Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242C4103209
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 04:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbfKTD3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 22:29:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57682 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727264AbfKTD3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 22:29:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574220551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2fznDqQ3hjbH7RQSQWp+IHz5IQOinc6XKGYw7yFaTSU=;
        b=BtdLoLvSy3c6RW3C3RzeJ80OjQB469YsGGbCY2bkLVib10Mdq92JLK6fev+y6zfoc9FKXk
        +RHiqAQx4dfAA9KsFpf5/OlZ9ihXPx8bNAcmHB927moGU9Vq3ViRngeZAeIPKT4i0yXhE+
        eqH0/8HPpmKTRZF0RqUtm/34Xgr46Lo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-smDlpc7BM8SWO0-6nOOgLw-1; Tue, 19 Nov 2019 22:29:07 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 921E7800EBE;
        Wed, 20 Nov 2019 03:29:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 846E960FC5;
        Wed, 20 Nov 2019 03:29:05 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 66F8418095FF;
        Wed, 20 Nov 2019 03:29:05 +0000 (UTC)
Date:   Tue, 19 Nov 2019 22:29:05 -0500 (EST)
From:   Jason Wang <jasowang@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Message-ID: <384616454.35622899.1574220545352.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191119191547.GL4991@ziepe.ca>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com> <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com> <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com> <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com> <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com> <20191119164632.GA4991@ziepe.ca> <20191119134822-mutt-send-email-mst@kernel.org> <20191119191547.GL4991@ziepe.ca>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
MIME-Version: 1.0
X-Originating-IP: [10.68.5.20, 10.4.195.4]
Thread-Topic: virtual-bus: Implementation of Virtual Bus
Thread-Index: KrLwWTXtsJJLy4ZvhGNSng/rRzRP6g==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: smDlpc7BM8SWO0-6nOOgLw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> On Tue, Nov 19, 2019 at 01:58:42PM -0500, Michael S. Tsirkin wrote:
> > On Tue, Nov 19, 2019 at 12:46:32PM -0400, Jason Gunthorpe wrote:
> > > As always, this is all very hard to tell without actually seeing real
> > > accelerated drivers implement this.
> > >=20
> > > Your patch series might be a bit premature in this regard.
> >=20
> > Actually drivers implementing this have been posted, haven't they?
> > See e.g. https://lwn.net/Articles/804379/
>=20
> Is that a real driver? It looks like another example quality
> thing.

I think the answer is obvious:

+static struct pci_driver ifcvf_driver =3D {
+=09.name     =3D IFCVF_DRIVER_NAME,
+=09.id_table =3D ifcvf_pci_ids,
+=09.probe    =3D ifcvf_probe,
+=09.remove   =3D ifcvf_remove,
+};

>=20
> For instance why do we need any of this if it has '#define
> IFCVF_MDEV_LIMIT 1' ?

This is just because virtio was done at VF level.

Thanks

>=20
> Surely for this HW just use vfio over the entire PCI function and be
> done with it?
>=20
> Jason
>=20
>=20

