Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B0653B469
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 09:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiFBHgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 03:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbiFBHgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 03:36:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA44C39154
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 00:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654155396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l00IQqB81+H5bP30hrUtm+oNhTBjm7YmLlYdO4/7FSE=;
        b=NZ7iN0uGh7/5pXUUVPOhWfznBD6f9V7ZullEQFitB/J4t/HDa0HmFabB12NiVgFWO081Yv
        6XZgDBDJ196/XnUy9GLQ8OUjmb0SNJUcC6wzCFaueb6lR6fCP7rBRxYMC7/yubYnEDBl76
        bCRLMvDnJAYhPMVnTGh1P1DYf+/eoio=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-326-vye2gS12MFSB4Imcet0nVA-1; Thu, 02 Jun 2022 03:36:35 -0400
X-MC-Unique: vye2gS12MFSB4Imcet0nVA-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-30c1d90587dso36045027b3.14
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 00:36:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l00IQqB81+H5bP30hrUtm+oNhTBjm7YmLlYdO4/7FSE=;
        b=pzRX27ag6mZDVI+BxbW5mK5zCgU+it7N29yKweZcFFvwJfkzoBCyJ/NxWbI1arKSuy
         0iDW+iHsp4GWLESC3FN4fVDYMsty+u93/+PJU5LOBW4CnkCHA+6TLPo38t+Si9zvJCTa
         mOlgXp/XgtaQrrOxJq8CHOvEQEUlPcxpdVN6tpqS2c6KBuawb/GSku3GfpIpTtyLjkWC
         JdRayPSUQpI0vzMTqINPx4l9Zm1bkSuajO67QmyJrmGvMTsf5r8fkqjz90BRkN3MzSlA
         yc0/oUMGggjFWOaqn1tay/BJ7Dh+Uc91SfWOZ8fTZgbeRGExZ0L2o6ha9oZWUVen4heW
         qECg==
X-Gm-Message-State: AOAM532jwFIQi0d++OObQNPvTaFwro84JOsJY+PdncBkypy9yNaLBhI0
        o2hZi8Uq7fv7L1zLCCyxrkSs9EiAxQPSbRIg2hHQISs7ZIMUQcGR4/AyTJ7+oSgjZfscqRDl5M1
        TDMkA4nBS7niwPt0BGpFEb3p2djO/i6dA
X-Received: by 2002:a25:bac7:0:b0:64c:b780:90d3 with SMTP id a7-20020a25bac7000000b0064cb78090d3mr3890104ybk.10.1654155394624;
        Thu, 02 Jun 2022 00:36:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLZvnLYAkQE0UJGJ91nxExuoLuGjC7sOLRQk6mmI/a6gfxOle0c8YveJkKocH1JNYmkjISxYhsm6RLPDM/jXM=
X-Received: by 2002:a25:bac7:0:b0:64c:b780:90d3 with SMTP id
 a7-20020a25bac7000000b0064cb78090d3mr3890093ybk.10.1654155394417; Thu, 02 Jun
 2022 00:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220602023845.2596397-1-lingshan.zhu@intel.com> <20220602023845.2596397-5-lingshan.zhu@intel.com>
In-Reply-To: <20220602023845.2596397-5-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 2 Jun 2022 15:36:23 +0800
Message-ID: <CACGkMEtzHB9e9fgQ=t9vT1iz6A9t46hsEMmpHghQSTSfhr7kuw@mail.gmail.com>
Subject: Re: [PATCH 4/6] vDPA: !FEATURES_OK should not block querying device
 config space
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
> Users may want to query the config space of a vDPA device,
> to choose a appropriate one for a certain guest. This means the
> users need to read the config space before FEATURES_OK, and
> the existence of config space contents does not depend on
> FEATURES_OK.

Quotes from the spec:

"The device MUST allow reading of any device-specific configuration
field before FEATURES_OK is set by the driver. This includes fields
which are conditional on feature bits, as long as those feature bits
are offered by the device."

>
> This commit removes FEATURES_OK blocker in vdpa_dev_config_fill()
> which calls vdpa_dev_net_config_fill() for virtio-net
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/vdpa.c | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index c820dd2b0307..030d96bdeed2 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -863,17 +863,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid,
>  {
>         u32 device_id;
>         void *hdr;
> -       u8 status;
>         int err;
>
>         mutex_lock(&vdev->cf_mutex);
> -       status = vdev->config->get_status(vdev);
> -       if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
> -               NL_SET_ERR_MSG_MOD(extack, "Features negotiation not completed");
> -               err = -EAGAIN;
> -               goto out;
> -       }

So we had the following in vdpa_dev_net_config_fill():

        features = vdev->config->get_driver_features(vdev);
        if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
                              VDPA_ATTR_PAD))
                return -EMSGSIZE;

It looks to me we need to switch to using get_device_features() instead.

Thanks

> -
>         hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
>                           VDPA_CMD_DEV_CONFIG_GET);
>         if (!hdr) {
> --
> 2.31.1
>

