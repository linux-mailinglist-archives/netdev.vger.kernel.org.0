Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2B456F989
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 11:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiGKJDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 05:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiGKJCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 05:02:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B98D322282
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 02:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657530172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KahG8dPujyuQmr3vS7XPH97ViH9jTIKR8+ux8kd1QT8=;
        b=YoBjNWFSdiVE4nyU/UR5Pu3xAuCjX98IukCDYtnEo3U7VYfsCetL4jrKESM0fPHtql7ZdL
        QY8b04gPDn+0/GjlvKl8Sl/gX626YmOMDGRwUrt8xyK/LwD5BqSDyUIE8faF3n0mfpSr5x
        bm/9/IAyAcqEu+1rBotqPhajRzpxRBk=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-RFquev0MNA6Pm0br0SFLCQ-1; Mon, 11 Jul 2022 05:02:45 -0400
X-MC-Unique: RFquev0MNA6Pm0br0SFLCQ-1
Received: by mail-ua1-f72.google.com with SMTP id m12-20020ab0138c000000b003820c57eda7so902544uae.20
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 02:02:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KahG8dPujyuQmr3vS7XPH97ViH9jTIKR8+ux8kd1QT8=;
        b=iEDxvH+pWbMfhXBbeWwHS2qIcsx7T81MQMnv82bZ0Hx/U/5ADZx5T0XfbeWXeHspDB
         WaMOKYybjh1cBahuPymu+1mUGLq0HqrH3UIKYs0vCoCJvg3vrY1AZBYET9IEqcNiwzpW
         8LYFpI6XqNwRDNB6gDHTvSkxfKdg5gYJ38Fyz7OlZEeLWSq8e4Htu3OuEwX41PbeQn0D
         E9BwCfpff+HTTvNTIgpkt/Q6Pjiw7jJmyl9VET9RFJuq28oH1YCVxzzQulipuPRyjTSf
         gnPi1azNZ8h3YoIQhOMkGtFGt6/RPW5pxr0KhpjnVJXaTR5exp0WyVeI3Vd9ym06ZsFx
         XYKA==
X-Gm-Message-State: AJIora9aG4r7vN1w7pWBRuuqgVRmDQy8fnUdU0JdkHldOsq0rAsLWtp1
        ucA/n6tneWXHg3miQraDou60Ad4jSI7epxIxvFYoOXQQDyz4yjPfC+7hp1ymllWYgNEIUmPf9QF
        Z4Yg+S8UsiVdRrN4JRHUAG+j3DvMTsyPv
X-Received: by 2002:a67:c894:0:b0:324:c5da:a9b5 with SMTP id v20-20020a67c894000000b00324c5daa9b5mr5669762vsk.33.1657530164718;
        Mon, 11 Jul 2022 02:02:44 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1teULKkvMHQJT95HO1uc0BNaAWznMll/Eik667wlaxMwKBx5Q4HHSX6ytTJUr0wN8GaaKbk1p8dwuemfZtwOG4=
X-Received: by 2002:a67:c894:0:b0:324:c5da:a9b5 with SMTP id
 v20-20020a67c894000000b00324c5daa9b5mr5669757vsk.33.1657530164473; Mon, 11
 Jul 2022 02:02:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220711075225.15687-1-mlombard@redhat.com>
In-Reply-To: <20220711075225.15687-1-mlombard@redhat.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 11 Jul 2022 11:02:33 +0200
Message-ID: <CAFL455nFxcrpezZENBHhMe_D7mE9N_v9mN9YjYQr1Z=-E3inug@mail.gmail.com>
Subject: Re: [PATCH] mm: prevent page_frag_alloc() from corrupting the memory
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?5oSa5qCR?= <chen45464546@163.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested with this kernel module:

http://bsdbackstore.eu/misc/oomk/

It requires 2 parameters: the first one is the amount of memory you
want to allocate with page_frag_alloc(), the second one is the size of
the fragment
I tested it on a machine with ~7Gb of free memory.

Without the patch:
-------------------------------------------------
3Gb of memory will be used with frag size = 1024 byte. No issue:

#insmod oomk.ko memory_size_gb=3 fragsize=1024

[  177.875107] Test begins, memory size = 3 fragsize = 1024
[  177.974538] Test completed!

10 Gb of memory, 1024 byte frag. page allocation failure but the
kernel handles it and doesn't crash:

#insmod oomk.ko memory_size_gb=10 fragsize=1024

[  215.104801] Test begins, memory size = 10 fragsize = 1024
[  215.227854] insmod: page allocation failure: order:0,
mode:0xa20(GFP_ATOMIC), nodemask=(null),cpuset=/,mems_allowed=0
[  215.230231] CPU: 1 PID: 1738 Comm: insmod Kdump: loaded Tainted: G
         OE    --------- ---  5.14.0-124.kpq0.el9.x86_64 #1
[  215.232344] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  215.233523] Call Trace:
[  215.234001]  dump_stack_lvl+0x34/0x44
[  215.234894]  warn_alloc+0x134/0x160
[  215.235592]  __alloc_pages_slowpath.constprop.0+0x809/0x840
[  215.236687]  ? get_page_from_freelist+0xc6/0x500
[  215.237569]  __alloc_pages+0x1fa/0x230
[  215.238381]  page_frag_alloc_align+0x16c/0x1a0
[...]
[  215.315722] allocation number 7379888 failed!
[  215.426227] Test completed!

10Gb, 4097 byte frag. Kernel crashes:

#insmod oomk.ko memory_size_gb=10 fragsize=4097
[  623.461505] BUG: Bad page state in process insmod  pfn:10a80c
[  623.462634] page:000000000654dc14 refcount:0 mapcount:0
mapping:000000007a56d6cd index:0x0 pfn:0x10a80c
[  623.464401] memcg:ffff900343a5b501
[  623.465058] aops:0xffff9003409e5d38 with invalid host inode 00003524480055f0
[  623.466394] flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
[  623.467632] raw: 0017ffffc0000000 dead000000000100 dead000000000122
ffff900346cf2900
[  623.469069] raw: 0000000000000000 0000000000100010 00000000ffffffff
ffff900343a5b501
[  623.470521] page dumped because: page still charged to cgroup
[...]
[  626.632838] general protection fault, probably for non-canonical
address 0xdead000000000108: 0000 [#1] PREEMPT SMP PTI
[  626.633913] ------------[ cut here ]------------
[  626.639981] CPU: 0 PID: 722 Comm: agetty Kdump: loaded Tainted: G
 B      OE    --------- ---  5.14.0-124.kpq0.el9.x86_64 #1
[  626.640923] WARNING: CPU: 1 PID: 22 at mm/slub.c:4566 __ksize+0xc4/0xe0
[  626.645018] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  626.645021] RIP: 0010:___slab_alloc+0x1b7/0x5c0


------------------------------------------

With the patch the kernel doesn't crash:

#insmod oomk.ko memory_size_gb=10 fragsize=4097
[ 4859.358496] Test begins, memory size = 10 fragsize = 4097
[ 4859.459674] allocation number 607754 failed!
[ 4859.495489] Test completed!

#insmod oomk.ko memory_size_gb=10 fragsize=40000
[ 8428.021491] Test begins, memory size = 10 fragsize = 40000
[ 8428.024308] allocation number 0 failed!
[ 8428.025709] Test completed!

Maurizio

