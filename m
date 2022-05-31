Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31368538AFA
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 07:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244060AbiEaFm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 01:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244053AbiEaFm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 01:42:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F356814A6
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 22:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653975745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lXZqQ2bmpu17MD3xsKbd7SyCjtmA473Yqjdy/U/0t2k=;
        b=E1Cq1ovd0CLRlsOhvKEviLrm/vuqquqjrG8c42oco/HiAPbS1gpJosjyjtMaQ0NcBD4diB
        DDcw16aJUYMjPeCp5DGjJ9I2B1O1a+84Nshi5euTfZ25t/F0zK3hGxiTJjJ5+FTHPl2dgL
        +khuSlLlHteDHgBRw9/sO4RtbhBdAOs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-wRJMy9O7OsmzZbGYkH2jVA-1; Tue, 31 May 2022 01:42:16 -0400
X-MC-Unique: wRJMy9O7OsmzZbGYkH2jVA-1
Received: by mail-wm1-f71.google.com with SMTP id m10-20020a05600c3b0a00b003948b870a8dso850510wms.2
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 22:42:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lXZqQ2bmpu17MD3xsKbd7SyCjtmA473Yqjdy/U/0t2k=;
        b=5QcG9bXkVrI9p5KbSEEO2XBCAshGA217j4F9bre5sSIgYgYlfLDbfT9bxLkff2k1Mg
         rOJe8rnVjZ1ou1/Jui68Lh2KVXX3MjXoTIXQ8r0+gKfilFeLtASkPtt+gIVCirW+I6nD
         8s1MXW3ZT9vCdSBRRu7AJuRH8Q87lU+kbpNgOyWtMwiOaFdhU4A/3DhWXRoFTWA8G7AN
         D8jXsRgvcv6XCLpcsmEEtjFxEyYlfqL82G0RDedWho6ctuu2ESaCwmCOqHb8+9p0OcdQ
         zVflbtmf/Rd5s1xvCjPVDVdqmRQmiC1YRoob5kNd2ZUh5HWWKumEMxW1KVYWfE7ruAh4
         bsKQ==
X-Gm-Message-State: AOAM533etyz2ByUUJvB6iZf43YkAakR5lwhAVv+KuPicEfrS7EInRQFT
        OCbrhSiprK39NGnKNOQHM29QZGuvTsmAItQvPKfpotLdSyIBpzAE5grsDVxNlO76GIMlTYoOpdn
        hs01nCLv5PTHDFW12
X-Received: by 2002:a5d:5984:0:b0:20f:f3a1:fc56 with SMTP id n4-20020a5d5984000000b0020ff3a1fc56mr26938591wri.718.1653975734740;
        Mon, 30 May 2022 22:42:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdE+qW9FBh7CyCXbLKMzMHLR0yj20nkiIZGrztEDmjYsCEbIiQpOmR1K3n4oHtOPy/6V+v4A==
X-Received: by 2002:a5d:5984:0:b0:20f:f3a1:fc56 with SMTP id n4-20020a5d5984000000b0020ff3a1fc56mr26938567wri.718.1653975734469;
        Mon, 30 May 2022 22:42:14 -0700 (PDT)
Received: from redhat.com ([2.52.157.68])
        by smtp.gmail.com with ESMTPSA id e9-20020a5d5949000000b002103136623esm5160877wri.85.2022.05.30.22.42.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 22:42:13 -0700 (PDT)
Date:   Tue, 31 May 2022 01:42:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>, martinpo@xilinx.com,
        lvivier@redhat.com, pabloc@xilinx.com,
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
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
Message-ID: <20220531014108-mutt-send-email-mst@kernel.org>
References: <20220526124338.36247-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220526124338.36247-1-eperezma@redhat.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 02:43:34PM +0200, Eugenio Pérez wrote:
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
> 
> After the return of ioctl with stop == 0, the device can continue
> processing buffers as long as typical conditions are met (vq is enabled,
> DRIVER_OK status bit is enabled, etc).
> 
> In the future, we will provide features similar to VHOST_USER_GET_INFLIGHT_FD
> so the device can save pending operations.
> 
> Comments are welcome.


So given this is just for simulator and affects UAPI I think it's fine
to make it wait for the next merge window, until there's a consensus.
Right?

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
>   vdpa: Add stop operation
>   vhost-vdpa: introduce STOP backend feature bit
>   vhost-vdpa: uAPI to stop the device
>   vdpa_sim: Implement stop vdpa op
> 
>  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++
>  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
>  drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
>  drivers/vhost/vdpa.c                 | 34 +++++++++++++++++++++++++++-
>  include/linux/vdpa.h                 |  6 +++++
>  include/uapi/linux/vhost.h           | 14 ++++++++++++
>  include/uapi/linux/vhost_types.h     |  2 ++
>  8 files changed, 83 insertions(+), 1 deletion(-)
> 
> -- 
> 2.31.1
> 

