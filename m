Return-Path: <netdev+bounces-9646-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8FF072A1AB
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 455C61C21147
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC6D8206BA;
	Fri,  9 Jun 2023 17:53:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA57F19BA3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:53:53 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2436C3594
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:53:51 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-978863fb00fso361871766b.3
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 10:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1686333229; x=1688925229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3EUzoE9dGxd3VuJpDmZxdF1iqIPMZ5+unNKrN952gKg=;
        b=AhhrXan8UzIf31liXB8vrSH31Ja6NGuvZbSjTVYpc1pp7seGzqdoNg0CvuabZRWdbg
         G+F41ruQtw5GCOm3R+A9cNa7BkaYdxTwivcOqiZ7GOdXfjOvLYXvicHBgpIp/KcNu4Vw
         PQ7PilZELoiRvbEY1OW4mD2AilOqsoEXyTUmM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686333229; x=1688925229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3EUzoE9dGxd3VuJpDmZxdF1iqIPMZ5+unNKrN952gKg=;
        b=j+aFAHO35E6dZ1H9tijDzhP6unAYqzw1PBZzFlBxcXlqCDFdnEp5C3QOY775q9aE+W
         ng11bOhA/7/DZEfZPk5gxD29dJ9Olux9a2c28zx7FsTQPYUadKTrvy0ukpG507iWbOvB
         W9ZQgxzhUYhn2BNAkSP8WL4g2AJrzW4T74rTXLLC0eyiZr9Frxz+rBTbYfUpFAJLKcPJ
         vkE5J5Q7skeG4+K13H7N4suRM6ekOhDQ0iHCwQk6CjN8mt42forL2scwN2qa6udKSi0r
         y99+cAA41SZ2sEfFw05u33AuMc5VPYxxaNfiUZNfDAXxrfnLBLDQ0kbhPn2oBF33W4qy
         2JYg==
X-Gm-Message-State: AC+VfDwy6w5eekmVs2CmuiRwFM93dTMsLN3TJPnnjmtCjyNOPlqu5Jxk
	g3L2TCkz1Iiw0auIsOeRwp9766RXI2J5baglN8wx9OAQ
X-Google-Smtp-Source: ACHHUZ6dpR72dlHQeSXpchn/oHAC6cQ6kB+nNjiaMzOB4ZN/yOrzwc2lMAZUByAHykhP4JzuSmh3rA==
X-Received: by 2002:a17:907:86a8:b0:979:dad9:4ec with SMTP id qa40-20020a17090786a800b00979dad904ecmr2129048ejc.45.1686333229324;
        Fri, 09 Jun 2023 10:53:49 -0700 (PDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id o21-20020a17090637d500b009571293d6acsm1566599ejc.59.2023.06.09.10.53.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 10:53:49 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-3f6dfc4dffaso16389865e9.0
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 10:53:48 -0700 (PDT)
X-Received: by 2002:a17:907:7d88:b0:977:d53e:4055 with SMTP id
 oz8-20020a1709077d8800b00977d53e4055mr2799662ejc.58.1686332808499; Fri, 09
 Jun 2023 10:46:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607223755.1610-1-richard@nod.at> <202306071634.51BBAFD14@keescook>
 <ZIHzbBXlxEz6As9N@alley> <9cd596d9-0ecb-29fc-fe18-f19b86a5ba44@rasmusvillemoes.dk>
 <ZINbQ3eyMB2OGfiN@alley>
In-Reply-To: <ZINbQ3eyMB2OGfiN@alley>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Jun 2023 10:46:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=whW0W3YY4dHGbQoSagMnWEQbQ=Kgv48LJYN1OwVFz8qTQ@mail.gmail.com>
Message-ID: <CAHk-=whW0W3YY4dHGbQoSagMnWEQbQ=Kgv48LJYN1OwVFz8qTQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] Integer overflows while scanning for integers
To: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Kees Cook <keescook@chromium.org>, 
	Richard Weinberger <richard@nod.at>, linux-hardening@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 10:03=E2=80=AFAM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> Added Linus into CC. Quick summary for him:
>
> 1. The original problem is best described in the cover letter, see
>    https://lore.kernel.org/r/20230607223755.1610-1-richard@nod.at

Well, honestly, I'm not convinced this is a huge problem, but:

> > I can't figure out what POSIX actually says should or could happen with
> > sscanf("99999999999999", "%i", &x);
>
> It looks to me that it does not say anything about it. Even the latest
> IEEE Std 1003.1-2017 says just this:

We really don't need to language-lawyer POSIX. It's one of those
"let's follow it to minimize confusion" things, but no need to think
our internal library decisions need to actually care deeply.

For example, we did all the '%pXYZ" extensions on the printf() side,
which are very much *not* POSIX. They have been a huge success.

And even when it comes to the user space ABI, we've always prioritized
backwards compatibility over POSIX.

In some cases have actively disagreed with POSIX for being actively
wrong. For example, POSIX at one point thought that 'accept()',
'bind()' and friends should take a 'size_t' for the address length,
which was complete garbage.

It's "int", and I absolutely refused to follow broken specs. They
ended up fixing their completely broken spec to use 'socklen_t'
instead, which is still completely wrong (it's "int", and anything
else is wrong), but at least you can now be POSIX-compatible without
being broken.

In this case, I would suggest:

 - absolutely do *NOT* add a WARNING() for this, because that just
allows user space to arbitrarily cause kernel warnings. Not ok.

 - fail overflows by default

 - to be able to deal with any compatibility issues, add a way to say
"don't fail overflows" in the format specs, maybe using '!'.

IOW, make

     sscanf("999999999999", "%d", &i);

return 0 (because it couldn't parse a single field - go ahead and set
errno to ERANGE too if you care), but allow people to do

     sscanf("999999999999", "%!d", &i);

which would return 1 and set 'i' to -727379969.

That makes us error out on overflow by default, but gives us an easy
way to say "in this case, I'll take the overflow value" if it turns
out that we have some situation where people gave bad input and it
"just worked".

There's a special case of "overflow" that we may need to deal with:
passing in "-1" as a way to set all bits to one in an unsigned value
is not necessarily uncommon.

So I suspect that even if the conversion is something like "%lu" (or
"%x"), which is technically meant for unsigned values, we need to
still allow negative values, and just say "it's not overflow, it's 2's
complement".

                 Linus

