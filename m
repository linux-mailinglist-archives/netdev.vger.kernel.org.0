Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B193A0EDD
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 10:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbhFIIrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 04:47:01 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:51622 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231917AbhFIIrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 04:47:00 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Ubr1-.z_1623228304;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0Ubr1-.z_1623228304)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Jun 2021 16:45:05 +0800
Date:   Wed, 9 Jun 2021 16:45:04 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next] tcp: avoid spurious loopback retransmit
Message-ID: <20210609084504.GP53857@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20210607154534.57034-1-dust.li@linux.alibaba.com>
 <CANn89i+dDy6ev50mBMwoK7f0NN+0xHf8V-Jas8zAmew02hJV4w@mail.gmail.com>
 <20210608030903.GN53857@linux.alibaba.com>
 <CANn89i+VEA4rc3T_oC7tJXYvA7OAmDc=Vk_wyxYwzYz23nENPg@mail.gmail.com>
 <20210609002542.GO53857@linux.alibaba.com>
 <CANn89i+vBRxKFy_Bb2_tKTh1ttLanZj99UNZcmjSQ=oq4-j6og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+vBRxKFy_Bb2_tKTh1ttLanZj99UNZcmjSQ=oq4-j6og@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 09:03:14AM +0200, Eric Dumazet wrote:
>On Wed, Jun 9, 2021 at 2:25 AM dust.li <dust.li@linux.alibaba.com> wrote:
>>
>
>> Normal RTO and fast retransmits are rarely triggerred.
>> But for TLP timers, it is easy since its timeout is usally only 2ms.
>>
>
>OK, by definition rtx timers can fire too early, so I think we will
>leave the code as it is.
>(ie not try to do special things for 'special' interfaces like loopback)
>
>We want to be generic as much as possible.
Totally understand!

After talking to you, I also rethinked this a bit more.
The original patch is bad and not generic, my original intention is
also to discuss with the community.

Through the patch is bad, I still think the problem is generic.
Devices like loopback/veth/ifb and maybe some others as well,
who depend on netif_rx() or tasklet to receive packets from CPU
backlog should all have this problem.

But I really didn't find a general way to gracefully solve this.

Thanks.
