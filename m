Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F768105002
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKUKFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:05:17 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37776 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726454AbfKUKFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:05:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574330716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mTbZEMwYfOT6jDofWQMm684EqH0d5BOVG5EfNCsfnNw=;
        b=Q4JfqNQ26ceaZUOLRk1+HNDwT9CCXyQgcDevUplomn2HAaCofHu7vnh8Y9XWujjZ0RMm9Y
        hXbplEXz82CdfEwbKoRcUSALmSpYJOhjZV7OgvMkJ3fghANovYdxpR2wkJ+AEwk7dDPkE3
        3L6lXYvUIbjU8Rzkp+q4cIYDEY6OonA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-0FT2gI_SPVO3eui9zL3-Uw-1; Thu, 21 Nov 2019 05:05:14 -0500
Received: by mail-wr1-f70.google.com with SMTP id k15so1754783wrp.22
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 02:05:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WjBe/bpFfR8YjJaRZQ403Que5OIq9zts89mo41qWm30=;
        b=avz3x8q6bqKfx09GUftVZ64QqWBKfODfc0+xS70eDowHXu6vWK6XDJiTzRJ+SjYw2M
         qN3SyPqBwUZvKjCiEgFWgWGV9Q5Mg5z3HkvKRw7mHIKtlJmXeK7lBnEySyXwWakwQtsV
         GU3Y9VDbdCkt443zpn8nB3BFwnKruuuvQlCjtvZTzhqITf88NHDFWIPaQm6kcictdNxL
         zFZMMoCRNmUB3RWZ6uGtStN51fBSORrUvKPtgvgh9cMel2qPx8Ck3yA+zzzDyRFEw+M/
         XO5waJZ3FfHowC7gavahL4Hq+e4YY9HtC5Q4ZYrvHkW/qAZsdP0w0tV4yXjAecoAYstr
         9Ogg==
X-Gm-Message-State: APjAAAX8NzCpkY2Mkpj8tONUdfV5wreiXu+/Na3a5eC9zZ0s2U00PGYg
        6Cxo0IL97rHBZ2ylbEghG0YM5DunWHwmMqU4k06BIWvnGu8LrAtpc45+oTWANIbYlF75CvOCe69
        YndJtMF6o3ejNrsgA
X-Received: by 2002:a1c:7d16:: with SMTP id y22mr8565195wmc.106.1574330713224;
        Thu, 21 Nov 2019 02:05:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqyOlfVU/bWpGIHnKv57s8kK3m5vYZ/Pt8KTmBF8V0SJrqfD//MnSWSTdrBYEv5kqItZozpMBg==
X-Received: by 2002:a1c:7d16:: with SMTP id y22mr8565167wmc.106.1574330712947;
        Thu, 21 Nov 2019 02:05:12 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id 17sm2273656wmg.19.2019.11.21.02.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 02:05:12 -0800 (PST)
Date:   Thu, 21 Nov 2019 11:05:10 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH net-next 0/6] vsock: add local transport support
Message-ID: <20191121100510.7gdcx7c3qom2f3wo@steredhat>
References: <20191119110121.14480-1-sgarzare@redhat.com>
 <20191121094643.GD439743@stefanha-x1.localdomain>
MIME-Version: 1.0
In-Reply-To: <20191121094643.GD439743@stefanha-x1.localdomain>
X-MC-Unique: 0FT2gI_SPVO3eui9zL3-Uw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 09:46:43AM +0000, Stefan Hajnoczi wrote:
> On Tue, Nov 19, 2019 at 12:01:15PM +0100, Stefano Garzarella wrote:
> > This series introduces a new transport (vsock_loopback) to handle
> > local communication.
> > This could be useful to test vsock core itself and to allow developers
> > to test their applications without launching a VM.
> >=20
> > Before this series, vmci and virtio transports allowed this behavior,
> > but only in the guest.
> > We are moving the loopback handling in a new transport, because it
> > might be useful to provide this feature also in the host or when
> > no H2G/G2H transports (hyperv, virtio, vmci) are loaded.
> >=20
> > The user can use the loopback with the new VMADDR_CID_LOCAL (that
> > replaces VMADDR_CID_RESERVED) in any condition.
> > Otherwise, if the G2H transport is loaded, it can also use the guest
> > local CID as previously supported by vmci and virtio transports.
> > If G2H transport is not loaded, the user can also use VMADDR_CID_HOST
> > for local communication.
> >=20
> > Patch 1 is a cleanup to build virtio_transport_common without virtio
> > Patch 2 adds the new VMADDR_CID_LOCAL, replacing VMADDR_CID_RESERVED
> > Patch 3 adds a new feature flag to register a loopback transport
> > Patch 4 adds the new vsock_loopback transport based on the loopback
> >         implementation of virtio_transport
> > Patch 5 implements the logic to use the local transport for loopback
> >         communication
> > Patch 6 removes the loopback from virtio_transport
> >=20
> > @Jorgen: Do you think it might be a problem to replace
> > VMADDR_CID_RESERVED with VMADDR_CID_LOCAL?
> >=20
> > Thanks,
> > Stefano
> >=20
> > Stefano Garzarella (6):
> >   vsock/virtio_transport_common: remove unused virtio header includes
> >   vsock: add VMADDR_CID_LOCAL definition
> >   vsock: add local transport support in the vsock core
> >   vsock: add vsock_loopback transport
> >   vsock: use local transport when it is loaded
> >   vsock/virtio: remove loopback handling
> >=20
> >  MAINTAINERS                             |   1 +
> >  include/net/af_vsock.h                  |   2 +
> >  include/uapi/linux/vm_sockets.h         |   8 +-
> >  net/vmw_vsock/Kconfig                   |  12 ++
> >  net/vmw_vsock/Makefile                  |   1 +
> >  net/vmw_vsock/af_vsock.c                |  49 +++++-
> >  net/vmw_vsock/virtio_transport.c        |  61 +------
> >  net/vmw_vsock/virtio_transport_common.c |   3 -
> >  net/vmw_vsock/vmci_transport.c          |   2 +-
> >  net/vmw_vsock/vsock_loopback.c          | 217 ++++++++++++++++++++++++
> >  10 files changed, 283 insertions(+), 73 deletions(-)
> >  create mode 100644 net/vmw_vsock/vsock_loopback.c
>=20
> Please see my comments.  Otherwise:
>=20
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Thanks!
I'll send a v2 following your comments.

Stefano

