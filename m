Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC46290A7F
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 19:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390646AbgJPRTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 13:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390386AbgJPRTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 13:19:41 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6D8C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 10:19:39 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id t21so3231079eds.6
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 10:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TZiDKOsJ7YsZPhT+2ifIwa7V0HOvOhHvnljt25X3cq8=;
        b=RGJaNDcDXhfUlJk4wGdkIExmVk9PyOt643ZDyBhyt3Eyxc7n/ZqZjcRh+8Q5vsEfQM
         6HssJn6bFOBtVg5PGZ3f6D81fxC9cnWhsLUbowLQVIucOl5pYHUmuuGyVhNccgU93nS6
         ORSfdbyqVqCA2hV1KL9cA+JWofl1wzfi1xYGcCEEevAhoDCSHlsDeg4P3KLPP8HgauMJ
         9S4zYOoasvfIAd99xBmPVuFY0dK1BeaGIHUz6L4NI5CLAIuWD2u++ytehUgQ/1pzqbqQ
         Y3S52t/H/lkM0Es6n7bSqSYm5EkBxnKBpAPN3OXSXFzxlo4PwrZp0bR6Hfr8rGKnzIQm
         Z/TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TZiDKOsJ7YsZPhT+2ifIwa7V0HOvOhHvnljt25X3cq8=;
        b=t69DjJjTOQe/FWfpyuKK1aULAPIFxfp/sqrfcV3mJIVYgo2nMewpiUvuwDs9O/br50
         FJpOdgxfBjsz3DzFCD4IDkBqFq3Krkd5VomveuhYrvabW2ZyXFwCX5Ay50APle49LAGE
         D1F0CHCgkIJMKmksh8OG2Qzi97Dl1NtKx1sKQ1sIGXQOv7c/Av0Wb0ZiwHXDxmxu48Xm
         Z/fywgAUgPgOqB/zzd0nig1fZAKK5gZqAlrSpMgyN5gWCU9u0auC4agh+DYD0iF8boY/
         mzNDRhrX+0FjZ9W7moADNI1MSeIhwl9iw6ZHinKATgRL3A40PeTkqxgWHWAy5dvsG9US
         d7VQ==
X-Gm-Message-State: AOAM531GL7Y4/SyPSC1g5EAXhiC2+DKHI3ZwPZR0GowGuY7HPPBR3bva
        JZzbrWTYcdOmS268geSEM7M=
X-Google-Smtp-Source: ABdhPJywSkZNFATyx47TvvRvMYTPCXQw5JZlDq8wx6hfB7JDvXrEiuUPwmAKh3Q/PGcDvYe/Cu3Ekg==
X-Received: by 2002:aa7:c90a:: with SMTP id b10mr5239099edt.163.1602868778066;
        Fri, 16 Oct 2020 10:19:38 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id a27sm2161214ejb.67.2020.10.16.10.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 10:19:37 -0700 (PDT)
Date:   Fri, 16 Oct 2020 20:19:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mike Galbraith <efault@gmx.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Subject: Re: [patchlet] r8169: fix napi_schedule_irqoff() called with irqs
 enabled warning
Message-ID: <20201016171936.vidrappu4gdiv5cm@skbuf>
References: <9c34e18280bde5c14f40b1ef89a5e6ea326dd5da.camel@gmx.de>
 <7e7e1b0e-aaf4-385c-b82c-79cac34c9175@gmail.com>
 <20201016142611.zpp63qppmazxl4k7@skbuf>
 <42ff951039f3c92def8490d3842e3f7eaf6900ff.camel@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42ff951039f3c92def8490d3842e3f7eaf6900ff.camel@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 07:11:22PM +0200, Mike Galbraith wrote:
> Yeah, it's a straight up correctness issue as it sits.

Yeah, tell me about it, you don't even want to know what it looks like
when the local_softirq_pending_ref percpu mask gets corrupted. The
symptom will be that random syscalls, like clock_nanosleep, will make
user processes hang in the kernel, because their timers will appear to
never expire. You'll also see negative expiry times in /proc/timer_list.
Eventually the entire system dies. All of that, reproducible with a
simple flood ping, given enough time.  Ask me how I come to know....
The 215602a8d212 ("enetc: use napi_schedule to be compatible with
PREEMPT_RT") commit is from before the lockdep warning came to be.
