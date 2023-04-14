Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA406E1EF1
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 11:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjDNJEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 05:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjDNJEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 05:04:14 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A835B98
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 02:04:11 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id q23so34449089ejz.3
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 02:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1681463050; x=1684055050;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BZMgCcf0+fxLcOwKjw3Au4d2n4Vk5uVRWfcU7aLG2ig=;
        b=Yn1F7CgBNrgmAxnsA0PUp8yE8phRcPg60L7TzSsR4ckDpB1PIl0PRtJdYq1TxPrIWb
         Q9NPnVFJlljDjF4yFpt5sQfTXHOYy4jCqXNqyY+kFNVgFuSyUpReYUnKauUwN46uY2Pu
         tnMyNY3fzysgj6eUFcjGlm/uMCw3IlpDr4IP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681463050; x=1684055050;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BZMgCcf0+fxLcOwKjw3Au4d2n4Vk5uVRWfcU7aLG2ig=;
        b=HJikVSxJGLFiXG/QJGoC6YROVb+TnMuzqJtHGyZfo3RjyxupehtAhZMWLHdjN2atkI
         uf7To8Q2udo3xmMugUhHzA/80W/mjs1tz6SRpRboFudDsw3WrlvH0cb9/CVcFnQyPUnZ
         +K2Lnm7/K/mE1/f9Db3RKfqI9yJwyMERIFbdhbUOOhIFm95zKW372KpbwsprTr61njol
         D+aWDOl2ZwU7iJ4kiVfK+mgsqgiJ8oQEUdbN567L0EMgxscr6yfb32KNqfz9PbvMMj2x
         N5EOUT0VijPnRIBOJ457VuZGAARPowAlG5mpa5KTmWuF3ntYxraS9lK44DIsarqn0jD6
         Kgzw==
X-Gm-Message-State: AAQBX9e/CrXHiGnBZqyvqzcFZMC9kao0IGkEV+PZUyvv4jw/VVXRtmOR
        epeJCvkyzKUshuMZWRXd4mDAYqayd35dMSCMNT92Bg==
X-Google-Smtp-Source: AKy350Y3UQEHIQfpEyvYeIjNHaxlUM9VL08op1D/9x+f0EOfp5oa424EwhbmZrhIJuNLi7Pl7M7Rw8ibVi/1mm2LGXY=
X-Received: by 2002:a17:907:3da9:b0:8f1:4cc5:f14c with SMTP id
 he41-20020a1709073da900b008f14cc5f14cmr2953696ejc.0.1681463049818; Fri, 14
 Apr 2023 02:04:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230406130205.49996-1-kal.conley@dectris.com>
 <20230406130205.49996-2-kal.conley@dectris.com> <87sfdckgaa.fsf@toke.dk>
 <ZDBEng1KEEG5lOA6@boxer> <CAHApi-nuD7iSY7fGPeMYiNf8YX3dG27tJx1=n8b_i=ZQdZGZbw@mail.gmail.com>
 <875ya12phx.fsf@toke.dk> <CAHApi-=rMHt7uR8Sw1Vw+MHDrtkyt=jSvTvwz8XKV7SEb01CmQ@mail.gmail.com>
 <87ile011kz.fsf@toke.dk> <CAHApi-m4gu8SX_1rBtUwrw+1-Q3ERFEX-HPMcwcCK1OceirwuA@mail.gmail.com>
 <87o7nrzeww.fsf@toke.dk> <CAHApi-=BcdTD7KvE0OEzYya0RmDLDBS19NgtZsESADYXbySLOQ@mail.gmail.com>
 <87edonzaac.fsf@toke.dk>
In-Reply-To: <87edonzaac.fsf@toke.dk>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Fri, 14 Apr 2023 11:08:53 +0200
Message-ID: <CAHApi-mKCmvrcKk1Q3RsTJ+28LYg3cz0cetp3TBD+bqicga28Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> "More annoying" is not a great argument, though. You're basically saying
> >> "please complicate your code so I don't have to complicate mine". And
> >> since kernel API is essentially frozen forever, adding more of them
> >> carries a pretty high cost, which is why kernel developers tend not to
> >> be easily swayed by convenience arguments (if all you want is a more
> >> convenient API, just build one on top of the kernel primitives and wrap
> >> it into a library).
> >
> > I was trying to make a fair comparison from the user's perspective
> > between having to allocate huge pages and deal with discontiguous
> > buffers. That was all.
> >
> > I think the "your code" distinction is a bit harsh. The kernel is a
> > community project. Why isn't it "our" code? I am trying to add a
> > feature that I think is generally useful to people. The kernel only
> > exists to serve its users.
>
> Oh, I'm sorry if that came across as harsh, that was not my intention! I
> was certainly not trying to make a "you vs us" distinction; I was just
> trying to explain why making changes on the kernel side carries a higher
> cost than an equivalent (or even slightly more complex) change on the
> userspace side, because of the UAPI consideration.

No problem! I agree. I am just somewhat confused by the "slightly more
complex" view of the situation. Currently, packets > 4K are not
supported _at all_ with AF_XDP. So this patchset adds something that
is not possible _at all_ today. We have been patiently waiting since
2018 for AF_XDP jumbo packet support. It seems that interest in this
feature from maintainers has been... lacking. :-) Now, if I understand
the situation correctly, you are asking for benchmarks to compare this
implementation with AF_XDP multi-buffer which doesn't exist yet? I am
glad it's being worked on but until there is a patchset, AF_XDP
multi-buffer is still VAPORWARE. :-)

Now in our case, we are primarily interested in throughput and
reducing total system load (so we have more compute budget for other
tasks). The faster we can receive packets the better. The packets we
need to receive are (almost) all 8000-9000 bytes... Using AF_XDP
multi-buffer would mean either (1) allocating extra space per packet
and copying the data to linearize it or (2) rewriting a significant
amount of code to handle segmented packets efficiently. If you want
benchmarks for (1) just use xdpsock and compare -z with -c. I think
that is a good approximation...

Hopefully, the HFT crowd can save this patchset in the end. :-)

-Kal
