Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D824E8D4B
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 06:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbiC1E3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 00:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiC1E3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 00:29:47 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324B5E02C;
        Sun, 27 Mar 2022 21:28:04 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id c23so13796014plo.0;
        Sun, 27 Mar 2022 21:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r/Yd4ctKBRTkId243QxullLAJ499JsmHM27TX/9zNkY=;
        b=kjjcYHL2++UDkRdZ0EfLspqHhHkaDUtPzjUGt4PdwSGpicb0wShNuKuXH3Pief6yQF
         SruyH62vjtPtAHUn0g43VhF1VQsjRADiNgcErKOjnfDUo0Ft7rPuJBlnERFoLDlaj26K
         ReIaI1U4TZYAj+OAgwMfjy3yStkP9NFsgvJQgf35xKJ5TyltP6oI1FHiFL0hvbm9LB7s
         TDJy9mG2oWaAkDDjHUQhlk7bJczQCGQD4AAR7uB/+ajK5n7T+8QBYfsFaACZNH4VNUGs
         NTD3bTxThqc0PT9rWbq0Z+SJnmUokKFkKVKjQLc2idF73h7n5G6VgrvCUvQ+fnUKhacA
         XNsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r/Yd4ctKBRTkId243QxullLAJ499JsmHM27TX/9zNkY=;
        b=hewMUXbTSZd+jHY9SbzjMgBnjihQHMZ+FR5PbOuHB5HiLHYbWRC4DcE3+/MJxUdmD1
         5lV9gRHf7+IVOzv1qBjMW5KunVoBEEnFiQOn9sZtSA8zQL9fuDKXu67KlDcr1mDUX6XB
         fdaqaRxQNWePHMiAdaL5G/BXWTwSCoYT9q0o0yVDuOY+s8M8xJR74LBzRJXBfiOTV+5Z
         JcpBbVpJa9ozmYSwSUlqNO48q2P4wxsrH7qNRxMqLfzDhlDJryPk6U9FT99F5AQNQx6l
         4cIlxEe4tldXvYUNqZmCPBngsuhAV3caipT9dGIGBxktWH1Z6ZB8ye46RqF8iChN6p9l
         aLEw==
X-Gm-Message-State: AOAM532F0NrOoP2ksgfU8bVoHq2O72mrPyxhf9DvvqAx1y3KSlVztOJQ
        8NmtLaBG9S5LXXeaXC2e1ek=
X-Google-Smtp-Source: ABdhPJwmkJCQyJ79YtxogKjAqgXtZOGDBCkPU9xvFTV72AvpbgvHqeFZ0oickFgjTvwf91vZzXoBqg==
X-Received: by 2002:a17:902:b702:b0:156:17a5:5ddb with SMTP id d2-20020a170902b70200b0015617a55ddbmr1801750pls.44.1648441684260;
        Sun, 27 Mar 2022 21:28:04 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id o27-20020a63731b000000b0038232af858esm11317715pgc.65.2022.03.27.21.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 21:28:03 -0700 (PDT)
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
Subject: [PATCH net-next v5 0/4] net: icmp: add skb drop reasons to icmp
Date:   Mon, 28 Mar 2022 12:27:33 +0800
Message-Id: <20220328042737.118812-1-imagedong@tencent.com>
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

