Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF891443CB0
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 06:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhKCF2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 01:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhKCF2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 01:28:50 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B6CC061714;
        Tue,  2 Nov 2021 22:26:13 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id v7so3802108ybq.0;
        Tue, 02 Nov 2021 22:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V1GdT6iYRhMl0O3PwXIC9/pxYDVMZJJQxm9Rz3StFos=;
        b=VncHJlvodE/soRLjdPpvkK440ZKU5LHYlcSvZZiGWLZ60vKSYNosCoqawM/5y/58W3
         NccfsJ9ect2eUu6/udebs7itiYb9U67TqUjx0qJXu2yh+NEzRVnobsac4M+6s7MdwL5a
         xD5K2Vs7p8vsg7i3QMeGvQ1VFl070t0HzJkagVqUbwjmNlOkKEDD5dpTpqwWWpYsXE5A
         0pb+U73FUCvLSvS1NDQmpztR/i7OrK+uw8qRSShFacJ9s2n1od3AAeo93KelUyh+bewQ
         QASu+lndgsAG5M3GkUsnU8NaWrFN8aJ+HbBrV3/WkKx13Qq7P6qSuucz4xHOKfDwqWJ1
         ybBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V1GdT6iYRhMl0O3PwXIC9/pxYDVMZJJQxm9Rz3StFos=;
        b=JyG3gy9sV64pHHWIB/RW2URQs5aqWSahFQBu/4XE1nKNdaAuFE9VSboJZJVVQGG0T5
         +DOUqlwmgaXJSmL8YY8X7oQ0D/0P3OHIP3KhkWdJDn+0QUTTZag9IvFdI7TUL/ml+2QF
         ReOWz7h83EBD65zWOa1bHAoIuK5tW1iCi4bIBCfIojL71yeuiSroPNJUrkiTXyj2FRJb
         +M8vwFCtuENPWvSUl4Joec1Oo9ew617frgKvEYH7yuTG8P7Uq/UDpv7mU6bcr+mqgYbF
         7ZRpLb0zN9Nu82ipvcgTzQY2Mk+iDt0EDOaJBu9N7XTVmjawZ+f7bmt17aBVDPH290UI
         I+6Q==
X-Gm-Message-State: AOAM533RnvN+mUcjwWCTk9gfdhQJ5XPaq0iVFnkB84PFGZJblxGca98P
        yfC8OsqyrVjmaPJyy8bKuWVRC3X7JIvVc7UhuQs=
X-Google-Smtp-Source: ABdhPJxAFLoqpFfsskTCrDrH8/bPFaby51xitvLdDIzA5GeYAglji5m9CvpHMRNyBsrANEnCO1Y6YWa1xZmVhWDrOOA=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr45794415ybj.504.1635917172631;
 Tue, 02 Nov 2021 22:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211027203727.208847-1-mauricio@kinvolk.io> <CAADnVQK2Bm7dDgGc6uHVosuSzi_LT0afXM6Hf3yLXByfftxV1Q@mail.gmail.com>
 <CAHap4zt7B1Zb56rr55Q8_cy8qdyaZsYcWt7ZHrs3EKr50fsA+A@mail.gmail.com>
 <CAEf4BzbDBGEnztzEcXmCFMNyzTjJ3pY41ahzieu9yJ+EDHU0dg@mail.gmail.com> <CAHap4zutG7KXywstCHcTbATN8iVCKuN84ZHxLfdsXDJS9sDmEA@mail.gmail.com>
In-Reply-To: <CAHap4zutG7KXywstCHcTbATN8iVCKuN84ZHxLfdsXDJS9sDmEA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 2 Nov 2021 22:26:01 -0700
Message-ID: <CAEf4BzbALXu7ucrVcNdT38od5fU2Cd9qMncbXGJGe-KG1NOdNw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] libbpf: Implement BTF Generator API
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 2:26 PM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> > Part #2 absolutely doesn't belong in libbpf. Libbpf exposes enough BTF
> > constructing APIs to implement this in any application, bpftool or
> > otherwise. It's also a relatively straightforward problem: mark used
> > types and fields, create a copy of BTF with only those types and
> > fields.
>
> Totally agree.
>
> > The last point is important, because to solve the problem 1b (exposing
> > CO-RE relo info), the best way to minimize public API commitments is
> > to (optionally, probably) request libbpf to record its CO-RE relo
> > decisions. Here's what I propose, specifically:
> >   1. Add something like "bool record_core_relo_info" (awful name,
> > don't use it) in bpf_object_open_opts.
> >   2. If it is set to true, libbpf will keep a "log" of CO-RE
> > relocation decisions, recording stuff like program name, instruction
> > index, local spec (i.e., root_type_id, spec string, relo kind, maybe
> > something else), target spec (kernel type_id, kernel spec string, also
> > module ID, if it's not vmlinux BTF). We can also record relocated
> > value (i.e., field offset, actual enum value, true/false for
> > existence, etc). All these are stable concepts, so I'd feel more
> > comfortable exposing them, compared to stuff like bpf_core_accessor
> > and other internal details.
> >   3. The memory for all that will be managed by libbpf for simplicity
> > of an API, and we'll expose accessors to get those arrays (at object
> > level or per-program level is TBD).
> >   4. This info will be available after the prepare() step and will be
> > discarded either at create_maps() or load().
>
> I like all this proposal. It fits very well with the BTFGen use case.
>
> Regarding the information to expose, IIUC that'd be slight versions of
> struct bpf_core_relo_res and struct bpf_core_spec. I think we could
> expose the following structures and a function to get it (please
> ignore the naming for now):
>
> ```
> /* reduced version of struct bpf_core_spec */
> struct bpf_core_spec_pub {
> const struct btf *btf;
> __u32 root_type_id;
> enum bpf_core_relo_kind kind;
> /* raw, low-level spec: 1-to-1 with accessor spec string */ --> we can
> also use access_str_off and let the user parse it
> int raw_spec[BPF_CORE_SPEC_MAX_LEN];

string might be a more "extensible" way, but we'll need to construct
that string for each relocation

> /* raw spec length */
> int raw_len;

using string would eliminate the need for this

> };
>
> struct bpf_core_relo_pub {
> const char *prog_name; --> if we expose it by program then it's not neede=
d.

yep, not sure about per-program yet, but that's minor

> int insn_idx;
>
> bool poison; --> allows the user to understand if the relocation
> succeeded or not.
>
> /* new field offset for field based core relos */
> __u32 new_offset;
>
> // TODO: fields for type and enum-based relos

isn't it always just u64 new_value for all types of relos? We can also
expose old_value just for completeness

>
> struct bpf_core_spec_pub local_spec, targ_spec; --> BTFGen only needs
> targ_spec, I suppose local spec would be useful for other use cases.

targ_spec doesn't seem necessary given we have root_type_id, relo
kind, access_string (or raw_spec). What am I missing?


> };
>
> LIBBPF_API struct bpf_core_relo_pub *bpf_program__core_relos(struct
> bpf_program *prog);

need also size of this array and it should be const struct *, but
yeah, something like this

> ```
>
> I don't have strong opinions about exposing it by object or by
> program. Both cases should work the same for BTFGen.
>
> Does it make sense to you?

Yeah, more or less.

>
> Btw, I'm probably not the right person to give opinions about this API
> splitment. I'd be happy to have other opinions here and to make this
> change once we agree on a path forward.
