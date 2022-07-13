Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA7C572D91
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 07:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbiGMFot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 01:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiGMFor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 01:44:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA5472DE9
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657691085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ye/OEisuk1M9Y7UFRb9TBjjAD4IQ42089/4Jo2aO6ys=;
        b=YRaeqGE8tDhCKRbgQNUxymPrqaT9Rc4pVew2olAgwIM/kvFYInrjGTk0KXv9Yv3lIM4GNG
        Zu/HmKZbNsG+P9J23b6GRxyP3PeKGB69pA8mSVGbGf/Ti1w/wsUQKg2Tq6YvxgKRiYwJPF
        +sAe2tUIKJcXTA3dbFaJZ2T01TAF9uA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-JBy1rMA7ND-nt75qmaIuZQ-1; Wed, 13 Jul 2022 01:44:44 -0400
X-MC-Unique: JBy1rMA7ND-nt75qmaIuZQ-1
Received: by mail-wr1-f72.google.com with SMTP id g9-20020adfa489000000b0021d6e786099so1781383wrb.7
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:44:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ye/OEisuk1M9Y7UFRb9TBjjAD4IQ42089/4Jo2aO6ys=;
        b=3bHFkJyKvaiWB67X2ryW2qWJULFfRyCKFratB2M8q2yGnGChwbxm1dO0MmAXxQN+9x
         7E2NH1SN/PLg9dY6ZYCSg0IwlCK3UAknyuwLWzEq3vnB+MTHQ2NrIYKuEDTb8Q9pmd52
         sn9rntBF6rH3+h4lI8RW3KVlmjwDep7IVQ1KSAeM+Frp+SZi2V9a+kvc7kOrBojsoYhX
         hSTggRgklx19vb1LVTZmBET+n6QX4j7Rr7i6a6WIPygkPjs/b73GnhQ02ozRKo9a8OSJ
         ktrBS3e7G8AuA51NyM7ZPp3EciFeK9Cn7Ifj7yFZaMk2XDS6KoQtg+BEQRqUQvnjSUq/
         DYYg==
X-Gm-Message-State: AJIora/GnWKeFTDcYbM3BGRzEtawFn9J/4KjcpcaoiNDX+/WToPXZpT7
        ubG60IpTrJ/I/nE+b25iEKfq0vInxM4sxgrIJRjVKudcxQeVBXKAScfWN423/4Y47q0O2mfrNcW
        7melrRZZLmIS3bm/L
X-Received: by 2002:adf:ffc1:0:b0:21d:66a1:c3ee with SMTP id x1-20020adfffc1000000b0021d66a1c3eemr1390285wrs.364.1657691083328;
        Tue, 12 Jul 2022 22:44:43 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sQssmai+lLbb0KzVW5xLsNMZ6wQ+8bMqipH7GIljNm9hRF4wnZnKrc96DYEniG7ZAFm7PQag==
X-Received: by 2002:adf:ffc1:0:b0:21d:66a1:c3ee with SMTP id x1-20020adfffc1000000b0021d66a1c3eemr1390276wrs.364.1657691083098;
        Tue, 12 Jul 2022 22:44:43 -0700 (PDT)
Received: from redhat.com ([2.52.24.42])
        by smtp.gmail.com with ESMTPSA id p12-20020a5d48cc000000b0021d9d13bf6csm8506209wrs.97.2022.07.12.22.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 22:44:42 -0700 (PDT)
Date:   Wed, 13 Jul 2022 01:44:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, Parav Pandit <parav@nvidia.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>
Subject: Re: [PATCH V3 1/6] vDPA/ifcvf: get_config_size should return a value
 no greater than dev implementation
Message-ID: <20220713013141-mutt-send-email-mst@kernel.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-2-lingshan.zhu@intel.com>
 <CACGkMEvGo2urfPriS3f6dCxT+41KJ0E-KUd4-GvUrX81BVy8Og@mail.gmail.com>
 <b2b2fb5e-c1c2-84b6-0315-a6eef121cdac@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2b2fb5e-c1c2-84b6-0315-a6eef121cdac@intel.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 02:44:08PM +0800, Zhu, Lingshan wrote:
> 
> 
> On 7/4/2022 12:39 PM, Jason Wang wrote:
> > On Fri, Jul 1, 2022 at 9:36 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> > > ifcvf_get_config_size() should return a virtio device type specific value,
> > > however the ret_value should not be greater than the onboard size of
> > > the device implementation. E.g., for virtio_net, config_size should be
> > > the minimum value of sizeof(struct virtio_net_config) and the onboard
> > > cap size.
> > Rethink of this, I wonder what's the value of exposing device
> > implementation details to users? Anyhow the parent is in charge of
> > "emulating" config space accessing.
> This will not be exposed to the users, it is a ifcvf internal helper,
> to get the actual device config space size.
> 
> For example, if ifcvf drives an Intel virtio-net device,
> if the device config space size is greater than sizeof(struct
> virtio_net_cfg),
> this means the device has something more than the spec, some private fields,
> we don't want to expose these extra private fields to the users, so in this
> case,
> we only return what the spec defines.

This is kind of already the case.

> If the device config space size is less than sizeof(struct virtio_net_cfg),
> means the device didn't implement all fields the spec defined, like no RSS.
> In such cases, we only return what the device implemented.
> So these are defensive programming.

I think the issue you are describing is simply this.


Driver must not access BAR outside capability length. Current code
does not verify that it does not. Not the case for the current
devices but it's best to be safe against the case where
device does not implement some of the capability.


From that POV I think the patch is good, just fix the log.



> > 
> > If we do this, it's probably a blocker for cross vendor stuff.
> > 
> > Thanks
> > 
> > > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> > > ---
> > >   drivers/vdpa/ifcvf/ifcvf_base.c | 13 +++++++++++--
> > >   drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
> > >   2 files changed, 13 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> > > index 48c4dadb0c7c..fb957b57941e 100644
> > > --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> > > +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> > > @@ -128,6 +128,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
> > >                          break;
> > >                  case VIRTIO_PCI_CAP_DEVICE_CFG:
> > >                          hw->dev_cfg = get_cap_addr(hw, &cap);
> > > +                       hw->cap_dev_config_size = le32_to_cpu(cap.length);
> > >                          IFCVF_DBG(pdev, "hw->dev_cfg = %p\n", hw->dev_cfg);
> > >                          break;
> > >                  }
> > > @@ -233,15 +234,23 @@ int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
> > >   u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
> > >   {
> > >          struct ifcvf_adapter *adapter;
> > > +       u32 net_config_size = sizeof(struct virtio_net_config);
> > > +       u32 blk_config_size = sizeof(struct virtio_blk_config);
> > > +       u32 cap_size = hw->cap_dev_config_size;
> > >          u32 config_size;
> > > 
> > >          adapter = vf_to_adapter(hw);
> > > +       /* If the onboard device config space size is greater than
> > > +        * the size of struct virtio_net/blk_config, only the spec
> > > +        * implementing contents size is returned, this is very
> > > +        * unlikely, defensive programming.
> > > +        */
> > >          switch (hw->dev_type) {
> > >          case VIRTIO_ID_NET:
> > > -               config_size = sizeof(struct virtio_net_config);
> > > +               config_size = cap_size >= net_config_size ? net_config_size : cap_size;
> > >                  break;
> > >          case VIRTIO_ID_BLOCK:
> > > -               config_size = sizeof(struct virtio_blk_config);
> > > +               config_size = cap_size >= blk_config_size ? blk_config_size : cap_size;
> > >                  break;
> > >          default:
> > >                  config_size = 0;
> > > diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> > > index 115b61f4924b..f5563f665cc6 100644
> > > --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> > > +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> > > @@ -87,6 +87,8 @@ struct ifcvf_hw {
> > >          int config_irq;
> > >          int vqs_reused_irq;
> > >          u16 nr_vring;
> > > +       /* VIRTIO_PCI_CAP_DEVICE_CFG size */
> > > +       u32 cap_dev_config_size;
> > >   };
> > > 
> > >   struct ifcvf_adapter {
> > > --
> > > 2.31.1
> > > 

