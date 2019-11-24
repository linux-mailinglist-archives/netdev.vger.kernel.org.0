Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 532FA108303
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 12:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfKXLAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 06:00:35 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52924 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726090AbfKXLAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 06:00:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574593232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1KXhsg+a1KjUX11ht7XLI08v5r74uXuYj8COBG7LPM4=;
        b=UDcHBKUdcb4aPbCo6N8Wkhbj6d2+dwuy39HdaF55VcUeZA0LQc2ZDp3W1cMB6ZSV9Uf9J7
        gQLXkuDP6GmwhexwQ+dSZwJq0PAtbvXcvbchGvtA2AwEPftuZDOSyd/IHnTJRzzEMAfLkY
        EKSa9dRWJEvlJfEgcPWi778BuU9ZVBw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-Ioc3Ii6RPhmpZAcowYj7Cg-1; Sun, 24 Nov 2019 06:00:31 -0500
Received: by mail-qt1-f198.google.com with SMTP id x50so8218515qth.4
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 03:00:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0fpSEO2RRD2QaPeNSiFSwgUcyKpHEGr4rGYpZ1TQU8Q=;
        b=XNiLhN5onq4MfZo9Tpr+VdZY3SFsYnOwiC48kyufmuBu9aEL2JkU718oVO7C5+SCvM
         DVkdjgVrIE3w0rv2YMGRokRSBhjhF29UMj/BASM7/2ZSTcOotl7NlJhYDiudjiMz3+Qm
         bBFiw20DRilvH4HjYOpQo+Ja1JG2MXJdLun3xLEYShYUdT6LR5FXeqe827243dNwyhFB
         ibKvKlYj4hk8QjzE1RtEGn8XydIwtmP/9i1LSOGXW6wvoFt1ppgiAugnk5v9M0qBvWSS
         RbmrlSdq6ic+WSm1AaYiqb/xPJfcdoF9BNSLsgVUee7uSLcdg/2saGPrHIDRzYuWIuUC
         gQvw==
X-Gm-Message-State: APjAAAUwc4nXCzGJIRT4NFU3/mtvBwf+vYtTzcXwfasvOplnYKCy8Fwi
        EgplrBf2HkE2q1zPIbAr/geRhJBFLQsjElHhIO0AP6aJw2xkjVKKXOe+ibmtoTQu1EX32hl5Ufi
        UhTzlYcBmH0MjaJ+D
X-Received: by 2002:aed:2706:: with SMTP id n6mr6931486qtd.224.1574593230967;
        Sun, 24 Nov 2019 03:00:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqybYQ+vHAMF1k+WWrJoHiMbEVYdPp4I1ebcXb9vBUxJeIk0O9YkuFJsowcY8HNYb0x/TxIk2Q==
X-Received: by 2002:aed:2706:: with SMTP id n6mr6931468qtd.224.1574593230796;
        Sun, 24 Nov 2019 03:00:30 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id m186sm1685825qkc.39.2019.11.24.03.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 03:00:29 -0800 (PST)
Date:   Sun, 24 Nov 2019 06:00:23 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191124055343-mutt-send-email-mst@kernel.org>
References: <20191120102856.7e01e2e2@x1.home>
 <20191120181108.GJ22515@ziepe.ca>
 <20191120150732.2fffa141@x1.home>
 <20191121030357.GB16914@ziepe.ca>
 <5dcef4ab-feb5-d116-b2a9-50608784a054@redhat.com>
 <20191121141732.GB7448@ziepe.ca>
 <721e49c2-a2e1-853f-298b-9601c32fcf9e@redhat.com>
 <20191122180214.GD7448@ziepe.ca>
 <20191123043951.GA364267@___>
 <20191123230948.GF7448@ziepe.ca>
MIME-Version: 1.0
In-Reply-To: <20191123230948.GF7448@ziepe.ca>
X-MC-Unique: Ioc3Ii6RPhmpZAcowYj7Cg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 07:09:48PM -0400, Jason Gunthorpe wrote:
> > > > > Further, I do not think it is wise to design the userspace ABI ar=
ound
> > > > > a simplistict implementation that can't do BAR assignment,
> > > >=20
> > > > Again, the vhost-mdev follow the VFIO ABI, no new ABI is invented, =
and
> > > > mmap() was kept their for mapping device regions.
> > >=20
> > > The patches have a new file in include/uapi.
> >=20
> > I guess you didn't look at the code. Just to clarify, there is no
> > new file introduced in include/uapi. Only small vhost extensions to
> > the existing vhost uapi are involved in vhost-mdev.
>=20
> You know, I review alot of patches every week, and sometimes I make
> mistakes, but not this time. From the ICF cover letter:
>=20
> https://lkml.org/lkml/2019/11/7/62
>=20
>  drivers/vfio/mdev/mdev_core.c    |  21 ++
>  drivers/vhost/Kconfig            |  12 +
>  drivers/vhost/Makefile           |   3 +
>  drivers/vhost/mdev.c             | 556 +++++++++++++++++++++++++++++++
>  include/linux/mdev.h             |   5 +
>  include/uapi/linux/vhost.h       |  21 ++
>  include/uapi/linux/vhost_types.h |   8 +
>       ^^^^^^^^^^^^^^
>=20
> Perhaps you thought I ment ICF was adding uapi? My remarks cover all
> three of the series involved here.

Tiwei seems to be right - include/uapi/linux/vhost.h and
include/uapi/linux/vhost_types.h are both existing files.  vhost uapi
extensions included here are very modest. They
just add virtio spec things that vhost was missing.

Are you looking at a very old linux tree maybe?
vhost_types.h appeared around 4.20.

--=20
MST

