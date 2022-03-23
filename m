Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4BD4E556A
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 16:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbiCWPl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 11:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238021AbiCWPl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 11:41:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF3729CB5;
        Wed, 23 Mar 2022 08:39:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC4076177B;
        Wed, 23 Mar 2022 15:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FD3C340E8;
        Wed, 23 Mar 2022 15:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648049995;
        bh=iacNN7d5mX6fsCUOLqHY8dcfUv0KxLbZ4ptrFKgCpKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CJUObmoF+BC2k1eUayP28y2jJNq+6bEPveWl9BwdeI/BOiAJyf1ZILg2PGcj6W8Gb
         CIjYcnL8gCg41v041iv9voUX2UlEe4sadKhD7sWpyZR2Wkfvsrs/m57AXOydbpCWuD
         FKwQ3hXU+YoUNn6VLwWcQKonJuQKehZpNqx9WcsKq6CgYzxNM0r/R6xkD6F3/yX/Y4
         19tqyWnuAS837+Q5umGl4S3NQPiKo/E/CN91NX/NABPUbz3OV37TrF6y4zz9zKGaXE
         5UUpHTqndbLbVD26mfsqAX6c061RSgMyh8D4UraJ/u2bVkhTgVDcOKBqtOOTyEkM84
         FfWX0Z1Ymi6ZA==
Date:   Wed, 23 Mar 2022 08:39:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: realtek: make interface drivers
 depend on OF
Message-ID: <20220323083953.46cdccc8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220323134944.4cn25vs6vaqcdeso@bang-olufsen.dk>
References: <20220323124225.91763-1-alvin@pqrs.dk>
        <YjsZVblL11w8IuRH@lunn.ch>
        <20220323134944.4cn25vs6vaqcdeso@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Mar 2022 13:48:56 +0000 Alvin =C5=A0ipraga wrote:
> The driver has been split in net-next and deviates significantly from
> what is in net. I can send a patch to net as well, but that will not
> cover net-next.
>=20
> View from net:
>=20
>     drivers/net/dsa/Kconfig:
>     ...
>     config NET_DSA_REALTEK_SMI
>     ...
>=20
> View from net-next:
>=20
>     drivers/net/dsa/Kconfig:
>     ...
>     source "drivers/net/dsa/realtek/Kconfig"
>     ...
>=20
>     drivers/net/dsa/realtek/Kconfig:
>     menuconfig NET_DSA_REALTEK
>         ...
>     config NET_DSA_REALTEK_MDIO
>         ...
>     config NET_DSA_REALTEK_SMI
>         ...
>=20
> I am not well-versed in the procedures here, but since 5.17 has now been
> released, isn't it more important to fix 5.18, which will soon have the
> net-next branch merged in? Hence the patch should target net-next?
>=20
> As for 5.17 and the old (net) structure, I can send a separate patch to
> net. Does that sound OK?
>=20
> Once that is clarified I can re-send with a Fixes: tag.

Just reply with a Fixes tag, I'll sort it out. I'm about to merge=20
the trees so it's a little bit of a special situation.
