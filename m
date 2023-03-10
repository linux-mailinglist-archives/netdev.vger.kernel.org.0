Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536516B5233
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjCJUvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCJUvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:51:45 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD90C13B28F
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 12:51:44 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id k37so4283212wms.0
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 12:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678481503;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yzdTe1fbjFDvbKdMqgt6qo6DMxBhY9unrR30B/RFsI0=;
        b=Z5V/daX6mMACSQmDh2e7taxVEjaov1A9P0Ih8Yh2Ni7OtXRMYt8MylBcs7Y9u18RSH
         7G1k97/K5bJwTeWWmFl8EEu/e4JsORl/UysR5aMLJMvVPV0sX2l1CM1Ucg4GnLDXSSah
         cDLSjfw+pZ/Byn/JCG1UclzEGzn8gPcrQo0BpxHtx6Mu/qKAcTwD30wRs604DTkVz5RC
         91lMq7QgaqKnF8+8Rkp9MKrRSF9VnVb7i3/LcG9fFb8bst0jLkcnOhknwpNy+mG92i8A
         E8SBVnhq3MWCr79UhXhZ/7Z8SM//7wT6bqESgiOcJn/pLgopneCyRvNqqST4IXteSrIG
         7/4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678481503;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yzdTe1fbjFDvbKdMqgt6qo6DMxBhY9unrR30B/RFsI0=;
        b=biO3/un5fM38dfGqtjXwSkd2PHkixJT29lsJt2wNNlnP4FGc7X86zYeALLBu4NweHG
         HTUeb6XnSrW3PCUV3HbzBIRhkCqULhwDHEHQmpVGPRA8743lRWz2WQJEbSbP68zEUIai
         PCGIkgy/fIG9VqUaSZhtFeMdamJI8CkBqaTQrR3Y930qcPfecb4dm3Sygcb4xq850vQY
         rIBTmB+XJl919x+N6noYUAZZkxn28SzFuRlZp1/YvcedGV1+aGEsJxFZzmyyi48WDXlE
         1n3GaLjDOZFHVVcsWJzZVgD78u+uZzV19YnLNFR6mSVoHKf7hjtOJPSgBnCSf98XpI7c
         0gHQ==
X-Gm-Message-State: AO0yUKXX2iaFfcH6x0arN9/Wef49Csi8s2zxGoMG39F3qTs4F7tOBL0u
        VbUOtwTY14xh7SfVfLvizR7kSgrUtdM=
X-Google-Smtp-Source: AK7set8CMJ+uoPfwOC/lUgn+/LNcqaQFG0kHAYhBhCkoSLWAmBFyDEFUGO4mw5uDNjCBqEUWh9Ye9w==
X-Received: by 2002:a7b:c050:0:b0:3e7:6a59:d9d3 with SMTP id u16-20020a7bc050000000b003e76a59d9d3mr3914124wmc.37.1678481503203;
        Fri, 10 Mar 2023 12:51:43 -0800 (PST)
Received: from ?IPV6:2a01:c22:7669:bf00:58d7:455f:e597:a838? (dynamic-2a01-0c22-7669-bf00-58d7-455f-e597-a838.c22.pool.telefonica.de. [2a01:c22:7669:bf00:58d7:455f:e597:a838])
        by smtp.googlemail.com with ESMTPSA id n14-20020a05600c4f8e00b003eb0d6f48f3sm1002754wmq.27.2023.03.10.12.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 12:51:42 -0800 (PST)
Message-ID: <a7ae8bf8-7521-ebbd-82dc-6338f766b59c@gmail.com>
Date:   Fri, 10 Mar 2023 21:51:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6c4ca9e8-8b68-f730-7d88-ebb7165f6b1d@gmail.com>
 <ZAntvsDrEtx/pIjA@corigine.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: phy: smsc: use phy_clear/set_bits in
 lan87xx_read_status
In-Reply-To: <ZAntvsDrEtx/pIjA@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.03.2023 15:31, Simon Horman wrote:
> On Wed, Mar 08, 2023 at 09:11:02PM +0100, Heiner Kallweit wrote:
>> Simplify the code by using phy_clear/sert_bits().
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/phy/smsc.c | 25 ++++++++++---------------
>>  1 file changed, 10 insertions(+), 15 deletions(-)
> 
> The phy_clear/sert_bits changes lookg good.
> But I have a few nit-pick comments.
> 
>> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
>> index af89f3ef1..5965a8afa 100644
>> --- a/drivers/net/phy/smsc.c
>> +++ b/drivers/net/phy/smsc.c
>> @@ -204,17 +204,16 @@ static int lan95xx_config_aneg_ext(struct phy_device *phydev)
>>  static int lan87xx_read_status(struct phy_device *phydev)
>>  {
>>  	struct smsc_phy_priv *priv = phydev->priv;
>> +	int rc;
>>  
>> -	int err = genphy_read_status(phydev);
>> +	rc = genphy_read_status(phydev);
>> +	if (rc)
>> +		return rc;
> 
> nit: this seems like a separate change, possibly a fix.
> 
There's no known problem with the current code, so the need for a fix
may be questionable. But you're right, it's a separate change.
IMO it just wasn't worth it to provide it as a separate patch.

>>  
>>  	if (!phydev->link && priv->energy_enable && phydev->irq == PHY_POLL) {
>>  		/* Disable EDPD to wake up PHY */
>> -		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
>> -		if (rc < 0)
>> -			return rc;
>> -
>> -		rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
>> -			       rc & ~MII_LAN83C185_EDPWRDOWN);
>> +		rc = phy_clear_bits(phydev, MII_LAN83C185_CTRL_STATUS,
>> +				    MII_LAN83C185_EDPWRDOWN);
>>  		if (rc < 0)
>>  			return rc;
>>  
>> @@ -222,24 +221,20 @@ static int lan87xx_read_status(struct phy_device *phydev)
>>  		 * an actual error.
>>  		 */
>>  		read_poll_timeout(phy_read, rc,
>> -				  rc & MII_LAN83C185_ENERGYON || rc < 0,
>> +				  rc < 0 || rc & MII_LAN83C185_ENERGYON,
> 
> nit: this also seems like a separate change.
> 
Same as for the remark before.

>>  				  10000, 640000, true, phydev,
>>  				  MII_LAN83C185_CTRL_STATUS);
>>  		if (rc < 0)
>>  			return rc;
>>  
>>  		/* Re-enable EDPD */
>> -		rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
>> -		if (rc < 0)
>> -			return rc;
>> -
>> -		rc = phy_write(phydev, MII_LAN83C185_CTRL_STATUS,
>> -			       rc | MII_LAN83C185_EDPWRDOWN);
>> +		rc = phy_set_bits(phydev, MII_LAN83C185_CTRL_STATUS,
>> +				  MII_LAN83C185_EDPWRDOWN);
>>  		if (rc < 0)
>>  			return rc;
>>  	}
>>  
>> -	return err;
>> +	return 0;
>>  }
>>  
>>  static int smsc_get_sset_count(struct phy_device *phydev)
>> -- 
>> 2.39.2
>>

