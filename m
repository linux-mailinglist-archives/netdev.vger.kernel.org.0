Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D534131ADE7
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhBMUNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 15:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhBMUNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 15:13:38 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F896C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:12:58 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g3so1363721edb.11
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HqyS1vjbYxE292S10kUbQPKMVFDUT/05Rtbkci5bi8w=;
        b=jBse+Fn3PUDwTujZBrmdAVYr5hzSne5Y0fnUBXW2HrPiAylWwiqmjzK/Pe9Yz4+EBS
         stquyOzd+GRvDDkUH2kY+Gp5BlXZkI+01eZWSwy5/Rhh1g0iMTJ89D2JLOEQzV5g2Ml0
         RrTG7FQD9TcNwGVNBVVah8a/1HyG7+ASWdQ8+AAzdhmeUJkkCKHDE2ClbQxv3ptUf+3w
         lhMLGiImtYefWxq6e4aHBISUyZn6b2ulKLhP2Qio0hfmigyTxZm1k4dWM/jvs0+aVd7W
         jOyUTyrvUsGPkjj+lE9uzJQhHhiX/8d7zu4SxSYwxwqub+lAuZbqCoH4cigkXBDg1DQe
         4seQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HqyS1vjbYxE292S10kUbQPKMVFDUT/05Rtbkci5bi8w=;
        b=d01nN2t9GaWI8RHSRfXZ0DlQYvkMO2QrF3HXWz6jMm/VsdSNQQbjc549Z+RhiWYqDl
         pzE0jH543U6YyEBCw3i6R+FgsfYh2l4VFtu+SI1ZqfIjkltCf2Ezt0sIO+Pz8IgKMqtS
         VbjlVXBQpu5F7mLfvH7qRwWmWWKMqrQSWq9lJ+CyZ34JL/tdrAHqvM4IpCa5Kk1RaZ4n
         DkHqTFeQPMoG6ySwiaNGdfEL0eJwpqaqaCZMBKetJE8DRdFPU3BdYuP/Q0Mkkn2Iu+I2
         9vHO/QBZL3rGbAwYED3bSk7+Uus854iF4oOzFQtOY8VjAA9de5oM5NCDhHTX+d/Rjs51
         Un0Q==
X-Gm-Message-State: AOAM531oEX1AgTa0iLxDw3bKZ0s/CCCFe/Bz+uFALaFb+FC0+F95H9W8
        Rj5wjFq2JRFBC9hx8TaukCE=
X-Google-Smtp-Source: ABdhPJzZZUFlcwWojk7lkp3D/7/F+vZLBnbOpJ2NE4Tuz4uVPDg9dek514MNLMfV5rXPYAO5R7pOow==
X-Received: by 2002:aa7:c396:: with SMTP id k22mr8990993edq.284.1613247177164;
        Sat, 13 Feb 2021 12:12:57 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x21sm8052482eje.118.2021.02.13.12.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 12:12:56 -0800 (PST)
Date:   Sat, 13 Feb 2021 22:12:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
Message-ID: <20210213201255.ygjn7rexook2ngqe@skbuf>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
 <eb7b911f4fe008e1412058f219623ee2@walle.cc>
 <20210213003641.gybb6gstjpkcwr6z@skbuf>
 <46c9b91b8f99605a26fbd7f26d5947b6@walle.cc>
 <1d90da5ef82f27942c7f5a5d844fc29a@walle.cc>
 <20210213185620.3lij467kne6cm4gk@skbuf>
 <4b3f06686cb58dcdda582bfdbd0abb85@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b3f06686cb58dcdda582bfdbd0abb85@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 08:57:46PM +0100, Michael Walle wrote:
> > On the other hand, I never meant for the inband autoneg setting to only
> > be configurable both ways.
>
> Then why is there a "bool enabled"?

Let me stress the word _only_ both ways. The whole point of the "bool
enabled" is to attempt coordination with the 'managed = "in-band-status"'
property device tree property of the MAC, or to error out if it is not
possible.

> > I expect some PHYs are not able to operate
> > using noinband mode, and for those I guess you should simply return
> > -EINVAL, allowing the system designer to know that the configuration
> > will not work and why.
>
> You mean like this:
>
> static int at803x_config_inband_aneg(struct phy_device *phydev, bool
> enabled)
> {
> 	if (!enabled)
> 		return -EINVAL;
> 	/* enable SGMII autoneg */
> 	return phy_write_paged(...);
> }
>
> But then why bother with config_inband_aneg() at all and just enable
> it unconditionally in config_init(). [and maybe keep the return -EINVAL].

Because .config_init() is generic code, while .config_inband_autoneg()
is phylink-specific. Generally I don't want to make any assumption about
the state in which a PHY driver used to operate prior to this series.
If you are sure that at803x.c user relies on a prior bootloader stage
having disabled in-band AN, then sure, I suppose you can enable it
unconditionally in .config_init().

For VSC8514 I put the configuration deliberately in a phylink-specific
callback since I trust that at least the MAC-side drivers were reviewed
for proper use of MLO_AN_PHY vs MLO_AN_INBAND.

> Which then begs the question, does it makes sense on (Q)SGMII links at
> all?

See above. In the general case we need to assume a wild world where the
same PHY driver operates as inband on some platforms and noinband on
others (and most importantly, it works on both, which we'd like to
preserve at least). I would be glad if we didn't need to make that
assumption though.
