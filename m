Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328286D9D5F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 18:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238265AbjDFQTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 12:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239733AbjDFQTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 12:19:06 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAA5A26D
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 09:18:48 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id d22so24055990pgw.2
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 09:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680797928; x=1683389928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3dsp4LItwMfovnFZtMzV+d0MQfzQEta6raxhBzu3aIA=;
        b=ivzXZIqC8VLKLu2raHW6fO6AdR/6OlQUm+hXLy0JRDLLd+0u6zQUxez7uAX9JSxG/Z
         oaczAljy1/G4oRCaScecoifBwS6DxdVXJAp8zJirXUNCEaPLTj1X5ylC9tW8zqzfjL8E
         13GAUgYyCFDT7R1GemOdJaTfj71zYmR+cJZKBoPHf6toNfpBVDahJ7GAFOSREhW/nVnC
         GI7JZiWNnySUESVH2BYPFjgF8C5xmUFb8y/yY4rNOWHV7M7Lq1Srche7Lbk0LdI17nJl
         /dXkRsMZ+/UNpuqxmY9dan6Ng2WicOJY12FodjkVsgUw06vdzfs3DDx0+Z+vZ9GDpR/Y
         UAHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680797928; x=1683389928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3dsp4LItwMfovnFZtMzV+d0MQfzQEta6raxhBzu3aIA=;
        b=EKTtzDKXIbszIOJVx+hTywN5ftCBqY7LFWdxPFZZPBxrSA1Lrhkg0A/W+9FkocIVeO
         HUYCqxcL3A5/g2KWgRiSzj3EHreSgxsKJ4EqTKQkJGXjEaKnmkWnkqlCx1ZaZMKR/n1G
         FnZkjc8l+NxHXkK7K83YAmQQd/J4eGfizjtMkTkJJgLr9NOXZydfxskr57j+0kT+VfNV
         G1qwEAJ1sIq8RIFYJb1AxMoGsEHwdBdEttqZbt7HrEsD1LXfB1GfIr1/3eDDyovThmMt
         zb7jRDgeMbhjloaumo3m+ug4vlKDixdHbkl2DQR6pAi7zsF+Y4d3io7YZVDnZbOLu3r6
         zx3g==
X-Gm-Message-State: AAQBX9ehSHPqM9VrK4AgySQiQ7UzuMsL1UFm+nnZblQVpvcOxWD3Inb6
        U4VF7t03SUS3K/Ac6SjzLMLtUr0CEfKlI36L99Gm2YFPJSRskg==
X-Google-Smtp-Source: AKy350b+DSf42oaNRWzEYNtZVWNNU84G9mQ9Yaufq2Q6kY2gRSh/xW4VTIGJ+e4erta5Z7vpeLoAw4w334Y7qAcT+Zs=
X-Received: by 2002:a63:fa05:0:b0:50b:eb56:b675 with SMTP id
 y5-20020a63fa05000000b0050beb56b675mr3295275pgh.7.1680797927642; Thu, 06 Apr
 2023 09:18:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230405063323.36270-1-glipus@gmail.com> <20230405094210.32c013a7@kernel.org>
 <20230405170322.epknfkxdupctg6um@skbuf> <20230405101323.067a5542@kernel.org>
 <20230405172840.onxjhr34l7jruofs@skbuf> <20230405104253.23a3f5de@kernel.org>
 <20230405180121.cefhbjlejuisywhk@skbuf> <20230405170010.1c989a8f@kernel.org>
 <CAP5jrPGzrzMYmBBT+B6U5Oh6v_Tcie1rj0KqsWOEZOBR7JBoXA@mail.gmail.com> <20230406150157.rwpmghgao77lkdny@skbuf>
In-Reply-To: <20230406150157.rwpmghgao77lkdny@skbuf>
From:   Max Georgiev <glipus@gmail.com>
Date:   Thu, 6 Apr 2023 10:18:36 -0600
Message-ID: <CAP5jrPEmZY4eGVNw+WWcmn0FdN4wXsq0x=h-9aZgX3gJYyi6XQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan code path
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 6, 2023 at 9:02=E2=80=AFAM Vladimir Oltean <vladimir.oltean@nxp=
.com> wrote:
>
> On Thu, Apr 06, 2023 at 12:21:37AM -0600, Max Georgiev wrote:
> > I tried my best to follow the discussion, and convert it to compilable =
code.
> > Here is what I have in mind for generic_hwtstamp_get_lower():
> >
> > int generic_hwtstamp_get_lower(struct net_dev *dev,
> >                            struct kernel_hwtstamp_config *kernel_cfg,
> >                            struct netlink_ext_ack *extack)
> > {
> >         const struct net_device_ops *ops =3D dev->netdev_ops;
> >         struct hwtstamp_config cfg;
> >         int err;
> >
> >         if (!netif_device_present(dev))
> >                 return -ENODEV;
> >
> >         if (ops->ndo_hwtstamp_get)
> >                 return ops->ndo_hwtstamp_get(dev, cfg, extack);
> >
> >         if (!cfg->ifr)
> >                 return -EOPNOTSUPP;
> >
> >         err =3D dev_eth_ioctl(dev, cfg->ifr, SIOCGHWTSTAMP);
> >         if (err)
> >             return err;
> >
> >         if (copy_from_user(&cfg, cfg->ifr->ifr_data, sizeof(cfg)))
> >                 return -EFAULT;
> >
> >         hwtstamp_config_to_kernel(kernel_cfg, &cfg);
> >
> >         return 0;
> > }
>
> Side note, it doesn't look like this code is particularly compilable
> either - "cfg" is used in some places instead of "kernel_cfg".

That's true, this code wouldn't compile. I copied it here to
illustrate the potentially concerning logic.
Thank you for pointing this out though!

>
> >
> > It looks like there is a possibility that the returned hwtstamp_config =
structure
> > will be copied twice to ifr and copied once from ifr on the return path
> > in case if the underlying driver does not implement ndo_hwtstamp_get():
> > - the underlying driver calls copy_to_user() inside its ndo_eth_ioctl()
> >   implementation to return the data to generic_hwtstamp_get_lower();
> > - then generic_hwtstamp_get_lower() calls copy_from_user() to copy it
> >   back out of the ifr to kernel_hwtstamp_config structure;
> > - then dev_get_hwtstamp() calls copy_to_user() again to update
> >   the same ifr with the same data the ifr already contains.
> >
> > Should we consider this acceptable?
>
> Thanks for laying this out. I guess with a table it's going to be
> clearer, so to summarize, I believe this is the status:
>
> Assuming we convert *vlan to ndo_hwtstamp_set():
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> If the vlan driver is converted to ndo_hwtstamp_set() and the real_dev
> driver uses ndo_eth_ioctl(), we have:
> - one copy_from_user() in dev_set_hwtstamp()
> - one copy_from_user() in the real_dev's ndo_eth_ioctl()
> - one copy_to_user() in the real_dev's ndo_eth_ioctl()
> - one copy_from_user() in generic_hwtstamp_get_lower()
> - one copy_to_user() in dev_set_hwtstamp()
>
> If the vlan driver is converted to ndo_hwtstamp_set() and the real_dev
> is converted too, we have:
> - one copy_from_user() in dev_set_hwtstamp()
> - one copy_to_user() in dev_set_hwtstamp()
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Assuming we don't convert *vlan to ndo_hwtstamp_set():
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> If the vlan driver isn't converted to ndo_hwtstamp_set() and the
> real_dev driver isn't converted either, we have:
> - one copy_from_user() in dev_set_hwtstamp()
> - one copy_from_user() in the real_dev's ndo_eth_ioctl()
> - one copy_to_user() in the real_dev's ndo_eth_ioctl()
>
> If the vlan driver isn't converted to ndo_hwtstamp_set(), but the
> real_dev driver is, we have:
> - one copy_from_user() in dev_set_hwtstamp()
> - one copy_from_user() in the vlan's ndo_eth_ioctl()
> - one copy_to_user() in the vlan's ndo_eth_ioctl()
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> So between converting and not converting the *vlans to ndo_hwtstamp_set()=
,
> the worst case is going to be worse (with a mix of new API in *vlan and
> old API in real_dev) and the best case is going to be better (with new
> API in both *vlan and real_dev). OTOH, with old API in *vlan, the number
> of copies to/from the user buffer is going to be constant at 3, which is
> not the best, not the worst.
>
> I guess the data indicates that we should convert the *vlans to
> ndo_hwtstamp_set() at the very end of the process, and for now, just
> make them compatible with a real_dev that uses the new API?
>
> Note that I haven't done the math for the "get" operation yet, but I
> believe it to be similar.

Thank you for putting this overhead tracking table together!

Here is my guess on how this accounting would look like
for the "get" codepath:

Assuming we convert *vlan to ndo_hwtstamp_set():

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

If the vlan driver is converted to ndo_hwtstamp_get() and the real_dev
driver uses ndo_eth_ioctl(), we have:
- one copy_to_user() in the real_dev's ndo_eth_ioctl()
- one copy_from_user() in generic_hwtstamp_get_lower()
- one copy_to_user() in dev_get_hwtstamp()

If the vlan driver is converted to ndo_hwtstamp_get() and the real_dev
is converted too, we have:
- one copy_to_user() in dev_get_hwtstamp()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Assuming we don't convert *vlan to ndo_hwtstamp_get():

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

If the vlan driver isn't converted to ndo_hwtstamp_get() and the
real_dev driver isn't converted either, we have:
- one copy_to_user() in the real_dev's ndo_eth_ioctl()

If the vlan driver isn't converted to ndo_hwtstamp_get(), but the
real_dev driver is, we have:
- one copy_to_user() in the vlan's ndo_eth_ioctl()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Adding real_dev->ndo_hwtstamp_get/set() support to vlan_eth_ioctl()
and holding back with ndo_hwtstamp_get/set() implementation in vlan
code looks like a winner again.

If I may, there are other ways to work around this inefficiency.
Since kernel_hwtstamp_config was meant to be easily extendable,
we can abuse it and add a flag field there. One of the flag values
can indicate that the operation result structure was already copied
to kernel_config->ifr by the function that received this kernel_config
instance as a parameter, and that the content of the
hwtstamp_config-related fields in kernel_config structure must
be ignored when the function returns. It would complicate the
implementation logic, but we'd avoid some unnecessary copy
operations while converting *vlan components to the newer interface.
Would it be a completely unreasonable approach?
