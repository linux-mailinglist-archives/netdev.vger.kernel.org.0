Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3FF1E680
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 03:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfEOBJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 21:09:07 -0400
Received: from mail-ot1-f53.google.com ([209.85.210.53]:41205 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfEOBJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 21:09:06 -0400
Received: by mail-ot1-f53.google.com with SMTP id g8so686701otl.8;
        Tue, 14 May 2019 18:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bBsyLbIZlNCfM2konVv0Iw/u6Pzl1k37zmDzPtOYv3s=;
        b=hojAWDuYdLxvpEzYmLYii4nTztqaBFArYHHI7/3Zuslm68T3tHl4oNQjyo3R45NKKI
         ERRvauDJiMZixXaVPgfowlw58axKWNdSg6Bf6jjdH/0JV1AHZ+HlYGIfG/5JjAWEJiFU
         D9PDfJyhqTaUDbTvdt/dZMUu3f/3O51NIHO1KEmHIKFYcE6r26jfucH54nkmL74flVo/
         K5bbq1cENOxZ5wTg3Y7dMjd17kMNrszxMVNdXIQF66d0q9+hhKP/FuXc2y51oiID4QxN
         XwH543CwBcGlueLp/Lb1MZWhlvCDPxpnKtD7M1hJ5BzplanS87lVwMiKa+zIC6pM8f92
         f4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bBsyLbIZlNCfM2konVv0Iw/u6Pzl1k37zmDzPtOYv3s=;
        b=auT2hFLqtNN9NB/zEqN6YTeIgoheW+tWy920hIJGaP3wPFvqh5hmHQgIslqtNqw3qX
         nFta/mFar9iLsBWQGIopJjsnoNIDTzelwLVQ6ZyhxTDN4m5lD9/1/oUASaUhC8khOa4u
         o6p67arWmhccGZFSLDrEmSHDmWfhKRYbWh+/LEY+rrh4RUsw4XnweocvsatVDmb6+PNz
         878D+g6p8eMy8k2L7JAGZBDOVpWkrKdXEB/4+U46Hzv22QeI5XMaqlFZc+fmBJZVQb6B
         bomzm2zqnfORooJ0xjRVzUyBC/Jgx/8GU9BBuut+2/Ul8Ortb/fo76VhlVizN/L+uJHI
         I7LA==
X-Gm-Message-State: APjAAAUFYqktu9Qm1lMk/3vOOM1o9RJdlk/g6elNkc4cEzIbjgeDASyb
        EDhyJ/aEaXqW91jyZShK8jXgxc/2
X-Google-Smtp-Source: APXvYqyDBKl8YZm/hoElE5E1ccYPsU2ylsg0izIHuxbM9nUd2RLW5LB8jrhUTfjSbC4ffGlNS2ZyNQ==
X-Received: by 2002:a9d:645a:: with SMTP id m26mr538807otl.269.1557882545817;
        Tue, 14 May 2019 18:09:05 -0700 (PDT)
Received: from [192.168.1.122] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id 189sm202249oih.26.2019.05.14.18.08.56
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 18:08:57 -0700 (PDT)
Subject: Re: [BUG] rtlwifi: a crash in error handling code of rtl_pci_probe()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, pkshih@realtek.com,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <4627da7a-c56c-5d88-62ae-ea2be9430f6f@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <12810ae7-ff10-42be-7887-19b68331980c@lwfinger.net>
Date:   Tue, 14 May 2019 20:08:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <4627da7a-c56c-5d88-62ae-ea2be9430f6f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/19 8:07 AM, Jia-Ju Bai wrote:
> In rtl_pci_probe(), when request_irq() in rtl_pci_intr_mode_legacy() in 
> rtl_pci_intr_mode_decide() fails, a crash occurs.
> The crash information is as follows:
> 
> [  108.271155] kasan: CONFIG_KASAN_INLINE enabled
> [  108.271163] kasan: GPF could be caused by NULL-ptr deref or user memory access
> ......
> [  108.271193] RIP: 0010:cfg80211_get_drvinfo+0xce/0x3b0 [cfg80211]
> ......
> [  108.271235] Call Trace:
> [  108.271245]  ethtool_get_drvinfo+0x110/0x640
> [  108.271255]  ? cfg80211_get_chan_state+0x7e0/0x7e0 [cfg80211]
> [  108.271261]  ? ethtool_get_settings+0x340/0x340
> [  108.271268]  ? __read_once_size_nocheck.constprop.7+0x20/0x20
> [  108.271279]  ? kasan_check_write+0x14/0x20
> [  108.271284]  dev_ethtool+0x272d/0x4c20
> [  108.271290]  ? unwind_get_return_address+0x66/0xb0
> [  108.271299]  ? __save_stack_trace+0x92/0x100
> [  108.271307]  ? ethtool_get_rxnfc+0x3f0/0x3f0
> [  108.271316]  ? save_stack+0xa3/0xd0
> [  108.271323]  ? save_stack+0x43/0xd0
> [  108.271331]  ? ftrace_graph_ret_addr+0x2d/0x170
> [  108.271338]  ? ftrace_graph_ret_addr+0x2d/0x170
> [  108.271346]  ? ftrace_graph_ret_addr+0x2d/0x170
> [  108.271354]  ? update_stack_state+0x3b2/0x670
> [  108.271361]  ? update_stack_state+0x3b2/0x670
> [  108.271370]  ? __read_once_size_nocheck.constprop.7+0x20/0x20
> [  108.271379]  ? unwind_next_frame.part.5+0x19f/0xa60
> [  108.271388]  ? bpf_prog_kallsyms_find+0x3e/0x270
> [  108.271396]  ? is_bpf_text_address+0x1a/0x30
> [  108.271408]  ? kernel_text_address+0x11d/0x130
> [  108.271416]  ? __kernel_text_address+0x12/0x40
> [  108.271423]  ? unwind_get_return_address+0x66/0xb0
> [  108.271431]  ? __save_stack_trace+0x92/0x100
> [  108.271440]  ? save_stack+0xa3/0xd0
> [  108.271448]  ? udp_ioctl+0x35/0xe0
> [  108.271457]  ? inet_ioctl+0x100/0x320
> [  108.271466]  ? inet_stream_connect+0xb0/0xb0
> [  108.271475]  ? alloc_file+0x60/0x480
> [  108.271483]  ? alloc_file_pseudo+0x19d/0x270
> [  108.271495]  ? sock_alloc_file+0x51/0x170
> [  108.271502]  ? __sys_socket+0x12c/0x1f0
> [  108.271510]  ? __x64_sys_socket+0x78/0xb0
> [  108.271520]  ? do_syscall_64+0xb1/0x2e0
> [  108.271529]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  108.271538]  ? kasan_check_read+0x11/0x20
> [  108.271548]  ? mutex_lock+0x8f/0xe0
> [  108.271557]  ? __mutex_lock_slowpath+0x20/0x20
> [  108.271568]  dev_ioctl+0x1fb/0xae0
> [  108.271576]  ? dev_ioctl+0x1fb/0xae0
> [  108.271586]  ? _copy_from_user+0x71/0xd0
> [  108.271594]  sock_do_ioctl+0x1e2/0x2f0
> [  108.271602]  ? kmem_cache_alloc+0xf9/0x250
> [  108.271611]  ? ___sys_recvmsg+0x5a0/0x5a0
> [  108.271621]  ? apparmor_file_alloc_security+0x128/0x7e0
> [  108.271630]  ? kasan_unpoison_shadow+0x35/0x50
> [  108.271638]  ? kasan_kmalloc+0xad/0xe0
> [  108.271652]  ? apparmor_file_alloc_security+0x128/0x7e0
> [  108.271662]  ? apparmor_file_alloc_security+0x269/0x7e0
> [  108.271670]  sock_ioctl+0x361/0x590
> [  108.271678]  ? sock_ioctl+0x361/0x590
> [  108.271686]  ? routing_ioctl+0x470/0x470
> [  108.271695]  ? kasan_check_write+0x14/0x20
> [  108.271703]  ? __mutex_init+0xba/0x130
> [  108.271713]  ? percpu_counter_add_batch+0xc7/0x120
> [  108.271722]  ? alloc_empty_file+0xae/0x150
> [  108.271729]  ? routing_ioctl+0x470/0x470
> [  108.271738]  do_vfs_ioctl+0x1ae/0xfe0
> [  108.271745]  ? do_vfs_ioctl+0x1ae/0xfe0
> [  108.271754]  ? alloc_file_pseudo+0x1ad/0x270
> [  108.271762]  ? ioctl_preallocate+0x1e0/0x1e0
> [  108.271770]  ? alloc_file+0x480/0x480
> [  108.271778]  ? kasan_check_read+0x11/0x20
> [  108.271786]  ? __fget+0x24d/0x320
> [  108.271794]  ? iterate_fd+0x180/0x180
> [  108.271802]  ? fd_install+0x52/0x60
> [  108.271812]  ? security_file_ioctl+0x8c/0xb0
> [  108.271820]  ksys_ioctl+0x99/0xb0
> [  108.271829]  __x64_sys_ioctl+0x78/0xb0
> [  108.271839]  do_syscall_64+0xb1/0x2e0
> [  108.271857]  ? prepare_exit_to_usermode+0xc8/0x160
> [  108.271871]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> ......
> 
> I checked the driver source code, but cannot find the reason, so I only report 
> the crash...
> Can somebody give an explanation about this crash?
> 
> This crash is triggered by a runtime fuzzing tool named FIZZER written by us.

Your backtrace does not include any references to rtlwifi routines, and I have 
no idea what FIZZER does, thus it is not possible for me to debug this. If the 
error situation that you state happens, the code should end up at label "fail3" 
in routine rtl_pci_probe(). Insert printk statements after every line of the 
following, and report the last good point before the error. It is certainly 
possible that something is being torn down that was never erected. The 
likelihood of failure of both MSI and legacy interrupts is not very likely, and 
we probably have never hit those conditions.

fail3:
         pci_set_drvdata(pdev, NULL);
         rtl_deinit_core(hw);

fail2:
         if (rtlpriv->io.pci_mem_start != 0)
                 pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);

         pci_release_regions(pdev);
         complete(&rtlpriv->firmware_loading_complete);

fail1:
         if (hw)
                 ieee80211_free_hw(hw);
         pci_disable_device(pdev);

         return err;

Larry
