Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6BD4C8AFE
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 12:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiCALl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 06:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbiCALl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 06:41:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83A0D95498
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 03:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646134875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jevPAIDXbxsqcggLiSAPMZ0qjGRa8Dl/g8BqBRC/KzU=;
        b=WD+kIWzzpQCNMZMNaQqLXi1o0pLAXWLxNl/DfsvBq0d36qiAc+gsk1EipChRqVO36FOS5k
        r9LWAbcd7x2XZcGJ29FP7Uymvk3A5pwvhuVPwpv0Z8aSrDxAwmYfNe8Vn6AOP9ePmN2pSC
        SzqcBnKcu08UunUe2KrnzHv55bQUp3I=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-JS2JK3khPqufUSZkzh0r2g-1; Tue, 01 Mar 2022 06:41:12 -0500
X-MC-Unique: JS2JK3khPqufUSZkzh0r2g-1
Received: by mail-wr1-f71.google.com with SMTP id w2-20020adfbac2000000b001ea99ca4c50so3186582wrg.11
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 03:41:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jevPAIDXbxsqcggLiSAPMZ0qjGRa8Dl/g8BqBRC/KzU=;
        b=zk6pCPpBc2xkthw1GVlLxktEy/jzKLryAsmdniVf44jfPfY+PJf2oi7BtShepbwhUU
         M1U9v8ueeg97U3MBDLoSY3Jhf4P1AXoHziwfB/wPbJo+pDKswoh1iaUKXV4F0OA6PEqT
         m2GGSQRUHDhl3y5w2hB338aoCfwFnxgIKpOpVykrKFgCfehrvbzn4K79algl0Y/YglzM
         haBVcREbU6VztbrGYZ8U2oNlQTXIyQ8rSlypLI243UkcPmz+lyPUtBk/d9H+VgniIYaG
         0qC0tSUjxWCVQJNUBrJ+xY0OCEz43minLRwQMtUS35ARLi4DD6xZg4VNuKKwUjzR0Vt9
         WkLA==
X-Gm-Message-State: AOAM530Ufplm4ZdhUFmwuA36gLVSjko9DNiw90F8UmiHHe2CJIKTh++n
        VYgrLZF8u6+Ok6sfUcbci/hWE5v6t3vMdkf+8z23GOYMMixJnE7OVA1uFMqOBV6Q6Hhl/yLW+ow
        SjTj/bb1ZOqdLYGlD
X-Received: by 2002:a05:6000:3c8:b0:1ef:64e8:9235 with SMTP id b8-20020a05600003c800b001ef64e89235mr15677939wrg.498.1646134871134;
        Tue, 01 Mar 2022 03:41:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwf2wF1Yh6vS0H0Oh+qYQk98tPNMgDemN1vAooBUtkNAzcJ/cJABcF0ZYGmw4mgJhoQR5AG4A==
X-Received: by 2002:a05:6000:3c8:b0:1ef:64e8:9235 with SMTP id b8-20020a05600003c800b001ef64e89235mr15677918wrg.498.1646134870839;
        Tue, 01 Mar 2022 03:41:10 -0800 (PST)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id 10-20020adf808a000000b001edd413a952sm13622450wrl.95.2022.03.01.03.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:41:09 -0800 (PST)
Date:   Tue, 1 Mar 2022 12:41:07 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net] ipv4: fix route lookups when handling ICMP redirects
 and PMTU updates
Message-ID: <20220301114107.GB24680@debian.home>
References: <cffd245430d10fa2a14c32d1c768eef7cfeb8963.1646068241.git.gnault@redhat.com>
 <922b4932-fcd5-d362-4679-6689046560c7@kernel.org>
 <20220228205440.GA24680@debian.home>
 <faca5750-911d-151f-d5fa-7a8ed3b43b08@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faca5750-911d-151f-d5fa-7a8ed3b43b08@kernel.org>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 09:31:09PM -0700, David Ahern wrote:
> On 2/28/22 1:54 PM, Guillaume Nault wrote:
> > On Mon, Feb 28, 2022 at 10:31:58AM -0700, David Ahern wrote:
> >> On 2/28/22 10:16 AM, Guillaume Nault wrote:
> >>> Fixes: d3a25c980fc2 ("ipv4: Fix nexthop exception hash computation.")
> >>
> >> That does not seem related to tos in the flow struct at all.
> > 
> > Ouch, copy/paste mistake.
> > I meant 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions."), which is
> > the next commit with 'git log -- net/ipv4/route.c'.
> > Really sorry :/, and thanks a lot for catching that!
> > 
> >>> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> >>> index f33ad1f383b6..d5d058de3664 100644
> >>> --- a/net/ipv4/route.c
> >>> +++ b/net/ipv4/route.c
> >>> @@ -499,6 +499,15 @@ void __ip_select_ident(struct net *net, struct iphdr *iph, int segs)
> >>>  }
> >>>  EXPORT_SYMBOL(__ip_select_ident);
> >>>  
> >>> +static void ip_rt_fix_tos(struct flowi4 *fl4)
> >>
> >> make this a static inline in include/net/flow.h and update
> >> flowi4_init_output and flowi4_update_output to use it. That should cover
> >> a few of the cases below leaving just  ...
> > 
> > Hum, I didn't think about this option, but it looks risky to me. As I
> > put it in note 1, ip_route_output_key_hash() unconditionally sets
> > ->flowi4_scope, assuming it can infer the scope from the RTO_ONLINK bit
> > of ->flowi4_tos. If we santise these fields in flowi4_init_output()
> > (and flowi4_update_output()), then ip_route_output_key_hash() would
> > sometimes work on already santised values and sometimes not. So it
> > wouldn't know if it should initialise ->flowi4_scope.
> > 
> > We could decide to let ip_route_output_key_hash() initialise
> > ->flowi4_scope only when the RTO_ONLINK bit is set, which
> > guarantees that we don't have sanitised values. But before that, we'd
> > need to audit all other callers, to verify that they correctly
> > initialise the ->flowi4_scope with RT_SCOPE_UNIVERSE, since
> > ip_route_output_key_hash() isn't going do it for them anymore.
> > I'll audit all these callers, but that should be something for
> > net-next.
> 
> I'm not following the response. You are moving the tos logic from
> ip_route_output_key_hash to a helper and calling the new helper for
> other fib lookups. My suggestion was to correctly set / fixup the tos
> and scope when flowi4 is initialized (reducing the number of places the
> fixup is needed) and recognizing below that ip_route_output_key_hash
> still needs the call to the new ip_rt_fix_tos.

The problem is that we can't santitise fl4 twice:

    fl4->flowi4_tos = 0x04 | RTO_ONLINK;
    fl4->flowi4_scope = whatever;

    ip_rt_fix_tos(fl4);
    /* Now ->flowi4_tos == 0x04 and ->flowi4_scope == RT_SCOPE_LINK */

    ip_rt_fix_tos(fl4);
    /* Now ->flowi4_scope is wrongly changed to RT_SCOPE_UNIVERSE */

Therefore we can't call the helper in ip_route_output_key_hash() "just
in case", because that has to be done exactly once and we can't know
whether fl4 has already been sanitised or not.

The second part of my reply was about trying to allow double calls to
ip_rt_fix_tos() (as it's required for the solution you proposed). It
looks like all call paths initialise ->flowi4_scope to zero (that is,
RT_SCOPE_UNIVERSE). If that's really the case, then ip_rt_fix_tos()
could reset ->flowi4_scope only when RTO_ONLINK is on. Then we wouldn't
have to worry about the problem described above. But that requires
auditing all code paths to ensure that they all of properly initialise
the scope to RT_SCOPE_UNIVERSE, otherwise we risk introducing
regressions because of uninitialised ->flowi4_scope. So this kind of
work seems better suited for the net-next tree.

And my final point was that the need for ip_rt_fix_tos() is temporary:
I plan to do the call paths review anyway, to make them initialise tos
and scope properly, thus removing the need for RTO_ONLINK. I already
have a draft patch series, but as I said that's work for net-next.

> > 
> >>> @@ -2613,9 +2625,7 @@ struct rtable *ip_route_output_key_hash(struct net *net, struct flowi4 *fl4,
> >>>  	struct rtable *rth;
> >>>  
> >>>  	fl4->flowi4_iif = LOOPBACK_IFINDEX;
> >>> -	fl4->flowi4_tos = tos & IPTOS_RT_MASK;
> >>> -	fl4->flowi4_scope = ((tos & RTO_ONLINK) ?
> >>> -			 RT_SCOPE_LINK : RT_SCOPE_UNIVERSE);
> >>> +	ip_rt_fix_tos(fl4);
> >>
> >> ... this one to call the new helper.
> > 
> > BTW, here's a bit more about the context around this patch.
> > I found the problem while working on removing the use of RTO_ONLINK, so
> > that ->flowi4_tos could be converted to dscp_t.
> > 
> > The objective is to modify callers so that they'd set ->flowi4_scope
> > directly, instead using RTO_ONLINK to mark their intention (and that's
> > why I said I'd have to audit them anyway).
> > 
> > Once that will be done, ip_rt_fix_tos() won't have to touch the scope
> > anymore. And once ->flowi4_tos will be converted to dscp_t, we'll can
> > remove that function entirely since dscp_t ensures ECN bits are cleared
> > (IPTOS_RT_MASK also ensures that high order bits are cleared too, but
> > that's redundant with the RT_TOS() calls already done by callers, and
> > which somewhat aren't really desirable anyway).
> > 
> 
> 
> 

