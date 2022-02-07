Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C504AB632
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 09:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiBGH7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 02:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234070AbiBGHtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 02:49:25 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4138AC043185;
        Sun,  6 Feb 2022 23:49:24 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CFCAB60004;
        Mon,  7 Feb 2022 07:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644220162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G7cxc0gAWU4rslnbS/39RP9AnfZM5ZxAcoe/N8KOCDg=;
        b=WQl4EY7xn77qNVFoI7VVQiNSXhFLGEMWvDFI1GS7eWLU4ZdmWd6p8u9GRt53FU0XJ/6IOR
        MYa82OOSLKHnXoXddhR/Y9iHNomnXQ2GevDxiF3dbYfGTU7R5CzLjMNqJU51PrSYxjsJ4J
        Bkyl/hO3L7kBf+Yv9A+WlwJhrQkMRjB5odW3vne96D/iE0SU/Hi2FBSbSGzFL3xDI3ig2I
        PLimWmqNKE8902mBDsemaUdQE14h7rmqG0wnm9nCMiIGmapAZIdR3/Qztwq5G50R9JRzWj
        z3NlyM0sM0xwFhUK1PQxA1PhzMs9EkxaREQOaO+kFWgwzdKRVP8RQ78pXuEvGg==
Date:   Mon, 7 Feb 2022 08:49:18 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>
Subject: Re: [PATCH wpan-next v2 1/5] net: ieee802154: Improve the way
 supported channels are declared
Message-ID: <20220207084918.0c2e6d13@xps13>
In-Reply-To: <CAB_54W5mnovPX0cyq5dwVoQKa6VZx3QPCfVoPAF+LQ5DkdQ3Mw@mail.gmail.com>
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
        <20220128110825.1120678-2-miquel.raynal@bootlin.com>
        <CAB_54W60OiGmjLQ2dAvnraq6fkZ6GGTLMVzjVbVAobcvNsaWtQ@mail.gmail.com>
        <20220131152345.3fefa3aa@xps13>
        <CAB_54W7SZmgU=2_HEm=_agE0RWfsXxEs_4MHmnAPPFb+iVvxsQ@mail.gmail.com>
        <20220201155507.549cd2e3@xps13>
        <CAB_54W5mnovPX0cyq5dwVoQKa6VZx3QPCfVoPAF+LQ5DkdQ3Mw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Sun, 6 Feb 2022 16:37:23 -0500:

> Hi,
>=20
> On Tue, Feb 1, 2022 at 9:55 AM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> ...
> >
> > Given the new information that I am currently processing, I believe the
> > array is not needed anymore, we can live with a minimal number of
> > additional helpers, like the one getting the PRF value for the UWB
> > PHYs. It's the only one I have in mind so far. =20
>=20
> I am not really sure if I understood now. So far those channel/page
> combinations are the same because we have no special "type" value in
> wpan_phy,

Yes, my assumption was more: I know there are only -legacy- phy types
supported, we will add another (or improve the current) way of defining
channels when we'll need to. Eg when improving UWB support.

> what we currently support is the "normal" (I think they name
> it legacy devices) phy type (no UWB, sun phy, whatever) and as Channel
> Assignments says that it does not apply for those PHY's I think it
> there are channel/page combinations which are different according to
> the PHY "type". However we don't support them and I think there might
> be an upcoming type field in wpan_phy which might be set only once at
> registration time.

An idea might be to create a callback that drivers might decide to
implement or not. If they implement it, the core might call it to get
further information about the channels. The core would provide a {page,
channel} couple and retrieve a structure with many information such as
the the frequency, the protocol, eventually the prf, etc.

Thanks,
Miqu=C3=A8l
