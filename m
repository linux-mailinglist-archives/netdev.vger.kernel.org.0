Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6226A2019AB
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 19:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732609AbgFSRoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 13:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731681AbgFSRox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 13:44:53 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E6BC06174E;
        Fri, 19 Jun 2020 10:44:53 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r18so4772756pgk.11;
        Fri, 19 Jun 2020 10:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=0QTxVclpKLRWUv6Qkt7Oy+I/CqvmSS/OXzrlfUz9hMw=;
        b=QnpcjL1S9hDTKp3tXf2mumk0YWSlXC9EgE9t2zc18GUhzATlRMZwIiamU8+aRXmx9p
         reujFq2zmF4jyUxI2wZxqKpoiUS8KmSkdhUqc23EAvr8eXTbgYaO1EKVljZT0I4jzx4w
         kMEtHpD9k/h4Ji/4qdtsBI7LXNPubgE4v6Fs0hCHrEgN4WaN8uRYfh8Oxr4f4eeARZCh
         0dPMZqjNJPH1Up8JJoDlhQ+kVCjRjNMUgOReapo6WXYRhJEgN0GSBt59HjFbStvOv9+G
         OId7erF0K2farn+Yu7v02MIFT1TqV62GBRtwCG0oMWAZpuJEmdnCZyArJ0fP/Qj9d9lT
         8mKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=0QTxVclpKLRWUv6Qkt7Oy+I/CqvmSS/OXzrlfUz9hMw=;
        b=BMGGiVtoqT+c30EUjVGsRpkRW9UfO7FF2pWTbDqRMP0Ax5YG3CXAFRpc0mBZAjCfz5
         DTX7ZQLWVvpy888ezyYuKNnjXM+c4xJLrxFyKcWtEx2bDRrgnp3K+42Y7sDbeUUBV78k
         pD/iqY6sT1jbMkY1q2Yq3HxFQ1n3dMPv6u3hrJsupaoHe35H1s7l/AH+hYtFmb3F6eEG
         ALfQOPQdmTqNg7zkCj3U/SNSov+dcA8XSNebQuA2KEqkv35sX1dV00pvZRA6klfm6o0N
         QXMa9/7ddnhM7yypZEu4K14/NK0xgmf/k/ieP4LCAWlOmB8Pq71taaW/R+M05Z9xltXq
         luRQ==
X-Gm-Message-State: AOAM532PNgFMSQqWNqsCajZfSz+kuTCl0iZNsHazOAtV69femKyLaP9q
        CWBCwjccWiA6XwXHh5aixg4=
X-Google-Smtp-Source: ABdhPJzxSlyJnvignQypWslzCUvt/J7w/rjpKCkxDm1HSYpty5tBhyrVJIjsPamuCC+YrCwY4Q0GGg==
X-Received: by 2002:a63:7741:: with SMTP id s62mr3903463pgc.332.1592588692388;
        Fri, 19 Jun 2020 10:44:52 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x14sm6503559pfq.80.2020.06.19.10.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 10:44:51 -0700 (PDT)
Date:   Fri, 19 Jun 2020 10:44:43 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Andrii Nakryiko <andriin@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        Masanori Misono <m.misono760@gmail.com>
Message-ID: <5eecf98ba643c_137b2ad09f64a5c458@john-XPS-13-9370.notmuch>
In-Reply-To: <4aec5fb8-9f9d-d01b-dd58-f15d50c5e827@fb.com>
References: <20200616173556.2204073-1-jolsa@kernel.org>
 <5eeaa556c7a0e_38b82b28075185c46a@john-XPS-13-9370.notmuch>
 <20200618114806.GA2369163@krava>
 <5eebe552dddc1_6d292ad5e7a285b83f@john-XPS-13-9370.notmuch>
 <CAEf4Bzb+U+A9i0VfGUHLVt28WCob7pb-0iVQA8d1fcR8A27ZpA@mail.gmail.com>
 <5eec061598dcf_403f2afa5de805bcde@john-XPS-13-9370.notmuch>
 <CAADnVQLGNUcDWmrgUBmdcgLMfUNf=-3yroA8a+b7s+Ki5Tb4Jg@mail.gmail.com>
 <4aec5fb8-9f9d-d01b-dd58-f15d50c5e827@fb.com>
Subject: Re: [PATCH] bpf: Allow small structs to be type of function argument
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song wrote:
> 
> 
> On 6/18/20 7:04 PM, Alexei Starovoitov wrote:
> > On Thu, Jun 18, 2020 at 5:26 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >>
> >>   foo(int a, __int128 b)
> >>
> >> would put a in r0 and b in r2 and r3 leaving a hole in r1. But that
> >> was some old reference manual and  might no longer be the case
> 
> This should not happen if clang compilation with -target bpf.
> This MAY happen if they compile with 'clang -target riscv' as the IR
> could change before coming to bpf backend.

I guess this means in order to handle __int128 and structs in
btf_ctx_access we would have to know this did not happen. Otherwise
the arg to type mappings are off because we simply do

 arg = off / 8

> 
> >> in reality. Perhaps just spreading hearsay, but the point is we
> >> should say something about what the BPF backend convention
> >> is and write it down. We've started to bump into these things
> >> lately.
> > 
> > calling convention for int128 in bpf is _undefined_.
> > calling convention for struct by value in bpf is also _undefined_.
> 
> Just to clarify a little bit. bpf backend did not do anything
> special about int128 and struct type. It is using llvm default.
> That is, int128 using two argument registers and struct passed
> by address. But I do see some other architectures having their
> own ways to handle these parameters like X86, AARCH64, AMDGPU, MIPS.
> 
> int128 is not widely used. passing struct as the argument is not
> a good practice. So Agree with Alexei is not really worthwhile to
> handle them in the place of arguments.

Agree as well I'll just add a small fix to check btf_type_is_int()
size is <= u64 and that should be sufficient to skip handling the
int128 case.

> 
> > 
> > In many cases the compiler has to have the backend code
> > so other parts of the compiler can function.
> > I didn't bother explicitly disabling every undefined case.
> > Please don't read too much into llvm generated code.
> > 


