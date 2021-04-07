Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1836F356637
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 10:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346903AbhDGIPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 04:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239391AbhDGIPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 04:15:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D82D61363;
        Wed,  7 Apr 2021 08:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617783323;
        bh=spo3XQrXBslXukUO/eKhNGhd8BzmT3xOrjhdgFIQi2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TwhcyB0CUooi5wQm/oGRiMjMV54ea8qMkbodoyT/n1HNETiil+sKTEsGhqXQ/DsN4
         /NobHk+hk9gwH8VKdaeuHwgya8Pi4G+2wRV3tkHTJIG5yzqQmCasVF/8Itq4JSY2nz
         s3ultnZ3Ngn0I/52uIW1lHqO5M7u5leHvp6B0+CZaUQ4/INFFYKJGwOt2Cz2SBaPMz
         TmhTZIWo9XEz6evHCW7l6Fe6ETJz9eFnIaRp7JfPhY6tpJQyspEZp8WAGf++dneOy0
         OHiiadV+idYvAL59G90xIOmGTxxXoQBrayJAYNxLiOL9rFVi1JoTlPm3sFFNdhh0zv
         NZw/HD8gSe2aA==
Date:   Wed, 7 Apr 2021 11:15:19 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YG1qF8lULn8lLJa/@unreal>
References: <20210406232321.12104-1-decui@microsoft.com>
 <YG0F4HkslqZHtBya@lunn.ch>
 <MW2PR2101MB089237C8CCFFF0C352CA658ABF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB089237C8CCFFF0C352CA658ABF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 08:02:17AM +0000, Dexuan Cui wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Tuesday, April 6, 2021 6:08 PM
> > To: Dexuan Cui <decui@microsoft.com>
> > 
> > > +static int gdma_query_max_resources(struct pci_dev *pdev)
> > > +{
> > > +	struct gdma_context *gc = pci_get_drvdata(pdev);
> > > +	struct gdma_general_req req = { 0 };
> > > +	struct gdma_query_max_resources_resp resp = { 0 };
> > > +	int err;
> > 
> > Network drivers need to use reverse christmas tree. I spotted a number
> > of functions getting this wrong. Please review the whole driver.
> 
> Hi Andrew, thanks for the quick comments!
> 
> I think In general the patch follows the reverse christmas tree style.
> 
> For the function you pointed out, I didn't follow the reverse
> christmas tree style because I wanted to keep the variable defines
> more natural, i.e. first define 'req' and then 'resp'.
> 
> I can swap the 2 lines here, i.e. define 'resp' first, but this looks a little
> strange to me, because in some other functions the 'req' should be
> defined first, e.g. 
> 
> int gdma_test_eq(struct gdma_context *gc, struct gdma_queue *eq)
> {
>         struct gdma_generate_test_event_req req = { 0 };
>         struct gdma_general_resp resp = { 0 };

BTW, you don't need to write { 0 }, the {} is enough.

Thanks
