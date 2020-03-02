Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A8A176104
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 18:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCBR3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 12:29:24 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34706 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbgCBR3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 12:29:24 -0500
Received: by mail-pj1-f66.google.com with SMTP id f2so140685pjq.1;
        Mon, 02 Mar 2020 09:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=i318bxoT6Ni0C1g9+1+56bhI51FxJh+OrbLkthVCfys=;
        b=tElqR9xI55IlX1bqzqmpCQQSYJlt61RVqZa1ejTlX+FKTLQPtkBa2KwjxkSLqNTZcG
         fL6iIxN4Y8DcaNRMeLug9PwC2JkFy2O3oSv280HwdydKeW18IxnzP9EhYdDUrMeP6t1D
         qQjnvKisCpl3nQRireRZQaEJ1iDX9RIgXfpF0izkJYfQeQk4KQZ7I/bqMH2rmJ08dzIF
         /eODhX4cMivxMP+eu2HTXaUbcgejaeCSspNQPcpgtXRcMrQbsfF9XgG37gKTjqxF9y+k
         SkYFD779/rifEd4Uh1Ua7V3N42FIKkrtapfch8MJ2acoenSAwf3iYsHzvpTxoLoA+c6G
         WFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=i318bxoT6Ni0C1g9+1+56bhI51FxJh+OrbLkthVCfys=;
        b=ASDhfZdRgBFZMZmhGGMqhIcIMY5nP6LHtZZzs9G/Z2itgOhdQMKJCSCByAsB8bQxIN
         2YLasyeIvkVVRPgSzomrXpiPtlHTIlKQ3cv7um/FlPKFxJ90/PYtVR5XIq/KcSlxx5Sp
         7zi8ZexE/DTs4+fheEadSwMASrMZJJtXCbvrbAKxseNGeudsqREOyTVmwMzaAKlTgLaK
         Fzk3Uea+ztwt+BDm7KEQOGMVQcvimJEFQu9H0pZ5aHr0Vo8S5tMkBvf9W/XM9P88S5DN
         e8iVJsZmNsBkYlhXTi9Wi48hn9oouCn5+QqsNADiDJUkEax/GhZfr5Q8I75rVBwo61Od
         Xh4A==
X-Gm-Message-State: ANhLgQ3ufO6v+6HFasrFhAgmBSixkL3REJVggwyp9aH4aFWADWtYT+0h
        zQTiGgOVEQHAm4Ui0VATZoQ=
X-Google-Smtp-Source: ADFU+vvrbLq1J0XXKKmBcmbvRzLZLLsAuraN2ldas+ndFYDRBWE/ICl1xxcGMJJGxJ2GkiTYJBLQkQ==
X-Received: by 2002:a17:902:61:: with SMTP id 88mr223176pla.313.1583170161637;
        Mon, 02 Mar 2020 09:29:21 -0800 (PST)
Received: from localhost.localdomain (c-98-210-123-170.hsd1.ca.comcast.net. [98.210.123.170])
        by smtp.googlemail.com with ESMTPSA id h7sm22901467pfq.36.2020.03.02.09.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 09:29:21 -0800 (PST)
From:   Dajun Jin <adajunjin@gmail.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        robh+dt@kernel.org, frowand.list@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] drivers/of/of_mdio.c:fix of_mdiobus_register()
Date:   Mon,  2 Mar 2020 09:29:19 -0800
Message-Id: <20200302172919.31425-1-adajunjin@gmail.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200301165018.GN6305@lunn.ch>
References: <20200301165018.GN6305@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>On Mon, Mar 02, 2020 at 12:41:38AM +0800, Dajun Jin wrote:
>> when registers a phy_device successful, should terminate the loop
>> or the phy_device would be registered in other addr.
>> 
>> Signed-off-by: Dajun Jin <adajunjin@xxxxxxxxx>
>> ---
>>  drivers/of/of_mdio.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
>> index 8270bbf505fb..9f982c0627a0 100644
>> --- a/drivers/of/of_mdio.c
>> +++ b/drivers/of/of_mdio.c
>> @@ -306,6 +306,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
>>  				rc = of_mdiobus_register_phy(mdio, child, addr);
>>  				if (rc && rc != -ENODEV)
>>  					goto unregister;
>> +				break;
>>  			}
>>  		}
>>  	}
>
>Hi Dajun
>
>What problem are you seeing? You explanation needs to be better.
>
>I'm guessing you have two or more PHYs on the bus, without reg
>properties?
>
>	Andrew

Hi Andrew

If a phy without reg property would be registered to all unoccupied addr.

This is my test in Xilinx zcu106 board.

dts is liks this:
ethernet@ff0e0000 {
    compatible = "cdns,zynqmp-gem", "cdns,gem";
    status = "okay";
    ...
    
    phy@0 {
        ti,rx-internal-delay = <0x8>;
        ti,tx-internal-delay = <0xa>;
        ti,fifo-depth = <0x1>;
        ti,rxctrl-strap-worka;
        linux,phandle = <0x12>;
        phandle = <0x12>;
    };
};

then when borad is booting,the dmesg is like this:
[    4.600035] mdio_bus ff0e0000.ethernet-ffffffff: /amba/ethernet@ff0e0000/phy@0 has invalid PHY address
[    4.600050] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 0
[    4.602076] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 1
[    4.603849] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 2
[    4.605574] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 4
[    4.607312] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 5
...
[    4.636155] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 28
[    4.637335] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 29
[    4.638504] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 30
[    4.639666] mdio_bus ff0e0000.ethernet-ffffffff: scan phy phy at address 31

	Dajun
