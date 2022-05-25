Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5E65336DA
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 08:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244200AbiEYGoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 02:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244186AbiEYGoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 02:44:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A06565DA2D
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 23:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653461045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q0dTaNHuL4SUBlxpiPP30yUP0V2S131GhNnsHFSLPKs=;
        b=CTr44IoGGXMZ2ibqlsIvlQJH+oW8HthHWkADWXizzX8aVXAZJhK8koFTn4jicbAxl3WLE4
        Zj+iXolJnVkOEhzt2OsHSplnAV6/tTQlCCrRaYTf2qbLIkeKAu5QIbsZQdoNnvdziS0zX+
        X/0C7QcaAowgj6/suzUdXXMT2sK9Imw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-h_bOBfxROFuuo0PHbC1rGg-1; Wed, 25 May 2022 02:44:04 -0400
X-MC-Unique: h_bOBfxROFuuo0PHbC1rGg-1
Received: by mail-qt1-f198.google.com with SMTP id c1-20020ac81101000000b002f9219952f0so9622555qtj.15
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 23:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q0dTaNHuL4SUBlxpiPP30yUP0V2S131GhNnsHFSLPKs=;
        b=rziX72GxsxvGlQEzrtJhUxxy9CP8f+MZ3II5ivSywFfUEJo4zCclX73Bhvlmj/flX5
         xJK2DLST8ZszKtpOPprXfGJPs9A0cvhwrQ5tZKTo4EwXYVEcdtPksit0e9I8AHcdG+63
         GJ8cNm/rKib0yuN5oSaX/obewwI5XECYMwLaEOiNlfb5x1c+/zFouieYCbcn/hgCe0hW
         s9oWkrJfNl0yalWiirZwtp+tykolgNRG1ernkRK6VaznGYKCBer1yyNLZGfYfLkHRYLy
         EWhrTJ2atZDCqrXaeqXtQ8d/7AlUNvWas/3iPmnV5siLks4K8emHbgL3abTKP3his0Dk
         En9Q==
X-Gm-Message-State: AOAM530273Yapd2L6uvW87u8RFpoqo2bKYQKbXBzT64Jx4Ps0DFA17hN
        5IxWSdJVHfdDImwXGnyHf/z2Wg/g0a+OU59jNDHnMyhNGSIWEZo2BPJUned6rcCetgSFdqZImTP
        lF1gqfzJlcqhVhZoZGE1p5uIgV7ZLxIWn
X-Received: by 2002:a05:620a:40c4:b0:6a2:e166:c7e3 with SMTP id g4-20020a05620a40c400b006a2e166c7e3mr20156514qko.486.1653461043998;
        Tue, 24 May 2022 23:44:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzBnli9BMJnOwkhuFIoRR7C+Xyp7bTitLcsl+I7WPStVvlJFXCRpVWtTCUfc3ivMsRtC2VLRXsg8ONEOvPReo=
X-Received: by 2002:a05:620a:40c4:b0:6a2:e166:c7e3 with SMTP id
 g4-20020a05620a40c400b006a2e166c7e3mr20156497qko.486.1653461043733; Tue, 24
 May 2022 23:44:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220524170610.2255608-1-eperezma@redhat.com> <20220524170610.2255608-4-eperezma@redhat.com>
 <CACGkMEsZSTgsgYkg5HhpJ62pKFTr6mtiNwYJa8E+r4RMTRuU8A@mail.gmail.com>
In-Reply-To: <CACGkMEsZSTgsgYkg5HhpJ62pKFTr6mtiNwYJa8E+r4RMTRuU8A@mail.gmail.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 25 May 2022 08:43:27 +0200
Message-ID: <CAJaqyWdxjmDVX4DQOdW90mkW_-MbP7AtK+Q_KdrsU0=nRdtGXQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] vhost-vdpa: uAPI to stop the device
To:     Jason Wang <jasowang@redhat.com>
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 4:51 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Wed, May 25, 2022 at 1:06 AM Eugenio P=C3=A9rez <eperezma@redhat.com> =
wrote:
> >
> > The ioctl adds support for stop the device from userspace.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >  drivers/vhost/vdpa.c       | 18 ++++++++++++++++++
> >  include/uapi/linux/vhost.h |  3 +++
> >  2 files changed, 21 insertions(+)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 32713db5831d..a5d33bad92f9 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -478,6 +478,21 @@ static long vhost_vdpa_get_vqs_count(struct vhost_=
vdpa *v, u32 __user *argp)
> >         return 0;
> >  }
> >
> > +static long vhost_vdpa_stop(struct vhost_vdpa *v, u32 __user *argp)
> > +{
> > +       struct vdpa_device *vdpa =3D v->vdpa;
> > +       const struct vdpa_config_ops *ops =3D vdpa->config;
> > +       int stop;
> > +
> > +       if (!ops->stop)
> > +               return -EOPNOTSUPP;
> > +
> > +       if (copy_from_user(&stop, argp, sizeof(stop)))
> > +               return -EFAULT;
> > +
> > +       return ops->stop(vdpa, stop);
> > +}
> > +
> >  static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int =
cmd,
> >                                    void __user *argp)
> >  {
> > @@ -650,6 +665,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *=
filep,
> >         case VHOST_VDPA_GET_VQS_COUNT:
> >                 r =3D vhost_vdpa_get_vqs_count(v, argp);
> >                 break;
> > +       case VHOST_STOP:
> > +               r =3D vhost_vdpa_stop(v, argp);
> > +               break;
> >         default:
> >                 r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
> >                 if (r =3D=3D -ENOIOCTLCMD)
> > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > index cab645d4a645..e7526968ab0c 100644
> > --- a/include/uapi/linux/vhost.h
> > +++ b/include/uapi/linux/vhost.h
> > @@ -171,4 +171,7 @@
> >  #define VHOST_VDPA_SET_GROUP_ASID      _IOW(VHOST_VIRTIO, 0x7C, \
> >                                              struct vhost_vring_state)
> >
> > +/* Stop or resume a device so it does not process virtqueue requests a=
nymore */
> > +#define VHOST_STOP                     _IOW(VHOST_VIRTIO, 0x7D, int)
> > +
>
> Unless we know it's a vhost general uAPI, let's use VHOST_VDPA_STOP here.
>

Ok I'll rename.

Thanks!

> Thanks
>
> >  #endif
> > --
> > 2.27.0
> >
>

