Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1CD117818D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbgCCSD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:03:26 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35776 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731209AbgCCSDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 13:03:23 -0500
Received: by mail-pj1-f66.google.com with SMTP id s8so1694463pjq.0;
        Tue, 03 Mar 2020 10:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B2tO/wgwTAbnKTMa9LXV6z5RfQ9U8qBcZe2mtEefEd8=;
        b=oyYwHdCWUZM9dSQP5KlhU2UTUoti7X2xuoY4bHIdm6RJKAjTqEkJub1A5PjXgJPfm6
         bKmeD0FERtQiPQ8YmL29UMwWpJr0uVBtscS7QGhU6Wv12eb6utpD2WK3dpapZAajRQNe
         pHUdXiOel7GfvDEVfNdAEJ/Ag7D4LcseUgAVUV7cg6oYGBtAQ4q1kv/0EWt9QiuFI8fu
         7gZme/SyqvK/a2fc+jjKRrzEf02eR5cF1DzqCq8yrvx+qsl5XqbqbJWpZNfrYWf23x/w
         NZnvKHszf4JGO6eC1UZcxgSbGDjgGxEF2z1+loWr1gUo1BfW8r79CPGsQbbHm6dt6q2K
         IjRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B2tO/wgwTAbnKTMa9LXV6z5RfQ9U8qBcZe2mtEefEd8=;
        b=tDyTCjJKT3igyD+cDnOZ+IoznHnSTIJtzxyUL0tNtJRm4jpw2dSdqgRumQY0CydHtN
         DCcyTQpHZrwCByBTsWO0AzrI9OCOGvJYGUKQDkStiTF1PUo8d7XkGk31kkqgBKQeg3v+
         WBjdDiuFqUGT4VsXGn/EKSCslIN/7HkwwfiGh78iTr6qqRzihBgaKawmnttO/KNQ8q3p
         JIMApm9qLdhZ//0ZI6++7bNY/Q9+ezbBIitFZq5Yteao8owUhJLRzmrYGahQjbChE7IF
         5eB4IEDJ2+SEd1VLRhukoT+HAcTfY2H6p42CvTz9XonGCdbFLwjSLDEZYPLygfAY2/eU
         jxaQ==
X-Gm-Message-State: ANhLgQ2qCTAEGh4SZ+WVJxmpz2tG8tuL6jkdIIfuG/AjlE9cpXXcuTnS
        7t2JBN8yS9HkFFKjlxxfBYimYTCr
X-Google-Smtp-Source: ADFU+vsC8+NCCJYXxI6hJi5y/Ir0r3L87i0ScL7C3YQCLkS4zxRONRWlqXTc0kh+Op9b9zCLTbM/Nw==
X-Received: by 2002:a17:90a:2a0c:: with SMTP id i12mr5173066pjd.149.1583258602673;
        Tue, 03 Mar 2020 10:03:22 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::4:a0de])
        by smtp.gmail.com with ESMTPSA id b4sm26257540pfd.18.2020.03.03.10.03.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 10:03:21 -0800 (PST)
Date:   Tue, 3 Mar 2020 10:03:19 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH 06/15] bpf: Add bpf_ksym_tree tree
Message-ID: <20200303180318.vblj7izq2miken6e@ast-mbp>
References: <20200302143154.258569-1-jolsa@kernel.org>
 <20200302143154.258569-7-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302143154.258569-7-jolsa@kernel.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 03:31:45PM +0100, Jiri Olsa wrote:
> The bpf_tree is used both for kallsyms iterations and searching
> for exception tables of bpf programs, which is needed only for
> bpf programs.
> 
> Adding bpf_ksym_tree that will hold symbols for all bpf_prog
> bpf_trampoline and bpf_dispatcher objects and keeping bpf_tree
> only for bpf_prog objects to keep it fast.

...

>  static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
> @@ -616,6 +650,7 @@ static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
>  	WARN_ON_ONCE(!list_empty(&aux->ksym.lnode));
>  	list_add_tail_rcu(&aux->ksym.lnode, &bpf_kallsyms);
>  	latch_tree_insert(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
> +	latch_tree_insert(&aux->ksym.tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
>  }
>  
>  static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
> @@ -624,6 +659,7 @@ static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
>  		return;
>  
>  	latch_tree_erase(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
> +	latch_tree_erase(&aux->ksym.tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);

I have to agree with Daniel here.
Having bpf prog in two latch trees is unnecessary.
Especially looking at the patch 7 that moves update to the other tree.
The whole thing becomes assymetrical and harder to follow.
Consider that walking extable is slow anyway. It's a page fault.
Having trampoline and dispatch in the same tree will not be measurable
on the speed of search_bpf_extables->bpf_prog_kallsyms_find.
So please consolidate.

Also I don't see a hunk that deletes tnode from 'struct bpf_image'.
These patches suppose to generalize it too, no?
And at the end kernel_text_address() suppose to call
is_bpf_text_address() only, right?
Instead of is_bpf_text_address() || is_bpf_image_address() ?
That _will_ actually speed up backtrace collection.
