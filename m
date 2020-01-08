Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A281F1347FD
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgAHQaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:30:46 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37272 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgAHQap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:30:45 -0500
Received: by mail-ed1-f67.google.com with SMTP id cy15so3086763edb.4;
        Wed, 08 Jan 2020 08:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7o9krT2FUFfJzalxomNVkht5y8lOkSzgYqZOdm5yd0M=;
        b=X8TgNDuz+uEj76NEkllamJk67PcA5BUx9CHYIBn0iZCL1hhHXUlYs14iUvNwIuuS7f
         kTTfoDZxbxkhEIZLHTP4UQ3cCdGf28XCWMfZ9WIr3KBzfiTihOqAjllKOzkWCKE1DGAR
         svr5zwYLmkCY+wocqYDhNi5qyjWvN80z8QvAZEINIiB96tTe1HtDtSwe+yT/qjqGv7pM
         0DVCSJefobFFR3r0Jazu9+7z1cRsncaZqKySZzYhssuLnMc58cjMCUDsSX1gKNQH+6Rg
         FVxYDocWq5DzrIhtY2iEVv4/YIi0jygNC7pBCJdH2QfpjFthNLvQ8+9CX0YWyKrMP2so
         hU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7o9krT2FUFfJzalxomNVkht5y8lOkSzgYqZOdm5yd0M=;
        b=CgbOac+xOxRm7UxAdFcjKnXYM+1mxa0FPjr812YAXY+uoDq/6QbDNrDAAiTfIIszlW
         mG1obcBJ6xKELrxzCq2DpuTCYqbwhiL2UZfngb7TBSTgoCvdcrR0yrN/FKyR3GGJGwtw
         UdDI6bwDp3Qet0EHazJmixAGZoIfOdg62DcGDikX2MgrJZRNLGLQ5CM1LXiy+KqRszzS
         VCZ4RyXb2hTOObOFBr7uza7bULV9XUW13CS1bg0qTdbssYf1Umy2um8/WNmXnkyS3NCJ
         HicCQlSH+gb1+PL7OcJLvqxlEEXXsPVAuJOd5B4JRY+5ryKJuuzQFXJt/R5T/R4rcPvL
         +0sg==
X-Gm-Message-State: APjAAAVUHfxhRY72T9xBATfrbwsMCAzVW4i719kppu9kMcEAzFieyWG6
        NDCUz8TBBE1f/FeCaEiX1yoWpqo97WGubIOtf3U=
X-Google-Smtp-Source: APXvYqzF4ARmkb+wNjI820dBjXqHoID1H5hB7nCDR7eZCrEtV123/DMTKyIfpgBjt0+My1LvwCjXkpgwBJXhyAFw3xo=
X-Received: by 2002:a17:907:11cc:: with SMTP id va12mr5803958ejb.164.1578501043781;
 Wed, 08 Jan 2020 08:30:43 -0800 (PST)
MIME-Version: 1.0
References: <HK0PR01MB3521C806FE109E04FA72858CFA3F0@HK0PR01MB3521.apcprd01.prod.exchangelabs.com>
 <CA+h21hpERd-yko+X9G-D9eFwu3LVq625qDUYvNGtEA8Ere_vYw@mail.gmail.com> <HK0PR01MB35219F5DF16CE54D088ACE2CFA3E0@HK0PR01MB3521.apcprd01.prod.exchangelabs.com>
In-Reply-To: <HK0PR01MB35219F5DF16CE54D088ACE2CFA3E0@HK0PR01MB3521.apcprd01.prod.exchangelabs.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 8 Jan 2020 18:30:31 +0200
Message-ID: <CA+h21hrb70QTaaXzxSxXGE=JaOLPazKmAEqSdMxOEcAYFVrxCg@mail.gmail.com>
Subject: Re: [PATCH] gianfar: Solve ethernet TX/RX problems for ls1021a
To:     =?UTF-8?B?Sm9obnNvbiBDSCBDaGVuICjpmbPmmK3li7Mp?= 
        <JohnsonCH.Chen@moxa.com>
Cc:     "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zero19850401@gmail.com" <zero19850401@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johnson,

On Wed, 8 Jan 2020 at 09:15, Johnson CH Chen (=E9=99=B3=E6=98=AD=E5=8B=B3)
<JohnsonCH.Chen@moxa.com> wrote:
>
> Hi Vladimir,
>
> Vladimir Oltean <olteanv@gmail.com> =E6=96=BC 2020=E5=B9=B41=E6=9C=887=E6=
=97=A5 =E9=80=B1=E4=BA=8C =E4=B8=8B=E5=8D=8811:49=E5=AF=AB=E9=81=93=EF=BC=
=9A
> >
> > Hi Chen,
> >
> > On Tue, 7 Jan 2020 at 12:37, Johnson CH Chen (=E9=99=B3=E6=98=AD=E5=8B=
=B3)
> > <JohnsonCH.Chen@moxa.com> wrote:
> > >
> > > Add dma_endian_le to solve ethernet TX/RX problems for freescale
> > > ls1021a. Without this, it will result in rx-busy-errors by ethtool, a=
nd transmit queue timeout in ls1021a's platforms.
> > >
> > > Signed-off-by: Johnson Chen <johnsonch.chen@moxa.com>
> > > ---
> >
> > This patch is not valid. The endianness configuration in
> > eTSECx_DMACTRL is reserved and not applicable.
> > What is the value of SCFG_ETSECDMAMCR bits ETSEC_BD and ETSEC_FR_DATA
> > on your board? Typically this is configured by the bootloader.
> >
>
> Thanks your suggestion. I use linux-fsl-sdk-v1.7, and find "dma-endian-le=
" is used in ls1021a.dtsi and gianfar.c/.h. For bootloader, version is U-Bo=
ot version is 2015.01-dirty and it seems old and not includes "SCFG_ETSECDM=
AMCR bits".
>
> It seems solution is included in bootloader, not in device tree for
> freescale/NXP: https://lxr.missinglinkelectronics.com/uboot/board/freesca=
le/ls1021aiot/ls1021aiot.c
>
> It means bootloader provides functions are the same as device tree's.
> So what's benefit for this desgin? It seems we need to upgrade kernel and=
 bootloader to satisfy our need, not just upgrade kernel only. So many than=
ks!
>

I'm not sure that the Freescale SDK 1.7 is of any relevance here. The
point is that this patch is breaking Ethernet for every other LS1021A
board except yours.

Regards,
-Vladimir
