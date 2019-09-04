Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0C0A8881
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbfIDOLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:11:15 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:46894 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729877AbfIDOLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 10:11:15 -0400
Received: by mail-yb1-f193.google.com with SMTP id y194so7322951ybe.13;
        Wed, 04 Sep 2019 07:11:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ndiu1qeyYiTsgd1IQKxLqytq07+6AvPDInzgXch1dx0=;
        b=jG6sUMeGvrOa7y8hDzJRpMlJ0GH5PIveC8dv0iHURRSK7qWEeeJPOvWub6Yb+Jceb4
         3fl9eRUIgX4OmqmA9ZqXB2SD0DZ/VghK/AkfF+qnFWyo0aSV/a7CEEN+meI1QaMS3GPo
         T380Rtm5WLulWZ2fOV4udEFBaXG+uucMpf8FfN5euqnj2tEtVJLu5PzMls14PzlmOaEa
         6m3LpvG0I2AKf6NgW90jqW1uqXhHhctz9bWKtcOejWqR6CzHwO2IG0hs34RjSJHFUvxE
         m0YkNCoLdNK1gvQfnVg8ojDgIxgYYe6iquTDxySWhvFT3J8jMeEcDI6csZ4no1WNj6t8
         ZuRQ==
X-Gm-Message-State: APjAAAXAN5qGSvYNGANXbLIfHnq6sRQT0lG1Es4zOHObJzN6AdprPl49
        avCDZF8YfSZYg8py1BvTd8s56Qksnl7Lph/jFuc=
X-Google-Smtp-Source: APXvYqyhk8FpqdMml/U3tSJdYtK/Y+iACvELqeYDdxkjKbPkgsnecJqn3l9d6E1wpGWwXqCgqS5anjOZuA/G8EqrUKg=
X-Received: by 2002:a5b:981:: with SMTP id c1mr27761719ybq.14.1567606274841;
 Wed, 04 Sep 2019 07:11:14 -0700 (PDT)
MIME-Version: 1.0
References: <1564565779-29537-1-git-send-email-harini.katakam@xilinx.com>
 <1564565779-29537-3-git-send-email-harini.katakam@xilinx.com>
 <20190801040648.GJ2713@lunn.ch> <CAFcVEC+DyVhLzbMdSDsadivbnZJxSEg-0kUF5_Q+mtSbBnmhSA@mail.gmail.com>
 <20190813132321.GF15047@lunn.ch> <CAFcVECKipjD9atgEJSf8j78q_1aOAX77nD6vVeytZ-M00qBt6A@mail.gmail.com>
 <20190813153820.GY14290@lunn.ch>
In-Reply-To: <20190813153820.GY14290@lunn.ch>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Wed, 4 Sep 2019 19:41:03 +0530
Message-ID: <CAFcVECLucW=OXRnr1vVws2fswp0zHxBnMT-3JC2AOPXCLhDL1g@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: gmii2rgmii: Switch priv field in mdio device structure
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        radhey.shyam.pandey@xilinx.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, Aug 13, 2019 at 9:40 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > The kernel does have a few helper, spi_get_drvdata, pci_get_drvdata,
> > > hci_get_drvdata. So maybe had add phydev_get_drvdata(struct phy_device
> > > *phydev)?
> >
> > Maybe phydev_mdio_get_drvdata? Because the driver data member available is
> > phydev->mdio.dev.driver_data.
>
> I still prefer phydev_get_drvdata(). It fits with the X_get_drvdata()
> pattern, where X is the type of parameter passed to the call, spi,
> pci, hci.
>
> We can also add mdiodev_get_drvdata(mdiodev). A few DSA drivers could
> use that.

Sorry for the late reply. I just sent a v2 adding
mdiodev_get/set_drvdata helpers
and using them in gmii2rgmii driver.
I did not add a corresponding phydev helper because there is no "struct dev" in
"struct phy_device" and I dint know if there were any users to add the member
and then a helper for driver data. Also,
strutct phy_device { struct mdio_device { struct device }}
is already available and it seemed logical to use that field to
set/get driver data
for gmii2rgmii. Please let me know if v2 is okay.

Regards,
Harini
