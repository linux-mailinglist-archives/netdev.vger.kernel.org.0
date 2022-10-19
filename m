Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9FC60456B
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbiJSMfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiJSMf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:35:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0D312909A
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 05:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666181621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rt+KjTtKd5GM/lbgv3ThuxZ4mjfxNVrl70y97s4Oa2I=;
        b=iROx/tYYLluPNorEvABvNQNQNkjqGJTGKXMYTAIZZjTM+SVVQ7bDZFZObj/Uz0YObsQqVz
        fk0c8cjDCJ+jiX0CnI4arnoSeQ6z8QixStdwtITRFJymajf5D3BqoxRtsc6QNKT3Ijjno0
        BKXRuDwJ1S5QYDm6PkvAMLUoy+6rAaQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-385-7NovaFQrNjyvjrV-b6x9Aw-1; Wed, 19 Oct 2022 08:13:39 -0400
X-MC-Unique: 7NovaFQrNjyvjrV-b6x9Aw-1
Received: by mail-wm1-f71.google.com with SMTP id az11-20020a05600c600b00b003c6e3d4d5b1so9594483wmb.7
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 05:13:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rt+KjTtKd5GM/lbgv3ThuxZ4mjfxNVrl70y97s4Oa2I=;
        b=c73dGwJAWWb16jbT6TaBukQDcl5h5uUv0VFAi13t3Xgjwh+6VBF9SJBkXs+8yxoQxj
         UaIkOQuJ94h1WSdD1Njf8da6+cC+GrAx2xUoLQyFy0PImxd5PLHgpYqFvS9dipYO/Nfm
         p9xobjJcm80+WSCxlndmL3MnETfIPOt/7e6asKOhuCMnREcZenuU6Daz81xxYQcGWP4F
         yhnzzFhq6sSYW8up25cwwiIzVD4fhlfNCMy4iY9fpnfdEUoWmmwoD22SOGxy/fv4ENDH
         qzRXhk3MpArJp7Y10Ys8NEbSo1oEVdUBc7s9fUb3GAOrg8nuEj1OXtZgfvdozrsGurOr
         KxgA==
X-Gm-Message-State: ACrzQf39hzxX61bHmCmp3BQO+EfWpaUVwc3FCaJca2qF68p+IauhByxj
        suRK3fGmoy2SNEMD47WPxsLzyl4jsrK4xPkz/OfW9lAWvA4tKLx4EZOsCt69KCK+JNEYd1dmN/U
        y78RiWDeU+1KwMd7Q
X-Received: by 2002:a05:6000:15c7:b0:22e:7aea:f7b1 with SMTP id y7-20020a05600015c700b0022e7aeaf7b1mr4993888wry.213.1666181618815;
        Wed, 19 Oct 2022 05:13:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6JN+v9V/eI4lFO+Gpxy/bvHqkz+lbhiqh+NhJiJzp++eKrJi9AtneI5CkR/vfIsCG6bdbq4w==
X-Received: by 2002:a05:6000:15c7:b0:22e:7aea:f7b1 with SMTP id y7-20020a05600015c700b0022e7aeaf7b1mr4993865wry.213.1666181618507;
        Wed, 19 Oct 2022 05:13:38 -0700 (PDT)
Received: from redhat.com ([2.54.191.184])
        by smtp.gmail.com with ESMTPSA id o36-20020a05600c512400b003c6edc05159sm14710053wms.1.2022.10.19.05.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 05:13:37 -0700 (PDT)
Date:   Wed, 19 Oct 2022 08:13:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Yury Norov <yury.norov@gmail.com>, netdev@vger.kernel.org
Subject: Re: 6.1-rc1 regression: virtio-net cpumask and during reboot
Message-ID: <20221019081320-mutt-send-email-mst@kernel.org>
References: <ac72ff9d-4246-3631-6e31-8c3033a70bf0@linux.ibm.com>
 <20221019074308-mutt-send-email-mst@kernel.org>
 <780306ca-4aba-3cf7-88ca-75e1903f76d0@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <780306ca-4aba-3cf7-88ca-75e1903f76d0@linux.ibm.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 02:11:37PM +0200, Christian Borntraeger wrote:
> Am 19.10.22 um 13:50 schrieb Michael S. Tsirkin:
> > On Wed, Oct 19, 2022 at 12:59:58PM +0200, Christian Borntraeger wrote:
> > > Michael,
> > > 
> > > as a heads-up.
> > > I have not looked into any details yet but we do get the following during reboot of a system on s390.
> > > It seems to be new with 6.1-rc1 (over 6.0)
> > > 
> > >    [    8.532461] ------------[ cut here ]------------
> > >    [    8.532497] WARNING: CPU: 8 PID: 377 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x3d8/0xca8
> > >    [    8.532507] Modules linked in: sha1_s390(+) sha_common virtio_net(+) net_failover failover pkey zcrypt rng_core autofs4
> > >    [    8.532528] CPU: 8 PID: 377 Comm: systemd-udevd Not tainted 6.1.0-20221018.rc1.git15.0fd5f2557625.300.fc36.s390x+debug #1
> > >    [    8.532533] Hardware name: IBM 8561 T01 701 (KVM/Linux)
> > >    [    8.532537] Krnl PSW : 0704e00180000000 00000000b05ec33c (__netif_set_xps_queue+0x3dc/0xca8)
> > >    [    8.532546]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
> > >    [    8.532552] Krnl GPRS: 00000000e7fb8b3f 0000000080000001 00000000b1870700 00000000b0ca1d3c
> > >    [    8.532557]            0000000000000100 0000000000000300 000000008b362500 00000000b133ba48
> > >    [    8.532561]            000000000000000c 0000038000000100 000000000000000c 0000000000000070
> > >    [    8.532566]            0000000084cd3200 0000000000000000 00000000b05ec0c2 00000380010b77c8
> > >    [    8.532575] Krnl Code: 00000000b05ec32e: c0e500187331      brasl   %r14,00000000b08fa990
> > >                              00000000b05ec334: a7f4ff0c          brc     15,00000000b05ec14c
> > >                             #00000000b05ec338: af000000          mc      0,0
> > >                             >00000000b05ec33c: ec76fed8007c      cgij    %r7,0,6,00000000b05ec0ec
> > >                              00000000b05ec342: e310f0b00004      lg      %r1,176(%r15)
> > >                              00000000b05ec348: ec16ffac007c      cgij    %r1,0,6,00000000b05ec2a0
> > >                              00000000b05ec34e: ec680388007c      cgij    %r6,0,8,00000000b05eca5e
> > >                              00000000b05ec354: e310f0b80004      lg      %r1,184(%r15)
> > >    [    8.532600] Call Trace:
> > >    [    8.532604]  [<00000000b05ec33c>] __netif_set_xps_queue+0x3dc/0xca8
> > >    [    8.532609] ([<00000000b05ec0c2>] __netif_set_xps_queue+0x162/0xca8)
> > >    [    8.532614]  [<000003ff7fbb81ce>] virtnet_set_affinity+0x1de/0x2a0 [virtio_net]
> > >    [    8.532622]  [<000003ff7fbbb674>] virtnet_probe+0x4d4/0xc08 [virtio_net]
> > >    [    8.532630]  [<00000000b04ec4e8>] virtio_dev_probe+0x1e8/0x418
> > >    [    8.532638]  [<00000000b05350ea>] really_probe+0xd2/0x480
> > >    [    8.532644]  [<00000000b0535648>] driver_probe_device+0x40/0xf0
> > >    [    8.532649]  [<00000000b0535fac>] __driver_attach+0x10c/0x208
> > >    [    8.532655]  [<00000000b0532542>] bus_for_each_dev+0x82/0xb8
> > >    [    8.532662]  [<00000000b053422e>] bus_add_driver+0x1d6/0x260
> > >    [    8.532667]  [<00000000b0536a70>] driver_register+0xa8/0x170
> > >    [    8.532672]  [<000003ff7fbc8088>] virtio_net_driver_init+0x88/0x1000 [virtio_net]
> > >    [    8.532680]  [<00000000afb50ab0>] do_one_initcall+0x78/0x388
> > >    [    8.532685]  [<00000000afc7b5b8>] do_init_module+0x60/0x248
> > >    [    8.532692]  [<00000000afc7ce96>] __do_sys_init_module+0xbe/0xd8
> > >    [    8.532698]  [<00000000b09123b2>] __do_syscall+0x1da/0x208
> > >    [    8.532704]  [<00000000b0925b12>] system_call+0x82/0xb0
> > >    [    8.532710] 3 locks held by systemd-udevd/377:
> > >    [    8.532715]  #0: 0000000089af5188 (&dev->mutex){....}-{3:3}, at: __driver_attach+0xfe/0x208
> > >    [    8.532728]  #1: 00000000b14668f0 (cpu_hotplug_lock){++++}-{0:0}, at: virtnet_probe+0x4ca/0xc08 [virtio_net]
> > >    [    8.532744]  #2: 00000000b1509d40 (xps_map_mutex){+.+.}-{3:3}, at: __netif_set_xps_queue+0x88/0xca8
> > >    [    8.532757] Last Breaking-Event-Address:
> > >    [    8.532760]  [<00000000b05ec0e0>] __netif_set_xps_queue+0x180/0xca8
> > 
> > 
> > Does this fix it for you?
> > 
> > https://lore.kernel.org/r/20221017030947.1295426-1-yury.norov%40gmail.com
> 
> Yes, it does. Thanks a lot.
> 
> Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>

You will want to reply to that one P).

-- 
MST

