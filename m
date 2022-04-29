Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A78C51549A
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 21:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380321AbiD2TgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 15:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380314AbiD2Tf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 15:35:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F26E5EBF5;
        Fri, 29 Apr 2022 12:32:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A841D62456;
        Fri, 29 Apr 2022 19:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFD4C385A7;
        Fri, 29 Apr 2022 19:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651260758;
        bh=Ag7BpgOds0uINJVlgHiuuJlnALHlbLEYKL2UBUqEfOQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jc9oQuMM8H3jgbPeBouKqVPN8LT1iPUrsBKYhZJrDIwvnZZl93bDI5L78OrAkQg0U
         Z6ejTumSNetWN4LIhT3iDGapGiqqQTrEmdGjFQAlznNdo9wUAzBXecZIBQZIofFaLe
         nCFjnzp5sCgVAGR6VwDQcfl2fY/ftPbtDUIllNUG/u1PuYtRmC6cnsJNtLVzAygOAO
         zc8qoqogrPdB+2P8pUFelWTsFycai6sgONwLZ696HT1XjFqBwXQNpyxnovizDIWE58
         4oBQv3tt6OZBSYiP9y7Dj0pu2dM7H64FLsHje8HM8LMUekv3uPg4JQNuw2TYKUAZwC
         ik1eQpOiSuqoA==
Date:   Fri, 29 Apr 2022 12:32:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next v2 00/12] add support for Renesas RZ/N1 ethernet
 subsystem devices
Message-ID: <20220429123235.3098ed12@kernel.org>
In-Reply-To: <20220429143505.88208-1-clement.leger@bootlin.com>
References: <20220429143505.88208-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 16:34:53 +0200 Cl=C3=A9ment L=C3=A9ger wrote:
> The Renesas RZ/N1 SoCs features an ethernet subsystem which contains
> (most notably) a switch, two GMACs, and a MII converter [1]. This
> series adds support for the switch and the MII converter.
>=20
> The MII converter present on this SoC has been represented as a PCS
> which sit between the MACs and the PHY. This PCS driver is probed from
> the device-tree since it requires to be configured. Indeed the MII
> converter also contains the registers that are handling the muxing of
> ports (Switch, MAC, HSR, RTOS, etc) internally to the SoC.
>=20
> The switch driver is based on DSA and exposes 4 ports + 1 CPU
> management port. It include basic bridging support as well as FDB and
> statistics support.

Build's not happy (W=3D1 C=3D1):

drivers/net/dsa/rzn1_a5psw.c:574:29: warning: symbol 'a5psw_switch_ops' was=
 not declared. Should it be static?
In file included from ../drivers/net/dsa/rzn1_a5psw.c:17:
drivers/net/dsa/rzn1_a5psw.h:221:1: note: offset of packed bit-field =E2=80=
=98port_mask=E2=80=99 has changed in GCC 4.4
  221 | } __packed;
      | ^

drivers/net/dsa/rzn1_a5psw.h:200: warning: Function parameter or member 'hc=
lk' not described in 'a5psw'
drivers/net/dsa/rzn1_a5psw.h:200: warning: Function parameter or member 'cl=
k' not described in 'a5psw'

Not sure how many of these are added by you but I think 2 at least.
