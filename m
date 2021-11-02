Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8C74437CA
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 22:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhKBV3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 17:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhKBV3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 17:29:11 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34877C061714
        for <netdev@vger.kernel.org>; Tue,  2 Nov 2021 14:26:34 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id t11so432366ljh.6
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 14:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uItLnRAHYLiuQK2hAUmCgUVAWaO1VnqxXTT3rliPgA4=;
        b=EJfjUG9jNAqK6Mhsu6Sln2orQ6XxNP9jqs8EeMgAQErKLvSFeByKLPQG2kXGwd3ENJ
         WiSL00Gq3hVfGwYdXhTSyutrAezjbzgH6LmVgkjV1N7V4QGn2kqjXY+rdcSd+Hnx65Lq
         kaZxaByFmMAOQpQRLSA5au8gP03veeoVZaUBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uItLnRAHYLiuQK2hAUmCgUVAWaO1VnqxXTT3rliPgA4=;
        b=C92V4gD2Q07qmuShyVsRbQxUh2uJ8TyiBo6Uei8LGWLUXuowEb20xMqcK9jwrRxTU9
         f9Sm6iFmnOwEuTXS1SOXuuNgT08otkd5Ksv1exKKOouTdzOX7eO4/EIjWslZ9ePzGvqs
         UCRoVhNRHqkqyWmwury05foVMfv+56T8mpDPp9YADnT+8Rz1pWrqy6GNKxZz7X2rNow7
         lkbkTTQ6s9a5H8eYE3Opuk7O9CGmnoPwxJ7ooS6pPnk+d0kiB3AWIpf+Yw/9nT3clPjU
         eBHfnHh7LMSsX1r7Qp2Mh5uMauPLdlnluJB4PWMjYHsLEMxiy679svzc+3ikSFyzkk4H
         i9XA==
X-Gm-Message-State: AOAM531LudWDRd4VJVs62xhScFkr8JxIWoqBFplvyuGmvvXBY8odqJjI
        tBqlSw/HUk4BqneK+KUw1GWYBtX11HNl/Q7VKSfN3A==
X-Google-Smtp-Source: ABdhPJwqux2jIRpOea05LMTtwMbunx5/Ds/j15vbbzBK3iM9otzu74Tkaoi6rq6wsTBJSnC0fFPk6Q9VoiXKq7kR0vM=
X-Received: by 2002:a2e:9c14:: with SMTP id s20mr5354526lji.266.1635888392226;
 Tue, 02 Nov 2021 14:26:32 -0700 (PDT)
MIME-Version: 1.0
References: <20211027203727.208847-1-mauricio@kinvolk.io> <CAADnVQK2Bm7dDgGc6uHVosuSzi_LT0afXM6Hf3yLXByfftxV1Q@mail.gmail.com>
 <CAHap4zt7B1Zb56rr55Q8_cy8qdyaZsYcWt7ZHrs3EKr50fsA+A@mail.gmail.com> <CAEf4BzbDBGEnztzEcXmCFMNyzTjJ3pY41ahzieu9yJ+EDHU0dg@mail.gmail.com>
In-Reply-To: <CAEf4BzbDBGEnztzEcXmCFMNyzTjJ3pY41ahzieu9yJ+EDHU0dg@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Tue, 2 Nov 2021 16:26:21 -0500
Message-ID: <CAHap4zutG7KXywstCHcTbATN8iVCKuN84ZHxLfdsXDJS9sDmEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] libbpf: Implement BTF Generator API
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Part #2 absolutely doesn't belong in libbpf. Libbpf exposes enough BTF
> constructing APIs to implement this in any application, bpftool or
> otherwise. It's also a relatively straightforward problem: mark used
> types and fields, create a copy of BTF with only those types and
> fields.

Totally agree.

> The last point is important, because to solve the problem 1b (exposing
> CO-RE relo info), the best way to minimize public API commitments is
> to (optionally, probably) request libbpf to record its CO-RE relo
> decisions. Here's what I propose, specifically:
>   1. Add something like "bool record_core_relo_info" (awful name,
> don't use it) in bpf_object_open_opts.
>   2. If it is set to true, libbpf will keep a "log" of CO-RE
> relocation decisions, recording stuff like program name, instruction
> index, local spec (i.e., root_type_id, spec string, relo kind, maybe
> something else), target spec (kernel type_id, kernel spec string, also
> module ID, if it's not vmlinux BTF). We can also record relocated
> value (i.e., field offset, actual enum value, true/false for
> existence, etc). All these are stable concepts, so I'd feel more
> comfortable exposing them, compared to stuff like bpf_core_accessor
> and other internal details.
>   3. The memory for all that will be managed by libbpf for simplicity
> of an API, and we'll expose accessors to get those arrays (at object
> level or per-program level is TBD).
>   4. This info will be available after the prepare() step and will be
> discarded either at create_maps() or load().

I like all this proposal. It fits very well with the BTFGen use case.

Regarding the information to expose, IIUC that'd be slight versions of
struct bpf_core_relo_res and struct bpf_core_spec. I think we could
expose the following structures and a function to get it (please
ignore the naming for now):

```
/* reduced version of struct bpf_core_spec */
struct bpf_core_spec_pub {
const struct btf *btf;
__u32 root_type_id;
enum bpf_core_relo_kind kind;
/* raw, low-level spec: 1-to-1 with accessor spec string */ --> we can
also use access_str_off and let the user parse it
int raw_spec[BPF_CORE_SPEC_MAX_LEN];
/* raw spec length */
int raw_len;
};

struct bpf_core_relo_pub {
const char *prog_name; --> if we expose it by program then it's not needed.
int insn_idx;

bool poison; --> allows the user to understand if the relocation
succeeded or not.

/* new field offset for field based core relos */
__u32 new_offset;

// TODO: fields for type and enum-based relos

struct bpf_core_spec_pub local_spec, targ_spec; --> BTFGen only needs
targ_spec, I suppose local spec would be useful for other use cases.
};

LIBBPF_API struct bpf_core_relo_pub *bpf_program__core_relos(struct
bpf_program *prog);
```

I don't have strong opinions about exposing it by object or by
program. Both cases should work the same for BTFGen.

Does it make sense to you?

Btw, I'm probably not the right person to give opinions about this API
splitment. I'd be happy to have other opinions here and to make this
change once we agree on a path forward.
