Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7631031E6
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 04:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfKTDPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 22:15:37 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39124 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727264AbfKTDPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 22:15:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574219735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pYSQR6cjfnJIT1vfOCF2hDFIXTDQo109Z4Iwx+wsbqg=;
        b=Ujlj+Ni7VDAuKijC0pEcmciWFKr4B2SQHT/Gn00cwc0HpA0Ns4yFq80TCxI45yz2mmCDOh
        kzu79gtk8MqcViF8U112J/6tXnzuxNmL4yn9BKWG+4JwNJbn49h7ONWOEXqj5qXXcuyh/z
        GeqmkYMgMAbO6tIqmg4Xj8lIjfvDto8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-74XahVNiPoyJ0BajaFUarQ-1; Tue, 19 Nov 2019 22:15:31 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 263A21883522;
        Wed, 20 Nov 2019 03:15:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C22066D43;
        Wed, 20 Nov 2019 03:15:30 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id AC24C4BB5B;
        Wed, 20 Nov 2019 03:15:29 +0000 (UTC)
Date:   Tue, 19 Nov 2019 22:15:28 -0500 (EST)
From:   Jason Wang <jasowang@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org, Dave Ertman <david.m.ertman@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Message-ID: <743601510.35622214.1574219728585.JavaMail.zimbra@redhat.com>
In-Reply-To: <AM0PR05MB486605742430D120769F6C45D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com> <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com> <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com> <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com> <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com> <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com> <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com> <AM0PR05MB486605742430D120769F6C45D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
MIME-Version: 1.0
X-Originating-IP: [10.68.5.20, 10.4.195.3]
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATItanP+SK9PEuJkGaYy2/dTKeM1NrAgAURC4CAAAcf0IAAJnyAgAAC1aCAAAnmgIAAf31QXxyMZiM=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 74XahVNiPoyJ0BajaFUarQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
>=20
>=20
> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Tuesday, November 19, 2019 1:37 AM
> >=20
> > On 2019/11/19 =E4=B8=8B=E5=8D=883:13, Parav Pandit wrote:
> > >> From: Jason Wang <jasowang@redhat.com>
> > >> Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtua=
l
> > >> Bus
> > >>
> > >>
> > > [..]
> > >
> > >> Probably, for virtio mdev we need more than just matching: life cycl=
e
> > >> management, cooperation with VFIO and we also want to be prepared fo=
r
> > >> the device slicing (like sub functions).
> > > Well I am revising my patches to life cycle sub functions via devlink
> > > interface for few reasons, as
> > >
> > > (a) avoid mdev bus abuse (still named as mdev in your v13 series,
> > > though it is actually for vfio-mdev)
> >=20
> >=20
> > Yes, but it could be simply renamed to "vfio-mdev".
> >=20
> >=20
> > > (b) support iommu
> >=20
> >=20
> > That is already supported by mdev.
> >=20
> >=20
> > > (c) manage and have coupling with devlink eswitch framework, which is
> > > very rich in several aspects
> >=20
> >=20
> > Good point.
> >=20
> >=20
> > > (d) get rid of limited sysfs interface for mdev creation, as netlink =
is
> > standard and flexible to add params etc.
> >=20
> >=20
> > Standard but net specific.
> >=20
> >=20
> > >
> > > If you want to get a glimpse of old RFC work of my revised series, pl=
ease
> > refer to [1].
> >=20
> >=20
> > Will do.
> >=20
> >=20
> > >
> > > Jiri, Jason, me think that even virtio accelerated devices will need
> > > eswitch
> > support. And hence, life cycling virtio accelerated devices via devlink
> > makes a
> > lot of sense to us.
> > > This way user has single tool to choose what type of device he want t=
o
> > > use
> > (similar to ip link add link type).
> > > So sub function flavour will be something like (virtio or sf).
> >=20
> >=20
> > Networking is only one of the types that is supported in virtio-mdev.
> > The codes are generic enough to support any kind of virtio device (bloc=
k,
> > scsi, crypto etc). Sysfs is less flexible but type independent.
> > I agree that devlink is standard and feature richer but still network
> > specific.
> > It's probably hard to add devlink to other type of physical drivers. I'=
m
> > thinking whether it's possible to combine syfs and devlink:
> > e.g the mdev is available only after the sub fuction is created and ful=
ly
> > configured by devlink.
> >=20
>=20
> Nop. Devlink is NOT net specific. It works at the bus/device level.
> Any block/scsi/crypto can register devlink instance and implement the
> necessary ops as long as device has bus.
>=20

Well, uapi/linux/devlink.h told me:

"
 * include/uapi/linux/devlink.h - Network physical device Netlink interface
"

And the userspace tool was packaged into iproute2, the command was
named as "TC", "PORT", "ESWITCH". All of those were strong hints that it
was network specific. Even for networking, only few vendors choose to
implement this.

So technically it could be extended but how hard it can be achieved in
reality?

I still don't see why devlink is conflicted with GUID/sysfs, you can
hook sysfs events to devlink or do post or pre configuration through
devlink. This is much more easier than forcing all vendors to use
devlink.

Thanks

