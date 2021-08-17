Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DEF3EF0EC
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhHQR3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbhHQR3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 13:29:03 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10289C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:28:30 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso6405334pjh.5
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xkpSi38oXZami+XwnhE9QZye75VIwwT4zuGFKimZ9UQ=;
        b=WQONYWKd4ubtFSEQqseJqp+S0FcKXr+9DRiMqqkq7nlAqwJSA6OIkSOUeSXEBn/vej
         T6hV0ipZek2LFVTFd5au4d7D+VuHeLvidn20BkHmfBUH8Ro3fbLA/ua9j5HT7PLytRSL
         4asJgpSKwQMVnwR8Loig0ovqK9ZpVjQ2hZEx0fMJzpmrnjnGxHmSjKe89dws8eiA5P2u
         +sQKM7g26Gz+ou6qoohMWyH4lUPChE7Hy7UosU7rA5RO6D3xmNbPS7/fT99hsemEcn0P
         XYjDagQCTkxotiw6UJo7waPVaQiiNfzdcuXzOpfHk/U5mrFa5DKzEkAgmN07MRhN/Ht0
         KQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xkpSi38oXZami+XwnhE9QZye75VIwwT4zuGFKimZ9UQ=;
        b=EH2Ly69WAuMvPR2ZGYhgd/yCBm3xr9xlo6UD1kXDvsaifGHlkCmqwpqvzixBTCow8f
         Fz2KTokyT9thg8jZ4DPg9xIjuqmZqn6LvmP6wU5/a3LI5sG4Q23NCmmzu43E13PmWxA+
         WtDst+hE33Lz04RkW81OzjdX36iaReiMfBtmUim8u11PQbYLwawnpXAW/M0ivYMMjYRS
         In78Ye5ToqhOM5baAtpMpThmWfPfm9Dd92JfeAx8jE1R7ksZ+APETAYWamVSJDlID5iB
         KXw9AwQrCC4iFfnyJavJxRMSZ9YYfqrxJhJe6EfbShkVDj1ici/rTITZEevTc82x7Tsy
         ePPQ==
X-Gm-Message-State: AOAM533ltJMenyAQihV/E8kvA/n+YL22lOnumbQZiT2InP24IDIx6K/I
        fLw2bypA+e5RbJLrJOGgB29TW2GqeifvoJcQ
X-Google-Smtp-Source: ABdhPJy+HKRXwpaq1lwg7mPFIKXh9fsOuAOWOBUJSoFeGCRxM3wgINi3hhTz0GzMzUJnmlnhFEvrfQ==
X-Received: by 2002:a17:90a:1f44:: with SMTP id y4mr4724912pjy.51.1629221309415;
        Tue, 17 Aug 2021 10:28:29 -0700 (PDT)
Received: from lattitude.lan ([49.206.114.79])
        by smtp.googlemail.com with ESMTPSA id y5sm3872096pgs.27.2021.08.17.10.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 10:28:29 -0700 (PDT)
From:   Gokul Sivakumar <gokulkumar792@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Gokul Sivakumar <gokulkumar792@gmail.com>
Subject: [PATCH iproute2 v3 1/3] bridge: reorder cmd line arg parsing to let "-c" detected as "color" option
Date:   Tue, 17 Aug 2021 22:58:05 +0530
Message-Id: <20210817172807.3196427-2-gokulkumar792@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210817172807.3196427-1-gokulkumar792@gmail.com>
References: <20210817172807.3196427-1-gokulkumar792@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per the man/man8/bridge.8 page, the shorthand cmd line arg "-c" can be
used to colorize the bridge cmd output. But while parsing the args in while
loop, matches() detects "-c" as "-compressedvlans" instead of "-color", so
fix this by doing the check for "-color" option first before checking for
"-compressedvlans".

Signed-off-by: Gokul Sivakumar <gokulkumar792@gmail.com>
---
 bridge/bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/bridge/bridge.c b/bridge/bridge.c
index f7bfe0b5..48b0e7f8 100644
--- a/bridge/bridge.c
+++ b/bridge/bridge.c
@@ -149,9 +149,9 @@ main(int argc, char **argv)
 			NEXT_ARG();
 			if (netns_switch(argv[1]))
 				exit(-1);
+		} else if (matches_color(opt, &color)) {
 		} else if (matches(opt, "-compressvlans") == 0) {
 			++compress_vlans;
-		} else if (matches_color(opt, &color)) {
 		} else if (matches(opt, "-force") == 0) {
 			++force;
 		} else if (matches(opt, "-json") == 0) {
-- 
2.25.1

