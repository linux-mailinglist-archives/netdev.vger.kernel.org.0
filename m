Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28001532452
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 09:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiEXHmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 03:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiEXHmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 03:42:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C05F6EC58
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 00:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653378165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xr0lHvjXTVWXEeMcpfBHikGqMQxP8Brjy+Y5r5qUUtk=;
        b=ZVLaeawmXC3KZGRg2OWYidAXhTcuuo9CeMvFvsgXf6SiJx6G9EWYUtLCZ7BXd4G9npZ1b0
        1l6NYdJjv6O+V8LnnzOrSK7z0TNZ6bXf/Ou64cJfemmxMK7b0QLPf35I3LubdWmvLMgCGS
        WpshDWj/mRt+TQ93TrAUsRKWM1I3z3w=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-136-0hp_AvYSNNmr_9fZlcDR-Q-1; Tue, 24 May 2022 03:42:43 -0400
X-MC-Unique: 0hp_AvYSNNmr_9fZlcDR-Q-1
Received: by mail-qt1-f198.google.com with SMTP id l20-20020ac81494000000b002f91203eeacso10452077qtj.10
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 00:42:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xr0lHvjXTVWXEeMcpfBHikGqMQxP8Brjy+Y5r5qUUtk=;
        b=eXJ2a5OvR2n+ocGKfyMXmjmRubpgs5YRdtaakAfmDYAZagdbk2vOgtd++XsDhmqKXi
         8Amm8B/IkxqoS9hZQf4ZUV0izuJvEjtAELMsfAGinKwj/18cPkiSWSvWAKvl8qldUEOU
         24Kr9yYPV6d20w94oOEYC/Vam4lcfkyIzvoPJ9Cn9EYvMN6FxvQhnI11Aqmsz3IWpvDt
         uNsBdGaEYxvH8ZJyWqDC/Q7ck9DvoaQie419xrv6nGX9uU9KmSwGG28SZ5WJ3lg42N8y
         pshTrp7EiDjMZTWrzmECfgXfTaD5PMubyodPkFQamGfjfuxEYj09cz1PIMpLuPIiyuS3
         JE1A==
X-Gm-Message-State: AOAM530Ws4btU2lM3mq9i7pMAPmdRBo5/p459jVk+APQFYW8Ae99kPZC
        iBAFNFxFsXYxC0bDkE+oauA8sGVumprZRco91zVgeWQVCZ/NQ3Izs/xTOvW9ayrZ3zS+QXfX0dz
        8hYd6hKjv/AjYNgzi9Zr5ZPHBfuSMTRfg
X-Received: by 2002:a05:622a:110c:b0:2f3:d347:6f8d with SMTP id e12-20020a05622a110c00b002f3d3476f8dmr19024566qty.403.1653378162795;
        Tue, 24 May 2022 00:42:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZwara4ZmEInMFe1WFL9gKd2OmNz8F+sra8z+TxWhKQWbJJN2UQupe5aSNcHPJXZgH8axKvjIUqARkW1ymK/g=
X-Received: by 2002:a05:622a:110c:b0:2f3:d347:6f8d with SMTP id
 e12-20020a05622a110c00b002f3d3476f8dmr19024558qty.403.1653378162580; Tue, 24
 May 2022 00:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220520172325.980884-1-eperezma@redhat.com> <20220520172325.980884-2-eperezma@redhat.com>
 <79089dc4-07c4-369b-826c-1c6e12edcaff@oracle.com> <CAJaqyWd3BqZfmJv+eBYOGRwNz3OhNKjvHPiFOafSjzAnRMA_tQ@mail.gmail.com>
 <20220524070900.ak7a5frwtezjhhrq@sgarzare-redhat>
In-Reply-To: <20220524070900.ak7a5frwtezjhhrq@sgarzare-redhat>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Tue, 24 May 2022 09:42:06 +0200
Message-ID: <CAJaqyWeiNWnWUzEUEo8HeuuF8XMPtKw9SapxLxLJECWJ0zNTUA@mail.gmail.com>
Subject: Re: [PATCH 1/4] vdpa: Add stop operation
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Longpeng <longpeng2@huawei.com>,
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 9:09 AM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> On Mon, May 23, 2022 at 09:20:14PM +0200, Eugenio Perez Martin wrote:
> >On Sat, May 21, 2022 at 12:13 PM Si-Wei Liu <si-wei.liu@oracle.com> wrot=
e:
> >>
> >>
> >>
> >> On 5/20/2022 10:23 AM, Eugenio P=C3=A9rez wrote:
> >> > This operation is optional: It it's not implemented, backend feature=
 bit
> >> > will not be exposed.
> >> >
> >> > Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> >> > ---
> >> >   include/linux/vdpa.h | 6 ++++++
> >> >   1 file changed, 6 insertions(+)
> >> >
> >> > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> >> > index 15af802d41c4..ddfebc4e1e01 100644
> >> > --- a/include/linux/vdpa.h
> >> > +++ b/include/linux/vdpa.h
> >> > @@ -215,6 +215,11 @@ struct vdpa_map_file {
> >> >    * @reset:                  Reset device
> >> >    *                          @vdev: vdpa device
> >> >    *                          Returns integer: success (0) or error =
(< 0)
> >> > + * @stop:                    Stop or resume the device (optional, b=
ut it must
> >> > + *                           be implemented if require device stop)
> >> > + *                           @vdev: vdpa device
> >> > + *                           @stop: stop (true), not stop (false)
> >> > + *                           Returns integer: success (0) or error =
(< 0)
> >> Is this uAPI meant to address all use cases described in the full blow=
n
> >> _F_STOP virtio spec proposal, such as:
> >>
> >> --------------%<--------------
> >>
> >> ...... the device MUST finish any in flight
> >> operations after the driver writes STOP.  Depending on the device, it
> >> can do it
> >> in many ways as long as the driver can recover its normal operation
> >> if it
> >> resumes the device without the need of resetting it:
> >>
> >> - Drain and wait for the completion of all pending requests until a
> >>    convenient avail descriptor. Ignore any other posterior descriptor.
> >> - Return a device-specific failure for these descriptors, so the drive=
r
> >>    can choose to retry or to cancel them.
> >> - Mark them as done even if they are not, if the kind of device can
> >>    assume to lose them.
> >> --------------%<--------------
> >>
> >
> >Right, this is totally underspecified in this series.
> >
> >I'll expand on it in the next version, but that text proposed to
> >virtio-comment was complicated and misleading. I find better to get
> >the previous version description. Would the next description work?
> >
> >```
> >After the return of ioctl, the device MUST finish any pending operations=
 like
> >in flight requests. It must also preserve all the necessary state (the
> >virtqueue vring base plus the possible device specific states) that is r=
equired
> >for restoring in the future.
>
> For block devices wait for all in-flight requests could take several
> time.
>
> Could this be a problem if the caller gets stuck on this ioctl?
>
> If it could be a problem, maybe we should use an eventfd to signal that
> the device is successfully stopped.
>

For that particular problem I'd very much prefer to add directly an
ioctl to get the inflight descriptors. We know for sure we will need
them, and it will be cleaner in the long run.

As I understand the vdpa block simulator, there is no need to return
the inflight descriptors since all of the requests are processed in a
synchronous way. So, for this iteration, we could offer the stop
feature to qemu.

Other non-simulated devices would need it. Could it be delayed to
future development?

Thanks!

> Thanks,
> Stefano
>

