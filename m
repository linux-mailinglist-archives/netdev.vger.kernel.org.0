Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC8E2C37C0
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 05:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgKYDoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 22:44:37 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:19394 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbgKYDog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 22:44:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606275875; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=Ge28rP6SbSH4Lai1lEMWW7z009l0Z3qjpj91J969oSI=; b=CYPNvZhKas1kOHxKzF5r/Ji8XkVhedQleC8yqaS8VpHz/pbiguYvD43JBlJgC152a2ERqv6A
 APcLHKGOnQYjR7oQXc7GsWutgcJOCnuC3/CKz4UIJ23AmxrFVaCjrOFozDeRqKdCv2hen23Z
 9vmAJSyU7fhJRGFPFf9xU4u5KNM=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5fbdd31a7ef0a8d843ef8196 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 25 Nov 2020 03:44:26
 GMT
Sender: pillair=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1D932C43462; Wed, 25 Nov 2020 03:44:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from Pillair (unknown [49.205.247.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7B0A2C433ED;
        Wed, 25 Nov 2020 03:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7B0A2C433ED
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
References: <20201112200906.991086-1-kuabhs@chromium.org> <20201112200856.v2.1.Ia526132a366886e3b5cf72433d0d58bb7bb1be0f@changeid> <CAD=FV=XKCLgL6Bt+3KfqKByyP5fpwXOh6TNHXAoXkaQJRzjKjQ@mail.gmail.com> <002401d6c242$d78f2140$86ad63c0$@codeaurora.org> <CAD=FV=UnecON-M9eZVQePuNpdygN_E9OtLN495Xe1GL_PA94DQ@mail.gmail.com>
In-Reply-To: <CAD=FV=UnecON-M9eZVQePuNpdygN_E9OtLN495Xe1GL_PA94DQ@mail.gmail.com>
Subject: RE: [PATCH v2 1/1] ath10k: add option for chip-id based BDF selection
Date:   Wed, 25 Nov 2020 09:14:16 +0530
Message-ID: <002d01d6c2dd$4386d880$ca948980$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKxMSkDsdRsNwK99YDuloz1ISNQFAKbjoqbAYQwjuUA6sHy1gG3Fmuop+1JeFA=
Content-Language: en-us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Doug Anderson <dianders@chromium.org>
> Sent: Tuesday, November 24, 2020 9:56 PM
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
> On Tue, Nov 24, 2020 at 1:19 AM Rakesh Pillai <pillair@codeaurora.org>
> wrote:
> >
> > > -----Original Message-----
> > > From: Doug Anderson <dianders@chromium.org>
> > > Sent: Tuesday, November 24, 2020 6:27 AM
> > > To: Abhishek Kumar <kuabhs@chromium.org>
> > > Cc: Kalle Valo <kvalo@codeaurora.org>; Rakesh Pillai
> > > <pillair@codeaurora.org>; LKML <linux-kernel@vger.kernel.org>; =
ath10k
> > > <ath10k@lists.infradead.org>; Brian Norris =
<briannorris@chromium.org>;
> > > linux-wireless <linux-wireless@vger.kernel.org>; David S. Miller
> > > <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; netdev
> > > <netdev@vger.kernel.org>
> > > Subject: Re: [PATCH v2 1/1] ath10k: add option for chip-id based =
BDF
> > > selection
> > >
> > > Hi,
> > >
> > > On Thu, Nov 12, 2020 at 12:09 PM Abhishek Kumar
> <kuabhs@chromium.org>
> > > wrote:
> > > >
> > > > In some devices difference in chip-id should be enough to pick
> > > > the right BDF. Add another support for chip-id based BDF =
selection.
> > > > With this new option, ath10k supports 2 fallback options.
> > > >
> > > > The board name with chip-id as option looks as follows
> > > > board name 'bus=3Dsnoc,qmi-board-id=3Dff,qmi-chip-id=3D320'
> > > >
> > > > Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-
> QCAHLSWMTPL-1
> > > > Tested-on: QCA6174 HW3.2 WLAN.RM.4.4.1-00157-QCARMSWPZ-1
> > > > Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> > > > ---
> > > >
> > > > (no changes since v1)
> > >
> > > I think you need to work on the method you're using to generate =
your
> > > patches.  There are most definitely changes since v1.  You =
described
> > > them in your cover letter (which you don't really need for a =
singleton
> > > patch) instead of here.
> > >
> > >
> > > > @@ -1438,12 +1439,17 @@ static int
> > > ath10k_core_create_board_name(struct ath10k *ar, char *name,
> > > >         }
> > > >
> > > >         if (ar->id.qmi_ids_valid) {
> > > > -               if (with_variant && ar->id.bdf_ext[0] !=3D '\0')
> > > > +               if (with_additional_params && ar->id.bdf_ext[0] =
!=3D '\0')
> > > >                         scnprintf(name, name_len,
> > > >                                   =
"bus=3D%s,qmi-board-id=3D%x,qmi-chip-id=3D%x%s",
> > > >                                   ath10k_bus_str(ar->hif.bus),
> > > >                                   ar->id.qmi_board_id, =
ar->id.qmi_chip_id,
> > > >                                   variant);
> > > > +               else if (with_additional_params)
> > > > +                       scnprintf(name, name_len,
> > > > +                                 =
"bus=3D%s,qmi-board-id=3D%x,qmi-chip-id=3D%x",
> > > > +                                 ath10k_bus_str(ar->hif.bus),
> > > > +                                 ar->id.qmi_board_id, =
ar->id.qmi_chip_id);
> > >
> > > I believe this is exactly opposite of what Rakesh was requesting.
> > > Specifically, he was trying to eliminate the extra scnprintf() but =
I
> > > think he still agreed that it was a good idea to generate 3 =
different
> > > strings.  I believe the proper diff to apply to v1 is:
> > >
> > > https://crrev.com/c/255643
>=20
> Wow, I seem to have deleted the last digit from my URL.  Should have =
been:
>=20
> https://crrev.com/c/2556437
>=20
> > >
> > > -Doug
> >
> > Hi Abhishek/Doug,
> >
> > I missed on reviewing this change. Also I agree with Doug that this =
is not
> the change I was looking for.
> >
> > The argument "with_variant" can be renamed to "with_extra_params".
> There is no need for any new argument to this function.
> > Case 1: with_extra_params=3D0,  ar->id.bdf_ext[0] =3D 0             =
->   The default
> name will be used (bus=3Dsnoc,qmi_board_id=3D0xab)
> > Case 2: with_extra_params=3D1,  ar->id.bdf_ext[0] =3D 0             =
->
> bus=3Dsnoc,qmi_board_id=3D0xab,qmi_chip_id=3D0xcd
> > Case 3: with_extra_params=3D1,  ar->id.bdf_ext[0] =3D "xyz"      ->
> bus=3Dsnoc,qmi_board_id=3D0xab,qmi_chip_id=3D0xcd,variant=3Dxyz
> >
> > ar->id.bdf_ext[0] depends on the DT entry for variant field.
>=20
> I'm confused about your suggestion.  Maybe you can help clarify.  Are
> you suggesting:
>=20
> a) Only two calls to ath10k_core_create_board_name()
>=20
> I'm pretty sure this will fail in some cases.  Specifically consider
> the case where the device tree has a "variant" defined but the BRD
> file only has one entry for (board-id) and one for (board-id +
> chip-id) but no entry for (board-id + chip-id + variant).  If you are
> only making two calls then I don't think you'll pick the right one.
>=20
> Said another way...
>=20
> If the device tree has a variant:
> 1. We should prefer a BRD entry that has board-id + chip-id + variant
> 2. If #1 isn't there, we should prefer a BRD entry that has board-id + =
chip-id
> 3. If #1 and #2 aren't there we fall back to a BRD entry that has =
board-id.
>=20
> ...without 3 calls to ath10k_core_create_board_name() we can't handle
> all 3 cases.

This can be handled by two calls to ath10k_core_create_board_name
1) ath10k_core_create_board_name(ar, boardname, sizeof(boardname), true) =
  :  As per my suggestions, this can result in two possible board names
    a) If DT have the "variant" node, it outputs the #1 from your =
suggestion  (1. We should prefer a BRD entry that has board-id + chip-id =
+ variant)
    b) If DT does not have the "variant" node, it outputs the #2 from =
your suggestion (2. If #1 isn't there, we should prefer a BRD entry that =
has board-id + chip-id)

2) ath10k_core_create_board_name(ar, boardname, sizeof(boardname), =
false)    :  This is the second call to this function and outputs the #3 =
from your suggestion (3. If #1 and #2 aren't there we fall back to a BRD =
entry that has board-id)


Below is the snippet of code change I am suggesting.=20

 static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
-                                        size_t name_len, bool =
with_variant)
+                                        size_t name_len, bool =
with_extra_params)
 {
        /* strlen(',variant=3D') + strlen(ar->id.bdf_ext) */
        char variant[9 + ATH10K_SMBIOS_BDF_EXT_STR_LENGTH] =3D { 0 };

-       if (with_variant && ar->id.bdf_ext[0] !=3D '\0')
+       if (ar->id.bdf_ext[0] !=3D '\0')
                scnprintf(variant, sizeof(variant), ",variant=3D%s",
                          ar->id.bdf_ext);

@@ -1493,7 +1493,7 @@ static int ath10k_core_create_board_name(struct =
ath10k *ar, char *name,
        }

        if (ar->id.qmi_ids_valid) {
-               if (with_variant && ar->id.bdf_ext[0] !=3D '\0')
+               if (with_extra_params)
                        scnprintf(name, name_len,
                                  =
"bus=3D%s,qmi-board-id=3D%x,qmi-chip-id=3D%x%s",
                                  ath10k_bus_str(ar->hif.bus),


Thanks,
Rakesh Pillai.

>=20
>=20
> b) Three calls to ath10k_core_create_board_name() but the caller
> manually whacks "ar->id.bdf_ext[0]" for one of the calls
>=20
> This doesn't look like it's a clean solution, but maybe I'm missing =
something.
>=20
>=20
> -Doug

