Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCB11FCA44
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 11:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgFQJ5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 05:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgFQJ5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 05:57:35 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA7AC061573
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 02:57:35 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id p18so1439918eds.7
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 02:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sieVdZ+7zUvBZAtBXeOWbxtzA5potHsDOyp/idhrePM=;
        b=Wkr9Q41M2X/qwgshCpyGBYQVLBFgxOwo38Bxwg3xB3jRTgGETAms4rO7GuL7ooxVjX
         WVlbc7nKpqR1eTn0jQX1eMPJASJFrzDUXlH3J/YkQN8w23xIa00T3TMlxKZtwUuDTGur
         CNssiBxB4CeGnGMJ9wbDFSBE5gOB7D94pXTaIqKwYN9cG2w/jwjfIPachTaUfcCzDVCZ
         jjaEMUp0WNmCJ94gmNBxF5bS6TYs7foeXc/yBJa3fPxAZ7lCG7828HRoPEGxuxCciwxq
         FiAVCNHY0G4wMiqkRXCzWmIA3bQlT5gyc6zLFw95vYR+1ps/J3ehMK74Pa8cKHr89N79
         uKUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sieVdZ+7zUvBZAtBXeOWbxtzA5potHsDOyp/idhrePM=;
        b=lw6JWdAmUdl4L/fAodjuRHCYXfm+e71oEUBau8IJrzc+hYJUG1tX3NYwep/jMzs9B8
         Pqa1nrI0DNCADmNnPKmy+kHoajyvtgHMi+i1HbiBfLkrwp6N8wYOCnHcrVdGgdKFsK3L
         TKUJTD767SQ3yKv1jQFAongSNgg3SokC7oSA/6pBdAbmi41C0vJJ24ME67iXvkqHRpBY
         YDdhwFsiEKHei8/NCM5Y/uJRQZdv0lg2fhlIJa4kTpXWy4+2xk/ucSw4dgl5BJbGDPSp
         A3K9d+YCoDDWg2n/VjkD870fBXXbtlJmOfhlwJdYAxvSkjIiEqbcF7znhUz02phNdMz8
         Fojg==
X-Gm-Message-State: AOAM531Sa+XqVTweTuRzQYBvACLg6D+WjRn+MNLhY5ute9lJSuTJ8IVD
        36BVCsyNMfqSGSDjsBMapzrYUlsdWO+i5mTpD3kh0Q==
X-Google-Smtp-Source: ABdhPJzTngRr9JwF9z9PHWCX59xuO+mLXB8BjoiIRDATv7HdVmYR4VApKYJXxMSpvpM9t4wsIuWts2GS1SjUq0Dwvcs=
X-Received: by 2002:a50:fb0b:: with SMTP id d11mr6678075edq.118.1592387853957;
 Wed, 17 Jun 2020 02:57:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200616074955.GA9092@laureti-dev>
In-Reply-To: <20200616074955.GA9092@laureti-dev>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 17 Jun 2020 12:57:23 +0300
Message-ID: <CA+h21hoTQzGwF5wYx3-0Fa_rUYWw+m2CVcBV8WUQ7OtK3DHpQA@mail.gmail.com>
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Helmut,

On Tue, 16 Jun 2020 at 11:00, Helmut Grohne <helmut.grohne@intenta.de> wrote:
>
> The macb driver does not support configuring rgmii delays. At least for
> the Zynq GEM, delays are not supported by the hardware at all. However,
> the driver happily accepts and ignores any such delays.
>
> When operating in a mac to phy connection, the delay setting applies to
> the phy. Since the MAC does not support delays, the phy must provide
> them and the only supported mode is rgmii-id.  However, in a fixed mac
> to mac connection, the delay applies to the mac itself. Therefore the
> only supported rgmii mode is rgmii.
>
> Link: https://lore.kernel.org/netdev/20200610081236.GA31659@laureti-dev/
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 5b9d7c60eebc..bee5bf65e8b3 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -514,7 +514,7 @@ static void macb_validate(struct phylink_config *config,
>             state->interface != PHY_INTERFACE_MODE_RMII &&
>             state->interface != PHY_INTERFACE_MODE_GMII &&
>             state->interface != PHY_INTERFACE_MODE_SGMII &&
> -           !phy_interface_mode_is_rgmii(state->interface)) {
> +           state->interface != PHY_INTERFACE_MODE_RGMII_ID) {

I don't think this change is correct though?
What if there were PCB traces in place, for whatever reason? Then the
driver would need to accept a phy with rgmii-txid, rgmii-rxid or
rgmii.

>                 bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>                 return;
>         }
> @@ -694,6 +694,13 @@ static int macb_phylink_connect(struct macb *bp)
>         struct phy_device *phydev;
>         int ret;
>
> +       if (of_phy_is_fixed_link(dn) &&
> +           phy_interface_mode_is_rgmii(bp->phy_interface) &&
> +           bp->phy_interface != PHY_INTERFACE_MODE_RGMII) {
> +               netdev_err(dev, "RGMII delays are not supported\n");
> +               return -EINVAL;
> +       }
> +

Have you checked that this doesn't break any existing in-tree users?

>         if (dn)
>                 ret = phylink_of_phy_connect(bp->phylink, dn, 0);
>
> --
> 2.20.1
>

Thanks,
-Vladimir
