Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F79585510
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235560AbiG2SjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 14:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiG2SjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 14:39:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF2065678
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 11:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CDF561EE2
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 18:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD6AC433D6
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 18:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659119958;
        bh=4iG2zVjGWLIKdrNpJKIztbthm6Ncj/fx/iaUWxAj+6o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ao5kqv/FArRRJzZW2UYaH7ixqioXwUEG+/H5xFWPz2jT/vJYRIM37/Ny4s9isRTzT
         +nWuiwvgCBqZLoAi43c9M03LO/6+HeBNQ8RBCUWOpsXo34Qx0/4/0mgWssCWSP/CRp
         UD70/5Apgj0i+dDW86Z0IQMNgEZE6U+jaGFPrzzAxzwjS7gHnHCEMxzvoD8Li/VkjJ
         PRlZmcZeHYwUXag7NHQdL5UZpN0Oc+EavERk+KC1HJH/Yr85PnzJTPS26tkmpgjcTp
         QNV/rPQBsL/HkfKCrCCqQbi2Rt8D9peb1jT75Fc1ZFqhXFbacBBvBrmF0ryE87r2T9
         vyu6jBo0On6yA==
Received: by mail-ua1-f48.google.com with SMTP id l7so2176964ual.9
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 11:39:18 -0700 (PDT)
X-Gm-Message-State: ACgBeo3lZks+pOHUfvLShkYQSAhjpuOD/bjAnwPwiREfPyZVSihrfHXU
        x8pgggRoyEMQQewsEYLa1qVJF2mwCgF7aWSndA==
X-Google-Smtp-Source: AA6agR4EqzfFsVzI4zQL8C4OD2tEuTWokOqeqavaenC25/aa0A2rX04tjjkpXUaYcPn6NB7H7hMXvtyXXkV34sQ2WaU=
X-Received: by 2002:a05:6130:291:b0:383:3b9:7024 with SMTP id
 q17-20020a056130029100b0038303b97024mr2183274uac.43.1659119957649; Fri, 29
 Jul 2022 11:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
 <20220729132119.1191227-5-vladimir.oltean@nxp.com> <CAL_JsqJJBDC9_RbJwUSs5Q-OjWJDSA=8GTXyfZ4LdYijB-AqqA@mail.gmail.com>
 <20220729170107.h4ariyl5rvhcrhq3@skbuf>
In-Reply-To: <20220729170107.h4ariyl5rvhcrhq3@skbuf>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 29 Jul 2022 12:39:06 -0600
X-Gmail-Original-Message-ID: <CAL_JsqL7AcAbtqwjYmhbtwZBXyRNsquuM8LqEFGYgha-xpuE+Q@mail.gmail.com>
Message-ID: <CAL_JsqL7AcAbtqwjYmhbtwZBXyRNsquuM8LqEFGYgha-xpuE+Q@mail.gmail.com>
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
        Marcin Wojtas <mw@semihalf.com>,
        Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 11:01 AM Vladimir Oltean
<vladimir.oltean@nxp.com> wrote:
>
> On Fri, Jul 29, 2022 at 10:22:49AM -0600, Rob Herring wrote:
> > It's not the kernel's job to validate the DT. If it was, it does a
> > horrible job.
>
> I'm surprised by you saying this.

I've said it many times...

> The situation is as follows: phylink parses the fwnode it's given, and
> errors out if it can't find everything it needs. See phylink_parse_mode()
> and phylink_parse_fixedlink(). This is a matter of fact - if you start
> parsing stuff, you'll eventually need to treat the case where what
> you're searching for isn't there, or isn't realistic.
>
> DSA is a common framework used by multiple drivers, and it wasn't always
> integrated with phylink. The DT nodes of some ports will lack what
> phylink needs, but these ports don't really need phylink to work, it's
> optional, they work without it too. However if we begin the process of
> registering them with phylink and we let phylink fail, this process is
> irreversible and the ports don't work anymore.
>
> So what DSA currently does (even before this patch set) is it
> pre-validates that phylink has what it needs, and skips phylink if it
> doesn't. It's only that it doesn't name it this way, and it doesn't
> print anything.
>
> Being a common framework, new drivers opt into this behavior willy-nilly.
> I am adding a table of compatible strings of old drivers where the
> behavior is retained. For new drivers, we fail them in DSA rather than
> in phylink, this is true. Maybe this is what you disagree with?

No, I haven't looked at it that closely.

> We do this as a matter of practicality - we already need to predetermine
> whether phylink has a chance of working, and if we find something missing,
> we know it won't. Seems illogical to let phylink go through the same
> parsing again.
>
> As for the lousy job, I can't contradict you...
>
> > Is the schema providing this validation? If not, you need to add it.
>
> No, it's not. I can also look into providing a patch that statically
> validates this. But I'm afraid, with all due respect, that not many
> people take the YAML validator too seriously? With the volume of output
> it even throws, it would be even hard to detect something new, you'd
> need to know to search for it. Most of the DSA drivers aren't even
> converted to YAML, and it is precisely the biggest offenders that
> aren't. And even if the schema says a property is required but the code
> begs to differ, and a future DT blob gets to enter production based on
> undocumented behavior, who's right?

All valid points. At least for the sea of warnings, you can limit
checking to only a subset of schemas you care about. Setting
'DT_SCHEMA_FILES=net/' will only check networking schemas for example.
Just need folks to care about those subsets.

I'm not saying don't put warnings in the kernel for this. Just don't
make it the only source of warnings. Given you are tightening the
requirements, it makes sense to have a warning. If it was something
entirely new, then I'd be more inclined to say only the schema should
check.

Rob
