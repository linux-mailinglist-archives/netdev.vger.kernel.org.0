Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CF453B250
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 05:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiFBDx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 23:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiFBDxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 23:53:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F8D324BF8
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 20:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654142033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3nhZSbN+Ew1mV2HyhEGIhPum4yYB0PCOS8RQvOZHGfg=;
        b=EbueC4Ek4SCHEGKpbe9TcZm+cERk+MjUTz5qx/k68szCuMilSg+eJiApbVfxBpfvW26F57
        uonwI+lctnkHvExVgLTJRTExWqPXcuJT7GXnHvX2bDV/dHvNZuEW4NuAN5ZAD8ue/UD1ue
        SG+KaQeDk50O1G8n3dbJ9uOx2Ji4tMk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-nXMYS_gMNISbz2q-lgUo-g-1; Wed, 01 Jun 2022 23:53:52 -0400
X-MC-Unique: nXMYS_gMNISbz2q-lgUo-g-1
Received: by mail-lf1-f70.google.com with SMTP id y12-20020a0565123f0c00b00477bab7c83aso1896633lfa.6
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 20:53:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3nhZSbN+Ew1mV2HyhEGIhPum4yYB0PCOS8RQvOZHGfg=;
        b=iyS0v/NgpKUS18OR8f1nTMoJoNSxzyJQirjemkqUGKkxJxc+YaJ7mYalrdZXiADirk
         rNGPEdstFx3egeeZABhFquhWZqyEu1B0KCMshrhCpBF5YroX2s+9AFhWFRQkr4J/Iads
         e4Zx4fL88/PbhAF+MZBYke1z+8kMLL0rD/cbZx3hQdMeul9Z4ufVw8EfHxdkUN3eaySg
         +oEjs0BnS4hAVEb/AjBjmPLjWLKMnltUmyX9MPYBWBJuNTxOZOlQjf0UxppuuNzNJLpW
         lSK6R07p1j/smkO7ajTd+p/bTHsH1yZ897xbHwh5lyPdZAegrkLXJqc4RR/74UXI1BSq
         n9Wg==
X-Gm-Message-State: AOAM530uqwevhYwEL8qFjdGW6HfB6YUOhTxjZ1CWjcsia4osr/92GZAV
        H9tqQ8QRPCCxihDeuDvwuReTI5+JyZ0dG5Ign28TJ42gEh7chlevxEWAjTjEPDoWo9EabSrv1uo
        YTeiFsV9XzmX3wmTonthrjia0aVslvzIc
X-Received: by 2002:a2e:910e:0:b0:255:4a7e:b42e with SMTP id m14-20020a2e910e000000b002554a7eb42emr13517234ljg.492.1654142030609;
        Wed, 01 Jun 2022 20:53:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJM9qe1ZzH7Y7RYWXggUuk3BevCy6i+Cbv2/YzP3wdLzlzwEekNr9HqR9L31QhUD0/KMuoWmCNycyMXglwQmk=
X-Received: by 2002:a2e:910e:0:b0:255:4a7e:b42e with SMTP id
 m14-20020a2e910e000000b002554a7eb42emr13517199ljg.492.1654142030349; Wed, 01
 Jun 2022 20:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220527065442-mutt-send-email-mst@kernel.org> <CACGkMEubfv_OJOsJ_ROgei41Qx4mPO0Xz8rMVnO8aPFiEqr8rA@mail.gmail.com>
 <PH0PR12MB5481695930E7548BAAF1B0D9DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEsSKF_MyLgFdzVROptS3PCcp1y865znLWgnzq9L7CpFVQ@mail.gmail.com>
 <PH0PR12MB5481CAA3F57892FF7F05B004DCDF9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEsJJL34iUYQMxHguOV2cQ7rts+hRG5Gp3XKCGuqNdnNQg@mail.gmail.com> <PH0PR12MB5481D099A324C91DAF01259BDCDE9@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481D099A324C91DAF01259BDCDE9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 2 Jun 2022 11:53:39 +0800
Message-ID: <CACGkMEueG76L8H+F70D=T5kjK_+J68ARNQmQQo51rq3CfcOdRA@mail.gmail.com>
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
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 10:59 AM Parav Pandit <parav@nvidia.com> wrote:
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

You can have a look at the ifcvf dpdk driver as an example.

But another thing that is unrelated to hardware architecture is the
nesting support. Having admin virtqueue in a nesting environment looks
like an overkill. Presenting a register in L1 and map it to L0's admin
should be good enough.

>
> I like to learn the advantages of such method other than simplicity.
>
> We can clearly that we are shifting away from such PCI registers with SIOV, IMS and other scalable solutions.
> virtio drifting in reverse direction by introducing more registers as transport.
> I expect it to an optional transport like AQ.

Actually, I had a proposal of using admin virtqueue as a transport,
it's designed to be SIOV/IMS capable. And it's not hard to extend it
with the state/stop support etc.

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

I didn't see a proposal like this. And I don't think querying general
virtio state like idx with a device specific CVQ is a good design.

>
> Programming them via cfg registers requires large cfg space or synchronous programming until receiving ACK from it.
> This means one entry at a time...
>
> Programming them via CVQ needs replicate and align cmd values etc on all device types. All duplicate and hard to maintain.
>
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

I agree.

Thanks

