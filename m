Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAC31271FD
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 01:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfLTACk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 19:02:40 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40189 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfLTACj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 19:02:39 -0500
Received: by mail-qk1-f194.google.com with SMTP id c17so6186716qkg.7;
        Thu, 19 Dec 2019 16:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DflVdIpQoJVyFG2BYO2Tb9HnXbDJdzN08W+fLPNFXdw=;
        b=J2K9KKfk7sNRJRboR9FGRYGVRv0Hnm+oqc4ULUvo81K3Zn9eSLsLIxoqt9t4HOkaFE
         IWRGvvMxGF4w7lB+49j0URKQU41q6Es4aybrNhT8rvTdtO3+ygRgq6KLdLIj4hPf8fuO
         GHz42/E+o9i+XZ+XuNyEpd1KJDxaRr/eGg7XP2HQNSqi6AO3o21BDZ/I44ostzpiRhBN
         KEOOqnS+KdWysOYjx8xPR4nWLgedEHw+W5545s+M6GYte9wdr89SXe2kIWnU4yDez/4E
         OG0W4Xx+btm/IaOSq+hatDt00N359c1ApOy+i3OaZLZ98Pu+HasiqeGDoh4xJ0Pm4kBD
         /HEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DflVdIpQoJVyFG2BYO2Tb9HnXbDJdzN08W+fLPNFXdw=;
        b=ltlZ1O5ef+ctTvCMSIY3AtZb8NSTnijd7G94plx7B/hQQ4ahzLerVhXpr/W0Zyi6JP
         KGepp+Henv4bh5RT4lUWaUef9aejA654yoEeowHJGVRR3a1BtLm97eS3gf9D7s+GFy4t
         HTfmuIbzHqlw/tUGqVvnMr7X0bhOq8SOiPQSTflTbflm+bExnfrsV05DN7SnAgzH8huS
         I5CKyiOQuieWZoKGxX62T/vOYxAAK/t00w05qQ4YJXx3aOWedcdJt8aBQ9DmF+pM+Kt9
         6Owo+qoraLkHsZGRgSmuu/LdiN+sN600P532A/PAsotSQN0lUg45coO7mUcMYhz6Fdr5
         abfw==
X-Gm-Message-State: APjAAAXXUKQlUs2UI5VyYt8pxq8TQMDnfzYA1X+YYl6ctkLOKfSJTJJu
        qcmxUmhU9XxZzU/uC0OJCkoG3sJgmLWwc7xc6BQ=
X-Google-Smtp-Source: APXvYqw9TDa7w6xj+qx/o6YYN4t9kpVyB/JwaShoiKk7HyvfPJQa+5Tszx3kLCLBj49gCNLEzwgaWVI1NA61UOPotN8=
X-Received: by 2002:ae9:e809:: with SMTP id a9mr10933464qkg.92.1576800158825;
 Thu, 19 Dec 2019 16:02:38 -0800 (PST)
MIME-Version: 1.0
References: <157676577049.957277.3346427306600998172.stgit@toke.dk> <157676577267.957277.6240503077867756432.stgit@toke.dk>
In-Reply-To: <157676577267.957277.6240503077867756432.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Dec 2019 16:02:27 -0800
Message-ID: <CAEf4BzZYOrXQFtVbqhw7PagzT6VhfM5LRV93cLuzABy8eHWyqw@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 2/3] libbpf: Handle function externs and
 support static linking
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 6:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds support for resolving function externs to libbpf, with a new AP=
I
> to resolve external function calls by static linking at load-time. The AP=
I
> for this requires the caller to supply the object files containing the
> target functions, and to specify an explicit mapping between extern
> function names in the calling program, and function names in the target
> object file. This is to support the XDP multi-prog case, where the
> dispatcher program may not necessarily have control over function names i=
n
> the target programs, so simple function name resolution can't be used.
>
> The target object files must be loaded into the kernel before the calling
> program, to ensure all relocations are done on the target functions, so w=
e
> can just copy over the instructions.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

A bunch of this code will change after you update to latest Clang with
proper type info for extern functions. E.g., there shouldn't be any
size/alignment for BTF_KIND_FUNC_PROTO, it's illegal. But that
Yonghong already mentioned.

As for the overall approach. I think doing static linking outside of
bpf_object opening/loading is cleaner approach. If we introduce
bpf_linker concept/object and have someting like
bpf_linked__new(options) + a sequence of
bpf_linker__add_object(bpf_object) + final bpf_linker__link(), which
will produce usable bpf_object, as if bpf_object__open() was just
called, it will be better and will allow quite a lot of flexibility in
how we do things, without cluttering bpf_object API itself.
Additionally, we can even have bpf_linker__write_file() to emit a
final ELF file with statically linked object, which can then be loaded
through bpf_object__open_file (we can do the same for in-memory
buffer, of course). You can imagine LLC some day using libbpf to do
actual linking of BPF .o files into a final BPF executable/object
file, just like you expect it to do for non-BPF object files. WDYT?

Additionally, and seems you already realized that as well (judging by
FIXMEs), we'll need to merge those individual objects' BTFs and
deduplicate them, so that they form coherent set of types. Adjusting
line info/func info is mandatory as well.

Another thing we should think through is sharing maps. With
BTF-defined maps, it should be pretty easy to have declaration vs
definiton of maps. E.g.,

prog_a.c:

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __uint(max_entries, 123);
    ... and so on, complete definition
} my_map SEC(".maps");

prog_b.c:

extern struct {
    ... here we can discuss which pieces are necessary/allowed,
potentially all (and they all should match, of course) ...
} my_map SEC(".maps");

prog_b.c won't create a new map, it will just use my_map from prog_a.c.

I might be missing something else as well, but those are the top things, IM=
O.

I hope this is helpful.

>  tools/lib/bpf/btf.c    |   10 +-
>  tools/lib/bpf/libbpf.c |  268 +++++++++++++++++++++++++++++++++++++++---=
------
>  tools/lib/bpf/libbpf.h |   17 +++
>  3 files changed, 244 insertions(+), 51 deletions(-)
>

[...]
