Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBEB4CC8A3
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 23:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiCCWPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 17:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiCCWPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 17:15:49 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1D13E5C9
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 14:15:02 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 19so3710762wmy.3
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 14:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=IIllnCsaVp8MwA2t4DFpg4FElAODradi88NbcLSWORI=;
        b=hFjIJJLTfPik4LuuaoVGEk3EjjPvDXI4L0ibuVxGYOOtbAJz5kheOhegi44+lJQbfs
         HFLarJal2AE3SQ0IxEzgP4JNnNUH0zpWqIiOrBTlNKPcOZXNcXEp6JNYQBPNE6zOfTBc
         66F429PDdrTV1S+xUg/if7zEeM0rKyPVtf7pIHWhj8suMJwAeLJy/IGG6JloSTY6iFvu
         xd7O+SFfaD5Wlp7RvuFCKlNFC4xrZW+ecjcAvjtvTSkJC+sOC9j3I5HBMf9ZgRKlDqkZ
         R87qSFwyckYYz/caQ0Cex2uEBiom/iM0WyQkQNOXvVU2hZ7GuzZZFrAWGbZcigu4QvUn
         CgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=IIllnCsaVp8MwA2t4DFpg4FElAODradi88NbcLSWORI=;
        b=JyTpZTi01RE5i1gM+/x5U08zGESiDLz62vWOxC2qPUG5VLtjtcZddKf9iWJM1AGsYi
         THi5qC+cfqGMj/ujkgfkvW8Y7huNspJ+EbKNvjJsHjIOr6NyClV26rVjwZBx/sIdBCJO
         bhOk3A26bG5HGU/iTT+v2JTWFLz1Ov+zedKV7gHcEgjLFu8R91Qa0Jm6wVhQ3yI+IIYt
         +JL9RHNgAgnx5DdKZn4FwpDDs0B+CUZfYzjxrIZ7iMp8ApE/SHUjSaeqrXmTPgcjWkO5
         2HG0D6liSzs/W2IWXy+IoIOmKY/H93hhZSXdOJ8zO4LCi0D2HMkPQZXGjsb8Gn0Vju7n
         Noqg==
X-Gm-Message-State: AOAM533duZDmcOJNTqzVHU1sBhkpSQ5m1wzAXdgERDK4Ce4FAUklIZKX
        UepB/korMPgZiGPispd8W+1/OBNTQgU=
X-Google-Smtp-Source: ABdhPJwTwg1V27Y8VpwIE88wS80XhUkqhGe9QUKopvMLpoJwK2QCSzoaVa3TbiaX/J2JZGUt0HQsHA==
X-Received: by 2002:a7b:c2fa:0:b0:381:6403:b44c with SMTP id e26-20020a7bc2fa000000b003816403b44cmr5373369wmk.92.1646345700896;
        Thu, 03 Mar 2022 14:15:00 -0800 (PST)
Received: from 2a01cb00891a2500bf034605a4dd6496.ipv6.abo.wanadoo.fr (2a01cb00891a2500bf034605a4dd6496.ipv6.abo.wanadoo.fr. [2a01:cb00:891a:2500:bf03:4605:a4dd:6496])
        by smtp.gmail.com with ESMTPSA id i15-20020a05600c354f00b00381753c67a8sm3189494wmq.26.2022.03.03.14.14.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 14:15:00 -0800 (PST)
Message-ID: <f0215a333fd80102cfab9c560fc2872e8eddb079.camel@gmail.com>
Subject: [PATCH iproute2-next] ipaddress: remove 'label' compatibility with
 Linux-2.0 net aliases
From:   maxime.deroucy@gmail.com
To:     netdev@vger.kernel.org
Date:   Thu, 03 Mar 2022 23:14:55 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
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
---
 ip/ipaddress.c           | 16 ----------------
 man/man8/ip-address.8.in |  3 ---
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
-       size_t len = strlen(dev);
-
-       if (strncmp(label, dev, len) != 0)
-               return false;
-
-       return label[len] == '\0' || label[len] == ':';
-}
-
 static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 {
        struct {
@@ -2501,12 +2491,6 @@ static int ipaddr_modify(int cmd, int flags, int
argc, char **argv)
                fprintf(stderr, "Not enough information: \"dev\"
argument is required.\n");
                return -1;
        }
-       if (l && !is_valid_label(d, l)) {
-               fprintf(stderr,
-                       "\"label\" (%s) must match \"dev\" (%s) or be
prefixed by \"dev\" with a colon.\n",
-                       l, d);
-               return -1;
-       }
 
        if (peer_len == 0 && local_len) {
                if (cmd == RTM_DELADDR && lcl.family == AF_INET &&
!(lcl.flags & PREFIXLEN_SPECIFIED)) {
diff --git a/man/man8/ip-address.8.in b/man/man8/ip-address.8.in
index a614ac64..1846252d 100644
--- a/man/man8/ip-address.8.in
+++ b/man/man8/ip-address.8.in
@@ -195,9 +195,6 @@ is derived by setting/resetting the host bits of
the interface prefix.
 .TP
 .BI label " LABEL"
 Each address may be tagged with a label string.
-In order to preserve compatibility with Linux-2.0 net aliases,
-this string must coincide with the name of the device or must be
prefixed
-with the device name followed by colon.
 The maximum allowed total length of label is 15 characters.
 
 .TP

