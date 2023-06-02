Return-Path: <netdev+bounces-7507-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3767207DA
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2630D1C21184
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD751332F3;
	Fri,  2 Jun 2023 16:44:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2443332E1
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:44:23 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47ABC196
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:44:21 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-5147e8972a1so3307540a12.0
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 09:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685724259; x=1688316259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzJT3HyKG2J4xiGoewlppsTGaruPJowM8pRCfo3JmUA=;
        b=dApqJ39S7kJ+spfhmbazjAu4ciZJNJh9okgwO2MURW6o9cnlP9bFbzXfFSTm6MpfF4
         Djad093jfFLRiG2RHrrBUxQ8Rw9eOvmEPy7P5PGrG905bvSKIvK9GhC3mSulV3uhmH4b
         qE/6W6pjsxfBx3mREiM4iDZy+yKW3dDaumtlE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685724259; x=1688316259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzJT3HyKG2J4xiGoewlppsTGaruPJowM8pRCfo3JmUA=;
        b=aAYcEAlsIze06FlomqnlSBLOCmRL/dEwBXDoICB3GIMUPpuHMBwVO/rjS3QePF4cou
         XaU4IFKcR4o++oDQ4KzVac0BopR7k3zNu+FYga05RlmXCYp14sFVx2bhHojgp48zmWaR
         nh+8Do9KP7/HCn5shhmEydBLgWVvLDxt0If9ftqwS5cxgIZCOgKgIRMqJnhN9HZSeHUS
         spifc+ZEmZ4NhSz+6wKULqjwa9VVBfHvlRmDey1Xv8Kw/RysA2cZvxkMvwMz2n/2XmsC
         dzJoxjg56R9OupZwtKIoJaWG0rYLP6k3a8s6DkXi/LeCICfyNSlBOCLcL7eLYTxEWCUN
         RJNA==
X-Gm-Message-State: AC+VfDwbs/FS1azi1Ggnp7jwZD8tA6KXBGL/1fO22z3+PcWf0HJpoZHZ
	NmJVdV9FDUzIINOe3uDtCPk/wfUNTOazxmn6v4W//ZjH
X-Google-Smtp-Source: ACHHUZ6eRLKxmZxH8V8/wY58igampizztcXD5pU90DDRycxpsb1fATMvJOEnVkQHGnh8HlKRcLA7KA==
X-Received: by 2002:aa7:c904:0:b0:510:db93:f034 with SMTP id b4-20020aa7c904000000b00510db93f034mr2429691edt.36.1685724259567;
        Fri, 02 Jun 2023 09:44:19 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id v15-20020aa7d9cf000000b0050bc4eb9846sm849375eds.1.2023.06.02.09.44.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 09:44:19 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-97467e06511so109932966b.2
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 09:44:19 -0700 (PDT)
X-Received: by 2002:a2e:7302:0:b0:2af:1681:2993 with SMTP id
 o2-20020a2e7302000000b002af16812993mr311009ljc.49.1685723811492; Fri, 02 Jun
 2023 09:36:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602150752.1306532-1-dhowells@redhat.com> <20230602150752.1306532-6-dhowells@redhat.com>
In-Reply-To: <20230602150752.1306532-6-dhowells@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Jun 2023 12:36:34 -0400
X-Gmail-Original-Message-ID: <CAHk-=wg-9vyvbQPy_Aa=BQmkdX7b=ANinNUU+22tMELuxmH99g@mail.gmail.com>
Message-ID: <CAHk-=wg-9vyvbQPy_Aa=BQmkdX7b=ANinNUU+22tMELuxmH99g@mail.gmail.com>
Subject: Re: [PATCH net-next v3 05/11] splice, net: Fix SPLICE_F_MORE
 signalling in splice_direct_to_actor()
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>, 
	Boris Pismenny <borisp@nvidia.com>, John Fastabend <john.fastabend@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 11:08=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Fix this by making splice_direct_to_actor() always signal SPLICE_F_MORE i=
f
> we haven't yet hit the requested operation size.

Well, I certainly like this patch better than the previous versions,
just because it doesn't add random fd-specific code.

That said, I think it might be worth really documenting the behavior,
particularly for files where the kernel *could* know "the file is at
EOF, no more data".

I hope that if user space wants to splice() a file to a socket, said
user space would have done an 'fstat()' and actually pass in the file
size as the length to splice(). Because if they do, I think this
simplified patch does the right thing automatically.

But if user space instead passes in a "maximally big len", and just
depends on the kernel then doing tha

                ret =3D do_splice_to(in, &pos, pipe, len, flags);
                if (unlikely(ret <=3D 0))
                        goto out_release;

to stop splicing at EOF, then the last splice_write() will have had
SPLICE_F_MORE set, even though no more data is coming from the file,
of course.

And I think that's fine. But wasn't that effectively what the old code
was already doing because 'read_len' was smaller than 'len'? I thought
that was what you wanted to fix?

IOW, I thought you wanted to clear SPLICE_F_MORE when we hit EOF. This
still doesn't do that.

So now I'm confused about what your "fix" is. Your patch doesn't
actually seem to change existing behavior in splice_direct_to_actor().

I was expecting you to actually pass the 'sd' down to do_splice_to()
and then to ->splice_read(), so that the splice_read() function could
say "I have no more", and clear it.

But you didn't do that.

Am I misreading something, or did I miss another patch?

               Linus

