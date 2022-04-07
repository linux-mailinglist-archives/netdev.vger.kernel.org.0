Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA124F75DD
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 08:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240993AbiDGGXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 02:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234876AbiDGGXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 02:23:45 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B5813F8A;
        Wed,  6 Apr 2022 23:21:46 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r66so4156428pgr.3;
        Wed, 06 Apr 2022 23:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r/Yd4ctKBRTkId243QxullLAJ499JsmHM27TX/9zNkY=;
        b=q015AvSPv9U5X4ukv5WL/BvkkY3lkwkjA3TX9tR+VTUGNZWn2o1bx7lYvwOQUwQ/eR
         c4TNCTNHPXsps4kuvWhQH2yJ4iiVdo9CissTex6LhXluLKRlScCMvHOghwIUjTogywFL
         qDG7vHYH9hpKHPzeJmcnwzcd8gOIY7ocg8v/1e8UohhEM3UzvAvwoG8pM7hagrtpcB1j
         85nc6F/gS/N7M0HkpFdiZzAi2bFco5H3A0z150jZnDKegvZGK3qXUV1ojjqQGVaTHzih
         n0YVyy9lSqffDt+7R1jSeOGOeSAyPRI7wHElLNdJopUAPPQgE8j45L4VP9fR3aLoSxvz
         3QYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r/Yd4ctKBRTkId243QxullLAJ499JsmHM27TX/9zNkY=;
        b=Z0RjlKs/Nfr7Akhs6hY8teIJkymsofYRmySolw5uz/FapLV9KFjPn71skRSRvruAUZ
         QfcjcY97AwuXvLpcsGK7lNVz+rj3SqNHmdg/l/2hdY4unRkobiQ2Dz57Cykyghqq4SN7
         +g5x6mKHEQgmjNisVgKxnUaVfmCRV1hMWyccYCyh3Ep7GUCpGyCs1UxJYMqKC/T1L7wZ
         sDYtoLSlyzB/ANaLtnpHe07UivGuqWNq9izqbQ+d0Bi805dKQY0G0U8D9xmz52mX1pA6
         f7ve1pCfAtbGqTZldBzpP3CSMQnSNI1h46alWASu0w3J19M2TcT0h1s+0WbYmkbxbw1t
         e5LQ==
X-Gm-Message-State: AOAM533qLHDSehNZGT1OKYexGBOPCcjReS9KAu0E7uCf1C8rhC/O5l3W
        A/NLxJqOP9Ce71ycCsRb4xz5iWLtRYs=
X-Google-Smtp-Source: ABdhPJzhshicBBhD4kyaCt7hQ6rZ9dAFNcF3D6v12IEEjAzJa88rbRJ9zgA8rV9GAA2+pQX1eSRlQQ==
X-Received: by 2002:a05:6a00:1d92:b0:4fa:dfbd:d7f0 with SMTP id z18-20020a056a001d9200b004fadfbdd7f0mr12724663pfw.31.1649312506252;
        Wed, 06 Apr 2022 23:21:46 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.118])
        by smtp.gmail.com with ESMTPSA id k92-20020a17090a4ce500b001ca69b5c034sm7522829pjh.46.2022.04.06.23.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 23:21:45 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, benbjiang@tencent.com
Subject: [PATCH RESEND net-next v5 0/4] net: icmp: add skb drop reasons to icmp
Date:   Thu,  7 Apr 2022 14:20:48 +0800
Message-Id: <20220407062052.15907-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
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

From: Menglong Dong <imagedong@tencent.com>

In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()"),
we added the support of reporting the reasons of skb drops to kfree_skb
tracepoint. And in this series patches, reasons for skb drops are added
to ICMP protocol.

In order to report the reasons of skb drops in 'sock_queue_rcv_skb()',
the function 'sock_queue_rcv_skb_reason()' is introduced in the 1th
patch, which is used in the 3th patch.

As David Ahern suggested, the reasons for skb drops should be more
general and not be code based. Therefore, in the 2th patch,
SKB_DROP_REASON_PTYPE_ABSENT is renamed to
SKB_DROP_REASON_UNHANDLED_PROTO, which is used for the cases of no
L3 protocol handler, no L4 protocol handler, version extensions, etc.

In the 3th patch, we introduce the new function __ping_queue_rcv_skb()
to report drop reasons by its return value and keep the return value of
ping_queue_rcv_skb() still.

In the 4th patch, we make ICMP message handler functions return drop
reasons, which means we change the return type of 'handler()' in
'struct icmp_control' from 'bool' to 'enum skb_drop_reason'. This
changed its original intention, as 'false' means failure, but
'SKB_NOT_DROPPED_YET', which is 0, means success now. Therefore, we
have to change all usages of these handler. Following "handler"
functions are involved:

icmp_unreach()
icmp_redirect()
icmp_echo()
icmp_timestamp()
icmp_discard()

And following drop reasons are added(what they mean can be see
in the document for them):

SKB_DROP_REASON_ICMP_CSUM
SKB_DROP_REASON_INVALID_PROTO

The reason 'INVALID_PROTO' is introduced for the case that the packet
doesn't follow rfc 1122 and is dropped. I think this reason is different
from the 'UNHANDLED_PROTO', as the 'UNHANDLED_PROTO' means the packet is
fine, and it is just not supported. This is not a common case, and I
believe we can locate the problem from the data in the packet. For now,
this 'INVALID_PROTO' is used for the icmp broadcasts with wrong types.

Maybe there should be a document file for these reasons. For example,
list all the case that causes the 'INVALID_PROTO' drop reason. Therefore,
users can locate their problems according to the document.

Changes since v4:
- rename SKB_DROP_REASON_RFC_1122 to SKB_DROP_REASON_INVALID_PROTO

Changes since v3:
- rename SKB_DROP_REASON_PTYPE_ABSENT to SKB_DROP_REASON_UNHANDLED_PROTO
  in the 2th patch
- fix the return value problem of ping_queue_rcv_skb() in the 3th patch
- remove SKB_DROP_REASON_ICMP_TYPE and SKB_DROP_REASON_ICMP_BROADCAST
  and introduce the SKB_DROP_REASON_RFC_1122 in the 4th patch

Changes since v2:
- fix aliegnment problem in the 2th patch

Changes since v1:
- introduce __ping_queue_rcv_skb() instead of change the return value
  of ping_queue_rcv_skb() in the 2th patch, as Paolo suggested

Menglong Dong (4):
  net: sock: introduce sock_queue_rcv_skb_reason()
  net: skb: rename SKB_DROP_REASON_PTYPE_ABSENT
  net: icmp: introduce __ping_queue_rcv_skb() to report drop reasons
  net: icmp: add skb drop reasons to icmp protocol

 include/linux/skbuff.h     | 13 ++++---
 include/net/ping.h         |  2 +-
 include/net/sock.h         |  9 ++++-
 include/trace/events/skb.h |  4 +-
 net/core/dev.c             |  8 ++--
 net/core/sock.c            | 30 ++++++++++++---
 net/ipv4/icmp.c            | 75 ++++++++++++++++++++++----------------
 net/ipv4/ping.c            | 32 ++++++++++------
 net/ipv6/icmp.c            | 24 +++++++-----
 9 files changed, 127 insertions(+), 70 deletions(-)

-- 
2.35.1

