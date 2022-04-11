Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B287C4FBC81
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346225AbiDKMyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiDKMyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:54:45 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4051573E
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:52:32 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2ed65e63afcso4343037b3.9
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nDDRbQiIQRSeHC/3d3J4BFZGwMAUxbB9q3bf9fVXELk=;
        b=gVa8ZQczCx6d/DBPVBBQiHTaYXXbttT8LxGEmfn9LJZUzUcovdbutXKJvCUqW51Rl2
         jyIpQE5ERja//P+cCJci1bNGytTskfGYunL+7xsmc/q2Y3jqFkmjENS3Rm4yFYLFX474
         sTh30Jm7B+NfzW1bhxunsrFLq5ELHBMgebO5LtY7jRUhIQz4qy6ELy7UosJwM2sql8ba
         5yjIx7H88vPufo3Cm5XgMcmgqMb2bH0nGo8iay5ljE5/2RZuqaYMsrgFfqKMWFEJacZo
         QB4Py+FXihIvNJmLM5qc+P5GZ9mC+HIndlhcBGN4pEPT6GQFoV6vpuS0G+4EJamEWORY
         F9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nDDRbQiIQRSeHC/3d3J4BFZGwMAUxbB9q3bf9fVXELk=;
        b=bVWY58HV7AnlsGgd6jk8oQZK/Y5Qnxr76SftFgSm6FdV1yeZf+JTi2lQwH2+9WwEc+
         T41uCzHL5WqAj5ofGAVdNqGSikemnAU87gsZ5wslzUaVHSGc5t2e6H7ZNTiHoULNy8lx
         pdxLdfqTWTFC0l83WUgXuC7LMSk0rMW31eORkqgumoYVhciibbhyEjn9kwGR47CELZdo
         nJRc8H4+LGapUIsMNAKCHBODO3m71COPIBIB0m2g8yd5n4Fs/zDezm0OHj6FkqlFqeTV
         FnzCpNPaFjhC3ToSZkuzcTE5SP7yAvZifaITNs7l+uCJiho7V5Vk+oZEe8qZUIJHtQpm
         wqEg==
X-Gm-Message-State: AOAM532ImyEI/iBf6ZIRiK0tlKw4/XyA2wWcHFfPgQ+/xPKTB9Ohe/AV
        17wmxwKeXkCJUkFcYYL3qgkSH4pMRhlKz09Y5fXPxQ==
X-Google-Smtp-Source: ABdhPJxBQGPMCPCXU8/C1KJ2sIx7m//eoszf3fMDU6sTC3V+EJrp5yy7DhpJ4kJJmv+iEcKk93lqGrlGCPQ61UVBbiM=
X-Received: by 2002:a81:6988:0:b0:2ec:3a5:dedb with SMTP id
 e130-20020a816988000000b002ec03a5dedbmr6673213ywc.160.1649681551267; Mon, 11
 Apr 2022 05:52:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649528984.git.lorenzo@kernel.org> <628c0a6d9bdbc547c93fcd4ae2e84d08af7bc8e1.1649528984.git.lorenzo@kernel.org>
 <CAC_iWj+wGjx4uAmtkvP=kJsD1uBKsxUXPfy8YS8Abhz=ooLmkg@mail.gmail.com>
 <YlQe8QysuyGRtxAx@lore-desk> <CAC_iWj+fk4hkpBQE6SnusVHFJMoq3u40Hn2VK7uCmUADXM2MPQ@mail.gmail.com>
 <YlQj11JOHOYB+f62@lunn.ch>
In-Reply-To: <YlQj11JOHOYB+f62@lunn.ch>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Mon, 11 Apr 2022 15:51:55 +0300
Message-ID: <CAC_iWjLs0iT+gVxn8WJJrfQAmb923KdLuOv9UcgUSwGX8LnVow@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 1/2] net: page_pool: introduce ethtool stats
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, jbrouer@redhat.com, jdamato@fastly.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, 11 Apr 2022 at 15:49, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Apr 11, 2022 at 03:34:21PM +0300, Ilias Apalodimas wrote:
> > On Mon, 11 Apr 2022 at 15:28, Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >
> > > > Hi Lorenzo,
> > >
> > > Hi Ilias,
> > >
> > > >
> > > > [...]
> > > >
> > > > >
> > > > >         for_each_possible_cpu(cpu) {
> > > > >                 const struct page_pool_recycle_stats *pcpu =
> > > > > @@ -66,6 +87,47 @@ bool page_pool_get_stats(struct page_pool *pool,
> > > > >         return true;
> > > > >  }
> > > > >  EXPORT_SYMBOL(page_pool_get_stats);
> > > > > +
> > > > > +u8 *page_pool_ethtool_stats_get_strings(u8 *data)
> > > > > +{
> > > > > +       int i;
> > > > > +
> > > > > +       for (i = 0; i < ARRAY_SIZE(pp_stats); i++) {
> > > > > +               memcpy(data, pp_stats[i], ETH_GSTRING_LEN);
> > > > > +               data += ETH_GSTRING_LEN;
> > > > > +       }
> > > > > +
> > > > > +       return data;
> > > >
> > > > Is there a point returning data here or can we make this a void?
> > >
> > > it is to add the capability to add more strings in the driver code after
> > > running page_pool_ethtool_stats_get_strings.
> >
> > But the current driver isn't using it.
>
> It could be you need it for the mlx5 driver, which puts the TLS
> counters after the page pool counters. Or you could just move them to
> the end. I don't think the order of statistics are ABI, just the
> strings themselves..
>
> > I don't have too much
> > experience with how drivers consume ethtool stats, but would it make
> > more sense to return a length instead of a pointer? Maybe Andrew has
> > an idea.
>
> Either is acceptable. Even if you do make it a void, the driver can
> use the stats_get_count() and do the maths. But a length or a pointer
> is simpler.

Thanks, I am fine with either as well.   I was just wondering why we
need it since the mvneta driver wasn't using it. Let's leave it as is

/Ilias
>
>    Andrew
