Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3125131F0
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345324AbiD1LD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240459AbiD1LDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:03:00 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF38985B4;
        Thu, 28 Apr 2022 03:59:22 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id w4so6211399wrg.12;
        Thu, 28 Apr 2022 03:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nuJIqlIgdFQjWwRTfq2SfS/poVF6W3nofVJduFZhe30=;
        b=hqyGK0806qOZl7W20YYwkJtRjjRW+S7DGK6HVn0GFIbyGkmTr2Bp2H9bTwQCsYYtTd
         YuBRMZJrMM0ZrbewQl3Hyg/iWAbSK9PXVasIL949y5IfrCjZ34md9O6BQ9cTVEXBGmTK
         oULBxHC7qTnHxXbfrsJ9gYg1m+qrg+M9QWrQY7s4pQgeY9DQPlEu+ZiwpI0vAFk0VN8d
         8MuRgOF1tUzHCtv6y50/YaBJVgq3dOsSZR2YKGXNery+s8EFbk5LO7taM/zVzn+OHR+z
         BziV5Tl4QECH3GvmC7D3EEElZihKQSgxWqFURZc5KF6zFM4Abz47R1qpE4QcPIs8zWr9
         D2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nuJIqlIgdFQjWwRTfq2SfS/poVF6W3nofVJduFZhe30=;
        b=gfChJwF79RqjKLWZoQiEVdPTLoJ5OR+Qx+wQoOns/yBcUc0hDZC97FaHRfCVTZI3vv
         hpQn+UqFUuZyQ3mUgPIVaY1xi/zRXl2+1K2qgorN4KTAA5E0nNPM0rQJhsDVdSzpxyMc
         RzRhNFptDlrYVA+47zB0znYcv/KpGRVkKd5jjqQj9FLE8FYBd+DBY+c8um2GpGQcs3CK
         kKeO7I3kfPS6ZSMNmmXjR+NTFpp3D5nzcknnJGy46ng7k+7GN/u5++Tyq75s4awG/rOp
         QopDGwei3qcmf9JqXvFm9hpUxo4D2GH9Ax+i+x4svaQIvVTvDpU86A5TCLnOYeHZ+P0u
         HxKA==
X-Gm-Message-State: AOAM530bBBjA8eIMaAnaM9sasM45mb4l9wgMiQI9TJXSJhZt0XQJIlq+
        9/sQzifRWHYIjPPvCNFBQe/hx0xvDKA=
X-Google-Smtp-Source: ABdhPJyqspCMzhzZudQJDBRnyAa0QXypXSzeKCv42o4uRbKrjglRx1gX4Ft3VlWzOLGhQgh+UuA9hA==
X-Received: by 2002:a5d:588a:0:b0:204:1f46:cf08 with SMTP id n10-20020a5d588a000000b002041f46cf08mr26655407wrf.133.1651143561089;
        Thu, 28 Apr 2022 03:59:21 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d588a000000b002052e4aaf89sm16028895wrf.80.2022.04.28.03.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:59:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 0/5] generic net and ipv6 minor optimisations
Date:   Thu, 28 Apr 2022 11:58:43 +0100
Message-Id: <cover.1651141755.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1-3 inline simple functions that only reshuffle arguments possibly adding
extra zero args, and call another function. It was benchmarked before with
a bunch of extra patches, see for details

https://lore.kernel.org/netdev/cover.1648981570.git.asml.silence@gmail.com/

It may increase the binary size, but it's the right thing to do and at least
without modules it actually sheds some bytes for some standard-ish config.

   text    data     bss     dec     hex filename
9627200       0       0 9627200  92e640 ./arch/x86_64/boot/bzImage
   text    data     bss     dec     hex filename
9627104       0       0 9627104  92e5e0 ./arch/x86_64/boot/bzImage


Pavel Begunkov (5):
  net: inline sock_alloc_send_skb
  net: inline skb_zerocopy_iter_dgram
  net: inline dev_queue_xmit()
  ipv6: help __ip6_finish_output() inlining
  ipv6: refactor ip6_finish_output2()

 include/linux/netdevice.h | 14 ++++++++++++--
 include/linux/skbuff.h    | 36 ++++++++++++++++++++++--------------
 include/net/sock.h        | 10 ++++++++--
 net/core/datagram.c       |  2 --
 net/core/datagram.h       | 15 ---------------
 net/core/dev.c            | 15 ++-------------
 net/core/skbuff.c         |  7 -------
 net/core/sock.c           |  7 -------
 net/ipv6/ip6_output.c     | 25 +++++++++++++------------
 9 files changed, 57 insertions(+), 74 deletions(-)
 delete mode 100644 net/core/datagram.h

-- 
2.36.0

