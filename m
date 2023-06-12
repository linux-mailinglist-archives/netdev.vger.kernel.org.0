Return-Path: <netdev+bounces-10212-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DF8D72CEFA
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:06:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E3C1281068
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FAF88485;
	Mon, 12 Jun 2023 19:06:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922CC5229
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 19:06:04 +0000 (UTC)
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466D7114;
	Mon, 12 Jun 2023 12:05:59 -0700 (PDT)
Date: Mon, 12 Jun 2023 19:05:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=hk5wwxcnufftnmnhwl5xrasb5a.protonmail; t=1686596754; x=1686855954;
	bh=25iDRWOxvgNspBxNkjPDBM29e6F7kcNQ02iow0Mrb0s=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=lOAZlqYJh3lQ5cuA0WRR8ZJ2QUOn1PeZRl9WPh/3ppHub1GJgqpXggTL8806BR9TY
	 XJtO9gEKzPE8RhoDeIFJvh/xGYRsDcCu1E7N1Y/6buhrz2woTYQSYRtmRd6N7J3Yi0
	 gMqOEf0CI7+ulrrPy7GwkxwpPhhZZNrjuaKucO7pcEIMyVuBMsZ8XektUpe41lef1n
	 79gSGc2AN4KBgWPg53pd5bUE2O69hFXa9BS0UeSTrJ/hCx0xDTpHIgdORsa5/HhpSW
	 HDF3cZOpr2x2a0DzW2ek+Nyss5/u4Y+jRDbItEwCMkwvj7zRcZjmJUrmNOjI6XNSS0
	 /3EIj+/ZMIduw==
To: Bagas Sanjaya <bagasdotme@gmail.com>
From: Sami Korkalainen <sami.korkalainen@proton.me>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Stable <stable@vger.kernel.org>, Linux Regressions <regressions@lists.linux.dev>, Linux Networking <netdev@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Linux regression tracking (Thorsten Leemhuis)" <regressions@leemhuis.info>
Subject: Re: [REGRESSION][BISECTED] Boot stall from merge tag 'net-next-6.2'
Message-ID: <oEbkgJ-ImLxBDZDUTnIAGFWrRVnwBss3FOlalTpwrz83xWgESC9pcvNKiAVp9BzFgqZ0V-NIwzBZ7icKD8ynuIi_ZMtGt7URu3ftcSt16u4=@proton.me>
In-Reply-To: <ZIcmpcEsTLXFaO0f@debian.me>
References: <GQUnKz2al3yke5mB2i1kp3SzNHjK8vi6KJEh7rnLrOQ24OrlljeCyeWveLW9pICEmB9Qc8PKdNt3w1t_g3-Uvxq1l8Wj67PpoMeWDoH8PKk=@proton.me> <ZHFaFosKY24-L7tQ@debian.me> <NVN-hJsvHwaHe6R-y6XIYJp0FV7sCavgMjobFnseULT1wjgkOFNXbGBGT5iVjCfbtU7dW5xy2hIDoq0ASeNaXhvSY-g2Df4aHWVIMQ2c3TQ=@proton.me> <ZIcmpcEsTLXFaO0f@debian.me>
Feedback-ID: 45678890:user:proton
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Ok. I will try the latest mainline and if it does not work, I try bisecting=
 again, but it should take at least a couple of weeks with this old PC. Can=
't really compile more than once a day.

Regards
Sami Korkalainen
___________________________

Sent with Proton Mail secure email.

------- Original Message -------
On Monday, June 12th, 2023 at 17.07, Bagas Sanjaya <bagasdotme@gmail.com> w=
rote:


> On Sat, May 27, 2023 at 04:07:56AM +0000, Sami Korkalainen wrote:
>=20
> > > Where is SCSI info?
> >=20
> > Right there, under the text (It was so short, that I thought to put it =
in the message. Maybe I should have put that also in pastebin for consisten=
cy and clarity):
> >=20
> > Attached devices:
> > Host: scsi0 Channel: 00 Id: 00 Lun: 00
> > Vendor: ATA Model: KINGSTON SVP200S Rev: C4
> > Type: Direct-Access ANSI SCSI revision: 05
> > Host: scsi1 Channel: 00 Id: 00 Lun: 00
> > Vendor: hp Model: CDDVDW TS-L633M Rev: 0301
> > Type: CD-ROM ANSI SCSI revision: 05
> >=20
> > > I think networking changes shouldn't cause this ACPI regression, righ=
t?
> > > Yeah, beats me, but that's what I got by bisecting. My expertise ends=
 about here.
>=20
>=20
> Hmm, no reply for a while.
>=20
> Networking people: It looks like your v6.2 PR introduces unrelated
> ACPICA regression. Can you explain why?
>=20
> ACPICA people: Can you figure out why do this regression happen?
>=20
> Sami: Can you try latest mainline and repeat bisection as confirmation?
>=20
> I'm considering to remove this from regression tracking if there is
> no replies in several more days.
>=20
> Thanks.
>=20
> --
> An old man doll... just what I always wanted! - Clara

