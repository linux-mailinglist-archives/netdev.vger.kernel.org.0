Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A451354A42
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 03:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238979AbhDFBnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 21:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238598AbhDFBnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 21:43:17 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6B1C06174A;
        Mon,  5 Apr 2021 18:42:30 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id w2so8776798ilj.12;
        Mon, 05 Apr 2021 18:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=PrSDtDYLYZ4HLqUStDekIt+fn6OzEwVC74efgP8t0E8=;
        b=GJc/rD3kJ2ljFwr04aHOd0yq65Hx3XvI7M3N8iFEfwihNBeI722VrTGxaQRQLpwhmb
         cgKB8hd6JMaD1Gomos/5R/fwlCkEvrkK63HgCo0J5VOlOEXiHGgcC5kZbjKHZClHNTPF
         p3HLev563vwoBG9HJoQf1Ae75c8KzCrlYIMFnp/T5GaNB5HLzfijdS8gdpZx18pQyHwF
         RzuZRrEHN0TJ3qgsZ8CvPsMiZKNsWEwQ68l5f7irMj36upkF5QjL1U600x8uBtX/5x2v
         EqfvymZJVt5Z7awPQbR9R/6aSj2BBjMNMiwZk2oEF5oA5csfPGYxHV/JkGk0FGMrCj8D
         cE5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=PrSDtDYLYZ4HLqUStDekIt+fn6OzEwVC74efgP8t0E8=;
        b=FT/l5C5eBdd2i3jmdY0D4k9nzREzLix7FHwuuGOYsp0UUvJQBAUOMi4MihdVO1hxiV
         vGKVfCo8tu9tx8lmpdhPnK2ThNxW20NMSWXrhM/FT5oMvqBbf1Sq1DNctqTSreicuz0G
         dA8LK6QNVeBNjEPyYHb1aR7HGUylb2efn00ogLYIxu1hV7WN0nlSNmZgk+3j865Oiz1V
         SeqaxJaHvygnw7OKpUzfIfZUcCPSCOhwbo2DGlGupisd1lPAKPrg0Lks5jjZBBGNIkzU
         MVETqzKWSkgC9Ea+Wr90n2zhD24HWN9CMsEUAVUOvBEJKYuzCXxbAtNEPHzX5wtoLTKT
         Sztw==
X-Gm-Message-State: AOAM5310hfrh1Tx5FQaH0bAa38RKpS+xcEQ3cmOaG0B5jYQlUd5IkBaC
        NJ0B8zFfim2erYW974rEa8c=
X-Google-Smtp-Source: ABdhPJwIOD7eCg9Vve36yyS+GNc3QOioD/OAIB05JZ/Q/KPP5BBtqGonhE0XwZFN+SKpxTrX/1pNjQ==
X-Received: by 2002:a92:c26e:: with SMTP id h14mr17219229ild.33.1617673349649;
        Mon, 05 Apr 2021 18:42:29 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id r4sm1076219ilb.51.2021.04.05.18.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 18:42:29 -0700 (PDT)
Date:   Mon, 05 Apr 2021 18:42:21 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Pedro Tammela <pctammela@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "(open list:BPF \\(Safe dynamic programs and tools\\))" 
        <netdev@vger.kernel.org>,
        bpf@vger.kernel.org (open list:BPF \(Safe dynamic programs and tools\)),
        "(open list:BPF \\(Safe dynamic programs and tools\\) open list)" 
        <linux-kernel@vger.kernel.org>,
        "(open list:BPF \\(Safe dynamic programs and tools\\) open list open
        list:KERNEL SELFTEST FRAMEWORK)" <linux-kselftest@vger.kernel.org> (open
        list:BPF \(Safe dynamic programs and tools\) open list open list:KERNEL
        SELFTEST FRAMEWORK)
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <606bbc7db9d66_d464620822@john-XPS-13-9370.notmuch>
In-Reply-To: <20210404200256.300532-2-pctammela@mojatatu.com>
References: <20210404200256.300532-1-pctammela@mojatatu.com>
 <20210404200256.300532-2-pctammela@mojatatu.com>
Subject: RE: [PATCH bpf-next 1/3] bpf: add batched ops support for percpu
 array
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pedro Tammela wrote:
> Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---

A commit message describing some of the change details and a note it uses
the for-each cpu copies (same as normal syscall on percpu map) and not the
per-cpu ones would be nice. I at least had to go and check the generic_map*
batch operations.

Also something about why generic_map_delete_batch is omitted?

>  kernel/bpf/arraymap.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index 463d25e1e67e..3c4105603f9d 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -698,6 +698,8 @@ const struct bpf_map_ops percpu_array_map_ops = {
>  	.map_delete_elem = array_map_delete_elem,
>  	.map_seq_show_elem = percpu_array_map_seq_show_elem,
>  	.map_check_btf = array_map_check_btf,
> +	.map_lookup_batch = generic_map_lookup_batch,
> +	.map_update_batch = generic_map_update_batch,
>  	.map_set_for_each_callback_args = map_set_for_each_callback_args,
>  	.map_for_each_callback = bpf_for_each_array_elem,
>  	.map_btf_name = "bpf_array",
> -- 
> 2.25.1
> 


