Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBCD304A26
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbhAZFMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729153AbhAYN56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:57:58 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF231C061574
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 05:56:47 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id w124so14830340oia.6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 05:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vkp2wGMrEMpza61Kw+HQF995USykfsp4HRFBjqAA1rE=;
        b=GNH/lB06pt0q1zOm5yQa1SUPShjddpsi+xKCkiq7dH5GIiuO3JHsBSfSktobChuCQV
         kQlHxyh5FPkrKkeTmQMwQAHl6bshbdxFpQDn8L6HcCdvlpFLJ69xTgIbYDmak1vIzjPA
         4BEZIfgnMO2DFzqvA1S6pszjpm8/CyCncWqX6+0JW26how2PunH6o2bCilXl4Sn3Xxtb
         mOXgY13bvckMnAvZ2IJR9rB2ZNJyOY+JYdNwvtXA6doEoiKCtNj9LWiGLp1GovzKRZ2s
         +77T1g0AbLGwtLOc3cibMSy2jRnMaJtFsHF50kJdr5ZYxdisQBARejTxbnEtbtVCTicM
         P02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vkp2wGMrEMpza61Kw+HQF995USykfsp4HRFBjqAA1rE=;
        b=HRwml7nNBFQc5pzFnoiEeP7AFGZHSkZ5gP8IqDi7n5RQ4cILLYOe1/d3ptTYDcEH4A
         dQN0ZLvc8T7QwOWfNFMTU9Zy0nk05cuEHcU5Pw3Yk5IrjX35lROVa/YloolwRuTtqW/A
         ecAi/YnmTItvwhOlMRSMBb7JJOScvy6+6DRoIZZYndaJvQ8veIbAmmucNVH3SfBKz0q7
         d309rjV/w0P3H3qsFTw7UB3PPo017qT4tf8dbZL4oGVhFviC6z59yZtrWws8yiS5d1nW
         s/D2xW2Zubj1BVeuATxpqxKPUTV4p4wqK2PnvTQsH9w/x3WQKCU1wh0jWmIXQdHta83T
         j0gQ==
X-Gm-Message-State: AOAM532IHeSmPaw1EoImC2u5fG+VSS6BXzWR6BvTMZ8UtCpvBilWbH7z
        kYWqbjK0y8IOwa6SjxVJzhEFKxa37j029rrj2w==
X-Google-Smtp-Source: ABdhPJyAPs9HAmo+zyipaqJ2kUTmdFf1JmeubyOdhU4/YqKYR+dG78vSatAKERdX/tumjU0TJAIQadbbrKBjjYfI+PU=
X-Received: by 2002:a05:6808:8e7:: with SMTP id d7mr157786oic.127.1611583006803;
 Mon, 25 Jan 2021 05:56:46 -0800 (PST)
MIME-Version: 1.0
References: <20210122155948.5573-1-george.mccollister@gmail.com>
 <20210122155948.5573-3-george.mccollister@gmail.com> <27b8f3f2-a295-6960-2df5-3ee5e457fea3@gmail.com>
 <1c8833b8-12db-fd5d-0db2-532b9197a0a5@gmail.com> <20210122184811.7asicloltgnshddt@primarily>
 <20210124084314.mwcx47poyw3gwybc@skbuf>
In-Reply-To: <20210124084314.mwcx47poyw3gwybc@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 25 Jan 2021 07:56:34 -0600
Message-ID: <CAFSKS=NZxV5r25SrAZ2E0fgUKJf-gEiP8N-knD7NiK3jrjzR2A@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 2/3] net: hsr: add DSA offloading support
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Nishanth Menon <nm@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 2:43 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
[snip]
>
> I would like to give HSR a spin to get a better idea of what you're doing, but
> it's kinda hard when this happens out of the box, with none of your changes
> already:
>
> [ 1385.000453] hsr0: hw csum failure
> [ 1385.004105] skb len=333 headroom=78 headlen=333 tailroom=293
> [ 1385.004105] mac=(64,14) net=(78,20) trans=98
> [ 1385.004105] shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
> [ 1385.004105] csum(0x14a00 ip_summed=2 complete_sw=0 valid=0 level=0)
> [ 1385.004105] hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=1 iif=16
> [ 1385.032520] dev name=hsr0 feat=0x0x0000000000007400
> [ 1385.037496] skb headroom: 00000000: 44 00 00 02 18 00 00 06 ef 00 00 00 b4 da ff ff
> [ 1385.045257] skb headroom: 00000010: ff ff ff ff 00 04 9f 05 de 0a 81 00 08 00 08 00
> [ 1385.053013] skb headroom: 00000020: 45 00 01 4d e1 e0 00 00 40 11 97 c0 00 00 00 00
> [ 1385.060767] skb headroom: 00000030: ff ff ff ff 00 44 00 43 01 39 f3 8a 01 01 06 00
> [ 1385.068521] skb headroom: 00000040: ff ff ff ff ff ff 00 04 9f 05 f4 ab 08 00
> [ 1385.075753] skb linear:   00000000: 45 00 01 4d f4 b2 00 00 40 11 84 ee 00 00 00 00
> [ 1385.083508] skb linear:   00000010: ff ff ff ff 00 44 00 43 01 39 e7 0e 01 01 06 00
> [ 1385.091262] skb linear:   00000020: 90 5c 56 3c 00 7c 00 00 00 00 00 00 00 00 00 00
> [ 1385.099116] skb linear:   00000030: 00 00 00 00 00 00 00 00 00 04 9f 05 f4 ab 00 00
> [ 1385.106874] skb linear:   00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.114628] skb linear:   00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.122380] skb linear:   00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.130132] skb linear:   00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.137883] skb linear:   00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.145635] skb linear:   00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.153386] skb linear:   000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.161139] skb linear:   000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.168890] skb linear:   000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.176641] skb linear:   000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.184392] skb linear:   000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.192144] skb linear:   000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.199896] skb linear:   00000100: 00 00 00 00 00 00 00 00 63 82 53 63 35 01 01 3d
> [ 1385.207730] skb linear:   00000110: 13 ff 9f 05 f4 ab 00 01 00 01 26 da 82 ac 00 04
> [ 1385.215566] skb linear:   00000120: 9f 05 de 0a 50 00 74 01 01 39 02 05 ba 0c 0a 4c
> [ 1385.223323] skb linear:   00000130: 53 31 30 32 38 41 52 44 42 91 01 01 37 0e 01 79
> [ 1385.231075] skb linear:   00000140: 21 03 06 0c 0f 1a 1c 33 36 3a 3b 77 ff
> [ 1385.238042] skb tailroom: 00000000: 32 39 30 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.245795] skb tailroom: 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.253547] skb tailroom: 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.261298] skb tailroom: 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.269050] skb tailroom: 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.276801] skb tailroom: 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.284553] skb tailroom: 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.292304] skb tailroom: 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.300110] skb tailroom: 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.307864] skb tailroom: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.315615] skb tailroom: 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.323367] skb tailroom: 000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.331119] skb tailroom: 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.338871] skb tailroom: 000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.346622] skb tailroom: 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.354373] skb tailroom: 000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.362124] skb tailroom: 00000100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.369875] skb tailroom: 00000110: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1385.377626] skb tailroom: 00000120: 00 00 00 00 00
> [ 1385.382504] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.11.0-rc4+ #410
> [ 1385.389117] Hardware name: LS1028A RDB Board (DT)
> [ 1385.393885] Call trace:
> [ 1385.396380]  dump_backtrace+0x0/0x1f0
> [ 1385.400130]  show_stack+0x24/0x80
> [ 1385.403516]  dump_stack+0xf8/0x168
> [ 1385.406990]  netdev_rx_csum_fault.part.0+0x54/0x64
> [ 1385.411861]  netdev_rx_csum_fault+0x48/0x50
> [ 1385.416119]  __skb_checksum_complete+0x110/0x120
> [ 1385.420811]  nf_ip_checksum+0x88/0x160
> [ 1385.424636]  nf_checksum+0x58/0x70
> [ 1385.428110]  nf_conntrack_udp_packet+0x194/0x2a0
> [ 1385.432807]  nf_conntrack_in+0x148/0x7d0
> [ 1385.436800]  ipv4_conntrack_in+0x24/0x30
> [ 1385.440797]  nf_hook_slow+0x58/0x100
> [ 1385.444443]  ip_rcv+0x13c/0x210
> [ 1385.447654]  __netif_receive_skb_one_core+0x60/0x90
> [ 1385.452603]  __netif_receive_skb+0x20/0x70
> [ 1385.456764]  process_backlog+0x138/0x2e4
> [ 1385.460753]  net_rx_action+0x12c/0x424
> [ 1385.464566]  __do_softirq+0x1f4/0x630
> [ 1385.468291]  __irq_exit_rcu+0x194/0x1c0
> [ 1385.472199]  irq_exit+0x1c/0x4c
> [ 1385.475407]  __handle_domain_irq+0x8c/0xec
> [ 1385.479574]  gic_handle_irq+0xcc/0x14c
> [ 1385.483386]  el1_irq+0xb4/0x180
> [ 1385.486589]  cpuidle_enter_state+0xdc/0x31c
> [ 1385.490844]  cpuidle_enter+0x44/0x5c
> [ 1385.494486]  do_idle+0x240/0x2d0
> [ 1385.497775]  cpu_startup_entry+0x30/0x8c
> [ 1385.501762]  rest_init+0x1b8/0x28c
> [ 1385.505226]  arch_call_rest_init+0x1c/0x28
> [ 1385.509397]  start_kernel+0x580/0x5b8

Yikes! I never ran into this on any of the hardware I tested on.

-George
