Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1603F3D0C
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 03:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhHVBvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 21:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhHVBvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 21:51:19 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9725C061575;
        Sat, 21 Aug 2021 18:50:39 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id a5so8136172plh.5;
        Sat, 21 Aug 2021 18:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oWp1bCl+FkafN8ehqG1SL+8snffxC7uBzDFP9htK1G0=;
        b=EDsXk0O+yaU/ooYbZDgUp+OQydPSecEWpi1/jVpkgCJW/dnOMhbWGVZ1Ypd8CM9SYM
         CjSb+2+pJAwZSQO5VeeymUWEChwYjinlhBjrPFVIE3Z1uWHlKj4D2sYChyODlzPJ8PtN
         mdNxFgPWKIEmqmERV7Wmd4tlCCYPpEjhrpxYICDRnSoCoRE23hnuLXUwFDY/xwemASUD
         mQ4mfyaBZvWv+SDSDsLsvq3vV6It1okuSMTacA+aH+h8Ykha/V9j3YD54QVvKKgclY4y
         Ar4D/3hNHk4RSPIPfasFrzf1dYHSpEwOEyqgkvc8FLbNpxABPTchc74w+Xk9PAOb6SyN
         4vOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oWp1bCl+FkafN8ehqG1SL+8snffxC7uBzDFP9htK1G0=;
        b=riwXW1kcL4mhRmi34A0ncexjgJRcLVjjibZm/8F9hBHZlyUFvr5VBb/H/oIu/3ndvg
         6CAe+vkGuAKkQLkvWREWOOELZaj+RbNU/4tqfGHDtRYc3fAkcc3MvmTTQH77BD/Q9djk
         NBkvse9UEEUmLmGQdVFF3/wc/2teWLGfhW7yGdZh+ZQJBnR93cc56AXtieJpeLJXILHI
         updVFZFHfzStZ0bxrkDevg6yD9ouaLzO6AHWrDY7HrknVf3hdbt4JOIgrJDLi+tOTiOd
         quiqTVs44N7aQV6efPR/YnhuX3CIMIkhki1IZHFi8C/o8oXY98SXA+iGYFePNysXeBcW
         xb9A==
X-Gm-Message-State: AOAM530bguVyCsBZAtBjxs/euMTCgBFsUvR+8phdOViBD9+QJdftQdDJ
        CeqLoIXdvEc6Uyga2uxzUKY=
X-Google-Smtp-Source: ABdhPJx/tnhxP6xZoi5T1FkxGUSKU/5c7OQbRfs54tq3YF8VsW0rc//ElWYFLWb2Ibxemaog9uPggw==
X-Received: by 2002:a17:90a:fa3:: with SMTP id 32mr12633225pjz.68.1629597039169;
        Sat, 21 Aug 2021 18:50:39 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id o10sm9699171pjg.34.2021.08.21.18.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 18:50:38 -0700 (PDT)
Date:   Sat, 21 Aug 2021 18:50:35 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "Bross, Kevin" <kevin.bross@intel.com>,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Ahmad Byagowi <abyagowi@fb.com>
Subject: Re: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL state
Message-ID: <20210822015035.GB4545@hoboy.vegasvil.org>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-2-arkadiusz.kubalewski@intel.com>
 <20210816235400.GA24680@hoboy.vegasvil.org>
 <PH0PR11MB4951762ECB04D90D634E905DEAFE9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210818170259.GD9992@hoboy.vegasvil.org>
 <PH0PR11MB495162EC9116F197D79589F5EAFF9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210819153414.GC26242@hoboy.vegasvil.org>
 <PH0PR11MB4951F51CBA231DFD65806CDAEAC09@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210820155538.GB9604@hoboy.vegasvil.org>
 <PH0PR11MB49518ED9AAF8B543FD8324B9EAC19@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB49518ED9AAF8B543FD8324B9EAC19@PH0PR11MB4951.namprd11.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 06:30:02PM +0000, Machnikowski, Maciej wrote:

> I did a talk at netDev 0x15 covering SyncE - you can refer to the slides for more detailed info, and hopefully the recording will be available soon as well:
> https://netdevconf.info/0x15/session.html?Introduction-to-time-synchronization-over-Ethernet

These slides are very clear and nicely done!

( And they also confirm that (ab)using the PHC chardev ioctl for the DPLL
stuff is the wrong interface ;^)

> The SyncE capable PHY is a PHY that can recover the physical clock,
> at which the data symbols are transferred, (usually) divide it and
> output it to the external PLL. It can also redirect the recovered
> and divided clock to more than one pin.

Right, and as your slides show so clearly, the DPLL is connected to
the PHY, not to the time stamping unit with the PTP clock.

> Since the 40.5.2 is not applicable to higher-speed ethernet which
> don't use auto-negotiation, but rather the link training sequence
> where the RX side always syncs its clock to the TX side.

I really want an interface that will also work with Gigabit and even
100 Megabit like the PHYTER (which does support SyncE).
 
> The external DPLL tunes the frequency generated by a crystal to the frequency recovered by the PHY, and drives the outputs.
> 
> On the other end - the SyncE PHY uses the clock generated by the DPLL to transmit the data to the next element.

So I guess that this is an implementation detail of the higher speed PHYs.

> That's why the RFC proposes 2 interfaces:
> - one for enabling redirected clock on a selected pin of the PHY
> - one for the physical frequency lock of the DPLL
> 
> The connection with the PTP subsystem is that in most use cases I
> heard about SyncE is used as a physical frequency syntonization for
> PTP clocks.

As your slides correctly show, SyncE is about distributing frequency
and not about Phase/ToD.  Of course you can combine SyncE with PTP to
get both, provided that you disable frequency adjustment in the PTP
software stack (in linuxptp, this is the "nullf" servo).  But SyncE in
fact predates PTP, and it can and should be configurable even on
interfaces that lack PHC altogther (or on kernels without PHC
enabled).

> Let me know if that makes more sense now. We could add a separate
> SyncE and separate PTP DPLL monitoring interfaces, but in most cases
> they will point to the same device.

This is just a coincidence of the device you are working with.  The
kernel really needs an interface that works with all kind of hardware
setups.  Imagine a computer with discrete MACs with HW time
stamping/PHC and discrete PHYs with SyncE support.  The PHC driver
won't have any connection to the PHY+DPLL.

Your API must be on the interface/MAC, with the possibility being
handled directly by the MAC driver (for integrated devices) or calling
into the PHY layers (phylib, phylink, and drivers/phy).

If you need a DPLL monitoring interface for your card, it ought to go
through the network interface to the MAC/PHY driver and then to the
DPLL itself.  That way, it will work with different types of hardware.

Thanks,
Richard
