Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 419BE16C1BD
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbgBYNIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:08:53 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44372 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729564AbgBYNIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:08:53 -0500
Received: by mail-ed1-f68.google.com with SMTP id g19so16137236eds.11
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 05:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4tyeplXY4bs8dB9fvy4OP+0sBP8hySqZ2OBhDKfBwhs=;
        b=aXy5MHqxyoLce+96Lv5LIrQD3pGGApEE5hNP2DmuWu+vXly5sNMf6lv0YRMZ5d20J3
         MtqWWIx5dbtOYNXj2cpbNBvd+FoCbWmO8CNRvcXyqPWNlcyiURqxThvA1IEln2yUAqDJ
         a1ic4GeZRAxP983vUayLI/4GVdDrvfm5rF9fuCF+gantPDj+KejRvMI1H+/BidJdYzBW
         vaOeQStR3grF4+aHD33Gvg6XncmZJQ/doQHhJKPKzDqLDWuZ1TM9AaAMeYrGnuVrFSkY
         A7iBygyZSb31tK0kAxXicybue8MDXS1YnAtiD66biqBos+j3ZfIuDBR+bctXP4/itpNR
         QO2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4tyeplXY4bs8dB9fvy4OP+0sBP8hySqZ2OBhDKfBwhs=;
        b=t6sglfIjVDojkNFmXmhXSt83LbF6JRRUYSOlV9oBTyjV2XjP0vMXIay+ZtAAR89g9S
         aVxowFucIq21Z9VLtMa0ejkRzMH+bWw7y0c0iDtBPpxNiIkm2OlpxougA3QP+Oojxq2b
         cIuFoB7q/RlRHGCegWCvS2C40KFjmDZH7qUhwxZyojkN/gV9CQZ0SKJkzhcSLv++RUH7
         O16QFBAYT4DQ0TF26ia7MVPmPZRNqcoSS04IL+iQKH+GfiQVjBo8znWB5ROv+5JuOjlS
         nsWgiTyXMkMBD5BdCt/x+oWyamE8OlQ2w3eh1oy8MhJmXOcI9U+2nA7EQg4PtInGsEl9
         Wy8g==
X-Gm-Message-State: APjAAAVmG03AeRLPKvESl1SPNeoP7hqrGT97OJLvSPQPJARPoI27JSlN
        Xp901aueActSWt/weU2y1Vr/iF/NNT6WS4iMiHo=
X-Google-Smtp-Source: APXvYqzTJef5WB1lI1eOZfEqh8qTWqGONqGIZ6aeoTnHDRHhLcscOzVlZS04fL61UjmFWuU6Vb3/O7HU1kxW0UjAkkY=
X-Received: by 2002:a17:906:4089:: with SMTP id u9mr52914499ejj.184.1582636131506;
 Tue, 25 Feb 2020 05:08:51 -0800 (PST)
MIME-Version: 1.0
References: <20200224213458.32451-1-olteanv@gmail.com> <20200225130223.kb7jg7u2kgjjrlpo@lx-anielsen.microsemi.net>
In-Reply-To: <20200225130223.kb7jg7u2kgjjrlpo@lx-anielsen.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 25 Feb 2020 15:08:40 +0200
Message-ID: <CA+h21hp41WXXTLZ0L2rwT5b1gMeL5YFBpNpCZMh7d9eWZpmaqw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/2] Allow unknown unicast traffic to CPU for
 Felix DSA
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Allan,

On Tue, 25 Feb 2020 at 15:02, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> On 24.02.2020 23:34, Vladimir Oltean wrote:
> >From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> >This is the continuation of the previous "[PATCH net-next] net: mscc:
> >ocelot: Workaround to allow traffic to CPU in standalone mode":
> >
> >https://www.spinics.net/lists/netdev/msg631067.html
> >
> >Following the feedback received from Allan Nielsen, the Ocelot and Felix
> >drivers were made to use the CPU port module in the same way (patch 1),
> >and Felix was made to additionally allow unknown unicast frames towards
> >the CPU port module (patch 2).
> >
> >Vladimir Oltean (2):
> >  net: mscc: ocelot: eliminate confusion between CPU and NPI port
> >  net: dsa: felix: Allow unknown unicast traffic towards the CPU port
> >    module
> >
> > drivers/net/dsa/ocelot/felix.c           | 16 ++++--
> > drivers/net/ethernet/mscc/ocelot.c       | 62 +++++++++++++---------
> > drivers/net/ethernet/mscc/ocelot.h       | 10 ----
> > drivers/net/ethernet/mscc/ocelot_board.c |  5 +-
> > include/soc/mscc/ocelot.h                | 67 ++++++++++++++++++++++--
> > net/dsa/tag_ocelot.c                     |  3 +-
> > 6 files changed, 117 insertions(+), 46 deletions(-)
>
> Hi Vladimer,
>
> Did this fix you original issue with the spamming of the CPU?
>
> /Allan

No, the entire handling of unknown unicast packets still leaves a lot
to be desired, but at least now the CPU gets those frames, which is
better than it not getting them.
For one thing, an unknown unicast packet received by a standalone
Felix port will still consume CPU cycles dropping it, whereas the same
thing cannot be said for a different DSA switch setup, say a sja1105
switch inheriting the MAC address from the DSA master, because the DSA
master drops that.
Secondly, even traffic that the CPU _intends_ to terminate remains
"unknown" from the switch's perspective, due to the
no-learning-from-injected-traffic issue. So that traffic is still
going to be flooded, potentially to unwanted ports as well.

Regards,
-Vladimir
