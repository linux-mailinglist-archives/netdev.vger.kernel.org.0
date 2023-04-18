Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1405C6E68B4
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 17:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbjDRPxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 11:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbjDRPx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 11:53:29 -0400
Received: from mail-ej1-x661.google.com (mail-ej1-x661.google.com [IPv6:2a00:1450:4864:20::661])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E223125B6
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 08:53:06 -0700 (PDT)
Received: by mail-ej1-x661.google.com with SMTP id c9so35586066ejz.1
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 08:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1681833184; x=1684425184;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dtKRb0VmWQ+eqkEDmwsx8CKGqgagGohDrg67yIFHRho=;
        b=jxQncYBpCqnxLufcINss5ZuDWQnvg7DW2jX5BFbQFDTwFke8WbR2plER529bG3KW8f
         WkmbxrlwpEdzw23J07hlmU8g2JP1B3SIjeUDyrV2C47kNOY2h5len+J6OSCpx58YkLqn
         sqPh3UhEmuavS5ntjeh7RkOCVfeVNG+lynBdFcuqMPDKle2Y9rgfzz+7EWGfzZK691IM
         HcM3SCNWoxAOd+t8iizhLrDjjlKX4QaCDBXd59HjmtqU6+3PrV+e4zwa5HZwK5iNyKR7
         HigsLGyeYCM9agJyG2cThAB+Z0ZpvgqUOCsc0KpbmM9VsFjRb1m7V5T891+I9CpQEJi9
         Cz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681833184; x=1684425184;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dtKRb0VmWQ+eqkEDmwsx8CKGqgagGohDrg67yIFHRho=;
        b=jgaVVXZm22M3+ITJIfVbaTaUhdWEUIRvw4auhIXJbUPMHeDN7E/D9FNe2mUuT6IIlF
         4AWt5ieAN9SDpWNje23PvTRcvHx00MYjCDmtKO4Lop6f2/jXfYnyGHm/ihC4iICH2ma8
         tzQCEzjE+4ShGxK/K/1KeTTgsb1UaBsB9mZZSWiPaS1bkt5hKHl44QidHkPXR9Dcv1D+
         wUqgXHl5UM5Sr3J/OoFpAkQThIhAwaEwT0/KfIK6xr9lZj/29RF/r4f2vz+4Ovk6HZ8D
         sXnbCVRX18iNd500c11N3gd5R9o3+b2XvbZ1eDkRRmTfpn7sOIcXYvLejO6s12WP27PL
         7//Q==
X-Gm-Message-State: AAQBX9f3Es+ai0wGXe0SrNHA5NeNx7nuwebQ7VpV+mLoAUwKSF6z3YvJ
        0iy8iSZBFP8A7ONWtA6Dcnhv83WpOqOhqm+xoAJbV2LhLvR3cg==
X-Google-Smtp-Source: AKy350bWMhGHFN7nqi6ENao2UHekNkedlUj68Jv3RGFH/RnOkofetsuypqu54Fol+96TcaqhaOPxXx+4pZt6
X-Received: by 2002:a17:907:9713:b0:94f:2852:1d2b with SMTP id jg19-20020a170907971300b0094f28521d2bmr10802981ejc.72.1681833184312;
        Tue, 18 Apr 2023 08:53:04 -0700 (PDT)
Received: from smtpservice.6wind.com ([185.13.181.2])
        by smtp-relay.gmail.com with ESMTP id xh8-20020a170906da8800b0094f260d4a05sm2609256ejb.101.2023.04.18.08.53.04;
        Tue, 18 Apr 2023 08:53:04 -0700 (PDT)
X-Relaying-Domain: 6wind.com
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 143C9600F0;
        Tue, 18 Apr 2023 17:53:04 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1pondf-0000LB-Vu; Tue, 18 Apr 2023 17:53:03 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2] iplink: fix help of 'netns' arg
Date:   Tue, 18 Apr 2023 17:52:57 +0200
Message-Id: <20230418155257.1302-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'ip link set foo netns /proc/1/ns/net' is a valid command.
Let's update the doc accordingly.

Fixes: 0dc34c7713bb ("iproute2: Add processless network namespace support")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 ip/iplink.c           | 4 ++--
 man/man8/ip-link.8.in | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index a8da52f9f7ca..f7db17a9869d 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -63,7 +63,7 @@ void iplink_usage(void)
 			"		    [ mtu MTU ] [index IDX ]\n"
 			"		    [ numtxqueues QUEUE_COUNT ]\n"
 			"		    [ numrxqueues QUEUE_COUNT ]\n"
-			"		    [ netns { PID | NAME } ]\n"
+			"		    [ netns { PID | NAME | NETNS_FILE } ]\n"
 			"		    type TYPE [ ARGS ]\n"
 			"\n"
 			"	ip link delete { DEVICE | dev DEVICE | group DEVGROUP } type TYPE [ ARGS ]\n"
@@ -88,7 +88,7 @@ void iplink_usage(void)
 		"		[ address LLADDR ]\n"
 		"		[ broadcast LLADDR ]\n"
 		"		[ mtu MTU ]\n"
-		"		[ netns { PID | NAME } ]\n"
+		"		[ netns { PID | NAME | NETNS_FILE } ]\n"
 		"		[ link-netns NAME | link-netnsid ID ]\n"
 		"		[ alias NAME ]\n"
 		"		[ vf NUM [ mac LLADDR ]\n"
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index c8c656579364..5b8ddbf20359 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -49,7 +49,7 @@ ip-link \- network device configuration
 .IR BYTES " ]"
 .br
 .RB "[ " netns " {"
-.IR PID " | " NETNSNAME " } ]"
+.IR PID " | " NETNSNAME " | " NETNS_FILE " } ]"
 .br
 .BI type " TYPE"
 .RI "[ " ARGS " ]"
@@ -118,7 +118,7 @@ ip-link \- network device configuration
 .IR MTU " ]"
 .br
 .RB "[ " netns " {"
-.IR PID " | " NETNSNAME " } ]"
+.IR PID " | " NETNSNAME " | " NETNS_FILE " } ]"
 .br
 .RB "[ " link-netnsid
 .IR ID " ]"
-- 
2.39.2

