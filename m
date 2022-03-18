Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A3C4DD6D8
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 10:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbiCRJKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 05:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiCRJKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 05:10:34 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2246D17ECE0;
        Fri, 18 Mar 2022 02:09:14 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 144D0FF80A;
        Fri, 18 Mar 2022 09:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647594553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xFkxbVKYpg3VDoY3mOHshO8q1PcvjZGqSGaKf2RSoto=;
        b=azVxy6JvwfUCjhDA83/C2uiJffqn/8yF2TcRSdlicdm4B5jL+BcGtLGZfsQslmfDLu8x2r
        uD13rj9lI0gMDhJSsTczqZo6GPbj7X1uUfv2MPF+orHc3QLSRQXsJtc12sDCuSV5Ym59PU
        T27C3qEMkCrqk+2fmre3T0hV30gtNb0F6gjXmxpQk7st9aDj6Og0MIg7XhwCitphq2oTPA
        aTJM0/e48i1lWA9L/zwo98zh2UCfrtFn7QXMpe80r1WM6Jqur82NHcjCUz9Z0e74j198eq
        XsFniYxNVBpPGhzzRHDgfM8Jz/rXedpWcEaipUW2Z9ox1LKPNz9fjKqvqX+Dyw==
Date:   Fri, 18 Mar 2022 10:09:10 +0100
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
Message-ID: <20220318100910.3bc425d7@xps13>
In-Reply-To: <CAB_54W5e2pgHtUXA41gn9B86e8Q-y3pWOty=cCv0FJd2V1b7yA@mail.gmail.com>
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
        <20220128110825.1120678-2-miquel.raynal@bootlin.com>
        <CAB_54W60OiGmjLQ2dAvnraq6fkZ6GGTLMVzjVbVAobcvNsaWtQ@mail.gmail.com>
        <20220131152345.3fefa3aa@xps13>
        <CAB_54W7SZmgU=2_HEm=_agE0RWfsXxEs_4MHmnAPPFb+iVvxsQ@mail.gmail.com>
        <20220201155507.549cd2e3@xps13>
        <CAB_54W5mnovPX0cyq5dwVoQKa6VZx3QPCfVoPAF+LQ5DkdQ3Mw@mail.gmail.com>
        <20220207084918.0c2e6d13@xps13>
        <CAB_54W6RC9dqRzPyN3OYb6pWfst+UixSAKppaCtDaCvzE0_kAQ@mail.gmail.com>
        <20220302142138.4122b3c6@xps13>
        <CAB_54W5e2pgHtUXA41gn9B86e8Q-y3pWOty=cCv0FJd2V1b7yA@mail.gmail.com>
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

alex.aring@gmail.com wrote on Sun, 13 Mar 2022 16:58:01 -0400:

> Hi,
>=20
> On Wed, Mar 2, 2022 at 8:21 AM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> >
> > Hi Alexander,
> >
> > alex.aring@gmail.com wrote on Sun, 20 Feb 2022 18:05:39 -0500:
> > =20
> > > Hi,
> > >
> > > On Mon, Feb 7, 2022 at 2:49 AM Miquel Raynal <miquel.raynal@bootlin.c=
om> wrote: =20
> > > >
> > > > Hi Alexander,
> > > >
> > > > alex.aring@gmail.com wrote on Sun, 6 Feb 2022 16:37:23 -0500:
> > > > =20
> > > > > Hi,
> > > > >
> > > > > On Tue, Feb 1, 2022 at 9:55 AM Miquel Raynal <miquel.raynal@bootl=
in.com> wrote:
> > > > > ... =20
> > > > > >
> > > > > > Given the new information that I am currently processing, I bel=
ieve the
> > > > > > array is not needed anymore, we can live with a minimal number =
of
> > > > > > additional helpers, like the one getting the PRF value for the =
UWB
> > > > > > PHYs. It's the only one I have in mind so far. =20
> > > > >
> > > > > I am not really sure if I understood now. So far those channel/pa=
ge
> > > > > combinations are the same because we have no special "type" value=
 in
> > > > > wpan_phy, =20
> > > >
> > > > Yes, my assumption was more: I know there are only -legacy- phy typ=
es
> > > > supported, we will add another (or improve the current) way of defi=
ning
> > > > channels when we'll need to. Eg when improving UWB support.
> > > > =20
> > > > > what we currently support is the "normal" (I think they name
> > > > > it legacy devices) phy type (no UWB, sun phy, whatever) and as Ch=
annel
> > > > > Assignments says that it does not apply for those PHY's I think it
> > > > > there are channel/page combinations which are different according=
 to
> > > > > the PHY "type". However we don't support them and I think there m=
ight
> > > > > be an upcoming type field in wpan_phy which might be set only onc=
e at
> > > > > registration time. =20
> > > >
> > > > An idea might be to create a callback that drivers might decide to
> > > > implement or not. If they implement it, the core might call it to g=
et
> > > > further information about the channels. The core would provide a {p=
age,
> > > > channel} couple and retrieve a structure with many information such=
 as
> > > > the the frequency, the protocol, eventually the prf, etc.
> > > > =20
> > >
> > > As I said before, for "many information" we should look at how
> > > wireless is using that with regdb and extend it with 802.15.4
> > > channels/etc. The kernel should only deal with an unique
> > > identification of a database key for "regdb" which so far I see is a
> > > combination of phy type, page id and channel id. Then from "somewhere"
> > > also the country code gets involved into that and you get a subset of
> > > what is available. =20
> >
> > Do you want another implementation of regdb that would support the
> > 802.15.4 world only (so far it is highly 802.11 oriented) ? Or is this
> > something that you would like to merge in the existing project?
> > =20
>=20
> I think we should run the strategy like wpan-tools, fork it but leave
> it open that probably they can be merged in future. How about that?
>=20
> I don't like that it is wireless standard specific, it should be
> specific to the standard which defines the regulation... As an
> example, I remember that at86rf212 has some LBT (listen before
> transmit) mode because of some duty cycle regulations in some
> countries. The regdb should not contain if LBT should be used in a
> country for specific sub 1Ghz range, etc. It should contain the duty
> cycle allowance. That's an example of what I mean with "wireless
> standard" and "regulation standard". However the regulation for sub
> 1Ghz is also a little bit crazy so far I see. :)
>=20
> However I really don't know if this is extremely difficult to handle.
> I would say this would be the better approach but if it doesn't work
> do it wireless specific. So it's up to whoever wants to do the work?
>=20
> > Overall it can be useful to define what is allowed in different
> > countries but this will not save us from needing extra information from
> > the devices. Describing the channels and protocols (and PRFs) for an
> > UWB PHY has nothing to do with the regulatory database, it's just
> > listing what is supported by the device. The actual location where it
> > might be useful to have a regdb (but not mandatory at the beginning)
> > would be when changing channels to avoid messing with local
> > regulations, I believe?
> > =20
>=20
> I see, but I am not sure what additional information you need as
> channel, page, phy type?

For a UWB PHY: the preamble code and the PRF, I believe.

> And if you have those values in user space
> you can get other information out of it, or not? Why does the kernel
> need to handle more than necessary? Even there we can use helpers to
> map those combinations to something else. Just avoid that drivers
> declare those information what they already declared and introduce
> helpers to whatever higher level information you want to get out of
> it.

I'll look into it soon.

Thanks,
Miqu=C3=A8l
