Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E141067C899
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236545AbjAZKcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbjAZKcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:32:03 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A365E4C6F6
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:32:02 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lc27so1381157ejc.1
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2o+HoseOnCIchZyk5OszUnjY2GrV9Ay/6XIdADJkds4=;
        b=kAY51BiXI/JmjHy8jX6Dp0XN4nM5qjwHxCERugk/ZCFAZwAhOmpk8jSsZiyfipMVS9
         iVa9NFBA7JsbrG+EOFltfWhZodvF/czOPLFIWEDMrDExi4xxenPGAKawh+1TtPZ9czl5
         BNwxw7PoM0/ho5VPUJoICbQ3G0S7sSToNYLe40Id88OO73iwg405gYSryJxHYkKibFmP
         +ompQowG5QQzcQK5DAKjldGfAktbQHSIvBkczArBTIvJR6rCm2mc1pmKMIoCI+koexNt
         yzc0YOV8Efmwj/48VDVmj6ujyPZrqbopRUgS3brIX6lcEDGLy1awEMGpxgPRYlkOlQZH
         4CQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2o+HoseOnCIchZyk5OszUnjY2GrV9Ay/6XIdADJkds4=;
        b=uk3H7ITRTfZE6vMfUYAYEzvKML2RwkWm7lWqL+QDSxfeMEqygI0hMrUpkG3pdmaQht
         WXY21Lk5NcU2ZOOq0wvW1A4679KDAcMsq2RYdSvh5QfOHlli0nhD7D3SPp+Mx3ZWF5XW
         bw5anQc5wbHSvoz0LZwC/cjBCrNOVGqSxcne9KuZk9KMyURoLPsWPN45U34RloG6hfmC
         KEIOnEVGaXJ6K9twqSFzX/gQVNqzH6PD8KAml2kyNVowvgnUpTPed2bfj3Vqof3bLLvZ
         s06PenGZwr7pyh+dWUht7PixNoOtmPSOgj0G2fxRpz9FjKlQyjxfDR36j5WLsW15NnXY
         gOgA==
X-Gm-Message-State: AFqh2krs8bWEHfHSHu2DKrnzevg6nQJqW0t62biIwni6PyWAlasiLReX
        P5pl5+UqcWx6EC31bJ7sj4LcjQ==
X-Google-Smtp-Source: AMrXdXsp4qXNFJjtjuwZq9/OBMaOEUE2B4AuKwUSBSgv0CHaHnfpL+CUNcOrYOQRsIgw/Ac0veIHDw==
X-Received: by 2002:a17:906:762a:b0:7c0:be5d:59a9 with SMTP id c10-20020a170906762a00b007c0be5d59a9mr45229259ejn.20.1674729121131;
        Thu, 26 Jan 2023 02:32:01 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id 21-20020a170906311500b0087045ae5935sm399381ejx.1.2023.01.26.02.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 02:32:00 -0800 (PST)
Date:   Thu, 26 Jan 2023 12:31:58 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented
 allocation
Message-ID: <Y9JWniFQmcc7m5Ey@hera>
References: <20230124124300.94886-1-nbd@nbd.name>
 <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
 <f3d079ce930895475f307de3fdaed0b85b4f2671.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3d079ce930895475f307de3fdaed0b85b4f2671.camel@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

Sorry for being late to the party,  was overloaded...

On Tue, Jan 24, 2023 at 07:57:35AM -0800, Alexander H Duyck wrote:
> On Tue, 2023-01-24 at 16:11 +0200, Ilias Apalodimas wrote:
> > Hi Felix,
> >
> > ++cc Alexander and Yunsheng.
> >
> > Thanks for the report
> >
> > On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> wrote:
> > >
> > > While testing fragmented page_pool allocation in the mt76 driver, I was able
> > > to reliably trigger page refcount underflow issues, which did not occur with
> > > full-page page_pool allocation.
> > > It appears to me, that handling refcounting in two separate counters
> > > (page->pp_frag_count and page refcount) is racy when page refcount gets
> > > incremented by code dealing with skb fragments directly, and
> > > page_pool_return_skb_page is called multiple times for the same fragment.
> > >
> > > Dropping page->pp_frag_count and relying entirely on the page refcount makes
> > > these underflow issues and crashes go away.
> > >
> >
> > This has been discussed here [1].  TL;DR changing this to page
> > refcount might blow up in other colorful ways.  Can we look closer and
> > figure out why the underflow happens?
> >
> > [1] https://lore.kernel.org/netdev/1625903002-31619-4-git-send-email-linyunsheng@huawei.com/
> >
> > Thanks
> > /Ilias
> >
> >
>
> The logic should be safe in terms of the page pool itself as it should
> be holding one reference to the page while the pp_frag_count is non-
> zero. That one reference is what keeps the two halfs in sync as the
> page shouldn't be able to be freed until we exhaust the pp_frag_count.

Do you remember why we decided to go with the fragment counter instead of
page references?

>
> To have an underflow there are two possible scenarios. One is that
> either put_page or free_page is being called somewhere that the
> page_pool freeing functions should be used.

Wouldn't that affect the non fragmented path as well? IOW the driver that
works with a full page would crash as well.

> The other possibility is
> that a pp_frag_count reference was taken somewhere a page reference
> should have.
>
> Do we have a backtrace for the spots that are showing this underrun? If
> nothing else we may want to look at tracking down the spots that are
> freeing the page pool pages via put_page or free_page to determine what
> paths these pages are taking.

Thanks
/Ilias
