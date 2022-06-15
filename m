Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB1154BF42
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 03:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbiFOB3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 21:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239774AbiFOB3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 21:29:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60DA72DAAE
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 18:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655256546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gPcslwf6/5AipVOiJxjFuNmMuJiLjP5Ai/xX9fViRS4=;
        b=DpBHjvSSVCQ9DRDWlNnU8z8yZTBzTiarNl1qc8W2X4vjEvgmFoIhWagMR+fsynKeLFQQqB
        j1OVpHognpp4iCtHRnddKdrXCOONkKPcSlg1E9c39ST1FnQKdBSVQOYW/Reg4av/DHMNe1
        92kM/VHPM5Sv1X8wMngl89um008Uc04=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-166Te67GOuadGIvEshjp9g-1; Tue, 14 Jun 2022 21:29:02 -0400
X-MC-Unique: 166Te67GOuadGIvEshjp9g-1
Received: by mail-lj1-f199.google.com with SMTP id k5-20020a2e6f05000000b002555a5d11e4so1564315ljc.18
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 18:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gPcslwf6/5AipVOiJxjFuNmMuJiLjP5Ai/xX9fViRS4=;
        b=JN67/BGOI77o6WCRlP7zemP7v6IOG3ja2Zs5/zVEuK0+IUIy8Ayzeyr9bqzrtdpIog
         1mq5s9cxPU3Sazqiza+sRR+S5Hf7DqHGRpZS1jNvQWFL9LfBXgYg7NlfE43uDw/wgphn
         TkKvrbOvLzIu0YxF4VqCvVz81drgCbSgR9OlZkHPNqZvlFYM9bp+f6EysEqRHTXiRthd
         ARtT4psRHKD6M0snf18DLtb8MTSa7h6lpfuyFxOyF+lnZS7U0Ulva3ekSzDUCFOr2rqh
         eTXxDQsDqH0OWbkpbZRKOAUWYSkc6ssFcTKzcQe1MylURrVS7K/JUUZNviV7FZxYXxYc
         83dA==
X-Gm-Message-State: AJIora/IQ5rqyguifK6UbyDPjdDH3AG7Yh7sovzMelre2wMQMeslJNvq
        8JUIyLTOPFqLOkxGK0Sv4zAfxAy9OP3vDAdR1x0B/GXGEgvf3hqysZX8ipqLnevnxhkMgDbR610
        tA0KwS7cMZ4MPBkcF9ZVYt69j4UAvcU8e
X-Received: by 2002:a19:4352:0:b0:479:5d1:3fef with SMTP id m18-20020a194352000000b0047905d13fefmr4549845lfj.411.1655256541080;
        Tue, 14 Jun 2022 18:29:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzy6G17S6B/NL5asgkhJ3N6qCPtMcJgm4jIUP9oxu6MOto7+cw1fHjnYuylfVl22jAQ1SwvKuEFSnQqUE0b/Qw=
X-Received: by 2002:a19:4352:0:b0:479:5d1:3fef with SMTP id
 m18-20020a194352000000b0047905d13fefmr4549812lfj.411.1655256540740; Tue, 14
 Jun 2022 18:29:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220527065442-mutt-send-email-mst@kernel.org> <CACGkMEubfv_OJOsJ_ROgei41Qx4mPO0Xz8rMVnO8aPFiEqr8rA@mail.gmail.com>
 <PH0PR12MB5481695930E7548BAAF1B0D9DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEsSKF_MyLgFdzVROptS3PCcp1y865znLWgnzq9L7CpFVQ@mail.gmail.com>
 <PH0PR12MB5481CAA3F57892FF7F05B004DCDF9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEsJJL34iUYQMxHguOV2cQ7rts+hRG5Gp3XKCGuqNdnNQg@mail.gmail.com>
 <PH0PR12MB5481D099A324C91DAF01259BDCDE9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEueG76L8H+F70D=T5kjK_+J68ARNQmQQo51rq3CfcOdRA@mail.gmail.com> <PH0PR12MB5481994AF05D3B4999EC1F0EDCAD9@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481994AF05D3B4999EC1F0EDCAD9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 15 Jun 2022 09:28:49 +0800
Message-ID: <CACGkMEtRTyymit=Zmwwcq0jNan-_C9p70vcLP0g7XmwQiOjUbw@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
To:     Parav Pandit <parav@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
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
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 8:10 AM Parav Pandit <parav@nvidia.com> wrote:
>
>
>
> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Wednesday, June 1, 2022 11:54 PM
> >
> > On Thu, Jun 2, 2022 at 10:59 AM Parav Pandit <parav@nvidia.com> wrote:
> > >
> > >
> > > > From: Jason Wang <jasowang@redhat.com>
> > > > Sent: Wednesday, June 1, 2022 10:00 PM
> > > >
> > > > On Thu, Jun 2, 2022 at 2:58 AM Parav Pandit <parav@nvidia.com> wrote:
> > > > >
> > > > >
> > > > > > From: Jason Wang <jasowang@redhat.com>
> > > > > > Sent: Tuesday, May 31, 2022 10:42 PM
> > > > > >
> > > > > > Well, the ability to query the virtqueue state was proposed as
> > > > > > another feature (Eugenio, please correct me). This should be
> > > > > > sufficient for making virtio-net to be live migrated.
> > > > > >
> > > > > The device is stopped, it won't answer to this special vq config done
> > here.
> > > >
> > > > This depends on the definition of the stop. Any query to the device
> > > > state should be allowed otherwise it's meaningless for us.
> > > >
> > > > > Programming all of these using cfg registers doesn't scale for
> > > > > on-chip
> > > > memory and for the speed.
> > > >
> > > > Well, they are orthogonal and what I want to say is, we should first
> > > > define the semantics of stop and state of the virtqueue.
> > > >
> > > > Such a facility could be accessed by either transport specific
> > > > method or admin virtqueue, it totally depends on the hardware
> > architecture of the vendor.
> > > >
> > > I find it hard to believe that a vendor can implement a CVQ but not AQ and
> > chose to expose tens of hundreds of registers.
> > > But maybe, it fits some specific hw.
> >
> > You can have a look at the ifcvf dpdk driver as an example.
> >
> Ifcvf is an example of using registers.
> It is not an answer why AQ is hard for it. :)

Well, it's an example of how vDPA is implemented. I think we agree
that for vDPA, vendors have the flexibility to implement their
perferrable datapath.

> virtio spec has definition of queue now and implementing yet another queue shouldn't be a problem.
>
> So far no one seem to have problem with the additional queue.
> So I take it as AQ is ok.
>
> > But another thing that is unrelated to hardware architecture is the nesting
> > support. Having admin virtqueue in a nesting environment looks like an
> > overkill. Presenting a register in L1 and map it to L0's admin should be good
> > enough.
> So may be a optimized interface can be added that fits nested env.
> At this point in time real users that we heard are interested in non-nested use cases. Let's enable them first.

That's fine. For nests, it's actually really easy, just adding an
interface within the existing transport should be sufficient.

>
>
> >
> > >
> > > I like to learn the advantages of such method other than simplicity.
> > >
> > > We can clearly that we are shifting away from such PCI registers with SIOV,
> > IMS and other scalable solutions.
> > > virtio drifting in reverse direction by introducing more registers as
> > transport.
> > > I expect it to an optional transport like AQ.
> >
> > Actually, I had a proposal of using admin virtqueue as a transport, it's
> > designed to be SIOV/IMS capable. And it's not hard to extend it with the
> > state/stop support etc.
> >
> > >
> > > > >
> > > > > Next would be to program hundreds of statistics of the 64 VQs
> > > > > through a
> > > > giant PCI config space register in some busy polling scheme.
> > > >
> > > > We don't need giant config space, and this method has been
> > > > implemented by some vDPA vendors.
> > > >
> > > There are tens of 64-bit counters per VQs. These needs to programmed on
> > destination side.
> > > Programming these via registers requires exposing them on the registers.
> > > In one of the proposals, I see them being queried via CVQ from the device.
> >
> > I didn't see a proposal like this. And I don't think querying general virtio state
> > like idx with a device specific CVQ is a good design.
> >
> My example was not for the idx. But for VQ statistics that is queried via CVQ.
>
> > >
> > > Programming them via cfg registers requires large cfg space or synchronous
> > programming until receiving ACK from it.
> > > This means one entry at a time...
> > >
> > > Programming them via CVQ needs replicate and align cmd values etc on all
> > device types. All duplicate and hard to maintain.
> > >
> > >
> > > > >
> > > > > I can clearly see how all these are inefficient for faster LM.
> > > > > We need an efficient AQ to proceed with at minimum.
> > > >
> > > > I'm fine with admin virtqueue, but the stop and state are orthogonal to
> > that.
> > > > And using admin virtqueue for stop/state will be more natural if we
> > > > use admin virtqueue as a transport.
> > > Ok.
> > > We should have defined it bit earlier that all vendors can use. :(
> >
> > I agree.
>
> I remember few months back, you acked in the weekly meeting that TC has approved the AQ direction.
> And we are still in this circle of debating the AQ.

I think not. Just to make sure we are on the same page, the proposal
here is for vDPA, and hope it can provide forward compatibility to
virtio. So in the context of vDPA, admin virtqueue is not a must.

Thanks

