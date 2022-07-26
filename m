Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54F8581A80
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 21:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239740AbiGZTtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 15:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239721AbiGZTtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 15:49:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89F27357C7
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 12:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658864940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h4W4k8N5drQJsdvsOqmfMYTc9AkddbThD/GEQ+8d7Sc=;
        b=Gn217F3An5HLydoYay8bZ/jIZpJhNWAsggj4pv1ccAtxWZmek7mI2YmOB3XuZgfdg3nUpc
        dav1k9QZ/h3WTmuATuu7ZuC+bEIoZ0VWRgMGpnbUV41fAfm0GZ8qrtyA8A/ov0yMGDan0f
        4arH8TqZfxWdUQlKqFvM6d8kvsTo66A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-3I_0D7avP9GYL7o2Nk020Q-1; Tue, 26 Jul 2022 15:48:55 -0400
X-MC-Unique: 3I_0D7avP9GYL7o2Nk020Q-1
Received: by mail-wm1-f71.google.com with SMTP id az39-20020a05600c602700b003a321d33238so8060815wmb.1
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 12:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=h4W4k8N5drQJsdvsOqmfMYTc9AkddbThD/GEQ+8d7Sc=;
        b=T180X8QncFscL/K/I125q6ieLqlO4rgVkNNp9qU3PBEMuDRn7aBd0makW2kPAus9uE
         C8JlaesFQT+bc5xFWpFDdrgaamhuz4VVEYDId2ztFj6pH0X1M0vSSVfmqsRYXmLSAHwa
         ERvU1lm+w5Ja1JHmEd0zAzvYhdywsz/uhjB4/A3FFwg8zVNpsSBowc510HiHBToV1CqD
         BFzOlEP3dxCkZ+94N4neDK3LD6nIhaTWyxbpyHE+n8+Sg2pAWF/uNl5qnXVWoBDoU8g4
         /AlqlbzH89hPFOj+1Ui+KYnAUhgcufBVMu9NJ1zchBwrKF3u16Dj7Z0EV7/5VOQXVTPT
         pguw==
X-Gm-Message-State: AJIora8sFtueqTVwO5xSJrEICs7/LEeDInUfVrsuK06GlhrRPbxaeo+7
        zj8ZuLfB7wDF8EaVfGs3HxEWvsUo8XI/XwpuecfQybzmOmzRMbGapm+VUKWQbwVS3ISo4l2Zu3W
        rpIVEGUlMRpFZ/ZHX
X-Received: by 2002:a7b:c7d8:0:b0:3a3:1b8a:97a4 with SMTP id z24-20020a7bc7d8000000b003a31b8a97a4mr542842wmk.160.1658864934577;
        Tue, 26 Jul 2022 12:48:54 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tlej1ETE/gaBJNxgTakMhYrg+HP9txSBXb8RhBbcX1b6PoXkUF9gyXs90SnjmmLAVx8vQqNQ==
X-Received: by 2002:a7b:c7d8:0:b0:3a3:1b8a:97a4 with SMTP id z24-20020a7bc7d8000000b003a31b8a97a4mr542818wmk.160.1658864934023;
        Tue, 26 Jul 2022 12:48:54 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7424:0:3d16:86dc:de54:5671])
        by smtp.gmail.com with ESMTPSA id r13-20020a05600c35cd00b003a046549a85sm24811524wmq.37.2022.07.26.12.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 12:48:53 -0700 (PDT)
Date:   Tue, 26 Jul 2022 15:48:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Message-ID: <20220726154704-mutt-send-email-mst@kernel.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-6-lingshan.zhu@intel.com>
 <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220713011631-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481BE59EDF381F5C0849C08DC949@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481BE59EDF381F5C0849C08DC949@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 03:54:06PM +0000, Parav Pandit wrote:
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Wednesday, July 13, 2022 1:27 AM
> > 
> > On Fri, Jul 01, 2022 at 10:07:59PM +0000, Parav Pandit wrote:
> > >
> > >
> > > > From: Zhu Lingshan <lingshan.zhu@intel.com>
> > > > Sent: Friday, July 1, 2022 9:28 AM
> > > > If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue
> > > > pair, so when userspace querying queue pair numbers, it should
> > > > return mq=1 than zero.
> > > >
> > > > Function vdpa_dev_net_config_fill() fills the attributions of the
> > > > vDPA devices, so that it should call vdpa_dev_net_mq_config_fill()
> > > > so the parameter in vdpa_dev_net_mq_config_fill() should be
> > > > feature_device than feature_driver for the vDPA devices themselves
> > > >
> > > > Before this change, when MQ = 0, iproute2 output:
> > > > $vdpa dev config show vdpa0
> > > > vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false
> > > > max_vq_pairs 0 mtu 1500
> > > >
> > > The fix belongs to user space.
> > > When a feature bit _MQ is not negotiated, vdpa kernel space will not add
> > attribute VDPA_ATTR_DEV_NET_CFG_MAX_VQP.
> > > When such attribute is not returned by kernel, max_vq_pairs should not be
> > shown by the iproute2.
> > >
> > > We have many config space fields that depend on the feature bits and
> > some of them do not have any defaults.
> > > To keep consistency of existence of config space fields among all, we don't
> > want to show default like below.
> > >
> > > Please fix the iproute2 to not print max_vq_pairs when it is not returned by
> > the kernel.
> > 
> > Parav I read the discussion and don't get your argument. From driver's POV
> > _MQ with 1 VQ pair and !_MQ are exactly functionally equivalent.
> But we are talking from user POV here.

From spec POV there's just driver and device, user would be part of
driver here.

> > 
> > It's true that iproute probably needs to be fixed too, to handle old kernels.
> > But iproute is not the only userspace, why not make it's life easier by fixing
> > the kernel?
> Because it cannot be fixed for other config space fields which are control by feature bits those do not have any defaults.
> So better to treat all in same way from user POV.

Consistency is good for sure. What are these other fields though?
Can you give examples so I understand please?

-- 
MST

