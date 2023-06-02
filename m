Return-Path: <netdev+bounces-7409-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A77720135
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E2A72818DD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F0C18C28;
	Fri,  2 Jun 2023 12:12:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E47917AC5
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 12:12:11 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F8EC0
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:12:09 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-51458187be1so2873216a12.2
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 05:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685707927; x=1688299927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/nu2Etlmi3Eu2Y0bwV0OBeKuPQ/LYJXZotP8yg4CZLQ=;
        b=FMfv6NVUdf2cl3tjQSRkGV47SnCVCf/kipOnXZZH+lVXam/VQ8M5/FCn+UUa5bAJpw
         4YRYxeuCssdVte6JNYgZiO1oPsBHUZdy0hdyWwzojraHP9KZkLhqqaMaNAf17R9XFXNu
         kxLXTQ1f3VV8LYy8jMk+TNPny5Y9XhsaDCqDQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685707927; x=1688299927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/nu2Etlmi3Eu2Y0bwV0OBeKuPQ/LYJXZotP8yg4CZLQ=;
        b=V+8jG3FxOIzqvEzZ3RA0on9Yw99XF6zyqfI38J5lYuqAA2QPLpYM/DAbFWBfbHl/S0
         MHOytUf2M7b/hq4CAAOWi1bu5uvfBNYaFt6Y7zgN21iZx0TpRqE7OM6tcBWrWlSrVIj1
         BeceeFb6mJoTFOGz47GpGJl4ydqXOuo1VTAlwQATmeBlJwbf2w8xlI5HNwFHusr82T8+
         xWr1UJVX9LxXyHC2J1EhHpSnk1o2qLbdnPCnCTIu0HFi+rZqakSJxmFPLaCDdbg4Ihp3
         Wuu91tRRlRr9674kLl+hK7m+2yYmjz6PndslJgowqlJpWN1A6x//LmHJFCOVeGRc2ErN
         96kQ==
X-Gm-Message-State: AC+VfDxuqk/oqgSvbTiCuj6BgnQ+IWAbfDwyFAz6wLG3mVRgj8o/cSlm
	s23vgnoZ6rI3HuJ8tf7OfkP58WSfh1fKeJ8SNdat6nFM
X-Google-Smtp-Source: ACHHUZ7ukTcUNNcBjdCPq2UCvuwj5vh0yizjc1A1SgRd65+Wkk7NLzlhzw1o5vJNLWxcyb2Nf+oAOg==
X-Received: by 2002:a17:907:961b:b0:973:9c54:5723 with SMTP id gb27-20020a170907961b00b009739c545723mr12564546ejc.2.1685707927596;
        Fri, 02 Jun 2023 05:12:07 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id f18-20020a170906825200b00965ac1510f8sm682429ejx.185.2023.06.02.05.12.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 05:12:05 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5149c76f4dbso2887269a12.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 05:12:04 -0700 (PDT)
X-Received: by 2002:a05:6402:2027:b0:514:9934:de96 with SMTP id
 ay7-20020a056402202700b005149934de96mr1647596edb.26.1685707924342; Fri, 02
 Jun 2023 05:12:04 -0700 (PDT)
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
 <CAHk-=wjvgL5nyZmpYRWBfab4NKvfQ7NjUvUhE3a3wYTyTEHdfQ@mail.gmail.com> <1227123.1685706296@warthog.procyon.org.uk>
In-Reply-To: <1227123.1685706296@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Jun 2023 08:11:47 -0400
X-Gmail-Original-Message-ID: <CAHk-=wgyAGUMHmQM-5Eb556z5xiHZB7cF05qjrtUH4F7P-1rSA@mail.gmail.com>
Message-ID: <CAHk-=wgyAGUMHmQM-5Eb556z5xiHZB7cF05qjrtUH4F7P-1rSA@mail.gmail.com>
Subject: Re: Bug in short splice to socket?
To: David Howells <dhowells@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
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

On Fri, Jun 2, 2023 at 7:45=E2=80=AFAM David Howells <dhowells@redhat.com> =
wrote:
>
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> > Do what I already suggested: making SPLICE_F_MORE reflect reality.
>
> I'm trying to.  I need MSG_MORE to behave sensibly for what I want.

But you need to stop doing these random hacks to fs/splice.c

The point is, you *CANNOT* make SPLICE_F_MORE reflect reality by
hacking fs/splice.c. Really. The generic layer DOES NOT KNOW, AND
FUNDAMENTALLY CANNOT KNOW if there is more data to be had.

So any of these random patches that try to add heuristics to
fs/splice.c will be rejected out of hand. They simply cannot be
correct.

And no, on the whole I do not believe you have to maintain some
selftest. A selftest failure is worrisome in that it clearly shows
that some behavior changed, but the situation here is

 (a) the current behavior is arguably bad and buggy

 (b) if we want to fix that bug, then the current behavior *will* change

Now, the only question then is whether the self-test actually tests
anything that user space actually depends on, or if it just tests some
random corner case.

So the self-test is certainly a ref flag, but not necessarily a very
meaningful one.

It shows that some user-visible change happened, which is always a big
danger flag, but after all that was the whole *point* of the whole
exercise.  The fact that the self-test caught the change is good,
because it means we had test coverage, but when the behavior is
something we *want* to change, the test failure is not a problem in
itself.

So what I think you should do is to fix the bug right, with a clean
patch, and no crazy hacks. That is something we can then apply and
test. All the while knowing full well that "uhhuh, this is a visible
change, we may have to revert it".

If then some *real* load ends up showing a regression, we may just be
screwed. Our current behavior may be buggy, but we have the rule that
once user space depends on kernel bugs, they become features pretty
much by definition, however much we might dislike it.

At that point, we'll have to see what we can do - if anything.

Basically, what I think the SPLICE_F_MORE rules *should* be (and hey,
I may be missing something) is

 1) if the user set that bit in the flags, then it's always true.

    The user basically told us "I will supply more data even after the
splice has finished", so it doesn't matter if the kernel runs out of
data in the middle.

 2) if the splice read side sees "I was asked for N bytes, but I could
only supply X bytes and I still have more to give", when we should set
SPLICE_F_MORE internally ("temporarily") for the next splice call.

    This is basically the "kernel independently knows that there will
be more data" case.

 3) In the end, this is all "best effort" and to some degree
inevitably a heuristic. We cannot see the future. We may hit that case
#2 and set the "there will be more data" bit, but then get a signal
and finish the splice system call before that more data actually
happens.

    Now, presumably the user will then continue the partial splice
after handling the signal, so (3) is still "right", but obviously we
can't _know_ that.

A corollary to (3) is that the reader side may not always know if
there will be more data to be read. For a file source, it's fairly
clear (modulo the obvious caveats - files can be truncated etc etc).
For other splice sources, the "I still have more to give" may not be
as unambiguous.  It is what it is.

Am I missing some important case? Considering that we clearly do *not*
do a great job at  SPLICE_F_MORE right now, I'd really want the
situation to be either that we just make the code "ClearlyCorrect(tm)"
and simple, or we just leave it alone as "that's our odd behavior,
deal with it".

None of this "let's change this all to be even more complex, and
handle some particular special case the way I want" crap.

Do it right, or don't do it at all.

             Linus

