Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4691B16BF0D
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730413AbgBYKpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:45:45 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:33405 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730399AbgBYKpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 05:45:44 -0500
Received: by mail-wr1-f43.google.com with SMTP id u6so14157998wrt.0
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 02:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q0ltq8yr54w4WYzWfLMscM8M4JgXlp34YJicpyse3M0=;
        b=keL0dAhGhvaFPmuecJoMkV8JuMudr7IYk1VLrIEJNpWhxiHnKD8bxQ7PR8y16Nqxo/
         a4JaIdR+f8OAioe/RupLBioi+ygk+i0wgEutahLg0xQLIJdx82BQuElqnbuNwrpItDeg
         gt2HbzBz8sPf23tdzc0QlX2GrEdX9Spru97GPbrOXIjOLnSaDrUtgEbwg2YDyFB/cxQi
         oZD2GxL4PsE2jTdHoqEeiAyS4tPPJ5mcBBCo3puOuz/5N4uGN1o1llXxcHjneHogA8+i
         2/MfNjhCSHNAP5ga331KfUxNDUM/EybEKH1gju9r7Go+iJRQHRl+MkeIqijNjWf3bH9v
         RidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q0ltq8yr54w4WYzWfLMscM8M4JgXlp34YJicpyse3M0=;
        b=MxFfUAS5ZbCXmLW8AT0o5FK5Ot5lbHeN6iPjv1qgS4iJgw0og7hLTHLvx8aJAiswMl
         N2kgTvIKUTFSzandqVcvjABZK6As8NKQZWYxWz1IC9UtRl/SAqVRaF9JnaahYRBuLNMU
         Fo7PjQileTUqyE37Flojp05dtet6JgjPfDxJYjafQfoimWCOsKuiq0e28HFQk3U/TI3k
         t+GSGL8ci/QCmsSqoeEHl/5NUcgTLkm0oQoElh8sftn2qN7Qtlhi12ZJ5iuZ1dCv+RCC
         XaK10lMagiuQsR5DadxTzW0WLXrs+Ce20fqyAvn/0++Fy7mx+J81xOl16nPmUMoZTrAy
         5wFg==
X-Gm-Message-State: APjAAAXjaAYQvZoZfnzrRC3o6Mt/M/X8N0/NFiDe8Z/FIxzBntW6a5Ox
        gXsOFZlmohQms9SfilGumz1cDQs08L8=
X-Google-Smtp-Source: APXvYqykPO8SSvSrcakRfYa9/nqbgWE/ArZdAWAJA+s45/VOReoTbuH+oEv5FXS+wq3GmUn/0D0lgQ==
X-Received: by 2002:adf:b60f:: with SMTP id f15mr75503806wre.372.1582627540880;
        Tue, 25 Feb 2020 02:45:40 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id n3sm6606334wrw.52.2020.02.25.02.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 02:45:40 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 10/10] selftests: netdevsim: Extend devlink trap test to include flow action cookie
Date:   Tue, 25 Feb 2020 11:45:27 +0100
Message-Id: <20200225104527.2849-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200225104527.2849-1-jiri@resnulli.us>
References: <20200225104527.2849-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Extend existing devlink trap test to include metadata type for flow
action cookie.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../testing/selftests/drivers/net/netdevsim/devlink_trap.sh  | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
index f101ab9441e2..437d32bd4cfd 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
@@ -103,6 +103,11 @@ trap_metadata_test()
 	for trap_name in $(devlink_traps_get); do
 		devlink_trap_metadata_test $trap_name "input_port"
 		check_err $? "Input port not reported as metadata of trap $trap_name"
+		if [ $trap_name == "ingress_flow_action_drop" ] ||
+		   [ $trap_name == "egress_flow_action_drop" ]; then
+			devlink_trap_metadata_test $trap_name "flow_action_cookie"
+			check_err $? "Flow action cookie not reported as metadata of trap $trap_name"
+		fi
 	done
 
 	log_test "Trap metadata"
-- 
2.21.1

