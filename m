Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB50535817
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 05:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbiE0Dme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 23:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiE0Dmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 23:42:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B17610CD;
        Thu, 26 May 2022 20:42:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 187EA61DA0;
        Fri, 27 May 2022 03:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3F3C385A9;
        Fri, 27 May 2022 03:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653622947;
        bh=MdaCAYKPMrUNYugf6nu4OyxpClXSxPhr2HuLrA18wKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bRsdZbv9XmtCnV2EOek8DfArcBpbJDh/3IAd44eJJenVazyG/YImbSChLvLVPUvD/
         rzNix7OgkF9JgQQWAZUDnTA4XQY64wZ/BMjnD2CgNZiRGRgU6GxzrF3TfQ2yaRsU1m
         Zy0+DmfGm4yKsqbSZbjVxLsajVfrBUuCh0SkP0whrmOU5yEse1Qpo2z+LbdRiG1bzr
         puHcv4hIHC1a/xyUCOj04F2LNXFDy3nyiglumUYMZB0REuef9aWqau/HUV9sOVmXVv
         Lbf3+r9rCakMW+6AdC5x4cDFbvyOdFqIDruBNC7kr6NCc6hlY/V7iwSE8akjJ15InZ
         TpwBSfslcMbAA==
Date:   Thu, 26 May 2022 20:42:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: ocelot: fix wrong time_after usage
Message-ID: <20220526204225.03b7804c@kernel.org>
In-Reply-To: <20220523160004.6d285609@fixe.home>
References: <YoeMW+/KGk8VpbED@lunn.ch>
        <20220520213115.7832-1-paskripkin@gmail.com>
        <YojvUsJ090H/wfEk@lunn.ch>
        <20220521162108.bact3sn4z2yuysdt@skbuf>
        <20220523160004.6d285609@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 May 2022 16:00:04 +0200 Cl=C3=A9ment L=C3=A9ger wrote:
> > If you're looking at me, I don't have the hardware to test, sorry.
> > Frame DMA is one of the components NXP removed when building their DSA
> > variants of these switches. But the function is called once or twice per
> > NAPI poll cycle, so it's worth optimizing as much as possible.
> >=20
> > Clement, could you please do some testing? The patch that Andrew is
> > talking about is 35da1dfd9484 ("net: dsa: mv88e6xxx: Improve performance
> > of busy bit polling"). =20
>=20
> Ok, I'll have to wake up that ocelot board but I'll try to do that.

We can't hold it in PW for much longer, please repost once tested.
