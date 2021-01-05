Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF9A2EA407
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 04:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbhAEDr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 22:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbhAEDr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 22:47:28 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18107C061574;
        Mon,  4 Jan 2021 19:46:48 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id g3so15666380plp.2;
        Mon, 04 Jan 2021 19:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xw079aVtf3EzdSxCTSDwZELuzk/6XV5HOEsKoSHdxns=;
        b=dhHdhlvsnjrAw3FlNo4uDrqrDQ72YSrREuoJ31hb6oJ7hfIzLUkHI7r0o2TEwgb88O
         VVIPbqPcT9Qn37/7DJdMZlwpqFU8BNt2tiqOoUlePTR5B55Mra8msCtv1IjBhUe4C5j6
         snFged3mJXdQbyr9MOFP8GBS46pgZcHMOHTYjdD7tyEbMazHAdhWsZYaKFNLBnJj//i9
         0jOFQpeQxmFF9PU6ptqv2Q1jOmcg+Kfvxi2FjiTQJ+f/iS8vJ5CPe25rzFAkcti9UqEY
         ON1oNHNM+LkHIMO5fKshVZ6qDsJfyRSvNC5JsZ/8gSFUj8lifhBzctu14i5D5jeqfCOT
         0Wmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xw079aVtf3EzdSxCTSDwZELuzk/6XV5HOEsKoSHdxns=;
        b=icVm6KB8OwWWZW8dv+Wjo1t53cobA05eHQalesu6EA9wp/+vj7wfM4MO23iALh33gw
         +QUy9kyw99Q/dw/LbKzx4LdOUR6G3qVNZW/RxZqWBBN34tEKn+Evm8V41Y2hunJ/m4fR
         XWlhqnOILHjz+ea0rt7f1k4JC+9nTEKawyTCU1ZSxXmz/DOPdOwtseI/CEwWR3fBMd5M
         ldZHl563gSGv6LcaivIMIJ11Y6QgaKo54emmP/Pl1f4Ilap4DFOTJMfmbKgF+LSmN6li
         9e5Y+RIMS/NNou6DvRVUW0W3AbSH5K6GJj17o5cRrtdbxzyReL7i5diFQC2RR9sdAIZw
         OWNg==
X-Gm-Message-State: AOAM530CBsdt67Q36YSKhobxSbXDk2A0TkjNcQUPsk/m6gpY7EAEWmXO
        fBEW4Hhe94xpEcnOtBBlF3o=
X-Google-Smtp-Source: ABdhPJxtbju1WICmOy2V2LXgo0YAURvnZKvFXsXn4lin0jX1zwgB++GcyMn6wLEMZxcCJW+owzvp2g==
X-Received: by 2002:a17:90b:1213:: with SMTP id gl19mr2141932pjb.232.1609818407592;
        Mon, 04 Jan 2021 19:46:47 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:429b])
        by smtp.gmail.com with ESMTPSA id x127sm53996638pfb.74.2021.01.04.19.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 19:46:46 -0800 (PST)
Date:   Mon, 4 Jan 2021 19:46:44 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add tests for user- and
 non-CO-RE BPF_CORE_READ() variants
Message-ID: <20210105034644.5thpans6alifiq65@ast-mbp>
References: <20201218235614.2284956-1-andrii@kernel.org>
 <20201218235614.2284956-4-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218235614.2284956-4-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 03:56:14PM -0800, Andrii Nakryiko wrote:
> +
> +/* shuffled layout for relocatable (CO-RE) reads */
> +struct callback_head___shuffled {
> +	void (*func)(struct callback_head___shuffled *head);
> +	struct callback_head___shuffled *next;
> +};
> +
> +struct callback_head k_probe_in = {};
> +struct callback_head___shuffled k_core_in = {};
> +
> +struct callback_head *u_probe_in = 0;
> +struct callback_head___shuffled *u_core_in = 0;
> +
> +long k_probe_out = 0;
> +long u_probe_out = 0;
> +
> +long k_core_out = 0;
> +long u_core_out = 0;
> +
> +int my_pid = 0;
> +
> +SEC("raw_tracepoint/sys_enter")
> +int handler(void *ctx)
> +{
> +	int pid = bpf_get_current_pid_tgid() >> 32;
> +
> +	if (my_pid != pid)
> +		return 0;
> +
> +	/* next pointers for kernel address space have to be initialized from
> +	 * BPF side, user-space mmaped addresses are stil user-space addresses
> +	 */
> +	k_probe_in.next = &k_probe_in;
> +	__builtin_preserve_access_index(({k_core_in.next = &k_core_in;}));
> +
> +	k_probe_out = (long)BPF_PROBE_READ(&k_probe_in, next, next, func);
> +	k_core_out = (long)BPF_CORE_READ(&k_core_in, next, next, func);
> +	u_probe_out = (long)BPF_PROBE_READ_USER(u_probe_in, next, next, func);
> +	u_core_out = (long)BPF_CORE_READ_USER(u_core_in, next, next, func);

I don't understand what the test suppose to demonstrate.
co-re relocs work for kernel btf only.
Are you saying that 'struct callback_head' happened to be used by user space
process that allocated it in user memory. And that is the same struct as
being used by the kernel? So co-re relocs that apply against the kernel
will sort-of work against the data of user space process because
the user space is using the same struct? That sounds convoluted.
I struggle to see the point of patch 1:
+#define bpf_core_read_user(dst, sz, src)                                   \
+       bpf_probe_read_user(dst, sz, (const void *)__builtin_preserve_access_index(src))

co-re for user structs? Aren't they uapi? No reloc is needed.
