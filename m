Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAA76E9AA1
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjDTRXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbjDTRXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:23:39 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79813A86;
        Thu, 20 Apr 2023 10:23:35 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f178da21afso6044515e9.1;
        Thu, 20 Apr 2023 10:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682011414; x=1684603414;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HesDPTh6EVGnZ/8YgentTE5ECfT7N3dVJtS3uzj6Z+s=;
        b=X3p9+dXj/ZNHJNaOG+bCE7A3TlpRc+bBE0KP0yYyOHb3mmE/C+ojrmtf7uBhvuU5nn
         xOEfW4n/cxTfwZ+enNV2mvo9WXqNrfUfbrfDhgCzegbFjQ8WLnfG6H2ycCuaqdIY1gO2
         I1m5PI94bWIdRlZ8twLSQ5SXuZRdrN5ltqcWfGFPlHR2uJ06nV7e7KuU23L1SNKSQvm8
         jFMRrCvOrUAtuqjxSkNBloklFdHVwcbMIXbYvwFzq4UaGAxci9StI5KHWPQVAI20bDFs
         lUgBySD6ogJQ+fnYA2avSEkjZfFLBJxlrQemW0NzU811vi7cY+auzQWooCQJz2YNS02y
         5aAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682011414; x=1684603414;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HesDPTh6EVGnZ/8YgentTE5ECfT7N3dVJtS3uzj6Z+s=;
        b=FFnyXQgtLOZCk2fedq379eHd32RQzuRuXdMHspko3biV9q50oUcB3/11/syC02huPq
         HVEBDwq0dXy2bg/4KKM2bo1T2IrVnKP60da/3qUasx4C3hHCRV4HsGqRvcfWne1pyoXj
         nQKDVqeNXN7ngcRxbB8v+/KpSjYxbptXDjwaoGi9nxHjrxno1wwQJhQtWqqTgCAfCemX
         3fwNvsYJkqHoXW5vckr5g/B5PFAJJtUvb/cRw6IgDTzWDQ+f9dMDzvWXkRjVaGYJ2q8X
         vS29sFiW0hCPjvtwKFgrCeo8XG0MBaMCf92sjRpKrR7FHgIzuxGG78OHEpN7XPEHqgO9
         LLbw==
X-Gm-Message-State: AAQBX9fQ5rQadOgyL+9RdJHMB6KOedzJ+xNSuO/vz3Xj+KrvE3xVngLp
        y9WZBHWMkRxWZuYoC46Fe3M=
X-Google-Smtp-Source: AKy350YDMQ1kUuSMMwp25/fLvRVIdqoSLzOIPqMWpyo8AkLyp0sy1X8sDAuotEKv9IG41Wa/X+J87Q==
X-Received: by 2002:adf:f349:0:b0:2ef:b8e3:46fd with SMTP id e9-20020adff349000000b002efb8e346fdmr2026282wrp.38.1682011413963;
        Thu, 20 Apr 2023 10:23:33 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c205300b003f173a00304sm5856629wmg.17.2023.04.20.10.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 10:23:33 -0700 (PDT)
Date:   Thu, 20 Apr 2023 19:23:13 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org, alexanderduyck@fb.com,
        lucien.xin@gmail.com, lixiaoyan@google.com, iwienand@redhat.com,
        leon@kernel.org, ye.xingchen@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] gro: optimise redundant parsing of packets
Message-ID: <20230420172311.GA38309@debian>
References: <20230320163703.GA27712@debian>
 <20230320170009.GA27961@debian>
 <889f2dc5e646992033e0d9b0951d5a42f1907e07.camel@redhat.com>
 <CANn89iK_bsPoaRVe+FNZ7LF_eLbz2Af6kju4j9TVHtbgkpcn5g@mail.gmail.com>
 <20230322193309.GA32681@debian>
 <352c24ff0c1b3a9f63062c21bbee0dca1b9ebfff.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <352c24ff0c1b3a9f63062c21bbee0dca1b9ebfff.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, 2023-03-22 at 20:33 +0100, Richard Gobert wrote:
> > > On Wed, Mar 22, 2023 at 2:59 AM Paolo Abeni <pabeni@redhat.com>
> > > wrote:
> > > > 
> > > > On Mon, 2023-03-20 at 18:00 +0100, Richard Gobert wrote:
> > > > > Currently the IPv6 extension headers are parsed twice: first in
> > > > > ipv6_gro_receive, and then again in ipv6_gro_complete.
> > > > > 
> > > > > By using the new ->transport_proto field, and also storing the
> > > > > size of the
> > > > > network header, we can avoid parsing extension headers a second
> > > > > time in
> > > > > ipv6_gro_complete (which saves multiple memory dereferences and
> > > > > conditional
> > > > > checks inside ipv6_exthdrs_len for a varying amount of
> > > > > extension headers in
> > > > > IPv6 packets).
> > > > > 
> > > > > The implementation had to handle both inner and outer layers in
> > > > > case of
> > > > > encapsulation (as they can't use the same field). I've applied
> > > > > a similar
> > > > > optimisation to Ethernet.
> > > > > 
> > > > > Performance tests for TCP stream over IPv6 with a varying
> > > > > amount of
> > > > > extension headers demonstrate throughput improvement of ~0.7%.
> > > > 
> > > > I'm surprised that the improvement is measurable: for large
> > > > aggregate
> > > > packets a single ipv6_exthdrs_len() call is avoided out of tens
> > > > calls
> > > > for the individual pkts. Additionally such figure is comparable
> > > > to
> > > > noise level in my tests.
> > 
> > It's not simple but I made an effort to make a quiet environment.
> > Correct configuration allows for this kind of measurements to be made
> > as the test is CPU bound and noise is a variance that can be reduced
> > with 
> > enough samples.
> > 
> > Environment example: (100Gbit NIC (mlx5), physical machine, i9 12th
> > gen)
> > 
> >     # power-management and hyperthreading disabled in BIOS
> >     # sysctl preallocate net mem
> >     echo 0 > /sys/devices/system/cpu/cpufreq/boost # disable
> > turboboost
> >     ethtool -A enp1s0f0np0 rx off tx off autoneg off # no PAUSE
> > frames
> > 
> >     # Single core performance
> >     for x in /sys/devices/system/cpu/cpu[1-9]*/online; do echo 0
> > >"$x"; done
> > 
> >     ./network-testing-master/bin/netfilter_unload_modules.sh
> > 2>/dev/null # unload netfilter
> >     tuned-adm profile latency-performance
> >     cpupower frequency-set -f 2200MHz # Set core to specific
> > frequency
> >     systemctl isolate rescue-ssh.target
> >     # and kill all processes besides init
> > 
> > > > This adds a couple of additional branches for the common (no
> > > > extensions
> > > > header) case.
> > 
> > The additional branch in ipv6_gro_receive would be negligible or even
> > non-existent for a branch predictor in the common case
> > (non-encapsulated packets).
> > I could wrap it with a likely macro if you wish.
> > Inside ipv6_gro_complete a couple of branches are saved for the
> > common
> > case as demonstrated below.
> > 
> > original code ipv6_gro_complete (ipv6_exthdrs_len is inlined):
> > 
> >     // if (skb->encapsulation)
> > 
> >     ffffffff81c4962b:	f6 87 81 00 00 00 20 	testb 
> > $0x20,0x81(%rdi)
> >     ffffffff81c49632:	74 2a                	je    
> > ffffffff81c4965e <ipv6_gro_complete+0x3e>
> > 
> >     ...
> > 
> >     // nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
> > 
> >     ffffffff81c4969c:	eb 1b                	jmp   
> > ffffffff81c496b9 <ipv6_gro_complete+0x99>    <-- jump to beginning of
> > for loop
> >     ffffffff81c4968e:   b8 28 00 00 00          mov    $0x28,%eax
> >     ffffffff81c49693:   31 f6                   xor    %esi,%esi
> >     ffffffff81c49695:   48 c7 c7 c0 28 aa 82    mov   
> > $0xffffffff82aa28c0,%rdi
> >     ffffffff81c4969c:   eb 1b                   jmp   
> > ffffffff81c496b9 <ipv6_gro_complete+0x99>
> >     ffffffff81c4969e:   f6 41 18 01             testb 
> > $0x1,0x18(%rcx)
> >     ffffffff81c496a2:   74 34                   je    
> > ffffffff81c496d8 <ipv6_gro_complete+0xb8>    <--- 3rd conditional
> > check: !((*opps)->flags & INET6_PROTO_GSO_EXTHDR)
> >     ffffffff81c496a4:   48 98                   cltq  
> >     ffffffff81c496a6:   48 01 c2                add    %rax,%rdx
> >     ffffffff81c496a9:   0f b6 42 01             movzbl 0x1(%rdx),%eax
> >     ffffffff81c496ad:   0f b6 0a                movzbl (%rdx),%ecx
> >     ffffffff81c496b0:   8d 04 c5 08 00 00 00    lea   
> > 0x8(,%rax,8),%eax
> >     ffffffff81c496b7:   01 c6                   add    %eax,%esi
> >     ffffffff81c496b9:   85 c9                   test   %ecx,%ecx    
> > <--- for loop starts here
> >     ffffffff81c496bb:   74 e7                   je    
> > ffffffff81c496a4 <ipv6_gro_complete+0x84>    <--- 1st conditional
> > check: proto != NEXTHDR_HOP
> >     ffffffff81c496bd:   48 8b 0c cf             mov   
> > (%rdi,%rcx,8),%rcx
> >     ffffffff81c496c1:   48 85 c9                test   %rcx,%rcx
> >     ffffffff81c496c4:   75 d8                   jne   
> > ffffffff81c4969e <ipv6_gro_complete+0x7e>    <--- 2nd conditional
> > check: unlikely(!(*opps))
> >     
> >     ... (indirect call ops->callbacks.gro_complete)
> > 
> > ipv6_exthdrs_len contains a loop which has 3 conditional checks.
> > For the common (no extensions header) case, in the new code, *all 3
> > branches are completely avoided*
> > 
> > patched code ipv6_gro_complete:
> > 
> >     // if (skb->encapsulation)
> >     ffffffff81befe58:   f6 83 81 00 00 00 20    testb 
> > $0x20,0x81(%rbx)
> >     ffffffff81befe5f:   74 78                   je    
> > ffffffff81befed9 <ipv6_gro_complete+0xb9>
> >     
> >     ...
> >     
> >     // else
> >     ffffffff81befed9:	0f b6 43 50          	movzbl
> > 0x50(%rbx),%eax
> >     ffffffff81befedd:	0f b7 73 4c          	movzwl
> > 0x4c(%rbx),%esi
> >     ffffffff81befee1:	48 8b 0c c5 c0 3f a9 	mov    -
> > 0x7d56c040(,%rax,8),%rcx
> >     
> >     ... (indirect call ops->callbacks.gro_complete)
> > 
> > Thus, the patch is beneficial for both the common case and the ext
> > hdr
> > case. I would appreciate a second consideration :)
> 
> A problem with the above analysis is that it does not take in
> consideration the places where the new branch are added:
> eth_gro_receive() and ipv6_gro_receive().
> 
> Note that such functions are called for each packet on the wire:
> multiple times for each aggregate packets. 
> 
> The above is likely not measurable in terms on pps delta, but the added
> CPU cycles spent for the common case are definitely there. In my
> opinion that outlast the benefit for the extensions header case.
> 
> Cheers,
> 
> Paolo
> 
> p.s. please refrain from off-list ping. That is ignored by most and
> considered rude by some.

Thanks,
I will re-post the first patch as a new one.
As for the second patch, I get your point, you are correct. I didn't
pay enough attention to the accumulated overhead during the receive phase, as it
wasn't showing up in my measurements. I'll look further into it, and check if I
can come up with a better solution.

Sorry for the off-list ping, is it ok to send a ping via the mailing list?
