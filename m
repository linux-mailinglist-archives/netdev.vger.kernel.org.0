Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2BD2F7787
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 12:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbhAOLVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 06:21:53 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:10734 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbhAOLVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 06:21:52 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210115112109epoutp0233183ddf1671089073b310911cc0f761~aY_kbPhkN0397203972epoutp02j
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 11:21:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210115112109epoutp0233183ddf1671089073b310911cc0f761~aY_kbPhkN0397203972epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610709669;
        bh=TIZ5+QlzRMhD/RwX4IqcdCtc797876KPO/iwoBLrka8=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=c6jafIG7uR/tAT7oHUR82oBPAS5djFsNJjR6gOqzhuyTWrvw989k6ykTPT8XEa2kv
         bNcnbXn1MVbfTGL9ROl6BcgegiEhUxJIbBZj9TONtaF4nZ8fjTtYk2RwzPCx3Eo3ww
         S+z1NS0PcBLQwg7Cmzk4TITWHTitr69MlkdMsO1g=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210115112108epcas2p3650881c6e6dda44b1e066345a2f30a45~aY_j0U_ok2153521535epcas2p3E;
        Fri, 15 Jan 2021 11:21:08 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.186]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DHJdv08Pjz4x9Pq; Fri, 15 Jan
        2021 11:21:07 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.03.52511.2AA71006; Fri, 15 Jan 2021 20:21:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210115112106epcas2p4bebb0ea08a25b4aa285161b6e8045fff~aY_hpGj3x1850918509epcas2p4n;
        Fri, 15 Jan 2021 11:21:06 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210115112106epsmtrp2792ee62467545d396f9a5d33453cec43~aY_hoNVKe0456404564epsmtrp2k;
        Fri, 15 Jan 2021 11:21:06 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-cb-60017aa2bab1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B3.86.13470.2AA71006; Fri, 15 Jan 2021 20:21:06 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210115112106epsmtip25180b12d6cf7c0367f296757b2df5d6e~aY_hYXimV2857228572epsmtip2b;
        Fri, 15 Jan 2021 11:21:06 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Alexander Lobakin'" <alobakin@pm.me>,
        "'Steffen Klassert'" <steffen.klassert@secunet.com>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        <namkyu78.kim@samsung.com>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Willem de Bruijn'" <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20210115105048.2689-1-alobakin@pm.me>
Subject: RE: [PATCH net] udp: ipv4: manipulate network header of NATed UDP
 GRO fraglist
Date:   Fri, 15 Jan 2021 20:21:06 +0900
Message-ID: <020101d6eb30$84363170$8ca29450$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHB+vDADvusEXIyolmvL0xqzqJZpgH0BKV0AUiOhq0CaVZx5gLGU+OUAgQYe3Kp/uIy8A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLJsWRmVeSWpSXmKPExsWy7bCmue6iKsYEg7dTrCxWPd7OYjHnfAuL
        xYVtfawWl3fNYbNouNPMZnFsgZjF7s4f7Bbvthxht/i6t4vFgdNjy8qbTB4LNpV6bFrVyebR
        dm0Vk8fRPefYPPq2rGL02NS6hNXj8ya5AI6oHJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMD
        Q11DSwtzJYW8xNxUWyUXnwBdt8wcoOuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUp
        OQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5Gf0LelgLLmtUnH/6g6WBcZ9CFyMHh4SAicSn
        K+JdjFwcQgI7GCXOTNrDCOF8YpSYtuIqlPONUeL9pUNADidYx7wLh6ESexklPkw4xQbhvGCU
        +DJ7J1gVm4CWxJtZ7awgO0QEEiUeHMkHqWEW6GaS6LvwgxWkhlPAWGLB3XnsILawQKTE5JY1
        LCA2i4CqxP/LH8Dm8ApYSjTPXMoEYQtKnJz5BKyGWUBeYvvbOcwQFylI/Hy6DGymiECYxI/H
        C6BqRCRmd7YxgyyWEDjAIXH10mqoBheJZS3XoGxhiVfHt7BD2FISn9/tZYMETL1Ea3cMRG8P
        o8SVfRCLJYCOnvWsnRGkhllAU2L9Ln2IcmWJI7eg1vJJdBz+yw4R5pXoaBOCMJUkJn6Jh5gh
        IfHi5GSWCYxKs5D8NQvJX7OQ3D8LYdUCRpZVjGKpBcW56anFRgUmyFG9iRGcbrU8djDOfvtB
        7xAjEwfjIUYJDmYlEd58ZYYEId6UxMqq1KL8+KLSnNTiQ4ymwJCeyCwlmpwPTPh5JfGGpkZm
        ZgaWphamZkYWSuK8RQYP4oUE0hNLUrNTUwtSi2D6mDg4pRqYFm5+9GTKT/M+7X3nf7WHhppt
        4nvpwqs7deLZHpn1H/5M27Sj+gVXVBND/5UdVTznlwh6G207+N7yTG/3/XuezzSmpjfsFfuW
        l/VKco+hWFKieU1hy6vP/Cudp8zpOXRi52+Dq3LnN/K9mj4zrEGlo1t04cnGuh9WYfmLHP7H
        X7/J9yXbdbnzatfunEt+0z4Hel6Q3KAadH7i13efuxU/z0rJUd8lpHknOrVxYfjf3eJB+mUh
        XAyqDLm5GiHyVQxHZqcty2qO/su4WTX35b0FfS9nnsjXunDn0faa9a/5FvFu1a6dtUnULGP5
        ZhVXxwSH9fv+88ZP/qD01PpL4Llv7zOmW56pS59X/Cnu7k+t/0osxRmJhlrMRcWJAKUvSy5A
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWy7bCSvO6iKsYEg5WHJC1WPd7OYjHnfAuL
        xYVtfawWl3fNYbNouNPMZnFsgZjF7s4f7Bbvthxht/i6t4vFgdNjy8qbTB4LNpV6bFrVyebR
        dm0Vk8fRPefYPPq2rGL02NS6hNXj8ya5AI4oLpuU1JzMstQifbsEroz+BT2sBZc1Ks4//cHS
        wLhPoYuRk0NCwERi3oXDjF2MXBxCArsZJR40H2TqYuQASkhI7NrsClEjLHG/5QgriC0k8IxR
        YtYZXxCbTUBL4s2sdrC4iECixKbrD1hB5jALTGSSaO64zwIx9ACTxKfJFxlBqjgFjCUW3J3H
        DmILC4RLfFvTzARiswioSvy//AGshlfAUqJ55lImCFtQ4uTMJywgNrOAtkTvw1ZGCFteYvvb
        OcwQ1ylI/Hy6DOqKMIkfjxdA1YtIzO5sY57AKDwLyahZSEbNQjJqFpKWBYwsqxglUwuKc9Nz
        iw0LDPNSy/WKE3OLS/PS9ZLzczcxgqNPS3MH4/ZVH/QOMTJxMB5ilOBgVhLhzVdmSBDiTUms
        rEotyo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qBKUDm6AfbA06T7nsd
        zf77h6koZW6qxcZVauK/Jh7/PuH2RMujYooZ+c8u9UxmtzuhYjtj0XTJ/cLTRb/v2Va2uCux
        evZxtq0z9soHePSk6dvv4frtn+hzk3+Kiolz1zTe1QtWnXW98ffkAu5jp26IJ0bkzrl56M5E
        XpOCVoYzEQqzcvav6i9aIS3+X+suv87yuGk3jt7hkWGtc5drKJv77MSXZbOviL3X2q1Subto
        8fOFrB0t5nMqaj/yJF1Q/P94+vT2gqafNYvfWRXe9FS+Xyl9/FSLYNjDJ3PFt77dPz+/4/4v
        zo7VTH5uofUimfMFLjBz+B1+tnHVRKbn236+jSuLyBb5l9DwoMD7jYr+ShUlluKMREMt5qLi
        RABc6t80LQMAAA==
X-CMS-MailID: 20210115112106epcas2p4bebb0ea08a25b4aa285161b6e8045fff
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210115061039epcas2p479bc5f3dd3dad5a250c4e0fc42896704
References: <CGME20210115061039epcas2p479bc5f3dd3dad5a250c4e0fc42896704@epcas2p4.samsung.com>
        <1610690304-167832-1-git-send-email-dseok.yi@samsung.com>
        <20210115081243.GM9390@gauss3.secunet.de>
        <01e801d6eb1c$2898c300$79ca4900$@samsung.com>
        <20210115092752.GN9390@gauss3.secunet.de>
        <20210115105048.2689-1-alobakin@pm.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-15 19:51, Alexander Lobakin wrote:
> From: Steffen Klassert <steffen.klassert@secunet.com>
> Date: Fri, 15 Jan 2021 10:27:52 +0100
> 
> > On Fri, Jan 15, 2021 at 05:55:22PM +0900, Dongseok Yi wrote:
> >> On 2021-01-15 17:12, Steffen Klassert wrote:
> >>> On Fri, Jan 15, 2021 at 02:58:24PM +0900, Dongseok Yi wrote:
> >>>> UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> >>>> forwarding. Only the header of head_skb from ip_finish_output_gso ->
> >>>> skb_gso_segment is updated but following frag_skbs are not updated.
> >>>>
> >>>> A call path skb_mac_gso_segment -> inet_gso_segment ->
> >>>> udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> >>>> does not try to update UDP/IP header of the segment list.
> >>>
> >>> We still need to find out why it works for Alexander, but not for you.
> >>> Different usecases?
> >>
> >> This patch is not for
> >> https://lore.kernel.org/patchwork/patch/1364544/
> >> Alexander might want to call udp_gro_receive_segment even when
> >> !sk and ~NETIF_F_GRO_FRAGLIST.
> >
> > Yes, I know. But he said that fraglist GRO + NAT works for him.
> > I want to find out why it works for him, but not for you.
> 
> I found that it worked for me because I advertised fraglist GSO
> support in my driver (and added actual support for xmitting
> fraglists). If so, kernel won't resegment GSO into a list of
> plain packets, so no __udp_gso_segment_list() will be called.
> 
> I think it will break if I disable fraglist GSO feature through
> Ethtool, so I could test your patches.

Thanks for the reply. In my case I enabled NETIF_F_GRO_FRAGLIST on
my driver. It expected that NAT done on each skb of the forwarded
fraglist.

> 
> >>>
> >>> I would not like to add this to a generic codepath. I think we can
> >>> relatively easy copy the full headers in skb_segment_list().
> >>
> >> I tried to copy the full headers with the similar approach, but it
> >> copies length too. Can we keep the length of each skb of the fraglist?
> >
> > Ah yes, good point.
> >
> > Then maybe you can move your approach into __udp_gso_segment_list()
> > so that we dont touch generic code.
> >

Okay, I will move it into __udp_gso_segment_list() on v3.

> >>
> >>>
> >>> I think about something like the (completely untested) patch below:
> >>>
> >>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >>> index f62cae3f75d8..63ae7f79fad7 100644
> >>> --- a/net/core/skbuff.c
> >>> +++ b/net/core/skbuff.c
> >>> @@ -3651,13 +3651,14 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >>>  				 unsigned int offset)
> >>>  {
> >>>  	struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
> >>> +	unsigned int doffset = skb->data - skb_mac_header(skb);
> >>>  	unsigned int tnl_hlen = skb_tnl_header_len(skb);
> >>>  	unsigned int delta_truesize = 0;
> >>>  	unsigned int delta_len = 0;
> >>>  	struct sk_buff *tail = NULL;
> >>>  	struct sk_buff *nskb;
> >>>
> >>> -	skb_push(skb, -skb_network_offset(skb) + offset);
> >>> +	skb_push(skb, doffset);
> >>>
> >>>  	skb_shinfo(skb)->frag_list = NULL;
> >>>
> >>> @@ -3675,7 +3676,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >>>  		delta_len += nskb->len;
> >>>  		delta_truesize += nskb->truesize;
> >>>
> >>> -		skb_push(nskb, -skb_network_offset(nskb) + offset);
> >>> +		skb_push(nskb, doffset);
> >>>
> >>>  		skb_release_head_state(nskb);
> >>>  		 __copy_skb_header(nskb, skb);
> >>> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> >>> index ff39e94781bf..1181398378b8 100644
> >>> --- a/net/ipv4/udp_offload.c
> >>> +++ b/net/ipv4/udp_offload.c
> >>> @@ -190,9 +190,22 @@ EXPORT_SYMBOL(skb_udp_tunnel_segment);
> >>>  static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
> >>>  					      netdev_features_t features)
> >>>  {
> >>> +	struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
> >>>  	unsigned int mss = skb_shinfo(skb)->gso_size;
> >>> +	unsigned int offset;
> >>>
> >>> -	skb = skb_segment_list(skb, features, skb_mac_header_len(skb));
> >>> +	skb_headers_offset_update(list_skb, skb_headroom(list_skb) - skb_headroom(skb));
> >>> +
> >>> +	/* Check for header changes and copy the full header in that case. */
> >>> +	if ((udp_hdr(skb)->dest == udp_hdr(list_skb)->dest) &&
> >>> +	    (udp_hdr(skb)->source == udp_hdr(list_skb)->source) &&
> >>> +	    (ip_hdr(skb)->daddr == ip_hdr(list_skb)->daddr) &&
> >>> +	    (ip_hdr(skb)->saddr == ip_hdr(list_skb)->saddr))
> >>> +		offset = skb_mac_header_len(skb);
> >>> +	else
> >>> +		offset = skb->data - skb_mac_header(skb);
> >>> +
> >>> +	skb = skb_segment_list(skb, features, offset);
> >>>  	if (IS_ERR(skb))
> >>>  		return skb;
> >>>
> >>>
> >>> After that you can apply the CSUM magic in __udp_gso_segment_list().
> 
> I'll test and let you know if it works. If doesn't, I think I'll be
> able to get a working one based on this.
> 
> >> Sorry, I don't know CSUM magic well. Is it used for checksum
> >> incremental update too?
> >
> > With that I meant the checksum updating you did in your patch.

Ah, I see.

> 
> Thanks,
> Al


