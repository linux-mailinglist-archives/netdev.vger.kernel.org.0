Return-Path: <netdev+bounces-7511-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 340C372081F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65EA71C2094D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0795332FF;
	Fri,  2 Jun 2023 17:05:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DF3332E1
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 17:05:37 +0000 (UTC)
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA974C0
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:05:35 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-96fbe7fbdd4so330213366b.3
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 10:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685725534; x=1688317534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pzyEvgFM4vBLAnySBJOk0orGfxOVuDft8i1c0mN6AA4=;
        b=OdE+LoDd65ZZj9zVyGZSCZI9qn8+CWDC1g0qNCCO5bxb2PxD4AuWpDU0mP4o/OmjJa
         CTHR2yrZII1XYV+S1LJBNxsSqQLh6MzdM2wB6owS+beTpTG7Jlwelw8cx9b4yA4ZotJD
         nTW/I4WZZMaLkZUAO4MKf5l3MefPR2PmIurMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685725534; x=1688317534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pzyEvgFM4vBLAnySBJOk0orGfxOVuDft8i1c0mN6AA4=;
        b=YmeJVUWtToPM/7y6Lce+e0dH9YS47gH4DQwJChduFijUmhWQ/T1xyWAg9z9ruvmF61
         sbjDn5TTqSb6F5XSRuaR1SybGSSeAVGw9n907qXwicrilBo8BBiVNr4VLrU/FuSakw5s
         B9+wuptbkJvqxGylYdrIrm7dJwjYMl8OI58PsrLqEW4nKSpfLDiPB0U1vrUkVSK3Ps1E
         i8rcHP6okLpedYX8vUekAmyLEvz88stWN4aHNGZZ4A4A8Sb4Pk/H1a+TgeCKUs4c0qi7
         6wm/6ulUPIRkdL/XbWfaDIFKy7kywurImIQ4YQecXcKCRthlPlNhlaZ9ENeNwfxUTSyN
         uF8g==
X-Gm-Message-State: AC+VfDxN5/BqTVE6yQNOwlnyz2J9SpHOrFjjSY9HLirSjwtvENhjoPfv
	RWpQoynqQwMvtG72fO/PHsFSyCh/JgehnSx+eATgIuI+
X-Google-Smtp-Source: ACHHUZ5kib9GuB1EkoJkbLhDjPXOH2l3NfCfg3NJYSIRQaYK2beo8hw3ZusXakWREihTy1Mzugxqrw==
X-Received: by 2002:a17:907:3e9d:b0:96a:3e7:b592 with SMTP id hs29-20020a1709073e9d00b0096a03e7b592mr12868370ejc.25.1685725534050;
        Fri, 02 Jun 2023 10:05:34 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id bq4-20020a170906d0c400b0096f7105b3a6sm952009ejb.189.2023.06.02.10.05.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 10:05:32 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-51478f6106cso3327355a12.1
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 10:05:31 -0700 (PDT)
X-Received: by 2002:aa7:d6d7:0:b0:50d:9de4:5664 with SMTP id
 x23-20020aa7d6d7000000b0050d9de45664mr1810734edr.40.1685725531338; Fri, 02
 Jun 2023 10:05:31 -0700 (PDT)
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
 <20230602093929.29fd447d@kernel.org> <CAHk-=whgpCNzmQfTAUY7D8P6t9TgzoLx9Uauu7YGQpgZtg-SYg@mail.gmail.com>
In-Reply-To: <CAHk-=whgpCNzmQfTAUY7D8P6t9TgzoLx9Uauu7YGQpgZtg-SYg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Jun 2023 13:05:14 -0400
X-Gmail-Original-Message-ID: <CAHk-=wh=V579PDYvkpnTobCLGczbgxpMgGmmhqiTyE34Cpi5Gg@mail.gmail.com>
Message-ID: <CAHk-=wh=V579PDYvkpnTobCLGczbgxpMgGmmhqiTyE34Cpi5Gg@mail.gmail.com>
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

On Fri, Jun 2, 2023 at 12:53=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And no, I don't think "splice_end()" can be that exact semantics -
> even if it's simple - exactly because splice() is an interruptible
> operation, so the "end" of a splice() is simply not a stable thing.

Just to harp some more on this - if SPLICE_F_MORE is seen as purely a
performance hit, with no real semantic value, and will still set
random packet boundaries but we want big packets for all the _usual_
cases, then I think something like "splice_end()" can be a fine
solution regardless of exact semantics.

Alternatively, if we make it the rule that "splice_end()" is only
called on EOF situations - so signals etc do not matter - then the
semantics would be stable and sound fine to me too.

In that second case, I'd like to literally name it that way, and
actually call it "splice_eof()". Because I'd like to really make it
very clear what the semantics would be.

So a "splice_eof()" sounds fine to me, and we'd make the semantics be
the current behavior:

 - splice() sets SPLICE_F_MORE if 'len > read_len'

 - splice() _clears_ SPLICE_F_MORE if we have hit 'len'

 - splice always sets SPLICE_F_MORE if it was passed by the user

BUT with the small new 'splice_eof()' rule that:

 - if the user did *not* set SPLICE_F_MORE *and* we didn't hit that
"use all of len" case that cleared SPLICE_F_MORE, *and* we did a
"->splice_in()" that returned EOF (ie zero), *then* we will also do
that ->splice_eof() call.

The above sounds like "stable and possibly useful semantics" to me. It
would just have to be documented.

Is that what people want?

I don't think it's conceptually any different from my suggestion of
saying "->splice_read() can set SPLICE_F_MORE if it has more to give",
just a different implementation that doesn't require changes on the
splice_read() side.

                 Linus

