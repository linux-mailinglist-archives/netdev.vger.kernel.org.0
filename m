Return-Path: <netdev+bounces-5108-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C913270FAAA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:45:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 469081C2084E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625FF19BC3;
	Wed, 24 May 2023 15:45:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C7C18C19
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:45:08 +0000 (UTC)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F6DE4D;
	Wed, 24 May 2023 08:44:40 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-64d2981e3abso857051b3a.1;
        Wed, 24 May 2023 08:44:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684943011; x=1687535011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TrdToRO/bP+geIejtXExyfPp1Jsz9iDuLIlZnoMhAw4=;
        b=P/Z3sLeAmsP8pEEDEAueNGGJmHzU2puBjrruJ+DqSV6RK3O3677kqzeJ2At91Zpjpu
         PAK9vizjcbIzwk5a0VqzdyAlfBijUK52E9yGI1y4roZdb17pDkiN17JZK1o1juzTgHyV
         VUsBmFniitcUF6WqqLAzU2bFnHW5BFx9IgItaEuYIf+NO/2O2oH/GlApsSZzLuJcK8sm
         FH3FB4xmBIaha08cjq454ZE0MHyUJx70BV1wu/m/ZcpQ7uRv9Coe12S6clVYbTO4hD8m
         qXVYQ1zqdquxQTGCqG4z8VfhBze6q0cU967P3XJAwN+4k7y56W2HVrB5KakFBkOF8ic3
         8FmQ==
X-Gm-Message-State: AC+VfDx6s/qTZNlHCJyGbg9bFpn6S2wkuzJZQmSt0nGjJYgUV8CA5Qki
	cLdZncfNDoqL7rvRR1hmwwRXhKu6Ps8=
X-Google-Smtp-Source: ACHHUZ4RvB86TUSb68aXdsprcG5wd0nzPx/ZN+jMVjsHyN+i36qEg/CQLdWfQdCwdGen4OL8SAc61w==
X-Received: by 2002:a17:902:bf06:b0:1a6:bd5c:649d with SMTP id bi6-20020a170902bf0600b001a6bd5c649dmr15565269plb.56.1684943010704;
        Wed, 24 May 2023 08:43:30 -0700 (PDT)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com. [209.85.216.45])
        by smtp.gmail.com with ESMTPSA id s10-20020a170902ea0a00b001a0448731c2sm8911493plg.47.2023.05.24.08.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 08:43:30 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2537a79b9acso321149a91.3;
        Wed, 24 May 2023 08:43:30 -0700 (PDT)
X-Received: by 2002:a17:90b:1003:b0:253:669b:4dbc with SMTP id
 gm3-20020a17090b100300b00253669b4dbcmr16813007pjb.41.1684943010142; Wed, 24
 May 2023 08:43:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230523223944.691076-1-Kenny.Ho@amd.com> <01936d68-85d3-4d20-9beb-27ff9f62d826@lunn.ch>
In-Reply-To: <01936d68-85d3-4d20-9beb-27ff9f62d826@lunn.ch>
From: Marc Dionne <marc.dionne@auristor.com>
Date: Wed, 24 May 2023 12:43:18 -0300
X-Gmail-Original-Message-ID: <CAB9dFdt4-cBFhEqsTXk9suE+Bw-xcpM0n3Q6rFmBaa+8A5uMWQ@mail.gmail.com>
Message-ID: <CAB9dFdt4-cBFhEqsTXk9suE+Bw-xcpM0n3Q6rFmBaa+8A5uMWQ@mail.gmail.com>
Subject: Re: [PATCH] Remove hardcoded static string length
To: Andrew Lunn <andrew@lunn.ch>
Cc: Kenny Ho <Kenny.Ho@amd.com>, David Howells <dhowells@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, y2kenny@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 9:50=E2=80=AFPM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, May 23, 2023 at 06:39:44PM -0400, Kenny Ho wrote:
> > UTS_RELEASE length can exceed the hardcoded length.  This is causing
> > compile error when WERROR is turned on.
> >
> > Signed-off-by: Kenny Ho <Kenny.Ho@amd.com>
> > ---
> >  net/rxrpc/local_event.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/rxrpc/local_event.c b/net/rxrpc/local_event.c
> > index 19e929c7c38b..61d53ee10784 100644
> > --- a/net/rxrpc/local_event.c
> > +++ b/net/rxrpc/local_event.c
> > @@ -16,7 +16,7 @@
> >  #include <generated/utsrelease.h>
> >  #include "ar-internal.h"
> >
> > -static const char rxrpc_version_string[65] =3D "linux-" UTS_RELEASE " =
AF_RXRPC";
> > +static const char rxrpc_version_string[] =3D "linux-" UTS_RELEASE " AF=
_RXRPC";
>
> This is not an area of the network stack i know about, so please
> excuse what might be a dumb question.
>
> How is the protocol defined here? Is there an RFC or some other sort
> of standard?
>
> A message is being built and sent over a socket. The size of that
> message was fixed, at 65 + sizeof(whdr). Now the message is variable
> length. Does the protocol specification actually allow this?
>
>         Andrew

I don't think there is an RFC describing RX, but the closest thing to
a spec (https://web.mit.edu/kolya/afs/rx/rx-spec) states:

"If a server receives a packet with a type value of 13, and the
client-initiated flag set, it should respond with a 65-byte payload
containing a string that identifies the version of AFS software it is
running."

So while it may not actually cause any issues (the few things that
look at the data just truncate past 65), it's probably best to keep
the response at a fixed 65 bytes.

Marc

