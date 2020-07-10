Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF99021B175
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 10:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgGJIhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 04:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbgGJIhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 04:37:08 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7590FC08C5DC
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 01:37:08 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h19so5473091ljg.13
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 01:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=fejdS5oXDBhA7SCXC2ps+GSa09Mm4PzKTz47mMKeznA=;
        b=c3x2FiQT6TXoFMi/lEyaa5Bcxv2wDEzGBOkaSSkCiIp5nsVGuNPzUTudrN7fLc1cMo
         WNHvoLDD8rVMEStHW0YH5o6c2RpKi07IJPBFRptIYSQ0yGqfoOz7QqoLjW+fNThOnmv2
         XHkH7cmyfWtQKQnlTZ6SaWN8R0i0IapKfj540=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=fejdS5oXDBhA7SCXC2ps+GSa09Mm4PzKTz47mMKeznA=;
        b=rlvWSrBxi6JRGZOa0Msb2Cc9VT/u7iK4qpRe7R8hIWGygIN5ckcUDt89IjBp/iHLKU
         4wgddZlQgXhVgv+4RWzj8dTBbxXY5/oJBeY/kQXdFNWwBwiqSBrskK2CCGEYY7cBdvCb
         +U0FY8zLoS8H187nzIzKw1IxeVGlBNJO4QwrIFYj9xf0506+Fh1W/J7qu5xNhY1GOLWr
         xjbu+dWnRQ0rOb120VeU84exlmKf/e4tIqmslMcOsVpnBB95tv5GbIxEvbcQFa/lakk8
         mlI6CU6VdbpvJNAcLeo8nU3Q7RCvkguBWj90wiYuM+f8ZaMt1cZaS0ur7Oy7w36BRl5T
         6ZdQ==
X-Gm-Message-State: AOAM533hBGR0BTP9FJiyRyCEkWo6zCO7XTvJV1fLexExuVkmu5KmRYKq
        T7pXOmWVsa+QupR1R0+gIaicmA==
X-Google-Smtp-Source: ABdhPJyDO+qq/oCenn+hN8r63rNpM0pYXwg+q/LIjKEgOWJ8pfCfGAw0CTosqI9qnesX4M/iqbRfTg==
X-Received: by 2002:a2e:9a47:: with SMTP id k7mr27428157ljj.96.1594370226759;
        Fri, 10 Jul 2020 01:37:06 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id v19sm1897418lfi.65.2020.07.10.01.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 01:37:06 -0700 (PDT)
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-13-jakub@cloudflare.com> <CAEf4BzbrUZhpxfw_eeJJCoo46_x1Y8naE19qoVUWi5sTSNSdzA@mail.gmail.com> <87h7ugadpt.fsf@cloudflare.com> <CAEf4BzY75c+gARvkmQ8OtbpDbZvBkia4qMyxO7HCoOeu=B1AxQ@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next v3 12/16] libbpf: Add support for SK_LOOKUP program type
In-reply-to: <CAEf4BzY75c+gARvkmQ8OtbpDbZvBkia4qMyxO7HCoOeu=B1AxQ@mail.gmail.com>
Date:   Fri, 10 Jul 2020 10:37:04 +0200
Message-ID: <87d053ahqn.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 01:13 AM CEST, Andrii Nakryiko wrote:
> On Thu, Jul 9, 2020 at 8:51 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> On Thu, Jul 09, 2020 at 06:23 AM CEST, Andrii Nakryiko wrote:
>> > On Thu, Jul 2, 2020 at 2:25 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>> >>
>> >> Make libbpf aware of the newly added program type, and assign it a
>> >> section name.
>> >>
>> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> >> ---
>> >>
>> >> Notes:
>> >>     v3:
>> >>     - Move new libbpf symbols to version 0.1.0.
>> >>     - Set expected_attach_type in probe_load for new prog type.
>> >>
>> >>     v2:
>> >>     - Add new libbpf symbols to version 0.0.9. (Andrii)
>> >>
>> >>  tools/lib/bpf/libbpf.c        | 3 +++
>> >>  tools/lib/bpf/libbpf.h        | 2 ++
>> >>  tools/lib/bpf/libbpf.map      | 2 ++
>> >>  tools/lib/bpf/libbpf_probes.c | 3 +++
>> >>  4 files changed, 10 insertions(+)
>> >>
>> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> >> index 4ea7f4f1a691..ddcbb5dd78df 100644
>> >> --- a/tools/lib/bpf/libbpf.c
>> >> +++ b/tools/lib/bpf/libbpf.c
>> >> @@ -6793,6 +6793,7 @@ BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
>> >>  BPF_PROG_TYPE_FNS(tracing, BPF_PROG_TYPE_TRACING);
>> >>  BPF_PROG_TYPE_FNS(struct_ops, BPF_PROG_TYPE_STRUCT_OPS);
>> >>  BPF_PROG_TYPE_FNS(extension, BPF_PROG_TYPE_EXT);
>> >> +BPF_PROG_TYPE_FNS(sk_lookup, BPF_PROG_TYPE_SK_LOOKUP);
>> >>
>> >>  enum bpf_attach_type
>> >>  bpf_program__get_expected_attach_type(struct bpf_program *prog)
>> >> @@ -6969,6 +6970,8 @@ static const struct bpf_sec_def section_defs[] = {
>> >>         BPF_EAPROG_SEC("cgroup/setsockopt",     BPF_PROG_TYPE_CGROUP_SOCKOPT,
>> >>                                                 BPF_CGROUP_SETSOCKOPT),
>> >>         BPF_PROG_SEC("struct_ops",              BPF_PROG_TYPE_STRUCT_OPS),
>> >> +       BPF_EAPROG_SEC("sk_lookup",             BPF_PROG_TYPE_SK_LOOKUP,
>> >> +                                               BPF_SK_LOOKUP),
>> >
>> > So it's a BPF_PROG_TYPE_SK_LOOKUP with attach type BPF_SK_LOOKUP. What
>> > other potential attach types could there be for
>> > BPF_PROG_TYPE_SK_LOOKUP? How the section name will look like in that
>> > case?
>>
>> BPF_PROG_TYPE_SK_LOOKUP won't have any other attach types that I can
>> forsee. There is a single attach type shared by tcp4, tcp6, udp4, and
>> udp6 hook points. If we hook it up in the future say to sctp, I expect
>> the same attach point will be reused.
>
> So you needed to add to bpf_attach_type just to fit into link_create
> model of attach_type -> prog_type, right? As I mentioned extending
> bpf_attach_type has a real cost on each cgroup, so we either need to
> solve that problem (and I think that would be the best) or we can
> change link_create logic to not require attach_type for programs like
> SK_LOOKUP, where it's clear without attach type.

Right. I was thinking about that a bit. For prog types map 1:1 to an
attach type, like flow_dissector or proposed sk_lookup, we don't really
to know the attach type to attach the program.

PROG_QUERY is more problematic though. But I imagine we could introduce
a flag like BPF_QUERY_F_BY_PROG_TYPE that would make the kernel
interpret attr->query.attach_type as prog type.

PROG_DETACH is yet another story but sk_lookup uses only link-based
attachment, so I'm ignoring it here.

What also might get in the way is the fact that there is no
bpf_attach_type value reserved for unspecified attach type at the
moment. We would have to ensure that the first enum,
BPF_CGROUP_INET_INGRESS, is not treated as an exact attach type.

>
> Second order question was if we have another attach type, having
> SEC("sk_lookup/just_kidding_something_else") would be a bit weird :)
> But it seems like that's not a concern.

Yes. Sorry, I didn't mean to leave it unanswered. Just assumed that it
was obvious that it's not the case.

I've been happily using the part of section name following "sk_lookup"
prefix to name the programs just to make section names in ELF object
unique:

  SEC("sk_lookup/lookup_pass")
  SEC("sk_lookup/lookup_drop")
  SEC("sk_lookup/redir_port")
