Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3EC3C989F
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 08:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239690AbhGOGDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 02:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhGOGDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 02:03:20 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A69C06175F
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 23:00:27 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id i4so2287354qvq.10
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 23:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XDN6M0voCCNTQjGhRBKdBi+yvKiLLyGKE35DUVdNNac=;
        b=mgMOcz8PNbbmjhQsB9uc/q3u0fqdYekBX+qP9CXUGomOp1IbQ00WgDzAQeXB+u5cOY
         mBZCrTFM/onzlAORaPILppim1ZzC3CIEzBby3V/Le5s0g91eBXAOKurelkKwwKGYFztu
         c5QN2Aqzvlu8ogOmP0AR2iCrbvcaXK3npcYhWHAJseqHdneEpaC7vyUN9rkl9ZSRyR0K
         qQj/I+pAJxocy83nWDmGknpldctvIACRAqXzOEctlhIZ3ok61PD1p9yiJWIqPHOdtTEZ
         Svicozw80et4H+16sdG/3Cr2t7E979NBcvO1rU+Z1IT9iS1uv0bTqLobisZsUtXkN5Fn
         v74w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XDN6M0voCCNTQjGhRBKdBi+yvKiLLyGKE35DUVdNNac=;
        b=T4PjefLndSOEmmAbYW/U8C1IN3P/e4JXVYmOYDdAGPFqCQYOEWMijK9D0GyQ+HB06X
         C4nPskBsBiFoY62VkjXBuxqZqdk/jQNp3I5i46c2wcuCaq0GTa83i2FlfZwTbKAa2eG5
         TpIyo5rEKBHUas+KHbj8dQeOVYt9iy+1ly1FRPgZL7uPWRD113St9ghGTHHocfNqH0SZ
         pPHedUl/Vc4nqVMfYrySf5Bv7s/iv0BS2WbEa5qsD79TzqdOWLc/lY4GrxeWEV/gRq8m
         FtWDGkmLjkzNlAwjDalCrE6uBhZ3ktRKQHn3vKY4U6jHW0eWfmKgdC3xSVUY/9Jk3O11
         meHg==
X-Gm-Message-State: AOAM533z8bwbR9xcrTQiVsGtmyr/AtyYVkDPuyOGLUZx5szZfoo1NvqB
        1YPRRNL/HvXp9rsAcIy/RPlhdkjmdIo=
X-Google-Smtp-Source: ABdhPJzR2DxF7cFCZ9X299JaNId/lZDCvvlEuHQl2HVXUPxPIig4XOwN1SfOP2Aj9OMeszSEI01Mzg==
X-Received: by 2002:a05:6214:1303:: with SMTP id a3mr2460569qvv.49.1626328826274;
        Wed, 14 Jul 2021 23:00:26 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id y26sm2043871qkm.32.2021.07.14.23.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 23:00:25 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next resend v2] net_sched: use %px to print skb address in trace_qdisc_dequeue()
Date:   Wed, 14 Jul 2021 23:00:21 -0700
Message-Id: <20210715060021.43249-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Print format of skbaddr is changed to %px from %p, because we want
to use skb address as a quick way to identify a packet.

Note, trace ring buffer is only accessible to privileged users,
it is safe to use a real kernel address here.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/qdisc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 330d32d84485..58209557cb3a 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -41,7 +41,7 @@ TRACE_EVENT(qdisc_dequeue,
 		__entry->txq_state	= txq->state;
 	),
 
-	TP_printk("dequeue ifindex=%d qdisc handle=0x%X parent=0x%X txq_state=0x%lX packets=%d skbaddr=%p",
+	TP_printk("dequeue ifindex=%d qdisc handle=0x%X parent=0x%X txq_state=0x%lX packets=%d skbaddr=%px",
 		  __entry->ifindex, __entry->handle, __entry->parent,
 		  __entry->txq_state, __entry->packets, __entry->skbaddr )
 );
-- 
2.27.0

