Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9425944B290
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 19:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242182AbhKISST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 13:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241573AbhKISSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 13:18:09 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085DFC061764;
        Tue,  9 Nov 2021 10:15:23 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id g14so105575edz.2;
        Tue, 09 Nov 2021 10:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oCDUefM5oc1pTaSVPsqfq8VDRqVjc8fVTjdoYr50Dr4=;
        b=RG+NTcaV6DKkj5ZBxrf7TMRqtQJIdxgoiZ1ooSQPLmlEaoP3nXX+F3f1HnGOplAPRc
         Ov1QVJGi7sUXUpdhA34iE3XLho83KSve36oPeTqdI02lhmCImyKggExX9NCx0TneA9zg
         9AYOScNPzH6ExJtFzkq0Osudf1ROrs/WTst0C59tiXkd3W0WzMX1Mojpnv4NyIwAUV5u
         MNkoCyK+EpdTRes5ErGOio+DdJvnCDKa7R3wVIrxU2voZ58HlOraaDuZMzgU8Ax8P2uX
         bqsHX3rkSsx3PzBu7xgNgEczjqxPu2i3818JJRGnBhVSf+Bz68o8gSEzM65kW2OZCO/3
         CqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oCDUefM5oc1pTaSVPsqfq8VDRqVjc8fVTjdoYr50Dr4=;
        b=AhAny73CTsXzP0iPdS0e0VQOkn0a2ECyFX/GMUTQUdJmo8BZ0SYYrePnSjPyjNaXMZ
         UZpMCt23p0hI0AKtTL93jqKlSAvsvpeSwu3h9E6AyynFXo8+0wzH1/ysJ/mJjhiIw2rf
         mCB/phIEa7ry7HAQwr4GhlloLqnkOrjqjWiGgaKvxrtrGSXrw7hGweexVa2kgqfOGII5
         m3KVcitHi9EWSOH79Ujna7ueaksHUKiQ8r9bArhTQY0on/eYj2zHHHAK6Rs93ul8bkQn
         CnNpzMGjcRejqVZs05Q0rZSlQ0kZY1eRl0ZKotRLGtuIGbNFftd5PUiidsmzxnZH0wpH
         oVGg==
X-Gm-Message-State: AOAM532LfzLek2FLMfIXZs/sE0haxYFLe/vkDesbDT35HNEVB9B/jbmU
        gOUHXslH1Bq+bnCRothPafRpj4NlKOw5i9yx9fYbrsZjczU=
X-Google-Smtp-Source: ABdhPJxXjwd7oLCKD1XSL/s5FeabDqMfCUNMosUfoBzJ8Lj+urzIn7aFwIF+iJK2r6vI+T7QCEUSa0sTJjEppE91HMY=
X-Received: by 2002:a50:d50c:: with SMTP id u12mr12602049edi.118.1636481721571;
 Tue, 09 Nov 2021 10:15:21 -0800 (PST)
MIME-Version: 1.0
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-3-martin.kaistra@linutronix.de> <f71396fc-29a3-4022-3f7a-3a37abb9079c@gmail.com>
 <caec2d40-6093-ff06-ab8e-379e7939a85c@gmail.com>
In-Reply-To: <caec2d40-6093-ff06-ab8e-379e7939a85c@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 9 Nov 2021 20:15:10 +0200
Message-ID: <CA+h21hp+UKRgCE0UTZr7keyU380W22ZEXdbfORhSTNfzb1S_iw@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] net: dsa: b53: Move struct b53_device to include/linux/dsa/b53.h
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Nov 2021 at 20:11, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 11/9/21 10:05 AM, Florian Fainelli wrote:
> > On 11/9/21 1:50 AM, Martin Kaistra wrote:
> >> In order to access the b53 structs from net/dsa/tag_brcm.c move the
> >> definitions from drivers/net/dsa/b53/b53_priv.h to the new file
> >> include/linux/dsa/b53.h.
> >>
> >> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
> >> ---
> >>  drivers/net/dsa/b53/b53_priv.h |  90 +----------------------------
> >>  include/linux/dsa/b53.h        | 100 +++++++++++++++++++++++++++++++++
> >>  2 files changed, 101 insertions(+), 89 deletions(-)
> >>  create mode 100644 include/linux/dsa/b53.h
> >
> > All you really access is the b53_port_hwtstamp structure within the
> > tagger, so please make it the only structure exposed to net/dsa/tag_brcm.c.
>
> You do access b53_dev in the TX part, still, I would like to find a more
> elegant solution to exposing everything here, can you create a
> b53_timecounter_cyc2time() function that is exported to modules but does
> not require exposing the b53_device to net/dsa/tag_brcm.c?
> --
> Florian

Switch drivers can't export symbols to tagging protocol drivers, remember?
https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/
