Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B33534C40
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 11:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345957AbiEZJHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 05:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239192AbiEZJHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 05:07:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A203AEE1D
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 02:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653556039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KrhZj/f2a1K5xyngYjaDLFoTBYuesG1Fa4WdS5JUxdc=;
        b=PqsbdUzHwK3A5hrBfI2O18NMQn7wLtI8TQIn5oZRsAPlgAuhtlki1fOcWkE6dU22yzKPCO
        D70sUJQpUbXQryivYe9qz6OFubPiffizY1KT2OWb59e0ZjVp5FLkqiNyI5+qBoQzHAamOn
        oHStQfoK7Ok3q9CIsqS0u4QK9CPUejs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-6UbcWFsdPCme4TLX18OlkQ-1; Thu, 26 May 2022 05:07:18 -0400
X-MC-Unique: 6UbcWFsdPCme4TLX18OlkQ-1
Received: by mail-wm1-f72.google.com with SMTP id o2-20020a05600c510200b0039747b0216fso2731108wms.0
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 02:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KrhZj/f2a1K5xyngYjaDLFoTBYuesG1Fa4WdS5JUxdc=;
        b=GkmDD8l8aspOj2ScgbzvyxiS3z+iZsyrkJadsA92CNzBI6JzAu9aczEYqo5gPh1cPh
         W0WHiItjSp4TloAMxm/mIi53kNa7J/Lw1NLkLQlUrq/TyGT6+rQbCMC3XZ6JWO5UAPws
         09R8qW4YCMWR6Wa0aIkdd6Fys3y54dUK7x+6w/6ksYpOO5OcJ5+XmQiViaZlKwZYLTLZ
         X4zhH6KoMgV7K0Mf6Qmydfyo7ksyrGHBfp2UJkuZ7dpzGWpaQqKAelfrC22sJTKO6RR6
         eiFxGUsPAGZqXuNRgqjivoG6cwa0GBvNgoWT5IQzm3YWh8hVT0qqk2DrQt8ZAZuG8ej6
         0VqQ==
X-Gm-Message-State: AOAM530SjWEVJuuGft1M9DJ1+X7hhnziFwIquyP3ijHqMqX9RLudXM+Z
        +zMlFn6riq1GUbj+/1H9kg3gJddSISSdTuXb/RCnY1jUliXHY/5BkPZNe9Ox76AgmcmTGTe1Ulx
        loHsBmzaDxDdJ8mqy
X-Received: by 2002:a05:600c:3d0d:b0:397:460d:3360 with SMTP id bh13-20020a05600c3d0d00b00397460d3360mr1385908wmb.54.1653556037232;
        Thu, 26 May 2022 02:07:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsQMSJXaL5D4KLoVhLNCOsXSL5t/a06VfP1CmmgXg13RDPmXb5nBs/26we+aadnB6KRWEdCQ==
X-Received: by 2002:a05:600c:3d0d:b0:397:460d:3360 with SMTP id bh13-20020a05600c3d0d00b00397460d3360mr1385860wmb.54.1653556036941;
        Thu, 26 May 2022 02:07:16 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id p36-20020a05600c1da400b003974027722csm1247492wms.47.2022.05.26.02.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 02:07:16 -0700 (PDT)
Date:   Thu, 26 May 2022 11:07:06 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     "Dawar, Gautam" <gautam.dawar@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Longpeng <longpeng2@huawei.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        "hanand@xilinx.com" <hanand@xilinx.com>
Subject: Re: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
Message-ID: <20220526090706.maf645wayelb7mcp@sgarzare-redhat>
References: <20220525105922.2413991-1-eperezma@redhat.com>
 <20220525105922.2413991-3-eperezma@redhat.com>
 <BL1PR12MB582520CC9CE024149141327499D69@BL1PR12MB5825.namprd12.prod.outlook.com>
 <CAJaqyWc9_ErCg4whLKrjNyP5z2DZno-LJm7PN=-9uk7PUT4fJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWc9_ErCg4whLKrjNyP5z2DZno-LJm7PN=-9uk7PUT4fJw@mail.gmail.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 10:57:03AM +0200, Eugenio Perez Martin wrote:
>On Wed, May 25, 2022 at 1:23 PM Dawar, Gautam <gautam.dawar@amd.com> wrote:
>>
>> [AMD Official Use Only - General]
>>
>> -----Original Message-----
>> From: Eugenio Pérez <eperezma@redhat.com>
>> Sent: Wednesday, May 25, 2022 4:29 PM
>> To: Michael S. Tsirkin <mst@redhat.com>; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org; virtualization@lists.linux-foundation.org; Jason Wang <jasowang@redhat.com>
>> Cc: Zhu Lingshan <lingshan.zhu@intel.com>; martinh@xilinx.com; Stefano Garzarella <sgarzare@redhat.com>; ecree.xilinx@gmail.com; Eli Cohen <elic@nvidia.com>; Dan Carpenter <dan.carpenter@oracle.com>; Parav Pandit <parav@nvidia.com>; Wu Zongyong <wuzongyong@linux.alibaba.com>; dinang@xilinx.com; Christophe JAILLET <christophe.jaillet@wanadoo.fr>; Xie Yongji <xieyongji@bytedance.com>; Dawar, Gautam <gautam.dawar@amd.com>; lulu@redhat.com; martinpo@xilinx.com; pabloc@xilinx.com; Longpeng <longpeng2@huawei.com>; Piotr.Uminski@intel.com; Kamde, Tanuj <tanuj.kamde@amd.com>; Si-Wei Liu <si-wei.liu@oracle.com>; habetsm.xilinx@gmail.com; lvivier@redhat.com; Zhang Min <zhang.min9@zte.com.cn>; hanand@xilinx.com
>> Subject: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
>>
>> [CAUTION: External Email]
>>
>> Userland knows if it can stop the device or not by checking this feature bit.
>>
>> It's only offered if the vdpa driver backend implements the stop() operation callback, and try to set it if the backend does not offer that callback is an error.
>>
>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>> ---
>>  drivers/vhost/vdpa.c             | 16 +++++++++++++++-
>>  include/uapi/linux/vhost_types.h |  2 ++
>>  2 files changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c index 1f1d1c425573..32713db5831d 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -347,6 +347,14 @@ static long vhost_vdpa_set_config(struct vhost_vdpa *v,
>>         return 0;
>>  }
>>
>> +static bool vhost_vdpa_can_stop(const struct vhost_vdpa *v) {
>> +       struct vdpa_device *vdpa = v->vdpa;
>> +       const struct vdpa_config_ops *ops = vdpa->config;
>> +
>> +       return ops->stop;
>> [GD>>] Would it be better to explicitly return a bool to match the return type?
>
>I'm not sure about the kernel code style regarding that casting. Maybe
>it's better to return !!ops->stop here. The macros likely and unlikely
>do that.

IIUC `ops->stop` is a function pointer, so what about

     return ops->stop != NULL;

Thanks,
Stefano

