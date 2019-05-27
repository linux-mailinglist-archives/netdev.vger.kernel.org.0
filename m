Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50BA62BA8D
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 21:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfE0TMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 15:12:38 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32930 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfE0TMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 15:12:38 -0400
Received: by mail-pl1-f193.google.com with SMTP id g21so7370404plq.0
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 12:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OBWTT82AuOV+TQ/nvsWljqIhqu+Sc0DiEti2qElSWCc=;
        b=axvwweOBgn4seMZsvsBecQC/fkRrhsWrg/PixMs1Yz9irN8JqGDiq8Yjdgva/+68ki
         v42zEofU3dqk1KVha75oqCSEHiQToeK8QqGt5NeubqMyQsoYn8xVyyfOagUhkMLAYmSW
         CG5782nfhNDthmIbFIV5uEgx1Qgw4/eWOfpwax38zhDZ7LnHtHfoG6y46eyA2TEkhsQ3
         JFOPwhZHPHoiqrPZCu2nOCiTPFRPIrVdOtZLcdSeyrojLk8je43A8Pjej4dBFCO9bjcc
         W2NwArz3poJFizwO3JtqqEYA+8XZpyxeA2Baw2CUrwfeEgCUgbBc226W1H4OpXCZGKv8
         f9ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OBWTT82AuOV+TQ/nvsWljqIhqu+Sc0DiEti2qElSWCc=;
        b=PivS7REU1457xlafmCsJdiRXwSthczd0LTfnp+lnBc1NnxumMjSNWy1gsEGqollxeQ
         I0Rmr8OkM6YrHDI6oH5k1IZzTE/90XeunhTbOZ1ttp61DfCdmgTczplgoQwFVh1oDhB6
         /B3K9jBLzue7OQs8vS8iVqPHD9inKbLRmhDzozgSmSu54g3KMgdK2KySr8sBEoayx0df
         84paY2Ju6fb3Y1ZCiB8ccLhCG9a0DWcQYX0JMcf4BpU5WxoL04Br4ZpBEnIzekesYTKW
         bB1sZ/H++QibM1l1sATiYOwDnbTH3QRYAjwbjcl8Hb+M2hxWW2VPzR2SATXh6nQ+RUlA
         Rp4Q==
X-Gm-Message-State: APjAAAVDXIl+lEixfh2nsW7NEjLLF9hwXKbq6sAVQ88E2vZs7qt52WHG
        843LIhWl+NX0HrpLzKnEy0Y=
X-Google-Smtp-Source: APXvYqyUsby0D+XLRT2XbLgjoSupKSE+iCy2i8iRPPdYZiZSBJPZStQLHzeF/nr+XOHjKGJiNP7H8A==
X-Received: by 2002:a17:902:8d94:: with SMTP id v20mr57142837plo.99.1558984357435;
        Mon, 27 May 2019 12:12:37 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id k3sm12296913pfa.36.2019.05.27.12.12.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 12:12:36 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] net: phy: dp83867: fix speed 10 in sgmii mode
To:     Max Uvarov <muvarov@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net
References: <20190527061607.30030-1-muvarov@gmail.com>
 <20190527061607.30030-2-muvarov@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <aec6bcb8-2ee0-2312-23d8-7d5c7e14fc57@gmail.com>
Date:   Mon, 27 May 2019 12:12:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190527061607.30030-2-muvarov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/2019 11:16 PM, Max Uvarov wrote:
> For support 10Mps sped in SGMII mode DP83867_10M_SGMII_RATE_ADAPT bit
> of DP83867_10M_SGMII_CFG register has to be cleared by software.
> That does not affect speeds 100 and 1000 so can be done on init.

s/support/supporting/
s/sped/speed/

> 
> Signed-off-by: Max Uvarov <muvarov@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/dp83867.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index fd35131a0c39..75861b8f3b4d 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -30,6 +30,7 @@
>  #define DP83867_STRAP_STS1	0x006E
>  #define DP83867_RGMIIDCTL	0x0086
>  #define DP83867_IO_MUX_CFG	0x0170
> +#define DP83867_10M_SGMII_CFG  0x016F
>  
>  #define DP83867_SW_RESET	BIT(15)
>  #define DP83867_SW_RESTART	BIT(14)
> @@ -74,6 +75,9 @@
>  /* CFG4 bits */
>  #define DP83867_CFG4_PORT_MIRROR_EN              BIT(0)
>  
> +/* 10M_SGMII_CFG bits */
> +#define DP83867_10M_SGMII_RATE_ADAPT		 BIT(7)
> +
>  enum {
>  	DP83867_PORT_MIRROING_KEEP,
>  	DP83867_PORT_MIRROING_EN,
> @@ -277,6 +281,22 @@ static int dp83867_config_init(struct phy_device *phydev)
>  				       DP83867_IO_MUX_CFG_IO_IMPEDANCE_CTRL);
>  	}
>  
> +	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
> +		/* For support SPEED_10 in SGMII mode
> +		 * DP83867_10M_SGMII_RATE_ADAPT bit
> +		 * has to be cleared by software. That
> +		 * does not affect SPEED_100 and
> +		 * SPEED_1000.

Likewise, s/support/supporting/ with that and Heiner's suggestion to use
phy_modify_mmd():

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

> +		 */
> +		val = phy_read_mmd(phydev, DP83867_DEVADDR,
> +				   DP83867_10M_SGMII_CFG);
> +		val &= ~DP83867_10M_SGMII_RATE_ADAPT;
> +		ret = phy_write_mmd(phydev, DP83867_DEVADDR,
> +				    DP83867_10M_SGMII_CFG, val);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	/* Enable Interrupt output INT_OE in CFG3 register */
>  	if (phy_interrupt_is_valid(phydev)) {
>  		val = phy_read(phydev, DP83867_CFG3);
> 

-- 
Florian
