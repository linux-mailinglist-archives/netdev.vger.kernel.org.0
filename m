Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFAD63C31F
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbiK2OtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiK2Osp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:48:45 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D030528A1;
        Tue, 29 Nov 2022 06:47:52 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E498920018;
        Tue, 29 Nov 2022 14:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669733271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dulSq1c/DoxOUidatg7Spr6v5kpSMwlX990B05mDQag=;
        b=fI7yGwAhwYpAeKd12R0FCmhDiNNVqns0yNmovQd2ZidHFGQqkcId41MmxNFkDTGeeA6u/O
        atHSgNesb+VkI6l4/FVL6SwC5+2VEmN0wIlQMNcqeQoP6JKxeGM+c09w+ePDtWylCX3Set
        Ulv1+UMTfAQNVrzbxVRLAuxk71rOD7csMOEzjV4H7pEUhFxAKCrvzjYt7wcvQOFtKlD4YE
        CX9j8wbqUcAWIgL/FcwMRXZyLwJu0elevOIe368WymVud7SKSEdzGOMzFKV7XUs9P4v17/
        WvGgzsJ/lzU3ut6vyxnLcJg+b+kODlGBYRLzcOMmCmB/j9WpZf8rGQPr3un2fQ==
Date:   Tue, 29 Nov 2022 15:47:47 +0100
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
Subject: Re: [PATCH wpan-next v3 0/2] IEEE 802.15.4 PAN discovery handling
Message-ID: <20221129154747.572d4da7@xps-13>
In-Reply-To: <04f7bc30-618d-db22-4b8f-8753f60d26b9@datenfreihafen.org>
References: <20221129135535.532513-1-miquel.raynal@bootlin.com>
        <04f7bc30-618d-db22-4b8f-8753f60d26b9@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Tue, 29 Nov 2022 15:39:13 +0100:

> Hello.
>=20
> On 29.11.22 14:55, Miquel Raynal wrote:
> > Hello,
> >  =20
> >>>> Just a resent of the v2, rebased <<< =20
> >=20
> > Last preparation step before the introduction of the scanning feature
> > (really): generic helpers to handle PAN discovery upon beacon
> > reception. We need to tell user space about the discoveries.
> >=20
> > In all the past, current and future submissions, David and Romuald from
> > Qorvo are credited in various ways (main author, co-author,
> > suggested-by) depending of the amount of rework that was involved on
> > each patch, reflecting as much as possible the open-source guidelines we
> > follow in the kernel. All this effort is made possible thanks to Qorvo
> > Inc which is pushing towards a featureful upstream WPAN support.
> >=20
> > Cheers,
> > Miqu=C3=A8l
> >=20
> > Changes in v3:
> > * Rebased on wpan-next/master.
> >=20
> > Changes in v2:
> > * Dropped all the logic around the knowledge of PANs: we forward all
> >    beacons received to userspace and let the user decide whether or not
> >    the coordinator is new or not.
> > * Changed the coordinator descriptor address member to a proper
> >    structure (not a pointer).
> >=20
> > David Girault (1):
> >    mac802154: Trace the registration of new PANs
> >=20
> > Miquel Raynal (1):
> >    ieee802154: Advertize coordinators discovery
> >=20
> >   include/net/cfg802154.h   |  18 +++++++
> >   include/net/nl802154.h    |  43 ++++++++++++++++
> >   net/ieee802154/nl802154.c | 103 ++++++++++++++++++++++++++++++++++++++
> >   net/ieee802154/nl802154.h |   2 +
> >   net/mac802154/trace.h     |  25 +++++++++
> >   5 files changed, 191 insertions(+)
> >  =20
>=20
> These patches have been applied to the wpan-next tree and will be
> part of the next pull request to net-next. Thanks!

Perfect, thanks for your responsiveness!

Next series with proper passive scan support is coming.

Thanks,
Miqu=C3=A8l
