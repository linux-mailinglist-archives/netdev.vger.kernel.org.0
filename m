Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995D3629A8D
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 14:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbiKONdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 08:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238379AbiKONdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 08:33:14 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C502B191
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:32:34 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id f3so6858394pgc.2
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x/Q+6DAWM/b5RnGpqSL+5blzuITCltHOk+UWXX+QkKU=;
        b=GBNF3eQcGCAe3wvIcsBKK5rlB8MvKrb2kCW6/ECl577Sz+lQfKaLjhoB/AfmMJjozr
         rLcU4QFHdP8H035uLBVTUZLy014kTkBpvb0mc//b5NEdoXBdzL8/uTEEr06ej8TcAF0z
         R/WBqgyEUflzPcwvMC9OFbqQ5LUdEuvKBr71N3yoioR6hweWGqThYLQANH47pRg79ekR
         EYIgMQ4DVcKRkeFE3e+E5FYZDimIhBGJOt7FYJFF1Yo5kvdpklCoT0UDMLDrJSByooTK
         eC/TAxfzeR9gyWTgxAcnVk7jHLogGkZM0+O1GMiSMtN9uUhyRGQeGMdNcKBIxZ+93NI0
         HXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x/Q+6DAWM/b5RnGpqSL+5blzuITCltHOk+UWXX+QkKU=;
        b=o1V0Cs9DnMq63tBBxrmSAfW/+a4p4DHBOPVAEjUZwTIe2WQOAPWmrg4Ai38gAUD7yV
         4rFvA4qMsZw/VTB7iwrk3e+SbPYpaLXzXXdA/IFNcHOFZ08ZQbqzlxR/wqVn0iuPgaYk
         cb/cYDH7KFaOxkfQlu1zVLFkLLDR7RAolSlnHfalBiUTLPNISQNYvEQpRtKL6J0hgyH1
         hlHh+11dhOHAPUUGt1bYIzQq3JWiBMRx5rIOIfdLxwSclhapXvCoJT6UR+XZzY+S7RLv
         21epU667oPVfpxbZ856QeEg5Nn+nzg6XcHzSb3vZFhqxYKgDHBXsJQIMLE+7sONxJyrY
         CtVA==
X-Gm-Message-State: ANoB5pl7HBgWj5IYVCmabLsGDGV4BcCd+PeisHs6uWREZwfXqriV9Hd/
        EZem5bY/kHsrCQ+RQxmz4/++JECqxRhMVQ==
X-Google-Smtp-Source: AA0mqf42FM8w0UHszQCZR+FgE8D40yrb2z5J6e4STt0zkEq7GAa8xhJpwmro6eQ0ppLNtD+F6uczrg==
X-Received: by 2002:a05:6a00:2162:b0:572:341f:f06a with SMTP id r2-20020a056a00216200b00572341ff06amr7644237pff.67.1668519153458;
        Tue, 15 Nov 2022 05:32:33 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z27-20020aa7959b000000b00565cf8c52c8sm8954617pfj.174.2022.11.15.05.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 05:32:32 -0800 (PST)
Date:   Tue, 15 Nov 2022 21:32:27 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Tom Herbert <tom@herbertland.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCHv2 net] net: use struct_group to copy addresses
Message-ID: <Y3OU6z1PnKiRwzfK@Laptop-X1>
References: <20221114081210.1033795-1-liuhangbin@gmail.com>
 <20221114211645.539397df@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114211645.539397df@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 09:16:45PM -0800, Jakub Kicinski wrote:
> On Mon, 14 Nov 2022 16:12:10 +0800 Hangbin Liu wrote:
> > diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
> > index 961ec16a26b8..6f7e833a00f7 100644
> > --- a/include/uapi/linux/ip.h
> > +++ b/include/uapi/linux/ip.h
> > @@ -100,8 +100,10 @@ struct iphdr {
> >  	__u8	ttl;
> >  	__u8	protocol;
> >  	__sum16	check;
> > -	__be32	saddr;
> > -	__be32	daddr;
> > +	struct_group(addrs,
> > +		__be32	saddr;
> > +		__be32	daddr;
> > +	);
> >  	/*The options start here. */
> >  };
> >  
> > diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
> > index 03cdbe798fe3..3a3a80496c7c 100644
> > --- a/include/uapi/linux/ipv6.h
> > +++ b/include/uapi/linux/ipv6.h
> > @@ -130,8 +130,10 @@ struct ipv6hdr {
> >  	__u8			nexthdr;
> >  	__u8			hop_limit;
> >  
> > -	struct	in6_addr	saddr;
> > -	struct	in6_addr	daddr;
> > +	struct_group(addrs,
> > +		struct	in6_addr	saddr;
> > +		struct	in6_addr	daddr;
> > +	);
> >  };
> >  
> 
> Can you double check the build with clang? It seems to fail with an odd
> message, maybe some includes missing?
> 
> In file included from ./usr/include/linux/if_tunnel.h:7:
> usr/include/linux/ip.h:103:2: error: type name requires a specifier or qualifier
>         struct_group(addrs,
>         ^

Ah, because this is a UAPI header, we need to use __struct_group() here.
I will fix it. Thanks for the info.

Hangbin
