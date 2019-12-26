Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04DBC12ABF5
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 12:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfLZLj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 06:39:58 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42051 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfLZLj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 06:39:57 -0500
Received: by mail-ed1-f68.google.com with SMTP id e10so22381036edv.9;
        Thu, 26 Dec 2019 03:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hnDpuMiYhSgWz3b9tcFVN297Eqx81qPSphtkpFW2YI4=;
        b=EGpos4ezfLlYKew+l/e4uJMp1Skke6cJfAC2hkFpwhvi2aSWglVSxO/Apd0kmsyYU4
         h/9hBvwkjpD1LWarE95HV5ZORSNeSM6HLaCuBjhLCwboFt4tF4LDm8Wq+K/4nhVTXkPW
         U+0pnY2U09Jy1xRZjZVbFDO0oJX2AUUEqzmciqjfqDuxrMPMP+iJDX00dXXhOb1MG22G
         Iea+7+idDyh1+Rw72NADm1grR8WLkGAFilun3oYBoPzH+v8h87Rwgj2sBt6hXG5jeJkI
         mVWFElZi0AHWt9mwfuEtHRWy3OavHY+pJ/Pr3wik7d+JhHAU2p+I4Be8MjzmEnv+PXSt
         crXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hnDpuMiYhSgWz3b9tcFVN297Eqx81qPSphtkpFW2YI4=;
        b=PRmjcP8+zgyJGUap8VTrG5pFGJeXj4ofAqi8aK+wPcFm/+L3wpd5Z7qzphhOtSVDLp
         5HgCGRMXfxiNo+wUi496m2R7QAbpiRDBiF/kOS7Gi9AGTBVodjBakBkYQo47W/kMKUBm
         +5dBO5q/Kebp7inPfTNqKlFfyh3s26s/UjFi7XJfGdYBaZq3SdxO89LhibT0d7nQIlAn
         e/Ke5DW3vbFdkw30XEeadqBhul65RGp3aUajfFHM1qxTyeYmvByTjMUQYYGcXf1exLlM
         fWnRn8THKJqLyDThzgAQyb4jlDor40uYJ164LU6DcHe0h9osCFUTLjzBZsuW8eC7IZRl
         kf3g==
X-Gm-Message-State: APjAAAXUsnuQKgALJaB89OD9Z1z3kbMnoj6B5zgQsAIDUB6O7zkvE3CD
        ozA0QtZIHVkRjrRlEuiKRqq+Tx7AxBKp8AWvoug=
X-Google-Smtp-Source: APXvYqwnJ4hu5Maho1A6UkCjxWLgHWKDqj1W43SvfESp+qHnuiZUYYJ6rlO/+jx29OthsJx6Da6soJidQqqcVLjEI0s=
X-Received: by 2002:a17:906:e219:: with SMTP id gf25mr47257452ejb.51.1577360395212;
 Thu, 26 Dec 2019 03:39:55 -0800 (PST)
MIME-Version: 1.0
References: <20191225005655.1502037-1-martin.blumenstingl@googlemail.com>
 <20191225005655.1502037-2-martin.blumenstingl@googlemail.com>
 <20191225150845.GA16671@lunn.ch> <CAFBinCA4X1e5_5nBiHmNiB40uJyr9Nm1b2VkF9NqM+wb7-1xmw@mail.gmail.com>
 <20191226105044.GC1480@lunn.ch>
In-Reply-To: <20191226105044.GC1480@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 26 Dec 2019 12:39:44 +0100
Message-ID: <CAFBinCB8YQ-tuGBixO_85NFXDdrH5keDURFgri5tFLdrAwUJKg@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on
 Meson8b/8m2 SoCs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        davem@davemloft.net, khilman@baylibre.com,
        linus.luessing@c0d3.blue, balbes-150@yandex.ru,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ingrassia@epigenesys.com, jbrunet@baylibre.com,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, Dec 26, 2019 at 11:50 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > >       # RX and TX delays are added by the MAC when required
> > >       - rgmii
> > >
> > >       # RGMII with internal RX and TX delays provided by the PHY,
> > >       # the MAC should not add the RX or TX delays in this case
> > >       - rgmii-id
> > >
> > >       # RGMII with internal RX delay provided by the PHY, the MAC
> > >       # should not add an RX delay in this case
> > >       - rgmii-rxid
> > >
> > >       # RGMII with internal TX delay provided by the PHY, the MAC
> > >       # should not add an TX delay in this case
> > >       - rgmii-txid
> > >
> > > So ideally, you want the MAC to add no delay at all, and then use the
> > > correct phy-mode so the PHY adds the correct delay. This gives you the
> > > most flexibility in terms of PHY and PCB design. This does however
> > > require that the PHY implements the delay, which not all do.
> > these boards (with RGMII PHY) that I am aware of are using an RTL8211F
> > PHY which implements a 2ns PHY TX delay
>
> We need to be careful here...
>
> Earlier this year we got into a mess with a PHY driver wrongly
> implemented these delays. DT contained 'rgmii', but the PHY driver
> actually implemented rgmii-id'. Boards worked, because they actually
> needed rgmii-id. But then came along a board which really did need
> rgmii. We took the decision, maybe the wrong decision, to fix the PHY
> driver, and fixup DT files as we found boards which had the incorrect
> setting. We broke a lot of boards for a while and caused lots of
> people pain.
>
> You might have something which works, but i want to be sure it is
> actually correct, not two bugs cancelling each other out.
(wow, that sounds painful)

> You say the RTL8211F PHY implements a 2ns PHY TX delay. So in DT, do
> you have the phy-mode of 'rgmii-txid'? That would be the correct
> setting to say that the PHY provides only the TX delay.
yes, in my experiment (for which I did not send patches to the list
yet because we're discussing that part) I set phy-mode = "rgmii-txid";
this also makes the dwmac-meson8b driver ignore any TX delay on the MAC side

> > however, the 3.10 vendor kernel also supports Micrel RGMII (and RMII)
> > PHYs where I don't know if they implement a (configurable) TX delay.
> >
> > > Looking at patches 2 and 3, the phy-mode is set to rgmii. What you
> > > might actually need to do is set this to rgmii-txid, or maybe
> > > rgmii-id, once you have the MAC not inserting any delay.
> > please let us split this discussion:
> > 1) I believe that this patch is still correct and required whenever
> > the MAC *has to* generate the TX delay (one use-case could be the
> > Micrel PHYs I mentioned above)
>
> I think this patch splits into two parts. One is getting a 25MHz
> clock. That part i can agree with straight away. The second part is
> setting a 2ns TX delay. This we need to be careful of. What is the MAC
> actually doing after this patch? What is the configured RX delay? Does
> the driver explicitly configure the RX delay? To what?
good to see that we agree on the clock part!

the MAC is not capable of generating an RX delay (at least as far as I know).
to me this means that we are using the default on the PHY side (I
*assume* - but I have no proof - that this means the RX delay is
enabled, just like TX delay is enabled after a full chip reset)

> > 2) the correct phy-mode and where the TX delay is being generated. I
> > have tried "rgmii-txid" on my own Odroid-C1 and it's working fine
> > there. however, it's the only board with RGMII PHY that I have from
> > this generation of SoCs (and other testers are typically rare for this
> > platform, because it's an older SoC). so my idea was to use the same
> > settings as the 3.10 vendor kernel because these seem to be the "known
> > working" ones.
>
> Vendor kernels have the alternative of 'vendor crap' for a good
> reason. Just because it works does not mean it is correct.
yes, there's no general rule about the quality of vendor code
in my case I found Ethernet TX to be stable and close to Gbit/s speeds
on the vendor kernel while mainline was dropping packets and speeds
were worse
that still doesn't mean the vendor code is good, but from a user
perspective it's better than what we have in mainline

> > what do you think about 2)? my main concern is that this *could* break
> > Ethernet on other people's boards.
> > on the other hand I have no idea how likely that actually is.
>
> From what i understand, Ethernet is already broken? Or is it broken on
> just some boards?
it's mostly "broken" (high TX packet loss, slow TX speeds) for the two
supported boards with an RGMII PHY (meson8b-odroidc1.dts and
meson8m2-mxiii-plus.dts)
examples on the many ways it was broken will follow - feel free to
skip this part

before this patch we had:
input clock at 250MHz
|- m250_sel (inheriting the rate of the input clock because it's a mux)
   |- m250_div set to 1
      |- fixed_div_by_2 (outputting 125MHz for the RGMII TX clock)
together with a configured (but suspicious) TX delay of 4ns on the MAC
side in the board .dts
Transmitting ("sending") data via Ethernet has heavy packet loss and
far from Gbit/s speeds
(setting the TX delay on the MAC in this case to 2ns broke Ethernet
completely, even DHCP was failing)

after this patch we have:
input clock at 500MHz (double as before)
|- m250_sel (inheriting the rate of the input clock because it's a mux)
   |- m250_div set to 2
      |- fixed_div_by_2 (still outputting 125MHz for the RGMII TX clock)
with the old TX delay of 4ns on the MAC side there is still packet loss
updating the TX delay on the MAC side to 2ns (which is what the vendor
driver does) fixes the packet loss and transmit speeds

> The Micrel PHY driver can also control its clock skew, but it does it
> in an odd way, not via the phy-mode, but via additional
> properties. See the binding document.
I see, thank you for the hint

> What we normally say is make the MAC add no delays, and pass the
> correct configuration to the PHY so it adds the delay. But due to the
> strapping pin on the rtl8211f, we are in a bit of a grey area. I would
> suggest the MAC adds no delay, phy-mode is set to rmgii-id, the PHY
> driver adds TX delay in software, we assume the strapping pin is set
> to add RX delay, and we add a big fat comment in the DT.
>
> For the Micrel PHY, we do the same, plus add the vendor properties to
> configure the clock skew.
>
> But as i said, we are in a bit of a grey area. We can consider other
> options, but everything needs to be self consistent, between what the
> MAC is doing, what the PHY is doing, and what phy-mode is set to in
> DT.
do you think it's worth the effort to get clarification from Realtek
on the RX delay behavior (and whether there's a register to control
it)?
(when I previously asked them about interrupt support they answered
all my questions so we were able to confirm that it's implemented
properly upstream)
before this email I would have asked Realtek about the RX delay and
sent a patch updating rtl8211f_config_init (the
PHY_INTERFACE_MODE_RGMII_RXID and PHY_INTERFACE_MODE_RGMII_ID cases).

you mentioned that there was breakage earlier this year, so I'm not sure anymore
(that leaves me thinking: asking them is still useful to get out of
this grey area)


Martin
