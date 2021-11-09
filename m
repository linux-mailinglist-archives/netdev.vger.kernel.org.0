Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F6544B2D7
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 19:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242635AbhKISvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 13:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242639AbhKISvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 13:51:53 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA20BC061764;
        Tue,  9 Nov 2021 10:49:06 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id f8so409141edy.4;
        Tue, 09 Nov 2021 10:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lmow5GkNL8rmuwuXfGzLROk1KvBCn7lg2Dy3ImDhk10=;
        b=DgAORoscuZ0uTA2FwtEIUUSdpeFFRTHDDTQa8+U3lm4kvgoK+xMBoVjJxivld4Twlv
         v+zZumC3rXSFyTF9aKlusOMEaby0gMAB7y0NuDc1dkJqTCzp1fLMzUxcrwibyI66NdOj
         FwaWBNx37/JeJeRZ2j2EAll9hItYc3Th5YpChuoSRj8fseyKgHs+byX4LmkC8BYGYiu5
         zZ7OZtHvOIaWB3rNJGuguMc1YlusPKrgeH4XpBRPPeeo5hS/8pMSkz+uM26I77jaxg8i
         u8ZhJ/GagOUrVLefJF606zsFPcloclpN1ToMZC06NP/gSpnUhRfH2bfftdSfg5xK4fX4
         S+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lmow5GkNL8rmuwuXfGzLROk1KvBCn7lg2Dy3ImDhk10=;
        b=wSqnsSZr4i9EMOnzPXskouEcBfUJKS8ftWnhOW60UPkHCJDKpT9oHomrbz+t2o2deV
         aF0MCXlNUGfBQj/qgNfz3pzQNBSXJ0YIvl5XGPR1aULn3UDS25eDUPcSozAE9486YbG4
         YGJlNToQdRHJipc9z5aPmpq/uH0lXiaMfxHHLo2YcvQieRQc/dOb5wCjRDlQ1jyhe1A8
         fbRb9f+6WYjXcevOs9JupeCOz6obZraXz3XXrU9LATYwiMnbD9jgBIsTqaSIrsAyIz1e
         g6Qd6SrsghAv2DrSTXjsSX5JlvgHnPUgimRgQNlZO+F11ktCB02tjw328/3A8cYpuftV
         9u1w==
X-Gm-Message-State: AOAM532T1bcie8IW94y39nDZ1wr3XYECJpXe8FFxPq03WBPSciKa3yLx
        7mtp/HWV/bc92OERF3T2DSo=
X-Google-Smtp-Source: ABdhPJxGX9O0aUKxjKHiwzcWe5JLdc+r40TrL+2RP/tT84C062tGbTS1J0/78LdZJ3snzFvV2Dr0mQ==
X-Received: by 2002:a17:906:82c5:: with SMTP id a5mr12532955ejy.127.1636483745332;
        Tue, 09 Nov 2021 10:49:05 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id gb2sm10260118ejc.52.2021.11.09.10.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 10:49:04 -0800 (PST)
Date:   Tue, 9 Nov 2021 20:49:03 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/7] net: dsa: b53: Move struct b53_device to
 include/linux/dsa/b53.h
Message-ID: <20211109184903.q6ijhjvcvhymf6nx@skbuf>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-3-martin.kaistra@linutronix.de>
 <f71396fc-29a3-4022-3f7a-3a37abb9079c@gmail.com>
 <caec2d40-6093-ff06-ab8e-379e7939a85c@gmail.com>
 <CA+h21hp+UKRgCE0UTZr7keyU380W22ZEXdbfORhSTNfzb1S_iw@mail.gmail.com>
 <b04b344e-2a17-eac2-bbcb-746091f9175a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b04b344e-2a17-eac2-bbcb-746091f9175a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 10:20:25AM -0800, Florian Fainelli wrote:
> On 11/9/21 10:15 AM, Vladimir Oltean wrote:
> > On Tue, 9 Nov 2021 at 20:11, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >>
> >> On 11/9/21 10:05 AM, Florian Fainelli wrote:
> >>> On 11/9/21 1:50 AM, Martin Kaistra wrote:
> >>>> In order to access the b53 structs from net/dsa/tag_brcm.c move the
> >>>> definitions from drivers/net/dsa/b53/b53_priv.h to the new file
> >>>> include/linux/dsa/b53.h.
> >>>>
> >>>> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
> >>>> ---
> >>>>  drivers/net/dsa/b53/b53_priv.h |  90 +----------------------------
> >>>>  include/linux/dsa/b53.h        | 100 +++++++++++++++++++++++++++++++++
> >>>>  2 files changed, 101 insertions(+), 89 deletions(-)
> >>>>  create mode 100644 include/linux/dsa/b53.h
> >>>
> >>> All you really access is the b53_port_hwtstamp structure within the
> >>> tagger, so please make it the only structure exposed to net/dsa/tag_brcm.c.
> >>
> >> You do access b53_dev in the TX part, still, I would like to find a more
> >> elegant solution to exposing everything here, can you create a
> >> b53_timecounter_cyc2time() function that is exported to modules but does
> >> not require exposing the b53_device to net/dsa/tag_brcm.c?
> >> --
> >> Florian
> > 
> > Switch drivers can't export symbols to tagging protocol drivers, remember?
> > https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/
> 
> I do now :) How about a function pointer in dsa_switch_ops that driver
> can hook onto?

IMHO, the honest answer to this is to admit that it's not quite okay to
timestamp a single packet at a time and simply not timestamp any packet
that might be concurrent with that, no warning or questions asked. We
should queue that second packet if it cannot be marked for timestamping
right away.

Which brings me to my second point, there used to be a generic deferred
xmit mechanism in DSA that also happened to solve this problem because
yes, there was a function pointer in dsa_switch_ops for it.
But you and Richard didn't quite like it, so I removed it.
https://patchwork.ozlabs.org/cover/1215617/
