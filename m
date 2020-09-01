Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115CA25A0CA
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgIAV2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:28:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbgIAV2n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 17:28:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E0BC20767;
        Tue,  1 Sep 2020 21:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598995722;
        bh=8ZUe2Uv8htFjUIGv0FShLGkWrw8wEYRSUJ1ZHje5XH8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N5lGDnvuZEB980KGHEXCeOiYOlwVYyBJi2JIVChmGo9EkSehLNomhM0ul9VPbuH1H
         uj8fNHswsXbJmlmEIoQk31Imxy0tFS9H99ZL9JN077OKa6ciQJWcXmI7i7biRVKWDt
         1BvxA9VO9m5VceVSQImPWhvwWT1TOZlv7PsXsPdI=
Date:   Tue, 1 Sep 2020 14:28:40 -0700
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
Message-ID: <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200901091742.GF3794@nanopsycho.orion>
References: <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901081906.GE3794@nanopsycho.orion>
        <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901091742.GF3794@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Sep 2020 11:17:42 +0200 Jiri Pirko wrote:
> >> The external PFs need to have an extra attribute with "external
> >> enumeration" what would be used for the representor netdev name as well.
> >> 
> >> pci/0000:00:08.0/0: type eth netdev enp0s8f0 flavour physical
> >> pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0
> >> pci/0000:00:08.0/2: type eth netdev enp0s8f0_e0pf0 flavour pcipf extnum 0
> >> pfnum 0  
> >
> >How about a prefix of "ec" instead of "e", like?
> >pci/0000:00:08.0/2: type eth netdev enp0s8f0_ec0pf0 flavour pcipf ecnum 0 pfnum 0  
> 
> Yeah, looks fine to me. Jakub?

I don't like that local port doesn't have the controller ID.

Whether PCI port is external or not is best described by a the peer
relation. Failing that, at the very least "external" should be a
separate attribute/flag from the controller ID.

I didn't quite get the fact that you want to not show controller ID 
on the local port, initially.
