Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFECF22A923
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgGWGxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGWGxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:53:33 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA42BC0619DC;
        Wed, 22 Jul 2020 23:53:32 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id w2so2586012pgg.10;
        Wed, 22 Jul 2020 23:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MKeI10oAeukD6znqZG6253pIZloE+begkglToKzlJ/0=;
        b=lr4pORw07DhPNC2bfi9AgknxtOAjLQBJ0De1ohELNHH0fC4lO7PQ4eiZDyn0aDzjgm
         I8zDRcqznWvO4SX6mz7MnzOkM5p8+G0eDJ100kiHhYXejuME+P+YBzz2XoOSRw5Cnavk
         900AGrTuxQFBStbaZFIjb2Msvjj5L16LypESwqnkuPdpj6Q0EaTfmKKk/ugiZnVDPOaJ
         lkmgQRNnQEJocE+QmPBrVNWfIwHfcavjZUG94a4Krm+H9zeb0+csnCzpEKtYAegn34+N
         N1E2EZzHw5HYxU33h33xOxH/3w/sZdg/OYYr+Az+UJviJrFqYCz0W8mIlsBpBA++Nn4b
         elRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MKeI10oAeukD6znqZG6253pIZloE+begkglToKzlJ/0=;
        b=IuhGCOahocvb7QHHoeoKOtkTEmew1JdgzuwBToJyWVSQMO+iiFqV6gKmjffsBSq2F7
         uNZSAfLj1cPSXqFSko+Lz2Fukt3BIdo2y6IIR8FLAYWSCSKPy8anMYmSK3+0kBrMY9vb
         Se+ZsyCRzewfZVR8aLCsthlt17saDmIvnAlkI7GzVyZ/VwBdtIsyXK/RmJSlaVhGq7ii
         4a1IB4yX2AI91F/xWcInXBQdyzMmrvLHZNszxhItugvp7QfracCvFTbbj4SL1oreqfIa
         pWSWA/nO+UAznN12kAZfMZMp6KzbI0FzJ1679gRCRuTOwuKiHrifdvn8dqMB5VTe8u1x
         YqBA==
X-Gm-Message-State: AOAM532pGylOquo8Lqg5leiVkK5j4EUyddFVZRVZe0xrrCYa3mrSvWeR
        oP3WbYsf7sbxo+WL2g9iUUo=
X-Google-Smtp-Source: ABdhPJySlLuLMTnPxayB9GJb5cstQeH9GWTnAUcauyVaVphzrZoGASUAUij/icP73xvQbl8RvYeTzA==
X-Received: by 2002:a62:be02:: with SMTP id l2mr2823365pff.163.1595487212451;
        Wed, 22 Jul 2020 23:53:32 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:6cd6])
        by smtp.gmail.com with ESMTPSA id y7sm1729879pfq.69.2020.07.22.23.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 23:53:31 -0700 (PDT)
Date:   Wed, 22 Jul 2020 23:53:29 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: implement bpf iterator for map
 elements
Message-ID: <20200723065329.yuw4dey27n2w5a4i@ast-mbp.dhcp.thefacebook.com>
References: <20200723061533.2099842-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723061533.2099842-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:15:33PM -0700, Yonghong Song wrote:
> Bpf iterator has been implemented for task, task_file,
> bpf_map, ipv6_route, netlink, tcp and udp so far.
> 
> For map elements, there are two ways to traverse all elements from
> user space:
>   1. using BPF_MAP_GET_NEXT_KEY bpf subcommand to get elements
>      one by one.
>   2. using BPF_MAP_LOOKUP_BATCH bpf subcommand to get a batch of
>      elements.
> Both these approaches need to copy data from kernel to user space
> in order to do inspection.
> 
> This patch implements bpf iterator for map elements.
> User can have a bpf program in kernel to run with each map element,
> do checking, filtering, aggregation, modifying values etc.
> without copying data to user space.
> 
> Patch #1 and #2 are refactoring. Patch #3 implements readonly/readwrite
> buffer support in verifier. Patches #4 - #7 implements map element
> support for hash, percpu hash, lru hash lru percpu hash, array,
> percpu array and sock local storage maps. Patches #8 - #9 are libbpf
> and bpftool support. Patches #10 - #13 are selftests for implemented
> map element iterators.

kasan is not happy:

[   16.896170] ==================================================================
[   16.896994] BUG: KASAN: use-after-free in __do_sys_bpf+0x34f3/0x3860
[   16.897657] Read of size 4 at addr ffff8881f105b208 by task test_progs/1958
[   16.898416]
[   16.898577] CPU: 0 PID: 1958 Comm: test_progs Not tainted 5.8.0-rc4-01920-g6276000cd38e #2828
[   16.899505] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
[   16.900405] Call Trace:
[   16.900679]  dump_stack+0x7d/0xb0
[   16.901068]  print_address_description.constprop.0+0x3a/0x60
[   16.901689]  ? __do_sys_bpf+0x34f3/0x3860
[   16.902125]  kasan_report.cold+0x1f/0x37
[   16.902595]  ? __do_sys_bpf+0x34f3/0x3860
[   16.903029]  __do_sys_bpf+0x34f3/0x3860
[   16.903494]  ? bpf_trace_run2+0xd1/0x210
[   16.903971]  ? bpf_link_get_from_fd+0xe0/0xe0
[   16.907802]  do_syscall_64+0x38/0x60
[   16.908187]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   16.908730] RIP: 0033:0x7f014cdfe7f9
[   16.909148] Code: Bad RIP value.
[   16.909524] RSP: 002b:00007ffe1d1e8b28 EFLAGS: 00000206 ORIG_RAX: 0000000000000141
[   16.910345] RAX: ffffffffffffffda RBX: 00007f014dd27690 RCX: 00007f014cdfe7f9
[   16.911058] RDX: 0000000000000078 RSI: 00007ffe1d1e8b60 RDI: 000000000000001e
[   16.911820] RBP: 00007ffe1d1e8b40 R08: 00007ffe1d1e8b40 R09: 00007ffe1d1e8b60
[   16.912575] R10: 0000000000000044 R11: 0000000000000206 R12: 0000000000000002
[   16.913304] R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000002
[   16.914026]
[   16.914189] Allocated by task 1958:
[   16.914562]  save_stack+0x1b/0x40
[   16.914944]  __kasan_kmalloc.constprop.0+0xc2/0xd0
[   16.915476]  bpf_iter_link_attach+0x235/0x4e0
[   16.915975]  __do_sys_bpf+0x1832/0x3860
[   16.916371]  do_syscall_64+0x38/0x60
[   16.916750]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   16.917338]
[   16.917524] Freed by task 1958:
[   16.917874]  save_stack+0x1b/0x40
[   16.918241]  __kasan_slab_free+0x12f/0x180
[   16.918681]  kfree+0xc6/0x280
[   16.919024]  bpf_iter_link_attach+0x3e3/0x4e0
[   16.919488]  __do_sys_bpf+0x1832/0x3860
[   16.919915]  do_syscall_64+0x38/0x60
[   16.920301]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

To reproduce:
./test_progs -n 5
#5 bpf_obj_id:OK
Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

./test_progs -n 4/18
#4/18 bpf_hash_map:OK
#4 bpf_iter:OK
Summary: 1/1 PASSED, 0 SKIPPED, 0 FAILED

./test_progs -n 5
[   37.569154] ==================================================================
[   37.570020] BUG: KASAN: use-after-free in __do_sys_bpf+0x34f3/0x3860

