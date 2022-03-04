Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB99C4CCD74
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbiCDGC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbiCDGCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:02:24 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A98E17B0DC;
        Thu,  3 Mar 2022 22:01:36 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id e6so6664137pgn.2;
        Thu, 03 Mar 2022 22:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fy9VjmMxXRapOa02iXlCU+eUSjWifQvOaRvF8K1gNE4=;
        b=SrvXoKdvRyegj2nNd+giP9kzgDY2G90N2thbfPF2gUKPzrm1o8dr4fR0lCWmU3ru8b
         r8OmLm1SHtjCKcKKhwSKTWs5jHTkJkO7Tqz866PQ/ncKo9sZbk/X7XdpXD2vEph/jnrN
         ZtCt6mGDNW7HwmZsnxaaFlyW/AKhRrOmuucvqM6xgDMlVJvjJ/bRtBFqR8rB1gq36hXC
         iTUV/UdOcEx5+XHXzOddHqC1s+tiZzv90N9XlJwZpeBA2pUUmo5aZpMneO/s43P3Ruds
         gtGK4ikJ4yVl1NR8uVOzgc3OALSCii5Pe6wbnMzLUhfc/B/tkdxm+AolN290OlZUOVyR
         thiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fy9VjmMxXRapOa02iXlCU+eUSjWifQvOaRvF8K1gNE4=;
        b=AqZnIgYurXgrFWxpRsJ7DSaNS2CQGxcf7fCfQ1r4c8YNM/5ae6P5AuPQzHlRnwbe8/
         Olqw0v2N2OKCMNQLLO0FzfPnbwtEn12PvTvqO69V8eCrWTuSeOTGtXRz3w6Ol03RA7AF
         tVWvKzVPxDYLYM2s6fhyuuS9qKBCtS4BZwGk/ghClkrwRVrrza+rG1n5ZM5p0OWqzOHj
         ya8AvAY8e0+31xxw1gG7VX01HZ0kKSpbeTxkgGpYvNPqJTbCZaOFeqtJtSn3MldgYd01
         8uxeGezk0k7M5opPdHvmrFzqoY2c6GKB1EXrovgIOmxg+pH/TujpgZF8F6MSz5wu+Vzn
         rSFg==
X-Gm-Message-State: AOAM5323B/yElN0jksnSDl2e27m7abZNU7Z8FRlFLZzr30iB2kOa0RGY
        nTfZbHSzVH7/PekSFi0e4Nk=
X-Google-Smtp-Source: ABdhPJwNmasC8NLQ4Acb2NsHigjhX74wp33fN1PdDh9rFWXCNWxyipbAb2soolAcFonf6SThif0doQ==
X-Received: by 2002:a05:6a00:781:b0:4f4:2a:2d89 with SMTP id g1-20020a056a00078100b004f4002a2d89mr26702180pfu.13.1646373695884;
        Thu, 03 Mar 2022 22:01:35 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.116])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00190500b004f104b5350fsm4569073pfi.93.2022.03.03.22.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 22:01:34 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, imagedong@tencent.com,
        edumazet@google.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com, atenart@kernel.org,
        bigeasy@linutronix.de, memxor@gmail.com, arnd@arndb.de,
        pabeni@redhat.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net-next v2 0/7] net: dev: add skb drop reasons to net/core/dev.c
Date:   Fri,  4 Mar 2022 14:00:39 +0800
Message-Id: <20220304060046.115414-1-imagedong@tencent.com>
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
to the link layer, which means that 'net/core/dev.c' is our target.

Following functions are processed:

sch_handle_egress()
__dev_xmit_skb()
enqueue_to_backlog()
do_xdp_generic()
sch_handle_ingress()
__netif_receive_skb_core()

and following new drop reasons are added (what they mean can be see in
the document of them):

SKB_DROP_REASON_TC_EGRESS
SKB_DROP_REASON_QDISC_DROP
SKB_DROP_REASON_CPU_BACKLOG
SKB_DROP_REASON_XDP
SKB_DROP_REASON_TC_INGRESS
SKB_DROP_REASON_PTYPE_ABSENT

In order to add skb drop reasons to kfree_skb_list(), the function
kfree_skb_list_reason() is introduced in the 2th patch, which will be
used in __dev_xmit_skb() in the 3th patch.

Changes since v1:
- rename SKB_DROP_REASON_QDISC_EGRESS to SKB_DROP_REASON_TC_EGRESS in the
  1th patch
- remove the 'else' in the 4th patch
- rename SKB_DROP_REASON_QDISC_INGRESS to SKB_DROP_REASON_TC_INGRESS in
  the 6th patch

Menglong Dong (7):
  net: dev: use kfree_skb_reason() for sch_handle_egress()
  net: skb: introduce the function kfree_skb_list_reason()
  net: dev: add skb drop reasons to __dev_xmit_skb()
  net: dev: use kfree_skb_reason() for enqueue_to_backlog()
  net: dev: use kfree_skb_reason() for do_xdp_generic()
  net: dev: use kfree_skb_reason() for sch_handle_ingress()
  net: dev: use kfree_skb_reason() for __netif_receive_skb_core()

 include/linux/skbuff.h     | 26 +++++++++++++++++++++++++-
 include/trace/events/skb.h |  6 ++++++
 net/core/dev.c             | 24 +++++++++++++++---------
 net/core/skbuff.c          |  7 ++++---
 4 files changed, 50 insertions(+), 13 deletions(-)

-- 
2.35.1

