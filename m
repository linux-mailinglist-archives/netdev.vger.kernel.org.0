Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A2E4778FA
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 17:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbhLPQ2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 11:28:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37182 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbhLPQ2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 11:28:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26B5B61E9D
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 16:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B382C36AE0;
        Thu, 16 Dec 2021 16:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639672099;
        bh=IuI7WnXPrk00ta4S84PUvbmG8XWc1pJ0KfMHyTEyroQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oyjYnderJxyY5qkZLHHCqXG3uISTv9ZMj23joVUFn9xtLqTSxDmXcoZlOi0hM4IN6
         xQ6ypzOsTIkWHm6Cncu1ngq3Gh/r5ScIRauVjn6P6heHuj3vLhU+7zeSgYrf2yhfyW
         ambqL6ORqr1EzJo5BUE2er/mLrvwhGcEbew1CUeoTdfp2TISkDe4wPm9hQSn6+MAd2
         EQ0FVLDkm1MRxwgIKBv5SxJKf9V9l7NmWAf8ck1x4tpxrntCUAMUI2uQAbLtGUQo/3
         cDBB/4wbaVaS7VXd7EY0jJKJ4GSbX0kpDFHA+QpFE8bYE8kvlXCqTv8dfu9EbwYHxj
         A4UIWvEPmvO9Q==
Date:   Thu, 16 Dec 2021 08:28:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Sudhakar Rani <sunrani@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211122144307.218021-2-sunrani@nvidia.com>
        <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
        <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
        <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
        <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 16:17:29 +0000 Sunil Sudhakar Rani wrote:
> > On Wed, 15 Dec 2021 22:15:10 +0000 Saeed Mahameed wrote:  
> > > We will have a parameter per feature we want to enable/disable instead
> > > of a global "trust" knob.  
> > 
> > So you're just asking me if I'm okay with devlink params regardless if I'm okay
> > with what they control? Not really, I prefer an API as created by this patches.  
>
> What shortcomings do you see in the finer granular approach we want
> to go to enable/disable On a per feature basis instead of global knob?

I was replying to Saeed so I assumed some context which you probably
lack. Granular approach is indeed better, what I was referring to when
I said "prefer an API as created by this patch" was having an dedicated
devlink op, instead of the use of devlink params.
