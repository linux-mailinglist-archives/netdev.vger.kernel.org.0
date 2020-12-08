Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C252D212D
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgLHCyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgLHCyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 21:54:25 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193F2C061749;
        Mon,  7 Dec 2020 18:53:45 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id t33so14886917ybd.0;
        Mon, 07 Dec 2020 18:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z8loPG8U58lIBTc9sYS7jiFOqCpefVAOcaLFNAdlAuE=;
        b=oEk3ysYj1UEoBp87Q3+GjmiJJih8MWcQeZaJNLM+81lwE94R6skRWZz49HmdQ9l9Ye
         DQIIZ+i0rqNVYS+3Qu05bJ1omqCYvmE7fauyuQAjChS9uiPHDIcz6Zi6tkkCLTekjnzh
         iuV4eEP45VObgdqssB22lijBhcpr6IDjs4RVxt6pB9WoCsKMm8Q9F167+z9qpuFNnPWV
         Tyy73zH56HAzob2aVoGh2JBKKiLua8wo0NPOUkbFv7on0vYMu+m7Ts+hkc43Iw7oXeBV
         gK/8ppbuWY+grT8FaXnhs+aMPZF/YxK4rAHcIEBzMLViwehwBWPKwqnplg4q4IgLAbEG
         r1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z8loPG8U58lIBTc9sYS7jiFOqCpefVAOcaLFNAdlAuE=;
        b=NjyTrKMxK9b8V/kgFCy3BVSIw+kYTsX4p/wfKbgr2BPn1J9tNIzg1PCPiyaMGUWYh9
         UsU1KS7cKTZW25ISNklZ2tpxKVt1lCxgNFsldoqEuwcVd1vrC2Q76R2HbaPC/ossMDQI
         mhYYT2RjZ2yO3ppyzYQg0uv2dhrIPuvw8se0n901vRgwG0u1ACVTMsjDgrljPoWDiY5x
         LbfDKzg7lkQ8Bozu9pABZahWKICM/uECgK9uZ3yn5KPMBG4EYmyiavVVoXi1EVQIgcsH
         21cbzUPItkqPQoTp6xjojedixYkWcvC0FQkZKW1LkVsyHDkcgxW7nnhiAKD2/9FrAKy7
         h+cg==
X-Gm-Message-State: AOAM533BPM5qb3Blk61GxQqNFy2n4sHf9/1BVp9285BRMeQRjt2GS5yW
        RysVuHzzKYdGy04I/FnA7HpJrgcCThybZasxgEE=
X-Google-Smtp-Source: ABdhPJxWBAHJvXmx92TJyJDSEvTIKGWGEUng3vk/iImzkp2jtDKRh5C1gX0xnCSTfB8KG2DcXwK4RAy3q90LdAw1mS0=
X-Received: by 2002:a25:df8e:: with SMTP id w136mr26365744ybg.230.1607396024423;
 Mon, 07 Dec 2020 18:53:44 -0800 (PST)
MIME-Version: 1.0
References: <20201201215900.3569844-1-guro@fb.com> <CAADnVQJThW0_5jJ=0ejjc3jh+w9_qzctqfZ-GvJrNQcKiaGYEQ@mail.gmail.com>
 <20201203032645.GB1568874@carbon.DHCP.thefacebook.com> <6abdd146-c584-9c66-261d-d7d39ff3f499@iogearbox.net>
In-Reply-To: <6abdd146-c584-9c66-261d-d7d39ff3f499@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Dec 2020 18:53:33 -0800
Message-ID: <CAEf4BzYe1SDnWBzAP_U7NtUhu_cWa0EEMLv+d-q3YTFvP+y3og@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 00/34] bpf: switch to memcg-based memory accounting
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Roman Gushchin <guro@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 4:37 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 12/3/20 4:26 AM, Roman Gushchin wrote:
> > On Wed, Dec 02, 2020 at 06:54:46PM -0800, Alexei Starovoitov wrote:
> >> On Tue, Dec 1, 2020 at 1:59 PM Roman Gushchin <guro@fb.com> wrote:
> >>>
> >>> 5) Cryptic -EPERM is returned on exceeding the limit. Libbpf even had
> >>>     a function to "explain" this case for users.
> >> ...
> >>> v9:
> >>>    - always charge the saved memory cgroup, by Daniel, Toke and Alexei
> >>>    - added bpf_map_kzalloc()
> >>>    - rebase and minor fixes
> >>
> >> This looks great. Applied.
> >
> > Thanks!
> >
> >> Please follow up with a change to libbpf's pr_perm_msg().
> >> That helpful warning should stay for old kernels, but it would be
> >> misleading for new kernels.
> >> libbpf probably needs a feature check to make this warning conditional.
> >
> > I think we've discussed it several months ago and at that time we didn't
> > find a good way to check this feature. I'll think again, but if somebody
> > has any ideas here, I'll appreciate a lot.
>
> Hm, bit tricky, agree .. given we only throw the warning in pr_perm_msg() for
> non-root and thus probing options are also limited, otherwise just probing for
> a helper that was added in this same cycle would have been good enough as a
> simple heuristic. I wonder if it would make sense to add some hint inside the
> bpf_{prog,map}_show_fdinfo() to indicate that accounting with memcg is enabled

I think the initial version was emitting 0 for memlock, so that was a
pretty simple way to prove stuff. But I think it was changed at the
last minute to emit some non-zero "estimate" of memory used or
something like that?

> for the prog/map one way or another? Not just for the sake of pr_perm_msg(), but
> in general for apps to stop messing with rlimit at this point. Maybe also bpftool
> feature probe could be extended to indicate that as well (e.g. the json output
> can be fed into Go natively).
