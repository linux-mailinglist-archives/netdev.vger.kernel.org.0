Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471C24BF1DE
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 07:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiBVGFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 01:05:53 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiBVGFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 01:05:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6D09D0E5;
        Mon, 21 Feb 2022 22:05:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E540660F49;
        Tue, 22 Feb 2022 06:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479F6C36AE3;
        Tue, 22 Feb 2022 06:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645509926;
        bh=sTgSEKKoICol33yrPaBoC5i5Zy7dMIxDHtgX1m8Wif0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jvYiGVqzS6uC1sMS0YYUMW6roBhxyPQvTtRoYJ0CfpSX2zjuHbSyAQ2B0eIo7X/f/
         EVBdm/n8jGfiJhbxwqLnvC03t0JCe4KM8WLrLyGS/bPhwADxipv7EB/xhUhjrUQrvG
         jO8dvEUyBu/UodszQHrpSzGUERMSQfsmWfPxi30tSSwcQZXAARHA+gSMOJp267OWUH
         FssrCn8iodiohTSACoC1WzjrlrYYH06X4x318t6xQnAldW79CGM10tTd+bs8YyjqsR
         vYQVRZnVNnui4ojM7AYGRoPiX8MR/QEcTZmbMEd2rfzVQjesMH2IlXv4RNogekiLQI
         faFKZcMxgh5aA==
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-2d310db3812so161780817b3.3;
        Mon, 21 Feb 2022 22:05:26 -0800 (PST)
X-Gm-Message-State: AOAM5333sBR/IMjP/1CjBkyI9ZGNcX7R0TxRoqMBkfZGxz7rffLRwzRQ
        i8Oq60bwSpWg+BwcQHM7cj7nV0sQzaSt3/hW1iI=
X-Google-Smtp-Source: ABdhPJzEZ/bEc8cwZMK0aBgwowso24AHWiaqSakzFUZIobZmtbYInj/25T2cMOnwraye3UOTl0ZiQabsjfRQcJc3oNA=
X-Received: by 2002:a81:9895:0:b0:2d7:7e75:9ba8 with SMTP id
 p143-20020a819895000000b002d77e759ba8mr4335827ywg.130.1645509925349; Mon, 21
 Feb 2022 22:05:25 -0800 (PST)
MIME-Version: 1.0
References: <20220220134813.3411982-1-memxor@gmail.com>
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 21 Feb 2022 22:05:14 -0800
X-Gmail-Original-Message-ID: <CAPhsuW53epuRQ3X5bYeoxRUL9sdEm7MUQ8bUoQCsf=C7k3hQ8A@mail.gmail.com>
Message-ID: <CAPhsuW53epuRQ3X5bYeoxRUL9sdEm7MUQ8bUoQCsf=C7k3hQ8A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 00/15] Introduce typed pointer support in BPF maps
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 20, 2022 at 5:48 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> Introduction
> ------------
>
> This set enables storing pointers of a certain type in BPF map, and extends the
> verifier to enforce type safety and lifetime correctness properties.
>
> The infrastructure being added is generic enough for allowing storing any kind
> of pointers whose type is available using BTF (user or kernel) in the future
> (e.g. strongly typed memory allocation in BPF program), which are internally
> tracked in the verifier as PTR_TO_BTF_ID, but for now the series limits them to
> four kinds of pointers obtained from the kernel.
>
> Obviously, use of this feature depends on map BTF.
>
> 1. Unreferenced kernel pointer
>
> In this case, there are very few restrictions. The pointer type being stored
> must match the type declared in the map value. However, such a pointer when
> loaded from the map can only be dereferenced, but not passed to any in-kernel
> helpers or kernel functions available to the program. This is because while the
> verifier's exception handling mechanism coverts BPF_LDX to PROBE_MEM loads,
> which are then handled specially by the JIT implementation, the same liberty is
> not available to accesses inside the kernel. The pointer by the time it is
> passed into a helper has no lifetime related guarantees about the object it is
> pointing to, and may well be referencing invalid memory.
>
> 2. Referenced kernel pointer
>
> This case imposes a lot of restrictions on the programmer, to ensure safety. To
> transfer the ownership of a reference in the BPF program to the map, the user
> must use the BPF_XCHG instruction, which returns the old pointer contained in
> the map, as an acquired reference, and releases verifier state for the
> referenced pointer being exchanged, as it moves into the map.
>
> This a normal PTR_TO_BTF_ID that can be used with in-kernel helpers and kernel
> functions callable by the program.
>
> However, if BPF_LDX is used to load a referenced pointer from the map, it is
> still not permitted to pass it to in-kernel helpers or kernel functions. To
> obtain a reference usable with helpers, the user must invoke a kfunc helper
> which returns a usable reference (which also must be eventually released before
> BPF_EXIT, or moved into a map).
>
> Since the load of the pointer (preserving data dependency ordering) must happen
> inside the RCU read section, the kfunc helper will take a pointer to the map
> value, which must point to the actual pointer of the object whose reference is
> to be raised. The type will be verified from the BTF information of the kfunc,
> as the prototype must be:
>
>         T *func(T **, ... /* other arguments */);
>
> Then, the verifier checks whether pointer at offset of the map value points to
> the type T, and permits the call.
>
> This convention is followed so that such helpers may also be called from
> sleepable BPF programs, where RCU read lock is not necessarily held in the BPF
> program context, hence necessiating the need to pass in a pointer to the actual
> pointer to perform the load inside the RCU read section.
>
> 3. per-CPU kernel pointer
>
> These have very little restrictions. The user can store a PTR_TO_PERCPU_BTF_ID
> into the map, and when loading from the map, they must NULL check it before use,
> because while a non-zero value stored into the map should always be valid, it can
> still be reset to zero on updates. After checking it to be non-NULL, it can be
> passed to bpf_per_cpu_ptr and bpf_this_cpu_ptr helpers to obtain a PTR_TO_BTF_ID
> to underlying per-CPU object.
>
> It is also permitted to write 0 and reset the value.
>
> 4. Userspace pointer
>
> The verifier recently gained support for annotating BTF with __user type tag.
> This indicates pointers pointing to memory which must be read using the
> bpf_probe_read_user helper to ensure correct results. The set also permits
> storing them into the BPF map, and ensures user pointer cannot be stored
> into other kinds of pointers mentioned above.
>
> When loaded from the map, the only thing that can be done is to pass this
> pointer to bpf_probe_read_user. No dereference is allowed.
>

I guess I missed some context here. Could you please provide some reference
to the use cases of these features?

For Unreferenced kernel pointer and userspace pointer, it seems that there is
no guarantee the pointer will still be valid during access (we only know it is
valid when it is stored in the map). Is this correct?

Thanks,
Song

[...]
