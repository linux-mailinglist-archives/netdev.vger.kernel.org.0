Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552EA552F37
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 11:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiFUJ4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 05:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiFUJ4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 05:56:19 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF46C27CE9
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:56:17 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id c4so21421983lfj.12
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+UauFON3Z5k4erj1lJhxb4xMRY3aeE01J2NPDi4cPiE=;
        b=FmNU07MSwd8ek+qnq+c1HaZujdUoSsVhCvencgloomp2smg94X2O7E9yd1MfePj7u1
         s5eggE5sF6BUJKWK7G36SCnzKPgFjxv08NzUItZHIP9TmA0mMp183VisI9k/pD20WQCS
         nUnAKfO7vdTkq5EvAMGv1ez7HMsiXmAkXdwtsGGlDLS9YdHD98i3/hnYGzA+UbQqoRzZ
         4t9A5NTPuV35XFoY2Jop+vrvQpXJmJjX+DT0UB01jSp3c7E/eTdqYVsdGpc9zmH34/u4
         vKbktlJUCjGUQ3vmLvzNCgiat/Yrn2Qw5G/i0JVmXWMuiNICttCpxgPb53FSwW2HSOBl
         7g1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+UauFON3Z5k4erj1lJhxb4xMRY3aeE01J2NPDi4cPiE=;
        b=C+ZGzoE7Y+5/FjPmdRF0gs/VwzPQkFXFCBuYEsVLRwmhEwyM1GVOgGBw4LChRLug9b
         KKHExx4q2l/X7C0DO6KECdLr1TzY4psJ+BLOAhbsmKR09sUPkSIgdzxBpi3A34sjMNuK
         P5y0YFnvTwDWhr22cjgd03j8iPxOybA0t/TbkZwpe4xDWN4Q1sXCdN5ud4K/boOzbd+B
         Y4uqHNDyzoZ+eqt2cOCfGVC1w6zkzfDmLM0SlzhIGVpDoHfntg7HIc9RDmRFJNhcol0Y
         N7OoUgHOV38op5cXpcmtdUDhVHprPPKdUYp9gtUGrXqz8QNBYGNrtDbwfjS366on70FM
         p//Q==
X-Gm-Message-State: AJIora9WnAjOz/0jZFxjHIioeZWpwCVC19Gq/fyZBVtY4se6QNiXjCxu
        WNF9TeZsIL7NJZknPC/EjQdC84QEgSsbQFNOM7YkZg==
X-Google-Smtp-Source: AGRyM1vE6WbXLd9KAOeEIAD5vck9Crd9lsdZBLhmd4rzhe3mbEvRfXLywJ8rOiJRSr8/hHK3nCi5rIQ7bY2hjkHVh70=
X-Received: by 2002:a05:6512:118f:b0:47f:6a1a:20d4 with SMTP id
 g15-20020a056512118f00b0047f6a1a20d4mr7179853lfr.428.1655805376108; Tue, 21
 Jun 2022 02:56:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220620150225.1307946-1-mw@semihalf.com> <20220620150225.1307946-2-mw@semihalf.com>
 <YrC1gEf4HpRp5zkh@lunn.ch>
In-Reply-To: <YrC1gEf4HpRp5zkh@lunn.ch>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 21 Jun 2022 11:56:06 +0200
Message-ID: <CAPv3WKe3vBJ9r=6tMEtPj-3c0E3MBpW4Csf8zjS0jG03C35ycg@mail.gmail.com>
Subject: Re: [net-next: PATCH 01/12] net: phy: fixed_phy: switch to fwnode_ API
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <lenb@kernel.org>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pon., 20 cze 2022 o 19:59 Andrew Lunn <andrew@lunn.ch> napisa=C5=82(a):
>
> On Mon, Jun 20, 2022 at 05:02:14PM +0200, Marcin Wojtas wrote:
> > This patch allows to use fixed_phy driver and its helper
> > functions without Device Tree dependency, by swtiching from
> > of_ to fwnode_ API.
>
> Do you actually need this? phylink does not use this code, it has its
> own fixed link implementation. And that implementation is not limited
> to 1G.
>

Yes, phylink has its own fixed-link handling, however the
net/dsa/port.c relies on fixed_phy helpers these are not 1:1
equivalents. I assumed this migration (fixed_phy -> phylink) is not
straightforward and IMO should be handled separately. Do you recall
justification for not using phylink in this part of net/dsa/*?

Thanks,
Marcin
