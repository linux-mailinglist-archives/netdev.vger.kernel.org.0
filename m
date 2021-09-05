Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916744011BD
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 23:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbhIEVRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 17:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhIEVRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 17:17:07 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B80C061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 14:16:03 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id w144so6427977oie.13
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 14:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=44Vum6v34eA5a4+LyGTdR/8ARH31f7BfkNnNOViZXdc=;
        b=FoozNQFWf00mJmgGxOAljpekwpnmUwfHBWP00foJKwB/s6O5sOoEVBgcrhwc0fs2mG
         qgbsvZRu8jNFU4ernoYRNtn8+/blZoPwMGCQDXu2zyXqw3sCG54EUwHxERGRic8PIhEf
         9F/luoYJsqshQlbTKzurMaWYJDhNC72ig8+BFaQJr4w5oC8LXt5JVLuS6bo9/YG3k2S8
         gP25+INP9AtmzHhhDZWDVuBNzJqt/B9+InCClyFetRRsi4+RscR0kjKxo7bdAyPHa87r
         lP0MXL7CaAahrPYbU5cgs7Ab1g4usJ0ZkXBE5maQG/wQmtkNNXxZlbNcgcqFiuIhem6F
         kASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=44Vum6v34eA5a4+LyGTdR/8ARH31f7BfkNnNOViZXdc=;
        b=fm4GPNKI06Kp6lKC+yarQ54dkBGjIXWjrTAOiBffArnaHWynprBktGkkeEgFomXXs/
         lhPx7tHStPOIjwVyo2rJ4mDE4HDL1HZP09jJtyaLVvAvKU+7iKB+lXoSguBwHQdPDixo
         G5s+luQFiLJjKR41zH0tgI9i19LRHajB0EKj0Qw2VjNf3Ets/H/D5pRgFYn5VO3GuTQH
         nBJ1TRj3rYn7jy7BrBbGcGzRDQoYk6oMmAKKi8bL2b5TBTaAC0e7E8xYyTfUa2ixrEhK
         7fjs1D1xaaVhXXXLntEtxJDrqwOJBYpTfGr9QU+tdIcGsFzFfKT98sRVXyvljhZ7EIfe
         EohA==
X-Gm-Message-State: AOAM531gWWd7bDPnj+ES56VgQIP9yGNiPQwFm/NTpFKdQ0twrRuaBqPs
        0MtWlv7gFv5exPNzBmaAGiA=
X-Google-Smtp-Source: ABdhPJzEKMucBLu1TjTIH2Zh7EYrbTdIM3sWVTAmBpe3/kByY1f9sH5CDzGObt561DT6cuEgGTly+g==
X-Received: by 2002:a05:6808:997:: with SMTP id a23mr6680594oic.11.1630876562808;
        Sun, 05 Sep 2021 14:16:02 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:5d95:1dc7:eeeb:985e? ([2600:1700:dfe0:49f0:5d95:1dc7:eeeb:985e])
        by smtp.gmail.com with ESMTPSA id e2sm1268718ooh.40.2021.09.05.14.16.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 14:16:02 -0700 (PDT)
Message-ID: <05523f76-6846-449e-bc66-5f4d15946ad5@gmail.com>
Date:   Sun, 5 Sep 2021 14:16:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] net: dsa: b53: Fix IMP port setup on BCM5301x
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210905172328.26281-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210905172328.26281-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/5/2021 10:23 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Broadcom's b53 switches have one IMP (Inband Management Port) that needs
> to be programmed using its own designed register. IMP port may be
> different than CPU port - especially on devices with multiple CPU ports.

There are two choices: port 5 or port 8,

> 
> For that reason it's required to explicitly note IMP port index and
> check for it when choosing a register to use.
> 
> This commit fixes BCM5301x support. Those switches use CPU port 5 while
> their IMP port is 8. Before this patch b53 was trying to program port 5
> with B53_PORT_OVERRIDE_CTRL instead of B53_GMII_PORT_OVERRIDE_CTRL(5).
> 
> It may be possible to also replace "cpu_port" usages with
> dsa_is_cpu_port() but that is out of the scope of thix BCM5301x fix.

Actually this would have been well within the scope of this patch.

> 
> Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

I really don't like the duplication of the "imp_port" and "cpu_port" 
members, first because this caused us problems before, and second 
because for all switch entries except the BCM5301X, cpu_port == 
imp_port, so this a duplication, and a waste of storage space to encode 
information.

In fact, there is no such thing as CPU port technically you chose either 
IMP0 or IMP1. IMP0 is port 8 and IMP1 is port 5.

> ---
>   drivers/net/dsa/b53/b53_common.c | 28 +++++++++++++++++++++++++---
>   drivers/net/dsa/b53/b53_priv.h   |  1 +
>   2 files changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index 5646eb8afe38..604f54112665 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1144,7 +1144,7 @@ static void b53_force_link(struct b53_device *dev, int port, int link)
>   	u8 reg, val, off;
>   
>   	/* Override the port settings */
> -	if (port == dev->cpu_port) {
> +	if (port == dev->imp_port) {

This should be port == 8

>   		off = B53_PORT_OVERRIDE_CTRL;
>   		val = PORT_OVERRIDE_EN;
>   	} else {
> @@ -1168,7 +1168,7 @@ static void b53_force_port_config(struct b53_device *dev, int port,
>   	u8 reg, val, off;
>   
>   	/* Override the port settings */
> -	if (port == dev->cpu_port) {
> +	if (port == dev->imp_port) {

Likewise

>   		off = B53_PORT_OVERRIDE_CTRL;
>   		val = PORT_OVERRIDE_EN;
>   	} else {
> @@ -1236,7 +1236,7 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
>   	b53_force_link(dev, port, phydev->link);
>   
>   	if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
> -		if (port == 8)
> +		if (port == dev->imp_port)

That use of port 8 was correct.

>   			off = B53_RGMII_CTRL_IMP;
>   		else
>   			off = B53_RGMII_CTRL_P(port);
> @@ -2280,6 +2280,7 @@ struct b53_chip_data {
>   	const char *dev_name;
>   	u16 vlans;
>   	u16 enabled_ports;
> +	u8 imp_port;
>   	u8 cpu_port;
>   	u8 vta_regs[3];
>   	u8 arl_bins;
> @@ -2304,6 +2305,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
>   		.enabled_ports = 0x1f,
>   		.arl_bins = 2,
>   		.arl_buckets = 1024,
> +		.imp_port = 5,

Could have used B53_CPU_PORT_25 here.

>   		.cpu_port = B53_CPU_PORT_25,
>   		.duplex_reg = B53_DUPLEX_STAT_FE,
>   	},
> @@ -2314,6 +2316,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
>   		.enabled_ports = 0x1f,
>   		.arl_bins = 2,
>   		.arl_buckets = 1024,
> +		.imp_port = 5,
>   		.cpu_port = B53_CPU_PORT_25,

and here.

>   		.duplex_reg = B53_DUPLEX_STAT_FE,
>   	},
> @@ -2324,6 +2327,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
>   		.enabled_ports = 0x1f,
>   		.arl_bins = 4,
>   		.arl_buckets = 1024,
> +		.imp_port = 8,
>   		.cpu_port = B53_CPU_PORT,

and B53_CPU_PORT here and for each entry below.

I will put this patch into my local test rack and see what breaks, and 
we can address this more cleanly with net-next. Another case where if we 
had more time to do a proper review we could come up with a small fix, 
and not create additional technical debt to fix in the next release 
cycle. Hope's spring is eternal, oh and I just came back from France, so 
I guess I am full of complaints, too :)
--
Florian
