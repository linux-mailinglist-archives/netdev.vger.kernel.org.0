Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B55403F55
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 21:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350276AbhIHTEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 15:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349845AbhIHTEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 15:04:01 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F545C061575;
        Wed,  8 Sep 2021 12:02:53 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id v16so3414786ilo.10;
        Wed, 08 Sep 2021 12:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x2FDPr6yRtupQhLE4miDTkWgI4YgoogIHLlJR7Xih1A=;
        b=Rpo6d0wlBs2UZEoJBrspoTCPbB2wxnXk64z2+Lqv1mJmSmcQ+UxeUZ1F3PHDBA0V+G
         J/OOqo7iHAaV3MtLlLFhy40oXQiMJ4Dk9b1xUwH9/C18SQaHZ1EqjaesKfFwkvAjSasc
         HRBanr/V7It5mDM9hQEd7vSWJG4hthhYhWrecwzSZTj4ckK3GikSxTs9APJn7XpElsJo
         apviXdoVWetpabXwpu/p9vcU9128w+FNMdwHUukwQlve/Q9DO3ox0xwWZsZtaJJaLANj
         OgtEmPEXsPSPHaKtxQy6zRLaLg4r4rdWqrqehYWhb7H1EsuhuOvyAL+uMOMwcDOQySNu
         kYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x2FDPr6yRtupQhLE4miDTkWgI4YgoogIHLlJR7Xih1A=;
        b=GO9mU8T8Ir6fpGdeYcvrbTbP+WuGNzTufelKM0AaFrO4oSAVvsFl0G0fUq1hvpSzu2
         +LWDr+uzFN+8VNE4cVgpuIXlNeBgn7XrU6whWEgP6gTAQySgnpagthqlKhBZ4CyZfL9O
         r91VOw2W6FkhVZRgnhM5DuNhePvtnKy2nJXLTMPlmz9orZFg2v9KUYkoJRZqk/D4cldV
         zWR+7NyNUx+ndCHYAOFZZT+72OGsIvJvdIonmqXKJsl34RJDGElBvwnHt/EwWmAgEReA
         H4TYWcW/boPVP36LGSR7k+cjC02DzJjDyrqZHofInSX3xaB8RCbacqwFwOvQwxsMNQBG
         HVKw==
X-Gm-Message-State: AOAM530IIuAknRli4HwO7JBjo0dKekKmG/a4+LmTEI1lixqJkr2bTW4t
        GIS4unjdv9M5dOiuLx44Kj0Ch3ZS00AphAt2CUTS88n/Cbs=
X-Google-Smtp-Source: ABdhPJxdPQMgyqHVHO5RULubySm78Aw9INUL0p+riw8HzmRchTllzs2uPB3wmmDJl0sO2kgvFC0wIv/Obda2aVoUxC8=
X-Received: by 2002:a92:1304:: with SMTP id 4mr1043255ilt.196.1631127772901;
 Wed, 08 Sep 2021 12:02:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210907202958.692166-1-ztong0001@gmail.com> <48b53487-a708-ec79-a993-3448f4ca6e6d@microchip.com>
In-Reply-To: <48b53487-a708-ec79-a993-3448f4ca6e6d@microchip.com>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Wed, 8 Sep 2021 12:02:41 -0700
Message-ID: <CAA5qM4CtA7mQ5ph8t5Da2zz08zuLOCocYYkHVTdM_rPS_xYJkA@mail.gmail.com>
Subject: Re: [PATCH v1] net: macb: fix use after free on rmmod
To:     Nicolas Ferre <Nicolas.Ferre@microchip.com>
Cc:     Claudiu Beznea <Claudiu.Beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Nicolas, sent a v2 as suggested.
- Tong

On Wed, Sep 8, 2021 at 12:27 AM <Nicolas.Ferre@microchip.com> wrote:
>
> On 07/09/2021 at 22:29, Tong Zhang wrote:
> > plat_dev->dev->platform_data is released by platform_device_unregister(),
> > use of pclk and hclk is use after free. This patch keeps a copy to fix
> > the issue.
> >
> > [   31.261225] BUG: KASAN: use-after-free in macb_remove+0x77/0xc6 [macb_pci]
> > [   31.275563] Freed by task 306:
> > [   30.276782]  platform_device_release+0x25/0x80
> >
> > Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> > ---
> >   drivers/net/ethernet/cadence/macb_pci.c | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
> > index 8b7b59908a1a..4dd0cec2e542 100644
> > --- a/drivers/net/ethernet/cadence/macb_pci.c
> > +++ b/drivers/net/ethernet/cadence/macb_pci.c
> > @@ -110,10 +110,12 @@ static void macb_remove(struct pci_dev *pdev)
> >   {
> >          struct platform_device *plat_dev = pci_get_drvdata(pdev);
> >          struct macb_platform_data *plat_data = dev_get_platdata(&plat_dev->dev);
> > +       struct clk *pclk = plat_data->pclk;
> > +       struct clk *hclk = plat_data->hclk;
> >
> >          platform_device_unregister(plat_dev);
> > -       clk_unregister(plat_data->pclk);
> > -       clk_unregister(plat_data->hclk);
> > +       clk_unregister(pclk);
> > +       clk_unregister(hclk);
>
> NACK, I  would prefer that you switch lines and do clock clk unregister
> before: this way we avoid the problem and I think that you don't need
> clocks for unregistering the platform device anyway.
>
> Please change accordingly or tell me what could go bad.
>
> Regards,
>    Nicolas
>
>
> >   }
> >
> >   static const struct pci_device_id dev_id_table[] = {
> > --
> > 2.25.1
> >
>
>
> --
> Nicolas Ferre
