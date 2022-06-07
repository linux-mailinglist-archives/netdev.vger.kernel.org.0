Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B820553F4D4
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 06:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiFGEEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 00:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236520AbiFGEEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 00:04:02 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDE46E8C7
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 21:03:59 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id a30so10329122ybj.3
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 21:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l0GUWANS5qVYUfourDqKhw0C7rK3Jri1LTo+9uMnlC0=;
        b=qDIM15Vz7+hiA+64RGDqm1yrKpLfcGDigFCMhMMwNdmhH4bQXic4EyhjSi6CLQkX37
         RVJ9gN0Luq3B1INSdPgcOZL0Z6jx/Mb1Z4vDaL4Ewo8C6L4u2beGjFOEVB3xBKz4GcGW
         uhsefP5x3na2Eq2Ty40fiiB+j8VDRoxZMtsZ3IXU5H94BjfI9Q0aS73op0rGbL2xQ4s1
         Rsz9RPCTJES8R2TxEWqrT/t5il+/uGU+iJcFbGKYT4HkYZNey0kRE7zGUg11BgU2WQ2j
         QhAz8naDciSHz4Bhry/G2LUQclKnKFpp6rO0ExASjHaAb3vJ/LWDNxEfihuSfnOHnmVg
         TDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l0GUWANS5qVYUfourDqKhw0C7rK3Jri1LTo+9uMnlC0=;
        b=nXK0qUzmL00WIsslnP14S7vNijyeQQfz4ez300qvF0MyuUlli2wmTwfj2pwZL50xMh
         MVxVd8t6gjUq/ecPKIDOw281ObNo1tF1axIu4qBv8H1Aj+bwxrISsjLJHRpvviRduddu
         rpGoXN38IcJ7FbrY8895lNg4+coMHnTrEvTg8NVV30v4+0avdVoXqc1Xac5gLnCy/rJM
         +VkAtXYfprnAAfwrcRVgJWoHWYZ4Y/yTBcmFRMHy+jMuvQaEy5RDSeVzdjV8bcYdlP4W
         kNrg5REBB5Kl11vP2wHpKlE6NJVIf2I3jjfbW0HbK1PDWicUHOT5gBwELFMAW7kEeuQt
         Hx/Q==
X-Gm-Message-State: AOAM532zAB40QYXDVljyDq0ri2JSFCMQJxfNRCZQ+VD/9RWWwPB6ZsJZ
        mnKIZqt0g0LxhA/4Y1fDOu+A/fvlistFKkNp59L1Bg==
X-Google-Smtp-Source: ABdhPJyk/+hNd9OtvwcKJfxETK+s7TsxD9WrsUQsyWZjcF2gYNyyreHKRXrdaRhugxKLeZsuDs45tK71dVua0ytvjsY=
X-Received: by 2002:a5b:148:0:b0:650:15bd:97ab with SMTP id
 c8-20020a5b0148000000b0065015bd97abmr28723080ybp.231.1654574638674; Mon, 06
 Jun 2022 21:03:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220606070804.40268-1-songmuchun@bytedance.com>
 <CANn89iJwuW6PykKE03wB24KATtk88tS4eSHH42i+dBFtaK8zsg@mail.gmail.com>
 <CANn89iKeOfDNmy0zPWHctuUQMb4UTiGxza9j3QVMsjuXFmeuhQ@mail.gmail.com> <CAMZfGtXqjzrQFWB8JaiTk4z8kpEjEwNNC8MO9dxUB5hrFwn0JQ@mail.gmail.com>
In-Reply-To: <CAMZfGtXqjzrQFWB8JaiTk4z8kpEjEwNNC8MO9dxUB5hrFwn0JQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Jun 2022 21:03:47 -0700
Message-ID: <CANn89i+JXJ0m8n7JZGzCb1S2fwL1vNAoRwjah_rQ0=6MsaeyhA@mail.gmail.com>
Subject: Re: [PATCH] tcp: use kvmalloc_array() to allocate table_perturb
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 8:56 PM Muchun Song <songmuchun@bytedance.com> wrote:
>
> On Tue, Jun 7, 2022 at 12:13 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Jun 6, 2022 at 9:05 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Mon, Jun 6, 2022 at 12:08 AM Muchun Song <songmuchun@bytedance.com> wrote:
> > > >
> > > > In our server, there may be no high order (>= 6) memory since we reserve
> > > > lots of HugeTLB pages when booting.  Then the system panic.  So use
> > > > kvmalloc_array() to allocate table_perturb.
> > > >
> > > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > >
> > > Please add a Fixes: tag and CC original author ?
> > >
>
> Will do.
>
> > > Thanks.
> >
> > Also using alloc_large_system_hash() might be a better option anyway,
> > spreading pages on multiple nodes on NUMA hosts.
>
> Using alloc_large_system_hash() LGTM, but
> I didn't see where the memory is allocated on multi-node
> in alloc_large_system_hash() or vmalloc_huge(), what I
> missed here?

This is done by default. You do not have to do anything special. Just
call alloc_large_system_hash().

For instance, on two socket system:

# grep alloc_large_system_hash /proc/vmallocinfo
0x000000005536618c-0x00000000a4ae0198   12288
alloc_large_system_hash+0x1df/0x2f0 pages=2 vmalloc N0=1 N1=1
0x000000003beddc38-0x0000000092b61b54   12288
alloc_large_system_hash+0x1df/0x2f0 pages=2 vmalloc N0=1 N1=1
0x0000000092b61b54-0x000000005c33d7fb   12288
alloc_large_system_hash+0x1df/0x2f0 pages=2 vmalloc N0=1 N1=1
0x000000004c0588af-0x0000000012cf548f   12288
alloc_large_system_hash+0x1df/0x2f0 pages=2 vmalloc N0=1 N1=1
0x000000008d50035e-0x00000000f434e297  266240
alloc_large_system_hash+0x1df/0x2f0 pages=64 vmalloc N0=32 N1=32
0x00000000fe631da3-0x00000000b60e95b8 268439552
alloc_large_system_hash+0x1df/0x2f0 pages=65536 vmalloc vpages
N0=32768 N1=32768
0x00000000b60e95b8-0x0000000062eb7a11  528384
alloc_large_system_hash+0x1df/0x2f0 pages=128 vmalloc N0=64 N1=64
0x0000000062eb7a11-0x000000005408af10 134221824
alloc_large_system_hash+0x1df/0x2f0 pages=32768 vmalloc vpages
N0=16384 N1=16384
0x000000005408af10-0x0000000054fb99eb 4198400
alloc_large_system_hash+0x1df/0x2f0 pages=1024 vmalloc vpages N0=512
N1=512
0x0000000054fb99eb-0x00000000a130e604 4198400
alloc_large_system_hash+0x1df/0x2f0 pages=1024 vmalloc vpages N0=512
N1=512
0x00000000a130e604-0x00000000e6e62c85 4198400
alloc_large_system_hash+0x1df/0x2f0 pages=1024 vmalloc vpages N0=512
N1=512
0x00000000e6e62c85-0x000000005ca0ef7c 2101248
alloc_large_system_hash+0x1df/0x2f0 pages=512 vmalloc N0=256 N1=256
0x000000005ca0ef7c-0x000000003bfe757f 1052672
alloc_large_system_hash+0x1df/0x2f0 pages=256 vmalloc N0=128 N1=128
0x000000003bfe757f-0x00000000bf49fcbd 4198400
alloc_large_system_hash+0x1df/0x2f0 pages=1024 vmalloc vpages N0=512
N1=512
0x00000000bf49fcbd-0x00000000902de200 1052672
alloc_large_system_hash+0x1df/0x2f0 pages=256 vmalloc N0=128 N1=128
0x00000000902de200-0x00000000c3d2821a 2101248
alloc_large_system_hash+0x1df/0x2f0 pages=512 vmalloc N0=256 N1=256
0x00000000c3d2821a-0x000000002ddc68f6 2101248
alloc_large_system_hash+0x1df/0x2f0 pages=512 vmalloc N0=256 N1=256

You can see N0=X and N1=X meaning pages are evenly spread among the two nodes.
