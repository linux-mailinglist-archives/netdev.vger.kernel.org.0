Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1369153B42D
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 09:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiFBHL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 03:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiFBHLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 03:11:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16C1860B84
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 00:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654153882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LQg4+c50YvWCQtzqLAPVbSBhXMgvtlCDtHeV4wCuhWA=;
        b=IPnbga4SZ5xm6QvihvzsH1BYuu5p66p1RkSyGueiCKGyPwkvVnr3HEqc4XI8nu0TU8iT1e
        zjkN1LDMpx1oVPbmrHpQISDEGraTS/gBCLhEGsc8DySkBi3w95hYHvo5ogT+RmvV1ieq40
        +3t36lLjLqBUrV1zM85EkDkwrCFEbh4=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-Tkb8VDNDNqWyVBeY0MKM8g-1; Thu, 02 Jun 2022 03:11:21 -0400
X-MC-Unique: Tkb8VDNDNqWyVBeY0MKM8g-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-30c1d90587dso35626847b3.14
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 00:11:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LQg4+c50YvWCQtzqLAPVbSBhXMgvtlCDtHeV4wCuhWA=;
        b=69PsNoJOBdz+tA7/vgmS7Yo+mNtPui1EqpyqruDgsF0bVEmccH0K9aMJDPHQm3CXq7
         MkBvLnGArkK1ylF3qJGf6G/Hnjd5h4cNxhEfF+k1/yIa7FKsITpMhn0Qw7VfrZaJ7Z33
         bazBvvgZ1SE9DTsFNgor+I88KKXD+ncrsjH3H7UZD2DLKl5I9vRM6gruVyMpcsidsVub
         4Y0NR3DV9EQ/R3H9CJ95VyveGgimx+Ppt+orPJGkeoiMbbtCLAIprUYK3LtD8QB11QLD
         kgJALMvbMGh8Kxyzhiz5+RoJjNO1elgGpG/Zu2iIBcke1Ud4UI5YOVuv1/Of3w64+/JW
         1TOA==
X-Gm-Message-State: AOAM531cEN8CnSRF9YhGy2VbzbCS3By3teH9/72/rEmBScZC+DrbtzQa
        /6E3e9y7YbyB2ai3vLLMFjT4NLU3RYv10o2ypoIQD3MqAQiWuY9SWu7mFz5WkjqMrpTFUGD6l5N
        uuwt5BzuD26jr6VDi4bvqTXFWB2/XVIj7
X-Received: by 2002:a25:2256:0:b0:65d:4d94:17c7 with SMTP id i83-20020a252256000000b0065d4d9417c7mr3660443ybi.173.1654153880483;
        Thu, 02 Jun 2022 00:11:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbq8mjNNskHu3ozeHpHlg+DaZHTBjyfJsEZXunCVoF4eQaVmhhytLgz9Ko+0MwYH/GiB6jkyIDuIrxlLkS4i8=
X-Received: by 2002:a25:2256:0:b0:65d:4d94:17c7 with SMTP id
 i83-20020a252256000000b0065d4d9417c7mr3660430ybi.173.1654153880277; Thu, 02
 Jun 2022 00:11:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220602023845.2596397-1-lingshan.zhu@intel.com> <20220602023845.2596397-2-lingshan.zhu@intel.com>
In-Reply-To: <20220602023845.2596397-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 2 Jun 2022 15:11:09 +0800
Message-ID: <CACGkMEsdKaWjmOncpLo1MO1DM2KDpE61KbH8uKBrnCqCxFubvw@mail.gmail.com>
Subject: Re: [PATCH 1/6] vDPA/ifcvf: get_config_size should return a value no
 greater than dev implementation
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> ifcvf_get_config_size() should return a virtio device type specific value,
> however the ret_value should not be greater than the onboard size of
> the device implementation. E.g., for virtio_net, config_size should be
> the minimum value of sizeof(struct virtio_net_config) and the onboard
> cap size.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_base.c | 8 ++++++--
>  drivers/vdpa/ifcvf/ifcvf_base.h | 2 ++
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index 48c4dadb0c7c..6bccc8291c26 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -128,6 +128,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
>                         break;
>                 case VIRTIO_PCI_CAP_DEVICE_CFG:
>                         hw->dev_cfg = get_cap_addr(hw, &cap);
> +                       hw->cap_dev_config_size = le32_to_cpu(cap.length);

One possible issue here is that, if the hardware have more size than
spec, we may end up with a migration compatibility issue.

It looks to me we'd better build the config size based on the
features, e.g it looks to me for net, we should probably use

offset_of(struct virtio_net_config, mtu)?

>                         IFCVF_DBG(pdev, "hw->dev_cfg = %p\n", hw->dev_cfg);
>                         break;
>                 }
> @@ -233,15 +234,18 @@ int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
>  u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
>  {
>         struct ifcvf_adapter *adapter;
> +       u32 net_config_size = sizeof(struct virtio_net_config);
> +       u32 blk_config_size = sizeof(struct virtio_blk_config);
> +       u32 cap_size = hw->cap_dev_config_size;
>         u32 config_size;
>
>         adapter = vf_to_adapter(hw);
>         switch (hw->dev_type) {
>         case VIRTIO_ID_NET:
> -               config_size = sizeof(struct virtio_net_config);
> +               config_size = cap_size >= net_config_size ? net_config_size : cap_size;

I don't get the code here, any chance that net_config_size could be zero?

Thanks

>                 break;
>         case VIRTIO_ID_BLOCK:
> -               config_size = sizeof(struct virtio_blk_config);
> +               config_size = cap_size >= blk_config_size ? blk_config_size : cap_size;
>                 break;
>         default:
>                 config_size = 0;
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 115b61f4924b..f5563f665cc6 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -87,6 +87,8 @@ struct ifcvf_hw {
>         int config_irq;
>         int vqs_reused_irq;
>         u16 nr_vring;
> +       /* VIRTIO_PCI_CAP_DEVICE_CFG size */
> +       u32 cap_dev_config_size;
>  };
>
>  struct ifcvf_adapter {
> --
> 2.31.1
>

