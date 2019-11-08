Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A71F532C
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfKHSEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:04:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32153 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726641AbfKHSEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:04:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573236241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sl22NQRj4kAsua4DUcOwX07sT76ZHHw5SEevvRZzI/Q=;
        b=Qf4vWYL3EKMX5YJT9qyaiGtX+/aK2iNm/SHp6e/oRIdTWnmjVvdgDCvnRM9HBRofXqVbov
        zfUuF5U4/i3xZg7nv0lSc8KUv8CRslyhgyhH7Gf7YQcHqjFWb5y/y97aY0GU6mj6HAFRZo
        kaPPR+OKbowqsAmMkURWmJLypOUn9Tw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-QjXhEeg3NLKNk3HR3VEPxg-1; Fri, 08 Nov 2019 13:03:58 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B915E8017DD;
        Fri,  8 Nov 2019 18:03:56 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A05376084E;
        Fri,  8 Nov 2019 18:03:55 +0000 (UTC)
Date:   Fri, 8 Nov 2019 11:03:55 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Parav Pandit <parav@mellanox.com>, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, cohuck@redhat.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 09/19] vfio/mdev: Expose mdev alias in sysfs
 tree
Message-ID: <20191108110355.77128e6f@x1.home>
In-Reply-To: <20191108132230.GK6990@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-9-parav@mellanox.com>
        <20191108132230.GK6990@nanopsycho>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: QjXhEeg3NLKNk3HR3VEPxg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019 14:22:30 +0100
Jiri Pirko <jiri@resnulli.us> wrote:

> Thu, Nov 07, 2019 at 05:08:24PM CET, parav@mellanox.com wrote:
>=20
> [...]
>=20
> >=20
> >+static ssize_t alias_show(struct device *device,
> >+=09=09=09  struct device_attribute *attr, char *buf)
> >+{
> >+=09struct mdev_device *dev =3D mdev_from_dev(device);
> >+
> >+=09if (!dev->alias)
> >+=09=09return -EOPNOTSUPP;
> >+
> >+=09return sprintf(buf, "%s\n", dev->alias);
> >+}
> >+static DEVICE_ATTR_RO(alias); =20
>=20
> I wonder, rather than adding another sysfs file, why the alias can't be
> simply a symlink to the aliased mdev directory?

The user doesn't know the alias in advance, it seems problematic to
assume an arbitrarily named link is the alias.  Thanks,

Alex

> >+
> > static const struct attribute *mdev_device_attrs[] =3D {
> >+=09&dev_attr_alias.attr,
> > =09&dev_attr_remove.attr,
> > =09NULL,
> > };
> >--=20
> >2.19.2
> > =20

