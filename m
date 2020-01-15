Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FF113D0BB
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 00:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgAOXly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 18:41:54 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46285 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgAOXly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 18:41:54 -0500
Received: by mail-qk1-f194.google.com with SMTP id r14so17447283qke.13;
        Wed, 15 Jan 2020 15:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gVR4fMo7dtC6YfR28ZV7I1BTq93R+fTaMa5SyNFmT18=;
        b=nbNKp+rteZfygjV6f2slGFDhfmUNCuN0236Ps8cmo1DcIeL5IgZJ27CwiRgWCrYnRt
         Wcon11RJ65hsQ1/ktKvqNRw7UyN+kh99Dy6H2Wgp87Hjc/yJFZ4+6hVUDOkzhSHqwbJ+
         FdaSadD0SIuV8Q15SIXVquNu1x1t96pBRIBkqPxOiJvtMcMTfZVG2IsmtxBGXAIfdRHX
         jlPPcrVovA7b88SF+cAaN89a5Bnt4hmmF1x1fQ2qcK+R5+feeASZTXf3fRdDH+9ZkbIh
         ZUa7bs3tL575cQOOa8PhnK/XVg6XUkyHc8qc/aKE1mTlwamNEO/AOEn2xZNWkQEI3pIa
         47Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gVR4fMo7dtC6YfR28ZV7I1BTq93R+fTaMa5SyNFmT18=;
        b=Ikb/F1jTnyfkFM8meobbXp/R06H++p+uxVvewOJgBEGKpVpJEroW1b1AdeFj2ajbg4
         xR3gG2J1yW0qjlAdCMHhlz6Jk5q4rJuTEeFBgtLYP85pHupBqft1U0loSzfWF+fYoGft
         p0pmik1qZSvN/OcsUF5DdbXX2bScdhkugT8QD6llClg0PRrdYmT08sKgYpcgBvmlWBaL
         en2yv344xcBC4Co4gGWmIAANRBmn4htG+uoQmEsg1WZaegerzg745Mngd5Im7rcWgt3O
         ia7sNdOZqps3qn+tz+ydp6V2YYQkdtpkovAH9XwfypVcNmZNhgMEjhJCqChEE/KGX1bK
         E1HA==
X-Gm-Message-State: APjAAAVjINLCgHaWpo8ttuXCEkcxdq0ZqmqV+gcKXsi4Qf04HXXX5heG
        cpeYb9DtwkhkuUaOf2tRZiipOddL+73YGWWOC2WiE+J8
X-Google-Smtp-Source: APXvYqw0oJUnx2g1KYqMApQc16l6T9GNDyhCOPq6aN2+x63sYMXXcVgRva61BmfH1kZaGR181tBqA9M4N13PQusDHME=
X-Received: by 2002:a37:e408:: with SMTP id y8mr30154611qkf.39.1579131713111;
 Wed, 15 Jan 2020 15:41:53 -0800 (PST)
MIME-Version: 1.0
References: <20200115222241.945672-1-kafai@fb.com> <20200115222312.948025-1-kafai@fb.com>
 <CAEf4BzbBTqp7jDsTFdT60DSFSw7hX2wr3PB4a8p2pOaqs18tVA@mail.gmail.com>
 <20200115224955.45evt277ino4j5zi@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZDnaYswB07s2HSMQ4D96LuqLwVa4rp3gwi8a6chV2Zog@mail.gmail.com> <20200115231219.ajxqzbg2khtgmql4@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200115231219.ajxqzbg2khtgmql4@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jan 2020 15:41:42 -0800
Message-ID: <CAEf4BzZDOjnZVjTob-KUOZ_J9YHnbwC6Lzj3vPA9aB95kx7zRA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 5/5] bpftool: Support dumping a map with btf_vmlinux_value_type_id
To:     Martin Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 3:12 PM Martin Lau <kafai@fb.com> wrote:
>
> On Wed, Jan 15, 2020 at 02:59:59PM -0800, Andrii Nakryiko wrote:
> > On Wed, Jan 15, 2020 at 2:50 PM Martin Lau <kafai@fb.com> wrote:
> > >
> > > On Wed, Jan 15, 2020 at 02:46:10PM -0800, Andrii Nakryiko wrote:
> > > > On Wed, Jan 15, 2020 at 2:28 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > This patch makes bpftool support dumping a map's value properly
> > > > > when the map's value type is a type of the running kernel's btf.
> > > > > (i.e. map_info.btf_vmlinux_value_type_id is set instead of
> > > > > map_info.btf_value_type_id).  The first usecase is for the
> > > > > BPF_MAP_TYPE_STRUCT_OPS.
> > > > >
> > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > ---
> > > >
> > > > LGTM.
> > > >
> > > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > > Thanks for the review!
> > >
> > > I just noticied I forgot to remove the #include "libbpf_internal.h".
> > > I will respin one more.
> >
> > didn't notice that. Please also update a subject on patch exposing
> > libbpf_find_kernel_btf (it still mentions old name).
> oops. already went out. :p
> The commit message mentioned the renaming from old to new name.

no worries
