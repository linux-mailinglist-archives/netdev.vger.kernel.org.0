Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211CC102E41
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 22:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfKSVdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 16:33:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38141 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726911AbfKSVdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 16:33:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574199230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uzn/F6dkuZ9Ul0rBb+0x2RB8yfihEGhX4QU9TcC33WI=;
        b=YiXFBgQted46foRmzTALJ2SxGDab7E8tI5ZI+8Rn9R0nQuRagCZSL0hDSd0q07hmSB/jBw
        PQv3wlYc7kuazKPzlj+P9+/CRWKDiVlY3zY7knraMvoE+Vo34n2evHTT3RVvJ2PqU9+OS4
        +FeOCYAtK6T3DMhVVM9UULEXRNJbjZE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-X-dgljZOPuuTO7br5uhZ7Q-1; Tue, 19 Nov 2019 16:33:49 -0500
Received: by mail-qv1-f72.google.com with SMTP id i32so15608094qvi.21
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 13:33:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=70cTiFQFsoR4WQjbXUzAh94mN99XWcHyHcMWXWuCRks=;
        b=LrflyRIq3fUAtOclwRJC0c96tmqT4jdYUgbt4QNPJUW7hlhQIIqSI8vCWzZrRqd5U9
         DSfIpvsw7eMnUPJfmutDkruhpzPEJcrSrh7Pfvd42z4n9o63zeVVJFjp/GXzI54sSHqi
         vnKEF/DZRptLMlzCJgHTTVF1XFBJfeEW/E6CH3bc6Kx+fzIPYXKNEVo4VEE6J3tHMj5N
         0EG6juBbX5zFduEI0+NtlhZBzYdvvAKr0B1/Qy09EUibO1rX7798a31vHfz7/98ppWRT
         9VNVAlhRQ2Gcx/DtdqaPIxgIH6IlPI8my8TiE9nhXauPF+X8Ax/ASKulw5SAy/7k94JX
         REEQ==
X-Gm-Message-State: APjAAAV1TEAEuMnAp6uR37Pe0I4t9+1U63dlKyhpzZGiFymjrlkLiC1s
        RScRzDQGq6+xzykj53+MhK4KvkUrCQKt43pQO6S1Qd56xnbgPSiG0ABrCtgajxMFwQKiggfFbtX
        YWxYV/Gum6j7Z2+Dh
X-Received: by 2002:a0c:dd01:: with SMTP id u1mr33153411qvk.69.1574199229081;
        Tue, 19 Nov 2019 13:33:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqwYGDeT1VCbLJVCTcgAiVh5jz+hDXmOSWm/2udH9NytTu9JOmh7DLTDTu1hmZf5Pk67w5vB4g==
X-Received: by 2002:a0c:dd01:: with SMTP id u1mr33153388qvk.69.1574199228792;
        Tue, 19 Nov 2019 13:33:48 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id b3sm10201658qkl.88.2019.11.19.13.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 13:33:47 -0800 (PST)
Date:   Tue, 19 Nov 2019 16:33:40 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Bie, Tiwei" <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191119163147-mutt-send-email-mst@kernel.org>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
 <20191119164632.GA4991@ziepe.ca>
 <20191119134822-mutt-send-email-mst@kernel.org>
 <20191119191547.GL4991@ziepe.ca>
MIME-Version: 1.0
In-Reply-To: <20191119191547.GL4991@ziepe.ca>
X-MC-Unique: X-dgljZOPuuTO7br5uhZ7Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 03:15:47PM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 19, 2019 at 01:58:42PM -0500, Michael S. Tsirkin wrote:
> > On Tue, Nov 19, 2019 at 12:46:32PM -0400, Jason Gunthorpe wrote:
> > > As always, this is all very hard to tell without actually seeing real
> > > accelerated drivers implement this.=20
> > >=20
> > > Your patch series might be a bit premature in this regard.
> >=20
> > Actually drivers implementing this have been posted, haven't they?
> > See e.g. https://lwn.net/Articles/804379/
>=20
> Is that a real driver? It looks like another example quality
> thing.=20
>=20
> For instance why do we need any of this if it has '#define
> IFCVF_MDEV_LIMIT 1' ?
>=20
> Surely for this HW just use vfio over the entire PCI function and be
> done with it?
>=20
> Jason

What this does is allow using it with unmodified virtio drivers within gues=
ts.
You won't get this with passthrough as it only implements parts of
virtio in hardware.

--=20
MST

