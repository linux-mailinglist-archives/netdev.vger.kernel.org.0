Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAEE590AC7
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 05:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbiHLDeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 23:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiHLDeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 23:34:04 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0B3A3D7F;
        Thu, 11 Aug 2022 20:34:01 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id m5so1581782qkk.1;
        Thu, 11 Aug 2022 20:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=wtO1fcUmjdTP9XEGrZXshRwO+5Eo0f1ecnkVPZiPXnc=;
        b=QKOno/lWel971HkrlKacISC5E/KwC+PnCDGeBDeoFr884L+22GrlLSceybYwOXEX+R
         V97ygFndmulZdG10y9C2xQq8NEZq0iqOiF91S5Y8qcqxyP6esAdbwp2tue4hVS4HInQN
         s5Y4E609AVsGOeIja4FKRUeR/sxyDUAedeTw/9h9I1ZWgM8Zx8opUaCxwtuPEC5Ikw/7
         P+kwfOpvIYUGx/mLXMYZH3eAqgkyE2HH6IkXvQVcpzJGZXHMkwDGkSLDLHXSVDoAA/EI
         ia/GlB28sBxvngzfsN9ZJ5uQwKcnY19MdkpwMHOi4ccPts2sh8Rj6Z6v3HsI0HZ9pl3a
         w6xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=wtO1fcUmjdTP9XEGrZXshRwO+5Eo0f1ecnkVPZiPXnc=;
        b=idYnkxIzytnKKU9Y761jHJjB41w48855p1xElF/eKrVx9C8lt0PmZtgatRYK1qJRZC
         eT4Ky6cLHhT/NhYGZMh2JDro+4+CnqMEEdyQBl75fsv3R+HJZL9LefcJ131grzQxz0st
         MkkPh3HADmManUXssJRoky44rZ3YB3NHqeta6h7Y2daUc4njou8MVOOPSk3Gqx1+l8oF
         rHZESZu1etsW5nJGXdTPhItAsw6e8Dc2gispZ9+2SWSFpZMmZg03+wPcH/1kbmGSDMjc
         zbi1Y/haBJjk/V81Otz1C8bLDRDi1+zk1d2LQQvGSoPDg0hcRBl6VUyaJV7cJ3oMpZZS
         BC/g==
X-Gm-Message-State: ACgBeo2/z6y0zIPyweb9X7Qn34Ng1qN491/aks2iHSEc4eOFgySojv7d
        Y3adnpkJWFT0mFHChFyfhAM=
X-Google-Smtp-Source: AA6agR4usEYrk/quXR769Asie2pRoZrezbDgSQRwLR+pjJRLsgPSE8CSSBkm488Up/qVKLyLOFW9Kg==
X-Received: by 2002:ae9:ef48:0:b0:6ba:2907:7417 with SMTP id d69-20020ae9ef48000000b006ba29077417mr1597066qkg.4.1660275240560;
        Thu, 11 Aug 2022 20:34:00 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u19-20020a05620a0c5300b006b5f8f32a8fsm848554qki.114.2022.08.11.20.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 20:33:59 -0700 (PDT)
Message-ID: <a6035600-56f6-1760-ae5c-5e8131a2e8e4@gmail.com>
Date:   Thu, 11 Aug 2022 20:33:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.1
Subject: Re: Kernel Panic in skb_release_data using genet
Content-Language: en-US
To:     Maxime Ripard <maxime@cerno.tech>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     nicolas saenz julienne <nsaenz@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <1482eff4-c5f4-66d9-237c-55a096ae2eb4@gmail.com>
 <6caa98e7-28ba-520c-f0cc-ee1219305c17@gmail.com>
 <20210528163219.x6yn44aimvdxlp6j@gilmour>
 <77d412b4-cdd6-ea86-d7fd-adb3af8970d9@gmail.com>
 <9e99ade5-ebfc-133e-ac61-1aba07ca80a2@gmail.com>
 <483c73edf02fa0139aae2b81e797534817655ea0.camel@kernel.org>
 <20210602132822.5hw4yynjgoomcfbg@gilmour>
 <681f7369-90c7-0d2a-18a3-9a10917ce5f3@gmail.com>
 <20220513145653.rb7tah6dbjxc2fab@houat>
 <bdce6694-f5f9-37c3-915b-90a6524af919@gmail.com>
 <20220517075254.5sctk4hgomjvnuxg@houat>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220517075254.5sctk4hgomjvnuxg@houat>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/17/2022 12:52 AM, Maxime Ripard wrote:
> It's not really 100% reliable, but happens 30%-50% of the time at boot
> when KASAN is enabled. It seems like enabling KASAN increases that
> likelihood though, it went unnoticed for some time before I started
> having those issues again when I enabled it for something unrelated.
> 
> It looks like it happens in bursts though, so I would get 10-15 boots
> fine, and then 4-5 boots with that crash.
> 
> Cold boot vs reboot doesn't seem to affect it in one way or the other.
> 
>> What version of GCC did you build your kernel with?
> 
> The arm64 cross-compiler packaged by Fedora, which is GCC 11.2
> at the moment.
> 
>> How often does that happen? What config.txt file are you using
>> for your Pi4 B?
> 
> You'll find my config.txt and kernel .config attached

OK, so this is what I have been able to reproduce so far but this does 
not appear to be very reliable to reproduce, I will try my best to hold 
on to that lead though, thanks for your patience.

# udhcpc -i eth0
udhcpc: started, v1.35.0
[   34.355086] bcmgenet fd580000.ethernet: configuring instance for 
external RGMII (RX delay)
[   34.363758] 
==================================================================
[   34.371106] BUG: KASAN: user-memory-access in put_page+0x10/0x64
[   34.377227] Read of size 4 at addr 01000085 by task ifconfig/165
[   34.383338]
[   34.384857] CPU: 0 PID: 165 Comm: ifconfig Tainted: G        W 
   5.19.0 #43
[   34.392560] Hardware name: BCM2711
[   34.396020]  unwind_backtrace from show_stack+0x18/0x1c
[   34.401354]  show_stack from dump_stack_lvl+0x40/0x4c
[   34.406502]  dump_stack_lvl from kasan_report+0x8c/0xa4
[   34.411825]  kasan_report from put_page+0x10/0x64
[   34.416615]  put_page from skb_release_data+0x84/0x13c
[   34.421847]  skb_release_data from __kfree_skb+0x14/0x20
[   34.427256]  __kfree_skb from bcmgenet_rx_poll+0x504/0x6f8
[   34.432846]  bcmgenet_rx_poll from __napi_poll.constprop.0+0x50/0x1c0
[   34.439407]  __napi_poll.constprop.0 from net_rx_action+0x278/0x488
[   34.445787]  net_rx_action from __do_softirq+0x268/0x390
[   34.451197]  __do_softirq from __irq_exit_rcu+0x88/0xf8
[   34.456521]  __irq_exit_rcu from irq_exit+0x10/0x18
[   34.461492]  irq_exit from call_with_stack+0x18/0x20
[   34.466553]  call_with_stack from __irq_svc+0x84/0x94
[   34.471696] Exception stack(0xf0d337f8 to 0xf0d33840)
[   34.476835] 37e0: 
   c5548580 00000003
[   34.485156] 3800: 00002000 f0a40808 c5548000 c5548580 00000000 
c554b000 c5548580 c554bdd0
[   34.493474] 3820: 00000000 00000004 c5548580 f0d33848 c094329c 
c09432bc 00070013 ffffffff
[   34.501788]  __irq_svc from bcmgenet_open+0xe1c/0x1094
[   34.507023]  bcmgenet_open from __dev_open+0x1e4/0x21c
[   34.512258]  __dev_open from __dev_change_flags+0x228/0x25c
[   34.517931]  __dev_change_flags from dev_change_flags+0x48/0x88
[   34.523958]  dev_change_flags from devinet_ioctl+0x3ac/0x834
[   34.529723]  devinet_ioctl from inet_ioctl+0x250/0x2a4
[   34.534956]  inet_ioctl from sock_ioctl+0x1dc/0x410
[   34.539927]  sock_ioctl from vfs_ioctl+0x50/0x64
[   34.544632]  vfs_ioctl from sys_ioctl+0x134/0xa7c
[   34.549422]  sys_ioctl from ret_fast_syscall+0x0/0x4c
[   34.554565] Exception stack(0xf0d33fa8 to 0xf0d33ff0)
[   34.559705] 3fa0:                   0051fd98 0053f9dc 00000003 
00008914 b6dc5c4c b6dc5bd0
[   34.568025] 3fc0: 0051fd98 0053f9dc b6dc5f55 00000036 b6dc5e48 
00000003 aed11d00 aed12010
[   34.576341] 3fe0: 00000036 b6dc5bb8 aec4c2f3 aebdda66
[   34.581475] 
==================================================================
[   34.588882] Disabling lock debugging due to kernel taint
[   34.594288] 8<--- cut here ---
[   34.597412] Unable to handle kernel paging request at virtual address 
01000085
[   34.604775] [01000085] *pgd=01982003, *pmd=00000000
[   34.609751] Internal error: Oops: 206 [#1] SMP ARM
[   34.614624] Modules linked in:
[   34.617734] CPU: 0 PID: 165 Comm: ifconfig Tainted: G    B   W 
   5.19.0 #43
[   34.625435] Hardware name: BCM2711
[   34.628892] PC is at put_page+0x14/0x64
[   34.632800] LR is at kasan_report+0x98/0xa4
[   34.637056] pc : [<c0b4bee4>]    lr : [<c047ea5c>]    psr: 60070113
[   34.643427] sp : f0803d50  ip : 00000000  fp : c554bfd8
[   34.648739] r10: 00007f5e  r9 : c694f582  r8 : c1fef15e
[   34.654052] r7 : c694f5b8  r6 : c694f580  r5 : 01000081  r4 : c1fef100
[   34.660689] r3 : 00000000  r2 : c1f047c0  r1 : 00000004  r0 : 00000001
[   34.667325] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
Segment user
[   34.674582] Control: 30c5383d  Table: 0606b700  DAC: fffffffd
[   34.680422] Register r0 information: non-paged memory
[   34.685565] Register r1 information: non-paged memory
[   34.690705] Register r2 information: slab task_struct start c1f047c0 
pointer offset 0
[   34.698690] Register r3 information: NULL pointer
[   34.703477] Register r4 information: slab skbuff_head_cache start 
c1fef100 pointer offset 0 size 48
[   34.712699] Register r5 information: non-paged memory
[   34.717839] Register r6 information: non-slab/vmalloc memory
[   34.723595] Register r7 information: non-slab/vmalloc memory
[   34.729352] Register r8 information: slab skbuff_head_cache start 
c1fef100 pointer offset 94 size 48
[   34.738662] Register r9 information: non-slab/vmalloc memory
[   34.744419] Register r10 information: non-paged memory
[   34.749646] Register r11 information: non-slab/vmalloc memory
[   34.755492] Register r12 information: NULL pointer
[   34.760366] Process ifconfig (pid: 165, stack limit = 0xf517d551)
[   34.766573] Stack: (0xf0803d50 to 0xf0804000)
[   34.771005] 3d40:                                     c1fef100 
00000001 c694f580 c0b4dc74
[   34.779325] 3d60: c1fef100 c5548000 c5548580 c1fef100 f0803e40 
7f5e0001 00007f5e c0b4db24
[   34.787644] 3d80: c554bdd0 c0940f84 0bc80000 b4c23195 c2cb12c0 
c0efdab0 c2cb12c0 00000001
[   34.795963] 3da0: 00000000 00000040 00000004 c554bec4 1e1007bc 
c554beb8 c5548588 00000004
[   34.804282] 3dc0: c55498bc c554bec8 c02d5684 00000003 00000000 
c02b6e10 e7df0980 c02bf390
[   34.812601] 3de0: 41b58ab3 c15fec7a c0940a80 c1f047c0 00070113 
257ac000 e7de97cc ffff982d
[   34.820919] 3e00: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 b4c23195
[   34.829237] 3e20: c1f047c0 e7de8680 00000000 c1f047c0 00000000 
c076733c e7de9ad8 00000000
[   34.837556] 3e40: e7de97d4 c613e0a0 00000001 c554bdd0 00000001 
00000040 f0803ef0 c554bdd8
[   34.845875] 3e60: 257ac000 c2805d40 e7df0d00 c0b70f24 c554bdd0 
f0803ef0 00000000 e7df0b40
[   34.854195] 3e80: f0803f60 bd1007d8 c554bdd0 c2644b40 257ac000 
c0b7130c 0000012c e7df0d0c
[   34.862513] 3ea0: ffff9839 f0803ef0 81d99054 c554bdd4 0000002c 
257ac000 c26433c8 c0840554
[   34.870832] 3ec0: 41b58ab3 c1612850 c0b71094 c2cb12c0 e7df0980 
c02d8a5c ea8ed400 c02d8ae0
[   34.879150] 3ee0: 41b58ab3 c15f3580 c08403c4 00000010 c554bd00 
c554bdd8 00000000 00000010
[   34.887470] 3f00: f0803f00 f0803f00 c5548580 00002000 c554bdd0 
c554b580 0000010a c093e0b8
[   34.895788] 3f20: f0803f20 f0803f20 0000002c c093df98 c2806f18 
c029f4ac 00000000 00000007
[   34.904108] 3f40: e7de9780 c02a4218 00000104 c4dca800 00000001 
c4dca824 c4dca86c c4dca86c
[   34.912427] 3f60: c4dca848 f0803fc8 f0d337f0 b4c23195 c4dca800 
c1f047c0 c280508c 00000008
[   34.920747] 3f80: c2643dc0 c1f047c4 00000003 00000100 c1f049d4 
c02014d8 c4dca800 c1f047c0
[   34.929066] 3fa0: 00400100 0000000a ffff9838 00000004 c263c3c8 
257ac000 c26433c0 c1f047c0
[   34.937385] 3fc0: c2643dc0 c1f047c4 257ac000 257ac000 c1f047c0 
00000000 f0d337f0 c02312c4
[   34.945704] 3fe0: c09432bc 00070013 ffffffff f0d3382c c5548580 
c0231418 c09432bc c07559fc
[   34.954019]  put_page from skb_release_data+0x84/0x13c
[   34.959252]  skb_release_data from __kfree_skb+0x14/0x20
[   34.964660]  __kfree_skb from bcmgenet_rx_poll+0x504/0x6f8
[   34.970250]  bcmgenet_rx_poll from __napi_poll.constprop.0+0x50/0x1c0
[   34.976812]  __napi_poll.constprop.0 from net_rx_action+0x278/0x488
[   34.983192]  net_rx_action from __do_softirq+0x268/0x390
[   34.988602]  __do_softirq from __irq_exit_rcu+0x88/0xf8
[   34.993927]  __irq_exit_rcu from irq_exit+0x10/0x18
[   34.998899]  irq_exit from call_with_stack+0x18/0x20
[   35.003958]  call_with_stack from __irq_svc+0x84/0x94
[   35.009101] Exception stack(0xf0d337f8 to 0xf0d33840)
[   35.014238] 37e0: 
   c5548580 00000003
[   35.022557] 3800: 00002000 f0a40808 c5548000 c5548580 00000000 
c554b000 c5548580 c554bdd0
[   35.030877] 3820: 00000000 00000004 c5548580 f0d33848 c094329c 
c09432bc 00070013 ffffffff
[   35.039192]  __irq_svc from bcmgenet_open+0xe1c/0x1094
[   35.044427]  bcmgenet_open from __dev_open+0x1e4/0x21c
[   35.049661]  __dev_open from __dev_change_flags+0x228/0x25c
[   35.055334]  __dev_change_flags from dev_change_flags+0x48/0x88
[   35.061361]  dev_change_flags from devinet_ioctl+0x3ac/0x834
[   35.067125]  devinet_ioctl from inet_ioctl+0x250/0x2a4
[   35.072359]  inet_ioctl from sock_ioctl+0x1dc/0x410
[   35.077330]  sock_ioctl from vfs_ioctl+0x50/0x64
[   35.082034]  vfs_ioctl from sys_ioctl+0x134/0xa7c
[   35.086825]  sys_ioctl from ret_fast_syscall+0x0/0x4c
[   35.091969] Exception stack(0xf0d33fa8 to 0xf0d33ff0)
[   35.097109] 3fa0:                   0051fd98 0053f9dc 00000003 
00008914 b6dc5c4c b6dc5bd0
[   35.105428] 3fc0: 0051fd98 0053f9dc b6dc5f55 00000036 b6dc5e48 
00000003 aed11d00 aed12010
[   35.113744] 3fe0: 00000036 b6dc5bb8 aec4c2f3 aebdda66
[   35.118883] Code: e1a05000 e2800004 ebe4cca7 e3a01004 (e5953004)
[   35.125104] ---[ end trace 0000000000000000 ]---
[   35.129801] Kernel panic - not syncing: Fatal exception in interrupt
[   35.136260] CPU3: stopping
[   35.139009] CPU: 3 PID: 27 Comm: migration/3 Tainted: G    B D W 
     5.19.0 #43
[   35.146872] Hardware name: BCM2711
[   35.150318] Stopper: multi_cpu_stop+0x0/0x140 <- 
stop_machine_cpuslocked+0x180/0x1e4
[   35.158197]  unwind_backtrace from show_stack+0x18/0x1c
[   35.163509]  show_stack from dump_stack_lvl+0x40/0x4c
[   35.168643]  dump_stack_lvl from do_handle_IPI+0x150/0x2a8
[   35.174218]  do_handle_IPI from ipi_handler+0x1c/0x28
[   35.179351]  ipi_handler from handle_percpu_devid_irq+0x94/0x150
[   35.185454]  handle_percpu_devid_irq from handle_irq_desc+0x38/0x48
[   35.191820]  handle_irq_desc from gic_handle_irq+0x6c/0x78
[   35.197393]  gic_handle_irq from generic_handle_arch_irq+0x28/0x3c
[   35.203671]  generic_handle_arch_irq from call_with_stack+0x18/0x20
[   35.210038]  call_with_stack from __irq_svc+0x84/0x94
[   35.215168] Exception stack(0xf0913e98 to 0xf0913ee0)
[   35.220293] 3e80: 
   e7e20a10 00000000
[   35.228594] 3ea0: 00000000 257dc000 e7e1ec68 f0913ee8 257dc000 
00000000 c2806f18 60070013
[   35.236896] 3ec0: f0863d70 f0863d74 f0863d70 f0913ee8 c02bebd4 
c02bebe8 60070013 ffffffff
[   35.245192]  __irq_svc from rcu_momentary_dyntick_idle+0x2c/0x9c
[   35.251296]  rcu_momentary_dyntick_idle from multi_cpu_stop+0xd4/0x140
[   35.257931]  multi_cpu_stop from cpu_stopper_thread+0x120/0x1d8
[   35.263947]  cpu_stopper_thread from smpboot_thread_fn+0x25c/0x264
[   35.270228]  smpboot_thread_fn from kthread+0x12c/0x140
[   35.275539]  kthread from ret_from_fork+0x14/0x1c
[   35.280317] Exception stack(0xf0913fb0 to 0xf0913ff8)
[   35.285441] 3fa0:                                     00000000 
00000000 00000000 00000000
[   35.293739] 3fc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[   35.302037] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   35.308746] CPU2: stopping
[   35.311492] CPU: 2 PID: 22 Comm: migration/2 Tainted: G    B D W 
     5.19.0 #43
[   35.319355] Hardware name: BCM2711
[   35.322803] Stopper: multi_cpu_stop+0x0/0x140 <- 
stop_machine_cpuslocked+0x180/0x1e4
[   35.330677]  unwind_backtrace from show_stack+0x18/0x1c
[   35.335988]  show_stack from dump_stack_lvl+0x40/0x4c
[   35.341122]  dump_stack_lvl from do_handle_IPI+0x150/0x2a8
[   35.346697]  do_handle_IPI from ipi_handler+0x1c/0x28
[   35.351830]  ipi_handler from handle_percpu_devid_irq+0x94/0x150
[   35.357932]  handle_percpu_devid_irq from handle_irq_desc+0x38/0x48
[   35.364298]  handle_irq_desc from gic_handle_irq+0x6c/0x78
[   35.369870]  gic_handle_irq from generic_handle_arch_irq+0x28/0x3c
[   35.376148]  generic_handle_arch_irq from call_with_stack+0x18/0x20
[   35.382515]  call_with_stack from __irq_svc+0x84/0x94
[   35.387646] Exception stack(0xf08ebea8 to 0xf08ebef0)
[   35.392773] bea0:                   f0863d70 00000003 00000000 
00000001 f0863d60 00000000
[   35.401074] bec0: 00000001 00000000 c2806f18 600c0013 f0863d70 
f0863d74 f0863d70 f08ebef8
[   35.409372] bee0: c030acac c02bebbc 600c0013 ffffffff
[   35.414495]  __irq_svc from rcu_momentary_dyntick_idle+0x0/0x9c
[   35.420511]  rcu_momentary_dyntick_idle from 0xc31d0000
[   35.425820] CPU1: stopping
[   35.428568] CPU: 1 PID: 17 Comm: migration/1 Tainted: G    B D W 
     5.19.0 #43
[   35.436430] Hardware name: BCM2711
[   35.439879] Stopper: multi_cpu_stop+0x0/0x140 <- 
stop_machine_cpuslocked+0x180/0x1e4
[   35.447752]  unwind_backtrace from show_stack+0x18/0x1c
[   35.453064]  show_stack from dump_stack_lvl+0x40/0x4c
[   35.458198]  dump_stack_lvl from do_handle_IPI+0x150/0x2a8
[   35.463772]  do_handle_IPI from ipi_handler+0x1c/0x28
[   35.468905]  ipi_handler from handle_percpu_devid_irq+0x94/0x150
[   35.475006]  handle_percpu_devid_irq from handle_irq_desc+0x38/0x48
[   35.481373]  handle_irq_desc from gic_handle_irq+0x6c/0x78
[   35.486945]  gic_handle_irq from generic_handle_arch_irq+0x28/0x3c
[   35.493222]  generic_handle_arch_irq from call_with_stack+0x18/0x20
[   35.499590]  call_with_stack from __irq_svc+0x84/0x94
[   35.504721] Exception stack(0xf08c3e98 to 0xf08c3ee0)
[   35.509847] 3e80: 
   e7e00a10 00000000
[   35.518148] 3ea0: 00000000 257bc000 e7dfec68 f08c3ee8 257bc000 
00000000 c2806f18 600f0013
[   35.526449] 3ec0: f0863d70 f0863d74 f0863d70 f08c3ee8 c02bebd4 
c02bebe8 600f0013 ffffffff
[   35.534745]  __irq_svc from rcu_momentary_dyntick_idle+0x2c/0x9c
[   35.540849]  rcu_momentary_dyntick_idle from multi_cpu_stop+0xd4/0x140
[   35.547483]  multi_cpu_stop from cpu_stopper_thread+0x120/0x1d8
[   35.553499]  cpu_stopper_thread from smpboot_thread_fn+0x25c/0x264
[   35.559780]  smpboot_thread_fn from kthread+0x12c/0x140
[   35.565090]  kthread from ret_from_fork+0x14/0x1c
[   35.569868] Exception stack(0xf08c3fb0 to 0xf08c3ff8)
[   35.574992] 3fa0:                                     00000000 
00000000 00000000 00000000
[   35.583292] 3fc0: 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000
[   35.591589] 3fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   35.599291] ---[ end Kernel panic - not syncing: Fatal exception in 
interrupt ]---
-- 
Florian
