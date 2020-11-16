Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91F52B44DB
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 14:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgKPNhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 08:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgKPNhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 08:37:50 -0500
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23E1C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 05:37:48 -0800 (PST)
Received: by mail-vs1-xe42.google.com with SMTP id y78so9113277vsy.6
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 05:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dWeaN/nGyVOapaqnYKOPSjDBSNQCNt5OkvgWb8fXvg0=;
        b=t/3JTz1Vz+AHx+7HmYy6rF69zY2etWreBILyA4tiJReKyMKWqMMvMtYPuOonusasgP
         /4pd8juJicbK7odNNPg+SpBaPJafsgr9HNaw1iXwWwRcfAkCPvbC4qCuTNrcS83ucMou
         LwRqlywHPPf1XDkCSMdmWG3PBI/5bFpihhrRpArvezmloFslLfXj/QAJlzhTC74Vf3G4
         AAO9Z33OHpp5JEVnV3k9wMdigpqU7hqX+Kx/Zt94VxvsJWluiCj28n3Si3UJtcOhGWNd
         gHY+kx6lDtjxf6Ar8cL1e8wUg0FgMR9TNzONsW4pFIzHrGPUMVMYudOsJzmFuNin8xoz
         XpHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dWeaN/nGyVOapaqnYKOPSjDBSNQCNt5OkvgWb8fXvg0=;
        b=FIpRXC5IZGnzonbLWlHUaXlNpikf3EX06qZcxiWDMd64nK66/f4qMNL+wQ4eZQIPNW
         5k+ABKGsdIheD8DQ0YoCTpUoM02otrozfXWqWhHeuznwEBuACy1f1o9ke2WsDXHqQDTA
         zxW2PhB9w0+yx1fAVD9GOp8+YPzgnWq3pTxud/ZjmOHMaeZ7fdLRtoJGCzl6UjseGMil
         SNF96IGdzic6Iot7jsdxQSaJ+7+QsHi0vnrqy2GkBZWLQi23VKhJPXaQzo/+8ko9N8i/
         HprrEbso15Jl+RuKLT8G3Z/rzKceUT1WVgw+WbFGDcyOebeUxZHZnDHgcpNu6IY/3KvG
         WqHg==
X-Gm-Message-State: AOAM531jjTVWiBw6ks/GPSpOYSuKG7XujAnnxZepC7DfwkcJlfGHYWLr
        7KAXwweR+LBlhbkKhW0i3Diy+JzVMMI=
X-Google-Smtp-Source: ABdhPJxMZ7ArzAos7ut0DG8sZCItq6C8YdT2IQO7NCSfWamfIuWMwAve6BQ1aFFeKcAukduC7+QDVw==
X-Received: by 2002:a05:6102:240f:: with SMTP id j15mr8280198vsi.22.1605533866926;
        Mon, 16 Nov 2020 05:37:46 -0800 (PST)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com. [209.85.217.44])
        by smtp.gmail.com with ESMTPSA id b81sm80119vka.53.2020.11.16.05.37.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 05:37:45 -0800 (PST)
Received: by mail-vs1-f44.google.com with SMTP id u24so9130467vsl.9
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 05:37:45 -0800 (PST)
X-Received: by 2002:a67:e210:: with SMTP id g16mr8140769vsa.28.1605533864970;
 Mon, 16 Nov 2020 05:37:44 -0800 (PST)
MIME-Version: 1.0
References: <MgZce9htmEtCtHg7pmWxXXfdhmQ6AHrnltXC41zOoo@cp7-web-042.plabs.ch>
 <20201113121502.GB7578@xsang-OptiPlex-9020> <CA+FuTSccV-DNMOqr0hy5q3fZak8=eWYYDNigo8EnG2GV6X1Stw@mail.gmail.com>
 <lRGp5G0pLof6EJnaWcq32k5uytNikWVd23oYWn28Pk@cp3-web-029.plabs.ch>
In-Reply-To: <lRGp5G0pLof6EJnaWcq32k5uytNikWVd23oYWn28Pk@cp3-web-029.plabs.ch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 16 Nov 2020 08:37:08 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfqyxCg5okPDHYwQsKUOCEVFOkf0a-vyX7VCS2poJsEnQ@mail.gmail.com>
Message-ID: <CA+FuTSfqyxCg5okPDHYwQsKUOCEVFOkf0a-vyX7VCS2poJsEnQ@mail.gmail.com>
Subject: Re: [net] 0b726f6b31: BUG:unable_to_handle_page_fault_for_address
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        0day robot <lkp@intel.com>, lkp@lists.01.org,
        kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 8:07 AM Alexander Lobakin <alobakin@pm.me> wrote:
>
> From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Date: Fri, 13 Nov 2020 10:51:36 -0500
>
> Hi!
>
> > On Fri, Nov 13, 2020 at 7:00 AM kernel test robot <oliver.sang@intel.com> wrote:
> >>
> >>
> >> Greeting,
> >>
> >> FYI, we noticed the following commit (built with gcc-9):
> >>
> >> commit: 0b726f6b318a07644b6c2388e6e44406740f4754 ("[PATCH v3 net] net: udp: fix Fast/frag0 UDP GRO")
> >> url: https://github.com/0day-ci/linux/commits/Alexander-Lobakin/net-udp-fix-Fast-frag0-UDP-GRO/20201110-052215
> >> base: https://git.kernel.org/cgit/linux/kernel/git/davem/net.git 4e0396c59559264442963b349ab71f66e471f84d
> >>
> >> in testcase: apachebench
> >> version:
> >> with following parameters:
> >>
> >>         runtime: 300s
> >>         concurrency: 2000
> >>         cluster: cs-localhost
> >>         cpufreq_governor: performance
> >>         ucode: 0x7000019
> >>
> >> test-description: apachebench is a tool for benchmarking your Apache Hypertext Transfer Protocol (HTTP) server.
> >> test-url: https://httpd.apache.org/docs/2.4/programs/ab.html
> >>
> >>
> >> on test machine: 16 threads Intel(R) Xeon(R) CPU D-1541 @ 2.10GHz with 48G memory
> >>
> >> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> >>
> >>
> >> If you fix the issue, kindly add following tag
> >> Reported-by: kernel test robot <oliver.sang@intel.com>
> >>
> >>
> >> [   28.582714] BUG: unable to handle page fault for address: fffffffffffffffa
> >> [   28.590164] #PF: supervisor read access in kernel mode
> >> [   28.590164] #PF: error_code(0x0000) - not-present page
> >> [   28.590165] PGD c7e20d067 P4D c7e20d067 PUD c7e20f067 PMD 0
> >> [   28.590169] Oops: 0000 [#1] SMP PTI
> >> [   28.590171] CPU: 15 PID: 0 Comm: swapper/15 Not tainted 5.10.0-rc2-00373-g0b726f6b318a #1
> >> [   28.590172] Hardware name: Supermicro SYS-5018D-FN4T/X10SDV-8C-TLN4F, BIOS 1.1 03/02/2016
> >> [   28.590177] RIP: 0010:__udp4_lib_rcv+0x547/0xbe0
> >> [   28.590178] Code: 74 0a f6 45 3c 80 74 04 44 8b 4d 28 48 8b 55 58 48 83 e2 fe 74 07 8b 52 7c 85 d2 75 06 8b 95 90 00 00 00 48 8b be f0 04 00 00 <44> 8b 58 0c 8b 48 10 55 41 55 44 89 de 41 51 41 89 d1 44 89 d2 e8
> >> [   28.590179] RSP: 0018:ffffc900003b4bb8 EFLAGS: 00010246
> >> [   28.590180] RAX: ffffffffffffffee RBX: 0000000000000011 RCX: ffff888c7bc580e2
> >> [   28.590181] RDX: 0000000000000002 RSI: ffff88810ddc8000 RDI: ffffffff82d68f00
> >> [   28.590182] RBP: ffff888c7bf8f800 R08: 00000000000003b7 R09: 0000000000000000
> >> [   28.590182] R10: 0000000000003500 R11: 0000000000000000 R12: ffff888c7bc580e2
> >> [   28.590183] R13: ffffffff82e072b0 R14: ffffffff82d68f00 R15: 0000000000000034
> >> [   28.590184] FS:  0000000000000000(0000) GS:ffff888c7fdc0000(0000) knlGS:0000000000000000
> >> [   28.590185] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [   28.590186] CR2: fffffffffffffffa CR3: 0000000c7e20a006 CR4: 00000000003706e0
> >> [   28.590186] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >> [   28.590187] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >> [   28.590187] Call Trace:
> >> [   28.590189]  <IRQ>
> >> [   28.590193]  ip_protocol_deliver_rcu+0xc5/0x1c0
> >> [   28.590196]  ip_local_deliver_finish+0x4b/0x60
> >> [   28.738714]  ip_local_deliver+0x6e/0x140
> >> [   28.738717]  ip_sublist_rcv_finish+0x57/0x80
> >> [   28.738719]  ip_sublist_rcv+0x199/0x240
> >> [   28.750730]  ip_list_rcv+0x13a/0x160
> >> [   28.750733]  __netif_receive_skb_list_core+0x2a9/0x2e0
> >> [   28.750736]  netif_receive_skb_list_internal+0x1d3/0x320
> >> [   28.764743]  gro_normal_list+0x19/0x40
> >> [   28.764747]  napi_complete_done+0x68/0x160
> >> [   28.773197]  igb_poll+0x63/0x320
> >> [   28.773198]  net_rx_action+0x136/0x3a0
> >> [   28.773201]  __do_softirq+0xe1/0x2c3
> >> [   28.773204]  asm_call_irq_on_stack+0x12/0x20
> >> [   28.773205]  </IRQ>
> >> [   28.773208]  do_softirq_own_stack+0x37/0x40
> >> [   28.773211]  irq_exit_rcu+0xd2/0xe0
> >> [   28.773213]  common_interrupt+0x74/0x140
> >> [   28.773216]  asm_common_interrupt+0x1e/0x40
> >> [   28.773219] RIP: 0010:cpuidle_enter_state+0xd2/0x360
> >
> > This was expected. This v3 of the patch has already been superseded by
> > one that addresses this lookup:
>
> Wait. This page fault happens on IP receive, which is performed after
> all GRO processing. At this point, all headers are pulled to skb->head,
> and no GRO helpers are needed to access them.
> The function that causes that, __udp4_lib_rcv(), uses ip_hdr() a lot,
> and it's safe. There should be another questionable point.

Right, patch v3 calls skb_gro_network_header from
__udp4_lib_lookup_skb, which is called from __udp4_lib_rcv, the
function at which the crash is reported.

@@ -534,7 +534,7 @@ static inline struct sock
*__udp4_lib_lookup_skb(struct sk_buff *skb,
                                                 __be16 sport, __be16 dport,
                                                 struct udp_table *udptable)
 {
-       const struct iphdr *iph = ip_hdr(skb);
+       const struct iphdr *iph = skb_gro_network_header(skb);
