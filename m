Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE58A5A1DAA
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiHZATW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiHZATV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:19:21 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDF7C5795;
        Thu, 25 Aug 2022 17:19:19 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id p187so42126iod.8;
        Thu, 25 Aug 2022 17:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=+X+Zw5Hs5cowtvbLdi5QQp8g1ejxPlW8grdIGZ8ah6A=;
        b=Yhq6cCTPPfnxM9iIrQ4CO6Fyy6Xlb29hbwH/y/pAOotna51qrQf/oAPLMg9otEiunS
         HNnBQ/GFCsVYeyqNhhazz1UadgyCDF6bfepOsudn7RA/YtaMdHPeFErVTdLMp3wJW5H6
         5br4gd7lIbuY91DpWPuZZd8ehIdJmMxiYHq3iqn/M4DTb69uCOrTpC5zR2IhIlkv2DmG
         c0GoSO5TEbxZcnv785yHVwrT+mXMAzLnsWAEgHLe2cUfTOrAwnM/3zUYUbbWbI5ElgM0
         awyEE2P9tQgd5MKxVrs1lzzCJmiv30ReCE8QP/bCkTQEIJ56PaQVXfS4aQccTUh/jTM+
         2BwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=+X+Zw5Hs5cowtvbLdi5QQp8g1ejxPlW8grdIGZ8ah6A=;
        b=Iccc021K+sG/AYPhxzTBX0hd1EnF/VD4qEf2z/dUnAEVWuqMRmz9YVQKyG9xWAHbiI
         c/Rn9OnUtILrzGT3+msEa42N96/mW5a48EyOqzLcANnn/y+GTfzN/MOjeWbU2qQQypFw
         RPTqm9u9zNYsVS5OdDlhCsPxdXl/m2Lr0ywNAjgnTfp1zk1sVoVm9BNghh+UK8vLEi01
         eZyxY2ACKJHZVpzwjpU3i5HaTyFHMqiSpG2WueAw90Cm9f+O9Gl2wACoCybI50aYGdfx
         M8EfadXbAk/8YrEx1qttbwQeMnpQfwHi29/isPnOm/Dw2QX+uw2rxwA7l6b7aTsojgc8
         v3WQ==
X-Gm-Message-State: ACgBeo2mYLF3ZPuDtoxOFLfuspJMhUSCyLhSfuE8uxnTUJo44auuWmfK
        h2ahkBgQMJHmJh1DimrZEtxkgRS1fenhdZ+GITM=
X-Google-Smtp-Source: AA6agR4rC/Z0Bfrh+OVvZt/HZTrqs0KVGfQlC5dUWtN5+hMfWeJ+KjZ1UDp1by27Vm8aE2GJieHuc7mWg7LnOtp7X+g=
X-Received: by 2002:a5e:dc46:0:b0:689:94f6:fa3e with SMTP id
 s6-20020a5edc46000000b0068994f6fa3emr2684556iop.110.1661473159232; Thu, 25
 Aug 2022 17:19:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-2-joannelkoong@gmail.com> <CAEf4BzZm7eUX3w-NwP0JuWtvKbO6GxN911TraY5bA8-z+ocyCg@mail.gmail.com>
 <CAP01T77izAbefN5CJ1ZdjwUdii=gMFMduKTYtSbYC3S9jbRoEA@mail.gmail.com> <CAJnrk1Y0r3++RLpT2jvp4st-79x3dUYk3uP-4tfnAeL5_kgM0Q@mail.gmail.com>
In-Reply-To: <CAJnrk1Y0r3++RLpT2jvp4st-79x3dUYk3uP-4tfnAeL5_kgM0Q@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 26 Aug 2022 02:18:43 +0200
Message-ID: <CAP01T74O6ZuH_NPObYTLUjFSADjWjzfHjTsLBf8b67jgchf6Gw@mail.gmail.com>
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

On Thu, 25 Aug 2022 at 23:02, Joanne Koong <joannelkoong@gmail.com> wrote:
> [...]
> >
> > Related question, it seems we know statically if dynptr is read only
> > or not, so why even do all this hidden parameter passing and instead
> > just reject writes directly? You only need to be able to set
> > MEM_RDONLY on dynptr_data returned PTR_TO_PACKETs, and reject
> > dynptr_write when dynptr type is xdp/skb (and ctx is only one). That
> > seems simpler than checking it at runtime. Verifier already handles
> > MEM_RDONLY generically, you only need to add the guard for
> > check_packet_acces (and check_helper_mem_access for meta->raw_mode
> > under pkt case), and rejecting dynptr_write seems like a if condition.
>
> There will be other helper functions that do writes (eg memcpy to
> dynptrs, strncpy to dynptrs, probe read user to dynptrs, hashing
> dynptrs, ...) so it's more scalable if we reject these at runtime
> rather than enforce these at the verifier level. I also think it's
> cleaner to keep the verifier logic as simple as possible and do the
> checking in the helper.

I won't be pushing this further, since you know what you plan to add
in the future better, but I still disagree.

I'm guessing there might be dynptrs where this read only property is
set dynamically at runtime, which is why you want to go this route?
I.e. you might not know statically whether dynptr is read only or not?

My main confusion is the inconsistency here.

Right now the patch implicitly relies on may_access_direct_pkt_data to
protect slices returned from dynptr_data, instead of setting
MEM_RDONLY on the returned PTR_TO_PACKET. Which is fine, it's not
needed. So indirectly, you are relying on knowing statically whether
the dynptr is read only or not. But then you also set this bit at
runtime.

So you reject some cases at load time, and the rest of them only at
runtime. Direct writes to dynptr slice fails load, writes through
helper does not (only fails at runtime).

Also, dynptr_data needs to know whether dynptr is read only
statically, to protect writes to its returned pointer, unless you
decide to introduce another helper for the dynamic rdonly bit case
(like dynptr_data_rdonly). Then you have a mismatch, where dynptr_data
works for some rdonly dynptrs (known to be rdonly statically, like
this skb one), but not for others.

I also don't agree about the complexity or scalability part, all the
infra and precedence is already there. We already have similar checks
for meta->raw_mode where we reject writes to read only pointers in
check_helper_mem_access.
