Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B926E60D7A9
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 01:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbiJYXIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 19:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbiJYXID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 19:08:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25428E985F;
        Tue, 25 Oct 2022 16:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2DDE61BA9;
        Tue, 25 Oct 2022 23:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE94DC433C1;
        Tue, 25 Oct 2022 23:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666739282;
        bh=pn3rcfbfIfY0TEQWDwy84ohmjEImsqQ+lTPswiWJZe0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TeCh6hlxLll3D83hsiAjAoX+3amar3OSKDICsDxNhgQsXDO/60jwm2LNbp2PC5F/2
         5YLSVXxAuhYU11m56HbZt0M93mTbUqpFINL9Bfz/JxkFkNmkKNjQPx1RFhG6BnBR/i
         lXWdeySWCTyh9gj9bPjAuqIWg3pNQo1nArVr3YNuWYov+M+9qCx0JU0KrKoY7ah1Fb
         POB5bnjAzcl/kiW/J/YUmzmfHmObEUghVeHujNk56LjXQs0W/cKcUMzonQIFAu+wco
         dW/V52rDujz7CmBleUg1SKGTukFVcORlLfWH70hdMyR4Z6GH7wcxu5Swf5ZzbQFwTx
         yZJu4cmja8icA==
Date:   Tue, 25 Oct 2022 16:08:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>, Juergen Borleis <jbe@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] net: fec: limit register access on i.MX6UL
Message-ID: <20221025160800.4eda6f50@kernel.org>
In-Reply-To: <Y1fbaY6SSLppusvx@lunn.ch>
References: <20221024080552.21004-1-jbe@pengutronix.de>
        <Y1fbaY6SSLppusvx@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 14:49:45 +0200 Andrew Lunn wrote:
> On Mon, Oct 24, 2022 at 10:05:52AM +0200, Juergen Borleis wrote:
> > Using 'ethtool -d [=E2=80=A6]' on an i.MX6UL leads to a kernel crash:
> >=20
> >    Unhandled fault: external abort on non-linefetch (0x1008) at [=E2=80=
=A6]
> >=20
> > due to this SoC has less registers in its FEC implementation compared t=
o other
> > i.MX6 variants. Thus, a run-time decision is required to avoid access to
> > non-existing registers.
> >=20
> > Signed-off-by: Juergen Borleis <jbe@pengutronix.de> =20
>=20
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

What would be the right Fixes tag for this? This one perhaps?

Fixes: a51d3ab50702 ("net: fec: use a more proper compatible string for i.M=
X6UL type device")
