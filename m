Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C562428B5
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 13:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgHLLdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 07:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbgHLLdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 07:33:04 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEC0C06174A;
        Wed, 12 Aug 2020 04:33:03 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id r21so1610951ota.10;
        Wed, 12 Aug 2020 04:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Em9Sp8XmzIpv/p2/XIEVSGX1+QelGDXMy8mBEoKzQGA=;
        b=svUM0PtlSc/BsJ398hEypGo/dtDceKxpkxJL2XapJiufbso1e8LfFI4bXYobnoySJa
         SRjvv9f/48b5GJPA7fHwECXPGN7eO/ub5qQngsk3EUO83vMzAXxkqcbbp5j1xemvZIq9
         s5mftpWisvt6SbOmNG3lr1AFiu06MFhrdLN47I42cpfWHFnGFPC0kmoM7pnxUZpSyLQj
         +N4Js6sN6aumylIuGGMt2QsXP+hkf1Ol4GBV8Uuo8S00kvpt2DD1ugHsd9sXoZ13vg/2
         3wLqiAgbMsq3tbjK6M6brM8AX2Uig0dYIzJF4KNHkRmKijkDxBWgQ34F0o2mtUai8o4g
         hCHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Em9Sp8XmzIpv/p2/XIEVSGX1+QelGDXMy8mBEoKzQGA=;
        b=uU9fnuYM3xvqv6N6V5WwapZ5O7kRbjc4Hp+lGA3cRh01/bXAsVrKF7RHOw8CWuhkXd
         a/D9YSmqqJBB63Hl3teNWjlDOYF4Hl19mIBKh4r7klyT0Gbk/aowKc2uAcLdKLf8DFb9
         jJkSoPon5cpwccJhHKkN3DAcaJvrSVrulqQoCTSsTzHZKVWZT9iwXG30e5Mel7ckoKHT
         EzzxYM+3SoXsMdj1yYYw3Hxq6RWQfiaGm0hfJWUT1GOjwLVjZd8N8rSo5UmwIwDo/a62
         StrdjAoUZ3BKDj/awLrkAB25cgyFpMgb/ggNsAV3KH91ZpcbcxuUDvOO7rUoDcXKSe+1
         LIew==
X-Gm-Message-State: AOAM531/OOF2cNjWO1nugWBXLLtTUpZXelRLUvdAqk0K09lMuL3Q8+BW
        ZP/dSK+If+b4jKnaIQkRFNZC796z9ht4lTatyA4=
X-Google-Smtp-Source: ABdhPJyApW1cAsqfCZE8viTLCHhX3eA/ksSTGjILeL6+zxKJ5TOuIeeZt8iyPAiUApQEScansB5N2ki5ANp9kIXSCiU=
X-Received: by 2002:a9d:128c:: with SMTP id g12mr8585420otg.242.1597231982871;
 Wed, 12 Aug 2020 04:33:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200716030847.1564131-1-keescook@chromium.org>
 <87h7tpa3hg.fsf@nanos.tec.linutronix.de> <202007301113.45D24C9D@keescook>
 <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com>
 <202008111427.D00FCCF@keescook> <s5hpn7wz8o6.wl-tiwai@suse.de>
In-Reply-To: <s5hpn7wz8o6.wl-tiwai@suse.de>
From:   Allen <allen.lkml@gmail.com>
Date:   Wed, 12 Aug 2020 17:02:50 +0530
Message-ID: <CAOMdWS+FJm0NZfbj+yyShX2edX6_9w5K+rA+_u+Z6-rrjcwucg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Kees Cook <keescook@chromium.org>, devel@driverdev.osuosl.org,
        linux-s390@vger.kernel.org, alsa-devel@alsa-project.org,
        Oscar Carter <oscar.carter@gmx.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-input@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Thomas Gleixner <tglx@linutronix.de>,
        Romain Perier <romain.perier@gmail.com>,
        Will Deacon <will@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> I have a patch set to convert the remaining tasklet usage in sound
> drivers to either the threaded IRQ or the work, but it wasn't
> submitted / merged for 5.8 due to the obvious conflict with your API
> changes.
> Each conversion is rather simple, but it's always a question of the
> nature of each tasklet usage which alternative is the best fit.
>
> FWIW, the current version is found in test/kill-tasklet branch of
> sound git tree
>   git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git

Great. Currently my tree has these converted to use the new
tasklet_setup() api. I will add these to my threaded IRQ/work tree
(which is still wip).

Thanks.


-- 
       - Allen
