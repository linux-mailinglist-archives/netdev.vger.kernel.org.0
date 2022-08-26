Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D245A2F48
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 20:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345278AbiHZSr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 14:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345280AbiHZSrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 14:47:25 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B12DED;
        Fri, 26 Aug 2022 11:44:36 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z8so3199858edb.0;
        Fri, 26 Aug 2022 11:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=FUmHak/3bRF3AaXAW589tW9XXeesv8P4Km7LZEQwCJI=;
        b=KUrR/xMxp4e7B6kUbozfFYQIr/1ez4t2VCGGViWpowWIkx8vCFta2Pu/dcYMzaSVn1
         NaNST2VUSp3j9w3A9w9u5bISgBaKQIjkaFU+C12Zu+AyEx4Z4FjmaYiNuDBMpKBw/grP
         fldGnigOJssikwnFhD1UgdCSbp2seQdTs8ocvoAhgH2Z9CxFYMKz4+tv8/DgbUrtrJCm
         NSdzaRN/jgwmAOpFldzsq9LoWoEyWVAYT3l4VfPqyun1Xeahj9nxBXnMKClHEAlAo/Bp
         uSAhmRdT+c9dqvAXFjdq9u9DPV2Bm/zz5wV3rJF6coGYFWFX+49DK1KqjkN6X1n2gAd/
         0DEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=FUmHak/3bRF3AaXAW589tW9XXeesv8P4Km7LZEQwCJI=;
        b=C7hevEoy88AoStlVMejGWt8CQ7Tea4UueinRChQxKfVxfw1AAxZ0964O9ZKeGJcNPY
         rGqNyn+IFCtZBSe5pS8UVRtrRtHPN0THwJwNjXqsao6+cdY4/Yk7NcmIxIKYR7Poohlt
         27zZnI/EQVV18olWEk1DCquvB7UuvL6e1NkdQwytxDQ0PqRexmgv66NZktQOVt2/2mkK
         7l9TTw5S8SfcBDuLhftaaV0vGYqi8W12DUHuXXyGsiee8SXmJCJrGVEczqS/aGO5qpke
         sknARjm9L3PcCKi3+9vNkP7+s7plwL4OXH7KxPymXltxrpwwnc/mde42rBtZfj75pSQi
         AyWA==
X-Gm-Message-State: ACgBeo0nb1WunnIP0BT+ihIjUqYXqIvWWP61oVVlfs7Vn3+mxI21M0rz
        z5ZCkjA0O/J9oTLmPSw9PbCMU0Lrp+t35hckWEQ=
X-Google-Smtp-Source: AA6agR6HAXi4zJaRET4WXskixy6J4e0YSx6dhoXZcMnZZDTP0RgfA2kfndTcx6N2W0UZ9hbvBZzKjIxZACnM6J/AmsM=
X-Received: by 2002:aa7:c70f:0:b0:447:cf74:9d2f with SMTP id
 i15-20020aa7c70f000000b00447cf749d2fmr5063504edq.229.1661539474574; Fri, 26
 Aug 2022 11:44:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-2-joannelkoong@gmail.com> <CAEf4BzZm7eUX3w-NwP0JuWtvKbO6GxN911TraY5bA8-z+ocyCg@mail.gmail.com>
 <CAP01T77izAbefN5CJ1ZdjwUdii=gMFMduKTYtSbYC3S9jbRoEA@mail.gmail.com>
 <CAJnrk1Y0r3++RLpT2jvp4st-79x3dUYk3uP-4tfnAeL5_kgM0Q@mail.gmail.com> <CAP01T74O6ZuH_NPObYTLUjFSADjWjzfHjTsLBf8b67jgchf6Gw@mail.gmail.com>
In-Reply-To: <CAP01T74O6ZuH_NPObYTLUjFSADjWjzfHjTsLBf8b67jgchf6Gw@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 26 Aug 2022 11:44:23 -0700
Message-ID: <CAJnrk1Z39+pLzAOL3tbqvQyTcB4HvrbLghmr6_vLXhtJYHuwEA@mail.gmail.com>
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

On Thu, Aug 25, 2022 at 5:19 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Thu, 25 Aug 2022 at 23:02, Joanne Koong <joannelkoong@gmail.com> wrote:
> > [...]
> > >
> > > Related question, it seems we know statically if dynptr is read only
> > > or not, so why even do all this hidden parameter passing and instead
> > > just reject writes directly? You only need to be able to set
> > > MEM_RDONLY on dynptr_data returned PTR_TO_PACKETs, and reject
> > > dynptr_write when dynptr type is xdp/skb (and ctx is only one). That
> > > seems simpler than checking it at runtime. Verifier already handles
> > > MEM_RDONLY generically, you only need to add the guard for
> > > check_packet_acces (and check_helper_mem_access for meta->raw_mode
> > > under pkt case), and rejecting dynptr_write seems like a if condition.
> >
> > There will be other helper functions that do writes (eg memcpy to
> > dynptrs, strncpy to dynptrs, probe read user to dynptrs, hashing
> > dynptrs, ...) so it's more scalable if we reject these at runtime
> > rather than enforce these at the verifier level. I also think it's
> > cleaner to keep the verifier logic as simple as possible and do the
> > checking in the helper.
>
> I won't be pushing this further, since you know what you plan to add
> in the future better, but I still disagree.
>
> I'm guessing there might be dynptrs where this read only property is
> set dynamically at runtime, which is why you want to go this route?
> I.e. you might not know statically whether dynptr is read only or not?
>
> My main confusion is the inconsistency here.
>
> Right now the patch implicitly relies on may_access_direct_pkt_data to
> protect slices returned from dynptr_data, instead of setting
> MEM_RDONLY on the returned PTR_TO_PACKET. Which is fine, it's not
> needed. So indirectly, you are relying on knowing statically whether
> the dynptr is read only or not. But then you also set this bit at
> runtime.
>
> So you reject some cases at load time, and the rest of them only at
> runtime. Direct writes to dynptr slice fails load, writes through
> helper does not (only fails at runtime).
>
> Also, dynptr_data needs to know whether dynptr is read only
> statically, to protect writes to its returned pointer, unless you
> decide to introduce another helper for the dynamic rdonly bit case
> (like dynptr_data_rdonly). Then you have a mismatch, where dynptr_data
> works for some rdonly dynptrs (known to be rdonly statically, like
> this skb one), but not for others.
>
> I also don't agree about the complexity or scalability part, all the
> infra and precedence is already there. We already have similar checks
> for meta->raw_mode where we reject writes to read only pointers in
> check_helper_mem_access.

My point about scalability is that if we reject bpf_dynptr_write() at
load time, then we must reject any future dynptr helper that does any
writing at load time as well, to be consistent.

I don't feel strongly about whether we reject at load time or run
time. Rejecting at load time instead of runtime doesn't seem that
useful to me, but there's a good chance I'm wrong here since Martin
stated that he prefers rejecting at load time as well.

As for the added complexity part, what I mean is that we'll need to
keep track of some more stuff to support this, such as whether the
dynptr is read only and which helper functions need to check whether
the dynptr is read only or not.

On the whole, I think given that both Martin and you have specified
your preferences for this, we should reject at load time instead of
runtime. I'll make this change for v5 :)
