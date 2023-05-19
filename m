Return-Path: <netdev+bounces-4033-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F0C70A2DA
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 00:38:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB6C6281CC9
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 22:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0FFA34;
	Fri, 19 May 2023 22:38:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB3E638
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 22:38:17 +0000 (UTC)
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEBA1BD;
	Fri, 19 May 2023 15:38:16 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id a1e0cc1a2514c-783f7e82f28so1173122241.1;
        Fri, 19 May 2023 15:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684535895; x=1687127895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qbwYVql1QIgBgS5uP0bWV9Ip2GirXHgk1wEAxdpCsvU=;
        b=Aw9UK0Qnz6yA00ZAdBL8N2w7D8NUmQnlAbudWjTvA8cqrV5uY1aymOE6d2r5JVZJUV
         VJLzH14Io7IiLsaswK2rA91pyqhIZq5u4tqUPteFTXkr4LSmH3YmnZS0ZDu9ef0m49V/
         b/YMmJ0t+cZYyvXLiYSW5buVGero7QXURBN+w+a8hOzgAhmgzK7tezn7IlbtQ9xBB9C3
         uv0zbgS/zzUbaXAz2a0xKxnTmmNecYU4LdbJLWSTs7SAr1G2De1qF5yvhvO3g++f4LUP
         q5XIUgpd+dW8HGz7VQDoOnnKsfnW1+Fl2Kqm8WJ87pgZjLbuf3nrF126aVuwLlGhL6yu
         2uXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684535895; x=1687127895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qbwYVql1QIgBgS5uP0bWV9Ip2GirXHgk1wEAxdpCsvU=;
        b=bC3q+8cya+loixQKbsJ/Ny/QHfsKb+IO9jtI9NVYQrALruadROOJXmqXB55pGQiGSq
         Kib9ckOLpO4710cbYFmOV4aw3i24+B9LqmLAhyJWWKNiS0wKAduPFeB8sL7qY5mepTGN
         3MXBogii5lxIYN3s69cnEATnGdorS+ae23B0+stv6G5WLfdD5s/zmUw2DaMIDGcDY5K8
         UoMOecasU4XkZWX6IyWVZwQ3g4Zegn+dA9cjhBTPor+he7q6+oiDJlmFiRd4jgGDOkF9
         /umZ+l7f+ZCVtBAFuXwrwAbE6VpZYj0t6LZ+2DgsPqr/UuWVqgFn+c4bgc/b6RMpb1+8
         tr+Q==
X-Gm-Message-State: AC+VfDwev+rJ1QJEQ2i5b3IA4/TuIbKGtCNcdWGClf3aiEAcco6gUYsH
	3gnNj5pJJtRWQzmxHDybI5nrjpuojk6j7Krg31c=
X-Google-Smtp-Source: ACHHUZ6MFBbl9p1Djo4vzwxuhjzjRUngVXdTCiAq0o7zitR/p5fEpQp0YA12uaLMpxcckxmbMn2ESj74kZtVl2Z2dDY=
X-Received: by 2002:a67:cd13:0:b0:439:31ec:8602 with SMTP id
 u19-20020a67cd13000000b0043931ec8602mr311596vsl.27.1684535895418; Fri, 19 May
 2023 15:38:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230518130713.1515729-1-dhowells@redhat.com> <20230518130713.1515729-17-dhowells@redhat.com>
 <CAF=yD-J8KGX5gjGBK6OO2SuoVa8s07Cm-oKxwmvBmRXY7XscBQ@mail.gmail.com> <2154600.1684535361@warthog.procyon.org.uk>
In-Reply-To: <2154600.1684535361@warthog.procyon.org.uk>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Fri, 19 May 2023 18:37:38 -0400
Message-ID: <CAF=yD-L1E_jHqvErrVWYofrc+R-P=+2Y1ipoxMdxuiPx5PO0JA@mail.gmail.com>
Subject: Re: [PATCH net-next v9 16/16] unix: Convert udp_sendpage() to use MSG_SPLICE_PAGES
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Chuck Lever III <chuck.lever@oracle.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Kuniyuki Iwashima <kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 6:29=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
>
> > tiny nit: subject s/udp_sendpage/unix_stream_sendpage/
>
> Can that be fixed up on application/merging, or do I need to repost the
> series?

I definitely do not mean for this to trigger a whole resubmission if
there are no other technical concerns.

Even if we don't fix it up, it's not the end of the world.

Only a hint in case there is a respin.

