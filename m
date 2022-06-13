Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF985499D3
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240087AbiFMRXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242331AbiFMRXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:23:32 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFC65FF0C
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 05:42:36 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id a15so8624260lfb.9
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 05:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g3woFP4cjI6P8W4rtXz3j0FKh1bUkvC0iQntXo8XjeY=;
        b=VaUNyUwwajaqLmg4EeLGYHf+uhtZ+tJtqBxUdssxUsNLU2eoTaPO6dS9j46x6myytB
         3lIubGBZRiev5bwt1yZZJSTEktAI/Ym/M86c8Cou9GtEgBD7vI7r4joT2qDg2+Gpq4eF
         xIeBBLfEt8zN9stb5CuLW+vufEqogaNEOSRI/eFtmHvvDq+8yIK5XbXP5ZGz9gV7S584
         mNWYXRxpU3iXiGexZkIhN6AhOKDHEFyUIYbu/ZOGYPuIJgrgI82Z3eW+au9Extzr5S7L
         /Z1cL6JSveXqAsSqicR15/P4TjwTaX5hNcPVU15LSclOklSznWDZYmVVPT6EywitpdPx
         /zYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g3woFP4cjI6P8W4rtXz3j0FKh1bUkvC0iQntXo8XjeY=;
        b=qvdVT69My+pGqoGHN0mAPMGCJEZ39I0KKcgoICuJemkVEGrPjR2kFX/34cJLXIOJT1
         pVulxlBipxv1aT+BPddRs5vMPwoknA6swSwwP4qFbWaWrogEvV6W43+b/ClbU7sSpLVK
         ns6FARw0JJ4xwBr+kYyoKMCiDQc6ADG2oZzoXbjVScQ6FCQKa/kUkwHQK8ytW9MkJkGb
         uObwa2uw/2rIixvvKc6k8qJL4sv7immMA1o1h1M9W/YAG0LfXjHWuzdpEUYkDWxNyxiJ
         AVwOX72vJYy0Lx12bMpqo+LcjklH9AqZh1irvuKV0bHgkDv2zeWyY4u6PD5X0Bi/dwtV
         Kv2w==
X-Gm-Message-State: AOAM532/oQyB1zh9bGrdL60J9YMK3Ml35jlCVj+ghbjDk7vsXFMG48pX
        +bbIuHkdOZ9REN1re9SAAI0yk/EJAvbPG4+A
X-Google-Smtp-Source: ABdhPJxU0dZ21f2SQHZnHFjhfBz9cxDSl05iymRf2LbV5FtBH9J+vmJCOUKCxtBt9I7LyCoOxAS2Pw==
X-Received: by 2002:a05:6512:33ce:b0:479:5b5e:a6fe with SMTP id d14-20020a05651233ce00b004795b5ea6femr20777001lfg.290.1655124154145;
        Mon, 13 Jun 2022 05:42:34 -0700 (PDT)
Received: from extra.gateflow.net ([46.109.159.121])
        by smtp.gmail.com with ESMTPSA id g19-20020a05651222d300b00477b256b890sm978625lfu.115.2022.06.13.05.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 05:42:32 -0700 (PDT)
From:   Anton Makarov <antonmakarov11235@gmail.com>
X-Google-Original-From: Anton Makarov <anton.makarov11235@gmail.com>
Date:   Mon, 13 Jun 2022 15:42:31 +0300
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     Anton Makarov <antonmakarov11235@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [net-next v2 1/1] net: seg6: Add support for SRv6 Headend
 Reduced Encapsulation
Message-Id: <20220613154231.a71c58a93a35e5231a71cd96@gmail.com>
In-Reply-To: <20220611202335.c24dc8e4dbb0f030a454a19e@uniroma2.it>
References: <20220609132750.4917-1-anton.makarov11235@gmail.com>
        <20220610135958.cb99b9122925b62eba634337@uniroma2.it>
        <20220610212108.ed54aa540f4b01d4018b04ee@gmail.com>
        <20220611202335.c24dc8e4dbb0f030a454a19e@uniroma2.it>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrea,
Please look inline. Many thanks!

On Sat, 11 Jun 2022 20:23:35 +0200
Andrea Mayer <andrea.mayer@uniroma2.it> wrote:

> Hi Anton,
> please consider my answers below. Thanks.
> 
> On Fri, 10 Jun 2022 21:21:08 +0300
> Anton Makarov <antonmakarov11235@gmail.com> wrote:
> 
> > Hi Andrea,
> > Thank you very much for your feedback! Plese look at my response inline
> > and let me know what you think about that. Many thanks!
> > 
> 
> you are welcome!
> 
> > 
> > > 
> > > > +	if (osrh->first_segment > 0)
> > > > +		hdrlen = (osrh->hdrlen - 1) << 3;
> > > > +
> > > > +	tot_len = hdrlen + sizeof(struct ipv6hdr);
> > > > +
> > > > +	err = skb_cow_head(skb, tot_len + skb->mac_len);
> > > > +	if (unlikely(err))
> > > > +		return err;
> > > > +
> > > > +	inner_hdr6 = ipv6_hdr(skb);
> > > > +	inner_hdr4 = ip_hdr(skb);
> > > 
> > > inner_hdr4 is only used in the *if* block that follows later on.
> > 
> > Do you mean it has to be defined inside *if* block and assigned via
> > inner_ip_hdr()?
> > 
> 
> I think it is correct to define inner_hdr4 as you have already done, but
> initialize and use it only within the *else if* block (the IPv4 one, of
> course), as it is no further accessed outside.

Agree.

> 
> > > > +	IP6CB(skb)->iif = skb->skb_iif;
> > > > +
> > > > +	if (skb->protocol == htons(ETH_P_IPV6)) {
> > > > +		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr6)),
> > > > +			     flowlabel);
> > > > +		hdr->hop_limit = inner_hdr6->hop_limit;
> > > > +	} else if (skb->protocol == htons(ETH_P_IP)) {
> > > > +		ip6_flow_hdr(hdr, (unsigned int) inner_hdr4->tos, flowlabel);
> > > > +		hdr->hop_limit = inner_hdr4->ttl;
> > > > +	}
> > > > +
> > > 
> > > Don't IPv4 and IPv6 cover all possible cases?
> > 
> > In fact while case SEG6_IPTUN_MODE_ENCAP in seg6_do_srh() does
> > preliminary check of protocol value, case SEG6_IPTUN_MODE_L2ENCAP does
> > not. So potentially skb->protocol can be of any value. Although
> > additional check brings extra impact on performance, sure.
> > 
> 
> If you fill the pushed IPv6 header in the same way as is done in
> seg6_do_srh_encap(), I don't think you need to provide other checks
> on skb->protocol (thus avoiding the *if else if* in favor of only *if else*).
> 
> In your solution, if the protocol is neither IP6 nor IP4, then the pushed
> IPv6 header is partially initialized. In particular, it seems to me that the
> traffic class, flow label, and hop limit are not set anywhere else.

Seems there is a more global inconsistence in entire seg6 implementation
because L2.Encaps has to inherit some parameters not from IPv6/IPv4
headers, but from inner Ethernet and VLAN headers. No?

> 
> > > 
> > > > +	skb->protocol = htons(ETH_P_IPV6);
> > > > +
> 
> This seems to be redundant, since in seg6_do_srh() the protocol is set after
> calling the seg6_do_srh_encap{_red}() functions.

> 
> > > > +	hdr->daddr = osrh->segments[osrh->first_segment];
> > > > +	hdr->version = 6;
> > > > +
> > > > +	if (osrh->first_segment > 0) {
> > > > +		hdr->nexthdr = NEXTHDR_ROUTING;
> > > > +
> > > > +		isrh = (void *)hdr + sizeof(struct ipv6hdr);
> > > > +		memcpy(isrh, osrh, hdrlen);
> > > > +
> > > > +		isrh->nexthdr = proto;
> > > > +		isrh->first_segment--;
> > > > +		isrh->hdrlen -= 2;
> > > > +	} else {
> > > > +		hdr->nexthdr = proto;
> > > > +	}
> > > > +
> > > > +	set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
> > > > +
> > > > +#ifdef CONFIG_IPV6_SEG6_HMAC
> > > > +	if (osrh->first_segment > 0 && sr_has_hmac(isrh)) {
> > > > +		err = seg6_push_hmac(net, &hdr->saddr, isrh);
> > > > +		if (unlikely(err))
> > > > +			return err;
> > > > +	}
> > > > +#endif
> > > > +
> > > 
> > > When there is only one SID and HMAC is configured, the SRH is not kept.
> > > Aren't we losing information this way?
> > 
> > Yes, but HMAC is just an optional part of SRH. RFC 8986 allows us to
> > omit entire SRH in reduced encapsulation when the SRv6 Policy only
> > contains one segment. 
> > And it seems to be the most usefull approach as
> > far as:
> > 1) About all hardware implementations do not procede HMAC at all
> > 2) Too many networking guys have a great concern about huge overhead of
> > SRv6 in compare with MPLS, so they are not happy to get extra 256 bits
> > 3) If one consider HMAC mandatory then there is still basic (not
> > reduced) encapsulation option
> > 
> > What do you think about it?
> > 
> 
> Thanks for the explanation.

You are welcome.

> 
> However, considering the RFC 8986 Section 5.2:
>   "The push of the SRH MAY be omitted when the SRv6 Policy only contains one
>    segment and there is no need to use any flag, tag, or TLV."
> 
> Hence, if a user needs to use HMAC (rare case) or any other type of supported
> flags, tags and TLVs, then the SRH should not be removed, even if there is
> only one SID.

Well noted - rare case. Seems to be academic research only, perhaps
some synthetic PoC. For many years since SRv6 introduction IANA
registered no more SHR TLV besides stillborn HMAC.
Processing some kind of security keys in hardware on multi-Tbps speeds
is unacceptably expensive for production network.

> 
> Andrea

Dear Andrea,
I see you are passionately keeping SRv6 part of kernel code under your
umbrella and this is great! Thus please offer your implementation of
SRv6 reduced encapsulation with your favorite coding style and so on
and so forth. I would be happy to get it and withdraw my version. I
just need encap.red to exist in the kernel, no more. Anyway we ignore
all unneeded parameters while offloading it in our hardware :)

Please note that if you are passionate of strictly followig standards
then entire SRv6 endpoint behaviors' implementation has to be reworked
hardly - lwtunnel is not a correct place for it. I will designate just
a couple of unacceptable points:

1) SRv6 Endpoint behaviors cannot require dev as mandatory parameter
like current implementation does. While End.DT4, End.DT6, End.DT46 have
some workaround- dev of type vrf, basic End behavior assumess egress dev
can be defined only in the second IP lookup _after_ processing of End
behavior itself. Thus dev parameter cannot be assigned during endpoint
behavior configuration. Please refer RFC 8986 section 4.1:

"S01. When an SRH is processed {
S02.   If (Segments Left == 0) {
S03.      Stop processing the SRH, and proceed to process the next
             header in the packet, whose type is identified by
             the Next Header field in the routing header.
S04.   }
S05.   If (IPv6 Hop Limit <= 1) {
S06.      Send an ICMP Time Exceeded message to the Source Address
             with Code 0 (Hop limit exceeded in transit),
             interrupt packet processing, and discard the packet.
S07.   }
S08.   max_LE = (Hdr Ext Len / 2) - 1
S09.   If ((Last Entry > max_LE) or (Segments Left > Last Entry+1)) {
S10.      Send an ICMP Parameter Problem to the Source Address
             with Code 0 (Erroneous header field encountered)
             and Pointer set to the Segments Left field,
             interrupt packet processing, and discard the packet.
S11.   }
S12.   Decrement IPv6 Hop Limit by 1
S13.   Decrement Segments Left by 1
S14.   Update IPv6 DA with Segment List[Segments Left]
S15.   Submit the packet to the egress IPv6 FIB lookup for
          transmission to the new destination
S16. }"

Of course, current implementation of End behavior has a hack - using dev
of type dummy and then next IP lookup. But I am afraid it impacts
networking stack performance and memory consuming much harder that just
extra variable. MPLS part of stack is a good reference how it has to be
implemented accordingly to RFC 8986.

2) H.Encaps.L2 cannot be processed _after_ IP lookup. Accordingly to RFC
8986 section 5.3 "The H.Encaps.L2 behavior encapsulates a received
Ethernet [IEEE.802.3_2018] frame and its attached VLAN header, if
present, in an IPv6 packet with an SRH. The Ethernet frame becomes the
payload of the new IPv6 packet".

IP lookup before H.Encaps.L2 in lwtunnel drops all broadcast and non-IP
frames and this is not acceptable for L2 tunnel behavior. Moreover
current H.Encaps.L2 implementation matches IP packets for tunneling by
IP address while it has to match Ethernet frames by MAC addresses. Dev
of type vxlan is a good reference how it has to be done.

With best regards,
Anton

