Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266333166C3
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhBJMc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:32:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231922AbhBJMaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:30:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612960133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i5wXyy1sPUgnnMqVauVL41jvRX6eG8p4VtBbB9PGUS8=;
        b=MsfUT2eCEe7E7S5QHVpNXXvhvLFJ28u1ZvxvGawDbz1nxR4GNG9ZQYsD0Th8xjnXM97le2
        M7GugTtV5Z8YULz5byP6Dur7Y+uWDlEXRSeFI+FwoNq6Oct1widAKhMW+VL3mp2YRxvxPc
        pOF0qJ5ULobmNDQhdCjEJGKQByC9rgY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-gJBuHSPgOSSn-gzzzpH5Nw-1; Wed, 10 Feb 2021 07:28:51 -0500
X-MC-Unique: gJBuHSPgOSSn-gzzzpH5Nw-1
Received: by mail-wm1-f70.google.com with SMTP id u138so890546wmu.8
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 04:28:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i5wXyy1sPUgnnMqVauVL41jvRX6eG8p4VtBbB9PGUS8=;
        b=V1GBIdQxlhIwdQZ8ntd4H5rZLfDlnH4Bprb/67DhVYHBbTZjqZ5RVQDwKL1fXs7urH
         m3vDH2SJrmQO8n+l7mz/SlNxknlOlaUJB7FMWJc6TVXztmK3HJuM8+4KoJFBPmnpqhD0
         KCVaOv0X+DpRurvt0nLRcNP6jvUHKOo/s0bDgmeGFeRt8PAoo79AiJga3aHr3odWPk9U
         Zibb86RYRyRzR4tbyCyveqLVp0HNcnRBdCT9HTX4/7H+zW39X/cQQljExSw/aEmb/3oJ
         /rlAnijJ/S/tJN9cTUuk+iZNelx0SB5ZXifLqD4StCs09sWbqfRRZpnGH0Ef9ahnT6xB
         csbg==
X-Gm-Message-State: AOAM530cQhITPSzvxKo/dmusHrV526I55zmdihLOOaIjxfnKeOI6WqVA
        a8+J3S1AVURu3/+x9dVTk425kUZH1kP6pRKeMAJh0+1jXGRuk+F/lMbOe9AWAJZ89vc6b8icJEk
        I0fDsDXIUh4uM8nMe
X-Received: by 2002:adf:b611:: with SMTP id f17mr3364769wre.8.1612960129954;
        Wed, 10 Feb 2021 04:28:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9+xzSxdXFmowIk42Rj2TTfAS5qUcbZY08lcAl1KI09s/LaYklsKwABS3n8zQbgdh+YNgXxg==
X-Received: by 2002:adf:b611:: with SMTP id f17mr3364759wre.8.1612960129805;
        Wed, 10 Feb 2021 04:28:49 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id i10sm3116755wrp.0.2021.02.10.04.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 04:28:49 -0800 (PST)
Date:   Wed, 10 Feb 2021 07:28:46 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Eli Cohen <elic@nvidia.com>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] mlx5_vdpa: fix feature negotiation across device
 reset
Message-ID: <20210210072758-mutt-send-email-mst@kernel.org>
References: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
 <1612614564-4220-2-git-send-email-si-wei.liu@oracle.com>
 <20210208053500.GA137517@mtl-vdi-166.wap.labs.mlnx>
 <061486d5-6235-731b-d036-f5d5e9fac22e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <061486d5-6235-731b-d036-f5d5e9fac22e@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 05:20:11PM -0800, Si-Wei Liu wrote:
> 
> 
> On 2/7/2021 9:35 PM, Eli Cohen wrote:
> > On Sat, Feb 06, 2021 at 04:29:23AM -0800, Si-Wei Liu wrote:
> > > The mlx_features denotes the capability for which
> > > set of virtio features is supported by device. In
> > > principle, this field needs not be cleared during
> > > virtio device reset, as this capability is static
> > > and does not change across reset.
> > > 
> > > In fact, the current code may have the assumption
> > > that mlx_features can be reloaded from firmware
> > > via the .get_features ops after device is reset
> > > (via the .set_status ops), which is unfortunately
> > > not true. The userspace VMM might save a copy
> > > of backend capable features and won't call into
> > > kernel again to get it on reset. This causes all
> > > virtio features getting disabled on newly created
> > > virtqs after device reset, while guest would hold
> > > mismatched view of available features. For e.g.,
> > > the guest may still assume tx checksum offload
> > > is available after reset and feature negotiation,
> > > causing frames with bogus (incomplete) checksum
> > > transmitted on the wire.
> > > 
> > > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> > > ---
> > >   drivers/vdpa/mlx5/net/mlx5_vnet.c | 1 -
> > >   1 file changed, 1 deletion(-)
> > > 
> > > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > index b8416c4..aa6f8cd 100644
> > > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > > @@ -1788,7 +1788,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
> > >   		clear_virtqueues(ndev);
> > >   		mlx5_vdpa_destroy_mr(&ndev->mvdev);
> > >   		ndev->mvdev.status = 0;
> > > -		ndev->mvdev.mlx_features = 0;
> > >   		++mvdev->generation;
> > >   		return;
> > >   	}
> > Since we assume that device capabilities don't change, I think I would
> > get the features through a call done in mlx5v_probe after the netdev
> > object is created and change mlx5_vdpa_get_features() to just return
> > ndev->mvdev.mlx_features.
> Yep, it makes sense. Will post a revised patch.

So I'm waiting for v2 of this patchset. Please make sure to post a cover letter
with an overall description.

> If vdpa tool allows
> reconfiguration post probing, the code has to be reconciled then.
> 
> > 
> > Did you actually see this issue in action? If you did, can you share
> > with us how you trigerred this?
> Issue is indeed seen in action. The mismatched tx-checksum offload as
> described in the commit message was one of such examples. You would need a
> guest reboot though (triggering device reset via the .set_status ops and
> zero'ed mlx_features was loaded to deduce new actual_features for creating
> the h/w virtq object) for repro.
> 
> -Siwei
> > 
> > > -- 
> > > 1.8.3.1
> > > 

