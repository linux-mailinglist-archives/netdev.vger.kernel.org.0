Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 660D41728F2
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 20:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbgB0Tul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 14:50:41 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36778 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729441AbgB0Tuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 14:50:40 -0500
Received: by mail-pg1-f196.google.com with SMTP id d9so231791pgu.3;
        Thu, 27 Feb 2020 11:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7uW9X1W1F9ZgGbC9mtCCVsRNONYV1BtcJj3fvHbppQo=;
        b=pxVTZ+r/60g83J4HUUvOJblX887hIxaihH2Eb1QAHJfG38h+EUM0ZY/scbrvPzdaAn
         PCZoS5NnpN6dOQ/xUKXUdFWe4rDhTpZifNzr7oL2NNY/OFeFTsj1mdxBMz7xWGbWZm8k
         5SbwRXCzl1gjLufyVNfrsM9g9A4khkLG2Y6XYJZyryv4CfGzm0DAXN8jJHSPtI8sRjG7
         yJzV19v3dAyBv6NSc+NgyAW0mqZ+UiswlBr2CL9qOO4qxh0WcZjNr3v8vjyjcR/bREPX
         q+JROVNwDi91MIdnUv/fedBD4rN26Jh1FrMwJLrv5yR9WlVMSuqzoenO3yVEXydSv6m7
         ClBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7uW9X1W1F9ZgGbC9mtCCVsRNONYV1BtcJj3fvHbppQo=;
        b=o30vGxQikvw4hPhTyOP4KChM1NI94F5+lmkS/KClU0+nk9j8aVZgQ1uuSx97bbebyD
         /3C3lSM8wzxBNZgVRPCirM9rBcPm4O4zLOI8uYU9v+UuJdHpMTqgjWMOFMCz6TKAQt3u
         ns1YWGUz/XsAcKWvVi8RVCOzBKfbBJVUIfswlViJbAmjQQwNPUCx8ZP7n0Ql2xFhFSQN
         iBGMleiPiTlia5Z3tMVGJWpAoUeko1Az7gxl/h/by3XTp8ks8mSjnqXta5f5qW0GI3X0
         HOz6R+KM1brt2j2kQz9j1cP35yUEYqRXPTXV12C6YwMjuNTchocW/iW7AI5mNE/GZZUq
         jRsw==
X-Gm-Message-State: APjAAAVPaBpunxVN5OqVICNWbvT/iI7Uy3xXkAKJIEhbg3b0YxYcnJJa
        hr3D+jRG5l/dTw5mtmHLhvg=
X-Google-Smtp-Source: APXvYqyaVFLJ1+CqfjSXQZPVxPDTMNsoyAUzRPqTwLTAHgskLfutVftNYoVjxc8Gk5BsPEwX45rozw==
X-Received: by 2002:a63:cf06:: with SMTP id j6mr870456pgg.379.1582833039520;
        Thu, 27 Feb 2020 11:50:39 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::6:79da])
        by smtp.gmail.com with ESMTPSA id q9sm7514497pgs.89.2020.02.27.11.50.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Feb 2020 11:50:38 -0800 (PST)
Date:   Thu, 27 Feb 2020 11:50:36 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 10/18] bpf: Re-initialize lnode in bpf_ksym_del
Message-ID: <20200227195034.jq76twzwxdlfcwpd@ast-mbp>
References: <20200226130345.209469-1-jolsa@kernel.org>
 <20200226130345.209469-11-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226130345.209469-11-jolsa@kernel.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 02:03:37PM +0100, Jiri Olsa wrote:
> When bpf_prog is removed from kallsyms it's on the way
> out to be removed, so we don't care about lnode state.
> 
> However the bpf_ksym_del will be used also by bpf_trampoline
> and bpf_dispatcher objects, which stay allocated even when
> they are not in kallsyms list, hence the lnode re-init.
> 
> The list_del_rcu commentary states that we need to call
> synchronize_rcu, before we can change/re-init the list_head
> pointers.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index c95424fc53de..1af2109b45c7 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -672,6 +672,13 @@ void bpf_ksym_del(struct bpf_ksym *ksym)
>  	spin_lock_bh(&bpf_lock);
>  	__bpf_ksym_del(ksym);
>  	spin_unlock_bh(&bpf_lock);
> +
> +	/*
> +	 * As explained in list_del_rcu, We must call synchronize_rcu
> +	 * before changing list_head pointers.
> +	 */
> +	synchronize_rcu();
> +	INIT_LIST_HEAD_RCU(&ksym->lnode);

I don't understand what this is for.
The comment made it even more confusing.
What kind of ksym reuse are you expecting?

Looking at trampoline and dispatcher patches I think cnt == 0
condition is unnecessary. Just add them to ksym at creation time
and remove from ksym at destroy. Both are executable code sections.
Though RIP should never point into them while there are no progs
I think it's better to keep them in ksym always.
Imagine sw race conditions in destruction. CPU bugs. What not.

In patch 3 the name
bpf_get_prog_addr_region(const struct bpf_prog *prog)
became wrong and 'const' pointer makes it even more misleading.
The function is not getting prog addr. It's setting ksym's addr.
I think it should be called:
bpf_ksym_set_addr(struct bpf_ksym *ksym);
__always_inline should be removed too.

Similar in patch 4:
static void bpf_get_prog_name(const struct bpf_prog *prog)
also is wrong for the same reasons.
It probably should be:
static void bpf_ksym_set_name(struct bpf_ksym *ksym);

I'm still not confortable with patch 15 sorting bit.
next = rb_next(&ksym->tnode.node[0]);
if (next)
is too tricky for me. I cannot wrap my head yet.
Since user space doesn't rely on sorted order could you drop it?

Do patches 16-18 strongly depend on patches 1-15 ?
We can take them via bpf-next tree. No problem. Just need Arnaldo's ack.

Overall looks great. All around important work.
Please address above and respin. I would like to land it soon.
