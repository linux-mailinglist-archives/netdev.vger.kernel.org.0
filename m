Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E12B4980C4
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 14:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242815AbiAXNPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 08:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239787AbiAXNPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 08:15:49 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AF7C06173D;
        Mon, 24 Jan 2022 05:15:49 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id i1so5749781pla.0;
        Mon, 24 Jan 2022 05:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zsKZycxk3s8EzrdbS+Ftq1wVpvKxEVr/0i2wJkBmcKE=;
        b=UYMMakO9c6nUeE86oZnQz1pZ0AeBAXSiCaVrBJifybAAJdtyD1a303ixMK3lTs3lRL
         onjvHK/12X6PLDfjcYf5PigCTaAEDCKV9xteHVfteA/21EUIx2HKuUak6SIgmDoFQgpa
         HX3HnQ446Cpj+0ATFJ+4Nv6YwL4bdXMYyAXXqgJVQeBhP8d0cu2ZKkVd+ECDt3hrxBHo
         CathRNpX+VhNfUh2v+0HqPyNsk8J3Y/ouzNNZiecKVv6xgWVRxPrixQmy9PL1WHd6ygd
         GbFLmQILVcGFCKo/5AjqdHPr6Dw3fGZgML7V235fXROz/flZ09YSZcTqdiL7c29IoxMT
         nBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zsKZycxk3s8EzrdbS+Ftq1wVpvKxEVr/0i2wJkBmcKE=;
        b=vrHqOegzWFP7K+sfjebg6o2+N/4aO7xEzrSrZ3qCDZGdEPmnHLazHAKcFPUxkY8TY9
         cWwQDlcoAgo0qSC0KwVSuVetUkgKz1vWnN8N9icMq3HTpnND2ItxzPiWhvdEzzXpwd/k
         AIuz2+kGHI0awumU8+C9657UWuC5ZH+8X9C3fyo60aVk6Gz8F8cQF3t6Jb/OVo7HGOVm
         M5s9CdUV4+naoxhwABGFlxXUxJTfyP7k9vHXAbIt7cjfNm8yaWf3aUshbm9UbtfllRzP
         ZjzA6UnsGISF6Ne2UgxNopVckUsxlPK/l2n19lX9V5rgT85f6YhNBKWwy5i536crIqYG
         d8eQ==
X-Gm-Message-State: AOAM5320zyC/ovd3eFIi9L3eKrC3iZXqscMiDql3hnYL7RzL5VliclU0
        YuW2KwdgQIn+9gAcOV/RK48=
X-Google-Smtp-Source: ABdhPJx2BHZ2Hgc2pH7eRt6vUlQquFSoPYVQ609a2fbwnJVrutFWJuZ77SKpyhSrgXY8/29x1ZieoA==
X-Received: by 2002:a17:902:e882:b0:14b:5896:a74f with SMTP id w2-20020a170902e88200b0014b5896a74fmr3207782plg.13.1643030148681;
        Mon, 24 Jan 2022 05:15:48 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id j11sm16508806pfu.55.2022.01.24.05.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 05:15:47 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, paulb@nvidia.com,
        pabeni@redhat.com, talalahmad@google.com, haokexin@gmail.com,
        keescook@chromium.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com
Subject: [PATCH net-next 0/6] net: use kfree_skb_reason() for ip/udp packet receive
Date:   Mon, 24 Jan 2022 21:15:32 +0800
Message-Id: <20220124131538.1453657-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

In this series patches, kfree_skb() is replaced with kfree_skb_reason()
during ipv4 and udp4 packet receiving path, and following drop reasons
are introduced:

SKB_DROP_REASON_NETFILTER_DROP
SKB_DROP_REASON_OTHERHOST
SKB_DROP_REASON_IP_CSUM
SKB_DROP_REASON_IP_INHDR
SKB_DROP_REASON_IP_ROUTE_INPUT
SKB_DROP_REASON_IP_RPFILTER
SKB_DROP_REASON_EARLY_DEMUX
SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST
SKB_DROP_REASON_XFRM_POLICY
SKB_DROP_REASON_IP_NOPROTO
SKB_DROP_REASON_UDP_FILTER
SKB_DROP_REASON_SOCKET_RCVBUFF
SKB_DROP_REASON_PROTO_MEM

TCP is more complex, so I left it in the next series.

I just figure out how __print_symbolic() works. It doesn't base on the
array index, but searching for symbols by loop. So I'm a little afraid
it's performance.


Menglong Dong (6):
  net: netfilter: use kfree_drop_reason() for NF_DROP
  net: ipv4: use kfree_skb_reason() in ip_rcv_core()
  net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()
  net: ipv4: use kfree_skb_reason() in ip_protocol_deliver_rcu()
  net: udp: use kfree_skb_reason() in udp_queue_rcv_one_skb()
  net: udp: use kfree_skb_reason() in __udp_queue_rcv_skb()

 include/linux/skbuff.h     | 16 +++++++++++++++
 include/trace/events/skb.h | 14 +++++++++++++
 net/ipv4/ip_input.c        | 42 +++++++++++++++++++++++++++-----------
 net/ipv4/udp.c             | 22 ++++++++++++++------
 net/netfilter/core.c       |  3 ++-
 5 files changed, 78 insertions(+), 19 deletions(-)

-- 
2.27.0

