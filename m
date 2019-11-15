Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0529FE2F9
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 17:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfKOQj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 11:39:59 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35259 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbfKOQj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 11:39:59 -0500
Received: by mail-pg1-f194.google.com with SMTP id k32so543658pgl.2;
        Fri, 15 Nov 2019 08:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=FRgJZkKjwQDCuu+MAnyqwDgQffBjFsnmD3AO1SRKwis=;
        b=Nz9WAnWJpIm2oTzLNJEJreH/PKjxWx1TCFIR7qC8EFdghL+jUQhkEdoWmzPJ9bJ2rO
         1F0dByAwLgovTDdlXHxsIjPP4KVrtPhieGlGJuGMlZeMalsXNv12wOHTJngYfMrsvZ2p
         HBC5wDJcORvUD9xAkdccpLLB9TkkNeiMxZtj0aDTaqo40iuykOtRcSQifuQihmwlSmht
         EzkNBCWr4JZklBZt5N42xG5AeiK5MRWqdwbZwxOGQ4cBbqic/tX3AXrRAExVrnOiuo1N
         4eS0aqU3lrT3+jX/+F92WnuZKUtRU/WDtF9UzaYzNn8I80PKsKKUh6/p2zeMPkKcXkCT
         hsJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=FRgJZkKjwQDCuu+MAnyqwDgQffBjFsnmD3AO1SRKwis=;
        b=jyEG+y8VxGmRFMmj85FVHDoprNb2fmGsW9jV3FumrjUsNdV38lAuNBOE2xfKNQHmIj
         rVI3G2RVB13YMzMdRi9e+iu80feLBAyO5Bz2WrBipLMvwcZvWKRDJK4e+AJUoRqHEyRQ
         ebTtFKl4oYPnL8LdxK2t3YQt9z81wWy+M3GVf5Ep9uoOPLYvFwnfnO2sNJfAW0q1ajtQ
         xWHvWeQ18r1GeY4HAgfNGxDfgW7qSyHDRjdv7v+FGhga+jY5DZwu+O7j87m6SGl/Ge+w
         lWWzFw45V0ZyvE3XDTXu/rCFBIpMY4bC+gmGbzZD1BoMnKoPYlz3f5Jo23DKM/FTm/pj
         YgOg==
X-Gm-Message-State: APjAAAUMQYkuP9enJgcRcFnQqWPjaxmrW/mbmNUPs32x/cVHQqQJ2KNx
        DuTwhO93NUNnxQam0t08gTA=
X-Google-Smtp-Source: APXvYqxJZwB//ENO8iCMhQululovzNZ4/eUsFBrvgZoy8MeWh6V9S/wreo3KOUZFpkQUbHzTMqi52g==
X-Received: by 2002:a63:5f04:: with SMTP id t4mr16986437pgb.73.1573835996651;
        Fri, 15 Nov 2019 08:39:56 -0800 (PST)
Received: from localhost (198-0-60-179-static.hfc.comcastbusiness.net. [198.0.60.179])
        by smtp.gmail.com with ESMTPSA id b24sm10960238pfi.148.2019.11.15.08.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 08:39:56 -0800 (PST)
Date:   Fri, 15 Nov 2019 08:39:55 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5dced4db31be6_5f462b1f489665bcaa@john-XPS-13-9370.notmuch>
In-Reply-To: <20191115015001.iyqipxhoqt77iade@ast-mbp.dhcp.thefacebook.com>
References: <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk>
 <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk>
 <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
 <87h839oymg.fsf@toke.dk>
 <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
 <5dcb3f4e8be4_3202ae6af4ec5bcac@john-XPS-13-9370.notmuch>
 <20191113002058.bkch563wm6vhmn3l@ast-mbp.dhcp.thefacebook.com>
 <5dcb959eb9d15_6dcc2b08358745c0f9@john-XPS-13-9370.notmuch>
 <20191115015001.iyqipxhoqt77iade@ast-mbp.dhcp.thefacebook.com>
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Tue, Nov 12, 2019 at 09:33:18PM -0800, John Fastabend wrote:
> > 
> > In addition to above flow something like this to load libraries first should
> > also work?
> > 
> >    // here fw2 is a library its never attached to anything but can be
> >    // used to pull functions from
> >    obj = bpf_object__open("fw2.o", attr);
> >    bpf_object__load(obj);
> >    prog = bpf_object__find_program_by_title(obj);
> >    subprog_btf_id0 = libbpf_find_obj_btf_id("name of function", obj);
> >    subprog_btf_id1 = libbpf_find_obj_btf_id("name of function", obj);
> > 
> >    // all pairs of (prog_fd, btf_id) need to be specified at load time
> >    attr.attach[0].prog_fd = fw2_fd;
> >    attr.attach[0].btf_id = subprog_btf_id0;
> >    attr.attach[1].prog_fd = fw2_fd;
> >    attr.attach[1].btf_id = subprog_btf_id1;
> >    obj = bpf_object__open("rootlet.o", attr)
> >    bpf_object__load(obj)
> >    prog = bpf_object__find_program_by_title(obj);
> >    link = bpf_program__replace(prog);
> >    // attach rootlet.o at this point with subprog_btf_id
> 
> The point I'm arguing that these:
>    attr.attach[0].prog_fd = fw2_fd;
>    attr.attach[0].btf_id = subprog_btf_id0;
>    attr.attach[1].prog_fd = fw2_fd;
>    attr.attach[1].btf_id = subprog_btf_id1;
> should not be part of libbpf api. Instead libbpf should be able to adjust
> relocations inside the program. You're proposing to do linking via explicit
> calls, I'm saying such linking should be declarative. libbpf should be able to
> derive the intent from the program and patch calls.

Agree seems cleaner. So when libs are loaded we create a in-kernel table
of functions/symbols and when main program is loaded search for the funcs. 

> 
> Example:
> helpers.o:
> int foo(struct xdp_md *ctx, int var) {...}
> int bar(int *array, bpf_size_t size) {...}
> obj = bpf_object__open("helpers.o", attr)
> bpf_object__load(obj);
> // load and verify helpers. 'foo' and 'bar' are not attachable to anything.
> // These two programs don't have program type.
> // The kernel loaded and verified them.
> main_prog.o:
> int foo(struct xdp_md *ctx, int var);
> int bar(int *array, bpf_size_t size);
> int main_prog(struct xdp_md *ctx) 
> { 
>   int ar[5], ret;
>   ret = foo(ctx, 1) + bar(ar, 5);
> }
> // 'foo' and 'bar' are extern functions from main_prog pov.
> obj = bpf_object__open("main_prog.o", attr)
> bpf_object__load(obj);
> // libbpf finds foo/bar in the kernel and adjusts two call instructions inside
> // main_prog to point to prog_fd+btf_id
> 
> That is the second use case of dynamic linking I've been talking earlier. The

This solves my use case.

> same thing should be possible to do with static linking. Then libbpf will
> adjust calls inside main_prog to be 'call pc+123' and 'foo' and 'bar' will
> become traditional bpf subprograms. main_prog() has single 'struct xdp_md *'
> argument. It is normal attachable XDP program.
> 
> Loading main_prog.o first and then loading helpers.o should be possible as
> well. The verifier needs BTF of extern 'foo' and 'bar' symbols to be able to
> verify main_prog() independently. For example to check that main_prog() is
> passing correct ctx into foo(). That is the main difference vs traditional
> dynamic linking. I think we all agree that we want bpf programs to be verified
> independently. To do that the verifier needs to have BTF (function prototypes)
> of extern symbols. One can argue that it's not necessary and helpers.o can be
> loaded first. I don't think that will work in all cases. There could be many
> dependencies between helpers1.o calling another helpers2.o and so on and there
> will be no good order where calling extern foo() can be avoided.

Agree, its a bit unclear what we would do with a __weak symbol if a helper.o
is loaded after main.o with that symbol. I think you keep using the __weak
symbol instead of automatically reloading it so you would need some explicit
logic to make that happen in libbpf if user wants.

> 
> This thread is getting long :) and sounds like we're converging. I'm thinking
> to combine everything we've discussed so far into dynamic/static linking doc.
> 

Yep seems we are close now. FWIW I just backed into a case where at least
static linking is going to be needed so this moves it up on my list because
I'll be using it as soon as its available.
