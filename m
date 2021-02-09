Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47943315660
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 19:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbhBISzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhBISr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 13:47:57 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6A1C06178A
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 10:37:50 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id g84so6688635oib.0
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 10:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9itt6/frNZntvWjdFbnAUsm3g2b0fSUbFqtY4Y3pr5o=;
        b=TkostDsSDKAcBSyIGElukCaJXZ8JlcMcgmANpuJo/OWXJII2s7mK021HaFvWa7ZCJT
         5sNpzcBy9/oPrvaGWaY5AGrrgqul967a2jop120/1BbQoavlKh54KG34jo7iKAbmTmX4
         FlJNGie7RqTBK3PgyD0MfP1GcH9izi75LGKY1GlVez6rjngwGyVn5cqRpHPIe4ZqNzxi
         Vy9IeZEjh6X3fLrJ3qQgTGezeSXdKCaPu8yLwX9/ljucaecntOqKJjqO3ofW/GRb5Exf
         dYmO4eDC8TE7TwYjLYkAB3Leh1esFucFQgWdksCAHq1I4oEzU2YzuLcqciC/GTZO7MmG
         e3WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9itt6/frNZntvWjdFbnAUsm3g2b0fSUbFqtY4Y3pr5o=;
        b=nDYzVWuW0sjIeN890IQ2m/FKaBf3X3huu7gUitgirCmbAImXo7J8NupuuSu3p8085E
         VSiMdTmOgdDxLfaeiJuuIVZM28/y7ZGG18yeMiAXKWMeXnTfVfU/DmtLypIwOX89EzLi
         A+Cd65gTiWvZ7/KI1X8yZ7LnFFPautXLQFOufVet3bdoenZZGOioLawj+pUlF5QpMtgl
         vEdQrspYVw7EIbaYgmYSr5wCM58lexyahrq++lPGCfMolZssiK/SMeQ+Scu3S/rzEIOO
         fPUmnSRaq9N3V1rmTIftNA7Qm0rjVutxWZooxyQTtSgiwuVi15Puvd+6SkD9f0eItyWX
         Dlrw==
X-Gm-Message-State: AOAM533m1kpKtDawOCYmNRA6XCRe2DvdEg1jDto22SQnmN+SwaX8Qz/e
        V7JxkXN2LD/K4qQh/1K/oeoJblpHPuRyxLv8dg==
X-Google-Smtp-Source: ABdhPJzKhvWNoWTQVSMoAxq92lPwbYldKIt5/ZsxOAvxr3NiTFq+HuG5YXQizeAmIdkAOh6WR8+OIh3K3pX3cfOHtLo=
X-Received: by 2002:aca:e085:: with SMTP id x127mr3457717oig.127.1612895869999;
 Tue, 09 Feb 2021 10:37:49 -0800 (PST)
MIME-Version: 1.0
References: <20210204215926.64377-1-george.mccollister@gmail.com>
 <20210204215926.64377-4-george.mccollister@gmail.com> <20210206232931.pbdvtx3gyluw2s4u@skbuf>
 <CAFSKS=MbXJ5VOL1aPWsNyxZfhOUh9XJ7taGMrNnNv5F2OQPJzA@mail.gmail.com> <20210209172024.qlpomxk6siiz5tbr@skbuf>
In-Reply-To: <20210209172024.qlpomxk6siiz5tbr@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Tue, 9 Feb 2021 12:37:38 -0600
Message-ID: <CAFSKS=OZqpO8=XgZOf8AGFbqPjKu1FryR-1+Qefdt7ku9PSU0w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/4] net: dsa: add support for offloading HSR
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 11:20 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Mon, Feb 08, 2021 at 11:21:26AM -0600, George McCollister wrote:
> > > If you return zero, the software fallback is never going to kick in.
> >
> > For join and leave? How is this not a problem for the bridge and lag
> > functions? They work the same way don't they? I figured it would be
> > safe to follow what they were doing.
>
> I didn't say that the bridge and LAG offloading logic does the right
> thing, but it is on its way there...
>
> Those "XXX not offloaded" messages were tested with cases where the
> .port_lag_join callback _is_ present, but fails (due to things like
> incompatible xmit hashing policy). They were not tested with the case
> where the driver does not implement .port_lag_join at all.
>
> Doesn't mean you shouldn't do the right thing. I'll send some patches
> soon, hopefully, fixing that for LAG and the bridge, you can concentrate
> on HSR. For the non-offload scenario where the port is basically
> standalone, we also need to disable the other bridge functions such as
> address learning, otherwise it won't work properly, and that's where
> I've been focusing my attention lately. You can't offload the bridge in
> software, or a LAG, if you have address learning enabled. For HSR it's
> even more interesting, you need to have address learning disabled even
> when you offload the DANH/DANP.

Do I just return -EOPNOTSUPP instead of 0 in dsa_switch_hsr_join and
dsa_switch_hsr_leave?

I'm not sure exactly what you're saying needs to be done wrt to
address learning with HSR. The switch does address learning
internally. Are you saying the DSA address learning needs to be
disabled? If that's something I need for this patch some tips on what
to do would be appreciated because I'm a bit lost.

Thanks
