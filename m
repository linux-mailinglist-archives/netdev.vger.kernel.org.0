Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904E34CA5D4
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 14:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242130AbiCBNW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 08:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbiCBNW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 08:22:29 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485C5C4284;
        Wed,  2 Mar 2022 05:21:45 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EBF78100009;
        Wed,  2 Mar 2022 13:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1646227301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oaiAmjifFbysmnT95EdQ6xObkGDbByhDPc/XB6m+M00=;
        b=XdeepkFdo37U01dZst2L+IG2IxvHr00zKsQtvaqnEKTcPlVIOwy8M5ObP9KOGC/Cflg+OG
        kY2M8yi+dtNyldafSdGNqzj3CJ+smx0hiZnxX6pHYVmit7yEIdFOCPaep5uYgwLydTja9v
        WT2Mc85GXlTtojqr3Bq09U67KCkfFaAIeEAWCohYJXNnJ0G0Hyj8OLIRVHcOykS0cSH28F
        1La/1HdDi93lEmcD/SqbtqEqe6pJNBmFZ4Zp3yHI7pPpPANIGffvpXW145JLszQRHw/wAO
        djeQ+BJ055kwer/3WMJk+7TAmxDDKx26FREkJnC+7Zek4pt+7zDW4m+HnMRHRw==
Date:   Wed, 2 Mar 2022 14:21:38 +0100
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
Message-ID: <20220302142138.4122b3c6@xps13>
In-Reply-To: <CAB_54W6RC9dqRzPyN3OYb6pWfst+UixSAKppaCtDaCvzE0_kAQ@mail.gmail.com>
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
        <20220128110825.1120678-2-miquel.raynal@bootlin.com>
        <CAB_54W60OiGmjLQ2dAvnraq6fkZ6GGTLMVzjVbVAobcvNsaWtQ@mail.gmail.com>
        <20220131152345.3fefa3aa@xps13>
        <CAB_54W7SZmgU=2_HEm=_agE0RWfsXxEs_4MHmnAPPFb+iVvxsQ@mail.gmail.com>
        <20220201155507.549cd2e3@xps13>
        <CAB_54W5mnovPX0cyq5dwVoQKa6VZx3QPCfVoPAF+LQ5DkdQ3Mw@mail.gmail.com>
        <20220207084918.0c2e6d13@xps13>
        <CAB_54W6RC9dqRzPyN3OYb6pWfst+UixSAKppaCtDaCvzE0_kAQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Sun, 20 Feb 2022 18:05:39 -0500:

> Hi,
>=20
> On Mon, Feb 7, 2022 at 2:49 AM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Sun, 6 Feb 2022 16:37:23 -0500:
> > =20
> > > Hi,
> > >
> > > On Tue, Feb 1, 2022 at 9:55 AM Miquel Raynal <miquel.raynal@bootlin.c=
om> wrote:
> > > ... =20
> > > >
> > > > Given the new information that I am currently processing, I believe=
 the
> > > > array is not needed anymore, we can live with a minimal number of
> > > > additional helpers, like the one getting the PRF value for the UWB
> > > > PHYs. It's the only one I have in mind so far. =20
> > >
> > > I am not really sure if I understood now. So far those channel/page
> > > combinations are the same because we have no special "type" value in
> > > wpan_phy, =20
> >
> > Yes, my assumption was more: I know there are only -legacy- phy types
> > supported, we will add another (or improve the current) way of defining
> > channels when we'll need to. Eg when improving UWB support.
> > =20
> > > what we currently support is the "normal" (I think they name
> > > it legacy devices) phy type (no UWB, sun phy, whatever) and as Channel
> > > Assignments says that it does not apply for those PHY's I think it
> > > there are channel/page combinations which are different according to
> > > the PHY "type". However we don't support them and I think there might
> > > be an upcoming type field in wpan_phy which might be set only once at
> > > registration time. =20
> >
> > An idea might be to create a callback that drivers might decide to
> > implement or not. If they implement it, the core might call it to get
> > further information about the channels. The core would provide a {page,
> > channel} couple and retrieve a structure with many information such as
> > the the frequency, the protocol, eventually the prf, etc.
> > =20
>=20
> As I said before, for "many information" we should look at how
> wireless is using that with regdb and extend it with 802.15.4
> channels/etc. The kernel should only deal with an unique
> identification of a database key for "regdb" which so far I see is a
> combination of phy type, page id and channel id. Then from "somewhere"
> also the country code gets involved into that and you get a subset of
> what is available.

Do you want another implementation of regdb that would support the
802.15.4 world only (so far it is highly 802.11 oriented) ? Or is this
something that you would like to merge in the existing project?

Overall it can be useful to define what is allowed in different
countries but this will not save us from needing extra information from
the devices. Describing the channels and protocols (and PRFs) for an
UWB PHY has nothing to do with the regulatory database, it's just
listing what is supported by the device. The actual location where it
might be useful to have a regdb (but not mandatory at the beginning)
would be when changing channels to avoid messing with local
regulations, I believe?

Thanks,
Miqu=C3=A8l
