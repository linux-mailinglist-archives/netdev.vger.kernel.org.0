Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02DA585634
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 22:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239238AbiG2Ugd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 16:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiG2Ugb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 16:36:31 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A960E6553
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 13:36:30 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-10e4449327aso7177687fac.4
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 13:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jcwm6P6FE3NVGgZFlvOsX6bnks6L/BDxDHOT1jE4ESs=;
        b=Rg7ZA4gM+vjUQ4KzdUOTxKnkDoR4/vJZX+6fF3CSiIyS7jFC6jch9klyE0aZeys6B7
         WkZZbxq+vj8GGp/Mejz3zJ360bMfDDRwm5ZNtJqiXjt90uH5gq6ZA6E/DLzv7C2N4U+w
         elfXTVsNH91rM9ZNmd9TO/mDZfMlQ3ltFcCjC2bFjo+2PrxZUOSTVURbAEyS5lMsDE/h
         SNphzFWAGOiOkd06S11in1rVXORikWJtSib4Bw6XDN2qKkI4Du+YRqNRettyXcWyGoWy
         b4b1xo6637eJGTcSew+hxvInDDk1kWmWduxjFCdYSKqZ9Hq02eUA3rYm8Flnrue2zqxN
         6MNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jcwm6P6FE3NVGgZFlvOsX6bnks6L/BDxDHOT1jE4ESs=;
        b=0LZvSEajCoIGp0hWsAKF4LCY9P9ebcdU3mCfkbgF66+tMMkDjq//N/KAI1BoOGawzl
         So/QyiocA6oRVbOs60sQfw+sEHQ1ucwup0YmtkXqXP2FOJEHyZmyltL9hcx0fZPLcxr+
         nZGPteM99UHAWPrkUvq+dRDLndp5MP2Esp4m6DU7oyF5HcHNrJp8EAPrypDsbuN0849m
         9Y6K9On99IF2nzGN+YkDueXLccf8veki1PO3YeaWkICHB+MOKNWtKYXA+XIaoGGFaFXd
         e5nD+8a1LcJberiixRo4zyL0mW1eyXZMU8t6bCkS4VGYbNJYsiOjNeGyxTQ3bGx0s+Qt
         B5ig==
X-Gm-Message-State: AJIora9mp1R7d01To58/5faqAJ29ih7W8KMSZtr/DnlXHIk7IZEQicpg
        7+T9yl/rbML5NmxP6a0cD3hbjcGK/HZt9kMZ6HbeTQ==
X-Google-Smtp-Source: AGRyM1sV/pgIeiJ84RelOK4xonpPVRnMAgTVZpFFXbo107kVfYFNNAZ6dE1i9ExudV0tp8c/qeNUT91xaXG1a3qPKg4=
X-Received: by 2002:a05:6870:a182:b0:10b:efbe:e65d with SMTP id
 a2-20020a056870a18200b0010befbee65dmr2963206oaf.5.1659126989943; Fri, 29 Jul
 2022 13:36:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
 <20220729132119.1191227-5-vladimir.oltean@nxp.com> <CAPv3WKe7BVS3cjPws69Zi=XqBE3UkgQM1yLKJgmphiQO_n8Jgw@mail.gmail.com>
 <20220729183444.jzr3eoj6xdumezwu@skbuf>
In-Reply-To: <20220729183444.jzr3eoj6xdumezwu@skbuf>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 29 Jul 2022 22:36:17 +0200
Message-ID: <CAPv3WKfLc_3D+BQg0Mhp9t8kHzpfYo1SKZkSDHYBLEoRbTqpmw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pt., 29 lip 2022 o 20:34 Vladimir Oltean <vladimir.oltean@nxp.com> napisa=
=C5=82(a):
>
> On Fri, Jul 29, 2022 at 07:57:50PM +0200, Marcin Wojtas wrote:
> > I'm ok with enforcing the phylink usage and updating the binding
> > description, so the CPU / DSA ports have a proper full description of
> > the link. What I find problematic is including the drivers' related
> > ifdefs and compat strings in the subsystem's generic code. With this
> > change, if someone adds a new driver (or extends the existing ones),
> > they will have to add the string in the driver AND net/dsa...
>
> I chuckled when I read this. You must have missed:
>
>  * If you are considering expanding this table for newly introduced switc=
hes,
>  * think again. It is OK to remove switches from this table if there aren=
't DT
>  * blobs in circulation which rely on defaulting the shared ports.
>
> The #ifdef's are there such that the compatible array is smaller on a
> kernel when those drivers are compiled out.
>
> > How about the following scenario:
> > - Remove allow/blocklist from this patch and validate the description
> > always (no opt out).
>
> We're validating the description always. We're opting a fixed number of
> switches out of _enforcing_ it, number which will not increase.
> That's why the people here are copied, to state if they're ok with being
> in one camp or the other.
>
> > For an agreed timeframe (1 year? 2 LTS releases?)
> > it wouldn't cause the switch probe to fail, but instead of
> > dev_warn/dev_err, there should be a big fat WARN_ON(). Spoiled bootlog
> > will encourage users to update the device trees.
>
> The intention is _not_ to fail probing for drivers with incomplete
> bindings, neither now nor after 1 year or 2 LTS releases.
>
> The intention is to not allow drivers which didn't have any such DT
> blobs, or awareness of the feature, to gain any parasitic users.
> The DSA core currently allows it. If planets align just the right way,
> those ports might even work by accident, until they don't.

What I propose is to enforce more strictly an update of DT description
with a specified timeline, abandoning 'camps' idea and driver-specific
contents in the generic code.

>
> > - After the deadline, the switch probe should start failing with
> > improper description and everyone will have to use phylink.
>
> Not applicable after the explanation above, I think. At least, it's not
> my goal to fail drivers. If individual maintainers want to do so,
> they're free to do it from my side.

Ok, that makes sense. The WARN_ON, however, can be annoying enough, so
to more efficiently enforce DT updates. If this change is eventually
scheduled for v5.21, there will be plenty of time for DT overhaul.

>
> > - Announce the binding change and start updating DT binding
> > description schema (adding the validation on that level too).
> > ?
>
> The announcement is here, what else are you thinking of?

Some open source projects have a nice practice of sending additional
'heads-up' information to the lists, that are related to the more
significant changes affecting a lot of users, modifying generic
behavior of the OS, implicating future need for a firmware update,
etc. For instance, v2 which is still under review on the edge of v5.19
and v5.20-rc1 could be easy to miss. In case of a more strict
approach, that could be helpful for raising awareness after the patch
lands.
