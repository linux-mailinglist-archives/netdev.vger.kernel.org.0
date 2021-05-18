Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65AA6387C8E
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 17:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350238AbhERPjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 11:39:13 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:18329 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238479AbhERPjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 11:39:12 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1621352267; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=fT/lRr9TGF7j93lEyEXldDjPNY+27pVG/LpIHHNwvu9Njd6mBIoLGiycOMjCXX0hyT
    yAlh+cF28Y3J1KucNpxkJeRNHLgeqrnBL+422t/Qi4ZPBGHi4Ah/ehZ2IbMNo3Uk0eAS
    M4NM3w1KcUIZ/Q0h/kWojAW8swiREe/8g9Ryid/E1Rvz2Ve2lKJlzJjvqM3h4hFGaNWu
    SLJBMNqgCCv/snXiTGdDslahMjIW34i+aoWpp79awm8tBc97IEZvmnW//WT9BgdjTdqp
    43KMrdyp/N3AG/pFn2iFyO13WK7kRovwH8Hwr4rcbIrjrqkE1fxQzpEFI5ROHuWKMOHf
    sgdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1621352267;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=RXdzcD8lF9tv64W9c1e+yZDS2kWzQ2g4CMcWojHmduQ=;
    b=IVRd4VR4+j0kCuDDHaBHB5t6HG6aAHcyJhiKd1x0rZuzciqtRvzJINamWjz0HKfLSt
    BQQn3MAHa4A4V7tyd26Ak+ugKsc//jPfY8CEtu4enR7JR1juhBL2HgsoLB7XztW2eXEk
    PVpFyZWsy9mTWX9iXQUJSZEfAf0YdKBFgMpRJR1ZUlEb2PQXeJeHQfuISc+jNTtjYmxF
    qqSAu9J3YctG7rlUNdgYotu5Nl7j5G/jSTbXexpCIDHKASA35eH5NA5miqICHXFHfEIM
    pwSQOE8wT8NbqONQUEcNHut3rfOPjZj+H3/eGkkQJqVFi0D2EcIJ7IjUk7G7Ylain+XM
    YeAA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1621352267;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=RXdzcD8lF9tv64W9c1e+yZDS2kWzQ2g4CMcWojHmduQ=;
    b=qWH483TvRZaRptJMFshttJsjzNeYz8hcj+OszPcPNXzObpieOwkJmQ7x3C/47MJYXr
    4ON3ltQOT3FdkaT0FZtqI1oRyeN18h6HVlczdqFj2EPugLFMHS+svJU9OVXxhajP22aX
    Ij45t+8ApDlJ4ymAAyPGCMx1gCnqG1P+H459Iwg0mXSGzqvew7sTma7HXb98mP1eQFe/
    G9epNgcfy+Kx9xlRCxZaecQOqW97yEhj92oewO0mFj+Q0SrzEmQex6zh076xpSRHFMoY
    IOr2BAJXmYflVFJw98TyGb0+38t0iVwaVloRgcc4q29S7D5onwH8heBjo9aqsJQlUjl0
    ASxg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j7Ic/Da4o="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.26.1 DYNA|AUTH)
    with ESMTPSA id z041eax4IFbk1IN
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 18 May 2021 17:37:46 +0200 (CEST)
Date:   Tue, 18 May 2021 17:37:43 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        ~postmarketos/upstreaming@lists.sr.ht
Subject: Re: [linux-nfc] Re: [PATCH 2/2] nfc: s3fwrn5: i2c: Enable optional
 clock from device tree
Message-ID: <YKPfRxlA0L2zgkq5@gerhold.net>
References: <20210518133935.571298-1-stephan@gerhold.net>
 <20210518133935.571298-2-stephan@gerhold.net>
 <ac04821e-359d-aaaa-7e07-280156f64036@canonical.com>
 <YKPWgSnz7STV4u+c@gerhold.net>
 <8b14159f-dca9-a213-031f-83ab2b3840a4@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b14159f-dca9-a213-031f-83ab2b3840a4@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, May 18, 2021 at 11:25:55AM -0400, Krzysztof Kozlowski wrote:
> On 18/05/2021 11:00, Stephan Gerhold wrote:
> > Hi,
> > 
> > On Tue, May 18, 2021 at 10:30:43AM -0400, Krzysztof Kozlowski wrote:
> >> On 18/05/2021 09:39, Stephan Gerhold wrote:
> >>> s3fwrn5 has a NFC_CLK_REQ output GPIO, which is asserted whenever
> >>> the clock is needed for the current operation. This GPIO can be either
> >>> connected directly to the clock provider, or must be monitored by
> >>> this driver.
> >>>
> >>> As an example for the first case, on many Qualcomm devices the
> >>> NFC clock is provided by the main PMIC. The clock can be either
> >>> permanently enabled (clocks = <&rpmcc RPM_SMD_BB_CLK2>) or enabled
> >>> only when requested through a special input pin on the PMIC
> >>> (clocks = <&rpmcc RPM_SMD_BB_CLK2_PIN>).
> >>>
> >>> On the Samsung Galaxy A3/A5 (2015, Qualcomm MSM8916) this mechanism
> >>> is used with S3FWRN5's NFC_CLK_REQ output GPIO to enable the clock
> >>> only when necessary. However, to make that work the s3fwrn5 driver
> >>> must keep the RPM_SMD_BB_CLK2_PIN clock enabled.
> >>
> >> This contradicts the code. You wrote that pin should be kept enabled
> >> (somehow... by driver? by it's firmware?) but your code requests the
> >> clock from provider.
> >>
> > 
> > Yeah, I see how that's a bit confusing. Let me try to explain it a bit
> > better. So the Samsung Galaxy A5 (2015) has a "S3FWRN5XS1-YF30", some
> > variant of S3FWRN5 I guess. That S3FWRN5 has a "XI" and "XO" pin in the
> > schematics. "XO" seems to be floating, but "XI" goes to "BB_CLK2"
> > on PM8916 (the main PMIC).
> > 
> > Then, there is "GPIO2/NFC_CLK_REQ" on the S3FWRN5. This goes to
> > GPIO_2_NFC_CLK_REQ on PM8916. (Note: I'm talking about two different
> > GPIO2 here, one on S3FWRN5 and one on PM8916, they just happen to have
> > the same number...)
> > 
> > So in other words, S3FWRN5 gets some clock from BB_CLK2 on PM8916,
> > and can tell PM8916 that it needs the clock via GPIO2/NFC_CLK_REQ.
> > 
> > Now the confusing part is that the rpmcc/clk-smd-rpm driver has two
> > clocks that represent BB_CLK2 (see include/dt-bindings/clock/qcom,rpmcc.h):
> > 
> >   - RPM_SMD_BB_CLK2
> >   - RPM_SMD_BB_CLK2_PIN
> > 
> > (There are also *_CLK2_A variants but they are even more confusing
> >  and not needed here...)
> > 
> > Those end up in different register settings in PM8916. There is one bit
> > to permanently enable BB_CLK2 (= RPM_SMD_BB_CLK2), and one bit to enable
> > BB_CLK2 based on the status of GPIO_2_NFC_CLK_REQ on PM8916
> > (= RPM_SMD_BB_CLK2_PIN).
> > 
> > So there is indeed some kind of "AND" inside PM8916 (the register bit
> > and "NFC_CLK_REQ" input pin). To make that "AND" work I need to make
> > some driver (here: the s3fwrn5 driver) enable the clock so the register
> > bit in PM8916 gets set.
> 
> Thanks for the explanation, it sounds good. The GPIO2 (or how you call
> it NFC_CLK_REQ) on S3FWRN5 looks like non-configurable from Linux point
> of view. Probably the device firmware plays with it always or at least
> handles it in an unknown way for us.
> 
> In such case there is no point to do anything more with the provided
> clock than what you are doing - enable it when device is on, disable
> when off.
> 
> I think it is enough to rephrase the msg:
> 1. Add at beginning that device has one clock input (XI pin). The clock
> input was so far ignored (assumed to be routed to some always-on
> oscillator).
> 2. The device should enable the clock when running.
> 3. Add all of your paragraph about detailed logic on GPIO.
> 
> Since the GPIO is non-controllable, it actually does not matter that
> much for the driver, so you can add it for relevance, but not as main
> point of the patch.
> 

The GPIO does not matter for the driver in my case (and requesting it
from the s3fwrn5 driver would likely break my special pinctrl setup
that muxes it to the "AND" in PM8916).

However, I did see some alternative code in the vendor NFC driver where
they request it, set up an interrupt for it and then do the
"clk_prepare_enable()" when it's asserted and clk_disable_unprepare()
when de-asserted.

I guess there are like 3 typical setups for the clock:

  1. Always-on oscillator
  2. GPIO2 magically handled by clock provider (my case)
  3. GPIO2 connected to SoC, driver must monitor it

We might need 3. at some point, but I don't think it makes sense to add
it until someone actually needs it (and can test it).

I will try to reword the message a bit and send a v2 tomorrow or so.

Thanks!
Stephan
