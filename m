Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717C15F61A1
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 09:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiJFH3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 03:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJFH3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 03:29:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B291F1B7A0
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 00:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665041385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+onFayfmRn/AXIe5HouFuxXCDT2hToP93mFlxrmsSpQ=;
        b=EBAGUIiNIzqCH5TlLZ1g9Dxg2Fnkf1tYv3Bvov6s1nMeWq5GVYbw0oqS0rttvZoe8hrGZA
        EM24C4gMSCXPUFdKJJIVQ50Gl4vYAYhoMSjWyZ+E9+s7UlTkEyqXe1B0cs2fiCrarxYKNJ
        fLh1/g17ib7YYytbIVKYBrhtZUq+JDE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-518-KD4d_2SYMs6cqPvxHdrYSw-1; Thu, 06 Oct 2022 03:29:45 -0400
X-MC-Unique: KD4d_2SYMs6cqPvxHdrYSw-1
Received: by mail-wr1-f72.google.com with SMTP id i26-20020adfaada000000b0022e2f38ffccso182499wrc.14
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 00:29:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=+onFayfmRn/AXIe5HouFuxXCDT2hToP93mFlxrmsSpQ=;
        b=nRAKyAo902Lh8Q9RlzuUe9ejvK53IwvyPp93SGzof228ownq356AR81SkmKGtHL4Pd
         x55YaVWOBmiN1NbcqJNx+MenU9q51CpSmokgQB19FC2+TyDMhrrP7FaQ8jZC8dKT1fju
         A/DCKROjus9V3Kn1mRat+jMEX35BVP4x+K2EEsO0IjMPhyNwzAVxLDWK4LeC1JdX5BRI
         hnAaNd79Qnc9P397UkJNd03mmFwFVGbumfDEQsJB09+u01/3BA44dpqWDlS7tCWVNG+N
         NKUk/4CeVkBYGCEblYdLOAC05TeF36V+pnb7JE/nUsntskNh7yejx04XYr67DozmlMlq
         FoxQ==
X-Gm-Message-State: ACrzQf3+Rpl8xi8Do33j1IU3s42tb8/c9oAQtGLKWEZ6ueyJVcNUEydZ
        n1oCByKj6w+ECX1cvaAGoIxKmi+xRFER4vQnuU2rHxe0bErLNBXkkSAQhH0H08fki9DMYX43UPL
        IqfW1imKQ+VO1qCu8
X-Received: by 2002:a5d:598f:0:b0:22a:f74d:ae24 with SMTP id n15-20020a5d598f000000b0022af74dae24mr2083525wri.544.1665041383713;
        Thu, 06 Oct 2022 00:29:43 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5yc75iHR/HQTeUt3VPkEl9GoKjlX+oX7ok555daDKoc6Y1HLmOGc2d3Af77wuZ1zAg2Jx7bQ==
X-Received: by 2002:a5d:598f:0:b0:22a:f74d:ae24 with SMTP id n15-20020a5d598f000000b0022af74dae24mr2083509wri.544.1665041383405;
        Thu, 06 Oct 2022 00:29:43 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id e18-20020adff352000000b0022cdb687bf9sm21783600wrp.0.2022.10.06.00.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 00:29:42 -0700 (PDT)
Message-ID: <7abd24501a058737c44b9dff4bf1779644b4658d.camel@redhat.com>
Subject: Re: [PATCH net] ipv4: Handle attempt to delete multipath route when
 fib_info contains an nh reference
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ido Schimmel <idosch@idosch.org>, David Ahern <dsahern@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        Gwangun Jung <exsociety@gmail.com>
Date:   Thu, 06 Oct 2022 09:29:36 +0200
In-Reply-To: <Yz56ZBVMUC/vmKhP@shredder>
References: <20221005181257.8897-1-dsahern@kernel.org>
         <Yz3WE+cBd9YUj7Bp@shredder>
         <84202713-ec7c-1e5e-8d9f-d36e715c81e4@kernel.org>
         <Yz56ZBVMUC/vmKhP@shredder>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-10-06 at 09:49 +0300, Ido Schimmel wrote:
> On Wed, Oct 05, 2022 at 01:27:59PM -0600, David Ahern wrote:
> > On 10/5/22 1:08 PM, Ido Schimmel wrote:
> > > On Wed, Oct 05, 2022 at 12:12:57PM -0600, David Ahern wrote:
> > > > Gwangun Jung reported a slab-out-of-bounds access in fib_nh_match:
> > > >     fib_nh_match+0xf98/0x1130 linux-6.0-rc7/net/ipv4/fib_semantics.c:961
> > > >     fib_table_delete+0x5f3/0xa40 linux-6.0-rc7/net/ipv4/fib_trie.c:1753
> > > >     inet_rtm_delroute+0x2b3/0x380 linux-6.0-rc7/net/ipv4/fib_frontend.c:874
> > > > 
> > > > Separate nexthop objects are mutually exclusive with the legacy
> > > > multipath spec. Fix fib_nh_match to return if the config for the
> > > > to be deleted route contains a multipath spec while the fib_info
> > > > is using a nexthop object.
> > > 
> > > Cool bug... Managed to reproduce with:
> > > 
> > >  # ip nexthop add id 1 blackhole
> > >  # ip route add 192.0.2.0/24 nhid 1
> > >  # ip route del 192.0.2.0/24 nexthop via 198.51.100.1 nexthop via 198.51.100.2
> > 
> > that's what I did as well.
> 
> :)
> 
> > 
> > > 
> > > Maybe add to tools/testing/selftests/net/fib_nexthops.sh ?
> > 
> > I have one in my tree, but in my tests nothing blew up or threw an error
> > message. It requires KASAN to be enabled otherwise the test does not
> > trigger anything.
> 
> That's fine. At least our team is running this test as part of
> regression on a variety of machines, some of which run a debug kernel
> with KASAN enabled. The system knows to fail a test if a splat was
> emitted to the kernel log.
> 
> > 
> > > 
> > > Checked IPv6 and I don't think we can hit it there, but I will double
> > > check tomorrow morning.
> > > 
> > > > 
> > > > Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
> > > > Reported-by: Gwangun Jung <exsociety@gmail.com>
> > > > Signed-off-by: David Ahern <dsahern@kernel.org>
> > > > ---
> > > >  net/ipv4/fib_semantics.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > > 
> > 
> > > 
> > > There is already such a check above for the non-multipath check, maybe
> > > we can just move it up to cover both cases? Something like:
> > > 
> > > diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> > > index 2dc97583d279..e9a7f70a54df 100644
> > > --- a/net/ipv4/fib_semantics.c
> > > +++ b/net/ipv4/fib_semantics.c
> > > @@ -888,13 +888,13 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
> > >  		return 1;
> > >  	}
> > >  
> > > +	/* cannot match on nexthop object attributes */
> > > +	if (fi->nh)
> > > +		return 1;
> > 
> > that should work as well. I went with the simplest change that would
> > definitely not have a negative impact on backports.
> 
> Ha, I see this hunk was added by 6bf92d70e690b. Given how overzealous
> the AUTOSEL bot is, I don't expect this fix to be missing from stable
> kernels. If you also blame 6bf92d70e690b (given it was apparently
> incomplete), then it makes it clear to anyone doing the backport that
> 6bf92d70e690b is needed as well.
> 
> I prefer having the check at the beginning because a) It would have
> avoided this bug b) It directly follows the 'cfg->fc_nh_id' check,
> making it clear that we never match if nexthop ID was not specified, but
> we got a FIB info with a nexthop object.

I also think this other option is better, and I think the backport
effort will be mostly unaffected: a kernel needing 6bf92d70e690b but
not the above fix would be quite a strange/completely unexpected
subject for stable backport.

Could you please consider a v2 moving the check upwards?

Thanks!

Paolo

