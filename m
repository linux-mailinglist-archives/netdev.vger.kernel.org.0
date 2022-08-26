Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328555A30AA
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 22:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242176AbiHZUy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 16:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234122AbiHZUyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 16:54:55 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADE42AE1A;
        Fri, 26 Aug 2022 13:54:53 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id q81so2109742iod.9;
        Fri, 26 Aug 2022 13:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=pkt0Yzf4R3Fd9DgZlP6dgeGDdAgSwq8fsjN4t7nFaSY=;
        b=W3w0hee66ofmZMrx+Ds27aTFgShoZHh6HewqQgmYAyESwL/AaJ4DgWRNy3ytwZdWw6
         blELn9t3Ra4aJoiTUKPETMjN2EYaECSQ9cdTw1Tb8uUnhyQQ8s5gXY7ofwJ1sTmClXDa
         TrGGJFCnVx3/s16ST93sCSsl5ilx1S/4MMvC0umilDoHVBnkPPuExZlLSboz/flx4rSi
         Wucxo982QHh9tQ7Mr7yhcH6ADlz27nrh1eJURmGyuLLcpqWjv1vH6usB+5ZBy5Sg5o34
         kidTbmOM5ZxREbnkrGcTwdZ+AgZK0nQIfjW4t1qEFSdPCP6alAbgeibe2e7MS0VGbqJj
         J1XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=pkt0Yzf4R3Fd9DgZlP6dgeGDdAgSwq8fsjN4t7nFaSY=;
        b=kqcZ4siBOXI9H/kcT4gC4QMjfX+7c3CwnscfjC6dPI474EK11brwAK3APSCX6eUVNr
         DrV+DJTSeNchwi1mzU7aBULyIV/jAumzI5wQSVojVfcfaORHs2/1DJkHUD5+M1rAdVWd
         BIvtWxzvp8NveQr8zlHn9hoIM8fPVrBGwdkAS6Pzx9JEl0qa0yW4yCJFNCaBCezkZ7xB
         XmbSGk8vfK114MTyJBb49vJzP/JCDu0RD7oJ1grtFjtzqArmnBZi9kgCbk6pSwRInFK2
         M7Bz2UC4BdzBrja2cHDy7c9JrqAIofzPfzyguWC+gp1Zd36BrN81qphQT4mtsVES4aDi
         4a3w==
X-Gm-Message-State: ACgBeo3NOzIWwqPoYwTDZuF65mm4+2RBIME0TxAzGlq0nUdqTE/8arCl
        SwIkKxyTcMWBk1CumiU2Z5r3F+QLFRhMB1fb7uprvbM+
X-Google-Smtp-Source: AA6agR4p00HwGGk93wZrsTQs6U5UdOeH+kAa/n95672KaD16yM9lM4tk6zT9FL1jksREeHRCTPZ2uYUS3stIp3welAI=
X-Received: by 2002:a5e:dc46:0:b0:689:94f6:fa3e with SMTP id
 s6-20020a5edc46000000b0068994f6fa3emr4374435iop.110.1661547293198; Fri, 26
 Aug 2022 13:54:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-2-joannelkoong@gmail.com> <CAEf4BzZm7eUX3w-NwP0JuWtvKbO6GxN911TraY5bA8-z+ocyCg@mail.gmail.com>
 <CAP01T77izAbefN5CJ1ZdjwUdii=gMFMduKTYtSbYC3S9jbRoEA@mail.gmail.com>
 <CAJnrk1Y0r3++RLpT2jvp4st-79x3dUYk3uP-4tfnAeL5_kgM0Q@mail.gmail.com>
 <CAP01T74O6ZuH_NPObYTLUjFSADjWjzfHjTsLBf8b67jgchf6Gw@mail.gmail.com>
 <CAJnrk1Z39+pLzAOL3tbqvQyTcB4HvrbLghmr6_vLXhtJYHuwEA@mail.gmail.com>
 <CAP01T76ChONTCVtHNZ_X3Z6qmuZTKCVYwe0s6_TGcuC1tEx9sw@mail.gmail.com> <CAJnrk1Zmne1uDn8EKdNKJe6O-k_moU9Sryfws_J-TF2BvX2QMg@mail.gmail.com>
In-Reply-To: <CAJnrk1Zmne1uDn8EKdNKJe6O-k_moU9Sryfws_J-TF2BvX2QMg@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 26 Aug 2022 22:54:17 +0200
Message-ID: <CAP01T746gvoOM7DuWY-3N2xJbEainTinTPhyqHki2Ms6E0Dk_A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] bpf: Add skb dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>, bpf@vger.kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        kafai@fb.com, kuba@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Aug 2022 at 21:49, Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Fri, Aug 26, 2022 at 11:52 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Fri, 26 Aug 2022 at 20:44, Joanne Koong <joannelkoong@gmail.com> wrote:
> > >
> > > On Thu, Aug 25, 2022 at 5:19 PM Kumar Kartikeya Dwivedi
> > > <memxor@gmail.com> wrote:
> > > >
> > > > On Thu, 25 Aug 2022 at 23:02, Joanne Koong <joannelkoong@gmail.com> wrote:
> > > > > [...]
> > > > > >
> > > > > > Related question, it seems we know statically if dynptr is read only
> > > > > > or not, so why even do all this hidden parameter passing and instead
> > > > > > just reject writes directly? You only need to be able to set
> > > > > > MEM_RDONLY on dynptr_data returned PTR_TO_PACKETs, and reject
> > > > > > dynptr_write when dynptr type is xdp/skb (and ctx is only one). That
> > > > > > seems simpler than checking it at runtime. Verifier already handles
> > > > > > MEM_RDONLY generically, you only need to add the guard for
> > > > > > check_packet_acces (and check_helper_mem_access for meta->raw_mode
> > > > > > under pkt case), and rejecting dynptr_write seems like a if condition.
> > > > >
> > > > > There will be other helper functions that do writes (eg memcpy to
> > > > > dynptrs, strncpy to dynptrs, probe read user to dynptrs, hashing
> > > > > dynptrs, ...) so it's more scalable if we reject these at runtime
> > > > > rather than enforce these at the verifier level. I also think it's
> > > > > cleaner to keep the verifier logic as simple as possible and do the
> > > > > checking in the helper.
> > > >
> > > > I won't be pushing this further, since you know what you plan to add
> > > > in the future better, but I still disagree.
> > > >
> > > > I'm guessing there might be dynptrs where this read only property is
> > > > set dynamically at runtime, which is why you want to go this route?
> > > > I.e. you might not know statically whether dynptr is read only or not?
> > > >
> > > > My main confusion is the inconsistency here.
> > > >
> > > > Right now the patch implicitly relies on may_access_direct_pkt_data to
> > > > protect slices returned from dynptr_data, instead of setting
> > > > MEM_RDONLY on the returned PTR_TO_PACKET. Which is fine, it's not
> > > > needed. So indirectly, you are relying on knowing statically whether
> > > > the dynptr is read only or not. But then you also set this bit at
> > > > runtime.
> > > >
> > > > So you reject some cases at load time, and the rest of them only at
> > > > runtime. Direct writes to dynptr slice fails load, writes through
> > > > helper does not (only fails at runtime).
> > > >
> > > > Also, dynptr_data needs to know whether dynptr is read only
> > > > statically, to protect writes to its returned pointer, unless you
> > > > decide to introduce another helper for the dynamic rdonly bit case
> > > > (like dynptr_data_rdonly). Then you have a mismatch, where dynptr_data
> > > > works for some rdonly dynptrs (known to be rdonly statically, like
> > > > this skb one), but not for others.
> > > >
> > > > I also don't agree about the complexity or scalability part, all the
> > > > infra and precedence is already there. We already have similar checks
> > > > for meta->raw_mode where we reject writes to read only pointers in
> > > > check_helper_mem_access.
> > >
> > > My point about scalability is that if we reject bpf_dynptr_write() at
> > > load time, then we must reject any future dynptr helper that does any
> > > writing at load time as well, to be consistent.
> > >
> > > I don't feel strongly about whether we reject at load time or run
> > > time. Rejecting at load time instead of runtime doesn't seem that
> > > useful to me, but there's a good chance I'm wrong here since Martin
> > > stated that he prefers rejecting at load time as well.
> > >
> > > As for the added complexity part, what I mean is that we'll need to
> > > keep track of some more stuff to support this, such as whether the
> > > dynptr is read only and which helper functions need to check whether
> > > the dynptr is read only or not.
> >
> > What I'm trying to understand is how dynptr_data is supposed to work
> > if this dynptr read only bit is only known at runtime. Or will it be
> > always known statically so that it can set returned pointer as read
> > only? Because then it doesn't seem it is required or useful to track
> > the readonly bit at runtime.
>
> I think it'll always be known statically whether the dynptr is
> read-only or not. If we make all writable dynptr helper functions
> reject read-only dynptrs at load time instead of run time, then yes we
> can remove the read-only bit in the bpf_dynptr_kern struct.
>
> There's also the question of whether this constraint (eg all read-only
> writes are rejected at load time) is too rigid - for example, what if
> in the future we want to add a helper function where if a certain
> condition is met, then we write some number of bytes, else we read
> some number of bytes? This would be not possible to add then, since
> we'll only know at runtime whether the condition is met.
>
> I personally lean towards rejecting helper function writes at runtime,
> but if you think it's a non-trivial benefit to reject at load time
> instead, I'm fine going with that.
>

My personal opinion is this:

When I am working with a statically known read only dynptr, it is like
declaring a variable const. Every function expecting it to be
non-const should fail compilation, and trying to mutate the variables
through writes should also fail compilation. For BPF compilation is
analogous to program load.

It might be that said variable is not const, then those operations may
fail at runtime due to some other reason. Being dynamically read-only
is then a runtime failure condition, which will cause failure at
runtime. Both are distinct cases in my mind, and it is fine to fail at
runtime when we don't know. In general, you save a lot of time of the
user in my opinion (esp. people new to things) if you reject known
incorrectness as early as possible.

E.g. load a dynptr from a map, where the field accepts storing both
read only and non-read only ones. Then it is expected that writes may
fail at runtime. That also allows you to switch read-only ness at
runtime back to rw. But if the field only expects rdonly dynptr,
verifier knows that the type is const statically, so it triggers
failures for writes at load time instead.

Taking this a step further, you may even store rw dynptr to a map
field expecting rdonly dynptr. That's like returning a const pointer
from a function for a rw memory, where you want to limit access of the
user, even better if you do it statically. Then functions trying to
write to dynptr loaded from said map field will fail load itself,
while others having access to rw dynptr can do it just fine.

When the verifier does not know, it does not know. There will be such
cases when you make const-ness a runtime property.

> >
> > It is fine if _everything_ checks it at runtime, but that doesn't seem
> > possible, hence the question. We would need a new slice helper that
> > only returns read-only slices, because dynptr_data can return rw
> > slices currently and it is already UAPI so changing that is not
> > possible anymore.
>
> I don't agree that if bpf_dynptr_write() is checked at runtime, then
> bpf_dynptr_data must also be checked at runtime to be consistent. I
> think it's fine if writes through helper functions are rejected at
> runtime, and writes through direct access are rejected at load time.
> That doesn't seem inconsistent to me.

My point was more that dynptr_data cannot propagate runtime
read-only-ness to its returned pointer. The verifier has to know
statically, at which point I don't see why we can't just reject other
cases at load anyway.

When we have dynptrs which have const-ness as a runtime property, it
is ok to support that by failing at runtime (but then you'll have a
hard time deciding how you want dynptr_data to work, most likely
you'll need another helper which returns only a rdonly slice, when it
fails, we call dynptr_data for rw slice).

But as I said before, I don't know how dynptr is going to evolve in
the future, so you'll have a better idea, and I'll leave it up to you
decide how you want to design its API. Enough words exchanged about
this :).
