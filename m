Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41033692A74
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbjBJWrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbjBJWrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:47:39 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5D47E8CA;
        Fri, 10 Feb 2023 14:47:28 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2DC3C240003;
        Fri, 10 Feb 2023 22:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676069246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gaGdZZT4BhNgokFlOzesjQoSQqCokYH80wS11iAZ8/Q=;
        b=RY/2CK8FcEDoDbL+HvOO49x0/8uZ6rqIKF9hoF7wBGRS6fqcKFnqQk3QN1sg4HrHKJkbgQ
        87jk+YA3bs3IZlk6/AiC+A0NnmgfcQQFyW+0ToEItj9r+4zeeNVorrEVosTKYaZDD96Ogz
        xcdaAFC+NsqWzu2CdhawkypkH78rYaYVblY649TjR9EjuN73LZM8b1IjcnrD4NEIspxYLb
        qQTyC7+u6V402p+Xt00U4GvPz97k6DmC9VHnnvR5jFOtxaJ/PfNV2970m+tGRzzsxsqquC
        UOmzWr2NGAKReJ2Q9AGSQh9+4Pwyg93LLq9qjo18XcM5+1i0pblIoGO/cRZOcw==
Date:   Fri, 10 Feb 2023 23:47:22 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning
 requests
Message-ID: <20230210234722.4cf0934f@xps-13>
In-Reply-To: <20230210105925.26c54e15@kernel.org>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <20230203201923.6de5c692@kernel.org>
        <20230210111843.0817d0d3@xps-13>
        <20230210105925.26c54e15@kernel.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

kuba@kernel.org wrote on Fri, 10 Feb 2023 10:59:25 -0800:

> On Fri, 10 Feb 2023 11:18:43 +0100 Miquel Raynal wrote:
> > > > +	/* Monitors are not allowed to perform scans */
> > > > +	if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MONITOR)     =20
> > >=20
> > > extack ?   =20
> >=20
> > Thanks for pointing at it, I just did know about it. I did convert
> > most of the printk's into extack strings. Shall I keep both or is fine
> > to just keep the extack thing?
> >=20
> > For now I've dropped the printk's, please tell me if this is wrong. =20
>=20
> That's right - just the extack, we don't want duplicated prints.

Thanks for the confirmation.

Series ready, I need to test it further just to verify there is no
unwanted regression, I'll send it early next week.

Thanks,
Miqu=C3=A8l
