Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC905A661D
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 16:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiH3OUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 10:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiH3OUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 10:20:22 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9309D4C634
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 07:20:18 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b16so14421249edd.4
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 07:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=jqUJXzQE4D72GHYet0436bMgHV7BRsy0piXr5HVcBNQ=;
        b=PlAycABxxlfGdZVcE+tivA3o4nQaIDKgHCWJv4CrcfR2ZfEIpjs07W98gje13w1Qx0
         bKvjCfCdrKCo0sF62ffe0wIFSw9qBNcbQGaZu95+eu06XkAykYSrxYvkEg3v273EtchR
         UHUlizU8AMlCbVgqesvrnaK3X3/bD8F5cVkOTFg8t6PkokdM54H9olnkDUN5a4VLW1UR
         5xN1depNqGWBuJhxRTKxsfx70TEJXfzv/ocnbk/ljmAS52IYjBRig3doXDrPlmROdIs/
         RFY7Iw3px82KdeOoGOQe0i5OhlQZp9njOpewr7AqOrcZgjftUwdP4djpArqCvAlBi9l1
         0+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=jqUJXzQE4D72GHYet0436bMgHV7BRsy0piXr5HVcBNQ=;
        b=Q+NarhKAHkJcdjzhLWFL2Q1quWGqYvQHAhTCcFJs+5aWooWHsR5vB2VwyUs2ShME52
         pR3xJ0spSXH4KAVB+2MIrTwuI+O3ridr6N8xlHS6F7QX/qdBB1XmGXkJ4POpjJRzPw7q
         XdNtgV/Wv6M/gpBatIUC1tfcIeu4WT5nyUqRfdLab4e/u8gdIZqe80SLwwxi/jigtB+i
         temPurIKGh6vDl5VLyh4w6zJpKEwVO+e/k3r+fxw+8LNOn/MLgal43bPNu6nd6zwPiMH
         GlS6O5M5UKruuuIhNFrRs98tbeayStpXKyrgys4GA7AlmGUPFys8QG8yLf+eH/z7pWZj
         buAQ==
X-Gm-Message-State: ACgBeo0OOQ5V1vr1rkmoG1cZkXbQuitcEroZN7wK/JOw9ARLQOzfK+W5
        gbtuBZ1eB4GYIIOt4/dJnMk=
X-Google-Smtp-Source: AA6agR7nZ/FHeeBgzIU8wptjZuYFHR6q7NSHwxzDOOExRAa0TZ8d1MXRO7hF6NtwRVG+CQkBxtxcvw==
X-Received: by 2002:a05:6402:379:b0:448:de41:2c0c with SMTP id s25-20020a056402037900b00448de412c0cmr1523313edw.290.1661869216793;
        Tue, 30 Aug 2022 07:20:16 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090623ea00b0073cdeedf56fsm2978262ejg.57.2022.08.30.07.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 07:20:16 -0700 (PDT)
Date:   Tue, 30 Aug 2022 17:20:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 3/3] rmon: Use RMU if available
Message-ID: <20220830142014.pytgaiacq2iq2rka@skbuf>
References: <20220826063816.948397-1-mattias.forsblad@gmail.com>
 <20220826063816.948397-4-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826063816.948397-4-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Forsblad,

On Fri, Aug 26, 2022 at 08:38:16AM +0200, Mattias Forsblad wrote:
> If RMU is supported, use that interface to
> collect rmon data.

A more adequate commit message would be:

net: dsa: mv88e6xxx: use RMU to collect RMON stats if available

But then, I don't think the splitting of patches is good. I think
mv88e6xxx_inband_rcv(), the producer of rmu_raw_stats[], should be
introduced along with its consumer. Otherwise I have to jump between one
patch and another to be able to comment and see things.

Also, it would be good if you could consider actually reporting the RMON
stats through the standardized interface (ds->ops->get_rmon_stats) and
ethtool -S lan0 --groups rmon, rather than just unstructured ethtool -S.

> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 41 ++++++++++++++++++++++++++------
>  1 file changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 4c0510abd875..0d0241ace708 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1226,16 +1226,30 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
>  				     u16 bank1_select, u16 histogram)
>  {
>  	struct mv88e6xxx_hw_stat *stat;
> +	int offset = 0;
> +	u64 high;
>  	int i, j;
>  
>  	for (i = 0, j = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
>  		stat = &mv88e6xxx_hw_stats[i];
>  		if (stat->type & types) {
> -			mv88e6xxx_reg_lock(chip);
> -			data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
> -							      bank1_select,
> -							      histogram);
> -			mv88e6xxx_reg_unlock(chip);
> +			if (chip->rmu.ops && chip->rmu.ops->get_rmon &&
> +			    !(stat->type & STATS_TYPE_PORT)) {
> +				if (stat->type & STATS_TYPE_BANK1)
> +					offset = 32;
> +
> +				data[j] = chip->ports[port].rmu_raw_stats[stat->reg + offset];
> +				if (stat->size == 8) {
> +					high = chip->ports[port].rmu_raw_stats[stat->reg + offset
> +							+ 1];
> +					data[j] += (high << 32);

What exactly protects ethtool -S, a reader of rmu_raw_stats[], from
reading an array that is concurrently overwritten by mv88e6xxx_inband_rcv?

> +				}
> +			} else {
> +				mv88e6xxx_reg_lock(chip);
> +				data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
> +								      bank1_select, histogram);
> +				mv88e6xxx_reg_unlock(chip);
> +			}
>  
>  			j++;
>  		}
> @@ -1304,8 +1318,8 @@ static void mv88e6xxx_get_stats(struct mv88e6xxx_chip *chip, int port,
>  	mv88e6xxx_reg_unlock(chip);
>  }
>  
> -static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
> -					uint64_t *data)
> +static void mv88e6xxx_get_ethtool_stats_mdio(struct dsa_switch *ds, int port,
> +					     uint64_t *data)
>  {
>  	struct mv88e6xxx_chip *chip = ds->priv;
>  	int ret;
> @@ -1319,7 +1333,20 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
>  		return;
>  
>  	mv88e6xxx_get_stats(chip, port, data);
> +}
>  
> +static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
> +					uint64_t *data)
> +{
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +
> +	/* If initialization of RMU isn't available
> +	 * fall back to MDIO access.
> +	 */
> +	if (chip->rmu.ops && chip->rmu.ops->get_rmon)

I would create a helper

static bool mv88e6xxx_rmu_available(struct mv88e6xxx_chip *chip)

and use it here and everywhere, for clarity. Testing the presence of
chip->rmu.ops is not wrong, but confusing.

Also, testing chip->rmu.ops->get_rmon gains exactly nothing, since it is
never NULL when chip->rmu.ops isn't NULL.

> +		chip->rmu.ops->get_rmon(chip, port, data);
> +	else
> +		mv88e6xxx_get_ethtool_stats_mdio(ds, port, data);
>  }
>  
>  static int mv88e6xxx_get_regs_len(struct dsa_switch *ds, int port)
> -- 
> 2.25.1
> 
