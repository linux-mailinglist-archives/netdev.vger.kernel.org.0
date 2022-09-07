Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8405B0CE8
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiIGTLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiIGTLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:11:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A29B69D8
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 12:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662577899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u/qj69XUPOcyLsjSAg4SPjsbFHmd3BOzkbohuB8c9bU=;
        b=CZqdOv7waYm8YSiMyjuvSI+MLWcGdxVGcvPUnwo7h6mnSsqK/X3CJNFm19TdpYN4F/CzHj
        tVz6/rVSr6Rgj3Lvzi39eDjGIhBC3pQkhKnY8OhCHeM6o/KqvS+UrIm00f4qJrvM5tDqeH
        3G99B0CmA3F/ysE3mWQqkSt4I26O4jY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-449-87Mp0E_iPryeNAg3r1VJww-1; Wed, 07 Sep 2022 15:11:38 -0400
X-MC-Unique: 87Mp0E_iPryeNAg3r1VJww-1
Received: by mail-wm1-f72.google.com with SMTP id a17-20020a05600c349100b003a545125f6eso10635283wmq.4
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 12:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=u/qj69XUPOcyLsjSAg4SPjsbFHmd3BOzkbohuB8c9bU=;
        b=GApKXwGXJu2XHH9QLvchFxfsCIlpMgGhFSEHhxiYZkfZoZSuthAeyHM8tIW4z0F+x/
         tg28QCzrZJV7wJOiNRlAHJFOJin7NpSTIbXX+o3EWDne47KZ3BGA0K0DMsLPvX4tVcCf
         lfLGajXXNDT60MYjcweoKGKrLv25lw8T/a1lywiQXxWbkYN2TgqpGHuL6vD7pvXR8jKM
         Ab35cqdWcwlsD1+/N82zD1LAxuJnIPxxZqxvVTjdWJAaBZaWj3sucOzZ+c0KeK3yxUnU
         +1cAY9/kBDuvQXJo1fBQ187opHBK8/1TY3eQC4ujWyNbOEPNzFh+nrIl3ykm77UvL3Ck
         cl+g==
X-Gm-Message-State: ACgBeo1fUK2AeCyFK1eus5w7JCV+SuKWIewyGAopyQAQ2fIKqp2fhVQf
        GzcHpDozBZW+e6b33BcqiiVOdedxxxyLoJ6azOyJi86dACtliZLfhwh8SRTJc/ejhM1lDjr578j
        NooDfLuJa7TPX651K
X-Received: by 2002:adf:f543:0:b0:228:c692:127a with SMTP id j3-20020adff543000000b00228c692127amr3085533wrp.246.1662577897045;
        Wed, 07 Sep 2022 12:11:37 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6d9AJ489TdJCGUgeCRPYhs8c3hJvWj8cdJQJMkw+jujrFv9ylSFbo6hqbQ/lpwXDQ/pngAVw==
X-Received: by 2002:adf:f543:0:b0:228:c692:127a with SMTP id j3-20020adff543000000b00228c692127amr3085517wrp.246.1662577896801;
        Wed, 07 Sep 2022 12:11:36 -0700 (PDT)
Received: from redhat.com ([2.52.30.234])
        by smtp.gmail.com with ESMTPSA id w3-20020a05600018c300b002206203ed3dsm19512739wrq.29.2022.09.07.12.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 12:11:36 -0700 (PDT)
Date:   Wed, 7 Sep 2022 15:11:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Message-ID: <20220907151026-mutt-send-email-mst@kernel.org>
References: <20220907012608-mutt-send-email-mst@kernel.org>
 <0355d1e4-a3cf-5b16-8c7f-b39b1ec14ade@nvidia.com>
 <20220907052317-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54812EC7F4711C1EA4CAA119DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907101335-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907141447-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 07:06:09PM +0000, Parav Pandit wrote:
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Wednesday, September 7, 2022 2:16 PM
> > 
> > On Wed, Sep 07, 2022 at 04:12:47PM +0000, Parav Pandit wrote:
> > >
> > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > Sent: Wednesday, September 7, 2022 10:40 AM
> > > >
> > > > On Wed, Sep 07, 2022 at 02:33:02PM +0000, Parav Pandit wrote:
> > > > >
> > > > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > > > Sent: Wednesday, September 7, 2022 10:30 AM
> > > > >
> > > > > [..]
> > > > > > > > actually how does this waste space? Is this because your
> > > > > > > > device does not have INDIRECT?
> > > > > > > VQ is 256 entries deep.
> > > > > > > Driver posted total of 256 descriptors.
> > > > > > > Each descriptor points to a page of 4K.
> > > > > > > These descriptors are chained as 4K * 16.
> > > > > >
> > > > > > So without indirect then? with indirect each descriptor can
> > > > > > point to
> > > > > > 16 entries.
> > > > > >
> > > > > With indirect, can it post 256 * 16 size buffers even though vq
> > > > > depth is 256
> > > > entries?
> > > > > I recall that total number of descriptors with direct/indirect
> > > > > descriptors is
> > > > limited to vq depth.
> > > >
> > > >
> > > > > Was there some recent clarification occurred in the spec to clarify this?
> > > >
> > > >
> > > > This would make INDIRECT completely pointless.  So I don't think we
> > > > ever had such a limitation.
> > > > The only thing that comes to mind is this:
> > > >
> > > > 	A driver MUST NOT create a descriptor chain longer than the Queue
> > > > Size of
> > > > 	the device.
> > > >
> > > > but this limits individual chain length not the total length of all chains.
> > > >
> > > Right.
> > > I double checked in virtqueue_add_split() which doesn't count table
> > entries towards desc count of VQ for indirect case.
> > >
> > > With indirect descriptors without this patch the situation is even worse
> > with memory usage.
> > > Driver will allocate 64K * 256 = 16MB buffer per VQ, while needed (and
> > used) buffer is only 2.3 Mbytes.
> > 
> > Yes. So just so we understand the reason for the performance improvement
> > is this because of memory usage? Or is this because device does not have
> > INDIRECT?
> 
> Because of shallow queue of 16 entries deep.

but why is the queue just 16 entries?
does the device not support indirect?

because with indirect you get 256 entries, with 16 s/g each.


> With driver turn around time to repost buffers, device is idle without any RQ buffers.
> With this improvement, device has 85 buffers instead of 16 to receive packets.
> 
> Enabling indirect in device can help at cost of 7x higher memory per VQ in the guest VM.

