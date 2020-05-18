Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5701D7F33
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgERQv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:51:59 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37577 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERQv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 12:51:58 -0400
Received: by mail-pl1-f195.google.com with SMTP id x10so4458592plr.4;
        Mon, 18 May 2020 09:51:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Yd4VQPjSfVqPw2JwHOBUH7DvL28anQpLQnF2oRmOvUg=;
        b=feXYZoGFDxp9/wWW8Vi0TYmI7PE+WdjwOmfK0ZI1tgeUmyEi4RDx4jLuhhTiDszGlJ
         2jf1N+T27ejV94FPrKkU9yR/YBYsuZMsG4Aa3U3SRiGBP9x7ABbr5DDLOYsfBVCWz+xZ
         7P6O2u2WkXLxuVpnbD3+pxC8TxGVMQbHE2C2FMG35UiXLhqNtmXdX8vxdHqsycvyz1M6
         UBb7NFAVqsJORDo7LqK2Tmsdeui+Mie8U4ilhVscT+TPujSW7VBWQkt/2W8kHX6I9RcL
         p6sDL1cqhTKLBhdHiWQGb3vH0bYotLHQGccVHdfCds8UFmorjNISDQQwWzfhVoI9hhH8
         vXig==
X-Gm-Message-State: AOAM5306/If0lzHkt2A40miQ5/TzjXtiG54DGXKX83i90xGcgB70UvjE
        PF454uHx9VlY+Zq+FIpzHwY=
X-Google-Smtp-Source: ABdhPJxLH5VDUbuE1FDuR86WOwRMaXJWESAIbwJvrLBEYETZmBwxGlYnKUYGXtOmogknCzCtXf7ShQ==
X-Received: by 2002:a17:90a:ad49:: with SMTP id w9mr365592pjv.20.1589820717327;
        Mon, 18 May 2020 09:51:57 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id v27sm3350582pfi.61.2020.05.18.09.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 09:51:56 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 17421404B0; Mon, 18 May 2020 16:51:55 +0000 (UTC)
Date:   Mon, 18 May 2020 16:51:54 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     jeyu@kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        rostedt@goodmis.org, mingo@redhat.com, aquini@redhat.com,
        cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, tiwai@suse.de, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
Message-ID: <20200518165154.GH11244@42.do-not-panic.com>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 03:24:01PM +0200, Johannes Berg wrote:
> On Fri, 2020-05-15 at 21:28 +0000, Luis Chamberlain wrote:> module_firmware_crashed
> 
> You didn't CC me or the wireless list on the rest of the patches, so I'm
> replying to a random one, but ...
> 
> What is the point here?
> 
> This should in no way affect the integrity of the system/kernel, for
> most devices anyway.

Keyword you used here is "most device". And in the worst case, *who*
knows what other odd things may happen afterwards.

> So what if ath10k's firmware crashes? If there's a driver bug it will
> not handle it right (and probably crash, WARN_ON, or something else),
> but if the driver is working right then that will not affect the kernel
> at all.

Sometimes the device can go into a state which requires driver removal
and addition to get things back up.

> So maybe I can understand that maybe you want an easy way to discover -
> per device - that the firmware crashed, but that still doesn't warrant a
> complete kernel taint.

That is one reason, another is that a taint helps support cases *fast*
easily detect if the issue was a firmware crash, instead of scraping
logs for driver specific ways to say the firmware has crashed.

> Instead of the kernel taint, IMHO you should provide an annotation in
> sysfs (or somewhere else) for the *struct device* that had its firmware
> crash.

It would seem the way some folks are thinking about getting more details
would be through devlink.

> Or maybe, if it's too complex to walk the entire hierarchy
> checking for that, have a uevent,  or add the ability for the kernel to
> print out elsewhere in debugfs the list of devices that crashed at some
> point... All of that is fine, but a kernel taint?

debugfs is optional, a taint is simple, and device agnostic. From a
support perspective it is very easy to see if a possible issue may
be device firmware specific.

  Luis
