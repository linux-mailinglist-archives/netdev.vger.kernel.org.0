Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B715F01E6
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 02:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiI3AuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 20:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiI3AuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 20:50:11 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B895241D1E
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 17:50:08 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id iv17so1960674wmb.4
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 17:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=J2OnT+99jfBJwY5gSjqGz6Sz6X53HoQmoREK97BD/aI=;
        b=dVCry9+1+nMwPzNXQ5zZVJNFEt6Pj2+kHu76HdQaK0DDlILkY4tT8SgBIWC7LA0G5z
         PU/9f61t/Rh2JizHa7IOgN0HAMGVJVyBH0sCvu4owYvRRHRYDXir4u0UbC66TzUY6OiA
         +bTolOHxoWVQoo1Is8f7B7YIHhXQU4NTyObWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=J2OnT+99jfBJwY5gSjqGz6Sz6X53HoQmoREK97BD/aI=;
        b=IVIKlP8+PvQCNGOklpnnuc/pTIwvgtGNp/ZfxzO/q2lJcuJFTUmL6S9qsREBDS48XH
         OaHtCgo2sipQ89Og6f6SrqFqgXCHUyBm72xj1tPHMjy1rRzEdfxRv7QEXBZI2Wg89DiV
         DSGvCBJBQ8y5uRB4e5JeLIGERItpT9sSg7OzFCwPFzMmLlogv8bD2VdWCSqqlBnLXdHc
         +ixfAC8GF5rl90rPrTGON4NZn6BNx2jRe9Em2ZfU3A3dvODpVneScnK8VCCFylFOwqS5
         WD+JWhmTfHtZ6U0J+id1jKreWh0tD5A4faY1ns2Eu7+AeUedfQHsbJP9ZbHd6XPrYWmy
         pfeA==
X-Gm-Message-State: ACrzQf3CJYxktP19ld9IAp8UXnKMhJqa+Tym0VyWlgMKFuH1k8+eHn2/
        d2Re0uEr5hGjfx+uxtBaGd0SfUojmNnmJULLKY1TQA==
X-Google-Smtp-Source: AMsMyM4edvNmMWYDgGs1EYacfER3/lj/kkdldCXMmEq/+9VgRLF/JJSpkBybwbt6D7PD5QWCWDnk4nspyOwuQPGlNIQ=
X-Received: by 2002:a05:600c:1c84:b0:3b3:ef37:afd3 with SMTP id
 k4-20020a05600c1c8400b003b3ef37afd3mr3987396wms.155.1664499006744; Thu, 29
 Sep 2022 17:50:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220928064538.667678-1-uekawa@chromium.org> <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
 <20220928052738-mutt-send-email-mst@kernel.org> <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
 <CADgJSGHxPWXJjbakEeWnqF42A03yK7Dpw6U1SKNLhk+B248Ymg@mail.gmail.com>
 <20220929031419-mutt-send-email-mst@kernel.org> <20220929074606.yqzihpcc7cl442c5@sgarzare-redhat>
 <20220929034807-mutt-send-email-mst@kernel.org> <20220929090731.27cda58c@kernel.org>
 <20220929122444-mutt-send-email-mst@kernel.org> <20220929110740.77942060@kernel.org>
In-Reply-To: <20220929110740.77942060@kernel.org>
From:   =?UTF-8?B?SnVuaWNoaSBVZWthd2EgKOS4iuW3nee0lOS4gCk=?= 
        <uekawa@chromium.org>
Date:   Fri, 30 Sep 2022 09:49:54 +0900
Message-ID: <CADgJSGGNjsnmzVdHkhqDN+_1cJxcPYe-U=a4A4TAL8PA6=owCw@mail.gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

It doesn't really crash the kernel causing send failures (I think the
error might not be handled quite right but not sure if that's on the
sftp end or the vsock part). Symptom is sftp-over-vsock sitting there
presumably failing to send any data anymore at one point.



[ 5071.211895] vhost-5837: page allocation failure: order:4, mode:0x24040c0
[ 5071.211900] CPU: 0 PID: 5859 Comm: vhost-5837 Tainted: G         C
    4.4.302-21729-g34b1226044a7 #1
[ 5071.211902] Hardware name: Google Atlas/Atlas, BIOS
Google_Atlas.11827.125.0 11/09/2020
[ 5071.211904]  aaaaaaaaaaaaaaaa 0b812745f761e452 ffff8803b9a23bc0
ffffffffb6a0df64
[ 5071.211909]  0000000000000002 0000003000000020 0000000000000282
0b812745f761e452
[ 5071.211913]  0000000000000001 ffff8803b9a23c58 ffffffffb68d6aed
0000000200000040
[ 5071.211917] Call Trace:
[ 5071.211922]  [<ffffffffb6a0df64>] dump_stack+0x97/0xdb
[ 5071.211925]  [<ffffffffb68d6aed>] warn_alloc_failed+0x10f/0x138
[ 5071.211928]  [<ffffffffb68d868a>] ? __alloc_pages_direct_compact+0x38/0x=
c8
[ 5071.211931]  [<ffffffffb664619f>] __alloc_pages_nodemask+0x84c/0x90d
[ 5071.211933]  [<ffffffffb6646e56>] alloc_kmem_pages+0x17/0x19
[ 5071.211936]  [<ffffffffb6653a26>] kmalloc_order_trace+0x2b/0xdb
[ 5071.211938]  [<ffffffffb66682f3>] __kmalloc+0x177/0x1f7
[ 5071.211941]  [<ffffffffb66e0d94>] ? copy_from_iter+0x8d/0x31d
[ 5071.211945]  [<ffffffffc0689ab7>]
vhost_vsock_handle_tx_kick+0x1fa/0x301 [vhost_vsock]
[ 5071.211949]  [<ffffffffc06828d9>] vhost_worker+0xf7/0x157 [vhost]
[ 5071.211951]  [<ffffffffb683ddce>] kthread+0xfd/0x105
[ 5071.211954]  [<ffffffffc06827e2>] ? vhost_dev_set_owner+0x22e/0x22e [vho=
st]
[ 5071.211956]  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
[ 5071.211959]  [<ffffffffb6eb332e>] ret_from_fork+0x4e/0x80
[ 5071.211961]  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
[ 5071.212605] Mem-Info:
[ 5071.212609] active_anon:1454995 inactive_anon:383258 isolated_anon:0
                active_file:968668 inactive_file:970304 isolated_file:0
                unevictable:8176 dirty:892826 writeback:213 unstable:0
                slab_reclaimable:67232 slab_unreclaimable:26022
                mapped:1549569 shmem:1536241 pagetables:19892 bounce:0
                free:22525 free_pcp:22 free_cma:0
[ 5071.212614] DMA free:15840kB min:12kB low:12kB high:16kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15996kB
managed:15904kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB
shmem:0kB slab_reclaimable:0kB slab_unreclaimable:64kB
kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB
local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? yes
[ 5071.212616] lowmem_reserve[]: 0 1864 15903 15903
[ 5071.212623] DMA32 free:58268kB min:1888kB low:2360kB high:2832kB
active_anon:521800kB inactive_anon:282196kB active_file:454328kB
inactive_file:455308kB unevictable:3996kB isolated(anon):0kB
isolated(file):0kB present:1992216kB managed:1912404kB mlocked:0kB
dirty:421280kB writeback:180kB mapped:678312kB shmem:669844kB
slab_reclaimable:37700kB slab_unreclaimable:13744kB
kernel_stack:2800kB pagetables:9932kB unstable:0kB bounce:0kB
free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:256 all_unreclaimable? no
[ 5071.212625] lowmem_reserve[]: 0 0 14038 14038
[ 5071.212631] Normal free:15992kB min:14240kB low:17800kB
high:21360kB active_anon:5298180kB inactive_anon:1250836kB
active_file:3420344kB inactive_file:3425908kB unevictable:28708kB
isolated(anon):0kB isolated(file):0kB present:14663680kB
managed:14375736kB mlocked:80kB dirty:3150024kB writeback:672kB
mapped:5519964kB shmem:5475120kB slab_reclaimable:231228kB
slab_unreclaimable:90280kB kernel_stack:20752kB pagetables:69636kB
unstable:0kB bounce:0kB free_pcp:88kB local_pcp:88kB free_cma:0kB
writeback_tmp:0kB pages_scanned:5188 all_unreclaimable? no
[ 5071.212633] lowmem_reserve[]: 0 0 0 0
[ 5071.212637] DMA: 0*4kB 0*8kB 0*16kB 1*32kB (U) 1*64kB (U) 1*128kB
(U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (U) 3*4096kB (M) =3D
15840kB
[ 5071.212651] DMA32: 233*4kB (UME) 360*8kB (UME) 71*16kB (UM) 56*32kB
(UME) 30*64kB (UME) 45*128kB (UME) 38*256kB (UME) 19*512kB (UME)
6*1024kB (UM) 3*2048kB (UME) 3*4096kB (UM) =3D 58452kB
[ 5071.212668] Normal: 887*4kB (UME) 1194*8kB (UME) 174*16kB (U)
0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D
15884kB
[ 5071.212680] 3475331 total pagecache pages
[ 5071.212681] 6 pages in swap cache
[ 5071.212682] Swap cache stats: add 45354, delete 45348, find 0/1601
[ 5071.212683] Free swap  =3D 23774356kB
[ 5071.212684] Total swap =3D 23882876kB
[ 5071.212686] 4167973 pages RAM
[ 5071.212687] 0 pages HighMem/MovableOnly
[ 5071.212688] 91962 pages reserved


2022=E5=B9=B49=E6=9C=8830=E6=97=A5(=E9=87=91) 3:07 Jakub Kicinski <kuba@ker=
nel.org>:
>
> On Thu, 29 Sep 2022 12:25:14 -0400 Michael S. Tsirkin wrote:
> > On Thu, Sep 29, 2022 at 09:07:31AM -0700, Jakub Kicinski wrote:
> > > On Thu, 29 Sep 2022 03:49:18 -0400 Michael S. Tsirkin wrote:
> > > > net tree would be preferable, my pull for this release is kind of r=
eady ... kuba?
> > >
> > > If we're talking about 6.1 - we can take it, no problem.
> >
> > I think they want it in 6.0 as it fixes a crash.
>
> I thought it's just an OOM leading to send failure. Junichi could you
> repost with the tags collected and the header for that stack trace
> included? The line that says it's just an OOM...
>

I think this is what you asked for but I don't quite know what you
mean by the tags

> "someone tried to alloc >32kB because it worked on a freshly booted
> system" kind of cases are a dime a dozen, no?..
