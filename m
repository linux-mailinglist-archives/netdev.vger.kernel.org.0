Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56A1816B18B
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbgBXVIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:08:17 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:39045 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbgBXVIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:08:14 -0500
Received: by mail-wr1-f43.google.com with SMTP id y17so3305015wrn.6
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 13:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q0ltq8yr54w4WYzWfLMscM8M4JgXlp34YJicpyse3M0=;
        b=Mz/NO3XVbdT++2QHQMo4DdbTnnKJe+kq3eNMMQty5v2yxOyeZux65s6p5+cw+mXf0h
         5XKXFdK9QVwMORZH5gSSArvH4beYrwcKEr9Mzfm8hlteOAAYy5iYfT1iqkJHQ1mHLFU2
         FPlRKh8Q2s1yalMJQzkGlWr7B5CtdwKb5CtOZPW6TTS7JHX37ryuUSUrq6EgX1FTcXuV
         oW7Xyqvt7ifrPtG0Q+O8z2Swv5T5ArOZfM6azMEtsqGyDK5L2VBPGaHOEMqRRxUqXDKV
         Mk4fixQDPAes4TBaVoPIRBp1Hl5/VUauBSwXHwjbDn6imDvLRgRaYI0bZDUP2BjwkzqB
         JEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q0ltq8yr54w4WYzWfLMscM8M4JgXlp34YJicpyse3M0=;
        b=LZe/E750SVXtsXEEGKESM0NOisbdwuTAawJTRKLbz7goBZV6cDLGpjxdz1E+TEHMdM
         lJv6dHkbnVh94hIMi61/iqXyhHXzdueDRMbVOVvO7NXiyPGy+RhrMtzxOSdVgR8ZsXJz
         OmvgDDjXjwPD3WK06MpKntFrf7MLCxXYdSiAPMg0eMvjFcmD9K74WF2vLrX3kpLULfA8
         /Aqp3VfMboSEluqOiVTVO+A1ZVaw64FMV1DdajNONkl9CiXZigf/XNdh+6WLBUWHkX4m
         GAFqGH3VSHTMEsv1GrJNLOZnsdV+3x+hlUXCA7e3QKLYLcUa4ryYNuTqSvNjsPiDTyij
         Gs4g==
X-Gm-Message-State: APjAAAVCjvxbf/oOY23dmur4+2P/ydIsU3JQTCbj/ajTJvoMfuSHuRjK
        OnlFjhWcTO58TrJCQNprt/70GeHZQdc=
X-Google-Smtp-Source: APXvYqzu+sf2mxrEsYDPWtMdxcIm4aRvStzKig+0AP8HHvfKbZZ+UZ4rMOjhbnmkQj74HHgJojusmQ==
X-Received: by 2002:adf:ff8d:: with SMTP id j13mr12032696wrr.112.1582578492874;
        Mon, 24 Feb 2020 13:08:12 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id l4sm2981991wrv.22.2020.02.24.13.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:08:12 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 10/10] selftests: netdevsim: Extend devlink trap test to include flow action cookie
Date:   Mon, 24 Feb 2020 22:07:58 +0100
Message-Id: <20200224210758.18481-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224210758.18481-1-jiri@resnulli.us>
References: <20200224210758.18481-1-jiri@resnulli.us>
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

