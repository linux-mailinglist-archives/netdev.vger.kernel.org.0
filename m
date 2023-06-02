Return-Path: <netdev+bounces-7396-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B099720060
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:28:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EBFF281849
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A1B17FF3;
	Fri,  2 Jun 2023 11:28:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E885A8466
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 11:28:25 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A821A2
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 04:28:24 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-9707313e32eso295402666b.2
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 04:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685705303; x=1688297303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z1GnyRn3CUTJ1J4Rj60TNnTJgegattVBSNHX3CbgG/Y=;
        b=bn3C84Mr82lUs9KMRWxxzQw54grJ/1hH+dpu19PDzBB5tDv1RC0ij0b85J9qAJjYKX
         2xAl0kEJtgjvX6biL98t7N43g/n2k30W5LLLg7jB4oydIonsl5/zYCn5fbEKP6uyVHJg
         X5eqmoWfQo866b17r2wGYC+FpTTPz8fXI64Ks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685705303; x=1688297303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z1GnyRn3CUTJ1J4Rj60TNnTJgegattVBSNHX3CbgG/Y=;
        b=gmWjUrIsMtP2UoRQjuPSCiH73F4P/vmCYdVRHoLvnEwmnis3t1uz5iSTOt76m3wakb
         w1Gtz9sG+I9Mpu6DY7Df8JwNsd1PrzDsRpHx51skXzYLEuQNtk8LbY/m1ueCQMbjhFzD
         iON0GzwUqxfmHJmImS6VGv//N777SQDaKH4IRDhXx7a7wWzDY4Wq0KfqTPqHqXpkxjYw
         2vhPKfOlUpfJLUZmEs3pYPRzZ1S1quXXQMrlRdBVHdY7Q36LVzZ/pbvmGmLarNYorwFK
         /xt2r69kPtaENWMena5ObXZYAqqzroQcd4L2LwP5kcUvOBQDOwy26c404NtoL/8WAsXd
         JM/Q==
X-Gm-Message-State: AC+VfDx+01iyXvbOMAjsyu00VEzKIx8okqccv96AZpfNXvs1pc+p/Ano
	5WX6tLM2Hh0OlkEJrAAOHaDbwflQq4lUTDOOS/rjhJD6
X-Google-Smtp-Source: ACHHUZ5ap5OXfSvTwOuyczdIH36UcpHBNf4oXqvYKjSO7LdFdj+hnFBMa9g7YVDz2YPDHNUOehTqwg==
X-Received: by 2002:a17:907:1c91:b0:96f:5cb3:df66 with SMTP id nb17-20020a1709071c9100b0096f5cb3df66mr11782623ejc.18.1685705302946;
        Fri, 02 Jun 2023 04:28:22 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id i15-20020a170906114f00b009545230e682sm652751eja.91.2023.06.02.04.28.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 04:28:22 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-51458187be1so2819092a12.2
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 04:28:22 -0700 (PDT)
X-Received: by 2002:aa7:c403:0:b0:50b:c89f:f381 with SMTP id
 j3-20020aa7c403000000b0050bc89ff381mr1838560edq.29.1685705302070; Fri, 02 Jun
 2023 04:28:22 -0700 (PDT)
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
In-Reply-To: <952877.1685694220@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Jun 2023 07:28:05 -0400
X-Gmail-Original-Message-ID: <CAHk-=wjvgL5nyZmpYRWBfab4NKvfQ7NjUvUhE3a3wYTyTEHdfQ@mail.gmail.com>
Message-ID: <CAHk-=wjvgL5nyZmpYRWBfab4NKvfQ7NjUvUhE3a3wYTyTEHdfQ@mail.gmail.com>
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

On Fri, Jun 2, 2023 at 4:23=E2=80=AFAM David Howells <dhowells@redhat.com> =
wrote:
>
> +/*
> + * Pass a zero-length record to the splice-write actor with SPLICE_F_MOR=
E
> + * turned off to allow the network to see MSG_MORE deasserted.
> + */
> +static ssize_t splice_from_pipe_zero(struct pipe_inode_info *pipe,

David, STOP.

Stop doing these crazy hacks to generic splice code. None of this makes sen=
se.

Those zero-sized splices have never worked, don't try to make them work.

The splice() system call has always had that

        if (!len)
                return 0;

since being introduced. We're not adding any crazy stuff now.

Do what I already suggested: making SPLICE_F_MORE reflect reality.

Or don't do anything at all. Because this kind of hacky garbage is not
even amusing.

               Linus

