Return-Path: <netdev+bounces-9701-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1410672A48C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:20:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 692021C211A6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7CBD22D74;
	Fri,  9 Jun 2023 20:20:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601E0408CF;
	Fri,  9 Jun 2023 20:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67A7C433EF;
	Fri,  9 Jun 2023 20:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686342045;
	bh=+HEW2eDJF0vdUfYIjhBBgAv9GfTMgXPA2PICsfVLPbY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=qGBojQzQXKoLcnMgAfhDpHac2rBCMQ+jen2R+M+v17oQMchcjMIxqPLsdEZS88XIe
	 JCupDlm0MAWawCcVjgJhkPsYMQ9Sg2pWVChOSQn80o4R1udA6FROAREyPh3SIP9N8+
	 QhhOQl50MFJuQq/HgUwYtjopGA/FNhzvlhe1qUv9D+ES/fKO8M8wmZSGGcqxNV63hl
	 FcUDiQHdKICXlXuwqPI/DtiU6VqlJIXMlKnQSUSLpQKADpyI0XNP3sa4rHcj5Z9234
	 1suTdqU5JXguI64PBstpIGra/P4XX7YPy1nVv4Sk+vxE3+BFHyEDYh9SHxS2qCOsB5
	 KFdjW5EAANjSA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id E27D3BBE38F; Fri,  9 Jun 2023 22:20:42 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Timo Beckers <timo@incline.eu>, Daniel Borkmann <daniel@iogearbox.net>,
 Stanislav Fomichev <sdf@google.com>, ast@kernel.org, andrii@kernel.org,
 martin.lau@linux.dev, razor@blackwall.org, john.fastabend@gmail.com,
 kuba@kernel.org, dxu@dxuuu.xyz, joe@cilium.io, davem@davemloft.net,
 bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query
 API for multi-progs
In-Reply-To: <CAEf4BzYnZ0XoTY=JHEq3iicP8OVPDHfziJ=q_7_F5O=B0pX6tw@mail.gmail.com>
References: <20230607192625.22641-1-daniel@iogearbox.net>
 <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com>
 <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com>
 <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com> <87a5x91nr8.fsf@toke.dk>
 <3a315a0d-52dd-7671-f6c1-bb681604c815@iogearbox.net>
 <874jng28xk.fsf@toke.dk> <1a73a1b9-c72a-de81-4fce-7ba4fb6d7900@incline.eu>
 <87sfb0zsok.fsf@toke.dk>
 <CAEf4BzYnZ0XoTY=JHEq3iicP8OVPDHfziJ=q_7_F5O=B0pX6tw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Fri, 09 Jun 2023 22:20:42 +0200
Message-ID: <87pm64z8th.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

>> >>> See above on the issues w/o the first/last. How would you work around them
>> >>> in practice so they cannot happen?
>> >> By having an ordering configuration that is deterministic. Enforced by
>> >> the system-wide management daemon by whichever mechanism suits it. We
>> >> could implement a minimal reference policy agent that just reads a
>> >> config file in /etc somewhere, and *that* could implement FIRST/LAST
>> >> semantics.
>> > I think this particular perspective is what's deadlocking this discussion.
>> > To me, it looks like distros and hyperscalers are in the same boat with
>> > regards to the possibility of coordination between tools. Distros are only
>> > responsible for the tools they package themselves, and hyperscalers
>> > run a tight ship with mostly in-house tooling already. When it comes to
>> > projects out in the wild, that all goes out the window.
>>
>> Not really: from the distro PoV we absolutely care about arbitrary
>> combinations of programs with different authors. Which is why I'm
>> arguing against putting anything into the kernel where the first program
>> to come along can just grab a hook and lock everyone out.
>
> What if some combinations of programs just cannot co-exist?
>
>
> Me, Daniel, Timo are arguing that there are real situations where you
> have to be first or need to die.

Right, and what I'm saying is that this decision should not be up to
individual applications to decide for the whole system. I'm OK with an
application *requesting* that, but it should be possible for a
system-level policy to override that request. I don't actually care so
much about the mechanism for doing so; I just don't want to expose a
flag in UAPI that comes with such a "lock everything" promise, because
that explicitly prevents such system overrides.

> And the counter argument we are getting is "but someone can
> accidentally or in bad faith overuse F_FIRST". The former is causing
> real problems and silent failures. The latter is about fixing bugs
> and/or fighting bad actors. We don't propose any real solution for the
> real first problem, because we are afraid of hypothetical bad actors.
> The former has a technical solution (F_FIRST/F_LAST), the latter is a
> matter of bug fixing and pushing back on bad actors. This is where
> distros can actually help by making sure that bad actors that don't
> really need F_FIRST/F_LAST are not using them.

It's not about "bad actors" in the malicious sense, it's about decisions
being made in one context not being valid in another. Take Daniel's
example of a DDOS application. It's probably a quite legitimate choice
for the developers of such an application to say "it only makes sense to
run a DDOS application first, so of course we'll set the FIRST flag".
But it is just as legitimate for a user/admin to say "I actually want to
run this DDOS application after this other application I wrote for that
specific purpose". If we enforce the FIRST flag semantics at the kernel
level we're making a decision that the first case is legitimate and the
second isn't, and that's just not true.

The whole datadog/cilium issue shows exactly that this kind of conflict
*is* how things play out in practice.

-Toke

