Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7DE2870B7
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgJHIaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbgJHIaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 04:30:46 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B50C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 01:30:45 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id b193so2774825pga.6
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 01:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LX8I2fijecv7KRtCEc4VPXXR4257RwUjHtPyJPvY9W0=;
        b=XYGdOyrNNQJRQ6hJBuUKwkDbFKksOH1ePxlFL2Rx+eOIhm3bi5NmExBXoAB2ihVHps
         HblBBTqJ/DAftYDSl8iHU9h3gXnEmmMCF1IulxObLV9M++SXh0jCfOKrFqlCnNo6m1NZ
         70ObngpeM2gpfLX1Zz1FLKc/buW8NfQDO3pGprgaCispLIHHnLtuJnOfd3Am5UGNVaRW
         eGe5u1LD2K5BxkfzUTtuGGK1cBoJ+0dcaQRMUT6n2CF/hvS6dOYQDo7TkIrzoesz5wST
         cUTGp8BWIytcvar4hNMStvsdEDiE7REmyIVFFbUgJolrHkZ3l0qMmMMnv5tV3CQ1+oUV
         mATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LX8I2fijecv7KRtCEc4VPXXR4257RwUjHtPyJPvY9W0=;
        b=dtiCPoYz5p+YZnghpqHloV/YCYYoVYtUavj08b1M7ROcjjNRPOxWZNppgaKH4MB4jK
         p3UHHl5sHLvTi8yz65jOxa3fsApcUQFyGng1xuGZTdeaCceP39f0iV9oIhI0LseeE7mb
         vp1Nn0CN2cUFtts4iWbxUEh9R4AJqPfKYn9wEkPxN73p+dQjb4cm8AAGNFk2hrK3Mkbi
         9db3tK/K/zG3IzqI/wU5pEcAbSvw6q2hvl1uQrHr2FKQNddjdjpDmDgxgU0ukc61wg9C
         +PsUz+D54+HegaXS8DvyaenqwUVB/RQapTTKLnekLYFqTWdiSROUgrBajKhvrLnOnFGP
         xX6w==
X-Gm-Message-State: AOAM5312r08oBlDXx9mQfHZTHlEaVw5vOXYJz/iQJn0RKNMpuxV8H+5+
        aMtqwZ1a0MrYjgWmUDws9Lo=
X-Google-Smtp-Source: ABdhPJwt+2ryNOul78QEOWthG/Etk4wPdoj7M884f+QWiKb8l7QXbeJugvbo4bJWjGA1eGCpbZJclA==
X-Received: by 2002:a17:90a:6443:: with SMTP id y3mr6793013pjm.150.1602145845557;
        Thu, 08 Oct 2020 01:30:45 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o20sm6799143pgh.63.2020.10.08.01.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 01:30:44 -0700 (PDT)
Date:   Thu, 8 Oct 2020 16:30:34 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Message-ID: <20201008083034.GI2531@dhcp-12-153.nay.redhat.com>
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
 <20201007035502.3928521-3-liuhangbin@gmail.com>
 <91f5b71e-416d-ebf1-750b-3e1d5cf6b732@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91f5b71e-416d-ebf1-750b-3e1d5cf6b732@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Thanks for the comments. I should add "RFC" in subject next time for the
uncertain fix patch.

On Wed, Oct 07, 2020 at 11:35:41AM +0200, Eric Dumazet wrote:
> 
> 
> On 10/7/20 5:55 AM, Hangbin Liu wrote:
> 
> >  		kfree_skb(skb);
> > @@ -282,6 +285,21 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> >  		}
> >  	}
> >  
> > +	/* RFC 8200, Section 4.5 Fragment Header:
> > +	 * If the first fragment does not include all headers through an
> > +	 * Upper-Layer header, then that fragment should be discarded and
> > +	 * an ICMP Parameter Problem, Code 3, message should be sent to
> > +	 * the source of the fragment, with the Pointer field set to zero.
> > +	 */
> > +	nexthdr = hdr->nexthdr;
> > +	offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
> > +	if (frag_off == htons(IP6_MF) && !pskb_may_pull(skb, offset + 1)) {
> > +		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
> > +		icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
> > +		rcu_read_unlock();
> > +		return NULL;
> > +	}
> > +
> >  	rcu_read_unlock();
> >  
> >  	/* Must drop socket now because of tproxy. */
> > 
> 
> Ouch, this is quite a buggy patch.
> 
> I doubt we want to add yet another ipv6_skip_exthdr() call in IPv6 fast path.
> 
> Surely the presence of NEXTHDR_FRAGMENT is already tested elsewhere ?

Would you like to help point where NEXTHDR_FRAGMENT was tested before IPv6
defragment?

> 
> Also, ipv6_skip_exthdr() does not pull anything in skb->head, it would be strange
> to force a pull of hundreds of bytes just because you want to check if an extra byte is there,
> if the packet could be forwarded as is, without additional memory allocations.
> 
> Testing skb->len should be more than enough at this stage.

Ah, yes, I shouldn't call pskb_may_pull here.
> 
> Also ipv6_skip_exthdr() can return an error.

it returns -1 as error, If we tested it by (offset + 1 > skb->len), does
that count as an error handler?

Thanks
Hangbin
