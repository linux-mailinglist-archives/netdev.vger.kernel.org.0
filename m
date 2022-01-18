Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A5B49313E
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 00:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350213AbiARXNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 18:13:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbiARXNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 18:13:01 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E3BC061574;
        Tue, 18 Jan 2022 15:13:01 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id w26so1480247wmi.0;
        Tue, 18 Jan 2022 15:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1W+xaCDXDvAJlEN1TanaAKIlI9w1S61ZKcKIY4ZvN34=;
        b=XwCCwZw7otuDFLbTs78kHSJj//fcLQCz8QmA6Ggz5EcxuEBuTRnhyNCQrgcZLMGmmc
         1CZBDzxju3X5m+vzjruvsXSs/Dg41k4b7aOaWWf+MSFse/l2x2Ibf9DE272MFrJUieh5
         p37d0YlhA1Rk2Nmg/mjry7uexHauayJ1DBYZBN0SWO+eMHqhkuMeaEtywrKLXNfrUcr/
         E+6vFmWSsiNTMEtV6UObduWqLK8LxXvxrlsOB+pia6qkzd5y8y0Zq55KiTVSHCiVMabV
         s0H4XK/y8DEEOFiHLLnPi2bFgkrhsJinso80O7y7IOmFVWEXlkikUJ7V3IoTOcia+Vwt
         rWbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1W+xaCDXDvAJlEN1TanaAKIlI9w1S61ZKcKIY4ZvN34=;
        b=TF5oWb0KVzkbeOG8Re7NjjRxnCR/081oo54g5XaVXFFfJ/0dX6LTwlPC+h2M80eHkG
         gmAw0zifYePD9bPBPgneRWlIuD1yC31/E+mUhvHzTvf5oEMcr4xOb6gRUkamem/KRGQd
         a1NX17axENNDgepd2Ux68P/IH6OQxUTswIAMkfU1os0KZW5hc3zF9E6pNszWdZnxnchw
         7B9O1ePCl2jc8/KoaZzxAoZf8GLk13Od/ja4jAtr1H89aoYVGK4jH8pk5mGh12l8ECVS
         ZrpvOJMUPlKigSla1n4JpTKvjEgPLL3bDbBcK3I2q+WIW68NV6T8YK8AcnOTVLQooNhP
         h9Vg==
X-Gm-Message-State: AOAM530zckULVjaBO+8x7YPhB0X0QYoXt4CmTFZhNSN4d0qow+m7AVeV
        u6L1s/n9lAfujVHOaokW6NmVfutHldbsxF5Jr6w=
X-Google-Smtp-Source: ABdhPJx76GKEMmb3A0Psaz/0A15zJhnun8lqD2Gi7JtDUSk9QDUyLPdN/j0By6bYROySFRFr6v0upSSiKwR8qNLIIYg=
X-Received: by 2002:adf:d1c7:: with SMTP id b7mr20758599wrd.81.1642547580086;
 Tue, 18 Jan 2022 15:13:00 -0800 (PST)
MIME-Version: 1.0
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
 <CAB_54W4q9a1MRdfK6yJHMRt+Zfapn0ggie9RbbUYi4=Biefz_A@mail.gmail.com> <20220118114023.2d2c0207@xps13>
In-Reply-To: <20220118114023.2d2c0207@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 18 Jan 2022 18:12:49 -0500
Message-ID: <CAB_54W4jAZqSJ-7VuT0uOukHEnxAYpaGqZ6S6n9tYst26F+VWQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/41] IEEE 802.15.4 scan support
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 18 Jan 2022 at 05:40, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> > > So far the only technical point that is missing in this series is the
> > > possibility to grab a reference over the module driving the net device
> > > in order to prevent module unloading during a scan or when the beacons
> > > work is ongoing.
>
> Do you have any advises regarding this issue? That is the only
> technical point that is left unaddressed IMHO.
>

module_get()/module_put() or I don't see where the problem here is.
You can avoid module unloading with it. Which module is the problem
here?

> > > Finally, this series is a deep reshuffle of David Girault's original
> > > work, hence the fact that he is almost systematically credited, either
> > > by being the only author when I created the patches based on his changes
> > > with almost no modification, or with a Co-developped-by tag whenever the
> > > final code base is significantly different than his first proposal while
> > > still being greatly inspired from it.
> > >
> >
> > can you please split this patch series, what I see is now:
> >
> > 1. cleanup patches
> > 2. sync tx handling for mlme commands
> > 3. scan support
>
> Works for me. I just wanted to give the big picture but I'll split the
> series.
>

maybe also put some "symbol duration" series into it if it's getting
too large? It is difficult to review 40 patches... in one step.

> Also sorry for forgetting the 'wpan-next' subject prefix.
>

no problem.

I really appreciate your work and your willingness to work on all
outstanding issues. I am really happy to see something that we can use
for mlme-commands and to separate it from the hotpath transmission...
It is good to see architecture for that which I think goes in the
right direction.

- Alex
