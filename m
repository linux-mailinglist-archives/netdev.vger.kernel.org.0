Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61B35319BE
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiEWTe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 15:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbiEWTeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 15:34:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAE3FED8F3
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 12:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653333652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zWR/65+oFrS++PJq66ZLNcU/040MXlKMFoYaFMveteY=;
        b=SVgT4tJq6EuYxMqOni3bnCyQ8nE3rfJs9HYn9J5eVni97QqF2TmrtgY2iBAUhAgsX83TZ2
        EdQEwPfDvIUmBLThKwXsxXD5PGiXt23BMzZfzm2AwjIvsobAlWgZozVPE+u6pC34yLnsQs
        RAX8jPJJHxH24yRYFuOf88yZHQilTcA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-jCNTl-99PyGUPOD2LGiE_A-1; Mon, 23 May 2022 15:20:51 -0400
X-MC-Unique: jCNTl-99PyGUPOD2LGiE_A-1
Received: by mail-qt1-f199.google.com with SMTP id x11-20020ac87ecb000000b002f92dbff915so4449946qtj.20
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 12:20:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zWR/65+oFrS++PJq66ZLNcU/040MXlKMFoYaFMveteY=;
        b=7oblscVIrJZSZoT92j9Z6dzyZx70QU45lAvTECE+4ppC7xxQ1iZ/inAYBpgptCfWO9
         BEZ2Ys4ZfFSngFde9mfoVnQ0RvLHnfm5XBljyxz8VuqbFxuRxKSlRHpOpRDswC/1MoGb
         ux5aq9MGiJFpVuTO/cpa/G4u32XZzoNPGsDp1Gi6o8TocqbQrrZlWYhFkVcWCMpl3IIK
         RybbsKAKiEOt9uIt5b2X+r7NLP936WSngb3KSKreREjYZ61e4s7iDLNt69y/rU5yXhld
         JEdU/DvcbkvVByDrm818fSs4gE64Vu3g2vD0ysA0lWhbI2iG7In1SHqqNRL5ho/zW7mO
         F6ag==
X-Gm-Message-State: AOAM530x/cYhSwAcrdoxRpWNdqtjY9uklwRYDtCHlZu2+vAtt9DpR4+P
        2QItLzAt3cS1x8naXc2aCvk7wdKIXjbPlvNpsK4+n3HgAhBYne8anacxzD41f8UI5ze0ocguWcG
        yWJmAhm3f1edadiTKRfw8Mr3LLhV5n7VO
X-Received: by 2002:a05:6214:400e:b0:462:5d6:5f47 with SMTP id kd14-20020a056214400e00b0046205d65f47mr15539468qvb.70.1653333650650;
        Mon, 23 May 2022 12:20:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFyoP5/0B3Uy836hFsQ5iz3pMKHomotpQ9pBk3F6XbfZPUBccGpKF4IoCu573jKQhm3W8E8iTgO2exVS/bklI=
X-Received: by 2002:a05:6214:400e:b0:462:5d6:5f47 with SMTP id
 kd14-20020a056214400e00b0046205d65f47mr15539444qvb.70.1653333650380; Mon, 23
 May 2022 12:20:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220520172325.980884-1-eperezma@redhat.com> <20220520172325.980884-2-eperezma@redhat.com>
 <79089dc4-07c4-369b-826c-1c6e12edcaff@oracle.com>
In-Reply-To: <79089dc4-07c4-369b-826c-1c6e12edcaff@oracle.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 23 May 2022 21:20:14 +0200
Message-ID: <CAJaqyWd3BqZfmJv+eBYOGRwNz3OhNKjvHPiFOafSjzAnRMA_tQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] vdpa: Add stop operation
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>, dinang@xilinx.com,
        Eli Cohen <elic@nvidia.com>,
        Laurent Vivier <lvivier@redhat.com>, pabloc@xilinx.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Xie Yongji <xieyongji@bytedance.com>, habetsm.xilinx@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, Cindy Lu <lulu@redhat.com>,
        ecree.xilinx@gmail.com, Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
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

On Sat, May 21, 2022 at 12:13 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>
>
>
> On 5/20/2022 10:23 AM, Eugenio P=C3=A9rez wrote:
> > This operation is optional: It it's not implemented, backend feature bi=
t
> > will not be exposed.
> >
> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > ---
> >   include/linux/vdpa.h | 6 ++++++
> >   1 file changed, 6 insertions(+)
> >
> > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> > index 15af802d41c4..ddfebc4e1e01 100644
> > --- a/include/linux/vdpa.h
> > +++ b/include/linux/vdpa.h
> > @@ -215,6 +215,11 @@ struct vdpa_map_file {
> >    * @reset:                  Reset device
> >    *                          @vdev: vdpa device
> >    *                          Returns integer: success (0) or error (< =
0)
> > + * @stop:                    Stop or resume the device (optional, but =
it must
> > + *                           be implemented if require device stop)
> > + *                           @vdev: vdpa device
> > + *                           @stop: stop (true), not stop (false)
> > + *                           Returns integer: success (0) or error (< =
0)
> Is this uAPI meant to address all use cases described in the full blown
> _F_STOP virtio spec proposal, such as:
>
> --------------%<--------------
>
> ...... the device MUST finish any in flight
> operations after the driver writes STOP.  Depending on the device, it
> can do it
> in many ways as long as the driver can recover its normal operation if it
> resumes the device without the need of resetting it:
>
> - Drain and wait for the completion of all pending requests until a
>    convenient avail descriptor. Ignore any other posterior descriptor.
> - Return a device-specific failure for these descriptors, so the driver
>    can choose to retry or to cancel them.
> - Mark them as done even if they are not, if the kind of device can
>    assume to lose them.
> --------------%<--------------
>

Right, this is totally underspecified in this series.

I'll expand on it in the next version, but that text proposed to
virtio-comment was complicated and misleading. I find better to get
the previous version description. Would the next description work?

```
After the return of ioctl, the device MUST finish any pending operations li=
ke
in flight requests. It must also preserve all the necessary state (the
virtqueue vring base plus the possible device specific states) that is requ=
ired
for restoring in the future.

In the future, we will provide features similar to VHOST_USER_GET_INFLIGHT_=
FD
so the device can save pending operations.
```

Thanks for pointing it out!





> E.g. do I assume correctly all in flight requests are flushed after
> return from this uAPI call? Or some of pending requests may be subject
> to loss or failure? How does the caller/user specify these various
> options (if there are) for device stop?
>
> BTW, it would be nice to add the corresponding support to vdpa_sim_blk
> as well to demo the stop handling. To just show it on vdpa-sim-net IMHO
> is perhaps not so convincing.
>
> -Siwei
>
> >    * @get_config_size:                Get the size of the configuration=
 space includes
> >    *                          fields that are conditional on feature bi=
ts.
> >    *                          @vdev: vdpa device
> > @@ -316,6 +321,7 @@ struct vdpa_config_ops {
> >       u8 (*get_status)(struct vdpa_device *vdev);
> >       void (*set_status)(struct vdpa_device *vdev, u8 status);
> >       int (*reset)(struct vdpa_device *vdev);
> > +     int (*stop)(struct vdpa_device *vdev, bool stop);
> >       size_t (*get_config_size)(struct vdpa_device *vdev);
> >       void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> >                          void *buf, unsigned int len);
>

