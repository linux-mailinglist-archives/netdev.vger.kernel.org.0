Return-Path: <netdev+bounces-7069-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CBA4719A08
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 12:44:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B8951C20B71
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A98D923409;
	Thu,  1 Jun 2023 10:44:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E655E23400
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C34AC433EF;
	Thu,  1 Jun 2023 10:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685616268;
	bh=bYp2io0uVTl+f+qPUizOw5UzogwUPAvYmR0vmqDhLS4=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
	b=G2Hx5V2r5FFcHtNRyoufeCN0O47XHgkfZ1TEc9ykqPyPxydM3nBiMMatnsVqEOpuO
	 gowNYFw9L6RDlSb/h800DsxkbIKIIl547DYwYCynn34kkoaMC/zZisfyJnYuuo8AMa
	 +qIIHYVKYs9hoiCLxc1hDoYveDldSX7ecQkdIP1mbtrPtZsy5AtGESWmSNDLuvhzFQ
	 Z67+3JHPBykyYmCLgNp7hX70zYPW31lthTZD9hj3MaeN0fUYIYEaOWR/WPQ9VhWpa9
	 8iKDHLkKQLOvTbQcRoLuYEw/kUAM03iuuakzvcGwvYt0Phg/Yi33FDWLUlxsJxDgXF
	 pY8pj+bnv2BAQ==
From: Kalle Valo <kvalo@kernel.org>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: netdev@vger.kernel.org,  linux-wireless@vger.kernel.org,  ath10k@lists.infradead.org,  Eric Dumazet <edumazet@google.com>,  kernel@pengutronix.de,  Jakub Kicinski <kuba@kernel.org>,  Paolo Abeni <pabeni@redhat.com>,  "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/4] Convert to platform remove callback returning void
References: <20230601082556.2738446-1-u.kleine-koenig@pengutronix.de>
	<87h6rrk0cn.fsf@kernel.org>
	<20230601093055.ovmhypa5jw2bq32q@pengutronix.de>
Date: Thu, 01 Jun 2023 13:44:24 +0300
In-Reply-To: <20230601093055.ovmhypa5jw2bq32q@pengutronix.de> ("Uwe
	\=\?utf-8\?Q\?Kleine-K\=C3\=B6nig\=22's\?\= message of "Thu, 1 Jun 2023 11:30:55
 +0200")
Message-ID: <874jnrjwc7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de> writes:

> Hello Kalle,
>
> On Thu, Jun 01, 2023 at 12:17:44PM +0300, Kalle Valo wrote:
>> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de> writes:
>>=20
>> > the motivation for this series is patch #3, patch #2 is a preparation =
for it
>> > and patches #1 and #4 are just cleanups that I noticed en passant.
>> >
>> > Best regards
>> > Uwe
>> >
>> > Uwe Kleine-K=C3=B6nig (4):
>> >   ath10k: Drop cleaning of driver data from probe error path and remove
>> >   ath10k: Drop checks that are always false
>> >   ath10k: Convert to platform remove callback returning void
>> >   atk10k: Don't opencode ath10k_pci_priv() in ath10k_ahb_priv()
>> >
>> >  drivers/net/wireless/ath/ath10k/ahb.c  | 20 +++-----------------
>> >  drivers/net/wireless/ath/ath10k/snoc.c |  8 +++-----
>> >  2 files changed, 6 insertions(+), 22 deletions(-)
>>=20
>> ath10k patches go to my ath.git tree, not net-next.
>
> This isn't obvious for outsiders. Not sure what can be improved to
> make this easier to spot.

Yeah, you are definitely not the first one who is bitten by this. We do
have the tree documented in MAINTAINERS but that's easy to miss:

QUALCOMM ATHEROS ATH10K WIRELESS DRIVER
M:      Kalle Valo <kvalo@kernel.org>
L:      ath10k@lists.infradead.org
S:      Supported
W:      https://wireless.wiki.kernel.org/en/users/Drivers/ath10k
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
F:      Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
F:      drivers/net/wireless/ath/ath10k/

And a rule of thumb is that all wireless patches do normally go to
wireless or wireless-next trees, and for most active wireless drivers we
have separate trees as well (like ath.git in this case).

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes

