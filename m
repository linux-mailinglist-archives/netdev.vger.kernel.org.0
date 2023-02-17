Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1C569A7E1
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBQJLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBQJLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:11:08 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271EB8690;
        Fri, 17 Feb 2023 01:11:03 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 409821C0005;
        Fri, 17 Feb 2023 09:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676625062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y4pAln/H63lw/LsUNGnO9M6BOkwcZBtic8ceAZoF4OU=;
        b=HieIVIuEjLxptW1+ycMbfmYzjfg5yAJer64GeUthfyhu2/mnc0x48KEodVGk4BRkfq7M6j
        fO+0T90cxKWE7+QtOqvl3EkH5eDAy1ezxTpOfLtoi01LDXw4O8aHXC8kkq126yU020ZHK5
        Gi1obAGTE88COJRdGyWMzgv88vM8d6CVOLQ5C+UBmcNKZN7p0dQq/izS6lH4lbQLm8ZGLv
        qelFCOEqHU2SMdrVpzmwIgyFHjSU7okqft+J83E27eicogdENav0Je2D7eSfJcen2zYo4D
        EWuKJd/6+TVL/JuFohzCtLNxPuFQKXzyXEEfTAm0HN/jD7UmlBPc2voqLkgc4Q==
Date:   Fri, 17 Feb 2023 10:10:58 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan v2 0/6] ieee802154: Scan/Beacon fixes
Message-ID: <20230217101058.0bb5df34@xps-13>
In-Reply-To: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
References: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
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

Hello Jakub, Stefan, Alexander,

miquel.raynal@bootlin.com wrote on Tue, 14 Feb 2023 14:50:29 +0100:

> Hello,
>=20
> Following Jakub's review on Stefan's MR, a number of changes were
> requested for him in order to pull the patches in net. In the mean time,
> a couple of discussions happened with Alexander (return codes for
> monitor scans and transmit helper used for beacons).
>=20
> Hopefully this series addresses everything.

I know it's only been 3 working days since I sent this series but as we
are approaching the closing of net-next and Stefan's MR was paused
until these fixes arrived, I wanted to check whether these changes
might be satisfying enough, in particular Jakub, if you found the
answers you asked for.

I mainly want to avoid the "Stefan waits for Alexander who waits for
Jakub who waits for Stefan" dependency chain :)

Thanks a lot for all the feedback anyway!
Miqu=C3=A8l

> Changes in v2:
> * Fixes lines with upsteam commit hashes rather than local
>   hashes. Everything else is exactly the same.
>=20
> Miquel Raynal (6):
>   ieee802154: Use netlink policies when relevant on scan parameters
>   ieee802154: Convert scan error messages to extack
>   ieee802154: Change error code on monitor scan netlink request
>   mac802154: Send beacons using the MLME Tx path
>   mac802154: Fix an always true condition
>   ieee802154: Drop device trackers
>=20
>  net/ieee802154/nl802154.c | 125 ++++++++++++++------------------------
>  net/mac802154/scan.c      |  25 ++++++--
>  2 files changed, 65 insertions(+), 85 deletions(-)
>=20
