Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9BC27BCB5
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 08:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgI2GBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 02:01:49 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18603 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI2GBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 02:01:48 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f72cd9a0004>; Mon, 28 Sep 2020 23:00:58 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 29 Sep
 2020 06:01:46 +0000
Date:   Tue, 29 Sep 2020 09:01:42 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        <virtualization@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v3 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
Message-ID: <20200929060142.GA120395@mtl-vdi-166.wap.labs.mlnx>
References: <73f7e48b-8d16-6b20-07d3-41dee0e3d3bd@infradead.org>
 <20200918082245.GP869610@unreal>
 <20200924052932-mutt-send-email-mst@kernel.org>
 <20200924102413.GD170403@mtl-vdi-166.wap.labs.mlnx>
 <20200925061959-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200925061959-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601359258; bh=s1n4fxUnOrXqu7iO06sSwSUoafpNw5JWrX09ZriSJ6w=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=B7cTZFwvFf76FTc/g/Ys1cglEtwHgufmhfFn7BYTLj1AF83c4NqrkPGEnL4Vhg/yG
         LYbejwCA9lyVXrnoAf274Db1usjswzJIuTr/Eyf5URW4izcj9j2tk1qJryP8kmfxs1
         xhJlHbKCzdqdviWqdcVe2sOK8BneC69mYO91YweTy+4qj1tJswR2W6uLFYmr7Snk/R
         1SvgOV6oj264ehDJXQ9IKMRG7qmiZS06Exnl0DCk+R6+/882Ab5N4DeiIlYD1LKujA
         IXt6ItLxD5E0O5Nkd5+18OO8Kx1Rx3ee20RWWnPdlzDbOT8cUKOk2Ks/UKokNV+Vz0
         JvqWFubIjSQDA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 06:20:45AM -0400, Michael S. Tsirkin wrote:
> > > 
> > > Hmm other drivers select VHOST_IOTLB, why not do the same?
> > 
> > I can't see another driver doing that.
> 
> Well grep VHOST_IOTLB and you will see some examples.

$ git grep -wn VHOST_IOTLB
drivers/vhost/Kconfig:2:config VHOST_IOTLB
drivers/vhost/Kconfig:11:       select VHOST_IOTLB
drivers/vhost/Kconfig:18:       select VHOST_IOTLB

What am I missing here?

> > Perhaps I can set dependency on
> > VHOST which by itself depends on VHOST_IOTLB?
> 
> VHOST is processing virtio in the kernel. You don't really need that
> for mlx, do you?
> 
> > > 
> > > 
> > > > >  	help
> > > > >  	  Support library for Mellanox VDPA drivers. Provides code that is
> > > > >
> > > 
> 
