Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042AD4E36EC
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiCVCyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbiCVCym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:54:42 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A2B6D94D;
        Mon, 21 Mar 2022 19:53:16 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso957113pjb.5;
        Mon, 21 Mar 2022 19:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HEQRBENvseTKzfj/N673FFaVSWQrn7jbBZtPfnnQUWY=;
        b=MvSYdqo9zmhT/tVhE3TG9caIcwbaR68rvhnmtsDW7OZhiHbbKppKx3K1zEuFvyVqtK
         2fDnZ+PEo/TtsLLff+wvv19y3TiY/hF6ET/4eLG+pF0yNJr+kPCxCufMSq7EvF/vTqq/
         +Gz4KqQIpgWrWLVtuFzlHC7aNKolXvr3vaTlvpaaz5xKmZIahS5Vpfh9WwrjbIjP9dVw
         3hejP+v3v3bbDXaF5jWoBh/Q+i/U5SAG6NcRHXBJ/wgN1OQ2EFCqpnraK6Xm7Vu0qrCD
         XD7xrJ9Yf8eD74U307R4BixfXuUpmUdXPObSvHH/5thWM+lDUrqyBkzSs4lzf1VsBdEN
         qzKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HEQRBENvseTKzfj/N673FFaVSWQrn7jbBZtPfnnQUWY=;
        b=r/Y32glOsT81IHTQrHEkpTXP8ciWcKxuA3prDOuyWnfq2b6NSQDH2GJUxzecux3KZZ
         0heCkPUtcxBDihSUTum7ThsDC7MT00mVl3gk7wK7c6oHfxJtrmmoFnUjwOAOXGydgykl
         8lE4tCtt5oYLJEyU96b7ii8O99m73quIWUCBedaAPj6VQJCMN/hnQe0lxW8uV4JXjypw
         uuoaQOZtow+3adzLZmD6wTtgxDKZU5PsKBNRf54Q3p10ramzW2sUFVRSzPrOPwVeUsJD
         R6wjTtAnpSd3WkCNLWPBFGxocb65DWYJoo3o6LDfDCQ2JhGy4YuXZH0D9PwEXDwTL64Q
         oQ+Q==
X-Gm-Message-State: AOAM533UNDUgkIbSu2Z5tJAKX6UKSqz9TlmhsbNt/umTrJfwUpQB/Nt/
        DGacmeWEdn8xh3cgH6SVx7o=
X-Google-Smtp-Source: ABdhPJzj1FBSzwoJb7MS4JnBFXOXe0hMLUreHU3V7EHk8mMDkoLBkusiB2pC7ob6xBrgjPBPVgMGcg==
X-Received: by 2002:a17:902:a415:b0:153:a1b6:729f with SMTP id p21-20020a170902a41500b00153a1b6729fmr15928344plq.52.1647917595414;
        Mon, 21 Mar 2022 19:53:15 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id g24-20020a17090a579800b001c60f919656sm764687pji.18.2022.03.21.19.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 19:53:14 -0700 (PDT)
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
Subject: [PATCH net-next v4 0/4] net: icmp: add skb drop reasons to icmp
Date:   Tue, 22 Mar 2022 10:52:16 +0800
Message-Id: <20220322025220.190568-1-imagedong@tencent.com>
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
SKB_DROP_REASON_RFC_1122

The reason 'RFC_1122' is introduced for the case that the packet doesn't
follow rfc 1122 and is dropped. Maybe the name 'INVALID_PROTO' is more
suitable? I think this reason is different from the 'UNHANDLED_PROTO',
as the 'UNHANDLED_PROTO' means the packet is fine, and it is just not
supported. This is not a common case, and I believe we can locate the
problem from the data in the packet. For now, this 'RFC_1122' is used
for the icmp broadcasts with wrong types.

Maybe there should be a document file for these reasons. For example,
list all the case that causes the 'RFC_1122' drop reason. Therefore,
users can locate their problems according to the document.

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

 include/linux/skbuff.h     | 10 ++---
 include/net/ping.h         |  2 +-
 include/net/sock.h         |  9 ++++-
 include/trace/events/skb.h |  4 +-
 net/core/dev.c             |  8 ++--
 net/core/sock.c            | 30 ++++++++++++---
 net/ipv4/icmp.c            | 75 ++++++++++++++++++++++----------------
 net/ipv4/ping.c            | 32 ++++++++++------
 net/ipv6/icmp.c            | 24 +++++++-----
 9 files changed, 124 insertions(+), 70 deletions(-)

-- 
2.35.1

