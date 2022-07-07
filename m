Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A8256A896
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 18:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiGGQuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 12:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236023AbiGGQuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 12:50:13 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566092A422
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 09:50:12 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id u12so33415222eja.8
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 09:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Oyhk8tIY7VGBnadaucveAmlAMN+zMbqVtzp3azgS8qw=;
        b=AGPCA+0zjSmHDSc9g6fcsG673Fk0HU9pCS3mTt/JmQtJZYLVnVqMwBO/Xw+92cq5OX
         uijLnvbn9Jrdp3Z5bchkpO8oQ86E54fS5SJ6mfjiGqfeUR8SGuk3zV5ASb5EXmNret3w
         +Zo3+EheYkCT+ouprk32VTfVMWlZ5tbgP800jhl4yUdxo829n/bAbA7yNxYxqJVf4zP4
         56WklCNdUSZcYWL0AZ0vKQsxdUBywcH1LtZhpugWxM4j5VQxFQextAAFFQv5bUaCEIz3
         I4Z0fgifKbZnFiXlvSWWTprp01t7dDvWQDGQc+hxo5Z8qThjODWSDnompAwCpIatqXrF
         Ccug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Oyhk8tIY7VGBnadaucveAmlAMN+zMbqVtzp3azgS8qw=;
        b=N7oL0r4ief5XNwTBpkQtbvBU7BtLqES+J8KyKNBv3/MAxLhNTPTel/8Cqw//UmY0x4
         f6ubiYz8ojkaRRh0ZFdo26SZmzjdR11E70qafdGt2sf8GAbLyMZsrMYZO1rgJu5R+gqc
         fUIRQM1sSHbphVcG1a5jQTvlKoDEdHDO+mHdKLYcYfYoLrLr8hdeZJDxi6YI2glIhk+Y
         Ax/3C2A6pCaqi7dVT3pbPh0nzs12gmRqfo+qwzGZ15dGcVrRP/x6lsDuLKIoFG8TU7ZQ
         yoCIphAKlrADzcno4N/BDeEn/kz/vDUSI2UpcxqgyWnQEGBPzw3w8/TsjWMLbMsHxSp8
         cJiA==
X-Gm-Message-State: AJIora+9Y+7MY+rubUgv8ds9LlKARA5zB5anOgPEREi03LiarJhy1eJz
        dOh/Dq66MaghihaXNX2YgQc=
X-Google-Smtp-Source: AGRyM1sN/zswdqJ6efPyjyralPctskh3tvhtSg5OT/CB8HR+fIubQAi30GYPgQAN2QGz5Ru8BH/EvQ==
X-Received: by 2002:a17:906:84f0:b0:72b:2157:f8fe with SMTP id zp16-20020a17090684f000b0072b2157f8femr342862ejb.462.1657212610836;
        Thu, 07 Jul 2022 09:50:10 -0700 (PDT)
Received: from skbuf ([188.25.231.143])
        by smtp.gmail.com with ESMTPSA id s2-20020a170906454200b006fe9ec4ba9esm19227543ejq.52.2022.07.07.09.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 09:50:10 -0700 (PDT)
Date:   Thu, 7 Jul 2022 19:50:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH RFC net-next 5/5] net: dsa: always use phylink for CPU
 and DSA ports
Message-ID: <20220707165008.2zumavc4wrvwtcel@skbuf>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <E1o8fA7-0059aO-K8@rmk-PC.armlinux.org.uk>
 <20220706102621.hfubvn3wa6wlw735@skbuf>
 <Ysa85mJIUfo5m4dJ@shell.armlinux.org.uk>
 <20220707154303.236xaeape7isracw@skbuf>
 <YscKuTXeXFX0tCap@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YscKuTXeXFX0tCap@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,THIS_AD,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 05:32:57PM +0100, Russell King (Oracle) wrote:
> Great, so I'll mark ocelot is safe.

Yes, please.

> > As for sja1105, there is DT validation that checks for the presence of
> > all required properties in sja1105_parse_ports_node().
> 
> Looking at those, it requires all of:
> 
> - a phy mode to be specified (as determined by of_get_phy_mode())
> - a phy-handle or of_phy_is_fixed_link() to return true
> 
> otherwise it errors out.

I know. The problem with this ad-hoc validation is that it doesn't cover
the pure MLO_AN_INBAND:

	managed = "in-band-status";

so it is more restrictive than it needs to be. Also it doesn't recognize
the presence of an SFP bus in MLO_AN_PHY mode.

That is part 1 of my problem. I want to have validation that I'm
providing phylink with all the right things it may need, but I don't
want to make the driver code super clunky. By checking just the presence of
either phy-handle or fixed-link I am rejecting valid phylink configurations.
What I need is a validation function that is actually in sync with
phylink, not just ad-hoc.

> > There is some DT validation in felix_parse_ports_node() too, but it
> > doesn't check that all specifiers that phylink might use are there.
> 
> Phylink (correction, fwnode_get_phy_node() which is not part of phylink
> anymore) will look for phy-handle, phy, or phy-device. This is I don't
> see that there's any incompatibility between what the driver is doing
> and what phylink does.
> 
> If there's a fixed-link property, then sja1105_parse_ports_node() is
> happy, and so will phylink. If there's a phy-handle, the same is true.
> If there's a "phy" or "phy-device" then sja1105_parse_ports_node()
> errors out. That's completely fine.
> 
> "phy" and "phy-device" are the backwards compatibility for DT - I
> believe one of them is the ePAPR specified property that we in Linux
> have decided to only fall back on if there's not our more modern
> "phy-handle" property.
> 
> It seems We have a lot of users of "phy" in DT today, so we can't drop
> that from generic code such as phylink, but I haven't found any users
> of "phy-device".
> 
> > I'd really like to add some validation before I gain any involuntary
> > users, but all open-coded constructs I can come up with are clumsy.
> > What would you suggest, if I explicitly don't want to rely on
> > context-specific phylink interpretation of empty OF nodes, and rather
> > error out?
> 
> So I also don't see a problem - sja1105 rejects DTs that fail to
> describe a port using at least one of a phy-handle, a fixed-link, or
> a managed in-band link, and I don't think it needs to do further
> validation, certainly not for the phy describing properties that
> the kernel has chosen to deprecate for new implementations.

And this is part 2 of my problem, ocelot/felix doesn't have validation
at all except for phy-mode, because if it were to simply copy the
phy-handle/fixed-link either/or logic from sja1105, it would break some
customer boards with SFP cages. But without that validation, I am
exposing this driver to configurations I don't want it to support (CPU
ports with empty OF nodes, i.o.w. what this patch set is about).
