Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167CE24CAAE
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 04:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgHUCWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 22:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbgHUCW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 22:22:29 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E73C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 19:22:28 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id g19so543587ejc.9
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 19:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nsUdliivJtp5Q6+//ViL/TxskEesc9x2uBqaTetkCW4=;
        b=L8/i1aFPC1LxPUXg1D2GZxUkWHDtGd90ELK9RK2LLZ/IoGIS77V8+gaXk+Q4UT9HLS
         9ODRRXaHvdWMFdIps9AiYjyN6aMLDmXWvcBqbDcZoqRdCBZG46ZBJ2SEJW7q/aZXZEw6
         Btcif9qvwviSGgM1R5lxRHiavoVAapIMBHrbzhhl5eicCKkUrjk+N1xi9imjVoaShxj0
         O81wLvdNL3pcmfbn9Y1kXAgRT9uu2r3azu025AM5CBkRFXHLsyjQqooRtostkuEczfdT
         L18Pmoa7tAOrjkPTGS3HnB4NAmu7SDZ4rvinOLaRHgFWlC92KRMG9edwE39Wnnw86Ob8
         ZTrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nsUdliivJtp5Q6+//ViL/TxskEesc9x2uBqaTetkCW4=;
        b=UBQlFfMVhKHXbvptlxIj5ljYEF4hn1iusp5pOH/z1kzF83giG5EU3Gw2PcqZOU+IVR
         IxmVLoL01zY5vdZc+MMqLPe/3DRV963WvrWfWV03qQ8GzPyd5wmaty4JD4Qq2PzL3BIv
         Re43YVlzuGzIX0iNY4/gM04gcT/fXTwaMprHPYWuK1NhiZpXTBmqOLwr/Wq40qdLFq1r
         tdPDtslwacaER3YgoVsEqgf2uPUQuEP97Llkem6FiGAE8WxHATlI5DG5pdMegd33VB7I
         1bObel95Wh4nCJSDyspnSkoH48W8/PaggynuzN4oe5gbyFlDRga07KRBtXR1AWkn//KA
         r7qw==
X-Gm-Message-State: AOAM531cVyTy7wqYY+unMg2PziSFNraq0twfOPpiNpTr1zTO6RAxJc0m
        s6EejAzfBFtPEQzdb+HsZy4U1tpHU7grSiivNK9fSg==
X-Google-Smtp-Source: ABdhPJxPa2BAinWcuRWziYxt33mJwF+y04RBKXB9gCPjrMmz1mDiblORWW7FKZhTjJKjGzr2w/qzpE7L/GbxmhpT5nA=
X-Received: by 2002:a17:906:3b45:: with SMTP id h5mr804466ejf.136.1597976547157;
 Thu, 20 Aug 2020 19:22:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com> <20200819224030.1615203-2-haoluo@google.com>
 <20200820215327.jsvjbsvv6ts3x4wn@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200820215327.jsvjbsvv6ts3x4wn@ast-mbp.dhcp.thefacebook.com>
From:   Hao Luo <haoluo@google.com>
Date:   Thu, 20 Aug 2020 19:22:15 -0700
Message-ID: <CA+khW7hGGCWkjqb_TNSQvpN-=4K==dtjF4fwUOf3zd8eoON5nw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 1/8] bpf: Introduce pseudo_btf_id
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 2:53 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> Why did you choose to do it during main do_check() walk instead of this pre-pass ?
> check_ld_imm() can be called multiple times for the same insn,
> so it's faster and less surprising to do it during replace_map_fd_with_map_ptr().
> BTF needs to be parsed first, of course.
> You can either move check_btf_info() before replace_map_fd_with_map_ptr() or
> move replace_map_fd_with_map_ptr() after check_btf_info().
> The latter is probably cleaner.

Ah, that does make more sense. I can move
replace_map_fd_with_map_ptr() after check_btf_info() (or
check_attach_btf_id()) and rename it to better reflect the fact that
it's not just for maps now.

Thanks for the insights!
Hao
