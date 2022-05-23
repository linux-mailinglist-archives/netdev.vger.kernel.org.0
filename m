Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD63C531F1D
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 01:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiEWXJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 19:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiEWXI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 19:08:59 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FF970369;
        Mon, 23 May 2022 16:08:58 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id c1so13916330qkf.13;
        Mon, 23 May 2022 16:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RM70btlxkJMcJZU115/sfApSU8coL9mAakE0PyR/h4Y=;
        b=Z+O4x3cYzdfYcBo+qMsyV+PE4neCzLxUeNKd0uGm+7pOIGn2SvhFHXsWE5j1ADZgFM
         /9Wn6I+zqKBfX7MCQxKpCMl0c7oafuo4U0o51+RHgfcZHad66+9Vl7LCGHWIMvyZl1T/
         nHOd3iHn5hTzpKFR+Iv+UyY7KgyOtooAfntO+fJze/d7dZYoqJbbh/1NxwLBJzweXq3u
         Ewz9nL60KfNVOua+CJkMUQOKZTKdSH9NiCSx8UBFVydJNnMmsaTN9+cn27baIcMVsgG6
         mDo0hv14ycnGJszVkW27C0aali7KWXzRlgKlPb6Dew+pth3VpCO8lBWUJ/Kob/3XfZSl
         fOEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RM70btlxkJMcJZU115/sfApSU8coL9mAakE0PyR/h4Y=;
        b=dXp1xMrgNoQfVHvwozjQeQ72dxyhjOpvVlLVgfcnjI8HHsmFbsxxxfhMYod0Q6V+d0
         u+DqiSCmSC2XAVWf4bgUE9ocN5apcQjVP+E8pV/j4bTdYH1hd5Z8h5+pUDD99c49DEqy
         0NEt+gvfsJ/3Zhqkq0zg77oex2D40/Scajmox9BdrByYJnoiz6tOo0AChyQCqINavbFy
         KA4H/t7SievrKuQw4ZUqMZ6C5VMxD8M2QsoJfVrFTIKreUlaioTWJYaZKr3AoIvZUQh2
         AE8evK1h6ix3O7bROtb55m2i2lKuxOvX+tfnwXXcu8GF6ih2W9Gyn0yCLanh0uF+IXPV
         Ad3Q==
X-Gm-Message-State: AOAM531J4YlDXpqTxrdpRpHDfySu5d11/ZrxWOJrfabBOlFoZwLDqcQ0
        SPL7yz/NtZIjuOjOueREy2s=
X-Google-Smtp-Source: ABdhPJx93GEPHLMwAQ23oDH+D205VadsPlC8SagMZbgHJWaXPsONy7Omp3isK0Yt4jw+pD2Ik+JUZw==
X-Received: by 2002:a05:620a:2456:b0:6a3:769a:653e with SMTP id h22-20020a05620a245600b006a3769a653emr5997540qkn.148.1653347337363;
        Mon, 23 May 2022 16:08:57 -0700 (PDT)
Received: from jup ([2607:fea8:e2e4:d600::6ece])
        by smtp.gmail.com with ESMTPSA id c10-20020ac86e8a000000b002f3ef928fbbsm1821926qtv.72.2022.05.23.16.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 16:08:56 -0700 (PDT)
Date:   Mon, 23 May 2022 19:08:54 -0400
From:   Michael Mullin <masmullin@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpftool: mmaped fields missing map structure in
 generated skeletons
Message-ID: <20220523230854.3hdduizw36huxvxw@jup>
References: <20220523202649.6iiz4h2wf5ryx3w2@jup>
 <CAEf4BzaecP2XkzftmH7GeeTfj1E+pv=20=L4ztrxe4-JU7MuUw@mail.gmail.com>
 <20220523221954.dsqvy55ron4cfdqq@jup>
 <CAEf4BzY-K8UoT1HhXf=fwdWtY2fdprttUF27Zm6WwSUSRq8ycA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY-K8UoT1HhXf=fwdWtY2fdprttUF27Zm6WwSUSRq8ycA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 03:38:03PM -0700, Andrii Nakryiko wrote:
> On Mon, May 23, 2022 at 3:19 PM Michael Mullin <masmullin@gmail.com> wrote:
> >
> > On Mon, May 23, 2022 at 03:02:31PM -0700, Andrii Nakryiko wrote:
> > > On Mon, May 23, 2022 at 1:26 PM Michael Mullin <masmullin@gmail.com> wrote:
> > > >
> > > > When generating a skeleton which has an mmaped map field, bpftool's
> > > > output is missing the map structure.  This causes a compile break when
> > > > the generated skeleton is compiled as the field belongs to the internal
> > > > struct maps, not directly to the obj.
> > > >
> > > > Signed-off-by: Michael Mullin <masmullin@gmail.com>
> > > > ---
> > > >  tools/bpf/bpftool/gen.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > > > index f158dc1c2149..b49293795ba0 100644
> > > > --- a/tools/bpf/bpftool/gen.c
> > > > +++ b/tools/bpf/bpftool/gen.c
> > > > @@ -853,7 +853,7 @@ codegen_maps_skeleton(struct bpf_object *obj, size_t map_cnt, bool mmaped)
> > > >                         i, bpf_map__name(map), i, ident);
> > > >                 /* memory-mapped internal maps */
> > > >                 if (mmaped && is_internal_mmapable_map(map, ident, sizeof(ident))) {
> > > > -                       printf("\ts->maps[%zu].mmaped = (void **)&obj->%s;\n",
> > > > +                       printf("\ts->maps[%zu].mmaped = (void **)&obj->maps.%s;\n",
> > >
> > > That's not right. maps.my_map is struct bpf_map *, but mmaped is
> > > supposed to be a blob of memory that is memory-mapped into map.
> > >
> > > Can you elaborate on how you trigger that compilation error with a
> > > small example?
> >
> > I have an a very small example on github. I have added some sed fixes to
> > my Makefile make my sample program compile.
> > https://github.com/masmullin2000/libbpf-sample/tree/main/c/simple
> >
> > https://github.com/masmullin2000/libbpf-sample/tree/02c7f945bf9027daedec04f485a320ba2df28204/c/simple
> > contains broken code.
> 
> You are missing -g when calling clang to generate debug info (DWARF
> and subsequently BTF). When BPF object file doesn't have BTF, we don't
> generate those bss/data/rodata/etc sections of the skeleton. You
> should be good just by adding -g.
> 

Thank you. By using -g, I am also unable to trigger the segfault
I was trying to fix with the patch
https://lore.kernel.org/bpf/20220523194917.igkgorco42537arb@jup/T/#u

I am not sure if there would be other ways to trigger the segfault.

> >
> > I apologize if this is an incorrect way to share external code.  I
> > haven't found the proper way to share example code from
> > kernelnewbies.org
> >
> > >
> > > >                                 i, ident);
> > > >                 }
> > > >                 i++;
> > > > --
> > > > 2.36.1
> > > >
