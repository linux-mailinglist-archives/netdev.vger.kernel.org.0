Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37597493167
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 00:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350281AbiARXcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 18:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350196AbiARXcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 18:32:43 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D80C061574;
        Tue, 18 Jan 2022 15:32:42 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id n8so1433000wmk.3;
        Tue, 18 Jan 2022 15:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jhx4P/7V0jR1r4GS0bXkT54dwJLR8WwyaKkLIbcZ1Jw=;
        b=o0FTBE3s5DNlBxwbq35uWlM7UHNGn1Xhi0jjWu07TqIpiVtfVtNG98tjNEUmWFrdlZ
         z6MQRsTHyuwhJZPeTFHdOXk9cOsN4WYbhGCXDzkjoRM4mLnv8LSleP9RHg/7oLvkWTow
         dj/5w+4kcRt5RsKT5ILLQispJwPqzCFwD+3rK74WHRVgsfWFRRLQjV8IVEtQ7LBKLonT
         LZiPFKwuK4xPkanNaCUk/WcqIultoJ7+Ep2rvev0638MzYrNkO2b7E/4RtzR6W4273Tr
         HqSpFL1MTJ6fQwD8MtDyOwIsKP/MWlwOu3J1KgqSunA9W0aVKHOzWTW6wGEmYbUvAvbX
         3hiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jhx4P/7V0jR1r4GS0bXkT54dwJLR8WwyaKkLIbcZ1Jw=;
        b=RSgG/u3NRGtkG5C5QuGw5CxDZ5daqr5s8hJtDqAMzHzKTwNGFZtmJMCjuqVo1w2Bis
         P+U065oAr0TQxejJ80HKtAVEO+V3pTA8GeDjuvSHkdUh7aCJBX6tWNDNhDpPnCGKgdZP
         abR5VAzNKSCH1ioWXFAFwA9imfF1beyJ7d8QnIH+bC9eM9CvLqNmkVCtzw+06rTjv0s8
         72elQ5GaJ5kwc8j9cxEnoziTrsH6aehSG2KM3ZTAFIV0hDEhxiBiSj9oij6vgq6nRQrS
         /JFV6n022/NcpGz15pKIEJreEYzH640TN4DE+vZGfbryf2+K3x4/AJCEG4Y5tMcHNtSg
         Cv7A==
X-Gm-Message-State: AOAM531CzY0MDxUatW8wcyCyFSZNA5OQyTsELVdDdQP8YrYCCYOklIpK
        lOkTvsOW6D2a26Rv8UnIgFiJ7vLk9J+FyaIVkVc=
X-Google-Smtp-Source: ABdhPJz9SEgf0a9qOeZ01tvL/cSJ34TakOjGqn32PE4qCTAd5YhVCs5iINzSLsvXk+Oq+QFlRdpn20D1tmmNCXOcFN0=
X-Received: by 2002:a05:6000:1686:: with SMTP id y6mr15827016wrd.205.1642548761407;
 Tue, 18 Jan 2022 15:32:41 -0800 (PST)
MIME-Version: 1.0
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
 <CAB_54W4q9a1MRdfK6yJHMRt+Zfapn0ggie9RbbUYi4=Biefz_A@mail.gmail.com> <20220118114034.791933ca@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220118114034.791933ca@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 18 Jan 2022 18:32:30 -0500
Message-ID: <CAB_54W7EutVuSd65O7J8HWYX9qQ_Y9T8aq9Jy9VM2C-3BznJRA@mail.gmail.com>
Subject: Re: [PATCH v3 00/41] IEEE 802.15.4 scan support
To:     Jakub Kicinski <kuba@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        =?UTF-8?Q?linux=2Dwireless=40vger=2Ekernel=2Eorg_Wireless_=3Clinux=2Dwireless=40vger?=
         =?UTF-8?Q?=2Ekernel=2Eorg=3E=2C_David_Girault_=3Cdavid=2Egirault=40qorvo=2Ecom=3E=2C_Romua?=
         =?UTF-8?Q?ld_Despres_=3Cromuald=2Edespres=40qorvo=2Ecom=3E=2C_Frederic_Blain_=3Cfred?=
         =?UTF-8?Q?eric=2Eblain=40qorvo=2Ecom=3E=2C_Nicolas_Schodet_=3Cnico=40ni=2Efr=2Eeu=2Eorg=3E=2C_?=
         =?UTF-8?Q?Michael_Hennerich_=3Cmichael=2Ehennerich=40analog=2Ecom=3E=2C_Varka_Bhad?=
         =?UTF-8?Q?ram_=3Cvarkabhadram=40gmail=2Ecom=3E=2C_Xue_Liu_=3Cliuxuenetmail=40gmail=2Ec?=
         =?UTF-8?Q?om=3E=2C_Alan_Ott_=3Calan=40signal11=2Eus=3E=2C_Thomas_Petazzoni?= 
        <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, 18 Jan 2022 at 14:40, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 17 Jan 2022 18:02:06 -0500 Alexander Aring wrote:
> > can you please split this patch series, what I see is now:
> >
> > 1. cleanup patches
>
> I see a few patches here with Fixes tags and the MAINTAINERS patch -
> do you mean those as cleanups? Fixes would preferably go to Linus soon
> and then the rest should be merged to -next trees.
>

okay. Then Miquel starts with fixes of the current code which came up
recently as we discussed (bouncing address/tx_skb leak/sifs/lifs
calculation/etc.). If this is done, we can take the rest of the
patches.
I am pretty sure Stefan can help here to get the right things sorted
out between wpan/wpan-next. At the end he will make the next step by
sending a pull-request to you.

- Alex
