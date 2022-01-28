Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F2C49F69A
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 10:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347708AbiA1JpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 04:45:25 -0500
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17487 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347707AbiA1JpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 04:45:24 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1643363105; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=np27wTPl16Rbnotsctu+USjfyr7vYV5w7EqW0aZgCEWLK9V3K5kxQJNQyR/f/87RpvLsT9n4yAogMQvFnzIZX/2L2vQO0pLJVmc7rA78S7sEInf04sk6RO5824oU+c/Qx2PeJDGfZdmEQcU9atychTaIxSQ5gzTNVAqdgLzJLus=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1643363105; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=md4yuToOZM5BbRfXNHa5VmMlDZ9FujVf83LU2o4Ob3Y=; 
        b=EGNQcAWP2oeioTyO5PwOPcVKwA3knB73CSsv67vgiq/wkbUjjBA5nSOH/EiKcm9/cFx+KPsJm4Mg1Or1+HWPwbUBQJVEHt/uLg5TfNNGkkvC7Bmw0/7ZoiKzhiTmfjBbkLD7/Jt3IdNSJXSXVI9L3qp3io9O6dHY2/jF9hpuJgY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1643363105;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=md4yuToOZM5BbRfXNHa5VmMlDZ9FujVf83LU2o4Ob3Y=;
        b=EzdB3fWEWfvx4SSxgAF9LO7WDeW3FvOwGOCRDDSh3egTJwdmQguaWFusyXXhgPBr
        L/4KBVfqlQBjt48Ys2lGuD2/Suj11/2M/cjZ1cKLh7EiK0rkZ5LEPe70Cb+ZLeGsGBS
        J1HGBMuM3oRY3eMRukh9tij55Jhv4nIf9Gh9f1A0=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1643363103381829.7624383956421; Fri, 28 Jan 2022 01:45:03 -0800 (PST)
Message-ID: <681c9be1-911a-2a68-63de-09644f24fea8@arinc9.com>
Date:   Fri, 28 Jan 2022 12:44:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v6 11/13] net: dsa: realtek: rtl8365mb: add
 RTL8367RB-VB support
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        frank-w@public-files.de, davem@davemloft.net, kuba@kernel.org
References: <20220128060509.13800-1-luizluca@gmail.com>
 <20220128060509.13800-12-luizluca@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220128060509.13800-12-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/01/2022 09:05, Luiz Angelo Daros de Luca wrote:
> RTL8367RB-VB is a 5+2 port 10/100/1000M Ethernet switch.
> It is similar to RTL8367S but in this version, both
> external interfaces are RGMII.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>   drivers/net/dsa/realtek/rtl8365mb.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
> index 6974decf5ebe..174496e4d736 100644
> --- a/drivers/net/dsa/realtek/rtl8365mb.c
> +++ b/drivers/net/dsa/realtek/rtl8365mb.c
> @@ -108,6 +108,9 @@
>   #define RTL8365MB_CHIP_ID_8367S		0x6367
>   #define RTL8365MB_CHIP_VER_8367S	0x00A0
>   
> +#define RTL8365MB_CHIP_ID_8367RB	0x6367
> +#define RTL8365MB_CHIP_VER_8367RB	0x0020
> +
>   /* Family-specific data and limits */
>   #define RTL8365MB_PHYADDRMAX		7
>   #define RTL8365MB_NUM_PHYREGS		32
> @@ -1979,6 +1982,11 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
>   				 "found an RTL8365MB-VC switch (ver=0x%04x)\n",
>   				 chip_ver);
>   			break;
> +		case RTL8365MB_CHIP_VER_8367RB:
> +			dev_info(priv->dev,
> +				 "found an RTL8367RB-VB switch (ver=0x%04x)\n",
> +				 chip_ver);
> +			break;
>   		case RTL8365MB_CHIP_VER_8367S:
>   			dev_info(priv->dev,
>   				 "found an RTL8367S switch (ver=0x%04x)\n",

You should mention the support for this chip model on kconfig like on 
"net: dsa: realtek: rtl8365mb: add RTL8367S support".

Don't you also need to match the "realtek,rtl8367rb" compatible string 
to rtl8365mb_variant on SMI and MDIO drivers?

Arınç
