Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF503B852A
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 16:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbhF3Opa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 10:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234882AbhF3Op3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 10:45:29 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6D0C061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 07:43:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id p17-20020a17090b0111b02901723ab8d11fso1525784pjz.1
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 07:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oj7eg43jZcPFVqKVxbEe/DM2okchzPosN9eNQf+xWrA=;
        b=UawJH8Ve5IYgitSve3SPcqByGCzS7hAVFrQQnEwnTNauLi0SZ0+I5Mva5AXDg4lRGC
         mBreIHUR6lrgxb56Mt6iMKBGw3hys4gmXB81NuOuzZMbyqg6gJJizMWBfdBxyL5V+joY
         Xh1Uh3fGCxxaPVwnC5OQmLQ1SohoRGJTxvhYa1PAN0pQy8KuXJWXkrIDUBLBz40OqYav
         hJGOQUziHCFUGCvnF1Ay21s15xq0FbLtxZPB7DFATSd3Mz7cQa880N5NMBNTg4ATNohg
         VUgtu7xy5jlxKfSbWyu+AjiGrmBe2PBCXC2VY/C5CGDLgeZ4L4s5ZqhfEiQYCV1+qBUI
         Ofkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oj7eg43jZcPFVqKVxbEe/DM2okchzPosN9eNQf+xWrA=;
        b=Lo5C0/rNXg6KSAqe2X3zBcGY8pG7+2bH06Y7ifTRK2TBs6B54NrSQgek7pzUhCn/gm
         p3F+rVxQklW5PvUMdUNUH+iW3m+mt13MkS6wXDHp6rLsxKTgMQQKt+roD/ENyVnnpQ4s
         7fuyKmD0f2+ffYCi5Xq2jSYjBS58kypIO/KgE2YmnvX4F430G69t8eLJJ6K6hVl3i39A
         hKV4jkblF9tz+VhLbZkFJY8B3oHE8WRsxA/Nhi/Tif/atbB/7r+o0eULF26OBHvC/JYI
         sYoj7sRToUhz7qSIFhvMGcyqwSkQHP6lcDQc8uR7fQuyWk3bQhnTOrQ2rOmjz8kt2Tod
         QQvw==
X-Gm-Message-State: AOAM5336SWznT8LYpJqO31vCbMJMMQYwLikQrH0Hj0SDIkPDEwWlJuUO
        uP0BalqVy7dxQnqLzs/Nf1E=
X-Google-Smtp-Source: ABdhPJxC2Bgiz8lUu5nurdH93E6rrjSmLydPKPRKMsG6aKPKGtPYJbTAB9jet18cNldOuyABn2Ojqg==
X-Received: by 2002:a17:902:c38c:b029:128:fd55:f54b with SMTP id g12-20020a170902c38cb0290128fd55f54bmr8435664plg.24.1625064180483;
        Wed, 30 Jun 2021 07:43:00 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w7sm3268410pgr.10.2021.06.30.07.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 07:42:59 -0700 (PDT)
Date:   Wed, 30 Jun 2021 07:42:57 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
Message-ID: <20210630144257.GA30627@hoboy.vegasvil.org>
References: <20210628184611.3024919-1-jonathan.lemon@gmail.com>
 <20210628233056.GA766@hoboy.vegasvil.org>
 <20210629001928.yhiql2dngstkpadb@bsd-mbp.dhcp.thefacebook.com>
 <20210630000933.GA21533@hoboy.vegasvil.org>
 <20210630035031.ulgiwewccgiz3rsv@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630035031.ulgiwewccgiz3rsv@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 08:50:31PM -0700, Jonathan Lemon wrote:
> The PHC should be sync'd to the PPS coming from the GPS signal.
> However, the GPS may be in holdover, so the actual counter comes
> from an atomic oscillator.  As the oscillator may be ever so 
> slightly out of sync with the GPS (or drifts with temperature),
> so we need to measure the phase difference between the two and
> steer the oscillator slightly.
> 
> The phase comparision between the two signals is done in HW 
> with a phasemeter, for precise comparisons.  The actual phase
> steering/adjustment is done through adjphase().

So you don't need the time stamp itself, just the phase offset, right?

> What's missing is the ability to report the phase difference
> to user space so the adjustment can be performed.

So let's create an interface for that reporting.

> Since these events are channel specific, I don't see why
> this is problematic.  The code blocks in question from my
> upcoming patch (dependent on this) is:

The long standing policy is not to add new features that don't have
users.  It would certainly help me in review if I could see the entire
patch series.  Also, I wonder what the user space code looks like.

> I'm not seeing why this is controversial.

It is about getting the right interface.  The external time stamp
interface is generic and all-purpose, and so I question whether your
extension makes sense.

I guess from what you have explained so far that the:

- GPS produces a pulse on the full second.
- That pulse is time stamped in the PHC.
- The HW calculates the difference between the full second and the
  captured time.
- User space steers the PHC based on the difference.

If this is so, why not simply use the time stamp itself?  Or if the
extra number is a correction to the time stamp, why not apply the
correction to the time stamp?

Thanks,
Richard
