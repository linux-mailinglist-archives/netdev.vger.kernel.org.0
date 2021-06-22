Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45103B0FA5
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 23:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFVV5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 17:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVV5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 17:57:01 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64778C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 14:54:44 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g192so635252pfb.6
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 14:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Et0cnhJuEoLjv6vMLinvtDVYCvvqn+qimMr3oMtAvgU=;
        b=C70uv04Vj3/Zv3xX3RyencgIdZUo1E7XDaCp4dKJAnUCBiJUgR6VkbiKJYMsGYuc4Z
         T90MZX/h6hv0FfmH0HNeLVoY8t2f0y3p0Gn725JrM8bGIyzglmi0tHZpybDqI1Q9yveb
         rMcE9YVJR9ZmxgaVc2iFZVUeuiJqpoW7d+qSxr2YGCZ7WxrsuKPOR+Gjcj71TRZDd2Tm
         W5PvfRIR1cYDgJf0sBntI8GUmO7d5P1hf225T7Mb6fobhEagefZCiY3DkSCvUKDJyQpI
         DSgolYrq2Ty24W0xNXdgaeeeCUaTvHpZsCgprPYVTptUQpWriin/MEzTDzi54mW+eTI9
         tH9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Et0cnhJuEoLjv6vMLinvtDVYCvvqn+qimMr3oMtAvgU=;
        b=a6qvw78zWscfhqMukzWiOMVjn3LQzqxHmViSt/aSlr10FQKMR0DmhLvzJCRBVUxrqZ
         UYsn+J9i/2U6JZ6iPCb38oOosTjaQBe7HEne8ROfM/QPTomfWeLxeWTikh0428gqp1/H
         Prnvi3//beuKvjdXtYmQaQ2J6qk2AuHgdyZH6scdLs1kC0wDBH3EgIqtQlZ3SJ03vLym
         4x3hyb6aGPDBXsmgsMQukqhKvMPaqHjL0uAGrC5ivPgXbwt7I34KWKGCE8ghkZk80TR3
         LVw6+vhBppcnhEdQ6kt6cahXtU9+9QB3T1+g0YTkeKltu0LXMxEyrkJrXP1UxRpB9/GZ
         5JaA==
X-Gm-Message-State: AOAM533FDpZ/vvFgGGHwG27LdOIzuWCn/4mMARd3Nc4+Y1H4GDp/SgLK
        Emq0FMUwIHx3y4yV1WCBsaY=
X-Google-Smtp-Source: ABdhPJx/8SA2fF2Umnbs9fyc2xbFKIu5TQQpyxJxhjfCAXz11bZ18eb+vKqXi6IHU1gPJZxEvmCImw==
X-Received: by 2002:a63:b00d:: with SMTP id h13mr711691pgf.74.1624398883934;
        Tue, 22 Jun 2021 14:54:43 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2af4])
        by smtp.gmail.com with ESMTPSA id c5sm3113648pjq.38.2021.06.22.14.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 14:54:43 -0700 (PDT)
Date:   Tue, 22 Jun 2021 14:54:39 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     maciej.fijalkowski@intel.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, netdev@vger.kernel.org
Subject: Re: [PATCH bpf v2 2/4] bpf: map_poke_descriptor is being called with
 an unstable poke_tab[]
Message-ID: <20210622215439.wfi56kb77ewq2lx6@ast-mbp.dhcp.thefacebook.com>
References: <162388400488.151936.1658153981415911010.stgit@john-XPS-13-9370>
 <162388411986.151936.3914295553899556046.stgit@john-XPS-13-9370>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162388411986.151936.3914295553899556046.stgit@john-XPS-13-9370>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 03:55:19PM -0700, John Fastabend wrote:
> When populating poke_tab[] of a subprog we call map_poke_track() after
> doing bpf_jit_add_poke_descriptor(). But, bpf_jit_add_poke_descriptor()
> may, likely will, realloc the poke_tab[] structure and free the old
> one. So that prog->aux->poke_tab is not stable. However, the aux pointer
> is referenced from bpf_array_aux and poke_tab[] is used to 'track'
> prog<->map link. This way when progs are released the entry in the
> map is dropped and vice versa when the map is released we don't drop
> it too soon if a prog is in the process of calling it.
> 
> I wasn't able to trigger any errors here, for example having map_poke_run
> run with a poke_tab[] pointer that was free'd from
> bpf_jit_add_poke_descriptor(), but it looks possible and at very least
> is very fragile.
> 
> This patch moves poke_track call out of loop that is calling add_poke
> so that we only ever add stable aux->poke_tab pointers to the map's
> bpf_array_aux struct. Further, we need this in the next patch to fix
> a real bug where progs are not 'untracked'.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  kernel/bpf/verifier.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 6e2ebcb0d66f..066fac9b5460 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -12126,8 +12126,12 @@ static int jit_subprogs(struct bpf_verifier_env *env)
>  			}
>  
>  			func[i]->insnsi[insn_idx - subprog_start].imm = ret + 1;
> +		}
>  
> -			map_ptr = func[i]->aux->poke_tab[ret].tail_call.map;
> +		for (j = 0; j < func[i]->aux->size_poke_tab; j++) {
> +			int ret;
> +
> +			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;

I don't see why it's necessary.
poke_tab pointer will be re-read after bpf_jit_add_poke_descriptor().
The compiler is not allowed to cache it.

I've applied the patch 1.
