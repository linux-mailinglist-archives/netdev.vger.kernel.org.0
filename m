Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA344E3C8D
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408334AbfJXTzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:55:02 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48047 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392889AbfJXTzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 15:55:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571946900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=46JWhWsVeq/tB0Aj5YNxoiRSmrwdl+Kq9BaeK3ujO0U=;
        b=DFyau+12Pf776Ra8ToZbfReIJM3hr50lO1EqlGKpxMWpK9hKxLtlHi8EfiH8kRtmVZdQoy
        JpVJ1IDyNc/Pr/+n55GZM09pcm0m0bUta4d7Y+ih7FqD71L+yAQS45IKjw0MPpLgdzHqOs
        uuu/uL7ZxjoMq54T7hQLBG/3061NeOg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-rQGSdyFqNNOUITf7Nv_epw-1; Thu, 24 Oct 2019 15:54:58 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85A4947B;
        Thu, 24 Oct 2019 19:54:54 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EB675D9D5;
        Thu, 24 Oct 2019 19:54:42 +0000 (UTC)
Date:   Thu, 24 Oct 2019 13:54:41 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
Subject: Re: [PATCH V5 2/6] modpost: add support for mdev class id
Message-ID: <20191024135441.160daa56@x1.home>
In-Reply-To: <555a101e-0ed1-2e9d-c1a4-e3b37d76bd18@redhat.com>
References: <20191023130752.18980-1-jasowang@redhat.com>
        <20191023130752.18980-3-jasowang@redhat.com>
        <20191023154245.32e4fa49@x1.home>
        <555a101e-0ed1-2e9d-c1a4-e3b37d76bd18@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: rQGSdyFqNNOUITf7Nv_epw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019 11:31:04 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2019/10/24 =E4=B8=8A=E5=8D=885:42, Alex Williamson wrote:
> > On Wed, 23 Oct 2019 21:07:48 +0800
> > Jason Wang <jasowang@redhat.com> wrote:
> > =20
> >> Add support to parse mdev class id table.
> >>
> >> Reviewed-by: Parav Pandit <parav@mellanox.com>
> >> Signed-off-by: Jason Wang <jasowang@redhat.com>
> >> ---
> >>   drivers/vfio/mdev/vfio_mdev.c     |  2 ++
> >>   scripts/mod/devicetable-offsets.c |  3 +++
> >>   scripts/mod/file2alias.c          | 10 ++++++++++
> >>   3 files changed, 15 insertions(+)
> >>
> >> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_md=
ev.c
> >> index 7b24ee9cb8dd..cb701cd646f0 100644
> >> --- a/drivers/vfio/mdev/vfio_mdev.c
> >> +++ b/drivers/vfio/mdev/vfio_mdev.c
> >> @@ -125,6 +125,8 @@ static const struct mdev_class_id id_table[] =3D {
> >>   =09{ 0 },
> >>   };
> >>  =20
> >> +MODULE_DEVICE_TABLE(mdev, id_table);
> >> + =20
> > Two questions, first we have:
> >
> > #define MODULE_DEVICE_TABLE(type, name)                                =
 \
> > extern typeof(name) __mod_##type##__##name##_device_table              =
 \
> >    __attribute__ ((unused, alias(__stringify(name))))
> >
> > Therefore we're defining __mod_mdev__id_table_device_table with alias
> > id_table.  When the virtio mdev bus driver is added in 5/6 it uses the
> > same name value.  I see virtio types all register this way (virtio,
> > id_table), so I assume there's no conflict, but pci types mostly (not
> > entirely) seem to use unique names.  Is there a preference to one way
> > or the other or it simply doesn't matter? =20
>=20
>=20
> It looks to me that those symbol were local, so it doesn't matter. But=20
> if you wish I can switch to use unique name.

I don't have a strong opinion, I'm just trying to make sure we're not
doing something obviously broken.

> >>   static struct mdev_driver vfio_mdev_driver =3D {
> >>   =09.name=09=3D "vfio_mdev",
> >>   =09.probe=09=3D vfio_mdev_probe,
> >> diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetab=
le-offsets.c
> >> index 054405b90ba4..6cbb1062488a 100644
> >> --- a/scripts/mod/devicetable-offsets.c
> >> +++ b/scripts/mod/devicetable-offsets.c
> >> @@ -231,5 +231,8 @@ int main(void)
> >>   =09DEVID(wmi_device_id);
> >>   =09DEVID_FIELD(wmi_device_id, guid_string);
> >>  =20
> >> +=09DEVID(mdev_class_id);
> >> +=09DEVID_FIELD(mdev_class_id, id);
> >> +
> >>   =09return 0;
> >>   }
> >> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> >> index c91eba751804..d365dfe7c718 100644
> >> --- a/scripts/mod/file2alias.c
> >> +++ b/scripts/mod/file2alias.c
> >> @@ -1335,6 +1335,15 @@ static int do_wmi_entry(const char *filename, v=
oid *symval, char *alias)
> >>   =09return 1;
> >>   }
> >>  =20
> >> +/* looks like: "mdev:cN" */
> >> +static int do_mdev_entry(const char *filename, void *symval, char *al=
ias)
> >> +{
> >> +=09DEF_FIELD(symval, mdev_class_id, id);
> >> +
> >> +=09sprintf(alias, "mdev:c%02X", id); =20
> > A lot of entries call add_wildcard() here, should we?  Sorry for the
> > basic questions, I haven't played in this code.  Thanks, =20
>=20
>=20
> It's really good question. My understanding is we won't have a module=20
> that can deal with all kinds of classes like CLASS_ID_ANY. So there's=20
> probably no need for the wildcard.

The comment for add_wildcard() indicates future extension, so it's hard
to know what we might need in the future until we do need it.  The
majority of modules.alias entries on my laptop (even if I exclude pci
aliases) end with a wildcard.  Thanks,

Alex

