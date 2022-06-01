Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79FD553A33B
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 12:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352342AbiFAKtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 06:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352325AbiFAKtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 06:49:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF524E0E3
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 03:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654080545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T5n9A4eLifr47qhHLRf9Kq7hYcEBfD03DgfdoZ0OcNA=;
        b=Uk1uvFgUXEo7skN5DF4HSeE4BQl9i3HmwsuRPo0FBTd8uH236zDXBSAA0C3JwMqLi9Ti5d
        3wL5XqhxO+jyEmbiYw0oZHox7OOEsEadhYucimV9lNum3W0UUjwtVG2c10ETkHlGh/K0vu
        1ubdZx0bRI2n4M6aNCgDvtQNet5flhs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-G_DyauNGO2ujKMUZlimW6g-1; Wed, 01 Jun 2022 06:49:04 -0400
X-MC-Unique: G_DyauNGO2ujKMUZlimW6g-1
Received: by mail-qv1-f72.google.com with SMTP id kj4-20020a056214528400b0044399a9bb4cso1059746qvb.15
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 03:49:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T5n9A4eLifr47qhHLRf9Kq7hYcEBfD03DgfdoZ0OcNA=;
        b=YpdVm7BOOeAwGALKiuSAAJbK1n5KTKMA6B6dnP17uGUtI/aEP7wTFwh45coImk3uk6
         xJlZhFz7ckPW8tOGUxynnEnI4AdTSlTxsYJocqvDzN9/qNFxhfLVqluH0A9Q+WCbdkDA
         7mW7ARVVTg3hR6xe+ltuqVJdikHVbvBHSqToKkjxlruqnIJAWrnAl1qviQBnxEem3DWu
         6WlSw6PcmL2/6j6dfBMcOWAVY8ozE3/rk5IeB3+eowzlIrCdKwRlFExgkoYAkvzq9xci
         t66ZGIPPvLUcu+MilaipiN24Gr2jQfQALv1vYygj3t9Nn9wvXho7xr0jeV7BzqkDUbJ6
         yd8w==
X-Gm-Message-State: AOAM531JUj+OCOAx/ocSGuAKRHVKCzW+4PmtkzKfwtAJ6AWnK2Z3r6kt
        pPSQi+sy+HaOh6DJ7M5VMxqLtocB2ZSUTQ3x5Ubfr43ADyIK36mBdCrAvR8bn04V+MBYH3ojwpd
        aPJ/tsbJsAvcCozaZRiFO2ov+U6zxwJYx
X-Received: by 2002:a0c:fe48:0:b0:462:6a02:a17d with SMTP id u8-20020a0cfe48000000b004626a02a17dmr27671545qvs.108.1654080544241;
        Wed, 01 Jun 2022 03:49:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydnMnL2CGtfHvsmGsOMtRegKBWrDanbK1aFihPp/xsHxn9Wq3Oqc+JoLCDAIVDJM7yrsBugSDtOndvdK+IpM0=
X-Received: by 2002:a0c:fe48:0:b0:462:6a02:a17d with SMTP id
 u8-20020a0cfe48000000b004626a02a17dmr27671514qvs.108.1654080544026; Wed, 01
 Jun 2022 03:49:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEu1YenjBHAssP=FvKX6WxDQ5Aa50r-BsnkfR4zqNTk6hg@mail.gmail.com>
 <CAJaqyWfzoORc7V=xqdyLsdRPRYGNJBvWaPcZDhOb1vJWhbixoA@mail.gmail.com> <PH0PR12MB54813940FE5AC483C4676F24DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB54813940FE5AC483C4676F24DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 1 Jun 2022 12:48:27 +0200
Message-ID: <CAJaqyWejR8M1sgNtJmWbDGKp2rMZO2rHZP_syqqJxVMiHfXLUQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 10:26 PM Parav Pandit <parav@nvidia.com> wrote:
>
>
>
> > From: Eugenio Perez Martin <eperezma@redhat.com>
> > Sent: Friday, May 27, 2022 3:55 AM
> >
> > On Fri, May 27, 2022 at 4:26 AM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > > On Thu, May 26, 2022 at 8:54 PM Parav Pandit <parav@nvidia.com> wrote=
:
> > > >
> > > >
> > > >
> > > > > From: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > > > Sent: Thursday, May 26, 2022 8:44 AM
> > > >
> > > > > Implement stop operation for vdpa_sim devices, so vhost-vdpa will
> > > > > offer
> > > > >
> > > > > that backend feature and userspace can effectively stop the devic=
e.
> > > > >
> > > > >
> > > > >
> > > > > This is a must before get virtqueue indexes (base) for live
> > > > > migration,
> > > > >
> > > > > since the device could modify them after userland gets them. Ther=
e
> > > > > are
> > > > >
> > > > > individual ways to perform that action for some devices
> > > > >
> > > > > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but
> > there
> > > > > was no
> > > > >
> > > > > way to perform it for any vhost device (and, in particular, vhost=
-vdpa).
> > > > >
> > > > >
> > > > >
> > > > > After the return of ioctl with stop !=3D 0, the device MUST finis=
h
> > > > > any
> > > > >
> > > > > pending operations like in flight requests. It must also preserve
> > > > > all
> > > > >
> > > > > the necessary state (the virtqueue vring base plus the possible
> > > > > device
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
> > > > > processing buffers as long as typical conditions are met (vq is
> > > > > enabled,
> > > > >
> > > > > DRIVER_OK status bit is enabled, etc).
> > > >
> > > > Just to be clear, we are adding vdpa level new ioctl() that doesn=
=E2=80=99t map to
> > any mechanism in the virtio spec.
> > >
> > > We try to provide forward compatibility to VIRTIO_CONFIG_S_STOP. That
> > > means it is expected to implement at least a subset of
> > > VIRTIO_CONFIG_S_STOP.
> > >
> >
> > Appending a link to the proposal, just for reference [1].
> >
> > > >
> > > > Why can't we use this ioctl() to indicate driver to start/stop the =
device
> > instead of driving it through the driver_ok?
> > >
> >
> > Parav, I'm not sure I follow you here.
> >
> > By the proposal, the resume of the device is (From qemu POV):
> > 1. To configure all data vqs and cvq (addr, num, ...) 2. To enable only=
 CVQ, not
> > data vqs 3. To send DRIVER_OK 4. Wait for all buffers of CVQ to be used=
 5. To
> > enable all others data vqs (individual ioctl at the moment)
> >
> > Where can we fit the resume (as "stop(false)") here? If the device is s=
topped
> > (as if we send stop(true) before DRIVER_OK), we don't read CVQ first. I=
f we
> > send it right after (or instead) DRIVER_OK, data buffers can reach data=
 vqs
> > before configuring RSS.
> >
> It doesn=E2=80=99t make sense with currently proposed way of using cvq to=
 replay the config.

The stop/resume part is not intended to restore the config through the
CVQ. The stop call is issued to be able to retrieve the vq status
(base, in vhost terminology). The symmetric operation (resume) was
added on demand, it was never intended to be part neither of the
config restore or the virtqueue state restore workflow.

The configuration restore workflow was modelled after the device
initialization, so each part needed to add the less things the better,
and only qemu needed to be changed. From the device POV, there is no
need to learn new tricks for this. The support of .set_vq_ready and
.get_vq_ready is already in the kernel in every vdpa backend driver.

> Need to continue with currently proposed temporary method that subsequent=
ly to be replaced with optimized flow as we discussed.

Back then, it was noted by you that enabling each data vq individually
after DRIVER_OK is slow on mlx5 devices. The solution was to batch
these enable calls accounting in the kernel, achieving no growth in
the vdpa uAPI layer. The proposed solution did not involve the resume
operation.

After that, you proposed in this thread "Why can't we use this ioctl()
to indicate driver to start/stop the device instead of driving it
through the driver_ok?". As I understand, that is a mistake, since it
requires the device, the vdpa layer, etc... to learn new tricks. It
requires qemu to duplicate the initialization layer (it's now common
for start and restore config). But I might have not seen the whole
picture, missing advantages of using the resume call for this
workflow. Can you describe the workflow you have in mind? How does
that new workflow affect this proposal?

I'm ok to change the proposal as long as we find we obtain a net gain.

Thanks!

