Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4837748B59B
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344689AbiAKSUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344629AbiAKSUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 13:20:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83051C06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 10:20:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B9EC60E9A
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 18:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE2FC36AEF;
        Tue, 11 Jan 2022 18:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641925206;
        bh=of7uV+JrQKxi+K/zYCn3UUFWdwuKrOa39yMjdSKvwQ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qNZIjirXFt2nUgduUksR6N5GtnEw/3gwLWUB0PUej7Xp33v/CuiYHGymZx6LytFjZ
         g401fp64+fcc22mJ8S+ZTnlgr/+W5DZ3Vx702fh94orrhCIhCaUohLa1jS+YadHpQC
         tGhjAqiI+MqnsEA56tY8z4SUnAI+3LSNwkxDHrA/7XCkK1YlPj7cvVxP1vGfbtHvMZ
         XGelsbrJfupEqBcqD0PQTQC1XRpq3WoGvt8GP1R2GA1U6Yw4LDgtlZ+7yEPxbiTt8u
         7z5931JmI9t+xkv8vjBikYiFDmOyZ7hwRNu9W5HOH66bzH23XQQdEE0SmC+12+5oZa
         u8q098yQmrfvQ==
Date:   Tue, 11 Jan 2022 10:20:05 -0800
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
Message-ID: <20220111102005.4f0fa3a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
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
        <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jan 2022 16:57:54 +0000 Parav Pandit wrote:
> > > What shortcomings do you see in the finer granular approach we want to
> > > go to enable/disable On a per feature basis instead of global knob?  
> > 
> > I was replying to Saeed so I assumed some context which you probably lack.
> > Granular approach is indeed better, what I was referring to when I said "prefer
> > an API as created by this patch" was having an dedicated devlink op, instead of
> > the use of devlink params.  
> 
> This discussed got paused in yet another year-end holidays. :)
> Resuming now and refreshing everyone's cache.
> 
> We need to set/clear the capabilities of the function before deploying such function.
> As you suggested we discussed the granular approach and at present we have following features to on/off.
> 
> Generic features:
> 1. ipsec offload

Why is ipsec offload a trusted feature?

> 2. ptp device

Makes sense.

> Device specific:
> 1. sw steering

No idea what that is/entails.

> 2. physical port counters query

Still don't know why VF needs to know phy counters.

> It was implicit that a driver API callback addition for both types of features is not good.
> Devlink port function params enables to achieve both generic and device specific features.
> Shall we proceed with port function params? What do you think?

I already addressed this. I don't like devlink params. They muddy the
water between vendor specific gunk and bona fide Linux uAPI. Build a
normal dedicated API.
