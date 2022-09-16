Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCF55BB390
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 22:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiIPUfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 16:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIPUfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 16:35:41 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5229FDDE;
        Fri, 16 Sep 2022 13:35:40 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id b23so18309128iof.2;
        Fri, 16 Sep 2022 13:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=E/eHaXadKYRfEPHdHJj7a6e9LfvJSW3hiZL/ARWnO4I=;
        b=lGkpYK7fcoe0Jl0Q2cWT6stE8XfrhvuvnI4LmdCcWvylFApkYbIJjR9MmZM+fyaLym
         Tb8QM/m2Yvl5urFxtJkIcOpZY5/404SjcI7acX524FeR+4Mm38YpQxv0rr62l7mloS70
         JDn/PZ4eXq9sZjYY7C0J51zIlt0PuCfPIMvCf8ZMyFqRu5M3Le6QXRiLd3L3idIbg7Ts
         /EmI+vhpdk3EM7Ga746GspENyfYwbb/qM+E0KKuB5/NQN73uGY1aezNjOCfc4SoFnVlC
         EhciUvfapMm0rYSnfMh8vWvUdsWoqdTcGR+zX4hzpXqAxTpNpQsnm6jpGe4x5ZolzCV+
         ot4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=E/eHaXadKYRfEPHdHJj7a6e9LfvJSW3hiZL/ARWnO4I=;
        b=cTLTQIMC3iq7AJxOCcDCn5TpCKSKiVW31hECt0cQzATEIOgVgsOhUoOM//u43rGEC2
         piRUXdi4uFqN3P+EsMCTgHNRZKkontu6vjxIdrKsbwuHtbusfmLHmO/q/tjpYu9XF4D/
         FhgOXKqEdeDIm9ZwU1Hg64aWBxgjOQYRoxi/eoRbqEhvYQQAuMKx5LiGJrH1RF9N+5LG
         b362/GVNijBkUL3gfpTgE7bbo79mmsV7Y1YG9ec3tuLtI8jTgordcdObEeswL1Og6Va9
         NMFMvi/jAPi4EVMucq5mRVmVJJNCbytvf8+KgrKUzk3RMTYStgLyD6NB3252t2lrM0Z8
         5R9w==
X-Gm-Message-State: ACrzQf0XFP+A1K2P3ntrUAnyBmZp169zlcV2Rx5ZpHXZlfq8xTxQE7AL
        dZyqbf8ZjIVh2OFI7bOT6g3qiOs6m6m9+j9OTqzWqVPC
X-Google-Smtp-Source: AMsMyM4z/DMdvQAaP+Q0O6xcOpsAIzmSo6lMYeSNHWEJ+Y4htQzZZ/0svXcH1kQgtdxA711Q4OnFlvRW5JJC8Ph9f5M=
X-Received: by 2002:a05:6602:2e88:b0:6a1:6d80:cff5 with SMTP id
 m8-20020a0566022e8800b006a16d80cff5mr2670331iow.168.1663360539564; Fri, 16
 Sep 2022 13:35:39 -0700 (PDT)
MIME-Version: 1.0
References: <c4cb11c8ffe732b91c175a0fc80d43b2547ca17e.1662920329.git.dxu@dxuuu.xyz>
 <ada17021-83c9-3dad-5992-4885e824ecac@linux.dev>
In-Reply-To: <ada17021-83c9-3dad-5992-4885e824ecac@linux.dev>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 16 Sep 2022 22:35:03 +0200
Message-ID: <CAP01T74=btUEPDrz0EVm9wNuMmbbqc2wRvtpJ-Qq45OtasMBZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Move nf_conn extern declarations to filter.h
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Sept 2022 at 22:20, Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 9/11/22 11:19 AM, Daniel Xu wrote:
> > We're seeing the following new warnings on netdev/build_32bit and
> > netdev/build_allmodconfig_warn CI jobs:
> >
> >      ../net/core/filter.c:8608:1: warning: symbol
> >      'nf_conn_btf_access_lock' was not declared. Should it be static?
> >      ../net/core/filter.c:8611:5: warning: symbol 'nfct_bsa' was not
> >      declared. Should it be static?
> >
> > Fix by ensuring extern declaration is present while compiling filter.o.
> >
> > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> > ---
> >   include/linux/filter.h                   | 6 ++++++
> >   include/net/netfilter/nf_conntrack_bpf.h | 7 +------
> >   2 files changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 527ae1d64e27..96de256b2c8d 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -567,6 +567,12 @@ struct sk_filter {
> >
> >   DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
> >
> > +extern struct mutex nf_conn_btf_access_lock;
> > +extern int (*nfct_bsa)(struct bpf_verifier_log *log, const struct btf *btf,
> > +                    const struct btf_type *t, int off, int size,
> > +                    enum bpf_access_type atype, u32 *next_btf_id,
> > +                    enum bpf_type_flag *flag);
>
> Can it avoid leaking the nfct specific details like
> 'nf_conn_btf_access_lock' and the null checking on 'nfct_bsa' to
> filter.c?  In particular, this code snippet in filter.c:
>
>          mutex_lock(&nf_conn_btf_access_lock);
>          if (nfct_bsa)
>                  ret = nfct_bsa(log, btf, ....);
>         mutex_unlock(&nf_conn_btf_access_lock);
>
>
> Can the lock and null check be done as one function (eg.
> nfct_btf_struct_access()) in nf_conntrack_bpf.c and use it in filter.c
> instead?

Don't think so, no. Because we want nf_conntrack to work as a module as well.
I was the one who suggested nf_conn specific names for now. There is
no other user of such module supplied
btf_struct_access callbacks yet, when one appears, we should instead
make registration of such callbacks properly generic (i.e. also
enforce it is only for module BTF ID etc.).
But that would be a lot of code without any users right now.

>
> btw, 'bsa' stands for btf_struct_access? It is a bit too short to guess ;)
>
> Also, please add a Fixes tag.
>

Agreed. Daniel, can you address the remaining two points from Martin and respin?
