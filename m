Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02571180257
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgCJPtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:49:16 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52198 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgCJPtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:49:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id a132so1964664wme.1
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y4dLtbGqQqfwaRE7kBPMrTHGmUSTv0rc8Bxu4V9sKq8=;
        b=gL2N8LO5/xaKH3o5wGHg6BasA14+m9F4TCxtBxML9CkY5GvJtXO4CTdVhxUv/SzHHp
         z+YLcHtHhbVvOCca5r5UobfAl1t2n9uI06yK6p9A8nDXugH6AS2A6z3SMbyaV2cwrI5s
         +fVmU/nwyifs+Hx6lYEH5vu/yxnv0iRJsP/jCjk19Tn/QTqYozg4K0H185iEfyt576st
         Y3o+9DbF/pm/Kg2AKz7HDD0jwSZ9JTmWvHVlYKmp/LSRvb9F5F9z8xh0S2Gjpl+hinzQ
         Jeemw0/fr+WNZ2joUbVY1aBB6DsUa44oJRPMQRjFt89pijkrPtwV+6ZFzXevfK3Z5Gad
         3vKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y4dLtbGqQqfwaRE7kBPMrTHGmUSTv0rc8Bxu4V9sKq8=;
        b=gzHNTDkDItPFaSB/aXPeph6+EXtFMGblVRgLFs5zCKXe6W0g3TMGI90+D8/gVGG1KF
         sYrMGiVSTdmDIoYiUzV3e/YU6ff2VTYzorqhMEqiSF7bhb/6yWqpy6Q82xBN+JJLNDkj
         9Jz9G+w6RRvjzseWcZf+pIXQK82KrV0KiXtkqz2wuHJ23BRNJ3+oqQkE6GLqhUjnXEFo
         jHD01vE++IrYFN3EVJYRSO5c6ykBhXwJB2NFpJRYwcbC5JYBmJqs3wDBLpk4apgVzbw2
         Vbzwb+OxW1JNXZQDz6fLmkW9bs4dOWuaqv8S0t+dj9ha4NFxTS+eHkzoY+QcQKg/DGoq
         ATQQ==
X-Gm-Message-State: ANhLgQ2W1JwolICku1R10fjqE2vzmw48A9MJaNWlIX0l1xmru/ymd39y
        JnwhthlgFdlZmsk2ZSWlD2utT+8TR/k=
X-Google-Smtp-Source: ADFU+vsT1Ujma9OBU2JGDM2FWIRFJo2zKLbwClkWVPEjDJa//hksfpuEm8BvyzR/ahbzhfjSMn3R9w==
X-Received: by 2002:a05:600c:2319:: with SMTP id 25mr2795897wmo.106.1583855353890;
        Tue, 10 Mar 2020 08:49:13 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b16sm64034027wrq.14.2020.03.10.08.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:49:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        pablo@netfilter.org, ecree@solarflare.com
Subject: [patch net-next 2/3] flow_offload: turn hw_stats_type into dedicated enum
Date:   Tue, 10 Mar 2020 16:49:08 +0100
Message-Id: <20200310154909.3970-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200310154909.3970-1-jiri@resnulli.us>
References: <20200310154909.3970-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Put the values into enum and add an enum to define the bits.

Suggested-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: Jiri Pirko <jiri@resnulli.us>
---
 include/net/flow_offload.h | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 2fda4178ba35..6849cb5d4883 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -155,11 +155,21 @@ enum flow_action_mangle_base {
 	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
 };
 
-#define FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE BIT(0)
-#define FLOW_ACTION_HW_STATS_TYPE_DELAYED BIT(1)
-#define FLOW_ACTION_HW_STATS_TYPE_ANY (FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE | \
-				       FLOW_ACTION_HW_STATS_TYPE_DELAYED)
-#define FLOW_ACTION_HW_STATS_TYPE_DISABLED 0
+enum flow_action_hw_stats_type_bit {
+	FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE_BIT,
+	FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT,
+};
+
+enum flow_action_hw_stats_type {
+	FLOW_ACTION_HW_STATS_TYPE_DISABLED = 0,
+	FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE =
+		BIT(FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE_BIT),
+	FLOW_ACTION_HW_STATS_TYPE_DELAYED =
+		BIT(FLOW_ACTION_HW_STATS_TYPE_DELAYED_BIT),
+	FLOW_ACTION_HW_STATS_TYPE_ANY =
+		FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE |
+		FLOW_ACTION_HW_STATS_TYPE_DELAYED,
+};
 
 typedef void (*action_destr)(void *priv);
 
@@ -175,7 +185,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
 
 struct flow_action_entry {
 	enum flow_action_id		id;
-	u8				hw_stats_type;
+	enum flow_action_hw_stats_type	hw_stats_type;
 	action_destr			destructor;
 	void				*destructor_priv;
 	union {
-- 
2.21.1

