Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845276D8477
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbjDERDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbjDERDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:03:30 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4146A41;
        Wed,  5 Apr 2023 10:02:20 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-17786581fe1so39204302fac.10;
        Wed, 05 Apr 2023 10:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680714139;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wJdooDkKozVkmq/jE5ZIJWHR45XBypuBSfKalkLMI0w=;
        b=lhndkTBq464U/Xt0gXIA3bzt6cy6hrEA9CqJAkmYdK2UONW6KBlkuDpUphZApxzZ9o
         yH+WHRlywqpAaRY1ZtroZg+JfQkLAfyKahIkrCYlwB8BXLszNLKTUN0LxaTxuFJpxv/J
         S2qbhbPM09ZG6KYFJPTlz29MDb3EjQCWPS/ogkmwnK4Ok3hQVrUk8DaF1hLSvfHFz2MM
         IN/5d8GU44EBeqpNMLWKF4dmwjDfDmJYym1vvYwa+NWi0bSwStQADBYpJ2H27HZ2SAUm
         +VswydxOZfluEWZLiH8oDcX3aCdtzHI8rUg8jISF3gXISZ067fWckPPrRZxI4ec1rMwD
         FOHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680714139;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wJdooDkKozVkmq/jE5ZIJWHR45XBypuBSfKalkLMI0w=;
        b=uhrshRQ1Cs7Ukpkh2G+Lu1ccU0gLGHT40clpt2j31M+b0xYREAXWkIK4pDPWZ8mVHw
         5Q0AK4OJSyh7sIngKMKP4OvlsFDck+eSwEVy2K3+6vX2v36DFYEKvbUiwuhyDGdKWE0I
         Dja+M9r2pTEZnyDB/DsWuABCgj3ZtzVPGgi4xAfZz5DALZ/knxvhFqi0HfQBg89BGW0+
         d+JwjdW188Ei6Msn6jhJ19yrjdlFOOl2AISKu78LsTG1U4UIBEotm+hICqBuEUpc0U8y
         TU8WWFRezPSqhZOtqPZGYlTqfWNzpKzCKRpjJPjhMjiaUfuxvSMuMdhZ/iArD4xmTabk
         6tfQ==
X-Gm-Message-State: AAQBX9ewaMjkHgqN0u1qOye8uJUossttIvCXeR/ilUTBw6RE6Otfu+B4
        M12R59k2dHynCo9NIuwk6Rg=
X-Google-Smtp-Source: AKy350Y+q+FZUc+o6NJRWKav1W5Jicca/zmUWi5GHYLjZcSC8DIl2a9Q6sS0FbYDYCYe31KADbNeuQ==
X-Received: by 2002:a05:6870:6025:b0:17a:cb34:758a with SMTP id t37-20020a056870602500b0017acb34758amr4109941oaa.34.1680714139060;
        Wed, 05 Apr 2023 10:02:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s15-20020a0568301e0f00b006a1508d348dsm7177806otr.22.2023.04.05.10.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 10:02:18 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 5 Apr 2023 10:02:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: Re: [PATCH net v3 2/3] net: stmmac: check if MAC needs to attach to
 a PHY
Message-ID: <5bb39f85-7ef0-4cbb-a06b-0d6431ab09b7@roeck-us.net>
References: <20230324081656.2969663-1-michael.wei.hong.sit@intel.com>
 <20230324081656.2969663-3-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324081656.2969663-3-michael.wei.hong.sit@intel.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Mar 24, 2023 at 04:16:55PM +0800, Michael Sit Wei Hong wrote:
> After the introduction of the fixed-link support, the MAC driver
> no longer attempt to scan for a PHY to attach to. This causes the
> non fixed-link setups to stop working.
> 
> Using the phylink_expects_phy() to check and determine if the MAC
> should expect and attach a PHY.
> 
> Fixes: ab21cf920928 ("net: stmmac: make mdio register skips PHY scanning for fixed-link")
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> Signed-off-by: Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>

With this patch in linux-next, the orangepi-pc qemu emulation fails to
bring up the Ethernet interface. The following error is seen.

[   12.482401] dwmac-sun8i 1c30000.ethernet eth0: Register MEM_TYPE_PAGE_POOL RxQ-0
[   12.487789] dwmac-sun8i 1c30000.ethernet eth0: PHY [mdio_mux-0.1:01] driver [Generic PHY] (irq=POLL)
[   12.488177] dwmac-sun8i 1c30000.ethernet eth0: no phy found
[   12.488295] dwmac-sun8i 1c30000.ethernet eth0: __stmmac_open: Cannot attach to PHY (error: -19)

Reverting this patch fixes the problem.

> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 8f543c3ab5c5..41f0f3b74933 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1135,6 +1135,7 @@ static int stmmac_init_phy(struct net_device *dev)
>  {
>  	struct stmmac_priv *priv = netdev_priv(dev);
>  	struct fwnode_handle *fwnode;
> +	bool phy_needed;
>  	int ret;
>  
>  	fwnode = of_fwnode_handle(priv->plat->phylink_node);
> @@ -1144,10 +1145,11 @@ static int stmmac_init_phy(struct net_device *dev)
>  	if (fwnode)
>  		ret = phylink_fwnode_phy_connect(priv->phylink, fwnode, 0);
>  
> +	phy_needed = phylink_expects_phy(priv->phylink);
>  	/* Some DT bindings do not set-up the PHY handle. Let's try to
>  	 * manually parse it
>  	 */
> -	if (!fwnode || ret) {
> +	if (!fwnode || phy_needed || ret) {

I don't really understand this condition. It starts taking this path even if ret == 0
and fwnode != NULL if phy_needed is set. That means this path is now taken even if
phylink_fwnode_phy_connect() returned no error. That seems odd.

Guenter

>  		int addr = priv->plat->phy_addr;
>  		struct phy_device *phydev;
>  
> -- 
> 2.34.1
> 
