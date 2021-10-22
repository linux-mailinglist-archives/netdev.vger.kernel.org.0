Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB924371B0
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 08:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhJVGYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 02:24:30 -0400
Received: from ni.piap.pl ([195.187.100.5]:57324 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhJVGY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 02:24:29 -0400
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        by ni.piap.pl (Postfix) with ESMTPSA id C2F17C3F2A72;
        Fri, 22 Oct 2021 08:22:08 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl C2F17C3F2A72
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1634883729; bh=SZRsIAVjwl/fGrV50XRToP/ca4ndx0e2foaGOICu3jQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=S28uQH752FInqfEJ1+uORz6WObO3cpnQiaRfRgvgk7bcnp9yPv/popFvOSuqzp8To
         4WAR5aqhoeDhPi0OYMbhbRjgSLSvCbjxliUq2STkmvL8eDA+hueqU9dzobEwuMWXEp
         keQJiLZZ98S97DG/mo+MJPuDDZW3FtAQv4qZ7pT4=
From:   =?utf-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 12/12] net: hldc_fr: use dev_addr_set()
References: <20211021131214.2032925-1-kuba@kernel.org>
        <20211021131214.2032925-13-kuba@kernel.org>
Sender: khalasa@piap.pl
Date:   Fri, 22 Oct 2021 08:22:08 +0200
In-Reply-To: <20211021131214.2032925-13-kuba@kernel.org> (Jakub Kicinski's
        message of "Thu, 21 Oct 2021 06:12:14 -0700")
Message-ID: <m3fsstd1f3.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-KLMS-Rule-ID: 3
X-KLMS-Message-Action: skipped
X-KLMS-AntiSpam-Status: not scanned, whitelist
X-KLMS-AntiPhishing: not scanned, whitelist
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, not scanned, whitelist
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Krzysztof Ha=C5=82asa <khalasa@piap.pl>

> --- a/drivers/net/wan/hdlc_fr.c
> +++ b/drivers/net/wan/hdlc_fr.c
> @@ -1093,7 +1093,9 @@ static int fr_add_pvc(struct net_device *frad, unsi=
gned int dlci, int type)
>  		dev->priv_flags &=3D ~IFF_TX_SKB_SHARING;
>  		eth_hw_addr_random(dev);
>  	} else {
> -		*(__be16 *)dev->dev_addr =3D htons(dlci);
> +		__be16 addr =3D htons(dlci);
> +
> +		dev_addr_set(dev, (u8 *)&addr);
>  		dlci_to_q922(dev->broadcast, dlci);
>  	}
>  	dev->netdev_ops =3D &pvc_ops;

--=20
Krzysztof "Chris" Ha=C5=82asa

Sie=C4=87 Badawcza =C5=81ukasiewicz
Przemys=C5=82owy Instytut Automatyki i Pomiar=C3=B3w PIAP
Al. Jerozolimskie 202, 02-486 Warszawa
