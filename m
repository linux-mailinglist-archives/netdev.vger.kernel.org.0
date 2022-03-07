Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAAD4CFD31
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 12:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237894AbiCGLmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 06:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbiCGLmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 06:42:12 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDF14E39D
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 03:41:18 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id t11so22790583wrm.5
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 03:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lyr+fzkQVlU4ZfslkGFdfgTGFSAT0Wt/tcgfgdSeDQw=;
        b=XpW8hyKM0XwPyFRKchmsR46J3e54aaLEQIU7Ac6q4pwhP3mheM5M0Kj7hfvBdMO2DB
         HJXmiobBNEYajH2oWjE59y53TLZFxGR5t5vJ6SxDi6qjkZEY6HaCWlKrPouBTlDhLv8S
         4esbrEX0+RElxRzfcvBChfnHbEAvdaRPRGPNrVi/L3GkSx7yMehDmVwEa4OWLOckpvuR
         6FhXe3DftVZBeVX6t/f13rwoqYO+yFMi0GckPWQzJzJpthvISo9fvMkqxBeUst07RPPW
         TnjrqnxfLflXJ2f2am/79XOmTB9sb0k00dl2zxxamlO7Aec8Jd21pLxe9sn4PQfy4wlr
         WbIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lyr+fzkQVlU4ZfslkGFdfgTGFSAT0Wt/tcgfgdSeDQw=;
        b=oJQU3difteGTMa1nWlKJD0rdL/rZc2Yu1b01XLaZ1pynqaAj53FEQkMh9NxWXf1Gh1
         c6rPQeaRTm7yWQGZ7hd3rKCeRAod+pspooYom1n7MMwLwf6xPUtTql4HgRuXrhTxZEW6
         JthIDnUEBr57yXVT5PFkznPkGl2berlTYLnAkjyV+5ug+AcScFPXpspdKKBo9rVz+meX
         2eD1i4f9hb5QeWPPRpbx0jrOsUrENT/L0y2k2s4ONluU/TwnoG/kYZrwjqkneIh128ic
         J6u+7E2Ardaa75gzCYtlPco/6ffdtVrwaXVBqRRzC76lWuoSuOA3wtrYanKit28wA/1p
         O/vg==
X-Gm-Message-State: AOAM530vGO1x/e/8wPN6S6hBLCo5Emgy22Jj9eGLeryttJKeWHn5Nl7R
        2WKq/NbnI6JdaTXKMDosTNCIhzTzlFk=
X-Google-Smtp-Source: ABdhPJwBtMNsmhwDZ0bAuASZxzZ3pPqr8n29GAGvVgaoOCMhc3yYwyJD8N59GYc9acDmRYX+gH5nqw==
X-Received: by 2002:a5d:5887:0:b0:1f1:fae9:a95e with SMTP id n7-20020a5d5887000000b001f1fae9a95emr2040874wrf.340.1646653276112;
        Mon, 07 Mar 2022 03:41:16 -0800 (PST)
Received: from mde-claranet.. (2a01cb00891a2500bf034605a4dd6496.ipv6.abo.wanadoo.fr. [2a01:cb00:891a:2500:bf03:4605:a4dd:6496])
        by smtp.gmail.com with ESMTPSA id n7-20020a05600c3b8700b00389a6241669sm2288165wms.33.2022.03.07.03.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 03:41:15 -0800 (PST)
From:   Maxime de Roucy <maxime.deroucy@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Maxime de Roucy <maxime.deroucy@gmail.com>
Subject: [PATCH v2] ipaddress: remove 'label' compatibility with Linux-2.0 net aliases
Date:   Mon,  7 Mar 2022 12:40:57 +0100
Message-Id: <20220307114057.28650-1-maxime.deroucy@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Sorry, I am not familiar with the contribution through mail mecanism and the `git send-email` command.

I tried to resubmit my patch in reply to
https://patchwork.kernel.org/project/netdevbpf/patch/f0215a333fd80102cfab9c560fc2872e8eddb079.camel@gmail.com/#24766590
but I don't see my message appearing in the mailing list archive… so I
tried multiple `git send-email` argument combination. You might have
receive this mail multiple times.

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

