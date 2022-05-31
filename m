Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57708538B7F
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 08:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244342AbiEaGon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 02:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244336AbiEaGom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 02:44:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 009A06D87E
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 23:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653979480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R09ZW9VvFl8cGzXr9uGNwD7esbAV/wMjvzPFPmxSk1k=;
        b=aTRwrWhlf9d0cxbazaIxKp8s16DGJZb641Ipe+RjYrmq5FmRNHFSPri69ldzBprc+z5m5b
        9iMwAN+p10yXRoMglZJHPUNwEHMRf5hgTEw+7mzEC94GKZ7epGJ7z1LqbkRkic2i18jUF6
        DzrYKlGh+1Gyw/bW8YAUa3aUU2ZIAIM=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-ijxsao8LOuioiVyiLe9Skw-1; Tue, 31 May 2022 02:44:38 -0400
X-MC-Unique: ijxsao8LOuioiVyiLe9Skw-1
Received: by mail-lj1-f199.google.com with SMTP id 1-20020a2e1641000000b00255569ac874so315908ljw.12
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 23:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R09ZW9VvFl8cGzXr9uGNwD7esbAV/wMjvzPFPmxSk1k=;
        b=Uj7RCP+TDcaJK2luygimIyQzjXmyvInT1pG45eXpXxEWGxDnj4kseivWXl+ZlHX3+s
         mJImzfKmvXA7WXdzgBPAt9yEsmhpmZp53+XXmUl3slLEOqy7XQuT686U91o734a/0sc2
         OBM4mVbGjAHihr/brVmTb4Hq3QaF/sZdu+uVg7rtMpblPvCCeH0p610MvzLs85loRNez
         5PYf8VciDlFfADnsdmii8VgC10WSqJRchXsxc61x35Kl8rBQL2wsZH4eL8uzhl4NbnA3
         HP35JIMQ6z5JC2Rh/5Q2172/PFxypipp11nrSlhAQje31/VC8Ow1/xk15zvBC4Dl1ilu
         W7Aw==
X-Gm-Message-State: AOAM532vVKrYmqS5CgzB9YgDfNfAkSVq9YKzBri5LIRPCeujEjsbhbCg
        nsxZi1vMsFX8TNhAzZ7yWsoDGoCZOCb85UqfUNhjy6xtuMT1YXBSzqC0RP4AbRX6hFSJhXn7VR/
        2Nx8GX0LtAtBxbefgdOMXWB0J1vJGh1uP
X-Received: by 2002:a05:6512:128e:b0:478:681c:18d8 with SMTP id u14-20020a056512128e00b00478681c18d8mr32302247lfs.190.1653979477104;
        Mon, 30 May 2022 23:44:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzb9MwkuGePNI9NXoXjO6wTh5Ss6nTswP5TQltBWqHApUqXR5peoNrnh/Uhl83sh1tUvY9O28tBGfW9/BSXTk4=
X-Received: by 2002:a05:6512:128e:b0:478:681c:18d8 with SMTP id
 u14-20020a056512128e00b00478681c18d8mr32302209lfs.190.1653979476807; Mon, 30
 May 2022 23:44:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220527065442-mutt-send-email-mst@kernel.org> <CACGkMEubfv_OJOsJ_ROgei41Qx4mPO0Xz8rMVnO8aPFiEqr8rA@mail.gmail.com>
 <20220531013913-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220531013913-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 31 May 2022 14:44:25 +0800
Message-ID: <CACGkMEuC29vaBPi7jDED3DzxPuZZx2hrUmtEUv4UWSdTM5AcFQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 1:40 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, May 30, 2022 at 11:39:21AM +0800, Jason Wang wrote:
> > On Fri, May 27, 2022 at 6:56 PM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> > >
> > > On Thu, May 26, 2022 at 12:54:32PM +0000, Parav Pandit wrote:
> > > >
> > > >
> > > > > From: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > > > Sent: Thursday, May 26, 2022 8:44 AM
> > > >
> > > > > Implement stop operation for vdpa_sim devices, so vhost-vdpa will=
 offer
> > > > >
> > > > > that backend feature and userspace can effectively stop the devic=
e.
> > > > >
> > > > >
> > > > >
> > > > > This is a must before get virtqueue indexes (base) for live migra=
tion,
> > > > >
> > > > > since the device could modify them after userland gets them. Ther=
e are
> > > > >
> > > > > individual ways to perform that action for some devices
> > > > >
> > > > > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there
> > > > > was no
> > > > >
> > > > > way to perform it for any vhost device (and, in particular, vhost=
-vdpa).
> > > > >
> > > > >
> > > > >
> > > > > After the return of ioctl with stop !=3D 0, the device MUST finis=
h any
> > > > >
> > > > > pending operations like in flight requests. It must also preserve=
 all
> > > > >
> > > > > the necessary state (the virtqueue vring base plus the possible d=
evice
> > > > >
> > > > > specific states) that is required for restoring in the future. Th=
e
> > > > >
> > > > > device must not change its configuration after that point.
> > > > >
> > > > >
> > > > >
> > > > > After the return of ioctl with stop =3D=3D 0, the device can cont=
inue
> > > > >
> > > > > processing buffers as long as typical conditions are met (vq is e=
nabled,
> > > > >
> > > > > DRIVER_OK status bit is enabled, etc).
> > > >
> > > > Just to be clear, we are adding vdpa level new ioctl() that doesn=
=E2=80=99t map to any mechanism in the virtio spec.
> > > >
> > > > Why can't we use this ioctl() to indicate driver to start/stop the =
device instead of driving it through the driver_ok?
> > > > This is in the context of other discussion we had in the LM series.
> > >
> > > If there's something in the spec that does this then let's use that.
> >
> > Actually, we try to propose a independent feature here:
> >
> > https://lists.oasis-open.org/archives/virtio-dev/202111/msg00020.html
> >
> > Does it make sense to you?
> >
> > Thanks
>
> But I thought the LM patches are trying to replace all that?

I'm not sure, and actually I think they are orthogonal. We need a new
state and the command to set the state could be transport specific or
a virtqueue.

As far as I know, most of the vendors have implemented this semantic.

Thanks

>
>
> > > Unfortunately the LM series seems to be stuck on moving
> > > bits around with the admin virtqueue ...
> > >
> > > --
> > > MST
> > >
>

