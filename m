Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4177F5BFE31
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiIUMrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiIUMrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:47:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10B38A7C2
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 05:47:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 675FE62625
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 12:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E93C433C1;
        Wed, 21 Sep 2022 12:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663764430;
        bh=y17SAhblrmfJTV+VUStfgBXoEfAYYU7qSjMW1O3ojSA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SnVPabFkGJFp6XC/yqLLDhNU61iW6ehZgMxb9K3n0XXteRkoHBrIe81jjbz0u6EoT
         ealBXN5hDM3NLI42KZPFICHTshmzi3g0DXl7Y/vJb6h1nnXJSVEQ7OHkCKMZoenDJ9
         dp2zrBfgPnglo3mxHrGD0b37RAP+8lOYNJKm36K0/Ravo6P3sXCV7gUvTl4UvkIiR7
         sF6kSwl8KiOt8ePanA7MgsVNCSCI4XCTES4RIlu4d/IGYHa8bMNZY71wnzWrLhO0W7
         fDvYxtl3JvBA/GUaB9in8ey+OrL5skGuQCqu1k0W3lIBRXnygHMehF3kRo2dindP39
         1unkW9xowpckQ==
Date:   Wed, 21 Sep 2022 05:47:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>,
        Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        kernel@pengutronix.de, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: fjes: Reorder symbols to get rid of a few forward
 declarations
Message-ID: <20220921054709.150841af@kernel.org>
In-Reply-To: <20220921064935.t24cjwgkesjr5ebn@pengutronix.de>
References: <20220917225142.473770-1-u.kleine-koenig@pengutronix.de>
        <20220920164435.55c026d3@kernel.org>
        <20220921064935.t24cjwgkesjr5ebn@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 08:49:35 +0200 Uwe Kleine-K=C3=B6nig wrote:
> On Tue, Sep 20, 2022 at 04:44:35PM -0700, Jakub Kicinski wrote:
> > On Sun, 18 Sep 2022 00:51:42 +0200 Uwe Kleine-K=C3=B6nig wrote: =20
> > > Quite a few of the functions and other symbols defined in this driver=
 had
> > > forward declarations. They can all be dropped after reordering them.
> > >=20
> > > This saves a few lines of code and reduces code duplication.
> > >=20
> > > Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>=
 =20
> >=20
> > Any reason why do this? =20
>=20
> The motivation was a breakage I introduced in another driver when I
> changed the prototype of a function and failed to adapt the declaration.
> (See 2dec3a7a7beb ("macintosh/ams: Adapt declaration of ams_i2c_remove()
> to earlier change") in today's next for the ugly details.)
>=20
> Currently I work on changing the prototype for the remove callback of
> platform drivers. So the patch here is prepatory work to make the latter
> change easier to do and review.
>=20
> > There's a ton of cobwebbed code with pointless forward declarations. =20
>=20
> For sure I won't address all of them. But if I stumble over one and find
> a few spare minutes I fix one at a time.
>=20
> > Do you have the HW and plan to work on the driver? =20
>=20
> I neither have the hardware nor do I plan to work on the driver. It's
> just a platform driver I might touch at some point in the future to
> adapt for a core driver change.

Alright, let me ask the obligatory question - Yasuaki is there any
chance that this driver is obsolete? I presume not, so would you be
willing to volunteer as the maintainer to review related patches?
