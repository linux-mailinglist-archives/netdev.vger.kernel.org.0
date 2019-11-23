Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4F8107F7E
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 17:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKWQuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 11:50:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26249 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726836AbfKWQuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 11:50:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574527820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iQ1nYZicRuCsr2N4GxCFhhF1w/8zoaTyzM1kGYuOUrs=;
        b=RaK7RGaLv6d1oAkRsguEZ9uMYYkncoFGq88NFmY0+crPFFgCjAbJUNtjNczMg+Kz30rbRq
        mm0w1p2icQPH3Gz9stCC1YEptxOFGT1yIsP2n4srk2DzjPXcdwYOB1TO0pWezqWV18LyCW
        +bgKhnojPPT4MrP6knu2hMW4cByOw4A=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-yAB2hYbLN525BlRsfqfSPg-1; Sat, 23 Nov 2019 11:50:19 -0500
Received: by mail-qk1-f198.google.com with SMTP id o11so6580245qkk.7
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 08:50:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sHQia/lsWr35bKNwE4bTfDIwWlqfBFukr8BZYG19Bvg=;
        b=MehHzX+TV0Gni1NCJFe88V1I5hZHmf/v77FR6PShgbdFHAU4dViM4OkReJo0jYs5Nw
         pKlxYy/oIwM+dqHl5YVaMtwVMf5vFcQV+Zq+cwznxCkr87/Nj8RjTOrxJbImB3byCihX
         K1mcAlT0Ku67AJz6TInEnP7tRg54Qa6RrqWlsQ7Memd69giOThiCy4gGnXv5jDrZeq9C
         kX+zZJo/Et7yl5KparNS92zv/j6ogzpVMYtPOeps6x4r7niFlIXFduF3okkrYD4G91Gm
         OdvuUaRLCvewN+JeqvqKip2Fkdwnm8zKMQa14RCUgh88Dr6Fd80+xIlBimtGUQJT6Rhp
         0CSw==
X-Gm-Message-State: APjAAAXH5X8rC1EKQ9cwbNkA0QkXF8Szb23pAPSOz6GSmcMKE002JFhH
        Fa07rvq+GB/dh+4nGbafznRplyCef5IKAMEfor3yf5wOw0IPg1KUsHqNvdZYhduqyry9v/+HPcm
        MwRnvsQK5FyKrCCHA
X-Received: by 2002:a05:6214:714:: with SMTP id b20mr19350112qvz.39.1574527818914;
        Sat, 23 Nov 2019 08:50:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqwQkY9bRii1J8sOZZLrXlXUoek5EdKj2DISUCJ7pbGOCucB5U5NnqaFttqpKqneVM87FnK6NQ==
X-Received: by 2002:a05:6214:714:: with SMTP id b20mr19350084qvz.39.1574527818689;
        Sat, 23 Nov 2019 08:50:18 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id j2sm609954qka.88.2019.11.23.08.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 08:50:17 -0800 (PST)
Date:   Sat, 23 Nov 2019 11:50:11 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191123114911-mutt-send-email-mst@kernel.org>
References: <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca>
 <20191120102856.7e01e2e2@x1.home>
 <20191120181108.GJ22515@ziepe.ca>
 <20191120150732.2fffa141@x1.home>
 <20191121030357.GB16914@ziepe.ca>
 <20191120232320-mutt-send-email-mst@kernel.org>
 <20191121134438.GA7448@ziepe.ca>
MIME-Version: 1.0
In-Reply-To: <20191121134438.GA7448@ziepe.ca>
X-MC-Unique: yAB2hYbLN525BlRsfqfSPg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 09:44:38AM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 20, 2019 at 11:24:03PM -0500, Michael S. Tsirkin wrote:
> > On Wed, Nov 20, 2019 at 11:03:57PM -0400, Jason Gunthorpe wrote:
> > > Frankly, when I look at what this virtio stuff is doing I see RDMA:
> > >  - Both have a secure BAR pages for mmaping to userspace (or VM)
> > >  - Both are prevented from interacting with the device at a register
> > >    level and must call to the kernel - ie creating resources is a
> > >    kernel call - for security.
> > >  - Both create command request/response rings in userspace controlled
> > >    memory and have HW DMA to read requests and DMA to generate respon=
ses
> > >  - Both allow the work on the rings to DMA outside the ring to
> > >    addresses controlled by userspace.
> > >  - Both have to support a mixture of HW that uses on-device security
> > >    or IOMMU based security.
> >=20
> > The main difference is userspace/drivers need to be portable with
> > virtio.
>=20
> rdma also has a stable/portable user space library API that is
> portable to multiple operating systems.
>=20
> What you don't like is that RDMA userspace has driver-specific
> code. Ie the kernel interface is not fully hardware independent.
>=20
> Jason

Right. Not that I don't like it, it has some advantages too.
But it's addressing a different need which a vendor
specific userspace driver doesn't address.

--=20
MST

