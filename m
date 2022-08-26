Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CF05A2F67
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 20:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345386AbiHZS4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 14:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345590AbiHZS4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 14:56:01 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A722D7D14;
        Fri, 26 Aug 2022 11:52:18 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id r141so1862860iod.4;
        Fri, 26 Aug 2022 11:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=7cklhi6L/GtauEjQjE6Em0/BNQevf1lgNNAVj9ijMPY=;
        b=A5DjMkMzhV3LVlJMtfAhsHHMofOh6T8pAB0PjdGgEzyb4mQsw4Eg9dcW3X8dUea2ss
         zQrM33inkFH6FnwIUAuUo/QfG8kvT+jyKWTtdrtAxJNzDCFkTnzersgdwJ291k3p05AX
         2avZjKooEfO6rhE6b50as4DSqk9ak+yMCRT5K4fUC4T6+/Y9uGzHAZocTeDp2ixQI9Y3
         yNToL1IO1yy+0EdcytAv6nTpjaYRmLHHlSElPSKfsYpb0wlTUOjXobpWdvbL8wcXjMIy
         Ix9F6RdowQ0Y2Oe8xYX1ZqZMTQVJOHUuP1fqsT9+2XwDxsmUJ7SjfzyotWclBjKk0I9r
         XTwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=7cklhi6L/GtauEjQjE6Em0/BNQevf1lgNNAVj9ijMPY=;
        b=Loq3qw/bTW+hAd5UTS3XHzdwVLn97TQqqp9V3ZSktfgT70lkmTdVaP2Y0XeVRnTLK8
         uWQNafSuNT0XQdrOXvBVs9Qf6DJZW62181LlLpehac2Y8KDYee0OJY6Gen7EZAqiHU9a
         Dl2EkK7EDuCaNh0aDp0EHvkQzJeBuyqHTAQt66dncGl9clctd7QYnCtqxjDEBuhpcEDD
         QxYYK+0D9DDVLbbtG8S0G/KnadV+yDLT9ZJrJr2NdG/kKRn2U+S6Ny1h5ium2MphkXmo
         /nZfYx6cOcPH4wjG7Qn2D/TOHz8xZNseoBnCov2ofmv66ita3exPesSJdiKXsSPffz2N
         84jA==
X-Gm-Message-State: ACgBeo2FlqEnKRjfWjgB3a8Nz/MBmgpyfMcxVhNAXoomUNjJ1tpzSN4u
        7f0d/i9jb+46wmzWeOdpX8hWiYqeBoBkUy02/z8=
X-Google-Smtp-Source: AA6agR6MnhMYaBO5P9iY2zXHoadGCAtzopsSBONcKerBBtXb7STZlq9qWDCpzvd89UxGDTK228hOkhhNnzB6Rm3k6Jg=
X-Received: by 2002:a6b:2ac4:0:b0:688:3a14:2002 with SMTP id
 q187-20020a6b2ac4000000b006883a142002mr3989668ioq.62.1661539938004; Fri, 26
 Aug 2022 11:52:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-2-joannelkoong@gmail.com> <CAEf4BzZm7eUX3w-NwP0JuWtvKbO6GxN911TraY5bA8-z+ocyCg@mail.gmail.com>
 <CAP01T77izAbefN5CJ1ZdjwUdii=gMFMduKTYtSbYC3S9jbRoEA@mail.gmail.com>
 <CAJnrk1Y0r3++RLpT2jvp4st-79x3dUYk3uP-4tfnAeL5_kgM0Q@mail.gmail.com>
 <CAP01T74O6ZuH_NPObYTLUjFSADjWjzfHjTsLBf8b67jgchf6Gw@mail.gmail.com> <CAJnrk1Z39+pLzAOL3tbqvQyTcB4HvrbLghmr6_vLXhtJYHuwEA@mail.gmail.com>
In-Reply-To: <CAJnrk1Z39+pLzAOL3tbqvQyTcB4HvrbLghmr6_vLXhtJYHuwEA@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 26 Aug 2022 20:51:42 +0200
Message-ID: <CAP01T76ChONTCVtHNZ_X3Z6qmuZTKCVYwe0s6_TGcuC1tEx9sw@mail.gmail.com>
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

On Fri, 26 Aug 2022 at 20:44, Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Thu, Aug 25, 2022 at 5:19 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Thu, 25 Aug 2022 at 23:02, Joanne Koong <joannelkoong@gmail.com> wrote:
> > > [...]
> > > >
> > > > Related question, it seems we know statically if dynptr is read only
> > > > or not, so why even do all this hidden parameter passing and instead
> > > > just reject writes directly? You only need to be able to set
> > > > MEM_RDONLY on dynptr_data returned PTR_TO_PACKETs, and reject
> > > > dynptr_write when dynptr type is xdp/skb (and ctx is only one). That
> > > > seems simpler than checking it at runtime. Verifier already handles
> > > > MEM_RDONLY generically, you only need to add the guard for
> > > > check_packet_acces (and check_helper_mem_access for meta->raw_mode
> > > > under pkt case), and rejecting dynptr_write seems like a if condition.
> > >
> > > There will be other helper functions that do writes (eg memcpy to
> > > dynptrs, strncpy to dynptrs, probe read user to dynptrs, hashing
> > > dynptrs, ...) so it's more scalable if we reject these at runtime
> > > rather than enforce these at the verifier level. I also think it's
> > > cleaner to keep the verifier logic as simple as possible and do the
> > > checking in the helper.
> >
> > I won't be pushing this further, since you know what you plan to add
> > in the future better, but I still disagree.
> >
> > I'm guessing there might be dynptrs where this read only property is
> > set dynamically at runtime, which is why you want to go this route?
> > I.e. you might not know statically whether dynptr is read only or not?
> >
> > My main confusion is the inconsistency here.
> >
> > Right now the patch implicitly relies on may_access_direct_pkt_data to
> > protect slices returned from dynptr_data, instead of setting
> > MEM_RDONLY on the returned PTR_TO_PACKET. Which is fine, it's not
> > needed. So indirectly, you are relying on knowing statically whether
> > the dynptr is read only or not. But then you also set this bit at
> > runtime.
> >
> > So you reject some cases at load time, and the rest of them only at
> > runtime. Direct writes to dynptr slice fails load, writes through
> > helper does not (only fails at runtime).
> >
> > Also, dynptr_data needs to know whether dynptr is read only
> > statically, to protect writes to its returned pointer, unless you
> > decide to introduce another helper for the dynamic rdonly bit case
> > (like dynptr_data_rdonly). Then you have a mismatch, where dynptr_data
> > works for some rdonly dynptrs (known to be rdonly statically, like
> > this skb one), but not for others.
> >
> > I also don't agree about the complexity or scalability part, all the
> > infra and precedence is already there. We already have similar checks
> > for meta->raw_mode where we reject writes to read only pointers in
> > check_helper_mem_access.
>
> My point about scalability is that if we reject bpf_dynptr_write() at
> load time, then we must reject any future dynptr helper that does any
> writing at load time as well, to be consistent.
>
> I don't feel strongly about whether we reject at load time or run
> time. Rejecting at load time instead of runtime doesn't seem that
> useful to me, but there's a good chance I'm wrong here since Martin
> stated that he prefers rejecting at load time as well.
>
> As for the added complexity part, what I mean is that we'll need to
> keep track of some more stuff to support this, such as whether the
> dynptr is read only and which helper functions need to check whether
> the dynptr is read only or not.

What I'm trying to understand is how dynptr_data is supposed to work
if this dynptr read only bit is only known at runtime. Or will it be
always known statically so that it can set returned pointer as read
only? Because then it doesn't seem it is required or useful to track
the readonly bit at runtime.

It is fine if _everything_ checks it at runtime, but that doesn't seem
possible, hence the question. We would need a new slice helper that
only returns read-only slices, because dynptr_data can return rw
slices currently and it is already UAPI so changing that is not
possible anymore.
