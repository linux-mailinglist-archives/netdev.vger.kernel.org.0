Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88EC5F80D5
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 00:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiJGWib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 18:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJGWia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 18:38:30 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC7782620;
        Fri,  7 Oct 2022 15:38:29 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bj12so14075668ejb.13;
        Fri, 07 Oct 2022 15:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t8oJ8uBoYKbakm2xp42zEcxh+wgG/wSoLfz35djbU/4=;
        b=DlXrTOSDvLfazgkLEPef9AnZOEtZ2+YrtJpz/sXI0zMUAGn+P43fOVtQw7m5zh5AJP
         J5BoGFHRMDuHCdSDabqg75/Vkr0abZMyuZ92GS1xGGM1L/bWJ3HwEJz59JtbCO3Z9cX+
         4DKOF2YepJNhP0Bup72VAgQjXUtE9bnX4WIVkiGMm2BuaFVY6GspNJCIGayp62lXnJ/k
         ZXEVqctH62gTEbk0iVdVtadkYHe/i9tKR6S/hEE+Tc1v0k+wiXt4vw6bEnPcSQ8rn9bI
         fF0W835PXI/vMaDE5zcUno1W39B+FEjaY7pyydh3stU2WqqaKacBd3KqG+CSv5Q1y/Sh
         TVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t8oJ8uBoYKbakm2xp42zEcxh+wgG/wSoLfz35djbU/4=;
        b=H1yrslxuKtm+yHmZCDZ0c8n74atKakNUISI/tRqd3eaFjTm6I7XxfIe8hlNbjCndeX
         ZF5RUXwnwcIumHgoqv4ZSVBOU6kYacrRnnd3jRmps55Jl+aywb5SnUD1NttZL5p76mSd
         K8usgNnFCOH+FlFMDyysnSlnfW15lVZ5wHrJPDVDT4WcD0AXnjZhfI0D/oWZ2znuiwEt
         wtj1cl7f4Z4sqnXcTBJOWGEOahno+RSuvpZSxpCj5ErdXnCE3Nn17tD0Y8Ec0P8ovo/8
         kEMXJfc1hXkH470R6tNhrHaWu16qcCpYvuZugffLaY7cvRRfhOI0b+3Mz/2mRWiIEJ4N
         xpmQ==
X-Gm-Message-State: ACrzQf2iYkrDgBSB/Slhzrgx3XIe5C+IqQE2e7i4FQKbLPXpZ0motVpg
        KGMxMj7KGpzFk04/KGhUFCU=
X-Google-Smtp-Source: AMsMyM7yo7t/qh9RZubKlbdW93yEvgrdgtZYdCAstPJOKqo34tY4aTvR8YCrjuTk9B3Li4qp36C9KQ==
X-Received: by 2002:a17:907:7629:b0:776:a147:8524 with SMTP id jy9-20020a170907762900b00776a1478524mr5806800ejc.632.1665182308244;
        Fri, 07 Oct 2022 15:38:28 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id s26-20020a056402165a00b00456d40f6b73sm2223299edx.87.2022.10.07.15.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 15:38:26 -0700 (PDT)
Date:   Sat, 8 Oct 2022 01:38:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Message-ID: <20221007223824.xf7aga3rs74fmcup@skbuf>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <20220927202600.hy5dr2s6j4jnmfpg@skbuf>
 <Y0CPmuxTRr799AR5@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0CPmuxTRr799AR5@euler>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 07, 2022 at 01:44:10PM -0700, Colin Foster wrote:
> With regards to the interrupts - I don't really have a concept of how
> those will work, since there isn't a processor for those lines to
> interrupt. So while there is this for the 7514:
> 
> interrupts = <18 21 16>;
> interrupt-names = "ptp_rdy", "xtr", "fdma";
> 
> it seems like there isn't anything to add there.
> 
> That is, unless there's something deeper that is going on that I don't
> fully understand yet. It wouldn't be the first time and, realistically,
> won't be the last. I'll copy the 7514 for now, as I plan to send out an
> RFC shortly with all these updates.

I was under the impression that the interrupt controller could be
configured to route the interrupts to external destinations EXT_DST0 or
EXT_DST1, which have the indices 2 and 3, respectively, in the DST_INTR_*
set of registers of the ICPU_CFG:INTR block. I could be wrong, though,
maybe this is just for PCIe, I never looked at the pinout of this chip
to study whether it's possible to use these as I expect, but normally
for things like PTP TX timestamping, you'd expect that the switch
notifies the external host when a packet has been timestamped and that
timestamp is available in the FIFO. The interrupts out of this switch
could also be useful for the PHY state machine, to disable polling.

Although in the general sense I agree with you, it's better not to add
anything than to add something and be wrong about it. This is where the
limitations start showing for the idea that "device tree describes
hardware, which is independent of software implementation". It's all too
easy to say this when you have an implementation already written.
Anyway.  DT doesn't describe hardware, but what software wants to
understand of it, and that makes it inseparable to some degree from
software implementation.
