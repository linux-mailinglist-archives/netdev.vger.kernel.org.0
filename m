Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BFE2CEECC
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 14:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgLDNd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 08:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgLDNd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 08:33:58 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0440C0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 05:33:17 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id e5so3084415pjt.0
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 05:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zsUtn/BN7RGWNRiP0GOeAP0ayPcDZClOFUtCVxGLjao=;
        b=tGJ81PQSHvRuz8azi/uu2gthptS+VUi3dOUfv/ZkWfF3Bb0K/nmjNnYfRuMP4m6Fea
         21U7mBmJ+BLWcpxi5oHZpTYuHvIBMuigQeiJhr0VIbccJvA2b655cWeZdKyDJIXCjIQ+
         7XF6TRPQcnYW3zzshjTXqfhHd0Kh7oDEvlgKtyoBD36WxQQ/FnntfEAxBdJtS2xkiQmp
         fEN1HAbea/jR7dUBmZ0u4krKHtcW99mSkQIAaNDRKznqZ1Cx4O9uAJsqGOTz6ixDuRDB
         vHpp5wjhYygOHoVH/2W2D8TxpuOJFKBTlmVqP3Uww6LLwd1QqSW9l+ylUoXtdGcT05MQ
         /H7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zsUtn/BN7RGWNRiP0GOeAP0ayPcDZClOFUtCVxGLjao=;
        b=S03AozieSprcFDOdgC2t3lqYLQCmW3FLQfMSZd+fxW1nfj1mWQi4PNV2cFdSPC6C/9
         HHaz02N0mn3L5QnjSOjAC/gQCQfyjmqT2DP8+NKv541caon7Xc8+/tDHHLXHTCn/N3o1
         4kevw076mbRzJXllQ5iPiO11VLiKz1TPf6yjZoDlSuGQqXL/0K5IQMeomOkOuJj7Q1uK
         Cj2y7Ro9xEznBoIO615bMJDNDKpNP9OU+flG9cz2y4LauUpgporR45U/4na8C+/bPFpd
         Cxp0Jrl1FHKDBwXw5Pg4aiKe3Xc5Zs/GQVCwVOFf4Vgv0SF+kbnKKfNfRXSrlQ/Jb1XX
         nbFw==
X-Gm-Message-State: AOAM531S335YPlsc4a2j60m8Rpgoi+PnZzzcilksl66A0tnbJZV9YYTh
        uARSKlHk2aqCICiTlmhO6Ow=
X-Google-Smtp-Source: ABdhPJxkRiysxI4RQlnS45rnvcpAqhHE/kAJfvq/L/JLxA2KUfURLaXBrs+tkZDW2t/Uv4Qe/OVqiQ==
X-Received: by 2002:a17:902:8d82:b029:d8:c5e8:9785 with SMTP id v2-20020a1709028d82b02900d8c5e89785mr3937626plo.5.1607088797446;
        Fri, 04 Dec 2020 05:33:17 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id v63sm4817401pfb.217.2020.12.04.05.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 05:33:16 -0800 (PST)
Date:   Fri, 4 Dec 2020 05:33:14 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 net-next] ptp: Add clock driver for the OpenCompute
 TimeCard.
Message-ID: <20201204133314.GA26030@hoboy.vegasvil.org>
References: <20201203182925.4059875-1-jonathan.lemon@gmail.com>
 <20201204005624.GC18560@hoboy.vegasvil.org>
 <20201204020037.jeyzulaqp4kd4pnv@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204020037.jeyzulaqp4kd4pnv@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 06:00:37PM -0800, Jonathan Lemon wrote:
> On Thu, Dec 03, 2020 at 04:56:24PM -0800, Richard Cochran wrote:

> > The name here is a bit confusing since "timex" has a special meaning
> > in the NTP/PTP API.
> 
> The .gettimex64 call is used here so the time returned from the
> clock can be correlated to the system time.

[facepalm] man, its in the interface naming.  Oh well.

> > This driver looks fine, but I'm curious how you will use it.  Can it
> > provide time stamping for network frames or other IO?
> 
> The card does have a PPS pulse output, so it can be wired to a network
> card which takes an external PPS signal.

Cool.  So the new ts2phc program can synchronize the NICs for you.
All that is missing here is ptp_clock_info.enable().  With that in
place, it will work out of the box.

> Right now, the current model (which certainly can be improved on) is using
> phc2sys to discipline the system and NIC clocks.

Yeah, ts2phc will fill in the gap.
 
> I'll send a v3.  I also need to open a discussion on how this should
> return the leap second changes to the user - there doesn't seem to be
> anything in the current API for this.

There is the clock_adjtime() system call, analogue of adjtimex.

Right now there is no PHC driver access to the timex.status field
(which carries the leap flags), but that can be changed...

kernel/time/posix-timers.c	do_clock_adjtime()  calls
kernel/time/posix-clock.c	pc_clock_adjtime()  calls
drivers/ptp/ptp_clock.c		ptp_clock_adjtime()

At this point the PHC layer could invoke a new, optional driver
callback that returns the leap second status flags, and then the PHC
layer could set timex.status appropriately.


Having said all that, the ts2phc program takes the approach of getting
the leap second information from the leap seconds file.  Of course,
this requires administratively updating the file at least once every
six months.

I considered and rejected the idea of trying to get the current leap
second status from GPS for two reasons.  First, there is no
standardized and universally implemented way of querying this from a
GPS.  Second, and more importantly, the leap second information is
only broadcast every 12.5 minutes, and that it is *way* too long to
wait after cold boot for applications I am interested in.

So the choice boiled down to either having to keep a file up to date,
say every month or so, or waiting 15 minutes in the worst case.  I
chose the lesser of two evils.

Thanks,
Richard
