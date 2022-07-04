Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A748B564CB3
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 06:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiGDEjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 00:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiGDEjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 00:39:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B73922BF2
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 21:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656909589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=34NQkLuDu70RYtu7A5zt/ESnLEXxvA0x7SQgJUnytlU=;
        b=Y0pVW41/J1XQzJPYlDA/l73+RXTdlgAuFssON9b28hFS05HjS/blcdyOZAw622znoyv/pD
        Zvj2xR0hgLj9erKvVLPBPDz4AbbbIE6qqy8twjI2sEKEEjINEp0GqvmrPgUurNgFJgWaqW
        M3edZgKNHcllD3Xmar1yZOgASWOqhkE=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-0gXgSyaXOZaEGob_1SSGwQ-1; Mon, 04 Jul 2022 00:39:48 -0400
X-MC-Unique: 0gXgSyaXOZaEGob_1SSGwQ-1
Received: by mail-lj1-f198.google.com with SMTP id w23-20020a2e9bd7000000b0025bd31b7fe7so2402410ljj.16
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 21:39:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=34NQkLuDu70RYtu7A5zt/ESnLEXxvA0x7SQgJUnytlU=;
        b=AQ1tu4T3NrC0/9fs5edv7Q6COZGCuzwXSGOsovL+1zmILiusv9xkpqJrVaeLknNW70
         upVyJLntX2Ul+xSJZrmhYa+vnaLVkw8VvaWoZhpgZPwBAVSmXYMvxcMC2Uzoe3/ZniHL
         ESUZgfaknnwPGkS+/m0sQ/1In0Pck3wflijLozo9eVpL7wgErpNRmwRyJFTT/V8VR03H
         XZo+I6p45dkAsoKVnqQr96BCNwsQJy2l7I+A6g/Li5geUtHpOlZObuZYaNH7yU6TCk1K
         7UTzNz/iZLzHUxYu9rrFEyhWrr7TN3rEv586b9GQRLrSAVIAo4JSKCkI7nY+THkRjiiY
         2VtQ==
X-Gm-Message-State: AJIora+noNJ2VTR+uE5L76eJrxnPXaU8fQ0HP8kydlYwUSLGgt993Kjk
        PQNC9cPqm/X42DaTbR74TdNgeFiPe014m0//skF2yo6gF4cmYITEQvxoTatf/2guWvQeJsJagne
        CdIwZKP9ynnw+wJMPAPksBlgxBr3N7VAE
X-Received: by 2002:a05:6512:b0d:b0:481:5cb4:cf1e with SMTP id w13-20020a0565120b0d00b004815cb4cf1emr10153637lfu.442.1656909586924;
        Sun, 03 Jul 2022 21:39:46 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sbGuL+fn0YCwy3PFvwHzJchJaTph3jj60D8dfYlVR8XTdiZAzAbGETkaVrvpPHFEGBOLc9W/txx60ltVFAKow=
X-Received: by 2002:a05:6512:b0d:b0:481:5cb4:cf1e with SMTP id
 w13-20020a0565120b0d00b004815cb4cf1emr10153626lfu.442.1656909586743; Sun, 03
 Jul 2022 21:39:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220701132826.8132-1-lingshan.zhu@intel.com> <20220701132826.8132-2-lingshan.zhu@intel.com>
In-Reply-To: <20220701132826.8132-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 4 Jul 2022 12:39:35 +0800
Message-ID: <CACGkMEvGo2urfPriS3f6dCxT+41KJ0E-KUd4-GvUrX81BVy8Og@mail.gmail.com>
Subject: Re: [PATCH V3 1/6] vDPA/ifcvf: get_config_size should return a value
 no greater than dev implementation
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, Parav Pandit <parav@nvidia.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 1, 2022 at 9:36 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> ifcvf_get_config_size() should return a virtio device type specific value,
> however the ret_value should not be greater than the onboard size of
> the device implementation. E.g., for virtio_net, config_size should be
> the minimum value of sizeof(struct virtio_net_config) and the onboard
> cap size.

Rethink of this, I wonder what's the value of exposing device
implementation details to users? Anyhow the parent is in charge of
"emulating" config space accessing.

If we do this, it's probably a blocker for cross vendor stuff.

Thanks

>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_base.c | 13 +++++++++++--
>  drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
>  2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index 48c4dadb0c7c..fb957b57941e 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -128,6 +128,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
>                         break;
>                 case VIRTIO_PCI_CAP_DEVICE_CFG:
>                         hw->dev_cfg = get_cap_addr(hw, &cap);
> +                       hw->cap_dev_config_size = le32_to_cpu(cap.length);
>                         IFCVF_DBG(pdev, "hw->dev_cfg = %p\n", hw->dev_cfg);
>                         break;
>                 }
> @@ -233,15 +234,23 @@ int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
>  u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
>  {
>         struct ifcvf_adapter *adapter;
> +       u32 net_config_size = sizeof(struct virtio_net_config);
> +       u32 blk_config_size = sizeof(struct virtio_blk_config);
> +       u32 cap_size = hw->cap_dev_config_size;
>         u32 config_size;
>
>         adapter = vf_to_adapter(hw);
> +       /* If the onboard device config space size is greater than
> +        * the size of struct virtio_net/blk_config, only the spec
> +        * implementing contents size is returned, this is very
> +        * unlikely, defensive programming.
> +        */
>         switch (hw->dev_type) {
>         case VIRTIO_ID_NET:
> -               config_size = sizeof(struct virtio_net_config);
> +               config_size = cap_size >= net_config_size ? net_config_size : cap_size;
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

