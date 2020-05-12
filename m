Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D181CFD7A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 20:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbgELSnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 14:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELSns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 14:43:48 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC38C061A0C;
        Tue, 12 May 2020 11:43:48 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u16so24834085wmc.5;
        Tue, 12 May 2020 11:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G6qmfcxPjUk1PAIF6WXdpSW8GsCiEbgK0TItUolFwFs=;
        b=YyFWPT+W59qjFtGUWHs8+M5E8cUKWVlHvcMyvGBJLWwuO8J1SaRBZFPHK0hrffGwqW
         n+ZH3L/qoTu+OKupXn7eiC4O/AaQ4GZY8kcn++DLzG9K4qylOcxHGZY4RPKUpgfNP7sS
         01PZVr466ASNSWOd29VQZojxA6W+DXZeP0zI3LE5EsEIsKZxwRpEwe8oh97aHAbnngxK
         UtNnThVMUeI0MxRuubCP3K3ly/mQgp1mMC6vkqFnAsQg0uvXudncbmI2h6MiD48V6GAU
         uTi6MHa19jzTYioFLvPiU4iUr8oIwkakg4O1z8RiHoIgLvxipKS12zSEewgM6+weqd2A
         rzlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G6qmfcxPjUk1PAIF6WXdpSW8GsCiEbgK0TItUolFwFs=;
        b=B71Q6TZ1YdPqIB3fbBD1u8RbnqpC36/0BU2i1kzYYTflzXMmZ7U183a7ssBLhq736m
         LeJTS0oL43tlNYMjdpnWugTvMczXJPfK38bEuAZX4TP88KA4VOZb8FDDsXPmMXj65/r7
         RMIaC0o2Ss6q4B0ZHNxTCwoPShuB5ThMeNJMxxZKkvqw7Au9z7XvHtL4JEBMRhAxOC6m
         FC4R59LO6byYRpTKrQnzhRieJV81XurHjZrd74VE3ufb/1DvJadY24OzHCvUF8umLJlG
         Idi4Ro1Tf8Na8OUQNCimHN9y/hDUjlvZsPkCZCYJjFpJBcgMqtjDcxlNZe7iU+PAt1R8
         Tg1Q==
X-Gm-Message-State: AGi0PuZg0OVmsJTkIH2nLwHwziAxN9mbgA9XNo9xrp9OhPAc9XAVloCP
        7mNIp9GbZKhAG4uK7D2JU1JVzF7E
X-Google-Smtp-Source: APiQypKLG+QPMpg9r4umkuQ/roOkNtuH2MZUIQ+y2wfaEtp9hgi29bWSg7F4vPXlGZMfP+tcvMvrBQ==
X-Received: by 2002:a1c:8094:: with SMTP id b142mr26171974wmd.61.1589309027074;
        Tue, 12 May 2020 11:43:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:d932:d3d0:91da:45c2? (p200300EA8F285200D932D3D091DA45C2.dip0.t-ipconnect.de. [2003:ea:8f28:5200:d932:d3d0:91da:45c2])
        by smtp.googlemail.com with ESMTPSA id n7sm14995650wro.94.2020.05.12.11.43.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 11:43:46 -0700 (PDT)
Subject: Re: [PATCH] net: phy: realtek: clear interrupt during init for
 rtl8211f
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200512184601.40b1758a@xhacker.debian>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7735a257-21ff-e6c0-acdc-f5ee187b1f57@gmail.com>
Date:   Tue, 12 May 2020 20:43:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200512184601.40b1758a@xhacker.debian>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.05.2020 12:46, Jisheng Zhang wrote:
> The PHY Register Accessible Interrupt is enabled by default, so
> there's such an interrupt during init. In PHY POLL mode case, the
> INTB/PMEB pin is alway active, it is not good. Clear the interrupt by
> calling rtl8211f_ack_interrupt().

As you say "it's not good" w/o elaborating a little bit more on it:
Do you face any actual issue? Or do you just think that it's not nice?
I'm asking because you don't provide a Fixes tag and you don't
annotate your patch as net or net-next.
Once you provide more details we would also get an idea whether a
change would have to be made to phylib, because what you describe
doesn't seem to be specific to this one PHY model.

> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> ---
>  drivers/net/phy/realtek.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index 2d99e9de6ee1..398607268a3c 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -179,6 +179,10 @@ static int rtl8211f_config_init(struct phy_device *phydev)
>  	u16 val_txdly, val_rxdly;
>  	int ret;
>  
> +	ret = rtl8211f_ack_interrupt(phydev);
> +	if (ret < 0)
> +		return ret;
> +
>  	switch (phydev->interface) {
>  	case PHY_INTERFACE_MODE_RGMII:
>  		val_txdly = 0;
> 

