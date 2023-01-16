Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77E566D1C5
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 23:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbjAPW0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 17:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbjAPW0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 17:26:09 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6211EFEF;
        Mon, 16 Jan 2023 14:26:07 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id hw16so59327389ejc.10;
        Mon, 16 Jan 2023 14:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Y/Srh2eSvyMyqsX1lsspFgvksvamPkm7S4MHuD02Ak=;
        b=HVweUNPGoJH9RCeCrM+OTDZUuJBdpfxtZJfNdjj3qOY72u8h/yPu8R4DtllpwEghef
         TVLA1hB4YG93ReyxkZwmgxBjKVyXvSIhDbIsJsXtXL4dRxhVUbZEyNHRjiGtuaAiWPPw
         DqG2eKAUPtQNTrhfk8i55rucVIA5nH6VwwEYqRdID6C9S3l96i7b3ma5vAJttn8mMYaM
         hZPXWrChdblUldU1FwwuxaxUqkEaUYEN0UL6KREQcppq0o7noYlmii07HNYb5S54a5BI
         +GR/dUa8+bBK+2ri34hl+lrC6AV4/wJMhxFxjsxMfiDt2vAGd612WUv5zCAQFP8MKNwo
         rPNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Y/Srh2eSvyMyqsX1lsspFgvksvamPkm7S4MHuD02Ak=;
        b=RD1uGKgbMWFLGxs88eK8ZQeZIr98MlgLrDxjaFkmW/PdFQ+88oXfsoXKQekkgDWz6V
         63RQ+9yORql9D81xzS7KXVIGDBcleCAr22MR3aO+gsH5qGfqqIURD/W08FoF1wEbmp5J
         1ocKImZsRHFr3orkeoIOS/7dtp/JIxhbg5t/vWWFWRFfjn8sdXRRpxWJMtD8bNZqY3WH
         oqCg0zKx3OgFD2qDcdMPxMtY2Oiok8fBn5VSqQU5BJwZSCp1sV6fFU0+n6xDHqJe3M8n
         Tb9aDORWOodcRA7hH9TgOoVZkFFhKBFLZfuSYgbyG4QBRYcMj4BHG34J37TkQXzQ8cRN
         zugg==
X-Gm-Message-State: AFqh2kqmOMyT9MGjmqBmnbvWsXLVHi1BD8VELyO5z3dSgfOy90pFFocu
        bNWPmCXGfjY4qQzPeEzyyec=
X-Google-Smtp-Source: AMrXdXtonRdzEGmNWff7KKJeTPZ0sMoxaQH2TuKWTgtNAnuORvp0jJTk3a5JOlKYpMl4UgTfJWTHwA==
X-Received: by 2002:a17:906:fcb5:b0:7c0:dac7:36ea with SMTP id qw21-20020a170906fcb500b007c0dac736eamr13886753ejb.66.1673907965592;
        Mon, 16 Jan 2023 14:26:05 -0800 (PST)
Received: from skbuf ([188.27.185.68])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906218900b0084cb4d37b8csm12385110eju.141.2023.01.16.14.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 14:26:05 -0800 (PST)
Date:   Tue, 17 Jan 2023 00:26:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        arun.ramadoss@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH net 2/2] net: dsa: microchip: lan937x: run phy
 initialization during each link update
Message-ID: <20230116222602.oswnt4ecoucpb2km@skbuf>
References: <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-1-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
 <20230116100500.614444-3-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 03:35:00PM +0530, Rakesh Sankaranarayanan wrote:
> PHY initialization is supposed to run on every mode changes.
> "lan87xx_config_aneg()" verifies every mode change using
> "phy_modify_changed()" function. Earlier code had phy_modify_changed()
> followed by genphy_soft_reset. But soft_reset resets all the
> pre-configured register values to default state, and lost all the
> initialization done. With this reason gen_phy_reset was removed.
> But it need to go through init sequence each time the mode changed.
> Update lan97xx_config_aneg() to invoke phy_init once successful mode
> update is detected.
> 
> PHY init sequence added in lan87xx_phy_init() have slave init
> commands executed every time. Update the init sequence to run
> slave init only if phydev is in slave mode.
> 
> Test setup contains LAN9370 EVB connected to SAMA5D3 (Running DSA),
> and issue can be reproduced by connecting link to any of the available
> ports after SAMA5D3 boot-up. With this issue, port will fail to
> update link state. But once the SAMA5D3 is reset with LAN9370 link in
> connected state itself, on boot-up link state will be reported as UP. But
> Again after some time, if link is moved to DOWN state, it will not get
> reported.
> 
> Fixes: b2cd2cde7d69 ("net: phy: LAN87xx: remove genphy_softreset in config_aneg")
> Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
> ---

Process related comments:

1. Don't prefix a patch with "net: dsa: microchip: " unless it touches
   the drivers/net/dsa/microchip/ folder.

2. Don't make unrelated patches on different drivers part of the same
   patch set.

3. AFAIU, this is the second fixup of a feature which never worked well
   (changing master/slave setting through ethtool). Not sure exactly
   what are the rules, but at some point, maintainers might say
   "hey, let go, this never worked, just send your fixes to net-next".
   I mean: (1) fixes of fixes of smth that never worked can't be sent ad
   infinitum, especially if not small and (2) there needs to be some
   incentive to submit code that actually works and was tested, rather
   than a placeholder which can be fixed up later, right? In this case,
   I'm not sure, this seems borderline net-next. Let's see what the PHY
   library maintainers think.

The code seems ok, I couldn't find flaws in it.

>  drivers/net/phy/microchip_t1.c | 70 +++++++++++++++++++++++++++-------
>  1 file changed, 56 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
> index 8569a545e0a3..78618c8cb6bf 100644
> --- a/drivers/net/phy/microchip_t1.c
> +++ b/drivers/net/phy/microchip_t1.c
> @@ -245,15 +245,42 @@ static int lan87xx_config_rgmii_delay(struct phy_device *phydev)
>  			   PHYACC_ATTR_BANK_MISC, LAN87XX_CTRL_1, rc);
>  }
>  
> +static int lan87xx_phy_init_cmd(struct phy_device *phydev,
> +				const struct access_ereg_val *cmd_seq, int cnt)
> +{
> +	int ret, i;
> +
> +	for (i = 0; i < cnt; i++) {
> +		if (cmd_seq[i].mode == PHYACC_ATTR_MODE_POLL &&
> +		    cmd_seq[i].bank == PHYACC_ATTR_BANK_SMI) {
> +			ret = access_smi_poll_timeout(phydev,
> +						      cmd_seq[i].offset,
> +						      cmd_seq[i].val,
> +						      cmd_seq[i].mask);
> +		} else {
> +			ret = access_ereg(phydev, cmd_seq[i].mode,
> +					  cmd_seq[i].bank, cmd_seq[i].offset,
> +					  cmd_seq[i].val);
> +		}
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return ret;
> +}
> +
>  static int lan87xx_phy_init(struct phy_device *phydev)
>  {
> -	static const struct access_ereg_val init[] = {
> +	static const struct access_ereg_val hw_init[] = {
>  		/* TXPD/TXAMP6 Configs */
>  		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_AFE,
>  		  T1_AFE_PORT_CFG1_REG,       0x002D,  0 },
>  		/* HW_Init Hi and Force_ED */
>  		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
>  		  T1_POWER_DOWN_CONTROL_REG,  0x0308,  0 },
> +	};
> +
> +	static const struct access_ereg_val slave_init[] = {
>  		/* Equalizer Full Duplex Freeze - T1 Slave */
>  		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
>  		  T1_EQ_FD_STG1_FRZ_CFG,     0x0002,  0 },
> @@ -267,6 +294,9 @@ static int lan87xx_phy_init(struct phy_device *phydev)
>  		  T1_EQ_WT_FD_LCK_FRZ_CFG,    0x0002,  0 },
>  		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
>  		  T1_PST_EQ_LCK_STG1_FRZ_CFG, 0x0002,  0 },
> +	};
> +
> +	static const struct access_ereg_val phy_init[] = {
>  		/* Slave Full Duplex Multi Configs */
>  		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP,
>  		  T1_SLV_FD_MULT_CFG_REG,     0x0D53,  0 },
> @@ -397,7 +427,7 @@ static int lan87xx_phy_init(struct phy_device *phydev)
>  		{ PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_SMI,
>  		  T1_POWER_DOWN_CONTROL_REG,	0x0300, 0 },
>  	};
> -	int rc, i;
> +	int rc;
>  
>  	/* phy Soft reset */
>  	rc = genphy_soft_reset(phydev);
> @@ -405,21 +435,28 @@ static int lan87xx_phy_init(struct phy_device *phydev)
>  		return rc;
>  
>  	/* PHY Initialization */
> -	for (i = 0; i < ARRAY_SIZE(init); i++) {
> -		if (init[i].mode == PHYACC_ATTR_MODE_POLL &&
> -		    init[i].bank == PHYACC_ATTR_BANK_SMI) {
> -			rc = access_smi_poll_timeout(phydev,
> -						     init[i].offset,
> -						     init[i].val,
> -						     init[i].mask);
> -		} else {
> -			rc = access_ereg(phydev, init[i].mode, init[i].bank,
> -					 init[i].offset, init[i].val);
> -		}
> +	rc = lan87xx_phy_init_cmd(phydev, hw_init, ARRAY_SIZE(hw_init));
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = genphy_read_master_slave(phydev);
> +	if (rc)
> +		return rc;
> +
> +	/* Following squence need to run only if phydev is in

s/Following squence need/The following sequence needs/

> +	 * slave mode.
> +	 */
> +	if (phydev->master_slave_state == MASTER_SLAVE_STATE_SLAVE) {
> +		rc = lan87xx_phy_init_cmd(phydev, slave_init,
> +					  ARRAY_SIZE(slave_init));
>  		if (rc < 0)
>  			return rc;
>  	}
>  
> +	rc = lan87xx_phy_init_cmd(phydev, phy_init, ARRAY_SIZE(phy_init));
> +	if (rc < 0)
> +		return rc;
> +
>  	return lan87xx_config_rgmii_delay(phydev);
>  }
>  
> @@ -775,6 +812,7 @@ static int lan87xx_read_status(struct phy_device *phydev)
>  static int lan87xx_config_aneg(struct phy_device *phydev)
>  {
>  	u16 ctl = 0;
> +	int ret;
>  
>  	switch (phydev->master_slave_set) {
>  	case MASTER_SLAVE_CFG_MASTER_FORCE:
> @@ -790,7 +828,11 @@ static int lan87xx_config_aneg(struct phy_device *phydev)
>  		return -EOPNOTSUPP;
>  	}
>  
> -	return phy_modify_changed(phydev, MII_CTRL1000, CTL1000_AS_MASTER, ctl);
> +	ret = phy_modify_changed(phydev, MII_CTRL1000, CTL1000_AS_MASTER, ctl);
> +	if (ret == 1)
> +		return phy_init_hw(phydev);
> +
> +	return ret;
>  }
>  
>  static int lan87xx_get_sqi(struct phy_device *phydev)
> -- 
> 2.34.1
> 

