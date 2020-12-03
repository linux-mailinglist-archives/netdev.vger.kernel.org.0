Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F862CD4B8
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 12:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbgLCLj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 06:39:56 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:56838 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgLCLjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 06:39:55 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2020 06:39:54 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606995569; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=3lEeiYfIabUWjKykhFZltcpohpjJIHJVg3falMmo2a8=; b=OEJIL4FvGrSxEK28xpFSbijIqCvJPuuOZgZXCzgXDU0fR4pKqjvGN7fIS9+smKOCQ1z1feK9
 0vBlMCFOLw8ZJqvifNe4iYl869vi0QOo+3WZCEabqxALjFVFzTxXBDrjGR6jqeqlnEbVCzH2
 lkyiaBXXQCsPqTauzSfAQc1INFk=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5fc8ccf789b9bc6268d3bc16 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Dec 2020 11:33:11
 GMT
Sender: pillair=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4727AC43462; Thu,  3 Dec 2020 11:33:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from Pillair (unknown [49.205.247.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 88C49C433ED;
        Thu,  3 Dec 2020 11:33:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 88C49C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'Doug Anderson'" <dianders@chromium.org>
Cc:     "'Abhishek Kumar'" <kuabhs@chromium.org>,
        "'Kalle Valo'" <kvalo@codeaurora.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'ath10k'" <ath10k@lists.infradead.org>,
        "'Brian Norris'" <briannorris@chromium.org>,
        "'linux-wireless'" <linux-wireless@vger.kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'netdev'" <netdev@vger.kernel.org>
References: <20201112200906.991086-1-kuabhs@chromium.org> <20201112200856.v2.1.Ia526132a366886e3b5cf72433d0d58bb7bb1be0f@changeid> <CAD=FV=XKCLgL6Bt+3KfqKByyP5fpwXOh6TNHXAoXkaQJRzjKjQ@mail.gmail.com> <002401d6c242$d78f2140$86ad63c0$@codeaurora.org> <CAD=FV=UnecON-M9eZVQePuNpdygN_E9OtLN495Xe1GL_PA94DQ@mail.gmail.com> <002d01d6c2dd$4386d880$ca948980$@codeaurora.org> <CAD=FV=WQPMnor3oTefDHd6JP6UmpyBo7UsOJ1Sg4Ly1otxr6hw@mail.gmail.com>
In-Reply-To: <CAD=FV=WQPMnor3oTefDHd6JP6UmpyBo7UsOJ1Sg4Ly1otxr6hw@mail.gmail.com>
Subject: RE: [PATCH v2 1/1] ath10k: add option for chip-id based BDF selection
Date:   Thu, 3 Dec 2020 17:03:02 +0530
Message-ID: <004301d6c968$12ef1b10$38cd5130$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKxMSkDsdRsNwK99YDuloz1ISNQFAKbjoqbAYQwjuUA6sHy1gG3FmuoAayVhWkBiF+H7qfguODA
Content-Language: en-us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Doug Anderson <dianders@chromium.org>
> Sent: Tuesday, December 1, 2020 12:49 AM
> To: Rakesh Pillai <pillair@codeaurora.org>
> Cc: Abhishek Kumar <kuabhs@chromium.org>; Kalle Valo
> <kvalo@codeaurora.org>; LKML <linux-kernel@vger.kernel.org>; ath10k
> <ath10k@lists.infradead.org>; Brian Norris <briannorris@chromium.org>;
> linux-wireless <linux-wireless@vger.kernel.org>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; netdev
> <netdev@vger.kernel.org>
> Subject: Re: [PATCH v2 1/1] ath10k: add option for chip-id based BDF
> selection
>=20
> Hi,
>=20
> On Tue, Nov 24, 2020 at 7:44 PM Rakesh Pillai <pillair@codeaurora.org>
> wrote:
> >
> > > > I missed on reviewing this change. Also I agree with Doug that =
this is not
> > > the change I was looking for.
> > > >
> > > > The argument "with_variant" can be renamed to =
"with_extra_params".
> > > There is no need for any new argument to this function.
> > > > Case 1: with_extra_params=3D0,  ar->id.bdf_ext[0] =3D 0          =
   ->   The
> default
> > > name will be used (bus=3Dsnoc,qmi_board_id=3D0xab)
> > > > Case 2: with_extra_params=3D1,  ar->id.bdf_ext[0] =3D 0          =
   ->
> > > bus=3Dsnoc,qmi_board_id=3D0xab,qmi_chip_id=3D0xcd
> > > > Case 3: with_extra_params=3D1,  ar->id.bdf_ext[0] =3D "xyz"      =
->
> > > bus=3Dsnoc,qmi_board_id=3D0xab,qmi_chip_id=3D0xcd,variant=3Dxyz
> > > >
> > > > ar->id.bdf_ext[0] depends on the DT entry for variant field.
> > >
> > > I'm confused about your suggestion.  Maybe you can help clarify.  =
Are
> > > you suggesting:
> > >
> > > a) Only two calls to ath10k_core_create_board_name()
> > >
> > > I'm pretty sure this will fail in some cases.  Specifically =
consider
> > > the case where the device tree has a "variant" defined but the BRD
> > > file only has one entry for (board-id) and one for (board-id +
> > > chip-id) but no entry for (board-id + chip-id + variant).  If you =
are
> > > only making two calls then I don't think you'll pick the right =
one.
> > >
> > > Said another way...
> > >
> > > If the device tree has a variant:
> > > 1. We should prefer a BRD entry that has board-id + chip-id + =
variant
> > > 2. If #1 isn't there, we should prefer a BRD entry that has =
board-id + chip-
> id
> > > 3. If #1 and #2 aren't there we fall back to a BRD entry that has =
board-id.
> > >
> > > ...without 3 calls to ath10k_core_create_board_name() we can't =
handle
> > > all 3 cases.
> >
> > This can be handled by two calls to ath10k_core_create_board_name
> > 1) ath10k_core_create_board_name(ar, boardname, sizeof(boardname),
> true)   :  As per my suggestions, this can result in two possible =
board names
> >     a) If DT have the "variant" node, it outputs the #1 from your =
suggestion
> (1. We should prefer a BRD entry that has board-id + chip-id + =
variant)
> >     b) If DT does not have the "variant" node, it outputs the #2 =
from your
> suggestion (2. If #1 isn't there, we should prefer a BRD entry that =
has board-
> id + chip-id)
> >
> > 2) ath10k_core_create_board_name(ar, boardname, sizeof(boardname),
> false)    :  This is the second call to this function and outputs the =
#3 from your
> suggestion (3. If #1 and #2 aren't there we fall back to a BRD entry =
that has
> board-id)
>=20
> What I'm trying to say is this.  Imagine that:
>=20
> a) the device tree has the "variant" property.
>=20
> b) the BRD file has two entries, one for "board-id" (1) and one for
> "board-id + chip-id" (2).  It doesn't have one for "board-id + chip-id
> + variant" (3).
>=20
> With your suggestion we'll see the "variant" property in the device
> tree.  That means we'll search for (1) and (3).  (3) isn't there, so
> we'll pick (1).  ...but we really should have picked (2), right?


Do we expect board-2.bin to not be populated with the bdf with variant =
field (if its necessary ?)
Seems fine for me, if we have 2 fallback names if that is needed.

>=20
> -Doug

