Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB4310554F
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfKUPVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:21:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50782 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726279AbfKUPVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 10:21:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574349714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xoi/mEqRIrWnRpvTl0NDdwq5Vb/YMexVa8/yaCTR3QA=;
        b=b7Plpv5bOiJAaDAdZ7qJ3+NQ3Jlhke4HJSBqpWcI+LKraNetwF+gadcsDtWeuNjxNsL0e6
        aMVCJcTU04W2bXywyb9RGW6PszSIPcKk1j7mCG6S7RBZ+MTkaPZXXf1roeIq2dqmvFioiL
        k8FDc47WY32ZDuGcNhRmHAm5rDK7kyc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-xvKQWEQKM6WbCa3BZgGTOA-1; Thu, 21 Nov 2019 10:21:53 -0500
Received: by mail-wm1-f70.google.com with SMTP id f16so1721295wmb.2
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 07:21:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v1PSvxZigoBGfcnTdo+vCEuQthQ6gbSlafKpw/APSmQ=;
        b=S2v+A2glnIJohck/xI02mBbIPuUXzzuqpd0fBHdseE0qBb7FVDEQQZbjtIFLn3tbE3
         KxCjr6YPucHjAW406656jdMp585EcLVIQ6Lqm10+nEv1d8nw6GAYc2eeePT70eZBiLop
         p4L6f1Z1YUiFJjZPRjSDqZYBlpV1MVySbv0FFOm9SIkYQMi08IMhghrRcNghj+Gw7FFX
         zzfS55mVtP7Pi/gAjKcA8z1WTY5kyyius+j56fF27vSN26wkDQemRaPzgEJyT+QTgvcA
         GwYwb9/pCHJ7tjMG3kfdQG2/FvedRifTxOCOPZAYf7ekjABmhj2+WELUY6upV9mMsloj
         Jbvg==
X-Gm-Message-State: APjAAAW7wOigHjf+r1DyV1ePI0cz7GHtkLLahCPiJsNhEUWgU+MTWfFq
        tnH69FJn/7mZA/7K1BdFyAtVHpW2XWhmrtI9g1K8CUR6cggjlcWjcj9mCVcqdn7U26eiCOG124W
        lyDNgOhuJUBJ/ljjt
X-Received: by 2002:a1c:3dc4:: with SMTP id k187mr10402991wma.167.1574349711883;
        Thu, 21 Nov 2019 07:21:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqySb9ZwhXcrSGZTnTFX5ITs/qVK8z9OeOvPDmE4FyZUCogUa+d5o5clfV/hdSBv8nnPcYrKmw==
X-Received: by 2002:a1c:3dc4:: with SMTP id k187mr10402963wma.167.1574349711644;
        Thu, 21 Nov 2019 07:21:51 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id s9sm3077160wmj.22.2019.11.21.07.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 07:21:51 -0800 (PST)
Date:   Thu, 21 Nov 2019 16:21:48 +0100
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
Message-ID: <20191121152148.slv26oesn25dpjb6@steredhat>
References: <20191119110121.14480-1-sgarzare@redhat.com>
 <20191119110121.14480-4-sgarzare@redhat.com>
 <MWHPR05MB3376F4452F0CF38C1AFABA2EDA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <MWHPR05MB3376F4452F0CF38C1AFABA2EDA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
X-MC-Unique: xvKQWEQKM6WbCa3BZgGTOA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 03:04:18PM +0000, Jorgen Hansen wrote:
> > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > Sent: Tuesday, November 19, 2019 12:01 PM
> > To: netdev@vger.kernel.org
> >
> > This patch allows to register a transport able to handle
> > local communication (loopback).
> >=20
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >  include/net/af_vsock.h   |  2 ++
> >  net/vmw_vsock/af_vsock.c | 17 ++++++++++++++++-
> >  2 files changed, 18 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > index 4206dc6d813f..b1c717286993 100644
> > --- a/include/net/af_vsock.h
> > +++ b/include/net/af_vsock.h
> > @@ -98,6 +98,8 @@ struct vsock_transport_send_notify_data {
> >  #define VSOCK_TRANSPORT_F_G2H=09=090x00000002
> >  /* Transport provides DGRAM communication */
> >  #define VSOCK_TRANSPORT_F_DGRAM=09=090x00000004
> > +/* Transport provides local (loopback) communication */
> > +#define VSOCK_TRANSPORT_F_LOCAL=09=090x00000008
> >=20
> >  struct vsock_transport {
> >  =09struct module *module;
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index cc8659838bf2..c9e5bad59dc1 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -136,6 +136,8 @@ static const struct vsock_transport *transport_h2g;
> >  static const struct vsock_transport *transport_g2h;
> >  /* Transport used for DGRAM communication */
> >  static const struct vsock_transport *transport_dgram;
> > +/* Transport used for local communication */
> > +static const struct vsock_transport *transport_local;
> >  static DEFINE_MUTEX(vsock_register_mutex);
> >=20
> >  /**** UTILS ****/
> > @@ -2130,7 +2132,7 @@ EXPORT_SYMBOL_GPL(vsock_core_get_transport);
> >=20
> >  int vsock_core_register(const struct vsock_transport *t, int features)
> >  {
> > -=09const struct vsock_transport *t_h2g, *t_g2h, *t_dgram;
> > +=09const struct vsock_transport *t_h2g, *t_g2h, *t_dgram, *t_local;
> >  =09int err =3D mutex_lock_interruptible(&vsock_register_mutex);
> >=20
> >  =09if (err)
> > @@ -2139,6 +2141,7 @@ int vsock_core_register(const struct
> > vsock_transport *t, int features)
> >  =09t_h2g =3D transport_h2g;
> >  =09t_g2h =3D transport_g2h;
> >  =09t_dgram =3D transport_dgram;
> > +=09t_local =3D transport_local;
> >=20
> >  =09if (features & VSOCK_TRANSPORT_F_H2G) {
> >  =09=09if (t_h2g) {
> > @@ -2164,9 +2167,18 @@ int vsock_core_register(const struct
> > vsock_transport *t, int features)
> >  =09=09t_dgram =3D t;
> >  =09}
> >=20
> > +=09if (features & VSOCK_TRANSPORT_F_LOCAL) {
> > +=09=09if (t_local) {
> > +=09=09=09err =3D -EBUSY;
> > +=09=09=09goto err_busy;
> > +=09=09}
> > +=09=09t_local =3D t;
> > +=09}
> > +
> >  =09transport_h2g =3D t_h2g;
> >  =09transport_g2h =3D t_g2h;
> >  =09transport_dgram =3D t_dgram;
> > +=09transport_local =3D t_local;
> >=20
> >  err_busy:
> >  =09mutex_unlock(&vsock_register_mutex);
> > @@ -2187,6 +2199,9 @@ void vsock_core_unregister(const struct
> > vsock_transport *t)
> >  =09if (transport_dgram =3D=3D t)
> >  =09=09transport_dgram =3D NULL;
> >=20
> > +=09if (transport_local =3D=3D t)
> > +=09=09transport_local =3D NULL;
> > +
> >  =09mutex_unlock(&vsock_register_mutex);
> >  }
> >  EXPORT_SYMBOL_GPL(vsock_core_unregister);
> > --
> > 2.21.0
>=20
> Having loopback support as a separate transport fits nicely, but do we ne=
ed to support
> different variants of loopback? It could just be built in.

I agree with you, indeed initially I developed it as built in, but
DEPMOD found a cyclic dependency because vsock_transport use
virtio_transport_common that use vsock, so if I include vsock_transport
in the vsock module, DEPMOD is not happy.

I don't know how to break this cyclic dependency, do you have any ideas?

Thanks,
Stefano

