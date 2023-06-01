Return-Path: <netdev+bounces-7115-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E667C71A21D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C7B11C20FD8
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F26E822D43;
	Thu,  1 Jun 2023 15:12:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09922342E
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:12:41 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC8318F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:12:38 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-51491b87565so1521987a12.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 08:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685632357; x=1688224357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ph7ftW5cejm+zmzrjTmdD1HUI/Koyz77q7cE4rVNfqE=;
        b=NX8kdHlRfY/J0T7dPsEEVLJrMJzWVC+rHBuc2VK0YT5fns8/UsmkffPdIhxHg8lA37
         xWhdvLlkEnNenmC2bEq1H/jIBkpFWE4abCkEIi4xbSL00yz+j2g55NkiPbwepsg62XB3
         VmLhDxOTqbKKOBhMt5R9KnavzatVrzc5LekZ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685632357; x=1688224357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ph7ftW5cejm+zmzrjTmdD1HUI/Koyz77q7cE4rVNfqE=;
        b=lmy61nrzlFewh6BxuLozEMiVkKjmRTQzyL5Sp7Y2g1KHgagtrNRr1yF+HtNfcrD24z
         Ip58sZKMm2+PLhBoRj/cUPBOOBL5us8TyL07V2vc96HJ7x4DSTP76i8hq9M/5RL15tza
         Q6CAhUwbobeieg8e5hZS8+k7YwuVH2eJI5DTY2wIo4ByHWmzf2gaiHKKa5RPcJisICDz
         lJZ2fEqSnr9pRqRQz8WsTjAvgEvTM/vHI5851vESsVdB5km4BZEuprHj4vsbH2k4E5Mx
         rq+M7qnOsTDNnZr5Op5Q0LK4FKgZt5Iml68CbIqztZI6OBndzyLHE7jqyn1fwh8xpJP8
         gcdQ==
X-Gm-Message-State: AC+VfDy1cYkCI4sFiKgIBfB8MYc3jAL2pNleXTb8L6Eaw9xyVS3A1wox
	pl28G41F206WaYN35KauPvYchVJ/MsX92qi3us5rks0h
X-Google-Smtp-Source: ACHHUZ5nly8UXJfwqxuunCJnM6I3OvPa/Q7N3SwSmRfChy+XRACUOWGIit1hx0R0HltIjFtLjgkbqA==
X-Received: by 2002:aa7:c543:0:b0:510:e756:3a1e with SMTP id s3-20020aa7c543000000b00510e7563a1emr179867edr.11.1685632356926;
        Thu, 01 Jun 2023 08:12:36 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id d12-20020a1709067f0c00b0093313f4fc3csm10664288ejr.70.2023.06.01.08.12.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 08:12:35 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-96fe2a1db26so127993566b.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 08:12:35 -0700 (PDT)
X-Received: by 2002:a17:907:a42a:b0:96f:912d:7922 with SMTP id
 sg42-20020a170907a42a00b0096f912d7922mr7892507ejc.53.1685632355228; Thu, 01
 Jun 2023 08:12:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230524153311.3625329-1-dhowells@redhat.com> <20230524153311.3625329-10-dhowells@redhat.com>
 <20230526180844.73745d78@kernel.org> <499791.1685485603@warthog.procyon.org.uk>
 <CAHk-=wgeixW3cc=Ys8eL0_+22FUhqeEru=nzRrSXy1U4YQdE-w@mail.gmail.com>
 <CAHk-=wghhHghtvU_SzXxAzfaX35BkNs-x91-Vj6+6tnVEhPrZg@mail.gmail.com> <832277.1685630048@warthog.procyon.org.uk>
In-Reply-To: <832277.1685630048@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Jun 2023 11:12:17 -0400
X-Gmail-Original-Message-ID: <CAHk-=wji_2UwFMkUYkygsYRek05NwaQkH-vA=yKQtQS9Js+urQ@mail.gmail.com>
Message-ID: <CAHk-=wji_2UwFMkUYkygsYRek05NwaQkH-vA=yKQtQS9Js+urQ@mail.gmail.com>
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
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 1, 2023 at 10:34=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> At the moment, it transcribes 16 pages at a time.  I could make it set
> MSG_MORE only if (a) SPLICE_F_MORE was passed into the splice() syscall o=
r (b)
> there's yet more data in the buffer.

That would at least be a good first step.

> However, this might well cause a malfunction in UDP, for example.  MSG_MO=
RE
> corks the current packet, so if I ask sendfile() say shove 32K into a pac=
ket,
> if, say, 16K is read from the source and entirely transcribed into the pa=
cket,

If you use splice() for UDP, I don't think you would normally expect
to get all that well-defined packet boundaries.

That said, I think *this* part of splice_direct_to_actor() is correct:

                if (read_len < len)
                        sd->flags |=3D SPLICE_F_MORE;    <- WRONG
                else if (!more)
                        sd->flags &=3D ~SPLICE_F_MORE; <- CORRECT

ie if we've used up all of the 'len' argument, *and* 'more' wasn't set
in the incoming flags, then at that point we should clear
SPLICE_F_MORE.

So that means that UDP packets boundaries will be honored at the
'splice()' system call 'len' argument.

Obviously packet boundaries might happen before that - ie depending on
what the packet size limits are.

But the "set SPLICE_F_MORE" bit is just wrong. The generic code simply
does not know enough to make that determination.

> if I understand what you're proposing, MSG_MORE wouldn't get set and the
> packet would be transmitted early.

No, I'm saying that MSG_MORE should be set depending on what the
splice *input* says.

If the splice input knows that it has more to give but stopped early
for whatever reason (typically that the splice pipe buffers filled up,
but that's not necessarily the *only* reason), then it should set
SPLICE_F_MORE.

But this is literally only something that the input side *can* know.

And as you mention, some input sides cannot know even that. Regular
files typically know if there is more data. Other dynamic sources may
simply not know. And if they know, they just shouldn't set
SPLICE_F_MORE.

Of course, SPLICE_F_MORE may then be set because the *user* passed in
that flag, but that's a completely separate issue. The user may pass
in that flag because the user wants maximally sized packets, and knows
that other things will be fed into the destination (not even
necessarily through splice) after the splice.

So you really have multiple different reasons why SPLICE_F_MORE might
get set, but that

                if (read_len < len)

is *not* a valid reason. And no, extending that logic with more random
logic is still not a valid reason.

            Linus

