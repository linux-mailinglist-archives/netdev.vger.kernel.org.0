Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE45596CDE
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 12:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbiHQKhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 06:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbiHQKhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 06:37:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661CB52DC5
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660732641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/bZCOzsQWglaIEflXVaKuMeO6kIO1iJlwntv9G+IQcI=;
        b=Dh+pCUigIb6qiHyyPaWg1MhEnNo2E9UKXecLR25/lDlDd7r+Iu7OvsjCw/7s/aPs/3xSfd
        jlfmd1QBnBWgQshwiK3b1Cl6B3XCQRvK6d5NnherRe8TtJTizNKx8BeS+cTnacyC/5CMjY
        7u9a2a5d0mQQxprpFDJEp5taO+DESjo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-455-CPBu0scCNcymFOE5rworNQ-1; Wed, 17 Aug 2022 06:37:20 -0400
X-MC-Unique: CPBu0scCNcymFOE5rworNQ-1
Received: by mail-wm1-f72.google.com with SMTP id 203-20020a1c02d4000000b003a5f5bce876so889373wmc.2
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/bZCOzsQWglaIEflXVaKuMeO6kIO1iJlwntv9G+IQcI=;
        b=zYwLiRzqttUM2DvMC0qq+1sMJ52xwIrEr+90iH7H4J8XPUm8TChI7M8ip7KWUUDGV0
         xsQ4/K+doP3uR6itbh7jiYJuRq7/IxYsXHBAMiXT0d9G95PI7SoMse2o3wa5gc3khGmL
         Nh7BORyvTzXnmgYwKagrvSlJFBPwEifYY/WftR5AJi60Fx5RDfL2wRlGYF8ztY4SoLJn
         ua6J67PLDQyWljnKAH5HY+qF8lvmWdjZt2fbJ4jpB2iIbgWN6lCBfulnEtRk1PeaNG6C
         eK+VYrVtu1MiTTEm7u9uBdy/fE5+MXMdD8VpTH746VWBSLjmILcC2ppiSAdLUxUBKCFX
         /RzQ==
X-Gm-Message-State: ACgBeo3VQRp4yjRfMyMN5uK7zEYur4Yb33fGKnR6gVjWWkgkrVcZL66I
        MVRUU0S18Kx/Sk5vnVUFxIGFNtyf+DdfUQ63RgcL9W5/wv5CerywjXyWnbVKnijb58ftJcY/AKs
        UKMW+OTwRgwqxozmi
X-Received: by 2002:adf:d1e8:0:b0:223:bca:8019 with SMTP id g8-20020adfd1e8000000b002230bca8019mr13769493wrd.562.1660732638731;
        Wed, 17 Aug 2022 03:37:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR78CQkZt1eehkXm5izHSD8H9NgPlq3Iq0IOh8rkYepCNOJ0f1/e81lieEPl5cN6j8AAmLR9Cw==
X-Received: by 2002:adf:d1e8:0:b0:223:bca:8019 with SMTP id g8-20020adfd1e8000000b002230bca8019mr13769482wrd.562.1660732638486;
        Wed, 17 Aug 2022 03:37:18 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id j18-20020a05600c191200b003a5f54e3bbbsm2012695wmq.38.2022.08.17.03.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 03:37:17 -0700 (PDT)
Date:   Wed, 17 Aug 2022 06:37:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Message-ID: <20220817063450-mutt-send-email-mst@kernel.org>
References: <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com>
 <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
 <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com>
 <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
 <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com>
 <20220817045406-mutt-send-email-mst@kernel.org>
 <a91fa479-d1cc-a2d6-0821-93386069a2c1@intel.com>
 <20220817053821-mutt-send-email-mst@kernel.org>
 <449c2fb2-3920-7bf9-8c5c-a68456dfea76@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <449c2fb2-3920-7bf9-8c5c-a68456dfea76@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 05:43:22PM +0800, Zhu, Lingshan wrote:
> 
> 
> On 8/17/2022 5:39 PM, Michael S. Tsirkin wrote:
> > On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wrote:
> > > 
> > > On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
> > > > On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
> > > > > Yes it is a little messy, and we can not check _F_VERSION_1 because of
> > > > > transitional devices, so maybe this is the best we can do for now
> > > > I think vhost generally needs an API to declare config space endian-ness
> > > > to kernel. vdpa can reuse that too then.
> > > Yes, I remember you have mentioned some IOCTL to set the endian-ness,
> > > for vDPA, I think only the vendor driver knows the endian,
> > > so we may need a new function vdpa_ops->get_endian().
> > > In the last thread, we say maybe it's better to add a comment for now.
> > > But if you think we should add a vdpa_ops->get_endian(), I can work
> > > on it for sure!
> > > 
> > > Thanks
> > > Zhu Lingshan
> > I think QEMU has to set endian-ness. No one else knows.
> Yes, for SW based vhost it is true. But for HW vDPA, only
> the device & driver knows the endian, I think we can not
> "set" a hardware's endian.

QEMU knows the guest endian-ness and it knows that
device is accessed through the legacy interface.
It can accordingly send endian-ness to the kernel and
kernel can propagate it to the driver.

> So if you think we should add a vdpa_ops->get_endian(),
> I will drop these comments in the next version of
> series, and work on a new patch for get_endian().
> 
> Thanks,
> Zhu Lingshan

Guests don't get endian-ness from devices so this seems pointless.

-- 
MST

