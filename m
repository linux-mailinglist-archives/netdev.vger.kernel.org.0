Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1612FE258F
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 23:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407590AbfJWVnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 17:43:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59901 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407584AbfJWVnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 17:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571866999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6hpFFnPZykrPqLg3oDhEyOYsEg/U+o2e+slzG/d5mzQ=;
        b=DJEOMJibX2fUf5gJXlnPKMitVY1S6TNQdFMHFd/vJeuwuoMeA9j3ExrFAfNFh56HXXddej
        ChzMR5LH/ARdQAo5xirDggDrSFXbp1KA6v6tR5HQaw0CJpTVbbxJqRPq+akSbIEU3rNQMc
        uweQ71rN2q8lWbss9ryEQ0rtvd9qYkY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-O4PFHJpqNaaC_G9ArySt4g-1; Wed, 23 Oct 2019 17:43:15 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEBC01800D6B;
        Wed, 23 Oct 2019 21:43:11 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0666F5D6D0;
        Wed, 23 Oct 2019 21:42:45 +0000 (UTC)
Date:   Wed, 23 Oct 2019 15:42:45 -0600
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
Message-ID: <20191023154245.32e4fa49@x1.home>
In-Reply-To: <20191023130752.18980-3-jasowang@redhat.com>
References: <20191023130752.18980-1-jasowang@redhat.com>
        <20191023130752.18980-3-jasowang@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: O4PFHJpqNaaC_G9ArySt4g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Oct 2019 21:07:48 +0800
Jason Wang <jasowang@redhat.com> wrote:

> Add support to parse mdev class id table.
>=20
> Reviewed-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vfio/mdev/vfio_mdev.c     |  2 ++
>  scripts/mod/devicetable-offsets.c |  3 +++
>  scripts/mod/file2alias.c          | 10 ++++++++++
>  3 files changed, 15 insertions(+)
>=20
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.=
c
> index 7b24ee9cb8dd..cb701cd646f0 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -125,6 +125,8 @@ static const struct mdev_class_id id_table[] =3D {
>  =09{ 0 },
>  };
> =20
> +MODULE_DEVICE_TABLE(mdev, id_table);
> +

Two questions, first we have:

#define MODULE_DEVICE_TABLE(type, name)                                 \
extern typeof(name) __mod_##type##__##name##_device_table               \
  __attribute__ ((unused, alias(__stringify(name))))

Therefore we're defining __mod_mdev__id_table_device_table with alias
id_table.  When the virtio mdev bus driver is added in 5/6 it uses the
same name value.  I see virtio types all register this way (virtio,
id_table), so I assume there's no conflict, but pci types mostly (not
entirely) seem to use unique names.  Is there a preference to one way
or the other or it simply doesn't matter?

>  static struct mdev_driver vfio_mdev_driver =3D {
>  =09.name=09=3D "vfio_mdev",
>  =09.probe=09=3D vfio_mdev_probe,
> diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-=
offsets.c
> index 054405b90ba4..6cbb1062488a 100644
> --- a/scripts/mod/devicetable-offsets.c
> +++ b/scripts/mod/devicetable-offsets.c
> @@ -231,5 +231,8 @@ int main(void)
>  =09DEVID(wmi_device_id);
>  =09DEVID_FIELD(wmi_device_id, guid_string);
> =20
> +=09DEVID(mdev_class_id);
> +=09DEVID_FIELD(mdev_class_id, id);
> +
>  =09return 0;
>  }
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index c91eba751804..d365dfe7c718 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -1335,6 +1335,15 @@ static int do_wmi_entry(const char *filename, void=
 *symval, char *alias)
>  =09return 1;
>  }
> =20
> +/* looks like: "mdev:cN" */
> +static int do_mdev_entry(const char *filename, void *symval, char *alias=
)
> +{
> +=09DEF_FIELD(symval, mdev_class_id, id);
> +
> +=09sprintf(alias, "mdev:c%02X", id);

A lot of entries call add_wildcard() here, should we?  Sorry for the
basic questions, I haven't played in this code.  Thanks,

Alex

> +=09return 1;
> +}
> +
>  /* Does namelen bytes of name exactly match the symbol? */
>  static bool sym_is(const char *name, unsigned namelen, const char *symbo=
l)
>  {
> @@ -1407,6 +1416,7 @@ static const struct devtable devtable[] =3D {
>  =09{"typec", SIZE_typec_device_id, do_typec_entry},
>  =09{"tee", SIZE_tee_client_device_id, do_tee_entry},
>  =09{"wmi", SIZE_wmi_device_id, do_wmi_entry},
> +=09{"mdev", SIZE_mdev_class_id, do_mdev_entry},
>  };
> =20
>  /* Create MODULE_ALIAS() statements.

