Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A815A586E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 02:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiH3AaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 20:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiH3AaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 20:30:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59662A70A
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 17:30:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EC7F61453
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C625C433C1;
        Tue, 30 Aug 2022 00:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661819405;
        bh=XBbIV7Eia/AgEignHvqsTa07uXydI/N9ifdf6ChYLf8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UYUqOFOnl7Cg5Od+KgMxvITEFcrSu2ozszO1/JRRF1yOrRxYc1vjWjdI62/cVNM4p
         jbN9Mx2uAvseSlcA4pVTZJsVbeRu5cLvb7vCO6rF1jxhXRAe+4HtQrPWj8/Tq9vGJN
         4JGskDpGgeUi2Cj+tIIs8kdcZxWCBi71BB/WneYitcwuvzRs6MJLRRSIb/ju5kvsZd
         SrUFRsp52S2ri+b13xpzX0Y0p1+c0rJfbYLBrFv6Xz5Y9onaGF2AILEpH/hdJeMqFS
         zlESls+nkJT+9UtRBabDuZzoCej5hEIcMRDMjYanFjX72gx9tvAghtY2iMUrtGIZ4O
         5hxmYMv3bRu2w==
Date:   Mon, 29 Aug 2022 17:30:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] sfc: add support for PTP over IPv6 and
 802.3
Message-ID: <20220829173006.0cd5c126@kernel.org>
In-Reply-To: <YwzmFPrWmmU7XI+i@lunn.ch>
References: <20220819082001.15439-1-ihuguet@redhat.com>
        <20220825090242.12848-1-ihuguet@redhat.com>
        <YwegaWH6yL2RHW+6@lunn.ch>
        <CACT4oufGh++TyEY-FdfUjZpXSxmbC0W2O-y4uprQdYFTevv2pw@mail.gmail.com>
        <YwjB84tvHAPymRRn@lunn.ch>
        <CACT4oudsW5LNdwDbaKK7=DX9wiPua1cYdQ7DLuRsNoZmV8=tmQ@mail.gmail.com>
        <YwzPbIxDOaC5h1pK@hoboy.vegasvil.org>
        <YwzmFPrWmmU7XI+i@lunn.ch>
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

On Mon, 29 Aug 2022 18:15:16 +0200 Andrew Lunn wrote:
> On Mon, Aug 29, 2022 at 07:38:36AM -0700, Richard Cochran wrote:
> > On Mon, Aug 29, 2022 at 09:09:48AM +0200, =C3=8D=C3=B1igo Huguet wrote:=
 =20
> > > Richard, missed to CC you in this patch series, just in case it's of
> > > your interest. =20
> >=20
> > I do appreciate being on CC for anything PTP related. =20
>=20
> Russell King had the issue he was being missed on a lot of PHYLINK
> patches. He updated the MAINTAINERS entry with:
>=20
> K:	phylink\.h|struct\s+phylink|\.phylink|>phylink_|phylink_(autoneg|clear=
|connect|create|destroy|disconnect|ethtool|helper|mac|mii|of|set|start|stop=
|test|validate)
>=20
> Maybe you could add some sort of regex for common ptp functions and struc=
tures?

+1
