Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652D62FCB38
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 07:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbhATG4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 01:56:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:39078 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbhATG43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 01:56:29 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210120065546epoutp04073111da5f8ec0b387d765ec7c532caf~b3lSSaPWa2370723707epoutp04i
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:55:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210120065546epoutp04073111da5f8ec0b387d765ec7c532caf~b3lSSaPWa2370723707epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611125746;
        bh=Y3t1Ru221BzeFTMjn0qEsdpY63KR+oSgn/Go4kpEcyY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=iy56PfdEcbU7A5S5oev5TLdmw+Qu8NONgrRr2o0Qw3hD5xkogOVMyj82VD4T/a7gv
         nl6m0V3c4cnVNVYh9qTgupI0fBmHD2C5MkAAApquAa0/gEnsUGJJKNQbE0m8qFjWOX
         8qmB4fIrohlgdIUg5H3NyNitg+CESdoWJpE0fxTQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210120065546epcas2p2e656b2b6c56ebd7a6a58dbb7be8421a8~b3lR1rx-R0033000330epcas2p2n;
        Wed, 20 Jan 2021 06:55:46 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.187]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DLGWM5B1sz4x9QH; Wed, 20 Jan
        2021 06:55:43 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        22.DD.05262.FE3D7006; Wed, 20 Jan 2021 15:55:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210120065543epcas2p48248b4b8590b6f5c45f93b7048087e05~b3lPSidc81483814838epcas2p4P;
        Wed, 20 Jan 2021 06:55:43 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210120065543epsmtrp196830196692c8e2251f2927c3da8ed43~b3lPRuMJQ0242102421epsmtrp1B;
        Wed, 20 Jan 2021 06:55:43 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-fc-6007d3ef3e46
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A1.4A.13470.FE3D7006; Wed, 20 Jan 2021 15:55:43 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210120065543epsmtip2703a746694828fe5496c77f1efee99d7~b3lPFHBGJ0775007750epsmtip2I;
        Wed, 20 Jan 2021 06:55:43 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Steffen Klassert'" <steffen.klassert@secunet.com>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        "'Alexander Lobakin'" <alobakin@pm.me>, <namkyu78.kim@samsung.com>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        "'Willem de Bruijn'" <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20210118132736.GM3576117@gauss3.secunet.de>
Subject: RE: [PATCH net v2] udp: ipv4: manipulate network header of NATed
 UDP GRO fraglist
Date:   Wed, 20 Jan 2021 15:55:42 +0900
Message-ID: <012d01d6eef9$45516d40$cff447c0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJT4Rp7bAvF1bGeZTYGN+mZAmy16AFN1KutAr+8QJepFb/3kA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHJsWRmVeSWpSXmKPExsWy7bCmhe77y+wJBhfPqFmserydxWLO+RYW
        iwvb+lgtLu+aw2bRcKeZzeLYAjGL3Z0/2C3ebTnCbvF1bxeLA6fHlpU3mTwWbCr12LSqk82j
        7doqJo+je86xefRtWcXosal1CavH501yARxROTYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYG
        hrqGlhbmSgp5ibmptkouPgG6bpk5QNcpKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtS
        cgoMDQv0ihNzi0vz0vWS83OtDA0MjEyBKhNyMtb0GhScN6j4Mm8qawPjNOUuRk4OCQETiZ9f
        drF3MXJxCAnsYJR482sZC4TziVFi9qY1TBDON0aJTQdAHIiW7k1HoKr2MkocfDuHDcJ5wShx
        fPMUNpAqNgEtiTez2llBbBEBc4nVr6aBjWIW2Mok8fDrVBaQBKeApUTj6y2MILawQIzE00md
        YM0sAqoSi9sWgzXzAtWsWzSBDcIWlDg58wlYL7OAgcT7c/OZIWx5ie1v5zBDnKcg8fPpMqBe
        DqDFThIrf2pClIhIzO5sgyrZwyGx9EAMhO0isWfuPkYIW1ji1fEt7BC2lMTL/jZ2kDESAvUS
        rd0xIOdLCPQwSlzZB3GChICxxKxn7YwQNcoSR25BXcYn0XH4L1Qrr0RHmxCEqSQx8Us8RKOE
        xIuTk1kmMCrNQvLWLCRvzULy1iwk9y9gZFnFKJZaUJybnlpsVGCMHNebGMEJV8t9B+OMtx/0
        DjEycTAeYpTgYFYS4W36y5YgxJuSWFmVWpQfX1Sak1p8iNEUGNITmaVEk/OBKT+vJN7Q1MjM
        zMDS1MLUzMhCSZy32OBBvJBAemJJanZqakFqEUwfEwenVANTzgYz/vDt396vPVz0T+i5b/DK
        Xfv04l3FGj0FJnmd7MiJ3/joTE5a5JueR9oG+vN9up8Hz9/AIrvytXLh3mIuoZ4/qyYXWK2K
        Mn0u7GE+Z3HJzKVzBbO+KZgkJav5ue5gfZ6nNo3VYaLyYYGNqnvPfOM5H627R63i6sdMxjKb
        7MDaYhM2wyvaZ86fUDrY4af7wymmSaHF+FzFR7MVnd4+PjOCi4psbP9Z2vXwrHdezTLb8rq4
        /P0bs0+VXzR9f9+B11N9x+UzdhMSjt/bvfLrLjfnlWq9B1kX7JNgzs5uOHnprZf0f897C2ZG
        Xcj68D6tJin790yHzUlVLkU88tf1j6c+23pEv5n3gLvD8S4lluKMREMt5qLiRABKybQKQQQA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsWy7bCSvO77y+wJBr+n8liserydxWLO+RYW
        iwvb+lgtLu+aw2bRcKeZzeLYAjGL3Z0/2C3ebTnCbvF1bxeLA6fHlpU3mTwWbCr12LSqk82j
        7doqJo+je86xefRtWcXosal1CavH501yARxRXDYpqTmZZalF+nYJXBlreg0KzhtUfJk3lbWB
        cZpyFyMnh4SAiUT3piMsXYxcHEICuxklVrUsYe1i5ABKSEjs2uwKUSMscb/lCCtEzTNGiZaj
        n5hBEmwCWhJvZrWzgtgiAuYSq19NYwIpYhbYzSTxtec+M0THEUaJ1w2NYFWcApYSja+3MILY
        wgJREr1t78AmsQioSixuWwxWwwtUs27RBDYIW1Di5MwnLCA2s4CRxLlD+9kgbHmJ7W/nMEOc
        pyDx8+kysKtFBJwkVv7UhCgRkZjd2cY8gVF4FpJJs5BMmoVk0iwkLQsYWVYxSqYWFOem5xYb
        FhjmpZbrFSfmFpfmpesl5+duYgTHnpbmDsbtqz7oHWJk4mA8xCjBwawkwtv0ly1BiDclsbIq
        tSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6pBqZV/7W0VBOusit7nNTz
        vG2kUX8wT9Pwv/OcrkILsx1fGmJlZB/nSllE/E2+rm6pp7dJr8a/87fg3D9y1u+iEoOYHJTd
        ryucm/jgwvzfPSFVYTfnbDznZW5Yvrq1KzR1Wkxlk82uyxf+5PLs7v+yNGVnwOsfc/Vj2W0e
        ZrV9v7Z8y9NgNm233bW+Ze/MXRbbWS88xsayJt68MOyHT9/UHdM3mmkVvGnjXVSQkJ/8MPLG
        hPA1kuFMJ8LjilafOh4/4Vfui9v7nzMum9G4aMXkCWUbfm389Yr5rcK+1p3TzTKOtcgu+quz
        7dJ34U/LmiXzhPds+6v7YM5Ti7NLP8aKiE4tYar5eknyX9kfry1nohcqsRRnJBpqMRcVJwIA
        6K1ZcSwDAAA=
X-CMS-MailID: 20210120065543epcas2p48248b4b8590b6f5c45f93b7048087e05
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2
References: <CGME20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2@epcas2p1.samsung.com>
        <1610716836-140533-1-git-send-email-dseok.yi@samsung.com>
        <20210118132736.GM3576117@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-18 22:27, Steffen Klassert wrote:
> On Fri, Jan 15, 2021 at 10:20:35PM +0900, Dongseok Yi wrote:
> > UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> > forwarding. Only the header of head_skb from ip_finish_output_gso ->
> > skb_gso_segment is updated but following frag_skbs are not updated.
> >
> > A call path skb_mac_gso_segment -> inet_gso_segment ->
> > udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> > does not try to update UDP/IP header of the segment list but copy
> > only the MAC header.
> >
> > Update dport, daddr and checksums of each skb of the segment list
> > in __udp_gso_segment_list. It covers both SNAT and DNAT.
> >
> > Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
> > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > ---
> > v1:
> > Steffen Klassert said, there could be 2 options.
> > https://lore.kernel.org/patchwork/patch/1362257/
> > I was trying to write a quick fix, but it was not easy to forward
> > segmented list. Currently, assuming DNAT only.
> >
> > v2:
> > Per Steffen Klassert request, move the procedure from
> > udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.
> >
> > To Alexander Lobakin, I've checked your email late. Just use this
> > patch as a reference. It support SNAT too, but does not support IPv6
> > yet. I cannot make IPv6 header changes in __udp_gso_segment_list due
> > to the file is in IPv4 directory.
> >
> >  include/net/udp.h      |  2 +-
> >  net/ipv4/udp_offload.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++----
> >  net/ipv6/udp_offload.c |  2 +-
> >  3 files changed, 59 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/net/udp.h b/include/net/udp.h
> > index 877832b..01351ba 100644
> > --- a/include/net/udp.h
> > +++ b/include/net/udp.h
> > @@ -178,7 +178,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
> >  int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
> >
> >  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> > -				  netdev_features_t features);
> > +				  netdev_features_t features, bool is_ipv6);
> >
> >  static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
> >  {
> > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > index ff39e94..c532d3b 100644
> > --- a/net/ipv4/udp_offload.c
> > +++ b/net/ipv4/udp_offload.c
> > @@ -187,8 +187,57 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
> >  }
> >  EXPORT_SYMBOL(skb_udp_tunnel_segment);
> >
> > +static void __udpv4_gso_segment_csum(struct sk_buff *seg,
> > +				     __be32 *oldip, __be32 *newip,
> > +				     __be16 *oldport, __be16 *newport)
> > +{
> > +	struct udphdr *uh = udp_hdr(seg);
> > +	struct iphdr *iph = ip_hdr(seg);
> > +
> > +	if (uh->check) {
> > +		inet_proto_csum_replace4(&uh->check, seg, *oldip, *newip,
> > +					 true);
> > +		inet_proto_csum_replace2(&uh->check, seg, *oldport, *newport,
> > +					 false);
> > +		if (!uh->check)
> > +			uh->check = CSUM_MANGLED_0;
> > +	}
> > +	uh->dest = *newport;
> > +
> > +	csum_replace4(&iph->check, *oldip, *newip);
> > +	iph->daddr = *newip;
> > +}
> 
> Can't we just do the checksum recalculation for this case as it is done
> with standard GRO?

If I understand standard GRO correctly, it calculates full checksum.
Should we adopt the same method to UDP GRO fraglist? I did not find
a simple method for the incremental checksum update.

> 
> > +
> > +static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
> > +{
> > +	struct sk_buff *seg;
> > +	struct udphdr *uh, *uh2;
> > +	struct iphdr *iph, *iph2;
> > +
> > +	seg = segs;
> > +	uh = udp_hdr(seg);
> > +	iph = ip_hdr(seg);
> > +
> > +	while ((seg = seg->next)) {
> > +		uh2 = udp_hdr(seg);
> > +		iph2 = ip_hdr(seg);
> > +
> > +		if (uh->source != uh2->source || iph->saddr != iph2->saddr)
> > +			__udpv4_gso_segment_csum(seg,
> > +						 &iph2->saddr, &iph->saddr,
> > +						 &uh2->source, &uh->source);
> > +
> > +		if (uh->dest != uh2->dest || iph->daddr != iph2->daddr)
> > +			__udpv4_gso_segment_csum(seg,
> > +						 &iph2->daddr, &iph->daddr,
> > +						 &uh2->dest, &uh->dest);
> > +	}
> 
> You don't need to check the addresses and ports of all packets in the
> segment list. If the addresses and ports are equal for the first and
> second packet in the list, then this also holds for the rest of the
> packets.

I think we can try this with an additional flag (seg_csum).

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 36b7e30..3f892df 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -213,25 +213,36 @@ static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
        struct sk_buff *seg;
        struct udphdr *uh, *uh2;
        struct iphdr *iph, *iph2;
+       bool seg_csum = false;

        seg = segs;
        uh = udp_hdr(seg);
        iph = ip_hdr(seg);

-       while ((seg = seg->next)) {
+       seg = seg->next;
+       do {
+               if (!seg)
+                       break;
+
                uh2 = udp_hdr(seg);
                iph2 = ip_hdr(seg);

-               if (uh->source != uh2->source || iph->saddr != iph2->saddr)
+               if (uh->source != uh2->source || iph->saddr != iph2->saddr) {
                        __udpv4_gso_segment_csum(seg,
                                                 &iph2->saddr, &iph->saddr,
                                                 &uh2->source, &uh->source);
+                       seg_csum = true;
+               }

-               if (uh->dest != uh2->dest || iph->daddr != iph2->daddr)
+               if (uh->dest != uh2->dest || iph->daddr != iph2->daddr) {
                        __udpv4_gso_segment_csum(seg,
                                                 &iph2->daddr, &iph->daddr,
                                                 &uh2->dest, &uh->dest);
-       }
+                       seg_csum = true;
+               }
+
+               seg = seg->next;
+       } while (seg_csum);

        return segs;
 }

