Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6404BF37E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 09:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiBVIV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 03:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiBVIV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 03:21:58 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB1F55BC2;
        Tue, 22 Feb 2022 00:21:32 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id t4-20020a17090a3b4400b001bc40b548f9so1715497pjf.0;
        Tue, 22 Feb 2022 00:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ASqSsrhSJTPhhRTmHJa6rLZ0juV1bYbfnhOAxny8cKg=;
        b=JEL6s72nsNb2b0zG2g+1J0ABzkFbDLmW+aVp4wVgJXvZmtjfei313oIbiLJJ3Ombal
         Laho50ihOG87T7/aclTDNKjk7LZ9Q7S8azfcoLphndzoCJBEZ+FrVdW+VN60rbQKctVl
         SKXklWVKUiKkS79XorY0Hkj1g630PIa/xtyCba4cw6mPvjpFWj7AM2FgtIcE0PHg12Ed
         OXDHdjg41Xz7EcwBTewRuVBscdeNaADJnzsiU7vuL9nfJguuk/1TKwa/xJ/Vw+oyd6rQ
         0cVZL4qOQ+lr96G/mkvEF08poVhhrMccOg8ONk7FVC6HCpVP8Xl++Xv58AgxqvWWEkel
         lP6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ASqSsrhSJTPhhRTmHJa6rLZ0juV1bYbfnhOAxny8cKg=;
        b=YZxTAgfAMIaf4eAdCaLVriWSVpWgQvXK2HzE2C2mnf9LLhnDMZh8jNjHc8b7YT+3Pn
         EDVPjExHA4e2kpEciR0OLvFeqJyUBe3yD67YCSqptST486VDmad3BPHQLiUhl0Lv2QZn
         H8As8ZrNKgD3ik0FlIv/CFihFpdkhbQkOPHyiLamNyd1zxtZlJeMBiwIzX5bOoLI+jhN
         mFg4h/PPBTR0vrNutY6UzAWXYIp1oB/M6zGnCu1PHMzbW2YWbxrNl0yLfGyesYZELHJX
         bu4gidMqDN9szkui1dPY8vBs6m975n/efFasFewuF0thyX9M1sg9Jj2CXL9SLvH8adiP
         Wkiw==
X-Gm-Message-State: AOAM532lbIhuWryntlw1TihOLDSHjWA9AWDcU5ZrLDFQFJkQPZ/Eu4vB
        L7cBdi5HjyRXAb4RrAxN6n4=
X-Google-Smtp-Source: ABdhPJxEvV3wZ3qLeNbr+UAbHlAP19jNeARyMtuZyYmO4QxKO8JWlPqPXEySJkag4FLRKH0rO8e6dw==
X-Received: by 2002:a17:903:40ca:b0:14e:8885:1f29 with SMTP id t10-20020a17090340ca00b0014e88851f29mr22088310pld.137.1645518091903;
        Tue, 22 Feb 2022 00:21:31 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id q9sm16792446pfk.31.2022.02.22.00.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 00:21:31 -0800 (PST)
Date:   Tue, 22 Feb 2022 13:51:29 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 00/15] Introduce typed pointer support in BPF
 maps
Message-ID: <20220222082129.yivvpm6yo3474dp3@apollo.legion>
References: <20220220134813.3411982-1-memxor@gmail.com>
 <CAPhsuW53epuRQ3X5bYeoxRUL9sdEm7MUQ8bUoQCsf=C7k3hQ8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW53epuRQ3X5bYeoxRUL9sdEm7MUQ8bUoQCsf=C7k3hQ8A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 11:35:14AM IST, Song Liu wrote:
> On Sun, Feb 20, 2022 at 5:48 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > Introduction
> > ------------
> >
> > This set enables storing pointers of a certain type in BPF map, and extends the
> > verifier to enforce type safety and lifetime correctness properties.
> >
> > The infrastructure being added is generic enough for allowing storing any kind
> > of pointers whose type is available using BTF (user or kernel) in the future
> > (e.g. strongly typed memory allocation in BPF program), which are internally
> > tracked in the verifier as PTR_TO_BTF_ID, but for now the series limits them to
> > four kinds of pointers obtained from the kernel.
> >
> > Obviously, use of this feature depends on map BTF.
> >
> > 1. Unreferenced kernel pointer
> >
> > In this case, there are very few restrictions. The pointer type being stored
> > must match the type declared in the map value. However, such a pointer when
> > loaded from the map can only be dereferenced, but not passed to any in-kernel
> > helpers or kernel functions available to the program. This is because while the
> > verifier's exception handling mechanism coverts BPF_LDX to PROBE_MEM loads,
> > which are then handled specially by the JIT implementation, the same liberty is
> > not available to accesses inside the kernel. The pointer by the time it is
> > passed into a helper has no lifetime related guarantees about the object it is
> > pointing to, and may well be referencing invalid memory.
> >
> > 2. Referenced kernel pointer
> >
> > This case imposes a lot of restrictions on the programmer, to ensure safety. To
> > transfer the ownership of a reference in the BPF program to the map, the user
> > must use the BPF_XCHG instruction, which returns the old pointer contained in
> > the map, as an acquired reference, and releases verifier state for the
> > referenced pointer being exchanged, as it moves into the map.
> >
> > This a normal PTR_TO_BTF_ID that can be used with in-kernel helpers and kernel
> > functions callable by the program.
> >
> > However, if BPF_LDX is used to load a referenced pointer from the map, it is
> > still not permitted to pass it to in-kernel helpers or kernel functions. To
> > obtain a reference usable with helpers, the user must invoke a kfunc helper
> > which returns a usable reference (which also must be eventually released before
> > BPF_EXIT, or moved into a map).
> >
> > Since the load of the pointer (preserving data dependency ordering) must happen
> > inside the RCU read section, the kfunc helper will take a pointer to the map
> > value, which must point to the actual pointer of the object whose reference is
> > to be raised. The type will be verified from the BTF information of the kfunc,
> > as the prototype must be:
> >
> >         T *func(T **, ... /* other arguments */);
> >
> > Then, the verifier checks whether pointer at offset of the map value points to
> > the type T, and permits the call.
> >
> > This convention is followed so that such helpers may also be called from
> > sleepable BPF programs, where RCU read lock is not necessarily held in the BPF
> > program context, hence necessiating the need to pass in a pointer to the actual
> > pointer to perform the load inside the RCU read section.
> >
> > 3. per-CPU kernel pointer
> >
> > These have very little restrictions. The user can store a PTR_TO_PERCPU_BTF_ID
> > into the map, and when loading from the map, they must NULL check it before use,
> > because while a non-zero value stored into the map should always be valid, it can
> > still be reset to zero on updates. After checking it to be non-NULL, it can be
> > passed to bpf_per_cpu_ptr and bpf_this_cpu_ptr helpers to obtain a PTR_TO_BTF_ID
> > to underlying per-CPU object.
> >
> > It is also permitted to write 0 and reset the value.
> >
> > 4. Userspace pointer
> >
> > The verifier recently gained support for annotating BTF with __user type tag.
> > This indicates pointers pointing to memory which must be read using the
> > bpf_probe_read_user helper to ensure correct results. The set also permits
> > storing them into the BPF map, and ensures user pointer cannot be stored
> > into other kinds of pointers mentioned above.
> >
> > When loaded from the map, the only thing that can be done is to pass this
> > pointer to bpf_probe_read_user. No dereference is allowed.
> >
>
> I guess I missed some context here. Could you please provide some reference
> to the use cases of these features?
>

The common usecase is caching references to objects inside BPF maps, to avoid
costly lookups, and being able to raise it once for the duration of program
invocation when passing it to multiple helpers (to avoid further re-lookups).
Storing references also allows you to control object lifetime.

One other use case is enabling xdp_frame queueing in XDP using this, but that
still needs some integration work after this lands, so it's a bit early to
comment on the specifics.

Other than that, I think Alexei already mentioned this could be easily extended
to do memory allocation returning a PTR_TO_BTF_ID in a BPF program [0] in the
future.

  [0]: https://lore.kernel.org/bpf/20220216230615.po6huyrgkswk7u67@ast-mbp.dhcp.thefacebook.com

> For Unreferenced kernel pointer and userspace pointer, it seems that there is
> no guarantee the pointer will still be valid during access (we only know it is
> valid when it is stored in the map). Is this correct?
>

That is correct. In the case of unreferenced and referenced kernel pointers,
when you do a BPF_LDX, both are marked as PTR_UNTRUSTED, and it is not allowed
to pass them into helpers or kfuncs, because from that point onwards we cannot
claim that the object is still alive when pointer is used later. Still,
dereference is permitted because verifier handles faults for bad accesses using
PROBE_MEM conversion for PTR_TO_BTF_ID loads in convert_ctx_accesses (which is
then later detected by JIT to build exception table used by exception handler).

In case of reading unreferenced pointer, in some cases you know that the pointer
will stay valid, so you can just store it in the map and load and directly
access it, it imposes very little restrictions.

For the referenced case, and BPF_LDX marking it as PTR_UNTRUSTED, you could say
that this makes it a lot less useful, because if BPF program already holds
reference, just to make sure I _read valid data_, I still have to use the
kptr_get style helper to raise and put reference to ensure the object is alive
when it is accessed.

So in that case, for RCU protected objects, it should still wait for BPF program
to hit BPF_EXIT before the actual release, but for other cases like the case of
sleepable programs, or objects where refcount alone manages lifetime, you can
also detect writer presence of the other BPF program (to detect if pointer
during our access was xchg'd out) using a seqlock style scheme:

	v = bpf_map_lookup_elem(&map, ...);
	if (!v)
		return 0;
	seq_begin = v->seq;
	atomic_thread_fence(memory_order_acquire); // A
	<do access>
	atomic_thread_fence(memory_order_acquire); // B
	seq_end = v->seq;
	if (seq_begin & 1 || seq_begin != seq_end)
		goto bad_read;
	<use data>

Ofcourse, barriers are not yet in BPF, but you get the idea (it should work on
x86). The updater BPF program will increment v->seq before and after xchg,
ensuring proper ordering. v->seq starts as 0, so odd seq indicates writer update
is in progress.

This would allow you to not raise refcount, while still ensuring that as long as
object was accessed, it was still valid between A and B. Even if raising
uncontended refcount is cheap, this is much cheaper.

The case of userspace pointer is different, it sets the MEM_USER flag, so the
only useful thing to do is calling bpf_probe_read_user, you can't even
dereference it. You are right that in most cases that userspace pointer won't be
useful, but for some cooperative cases between BPF program and userspace thread,
it can act as a way to share certain thread local areas/userspace memory that
the BPF program can then store keyed by the task_struct *, where using a BPF map
to share memory is not always possible.

> Thanks,
> Song
>
> [...]

--
Kartikeya
