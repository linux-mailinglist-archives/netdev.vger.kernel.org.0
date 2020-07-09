Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DEE21AB47
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 01:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgGIXNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 19:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgGIXNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 19:13:17 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC10C08C5CE;
        Thu,  9 Jul 2020 16:13:17 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id p7so1768504qvl.4;
        Thu, 09 Jul 2020 16:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hv/1Nf2WjXXW88VGgmWkF0dU2MUYEL1DwubrJtO8Eow=;
        b=Ip5okX5jeu5mlT40XvDq8dLDIczHVgE3UdL1P62H9KxBUKCUEAkIhI3mOsY8Pz+umC
         JynLQ5RvpDzY73z01/IG1COJavuXcI9AwNVMdI+j1nGCTxvRQmODZWpFqxD1y8zYb61Q
         k2q8LNwyaX4nFXM1ON09UmdgYZ9e3fuCOHb9/0tomhRatA9o/XpfmrmnwzlFntdijYhC
         btfYk+Kqau9PcvX1+fjDhJIbDdkqEdTpx09hOFrG/S8tD5PBdUZtP6gnwl/yVkL7ryIf
         vjC+CNoz57M42/nMel7oh17WsBjVqlN4Qz4aUr8amLH40BgpTyjQBk/hqevqHGdw4fA3
         8w/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hv/1Nf2WjXXW88VGgmWkF0dU2MUYEL1DwubrJtO8Eow=;
        b=YEuXKUQrrTt3gbNpznVa0fwDqVRQWAZLMwoBjhdIaigGGTLhOKISAov1Jw3oWaolXz
         XQ2AzTYOvJLwtqUTrYwXboQtGOme3KW8Iqd68+Mzf5Q3nZ6aUfZlferSJmm2RWbY6XbG
         TPYfK+w0ZLTCOn+s8jprAPnokr0hRMRHfyVeSYW65CZWpiyR+U9Jpa+B4Ztt4sPaPcPM
         82oM2z0/rf6O3y+1LOAcip7/18eBpwhUVoDDKgiCO2lPXrZz5vqb3JaJAyW9TeUgR4dr
         3d1fE+9zc1ZXfVN5X51snNx195V578w0TH93LSfA4CKkD1Qm0FH22+Q64m418NymmXEJ
         MVyg==
X-Gm-Message-State: AOAM532+bF/Nop6yvyOBtXHfVzv4G1ru+D/Fm3Ll0QQbr2Hc4zyG8l2Y
        eX2ltlZKbvGPHNeIffCh3ZbMBfxmm4C1FPWs4zQ=
X-Google-Smtp-Source: ABdhPJzcFhwi3fSE6PLc9JeTQLnwNR1a/CX2jqkuyNq8LWrc/P4Y0nCoZHlYY0UXDG3Su0Gzlvbi3ZD7jwbh4AsE7J4=
X-Received: by 2002:a05:6214:946:: with SMTP id dn6mr54508659qvb.224.1594336394598;
 Thu, 09 Jul 2020 16:13:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-13-jakub@cloudflare.com>
 <CAEf4BzbrUZhpxfw_eeJJCoo46_x1Y8naE19qoVUWi5sTSNSdzA@mail.gmail.com> <87h7ugadpt.fsf@cloudflare.com>
In-Reply-To: <87h7ugadpt.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Jul 2020 16:13:03 -0700
Message-ID: <CAEf4BzY75c+gARvkmQ8OtbpDbZvBkia4qMyxO7HCoOeu=B1AxQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 12/16] libbpf: Add support for SK_LOOKUP
 program type
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 8:51 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Thu, Jul 09, 2020 at 06:23 AM CEST, Andrii Nakryiko wrote:
> > On Thu, Jul 2, 2020 at 2:25 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>
> >> Make libbpf aware of the newly added program type, and assign it a
> >> section name.
> >>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >>
> >> Notes:
> >>     v3:
> >>     - Move new libbpf symbols to version 0.1.0.
> >>     - Set expected_attach_type in probe_load for new prog type.
> >>
> >>     v2:
> >>     - Add new libbpf symbols to version 0.0.9. (Andrii)
> >>
> >>  tools/lib/bpf/libbpf.c        | 3 +++
> >>  tools/lib/bpf/libbpf.h        | 2 ++
> >>  tools/lib/bpf/libbpf.map      | 2 ++
> >>  tools/lib/bpf/libbpf_probes.c | 3 +++
> >>  4 files changed, 10 insertions(+)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index 4ea7f4f1a691..ddcbb5dd78df 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -6793,6 +6793,7 @@ BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
> >>  BPF_PROG_TYPE_FNS(tracing, BPF_PROG_TYPE_TRACING);
> >>  BPF_PROG_TYPE_FNS(struct_ops, BPF_PROG_TYPE_STRUCT_OPS);
> >>  BPF_PROG_TYPE_FNS(extension, BPF_PROG_TYPE_EXT);
> >> +BPF_PROG_TYPE_FNS(sk_lookup, BPF_PROG_TYPE_SK_LOOKUP);
> >>
> >>  enum bpf_attach_type
> >>  bpf_program__get_expected_attach_type(struct bpf_program *prog)
> >> @@ -6969,6 +6970,8 @@ static const struct bpf_sec_def section_defs[] = {
> >>         BPF_EAPROG_SEC("cgroup/setsockopt",     BPF_PROG_TYPE_CGROUP_SOCKOPT,
> >>                                                 BPF_CGROUP_SETSOCKOPT),
> >>         BPF_PROG_SEC("struct_ops",              BPF_PROG_TYPE_STRUCT_OPS),
> >> +       BPF_EAPROG_SEC("sk_lookup",             BPF_PROG_TYPE_SK_LOOKUP,
> >> +                                               BPF_SK_LOOKUP),
> >
> > So it's a BPF_PROG_TYPE_SK_LOOKUP with attach type BPF_SK_LOOKUP. What
> > other potential attach types could there be for
> > BPF_PROG_TYPE_SK_LOOKUP? How the section name will look like in that
> > case?
>
> BPF_PROG_TYPE_SK_LOOKUP won't have any other attach types that I can
> forsee. There is a single attach type shared by tcp4, tcp6, udp4, and
> udp6 hook points. If we hook it up in the future say to sctp, I expect
> the same attach point will be reused.

So you needed to add to bpf_attach_type just to fit into link_create
model of attach_type -> prog_type, right? As I mentioned extending
bpf_attach_type has a real cost on each cgroup, so we either need to
solve that problem (and I think that would be the best) or we can
change link_create logic to not require attach_type for programs like
SK_LOOKUP, where it's clear without attach type.

Second order question was if we have another attach type, having
SEC("sk_lookup/just_kidding_something_else") would be a bit weird :)
But it seems like that's not a concern.

>
> >
> >>  };
> >>

[...]
