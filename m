Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF2265C14A
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 14:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237693AbjACNz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 08:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237645AbjACNzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 08:55:25 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A84FFF2;
        Tue,  3 Jan 2023 05:55:24 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id x22so73725769ejs.11;
        Tue, 03 Jan 2023 05:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZtSxpSjX58ynpD01H51Yz32AIwKbxvwZO/htBdjgQhU=;
        b=NWvGHpwyDNWGPavMB83+2pIXyyjvNcMRZF7kNLcgZILW4LhyNZhueL9uCOFlYStAxX
         a5yChIeoLzAIk75K/SD7/Q6RmenE2Ie3nRtEN1YwUjEWUgzoUm2e/lc/WYLuV5BWrpnp
         cukx7TMS1vciDJqH1yho4Vd4gsunpPcGLS7+7LMwEGfoGhxODaGxVm0lEzbfSDbY+6dF
         jnVgQSrvead51nVPKMBVSmc70iMkIiVExjJBBARX1qoID8wQuJ9q+LgJBdmfU3gbAR/s
         hJ/j3B9j3VMqYr3OZ9z7yLXQAbMamIg0fWWnu4h56ZEfkZesTprxp3knCWqYs5GHsFAx
         d18A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZtSxpSjX58ynpD01H51Yz32AIwKbxvwZO/htBdjgQhU=;
        b=Y7l2Rd46SRcjCr299Ng9FW1d4fHcK8O6q/LuC2kNgWFOx/iY5Fshl0xoThy0xg+hWW
         bzmuxwIKwLPNgXJnfL2gXv9EM+g64kog892/xCdkdjpFE7H7GPB0LRl5u5MTmYoiTkoW
         YvYkrAUvgblY6jh4cczNWZJBjQUE9s/kpwrShsjgeoqwQjKCltKp+GB2hq/LnEa/esq+
         N7w0d2q1lD18CnlyBuXULHUOv0m9ikJlKxOCLVjUH5Dz27T9X3RJE7i+/NVKMyRI1gl4
         9eT+EVFr/EoV8mQXR7hHrlxAp/GeeiACYlg8LIK9ao0H0bDM1ZlY3FTTDxGC2hPZJrbC
         kA1g==
X-Gm-Message-State: AFqh2kpPQURzIQFDiwowId2hqIRhIT7orUFWSxNrVMCeV+ZU+jtUOuGw
        W/qJqNrPQ6G92A8TUMTpm8k=
X-Google-Smtp-Source: AMrXdXul+Qhor0TFBD82nysJpNI3VhxWK05SAKn9RHHdHtJl9+gmsiDFWAngpR8gHsFYoJeQk44dqA==
X-Received: by 2002:a17:907:7d8f:b0:7b5:911c:9b12 with SMTP id oz15-20020a1709077d8f00b007b5911c9b12mr46938748ejc.1.1672754122626;
        Tue, 03 Jan 2023 05:55:22 -0800 (PST)
Received: from skbuf ([188.26.185.118])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b0080345493023sm13998125ejt.167.2023.01.03.05.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 05:55:22 -0800 (PST)
Date:   Tue, 3 Jan 2023 15:55:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH RFC net-next v2 08/12] net: ethernet: freescale: xgmac:
 Separate C22 and C45 transactions for xgmac
Message-ID: <20230103135519.oai43rj3waigqi54@skbuf>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
 <20221227-v6-2-rc1-c45-seperation-v2-8-ddb37710e5a7@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v2-8-ddb37710e5a7@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit message can be: "net/fsl: xgmac_mdio: Separate C22 and C45 transactions".

On Wed, Dec 28, 2022 at 12:07:24AM +0100, Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> The xgmac MDIO bus driver can perform both C22 and C45 transfers.
> Create separate functions for each and register the C45 versions using
> the new API calls where appropriate.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> v2:
>  - [al] Move the masking of regnum into the variable declarations
>  - [al] Remove a couple of blank lines

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  
> -/*
> - * Reads from register regnum in the PHY for device dev, returning the value.
> +/* Reads from register regnum in the PHY for device dev, returning the value.
>   * Clears miimcom first.  All PHY configuration has to be done through the
>   * TSEC1 MIIM regs.
>   */

I have some reservations regarding the utility of the comments in this
driver. It's surely not worth duplicating them between C22 and C45.
It might also be more productive to just delete them, because:

 - miimcom is a register accessed by fsl_pq_mdio.c, not by xgmac_mdio.c
 - "device dev" doesn't really refer to anything (maybe "dev_addr").
 - I don't understand what is meant by the comment "All PHY configuration
   has to be done through the TSEC1 MIIM regs". Or rather said, I think I
   understand, but it is irrelevant to the driver for 2 reasons:
    * TSEC devices use the fsl_pq_mdio.c driver, not this one
    * It doesn't matter to this driver whose TSEC registers are used for
      MDIO access. The driver just works with the registers it's given,
      which is a concern for the device tree.
 - barring the above, the rest just describes the MDIO bus API, which is
   superfluous
