Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918E029705F
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464733AbgJWNZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373831AbgJWNZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 09:25:49 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13271C0613CE;
        Fri, 23 Oct 2020 06:25:48 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id k68so1297848otk.10;
        Fri, 23 Oct 2020 06:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=coXI+hnEQpGfbagDq5IDOSjcPU2q/MpePlAmsXCYVTs=;
        b=FeiU8x6G3PLdtP9QCuyvwO9P1NzHMWxd99QRVszMrJgXawtvdatA+ObHv0JU3tYt2H
         o0ZH4AZTYvxB02YjUvoiKNmCPRlu1TamVGqYEZ8ZLNx1D5FKoLc7WQFsMxVVAmSPrP5R
         wW7LU6gXCpTqpUfXgIOgoT1FGaaSCDr4bs03zlhu72RhuGqthg/I8qqW7OUKE96xCjmA
         LY5aRfloRaMX0+jBJvmkfYWtbqG1y+ZPGAVV58Jk2mnBe/hmkplpSC5Wh12hDCEzkEk1
         i53g3nbGNYAU1catfROy/w6Hr8ziXmYlf2byvIyB112CKjC+D1rfyPjSUHIBsLd/QqlZ
         Ytng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=coXI+hnEQpGfbagDq5IDOSjcPU2q/MpePlAmsXCYVTs=;
        b=WU4gXoEXEQfbl6d62QCph4+EQlBHYbu8fJN0b+ytlXfH7vho4ZxkXrSUWVl3YWcscx
         1gHF2WgCFNikFLZDza8XE43mKWpmZ+lpjE0GEhrI6bGcgXS9MBM89TkgboAxt8Q9IUGg
         rbDRiLvzzzriEnnc+smo3akaUdG/yUmYdytUHcAO3VGBuV1BLnoeGVm2GmVXDLJkbV2B
         pC/NSx8ubVWJR9UUeSRCLUqElasIy+T5WihkZl6kUkWVXieYS4GptVP4U1cbC+IfiM63
         cXyzbHpWwRoNz8pQLRfnQYga0tohCwuq0RJcsFnzQkuO0gURgnYIlZe88PVs6Ztvk3CZ
         AcMA==
X-Gm-Message-State: AOAM5328wqp8uUoqypk920G9q3jDVmK5LDAvpoa5pgu3QYB91yhqm1Ni
        8KjQUL5xynGyD1rZerCljd4U+0bYyDmfY6zOcxu9ml+sHzGI9A==
X-Google-Smtp-Source: ABdhPJw9mdNcoUzXsAYk/V6TzpbyuphhjRpRiSnRSomTzrqh2/URyhP8hvN7+bcrsj3OlTXjYytZblgyi/nPeuQJXFc=
X-Received: by 2002:a9d:822:: with SMTP id 31mr651999oty.224.1603459547385;
 Fri, 23 Oct 2020 06:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <20201022074551.11520-1-alexandru.ardelean@analog.com>
 <20201022074551.11520-2-alexandru.ardelean@analog.com> <20201022170219.13b03274@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022170219.13b03274@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Alexandru Ardelean <ardeleanalex@gmail.com>
Date:   Fri, 23 Oct 2020 16:25:33 +0300
Message-ID: <CA+U=Dsp+AnhHe87-7FXTekf5KqC3arYsy_46FEcZjQJTBWq8-Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: phy: adin: implement cable-test support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 3:02 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 22 Oct 2020 10:45:51 +0300 Alexandru Ardelean wrote:
> > The ADIN1300/ADIN1200 support cable diagnostics using TDR.
> >
> > The cable fault detection is automatically run on all four pairs looking at
> > all combinations of pair faults by first putting the PHY in standby (clear
> > the LINK_EN bit, PHY_CTRL_3 register, Address 0x0017) and then enabling the
> > diagnostic clock (set the DIAG_CLK_EN bit, PHY_CTRL_1 register, Address
> > 0x0012).
> >
> > Cable diagnostics can then be run (set the CDIAG_RUN bit in the
> > CDIAG_RUN register, Address 0xBA1B). The results are reported for each pair
> > in the cable diagnostics results registers, CDIAG_DTLD_RSLTS_0,
> > CDIAG_DTLD_RSLTS_1, CDIAG_DTLD_RSLTS_2, and CDIAG_DTLD_RSLTS_3, Address
> > 0xBA1D to Address 0xBA20).
> >
> > The distance to the first fault for each pair is reported in the cable
> > fault distance registers, CDIAG_FLT_DIST_0, CDIAG_FLT_DIST_1,
> > CDIAG_FLT_DIST_2, and CDIAG_FLT_DIST_3, Address 0xBA21 to Address 0xBA24).
> >
> > This change implements support for this using phylib's cable-test support.
> >
> > Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
>
> # Form letter - net-next is closed
>
> We have already sent a pull request for 5.10 and therefore net-next
> is closed for new drivers, features, and code refactoring.
>
> Please repost when net-next reopens after 5.10-rc1 is cut.
>

Ack.
No hurry from my side.

Thanks
Alex

> (http://vger.kernel.org/~davem/net-next.html will not be up to date
>  this time around, sorry about that).
>
> RFC patches sent for review only are obviously welcome at any time.
