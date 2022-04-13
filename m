Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7978C4FEBF2
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 02:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiDMAhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 20:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiDMAhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 20:37:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F1C5FD2;
        Tue, 12 Apr 2022 17:35:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98D4EB82072;
        Wed, 13 Apr 2022 00:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3886CC385B1;
        Wed, 13 Apr 2022 00:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649810128;
        bh=AmfvMR6B8qWiar02K5X7Z8KIhMvVMGBK0eqEnVrFYpI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TxSzzlCOKE01p9I9UE5gYaWOCURLBMQJmIDI63cp2ILPaM5AZ/T9SPl3gGt7Pe99H
         SoxXtP59LPHy1mdvTMTOEvEJbeTILyT0GJeTK9C42LX5qkNHjbiXLa7/KzmBGfEJAw
         zUnY8CksJ6rKwIctIDPek8FU/OIXKLt2XZePPHzZlCIyZW5C9OuNVkZq9QO+9u30IR
         srLq82ZNl4Ijrnf1nB0oEdZlrb0o6i2CGiCjoUiW3y+BsbNd20R726D/TTXZmpFYeT
         6YFqnCAvixY4GGkla4N/uspLDXyzEmItxAyroL0wQkZ171htOphChzjaWOvy/OvwJ9
         F6QUnERcd4aBg==
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-2ebdf6ebd29so6039987b3.2;
        Tue, 12 Apr 2022 17:35:28 -0700 (PDT)
X-Gm-Message-State: AOAM532XN0L5G/YM+16Vvb0dVjg+HseOZTzrADneCwzLt3R+v/fd//g5
        4wCI7NQ4eJH/Bu05KdqBOYack2PItqI73/24OKY=
X-Google-Smtp-Source: ABdhPJxdJyCJBgAjK0m6B/QRCZoAaYow/4ZgPbqC+fgtzHksYWemDjn3nzAKx2oczPg0w5rKoB7gHE62aESus4w1jLQ=
X-Received: by 2002:a0d:f6c6:0:b0:2e5:bf17:4dce with SMTP id
 g189-20020a0df6c6000000b002e5bf174dcemr33657904ywf.130.1649810127216; Tue, 12
 Apr 2022 17:35:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220411231808.667073-1-song@kernel.org> <YlWc/yDjWbeSuVP4@bombadil.infradead.org>
In-Reply-To: <YlWc/yDjWbeSuVP4@bombadil.infradead.org>
From:   Song Liu <song@kernel.org>
Date:   Tue, 12 Apr 2022 17:35:14 -0700
X-Gmail-Original-Message-ID: <CAPhsuW46YEP=uSvG3rgE4qfS8vJ3e-ZoSRYdCPLyEPmqugEXxA@mail.gmail.com>
Message-ID: <CAPhsuW46YEP=uSvG3rgE4qfS8vJ3e-ZoSRYdCPLyEPmqugEXxA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 0/3] vmalloc: bpf: introduce VM_ALLOW_HUGE_VMAP
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Christoph Hellwig <hch@infradead.org>, imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luis,

On Tue, Apr 12, 2022 at 8:38 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Mon, Apr 11, 2022 at 04:18:05PM -0700, Song Liu wrote:
> > Changes v1 => v2:
> > 1. Add vmalloc_huge(). (Christoph Hellwig)
> > 2. Add module_alloc_huge(). (Christoph Hellwig)
> > 3. Add Fixes tag and Link tag. (Thorsten Leemhuis)
> >
> > Enabling HAVE_ARCH_HUGE_VMALLOC on x86_64 and use it for bpf_prog_pack has
> > caused some issues [1], as many users of vmalloc are not yet ready to
> > handle huge pages. To enable a more smooth transition to use huge page
> > backed vmalloc memory, this set replaces VM_NO_HUGE_VMAP flag with an new
> > opt-in flag, VM_ALLOW_HUGE_VMAP. More discussions about this topic can be
> > found at [2].
> >
> > Patch 1 removes VM_NO_HUGE_VMAP and adds VM_ALLOW_HUGE_VMAP.
> > Patch 2 uses VM_ALLOW_HUGE_VMAP in bpf_prog_pack.
> >
> > [1] https://lore.kernel.org/lkml/20220204185742.271030-1-song@kernel.org/
> > [2] https://lore.kernel.org/linux-mm/20220330225642.1163897-1-song@kernel.org/
> >
> > Song Liu (3):
> >   vmalloc: replace VM_NO_HUGE_VMAP with VM_ALLOW_HUGE_VMAP
> >   module: introduce module_alloc_huge
> >   bpf: use vmalloc with VM_ALLOW_HUGE_VMAP for bpf_prog_pack
> >
> >  arch/Kconfig                 |  6 ++----
> >  arch/powerpc/kernel/module.c |  2 +-
> >  arch/s390/kvm/pv.c           |  2 +-
> >  arch/x86/kernel/module.c     | 21 +++++++++++++++++++
> >  include/linux/moduleloader.h |  5 +++++
> >  include/linux/vmalloc.h      |  4 ++--
> >  kernel/bpf/core.c            |  9 +++++----
> >  kernel/module.c              |  8 ++++++++
>
> Please use modules-next [0] as that has queued up changes which change
> kernel/module.c quite a bit.
>
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=modules-next

We are hoping to ship this set to fix some issues with 5.18. So I guess it
shouldn't go through modules-next branch? Would this work for you?
We are adding a new API module_alloc_huge(), so it shouldn't break
existing features.

Thanks,
Song
