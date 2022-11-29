Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E8063C0B5
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbiK2NNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiK2NMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:12:52 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DEF627C7;
        Tue, 29 Nov 2022 05:11:41 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 957AF24000C;
        Tue, 29 Nov 2022 13:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669727481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lrk1obgdUKvQi0CZTnoZMlhVMRgBpVKOFvv7Qmw9fjY=;
        b=TC/SjJq+PbLbVzoh2CtODMLF6ebVC1ekGk9qpfTQb8B0cf1vkY4OYLLpngY0BitxL+WuUK
        93S+rTdx9Y0uFwqtICZesmR+Cxa9hz1TsGyPyZn00yxQbXXp3pQySCIMXrh5uvprKiMsSl
        unCfzInDw9wJi5n5mxSoVT8l9dfxV1z9PBAWHR7kKVyjUbRRkucg9XvYK6oHfzCo/pD+wG
        Olk7gfPJim8rgkCGwAQQdeYLkWeKDi+PKp+FKg4Aa6Z0rj+Zj2ocXMqeqMER2bu4xtOh7L
        X3RLFxHbCG7dCFBfYg6gMLI8Bgw6CMI5iMzEo2K552yLV/sPu+rjbiWk0DbBLw==
Date:   Tue, 29 Nov 2022 14:11:14 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <aahringo@redhat.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v2 0/2] IEEE 802.15.4 PAN discovery handling
Message-ID: <20221129141114.2b78240b@xps-13>
In-Reply-To: <ff0e20e9-687c-75f7-12ea-c927df39a1db@datenfreihafen.org>
References: <20221118221041.1402445-1-miquel.raynal@bootlin.com>
        <CAK-6q+iLkYuz5csmbLt=tKcfGmdNGP+Sm42+DQRu5180jafEGw@mail.gmail.com>
        <20221129090321.132a4439@xps-13>
        <ff0e20e9-687c-75f7-12ea-c927df39a1db@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Tue, 29 Nov 2022 13:41:32 +0100:

> Hello.
>=20
> On 29.11.22 09:03, Miquel Raynal wrote:
> > Hi Alexander,
> >=20
> > aahringo@redhat.com wrote on Mon, 28 Nov 2022 17:11:38 -0500:
> >  =20
> >> Hi,
> >>
> >> On Fri, Nov 18, 2022 at 5:13 PM Miquel Raynal <miquel.raynal@bootlin.c=
om> wrote: =20
> >>>
> >>> Hello,
> >>>
> >>> Last preparation step before the introduction of the scanning feature
> >>> (really): generic helpers to handle PAN discovery upon beacon
> >>> reception. We need to tell user space about the discoveries.
> >>>
> >>> In all the past, current and future submissions, David and Romuald fr=
om
> >>> Qorvo are credited in various ways (main author, co-author,
> >>> suggested-by) depending of the amount of rework that was involved on
> >>> each patch, reflecting as much as possible the open-source guidelines=
 we
> >>> follow in the kernel. All this effort is made possible thanks to Qorvo
> >>> Inc which is pushing towards a featureful upstream WPAN support. =20
> >>>   >> =20
> >> Acked-by: Alexander Aring <aahringo@redhat.com>
> >>
> >> I am sorry, I saw this series today. Somehow I mess up my mails if we
> >> are still writing something on v1 but v2 is already submitted. I will
> >> try to keep up next time. =20
> >=20
> > Haha I was asking myself wether or not you saw it, no problem :) I did
> > send it after your main review but we continued discussing on v1 (about
> > the preambles) so I did not ping for the time the discussion would
> > settle. =20
>=20
> I was trying to apply these two patches, but the first one does not apply:
>=20
>=20
> Failed to apply patch:
> error: patch failed: include/net/nl802154.h:58
> error: include/net/nl802154.h: patch does not apply
> hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
> Applying: ieee802154: Advertize coordinators discovery
> Patch failed at 0001 ieee802154: Advertize coordinators discovery
>=20
> It seems you need a rebase as there is commit 8254393663f9b8cb8b84cdce1ab=
b118833c22a54 which touches this area of the file and removes a comment and=
 ifdef. Should be fine to go in after the rebase.

Oh crap, this is gonna conflict with a dozen of my patches /o\. Not hard
to solve though. Let me fix this by moving all new commands in this
header above the security commands.

I'll also have to update the wpan tools to use the same commands.

Thanks,
Miqu=C3=A8l
