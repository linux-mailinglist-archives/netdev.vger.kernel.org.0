Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B547656C499
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238089AbiGHW1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 18:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238673AbiGHW11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 18:27:27 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115F313B441
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 15:27:26 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id j22so13634626ejs.2
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 15:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WEnzUIVGWRJo6u3b5NG+JRQJLU0Y74e253c2rTK7YQ0=;
        b=Ab1sACPd2+D8L0/h8GI3KH5OiqrZ0xNKU9mkoAUZ691jROoaObYRE4XaQWDsF0AZUi
         mXt9QMdFn+ZTjT55bW2aw+KBdsmj7aIEYk5B3kugUdbWe+FPN2cpqlV2Nn7G7paYrdIo
         R1s4UQpIlLz0rdpPIrhcb24lNAR/FzBNqRl9LMm7EUSisRYEUEgJi9uh3YIxAsqrhbuM
         38NspgE1TDaA32El9cRqKSNUGOD7eremXj+7WiRnz5fUer5HBvqwLTE+zo/RbFEIsDfN
         hM7Jy3UjyLMdAi3t/dOPZN3JMAxbAUsuf95x0PH+DdGpPLFsuZ3M9D1+G9UU6mgum4Ec
         4vww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WEnzUIVGWRJo6u3b5NG+JRQJLU0Y74e253c2rTK7YQ0=;
        b=3klm+vj0UA6WYPyjEDX27TRuDD4piNDFK1wFRHPylIM1yGV/HbCFzTdcUmgbdRpl94
         FbOGrVwGHclFcBKA/C3uH7KedJLVzl+QuAGfUEGwk6VvN1BmRA0fJFGHodL6Mm34ddpg
         6n4PG8l836neuqwcwdwyL3qd+SSLLVIEryWqPvT8DG3aR2u7IibrCv/Xh0ig6bkchjWb
         82b90NBgpZAcw2khCNNpDNItAwwAnyXpFvmmLWhVlo3VJGGzMJ1ohkPT8D/9x+mB2GaT
         /YKj0Z5VQE/QPD50BSDvgDCldIueb/8XzaxtyXffrYPYgHhTHmn8BP5nnlgibDtTm7yG
         hTEg==
X-Gm-Message-State: AJIora+Cqs9hqeatR/Jwg8eHgjwoIJxhP0Ln7fsDWJoLcm2izvRd9n0T
        vwsWU7fbJ/OEWEYZ5fAfturN5YRc30hQo9OjyQlcruc1
X-Google-Smtp-Source: AGRyM1tMufSFZflhTP13TyIA/3egZfJsON2DOxdq9/6B7c4MHHHidUS+yZthiloiJ97HJ5dpIzgBhMyiQ9Fjo+9B5pc=
X-Received: by 2002:a17:906:5a67:b0:72a:f293:5b3e with SMTP id
 my39-20020a1709065a6700b0072af2935b3emr5833104ejc.290.1657319244536; Fri, 08
 Jul 2022 15:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
 <20220705173114.2004386-4-vladimir.oltean@nxp.com> <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
 <20220706164552.odxhoyupwbmgvtv3@skbuf> <CAFBinCBnYD59W3C+u_B6Y2GtLY1yS17711HAf049mstMF9_5eg@mail.gmail.com>
 <20220707223116.xc2ua4sznjhe6yqz@skbuf> <CAFBinCB74dYJOni8-vZ+hNH6Q6E4rmr5EHR_o5KQSGogJzBhFA@mail.gmail.com>
 <20220708120950.54ga22nvy3ge5lio@skbuf>
In-Reply-To: <20220708120950.54ga22nvy3ge5lio@skbuf>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 9 Jul 2022 00:27:13 +0200
Message-ID: <CAFBinCCnn-DTBYh-vBGpGBCfnsQ-kSGPM2brwpN3G4RZQKO-Ug@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Fri, Jul 8, 2022 at 2:09 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Fri, Jul 08, 2022 at 12:00:33PM +0200, Martin Blumenstingl wrote:
> > That made me look at another selftest and indeed: most of the
> > local_termination.sh tests are passing (albeit after having to make
> > some changes to the selftest scripts, I'll provide patches for these
> > soon)
> >
> > None (zero) of the tests from bridge_vlan_unaware.sh and only a single
> > test from bridge_vlan_aware.sh ("Externally learned FDB entry - ageing
> > & roaming") are passing for me on GSWIP.
> > Also most of the ethtool.sh tests are failing (ping always reports
> > "Destination Host Unreachable").
>
> I don't recall having run ethtool.sh, so I don't know what's the status
> there.
OK, no worries there

> > I guess most (or at least more) of these are supposed to pass? Do you
> > want me to open another thread for this or is it fine to reply here?
>
> So yes, the intention is for the selftests to pass, but I wouldn't be
> surprised if they don't. They didn't when I started this effort for the
> ocelot/felix DSA driver either, it's most likely that individual drivers
> will need changes, that's kind of the whole point of having selftests,
> to have implementations that are uniform in terms of behavior.
> For the ocelot driver, the tests symlinked in the DSA folder do pass
> (with the exception of the locked port test, which isn't implemented,
> and the bridge local_termination.sh tests, but that's a bridge problem
> and not a driver problem). I should have a remote setup and I should be
> able to repeat some tests if necessary.
>
> I think it would be a good idea to create a new email thread with the
> relevant DSA maintainers for selftest status on GSWIP. You'll need to
> gather some information on what exactly fails when things fail.
> The way I prefer to do this is to run the test itself with "bash -x
> ./bridge_vlan_unaware.sh swp0 swp1 swp2 swp3", analyze a bit where
> things get stuck, then edit the script, put a "bash" command after the
> failing portion, and run the selftest again; this gives me a subshell
> with all the VRFs configured from which I have more control and can
> re-run the commands that just failed (I copy them from right above,
> they're visible when run with bash -x). Then I try to manually check
> counters, tcpdump, things like that.
I already found "bash -x" and used a similar trick (launching tcpdump
before the failing portion). But it's good to have it written down!
Thanks a lot again for all your detailed explanations and the time
you've taken to help me out!
I'll start a new thread on this in the next few days.


Best regards,
Martin
