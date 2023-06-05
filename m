Return-Path: <netdev+bounces-8186-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECA09722FE4
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D31A41C20988
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5922224E97;
	Mon,  5 Jun 2023 19:38:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475F72415C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:38:28 +0000 (UTC)
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2AAED
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:38:26 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2b1ac373c9eso49015941fa.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 12:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685993904; x=1688585904;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U8BceSTb/ueXp+FJPSkU6yGPSfQrcXh8uFcHja7e6jA=;
        b=dwjV7epPKMIHMcdPFKYglaMzPj7uTI62EO+Ao4GZFVNsRRynAP02mTgs2xf+MFHMZl
         QTvYUpUmv/MujKb4/9AxTJVXppFa1dZj1MD8/WfLyI5OC09FYD2ZvkCb7gd7XcQosOp4
         TjKzmytJ4St9YvkDwhknv809U5jFdZxPjp6CNNqkbuBHHU3gUosqPgJ8rHnuwqkb+nwN
         lKgJyP4gXOceLZhoYv6uCqQXWvsivb2/xXQ5xEHGBotCaW7vqbwejaf0wsxGoXNMW/BF
         W76xuNVX75q69fcwdOGd1LUZAg2rz/1grfjsP7JIXdsDpuq7/9brra3n/cAwcBuFiPFW
         Ycmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685993904; x=1688585904;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U8BceSTb/ueXp+FJPSkU6yGPSfQrcXh8uFcHja7e6jA=;
        b=biZ2U4OHL7tcjIHuGDGkEXXQ9tDtp59ryWBzQGKkvQVNSSKgLntxqpnTRa/OegXw+u
         zS6X1q6mxSWA/q7XYAsugmO8MgSTR2rMno987QxS9ZEdRI3rveZcJfp3hDl+4bFtFTcV
         IRGUJCkJIl7OAD1pxwVajbRLnYSGhtBBXEeo6MyG1N0ucGMXe6rUiiML9EFizAqkgk1K
         GURtfrMWyTpNM8+lcflIgU4OgA8Z1UNFuV9FwVS9tZ3znt/+JeQzBHZEjk4dOHrqC11k
         xQUdVXu/hWDqn4uD/p339sc9CFwvKOj2zRjKipQbHQYkT5Khr6wORWILELIbfabb39Jw
         EYIw==
X-Gm-Message-State: AC+VfDwFjJ0VdVARLR21crFWRH6C+chh4KHqb6VOiuO7zWr6XOhGDHmG
	a1ECYvmBkTF4/6Ov1BCNb+iXNqoKUToCC5p1yVML4WrmKBc=
X-Google-Smtp-Source: ACHHUZ79JoZOtFXzX75fkY5p7L84xPAvi0n7rQ0D3raZZrclooA8Om1FypbIIRMCcxkmgOMv2WE/RJiblWw2tUTQzAo=
X-Received: by 2002:a05:651c:90:b0:2b1:a8bb:99ab with SMTP id
 16-20020a05651c009000b002b1a8bb99abmr120400ljq.19.1685993904092; Mon, 05 Jun
 2023 12:38:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0df383e20e5a90494e3cbd0cf23c508c5c943ab4.1685725191.git.chunkeey@gmail.com>
In-Reply-To: <0df383e20e5a90494e3cbd0cf23c508c5c943ab4.1685725191.git.chunkeey@gmail.com>
From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date: Mon, 5 Jun 2023 16:38:12 -0300
Message-ID: <CAJq09z4usfR=TqQMOd6DiPrNKhQi6vr-AWuMbgGvGa+E-RTFbw@mail.gmail.com>
Subject: Re: [PATCH v1] net: dsa: realtek: rtl8365mb: use mdio passthrough to
 access PHYs
To: Christian Lamparter <chunkeey@gmail.com>
Cc: netdev@vger.kernel.org, alsi@bang-olufsen.dk, linus.walleij@linaro.org, 
	andrew@lunn.ch, olteanv@gmail.com, f.fainelli@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi, Christian

> when bringing up the PHYs on a Netgear WNDAP660, I observed that
> none of the PHYs are getting enumerated and the rtl8365mb fails
> to load.
>
> | realtek-mdio [...] lan1 (unini...): validation of gmii with support \
> |   0...,0.,..6280 and advertisement 0...,0...,6280 failed: -EINVAL
> | realtek-mdio [...] lan1 (uninit...): failed to connect to PHY: -EINVAL
> | realtek-mdio [...] lan1 (uninit...): error -22 setting up PHY for
> |   tree 0, switch 0, port 0
>
> with phytool, all registers just returned "0000".
>
> Now, the same behavior was present with the swconfig version of
> rtl8637b.c and in the device's uboot the "mii" register access
> utility also reports bogus values.
>
> The Netgear WNDAP660 might be somewhat special, since the RTL8363SB
> uses exclusive MDC/MDIO-access (instead of SMI). (And the RTL8363SB
> is not part of the supported list of this driver).
>
> Since this was all hopeless, I dug up some datasheet when searching
> for solutions:
> "10/100M & 10/100/1000M Switch Controller Programming Guide".
> It had an interesting passage that pointed to a magical
> MDC_MDIO_OPERATION define which resulted in different slave PHY
> access for the MDIO than it was implemented for SMI.
>
> With this implemented, the RTL8363SB PHYs came to live:
>
> | [...]: found an RTL8363SB-CG switch
> | [...]: missing child interrupt-controller node
> | [...]: no interrupt support
> | [...]: configuring for fixed/rgmii link mode
> | [...] lan1 (uninit...): PHY [dsa-0.0:01] driver [Generic PHY] (irq=POLL)
> | [...] lan2 (uninit...): PHY [dsa-0.0:02] driver [Generic PHY] (irq=POLL)
> | device eth0 entered promiscuous mode
> | DSA: tree 0 setup
> | realtek-mdio 4ef600c00.ethernet:00: Link is Up - 1Gbps/Full - [...]
>
> | # phytool lan1/2
> | ieee-phy: id:0x001cc980 <--- this is correct!!
> |
> |  ieee-phy: reg:BMCR(0x00) val:0x1140
> |     flags:          -reset -loopback +aneg-enable -power-down
> |                     -isolate -aneg-restart -collision-test
> |     speed:          1000-full
> |
> |  ieee-phy: reg:BMSR(0x01) val:0x7969
> |     capabilities:   -100-b4 +100-f +100-h +10-f +10-h -100-t2-f
> |                     -100-t2-h
> |      flags:         +ext-status +aneg-complete -remote-fault
> |                     +aneg-capable -link -jabber +ext-register
>
> the port statistics are working too and the exported LED triggers.
> But so far I can't get any traffic to pass.
>
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> ---
> Any good hints or comments? Is the RTL8363SB an odd one here and
> everybody else can just use SMI?

It seems that the indirect read using the register protocol does not
work with your device. Yes, I could have used the memory mapped under
the 0x2000 base to read those indirect registers, but I chose to keep
the SMI-way as it was working even for an MDIO device. Using the same
code path also helped uncover some issues with SMI. I didn't test
writing to those registers, but reading from them does work with my
RTL8367S.

Perhaps in your device generation, there is something different in the
indirect read protocol used by SMI but optional (or non-existing) for
MDIO devices. It might be worth trying to check if the SMI protocol
used by other old drivers would work with your device and how they
differ from the current rtl8365mb.c. If not, another RTL8363SB
connected through SMI might also break with rtl8365mb.c. I believe
that keeping a single code path independently the interface is
beneficial for the driver.

If we do need to have different phy_read/write methods, especially if
RTL8363SB SMI needs a different protocol, I think we could convert the
dsa_switch_ops into a dynamic structure and let the interface driver
(realtek-smi/mdio) select the methods.

The reason we have two ops for SMI and MDIO is not really related to
differences between them. It's only because realtek-smi implemented a
custom slave-mii, while realtek-mdio used the generic one that dsa
creates. I wrote a series of patches that eliminate that difference
and clean up some code. It was submitted last year but didn't progress
any further. I rebased it on net-next:

https://github.com/luizluca/linux/tree/realtek_deprecate_slave_mdio

Alvin, maybe we should revisit the series before introducing more complexity.

> So far, I'm just reusing the existing jam tables. rtl8367b.c jam
> tables ones don't help with getting "traffic".

I did some decoding while I was debugging an issue during realtek-mdio
implementation, but I stopped and never submitted it (and I probably
lost it). There were a lot of register declarations, getters and
setters, converting a dozen lines into hundreds. Alvin, is that level
of verbosity acceptable? We could start by declaring the register
names. We need to read the vendor code to understand the context of
each register, as the docs we find online (search for "realtek
unmanaged switch programming guide") don't provide detailed
information about the registers. Even the vendor code sometimes uses
magic number shortcuts instead of calling its own functions.

Regarding the non-realtek packets, it might be the switch trapping
some special cases to the CPU port. Check if the IPv6 case, for
example, is not actually a multicast request.
RTL8365MB_CPU_INSERT_TO_ALL should handle that job, but your switch
might handle things differently.

Regards,

