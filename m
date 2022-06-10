Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E635D546C3D
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 20:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346543AbiFJSVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 14:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbiFJSVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 14:21:13 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EC5A5AB1
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 11:21:11 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id g25so30248ljm.2
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 11:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WDbQGcHRB7r7S5NMylyIuOM8frRwF1KEs/FSKYlEImA=;
        b=RCZWuazzpcQjwWjy4ZXSkRLut2iEIdBtngnIPrU8I5h9Cw5Rhs559+xRaaphblYkAL
         mCRlTjuQbV30c3ldu91ime6bZznoJ0jfLyRVDxIupVIysJG29NSenRSvhUOC46xNGyel
         MYd3Iu0JdkN+l9w6BG2fjE/SV9vq/wUNSSutybSGQHRrUkyVY7oEcrzL3CnmTgt2yoqf
         53Y+ILg197cC9S1zjHY9TDIrpN4xmEJgmzW+xN03j5hyQPvDzWMgCZfmpxPr3Z7iJk+V
         vvMkftt2ONgO2NOs7xOywG0YRiZ2wBQUZOyoT6Jl6jmbXCVp26S00F/EsUMMMTvQzkR/
         JhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WDbQGcHRB7r7S5NMylyIuOM8frRwF1KEs/FSKYlEImA=;
        b=Wl7m4b4Z0oGQRcQl/c+PGFvp6CBdPbFqUKave4WQMlxTLzH5qsLX4xVAzTBepdK6JX
         hq2eqW1OfF/0LjVHGnt5ozWkKZJx8sFt6BWXsgM3VDJegYyb64Si8mt0P2jp8D2mfTdn
         GwqAHi9qVIiK1euFmhDinCLi1q2cWemeh1uijGBojyVvcL+w6/myhUPk91DCFfgoIFPc
         8DqlTimolHPZsrsmRf/VBg4EUFNWkUtdldm22R1FSil2m2p2U0Qg9HrM6CPJ7ihnw8/4
         lbWeo5qRMJu6Qz/Ho4YmjFyznb8KkjltQDUPRpIVdH23Ok8sgrRXfv77pSCzvORW/o1p
         LbBQ==
X-Gm-Message-State: AOAM5311HpUE2goqnobQBZWiQVYLHHucuZiQmkh8egSmNGdYPN9e4uWf
        1AkFz9A96b0icFBq8aZzsKM=
X-Google-Smtp-Source: ABdhPJwSSodiYyKV/+NOlpi/bm4vHoSjdYNUY/Tq/aH0efvciBkXBvvqLJ19HM43Lq4cyQsiiu4cGQ==
X-Received: by 2002:a2e:96c1:0:b0:258:e8ec:3889 with SMTP id d1-20020a2e96c1000000b00258e8ec3889mr2225723ljj.6.1654885270056;
        Fri, 10 Jun 2022 11:21:10 -0700 (PDT)
Received: from extra.gateflow.net ([46.109.159.121])
        by smtp.gmail.com with ESMTPSA id i26-20020ac25b5a000000b00477c0365b20sm4803984lfp.188.2022.06.10.11.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 11:21:09 -0700 (PDT)
From:   Anton Makarov <antonmakarov11235@gmail.com>
X-Google-Original-From: Anton Makarov <anton.makarov11235@gmail.com>
Date:   Fri, 10 Jun 2022 21:21:08 +0300
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     Anton Makarov <antonmakarov11235@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, david.lebrun@uclouvain.be,
        netdev@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [net-next v2 1/1] net: seg6: Add support for SRv6 Headend
 Reduced Encapsulation
Message-Id: <20220610212108.ed54aa540f4b01d4018b04ee@gmail.com>
In-Reply-To: <20220610135958.cb99b9122925b62eba634337@uniroma2.it>
References: <20220609132750.4917-1-anton.makarov11235@gmail.com>
        <20220610135958.cb99b9122925b62eba634337@uniroma2.it>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrea,
Thank you very much for your feedback! Plese look at my response inline
and let me know what you think about that. Many thanks!

On Fri, 10 Jun 2022 13:59:58 +0200
Andrea Mayer <andrea.mayer@uniroma2.it> wrote:

> Hi Anton,
> please see my comments inline, thanks.
> 
> On Thu,  9 Jun 2022 16:27:50 +0300
> Anton Makarov <antonmakarov11235@gmail.com> wrote:
> 
> > SRv6 Headend H.Encaps.Red and H.Encaps.L2.Red behaviors are implemented
> > accordingly to RFC 8986. The H.Encaps.Red is an optimization of
> > The H.Encaps behavior. The H.Encaps.L2.Red is an optimization of
> > the H.Encaps.L2 behavior. Both new behaviors reduce the length of
> > the SRH by excluding the first SID in the SRH of the pushed IPv6 header.
> > The first SID is only placed in the Destination Address field
> > of the pushed IPv6 header.
> > 
> > The push of the SRH is omitted when the SRv6 Policy only contains
> > one segment.
> > 
> > Signed-off-by: Anton Makarov <anton.makarov11235@gmail.com>
> > 
> > ...
> >  
> > +/* encapsulate an IPv6 packet within an outer IPv6 header with reduced SRH */
> > +int seg6_do_srh_encap_red(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
> > +{
> > +	struct dst_entry *dst = skb_dst(skb);
> > +	struct net *net = dev_net(dst->dev);
> > +	struct ipv6hdr *hdr, *inner_hdr6;
> > +	struct iphdr *inner_hdr4;
> > +	struct ipv6_sr_hdr *isrh;
> > +	int hdrlen = 0, tot_len, err;
> 
> I suppose we should stick with the reverse XMAS tree code style.

Sure, no problem.

> 
> > +	__be32 flowlabel = 0;
> 
> this initialization is unnecessary since the variable is accessed for the first
> time in writing, later in the code.

Sorry, missed this extra action. You are correct.

> 
> > +	if (osrh->first_segment > 0)
> > +		hdrlen = (osrh->hdrlen - 1) << 3;
> > +
> > +	tot_len = hdrlen + sizeof(struct ipv6hdr);
> > +
> > +	err = skb_cow_head(skb, tot_len + skb->mac_len);
> > +	if (unlikely(err))
> > +		return err;
> > +
> > +	inner_hdr6 = ipv6_hdr(skb);
> > +	inner_hdr4 = ip_hdr(skb);
> 
> inner_hdr4 is only used in the *if* block that follows later on.

Do you mean it has to be defined inside *if* block and assigned via
inner_ip_hdr()?

> 
> > +	flowlabel = seg6_make_flowlabel(net, skb, inner_hdr6);
> > +
> > +	skb_push(skb, tot_len);
> > +	skb_reset_network_header(skb);
> > +	skb_mac_header_rebuild(skb);
> > +	hdr = ipv6_hdr(skb);
> > +
> > +	memset(skb->cb, 0, sizeof(skb->cb));
> 
> is there a specific reason why we should consider the whole CB size and not
> only the part covered by the struct inet6_skb_parm?

Oh yes, memset(IP6CB(skb), 0, sizeof(*IP6CB(skb))) would be better. You
are correct.

> 
> > +	IP6CB(skb)->iif = skb->skb_iif;
> > +
> > +	if (skb->protocol == htons(ETH_P_IPV6)) {
> > +		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr6)),
> > +			     flowlabel);
> > +		hdr->hop_limit = inner_hdr6->hop_limit;
> > +	} else if (skb->protocol == htons(ETH_P_IP)) {
> > +		ip6_flow_hdr(hdr, (unsigned int) inner_hdr4->tos, flowlabel);
> > +		hdr->hop_limit = inner_hdr4->ttl;
> > +	}
> > +
> 
> Don't IPv4 and IPv6 cover all possible cases?

In fact while case SEG6_IPTUN_MODE_ENCAP in seg6_do_srh() does
preliminary check of protocol value, case SEG6_IPTUN_MODE_L2ENCAP does
not. So potentially skb->protocol can be of any value. Although
additional check brings extra impact on performance, sure.

> 
> > +	skb->protocol = htons(ETH_P_IPV6);
> > +
> > +	hdr->daddr = osrh->segments[osrh->first_segment];
> > +	hdr->version = 6;
> > +
> > +	if (osrh->first_segment > 0) {
> > +		hdr->nexthdr = NEXTHDR_ROUTING;
> > +
> > +		isrh = (void *)hdr + sizeof(struct ipv6hdr);
> > +		memcpy(isrh, osrh, hdrlen);
> > +
> > +		isrh->nexthdr = proto;
> > +		isrh->first_segment--;
> > +		isrh->hdrlen -= 2;
> > +	} else {
> > +		hdr->nexthdr = proto;
> > +	}
> > +
> > +	set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
> > +
> > +#ifdef CONFIG_IPV6_SEG6_HMAC
> > +	if (osrh->first_segment > 0 && sr_has_hmac(isrh)) {
> > +		err = seg6_push_hmac(net, &hdr->saddr, isrh);
> > +		if (unlikely(err))
> > +			return err;
> > +	}
> > +#endif
> > +
> 
> When there is only one SID and HMAC is configured, the SRH is not kept.
> Aren't we losing information this way?

Yes, but HMAC is just an optional part of SRH. RFC 8986 allows us to
omit entire SRH in reduced encapsulation when the SRv6 Policy only
contains one segment. And it seems to be the most usefull approach as
far as:
1) About all hardware implementations do not procede HMAC at all
2) Too many networking guys have a great concern about huge overhead of
SRv6 in compare with MPLS, so they are not happy to get extra 256 bits
3) If one consider HMAC mandatory then there is still basic (not
reduced) encapsulation option

What do you think about it?

> 
> Andrea

Anton

