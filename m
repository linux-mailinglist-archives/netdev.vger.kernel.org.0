Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CCB4CFD08
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 12:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238919AbiCGLew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 06:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241980AbiCGLeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 06:34:04 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E1490
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 03:33:00 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id i8so22708142wrr.8
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 03:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ELMf6ZeJINTJV3po4MpOruvF6GjhpvhBYQF6UO2QeYM=;
        b=FtVar4+s/rOr3qIl+YoKPydLJdwNbqUdmgH9n5WvnmZEi2/ym3r5uF2KROlzLEZffq
         /WfXOguDLwVYh0/zp+KBkFEylv+zSxdRFn2Dwda7I6L0P30zcuPn16xS2OkP1B139rhD
         HNmgm25TSpvsmH3D/TZcQQctiO4t7Q3AEsQozdTP/egM6IeZc7mLHuFsDU0Jq+Nnau48
         2ozR0YZOUGNFUavoMO7oAElhSVnhgv7XKsS/K1dWFv5DF+FoinDEY4GbH/trIzGA+mVJ
         4Y3HRjlolrj6qCUv2JlaNdPgpztPNDvEepVPpEGW919/pQMSkWXZTAJHmt0aHSrJtoJ4
         Z9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ELMf6ZeJINTJV3po4MpOruvF6GjhpvhBYQF6UO2QeYM=;
        b=TySnVOfMfGE1ujXJAPYnRuHpF9Zt2ujCO1hGhc//UcE9Yr62iGo2Qkf7OWyEfJGTs8
         6hrchSopCfb38RRTY4FyCiySPbSIIm6d5bus95Ji/8GQhI4ZN7vpJRb7yXZkbph/2iWE
         WC/8jE784IZQR2dHzEZsBgOjlEIA5o5dXvzPi0iZSObPoA9ZICu2hmv5Oj/4Jha9au8x
         ZvaTLDkVZAvAsCnQMQC634JkF2A8lBlLh7NrmO5j7HKJXAcBUgLKxrasJ2ZoS8afob8E
         TkfkUG22PAnmtV+h9gAW2z2zsLnZ5J4grkcNLDd4frAt7SuS39a6EBVUt7ByagOXUuIM
         Q0Mg==
X-Gm-Message-State: AOAM533fiDnggRKwvCAwBnO8ohHdPVt59Y1H3FHVHM2NxvZDSmWYG4NY
        td3Pze/DB0zV62QZqbgtS+/ksCcjxZ8=
X-Google-Smtp-Source: ABdhPJyVj5l3YiPZxlIgbrgRNiXPXoBXI/cD7sfbW2Om7BIIV31cY/L1uE9xBs4iLml+El10d4eFwg==
X-Received: by 2002:a05:6000:1864:b0:1ef:d2b0:560a with SMTP id d4-20020a056000186400b001efd2b0560amr8098169wri.38.1646652778517;
        Mon, 07 Mar 2022 03:32:58 -0800 (PST)
Received: from mde-claranet.. (2a01cb00891a2500bf034605a4dd6496.ipv6.abo.wanadoo.fr. [2a01:cb00:891a:2500:bf03:4605:a4dd:6496])
        by smtp.gmail.com with ESMTPSA id o7-20020a5d6707000000b001f067c7b47fsm15823746wru.27.2022.03.07.03.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 03:32:58 -0800 (PST)
From:   Maxime de Roucy <maxime.deroucy@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Maxime de Roucy <maxime.deroucy@gmail.com>
Subject: [PATCH v2] ipaddress: remove 'label' compatibility with Linux-2.0 net aliases
Date:   Mon,  7 Mar 2022 12:32:45 +0100
Message-Id: <20220307113245.28474-1-maxime.deroucy@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304142441.342f3156@hermes.local>
References: <20220304142441.342f3156@hermes.local>
MIME-Version: 1.0
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

As Linux-2.0 is getting old and systemd allows non Linux-2.0 compatible
aliases to be set, I think iproute2 should be able to manage such
aliases.

Signed-off-by: Maxime de Roucy <maxime.deroucy@gmail.com>
---
 ip/ipaddress.c           | 16 ----------------
 man/man8/ip-address.8.in |  3 ---
 2 files changed, 19 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 739b0b9c..a80996ef 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -2349,16 +2349,6 @@ static bool ipaddr_is_multicast(inet_prefix *a)
 		return false;
 }
 
-static bool is_valid_label(const char *dev, const char *label)
-{
-	size_t len = strlen(dev);
-
-	if (strncmp(label, dev, len) != 0)
-		return false;
-
-	return label[len] == '\0' || label[len] == ':';
-}
-
 static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 {
 	struct {
@@ -2501,12 +2491,6 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 		fprintf(stderr, "Not enough information: \"dev\" argument is required.\n");
 		return -1;
 	}
-	if (l && !is_valid_label(d, l)) {
-		fprintf(stderr,
-			"\"label\" (%s) must match \"dev\" (%s) or be prefixed by \"dev\" with a colon.\n",
-			l, d);
-		return -1;
-	}
 
 	if (peer_len == 0 && local_len) {
 		if (cmd == RTM_DELADDR && lcl.family == AF_INET && !(lcl.flags & PREFIXLEN_SPECIFIED)) {
diff --git a/man/man8/ip-address.8.in b/man/man8/ip-address.8.in
index a614ac64..1846252d 100644
--- a/man/man8/ip-address.8.in
+++ b/man/man8/ip-address.8.in
@@ -195,9 +195,6 @@ is derived by setting/resetting the host bits of the interface prefix.
 .TP
 .BI label " LABEL"
 Each address may be tagged with a label string.
-In order to preserve compatibility with Linux-2.0 net aliases,
-this string must coincide with the name of the device or must be prefixed
-with the device name followed by colon.
 The maximum allowed total length of label is 15 characters.
 
 .TP
-- 
2.35.1

