Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320772B746A
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 03:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgKRCzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 21:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbgKRCzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 21:55:14 -0500
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832A8C0613D4;
        Tue, 17 Nov 2020 18:55:13 -0800 (PST)
Received: by mail-oo1-xc43.google.com with SMTP id l10so54980oom.6;
        Tue, 17 Nov 2020 18:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tEwnmHhIEBiF4ip6J2MWPrfZE1yNIQonDIzMaMDdDvM=;
        b=NDKe/JPt7K5aQAIYsKRW4qi5dUaX6bMle2gk9Xr0l3CC9PCYDXVxUby5N/vQ1ES4Pd
         oOS843e3Zhi7CH2lACr/vcn2KZ2Oo6g6BR9/1O/logjwpGfUaSz7sPqRiR21DItRH3DG
         z52oflR7hSbVffXDnNJtLRAFHce28sX2r7lcAZTYv0ixB171H69O8rr8d7xVw3Svd/qx
         lWwcIcIYbOAe2I+4ZzjBJKfukz7muxT33HFAOjFknju7YVHODHiIgQwsgcWhASorKjNY
         zeejI37zQbpY38fy8yDDn00KnKEkLBhKtEa80250KZDHt9ewJdub9h8AG117DZzGpuds
         0Bpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tEwnmHhIEBiF4ip6J2MWPrfZE1yNIQonDIzMaMDdDvM=;
        b=Un2cf/NsOfxKuwCVJAcZ2uHWCDDzLS5W+YXcbERnqx4UBeGsHwhxQcm9NUL0LNc0z0
         aBhzLt4nir6obl1H8uKmrMwwTjw228CkTl7oQVpYhDzlgWv9SW7BHfpXOWL9EjtlM8b8
         WMdQhVgxHm7PMtLxR6ne558w4GMr+HHXwY9YNhuq5UV7DRgDmaPvIwiVSbDPX86iqWaj
         Wnqca8Fg9Wr0y/UzktyXYDSzg/HIwaFXbCaraJvfsQ4hfOl3IXiOnBLEXRI2Drmwizhe
         HhyjJJ6w7LXrSQ7EvsN4FZjlh5xYqr5Z2MRUoORvQF0CL3yk5UBKGHItlnF/xmFLDTMx
         GWbw==
X-Gm-Message-State: AOAM531IaB3kxewuf9sgexJN8zanwgPmEnfnclR/oiJGJ4gn6vVAyquf
        KAEM0JELZ7oQg+8gljJKy82HY0VyG9Wt/uXMYQ==
X-Google-Smtp-Source: ABdhPJzRjuZgyhfgqXMOz7fG3Ka0cwdzRenoNOLT116CNG2LIn0CFNpWW+KaC111Or8HXNF3cx5nETwIX+56qQSDf4w=
X-Received: by 2002:a4a:928a:: with SMTP id i10mr5092779ooh.47.1605668112908;
 Tue, 17 Nov 2020 18:55:12 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-2-danieltimlee@gmail.com> <CAEf4BzZ9Sr0PXvZAa74phnwm7um9AoN4ELGkNBMvyzvh7vYzRQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZ9Sr0PXvZAa74phnwm7um9AoN4ELGkNBMvyzvh7vYzRQ@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 18 Nov 2020 11:54:56 +0900
Message-ID: <CAEKGpzhCeRZct-zW_DG0Aj_PD1FvtUOzbF5c134wwoGgqgf6rA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/9] selftests: bpf: move tracing helpers to trace_helper
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 10:58 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Nov 17, 2020 at 6:57 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > Under the samples/bpf directory, similar tracing helpers are
> > fragmented around. To keep consistent of tracing programs, this commit
> > moves the helper and define locations to increase the reuse of each
> > helper function.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> >
> > ---
> > [...]
> > -static void read_trace_pipe2(void)
>
> This is used only in hbm.c, why move it into trace_helpers.c?
>

I think this function can be made into a helper that can be used in
other programs. Which is basically same as 'read_trace_pipe' and
also writes the content of that pipe to file either. Well, it's not used
anywhere else, but I moved this function for the potential of reuse.

Since these 'read_trace_pipe's are helpers that are only used
under samples directory, what do you think about moving these
helpers to something like samples/bpf/trace_pipe.h?

Thanks for your time and effort for the review.

-- 
Best,
Daniel T. Lee
