Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115281D19C5
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730027AbgEMPqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbgEMPqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:46:38 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6699DC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 08:46:38 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b12so5062068plz.13
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 08:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZpLfTJ8ouPn1kLlrjqtwRp0K+/L19gJd6qpBYWzECDA=;
        b=DRrSmku+pMUE7I5aKXew64Mot0IrIeb9PCHuJq6+qo97yJbCJLga8Ke8xBq09uwu06
         BPPyRAEXbIab5Aazm8Bg3dN5RPy1JnXqXrovQ1xtCRXucLeAFE4Kb4FvljMVxwiRwIpr
         fjptKNUYlAoey+dZ0GHhhKPmIUUcwaKxmItP9N/2Aah8VeYIAKMJf5Oxf8JW8gLJe58Z
         DPM07Vb2UKwpJriRvUtIeLxG8Nf0C9uNyCSKRrQTgXLgc9IHNrbdT4xllkppv1DIWrDY
         G5T87y/0Su+gho/65XBNIpbB7k79GynBcW4dU8Z0aoAOKFRntS1i1rL9PtMEJ7OMmRWg
         1odA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZpLfTJ8ouPn1kLlrjqtwRp0K+/L19gJd6qpBYWzECDA=;
        b=cyQbLFHiRT3nVnIf+O2zAQjUbegN3p6VhACGmv8aQ8mKUs9NPsvnC6O/J0MNSVdW3M
         nzmtNag8vphXiZytfhyFXWQTtBiDhRi8sn3PpLQ9mV0iTmZLLEUemO25AaFJLX/PwuBd
         CGTxSzKErrrib/eT/eoL0dul5newrQn2RVIkej/Hkzr8m9LNAwVdaeMfI4v6TphM3tac
         E7M9qXFoHJrRuBMd5qopTSEfTPgJ9QQEq/Agj/D1org212FwFXpYFwnWdGJIaKq7g+Mj
         QI+FdYg6/LeJ4Wes+o1i6xdtCe99omj1svHudljNQfYp4ellfC7cYxFsNDNBD1xOICJV
         8vlg==
X-Gm-Message-State: AGi0PuY6/qkceaiSUqYxV9xxO9gN0XGazdtXjbW3j9TBor9B1gJfNjCc
        kOn/Vns2QdbkBbE4bQ+VSgw=
X-Google-Smtp-Source: APiQypKMlUWiqBRaHWFBOJTV400ENjbYiNsGf9BzVkD+tGtpP9xN2rvKp8Zc0+CtT4l9scsSwt/+lw==
X-Received: by 2002:a17:90b:3110:: with SMTP id gc16mr35015196pjb.155.1589384797829;
        Wed, 13 May 2020 08:46:37 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g9sm84588pgh.52.2020.05.13.08.46.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 08:46:37 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: mt7530: set CPU port to fallback mode
To:     DENG Qingfang <dqfext@gmail.com>, netdev@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mediatek@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Tom James <tj17@me.com>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com, Szabolcs Hubai <szab.hu@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
References: <20200513153717.15599-1-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5d77da58-694a-7f9c-53fb-9d107e271d40@gmail.com>
Date:   Wed, 13 May 2020 08:46:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513153717.15599-1-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2020 8:37 AM, DENG Qingfang wrote:
> Currently, setting a bridge's self PVID to other value and deleting
> the default VID 1 renders untagged ports of that VLAN unable to talk to
> the CPU port:
> 
> 	bridge vlan add dev br0 vid 2 pvid untagged self
> 	bridge vlan del dev br0 vid 1 self
> 	bridge vlan add dev sw0p0 vid 2 pvid untagged
> 	bridge vlan del dev sw0p0 vid 1
> 	# br0 cannot send untagged frames out of sw0p0 anymore
> 
> That is because the CPU port is set to security mode and its PVID is
> still 1, and untagged frames are dropped due to VLAN member violation.
> 
> Set the CPU port to fallback mode so untagged frames can pass through.

How about if the bridge has vlan_filtering=1? The use case you present
seems to be valid to me, that is, you may create a VLAN just for the
user ports and not have the CPU port be part of it at all.

> 
> Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
>  drivers/net/dsa/mt7530.c | 11 ++++++++---
>  drivers/net/dsa/mt7530.h |  6 ++++++
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 5c444cd722bd..a063d914c23f 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -810,10 +810,15 @@ mt7530_port_set_vlan_aware(struct dsa_switch *ds, int port)
>  		   PCR_MATRIX_MASK, PCR_MATRIX(MT7530_ALL_MEMBERS));
>  
>  	/* Trapped into security mode allows packet forwarding through VLAN
> -	 * table lookup.
> +	 * table lookup. CPU port is set to fallback mode to let untagged
> +	 * frames pass through.
>  	 */
> -	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
> -		   MT7530_PORT_SECURITY_MODE);
> +	if (dsa_is_cpu_port(ds, port))
> +		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
> +			   MT7530_PORT_FALLBACK_MODE);
> +	else
> +		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
> +			   MT7530_PORT_SECURITY_MODE);
>  
>  	/* Set the port as a user port which is to be able to recognize VID
>  	 * from incoming packets before fetching entry within the VLAN table.
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index 979bb6374678..d45eb7540703 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -152,6 +152,12 @@ enum mt7530_port_mode {
>  	/* Port Matrix Mode: Frames are forwarded by the PCR_MATRIX members. */
>  	MT7530_PORT_MATRIX_MODE = PORT_VLAN(0),
>  
> +	/* Fallback Mode: Forward received frames with ingress ports that do
> +	 * not belong to the VLAN member. Frames whose VID is not listed on
> +	 * the VLAN table are forwarded by the PCR_MATRIX members.
> +	 */
> +	MT7530_PORT_FALLBACK_MODE = PORT_VLAN(1),
> +
>  	/* Security Mode: Discard any frame due to ingress membership
>  	 * violation or VID missed on the VLAN table.
>  	 */
> 

-- 
Florian
