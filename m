Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1F6223F30
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 17:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgGQPNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 11:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgGQPNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 11:13:40 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C23C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 08:13:39 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id y13so6262287lfe.9
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 08:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ihApHeNosiHx6nUASfY6SAPFllo59+sVvjnXR/uag7o=;
        b=xGyBb/++2nQv7VJbnPslJJzxnjcqAJRCiZwQwZIx6aPx5Yrh5NDfEaFqC9klZjlQpf
         nd8tEGCASoP77EdInqcBXT5ZFruw5f4/sHxNTN3wNCfodu8XcQiLwQqhnHm4kL4WfxRP
         hLn4CgAUwD58BDfZbTLMAGIdP+BBDVxytLU/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ihApHeNosiHx6nUASfY6SAPFllo59+sVvjnXR/uag7o=;
        b=b/KHzZWTnN0PvPGlLn5NlSXRG9BtX12HMxOaawMgWqrlctGwcRYz3rNSI/wuUmWnJ8
         NKsO+TCvmrh8OPknzlNMWLRQKo6hue4JbrUsdUrrfDf92rC/SVfTL9iIlCvs4Ggll5fE
         m9upNQxZ4D/U1SAhq2rudaNcY19AuM3K8cqAmO85OKM15F2Ew3my/e12Jsou6VMwrry+
         4+yjuhweT0lv29rhKFCHEt7VtsBJdQrU8tYQpeJaPKpoTSLe5aYtQLg8SAUUe14tfdTc
         ydpdT0cUdqLYwOeuMDUqVz7yxF8IXF8dFX4IJriOa7vnbMSVXzMh2TR9GpQVhm7VQxen
         Mpsg==
X-Gm-Message-State: AOAM532CLaoFRtXz5nicjAfAOQNEVcewqJDnYFGQarCLxAs2cIEj463p
        aWNqOSf72VtBlhHxh/Pz3sCtS+ee7tTmbg==
X-Google-Smtp-Source: ABdhPJzUMmuYOE77b9Y/YDzKehINQwx85hnSGzpdfF/rKWroRAPv5pf5wEEGsoJO3tAqLCYjBxn7Mw==
X-Received: by 2002:a19:7111:: with SMTP id m17mr5038973lfc.156.1594998818059;
        Fri, 17 Jul 2020 08:13:38 -0700 (PDT)
Received: from toad ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id m9sm1935755lfb.5.2020.07.17.08.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 08:13:37 -0700 (PDT)
Date:   Fri, 17 Jul 2020 17:13:33 +0200
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        brouer@redhat.com, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH v7 bpf-next 0/9] introduce support for XDP programs in
 CPUMAP
Message-ID: <20200717171333.3fe979e6@toad>
In-Reply-To: <20200717110136.GA1683270@localhost.localdomain>
References: <cover.1594734381.git.lorenzo@kernel.org>
        <20200717120013.0926a74e@toad>
        <20200717110136.GA1683270@localhost.localdomain>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 13:01:36 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> [...]
> 
> > This started showing up with when running ./test_progs from recent
> > bpf-next (bfdfa51702de). Any chance it is related?
> > 
> > [ 2950.440613] =============================================
> > 
> > [ 3073.281578] INFO: task cpumap/0/map:26:536 blocked for more than 860 seconds.
> > [ 3073.285492]       Tainted: G        W         5.8.0-rc4-01471-g15d51f3a516b #814
> > [ 3073.289177] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [ 3073.293021] cpumap/0/map:26 D    0   536      2 0x00004000
> > [ 3073.295755] Call Trace:
> > [ 3073.297143]  __schedule+0x5ad/0xf10
> > [ 3073.299032]  ? pci_mmcfg_check_reserved+0xd0/0xd0
> > [ 3073.301416]  ? static_obj+0x31/0x80
> > [ 3073.303277]  ? mark_held_locks+0x24/0x90
> > [ 3073.305313]  ? cpu_map_update_elem+0x6d0/0x6d0
> > [ 3073.307544]  schedule+0x6f/0x160
> > [ 3073.309282]  schedule_preempt_disabled+0x14/0x20
> > [ 3073.311593]  kthread+0x175/0x240
> > [ 3073.313299]  ? kthread_create_on_node+0xd0/0xd0
> > [ 3073.315106]  ret_from_fork+0x1f/0x30
> > [ 3073.316365]
> >                Showing all locks held in the system:
> > [ 3073.318423] 1 lock held by khungtaskd/33:
> > [ 3073.319642]  #0: ffffffff82d246a0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x28/0x1c3
> > 
> > [ 3073.322249] =============================================  
> 
> Hi Jakub,
> 
> can you please provide more info? can you please identify the test that trigger
> the issue? I run test_progs with bpf-next master branch and it works fine for me.
> I run the tests in a vm with 4 vcpus and 4G of memory.
> 
> Regards,
> Lorenzo
> 

Was able to trigger it running the newly added selftest:

virtme-init: console is ttyS0
bash-5.0# ./test_progs -n 100
#100/1 cpumap_with_progs:OK
#100 xdp_cpumap_attach:OK
Summary: 1/1 PASSED, 0 SKIPPED, 0 FAILED
bash-5.0# [  247.177168] INFO: task cpumap/0/map:3:198 blocked for more than 122 seconds.
[  247.181306]       Not tainted 5.8.0-rc4-01456-gbfdfa51702de #815
[  247.184487] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  247.188876] cpumap/0/map:3  D    0   198      2 0x00004000
[  247.192624] Call Trace:
[  247.194327]  __schedule+0x5ad/0xf10
[  247.196860]  ? pci_mmcfg_check_reserved+0xd0/0xd0
[  247.199853]  ? static_obj+0x31/0x80
[  247.201917]  ? mark_held_locks+0x24/0x90
[  247.204398]  ? cpu_map_update_elem+0x6d0/0x6d0
[  247.207098]  schedule+0x6f/0x160
[  247.209079]  schedule_preempt_disabled+0x14/0x20
[  247.211863]  kthread+0x175/0x240
[  247.213698]  ? kthread_create_on_node+0xd0/0xd0
[  247.216054]  ret_from_fork+0x1f/0x30
[  247.218363]
[  247.218363] Showing all locks held in the system:
[  247.222150] 1 lock held by khungtaskd/33:
[  247.224894]  #0: ffffffff82d246a0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x28/0x1c3
[  247.231113]
[  247.232335] =============================================
[  247.232335]

qemu running with 4 vCPUs, 4 GB of memory. .config uploaded at
https://paste.centos.org/view/0c14663d

HTH,
-jkbs
