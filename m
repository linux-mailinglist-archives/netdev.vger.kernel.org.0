Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94774298D54
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 13:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773386AbgJZMzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 08:55:32 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:35394 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1773347AbgJZMzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 08:55:31 -0400
Received: by mail-pj1-f48.google.com with SMTP id h4so3059201pjk.0
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 05:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M8Vw2QZFp/jt/eIW34XJjud6D53sQk4VNFp4sQsQZOs=;
        b=VMi6+sGYflFqDFo9A4e0xwNxC7oK6kl0nXEM4HtOsfO8maweA34rrjkk6NOGeI6ck/
         1+3zAjJ2qwI0ODg9OVEwUR+583vT1iuhkan1umk7IFCNUIBvvmZG4jAueHzkt7romfLQ
         bU91p2JXndgTsmP2sWgL+1QPZW97M5dA59bi2ITT3uOwe6NgvcVnSjc8dVWjt3vuaHOL
         iF7RPca3024fyXD++IoFurprP62cbjcKhXTfB5N1krw32tSKBglBUd8cinLslQImpVPm
         +w3Ac6SZlRMuYbcHuv9KVMkoBxGqEsUYC+F6CwJMSzj0IuLorAqUvbKWmeg7buPwKhhq
         xIvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M8Vw2QZFp/jt/eIW34XJjud6D53sQk4VNFp4sQsQZOs=;
        b=dzKuO1GK7p9ZIhSP9/jk4A5Nrsz3HLL39UyMwzaQWeBxrSHGg9jAA5xGreJipJAL0M
         voJMh4E7cyjRTEULCmYzBLqHsPtgl0xjfWcT+zoLeppivs0NP+V8vm1P6c3i0Y+z58IZ
         b4LzdJbHuv7TrOkkzoWiTg8TvIE5Jq6ROhBFj7/kfH3UwzWWy7ABg4GE+gf9hLgg5s47
         5w7cm8Xzi4hwh+AFV9Fx3VKgj4mz1HlR0AVA4pbpRqHmCku2sg31KtjFCrRU4FsssK4z
         rB3cfigqdg59nW7P8L5p5FYibIGliF9Qmu0ZRPwqyJaGAN54fsTSu95wjL6sL5E9MOAS
         lA6A==
X-Gm-Message-State: AOAM530KTuEqLO8QL+GrPESArGrLSpDP1ouqxdg26TFZDuuwkCs1LW6Y
        PqeJTKHhNtP/eZk4tzwQx47eObKbHRq5SamR
X-Google-Smtp-Source: ABdhPJymoE6QZD6nkqoWX8v6j+xKztsdHjq6H6OVCAeLnXmEW2BLnLfzbfw3bbRDTxBj33K0TX43+g==
X-Received: by 2002:a17:90a:d517:: with SMTP id t23mr16640918pju.141.1603716930848;
        Mon, 26 Oct 2020 05:55:30 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k127sm10652684pgk.10.2020.10.26.05.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 05:55:30 -0700 (PDT)
Date:   Mon, 26 Oct 2020 20:55:19 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     "Georg Kohmann (geokohma)" <geokohma@cisco.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv4 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Message-ID: <20201026125519.GO2531@dhcp-12-153.nay.redhat.com>
References: <20201023064347.206431-1-liuhangbin@gmail.com>
 <20201026072926.3663480-1-liuhangbin@gmail.com>
 <20201026072926.3663480-3-liuhangbin@gmail.com>
 <57fe774b-63bb-a270-4271-f1cb632a6423@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57fe774b-63bb-a270-4271-f1cb632a6423@cisco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 08:09:21AM +0000, Georg Kohmann (geokohma) wrote:
> > +	nexthdr = hdr->nexthdr;
> > +	offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
> > +	if (offset < 0)
> > +		goto fail_hdr;
> > +
> > +	/* Check some common protocols' header */
> > +	if (nexthdr == IPPROTO_TCP)
> > +		offset += sizeof(struct tcphdr);
> > +	else if (nexthdr == IPPROTO_UDP)
> > +		offset += sizeof(struct udphdr);
> > +	else if (nexthdr == IPPROTO_ICMPV6)
> > +		offset += sizeof(struct icmp6hdr);
> > +	else
> > +		offset += 1;
> 
> Maybe also check the special case IPPROTO_NONE?

IPPROTO_NONE defines the same with NEXTHDR_NONE. So ipv6_skip_exthdr() will
return -1, and we will goto fail_hdr and send ICMP parameter error message.

The question is if it's OK to reply a ICMP error for fragment + IPPROTO_NONE
packet? For pure IPPROTO_NONE message, we should drop silently, but what about
fragment message?

> > +
> > +	if (frag_off == htons(IP6_MF) && offset > skb->len) {
> > +		__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev), IPSTATS_MIB_INHDRERRORS);
> > +		icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
> > +		return -1;
> > +	}
> > +
> >  	iif = skb->dev ? skb->dev->ifindex : 0;
> >  	fq = fq_find(net, fhdr->identification, hdr, iif);
> >  	if (fq) {
> 
> Are you planning to also add this fix for the fragmentation handling in the netfilter?
> 
I have no plan to fix this on netfilter as netfilter is a module.
It may have different behavior during defragment.

Thanks
Hangbin
