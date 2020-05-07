Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B09F1C82B8
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 08:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgEGGo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 02:44:26 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43318 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgEGGoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 02:44:25 -0400
Received: by mail-lj1-f196.google.com with SMTP id l19so5036779lje.10;
        Wed, 06 May 2020 23:44:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KPHo05lQ60Sgmm/o6B6Lw5R77cey+JqtyoXZZ3TP7Og=;
        b=e7wVI36Rf4fqtU7WJhW0eNhiOoR9qLs5D7mo3cKZhnru4fOU0GoxY1Rs35zvmMqf/I
         DkA2PrCvpIxoe8AfSXOlVr+ta+B03ZyC68RXZWbovm0bXaTIDEVnnMfW7e3g0LHXY1CO
         dPAfTAx0ObfeW2JzcLmANRpukFCj7UGfD4Dz2qmu6JNdWZwEYji98uT+Ag8c7vkY0qce
         qtMr9FwgibLoP97IsmB2khr0BBtNp/Qixd3dkDjNqYPewll+e1NSw/I9TxqrYAUhMlLu
         BkNL9gdlG3oZnUJUNlWttddZNuu/RiSzOPza0L/9JzUYBSWiPbMzjI9KczuLwh2Lg/MD
         6zVA==
X-Gm-Message-State: AGi0PuZ8NNXts1Z10rRrfQ3AGOIxTdtR0oFmdemBYWnHfBdILxspxbN5
        lBIIvmnMYJZKmHoYdPPk508=
X-Google-Smtp-Source: APiQypIpQr2fTJp7sK/Z45NvIbcu6kYbSACpGgviZMKo6vxLEoYdxdc72K9eQNDS8kRJ9TzuUBJ2bQ==
X-Received: by 2002:a2e:b44c:: with SMTP id o12mr6880195ljm.240.1588833860796;
        Wed, 06 May 2020 23:44:20 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id o20sm3131820lfc.39.2020.05.06.23.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 23:44:19 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1jWaGS-0008Rt-A0; Thu, 07 May 2020 08:44:12 +0200
Date:   Thu, 7 May 2020 08:44:12 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vince Bridgers <vbridger@opensource.altera.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        Li Yang <leoli@freescale.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <blogic@openwrt.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lars Persson <lars.persson@axis.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Netdev <netdev@vger.kernel.org>,
        nios2-dev@lists.rocketboards.org,
        open list <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: [PATCH net 11/16] net: ethernet: marvell: mvneta: fix fixed-link
 phydev leaks
Message-ID: <20200507064412.GL2042@localhost>
References: <1480357509-28074-1-git-send-email-johan@kernel.org>
 <1480357509-28074-12-git-send-email-johan@kernel.org>
 <CA+G9fYvBjUVkVhtRHVm6xXcKe2+tZN4rGdB9FzmpcfpaLhY1+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvBjUVkVhtRHVm6xXcKe2+tZN4rGdB9FzmpcfpaLhY1+g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 12:27:53AM +0530, Naresh Kamboju wrote:
> On Tue, 29 Nov 2016 at 00:00, Johan Hovold <johan@kernel.org> wrote:
> >
> > Make sure to deregister and free any fixed-link PHY registered using
> > of_phy_register_fixed_link() on probe errors and on driver unbind.
> >
> > Fixes: 83895bedeee6 ("net: mvneta: add support for fixed links")
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > index 0c0a45af950f..707bc4680b9b 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -4191,6 +4191,8 @@ static int mvneta_probe(struct platform_device *pdev)
> >         clk_disable_unprepare(pp->clk);
> >  err_put_phy_node:
> >         of_node_put(phy_node);
> > +       if (of_phy_is_fixed_link(dn))
> > +               of_phy_deregister_fixed_link(dn);
> 
> While building kernel Image for arm architecture on stable-rc 4.4 branch
> the following build error found.
> 
> drivers/net/ethernet/marvell/mvneta.c:3442:3: error: implicit
> declaration of function 'of_phy_deregister_fixed_link'; did you mean
> 'of_phy_register_fixed_link'? [-Werror=implicit-function-declaration]
> |    of_phy_deregister_fixed_link(dn);
> |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> |    of_phy_register_fixed_link
> 
> ref:
> https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/541374729

Greg, 3f65047c853a ("of_mdio: add helper to deregister fixed-link
PHYs") needs to be backported as well for these.

Original series can be found here:

	https://lkml.kernel.org/r/1480357509-28074-1-git-send-email-johan@kernel.org

Johan
