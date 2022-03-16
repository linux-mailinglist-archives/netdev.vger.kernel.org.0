Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0334E4DA88D
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 03:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353220AbiCPCsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 22:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236530AbiCPCsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 22:48:13 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5E54665D;
        Tue, 15 Mar 2022 19:46:59 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id s11so1918629pfu.13;
        Tue, 15 Mar 2022 19:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WAhA3or61uWhNEMP9Wr/hW8ClqY4rD9PF3SsmW6XEFA=;
        b=ShoRLELfSFRn19TwdACGRJjhYlm8DHVMEUv63lfywdvrsvnbwnuzK1G7jscGQYimex
         N9E3OHDfr+Yis1v2S0Fa9c837mslEQzWgSDJ+mZIrpj/6Mzbm95PsbCyV4TO0D83os/q
         xXhhWmFnkKFqhHQRuz8tEZeMW+8UjhyCq8qZtvanD31wAZ5Tt8PvyailINF0sfF10pAw
         E3maHMtf4OGIk4ajGbrqvLrv+mSmx/MlhCRoDdltFBYjL3fjl8MN+J49kkyu66rzFTGY
         AAgYC/kQg7xihdc710RvdBYzIyRpq3ChoGyqlCvXuyG32tegIHGkXdu3Su+mvjWDWsVC
         vi7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WAhA3or61uWhNEMP9Wr/hW8ClqY4rD9PF3SsmW6XEFA=;
        b=rJteQUENUHF9chXRYJW1cZftEHcHeSQZDhJcb/jly/7gEwHD2wXXSA4T+2NgZ5zoWp
         kuujT03UBaho52xiQrP4tBUa4kvxp+mVrcDzrjO373aPS2oAEvULvipRbCe4ZZYPLWFg
         Q/sx2AW+yB9jvMk8C+PgcF4uSCWSxS7KCcT6rO0Tg2LMg10+x75Mgx7mHqz2tOsUaYAD
         Q2dBymHAL0HbKXq8hwX0E+eNU120LYzdrg/Vr6ayFS0WHYScn/PX3VVfjG7rtqwQbCsi
         SD6ovKzdsogflAptctLC8HtaFoht4GpWwypwfBBPo3XG8qwoU3YS5pf7scdCBc1QaIYD
         CVNw==
X-Gm-Message-State: AOAM533OB45HXQoGT+L54XaHhXTgGTupXLXrIKL6bvdlkGadJFDYU6bd
        Toun7rVmWODWHLFRSEpjf6I=
X-Google-Smtp-Source: ABdhPJwlCVx/sE/Oqp1+AsoUstkJQEZJr9kP5n3d2nKa88UwGaBzfJYlcm6TiP90Y3Ee1Ua+Oqo3mA==
X-Received: by 2002:a63:f14b:0:b0:374:7b9e:dc8f with SMTP id o11-20020a63f14b000000b003747b9edc8fmr26351543pgk.357.1647398819094;
        Tue, 15 Mar 2022 19:46:59 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6664d26eesm514630pfk.88.2022.03.15.19.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 19:46:58 -0700 (PDT)
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
Subject: [PATCH net-next v2 0/3] net: icmp: add skb drop reasons to icmp
Date:   Wed, 16 Mar 2022 10:46:03 +0800
Message-Id: <20220316024606.689731-1-imagedong@tencent.com>
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
patch, which is used in the 2th patch.

In the 2th patch, we introduce the new function __ping_queue_rcv_skb()
to report drop reasons by its return value.

In the 3th patch, we make ICMP message handler functions return drop
reasons, which means we change the return type of 'handler()' in
'struct icmp_control' from 'bool' to 'enum skb_drop_reason'. This
changed its original intention, as 'false' means failure, but
'SKB_NOT_DROPPED_YET', which is 0, means success now. Therefore, we
have to change all usages of these handler. Following "handler" functions
are involved:

icmp_unreach()
icmp_redirect()
icmp_echo()
icmp_timestamp()
icmp_discard()

And following drop reasons are added(what they mean can be see
in the document for them):

SKB_DROP_REASON_ICMP_CSUM
SKB_DROP_REASON_ICMP_TYPE
SKB_DROP_REASON_ICMP_BROADCAST

Changes since v1:
- introduce __ping_queue_rcv_skb() instead of change the return value
  of ping_queue_rcv_skb() in the 2th patch, as Paolo suggested

Menglong Dong (3):
  net: sock: introduce sock_queue_rcv_skb_reason()
  net: icmp: introduce __ping_queue_rcv_skb() to report drop reasons
  net: icmp: add reasons of the skb drops to icmp protocol

 include/linux/skbuff.h     |  5 +++
 include/net/ping.h         |  2 +-
 include/net/sock.h         |  9 ++++-
 include/trace/events/skb.h |  3 ++
 net/core/sock.c            | 30 ++++++++++++---
 net/ipv4/icmp.c            | 75 ++++++++++++++++++++++----------------
 net/ipv4/ping.c            | 32 ++++++++++------
 net/ipv6/icmp.c            | 24 +++++++-----
 8 files changed, 121 insertions(+), 59 deletions(-)

-- 
2.35.1

