Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27DFC106974
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 11:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKVKCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 05:02:23 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33639 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726563AbfKVKCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 05:02:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574416940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q5brik//Uj78Imdw+Nasd8kB1YSOqMDawTRFR2gNwAc=;
        b=UlNet/e/vMxmEgMGO0nLCJF4wOK2DyUJzQBVA06EoBW0Uf8YSunAwwqZKvDdcwKx35Ow+2
        T8nixD5EaFVqgKi0LRGYd9GpKvqNxtR6y0CGBtU0KDLK/DGIuZpHr3+1+pnWv9OUfZo5IO
        kOEpqX/pzaZNbW+C/BSq5aWcc85WsQY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-m7qZghdbMqeXdKlrM8kNWw-1; Fri, 22 Nov 2019 05:02:17 -0500
Received: by mail-wr1-f71.google.com with SMTP id e10so3600026wrt.16
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 02:02:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TxlQ/8hM2ybpNrpWCxq4vBt3O3dzk/gjN30vFVF3w9c=;
        b=drITIsurYp3D6UggPzRAvIIta093cjOZY/95qhIME+ZFHnbD92i3USUqPLLrpAozy3
         xZBoa28cUZa3rIAZEQj1u9Get5MA2y5XRpxGMkTRBE8/ApJjjjwMAHqS7asCFS1dIte2
         NY6/A/9rEuYW+GmJDspbDGdBV/LMBGUN1zy8SJxdTD+ngan0vA40qtZeofv3O/o9Mwgf
         fEKgsTj/trjvmPAW1zLjfPBMZVRg6nhVaOVyyi2yPMGWb08A/oBQvudDl9be2vyMI1Bs
         0p8KdnwjWykPujce93326X1I+PDaw1vh9z8Sf4CMDj+4484U3y3yp+CW6tC7jtCoOwvV
         /T7Q==
X-Gm-Message-State: APjAAAU2mLOjAIag4mtHNM7DS5Rw6+vF9Ol+5z/1uP0smcJQJ9gvXEJY
        AP0T+9mjzaq7so3WMspX7HX2ngvoPtn5KlURM5IXy2Bl/Oqhcgqrdr40sivpKKmpWY5hya7EkNY
        5AgxN6jPYLYjZa5Yd
X-Received: by 2002:a1c:3d8a:: with SMTP id k132mr904871wma.144.1574416936567;
        Fri, 22 Nov 2019 02:02:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqwnfT8kemugquSzuCzADN8nk7bWDwXV59utNsTdM9vDxjzVAVfFfI24LbFsDpJ3AH0GMJIOQA==
X-Received: by 2002:a1c:3d8a:: with SMTP id k132mr904842wma.144.1574416936299;
        Fri, 22 Nov 2019 02:02:16 -0800 (PST)
Received: from steredhat.homenet.telecomitalia.it (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id v19sm2111293wrg.38.2019.11.22.02.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:02:15 -0800 (PST)
Date:   Fri, 22 Nov 2019 11:02:12 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH net-next 4/6] vsock: add vsock_loopback transport
Message-ID: <20191122100212.u3mvt6qkay7zexz7@steredhat.homenet.telecomitalia.it>
References: <20191119110121.14480-1-sgarzare@redhat.com>
 <20191119110121.14480-5-sgarzare@redhat.com>
 <20191121093458.GB439743@stefanha-x1.localdomain>
 <20191121095948.bc7lc3ptsh6jxizw@steredhat>
 <20191121152517.zfedz6hg6ftcb2ks@steredhat>
 <20191122092546.GA464656@stefanha-x1.localdomain>
MIME-Version: 1.0
In-Reply-To: <20191122092546.GA464656@stefanha-x1.localdomain>
X-MC-Unique: m7qZghdbMqeXdKlrM8kNWw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 09:25:46AM +0000, Stefan Hajnoczi wrote:
> On Thu, Nov 21, 2019 at 04:25:17PM +0100, Stefano Garzarella wrote:
> > On Thu, Nov 21, 2019 at 10:59:48AM +0100, Stefano Garzarella wrote:
> > > On Thu, Nov 21, 2019 at 09:34:58AM +0000, Stefan Hajnoczi wrote:
> > > > On Tue, Nov 19, 2019 at 12:01:19PM +0100, Stefano Garzarella wrote:
> > > > > +static struct workqueue_struct *vsock_loopback_workqueue;
> > > > > +static struct vsock_loopback *the_vsock_loopback;
> > > >=20
> > > > the_vsock_loopback could be a static global variable (not a pointer=
) and
> > > > vsock_loopback_workqueue could also be included in the struct.
> > > >=20
> > > > The RCU pointer is really a way to synchronize vsock_loopback_send_=
pkt()
> > > > and vsock_loopback_cancel_pkt() with module exit.  There is no othe=
r
> > > > reason for using a pointer.
> > > >=20
> > > > It's cleaner to implement the synchronization once in af_vsock.c (o=
r
> > > > virtio_transport_common.c) instead of making each transport do it.
> > > > Maybe try_module_get() and related APIs provide the necessary seman=
tics
> > > > so that core vsock code can hold the transport module while it's be=
ing
> > > > used to send/cancel a packet.
> > >=20
> > > Right, the module cannot be unloaded until open sockets, so here the
> > > synchronization is not needed.
> > >=20
> > > The synchronization come from virtio-vsock device that can be
> > > hot-unplugged while sockets are still open, but that can't happen her=
e.
> > >=20
> > > I will remove the pointers and RCU in the v2.
> > >=20
> > > Can I keep your R-b or do you prefer to watch v2 first?
>=20
> I'd like to review v2.
>=20

Sure!

> > > > > +MODULE_ALIAS_NETPROTO(PF_VSOCK);
> > > >=20
> > > > Why does this module define the alias for PF_VSOCK?  Doesn't anothe=
r
> > > > module already define this alias?
> > >=20
> > > It is a way to load this module when PF_VSOCK is starting to be used.
> > > MODULE_ALIAS_NETPROTO(PF_VSOCK) is already defined in vmci_transport
> > > and hyperv_transport. IIUC it is used for the same reason.
> > >=20
> > > In virtio_transport we don't need it because it will be loaded when
> > > the PCI device is discovered.
> > >=20
> > > Do you think there's a better way?
> > > Should I include the vsock_loopback transport directly in af_vsock
> > > without creating a new module?
> > >=20
> >=20
> > That last thing I said may not be possible:
> > I remembered that I tried, but DEPMOD found a cyclic dependency because
> > vsock_transport use virtio_transport_common that use vsock, so if I
> > include vsock_transport in the vsock module, DEPMOD is not happy.
> >=20
> > Do you think it's okay in this case to keep MODULE_ALIAS_NETPROTO(PF_VS=
OCK)
> > or is there a better way?
>=20
> The reason I asked is because the semantics of duplicate module aliases
> aren't clear to me.  Do all modules with the same alias get loaded?
> Or just the first?  Or ...?

It wasn't clear to me either, but when I tried, I saw that all modules
with the same alias got loaded.

Stefano

