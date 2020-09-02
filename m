Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BF325AED9
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgIBP3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbgIBPYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 11:24:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A1BE20767;
        Wed,  2 Sep 2020 15:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599060240;
        bh=d3M7pbJ+TEn7khWKvkhKRnJf5xSK9xinFqy9OiKP3O4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cp9Eha183o2xT+K+Ym44Pv0ockvQugxza5JA4tl+qqELYuks4LZ6QG1mX0+6fYDu1
         kzaU3PV1NPVsQB9rSPRy/nO7ZF0Ryal8IQT2kgXoY61/Qeg1Lg/MB4xNStADC+6EOd
         nBzDAS/EHzu9pR9f/PoYjRjbfEWYIhAzzVhPmy0U=
Date:   Wed, 2 Sep 2020 08:23:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Parav Pandit <parav@nvidia.com>, Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Message-ID: <20200902082358.6b0c69b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200902080011.GI3794@nanopsycho.orion>
References: <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901081906.GE3794@nanopsycho.orion>
        <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901091742.GF3794@nanopsycho.orion>
        <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200902080011.GI3794@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Sep 2020 10:00:11 +0200 Jiri Pirko wrote:
>>> I didn't quite get the fact that you want to not show controller ID on the local
>>> port, initially.  
>> Mainly to not_break current users.  
> 
> You don't have to take it to the name, unless "external" flag is set.
> 
> But I don't really see the point of showing !external, cause such
> controller number would be always 0. Jakub, why do you think it is
> needed?

It may seem reasonable for a smartNIC where there are only two
controllers, and all you really need is that external flag. 

In a general case when users are trying to figure out the topology
not knowing which controller they are sitting at looks like a serious
limitation.

Example - multi-host system and you want to know which controller you
are to run power cycle from the BMC side.

We won't be able to change that because it'd change the names for you.
