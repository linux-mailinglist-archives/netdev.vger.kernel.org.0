Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7371F9FEE
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 21:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731407AbgFOTIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 15:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgFOTIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 15:08:38 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC84C061A0E;
        Mon, 15 Jun 2020 12:08:38 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id w9so13542828qtv.3;
        Mon, 15 Jun 2020 12:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YVlspmnXYf2yCxQ/eFfu+0KVKqIfOAe8AZ4yuhbokns=;
        b=I7C0Rkz4Z77kET3+eJmCN2SNOiqccaqxzxxnlOXYruIcv/9kVUHRO1+ZrYsd9/zea4
         mU4ocRxEEj/g+iyXjJ+yq5kCtv5lafg/Mej8kxrljNvrJY9UpPs4/83e4AZBZcnktZkn
         zGZCyKskzrHgfOu3+khdaecXWUPe8wWUqa7PHsCeia0MSlJXb9r0ZlWLxW6QhmnkibOO
         VWmWFPWZhIuC4Kg0NIIt3u1U2kRHabGCb5eoVF6k9r5EclxlGctdNc7rB8oD0vQJzOA7
         VtD7hkPSZDlMDLWfg/orVNrbZCvRtDqrwK4arKcF0qkNkXRAJ3wrCY0ofhag13RAyj0E
         h04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YVlspmnXYf2yCxQ/eFfu+0KVKqIfOAe8AZ4yuhbokns=;
        b=kxHBxhCU7ucdPhUFzz6AG9jaXKCn6fk7OO1wNYYS5WxG6Mgw0bh+BRRT/nrYrTU4wk
         tS059EWDl3HErd7I1+zBjPyzvGOnzxf4S7wDWZV51aNRmdchElSyGDjBk4ta3YwmLLbD
         0masYQEWb4atje93vcVgFLHUUUMb0OSDp4Rqs8t8II0/3xwFbpnxOg03VvAaHyNm9XEe
         ougLkyq/kwrLeafovRjitb34S+E1O5lT3f1yWeL1IHLubZRHjc2FBhqRGapcs24k39AJ
         nY1RHkhjGDN8r4RUZUO6tRu59/2ictpV5rQL4jggQnaZlbQTP9KYFcqOex0YV1DxaX9B
         LDfA==
X-Gm-Message-State: AOAM532n6v01Iqdw6ffV3rpjKBHArB3gRvOdVZdiiwby8WB15B6/u40S
        7WUYWUAbMyYPLVP/8AGZvJlPge5Gq6oLd9brUvyclIT49jA=
X-Google-Smtp-Source: ABdhPJzoTC8vPq4JWknKpnUK83KdH4N5hfkGgo6VbnNhN5JTNwpN9Fk3cWMSuyR8U4PqOCErQIjS3IhHIRrlA5InNls=
X-Received: by 2002:ac8:2dc3:: with SMTP id q3mr17044210qta.141.1592248117474;
 Mon, 15 Jun 2020 12:08:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200612223150.1177182-1-andriin@fb.com> <20200612223150.1177182-3-andriin@fb.com>
 <CA+khW7hFZzp_K_xydSFw0O3LYB22_fC=Z4wG7i9Si+phGHn4cQ@mail.gmail.com>
In-Reply-To: <CA+khW7hFZzp_K_xydSFw0O3LYB22_fC=Z4wG7i9Si+phGHn4cQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Jun 2020 12:08:26 -0700
Message-ID: <CAEf4BzYVY-sA_SRqxr-dxrkR5DPW6tv3tnNonK=4WPx6eEiZFQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/8] libbpf: add support for extracting
 kernel symbol addresses
To:     Hao Luo <haoluo@google.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 9:44 AM Hao Luo <haoluo@google.com> wrote:
>
> Thanks, Andrii,
>
> This change looks nice! A couple of comments:
>
> 1. A 'void' type variable looks slightly odd from a user's perspective. How about using 'u64' or 'void *'? Or at least, a named type, which aliases to 'void'?

That choice is very deliberate one. `extern const void` is the right
way in C language to access linker-generated symbols, for instance,
which is quite similar to what the intent is her. Having void type is
very explicit that you don't know/care about that value pointed to by
extern address, the only operation you can perform is to get it's
address.

Once we add kernel variables support, that's when types will start to
be specified and libbpf will do extra checks (type matching) and extra
work (generating ldimm64 with BTF ID, for instance), to allow C code
to access data pointed to by extern address.

Switching type to u64 would be misleading in allowing C code to
implicitly dereference value of extern. E.g., there is a big
difference between:

extern u64 bla;

printf("%lld\n", bla); /* de-reference happens here, we get contents
of memory pointed to by "bla" symbol */

printf("%p\n", &bla); /* here we get value of linker symbol/address of
extern variable */

Currently I explicitly support only the latter and want to prevent the
former, until we have kernel variables in BTF. Using `extern void`
makes compiler enforce that only the &bla form is allowed. Everything
else is compilation error.

> 2. About the type size of ksym, IIUC, it looks strange that the values read from kallsyms have 8 bytes but their corresponding vs->size is 4 bytes and vs->type points to 4-byte int. Can we make them of the same size?

That's a bit of a hack on my part. Variable needs to point to some
type, which size will match the size of datasec's varinfo entry. This
is checked and enforced by kernel. I'm looking for 4-byte int, because
it's almost guaranteed that it will be present in program's BTF and I
won't have to explicitly add it (it's because all BPF programs return
int, so it must be in program's BTF already). While 8-byte long is
less likely to be there.

In the future, if we have a nicer way to extend BTF (and we will
soon), we can do this a bit better, but either way that .ksyms DATASEC
type isn't used for anything (there is no map with that DATASEC as a
value type), so it doesn't matter.

>
> Hao
>
> On Fri, Jun 12, 2020 at 3:35 PM Andrii Nakryiko <andriin@fb.com> wrote:
>>
>> Add support for another (in addition to existing Kconfig) special kind of
>> externs in BPF code, kernel symbol externs. Such externs allow BPF code to
>> "know" kernel symbol address and either use it for comparisons with kernel
>> data structures (e.g., struct file's f_op pointer, to distinguish different
>> kinds of file), or, with the help of bpf_probe_user_kernel(), to follow
>> pointers and read data from global variables. Kernel symbol addresses are
>> found through /proc/kallsyms, which should be present in the system.
>>
>> Currently, such kernel symbol variables are typeless: they have to be defined
>> as `extern const void <symbol>` and the only operation you can do (in C code)
>> with them is to take its address. Such extern should reside in a special
>> section '.ksyms'. bpf_helpers.h header provides __ksym macro for this. Strong
>> vs weak semantics stays the same as with Kconfig externs. If symbol is not
>> found in /proc/kallsyms, this will be a failure for strong (non-weak) extern,
>> but will be defaulted to 0 for weak externs.
>>
>> If the same symbol is defined multiple times in /proc/kallsyms, then it will
>> be error if any of the associated addresses differs. In that case, address is
>> ambiguous, so libbpf falls on the side of caution, rather than confusing user
>> with randomly chosen address.
>>
>> In the future, once kernel is extended with variables BTF information, such
>> ksym externs will be supported in a typed version, which will allow BPF
>> program to read variable's contents directly, similarly to how it's done for
>> fentry/fexit input arguments.
>>
>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> ---
>>  tools/lib/bpf/bpf_helpers.h |   1 +
>>  tools/lib/bpf/btf.h         |   5 ++
>>  tools/lib/bpf/libbpf.c      | 138 ++++++++++++++++++++++++++++++++++--
>>  3 files changed, 139 insertions(+), 5 deletions(-)
>>

[...]

>>
>>  enum extern_type {
>>         EXT_UNKNOWN,
>> +       EXT_KSYM,
>>
>>         EXT_KCFG,
>>  };
>
>
> Minor, let EXT_KSYM come after EXT_KCFG.

I wanted ksym externs to go before KCFG ones, but not sure why. I'll
double check, I don't think it should matter.

>
>>
>>

[...]

>> +static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
>> +{
>> +       char sym_type, sym_name[256];
>> +       unsigned long sym_addr;
>> +       struct extern_desc *ext;
>> +       int ret, err = 0;
>> +       FILE *f;
>> +
>> +       f = fopen("/proc/kallsyms", "r");
>> +       if (!f) {
>> +               err = -errno;
>> +               pr_warn("failed to open /proc/kallsyms: %d\n", err);
>> +               return err;
>> +       }
>> +
>> +       while (true) {
>> +               ret = fscanf(f, "%lx %c %s%*[^\n]\n",
>> +                            &sym_addr, &sym_type, sym_name);
>
>
> Maybe better follow the existing pattern in kernel (scripts/kallsyms.c https://github.com/torvalds/linux/blob/master/scripts/kallsyms.c#L177)


oh, didn't know about this "%499s" trick, will change.

>
>>
>> +               if (ret == EOF && feof(f))
>> +                       break;
>> +               if (ret != 3) {
>> +                       err = -EINVAL;
>> +                       goto out;
>> +               }
>> +

[...]
