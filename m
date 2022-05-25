Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94BD533572
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 04:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243669AbiEYCt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 22:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbiEYCt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 22:49:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21812703CF
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653446995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ElTuX9jWxfL0CUwfGnyHCc3cXorhj0tUDVKXC9Pq5yE=;
        b=SCsFvErvjB569gHhEv8qQXK/cvYp4munxTKrceCZ4ZonnBY+omeKA1L2/IcbPlL0EodUAc
        H0FZf9Amkatu87aHrv8BlfZekH5SrTJSyeVQsfxd2AalOxnndN0IcpOFLNqja39HRkUMZS
        /X03vhEpapmdK93QSD80fPkWw5KfQwc=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-Toi4OS8TPKGdHDmMzXgVng-1; Tue, 24 May 2022 22:49:53 -0400
X-MC-Unique: Toi4OS8TPKGdHDmMzXgVng-1
Received: by mail-lf1-f69.google.com with SMTP id u13-20020a05651206cd00b00477c7503103so8387528lff.15
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:49:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ElTuX9jWxfL0CUwfGnyHCc3cXorhj0tUDVKXC9Pq5yE=;
        b=z27v/IePBLEnndifuFY4dasX95NLFIbzAjZFdBv2gwNJqwmCffgZ9lwT/ZeAI9jGK7
         kLMDn7rqDBq7yrXvRCZCVNGEpqmg1RNMfRrim4cZ+x05TIrGnUmRk7X/JrtAkvQ55edT
         ZdHB39JLKqPFR8/RRO9j+9EFVKJzgieTw4txfWU1Ku4bYVzm8wLq5DmkrWr1SoWSFPwS
         5mV/SSHeyaGH0Xgq2QrZHAz55VtccM0L5FyQdxXCBJ+wvZPW05D0MR2DvBc7+RMBysKz
         5UADjIYbFE6AuDj2Uh9dZpchtFjuWJE+vexIjKCfcI7G5nvwCBerZBAjgH9UP6DjnMyb
         nb9A==
X-Gm-Message-State: AOAM533XKPwrrfhNQkZE0WlWRtCtG6FEjN21uxGNx11Sne8nUBNzs10X
        3tvzFQTMgZv5i+y8VH+ait8T0A9YX0ZqWa49Cx+WFgdemuDdWyrsryUJ5Cle4QgV34em3fjmp07
        hjUXrTHDMEjV+xCqI+boct8svUczE6irZ
X-Received: by 2002:a2e:81c1:0:b0:24b:f44:3970 with SMTP id s1-20020a2e81c1000000b0024b0f443970mr17702589ljg.97.1653446992149;
        Tue, 24 May 2022 19:49:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwaAlxsbkHduKZFbcUP9Q8h4gtKP25cQ1tcIPf8o5riuG1dRzo29yaMgKzd1IjazP5PKoJ9oIdwVR4fFRKu26Q=
X-Received: by 2002:a2e:81c1:0:b0:24b:f44:3970 with SMTP id
 s1-20020a2e81c1000000b0024b0f443970mr17702581ljg.97.1653446991974; Tue, 24
 May 2022 19:49:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220524170610.2255608-1-eperezma@redhat.com>
In-Reply-To: <20220524170610.2255608-1-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 25 May 2022 10:49:40 +0800
Message-ID: <CACGkMEvHRL7a6njivA0+ae-+nXUB9Dng=oaQny0cHu-Ra+bcFg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Implement vdpasim stop operation
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        habetsm.xilinx@gmail.com, Eli Cohen <elic@nvidia.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Cindy Lu <lulu@redhat.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        ecree.xilinx@gmail.com, "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Martin Porter <martinpo@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Longpeng <longpeng2@huawei.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 1:06 AM Eugenio P=C3=A9rez <eperezma@redhat.com> wr=
ote:
>
> Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
> that backend feature and userspace can effectively stop the device.
>
> This is a must before get virtqueue indexes (base) for live migration,
> since the device could modify them after userland gets them. There are
> individual ways to perform that action for some devices
> (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
> way to perform it for any vhost device (and, in particular, vhost-vdpa).
>
> After the return of ioctl with stop !=3D 0, the device MUST finish any
> pending operations like in flight requests. It must also preserve all
> the necessary state (the virtqueue vring base plus the possible device
> specific states) that is required for restoring in the future. The
> device must not change its configuration after that point.

I'd suggest documenting this in the code maybe around ops->stop()?

Thanks

>
> After the return of ioctl with stop =3D=3D 0, the device can continue
> processing buffers as long as typical conditions are met (vq is enabled,
> DRIVER_OK status bit is enabled, etc).
>
> In the future, we will provide features similar to VHOST_USER_GET_INFLIGH=
T_FD
> so the device can save pending operations.
>
> Comments are welcome.
>
> v2:
> * Replace raw _F_STOP with BIT_ULL(_F_STOP).
> * Fix obtaining of stop ioctl arg (it was not obtained but written).
> * Add stop to vdpa_sim_blk.
>
> Eugenio P=C3=A9rez (4):
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
>  include/uapi/linux/vhost.h           |  3 +++
>  include/uapi/linux/vhost_types.h     |  2 ++
>  8 files changed, 72 insertions(+), 1 deletion(-)
>
> --
> 2.27.0
>
>

