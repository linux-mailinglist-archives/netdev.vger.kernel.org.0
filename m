Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE7E3DE891
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 10:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhHCIkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 04:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbhHCIkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 04:40:20 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA59C061764
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 01:40:09 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id p21so27996984edi.9
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 01:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CRakoksKAuPF3/d2S73RYrpu1epFEAqqfntqG1htuL4=;
        b=znB/3Myq5X4zIUS4gde9Mg9tjF1aDURQoZRlblRrqyGfbh4thbo1YaTMC3saVRKlPP
         674PLsaWG5jbekrevWBMIoUcWWthld+vntKBZb4jvxn+hlJwNqMA1fH1WSmw5KoYsi+0
         S0O2YjFpmJDAdotybDaOg8jaDusDTfgpfi7xfwxyuo/GLh4XEjfPYJRUItJxzXn4mNNo
         oKJVunX+F1ZH7M6+vhPA0Z0B3HKoIZDUl+7NUcleOOSpjexBogw+aT2kprwNAXZhGo6j
         RrhwGmeD9j3EVhN69gd7/7zGDkMHX1+M2PspnLojdVAG6o86HlgS5lmHP1mCqaqF4vtm
         hsxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CRakoksKAuPF3/d2S73RYrpu1epFEAqqfntqG1htuL4=;
        b=JyuZPBFzhXfH3lyWojnB3il3b9IkxaTz4tGnLf8bhe0/vCeapLJjlgH+7tGB8o/rEt
         /3oz5088SGZvymMc6zJC6TLKnapGs+2b4RRDdT1aqUy+bYpvIaiyCLTsf+k+oJGZwpCs
         fA1t3B2uxg1/9obQnE9VQiXHoOGIbCx7npOTBR0I+9NXC8El3bfXnNTEu6AfKtDuP/fs
         66VdxVfR/dQna+puQv7mY9Hhew4Lc/Vly/eV6D6oS61/THtvNzjNFViDy+gnuN5lqKKr
         Qjfr/TQh6n3YbRZnOeyXg6CDgIgdzkYYW4bW3WCtE0k67sF2y6uDspNZlj0D2lccjq9K
         5/pw==
X-Gm-Message-State: AOAM532c8UrVHCNm/NPCy6Kgqj8PF2S/ug/00VlRQfSAAKO1iLX2MISy
        I4vi2BXDtBv+C6bnSA3hpQAasjosJ8eOjUbJ0PnB
X-Google-Smtp-Source: ABdhPJziVMvbOy20Edn+NVtfYzb6y08nWOl2Zx+frMXDG7ucgHCSE76xDftYnLe8xR0cQVvoPf0Q/Fgl17K812vHpL0=
X-Received: by 2002:a05:6402:74f:: with SMTP id p15mr23843570edy.195.1627980007349;
 Tue, 03 Aug 2021 01:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210729073503.187-1-xieyongji@bytedance.com> <20210729073503.187-17-xieyongji@bytedance.com>
 <eab9e694-42a5-9382-b829-1b7fade8a5ab@redhat.com>
In-Reply-To: <eab9e694-42a5-9382-b829-1b7fade8a5ab@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 3 Aug 2021 16:39:56 +0800
Message-ID: <CACycT3sRewP1kfwdFCNU+=Jn1gSB1jrB7pVd-q6Mvq29R6dW4A@mail.gmail.com>
Subject: Re: [PATCH v10 16/17] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 3:30 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/7/29 =E4=B8=8B=E5=8D=883:35, Xie Yongji =E5=86=99=E9=81=93=
:
> > This VDUSE driver enables implementing software-emulated vDPA
> > devices in userspace. The vDPA device is created by
> > ioctl(VDUSE_CREATE_DEV) on /dev/vduse/control. Then a char device
> > interface (/dev/vduse/$NAME) is exported to userspace for device
> > emulation.
> >
> > In order to make the device emulation more secure, the device's
> > control path is handled in kernel. A message mechnism is introduced
> > to forward some dataplane related control messages to userspace.
> >
> > And in the data path, the DMA buffer will be mapped into userspace
> > address space through different ways depending on the vDPA bus to
> > which the vDPA device is attached. In virtio-vdpa case, the MMU-based
> > software IOTLB is used to achieve that. And in vhost-vdpa case, the
> > DMA buffer is reside in a userspace memory region which can be shared
> > to the VDUSE userspace processs via transferring the shmfd.
> >
> > For more details on VDUSE design and usage, please see the follow-on
> > Documentation commit.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
> >   drivers/vdpa/Kconfig                               |   10 +
> >   drivers/vdpa/Makefile                              |    1 +
> >   drivers/vdpa/vdpa_user/Makefile                    |    5 +
> >   drivers/vdpa/vdpa_user/vduse_dev.c                 | 1541 +++++++++++=
+++++++++
> >   include/uapi/linux/vduse.h                         |  220 +++
> >   6 files changed, 1778 insertions(+)
> >   create mode 100644 drivers/vdpa/vdpa_user/Makefile
> >   create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
> >   create mode 100644 include/uapi/linux/vduse.h
> >
> > diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Docum=
entation/userspace-api/ioctl/ioctl-number.rst
> > index 1409e40e6345..293ca3aef358 100644
> > --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> > +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> > @@ -300,6 +300,7 @@ Code  Seq#    Include File                         =
                  Comments
> >   'z'   10-4F  drivers/s390/crypto/zcrypt_api.h                        =
conflict!
> >   '|'   00-7F  linux/media.h
> >   0x80  00-1F  linux/fb.h
> > +0x81  00-1F  linux/vduse.h
> >   0x89  00-06  arch/x86/include/asm/sockios.h
> >   0x89  0B-DF  linux/sockios.h
> >   0x89  E0-EF  linux/sockios.h                                         =
SIOCPROTOPRIVATE range
> > diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> > index a503c1b2bfd9..6e23bce6433a 100644
> > --- a/drivers/vdpa/Kconfig
> > +++ b/drivers/vdpa/Kconfig
> > @@ -33,6 +33,16 @@ config VDPA_SIM_BLOCK
> >         vDPA block device simulator which terminates IO request in a
> >         memory buffer.
> >
> > +config VDPA_USER
> > +     tristate "VDUSE (vDPA Device in Userspace) support"
> > +     depends on EVENTFD && MMU && HAS_DMA
> > +     select DMA_OPS
> > +     select VHOST_IOTLB
> > +     select IOMMU_IOVA
> > +     help
> > +       With VDUSE it is possible to emulate a vDPA Device
> > +       in a userspace program.
> > +
> >   config IFCVF
> >       tristate "Intel IFC VF vDPA driver"
> >       depends on PCI_MSI
> > diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
> > index 67fe7f3d6943..f02ebed33f19 100644
> > --- a/drivers/vdpa/Makefile
> > +++ b/drivers/vdpa/Makefile
> > @@ -1,6 +1,7 @@
> >   # SPDX-License-Identifier: GPL-2.0
> >   obj-$(CONFIG_VDPA) +=3D vdpa.o
> >   obj-$(CONFIG_VDPA_SIM) +=3D vdpa_sim/
> > +obj-$(CONFIG_VDPA_USER) +=3D vdpa_user/
> >   obj-$(CONFIG_IFCVF)    +=3D ifcvf/
> >   obj-$(CONFIG_MLX5_VDPA) +=3D mlx5/
> >   obj-$(CONFIG_VP_VDPA)    +=3D virtio_pci/
> > diff --git a/drivers/vdpa/vdpa_user/Makefile b/drivers/vdpa/vdpa_user/M=
akefile
> > new file mode 100644
> > index 000000000000..260e0b26af99
> > --- /dev/null
> > +++ b/drivers/vdpa/vdpa_user/Makefile
> > @@ -0,0 +1,5 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +vduse-y :=3D vduse_dev.o iova_domain.o
> > +
> > +obj-$(CONFIG_VDPA_USER) +=3D vduse.o
> > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_use=
r/vduse_dev.c
> > new file mode 100644
> > index 000000000000..6addc62e7de6
> > --- /dev/null
> > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > @@ -0,0 +1,1541 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * VDUSE: vDPA Device in Userspace
> > + *
> > + * Copyright (C) 2020-2021 Bytedance Inc. and/or its affiliates. All r=
ights reserved.
> > + *
> > + * Author: Xie Yongji <xieyongji@bytedance.com>
> > + *
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/cdev.h>
> > +#include <linux/device.h>
> > +#include <linux/eventfd.h>
> > +#include <linux/slab.h>
> > +#include <linux/wait.h>
> > +#include <linux/dma-map-ops.h>
> > +#include <linux/poll.h>
> > +#include <linux/file.h>
> > +#include <linux/uio.h>
> > +#include <linux/vdpa.h>
> > +#include <linux/nospec.h>
> > +#include <uapi/linux/vduse.h>
> > +#include <uapi/linux/vdpa.h>
> > +#include <uapi/linux/virtio_config.h>
> > +#include <uapi/linux/virtio_ids.h>
> > +#include <uapi/linux/virtio_blk.h>
> > +#include <linux/mod_devicetable.h>
> > +
> > +#include "iova_domain.h"
> > +
> > +#define DRV_AUTHOR   "Yongji Xie <xieyongji@bytedance.com>"
> > +#define DRV_DESC     "vDPA Device in Userspace"
> > +#define DRV_LICENSE  "GPL v2"
> > +
> > +#define VDUSE_DEV_MAX (1U << MINORBITS)
> > +#define VDUSE_BOUNCE_SIZE (64 * 1024 * 1024)
> > +#define VDUSE_IOVA_SIZE (128 * 1024 * 1024)
> > +#define VDUSE_REQUEST_TIMEOUT 30
>
>
> I think we need make this as a module parameter. 0 probably means we
> need to wait for ever.
>
> This can help in the case when the userspace is attached by GDB. If
> Michael is still not happy, we can find other solution (e.g only offload
> the datapath).
>

OK, a device attribute might be better.

Thanks,
Yongji
