Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E96C1C79C4
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 20:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgEFS6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 14:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730414AbgEFS6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 14:58:09 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D609C0610D6
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 11:58:07 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id s9so2281505lfp.1
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 11:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2hhU7YC1mHWJXOQCa9/YtvMX0AvTF/51BQ11Lkp2if0=;
        b=ENs11Z2E6PTphR/O7XEptV9DrkitQZwLiWGfUE3J1NThoeRLPWDK4tDps5BoTcWit1
         zxwc6iaDbar5hppPTNmyGg+DQIeMEcKomHQdFBhyU8VETMfHL8W2a1Jd5FtPT4MSFPlx
         pW5uAwDfiblCrXtvPdUyMV5XllzXhrrMlu3/oW6uuJTz36qgimok4gbXBH4xnjVurcCX
         lcUe+U7g7T87tsCxaKgUy1ztqhvZkOlPI1dRGORUz42KQ/uPPuoOll0V3+DBw/rjO1OW
         I1Q/zUwoATalGf6bzwzmulWBAfKNsUBbxb1ZM1A5ACSkMtfwmtHD9gRLESdsOugAfng+
         xmww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2hhU7YC1mHWJXOQCa9/YtvMX0AvTF/51BQ11Lkp2if0=;
        b=W3bWkBjuwA3Xe5pZD3w9cZXKZ1bwjyJnXiep8B6rOPJ0dxkJkKol163l3qD/H9HOaf
         MgFRZqDNeTik1PaByFfxFkXo7/lhBVDoFuq1H3c2tD1JwIBn90BEJWa4zkkRyjgSrjnR
         Fj/4Cbg5/D0+E2BlBbpotMNXpOG8RdbrCWWEH7kKAIzz5vXuHAXxNPRGijuAGf1iRJRD
         pmMl3rx2ndfw7rIWmIcyOkxkcJnJruLyhiBPyaj5IvBZMX1KGWrSKR2IgaoBoCdxELkL
         OqbeVuiEBrL/5wmD6x+czn90uMAqoWCnm2zPxELwywX83q5e87pcWejT7oAOZoFlEGob
         7mBA==
X-Gm-Message-State: AGi0PuYVa8YcL+4GWJaKUHHwl72wScRxQpAgDgWiAFb08yDZlLt3HwMa
        MuyGuko7/0CR1QjG5uB5ZCfWxHD3w3wWxB7FeZCIXg==
X-Google-Smtp-Source: APiQypK2/BS9DNLQgUdve0DnZIP+ggCdF8l9P6mtknH7uy4q8+KLPietCh0cyMKc+/gJFltqkIhzsPf/UxXxP4Q5v8I=
X-Received: by 2002:a19:40d2:: with SMTP id n201mr6168784lfa.82.1588791485423;
 Wed, 06 May 2020 11:58:05 -0700 (PDT)
MIME-Version: 1.0
References: <1480357509-28074-1-git-send-email-johan@kernel.org> <1480357509-28074-12-git-send-email-johan@kernel.org>
In-Reply-To: <1480357509-28074-12-git-send-email-johan@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 7 May 2020 00:27:53 +0530
Message-ID: <CA+G9fYvBjUVkVhtRHVm6xXcKe2+tZN4rGdB9FzmpcfpaLhY1+g@mail.gmail.com>
Subject: Re: [PATCH net 11/16] net: ethernet: marvell: mvneta: fix fixed-link
 phydev leaks
To:     Johan Hovold <johan@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Nov 2016 at 00:00, Johan Hovold <johan@kernel.org> wrote:
>
> Make sure to deregister and free any fixed-link PHY registered using
> of_phy_register_fixed_link() on probe errors and on driver unbind.
>
> Fixes: 83895bedeee6 ("net: mvneta: add support for fixed links")
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 0c0a45af950f..707bc4680b9b 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -4191,6 +4191,8 @@ static int mvneta_probe(struct platform_device *pdev)
>         clk_disable_unprepare(pp->clk);
>  err_put_phy_node:
>         of_node_put(phy_node);
> +       if (of_phy_is_fixed_link(dn))
> +               of_phy_deregister_fixed_link(dn);

While building kernel Image for arm architecture on stable-rc 4.4 branch
the following build error found.

drivers/net/ethernet/marvell/mvneta.c:3442:3: error: implicit
declaration of function 'of_phy_deregister_fixed_link'; did you mean
'of_phy_register_fixed_link'? [-Werror=implicit-function-declaration]
|    of_phy_deregister_fixed_link(dn);
|    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
|    of_phy_register_fixed_link

ref:
https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/541374729

- Naresh
