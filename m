Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207272A15B
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404386AbfEXWjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:39:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34272 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbfEXWjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:39:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id e19so2862126wme.1
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 15:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fyZi6v0mcgKSC16RURy0qopnByCgnXY1K2U9goxfA1Q=;
        b=JNQS/PTGqlUgYcpzMAYHuZqlDvD2sNfGPlDoRvlyNpPQfxbTZutYHgHCSjsSJCCw05
         5YmVB59KP6XFcHrAKqxOqRTk6Hr9wRl/t3WLBPgNtb3FGdbcbWTLcHAG8wVVbZqX5ja4
         9e08U9URC16u5tUAjjOWPTrjp9emoLdkHQ0gikVaBB/CDY/xofJWr5/JmNvBDV7cHUTw
         XcxwQUgNMMwd8fo0Eas9iV1pSTWD3TghtD0rDuSCLTb3c3Fn4yeh1DBbBaVGUgyKG3tK
         opPLbHpuRD8/V0Rlas0cihCTst7HIoJ/xDApIijjD/5PGhOoh/stcZc5gpOkc5HLQSYP
         wI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fyZi6v0mcgKSC16RURy0qopnByCgnXY1K2U9goxfA1Q=;
        b=D1plcMFugeXv8vGZPRYqGaH3XeEiJXjtU9YCvJr9iRrhBs8l2A9g25HDFu7KnTkN31
         ndDZNbozKP5ZSavlOpIWTTBvfgCsqfwjbIDGZmB942L2ScJKz3PfYHgw0a+gCVng/Bzg
         iiqzshIlaYV+gErTkCmoGehqQFyyYdvuoT8s4ihklcwdeAbix6qFAJ/GVIyLMlJjlLIB
         1QOGCK0SoSrdXh00AEnH2exBetUB2IQyrBi4AimSem4QINkcg/EHMoJ6gGtGbZSI52lC
         ke034Py3Wcp4DCp1nuIhEhp3ynxrsIQp/brjEIg+g/rB3bf/DE5Vg7XyQt6K75T8Fiq7
         vOWA==
X-Gm-Message-State: APjAAAWlIj3jmiil7oVcbne6XR6Z7/BXjcF2BsItk7B2oLnKFC8StUVl
        djtk51G9Yr3fquGZwZfMgWRZMe9YxsTSKQKvEqDgmQ==
X-Google-Smtp-Source: APXvYqxW2n5H9vt7mX4JNr8xeJxdoAikSxRfwl4bvPXYtUPI7AS/sOyLcEt10h951ycbvpy5lE6/mmoD6w3q9rCJBPA=
X-Received: by 2002:a1c:2e0a:: with SMTP id u10mr63993wmu.92.1558737537847;
 Fri, 24 May 2019 15:38:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190524134928.16834-1-jarod@redhat.com> <30882.1558732616@famine>
In-Reply-To: <30882.1558732616@famine>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Fri, 24 May 2019 15:38:46 -0700
Message-ID: <CAF2d9jhGmsaOZsDWNFihsD4EuEVq9s0xwY22d+FuhBz=A2JpKA@mail.gmail.com>
Subject: Re: [PATCH net] bonding/802.3ad: fix slave link initialization
 transition states
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Heesoon Kim <Heesoon.Kim@stratus.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 2:17 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Jarod Wilson <jarod@redhat.com> wrote:
>
> >Once in a while, with just the right timing, 802.3ad slaves will fail to
> >properly initialize, winding up in a weird state, with a partner system
> >mac address of 00:00:00:00:00:00. This started happening after a fix to
> >properly track link_failure_count tracking, where an 802.3ad slave that
> >reported itself as link up in the miimon code, but wasn't able to get a
> >valid speed/duplex, started getting set to BOND_LINK_FAIL instead of
> >BOND_LINK_DOWN. That was the proper thing to do for the general "my link
> >went down" case, but has created a link initialization race that can put
> >the interface in this odd state.
>
Are there any notification consequences because of this change?

>        Reading back in the git history, the ultimate cause of this
> "weird state" appears to be devices that assert NETDEV_UP prior to
> actually being able to supply sane speed/duplex values, correct?
>
>         Presuming that this is the case, I don't see that there's much
> else to be done here, and so:
>
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>
> >The simple fix is to instead set the slave link to BOND_LINK_DOWN again,
> >if the link has never been up (last_link_up == 0), so the link state
> >doesn't bounce from BOND_LINK_DOWN to BOND_LINK_FAIL -- it hasn't failed
> >in this case, it simply hasn't been up yet, and this prevents the
> >unnecessary state change from DOWN to FAIL and getting stuck in an init
> >failure w/o a partner mac.
> >
> >Fixes: ea53abfab960 ("bonding/802.3ad: fix link_failure_count tracking")
> >CC: Jay Vosburgh <j.vosburgh@gmail.com>
> >CC: Veaceslav Falico <vfalico@gmail.com>
> >CC: Andy Gospodarek <andy@greyhouse.net>
> >CC: "David S. Miller" <davem@davemloft.net>
> >CC: netdev@vger.kernel.org
> >Tested-by: Heesoon Kim <Heesoon.Kim@stratus.com>
> >Signed-off-by: Jarod Wilson <jarod@redhat.com>
>
>
>
> >---
> > drivers/net/bonding/bond_main.c | 15 ++++++++++-----
> > 1 file changed, 10 insertions(+), 5 deletions(-)
> >
> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >index 062fa7e3af4c..407f4095a37a 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -3122,13 +3122,18 @@ static int bond_slave_netdev_event(unsigned long event,
> >       case NETDEV_CHANGE:
> >               /* For 802.3ad mode only:
> >                * Getting invalid Speed/Duplex values here will put slave
> >-               * in weird state. So mark it as link-fail for the time
> >-               * being and let link-monitoring (miimon) set it right when
> >-               * correct speeds/duplex are available.
> >+               * in weird state. Mark it as link-fail if the link was
> >+               * previously up or link-down if it hasn't yet come up, and
> >+               * let link-monitoring (miimon) set it right when correct
> >+               * speeds/duplex are available.
> >                */
> >               if (bond_update_speed_duplex(slave) &&
> >-                  BOND_MODE(bond) == BOND_MODE_8023AD)
> >-                      slave->link = BOND_LINK_FAIL;
> >+                  BOND_MODE(bond) == BOND_MODE_8023AD) {
> >+                      if (slave->last_link_up)
> >+                              slave->link = BOND_LINK_FAIL;
> >+                      else
> >+                              slave->link = BOND_LINK_DOWN;
> >+              }
> >
> >               if (BOND_MODE(bond) == BOND_MODE_8023AD)
> >                       bond_3ad_adapter_speed_duplex_changed(slave);
> >--
> >2.20.1
> >
