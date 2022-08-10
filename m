Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4BF58EF9E
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiHJPvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiHJPvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:51:39 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF89F4BD19;
        Wed, 10 Aug 2022 08:51:37 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id h13so18244219wrf.6;
        Wed, 10 Aug 2022 08:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=eLUXa/7f03mrrlxRZvP1+mfNlm5ZK61/IOpf+UOnfpA=;
        b=WqSg1M4LPvRvE7ifojxAgf7wRBU1icJ6/c02Okmzy1I7MNcWnJciMvgd9E29H25H4Q
         hOSe7+Md7Co6t5MC+3/kIvdRVkg5NK+48WzlsJpoKmlT00h4hLNZDfBAFl5jNzjUkw2L
         tDwbjfZBV458pAPRzXjVRiCGwRDFyQTytaD+8YF9Tuc0TmbJm9yw+HSJc6BXCFKIzpEK
         D9d891nlEEq+OcCtS7778AT52Q5yAJ9ZCs40vzIlwX+6P3K1D46S8DHPJLWHUfGr37ct
         L8IZcVVnoD/jWZzALGwunGKNX3cSyxrT1U/+O4o866OfJT0bJ2tZvGB0V4x8e0v/HdlK
         ai3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=eLUXa/7f03mrrlxRZvP1+mfNlm5ZK61/IOpf+UOnfpA=;
        b=PDmlgHkjxhpRjysIgyU8FX7XTDV2pTtjJoJHk3fI/D9V4walimyaTK4CRsXt1W0Mal
         imDWnQgvAHB73P9kza5SuxWIxGp4WORg+9U4HXcIMtDu2swoMLkwBvdlAfPSupk0gnjx
         CAbZPMwO36XuvLFsAXj67RGFelK6gIlya9yWf8JJdvVPeEFp2j6PeC/ultZB69FpyKzp
         X+H/l3koCWTbPcWjQG7ZCB9KoZyFLk1MU644GP4RNJQfHRImD0JaCuwUhVhKnBH4DHAl
         UTqtfI5c0paVjICC50xQlUZgs+H3hEEGm3Kn++nw7Z+HFLVqVAh5GOdoCvZWYW7wst38
         wOVg==
X-Gm-Message-State: ACgBeo0J9DV2UUZR6tRSjf0dfJ37490P6A0Oa22uinFrbkZ8ch4trQCe
        DXfMtkqr/JRE4MUfJmD7zM8aIbFs7Ok=
X-Google-Smtp-Source: AA6agR5DJfVKYDlrSNLa3wNyuLPvwubsZF8VZQM6JU+GS2BugrOvjw9AFh0IiP8A3TZSNH/OEieLog==
X-Received: by 2002:a05:6000:785:b0:220:6d7f:dd1f with SMTP id bu5-20020a056000078500b002206d7fdd1fmr18016045wrb.578.1660146695975;
        Wed, 10 Aug 2022 08:51:35 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id ay1-20020a05600c1e0100b003a342933727sm3004519wmb.3.2022.08.10.08.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:51:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next io_uring 00/11] improve io_uring's ubuf_info refcounting
Date:   Wed, 10 Aug 2022 16:49:08 +0100
Message-Id: <cover.1660124059.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
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

There is a couple of tricks we can do with io_uring to improve ubuf_info
refcounting. First, we ammortise reference grabbing and then give them
away to the network layer, which is implemented in 8 and 11. Also, we
don't need need additional pinning for TCP, which is removed by 7.

1-4 are needed because otherwise we're out of space in io_notif_data and
using ->desc or some other field of ubuf_info would be ugly. It'll also
facilitate further ideas like adding a simpler notification model for UDP.

liburing/examples/io_uring-sendzc benchmark using a branch containing the
patchset and some more [1] showed ~1.6% qps improvement for UDP (dummy dev),
and ~1% for TCP (localhost + hacks enabling zc).

I didn't specifically test xen and vhost and not sure how, would love
some help with that.

[1] https://github.com/isilence/linux/tree/net/zc-ref-optimisation

Pavel Begunkov (11):
  net: introduce struct ubuf_info_msgzc
  xen/netback: use struct ubuf_info_msgzc
  vhost/net: use struct ubuf_info_msgzc
  net: shrink struct ubuf_info
  net: rename ubuf_info's flags
  net: add flags for controlling ubuf_info
  net/tcp: optimise tcp ubuf refcounting
  net: let callers provide ->msg_ubuf refs
  io_uring/notif: add helper for flushing refs
  io_uring/notif: mark notifs with UARGFL_CALLER_PINNED
  io_uring/notif: add ubuf_info ref caching

 drivers/net/xen-netback/common.h    |  2 +-
 drivers/net/xen-netback/interface.c |  4 +--
 drivers/net/xen-netback/netback.c   |  7 +++---
 drivers/vhost/net.c                 | 17 +++++++------
 include/linux/skbuff.h              | 35 +++++++++++++++++++++++---
 io_uring/net.c                      |  8 +++++-
 io_uring/notif.c                    | 21 ++++++++++------
 io_uring/notif.h                    | 22 +++++++++++++++-
 net/core/skbuff.c                   | 39 ++++++++++++++++-------------
 net/ipv4/ip_output.c                |  3 ++-
 net/ipv4/tcp.c                      | 11 +++++---
 net/ipv6/ip6_output.c               |  3 ++-
 12 files changed, 123 insertions(+), 49 deletions(-)

-- 
2.37.0

