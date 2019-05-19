Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964AE2279F
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbfESRVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 13:21:48 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34336 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfESRVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 13:21:47 -0400
Received: by mail-ed1-f65.google.com with SMTP id p27so19910303eda.1;
        Sun, 19 May 2019 10:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=muJ45ksqmDxJSuktlA1uB6dC+KQpi/yFEAlPEyZxCyE=;
        b=R2mkT9PZ+lVe4BKUWRp2d7UfzGVIzKpCLbx5ulfPDHL6VzAMyXWO5sHsSQ0eiEOzHH
         c28V7NmJkKGxvmNoVattjHPmI3kVoHKRfx4906XzZLcbD9nUJlfCv3sku1yjoKwU7J8q
         VszGSfEe7rnpKYudlIWucbVUAgSOToPdh2YpAGrk8CbJj9IcvHVn6Q4qeF+EOXWcG2Cl
         XboNb7cD4bNfKB/v+K+JE3kbOI0066iKZRc2CLycTK1tDwlDTD+CfeOY+kQEep3STtFc
         BCgkBGpsGMZWKCx6PWH7N5GQeWkWQeAPPqEyBG3HCMapNvMtvFsrrIfRVc2y8POA+Bs4
         QbQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=muJ45ksqmDxJSuktlA1uB6dC+KQpi/yFEAlPEyZxCyE=;
        b=p+BcVC9o8LgFwrJNLn8Yf4F5diUyUTsiZzjWvhrZ7fJ1D1yTGEbueamUNGz/upn7ae
         rjYh2dKg3m+rydxAkC7Uxy6umuNR7/j2MpEBAfnB/Ead10VB8cOhmcWixEvaG2bvScYx
         MxY5oIoccPuVVWgL6zv2w86Iwm2XLtCfsgr+4f+TwPu7gq9oGQrXCHfEW1/H47uYEOoh
         CvIaGyKomDzs3mPWQvZhBFoh9nF+8GCWBr9CymlTvh+QugbmuTC/h9uPoiVJNXhQfMtK
         CPcmJFR/btos8D8JHW0tTqWbTmRpW+9fHK2dYNXIZeoBk4VJn7rNSTDhMTnaZg5+HmH4
         S0nQ==
X-Gm-Message-State: APjAAAWBpHisHtWIBCSrwbql640AvwECxr4bBQsWyuK+41lRj8uPCr0F
        kGqAKNVdfJiybw9jCpK0r+k=
X-Google-Smtp-Source: APXvYqwDRaxw8f0nK491XFTGuqzkzn9IYubE/F/Ao44Ix7toWHBVEMdRUoBF1kbKIlboy+jLMcAekQ==
X-Received: by 2002:a17:906:4f8f:: with SMTP id o15mr38721572eju.129.1558280632338;
        Sun, 19 May 2019 08:43:52 -0700 (PDT)
Received: from archlinux-epyc ([2a01:4f9:2b:2b15::2])
        by smtp.gmail.com with ESMTPSA id q11sm4956735edd.51.2019.05.19.08.43.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 19 May 2019 08:43:50 -0700 (PDT)
Date:   Sun, 19 May 2019 08:43:48 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Haller <thaller@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 4.9 41/51] fib_rules: return 0 directly if an exactly
 same rule exists when NLM_F_EXCL not supplied
Message-ID: <20190519154348.GA113991@archlinux-epyc>
References: <20190515090616.669619870@linuxfoundation.org>
 <20190515090628.066392616@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20190515090628.066392616@linuxfoundation.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 15, 2019 at 12:56:16PM +0200, Greg Kroah-Hartman wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> 
> [ Upstream commit e9919a24d3022f72bcadc407e73a6ef17093a849 ]
> 
> With commit 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to
> fib_nl_newrule") we now able to check if a rule already exists. But this
> only works with iproute2. For other tools like libnl, NetworkManager,
> it still could add duplicate rules with only NLM_F_CREATE flag, like
> 
> [localhost ~ ]# ip rule
> 0:      from all lookup local
> 32766:  from all lookup main
> 32767:  from all lookup default
> 100000: from 192.168.7.5 lookup 5
> 100000: from 192.168.7.5 lookup 5
> 
> As it doesn't make sense to create two duplicate rules, let's just return
> 0 if the rule exists.
> 
> Fixes: 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to fib_nl_newrule")
> Reported-by: Thomas Haller <thaller@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/core/fib_rules.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/net/core/fib_rules.c
> +++ b/net/core/fib_rules.c
> @@ -429,9 +429,9 @@ int fib_nl_newrule(struct sk_buff *skb,
>  	if (rule->l3mdev && rule->table)
>  		goto errout_free;
>  
> -	if ((nlh->nlmsg_flags & NLM_F_EXCL) &&
> -	    rule_exists(ops, frh, tb, rule)) {
> -		err = -EEXIST;
> +	if (rule_exists(ops, frh, tb, rule)) {
> +		if (nlh->nlmsg_flags & NLM_F_EXCL)
> +			err = -EEXIST;
>  		goto errout_free;
>  	}
>  
> 
> 

Hi all,

This commit is causing issues on Android devices when Wi-Fi and mobile
data are both enabled. The device will do a soft reboot consistently.
So far, I've had reports on the Pixel 3 XL, OnePlus 6, Pocophone, and
Note 9 and I can reproduce on my OnePlus 6.

Sorry for taking so long to report this, I just figured out how to
reproduce it today and I didn't want to report it without that.

Attached is a full dmesg and the relevant snippet from Android's logcat.

Let me know what I can do to help debug,
Nathan

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.log"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.9.177-gb7bd79d4e8f5 (nathan@archlinux-epyc) =
(clang version 9.0.0 (git://github.com/llvm/llvm-project 898896836dd17e093f=
fb9c8293193332d3d68b62)) #1 SMP PREEMPT Sat May 18 12:24:16 MST 2019
[    0.000000] Boot CPU: AArch64 Processor [517f803c]
[    0.000000] Machine: Qualcomm Technologies, Inc. SDM845 v2.1 MTP PVT
[    0.000000] Reserved memory: created CMA memory pool at 0x00000000fec000=
00, size 16 MiB
[    0.000000] OF: reserved mem: initialized node adsp_region, compatible i=
d shared-dma-pool
[    0.000000] Reserved memory: created CMA memory pool at 0x00000000fdc000=
00, size 16 MiB
[    0.000000] OF: reserved mem: initialized node qseecom_ta_region, compat=
ible id shared-dma-pool
[    0.000000] Reserved memory: created CMA memory pool at 0x00000000f80000=
00, size 92 MiB
[    0.000000] OF: reserved mem: initialized node secure_display_region, co=
mpatible id shared-dma-pool
[    0.000000] Reserved memory: created CMA memory pool at 0x000000027a4000=
00, size 36 MiB
[    0.000000] OF: reserved mem: initialized node mem_dump_region, compatib=
le id shared-dma-pool
[    0.000000] Reserved memory: created CMA memory pool at 0x00000000f78000=
00, size 8 MiB
[    0.000000] OF: reserved mem: initialized node secure_sp_region, compati=
ble id shared-dma-pool
[    0.000000] Reserved memory: created CMA memory pool at 0x00000000ef8000=
00, size 128 MiB
[    0.000000] OF: reserved mem: initialized node linux,cma, compatible id =
shared-dma-pool
[    0.000000] Reserved memory: created DMA memory pool at 0x000000008ab000=
00, size 20 MiB
[    0.000000] OF: reserved mem: initialized node qseecom_region@0x8ab00000=
, compatible id shared-dma-pool
[    0.000000] Removed memory: created DMA memory pool at 0x000000008bf0000=
0, size 5 MiB
[    0.000000] OF: reserved mem: initialized node camera_region@0x8bf00000,=
 compatible id removed-dma-pool
[    0.000000] Removed memory: created DMA memory pool at 0x000000008c40000=
0, size 0 MiB
[    0.000000] OF: reserved mem: initialized node ips_fw_region@0x8c400000,=
 compatible id removed-dma-pool
[    0.000000] Removed memory: created DMA memory pool at 0x000000008c41000=
0, size 0 MiB
[    0.000000] OF: reserved mem: initialized node ipa_gsi_region@0x8c410000=
, compatible id removed-dma-pool
[    0.000000] Removed memory: created DMA memory pool at 0x000000008c41500=
0, size 0 MiB
[    0.000000] OF: reserved mem: initialized node gpu_region@0x8c415000, co=
mpatible id removed-dma-pool
[    0.000000] Removed memory: created DMA memory pool at 0x000000008c50000=
0, size 26 MiB
[    0.000000] OF: reserved mem: initialized node adsp_region@0x8c500000, c=
ompatible id removed-dma-pool
[    0.000000] Removed memory: created DMA memory pool at 0x000000008df0000=
0, size 1 MiB
[    0.000000] OF: reserved mem: initialized node wlan_fw_region@0x8df00000=
, compatible id removed-dma-pool
[    0.000000] Removed memory: created DMA memory pool at 0x000000008e00000=
0, size 120 MiB
[    0.000000] OF: reserved mem: initialized node modem_region@0x8e000000, =
compatible id removed-dma-pool
[    0.000000] Removed memory: created DMA memory pool at 0x000000009580000=
0, size 5 MiB
[    0.000000] OF: reserved mem: initialized node video_region@0x95800000, =
compatible id removed-dma-pool
[    0.000000] Removed memory: created DMA memory pool at 0x0000000095d0000=
0, size 8 MiB
[    0.000000] OF: reserved mem: initialized node cdsp_region@0x95d00000, c=
ompatible id removed-dma-pool
[    0.000000] Removed memory: created DMA memory pool at 0x000000009650000=
0, size 2 MiB
[    0.000000] OF: reserved mem: initialized node mba_region@0x96500000, co=
mpatible id removed-dma-pool
[    0.000000] Removed memory: created DMA memory pool at 0x000000009670000=
0, size 20 MiB
[    0.000000] OF: reserved mem: initialized node slpi_region@0x96700000, c=
ompatible id removed-dma-pool
[    0.000000] Removed memory: created DMA memory pool at 0x0000000097b0000=
0, size 1 MiB
[    0.000000] OF: reserved mem: initialized node pil_spss_region@0x97b0000=
0, compatible id removed-dma-pool
[    0.000000] On node 0 totalpages: 2008649
[    0.000000] free_area_init_node: node 0, pgdat ffffff8009707680, node_me=
m_map ffffffc1f2214000
[    0.000000] DMA zone: 8192 pages used for memmap
[    0.000000] DMA zone: 0 pages reserved
[    0.000000] DMA zone: 449961 pages, LIFO batch:31
[    0.000000] Normal zone: 24355 pages used for memmap
[    0.000000] Normal zone: 1558688 pages, LIFO batch:31
[    0.000000] psci: probing for conduit method from DT.
[    0.000000] psci: PSCIv1.1 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: MIGRATE_INFO_TYPE not supported.
[    0.000000] psci: SMC Calling Convention v1.0
[    0.000000] random: fast init done
[    0.000000] percpu: Embedded 20 pages/cpu s51480 r0 d30440 u81920
[    0.000000] pcpu-alloc: s51480 r0 d30440 u81920 alloc=3D20*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7=
=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 1976102
[    0.000000] Kernel command line: quiet rcupdate.rcu_expedited=3D1 noirqd=
ebug androidboot.hardware=3Dqcom androidboot.console=3DttyMSM0 video=3Dvfb:=
640x400,bpp=3D32,memsize=3D3072000 msm_rtb.filter=3D0x237 ehci-hcd.park=3D3=
 lpm_levels.sleep_disabled=3D1 service_locator.enable=3D1 swiotlb=3D2048 an=
droidboot.configfs=3Dtrue androidboot.usbcontroller=3Da600000.dwc3 firmware=
_class.path=3D/vendor/firmware_mnt/image loop.max_part=3D7 buildvariant=3Du=
ser androidboot.verifiedbootstate=3Dorange androidboot.keymaster=3D1 dm=3D"=
1 vroot none ro 1,0 5764704 verity 1 PARTUUID=3De7505641-4ac1-cf0a-53c2-f64=
0f90fdd04 PARTUUID=3De7505641-4ac1-cf0a-53c2-f640f90fdd04 4096 4096 720588 =
720588 sha1 8ac817f655b76567ece5024b04dca0ea23256077 1a87bfcea39e15b538433e=
48836a4032e45a9ff2e1b809a0f129c10704566ae8 10 restart_on_corruption ignore_=
zero_blocks use_fec_from_device PARTUUID=3De7505641-4ac1-cf0a-53c2-f640f90f=
dd04 fec_roots 2 fec_blocks 726263 fec_start 726263" root=3D/dev/dm-0 andro=
idboot.vbmeta.device=3DPARTUUID=3Dc4dc3735-e477-34e9-9acf-62b92d8f6a70 andr=
oidb
[    0.000000] IRQ lockup detection disabled
[    0.000000] log_buf_len individual max cpu contribution: 131072 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 917504 bytes
[    0.000000] log_buf_len min size: 262144 bytes
[    0.000000] log_buf_len: 2097152 bytes
[    0.000000] early log buf free: 255696(97%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608=
 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 b=
ytes)
[    0.000000] software IO TLB: mapped [mem 0xef400000-0xef800000] (4MB)
[    0.000000] Memory: 7484332K/8034596K available (15998K kernel code, 158=
4K rwdata, 4904K rodata, 576K init, 5323K bss, 247160K reserved, 303104K cm=
a-reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000] modules : 0xffffff8000000000 - 0xffffff8008000000   (   128 =
MB)
[    0.000000] vmalloc : 0xffffff8008000000 - 0xffffffbebfff0000   (   250 =
GB)
[    0.000000] .text : 0xffffff8008080000 - 0xffffff8009020000   ( 16000 KB)
[    0.000000] .rodata : 0xffffff8009020000 - 0xffffff80094f0000   (  4928 =
KB)
[    0.000000] .init : 0xffffff80094f0000 - 0xffffff8009580000   (   576 KB)
[    0.000000] .data : 0xffffff8009580000 - 0xffffff800970c000   (  1584 KB)
[    0.000000] .bss : 0xffffff800970c000 - 0xffffff8009c3ed5c   (  5324 KB)
[    0.000000] fixed   : 0xffffffbefe7fd000 - 0xffffffbefec00000   (  4108 =
KB)
[    0.000000] PCI I/O : 0xffffffbefee00000 - 0xffffffbeffe00000   (    16 =
MB)
[    0.000000] memory  : 0xffffffc000000000 - 0xffffffc1fc8a0000   (  8136 =
MB)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D8, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] \x09RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] \x09RCU kthread priority: 1.
[    0.000000] NR_IRQS:64 nr_irqs:64 0
[    0.000000] PDC SDM845 v2 initialized
[    0.000000] \x09Offload RCU callbacks from all CPUs
[    0.000000] \x09Offload RCU callbacks from CPUs: 0-7.
[    0.000000] arm_arch_timer: Architected cp15 and mmio timer(s) running a=
t 19.20MHz (virt/virt).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cy=
cles: 0x46d987e47, max_idle_ns: 440795202767 ns
[    0.000005] sched_clock: 56 bits at 19MHz, resolution 52ns, wraps every =
4398046511078ns
[    0.000021] clocksource: Switched to clocksource arch_sys_counter
[    0.002221] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 38.00 BogoMIPS (lpj=3D64000)
[    0.002237] pid_max: default: 32768 minimum: 301
[    0.002307] Security Framework initialized
[    0.002316] SELinux:  Initializing.
[    0.002356] SELinux:  Starting in permissive mode
[    0.002388] Mount-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.002392] Mountpoint-cache hash table entries: 16384 (order: 5, 131072=
 bytes)
[    0.003405] /cpus/cpu@0: Missing clock-frequency property
[    0.003417] /cpus/cpu@100: Missing clock-frequency property
[    0.003424] /cpus/cpu@200: Missing clock-frequency property
[    0.003430] /cpus/cpu@300: Missing clock-frequency property
[    0.003439] /cpus/cpu@400: Missing clock-frequency property
[    0.003446] /cpus/cpu@500: Missing clock-frequency property
[    0.003453] /cpus/cpu@600: Missing clock-frequency property
[    0.003461] /cpus/cpu@700: Missing clock-frequency property
[    0.003522] sched-energy: Sched-energy-costs installed from DT
[    0.006780] ASID allocator initialised with 65536 entries
[    0.006828] NOHZ: local_softirq_pending 02
[    0.030566] CPU1: Booted secondary processor [517f803c]
[    0.040577] CPU2: Booted secondary processor [517f803c]
[    0.050642] CPU3: Booted secondary processor [517f803c]
[    0.061311] CPU4: Booted secondary processor [516f802d]
[    0.071742] CPU5: Booted secondary processor [516f802d]
[    0.082299] CPU6: Booted secondary processor [516f802d]
[    0.093019] CPU7: Booted secondary processor [516f802d]
[    0.093175] Brought up 8 CPUs
[    0.093181] SMP: Total of 8 processors activated.
[    0.093185] CPU features: detected feature: GIC system register CPU inte=
rface
[    0.093187] CPU features: detected feature: Privileged Access Never
[    0.093189] CPU features: detected feature: User Access Override
[    0.093192] CPU features: detected feature: 32-bit EL0 Support
[    0.093299] CPU: All CPU(s) started at EL1
[    0.093336] alternatives: patching kernel code
[    0.094987] CPU7: update max cpu_capacity 1024
[    0.162393] CPU0: update max cpu_capacity 1024
[    0.163113] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 6370867519511994 ns
[    0.163125] futex hash table entries: 2048 (order: 6, 262144 bytes)
[    0.168909] pinctrl core: initialized pinctrl subsystem
[    0.169512] NET: Registered protocol family 16
[    0.170529] schedtune: init normalization constants...
[    0.170536] schedtune: CLUSTER[0-3]      min_pwr:     1 max_pwr:    17
[    0.170541] schedtune: CPU[0]            min_pwr:     4 max_pwr:   160
[    0.170544] schedtune: CPU[1]            min_pwr:     4 max_pwr:   160
[    0.170546] schedtune: CPU[2]            min_pwr:     4 max_pwr:   160
[    0.170549] schedtune: CPU[3]            min_pwr:     4 max_pwr:   160
[    0.170553] schedtune: CLUSTER[4-7]      min_pwr:     1 max_pwr:   190
[    0.170557] schedtune: CPU[4]            min_pwr:    40 max_pwr: 60000
[    0.170560] schedtune: CPU[5]            min_pwr:    40 max_pwr: 60000
[    0.170563] schedtune: CPU[6]            min_pwr:    40 max_pwr: 60000
[    0.170566] schedtune: CPU[7]            min_pwr:    40 max_pwr: 60000
[    0.170571] schedtune: SYSTEM            min_pwr:   178 max_pwr: 240847
[    0.170573] schedtune: using normalization constants mul: 383241808 sh1:=
 1 sh2: 17
[    0.170574] schedtune: verify normalization constants...
[    0.170577] schedtune: max_pwr/2^0: 240669 =3D> norm_pwr:  1024
[    0.170580] schedtune: max_pwr/2^1: 120334 =3D> norm_pwr:   511
[    0.170582] schedtune: max_pwr/2^2: 60167 =3D> norm_pwr:   255
[    0.170584] schedtune: max_pwr/2^3: 30083 =3D> norm_pwr:   127
[    0.170586] schedtune: max_pwr/2^4: 15041 =3D> norm_pwr:    63
[    0.170587] schedtune: max_pwr/2^5: 7520 =3D> norm_pwr:    31
[    0.170589] schedtune: configured to support 6 boost groups
[    0.171231] cpuidle: using governor menu
[    0.172392] cpuidle: using governor qcom
[    0.177311] vdso: 2 pages (1 code @ ffffff8009027000, 1 data @ ffffff800=
9584000)
[    0.177316] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    0.177911] DMA: preallocated 256 KiB pool for atomic allocations
[    0.177992] msm_smem_init: unable to create logging context
[    0.178014] <CORE> glink_init: unable to create log context
[    0.178561] exit: IPA_USB init success!
[    0.178600] Failed to create IPC log0
[    0.178606] Failed to create IPC log1
[    0.178609] Failed to create IPC log2
[    0.178611] Failed to create IPC log3
[    0.178613] Failed to create IPC log4
[    0.188677] pstore: using zlib compression
[    0.188862] console [pstore0] enabled
[    0.188933] pstore: Registered ramoops as persistent store backend
[    0.188937] ramoops: attached 0x400000@0xac300000, ecc: 0/0
[    0.191558] irq: no irq domain found for /soc/qcom,mdss_mdp@ae00000 !
[    0.191630] irq: no irq domain found for /soc/qcom,mdss_mdp@ae00000 !
[    0.191902] qupv3_geni_se 8c0000.qcom,qupv3_0_geni_se: geni_se_probe Fai=
led to allocate log context
[    0.192030] irq: no irq domain found for /soc/pinctrl@03400000 !
[    0.192438] qupv3_geni_se ac0000.qcom,qupv3_1_geni_se: geni_se_probe Fai=
led to allocate log context
[    0.195523] unable to find DT imem DLOAD mode node
[    0.197220] unable to find DT imem EDLOAD mode node
[    0.198089] set_dload_mode ON
[    0.198513] spmi spmi-0: PMIC arbiter version v5 (0x50000000)
[    0.200298] platform 4080000.qcom,mss: assigned reserved memory node mod=
em_region@0x8e000000
[    0.200391] platform 17300000.qcom,lpass: assigned reserved memory node =
adsp_region@0x8c500000
[    0.200482] platform 5c00000.qcom,ssc: assigned reserved memory node slp=
i_region@0x96700000
[    0.201095] platform 8300000.qcom,turing: assigned reserved memory node =
cdsp_region@0x95d00000
[    0.201375] platform soc:qcom,msm-adsprpc-mem: assigned reserved memory =
node adsp_region
[    0.201585] platform aae0000.qcom,venus: assigned reserved memory node v=
ideo_region@0x95800000
[    0.205749] <CORE> glink_core_register_transport: unable to create log c=
ontext for [spss:mailbox]
[    0.205824] <CORE> glink_mailbox_probe: unable to create log context for=
 [spss:mailbox]
[    0.210841] <CORE> glink_core_register_transport: unable to create log c=
ontext for [mpss:smem]
[    0.210907] <CORE> glink_smem_native_probe: unable to create log context=
 for [mpss:smem]
[    0.211312] <CORE> glink_core_register_transport: unable to create log c=
ontext for [lpass:smem]
[    0.211381] <CORE> glink_smem_native_probe: unable to create log context=
 for [lpass:smem]
[    0.211804] <CORE> glink_core_register_transport: unable to create log c=
ontext for [dsps:smem]
[    0.211853] <CORE> glink_smem_native_probe: unable to create log context=
 for [dsps:smem]
[    0.212350] <CORE> glink_core_register_transport: unable to create log c=
ontext for [cdsp:smem]
[    0.212396] <CORE> glink_smem_native_probe: unable to create log context=
 for [cdsp:smem]
[    0.213196] sps:sps is ready.
[    0.213712] (NULL device *): msm_gsi_probe:3147 failed to create IPC log=
, continue...
[    0.214048] platform soc:qcom,ipa_fws: assigned reserved memory node ips=
_fw_region@0x8c400000
[    0.215205] platform soc:mem_dump: assigned reserved memory node mem_dum=
p_region
[    0.217930] pm8998_s9_level: supplied by pm8998_s6_level
[    0.217965] pm8998_s9_level: Bringing 1uV into 17-17uV
[    0.218084] pm8998_s9_level_ao: supplied by pm8998_s6_level_ao
[    0.218107] pm8998_s9_level_ao: Bringing 1uV into 17-17uV
[    0.225344] pm8998_l24: supplied by pm8998_l12
[    0.226881] pm8998_lvs1: Bringing 1uV into 1800000-1800000uV
[    0.227220] pm8998_lvs2: Bringing 1uV into 1800000-1800000uV
[    0.240559] sdm845-v2-pinctrl 3400000.pinctrl: invalid resource
[    0.246607] platform soc:qcom,kgsl-hyp: assigned reserved memory node gp=
u_region@0x8c415000
[    0.263724] gpu_cx_gdsc: supplied by pm8998_s9_level
[    0.266339] clk: cam_cc_bps_clk_src: set OPP pair(19200000 Hz: 129 uV) o=
n ac6f000.qcom,bps
[    0.266542] clk: cam_cc_bps_clk_src: set OPP pair(600000000 Hz: 257 uV) =
on ac6f000.qcom,bps
[    0.266683] clk: cam_cc_cci_clk_src: set OPP pair(19200000 Hz: 129 uV) o=
n ac4a000.qcom,cci
[    0.266829] clk: cam_cc_cci_clk_src: set OPP pair(100000000 Hz: 257 uV) =
on ac4a000.qcom,cci
[    0.266994] clk: cam_cc_csi0phytimer_clk_src: set OPP pair(19200000 Hz: =
129 uV) on ac65000.qcom,csiphy
[    0.267066] clk: cam_cc_csi0phytimer_clk_src: set OPP pair(269333333 Hz:=
 129 uV) on ac65000.qcom,csiphy
[    0.267217] clk: cam_cc_csi1phytimer_clk_src: set OPP pair(19200000 Hz: =
129 uV) on ac66000.qcom,csiphy
[    0.267301] clk: cam_cc_csi1phytimer_clk_src: set OPP pair(269333333 Hz:=
 129 uV) on ac66000.qcom,csiphy
[    0.267439] clk: cam_cc_csi2phytimer_clk_src: set OPP pair(19200000 Hz: =
129 uV) on ac67000.qcom,csiphy
[    0.267527] clk: cam_cc_csi2phytimer_clk_src: set OPP pair(269333333 Hz:=
 129 uV) on ac67000.qcom,csiphy
[    0.267688] clk: cam_cc_csi3phytimer_clk_src: set OPP pair(19200000 Hz: =
49 uV) on ac68000.qcom,csiphy
[    0.267771] clk: cam_cc_csi3phytimer_clk_src: set OPP pair(269333333 Hz:=
 129 uV) on ac68000.qcom,csiphy
[    0.268259] clk: cam_cc_icp_clk_src: set OPP pair(19200000 Hz: 129 uV) o=
n ac00000.qcom,a5
[    0.268423] clk: cam_cc_icp_clk_src: set OPP pair(600000000 Hz: 193 uV) =
on ac00000.qcom,a5
[    0.268724] clk: cam_cc_ife_0_clk_src: set OPP pair(19200000 Hz: 129 uV)=
 on acaf000.qcom,vfe0
[    0.268941] clk: cam_cc_ife_0_clk_src: set OPP pair(600000000 Hz: 257 uV=
) on acaf000.qcom,vfe0
[    0.269178] clk: cam_cc_ife_0_csid_clk_src: set OPP pair(19200000 Hz: 12=
9 uV) on acb3000.qcom,csid0
[    0.269307] clk: cam_cc_ife_0_csid_clk_src: set OPP pair(538666667 Hz: 2=
57 uV) on acb3000.qcom,csid0
[    0.269619] clk: cam_cc_ife_1_clk_src: set OPP pair(19200000 Hz: 129 uV)=
 on acb6000.qcom,vfe1
[    0.269842] clk: cam_cc_ife_1_clk_src: set OPP pair(600000000 Hz: 257 uV=
) on acb6000.qcom,vfe1
[    0.270121] clk: cam_cc_ife_1_csid_clk_src: set OPP pair(19200000 Hz: 12=
9 uV) on acba000.qcom,csid1
[    0.270252] clk: cam_cc_ife_1_csid_clk_src: set OPP pair(538666667 Hz: 2=
57 uV) on acba000.qcom,csid1
[    0.270548] clk: cam_cc_ife_lite_clk_src: set OPP pair(19200000 Hz: 129 =
uV) on acc4000.qcom,vfe-lite
[    0.270774] clk: cam_cc_ife_lite_clk_src: set OPP pair(600000000 Hz: 257=
 uV) on acc4000.qcom,vfe-lite
[    0.271069] clk: cam_cc_ife_lite_csid_clk_src: set OPP pair(19200000 Hz:=
 129 uV) on acc8000.qcom,csid-lite
[    0.271218] clk: cam_cc_ife_lite_csid_clk_src: set OPP pair(538666667 Hz=
: 257 uV) on acc8000.qcom,csid-lite
[    0.271685] clk: cam_cc_ipe_0_clk_src: set OPP pair(19200000 Hz: 129 uV)=
 on ac87000.qcom,ipe0
[    0.272001] clk: cam_cc_ipe_0_clk_src: set OPP pair(600000000 Hz: 257 uV=
) on ac87000.qcom,ipe0
[    0.272525] clk: cam_cc_ipe_1_clk_src: set OPP pair(19200000 Hz: 129 uV)=
 on ac91000.qcom,ipe1
[    0.272804] clk: cam_cc_ipe_1_clk_src: set OPP pair(600000000 Hz: 257 uV=
) on ac91000.qcom,ipe1
[    0.275868] cam_cc-sdm845 ad00000.qcom,camcc: Registered Camera CC clocks
[    0.276989] qmp-aop-clk soc:qcom,aopclk: Registered clocks with AOP
[    0.277924] clk-rpmh soc:qcom,rpmhclk: Registered RPMh clocks
[    0.279824] disp_cc-sdm845 af00000.qcom,dispcc: Registered Display CC cl=
ocks
[    0.303522] gcc-sdm845 100000.qcom,gcc: Registered GCC clocks
[    0.304386] clk: gpu_cc_gx_gfx3d_clk_src: set OPP pair(180000000 Hz: 49 =
uV) on 5000000.qcom,kgsl-3d0
[    0.304658] clk: gpu_cc_gx_gfx3d_clk_src: set OPP pair(710000000 Hz: 417=
 uV) on 5000000.qcom,kgsl-3d0
[    0.304725] gfxcc-sdm845 5090000.qcom,gfxcc: Registered GFX CC clocks
[    0.306239] clk: gpu_cc_gmu_clk_src: set OPP pair(19200000 Hz: 49 uV) on=
 506a000.qcom,gmu
[    0.306340] clk: gpu_cc_gmu_clk_src: set OPP pair(500000000 Hz: 129 uV) =
on 506a000.qcom,gmu
[    0.306533] gpu_cc-sdm845 5090000.qcom,gpucc: Registered GPU CC clocks
[    0.307728] video_cc-sdm845 ab00000.qcom,videocc: Registered Video CC cl=
ocks
[    0.308049] socinfo_print: v0.15, id=3D321, ver=3D2.1, raw_id=3D139, raw=
_ver=3D2, hw_plat=3D8, hw_plat_ver=3D65536\x0a accessory_chip=3D0, hw_plat_=
subtype=3D0, pmic_model=3D65556, pmic_die_revision=3D131072 foundry_id=3D3 =
serial_number=3D3423966390 num_pmics=3D3 chip_family=3D0x4f raw_device_fami=
ly=3D0x6 raw_device_number=3D0x0 nproduct_id=3D0x3f4 num_clusters=3D0x1 ncl=
uster_array_offset=3D0xb0 num_defective_parts=3D0x6 ndefective_parts_array_=
offset=3D0xb4 nmodem_supported=3D0xff
[    0.308052] msm_bus_fabric_rpmh_init_driver
[    0.308254] msm_bus: Probe started
[    0.308864] msm_bus_device 16e0000.ad-hoc-bus: Bus type is missing
[    0.308915] msm_bus_device 16e0000.ad-hoc-bus: Bus type is missing
[    0.308928] msm_bus_device 16e0000.ad-hoc-bus: Bus type is missing
[    0.308978] msm_bus_device 16e0000.ad-hoc-bus: Bus type is missing
[    0.311322] msm_bus: DT Parsing complete
[    0.314282] msm_bus_fab_init_noc_ops: Invalid Bus type
[    0.314433] msm_bus_fab_init_noc_ops: Invalid Bus type
[    0.314472] msm_bus_fab_init_noc_ops: Invalid Bus type
[    0.314629] msm_bus_fab_init_noc_ops: Invalid Bus type
[    0.325444] actuator_regulator: supplied by pmi8998_bob
[    0.325787] actuator_regulator: supplied by pmi8998_bob
[    0.325878] actuator_regulator: Failed to create debugfs directory
[    0.325898] actuator_regulator: Failed to create debugfs directory
[    0.325917] reg-fixed-voltage vendor:ext_5v_boost: could not find pctlde=
v for node /soc/qcom,spmi@c440000/qcom,pmi8998@2/pinctrl@c000/usb2_ext_5v_b=
oost/usb2_ext_5v_boost_default, deferring probe
[    0.326776] arm-smmu 5040000.arm,smmu-kgsl: \x09(IDR0.CTTW overridden by=
 dma-coherent property)
[    0.326895] arm-smmu 5040000.arm,smmu-kgsl: \x09stream matching with 5 r=
egister groups, mask 0x7
[    0.327058] arm-smmu 5040000.arm,smmu-kgsl: found 8 context interrupt(s)=
 but have 5 context banks. assuming 5 context interrupts.
[    0.329616] register_client_adhoc:find path.src 139 dest 627
[    0.329804] register_client_adhoc:Client handle 1 apps_smmu
[    0.329974] arm-smmu 15000000.apps-smmu: \x09(IDR0.CTTW overridden by dm=
a-coherent property)
[    0.330098] arm-smmu 15000000.apps-smmu: \x09stream matching with 76 reg=
ister groups, mask 0x7fff
[    0.330840] arm-smmu 15000000.apps-smmu: found 64 context interrupt(s) b=
ut have 45 context banks. assuming 45 context interrupts.
[    0.331340] register_client_adhoc:find path.src 139 dest 627
[    0.331478] register_client_adhoc:Client handle 2 apps_smmu
[    0.331677] register_client_adhoc:find path.src 139 dest 627
[    0.331810] register_client_adhoc:Client handle 3 apps_smmu
[    0.332000] register_client_adhoc:find path.src 22 dest 773
[    0.332075] register_client_adhoc:Client handle 4 mnoc_hf_0_tbu
[    0.332263] register_client_adhoc:find path.src 22 dest 773
[    0.332332] register_client_adhoc:Client handle 5 mnoc_hf_1_tbu
[    0.332517] register_client_adhoc:find path.src 137 dest 772
[    0.332590] register_client_adhoc:Client handle 6 mnoc_sf_0_tbu
[    0.332730] register_client_adhoc:find path.src 139 dest 627
[    0.332868] register_client_adhoc:Client handle 7 apps_smmu
[    0.333059] register_client_adhoc:find path.src 139 dest 627
[    0.333192] register_client_adhoc:Client handle 8 apps_smmu
[    0.333418] register_client_adhoc:find path.src 139 dest 627
[    0.333550] register_client_adhoc:Client handle 9 apps_smmu
[    0.334232] iommu: Adding device ae00000.qcom,mdss_mdp to group 0
[    0.334372] iommu: Adding device 8c0000.qcom,qupv3_0_geni_se:qcom,iommu_=
qupv3_0_geni_se_cb to group 1
[    0.334508] iommu: Adding device ac0000.qcom,qupv3_1_geni_se:qcom,iommu_=
qupv3_1_geni_se_cb to group 2
[    0.334665] iommu: Adding device 1de0000.qcedev to group 3
[    0.334796] iommu: Adding device 1de0000.qcrypto to group 4
[    0.334931] iommu: Adding device 18800000.qcom,icnss to group 5
[    0.335062] iommu: Adding device 800000.qcom,gpi-dma to group 6
[    0.335195] iommu: Adding device a00000.qcom,gpi-dma to group 7
[    0.335325] iommu: Adding device 88a7000.msm_tspp to group 8
[    0.335458] iommu: Adding device soc:apps_iommu_test_device to group 8
[    0.335582] iommu: Adding device soc:apps_iommu_coherent_test_device to =
group 8
[    0.335727] iommu: Adding device soc:qcom,msm-audio-ion to group 9
[    0.335863] iommu: Adding device a600000.ssusb to group 10
[    0.335996] iommu: Adding device soc:usb_audio_qmi_dev to group 11
[    0.337618] SCSI subsystem initialized
[    0.337711] usbcore: registered new interface driver usbfs
[    0.337734] usbcore: registered new interface driver hub
[    0.337853] usbcore: registered new device driver usb
[    0.338347] soc:usb_nop_phy supply vcc not found, using dummy regulator
[    0.338676] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8c0:0x21)
[    0.338690] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8c1:0x0)
[    0.338704] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8c2:0x2)
[    0.338718] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8c3:0x0)
[    0.338733] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8c4:0x40)
[    0.338746] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8c5:0x2)
[    0.338760] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8c6:0x0)
[    0.338774] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8c7:0x80)
[    0.338788] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8c8:0x40)
[    0.338802] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8c9:0x0)
[    0.338816] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8ca:0x0)
[    0.338830] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8cb:0x0)
[    0.338844] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8cc:0x0)
[    0.338858] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8cd:0x0)
[    0.338872] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8ce:0x0)
[    0.338886] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: (0x8cf:0x0)
[    0.338938] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: PMIC@SID0 PON_REASON1 regs :[0x21] and Power-on reason: Triggered=
 from Hard Reset and 'warm' boot
[    0.338942] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: PMIC@SID0 PON_REASON1 regs :[0x21] and Power-on reason: Triggered=
 from PON1 (secondary PMIC) and 'warm' boot
[    0.338970] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pm8998@0:qcom,powe=
r-on@800: PMIC@SID0: POFF_REASON regs :[0x2] and Power-off reason: Triggere=
d from PS_HOLD (PS_HOLD/MSM controlled shutdown)
[    0.339152] input: qpnp_pon as /devices/virtual/input/input0
[    0.340006] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: No PON config. specified
[    0.340056] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8c0:0x20)
[    0.340072] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8c1:0x0)
[    0.340086] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8c2:0x8)
[    0.340101] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8c3:0x0)
[    0.340115] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8c4:0x40)
[    0.340129] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8c5:0x8)
[    0.340144] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8c6:0x0)
[    0.340157] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8c7:0x80)
[    0.340171] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8c8:0x0)
[    0.340186] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8c9:0x0)
[    0.340200] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8ca:0x0)
[    0.340214] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8cb:0x0)
[    0.340228] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8cc:0x0)
[    0.340242] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8cd:0x0)
[    0.340256] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8ce:0x0)
[    0.340271] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: (0x8cf:0x0)
[    0.340322] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: PMIC@SID2 PON_REASON1 regs :[0x20] and Power-on reason: Triggere=
d from PON1 (secondary PMIC) and 'warm' boot
[    0.340348] qcom,qpnp-power-on c440000.qcom,spmi:qcom,pmi8998@2:qcom,pow=
er-on@800: PMIC@SID2: POFF_REASON regs :[0x8] and Power-off reason: Trigger=
ed from GP1 (Keypad_Reset1)
[    0.340703] media: Linux media interface: v0.10
[    0.340726] Linux video capture interface: v2.00
[    0.354136] platform soc:qcom,ion:qcom,ion-heap@22: assigned reserved me=
mory node adsp_region
[    0.354371] platform soc:qcom,ion:qcom,ion-heap@27: assigned reserved me=
mory node qseecom_region@0x8ab00000
[    0.354460] platform soc:qcom,ion:qcom,ion-heap@19: assigned reserved me=
mory node qseecom_ta_region
[    0.354532] platform soc:qcom,ion:qcom,ion-heap@13: assigned reserved me=
mory node secure_sp_region
[    0.354604] platform soc:qcom,ion:qcom,ion-heap@10: assigned reserved me=
mory node secure_display_region
[    0.354878] ION heap system created
[    0.355002] ION heap adsp created at 0x00000000fec00000 with size 1000000
[    0.355012] ION heap qsecom created at 0x000000008ab00000 with size 1400=
000
[    0.355019] ION heap qsecom_ta created at 0x00000000fdc00000 with size 1=
000000
[    0.355027] ION heap spss created at 0x00000000f7800000 with size 800000
[    0.355035] ION heap secure_display created at 0x00000000f8000000 with s=
ize 5c00000
[    0.355042] ION heap secure_heap created
[    0.355628] ipa ipa3_tz_unlock_reg:4965 Bad parameters
[    0.355639] ipa ipa3_pre_init:5165 Failed to unlock memory region using =
TZ
[    0.355726] register_client_adhoc:find path.src 90 dest 512
[    0.356167] register_client_adhoc:find path.src 90 dest 585
[    0.356301] register_client_adhoc:find path.src 1 dest 676
[    0.356542] register_client_adhoc:find path.src 143 dest 777
[    0.356612] register_client_adhoc:Client handle 10 ipa
[    0.357039] ipa ipa3_uc_state_check:284 uC interface not initialized
[    0.357622] ipa ipa3_uc_state_check:284 uC interface not initialized
[    0.358126] iommu: Adding device 1e00000.qcom,ipa:ipa_smmu_ap to group 12
[    0.358351] iommu: Adding device 1e00000.qcom,ipa:ipa_smmu_wlan to group=
 13
[    0.358560] iommu: Adding device 1e00000.qcom,ipa:ipa_smmu_uc to group 14
[    0.359321] PMIC@SID0: PM8998 v2.0 options: 0, 0, 0, 0
[    0.359452] PMIC@SID4: PM8005 v2.0 options: 0, 0, 0, 0
[    0.359564] PMIC@SID2: PMI8998 v2.1 options: 0, 0, 0, 0
[    0.360808] Advanced Linux Sound Architecture Driver Initialized.
[    0.361497] Bluetooth: Core ver 2.22
[    0.361517] NET: Registered protocol family 31
[    0.361518] Bluetooth: HCI device and connection manager initialized
[    0.361526] Bluetooth: HCI socket layer initialized
[    0.361532] Bluetooth: L2CAP socket layer initialized
[    0.361553] Bluetooth: SCO socket layer initialized
[    0.361895] NetLabel: Initializing
[    0.361897] NetLabel:  domain hash size =3D 128
[    0.361898] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.361939] NetLabel:  unlabeled traffic allowed by default
[    0.361991] pcie:pcie_init.
[    0.362000] pcie_init: unable to create IPC log context for pcie0-short
[    0.362004] pcie_init: unable to create IPC log context for pcie0-long
[    0.362009] pcie_init: unable to create IPC log context for pcie0-dump
[    0.362014] pcie_init: unable to create IPC log context for pcie1-short
[    0.362018] pcie_init: unable to create IPC log context for pcie1-long
[    0.362023] pcie_init: unable to create IPC log context for pcie1-dump
[    0.362028] pcie_init: unable to create IPC log context for pcie2-short
[    0.362033] pcie_init: unable to create IPC log context for pcie2-long
[    0.362037] pcie_init: unable to create IPC log context for pcie2-dump
[    0.362944] gpu_gx_gdsc: supplied by pm8005_s1_level
[    0.363288] actuator_regulator: Failed to create debugfs directory
[    0.364718] clk: add_opp: Set OPP pair (300000000 Hz, 592000 uv) on cpu0
[    0.365376] clk: add_opp: Set OPP pair (1766400000 Hz, 804000 uv) on cpu0
[    0.365425] clk: add_opp: Set OPP pair (300000000 Hz, 592000 uv) on cpu1
[    0.366084] clk: add_opp: Set OPP pair (1766400000 Hz, 804000 uv) on cpu1
[    0.366133] clk: add_opp: Set OPP pair (300000000 Hz, 592000 uv) on cpu2
[    0.366828] clk: add_opp: Set OPP pair (1766400000 Hz, 804000 uv) on cpu2
[    0.366895] clk: add_opp: Set OPP pair (300000000 Hz, 592000 uv) on cpu3
[    0.367574] clk: add_opp: Set OPP pair (1766400000 Hz, 804000 uv) on cpu3
[    0.367621] clk: add_opp: Set OPP pair (825600000 Hz, 600000 uv) on cpu4
[    0.368613] clk: add_opp: Set OPP pair (2803200000 Hz, 1032000 uv) on cp=
u4
[    0.368658] clk: add_opp: Set OPP pair (825600000 Hz, 600000 uv) on cpu5
[    0.369660] clk: add_opp: Set OPP pair (2803200000 Hz, 1032000 uv) on cp=
u5
[    0.369708] clk: add_opp: Set OPP pair (825600000 Hz, 600000 uv) on cpu6
[    0.370767] clk: add_opp: Set OPP pair (2803200000 Hz, 1032000 uv) on cp=
u6
[    0.370814] clk: add_opp: Set OPP pair (825600000 Hz, 600000 uv) on cpu7
[    0.371872] clk: add_opp: Set OPP pair (2803200000 Hz, 1032000 uv) on cp=
u7
[    0.372285] clk: add_opp: Set OPP pair (300000000 Hz, 600000 uv) on soc:=
qcom,l3-cpu0
[    0.372288] clk: add_opp: Set OPP pair (300000000 Hz, 600000 uv) on soc:=
qcom,l3-cpu4
[    0.372290] clk: add_opp: Set OPP pair (300000000 Hz, 600000 uv) on soc:=
qcom,l3-cdsp
[    0.372293] clk: add_opp: Set OPP pair (300000000 Hz, 600000 uv) on 5000=
000.qcom,kgsl-3d0
[    0.374388] clk: add_opp: Set OPP pair (1478400000 Hz, 816000 uv) on soc=
:qcom,l3-cpu0
[    0.374390] clk: add_opp: Set OPP pair (1478400000 Hz, 816000 uv) on soc=
:qcom,l3-cpu4
[    0.374392] clk: add_opp: Set OPP pair (1478400000 Hz, 816000 uv) on soc=
:qcom,l3-cdsp
[    0.374394] clk: add_opp: Set OPP pair (1478400000 Hz, 816000 uv) on 500=
0000.qcom,kgsl-3d0
[    0.375465] cpufreq: driver osm-cpufreq up and running
[    0.375467] clk: clk_cpu_osm_driver_probe: OSM CPUFreq driver inited
[    0.375523] reg-fixed-voltage vendor:ext_5v_boost: could not find pctlde=
v for node /soc/qcom,spmi@c440000/qcom,pmi8998@2/pinctrl@c000/usb2_ext_5v_b=
oost/usb2_ext_5v_boost_default, deferring probe
[    0.375709] sched-energy energy-costs: cpu=3D0 eff=3D1024 [freq=3D300000=
 cap=3D65 power_d0=3D12] -> [freq=3D1766400 cap=3D381 power_d0=3D160]
[    0.375713] CPU0: update cpu_capacity 381
[    0.375720] sched-energy energy-costs: cpu=3D1 eff=3D1024 [freq=3D300000=
 cap=3D65 power_d0=3D12] -> [freq=3D1766400 cap=3D381 power_d0=3D160]
[    0.375722] CPU1: update cpu_capacity 381
[    0.375728] sched-energy energy-costs: cpu=3D2 eff=3D1024 [freq=3D300000=
 cap=3D65 power_d0=3D12] -> [freq=3D1766400 cap=3D381 power_d0=3D160]
[    0.375730] CPU2: update cpu_capacity 381
[    0.375737] sched-energy energy-costs: cpu=3D3 eff=3D1024 [freq=3D300000=
 cap=3D65 power_d0=3D12] -> [freq=3D1766400 cap=3D381 power_d0=3D160]
[    0.375739] CPU3: update cpu_capacity 381
[    0.375746] sched-energy energy-costs: cpu=3D4 eff=3D1740 [freq=3D300000=
 cap=3D110 power_d0=3D189] -> [freq=3D2956800 cap=3D1024 power_d0=3D60000]
[    0.375747] CPU4: update cpu_capacity 1024
[    0.375754] sched-energy energy-costs: cpu=3D5 eff=3D1740 [freq=3D300000=
 cap=3D110 power_d0=3D189] -> [freq=3D2956800 cap=3D1024 power_d0=3D60000]
[    0.375755] CPU5: update cpu_capacity 1024
[    0.375762] sched-energy energy-costs: cpu=3D6 eff=3D1740 [freq=3D300000=
 cap=3D110 power_d0=3D189] -> [freq=3D2956800 cap=3D1024 power_d0=3D60000]
[    0.375763] CPU6: update cpu_capacity 1024
[    0.375771] sched-energy energy-costs: cpu=3D7 eff=3D1740 [freq=3D300000=
 cap=3D110 power_d0=3D189] -> [freq=3D2956800 cap=3D1024 power_d0=3D60000]
[    0.375773] CPU7: update cpu_capacity 1024
[    0.376864] sched-energy energy-costs: Sched-energy-costs capacity updat=
ed
[    0.376895] reg-fixed-voltage vendor:ext_5v_boost: could not find pctlde=
v for node /soc/qcom,spmi@c440000/qcom,pmi8998@2/pinctrl@c000/usb2_ext_5v_b=
oost/usb2_ext_5v_boost_default, deferring probe
[    0.377150] clocksource: Switched to clocksource arch_sys_counter
[    0.377216] VFS: Disk quotas dquot_6.6.0
[    0.377245] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byte=
s)
[    0.377697] debugcc-sdm845 soc:qcom,cc-debug@100000: Registered debug mu=
x successfully
[    0.378222] mdss_pll_probe: MDSS pll label =3D MDSS DSI 0 PLL
[    0.378224] mdss_pll_probe: mdss_pll_probe: label=3DMDSS DSI 0 PLL PLL S=
SC enabled
[    0.378268] mdss_pll ae94a00.qcom,mdss_dsi_pll: Failed to create debugfs=
 directory
[    0.378271] mdss_pll ae94a00.qcom,mdss_dsi_pll: Failed to create debugfs=
 directory
[    0.378275] mdss_pll ae94a00.qcom,mdss_dsi_pll: Failed to create debugfs=
 directory
[    0.378278] mdss_pll ae94a00.qcom,mdss_dsi_pll: Failed to create debugfs=
 directory
[    0.378281] mdss_pll ae94a00.qcom,mdss_dsi_pll: Failed to create debugfs=
 directory
[    0.378689] dsi_pll_clock_register_10nm: Registered DSI PLL ndx=3D0, clo=
cks successfully
[    0.378705] mdss_pll_probe: MDSS pll label =3D MDSS DSI 1 PLL
[    0.378706] mdss_pll_probe: mdss_pll_probe: label=3DMDSS DSI 1 PLL PLL S=
SC enabled
[    0.378733] mdss_pll ae96a00.qcom,mdss_dsi_pll: Failed to create debugfs=
 directory
[    0.378736] mdss_pll ae96a00.qcom,mdss_dsi_pll: Failed to create debugfs=
 directory
[    0.378739] mdss_pll ae96a00.qcom,mdss_dsi_pll: Failed to create debugfs=
 directory
[    0.378742] mdss_pll ae96a00.qcom,mdss_dsi_pll: Failed to create debugfs=
 directory
[    0.378744] mdss_pll ae96a00.qcom,mdss_dsi_pll: Failed to create debugfs=
 directory
[    0.380060] CPU1: update max cpu_capacity 381
[    0.383375] CPU5: update max cpu_capacity 1024
[    0.383821] dsi_pll_10nm_lock_status: DSI PLL(1) lock failed, status=3D0=
x00000000
[    0.389024] dsi_pll_10nm_lock_status: DSI PLL(1) lock failed, status=3D0=
x00000000
[    0.389130] dsi_pll_clock_register_10nm: Registered DSI PLL ndx=3D1, clo=
cks successfully
[    0.389143] mdss_pll_probe: MDSS pll label =3D MDSS DP PLL
[    0.392311] NET: Registered protocol family 2
[    0.392629] TCP established hash table entries: 65536 (order: 7, 524288 =
bytes)
[    0.392737] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.393004] TCP: Hash tables configured (established 65536 bind 65536)
[    0.393034] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.393082] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.393216] NET: Registered protocol family 1
[    0.393233] PCI: CLS 0 bytes, default 128
[    0.393267] reg-fixed-voltage vendor:ext_5v_boost: could not find pctlde=
v for node /soc/qcom,spmi@c440000/qcom,pmi8998@2/pinctrl@c000/usb2_ext_5v_b=
oost/usb2_ext_5v_boost_default, deferring probe
[    0.393509] Unpacking initramfs...
[    0.600396] Freeing initrd memory: 15616K
[    0.600493] execprog: copying static data
[    0.600550] execprog: finished copying
[    0.600882] hw perfevents: enabled with armv8_pmuv3 PMU driver, 7 counte=
rs available
[    0.605518] workingset: timestamp_bits=3D61 max_order=3D21 bucket_order=
=3D0
[    0.606819] Registering sdcardfs 0.1
[    0.606882] ntfs: driver 2.1.32 [Flags: R/O].
[    0.606917] fuse init (API version 7.26)
[    0.607068] exFAT: Version 1.2.9
[    0.607088] SELinux:  Registering netfilter hooks
[    0.607225] pfk_ext4 [pfk_ext4_init]: PFK EXT4 inited successfully
[    0.607226] pfk_f2fs [pfk_f2fs_init]: PFK F2FS inited successfully
[    0.607228] pfk [pfk_init]: Driver initialized successfully
[    0.612236] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 247)
[    0.612240] io scheduler noop registered
[    0.612241] io scheduler deadline registered
[    0.612278] io scheduler cfq registered (default)
[    0.619848] qcom,qpnp-clkdiv c440000.qcom,spmi:qcom,pm8998@0:qcom,clkdiv=
@5b00: Registered qpnp_clkdiv_1 successfully
[    0.619905] qcom,qpnp-clkdiv c440000.qcom,spmi:qcom,pm8998@0:qcom,clkdiv=
@5c00: Registered qpnp_clkdiv_2 successfully
[    0.619961] qcom,qpnp-clkdiv c440000.qcom,spmi:qcom,pm8998@0:qcom,clkdiv=
@5d00: Registered qpnp_clkdiv_3 successfully
[    0.622482] glink_loopback_server_init: unable to create log context
[    0.622818] <CORE> glink_core_register_transport: unable to create log c=
ontext for [wdsp:spi]
[    0.623209] msm_smp2p_init: unable to create log context
[    0.624450] qmi_log_init: Unable to create QMI IPC logging for Req/Resp
[    0.624454] logging for Indications: Unable to create QMI IPC qmi_log_in=
it
[    0.624913] icnss: Unable to create log context
[    0.624916] icnss: Unable to create log long context
[    0.625786] icnss 18800000.qcom,icnss: for wcss_msa0 segments only will =
be dumped.
[    0.625836] icnss: Platform driver probed successfully
[    0.626423] register_client_adhoc:find path.src 125 dest 512
[    0.626629] register_client_adhoc:Client handle 11 scm_pas
[    0.626641] minidump-id not found for adsp
[    0.626763] minidump-id not found for slpi
[    0.626816] minidump-id not found for cdsp
[    0.627073] register_client_adhoc:find path.src 63 dest 512
[    0.627190] register_client_adhoc:Client handle 12 pil-venus
[    0.627196] minidump-id not found for venus
[    0.627207] subsys-pil-tz aae0000.qcom,venus: for venus segments only wi=
ll be dumped.
[    0.627316] minidump-id not found for ipa_fws
[    0.627321] subsys-pil-tz soc:qcom,ipa_fws: for ipa_fws segments only wi=
ll be dumped.
[    0.627422] minidump-id not found for a630_zap
[    0.627427] subsys-pil-tz soc:qcom,kgsl-hyp: for a630_zap segments only =
will be dumped.
[    0.627754] pil-q6v5-mss 4080000.qcom,mss: No pas_id found.
[    0.628463] qiib_driver_data_init: unable to create logging context
[    0.630393] msm_geni_serial 898000.qcom,qup_uart: Wakeup byte 0xfd
[    0.630417] msm_geni_serial 898000.qcom,qup_uart: Serial port0 added.Fif=
oSize 64 is_console0
[    0.630429] 898000.qcom,qup_uart: ttyHS0 at MMIO 0x898000 (irq =3D 8, ba=
se_baud =3D 0) is a MSM
[    0.630792] msm_geni_serial_init: Driver initialized
[    0.630903] register_client_adhoc:find path.src 1 dest 618
[    0.631020] register_client_adhoc:Client handle 13 msm-rng-noc
[    0.632750] random: crng init done
[    0.635104] loop: module loaded
[    0.635513] QSEECOM: qseecom_probe: qseecom.qsee_version =3D 0x1400000
[    0.635529] QSEECOM: qseecom_retrieve_ce_data: Device does not support P=
FE
[    0.635533] QSEECOM: qseecom_probe: no-clock-support=3D0x1
[    0.635535] QSEECOM: qseecom_probe: qseecom.qsee_reentrancy_support =3D 2
[    0.635554] register_client_adhoc:find path.src 125 dest 512
[    0.635719] register_client_adhoc:Client handle 14 qseecom-noc
[    0.635774] QSEECOM: qseecom_probe: qseecom.whitelist_support =3D 1
[    0.635953] Loading pn544 driver
[    0.636054] register_client_adhoc:find path.src 125 dest 512
[    0.636196] register_client_adhoc:Client handle 15 qcedev-noc
[    0.637686] qce 1de0000.qcedev: QTI Crypto 5.4.1 device found @0x1de0000
[    0.637691] qce 1de0000.qcedev: CE device =3D 0x0 IO base, CE =3D ffffff=
800a8a0000 Consumer (IN) PIPE 6,\x0aProducer (OUT) PIPE 7 IO base BAM =3D 0=
000000000000000\x0aBAM IRQ 104 Engines Availability =3D 0x2011073
[    0.637721] sps_register_bam_device : unable to create IPC Logging 0 for=
 bam 0x0000000001dc4000
[    0.637730] sps_register_bam_device : unable to create IPC Logging 1 for=
 bam 0x0000000001dc4000
[    0.637736] sps_register_bam_device : unable to create IPC Logging 2 for=
 bam 0x0000000001dc4000
[    0.637742] sps_register_bam_device : unable to create IPC Logging 3 for=
 bam 0x0000000001dc4000
[    0.637746] sps_register_bam_device : unable to create IPC Logging 4 for=
 bam 0x0000000001dc4000
[    0.637754] sps:BAM 0x0000000001dc4000 is registered.
[    0.637954] sps:BAM 0x0000000001dc4000 (va:0xffffff800bdc0000) enabled: =
ver:0x27, number of pipes:16
[    0.638300] QCE50: qce_sps_init:  QTI MSM CE-BAM at 0x0000000001dc4000 i=
rq 104
[    0.638743] iommu: Adding device 1de0000.qcedev:qcom_cedev_ns_cb to grou=
p 15
[    0.639269] qcedev_setup_context_bank Attached 1de0000.qcedev:qcom_cedev=
_ns_cb and create mapping
[    0.639271] qcedev_setup_context_bank Context Bank name:ns_context, is_s=
ecure:0, start_addr:0x60000000
[    0.639274] qcedev_setup_context_bank size:0x40000000, dev:ffffffc1ec013=
c10, mapping:ffffffc1ec0eab00
[    0.639347] iommu: Adding device 1de0000.qcedev:qcom_cedev_s_cb to group=
 16
[    0.641300] qcedev_setup_context_bank Attached 1de0000.qcedev:qcom_cedev=
_s_cb and create mapping
[    0.641305] qcedev_setup_context_bank Context Bank name:secure_context, =
is_secure:1, start_addr:0x60200000
[    0.641307] qcedev_setup_context_bank size:0x40000000, dev:ffffffc1ec014=
010, mapping:ffffffc1ec100400
[    0.642009] register_client_adhoc:find path.src 125 dest 512
[    0.642209] register_client_adhoc:Client handle 16 qcrypto-noc
[    0.643565] qcrypto 1de0000.qcrypto: QTI Crypto 5.4.1 device found @0x1d=
e0000
[    0.643570] qcrypto 1de0000.qcrypto: CE device =3D 0x0 IO base, CE =3D f=
fffff800bea0000 Consumer (IN) PIPE 4,\x0aProducer (OUT) PIPE 5 IO base BAM =
=3D 0000000000000000\x0aBAM IRQ 104 Engines Availability =3D 0x2011073
[    0.644041] QCE50: qce_sps_init:  QTI MSM CE-BAM at 0x0000000001dc4000 i=
rq 104
[    0.644419] qcrypto 1de0000.qcrypto: qcrypto-ecb-aes
[    0.644551] qcrypto 1de0000.qcrypto: qcrypto-cbc-aes
[    0.644668] qcrypto 1de0000.qcrypto: qcrypto-ctr-aes
[    0.644778] qcrypto 1de0000.qcrypto: qcrypto-ecb-des
[    0.644883] qcrypto 1de0000.qcrypto: qcrypto-cbc-des
[    0.644990] qcrypto 1de0000.qcrypto: qcrypto-ecb-3des
[    0.645102] qcrypto 1de0000.qcrypto: qcrypto-cbc-3des
[    0.645211] qcrypto 1de0000.qcrypto: qcrypto-xts-aes
[    0.645334] qcrypto 1de0000.qcrypto: qcrypto-sha1
[    0.645444] qcrypto 1de0000.qcrypto: qcrypto-sha256
[    0.645552] qcrypto 1de0000.qcrypto: qcrypto-aead-hmac-sha1-cbc-aes
[    0.645662] qcrypto 1de0000.qcrypto: qcrypto-aead-hmac-sha1-cbc-des
[    0.645770] qcrypto 1de0000.qcrypto: qcrypto-aead-hmac-sha1-cbc-3des
[    0.645876] qcrypto 1de0000.qcrypto: qcrypto-aead-hmac-sha256-cbc-aes
[    0.645987] qcrypto 1de0000.qcrypto: qcrypto-aead-hmac-sha256-cbc-des
[    0.646095] qcrypto 1de0000.qcrypto: qcrypto-aead-hmac-sha256-cbc-3des
[    0.646206] qcrypto 1de0000.qcrypto: qcrypto-hmac-sha1
[    0.646315] qcrypto 1de0000.qcrypto: qcrypto-hmac-sha256
[    0.646420] qcrypto 1de0000.qcrypto: qcrypto-aes-ccm
[    0.646526] qcrypto 1de0000.qcrypto: qcrypto-rfc4309-aes-ccm
[    0.647669] ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to f=
ind vccq-supply regulator, assuming enabled
[    0.650942] qcom_ice_get_pdevice: found ice device ffffffc1ec733a00
[    0.650944] qcom_ice_get_pdevice: matching platform device ffffffc1efebb=
000
[    0.651122] register_client_adhoc:find path.src 123 dest 512
[    0.651336] register_client_adhoc:find path.src 1 dest 757
[    0.651470] register_client_adhoc:Client handle 17 ufshc_mem
[    0.652155] scsi host0: ufshcd
[    0.656834] qcom_ice 1d90000.ufsice: QC ICE 3.1.75 device found @0xfffff=
f800a8c8000
[    0.663905] SCSI Media Changer driver v0.25=20
[    0.663946] [drm] Initialized
[    0.664075] register_client_adhoc:find path.src 20003 dest 20515
[    0.664144] register_client_adhoc:find path.src 20004 dest 20515
[    0.664190] register_client_adhoc:Client handle 18 disp_rsc_mnoc
[    0.664208] register_client_adhoc:find path.src 20001 dest 20513
[    0.664262] register_client_adhoc:Client handle 19 disp_rsc_llcc
[    0.664280] register_client_adhoc:find path.src 20000 dest 20512
[    0.664331] register_client_adhoc:Client handle 20 disp_rsc_ebi
[    0.664505] [sde_rsc_hw:rsc_hw_init:679]: sde rsc init successfully done
[    0.664524] [sde_rsc:sde_rsc_probe:1416]: sde rsc index:0 probed success=
fully
[    0.664887] msm-dsi-phy:[dsi_phy_driver_probe] Probe successful for dsi-=
phy-0
[    0.665019] msm-dsi-phy:[dsi_phy_driver_probe] Probe successful for dsi-=
phy-1
[    0.665505] AXI: get_pdata(): Error: Client name not found
[    0.665511] AXI: msm_bus_cl_get_pdata(): client has to provide missing e=
ntry for successful registration
[    0.665518] dsi-ctrl:[dsi_ctrl_dev_probe] Probe successful for dsi-ctrl-0
[    0.667249] msm-dsi-panel:[dsi_panel_parse_reset_sequence:1869] RESET SE=
Q LENGTH =3D 24
[    0.667268] msm-dsi-panel:[dsi_panel_parse_misc_features:1916] dsi_panel=
_parse_misc_features: ulps feature enabled
[    0.667271] msm-dsi-panel:[dsi_panel_parse_misc_features:1922] dsi_panel=
_parse_misc_features: ulps during suspend feature disabled
[    0.667340] msm-dsi-panel:[dsi_panel_parse_esd_config:3118] ESD enabled =
with mode: register_read
[    0.668155] msm-dsi-display:[dsi_display_get_boot_display] index =3D 0
[    0.668159] msm-dsi-display:[dsi_display_get_boot_display] index =3D 1
[    0.668740] register_client_adhoc:find path.src 1 dest 590
[    0.668908] register_client_adhoc:Client handle 21 mdss_reg
[    0.668934] register_client_adhoc:find path.src 22 dest 512
[    0.669065] register_client_adhoc:find path.src 23 dest 512
[    0.669196] register_client_adhoc:Client handle 22 mdss_sde
[    0.669279] msm_drm ae00000.qcom,mdss_mdp: bound af20000.qcom,sde_rscc (=
ops 0xffffff80090a4e08)
[    0.669285] msm_drm ae00000.qcom,mdss_mdp: bound soc:qcom,wb-display@0 (=
ops 0xffffff80090a91a8)
[    0.669554] msm-dsi-display:[dsi_display_bind] Successfully bind display=
 panel 'dsi_samsung_sofef00_m_cmd_display'
[    0.669840] msm_drm ae00000.qcom,mdss_mdp: bound soc:qcom,dsi-display@18=
 (ops 0xffffff80090a5c50)
[    0.669878] [drm] mapped mdp address space @ffffff800e700000
[    0.669892] msm_drm ae00000.qcom,mdss_mdp: failed to get memory resource=
: vbif_nrt_phys
[    0.669964] [drm:_sde_kms_get_splash_data:3194] found continuous splash =
base address:9d400000 size:2400000
[    0.671424] [drm:sde_kms_hw_init:3323] sde hardware revision:0x40000001
[    0.672258] [drm] Created domain mdp_ns [80000000,80000000] secure=3D0
[    0.676077] iommu: Adding device ae00000.qcom,mdss_mdp:qcom,smmu_sde_sec=
_cb to group 17
[    0.676400] [drm] probing device qcom,smmu_sde_sec
[    0.676408] [drm] Created domain mdp_s [80000000,80000000] secure=3D1
[    0.680473] [drm] invalid feature map 9 for feature 10
[    0.680593] [drm] invalid feature map 9 for feature 10
[    0.680708] [drm] invalid feature map 9 for feature 10
[    0.680729] ufshcd-qcom 1d84000.ufshc: ufshcd_print_pwr_info:[RX, TX]: g=
ear=3D[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate =3D 0
[    0.680834] [drm] invalid feature map 9 for feature 10
[    0.769647] ufshcd-qcom 1d84000.ufshc: ufshcd_print_pwr_info:[RX, TX]: g=
ear=3D[3, 3], lane[2, 2], pwr[FAST MODE, FAST MODE], rate =3D 2
[    0.770623] scsi 0:0:0:49488: Well-known LUN    SAMSUNG  KLUDG4U1EA-B0C1=
  0500 PQ: 0 ANSI: 6
[    0.771638] scsi 0:0:0:49456: Well-known LUN    SAMSUNG  KLUDG4U1EA-B0C1=
  0500 PQ: 0 ANSI: 6
[    0.772460] scsi 0:0:0:49476: Well-known LUN    SAMSUNG  KLUDG4U1EA-B0C1=
  0500 PQ: 0 ANSI: 6
[    0.773319] scsi 0:0:0:0: Direct-Access     SAMSUNG  KLUDG4U1EA-B0C1  05=
00 PQ: 0 ANSI: 6
[    0.774071] scsi 0:0:0:1: Direct-Access     SAMSUNG  KLUDG4U1EA-B0C1  05=
00 PQ: 0 ANSI: 6
[    0.774670] scsi 0:0:0:2: Direct-Access     SAMSUNG  KLUDG4U1EA-B0C1  05=
00 PQ: 0 ANSI: 6
[    0.775287] scsi 0:0:0:3: Direct-Access     SAMSUNG  KLUDG4U1EA-B0C1  05=
00 PQ: 0 ANSI: 6
[    0.775904] scsi 0:0:0:4: Direct-Access     SAMSUNG  KLUDG4U1EA-B0C1  05=
00 PQ: 0 ANSI: 6
[    0.776524] scsi 0:0:0:5: Direct-Access     SAMSUNG  KLUDG4U1EA-B0C1  05=
00 PQ: 0 ANSI: 6
[    0.783815] sdc: sdc1 sdc2
[    0.783995] sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8 sda9 sda10 sda1=
1 sda12 sda13 sda14 sda15 sda16 sda17
[    0.784933] sdb: sdb1 sdb2
[    0.785117] sdd: sdd1 sdd2 sdd3
[    0.787342] sde: sde1 sde2 sde3 sde4 sde5 sde6 sde7 sde8 sde9 sde10 sde1=
1 sde12 sde13 sde14 sde15 sde16 sde17 sde18 sde19 sde20 sde21 sde22 sde23 s=
de24 sde25 sde26 sde27 sde28 sde29 sde30 sde31 sde32 sde33 sde34 sde35 sde3=
6 sde37 sde38 sde39 sde40 sde41 sde42 sde43 sde44 sde45 sde46 sde47 sde48 s=
de49 sde50 sde51 sde52 sde53 sde54 sde55 sde56 sde57 sde58 sde59 sde60 sde6=
1 sde62 sde63 sde64 sde65 sde66 sde67 sde68 sde69 sde70 sde71 sde72
[    0.792469] sdf: sdf1 sdf2 sdf3 sdf4 sdf5
[    0.805936] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.805939] [drm] No driver support for vblank timestamp query.
[    0.807335] msm-dsi-panel:[dsi_panel_parse_topology:2662] default topolo=
gy: lm: 1 comp_enc:0 intf: 1
[    0.807702] msm-dsi-panel:[dsi_panel_parse_partial_update_caps:2750] par=
tial update disabled as the property is not set
[    0.807871] dsi-ctrl:[_dsi_ctrl_setup_isr] [DSI_0] IRQ 661 registered
[    0.812277] iommu: Adding device 506a000.qcom,gmu:gmu_user to group 18
[    0.812544] iommu: Adding device 506a000.qcom,gmu:gmu_kernel to group 19
[    0.814092] register_client_adhoc:find path.src 26 dest 512
[    0.814352] register_client_adhoc:Client handle 23 grp3d
[    0.814373] register_client_adhoc:find path.src 26 dest 10036
[    0.814527] register_client_adhoc:Client handle 24 cnoc
[    0.814534] query_client_usecase_all: query_start
[    0.814593] query_client_usecase_all: query_start
[    0.815636] iommu: Adding device 5040000.qcom,kgsl-iommu:gfx3d_user to g=
roup 20
[    0.815896] iommu: Adding device 5040000.qcom,kgsl-iommu:gfx3d_secure to=
 group 21
[    0.849521] libphy: Fixed MDIO Bus: probed
[    0.849523] tun: Universal TUN/TAP device driver, 1.6
[    0.849524] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.849563] PPP generic driver version 2.4.2
[    0.849633] PPP BSD Compression module registered
[    0.849635] PPP Deflate Compression module registered
[    0.849712] PPP MPPE Compression module registered
[    0.849716] NET: Registered protocol family 24
[    0.849820] CLD80211: Initializing
[    0.849894] usbcore: registered new interface driver r8152
[    0.849901] usbcore: registered new interface driver asix
[    0.849908] usbcore: registered new interface driver ax88179_178a
[    0.849921] usbcore: registered new interface driver cdc_ether
[    0.849925] usbcore: registered new interface driver net1080
[    0.849930] usbcore: registered new interface driver cdc_subset
[    0.849936] usbcore: registered new interface driver zaurus
[    0.849944] usbcore: registered new interface driver cdc_ncm
[    0.850325] msm_sharedmem: sharedmem_register_qmi: qmi init successful
[    0.855078] msm_sharedmem: msm_sharedmem_probe: Device created for clien=
t 'rmtfs'
[    0.856806] msm-qusb-phy-v2 88e2000.qusb: qusb_phy_probe:qusb-phy-ophost=
-init-seq got!
[    0.856935] msm-qusb-phy-v2 88e2000.qusb: usb_oe_exist=3D0
[    0.857237] actuator_regulator: Failed to create debugfs directory
[    0.858688] msm-dwc3 a600000.ssusb: unable to get dbm device
[    0.859774] usbcore: registered new interface driver usb-storage
[    0.860924] fgsi_init: Err allocating ipc_log_ctxt
[    0.861837] qpnp-pdphy c440000.qcom,spmi:qcom,pmi8998@2:qcom,usb-pdphy@1=
700: usbpd_create failed: -517
[    0.862269] mousedev: PS/2 mouse device common for all mice
[    0.862353] usbcore: registered new interface driver xpad
[    0.862355] synaptics,s3320: tpd_driver_init enter
[    0.862702] fingerprint_detect_probe
[    0.862843] fingerprint_detect soc:fingerprint_detect: fp-gpio-id0 - gpi=
o: 91
[    0.862847] fingerprint_detect soc:fingerprint_detect: fingerprint_detec=
t_probe: gpio_is_valid(fp_detect->id0_gpio=3D91)
[    0.862858] fingerprint_detect soc:fingerprint_detect: fp-gpio-id1 - gpi=
o: 92
[    0.862860] fingerprint_detect soc:fingerprint_detect: fingerprint_detec=
t_probe: gpio_is_valid(fp_detect->id1_gpio=3D92)
[    0.862872] fingerprint_detect soc:fingerprint_detect: fp-gpio-id2 - gpi=
o: 95
[    0.862873] fingerprint_detect soc:fingerprint_detect: fingerprint_detec=
t_probe: gpio_is_valid(fp_detect->id2_gpio=3D95)
[    0.872962] fingerprint_detect_probe: 011
[    0.883054] fingerprint_detect_probe: 011
[    0.893121] fingerprint_detect_probe: 011
[    0.893125] fingerprint_detect soc:fingerprint_detect: fingerprint_detec=
t_probe: ok
[    0.893147] gf_spi: gf_init:fp version 3
[    0.893155] CHRDEV "goodix_fp_spi" major number 233 goes below the dynam=
ic allocation range
[    0.893492] soc:goodix_fp supply vdd-3v2 not found, using dummy regulator
[    0.893523] gf_parse_dts: Failed to get regulator vdd voltage
[    0.893532] gf_parse_dts:00Failed to set regulator voltage vdd
[    0.893537] gf_parse_dts: Failed to get regulator vdd current
[    0.894011] input: gf_input as /devices/virtual/input/input1
[    0.894043] gf_spi: version V1.2.08
[    0.894106] gf_spi: status =3D 0x0
[    0.894109] [+silead_fp-] SILEAD_FP Driver, Version: v0.2.3.
[    0.894110] silfp_dev_init:fp version 3
[    0.894552] qcom,qpnp-rtc c440000.qcom,spmi:qcom,pm8998@0:qcom,pm8998_rt=
c: rtc core: registered qpnp_rtc as rtc0
[    0.894770] i2c /dev entries driver
[    0.894953] i2c_geni 88c000.i2c: No reset config specified
[    0.894959] i2c_geni 88c000.i2c: Bus frequency not specified, default to=
 400KHz.
[    0.895000] i2c_geni 88c000.i2c: Geni-I2C speed=3D400000
[    0.895713] pn544_parse_dt: 63, 12, 62, 116 error:0
[    0.895944] pn544_probe : requesting IRQ 315
[    0.896285] i2c_geni 890000.i2c: No reset config specified
[    0.896292] i2c_geni 890000.i2c: Bus frequency not specified, default to=
 400KHz.
[    0.896328] i2c_geni 890000.i2c: Geni-I2C speed=3D400000
[    0.896936] i2c_geni a88000.i2c: reset config specified
[    0.896975] i2c_geni a88000.i2c: Geni-I2C speed=3D100000
[    0.897632] i2c_geni a88000.i2c: i2c error :-107
[    0.897839] i2c_geni a88000.i2c: i2c error :-107
[    0.898043] i2c_geni a88000.i2c: i2c error :-107
[    0.898247] i2c_geni a88000.i2c: i2c error :-107
[    0.898253] I2C PMIC: i2c_pmic_read: i2c_pmic_read failed for 3 retries,=
 rc =3D -107
[    0.898259] I2C PMIC: i2c_pmic_determine_initial_status: Couldn't read i=
rq data rc=3D-107
[    0.898265] I2C PMIC: i2c_pmic_probe: Couldn't determine initial status =
rc=3D-107
[    0.898314] i2c_pmic: probe of 0-0008 failed with error -107
[    0.898578] i2c_geni a88000.i2c: i2c error :-107
[    0.898781] i2c_geni a88000.i2c: i2c error :-107
[    0.898982] i2c_geni a88000.i2c: i2c error :-107
[    0.899185] i2c_geni a88000.i2c: i2c error :-107
[    0.899189] I2C PMIC: i2c_pmic_read: i2c_pmic_read failed for 3 retries,=
 rc =3D -107
[    0.899194] I2C PMIC: i2c_pmic_determine_initial_status: Couldn't read i=
rq data rc=3D-107
[    0.899198] I2C PMIC: i2c_pmic_probe: Couldn't determine initial status =
rc=3D-107
[    0.899216] i2c_pmic: probe of 0-000c failed with error -107
[    0.899438] i2c_geni a90000.i2c: No reset config specified
[    0.899443] i2c_geni a90000.i2c: Bus frequency not specified, default to=
 400KHz.
[    0.899476] i2c_geni a90000.i2c: Geni-I2C speed=3D400000
[    0.900067] synaptics,s3320: before on cpu [4]
[    0.900073] synaptics,s3320: check CPU[0] is [online]
[    0.902197] iommu: Adding device aa00000.qcom,vidc:non_secure_cb to grou=
p 22
[    0.902653] iommu: Adding device aa00000.qcom,vidc:secure_bitstream_cb t=
o group 23
[    0.903965] iommu: Adding device aa00000.qcom,vidc:secure_pixel_cb to gr=
oup 24
[    0.904976] iommu: Adding device aa00000.qcom,vidc:secure_non_pixel_cb t=
o group 25
[    0.906723] register_client_adhoc:find path.src 1 dest 590
[    0.906945] register_client_adhoc:Client handle 25 sde_reg
[    0.907015] iommu: Adding device ae00000.qcom,mdss_rotator:qcom,smmu_rot=
_unsec_cb to group 26
[    0.907119] iommu: Adding device ae00000.qcom,mdss_rotator:qcom,smmu_rot=
_sec_cb to group 27
[    0.907256] register_client_adhoc:find path.src 25 dest 512
[    0.907407] register_client_adhoc:Client handle 26 mdss_rotator
[    0.907417] register_client_adhoc:find path.src 1 dest 590
[    0.907536] register_client_adhoc:Client handle 27 mdss_rot_reg
[    0.907935] No change in context(0=3D=3D0), skip
[    0.909464] sde_rotator_evtlog_create_debugfs: evtlog_status: enable:0, =
panic:1, dump:2
[    0.910692] sde_rotator ae00000.qcom,mdss_rotator: <SDEROT_INFO> SDE v4l=
2 rotator probe success
[    0.911865] sde_smmu_probe: <SDEROT_INFO> iommu v2 domain[0] mapping and=
 clk register successful!
[    0.912854] sde_smmu_probe: <SDEROT_INFO> iommu v2 domain[1] mapping and=
 clk register successful!
[    0.914303] iommu: Adding device soc:qcom,cam_smmu:msm_cam_smmu_ife to g=
roup 28
[    0.914451] iommu: Adding device soc:qcom,cam_smmu:msm_cam_smmu_jpeg to =
group 29
[    0.914517] platform soc:qcom,cam_smmu:msm_cam_icp_fw: assigned reserved=
 memory node camera_region@0x8bf00000
[    0.914602] iommu: Adding device soc:qcom,cam_smmu:msm_cam_smmu_icp to g=
roup 30
[    0.914700] iommu: Adding device soc:qcom,cam_smmu:msm_cam_smmu_cpas_cdm=
 to group 31
[    0.914830] iommu: Adding device soc:qcom,cam_smmu:msm_cam_smmu_fd to gr=
oup 32
[    0.914906] iommu: Adding device soc:qcom,cam_smmu:msm_cam_smmu_lrme to =
group 33
[    0.915710] register_client_adhoc:find path.src 1 dest 589
[    0.915873] register_client_adhoc:Client handle 28 cam_ahb
[    0.915984] register_client_adhoc:find path.src 136 dest 512
[    0.916106] register_client_adhoc:Client handle 29 cam_hf_1_mnoc
[    0.916295] register_client_adhoc:find path.src 146 dest 778
[    0.916330] register_client_adhoc:Client handle 30 cam_hf_1_camnoc
[    0.916428] register_client_adhoc:find path.src 145 dest 512
[    0.916546] register_client_adhoc:Client handle 31 cam_hf_2_mnoc
[    0.916724] register_client_adhoc:find path.src 147 dest 778
[    0.916754] register_client_adhoc:Client handle 32 cam_hf_2_camnoc
[    0.916854] register_client_adhoc:find path.src 137 dest 512
[    0.916983] register_client_adhoc:Client handle 33 cam_sf_1_mnoc
[    0.917150] register_client_adhoc:find path.src 148 dest 778
[    0.917183] register_client_adhoc:Client handle 34 cam_sf_1_camnoc
[    0.924801] CAM_INFO: CAM-ISP: cam_vfe_reset: 390 calling RESET on vfe 0
[    0.924889] CAM_INFO: CAM-ISP: cam_vfe_reset: 390 calling RESET on vfe 0
[    0.927564] CAM_INFO: CAM-ISP: cam_vfe_reset: 390 calling RESET on vfe 1
[    0.927646] CAM_INFO: CAM-ISP: cam_vfe_reset: 390 calling RESET on vfe 1
[    0.928246] CAM_ERR: CAM-UTIL: cam_soc_util_get_option_clk_by_name: 256 =
No clk named ife_dsp_clk found. Dev acc4000.qcom,vfe-lite
[    0.928252] CAM_WARN: CAM-ISP: cam_vfe_init_soc_resources: 107 option cl=
k get failed
[    0.930272] CAM_INFO: CAM-ISP: cam_vfe_reset: 390 calling RESET on vfe 2
[    0.930354] CAM_INFO: CAM-ISP: cam_vfe_reset: 390 calling RESET on vfe 2
[    0.931648] CAM_INFO: CAM-ISP: cam_isp_dev_probe: 148 Camera ISP probe c=
omplete
[    0.932770] CAM_INFO: CAM: cam_res_mgr_probe: 681 Disable shared gpio su=
pport.
[    0.933390] execprog: worker started
[    0.933392] execprog: waiting for /dev/socket/property_service
[    0.934659] CAM_INFO: CAM-ACTUATOR: cam_actuator_parse_dt: 58 No GPIO fo=
und
[    0.934675] CAM_INFO: CAM-ACTUATOR: cam_actuator_parse_dt: 58 No GPIO fo=
und
[    0.939604] CAM_ERR: CAM-SMMU: cam_smmu_create_add_handle_in_table: 608 =
Error: cam-secure already got handle 0x42562
[    0.941498] CAM_INFO: CAM-JPEG: cam_jpeg_dev_probe: 146 Camera JPEG prob=
e complete
[    0.947539] SMB2: smb2_chg_config_init: PMI8998 Revision=3D0x2
[    0.947561] SMB2: smb2_parse_dt: T1:-22, T2:-22, T3:-22, fcc1:-22, fcc1:=
-22, cut1:-22, cut2:-22,full:-22
[    0.947566] SMB2: smb2_parse_dt: OTG_ICL:enable:1,CapThr:15,LowThr:10000=
00,NorThr:1500000
[    0.947567] SMB2: smb2_parse_dt: q1:-22,q2:-22,q3:-22,NORMAL_CUTOFF:-22,=
warm:-22,FULL=3D-22
[    0.947572] SMB2: smb2_parse_dt: T0=3D-30, T1=3D0, T2=3D50, T3=3D120, T4=
=3D160, T5=3D450, T6=3D530
[    0.947573] SMB2: smb2_parse_dt: BATT_TEMP_LITTLE_COLD=3D275, 3975, 3700
[    0.947574] SMB2: smb2_parse_dt: BATT_TEMP_COOL=3D425, 4400, 4150
[    0.947574] SMB2: smb2_parse_dt: BATT_TEMP_LITTLE_COOL=3D725, 4400, 4270
[    0.947575] SMB2: smb2_parse_dt: BATT_TEMP_PRE_NORMAL=3D1375, 4400, 4270
[    0.947576] SMB2: smb2_parse_dt: BATT_TEMP_NORMAL=3D1950, 4400, 4270
[    0.947576] SMB2: smb2_parse_dt: BATT_TEMP_WARM=3D750, 4080, 3980
[    0.947577] SMB2: smb2_parse_dt: cutoff_volt_with_charger=3D3250, disabl=
e-pd=3D1
[    0.947580] SMB2: smb2_parse_dt: sw_iterm_ma=3D264,check_batt_full_by_sw=
=3D1
[    0.947665] SMBLIB: op_set_collapse_fet: USBIN_5V_AICL_THRESHOLD_CFG_REG=
(0x1381)=3D0x3
[    0.947687] SMBLIB: op_set_collapse_fet: USBIN_CONT_AICL_THRESHOLD_CFG_R=
EG(0x1384)=3D0x3
[    0.947742] SMBLIB: op_set_collapse_fet: USBIN_AICL_OPTIONS_CFG_REG(0x13=
80)=3D0xc7
[    0.947782] SMBLIB: op_set_collapse_fet: USBIN_LOAD_CFG_REG(0x1365)=3D0x=
f7
[    0.948111] SMBLIB: op_battery_temp_region_set: set temp_region=3D5
[    0.948184] register_client_adhoc:find path.src 1 dest 731
[    0.948400] register_client_adhoc:Client handle 35 dash_clk_vote
[    0.948808] actuator_regulator: Failed to create debugfs directory
[    0.948901] actuator_regulator: Failed to create debugfs directory
[    0.948961] SMB2: smb2_init_hw: vbat_max=3D4365000, ibat_max=3D500000, i=
usb_max=3D1800000
[    0.949129] SMBLIB: smblib_set_dc_suspend: 0
[    0.949180] SMBLIB: smblib_dc_icl_vote_callback: dc icl set 1200000
[    0.949345] SMBLIB: smblib_chg_disable_vote_callback: set chg_disable=3D0
[    0.950233] SMBLIB: get_prop_fast_adapter_update: no fast_charger regist=
er found
[    0.950239] SMBLIB: get_prop_fast_chg_started: no fast_charger register =
found
[    0.950514] SMBLIB: smblib_get_apsd_result: APSD_DTC_STATUS_DONE_BIT is 0
[    0.950593] SMBLIB: smblib_usb_plugin_locked: V  fail rc=3D-517
[    0.950597] SMBLIB: smblib_usb_plugin_locked: IRQ: detached
[    0.950602] SMBLIB: get_prop_fast_adapter_update: no fast_charger regist=
er found
[    0.950605] SMBLIB: get_prop_fast_chg_started: no fast_charger register =
found
[    0.950638] SMBLIB: get_prop_fast_adapter_update: no fast_charger regist=
er found
[    0.950742] SMBLIB: smblib_get_apsd_result: APSD_DTC_STATUS_DONE_BIT is 0
[    0.950798] SMBLIB: get_prop_fast_chg_started: no fast_charger register =
found
[    0.950812] SMBLIB: smblib_handle_usb_source_change: APSD_STATUS=3D0x00
[    0.950826] SMBLIB: smblib_get_apsd_result: APSD_DTC_STATUS_DONE_BIT is 0
[    0.950925] SMBLIB: smblib_set_icl_current: icl_ua=3D25000
[    0.950928] SMBLIB: smblib_set_usb_suspend: suspend=3D1
[    0.950960] SMBLIB: smblib_set_icl_current: icl_ua=3D2147483647
[    0.951002] SMBLIB: smblib_set_usb_suspend: suspend=3D0
[    0.951204] SMBLIB: smblib_get_apsd_result: APSD_DTC_STATUS_DONE_BIT is 0
[    0.951288] SMBLIB: get_property_from_fg: no bms psy found
[    0.951294] SMBLIB: get_prop_batt_capacity: Couldn't get capacity rc=3D-=
22
[    0.951299] SMBLIB: get_prop_fast_adapter_update: no fast_charger regist=
er found
[    0.951302] SMBLIB: get_prop_fast_chg_started: no fast_charger register =
found
[    0.951346] SMBLIB: get_property_from_fg: no bms psy found
[    0.951351] SMBLIB: get_prop_batt_capacity: Couldn't get capacity rc=3D-=
22
[    0.951354] SMBLIB: get_prop_fast_adapter_update: no fast_charger regist=
er found
[    0.951358] SMBLIB: get_prop_fast_chg_started: no fast_charger register =
found
[    0.951451] SMBLIB: op_get_fastchg_ing: no fast_charger register found
[    0.951615] SMBLIB: get_property_from_fg: no bms psy found
[    0.951619] SMBLIB: get_prop_batt_capacity: Couldn't get capacity rc=3D-=
22
[    0.951622] SMBLIB: get_prop_fast_adapter_update: no fast_charger regist=
er found
[    0.951626] SMBLIB: get_prop_fast_chg_started: no fast_charger register =
found
[    0.951665] SMBLIB: get_property_from_fg: no bms psy found
[    0.951668] SMBLIB: get_prop_batt_capacity: Couldn't get capacity rc=3D-=
22
[    0.951671] SMBLIB: get_prop_fast_adapter_update: no fast_charger regist=
er found
[    0.951676] SMBLIB: get_prop_fast_chg_started: no fast_charger register =
found
[    0.951762] SMBLIB: op_get_fastchg_ing: no fast_charger register found
[    0.958919] SMBLIB: smblib_set_icl_current: icl_ua=3D25000
[    0.958921] SMBLIB: smblib_set_usb_suspend: suspend=3D1
[    0.958953] SMBLIB: smblib_set_icl_current: icl_ua=3D2147483647
[    0.958976] SMBLIB: smblib_set_usb_suspend: suspend=3D0
[    0.959121] SMB2: smb2_probe: QPNP SMB2 probed successfully usb:present=
=3D0 type=3D0 batt:present =3D 1 health =3D 1 charge =3D 1
[    0.959715] BQ: bq27541_parse_dt: di->is_mcl_verion=3D0
[    0.960330] SMBLIB: get_property_from_fg: no bms psy found
[    0.960337] SMBLIB: get_prop_batt_capacity: Couldn't get capacity rc=3D-=
22
[    0.960341] SMBLIB: get_prop_fast_adapter_update: no fast_charger regist=
er found
[    0.960345] SMBLIB: get_prop_fast_chg_started: no fast_charger register =
found
[    0.960399] SMBLIB: get_property_from_fg: no bms psy found
[    0.960403] SMBLIB: get_prop_batt_capacity: Couldn't get capacity rc=3D-=
22
[    0.960407] SMBLIB: get_prop_fast_adapter_update: no fast_charger regist=
er found
[    0.960410] SMBLIB: get_prop_fast_chg_started: no fast_charger register =
found
[    0.960506] SMBLIB: op_get_fastchg_ing: no fast_charger register found
[    0.960678] BQ: bq27541_battery_probe: probe success battery exist=20
[    0.961017] FASTCHG: dash_probe: dash_probe
[    0.963384] FASTCHG: check_n76e_support: n76e not exist
[    0.963386] FASTCHG: check_enhance_support: enhance dash not exist
[    0.963389] FASTCHG: dash_probe: dash_probe success
[    0.963409] dash_adapter_init success
[    0.970300] SMBLIB: smblib_get_apsd_result: APSD_DTC_STATUS_DONE_BIT is 0
[    0.978756] bcl_peripheral:bcl_read_soc battery percentage read error:-61
[    0.978769] thermal thermal_zone63: failed to read out thermal zone (-61)
[    0.978775] bcl_peripheral:bcl_read_soc battery percentage read error:-61
[    0.978779] thermal thermal_zone63: failed to read out thermal zone (-61)
[    0.978808] bcl_peripheral:bcl_read_soc battery percentage read error:-61
[    0.980379] 17d41000.qcom,cpucc:qcom,limits-dcvs@0 supply isens_vref not=
 found, using dummy regulator
[    0.980422] msm_lmh_dcvs:limits_isens_vref_ldo_init Regulator:isens_vref=
 settings read error:-22
[    0.991028] bcl_peripheral:bcl_read_soc battery percentage read error:-61
[    0.991040] thermal thermal_zone63: failed to read out thermal zone (-61)
[    0.994462] bcl_peripheral:bcl_read_soc battery percentage read error:-61
[    0.994469] thermal thermal_zone63: failed to read out thermal zone (-61)
[    1.007907] device-mapper: uevent: version 1.0.3
[    1.008028] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised:=
 dm-devel@redhat.com
[    1.008174] device-mapper: req-crypt: dm-req-crypt successfully initaliz=
ed.\x0a
[    1.008503] bt_power_populate_dt_pinfo: bt-reset-gpio not provided in de=
vice tree
[    1.008527] bt_dt_parse_vreg_info: qca,bt-chip-pwd: is not provided in d=
evice tree
[    1.008530] bt_dt_parse_clk_info: clocks is not provided in device tree
[    1.008534] bt_power_populate_dt_pinfo: clock not provided in device tree
[    1.008646] CHRDEV "bt" major number 232 goes below the dynamic allocati=
on range
[    1.010138] haptics: qpnp_haptics_probe: qpnp_haptics_probe done
[    1.010458] usbcore: registered new interface driver usbhid
[    1.010460] usbhid: USB HID core driver
[    1.010547] ashmem: initialized
[    1.010554] CHRDEV "qcwlanstate" major number 231 goes below the dynamic=
 allocation range
[    1.010585] wlan_hdd_state wlan major(231) initialized
[    1.010590] ipa_ut ipa_ut_module_init:1044 Loading IPA test module...
[    1.010704] qpnp_coincell_charger_show_state: enabled=3DY, voltage=3D320=
0 mV, resistance=3D800 ohm
[    1.011316] bimc-bwmon 1436400.qcom,cpu-bwmon: BW HWmon governor registe=
red.
[    1.011348] bimc-bwmon 114a000.qcom,llcc-bwmon: BW HWmon governor regist=
ered.
[    1.011686] arm-memlat-mon soc:qcom,cpu0-memlat-mon: Memory Latency gove=
rnor registered.
[    1.011710] arm-memlat-mon soc:qcom,cpu4-memlat-mon: Memory Latency gove=
rnor registered.
[    1.011732] arm-memlat-mon soc:qcom,cpu0-l3lat-mon: Memory Latency gover=
nor registered.
[    1.011750] arm-memlat-mon soc:qcom,cpu4-l3lat-mon: Memory Latency gover=
nor registered.
[    1.011768] arm-memlat-mon soc:qcom,devfreq-compute: Compute governor re=
gistered.
[    1.012263] register_client_adhoc:find path.src 1 dest 770
[    1.012422] register_client_adhoc:Client handle 36 soc:qcom,cpubw
[    1.012901] register_client_adhoc:find path.src 129 dest 512
[    1.012938] register_client_adhoc:Client handle 37 soc:qcom,llccbw
[    1.014354] register_client_adhoc:find path.src 1 dest 512
[    1.014465] register_client_adhoc:Client handle 38 soc:qcom,memlat-cpu0
[    1.014646] register_client_adhoc:find path.src 1 dest 512
[    1.014758] register_client_adhoc:Client handle 39 soc:qcom,memlat-cpu4
[    1.014942] register_client_adhoc:find path.src 139 dest 627
[    1.015017] register_client_adhoc:Client handle 40 soc:qcom,snoc_cnoc_ke=
epalive
[    1.015137] register_client_adhoc:find path.src 1 dest 512
[    1.015244] register_client_adhoc:Client handle 41 soc:qcom,mincpubw
[    1.015495] register_client_adhoc:find path.src 26 dest 512
[    1.015567] register_client_adhoc:Client handle 42 soc:qcom,gpubw
[    1.016862] extcon_data->key3_gpio=3D126
[    1.016865] extcon_data->key2_gpio=3D52
[    1.016867] extcon_data->key1_gpio=3D24
[    1.017616] CHRDEV "esoc" major number 230 goes below the dynamic alloca=
tion range
[    1.017862] CHRDEV "sensors" major number 229 goes below the dynamic all=
ocation range
[    1.017992] usbcore: registered new interface driver snd-usb-audio
[    1.026355] msm-cdc-pinctrl soc:msm_cdc_pinctrl@49: msm_cdc_pinctrl_prob=
e: Cannot get cdc gpio pinctrl:-19
[    1.026871] ****** max98927_i2c_probe id.name =3Dmax98927L id.driver_dat=
a=3D 0=20
[    1.026875] max98927_reset:69------
[    1.050330] max98927 device version 0x42
[    1.059472] ****** max98927_i2c_probe snd_soc_register_codec id =3D0
[    1.059474] max98927 register codec ok.
[    1.059523] tfa98xx_i2c_init(): TFA98XX driver version v6.5.2
[    1.059564] fsa4480 driver fsa4480_i2c_init
[    1.060086] CHRDEV "avtimer" major number 228 goes below the dynamic all=
ocation range
[    1.060626] apr_probe: Unable to create ipc log context
[    1.060785] CHRDEV "wcd-dsp-glink" major number 227 goes below the dynam=
ic allocation range
[    1.061128] GACT probability NOT on
[    1.061137] Mirror/redirect action on
[    1.061142] u32 classifier
[    1.061143] Actions configured
[    1.061146] Netfilter messages via NETLINK v0.30.
[    1.061226] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[    1.061275] ctnetlink v0.93: registering with nfnetlink.
[    1.061414] xt_time: kernel timezone is -0000
[    1.061438] wireguard: WireGuard 0.0.20190227 loaded. See www.wireguard.=
com for information.
[    1.061439] wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason=
@zx2c4.com>. All Rights Reserved.
[    1.061467] IPv4 over IPsec tunneling driver
[    1.061606] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.061674] arp_tables: arp_tables: (C) 2002 David S. Miller
[    1.061687] Initializing XFRM netlink socket
[    1.061756] NET: Registered protocol family 10
[    1.062095] mip6: Mobile IPv6
[    1.062101] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    1.062263] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    1.062445] NET: Registered protocol family 17
[    1.062451] NET: Registered protocol family 15
[    1.062458] Ebtables v2.0 registered
[    1.062515] l2tp_core: L2TP core driver, V2.0
[    1.062518] l2tp_ppp: PPPoL2TP kernel driver, V2.0
[    1.062519] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[    1.062524] l2tp_netlink: L2TP netlink interface
[    1.062533] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[    1.062534] l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
[    1.062748] NET: Registered protocol family 27
[    1.062749] IPC_RTR: ipc_router_create_log_ctx: Unable to create IPC log=
ging for [local_IPCRTR]
[    1.063228] actuator_regulator: Failed to create debugfs directory
[    1.065862] minidump-id not found for adsp
[    1.065981] subsys-pil-tz 17300000.qcom,lpass: for adsp segments only wi=
ll be dumped.
[    1.066249] minidump-id not found for slpi
[    1.066335] subsys-pil-tz 5c00000.qcom,ssc: for slpi segments only will =
be dumped.
[    1.066504] minidump-id not found for cdsp
[    1.066588] subsys-pil-tz 8300000.qcom,turing: for cdsp segments only wi=
ll be dumped.
[    1.066808] pil-q6v5-mss 4080000.qcom,mss: No pas_id found.
[    1.066916] platform 4080000.qcom,mss:qcom,mba-mem@0: assigned reserved =
memory node mba_region@0x96500000
[    1.067042] pil-q6v5-mss 4080000.qcom,mss: for modem segments only will =
be dumped.
[    1.067055] pil-q6v5-mss 4080000.qcom,mss: for md_modem segments only wi=
ll be dumped.
[    1.067923] Force USB running as High speed
[    1.068634] dwc3 a600000.dwc3: Error getting ipc_log_ctxt
[    1.068728] register_client_adhoc:find path.src 61 dest 512
[    1.068914] register_client_adhoc:find path.src 61 dest 676
[    1.069018] register_client_adhoc:find path.src 1 dest 583
[    1.069130] register_client_adhoc:Client handle 43 usb0
[    1.069215] Invalid index Defaulting curr to 0
[    1.069415] msm-dwc3 a600000.ssusb: Not attached
[    1.070556] FG: fg_parse_dt: use_external_fg=3D1
[    1.078277] FG: fg_gen3_probe: battery SOC:50 voltage: 4199696uV temp: 3=
10
[    1.078854] qcom,fg-gen3 c440000.qcom,spmi:qcom,pmi8998@2:qpnp,fg: therm=
al_zone_of_sensor_register() failed rc:-19
[    1.083376] FG: fg_psy_get_property: unsupported property 24
[    1.083410] SMBLIB: load_data: stored_soc[0xb8], shutdown_soc[92]
[    1.085370] FG: fg_psy_get_property: unsupported property 1
[    1.200076] synaptics,s3320: after on cpu [0]
[    1.200082] synaptics,s3320: synaptics_ts_probe  is called
[    1.200102] synaptics,s3320: synaptics_parse_dts ts->support_hw_poweroff=
 =3D1
[    1.200109] synaptics,s3320: synaptics,tx-rx-num is 15 30=20
[    1.200114] synaptics,s3320: synaptic:ts->irq_gpio:125 irq_flags:8200 ma=
x_num 10
[    1.200151] synaptics,s3320: synaptics_parse_dts: avdd current =3D 20000
[    1.200233] synaptics,s3320: synaptics_parse_dts:avdd_vmin=3D3008000,avd=
d_vmax=3D3008000
[    1.200343] 3-0020 supply vcc_i2c_1v8 not found, using dummy regulator
[    1.200379] synaptics,s3320: synaptics_parse_dts: Failed to get regulato=
r vdd current
[    1.200384] synaptics,s3320: synaptics_parse_dts: Failed to get regulato=
r vdd voltage
[    1.237020] thermal thermal_zone64: failed to read out thermal zone (-61)
[    1.238057] register_client_adhoc:find path.src 61 dest 512
[    1.238209] register_client_adhoc:find path.src 61 dest 676
[    1.238308] register_client_adhoc:find path.src 1 dest 583
[    1.238413] register_client_adhoc:Client handle 43 usb0
[    1.238805] Registered cp15_barrier emulation handler
[    1.238830] Registered setend emulation handler
[    1.238843] core_ctl: Creating CPU group 0
[    1.238845] core_ctl: Init CPU0 state
[    1.238845] core_ctl: Init CPU1 state
[    1.238846] core_ctl: Init CPU2 state
[    1.238847] core_ctl: Init CPU3 state
[    1.238940] core_ctl: Creating CPU group 4
[    1.238941] core_ctl: Init CPU4 state
[    1.238941] core_ctl: Init CPU5 state
[    1.238942] core_ctl: Init CPU6 state
[    1.238942] core_ctl: Init CPU7 state
[    1.239183] registered taskstats version 1
[    1.241502] msm-dwc3 a600000.ssusb: DWC3 exited from low power mode
[    1.242780] msm-dwc3 a600000.ssusb: DWC3 in low power mode
[    1.258072] spss_utils [spss_init]: spss-utils driver Ver 2.0 30-Mar-201=
7.
[    1.260659] iommu: Adding device soc:qcom,msm_fastrpc:qcom,msm_fastrpc_c=
ompute_cb1 to group 34
[    1.261095] iommu: Adding device soc:qcom,msm_fastrpc:qcom,msm_fastrpc_c=
ompute_cb2 to group 35
[    1.261350] iommu: Adding device soc:qcom,msm_fastrpc:qcom,msm_fastrpc_c=
ompute_cb3 to group 36
[    1.261598] iommu: Adding device soc:qcom,msm_fastrpc:qcom,msm_fastrpc_c=
ompute_cb4 to group 37
[    1.261845] iommu: Adding device soc:qcom,msm_fastrpc:qcom,msm_fastrpc_c=
ompute_cb5 to group 38
[    1.262099] iommu: Adding device soc:qcom,msm_fastrpc:qcom,msm_fastrpc_c=
ompute_cb6 to group 39
[    1.262347] iommu: Adding device soc:qcom,msm_fastrpc:qcom,msm_fastrpc_c=
ompute_cb7 to group 40
[    1.262595] iommu: Adding device soc:qcom,msm_fastrpc:qcom,msm_fastrpc_c=
ompute_cb8 to group 41
[    1.262842] iommu: Adding device soc:qcom,msm_fastrpc:qcom,msm_fastrpc_c=
ompute_cb9 to group 42
[    1.263537] iommu: Adding device soc:qcom,msm_fastrpc:qcom,msm_fastrpc_c=
ompute_cb10 to group 43
[    1.263613] fastrpc: probe of soc:qcom,msm_fastrpc:qcom,msm_fastrpc_comp=
ute_cb10 failed with error -1
[    1.263637] iommu: Adding device soc:qcom,msm_fastrpc:qcom,msm_fastrpc_c=
ompute_cb11 to group 44
[    1.263885] iommu: Adding device soc:qcom,msm_fastrpc:qcom,msm_fastrpc_c=
ompute_cb12 to group 45
[    1.264545] fastrpc: probe of soc:qcom,msm_fastrpc:qcom,msm_fastrpc_comp=
ute_cb10 failed with error -1
[    1.264554] CHRDEV "adsprpc-smd" major number 225 goes below the dynamic=
 allocation range
[    1.265190] ngd_msm_ctrl 171c0000.slim: error creating ipc_logging conte=
xt
[    1.265245] iommu: Adding device 171c0000.slim:qcom,iommu_slim_ctrl_cb t=
o group 46
[    1.266073] ngd_msm_ctrl 17240000.slim: error creating ipc_logging conte=
xt
[    1.266165] iommu: Adding device 17240000.slim:qcom,iommu_slim_ctrl_cb t=
o group 47
[    1.267707] input: gpio-keys as /devices/platform/soc/soc:gpio_keys/inpu=
t/input2
[    1.267837] qcom,qpnp-rtc c440000.qcom,spmi:qcom,pm8998@0:qcom,pm8998_rt=
c: setting system clock to 1970-01-03 10:12:14 UTC (209534)
[    1.268404] lpm_levels_of: idx 1 7100
[    1.268406] lpm_levels_of: idx 2 5989
[    1.268407] lpm_levels_of: idx 2 3933
[    1.268442] lpm_levels_of: idx 1 1744
[    1.268443] lpm_levels_of: idx 2 1000
[    1.268444] lpm_levels_of: Residency < 0 for LPM
[    1.268446] lpm_levels_of: idx 2 1000
[    1.268473] lpm_levels: register_cluster_lpm_stats()
[    1.268531] lpm_levels: register_cluster_lpm_stats()
[    1.270942] rmnet_ipa3 started initialization
[    1.271041] RNDIS_IPA module is loaded.
[    1.272396] msm_bus_late_init: Remove handoff bw requests
[    1.272999] actuator_regulator: Failed to create debugfs directory
[    1.273027] ufs_card_gdsc: disabling
[    1.273079] actuator_regulator: disabling
[    1.273080] actuator_regulator: disabling
[    1.273087] ext_5v_boost: disabling
[    1.273089] regulator_proxy_consumer_remove_all: removing regulator prox=
y consumer requests
[    1.273190] ALSA device list:
[    1.273191] No soundcards found.
[    1.273214] Warning: unable to open an initial console.
[    1.273318] Freeing unused kernel memory: 576K
[    1.283498] EXT4-fs (sda14): mounted filesystem without journal. Opts: (=
null)
[    1.286164] EXT4-fs (sde44): mounted filesystem without journal. Opts: (=
null)
[    1.344345] synaptics,s3320: F12_2D_QUERY_BASE =3D 4a \x0a \x09\x09\x09F=
12_2D_CMD_BASE  =3D 0 \x0a\x09\x09\x09F12_2D_CTRL_BASE\x09=3D 13 \x0a\x09\x=
09\x09F12_2D_DATA_BASE\x09=3D 8 \x0a\x09\x09\x09
[    1.344952] synaptics,s3320: F34_FLASH_QUERY_BASE =3D 23 \x0a\x09\x09\x0=
9F34_FLASH_CMD_BASE\x09=3D 0 \x0a\x09\x09\x09F34_FLASH_CTRL_BASE\x09=3D c \=
x0a\x09\x09\x09F34_FLASH_DATA_BASE\x09=3D 0 \x0a\x09\x09\x09
[    1.345939] synaptics,s3320: F54_QUERY_BASE =3D 43 \x0a\x09\x09\x09F54_C=
MD_BASE  =3D 42 \x0a\x09\x09\x09F54_CTRL_BASE\x09=3D e \x0a\x09\x09\x09F54_=
DATA_BASE\x09=3D 0 \x0a\x09\x09\x09
[    1.346368] synaptics,s3320: before fw update bootloader_mode[0x0]
[    1.347902] synaptics,s3320: CURRENT_FIRMWARE_ID =3D 0x4543313031303134
[    1.352823] synaptics,s3320: max_x =3D 1080,max_y =3D 2280; max_x_ic =3D=
 1079,max_y_ic =3D 2279
[    1.353851] synaptics,s3320: synaptics_soft_reset !!!
[    1.440512] of_batterydata_get_best_profile: OP_3300mah found
[    1.457160] synaptics,s3320: synaptics_tpedge_limitfunc limit_enable =3D=
1,mode:0x67 !
[    1.457630] input: synaptics,s3320 as /devices/platform/soc/a90000.i2c/i=
2c-3/3-0020/input/input3
[    1.510070] synaptics,s3320: synaptic:ts->irq is 377
[    1.520966] synaptics,s3320: synaptics_ts_probe 3203: normal end
[    1.830782] init: init first stage started!
[    1.830863] init: Using Android DT directory /proc/device-tree/firmware/=
android/
[    1.831252] init: [libfs_mgr]fs_mgr_read_fstab_default(): failed to find=
 device default fstab
[    1.893549] SMBLIB: smblib_get_apsd_result: APSD_DTC_STATUS_DONE_BIT is 0
[    1.947431] FG: fg_psy_get_property: unsupported property 1
[    1.971195] EXT4-fs (sde44): mounted filesystem without journal. Opts: b=
arrier=3D1,discard
[    1.971232] init: [libfs_mgr]__mount(source=3D/dev/block/platform/soc/1d=
84000.ufshc/by-name/vendor_b,target=3D/vendor,type=3Dext4)=3D0: Success
[    1.971294] init: Skipped setting INIT_AVB_VERSION (not in recovery mode)
[    1.971347] init: Loading SELinux policy
[    1.971380] selinux: SELinux: op_load_policy default\x0a
[    1.973543] SELinux: 65536 avtab hash slots, 268543 rules.
[    1.981695] BQ: bq27541_hw_config: DEVICE_BQ27411
[    1.983314] BQ: check_df_version: DEVICE DF:177
[    1.983315] BQ: bq27541_hw_config: DEVICE_TYPE is 0x421, FIRMWARE_VERSIO=
N is 0x109
[    1.983316] BQ: bq27541_hw_config: Complete bq27541 configuration 0x208A
[    2.000397] SELinux: 65536 avtab hash slots, 268543 rules.
[    2.000407] SELinux:  1 users, 4 roles, 2221 types, 0 bools, 1 sens, 102=
4 cats
[    2.000410] SELinux:  93 classes, 268543 rules
[    2.001401] SELinux:  Completing initialization.
[    2.001402] SELinux:  Setting up existing superblocks.
[    2.034987] selinux: SELinux: Loaded policy from /sepolicy\x0a
[    2.040420] selinux: SELinux: Loaded file_contexts\x0a
[    2.041716] init: init second stage started!
[    2.051181] init: Using Android DT directory /proc/device-tree/firmware/=
android/
[    2.053302] selinux: SELinux: Loaded file_contexts\x0a
[    2.053308] init: Running restorecon...
[    2.056475] init: waitid failed: No child processes
[    2.058039] init: Couldn't load property file '/odm/default.prop': open(=
) failed: No such file or directory: No such file or directory
[    2.059257] selinux: avc:  denied  { set } for  scontext=3Du:r:vendor_in=
it:s0 tcontext=3Du:object_r:exported_secure_prop:s0 tclass=3Dproperty_servi=
ce permissive=3D0\x0a
[    2.059265] init: Unable to set property 'ro.adb.secure' to '1' in prope=
rty file '/vendor/default.prop': SELinux permission check failed
[    2.059500] init: Created socket '/dev/socket/property_service', mode 66=
6, user 0, group 0
[    2.059932] init: Forked subcontext for 'u:r:vendor_init:s0' with pid 498
[    2.070062] execprog: saving binary to userspace
[    2.097213] ueventd: ueventd started!
[    2.101499] selinux: SELinux: Loaded file_contexts\x0a
[    2.101530] ueventd: Parsing file /ueventd.rc...
[    2.101978] ueventd: Parsing file /vendor/ueventd.rc...
[    2.104115] ueventd: Parsing file /odm/ueventd.rc...
[    2.104134] ueventd: Unable to read config file '/odm/ueventd.rc': open(=
) failed: No such file or directory
[    2.104192] ueventd: Parsing file /ueventd.qcom.rc...
[    2.104208] ueventd: Unable to read config file '/ueventd.qcom.rc': open=
() failed: No such file or directory
[    2.124930] execprog: execution finished
[    2.176982] SMBLIB: smblib_get_apsd_result: APSD_DTC_STATUS_DONE_BIT is 0
[    2.193888] killall:=20
[    2.193890] msm_irqbalance
[    2.193892] : No such process
[    2.193894]=20
[    2.230789] FG: fg_psy_get_property: unsupported property 1
[    3.429584] ueventd: Coldboot took 1.324 seconds
[    3.502385] keychord: using input dev qpnp_pon for fevent
[    3.502388] keychord: using input dev gf_input for fevent
[    3.502390] keychord: using input dev gpio-keys for fevent
[    3.512252] Registered swp emulation handler
[    3.576156] init: wait for '/dev/block/platform/soc/1d84000.ufshc' took =
0ms
[    3.577026] init: mount_tempfs=3D0
[    3.579989] EXT4-fs (sda17): Ignoring removed nomblk_io_submit option
[    3.629782] EXT4-fs (sda17): recovery complete
[    3.630395] EXT4-fs (sda17): mounted filesystem with ordered data mode. =
Opts: errors=3Dremount-ro,nomblk_io_submit
[    4.169449] e2fsck: e2fsck 1.43.3 (04-Sep-2016)\x0a
[    4.169461] e2fsck: Pass 1: Checking inodes, blocks, and sizes\x0a
[    4.169463] e2fsck: Pass 2: Checking directory structure\x0a
[    4.169464] e2fsck: Pass 3: Checking directory connectivity\x0a
[    4.169466] e2fsck: Pass 4: Checking reference counts\x0a
[    4.169467] e2fsck: Pass 5: Checking group summary information\x0a
[    4.169469] e2fsck: /dev/block/bootdevice/by-name/userdata: 28831/720896=
0 files (2.2% non-contiguous), 2098521/28835840 blocks\x0a
[    4.175554] EXT4-fs (sda17): mounted filesystem with ordered data mode. =
Opts: barrier=3D1,noauto_da_alloc,discard
[    4.179428] EXT4-fs (sde37): mounted filesystem with ordered data mode. =
Opts: barrier=3D1
[    4.181337] EXT4-fs (sda2): mounted filesystem with ordered data mode. O=
pts: barrier=3D1
[    4.187464] EXT4-fs (sde59): mounted filesystem with ordered data mode. =
Opts:=20
[    4.188970] EXT4-fs (sda7): mounted filesystem with ordered data mode. O=
pts: barrier=3D1
[    4.205280] logd.auditd: start
[    4.205286] logd.klogd: 4205269636
[    4.226209] binder: 542:542 ioctl 4018620d 7ff38182e0 returned -22
[    4.249984] QSEECOM: qseecom_register_listener: Service 8192 is register=
ed
[    4.250292] QSEECOM: qseecom_register_listener: Service 12288 is registe=
red
[    4.250598] QSEECOM: qseecom_register_listener: Service 16384 is registe=
red
[    4.252801] QSEECOM: qseecom_register_listener: Service 11 is registered
[    4.253082] QSEECOM: qseecom_register_listener: Service 10 is registered
[    4.254199] QSEECOM: qseecom_register_listener: Service 28672 is registe=
red
[    4.255131] QSEECOM: qseecom_register_listener: Service 36864 is registe=
red
[    4.255914] QSEECOM: qseecom_register_listener: Service 45056 is registe=
red
[    4.257105] QSEECOM: qseecom_register_listener: Service 4352 is register=
ed
[    4.337304] IPA smmu_info.s1_bypass_arr[AP]=3D1 smmu_info.fast_map=3D0
[    4.337508] IPA smmu_info.s1_bypass_arr[WLAN]=3D1 smmu_info.fast_map=3D0
[    4.337773] IPA smmu_info.s1_bypass_arr[UC]=3D1 smmu_info.fast_map=3D0
[    4.338286] ipa ipa3_uc_state_check:284 uC interface not initialized
[    4.340945] ueventd: firmware: loading 'ipa_fws.mdt' for '/devices/platf=
orm/soc/soc:qcom,ipa_fws/firmware/ipa_fws.mdt'
[    4.344141] subsys-pil-tz soc:qcom,ipa_fws: ipa_fws: loading from 0x0000=
00008c400000 to 0x000000008c405000
[    4.377905] subsys-pil-tz soc:qcom,ipa_fws: ipa_fws: Brought out of reset
[    4.377951] ipa ipa3_uc_state_check:284 uC interface not initialized
[    4.378254] IPA FW loaded successfully
[    4.378534] ipa ipa3_uc_state_check:284 uC interface not initialized
[    4.382538] vdc: Waited 20ms for vold
[    4.383505] ipahal ipahal_init:1577 failed to create IPA regdump log, co=
ntinue...
[    4.383587] CHRDEV "ipaNatTable" major number 224 goes below the dynamic=
 allocation range
[    4.383638] ipa ipa3_set_resorce_groups_min_max_limits:4968 skip configu=
ring ipa_rx_hps_clients from HLOS
[    4.383799] gsi soc:qcom,msm_gsi: gsi_register_device:839 GSI irq is wak=
e enabled 106
[    4.386122] CHRDEV "ipa_tethering_bridge" major number 223 goes below th=
e dynamic allocation range
[    4.386361] rmnet_ipa3 started initialization
[    4.386364] IPA SSR support =3D True
[    4.386365] IPA ipa-loaduC =3D True
[    4.386366] IPA SG support =3D True
[    4.386367] IPA Napi Enable =3D True
[    4.386368] using default for wan-rx-desc-size =3D 256
[    4.386414] IPA driver initialization was successful.
[    4.387176] CHRDEV "wwan_ioctl" major number 222 goes below the dynamic =
allocation range
[    4.387511] rmnet_ipa completed initialization
[    4.405484] fscrypt: AES-256-CTS-CBC using implementation "cts(cbc-aes-c=
e)"
[    4.433280] ipa ipa3_uc_state_check:289 uC is not loaded
[    4.465532] vdc: Waited 0ms for vold
[    4.509124] init: oem_property_main
[    4.548400] logd: logdr: UID=3D0 GID=3D0 PID=3D608 n tail=3D0 logMask=3D=
19 pid=3D0 start=3D0ns timeout=3D0ns
[    4.555867] logd: logdr: UID=3D0 GID=3D0 PID=3D611 b tail=3D0 logMask=3D=
19 pid=3D0 start=3D0ns timeout=3D0ns
[    4.565646] SELinux:  Context  is not valid (left unmapped).
[    4.574578] init: e4crypt_set_directory_policy ro.boot.qe =3D=20
[    4.574601] init: Setting policy on /data/fpc_images
[    4.575004] init: Found policy 7709e4b766230604 at /data/fpc_images whic=
h matches expected value
[    4.575806] init: e4crypt_set_directory_policy ro.boot.qe =3D=20
[    4.575818] init: Setting policy on /data/fpc
[    4.576203] init: Policy for /data/fpc set to 7709e4b766230604 modes 127=
/4
[    4.579721] init: Not setting policy on /data/media
[    4.584431] init: e4crypt_set_directory_policy ro.boot.qe =3D=20
[    4.584449] init: Setting policy on /data/connectivity
[    4.622915] update_verifier: Started with arg 1: nonencrypted
[    4.626552] update_verifier: Booting slot 1: isSlotMarkedSuccessful=3D1
[    4.626557] update_verifier: Leaving update_verifier.
[    4.868637] init: oem_property_main
[    4.870836] subsys-restart: __subsystem_get(): Changing subsys fw_name t=
o slpi
[    4.876350] logd.daemon: reinit
[    4.876633] subsys-pil-tz 17300000.qcom,lpass: adsp: loading from 0x0000=
00008c500000 to 0x000000008df00000
[    4.876737] subsys-pil-tz 8300000.qcom,turing: cdsp: loading from 0x0000=
000095d00000 to 0x0000000096500000
[    4.876884] subsys-pil-tz 5c00000.qcom,ssc: slpi: loading from 0x0000000=
096700000 to 0x0000000097880000
[    5.020903] subsys-pil-tz 8300000.qcom,turing: cdsp: Brought out of reset
[    5.030643] subsys-pil-tz 8300000.qcom,turing: Subsystem error monitorin=
g/handling services are up
[    5.037489] subsys-pil-tz 8300000.qcom,turing: cdsp: Power/Clock ready i=
nterrupt received
[    5.043218] IPC_RTR: ipc_router_create_log_ctx: Unable to create IPC log=
ging for [cdsp_IPCRTR]
[    5.053008] sysmon-qmi: sysmon_clnt_svc_arrive: Connection established b=
etween QMI handle and cdsp's SSCTL service
[    5.078033] dashd: dashd_main enterd
[    5.078042] dashd: run /sbin/dashd ENGINE START!
[    5.078070] FASTCHG: dash_dev_write: fw_ver_count=3D5746
[    5.078106] dashd: THREAD is created!
[    5.078812] dashd: type=3DUSB_PD, soc=3D92, temp=3D25, vbat=3D4000, ibat=
=3D0
[    5.086911] dashd: THREAD running
[    5.086933] dashd: dash read
[    5.114416] rmt_storage:INFO:check_support_using_libmdm: Modem subsystem=
 found on target!
[    5.116386] rmt_storage:INFO:main: Done with init now waiting for messag=
es!
[    5.134231] servloc: service_locator_svc_arrive: Connection established =
with the Service locator
[    5.134264] servloc: init_service_locator: Service locator initialized
[    5.140065] subsys-pil-tz 17300000.qcom,lpass: adsp: Brought out of reset
[    5.144362] subsys-pil-tz 17300000.qcom,lpass: Subsystem error monitorin=
g/handling services are up
[    5.145146] apr_tal_link_state_cb: edge[lpass] link state[0]
[    5.145389] IPC_RTR: ipc_router_create_log_ctx: Unable to create IPC log=
ging for [lpass_IPCRTR]
[    5.150708] sysmon-qmi: sysmon_clnt_svc_arrive: Connection established b=
etween QMI handle and adsp's SSCTL service
[    5.152081] subsys-pil-tz 17300000.qcom,lpass: adsp: Power/Clock ready i=
nterrupt received
[    5.153397] audio_notifer_reg_service: service PDR_ADSP is in use
[    5.155989] service-notifier: root_service_service_arrive: Connection es=
tablished between QMI handle and 74 service
[    5.168615] service-notifier: root_service_service_ind_cb: Indication re=
ceived from msm/adsp/audio_pd, state: 0x1fffffff, trans-id: 1
[    5.169470] smartpa dts config is max98927
[    5.169476] smartpa_present
[    5.173416] service-notifier: send_ind_ack: Indication ACKed for transid=
 1, service msm/adsp/audio_pd, instance 74!
[    5.194792] subsys-pil-tz 5c00000.qcom,ssc: slpi: Brought out of reset
[    5.196950] sps_register_bam_device : unable to create IPC Logging 0 for=
 bam 0x0000000017184000
[    5.196957] sps_register_bam_device : unable to create IPC Logging 1 for=
 bam 0x0000000017184000
[    5.196960] sps_register_bam_device : unable to create IPC Logging 2 for=
 bam 0x0000000017184000
[    5.196962] sps_register_bam_device : unable to create IPC Logging 3 for=
 bam 0x0000000017184000
[    5.196964] sps_register_bam_device : unable to create IPC Logging 4 for=
 bam 0x0000000017184000
[    5.197112] sps:BAM 0x0000000017184000 (va:0x0000000000000000) enabled: =
ver:0x19, number of pipes:23
[    5.197114] sps:BAM 0x0000000017184000 is registered.
[    5.210097] sps_register_bam_device : unable to create IPC Logging 0 for=
 bam 0x0000000017204000
[    5.210106] sps_register_bam_device : unable to create IPC Logging 1 for=
 bam 0x0000000017204000
[    5.210108] sps_register_bam_device : unable to create IPC Logging 2 for=
 bam 0x0000000017204000
[    5.210110] sps_register_bam_device : unable to create IPC Logging 3 for=
 bam 0x0000000017204000
[    5.210112] sps_register_bam_device : unable to create IPC Logging 4 for=
 bam 0x0000000017204000
[    5.210155] sps:BAM 0x0000000017204000 (va:0x0000000000000000) enabled: =
ver:0x19, number of pipes:13
[    5.210156] sps:BAM 0x0000000017204000 is registered.
[    5.224166] healthd: Unknown power supply type 'BMS'
[    5.224193] healthd: Unknown power supply type 'Main'
[    5.235076] subsys-pil-tz 5c00000.qcom,ssc: Subsystem error monitoring/h=
andling services are up
[    5.241992] subsys-pil-tz 5c00000.qcom,ssc: slpi: Power/Clock ready inte=
rrupt received
[    5.251779] IPC_RTR: ipc_router_create_log_ctx: Unable to create IPC log=
ging for [dsps_IPCRTR]
[    5.254723] healthd: battery l=3D92 v=3D4000 t=3D25.0 h=3D2 st=3D3 c=3D0=
 fc=3D2878000 cc=3D0 chg=3D
[    5.261509] healthd: Unknown power supply type 'BMS'
[    5.261540] healthd: Unknown power supply type 'Main'
[    5.267149] healthd: battery l=3D92 v=3D4000 t=3D25.0 h=3D2 st=3D3 c=3D0=
 fc=3D2878000 cc=3D0 chg=3D
[    5.280177] logd: logdr: UID=3D0 GID=3D0 PID=3D773 b tail=3D0 logMask=3D=
2 pid=3D0 start=3D0ns timeout=3D0ns
[    5.280390] logd: logdr: UID=3D0 GID=3D0 PID=3D775 b tail=3D0 logMask=3D=
80 pid=3D0 start=3D0ns timeout=3D0ns
[    5.280466] logd: logdr: UID=3D0 GID=3D0 PID=3D774 b tail=3D0 logMask=3D=
4 pid=3D0 start=3D0ns timeout=3D0ns
[    5.280559] logd: logdr: UID=3D0 GID=3D0 PID=3D772 b tail=3D0 logMask=3D=
19 pid=3D0 start=3D0ns timeout=3D0ns
[    5.296203] Mass Storage Function, version: 2009/09/11
[    5.296210] LUN: removable read only CD-ROM file: (no medium)
[    5.316976] sdm845-asoc-snd soc:qcom,msm-audio-apr:sound-tavil: msm_init=
_wsa_dev: Max WSA devices is 0 for this target?
[    5.317040] sdm845-asoc-snd soc:qcom,msm-audio-apr:sound-tavil: ASoC: pl=
atform /soc/qcom,msm-pcm-voice not registered
[    5.322620] slimbus sb-1: of_slim: invalid E-addr
[    5.323278] wcd-slim tavil-slim-pgd: Platform data from device tree
[    5.323786] wcd-slim tavil-slim-pgd: msm_cdc_dt_parse_vreg_info: cdc-vdd=
-buck: vol=3D[1800000 1800000]uV, curr=3D[650000]uA, ond 0
[    5.323913] wcd-slim tavil-slim-pgd: msm_cdc_dt_parse_vreg_info: cdc-buc=
k-sido: vol=3D[1800000 1800000]uV, curr=3D[250000]uA, ond 0
[    5.323983] wcd-slim tavil-slim-pgd: msm_cdc_dt_parse_vreg_info: cdc-vdd=
-tx-h: vol=3D[1800000 1800000]uV, curr=3D[25000]uA, ond 0
[    5.324043] wcd-slim tavil-slim-pgd: msm_cdc_dt_parse_vreg_info: cdc-vdd=
-rx-h: vol=3D[1800000 1800000]uV, curr=3D[25000]uA, ond 0
[    5.324103] wcd-slim tavil-slim-pgd: msm_cdc_dt_parse_vreg_info: cdc-vdd=
px-1: vol=3D[1800000 1800000]uV, curr=3D[10000]uA, ond 0
[    5.324179] wcd-slim tavil-slim-pgd: wcd9xxx_slim_probe: probing for wcd=
 type: 4, name: tavil-slim-pgd
[    5.326175] smartpa dts config is max98927
[    5.326182] smartpa_present
[    5.330350] file system registered
[    5.331361] CHRDEV "msm_usb_bridge" major number 221 goes below the dyna=
mic allocation range
[    5.332612] f_cdev_alloc: port_name:at_usb0 (0000000000000000) portno:(0)
[    5.333938] f_cdev_alloc: port_name:at_usb1 (0000000000000000) portno:(1)
[    5.334844] f_cdev_alloc: port_name:at_usb2 (0000000000000000) portno:(2)
[    5.347713] sysmon-qmi: sysmon_clnt_svc_arrive: Connection established b=
etween QMI handle and slpi's SSCTL service
[    5.352294] boot_mode:=20
[    5.365782] synaptics,s3320: start update ******* fw_name:tp/fw_synaptic=
s_17819.img,ts->manu_name:S3706B
[    5.365791] synaptics,s3320: enter version 17819 update mode
[    5.380412] slimbus:1 laddr:0xcf, EAPC:0x1:0x50
[    5.380628] wcd-slim tavil-slim-pgd: wcd9xxx_slim_device_up: slim device=
 up, dev_up =3D 1
[    5.380832] slimbus:1 laddr:0xce, EAPC:0x0:0x50
[    5.382932] wcd-slim tavil-slim-pgd: wcd934x_get_cdc_info: wcd9xxx chip =
id major 0x108, minor 0x1
[    5.382940] wcd9xxx_core_res_init: num_irqs =3D 32, num_irq_regs =3D 4
[    5.383054] synaptics,s3320: FW_ID:2827775--CONFIG_ID  FW_NAME:tp/fw_syn=
aptics_17819.img
[    5.391728] synaptics,s3320_firmware: fwu_start_reflash: Start of reflas=
h process
[    5.392354] synaptics,s3320_firmware: fwu_go_nogo: Device firmware ID =
=3D 2827775
[    5.392358] synaptics,s3320_firmware: fwu_go_nogo: Image firmware ID =3D=
 2827775
[    5.393493] synaptics,s3320_firmware: fwu_go_nogo: No need to do reflash
[    5.394537] synaptics,s3320_firmware: fwu_start_reflash: End of reflash =
process
[    5.444461] kgsl kgsl-3d0: loading /vendor/firmware_mnt/image/a630_sqe.f=
w failed with error -13
[    5.446160] kgsl kgsl-3d0: loading /vendor/firmware_mnt/image/a630_gmu.b=
in failed with error -13
[    5.448062] sdm845-asoc-snd soc:qcom,msm-audio-apr:sound-tavil: msm_init=
_wsa_dev: Max WSA devices is 0 for this target?
[    5.448124] sdm845-asoc-snd soc:qcom,msm-audio-apr:sound-tavil: ASoC: pl=
atform /soc/qcom,msm-pcm-voice not registered
[    5.449111] slimbus sb-3: of_slim: invalid E-addr
[    5.450642] 'opened /dev/sdsprpc-smd c 225 2'
[    5.451049] smartpa dts config is max98927
[    5.451053] smartpa_present
[    5.480892] QSEECOM: qseecom_load_app: App (soter64) does'nt exist, load=
ing apps for first time
[    5.509759] QSEECOM: qseecom_load_app: App with id 2 (soter64) now loaded
[    5.523781] subsys-pil-tz soc:qcom,kgsl-hyp: loading /vendor/firmware_mn=
t/image/a630_zap.mdt failed with error -13
[    5.526037] subsys-pil-tz soc:qcom,kgsl-hyp: a630_zap: loading from 0x00=
0000008c415000 to 0x000000008c416000
[    5.546231] sdm845-asoc-snd soc:qcom,msm-audio-apr:sound-tavil: msm_init=
_wsa_dev: Max WSA devices is 0 for this target?
[    5.546825] tavil_codec tavil_codec: tavil_soc_codec_probe()
[    5.550425] subsys-pil-tz soc:qcom,kgsl-hyp: loading /vendor/firmware_mn=
t/image/a630_zap.b02 failed with error -13
[    5.550752] .....wcd934x_edev probe success!
[    5.554689] subsys-pil-tz soc:qcom,kgsl-hyp: a630_zap: Brought out of re=
set
[    5.557178] wcd-dsp-mgr soc:qcom,wcd-dsp-mgr: for wdsp segments only wil=
l be dumped.
[    5.557426] wcd-dsp-mgr soc:qcom,wcd-dsp-mgr: bound tavil_codec (ops 0xf=
fffff80091d6b48)
[    5.557588] wcd-dsp-mgr soc:qcom,wcd-dsp-mgr: bound spi0.0 (ops 0xffffff=
80091dc688)
[    5.557591] wcd-dsp-mgr soc:qcom,wcd-dsp-mgr: bound soc:qcom,glink-spi-x=
prt-wdsp (ops 0xffffff800907f4e8)
[    5.560685] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no dapm matc=
h for TERT_MI2S_TX --> TERT_MI2S_TX --> MultiMedia17 Mixer
[    5.560692] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route TERT_MI2S_TX -> TERT_MI2S_TX -> MultiMedia17 Mixer
[    5.560697] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no dapm matc=
h for TERT_MI2S_TX --> TERT_MI2S_TX --> MultiMedia18 Mixer
[    5.560700] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route TERT_MI2S_TX -> TERT_MI2S_TX -> MultiMedia18 Mixer
[    5.560703] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no dapm matc=
h for TERT_MI2S_TX --> TERT_MI2S_TX --> MultiMedia19 Mixer
[    5.560706] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route TERT_MI2S_TX -> TERT_MI2S_TX -> MultiMedia19 Mixer
[    5.560720] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no dapm matc=
h for TERT_MI2S_TX --> TERT_MI2S_TX --> MultiMedia28 Mixer
[    5.560723] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route TERT_MI2S_TX -> TERT_MI2S_TX -> MultiMedia28 Mixer
[    5.560727] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no dapm matc=
h for TERT_MI2S_TX --> TERT_MI2S_TX --> MultiMedia29 Mixer
[    5.560729] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route TERT_MI2S_TX -> TERT_MI2S_TX -> MultiMedia29 Mixer
[    5.560750] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no dapm matc=
h for QUAT_MI2S_TX --> QUAT_MI2S_TX --> MultiMedia17 Mixer
[    5.560753] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route QUAT_MI2S_TX -> QUAT_MI2S_TX -> MultiMedia17 Mixer
[    5.560756] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no dapm matc=
h for QUAT_MI2S_TX --> QUAT_MI2S_TX --> MultiMedia19 Mixer
[    5.560759] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route QUAT_MI2S_TX -> QUAT_MI2S_TX -> MultiMedia19 Mixer
[    5.560772] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no dapm matc=
h for QUAT_MI2S_TX --> QUAT_MI2S_TX --> MultiMedia28 Mixer
[    5.560775] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route QUAT_MI2S_TX -> QUAT_MI2S_TX -> MultiMedia28 Mixer
[    5.560778] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no dapm matc=
h for QUAT_MI2S_TX --> QUAT_MI2S_TX --> MultiMedia29 Mixer
[    5.560781] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route QUAT_MI2S_TX -> QUAT_MI2S_TX -> MultiMedia29 Mixer
[    5.565182] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no sink widg=
et found for MM_UL28
[    5.565188] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route MultiMedia28 Mixer -> direct -> MM_UL28
[    5.565209] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no sink widg=
et found for MM_UL29
[    5.565211] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route MultiMedia29 Mixer -> direct -> MM_UL29
[    5.567276] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no sink widg=
et found for AUDIO_REF_EC_UL28 MUX
[    5.567279] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route PRI_MI2S_TX -> PRI_MI2S_TX -> AUDIO_REF_EC_UL28 MUX
[    5.567298] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no sink widg=
et found for AUDIO_REF_EC_UL28 MUX
[    5.567301] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route SEC_MI2S_TX -> SEC_MI2S_TX -> AUDIO_REF_EC_UL28 MUX
[    5.567319] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no sink widg=
et found for AUDIO_REF_EC_UL28 MUX
[    5.567321] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route TERT_MI2S_TX -> TERT_MI2S_TX -> AUDIO_REF_EC_UL28 MUX
[    5.567334] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no sink widg=
et found for AUDIO_REF_EC_UL28 MUX
[    5.567337] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route QUAT_MI2S_TX -> QUAT_MI2S_TX -> AUDIO_REF_EC_UL28 MUX
[    5.567351] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no sink widg=
et found for AUDIO_REF_EC_UL29 MUX
[    5.567353] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route PRI_MI2S_TX -> PRI_MI2S_TX -> AUDIO_REF_EC_UL29 MUX
[    5.567372] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no sink widg=
et found for AUDIO_REF_EC_UL29 MUX
[    5.567374] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route SEC_MI2S_TX -> SEC_MI2S_TX -> AUDIO_REF_EC_UL29 MUX
[    5.567392] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no sink widg=
et found for AUDIO_REF_EC_UL29 MUX
[    5.567394] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route TERT_MI2S_TX -> TERT_MI2S_TX -> AUDIO_REF_EC_UL29 MUX
[    5.567407] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no sink widg=
et found for AUDIO_REF_EC_UL29 MUX
[    5.567410] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route QUAT_MI2S_TX -> QUAT_MI2S_TX -> AUDIO_REF_EC_UL29 MUX
[    5.567456] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no source wi=
dget found for AUDIO_REF_EC_UL28 MUX
[    5.567459] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route AUDIO_REF_EC_UL28 MUX -> direct -> MM_UL28
[    5.567480] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no source wi=
dget found for AUDIO_REF_EC_UL29 MUX
[    5.567482] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route AUDIO_REF_EC_UL29 MUX -> direct -> MM_UL29
[    5.575482] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: no dapm matc=
h for TERT_MI2S_TX --> TERT_MI2S_TX --> VoLTE Stub Tx Mixer
[    5.575489] msm-pcm-routing soc:qcom,msm-pcm-routing: ASoC: Failed to ad=
d route TERT_MI2S_TX -> TERT_MI2S_TX -> VoLTE Stub Tx Mixer
[    5.602547] spi_geni a80000.spi: tx_fifo 16 rx_fifo 16 tx_width 32
[    5.700855] max98927_probe: enter
[    5.716137] msm_audrx_init: dev_namesoc:qcom,msm-dai-q6:qcom,msm-dai-q6-=
sb-0-rx
[    5.722218] apr_tal_notify_state: Channel state[0]
[    5.733084] sdm845-asoc-snd soc:qcom,msm-audio-apr:sound-tavil: ASoC: no=
 sink widget found for SpkrLeft IN
[    5.733097] sdm845-asoc-snd soc:qcom,msm-audio-apr:sound-tavil: ASoC: Fa=
iled to add route SPK1 OUT -> direct -> SpkrLeft IN
[    5.733120] sdm845-asoc-snd soc:qcom,msm-audio-apr:sound-tavil: ASoC: no=
 sink widget found for SpkrRight IN
[    5.733123] sdm845-asoc-snd soc:qcom,msm-audio-apr:sound-tavil: ASoC: Fa=
iled to add route SPK2 OUT -> direct -> SpkrRight IN
[    5.733143] sdm845-asoc-snd soc:qcom,msm-audio-apr:sound-tavil: wcd_mbhc=
_start: qcom,msm-mbhc-usbc-audio-supported in dt node is missing or false
[    5.733145] sdm845-asoc-snd soc:qcom,msm-audio-apr:sound-tavil: wcd_mbhc=
_start: skipping USB c analog configuration
[    5.747229] input: sdm845-tavil-snd-card Headset Jack as /devices/platfo=
rm/soc/soc:qcom,msm-audio-apr/soc:qcom,msm-audio-apr:sound-tavil/sound/card=
0/input4
[    5.747369] input: sdm845-tavil-snd-card Button Jack as /devices/platfor=
m/soc/soc:qcom,msm-audio-apr/soc:qcom,msm-audio-apr:sound-tavil/sound/card0=
/input5
[    5.747416] keychord: using input dev sdm845-tavil-snd-card Button Jack =
for fevent
[    5.748231] sdm845-asoc-snd soc:qcom,msm-audio-apr:sound-tavil: Sound ca=
rd sdm845-tavil-snd-card registered
[    5.748330] property qcom,us-euro-gpios not detected in node /soc/qcom,m=
sm-audio-apr/sound-tavil
[    5.748337] msm_asoc_machine_probe: fsa4480_enable is false
[    5.748341] msm_prepare_us_euro
[    5.748343] setHpSwGpioPin hp_sw_gpio gpio_is_valid failed
[    5.748688] msm_get_pinctrl: could not get mi2s_disable pinstate
[    5.754291] CAM_INFO: CAM-ICP: cam_icp_mgr_hw_open: 2803 FW download don=
e successfully
[    6.026717] extcon_dev_work ,key[0]=3D1,key[1]=3D1,key[2]=3D0
[    6.340385] capability: warning: `main' uses 32-bit capabilities (legacy=
 support in use)
[    6.606353] msm_qti_pp_get_rms_value_control, back not active to query r=
ms be_idx:3
[    6.610753] CAM_ERR: CAM-SENSOR: cam_sensor_update_id_info: 486 Sensor A=
ddr: 0x1010100 sensor_id: 0x13 sensor_mask: 0x0
[    6.612848] core_get_license_status: cmdrsp_license_result.result =3D 0x=
15 for module 0x131ff
[    6.613385] msm-ext-disp-audio-codec-rx soc:qcom,msm-ext-disp:qcom,msm-e=
xt-disp-audio-codec-rx: msm_ext_disp_audio_type_get: codec_data, get_audio_=
edid_blk() or get_intf_id is NULL
[    6.613602] max98927_info_rivision_ctl
[    6.613635] max98927_info_rivision_ctl
[    6.613667] max98927_get_rivision_ctl
[    6.613850] max98927_digital_gain_get: spk_gain setting returned 0
[    6.619168] max98927_mono_out_get_l: value:128
[    6.619350] max98927_mono_out_get_r: value:0
[    6.620339] max98927_left_channel_enable_get: value:0
[    6.620504] max98927_right_channel_enable_get: value:0
[    6.623668] CAM_ERR: CAM-SENSOR: cam_sensor_match_id: 709 sensor id 0x13=
 matched
[    6.623847] CAM_INFO: CAM-SENSOR: cam_sensor_match_id: 732 imx519 sensor=
_version: 0x10
[    6.636964] CAM_ERR: CAM-SENSOR: cam_sensor_match_id: 744 sensor_id: 0x5=
19, fuse_id:7ab0519070120210
[    6.636971] CAM_INFO: CAM-SENSOR: cam_sensor_driver_cmd: 866 Probe Succe=
es,slot:0,slave_addr:0x34,sensor_id:0x519
[    6.647219] CAM_ERR: CAM-SENSOR: cam_sensor_driver_cmd: 1094 fuse_id:7ab=
0519070120210
[    6.748595] CAM_ERR: CAM-SENSOR: cam_sensor_update_id_info: 486 Sensor A=
ddr: 0x0 sensor_id: 0x0 sensor_mask: 0x0
[    6.761273] CAM_ERR: CAM-SENSOR: cam_sensor_match_id: 712 sensor id regi=
ster is 0x0
[    6.761372] CAM_INFO: CAM-SENSOR: cam_sensor_driver_cmd: 866 Probe Succe=
es,slot:2,slave_addr:0x20,sensor_id:0x371
[    6.785265] CAM_ERR: CAM-SENSOR: cam_sensor_update_id_info: 486 Sensor A=
ddr: 0x1010100 sensor_id: 0x61 sensor_mask: 0x0
[    6.797942] CAM_ERR: CAM-SENSOR: cam_sensor_match_id: 706 sensor id 0x13=
 does not match 0x61
[    6.830046] CAM_ERR: CAM-SENSOR: cam_sensor_init_subdev_do_ioctl: 131 ca=
m_sensor_subdev_ioctl failed
[    6.830293] CAM_ERR: CAM-SENSOR: cam_sensor_update_id_info: 486 Sensor A=
ddr: 0x1010100 sensor_id: 0x13 sensor_mask: 0x0
[    6.842487] CAM_ERR: CAM-SENSOR: cam_sensor_match_id: 709 sensor id 0x13=
 matched
[    6.842580] CAM_INFO: CAM-SENSOR: cam_sensor_driver_cmd: 866 Probe Succe=
es,slot:1,slave_addr:0x20,sensor_id:0x376
[    6.892404] msm_qti_pp_get_rms_value_control, back not active to query r=
ms be_idx:3
[    6.898455] core_get_license_status: cmdrsp_license_result.result =3D 0x=
15 for module 0x131ff
[    6.898961] msm-ext-disp-audio-codec-rx soc:qcom,msm-ext-disp:qcom,msm-e=
xt-disp-audio-codec-rx: msm_ext_disp_audio_type_get: codec_data, get_audio_=
edid_blk() or get_intf_id is NULL
[    6.899169] max98927_info_rivision_ctl
[    6.899202] max98927_info_rivision_ctl
[    6.899234] max98927_get_rivision_ctl
[    6.899415] max98927_digital_gain_get: spk_gain setting returned 0
[    6.903194] max98927_mono_out_get_l: value:128
[    6.903381] max98927_mono_out_get_r: value:0
[    6.903882] max98927_left_channel_enable_get: value:0
[    6.903973] max98927_right_channel_enable_get: value:0
[    6.973634] synaptics,s3320: F12_2D_QUERY_BASE =3D 4a \x0a \x09\x09\x09F=
12_2D_CMD_BASE  =3D 0 \x0a\x09\x09\x09F12_2D_CTRL_BASE\x09=3D 13 \x0a\x09\x=
09\x09F12_2D_DATA_BASE\x09=3D 8 \x0a\x09\x09\x09
[    6.974232] synaptics,s3320: F34_FLASH_QUERY_BASE =3D 23 \x0a\x09\x09\x0=
9F34_FLASH_CMD_BASE\x09=3D 0 \x0a\x09\x09\x09F34_FLASH_CTRL_BASE\x09=3D c \=
x0a\x09\x09\x09F34_FLASH_DATA_BASE\x09=3D 0 \x0a\x09\x09\x09
[    6.975140] synaptics,s3320: F54_QUERY_BASE =3D 43 \x0a\x09\x09\x09F54_C=
MD_BASE  =3D 42 \x0a\x09\x09\x09F54_CTRL_BASE\x09=3D e \x0a\x09\x09\x09F54_=
DATA_BASE\x09=3D 0 \x0a\x09\x09\x09
[    6.977089] synaptics,s3320: max_x =3D 1080,max_y =3D 2280; max_x_ic =3D=
 1079,max_y_ic =3D 2279
[    6.977344] synaptics,s3320: Firmware self check success
[    6.977935] synaptics,s3320: CURRENT_FIRMWARE_ID 0x4543313031303134!
[    6.987599] set_dload_mode ON
[    6.987891] CAM_ERR: CAM-EEPROM: cam_eeprom_read_memory: 159 OIS module =
0x24
[    6.990671] cgroup: cgroup: disabling cgroup2 socket matching due to net=
_prio or net_cls activation
[    7.003185] ep0_open success!
[    7.003195] read descriptors
[    7.003201] read strings
[    7.004076] subsys-restart: __subsystem_get(): Changing subsys fw_name t=
o modem
[    7.006364] ipa-wan ipa3_ssr_notifier_cb:2731 IPA received MPSS BEFORE_P=
OWERUP
[    7.006671] ipa ipa3_uc_state_check:289 uC is not loaded
[    7.006679] ipa-wan ipa3_ssr_notifier_cb:2743 IPA BEFORE_POWERUP handlin=
g is complete
[    7.007800] pil-q6v5-mss 4080000.qcom,mss: modem: loading from 0x0000000=
08e000000 to 0x0000000095800000
[    7.015317] pil-q6v5-mss 4080000.qcom,mss: Debug policy not present - ms=
adp. Continue.
[    7.015352] pil-q6v5-mss 4080000.qcom,mss: Loading MBA and DP (if presen=
t) from 0x0000000096500000 to 0x0000000096600000
[    7.035660] 'opened /dev/adsprpc-smd c 225 0'
[    7.044481] init: starting service 'wifidisplayhalservice'...
[    7.045334] init: starting service '0HuqVPR'...
[    7.046072] init: Could not start service 'nqnfcinfo' as part of class '=
late_start': Cannot find '/system/vendor/bin/nqnfcinfo': No such file or di=
rectory
[    7.046234] init: starting service 'cnss-daemon'...
[    7.047486] init: Created socket '/dev/socket/statsdw', mode 222, user 1=
066, group 1066
[    7.050533] init: Failed to open file '/d/mmc0/mmc0:0001/ext_csd': No su=
ch file or directory
[    7.057520] init: Could not start service 'ssgqmigd' as part of class 'l=
ate_start': Cannot find '/vendor/bin/ssgqmigd': No such file or directory
[    7.057534] init: Could not start service 'ssgtzd' as part of class 'lat=
e_start': Cannot find '/vendor/bin/ssgtzd': No such file or directory
[    7.057780] init: starting service 'mlid'...
[    7.058698] init: starting service 'loc_launcher'...
[    7.060484] 'opened /dev/cdsprpc-smd c 225 3'
[    7.092740] pil-q6v5-mss 4080000.qcom,mss: MBA boot done
[    7.094718] BQ: bq27541_battery_soc: bq27541_battery_soc =3D 92
[    7.094749] SMBLIB: load_data: stored_soc[0xb8], shutdown_soc[92]
[    7.094750] BQ: fg_soc_calibrate: soc=3D92, soc_load=3D92
[    7.195167] QSEECOM: qseecom_load_app: App (dhsecapp) does'nt exist, loa=
ding apps for first time
[    7.248021] Process lowi-server granted CAP_NET_ADMIN from Android group=
 net_admin.
[    7.248024] Please update the .rc file to explictly set 'capabilities NE=
T_ADMIN'
[    7.248025] Implicit grants are deprecated and will be removed in the fu=
ture.
[    7.272947] QSEECOM: qseecom_load_app: App with id 3 (dhsecapp) now load=
ed
[    7.293629] QSEECOM: qseecom_load_app: App (haventkn) does'nt exist, loa=
ding apps for first time
[    7.336273] QSEECOM: qseecom_load_app: App with id 4 (haventkn) now load=
ed
[    7.517905] msm-dsi-panel:[dsi_panel_set_backlight:724] ---backlight lev=
el =3D 1023---
[    7.572150] init: oem_property_main
[    7.579708] logd.daemon: reinit
[    7.599803] set_dload_mode ON
[    8.160091] BQ: bq27411_modify_soc_smooth_parameter: bq27411_modify_soc_=
smooth_parameter begin
[    8.258146] BQ: unseal: bq27541 : i=3D1,bq27541_di->device_type=3D1
[    8.314152] BQ: bq27411_enable_config_mode: bq27411_enable_config_mode s=
uccess i =3D 1, config_mode =3D 0x119, enable =3D 1
[    8.318821] healthd: battery l=3D92 v=3D4151 t=3D26.7 h=3D2 st=3D3 c=3D-=
881 fc=3D2878000 cc=3D0 chg=3D
[    8.319239] healthd: battery l=3D92 v=3D4151 t=3D26.7 h=3D2 st=3D3 c=3D-=
881 fc=3D2878000 cc=3D0 chg=3D
[    8.331702] healthd: battery l=3D92 v=3D4151 t=3D26.7 h=3D2 st=3D3 c=3D-=
881 fc=3D2878000 cc=3D0 chg=3D
[    8.332698] healthd: battery l=3D92 v=3D4151 t=3D26.7 h=3D2 st=3D3 c=3D-=
881 fc=3D2878000 cc=3D0 chg=3D
[    8.351348] BQ: bq27411_write_block_data_cmd: bq27411 write blk_id =3D 0=
x6b, addr =3D 0x42, old_val =3D 0x71, new_val =3D 0x11, old_csum =3D 0xfd, =
new_csum =3D 0x5d
[    8.368821] healthd: battery l=3D92 v=3D4151 t=3D26.7 h=3D2 st=3D3 c=3D-=
881 fc=3D2878000 cc=3D0 chg=3D
[    8.372175] healthd: battery l=3D92 v=3D4151 t=3D26.7 h=3D2 st=3D3 c=3D-=
881 fc=3D2878000 cc=3D0 chg=3D
[    8.377239] BQ: bq27411_write_block_data_cmd: bq27411 write blk_id =3D 0=
x40, addr =3D 0x42, old_val =3D 0xf, new_val =3D 0x7, old_csum =3D 0x1, new=
_csum =3D 0x9
[    8.508284] pil-q6v5-mss 4080000.qcom,mss: modem: Brought out of reset
[    8.559703] pil-q6v5-mss 4080000.qcom,mss: Subsystem error monitoring/ha=
ndling services are up
[    8.561429] ipa-wan ipa3_ssr_notifier_cb:2747 ipa3_ssr_notifier_cb:2747 =
IPA received MPSS AFTER_POWERUP
[    8.561437] ipa-wan ipa3_ssr_notifier_cb:2752 IPA AFTER_POWERUP handling=
 is complete
[    8.561702] apr_tal_link_state_cb: edge[mpss] link state[0]
[    8.561928] FASTCHG: dashchg_fw_check: result=3Dsuccess
[    8.561931] FASTCHG: reset_mcu_and_request_irq:=20
[    8.562655] IPC_RTR: ipc_router_create_log_ctx: Unable to create IPC log=
ging for [mpss_IPCRTR]
[    8.565425] rmt_storage:INFO:rmt_storage_open_cb: Processing: Open Reque=
st for /boot/modem_fs1!
[    8.565566] service-notifier: root_service_service_arrive: Connection es=
tablished between QMI handle and 180 service
[    8.567542] sysmon-qmi: sysmon_clnt_svc_arrive: Connection established b=
etween QMI handle and modem's SSCTL service
[    8.567624] rmt_storage:INFO:rmt_storage_open_cb: Processing: Open Reque=
st for /boot/modem_fs2!
[    8.568125] rmt_storage:INFO:rmt_storage_open_cb: Processing: Open Reque=
st for /boot/modem_fsg!
[    8.568754] rmt_storage:INFO:rmt_storage_open_cb: Processing: Open Reque=
st for /boot/modem_fsc!
[    8.572229] rmt_storage:INFO:rmt_storage_alloc_buff_cb: Received req_siz=
e: 0! avail: 2097152
[    8.572943] rmt_storage:INFO:rmt_storage_rw_iovec_cb: Read iovec request=
 received for /oem/nvbk/static
[    8.573091] rmt_storage:INFO:rmt_storage_client_thread: Calling Read [of=
fset=3D0, size=3D512]for /oem/nvbk/static!
[    8.574093] rmt_storage:INFO:rmt_storage_client_thread: Done Read (bytes=
 =3D 512) for /oem/nvbk/static!
[    8.588387] FASTCHG: dashchg_fw_update: FW check success
[    8.879759] ipa-wan ipa3_handle_indication_req:152 not send indication
[    8.879922] Sending QMI_IPA_INIT_MODEM_DRIVER_REQ_V01
[    8.884621] ipa ipa3_uc_wdi_event_log_info_handler:364 WDI stats ofst=3D=
0x47130
[    8.884635] ipa ipa3_uc_ntn_event_log_info_handler:39 NTN feature missin=
g 0x9
[    8.887793] QMI_IPA_INIT_MODEM_DRIVER_REQ_V01 response received
[    8.920443] IPC_RTR: process_new_server_msg: Server 00001002 create reje=
cted, version =3D 0
[    8.930958] BQ: bq27411_enable_config_mode: bq27411_enable_config_mode s=
uccess i =3D 21, config_mode =3D 0x109, enable =3D 0
[    8.943647] BQ: bq27411_modify_soc_smooth_parameter: bq27411_modify_soc_=
smooth_parameter end
[    9.417404] pil-q6v5-mss 4080000.qcom,mss: modem: Power/Clock ready inte=
rrupt received
[    9.569247] service-notifier: root_service_service_ind_cb: Indication re=
ceived from msm/modem/wlan_pd, state: 0x1fffffff, trans-id: 1
[    9.569518] service-notifier: send_ind_ack: Indication ACKed for transid=
 1, service msm/modem/wlan_pd, instance 180!
[    9.571477] icnss: QMI Server Connected: state: 0x981
[    9.629128] IPC_RTR: process_new_server_msg: Server 00001003 create reje=
cted, version =3D 0
[    9.930529] ip_local_port_range: prefer different parity for start/end v=
alues.
[   10.214098] ipa ipa3_assign_policy:2879 get close-by 8192
[   10.214105] ipa ipa3_assign_policy:2885 set rx_buff_sz 7680
[   10.214108] ipa ipa3_assign_policy:2907 set aggr_limit 6
[   10.215878] ipa-wan ipa3_wwan_ioctl:1715 dev(rmnet_data0) register to IPA
[   10.299959] ipa-wan ipa3_wwan_ioctl:1715 dev(rmnet_data1) register to IPA
[   10.387389] ipa-wan ipa3_wwan_ioctl:1715 dev(rmnet_data2) register to IPA
[   10.486823] ipa-wan ipa3_wwan_ioctl:1715 dev(rmnet_data3) register to IPA
[   10.575807] ipa-wan ipa3_wwan_ioctl:1715 dev(rmnet_data4) register to IPA
[   10.611567] synaptics,s3320: key_disable_write_func key_back:0 key_appse=
lect:0
[   10.698680] ipa-wan ipa3_wwan_ioctl:1715 dev(rmnet_data5) register to IPA
[   10.787044] ipa-wan ipa3_wwan_ioctl:1715 dev(rmnet_data6) register to IPA
[   10.864432] acc_open
[   10.864437] acc_release
[   10.884653] ipa-wan ipa3_wwan_ioctl:1715 dev(rmnet_data7) register to IPA
[   10.912456] ipa-wan ipa3_wwan_ioctl:1715 dev(rmnet_data8) register to IPA
[   10.922924] gf_spi: Found
[   10.922927] gf_spi: Succeed to open device. irq =3D 373
[   10.922932] gf_spi: Sensor has already powered-on.
[   10.922934] gf_spi: gf_ioctl GF_IOC_RESET.=20
[   10.937716] ipa-wan ipa3_wwan_ioctl:1715 dev(rmnet_data9) register to IPA
[   10.940863] QSEECOM: qseecom_load_app: App (gfp5288) does'nt exist, load=
ing apps for first time
[   10.983073] ipa-wan ipa3_wwan_ioctl:1715 dev(rmnet_data10) register to I=
PA
[   11.060797] QSEECOM: qseecom_load_app: App with id 5 (gfp5288) now loaded
[   11.099569] synaptics,s3320: tp_gesture_write_func write argc1[0xdf],arg=
c2[0x0]
[   11.137048] synaptics,s3320: key_disable_write_func key_back:0 key_appse=
lect:0
[   11.144396] Wifi Turning On from UI
[   11.144400] wlan: Loading driver v5.1.1.71H ()
[   11.147633] wlan: driver loaded
[   11.150306] healthd: battery l=3D92 v=3D4151 t=3D26.7 h=3D2 st=3D3 c=3D-=
881 fc=3D2878000 cc=3D0 chg=3D
[   11.152689] healthd: battery l=3D92 v=3D4151 t=3D26.7 h=3D2 st=3D3 c=3D-=
881 fc=3D2878000 cc=3D0 chg=3D
[   11.165748] gf_spi: IRQ has been enabled.
[   11.165752] gf_spi: vendor_id : 0x0
[   11.165753] gf_spi: mode : 0xe8
[   11.165753] gf_spi: operation: 0x37
[   11.688602] sdcardfs version 2.0
[   11.688608] sdcardfs: dev_name -> /data/media
[   11.688609] sdcardfs: options -> fsuid=3D1023,fsgid=3D1023,multiuser,der=
ive_gid,default_normal,mask=3D6,userid=3D0,gid=3D1015
[   11.688613] sdcardfs: mnt -> 0000000000000000
[   11.688652] sdcardfs: mounted on top of /data/media type ext4
[   11.689012] Remount options were mask=3D23,gid=3D9997 for vfsmnt 0000000=
000000000.
[   11.689019] sdcardfs : options - debug:1
[   11.689021] sdcardfs : options - gid:9997
[   11.689022] sdcardfs : options - mask:23
[   11.689099] Remount options were mask=3D7,gid=3D9997 for vfsmnt 00000000=
00000000.
[   11.689102] sdcardfs : options - debug:1
[   11.689104] sdcardfs : options - gid:9997
[   11.689105] sdcardfs : options - mask:7
[   11.863573] msm-dsi-panel:[dsi_panel_set_srgb_mode:4354] sRGB Mode Off.
[   11.863841] Real Send DCI-P3 off command
[   11.864034] msm-dsi-panel:[dsi_panel_set_dci_p3_mode:4380] DCI-P3 Mode O=
ff.
[   11.864179] Real Send Night mode off command
[   11.864504] msm-dsi-panel:[dsi_panel_set_night_mode:4407] night Mode Off.
[   11.864899] msm-dsi-panel:[dsi_panel_set_adaption_mode:4479] adaption Mo=
de Off.
[   11.898007] subsys-restart: __subsystem_get(): Changing subsys fw_name t=
o venus
[   11.904159] subsys-pil-tz aae0000.qcom,venus: venus: loading from 0x0000=
000095800000 to 0x0000000095d00000
[   11.950421] subsys-pil-tz aae0000.qcom,venus: venus: Brought out of reset
[   12.041924] binder: unexpected work type, 4, not freed
[   12.405107] init: processing action (sys.training=3D0) from (/system/etc=
/init/caffed.rc:6)
[   12.546509] init: processing action (vendor.ims.DATA_DAEMON_STATUS=3D1) =
=66rom (/vendor/etc/init/hw/init.target.rc:446)
[   12.547622] init: starting service 'vendor.ims_rtp_daemon'...
[   12.557114] init: Received control message 'stop' for 'vendor.imsrcsserv=
ice' from pid: 1166 (/system/vendor/bin/imsdatadaemon)
[   12.557135] init: Sending signal 9 to service 'vendor.imsrcsservice' (pi=
d 906) process group...
[   12.567869] libprocessgroup: Successfully killed process cgroup uid 1000=
 pid 906 in 10ms
[   12.569344] init: Service 'vendor.imsrcsservice' (pid 906) received sign=
al 9
[   12.572153] init: Received control message 'start' for 'vendor.imsrcsser=
vice' from pid: 1166 (/system/vendor/bin/imsdatadaemon)
[   12.572724] init: starting service 'vendor.imsrcsservice'...
[   12.697205] HTB: quantum of class 10001 is big. Consider r2q change.
[   12.723222] HTB: quantum of class 10010 is big. Consider r2q change.
[   12.742839] icnss: WLAN FW is ready: 0xd87
[   12.742942] qcom,rpmh-regulator soc:rpmh-regulator-ldoa7: TCS Busy, retr=
ying RPMH message send
[   12.744349] wlan: probing driver v5.1.1.71H
[   12.744358] ipa ipa3_uc_reg_rdyCB:1774 bad parm. inout=3D          (null=
)=20
[   12.745410] ueventd: firmware: loading 'wlan/qca_cld/WCNSS_qcom_cfg.ini'=
 for '/devices/platform/soc/18800000.qcom,icnss/firmware/wlan!qca_cld!WCNSS=
_qcom_cfg.ini'
[   12.747151] ueventd: loading /devices/platform/soc/18800000.qcom,icnss/f=
irmware/wlan!qca_cld!WCNSS_qcom_cfg.ini took 1ms
[   12.748138] ipa ipa3_uc_reg_rdyCB:1774 bad parm. inout=3D          (null=
)=20
[   12.748469] ipa ipa3_uc_reg_rdyCB:1774 bad parm. inout=3D          (null=
)=20
[   12.797093] IPC_RTR: process_new_server_msg: Server 00001003 create reje=
cted, version =3D 0
[   12.863477] cnss_utils: WLAN MAC address is not set, type 0
[   12.864380] ueventd: firmware: loading 'wlan/qca_cld/wlan_mac.bin' for '=
/devices/platform/soc/18800000.qcom,icnss/firmware/wlan!qca_cld!wlan_mac.bi=
n'
[   12.864857] ueventd: loading /devices/platform/soc/18800000.qcom,icnss/f=
irmware/wlan!qca_cld!wlan_mac.bin took 0ms
[   12.874900] init: Received control message 'start' for 'wpa_supplicant' =
=66rom pid: 924 (/system/bin/wificond)
[   13.007797] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   13.014414] Process lowi-server granted CAP_NET_ADMIN from Android group=
 net_admin.
[   13.014418] Please update the .rc file to explictly set 'capabilities NE=
T_ADMIN'
[   13.014419] Implicit grants are deprecated and will be removed in the fu=
ture.
[   13.014498] Process lowi-server granted CAP_NET_ADMIN from Android group=
 net_admin.
[   13.014499] Please update the .rc file to explictly set 'capabilities NE=
T_ADMIN'
[   13.014500] Implicit grants are deprecated and will be removed in the fu=
ture.
[   13.014599] Process lowi-server granted CAP_NET_ADMIN from Android group=
 net_admin.
[   13.014601] Please update the .rc file to explictly set 'capabilities NE=
T_ADMIN'
[   13.014602] Implicit grants are deprecated and will be removed in the fu=
ture.
[   13.732925] HTB: quantum of class 10010 is big. Consider r2q change.
[   13.804579] HTB: quantum of class 10010 is big. Consider r2q change.
[   14.079246] HTB: quantum of class 10001 is big. Consider r2q change.
[   14.101667] HTB: quantum of class 10010 is big. Consider r2q change.
[   14.268641] [RMNET:HI] rmnet_config_notify_cb(): Kernel is trying to unr=
egister v4-rmnet_data1
[   14.313558] [RMNET:HI] rmnet_config_notify_cb(): Kernel is trying to unr=
egister v4-rmnet_data1
[   15.925229] HTB: quantum of class 10001 is big. Consider r2q change.
[   15.940490] HTB: quantum of class 10010 is big. Consider r2q change.
[   17.594250] init: Received control message 'stop' for 'vendor.imsrcsserv=
ice' from pid: 2316 (/system/vendor/bin/imsrcsd)
[   17.594267] init: Sending signal 9 to service 'vendor.imsrcsservice' (pi=
d 2316) process group...
[   17.599513] libprocessgroup: Successfully killed process cgroup uid 1000=
 pid 2316 in 5ms
[   17.600811] init: Service 'vendor.imsrcsservice' (pid 2316) received sig=
nal 9
[   18.037597] init: Service 'bootanim' (pid 884) exited with status 0
[   18.162082] init: processing action (sys.boot_completed=3D1) from (/init=
=2Erc:765)
[   18.162153] init: processing action (sys.boot_completed=3D1) from (/init=
=2Erc:894)
[   18.162192] init: starting service 'AJ3Px1g'...
[   18.163022] init: processing action (sys.boot_completed=3D1) from (/init=
=2Eusb.rc:115)
[   18.163462] init: processing action (sys.boot_completed=3D1) from (/init=
=2Eperformance_profiles.rc:1)
[   18.163778] Boot completed=20
[   18.168701] Core dump to |/system/bin/coredump.sh 2671 0 1558279291 pipe=
 failed
[   18.370088] /vendor/bin/init.qcom.post_boot.sh[78]: can't create /sys/de=
vices/system/cpu/cpu0/cpufreq/schedutil/rate_limit_us: Permission denied
[   18.370295] /vendor/bin/init.qcom.post_boot.sh[85]: can't create /sys/de=
vices/system/cpu/cpu4/cpufreq/schedutil/rate_limit_us: Permission denied
[   18.370553] /vendor/bin/init.qcom.post_boot.sh[97]: can't create /sys/mo=
dule/lowmemorykiller/parameters/oom_reaper: Permission denied
[   18.382668] /vendor/bin/init.qcom.post_boot.sh[164]: can't create /sys/m=
odule/lpm_levels/L3/cpu0/ret/idle_enabled: No such file or directory
[   18.382695] /vendor/bin/init.qcom.post_boot.sh[165]: can't create /sys/m=
odule/lpm_levels/L3/cpu1/ret/idle_enabled: No such file or directory
[   18.382710] /vendor/bin/init.qcom.post_boot.sh[166]: can't create /sys/m=
odule/lpm_levels/L3/cpu2/ret/idle_enabled: No such file or directory
[   18.382725] /vendor/bin/init.qcom.post_boot.sh[167]: can't create /sys/m=
odule/lpm_levels/L3/cpu3/ret/idle_enabled: No such file or directory
[   18.382738] /vendor/bin/init.qcom.post_boot.sh[168]: can't create /sys/m=
odule/lpm_levels/L3/cpu4/ret/idle_enabled: No such file or directory
[   18.382753] /vendor/bin/init.qcom.post_boot.sh[169]: can't create /sys/m=
odule/lpm_levels/L3/cpu5/ret/idle_enabled: No such file or directory
[   18.382766] /vendor/bin/init.qcom.post_boot.sh[170]: can't create /sys/m=
odule/lpm_levels/L3/cpu6/ret/idle_enabled: No such file or directory
[   18.401418] SMBLIB: smblib_get_apsd_result: APSD_DTC_STATUS_DONE_BIT is 0
[   18.514313] init.qcom.post_: 2 output lines suppressed due to ratelimiti=
ng
[   18.924236] synaptics,s3320: start get base data:1
[   19.080309] synaptics,s3320: set_doze_time: set doze time: 1
[   19.081257] synaptics,s3320: synaptics_tpedge_limitfunc limit_enable =3D=
1,mode:0x67 !
[   20.454820] Process lowi-server granted CAP_NET_ADMIN from Android group=
 net_admin.
[   20.454831] Please update the .rc file to explictly set 'capabilities NE=
T_ADMIN'
[   20.454833] Implicit grants are deprecated and will be removed in the fu=
ture.
[   22.612081] init: processing action (sys.sysctl.tcp_def_init_rwnd=3D*) f=
rom (/init.rc:782)
[   23.091290] selinux: SELinux: Skipping restorecon_recursive(/data/system=
_ce/0)\x0a
[   23.094371] init: Async property child exited with status 0
[   23.097979] selinux: SELinux: Skipping restorecon_recursive(/data/misc_c=
e/0)\x0a
[   23.098713] init: Async property child exited with status 0
[   23.533941] init: processing action (vold.internalSD.startcopy=3D1) from=
 (OP_ACTION_INDEX:35)
[   23.534129] init: starting service 'filebuilderd'...
[   23.546598] filebuilderd: run /system/bin/filebuilderd ENGINE START!
[   23.546747] filebuilderd: Finish traveling /data/media/ folder, 0 files =
(0KB) copied, travel 0 folder, elapse 0 msec
[   23.546759] filebuilderd: Start checking folder...
[   23.546878] filebuilderd: Finish check /data/media/0/ folder, elapse 0 m=
sec, ret =3D 0
[   23.548593] init: Service 'filebuilderd' (pid 2824) exited with status 0
[   23.773912] CPU5: update max cpu_capacity 967
[   24.137390] pn544_dev_ioctl :enter cmd =3D 1074063617, arg =3D 0
[   24.137393] p61_access_lock: Enter
[   24.137394] p61_access_lock: Exit
[   24.137395] pn544_dev_ioctl power off
[   24.137396] p61_update_access_state: Enter current_state =3D 100
[   24.137397] p61_update_access_state: Exit current_state =3D 100
[   24.137403] p61_access_unlock: Enter
[   24.137404] p61_access_unlock: Exit
[   24.137405] pn544_dev_ioctl :exit cmd =3D 1074063617, arg =3D 0
[   24.147495] pn544_dev_ioctl :enter cmd =3D 1074063617, arg =3D 1
[   24.147497] p61_access_lock: Enter
[   24.147499] p61_access_lock: Exit
[   24.147500] pn544_dev_ioctl power on
[   24.147501] p61_update_access_state: Enter current_state =3D 100
[   24.147502] p61_update_access_state: Exit current_state =3D 100
[   24.147508] p61_access_unlock: Enter
[   24.147509] p61_access_unlock: Exit
[   24.147510] pn544_dev_ioctl :exit cmd =3D 1074063617, arg =3D 1
[   24.149618] i2c_geni 88c000.i2c: i2c error :-107
[   24.149631] pn544_dev_write : i2c_master_send returned -107
[   24.206971] pn544_dev_ioctl :enter cmd =3D 1074063623, arg =3D 2
[   24.206974] p61_access_lock: Enter
[   24.206976] p61_access_lock: Exit
[   24.206977] pn544_dev_ioctl : The power scheme is set to PN80T_LEGACY_PW=
R_SCHEME,
[   24.206977] p61_access_unlock: Enter
[   24.206978] p61_access_unlock: Exit
[   24.206979] pn544_dev_ioctl :exit cmd =3D 1074063623, arg =3D 2
[   25.225150] pn544_dev_ioctl :enter cmd =3D 1074063621, arg =3D 2844
[   25.225153] set_nfc_pid : The NFC Service PID is 2844
[   25.247046] pn544_dev_ioctl :enter cmd =3D 2147805443, arg =3D 549051441=
924
[   25.247049] p61_access_lock: Enter
[   25.247051] p61_access_lock: Exit
[   25.247052] pn544_dev_ioctl: P61_GET_PWR_STATUS  =3D 100
[   25.247053] p61_access_unlock: Enter
[   25.247054] p61_access_unlock: Exit
[   25.247055] pn544_dev_ioctl :exit cmd =3D 2147805443, arg =3D 5490514419=
24
[   25.251505] pn544_dev_ioctl :enter cmd =3D 1074063621, arg =3D 2844
[   25.251509] set_nfc_pid : The NFC Service PID is 2844
[   25.253412] rdc_check_valid: rdc=3D0 invalid, [241833636, 403056239]=20
[   25.254569] max989xx_calib_get get calib_value 307581421 =20
[   25.254572] max98927_stream_mute: ref_RDC left =3D307581421=20
[   25.296998] pn544_dev_ioctl :enter cmd =3D 1074063621, arg =3D 2844
[   25.297001] set_nfc_pid : The NFC Service PID is 2844
[   28.664152] CPU6: update max cpu_capacity 1024
[   33.864969] pn544_dev_ioctl :enter cmd =3D 1074063618, arg =3D 1
[   33.864981] p61_access_lock: Enter
[   33.864985] p61_access_lock: Exit
[   33.864989] pn544_dev_ioctl : PN61_SET_SPI_PWR - power on ese
[   33.864993] p61_update_access_state: Enter current_state =3D 100
[   33.864995] p61_update_access_state: Exit current_state =3D 400
[   33.864998] nfc service pid pn544_dev_ioctl   ---- 2844
[   33.865004] signal_handler: Enter
[   33.865010] com.android.nfc.
[   33.865094] signal_handler: Exit ret =3D 0
[   33.867205] i2c_geni 88c000.i2c: i2c error :-107
[   33.867229] pn544_dev_write : i2c_master_send returned -107
[   33.891837] pn544_dev_ioctl :enter cmd =3D 1074063626, arg =3D -16
[   33.891845] release_dwpOnOff_wait: Enter=20
[   33.891984] Dwp On/off wait protection: Timeout
[   33.891987] Dwp On/Off wait protection : released
[   33.904033] p61_access_unlock: Enter
[   33.904041] p61_access_unlock: Exit
[   33.904045] pn544_dev_ioctl :exit cmd =3D 1074063618, arg =3D 1
[   33.905739] spi_geni 880000.spi: tx_fifo 16 rx_fifo 16 tx_width 32
[   34.035236] pn544_dev_ioctl :enter cmd =3D 1074063618, arg =3D 0
[   34.035248] p61_access_lock: Enter
[   34.035253] p61_access_lock: Exit
[   34.035257] pn544_dev_ioctl : PN61_SET_SPI_PWR - power off ese
[   34.035263] p61_update_access_state: Enter current_state =3D 400
[   34.035265] p61_update_access_state: Exit current_state =3D 100
[   34.035270] nfc service pid pn544_dev_ioctl   ---- 2844
[   34.035275] svdd_sync_onoff: Enter nfc_service_pid: 2844
[   34.035279] signal_handler: Enter
[   34.035283] com.android.nfc.
[   34.035344] signal_handler: Exit ret =3D 0
[   34.035346] Waiting for svdd protection response
[   34.046598] pn544_dev_ioctl :enter cmd =3D 1074063624, arg =3D -16
[   34.046605] release_svdd_wait: Enter=20
[   34.046653] release_svdd_wait: Exit
[   34.057021] svdd wait protection : released
[   34.057029] svdd_sync_onoff: Exit
[   34.060258] svdd_sync_onoff: Enter nfc_service_pid: 2844
[   34.060264] signal_handler: Enter
[   34.060268] com.android.nfc.
[   34.060330] signal_handler: Exit ret =3D 0
[   34.060334] Waiting for svdd protection response
[   34.075170] pn544_dev_ioctl :enter cmd =3D 1074063624, arg =3D -16
[   34.075177] release_svdd_wait: Enter=20
[   34.075261] release_svdd_wait: Exit
[   34.086860] svdd wait protection : released
[   34.086866] svdd_sync_onoff: Exit
[   34.086872] p61_access_unlock: Enter
[   34.086875] p61_access_unlock: Exit
[   34.086885] pn544_dev_ioctl :exit cmd =3D 1074063618, arg =3D 0
[   34.088518] pn544_dev_ioctl :enter cmd =3D 1074063618, arg =3D 0
[   34.088523] p61_access_lock: Enter
[   34.088526] p61_access_lock: Exit
[   34.088531] pn544_dev_ioctl : PN61_SET_SPI_PWR - power off ese
[   34.088535] pn544_dev_ioctl : PN61_SET_SPI_PWR - failed, current_state =
=3D 100=20
[   34.088573] p61_access_unlock: Enter
[   34.088577] p61_access_unlock: Exit
[   35.103381] HTB: quantum of class 10010 is big. Consider r2q change.
[   35.199417] HTB: quantum of class 10010 is big. Consider r2q change.
[   35.276250] HTB: quantum of class 10010 is big. Consider r2q change.
[   35.358198] HTB: quantum of class 10010 is big. Consider r2q change.
[   35.428404] HTB: quantum of class 10010 is big. Consider r2q change.
[   35.521990] HTB: quantum of class 10010 is big. Consider r2q change.
[   36.388330] HTB: quantum of class 10010 is big. Consider r2q change.
[   36.481630] HTB: quantum of class 10010 is big. Consider r2q change.
[   36.555046] HTB: quantum of class 10010 is big. Consider r2q change.
[   36.632700] HTB: quantum of class 10010 is big. Consider r2q change.
[   36.711612] HTB: quantum of class 10010 is big. Consider r2q change.
[   36.788563] HTB: quantum of class 10010 is big. Consider r2q change.
[   41.160159] IRQ6 no longer affine to CPU4
[   41.237595] init: Untracked pid 4912 exited with status 0
[   41.380509] logd: logdr: UID=3D10016 GID=3D10016 PID=3D2716 n tail=3D0 l=
ogMask=3D4 pid=3D0 start=3D0ns timeout=3D0ns
[   41.730207] init: Received control message 'start' for 'mdnsd' from pid:=
 620 (/system/bin/netd)
[   41.730892] init: starting service 'mdnsd'...
[   41.737416] init: Created socket '/dev/socket/mdnsd', mode 660, user 102=
0, group 3003
[   41.940150] IRQ6 no longer affine to CPU4
[   42.232181] logd: logdr: UID=3D10016 GID=3D10016 PID=3D2429 n tail=3D0 l=
ogMask=3D4 pid=3D0 start=3D0ns timeout=3D0ns
[   42.257034] logd: logdr: UID=3D10016 GID=3D10016 PID=3D2429 n tail=3D0 l=
ogMask=3D4 pid=3D0 start=3D1558279314861000000ns timeout=3D1558286515441327=
047ns
[   43.968382] logd: logdr: UID=3D10016 GID=3D10016 PID=3D2716 n tail=3D0 l=
ogMask=3D4 pid=3D0 start=3D0ns timeout=3D0ns
[   47.713369] CPU6: update max cpu_capacity 967
[   47.741316] init: Untracked pid 5576 exited with status 0
[   53.304984] init: Received control message 'start' for 'bootanim' from p=
id: 726 (/system/bin/surfaceflinger)
[   53.305395] init: starting service 'bootanim'...
[   53.345664] init: Service 'zygote' (pid 621) received signal 9
[   53.345693] init: Sending signal 9 to service 'zygote' (pid 621) process=
 group...
[   53.382744] libprocessgroup: Successfully killed process cgroup uid 0 pi=
d 621 in 36ms
[   53.384056] init: Command 'write /sys/power/state on' action=3Donrestart=
 (<Service 'zygote' onrestart>:2) took 0ms and failed: Unable to write to f=
ile '/sys/power/state': Unable to write file contents: Invalid argument
[   53.384164] init: Sending signal 9 to service 'audioserver' (pid 724) pr=
ocess group...
[   53.457616] libprocessgroup: Successfully killed process cgroup uid 1041=
 pid 724 in 73ms
[   53.457863] init: Command 'restart audioserver' action=3Donrestart (<Ser=
vice 'zygote' onrestart>:3) took 73ms and succeeded
[   53.457901] init: Sending signal 9 to service 'cameraserver' (pid 908) p=
rocess group...
[   53.603415] qtaguid: tag_stat: stat_update() p2p0 not found
[   53.912751] msm_qti_pp_get_rms_value_control, back not active to query r=
ms be_idx:3
[   53.920373] core_get_license_status: cmdrsp_license_result.result =3D 0x=
15 for module 0x131ff
[   53.921456] msm-ext-disp-audio-codec-rx soc:qcom,msm-ext-disp:qcom,msm-e=
xt-disp-audio-codec-rx: msm_ext_disp_audio_type_get: codec_data, get_audio_=
edid_blk() or get_intf_id is NULL
[   53.921699] max98927_info_rivision_ctl
[   53.921737] max98927_info_rivision_ctl
[   53.921773] max98927_get_rivision_ctl
[   53.921980] max98927_digital_gain_get: spk_gain setting returned 0
[   53.926198] max98927_mono_out_get_l: value:128
[   53.926408] max98927_mono_out_get_r: value:0
[   53.927002] max98927_left_channel_enable_get: value:0
[   53.927107] max98927_right_channel_enable_get: value:0
[   53.945795] i2c_geni 88c000.i2c: i2c error :-107
[   53.945812] pn544_dev_write : i2c_master_send returned -107
[   53.978461] pn544_dev_ioctl :enter cmd =3D 1074063617, arg =3D 0
[   53.978466] p61_access_lock: Enter
[   53.978468] p61_access_lock: Exit
[   53.978470] pn544_dev_ioctl power off
[   53.978471] p61_update_access_state: Enter current_state =3D 100
[   53.978473] p61_update_access_state: Exit current_state =3D 100
[   53.978486] p61_access_unlock: Enter
[   53.978487] p61_access_unlock: Exit
[   53.978489] pn544_dev_ioctl :exit cmd =3D 1074063617, arg =3D 0
[   54.237835] msm_qti_pp_get_rms_value_control, back not active to query r=
ms be_idx:3
[   54.246087] core_get_license_status: cmdrsp_license_result.result =3D 0x=
15 for module 0x131ff
[   54.246628] msm-ext-disp-audio-codec-rx soc:qcom,msm-ext-disp:qcom,msm-e=
xt-disp-audio-codec-rx: msm_ext_disp_audio_type_get: codec_data, get_audio_=
edid_blk() or get_intf_id is NULL
[   54.246909] max98927_info_rivision_ctl
[   54.246946] max98927_info_rivision_ctl
[   54.246977] max98927_get_rivision_ctl
[   54.247160] max98927_digital_gain_get: spk_gain setting returned 0
[   54.250947] max98927_mono_out_get_l: value:128
[   54.251128] max98927_mono_out_get_r: value:0
[   54.251633] max98927_left_channel_enable_get: value:0
[   54.251725] max98927_right_channel_enable_get: value:0
[   54.420299] IRQ6 no longer affine to CPU5
[   54.503500] qtaguid: tag_stat: stat_update() p2p0 not found
[   54.952211] HTB: quantum of class 10010 is big. Consider r2q change.
[   55.010358] HTB: quantum of class 10010 is big. Consider r2q change.
[   55.066193] HTB: quantum of class 10010 is big. Consider r2q change.
[   55.448408] healthd: battery l=3D92 v=3D4110 t=3D27.9 h=3D2 st=3D3 c=3D-=
913 fc=3D2878000 cc=3D0 chg=3D
[   55.449931] healthd: battery l=3D92 v=3D4110 t=3D27.9 h=3D2 st=3D3 c=3D-=
913 fc=3D2878000 cc=3D0 chg=3D
[   55.465795] healthd: battery l=3D92 v=3D4110 t=3D27.9 h=3D2 st=3D3 c=3D-=
913 fc=3D2878000 cc=3D0 chg=3D
[   55.471085] healthd: battery l=3D92 v=3D4110 t=3D27.9 h=3D2 st=3D3 c=3D-=
913 fc=3D2878000 cc=3D0 chg=3D
[   55.472510] healthd: battery l=3D92 v=3D4110 t=3D27.9 h=3D2 st=3D3 c=3D-=
913 fc=3D2878000 cc=3D0 chg=3D
[   58.690290] init: processing action (sys.sysctl.extra_free_kbytes=3D*) f=
rom (/init.rc:778)
[   58.698358] synaptics,s3320: key_disable_write_func key_back:0 key_appse=
lect:0
[   58.998174] acc_open
[   58.998180] acc_release
[   59.411024] synaptics,s3320: tp_gesture_write_func write argc1[0xdf],arg=
c2[0x0]
[   59.413740] init: processing action (wlan.driver.status=3Dok) from (/ven=
dor/etc/init/hw/init.target.rc:176)
[   59.414164] Wifi Turning On from UI
[   59.414341] init: processing action (wlan.driver.status=3Dok) from (OP_A=
CTION_INDEX:31)
[   59.438815] synaptics,s3320: key_disable_write_func key_back:0 key_appse=
lect:0
[   59.457111] healthd: battery l=3D92 v=3D4110 t=3D27.9 h=3D2 st=3D3 c=3D-=
913 fc=3D2878000 cc=3D0 chg=3D
[   59.468178] healthd: battery l=3D92 v=3D4110 t=3D27.9 h=3D2 st=3D3 c=3D-=
913 fc=3D2878000 cc=3D0 chg=3D
[   59.527014] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   59.807446] msm-dsi-panel:[dsi_panel_set_srgb_mode:4354] sRGB Mode Off.
[   59.807823] Real Send DCI-P3 off command
[   59.821969] msm-dsi-panel:[dsi_panel_set_dci_p3_mode:4380] DCI-P3 Mode O=
ff.
[   59.822711] Real Send Night mode off command
[   59.824028] msm-dsi-panel:[dsi_panel_set_night_mode:4407] night Mode Off.
[   59.838983] msm-dsi-panel:[dsi_panel_set_adaption_mode:4479] adaption Mo=
de Off.
[   59.949082] sdcardfs version 2.0
[   59.949088] sdcardfs: dev_name -> /data/media
[   59.949090] sdcardfs: options -> fsuid=3D1023,fsgid=3D1023,multiuser,der=
ive_gid,default_normal,mask=3D6,userid=3D0,gid=3D1015
[   59.949093] sdcardfs: mnt -> 0000000000000000
[   59.949121] sdcardfs: mounted on top of /data/media type ext4
[   59.949346] Remount options were mask=3D23,gid=3D9997 for vfsmnt 0000000=
000000000.
[   59.949351] sdcardfs : options - debug:1
[   59.949353] sdcardfs : options - gid:9997
[   59.949354] sdcardfs : options - mask:23
[   59.949475] Remount options were mask=3D7,gid=3D9997 for vfsmnt 00000000=
00000000.
[   59.949478] sdcardfs : options - debug:1
[   59.949480] sdcardfs : options - gid:9997
[   59.949481] sdcardfs : options - mask:7
[   60.152762] init: processing action (sys.training=3D0) from (/system/etc=
/init/caffed.rc:6)
[   61.811785] init: processing action (persist.sys.gamemode.wifiboost=3D0)=
 from (/init.rc:863)
[   61.812002] init: starting service 'networkboost_disable'...
[   61.817587] init: Service 'networkboost_disable' (pid 6712) exited with =
status 0
[   61.940527] IRQ6 no longer affine to CPU5
[   66.280737] init: Service 'bootanim' (pid 5666) exited with status 0
[   66.413032] init: processing action (sys.boot_completed=3D1) from (/init=
=2Erc:765)
[   66.413282] init: processing action (sys.boot_completed=3D1) from (/init=
=2Erc:894)
[   66.413335] init: starting service 'AJ3Px1g'...
[   66.418045] init: processing action (sys.boot_completed=3D1) from (/init=
=2Eusb.rc:115)
[   66.419064] init: processing action (sys.boot_completed=3D1) from (/init=
=2Eperformance_profiles.rc:1)
[   66.419187] init: processing action (sys.boot_completed=3D1) from (/vend=
or/etc/init/hw/init.qcom.rc:543)
[   66.420122] Boot completed=20
[   66.422221] HTB: quantum of class 10010 is big. Consider r2q change.
[   66.429729] init: processing action (sys.boot_completed=3D1) from (/vend=
or/etc/init/hw/init.qcom.rc:1008)
[   66.430736] init: starting service 'qcom-post-boot'...
[   66.434654] init: starting service 'qti-testscripts'...
[   66.442243] Core dump to |/system/bin/coredump.sh 6759 0 1558279339 pipe=
 failed
[   66.563302] /vendor/bin/init.qcom.post_boot.sh[78]: can't create /sys/de=
vices/system/cpu/cpu0/cpufreq/schedutil/rate_limit_us: Permission denied
[   66.563450] /vendor/bin/init.qcom.post_boot.sh[85]: can't create /sys/de=
vices/system/cpu/cpu4/cpufreq/schedutil/rate_limit_us: Permission denied
[   66.563686] /vendor/bin/init.qcom.post_boot.sh[97]: can't create /sys/mo=
dule/lowmemorykiller/parameters/oom_reaper: Permission denied
[   66.564331] CPU6: update max cpu_capacity 1024
[   66.580188] IRQ6 no longer affine to CPU6
[   66.601925] /vendor/bin/init.qcom.post_boot.sh[164]: can't create /sys/m=
odule/lpm_levels/L3/cpu0/ret/idle_enabled: No such file or directory
[   66.601985] /vendor/bin/init.qcom.post_boot.sh[165]: can't create /sys/m=
odule/lpm_levels/L3/cpu1/ret/idle_enabled: No such file or directory
[   66.602030] /vendor/bin/init.qcom.post_boot.sh[166]: can't create /sys/m=
odule/lpm_levels/L3/cpu2/ret/idle_enabled: No such file or directory
[   66.602075] /vendor/bin/init.qcom.post_boot.sh[167]: can't create /sys/m=
odule/lpm_levels/L3/cpu3/ret/idle_enabled: No such file or directory
[   66.602119] /vendor/bin/init.qcom.post_boot.sh[168]: can't create /sys/m=
odule/lpm_levels/L3/cpu4/ret/idle_enabled: No such file or directory
[   66.602163] /vendor/bin/init.qcom.post_boot.sh[169]: can't create /sys/m=
odule/lpm_levels/L3/cpu5/ret/idle_enabled: No such file or directory
[   66.602206] /vendor/bin/init.qcom.post_boot.sh[170]: can't create /sys/m=
odule/lpm_levels/L3/cpu6/ret/idle_enabled: No such file or directory
[   66.743986] init.qcom.post_: 2 output lines suppressed due to ratelimiti=
ng
[   69.022936] HTB: quantum of class 10001 is big. Consider r2q change.
[   69.065049] HTB: quantum of class 10010 is big. Consider r2q change.
[   69.208040] htb: prio qdisc 10: is non-work-conserving?
[   71.237120] CPU6: update max cpu_capacity 967
[   71.578682] pn544_dev_ioctl :enter cmd =3D 1074063617, arg =3D 0
[   71.578685] p61_access_lock: Enter
[   71.578686] p61_access_lock: Exit
[   71.578687] pn544_dev_ioctl power off
[   71.578688] p61_update_access_state: Enter current_state =3D 100
[   71.578689] p61_update_access_state: Exit current_state =3D 100
[   71.578696] p61_access_unlock: Enter
[   71.578696] p61_access_unlock: Exit
[   71.578697] pn544_dev_ioctl :exit cmd =3D 1074063617, arg =3D 0
[   71.588808] pn544_dev_ioctl :enter cmd =3D 1074063617, arg =3D 1
[   71.588811] p61_access_lock: Enter
[   71.588812] p61_access_lock: Exit
[   71.588813] pn544_dev_ioctl power on
[   71.588814] p61_update_access_state: Enter current_state =3D 100
[   71.588815] p61_update_access_state: Exit current_state =3D 100
[   71.588821] p61_access_unlock: Enter
[   71.588822] p61_access_unlock: Exit
[   71.588823] pn544_dev_ioctl :exit cmd =3D 1074063617, arg =3D 1
[   71.591460] i2c_geni 88c000.i2c: i2c error :-107
[   71.591477] pn544_dev_write : i2c_master_send returned -107
[   71.658084] pn544_dev_ioctl :enter cmd =3D 1074063623, arg =3D 2
[   71.658087] p61_access_lock: Enter
[   71.658088] p61_access_lock: Exit
[   71.658089] pn544_dev_ioctl : The power scheme is set to PN80T_LEGACY_PW=
R_SCHEME,
[   71.658090] p61_access_unlock: Enter
[   71.658090] p61_access_unlock: Exit
[   71.658091] pn544_dev_ioctl :exit cmd =3D 1074063623, arg =3D 2
[   72.665961] pn544_dev_ioctl :enter cmd =3D 1074063621, arg =3D 6946
[   72.665965] set_nfc_pid : The NFC Service PID is 6946
[   72.704016] pn544_dev_ioctl :enter cmd =3D 2147805443, arg =3D 549051441=
924
[   72.704021] p61_access_lock: Enter
[   72.704022] p61_access_lock: Exit
[   72.704024] pn544_dev_ioctl: P61_GET_PWR_STATUS  =3D 100
[   72.704026] p61_access_unlock: Enter
[   72.704027] p61_access_unlock: Exit
[   72.704029] pn544_dev_ioctl :exit cmd =3D 2147805443, arg =3D 5490514419=
24
[   72.708362] pn544_dev_ioctl :enter cmd =3D 1074063621, arg =3D 6946
[   72.708368] set_nfc_pid : The NFC Service PID is 6946
[   72.723732] pn544_dev_ioctl :enter cmd =3D 1074063621, arg =3D 6946
[   72.723735] set_nfc_pid : The NFC Service PID is 6946
[   74.113494] QSEECOM: qseecom_load_app: App (faceapp) does'nt exist, load=
ing apps for first time
[   74.161550] QSEECOM: qseecom_load_app: App with id 6 (faceapp) now loaded
[   74.165422] QSEECOM: qseecom_unload_app: App id 6 now unloaded
[   75.709093] Process lowi-server granted CAP_NET_ADMIN from Android group=
 net_admin.
[   75.709102] Please update the .rc file to explictly set 'capabilities NE=
T_ADMIN'
[   75.709103] Implicit grants are deprecated and will be removed in the fu=
ture.
[   76.020399] IRQ6 no longer affine to CPU4
[   77.471227] init: processing action (sys.sysctl.tcp_def_init_rwnd=3D*) f=
rom (/init.rc:782)
[   77.680855] IRQ6 no longer affine to CPU4
[   78.321860] HTB: quantum of class 10010 is big. Consider r2q change.
[   78.440424] IRQ6 no longer affine to CPU6
[   79.184245] HTB: quantum of class 10010 is big. Consider r2q change.
[   81.325760] pn544_dev_ioctl :enter cmd =3D 1074063618, arg =3D 1
[   81.325771] p61_access_lock: Enter
[   81.325776] p61_access_lock: Exit
[   81.325782] pn544_dev_ioctl : PN61_SET_SPI_PWR - power on ese
[   81.325787] p61_update_access_state: Enter current_state =3D 100
[   81.325791] p61_update_access_state: Exit current_state =3D 400
[   81.325796] nfc service pid pn544_dev_ioctl   ---- 6946
[   81.325802] signal_handler: Enter
[   81.325808] com.android.nfc.
[   81.325901] signal_handler: Exit ret =3D 0
[   81.328066] i2c_geni 88c000.i2c: i2c error :-107
[   81.328091] pn544_dev_write : i2c_master_send returned -107
[   81.347370] pn544_dev_ioctl :enter cmd =3D 1074063626, arg =3D -16
[   81.347377] release_dwpOnOff_wait: Enter=20
[   81.347460] Dwp On/off wait protection: Timeout
[   81.347466] Dwp On/Off wait protection : released
[   81.359535] p61_access_unlock: Enter
[   81.359541] p61_access_unlock: Exit
[   81.359548] pn544_dev_ioctl :exit cmd =3D 1074063618, arg =3D 1
[   81.517366] pn544_dev_ioctl :enter cmd =3D 1074063618, arg =3D 0
[   81.517377] p61_access_lock: Enter
[   81.517383] p61_access_lock: Exit
[   81.517389] pn544_dev_ioctl : PN61_SET_SPI_PWR - power off ese
[   81.517395] p61_update_access_state: Enter current_state =3D 400
[   81.517399] p61_update_access_state: Exit current_state =3D 100
[   81.517404] nfc service pid pn544_dev_ioctl   ---- 6946
[   81.517410] svdd_sync_onoff: Enter nfc_service_pid: 6946
[   81.517416] signal_handler: Enter
[   81.517424] com.android.nfc.
[   81.517517] signal_handler: Exit ret =3D 0
[   81.517520] Waiting for svdd protection response
[   81.529469] pn544_dev_ioctl :enter cmd =3D 1074063624, arg =3D -16
[   81.529476] release_svdd_wait: Enter=20
[   81.529528] release_svdd_wait: Exit
[   81.540507] svdd wait protection : released
[   81.540514] svdd_sync_onoff: Exit
[   81.543467] svdd_sync_onoff: Enter nfc_service_pid: 6946
[   81.543472] signal_handler: Enter
[   81.543477] com.android.nfc.
[   81.543533] signal_handler: Exit ret =3D 0
[   81.543537] Waiting for svdd protection response
[   81.558342] pn544_dev_ioctl :enter cmd =3D 1074063624, arg =3D -16
[   81.558345] release_svdd_wait: Enter=20
[   81.558377] release_svdd_wait: Exit
[   81.570279] svdd wait protection : released
[   81.570286] svdd_sync_onoff: Exit
[   81.570292] p61_access_unlock: Enter
[   81.570295] p61_access_unlock: Exit
[   81.570304] pn544_dev_ioctl :exit cmd =3D 1074063618, arg =3D 0
[   81.570887] pn544_dev_ioctl :enter cmd =3D 1074063618, arg =3D 0
[   81.570893] p61_access_lock: Enter
[   81.570896] p61_access_lock: Exit
[   81.570901] pn544_dev_ioctl : PN61_SET_SPI_PWR - power off ese
[   81.570906] pn544_dev_ioctl : PN61_SET_SPI_PWR - failed, current_state =
=3D 100=20
[   81.570926] p61_access_unlock: Enter
[   81.570930] p61_access_unlock: Exit
[   82.111753] HTB: quantum of class 10001 is big. Consider r2q change.
[   82.142287] HTB: quantum of class 10010 is big. Consider r2q change.
[   87.039254] healthd: battery l=3D92 v=3D4147 t=3D28.3 h=3D2 st=3D3 c=3D-=
863 fc=3D2878000 cc=3D0 chg=3D
[   87.040243] healthd: battery l=3D92 v=3D4147 t=3D28.3 h=3D2 st=3D3 c=3D-=
863 fc=3D2878000 cc=3D0 chg=3D
[   87.519925] init: Untracked pid 9107 exited with status 0
[   87.731396] logd: logdr: UID=3D10016 GID=3D10016 PID=3D6862 n tail=3D0 l=
ogMask=3D4 pid=3D0 start=3D0ns timeout=3D0ns
[   88.368726] logd: logdr: UID=3D10016 GID=3D10016 PID=3D6834 n tail=3D0 l=
ogMask=3D4 pid=3D0 start=3D0ns timeout=3D0ns
[   88.404334] logd: logdr: UID=3D10016 GID=3D10016 PID=3D6834 n tail=3D0 l=
ogMask=3D4 pid=3D0 start=3D1558279361063000000ns timeout=3D1558286561589282=
165ns
[   88.470226] IPC_RTR: do_read_data: No local port id 00000160
[   88.474069] IPC_RTR: do_read_data: No local port id 00000160
[   88.700454] IRQ6 no longer affine to CPU4
[   98.870154] rmt_storage:INFO:rmt_storage_rw_iovec_cb: Write iovec reques=
t received for /boot/modem_fs2
[   98.870611] rmt_storage:INFO:rmt_storage_client_thread: Calling Write [o=
ffset=3D0, size=3D2097152]for /boot/modem_fs2!
[   98.928916] rmt_storage:INFO:rmt_storage_client_thread: Done Write (byte=
s =3D 2097152) for /boot/modem_fs2!
[   99.237338] logd: logdr: UID=3D10016 GID=3D10016 PID=3D6862 n tail=3D0 l=
ogMask=3D4 pid=3D0 start=3D0ns timeout=3D0ns
[   99.912690] logd: logdr: UID=3D10016 GID=3D10016 PID=3D6862 n tail=3D0 l=
ogMask=3D4 pid=3D0 start=3D0ns timeout=3D0ns
[  103.628092] CPU6: update max cpu_capacity 1024
[  103.630019] CPU6: update max cpu_capacity 967
[  103.674700] init: Untracked pid 9820 exited with status 0
[  105.741054] IRQ6 no longer affine to CPU6
[  107.597355] init: Received control message 'start' for 'bootanim' from p=
id: 726 (/system/bin/surfaceflinger)
[  107.597886] init: starting service 'bootanim'...
[  107.654239] init: Service 'zygote' (pid 5720) received signal 9
[  107.654269] init: Sending signal 9 to service 'zygote' (pid 5720) proces=
s group...
[  107.679085] libprocessgroup: Successfully killed process cgroup uid 0 pi=
d 5720 in 24ms
[  107.679940] init: Command 'write /sys/power/state on' action=3Donrestart=
 (<Service 'zygote' onrestart>:2) took 0ms and failed: Unable to write to f=
ile '/sys/power/state': Unable to write file contents: Invalid argument
[  107.679958] init: Sending signal 9 to service 'audioserver' (pid 5723) p=
rocess group...
[  107.753715] libprocessgroup: Successfully killed process cgroup uid 1041=
 pid 5723 in 73ms
[  107.753980] init: Command 'restart audioserver' action=3Donrestart (<Ser=
vice 'zygote' onrestart>:3) took 74ms and succeeded
[  107.778393] SMBLIB: smblib_get_apsd_result: APSD_DTC_STATUS_DONE_BIT is 0
[  107.778400] SMBLIB: smblib_handle_usbin_uv: PMI: smblib_handle_usbin_uv:=
 DEBUG: RESET STORM COUNT FOR POWER_OK
[  107.778452] SMBLIB: smblib_usb_plugin_locked: acquire chg_wake_lock
[  107.779654] SMBLIB: smblib_awake_vote_callback: set awake=3D1
[  107.779678] SMBLIB: smblib_usb_plugin_locked: IRQ: attached
[  107.780201] IRQ6 no longer affine to CPU6
[  107.883396] qtaguid: tag_stat: stat_update() p2p0 not found
[  107.937144] SMBLIB: smblib_get_apsd_result: APSD_DTC_STATUS_DONE_BIT is 0
[  107.969377] healthd: battery l=3D92 v=3D4195 t=3D28.5 h=3D2 st=3D4 c=3D-=
555 fc=3D2878000 cc=3D0 chg=3D
[  107.983580] healthd: battery l=3D92 v=3D4195 t=3D28.5 h=3D2 st=3D4 c=3D-=
555 fc=3D2878000 cc=3D0 chg=3D
[  107.990857] SMBLIB: smblib_get_apsd_result: APSD_DTC_STATUS_DONE_BIT is 0
[  108.006356] healthd: battery l=3D92 v=3D4195 t=3D28.5 h=3D2 st=3D4 c=3D-=
555 fc=3D2878000 cc=3D0 chg=3D
[  108.013055] healthd: battery l=3D92 v=3D4195 t=3D28.5 h=3D2 st=3D4 c=3D-=
555 fc=3D2878000 cc=3D0 chg=3D
[  108.169520] msm_qti_pp_get_rms_value_control, back not active to query r=
ms be_idx:3
[  108.175178] i2c_geni 88c000.i2c: i2c error :-107
[  108.175194] pn544_dev_write : i2c_master_send returned -107
[  108.180043] core_get_license_status: cmdrsp_license_result.result =3D 0x=
15 for module 0x131ff
[  108.180986] msm-ext-disp-audio-codec-rx soc:qcom,msm-ext-disp:qcom,msm-e=
xt-disp-audio-codec-rx: msm_ext_disp_audio_type_get: codec_data, get_audio_=
edid_blk() or get_intf_id is NULL
[  108.181520] max98927_info_rivision_ctl
[  108.181616] max98927_info_rivision_ctl
[  108.181712] max98927_get_rivision_ctl
[  108.182170] max98927_digital_gain_get: spk_gain setting returned 0
[  108.187185] max98927_mono_out_get_l: value:128
[  108.187379] max98927_mono_out_get_r: value:0
[  108.187988] max98927_left_channel_enable_get: value:0
[  108.188099] max98927_right_channel_enable_get: value:0
[  108.208306] pn544_dev_ioctl :enter cmd =3D 1074063617, arg =3D 0
[  108.208311] p61_access_lock: Enter
[  108.208314] p61_access_lock: Exit
[  108.208316] pn544_dev_ioctl power off
[  108.208317] p61_update_access_state: Enter current_state =3D 100
[  108.208319] p61_update_access_state: Exit current_state =3D 100
[  108.208333] p61_access_unlock: Enter
[  108.208335] p61_access_unlock: Exit
[  108.208336] pn544_dev_ioctl :exit cmd =3D 1074063617, arg =3D 0
[  108.213422] qtaguid: tag_stat: stat_update() p2p0 not found
[  108.255214] CPU7: update max cpu_capacity 1024
[  108.497403] msm_qti_pp_get_rms_value_control, back not active to query r=
ms be_idx:3
[  108.505615] core_get_license_status: cmdrsp_license_result.result =3D 0x=
15 for module 0x131ff
[  108.506815] msm-ext-disp-audio-codec-rx soc:qcom,msm-ext-disp:qcom,msm-e=
xt-disp-audio-codec-rx: msm_ext_disp_audio_type_get: codec_data, get_audio_=
edid_blk() or get_intf_id is NULL
[  108.507333] max98927_info_rivision_ctl
[  108.507395] max98927_info_rivision_ctl
[  108.507426] max98927_get_rivision_ctl
[  108.507747] max98927_digital_gain_get: spk_gain setting returned 0
[  108.511943] max98927_mono_out_get_l: value:128
[  108.512148] max98927_mono_out_get_r: value:0
[  108.512731] max98927_left_channel_enable_get: value:0
[  108.512825] max98927_right_channel_enable_get: value:0
[  108.585079] SMBLIB: smblib_handle_usb_source_change: APSD_STATUS=3D0x01
[  108.585153] SMBLIB: smblib_set_icl_current: icl_ua=3D475000
[  108.585244] SMBLIB: smblib_set_usb_suspend: suspend=3D0
[  108.585260] SMBLIB: smblib_set_icl_current: icl_ua=3D1500000
[  108.585341] SMBLIB: smblib_set_usb_suspend: suspend=3D0
[  108.585363] SMBLIB: op_charging_en: enable=3D1
[  108.586356] SMBLIB: handle_batt_temp_normal: triggered
[  108.586367] SMBLIB: set_chg_ibat_vbat_max: set ibatmax=3D1950 and set vb=
atmax=3D4400
[  108.588471] SMBLIB: op_battery_temp_region_set: set temp_region=3D5
[  108.588482] SMBLIB: smblib_handle_apsd_done: apsd result=3D0x4, name=3DC=
DP, psy_type=3D6
[  108.589414] SMBLIB: smblib_handle_apsd_done: apsd done,current_now=3D555
[  108.590560] usbpd usbpd0: typec mode:6 present:1 type:6 orientation:1
[  108.590569] usbpd usbpd0: Type-C Source (default) connected
[  108.593267] msm-dwc3 a600000.ssusb: DWC3 exited from low power mode
[  108.608267] healthd: battery l=3D92 v=3D4195 t=3D28.5 h=3D2 st=3D2 c=3D-=
555 fc=3D2878000 cc=3D0 chg=3Du
[  108.609778] healthd: battery l=3D92 v=3D4195 t=3D28.5 h=3D2 st=3D2 c=3D-=
555 fc=3D2878000 cc=3D0 chg=3Du
[  108.767573] healthd: battery l=3D92 v=3D4195 t=3D28.5 h=3D2 st=3D2 c=3D-=
555 fc=3D2878000 cc=3D0 chg=3Du
[  108.768618] healthd: battery l=3D92 v=3D4195 t=3D28.5 h=3D2 st=3D2 c=3D-=
555 fc=3D2878000 cc=3D0 chg=3Du
[  108.781851] healthd: battery l=3D92 v=3D4195 t=3D28.5 h=3D2 st=3D2 c=3D-=
555 fc=3D2878000 cc=3D0 chg=3Du
[  108.782748] healthd: battery l=3D92 v=3D4195 t=3D28.5 h=3D2 st=3D2 c=3D-=
555 fc=3D2878000 cc=3D0 chg=3Du
[  108.909401] android_work: sent uevent USB_STATE=3DCONNECTED
[  109.040920] healthd: battery l=3D92 v=3D4141 t=3D28.5 h=3D2 st=3D2 c=3D-=
501 fc=3D2878000 cc=3D0 chg=3Du
[  109.042291] healthd: battery l=3D92 v=3D4141 t=3D28.5 h=3D2 st=3D2 c=3D-=
501 fc=3D2878000 cc=3D0 chg=3Du
[  109.189931] android_work: sent uevent USB_STATE=3DDISCONNECTED
[  109.262580] android_work: sent uevent USB_STATE=3DCONNECTED
[  109.316714] android_work: sent uevent USB_STATE=3DDISCONNECTED
[  109.385062] SMBLIB: notify_usb_enumeration_function: status=3D1
[  109.396413] android_work: sent uevent USB_STATE=3DCONNECTED
[  109.400277] configfs-gadget gadget: high-speed config #1: b
[  109.400366] usb_gadget_vbus_draw USB setting current is 500mA
[  109.401132] android_work: sent uevent USB_STATE=3DCONFIGURED
[  109.600066] SMBLIB: smbchg_re_det_work: re_det, usb_enum_status
[  109.603520] SMBLIB: op_check_charger_uovp: charger_voltage=3D4218 charge=
r_ovp=3D0
[  109.603531] SMBLIB: op_check_charger_uovp: charger is over voltage, coun=
t=3D0
[  109.603536] SMBLIB: op_check_charger_uovp: uovp_satus=3D1,pre_uovp_satus=
=3D0,over_volt_count=3D0
[  109.734114] healthd: battery l=3D92 v=3D4141 t=3D28.5 h=3D2 st=3D2 c=3D-=
501 fc=3D2878000 cc=3D0 chg=3Du
[  109.743575] healthd: battery l=3D92 v=3D4141 t=3D28.5 h=3D2 st=3D2 c=3D-=
501 fc=3D2878000 cc=3D0 chg=3Du
[  109.836030] healthd: battery l=3D92 v=3D4141 t=3D28.5 h=3D2 st=3D2 c=3D-=
501 fc=3D2878000 cc=3D0 chg=3Du
[  109.840890] healthd: battery l=3D92 v=3D4141 t=3D28.5 h=3D2 st=3D2 c=3D-=
501 fc=3D2878000 cc=3D0 chg=3Du
[  109.883162] init: processing action (sys.sysctl.extra_free_kbytes=3D*) f=
rom (/init.rc:778)
[  109.888062] synaptics,s3320: key_disable_write_func key_back:0 key_appse=
lect:0
[  110.106794] acc_open
[  110.106799] acc_release
[  110.340907] IRQ6 no longer affine to CPU4
[  110.442935] synaptics,s3320: tp_gesture_write_func write argc1[0xdf],arg=
c2[0x0]
[  110.458817] Wifi Turning On from UI
[  110.459498] init: processing action (wlan.driver.status=3Dok) from (/ven=
dor/etc/init/hw/init.target.rc:176)
[  110.460232] init: processing action (wlan.driver.status=3Dok) from (OP_A=
CTION_INDEX:31)
[  110.466621] synaptics,s3320: key_disable_write_func key_back:0 key_appse=
lect:0
[  110.484729] healthd: battery l=3D92 v=3D4294 t=3D28.5 h=3D2 st=3D2 c=3D7=
07 fc=3D2878000 cc=3D0 chg=3Du
[  110.579471] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  110.815760] msm-dsi-panel:[dsi_panel_set_srgb_mode:4354] sRGB Mode Off.
[  110.816637] Real Send DCI-P3 off command
[  110.817354] msm-dsi-panel:[dsi_panel_set_dci_p3_mode:4380] DCI-P3 Mode O=
ff.
[  110.817725] Real Send Night mode off command
[  110.817952] msm-dsi-panel:[dsi_panel_set_night_mode:4407] night Mode Off.
[  110.820135] CPU7: update max cpu_capacity 967
[  110.832514] msm-dsi-panel:[dsi_panel_set_adaption_mode:4479] adaption Mo=
de Off.
[  110.926060] sdcardfs version 2.0
[  110.926065] sdcardfs: dev_name -> /data/media
[  110.926066] sdcardfs: options -> fsuid=3D1023,fsgid=3D1023,multiuser,der=
ive_gid,default_normal,mask=3D6,userid=3D0,gid=3D1015
[  110.926069] sdcardfs: mnt -> 0000000000000000
[  110.926210] sdcardfs: mounted on top of /data/media type ext4
[  110.926534] Remount options were mask=3D23,gid=3D9997 for vfsmnt 0000000=
000000000.
[  110.926541] sdcardfs : options - debug:1
[  110.926542] sdcardfs : options - gid:9997
[  110.926543] sdcardfs : options - mask:23
[  110.926657] Remount options were mask=3D7,gid=3D9997 for vfsmnt 00000000=
00000000.
[  110.926661] sdcardfs : options - debug:1
[  110.926662] sdcardfs : options - gid:9997
[  110.926710] sdcardfs : options - mask:7
[  112.853646] init: processing action (persist.sys.gamemode.wifiboost=3D0)=
 from (/init.rc:863)
[  112.853899] init: starting service 'networkboost_disable'...
[  112.860377] init: Service 'networkboost_disable' (pid 11013) exited with=
 status 0
[  113.020199] IRQ6 no longer affine to CPU4

--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="logcat.log"

05-19 08:23:00.657  5726  5743 E Netd    : Error adding IPv4 rule: Invalid argument
05-19 08:23:00.657  5726  5743 E Netd    : failed to change permission on interface rmnet_data1 of netId 100 from 0 to 1
05-19 08:23:00.658  6238  6238 D DPMJ    : |SERVICE| DPM received action android.intent.action.ANY_DATA_STATE
05-19 08:23:00.658  6238  6238 W DPMJ    : |SERVICE| DPM received ACTION_ANY_DATA_CONNECTION_STATE_CHANGEDhipri
05-19 08:23:00.658  6238  6238 D DPMJ    : |SERVICE| DPM currently does not support this apnType=hipri
05-19 08:23:00.658  7507  7507 D SecureService: onReceive action:android.intent.action.ANY_DATA_STATE
05-19 08:23:00.658  7507  7507 W ContextImpl: Calling a method in the system process without a qualified user: android.app.ContextImpl.sendBroadcast:1008 android.content.ContextWrapper.sendBroadcast:444 com.oneplus.security.SecureService$b.onReceive:188 android.app.LoadedApk$ReceiverDispatcher$Args.lambda$getRunnable$0:1424 android.app.-$$Lambda$LoadedApk$ReceiverDispatcher$Args$_BumDX2UKsnxLVrE6UJsJZkotuA.run:2 
05-19 08:23:00.659  6298  6298 D TelephonyProvider: subIdString = 1 subId = 1
05-19 08:22:06.350   859  1656 E AndroidRuntime: *** FATAL EXCEPTION IN SYSTEM PROCESS: ConnectivityServiceThread
05-19 08:22:06.350   859  1656 E AndroidRuntime: java.lang.IllegalStateException: command '94 network permission network set NETWORK 100' failed with '400 94 setPermissionForNetworks() failed (Invalid argument)'
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at com.android.server.NetworkManagementService.setNetworkPermission(NetworkManagementService.java:2735)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at com.android.server.ConnectivityService.updateCapabilities(ConnectivityService.java:5207)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at com.android.server.ConnectivityService.handleLingerComplete(ConnectivityService.java:5434)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at com.android.server.ConnectivityService.access$3100(ConnectivityService.java:225)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at com.android.server.ConnectivityService$NetworkStateTrackerHandler.maybeHandleNetworkAgentInfoMessage(ConnectivityService.java:2417)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at com.android.server.ConnectivityService$NetworkStateTrackerHandler.handleMessage(ConnectivityService.java:2429)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at android.os.Handler.dispatchMessage(Handler.java:106)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at com.android.internal.util.WakeupMessage.onAlarm(WakeupMessage.java:133)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at android.app.AlarmManager$ListenerWrapper.run(AlarmManager.java:245)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at android.os.Handler.handleCallback(Handler.java:873)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at android.os.Handler.dispatchMessage(Handler.java:99)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at android.os.Looper.loop(Looper.java:193)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at android.os.HandlerThread.run(HandlerThread.java:65)
05-19 08:22:06.350   859  1656 E AndroidRuntime: Caused by: com.android.server.NativeDaemonConnector$NativeDaemonFailureException: command '94 network permission network set NETWORK 100' failed with '400 94 setPermissionForNetworks() failed (Invalid argument)'
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at com.android.server.NativeDaemonConnector.executeForList(NativeDaemonConnector.java:515)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at com.android.server.NativeDaemonConnector.execute(NativeDaemonConnector.java:411)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at com.android.server.NativeDaemonConnector.execute(NativeDaemonConnector.java:406)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	at com.android.server.NetworkManagementService.setNetworkPermission(NetworkManagementService.java:2730)
05-19 08:22:06.350   859  1656 E AndroidRuntime: 	... 12 more
05-19 08:23:00.660  5838  5979 E AndroidRuntime: *** FATAL EXCEPTION IN SYSTEM PROCESS: ConnectivityServiceThread
05-19 08:23:00.660  5838  5979 E AndroidRuntime: java.lang.IllegalStateException: command '92 network permission network set NETWORK 100' failed with '400 92 setPermissionForNetworks() failed (Invalid argument)'
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at com.android.server.NetworkManagementService.setNetworkPermission(NetworkManagementService.java:2735)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at com.android.server.ConnectivityService.updateCapabilities(ConnectivityService.java:5207)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at com.android.server.ConnectivityService.handleLingerComplete(ConnectivityService.java:5434)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at com.android.server.ConnectivityService.access$3100(ConnectivityService.java:225)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at com.android.server.ConnectivityService$NetworkStateTrackerHandler.maybeHandleNetworkAgentInfoMessage(ConnectivityService.java:2417)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at com.android.server.ConnectivityService$NetworkStateTrackerHandler.handleMessage(ConnectivityService.java:2429)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at android.os.Handler.dispatchMessage(Handler.java:106)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at com.android.internal.util.WakeupMessage.onAlarm(WakeupMessage.java:133)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at android.app.AlarmManager$ListenerWrapper.run(AlarmManager.java:245)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at android.os.Handler.handleCallback(Handler.java:873)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at android.os.Handler.dispatchMessage(Handler.java:99)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at android.os.Looper.loop(Looper.java:193)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at android.os.HandlerThread.run(HandlerThread.java:65)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: Caused by: com.android.server.NativeDaemonConnector$NativeDaemonFailureException: command '92 network permission network set NETWORK 100' failed with '400 92 setPermissionForNetworks() failed (Invalid argument)'
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at com.android.server.NativeDaemonConnector.executeForList(NativeDaemonConnector.java:515)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at com.android.server.NativeDaemonConnector.execute(NativeDaemonConnector.java:411)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at com.android.server.NativeDaemonConnector.execute(NativeDaemonConnector.java:406)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	at com.android.server.NetworkManagementService.setNetworkPermission(NetworkManagementService.java:2730)
05-19 08:23:00.660  5838  5979 E AndroidRuntime: 	... 12 more
05-19 08:23:00.665  6298  6298 I chatty  : uid=1001(radio) identical 1 line
05-19 08:23:00.669  6298  6298 D TelephonyProvider: subIdString = 1 subId = 1
05-19 08:23:00.669  5838  5979 E OPDiagnose: OPDiagnoseManager addIssueCount type = 2, count = 1
05-19 08:23:00.669  5838  5979 E         : BpOPDiagnoseServer addIssueCount type = 2, count = 1
05-19 08:23:00.670   718   803 E         : BnOPDiagnoseServer ADD_ISSUE_COUNT type = 2, count = 1
05-19 08:23:00.670   718   803 W OPDiagnoseService: OPDiagnoseService addIssueCount type = 2, count = 1
05-19 08:23:00.670   718   802 D OPDiagnoseService: OPDiagnoseService get issue item...2
05-19 08:23:00.670  5838  5939 D OSTracker: OS Event: system_server_crash
05-19 08:23:00.672  5838  5858 W BroadcastQueue: Background execution not allowed: receiving Intent { act=android.intent.action.DROPBOX_ENTRY_ADDED flg=0x10 (has extras) } to com.google.android.gms/.stats.service.DropBoxEntryAddedReceiver
05-19 08:23:00.673  5838  5858 W BroadcastQueue: Background execution not allowed: receiving Intent { act=android.intent.action.DROPBOX_ENTRY_ADDED flg=0x10 (has extras) } to com.google.android.gms/.chimera.GmsIntentOperationService$PersistentTrustedReceiver
05-19 08:23:00.673  5838  5979 E Process : try to kill system_server
05-19 08:23:00.673  5838  5979 I Process : Sending signal. PID: 5838 SIG: 9

--G4iJoqBmSsgzjUCe--
