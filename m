Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECA366BA19
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbjAPJRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbjAPJRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:17:08 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047C715543;
        Mon, 16 Jan 2023 01:17:06 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 80D7A240009;
        Mon, 16 Jan 2023 09:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673860625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tdSLahJGG9ZLaHYSPHl852UcYrbkiUiQZKiDDskVsnM=;
        b=PCXOzVQPQLdt5HNtqyFfWHiifex63eRKe8Ou4OdgPBavdxwJXQBS4QQHVCUOxnDpad49E7
        O1xoCc5V6ZuBte8qnjQEQGsi+EtQIFBoFnL/1DV7Pksxguuzj9LRgOjVkSlotNxgF/yiyQ
        ZFa8ZCURDR3VEg32i9Pf4b+1yGUTEG7H0f5EPjoSq2Ng1PwgYooEw4GRYk60qtf8csVz6n
        FtscfALaBV1kCBvBhg4Lse3U1XGUiufh0YYCsf+WfWFH6DNzxfXPN+ZcHe/YtjOYjWqsBv
        mW8fG0Ymzx/aGlkoYz/XtQ8ZoMJLIETEr6jtqzKv0UrsGongj/B+2TCVo4dNMQ==
Date:   Mon, 16 Jan 2023 10:19:14 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>
Subject: Re: [PATCH net-next] net: dsa: rzn1-a5psw: Add vlan support
Message-ID: <20230116101914.2998445b@fixe.home>
In-Reply-To: <20230113151248.22xexjyxmlyeeg7r@skbuf>
References: <20230111115607.1146502-1-clement.leger@bootlin.com>
        <20230113151248.22xexjyxmlyeeg7r@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
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

Le Fri, 13 Jan 2023 17:12:48 +0200,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> On Wed, Jan 11, 2023 at 12:56:07PM +0100, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add support for vlan operation (add, del, filtering) on the RZN1
> > driver. The a5psw switch supports up to 32 VLAN IDs with filtering,
> > tagged/untagged VLANs and PVID for each ports.
> >=20
> > Signed-off-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>
> > --- =20
>=20
> Have you run the bridge_vlan_aware.sh and bridge_vlan_unaware.sh from
> tools/testing/selftests/drivers/net/dsa/?

Nope, I will do that.

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
