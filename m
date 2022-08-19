Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7740459921D
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 02:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345936AbiHSA6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 20:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345726AbiHSA5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 20:57:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78063DF4D4
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660870669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uuQp/54kzUA0HT/STCK8ZUpvoW2Mnly/Q6xJfw5TSjY=;
        b=AA4fjvuWDWnMRE0B56XLJvABLgbMXp+A3L46ESNhT4B5eVReak+YtyE+u5Dg0TC9Iy55vr
        eerOjHa+vacWUsG/bweK+oUsacb9M+mUu3i/r0ceKyg5mKftkSbAgw2HNwMTJ4kDne9GDF
        zPhNNJ/mf1g2CrtsZvYSfcTdU+HZ7CI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-669-gCpOaePzP-e8BpoVw3D3dw-1; Thu, 18 Aug 2022 20:57:40 -0400
X-MC-Unique: gCpOaePzP-e8BpoVw3D3dw-1
Received: by mail-lf1-f69.google.com with SMTP id z1-20020a0565120c0100b0048ab2910b13so978804lfu.23
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:57:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=uuQp/54kzUA0HT/STCK8ZUpvoW2Mnly/Q6xJfw5TSjY=;
        b=QiAZxd0GyAH6KehZ5UThykWZuFjumhe8GZJDNp5xrTg46SfT9Fr7HE9vk9ARWCyb1S
         P3EhW42a8J3i8avE5mPzUmnxohphVX9h5W6Po8tkq/GNj/MZivfKGBShpDm5RGYrVK4k
         ehYe8oxq7DgINzNf0Rn3Kta+3aJGgVrh4GY2j2qh3AncPnVtUl3y3SieeP8FrDbbloSR
         mmOzgYFPLTTjICE/M031CuiqYBKSdUwszn7xM5OIYyyYPuZVgmWgk7I0Q8Cxo3zXUCFx
         E514IOfGvXm8yfujBXDYVolXjT6osXmI98UaaxI1kjOZjbYGGFXedlQkEunWVQtXHchb
         Ue7w==
X-Gm-Message-State: ACgBeo0jWDo9nrkDgqxcLV73hdoCHWYB+UR7fKfCWCEPRbq7PknNrh8N
        K4jYNWLYpKR8H0RWVzSn7VdjB9TZoqh8H4aSrD9IzTq3ea4AZEjcGSBWeLctq4NNtsqO0NPaKgS
        3Gr7qfHuHKDn0VxC7kl/phii0Lvt0Gkav
X-Received: by 2002:a05:651c:2103:b0:25d:6478:2a57 with SMTP id a3-20020a05651c210300b0025d64782a57mr1520452ljq.496.1660870659361;
        Thu, 18 Aug 2022 17:57:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5NBBg5Ds9XUeFrJ5XIbbNo4QBFxzNKUMH/CyMN4Jn/ghuXR8mPIUiifAo/bM5oS9vi+A6u9mAf/95LI1LMrdo=
X-Received: by 2002:a05:651c:2103:b0:25d:6478:2a57 with SMTP id
 a3-20020a05651c210300b0025d64782a57mr1520433ljq.496.1660870659177; Thu, 18
 Aug 2022 17:57:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220811135353.2549658-1-eperezma@redhat.com> <20220811135353.2549658-4-eperezma@redhat.com>
In-Reply-To: <20220811135353.2549658-4-eperezma@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 19 Aug 2022 08:57:28 +0800
Message-ID: <CACGkMEvDTky2y_ngUJp69Wt=1hq3U=LeSdnzEj=oYJxh+jTrOQ@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] vhost: Remove invalid parameter of
 VHOST_VDPA_SUSPEND ioctl
To:     =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, ecree.xilinx@gmail.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        "Uminski, Piotr" <Piotr.Uminski@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Laurent Vivier <lvivier@redhat.com>,
        Martin Porter <martinpo@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Eli Cohen <elic@nvidia.com>, Cindy Lu <lulu@redhat.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Xie Yongji <xieyongji@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 9:54 PM Eugenio P=C3=A9rez <eperezma@redhat.com> wr=
ote:
>
> It was a leftover from previous versions.
>
> Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
> Note that I'm not sure this removal is valid. The ioctl is not in master
> branch by the send date of this patch, but there are commits on vhost
> branch that do have it.
> ---
>  include/uapi/linux/vhost.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 89fcb2afe472..768ec46a88bf 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -178,6 +178,6 @@
>   * the possible device specific states) that is required for restoring i=
n the
>   * future. The device must not change its configuration after that point=
.
>   */
> -#define VHOST_VDPA_SUSPEND             _IOW(VHOST_VIRTIO, 0x7D, int)
> +#define VHOST_VDPA_SUSPEND             _IO(VHOST_VIRTIO, 0x7D)
>
>  #endif
> --
> 2.31.1
>

