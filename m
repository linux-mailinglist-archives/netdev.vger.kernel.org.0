Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5601557D619
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 23:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbiGUVgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 17:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbiGUVgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 17:36:51 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921E49361D;
        Thu, 21 Jul 2022 14:36:50 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id m16so3734541edb.11;
        Thu, 21 Jul 2022 14:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dM5Ipf0pW1sHVngWhRmQL54mzB8rAPcDkpMU7YZORbY=;
        b=YKlJAtoD5oh1nsR0YPD1gVhOOVqZwjfJsbU0n9t/2F31hZclspGY6Q32l6wCZkocOk
         J/OpNHXVKk+fIKTwr2bqIgEqJ5VvKzjUC+MZ6OmmRke3gGX0eZQY2McRWxovhGwGwGVd
         lv1Qj5j4cvOTCmYteGyvhdubnCMPLEaWzWk/jfGRGjvwqsoAkV4wUoULICAdAKKPU+3z
         MMhYK72GQfqua/zlYpiAJz0Ve9VfpeAurr7E1opw5HoRfuGGYs7/fa0TSsqQL7cWzlxO
         t9Fki9V1GWMct3KOIQdamrCsvOHL9cmMpmxtE108K5lma4eGcVCvuERxCNLMYmb9Y6bG
         0rTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dM5Ipf0pW1sHVngWhRmQL54mzB8rAPcDkpMU7YZORbY=;
        b=6yc6lWn6GEbF+vkBjxVrHM5+W1m92GFJGLWdA2TgMlVBCf7aGVTs9UJlFRh/5MNsev
         S0FmbWaA+zmvthR8X40VfqMbs98ijt5KFv3jHpkpV07tRACEW1NTkOTscCHAM047hdxl
         7ePV2XMhF0RJl9gbqu/Ez6AKTf541mo/+6Hb+wWTPzZ8RdGlDpqC4vNTWZMQ8fcRSDz9
         W6j9sR5DN5Ubaul6fzBwAg5d84qXFtr5iseUnCzM/+beIKDVAx4qLukzysB56LBJgYCD
         XeYXDOON2bN6K5WaDdNhQ8e0JaY7Dv2LGfHf9Vz5HdK1Sbhya6BV7ptW3iq7rMbI5flR
         arvQ==
X-Gm-Message-State: AJIora9gjB+Ea1HJpifz1+7mzSBDN/hLcerA6MrGYsEh04r8cgwMsxa5
        PHLXyYm3BDDcEqhpHoFMuEA=
X-Google-Smtp-Source: AGRyM1sxaAiodhN6poRONOUpx0euQaN7KbvX4J+AQGA8IzCf1dbLoXzyqULJnieH2nqRe23rhJf9TQ==
X-Received: by 2002:a05:6402:4442:b0:43b:c866:21be with SMTP id o2-20020a056402444200b0043bc86621bemr432882edb.28.1658439409047;
        Thu, 21 Jul 2022 14:36:49 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id b21-20020a17090630d500b0072aa1313f5csm1219613ejb.201.2022.07.21.14.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 14:36:48 -0700 (PDT)
Date:   Fri, 22 Jul 2022 00:36:45 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
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
Message-ID: <20220721213645.57ne2jf7f6try4ec@skbuf>
References: <20220716123608.chdzbvpinso546oh@skbuf>
 <YtUec3GTWTC59sky@shell.armlinux.org.uk>
 <20220720224447.ygoto4av7odsy2tj@skbuf>
 <20220721134618.axq3hmtckrumpoy6@skbuf>
 <Ytlol8ApI6O2wy99@shell.armlinux.org.uk>
 <20220721151533.3zomvnfogshk5ze3@skbuf>
 <20220721192145.1f327b2a@dellmb>
 <20220721192145.1f327b2a@dellmb>
 <20220721182216.z4vdaj4zfb6w3emo@skbuf>
 <YtnBmFm8Jhokgp7Q@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtnBmFm8Jhokgp7Q@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 10:14:00PM +0100, Russell King (Oracle) wrote:
> > > So currently we try to enable C37 AN in 2500base-x mode, although
> > > the standard says that it shouldn't be there, and it shouldn't be there
> > > presumably because they want it to work with C73 AN.
> > > 
> > > I don't know how to solve this issue. Maybe declare a new PHY interface
> > > mode constant, 2500base-x-no-c37-an ?
> > 
> > So this is essentially what I'm asking, and you didn't necessarily fully
> > answer. I take it that there exist Marvell switches which enable in-band
> > autoneg for 2500base-x and switches which don't, and managed = "in-band-status"
> > has nothing to do with that decision. Right?
> 
> I think we're getting a little too het up over this.

No, I think it's relevant to this patch set.

> We have 1000base-X where, when we're not using in-band-status, we don't
> use autoneg (some drivers that weren't caught in review annoyingly do
> still use autoneg, but they shouldn't). We ignore the ethtool autoneg
> bit.
> 
> We also have 1000base-X where we're using in-band-status, and we then
> respect the ethtool autoneg bit.
> 
> So, wouldn't it be logical if 2500base-X were implemented the same way,
> and on setups where 2500base-X does not support clause 37 AN, we
> clear the ethtool autoneg bit? If we have 2500base-X being used as the
> media link, surely this is the right behaviour?

The ethtool autoneg bit is only relevant when the PCS is the last thing
before the medium. But if the SERDES protocol connects the MAC to the PHY,
or the MAC to another MAC (such as the case here, CPU or DSA ports),
there won't be any ethtool bit to take into consideration, and that's
where my question is. Is there any expected correlation between enabling
in-band autoneg and the presence or absence of managed = "in-band-status"?

> (This has implications for the rate adaption case, since the 2500base-X
> link is not the media, and therefore the state of the autoneg bit
> shouldn't apply to the 2500base-X link.)

This is closer to what I was interested in knowing, but still not that.
