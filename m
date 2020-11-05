Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE912A8822
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732162AbgKEUbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:31:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbgKEUbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 15:31:55 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70B86206CB;
        Thu,  5 Nov 2020 20:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604608314;
        bh=mLsNqMpg+fjeU5Wj1TlalFF/ej18WzbVB4jrTqF1H+g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tip2y8ihPjnL+k84Ml5q7RJaT+qHuQ8ouQtkwEu9HT+3NJ+Do7g6/WkFLgvWr0nxG
         XL66eSQHoh7XVgTbzWogbyGV0wbtvQ24hhUBY24NLMphWpdncSrpEJ1V5DOZXDJx+e
         SeV6rpliRjmRwz5J0sZtZO/dmhjGVN3fW+ON4qpQ=
Message-ID: <8a8e75215a5d3d8cfa9c3c6747325dbbf965811f.camel@kernel.org>
Subject: Re: [PATCH mlx5-next v1 04/11] vdpa/mlx5: Make hardware definitions
 visible to all mlx5 devices
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        gregkh <gregkh@linuxfoundation.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        shiraz.saleem@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, linux-kernel@vger.kernel.org
Date:   Thu, 05 Nov 2020 12:31:52 -0800
In-Reply-To: <20201101201542.2027568-5-leon@kernel.org>
References: <20201101201542.2027568-1-leon@kernel.org>
         <20201101201542.2027568-5-leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-11-01 at 22:15 +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Move mlx5_vdpa IFC header file to the general include folder, so
> mlx5_core will be able to reuse it to check if VDPA is supported
> prior to creating an auxiliary device.
> 

I don't really like this, the whole idea of aux devices is that they
get to do own logic and hide details, now we are exposing aux specific
stuff to the bus .. 
let's figure a way to avoid such exposure as we discussed yesterday.

is_supported check shouldn't belong to mlx5_core and each aux device
(en/ib/vdpa) should implement own is_supported op and keep the details
hidden in the aux driver like it was before this patch.

