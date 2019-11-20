Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC75E103206
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 04:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfKTDZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 22:25:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31514 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727348AbfKTDZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 22:25:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574220304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gnzJFkYQzZLXrS7rakKLHp8MIchUy3GNK0X8yTSiLKw=;
        b=YHHIzMC7Hc5yhTPX3B2XV2ezp4neAOGDHnrYi61xm5ech2119eRIalk7WPsnNd5QxmV+Xh
        GM2FTWVBbai5yxrMilW5007vbBfdiRYwYglrbBnnJ+BW/wP8stMrFf5euilB9Nm+VSWvXG
        garnjbZjixQjnUX4FHm8bbCvxJPZmYE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-4ZHJJ5y4OfCC5tnCoyFtSg-1; Tue, 19 Nov 2019 22:25:00 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA38B180496F;
        Wed, 20 Nov 2019 03:24:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BB3B760FC5;
        Wed, 20 Nov 2019 03:24:58 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7B4CD4BB65;
        Wed, 20 Nov 2019 03:24:58 +0000 (UTC)
Date:   Tue, 19 Nov 2019 22:24:51 -0500 (EST)
From:   Jason Wang <jasowang@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Message-ID: <1655636323.35622504.1574220291482.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191119164632.GA4991@ziepe.ca>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com> <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com> <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com> <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com> <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com> <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com> <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com> <20191119164632.GA4991@ziepe.ca>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
MIME-Version: 1.0
X-Originating-IP: [10.68.5.20, 10.4.195.21]
Thread-Topic: virtual-bus: Implementation of Virtual Bus
Thread-Index: PY6mRN7cE/SzrGkgwT22KgxjMQGbiQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 4ZHJJ5y4OfCC5tnCoyFtSg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> On Tue, Nov 19, 2019 at 03:37:03PM +0800, Jason Wang wrote:
>=20
> > > Jiri, Jason, me think that even virtio accelerated devices will need
> > > eswitch support. And hence, life cycling virtio accelerated devices v=
ia
> > > devlink makes a lot of sense to us.
> > > This way user has single tool to choose what type of device he want t=
o
> > > use (similar to ip link add link type).
> > > So sub function flavour will be something like (virtio or sf).
> >=20
> > Networking is only one of the types that is supported in virtio-mdev. T=
he
> > codes are generic enough to support any kind of virtio device (block, s=
csi,
> > crypto etc). Sysfs is less flexible but type independent. I agree that
> > devlink is standard and feature richer but still network specific. It's
> > probably hard to add devlink to other type of physical drivers. I'm
> > thinking
> > whether it's possible to combine syfs and devlink: e.g the mdev is
> > available
> > only after the sub fuction is created and fully configured by devlink.
>=20
> The driver providing the virtio should really be in control of the
> life cycle policy. For net related virtio that is clearly devlink.

As replied in another thread, there were already existed devices
(Intel IFC VF) that doesn't use devlink.

>=20
> Even for block we may find that network storage providers (ie some
> HW accelerated virtio-blk-over-ethernet) will want to use devlink to
> create a combination ethernet and accelerated virtio-block widget.
>=20
>

Note, there's already commercial virtio-blk done at PF level provided
by Ali ECS instance. So it's looks pretty clear to me it's almost
impossible to have every vendors to use devlink. Tie virtio soluton to
devlink seems a burden and actually devlink doesn't conflict with the
simple sysfs interface.

Thanks

