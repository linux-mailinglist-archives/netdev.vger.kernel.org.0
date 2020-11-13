Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65EF2B1F39
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 16:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgKMPwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 10:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgKMPwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 10:52:33 -0500
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C5AC0617A6
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 07:52:26 -0800 (PST)
Received: by mail-vs1-xe44.google.com with SMTP id f7so5414617vsh.10
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 07:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pDAgwKMitaAWFC4jbQvzCfSXWaMHu4F1VWRWRkf2F9w=;
        b=U72jvX/hsqVzw3jlQZ8fQJuG2QhjmRNj2Vx6gjyaj4GW5OZYxiUinAbfX2n+L3+fvu
         WX26BKgaTpZujLvmIh3HTswYK2ogos3GoIXrKx8qIWxOTD868HBMoNWANhNU/XSHnYzw
         +hnp6kzQVxeconfWB7o9gT2cGAoXFqTeuD7m5OAbKYoqNIYPUDj+RklPXCKd5fHmNdDX
         1j8hpKtPmScngjoDwtp/nbFbCKC1q9/+YBWiA6e49tgPYQm6QYTkDXZ7WKj8a5X5cuJ/
         P7s7AA8lRdFhIYJJn+rXR3FnNnbTMZFhKckMtZB6ZUQ9xq/xcAMKAeE4Bi8QgGbtaBTO
         oQEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pDAgwKMitaAWFC4jbQvzCfSXWaMHu4F1VWRWRkf2F9w=;
        b=oir1a2OkpbzhPMIbkhNj3tTv+DSin7ZLKQqrqjWfDcjYRhzZdI1SoGHH3HgGPpfH3Y
         fJOaZG14wSntuQMi7S+GcGSn53V1+H9NOLjig5Sqle9Cq6L7+sxG8/xsuJ5AnwwTEhJ6
         D2SCQ5IccRxHvjwpyj2yr/mUAtBvTrX4O7aGv2nFCZsOnxDx+0DAZU6ob01LesoBqXXf
         llX0r5o3jzkAp419BgoDIi8qobgFgUXYuxmyWpySiBtiE7090meZE0dNNLE+luvoyFvq
         3YayYMeNrsJrxbeTem20bar02l/8f5qVi7VZjxf6EUOeDlCcJZv50C9rW1DhgVyA0qAJ
         sbGQ==
X-Gm-Message-State: AOAM530E1CShf+ysP3CvBUQFMhpBCezUWis3c3uRtCWgSBb1ssRHkZs/
        X8WFXytWTY83bJg7OaJ2i++vCwLgP5k=
X-Google-Smtp-Source: ABdhPJzCSzGZrHkadfDvlycZzSseAvEDmNCT/6CPJ6xuKq7ivNHrjPmxrISR6QK2XEvuii3wX7YpVA==
X-Received: by 2002:a67:2a41:: with SMTP id q62mr1669492vsq.39.1605282740296;
        Fri, 13 Nov 2020 07:52:20 -0800 (PST)
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com. [209.85.222.41])
        by smtp.gmail.com with ESMTPSA id a8sm1040243vsp.4.2020.11.13.07.52.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 07:52:20 -0800 (PST)
Received: by mail-ua1-f41.google.com with SMTP id q4so3133171ual.8
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 07:52:19 -0800 (PST)
X-Received: by 2002:ab0:6dd1:: with SMTP id r17mr1444960uaf.108.1605282734337;
 Fri, 13 Nov 2020 07:52:14 -0800 (PST)
MIME-Version: 1.0
References: <MgZce9htmEtCtHg7pmWxXXfdhmQ6AHrnltXC41zOoo@cp7-web-042.plabs.ch> <20201113121502.GB7578@xsang-OptiPlex-9020>
In-Reply-To: <20201113121502.GB7578@xsang-OptiPlex-9020>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 13 Nov 2020 10:51:36 -0500
X-Gmail-Original-Message-ID: <CA+FuTSccV-DNMOqr0hy5q3fZak8=eWYYDNigo8EnG2GV6X1Stw@mail.gmail.com>
Message-ID: <CA+FuTSccV-DNMOqr0hy5q3fZak8=eWYYDNigo8EnG2GV6X1Stw@mail.gmail.com>
Subject: Re: [net] 0b726f6b31: BUG:unable_to_handle_page_fault_for_address
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        0day robot <lkp@intel.com>, lkp@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 7:00 AM kernel test robot <oliver.sang@intel.com> wrote:
>
>
> Greeting,
>
> FYI, we noticed the following commit (built with gcc-9):
>
> commit: 0b726f6b318a07644b6c2388e6e44406740f4754 ("[PATCH v3 net] net: udp: fix Fast/frag0 UDP GRO")
> url: https://github.com/0day-ci/linux/commits/Alexander-Lobakin/net-udp-fix-Fast-frag0-UDP-GRO/20201110-052215
> base: https://git.kernel.org/cgit/linux/kernel/git/davem/net.git 4e0396c59559264442963b349ab71f66e471f84d
>
> in testcase: apachebench
> version:
> with following parameters:
>
>         runtime: 300s
>         concurrency: 2000
>         cluster: cs-localhost
>         cpufreq_governor: performance
>         ucode: 0x7000019
>
> test-description: apachebench is a tool for benchmarking your Apache Hypertext Transfer Protocol (HTTP) server.
> test-url: https://httpd.apache.org/docs/2.4/programs/ab.html
>
>
> on test machine: 16 threads Intel(R) Xeon(R) CPU D-1541 @ 2.10GHz with 48G memory
>
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
>
>
> If you fix the issue, kindly add following tag
> Reported-by: kernel test robot <oliver.sang@intel.com>
>
>
> [   28.582714] BUG: unable to handle page fault for address: fffffffffffffffa
> [   28.590164] #PF: supervisor read access in kernel mode
> [   28.590164] #PF: error_code(0x0000) - not-present page
> [   28.590165] PGD c7e20d067 P4D c7e20d067 PUD c7e20f067 PMD 0
> [   28.590169] Oops: 0000 [#1] SMP PTI
> [   28.590171] CPU: 15 PID: 0 Comm: swapper/15 Not tainted 5.10.0-rc2-00373-g0b726f6b318a #1
> [   28.590172] Hardware name: Supermicro SYS-5018D-FN4T/X10SDV-8C-TLN4F, BIOS 1.1 03/02/2016
> [   28.590177] RIP: 0010:__udp4_lib_rcv+0x547/0xbe0
> [   28.590178] Code: 74 0a f6 45 3c 80 74 04 44 8b 4d 28 48 8b 55 58 48 83 e2 fe 74 07 8b 52 7c 85 d2 75 06 8b 95 90 00 00 00 48 8b be f0 04 00 00 <44> 8b 58 0c 8b 48 10 55 41 55 44 89 de 41 51 41 89 d1 44 89 d2 e8
> [   28.590179] RSP: 0018:ffffc900003b4bb8 EFLAGS: 00010246
> [   28.590180] RAX: ffffffffffffffee RBX: 0000000000000011 RCX: ffff888c7bc580e2
> [   28.590181] RDX: 0000000000000002 RSI: ffff88810ddc8000 RDI: ffffffff82d68f00
> [   28.590182] RBP: ffff888c7bf8f800 R08: 00000000000003b7 R09: 0000000000000000
> [   28.590182] R10: 0000000000003500 R11: 0000000000000000 R12: ffff888c7bc580e2
> [   28.590183] R13: ffffffff82e072b0 R14: ffffffff82d68f00 R15: 0000000000000034
> [   28.590184] FS:  0000000000000000(0000) GS:ffff888c7fdc0000(0000) knlGS:0000000000000000
> [   28.590185] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   28.590186] CR2: fffffffffffffffa CR3: 0000000c7e20a006 CR4: 00000000003706e0
> [   28.590186] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   28.590187] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   28.590187] Call Trace:
> [   28.590189]  <IRQ>
> [   28.590193]  ip_protocol_deliver_rcu+0xc5/0x1c0
> [   28.590196]  ip_local_deliver_finish+0x4b/0x60
> [   28.738714]  ip_local_deliver+0x6e/0x140
> [   28.738717]  ip_sublist_rcv_finish+0x57/0x80
> [   28.738719]  ip_sublist_rcv+0x199/0x240
> [   28.750730]  ip_list_rcv+0x13a/0x160
> [   28.750733]  __netif_receive_skb_list_core+0x2a9/0x2e0
> [   28.750736]  netif_receive_skb_list_internal+0x1d3/0x320
> [   28.764743]  gro_normal_list+0x19/0x40
> [   28.764747]  napi_complete_done+0x68/0x160
> [   28.773197]  igb_poll+0x63/0x320
> [   28.773198]  net_rx_action+0x136/0x3a0
> [   28.773201]  __do_softirq+0xe1/0x2c3
> [   28.773204]  asm_call_irq_on_stack+0x12/0x20
> [   28.773205]  </IRQ>
> [   28.773208]  do_softirq_own_stack+0x37/0x40
> [   28.773211]  irq_exit_rcu+0xd2/0xe0
> [   28.773213]  common_interrupt+0x74/0x140
> [   28.773216]  asm_common_interrupt+0x1e/0x40
> [   28.773219] RIP: 0010:cpuidle_enter_state+0xd2/0x360

This was expected. This v3 of the patch has already been superseded by
one that addresses this lookup:

> @@ -534,7 +534,7 @@ static inline struct sock *__udp4_lib_lookup_skb(struct sk_buff *skb,
>                                                  __be16 sport, __be16 dport,
>                                                  struct udp_table *udptable)
>  {
> -       const struct iphdr *iph = ip_hdr(skb);
> +       const struct iphdr *iph = skb_gro_network_header(skb);

The merged version was v5 and lacks this change.
