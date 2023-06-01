Return-Path: <netdev+bounces-7089-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE3D3719D2E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:19:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75C37281739
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FE4FBE6;
	Thu,  1 Jun 2023 13:19:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8631523423
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 13:19:39 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D71E7
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 06:19:37 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-5148e4a2f17so1322969a12.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 06:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685625576; x=1688217576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J9fh93enkgzJnFkHaT1AoRmSykNaubcKRvO4orBZENE=;
        b=BMRLbYcZWRFGS8NzP5yyzosPnpQDUKsuOhZIDqRoXkrGfEJUl1ZrM/SVv/R2n2dI+4
         XM8o2QAfqi49Y99YWc7CErF4Krl4tRyIiBrHfnZSGSxOz7cGMWyQrqgcvpNw4/Ey4Z+S
         JKKbxtJyTK4l+zvVfFpySCANBuYLbxMapFWJM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685625576; x=1688217576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J9fh93enkgzJnFkHaT1AoRmSykNaubcKRvO4orBZENE=;
        b=hMx+Yd3s2mzvF+VQacWoJdf1eF/s+oEa8nGzdrhEfuAmIBDS4Mpc0QPx+zOuoDw1O3
         eSFvWwtXac3DMVahKb0gJgGOsD8HmIdbuqqlvcfRlPuSF9xj11VfhsLLwRRIA+9U4gKD
         AOgEWa2cYGMCsFvDgnG8fz6LWUEQeOWX+urZ0FAv6lmg/tan+5qL61MoCKP5CV4NhBt9
         TtuB46sJKGd7EKRVRzOCn32+3YD/Bn7f0C+m73yYSrK4HKi/BEGZvAqA6ZvzdSOBNPuc
         ZYwrbX4YoNG5fXp+sf8+qLNvwgee9kEScYYdCUk1zoEd+qxDkhG9E2tE4Is6rvw9IgSm
         k26g==
X-Gm-Message-State: AC+VfDzBg/uCCHYKdRWFxn4FGZ656I9M2Hyp43GWW6Xuylv/VeriV6AE
	2hemk0cyButs3odMIYRaEN4E2n/lQkH7qEb1Xdnr4fql
X-Google-Smtp-Source: ACHHUZ6GMnS+iuORu+AtK+c/decxarr9NpcQ/a7UQ0NZOxgtrOvijW6HbacBcRo5kwixzowv/uj+8w==
X-Received: by 2002:aa7:c487:0:b0:514:9e91:f54 with SMTP id m7-20020aa7c487000000b005149e910f54mr5399890edq.26.1685625576166;
        Thu, 01 Jun 2023 06:19:36 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id d23-20020a50fe97000000b0051458c4ae68sm7166128edt.77.2023.06.01.06.19.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 06:19:35 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5162d2373cdso1119762a12.3
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 06:19:35 -0700 (PDT)
X-Received: by 2002:a17:907:a414:b0:96f:5f44:ea02 with SMTP id
 sg20-20020a170907a41400b0096f5f44ea02mr8514666ejc.8.1685625575183; Thu, 01
 Jun 2023 06:19:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230524153311.3625329-1-dhowells@redhat.com> <20230524153311.3625329-10-dhowells@redhat.com>
 <20230526180844.73745d78@kernel.org> <499791.1685485603@warthog.procyon.org.uk>
 <CAHk-=wgeixW3cc=Ys8eL0_+22FUhqeEru=nzRrSXy1U4YQdE-w@mail.gmail.com>
In-Reply-To: <CAHk-=wgeixW3cc=Ys8eL0_+22FUhqeEru=nzRrSXy1U4YQdE-w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Jun 2023 09:19:18 -0400
X-Gmail-Original-Message-ID: <CAHk-=wghhHghtvU_SzXxAzfaX35BkNs-x91-Vj6+6tnVEhPrZg@mail.gmail.com>
Message-ID: <CAHk-=wghhHghtvU_SzXxAzfaX35BkNs-x91-Vj6+6tnVEhPrZg@mail.gmail.com>
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

On Thu, Jun 1, 2023 at 9:09=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The reason the old code is garbage is that it sets SPLICE_F_MORE
> entirely in the wrong place. It sets it *after* it has done the
> splice(). That's just crazy.

Clarification, because there are two splice's (from and to): by "after
the splice" I mean after the splice source, of course. It's still set
before the splice _to_ the network.

(But it is still true that I hope the networking code itself then sets
MSG_MORE even if SPLICE_F_MORE wasn't set, if it gets a buffer that is
bigger than what it can handle right now - so there are two
*different* reasons for "more data" - either the source knows it has
more to give, or the destination knows it didn't use everything it
got).

The point is that the splice *source* knows whether there is more data
to be had, and that's where the "there is more" should be set.

But the generic code does *not* know. You add a completely horrendous
hack to kind of approximate that knowledge, but it's *wrong*.

The old code was wrong too, of course. No question about that.

Basically my argument is that the whole "there is more data" should be
set by "->splice_read()" not by some hack in some generic
splice_direct_to_actor() function that is absolutely not supposed to
know about the internals of the source or the destination.

Do we have a good interface for that? No. I get the feeling that to
actually fix this, we'd have to pass in the 'struct splice_desc"
pointer to ->splice_read().

Then the reading side can say "yup, I have more data for you after
this", and it all makes sense at least conceptually.

So please, can we just fix the layering violation, rather than make it wors=
e?

                Linus

