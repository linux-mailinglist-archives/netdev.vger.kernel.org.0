Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497514A7EE2
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 06:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbiBCFOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 00:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236553AbiBCFOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 00:14:34 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA69C061714;
        Wed,  2 Feb 2022 21:14:34 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id x11so1212645plg.6;
        Wed, 02 Feb 2022 21:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/XvS1cqfkeqiPvoM6zdk/RybqMUuGn2wKOpu+RAubME=;
        b=CCKxvnTUr/p5sXzQFArCLzvE25cnccC1MT/MgJBjAgd5J+UBe+VK/8p6BT83Yf2i17
         3mM3TYLZABXNVsPqTWT9R9dYMLHc0uAyItzV/dyWtli3aW8yTYxlx8Cxzt9tMzzuopL8
         IqIDXMJWUDw9x5xk6R0nhFpOvLoM/Odfgv5MWqODcFiLXFgnvbR5X3L7NGU4Tw9exNjA
         CZ95SsvQSqSZtCUPidGCDUEpI17JO8V//RYjEAOcsCWCV0zWi/bqXOnA3zaAKknAV0BS
         g71mfUyZiP6MNny4sCw92DNaskqcFNvLX7fOgDi20ic/qblsR6zGMswA+MAOoQSyi6T+
         FT5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/XvS1cqfkeqiPvoM6zdk/RybqMUuGn2wKOpu+RAubME=;
        b=Lzf2wZ9Fk0T0C/xTij8W9mKaOz/d9PXf3Q1/VES0qz64vS4rG1gGr6kNFFiA1uLyjs
         U1FxzB4ErUcCZdx6iJCxoasSAF0dWZ1OfkTOE0LXledPdftz3/HeGFds5UjdRoEYPdZ6
         qL9nlpfYKsDAUhML5sgtnaj5vcWg7TFiLPut/1TEM7dm5bpuHIAMolHRuHy1NMZaEO6E
         XlrNDnP0Ps/sGSHJ/2c84D38WTMPHIamHffUR+gak7hrDUozvwNxsdVq+O/kuwG9KaTe
         AyOk0b1OCYN1Tcxoqf1iJOpXuQ7rSe48/7gD4aKKcb7SCKo5BJRK6CmoyK0SFFIVzioN
         6JNA==
X-Gm-Message-State: AOAM533LTuWcUHIFd72yJa4VXMU4sRZBdyrxmbIWAzfZi+o025Ri6ojz
        WbNuA6deuBaDvjNBfdMphn8=
X-Google-Smtp-Source: ABdhPJwpHPqQgmShBBEKrtoDaUXJcHZ+hFS30gsjm4wgZ4HESicEARK41UA8uChVoJWWGeCFFfGghQ==
X-Received: by 2002:a17:90a:4045:: with SMTP id k5mr12175403pjg.98.1643865273521;
        Wed, 02 Feb 2022 21:14:33 -0800 (PST)
Received: from localhost (61-223-193-169.dynamic-ip.hinet.net. [61.223.193.169])
        by smtp.gmail.com with ESMTPSA id nn12sm8484531pjb.24.2022.02.02.21.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 21:14:32 -0800 (PST)
From:   Hou Tao <hotforest@gmail.com>
X-Google-Original-From: Hou Tao <houtao1@huawei.com>
To:     daniel@iogearbox.net
Cc:     andreyknvl@google.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, hotforest@gmail.com,
        houtao1@huawei.com, john.fastabend@gmail.com, kafai@fb.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com, yhs@fb.com
Subject: Re: [PATCH bpf-next v2] bpf: use VM_MAP instead of VM_ALLOC for ringbuf
Date:   Thu,  3 Feb 2022 13:14:27 +0800
Message-Id: <20220203051427.23315-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <c6c74927-0199-617a-c4b2-bb4d0a733906@iogearbox.net>
References: <c6c74927-0199-617a-c4b2-bb4d0a733906@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> On 2/2/22 7:01 AM, Hou Tao wrote:
> > After commit 2fd3fb0be1d1 ("kasan, vmalloc: unpoison VM_ALLOC pages
> > after mapping"), non-VM_ALLOC mappings will be marked as accessible
> > in __get_vm_area_node() when KASAN is enabled. But now the flag for
> > ringbuf area is VM_ALLOC, so KASAN will complain out-of-bound access
> > after vmap() returns. Because the ringbuf area is created by mapping
> > allocated pages, so use VM_MAP instead.
> > 
> > After the change, info in /proc/vmallocinfo also changes from
> >    [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmalloc user
> > to
> >    [start]-[end]   24576 ringbuf_map_alloc+0x171/0x290 vmap user
> > 
> > Reported-by: syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com
> > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > ---
> > v2:
> >    * explain why VM_ALLOC will lead to vmalloc-oob access
> 
> Do you know which tree commit 2fd3fb0be1d1 is, looks like it's neither
> in bpf nor in bpf-next tree at the moment.
> 
It is on linux-next tree:
 
 $ git name-rev 2fd3fb0be1d1
 2fd3fb0be1d1 tags/next-20220201~2^2~96
 
> Either way, I presume this fix should be routed via bpf tree rather
> than bpf-next? (I can add Fixes tag while applying.)
>
Make sense and thanks for that.

Regards,
Tao

> >    * add Reported-by tag
> > v1: https://lore.kernel.org/bpf/CANUnq3a+sT_qtO1wNQ3GnLGN7FLvSSgvit2UVgqQKRpUvs85VQ@mail.gmail.com/T/#t
> > ---
> >   kernel/bpf/ringbuf.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> > index 638d7fd7b375..710ba9de12ce 100644
> > --- a/kernel/bpf/ringbuf.c
> > +++ b/kernel/bpf/ringbuf.c
> > @@ -104,7 +104,7 @@ static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
> >   	}
> >   
> >   	rb = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
> > -		  VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
> > +		  VM_MAP | VM_USERMAP, PAGE_KERNEL);
> >   	if (rb) {
> >   		kmemleak_not_leak(pages);
> >   		rb->pages = pages;
> > 
> 
> 
