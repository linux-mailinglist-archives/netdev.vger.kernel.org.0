Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5166DF7CD
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjDLN4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjDLN4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:56:08 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94197D9E;
        Wed, 12 Apr 2023 06:55:50 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-54c17fa9ae8so319591937b3.5;
        Wed, 12 Apr 2023 06:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681307750; x=1683899750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=933rqrJ5JW6xLLolSy8p/l987jO0ZQnx8xOK/Rz6sro=;
        b=nx7U8oZhzlF0AOp6y1Eods+RekUaFqPLuIZmfj/VtfuMR1usD9ckyk8fsIKTQctlRR
         yizqSV0S6KBUSdxEIf6Km8flho3enwQTh83nUMtN2Co52+Rsw3kiBqZxabqKqJSXU6oz
         riLKjD89F4/n8x5wIdmJBGzYbkIUnNCOXRKVVebc4HaCW6wvc+U4v4T24AAIXaVZCFHG
         9MYCIyPIgVYnzHEM4WuQ1kGgEjnZTQf3kyh9IQS25FfjhPyW2ThvSCmFpl/ROZMpUzb/
         5Vp+nfljNeilxTxvEY4hNfelFFpMmxFEKSDR0u7Jq/AOY0RGvDe3Gn9yVDdDWbwPyst8
         0/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681307750; x=1683899750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=933rqrJ5JW6xLLolSy8p/l987jO0ZQnx8xOK/Rz6sro=;
        b=nThmfCEMVlppficouA5LGUmqa/O0PisdqfdaF8Au02yhDK+4DNOwNxc7XDLaDFi43I
         MdG4r/RUG8UVzJ6cto0CGKaLL61mBtEY+EN1c1CrjoineZQVUcbR8DQJlSmh/YIudE4t
         26t8pVGXza6UD8DiL56w9ZShM0cY7xMrVu/KhhRhsm+iVVOU3lgNQlDJ5r2wgeu3+DW4
         idBTJ1b1JphwNaMFXo223gsApFnKwhU6oDZnjJw/AM3CfmUwo+bYvy0VIU3dNQx/6jHK
         qhVu0A0r1rKoqmamahtDvoyCPCsb6+PvDtczcpL0dDeAdwZ/QDYwPB0RAUa7lK/KgaSb
         OvXg==
X-Gm-Message-State: AAQBX9eka45ZVuGSIFFzMwLLylWrLjBbGoXjJyc0OO1Uv0o7nDFWr0+7
        KnSfra2FnPMhCaeh3x2lS3DuQl+qNsauRvxb3r8g1Y4jUHJMeJLs
X-Google-Smtp-Source: AKy350bAa0ZsGfxqwG6PFWeyb/56jhdj0mZnmhX4MEHqX0MJdVmwadEJGZF9WZDwBUFma1xppMcjKNdhQaRPMq0BVt8=
X-Received: by 2002:a81:ac5c:0:b0:54f:b2a3:8441 with SMTP id
 z28-20020a81ac5c000000b0054fb2a38441mr518540ywj.10.1681307749851; Wed, 12 Apr
 2023 06:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230406130205.49996-1-kal.conley@dectris.com>
 <20230406130205.49996-2-kal.conley@dectris.com> <87sfdckgaa.fsf@toke.dk>
 <ZDBEng1KEEG5lOA6@boxer> <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
 <875ya12phx.fsf@toke.dk>
In-Reply-To: <875ya12phx.fsf@toke.dk>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 12 Apr 2023 15:55:38 +0200
Message-ID: <CAJ8uoz0arggpZdf9KPe5+pJbq_nVJUmvVryPHuwAsqswGs1LZw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Kal Cutter Conley <kal.conley@dectris.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 at 15:40, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Kal Cutter Conley <kal.conley@dectris.com> writes:
>
> >> > > Add core AF_XDP support for chunk sizes larger than PAGE_SIZE. Thi=
s
> >> > > enables sending/receiving jumbo ethernet frames up to the theoreti=
cal
> >> > > maxiumum of 64 KiB. For chunk sizes > PAGE_SIZE, the UMEM is requi=
red
> >> > > to consist of HugeTLB VMAs (and be hugepage aligned). Initially, o=
nly
> >> > > SKB mode is usable pending future driver work.
> >> >
> >> > Hmm, interesting. So how does this interact with XDP multibuf?
> >>
> >> To me it currently does not interact with mbuf in any way as it is ena=
bled
> >> only for skb mode which linearizes the skb from what i see.
> >>
> >> I'd like to hear more about Kal's use case - Kal do you use AF_XDP in =
SKB
> >> mode on your side?
> >
> > Our use-case is to receive jumbo Ethernet frames up to 9000 bytes with
> > AF_XDP in zero-copy mode. This patchset is a step in this direction.
> > At the very least, it lets you test out the feature in SKB mode
> > pending future driver support. Currently, XDP multi-buffer does not
> > support AF_XDP at all. It could support it in theory, but I think it
> > would need some UAPI design work and a bit of implementation work.
> >
> > Also, I think that the approach taken in this patchset has some
> > advantages over XDP multi-buffer:
> >     (1) It should be possible to achieve higher performance
> >         (a) because the packet data is kept together
> >         (b) because you need to acquire and validate less descriptors
> > and touch the queue pointers less often.
> >     (2) It is a nicer user-space API.
> >         (a) Since the packet data is all available in one linear
> > buffer. This may even be a requirement to avoid an extra copy if the
> > data must be handed off contiguously to other code.
> >
> > The disadvantage of this patchset is requiring the user to allocate
> > HugeTLB pages which is an extra complication.
> >
> > I am not sure if this patchset would need to interact with XDP
> > multi-buffer at all directly. Does anyone have anything to add here?
>
> Well, I'm mostly concerned with having two different operation and
> configuration modes for the same thing. We'll probably need to support
> multibuf for AF_XDP anyway for the non-ZC path, which means we'll need
> to create a UAPI for that in any case. And having two APIs is just going
> to be more complexity to handle at both the documentation and
> maintenance level.

One does not replace the other. We need them both, unfortunately.
Multi-buff is great for e.g., stitching together different headers
with the same data. Point to different buffers for the header in each
packet but the same piece of data in all of them. This will never be
solved with Kal's approach. We just need multi-buffer support for
this. BTW, we are close to posting multi-buff support for AF_XDP. Just
hang in there a little while longer while the last glitches are fixed.
We have to stage it in two patch sets as it will be too long
otherwise. First one will only contain improvements to the xsk
selftests framework so that multi-buffer tests can be supported. The
second one will be the core code and the actual multi-buffer tests. As
for what Kal's patches are good for, please see below.

> It *might* be worth it to do this if the performance benefit is really
> compelling, but, well, you'd need to implement both and compare directly
> to know that for sure :)

The performance benefit is compelling. As I wrote in a mail to a post
by Kal, there are users out there that state that this feature (for
zero-copy mode nota bene) is a must for them to be able to use AF_XDP
instead of DPDK style user-mode drivers. They have really tough
latency requirements.



> -Toke
>
