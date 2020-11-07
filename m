Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C80C2AA544
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 14:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgKGNIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 08:08:35 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:35278 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727084AbgKGNIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 08:08:34 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UEW6ava_1604754510;
Received: from IT-FVFX43SYHV2H.lan(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UEW6ava_1604754510)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 07 Nov 2020 21:08:31 +0800
Subject: Re: [PATCH] net/xdp: remove unused macro REG_STATE_NEW
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1604641431-6295-1-git-send-email-alex.shi@linux.alibaba.com>
 <20201106171352.5c51342d@carbon>
From:   Alex Shi <alex.shi@linux.alibaba.com>
Message-ID: <3d39a08d-2e50-efeb-214f-0c7c2d1605d7@linux.alibaba.com>
Date:   Sat, 7 Nov 2020 21:08:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201106171352.5c51342d@carbon>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2020/11/7 ÉÏÎç12:13, Jesper Dangaard Brouer Ð´µÀ:
> Hmm... REG_STATE_NEW is zero, so it is implicitly set via memset zero.
> But it is true that it is technically not directly used or referenced.
> 
> It is mentioned in a comment, so please send V2 with this additional change:

Hi Jesper,

Thanks a lot for comments. here is the v2:

From 2908d25bf2e1c90ad71a83ba056743f45da283e8 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@linux.alibaba.com>
Date: Fri, 6 Nov 2020 13:41:58 +0800
Subject: [PATCH v2] net/xdp: remove unused macro REG_STATE_NEW

To tame gcc warning on it:
net/core/xdp.c:20:0: warning: macro "REG_STATE_NEW" is not used
[-Wunused-macros]
And change related comments as Jesper Dangaard Brouer suggested.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
---
 net/core/xdp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 48aba933a5a8..0df5ee5682d9 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -19,7 +19,6 @@
 #include <trace/events/xdp.h>
 #include <net/xdp_sock_drv.h>
 
-#define REG_STATE_NEW		0x0
 #define REG_STATE_REGISTERED	0x1
 #define REG_STATE_UNREGISTERED	0x2
 #define REG_STATE_UNUSED	0x3
@@ -175,7 +174,7 @@ int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
 		return -ENODEV;
 	}
 
-	/* State either UNREGISTERED or NEW */
+	/* State either UNREGISTERED or zero */
 	xdp_rxq_info_init(xdp_rxq);
 	xdp_rxq->dev = dev;
 	xdp_rxq->queue_index = queue_index;
-- 
1.8.3.1

