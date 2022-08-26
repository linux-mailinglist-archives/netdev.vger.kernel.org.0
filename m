Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5695A302D
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 21:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344617AbiHZTtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 15:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbiHZTtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 15:49:14 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB7DD41B8;
        Fri, 26 Aug 2022 12:49:12 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bj12so4976945ejb.13;
        Fri, 26 Aug 2022 12:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=lFfRhGq/C2tmzV8LpNcEWTFvD11vZdOiT2ymmvZNkXM=;
        b=SYXgKBCMsfvYQ+mL4y8sw6phUTHL+zxW8ToWaE9wkWtCrec5gmotGEUV1r+2fcMfmq
         2GjOV/zdXam7qjDdD9kKsO/ZGNpx7GRp8VuA73VLI91wZKCLaqndMk+UjIgjBM4HdMpL
         Y881dUBs//1chWclNOSIrl4vdZ9LyggT0ph1WLpl0pacywoYt8ieCPPWCgRpqTrOvIZl
         2uIaMg1RgY9fCORr+TcliD/i1/WI7KDdaSA0DfmYfrrUqyhayspA1VyMBLxdHTRV4x0W
         OGBERC8FI/9f348lT+XcAW7/y/XQlfYEHCyJwkAAfY8AUZEgIoCX9h3MOyT9BMzJ0vFG
         5Etw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=lFfRhGq/C2tmzV8LpNcEWTFvD11vZdOiT2ymmvZNkXM=;
        b=yAM4JhFSsvLkrGWulncDLSFnlz+SjmjwHPtVY6o8EM5BxjIwd5MQMTKZRQSUlD9RnK
         K5ahZWzPMcERNwVKA8hRTo6T0fWlkkRcJq+42jEnHhO7SDoujB0SykerUCZqwnDuKVV/
         tXVPxDVCYfck651ckVzUwJkA5REEUAiSRxJ6Zk/NYRYidbuPZc3oHKiGDmewgI42HTsY
         ZI3N7ZLjV1tC3b63L2ANhuxQG4dEPwJF5DMuehEJRNqWbSuuObu4RfLfmYD5/Ekkl+Qh
         ojl3Nn3k/1kK0ztzU+OZ6pMJzQFM8fEPijaEFCa3QpvumuHT+x+D3Zj6eYKSXfecH811
         IE2A==
X-Gm-Message-State: ACgBeo3zyJ8wmdkQGDaS0jN+A8IK0wh1cbWFoU57wvww4ivQBn0s9UDn
        H32N3gl8Boh5RVfp1YLrB24KSxH69Lz5WEt6qbE=
X-Google-Smtp-Source: AA6agR73Q0HZSxNSzeeEdfHDFFhd1ixwXdbVhBqtfaMp38clySFHtgypZqz/TFy1WAXJt8jgV2ioFw11a6+4IHRot0s=
X-Received: by 2002:a17:907:b013:b0:73d:c708:3f22 with SMTP id
 fu19-20020a170907b01300b0073dc7083f22mr6169995ejc.608.1661543351468; Fri, 26
 Aug 2022 12:49:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-2-joannelkoong@gmail.com> <CAEf4BzZm7eUX3w-NwP0JuWtvKbO6GxN911TraY5bA8-z+ocyCg@mail.gmail.com>
 <CAP01T77izAbefN5CJ1ZdjwUdii=gMFMduKTYtSbYC3S9jbRoEA@mail.gmail.com>
 <CAJnrk1Y0r3++RLpT2jvp4st-79x3dUYk3uP-4tfnAeL5_kgM0Q@mail.gmail.com>
 <CAP01T74O6ZuH_NPObYTLUjFSADjWjzfHjTsLBf8b67jgchf6Gw@mail.gmail.com>
 <CAJnrk1Z39+pLzAOL3tbqvQyTcB4HvrbLghmr6_vLXhtJYHuwEA@mail.gmail.com> <CAP01T76ChONTCVtHNZ_X3Z6qmuZTKCVYwe0s6_TGcuC1tEx9sw@mail.gmail.com>
In-Reply-To: <CAP01T76ChONTCVtHNZ_X3Z6qmuZTKCVYwe0s6_TGcuC1tEx9sw@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 26 Aug 2022 12:49:00 -0700
Message-ID: <CAJnrk1Zmne1uDn8EKdNKJe6O-k_moU9Sryfws_J-TF2BvX2QMg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] bpf: Add skb dynptrs
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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

On Fri, Aug 26, 2022 at 11:52 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Fri, 26 Aug 2022 at 20:44, Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > On Thu, Aug 25, 2022 at 5:19 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > On Thu, 25 Aug 2022 at 23:02, Joanne Koong <joannelkoong@gmail.com> wrote:
> > > > [...]
> > > > >
> > > > > Related question, it seems we know statically if dynptr is read only
> > > > > or not, so why even do all this hidden parameter passing and instead
> > > > > just reject writes directly? You only need to be able to set
> > > > > MEM_RDONLY on dynptr_data returned PTR_TO_PACKETs, and reject
> > > > > dynptr_write when dynptr type is xdp/skb (and ctx is only one). That
> > > > > seems simpler than checking it at runtime. Verifier already handles
> > > > > MEM_RDONLY generically, you only need to add the guard for
> > > > > check_packet_acces (and check_helper_mem_access for meta->raw_mode
> > > > > under pkt case), and rejecting dynptr_write seems like a if condition.
> > > >
> > > > There will be other helper functions that do writes (eg memcpy to
> > > > dynptrs, strncpy to dynptrs, probe read user to dynptrs, hashing
> > > > dynptrs, ...) so it's more scalable if we reject these at runtime
> > > > rather than enforce these at the verifier level. I also think it's
> > > > cleaner to keep the verifier logic as simple as possible and do the
> > > > checking in the helper.
> > >
> > > I won't be pushing this further, since you know what you plan to add
> > > in the future better, but I still disagree.
> > >
> > > I'm guessing there might be dynptrs where this read only property is
> > > set dynamically at runtime, which is why you want to go this route?
> > > I.e. you might not know statically whether dynptr is read only or not?
> > >
> > > My main confusion is the inconsistency here.
> > >
> > > Right now the patch implicitly relies on may_access_direct_pkt_data to
> > > protect slices returned from dynptr_data, instead of setting
> > > MEM_RDONLY on the returned PTR_TO_PACKET. Which is fine, it's not
> > > needed. So indirectly, you are relying on knowing statically whether
> > > the dynptr is read only or not. But then you also set this bit at
> > > runtime.
> > >
> > > So you reject some cases at load time, and the rest of them only at
> > > runtime. Direct writes to dynptr slice fails load, writes through
> > > helper does not (only fails at runtime).
> > >
> > > Also, dynptr_data needs to know whether dynptr is read only
> > > statically, to protect writes to its returned pointer, unless you
> > > decide to introduce another helper for the dynamic rdonly bit case
> > > (like dynptr_data_rdonly). Then you have a mismatch, where dynptr_data
> > > works for some rdonly dynptrs (known to be rdonly statically, like
> > > this skb one), but not for others.
> > >
> > > I also don't agree about the complexity or scalability part, all the
> > > infra and precedence is already there. We already have similar checks
> > > for meta->raw_mode where we reject writes to read only pointers in
> > > check_helper_mem_access.
> >
> > My point about scalability is that if we reject bpf_dynptr_write() at
> > load time, then we must reject any future dynptr helper that does any
> > writing at load time as well, to be consistent.
> >
> > I don't feel strongly about whether we reject at load time or run
> > time. Rejecting at load time instead of runtime doesn't seem that
> > useful to me, but there's a good chance I'm wrong here since Martin
> > stated that he prefers rejecting at load time as well.
> >
> > As for the added complexity part, what I mean is that we'll need to
> > keep track of some more stuff to support this, such as whether the
> > dynptr is read only and which helper functions need to check whether
> > the dynptr is read only or not.
>
> What I'm trying to understand is how dynptr_data is supposed to work
> if this dynptr read only bit is only known at runtime. Or will it be
> always known statically so that it can set returned pointer as read
> only? Because then it doesn't seem it is required or useful to track
> the readonly bit at runtime.

I think it'll always be known statically whether the dynptr is
read-only or not. If we make all writable dynptr helper functions
reject read-only dynptrs at load time instead of run time, then yes we
can remove the read-only bit in the bpf_dynptr_kern struct.

There's also the question of whether this constraint (eg all read-only
writes are rejected at load time) is too rigid - for example, what if
in the future we want to add a helper function where if a certain
condition is met, then we write some number of bytes, else we read
some number of bytes? This would be not possible to add then, since
we'll only know at runtime whether the condition is met.

I personally lean towards rejecting helper function writes at runtime,
but if you think it's a non-trivial benefit to reject at load time
instead, I'm fine going with that.

>
> It is fine if _everything_ checks it at runtime, but that doesn't seem
> possible, hence the question. We would need a new slice helper that
> only returns read-only slices, because dynptr_data can return rw
> slices currently and it is already UAPI so changing that is not
> possible anymore.

I don't agree that if bpf_dynptr_write() is checked at runtime, then
bpf_dynptr_data must also be checked at runtime to be consistent. I
think it's fine if writes through helper functions are rejected at
runtime, and writes through direct access are rejected at load time.
That doesn't seem inconsistent to me.
