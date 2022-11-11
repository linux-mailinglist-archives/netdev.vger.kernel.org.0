Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D658D625462
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 08:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbiKKHSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 02:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbiKKHSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 02:18:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6102478308
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 23:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668151048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4QndAHwF5T4cRP2zHP2BYS+XxR0b4XY/sv0eiTHsSwQ=;
        b=ZXlqm5LLxsELKDGPvnpWP4VRa2sqaw1Gnunco28jXd59ThOz8Ap2ugAV10fcwmhL9mcdAS
        B0TrkP2255FzKqfGF+zNjNhKA6F4l5YVpNB3bwRIRg9yr4hBZnjpdz2LJW6gLVp+qTQk6a
        i3IBLXxU+BmCw/7CvfswE2j0Pphh3hc=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-672-1sVyMgrwOBC98FpXC5A0FA-1; Fri, 11 Nov 2022 02:17:27 -0500
X-MC-Unique: 1sVyMgrwOBC98FpXC5A0FA-1
Received: by mail-oo1-f69.google.com with SMTP id k13-20020a4adfad000000b0049f0c8d234bso1353503ook.11
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 23:17:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4QndAHwF5T4cRP2zHP2BYS+XxR0b4XY/sv0eiTHsSwQ=;
        b=afW00i7KDkeOD7WRi+SP82Zak3Qh+g17yghkPQoBEG3+GMoI6TzecL8zUx1Ez6WZaN
         7MiKVMDR/eyt5r8u//B3yYvvaj1U8ttX7gic4MZsXqPLQ6gNIkyLn+7zysbKzZ+YMVCK
         aNrOf3zu8fIBbMB4TCzGSjJ0uDtd6YdjWEIAHjp50+iShV63h4G6uqi8M181nmukX+4w
         GtK3KfDDi7oM7/nf1tLVDoGbUvNxT7bkMo+zYb7LgGK+BfrOZZbHhLoO7KVVd8onH2dF
         UYb5sEOpTyUxhMZYdBXf+KDufPJ9T8jC6iHaPImPh9VuOUs7CdKe7degYEOMFEbNEkWa
         6CHw==
X-Gm-Message-State: ANoB5pkRmuUh6zMHDGYl0FTPygXc4Zln0WFxKK3Ixk/qKCGlgVz5I8UX
        QSqCebrB6oefixBSO2OOjbV21JAMelpavJbT/WL/EIemTpAM1+4rQZ+ptF/PSKGiSvYJRStyaVC
        2Giq9P16GR3tC6ioOx++xcs5Vab5futKG
X-Received: by 2002:a05:6830:124d:b0:66c:64d6:1bb4 with SMTP id s13-20020a056830124d00b0066c64d61bb4mr633596otp.201.1668151046375;
        Thu, 10 Nov 2022 23:17:26 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7ZEx6mPdq+HYSFhWhFwD1Xr1pcZlFnjwz9gp+GBxZsQYEu0r/sKobQ2o5tt/vsUeaP6ytP0eDsJUY4bZUhzVc=
X-Received: by 2002:a05:6830:124d:b0:66c:64d6:1bb4 with SMTP id
 s13-20020a056830124d00b0066c64d61bb4mr633591otp.201.1668151046080; Thu, 10
 Nov 2022 23:17:26 -0800 (PST)
MIME-Version: 1.0
References: <20221110075821.3818-1-jasowang@redhat.com> <20221110055242-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221110055242-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 11 Nov 2022 15:17:14 +0800
Message-ID: <CACGkMEusb5NYi8ZTR-fovDku7n+As=HWitM+kx4CW10=oC87cQ@mail.gmail.com>
Subject: Re: [PATCH] vdpa: allow provisioning device features
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, si-wei.liu@oracle.com,
        eperezma@redhat.com, lingshan.zhu@intel.com, elic@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 7:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Nov 10, 2022 at 03:58:21PM +0800, Jason Wang wrote:
> > This patch allows device features to be provisioned via vdpa. This
> > will be useful for preserving migration compatibility between source
> > and destination:
> >
> > # vdpa dev add name dev1 mgmtdev pci/0000:02:00.0 device_features 0x300020000
> > # dev1: mac 52:54:00:12:34:56 link up link_announce false mtu 65535
> >       negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM
> >
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  man/man8/vdpa-dev.8            | 10 ++++++++++
> >  vdpa/include/uapi/linux/vdpa.h |  1 +
> >  vdpa/vdpa.c                    | 27 ++++++++++++++++++++++++++-
> >  3 files changed, 37 insertions(+), 1 deletion(-)
> >
> > diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
> > index 9faf3838..bb45b4a6 100644
> > --- a/man/man8/vdpa-dev.8
> > +++ b/man/man8/vdpa-dev.8
> > @@ -31,6 +31,7 @@ vdpa-dev \- vdpa device configuration
> >  .I NAME
> >  .B mgmtdev
> >  .I MGMTDEV
> > +.RI "[ device_features " DEVICE_FEATURES " ]"
> >  .RI "[ mac " MACADDR " ]"
> >  .RI "[ mtu " MTU " ]"
> >  .RI "[ max_vqp " MAX_VQ_PAIRS " ]"
> > @@ -74,6 +75,10 @@ Name of the new vdpa device to add.
> >  Name of the management device to use for device addition.
> >
> >  .PP
> > +.BI device_features " DEVICE_FEAETURES"
>
> typo

Will fix.

>
> > +- specifies the device features that is provisioned for the new vdpa device.
>
> I propose
>          the device features -> the virtio "device features" bit-mask
>
> features sounds like it's a generic thing, here's it's
> the actual binary
>
> and maybe add "the bits can be found under include/uapi/linux/virtio*h,
> see macros such as VIRTIO_F_ and VIRTIO_NET_F_ for specific bit values"

That's fine.

>
> > +This is optional.
> > +
>
> and if not given what are the features?

As in the past, determined by the parent/mgmt device, do we need to
document this?

>
> >  .BI mac " MACADDR"
> >  - specifies the mac address for the new vdpa device.
> >  This is applicable only for the network type of vdpa device. This is optional.
> > @@ -127,6 +132,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net
> >  Add the vdpa device named foo on the management device vdpa_sim_net.
> >  .RE
> >  .PP
> > +vdpa dev add name foo mgmtdev vdpa_sim_net device_features 0x300020000
> > +.RS 4
> > +Add the vdpa device named foo on the management device vdpa_sim_net with device_features of 0x300020000
> > +.RE
> > +.PP
> >  vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55
> >  .RS 4
> >  Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55.
> > diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> > index 94e4dad1..7c961991 100644
> > --- a/vdpa/include/uapi/linux/vdpa.h
> > +++ b/vdpa/include/uapi/linux/vdpa.h
> > @@ -51,6 +51,7 @@ enum vdpa_attr {
> >       VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
> >       VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
> >       VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
> > +     VDPA_ATTR_DEV_FEATURES,                 /* u64 */
> >
> >       /* new attributes must be added above here */
> >       VDPA_ATTR_MAX,
> > diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> > index b73e40b4..9a866d61 100644
> > --- a/vdpa/vdpa.c
> > +++ b/vdpa/vdpa.c
> > @@ -27,6 +27,7 @@
> >  #define VDPA_OPT_VDEV_MTU            BIT(5)
> >  #define VDPA_OPT_MAX_VQP             BIT(6)
> >  #define VDPA_OPT_QUEUE_INDEX         BIT(7)
> > +#define VDPA_OPT_VDEV_FEATURES               BIT(8)
> >
> >  struct vdpa_opts {
> >       uint64_t present; /* flags of present items */
> > @@ -38,6 +39,7 @@ struct vdpa_opts {
> >       uint16_t mtu;
> >       uint16_t max_vqp;
> >       uint32_t queue_idx;
> > +     __u64 device_features;
> >  };
> >
> >  struct vdpa {
>
> why __u and not uint here?

That's possible, will do.

>
> > @@ -187,6 +189,17 @@ static int vdpa_argv_u32(struct vdpa *vdpa, int argc, char **argv,
> >       return get_u32(result, *argv, 10);
> >  }
> >
> > +static int vdpa_argv_u64_hex(struct vdpa *vdpa, int argc, char **argv,
> > +                          __u64 *result)
> > +{
> > +     if (argc <= 0 || !*argv) {
> > +             fprintf(stderr, "number expected\n");
> > +             return -EINVAL;
> > +     }
> > +
> > +     return get_u64(result, *argv, 16);
> > +}
> > +
> >  struct vdpa_args_metadata {
> >       uint64_t o_flag;
> >       const char *err_msg;
> > @@ -244,6 +257,10 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
> >               mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
> >       if (opts->present & VDPA_OPT_QUEUE_INDEX)
> >               mnl_attr_put_u32(nlh, VDPA_ATTR_DEV_QUEUE_INDEX, opts->queue_idx);
> > +     if (opts->present & VDPA_OPT_VDEV_FEATURES) {
> > +             mnl_attr_put_u64(nlh, VDPA_ATTR_DEV_FEATURES,
> > +                             opts->device_features);
> > +     }
> >  }
> >
> >  static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> > @@ -329,6 +346,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> >
> >                       NEXT_ARG_FWD();
> >                       o_found |= VDPA_OPT_QUEUE_INDEX;
> > +             } else if (!strcmp(*argv, "device_features") &&
> > +                        (o_optional & VDPA_OPT_VDEV_FEATURES)) {
> > +                     NEXT_ARG_FWD();
> > +                     err = vdpa_argv_u64_hex(vdpa, argc, argv,
> > +                                             &opts->device_features);
> > +                     if (err)
> > +                             return err;
> > +                     o_found |= VDPA_OPT_VDEV_FEATURES;
> >               } else {
> >                       fprintf(stderr, "Unknown option \"%s\"\n", *argv);
> >                       return -EINVAL;
>
>
> should not we validate the value we get? e.g. a mac feature
> requires that mac is supplied, etc.

This isn't an "issue" that is introduced by this patch. Management
device is free to give _F_MAC even if the mac address is not
provisioned by the userspace. So this should be the responsibility of
the parent not the netlink/vdpa tool.

> in fact hex isn't very user friendly. why not pass feature
> names instead?

This can be added on top if necessary. In fact there's a plan to
accept JSON files for provisioning.

The advantages of hex is we don't need to keep the name  synced with
the new features.

Thanks

>
>
>
> > @@ -708,7 +733,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
> >       err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
> >                                 VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
> >                                 VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
> > -                               VDPA_OPT_MAX_VQP);
> > +                               VDPA_OPT_MAX_VQP | VDPA_OPT_VDEV_FEATURES);
> >       if (err)
> >               return err;
> >
> > --
> > 2.25.1
>

