Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1258E6D6005
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 14:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbjDDMTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 08:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbjDDMTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 08:19:22 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7180B49C8
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 05:14:03 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t10so129540676edd.12
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 05:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680610442;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1FlXMDdCERweSivjHZ7/5B+1YGIBAwVG5BfESYtf7Lw=;
        b=YX8mzm+GaExr+LtZQZLQbjXBf1wS5hKRbNWLvbv1HjVUsM43EMylri0DSwQKzYdOPA
         niP9hMX/S7wflAS3uaIVpxFRjuTyNgSicuyHS4XSu+waAvO2edBguxqRD1aXbI5dP9mJ
         vDVmJ//mmpj6c0Mml6AJnkPMLTXJsMWBWxUpU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680610442;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1FlXMDdCERweSivjHZ7/5B+1YGIBAwVG5BfESYtf7Lw=;
        b=ZYx0cop2A8ACjGBxPKPuF4EoI0xGDYLA5Yk1hNLKCiv1/ufayIDrviBZ4zx1zDYSs9
         9Xzy8c91MIxJJvxed1+H0dGs5R2t07cHvblJMq5rvPAW91Ri99f/M64JUcu9wi/YYeDk
         oFSBZlCw055F7e3ocRqNcYpqeOGJ1rtKOBMw107ofF9k9ghV/xWtFT0+WMwI98c9NkRz
         JuxW+0QT9YSWEG1gQUEeoJrhI5J1KGc1Q1nt9/nT5e4DlBPoDm5KEfC+VxSAi5jyuvAE
         EbjWRvGqD5bVUVzMd6PqmnB+w4mNVYFkISZEw3LEtb8sqiQyEy6Rf5DrWONisbP8RjpR
         cYaQ==
X-Gm-Message-State: AAQBX9fqsKLLXeNtU7IhdF0oaIAGHyXnBDTkgdO19iAks9zxZkvVZkAz
        q5xAqPvJhneh+RcG1r6/otYoLh3Rreg6sabzV8letw==
X-Google-Smtp-Source: AKy350Z8HlCm5B54b7UZJKHACU21DJz3ku5dfDAh0DEMnERB4q/wmKmLgfyJ3uyBvPJjFhCSf597wbTe7HicdKc0qaQ=
X-Received: by 2002:a50:8d54:0:b0:4fb:7e7a:ebf1 with SMTP id
 t20-20020a508d54000000b004fb7e7aebf1mr1266924edt.6.1680610442009; Tue, 04 Apr
 2023 05:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230329180502.1884307-1-kal.conley@dectris.com>
 <20230329180502.1884307-9-kal.conley@dectris.com> <CAJ8uoz330DWzHabpqd+HaeAxBi2gr+GOTtnS9WJFWrt=6DaeWQ@mail.gmail.com>
 <CAHApi-nfBM=i1WeZ-jtHN87AWPvURo0LygT9yYxF=cUeYthXBQ@mail.gmail.com>
 <CAJ8uoz0SEkcXQuoqYd94GreJqpCxQuf1QVgm9=Um6Wqk=s8GBw@mail.gmail.com>
 <CAHApi-=ui3JofMr7y+LvuYkXCU=h7vGiKXsfuV5gog-02u-u+Q@mail.gmail.com> <CAJ8uoz0GgzzfrgS0189=zwY-zzogZq+=v-NCY7O+RuWrwe1n6w@mail.gmail.com>
In-Reply-To: <CAJ8uoz0GgzzfrgS0189=zwY-zzogZq+=v-NCY7O+RuWrwe1n6w@mail.gmail.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Tue, 4 Apr 2023 14:18:42 +0200
Message-ID: <CAHApi-kVF5dS=ym7PXttCVAz7jEod2cOhh27YYwkidCUogu6-A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 08/10] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
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
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > > Is not the max 64K as you test against XDP_UMEM_MAX_CHUNK_SIZE in
> > > > > xdp_umem_reg()?
> > > >
> > > > The absolute max is 64K. In the case of HPAGE_SIZE < 64K, then it
> > > > would be HPAGE_SIZE.
> > >
> > > Is there such a case when HPAGE_SIZE would be less than 64K? If not,
> > > then just write 64K.
> >
> > Yes. While most platforms have HPAGE_SIZE defined to a compile-time
> > constant >= 64K (very often 2M) there are platforms (at least ia64 and
> > powerpc) where the hugepage size is configured at boot. Specifically,
> > in the case of Itanium (ia64), the hugepage size may be configured at
> > boot to any valid page size > PAGE_SIZE (e.g. 8K). See:
> > https://elixir.bootlin.com/linux/latest/source/arch/ia64/mm/hugetlbpage.c#L159
>
> So for all practical purposes it is max 64K. Let us just write that then.

What about when CONFIG_HUGETLB_PAGE is not defined? Should we keep it
set to PAGE_SIZE in that case, or would you like it to be a fixed
constant == 64K always?

>
> > >
> > > > > >  static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
> > > > > >  {
> > > > > > +#ifdef CONFIG_HUGETLB_PAGE
> > > > >
> > > > > Let us try to get rid of most of these #ifdefs sprinkled around the
> > > > > code. How about hiding this inside xdp_umem_is_hugetlb() and get rid
> > > > > of these #ifdefs below? Since I believe it is quite uncommon not to
> > > > > have this config enabled, we could simplify things by always using the
> > > > > page_size in the pool, for example. And dito for the one in struct
> > > > > xdp_umem. What do you think?
> > > >
> > > > I used #ifdef for `page_size` in the pool for maximum performance when
> > > > huge pages are disabled. We could also not worry about optimizing this
> > > > uncommon case though since the performance impact is very small.
> > > > However, I don't find the #ifdefs excessive either.
> > >
> > > Keep them to a minimum please since there are few of them in the
> > > current code outside of some header files. And let us assume that
> > > CONFIG_HUGETLB_PAGE is the common case.
> > >
> >
> > Would you be OK if I just remove the ones from xsk_buff_pool? I think
> > the code in xdp_umem.c is quite readable and the #ifdefs are really
> > only used in xdp_umem_pin_pages.
>
> Please make an effort to remove the ones in xdp_umem.c too. The more
> ifdefs you add, the harder it will be to read.

OK
