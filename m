Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9407B290E10
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 01:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410949AbgJPXQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 19:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393118AbgJPXQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 19:16:52 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED707C061755;
        Fri, 16 Oct 2020 16:16:50 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 10so2343229pfp.5;
        Fri, 16 Oct 2020 16:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=igR2JRxUZsx9VeqjyhWla0GW6mc0OrGGOO2sZ/4GSGw=;
        b=R/Ck/YfRnhuxMc6JuLtu1AwhOE9d6RzebEMS0v+lCaUt00Wy8ZzAtSiwGCGeJ1bvy6
         Np1+Oqff7McieYD2Irz7CaOMByfuXtN9gWBGk32pYjwJWJoppsz09BUA5Eqt3eMVP+4z
         gDa2JN/A4IhXY2CWYHgsYj8VUeWhapLgvumzhFHVtdKQi46v9hulRzWblu77Uq2ASA77
         xL8wOQGES112LDwlOdPghZID1v9I304doRA9zXOv3D6J+XXYMPLZtIYL3EbVYIaShmEt
         58825OHJAQwaAFllkKzDLlJWLtpyZ38BtRxMFV9dkRglJfegihW8uYDKpVPkaD+KdurP
         kk2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=igR2JRxUZsx9VeqjyhWla0GW6mc0OrGGOO2sZ/4GSGw=;
        b=jk1R9K4xr7XiWWX4ETXRqppsrsrCA+CjbodAQm/r3L2dHk+dL4/D4VWtZepCjQ7bOS
         6m86+CeY83SjCjZbbHFKlpuN3yWjjk+m90EfKChMu1jbVqyCEHR//08AVXBP8nShuQVq
         I8tKlRj+4P42eBi9a+WBSXaEnAqlpccG9QtysH57V2IvyMSMUajEk72Q8uGm0lF8GHKM
         f+APDqW2Bq6+39DcjEGrLc0Tsp4itVxQn0DR7S3uCMDydVAPY5Inef7i51TVRFQbj2cX
         pQqupTGccfdsSPLhepvaJ/C+4ntBm4VzdiNSOMi4o9PetFpqU3r4ahX2A3zR7dlqiMOD
         zWhw==
X-Gm-Message-State: AOAM5325ffckS91cMROi5qHC5xLgrRaaPnxGXuzW/jfzV2jDOZ0LtVtb
        aVpxKHY/4XSBlVOvit7NZ3Y=
X-Google-Smtp-Source: ABdhPJzIUhe6rpqQQpdTqA9lxqZEic4rsMwchjGvg9htvspwVRLoQLUhBANu9Nz4PeE7MyFB1RzqQQ==
X-Received: by 2002:a63:5d07:: with SMTP id r7mr5128569pgb.440.1602890210456;
        Fri, 16 Oct 2020 16:16:50 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id b128sm3807930pga.80.2020.10.16.16.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 16:16:49 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Sat, 17 Oct 2020 07:08:21 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/6] staging: qlge: Initialize devlink health dump
 framework for the dlge driver
Message-ID: <20201016230821.zgdc44qt34rzsn5x@Rk>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-2-coiby.xu@gmail.com>
 <20201010073514.GA14495@f3>
 <20201010102416.hvbgx3mgyadmu6ui@Rk>
 <20201010134855.GB17351@f3>
 <20201012112406.6mxta2mapifkbeyw@Rk>
 <20201013003704.GA41031@f3>
 <20201015033732.qaihehernm2jzoln@Rk>
 <20201015110606.GA52981@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201015110606.GA52981@f3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 08:06:06PM +0900, Benjamin Poirier wrote:
>On 2020-10-15 11:37 +0800, Coiby Xu wrote:
>> On Tue, Oct 13, 2020 at 09:37:04AM +0900, Benjamin Poirier wrote:
>> > On 2020-10-12 19:24 +0800, Coiby Xu wrote:
>> > [...]
>> > > > I think, but didn't check in depth, that in those drivers, the devlink
>> > > > device is tied to the pci device and can exist independently of the
>> > > > netdev, at least in principle.
>> > > >
>> > > You are right. Take drivers/net/ethernet/mellanox/mlxsw as an example,
>> > > devlink reload would first first unregister_netdev and then
>> > > register_netdev but struct devlink stays put. But I have yet to
>> > > understand when unregister/register_netdev is needed.
>> >
>> > Maybe it can be useful to manually recover if the hardware or driver
>> > gets in an erroneous state. I've used `modprobe -r qlge && modprobe
>> > qlge` for the same in the past.
>>
>> Thank you for providing this user case!
>> >
>> > > Do we need to
>> > > add "devlink reload" for qlge?
>> >
>> > Not for this patchset. That would be a new feature.
>>
>> To implement this feature, it seems I need to understand how qlge work
>> under the hood. For example, what's the difference between
>> qlge_soft_reset_mpi_risc and qlge_hard_reset_mpi_risc? Or should we use
>> a brute-force way like do the tasks in qlge_remove and then re-do the
>> tasks in qlge_probe?
>
>I don't know. Like I've said before, I'd recommend testing on actual
>hardware. I don't have access to it anymore.

Yeah, as I'm changing more code, it's more and more important to test
it on actual hardware. Have you heard anyone installing qle8142 to
Raspberry Pi which has a PCIe bus.
>
>> Is a hardware reference manual for qlge device?
>
>I've never gotten access to one.
>
My experience of wrestling with an AMD GPIO chip [1] shows it would
be a bit annoying to deal with a device without a reference manual.
I have to treat it like a blackbox and try different kinds of input
to see what would happen.

Btw, it seems resetting the device is a kind of panacea. For example,
according to the specs of my touchpad (Synaptics RMI4 Specification),
it even has the feature of spontaneous reset. devlink health [2] also
has the so-called auto-recovery. So resetting is a common phenomenon. I
wonder if there are some common guidelines to do resetting which also
apply to the qlge8*** devices.

>The only noteworthy thing from Qlogic that I know of is the firmware
>update:
>http://driverdownloads.qlogic.com/QLogicDriverDownloads_UI/SearchByProduct.aspx?ProductCategory=322&Product=1104&Os=190
>
>It did fix some weird behavior when I applied it so I'd recommend doing
>the same if you get an adapter.

Thank you for sharing the info!


[1] https://www.spinics.net/lists/linux-gpio/msg53901.html
[2] https://www.kernel.org/doc/html/latest/networking/devlink/devlink-health.html

--
Best regards,
Coiby
