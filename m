Return-Path: <netdev+bounces-11046-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 156CC7314B2
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:58:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3C6128171B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C401063C1;
	Thu, 15 Jun 2023 09:58:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B527217F1
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:58:18 +0000 (UTC)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4ED1FDB;
	Thu, 15 Jun 2023 02:58:16 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1b517ee9157so3081945ad.3;
        Thu, 15 Jun 2023 02:58:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686823096; x=1689415096;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=//1nqNY65Oj9cRjVXCMigOTuSDy4ibT25fqZRbusfJc=;
        b=BB5q9MdtwCRUT5T5+PwwjLSZyYzDVGEcwpff1E8awnC+Pxsns1rYMtfX+PlNisHMCX
         R9GBjz1QH44waIdZGLmXKS47V7hAWZGo8bTONG0Nqee/rx0AJWMJnbGTHCLaARi56bvu
         z0hvNAlbQpQXLL8Zk7zBgYpKoqPZvKU88ykn6354azGQgQF/NXIc+QldR/5C96hlc/Bb
         KfARq03siodybJMJQ5AFIBojEzOd8at/V7QySKQB6hSUdbFJp3CjHV7uWQYmQHalfGGO
         opAWPGMeEeelPFF1SEfGvo233d+lj8AnH5RvXtrBWKnPsZCRW1D398zBPzaO1V77I45f
         68Yg==
X-Gm-Message-State: AC+VfDwVzH/7Wyg/9O0LoN8NuuADI+cMcUcP5kY927ejQskGboXEY/Lb
	MKJC2bnBWKWVHZBRiuZNSvquPLdUCfpnI8CbpHo=
X-Google-Smtp-Source: ACHHUZ7W9cAAI27g+9TLkuwB+IooIIWUEnWJOIa17tJaPX+uJTmj10PyWRum4nzlnV8maFyi7HhLNYe3CjfjzuDGYPc=
X-Received: by 2002:a17:90a:2b49:b0:253:971b:dd1e with SMTP id
 y9-20020a17090a2b4900b00253971bdd1emr3486539pjc.0.1686823095856; Thu, 15 Jun
 2023 02:58:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <PAVPR10MB7209CEA1F5AD12B2E5C8ED86B15AA@PAVPR10MB7209.EURPRD10.PROD.OUTLOOK.COM>
 <ZIrC6DpjjtmpIsI9@corigine.com>
In-Reply-To: <ZIrC6DpjjtmpIsI9@corigine.com>
From: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date: Thu, 15 Jun 2023 18:58:04 +0900
Message-ID: <CAMZ6RqKzkEL+zfNyqn_f46K_h3_cX-BwGQJb8X5hH-vms0P=cw@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] can: length: fix bitstuffing count
To: Simon Horman <simon.horman@corigine.com>, 
	HMS Incident Management <incidentmanagement@hms.se>
Cc: "mkl@pengutronix.de" <mkl@pengutronix.de>, 
	"linux-can@vger.kernel.org" <linux-can@vger.kernel.org>, 
	"Thomas.Kopp@microchip.com" <Thomas.Kopp@microchip.com>, 
	"socketcan@hartkopp.net" <socketcan@hartkopp.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"marex@denx.de" <marex@denx.de>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu. 15 Jun. 2023 at 17:03, Simon Horman <simon.horman@corigine.com> wrote:
> On Wed, Jun 14, 2023 at 08:40:42PM +0000, HMS Incident Management wrote:
> > [You don't often get email from incidentmanagement@hms.se. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> >
> > **We apologize for the delay in delivering this email, which was caused by a mail incident that occurred over the weekend on June 10th. This email was originally sent from vincent.mailhol@gmail.com on 06/11/2023 02:58:08
> >
> > The Stuff Bit Count is always coded on 4 bits [1]. Update the Stuff
> > Bit Count size accordingly.
> >
> > In addition, the CRC fields of CAN FD Frames contain stuff bits at
> > fixed positions called fixed stuff bits [2]. The CRC field starts with
> > a fixed stuff bit and then has another fixed stuff bit after each
> > fourth bit [2], which allows us to derive this formula:
> >
> >   FSB count = 1 + round_down(len(CRC field)/4)
> >
> > The length of the CRC field is [1]:
> >
> >   len(CRC field) = len(Stuff Bit Count) + len(CRC)
> >                  = 4 + len(CRC)
> >
> > with len(CRC) either 17 or 21 bits depending of the payload length.
> >
> > In conclusion, for CRC17:
> >
> >   FSB count = 1 + round_down((4 + 17)/4)
> >             = 6
> >
> > and for CRC 21:
> >
> >   FSB count = 1 + round_down((4 + 21)/4)
> >             = 7
> >
> > Add a Fixed Stuff bits (FSB) field with above values and update
> > CANFD_FRAME_OVERHEAD_SFF and CANFD_FRAME_OVERHEAD_EFF accordingly.
> >
> > [1] ISO 11898-1:2015 section 10.4.2.6 "CRC field":
> >
> >   The CRC field shall contain the CRC sequence followed by a recessive
> >   CRC delimiter. For FD Frames, the CRC field shall also contain the
> >   stuff count.
> >
> >   Stuff count
> >
> >   If FD Frames, the stuff count shall be at the beginning of the CRC
> >   field. It shall consist of the stuff bit count modulo 8 in a 3-bit
> >   gray code followed by a parity bit [...]
> >
> > [2] ISO 11898-1:2015 paragraph 10.5 "Frame coding":
> >
> >   In the CRC field of FD Frames, the stuff bits shall be inserted at
> >   fixed positions; they are called fixed stuff bits. There shall be a
> >   fixed stuff bit before the first bit of the stuff count, even if the
> >   last bits of the preceding field are a sequence of five consecutive
> >   bits of identical value, there shall be only the fixed stuff bit,
> >   there shall not be two consecutive stuff bits. A further fixed stuff
> >   bit shall be inserted after each fourth bit of the CRC field [...]
> >
> > Fixes: 85d99c3e2a13 ("can: length: can_skb_get_frame_len(): introduce function to get data length of frame in data link layer")
> > Suggested-by: Thomas Kopp
> > Signed-off-by: Vincent Mailhol
> > Reviewed-by: Thomas Kopp
>
> Hi,
>
> Some feedback from my side, in the hope that it is useful.
>
> I guess this patch-set has had a bit of a journey, email-wise.
> Unfortunately on it's trip the email addresses for the tags above got lost,
> which by itself leads me to think it should be resent.

I can see Thomas's email in the To: field.

> Also, I think it would be best if the From address of the email
> was from a human, who features in the Signed-off-by tags of the patches.
> But perhaps this is also an artifact of the journey.

Yes, the original message had a correct From: tag. As far as I can
see, only that From: tag was lost. The other To: and CC: fields seem
correct.

Also, the original message correctly reached the CAN mailing list with
all the good tags.

  https://lore.kernel.org/linux-can/20230611025728.450837-1-mailhol.vincent@wanadoo.fr/

> It is also unclear to me where this applies - f.e. it doesn't
> apply to the main branch of linux-can-next.

I tested it right now, the original series apply well. The one you
received was redacted and indeed does not apply. For example, this:

  diff --git a/include/linux/can/length.h b/include/linux/can/length.h
  index b8c12c83bc51..521fdbce2d69 100644
  --- a/include/linux/can/length.h
  +++ b/include/linux/can/length.h
  @@ -1,6 +1,7 @@
   /* SPDX-License-Identifier: GPL-2.0 */
   /* Copyright (C) 2020 Oliver Hartkopp <socketcan@hartkopp.net>
    * Copyright (C) 2020 Marc Kleine-Budde <kernel@pengutronix.de>
  + * Copyright (C) 2020 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    */

   #ifndef _CAN_LENGTH_H

became that:

  diff --git a/include/linux/can/length.h b/include/linux/can/length.h
  index b8c12c83bc51..521fdbce2d69 100644
  --- a/include/linux/can/length.h
  +++ b/include/linux/can/length.h
  @@ -1,6 +1,7 @@
   /* SPDX-License-Identifier: GPL-2.0 */
   /* Copyright (C) 2020 Oliver Hartkopp
    * Copyright (C) 2020 Marc Kleine-Budde
  + * Copyright (C) 2020 Vincent Mailhol
    */

   #ifndef _CAN_LENGTH_H

(note the missing e-mail address).

@HMS incident management team, maybe this is something you should fix.

> Lastly, I'm not a CAN maintainer. But I think it's usual to separate
> fixes and enhancements into different series, likely the former
> targeting the can tree while the latter targets the can-next tree
> (I could be way off here).

Hmm... The fact is that only the first two patches are fixes. The
third one is not.  The fixes being really minor, there is no urgency.
So I was thinking of having the full series go to the next branch and
as long as there is the Fix: tag, the two first patches will
eventually be picked by the stable team. I thought that this approach
was easier than sending two fixes to the stable branch, wait for these
to propagate to next and then send a second series of a single patch
for next.

@Marc, let me know what you prefer. I am fine to split if this works
best for you. Also, I will wait for your answer before doing any
resend.

> If on the other hand, the patches in this series are not bug fixes,
> then it is probably best to drop the 'fixes' language.

I will keep the Fix tags. Even if minor (probably no visible
repercussions) it still fixes an existing inaccuracy (whether you call
it bug or not is another debate, but I often see typo fixes being
backported, and these are a bit more than a typo fix).


Yours sincerely,
Vincent Mailhol

