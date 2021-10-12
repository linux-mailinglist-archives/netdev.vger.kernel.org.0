Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DB442A6B1
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbhJLOGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbhJLOGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:06:02 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54348C061570;
        Tue, 12 Oct 2021 07:04:00 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id d9so81822edh.5;
        Tue, 12 Oct 2021 07:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=80h6wvdwCXl8aMWCsxwnWoDnL0RhjgODdxJ4RifM/C0=;
        b=XtYOZFlZxmtKBNhp2WkSGyR1I/zmsU2lQflUrDihgHq8M41/gHh5K1DlH1jzdBhKUn
         nGpO9D5/7c4OuzKLUTMTE/boi/F4J/B8KS9N5TPGJRFBZ0oofjKeDAohqFts59lHINht
         faJtPNPQjBA2HjkSbs+qabwwDSfAmDy/5LELRnX0cSZSRL/08a5ZkvtcQ7EXplaUJfKB
         a4jL/ApVJtflYz/zLiLbt3C7Xyzni+WNYib0zSomeWEI1ifpXsGxazG4cYGrQjdqeMsm
         tI0MQy84DNAkJGs7Q4gKAEhuc5Zf58YDYrG6knHPxXNAoEc3K+V7RPEJ1f4WNvjFX5JI
         2Zdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=80h6wvdwCXl8aMWCsxwnWoDnL0RhjgODdxJ4RifM/C0=;
        b=EvWnM8lrm2ENRvpWyAlmiI2KQeKE+xUqEaw6o8ereCRm0QcugOZq+mb9w3Mjdkdl/I
         owq4hVoeg+8jZFXNetX1tycC81XV4CTwlQkxlkLfdlQhANXFO+KVWtXdcrColo39xJAy
         49PCENN2lRgN2zChmGnW/FEl5Qn1+8qP9jOGcgK7+jD+YNUZDSta6sMpzVjRf+kOTIh5
         A+fqPhNPSRJMfqjdjfC+74S5z0Mx4E/XchQp4wbqk0GuIqKA2OqvvjL0GGfHY1UUL7ae
         sVSsmx909D4BFxdMTKtQeq2C6XaRHeqQgIVlN7xAhl/zVnP+mvHCDg5wOkjVhTHuI3Fy
         S2Sg==
X-Gm-Message-State: AOAM533LrITWvan7yk8ArUBm37ADaU4Y+554OvNr+gtr/Ix+v1nhvnHs
        DpFx49zcLkUW52plNFEmZ7A=
X-Google-Smtp-Source: ABdhPJynBoEn4t6d+ZqG3M4W+MqVjISvbZV9McCkp+wFfS5YypAwvUbkRni8q1PBDIlnH3zGy1x/4w==
X-Received: by 2002:a05:6402:50ca:: with SMTP id h10mr122465edb.262.1634047438686;
        Tue, 12 Oct 2021 07:03:58 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id q9sm4967451ejf.70.2021.10.12.07.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 07:03:58 -0700 (PDT)
Date:   Tue, 12 Oct 2021 17:03:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Message-ID: <20211012140356.kqd5g6h2lhvugpxz@skbuf>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
 <20211012123557.3547280-6-alvin@pqrs.dk>
 <20211012130429.chiqugd57xoqf6hd@skbuf>
 <6848079b-eb8b-91c9-f64d-5f0c3fde36ec@bang-olufsen.dk>
 <ce2d43ae-d15e-4425-8728-07ed6fa38f9c@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce2d43ae-d15e-4425-8728-07ed6fa38f9c@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 01:50:44PM +0000, Alvin Šipraga wrote:
> >>> +static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int
> >>> port,
> >>> +                      phy_interface_t interface)
> >>> +{
> >>> +    int tx_delay = 0;
> >>> +    int rx_delay = 0;
> >>> +    int ext_port;
> >>> +    int ret;
> >>> +
> >>> +    if (port == smi->cpu_port) {
> >>> +        ext_port = PORT_NUM_L2E(port);
> >>> +    } else {
> >>> +        dev_err(smi->dev, "only one EXT port is currently
> >>> supported\n");
> >>> +        return -EINVAL;
> >>> +    }
> >>> +
> >>> +    /* Set the RGMII TX/RX delay
> >>> +     *
> >>> +     * The Realtek vendor driver indicates the following possible
> >>> +     * configuration settings:
> >>> +     *
> >>> +     *   TX delay:
> >>> +     *     0 = no delay, 1 = 2 ns delay
> >>> +     *   RX delay:
> >>> +     *     0 = no delay, 7 = maximum delay
> >>> +     *     No units are specified, but there are a total of 8 steps.
> >>> +     *
> >>> +     * The vendor driver also states that this must be configured
> >>> *before*
> >>> +     * forcing the external interface into a particular mode, which
> >>> is done
> >>> +     * in the rtl8365mb_phylink_mac_link_{up,down} functions.
> >>> +     *
> >>> +     * NOTE: For now this is hardcoded to tx_delay = 1, rx_delay = 4.
> >>> +     */
> >>> +    if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
> >>> +        interface == PHY_INTERFACE_MODE_RGMII_TXID)
> >>> +        tx_delay = 1; /* 2 ns */
> >>> +
> >>> +    if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
> >>> +        interface == PHY_INTERFACE_MODE_RGMII_RXID)
> >>> +        rx_delay = 4;
> >>
> >> There is this ongoing discussion that we have been interpreting the
> >> meaning of "phy-mode" incorrectly for RGMII all along. The conclusion
> >> seems to be that for a PHY driver, it is okay to configure its internal
> >> delay lines based on the value of the phy-mode string, but for a MAC
> >> driver it is not. The only viable option for a MAC driver to configure
> >> its internal delays is based on parsing some new device tree properties
> >> called rx-internal-delay-ps and tx-internal-delay-ps.
> >> Since you do not seem to have any baggage to support here (new driver),
> >> could you please just accept any PHY_INTERFACE_MODE_RGMII* value and
> >> apply delays (or not) based on those other OF properties?
> >> https://patchwork.kernel.org/project/netdevbpf/patch/20210723173108.459770-6-prasanna.vengateshan@microchip.com/>>
> >
> >
> > Ugh, I remember my head spinning when I first looked into this. But OK,
> > I can do as you suggest.
> >
> > Just to clarify: if the *-internal-delay-ps property is missing, you are
> > saying that I should set the delay to 0 rather than my defaults (tx=1,
> > rx=4), right?

Yes, I think so.

> Another problem is that for the RX delay, I have no idea what the actual
> unit of measurement is. See the comment I left in
> rtl8365mb_ext_config_rgmii().
>
> So I guess I could "reinterpret" rx-internal-delay-ps to mean these
> magic step values, or otherwise I don't know what might be the best
> practice.

I think what could work is you could accept only the 0 or 2000 ps values.
For the TX delay you say it is clear that you should program "1" to hardware.
For the RX delay I guess that the value of "4" is simply your best guess
of what would correspond to 2 ns. So you could just transform the 2000 ps
value into a "4" for the RX delay and make no other guesses otherwise.

> >>> +    ret = regmap_update_bits(
> >>> +        smi->map, RTL8365MB_EXT_RGMXF_REG(ext_port),
> >>> +        RTL8365MB_EXT_RGMXF_TXDELAY_MASK |
> >>> +            RTL8365MB_EXT_RGMXF_RXDELAY_MASK,
> >>> +        FIELD_PREP(RTL8365MB_EXT_RGMXF_TXDELAY_MASK, tx_delay) |
> >>> +            FIELD_PREP(RTL8365MB_EXT_RGMXF_RXDELAY_MASK, rx_delay));
> >>> +    if (ret)
> >>> +        return ret;
> >>> +
> >>> +    ret = regmap_update_bits(
> >>> +        smi->map, RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(ext_port),
> >>> +        RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(ext_port),
> >>> +        RTL8365MB_EXT_PORT_MODE_RGMII
> >>> +            << RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(
> >>> +                   ext_port));
> >>> +    if (ret)
> >>> +        return ret;
> >>> +
> >>> +    return 0;
> >>> +}
> >>
> >>> +static void rtl8365mb_phylink_mac_config(struct dsa_switch *ds, int
> >>> port,
> >>> +                     unsigned int mode,
> >>> +                     const struct phylink_link_state *state)
> >>> +{
> >>> +    struct realtek_smi *smi = ds->priv;
> >>> +    int ret;
> >>> +
> >>> +    if (!rtl8365mb_phy_mode_supported(ds, port, state->interface)) {
> >>> +        dev_err(smi->dev, "phy mode %s is unsupported on port %d\n",
> >>> +            phy_modes(state->interface), port);
> >>> +        return;
> >>> +    }
> >>> +
> >>> +    /* If port MAC is connected to an internal PHY, we have nothing
> >>> to do */
> >>> +    if (dsa_is_user_port(ds, port))
> >>> +        return;
> >>> +
> >>> +    if (mode != MLO_AN_PHY && mode != MLO_AN_FIXED) {
> >>> +        dev_err(smi->dev,
> >>> +            "port %d supports only conventional PHY or fixed-link\n",
> >>> +            port);
> >>> +        return;
> >>> +    }
> >>> +
> >>> +    if (phy_interface_mode_is_rgmii(state->interface)) {
> >>> +        ret = rtl8365mb_ext_config_rgmii(smi, port, state->interface);
> >>> +        if (ret)
> >>> +            dev_err(smi->dev,
> >>> +                "failed to configure RGMII mode on port %d: %d\n",
> >>> +                port, ret);
> >>> +        return;
> >>> +    }
> >>> +
> >>> +    /* TODO: Implement MII and RMII modes, which the RTL8365MB-VC also
> >>> +     * supports
> >>> +     */
> >>> +}
> >>> +
> >>> +static void rtl8365mb_phylink_mac_link_down(struct dsa_switch *ds,
> >>> int port,
> >>> +                        unsigned int mode,
> >>> +                        phy_interface_t interface)
> >>> +{
> >>> +    struct realtek_smi *smi = ds->priv;
> >>> +    int ret;
> >>> +
> >>> +    if (dsa_is_cpu_port(ds, port)) {
> >>
> >> I assume the "dsa_is_cpu_port()" check here can also be replaced with
> >> "phy_interface_mode_is_rgmii(interface)"? Can you please do that for
> >> consistency?
> >
> > Consistency with what exactly?

I was going to say with rtl8365mb_phylink_mac_config() where you do have
a specific check for phy_interface_mode_is_rgmii(), but now I notice
that it is further guarded by a "dsa_is_user_port()" check. So, with nothing.

> > All I'm saying with this code is that for CPU ports, we have to
> > force some mode on it in response to mac_link_up. This doesn't
> > apply to user ports because the PHY is always internal to the switch
> > (this appears to be the case for all switches in the rtl8365mb-like
> > family). Or are you wondering about a scenario where the port is
> > treated as a DSA port?

Understood that the code is functionally correct, but you're not forcing
the link because it's a CPU port, you're forcing the link because it's
an RGMII port. Semantically, a CPU port means something entirely
different: pass DSA-tagged frames to a host. Nothing at the physical link level.
On your switch it is basically a coincidence that all user ports have
internal PHYs, and the CPU port is RGMII. All I'm saying is to remove
the assumptions based on port roles from your MAC configuration logic.

For somebody searching the git tree for .phylink_mac_link_up implementations
and sleepwalking into your code, it will be deeply confusing to see such
logic, even if there is a drawing at the top of the file.

Why do you need these checks anyway and cannot simply distinguish based
on PHY_INTERFACE_MODE_INTERNAL vs PHY_INTERFACE_MODE_RGMII*?
