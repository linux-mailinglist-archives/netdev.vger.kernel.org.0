Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601DE3C682D
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 03:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhGMBnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 21:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhGMBnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 21:43:40 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072CFC0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 18:40:51 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id x70so16065339oif.11
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 18:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sJP2rY9j1Mr/s/MEXqniN3G9ScPpYODzDlYRXJMwRW4=;
        b=kxel0Rqb+4BgXrnCDOyEKkttmFljcHtnY5x/x185fXRvhxHihgA8rmQ4XHxZY0k6gS
         txTrayt9ZPwoCrbAdNkbERYsHahBdCYqDu/rGaaOL0kIeMFKbd+2A72O3JiVBTstH9nT
         2/vVJUDM4s73MpRpsLeVFr83IzK52P3St84Kc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sJP2rY9j1Mr/s/MEXqniN3G9ScPpYODzDlYRXJMwRW4=;
        b=NO3J3OPDwwXTyY39BHf7OecHrnQVhzX9y94IxbbmNa7QWH613bJ6pmzJrk0anvm2F3
         kSphhsH8BxiXE6PwLcWPBCqfUu8djLWVkA+nW/V7InelUC5ZZMarwV5i/C9gkFhz+Goc
         SugRtRzahP2R6/wRFlgQXeM/XSV/XkeY0xptjMNmkdpeiGLkMLuS0mBogY7x2dbX3x0t
         N1zwE+jznce2DMpO1lnr2WV/0/nj+G+czuznOhicYk2a0Kr40MZOxusr8m9XGibHbzo+
         B91eoxKwXHEMkYU4JsV5zFG5wesrDtqcSqVvtunD6hgPb42+0TWWot+rxIUG8SLFApT0
         ilJw==
X-Gm-Message-State: AOAM533LpBlN0nG/V3XZLhHMGL9WTJUICTJYf8DDwxu/X1QKMzRE3hGP
        ewYDDT7nT85346xLnSDGo8jxXI1ci2M0UA==
X-Google-Smtp-Source: ABdhPJyxy8aCCf7o8pnli9Jo7qVwILvkwAcjYDdzKkCwNh+Q+SOPpEb2IL6qSC45klgU3OMx0zSM/A==
X-Received: by 2002:a05:6808:112:: with SMTP id b18mr4855824oie.77.1626140449666;
        Mon, 12 Jul 2021 18:40:49 -0700 (PDT)
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com. [209.85.167.180])
        by smtp.gmail.com with ESMTPSA id s29sm2010383oiw.54.2021.07.12.18.40.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 18:40:48 -0700 (PDT)
Received: by mail-oi1-f180.google.com with SMTP id t25so8039917oiw.13
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 18:40:48 -0700 (PDT)
X-Received: by 2002:aca:fcc3:: with SMTP id a186mr4176866oii.105.1626140448227;
 Mon, 12 Jul 2021 18:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210618064625.14131-1-pkshih@realtek.com> <20210618064625.14131-5-pkshih@realtek.com>
 <20210702072308.GA4184@pengutronix.de> <CA+ASDXNjHJoXgRAM4E7TcLuz9zBmQkaBMuhK2DEVy3dnE-3XcA@mail.gmail.com>
 <20210702175740.5cdhmfp4ldiv6tn7@pengutronix.de> <CA+ASDXP0_Y1x_1OixJFWDCeZX3txV+xbwXcXfTbw1ZiGjSFiCQ@mail.gmail.com>
 <20210702193253.sjj75qp7kainvxza@pengutronix.de> <CA+ASDXP8JU+VXQV1ZHLsV88y_Ejr4YbS3YwDmWiKjhYsQ-F2Yw@mail.gmail.com>
 <20210703041548.nhe6iedtrkwihefo@pengutronix.de>
In-Reply-To: <20210703041548.nhe6iedtrkwihefo@pengutronix.de>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 12 Jul 2021 18:40:36 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOFTirEBTiXDjipZ2mfdmpu88pUR+4ri4TV2_=q_V+B0g@mail.gmail.com>
Message-ID: <CA+ASDXOFTirEBTiXDjipZ2mfdmpu88pUR+4ri4TV2_=q_V+B0g@mail.gmail.com>
Subject: Re: [PATCH 04/24] rtw89: add debug files
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 2, 2021 at 9:15 PM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> For example drivers/net/wireless/realtek/rtw89/debug.c is 2404 of potentially
> removable code. Some one should review it or outoptimize it by using
> existing frameworks.

Only ~28 of those lines are for the debug logging you point out.
(There's a few more in the .h file, but still.) Most of that is
unrelated code for dumping other debug info about the Realtek
chip/firmware/driver state, or performing other debugging operations.

> As you noticed, not many people are willing to review this driver. IMO,
> it is related to the RealTek reputation of making code drops with lots
> of not not usable or duplicated code. So to say - offloading the dirty work to
> the community. For example this patch set:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/drivers/staging/rts5139?h=v5.13&qt=author&q=rempel

FWIW, that driver was introduced into mainline (staging) by somebody @
Realsil, not Realtek:

https://git.kernel.org/linus/1dac4186bcc663cb8c2bcc59481aea8fe9124a6c

Sure, Realtek previously developed plenty of copy/paste/modify Linux
drivers, and it's likely most of that code was based off their
downstream drivers (which suffered from duplication), but they rarely
(never?) tried to get them merged upstream. Can you really blame them
for having non-upstream-friendly code in their
not-intended-for-upstream drivers? Now they've been nudged into doing
the upstream work themselves (*cough* *cough*) with rtw88 and now
rtw89, and IMO, they aren't suffering nearly of the same kinds of
duplication problems you note. But agreed, the reputational problems
might still be lingering.

If we're opining on lack of review: I haven't watched so many other
wireless drivers' review and inclusion in mainline (I tend to bother
with them once they're already mostly upstream, and I mostly just need
to fix bugs), but my impression is that the biggest impediment is
Kalle's limited resources. Most other successful drivers have
dedicated submaintainers who do the review or else append their name
on submissions and do pull requests, whether or not they got much
mailing list review. Everyone else who isn't so lucky has to wait in
line for Kalle, often for quite some time. This is getting a bit off
topic though.

> This new rtw89 driver seems to confirm this reputation, but I cani't say it
> for sure without spending a week on reverse engineering it.

FWIW, I've looked through it lightly (and I looked through rtw88 quite
a bit), and I don't see much (or any, really) of those same kinds of
problems. It's not perfect code of course, but I don't think
duplication is the biggest sort of problem.

Anyway, thanks for reviewing, and thanks for any issues you do point out!

Brian
