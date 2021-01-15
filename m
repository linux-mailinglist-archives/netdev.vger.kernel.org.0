Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944E02F74C1
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 09:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbhAOI4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 03:56:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47893 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbhAOI4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 03:56:12 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210115085527epoutp025ae62db686ec0d1af30e63ad4f9644f6~aW-WdpdML2826328263epoutp02E
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:55:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210115085527epoutp025ae62db686ec0d1af30e63ad4f9644f6~aW-WdpdML2826328263epoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610700927;
        bh=IqVrX+Tp8ndGHkugTbkr66bB1OgtIDaxDWy+ZClRjBY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=caGQvW94GWLPrZREStExpkhlnik0D2W0bbQTTlhXIQRpC4wR9xN5zjMStusaj+aS5
         UWMK2UYZRC4FZ5hQy0aY6Tuxo0YjWuvL4CjChk8QcXShx4mRsuH2aP81z9YK5vjxyW
         DNZxVWm2nktSEG4XcCoUVxqmIFJJiWh+az9Mupfk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210115085526epcas2p3d12671f58c9e78b5ca0a0f24b76865f7~aW-WCDTIq0199201992epcas2p39;
        Fri, 15 Jan 2021 08:55:26 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.189]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DHFPm6775z4x9Q2; Fri, 15 Jan
        2021 08:55:24 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        B9.5B.52511.B7851006; Fri, 15 Jan 2021 17:55:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210115085522epcas2p44dc2a3a7562b9f07b10ba1d90778c560~aW-SfckKP2509325093epcas2p4r;
        Fri, 15 Jan 2021 08:55:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210115085522epsmtrp12eddf51fe4b4a3f2fc6c22430de63bc9~aW-SeIdB_0654006540epsmtrp1U;
        Fri, 15 Jan 2021 08:55:22 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-bb-6001587b3397
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        01.AB.08745.A7851006; Fri, 15 Jan 2021 17:55:22 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210115085522epsmtip28248144767b8286cb400ae4de5b926df~aW-SNP_hB2340323403epsmtip25;
        Fri, 15 Jan 2021 08:55:22 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Steffen Klassert'" <steffen.klassert@secunet.com>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        <namkyu78.kim@samsung.com>, "'Alexander Lobakin'" <alobakin@pm.me>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Willem de Bruijn'" <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20210115081243.GM9390@gauss3.secunet.de>
Subject: RE: [PATCH net] udp: ipv4: manipulate network header of NATed UDP
 GRO fraglist
Date:   Fri, 15 Jan 2021 17:55:22 +0900
Message-ID: <01e801d6eb1c$2898c300$79ca4900$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHB+vDADvusEXIyolmvL0xqzqJZpgH0BKV0AUiOhq2qOFUG4A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPJsWRmVeSWpSXmKPExsWy7bCmmW51BGOCwerfIharHm9nsZhzvoXF
        4sK2PlaLy7vmsFk03Glmszi2QMxid+cPdot3W46wW3zd28XiwOmxZeVNJo8Fm0o9Nq3qZPNo
        u7aKyePonnNsHn1bVjF6bGpdwurxeZNcAEdUjk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmB
        oa6hpYW5kkJeYm6qrZKLT4CuW2YO0HVKCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKU
        nAJDwwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjH9vnrMUvDCsuN65ibGBcY16FyMnh4SAiUTD
        rLmsILaQwA5GiTtPI7oYuYDsT4wSDbcXsEI4nxklVr+5wwjT8fJUDyNEYhejxL2F56CqXjBK
        tL3/xgZSxSagJfFmVjvYXBEBc4nVr6YxgRQxC2xlkrg07zwzSIJTwEzi3pmdYEXCApESk1vW
        sHQxcnCwCKhKPJolCBLmFbCU+Lp0DjOELShxcuYTFhCbWcBA4v25+cwQtrzE9rcQNRICChI/
        ny6D2usksWHuR6h6EYnZnW3MIDdICOzhkHhw5zcTRIOLxLvjLVDNwhKvjm9hh7ClJF72t7GD
        3CMhUC/R2h0D0dvDKHFlH8QREgLGErOetTNC1ChLHLkFtYtPouPwX6hWXomONiEIU0li4pd4
        iEYJiRcnJ7NMYFSaheSxWUgem4XksVlIHljAyLKKUSy1oDg3PbXYqMAEObI3MYJTrpbHDsbZ
        bz/oHWJk4mA8xCjBwawkwpuvzJAgxJuSWFmVWpQfX1Sak1p8iNEUGNQTmaVEk/OBST+vJN7Q
        1MjMzMDS1MLUzMhCSZy3yOBBvJBAemJJanZqakFqEUwfEwenVAOT8W3FN88XrP4j5Fzyxr3c
        YWLg0WlR6q3NZRtfLd8dvHBt1qEXqgH3rkx/KJ2Z3hGus/oFg1ebeej+2ypmYW4fI5zlelgr
        Wy5tbOrV/b//r8CzxXNWx8ytO/b63a2/k+qX9Rly/lmY1/6522pSfKbHqbNsjyPfLp+ftDng
        hkNgXq0t43SHa8HlEZN6bv5wPvzzQeThUw1PO9VkHZ05qqexukUUxX3dKuknLx1k1uep3vJ0
        44q9x575i8ZKf9+8h6kg0+HevuNqKZIay+v9q1Za35z9dn6rnc26K3k2p3bNvR/HKuV6edMM
        rt9lpeFpCws3MfaazTBgPeHj7sGqrV/h1CEn0LLylhubbb/hLjMlluKMREMt5qLiRABKaAL+
        QgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWy7bCSvG5VBGOCQe8lPYtVj7ezWMw538Ji
        cWFbH6vF5V1z2Cwa7jSzWRxbIGaxu/MHu8W7LUfYLb7u7WJx4PTYsvImk8eCTaUem1Z1snm0
        XVvF5HF0zzk2j74tqxg9NrUuYfX4vEkugCOKyyYlNSezLLVI3y6BK+Pfm+csBS8MK653bmJs
        YFyj3sXIySEhYCLx8lQPYxcjF4eQwA5GiYlbNjF1MXIAJSQkdm12hagRlrjfcoQVouYZo8TS
        Fa+ZQBJsAloSb2a1s4LYIgLmEqtfTWMCKWIW2M0kMevifnaIjoOMEpv2fGEHqeIUMJO4d2Yn
        WIewQLjEtzXNYNtYBFQlHs0SBAnzClhKfF06hxnCFpQ4OfMJC4jNLGAkce7QfjYIW15i+1uI
        GgkBBYmfT5dBHeEksWHuR6h6EYnZnW3MExiFZyEZNQvJqFlIRs1C0rKAkWUVo2RqQXFuem6x
        YYFRXmq5XnFibnFpXrpecn7uJkZw9Glp7WDcs+qD3iFGJg7GQ4wSHMxKIrz5ygwJQrwpiZVV
        qUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTCtmTWhg9eu77voo0+u
        JzhbpK9F/Re6sU1jxrLluw023nqxakWyqNl+tfm7z33P7bp7vevcS8bpu3Pd1zevX+O1M6z4
        v+SHa4Z1fb/mVxcdCr1aLz/V6Mqaxw+r70iV2C8MWZ7VZPtfUv7zk6f8/1RC9q16HdpjM+NV
        w+x1hq1yfuL1y6w/CpioJ5lm/lku/dz15pVIm6rO0kdyF4JPLLvu9YGz+sREf96VAdOas6eX
        3JndIx6i3l+3RvX7s6Tde37cYD/5yfTzzHjW69U8SdYizuWz+uJjzuy/2dGe5C/G/ShlaXNi
        2P9J1zc/YWvjnCxyU9HoRcKyOvt384/xCM1pmloWuyd5heQrxeitGQ+zlFiKMxINtZiLihMB
        fYVCMS0DAAA=
X-CMS-MailID: 20210115085522epcas2p44dc2a3a7562b9f07b10ba1d90778c560
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210115061039epcas2p479bc5f3dd3dad5a250c4e0fc42896704
References: <CGME20210115061039epcas2p479bc5f3dd3dad5a250c4e0fc42896704@epcas2p4.samsung.com>
        <1610690304-167832-1-git-send-email-dseok.yi@samsung.com>
        <20210115081243.GM9390@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-15 17:12, Steffen Klassert wrote:
> On Fri, Jan 15, 2021 at 02:58:24PM +0900, Dongseok Yi wrote:
> > UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> > forwarding. Only the header of head_skb from ip_finish_output_gso ->
> > skb_gso_segment is updated but following frag_skbs are not updated.
> >
> > A call path skb_mac_gso_segment -> inet_gso_segment ->
> > udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> > does not try to update UDP/IP header of the segment list.
> 
> We still need to find out why it works for Alexander, but not for you.
> Different usecases?

This patch is not for
https://lore.kernel.org/patchwork/patch/1364544/
Alexander might want to call udp_gro_receive_segment even when
!sk and ~NETIF_F_GRO_FRAGLIST.

> 
> We copy only the MAC header in skb_segment_list(), so I think
> this is a valid bug when NAT changed the UDP header.
> 
> >
> > Update dport, daddr and checksums of each skb of the segment list
> > after __udp_gso_segment.
> >
> > Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
> > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > ---
> > Steffen Klassert said, there could be 2 options.
> > https://lore.kernel.org/patchwork/patch/1362257/
> >
> > I was trying to write a quick fix, but it was not easy to forward
> > segmented list. Currently, assuming DNAT only. Should we consider
> > SNAT too?
> 
> If it is broken, then it is broken for both, so yes.

Okay.

> 
> >
> >  net/ipv4/udp_offload.c | 45 +++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 41 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > index ff39e94..7e24928 100644
> > --- a/net/ipv4/udp_offload.c
> > +++ b/net/ipv4/udp_offload.c
> > @@ -309,10 +309,12 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
> >  					 netdev_features_t features)
> >  {
> >  	struct sk_buff *segs = ERR_PTR(-EINVAL);
> > +	struct sk_buff *seg;
> >  	unsigned int mss;
> >  	__wsum csum;
> > -	struct udphdr *uh;
> > -	struct iphdr *iph;
> > +	struct udphdr *uh, *uh2;
> > +	struct iphdr *iph, *iph2;
> > +	bool is_fraglist = false;
> >
> >  	if (skb->encapsulation &&
> >  	    (skb_shinfo(skb)->gso_type &
> > @@ -327,8 +329,43 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
> >  	if (!pskb_may_pull(skb, sizeof(struct udphdr)))
> >  		goto out;
> >
> > -	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
> > -		return __udp_gso_segment(skb, features);
> > +	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
> > +		if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST)
> > +			is_fraglist = true;
> > +
> > +		segs = __udp_gso_segment(skb, features);
> > +		if (IS_ERR_OR_NULL(segs) || !is_fraglist)
> > +			return segs;
> > +
> > +		seg = segs;
> > +		uh = udp_hdr(seg);
> > +		iph = ip_hdr(seg);
> > +
> > +		while ((seg = seg->next)) {
> > +			uh2 = udp_hdr(seg);
> > +			iph2 = ip_hdr(seg);
> > +
> > +			if (uh->dest == uh2->dest && iph->daddr == iph2->daddr)
> > +				continue;
> > +
> > +			if (uh2->check) {
> > +				inet_proto_csum_replace4(&uh2->check, seg,
> > +							 iph2->daddr,
> > +							 iph->daddr, true);
> > +				inet_proto_csum_replace2(&uh2->check, seg,
> > +							 uh2->dest, uh->dest,
> > +							 false);
> > +				if (!uh2->check)
> > +					uh2->check = CSUM_MANGLED_0;
> > +			}
> > +			uh2->dest = uh->dest;
> > +
> > +			csum_replace4(&iph2->check, iph2->daddr, iph->daddr);
> > +			iph2->daddr = iph->daddr;
> > +		}
> > +
> > +		return segs;
> > +	}
> 
> I would not like to add this to a generic codepath. I think we can
> relatively easy copy the full headers in skb_segment_list().

I tried to copy the full headers with the similar approach, but it
copies length too. Can we keep the length of each skb of the fraglist?

> 
> I think about something like the (completely untested) patch below:
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f62cae3f75d8..63ae7f79fad7 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3651,13 +3651,14 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>  				 unsigned int offset)
>  {
>  	struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
> +	unsigned int doffset = skb->data - skb_mac_header(skb);
>  	unsigned int tnl_hlen = skb_tnl_header_len(skb);
>  	unsigned int delta_truesize = 0;
>  	unsigned int delta_len = 0;
>  	struct sk_buff *tail = NULL;
>  	struct sk_buff *nskb;
> 
> -	skb_push(skb, -skb_network_offset(skb) + offset);
> +	skb_push(skb, doffset);
> 
>  	skb_shinfo(skb)->frag_list = NULL;
> 
> @@ -3675,7 +3676,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>  		delta_len += nskb->len;
>  		delta_truesize += nskb->truesize;
> 
> -		skb_push(nskb, -skb_network_offset(nskb) + offset);
> +		skb_push(nskb, doffset);
> 
>  		skb_release_head_state(nskb);
>  		 __copy_skb_header(nskb, skb);
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index ff39e94781bf..1181398378b8 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -190,9 +190,22 @@ EXPORT_SYMBOL(skb_udp_tunnel_segment);
>  static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
>  					      netdev_features_t features)
>  {
> +	struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
>  	unsigned int mss = skb_shinfo(skb)->gso_size;
> +	unsigned int offset;
> 
> -	skb = skb_segment_list(skb, features, skb_mac_header_len(skb));
> +	skb_headers_offset_update(list_skb, skb_headroom(list_skb) - skb_headroom(skb));
> +
> +	/* Check for header changes and copy the full header in that case. */
> +	if ((udp_hdr(skb)->dest == udp_hdr(list_skb)->dest) &&
> +	    (udp_hdr(skb)->source == udp_hdr(list_skb)->source) &&
> +	    (ip_hdr(skb)->daddr == ip_hdr(list_skb)->daddr) &&
> +	    (ip_hdr(skb)->saddr == ip_hdr(list_skb)->saddr))
> +		offset = skb_mac_header_len(skb);
> +	else
> +		offset = skb->data - skb_mac_header(skb);
> +
> +	skb = skb_segment_list(skb, features, offset);
>  	if (IS_ERR(skb))
>  		return skb;
> 
> 
> After that you can apply the CSUM magic in __udp_gso_segment_list().

Sorry, I don't know CSUM magic well. Is it used for checksum
incremental update too?

