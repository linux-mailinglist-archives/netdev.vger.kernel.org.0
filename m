Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAA663B67F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbiK2AU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234781AbiK2AU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:20:56 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247A731EF6
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 16:20:55 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id t11-20020a17090a024b00b0021932afece4so4800291pje.5
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 16:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V57uSH08PE25Wlk/c9BqDLzezSRu5me2pfIVdTCTkjo=;
        b=D+q65hKGOvqVhsHWElVacfBJqkewFRwiZlCYL8dHK3aSw5hsmyl6gdmXYyOLzLA7NP
         733rRyNp2nxO0dg9OJeTkJlreUeJNkkbrzHNUoUi+Xod1Eiao4uQpgqOgup8ZnhJMInG
         Ahiz5yXLH1Xw0C9kZpGrdjyi3ImzROsej0IAOw1mR7HpNPABsMVJizvjy2V8wu1H53Ay
         AMqtjJpNsySlkUt/1X3mrFRn0+sKg5I3upsiFgoHk1o5f5eBcs496YKvAEjY98vWHi5f
         JT8axftRuPlPQZQH2mwKcq+5uFkD/QuJb9V6JiprfjtWCne/F/KJ0/zjaPXVgI6cE8MD
         //0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V57uSH08PE25Wlk/c9BqDLzezSRu5me2pfIVdTCTkjo=;
        b=WXrY3obe2riiZthtg4M7YppaYj1ncJtYAufebb1hoOIh6qotYTNCXTtMS8Dm9es+5g
         nU1DETY0a80yFdadBLR1CIiqur585Tgd+WYprsmHJ+ZYhRf7iWsJh3tlTtPi8Q29+yZa
         3EyKd1afn5/j81fCRqUs0cvSVU1KCeTr5HkenTkMHfdEDrKcEC8aCj1jAdl2HnUAdS/f
         hdLsG/mRgGX9p3vrlNRUlycO8xsQkHDNI4WmOesUgZ9cpY+06S79/qGNqnfpwnAMKwLl
         eUgEGQXi8ZOS1u615gNTQ4RYSCLYgQ/WHnx4FU7nKxMSCss2eiuMsBq0Ma6pnMRHyRz5
         NCdw==
X-Gm-Message-State: ANoB5pmhba9OiEYP7W04IDb/jJAqNnELz0ixLTTmHm6sdRKNMxy1uA50
        VaX4ySPt+Q4Ofvg9B9XRgCZO/im9E+0VKMvA4FG7jg==
X-Google-Smtp-Source: AA0mqf59j2i1wiIGpVCyi0oFg8zlitbjzQg67fFYRUOZyJWEI9t6k/xeK14j1fHIBWVDHLc/vPiKYhsMfkGA85iwTV0=
X-Received: by 2002:a17:90b:1095:b0:219:237c:7986 with SMTP id
 gj21-20020a17090b109500b00219237c7986mr12292720pjb.220.1669681254627; Mon, 28
 Nov 2022 16:20:54 -0800 (PST)
MIME-Version: 1.0
References: <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221115223732.ctvzjbpeaxulnm5l@skbuf> <3771f5be-3deb-06f9-d0a0-c3139d098bf0@seco.com>
 <20221115230207.2e77pifwruzkexbr@skbuf> <219dc20d-fd2b-16cc-8b96-efdec5f783c9@seco.com>
 <Y3bLlUk1wxzAqKmj@lunn.ch>
In-Reply-To: <Y3bLlUk1wxzAqKmj@lunn.ch>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Mon, 28 Nov 2022 16:20:42 -0800
Message-ID: <CAJ+vNU1iDuFRbm-9+hzEgqZ=enL2yTkDJq6=7EtsQu3KFAxjDQ@mail.gmail.com>
Subject: Re: [PATCH] phy: aquantia: Configure SERDES mode by default
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 4:03 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Well, part of my goal in sending out this patch is to get some feedback
> > on the right thing to do here. As I see it, there are three ways of
> > configuring this phy:
> >
> > - Always rate adapt to whatever the initial phy interface mode is
> > - Switch phy interfaces depending on the link speed
> > - Do whatever the firmware sets up
>
> My understanding of the aQuantia firmware is that it is split into two
> parts. The first is the actual firmware that runs on the PHY. The
> second is provisioning, which seems to be a bunch of instructions to
> put value X in register Y. It seems like aQuantia, now Marvell, give
> different provisioning to different customers.
>
> What this means is, you cannot really trust any register contains what
> you want, that your devices does the same as somebody elses' device in
> its reset state.
>
> So i would say, "Do whatever the firmware sets up" is the worst
> choice. Assume nothing, set every register which is important to the
> correct value.
>
>         Andrew

Andrew,

Sorry for the late reply!

That's exactly what the firmware is doing. According to a Marvell FAE
they add 'provisioning' of registers to the firmware to ease their
support effort. That didn't at all ease things for me because I was
pointed to the wrong firmware by another FAE which led to all of this.

In my case my device-tree is setting the interface to xfi (10g) yet
the firmware has provisioned the link for xfi/2 (5g) - a warning would
have probably helped us all understand the issue but again I was just
pointed to the wrong firmware without an explanation of how their
firmware works.

Tim
