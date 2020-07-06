Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66695215E45
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbgGFSYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729550AbgGFSY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:24:29 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38306C061755;
        Mon,  6 Jul 2020 11:24:29 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id g139so23170271lfd.10;
        Mon, 06 Jul 2020 11:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=GNvkm4qlrLyrpc6mI9W5mMAuFTgjd7/fxQQLIFTdU1Q=;
        b=LmNYZkDihijVpiZmPMzxg4oPZTvQuA6M3Hv9gZ/sfxfAviJdLcw13lQROOw7ow95G9
         Bh6BZbKmgiJOdiuAsZWjpoaJxsOeO2amF/10Xr8LEpTdk0HCD3buzPNk/Z0rP/NKNQz0
         P1wEqwX/IMknr3lITY4yH9/FAPXFQQHTkiJ2z9nVh/uuFenzoUIFY6mNjyFC2sI5OvzZ
         toJ1VsFm3ycCv10GW7T3a1hufgv47AoS5LjacMH5feScB+A3rZGvzneg16tZiGtsBHSR
         35hIz7z7c+MFmtHtAduUz5BccwB8Osg65k4oDjGMLL7KGnaMydSqvuE126l+MNDU30tW
         z6Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=GNvkm4qlrLyrpc6mI9W5mMAuFTgjd7/fxQQLIFTdU1Q=;
        b=T/nHUszzQl3En1gsbDM7ZWqFiRuoO/5C6yj/kAe/1TDGzfD04GHXZMc5rH4MujzoYE
         FsfaOvHyLM7l8A2SbsKgVK41QXanuQa1K0Uoqv6fpAsYgFb56d0EOWaNQ2MdxlJ/KC+u
         3UtRNQm19LdATyC4tg9SMtPRL/ulMmTGI2naQ0MPTOY8SpEL+mjZz70sjdwDySc52RAz
         fwKMFZiHPDY3FgmHn0VTzUogY+zYaav8YtUX/egWT26EPbsqtdbKoyMt//WUr/SsA7Zk
         nagZF2TSiGkFHXTtzWBVk8dH3pbILk/m7nfux8HYWpAYqnNeFKHq1zIXOvrthYU4CNnh
         V9Ug==
X-Gm-Message-State: AOAM530HVhLAJavCknyl89/f9TViNaoX3Aoa60gUiMH9I5125+Ok3dUF
        LhmJbL9grV3l2H6U2prowuw=
X-Google-Smtp-Source: ABdhPJwpuyZX2j0nAIjSro1X6784HLmhor2st7ncGY53Y0bOMOhNkJqj4+D5xoFfW/BGD4+BDHjzcA==
X-Received: by 2002:ac2:47e7:: with SMTP id b7mr30423731lfp.68.1594059867015;
        Mon, 06 Jul 2020 11:24:27 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id j26sm9023140lfm.11.2020.07.06.11.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 11:24:25 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200706142616.25192-4-sorganov@gmail.com>
        <20200706152721.3j54m73bm673zlnj@skbuf>
Date:   Mon, 06 Jul 2020 21:24:24 +0300
In-Reply-To: <20200706152721.3j54m73bm673zlnj@skbuf> (Vladimir Oltean's
        message of "Mon, 6 Jul 2020 18:27:21 +0300")
Message-ID: <874kqksdrb.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> Hi Sergey,
>
> On Mon, Jul 06, 2020 at 05:26:14PM +0300, Sergey Organov wrote:
>> Initializing with 0 makes it much easier to identify time stamps from
>> otherwise uninitialized clock.
>> 
>> Initialization of PTP clock with current kernel time makes little sense as
>> PTP time scale differs from UTC time scale that kernel time represents.
>> It only leads to confusion when no actual PTP initialization happens, as
>> these time scales differ in a small integer number of seconds (37 at the
>> time of writing.)
>> 
>> Signed-off-by: Sergey Organov <sorganov@gmail.com>
>> ---
>
> Reading your patch, I got reminded of my own attempt of making an
> identical change to the ptp_qoriq driver:
>
> https://www.spinics.net/lists/netdev/msg601625.html
>
> Could we have some sort of kernel-wide convention, I wonder (even though
> it might be too late for that)? After your patch, I can see equal
> amounts of confusion of users expecting some boot-time output of
> $(phc_ctl /dev/ptp0 get) as it used to be, and now getting something
> else.
>
> There's no correct answer, I'm afraid.

IMHO, the correct answer would be keep non-initialized clock at 0. No
ticking.

> Whatever the default value of the clock may be, it's bound to be
> confusing for some reason, _if_ the reason why you're investigating it
> in the first place is a driver bug. Also, I don't really see how your
> change to use Jan 1st 1970 makes it any less confusing.

When I print the clocks in application, I see seconds and milliseconds
part since epoch. With this patch seconds count from 0, that simply
match uptime. Easy to tell from any other (malfunctioning) clock.

Here is the description of confusion and improvement. I spent half a day
not realizing that I sometimes get timestamps from the wrong PTP clock.
Part of the problem is that kernel time at startup, when it is used for
initialization of the PTP clock, is in fact somewhat random, and it
could be off by a few seconds. Now, when in application I get time stamp
that is almost right, and then another one that is, say, 9 seconds off,
what should I think? Right, that I drive PTP clock wrongly.

Now, when one of those timestamps is almost 0, I see immediately I got
time from wrong PTP clock, rather than wrong time from correct PTP
clock.

Thanks,
-- Sergey
