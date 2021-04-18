Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A993634E7
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 13:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhDRLvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 07:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhDRLvi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 07:51:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12BB661207;
        Sun, 18 Apr 2021 11:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618746670;
        bh=yNyR1LiE1DA8XrGTItMp716jk+EUoFMuSkUyeHkt/pU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QsRuLY+JhwIF5dQ4wZyzcRNYGW5r0XTP4YA0WdrQKmC11q22XBByNlzqU73zD35Es
         X2w0LzvYUbuaVj3hWKtVrUMZ4znPVm1e+/02gzG+qJi55lZ0D7ipdhMlAOcgYUZc9P
         cWOpzuBoep5Aap2sjq7ZfYiF8JhS51TkscHNQb0hdEKGi3C6xRcuy5mjCZKNWhypN4
         jKaFgCppedqCp2zuBaW8lc+Kji3FZQeSUftLmEFbcDOb8zTUC66eIPETdwMrEir7wv
         QM2Nyvv5aHBvr2/eYJob4u7Dti+R2luh/4nMq8nI3W/l3b093cId4IbB5l6A2kN6pK
         iiN5kzFCmwTqA==
Date:   Sun, 18 Apr 2021 14:51:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Parav Pandit <parav@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Lacombe, John S" <john.s.lacombe@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
Subject: Re: [PATCH v4 05/23] ice: Add devlink params support
Message-ID: <YHwdKxtIi26ZmVlL@unreal>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-6-shiraz.saleem@intel.com>
 <20210407145705.GA499950@nvidia.com>
 <e516fa3940984b0cb0134364b923fc8e@intel.com>
 <20210407224631.GI282464@nvidia.com>
 <c5a38fcf137e49c0af0bfa6edd3ec605@intel.com>
 <BY5PR12MB43221FA2A6295C9CF23C798DDC709@BY5PR12MB4322.namprd12.prod.outlook.com>
 <8a7cd11994c2447a926cf2d3e60a019c@intel.com>
 <BY5PR12MB4322A28E6678CBB8A6544026DC4F9@BY5PR12MB4322.namprd12.prod.outlook.com>
 <4d9a592fa5694de8aadc60db1376da20@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d9a592fa5694de8aadc60db1376da20@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 12:21:08AM +0000, Saleem, Shiraz wrote:
> > Subject: RE: [PATCH v4 05/23] ice: Add devlink params support

<...>

> > > Why not just allow the setting to apply dynamically during a 'set'
> > > itself with an unplug/plug of the auxdev with correct type.
> > >
> > This suggestion came up in the internal discussion too.
> > However such task needs to synchronize with devlink reload command and also
> > with driver remove() sequence.
> > So locking wise and depending on amount of config change, it is close to what
> > reload will do.
> 
> Holding this mutex across the auxiliary device unplug/plug in "set" wont cut it?
> https://elixir.bootlin.com/linux/v5.12-rc7/source/drivers/net/ethernet/mellanox/mlx5/core/main.c#L1304

Like Parav said, we are working to fix it and already have one working
solution, unfortunately it has one eyebrow raising change and we are
trying another one.

You can take a look here to get sense of the scope:
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=devlink-core

Thanks
