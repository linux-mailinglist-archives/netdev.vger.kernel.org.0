Return-Path: <netdev+bounces-7508-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE5C7207F3
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:54:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F1BE281937
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94209332F8;
	Fri,  2 Jun 2023 16:54:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83552332F6
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:54:04 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D44196
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:54:02 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-5147f5efeb5so3370160a12.0
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 09:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685724841; x=1688316841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lPmI2TrZDJVO0p/gCaOEjLaAl8IYK3WfafDGT3CK+9M=;
        b=D7rjhzbSbPeeaPEAqYQi9x2/eb9VhR7WjqKyoXPjrTqeqC1931F8awE1RHk39TC09a
         KzKDcyUI5q0rvSoQ78m4ZtaFoNDQOLfUpzoNqu6h5lRb3JPCqOQclRJAqV/oBqCcsfPU
         cGL6+WFMKP/F/D7GOVA6RDKH+0rzhXincuHh4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685724841; x=1688316841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lPmI2TrZDJVO0p/gCaOEjLaAl8IYK3WfafDGT3CK+9M=;
        b=lv/gOVOoKT1EI/fmUDZ5RU+w0ISQlaewhkOdvCvofF03AsTPRLXCSi/vj3ig+wykdR
         6c+ck/W5bj23Gz4bMhalUTZ9VRizEnf7XKDoK7c8Gimet9qR/5pes9tRP11VIi+X4PDn
         k0tP0HUPVpuqu3HDUTlUw43toTcgzuirBW2YpZ7uJ88C8ziAxVUic8R0mzoX5j0kOkQG
         d7ef2ZK3bX8is7z8aON3rtTMO8kY1SZBkK/eZOgBU4M6ltpwaw+xTgGvxAiEVubooIoj
         KtZyhFvHrXYMGnwZ/ykgf8WUCkaWeevGaow4wRDaPV118EkvHpqklCgz2kKFHOOdPDS6
         g+EQ==
X-Gm-Message-State: AC+VfDxR8Z+GYIPv6Lmhp84xZd6Csm4RDy2CDT9WnEcGc3zRG7dxxRCc
	zriM9FUFNf1iuIviYVyh1vMmgWbVyAT8Tf6bgKgyLAFF
X-Google-Smtp-Source: ACHHUZ7Emm2s1l6lVPKdrR6oYyCtIc2q0VBszG5QXi5ci/V4VzzyKVzMfAtlKPpt7wDrx7WmTf4j5w==
X-Received: by 2002:a17:907:989:b0:974:1c90:2205 with SMTP id bf9-20020a170907098900b009741c902205mr7701483ejc.13.1685724840823;
        Fri, 02 Jun 2023 09:54:00 -0700 (PDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id gf18-20020a170906e21200b0096629607bb2sm963052ejb.98.2023.06.02.09.53.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 09:53:59 -0700 (PDT)
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-30ae61354fbso2173104f8f.3
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 09:53:59 -0700 (PDT)
X-Received: by 2002:adf:e2c6:0:b0:307:839a:335e with SMTP id
 d6-20020adfe2c6000000b00307839a335emr422037wrj.44.1685724839196; Fri, 02 Jun
 2023 09:53:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHk-=wji_2UwFMkUYkygsYRek05NwaQkH-vA=yKQtQS9Js+urQ@mail.gmail.com>
 <20230524153311.3625329-1-dhowells@redhat.com> <20230524153311.3625329-10-dhowells@redhat.com>
 <20230526180844.73745d78@kernel.org> <499791.1685485603@warthog.procyon.org.uk>
 <CAHk-=wgeixW3cc=Ys8eL0_+22FUhqeEru=nzRrSXy1U4YQdE-w@mail.gmail.com>
 <CAHk-=wghhHghtvU_SzXxAzfaX35BkNs-x91-Vj6+6tnVEhPrZg@mail.gmail.com>
 <832277.1685630048@warthog.procyon.org.uk> <909595.1685639680@warthog.procyon.org.uk>
 <20230601212043.720f85c2@kernel.org> <952877.1685694220@warthog.procyon.org.uk>
 <CAHk-=wjvgL5nyZmpYRWBfab4NKvfQ7NjUvUhE3a3wYTyTEHdfQ@mail.gmail.com>
 <1227123.1685706296@warthog.procyon.org.uk> <CAHk-=wgyAGUMHmQM-5Eb556z5xiHZB7cF05qjrtUH4F7P-1rSA@mail.gmail.com>
 <20230602093929.29fd447d@kernel.org>
In-Reply-To: <20230602093929.29fd447d@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Jun 2023 12:53:42 -0400
X-Gmail-Original-Message-ID: <CAHk-=whgpCNzmQfTAUY7D8P6t9TgzoLx9Uauu7YGQpgZtg-SYg@mail.gmail.com>
Message-ID: <CAHk-=whgpCNzmQfTAUY7D8P6t9TgzoLx9Uauu7YGQpgZtg-SYg@mail.gmail.com>
Subject: Re: Bug in short splice to socket?
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Chuck Lever <chuck.lever@oracle.com>, Boris Pismenny <borisp@nvidia.com>, 
	John Fastabend <john.fastabend@gmail.com>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 12:39=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> Can we add an optional splice_end / short_splice / splice_underflow /
> splice_I_did_not_mean_to_set_more_on_the_previous_call_sorry callback
> to struct file_operations?

A splice_end() operation might well be the simplest model, but I think
it's broken.

It would certainly be easy to implement: file descriptor that doesn't
care about SPLICE_F_MORE - so most of them - would just leave it as
NULL, and the splice code could decide to call it *if* it had left the
last splice with SPLICE_F_MORE, _and_ the user hadn't set it, and the
file descriptor wants that information.

But I think one of the problems here is one of "what the hell is the
meaning of that bit"?

In particular, think about what happens if a signal is pending, and we
return with a partially completed write? There potentially *is* more
data to be sent, it's just not sent by *this* splice() call, as user
space has to handle the signal first.

What is the semantics of SPLICE_F_MORE in that kind of situation?

Which is why I really think that it would be *so* much better if we
really let the whole SPLICE_F_MORE bit be a signal from the *input*
side.

I know I've been harping on this, but just from a "sane semantics"
standpoint, I really think the only thing that *really* makes sense is
for the input side of a splice to say "I gave you X amount of data,
but I have more to give".

And that would *literally* be the semantic meaning of that SPLICE_F_MORE bi=
t.

Wouldn't it be lovely to have some actual documented meaning to it,
which does *not* depend on things like ".. but what if a signal
happens" issues?

And yes, it's entirely possible that I'm missing something, and I'm
misunderstanding what people really want, but I do feel like this is a
somewhat subtle area, and if people really care about the exact
semantics of SPLICE_F_MORE, then we need to *have* exact semantics for
it.

And no, I don't think "splice_end()" can be that exact semantics -
even if it's simple - exactly because splice() is an interruptible
operation, so the "end" of a splice() is simply not a stable thing.

I also do wonder how much we care. What are the situations where the
packet boundaries can really matter in actual real world. Exactly
because I'm not 100% convinced we've had super-stable behavior here.

The fact that a test-case never triggers signal handling in the middle
of a splice() call isn't exactly a huge surprise. The test case
probably doesn't *have* signals. But it just means that the test-case
isn't all that real-life.

              Linus

