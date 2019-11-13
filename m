Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42772FB54D
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 17:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbfKMQiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 11:38:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43771 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726410AbfKMQiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 11:38:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573663129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QqzCZrrw+N1LqLUBngxMhEYqWKp5yMdHfOeTcezaP3c=;
        b=B3fvV0aQqI2IdTj0FBfXfd9gyVROAqBr+BbM2U05MxVkct6bUtImRPAsYesHYBhWyT1YOG
        DIap0conT6MyRfVR5H993pRcNJJioW5rrwhENnWOh51DEuwC/+oSbmQbmnqbYLuX8F72AY
        kNq1KmqUiVkHKT/1zGiMfjY+rj/mXBg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-djoDrPpaN_ael8bQfx3xPQ-1; Wed, 13 Nov 2019 11:38:48 -0500
Received: by mail-wm1-f71.google.com with SMTP id y133so1407723wmd.8
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 08:38:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9rmRmGxbCej/NSmLlrw5qBptbx4sAiez+aV0DPKoxmk=;
        b=bj1HZ1VsSiZ7je45DS5V4W3/8odVDcTSL0l7M9ziJF3Sw0ziU3jTazblnH3dH3wBwd
         aJcbr/MR7/rmy5MhFnVaUcf9qB12JqWe0/u/zjTIse8e5h6RE6i/CVf90VTZvf4vwQCT
         TzoY1yamFIoEl0HFb7fV1IF7T3mCvIROKb+ukFYFwVRrQ0+fWSZViH8aPu7haoVJEAra
         QvqVhz8mT/wvYm8Vbd9hKk1EP9SG4zrTi0ddh5moxdn3lKDkwAXndftirDZDK+Mce9uW
         qdE6U37txjunvjz3SYQIWoLdR8Dp4Fqi0apgsYHao34rOM8tpHr0Yi2o31bDQhuzIKIg
         FHDw==
X-Gm-Message-State: APjAAAUdzmVWUOBOQYsa0x/nlE/XjUiUYMSs8I80v/Ok8momvjLFgCMH
        kQDnwKejuc4SgdH3r4sZHV/kaDWHAOvWhbNo/YmmeqFdlPiDEui5+fMj5K8fzuUQtOcMh7bgYWv
        Nth45AsLrjIgHn8Ew
X-Received: by 2002:adf:f0c4:: with SMTP id x4mr2417503wro.217.1573663126802;
        Wed, 13 Nov 2019 08:38:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqxXrDaHddzqNUvTPvMV4jXm5tNoMjrSJ3IvH3rKSatkd4o3Pvp2hT95nFuBwmA+H3+NDewgsg==
X-Received: by 2002:adf:f0c4:: with SMTP id x4mr2417472wro.217.1573663126527;
        Wed, 13 Nov 2019 08:38:46 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id q17sm2813058wmj.12.2019.11.13.08.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 08:38:45 -0800 (PST)
Date:   Wed, 13 Nov 2019 17:38:42 +0100
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
Subject: Re: [PATCH net-next 11/14] vsock: add multi-transports support
Message-ID: <20191113163842.6byl2qul4nbjf5no@steredhat>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-12-sgarzare@redhat.com>
 <MWHPR05MB33761FE4DA27130C72FC5048DA740@MWHPR05MB3376.namprd05.prod.outlook.com>
 <20191111171740.xwo7isdmtt7ywibo@steredhat>
 <MWHPR05MB33764F82AFA882B921A11E56DA770@MWHPR05MB3376.namprd05.prod.outlook.com>
 <20191112103630.vd3kbk7xnplv6rey@steredhat>
 <MWHPR05MB3376560CFD2A710723843828DA760@MWHPR05MB3376.namprd05.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <MWHPR05MB3376560CFD2A710723843828DA760@MWHPR05MB3376.namprd05.prod.outlook.com>
X-MC-Unique: djoDrPpaN_ael8bQfx3xPQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 02:30:24PM +0000, Jorgen Hansen wrote:
> > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > Sent: Tuesday, November 12, 2019 11:37 AM
>=20
> > > > > You already mentioned that you are working on a fix for loopback
> > > > > here for the guest, but presumably a host could also do loopback.
> > > >
> > > > IIUC we don't support loopback in the host, because in this case th=
e
> > > > application will use the CID_HOST as address, but if we are in a ne=
sted
> > > > VM environment we are in trouble.
> > >
> > > If both src and dst CID are CID_HOST, we should be fairly sure that t=
his
> > > Is host loopback, no? If src is anything else, we would do G2H.
> > >
> >=20
> > The problem is that we don't know the src until we assign a transport
> > looking at the dst. (or if the user bound the socket to CID_HOST before
> > the connect(), but it is not very common)
> >=20
> > So if we are in a L1 and the user uses the local guest CID, it works, b=
ut if
> > it uses the HOST_CID, the packet will go to the L0.
> >=20
> > If we are in L0, it could be simple, because we can simply check if G2H
> > is not loaded, so any packet to CID_HOST, is host loopback.
> >=20
> > I think that if the user uses the IOCTL_VM_SOCKETS_GET_LOCAL_CID, to se=
t
> > the dest CID for the loopback, it works in both cases because we return=
 the
> > HOST_CID in L0, and always the guest CID in L1, also if a H2G is loaded=
 to
> > handle the L2.
> >=20
> > Maybe we should document this in the man page.
>=20
> Yeah, it seems like a good idea to flesh out the routing behavior for nes=
ted
> VMs in the man page.

I'll do it.

>=20
> >=20
> > But I have a question: Does vmci support the host loopback?
> > I've tried, and it seems not.
>=20
> Only for datagrams - not for stream sockets.
> =20

Ok, I'll leave the datagram loopback as before.

> > Also vhost-vsock doesn't support it, but virtio-vsock does.
> >=20
> > > >
> > > > Since several people asked about this feature at the KVM Forum, I w=
ould
> > like
> > > > to add a new VMADDR_CID_LOCAL (i.e. using the reserved 1) and
> > implement
> > > > loopback in the core.
> > > >
> > > > What do you think?
> > >
> > > What kind of use cases are mentioned in the KVM forum for loopback?
> > One concern
> > > is that we have to maintain yet another interprocess communication
> > mechanism,
> > > even though other choices exist already  (and those are likely to be =
more
> > efficient
> > > given the development time and specific focus that went into those). =
To
> > me, the
> > > local connections are mainly useful as a way to sanity test the proto=
col and
> > transports.
> > > However, if loopback is compelling, it would make sense have it in th=
e core,
> > since it
> > > shouldn't need a specific transport.
> >=20
> > The common use cases is for developer point of view, and to test the
> > protocol and transports as you said.
> >=20
> > People that are introducing VSOCK support in their projects, would like=
 to
> > test them on their own PC without starting a VM.
> >=20
> > The idea is to move the code to handle loopback from the virtio-vsock,
> > in the core, but in another series :-)
>=20
> OK, that makes sense.

Thanks,
Stefano

