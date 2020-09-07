Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC23D25FE82
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbgIGQSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730487AbgIGQSP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:18:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1146221556;
        Mon,  7 Sep 2020 16:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599495495;
        bh=sX7UFs8R7WmqkLZcwQZ4r8993g7ptMJaEyn/BSqLsNg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gub7C+OpDKAMmOFLPJp4hv2ZLYh1pMjFs8XvM8LCChcJhyj+c5oKNJBoVb0uHHCyC
         sUuHohh0tdNw+8Jrl0Fe6iVDE1bJPByvCPUT0RFdywjVYa2bFLBJtmsOhtb/xPDM3x
         +AH5OepLlIdXi8CLct8KiB/a+Qo7eKaaIRl157A4=
Date:   Mon, 7 Sep 2020 09:18:13 -0700
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
Message-ID: <20200907091813.7ad7f6ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907072153.GL2997@nanopsycho.orion>
References: <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901091742.GF3794@nanopsycho.orion>
        <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200902080011.GI3794@nanopsycho.orion>
        <20200902082358.6b0c69b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200903055439.GA2997@nanopsycho.orion>
        <20200903123123.7e6025ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200904084321.GG2997@nanopsycho.orion>
        <BY5PR12MB43229A748C15AB08C233A792DC2B0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200907072153.GL2997@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 09:21:53 +0200 Jiri Pirko wrote:
> >Putting little more realistic example for Jakub's and your suggestion below.
> >
> >Below is the output for 3 controllers. ( 2 external + 1 local )
> >Each external controller consist of 2 PCI PFs for a external host via single PCIe cable.
> >Each local controller consist of 1 PCI PF.
> >
> >$ devlink port show
> >pci/0000:00:08.0/0: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0 cnum 0 external false
> >pci/0000:00:08.0/1: type eth netdev enp0s8f0_c1pf0 flavour pcipf pfnum 0 cnum 1 external true
> >pci/0000:00:08.1/1: type eth netdev enp0s8f1_c1pf1 flavour pcipf pfnum 1 cnum 1 external true  
> 
> I see cnum 0 and cnum 1, yet you talk about 3 controllers. What did I
> miss?

Heh, good point. Please make sure to put this example in docs so folks
have a reference on how we expect a 2-port smartnic to look.
