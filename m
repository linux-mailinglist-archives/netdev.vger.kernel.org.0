Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 913341A4795
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 16:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDJOkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 10:40:35 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20390 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726177AbgDJOke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 10:40:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586529634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sdxFTSbWfJP1BjnCvak13UOfzZOw2d0mkvo9u0Ex5RM=;
        b=aOUggCtOwAiHmeWf3k7Sxxlvai2tvO7t6wTZTHGlI3QnQmQDIbTVKDfIyrAmU2yYbjb216
        gGvnWtwKrbEiNMWogtqmdev0zCKVcCTLuZ+62+S828H8uLyoJL0clbGBNIEn6hG6OBChjC
        ZAFQXNMgtvTf11zrtps7Wd1gc/72CHg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-KtbvtA9POkOmI96vi8JGEA-1; Fri, 10 Apr 2020 10:40:25 -0400
X-MC-Unique: KtbvtA9POkOmI96vi8JGEA-1
Received: by mail-ed1-f69.google.com with SMTP id e24so2252896eds.18
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 07:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sdxFTSbWfJP1BjnCvak13UOfzZOw2d0mkvo9u0Ex5RM=;
        b=ATfwlalsBZLp8ByiQuBpJjmkh3XR/uU+3kVKofCfl2twDUuQQWU0UkRVERFX0Is/3N
         dVA54D48NIIa6wkzOGW3E6Qr4f7szg96TPQurOpAsDngv/vGUwA/1xxtK94Qk+2DgcYq
         qqjgPaY64ZcioOHy729sQFWO9RMaU/n79nphGqCyzDMxkS3sKarTBHvpFdVlryQmv6+g
         i/1O3GvVGrBGJUmL2XRDuhpTKyXj7fVVaCkTvwK7K/knw/kXhPi/Ecrs9l4sHD6OPGdN
         FhExTixRA4w2TGwZ9kpxcHM9TRHHeR1CATTFJZHwVpzC5XZ8YFXar03CT42xo9dCxPUY
         0nEg==
X-Gm-Message-State: AGi0PuayfArt7WxiIApnGXUSKrMh79hiCf4jQu7iVD6/65X+4pOlmkE9
        a74h3liNpZGX+xEKlMkqYT4LmKU/XnB87OmtfJR+Aaam+8C+hklmQwqQY4wTAkmrsx0Nji+pDWN
        i1bD509ykQftmc+1Dj6r9OuigAasJJXxY
X-Received: by 2002:a17:906:6992:: with SMTP id i18mr3948474ejr.293.1586529624802;
        Fri, 10 Apr 2020 07:40:24 -0700 (PDT)
X-Google-Smtp-Source: APiQypLjdUp4hp8mhI/74IhW4c+q0aHoVFTJIhb8YW3iHGNxcYO6bG8GY6TL4DdH6wIIqwEoIFmrVCabLn50B6beHjE=
X-Received: by 2002:a17:906:6992:: with SMTP id i18mr3948449ejr.293.1586529624581;
 Fri, 10 Apr 2020 07:40:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200303155347.GS25745@shell.armlinux.org.uk> <E1j99sC-00011f-22@rmk-PC.armlinux.org.uk>
 <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
 <20200410141914.GY25745@shell.armlinux.org.uk> <20200410143658.GM5827@shell.armlinux.org.uk>
In-Reply-To: <20200410143658.GM5827@shell.armlinux.org.uk>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 10 Apr 2020 16:39:48 +0200
Message-ID: <CAGnkfhxPm6UWj8Dyt9S08vHdh9nwkTums+WfY14D52dsBsBPgQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: place in powersave
 mode at probe
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Luka Perkov <luka.perkov@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 4:37 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Fri, Apr 10, 2020 at 03:19:14PM +0100, Russell King - ARM Linux admin wrote:
> > On Fri, Apr 10, 2020 at 03:48:34PM +0200, Matteo Croce wrote:
> > > On Fri, Apr 10, 2020 at 3:24 PM Russell King <rmk+kernel@armlinux.org.uk> wrote:
> > > >
> > > > Place the 88x3310 into powersaving mode when probing, which saves 600mW
> > > > per PHY. For both PHYs on the Macchiatobin double-shot, this saves
> > > > about 10% of the board idle power.
> > > >
> > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > >
> > > Hi,
> > >
> > > I have a Macchiatobin double shot, and my 10G ports stop working after
> > > this change.
> > > I reverted this commit on top of latest net-next and now the ports work again.
> >
> > Please describe the problem in more detail.
> >
> > Do you have the interface up?  Does the PHY link with the partner?
> > Is the problem just that traffic isn't passed?
>
> I've just retested on my Macchiatobin double shot, and it works fine.
> What revision PHYs do you have?  Unfortunately, you can't read the
> PHY ID except using mii-diag:
>
> # mii-diag eth0 -p 32769
>
> or
>
> # mii-diag eth1 -p 33025
>
> Looking at word 3 and 4, it will be either:
>
> 002b 09aa
> 002b 09ab
>
> Thanks.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
>


Hi Russel,

I have the interface up connected via a DAC Cable to an i40e card.
When I set the link up I detect the carrier:

mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-mii:00] driver
[mv88x3310] (irq=POLL)
mvpp2 f2000000.ethernet eth0: configuring for phy/10gbase-r link mode
mvpp2 f2000000.ethernet eth0: Link is Up - 10Gbps/Full - flow control off

No traffic is received or can be sent.

How can I read the PHY revision?

Thanks,
-- 
Matteo Croce
per aspera ad upstream

