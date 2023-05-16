Return-Path: <netdev+bounces-2880-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A217C704681
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A5062814D5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C3EA1DDC0;
	Tue, 16 May 2023 07:36:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107C71D2D0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32012C433D2;
	Tue, 16 May 2023 07:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684222605;
	bh=zMW5J3IPKcaA8SEZMEgMki8h82ysz8NJd7YJSkmNm6Q=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=mYWhZnf2zav588RBPWXDAdyN1zSX+k0pt6SJnnYuYJZ4sqKUTILhZ8Y/RKuDytXOP
	 8AeEILB0TPh39kKo6Vx2E3dWTJMJ+u6OsT3FJc5zfoFRt0hkIpKzeU6DBEXLDO6OWL
	 zeC65DEFMtBgKujC4aLNTlKCURsR6/vDF8faZpFPboFHOPvbLnHpjJNhF/RJ/AEqd3
	 GkOyrV5InP8DnH5G/LVhvsxdTRhh6GGLlyfINe/hZj8oVvjt7ayp1u95/gHtO1oGQC
	 La+X9EaHgqWYdQXeGBx4nXeuhZqj87VjxEyt6NW3ozBDdFt4mehYsMgN5bBax6mQdG
	 uf3QW2Y21XNcA==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <7c7fc244-012c-7760-a62e-7c31242d489a@ovn.org>
References: <20230511093456.672221-1-atenart@kernel.org> <20230511093456.672221-5-atenart@kernel.org> <fe2f6594-b330-bc5b-55a5-8e1686a2eac1@redhat.com> <CANn89i+R4fdkbQr1u2L-upJobSM3aQOpGi6Kbbix_HPkkovnpA@mail.gmail.com> <2d54b3f5-d8c6-6009-a05a-e5bb2deafeda@redhat.com> <e45f3257-dc5c-3bcd-2de4-64f478ebb470@ovn.org> <11ece947-a839-0026-b272-7fb07bcaf1bb@redhat.com> <168413833063.4854.12088632353537054947@kwain> <7c7fc244-012c-7760-a62e-7c31242d489a@ovn.org>
Subject: Re: [PATCH net-next 4/4] net: skbuff: fix l4_hash comment
From: Antoine Tenart <atenart@kernel.org>
Cc: i.maximets@ovn.org, davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
To: Dumitru Ceara <dceara@redhat.com>, Eric Dumazet <edumazet@google.com>, Ilya Maximets <i.maximets@ovn.org>
Date: Tue, 16 May 2023 09:36:42 +0200
Message-ID: <168422260272.35976.12561298456115365259@kwain>

Quoting Ilya Maximets (2023-05-15 20:23:28)
> On 5/15/23 10:12, Antoine Tenart wrote:
> > Quoting Dumitru Ceara (2023-05-11 22:50:32)
> >> On 5/11/23 19:54, Ilya Maximets wrote:
> >>>>> Note that skb->hash has never been considered as canonical, for obv=
ious reasons.
> >>>
> >>> I guess, the other point here is that it's not an L4 hash either.
> >>>
> >>> It's a random number.  So, the documentation will still not be
> >>> correct even after the change proposed in this patch.
> >=20
> > The proposed changed is "indicate hash is from layer 4 and provides a
> > uniform distribution over flows", which does not describe *how* the hash
> > is computed but *where* it comes from. This matches "random number set
> > by TCP" and changes in how hashes are computed won't affect the comment,
> > so we'll not end up in the same situation.
>=20
> I respectfully disagree,  "is from layer 4" and "random number" do not
> match for me.  So, "where it comes from" argument is not applicable.
> Random numbers come from random number generator, and not "from layer 4".
>=20
> Unless by "from layer 4" you mean "from the code that handles layer 4
> packet processing".  But that seems very confusing to me.  And it is
> definitely not the first thing that comes to mind while reading the
> documentation.

Yes that is what I meant, but if that is still confusing then this is
not improving things so let's try something better. I intentionally did
not mention how the hash is computed because it's easy to forget to
update the documentation when the exact logic is changed. What's
important here IMHO is to mention what the hash provides.

What about "indicates hash was set by layer 4 stack and provides a
uniform distribution over flows"? Or/and we should we also add a
disclaimer like "no guarantee on how the hash was computed"?

> Also making it look like subsystems that use it in a previously
> documented meaning are at fault.  It's just not fair.

I never said that nor it is what I think, I'm sorry if my message was
misleading.

Antoine

