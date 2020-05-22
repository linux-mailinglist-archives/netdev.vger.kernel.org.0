Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B33D1DDC58
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgEVAx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgEVAx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:53:27 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814E8C061A0E;
        Thu, 21 May 2020 17:53:27 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id x22so5565952lfd.4;
        Thu, 21 May 2020 17:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CQbuKHK4Fpjn4KjGNbdOe7m3KtF6KBLy2S3JAIVDZ7w=;
        b=dFW5HF+EXcUG1IA/kdnBkznwnNNCeEfFSsT4rGTAXO4x2amNEqP0A1O13WH6Oyoxlw
         FeI0S+wLKGoBf2YPGEEKCY+zDJiq5uchG0tCjxTm6VHawcUYqSxu2Ieu1vBYo9fKGqVp
         gCTaQsMGJ/v0seBWVQ7ZSRFRQhtBxo0v7jx7LqDokuTK5LuW7EdePA/lRfwpbnavDCah
         fOI+pPWYUoGro+VLKUdk97uSqFDjeLISUFdEpqNMa0RRwS6kaGp4Tubz/kXR+wtfpOpY
         8ExRB/hE+1lONiaXDvakBsfNUx3ndsLpSNZxelHH4Lnwu2DExIp7ypWE9sNuACgmJ/62
         U4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CQbuKHK4Fpjn4KjGNbdOe7m3KtF6KBLy2S3JAIVDZ7w=;
        b=tz0LBzuRvBvBe/pSplu13FpvYo0eSmQKRcJqDhwIafFzqQE60MTXrOMVMUP3Q1aeUf
         4TA0JaiIDhv1vF/ZzVZPSdWgKQ2B+BboevKwcy2DZim2fabo2ZVUrhGKDllj7mZZbOdF
         KT7v+r0IklezfNqf33OfZFfpb5UwvX1LHhbTgcDzPM3cTjwul5HnkgvjrL7ZLj5KUxZb
         nSxcaTDmWGAb1k1I1XPsMWXuPNTCbQYnzWnnuN3XIDukNu7TtcUwL4iFFIYE2EY7Fjmu
         nlGFC7Onwuh69/noPl+OOEh18z3wEW617JbzUOZb/xmuB934JJxaEL9/AhK5zV4/97lZ
         5BaA==
X-Gm-Message-State: AOAM533pCksZofhE30Iz8bLKViwqFDMzVGfaxOLebSjWXBnqneHV9fQb
        00XaXWe5rU6o3tfdsrOjvUSjnqFjGL6CdV/v9FVL0Q==
X-Google-Smtp-Source: ABdhPJysWdLo12/9qdSGEHKozzyKc1/jYR6Zv/ERBaKu8fFpwKjZWqt+ASyGw9F92rGP2zG8V0VNF9FG9u1mtboeJiI=
X-Received: by 2002:a19:48e:: with SMTP id 136mr1505646lfe.134.1590108805977;
 Thu, 21 May 2020 17:53:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200520172258.551075-1-jakub@cloudflare.com> <CAEf4BzbpMp9D0TsC5dhRJ-AeKqsXJ5EyEcCx2-kkZg+ZBnHYqg@mail.gmail.com>
In-Reply-To: <CAEf4BzbpMp9D0TsC5dhRJ-AeKqsXJ5EyEcCx2-kkZg+ZBnHYqg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 May 2020 17:53:14 -0700
Message-ID: <CAADnVQKztsp-fF5Mbi7DUGrM-5SfH24xntaF0Qaewxr9ax7ZRw@mail.gmail.com>
Subject: Re: [PATCH bpf] flow_dissector: Drop BPF flow dissector prog ref on
 netns cleanup
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 12:09 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, May 20, 2020 at 10:24 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >
> > When attaching a flow dissector program to a network namespace with
> > bpf(BPF_PROG_ATTACH, ...) we grab a reference to bpf_prog.
> >
> > If netns gets destroyed while a flow dissector is still attached, and there
> > are no other references to the prog, we leak the reference and the program
> > remains loaded.
> >
> > Leak can be reproduced by running flow dissector tests from selftests/bpf:
> >
> >   # bpftool prog list
> >   # ./test_flow_dissector.sh
> >   ...
> >   selftests: test_flow_dissector [PASS]
> >   # bpftool prog list
> >   4: flow_dissector  name _dissect  tag e314084d332a5338  gpl
> >           loaded_at 2020-05-20T18:50:53+0200  uid 0
> >           xlated 552B  jited 355B  memlock 4096B  map_ids 3,4
> >           btf_id 4
> >   #
> >
> > Fix it by detaching the flow dissector program when netns is going away.
> >
> > Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > ---
> >
> > Discovered while working on bpf_link support for netns-attached progs.
> > Looks like bpf tree material so pushing it out separately.
> >
> > -jkbs
> >
>
> [...]
>
> >  /**
> >   * __skb_flow_get_ports - extract the upper layer ports and return them
> >   * @skb: sk_buff to extract the ports from
> > @@ -1827,6 +1848,8 @@ EXPORT_SYMBOL(flow_keys_basic_dissector);
> >
> >  static int __init init_default_flow_dissectors(void)
> >  {
> > +       int err;
> > +
> >         skb_flow_dissector_init(&flow_keys_dissector,
> >                                 flow_keys_dissector_keys,
> >                                 ARRAY_SIZE(flow_keys_dissector_keys));
> > @@ -1836,7 +1859,11 @@ static int __init init_default_flow_dissectors(void)
> >         skb_flow_dissector_init(&flow_keys_basic_dissector,
> >                                 flow_keys_basic_dissector_keys,
> >                                 ARRAY_SIZE(flow_keys_basic_dissector_keys));
> > -       return 0;
> > +
> > +       err = register_pernet_subsys(&flow_dissector_pernet_ops);
> > +
> > +       WARN_ON(err);
>
> syzbot simulates memory allocation failures, which can bubble up here,
> so this WARN_ON will probably trigger. I wonder if this could be
> rewritten so that init fails, when registration fails? What are the
> consequences?

good catch. that warn is pointless.
I removed it and force pushed the bpf tree.
