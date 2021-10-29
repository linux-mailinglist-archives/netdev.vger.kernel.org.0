Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C946E43F6C0
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 07:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhJ2Foh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 01:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhJ2Fog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 01:44:36 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8629FC061570;
        Thu, 28 Oct 2021 22:42:07 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id n7so14969824ljp.5;
        Thu, 28 Oct 2021 22:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OqIUMNNZdElt4ykeqKzyUq6XbANVm6mrrDpsIt3rxiU=;
        b=fzJXldPw1O0i9bei67PZJPn3L/SMf8vEe9M34juhGK41c1KZxyBtfkjOnPxo7QS7iQ
         SLqQF6e+R1SDtMaDzIpm40QIMH9TISqqChYzLmjj/fkSCTeixbx8UKMA2mnJ9ru4mDm+
         5dxAs8LPaIEiZjyXCW0nIUXSv9EhYbNnKQBYSGOuliOYbTv7aXOTo+RXYnAre1ALUnja
         pVt5kW1GcMqAvbQMSKpo4m6nz71JcCoo++OA3jo6wnC/us3lW0z0mCqRp9pkAnfPDyMy
         7PpWb2kwlmTfM/EL6VSQnS1XQId35ohgCe+SvVzezaiBvrphF394n7tWhqbyi6l13kgw
         6eXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OqIUMNNZdElt4ykeqKzyUq6XbANVm6mrrDpsIt3rxiU=;
        b=dqAqgi1APJmVY1qJoIEBEAHS1NPv5UNPGN1JF/Z3F2gXTYDBa1/rYprkySp9hE4IEU
         oC4LkfrJOZi1tE2l7ta++3Ovi/yRciMi6Aw+0YgD6ZR0oIYRfLbO9V/IOIqXWwDiR0Bo
         BYeLSZ6jkpf4tHF80lovXc4KDIRWRuxFb2+tNSe/fihrhiid+jstzWl5n3lA7ZafsjoK
         INGU3DaN6FkJdmcriaIt81HBbNkLUlx3iUW+kQt+kO6+dTE5HMXG2AhpPaAs/iKAer4W
         gcpC0mcSSiORs6OiEJiAWEcu8TtwjVCl6bEsnUfAuU+Djl7gu6q5O0BH94FU7pQ8dCQO
         R8Qg==
X-Gm-Message-State: AOAM531QEa4bzUSnrnCyiU4riLAgsuOJW0OreRDTVwnq/SLKOkiaF25D
        2kdGsLMlixCoqo+DUCq+z1tD1Gxzi4ChlvfKxA==
X-Google-Smtp-Source: ABdhPJxIiTLKGbkjERdw0T/Hi7HVMyRwEDBtXgq8t31Pbo4YuFvl35uOrKLsKT+RPKFb2OJqncKE/acO8mnLJO34JDs=
X-Received: by 2002:a2e:9106:: with SMTP id m6mr9191592ljg.24.1635486125724;
 Thu, 28 Oct 2021 22:42:05 -0700 (PDT)
MIME-Version: 1.0
References: <20211027203727.208847-1-mauricio@kinvolk.io> <CAADnVQK2Bm7dDgGc6uHVosuSzi_LT0afXM6Hf3yLXByfftxV1Q@mail.gmail.com>
In-Reply-To: <CAADnVQK2Bm7dDgGc6uHVosuSzi_LT0afXM6Hf3yLXByfftxV1Q@mail.gmail.com>
From:   Rafael David Tinoco <rafaeldtinoco@gmail.com>
Date:   Fri, 29 Oct 2021 02:41:42 -0300
Message-ID: <CAGqxgpuB_L519RK6mGUrt9XTHnYJTrZY9AuQqgQ+p196k+oE1g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] libbpf: Implement BTF Generator API
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 11:34 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Oct 27, 2021 at 1:37 PM Mauricio V=C3=A1squez <mauricio@kinvolk.i=
o> wrote:
> > There is also a good example[3] on how to use BTFGen and BTFHub togethe=
r
> > to generate multiple BTF files, to each existing/supported kernel,
> > tailored to one application. For example: a complex bpf object might
> > support nearly 400 kernels by having BTF files summing only 1.5 MB.
>
> Could you share more details on what kind of fields and types
> were used to achieve this compression?
> Tracing progs will be peeking into task_struct.
> To describe it in the reduced BTF most of the kernel types would be neede=
d,
> so I'm a bit skeptical on the practicality of the algorithm.

https://github.com/aquasecurity/btfhub/tree/main/tools

has a complete README and, at the end, the example used:

https://github.com/aquasecurity/btfhub/tree/main/tools#time-to-test-btfgen-=
and-btfhub

We tested btfgen with bpfcc tools and tracee:

https://github.com/aquasecurity/tracee/blob/main/tracee-ebpf/tracee/tracee.=
bpf.c

and the generated BTF files worked. If you run something like:

./btfgen.sh [.../aquasec-tracee/tracee-ebpf/dist/tracee.bpf.core.o]

it will generate the BTFs tailored to a given eBPF object file, 1 smaller B=
TF
file per existing full external raw BTF file (1 per kernel version, basical=
ly).

All the ~500 kernels generated the same amount of BTF files with ~3MB in
total. We then remove all the BTF files that are equal to their previous
kernels:

https://github.com/aquasecurity/btfhub/blob/main/tools/btfgen.sh#L113

and we are able to reduce from 3MB to 1.5MB (as similar BTF files are symli=
nks
to the previous ones).

> I think it may work for sk_buff, since it will pull struct sock,
> net_device, rb_tree, and not a ton more.
> Have you considered generating kernel BTF with fields that are accessed
> by bpf prog only and replacing all other fields with padding ?

That is exactly the result of our final BTF file. We only include the
fields and types being used by the given eBPF object:

```
$ bpftool btf dump file ./generated/5.4.0-87-generic.btf format raw
[1] PTR '(anon)' type_id=3D99
[2] TYPEDEF 'u32' type_id=3D35
[3] TYPEDEF '__be16' type_id=3D22
[4] PTR '(anon)' type_id=3D52
[5] TYPEDEF '__u8' type_id=3D83
[6] PTR '(anon)' type_id=3D29
[7] STRUCT 'mnt_namespace' size=3D120 vlen=3D1
    'ns' type_id=3D72 bits_offset=3D64
[8] TYPEDEF '__kernel_gid32_t' type_id=3D75
[9] STRUCT 'iovec' size=3D16 vlen=3D2
    'iov_base' type_id=3D16 bits_offset=3D0
    'iov_len' type_id=3D85 bits_offset=3D64
[10] PTR '(anon)' type_id=3D58
[11] STRUCT '(anon)' size=3D8 vlen=3D2
    'skc_daddr' type_id=3D81 bits_offset=3D0
    'skc_rcv_saddr' type_id=3D81 bits_offset=3D32
[12] TYPEDEF '__u64' type_id=3D89
...
[120] STRUCT 'task_struct' size=3D9216 vlen=3D13
    'thread_info' type_id=3D105 bits_offset=3D0
    'real_parent' type_id=3D30 bits_offset=3D18048
    'real_cred' type_id=3D16 bits_offset=3D21248
    'pid' type_id=3D14 bits_offset=3D17920
    'mm' type_id=3D110 bits_offset=3D16512
    'thread_pid' type_id=3D56 bits_offset=3D18752
    'exit_code' type_id=3D123 bits_offset=3D17152
    'group_leader' type_id=3D30 bits_offset=3D18432
    'flags' type_id=3D75 bits_offset=3D288
    'thread_group' type_id=3D87 bits_offset=3D19328
    'tgid' type_id=3D14 bits_offset=3D17952
    'nsproxy' type_id=3D100 bits_offset=3D22080
    'comm' type_id=3D96 bits_offset=3D21440
[121] STRUCT 'pid' size=3D96 vlen=3D1
    'numbers' type_id=3D77 bits_offset=3D640
[122] STRUCT 'new_utsname' size=3D390 vlen=3D1
    'nodename' type_id=3D48 bits_offset=3D520
[123] INT 'int' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3DSIGNED
[124] ARRAY '(anon)' type_id=3D35 index_type_id=3D123 nr_elems=3D2
```

If you do a "format c" to the generated BTF file, then bpftool considers
everything as padding:

```
typedef unsigned char __u8;

struct ns_common {
        long: 64;
        long: 64;
        unsigned int inum;
        int: 32;
};

struct mnt_namespace {
        long: 64;
        struct ns_common ns;
        long: 64;
        long: 64;
        long: 64;
        long: 64;
        long: 64;
        long: 64;
        long: 64;
        long: 64;
        long: 64;
        long: 64;
        long: 64;
};

typedef unsigned int __kernel_gid32_t;
```

But libbpf is still able to calculate all field relocations.

> I think the algo would be quite different from the actual CO-RE logic
> you're trying to reuse.
> If CO-RE matching style is necessary and it's the best approach then plea=
se
> add new logic to bpftool.

Yes, we're heading that direction I suppose :\ ... Accessing .BTF.ext, to g=
et
the "bpf_core_relo" information requires libbpf internals to be exposed:

https://github.com/rafaeldtinoco/btfgen/blob/standalone/btfgen2.c#L119
https://github.com/rafaeldtinoco/btfgen/blob/standalone/include/stolen.h

we would have to check if we can try to export what we need for that (inste=
ad
of re-declaring internal headers, which obviously looks bad).
