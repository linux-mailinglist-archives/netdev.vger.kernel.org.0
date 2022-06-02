Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83C953B58C
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 10:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbiFBI6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 04:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiFBI6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 04:58:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4FE771F1BEE
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 01:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654160300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EA4sjAo0s1UJhwaoiLkeLMjmAdZWjnEWcCJT8pCAuaE=;
        b=fIjSgMY9CNqSJwSskJwSv5bPvCdAjvwYapZku0k4pZNnIKIxN9hYJNytyFno7TqORW8RpX
        9VJ+mA1iebuD1VkAZC9IsuCp96QAfkor/7V+4NPJtQuwhM63Hi3pRanzkbaeVsr5mY3xnr
        uFHobasZBHdbKDA8VVdMbq1XBNPNppA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-5j8DFtcgOp6VTx1TdNW7jg-1; Thu, 02 Jun 2022 04:58:19 -0400
X-MC-Unique: 5j8DFtcgOp6VTx1TdNW7jg-1
Received: by mail-qk1-f200.google.com with SMTP id bj2-20020a05620a190200b005084968bb24so3194114qkb.23
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 01:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EA4sjAo0s1UJhwaoiLkeLMjmAdZWjnEWcCJT8pCAuaE=;
        b=zyw/k3DA1dgHrXdgm8ZvCg2m49+fScAzPrnB8gHHGTlKhwMUltHKldoC9EHM6fZtOB
         64XrJHwwWudGyW1R31xu4ssqgHcoNTcUmY82PXlxUp7I9mJaH3aQq+buspyuE/wbnXlz
         JpQUtBb8PCkw29T/EhL3x7lbIhOXSDyltqIC9/ubOpPooM0szT6WQLtCUIhfQ7FX6RGD
         sY7kSK21qEEnBsYgkoptI1mGU4x2R1D92Xq5F9qmtIpSMvkNqyxA279qcghPCM+e2lp6
         KRv+CHI0Mn31B3+stIbVW0+C3zmmW5i+5uFgLZopNTnSgWvJUJ3THCfC5vekGRmuCbL7
         NZPg==
X-Gm-Message-State: AOAM532gGTBGz5Zt8870KegcP3D02da8/rrzGIG43dcCPrRk2ff1+PHJ
        qJYHsS7knvEBB/vb1Ourr9jxxsUV8D0v1AqYiEs9Azp3Upb4LH3SkirNU+JqAOrm/rFmQ+22Ykd
        Z2JnWDD2XU/E4a3ZT2YT1/0BMxPtgjabe
X-Received: by 2002:a05:620a:1a07:b0:6a5:dac2:6703 with SMTP id bk7-20020a05620a1a0700b006a5dac26703mr2393927qkb.522.1654160299010;
        Thu, 02 Jun 2022 01:58:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAbj14F2a0s/ukphMQnuAJbi7nfAYfJ691JlPmplBlmLbS6ZLZsowsOZJyyZbccM3oVxpWmpjcPAFKx4b2sdQ=
X-Received: by 2002:a05:620a:1a07:b0:6a5:dac2:6703 with SMTP id
 bk7-20020a05620a1a0700b006a5dac26703mr2393906qkb.522.1654160298779; Thu, 02
 Jun 2022 01:58:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220527065442-mutt-send-email-mst@kernel.org> <CACGkMEubfv_OJOsJ_ROgei41Qx4mPO0Xz8rMVnO8aPFiEqr8rA@mail.gmail.com>
 <PH0PR12MB5481695930E7548BAAF1B0D9DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEsSKF_MyLgFdzVROptS3PCcp1y865znLWgnzq9L7CpFVQ@mail.gmail.com>
 <PH0PR12MB5481CAA3F57892FF7F05B004DCDF9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEsJJL34iUYQMxHguOV2cQ7rts+hRG5Gp3XKCGuqNdnNQg@mail.gmail.com> <PH0PR12MB5481D099A324C91DAF01259BDCDE9@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481D099A324C91DAF01259BDCDE9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 2 Jun 2022 10:57:42 +0200
Message-ID: <CAJaqyWfNZa2XTXaiohbPreZ6-wbEmOC6P2cHrw_3ms-JNDbGmw@mail.gmail.com>
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
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 4:59 AM Parav Pandit <parav@nvidia.com> wrote:
>
>
> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Wednesday, June 1, 2022 10:00 PM
> >
> > On Thu, Jun 2, 2022 at 2:58 AM Parav Pandit <parav@nvidia.com> wrote:
> > >
> > >
> > > > From: Jason Wang <jasowang@redhat.com>
> > > > Sent: Tuesday, May 31, 2022 10:42 PM
> > > >
> > > > Well, the ability to query the virtqueue state was proposed as
> > > > another feature (Eugenio, please correct me). This should be
> > > > sufficient for making virtio-net to be live migrated.
> > > >
> > > The device is stopped, it won't answer to this special vq config done here.
> >
> > This depends on the definition of the stop. Any query to the device state
> > should be allowed otherwise it's meaningless for us.
> >
> > > Programming all of these using cfg registers doesn't scale for on-chip
> > memory and for the speed.
> >
> > Well, they are orthogonal and what I want to say is, we should first define
> > the semantics of stop and state of the virtqueue.
> >
> > Such a facility could be accessed by either transport specific method or admin
> > virtqueue, it totally depends on the hardware architecture of the vendor.
> >
> I find it hard to believe that a vendor can implement a CVQ but not AQ and chose to expose tens of hundreds of registers.
> But maybe, it fits some specific hw.
>
> I like to learn the advantages of such method other than simplicity.
>
> We can clearly that we are shifting away from such PCI registers with SIOV, IMS and other scalable solutions.
> virtio drifting in reverse direction by introducing more registers as transport.
> I expect it to an optional transport like AQ.
>
> > >
> > > Next would be to program hundreds of statistics of the 64 VQs through a
> > giant PCI config space register in some busy polling scheme.
> >
> > We don't need giant config space, and this method has been implemented
> > by some vDPA vendors.
> >
> There are tens of 64-bit counters per VQs. These needs to programmed on destination side.
> Programming these via registers requires exposing them on the registers.
> In one of the proposals, I see them being queried via CVQ from the device.
>
> Programming them via cfg registers requires large cfg space or synchronous programming until receiving ACK from it.
> This means one entry at a time...
>
> Programming them via CVQ needs replicate and align cmd values etc on all device types. All duplicate and hard to maintain.
>

I think this discussion should be moved to the proposals on
virtio-comment. In the vdpa context, they should be covered.

This one is about exposing the basic facility of stopping and resuming
a device to userland, and it fits equally well if the device
implements it via cfg registers, via admin vq, via channel I/O, or via
whatever transport the vdpa backend prefers. To ask for the state is
already covered in the vhost layer, and this proposal does not affect
it.

Given the flexibility of vdpa, we can even ask vq state using
backend-specific methods, cache it (knowing that there will be no
change of them until resume or DRIVER_OK), and expose them to qemu
using config space interface or any other batch method. Same as with
the enable_vq problem. And the same applies to stats. And we maintain
compatibility with all vendor-specific control plane.

Would that work for devices that cannot or does not want to expose
them via config space?

Thanks!

>
> > >
> > > I can clearly see how all these are inefficient for faster LM.
> > > We need an efficient AQ to proceed with at minimum.
> >
> > I'm fine with admin virtqueue, but the stop and state are orthogonal to that.
> > And using admin virtqueue for stop/state will be more natural if we use
> > admin virtqueue as a transport.
> Ok.
> We should have defined it bit earlier that all vendors can use. :(

