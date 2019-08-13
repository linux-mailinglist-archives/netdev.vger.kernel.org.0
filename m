Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABBC48B670
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 13:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfHMLQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 07:16:52 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:43928 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfHMLQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 07:16:52 -0400
Received: by mail-yb1-f195.google.com with SMTP id o82so7998346ybg.10;
        Tue, 13 Aug 2019 04:16:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fpL8tgOC7LhjHn63gsTa4JL9oUa9w1GDwbaAmgEP2eo=;
        b=snBotTZ38Vl4tuBBLQTXq8oZVjEdhV3Yz6uIoWUcnqrI61cP3Iie+j6R7kMW0dfrwF
         z++0tDZSYyBoPiV7CQgnyUS1BksZsj0gV5uof87LcPoiMBdlEhTFRzwmSlZ1zllSha5U
         p5UmvL0ET1ZknYLNvW4dJ3iw6odIF+yjRKkiflkT1OhrRBAzg1aZpzuu4T5Z2OImmOMH
         Izpv6MZoTrooJA2cP0Qv6lSIxvJQkjEd8mf2XgUBNX9CIvTW3Ojr3swUwjnKgeTUWlS3
         mzj466D5sGLdSJ074ztXvIbpwm8feRPuDn+qcRcmGnfIujoxoNch4jOIQaP0uzzO74Qf
         Leng==
X-Gm-Message-State: APjAAAVURlC1C+VdtkaTr05jI3opO8La+hxMoF0UCADj3d+jlmUscaqb
        iakQ0lsX4d5Am81MCqptLTT9lvmprfcPmB3bq50=
X-Google-Smtp-Source: APXvYqxMqmMA/lHhb+ernHEQv3Mdn/NK06RJyi0cT1iBcpqYg5D9awj5M1Bel1AXoKonUVrriQpWnz/gGQYPyNBjXxI=
X-Received: by 2002:a25:5f06:: with SMTP id t6mr26379839ybb.325.1565695011491;
 Tue, 13 Aug 2019 04:16:51 -0700 (PDT)
MIME-Version: 1.0
References: <1564565779-29537-1-git-send-email-harini.katakam@xilinx.com>
 <1564565779-29537-3-git-send-email-harini.katakam@xilinx.com> <20190801040648.GJ2713@lunn.ch>
In-Reply-To: <20190801040648.GJ2713@lunn.ch>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Tue, 13 Aug 2019 16:46:40 +0530
Message-ID: <CAFcVEC+DyVhLzbMdSDsadivbnZJxSEg-0kUF5_Q+mtSbBnmhSA@mail.gmail.com>
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

On Thu, Aug 1, 2019 at 9:36 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Jul 31, 2019 at 03:06:19PM +0530, Harini Katakam wrote:
> > Use the priv field in mdio device structure instead of the one in
> > phy device structure. The phy device priv field may be used by the
> > external phy driver and should not be overwritten.
>
> Hi Harini
>
> I _think_ you could use dev_set_drvdata(&mdiodev->dev) in xgmiitorgmii_probe() and
> dev_get_drvdata(&phydev->mdiomdio.dev) in _read_status()

Thanks for the review. This works if I do:
dev_set_drvdata(&priv->phy_dev->mdio.dev->dev) in probe
and then
dev_get_drvdata(&phydev->mdio.dev) in _read_status()

i.e mdiodev in gmii2rgmii probe and priv->phy_dev->mdio are not the same.

If this is acceptable, I can send a v2.

Regards,
Harini
