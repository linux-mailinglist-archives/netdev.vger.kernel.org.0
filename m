Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFD666DC7F
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbjAQLdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236873AbjAQLcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:32:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5418B1E9F7
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673955124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DebkQxtJhC7y5UTBvuSa17RQTzE64CoNiuX1iOcLPqY=;
        b=LQLH3Q3ik/69DI2IsioD3cLF7tc0YfWs33xvaRUkvC/rLUKqe7tupaCC8z6wPtr7Xqlc+v
        OcMFM/sNRED9IQLYHFQ7ReAAP8wZDaS3SjDQK3AuSSN4ZnjJSfelu5aeiWeKyoAZBhB4hw
        H9r3Q6rcOc9Rv6A0/ywCGOGPk/YCLCU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-248-sCuD6z-JPOG13wTmWSwSDg-1; Tue, 17 Jan 2023 06:32:03 -0500
X-MC-Unique: sCuD6z-JPOG13wTmWSwSDg-1
Received: by mail-qt1-f197.google.com with SMTP id f2-20020ac80682000000b003b6364059d2so1320243qth.9
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:32:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DebkQxtJhC7y5UTBvuSa17RQTzE64CoNiuX1iOcLPqY=;
        b=QGZzqbXd17mtmqwdeHTt2h5x1NRCNiTlpggPgzcGO+i+ZQ1hd0bYoppMc3YEW8VooZ
         sRvPktDHErByuiHsI0JBAN+trNA3bSTI9uoXAM8yxBrh3heXgFfodvn+NONvFBhIidzn
         E4+xMiklhWo/8LwHXJEtj1Tj/H2aA3wjl2XvL+R1SFjuugARvwrgNNwai7TMUkx12LG1
         XSpv86LKP0iNHYna09Oyoqa8f0Lj7cuOhXv90iYsyeeH65PmVE8PJyhHgzG/lJ/XgeG2
         5n4zk3ASuj/WG55VAAY63FUiAx0HNotJEuYMZIgD6A7Aif+/9w2SpGANLXmpF8b+1bBW
         2N8w==
X-Gm-Message-State: AFqh2krOfbDJSfBpSAVc0UJuABs7n/ik//Ahyecppz7EyY6ze3X3pdHK
        ZML8eGhsg1EQIKGjsr1gn+YPF40HJqHu91Pk6pODMi6wVbPF3egDTNBUVMfW3Q7bYPYjCqi1Uxb
        0JiytBsu6SMucKSCs
X-Received: by 2002:ac8:6a0e:0:b0:3ab:7928:526c with SMTP id t14-20020ac86a0e000000b003ab7928526cmr3042311qtr.17.1673955122624;
        Tue, 17 Jan 2023 03:32:02 -0800 (PST)
X-Google-Smtp-Source: AMrXdXthAaLgwtHhzoNI/07Aw8e+FIGR/OQBFYxTJ6yUJIz5jQf4eIazUokO3DCXe5mTOziMfaSYcA==
X-Received: by 2002:ac8:6a0e:0:b0:3ab:7928:526c with SMTP id t14-20020ac86a0e000000b003ab7928526cmr3042283qtr.17.1673955122339;
        Tue, 17 Jan 2023 03:32:02 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-115-179.dyn.eolo.it. [146.241.115.179])
        by smtp.gmail.com with ESMTPSA id t11-20020a05620a034b00b006fa31bf2f3dsm19759626qkm.47.2023.01.17.03.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 03:32:01 -0800 (PST)
Message-ID: <5ce7d9c3db722ebb46d1e10ef79812c83bab010f.camel@redhat.com>
Subject: Re: [PATCH net] net: mdio: validate parameter addr in
 mdiobus_get_phy()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Tue, 17 Jan 2023 12:31:59 +0100
In-Reply-To: <cdf664ea-3312-e915-73f8-021678d08887@gmail.com>
References: <cdf664ea-3312-e915-73f8-021678d08887@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-01-15 at 11:54 +0100, Heiner Kallweit wrote:
> The caller may pass any value as addr, what may result in an out-of-bound=
s
> access to array mdio_map. One existing case is stmmac_init_phy() that
> may pass -1 as addr. Therefore validate addr before using it.
>=20
> Fixes: 7f854420fbfe ("phy: Add API for {un}registering an mdio device to =
a bus.")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/mdio_bus.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 902e1c88e..132dd1f90 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -108,7 +108,12 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
> =20
>  struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
>  {
> -	struct mdio_device *mdiodev =3D bus->mdio_map[addr];
> +	struct mdio_device *mdiodev;
> +
> +	if (addr < 0 || addr >=3D ARRAY_SIZE(bus->mdio_map))
> +		return NULL;

Speaking of possible follow-ups, would it make sense to add a
WARN_ON_ONCE() or similar on the above condition?

Thanks!

Paolo
>=20

