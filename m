Return-Path: <netdev+bounces-9257-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C4A7284AB
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:14:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3F1028173B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:14:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0921171C1;
	Thu,  8 Jun 2023 16:14:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C459716432
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:14:37 +0000 (UTC)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995AD11A;
	Thu,  8 Jun 2023 09:14:36 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id E8F236081100;
	Thu,  8 Jun 2023 18:14:34 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id oqHi80E8qL1V; Thu,  8 Jun 2023 18:14:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 1F8CE605DED7;
	Thu,  8 Jun 2023 18:14:34 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id tehA2qorFK82; Thu,  8 Jun 2023 18:14:34 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id C30E76081100;
	Thu,  8 Jun 2023 18:14:33 +0200 (CEST)
Date: Thu, 8 Jun 2023 18:14:33 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-hardening <linux-hardening@vger.kernel.org>, 
	netdev <netdev@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	Kees Cook <keescook@chromium.org>, Petr Mladek <pmladek@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, 
	senozhatsky <senozhatsky@chromium.org>, 
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
Message-ID: <1744246043.3699439.1686240873455.JavaMail.zimbra@nod.at>
In-Reply-To: <ZIHlZsPMZ2dI5/yG@smile.fi.intel.com>
References: <20230607223755.1610-1-richard@nod.at> <20230607223755.1610-2-richard@nod.at> <ZIHlZsPMZ2dI5/yG@smile.fi.intel.com>
Subject: Re: [RFC PATCH 1/1] vsprintf: Warn on integer scanning overflows
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
Thread-Topic: vsprintf: Warn on integer scanning overflows
Thread-Index: HtQ8lTrkG2Q6/iouRL6tfcEr+5bePw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

----- Urspr=C3=BCngliche Mail -----
> Von: "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>
>>  =09if (prefix_chars < max_chars) {
>>  =09=09rv =3D _parse_integer_limit(cp, base, &result, max_chars - prefix=
_chars);
>> +=09=09WARN_ON_ONCE(rv & KSTRTOX_OVERFLOW);
>=20
> This seems incorrect. simple_strto*() are okay to overflow. It's by desig=
n.

Is this design decision also known to all users of scanf functions in the k=
ernel?

Thanks,
//richard

