Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F3F4B12DB
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244275AbiBJQgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:36:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244267AbiBJQgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:36:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2462A137
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:36:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC6EFB82509
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 16:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A47D7C340EE;
        Thu, 10 Feb 2022 16:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644510995;
        bh=mCQICEZA7CWkvNyIMnKSrGh0FfTFNcSJp2KrJSF8qug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yjqa30hqObo75C02OHzkZTILPeOCzyVl3VQxLGukACK0E2NE6aarOrAF4YNyJKa/z
         Y7TKAFUaJiIFKmLmfxk4bG0m14VCSzJsLiHudNbiJNOIVU8dM6ajPaDvPgFOGz9wcM
         dIB1MZ6cuJ9F61ILTFKQOc24V0lEG9N3G8mTCG5FCMEQT4FWum5sza+96xiG2m9td9
         F4H6ugRV24pRkWI3aKZcSu7H2ksXXaB1jO6Poan3ifxFpfAFJC+l93LpkCPGdTE9Gz
         hIDmyCuvec+mCaOviP8B7CZl3vxSyriKIrdLWb2/xHbqry5nAvP7UMESsDs0t0pznj
         JhXyxR6jiIdLg==
Date:   Thu, 10 Feb 2022 17:36:32 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [v6] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Message-ID: <20220210173632.13e31df3@dellmb>
In-Reply-To: <AM0PR0602MB3666A3A51C6F92ABAB6ED213F72F9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20220210084322.15467-1-holger.brunck@hitachienergy.com>
        <20220210151635.4b170f5c@dellmb>
        <AM0PR0602MB3666A3A51C6F92ABAB6ED213F72F9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 16:26:17 +0000
Holger Brunck <holger.brunck@hitachienergy.com> wrote:

> > > The mv88e6352, mv88e6240 and mv88e6176  have a serdes interface. This
> > > patch allows to configure the output swing to a desired value in the
> > > phy-handle of the port. The value which is peak to peak has to be
> > > specified in microvolts. As the chips only supports eight dedicated
> > > values we return EINVAL if the value in the DTS does not match one of
> > > these values.
> > >
> > > CC: Andrew Lunn <andrew@lunn.ch>
> > > CC: Jakub Kicinski <kuba@kernel.org>
> > > CC: Marek Beh=C3=BAn <kabel@kernel.org>
> > > Signed-off-by: Holger Brunck <holger.brunck@hitachienergy.com> =20
> >=20
> > Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
> >=20
> > Keep in mind that the tx-p2p-amplitude DT property is not merged in DT =
yet. I
> > suggest you resend this patch as a series of 2 patches, the first being=
 the DT
> > patch:
> >   https://lore.kernel.org/linux-devicetree/20220119131117.30245-1-
> > kabel@kernel.org/
> > where you should also add Rob's reviewed-by tag, which he sent in
> >   https://lore.kernel.org/linux-
> > devicetree/YgGBe0BS%2Fd0lOVtU@robh.at.kernel.org/
> >  =20
>=20
> I can do that. But then it has to go through the netdev-next tree or? As =
I have
> now dependencies to Russels changes which are sitting in netdev-next.

Yes, your patches should have tag net-next.

Marek
