Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C710542518
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349274AbiFHBsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 21:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbiFHBrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 21:47:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A385F89;
        Tue,  7 Jun 2022 17:07:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B4D7B82464;
        Wed,  8 Jun 2022 00:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73D1C34114;
        Wed,  8 Jun 2022 00:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654646863;
        bh=CrcbDSIMUGUy9BjrLMTLkVHJ9psx3y4Wlntj3nvGas8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LOKNhmAcCbw2DyoNFmC8yOted5y6dRFfpppHX0nlrIAYPztLgqpDh/HOnucUWb1R3
         EuE96CqG9M/p4zQxhgkwP3jwJLoxP7FKHkKS98g5JeYYqBpAvgmvnaXUL7WN8KydpM
         gy1j/bnBosk7wk/z1Fa6tlAApLwasoov/VlSCIWr09Zyngys4B5SzUSh0e31/SKluo
         l5M2KrUKROwRUt8f8QgUDOof2RZRc9VmbekOwjqsP5uQxLg1Jd+PhxPwR5mkLhnKMw
         qzorHcJbex7ncdUOkHOLDxSDhMamdau2ayN3/25FXxp2WlBQ8IVN+F+5gjLWSsqign
         UvTMJNsbOV9Xg==
Date:   Tue, 7 Jun 2022 17:07:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Max Staudt <max@enpas.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 4/7] can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
Message-ID: <20220607170741.05bea62d@kernel.org>
In-Reply-To: <CAMZ6Rq+vYNvrTcToqVqqKSPJXAdjs3RkUY_SNuwB7n9FMuqQiQ@mail.gmail.com>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-1-mailhol.vincent@wanadoo.fr>
        <20220604163000.211077-5-mailhol.vincent@wanadoo.fr>
        <CAMuHMdXkq7+yvD=ju-LY14yOPkiiHwL6H+9G-4KgX=GJjX=h9g@mail.gmail.com>
        <CAMZ6RqLEEHOZjrMH+-GLC--jjfOaWYOPLf+PpefHwy=cLpWTYg@mail.gmail.com>
        <20220607182216.5fb1084e.max@enpas.org>
        <20220607150614.6248c504@kernel.org>
        <CAMZ6Rq+vYNvrTcToqVqqKSPJXAdjs3RkUY_SNuwB7n9FMuqQiQ@mail.gmail.com>
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

On Wed, 8 Jun 2022 08:40:19 +0900 Vincent MAILHOL wrote:
> On Wed. 8 Jun 2022 =C3=A0 07:06, Jakub Kicinski <kuba@kernel.org> wrote:
> > AFAIU Linus likes for everything that results in code being added to
> > the kernel to default to n. =20
>=20
> A "make defconfig" would not select CONFIG_CAN (on which
> CAN_RX_OFFLOAD indirectly depends) and so by default this code is not
> added to the kernel.
>=20
> > If the drivers hard-select that Kconfig
> > why bother user with the question at all? My understanding is that
> > Linus also likes to keep Kconfig as simple as possible. =20
>=20
> I do not think that this is so convoluted. What would bother me is
> that RX offload is not a new feature. Before this series, RX offload
> is built-in the can-dev.o by default. If this new CAN_RX_OFFLOAD does
> not default to yes, then the default features built-in can-dev.o would
> change before and after this series.
>=20
> But you being one of the maintainers, if you insist I will go in your
> direction. So will removing the "default yes" and the comment "If
> unsure, say yes" from the CAN_RX_OFFLOAD satisfy you?

I'm mostly trying to make sure Linus won't complain and block the entire
net-next PR. Unfortunately I don't think the rules are written down
anywhere.

I could well be missing some CAN-specific context here but I see no
practical benefit to exposing a knob for enabling driver framework and
then selecting that framework in drivers as well. The only beneficiary
I can think of is out-of-tree code.

If the framework is optional (covers only parts of the driver's
functionality) we make the knob configurable and drivers should work
with or without it (e.g. PTP).

If the framework is important / fundamental - hide it completely from=20
the user / Kconfig and have the drivers 'select' it as a dependency
(e.g. DEVLINK, PAGE_POOL).

I'm not familiar with examples of the middle ground where we'd both
expose the Kconfig, _and_ select in the drivers. Are there any?

I don't want you to rage-quit over this tho, so we can merge as is and
deal with the consequences.

> > Upstream mentioning out-of-tree modules may have the opposite effect
> > to what you intend :( Forgive my ignorance, what's the reason to keep
> > the driver out of tree? =20
>=20
> I can answer for Max. The can327 patch is under review with the clear
> intent to have it upstream. c.f.:
> https://lore.kernel.org/linux-can/20220602213544.68273-1-max@enpas.org/
>=20
> But until the patch gets accepted, it is defacto an out of tree module.

Good to hear, then it will get upstream in due course, and the problem
will disappear, no?
