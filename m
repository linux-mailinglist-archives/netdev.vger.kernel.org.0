Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9B248181C
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 02:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbhL3BgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 20:36:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbhL3BgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 20:36:20 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19855C061574;
        Wed, 29 Dec 2021 17:36:20 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id l16so4994480plg.10;
        Wed, 29 Dec 2021 17:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WLTI0sBS8w+kDvTte81dO1nlEiA5fBFPyxOiq3CM9JU=;
        b=SNpuXfTzSE2QfrFMS34Bwy3nP+fB/Y2MmJHv2NoIDxYa0w0EtlJvLRQzvcv6GeowhZ
         xk5UxXLktv3ykpMy57IyPDX7NJ6tWYf2AJnYKOmCoTN+sZNsj02wqzPerZZymOhoLbpV
         PUmyB4uMan9R70O4N64nZiKwUn6L+G2RaVg+HnZajVfog4x1iByLk3/jIcPcWS2txnC2
         BCadIC2T4kICU4NYHjTBDYoW55xXpHAXf00ArlHKNfQZcc0rW41QUT1OcruyKB5JSkTN
         bHOeNDMCXQjwBeSGMqRo5xmD+Dtv0naKE+of9MDRItHz9hsEC1EiHeRCee5mRMbD0SS1
         QRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WLTI0sBS8w+kDvTte81dO1nlEiA5fBFPyxOiq3CM9JU=;
        b=oHv2UktvpILUAeB+SBAUuymGzquWlY61FrcuVwiBn+ReJ+XYVhEflskSYSAPL1akpP
         25rfg4u7lI3J6EGXgqGy7iqEvxajoKyrled+Rjin2LrdBJFSCmqg/VGlLa4RK3mXbI2u
         tHCHVl2Us5ZeNC9QWtTXnwd06Yg+pvjFRsRcjKiGbMba8SSo4D5pPSR0rybJOwQZH/Yb
         igsqJwthJJxnkfRSJc/DX+BRmKPsVFVBW3Wvt/mRxXBGRx0pMshl1MlefjxTJK/qaF1B
         qIgy++qG8ZRhjlH+O+tbTy93IXYGjwNIIg6sXU3H6tGih+PzOfkAEg8FKiClIx6PXRvr
         t5ig==
X-Gm-Message-State: AOAM533vsztxkxFpdpXqeJJV7RUnshjb6tJ1dU14LStRNUKQQwbQQoOe
        G4kRyXekk2ZwgL8jIl1I7Xc=
X-Google-Smtp-Source: ABdhPJzswsCmG4avG3BdMlCSLARdonyve+eglSShayD8PYdzRnkoDVPkZMtsKz5C7iDhCEq8IQhKIg==
X-Received: by 2002:a17:902:e80a:b0:149:14aa:a1a5 with SMTP id u10-20020a170902e80a00b0014914aaa1a5mr29025783plg.29.1640828179545;
        Wed, 29 Dec 2021 17:36:19 -0800 (PST)
Received: from integral2.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id v8sm19616795pfu.68.2021.12.29.17.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 17:36:19 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [RFC PATCH v1 0/3] io_uring: Add sendto(2) and recvfrom(2) support
Date:   Thu, 30 Dec 2021 08:35:40 +0700
Message-Id: <20211230013154.102910-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This RFC patchset adds sendto(2) and recvfrom(2) support for io_uring.
It also addresses an issue in the liburing GitHub repository [1].


## Motivations:
1) By using `sendto()` and `recvfrom()` we can make the submission
   simpler compared to always using `sendmsg()` and `recvmsg()` from
   the userspace.

2) There is a historical patch that tried to add the same
   functionality, but did not end up being applied. [2]

On Tue, 7 Jul 2020 12:29:18 -0600, Jens Axboe <axboe@kernel.dk> wrote:
> In a private conversation with the author, a good point was brought
> up that the sendto/recvfrom do not require an allocation of an async
> context, if we need to defer or go async with the request. I think
> that's a major win, to be honest. There are other benefits as well
> (like shorter path), but to me, the async less part is nice and will
> reduce overhead


## Changes summary
There are 3 patches in this series.

PATCH 1/3 renames io_recv to io_recvfrom and io_send to io_sendto.
Note that

    send(sockfd, buf, len, flags);

  is equivalent to

    sendto(sockfd, buf, len, flags, NULL, 0);

and
    recv(sockfd, buf, len, flags);

  is equivalent to

    recvfrom(sockfd, buf, len, flags, NULL, NULL);

So it is saner to have `send` and `recv` directed to `sendto` and
`recvfrom` instead of the opposite with respect to the name.


PATCH 2/3 makes `move_addr_to_user()` be a non static function. This
function lives in net/socket.c, we need to call this from io_uring
to add `recvfrom()` support for liburing. Added net files maintainers
to the CC list.

PATCH 3/3 adds `sendto(2)` and `recvfrom(2)` support for io_uring.
Added two new opcodes: IORING_OP_SENDTO and IORING_OP_RECVFROM.

## How to test

This patchset is based on "for-next" branch commit:

  aafc6e6eba29c890b0031267fc37c43490447c81 ("Merge branch 'for-5.17/io_uring' into for-next")

It is also available in the Git repository at:

  https://github.com/ammarfaizi2/linux-block ammarfaizi2/linux-block/io_uring-recvfrom-sendto


I also added the liburing support and test. The liburing support is
based on "xattr-getdents64" branch commit:

  18d71076f6c97e1b25aa0e3b0e12a913ec4717fa ("src/include/liburing.h: style cleanups")

It is available in the Git repository at:

  https://github.com/ammarfaizi2/liburing sendto-recvfrom


Link: https://github.com/axboe/liburing/issues/397 [1]
Link: https://lore.kernel.org/io-uring/a2399c89-2c45-375c-7395-b5caf556ec3d@kernel.dk/ [2]
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
Ammar Faizi (3):
  io_uring: Rename `io_{send,recv}` to `io_{sendto,recvfrom}`
  net: Make `move_addr_to_user()` be a non static function
  io_uring: Add `sendto(2)` and `recvfrom(2)` support

 fs/io_uring.c                 | 88 +++++++++++++++++++++++++++++++----
 include/linux/socket.h        |  2 +
 include/uapi/linux/io_uring.h |  2 +
 net/socket.c                  |  4 +-
 4 files changed, 86 insertions(+), 10 deletions(-)


base-commit: aafc6e6eba29c890b0031267fc37c43490447c81
-- 
Ammar Faizi
