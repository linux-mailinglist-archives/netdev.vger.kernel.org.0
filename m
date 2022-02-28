Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03144C7B09
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 21:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiB1Uz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 15:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiB1Uz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 15:55:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 522146253
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 12:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646081686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HeCt+VGBDipCwQS0detdZr2xa8RQZ0HMHTglMiTP/mY=;
        b=ahzWtaMBdLj5uhPoU34BUB5uo7RuQ/WyO5sAZuttXJ0PWMDfHaklq3Z1ggp6VLEmomV2ab
        k4B+IIIoZMw0z+2mFiNM4D9xKEaJToBgIZg/Z8rMlw5VjCRCEKW4Jq3Rr1AOVi3y3d9Cu3
        5GlcPymem9PQbxGTIk5zM1aBDtO6EgQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-3u8guV3lM7aD5btl-6N_VA-1; Mon, 28 Feb 2022 15:54:44 -0500
X-MC-Unique: 3u8guV3lM7aD5btl-6N_VA-1
Received: by mail-wm1-f71.google.com with SMTP id i131-20020a1c3b89000000b0037bb9f6feeeso140341wma.5
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 12:54:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HeCt+VGBDipCwQS0detdZr2xa8RQZ0HMHTglMiTP/mY=;
        b=4E9NAwn0cuaC67s2gi+KDCa5CFeSYziNKYeQXIKtcygiZrRdjFpIbEtV/O3fpf1l5N
         KD4gsL/robbKBWRNeydwAxMdrcbznlgpgBIyo6Pxskb4F2FaEmnDXICz5pAI6p0NPFC2
         ENsMcolXgQSk5+FrVqTx7KeCMBJdo6SG/DIJb8apM4uYJ33SKb5KluMKAhVypD8KMNFa
         6VAX/d6sYxnZ4+dU0e4+k+lbT4OG36iu6AFNFPXxHIrs2bLyqrwV9pLRA+4a4RstxP1G
         ZgeC7QRNQqsYaWgYnN+a4O7qMY52pIPwOXPSyTZ7KDNTOAb8Oc3MFiafnBH7Ln/dRmPD
         zhxA==
X-Gm-Message-State: AOAM530fuvwS7Faa1HpdlBhb2o3Y9+HuJM1ZQP2uWg1pgo7Sd2QkvnL1
        Aiw0guQ1onYHGIBN4SS72f3IG9Gbj+TC5EGaJ4e75NHqW77omIxEvPgcZhZBsUBezFMBZW53xJc
        sG1imSuMJra2yT7w/
X-Received: by 2002:adf:d210:0:b0:1ef:ac39:43aa with SMTP id j16-20020adfd210000000b001efac3943aamr5688490wrh.578.1646081683086;
        Mon, 28 Feb 2022 12:54:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzzNRdL36QRNbuPtB8Q2Uo6Q6nykB/uNFInQI7z17cZAXAoNUAQC0U0ArUQw/w5VeimxfDVBA==
X-Received: by 2002:adf:d210:0:b0:1ef:ac39:43aa with SMTP id j16-20020adfd210000000b001efac3943aamr5688482wrh.578.1646081682828;
        Mon, 28 Feb 2022 12:54:42 -0800 (PST)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id m11-20020adff38b000000b001ef879a5930sm8074906wro.61.2022.02.28.12.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 12:54:42 -0800 (PST)
Date:   Mon, 28 Feb 2022 21:54:40 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net] ipv4: fix route lookups when handling ICMP redirects
 and PMTU updates
Message-ID: <20220228205440.GA24680@debian.home>
References: <cffd245430d10fa2a14c32d1c768eef7cfeb8963.1646068241.git.gnault@redhat.com>
 <922b4932-fcd5-d362-4679-6689046560c7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <922b4932-fcd5-d362-4679-6689046560c7@kernel.org>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 10:31:58AM -0700, David Ahern wrote:
> On 2/28/22 10:16 AM, Guillaume Nault wrote:
> > Fixes: d3a25c980fc2 ("ipv4: Fix nexthop exception hash computation.")
> 
> That does not seem related to tos in the flow struct at all.

Ouch, copy/paste mistake.
I meant 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions."), which is
the next commit with 'git log -- net/ipv4/route.c'.
Really sorry :/, and thanks a lot for catching that!

> > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > index f33ad1f383b6..d5d058de3664 100644
> > --- a/net/ipv4/route.c
> > +++ b/net/ipv4/route.c
> > @@ -499,6 +499,15 @@ void __ip_select_ident(struct net *net, struct iphdr *iph, int segs)
> >  }
> >  EXPORT_SYMBOL(__ip_select_ident);
> >  
> > +static void ip_rt_fix_tos(struct flowi4 *fl4)
> 
> make this a static inline in include/net/flow.h and update
> flowi4_init_output and flowi4_update_output to use it. That should cover
> a few of the cases below leaving just  ...

Hum, I didn't think about this option, but it looks risky to me. As I
put it in note 1, ip_route_output_key_hash() unconditionally sets
->flowi4_scope, assuming it can infer the scope from the RTO_ONLINK bit
of ->flowi4_tos. If we santise these fields in flowi4_init_output()
(and flowi4_update_output()), then ip_route_output_key_hash() would
sometimes work on already santised values and sometimes not. So it
wouldn't know if it should initialise ->flowi4_scope.

We could decide to let ip_route_output_key_hash() initialise
->flowi4_scope only when the RTO_ONLINK bit is set, which
guarantees that we don't have sanitised values. But before that, we'd
need to audit all other callers, to verify that they correctly
initialise the ->flowi4_scope with RT_SCOPE_UNIVERSE, since
ip_route_output_key_hash() isn't going do it for them anymore.
I'll audit all these callers, but that should be something for
net-next.

> > @@ -2613,9 +2625,7 @@ struct rtable *ip_route_output_key_hash(struct net *net, struct flowi4 *fl4,
> >  	struct rtable *rth;
> >  
> >  	fl4->flowi4_iif = LOOPBACK_IFINDEX;
> > -	fl4->flowi4_tos = tos & IPTOS_RT_MASK;
> > -	fl4->flowi4_scope = ((tos & RTO_ONLINK) ?
> > -			 RT_SCOPE_LINK : RT_SCOPE_UNIVERSE);
> > +	ip_rt_fix_tos(fl4);
> 
> ... this one to call the new helper.

BTW, here's a bit more about the context around this patch.
I found the problem while working on removing the use of RTO_ONLINK, so
that ->flowi4_tos could be converted to dscp_t.

The objective is to modify callers so that they'd set ->flowi4_scope
directly, instead using RTO_ONLINK to mark their intention (and that's
why I said I'd have to audit them anyway).

Once that will be done, ip_rt_fix_tos() won't have to touch the scope
anymore. And once ->flowi4_tos will be converted to dscp_t, we'll can
remove that function entirely since dscp_t ensures ECN bits are cleared
(IPTOS_RT_MASK also ensures that high order bits are cleared too, but
that's redundant with the RT_TOS() calls already done by callers, and
which somewhat aren't really desirable anyway).

> >  
> >  	rcu_read_lock();
> >  	rth = ip_route_output_key_hash_rcu(net, fl4, &res, skb);
> 

