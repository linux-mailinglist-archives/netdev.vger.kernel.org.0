Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584D657D33A
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiGUSWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiGUSWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:22:24 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443CB18E0A;
        Thu, 21 Jul 2022 11:22:23 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id j22so4601092ejs.2;
        Thu, 21 Jul 2022 11:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=telDdakKeqGHEY5wudZ4nwhx49SVQMwMuffymH63PGo=;
        b=XO6ulZkpjNDdBb/M6u2BJKg/17Y5IC8hQ1aMS3hURuUDmP74sjHYARYI3sm2/EIw9y
         y6/zJOAWEomlFQDiZZ0oQhDwNzkNHn3KGbrxSURAzRS5S40NtxKZpzFZPtUTmub53Xk3
         YdTVVZy29+H9cdRACJG6aaojCfnXp+8pHYwdQ8twWYFhDkmARKCc6yk067SlEkPPFPk6
         6EQVPPpy1GnBLIl82R69shy7+vn2NydHcaYPoiI1fBYgnsGznylXM+CP53w1t1ydxAxm
         6RkuhJ5sB77ojJa7vpQ3l85VvWAcpVby/+wTmp6imQfVD+ytp1DmZr0SLOrgzTBTNtCk
         mn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=telDdakKeqGHEY5wudZ4nwhx49SVQMwMuffymH63PGo=;
        b=nUUNawyvLBsk+n3eyyARMfT2OsTh/MC8ob+j96ncYahXMVetfr6jzXftE7YTs9PR4F
         iaSuj86O3XvEE+IwzxJeugUqBPeJYVT4+bYjkp7RgQaHHPDwj5QiKky90XsAF0n4rzwU
         3Gr5CzUi4U+hCThO2zuq0kh7vbeYs2Y5oJPxOQfpPpsPm90ImZEYdr2OCy6v/JFW3Ocu
         iua6yOTjR7UQyW02ldm+yqEtTiAabsx4Z7KwoZE1EGx5QjdjpVw26nnfKn0ikH11qcAS
         UIpRSNJIaKN9Tu65OmnqYvc4FMozwmndWHsvXvRqudczaSpQeG+wI+GBxREXVGQVXsFo
         Vk+A==
X-Gm-Message-State: AJIora8Ag6hypLqemvUKFRqZHBaLaCq1b0Gv5lRSjR4BErU8X3mhHsR9
        ytDtI1PTvxySzbGKPinF6Bs=
X-Google-Smtp-Source: AGRyM1sJrvIzufk8Q3F7TTBGAnC3qPeej57/OshreWEcvuibGnkDJO/s88ycWFKIoC5dVGW5WRGiPQ==
X-Received: by 2002:a17:907:1b25:b0:6da:8206:fc56 with SMTP id mp37-20020a1709071b2500b006da8206fc56mr41001511ejc.81.1658427741328;
        Thu, 21 Jul 2022 11:22:21 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id t6-20020a170906608600b0072ecef772acsm1107193ejj.2.2022.07.21.11.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 11:22:20 -0700 (PDT)
Date:   Thu, 21 Jul 2022 21:22:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <20220721182216.z4vdaj4zfb6w3emo@skbuf>
References: <20220716105711.bjsh763smf6bfjy2@skbuf>
 <YtKdcxupT+INVAhR@shell.armlinux.org.uk>
 <20220716123608.chdzbvpinso546oh@skbuf>
 <YtUec3GTWTC59sky@shell.armlinux.org.uk>
 <20220720224447.ygoto4av7odsy2tj@skbuf>
 <20220721134618.axq3hmtckrumpoy6@skbuf>
 <Ytlol8ApI6O2wy99@shell.armlinux.org.uk>
 <20220721151533.3zomvnfogshk5ze3@skbuf>
 <20220721192145.1f327b2a@dellmb>
 <20220721192145.1f327b2a@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220721192145.1f327b2a@dellmb>
 <20220721192145.1f327b2a@dellmb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 07:21:45PM +0200, Marek Behún wrote:
> Marvell documentation says that 2500base-x does not implement inband
> AN.

Does Marvell documentation actually call it 2500base-x when it says it
doesn't support in-band autoneg?

> But when it was first implemented, for some reason it was thought that
> 2500base-x is just 1000base-x at 2.5x speed, and 1000base-x does
> support inband AN. Also it worked during tests for both switches and
> SOC NICs, so it was enabled.
> 
> At the time 2500base-x was not standardized. Now 2500base-x is
> stanradrized, and the standard says that 2500base-x does not support
> clause 37 AN. I guess this is because where it is used, it is intended
> to work with clause 73 AN somehow.

When you say 2500base-x is standardized, do you mean there is a document
somewhere which I could use to read more about this?

> And then came 6373X switch, which didn't support clause 37 inband AN in
> 2500base-x mode (the AN reigster returned 0xffff or something when
> 2500base-x CMODE was set). Maybe 6373X finally supports clause 73 AN
> (I don't know, but I don't think so) and that is the reason they now
> forbid clause 37 AN in HW in 2500base-x.
> 
> But the problem is that by this time there is software out there then
> expects 2500base-x to have clause 37 AN enabled. Indeed a passive SFP
> cable did not work between MOX' SFP port and CN9130-CRB's SFP port
> when used with Peridot (6190), if C37 AN was disabled on 6393x and left
> enabled on Peridot.
> 
> I managed to work out how to enable C37 AN on 6393x:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=163000dbc772c1eae9bdfe7c8fe30155db1efd74
> 
> So currently we try to enable C37 AN in 2500base-x mode, although
> the standard says that it shouldn't be there, and it shouldn't be there
> presumably because they want it to work with C73 AN.
> 
> I don't know how to solve this issue. Maybe declare a new PHY interface
> mode constant, 2500base-x-no-c37-an ?

So this is essentially what I'm asking, and you didn't necessarily fully
answer. I take it that there exist Marvell switches which enable in-band
autoneg for 2500base-x and switches which don't, and managed = "in-band-status"
has nothing to do with that decision. Right?

Is this by design of the 'managed' property, or is it an interpretation
quirk of Marvell drivers? Some other drivers enable in-band autoneg only
when manage = "in-band-status", and no one really said anything about
that during review, so I came to believe that this is the expectation.
I'm confused now, I was hoping Russell could clarify.
