Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7673B9539
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 19:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhGARJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 13:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbhGARJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 13:09:46 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD946C061762
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 10:07:15 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b12so5347880pfv.6
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 10:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6FMY/kxmgn4j+MFoV2yKtdR5pbXvSpbLhYPD+QyU59k=;
        b=iezfM3navqMPjlGMFCettuoByytPdCx0/NiGTFWg8rDYjxaOFYPktP8nhPgowKE/YF
         6tJWId28b/m7Q2l6DU0wDjYlXIKjzLJQcECK6RZF+Iy2DucjizysiIY3FDVfUn04iThs
         tj6o/PSn4XcgduoptiW44K6Li5GAoKvYaD9VQIqgxHqvl2ReG7Obz33rXXH+qPcMqpbB
         gGnws3Zhz/C5EInHaUYSk0dn/RJxsh+cuoZf2SwMyeCvMSEm9L1ahuK5/mxXTx/+DTXe
         zh88I1NfdnOBkkNwk9jrEs/puVj8N90eMpEHkPdWKrqRUsmxNeFt7Ce6635pSnQOwUxM
         xItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6FMY/kxmgn4j+MFoV2yKtdR5pbXvSpbLhYPD+QyU59k=;
        b=SBtJbNF51UmhBh25W2eWBBABg11BWnU2PcQAAXtNC1rcpJvAk+2vJRyNxmNt6HqlA5
         g5G6kAsjgbz9YuBUb8ZfNhawe+GhFZtV5IBY3Ytx3frphcYAPANUwaNkwiMH7DYGQm30
         GI1XqzUdRb83+sBb8fGDgjB6qBfW0/8rMoki92jCbkYwmDIGIkr5FM51R4Zsma/0Hm3G
         45kw84oGnMY7CCAV7/j1gKzl855cbBM9Q3NPwmWzGQ0gRWr1Ww7FdDJbi4hTfODzN51Z
         Do3NU0paSuOKjAXOOln1QSGUzdM1yM0cb42gCcQ+80FwZQHD7XpS9abi8mWQncoJ14h7
         09lQ==
X-Gm-Message-State: AOAM532vztown5a9EpNqQqp4Pv85pCkNGbmZFDtWe7mFWOGYZT+V7aNo
        FMQTa5E1XcL57C9VQwOZ31o=
X-Google-Smtp-Source: ABdhPJyBTQ0Pobk9HOnuuAInTN+w81uz/HO3qQGfhhhW14k+QDnb1RhthBSPkJk0gzTui+5EBMZaLQ==
X-Received: by 2002:a63:4719:: with SMTP id u25mr577739pga.193.1625159235226;
        Thu, 01 Jul 2021 10:07:15 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p45sm605529pfw.19.2021.07.01.10.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 10:07:14 -0700 (PDT)
Date:   Thu, 1 Jul 2021 10:07:12 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
Message-ID: <20210701170712.GB24430@hoboy.vegasvil.org>
References: <20210628184611.3024919-1-jonathan.lemon@gmail.com>
 <20210628233056.GA766@hoboy.vegasvil.org>
 <20210629001928.yhiql2dngstkpadb@bsd-mbp.dhcp.thefacebook.com>
 <20210630000933.GA21533@hoboy.vegasvil.org>
 <20210630035031.ulgiwewccgiz3rsv@bsd-mbp.dhcp.thefacebook.com>
 <20210701145935.GB22819@hoboy.vegasvil.org>
 <20210701161555.y4p6wz6l6e6ea2vg@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701161555.y4p6wz6l6e6ea2vg@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 09:15:55AM -0700, Jonathan Lemon wrote:
> static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
>                                        struct ptp_clock_event *src)
> {
>         struct ptp_extts_event *dst;
>         unsigned long flags;
>         s64 seconds;
>         u32 remainder;
> 
>         seconds = div_u64_rem(src->timestamp, 1000000000, &remainder);
> 
> 
> It seems like there should be a way to use pps_times here instead
> of needing to convert back and forth.

You could re-factor that to have two callers, with the part that
enqueues in a shared helper function.  The only reason the API has a
64 bit word instead of a timespec is that many, but not all drivers
use timecounter_cyc2time() or similar to calculate the time stamp.

But the ptp_clock_event is really meant to be polymorphic, with
pps_times only set for traditional NTP PPS events (activated by the
PTP_ENABLE_PPS ioctl).

 * struct ptp_clock_event - decribes a PTP hardware clock event
 *
 * @type:  One of the ptp_clock_events enumeration values.
 * @index: Identifies the source of the event.
 * @timestamp: When the event occurred (%PTP_CLOCK_EXTTS only).
 * @pps_times: When the event occurred (%PTP_CLOCK_PPSUSR only).

The PTP_CLOCK_EXTTS is different.  It is meant for generic time
stamping of external signals, activated by the PTP_EXTTS_REQUEST
ioctl.

I'm not sure which type is better suited to your HW.

Thanks,
Richard
