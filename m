Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01775519D50
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 12:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348286AbiEDKwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 06:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235739AbiEDKwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 06:52:42 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164A620BF1
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 03:49:07 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bv19so2090482ejb.6
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 03:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nn0IhisrDuZS+6qN6ZcSTLAfNs6wYkQhRvdAbj5Qq2c=;
        b=jacci/99xqMScveVviuGYqBF9JbzkzkGBRh+IUGBCm2+0/RDBB+IXIcNcF20DKCVM7
         tPY9zw26ZZD+s7gludbFGJennjEXHBo3TEF1xKQ9YipxK4FPeeYLUge0FzQmpASEku9S
         ZPHVuaKcpbcM/YzX7Yr507gCBwEkJcSGbZUmB9Z8pXtXiJCkuZoOZfMkNnnQ+g99dpu1
         mYXcyGdqWbJKWAMDaJxO9+RANkrQYLBCiJssLZccy13cmSEAdw1s9nODjpNoCO8rXPLp
         mxqjj4WB6+LgDiaizn+Pz4B+YKsfU9l+OBEvWE2AFZNYnCfD+0DXsBlyWgoUDVo9IdwO
         1aOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nn0IhisrDuZS+6qN6ZcSTLAfNs6wYkQhRvdAbj5Qq2c=;
        b=A3ETJO9TtPU16xSHrLmHKs1iPnyDbqsQZ76nyAmKSrRoaYt/XhYao/aZAUNsR/M1L5
         uZA+JQb+F7YhnLY3IcSe8OnLfD7O5lAoZlhKQgTLaQiZoQ6iHIdgcv7bxAoWoRWHF7rJ
         VSvxaEn81cdKvVirczzO/zOXiIzjTnFiR0pHT/9a2KJsQaCi1combvsdzxFnr8SAejGB
         AChUOjTvXhtdz7jqc/4SQ/LYn9UtECKbUPM2bG2R1T+jUm9YkF0YMfAnJtpC0OQrZ7k+
         kcLAXuloEghCT8m1lFA4eReh6w8NGpmPSZ7Nni+5EoAxRPlwXfHrRvfbhBFv7xgzJrRK
         oaXA==
X-Gm-Message-State: AOAM531P5ArEorNkSHPr/0sK+psjCp7Rz5dJN5ubqp3Rhj2oduQ+1sZs
        PakQr57nu7zUEm2a0+4SGqy9J+wxWjSwlgCuTJQ=
X-Google-Smtp-Source: ABdhPJziNj0PUTU+CpDNK7ynvBhx1JxmqZSOU6YWG+7bX+z/vR0T0EeExyPIO8PKJR0h3Z1ddcIIeRJhR2UJV0gsCHQ=
X-Received: by 2002:a17:906:2646:b0:6d5:d889:c92b with SMTP id
 i6-20020a170906264600b006d5d889c92bmr20300706ejc.696.1651661345566; Wed, 04
 May 2022 03:49:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAOMZO5BwYSgMZYHJcxV9bLcSQ2jjdFL47qr8o8FUj75z8SdhrQ@mail.gmail.com>
In-Reply-To: <CAOMZO5BwYSgMZYHJcxV9bLcSQ2jjdFL47qr8o8FUj75z8SdhrQ@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 4 May 2022 07:48:56 -0300
Message-ID: <CAOMZO5AJRTfja47xGG6nzLdC7Bdr=r5K0FVCcgMvN05XSb7LhA@mail.gmail.com>
Subject: Re: imx6sx: Regression on FEC with KSZ8061
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 4, 2022 at 7:24 AM Fabio Estevam <festevam@gmail.com> wrote:
>
> Hi,
>
> On an imx6sx-based board, the Ethernet is functional on 5.10.
>
> The board has a KSZ8061 Ethernet PHY.
>
> After moving to kernel 5.15 or 5.17, the Ethernet is no longer functional:
>
> # udhcpc -i eth0
> udhcpc: started, v1.35.0
> 8<--- cut here ---
> Unable to handle kernel NULL pointer dereference at virtual address 00000008
> pgd = f73cef4e
> [00000008] *pgd=00000000
> Internal error: Oops: 5 [#1] SMP ARM
> Modules linked in:
> CPU: 0 PID: 196 Comm: ifconfig Not tainted 5.15.37-dirty #94
> Hardware name: Freescale i.MX6 SoloX (Device Tree)
> PC is at kszphy_config_reset+0x10/0x114

By adding this change, we can see that priv is NULL:

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -508,8 +508,12 @@ static int kszphy_nand_tree_disable(struct phy_device *phyd
ev)
 /* Some config bits need to be set again on resume, handle them here. */
 static int kszphy_config_reset(struct phy_device *phydev)
 {
-       struct kszphy_priv *priv = phydev->priv;
        int ret;
+       struct kszphy_priv *priv = phydev->priv;
+       if (!priv) {
+               pr_err("*********** priv is NULL\n");
+               return -ENOMEM;
+       }

        if (priv->rmii_ref_clk_sel) {

udhcpc: started, v1.35.0
[   14.754823] *********** priv is NULL
[   14.754863] Micrel KSZ8061 2188000.ethernet-1:00: attached PHY
driver (mii_bus:phy_addr=2188000.ethernet-1:00, irq=POLL)
[   14.757024] *********** priv is NULL
udhcpc: broadcasting discover
udhcpc: broadcasting discover
udhcpc: broadcasting discover

Any ideas?

Thanks
