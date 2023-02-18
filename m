Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7975B69BBB8
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 21:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBRUEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 15:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBRUEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 15:04:21 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEDF113F4;
        Sat, 18 Feb 2023 12:04:18 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 45BD420005;
        Sat, 18 Feb 2023 20:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676750657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=plP0tpWTJH/Wfg8C+H/DoEs/cz1/fGiZjKZWbK9uw5A=;
        b=Uc71l1jQIy8m821HsxffpLgKswvnSb5BHtJGOuMjT/Z3k7+hqx6Z8UKRVmmd3B3lNLz+OD
        EIHy1IKZeJ/kqqNKi/rdCRLXIbPy0jCUC/iL07eid7ZzVzkE/vff29nmdSzivQjxinIJ03
        PudYvV5T97tTch8gdm5LiLss3YMNTQSbZI46n2kQwXB+NCpbY5P7K+oRZpaSUIuLCM7kTW
        hEqrRiwG5FuzDZlNWy79LeWMYJRq+OwBBgDUJSIQRlumsxom4mxh3pCLx66Rir/UgEGb/v
        xFmV3c6j6Gw+6Wq67kmrpjxewgFPsTsYoux2uBdrzdv+MrjaWqJC4Syz29dZaA==
Date:   Sat, 18 Feb 2023 21:04:12 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
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
Subject: Re: [PATCH wpan v2 0/6] ieee802154: Scan/Beacon fixes
Message-ID: <20230218210412.2feb5af2@xps-13>
In-Reply-To: <736c9250-ecfc-f9ce-7367-bd79e930f5c3@datenfreihafen.org>
References: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
        <20230217101058.0bb5df34@xps-13>
        <736c9250-ecfc-f9ce-7367-bd79e930f5c3@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Sat, 18 Feb 2023 18:20:22 +0100:

> Hello Miquel.
>=20
> On 17.02.23 10:10, Miquel Raynal wrote:
> > Hello Jakub, Stefan, Alexander,
> >=20
> > miquel.raynal@bootlin.com wrote on Tue, 14 Feb 2023 14:50:29 +0100:
> >  =20
> >> Hello,
> >>
> >> Following Jakub's review on Stefan's MR, a number of changes were
> >> requested for him in order to pull the patches in net. In the mean tim=
e,
> >> a couple of discussions happened with Alexander (return codes for
> >> monitor scans and transmit helper used for beacons).
> >>
> >> Hopefully this series addresses everything. =20
> >=20
> > I know it's only been 3 working days since I sent this series but as we
> > are approaching the closing of net-next and Stefan's MR was paused
> > until these fixes arrived, I wanted to check whether these changes
> > might be satisfying enough, in particular Jakub, if you found the
> > answers you asked for.
> >=20
> > I mainly want to avoid the "Stefan waits for Alexander who waits for
> > Jakub who waits for Stefan" dependency chain :) =20
>=20
> I just reviewed and tested them and have no problem to take them in. For =
patches 1 and 2 I would prefer an ack from Jakub to make sure we covered al=
l of this review feedback before. Let's hope we can get these on Monday or =
Tuesday. Once we have them in I will re-spin a new pull request for all the=
 changes.

Thanks a lot!

Miqu=C3=A8l
