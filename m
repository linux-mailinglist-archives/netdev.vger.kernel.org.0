Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3278A5713E7
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 10:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiGLIEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 04:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbiGLIEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 04:04:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3366B1FF
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657613077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zk3S2xAdR/7hGTN3JMUGrzoWncg4Rn0Aa+mjreKRU3I=;
        b=bZoYJ2sTqT4JUS0NwctzuTELgu4CD2qWiT5xGgF+bKi4U2PNRTiq5M5UwDRyDb8XIJ+Z2i
        TNJHfsa+9f1GeXsJ4DrxYu31hGvZEc4gO3qomYJ+wO/H9vn6RlnF2TUyqR9uwAUPs8O0G2
        wzFK1XcQR2TP2L+xHBjId439jbwanvs=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-unlCr2-wN12rv3_DRB9j1w-1; Tue, 12 Jul 2022 04:04:36 -0400
X-MC-Unique: unlCr2-wN12rv3_DRB9j1w-1
Received: by mail-lf1-f70.google.com with SMTP id e10-20020a19674a000000b0047f8d95f43cso3296835lfj.0
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:04:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Zk3S2xAdR/7hGTN3JMUGrzoWncg4Rn0Aa+mjreKRU3I=;
        b=AguDBxaK5D3ZR+2F1bNYaILjX83wPiVgw6867+Eps3DmeWvVR4idqAsHyLw1vxGdLX
         OmxElsoikKyAJWG5PfkXViMReIujNiTmTzpq//OOKC7ETBYqLukfHRZWNJe9/1gpEL2l
         l4jzTrTXhKW4UYJkLqyVc9TKBuK0SOWQYLM4/tLmAiLTqsKDk4vj2nnnPlL2uQ1ooKgR
         nCbHGX7oZ4jLPc7T8AdBEFogyLALF2YItOOLBlqUC+LNf6cf71fY7UMbwOJQQm7SzaWP
         VFXZN0XCY4LQ7uiSlJzegrsfCrqd4D6+6pbs1pgubRyPVOsHlqJK1lSb9IgiXgFp4+h5
         u46Q==
X-Gm-Message-State: AJIora9G/coh9+z7n1esaQcv01BT0DYVGskx3XRVtv0dNJCmVnSLqhYv
        lkxa5Sc0svlqXre/tVNiPJvxGaSfyiIoTbwMR32po0XpFV9dJoPRnI9ufdRajo3pedXAKADjTQJ
        grP9v/xbyNmUcHwjRKUaZYfcVvX0FwDXt
X-Received: by 2002:a05:6512:3b8e:b0:481:1a75:452 with SMTP id g14-20020a0565123b8e00b004811a750452mr15293720lfv.238.1657613075126;
        Tue, 12 Jul 2022 01:04:35 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vFL+N9RzhXFr/ks5hqi5WjMGbUNrOhsaPrmrfRg/JxZpXDwQSu5M2XKsRZPR3L6Fkftxrqt8icOOXsoZFhCZE=
X-Received: by 2002:a05:6512:3b8e:b0:481:1a75:452 with SMTP id
 g14-20020a0565123b8e00b004811a750452mr15293702lfv.238.1657613074923; Tue, 12
 Jul 2022 01:04:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220623160738.632852-1-eperezma@redhat.com> <20220623160738.632852-2-eperezma@redhat.com>
 <CACGkMEv+yFLCzo-K7eSaVPJqLCa5SxfVCmB=piQ3+6R3=oDz-w@mail.gmail.com> <CAJaqyWcsesMV5DSs7sCrsJmZX=QED7p7UXa_7H=1UHfQTnKS6w@mail.gmail.com>
In-Reply-To: <CAJaqyWcsesMV5DSs7sCrsJmZX=QED7p7UXa_7H=1UHfQTnKS6w@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 12 Jul 2022 16:04:23 +0800
Message-ID: <CACGkMEsr=2LjU1-UDV1SF9vJPty2003YKORHZMSr1W-p9eNr+A@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] vdpa: Add suspend operation
To:     Eugenio Perez Martin <eperezma@redhat.com>
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
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 8, 2022 at 7:31 PM Eugenio Perez Martin <eperezma@redhat.com> w=
rote:
>
> On Wed, Jun 29, 2022 at 6:10 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Fri, Jun 24, 2022 at 12:07 AM Eugenio P=C3=A9rez <eperezma@redhat.co=
m> wrote:
> > >
> > > This operation is optional: It it's not implemented, backend feature =
bit
> > > will not be exposed.
> >
> > A question, do we allow suspending a device without DRIVER_OK?
> >
>
> That should be invalid. In particular, vdpa_sim will resume in that
> case, but I guess it would depend on the device.

Yes, and that will match our virtio spec patch (STOP bit).

>
> Do you think it should be controlled in the vdpa frontend code?

The vdpa bus should validate this at least.

Thanks

>
> Thanks!
>
> > Thanks
> >
> > >
> > > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > ---
> > >  include/linux/vdpa.h | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> > > index 7b4a13d3bd91..d282f464d2f1 100644
> > > --- a/include/linux/vdpa.h
> > > +++ b/include/linux/vdpa.h
> > > @@ -218,6 +218,9 @@ struct vdpa_map_file {
> > >   * @reset:                     Reset device
> > >   *                             @vdev: vdpa device
> > >   *                             Returns integer: success (0) or error=
 (< 0)
> > > + * @suspend:                   Suspend or resume the device (optiona=
l)
> > > + *                             @vdev: vdpa device
> > > + *                             Returns integer: success (0) or error=
 (< 0)
> > >   * @get_config_size:           Get the size of the configuration spa=
ce includes
> > >   *                             fields that are conditional on featur=
e bits.
> > >   *                             @vdev: vdpa device
> > > @@ -319,6 +322,7 @@ struct vdpa_config_ops {
> > >         u8 (*get_status)(struct vdpa_device *vdev);
> > >         void (*set_status)(struct vdpa_device *vdev, u8 status);
> > >         int (*reset)(struct vdpa_device *vdev);
> > > +       int (*suspend)(struct vdpa_device *vdev);
> > >         size_t (*get_config_size)(struct vdpa_device *vdev);
> > >         void (*get_config)(struct vdpa_device *vdev, unsigned int off=
set,
> > >                            void *buf, unsigned int len);
> > > --
> > > 2.31.1
> > >
> >
>

