Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4542C4CFCEB
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 12:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbiCGLbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 06:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbiCGLbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 06:31:46 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20613E0E3
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 03:23:15 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id p9so22674567wra.12
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 03:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ELMf6ZeJINTJV3po4MpOruvF6GjhpvhBYQF6UO2QeYM=;
        b=OYrIcdKL/UHPuKUHzU/18wYvMrAtT6AeihrZFvNCiBJkjznB0B9/OSaN6CxFVBsGWc
         JpD/7LHHSkRTt5cEt9eUliIS/Ca/OOpWr1ev3w5XEb16wIJ+UO2i9j738wo6e3xWHX+3
         edV5mEnGTtTBV7eFgXuOgEL/FwyzukRuM/wMCJ+QLDzrRVZHZN7khk85OTXmn7DE5Kk1
         Fb2qWXE2RAU95UxJmDmoILSMkRnIi6y2vuyd93OE5Y5icR31NJap/D8TU0wmrn2ek1k6
         5+jVP1m+0dsEduMuD2Dgy6ilXRGtv1DmRIMFFQUiDSJEpwPcB5qXXsLLhBrr+BSTKyhC
         BPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ELMf6ZeJINTJV3po4MpOruvF6GjhpvhBYQF6UO2QeYM=;
        b=2EvbiVZ/Y6ViiuZpFSex+I8sTmreTiuXYrkQXaJVRG1acQh56i869qQ+UQn4aF8N+f
         BVuLlFFoMCvV4Uie59Wc9F4zdesGRHBnQjqxh/mVqW+xGM/xrhDqb6wBQMyt2ZTOHkRr
         uV7fogGIzTGVmhQvZPWP5uMRaw4fOcYg1hhHVDT2/l2c4evP/VIoiLRC4mvSMtUfh8vO
         Gq8fccoFnF8vBrmjV8aOc2rpTu/ubxrFXoFVMiewSAuoppCYy4ekBKoRR8b8wL9NfAED
         XMhL/5VcCHBhjETIyuQ5S0LGVS9ob7ml3ifyPFYy9Bvsk25HgJkrVk36XvYDpSfRS1Ol
         pjIQ==
X-Gm-Message-State: AOAM531KpJ/jdMF5alOAJOHao7u9L+K5G02UGgrafZYYAsIigyultIga
        srOaFV3Ah6k3Kxk+fQL5fJh0R0vifmU=
X-Google-Smtp-Source: ABdhPJxcWezyvsqFDBHpSwrnFMyHpa7U5+2T9dGVvSd4G+rbB0zChBFXON0hNKILbdbCRwmLnbyu8Q==
X-Received: by 2002:a05:6000:124b:b0:1f0:4819:fd44 with SMTP id j11-20020a056000124b00b001f04819fd44mr8509072wrx.101.1646652193947;
        Mon, 07 Mar 2022 03:23:13 -0800 (PST)
Received: from mde-claranet.. (2a01cb00891a2500bf034605a4dd6496.ipv6.abo.wanadoo.fr. [2a01:cb00:891a:2500:bf03:4605:a4dd:6496])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c511000b0038141b4a4edsm21926140wms.38.2022.03.07.03.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 03:23:13 -0800 (PST)
From:   Maxime de Roucy <maxime.deroucy@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Maxime de Roucy <maxime.deroucy@gmail.com>
Subject: [PATCH] ipaddress: remove 'label' compatibility with Linux-2.0 net aliases
Date:   Mon,  7 Mar 2022 12:23:00 +0100
Message-Id: <20220307112300.27406-1-maxime.deroucy@gmail.com>
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

