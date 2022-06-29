Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F4A55F4F1
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiF2EKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 00:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiF2EKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 00:10:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06774326D2
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 21:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656475847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bg6heNJXq50eL6WsFIMxRV6MiBd1t5LqWZMr8mmOcec=;
        b=TCpZHVJ3ivj+IeKzkj7z6dLwyDYdKVZlzNdadB+WYozqswSUtzFHJ/F03HwVh2G70l776L
        noCUqHaTWHPev4GirHSFxeyMO100ViHkNuYZ+9hla9Vj9iIhavilwu8uqBXYylNPCQGtyQ
        O1i2RdeHqyDhaa5ykdvvzn033UfCVl8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-rvLwZlHvMzyjODJiSewiJQ-1; Wed, 29 Jun 2022 00:10:45 -0400
X-MC-Unique: rvLwZlHvMzyjODJiSewiJQ-1
Received: by mail-lf1-f69.google.com with SMTP id o23-20020ac24357000000b0047f95f582c6so7146383lfl.7
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 21:10:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bg6heNJXq50eL6WsFIMxRV6MiBd1t5LqWZMr8mmOcec=;
        b=f9egYs8wMdWKbL5wA8wT7iG36okkNckRw5VcoczabXhkV/VDl/HrzP00EpzsJCNOpc
         XtJ5WdazyjaQmigq8XLHSYlDClkE/iUSvmWaM+kKn5sWDu5y6voi7W27GlMNIZqx2yPu
         ukALXiptMQTfjTFp43wiXhnf9i3Zc5+OQ9WyE13pgyU9eBbmUott4vT1A//2Ub56YZp8
         ljo6fEo+BtCCcKeJzeNhHY6Sj+Sgd8tEXkMPSWairGlR98GrN6T+yHuAjOnboOsas5RU
         PW1EwU2gPVMtW0GD5J4trvRX8ONj4eHMmNvz1nulhIBkoTuY5sM3TIZ0mKG8vw05bjYe
         LILQ==
X-Gm-Message-State: AJIora/+GIhosZYLXIg9ofdpJ3K0jM6+UABQDphdteZuU0wrqiMB+n/D
        4OmxkYlGW2u6ZB2SkaMf1nhZUbmZQFef5tWs6Jhqc5ejx02R5xa21afS+II255P/xGm3Jxnhi82
        9fNyVDeeyGTPrDCx2kzHrFsM/27ZJGPxR
X-Received: by 2002:a05:651c:1610:b0:25a:75fa:f9cc with SMTP id f16-20020a05651c161000b0025a75faf9ccmr615166ljq.243.1656475843953;
        Tue, 28 Jun 2022 21:10:43 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tsRfqKSJ5WREAe866tYR2Av6sXWiFQwf7Na0t+bQDdXFNQBHVv7PWUm2aQHXPC9OFidZUGp5C/19n3ZUbyfXY=
X-Received: by 2002:a05:651c:1610:b0:25a:75fa:f9cc with SMTP id
 f16-20020a05651c161000b0025a75faf9ccmr615131ljq.243.1656475843670; Tue, 28
 Jun 2022 21:10:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-2-eperezma@redhat.com>
In-Reply-To: <20220623160738.632852-2-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 29 Jun 2022 12:10:32 +0800
Message-ID: <CACGkMEv+yFLCzo-K7eSaVPJqLCa5SxfVCmB=piQ3+6R3=oDz-w@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] vdpa: Add suspend operation
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Cindy Lu <lulu@redhat.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        habetsm.xilinx@gmail.com, "Dawar, Gautam" <gautam.dawar@amd.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Martin Porter <martinpo@xilinx.com>,
        Eli Cohen <elic@nvidia.com>, ecree.xilinx@gmail.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 12:07 AM Eugenio P=C3=A9rez <eperezma@redhat.com> w=
rote:
>
> This operation is optional: It it's not implemented, backend feature bit
> will not be exposed.

A question, do we allow suspending a device without DRIVER_OK?

Thanks

>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
>  include/linux/vdpa.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 7b4a13d3bd91..d282f464d2f1 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -218,6 +218,9 @@ struct vdpa_map_file {
>   * @reset:                     Reset device
>   *                             @vdev: vdpa device
>   *                             Returns integer: success (0) or error (< =
0)
> + * @suspend:                   Suspend or resume the device (optional)
> + *                             @vdev: vdpa device
> + *                             Returns integer: success (0) or error (< =
0)
>   * @get_config_size:           Get the size of the configuration space i=
ncludes
>   *                             fields that are conditional on feature bi=
ts.
>   *                             @vdev: vdpa device
> @@ -319,6 +322,7 @@ struct vdpa_config_ops {
>         u8 (*get_status)(struct vdpa_device *vdev);
>         void (*set_status)(struct vdpa_device *vdev, u8 status);
>         int (*reset)(struct vdpa_device *vdev);
> +       int (*suspend)(struct vdpa_device *vdev);
>         size_t (*get_config_size)(struct vdpa_device *vdev);
>         void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
>                            void *buf, unsigned int len);
> --
> 2.31.1
>

