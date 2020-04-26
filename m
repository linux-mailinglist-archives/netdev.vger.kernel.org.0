Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3231B8B5B
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 04:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgDZCl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 22:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726108AbgDZCl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 22:41:58 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF9FC061A0C
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 19:41:58 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o10so6822213pgb.6
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 19:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daemons-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8IYtAFbciShiT0fdAfMZ7efWbaDf5FVfgYocgiOQmLY=;
        b=pzZUWK2zE3hDKPt0z+xKXHSnYR5OsS66t3vLlXJdGANDheH4kv3ix2G7IwwIfuM/++
         5cx+gvqppJ7Sw9M9gr67rXDNiV9ZBcy87U30CzoqgLnT1bofMIpVfFcBhnTOU0srlMiB
         14ahowJMGii7i3/TcN4bmLIAbz6dRnUDgZwF2eWv+iYYegH7WJQEEWsWPbANIE+fxQyN
         qzU3Zb6hlWv4PuQfdZ+RBs4Hh8tnh/52iVG04WpcV3xamYthlY8mLoFfASV1u+NR8Hwv
         u+gok2cabH2OyWHTzPU7NoyIwPgAYV09NyQy1SxMjU8t70QtLfcsfYSUlV69pTZ+MhEQ
         Jy5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8IYtAFbciShiT0fdAfMZ7efWbaDf5FVfgYocgiOQmLY=;
        b=Qt1jxYXfi197/bKbGj+IJEhp2Y1KeVQpMIu1YcvzEYiDuRnRe1cXUh43RhF/x/pQI1
         t6lqtsKHlVsaqJ1FNmH1Bw88kBbk0Jsl13sj2KarxN/075SbZNJynS4dVX2veAhYBftK
         Sw58Lmmi8tNG7Ospb3j3cr69CQ454P0a+X7a3c9Y1PuX4vVyv1lh8hwO3+oGg3M60sKY
         bhcpsxIq+G2f8s4QbuFHs+WhjLz7Qyu0ybF6YSZuZqIreAie7uz1HS2Mx33pDM7KVKVd
         23zWRjpzjG7B79Y33z896Wx8GuHknmoW8IibdCHXFuVyKtzvb6VJMeruerA3F8510PLZ
         zZrg==
X-Gm-Message-State: AGi0PuZiIKBdNOhmB0C15ZsIrq+t69YasmM1V1F5tKqe5Xq5JpuWZ0xy
        a9q1JWppxUVesNkOkN1S1RJq
X-Google-Smtp-Source: APiQypKanNvXzEfJDheKFu5G0bbgJXwkyIReS7EZeZs81CHXrv8w7saQmPQLndnf0ytO7863V9mstA==
X-Received: by 2002:a63:7901:: with SMTP id u1mr16081297pgc.409.1587868917553;
        Sat, 25 Apr 2020 19:41:57 -0700 (PDT)
Received: from arctic-shiba-lx ([47.156.151.166])
        by smtp.gmail.com with ESMTPSA id 13sm9074035pfv.95.2020.04.25.19.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2020 19:41:56 -0700 (PDT)
Date:   Sat, 25 Apr 2020 19:41:48 -0700
From:   Clay McClure <clay@daemons.net>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: cpts: Condition WARN_ON on PTP_1588_CLOCK
Message-ID: <20200426024148.GA7518@arctic-shiba-lx>
References: <6fef3a00-6c18-b775-d1b4-dfd692261bd3@ti.com>
 <20200420093610.GA28162@arctic-shiba-lx>
 <CAK8P3a36ZxNJxUS4UzrwJiMx8UrgYPkcv4X6yYw7EC4jRBbbGQ@mail.gmail.com>
 <20200420170051.GB11862@localhost>
 <CAK8P3a11CqpDJzjy5QfV-ebHgRxUu8SRVTJPPmsus1O1+OL72Q@mail.gmail.com>
 <20200420211819.GA16930@localhost>
 <CAK8P3a18540y3zqR=mqKhj-goinN3c-FGKvAnTHnLgBxiPa4mA@mail.gmail.com>
 <20200420213406.GB20996@localhost>
 <CAK8P3a22aSbpcVK-cZ6rhnPgbYEGU3z__G9xk1EexOPZd5Hmzw@mail.gmail.com>
 <c04458ed-29ee-1797-3a11-7f3f560553e6@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c04458ed-29ee-1797-3a11-7f3f560553e6@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 02:16:11PM +0300, Grygorii Strashko wrote:
> 
> On 21/04/2020 00:42, Arnd Bergmann wrote:
> >
> > On Mon, Apr 20, 2020 at 11:34 PM Richard Cochran
> > >
> > > To be clear, do you all see a need to change the stubbed version of
> > > ptp_clock_register() or not?
> > 
> > No, if the NULL return is only meant to mean "nothing wrong, keep going
> > wihtout an object", that's fine with me. It does occasionally confuse driver
> > writers (as seen here), so it's not a great interface, but there is no general
> > solution to make it better.

That's why in my first patch I condition the WARN_ON() on PTP_1588_CLOCK,
since without that the null pointer here is not an error:

	void cpts_unregister(struct cpts *cpts)                                         
	{                                                                               
		if (WARN_ON(!cpts->clock))                                              
			return;                                                         

Grygorii's question (paraphrasing: "why would you ever do that?")
prompted my second patch, making the broken configuration obvious by
emitting an error during `ifup`, instead of just a warning during
`ifdown`.

But I think Grygorii is on to something here:

> Another question is that CPTS completely nonfunctional in this case and
> it was never expected that somebody will even try to use/run such
> configuration (except for random build purposes).

So, let's not allow it. In my view, commit d1cbfd771ce8 ("ptp_clock:
Allow for it to be optional") went a bit too far, and converted even
clearly PTP-specific modules from `select` to `imply` PTP_1588_CLOCK,
which is what made this broken configuration possible. I suggest
reverting that change, just for the PTP-specific modules under
drivers/net/ethernet.

I audited all drivers that call `ptp_clock_register()`; it looks like
these should `select` (instead of merely `imply`) PTP_1588_CLOCK:

    NET_DSA_MV88E6XXX_PTP
    NET_DSA_SJA1105_PTP
    MACB_USE_HWSTAMP
    CAVIUM_PTP
    TI_CPTS_MOD
    PTP_1588_CLOCK_IXP46X

Note how they all reference PTP or timestamping in their name, which is
a clue that they depend on PTP_1588_CLOCK.

I have a patch for this, but first, a procedural question: does mailing
list etiquette dictate that I reply to this thread with the new patch,
or does it begin a new thread?

-- 
Clay

