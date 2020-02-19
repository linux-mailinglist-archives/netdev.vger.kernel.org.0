Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F1116464C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 15:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgBSOFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 09:05:21 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42827 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgBSOFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 09:05:21 -0500
Received: by mail-ed1-f65.google.com with SMTP id e10so29218317edv.9
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 06:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jVNn6ydOhoaFYlob8I2x9SK2uphuvWU546pINsPX6fQ=;
        b=N3q51zL/eN7z+aGyYmvJnQcRertnI8M1y/GJ2yl6wvyB747tg/DFM8NVjnKcStrVLn
         cJd72hZEdEmNwsqb3U44La3AdtsxGg/72vM04H4zX+RtXvIkaKpgdfrESUYc2k8XN9br
         tRxzh2GL9axA9c3oTbZ9txi1xKkVDS6nbqJFDJAC9gSj8VmTxAKy1DSkr3gLdZ9srnl8
         XZbffSfdb4HNW10K4OPn77xsVqW2axwAFd7v5VtgjiUM2JAISxcgMd5k7QFeBuyypXjr
         Twc7Q/QK+7EAsmAC5V08TJS1PUlt6xMyuE/ydUO2q5x/2Zid6Q+EjB9Vzx47OjCRNmYV
         xFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jVNn6ydOhoaFYlob8I2x9SK2uphuvWU546pINsPX6fQ=;
        b=NFzBkZ3vn7diAmtQbUAaZKKa4StXMqTNiqTAncu885fkWxwkXZMQWOtPV0LPr8hlz1
         XHIx/OPjkVyiqV0INnPF8JdKxsPTnr4tbiQcZlPDJdBN/74GWb16IzuMMHC0e2H9+siN
         XDYjkil6xOZhAiZmtUm4ZRltY2Xs6gelacBIsBplcoO+EzZRUTRmqOe1PF++ZpxiMdoa
         KiVLmuK0PTBr+diJQQRhSEC80kC+OqtlVIOI6aY7TzFOM4soVU4RxtuRWe/wH4/e1DKT
         ZcP3FB9eLdKgS7oLZBPiQcejqQeqrSxknrZBS1D5AnMGaX6mj2fTtClzj6/vMRrqJ3nA
         afGg==
X-Gm-Message-State: APjAAAXPfzVxhcxkwUdhBWSsmZ41k8I6mMu74xXnfZThjYjaiXQOkLFy
        LH0SsKPCJndbREwv4Gxw8PXopYtw+kWdNHw8rMc=
X-Google-Smtp-Source: APXvYqwTfd1hdSQivxKMZo7buxE2P7k5IIb2Q35JRxYrDLao9wHaRvElZ8biYQM2k4s2tGUsuZXXtEJwzXO3LIsjDwY=
X-Received: by 2002:a17:906:9501:: with SMTP id u1mr23328695ejx.113.1582121119254;
 Wed, 19 Feb 2020 06:05:19 -0800 (PST)
MIME-Version: 1.0
References: <20200217150058.5586-1-olteanv@gmail.com> <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
 <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com>
 <20200218140111.GB10541@lunn.ch> <20200219101739.65ucq6a4dmlfgfki@lx-anielsen.microsemi.net>
In-Reply-To: <20200219101739.65ucq6a4dmlfgfki@lx-anielsen.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 19 Feb 2020 16:05:08 +0200
Message-ID: <CA+h21hp5NQNJJ5agMPAZ+edaZ+ouSjTJ8DypYR5Htx3ZT5iSYA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: Workaround to allow traffic
 to CPU in standalone mode
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 at 12:17, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> With Ocelot we do not see this spamming - and I still do not understand
> why this is seen with Felix.
>

I should have watched my words.
When doing what all the other DSA switches do, which is enabling a
bulk forwarding path between the front-panel ports and the CPU, the
Ocelot switch core is more susceptible to doing more software
processing work than other devices in its class, for the same end
effect of dropping packets that the CPU is not interested in (say an
unknown unicast MAC that is not present in the switch FDB nor in the
DSA master's RX filter). In such a scenario, any other DSA system
would have the host port drop these packets in hardware, by virtue of
the unknown unicast MAC not being being present RX filter. With
Ocelot, this mechanism that prevents software work being done for
dropping is subverted. So to avoid this design limitation, the Ocelot
core does not enable a bulk forwarding path between the front-panel
ports and the CPU.

Hope this is clearer.

-Vladimir
