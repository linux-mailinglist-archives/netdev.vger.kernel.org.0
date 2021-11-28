Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4938D460B46
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 00:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359653AbhK1Xuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 18:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234736AbhK1Xso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 18:48:44 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF88BC061574
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 15:45:27 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id w23so30319399uao.5
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 15:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ByoCJwEWRvtjWnGVx0vM6wsW0kQb7NDofw9PQFqlPEI=;
        b=h40l2Srp5YizcbUFW24rxIrmoi/yJiSO2oioZqdwATElL7hw7N0ZFCMr/pr2zXcz8f
         z5ByRn5oHSL2zo0o/Y+GfvY9ehXk+sndXlvfeu3O1KRRzF6o6xCvVrr7pqfpi9njfi/q
         ltNGyMRKjuk8ZudSvhWQ325YljsOLPNP/crMmHgDHQwY6BFj8VQ6b9aaBXAA97ea7Uot
         wDX3GaXHpaI51cAPGVrBMfo8yqoWgnwIKuIal2K57oCVEWP218oJwmBMv8Tl6iIEr8GJ
         AHtEgbKfzdwavAEAid5rKJZFcHNDoeaMC2toa9YPJafbqDUOqBy2fq83ClNReWbMzo3h
         fEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ByoCJwEWRvtjWnGVx0vM6wsW0kQb7NDofw9PQFqlPEI=;
        b=SGNcMkBw/DN9YaKv53XFjjTz2sCRrB93V5J0cgO4XesxO3yXM1xzJEo0XZt3y4e2lB
         Myi+Uq9ZSrfQiWbNT/IRSzZNcw5arfaw82djPvoeWvCJN05kUWDt0BVxL3M6N6uoXuST
         Nl0UkZr727ZWj0tIAhjn6Qzk18OjxRuv/15qBDsU3WW7t+RuwQcPlu5pdQGvftCzUOh3
         uZEd/YdntQG4+I0Gtck/HBBgKZNN4ps8jp00rWkpMH0txRxxbKFIjxWS1Y0qfzcRbsOx
         i910gonwAynP6s5SflXSju3LTjpbKiWdza/Lf2im/DP/OPbnCr9Z8bcYCqJOCcJcalq8
         TY6g==
X-Gm-Message-State: AOAM531sLrRUyhbgik9bc+0huumQAsrFUDTTH8/MqQxi9iK8VnUypcA/
        9eNynGBI4UIdWy+pMePZk4iQNMFqNshMZzlXMERfB0rm+I8gWQ==
X-Google-Smtp-Source: ABdhPJw8Qnp7bgui3o163NjOb4ojk6wehA98X2Lt+0G4jmYtz+iJcd61DPp+dHeGf5hn3ilSo+/XJdhC5osTdHg5l7Y=
X-Received: by 2002:ab0:35cd:: with SMTP id x13mr47071293uat.46.1638143127057;
 Sun, 28 Nov 2021 15:45:27 -0800 (PST)
MIME-Version: 1.0
References: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
 <20211128125522.23357-6-ryazanov.s.a@gmail.com> <ac532d400cd61a0f86ad5b1931df87a83582323c.camel@sipsolutions.net>
In-Reply-To: <ac532d400cd61a0f86ad5b1931df87a83582323c.camel@sipsolutions.net>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 29 Nov 2021 02:45:16 +0300
Message-ID: <CAHNKnsSgc0bEwJbS01f26JRLpnzky9mcSJ6sWy2vFDuNOHz-Xw@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next 5/5] net: wwan: core: make debugfs optional
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Leon to CC to merge both conversations.

On Sun, Nov 28, 2021 at 8:01 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2021-11-28 at 15:55 +0300, Sergey Ryazanov wrote:
>>
>> +config WWAN_DEBUGFS
>> +     bool "WWAN subsystem common debugfs interface"
>> +     depends on DEBUG_FS
>> +     help
>> +       Enables common debugfs infrastructure for WWAN devices.
>> +
>> +       If unsure, say N.
>>
>
> I wonder if that really should even say "If unsure, say N." because
> really, once you have DEBUG_FS enabled, you can expect things to show up
> there?
>
> And I'd probably even argue that it should be
>
>         bool "..." if EXPERT
>         default y
>         depends on DEBUG_FS
>
> so most people aren't even bothered by the question?
>
>
>>  config WWAN_HWSIM
>>       tristate "Simulated WWAN device"
>>       help
>> @@ -83,6 +91,7 @@ config IOSM
>>  config IOSM_DEBUGFS
>>       bool "IOSM Debugfs support"
>>       depends on IOSM && DEBUG_FS
>> +     select WWAN_DEBUGFS
>>
> I guess it's kind of a philosophical question, but perhaps it would make
> more sense for that to be "depends on" (and then you can remove &&
> DEBUG_FS"), since that way it becomes trivial to disable all of WWAN
> debugfs and not have to worry about individual driver settings?
>
>
> And after that change, I'd probably just make this one "def_bool y"
> instead of asking the user.

When I was preparing this series, my primary considered use case was
embedded firmwares. For example, in OpenWrt, you can not completely
disable debugfs, as a lot of wireless stuff can only be configured and
monitored with the debugfs knobs. At the same time, reducing the size
of a kernel and modules is an essential task in the world of embedded
software. Disabling the WWAN and IOSM debugfs interfaces allows us to
save 50K (x86-64 build) of space for module storage. Not much, but
already considerable when you only have 16MB of storage.

I personally like Johannes' suggestion to enable these symbols by
default to avoid bothering PC users with such negligible things for
them. One thing that makes me doubtful is whether we should hide the
debugfs disabling option under the EXPERT. Or it would be an EXPERT
option misuse, since the debugfs knobs existence themself does not
affect regular WWAN device use.

Leon, would it be Ok with you to add these options to the kernel
configuration and enable them by default?

-- 
Sergey
