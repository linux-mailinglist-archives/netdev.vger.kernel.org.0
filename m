Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691015822A5
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiG0JDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiG0JDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:03:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82FDE46DBF
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658912579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gtC1Kngdj/9ZAtLMhB4yQ8VboNXr6FhpxFuZ9/lFO2o=;
        b=YC+Q+bQ2l9zpftMqpfveTL7cWE7h4RCUwoXLZdkmYiG6QgjYILiZWWwJ8A3qUezMZhu6RI
        NGFAKFUppiF5bVQ510nc/yRer0qg2oOzSa/veOnIl6aF8e/tElEpaTv/G3YFP0TRiepwDk
        liM+XTytLjfhUil0lN7hcZhR8+aZemQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-Anzdmlq_OTmzu5Qt-YMUIA-1; Wed, 27 Jul 2022 05:02:57 -0400
X-MC-Unique: Anzdmlq_OTmzu5Qt-YMUIA-1
Received: by mail-wm1-f71.google.com with SMTP id k27-20020a05600c1c9b00b003a2fee19a80so890187wms.1
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:02:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=gtC1Kngdj/9ZAtLMhB4yQ8VboNXr6FhpxFuZ9/lFO2o=;
        b=Be+x5UjpL4x1cdZ7jJ7IVHWg5sdg3VYlFPUOMpiQj6uu9hH4i/YMHQFwWQNyeaY3LL
         4yicizSRR7D2myrR+GbrGVB3DDAfhS5oZIyAbw9/Zj+QIVqp07Uo4cj6Y2OF53HLCl36
         DIc+903sLC+u42gz0r3dfZAQg/FT19inyPR7HXQsVA9c5sgAvz9RgK6DS4+ZPak9jlKN
         LEP+Ig25jCNQW2OzVCKpGpQh9qOfgkTnDcWCr1HQdmP+5nmuaWxEgaF2pni77YwGuiPE
         AWV8986UKTgXYW/vGSXsHuKAp5iz0vkxSB+yT7qIGNijn7rTeJUjmcFDC8wWmAHMsZTT
         fflg==
X-Gm-Message-State: AJIora969IjnHp/REmmueq9SpwuT9E6UtgwAdbj3Y1aSMTKA1JKTPb04
        zh6aMBesIZEBFADWMcRAWDp2h9lxcPES1aFqjIauo1lrv4xsADAEFRuozKPs6qdR9Ojvs6mw+3A
        qTdqE+3syBSh/Vwzn
X-Received: by 2002:a05:6000:80b:b0:21e:d62e:b282 with SMTP id bt11-20020a056000080b00b0021ed62eb282mr946121wrb.557.1658912576250;
        Wed, 27 Jul 2022 02:02:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uW9fV+cMip2PTPTYKXcapQCJhkF7jhW8fg6kDZV7A60tEtWN8sMyjbcVt8iYSWS8fR3A9+3w==
X-Received: by 2002:a05:6000:80b:b0:21e:d62e:b282 with SMTP id bt11-20020a056000080b00b0021ed62eb282mr946104wrb.557.1658912576019;
        Wed, 27 Jul 2022 02:02:56 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7424:0:3d16:86dc:de54:5671])
        by smtp.gmail.com with ESMTPSA id f8-20020a5d4dc8000000b0021dd8e1309asm16828404wru.75.2022.07.27.02.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 02:02:55 -0700 (PDT)
Date:   Wed, 27 Jul 2022 05:02:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Message-ID: <20220727050222-mutt-send-email-mst@kernel.org>
References: <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org>
 <CACGkMEv62tuOP3ra0GBhjCH=syFWxP+GVfGL_i0Ce0iD4uMY=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEv62tuOP3ra0GBhjCH=syFWxP+GVfGL_i0Ce0iD4uMY=Q@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 02:54:13PM +0800, Jason Wang wrote:
> On Wed, Jul 27, 2022 at 2:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
> > >
> > > > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > Sent: Tuesday, July 26, 2022 10:53 PM
> > > >
> > > > On 7/27/2022 10:17 AM, Parav Pandit wrote:
> > > > >> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > >> Sent: Tuesday, July 26, 2022 10:15 PM
> > > > >>
> > > > >> On 7/26/2022 11:56 PM, Parav Pandit wrote:
> > > > >>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > > > >>>> Sent: Tuesday, July 12, 2022 11:46 PM
> > > > >>>>> When the user space which invokes netlink commands, detects that
> > > > >> _MQ
> > > > >>>> is not supported, hence it takes max_queue_pair = 1 by itself.
> > > > >>>> I think the kernel module have all necessary information and it is
> > > > >>>> the only one which have precise information of a device, so it
> > > > >>>> should answer precisely than let the user space guess. The kernel
> > > > >>>> module should be reliable than stay silent, leave the question to
> > > > >>>> the user space
> > > > >> tool.
> > > > >>> Kernel is reliable. It doesn’t expose a config space field if the
> > > > >>> field doesn’t
> > > > >> exist regardless of field should have default or no default.
> > > > >> so when you know it is one queue pair, you should answer one, not try
> > > > >> to guess.
> > > > >>> User space should not guess either. User space gets to see if _MQ
> > > > >> present/not present. If _MQ present than get reliable data from kernel.
> > > > >>> If _MQ not present, it means this device has one VQ pair.
> > > > >> it is still a guess, right? And all user space tools implemented this
> > > > >> feature need to guess
> > > > > No. it is not a guess.
> > > > > It is explicitly checking the _MQ feature and deriving the value.
> > > > > The code you proposed will be present in the user space.
> > > > > It will be uniform for _MQ and 10 other features that are present now and
> > > > in the future.
> > > > MQ and other features like RSS are different. If there is no _RSS_XX, there
> > > > are no attributes like max_rss_key_size, and there is not a default value.
> > > > But for MQ, we know it has to be 1 wihtout _MQ.
> > > "we" = user space.
> > > To keep the consistency among all the config space fields.
> >
> > Actually I looked and the code some more and I'm puzzled:
> >
> >
> >         struct virtio_net_config config = {};
> >         u64 features;
> >         u16 val_u16;
> >
> >         vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> >
> >         if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
> >                     config.mac))
> >                 return -EMSGSIZE;
> >
> >
> > Mac returned even without VIRTIO_NET_F_MAC
> >
> >
> >         val_u16 = le16_to_cpu(config.status);
> >         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> >                 return -EMSGSIZE;
> >
> >
> > status returned even without VIRTIO_NET_F_STATUS
> >
> >         val_u16 = le16_to_cpu(config.mtu);
> >         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> >                 return -EMSGSIZE;
> >
> >
> > MTU returned even without VIRTIO_NET_F_MTU
> >
> >
> > What's going on here?
> 
> Probably too late to fix, but this should be fine as long as all
> parents support STATUS/MTU/MAC.

Why is this too late to fix.

> I wonder if we can add a check in the core and fail the device
> registration in this case.
> 
> Thanks
> 
> >
> >
> > --
> > MST
> >

