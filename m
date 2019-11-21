Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 545491056A8
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 17:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfKUQM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 11:12:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27828 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726980AbfKUQM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 11:12:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574352774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s4jDlqvRauMO48OH1rfHe5D1vr1CStUdJKWdRifHUHE=;
        b=beR9xVl3TlBNOd7oLX7HZrOyLjQuXf1oRL26fh+GCi6CKoRPh3Sxwz28SnvZm4Dp3a2zdR
        dnayGCS4f2oKKQnU9rOqM8pDPh2t5TWdKJM9GKgWVLSVms/TiGmjwL1nT2XRiMKtueDHLn
        N6SwsrHp3GRaNDkYlsAQY7DRk+kQilQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-soOqgo5TNi6HOeMPmQy1ng-1; Thu, 21 Nov 2019 11:12:52 -0500
Received: by mail-wr1-f72.google.com with SMTP id u14so2299814wrq.19
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 08:12:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bzunz7vaTZgIeoprS+AqEx2vIVmIoRBhLk3Y9Zo1tTc=;
        b=YaiTJKC62Py7b+54TH3GS7iC4AuNMiwOsAXlF+2q0BkVBus7QdWSHen7VDojZA+xpv
         rZP8DAg3cRxtJE5g79gtrKsdNS0cSS0tFR4IAwXpO7Oub9UKbL1IG68vxksWcrYjH8rr
         Ny/s4ytmuK6KPQV5g9vLQHo+uyp0nhsi4oMzNsg9e5ON0vnyV6fr+up+EekysNDsj+8l
         bFKiew6j5wJY01ppjqCRS+gn8nO9VBidL0+JsKfktD9bJx1xXtOeI2pMGb3Bi87OHiXF
         Cb8R6dvHd8tuk8K6Ct3c/eu2yS5Y0jyrETKJm3I4N7hQZmZI3QQP0zp2QNoYZ5O3nUzd
         X+3A==
X-Gm-Message-State: APjAAAWH23xl+DZWHyByQ5M7V1q9mbUb0YAE/ABnyiuSRagtly+Nbrth
        UTDgPfL5nkvJRH49HhYBUFcZXpC5N0zILNTb8hpVzpbMbgwVj9tytuQcUy8lsOG/GkyxcAz2iIV
        dQwbBincaWV6xroyA
X-Received: by 2002:a7b:c10c:: with SMTP id w12mr11307554wmi.114.1574352771191;
        Thu, 21 Nov 2019 08:12:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqx/ihIoiUrBSYY5RXkVJWL/zIYFDoQRjxNOwfDXmQBBbNZUvYEUurSUy8wy3xec3AaM6xyemQ==
X-Received: by 2002:a7b:c10c:: with SMTP id w12mr11307522wmi.114.1574352770936;
        Thu, 21 Nov 2019 08:12:50 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id g133sm75244wme.42.2019.11.21.08.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 08:12:50 -0800 (PST)
Date:   Thu, 21 Nov 2019 17:12:47 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jorgen Hansen <jhansen@vmware.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/6] vsock: add local transport support in the
 vsock core
Message-ID: <20191121161247.u6xvrso272q4ujag@steredhat>
References: <20191119110121.14480-1-sgarzare@redhat.com>
 <20191119110121.14480-4-sgarzare@redhat.com>
 <MWHPR05MB3376F4452F0CF38C1AFABA2EDA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
 <20191121152148.slv26oesn25dpjb6@steredhat>
 <MWHPR05MB3376D95B5E50DF7CAF675EEDDA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <MWHPR05MB3376D95B5E50DF7CAF675EEDDA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
X-MC-Unique: soOqgo5TNi6HOeMPmQy1ng-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 03:53:47PM +0000, Jorgen Hansen wrote:
> > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > Sent: Thursday, November 21, 2019 4:22 PM
> >=20
> > On Thu, Nov 21, 2019 at 03:04:18PM +0000, Jorgen Hansen wrote:
> > > > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > > > Sent: Tuesday, November 19, 2019 12:01 PM
> > > > To: netdev@vger.kernel.org
> > > >
> > > > This patch allows to register a transport able to handle
> > > > local communication (loopback).
> > > >
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > ---
> > > >  include/net/af_vsock.h   |  2 ++
> > > >  net/vmw_vsock/af_vsock.c | 17 ++++++++++++++++-
> > > >  2 files changed, 18 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > > > index 4206dc6d813f..b1c717286993 100644
> > > > --- a/include/net/af_vsock.h
> > > > +++ b/include/net/af_vsock.h
> > > > @@ -98,6 +98,8 @@ struct vsock_transport_send_notify_data {
> > > >  #define VSOCK_TRANSPORT_F_G2H=09=090x00000002
> > > >  /* Transport provides DGRAM communication */
> > > >  #define VSOCK_TRANSPORT_F_DGRAM=09=090x00000004
> > > > +/* Transport provides local (loopback) communication */
> > > > +#define VSOCK_TRANSPORT_F_LOCAL=09=090x00000008
> > > >
> > > >  struct vsock_transport {
> > > >  =09struct module *module;
> > > > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > > > index cc8659838bf2..c9e5bad59dc1 100644
> > > > --- a/net/vmw_vsock/af_vsock.c
> > > > +++ b/net/vmw_vsock/af_vsock.c
> > > > @@ -136,6 +136,8 @@ static const struct vsock_transport
> > *transport_h2g;
> > > >  static const struct vsock_transport *transport_g2h;
> > > >  /* Transport used for DGRAM communication */
> > > >  static const struct vsock_transport *transport_dgram;
> > > > +/* Transport used for local communication */
> > > > +static const struct vsock_transport *transport_local;
> > > >  static DEFINE_MUTEX(vsock_register_mutex);
> > > >
> > > >  /**** UTILS ****/
> > > > @@ -2130,7 +2132,7 @@
> > EXPORT_SYMBOL_GPL(vsock_core_get_transport);
> > > >
> > > >  int vsock_core_register(const struct vsock_transport *t, int featu=
res)
> > > >  {
> > > > -=09const struct vsock_transport *t_h2g, *t_g2h, *t_dgram;
> > > > +=09const struct vsock_transport *t_h2g, *t_g2h, *t_dgram, *t_local=
;
> > > >  =09int err =3D mutex_lock_interruptible(&vsock_register_mutex);
> > > >
> > > >  =09if (err)
> > > > @@ -2139,6 +2141,7 @@ int vsock_core_register(const struct
> > > > vsock_transport *t, int features)
> > > >  =09t_h2g =3D transport_h2g;
> > > >  =09t_g2h =3D transport_g2h;
> > > >  =09t_dgram =3D transport_dgram;
> > > > +=09t_local =3D transport_local;
> > > >
> > > >  =09if (features & VSOCK_TRANSPORT_F_H2G) {
> > > >  =09=09if (t_h2g) {
> > > > @@ -2164,9 +2167,18 @@ int vsock_core_register(const struct
> > > > vsock_transport *t, int features)
> > > >  =09=09t_dgram =3D t;
> > > >  =09}
> > > >
> > > > +=09if (features & VSOCK_TRANSPORT_F_LOCAL) {
> > > > +=09=09if (t_local) {
> > > > +=09=09=09err =3D -EBUSY;
> > > > +=09=09=09goto err_busy;
> > > > +=09=09}
> > > > +=09=09t_local =3D t;
> > > > +=09}
> > > > +
> > > >  =09transport_h2g =3D t_h2g;
> > > >  =09transport_g2h =3D t_g2h;
> > > >  =09transport_dgram =3D t_dgram;
> > > > +=09transport_local =3D t_local;
> > > >
> > > >  err_busy:
> > > >  =09mutex_unlock(&vsock_register_mutex);
> > > > @@ -2187,6 +2199,9 @@ void vsock_core_unregister(const struct
> > > > vsock_transport *t)
> > > >  =09if (transport_dgram =3D=3D t)
> > > >  =09=09transport_dgram =3D NULL;
> > > >
> > > > +=09if (transport_local =3D=3D t)
> > > > +=09=09transport_local =3D NULL;
> > > > +
> > > >  =09mutex_unlock(&vsock_register_mutex);
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(vsock_core_unregister);
> > > > --
> > > > 2.21.0
> > >
> > > Having loopback support as a separate transport fits nicely, but do w=
e need
> > to support
> > > different variants of loopback? It could just be built in.
> >=20
> > I agree with you, indeed initially I developed it as built in, but
> > DEPMOD found a cyclic dependency because vsock_transport use
> > virtio_transport_common that use vsock, so if I include vsock_transport
> > in the vsock module, DEPMOD is not happy.
> >=20
> > I don't know how to break this cyclic dependency, do you have any ideas=
?
>=20
> One way to view this would be that the loopback transport and the support
> it uses from virtio_transport_common are independent of virtio as such,
> and could be part of  the af_vsock module if loopback is configured. So
> in a way, the virtio g2h and h2g transports would be extensions of the
> built in loopback transport. But that brings in quite a bit of code so
> it could be better to just keep it as is.

Great idea!

Stefan already suggested (as a long-term goal) to rename the generic
functionality in virtio_transport_common.c

Maybe I can do both in another series later on, since it requires enough
changes.

Thanks,
Stefano

