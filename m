Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD0C6E8C59
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbjDTIMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234040AbjDTIMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:12:34 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6D22D49;
        Thu, 20 Apr 2023 01:12:32 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 3f1490d57ef6-b94d8d530c3so143221276.0;
        Thu, 20 Apr 2023 01:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681978352; x=1684570352;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ufAhAdE0r7c7qaGNcRxtBn4ycIciFiGBaPdCDyt/jC4=;
        b=Aii4cD7KcxtBNGj6ssDzMwkXLwpZ8acVamSTcN6ZFZ12JVINgOKCVPbXp06SITukmK
         OgWW6IRFqv8dA0bn4BtD/bHrLomeLYQNjfC9wAkDbDZHtJbeM7eDZEJH9Y1tFmG3FVa5
         EgxXf6AKfPISj099CUEABAeZxP0Sth1AKwvov6EMbpbS2u9m6Uti9Y3nJP9yrQuJBZgq
         6Vj0I6mbcbIkAJTfP4dAV2Cl5c75V22LMbBYGz54ImxKyv/2fWSw8FO2nX7b6caquWKI
         cXs+AoYmVqe225Z60j2piZ5O4kklgBO508a1Nc7jAhdHKeEZmSmy9o9xa2Jq8gmE4SNm
         g+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681978352; x=1684570352;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ufAhAdE0r7c7qaGNcRxtBn4ycIciFiGBaPdCDyt/jC4=;
        b=Kzw5ggbrNJy4U3UnimiGIeIA1eQalDbceVgg6PeVSrVoI4pmrZc+HHYaEIcLTXWTzL
         r1lT5z3EV5eDLHY8uWZBoWDgNfDRz+Ke++rrGL6gXlMbKSt/NZMYqGoLYHAEFq/860tR
         kcM1bm9pcQsVWE/KHjWKMnHnlJVBQEKpNnu3ErB4auja6breOuPJ0l9y5Ztj4ooWpJjG
         KfBnCVcZAx+5pN+xAzZFyrBaRJXEAjanMvBc3hqnBcDjlFuB464CIoOI4J9UPEAlkqw+
         R0LkmB/TCfa6W2YWdVLFimHStNFaJWc84Nuzb1IRFwS+7CexC4YrdPiXsQeclQKhi+xQ
         lUpw==
X-Gm-Message-State: AAQBX9cqQdeo2Lb52elGLv5n57ZK3/NaTxHOvi11KC0q6yDoJmsRgLxI
        G2ozHX4wV8AaNts6RVm7Svq9mBM9+F4NWK7vvKisn/x+SnFVmg==
X-Google-Smtp-Source: AKy350br2VSLJGwe7XMvMryQMIcZde+pUbCFM+MFqX0o/o8o2NN/vN8gBDNkVie6wdkNcSISj1wnMJ/RBsJL/WTmjEw=
X-Received: by 2002:a81:7857:0:b0:541:664e:b5d4 with SMTP id
 t84-20020a817857000000b00541664eb5d4mr233169ywc.4.1681978352116; Thu, 20 Apr
 2023 01:12:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230418143617.27762-1-magnus.karlsson@gmail.com> <CAHApi-=_=ia8Pa23QRchxdx-ekPTgT5nYj=ktYGO4gRwP0cvCA@mail.gmail.com>
In-Reply-To: <CAHApi-=_=ia8Pa23QRchxdx-ekPTgT5nYj=ktYGO4gRwP0cvCA@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 20 Apr 2023 10:12:21 +0200
Message-ID: <CAJ8uoz3qM04VQF7FRmnVp_AZjGaPw25GJNn0ah-Jd0=eRCRsjg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/xsk: fix munmap for hugepage allocated umem
To:     Kal Cutter Conley <kal.conley@dectris.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, tirthendu.sarkar@intel.com,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 at 00:01, Kal Cutter Conley <kal.conley@dectris.com> wrote:
>
> > @@ -1286,16 +1287,19 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
> >         u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
> >         int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
> >         LIBBPF_OPTS(bpf_xdp_query_opts, opts);
> > +       off_t mmap_offset = 0;
> >         void *bufs;
> >         int ret;
> >
> > -       if (ifobject->umem->unaligned_mode)
> > +       if (ifobject->umem->unaligned_mode) {
> >                 mmap_flags |= MAP_HUGETLB;
> > +               mmap_offset = MAP_HUGE_2MB;
> > +       }
>
> MAP_HUGE_2MB should be ORed into mmap_flags. The offset argument
> should be zero for MAP_ANONYMOUS mappings. The tests may still fail if
> the default hugepage size is not 2MB.

You are correct that it should go into the flags field. Misread the
man page so will send a fix.

It was a conscious decision to require a hugepage size of 2M. I want
it to fail if you do not have it since the rest of the code will not
work if you are using some other size. Yes, it is possible to discover
what hugepage sizes exist and act on that, but I want to keep the code
simple.

> >
> >         if (ifobject->shared_umem)
> >                 umem_sz *= 2;
> >
> > -       bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
> > +       bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, mmap_offset);
> >         if (bufs == MAP_FAILED)
> >                 exit_with_error(errno);
> >
>
> -Kal
