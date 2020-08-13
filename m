Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8640243235
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 03:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgHMBq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 21:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbgHMBqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 21:46:21 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8214BC061383;
        Wed, 12 Aug 2020 18:46:21 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c10so3583225pjn.1;
        Wed, 12 Aug 2020 18:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oOgrmsxW9OeDM56HqH8X/C8UEkj3Rx1fpN2RSFfS628=;
        b=rNGOzBHfgmdmmsznkTbqnEwW/ylnjrIJdnLlFfELVOw1ZgJbFNHhnkC+DKJGM6EOOA
         cmyoUdWBz0MW4IBA8qZF5GlLMUt/FVtJ1vLQZfza9kX2fNwZJhIAYQiGFGQTfECZi98N
         HnTRuhvQnj9fK+y33B87T8d5k5bcz6asIZPrN+6apram5942e0l6wTP+EoiwpLNHzgRO
         nfwRG+7zysYXVxvyC0PXEhydNxBISxxabB9TIIwMZwgWptZQEHpYJl/zgEmiiK7cJSQK
         OxWZwB0IdW7DnJOPIE9D3Vn1URdYr5TTcDBIvKR32Mm0G8GAuSM88ggAWb4rvRMu43eH
         LJWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oOgrmsxW9OeDM56HqH8X/C8UEkj3Rx1fpN2RSFfS628=;
        b=CugEBIDLXdH8htPVERuFid1/TkJTq9nW+o03vvx7ng18VV8kIKE9GBLcESkk9LVay2
         KSiYZAC/QzBPXOA7ulm0DXBNqwy1JezGjhD4enq+UCD6gPw+0S9k1N/cUzE8LxRMvvml
         zvF7OC0VpRv4b7nE31GQDhDVAShyTBw+rAbPfcNXvFAeWqDYLiSq9deqraLIuOfQFikr
         yJu1Z3/CYepQOE8W5KBl4ykjagzPORga41F0fsYV4hvy9GS4f5OCuduaSP6LhDlYgfxF
         UNaxVblUhBaHWBMK3GqDACjM6RzgejQWzwC741ERaheFwwCehXZ1x+kPgrAOj8hFXD6J
         AGUQ==
X-Gm-Message-State: AOAM53329ESBw1bSqgc71R7qZHg4opOU6kxcR+bdf/qU5clEhCkQ1H3I
        70YXK6QWH14wLqpbusdC0ZA=
X-Google-Smtp-Source: ABdhPJwX43LygDVhwXtukQn4ElHAikWkVEjbhQPH3bRKa+l4+ob+cn2bUejL7cUgXt+h/RZgnQQLOA==
X-Received: by 2002:a17:90b:e83:: with SMTP id fv3mr2650720pjb.193.1597283180952;
        Wed, 12 Aug 2020 18:46:20 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:affd])
        by smtp.gmail.com with ESMTPSA id w6sm3162107pgr.82.2020.08.12.18.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2020 18:46:19 -0700 (PDT)
Date:   Wed, 12 Aug 2020 18:46:16 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com,
        linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: make BTF show support generic,
 apply to seq files/bpf_trace_printk
Message-ID: <20200813014616.6enltdpq6hzlri6r@ast-mbp.dhcp.thefacebook.com>
References: <1596724945-22859-1-git-send-email-alan.maguire@oracle.com>
 <1596724945-22859-3-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596724945-22859-3-git-send-email-alan.maguire@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 06, 2020 at 03:42:23PM +0100, Alan Maguire wrote:
> 
> The bpf_trace_printk tracepoint is augmented with a "trace_id"
> field; it is used to allow tracepoint filtering as typed display
> information can easily be interspersed with other tracing data,
> making it hard to read.  Specifying a trace_id will allow users
> to selectively trace data, eliminating noise.

Since trace_id is not seen in trace_pipe, how do you expect users
to filter by it?
It also feels like workaround. May be let bpf prog print the whole
struct in one go with multiple new lines and call
trace_bpf_trace_printk(buf) once?

Also please add interface into bpf_seq_printf.
BTF enabled struct prints is useful for iterators too
and generalization you've done in this patch pretty much takes it there.

> +/*
> + * Options to control show behaviour.
> + *	- BTF_SHOW_COMPACT: no formatting around type information
> + *	- BTF_SHOW_NONAME: no struct/union member names/types
> + *	- BTF_SHOW_PTR_RAW: show raw (unobfuscated) pointer values;
> + *	  equivalent to %px.
> + *	- BTF_SHOW_ZERO: show zero-valued struct/union members; they
> + *	  are not displayed by default
> + *	- BTF_SHOW_NONEWLINE: include indent, but suppress newline;
> + *	  to be used when a show function implicitly includes a newline.
> + *	- BTF_SHOW_UNSAFE: skip use of bpf_probe_read() to safely read
> + *	  data before displaying it.
> + */
> +#define BTF_SHOW_COMPACT	(1ULL << 0)
> +#define BTF_SHOW_NONAME		(1ULL << 1)
> +#define BTF_SHOW_PTR_RAW	(1ULL << 2)
> +#define BTF_SHOW_ZERO		(1ULL << 3)
> +#define BTF_SHOW_NONEWLINE	(1ULL << 32)
> +#define BTF_SHOW_UNSAFE		(1ULL << 33)

I could have missed it earlier, but what is the motivation to leave the gap
in bits? Just do bit 4 and 5 ?
