Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCAE601438
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 19:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiJQRDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 13:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiJQRDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 13:03:44 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E43A6FA2B
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:03:41 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a10so19364474wrm.12
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfTCoR58idMg6WfKIzHQnE7Yg8ftI8rKIp7yG+lylFA=;
        b=QOAVf3HnzRDJZ5WcNKWFshzk1PdHzaqJyaLOWD4DRIo4pFE7sj1Fix2xyDxAopb1bh
         iTeKm6bFojgib2tI8ckv15E063Iu3yEuwkHQDy2MlibPZTjBDBfdO2KEUyGRECya1Y+l
         ZlpRvZDoDTou6x4kqxigIT3GW2700oAXIIJw853DRD+4GVIp9O82jJTpaMqnEnniHCx+
         h8NdckPMWchneTa/gDahzqW5R2wAoZGBqE7MxlWF2mDfk/q9FSZg0oYKA2baEpAd5Z7c
         KncoJpLpl5cDqHYOmeQxA8TXKyL4XDAZgKB3cawy0vFeNcdksmC7P63QPq1IQpoy3K71
         k2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FfTCoR58idMg6WfKIzHQnE7Yg8ftI8rKIp7yG+lylFA=;
        b=M/OyG5imbSQit6A/AZWM+JcVVwqxur3lvMTgTXsimjYb5XbrKBvU7y6ddUcoTlY/3t
         SQKlA+fi4naM8SGEg2Lu44DpdKmpOVucgqzUJq3SqCz5tHID/vqW2SgfVUfq8kI9TNzc
         UWkOGzev739yvaU1lgnwhLo5c4ecQvWkaLuS/aBIy1VN0FeeYvY9au9xZ0KSv3lkYZ6X
         rtbAAzAbisMpwNR4XCCqPpCBlnRuELHUCTnr2EYtEaUn1dP5iGycaOmxl1z9KMxgFlQU
         joMc8TiBPlslHfi83O3fxUu5wWP6qT9ANVekLQILGKuOex0QWhybutMKl46MH6aVX4BS
         zX7A==
X-Gm-Message-State: ACrzQf3y7qYa1ug3y09zawxkj0jeTioiWh74nZa3tXc43qJ4VNWxchsP
        SexbO6ocz1btmsDQ54mY0g9w3A==
X-Google-Smtp-Source: AMsMyM7eAVFS47f4lwYbIcRY/fcxie+kMlY4llt3ZmEhSf6Cij4YkU0OPffxDrpBiSPQ7EGrUYisjQ==
X-Received: by 2002:a5d:6e82:0:b0:22f:a27c:c964 with SMTP id k2-20020a5d6e82000000b0022fa27cc964mr6902053wrz.699.1666026219274;
        Mon, 17 Oct 2022 10:03:39 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id w16-20020adf8bd0000000b0022f40a2d06esm9079196wra.35.2022.10.17.10.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 10:03:38 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH iproute2 1/4] ss: man: add missing entries for MPTCP
Date:   Mon, 17 Oct 2022 19:03:05 +0200
Message-Id: <20221017170308.1280537-2-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221017170308.1280537-1-matthieu.baerts@tessares.net>
References: <20221017170308.1280537-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'ss -h' was mentioning MPTCP but not the man page.

While at it, also add the missing '.' at the end of the list, before the
new sentence.

Fixes: 9c3be2c0 ("ss: mptcp: add msk diag interface support")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 man/man8/ss.8 | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 12cb91b9..6489aa79 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -385,6 +385,9 @@ Display vsock sockets (alias for -f vsock).
 .B \-\-xdp
 Display XDP sockets (alias for -f xdp).
 .TP
+.B \-M, \-\-mptcp
+Display MPTCP sockets.
+.TP
 .B \-\-inet-sockopt
 Display inet socket options.
 .TP
@@ -396,7 +399,7 @@ supported: unix, inet, inet6, link, netlink, vsock, xdp.
 List of socket tables to dump, separated by commas. The following identifiers
 are understood: all, inet, tcp, udp, raw, unix, packet, netlink, unix_dgram,
 unix_stream, unix_seqpacket, packet_raw, packet_dgram, dccp, sctp,
-vsock_stream, vsock_dgram, xdp Any item in the list may optionally be
+vsock_stream, vsock_dgram, xdp, mptcp. Any item in the list may optionally be
 prefixed by an exclamation mark
 .RB ( ! )
 to exclude that socket table from being dumped.
-- 
2.37.2

