Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FC11CC1B0
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 15:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgEINOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 09:14:47 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23818 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727106AbgEINOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 09:14:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589030085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fXszUZPGL30pBHLQXJciSiK0fXjuwaWRz9TKtjnhSaw=;
        b=NgBe6TEq5dKbyEuyWZEfv0fVzAOHKexWUfeT5EjjR/bxky6HExlpx4jA+oneQOWddzOM8t
        2XKHv4q3KKyUyB/fyxIC/E3Fb6Qn2zgwQjOi9T2nqKnOpxof11P0ZDTgy2KlkuGZZgp4gY
        H3AMz8qEDDV6ZRdeOQe9a+zWhBhaaLI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-61pnhPxnNY-AbVH3vzrgFg-1; Sat, 09 May 2020 09:14:43 -0400
X-MC-Unique: 61pnhPxnNY-AbVH3vzrgFg-1
Received: by mail-ed1-f69.google.com with SMTP id cq11so1181292edb.7
        for <netdev@vger.kernel.org>; Sat, 09 May 2020 06:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fXszUZPGL30pBHLQXJciSiK0fXjuwaWRz9TKtjnhSaw=;
        b=aFkLZGFwH3ytO2vx0K65VJEou35eDtBvp794mnxPaXBFNpjZe26llZUhzzqHZBbLvc
         rNF1wBepyY1uhFnOuiQVRGKbutEZUbsPhhZ52M52LGs+MhMsSyWkYj/cpNQa2diiNF1I
         X5K52nWbaVQEc20rtYn2sTI71N1ks4TDSbUAthxMQk/+TuzOQ0vMtqhwGG59g/9QOsc3
         lbmFNtB5YqiSywZr4y88CqEnexNKZZHSc7+wlTNKqvrg/zrXeKGMlITEACATb5f5dJLC
         5YwOrBqjqJXogVE4jaIoNiS22K/ATVwjxGLCeH3o/ge3cHvLKc39lWNbRrdcNQBOY248
         jcqw==
X-Gm-Message-State: AGi0PuaynpPBAu2XoChYwclW+vWi91WInRsb/MIPqnxKUirNPFv6kUsU
        m3M1amkRKXw4g92JdJT37xW/6iCMDj9YO+dXPX1G0hpaQM/rnLcW/u2xvS3/9fddpegSY248OpL
        QURtUEZeQdnLeijUhc8mGtuEvn6owtduE
X-Received: by 2002:a05:6402:b2a:: with SMTP id bo10mr6360509edb.366.1589030082271;
        Sat, 09 May 2020 06:14:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypJTOew0BzTLx2lykLc6ZnwAhULmTxRo4EBF7kA/EDNp3Rtkx/81lrJt/Ty1aqhmM7gm8iaduhfmnd2Vfy0rnYA=
X-Received: by 2002:a05:6402:b2a:: with SMTP id bo10mr6360472edb.366.1589030081918;
 Sat, 09 May 2020 06:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
 <20190524100554.8606-4-maxime.chevallier@bootlin.com> <CAGnkfhzsx_uEPkZQC-_-_NamTigD8J0WgcDioqMLSHVFa3V6GQ@mail.gmail.com>
 <20200423170003.GT25745@shell.armlinux.org.uk> <CAGnkfhwOavaeUjcm4_+TG-xLxQA519o+fR8hxBCCfSy3qpcYhQ@mail.gmail.com>
 <DM5PR18MB1146686527DE66495F75D0DAB0A30@DM5PR18MB1146.namprd18.prod.outlook.com>
 <20200509114518.GB1551@shell.armlinux.org.uk>
In-Reply-To: <20200509114518.GB1551@shell.armlinux.org.uk>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sat, 9 May 2020 15:14:05 +0200
Message-ID: <CAGnkfhx8fEZCoLPzGxSzQnj1ZWcQtBMn+g_jO1Jxc4zF7pQwjQ@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts
 to handle RSS tables
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Stefan Chulski <stefanc@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 9, 2020 at 1:45 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Sat, May 09, 2020 at 11:15:58AM +0000, Stefan Chulski wrote:
> >
> >
> > > -----Original Message-----
> > > From: Matteo Croce <mcroce@redhat.com>
> > > Sent: Saturday, May 9, 2020 3:13 AM
> > > To: David S . Miller <davem@davemloft.net>
> > > Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>; netdev
> > > <netdev@vger.kernel.org>; LKML <linux-kernel@vger.kernel.org>; Antoine
> > > Tenart <antoine.tenart@bootlin.com>; Thomas Petazzoni
> > > <thomas.petazzoni@bootlin.com>; gregory.clement@bootlin.com;
> > > miquel.raynal@bootlin.com; Nadav Haklai <nadavh@marvell.com>; Stefan
> > > Chulski <stefanc@marvell.com>; Marcin Wojtas <mw@semihalf.com>; Linux
> > > ARM <linux-arm-kernel@lists.infradead.org>; Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk>
> > > Subject: [EXT] Re: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts to
> > > handle RSS tables
> > >
> > > Hi,
> > >
> > > What do you think about temporarily disabling it like this?
> > >
> > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > @@ -5775,7 +5775,8 @@ static int mvpp2_port_probe(struct platform_device
> > > *pdev,
> > >                             NETIF_F_HW_VLAN_CTAG_FILTER;
> > >
> > >         if (mvpp22_rss_is_supported()) {
> > > -               dev->hw_features |= NETIF_F_RXHASH;
> > > +               if (port->phy_interface != PHY_INTERFACE_MODE_SGMII)
> > > +                       dev->hw_features |= NETIF_F_RXHASH;
> > >                 dev->features |= NETIF_F_NTUPLE;
> > >         }
> > >
> > >
> > > David, is this "workaround" too bad to get accepted?
> >
> > Not sure that RSS related to physical interface(SGMII), better just remove NETIF_F_RXHASH as "workaround".
>
> Hmm, I'm not sure this is the right way forward.  This patch has the
> effect of disabling:
>
> d33ec4525007 ("net: mvpp2: add an RSS classification step for each flow")
>
> but the commit you're pointing at which caused the regression is:
>
> 895586d5dc32 ("net: mvpp2: cls: Use RSS contexts to handle RSS tables")
>
>

Hi,

When git bisect pointed to 895586d5dc32 ("net: mvpp2: cls: Use RSS
contexts to handle RSS tables"), which was merged
almost an year after d33ec4525007 ("net: mvpp2: add an RSS
classification step for each flow"), so I assume that between these
two commits either the feature was working or it was disable and we
didn't notice

Without knowing what was happening, which commit should my Fixes tag point to?

Regards,
-- 
Matteo Croce
per aspera ad upstream

