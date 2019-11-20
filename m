Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56073103D0E
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 15:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731527AbfKTOP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 09:15:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730565AbfKTOP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 09:15:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574259327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9EdQEdvTzZPxTFCzpiAyH5bmob1fKXU8vcyQev9OzUA=;
        b=Cz1cfiahUK3PH9WeHWGB635vOV8U8cbaGHeHh23/Nk2YBd4a8JLaQLSHkr1A8nNw+xAxmH
        +GHChyXmN7liluDrT4YBy73mUIG5fF3VAXq8ZDlwBuXVkga3nr14FYicIPZTdpv4wJYgrX
        mvzbB1zjnLFib4Pizt4Ujen8168cWjw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-i_SFlFmuNAC55HAbg6J08Q-1; Wed, 20 Nov 2019 09:15:26 -0500
Received: by mail-qk1-f199.google.com with SMTP id w85so1599284qka.13
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 06:15:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lOq4H+J+eAB7Zt4IheQtqfp4O5c85nHSkJQVDqKg41g=;
        b=rj+o0PAGCvR/khOY+EN8BeTtVV+fCYzbMv9GW2mCyysNAsTIB7CRBMiVjOqAP2SUu0
         SzyqTPMkfPTNqot+y58aGAXfX+Nm4qq/jqA5dyq9cAlj00+jUpKZigcqiYUvEH+s/Xvh
         zZhH+n5qfREEhCPbMih3sdWLwgSiZrpt7Qh8+QwwJYldQTXzkTY4hvuSa+qQXNQCk+sl
         NbpJUkeSbZFc1X4wYLSNN+bwWTwwh3OFwyjs6mgXyygeV/x+9dxDmHfpehjCry0HIGLD
         jeX6Ln9V0drUKhaTB7zAsaOQhIFLrzpV0BAWzg+0MhoPWbCEbSTMkr3happEtVFLFiXa
         FoTg==
X-Gm-Message-State: APjAAAW9bH7JRBIh4xqDHG/CUPPh/cPsR/dQG+gSRZ4YOvZQjm32ZvnY
        podVeCjrgvL5GPSNcj6dNx6o5Gzz00/UfmSHdyz46P9ieqlIXNWieksgc/8CzEAYaUaCmWZuGNi
        vVHIPQibhe3jm5S7x
X-Received: by 2002:ac8:6d0b:: with SMTP id o11mr2759135qtt.253.1574259325522;
        Wed, 20 Nov 2019 06:15:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqy/qUPcXmLfhAED7hKKcfmUTUEOpmeGXhUC/+Yngs0gbEI2Vh9YfvpOEgljbcIQwRjFpBJZ2A==
X-Received: by 2002:ac8:6d0b:: with SMTP id o11mr2759099qtt.253.1574259325090;
        Wed, 20 Nov 2019 06:15:25 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id g7sm11874321qkl.20.2019.11.20.06.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 06:15:23 -0800 (PST)
Date:   Wed, 20 Nov 2019 09:15:17 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191120084358-mutt-send-email-mst@kernel.org>
References: <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca>
MIME-Version: 1.0
In-Reply-To: <20191120133835.GC22515@ziepe.ca>
X-MC-Unique: i_SFlFmuNAC55HAbg6J08Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 09:38:35AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 19, 2019 at 10:59:20PM -0500, Jason Wang wrote:
>=20
> > > > The interface between vfio and userspace is
> > > > based on virtio which is IMHO much better than
> > > > a vendor specific one. userspace stays vendor agnostic.
> > >=20
> > > Why is that even a good thing? It is much easier to provide drivers
> > > via qemu/etc in user space then it is to make kernel upgrades. We've
> > > learned this lesson many times.
> >=20
> > For upgrades, since we had a unified interface. It could be done
> > through:
> >=20
> > 1) switch the datapath from hardware to software (e.g vhost)
> > 2) unload and load the driver
> > 3) switch teh datapath back
> >=20
> > Having drivers in user space have other issues, there're a lot of
> > customers want to stick to kernel drivers.
>=20
> So you want to support upgrade of kernel modules, but runtime
> upgrading the userspace part is impossible? Seems very strange to me.

It's still true, you have to kill userspace to update a shared library.

Not to mention that things like rust encourage static builds so you
can't update a library even if you were willing to risk doing
that.

> > > This is why we have had the philosophy that if it doesn't need to be
> > > in the kernel it should be in userspace.
> >=20
> > Let me clarify again. For this framework, it aims to support both
> > kernel driver and userspce driver. For this series, it only contains
> > the kernel driver part. What it did is to allow kernel virtio driver
> > to control vDPA devices. Then we can provide a unified interface for
> > all of the VM, containers and bare metal. For this use case, I don't
> > see a way to leave the driver in userspace other than injecting
> > traffic back through vhost/TAP which is ugly.
>=20
> Binding to the other kernel virtio drivers is a reasonable
> justification, but none of this comes through in the patch cover
> letters or patch commit messages.

Yea this could have been communicated better.

> > > > That has lots of security and portability implications and isn't
> > > > appropriate for everyone.
> > >=20
> > > This is already using vfio. It doesn't make sense to claim that using
> > > vfio properly is somehow less secure or less portable.
> > >=20
> > > What I find particularly ugly is that this 'IFC VF NIC' driver
> > > pretends to be a mediated vfio device, but actually bypasses all the
> > > mediated device ops for managing dma security and just directly plugs
> > > the system IOMMU for the underlying PCI device into vfio.
> >=20
> > Well, VFIO have multiple types of API. The design is to stick the VFIO
> > DMA model like container work for making DMA API work for userspace
> > driver.
>=20
> Well, it doesn't, that model, for security, is predicated on vfio
> being the exclusive owner of the device. For instance if the kernel
> driver were to perform DMA as well then security would be lost.

The assumption at least IFC driver makes is that the kernel
driver does no DMA.

> > > I suppose this little hack is what is motivating this abuse of vfio i=
n
> > > the first place?
> > >=20
> > > Frankly I think a kernel driver touching a PCI function for which vfi=
o
> > > is now controlling the system iommu for is a violation of the securit=
y
> > > model, and I'm very surprised AlexW didn't NAK this idea.
> > >
> > > Perhaps it is because none of the patches actually describe how the
> > > DMA security model for this so-called mediated device works? :(
> > >
> > > Or perhaps it is because this submission is split up so much it is
> > > hard to see what is being proposed? (I note this IFC driver is the
> > > first user of the mdev_set_iommu_device() function)
> >=20
> > Are you objecting the mdev_set_iommu_deivce() stuffs here?
>=20
> I'm questioning if it fits the vfio PCI device security model, yes.

If you look at the IFC patch you'll find it doesn't do DMA, that's
what makes it secure.

> > > > It is kernel's job to abstract hardware away and present a unified
> > > > interface as far as possible.
> > >=20
> > > Sure, you could create a virtio accelerator driver framework in our
> > > new drivers/accel I hear was started. That could make some sense, if
> > > we had HW that actually required/benefited from kernel involvement.
> >=20
> > The framework is not designed specifically for your card. It tries to b=
e
> > generic to support every types of virtio hardware devices, it's not
> > tied to any bus (e.g PCI) and any vendor. So it's not only a question
> > of how to slice a PCIE ethernet device.
>=20
> That doesn't explain why this isn't some new driver subsystem and
> instead treats vfio as a driver multiplexer.
>=20
> Jason

That motivation's missing.

--=20
MST

