Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8F25993CA
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 05:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345711AbiHSDwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 23:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235080AbiHSDww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 23:52:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E64CC31C
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 20:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660881169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WAJAq5ZihTLOBrM5eMh7GMiTFrZ/R9PeAnxxmgtqE5k=;
        b=YJc4srxN6S/QkExrilwfMjE/WT759WyCja11FSicy5LPIXzAxATt6pFjtDsvQJFmy7Rd/m
        fx6G4YqNeLKZVoL5pMLp0vSqSmIduNIu7gAZYMEctFhYQhMML1qWbaSnuD71qDeZLzG8Fp
        YZye7wy96O5mHrm+u+hboYJWoPgDX0k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-578-AGW3rkNfOc6nNpMUt5M6DQ-1; Thu, 18 Aug 2022 23:52:48 -0400
X-MC-Unique: AGW3rkNfOc6nNpMUt5M6DQ-1
Received: by mail-wm1-f71.google.com with SMTP id az42-20020a05600c602a00b003a552086ba9so3689591wmb.6
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 20:52:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=WAJAq5ZihTLOBrM5eMh7GMiTFrZ/R9PeAnxxmgtqE5k=;
        b=tQrSDgfijpoyeBw6q3nJCUVGciPoFwoU9A+9IhQW8tICbwPD+l0Ys1hFEiShIpd/OK
         x0Q2PHmGTxoa/Ggc5bf2q8Sl4PRjVxSHAqNA+yIBBchjKDo3j47ZxZxvqMOzbi55cLvq
         KVTIw0syTAGLyJTuvta91QZpv4qMOOEuQf5IYU+fOKmWYdLmvohDEbR8HcFc4cBwPPdn
         gmAs5VggPpwd8WU2PZ/RE/nF5c83aslFdGj043aJXaYXgI8/FTHK8aOCci7jJRrlO/du
         NuP2NRbtn+p6qzXY7At3/F/KJh4jMPWaSfe9PwAM9tMEPwjAQLuKmVgCfsH19Xn8jXzD
         4ARg==
X-Gm-Message-State: ACgBeo0wNmsQ1XZrjK8aehKJZtDcAjV7znLIVbpQN7UPR2giaciunIr/
        U4OyuLurE9vRJa34++7yJeaDYfK4sAF8PB3reVePl9jbf2qPsRhSlGPZriHioWc2RoVmb6RVuUr
        eR+VTNyXKnyfwx4rU
X-Received: by 2002:a05:600c:42c3:b0:3a6:431:91bf with SMTP id j3-20020a05600c42c300b003a6043191bfmr6340492wme.188.1660881167191;
        Thu, 18 Aug 2022 20:52:47 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7ZHWj35Cj7E6zxbO8e4bqs00d+Oyu5ZJti0Zd52xBJf2ZL+sVz7snvXxLdwTTpqO7aJUjHWw==
X-Received: by 2002:a05:600c:42c3:b0:3a6:431:91bf with SMTP id j3-20020a05600c42c300b003a6043191bfmr6340471wme.188.1660881166864;
        Thu, 18 Aug 2022 20:52:46 -0700 (PDT)
Received: from redhat.com ([181.214.206.203])
        by smtp.gmail.com with ESMTPSA id r6-20020a05600c35c600b003a626055569sm4064206wmq.16.2022.08.18.20.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 20:52:45 -0700 (PDT)
Date:   Thu, 18 Aug 2022 23:52:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Message-ID: <20220818235137-mutt-send-email-mst@kernel.org>
References: <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
 <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com>
 <20220817045406-mutt-send-email-mst@kernel.org>
 <a91fa479-d1cc-a2d6-0821-93386069a2c1@intel.com>
 <20220817053821-mutt-send-email-mst@kernel.org>
 <449c2fb2-3920-7bf9-8c5c-a68456dfea76@intel.com>
 <20220817063450-mutt-send-email-mst@kernel.org>
 <54aa5a5c-69e2-d372-3e0c-b87f595d213c@redhat.com>
 <f0b6ea5c-1783-96d2-2d9f-e5cf726b0fc0@oracle.com>
 <CACGkMEumKfktMUJOTUYL_JYkFbw8qH331gGARPB2bTH=7wKWPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEumKfktMUJOTUYL_JYkFbw8qH331gGARPB2bTH=7wKWPg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 08:42:32AM +0800, Jason Wang wrote:
> On Fri, Aug 19, 2022 at 7:20 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
> >
> >
> >
> > On 8/17/2022 9:15 PM, Jason Wang wrote:
> > >
> > > 在 2022/8/17 18:37, Michael S. Tsirkin 写道:
> > >> On Wed, Aug 17, 2022 at 05:43:22PM +0800, Zhu, Lingshan wrote:
> > >>>
> > >>> On 8/17/2022 5:39 PM, Michael S. Tsirkin wrote:
> > >>>> On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wrote:
> > >>>>> On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
> > >>>>>> On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
> > >>>>>>> Yes it is a little messy, and we can not check _F_VERSION_1
> > >>>>>>> because of
> > >>>>>>> transitional devices, so maybe this is the best we can do for now
> > >>>>>> I think vhost generally needs an API to declare config space
> > >>>>>> endian-ness
> > >>>>>> to kernel. vdpa can reuse that too then.
> > >>>>> Yes, I remember you have mentioned some IOCTL to set the endian-ness,
> > >>>>> for vDPA, I think only the vendor driver knows the endian,
> > >>>>> so we may need a new function vdpa_ops->get_endian().
> > >>>>> In the last thread, we say maybe it's better to add a comment for
> > >>>>> now.
> > >>>>> But if you think we should add a vdpa_ops->get_endian(), I can work
> > >>>>> on it for sure!
> > >>>>>
> > >>>>> Thanks
> > >>>>> Zhu Lingshan
> > >>>> I think QEMU has to set endian-ness. No one else knows.
> > >>> Yes, for SW based vhost it is true. But for HW vDPA, only
> > >>> the device & driver knows the endian, I think we can not
> > >>> "set" a hardware's endian.
> > >> QEMU knows the guest endian-ness and it knows that
> > >> device is accessed through the legacy interface.
> > >> It can accordingly send endian-ness to the kernel and
> > >> kernel can propagate it to the driver.
> > >
> > >
> > > I wonder if we can simply force LE and then Qemu can do the endian
> > > conversion?
> > convert from LE for config space fields only, or QEMU has to forcefully
> > mediate and covert endianness for all device memory access including
> > even the datapath (fields in descriptor and avail/used rings)?
> 
> Former. Actually, I want to force modern devices for vDPA when
> developing the vDPA framework. But then we see requirements for
> transitional or even legacy (e.g the Ali ENI parent). So it
> complicates things a lot.
> 
> I think several ideas has been proposed:
> 
> 1) Your proposal of having a vDPA specific way for
> modern/transitional/legacy awareness. This seems very clean since each
> transport should have the ability to do that but it still requires
> some kind of mediation for the case e.g running BE legacy guest on LE
> host.
> 
> 2) Michael suggests using VHOST_SET_VRING_ENDIAN where it means we
> need a new config ops for vDPA bus, but it doesn't solve the issue for
> config space (at least from its name). We probably need a new ioctl
> for both vring and config space.
> 
> or


Yea, like VHOST_SET_CONFIG_ENDIAN.



> 3) revisit the idea of forcing modern only device which may simplify
> things a lot

Problem is vhost needs VHOST_SET_CONFIG_ENDIAN too. it's not
a vdpa specific issue.

> which way should we go?
> 
> > I hope
> > it's not the latter, otherwise it loses the point to use vDPA for
> > datapath acceleration.
> >
> > Even if its the former, it's a little weird for vendor device to
> > implement a LE config space with BE ring layout, although still possible...
> 
> Right.
> 
> Thanks
> 
> >
> > -Siwei
> > >
> > > Thanks
> > >
> > >
> > >>
> > >>> So if you think we should add a vdpa_ops->get_endian(),
> > >>> I will drop these comments in the next version of
> > >>> series, and work on a new patch for get_endian().
> > >>>
> > >>> Thanks,
> > >>> Zhu Lingshan
> > >> Guests don't get endian-ness from devices so this seems pointless.
> > >>
> > >
> >

