Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58593317015
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbhBJT0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 14:26:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233853AbhBJT0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 14:26:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F17F64E74;
        Wed, 10 Feb 2021 19:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612985138;
        bh=Uj8+qzK2zokC6zv2bqptQQdZk3ApeTA/xxqgaWyJsbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u529H8Qzfgp1lDmWI2NP57ku/Q1ina+5xa+dmz1WK6ApfOtjx/geSNkLLB9Ajwq5X
         KKyqzI3Kyr4/p4u6JJPCVmBYcm+rtgXmHGowsFwpnBHrXheiZtZUhNajeH3WcXM7jx
         FFki/qSfud1rTvvlJGjSx+r2FB606O9tWYlU0/90IXcML/FXC8CKnFuzrf76Zlg6y7
         KqPjpca9PR/vLTWRPzc+sQ6G2wUg8ArxVwD8ZuDE2AVQhsUoIREZJtnsE+J7wZHBOm
         nRlTlaHf8kjwnJKZPU8RyqegrxXcsxPyf8yl+OHGKMc9Ab7oLi+F/ArKYEDC9Cpef2
         JDlUKXmG7lXzg==
Date:   Wed, 10 Feb 2021 11:25:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mickey Rachamim <mickeyr@marvell.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [EXT] Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG
 support
Message-ID: <20210210112537.7e67ffb2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BN6PR18MB158781B17E633670912AEED6BA8E9@BN6PR18MB1587.namprd18.prod.outlook.com>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
        <20210203165458.28717-6-vadym.kochan@plvision.eu>
        <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87v9b249oq.fsf@waldekranz.com>
        <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YCKVAtu2Y8DAInI+@lunn.ch>
        <20210209093500.53b55ca8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN6PR18MB158781B17E633670912AEED6BA8E9@BN6PR18MB1587.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 20:31:32 +0000 Mickey Rachamim wrote:
> On Tuesday, February 9, 2021 7:35 PM Jakub Kicinski wrote:
> > Sounds like we have 3 people who don't like FW-heavy designs dominating the kernel - this conversation can only go one way. 
> > Marvell, Plvision anything to share? AFAIU the values of Linux kernel are open source, healthy community, empowering users. With the SDK on the embedded CPU your driver does not seem to tick any of these boxes.  
> 
> I'll try to share Marvell's insight and plans regarding our Prestera drivers;
>  
> We do understand the importance and the vision behind the open-source
> community - while being committed to quality, functionality and the
> developers/end-users.
> 
> We started working on the Prestera driver in Q2 2019. it took us more
> than a year to get the first approved driver into 5.10, and we just
> started. Right at the beginning - we implemented PP function into the
> Kernel driver like the SDMA operation (This is the RX/TX DMA engine).
> Yet, the FW itself - is an SW package that supports many Marvell
> Prestera Switching families of devices - this is a significant SW
> package that will take many working years to adapt to the Kernel
> environment. We do plan to port more and more PP functions as Kernel
> drivers along the way. 

Okay, so it sounds like there are no technical reason for you to keep
the SDK. My guess is also that you have a large customer who is
expecting you to provide upstream integration, hence the contractors
and taking the easiest way out.

> We also are working with the community to extend Kernel functionality
> with a new feature beneficial to all Kernel users (e.g. Devlink
> changes) and we will continue to do it.

Ah, devlink, every vendor's favorite interface. I keep my fingers
crossed that you're not just talking about exposing a bunch of
implementation-specific params, traps etc.

> By extending the Prestera driver to in-kernel implementation with
> more PP features - we will simplify the FW logic and enables
> cost-effective solutions to the market/developers.
