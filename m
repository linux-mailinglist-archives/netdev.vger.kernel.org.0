Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD4B53B197
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 04:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbiFBCIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 22:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiFBCIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 22:08:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 381BC247069
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 19:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654135712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1XyspsvoSb3NtHUHpb5oeCcY1zxXsm6k93GfeTwfJEU=;
        b=XqEDv29G5xOqPp2sbY/kpkewKK905vzIQzwnE3khPREyXiRgcw4GN+LxCZX6hUCneuPJuv
        eFxghgvst3RLIUDkLWmbTaeAhU5OuN4wcBaXV9POdoXAwo5UmB21xDON1ykr5IdjPXsNp1
        yLR3+86CZvUXqkZFlkcJDwSOH7ows98=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-H80BD0hjOxuDOxKZtZCltQ-1; Wed, 01 Jun 2022 22:08:31 -0400
X-MC-Unique: H80BD0hjOxuDOxKZtZCltQ-1
Received: by mail-pl1-f198.google.com with SMTP id d11-20020a170902cecb00b00163fe890197so1927028plg.1
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 19:08:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1XyspsvoSb3NtHUHpb5oeCcY1zxXsm6k93GfeTwfJEU=;
        b=KpZM/lWHHS4TTRsp7qV0ysDYvjTE1bxYxAHbfZzRjR5k79OtfCbXk/EJtRNFx3PW4y
         MQu2PXvIolcg7VL5osSdi+OU7UBzDVXedoD3iyy9kQSrM3Q3w2nqkQBpqxcoGp88qoi7
         OcT5uXdECDY2Ul5an+qxx89agK6idIFbP5tTe73OqbjBammuZ37X7Xfu8jMm5ru1dzeQ
         qxKUde6LkFv7HT3uh0AjURppMUeXLiyg4HXV1vWcytc2nc3vmnU8s0MHSVTQJmMhqFUL
         qqCASIIINopnCgKnOlqGRBJ7p9YV2BCUusPo4EXb9MEfKGhjuyFdKTlL2T8ZrHq5mtpA
         1yQQ==
X-Gm-Message-State: AOAM531tUFnCfoQtwUvUEFtRT56e7YcWPxs8QIiLTc2kX3hfVd9XsOE7
        JBOWzA6KY5lQzjS9zazmzIU4Vi2bXsBpEx4Jl7ungGXA+7KRiStxSvxSj3haBqVyiN4NlAFolxc
        OH1Qk/zez5oILVdWh
X-Received: by 2002:a17:902:9a92:b0:161:4e50:3b80 with SMTP id w18-20020a1709029a9200b001614e503b80mr2320109plp.149.1654135710184;
        Wed, 01 Jun 2022 19:08:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2dbDxajoyEelOLKZRvwOLRq9wik2EaSJcf1SAoEJF9TtruJ7MBPk0VF5bPP8b9BefjZkjUw==
X-Received: by 2002:a17:902:9a92:b0:161:4e50:3b80 with SMTP id w18-20020a1709029a9200b001614e503b80mr2320090plp.149.1654135709878;
        Wed, 01 Jun 2022 19:08:29 -0700 (PDT)
Received: from [10.72.13.239] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l17-20020a170902e2d100b0015e9f45c1f4sm2167309plc.186.2022.06.01.19.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 19:08:29 -0700 (PDT)
Message-ID: <6a0b9961-40c6-9b22-2b79-608633f78814@redhat.com>
Date:   Thu, 2 Jun 2022 10:08:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
Content-Language: en-US
To:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     martinh@xilinx.com, Stefano Garzarella <sgarzare@redhat.com>,
        martinpo@xilinx.com, lvivier@redhat.com, pabloc@xilinx.com,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>, lulu@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, Piotr.Uminski@intel.com,
        Si-Wei Liu <si-wei.liu@oracle.com>, ecree.xilinx@gmail.com,
        gautam.dawar@amd.com, habetsm.xilinx@gmail.com,
        tanuj.kamde@amd.com, hanand@xilinx.com, dinang@xilinx.com,
        Longpeng <longpeng2@huawei.com>
References: <20220526124338.36247-1-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220526124338.36247-1-eperezma@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/5/26 20:43, Eugenio Pérez 写道:
> Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
> that backend feature and userspace can effectively stop the device.
>
> This is a must before get virtqueue indexes (base) for live migration,
> since the device could modify them after userland gets them. There are
> individual ways to perform that action for some devices
> (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> way to perform it for any vhost device (and, in particular, vhost-vdpa).
>
> After the return of ioctl with stop != 0, the device MUST finish any
> pending operations like in flight requests. It must also preserve all
> the necessary state (the virtqueue vring base plus the possible device
> specific states) that is required for restoring in the future. The
> device must not change its configuration after that point.


I think we probably need more accurate definition on the state as Parav 
suggested.

Besides this, we should also clarify when stop is allowed. E.g should we 
allow setting stop without DRIVER_OK?

Thanks


>
> After the return of ioctl with stop == 0, the device can continue
> processing buffers as long as typical conditions are met (vq is enabled,
> DRIVER_OK status bit is enabled, etc).
>
> In the future, we will provide features similar to VHOST_USER_GET_INFLIGHT_FD
> so the device can save pending operations.
>
> Comments are welcome.
>
> v4:
> * Replace VHOST_STOP to VHOST_VDPA_STOP in vhost ioctl switch case too.
>
> v3:
> * s/VHOST_STOP/VHOST_VDPA_STOP/
> * Add documentation and requirements of the ioctl above its definition.
>
> v2:
> * Replace raw _F_STOP with BIT_ULL(_F_STOP).
> * Fix obtaining of stop ioctl arg (it was not obtained but written).
> * Add stop to vdpa_sim_blk.
>
> Eugenio Pérez (4):
>    vdpa: Add stop operation
>    vhost-vdpa: introduce STOP backend feature bit
>    vhost-vdpa: uAPI to stop the device
>    vdpa_sim: Implement stop vdpa op
>
>   drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++
>   drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
>   drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
>   drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
>   drivers/vhost/vdpa.c                 | 34 +++++++++++++++++++++++++++-
>   include/linux/vdpa.h                 |  6 +++++
>   include/uapi/linux/vhost.h           | 14 ++++++++++++
>   include/uapi/linux/vhost_types.h     |  2 ++
>   8 files changed, 83 insertions(+), 1 deletion(-)
>

