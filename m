Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EADB1E61D2
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390223AbgE1NKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:10:23 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38257 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390089AbgE1NKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 09:10:20 -0400
Received: by mail-ot1-f65.google.com with SMTP id o13so2292930otl.5;
        Thu, 28 May 2020 06:10:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PFNpJOdNreBWIv2VXMSlp6vZWYItaUUXM5F73hUgu2U=;
        b=KpQoZKEgtjmy/OOFtS570wk2BDehWspjwu2oiW6u4Nh7DMWo8+BNVlCyQN+1/cUUDh
         ep6glPMsAsTxuSFtiwG8YLVvlWt1xFWHazoddEIda541+eICaBml8k00X0eJQxff8sFw
         DuCyFe3Kj6jNnwdxaRX4PlZOYvjdkNfrfF6qOm5oqasLPR/qe6GTsfl6D8+rpTdiTfrB
         CANT2HD+3DyYv2fs+6nXlQG7m5GBeYHz+AhJV/YkxWYbqmuchqDw0WmF+1ao33QNJRTx
         tA+gjGYCWt/yVkkGk/XMG9quRQa+1foPW0YlkYL1PYMfKS+1wjH6DeSGkytKWsKuEgLZ
         48ug==
X-Gm-Message-State: AOAM531X2dl/1sRaJjcixleNQYJ7XPBxGnjoc9uAlutVUE2D7CPx/aSb
        4xBRv4jBODSR28GOfYYA12OSLheCINli4AMJ97s=
X-Google-Smtp-Source: ABdhPJx7BFJvf8y044qIdsQT28FXaoi9YVaS20PEV9bo5HB3o3F1La8Ij5WEwjXvIjPgrBgQKFqsHnZ++oV/3FFNeaY=
X-Received: by 2002:a05:6830:1151:: with SMTP id x17mr2247633otq.250.1590671418177;
 Thu, 28 May 2020 06:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
 <CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com>
 <20200428154718.GA24923@lunn.ch> <6791722391359fce92b39e3a21eef89495ccf156.camel@toradex.com>
 <CAMuHMdXm7n6cE5-ZjwxU_yKSrCaZCwqc_tBA+M_Lq53hbH2-jg@mail.gmail.com>
 <20200429092616.7ug4kdgdltxowkcs@pengutronix.de> <CAMuHMdWf1f95ZcOLd=k1rd4WE98T1qh_3YsJteyDGtYm1m_Nfg@mail.gmail.com>
 <20200527205221.GA818296@lunn.ch>
In-Reply-To: <20200527205221.GA818296@lunn.ch>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 28 May 2020 15:10:06 +0200
Message-ID: <CAMuHMdU+MR-2tr3-pH55G0GqPG9HwH3XUd=8HZxprFDMGQeWUw@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@protonic.nl" <david@protonic.nl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Wed, May 27, 2020 at 10:52 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > You may wonder what's the difference between 3 and 4? It's not just the
> > PHY driver that looks at phy-mode!
> > drivers/net/ethernet/renesas/ravb_main.c:ravb_set_delay_mode() also
> > does, and configures an additional TX clock delay of 1.8 ns if TXID is
> > enabled.
>
> That sounds like a MAC bug. Either the MAC insert the delay, or the
> PHY does. If the MAC decides it is going to insert the delay, it
> should be masking what it passes to phylib so that the PHY does not
> add a second delay.

And so I gave this a try, and modified the ravb driver to pass "rgmii"
to the PHY if it has inserted a delay.
That fixes the speed issue on R-Car M3-W!
And gets rid of the "*-skew-ps values should be used only with..."
message.

I also tried if I can get rid of "rxc-skew-ps = <1500>". After dropping
the property, DHCP failed.  Compensating by changing the PHY mode in DT
from "rgmii-txid" to "rgmii-id" makes it work again.

However, given Philippe's comment that the rgmi-*id apply to the PHY
only, I think we need new DT properties for enabling MAC internal delays.

> This whole area of RGMII delays has a number of historical bugs, which
> often counter act each other. So you fix one, and it break somewhere
> else.

Indeed...

> In this case, not allowing skews for plain RGMII is probably being too
> strict. We probably should relax that constrain in this case, for this
> PHY driver.

That description is not quite correct: the driver expects skews for
plain RGMII only. For RGMII-*ID, it prints a warning, but still applies
the supplied skew values.


To fix the issue, I came up with the following problem statement and
plan:

A. Old behavior:

  1. ravb acts upon "rgmii-*id" (on SoCs that support it[1]),
  2. ksz9031 ignored "rgmii-*id", using hardware defaults for skew
     values.

B. New behavior (broken):

  1. ravb acts upon "rgmii-*id",
  2. ksz9031 acts upon "rgmii-*id".

C. Quick fix for v5.8 (workaround, backwards-compatible with old DTB):

  1. ravb acts upon "rgmii-*id", but passes "rgmii" to phy,
  2. ksz9031 acts upon "rgmi", using new "rgmii" skew values.

D. Long-term fix:
  1. Check if new boolean "renesas,[rt]x-delay"[2] values are
      specified in DTB.
       No: ravb acts upon "rgmii-*id", but passes "rgmii" to phy, for
           backwards-compatibility,
       Yes: ravb enables TX clock delay of 2.0 ns and/or RX clock delay
            of 1.8 ns, based on "renesas,[rt]x-delay" values, and passes
            the unmodified interface type to phy,
  2. ksz9031 acts upon "rgmii*",
  3. Salvator-X(S) DTS makes things explicit by changing it from

        phy-mode = "rgmii-txid";
        rxc-skew-ps = <1500>;

     to:

        phy-mode = "rgmii";
        renesas,rx-delay = <false>;
        renesas,tx-delay = <true>;
        rxc-skew-ps = <1500>;

     or:

        phy-mode = "rgmii";
        renesas,rx-delay = <true>;
        renesas,tx-delay = <true>;

[2] Should we use numerical "renesas,[rt]x-delay-ps" instead?
     The only supported values are 0 and 2000 (TX) or 1800 (RX).

The ULCB boards are very similar to Salvator-X(S), so I guess they
behave the same, and are thus affected.

Unfortunately there are other boards that use R-Car Gen3 EtherAVB:
  - The Silicon Linux sub board for CAT874 (CAT875) connects EtherAVB to
    an RTL8211E PHY.  As it uses the "rgmii" mode, it should not be
    affected.
  - The HiHope RZ/G2M sub board connects EtherAVB to an RTL8211E PHY.
    It uses the "rgmii-txid" mode, so it will be affacted by modifying
    the ravb driver.
  - Eagle and V3MSK connect EtherAVB to a KSZ9031, and use the "rgmii-id"
    mode with rxc-skew-ps = <1500>, so they are affected.
  - Ebisu and Draak connect EtherAVB to a KSZ9031, and use the "rgmii"
    mode with rxc-skew-ps = <1500>.  However, they're limited to 100
    Mbps, as EtherAVB on R-Car E3 and D3 do not support TX clock
    internal delay mode[1], and the delays provided by KSZ9031 clock pad
    skew were deemed insufficient.

Obviously, the affected boards will need testing (I only have
Salvator-X(S) and Ebisu).

Does the above make sense?
Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
