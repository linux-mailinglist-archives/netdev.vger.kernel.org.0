Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37DE1D1F9E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403777AbgEMTtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390696AbgEMTtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:49:16 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CF6C061A0E
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:49:16 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id l19so904115lje.10
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YO5CZycJoj3SG3fGwN+WTopK/LhbyP0lsfj2E+DRkX4=;
        b=PhubPRzpkCdl9mVPHrG9Oo8C+WwrKBHaeYw/BPL1ZhM7m32uY9vOkxzag4IPR45vmN
         nCyuee+AoItBB8/CS6j7/cO2lxt0a4Fuet7ze1acDgZYlgBMc3l9Izqr8rAmG81U3hf8
         E+jYDPSfclqu+31+e+LKbjbSmiBTvos3Qrvk0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YO5CZycJoj3SG3fGwN+WTopK/LhbyP0lsfj2E+DRkX4=;
        b=fqddDHQ3izvJgzSiSZaU3mtrhSvlIpHZ+K2avxAKuO7rZQgu4SRu5heQMH9M3zrGwR
         oc2pfejkUTWt9gAp6i8h4Ypkhr0PWnQ9vHZZMMrYxUAsftlX865S4jd524yJaJv2Bm2U
         15tcRzQ6iV1RL/aXQgLdqt/IesCggX0pmUwNKxRKeGhXifNckZz4bR7t6K8a5YH0diDN
         2x4B33c+AThccPOcykjGhv33V5D1zIrMN4AecKolfDdnKnaxoREmlF3AAs1NDOUUWurw
         pfBaqNHw+O159KsR8UayFyhKVnGd63sXqK5onbV72SsG1qNXOJ03jq7rddQBqxm87rXb
         CBGQ==
X-Gm-Message-State: AOAM532rPR+mfHJCLDzgZ9cgsykmX2is1oi5TiSfLuwTmxOCA7MnKfhf
        A/nMxANMnGLr5+5GbaqM8UoKWHoXoSg=
X-Google-Smtp-Source: ABdhPJyjYkTATdiPS3YAb2fyyfGqA7dnbAV+TGfFkwHMDUGTx5o+JuHQFm4HfZrPLuIg1ZTkXj0EJQ==
X-Received: by 2002:a2e:8083:: with SMTP id i3mr413150ljg.175.1589399352255;
        Wed, 13 May 2020 12:49:12 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id b8sm321576lfq.70.2020.05.13.12.49.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 12:49:11 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id d22so534786lfm.11
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:49:10 -0700 (PDT)
X-Received: by 2002:ac2:58c8:: with SMTP id u8mr739476lfo.142.1589399350490;
 Wed, 13 May 2020 12:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200513160038.2482415-1-hch@lst.de> <20200513160038.2482415-15-hch@lst.de>
 <CAHk-=wgzXqgYQQt2NCdZTtxLmV1FV1nbZ_gKw0O_mRkXZj57zg@mail.gmail.com> <20200513194003.GA31028@lst.de>
In-Reply-To: <20200513194003.GA31028@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 13 May 2020 12:48:54 -0700
X-Gmail-Original-Message-ID: <CAHk-=whtGLxezkdMP6+859LFDgb++6dgYa6Vrc=zJ9+GB7UMFQ@mail.gmail.com>
Message-ID: <CAHk-=whtGLxezkdMP6+859LFDgb++6dgYa6Vrc=zJ9+GB7UMFQ@mail.gmail.com>
Subject: Re: [PATCH 14/18] maccess: allow architectures to provide kernel
 probing directly
To:     Christoph Hellwig <hch@lst.de>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:40 PM Christoph Hellwig <hch@lst.de> wrote:
>
> We do export something like it, currently it is called
> probe_kernel_address, and the last patch renames it to
> get_kernel_nofault.  However it is implemented as a wrapper
> around probe_kernel_address / copy_from_kernel_nofault and thus
> not quite as efficient and without the magic goto semantics.

Looking at the current users of "probe_kernel_read()", it looks like
it's almost mostly things that just want a single byte or word.

It's not 100% that: we definitely do several things that want the
"copy" semantics vs the "get" semantics: on the x86 side we have
CALL_INSN_SIZE and MAX_INSN_SIZE, and the ldttss_desc.

But the bulk of them do seem to be a single value.

I don't know if performance really matters here, but to me the whole
"most users seem to want to read a single value" is what makes me
think that maybe that should be the primary model, rather than have
the copy model be the primary one and then we implement the single
value case (badly) with a copy.

It probably doesn't matter that much. I certainly wouldn't hold this
series up over it - it can be a future thing.

         Linus
