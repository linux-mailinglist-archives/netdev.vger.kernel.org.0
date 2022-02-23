Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174744C06A4
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbiBWBKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiBWBKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:10:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10B7ABC95
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 17:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645578579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VOIdj8LfS1quF8HrsiYyhYsFd/6gruTfw8BZDYs3h9Q=;
        b=Q8z5AHlGkwtB/ZiQ9rYuuSOmV7/9aO0iHTpRrN46FbzIvtd35r6JBr064o86G0hlMcD7rO
        kTFoU9wv+0Z42nPgzXNl7gVCk0e7MABMo1QclqAX5ztiWmyViyWKC7kyHz4K52nKAn6hrq
        6JTYQLocPYctCBEKxK9WmEeIg9zKDqk=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-5PmdCrTvP6m4MzK2xIuJDQ-1; Tue, 22 Feb 2022 20:09:37 -0500
X-MC-Unique: 5PmdCrTvP6m4MzK2xIuJDQ-1
Received: by mail-oi1-f197.google.com with SMTP id w19-20020a0568080d5300b002d54499cc1eso1630689oik.19
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 17:09:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=VOIdj8LfS1quF8HrsiYyhYsFd/6gruTfw8BZDYs3h9Q=;
        b=P5K4xrA7TFnDKaoMOk/UhDsDV6AcaVVIJuzh6PMWrk67JmvKpOVsxwcHuE0mWWYQUV
         aof7pANr5u0ifIDNZjGiXdnWl5ndaGB5ffuzoAIAVnPjxkzIev+t1z/fw0HzZu93yCOB
         4J5i0wS73H9MD0a0JpeBOm7dERUMJufnHGDgXZBluNDVAL7CJtASh6nDwob/sy8s+DuB
         yI8dQJrrIUpjvsPtO7LPgnmPV7c/nNGarbGPkpmHjWWbQ4UIJDIhiABxDD53Ci4SCAlM
         vLunlI+KA/CE4U7swNbos8l46jQzA4KLmWSr5Dv/oGbPD8LprJQkTLcGn1+DYnhntI1c
         lbJg==
X-Gm-Message-State: AOAM530SLSgZZnk/xKH61tkxfu39Yjdb4plzwzqDeXgr1oDx1uO8gHHD
        fiTexr6VWrqi5pbwyQP5y76pZxHikHPREkJtEfWjne8FH5jD2p2BEPMOs9HAm9M/1DDxjuTOB7w
        0XfhFbrnqBnufZoId
X-Received: by 2002:a05:6808:1a18:b0:2d3:a839:9a63 with SMTP id bk24-20020a0568081a1800b002d3a8399a63mr3283074oib.49.1645578577030;
        Tue, 22 Feb 2022 17:09:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw5kyhFx4+htnaM0l3I91ItDe+zVVFp1ujuNqQfpVUdehcJhe7A8Z6BfQmGQdwscqGL0UVHKw==
X-Received: by 2002:a05:6808:1a18:b0:2d3:a839:9a63 with SMTP id bk24-20020a0568081a1800b002d3a8399a63mr3283060oib.49.1645578576728;
        Tue, 22 Feb 2022 17:09:36 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q9sm1644757oif.9.2022.02.22.17.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 17:09:36 -0800 (PST)
Date:   Tue, 22 Feb 2022 18:09:34 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V8 mlx5-next 09/15] vfio: Define device migration
 protocol v2
Message-ID: <20220222180934.72400d6a.alex.williamson@redhat.com>
In-Reply-To: <20220223002136.GG10061@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
        <20220220095716.153757-10-yishaih@nvidia.com>
        <20220222165300.4a8dd044.alex.williamson@redhat.com>
        <20220223002136.GG10061@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Feb 2022 20:21:36 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Feb 22, 2022 at 04:53:00PM -0700, Alex Williamson wrote:
> > On Sun, 20 Feb 2022 11:57:10 +0200
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >   
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > 
> > > Replace the existing region based migration protocol with an ioctl based
> > > protocol. The two protocols have the same general semantic behaviors, but
> > > the way the data is transported is changed.
> > > 
> > > This is the STOP_COPY portion of the new protocol, it defines the 5 states
> > > for basic stop and copy migration and the protocol to move the migration
> > > data in/out of the kernel.
> > > 
> > > Compared to the clarification of the v1 protocol Alex proposed:
> > > 
> > > https://lore.kernel.org/r/163909282574.728533.7460416142511440919.stgit@omen
> > > 
> > > This has a few deliberate functional differences:
> > > 
> > >  - ERROR arcs allow the device function to remain unchanged.
> > > 
> > >  - The protocol is not required to return to the original state on
> > >    transition failure. Instead userspace can execute an unwind back to
> > >    the original state, reset, or do something else without needing kernel
> > >    support. This simplifies the kernel design and should userspace choose
> > >    a policy like always reset, avoids doing useless work in the kernel
> > >    on error handling paths.
> > > 
> > >  - PRE_COPY is made optional, userspace must discover it before using it.
> > >    This reflects the fact that the majority of drivers we are aware of
> > >    right now will not implement PRE_COPY.
> > > 
> > >  - segmentation is not part of the data stream protocol, the receiver
> > >    does not have to reproduce the framing boundaries.  
> > 
> > I'm not sure how to reconcile the statement above with:
> > 
> > 	"The user must consider the migration data segments carried
> > 	 over the FD to be opaque and non-fungible. During RESUMING, the
> > 	 data segments must be written in the same order they came out
> > 	 of the saving side FD."
> > 
> > This is subtly conflicting that it's not segmented, but segments must
> > be written in order.  We'll naturally have some segmentation due to
> > buffering in kernel and userspace, but I think referring to it as a
> > stream suggests that the user can cut and join segments arbitrarily so
> > long as byte order is preserved, right?    
> 
> Yes, it is just some odd language that carried over from the v1 language
> 
> > I suspect the commit log comment is referring to the driver imposed
> > segmentation and framing relative to region offsets.  
> 
> v1 had some special behavior where qemu would carry each data_size as
> a single unit to the other side present it whole to the migration
> region. We couldn't find any use case for this, and it wasn't clear if
> this was deliberate or just a quirk of qemu's implementation.
> 
> We tossed it because doing an extra ioctl or something to learn this
> framing would hurt a zero-copy async iouring data mover scheme.

It was deliberate in the v1 because the data region might cover both
emulated and direct mapped ranges and might do so in combinations.  For
instance the driver could create a "frame" where the header lands in
emulated space to validate sequencing and setup the fault address for
mmap access.  A driver might use a windowing scheme to iterate across a
giant framebuffer, for example.
 
> > Maybe something like:
> > 
> > 	"The user must consider the migration data stream carried over
> > 	 the FD to be opaque and must preserve the byte order of the
> > 	 stream.  The user is not required to preserve buffer
> > 	 segmentation when writing the data stream during the RESUMING
> > 	 operation."  
> 
> Yes
> 
> > > + * The kernel migration driver must fully transition the device to the new state
> > > + * value before the operation returns to the user.  
> > 
> > The above statement certainly doesn't preclude asynchronous
> > availability of data on the stream FD, but it does demand that the
> > device state transition itself is synchronous and can cannot be
> > shortcut.  If the state transition itself exceeds migration SLAs, we're
> > in a pickle.  Thanks,  
> 
> Even if the commands were async, it is not easy to believe a device
> can instantaneously abort an arc when a timer hits and return to full
> operation. For instance, mlx5 can't do this.
> 
> The vCPU cannot be restarted to try to meet the SLA until a command
> going back to RUNNING returns.
> 
> If we want to have a SLA feature it feels better to pass in the
> deadline time as part of the set state ioctl and the driver can then
> internally do something appropriate and not have to figure out how to
> juggle an external abort. The driver would be expected to return fully
> completed from STOP or return back to RUNNING before the deadline.
> 
> For instance mlx5 could possibly implement this by checking the
> migration size and doing some maths before deciding if it should
> commit to its unabortable device command.
> 
> I have a feeling supporting SLA means devices are going to have to
> report latencies for various arcs and work in a more classical
> realtime deadline oriented way overall. Estimating the transfer
> latency and size is another factor too.
> 
> Overall, this SLA topic looks quite big to me, and I think a full
> solution will come with many facets. We are also quite interested in
> dirty rate limiting, for instance.

So if/when we were to support this, we might use a different SET_STATE
feature ioctl that allows the user to specify a deadline and we'd use
feature probing or a flag on the migration feature for userspace to
discover this?  I'd be ok with that, I just want to make sure we have
agreeable options to support it.  Thanks,

Alex

