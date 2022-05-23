Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7330A531E4E
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 00:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiEWWCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 18:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiEWWCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 18:02:44 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB695EBF1;
        Mon, 23 May 2022 15:02:43 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id ay20so619655vkb.5;
        Mon, 23 May 2022 15:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mf9t72ThhbpA2cfOgFGg3CPfhzKOqoIL1OVdalzrcJc=;
        b=KuSe/vKJ+o8EsjXPV6K/z/8ZiIeXF5t68EmozAlHSHhgfRg8zZXNqUPQu+8q2Zz+mh
         fZrLKt6lsesmonlIOjCEDsmxg1bkLOkeovuxUKIon3yuetp73NSUOG7DWmcaA8P5wxmG
         NQeWwJjoix8ZeytR40/zFklWOWeSuQKbkF1Dgosmb7LWCtFm0eZFHFIf11zx2dwlpzf8
         slSQX0snt9rFDCEGk+8+dHEPZBG5Iw0iwyjo+Y1Zp1Zk4yJkI2oyPnI9cWhNVLuXREJF
         /xD16nRKbLOlMP8o6gvabwmDaUSSeXMseX7BrK7LZHdMC2nNxj56kgxgOPb+Nyfb3xrH
         bI8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mf9t72ThhbpA2cfOgFGg3CPfhzKOqoIL1OVdalzrcJc=;
        b=lAdGEe9urZgbZcH9O5JljWZiOT9Xq3wNh0yz33yh3OYMZNSq/5BA5WJToiwnXB8jmq
         0a4V+QqXK41u5uS1C86A2jzeeyUFVoCBiPubf8kqdoY00RlEbJv5PVsZREqXsbvM5r/U
         PfTLzea8gQMQMVvKBoS37S0sYdydnDUGCU3Px5BpsJZSJ4cJLzK320kIvX1EMiZ6XfEJ
         7PtPOkg0aKnjRsK2mIIn8eoHDqgQ8q28+r7Vlzd+AG70CZmGeSmbyd15UGxJ0Rhe7x8Y
         7yjMtjtoQMQ8pSS4qVW2k4tfT7ERHK5FNyVQSnXV0RiRZCc6/IzRYgj4IdMZK2aBJc4w
         f7Sg==
X-Gm-Message-State: AOAM532QWr9ODoFGfep+MvAyKP0H6b6zxOuxp+SHQMspfAaCUXD1cPVy
        YBxSKhLVXu9DX5RtwAD8pUenDlGGnGrLCINCFp4/If06
X-Google-Smtp-Source: ABdhPJyDALo0aTAeiL0swPHhoTBPFNrITCPp91n+PKmu1hFyeVAXps80/SmoBxeqUz00AKI4VcJknzgGavFC8o5pX6U=
X-Received: by 2002:a1f:a748:0:b0:357:d811:a36 with SMTP id
 q69-20020a1fa748000000b00357d8110a36mr1481404vke.2.1653343362701; Mon, 23 May
 2022 15:02:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220523202649.6iiz4h2wf5ryx3w2@jup>
In-Reply-To: <20220523202649.6iiz4h2wf5ryx3w2@jup>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 15:02:31 -0700
Message-ID: <CAEf4BzaecP2XkzftmH7GeeTfj1E+pv=20=L4ztrxe4-JU7MuUw@mail.gmail.com>
Subject: Re: [PATCH] bpftool: mmaped fields missing map structure in generated skeletons
To:     Michael Mullin <masmullin@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Mon, May 23, 2022 at 1:26 PM Michael Mullin <masmullin@gmail.com> wrote:
>
> When generating a skeleton which has an mmaped map field, bpftool's
> output is missing the map structure.  This causes a compile break when
> the generated skeleton is compiled as the field belongs to the internal
> struct maps, not directly to the obj.
>
> Signed-off-by: Michael Mullin <masmullin@gmail.com>
> ---
>  tools/bpf/bpftool/gen.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index f158dc1c2149..b49293795ba0 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -853,7 +853,7 @@ codegen_maps_skeleton(struct bpf_object *obj, size_t map_cnt, bool mmaped)
>                         i, bpf_map__name(map), i, ident);
>                 /* memory-mapped internal maps */
>                 if (mmaped && is_internal_mmapable_map(map, ident, sizeof(ident))) {
> -                       printf("\ts->maps[%zu].mmaped = (void **)&obj->%s;\n",
> +                       printf("\ts->maps[%zu].mmaped = (void **)&obj->maps.%s;\n",

That's not right. maps.my_map is struct bpf_map *, but mmaped is
supposed to be a blob of memory that is memory-mapped into map.

Can you elaborate on how you trigger that compilation error with a
small example?

>                                 i, ident);
>                 }
>                 i++;
> --
> 2.36.1
>
