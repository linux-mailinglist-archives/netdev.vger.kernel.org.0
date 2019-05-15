Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 894B31E697
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 03:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfEOBUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 21:20:16 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35361 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfEOBUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 21:20:15 -0400
Received: by mail-pg1-f195.google.com with SMTP id h1so455988pgs.2;
        Tue, 14 May 2019 18:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=waTKL6Bu37eEJwdHVOOvDPh/YJJ+fJD/m3gwqPus+Yo=;
        b=g/bEER0pbeLTxAe722+c8aeHM4c3JMw48iGb5c+p9hNDhd5tygISlhya9iswl7Nck9
         E57mvk9dN2T5m6HeLCFU2r4qVrJBZxpF7CTBfpr02fFymEwXoyJiGkdd5ZOdMLY1LdOZ
         EYiaE/o8eng65Y/JIIZPViGFK6/onOkwZGypjSObx92sUp/Kaz2K/gD7ShazGiutNv99
         +ANbG5btuK6LSgKUcECt7pd/jj//uYRizr9RPmQxcNWvXw+8xKHyWdVJz6bFucZwcIb7
         C8hbRai8qvHySHw/YqJACdm3NgNhILOY+zgTkFjbCcNqz3fvZX6Nx+1Ioaf0AmXQYjKE
         FkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=waTKL6Bu37eEJwdHVOOvDPh/YJJ+fJD/m3gwqPus+Yo=;
        b=bSF9fDdH3pV/oC2u0n0t9xKsIepjj7Zh13ad8hChbObrpa7dx2INp+zUYlyY5cYpvE
         s/Hpl85MsFDxd+p0nYGYwp0u7PBWQfYF/W1EdnLugQZFbnyLDlkQCjeV5JRR26dovqzu
         oWowfGM84s62KMKZYABkAxc6GTGoXu35Hnk4KrLtyOndiQeH2dF3VL/GSg/pojwNa9Wm
         eQFiZD8BZUk92xzT2A97gT4S33paxiJ1tjKgShyDq5Lc+3ddnTyT69qMBX960XUxjOj9
         /8OnV1g7EWpALJ85H/CB15l2WvoHxt2fBuUMAALKBkR62M4F5RjmtRFpkCC04D6PGuzY
         45Pw==
X-Gm-Message-State: APjAAAXk6ecf5iFSNEiEybRN2Yj7zvB9FW28FQnaychannNMnaYqYrfK
        DEQptejPq5l6oUnr6cmYgejeZRG/
X-Google-Smtp-Source: APXvYqyTRbvAaHuSsKDln2/BVVrviPlcjY9NO7vlda9jJtqY7Q6Xa0OS4gnQqRjiMj/gquDPZE5lKw==
X-Received: by 2002:a62:ea04:: with SMTP id t4mr43400612pfh.47.1557883214597;
        Tue, 14 May 2019 18:20:14 -0700 (PDT)
Received: from ?IPv6:2402:f000:4:72:808::6f28? ([2402:f000:4:72:808::6f28])
        by smtp.gmail.com with ESMTPSA id s6sm418612pfb.128.2019.05.14.18.20.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 18:20:13 -0700 (PDT)
Subject: Re: [BUG] rtlwifi: a crash in error handling code of rtl_pci_probe()
To:     Larry Finger <Larry.Finger@lwfinger.net>, pkshih@realtek.com,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <4627da7a-c56c-5d88-62ae-ea2be9430f6f@gmail.com>
 <12810ae7-ff10-42be-7887-19b68331980c@lwfinger.net>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <e7f9e9d3-1eac-0d09-104e-209210c3e39c@gmail.com>
Date:   Wed, 15 May 2019 09:20:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <12810ae7-ff10-42be-7887-19b68331980c@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/5/15 9:08, Larry Finger wrote:
> On 5/14/19 8:07 AM, Jia-Ju Bai wrote:
>> In rtl_pci_probe(), when request_irq() in rtl_pci_intr_mode_legacy() 
>> in rtl_pci_intr_mode_decide() fails, a crash occurs.
>> The crash information is as follows:
>>
>> [  108.271155] kasan: CONFIG_KASAN_INLINE enabled
>> [  108.271163] kasan: GPF could be caused by NULL-ptr deref or user 
>> memory access
>> ......
>> [  108.271193] RIP: 0010:cfg80211_get_drvinfo+0xce/0x3b0 [cfg80211]
>> ......
>> [  108.271235] Call Trace:
>> [  108.271245]  ethtool_get_drvinfo+0x110/0x640
>> [  108.271255]  ? cfg80211_get_chan_state+0x7e0/0x7e0 [cfg80211]
>> [  108.271261]  ? ethtool_get_settings+0x340/0x340
>> [  108.271268]  ? __read_once_size_nocheck.constprop.7+0x20/0x20
>> [  108.271279]  ? kasan_check_write+0x14/0x20
>> [  108.271284]  dev_ethtool+0x272d/0x4c20
>> [  108.271290]  ? unwind_get_return_address+0x66/0xb0
>> [  108.271299]  ? __save_stack_trace+0x92/0x100
>> [  108.271307]  ? ethtool_get_rxnfc+0x3f0/0x3f0
>> [  108.271316]  ? save_stack+0xa3/0xd0
>> [  108.271323]  ? save_stack+0x43/0xd0
>> [  108.271331]  ? ftrace_graph_ret_addr+0x2d/0x170
>> [  108.271338]  ? ftrace_graph_ret_addr+0x2d/0x170
>> [  108.271346]  ? ftrace_graph_ret_addr+0x2d/0x170
>> [  108.271354]  ? update_stack_state+0x3b2/0x670
>> [  108.271361]  ? update_stack_state+0x3b2/0x670
>> [  108.271370]  ? __read_once_size_nocheck.constprop.7+0x20/0x20
>> [  108.271379]  ? unwind_next_frame.part.5+0x19f/0xa60
>> [  108.271388]  ? bpf_prog_kallsyms_find+0x3e/0x270
>> [  108.271396]  ? is_bpf_text_address+0x1a/0x30
>> [  108.271408]  ? kernel_text_address+0x11d/0x130
>> [  108.271416]  ? __kernel_text_address+0x12/0x40
>> [  108.271423]  ? unwind_get_return_address+0x66/0xb0
>> [  108.271431]  ? __save_stack_trace+0x92/0x100
>> [  108.271440]  ? save_stack+0xa3/0xd0
>> [  108.271448]  ? udp_ioctl+0x35/0xe0
>> [  108.271457]  ? inet_ioctl+0x100/0x320
>> [  108.271466]  ? inet_stream_connect+0xb0/0xb0
>> [  108.271475]  ? alloc_file+0x60/0x480
>> [  108.271483]  ? alloc_file_pseudo+0x19d/0x270
>> [  108.271495]  ? sock_alloc_file+0x51/0x170
>> [  108.271502]  ? __sys_socket+0x12c/0x1f0
>> [  108.271510]  ? __x64_sys_socket+0x78/0xb0
>> [  108.271520]  ? do_syscall_64+0xb1/0x2e0
>> [  108.271529]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [  108.271538]  ? kasan_check_read+0x11/0x20
>> [  108.271548]  ? mutex_lock+0x8f/0xe0
>> [  108.271557]  ? __mutex_lock_slowpath+0x20/0x20
>> [  108.271568]  dev_ioctl+0x1fb/0xae0
>> [  108.271576]  ? dev_ioctl+0x1fb/0xae0
>> [  108.271586]  ? _copy_from_user+0x71/0xd0
>> [  108.271594]  sock_do_ioctl+0x1e2/0x2f0
>> [  108.271602]  ? kmem_cache_alloc+0xf9/0x250
>> [  108.271611]  ? ___sys_recvmsg+0x5a0/0x5a0
>> [  108.271621]  ? apparmor_file_alloc_security+0x128/0x7e0
>> [  108.271630]  ? kasan_unpoison_shadow+0x35/0x50
>> [  108.271638]  ? kasan_kmalloc+0xad/0xe0
>> [  108.271652]  ? apparmor_file_alloc_security+0x128/0x7e0
>> [  108.271662]  ? apparmor_file_alloc_security+0x269/0x7e0
>> [  108.271670]  sock_ioctl+0x361/0x590
>> [  108.271678]  ? sock_ioctl+0x361/0x590
>> [  108.271686]  ? routing_ioctl+0x470/0x470
>> [  108.271695]  ? kasan_check_write+0x14/0x20
>> [  108.271703]  ? __mutex_init+0xba/0x130
>> [  108.271713]  ? percpu_counter_add_batch+0xc7/0x120
>> [  108.271722]  ? alloc_empty_file+0xae/0x150
>> [  108.271729]  ? routing_ioctl+0x470/0x470
>> [  108.271738]  do_vfs_ioctl+0x1ae/0xfe0
>> [  108.271745]  ? do_vfs_ioctl+0x1ae/0xfe0
>> [  108.271754]  ? alloc_file_pseudo+0x1ad/0x270
>> [  108.271762]  ? ioctl_preallocate+0x1e0/0x1e0
>> [  108.271770]  ? alloc_file+0x480/0x480
>> [  108.271778]  ? kasan_check_read+0x11/0x20
>> [  108.271786]  ? __fget+0x24d/0x320
>> [  108.271794]  ? iterate_fd+0x180/0x180
>> [  108.271802]  ? fd_install+0x52/0x60
>> [  108.271812]  ? security_file_ioctl+0x8c/0xb0
>> [  108.271820]  ksys_ioctl+0x99/0xb0
>> [  108.271829]  __x64_sys_ioctl+0x78/0xb0
>> [  108.271839]  do_syscall_64+0xb1/0x2e0
>> [  108.271857]  ? prepare_exit_to_usermode+0xc8/0x160
>> [  108.271871]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> ......
>>
>> I checked the driver source code, but cannot find the reason, so I 
>> only report the crash...
>> Can somebody give an explanation about this crash?
>>
>> This crash is triggered by a runtime fuzzing tool named FIZZER 
>> written by us.
>
> Your backtrace does not include any references to rtlwifi routines, 
> and I have no idea what FIZZER does, thus it is not possible for me to 
> debug this. If the error situation that you state happens, the code 
> should end up at label "fail3" in routine rtl_pci_probe(). Insert 
> printk statements after every line of the following, and report the 
> last good point before the error. It is certainly possible that 
> something is being torn down that was never erected. The likelihood of 
> failure of both MSI and legacy interrupts is not very likely, and we 
> probably have never hit those conditions.
>
> fail3:
>         pci_set_drvdata(pdev, NULL);
>         rtl_deinit_core(hw);
>
> fail2:
>         if (rtlpriv->io.pci_mem_start != 0)
>                 pci_iounmap(pdev, (void __iomem 
> *)rtlpriv->io.pci_mem_start);
>
>         pci_release_regions(pdev);
>         complete(&rtlpriv->firmware_loading_complete);
>
> fail1:
>         if (hw)
>                 ieee80211_free_hw(hw);
>         pci_disable_device(pdev);
>
>         return err;

Thanks for the advice :)
I will insert some printk statements to debug this problem.


Best wishes,
Jia-Ju Bai
