Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C6B5B0D2A
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 21:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiIGTYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 15:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIGTYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 15:24:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC3CC0E72
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 12:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662578646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sYnZZ/3twYWT2HM0ZS6NnUha3knYPuZH8nbGiQU3O6Y=;
        b=guPsxyzw6jIPh4KAXd0C/mo2bweEEVs/OYVzXIA1gEqolpqem5E6lut2aJQDZfljmIG8oz
        2LK0iU9VMXad1cn2YO3ZdIUXAgkuUB1ghACvmO0h+lIUluGUlMKyWeubSWHYIyI2cljhkn
        DpbwJ90ezdkWb5F6m6qeF2T71GXr6wk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-17-MGfeGbmuPka_vlDfeD0APg-1; Wed, 07 Sep 2022 15:24:05 -0400
X-MC-Unique: MGfeGbmuPka_vlDfeD0APg-1
Received: by mail-qv1-f70.google.com with SMTP id nm17-20020a0562143b1100b004a5a3002d87so6781505qvb.8
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 12:24:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=sYnZZ/3twYWT2HM0ZS6NnUha3knYPuZH8nbGiQU3O6Y=;
        b=qqQpBWeggwWOLy1b8k0JNLjc7EaWYOy0tjrW3LXqmCAyl4Zx01IJIf2djji1PqWlwJ
         9xbAohJOf7w0B9hM4r0brEB5YYcjedxjHtvV2ZO+f4isVyk67YnV2pawyuBXBfyGFSRI
         d7aARDMxIB2p4tAhIqTu1KL8B9T5ATKZ5of1efxK+nh+ERuZto6RSNyA+ISCKrdF22Y9
         A014AEupElIZgBNnciSJ57ZbIGdNU7FDoDwec3xb9jg6Mj29FH54is8cmhNpaDd5XKmc
         ieWSEdV20aXtrQXeTL9A0GBvqyCE86y2JvrRcHTLPrvcRymc/V5qfyQqjSF7YPwahPZq
         AcnA==
X-Gm-Message-State: ACgBeo1fs9dPDoKQ22z+OpOUdvVbeQVlEm0y/nevny/JIzhpUYmJ8xzK
        3XBOuAdu10Hq52i0qHTDTDrPrfPhgQ1jvzlB+O9XJeO51ivou6zt1ZtM7nMffUfjsXfaKPH7/Ri
        YOAZ7VQYssB6OcPZd
X-Received: by 2002:a05:6214:622:b0:4aa:9e48:d469 with SMTP id a2-20020a056214062200b004aa9e48d469mr4547441qvx.65.1662578645215;
        Wed, 07 Sep 2022 12:24:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6ZlbAA5CZ2VKWrhrxKuPB9BV37ohMQbYVc9OBJtHvmQ8Oa7r7SJS/mbUp0rzu5HI59srwtKA==
X-Received: by 2002:a05:6214:622:b0:4aa:9e48:d469 with SMTP id a2-20020a056214062200b004aa9e48d469mr4547428qvx.65.1662578644986;
        Wed, 07 Sep 2022 12:24:04 -0700 (PDT)
Received: from redhat.com ([45.144.113.241])
        by smtp.gmail.com with ESMTPSA id fy9-20020a05622a5a0900b0034359fc348fsm13431448qtb.73.2022.09.07.12.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 12:24:04 -0700 (PDT)
Date:   Wed, 7 Sep 2022 15:23:57 -0400
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
Message-ID: <20220907152156-mutt-send-email-mst@kernel.org>
References: <20220907052317-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54812EC7F4711C1EA4CAA119DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907101335-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907141447-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907151026-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54811F1234CB7822F47DD1B9DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB54811F1234CB7822F47DD1B9DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 07:18:06PM +0000, Parav Pandit wrote:
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Wednesday, September 7, 2022 3:12 PM
> 
> > > Because of shallow queue of 16 entries deep.
> > 
> > but why is the queue just 16 entries?
> I explained the calculation in [1] about 16 entries.
> 
> [1] https://lore.kernel.org/netdev/PH0PR12MB54812EC7F4711C1EA4CAA119DC419@PH0PR12MB5481.namprd12.prod.outlook.com/
> 
> > does the device not support indirect?
> >
> Yes, indirect feature bit is disabled on the device.

OK that explains it.

> > because with indirect you get 256 entries, with 16 s/g each.
> > 
> Sure. I explained below that indirect comes with 7x memory cost that is not desired.
> (Ignored the table memory allocation cost and extra latency).

Oh sure, it's a waste. I wonder what effect does the patch have
on bandwidth with indirect enabled though.


> Hence don't want to enable indirect in this scenario.
> This optimization also works with indirect with smaller indirect table.
> 
> > 
> > > With driver turn around time to repost buffers, device is idle without any
> > RQ buffers.
> > > With this improvement, device has 85 buffers instead of 16 to receive
> > packets.
> > >
> > > Enabling indirect in device can help at cost of 7x higher memory per VQ in
> > the guest VM.

