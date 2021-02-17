Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F45B31E143
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 22:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhBQVWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 16:22:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232371AbhBQVVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 16:21:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613596823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dnUfiwdq5gxWn7kuZ9KofRt51rZIFhafBYYbLyCXkSs=;
        b=PKe4dnKaBSMhU9p9Ti8OVPecVPkvnkkbOIPrmd+9nuMQhGYZsA4v9tfMRF733m92ghc96J
        MyLpsQ1kW9eAPmkn/BGDTYt6rncBv8fzJ4II+my++F88gwpL3c/qsn2HVlKTQDPxETzBqB
        gmREJk409NedMKtSE49ZeluJQ5q3jQM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-wxS7yLWZNZGppNzNpn-BCw-1; Wed, 17 Feb 2021 16:20:20 -0500
X-MC-Unique: wxS7yLWZNZGppNzNpn-BCw-1
Received: by mail-ej1-f72.google.com with SMTP id yd24so2044442ejb.9
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 13:20:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dnUfiwdq5gxWn7kuZ9KofRt51rZIFhafBYYbLyCXkSs=;
        b=gOskGL5HnPMPoR/vkXWkWUoauXQC8YRzRHevxI7JS+d5s5azpZ20gWaQwf4oAZzdyJ
         pA9ZMorKuZdnNOBYtP/wz8v6bjaaaApflrKW2U5ELhSiNTWP3rsOVG2pgStZyqAPHr7M
         VT8XCyEGHHM5+d+MdJFwjncm5s7+qp6mynkubLqlSQybPQyWczAPzZcIlJAOoyiAwj2u
         vQ7JK8MoWcpP30Jv+poutwEVo7ebvzH7ECw6Aml/+RlUovMThKDJgJq9yXk7KHLy/xLM
         5xdC/MVeGXwqQfAjg20xF/fp2ahoVgs3nVRzfyWjALUE290X5ZeUon10w28dOJ/B4clF
         SfsA==
X-Gm-Message-State: AOAM533AdTQjNHOCEDYYNTvApClfr8/jKOeo0cHDL0N6pqcN/3clr1Fj
        od0TtptOT4ckEOFWFRRnW9xZJ5z5zES/cBAYentZURCxmY58vD+1E5d0YI2czFXKnk3gcrcrWvU
        XX2ZraZIndvm/TKrb
X-Received: by 2002:aa7:d68d:: with SMTP id d13mr728748edr.291.1613596819516;
        Wed, 17 Feb 2021 13:20:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLOH8aMmh5snYzz9S7cR4u4nYqA6EuVxyyVAfvIIkVTeOvC+C0pe7pnz/oSv3yn+vdF7N9Jg==
X-Received: by 2002:aa7:d68d:: with SMTP id d13mr728678edr.291.1613596818439;
        Wed, 17 Feb 2021 13:20:18 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id x25sm1651338edv.65.2021.02.17.13.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 13:20:17 -0800 (PST)
Date:   Wed, 17 Feb 2021 16:20:14 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Eli Cohen <elic@nvidia.com>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] vdpa/mlx5: Fix suspend/resume index restoration
Message-ID: <20210217161858-mutt-send-email-mst@kernel.org>
References: <20210216162001.83541-1-elic@nvidia.com>
 <4ecc1c7f-4f5a-68be-6734-e18dfeb91437@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ecc1c7f-4f5a-68be-6734-e18dfeb91437@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 11:42:48AM -0800, Si-Wei Liu wrote:
> 
> 
> On 2/16/2021 8:20 AM, Eli Cohen wrote:
> > When we suspend the VM, the VDPA interface will be reset. When the VM is
> > resumed again, clear_virtqueues() will clear the available and used
> > indices resulting in hardware virqtqueue objects becoming out of sync.
> > We can avoid this function alltogether since qemu will clear them if
> > required, e.g. when the VM went through a reboot.
> > 
> > Moreover, since the hw available and used indices should always be
> > identical on query and should be restored to the same value same value
> > for virtqueues that complete in order, we set the single value provided
> > by set_vq_state(). In get_vq_state() we return the value of hardware
> > used index.
> > 
> > Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> > Signed-off-by: Eli Cohen <elic@nvidia.com>
> Acked-by: Si-Wei Liu <si-wei.liu@oracle.com>


Seems to also fix b35ccebe3ef76168aa2edaa35809c0232cb3578e, right?


> > ---
> >   drivers/vdpa/mlx5/net/mlx5_vnet.c | 17 ++++-------------
> >   1 file changed, 4 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index b8e9d525d66c..a51b0f86afe2 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1169,6 +1169,7 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
> >   		return;
> >   	}
> >   	mvq->avail_idx = attr.available_index;
> > +	mvq->used_idx = attr.used_index;
> >   }
> >   static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> > @@ -1426,6 +1427,7 @@ static int mlx5_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
> >   		return -EINVAL;
> >   	}
> > +	mvq->used_idx = state->avail_index;
> >   	mvq->avail_idx = state->avail_index;
> >   	return 0;
> >   }
> > @@ -1443,7 +1445,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
> >   	 * that cares about emulating the index after vq is stopped.
> >   	 */
> >   	if (!mvq->initialized) {
> > -		state->avail_index = mvq->avail_idx;
> > +		state->avail_index = mvq->used_idx;
> >   		return 0;
> >   	}
> > @@ -1452,7 +1454,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
> >   		mlx5_vdpa_warn(mvdev, "failed to query virtqueue\n");
> >   		return err;
> >   	}
> > -	state->avail_index = attr.available_index;
> > +	state->avail_index = attr.used_index;
> >   	return 0;
> >   }
> > @@ -1532,16 +1534,6 @@ static void teardown_virtqueues(struct mlx5_vdpa_net *ndev)
> >   	}
> >   }
> > -static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
> > -{
> > -	int i;
> > -
> > -	for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
> > -		ndev->vqs[i].avail_idx = 0;
> > -		ndev->vqs[i].used_idx = 0;
> > -	}
> > -}
> > -
> >   /* TODO: cross-endian support */
> >   static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
> >   {
> > @@ -1777,7 +1769,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
> >   	if (!status) {
> >   		mlx5_vdpa_info(mvdev, "performing device reset\n");
> >   		teardown_driver(ndev);
> > -		clear_virtqueues(ndev);
> >   		mlx5_vdpa_destroy_mr(&ndev->mvdev);
> >   		ndev->mvdev.status = 0;
> >   		++mvdev->generation;

