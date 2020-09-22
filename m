Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD81273ED6
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 11:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIVJtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 05:49:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726548AbgIVJtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 05:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600768144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C7pld8CF2XoWB/dz/mweeUUMdCoVXOEtidPbZSC2mYk=;
        b=MwJeBWCUInIi/tJyhYCUsIk0WiK8Qip47q2iBDF61QUK8THhjigJKkedI7znhMbZ5Po3SB
        vq4g54Npp1RKYnin/XOYnLrS8iWS5+Cno2Kh3krP/amb4qpvnnJmKAjgvieP0ytMWcTsEe
        SegB0O74tznUlzUvFB0Xt+DSWZjIqSE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-AL8NEGhZPVK--qAaNYJGdA-1; Tue, 22 Sep 2020 05:49:01 -0400
X-MC-Unique: AL8NEGhZPVK--qAaNYJGdA-1
Received: by mail-pg1-f200.google.com with SMTP id t3so10080665pgc.21
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 02:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=C7pld8CF2XoWB/dz/mweeUUMdCoVXOEtidPbZSC2mYk=;
        b=WJOl06yTdJqSDZgAbkGkx4WkZFm6wYQ8vgjOEPcrIfD1KGpldTJ4X0edPqb0SHDs4O
         1wfFY7WnmUDmVYKhEwBBkujkGUFIOfYe8871sGwMz7kHGuoOKqDI+GTAq0l4p2oXaY0T
         8j4nVqYTdq6JrnYUIBYQAo2vLejECikRqWWoCsCopM8BGuMD5d9thV/smDz2HxJGnmxG
         50iPrTEcbnKtl+s9SfF6vHcPOykBTH5lqHltoWmEMvV0pAOrBdN4x9fHLukdchUX3BiW
         BxDRNCCTzZpHZTvkaUvuZXviPdW6vMoGstXVmKl9WRodYqjJzhrpG9jy1yZIaOLt5bsq
         uTGw==
X-Gm-Message-State: AOAM532yMOXi11wgov3WjhL2dhvXldYuSdDqvkvvHsqJnc/Grd0TQYj5
        htSetOqZhMPL8xAu1i8MgsJwX7ZLXTG7F/hEekZHBBsCvQX49R8zTTyqAt7YXXm0/aRMK3vRCV+
        zeVZyb2Ctkhzz/OOK
X-Received: by 2002:a65:5cc5:: with SMTP id b5mr2848416pgt.417.1600768140424;
        Tue, 22 Sep 2020 02:49:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRkjLs32HCIaPCnYQAVYeZEICRf64Td+jyJVxWQIFB2+3NglYYYXu9OGcfcQ9khQaoP2qtfg==
X-Received: by 2002:a65:5cc5:: with SMTP id b5mr2848403pgt.417.1600768140106;
        Tue, 22 Sep 2020 02:49:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id c7sm15056412pfj.100.2020.09.22.02.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 02:48:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 89A12183A99; Tue, 22 Sep 2020 11:48:54 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v7 00/10] bpf: Support multi-attach for
 freplace programs
In-Reply-To: <CAEf4BzZbUrTKS9utppKCiBqkeybBEQQgwjqJhSz8FJyiK32VHA@mail.gmail.com>
References: <160051618267.58048.2336966160671014012.stgit@toke.dk>
 <CAEf4BzZbUrTKS9utppKCiBqkeybBEQQgwjqJhSz8FJyiK32VHA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Sep 2020 11:48:54 +0200
Message-ID: <87tuvqp2ex.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Sat, Sep 19, 2020 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> This series adds support attaching freplace BPF programs to multiple tar=
gets.
>> This is needed to support incremental attachment of multiple XDP program=
s using
>> the libxdp dispatcher model.
>>
>> The first patch fixes an issue that came up in review: The verifier will
>> currently allow MODIFY_RETURN tracing functions to attach to other BPF p=
rograms,
>> even though it is pretty clear from the commit messages introducing the
>> functionality that this was not the intention. This patch is included in=
 the
>> serise because the subsequent refactoring patches touch the same code.
>>
>> The next three patches are refactoring patches: Patch 2 is a trivial cha=
nge to
>> the logging in the verifier, split out to make the subsequent refactor e=
asier to
>> read. Patch 3 refactors check_attach_btf_id() so that the checks on prog=
ram and
>> target compatibility can be reused when attaching to a secondary locatio=
n.
>>
>> Patch 4 moves prog_aux->linked_prog and the trampoline to be embedded in
>> bpf_tracing_link on attach, and freed by the link release logic, and int=
roduces
>> a mutex to protect the writing of the pointers in prog->aux.
>>
>> Based on these refactorings, it becomes pretty straight-forward to suppo=
rt
>> multiple-attach for freplace programs (patch 5). This is simply a matter=
 of
>> creating a second bpf_tracing_link if a target is supplied. However, for=
 API
>> consistency with other types of link attach, this option is added to the
>> BPF_LINK_CREATE API instead of extending bpf_raw_tracepoint_open().
>>
>> Patch 6 is a port of Jiri Olsa's patch to support fentry/fexit on frepla=
ce
>> programs. His approach of getting the target type from the target program
>> reference no longer works after we've gotten rid of linked_prog (because=
 the
>> bpf_tracing_link reference disappears on attach). Instead, we used the s=
aved
>> reference to the target prog type that is also used to verify compatibil=
ity on
>> secondary freplace attachment.
>>
>> Patches 7 is the accompanying libbpf update, and patches 8-10 are selfte=
sts:
>> patch 8 tests for the multi-freplace functionality itself, patch 9 is Ji=
ri's
>> previous selftest for the fentry-to-freplace fix, and patch 10 is a test=
 for
>> the change introduced in patch 1, blocking MODIFY_RETURN functions from
>> attaching to other BPF programs.
>>
>> With this series, libxdp and xdp-tools can successfully attach multiple =
programs
>> one at a time. To play with this, use the 'freplace-multi-attach' branch=
 of
>> xdp-tools:
>>
>> $ git clone --recurse-submodules --branch freplace-multi-attach https://=
github.com/xdp-project/xdp-tools
>> $ cd xdp-tools/xdp-loader
>> $ make
>> $ sudo ./xdp-loader load veth0 ../lib/testing/xdp_drop.o
>> $ sudo ./xdp-loader load veth0 ../lib/testing/xdp_pass.o
>> $ sudo ./xdp-loader status
>>
>> The series is also available here:
>> https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=3D=
bpf-freplace-multi-attach-alt-07
>>
>> Changelog:
>>
>> v7:
>>   - Add back missing ptype =3D=3D prog->type check in link_create()
>>   - Use tracing_bpf_link_attach() instead of separate freplace_bpf_link_=
attach()
>>   - Don't break attachment of bpf_iters in libbpf
>
> What was specifically the issue and the fix for bpf_iters?

It was in libbpf - after making the attr passed to the kernel a union, I
was still unconditionally writing to the target_btf_id field, clobbering
the iter pointer. Which is also why it still happened even with a kernel
that didn't have the patch applied: I forgot to recompile the selftest :)

-Toke

