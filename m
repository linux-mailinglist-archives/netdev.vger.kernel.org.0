Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA2E65FF77
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 12:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjAFLWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 06:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjAFLWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 06:22:45 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5605C687B0;
        Fri,  6 Jan 2023 03:22:39 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 998ED100007;
        Fri,  6 Jan 2023 11:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1673004158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lXXcHa5QQ0OkAj5BWIO1IIrCAfdI/cPtYcG5E5fqmtw=;
        b=AIq6U+STykCN/KNp4KhC2Hw1jjjCRfQE8FdWIG5Z7ohjMbtpozNXNnVsqlGh9gRFBX6441
        qnj0b4DYyCihPzyNINSfH6wEbEtes+dI/CFOcNWA0rM1ConHAC4wFGvLp76a+RJ3Qn0hd5
        BK3FtIgdsphcCQQmzyxtF1vJXVTapc2EjuSWZHSHbo1+NZ7K2o/DUlvviOpeuyj5pXbLXk
        cAkNTBmPMXLWlgTIfSNXmB/MVOqiROGvz3ZrsLjop3q86s6CLACDEegNNkLBvjRQCmfvoH
        koIkN9LFPrG4w/rBAv2H8wuLHmLDN0+poTnEGHyMsZTRLXWeKHG0AiiT8zwDJw==
Date:   Fri, 6 Jan 2023 12:22:33 +0100
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
Subject: Re: [PATCH wpan-next v3 0/6] IEEE 802.15.4 passive scan support
Message-ID: <20230106122233.78aa82e2@xps-13>
In-Reply-To: <ec93100f-8c55-2f54-d3d5-63f31c2602f4@datenfreihafen.org>
References: <20230103165644.432209-1-miquel.raynal@bootlin.com>
        <9828444e-d047-40ac-6550-0bde4a9b5230@datenfreihafen.org>
        <20230104132037.0c49a4ed@xps-13>
        <ec93100f-8c55-2f54-d3d5-63f31c2602f4@datenfreihafen.org>
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

stefan@datenfreihafen.org wrote on Wed, 4 Jan 2023 13:28:44 +0100:

> Hello Miquel.
>=20
> On 04.01.23 13:20, Miquel Raynal wrote:
> > Hi Stefan,
> >=20
> > stefan@datenfreihafen.org wrote on Tue, 3 Jan 2023 20:43:02 +0100:
> >  =20
> >> Hello Miquel.
> >>
> >> On 03.01.23 17:56, Miquel Raynal wrote: =20
> >>> Hello,
> >>>
> >>> We now have the infrastructure to report beacons/PANs, we also have t=
he
> >>> capability to transmit MLME commands synchronously. It is time to use
> >>> these to implement a proper scan implementation.
> >>>
> >>> There are a few side-changes which are necessary for the soft MAC scan
> >>> implementation to compile/work, but nothing big. The two main changes
> >>> are:
> >>> * The introduction of a user API for managing scans.
> >>> * The soft MAC implementation of a scan.
> >>>
> >>> In all the past, current and future submissions, David and Romuald fr=
om
> >>> Qorvo are credited in various ways (main author, co-author,
> >>> suggested-by) depending of the amount of rework that was involved on
> >>> each patch, reflecting as much as possible the open-source guidelines=
 we
> >>> follow in the kernel. All this effort is made possible thanks to Qorvo
> >>> Inc which is pushing towards a featureful upstream WPAN support.
> >>>
> >>> Example of output:
> >>>
> >>> 	# iwpan monitor
> >>> 	coord1 (phy #1): scan started
> >>> 	coord1 (phy #1): beacon received: PAN 0xabcd, addr 0xb2bcc36ac5570abe
> >>> 	coord1 (phy #1): scan finished
> >>> 	coord1 (phy #1): scan started
> >>> 	coord1 (phy #1): scan aborted =20
> >>
> >> These patches have been applied to the wpan-next tree and will be
> >> part of the next pull request to net-next. Thanks!
> >>
> >> Before I would add them to a pull request to net-next I would like to =
have an updated patchset for iwpan to reflect these scan changes. We would =
need something to verify the kernel changes and try to coordinate a new iwp=
an release with this functionality with the major kernel release bringing t=
he feature. =20
> >=20
> > So far I did not made a single change for the scan, but a common
> > changeset for scan+beaconing (which I am about to send), should I split
> > it or should we assume we could introduce scanning and beaconing in the
> > same kernel release? =20
>=20
>  From my side I do not mind to introduce scanning and beaconing in the sa=
me release. I just want to make you aware that scanning would slip if beaco=
ning slips and we have no support in iwpan to test and release together.
>=20
> If you have the beaconing patchset ready, let's start with it and if it t=
urns out it will not be ready for the next release (let's hope it will) you=
 can think again if you want to have the scan part split of to release that=
 earlier.

It was easier to split than I thought, so I've sent the userspace
changes a minute ago:
https://lore.kernel.org/linux-wpan/20230106111831.692202-1-miquel.raynal@bo=
otlin.com/T/#t

Thanks,
Miqu=C3=A8l
