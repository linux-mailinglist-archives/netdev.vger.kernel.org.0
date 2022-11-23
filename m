Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E017F634E62
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 04:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbiKWDgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 22:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235607AbiKWDgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 22:36:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F4ADA4F2
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 19:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669174527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7cHjQsdE8aSnVqbsiao1ZG5uoGuMImMKpW9iuQFfIzk=;
        b=OJwmuLnT9lI81Li6QAHyRGkXYunLuj2/kEy9cawhT2cMd39y7d7k4aWS78FQPQjn7owF1v
        p0streab2U04mtXpIsUE4J43Dw4PnZ3DoMrNT1vWe86xXedTGfzXMACx1EagHyC/3+vDbM
        slPhwuOBLMVRpr9VBbTwIxh9LebeDGM=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-425-IX5YneuTPq6cJijQ0EGXrw-1; Tue, 22 Nov 2022 22:35:25 -0500
X-MC-Unique: IX5YneuTPq6cJijQ0EGXrw-1
Received: by mail-oo1-f70.google.com with SMTP id y19-20020a4a9c13000000b0049dd7ad41c4so7152974ooj.3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 19:35:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7cHjQsdE8aSnVqbsiao1ZG5uoGuMImMKpW9iuQFfIzk=;
        b=kwAEzXt3iH9lamTkrFIejlTQrQcuXkKg9fdZl6Rd63eNY2S2L8bxVdegw2yy+fZMn2
         l0RKy/iPW4mXm5+J+0L/Iy3g9TLgSUFYN9cV6JO4LrEmMocr85fjsFB5ikczfU51vH7c
         d7jsPV1CFC+N42NrUfJYOfAkAz8M7RNVuQjKMf/X7Z6plC8vQVCnJH7MNqJx/iGj3sp8
         coDIecoLyFNCX24SxuiX5jLfVU6Ag6afNiOYsj2Ww43b65B3FedzCNEZfuf5S+JTMMXg
         d0Lgudf+7Q0GWPGnDUS/a2m5JgYVLvDuHsVGjOlcfmFOPZSStz9nyn+jZEzlNot55Umw
         q5mA==
X-Gm-Message-State: ANoB5plJxZ/GfLUS/UleWzJ8f34sypf6Ui4pzug5iNE1UZY6pElxPuyp
        /D71ctjgyeqSEWtxvshkHQVCaofMWCLRT56/10uPucwejeyOodXG61NmgJFEoA4xaT29d4R3FDf
        +6PLhztnw3JPrpWdVFKwXJwbz34YMMlTA
X-Received: by 2002:a05:6870:1e83:b0:132:7b3:29ac with SMTP id pb3-20020a0568701e8300b0013207b329acmr4896876oab.35.1669174525017;
        Tue, 22 Nov 2022 19:35:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5BF59668XsgotVKSLGTSBJqlyXOsTZrMKRKPhmrrL3zuH98okkVaX3mm5eNN5Vp8oFgnUIo61H5DRaNknVU/k=
X-Received: by 2002:a05:6870:1e83:b0:132:7b3:29ac with SMTP id
 pb3-20020a0568701e8300b0013207b329acmr4896867oab.35.1669174524760; Tue, 22
 Nov 2022 19:35:24 -0800 (PST)
MIME-Version: 1.0
References: <20221117033303.16870-1-jasowang@redhat.com> <84298552-08ec-fe2d-d996-d89918c7fddf@oracle.com>
In-Reply-To: <84298552-08ec-fe2d-d996-d89918c7fddf@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 23 Nov 2022 11:35:13 +0800
Message-ID: <CACGkMEtLFTrqdb=MXKovP8gZzTXzFczQSmK0PgzXQTr0Dbr5jA@mail.gmail.com>
Subject: Re: [PATCH V2] vdpa: allow provisioning device features
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
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

On Wed, Nov 23, 2022 at 6:29 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>
>
>
> On 11/16/2022 7:33 PM, Jason Wang wrote:
> > This patch allows device features to be provisioned via vdpa. This
> > will be useful for preserving migration compatibility between source
> > and destination:
> >
> > # vdpa dev add name dev1 mgmtdev pci/0000:02:00.0 device_features 0x300020000
> Miss the actual "vdpa dev config show" command below

Right, let me fix that.

> > # dev1: mac 52:54:00:12:34:56 link up link_announce false mtu 65535
> >        negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM
> >
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> > Changes since v1:
> > - Use uint64_t instead of __u64 for device_features
> > - Fix typos and tweak the manpage
> > - Add device_features to the help text
> > ---
> >   man/man8/vdpa-dev.8            | 15 +++++++++++++++
> >   vdpa/include/uapi/linux/vdpa.h |  1 +
> >   vdpa/vdpa.c                    | 32 +++++++++++++++++++++++++++++---
> >   3 files changed, 45 insertions(+), 3 deletions(-)
> >
> > diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
> > index 9faf3838..43e5bf48 100644
> > --- a/man/man8/vdpa-dev.8
> > +++ b/man/man8/vdpa-dev.8
> > @@ -31,6 +31,7 @@ vdpa-dev \- vdpa device configuration
> >   .I NAME
> >   .B mgmtdev
> >   .I MGMTDEV
> > +.RI "[ device_features " DEVICE_FEATURES " ]"
> >   .RI "[ mac " MACADDR " ]"
> >   .RI "[ mtu " MTU " ]"
> >   .RI "[ max_vqp " MAX_VQ_PAIRS " ]"
> > @@ -74,6 +75,15 @@ Name of the new vdpa device to add.
> >   Name of the management device to use for device addition.
> >
> >   .PP
> > +.BI device_features " DEVICE_FEATURES"
> > +Specifies the virtio device features bit-mask that is provisioned for the new vdpa device.
> > +
> > +The bits can be found under include/uapi/linux/virtio*h.
> > +
> > +see macros such as VIRTIO_F_ and VIRTIO_XXX(e.g NET)_F_ for specific bit values.
> > +
> > +This is optional.
> Document the behavior when this attribute is missing? For e.g. inherit
> device features from parent device.

This is the current behaviour but unless we've found a way to mandate
it, I'd like to not mention it. Maybe add a description to say the
user needs to check the features after the add if features are not
specified.

>
> And what is the expected behavior when feature bit mask is off but the
> corresponding config attr (for e.g. mac, mtu, and max_vqp) is set?

It depends totally on the parent. And this "issue" is not introduced
by this feature. Parents can decide to provision MQ by itself even if
max_vqp is not specified.

> I
> think the previous behavior without device_features is that any config
> attr implies the presence of the specific corresponding feature (_F_MAC,
> _F_MTU, and _F_MQ). Should device_features override the other config
> attribute, or such combination is considered invalid thus should fail?

It follows the current policy, e.g if the parent doesn't support
_F_MQ, we can neither provision _F_MQ nor max_vqp.

Thanks

>
> Thanks,
> -Siwei
>
> > +
> >   .BI mac " MACADDR"
> >   - specifies the mac address for the new vdpa device.
> >   This is applicable only for the network type of vdpa device. This is optional.
> > @@ -127,6 +137,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net
> >   Add the vdpa device named foo on the management device vdpa_sim_net.
> >   .RE
> >   .PP
> > +vdpa dev add name foo mgmtdev vdpa_sim_net device_features 0x300020000
> > +.RS 4
> > +Add the vdpa device named foo on the management device vdpa_sim_net with device_features of 0x300020000
> > +.RE
> > +.PP
> >   vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55
> >   .RS 4
> >   Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55.
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
> > index b73e40b4..d0ce5e22 100644
> > --- a/vdpa/vdpa.c
> > +++ b/vdpa/vdpa.c
> > @@ -27,6 +27,7 @@
> >   #define VDPA_OPT_VDEV_MTU           BIT(5)
> >   #define VDPA_OPT_MAX_VQP            BIT(6)
> >   #define VDPA_OPT_QUEUE_INDEX                BIT(7)
> > +#define VDPA_OPT_VDEV_FEATURES               BIT(8)
> >
> >   struct vdpa_opts {
> >       uint64_t present; /* flags of present items */
> > @@ -38,6 +39,7 @@ struct vdpa_opts {
> >       uint16_t mtu;
> >       uint16_t max_vqp;
> >       uint32_t queue_idx;
> > +     uint64_t device_features;
> >   };
> >
> >   struct vdpa {
> > @@ -187,6 +189,17 @@ static int vdpa_argv_u32(struct vdpa *vdpa, int argc, char **argv,
> >       return get_u32(result, *argv, 10);
> >   }
> >
> > +static int vdpa_argv_u64_hex(struct vdpa *vdpa, int argc, char **argv,
> > +                          uint64_t *result)
> > +{
> > +     if (argc <= 0 || !*argv) {
> > +             fprintf(stderr, "number expected\n");
> > +             return -EINVAL;
> > +     }
> > +
> > +     return get_u64(result, *argv, 16);
> > +}
> > +
> >   struct vdpa_args_metadata {
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
> >   }
> >
> >   static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
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
> > @@ -615,8 +640,9 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
> >   static void cmd_dev_help(void)
> >   {
> >       fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
> > -     fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
> > -     fprintf(stderr, "                                                    [ max_vqp MAX_VQ_PAIRS ]\n");
> > +     fprintf(stderr, "       vdpa dev add name NAME mgmtdevMANAGEMENTDEV [ device_features DEVICE_FEATURES]\n");
> > +     fprintf(stderr, "                                                   [ mac MACADDR ] [ mtu MTU ]\n");
> > +     fprintf(stderr, "                                                   [ max_vqp MAX_VQ_PAIRS ]\n");
> >       fprintf(stderr, "       vdpa dev del DEV\n");
> >       fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
> >       fprintf(stderr, "Usage: vdpa dev vstats COMMAND\n");
> > @@ -708,7 +734,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
> >       err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
> >                                 VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
> >                                 VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
> > -                               VDPA_OPT_MAX_VQP);
> > +                               VDPA_OPT_MAX_VQP | VDPA_OPT_VDEV_FEATURES);
> >       if (err)
> >               return err;
> >
>

