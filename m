Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549432C2108
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 10:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731124AbgKXJTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 04:19:11 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:57171 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731110AbgKXJTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 04:19:10 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606209549; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=T/nuXdXFujJ/x3ermaFIfdonlDhhCK1yet+N4iW7bWA=; b=uxTj49rvClN7gLd0N9m+z01uDGL39Utj/OltY+j6g4b0SxO+8HYpX4rQ5CnQqA4pZDajhlkN
 +bbw5WUDzJqij48gOK0o/aZUJYm818a+1g0I5pS9LeVVkYsdLmdY90VW5n/VZM5emk3vyu+T
 YytP5T0Nuw6QjtrmJv6wmpNC0QY=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fbcd005ba50d14f88a5e938 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 24 Nov 2020 09:19:01
 GMT
Sender: pillair=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EA8F4C43464; Tue, 24 Nov 2020 09:19:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from Pillair (unknown [49.205.247.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4943AC433ED;
        Tue, 24 Nov 2020 09:18:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4943AC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'Doug Anderson'" <dianders@chromium.org>,
        "'Abhishek Kumar'" <kuabhs@chromium.org>
Cc:     "'Kalle Valo'" <kvalo@codeaurora.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'ath10k'" <ath10k@lists.infradead.org>,
        "'Brian Norris'" <briannorris@chromium.org>,
        "'linux-wireless'" <linux-wireless@vger.kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'netdev'" <netdev@vger.kernel.org>
References: <20201112200906.991086-1-kuabhs@chromium.org> <20201112200856.v2.1.Ia526132a366886e3b5cf72433d0d58bb7bb1be0f@changeid> <CAD=FV=XKCLgL6Bt+3KfqKByyP5fpwXOh6TNHXAoXkaQJRzjKjQ@mail.gmail.com>
In-Reply-To: <CAD=FV=XKCLgL6Bt+3KfqKByyP5fpwXOh6TNHXAoXkaQJRzjKjQ@mail.gmail.com>
Subject: RE: [PATCH v2 1/1] ath10k: add option for chip-id based BDF selection
Date:   Tue, 24 Nov 2020 14:48:52 +0530
Message-ID: <002401d6c242$d78f2140$86ad63c0$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKxMSkDsdRsNwK99YDuloz1ISNQFAKbjoqbAYQwjuWoASIGoA==
Content-Language: en-us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Doug Anderson <dianders@chromium.org>
> Sent: Tuesday, November 24, 2020 6:27 AM
> To: Abhishek Kumar <kuabhs@chromium.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>; Rakesh Pillai
> <pillair@codeaurora.org>; LKML <linux-kernel@vger.kernel.org>; ath10k
> <ath10k@lists.infradead.org>; Brian Norris <briannorris@chromium.org>;
> linux-wireless <linux-wireless@vger.kernel.org>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; netdev
> <netdev@vger.kernel.org>
> Subject: Re: [PATCH v2 1/1] ath10k: add option for chip-id based BDF
> selection
>=20
> Hi,
>=20
> On Thu, Nov 12, 2020 at 12:09 PM Abhishek Kumar <kuabhs@chromium.org>
> wrote:
> >
> > In some devices difference in chip-id should be enough to pick
> > the right BDF. Add another support for chip-id based BDF selection.
> > With this new option, ath10k supports 2 fallback options.
> >
> > The board name with chip-id as option looks as follows
> > board name 'bus=3Dsnoc,qmi-board-id=3Dff,qmi-chip-id=3D320'
> >
> > Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
> > Tested-on: QCA6174 HW3.2 WLAN.RM.4.4.1-00157-QCARMSWPZ-1
> > Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> > ---
> >
> > (no changes since v1)
>=20
> I think you need to work on the method you're using to generate your
> patches.  There are most definitely changes since v1.  You described
> them in your cover letter (which you don't really need for a singleton
> patch) instead of here.
>=20
>=20
> > @@ -1438,12 +1439,17 @@ static int
> ath10k_core_create_board_name(struct ath10k *ar, char *name,
> >         }
> >
> >         if (ar->id.qmi_ids_valid) {
> > -               if (with_variant && ar->id.bdf_ext[0] !=3D '\0')
> > +               if (with_additional_params && ar->id.bdf_ext[0] !=3D =
'\0')
> >                         scnprintf(name, name_len,
> >                                   =
"bus=3D%s,qmi-board-id=3D%x,qmi-chip-id=3D%x%s",
> >                                   ath10k_bus_str(ar->hif.bus),
> >                                   ar->id.qmi_board_id, =
ar->id.qmi_chip_id,
> >                                   variant);
> > +               else if (with_additional_params)
> > +                       scnprintf(name, name_len,
> > +                                 =
"bus=3D%s,qmi-board-id=3D%x,qmi-chip-id=3D%x",
> > +                                 ath10k_bus_str(ar->hif.bus),
> > +                                 ar->id.qmi_board_id, =
ar->id.qmi_chip_id);
>=20
> I believe this is exactly opposite of what Rakesh was requesting.
> Specifically, he was trying to eliminate the extra scnprintf() but I
> think he still agreed that it was a good idea to generate 3 different
> strings.  I believe the proper diff to apply to v1 is:
>=20
> https://crrev.com/c/255643
>=20
> -Doug

Hi Abhishek/Doug,

I missed on reviewing this change. Also I agree with Doug that this is =
not the change I was looking for.

The argument "with_variant" can be renamed to "with_extra_params". There =
is no need for any new argument to this function.
Case 1: with_extra_params=3D0,  ar->id.bdf_ext[0] =3D 0             ->   =
The default name will be used (bus=3Dsnoc,qmi_board_id=3D0xab)
Case 2: with_extra_params=3D1,  ar->id.bdf_ext[0] =3D 0             ->   =
bus=3Dsnoc,qmi_board_id=3D0xab,qmi_chip_id=3D0xcd
Case 3: with_extra_params=3D1,  ar->id.bdf_ext[0] =3D "xyz"      ->   =
bus=3Dsnoc,qmi_board_id=3D0xab,qmi_chip_id=3D0xcd,variant=3Dxyz

ar->id.bdf_ext[0] depends on the DT entry for variant field.

Thanks,
Rakesh Pillai.

