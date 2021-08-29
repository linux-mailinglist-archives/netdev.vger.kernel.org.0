Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BCF3FAD4B
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 18:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbhH2Q6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 12:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbhH2Q6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 12:58:09 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0293BC061575;
        Sun, 29 Aug 2021 09:57:17 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so12248806pjb.0;
        Sun, 29 Aug 2021 09:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TrOT5kAqHDzxKVhcRxNJfE7NH12WV49NMN9SrzZvomw=;
        b=al7xRziDp6wtdsrL2oW9opcStrIQPpqkzTsE8/QRLPzVxhhzL2nd4i06EUzK7Pf/X2
         KLt7CVEpQBR0+Q39nLwO5WTYvb7CAIcPPFGuj9tDyuev2FeYDSjYyItH+R7HDfkxO0za
         Bu6G+jyeuNKbzmv6muHud4UqqZzfDEUtYZ0Y0kyDJwc3m4taOWdA+t70kzpK9d6fIjJJ
         rQfVsEGS1LcFTYqsSD7xARuE6R3oLpe8z2t0/O7o8QEFD86iDaY90By86K0OYs1CsThn
         jxxz6dKQ2KAKwFyZ0ZE7T87NVtd7ZjeoKEV60Vllmnl+8XL77qPCnHm7CIphZDUdyN91
         6XLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TrOT5kAqHDzxKVhcRxNJfE7NH12WV49NMN9SrzZvomw=;
        b=k65VsBvfsq3l0ZzlqXgWJRtgEE+H4nYLQQTAlmlrCt0J9Oa79ROn5G3ChUZPauqxol
         SwV+EtM8uQE6YAbzYOPzn/On3C81yKm7rKT4JpNvfpDkDn2WBGmotaCCk+JQPOszzr8S
         z8e4a3GaZzqWGcfgCbSRTUEqyCjnSqT/iqI5/xOYuPdw72caXWq5reaKnXD49bRpAGe0
         kEUhh/0U3K6B4CtWP3D3PrEkGL9LoPJXpHMRyVavDhSoTyfWjzlFRCBaVqF2KQLevIPy
         4jRN00C+vutZCmN+GodznVpcpfRJbTeGyxmMIPBufOV2ans6UVfuwHpby/tNC5zWBEs3
         t0Ow==
X-Gm-Message-State: AOAM531zDWduIbXJuhBx5axAYfKlPQ7GsZX9OVE9rDi/brvjIX09PCnZ
        P+OFsUcJsxPtKnuu8ByO2q104cjkVvU=
X-Google-Smtp-Source: ABdhPJyfMPVmUfOc95p+TAwGz7Pk3tDjBfSYFA8uaC6OQw8YfqWkfZpmqWQtgPNczzZCmkpGZCeSWA==
X-Received: by 2002:a17:90a:64c1:: with SMTP id i1mr34245322pjm.111.1630256236473;
        Sun, 29 Aug 2021 09:57:16 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:d606])
        by smtp.gmail.com with ESMTPSA id h4sm4902291pjc.28.2021.08.29.09.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 09:57:16 -0700 (PDT)
Date:   Sun, 29 Aug 2021 09:57:14 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 bpf-next 4/7] libbpf: use static const fmt string in
 __bpf_printk
Message-ID: <20210829165714.wghn236g2ka7lgna@ast-mbp.dhcp.thefacebook.com>
References: <20210828052006.1313788-1-davemarchevsky@fb.com>
 <20210828052006.1313788-5-davemarchevsky@fb.com>
 <3da3377c-7f79-9e07-7deb-4fca6abae8fd@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3da3377c-7f79-9e07-7deb-4fca6abae8fd@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 28, 2021 at 12:40:17PM -0400, Dave Marchevsky wrote:
> On 8/28/21 1:20 AM, Dave Marchevsky wrote:   
> > The __bpf_printk convenience macro was using a 'char' fmt string holder
> > as it predates support for globals in libbpf. Move to more efficient
> > 'static const char', but provide a fallback to the old way via
> > BPF_NO_GLOBAL_DATA so users on old kernels can still use the macro.
> > 
> > Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> > ---
> >  tools/lib/bpf/bpf_helpers.h | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index 5f087306cdfe..a1d5ec6f285c 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -216,10 +216,16 @@ enum libbpf_tristate {
> >  		     ___param, sizeof(___param));		\
> >  })
> >  
> > +#ifdef BPF_NO_GLOBAL_DATA
> > +#define BPF_PRINTK_FMT_TYPE char
> > +#else
> > +#define BPF_PRINTK_FMT_TYPE static const char
> 
> The reference_tracking prog test is failing as a result of this.
> Specifically, it fails to load bpf_sk_lookup_test0 prog, which 
> has a bpf_printk:
> 
>   47: (b4) w3 = 0
>   48: (18) r1 = 0x0
>   50: (b4) w2 = 7
>   51: (85) call bpf_trace_printk#6
>   R1 type=inv expected=fp, pkt, pkt_meta, map_key, map_value, mem, rdonly_buf, rdwr_buf
> 
> Setting BPF_NO_GLOBAL_DATA in the test results in a pass

hmm. that's odd. pls investigate.
Worst case we can just drop this patch for now.
The failing printk is this one, right?
bpf_printk("sk=%d\n", sk ? 1 : 0);
iirc we had an issue related to ?: operand being used as an argument
and llvm generating interesting code path with 'sk' and the later
if (sk) bpf_sk_release(sk);
would not be properly recognized by the verifier leading it to
believe that sk may not be released in some cases.
That printk was triggering such interesting llvm codegen.
See commit d844a71bff0f ("bpf: Selftests, add printk to test_sk_lookup_kern to encode null ptr check")
