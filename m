Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7766C5B0D5F
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiIGTiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiIGTiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:38:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89CEC1212
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 12:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662579475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TGroVYrUR+FlP7enzDgAT8Dk+QrrDDFqASiVxT9Otco=;
        b=DbUkYSqjwtLBUKPPEXKPfLJinMAk2d0RsgFLaNBAKounUKiV4ssF4mVMqwIn3sGA69DNm1
        oKmKVBYWgOJYzBvOmHKt3dbRWPz3U+mRAOBUUO/sV8iMFERycze7lbG7MWCrlvhR5bAh8U
        DgSEZrK2ZqT8AO+I/q2OCkVLPFTeJ0s=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-423-uYKMFSL7Oy6Wo27bsPebBQ-1; Wed, 07 Sep 2022 15:37:54 -0400
X-MC-Unique: uYKMFSL7Oy6Wo27bsPebBQ-1
Received: by mail-qt1-f199.google.com with SMTP id v5-20020ac873c5000000b003434ef0a8c7so12784588qtp.21
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 12:37:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=TGroVYrUR+FlP7enzDgAT8Dk+QrrDDFqASiVxT9Otco=;
        b=5E1MkZkZwxBhu+jVMBcnCe+VR3xQTm0PZ6ky5UCeg/T8OjAqJEj0Xo3xyZ4lfpShnD
         ANyeNsXQZ47Rk0tqChOQPl6sdmHgLhMGifI//H6NAJC5E8Oj+3VmrGuDDb/Jj7reHvr4
         DdsGm7lsnlrXh6jWLkGlVYXTFfWwj/fOAilnls8okPFOq71YbeFoWItxsBpDuwii/+yf
         Rx1bUFo4v0IwBLN/UUv48VQSABDSnhVfmAnR0/rUZ8KM7ZM+lmzq+M6oEM3UpdZLGbF4
         NJjqVDJ4itJwGIyRyrZenfzxJySqfoSBzxN/A67LhriMB3MbKdrxyT9NiDwL0Ksx44DG
         G6ng==
X-Gm-Message-State: ACgBeo3JyR0gScXYIA9Kl+/zDsoqsQ8TY8MD8B9u7YbLek0FafqHf3s+
        HjCqH3SyLEp785uqY0Y9lSjZ7x1G29erin8GZLdk7m0NnT53fqsPe9F9QtcS0Sreb/X89Vpg3Tw
        WBeL9WJ/HP82izTv3
X-Received: by 2002:a05:622a:5cb:b0:344:551a:c804 with SMTP id d11-20020a05622a05cb00b00344551ac804mr4772407qtb.645.1662579473917;
        Wed, 07 Sep 2022 12:37:53 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6o8+b3rCTjFRlYR6CJvTMblMf0qs3ibHzjOkhWuqZnfLiHVuUvUmc7APhywpTSHy+5koL1qQ==
X-Received: by 2002:a05:622a:5cb:b0:344:551a:c804 with SMTP id d11-20020a05622a05cb00b00344551ac804mr4772386qtb.645.1662579473681;
        Wed, 07 Sep 2022 12:37:53 -0700 (PDT)
Received: from redhat.com ([45.144.113.241])
        by smtp.gmail.com with ESMTPSA id c28-20020ac81e9c000000b0034454067d24sm13524561qtm.64.2022.09.07.12.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 12:37:53 -0700 (PDT)
Date:   Wed, 7 Sep 2022 15:37:46 -0400
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
Message-ID: <20220907153727-mutt-send-email-mst@kernel.org>
References: <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907141447-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907151026-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54811F1234CB7822F47DD1B9DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907152156-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481291080EBEC54C82A5641DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907153425-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907153425-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 03:36:16PM -0400, Michael S. Tsirkin wrote:
> On Wed, Sep 07, 2022 at 07:27:16PM +0000, Parav Pandit wrote:
> > 
> > > From: Michael S. Tsirkin <mst@redhat.com>
> > > Sent: Wednesday, September 7, 2022 3:24 PM
> > > 
> > > On Wed, Sep 07, 2022 at 07:18:06PM +0000, Parav Pandit wrote:
> > > >
> > > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > > Sent: Wednesday, September 7, 2022 3:12 PM
> > > >
> > > > > > Because of shallow queue of 16 entries deep.
> > > > >
> > > > > but why is the queue just 16 entries?
> > > > I explained the calculation in [1] about 16 entries.
> > > >
> > > > [1]
> > > >
> > > https://lore.kernel.org/netdev/PH0PR12MB54812EC7F4711C1EA4CAA119DC
> > > 419@
> > > > PH0PR12MB5481.namprd12.prod.outlook.com/
> > > >
> > > > > does the device not support indirect?
> > > > >
> > > > Yes, indirect feature bit is disabled on the device.
> > > 
> > > OK that explains it.
> > 
> > So can we proceed with v6 to contain 
> > (a) updated commit message and
> > (b) function name change you suggested to drop _fields suffix?
> 
> (c) replace mtu = 0 with sensibly not calling the function
> when mtu is unknown.
> 
> 
> And I'd like commit log to include results of perf testing
> - with indirect feature on
> - with mtu feature off
> just to make sure nothing breaks.

and if possible a larger ring. 1k?

> -- 
> MST

