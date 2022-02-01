Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02404A542A
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 01:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbiBAAfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 19:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiBAAfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 19:35:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DB0C061714;
        Mon, 31 Jan 2022 16:35:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4149C6116E;
        Tue,  1 Feb 2022 00:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50C4C340EC;
        Tue,  1 Feb 2022 00:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643675734;
        bh=cSEHOgu6WdxyN/x8mmLI9PyPNmHpQ766gw4vAOVF/p8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XXTWk9PVuTOJT0muRWwvhXefkHnxJ+UDo6fOO/2kjArsnsn2jmOVz5GQlOVshTQ5f
         93qOfEgqfD+HzV2GOkGdHZrBNfBKq2If526D/wz7eiwVL6+CknTjEOwucDi085vhPC
         BGv4i5YVqkHJ7M7he2VL0yY9J95cXN/RHrsaJDGIWWVHzYrq3vyMOD9c8GMuIQPbQx
         m/G5sqWoWgj++kCHWQrd6TsweiFQqXXQZcK8AYkIddIbOfv4JDGT6A0X5lJgQQu2Jw
         QSHG0qpMJvokPfkT08QdMsKDqGJRVTR5hQSgGgztzN5xL1wMMfkhOcAqSCcycDyrEH
         bm8Uyhhfh3Aww==
Received: by mail-yb1-f181.google.com with SMTP id w81so23588810ybg.12;
        Mon, 31 Jan 2022 16:35:34 -0800 (PST)
X-Gm-Message-State: AOAM532Cto8FlaBV0o9b4ye68/SyK4MOXDCGjzGRYCEPX2Cg3PXr7Zxj
        /3Ruw6zb0fpPlz3N28u9NUw/1flf7Ka96ppIVoQ=
X-Google-Smtp-Source: ABdhPJzzlUxO6mNNpETFDRcL+yX480IIMOe0zQN9THru2e/C6JjckNnv6svKBUXvyjjd3vLUzdiEM6NrLwx0IOxnXgw=
X-Received: by 2002:a25:8543:: with SMTP id f3mr15414165ybn.47.1643675733838;
 Mon, 31 Jan 2022 16:35:33 -0800 (PST)
MIME-Version: 1.0
References: <20220128234517.3503701-1-song@kernel.org> <20220128234517.3503701-9-song@kernel.org>
 <c5100e9a-3e8a-a554-1d77-50d7b296340b@iogearbox.net>
In-Reply-To: <c5100e9a-3e8a-a554-1d77-50d7b296340b@iogearbox.net>
From:   Song Liu <song@kernel.org>
Date:   Mon, 31 Jan 2022 16:35:23 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7911=38ym7ko23KLCFrgqCm0VFdQSu8Mqv+5Avc3sTFg@mail.gmail.com>
Message-ID: <CAPhsuW7911=38ym7ko23KLCFrgqCm0VFdQSu8Mqv+5Avc3sTFg@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next 8/9] bpf: introduce bpf_jit_binary_pack_[alloc|finalize|free]
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 4:21 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/29/22 12:45 AM, Song Liu wrote:
> [...]
[...]
> > +}
> > +
> > +/* Copy JITed text from rw_header to its final location, the ro_header. */
> > +int bpf_jit_binary_pack_finalize(struct bpf_prog *prog,
> > +                              struct bpf_binary_header *ro_header,
> > +                              struct bpf_binary_header *rw_header)
> > +{
> > +     void *ptr;
> > +
> > +     ptr = bpf_arch_text_copy(ro_header, rw_header, rw_header->size);
>
> Does this need to be wrapped with a text_mutex lock/unlock pair given
> text_poke_copy() internally relies on __text_poke() ?

Yes... Good catch. I guess we may do the lock in text_poke_copy().

Thanks,
Song
