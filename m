Return-Path: <netdev+bounces-8548-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A57724833
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:49:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5154E280FB2
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92F0330B75;
	Tue,  6 Jun 2023 15:49:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D5E37B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D15C433EF;
	Tue,  6 Jun 2023 15:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686066560;
	bh=o3yIyCgRGH5S/mkc72bZVcX1gFYjf6Gdv8HpJ7qF+LU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q6g8lMbvdId+tdw4GDmeH3iPjXPM1hrXJwWCMtjZ1/6w8jA1rh8Z0afNx+werNP1l
	 o/9wul1LtP/LDysdjREGdKRrEzDp7lgdHlzDWht4Ru/0KjeXHRzL/Jjof1zHmUXYUF
	 cr3cuV2fGPN782BxwYjayQ9UEOkL+WaksOpbwaSpLKY6ZCoUJdOleT4gZ4ca7Wde46
	 zEk3CHW8Gtzr/HblztuiSpWoCEXM8jXtjDkZ40xjxdECY/035mJX3k+DxIpABh+qsX
	 Qb6/Ulo59sFh4bf23uezvjEPqua6wf6tl/A+XJy04MlJ+f6TOTN7u6ms+4fzV2RupW
	 h/lhZ37Ph/JIw==
Date: Tue, 6 Jun 2023 08:49:19 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "luwei (O)" <luwei32@huawei.com>
Cc: Networking <netdev@vger.kernel.org>
Subject: Re: [Question] integer overflow in function
 __qdisc_calculate_pkt_len()
Message-ID: <20230606084919.5549dd58@kernel.org>
In-Reply-To: <c6ab254d-76c3-7507-3935-e9bad4da0bab@huawei.com>
References: <7723cc01-57bf-2b64-7f78-98a0e6508a2e@huawei.com>
	<20230605161922.5e417434@kernel.org>
	<c6ab254d-76c3-7507-3935-e9bad4da0bab@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Jun 2023 20:54:47 +0800 luwei (O) wrote:
> > on a quick look limiting the cell_align to S16_MIN at the netlink level
> > (NLA_POLICY_MIN()) seems reasonable, feel free to send a patch.
> > . =20
>=20
> Thanks for your reply, but do your mean cell_align or overhead? It seems=
=20
> limit cell_align to
>=20
> S16_MIN(-32768) can still cause the overflow:
>=20
>  =C2=A0=C2=A0=C2=A0 66 + (-2147483559) + (-32767) =3D 2147451036
>=20
>    skb->len =3D 66
>    stab->szopts.overhead =3D -2147483559
>    stab->szopts.cell_align =3D -32767

Could you explain what the problem caused by the overflow will be?

