Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4647D4B07BB
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbiBJIHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:07:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236975AbiBJIHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:07:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 231D5184
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644480459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rGcAkQ2KBwEnEDFBmOXDTasNrc16+70ZKZhrW/+mHeI=;
        b=itd2p2DwjWMO2UsqC1t7GsNmbG8CBlNX1Tzdk4YiFQrItayNJdSK+DAQkXFx7PCZV1V0Gq
        06wsB66u4zl3Nr6RsUwDsOgkkgDC3z8HcihRukNNm6yaaI7i2vBGc2bWY3DZhJb7axi0Oo
        t5yebKCpEp11slJ/kh12SOMP4HwOOR0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-383-uuUvaUWvNo-xWBgOYKYy6g-1; Thu, 10 Feb 2022 03:07:38 -0500
X-MC-Unique: uuUvaUWvNo-xWBgOYKYy6g-1
Received: by mail-lf1-f69.google.com with SMTP id z9-20020a056512308900b004370a6a3211so1159974lfd.13
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:07:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rGcAkQ2KBwEnEDFBmOXDTasNrc16+70ZKZhrW/+mHeI=;
        b=U9Hp07MfMezJm+X6rZnyoP7eANSEktSCSSz6IRT8+Wk4AaydZb3ioHBfOwvERZG+I1
         xnaxv5kDY/SUeyywJj+EC2Lqtsqy/32y03ZSx27FE9zAbD8wuQnE0ye2dgODmla7GfoN
         0JoaYfx7T4/1xLgxl7YjpAHacSQg6vz3v1deU9kwd2KwHllryUUB9qIfNrgIuNhZq2Kt
         h1vlAP2iF1al20Lw6hczpZf82H/4q9Xl2NVkM02FC7vsTyyFxpcOrmUSiNZEU/8WOMXD
         WvTUUDXYpt0XxuTcmM336Djzi+s+F9OlhbDWWuThrQDJXTznMtVlO6DRAttCI6r9/0r7
         aCRw==
X-Gm-Message-State: AOAM533sr5oixIMj8wBaQOL5RbK1DfFSX9t4qqIhZCwxl7ib5vss13yH
        c8bEKUPQhk6D4cxFfloB1bQmBpf9Y1aiIQAWmzAH+IYkKeM3HNVfxA4XfOu/GovArx2n4YPOL1f
        Yi7Gt1IbFsqVsS0TNFXxxoN9+TKua8ZyX
X-Received: by 2002:a05:6512:39c6:: with SMTP id k6mr4581549lfu.199.1644480456348;
        Thu, 10 Feb 2022 00:07:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJznMoJXEs6rCFp3ZkEfdyBjYrSLqRcOL3AAQlAxdpq755zNmolW8/DI6mNop0Zjgctho/D/XytBJZL2uSZL0pQ=
X-Received: by 2002:a05:6512:39c6:: with SMTP id k6mr4581535lfu.199.1644480456028;
 Thu, 10 Feb 2022 00:07:36 -0800 (PST)
MIME-Version: 1.0
References: <20220207125537.174619-1-elic@nvidia.com> <20220207125537.174619-4-elic@nvidia.com>
In-Reply-To: <20220207125537.174619-4-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 10 Feb 2022 16:07:24 +0800
Message-ID: <CACGkMEsyPHKPm1mH+O9jD2uLMGTJrgRF=8h=9O00JiEXeYNEvg@mail.gmail.com>
Subject: Re: [PATCH 3/3] vdpa: Add support to configure max number of VQs
To:     Eli Cohen <elic@nvidia.com>
Cc:     "Hemminger, Stephen" <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Jianbo Liu <jianbol@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 7, 2022 at 8:56 PM Eli Cohen <elic@nvidia.com> wrote:
>
> Add support to configure max supported virtqueue pairs for a vdpa
> device. For this to be possible, add support for reading management
> device's capabilities. Management device capabilities give the user a
> hint as to how many virtqueue pairs at most he can ask for. Using this
> information the user can choose a valid number of virtqueue pairs when
> creating the device.
>
> Examples:
> - Show management device capabiliteis:
> $ vdpa mgmtdev show
> auxiliary/mlx5_core.sf.1:
>   supported_classes net
>   max_supported_vqs 257
>   dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ \
>                MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM
>
> A user can now create a device based on the above information. In the
> above case 128 virtqueue pairs at most. The other VQ being for the
> control virtqueue.
>
> - Add a vdpa device with 16 data virtqueue pairs
> $ vdpa dev add name vdpa-a mgmtdev auxiliary/mlx5_core.sf.1 max_vqp 16
>
> After feature negotiation has been completed, one can read the vdpa
> configuration using:
> $ vdpa dev config show
> vdpa-a: mac 00:00:00:00:88:88 link up link_announce false max_vq_pairs 16 mtu 1500
>   negotiated_features CSUM GUEST_CSUM MTU MAC HOST_TSO4 HOST_TSO6 STATUS
>                       CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM

I wonder if lower case is better.

>
> Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>  vdpa/include/uapi/linux/vdpa.h |   4 ++
>  vdpa/vdpa.c                    | 113 ++++++++++++++++++++++++++++++++-
>  2 files changed, 114 insertions(+), 3 deletions(-)
>
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> index b7eab069988a..171122dd03c9 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -40,6 +40,10 @@ enum vdpa_attr {
>         VDPA_ATTR_DEV_NET_CFG_MAX_VQP,          /* u16 */
>         VDPA_ATTR_DEV_NET_CFG_MTU,              /* u16 */
>
> +       VDPA_ATTR_DEV_NEGOTIATED_FEATURES,      /* u64 */
> +       VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
> +       VDPA_ATTR_DEV_SUPPORTED_FEATURES,       /* u64 */

I wonder if it's better to split the patches into three where the
above command could be implemented separately.

> +
>         /* new attributes must be added above here */
>         VDPA_ATTR_MAX,
>  };
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index 4ccb564872a0..d0dd4196610f 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -23,6 +23,7 @@
>  #define VDPA_OPT_VDEV_HANDLE           BIT(3)
>  #define VDPA_OPT_VDEV_MAC              BIT(4)
>  #define VDPA_OPT_VDEV_MTU              BIT(5)
> +#define VDPA_OPT_MAX_VQP               BIT(6)
>
>  struct vdpa_opts {
>         uint64_t present; /* flags of present items */
> @@ -32,6 +33,7 @@ struct vdpa_opts {
>         unsigned int device_id;
>         char mac[ETH_ALEN];
>         uint16_t mtu;
> +       uint16_t max_vqp;
>  };
>
>  struct vdpa {
> @@ -78,6 +80,9 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
>         [VDPA_ATTR_DEV_VENDOR_ID] = MNL_TYPE_U32,
>         [VDPA_ATTR_DEV_MAX_VQS] = MNL_TYPE_U32,
>         [VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
> +       [VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
> +       [VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
> +       [VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
>  };
>
>  static int attr_cb(const struct nlattr *attr, void *data)
> @@ -219,6 +224,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
>                              sizeof(opts->mac), opts->mac);
>         if (opts->present & VDPA_OPT_VDEV_MTU)
>                 mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts->mtu);
> +       if (opts->present & VDPA_OPT_MAX_VQP)
> +               mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
>  }
>
>  static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> @@ -287,6 +294,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
>
>                         NEXT_ARG_FWD();
>                         o_found |= VDPA_OPT_VDEV_MTU;
> +               } else if ((matches(*argv, "max_vqp")  == 0) && (o_optional & VDPA_OPT_MAX_VQP)) {
> +                       NEXT_ARG_FWD();
> +                       err = vdpa_argv_u16(vdpa, argc, argv, &opts->max_vqp);
> +                       if (err)
> +                               return err;
> +
> +                       NEXT_ARG_FWD();
> +                       o_found |= VDPA_OPT_MAX_VQP;
>                 } else {
>                         fprintf(stderr, "Unknown option \"%s\"\n", *argv);
>                         return -EINVAL;
> @@ -385,6 +400,77 @@ static const char *parse_class(int num)
>         return class ? class : "< unknown class >";
>  }
>
> +static const char * const net_feature_strs[64] = {
> +       [VIRTIO_NET_F_CSUM] = "CSUM",
> +       [VIRTIO_NET_F_GUEST_CSUM] = "GUEST_CSUM",
> +       [VIRTIO_NET_F_CTRL_GUEST_OFFLOADS] = "CTRL_GUEST_OFFLOADS",
> +       [VIRTIO_NET_F_MTU] = "MTU",
> +       [VIRTIO_NET_F_MAC] = "MAC",
> +       [VIRTIO_NET_F_GUEST_TSO4] = "GUEST_TSO4",
> +       [VIRTIO_NET_F_GUEST_TSO6] = "GUEST_TSO6",
> +       [VIRTIO_NET_F_GUEST_ECN] = "GUEST_ECN",
> +       [VIRTIO_NET_F_GUEST_UFO] = "GUEST_UFO",
> +       [VIRTIO_NET_F_HOST_TSO4] = "HOST_TSO4",
> +       [VIRTIO_NET_F_HOST_TSO6] = "HOST_TSO6",
> +       [VIRTIO_NET_F_HOST_ECN] = "HOST_ECN",
> +       [VIRTIO_NET_F_HOST_UFO] = "HOST_UFO",
> +       [VIRTIO_NET_F_MRG_RXBUF] = "MRG_RXBUF",
> +       [VIRTIO_NET_F_STATUS] = "STATUS",
> +       [VIRTIO_NET_F_CTRL_VQ] = "CTRL_VQ",
> +       [VIRTIO_NET_F_CTRL_RX] = "CTRL_RX",
> +       [VIRTIO_NET_F_CTRL_VLAN] = "CTRL_VLAN",
> +       [VIRTIO_NET_F_CTRL_RX_EXTRA] = "CTRL_RX_EXTRA",
> +       [VIRTIO_NET_F_GUEST_ANNOUNCE] = "GUEST_ANNOUNCE",
> +       [VIRTIO_NET_F_MQ] = "MQ",
> +       [VIRTIO_F_NOTIFY_ON_EMPTY] = "NOTIFY_ON_EMPTY",
> +       [VIRTIO_NET_F_CTRL_MAC_ADDR] = "CTRL_MAC_ADDR",
> +       [VIRTIO_F_ANY_LAYOUT] = "ANY_LAYOUT",
> +       [VIRTIO_NET_F_RSC_EXT] = "RSC_EXT",
> +       [VIRTIO_NET_F_STANDBY] = "STANDBY",
> +};

It seems we are still missing things that are already supported in the
Linux uapi. I think it's better to support them. E.g the RSS and
SPEED_DUPLEX etc.

> +
> +#define VDPA_EXT_FEATURES_SZ (VIRTIO_DEV_INDEPENDENT_F_END - \
> +                             VIRTIO_DEV_INDEPENDENT_F_START + 1)
> +
> +static const char * const ext_feature_strs[VDPA_EXT_FEATURES_SZ] = {
> +       [VIRTIO_F_RING_INDIRECT_DESC - VIRTIO_DEV_INDEPENDENT_F_START] = "RING_INDIRECT_DESC",
> +       [VIRTIO_F_RING_EVENT_IDX - VIRTIO_DEV_INDEPENDENT_F_START] = "RING_EVENT_IDX",
> +       [VIRTIO_F_VERSION_1 - VIRTIO_DEV_INDEPENDENT_F_START] = "VERSION_1",
> +       [VIRTIO_F_ACCESS_PLATFORM - VIRTIO_DEV_INDEPENDENT_F_START] = "ACCESS_PLATFORM",
> +       [VIRTIO_F_RING_PACKED - VIRTIO_DEV_INDEPENDENT_F_START] = "RING_PACKED",
> +       [VIRTIO_F_IN_ORDER - VIRTIO_DEV_INDEPENDENT_F_START] = "IN_ORDER",
> +       [VIRTIO_F_ORDER_PLATFORM - VIRTIO_DEV_INDEPENDENT_F_START] = "ORDER_PLATFORM",
> +       [VIRTIO_F_SR_IOV - VIRTIO_DEV_INDEPENDENT_F_START] = "SR_IOV",
> +       [VIRTIO_F_NOTIFICATION_DATA - VIRTIO_DEV_INDEPENDENT_F_START] = "NOTIFICATION_DATA",
> +};
> +
> +static void print_net_features(struct vdpa *vdpa, uint64_t features, bool maxf)
> +{
> +       const char *s;
> +       int i;
> +
> +       if (maxf)
> +               pr_out_array_start(vdpa, "dev_features");
> +       else
> +               pr_out_array_start(vdpa, "negotiated_features");
> +
> +       for (i = 0; i < 64; i++) {
> +               if (!(features & (1ULL << i)))
> +                       continue;
> +
> +               if (i >= VIRTIO_DEV_INDEPENDENT_F_START && i <= VIRTIO_DEV_INDEPENDENT_F_END)

I don't see any issue that just use VIRTIO_TRANSPORT_F_START and
VIRTIO_TRANSPORT_F_END (even if END can change).

> +                       s = ext_feature_strs[i - VIRTIO_DEV_INDEPENDENT_F_START];
> +               else
> +                       s = net_feature_strs[i];
> +
> +               if (!s)
> +                       print_uint(PRINT_ANY, NULL, " unrecognized_bit_%d", i);
> +               else
> +                       print_string(PRINT_ANY, NULL, " %s", s);
> +       }
> +       pr_out_array_end(vdpa);
> +}
> +
>  static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>                                 struct nlattr **tb)
>  {
> @@ -408,6 +494,22 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
>                 pr_out_array_end(vdpa);
>         }
>
> +       if (tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]) {
> +               uint16_t num_vqs;
> +
> +               if (!vdpa->json_output)
> +                       printf("\n");
> +               num_vqs = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]);
> +               print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
> +       }
> +
> +       if (tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]) {
> +               uint64_t features;
> +
> +               features  = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]);
> +               print_net_features(vdpa, features, true);

Do we need to check whether it's a networking device before trying to
print the feature and for other type devices we can simply print the
bit number as a startup?

Thanks

> +       }
> +
>         pr_out_handle_end(vdpa);
>  }
>
> @@ -557,7 +659,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
>                                           NLM_F_REQUEST | NLM_F_ACK);
>         err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
>                                   VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
> -                                 VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU);
> +                                 VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU | VDPA_OPT_MAX_VQP);
>         if (err)
>                 return err;
>
> @@ -579,9 +681,10 @@ static int cmd_dev_del(struct vdpa *vdpa,  int argc, char **argv)
>         return mnlu_gen_socket_sndrcv(&vdpa->nlg, nlh, NULL, NULL);
>  }
>
> -static void pr_out_dev_net_config(struct nlattr **tb)
> +static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
>  {
>         SPRINT_BUF(macaddr);
> +       uint64_t val_u64;
>         uint16_t val_u16;
>
>         if (tb[VDPA_ATTR_DEV_NET_CFG_MACADDR]) {
> @@ -610,6 +713,10 @@ static void pr_out_dev_net_config(struct nlattr **tb)
>                 val_u16 = mnl_attr_get_u16(tb[VDPA_ATTR_DEV_NET_CFG_MTU]);
>                 print_uint(PRINT_ANY, "mtu", "mtu %d ", val_u16);
>         }
> +       if (tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]) {
> +               val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
> +               print_net_features(vdpa, val_u64, false);
> +       }
>  }
>
>  static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> @@ -619,7 +726,7 @@ static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
>         pr_out_vdev_handle_start(vdpa, tb);
>         switch (device_id) {
>         case VIRTIO_ID_NET:
> -               pr_out_dev_net_config(tb);
> +               pr_out_dev_net_config(vdpa, tb);
>                 break;
>         default:
>                 break;
> --
> 2.34.1
>

