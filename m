Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171CC54449E
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 09:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238540AbiFIHTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 03:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238571AbiFIHTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 03:19:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BCCB243BBD
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 00:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654759176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LZJhp5L1ykqWD7LdN0E4Ox3CGQKebfkP1ixyik/IJxo=;
        b=HgBstNws9Eunb5gATT8vUJOL42RYBSpfJ7bQ7F+yq9fNyHB3QjRAQDONbgRGaHdiEeJzr6
        YP4YxQOdpUr4q7ghO0ivHQ+/buVf5/Cvy9cL01N+2KjYmThhJ9zHoWyokDM3p6XQxpDvyd
        uuUzdS6e+WWyz086QWgFe6yjfANbnZI=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-QOBfTfmwO_KnMqOfXebpFA-1; Thu, 09 Jun 2022 03:19:35 -0400
X-MC-Unique: QOBfTfmwO_KnMqOfXebpFA-1
Received: by mail-lj1-f199.google.com with SMTP id b12-20020a2ebc0c000000b0025662e0a527so800851ljf.0
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 00:19:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LZJhp5L1ykqWD7LdN0E4Ox3CGQKebfkP1ixyik/IJxo=;
        b=xRPI77aJQth7pj0CvlwfuDz+e0MdSAVSJBwBaj77mUGPJ8kw95qD3xQmgnpmmjteUW
         3kazzTjRzJIG7W9/Y8ktY6EStSb0lSOdBT3xfNRUtNMXxjN+3ucbRgO38szXYHs8UoXF
         4x0QsPzmS1HE6vf3Um+M8C6d4qVuYeBPk24q6r6tNgdXZ4+GwP/czWVZnqNF/dicocBJ
         F0fsmc1qaPAg5a0g73+hF8lQ9+AdqT5JB5uTvQKDQ7pPHe7YlIK389xJQhJfN/NXgDku
         YB+ivE8k71wDzWYtSU9cYk8svzNrSQEW3fPtEpbBr94yCCRcXFEFjCJZ/sPaRb6Z4yfA
         /few==
X-Gm-Message-State: AOAM530A9i2sWMbpKC4Uau+lnlv4odo1lqqrFd7Mf8kGoRdonNrzuvND
        Xceo7zdeBnWQYMRE1aOzonHjMa+M4eG7jUsDSvzYhlaYw3WTYMRCbn5ulcSgcQk0tA49/sA5sDS
        Ix+bQieNw6ttvNCvgr/UjflKlqtfZxe9T
X-Received: by 2002:a05:651c:895:b0:250:c5ec:bc89 with SMTP id d21-20020a05651c089500b00250c5ecbc89mr60689041ljq.251.1654759173834;
        Thu, 09 Jun 2022 00:19:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzb90dNZuYzoDTn4w+qZtYw1PWxrMu4ox+V+bc3835dZlQxeb3AGEBqe4wWKmMUQZhifbzb0yqD707QLMIfw/4=
X-Received: by 2002:a05:651c:895:b0:250:c5ec:bc89 with SMTP id
 d21-20020a05651c089500b00250c5ecbc89mr60689031ljq.251.1654759173667; Thu, 09
 Jun 2022 00:19:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220603103356.26564-1-gautam.dawar@amd.com> <CACGkMEs38ycmAaDc48_rt5BeBHq4tzKH39gj=KczYFQC16ns5Q@mail.gmail.com>
 <DM4PR12MB5841EB20B82969B6D67638AF99A49@DM4PR12MB5841.namprd12.prod.outlook.com>
 <PH0PR12MB54814B1D6E884E50E5C26786DCA49@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB54814B1D6E884E50E5C26786DCA49@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 9 Jun 2022 15:19:22 +0800
Message-ID: <CACGkMEsdMzLb+JtdZ7vTmMb=jU7PpM5GaJT1uD6t_tty46x2OA@mail.gmail.com>
Subject: Re: [PATCH] vdpa: allow vdpa dev_del management operation to return failure
To:     Parav Pandit <parav@nvidia.com>
Cc:     "Dawar, Gautam" <gautam.dawar@amd.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 6:43 PM Parav Pandit <parav@nvidia.com> wrote:
>
>
> > From: Dawar, Gautam <gautam.dawar@amd.com>
> > Sent: Wednesday, June 8, 2022 6:30 AM
> > To: Jason Wang <jasowang@redhat.com>
> > Cc: netdev <netdev@vger.kernel.org>; linux-net-drivers (AMD-Xilinx) <linux-
> > net-drivers@amd.com>; Anand, Harpreet <harpreet.anand@amd.com>;
> > Michael S. Tsirkin <mst@redhat.com>; Zhu Lingshan
> > <lingshan.zhu@intel.com>; Xie Yongji <xieyongji@bytedance.com>; Eli
> > Cohen <elic@nvidia.com>; Parav Pandit <parav@nvidia.com>; Si-Wei Liu <si-
> > wei.liu@oracle.com>; Stefano Garzarella <sgarzare@redhat.com>; Wan
> > Jiabing <wanjiabing@vivo.com>; Dan Carpenter
> > <dan.carpenter@oracle.com>; virtualization <virtualization@lists.linux-
> > foundation.org>; linux-kernel <linux-kernel@vger.kernel.org>
> > Subject: RE: [PATCH] vdpa: allow vdpa dev_del management operation to
> > return failure
> >
> > [AMD Official Use Only - General]
> >
> > Hi Gautam:
> > [GD>>] Hi Jason,
> >
> > On Fri, Jun 3, 2022 at 6:34 PM Gautam Dawar <gautam.dawar@amd.com>
> > wrote:
> > >
> > > Currently, the vdpa_nl_cmd_dev_del_set_doit() implementation allows
> > > returning a value to depict the operation status but the return type
> > > of dev_del() callback is void. So, any error while deleting the vdpa
> > > device in the vdpa parent driver can't be returned to the management
> > > layer.
> >
> > I wonder under which cognition we can hit an error in dev_del()?
> > [GD>>] In the AMD-Xilinx vDPA driver, on receiving vdpa device deletion
> > request, I try to identify if the vdpa device is in use by any virtio-net driver
> > (through any vdpa bus driver) by looking at the vdpa device status value. In
> > case the vdpa device status is >= VIRTIO_CONFIG_S_DRIVER, -EBUSY is
> > returned.
> > This is to avoid side-effects as noted in
> > https://bugzilla.kernel.org/show_bug.cgi?id=213179 caused by deleting the
> > vdpa device when it is being used.
> > >
> User should be able to delete the device anytime.

It requires a poll event to user space and then Qemu can release the
vhost-vDPA device. This is how VFIO works. We probably need to
implement something like this.

But notice that, at the worst case, usersapce may not respond to this
event, so there's nothing more kenrel can do execpt for waiting.

We need to consider something different. I used to have an idea to
make vhost-vdpa couple with vDPA loosely with SRCU/RCU. We might
consider implementing that.

> Upper layers who are unable to perform teardown sequence should be fixed.

I think we probably don't need to bother with failing the dev_del().
We can consider to fix/workaround the waiting first.

Thanks

