Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CD95E7DF2
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbiIWPKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiIWPKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:10:10 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5AEA6C3E;
        Fri, 23 Sep 2022 08:10:09 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id a8so701936lff.13;
        Fri, 23 Sep 2022 08:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date;
        bh=hwfpnky+kIGo+6BQx8KdkTZdwoBXJ3O3qQ3V/MMGJ2A=;
        b=BIAfiW5N0huK12QJFQGlWS36v5duFfTFhPIL5P8CSd7cFfrvpohsj9C/SmDfqfE3dK
         w60UDYJH4a88/UiomenYEkRGJ+UMwWaTAGbOCvvmdzvklxmcQxz2qT3SRjgkDyzf5X/7
         yBzrcMPHJ31oq9uhTY+j6B/JpCdppMuuO+D1u0cyq0uL43bXjx7SSq8qeSB0JnFWg09p
         +jj02AHFLUnqFX0ryGL3bxcnWx8wepDpjfRaHVfcHbnO7jze7uKJ+7rVEXxA0QMqrw+h
         LfHjQ0gZI5jNOIWLbJ/pc3g5AqkbatW4AibHVVTE6DsXf58m+109mp5fiLcpRTwms5Ew
         KVGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date;
        bh=hwfpnky+kIGo+6BQx8KdkTZdwoBXJ3O3qQ3V/MMGJ2A=;
        b=V0tlV5PVuWDVyKl6VALIVDCuUwR+6SWgPyFgFwszqAz6M0DhtJhRdJbD9ZjdmLR06I
         bw+nBQGMhk7KI0eQ9vIsmFj0yPOdcNQy4XWwqHhbYY2Ww7bvhyqDg6C0yEfHRuzqJ1MI
         yMsr/ew6iaVm0gDHBmYMvVCNqyEq+Boh1HkdF82dyBu5SYzzSHjErrWR0QHWSZOmcdq9
         8gNSIGaGBT09iWl1ydckXad7PsSuFF3jaBy7BW2TLnH7+MBIZBA83tF0So0WSMGRzt0c
         k/38LfYmMWjc3uqytKPGaTHJSYS0CuTkHzNJu0MzoV6aLRF1UzJhv4E8p5LzNNejBfA5
         EHlQ==
X-Gm-Message-State: ACrzQf3CpjGtHbpJrffm/JsLp/ucKE/M8zxEqLmlZqeJvg6hShzsbYlu
        iVIM6MO2asQ/E6Ug3zIUyEs=
X-Google-Smtp-Source: AMsMyM5zLDQVvZSzGLwguzeWNaDqtr4FE+pno4tipIsQDe7U44bV4oyqIeDh+lDftH60BX7Yyy4AyQ==
X-Received: by 2002:a05:6512:706:b0:498:b7ea:f2e8 with SMTP id b6-20020a056512070600b00498b7eaf2e8mr3429941lfs.570.1663945806195;
        Fri, 23 Sep 2022 08:10:06 -0700 (PDT)
Received: from pc636 (host-95-193-99-240.mobileonline.telia.com. [95.193.99.240])
        by smtp.gmail.com with ESMTPSA id y6-20020ac24466000000b00492e69be4d6sm1493029lfl.27.2022.09.23.08.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 08:10:05 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date:   Fri, 23 Sep 2022 17:10:03 +0200
To:     Florian Westphal <fw@strlen.de>
Cc:     Uladzislau Rezki <urezki@gmail.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <Yy3MS2uhSgjF47dy@pc636>
References: <20220923103858.26729-1-fw@strlen.de>
 <Yy20toVrIktiMSvH@dhcp22.suse.cz>
 <20220923133512.GE22541@breakpoint.cc>
 <Yy3GL12BOgp3wLjI@pc636>
 <20220923145409.GF22541@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923145409.GF22541@breakpoint.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 23, 2022 at 04:54:09PM +0200, Florian Westphal wrote:
> Uladzislau Rezki <urezki@gmail.com> wrote:
> > On Fri, Sep 23, 2022 at 03:35:12PM +0200, Florian Westphal wrote:
> > > Michal Hocko <mhocko@suse.com> wrote:
> > > > On Fri 23-09-22 12:38:58, Florian Westphal wrote:
> > > > > Martin Zaharinov reports BUG() in mm land for 5.19.10 kernel:
> > > > >  kernel BUG at mm/vmalloc.c:2437!
> > > > >  invalid opcode: 0000 [#1] SMP
> > > > >  CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W  O      5.19.9 #1
> > > > >  [..]
> > > > >  RIP: 0010:__get_vm_area_node+0x120/0x130
> > > > >   __vmalloc_node_range+0x96/0x1e0
> > > > >   kvmalloc_node+0x92/0xb0
> > > > >   bucket_table_alloc.isra.0+0x47/0x140
> > > > >   rhashtable_try_insert+0x3a4/0x440
> > > > >   rhashtable_insert_slow+0x1b/0x30
> > > > >  [..]
> > > > > 
> > > > > bucket_table_alloc uses kvzallocGPF_ATOMIC).  If kmalloc fails, this now
> > > > > falls through to vmalloc and hits code paths that assume GFP_KERNEL.
> > > > > 
> > > > > Revert the problematic change and stay with slab allocator.
> > > > 
> > > > Why don't you simply fix the caller?
> > > 
> > > Uh, not following?
> > > 
> > > kvzalloc(GFP_ATOMIC) was perfectly fine, is this illegal again?
> > >
> > <snip>
> > static struct vm_struct *__get_vm_area_node(unsigned long size,
> > 		unsigned long align, unsigned long shift, unsigned long flags,
> > 		unsigned long start, unsigned long end, int node,
> > 		gfp_t gfp_mask, const void *caller)
> > {
> > 	struct vmap_area *va;
> > 	struct vm_struct *area;
> > 	unsigned long requested_size = size;
> > 
> > 	BUG_ON(in_interrupt());
> > ...
> > <snip>
> > 
> > vmalloc is not supposed to be called from the IRQ context.
> 
> It uses kvzalloc, not vmalloc api.
> 
> Before 2018, rhashtable did use kzalloc OR kvzalloc, depending on gfp_t.
> 
> Quote from 93f976b5190df327939 changelog:
>   As of ce91f6ee5b3b ("mm: kvmalloc does not fallback to vmalloc for
>   incompatible gfp flags") we can simplify the caller
>   and trust kvzalloc() to just do the right thing.
> 
> I fear that if this isn't allowed it will result in hard-to-spot bugs
> because things will work fine until a fallback to vmalloc happens.
> 
> rhashtable may not be the only user of kvmalloc api that rely on
> ability to call it from (soft)irq.
>
Doing the "p = kmalloc(sizeof(*p), GFP_ATOMIC);" from an atomic context
is also a problem nowadays. Such code should be fixed across the kernel
because of PREEMPT_RT support.

--
Uladzislau Rezki
