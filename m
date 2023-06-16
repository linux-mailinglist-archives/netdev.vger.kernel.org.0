Return-Path: <netdev+bounces-11537-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E2149733829
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D0C0280D5A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0471D111A2;
	Fri, 16 Jun 2023 18:31:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA37B1DDC9
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 18:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0272FC433C0;
	Fri, 16 Jun 2023 18:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686940308;
	bh=npccMbFDUkD3Zx7BJ92pVUQqMFnp0n6o4An5GXsnjoc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kcy6Oy4XTDfp17Wng718wKvbUVNgDXbl6LqF6Rqk1mhjf7GSlITumpp6ul5eUdxAD
	 sxPj/ODUBCbaJW+2Je8eHe3EqyRDibEL6p7RuVHv6u1p28egVycOuiR/1/YvV/kHAU
	 yaTCmjQOZB1JVl5P4dMSjG2HKfEuYc/461iOkJ88fB8N9WPZW//Cei+tSVeZrAqo3u
	 mONzpkQssORiqIdMhfkspV81cYR5nvEgj0xE/5r4bQCLNU4qM2KVo4ye62n9IBHlII
	 YsPGZRhYtaw8dhEyHymTAo66oFcGNuyrdYb53Uhwx+y03JW29j8zYyktE845wrZDgs
	 O0kZz7U5Afo8Q==
Date: Fri, 16 Jun 2023 11:31:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, FUJITA Tomonori
 <fujita.tomonori@gmail.com>, netdev@vger.kernel.org,
 rust-for-linux@vger.kernel.org, aliceryhl@google.com
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <20230616113147.45fd9773@kernel.org>
In-Reply-To: <67756b12-e533-4f76-bd3c-360536f2636b@lunn.ch>
References: <20230613045326.3938283-1-fujita.tomonori@gmail.com>
	<20230614230128.199724bd@kernel.org>
	<CANiq72nLV-BiXerGhhs+c6yeKk478vO_mKxMa=Za83=HbqQk-w@mail.gmail.com>
	<20230615191931.4e4751ac@kernel.org>
	<67756b12-e533-4f76-bd3c-360536f2636b@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Jun 2023 15:04:59 +0200 Andrew Lunn wrote:
> > Actually Andrew is interested, and PHY drivers seem relatively simple..
> > /me runs away =20
>=20
> :-)
>=20
> I think because they are so simple, there is not much to gain by
> implementing them in rust.

I see many benefits :) Its a smallish and self-contained piece so it's
achievable. Yet it interacts (to the extent the complexity of the PHY
calls for it) with core netdev structures. Some PHYs even do
timestamping which brings in interactions with skbs etc.

Major benefit number 2 is that Rust is currently missing any real life
bus bindings (AFAIU) and PHYs and the bus they live on are maintained
by the same person =F0=9F=98=81=EF=B8=8F

