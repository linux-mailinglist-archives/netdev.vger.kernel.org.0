Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3C651B5B3
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 14:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbfEMMTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 08:19:22 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50891 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbfEMMTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 08:19:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id f204so8135955wme.0;
        Mon, 13 May 2019 05:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:mime-version:message-id:in-reply-to
         :references:user-agent:content-transfer-encoding;
        bh=TUgTyEA2x9hqWbN0oIASXhcSQpEw/aoyuMOpXI0eIPA=;
        b=j6+z41lq1N9z8zNZjnDKM9jnaPgIesFhKo6AmpDMp/w93zmuTpnomdsXK+yALp42JO
         l4TejRtm0DCnreFpX/ICAwPsm4CdG5Jsv+LU395mmFTUNaQhtHYKUXhMTvo+QKenRn76
         1ww0ijZkjuUMoPhn0dR4Bjvavz5pMCrWuX+HXPT57M/BdnUn5eC8XZ4dvp+vUYqJ0AUK
         AaNRbtC6Ap3ccn983JBfLmbo5RFvsYhJ8UvXpQSWKpRxMcsMogMoZTJlzzl74vtO7vKt
         pIqyERiGvfzqlMoX8m9FjrLsG6k+UDvx/D5PF3EEgNSOI0D0Z9s1nsuk3Z0yBlIB7IDN
         qhcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:mime-version:message-id
         :in-reply-to:references:user-agent:content-transfer-encoding;
        bh=TUgTyEA2x9hqWbN0oIASXhcSQpEw/aoyuMOpXI0eIPA=;
        b=oX7gcqFEBbhB7yMq1gRhk4+LY2Xt3gE1X2YPze4KFpFdJPXbKfgrShIXUDr8vhKXa9
         OOjwy9gHTvicRkunbY+sNI8EVWdy488LuMuVcpGaZ6RWqrEM7UbPmHHSHtd9GihKW2Pq
         lDeZYZx368nCH3WTxN3gF7dcozC6PzvnQbwcOO6mYoeVSp5WYq6TINtd9dJszv4pjVJU
         AQ1sym2wUS6jZNz5SSZkKEMXapzfzkBmJ9s31knoD5gXC4yTJ/aSscYvWw8qd73wCNHW
         wlal+eAHO6tWGzvkbEpwSybmC+dh3AwIxMQgREpY8v7DbG39bKwbVlSKUG+2PtNgFt58
         etQQ==
X-Gm-Message-State: APjAAAX+/KDQRhSINP8GlpVTjaLZHxdfCfKDHOpQMxtR465nOhrFfNIe
        7z11M/a4DeTqX4++lSy2EF6aQP/N+g244Q==
X-Google-Smtp-Source: APXvYqx8JxGB6O4jKB856rNMJQFYOS1x2OtGrk92bwfAPjSLlqEErSB+fFDIQyEoYr4KNNesKYkU6w==
X-Received: by 2002:a1c:e30a:: with SMTP id a10mr15646563wmh.128.1557749960299;
        Mon, 13 May 2019 05:19:20 -0700 (PDT)
Received: from localhost ([92.59.185.54])
        by smtp.gmail.com with ESMTPSA id t13sm16125677wra.81.2019.05.13.05.19.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 13 May 2019 05:19:18 -0700 (PDT)
From:   Vicente Bergas <vicencb@gmail.com>
To:     Serge Semin <fancer.lancer@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Date:   Mon, 13 May 2019 14:19:17 +0200
MIME-Version: 1.0
Message-ID: <cf1e81d9-6f91-41fe-a390-b9688e5707f7@gmail.com>
In-Reply-To: <20190513105104.af7d7n337lxqac63@mobilestation>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
 <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
 <61831f43-3b24-47d9-ec6f-15be6a4568c5@gmail.com>
 <0f16b2c5-ef2a-42a1-acdc-08fa9971b347@gmail.com>
 <20190513102941.4ocb3tz3wmh3pj4t@mobilestation>
 <20190513105104.af7d7n337lxqac63@mobilestation>
User-Agent: Trojita
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, May 13, 2019 12:51:05 PM CEST, Serge Semin wrote:
> On Mon, May 13, 2019 at 01:29:42PM +0300, Serge Semin wrote:
>> Hello Vincente,
>>=20
>> On Sat, May 11, 2019 at 05:06:04PM +0200, Vicente Bergas wrote: ...
>
> Hmm, just figured out, that in the datasheet RXDLY/TXDLY pins=20
> are actually grounded, so
> phy-mode=3D"rgmii" should work for you. Are you sure that on your=20
> actual hardware the
> resistors aren't placed differently?

That is correct, the schematic has pull-down resistors and placeholders for
pull-up resistors. On the board I can confirm the pull-ups are not
populated and the pull-downs are.
But the issue seems unrelated to this.

I have traced it down to a deadlock while trying to acquire a mutex.
It hangs here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drive=
rs/net/phy/realtek.c?id=3D47782361aca2#n220
while waiting for this mutex:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drive=
rs/net/phy/mdio_bus.c?id=3D47782361aca2#n692

Regards,
  Vicen=C3=A7.

> The current config register state can be read from the 0x1c=20
> extension page. Something
> like this:
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -221,6 +221,9 @@ static int rtl8211e_config_init(struct=20
> phy_device *phydev)
>  =09if (ret)
>  =09=09goto err_restore_page;
> =20
> +=09ret =3D phy_read(phydev, 0x1c);
> +=09dev_info(&phydev->mdio.dev, "PHY config register %08x\n", ret);
> +
>  =09ret =3D phy_modify(phydev, 0x1c, RTL8211E_TX_DELAY | RTL8211E_RX_DELAY,=

>  =09=09=09 val);
> =20
> -Sergey

