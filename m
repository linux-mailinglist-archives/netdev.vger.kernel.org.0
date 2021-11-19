Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2BA457569
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 18:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbhKSR2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 12:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhKSR2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 12:28:17 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5338C061574;
        Fri, 19 Nov 2021 09:25:15 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id n2so25809197yba.2;
        Fri, 19 Nov 2021 09:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pCBiavxBuqxxK+6oz6nLWeSo45Gu0oX9PmaxhSwJXSI=;
        b=pMEOQL+9F6O4VSb959TXev/SqBe1ClrAu9VNlyvhMs6+2PeN0se/ecAHRJxcidkAp7
         Y2XMd9Qhofka/0/gidWQ8s3cclCENNn06l2qCb6pAIn8ypMYKoVguh4I40XiCL/Abwgb
         AwB0MF8UOC4jpJdb1Vm4mDYA0IXUUlHJargyqSOBr3eIRxKA6K8VU+BBfqNgngcEW8Ja
         ESbOlqpgeCuPg4WL9vZON40a5x1iKmEHQJLAsTcStKeeFB7IThWckUH34gKWQGmHccP5
         noV9U4odE4duh0yMttE1tkFyrEiGOGYocnrZbVAJX19A1b8FvgOLsPrlwWjmHBrYmPee
         /dYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pCBiavxBuqxxK+6oz6nLWeSo45Gu0oX9PmaxhSwJXSI=;
        b=CZjLI/7NVbw/yzAeQvKN2g9NjWkdcOsmNATHaBrdkC7jfTFdydvGLI6lLdKW/AdOuz
         /UFK1mIX/l96Gib6pnXWvQvVexvZAAO7bvQ/Dzi5LuKiKz9kE+7OcPVRwUa8nDp+qUkZ
         8LxLeELnPpNbPwHQfq3NdRPHEdNRVeSMYio86ojrJEvi8fB4cvZhvnrO3vmjUNv/MX/h
         MnB1MdBTXVqDh4CNXCi2En0pqhYdOLjeVM2THD7YoF1EMHQZ2LJwlLmGXoUfcXPj0sbp
         YIoMFKZWyex/vbkDPXlQnHhrbg/IJ6Ktuw75g9yRvtLr1EZLtoqs/R2b9NahQoU+vocH
         LHTA==
X-Gm-Message-State: AOAM532y8zFrQN0oBmDwa7TlePi5KL7JkwYfaHdtl0W6/KNpC8sgwhFh
        oKUOIo7X+ZoqDSdAfqIq10eAEtO4OD5MT6XSw66OZRI8D/U=
X-Google-Smtp-Source: ABdhPJy4cbwacDjCWqrysIoLCLR4DqwoZkoOdCfOS4ofuHeVBh6JIeAyNAJhOg3aHuNoWjQCB7qlcw96ii9yPXXeQz0=
X-Received: by 2002:a25:d16:: with SMTP id 22mr38566464ybn.51.1637342715080;
 Fri, 19 Nov 2021 09:25:15 -0800 (PST)
MIME-Version: 1.0
References: <20211116164208.164245-1-mauricio@kinvolk.io> <20211116164208.164245-5-mauricio@kinvolk.io>
In-Reply-To: <20211116164208.164245-5-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Nov 2021 09:25:03 -0800
Message-ID: <CAEf4BzZ0pEXzEvArpzL=0qbVC65z=hmeVuP7cbLKk-0_Gv5Y+A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] libbpf: Expose CO-RE relocation results
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 8:42 AM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> The result of the CO-RE relocations can be useful for some use cases
> like BTFGen[0]. This commit adds a new =E2=80=98record_core_relos=E2=80=
=99 option to
> save the result of such relocations and a couple of functions to access
> them.
>
> [0]: https://github.com/kinvolk/btfgen/
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/lib/bpf/libbpf.c    | 63 ++++++++++++++++++++++++++++++++++++++-
>  tools/lib/bpf/libbpf.h    | 49 +++++++++++++++++++++++++++++-
>  tools/lib/bpf/libbpf.map  |  2 ++
>  tools/lib/bpf/relo_core.c | 28 +++++++++++++++--
>  tools/lib/bpf/relo_core.h | 21 ++-----------
>  5 files changed, 140 insertions(+), 23 deletions(-)
>

Ok, I've meditated on this patch set long enough. I still don't like
that libbpf will be doing all this just for the sake of BTFGen's use
case.

In the end, I think giving bpftool access to internal APIs of libbpf
is more appropriate, and it seems like it's pretty easy to achieve. It
might actually clean up gen_loader parts a bit as well. So we'll need
to coordinate all this with Alexei's current work on CO-RE for kernel
as well.

But here's what I think could be done to keep libbpf internals simple.
We split bpf_core_apply_relo() into two parts: 1) calculating the
struct bpf_core_relo_res and 2) patching the instruction. If you look
at bpf_core_apply_relo, it needs prog just for prog_name (which we can
just pass everywhere for logging purposes) and to extract one specific
instruction to be patched. This instruction is passed at the very end
to bpf_core_patch_insn() after bpf_core_relo_res is calculated. So I
propose to make those two explicitly separate steps done by libbpf. So
bpf_core_apply_relo() (which we should rename to bpf_core_calc_relo()
or something like that) won't do any modification to the program
instructions. bpf_object__relocate_core() will do bpf_core_calc_relo()
first, if that's successful, it will pass the result into
bpf_core_patch_insn(). Simple and clean, unless I missed some
complication (happens all the time, but..)

At this point, we can teach bpftool to just take btf_ext (from BPF
object file), iterate over all CO-RE relos and call only
bpf_core_calc_relo() (no instruction patching). Using
bpf_core_relo_res bpftool will know types and fields that need to be
preserved and it will be able to construct minimal btf. So interface
for bpftool looks like this:

   bpftool gen distill_btf (or whatever the name) <file.bpf.o>
<distilled_raw.btf>

BTFGen as a solution, then, can use bpftool to process each pair of
btf + bpf object.

Thoughts?

[...]
