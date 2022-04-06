Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFD54F6E26
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 01:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbiDFXDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 19:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiDFXDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 19:03:41 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F49670851
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 16:01:42 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id q12so230388pla.9
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 16:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yUNiJ50JIxcSmT5dMDkLsYzs3biF1S9Y/XikpDUh7ZA=;
        b=Yj3qtX7CIxDtpaarH3n6RF1fmljiS9hL/CO7+XNpt6dnXVdy5ajBllb2FTvIQ9f3Yd
         a0o3zNSVjzAeg5Zj/5sKvbav5pKj/Rd7LnhB0y3y+9T31uAz7BCKgU33yLQgNjit293L
         JRqu86ucEWia19rGrheBjT0YfXpOrB8tnxlEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yUNiJ50JIxcSmT5dMDkLsYzs3biF1S9Y/XikpDUh7ZA=;
        b=cQKB6HKXe2ejfyJD8wsd2zFKCWhA3U7gJdJHb0NDdWuECX34upQWy0WdOu/JVFAEs4
         4mDzb8Gnu8Y15TBDaJZlIaum9vGjt4UCyRNGlA96IFYZviofU+dBksvfS6QRmlQyhJQF
         rftcx3zhXF/mZXIWqJgurwbaYkzfO8w2V5f7m6rw7+nwdHlCbQ+sZAXzsyY+Znk721HQ
         K0ckW0tePY0m0h1HaOIcECWoifjhBCbDOn5ESwQMVLL8fy5aHewRWikbq0D0ouQnsmzM
         Yc0oMhtH4vfPP+k3btFr2HjhIXOn6jxU6s3dnvQI8SHmgpg4kX/fdrYUHiCes8UzNYT3
         w6wg==
X-Gm-Message-State: AOAM531uZCOfVwCQmPTVbMJPvNkj+vwdEZGtGEdyYhBq16zpeUGc12yQ
        yDnCpeDUqTK88c+clZZZNfRhQA==
X-Google-Smtp-Source: ABdhPJx4J4ed2jVRZuan3CAObS2VHwH6FWIfjqXBD9YB8D3ycYH5/5v82R3dbJcDoymCzJkZZDUFzQ==
X-Received: by 2002:a17:903:11d1:b0:151:9fb2:9858 with SMTP id q17-20020a17090311d100b001519fb29858mr10716992plh.136.1649286101696;
        Wed, 06 Apr 2022 16:01:41 -0700 (PDT)
Received: from fastly.com (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id m15-20020a638c0f000000b003827bfe1f5csm16997457pgd.7.2022.04.06.16.01.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Apr 2022 16:01:41 -0700 (PDT)
Date:   Wed, 6 Apr 2022 16:01:37 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, jbrouer@redhat.com,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next] net: mvneta: add support for page_pool_get_stats
Message-ID: <20220406230136.GA96269@fastly.com>
References: <e4a3bb0fb407ead607b85f7f041f24b586c8b99d.1649190493.git.lorenzo@kernel.org>
 <Yk2X6KPyeN3z7OUW@lunn.ch>
 <Yk2dhD2rjQQaF4Pc@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yk2dhD2rjQQaF4Pc@lore-desk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 04:02:44PM +0200, Lorenzo Bianconi wrote:
> > > +static void mvneta_ethtool_update_pp_stats(struct mvneta_port *pp,
> > > +					   struct page_pool_stats *stats)
> > > +{
> > > +	int i;
> > > +
> > > +	memset(stats, 0, sizeof(*stats));
> > > +	for (i = 0; i < rxq_number; i++) {
> > > +		struct page_pool *page_pool = pp->rxqs[i].page_pool;
> > > +		struct page_pool_stats pp_stats = {};
> > > +
> > > +		if (!page_pool_get_stats(page_pool, &pp_stats))
> > > +			continue;
> > > +
> > > +		stats->alloc_stats.fast += pp_stats.alloc_stats.fast;
> > > +		stats->alloc_stats.slow += pp_stats.alloc_stats.slow;
> > > +		stats->alloc_stats.slow_high_order +=
> > > +			pp_stats.alloc_stats.slow_high_order;
> > > +		stats->alloc_stats.empty += pp_stats.alloc_stats.empty;
> > > +		stats->alloc_stats.refill += pp_stats.alloc_stats.refill;
> > > +		stats->alloc_stats.waive += pp_stats.alloc_stats.waive;
> > > +		stats->recycle_stats.cached += pp_stats.recycle_stats.cached;
> > > +		stats->recycle_stats.cache_full +=
> > > +			pp_stats.recycle_stats.cache_full;
> > > +		stats->recycle_stats.ring += pp_stats.recycle_stats.ring;
> > > +		stats->recycle_stats.ring_full +=
> > > +			pp_stats.recycle_stats.ring_full;
> > > +		stats->recycle_stats.released_refcnt +=
> > > +			pp_stats.recycle_stats.released_refcnt;
> > 
> > Am i right in saying, these are all software stats? They are also
> > generic for any receive queue using the page pool?
> 
> yes, these stats are accounted by the kernel so they are sw stats, but I guess
> xdp ones are sw as well, right?
> 
> > 
> > It seems odd the driver is doing the addition here. Why not pass stats
> > into page_pool_get_stats()? That will make it easier when you add
> > additional statistics?
> > 
> > I'm also wondering if ethtool -S is even the correct API. It should be
> > for hardware dependent statistics, those which change between
> > implementations. Where as these statistics should be generic. Maybe
> > they should be in /sys/class/net/ethX/statistics/ and the driver
> > itself is not even involved, the page pool code implements it?
> 
> I do not have a strong opinion on it, but I can see an issue for some drivers
> (e.g. mvpp2 iirc) where page_pools are not specific for each net_device but are shared
> between multiple ports, so maybe it is better to allow the driver to decide how
> to report them. What do you think?

When I did the implementation of this API the feedback was essentially
that the drivers should be responsible for reporting the stats of their
active page_pool structures; this is why the first driver to use this
(mlx5) uses the API and outputs the stats via ethtool -S.

I have no strong preference, either, but I think that exposing the stats
via an API for the drivers to consume is less tricky; the driver knows
which page_pools are active and which pool is associated with which
RX-queue, and so on.

If there is general consensus for a different approach amongst the
page_pool maintainers, I am happy to implement it.

Thanks,
Joe
