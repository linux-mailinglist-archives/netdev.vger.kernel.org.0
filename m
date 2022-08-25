Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC225A094C
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 08:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236545AbiHYG6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 02:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbiHYG6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 02:58:40 -0400
Received: from comms.puri.sm (comms.puri.sm [159.203.221.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32031A033A;
        Wed, 24 Aug 2022 23:58:39 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 6170AE1171;
        Wed, 24 Aug 2022 23:58:08 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GMMjKO_RXaO4; Wed, 24 Aug 2022 23:58:07 -0700 (PDT)
Message-ID: <2c609579d9fba41a6fcbd47788ccbcf1f4fa0f2a.camel@puri.sm>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=puri.sm; s=comms;
        t=1661410687; bh=UO5XV5GOXaJUp2qheZTnBxncOA0cWICbUUFp+tuLMbo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kTNNzvR2unUbjb/QrtWtKSeMmYzYcFAS16woPrlSBmRiA2zqPbeZXMFoteeotSVd2
         ppqFKvvx7uXdbF2CSEkzcahDUHlhTWo7t+mteq1axuIzsIzgr4rFpRL/tyktQzvTfr
         gdCD78kRakHzVg5aTF12FitR19ugqiI6DzKrT3B4BVV/yIbKklbOW3V8EPeTtL1d6O
         024kx31apwQCB3/AHVgZU7PI3qjCYI84z2hhvXGli0SKptH6FlIGVNaG6MAxzHoXvi
         0mCDg9w0r4DbdJKLAqAfDQz8fIDPXFwUpcfcrlniMnbs5Dl+nspO2khLZ8kY/Vmkfm
         gh0HTHw33Jzxw==
Subject: Re: [PATCH v2 3/4] Revert "PM: domains: Delete usage of
 driver_deferred_probe_check_state()"
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peng Fan <peng.fan@nxp.com>, Luca Weiss <luca.weiss@fairphone.com>,
        Doug Anderson <dianders@chromium.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Tony Lindgren <tony@atomide.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Philippe Brucker <jpb@kernel.org>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux.dev,
        netdev@vger.kernel.org
Date:   Thu, 25 Aug 2022 08:57:58 +0200
In-Reply-To: <20220819221616.2107893-4-saravanak@google.com>
References: <20220819221616.2107893-1-saravanak@google.com>
         <20220819221616.2107893-4-saravanak@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, dem 19.08.2022 um 15:16 -0700 schrieb Saravana Kannan:
> This reverts commit 5a46079a96451cfb15e4f5f01f73f7ba24ef851a.
> 
> Quite a few issues have been reported [1][2][3][4][5][6] on the
> original
> commit. While about half of them have been fixed, I'll need to fix
> the rest
> before driver_deferred_probe_check_state() can be deleted. So, revert
> the
> deletion for now.
> 
> [1] -
> https://lore.kernel.org/all/DU0PR04MB941735271F45C716342D0410886B9@DU0PR04MB9417.eurprd04.prod.outlook.com/
> [2] - https://lore.kernel.org/all/CM6REZS9Z8AC.2KCR9N3EFLNQR@otso/
> [3] -
> https://lore.kernel.org/all/CAD=FV=XYVwaXZxqUKAuM5c7NiVjFz5C6m6gAHSJ7rBXBF94_Tg@mail.gmail.com/
> [4] - https://lore.kernel.org/all/Yvpd2pwUJGp7R+YE@euler/
> [5] -
> https://lore.kernel.org/lkml/20220601070707.3946847-2-saravanak@google.com/
> [6] -
> https://lore.kernel.org/all/CA+G9fYt_cc5SiNv1Vbse=HYY_+uc+9OYPZuJ-x59bROSaLN6fw@mail.gmail.com/
> 
> Fixes: 5a46079a9645 ("PM: domains: Delete usage of
> driver_deferred_probe_check_state()")
> Reported-by: Peng Fan <peng.fan@nxp.com>
> Reported-by: Luca Weiss <luca.weiss@fairphone.com>
> Reported-by: Doug Anderson <dianders@chromium.org>
> Reported-by: Colin Foster <colin.foster@in-advantage.com>
> Reported-by: Tony Lindgren <tony@atomide.com>
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Tested-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
>  drivers/base/power/domain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/base/power/domain.c
> b/drivers/base/power/domain.c
> index 5a2e0232862e..55a10e6d4e2a 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -2733,7 +2733,7 @@ static int __genpd_dev_pm_attach(struct device
> *dev, struct device *base_dev,
>                 mutex_unlock(&gpd_list_lock);
>                 dev_dbg(dev, "%s() failed to find PM domain: %ld\n",
>                         __func__, PTR_ERR(pd));
> -               return -ENODEV;
> +               return driver_deferred_probe_check_state(base_dev);
>         }
>  
>         dev_dbg(dev, "adding to PM domain %s\n", pd->name);

Fixes imx8mq where ENODEV results in:
[    1.048019] imx8m-blk-ctrl 38320000.blk-ctrl: error -ENODEV: failed
to attach power domain "bus"


Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>

thanks for fixing this,

                                martin


