Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A368D10C7E0
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 12:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfK1LY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 06:24:57 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45424 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfK1LY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 06:24:57 -0500
Received: by mail-ed1-f65.google.com with SMTP id b5so22391161eds.12
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 03:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KcOLrUW2GBsm8K1aC2A+s1dZUILIJXlDxpel/sF0Sg8=;
        b=s5lPTHLELNM+1fDWDir4y1YKuNxSavSucdlZRlgamNy/5Ua2Hya0S9SjlQwzBXG4Ic
         aqnVPt+kG6/0xbDj2gI9vVSaji7Si+4JAOSqiQT8BGUzTziFUClc4b+W1uaKTWUnipfs
         HOc7WryPngO9coPDLHDylClAAt9AIXPzklwQ9hA7HWPrtJVzDKMnqZm0JGIgSArTV4am
         pgTZbohKR3AHcDzzFaXr0O9gN0kGGB0YpXsWhZW6IyEK3bNJwaMQ5FWFkInyuPBPDT0C
         JRZmCQ3HvLMZHvTQU0WdMHfANTW2j69Fm9DdNGLjawPm3TV/NeAHt+ME0M2HZntY9lu9
         Gfwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KcOLrUW2GBsm8K1aC2A+s1dZUILIJXlDxpel/sF0Sg8=;
        b=cvsQGVeIvVbl+G4fOCTAuLO0IAcvZULqzpzNHyLkyaiF138UwZqn7OGL1w+95xiZ3V
         /otuX0z7X1gaJsdtEYhUs7L8Ycr5nhqE/JQhAg6p6GcmbQsqGafShoRLlv4TnkTUCKd2
         ku4AmG/31nLUrFXiBm7hAflic1qb82Y1hk454h5JZtDAN9bbLIg7MT0tqExEvYOiNvOW
         UHJUim2+bzUB1CmbalZ8U0wmsZFTRPWwsWObvXZ9HsIpIuVpsoYn8bwXJWbLppsJdORM
         W6NBHNbSoia+YFAl+21dOS/ekW7P+tH4gjbfXBnhPR6kHA6k/xaCKOT+Qb8OZy5IZZ67
         TjhA==
X-Gm-Message-State: APjAAAVGziCerr42DHxNbaszbts2pE7jawar8Sok+n6nMibp60kl3pSe
        DT7mnEe9eIvRyVAKW4CX5lNIQsukbGulhIDv1Ec=
X-Google-Smtp-Source: APXvYqyHK1RFqt4z2v5jYcuOipbV36hp9yluDOym9YqmHlmjACVhlKwQ/k7jDss6+NNnApdjF3/YQUv2TUa2As34Huk=
X-Received: by 2002:a17:906:ae85:: with SMTP id md5mr7587105ejb.151.1574940295573;
 Thu, 28 Nov 2019 03:24:55 -0800 (PST)
MIME-Version: 1.0
References: <20191128015636.26961-1-olteanv@gmail.com> <AM4PR0401MB2226E08F0618025F3F43EA38F8470@AM4PR0401MB2226.eurprd04.prod.outlook.com>
In-Reply-To: <AM4PR0401MB2226E08F0618025F3F43EA38F8470@AM4PR0401MB2226.eurprd04.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 28 Nov 2019 13:24:44 +0200
Message-ID: <CA+h21hqHzo4QSL5xd6Jv578Z2HMupHwetMqroQQqSoa7PuA81Q@mail.gmail.com>
Subject: Re: [PATCH net] net: mscc: ocelot: unregister the PTP clock on deinit
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Nov 2019 at 04:42, Y.b. Lu <yangbo.lu@nxp.com> wrote:
>
> > -----Original Message-----
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Sent: Thursday, November 28, 2019 9:57 AM
> > To: davem@davemloft.net; richardcochran@gmail.com
> > Cc: andrew@lunn.ch; f.fainelli@gmail.com; vivien.didelot@gmail.com;
> > Claudiu Manoil <claudiu.manoil@nxp.com>; Alexandru Marginean
> > <alexandru.marginean@nxp.com>; Xiaoliang Yang
> > <xiaoliang.yang_1@nxp.com>; Y.b. Lu <yangbo.lu@nxp.com>;
> > netdev@vger.kernel.org; alexandre.belloni@bootlin.com;
> > UNGLinuxDriver@microchip.com; Vladimir Oltean <vladimir.oltean@nxp.com>
> > Subject: [PATCH net] net: mscc: ocelot: unregister the PTP clock on deinit
> >
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > Currently a switch driver deinit frees the regmaps, but the PTP clock is still out
> > there, available to user space via /dev/ptpN. Any PTP operation is a ticking
> > time bomb, since it will attempt to use the freed regmaps and thus trigger
> > kernel panics:
> >
> > [    4.291746] fsl_enetc 0000:00:00.2 eth1: error -22 setting up slave phy
> > [    4.291871] mscc_felix 0000:00:00.5: Failed to register DSA switch: -22
> > [    4.308666] mscc_felix: probe of 0000:00:00.5 failed with error -22
> > [    6.358270] Unable to handle kernel NULL pointer dereference at virtual
> > address 0000000000000088
> > [    6.367090] Mem abort info:
> > [    6.369888]   ESR = 0x96000046
> > [    6.369891]   EC = 0x25: DABT (current EL), IL = 32 bits
> > [    6.369892]   SET = 0, FnV = 0
> > [    6.369894]   EA = 0, S1PTW = 0
> > [    6.369895] Data abort info:
> > [    6.369897]   ISV = 0, ISS = 0x00000046
> > [    6.369899]   CM = 0, WnR = 1
> > [    6.369902] user pgtable: 4k pages, 48-bit VAs, pgdp=00000020d58c7000
> > [    6.369904] [0000000000000088] pgd=00000020d5912003,
> > pud=00000020d5915003, pmd=0000000000000000
> > [    6.369914] Internal error: Oops: 96000046 [#1] PREEMPT SMP
> > [    6.420443] Modules linked in:
> > [    6.423506] CPU: 1 PID: 262 Comm: phc_ctl Not tainted
> > 5.4.0-03625-gb7b2a5dadd7f #204
> > [    6.431273] Hardware name: LS1028A RDB Board (DT)
> > [    6.435989] pstate: 40000085 (nZcv daIf -PAN -UAO)
> > [    6.440802] pc : css_release+0x24/0x58
> > [    6.444561] lr : regmap_read+0x40/0x78
> > [    6.448316] sp : ffff800010513cc0
> > [    6.451636] x29: ffff800010513cc0 x28: ffff002055873040
> > [    6.456963] x27: 0000000000000000 x26: 0000000000000000
> > [    6.462289] x25: 0000000000000000 x24: 0000000000000000
> > [    6.467617] x23: 0000000000000000 x22: 0000000000000080
> > [    6.472944] x21: ffff800010513d44 x20: 0000000000000080
> > [    6.478270] x19: 0000000000000000 x18: 0000000000000000
> > [    6.483596] x17: 0000000000000000 x16: 0000000000000000
> > [    6.488921] x15: 0000000000000000 x14: 0000000000000000
> > [    6.494247] x13: 0000000000000000 x12: 0000000000000000
> > [    6.499573] x11: 0000000000000000 x10: 0000000000000000
> > [    6.504899] x9 : 0000000000000000 x8 : 0000000000000000
> > [    6.510225] x7 : 0000000000000000 x6 : ffff800010513cf0
> > [    6.515550] x5 : 0000000000000000 x4 : 0000000fffffffe0
> > [    6.520876] x3 : 0000000000000088 x2 : ffff800010513d44
> > [    6.526202] x1 : ffffcada668ea000 x0 : ffffcada64d8b0c0
> > [    6.531528] Call trace:
> > [    6.533977]  css_release+0x24/0x58
> > [    6.537385]  regmap_read+0x40/0x78
> > [    6.540795]  __ocelot_read_ix+0x6c/0xa0
> > [    6.544641]  ocelot_ptp_gettime64+0x4c/0x110
> > [    6.548921]  ptp_clock_gettime+0x4c/0x58
> > [    6.552853]  pc_clock_gettime+0x5c/0xa8
> > [    6.556699]  __arm64_sys_clock_gettime+0x68/0xc8
> > [    6.561331]  el0_svc_common.constprop.2+0x7c/0x178
> > [    6.566133]  el0_svc_handler+0x34/0xa0
> > [    6.569891]  el0_sync_handler+0x114/0x1d0
> > [    6.573908]  el0_sync+0x140/0x180
> > [    6.577232] Code: d503201f b00119a1 91022263 b27b7be4 (f9004663)
> > [    6.583349] ---[ end trace d196b9b14cdae2da ]---
> > [    6.587977] Kernel panic - not syncing: Fatal exception
> > [    6.593216] SMP: stopping secondary CPUs
> > [    6.597151] Kernel Offset: 0x4ada54400000 from 0xffff800010000000
> > [    6.603261] PHYS_OFFSET: 0xffffd0a7c0000000
> > [    6.607454] CPU features: 0x10002,21806008
> > [    6.611558] Memory Limit: none
> > [    6.614620] Rebooting in 3 seconds..
> >
> > Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/ethernet/mscc/ocelot.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/mscc/ocelot.c
> > b/drivers/net/ethernet/mscc/ocelot.c
> > index 52a1b1f12af8..245298d9ba8c 100644
> > --- a/drivers/net/ethernet/mscc/ocelot.c
> > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > @@ -2166,6 +2166,14 @@ static struct ptp_clock_info ocelot_ptp_clock_info
> > = {
> >       .adjfine        = ocelot_ptp_adjfine,
> >  };
> >
> > +static void ocelot_deinit_timestamp(struct ocelot *ocelot) {
> > +     if (!ocelot->ptp || !ocelot->ptp_clock)
> > +             return;
> > +
> > +     ptp_clock_unregister(ocelot->ptp_clock);
>
> [Y.b. Lu] It makes sense. How about,
>
> If (ocelot->ptp_clock)
>         ptp_clock_unregister(ocelot->ptp_clock);
>

Ok, sent a v2 with this change. I needed to do one more check in
ocelot_init_timestamp anyway.

> > +}
> > +
> >  static int ocelot_init_timestamp(struct ocelot *ocelot)  {
> >       ocelot->ptp_info = ocelot_ptp_clock_info; @@ -2508,6 +2516,7 @@ void
> > ocelot_deinit(struct ocelot *ocelot)
> >       destroy_workqueue(ocelot->stats_queue);
> >       mutex_destroy(&ocelot->stats_lock);
> >       ocelot_ace_deinit();
> > +     ocelot_deinit_timestamp(ocelot);
> >
> >       for (i = 0; i < ocelot->num_phys_ports; i++) {
> >               port = ocelot->ports[i];
> > --
> > 2.17.1
>

Thanks,
-Vladimir
