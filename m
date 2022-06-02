Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CF853B444
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 09:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiFBHWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 03:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbiFBHWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 03:22:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D02921B5851
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 00:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654154526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PdmeV4XXkwsKK34sBvBhUPHAPFbEQyKtEpFLQkhAZRk=;
        b=gtPboHkPyXmttCjxEoOxjPlqBweTdApPW5g1BUpuR2myCwXx6bxfDEQQbsL0U1rh68irUM
        kZLrjYaPD5bmMA5S7mpDa27BqmBiz6Kxc7gRIlm+BbsrOqY38r98BSn7xk1gWQ98uk8D06
        aqJXuE+Vp4qp7J56Ai7taGLnyLQ7KM0=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-gvj07oPWOMionWqwhCFsYQ-1; Thu, 02 Jun 2022 03:22:03 -0400
X-MC-Unique: gvj07oPWOMionWqwhCFsYQ-1
Received: by mail-yb1-f197.google.com with SMTP id i17-20020a259d11000000b0064cd3084085so3463611ybp.9
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 00:22:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PdmeV4XXkwsKK34sBvBhUPHAPFbEQyKtEpFLQkhAZRk=;
        b=Cgq34Zgqvuo/fXU+9tzDI1M3tLFZ9mFuy+YeYBUOoKQZmswk/MaRYWbjnH8wEaZsdm
         4HJpXuoJSY16cMybPiKgsk6AvFBv70m8RVMZlyidk/Txa3iTEJofos0KLugaa23i+Edh
         S83fP7DTmOP9xsnYytchrA8NNCaIecihi9g0qyDbY2cnzhER43QijcbcsWKSp1dBrxsm
         pbKDecUCqe0OHCrp+X0lgKAlNPwcJpbLb+cQ/L2Y1+Uv+5/cvl8c4+M4Va2Fp5kc9g60
         VezxVfUwVp7Ta4yJ2d7da0aGKiyjSCWwMWzXxNww6n1CEGLAlVgdJjLap2AFZHIpLIqm
         eveg==
X-Gm-Message-State: AOAM532iGeeNJiiOmb54XRbmpKBcICRlXTfve5y/LpnoadQo7tX1mW4d
        XUUyBH9HpoqyR123km2nQ8sjQnYLj0vKx2I9Mh98tmamQMsh7Rd+oaWyTv3wwM8KQyFE0GT2ROr
        t2js3OXxXXGUkZXEK+cuIUonvy85Lt+bJ
X-Received: by 2002:a25:d98b:0:b0:65c:9dc9:7a8f with SMTP id q133-20020a25d98b000000b0065c9dc97a8fmr3682962ybg.622.1654154523044;
        Thu, 02 Jun 2022 00:22:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuB1e5WkQ7CJfmXyUcXu9v1a07sh/Q63u1Zs089N3+o1m61VRasufyxqas0IxOqRZFSLxoDqQFKlYmmFh6paM=
X-Received: by 2002:a25:d98b:0:b0:65c:9dc9:7a8f with SMTP id
 q133-20020a25d98b000000b0065c9dc97a8fmr3682951ybg.622.1654154522824; Thu, 02
 Jun 2022 00:22:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220602023845.2596397-1-lingshan.zhu@intel.com> <20220602023845.2596397-3-lingshan.zhu@intel.com>
In-Reply-To: <20220602023845.2596397-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 2 Jun 2022 15:21:51 +0800
Message-ID: <CACGkMEt4u2R9y8f3S0rAhrEmOi-N=1NCfLxLTR+U6ddcu9iYWg@mail.gmail.com>
Subject: Re: [PATCH 2/6] vDPA/ifcvf: support userspace to query features and
 MQ of a management device
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
> Adapting to current netlink interfaces, this commit allows userspace
> to query feature bits and MQ capability of a management device.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_base.c | 12 ++++++++++++
>  drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
>  drivers/vdpa/ifcvf/ifcvf_main.c |  3 +++
>  3 files changed, 16 insertions(+)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index 6bccc8291c26..7be703b5d1f4 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -341,6 +341,18 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
>         return 0;
>  }
>
> +u16 ifcvf_get_max_vq_pairs(struct ifcvf_hw *hw)
> +{
> +       struct virtio_net_config __iomem *config;
> +       u16 val, mq;
> +
> +       config  = (struct virtio_net_config __iomem *)hw->dev_cfg;

Any reason we need the cast here? (cast from void * seems not necessary).

> +       val = vp_ioread16((__le16 __iomem *)&config->max_virtqueue_pairs);

I don't see any __le16 cast for the callers of vp_ioread16, anything
make max_virtqueue_pairs different here?

Thanks

> +       mq = le16_to_cpu((__force __le16)val);
> +
> +       return mq;
> +}
> +
>  static int ifcvf_hw_enable(struct ifcvf_hw *hw)
>  {
>         struct virtio_pci_common_cfg __iomem *cfg;
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index f5563f665cc6..d54a1bed212e 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -130,6 +130,7 @@ u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
>  int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features);
>  u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
>  int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
> +u16 ifcvf_get_max_vq_pairs(struct ifcvf_hw *hw);
>  struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
>  int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
>  u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 4366320fb68d..0c3af30b297e 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -786,6 +786,9 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>         vf->hw_features = ifcvf_get_hw_features(vf);
>         vf->config_size = ifcvf_get_config_size(vf);
>
> +       ifcvf_mgmt_dev->mdev.max_supported_vqs = ifcvf_get_max_vq_pairs(vf);

Btw, I think current IFCVF doesn't support the provisioning of a
$max_qps that is smaller than what hardware did.

Then I wonder if we need a min_supported_vqs attribute or doing
mediation in the ifcvf parent.

Thanks

> +       ifcvf_mgmt_dev->mdev.supported_features = vf->hw_features;
> +
>         adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
>         ret = _vdpa_register_device(&adapter->vdpa, vf->nr_vring);
>         if (ret) {
> --
> 2.31.1
>

