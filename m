Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA47B6E4751
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjDQMN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjDQMNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:13:55 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A395D4EF1;
        Mon, 17 Apr 2023 05:13:20 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id j15so4428007ybl.10;
        Mon, 17 Apr 2023 05:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681733598; x=1684325598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SHhPz+EuIXTc1mVy+d6/xeEAaq2+DiiC9QI7fkSBxRM=;
        b=BbNpNiGbmO3q3OE3llCQvT+0cvIcVVESgUqwP8dut5rK3te/4mV2aRs5xtYkhQvdru
         iGRFHuEBEWCe//1QQNQLiUimO7oiSF4ir2Htu2JU6CmiYEafd+gXthH/+zfYPXh/t7h5
         9NLD++wSaozK12jZ8chWzGHWcsLsKfJct47lB5Xb1F4MfkF7BwkwpIDl7MhBbUeW/M3B
         npoj13RyjRsdrMbuvc3KzJT1ZIMl9ykYe5tbccpAht/h2ipRndQ1/5f68DI8YX2Qs17I
         hE5aoarx/cm8AKuRLp57e6Dnme68istUazyQVeRZdsGnfZkSXKQrWDDP0e9WaAsOv3H5
         oRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681733598; x=1684325598;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SHhPz+EuIXTc1mVy+d6/xeEAaq2+DiiC9QI7fkSBxRM=;
        b=f6yjL6GyHXhP/MI2aa90uMnB0h/pYFhFhIYlzWMFHL240OhvQHqUebhPBKuf09OXiL
         DvyzOMeleAwNzSppCF6fN8elIxXkGpq07o2xpBQRii8xx7FhOhsrBLFeb7Y+8w4rh4lY
         QGAu4enB3bY4hVAYF5a4/5WaL6ripMAEvWf3mmm9oD47KDs5anS9r/ld3e2ew8v9pfT2
         ffBvq1oT6KHGe37sVEbiYKZyDFzK5BD6fwgMMpT7FrumHOLu2/ssdjOPjHY+X/IgjnXh
         L49KYa6nWulUB//4eoW2MW0unCjxEum4IjGFIUa5YD+LH5Ia4jBNV516hrO632FniJ2f
         nJaw==
X-Gm-Message-State: AAQBX9ed9/C3v1va5mGOqIaneLgJmZ/zS5ej810aEKlwYl35GlF0h+Tu
        9FQz4ceo89dRdE07aHLCmc+WR4uqu1wzQ0dVGD0=
X-Google-Smtp-Source: AKy350Zi96A5jujccZMknsThLjiF44PbqWdaH/fiFQYsDPOOiQsU6l9PuK4H5Co6mSVausbSA2EP4+TyOAKnpjlS0fg=
X-Received: by 2002:a25:da0b:0:b0:b8f:6f3f:ed20 with SMTP id
 n11-20020a25da0b000000b00b8f6f3fed20mr7039281ybf.5.1681733597805; Mon, 17 Apr
 2023 05:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230406130205.49996-1-kal.conley@dectris.com>
 <20230406130205.49996-2-kal.conley@dectris.com> <87sfdckgaa.fsf@toke.dk>
 <ZDBEng1KEEG5lOA6@boxer> <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
 <875ya12phx.fsf@toke.dk> <CAHApi-=rMHt7uR8Sw1Vw+MHDrtkyt=jSvTvwz8XKV7SEb01CmQ@mail.gmail.com>
 <87ile011kz.fsf@toke.dk> <CAHApi-m4gu8SX_1rBtUwrw+1-Q3ERFEX-HPMcwcCK1OceirwuA@mail.gmail.com>
 <87o7nrzeww.fsf@toke.dk>
In-Reply-To: <87o7nrzeww.fsf@toke.dk>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 17 Apr 2023 14:13:06 +0200
Message-ID: <CAJ8uoz3Rts2Xfhqq+0cm3GES=dMb2hTqPzGm515oG_nmt=-Nbg@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 at 22:52, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Kal Cutter Conley <kal.conley@dectris.com> writes:
>
> >> Well, you mentioned yourself that:
> >>
> >> > The disadvantage of this patchset is requiring the user to allocate
> >> > HugeTLB pages which is an extra complication.
> >
> > It's a small extra complication *for the user*. However, users that
> > need this feature are willing to allocate hugepages. We are one such
> > user. For us, having to deal with packets split into disjoint buffers
> > (from the XDP multi-buffer paradigm) is a significantly more annoying
> > complication than allocating hugepages (particularly on the RX side).
>
> "More annoying" is not a great argument, though. You're basically saying
> "please complicate your code so I don't have to complicate mine". And
> since kernel API is essentially frozen forever, adding more of them
> carries a pretty high cost, which is why kernel developers tend not to
> be easily swayed by convenience arguments (if all you want is a more
> convenient API, just build one on top of the kernel primitives and wrap
> it into a library).
>
> So you'll need to come up with either (1) a use case that you *can't*
> solve without this new API (with specifics as to why that is the case),
> or (2) a compelling performance benchmark showing the complexity is
> worth it. Magnus indicated he would be able to produce the latter, in
> which case I'm happy to be persuaded by the numbers.

We will measure it and get back to you. Would be good with some numbers.

> In any case, however, the behaviour needs to be consistent wrt the rest
> of XDP, so it's not as simple as just increasing the limit (as I
> mentioned in my previous email).
>
> -Toke
>
