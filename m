Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F14531E87
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 00:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiEWWUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 18:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiEWWT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 18:19:59 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D9C8AE6E;
        Mon, 23 May 2022 15:19:58 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id v6so10573543qtx.12;
        Mon, 23 May 2022 15:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gJZ2EuLHOSL7PCIwr5z5Y+h7/+WPPg4E4J2oaC866W0=;
        b=YOhTG9Ri+JSXgF8K3bxkJJMTZoQjAypQHSslGCYguNA6W8rpjSOwWWVHglqoOLfziX
         OuLbVtzWsjllk5FikzcX2UBujPLKCT5mRUBdbFg8cLydNboLaQV2DoPWN46Usx3FIAr/
         rDS7PSBsOUGSbWVRg+niu8IHtlsriMje8IAn1U03HOvcozseYUBlpWNqQMewEqkJ26F2
         0hZchk06w+preD1pH0L50nHWB1MpFLj6ggYVd2p3Ck8Pu+AM9D6kfCVfJdLPKQ3z+w5J
         hHKf8yfNx8UJlZ5q/yFd2IfnhPVznGO3MEWWEHx2KwsvHTk9KG5zdW7Gz/+L9pjmlCiI
         NzsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gJZ2EuLHOSL7PCIwr5z5Y+h7/+WPPg4E4J2oaC866W0=;
        b=l+08hfH2Dfk4ioRz07Mzd/ZmE8O9t2hqiTwR5pQ3jc8NNPYBqWIZqMkyti7aaRExyK
         qu96DecPDKYFDJY6eOdJPVVvUzJIVmy56wfC/oQhrr5oh5ulJpjB7uSp5OSxVyJxZCSN
         c4/3tiqg+9JGfvVj077HClGLfQc0402BbPQjcw9HxUT1JanYMTEp/ouLccBAHqE2LMR/
         iKWBh8ANfI1n35h5Q+db5vyshauTNsdWgzsLwXwib3hZIPoOIhCAd7u+7GUMi+1aLoeF
         ku/y2siDcvYWCn2M9ItMeBh2ExdYo1pwBDEHoXHqsfJrqnlTTd8DX+nBajKzE8OrvleG
         IGLg==
X-Gm-Message-State: AOAM531TZRPBfTL/dix0J5RL+r0lqjJgq2zHAKNdK0IDwlxZJRW3EucI
        tf8gVDC/fFRfxuPs6G8LOc4H3ffMG3DjYg==
X-Google-Smtp-Source: ABdhPJz1VHWenGd2tI7aaPHAkuYo+GbZjISx0sNKVm0XqQY2LBg7NKQIeqn7HLtSUZeJLVvzaiUFBg==
X-Received: by 2002:a05:622a:4ce:b0:2f9:3e6e:475 with SMTP id q14-20020a05622a04ce00b002f93e6e0475mr2344654qtx.469.1653344397807;
        Mon, 23 May 2022 15:19:57 -0700 (PDT)
Received: from jup ([2607:fea8:e2e4:d600::6ece])
        by smtp.gmail.com with ESMTPSA id e18-20020ac84e52000000b002f936bae288sm3106792qtw.87.2022.05.23.15.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 15:19:57 -0700 (PDT)
Date:   Mon, 23 May 2022 18:19:54 -0400
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
Message-ID: <20220523221954.dsqvy55ron4cfdqq@jup>
References: <20220523202649.6iiz4h2wf5ryx3w2@jup>
 <CAEf4BzaecP2XkzftmH7GeeTfj1E+pv=20=L4ztrxe4-JU7MuUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaecP2XkzftmH7GeeTfj1E+pv=20=L4ztrxe4-JU7MuUw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 03:02:31PM -0700, Andrii Nakryiko wrote:
> On Mon, May 23, 2022 at 1:26 PM Michael Mullin <masmullin@gmail.com> wrote:
> >
> > When generating a skeleton which has an mmaped map field, bpftool's
> > output is missing the map structure.  This causes a compile break when
> > the generated skeleton is compiled as the field belongs to the internal
> > struct maps, not directly to the obj.
> >
> > Signed-off-by: Michael Mullin <masmullin@gmail.com>
> > ---
> >  tools/bpf/bpftool/gen.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > index f158dc1c2149..b49293795ba0 100644
> > --- a/tools/bpf/bpftool/gen.c
> > +++ b/tools/bpf/bpftool/gen.c
> > @@ -853,7 +853,7 @@ codegen_maps_skeleton(struct bpf_object *obj, size_t map_cnt, bool mmaped)
> >                         i, bpf_map__name(map), i, ident);
> >                 /* memory-mapped internal maps */
> >                 if (mmaped && is_internal_mmapable_map(map, ident, sizeof(ident))) {
> > -                       printf("\ts->maps[%zu].mmaped = (void **)&obj->%s;\n",
> > +                       printf("\ts->maps[%zu].mmaped = (void **)&obj->maps.%s;\n",
> 
> That's not right. maps.my_map is struct bpf_map *, but mmaped is
> supposed to be a blob of memory that is memory-mapped into map.
> 
> Can you elaborate on how you trigger that compilation error with a
> small example?

I have an a very small example on github. I have added some sed fixes to
my Makefile make my sample program compile.
https://github.com/masmullin2000/libbpf-sample/tree/main/c/simple

https://github.com/masmullin2000/libbpf-sample/tree/02c7f945bf9027daedec04f485a320ba2df28204/c/simple
contains broken code.

I apologize if this is an incorrect way to share external code.  I
haven't found the proper way to share example code from
kernelnewbies.org

> 
> >                                 i, ident);
> >                 }
> >                 i++;
> > --
> > 2.36.1
> >
