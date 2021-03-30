Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2726A34EB7D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhC3PFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbhC3PFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:05:03 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4BCC0613D8;
        Tue, 30 Mar 2021 08:05:02 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b14so24273323lfv.8;
        Tue, 30 Mar 2021 08:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NDU6A12u+rXHnnt7HiYDLSDihuLFvN8sM+MRBrDc1yo=;
        b=lJIsJ8oGCQKJ7cHmaQdct5bgnRwxC3WIZMAv6EBTMgb40XepxaVahCS76qmRBzv9Xg
         1OoWSMYiP0FwJlOOzIn8y7XNIGZ9/4mSVrRcfOS2nxo0E78Z8b5PQOXR0U6b4Q075bP6
         nxCsOIeLZ2pv29B9iIHDi0qdMh5aXUXQ8rg9gWpLmEWsU6+GQCuWqLHLb+8apVhnSKpL
         UyxxGLiZg9G34XIHRiKWJVAFxFNEDtb5bQadjvEKOqxQBhGfvwAVRC+Mso1rY45B1lSs
         6VDmTtiGmfTHlmycwtixXzuVFK3q09P8/4oGFQRxq3fXY+2ZXgqkV8T4mNcusFM8YcCf
         aOuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NDU6A12u+rXHnnt7HiYDLSDihuLFvN8sM+MRBrDc1yo=;
        b=X1i1g2GqayI6rDZi6u8QX2y5vc6NTTAmjTTymWOK+2UIFSTvDo9i3RzIxHjtJG79fb
         FZDp52eO2I3V4CqR4QvXX9PGAJIZ3vba1psuL2yARAdQrRNeuweGAcob3Sbvqc31+uX3
         /5O6/aek+YqXpGjqsS4L81WZTdz2kPqF6sBNjxiVidpsc2u/Zhixa0Ri10Vk/+Vaf4nY
         SSseVN3mNHXwBLLiWGDkaHECo9o/TOOeI5wgaYJAa5XWGDvlbA5gyDTpkaRQVMnVK4nE
         cOGyUnHODOZwfIaVvl0EKs63BYYnKuC9nix1+whCumNVChkFHqYzMMGfrxP5jJlGR8vv
         vwyw==
X-Gm-Message-State: AOAM533loBHiLHA+snDfJyPFu4hblLiPUiplt3nunVWs0/7QuHY3jllE
        YtWyBVAlxauLXuOD+JGGEw2sOUXbgQnwD7V2Rcc=
X-Google-Smtp-Source: ABdhPJyr6zuKHLNxnmbk4GFqVBqzCFlj5dBZXx+4vfI5QhMUtKkNSrerXfwuJWK7f+3e+HSAU5t31WOmhtLMFkfryoE=
X-Received: by 2002:ac2:5974:: with SMTP id h20mr16611591lfp.500.1617116701026;
 Tue, 30 Mar 2021 08:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210309112615.625-1-o.rempel@pengutronix.de> <CAOMZO5CYquzd4BBZBUM6ufWkPqfidctruWmaDROwHKVmi3NX2A@mail.gmail.com>
 <YGM2AGfawEFTKOtE@lunn.ch>
In-Reply-To: <YGM2AGfawEFTKOtE@lunn.ch>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 30 Mar 2021 12:04:50 -0300
Message-ID: <CAOMZO5CRFHh5vv3vQqaatDnq55ZMmO5DfJH1VtZ1n0DBgf5Whg@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] remove different PHY fixups
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, Mar 30, 2021 at 11:30 AM Andrew Lunn <andrew@lunn.ch> wrote:

> Hi Fabio
>
> I think it should be merged, and we fixup anything which does break.
> We are probably at the point where more is broken by not merging it
> than merging it.

Thanks for your feedback. I agree.

Shawn wants to collect some Acked-by for this series.

Could you please give your Acked-by for this series?

Thanks
