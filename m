Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77FDD6D5EC4
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbjDDLOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234639AbjDDLOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:14:33 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB7C1FEA;
        Tue,  4 Apr 2023 04:14:32 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id cf7so38212021ybb.5;
        Tue, 04 Apr 2023 04:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680606872;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gVo5EF32hJ+j6zLMjucS/chjw/jsmoSQqHwPbkJqces=;
        b=LwsfY1OtmyxDYjVpbBC59BNM9J4LMypl3khFXHuBY6BEJtuHWVF6eb2F/OPKgnEv7J
         Fs7PmMuNKaVneD5uzcgczfMORk+rFTjGoJQYf5WGXdZI7yJ4ItoMZTwSplPFDvwkiqgx
         A2InUYXJUwyh3pMRhwCIzGpMA9hTMDKGc26zJkwrcVsupUyt/7sfz2PT/FL6FH1Z+VHz
         KGG2Z97W0knDhGwhVejX7yzguE0y1XYMjXcMH7cdhcbsr79czyq+9xQXV5grW21dHA+o
         MBZRSP/41aOgP4ZMKpwvTLlofI3hdYR4x98u55XVjt33ZLqI73CsIeQ5WIQ05Yokm5IH
         1TOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680606872;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gVo5EF32hJ+j6zLMjucS/chjw/jsmoSQqHwPbkJqces=;
        b=ZGEUMW2hKo8XH6nATnOpH1yHiEmXWEwovl35dmP4jHOAKWtWGycxG20VtmFc9R8JCI
         WHfOqzxqwSwL4PaCHgbomVWTxgxm9bgLvUiHEGXtQPvvGtcAuNZzRnbJo3Q2xR7Lp/KL
         8chnKZBkZyQh/E1z0bhQYXxHamvqkdaEP4nlUIyF446Osm8cgOQLeRFHTecmkPjSQ/IT
         L99FFduviVtsLr61FAfexPMKW9XJdnyYcEVtfOs6VQ4BFYrwM63ZVND1H5211qxgus2z
         90kLo5nYlgF+iBYus0QfsDlMLP27cF6Jy19hPiWDzRpCqhS4HbQz/OwmZoz5Ec/+Zexe
         Q29w==
X-Gm-Message-State: AAQBX9cc/TTIXy5ypZS6G9XirxIuZi6xgPeqf4o93+lBiZTODO3F6ovi
        ITUggykc2Yzb8fDN0MlLJe4lV98xjtgATyTKqJ0=
X-Google-Smtp-Source: AKy350ajqq6A6l3G1blkn41jMC3CgA2eNIYkGbCOtvTg3xkmiJb332SKKTLe/F1mb8l+wuNsQquw2GNKsidWLkExD3A=
X-Received: by 2002:a25:c401:0:b0:b76:ae61:b68b with SMTP id
 u1-20020a25c401000000b00b76ae61b68bmr1379110ybf.5.1680606871742; Tue, 04 Apr
 2023 04:14:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230329180502.1884307-1-kal.conley@dectris.com>
 <20230329180502.1884307-9-kal.conley@dectris.com> <CAJ8uoz330DWzHabpqd+HaeAxBi2gr+GOTtnS9WJFWrt=6DaeWQ@mail.gmail.com>
 <CAHApi-nfBM=i1WeZ-jtHN87AWPvURo0LygT9yYxF=cUeYthXBQ@mail.gmail.com>
 <CAJ8uoz0SEkcXQuoqYd94GreJqpCxQuf1QVgm9=Um6Wqk=s8GBw@mail.gmail.com> <CAHApi-=ui3JofMr7y+LvuYkXCU=h7vGiKXsfuV5gog-02u-u+Q@mail.gmail.com>
In-Reply-To: <CAHApi-=ui3JofMr7y+LvuYkXCU=h7vGiKXsfuV5gog-02u-u+Q@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 4 Apr 2023 13:14:20 +0200
Message-ID: <CAJ8uoz0GgzzfrgS0189=zwY-zzogZq+=v-NCY7O+RuWrwe1n6w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 08/10] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     Kal Cutter Conley <kal.conley@dectris.com>
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
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Apr 2023 at 12:29, Kal Cutter Conley <kal.conley@dectris.com> wrote:
>
> > > > Is not the max 64K as you test against XDP_UMEM_MAX_CHUNK_SIZE in
> > > > xdp_umem_reg()?
> > >
> > > The absolute max is 64K. In the case of HPAGE_SIZE < 64K, then it
> > > would be HPAGE_SIZE.
> >
> > Is there such a case when HPAGE_SIZE would be less than 64K? If not,
> > then just write 64K.
>
> Yes. While most platforms have HPAGE_SIZE defined to a compile-time
> constant >= 64K (very often 2M) there are platforms (at least ia64 and
> powerpc) where the hugepage size is configured at boot. Specifically,
> in the case of Itanium (ia64), the hugepage size may be configured at
> boot to any valid page size > PAGE_SIZE (e.g. 8K). See:
> https://elixir.bootlin.com/linux/latest/source/arch/ia64/mm/hugetlbpage.c#L159

So for all practical purposes it is max 64K. Let us just write that then.

> >
> > > > >  static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
> > > > >  {
> > > > > +#ifdef CONFIG_HUGETLB_PAGE
> > > >
> > > > Let us try to get rid of most of these #ifdefs sprinkled around the
> > > > code. How about hiding this inside xdp_umem_is_hugetlb() and get rid
> > > > of these #ifdefs below? Since I believe it is quite uncommon not to
> > > > have this config enabled, we could simplify things by always using the
> > > > page_size in the pool, for example. And dito for the one in struct
> > > > xdp_umem. What do you think?
> > >
> > > I used #ifdef for `page_size` in the pool for maximum performance when
> > > huge pages are disabled. We could also not worry about optimizing this
> > > uncommon case though since the performance impact is very small.
> > > However, I don't find the #ifdefs excessive either.
> >
> > Keep them to a minimum please since there are few of them in the
> > current code outside of some header files. And let us assume that
> > CONFIG_HUGETLB_PAGE is the common case.
> >
>
> Would you be OK if I just remove the ones from xsk_buff_pool? I think
> the code in xdp_umem.c is quite readable and the #ifdefs are really
> only used in xdp_umem_pin_pages.

Please make an effort to remove the ones in xdp_umem.c too. The more
ifdefs you add, the harder it will be to read.
