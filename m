Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B78159983
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731560AbgBKTOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:14:00 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42126 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729934AbgBKTN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 14:13:59 -0500
Received: by mail-qk1-f196.google.com with SMTP id q15so11220504qke.9;
        Tue, 11 Feb 2020 11:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=d1W30zHQdiQkj5IyypchYVwItXRzGT2oAJPS35EbEQ8=;
        b=fLsbjOU+hlAXFHNCScMBjf2nbVfIcoHTSMBR103UbL4IQ0k3uojgEBSHD0i6BIiS4h
         J+QLLh8QagnZGfvRoVSmNqRwlS2ETL9t26/320ZWrjNQ8NC+mpfPZkCIz2LR1w5w8DKV
         x/H/8RLFvHQGcZcbvgU7puhM8kQqrmR/lZ3gU2FSlAtwwxc41d+n0kYlsRtZ6gHOURKi
         /D3JEZqNTZMMuCWHHAKhQKxEvDwthHePURahSrl3q1aDdWBZUQ5tPXrgK59YepI5VuaL
         KM7hY6iESLsNzDBPeTdt3U7dDpx3egyXmRyN5bXlI6FX6Ibmuwxel9vID0CVUC2voT4h
         9y4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=d1W30zHQdiQkj5IyypchYVwItXRzGT2oAJPS35EbEQ8=;
        b=Dx8DlRlCkAElKcJUc5CWimaZ7X819/Iu6h0lphI9wEXUEQIvSbhshQ93XWk0CM9DNP
         snnZINJI/eG2J8+poao9SR0yygEETfBMUi0+z2uj/twQPB71m49FW1BnDCcQn1aySiyZ
         v980zWUBNri1v4nppSUOFLoyOMfVrEntC+zea2U4sIn4Ui1+QMcLV5OxZQeTqhetHnj8
         Rk2BJY26hfYeUgA3+aBN7wkzJwGTm9TsMEUHM5qZloK25M20bJDx7ch9xQV99N1R+Nl6
         X+1GmhzTQSROO7vRtuM6DNrD1tpapyguQGPTZnlpyKbMqvyi6OUQA64SFbvtyD5kBJyR
         Nr6Q==
X-Gm-Message-State: APjAAAUKxNcWakPYxGKpA3Fb59DnxJd1xkcFXRSlcbvj1rtoKijO3naT
        uoBKxHfnZOZ0sUIbFL/NERY=
X-Google-Smtp-Source: APXvYqwI0G5bVWqS6HCpjd/UFLoG4amTwVDRrFkCIwicIOMZYe4RIk0doKcl/eoVWQTuSiPJ5FfT5Q==
X-Received: by 2002:a37:b201:: with SMTP id b1mr7518397qkf.111.1581448438262;
        Tue, 11 Feb 2020 11:13:58 -0800 (PST)
Received: from quaco.ghostprotocols.net ([177.195.209.176])
        by smtp.gmail.com with ESMTPSA id c8sm2452358qkk.37.2020.02.11.11.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 11:13:57 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 2503140A7D; Tue, 11 Feb 2020 16:13:47 -0300 (-03)
Date:   Tue, 11 Feb 2020 16:13:47 -0300
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH 00/14] bpf: Add trampoline and dispatcher to
 /proc/kallsyms
Message-ID: <20200211191347.GH3416@kernel.org>
References: <20200208154209.1797988-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200208154209.1797988-1-jolsa@kernel.org>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, Feb 08, 2020 at 04:41:55PM +0100, Jiri Olsa escreveu:
> hi,
> this patchset adds trampoline and dispatcher objects
> to be visible in /proc/kallsyms. The last patch also
> adds sorting for all bpf objects in /proc/kallsyms.

This will allow those to appear in profiles, right? That would be
interesting to explicitely state, i.e. the _why_ of this patch, not just
the _what_.

Thanks,

- Arnaldo
 
>   $ sudo cat /proc/kallsyms | tail -20
>   ...
>   ffffffffa050f000 t bpf_prog_5a2b06eab81b8f51    [bpf]
>   ffffffffa0511000 t bpf_prog_6deef7357e7b4530    [bpf]
>   ffffffffa0542000 t bpf_trampoline_13832 [bpf]
>   ffffffffa0548000 t bpf_prog_96f1b5bf4e4cc6dc_mutex_lock [bpf]
>   ffffffffa0572000 t bpf_prog_d1c63e29ad82c4ab_bpf_prog1  [bpf]
>   ffffffffa0585000 t bpf_prog_e314084d332a5338__dissect   [bpf]
>   ffffffffa0587000 t bpf_prog_59785a79eac7e5d2_mutex_unlock       [bpf]
>   ffffffffa0589000 t bpf_prog_d0db6e0cac050163_mutex_lock [bpf]
>   ffffffffa058d000 t bpf_prog_d8f047721e4d8321_bpf_prog2  [bpf]
>   ffffffffa05df000 t bpf_trampoline_25637 [bpf]
>   ffffffffa05e3000 t bpf_prog_d8f047721e4d8321_bpf_prog2  [bpf]
>   ffffffffa05e5000 t bpf_prog_3b185187f1855c4c    [bpf]
>   ffffffffa05e7000 t bpf_prog_d8f047721e4d8321_bpf_prog2  [bpf]
>   ffffffffa05eb000 t bpf_prog_93cebb259dd5c4b2_do_sys_open        [bpf]
>   ffffffffa0677000 t bpf_dispatcher_xdp   [bpf]
> 
> thanks,
> jirka
> 
> 
> ---
> Björn Töpel (1):
>       bpf: Add bpf_trampoline_ name prefix for DECLARE_BPF_DISPATCHER
> 
> Jiri Olsa (13):
>       x86/mm: Rename is_kernel_text to __is_kernel_text
>       bpf: Add struct bpf_ksym
>       bpf: Add name to struct bpf_ksym
>       bpf: Add lnode list node to struct bpf_ksym
>       bpf: Add bpf_kallsyms_tree tree
>       bpf: Move bpf_tree add/del from bpf_prog_ksym_node_add/del
>       bpf: Separate kallsyms add/del functions
>       bpf: Add bpf_ksym_add/del functions
>       bpf: Re-initialize lnode in bpf_ksym_del
>       bpf: Rename bpf_tree to bpf_progs_tree
>       bpf: Add trampolines to kallsyms
>       bpf: Add dispatchers to kallsyms
>       bpf: Sort bpf kallsyms symbols
> 
>  arch/x86/mm/init_32.c   |  14 ++++++----
>  include/linux/bpf.h     |  54 ++++++++++++++++++++++++++------------
>  include/linux/filter.h  |  13 +++-------
>  kernel/bpf/core.c       | 182 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------------------
>  kernel/bpf/dispatcher.c |   6 +++++
>  kernel/bpf/trampoline.c |  23 ++++++++++++++++
>  kernel/events/core.c    |   4 +--
>  net/core/filter.c       |   5 ++--
>  8 files changed, 219 insertions(+), 82 deletions(-)
> 

-- 

- Arnaldo
