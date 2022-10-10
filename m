Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550595F9F22
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 15:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJJNHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 09:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJJNHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 09:07:35 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272E111C00;
        Mon, 10 Oct 2022 06:07:13 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id s2so15852708edd.2;
        Mon, 10 Oct 2022 06:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PA170MT8Cdy+Qn7XlBE3Vc+Knb9tb4HZFxl8Mno0ppo=;
        b=YC5GDry43xY+2oKzY/5lUvaIycNbCJA2bpJUZP+6l+SJ4jnhLAxcXMITTy0FyRdxEA
         G033FssfZ/pJ46lPHgQg8Kcng3B1aN3RFjiR+1GxuJiJqVQtMml7r4Kp7SLWp+I4CneA
         oW1Aebz3zwVcWG1mnwhzdYyyjKh837zAU9TTEMTUo34YWYVFIHAVIqGi5DU4zcE4goWT
         IDM7UgzQALlgxpcZAl8GJMJzyulDeeFUmGtO27UvZ2Z7GIuSg6E5b+rjbFzgt7FUi8uN
         JCVjZ+Hbf6ujZj/863lerBbiI9KK2KV1WL0PcJKyEEmgRH/6vIBv6QK3BVHzEM5r2WUe
         p/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PA170MT8Cdy+Qn7XlBE3Vc+Knb9tb4HZFxl8Mno0ppo=;
        b=C1esJXer48EuB+ZIArwiBs4NQ3/eQC1QMeNSbERfWZfKCGvAbEgDsUpuPGFP/+JF0v
         SJkK1OmMdDnjStgmRQXzentg15kFrmqaYhGKbmrd4TOJnBldW7bq68duLGNnR+MrF9UW
         IxTslXkPuXGxcOCf5854psZQ3O1aNxmttSFtkwyHAU8pMLGvHvET8fyOoMQvuc4WOM62
         AIzXlxwBGMQCx6LHp9G36YcoeWiy6vwxgoJm2Vagzw1x0KScm1Up+oa2MmGVy1aN/sG1
         6h+YTiU6sk9Lw4Qdr9PeXBrANIhIfnugoT2WhhOzWWIEL8k3+L2bFaM8UR8vOmUTaCgR
         b8Lg==
X-Gm-Message-State: ACrzQf2hpa7IPh0ORsrHPYv7CiJVaDSbfwvOlXXrfnTVbWLFiwUIOJmg
        2o2OamwIeg0iVz59Psq/MSE=
X-Google-Smtp-Source: AMsMyM6WfWPeVjcIjLztoSZ19dgYMZJTqs8NyjuKfBoc0UASFP71lPOLc60IMDfZCzj4wNoxa6gFqQ==
X-Received: by 2002:aa7:c314:0:b0:458:dc90:467a with SMTP id l20-20020aa7c314000000b00458dc90467amr17295156edq.284.1665407231133;
        Mon, 10 Oct 2022 06:07:11 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id f13-20020a056402160d00b0044657ecfbb5sm7062195edv.13.2022.10.10.06.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 06:07:10 -0700 (PDT)
Date:   Mon, 10 Oct 2022 16:07:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <20221010130707.6z63hsl43ipd5run@skbuf>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
 <YzzLCYHmTcrHbZcH@colin-ia-desktop>
 <455e31be-dc87-39b3-c7fe-22384959c556@linaro.org>
 <Yz2mSOXf68S16Xg/@colin-ia-desktop>
 <28b4d9f9-f41a-deca-aa61-26fb65dcc873@linaro.org>
 <20221008000014.vs2m3vei5la2r2nd@skbuf>
 <c9ce1d83-d1ca-4640-bba2-724e18e6e56b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9ce1d83-d1ca-4640-bba2-724e18e6e56b@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 12:14:22PM -0400, Krzysztof Kozlowski wrote:
> On 08/10/2022 02:00, Vladimir Oltean wrote:
> > On Wed, Oct 05, 2022 at 06:09:59PM +0200, Krzysztof Kozlowski wrote:
> >>>> I don't understand how your answer relates to "reg=<0 0>;". How is it
> >>>> going to become 0x71010000 if there is no other reg/ranges set in parent
> >>>> nodes. The node has only one IO address, but you say the switch has 20
> >>>> addresses...
> >>>>
> >>>> Are we talking about same hardware?
> >>>
> >>> Yes. The switch driver for both the VSC7512 and VSC7514 use up to ~20 regmaps
> >>> depending on what capabilities it is to have. In the 7514 they are all
> >>> memory-mapped from the device tree. While the 7512 does need these
> >>> regmaps, they are managed by the MFD, not the device tree. So there
> >>> isn't a _need_ for them to be here, since at the end of the day they're
> >>> ignored.
> >>>
> >>> The "reg=<0 0>;" was my attempt to indicate that they are ignored, but I
> >>> understand that isn't desired. So moving forward I'll add all the
> >>> regmaps back into the device tree.
> >>
> >> You need to describe the hardware. If hardware has IO address space, how
> >> does it matter that some driver needs or needs not something?
> > 
> > What do you mean by IO address space exactly? It is a SPI device with registers.
> > Does that constitute an IO address space to you?
> 
> By IO I meant MMIO (or similar) which resides in reg (thus in unit
> address). The SPI devices have only chip-select as reg, AFAIR.

Again, the SPI device (soc@0) has a unit address that describes the chip
select, yes. The children of the SPI device have a unit address that
describes the address space of the SPI registers of the mini-peripherals
within that SPI device.

> > The driver need matters because you don't usually see DT nodes of SPI,
> > I2C, MDIO devices describing the address space of their registers, and
> > having child nodes with unit addresses in that address space. Only when
> > those devices are so complex that the need arises to identify smaller
> > building blocks is when you will end up needing that. And this is an
> > implementation detail which shapes how the dt-bindings will look like.
> 
> So probably I misunderstood here. If this is I2C or SPI device, then of
> course reg and unit address do not represent registers.

Except we're not talking about the SPI device, I'm reminding you that we
are talking about "reg = <0 0>" which Colin used to describe the
/spi/soc@0/ethernet-switch node.

Colin made the incorrect decision to describe "reg = <0 0>" for the
switch OF node in an attempt to point out that "reg" will *not* be used
by his implementation, whatever value it has. You may want to revisit
some of the things that were said.

What *is* used in the implementation is the array of resources from
struct mfd_cell vsc7512_devs[] in drivers/mfd/ocelot-core.c, because MFD
allows you to do this (and I suppose because it is more convenient than
to rely on the DT). Colin's entire confusion comes from the fact that he
thought it wouldn't be necessary to describe the unit addresses of MFD
children if those addresses won't be retrieved from DT.

> >> You mentioned that address space is mapped to regmaps. Regmap is Linux
> >> specific implementation detail, so this does not answer at all about
> >> hardware.
> >>
> >> On the other hand, if your DTS design requires this is a child of
> >> something else and by itself it does not have address space, it would be
> >> understandable to skip unit address entirely... but so far it is still
> >> confusing, especially that you use arguments related to implementation
> >> to justify the DTS.
> > 
> > If Colin skips the unit address entirely, then how could he distinguish
> > between the otherwise identical MDIO controllers mdio@7107009c and
> > mdio@710700c0 from Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml?
> > The ethernet-switch node added here is on the same hierarchical level
> > with the MDIO controller nodes, so it must have a unit address just like
> > them.
> 
> So what is @710700c0?

@710700c0 is VSC7512_MIIM1_RES_START, i.e. the base address of the
second MDIO controller embedded within the SoC (accessed over whatever;
SPI or MMIO).

> It's not chip-select, but MMIO or some other bus (specific to the
> device), right?

Yes, it is not chip select. Think of the /spi/soc@0 node as an AHB to
SPI bridge (it is possibly not quite that, but for the sake of imagination
it's a good enough description), and the children of /spi/soc@0 are
nodes whose registers are accessed through that AHB to SPI bridge.
The same addresses can also be accessed via direct MMIO by the processor
*inside* the switch SoC, which in some cases can also run Linux
(although not here in VSC7512, but in VSC7514).

> The mscc,ocelot.yaml has a soc@0 SPI device. Children of soc@0 use unit
> addresses/reg meaningful for that soc@0.

Which they do.

> > But I don't support Colin's choice of "reg=<0 0>;" either. A choice must
> > be made between 2 options:
> > - mapping all 20 regions of the SPI address space into "reg" values
> > - mapping a single region from the smallest until the largest address of
> >   those 20, and hope nothing overlaps with some other peripheral, or
> >   worse, that this region will never need to be expanded to the left.
> 
> Yeah, at least to my limited knowledge of this hardware.

Yeah what? That a decision must be made?

> > What information do you need to provide some best practices that can be
> > applied here and are more useful than "you need to describe the
> > hardware"? 
> 
> Describe the hardware properties in terms of it fit in to the whole
> system - so some inputs (clocks, GPIOs), outputs (interrupts),
> characteristics of a device (e.g. clock provider -> clock cells) and
> properties configuring hardware per specific implementation.
> 
> But mostly this argument "describe hardware" should be understood like:
> do not describe software (Linux drivers) and software policies (driver
> choices)...

Let's bring this back on track. The discussion started with you saying:

| soc in spi is a bit confusing.

which I completely agree with, it really is. But it's also not wrong
(or at least you didn't point out reasons why it would be, despite being
asked to), and very descriptive of what actually takes place here:
SoC registers are being accessed over SPI by an external host.

If you're going to keep giving mechanical review to this, my fear is
that a very complex set of schemas is going to fall through the cracks
of bureaucracy, and while it will end up being formally correct,
absolutely no one will understand what is actually required when
piecing everything together.

In your review of the example provided by Colin here, you first have
this comment about "soc in spi" being confusing, then you seem to forget
everything about that, and ask "How is this example different than
previous one (existing soc example)?"

There are more things to unpack in order to answer that.

The main point is that we wanted to reuse the existing MMIO-based
drivers when accessing the devices over SPI. So the majority of
peripherals have the same dt-bindings whether they are on /soc or on
/spi/soc. Linux also provides us with the mfd and regmap abstractions,
so all is good there. So you are not completely wrong to expect that an
ethernet-switch with the "mscc,vsc7512-switch" compatible string should
have the same bindings regardless of whatever its parent is.

Except this is not actually true, and the risk is that this will appear
as seamless as just that when it actually isn't.

First (and here Colin is also wrong), the switch Colin adds support for
is not directly comparable with "the existing soc example" (vsc9953).
That is different (NXP) hardware which just happens to be supported by
the same driver (drivers/net/dsa/ocelot). It's worth reiterating that
dissimilar hardware driven by a common driver should not necessarily
have the same dt-bindings. Case in point, the NXP switches have a single
(larger) "reg", because the SoC integration was tidier and the switch
doesn't have 20 regions spread out through the SoC's guts, which overlap
with other peripherals as in the case of VSC7512/VSC7514.

Anyway, Colin's SPI-controlled VSC7512 switch is most similar to
mscc,vsc7514-switch.yaml (to the point of the hardware being identical),
and I believe that this is the schema he should append his information to,
rather than what he's currently proposing in his patches.

*But* accessing an Ethernet switch over SPI is not functionally
identical to accessing it over MMIO, unless you want to have an Ethernet
throughput in the order of tens of bits per second.

This is where implementation starts to matter, and while mscc,vsc7514-switch.yaml
describes a switch where packets are sent and received over MMIO (which
wouldn't be feasible over SPI), Colin's VSC7512 schema describes a
switch used in DSA mode (packets are sent/received over a host Ethernet
port, fact which helps overcome the bandwidth limitations of SPI).
To make matters worse, even VSC7514 can be used in DSA mode. When used
in DSA mode, a *different* driver, with *different* dt-bindings (because
of different histories) controls it.

So what must be done is that mscc,vsc7514-switch.yaml must incorporate
*elements* of dsa.yaml, but *only* when it is not accessed using MMIO
(i.e. the Linux on the MIPS VSC7514 doesn't support an external host
driving the switch in DSA mode).

I was kind of expecting this discussion to converge towards ways in
which we can modify mscc,vsc7514-switch.yaml to support a switch used
in DSA mode or in switchdev mode. Most notable in dsa-port.yaml is the
presence of an 'ethernet' phandle, but there are also other subtle
differences, like the 'label' property which mscc,vsc7514-switch.yaml
does not have (and which in the switchdev implementation at
drivers/net/ethernet/mscc/ does not support, either).
