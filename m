Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976832A0ECE
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 20:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgJ3Tkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 15:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgJ3Tkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 15:40:31 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD31C0613D2;
        Fri, 30 Oct 2020 12:40:31 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id i18so1883662ots.0;
        Fri, 30 Oct 2020 12:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=gWR7GXD+A3nP28R5gy8PB5/5HzBDjhKdxtj8DfG8v9A=;
        b=MaVONzX2Vr0YbQ4kLdGl7/G4kZ4+9hNtKVTpNYqC3m6wUQjmZOvcittmYyiD5Jenbm
         xtH/JlMowgfrIZNq0VuWVrc3Y6qZYdEfQMRGlx4V2NnwzV2t5c1Mn69hihlW0MEOhYz/
         zZ7ivYZ89HEdPyfh5ZoivWK4YfhdUoYmfQKQF7Q9f1zl6B+imegjzk8ltzFd2GHr0rAu
         T6SVfR4U6f27yHT2UPq5kUtUmeGnHhhtPSerXnOM7RfBZosOl9OweD4tvn5DSZ2JSzDt
         W6iXQoByiRffLZDP0EF9hqFXZehZyGRhFIzKectWRdWE4zyfMTIfD++rRNhuy+NmWO/o
         1AuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=gWR7GXD+A3nP28R5gy8PB5/5HzBDjhKdxtj8DfG8v9A=;
        b=J1zUZY6So76Fa3IHaV8d2IyuBE449R9o6VDe7e8qc48pRlvCpHmKjcip9YFnF7TF9O
         hD9X7p0HbiI2mqfg7E/B9g2wVsQvhMSv5fzBkOT5KbetjtKiuDV0NiUA1aULk+g3TT5s
         O7aaKTyyCfMGu5oxVqQOWkD7KGIYC7a844UUTWAOb2e4qn8KvkR5Wr+X5JDs0hVTCQtG
         vXoPgEm0rQyoq53SN6BwY6RcfWhtrcW3+NUWNBoRDhA4Y2FOCeiicPIdVtWZFvFlSoa3
         9v0J42nf7rUqxF7No7/2j+yUfxkPwba4vJTkPTeCi3Tzfd58v6oDAwlfrk3e2KG+cq4V
         4d7g==
X-Gm-Message-State: AOAM530u7NcgaAu/MFjkozrQnpc3aHuNgzqhvGK1ofa356pAiYZdp899
        5kkTtYppTflYhFJ7eQw78As=
X-Google-Smtp-Source: ABdhPJwaklQ8F1QAciRpc0Xw4LnbAkaVfau8CjsfSVvlTGHx3elUFOtlGTDf9GkyiwQ9QjOtKzWfcg==
X-Received: by 2002:a05:6830:19e1:: with SMTP id t1mr3067313ott.196.1604086830584;
        Fri, 30 Oct 2020 12:40:30 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w79sm368344oia.28.2020.10.30.12.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 12:40:29 -0700 (PDT)
Date:   Fri, 30 Oct 2020 12:40:21 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Message-ID: <5f9c6c259dfe5_16d420817@john-XPS-13-9370.notmuch>
In-Reply-To: <160407665728.1525159.18300199766779492971.stgit@firesoul>
References: <160407661383.1525159.12855559773280533146.stgit@firesoul>
 <160407665728.1525159.18300199766779492971.stgit@firesoul>
Subject: RE: [PATCH bpf-next V5 2/5] bpf: bpf_fib_lookup return MTU value as
 output when looked up
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> The BPF-helpers for FIB lookup (bpf_xdp_fib_lookup and bpf_skb_fib_lookup)
> can perform MTU check and return BPF_FIB_LKUP_RET_FRAG_NEEDED.  The BPF-prog
> don't know the MTU value that caused this rejection.
> 
> If the BPF-prog wants to implement PMTU (Path MTU Discovery) (rfc1191) it
> need to know this MTU value for the ICMP packet.
> 
> Patch change lookup and result struct bpf_fib_lookup, to contain this MTU
> value as output via a union with 'tot_len' as this is the value used for
> the MTU lookup.
> 
> V5:
>  - Fixed uninit value spotted by Dan Carpenter.
>  - Name struct output member mtu_result
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/uapi/linux/bpf.h       |   11 +++++++++--
>  net/core/filter.c              |   22 +++++++++++++++-------
>  tools/include/uapi/linux/bpf.h |   11 +++++++++--
>  3 files changed, 33 insertions(+), 11 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index e6ceac3f7d62..01b2b17c645a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2219,6 +2219,9 @@ union bpf_attr {
>   *		* > 0 one of **BPF_FIB_LKUP_RET_** codes explaining why the
>   *		  packet is not forwarded or needs assist from full stack
>   *
> + *		If lookup fails with BPF_FIB_LKUP_RET_FRAG_NEEDED, then the MTU
> + *		was exceeded and result params->mtu contains the MTU.
> + *

Do we need to hide this behind a flag? It seems otherwise you might confuse
users. I imagine on error we could reuse the params arg, but now we changed
the tot_len value underneath them?

>   * long bpf_sock_hash_update(struct bpf_sock_ops *skops, struct bpf_map *map, void *key, u64 flags)
>   *	Description
>   *		Add an entry to, or update a sockhash *map* referencing sockets.
> @@ -4872,9 +4875,13 @@ struct bpf_fib_lookup {
>  	__be16	sport;
>  	__be16	dport;
