Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B20E6A7D0B
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 09:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCBIs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 03:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCBIsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 03:48:55 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8185F11664;
        Thu,  2 Mar 2023 00:48:52 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4929124000D;
        Thu,  2 Mar 2023 08:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1677746931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MuiZ6DAalCFX0pWZRSXORPzDV2NDJW8mufoPL0S2PjI=;
        b=dLlXRK0eZnFh1oZ94fBZRhOpeGA22zxgYnp8ynPPBrkSDpMz/VEL2LpUeQbYThLYlFBAzA
        pMsPlFqlDuYsCiAM9YLw5wmxp0Re/E5LF4T//4JecvmMenxXJ2P0nnQOMMjTJF3SS0cAw1
        1u5xizByNYYl06GZRgmee3UGjgDAvm+tCivInM2ZB69/qb1EevYn2bHxDuTl8Gm3dVPX4S
        p6vq3nUpBAVAEb8cycIO4Dn8fzjRG3AUDXW+UuDKPsxkfd1owJALie3Orb4/GK5P9DqBKZ
        w3529T0xuBdCRB64tVeJiwxDHM44aN63eOKwqyL8W0JYiZtBOaXkjPZK2BCtqQ==
Date:   Thu, 2 Mar 2023 09:48:48 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
Subject: Re: [PATCH net] ieee802154: Prevent user from crashing the host
Message-ID: <20230302094848.206f35ae@xps-13>
In-Reply-To: <20230301154450.547716-1-miquel.raynal@bootlin.com>
References: <20230301154450.547716-1-miquel.raynal@bootlin.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

miquel.raynal@bootlin.com wrote on Wed,  1 Mar 2023 16:44:50 +0100:

> Avoid crashing the machine by checking
> info->attrs[NL802154_ATTR_SCAN_TYPE] presence before de-referencing it,
> which was the primary intend of the blamed patch.

Subject should have been wpan instead of net, sorry for the confusion.

> Reported-by: Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Fixes: a0b6106672b5 ("ieee802154: Convert scan error messages to extack")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>  net/ieee802154/nl802154.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index 88380606af2c..a18fb98a4b09 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -1412,7 +1412,7 @@ static int nl802154_trigger_scan(struct sk_buff *sk=
b, struct genl_info *info)
>  		return -EOPNOTSUPP;
>  	}
> =20
> -	if (!nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
> +	if (!info->attrs[NL802154_ATTR_SCAN_TYPE]) {
>  		NL_SET_ERR_MSG(info->extack, "Malformed request, missing scan type");
>  		return -EINVAL;
>  	}


Thanks,
Miqu=C3=A8l
