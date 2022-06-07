Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D178A53F4E3
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 06:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbiFGEQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 00:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiFGEQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 00:16:10 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C796CFE07
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 21:16:07 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id r1so522166ybd.4
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 21:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8IU+TSpoyQ3EBsEzc87QXqFIO9Dd/n4Kys9xA1IO4jk=;
        b=8PkRrPQhB9xIYk5RJjIpA4Uhr1hZn7VgrHki7DCZSOuswsqCw8f0RCcLzz1Essg22w
         5MSL84HZrHNOloEnxl4PRl1GiblSpkXuxcsXYKsCiGxPtK1NsFXHvQeCNz1PWPi604da
         OWsOpf9m4vKmWV2sOxM7LjE8QDEMmbGyZ4sN5FDVsXsVKZQdc9y2f4s53vrEi5nnSFKt
         E81ApnerFUd/wkThchi69JUHjx/exIa5DTTNSeMr/HRjmwQ8Bx0GI//RmUdACcF/fm8a
         B7CEVl/W0Bnilj1bW284ojwJ4qt6XhvtaE0myff0NumoIqk5XjhRBH3uBTs+U+jYPJcQ
         igVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8IU+TSpoyQ3EBsEzc87QXqFIO9Dd/n4Kys9xA1IO4jk=;
        b=SqigSlgD5XjQpkjIAdkp3bjeBFFjhqZ60rsKuSz4gp3eMVO/bldGVtPSQH8nM8U4ac
         YLOdkfrZO9jRdqyhMZGZ/RgnbCfxEwjyGKrIziRvXrUcpd+21sew/WcNzQpJCbYy1BsS
         goDC5AwJbxe/QWGlAVXenGsvazAIaxZJ8V6eitVFx8eAL3ChU1/nzt18kIl6USrT0UBc
         eZcLDhhHgm+/RJVpBlwt/igr8LjvaLXo2H5MxtUq4UYT2foDhH2/ESWk2muPTdbgmhpX
         c1Q3W3qtEglDcblm9pSM0ZcY8OM18jVrlTo7AMPhLQ/CQ/zM1KAoptNlW11AeLgPlZhx
         EVPQ==
X-Gm-Message-State: AOAM531iChw7AAhXbbjSk4J4htg4JtTtcpT4wgB9xIz+GT1RCq7+xg4f
        zKGDX1FpaujGsiPluzHfyRvkFyYWtkPBlxFljq5SGA==
X-Google-Smtp-Source: ABdhPJz99VHJmlzr7/qFM0Idb9u4+UaulaZKxJChRmtKMdm9Wy9SXU+qQopweSVe2n3zz8EloYZzJYzIIkjv/4dNRbM=
X-Received: by 2002:a05:6902:c9:b0:641:1998:9764 with SMTP id
 i9-20020a05690200c900b0064119989764mr27854106ybs.427.1654575366739; Mon, 06
 Jun 2022 21:16:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220606070804.40268-1-songmuchun@bytedance.com>
 <CANn89iJwuW6PykKE03wB24KATtk88tS4eSHH42i+dBFtaK8zsg@mail.gmail.com>
 <CANn89iKeOfDNmy0zPWHctuUQMb4UTiGxza9j3QVMsjuXFmeuhQ@mail.gmail.com>
 <CAMZfGtXqjzrQFWB8JaiTk4z8kpEjEwNNC8MO9dxUB5hrFwn0JQ@mail.gmail.com> <CANn89i+JXJ0m8n7JZGzCb1S2fwL1vNAoRwjah_rQ0=6MsaeyhA@mail.gmail.com>
In-Reply-To: <CANn89i+JXJ0m8n7JZGzCb1S2fwL1vNAoRwjah_rQ0=6MsaeyhA@mail.gmail.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 7 Jun 2022 12:15:29 +0800
Message-ID: <CAMZfGtVQsB3OXuwpHWQ0+qiwyKtF_tUgsYxHOu=Jqvjupq_yCQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: use kvmalloc_array() to allocate table_perturb
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 7, 2022 at 12:03 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Jun 6, 2022 at 8:56 PM Muchun Song <songmuchun@bytedance.com> wrote:
> >
> > On Tue, Jun 7, 2022 at 12:13 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Mon, Jun 6, 2022 at 9:05 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Mon, Jun 6, 2022 at 12:08 AM Muchun Song <songmuchun@bytedance.com> wrote:
> > > > >
> > > > > In our server, there may be no high order (>= 6) memory since we reserve
> > > > > lots of HugeTLB pages when booting.  Then the system panic.  So use
> > > > > kvmalloc_array() to allocate table_perturb.
> > > > >
> > > > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > > >
> > > > Please add a Fixes: tag and CC original author ?
> > > >
> >
> > Will do.
> >
> > > > Thanks.
> > >
> > > Also using alloc_large_system_hash() might be a better option anyway,
> > > spreading pages on multiple nodes on NUMA hosts.
> >
> > Using alloc_large_system_hash() LGTM, but
> > I didn't see where the memory is allocated on multi-node
> > in alloc_large_system_hash() or vmalloc_huge(), what I
> > missed here?
>
> This is done by default. You do not have to do anything special. Just
> call alloc_large_system_hash().
>
> For instance, on two socket system:
>
> # grep alloc_large_system_hash /proc/vmallocinfo
> 0x000000005536618c-0x00000000a4ae0198   12288
> alloc_large_system_hash+0x1df/0x2f0 pages=2 vmalloc N0=1 N1=1
> 0x000000003beddc38-0x0000000092b61b54   12288
> alloc_large_system_hash+0x1df/0x2f0 pages=2 vmalloc N0=1 N1=1
> 0x0000000092b61b54-0x000000005c33d7fb   12288
> alloc_large_system_hash+0x1df/0x2f0 pages=2 vmalloc N0=1 N1=1
> 0x000000004c0588af-0x0000000012cf548f   12288
> alloc_large_system_hash+0x1df/0x2f0 pages=2 vmalloc N0=1 N1=1
> 0x000000008d50035e-0x00000000f434e297  266240
> alloc_large_system_hash+0x1df/0x2f0 pages=64 vmalloc N0=32 N1=32
> 0x00000000fe631da3-0x00000000b60e95b8 268439552
> alloc_large_system_hash+0x1df/0x2f0 pages=65536 vmalloc vpages
> N0=32768 N1=32768
> 0x00000000b60e95b8-0x0000000062eb7a11  528384
> alloc_large_system_hash+0x1df/0x2f0 pages=128 vmalloc N0=64 N1=64
> 0x0000000062eb7a11-0x000000005408af10 134221824
> alloc_large_system_hash+0x1df/0x2f0 pages=32768 vmalloc vpages
> N0=16384 N1=16384
> 0x000000005408af10-0x0000000054fb99eb 4198400
> alloc_large_system_hash+0x1df/0x2f0 pages=1024 vmalloc vpages N0=512
> N1=512
> 0x0000000054fb99eb-0x00000000a130e604 4198400
> alloc_large_system_hash+0x1df/0x2f0 pages=1024 vmalloc vpages N0=512
> N1=512
> 0x00000000a130e604-0x00000000e6e62c85 4198400
> alloc_large_system_hash+0x1df/0x2f0 pages=1024 vmalloc vpages N0=512
> N1=512
> 0x00000000e6e62c85-0x000000005ca0ef7c 2101248
> alloc_large_system_hash+0x1df/0x2f0 pages=512 vmalloc N0=256 N1=256
> 0x000000005ca0ef7c-0x000000003bfe757f 1052672
> alloc_large_system_hash+0x1df/0x2f0 pages=256 vmalloc N0=128 N1=128
> 0x000000003bfe757f-0x00000000bf49fcbd 4198400
> alloc_large_system_hash+0x1df/0x2f0 pages=1024 vmalloc vpages N0=512
> N1=512
> 0x00000000bf49fcbd-0x00000000902de200 1052672
> alloc_large_system_hash+0x1df/0x2f0 pages=256 vmalloc N0=128 N1=128
> 0x00000000902de200-0x00000000c3d2821a 2101248
> alloc_large_system_hash+0x1df/0x2f0 pages=512 vmalloc N0=256 N1=256
> 0x00000000c3d2821a-0x000000002ddc68f6 2101248
> alloc_large_system_hash+0x1df/0x2f0 pages=512 vmalloc N0=256 N1=256
>
> You can see N0=X and N1=X meaning pages are evenly spread among the two nodes.

Thanks a lot. Really helpful information.
