Return-Path: <netdev+bounces-7087-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7124C719CFA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7BC41C21006
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9DCD2EB;
	Thu,  1 Jun 2023 13:09:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C54A23423
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 13:09:38 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B7797
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:09:36 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-96f50e26b8bso118298766b.2
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 06:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685624974; x=1688216974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bGLeNL4xyVWCzs5LFhZzIMiXdkid2+oUWl2Rt0i8z+U=;
        b=KM71FxQkhuCtTMGGWiWYBAzAbtxhLH88ZlN+MyRy2N8QngJe39QtlpcVLxM1ho6S6b
         XNuqd3EwfJyffpJtz1Pnu78Lc+opffulOzPdP86t3TK8meFA+nKCurJ9cEmmFY4vWvTe
         asM1KsDs+fBxS1q0X8slyE8vfNQcJPyGVM4nY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685624974; x=1688216974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bGLeNL4xyVWCzs5LFhZzIMiXdkid2+oUWl2Rt0i8z+U=;
        b=kH3LYV+N8QxGbi4fXT6Lx9INyT2wFBQOrrLqZ5PqAPlTXx+sMvUS5vYXrFKnTupUsM
         6I6rJioLnNnH19INvN7dxOyBUR7EtMvlj1fSIX2vjl7l+vI4PuoqFfw5rKvcVj23l+sS
         wojwD1xJgQV8fxeWZPr7XNGMVYgYQQ/cuDgicXo3y4e/gPIREVXYgE7/vrDA4Fx3cdx4
         p6pwEzp7U6D4bRTbPp/b8vIEaxIATN0dlD+Gq5Kia2+/uuzqd5QHZln1+39o+Ou7RjHD
         wq+MHTfAkT/dO7P2gnH8JsUkqfWYigF4pv6sszvWXK3MmP3mO0YIpgKdDQeOTJpdxS10
         7kpA==
X-Gm-Message-State: AC+VfDxwwlqjTA2isoxymTgYcvJj1HtjML5daJRDWZI99widFid6CUV9
	DTMCL1ALSGfILGk0hrZoUKoIzlBLL5goiutD7bQfjts0
X-Google-Smtp-Source: ACHHUZ4oIuJEMFbtv7CBTzHXsVM0uLlkT840tlHMEFulQfROhS863bxJoBEY3/BqcihCjGYXkZ8lhw==
X-Received: by 2002:a17:907:7295:b0:94f:704d:a486 with SMTP id dt21-20020a170907729500b0094f704da486mr8007062ejc.32.1685624974307;
        Thu, 01 Jun 2023 06:09:34 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id h27-20020a170906111b00b00969cbd5718asm10471007eja.48.2023.06.01.06.09.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 06:09:33 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-9741a0fd134so120241666b.0
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 06:09:33 -0700 (PDT)
X-Received: by 2002:a17:907:9722:b0:95e:d448:477 with SMTP id
 jg34-20020a170907972200b0095ed4480477mr8993487ejc.33.1685624973235; Thu, 01
 Jun 2023 06:09:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230524153311.3625329-1-dhowells@redhat.com> <20230524153311.3625329-10-dhowells@redhat.com>
 <20230526180844.73745d78@kernel.org> <499791.1685485603@warthog.procyon.org.uk>
In-Reply-To: <499791.1685485603@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Jun 2023 09:09:16 -0400
X-Gmail-Original-Message-ID: <CAHk-=wgeixW3cc=Ys8eL0_+22FUhqeEru=nzRrSXy1U4YQdE-w@mail.gmail.com>
Message-ID: <CAHk-=wgeixW3cc=Ys8eL0_+22FUhqeEru=nzRrSXy1U4YQdE-w@mail.gmail.com>
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

On Tue, May 30, 2023 at 6:26=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> When used with sendfile(), it sets SPLICE_F_MORE (which causes MSG_MORE t=
o be
> passed to the network protocol) if we haven't yet read everything that th=
e
> user requested and clears it if we fulfilled what the user requested.
>
> This has the weird effect that MSG_MORE gets kind of inverted. [...]

I hate this patch.

The old code is unquestionably garbage, but this just ends up
resulting in more of the same.

The reason the old code is garbage is that it sets SPLICE_F_MORE
entirely in the wrong place. It sets it *after* it has done the
splice(). That's just crazy.

And that craziness is the direct cause of the bug.

You try to fix the bug by just extending on the craziness. No. The
crazy should be removed, not extended upon.

The "flag" setting should be done *before* the send, if we know that
more data is pending even after the "do_splice_to()". Not after.

And the networking code should do its own "oh, splice gave me X bytes,
but I only used Y, so I know more data is pending, so I'll set
MSG_MORE on the *current* packet". But that's entirely inside of
whatever networking code that does th esplice.

So no. I absolutely refuse to entertain this patch because it's
completely broken. The fact that the old code was also completely
broken is *not* an excuse to make for more nonsensical breakage that
may or may just hide the crazy.

               Linus

