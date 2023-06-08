Return-Path: <netdev+bounces-9256-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8DC67284A5
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:12:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56BF428173C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98AAC171A6;
	Thu,  8 Jun 2023 16:12:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DEC1641A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:12:23 +0000 (UTC)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C28311A;
	Thu,  8 Jun 2023 09:12:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 093FC605DED7;
	Thu,  8 Jun 2023 18:12:12 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id YsTv-yOP3HrN; Thu,  8 Jun 2023 18:12:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 7E9E36081100;
	Thu,  8 Jun 2023 18:12:11 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id VYHkTxYt_ulp; Thu,  8 Jun 2023 18:12:11 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id 508B4605DED7;
	Thu,  8 Jun 2023 18:12:11 +0200 (CEST)
Date: Thu, 8 Jun 2023 18:12:11 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: Petr Mladek <pmladek@suse.com>
Cc: Kees Cook <keescook@chromium.org>, 
	linux-hardening <linux-hardening@vger.kernel.org>, 
	netdev <netdev@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, 
	senozhatsky <senozhatsky@chromium.org>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	davem <davem@davemloft.net>, edumazet <edumazet@google.com>, 
	kuba <kuba@kernel.org>, pabeni <pabeni@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?Q?Bj=C3=B6rn?= Roy Baron <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, 
	Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>
Message-ID: <520885538.3699431.1686240731083.JavaMail.zimbra@nod.at>
In-Reply-To: <ZIHzbBXlxEz6As9N@alley>
References: <20230607223755.1610-1-richard@nod.at> <202306071634.51BBAFD14@keescook> <ZIHzbBXlxEz6As9N@alley>
Subject: Re: [RFC PATCH 0/1] Integer overflows while scanning for integers
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: Integer overflows while scanning for integers
Thread-Index: eRz4qdIczSWHayESvWhfMkCVWHkibA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

----- Urspr=C3=BCngliche Mail -----
> Von: "Petr Mladek" <pmladek@suse.com>
> On Wed 2023-06-07 16:36:12, Kees Cook wrote:
>> On Thu, Jun 08, 2023 at 12:37:54AM +0200, Richard Weinberger wrote:
>> > Hi!
>> >=20
>> > Lately I wondered whether users of integer scanning functions check
>> > for overflows.
>> > To detect such overflows around scanf I came up with the following
>> > patch. It simply triggers a WARN_ON_ONCE() upon an overflow.
>> >=20
>> > After digging into various scanf users I found that the network device
>> > naming code can trigger an overflow.
>> >=20
>> > e.g:
>> > $ ip link add 1 type veth peer name 9999999999
>> > $ ip link set name "%d" dev 1
>> >=20
>> > It will trigger the following WARN_ON_ONCE():
>> > ------------[ cut here ]------------
>> > WARNING: CPU: 2 PID: 433 at lib/vsprintf.c:3701 vsscanf+0x6ce/0x990
>>=20
>> Hm, it's considered a bug if a WARN or BUG can be reached from
>> userspace,
>=20
> Good point. WARN() does not look like the right way in this case.

Well, the whole point of my RFC(!) patch is showing the issue and providing=
 a way
to actually find such call sites, like the netdev code.
=20
> Another problem is that some users use panic_on_warn. In this case,
> the above "ip" command calls would trigger panic(). And it does not
> look like an optimal behavior.

Only if we don't fix netdev code.
=20
> I know there already are some WARN_ONs for similar situations, e.g.
> set_field_width() or set_precision(). But these do not get random
> values. And it would actually be nice to introduce something like
> INFO() that would be usable for these less serious problems where
> the backtrace is useful but they should never trigger panic().
>=20
>> so this probably needs to be rearranged (or callers fixed).
>> Do we need to change the scanf API for sane use inside the kernel?
>=20
> It seems that userspace implementation of sscanf() and vsscanf()
> returns -ERANGE in this case. It might be a reasonable solution.
>=20
> Well, there is a risk of introducing security problems. The error
> value might cause an underflow/overflow when the caller does not expect
> a negative value.

Agreed. Without inspecting all users of scanf we cannot change the API.

> Alternative solution would be to update the "ip" code so that it
> reads the number separately and treat zero return value as
> -EINVAL.

The kernel needs fixing, not userspace.

Thanks,
//richard

