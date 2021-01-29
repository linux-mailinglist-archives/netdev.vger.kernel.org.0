Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A2730904E
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 23:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhA2WuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 17:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhA2WuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 17:50:12 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005E8C061573;
        Fri, 29 Jan 2021 14:49:31 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id p15so10343710wrq.8;
        Fri, 29 Jan 2021 14:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TxZTwmVBAszHY/FHghqTuPm0fq1rfUoUoo9mfv7kFa0=;
        b=JS4l6+XUjBn7f++gbnmdJeDvQOOESkXDRBrSIb8uKYVNRjNepBbmQ3AC6KpzgahepK
         BUa+/ZoUqbdkZbV/ETIpMmbemzBEVZrzOKQ30+psTmbsg5xDdFDPrnQqCpNcz/G77U48
         tN9Qde/4CCJOkstQ4ueLnJXreR8cMm6XRxteNoQ8deFPR8m9zBVYgumNIPxpGmgn7EVf
         r55WFNFJm9CuLeT9A1W9bbMcyh3xzbQPTUXdLs0R220q7xXhXppLkEOCPWAvw3QWwIqE
         XYQdj76WuIVtiopFlZKSsOEDJG4th1weMoStNxsOlDdbM62NjoMBaqqkNPLsG0Lny8ER
         sxGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TxZTwmVBAszHY/FHghqTuPm0fq1rfUoUoo9mfv7kFa0=;
        b=J6I22yGBwSBl6nwKWNfnBh1vgUPek5Y5LMwWTTVR/Qbfj+Cu0EsCH+vg8KH1wBDfUC
         ERhoHZRBkLIEoaa75oS1Y71/7x8mo2kiTK2zKiVZYv4xCsPhQ0mgpWQa6/lDqWI0iRjk
         06gOiB7ui72jQc8GDMti2f645+ehnssvfEo4nXb6hzH2ySD4g950AAdE/XxejAELoTaP
         uy5TTAfTs7ZLWXU2u1tQtcbTy2c93bqiHZtnNB2d2Gsreu7m8UHbV3tP7SNSLkRrmFmd
         svo4R/Dn1I+MgVJDt61v7LxU5hx+3mySL2v9TV27OMzHWm+oyVGHsIkjLWz8oM0hrnne
         4lUQ==
X-Gm-Message-State: AOAM5303Y4pnHVllgf4IAeIbzCJThC0p24hp3AJF6F+4YwDhpy1P/C4Y
        Su2Ut54UImPMY3cS7d5InTy4IcJu07e1KEoyZbQ=
X-Google-Smtp-Source: ABdhPJz9Qzpzrwu8SMXaGnnVpDAw/l3dN43ky2YraD6u+hkinfYQyZ5G9UGX8XqQp2i3pHN9yfz8o0cmpefAPjDw83w=
X-Received: by 2002:a5d:65ca:: with SMTP id e10mr6983337wrw.166.1611960570571;
 Fri, 29 Jan 2021 14:49:30 -0800 (PST)
MIME-Version: 1.0
References: <20210129195240.31871-1-TheSven73@gmail.com> <20210129195240.31871-2-TheSven73@gmail.com>
 <YBRxtM/tpmegczPD@lunn.ch>
In-Reply-To: <YBRxtM/tpmegczPD@lunn.ch>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Fri, 29 Jan 2021 17:49:19 -0500
Message-ID: <CAGngYiX6BBFPPwSaHeFqTQmERzbV-ZQHrHr_Zv4e=YCOZuc4Wg@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs
 w/o dma cache snooping
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew, thank you so much for looking at this patch !

On Fri, Jan 29, 2021 at 3:36 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> So this patch appears to contain two different changes
> 1) You only allocate a receive buffer as big as the MTU plus overheads
> 2) You change the cache operations to operate on the received length.
>
> The first change should be completely safe, and i guess, is giving
> most of the benefits. The second one is where interesting things might
> happen. So please split this patch into two.  If it does break, we can
> git bisect, and probably end up on the second patch.
>

Yes, I tested this extensively on arm7, but you're right, it might behave
differently on other platforms. I will split into two, as you suggested.
