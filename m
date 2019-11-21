Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFA610556D
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfKUPZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:25:26 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30469 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726613AbfKUPZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 10:25:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574349924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kBm3B1uW0ATy8DLnD/N50So/7howYiU9bWi3eGPQ8KQ=;
        b=BZyUrSto5o2CWfb2u7Au4/2bJfT9L7J+OoaA3WWxf0XbhkePDBeJq6b4l0XD3z4mBoW/eM
        wHbGEWik78dbrFTdjTsO+3MR2dsXszCjFxy5IjyPMPp0ka+yufqtQcy5zoWq47rG5qIUjO
        NQJqbkatmPhXdV3+dtl4TYJ1j9CNAxQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-N5QS5iwqMSWIqzfcSfG7fw-1; Thu, 21 Nov 2019 10:25:21 -0500
Received: by mail-wm1-f71.google.com with SMTP id f191so1998571wme.1
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 07:25:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Luh/FRsdrygdtryuzjcgAMyRo3l6t+Zhjzz9aLHJ0EU=;
        b=f9zG0s+5au4PdJQpLvqKG74EFWFIs+0pQ6R+3hje3iH5rjmUvRypXn8paD+8ITGxPP
         Y9yEX6fIXHQAg3Zc9HqZuOb1FQORsOP0+JFnVsVsCdx1gqiAsnIQy3zSvJ9xowdUlikM
         RHJzTsrKF2IP+aVzNVNrQqyJ6sjnN5b1ciuQtCG2K6P6qWsPn0FrnzMmhWnhFaTew7hk
         QVXbVNa82SkOdLGV8DSBinGzGcbE3drklDaJXhCJKRfhTQBTB46jjQK8LGthI3PBBXSJ
         ikTf0zvROeLnsIhToDzAz2DVbYE05YQHg1L3BmVD35Kb5Lko97uQuWrAcI1WOZ0EoS8b
         YL4Q==
X-Gm-Message-State: APjAAAUIrUK4pmKWNqRX0eSMiWvy3gSTkbbjutE8SrUXbrGG0hMX8KBv
        SRAKdkO0c2Pn2UqGwZKvLhaBNVID/g0v6Be0mONUg4yJJp6TIGrxVkaPsSIPh/oDbuDiJDuZROw
        QDygH/69T5LQUcEZo
X-Received: by 2002:a05:600c:2410:: with SMTP id 16mr10111951wmp.36.1574349920264;
        Thu, 21 Nov 2019 07:25:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqw6kCXHNhqyKfZOnNRC+6rkdzH+5TteBCvmm65ewNpd7LRKY0hfW8ym9t1TkIRcJ7FqzYeccA==
X-Received: by 2002:a05:600c:2410:: with SMTP id 16mr10111918wmp.36.1574349919938;
        Thu, 21 Nov 2019 07:25:19 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id w17sm3864052wrt.45.2019.11.21.07.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 07:25:19 -0800 (PST)
Date:   Thu, 21 Nov 2019 16:25:17 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH net-next 4/6] vsock: add vsock_loopback transport
Message-ID: <20191121152517.zfedz6hg6ftcb2ks@steredhat>
References: <20191119110121.14480-1-sgarzare@redhat.com>
 <20191119110121.14480-5-sgarzare@redhat.com>
 <20191121093458.GB439743@stefanha-x1.localdomain>
 <20191121095948.bc7lc3ptsh6jxizw@steredhat>
MIME-Version: 1.0
In-Reply-To: <20191121095948.bc7lc3ptsh6jxizw@steredhat>
X-MC-Unique: N5QS5iwqMSWIqzfcSfG7fw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 10:59:48AM +0100, Stefano Garzarella wrote:
> On Thu, Nov 21, 2019 at 09:34:58AM +0000, Stefan Hajnoczi wrote:
> > On Tue, Nov 19, 2019 at 12:01:19PM +0100, Stefano Garzarella wrote:
> >=20
> > Ideas for long-term changes below.
> >=20
> > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> >=20
>=20
> Thanks for reviewing!
>=20
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 760049454a23..c2a3dc3113ba 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -17239,6 +17239,7 @@ F:=09net/vmw_vsock/diag.c
> > >  F:=09net/vmw_vsock/af_vsock_tap.c
> > >  F:=09net/vmw_vsock/virtio_transport_common.c
> > >  F:=09net/vmw_vsock/virtio_transport.c
> > > +F:=09net/vmw_vsock/vsock_loopback.c
> > >  F:=09drivers/net/vsockmon.c
> > >  F:=09drivers/vhost/vsock.c
> > >  F:=09tools/testing/vsock/
> >=20
> > At this point you are most active in virtio-vsock and I am reviewing
> > patches on a best-effort basis.  Feel free to add yourself as
> > maintainer.
> >=20
>=20
> Sure, I'd be happy to maintain it.
>=20
> > > diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loo=
pback.c
> > > new file mode 100644
> > > index 000000000000..3d1c1a88305f
> > > --- /dev/null
> > > +++ b/net/vmw_vsock/vsock_loopback.c
> > > @@ -0,0 +1,217 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * loopback transport for vsock using virtio_transport_common APIs
> > > + *
> > > + * Copyright (C) 2013-2019 Red Hat, Inc.
> > > + * Author: Asias He <asias@redhat.com>
> > > + *         Stefan Hajnoczi <stefanha@redhat.com>
> > > + *         Stefano Garzarella <sgarzare@redhat.com>
> > > + *
> > > + */
> > > +#include <linux/spinlock.h>
> > > +#include <linux/module.h>
> > > +#include <linux/list.h>
> > > +#include <linux/virtio_vsock.h>
> >=20
> > Is it time to rename the generic functionality in
> > virtio_transport_common.c?  This doesn't have anything to do with virti=
o
> > :).
> >=20
>=20
> Completely agree, new transports could use it to handle the protocol with=
out
> reimplementing things already done.
>=20
> > > +
> > > +static struct workqueue_struct *vsock_loopback_workqueue;
> > > +static struct vsock_loopback *the_vsock_loopback;
> >=20
> > the_vsock_loopback could be a static global variable (not a pointer) an=
d
> > vsock_loopback_workqueue could also be included in the struct.
> >=20
> > The RCU pointer is really a way to synchronize vsock_loopback_send_pkt(=
)
> > and vsock_loopback_cancel_pkt() with module exit.  There is no other
> > reason for using a pointer.
> >=20
> > It's cleaner to implement the synchronization once in af_vsock.c (or
> > virtio_transport_common.c) instead of making each transport do it.
> > Maybe try_module_get() and related APIs provide the necessary semantics
> > so that core vsock code can hold the transport module while it's being
> > used to send/cancel a packet.
>=20
> Right, the module cannot be unloaded until open sockets, so here the
> synchronization is not needed.
>=20
> The synchronization come from virtio-vsock device that can be
> hot-unplugged while sockets are still open, but that can't happen here.
>=20
> I will remove the pointers and RCU in the v2.
>=20
> Can I keep your R-b or do you prefer to watch v2 first?
>=20
> >=20
> > > +MODULE_ALIAS_NETPROTO(PF_VSOCK);
> >=20
> > Why does this module define the alias for PF_VSOCK?  Doesn't another
> > module already define this alias?
>=20
> It is a way to load this module when PF_VSOCK is starting to be used.
> MODULE_ALIAS_NETPROTO(PF_VSOCK) is already defined in vmci_transport
> and hyperv_transport. IIUC it is used for the same reason.
>=20
> In virtio_transport we don't need it because it will be loaded when
> the PCI device is discovered.
>=20
> Do you think there's a better way?
> Should I include the vsock_loopback transport directly in af_vsock
> without creating a new module?
>=20

That last thing I said may not be possible:
I remembered that I tried, but DEPMOD found a cyclic dependency because
vsock_transport use virtio_transport_common that use vsock, so if I
include vsock_transport in the vsock module, DEPMOD is not happy.

Do you think it's okay in this case to keep MODULE_ALIAS_NETPROTO(PF_VSOCK)
or is there a better way?

Thanks,
Stefano

