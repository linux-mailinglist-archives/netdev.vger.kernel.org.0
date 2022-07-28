Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B012583641
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 03:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbiG1BWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 21:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbiG1BWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 21:22:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2664AB49E
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 18:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658971333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1Znmlu63Erey1IsixFqUUX+KxOGTKzA8el4/bq2d5M=;
        b=SFsJFk1u1cYPNtQ3o8Vged3hmv2PVMXFIqPBbiR37jICVr7YK2Tcv9TKY77z0Q91OR8rk6
        061aB7rERUJEOxxN4Ts+vfRo5dE/a3xiVFyvtMSwKZ7F3+J0fdG+auO6iUQb18hQ4dpgEH
        +y6UIbaBWz7Y9SQIFh7n7RuqV2LxaKQ=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-RMGhoMXkNiW_OIF_j4aVqg-1; Wed, 27 Jul 2022 21:22:04 -0400
X-MC-Unique: RMGhoMXkNiW_OIF_j4aVqg-1
Received: by mail-lf1-f71.google.com with SMTP id c15-20020ac244af000000b0048a8421d969so167213lfm.19
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 18:22:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J1Znmlu63Erey1IsixFqUUX+KxOGTKzA8el4/bq2d5M=;
        b=ymiHQPdsD//xs3C1fGFPHmIOf6CXxMqe0MD3S9iRZygARfM8J0cQpMXX1XkATxAREu
         JJ1Tt/iLOB0U1UXByyHegmkJJMWsWJ92SZ2rz+0Ok5hAFsvRtvjfmGBTSP51Q16hf82B
         Kl6l+8rHrCh2B3R47w13dHSdYj8tlZkj89ZUbwSjaRwb894v2QVf+d9mgfwS6FGfViWE
         QSGPtVm779xAUV0JzYrLhpksDeNL/V4SkuThL5cetw1bD1kVMl/7ZTni83CwQY8KHAQH
         Mfa65L9VjPEE4pASdzfUlZV7sH5h0QL3b7/UaPLdfJG7CCWmqno/r3hDqHmyGDMa3IVN
         AmjA==
X-Gm-Message-State: AJIora9MEcI20/N8PiwInvRsf2rMYscutVfTJuZxeU0sqWswEYYpFLgb
        GPukD8E+En1De3nx3jbHGnKiEBN3JCpn93Fo2CZ72dTBaefCABuurDUB1eYAtdJ7dAePz7i34Hh
        pSQvZWtXbeywcI+Jdt03p6g1LLZK7JN/4
X-Received: by 2002:a05:6512:b0d:b0:481:5cb4:cf1e with SMTP id w13-20020a0565120b0d00b004815cb4cf1emr8766414lfu.442.1658971322975;
        Wed, 27 Jul 2022 18:22:02 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t5yxyiTp0u/B4D6tJQ9YC9z6eOVv3G44gn3eTDZDSpBH6d3EYrhhZbn+OQ28uEDHkdipKpVfwdWTOZZhVPwD4=
X-Received: by 2002:a05:6512:b0d:b0:481:5cb4:cf1e with SMTP id
 w13-20020a0565120b0d00b004815cb4cf1emr8766401lfu.442.1658971322340; Wed, 27
 Jul 2022 18:22:02 -0700 (PDT)
MIME-Version: 1.0
References: <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com> <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com> <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org> <CACGkMEv62tuOP3ra0GBhjCH=syFWxP+GVfGL_i0Ce0iD4uMY=Q@mail.gmail.com>
 <20220727050222-mutt-send-email-mst@kernel.org> <CACGkMEtDFUGX17giwYdF58QJ1ccZJDJg1nFVDkSeB27sfZz28g@mail.gmail.com>
 <20220727114419-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220727114419-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 28 Jul 2022 09:21:51 +0800
Message-ID: <CACGkMEv80RTtuyw5RtwgTHUphS1s2oTeb94tc6Tx7LbJWKsEBw@mail.gmail.com>
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 11:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Wed, Jul 27, 2022 at 05:50:59PM +0800, Jason Wang wrote:
> > On Wed, Jul 27, 2022 at 5:03 PM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> > >
> > > On Wed, Jul 27, 2022 at 02:54:13PM +0800, Jason Wang wrote:
> > > > On Wed, Jul 27, 2022 at 2:01 PM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
> > > > >
> > > > > On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
> > > > > >
> > > > > > > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > > > Sent: Tuesday, July 26, 2022 10:53 PM
> > > > > > >
> > > > > > > On 7/27/2022 10:17 AM, Parav Pandit wrote:
> > > > > > > >> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > > > >> Sent: Tuesday, July 26, 2022 10:15 PM
> > > > > > > >>
> > > > > > > >> On 7/26/2022 11:56 PM, Parav Pandit wrote:
> > > > > > > >>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > > > > >>>> Sent: Tuesday, July 12, 2022 11:46 PM
> > > > > > > >>>>> When the user space which invokes netlink commands, det=
ects that
> > > > > > > >> _MQ
> > > > > > > >>>> is not supported, hence it takes max_queue_pair =3D 1 by=
 itself.
> > > > > > > >>>> I think the kernel module have all necessary information=
 and it is
> > > > > > > >>>> the only one which have precise information of a device,=
 so it
> > > > > > > >>>> should answer precisely than let the user space guess. T=
he kernel
> > > > > > > >>>> module should be reliable than stay silent, leave the qu=
estion to
> > > > > > > >>>> the user space
> > > > > > > >> tool.
> > > > > > > >>> Kernel is reliable. It doesn=E2=80=99t expose a config sp=
ace field if the
> > > > > > > >>> field doesn=E2=80=99t
> > > > > > > >> exist regardless of field should have default or no defaul=
t.
> > > > > > > >> so when you know it is one queue pair, you should answer o=
ne, not try
> > > > > > > >> to guess.
> > > > > > > >>> User space should not guess either. User space gets to se=
e if _MQ
> > > > > > > >> present/not present. If _MQ present than get reliable data=
 from kernel.
> > > > > > > >>> If _MQ not present, it means this device has one VQ pair.
> > > > > > > >> it is still a guess, right? And all user space tools imple=
mented this
> > > > > > > >> feature need to guess
> > > > > > > > No. it is not a guess.
> > > > > > > > It is explicitly checking the _MQ feature and deriving the =
value.
> > > > > > > > The code you proposed will be present in the user space.
> > > > > > > > It will be uniform for _MQ and 10 other features that are p=
resent now and
> > > > > > > in the future.
> > > > > > > MQ and other features like RSS are different. If there is no =
_RSS_XX, there
> > > > > > > are no attributes like max_rss_key_size, and there is not a d=
efault value.
> > > > > > > But for MQ, we know it has to be 1 wihtout _MQ.
> > > > > > "we" =3D user space.
> > > > > > To keep the consistency among all the config space fields.
> > > > >
> > > > > Actually I looked and the code some more and I'm puzzled:
> > > > >
> > > > >
> > > > >         struct virtio_net_config config =3D {};
> > > > >         u64 features;
> > > > >         u16 val_u16;
> > > > >
> > > > >         vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config)=
);
> > > > >
> > > > >         if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(co=
nfig.mac),
> > > > >                     config.mac))
> > > > >                 return -EMSGSIZE;
> > > > >
> > > > >
> > > > > Mac returned even without VIRTIO_NET_F_MAC
> > > > >
> > > > >
> > > > >         val_u16 =3D le16_to_cpu(config.status);
> > > > >         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> > > > >                 return -EMSGSIZE;
> > > > >
> > > > >
> > > > > status returned even without VIRTIO_NET_F_STATUS
> > > > >
> > > > >         val_u16 =3D le16_to_cpu(config.mtu);
> > > > >         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> > > > >                 return -EMSGSIZE;
> > > > >
> > > > >
> > > > > MTU returned even without VIRTIO_NET_F_MTU
> > > > >
> > > > >
> > > > > What's going on here?
> > > >
> > > > Probably too late to fix, but this should be fine as long as all
> > > > parents support STATUS/MTU/MAC.
> > >
> > > Why is this too late to fix.
> >
> > If we make this conditional on the features. This may break the
> > userspace that always expects VDPA_ATTR_DEV_NET_CFG_MTU?
> >
> > Thanks
>
> Well only on devices without MTU. I'm saying said userspace
> was reading trash on such devices anyway.

It depends on the parent actually. For example, mlx5 query the lower
mtu unconditionally:

        err =3D query_mtu(mdev, &mtu);
        if (err)
                goto err_alloc;

        ndev->config.mtu =3D cpu_to_mlx5vdpa16(mvdev, mtu);

Supporting MTU features seems to be a must for real hardware.
Otherwise the driver may not work correctly.

> We don't generally maintain bug for bug compatiblity on a whim,
> only if userspace is actually known to break if we fix a bug.

 So I think it should be fine to make this conditional then we should
have a consistent handling of other fields like MQ.

Thanks

>
>
> > >
> > > > I wonder if we can add a check in the core and fail the device
> > > > registration in this case.
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > >
> > > > > --
> > > > > MST
> > > > >
> > >
>

