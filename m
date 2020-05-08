Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8792E1CA3B5
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 08:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgEHGV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 02:21:28 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44702 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgEHGV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 02:21:27 -0400
Received: by mail-lj1-f193.google.com with SMTP id a21so433224ljj.11;
        Thu, 07 May 2020 23:21:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=l07sjg7wad11JybQiwBPplAsmA/VCV2GQr8sTEyBm88=;
        b=C1Dt6HJA2i7OLmGNc9XeFfcM+njIJrh7SQ8MmMM0w10EYLGbB6nWl5tysAKbyh26NV
         92Vr2fknGA27JOLMooDs/pi8KKnsaE4BJ8VLjEu3XWbuCgDKezm2PWVhZdNQT9VlF+Cr
         e8xxoIPBQPiiPP32vzN0FV6FP2kMUjmQqt4kIXxuNJ/O1NMiyhRh68rZyxUfO85vMG3Y
         7rEIjqd07d20ros4Bro7pnu6ce1GoDxeMYDUhLG8n1abhqKhxiK7h5EjO6DMHHYBcjqO
         30Xp79qHVkpd6OIfZkp6oq6yP9TVUTqReasmmj5XZdnhXF6HGP8tdN1ONSzr+RMd1Gqe
         uGtA==
X-Gm-Message-State: AOAM532LnT/OWxDGsCuWXIkKI6J1NQMvV5HRcU++9B/lN68BdQtQcidF
        /aD/BQBnht/6sdswbsr4/9I=
X-Google-Smtp-Source: ABdhPJzQwccjomPZVXTofZDq7QNMtMm+acyePCPBUNykc5Wt6G9pf/ArU7L/ehrFMv9M6FmHt7FVvw==
X-Received: by 2002:a05:651c:549:: with SMTP id q9mr624525ljp.236.1588918884533;
        Thu, 07 May 2020 23:21:24 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id z64sm428692lfa.50.2020.05.07.23.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 23:21:23 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1jWwNr-0001TQ-0H; Fri, 08 May 2020 08:21:19 +0200
Date:   Fri, 8 May 2020 08:21:19 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lars Persson <lars.persson@axis.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Netdev <netdev@vger.kernel.org>,
        nios2-dev@lists.rocketboards.org,
        open list <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: [PATCH net 11/16] net: ethernet: marvell: mvneta: fix fixed-link
 phydev leaks
Message-ID: <20200508062119.GE25962@localhost>
References: <1480357509-28074-1-git-send-email-johan@kernel.org>
 <1480357509-28074-12-git-send-email-johan@kernel.org>
 <CA+G9fYvBjUVkVhtRHVm6xXcKe2+tZN4rGdB9FzmpcfpaLhY1+g@mail.gmail.com>
 <20200507064412.GL2042@localhost>
 <20200507064734.GA798308@kroah.com>
 <20200507111312.GA1497799@kroah.com>
 <CA+G9fYu2SrkEHyAzF57xJz5WjgHv361qdL2wPqON_pGS4Vtxmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYu2SrkEHyAzF57xJz5WjgHv361qdL2wPqON_pGS4Vtxmw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 03:35:02AM +0530, Naresh Kamboju wrote:
> On Thu, 7 May 2020 at 16:43, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> <trim>
> > > >
> > > > Greg, 3f65047c853a ("of_mdio: add helper to deregister fixed-link
> > > > PHYs") needs to be backported as well for these.
> > > >
> > > > Original series can be found here:
> > > >
> > > >     https://lkml.kernel.org/r/1480357509-28074-1-git-send-email-johan@kernel.org
> > >
> > > Ah, thanks for that, I thought I dropped all of the ones that caused
> > > build errors, but missed the above one.  I'll go take the whole series
> > > instead.
> >
> > This should now all be fixed up, thanks.
> 
> While building kernel Image for arm architecture on stable-rc 4.4 branch
> the following build error found.
> 
> of_mdio: add helper to deregister fixed-link PHYs
> commit 3f65047c853a2a5abcd8ac1984af3452b5df4ada upstream.
> 
> Add helper to deregister fixed-link PHYs registered using
> of_phy_register_fixed_link().
> 
> Convert the two drivers that care to deregister their fixed-link PHYs to
> use the new helper, but note that most drivers currently fail to do so.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [only take helper function for 4.4.y - gregkh]
> 
>  # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> arm-linux-gnueabihf-gcc" O=build zImage
> 70 #
> 71 ../drivers/of/of_mdio.c: In function ‘of_phy_deregister_fixed_link’:
> 72 ../drivers/of/of_mdio.c:379:2: error: implicit declaration of
> function ‘fixed_phy_unregister’; did you mean ‘fixed_phy_register’?
> [-Werror=implicit-function-declaration]
> 73  379 | fixed_phy_unregister(phydev);
> 74  | ^~~~~~~~~~~~~~~~~~~~
> 75  | fixed_phy_register
> 76 ../drivers/of/of_mdio.c:381:22: error: ‘struct phy_device’ has no
> member named ‘mdio’; did you mean ‘mdix’?
> 77  381 | put_device(&phydev->mdio.dev); /* of_phy_find_device() */
> 78  | ^~~~
> 79  | mdix

Another dependency: 5bcbe0f35fb1 ("phy: fixed: Fix removal of phys.")

Greg, these patches are from four years ago so can't really remember if
there are other dependencies or reasons against backporting them (the
missing stable tags are per Dave's preference), sorry.

The cover letter also mentions another dependency, but that may just
have been some context conflict.

Perhaps you better drop these unless you want to review them closer.

Johan
