Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12EB48B7B1
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 20:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239037AbiAKT5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 14:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbiAKT5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 14:57:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40376C06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 11:57:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0830EB81D1D
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 19:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8776DC36AE9;
        Tue, 11 Jan 2022 19:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641931025;
        bh=5TEPsU5TU2ZmUpqFeVDFVwU70QEe0awWx2oN7MV306c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tZjhCbLCo9XjvoSN3XhUMZ1XtPT2biX9K/OdJsk4wklAcfW//TchLZY0EQBLJXHDH
         PimF9e0+yyMVrHsooWZfSCRlCjLqNILwEexTCT3pwqKvdW4KpsditOEq++lQXuh3rd
         ol94HNAppJP5NXWytsLYGlrTVBgRi8PlxT9tWBFPB0yfgcl0ovp+zn9SGf2LkFjXcq
         snVs1I6F816xnTCTq9kow8mVcOl1xpSp6vzmtKnWLy5vmbNQItI5YrKYzUje+bDyY6
         IZn8viNpUl1mLFhilsogLqx1eZwt0d4brKtwMCTTuhZHUJRXTT+JW1CQthBznQ58+h
         91XlOsJ47e4yQ==
Date:   Tue, 11 Jan 2022 11:57:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20220111115704.4312d280@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <PH0PR12MB5481E3E9D38D0F8DE175A915DC519@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
        <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
        <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB548176ED1E1B5ED1EF2BB88EDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111112418.2bbc0db4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB5481E3E9D38D0F8DE175A915DC519@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jan 2022 19:39:37 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, January 12, 2022 12:54 AM
> > 
> > On Tue, 11 Jan 2022 18:26:16 +0000 Parav Pandit wrote:  
> > > It isn't trusted feature. The scope in few weeks got expanded from
> > > trusted to more granular at controlling capabilities. One that came up
> > > was ipsec or other offloads that consumes more device resources.  
> > 
> > That's what I thought. Resource control is different than privileges, and
> > requires a different API.
> >  
> It's the capability that is turned on/off.
> A device is composed based on what is needed. ipsec offload is not always needed.
> Its counter intuitive to expose some low level hardware resource to disable ipsec indirectly.
> So it is better to do as capability/param rather than some resource.
> It is capability is more than just resource.

Wouldn't there be some limitation on the number of SAs or max
throughput or such to limit on VF hogging the entire crypto path?

I was expecting such a knob, and then turning it to 0 would effectively
remove the capability (FW can completely hide it or driver ignore it).



> > > A prometheous kind of monitoring software wants to monitor the
> > > physical port counters, running in a container. Such container doesn't
> > > have direct access to the PF or physical representor. Just for sake of
> > > monitoring counters, user doesn't want to run the monitoring container
> > > in root net ns.  
> > 
> > Containerizing monitors seems very counter-intuitive to me.
> >  
> May be. But it is in use at [1] for a long time now.
> 
> [1] docker run -p 9090:9090 prom/prometheus

How is it "in use" if we haven't merged the patch to enable it? :)
What does it monitor? PHYs port does not include east-west traffic,
exposing just the PHYs stats seems like a half measure.

> > > For sure we prefer the bona fide Linux uAPI for standard features.
> > > But internal knobs of how to do steering etc, is something not generic
> > > enough. May be only those quirks live in the port function params and
> > > rest in standard uAPIs?  
> > 
> > Something talks to that steering API, and it's not netdev. So please don't push
> > problems which are not ours onto us.  
> Not sure I follow you.
> Netdev of a mlx5 function talks to the driver internal steering API
> in addition to other drivers operating this mlx5 function.

But there is no such thing as "steering API" in netdev. We can expose
the functionality we do have, if say PTP requires some steering then
enabling PTP implies the required steering is enabled. "steering API"
as an entity is meaningless to a netdev user.
