Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5231C475615
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241580AbhLOKS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhLOKSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 05:18:25 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061BBC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 02:18:25 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y13so72530021edd.13
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 02:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=q1JZdkCf7dQjjuxhi38jTg67iYbn4g+3Fbt+hPUhKKM=;
        b=opiAMLtsmcG2vEJvh8tEIcI2c1B9RCUr8jX65O1/wps1ovRuW2yjQhOnXHY+bv+KH+
         +XRUuaDN+Dkz3uAEgdZjpw+jk32xkchAFhQquyeDb+KCZQiJSUnMArKijM2Jln1oxMEJ
         CL4kgW+Dk1HpnFGrm9EviwF3ajGjwySrMNkRAMyqKPDajPjT1ZT7ZaqXZEYwdKA5oSi1
         ry4X03nzVfJByZBcS3Syi73UMvA2jipI8MsyyNIXG5qsry3HGs++0Wj4A5RRfI0CqdAn
         /GJiYhI7mIXk+FzACxd0VM2tSH3wMLIToj9mhjka6Hpunyr1XLC8cnEs06BEQmMHEKkl
         MM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q1JZdkCf7dQjjuxhi38jTg67iYbn4g+3Fbt+hPUhKKM=;
        b=f0/ewqrOu14QsRS+byPmLoKGju7YwcWDGr9cxvm6e9yfx5233WuVVfLpYrCbsJFvSj
         wU5mDN3MWoM+XIhdixHSwi+NX7BnWJOO6698sdMSPsPyHIydSjQTGiYehQ06L3YuShMm
         yubwzFR0+EYlrtpP5wF2JqqET1BbquyshhjCcgptn7Dd6osFX3phBVeH/nZ6GvNOmPg6
         tMPDNPGebWPiDbmEuVEWiSuHnrxLGBfcfV6zhv0/hg3EvvI+FwFghUR1LduYU9FiisDC
         P/0BM7r/buZwbSz/0tURTroF2A3CFmhl2FpaQ98J2WubHUaZJac3ZNWiozaDXDv7cUla
         FI9g==
X-Gm-Message-State: AOAM530Su6Bbrl9jipRZEhIMC6ENwDR90hv1k1JD3wUEj3zz/djSrmLs
        98PWvg+VBnukWKvw/jknYRc=
X-Google-Smtp-Source: ABdhPJw9QVeVILEa+Z30V1/vHSmNXlz8SMSEyUWQpM8cmgNBr8k7N0vZ7WYwq8HHMVw4uBfU7nPdoQ==
X-Received: by 2002:a05:6402:908:: with SMTP id g8mr13748700edz.59.1639563503608;
        Wed, 15 Dec 2021 02:18:23 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id sa17sm556987ejc.123.2021.12.15.02.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 02:18:23 -0800 (PST)
Message-ID: <a6b342b3-8ce1-70c8-8398-fceaee0b51ff@gmail.com>
Date:   Wed, 15 Dec 2021 11:18:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 net-next 01/23] lib: add reference counting tracking
 infrastructure
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <20211205042217.982127-2-eric.dumazet@gmail.com>
From:   Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <20211205042217.982127-2-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05. 12. 21, 5:21, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> It can be hard to track where references are taken and released.
> 
> In networking, we have annoying issues at device or netns dismantles,
> and we had various proposals to ease root causing them.
...
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -680,6 +680,11 @@ config STACK_HASH_ORDER
>   	 Select the hash size as a power of 2 for the stackdepot hash table.
>   	 Choose a lower value to reduce the memory impact.
>   
> +config REF_TRACKER
> +	bool
> +	depends on STACKTRACE_SUPPORT
> +	select STACKDEPOT

Hi,

I have to:
+       select STACKDEPOT_ALWAYS_INIT
here. Otherwise I see this during boot:

> BUG: unable to handle page fault for address: 00000000001e6f80
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP PTI
> CPU: 1 PID: 1 Comm: swapper/0 Tainted: G          I       5.16.0-rc5-next-20211214-vanilla+ #46 2756e36611a8c8a8271884ae04571fc88e1cb566
> Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
> RIP: 0010:__stack_depot_save (lib/stackdepot.c:373) 
> Code: 04 31 fb 83 fe 03 77 97 83 fe 02 74 7a 83 fe 03 74 72 83 fe 01 74 73 48 8b 05 45 ec 11 02 89 d9 81 e1 ff ff 0f 00 48 8d 0c c8 <48> 8b 29 48 85 ed 75 12 e9 9f 00 00 00 48 8b 6d 00 48 85 ed 0f 84
> All code
> ========
>    0:	04 31                	add    $0x31,%al
>    2:	fb                   	sti    
>    3:	83 fe 03             	cmp    $0x3,%esi
>    6:	77 97                	ja     0xffffffffffffff9f
>    8:	83 fe 02             	cmp    $0x2,%esi
>    b:	74 7a                	je     0x87
>    d:	83 fe 03             	cmp    $0x3,%esi
>   10:	74 72                	je     0x84
>   12:	83 fe 01             	cmp    $0x1,%esi
>   15:	74 73                	je     0x8a
>   17:	48 8b 05 45 ec 11 02 	mov    0x211ec45(%rip),%rax        # 0x211ec63
>   1e:	89 d9                	mov    %ebx,%ecx
>   20:	81 e1 ff ff 0f 00    	and    $0xfffff,%ecx
>   26:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
>   2a:*	48 8b 29             	mov    (%rcx),%rbp		<-- trapping instruction
>   2d:	48 85 ed             	test   %rbp,%rbp
>   30:	75 12                	jne    0x44
>   32:	e9 9f 00 00 00       	jmp    0xd6
>   37:	48 8b 6d 00          	mov    0x0(%rbp),%rbp
>   3b:	48 85 ed             	test   %rbp,%rbp
>   3e:	0f                   	.byte 0xf
>   3f:	84                   	.byte 0x84
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	48 8b 29             	mov    (%rcx),%rbp
>    3:	48 85 ed             	test   %rbp,%rbp
>    6:	75 12                	jne    0x1a
>    8:	e9 9f 00 00 00       	jmp    0xac
>    d:	48 8b 6d 00          	mov    0x0(%rbp),%rbp
>   11:	48 85 ed             	test   %rbp,%rbp
>   14:	0f                   	.byte 0xf
>   15:	84                   	.byte 0x84
> RSP: 0000:ffffb3f700027b78 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 000000004ea3cdf0 RCX: 00000000001e6f80
> RDX: 000000000000000d RSI: 0000000000000002 RDI: 00000000793ec676
> RBP: ffff8b578094f4d0 R08: 0000000043abc8c3 R09: 000000000000000d
> R10: 0000000000000015 R11: 000000000000001c R12: 0000000000000001
> R13: 0000000000000cc0 R14: ffffb3f700027bd8 R15: 000000000000000d
> FS:  0000000000000000(0000) GS:ffff8b5845c80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000001e6f80 CR3: 0000000199410000 CR4: 00000000000006e0
> Call Trace:
> <TASK>
> ref_tracker_alloc (lib/ref_tracker.c:84) 
> net_rx_queue_update_kobjects (net/core/net-sysfs.c:1049 net/core/net-sysfs.c:1101) 
> netdev_register_kobject (net/core/net-sysfs.c:1761 net/core/net-sysfs.c:2012) 
> register_netdevice (net/core/dev.c:9660) 
> register_netdev (net/core/dev.c:9784) 
> loopback_net_init (drivers/net/loopback.c:217) 
> ops_init (net/core/net_namespace.c:140) 
> register_pernet_operations (net/core/net_namespace.c:1148 net/core/net_namespace.c:1217) 
> register_pernet_device (net/core/net_namespace.c:1304) 
> net_dev_init (net/core/dev.c:11014) 
> ? sysctl_core_init (net/core/dev.c:10958) 
> do_one_initcall (init/main.c:1303) 
> kernel_init_freeable (init/main.c:1377 init/main.c:1394 init/main.c:1413 init/main.c:1618) 
> ? rest_init (init/main.c:1499) 
> kernel_init (init/main.c:1509) 
> ret_from_fork (arch/x86/entry/entry_64.S:301) 
> </TASK>
> Modules linked in:
> CR2: 00000000001e6f80
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__stack_depot_save (lib/stackdepot.c:373) 
> Code: 04 31 fb 83 fe 03 77 97 83 fe 02 74 7a 83 fe 03 74 72 83 fe 01 74 73 48 8b 05 45 ec 11 02 89 d9 81 e1 ff ff 0f 00 48 8d 0c c8 <48> 8b 29 48 85 ed 75 12 e9 9f 00 00 00 48 8b 6d 00 48 85 ed 0f 84
> All code
> ========
>    0:	04 31                	add    $0x31,%al
>    2:	fb                   	sti    
>    3:	83 fe 03             	cmp    $0x3,%esi
>    6:	77 97                	ja     0xffffffffffffff9f
>    8:	83 fe 02             	cmp    $0x2,%esi
>    b:	74 7a                	je     0x87
>    d:	83 fe 03             	cmp    $0x3,%esi
>   10:	74 72                	je     0x84
>   12:	83 fe 01             	cmp    $0x1,%esi
>   15:	74 73                	je     0x8a
>   17:	48 8b 05 45 ec 11 02 	mov    0x211ec45(%rip),%rax        # 0x211ec63
>   1e:	89 d9                	mov    %ebx,%ecx
>   20:	81 e1 ff ff 0f 00    	and    $0xfffff,%ecx
>   26:	48 8d 0c c8          	lea    (%rax,%rcx,8),%rcx
>   2a:*	48 8b 29             	mov    (%rcx),%rbp		<-- trapping instruction
>   2d:	48 85 ed             	test   %rbp,%rbp
>   30:	75 12                	jne    0x44
>   32:	e9 9f 00 00 00       	jmp    0xd6
>   37:	48 8b 6d 00          	mov    0x0(%rbp),%rbp
>   3b:	48 85 ed             	test   %rbp,%rbp
>   3e:	0f                   	.byte 0xf
>   3f:	84                   	.byte 0x84
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	48 8b 29             	mov    (%rcx),%rbp
>    3:	48 85 ed             	test   %rbp,%rbp
>    6:	75 12                	jne    0x1a
>    8:	e9 9f 00 00 00       	jmp    0xac
>    d:	48 8b 6d 00          	mov    0x0(%rbp),%rbp
>   11:	48 85 ed             	test   %rbp,%rbp
>   14:	0f                   	.byte 0xf
>   15:	84                   	.byte 0x84
> RSP: 0000:ffffb3f700027b78 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 000000004ea3cdf0 RCX: 00000000001e6f80
> RDX: 000000000000000d RSI: 0000000000000002 RDI: 00000000793ec676
> RBP: ffff8b578094f4d0 R08: 0000000043abc8c3 R09: 000000000000000d
> R10: 0000000000000015 R11: 000000000000001c R12: 0000000000000001
> R13: 0000000000000cc0 R14: ffffb3f700027bd8 R15: 000000000000000d
> FS:  0000000000000000(0000) GS:ffff8b5845c80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000001e6f80 CR3: 0000000199410000 CR4: 00000000000006e0

regards,
-- 
js
