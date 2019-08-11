Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7569489124
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 11:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfHKJyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 05:54:15 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38242 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfHKJyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 05:54:15 -0400
Received: by mail-lf1-f65.google.com with SMTP id h28so72344320lfj.5
        for <netdev@vger.kernel.org>; Sun, 11 Aug 2019 02:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bJxJ/Rcx445G5gR0Any2lfdbBuYg/GFRMolblJDSSfc=;
        b=0UaURJCHb0V80q8PwAK9kK+H8qlj8Ag7QpKTpYzGH7YMmRz2EliC3GNbUn7ZRUUhb4
         ZPCQ6zXDK9DEpbN9swLfBjPgdfihP5lKd6kH5qtByKvVEOfAYl3Bw1fddwVn9Y9GYDwE
         tEbP7sytnGFjIHZsLy0V7+1OUN2O8D5mjhoHKxaR1wHneTATvxUwVWEST1V55NUnuL7G
         xe4juuVUBm9+qICxaUx7d5L++QqcL6pLHGVhpx5kDuPO8dPFXd4PksY8p3jj3AOSdH9b
         IJGo1cW36Y1qGyvRE+pS/IQYyNH6m88zMuJ2+nK1YHTBKQyq+rU1MkVSTktlkVbw82tr
         h9yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bJxJ/Rcx445G5gR0Any2lfdbBuYg/GFRMolblJDSSfc=;
        b=AM+3AxjsO20etEECu/thn6SYgcbKaY+X/jcDm3OVKu0OCOmuILDM1RSxFp0HKItYpF
         Rml1IC0sFy/gE/t77XteY+Oab/sEi1jjFhG5LTCCPy6HlnrTFyusKQwvL/tdzoftv7Nc
         qTMo3hSdjGovp0B2rcX0fKBcnQySvcR0x/gEux049qSxHi60w+Lpdfjj4bgXz2D2acf7
         xnS56NM3wdmEsiDTyjVq+zHRyKTxQIJxgsWTpsW7C51XDMJU85Xng+pR0Oacti5b+DzH
         pboPsOrVPjPdILojocbvkM1l/CmbitU6gJvltSD73BBw64Brco8MCt/Bos++qDDwBLMO
         lm0Q==
X-Gm-Message-State: APjAAAXkvMQXQXYyMsQTR2ANg8Pkmy54W/N1DvHu77xC40zIT7nLjQX/
        njWUNlpAX83D9ndMliHJ7XGlyQ==
X-Google-Smtp-Source: APXvYqxpnVf303X7BpyiwbkHmn1o1XCHTjMEYIibIuhDI4VQak63YNkbiN64RK6wmvttC80cd9U41w==
X-Received: by 2002:a19:c20b:: with SMTP id l11mr17361493lfc.106.1565517253143;
        Sun, 11 Aug 2019 02:54:13 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:464e:4679:7d95:7170:9da8:af4f? ([2a00:1fa0:464e:4679:7d95:7170:9da8:af4f])
        by smtp.gmail.com with ESMTPSA id o5sm392759lji.43.2019.08.11.02.54.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 02:54:12 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/1] net: dsa: fix fixed-link port
 registration
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20190811031857.2899-1-marek.behun@nic.cz>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <fab0fac1-76b7-f365-ecf5-e7eb0f924fad@cogentembedded.com>
Date:   Sun, 11 Aug 2019 12:54:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190811031857.2899-1-marek.behun@nic.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

    Just noticed a comment typo...

On 11.08.2019 6:18, Marek Behún wrote:

> Commit 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in
> genphy_read_status") broke fixed link DSA port registration in
> dsa_port_fixed_link_register_of: the genphy_read_status does not do what
> it is supposed to and the following adjust_link is given wrong
> parameters.
> 
> This causes a regression on Turris Omnia, where the mvneta driver for
> the interface connected to the switch reports crc errors, for some
> reason.
> 
> I realize this fix is not ideal, something else could change in genphy
> functions which could cause DSA fixed-link port to break again.
> Hopefully DSA fixed-link port functionality will be converted to phylink
> API soon.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
>   net/dsa/port.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 363eab6df51b..c424ebb373e1 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -485,6 +485,17 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
>   	phydev->interface = mode;
>   
>   	genphy_config_init(phydev);
> +
> +	/*
> +	 * Commit 88d6272acaaa caused genphy_read_status not to do it's work if
                                                                    ^^^^ its.

> +	 * autonegotiation is enabled and link status did not change. This is
> +	 * the case for fixed_phy. By setting phydev->link = 0 before the call
> +	 * to genphy_read_status we force it to read and fill in the parameters.
> +	 *
> +	 * Hopefully this dirty hack will be removed soon by converting DSA
> +	 * fixed link ports to phylink API.
> +	 */
> +	phydev->link = 0;
>   	genphy_read_status(phydev);
>   
>   	if (ds->ops->adjust_link)

MBR, Sergei

