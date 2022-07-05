Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934DE567533
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 19:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbiGERIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 13:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiGERIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 13:08:15 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F441CB3E;
        Tue,  5 Jul 2022 10:08:12 -0700 (PDT)
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 265H7Vjn005429;
        Tue, 5 Jul 2022 19:07:37 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id AA5521208B1;
        Tue,  5 Jul 2022 19:07:27 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1657040848; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uGknwfi4mUIiVYFG08ndrGES0RIjrZCfTG6jqpQqgRY=;
        b=xBw2n77HWtkLu0JTOI/QgjTst019m9LojXkvuTraHswS+s4tnjzulF6UW4OJcCJcDfwuZZ
        6QWUvXiHW2AnovBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1657040848; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uGknwfi4mUIiVYFG08ndrGES0RIjrZCfTG6jqpQqgRY=;
        b=HS9hvTOi81xchdZ2mg65uPIyE2ADuS1ePP8GpwzhRuSGGX5Y52d+rkxv9IcaL1fUDhgSE2
        7eE4Mv1TgN4tobRQnnRwpha8+xD+FKqgKm4dkFGL9/BceTKIv/SJhEZvoTjl6mRAZHNleu
        TqmsyDiislLSgwclGH0Ozxntgw9Q7tvFfaDv8e7Kn0c6tL+VQxfeL8kQRiJ+YsebkgPMEn
        AyeAuemFR28ZuqlsnRT6hUyWpuvCq/dIwP9GhWvUvWCFDlmThMtlsCfiYqtFDWW1cV/5T2
        ivVOwOyw/RzbUN83DaSq2n/tN1HgbZ5zWzAsQ0ERyzLKMZm95blEZbyTMVHOmQ==
Date:   Tue, 5 Jul 2022 19:07:27 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Anton Makarov <anton.makarov11235@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next v4 1/4] seg6: add support for SRv6 H.Encaps.Red
 behavior
Message-Id: <20220705190727.69d532417be7438b15404ee1@uniroma2.it>
In-Reply-To: <cd046e93a9783be5944cf15974afa534c94fb15e.camel@redhat.com>
References: <20220701150152.24103-1-andrea.mayer@uniroma2.it>
        <20220701150152.24103-2-andrea.mayer@uniroma2.it>
        <cd046e93a9783be5944cf15974afa534c94fb15e.camel@redhat.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,
please see my answers inline, thanks.

On Tue, 05 Jul 2022 09:33:16 +0200
Paolo Abeni <pabeni@redhat.com> wrote:

> On Fri, 2022-07-01 at 17:01 +0200, Andrea Mayer wrote:
> > The SRv6 H.Encaps.Red behavior described in [1] is an optimization of
> > the SRv6 H.Encaps behavior [2].
> > 
> > H.Encaps.Red reduces the length of the SRH by excluding the first
> > segment (SID) in the SRH of the pushed IPv6 header. The first SID is
> > only placed in the IPv6 Destination Address field of the pushed IPv6
> > header.
> > When the SRv6 Policy only contains one SID the SRH is omitted, unless
> > there is an HMAC TLV to be carried.
> > 
> > [1] - https://datatracker.ietf.org/doc/html/rfc8986#section-5.2
> > [2] - https://datatracker.ietf.org/doc/html/rfc8986#section-5.1
> > 
> > Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> > Signed-off-by: Anton Makarov <anton.makarov11235@gmail.com>
> > ---
> >  include/uapi/linux/seg6_iptunnel.h |   1 +
> >  net/ipv6/seg6_iptunnel.c           | 126 ++++++++++++++++++++++++++++-
> >  2 files changed, 126 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/uapi/linux/seg6_iptunnel.h b/include/uapi/linux/seg6_iptunnel.h
> > index eb815e0d0ac3..538152a7b2c3 100644
> > --- a/include/uapi/linux/seg6_iptunnel.h
> > +++ b/include/uapi/linux/seg6_iptunnel.h
> > @@ -35,6 +35,7 @@ enum {
> >  	SEG6_IPTUN_MODE_INLINE,
> >  	SEG6_IPTUN_MODE_ENCAP,
> >  	SEG6_IPTUN_MODE_L2ENCAP,
> > +	SEG6_IPTUN_MODE_ENCAP_RED,
> >  };
> >  
> >  #endif
> > diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
> > index d64855010948..4942073650d3 100644
> > --- a/net/ipv6/seg6_iptunnel.c
> > +++ b/net/ipv6/seg6_iptunnel.c
> > @@ -36,6 +36,7 @@ static size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
> >  	case SEG6_IPTUN_MODE_INLINE:
> >  		break;
> >  	case SEG6_IPTUN_MODE_ENCAP:
> > +	case SEG6_IPTUN_MODE_ENCAP_RED:
> >  		head = sizeof(struct ipv6hdr);
> >  		break;
> >  	case SEG6_IPTUN_MODE_L2ENCAP:
> > @@ -195,6 +196,122 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
> >  }
> >  EXPORT_SYMBOL_GPL(seg6_do_srh_encap);
> >  
> > +/* encapsulate an IPv6 packet within an outer IPv6 header with reduced SRH */
> > +static int seg6_do_srh_encap_red(struct sk_buff *skb,
> > +				 struct ipv6_sr_hdr *osrh, int proto)
> > +{
> > +	__u8 first_seg = osrh->first_segment;
> > +	struct dst_entry *dst = skb_dst(skb);
> > +	struct net *net = dev_net(dst->dev);
> > +	struct ipv6hdr *hdr, *inner_hdr;
> > +	int hdrlen = ipv6_optlen(osrh);
> > +	int red_tlv_offset, tlv_offset;
> > +	struct ipv6_sr_hdr *isrh;
> > +	bool skip_srh = false;
> > +	__be32 flowlabel;
> > +	int tot_len, err;
> > +	int red_hdrlen;
> > +	int tlvs_len;
> > +
> > +	if (first_seg > 0) {
> > +		red_hdrlen = hdrlen - sizeof(struct in6_addr);
> > +	} else {
> > +		/* NOTE: if tag/flags and/or other TLVs are introduced in the
> > +		 * seg6_iptunnel infrastructure, they should be considered when
> > +		 * deciding to skip the SRH.
> > +		 */
> > +		skip_srh = !sr_has_hmac(osrh);
> > +
> > +		red_hdrlen = skip_srh ? 0 : hdrlen;
> > +	}
> > +
> > +	tot_len = red_hdrlen + sizeof(struct ipv6hdr);
> > +
> > +	err = skb_cow_head(skb, tot_len + skb->mac_len);
> > +	if (unlikely(err))
> > +		return err;
> > +
> > +	inner_hdr = ipv6_hdr(skb);
> > +	flowlabel = seg6_make_flowlabel(net, skb, inner_hdr);
> > +
> > +	skb_push(skb, tot_len);
> > +	skb_reset_network_header(skb);
> > +	skb_mac_header_rebuild(skb);
> > +	hdr = ipv6_hdr(skb);
> > +
> > +	/* based on seg6_do_srh_encap() */
> > +	if (skb->protocol == htons(ETH_P_IPV6)) {
> > +		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr)),
> > +			     flowlabel);
> > +		hdr->hop_limit = inner_hdr->hop_limit;
> > +	} else {
> > +		ip6_flow_hdr(hdr, 0, flowlabel);
> > +		hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));
> > +
> > +		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
> > +		IP6CB(skb)->iif = skb->skb_iif;
> > +	}
> > +
> > +	/* no matter if we have to skip the SRH or not, the first segment
> > +	 * always comes in the pushed IPv6 header.
> > +	 */
> > +	hdr->daddr = osrh->segments[first_seg];
> > +
> > +	if (skip_srh) {
> > +		hdr->nexthdr = proto;
> > +
> > +		set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
> > +		goto out;
> > +	}
> > +
> > +	/* we cannot skip the SRH, slow path */
> > +
> > +	hdr->nexthdr = NEXTHDR_ROUTING;
> > +	isrh = (void *)hdr + sizeof(struct ipv6hdr);
> > +
> > +	if (unlikely(!first_seg)) {
> > +		/* this is a very rare case; we have only one SID but
> > +		 * we cannot skip the SRH since we are carrying some
> > +		 * other info.
> > +		 */
> > +		memcpy(isrh, osrh, hdrlen);
> > +		goto srcaddr;
> > +	}
> > +
> > +	tlv_offset = sizeof(*osrh) + (first_seg + 1) * sizeof(struct in6_addr);
> > +	red_tlv_offset = tlv_offset - sizeof(struct in6_addr);
> > +
> > +	memcpy(isrh, osrh, red_tlv_offset);
> > +
> > +	tlvs_len = hdrlen - tlv_offset;
> > +	if (unlikely(tlvs_len > 0)) {
> > +		const void *s = (const void *)osrh + tlv_offset;
> > +		void *d = (void *)isrh + red_tlv_offset;
> > +
> > +		memcpy(d, s, tlvs_len);
> > +	}
> > +
> > +	--isrh->first_segment;
> > +	isrh->hdrlen -= 2;
> > +
> > +srcaddr:
> > +	isrh->nexthdr = proto;
> > +	set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
> > +
> > +#ifdef CONFIG_IPV6_SEG6_HMAC
> > +	if (unlikely(!skip_srh && sr_has_hmac(isrh))) {
> > +		err = seg6_push_hmac(net, &hdr->saddr, isrh);
> > +		if (unlikely(err))
> > +			return err;
> > +	}
> > +#endif
> > +
> > +out:
> > +	skb_postpush_rcsum(skb, hdr, tot_len);
> 
> It looks like, at this point hdr->payload_len is not initialized yet -
> it will be set later by the caller. So the above will corrupt the
> checksum complete.
> 

very good catch, thanks.

> I think the solution is moving 'payload_len' initialization before the
> csum update. Note that 'seg6_do_srh_encap' has a similar issue.
> 

Yes, but for doing this, we need to fix an issue which is pre-existing to my
patch.

Taking a look at the code, I saw that the function 'seg6_do_srh_inline()'
is also affected by the same problem.
Specifically, it looks like this issue is present from the beginning, i.e.:
commit 6c8702c60b88 ("ipv6: sr: add support for SRH encapsulation and injection
with lwtunnels").

Therefore in a different patch, I will fix the 'seg6_do_srh()' code by moving
the 'payload_len' initialization inside both seg6_do_srh_{encap,inline}
functions (and before updating the csum, as you suggested).
Since these functions are exported globally, we should also take
care of the callers that will no longer have to initialize the 'payload_len' on
their own.

In the new patch, I will credit you for having caught this bug (i.e.
Reported-by tag) as well as I will add the link to this thread (i.e. Link tag)
for documentation purposes.

Once we have fixed this issue, I will send an up-to-date v5; do you agree with
this plan?

Ciao,
Andrea
