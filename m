Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF673544104
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 03:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbiFIB1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 21:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiFIB1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 21:27:08 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730931D0BEC;
        Wed,  8 Jun 2022 18:27:07 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id c14so20447537pgu.13;
        Wed, 08 Jun 2022 18:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ohArTeXp2Pr0pB+mqZQrE4r8pT4B3GIeovN1n/X63rA=;
        b=exdSxf3DL5WbChCauJFC4GGZiaxwhBbQBCIGaFF4P90R7d4+ywvvK7IeoIDc2Ywqlh
         1DyuJWBaWFwCUS8qvjBmOqe6c2LL1IdFEMlY4jHQhe9xdkIhWAPsZco8Ci650un507Gy
         hDoe8MiFZJxjazcgsWCfbJlexoxyc/ME2O9nFT3TW5sy9ZhVu/Oj6bnrwoN5VKCVtEd/
         9Dgw1O5TCo8iwvl4ZWtsNZBKrftHTpy4hH7EiNGMHfEpCMzXEGZAUcdXKv5+H8S/Neef
         UvWm4oQURF5Y4BU/FfaXhIPxAL6Mp7ChEa1lOCiVJkA7B5erqzx+hnamHTSJlpojG6EO
         FumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ohArTeXp2Pr0pB+mqZQrE4r8pT4B3GIeovN1n/X63rA=;
        b=gRc/sqGYsmCEK1D+c9Gegc5PKNgeLlQeyjeY43SzDRFXqNjkcM86BQ8UFi77Jg2nGX
         kPwY4+r1Xy74l8e3tEAwdxJ1txc7qCxbA0hZLc4iWXh7wSom2HmQfetfXyAtW11Y507F
         vadqdAIkAr6PAqbe5z6+YNm2ND7S3zf0ulqudrSi45s4vwQXTtrFe0tB9BAXneUsgQGT
         ExVwyW9puqK2utvgPy1n4N7cdaM4J+6zUgN+DdWLTJqOkE8wq2h9blbDppDWBxFGAmic
         mwuJbLTZueylyAX4WcFP/iHx2nKmCjpog6576s/EbC8egeuOpzMjdd1SJp7B/jeudhGc
         EY4Q==
X-Gm-Message-State: AOAM533WWijHJhWVC8jDBQ9nFlKjg8wveBZeHz+d4bo5YphJE77ZvOzL
        ofgXWmwIACv8RV9HyZZYsH4=
X-Google-Smtp-Source: ABdhPJz9wKGXepMU1/1J3ARu0yAZ6GW92ZJiwFgSxeclTMKFIqtQDt4N5lJ2IA/drsS6a8qaII7iJQ==
X-Received: by 2002:a63:b51:0:b0:3fc:cd1d:884 with SMTP id a17-20020a630b51000000b003fccd1d0884mr32170542pgl.98.1654738026953;
        Wed, 08 Jun 2022 18:27:06 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g19-20020a170902869300b00163b65c9de2sm15449998plo.170.2022.06.08.18.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 18:27:06 -0700 (PDT)
Date:   Thu, 9 Jun 2022 09:26:56 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH bpf-next 0/3] move AF_XDP APIs to libxdp
Message-ID: <YqFMYNQ3utxcFGgn@Laptop-X1>
References: <20220607084003.898387-1-liuhangbin@gmail.com>
 <87tu8w6cqa.fsf@toke.dk>
 <YqAJeHAL57cB9qJk@Laptop-X1>
 <CAJ8uoz2g99N6HESyX1cGUWahSJRYQjXDG3m3f4_8APAvJNMHXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ8uoz2g99N6HESyX1cGUWahSJRYQjXDG3m3f4_8APAvJNMHXw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 12:18:14PM +0200, Magnus Karlsson wrote:
> On Wed, Jun 8, 2022 at 9:55 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> > On Tue, Jun 07, 2022 at 11:31:57AM +0200, Toke Høiland-Jørgensen wrote:
> > > Hangbin Liu <liuhangbin@gmail.com> writes:
> > >
> > > > libbpf APIs for AF_XDP are deprecated starting from v0.7.
> > > > Let's move to libxdp.
> > > >
> > > > The first patch removed the usage of bpf_prog_load_xattr(). As we
> > > > will remove the GCC diagnostic declaration in later patches.
> > >
> > > Kartikeya started working on moving some of the XDP-related samples into
> > > the xdp-tools repo[0]; maybe it's better to just include these AF_XDP
> > > programs into that instead of adding a build-dep on libxdp to the kernel
> > > samples?
> >
> > OK, makes sense to me. Should we remove these samples after the xdp-tools PR
> > merged? What about xdpxceiver.c in selftests/bpf? Should that also be moved to
> > xdp-tools?
> 
> Andrii has submitted a patch [1] for moving xsk.[ch] from libbpf to
> the xsk selftests so it can be used by xdpxceiver. This is a good idea
> since xdpxceiver tests the low level kernel interfaces and should not
> be in libxdp. I can also use those files as a start for implementing
> control interface tests which are in the planning stages. But the
> xdpsock sample shows how to use libxdp to write an AF_XDP program and
> belongs more naturally with libxdp. So good that Kartikeya is moving
> it over. Thanks!

Oh, I didn't notice this patch. I think it's a good plan.
Thanks for notify me.

Hangbin

> 
> Another option would be to keep the xdpsock sample and require libxdp
> as in your patch set, but you would have to make sure that everything
> else in samples/bpf compiles neatly even if you do not have libxdp.
> Test for the presence of libxdp in the Makefile and degrade gracefully
> if you do not. But we would then have to freeze the xdpsock app as all
> new development of samples should be in libxdp. Or we just turn
> xdpsock into a README file and direct people to the samples in libxdp?
> What do you think?
> 
> [1] https://lore.kernel.org/bpf/20220603190155.3924899-2-andrii@kernel.org/
> 
> > Thanks
> > Hangbin
