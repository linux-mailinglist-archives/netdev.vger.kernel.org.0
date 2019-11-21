Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 785E0105520
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfKUPOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:14:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45663 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726716AbfKUPOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 10:14:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574349242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S/ndUKKJCxI76HoRVTG7jNdszQTcPJXiUk69ASnD9hc=;
        b=BFZPun6Wui8mst5ik4v+igZbbNO52U03jnmSpDZ1ATsGYUxUJFr+Ti3ykcD52EkazKpp+B
        ko2SioijMq46xlosEU/tY9Nt7mHwLezU+K1xLd3BvLSJRmSAi5PvMABX2yMrB2PxStfrsf
        GYB6ESIY9PDnA2Y+Db56AsDis/pFM7w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-sbaU5VrmMxWepkgX6OVgmw-1; Thu, 21 Nov 2019 10:13:59 -0500
Received: by mail-wm1-f71.google.com with SMTP id y14so1959233wmi.4
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 07:13:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iHsCY/CMXwIcgnSHclUoHJ8eh4Q1rh48lgjW6W5ihDs=;
        b=d5/VlY9ZAHp0xuD8bGT53YmEJzntXc3bWBFqT4r9Pt/RTGQgD7Otyj8G89l2wUZASW
         dNTEmwpDuq6Xib8W2dNxBLlZIk7opGGQOALRyzzPoE9K4gHXo/EadZSeAWW7YpKYzIkM
         71XoUrQKcijVhueyZlLWEGOnnYQd0YVl50uyPVy65wlPkv/x1CUHYtC0qfZNOLXwmfwt
         Jevh0o4XetrKwv7BxsBR3uhaniqrQ7b2O9JaNgBQnBrJwWDafbrRd0ORtyKlUNf2kZXS
         EDyiQopRcHa5ySTedeVl5OS+QYonjD/7l2lzmkrxs7PeCifaZJ/OLYhyIKIk7Alo75EO
         iBvg==
X-Gm-Message-State: APjAAAUUaCuOQ4rLORUuomUr8+UIY3TcO93EMoxRXCmSHCLJn3y5kpR3
        vrvGlsKDY4L2uACxifxqAhLBRuQ3qBzCpvu44Rr+DE5XU5WjStswWoNHChIHe69rYBrgNO0j0S8
        HDWRPqd8w6c4Ufwjz
X-Received: by 2002:adf:fd4a:: with SMTP id h10mr10771260wrs.90.1574349237925;
        Thu, 21 Nov 2019 07:13:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqwffrnaWrX2CTnz1mrGFjyWf4QxuPdCHsb+nu0fFKK6LVRRphnlRgzFqP4BBbEKQFy/2FMiLQ==
X-Received: by 2002:adf:fd4a:: with SMTP id h10mr10771237wrs.90.1574349237686;
        Thu, 21 Nov 2019 07:13:57 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id z7sm1978953wma.46.2019.11.21.07.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 07:13:57 -0800 (PST)
Date:   Thu, 21 Nov 2019 16:13:55 +0100
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
Subject: Re: [PATCH net-next 0/6] vsock: add local transport support
Message-ID: <20191121151355.grgfbte6xniqe6xo@steredhat>
References: <20191119110121.14480-1-sgarzare@redhat.com>
 <MWHPR05MB3376B8241546664BBCA6FC37DA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <MWHPR05MB3376B8241546664BBCA6FC37DA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
X-MC-Unique: sbaU5VrmMxWepkgX6OVgmw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 02:45:32PM +0000, Jorgen Hansen wrote:
> > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > Sent: Tuesday, November 19, 2019 12:01 PM
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
> > Patch 2 adds the new VMADDR_CID_LOCAL, replacing
> > VMADDR_CID_RESERVED
> > Patch 3 adds a new feature flag to register a loopback transport
> > Patch 4 adds the new vsock_loopback transport based on the loopback
> >         implementation of virtio_transport
> > Patch 5 implements the logic to use the local transport for loopback
> >         communication
> > Patch 6 removes the loopback from virtio_transport
> >=20
> > @Jorgen: Do you think it might be a problem to replace
> > VMADDR_CID_RESERVED with VMADDR_CID_LOCAL?
>=20
> No, that should be fine. It has never allowed for use with stream sockets=
 in
> AF_VSOCK. The only potential use would be for datagram sockets, but that
> side appears to be unaffected by your changes, since loopback is only
> introduced for SOCK_STREAM.
>=20

Yes, datagram sockets are not affected.

Thanks for the clarification,
Stefano

