Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DAC4C9D95
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 06:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239640AbiCBFrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 00:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbiCBFrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 00:47:16 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2E3B18A2;
        Tue,  1 Mar 2022 21:46:34 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id i11so719764eda.9;
        Tue, 01 Mar 2022 21:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ju1hFzCBSx147XTyPzHG3qmNTxLyCXpzXti14uOg3Zw=;
        b=XQF+mq2xUo6VNixetWdZ1ah04YUZjzhSzra/CYRofSGJDE9oyqxQuOsZ2aUlKxVCUK
         upIwsYaFU/7tAgmruY53YzGBr+StWr+B9KHUo9cqkRL2cuHRfwHwTcy82cYaMpl3HTpH
         P0BG3FHsuxSd/Xkrhm9wVVh9j+nwICAzyorT1NVBqF+eAPZrKpQQvMjr1olL9YgtjdbQ
         bdurXInJVclLC4K5jxGfbX3AZjf5gxXCwr7kPEaHMMIRz9I8KgpAFaQl1J0Ja5HB4smK
         OeXCLZCc11TNtROxRT6zvHWmHwF7yvMErvmyyxY3sSj3vMvOHY0DSlRA2YuUhN3HC0q1
         Lzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ju1hFzCBSx147XTyPzHG3qmNTxLyCXpzXti14uOg3Zw=;
        b=7v9W0JwB7zNHw0abOWM1d45u2mJsIsQqElN9/pZ9wZCec0fSHKOaXHLMri5vtxxxCk
         YOKYindtSjJMC84gIN7Ijjuvu1C+brhhTk4tcjS70Vl5UhNIczy/XJ7hsqgehUmYzaOc
         014ek/oEVDFKIZR6dYTM5I7CbeOR1L6+3A6ML1EJUfuVuh34iF6PQcOfPG/61m+FcJuG
         qKs7eMqTHQlwLaUgohH5SM+ZwTnjyFwuc2Nl4Hf3xpqXkIDoHrBEOBqJa52AyK9w1gTP
         ikZ4I2jnXpJRw+Nv12JSSEPukSfNGmYYZ+QKwB2VsP6uep6ZTQKxvvyfa538Eup2xS4s
         7wEA==
X-Gm-Message-State: AOAM530opk/+Dg9YusxLR5HSf3ewimchcJDrS2jjicrK3h1qEMTnle2L
        M+XnkT8I1pF/p1KHnTXO4R99SKNlC3nMuNiT95lUoA8ERt0=
X-Google-Smtp-Source: ABdhPJytECZlniE35uFfJSbPDZN0wge61h9/VBUAoayESw7OZkGGA6NQylxJFClTJ/9x3nWvWshmwHeuXwBl7OsJPYk=
X-Received: by 2002:a05:6402:5304:b0:413:8a0c:c54a with SMTP id
 eo4-20020a056402530400b004138a0cc54amr19691262edb.172.1646199992679; Tue, 01
 Mar 2022 21:46:32 -0800 (PST)
MIME-Version: 1.0
References: <20220227134009.1298488-1-dzm91@hust.edu.cn> <d4bed569-d448-8b59-0774-c036e4c9abe9@iogearbox.net>
In-Reply-To: <d4bed569-d448-8b59-0774-c036e4c9abe9@iogearbox.net>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 2 Mar 2022 13:46:04 +0800
Message-ID: <CAD-N9QUptT_h4FtjPTNyc72jrUHW0R_-Ggf3R1V3Fsz4hoyuAw@mail.gmail.com>
Subject: Re: [PATCH] bpf: cgroup: remove WARN_ON at bpf_cgroup_link_release
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        syzkaller <syzkaller@googlegroups.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Wed, Mar 2, 2022 at 12:28 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 2/27/22 2:40 PM, Dongliang Mu wrote:
> > From: Dongliang Mu <mudongliangabcd@gmail.com>
> >
> > When syzkaller injects fault into memory allocation at
> > bpf_prog_array_alloc, the kernel encounters a memory failure and
> > returns non-zero, thus leading to one WARN_ON at
> > bpf_cgroup_link_release. The stack trace is as follows:
> >
> >   __kmalloc+0x7e/0x3d0
> >   bpf_prog_array_alloc+0x4f/0x60
> >   compute_effective_progs+0x132/0x580
> >   ? __sanitizer_cov_trace_pc+0x1a/0x40
> >   update_effective_progs+0x5e/0x260
> >   __cgroup_bpf_detach+0x293/0x760
> >   bpf_cgroup_link_release+0xad/0x400
> >   bpf_link_free+0xca/0x190
> >   bpf_link_put+0x161/0x1b0
> >   bpf_link_release+0x33/0x40
> >   __fput+0x286/0x9f0
> >
> > Fix this by removing the WARN_ON for __cgroup_bpf_detach.
> >
> > Reported-by: syzkaller <syzkaller@googlegroups.com>
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> >   kernel/bpf/cgroup.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 514b4681a90a..fdbdcee6c9fa 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -896,8 +896,8 @@ static void bpf_cgroup_link_release(struct bpf_link *link)
> >               return;
> >       }
> >
> > -     WARN_ON(__cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
> > -                                 cg_link->type));
> > +     __cgroup_bpf_detach(cg_link->cgroup, NULL, cg_link,
> > +                                 cg_link->type);
>
> "Fixing" by removing WARN_ON is just papering over the issue which in this case as
> mentioned is allocation failure on detach/teardown when allocating and recomputing
> effective prog arrays..

Hi Daniel,

you're right. This is not a good fix, any idea to fix the underlying
bug perfectly?

>
> >       cg = cg_link->cgroup;
> >       cg_link->cgroup = NULL;
> >
>
