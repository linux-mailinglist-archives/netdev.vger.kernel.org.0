Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE39E1DAD80
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 10:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgETIcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 04:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETIcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 04:32:45 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCDFC061A0E;
        Wed, 20 May 2020 01:32:45 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s10so1117264pgm.0;
        Wed, 20 May 2020 01:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LdXCTub4Z9kDMOSy0ARQdskJN6lbu+XKJdQ8G1oxt2w=;
        b=ioWZhImdJDpldT4SXJ9FDSvyluvAVlamd6Z0TPO1ZCr3WXm+XVbBYF9lRlMTGfKiKP
         fwn6gWXg/dMeYxmVmC6VCbCS813r3sF8ENw447F9cDZN7o+4jwf/ATR4C4xfJlmDxPr6
         VvHSR5zXvxwrCQdrSC+eNGxlXV8KtMFitR4k98f+Y0AFsYmu9xI/EeJblOAhUJIrQ5ti
         HTZW/41UyGeg1taV1I3LZpMGDmng67TjVIn+9Hs+NVuh39gvBCX9vwCElmWiHsoRqEtd
         arPVZp8aD9G1ASHPX4AFLYDGOMNVtJ61wePi0FfgHxsfz80qD6WMxu2KD0EaSyqsNnzG
         iDww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LdXCTub4Z9kDMOSy0ARQdskJN6lbu+XKJdQ8G1oxt2w=;
        b=C3l8BkhOJdmvflCPcVPjjshjZCKson+EJG8NP7+WTBU7exZ5yOPh2OJHtRjjviSRT6
         s3TXMBJGcKzY798r0sxwCslebdjTpXaVQdVx1Y1QSHcIBKQIq+XC8z2+ookjvNrlXxZE
         yiDZfhaddE+jPu+UxL3G1I4ofDJ+x44uHMC7XYHuj6820TSiRGNexJDrGQbJo8OZWLwl
         boiUJmOll9o1vO3oPacxgplKyvJJixOsFYd14DTdtNy83rICsfqo+5k/UNFz2Rqg1x1t
         066HnRZ3HZkudM9mbCja/Uygrzat/SxCpojKio+U5w3BxkIilH9NGbpSLTf7N3nnsN2P
         GINg==
X-Gm-Message-State: AOAM530Wb8RToELmJqzR3FBKQR9ahXBX+MUO+a0h6H3+/g+UYGHisNJC
        WE9omyaJF/AkZN2wshbmrDfiFpN5xB0aFPKrh+M=
X-Google-Smtp-Source: ABdhPJxyc7lGecCf47GbjoOmrlktPAZ4hEbvxvpm/3E/o9ZhCs/tLKv3L7khmH+4TruBr0WdnFND/2t3RPZbLKPE2F0=
X-Received: by 2002:a65:6251:: with SMTP id q17mr3051810pgv.4.1589963564573;
 Wed, 20 May 2020 01:32:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200515212846.1347-1-mcgrof@kernel.org> <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
 <7306323c35e6f44d7c569e689b48f380f80da5e5.camel@sipsolutions.net>
 <CA+ASDXOg9oKeMJP1Mf42oCMMM3sVe0jniaWowbXVuaYZ=ZpDjQ@mail.gmail.com>
 <20200519140212.GT11244@42.do-not-panic.com> <CA+ASDXMUHOcvJ_7UWgyANMxSz15Ji7TcLDXVCtSPa+fOr=+FGA@mail.gmail.com>
 <CANUX_P1pnV46gOo0aL6QV0b+49ubB7C5nuUOuOfoT7aOM+ye9w@mail.gmail.com>
In-Reply-To: <CANUX_P1pnV46gOo0aL6QV0b+49ubB7C5nuUOuOfoT7aOM+ye9w@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 20 May 2020 11:32:32 +0300
Message-ID: <CAHp75VfOvABsQyxdy9j-On6pTunM1+uisoWQOmoNa7wLWJ+CSw@mail.gmail.com>
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
To:     Emmanuel Grumbach <egrumbach@gmail.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        aquini@redhat.com, "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Will Deacon <will@kernel.org>, Baoquan He <bhe@redhat.com>,
        ath10k@lists.infradead.org, Takashi Iwai <tiwai@suse.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Young <dyoung@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, gpiccoli@canonical.com,
        Steven Rostedt <rostedt@goodmis.org>, cai@lca.pw,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        schlad@suse.de, Linux Kernel <linux-kernel@vger.kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 8:40 AM Emmanuel Grumbach <egrumbach@gmail.com> wrote:

> Since I have been involved quite a bit in the firmware debugging
> features in iwlwifi, I think I can give a few insights here.
>
> But before this, we need to understand that there are several sources of issues:
> 1) the firmware may crash but the bus is still alive, you can still
> use the bus to get the crash data
> 2) the bus is dead, when that happens, the firmware might even be in a
> good condition, but since the bus is dead, you stop getting any
> information about the firmware, and then, at some point, you get to
> the conclusion that the firmware is dead. You can't get the crash data
> that resides on the other side of the bus (you may have gathered data
> in the DRAM directly, but that's a different thing), and you don't
> have much recovery to do besides re-starting the PCI enumeration.
>
> At Intel, we have seen both unfortunately. The bus issues are the ones
> that are trickier obviously. Trickier to detect (because you just get
> garbage from any request you issue on the bus), and trickier to
> handle. One can argue that the kernel should *not* handle those and
> let this in userspace hands. I guess it all depends on what component
> you ship to your customer and what you customer asks from you  :).

Or the two best approaches:
1) get rid of firmware completely;
2) make it OSS (like SOF).

I think any of these is a right thing to do in long-term perspective.

How many firmwares average computer has? 50? 100? Any of them is a
burden and PITA.

-- 
With Best Regards,
Andy Shevchenko
