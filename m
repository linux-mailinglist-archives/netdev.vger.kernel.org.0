Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A258AF8D0D
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 11:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfKLKmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 05:42:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39649 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725874AbfKLKmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 05:42:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573555327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t5MdSNFaJUFMw+ktkmGSBraFfMN3xLO5MNDHuMIJ4YE=;
        b=HaduibEqAzTAbDcLKxpVJhQGJtOo5L1eOQHLk90G1bscwcqPWVVgM92vA/26fbQ1gGUd0J
        9nmH8DccMykdZKMj9XD5UqSs/z/5ApfIyZBBIhixDgPBoYnD9qKPx6dMXtJ5h/+jjqaX9M
        CUMzULJExTLCFdwI40mZQFJPWhWVif8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-h_2epXcLOIOff8FKvvomaw-1; Tue, 12 Nov 2019 05:42:06 -0500
Received: by mail-wr1-f72.google.com with SMTP id f8so11667175wrq.6
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 02:42:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vUK3k3PYV7+WIhfZTJTf9V3GDfUQYxuDQUeG6IzQ6Bc=;
        b=d+zDlerfnJ1z2490bArmkQJrItko10NgXCFC+GJPnRo7oPMEbfbX9tbPp4uL3simb1
         TivxlgrnGw4IfCQnseBcS0eEBeUof//LeIocYJ3ijvfLyt+OftKH4jdybsY8rnVhEhzW
         3N9NWIBmgTuWX/RyiNJpOkbOQ0d+HxEIGNO/gPmVwhdFiSpX1YkfTMrH/yeypOD4pjYj
         HsUkUKPgrL1NXB0asuCxkJh0tqCy64b7N8AgprzpUzGTxaGg8DjiFFCwLEiE/2FkBbz2
         fnACuQhHW7EXN5K2aM3vC3xIcQPx38qIORJWHrkeAH+YHTNVMkeitYw636JLIg92oRLN
         SWVQ==
X-Gm-Message-State: APjAAAU3eqygC/A67PvACOiLXpyoLbyQk039vS2IbpMHwlzYNKYDqkyo
        +k9FMXf7+//zg9JqWlILfsdhAIL/Vy2zmFiBa+0xXf+C7WZck02PG6IVcegJbQXLrsfUtL1NHfY
        Vldj03yakcZjmkd40
X-Received: by 2002:adf:9e05:: with SMTP id u5mr19523223wre.239.1573555324981;
        Tue, 12 Nov 2019 02:42:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqwq/QTsf6eKeo9n5WelsN7V/SyybR7/jPKjiKjoknrXU4ymGTeF6cAW0Vus7tswMT5UtujQRw==
X-Received: by 2002:adf:9e05:: with SMTP id u5mr19523199wre.239.1573555324672;
        Tue, 12 Nov 2019 02:42:04 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id j11sm18787131wrq.26.2019.11.12.02.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 02:42:04 -0800 (PST)
Date:   Tue, 12 Nov 2019 11:42:01 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jorgen Hansen <jhansen@vmware.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 12/14] vsock/vmci: register vmci_transport only
 when VMCI guest/host are active
Message-ID: <20191112104201.abt7h37df24h3n7p@steredhat>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-13-sgarzare@redhat.com>
 <MWHPR05MB3376266BC6AE9E6E0B75F1A1DA740@MWHPR05MB3376.namprd05.prod.outlook.com>
 <20191111173053.erwfzawioxje635o@steredhat>
 <MWHPR05MB33769FD52B833FC1C82F0A80DA770@MWHPR05MB3376.namprd05.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <MWHPR05MB33769FD52B833FC1C82F0A80DA770@MWHPR05MB3376.namprd05.prod.outlook.com>
X-MC-Unique: h_2epXcLOIOff8FKvvomaw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 10:03:54AM +0000, Jorgen Hansen wrote:
> > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > Sent: Monday, November 11, 2019 6:31 PM
> > On Mon, Nov 11, 2019 at 04:27:28PM +0000, Jorgen Hansen wrote:
> > > > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > > > Sent: Wednesday, October 23, 2019 11:56 AM
> > > >
> > > > To allow other transports to be loaded with vmci_transport,
> > > > we register the vmci_transport as G2H or H2G only when a VMCI guest
> > > > or host is active.
> > > >
> > > > To do that, this patch adds a callback registered in the vmci drive=
r
> > > > that will be called when a new host or guest become active.
> > > > This callback will register the vmci_transport in the VSOCK core.
> > > > If the transport is already registered, we ignore the error coming
> > > > from vsock_core_register().
> > >
> > > So today this is mainly an issue for the VMCI vsock transport, becaus=
e
> > > VMCI autoloads with vsock (and with this solution it can continue to
> > > do that, so none of our old products break due to changed behavior,
> > > which is great).
> >=20
> > I tried to not break anything :-)
> >=20
> > >                  Shouldn't vhost behave similar, so that any module
> > > that registers a h2g transport only does so if it is in active use?
> > >
> >=20
> > The vhost-vsock module will load when the first hypervisor open
> > /dev/vhost-vsock, so in theory, when there's at least one active user.
>=20
> Ok, sounds good then.=20
>=20
> >=20
> > >
> > > > --- a/drivers/misc/vmw_vmci/vmci_host.c
> > > > +++ b/drivers/misc/vmw_vmci/vmci_host.c
> > > > @@ -108,6 +108,11 @@ bool vmci_host_code_active(void)
> > > >  =09     atomic_read(&vmci_host_active_users) > 0);
> > > >  }
> > > >
> > > > +int vmci_host_users(void)
> > > > +{
> > > > +=09return atomic_read(&vmci_host_active_users);
> > > > +}
> > > > +
> > > >  /*
> > > >   * Called on open of /dev/vmci.
> > > >   */
> > > > @@ -338,6 +343,8 @@ static int vmci_host_do_init_context(struct
> > > > vmci_host_dev *vmci_host_dev,
> > > >  =09vmci_host_dev->ct_type =3D VMCIOBJ_CONTEXT;
> > > >  =09atomic_inc(&vmci_host_active_users);
> > > >
> > > > +=09vmci_call_vsock_callback(true);
> > > > +
> > >
> > > Since we don't unregister the transport if user count drops back to 0=
, we
> > could
> > > just call this the first time, a VM is powered on after the module is=
 loaded.
> >=20
> > Yes, make sense. can I use the 'vmci_host_active_users' or is better to
> > add a new 'vmci_host_vsock_loaded'?
> >=20
> > My doubt is that vmci_host_active_users can return to 0, so when it ret=
urns
> > to 1, we call vmci_call_vsock_callback() again.
>=20
> vmci_host_active_users can drop to 0 and then increase again, so having a=
 flag
> indicating whether the callback has been invoked would ensure that it is =
only
> called once.

I agree, I will use a dedicated flag, maybe in the
vmci_call_vsock_callback(), since it can be called or during the
vmci_host_do_init_context() or when the callback is registered.

Thanks,
Stefano

