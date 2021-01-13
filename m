Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007D72F42B6
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbhAMEAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:00:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:62922 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbhAMEAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 23:00:32 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210113035948epoutp0489e528d65d05bb0d878e4136e66728d3~Zrqp51Ky40918609186epoutp04-
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 03:59:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210113035948epoutp0489e528d65d05bb0d878e4136e66728d3~Zrqp51Ky40918609186epoutp04-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610510389;
        bh=W8Fhl0L7TMF26AAY4u8va1bwbtBxcSdA0ncq9rF/8so=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=aRm65thRop2Q++MBedeJR61Ig8pR+7SpmG+5KVOj7XaJxYIWH6cURJQ6Narb/mlEf
         G3fgAeEHerYA++4WzLpgLWHMlz3C5P56v0TNT5BEfwtj9Ks5GpFT2u7GiWIbgxnLrB
         WAyuFBH9JvY0U/rfADCMsdbAe7dvbdqZ+4G6KsTU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210113035948epcas2p2ffe53b8a7937eddba6868c463218d829~Zrqpdn0U-3197131971epcas2p2W;
        Wed, 13 Jan 2021 03:59:48 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.190]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DFtxZ4QwNz4x9QB; Wed, 13 Jan
        2021 03:59:46 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F3.5E.56312.2307EFF5; Wed, 13 Jan 2021 12:59:46 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210113035946epcas2p461e3b34ec59b314eab3dee898b9722de~ZrqnN_ytt0766307663epcas2p4_;
        Wed, 13 Jan 2021 03:59:46 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210113035946epsmtrp251de986472b9d8bd64893bde2f1237cb~ZrqnM0LnO1124111241epsmtrp2W;
        Wed, 13 Jan 2021 03:59:46 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-bd-5ffe7032051f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BB.86.08745.1307EFF5; Wed, 13 Jan 2021 12:59:45 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210113035945epsmtip198e02bd2f5ed7787a28262e3ee8a15ea~Zrqm_F9FU1901119011epsmtip1W;
        Wed, 13 Jan 2021 03:59:45 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Alexander Duyck'" <alexander.duyck@gmail.com>,
        "'Alexander Lobakin'" <alobakin@pm.me>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>
Cc:     "'Eric Dumazet'" <edumazet@google.com>,
        "'Edward Cree'" <ecree@solarflare.com>,
        "'Willem de Bruijn'" <willemb@google.com>,
        "'Steffen Klassert'" <steffen.klassert@secunet.com>,
        "'Alexey Kuznetsov'" <kuznet@ms2.inr.ac.ru>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <6fb72534-d4d4-94d8-28d1-aabf16e11488@gmail.com>
Subject: RE: [PATCH net-next] udp: allow forwarding of plain
 (non-fraglisted) UDP GRO packets
Date:   Wed, 13 Jan 2021 12:59:45 +0900
Message-ID: <001401d6e960$87cab7b0$97602710$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQIG1joYaP0v6oQkhg9ExAi4xsHAXwG4fV9fAwzqUvmpnuIkEA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJsWRmVeSWpSXmKPExsWy7bCmha5Rwb94g+ZpMhb/595msVj1eDuL
        xZzzLSwWX/8vZ7F4euwRu8WFbX2sFhfaXrFaXN41h83i2AIxi92dP9gt3m05wm7xdW8XiwOP
        x5aVN5k8ds66y+6xYFOpx6ZVnWwebddWMXls+f2dzePonnNsHptal7B6rH7yg83j8ya5AK6o
        HJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoLOVFMoS
        c0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5
        GbMuzWQqWCZaMavzImMD4x+BLkZODgkBE4n/9yexgthCAjsYJU7eUu9i5AKyPzFK3H1+lBXC
        +cwo0fXrAhNMx+GlN9khErsYJXpeP2KCcF4wShz+/4YZpIpNQEvizax2sHYRgQ2MEi+a94M5
        zAKXmCT2Hl/BBlLFKWArsXBbE9h2YYF4iQnLPgDZHBwsAqoSd9eVgYR5BSwl3v34yQphC0qc
        nPmEBcRmFpCX2P52DjPESQoSP58uY4WIi0jM7mwDi4sIOEk8PPMP7DoJgRccEhsvr2OHaHCR
        6Dr3jwXCFpZ4dXwLVFxK4vO7vWwgN0gI1Eu0dsdA9PYwSlzZ9wSq3lhi1rN2RpAaZgFNifW7
        9CHKlSWO3II6jU+i4/Bfdogwr0RHmxCEqSQx8Us8xAwJiRcnJ7NMYFSaheSvWUj+moXkl1kI
        qxYwsqxiFEstKM5NTy02KjBCjutNjOAUreW2g3HK2w96hxiZOBgPMUpwMCuJ8BZ1/40X4k1J
        rKxKLcqPLyrNSS0+xGgKDOiJzFKiyfnALJFXEm9oamRmZmBpamFqZmShJM5bbPAgXkggPbEk
        NTs1tSC1CKaPiYNTqoGp4MrNKS8E/jPVLZHOr834KVm44HKrJtfKXyUBc48V3iotm21x+W5u
        WqrQpnCpS9JnHa7KfzHM3iUhwzinr+SJSSTf4/TmhAXRHzta2Q/Fvn+xfuqJGRczdty7zeVl
        +kN9bnuv08lAq20Onf6fthoaps9cO1GKq3WV26wTjrfWpC2L7FE70lbJuPG91uwbrcGFfF6+
        Pde4IpQF/YWvbey40rRuQ7E2d3U3S7GD2AJ710e/pE2PiL2/+V9mm2Z4ePAt/uYE91vPUg+J
        n5x5ae6LnRxZl00cT3f1i31bWVzBpRXxIPW7cUr940dyMt9evFt48+KuaH8hsylNMnImPuX6
        ryd22SxneX96b+7Pr9+VWIozEg21mIuKEwHXPLQ7WgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWy7bCSnK5hwb94gx2fLS3+z73NYrHq8XYW
        iznnW1gsvv5fzmLx9NgjdosL2/pYLS60vWK1uLxrDpvFsQViFrs7f7BbvNtyhN3i694uFgce
        jy0rbzJ57Jx1l91jwaZSj02rOtk82q6tYvLY8vs7m8fRPefYPDa1LmH1WP3kB5vH501yAVxR
        XDYpqTmZZalF+nYJXBmzLs1kKlgmWjGr8yJjA+MfgS5GTg4JAROJw0tvsncxcnEICexglLg0
        /wFbFyMHUEJCYtdmV4gaYYn7LUdYIWqeMUo8nLafESTBJqAl8WZWO1hCRGATo8Smw9/BHGaB
        G0wSPx4uYgKpEhLYzihx8YsJiM0pYCuxcFsTK4gtLBArMfvHDWaQbSwCqhJ315WBhHkFLCXe
        /fjJCmELSpyc+YQFxGYW0JbofdjKCGHLS2x/O4cZ4joFiZ9Pl7FCxEUkZne2gcVFBJwkHp75
        xzSBUXgWklGzkIyahWTULCTtCxhZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBMer
        ltYOxj2rPugdYmTiYDzEKMHBrCTCW9T9N16INyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FC
        AumJJanZqakFqUUwWSYOTqkGptCaP78Nbsz9O3nTAkntgurrDzKj+wyPaH4WKObgvvEpi2ES
        w5fnvxSM1ilNXlm0xf9wusxt7cCytbsspvzur3xUmXFo3nzLm2sf1zaLax4V5wy6VL4+aptg
        aoF9GhtnbvbiwPlvpk1kdXme//OCyZa5keduVeb6vcrjuMkp+XH65q1HnginGL1lsHF7myb5
        OOfnn3MBTdxvOMv/F9i2rT20Obvwu0ibok1mE/e9nVr3dp9fn6PCx3zDbdVeQU3hZw7vTNLN
        Wr0jLjteC91rF/EpaCr7ib5ny+pL1n98W8Qi8M5F57RVUuHFR22rDc9kabTsSbu7PeamV2b4
        /O3f3kzcKnGn4ubC7evCW2yvmSmxFGckGmoxFxUnAgAOfVbfRgMAAA==
X-CMS-MailID: 20210113035946epcas2p461e3b34ec59b314eab3dee898b9722de
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210113031405epcas2p265f8a05fd83cf818e8ef4cabd6c687b2
References: <20210112211536.261172-1-alobakin@pm.me>
        <CGME20210113031405epcas2p265f8a05fd83cf818e8ef4cabd6c687b2@epcas2p2.samsung.com>
        <6fb72534-d4d4-94d8-28d1-aabf16e11488@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-13 12:10, Alexander Duyck wrote:
> On 1/12/21 1:16 PM, Alexander Lobakin wrote:
> > Commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") actually
> > not only added a support for fraglisted UDP GRO, but also tweaked
> > some logics the way that non-fraglisted UDP GRO started to work for
> > forwarding too.
> > Tests showed that currently forwarding and NATing of plain UDP GRO
> > packets are performed fully correctly, regardless if the target
> > netdevice has a support for hardware/driver GSO UDP L4 or not.
> > Add the last element and allow to form plain UDP GRO packets if
> > there is no socket -> we are on forwarding path.
> >

Your patch is very similar with the RFC what I submitted but has
different approach. My concern was NAT forwarding.
https://lore.kernel.org/patchwork/patch/1362257/

Nevertheless, I agreed with your idea that allow fraglisted UDP GRO
if there is socket.

> > Plain UDP GRO forwarding even shows better performance than fraglisted
> > UDP GRO in some cases due to not wasting one skbuff_head per every
> > segment.
> >
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >   net/ipv4/udp_offload.c | 5 +++--
> >   1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > index ff39e94781bf..9d71df3d52ce 100644
> > --- a/net/ipv4/udp_offload.c
> > +++ b/net/ipv4/udp_offload.c
> > @@ -460,12 +460,13 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
> >   	if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
> >   		NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;

is_flist can be true even if !sk.

> >
> > -	if ((sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist) {
> > +	if (!sk || (sk && udp_sk(sk)->gro_enabled) ||

Actually sk would be NULL by udp_encap_needed_key in udp4_gro_receive
or udp6_gro_receive.

> > +	    NAPI_GRO_CB(skb)->is_flist) {
> >   		pp = call_gro_receive(udp_gro_receive_segment, head, skb);

udp_gro_receive_segment will check is_flist first and try to do
fraglisted UDP GRO. Can you check what I'm missing?

> >   		return pp;
> >   	}
> >
> 
> The second check for sk in "(sk && udp_sk(sk)->gro_enabled)" is
> redundant and can be dropped. You already verified it is present when
> you checked for !sk before the logical OR.
> 

Sorry, Alexander Duyck. I believe Alexander Lobakin will answer this.

> > -	if (!sk || NAPI_GRO_CB(skb)->encap_mark ||
> > +	if (NAPI_GRO_CB(skb)->encap_mark ||
> >   	    (skb->ip_summed != CHECKSUM_PARTIAL &&
> >   	     NAPI_GRO_CB(skb)->csum_cnt == 0 &&
> >   	     !NAPI_GRO_CB(skb)->csum_valid) ||
> >


