Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B514A9F5B
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377622AbiBDSmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356104AbiBDSmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:42:05 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE9FC061714;
        Fri,  4 Feb 2022 10:42:05 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id z7so5591661ilb.6;
        Fri, 04 Feb 2022 10:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7ODX1hUqLfBCQaglsLxoSRLWLR0TSCQPHptU9mmOuVk=;
        b=MfZjMp/X4FBwJ0Qxm1yPk4M8QUzOc2pKlDV3LgL9lV+HP2xfWQtDz0jpLafr0r8gj8
         nxEN69sJhJmFMP+RUmAYGNow1nEsY6sWEE373lV2YW8+xVtJdNrFQxqKIjWAvQHMSzpg
         iwMs+JoRjdQ5bmnp3QKgoGko425fzxqZYTN2o79Hapt2ybFX02CsMi7+7hdF2gYBz3t6
         ZHoN9kPmGhOCpfZBZMxGrCKEemnygdrwgdBqnjOFscEr5wwZBhpKP4Nn7LTVPER2idte
         z0Q5O97mcZkKutO0dHb/009M1gFt/cyDl8wgrJhpumMddt02LsAU7fQeCzmn+FZ2GsGW
         8SoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ODX1hUqLfBCQaglsLxoSRLWLR0TSCQPHptU9mmOuVk=;
        b=Q534S0cuN/4IfU4qelzxITPo1wGIXPhDfog5FMqnx0x/nX4+qPPmFfE9BNhH1nPOFp
         YwgoJInhsZyl9QVvd1X8PJA4+rW3M5kyChdSyCMZ7oRZsoZVutujYVbhy8WXtH4r8IaL
         zO4Jp+ZxuaijqZGLaz/CKMlVi3PKIkXiUD6tlKcfR9jyXbTnP6k41G5+OMOWNNDBAinl
         iiVSe3pqorR6B6Q0gP/v5LRsvf+zEdfDXeKIYvx3tVZzmq5vH4Z1qV1+KKYkw7JmY+ZB
         vQgz2RuzTJVL8CvcCtdp3xzUzOlR4q8pca7u+41UaQqn5hG9PVMcReWiHmpIFY0jFItK
         N8kQ==
X-Gm-Message-State: AOAM532KmjKrK4M8h2XxzlQc1qaFwR0u2FfBvng5bVzGruUzNtwDCcux
        kSeMNYjxuXPaonQwcczqfCcDylNFpRzcxcs9pUo=
X-Google-Smtp-Source: ABdhPJxmIQ6e+4aYnU4HgkLOJ7/0u6L8uR72/NFzoDDH5DxhqeCVqPZs8G3OFW5eID3A6KKoinjV6dpDlo1FD/7VEgs=
X-Received: by 2002:a05:6e02:1a6c:: with SMTP id w12mr232140ilv.305.1644000125085;
 Fri, 04 Feb 2022 10:42:05 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-7-mauricio@kinvolk.io>
 <CAEf4BzZu-u1WXGScPZKVQZc+RGjmnYm45mcOGkzXyFLMKS-5gA@mail.gmail.com>
 <CAHap4zv+bLA4BB9ZJ7RXDCChe6dU0AB3zuCieWskp2OJ5Y-4xw@mail.gmail.com>
 <CAEf4BzagOBmVbrPOnSwthOxt7CYoqNTuojbtmgskNa_Ad=8EVQ@mail.gmail.com> <8846F5AD-CFD3-4F32-B9C5-E36AB38C37DF@gmail.com>
In-Reply-To: <8846F5AD-CFD3-4F32-B9C5-E36AB38C37DF@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Feb 2022 10:41:54 -0800
Message-ID: <CAEf4BzbqXJaAiPgdGi3wNvbLXaRdZ_VL-XLBTjHQ=y8X5RHgXA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 6/9] bpftool: Implement relocations recording
 for BTFGen
To:     Rafael David Tinoco <rafaeldtinoco@gmail.com>
Cc:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 10:20 PM Rafael David Tinoco
<rafaeldtinoco@gmail.com> wrote:
>
> >>> As in, do you substitute forward declarations for types that are
> >>> never directly used? If not, that's going to be very suboptimal for
> >>> something like task_struct and any other type that's part of a big
> >>> cluster of types.
>
> >> We decided to include the whole types and all direct and indirect
> >> types referenced from a structure field for type-based relocations.
> >> Our reasoning is that we don't know if the matching algorithm of
> >> libbpf could be changed to require more information in the future and
> >> type-based relocations are few compared to field based relocations.
>
> > It will depend on application and which type is used in relocation.
> > task_struct reaches tons of types and will add a very noticeable size
> > to minimized BTF, for no good reason, IMO. If we discover that we do
> > need those types, we'll update bpftool to generate more.
>
> Just to see if I understood this part correctly. IIRC, we started type
> based relocations support in btfgen because of this particular case:
>
>         union kernfs_node_id {
>             struct {
>                 u32 ino;
>                 u32 generation;
>             };
>             u64 id;
>         };
>
>         struct kernfs_node___older_v55 {
>             const char *name;
>             union kernfs_node_id id;
>         };
>
>         struct kernfs_node___rh8 {
>             const char *name;
>             union {
>                 u64 id;
>                 struct {
>                     union kernfs_node_id id;
>                 } rh_kabi_hidden_172;
>                 union { };
>             };
>         };
>
> So we have 3 situations:
>
> (struct kernfs_node *)->id as u64
>
>         [29] STRUCT 'kernfs_node' size=128 vlen=1
>                 'id' type_id=42 bits_offset=832
>         [42] TYPEDEF 'u64' type_id=10
>
> (struct kernfs_node___older_v55 *)->id as u64 (union kernfs_node_id)->id
>
>         [79] STRUCT 'kernfs_node' size=128 vlen=1
>                 'id' type_id=69 bits_offset=832
>         [69] UNION 'kernfs_node_id' size=8 vlen=2
>                 '(anon)' type_id=132 bits_offset=0
>                 'id' type_id=40 bits_offset=0
>         [40] TYPEDEF 'u64' type_id=12
>
> (struct kernfs_node___rh8 *)->id = (anon union)->id
>
>         [56] STRUCT 'kernfs_node' size=128 vlen=1
>                 '(anon)' type_id=24 bits_offset=832
>         [24] UNION '(anon)' size=8 vlen=1
>                 'id' type_id=40 bits_offset=0
>         [40] TYPEDEF 'u64' type_id=11
>
> We're finding needed BTF types, that should be added to generated BTF,
> based on fields/members of CORE relo info. How we would know we had to
> add the anon union of the last case if it does not exist in the local
> BTF ? What is your suggestion ?
>

I'd need to see real BPF program code for this situation, but if you
don't have field-based relocation that needs that anonymous union,
then it shouldn't matter if that union is there or not. I suspect you
do have field-based relocations that access fields of struct
kernfs_node___rh8 and kernfs_node___older_v55, so both structs and
necessary fields should be marked as "used" by btfgen algorithm.

> Thanks!
>
> -rafaeldtinoco
