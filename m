Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A398116370E
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 00:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgBRXSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 18:18:21 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33242 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727635AbgBRXSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 18:18:21 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so11722847pgk.0;
        Tue, 18 Feb 2020 15:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wr4DuRVgR1jd4oTUUpPq0Q2YSUdbLao1hXDjFRWINh0=;
        b=NZIOEomRHq5wTNr6cqFSxCO12drK3rGMjv66dh6YznuBgxTbw1yqHwaHw9GUufDJo+
         OgZCEardbTeP4Z4J1oDXyOXrYNFlbvL1PNXL+Nu7bbHryI4kzzBhc7uh+1u+icxU3CKD
         fkMhhf/Tb0Khgo453xtPmF7AMdQWpvELJL1wTHkqjJkwEOLOd4Lhr+EdGdk9ECLaW7fL
         bbgN7hyIScKQ4vTYByVR5yOlKGE6flyml8kc6aR//ZzBZw/pXzUR09h5uNqNc82t5jjG
         UDDPIhxgrK/IVx3gRM8RXIRp2/59VsOaZh+FpW5WT1ht5RkFuTF5VO1Wo6nremUpteNG
         Rcuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Wr4DuRVgR1jd4oTUUpPq0Q2YSUdbLao1hXDjFRWINh0=;
        b=DxSkhTVvdYCLF+2vWCacRj8hjkWSGZdMRIpGaJhqjIjmHYi/rYkOjPjrsaXTNPNMkZ
         ePSfIBZ5xiyHCob/r4KeV/mJwINN7jo8q8+vhjyGuv+/Fgk650qsEhf+Doq4t3SJjcux
         q3OfjZEmcl3RQOCmcgmE+kW9WUBR9iKohsCfqoGh2nlQHWjpncFsKzeTEgmswQgSl3bs
         dRTs8FQDrtOE0b84UY47w2k4LXIP4pSykOBWuzyGuoABcAxhNeOx1ihOFVbp37MaC4Yj
         5BdjdPBDz2t9GgtxO0VXRfEizuXSrJMHw4P1Jh5TqMhPLF/QQSt6xU6KrlxVoaIEpMRq
         d4RA==
X-Gm-Message-State: APjAAAWfhzn+DifnDltp7QWEmGHP//3kmLXrqD6hhtbC9to2h0aCjMkD
        NhvDY9QWFEBbvQFvdaWUQlI=
X-Google-Smtp-Source: APXvYqzRzk6xcaC+XO/KYJEeu21032vpEy76fvhAcH60V4Vx/eqYEIkQe2n87Vg7YAFFAFPYBieULA==
X-Received: by 2002:a65:6718:: with SMTP id u24mr25535951pgf.289.1582067900759;
        Tue, 18 Feb 2020 15:18:20 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::5:dd54])
        by smtp.gmail.com with ESMTPSA id x65sm68563pfb.171.2020.02.18.15.18.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Feb 2020 15:18:19 -0800 (PST)
Date:   Tue, 18 Feb 2020 15:18:17 -0800
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
Subject: Re: [PATCH 15/18] bpf: Sort bpf kallsyms symbols
Message-ID: <20200218231816.own6y5ijjx25kti6@ast-mbp>
References: <20200216193005.144157-1-jolsa@kernel.org>
 <20200216193005.144157-16-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200216193005.144157-16-jolsa@kernel.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 08:30:02PM +0100, Jiri Olsa wrote:
> Currently we don't sort bpf_kallsyms and display symbols
> in proc/kallsyms as they come in via __bpf_ksym_add.
> 
> Using the latch tree to get the next bpf_ksym object
> and insert the new symbol ahead of it.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/core.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 2f857bbfe05c..fa814179730c 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -651,9 +651,28 @@ static struct latch_tree_root bpf_progs_tree __cacheline_aligned;
>  
>  static void __bpf_ksym_add(struct bpf_ksym *ksym)
>  {
> +	struct list_head *head = &bpf_kallsyms;
> +	struct rb_node *next;
> +
>  	WARN_ON_ONCE(!list_empty(&ksym->lnode));
> -	list_add_tail_rcu(&ksym->lnode, &bpf_kallsyms);
>  	latch_tree_insert(&ksym->tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
> +
> +	/*
> +	 * Add ksym into bpf_kallsyms in ordered position,
> +	 * which is prepared for us by latch tree addition.
> +	 *
> +	 * Find out the next symbol and insert ksym right
> +	 * ahead of it. If ksym is the last one, just tail
> +	 * add to the bpf_kallsyms.
> +	 */
> +	next = rb_next(&ksym->tnode.node[0]);
> +	if (next) {
> +		struct bpf_ksym *ptr;
> +
> +		ptr = container_of(next, struct bpf_ksym, tnode.node[0]);
> +		head = &ptr->lnode;
> +	}
> +	list_add_tail_rcu(&ksym->lnode, head);

what is the motivation for sorting? do you want perf and other user space
to depend on it? Or purely aesthetics?
