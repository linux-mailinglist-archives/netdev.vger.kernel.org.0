Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1C754771D
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 20:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiFKSYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 14:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiFKSYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 14:24:21 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113791DA4D
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 11:24:18 -0700 (PDT)
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 25BINdhP016137;
        Sat, 11 Jun 2022 20:23:45 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 8CE1F12097E;
        Sat, 11 Jun 2022 20:23:35 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1654971815; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2qrciiX06hlNgkiyzAXQfGTRsBJYY7mQ+OqUXFOraqM=;
        b=mt2H7AxRs5hTUcDvxFv342labciTJaLkr7SgtQl6qoOyEuGQbQwLim4M8MpkSE5k88kRyB
        n8D/8XC359KVZwDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1654971815; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2qrciiX06hlNgkiyzAXQfGTRsBJYY7mQ+OqUXFOraqM=;
        b=P0io6zd4yFXyZ0mv3ECgC00ZmF9QZJAzZxTCBOoea7ZADukzUQSjZzXJPmNmb1xSeo/yuG
        OHmAJQ31KpXPjLOnxZl54hsbdbzNyghqQGSCPB/UY/NuHX2BgEdM+Ls1ewil/mqxfD2LkD
        byMtNJd4jRMlFJSMKZ2l9d3OC0Jgpw85T7RnhDy4E6d4lgXYUwT99k2/bGGgEM0ohXUEPn
        Q96XDMEVB8pK2L5FUd9A3PlCJkoKVnl9oYpenosWHMmmgLyIk8PnhCAuiDCjCvJY+QIKRA
        4hqblojUsYZO+dA93x3OmGtHsvXEX0GerkSOnNTCsEkXi0q904fnvHTZia2keg==
Date:   Sat, 11 Jun 2022 20:23:35 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Anton Makarov <antonmakarov11235@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next v2 1/1] net: seg6: Add support for SRv6 Headend
 Reduced Encapsulation
Message-Id: <20220611202335.c24dc8e4dbb0f030a454a19e@uniroma2.it>
In-Reply-To: <20220610212108.ed54aa540f4b01d4018b04ee@gmail.com>
References: <20220609132750.4917-1-anton.makarov11235@gmail.com>
        <20220610135958.cb99b9122925b62eba634337@uniroma2.it>
        <20220610212108.ed54aa540f4b01d4018b04ee@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Anton,
please consider my answers below. Thanks.

On Fri, 10 Jun 2022 21:21:08 +0300
Anton Makarov <antonmakarov11235@gmail.com> wrote:

> Hi Andrea,
> Thank you very much for your feedback! Plese look at my response inline
> and let me know what you think about that. Many thanks!
> 

you are welcome!

> 
> > 
> > > +	if (osrh->first_segment > 0)
> > > +		hdrlen = (osrh->hdrlen - 1) << 3;
> > > +
> > > +	tot_len = hdrlen + sizeof(struct ipv6hdr);
> > > +
> > > +	err = skb_cow_head(skb, tot_len + skb->mac_len);
> > > +	if (unlikely(err))
> > > +		return err;
> > > +
> > > +	inner_hdr6 = ipv6_hdr(skb);
> > > +	inner_hdr4 = ip_hdr(skb);
> > 
> > inner_hdr4 is only used in the *if* block that follows later on.
> 
> Do you mean it has to be defined inside *if* block and assigned via
> inner_ip_hdr()?
> 

I think it is correct to define inner_hdr4 as you have already done, but
initialize and use it only within the *else if* block (the IPv4 one, of
course), as it is no further accessed outside.

> > > +	IP6CB(skb)->iif = skb->skb_iif;
> > > +
> > > +	if (skb->protocol == htons(ETH_P_IPV6)) {
> > > +		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr6)),
> > > +			     flowlabel);
> > > +		hdr->hop_limit = inner_hdr6->hop_limit;
> > > +	} else if (skb->protocol == htons(ETH_P_IP)) {
> > > +		ip6_flow_hdr(hdr, (unsigned int) inner_hdr4->tos, flowlabel);
> > > +		hdr->hop_limit = inner_hdr4->ttl;
> > > +	}
> > > +
> > 
> > Don't IPv4 and IPv6 cover all possible cases?
> 
> In fact while case SEG6_IPTUN_MODE_ENCAP in seg6_do_srh() does
> preliminary check of protocol value, case SEG6_IPTUN_MODE_L2ENCAP does
> not. So potentially skb->protocol can be of any value. Although
> additional check brings extra impact on performance, sure.
> 

If you fill the pushed IPv6 header in the same way as is done in
seg6_do_srh_encap(), I don't think you need to provide other checks
on skb->protocol (thus avoiding the *if else if* in favor of only *if else*).

In your solution, if the protocol is neither IP6 nor IP4, then the pushed
IPv6 header is partially initialized. In particular, it seems to me that the
traffic class, flow label, and hop limit are not set anywhere else.

> > 
> > > +	skb->protocol = htons(ETH_P_IPV6);
> > > +

This seems to be redundant, since in seg6_do_srh() the protocol is set after
calling the seg6_do_srh_encap{_red}() functions.

> > > +	hdr->daddr = osrh->segments[osrh->first_segment];
> > > +	hdr->version = 6;
> > > +
> > > +	if (osrh->first_segment > 0) {
> > > +		hdr->nexthdr = NEXTHDR_ROUTING;
> > > +
> > > +		isrh = (void *)hdr + sizeof(struct ipv6hdr);
> > > +		memcpy(isrh, osrh, hdrlen);
> > > +
> > > +		isrh->nexthdr = proto;
> > > +		isrh->first_segment--;
> > > +		isrh->hdrlen -= 2;
> > > +	} else {
> > > +		hdr->nexthdr = proto;
> > > +	}
> > > +
> > > +	set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
> > > +
> > > +#ifdef CONFIG_IPV6_SEG6_HMAC
> > > +	if (osrh->first_segment > 0 && sr_has_hmac(isrh)) {
> > > +		err = seg6_push_hmac(net, &hdr->saddr, isrh);
> > > +		if (unlikely(err))
> > > +			return err;
> > > +	}
> > > +#endif
> > > +
> > 
> > When there is only one SID and HMAC is configured, the SRH is not kept.
> > Aren't we losing information this way?
> 
> Yes, but HMAC is just an optional part of SRH. RFC 8986 allows us to
> omit entire SRH in reduced encapsulation when the SRv6 Policy only
> contains one segment. 
> And it seems to be the most usefull approach as
> far as:
> 1) About all hardware implementations do not procede HMAC at all
> 2) Too many networking guys have a great concern about huge overhead of
> SRv6 in compare with MPLS, so they are not happy to get extra 256 bits
> 3) If one consider HMAC mandatory then there is still basic (not
> reduced) encapsulation option
> 
> What do you think about it?
> 

Thanks for the explanation.

However, considering the RFC 8986 Section 5.2:
  "The push of the SRH MAY be omitted when the SRv6 Policy only contains one
   segment and there is no need to use any flag, tag, or TLV."

Hence, if a user needs to use HMAC (rare case) or any other type of supported
flags, tags and TLVs, then the SRH should not be removed, even if there is
only one SID.

Andrea
