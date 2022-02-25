Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6044C43D6
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240241AbiBYLqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240232AbiBYLqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:46:51 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1791E4827;
        Fri, 25 Feb 2022 03:46:19 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id p20so7103157ljo.0;
        Fri, 25 Feb 2022 03:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=xXj2/f+qvoC8XO/wzynFMId5J1aWTkWLoQHGmpvRGhE=;
        b=hmM+xtnQ1cHBDLM3D5uqmEKqhbv/H1Y4SldYiitjnQmqXgvL0OQuoAMytslMeHutSC
         NdSfwDvD+PIpJh7G+HuiLmSJxeDiRcmpmOZbWdhjnIAjKN06KDaZoYi0E8nydRiDguZw
         bQImBqHnaJB1l6WoBkBxYzdiJGiQMu1UZeYw8N/PRpaFSfK6JtDAJkoLvkyIPxJilIgW
         qaCBgCM3Lt7qPfns+UQvxtSNLSzBMmpIC75vp9lwEnP3kOMbq7aCuOY8tnDDXW1bs7Vo
         hAnKmeJg/kFw14nyxA+rZF6wpvIGAd01j4J2ApGbJMSg230Z+yjRAmoAAQ6ddAMnKx20
         sZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=xXj2/f+qvoC8XO/wzynFMId5J1aWTkWLoQHGmpvRGhE=;
        b=rr9+sHbjP58saHW1gRAQZ/BR2hKvhtoVToKn70XNqdjVRvS3pf9lYHHn4cZkfbWaus
         YZkUWagXQj6tGRTYB4GsAkbzUxSG8AWjiKw4ESFvuaSn/3Y74N+rWDwchwdyZ/RAcOY2
         qHMKXb7LWU2lNHKnnHkw7CCVtopPXbr5y5L+9Pfyru2LAV8QB6W0zK06r4jwPISU/trV
         19m4POBeSDeicImidrAdt7MxsPL59Rml367EYwxiO+sW63QL/DQVPKejYgMBtKqDdOcX
         TYQ7GvFkV2MZKGyb3mFYD2bRuhdR6hVf9ut31BLc3gouURRnsXgWu86rTCdFggak6hLM
         a4Rw==
X-Gm-Message-State: AOAM531zAehytA/x4J4T5h8Wx8FC1EXksn7IdhG/awoLpJBa3p1MY7XQ
        yznA9/Vhn0r50rQ5EPxVJVo=
X-Google-Smtp-Source: ABdhPJxQIhriQeTviQnzV2RibNwzzp851tEln7cRsRGIQkuUZwTDushz+trV0NXeHv55KNbKlj+Iyw==
X-Received: by 2002:a05:651c:202:b0:244:c45d:102 with SMTP id y2-20020a05651c020200b00244c45d0102mr5009751ljn.29.1645789577595;
        Fri, 25 Feb 2022 03:46:17 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id g7-20020a19e047000000b0044395c894d2sm184177lfj.163.2022.02.25.03.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 03:46:17 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH iproute2-next 1/1] bridge: link: Add command to set port in locked mode
Date:   Fri, 25 Feb 2022 12:44:57 +0100
Message-Id: <20220225114457.2386149-2-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225114457.2386149-1-schultz.hans+netdev@gmail.com>
References: <20220225114457.2386149-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for setting a bridge port in locked mode to use with 802.1X,
so that only authorized clients are allowed access through the port.

Syntax: bridge link set dev DEV locked {on, off}

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 bridge/link.c                | 13 +++++++++++++
 include/uapi/linux/if_link.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/bridge/link.c b/bridge/link.c
index 205a2fe7..bb4f0b2d 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -175,6 +175,9 @@ static void print_protinfo(FILE *fp, struct rtattr *attr)
 		if (prtb[IFLA_BRPORT_ISOLATED])
 			print_on_off(PRINT_ANY, "isolated", "isolated %s ",
 				     rta_getattr_u8(prtb[IFLA_BRPORT_ISOLATED]));
+		if (prtb[IFLA_BRPORT_LOCKED])
+			print_on_off(PRINT_ANY, "locked", "locked %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_LOCKED]));
 	} else
 		print_stp_state(rta_getattr_u8(attr));
 }
@@ -275,6 +278,7 @@ static void usage(void)
 		"                               [ neigh_suppress {on | off} ]\n"
 		"                               [ vlan_tunnel {on | off} ]\n"
 		"                               [ isolated {on | off} ]\n"
+		"                               [ locked {on | off} ]\n"
 		"                               [ hwmode {vepa | veb} ]\n"
 		"                               [ backup_port DEVICE ] [ nobackup_port ]\n"
 		"                               [ self ] [ master ]\n"
@@ -303,6 +307,7 @@ static int brlink_modify(int argc, char **argv)
 	__s8 vlan_tunnel = -1;
 	__s8 mcast_flood = -1;
 	__s8 mcast_to_unicast = -1;
+	__s8 locked = -1;
 	__s8 isolated = -1;
 	__s8 hairpin = -1;
 	__s8 bpdu_guard = -1;
@@ -415,6 +420,11 @@ static int brlink_modify(int argc, char **argv)
 			isolated = parse_on_off("isolated", *argv, &ret);
 			if (ret)
 				return ret;
+		} else if (strcmp(*argv, "locked") == 0) {
+			NEXT_ARG();
+			locked = parse_on_off("locked", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "backup_port") == 0) {
 			NEXT_ARG();
 			backup_port_idx = ll_name_to_index(*argv);
@@ -489,6 +499,9 @@ static int brlink_modify(int argc, char **argv)
 	if (isolated != -1)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_ISOLATED, isolated);
 
+	if (locked >= 0)
+		addattr8(&req.n, sizeof(req), IFLA_BRPORT_LOCKED, locked);
+
 	if (backup_port_idx != -1)
 		addattr32(&req.n, sizeof(req), IFLA_BRPORT_BACKUP_PORT,
 			  backup_port_idx);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 1d4ed60b..637623bb 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -534,6 +534,7 @@ enum {
 	IFLA_BRPORT_MRP_IN_OPEN,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
+	IFLA_BRPORT_LOCKED,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
-- 
2.30.2

