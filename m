Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5D85A2CB
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfF1Rwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:52:41 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45725 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfF1Rwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:52:40 -0400
Received: by mail-lj1-f195.google.com with SMTP id m23so6788479lje.12
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ACWhj+Qx5qTm5GfKMBbb00dcdp8QuPj5OuqPevNtJRk=;
        b=snAGpyjF3/zPr5L2YptZSFfBR6SZT9Lx0bauTDnqjOLOtUpogOyz75g3QEjxoueqKM
         3qxNVZOgbzIV/AYbXIdlNbh7IuYJDKsKavFqo2ap1iflII8vElO0dQfAd/9E8acJliLi
         Br7iScCbTCi5NwIvAYTF29WBhE2ZKcH2GGkxGaigiSM8LIxBmdrRM9YwJeDLVgGosQio
         08kCyRwivFoR5E0lbkqrLzVy0mtuEoiYc+G901wsulHUjoYfyi7BqObbVpnef1P8axH7
         ZJnvY2A4gt3m6Rj/g/CXFPv6xZI12sQ5+BZ2it9/MFoq3K2XLNdoI6qaKXm13iFKMNsZ
         wzxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ACWhj+Qx5qTm5GfKMBbb00dcdp8QuPj5OuqPevNtJRk=;
        b=FBbbRMODe/QFoL95hx4XBaLDlq8OPuPvLOd1WbPJRtQV1Lqxby7pD5lIHAXUQS6xdF
         ik1YJeD11/q0F7zDkUnvPLQ2GBQyLXGjDCqM+MvhFNOsyRczB6Yks0vF6YlM2qYjH8h7
         PXkXHLuIirjjUGEaxL4FKbVIcLNHuB3Yk+WJUMYlk2BlY3wkX7eVTumGscuUo08mBmjS
         WoYA4RnI4IejllyUcvhV+DIhGF2gWoL7CljywLvobEDoXoAzR/TBGsxbVszYvYKyv6xV
         47bYo1FG8BIWjGfQjmYTZ+HGSEMV7h3f9BMq8Wov042EQvtJgMha/UW+4XlgCWohgm2F
         P7Zg==
X-Gm-Message-State: APjAAAVzbor/t4yVUlMgNi1YCXudetdhYuZ4VxKWbG0fOMF0vjd6RsMo
        BrSb09E9jAn19styDDF5vRoosr3mx9I2hq8BIIhnoA==
X-Google-Smtp-Source: APXvYqw7BsKyH+kv1tLZe86PB1Jeic4z+yrsjjf2uMpP197ZhQufAkspISt9ivAFLnTUZn2xw3EY4e9Ve2EHEO28jlk=
X-Received: by 2002:a2e:124c:: with SMTP id t73mr6813300lje.190.1561744357963;
 Fri, 28 Jun 2019 10:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190626185251.205687-1-csully@google.com> <20190626185251.205687-2-csully@google.com>
 <20190626160832.3f191a53@cakuba.netronome.com>
In-Reply-To: <20190626160832.3f191a53@cakuba.netronome.com>
From:   Catherine Sullivan <csully@google.com>
Date:   Fri, 28 Jun 2019 10:52:27 -0700
Message-ID: <CAH_-1qzzWVKxDX3LaorsgYPjT5uhDgqdN3oMZtJ2p6AzDqRyXA@mail.gmail.com>
Subject: Re: [net-next 1/4] gve: Add basic driver framework for Compute Engine
 Virtual NIC
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 4:08 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 26 Jun 2019 11:52:48 -0700, Catherine Sullivan wrote:
> > Add a driver framework for the Compute Engine Virtual NIC that will be
> > available in the future.
> >
> > At this point the only functionality is loading the driver.
> >
> > Signed-off-by: Catherine Sullivan <csully@google.com>
> > Signed-off-by: Sagi Shahar <sagis@google.com>
> > Signed-off-by: Jon Olson <jonolson@google.com>
> > Acked-by: Willem de Bruijn <willemb@google.com>
> > Reviewed-by: Luigi Rizzo <lrizzo@google.com>
> > ---
>
> > +if NET_VENDOR_GOOGLE
> > +
> > +config GVE
> > +     tristate "Google Virtual NIC (gVNIC) support"
> > +     depends on (PCI_MSI && X86)
>
> We usually prefer for drivers not to depend on the platform unless
> really necessary, but IDK how that applies to the curious new world
> of NICs nobody can buy :)

This is the only platform it will ever need to run on so we would really
prefer to not have to support others :)

>
> > +     help
> > +       This driver supports Google Virtual NIC (gVNIC)"
> > +
> > +       To compile this driver as a module, choose M here.
> > +       The module will be called gve.
> > +
> > +endif #NET_VENDOR_GOOGLE
>
> > +void gve_adminq_release(struct gve_priv *priv)
> > +{
> > +     int i;
> > +
> > +     /* Tell the device the adminq is leaving */
> > +     writel(0x0, &priv->reg_bar0->adminq_pfn);
> > +     for (i = 0; i < GVE_MAX_ADMINQ_RELEASE_CHECK; i++) {
> > +             if (!readl(&priv->reg_bar0->adminq_pfn)) {
> > +                     gve_clear_device_rings_ok(priv);
> > +                     gve_clear_device_resources_ok(priv);
> > +                     gve_clear_admin_queue_ok(priv);
> > +                     return;
> > +             }
> > +             msleep(GVE_ADMINQ_SLEEP_LEN);
> > +     }
> > +     /* If this is reached the device is unrecoverable and still holding
> > +      * memory. Anything other than a BUG risks memory corruption.
> > +      */
> > +     WARN(1, "Unrecoverable platform error!");
> > +     BUG();
>
> Please don't add BUG()s to the kernel.  You're probably better off
> spinning for ever in the loop above.  Also if there is an IOMMU in
> the way the device won't be able to mess with the memory.

Ack, it will be switched to a loop that won't end in v2.

>
> > +}
> > +
>
> > diff --git a/drivers/net/ethernet/google/gve/gve_size_assert.h b/drivers/net/ethernet/google/gve/gve_size_assert.h
> > new file mode 100644
> > index 000000000000..a58422d4f16e
> > --- /dev/null
> > +++ b/drivers/net/ethernet/google/gve/gve_size_assert.h
> > @@ -0,0 +1,15 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR MIT)
> > + * Google virtual Ethernet (gve) driver
> > + *
> > + * Copyright (C) 2015-2019 Google, Inc.
> > + */
> > +
> > +#ifndef _GVE_ASSERT_H_
> > +#define _GVE_ASSERT_H_
> > +#define GVE_ASSERT_SIZE(tag, type, size) \
> > +     static void gve_assert_size_ ## type(void) __attribute__((used)); \
> > +     static inline void gve_assert_size_ ## type(void) \
> > +     { \
> > +             BUILD_BUG_ON(sizeof(tag type) != (size)); \
> > +     }
> > +#endif /* _GVE_ASSERT_H_ */
>
> Please use static_assert() directly in your struct size checks.

Thanks - that is much cleaner. Fixed in v2.
