Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BB428868E
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 12:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387471AbgJIKHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 06:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgJIKHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 06:07:51 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50541C0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 03:07:50 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id h6so6795643pgk.4
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 03:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PxXPx3Tv3Z2b0eEPLlGvN0NCRLzR/W8Wz8uEBCTf24A=;
        b=lOoUNullfi7PoIE2nmQf5nTtTjscb8Vuiv3XN+6yBHk2hzvdysNCU2wnTxu2Zon6DD
         AhhJb4uEMQy78DsaabH4NeHw2C6KIqTqDQrDxve9dI6jJo556KhESiKlrdQ7+cCQxOV8
         5+taHfi1SotELPUSvFZ3/VD3NeSU9bcsPUMqwq2aoguNq/c3Tb+Ht6KyjKduZ36fOmf+
         8upK/G0H5oJOhkKSgKzX8M9wXwn3FER8O/TaZ4aecArEI2qu+w1334cBgP4DmfqbTW18
         AdIfgtVumII8d34Uzjb7CJgma0HkarBC/Yye8PGPYtopfj6WaYDs5WXH9lK2ob69dRIE
         dyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PxXPx3Tv3Z2b0eEPLlGvN0NCRLzR/W8Wz8uEBCTf24A=;
        b=oyHiPD/NkwVTevnwbrA0nHdRQvUmHlnoXtu41Tz4fE2utRDllIGA5ENrbILgbnl4vw
         2GBd7456OhAlRkoS7SP4JNGcIQ2jj8amFkzlyhypUkDaN2zzX/dJ/e0PuZ++1XCIcsUG
         UO0MZd12fgOkrIj9xgvtwG5iQylL2YtRPcIrTxISTEY3mtp5zhuMUOfxl1sed+8hnxtU
         NFsI7rN+nu9qQAdex4J2tNHfIRS6FYDI/YpKQoOOVXdb1klw0f1ftRxFjKPSfa6nAUTG
         uA61+GoDo7sKZZCyuF0J//6M6iR9F2yJdaK0wzeUM+1iQIvRPHoUEMW6UdOdwbdOAb3p
         T0nw==
X-Gm-Message-State: AOAM530MXxH8ymhCJXh39f3DAXIjfO4iDDjFxF8TPGmUdvtgBrdaFIvp
        lyZ8sMKZFvbUO9+zLG/ihqY=
X-Google-Smtp-Source: ABdhPJzr++BEgITmLunXMLRBMlfDopIbpX2BUExDLrLVC2JCBpsppAz7eDkAOZpVJFIS33KgP/ygmw==
X-Received: by 2002:a65:62d5:: with SMTP id m21mr2852081pgv.226.1602238069871;
        Fri, 09 Oct 2020 03:07:49 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v21sm11283593pjy.43.2020.10.09.03.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 03:07:48 -0700 (PDT)
Date:   Fri, 9 Oct 2020 18:07:38 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Message-ID: <20201009100738.GK2531@dhcp-12-153.nay.redhat.com>
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
 <20201007035502.3928521-3-liuhangbin@gmail.com>
 <91f5b71e-416d-ebf1-750b-3e1d5cf6b732@gmail.com>
 <20201008083034.GI2531@dhcp-12-153.nay.redhat.com>
 <f7272dda-0383-c7d0-1a8a-4a70a1aadb77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f7272dda-0383-c7d0-1a8a-4a70a1aadb77@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 11:47:00AM +0200, Eric Dumazet wrote:
> 
> 
> On 10/8/20 10:30 AM, Hangbin Liu wrote:
> >>> @@ -282,6 +285,21 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> >>>  		}
> >>>  	}
> >>>  
> >>> +	/* RFC 8200, Section 4.5 Fragment Header:
> >>> +	 * If the first fragment does not include all headers through an
> >>> +	 * Upper-Layer header, then that fragment should be discarded and
> >>> +	 * an ICMP Parameter Problem, Code 3, message should be sent to
> >>> +	 * the source of the fragment, with the Pointer field set to zero.
> >>> +	 */
> >>> +	nexthdr = hdr->nexthdr;
> >>> +	offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
> >>> +	if (frag_off == htons(IP6_MF) && !pskb_may_pull(skb, offset + 1)) {
> >>> +		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
> >>> +		icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
> >>> +		rcu_read_unlock();
> >>> +		return NULL;
> >>> +	}
> >>> +
> >>>  	rcu_read_unlock();
> >>>  
> >>>  	/* Must drop socket now because of tproxy. */
> >>>
> >>
> >> Ouch, this is quite a buggy patch.
> >>
> >> I doubt we want to add yet another ipv6_skip_exthdr() call in IPv6 fast path.
> >>
> >> Surely the presence of NEXTHDR_FRAGMENT is already tested elsewhere ?
> > 
> > Would you like to help point where NEXTHDR_FRAGMENT was tested before IPv6
> > defragment?
> I think we have to ask the question : Should routers enforce the rule, or
> only end points ?

From IPv6 Core Conformance test[1], it applied to both router and host(It will
marked specifically if a test only for router).

> 
> End points must handle NEXTHDR_FRAGMENT, in ipv6_frag_rcv()

Yes, I was also try put the check there, but it looks that would be too late
if module nf_defrag_ipv6 loaded

> >> Also ipv6_skip_exthdr() can return an error.
> > 
> > it returns -1 as error, If we tested it by (offset + 1 > skb->len), does
> > that count as an error handler?
> 
> If there is an error, then you want to send the ICMP, right ?

No, this is only for fragment header with no enough Upper-Layer header, which need
send ICMP Parameter Problem, Code 3 specifically. For other errors, I guess
the other code will take care of it.

So for -1 return, I just skipped it.
> 
> The (offset + 1) expression will become 0, and surely the test will be false,
> so you wont send the ICMP...

[1] v6LC.1.3.6: First Fragment Doesn’t Contain All Headers part A, B,
C and D at https://ipv6ready.org/docs/Core_Conformance_5_0_0.pdf

Thanks
Hangbin
