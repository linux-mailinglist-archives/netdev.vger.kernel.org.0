Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F5A39CA27
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 19:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhFERSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 13:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhFERSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 13:18:06 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1587C061766
        for <netdev@vger.kernel.org>; Sat,  5 Jun 2021 10:16:17 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id u24so14851117edy.11
        for <netdev@vger.kernel.org>; Sat, 05 Jun 2021 10:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=33LLrKNwtNeC8taTRgqwjkos//0SmQGo8gnzun3eCe0=;
        b=oi6qMcMRlvwyGUVjAjZfzJ15jrb4p89gYINcWf0K2GLx/IJY81Az7MRqN8LtGUOBr0
         9pdKdyjP2lt5pQjNQBZu9RAW+0889wShsLuGXe26pcMxYbgQSYs4N0essDeRnWlvUVwl
         09abRTAkwW5Ulj/NGMG1ArtZ+U0A4ewV4pcJd2qXJZjPt47RB5KQ+SwzOvnphf0xWgct
         kbnIx2ilok0HclZ6/BuVpI0qbQQ/EBrmpjJ+Rk/sA/1uX3wxmJkzAZt8Iwp5kZfFdUhN
         NuUKS0Rtdk3U0D2uszF6ptlHOKAz11fRQ+hr/SWTN1mUfVWld8hw65UHmrsQxaDNYyKk
         LGsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=33LLrKNwtNeC8taTRgqwjkos//0SmQGo8gnzun3eCe0=;
        b=lJT8LX2UXNiqC4XWi0FR2y8ELxMAKThHIqJ3TXti8VX/hOrI3IubtRvtUT9CgSgWup
         835Q0vw7/Jbc8OQJ26M0QgA7PT48G6+4VaGIat/0s0hZJmdmHSunA0qfM7IBt1zXLgc/
         9V6MWjVn8zFTxSQS9hkX5osZh87fUN3B2eSov+5lo3i5HWGpwEW0neHumlc53Hngv7hX
         1qyOHPKdDJO7gFnolgYD8oJ/MezA1ZA56fm9jZU607etZvA8k1eTLj1itxe7b6uboB4W
         zhIOOvZfmdyOKl19d3onEse33ZvjZIGucN2FjS445Hi8TB4spFKAfMelrkeCFVrLAb+0
         ZoZA==
X-Gm-Message-State: AOAM532XblAivKsc6w9EZ3KX3eoVGoveZmOdxS7MKWDWv/svpo5TEmSv
        YEVmUgWO9IUsfhJXnwYyX9m90fmqe98log==
X-Google-Smtp-Source: ABdhPJyfoPv8+Ler83HkiLpjCGAQq8Js9A82CPpxx7SrKduWUqz9DK6OmmPLV4k2398f9Fc/Vdj6Qw==
X-Received: by 2002:a05:6402:14d8:: with SMTP id f24mr2270291edx.79.1622913376456;
        Sat, 05 Jun 2021 10:16:16 -0700 (PDT)
Received: from ?IPv6:2a0f:6480:3:1:d65d:64ff:fed0:4a9d? ([2a0f:6480:3:1:d65d:64ff:fed0:4a9d])
        by smtp.gmail.com with ESMTPSA id zb19sm4314566ejb.120.2021.06.05.10.16.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Jun 2021 10:16:15 -0700 (PDT)
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Subject: VRF/IPv4/ARP: unregister_netdevice waiting for dev to become free ->
 Who's responsible for releasing dst_entry created by ip_route_input_noref?
To:     Network Development <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, David Ahern <dsahern@gmail.com>
Message-ID: <20cd265b-d52d-fd1f-c47e-bfa7ea15518f@gmail.com>
Date:   Sat, 5 Jun 2021 19:16:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone,

I'm observing an device unregistration issue when I try to delete a VRF interface after using the VRF.
The issue is reproducible on 5.12.9, 5.10.24, 5.11.0-18 (debian).

Here are the steps to reproduce the issue:

ip addr add 10.0.0.1/32 dev lo
ip netns add test-ns
ip link add veth-outside type veth peer name veth-inside
ip link add vrf-100 type vrf table 1100
ip link set veth-outside master vrf-100
ip link set veth-inside netns test-ns
ip link set veth-outside up
ip link set vrf-100 up
ip route add 10.1.1.1/32 dev veth-outside table 1100
ip netns exec test-ns ip link set veth-inside up
ip netns exec test-ns ip addr add 10.1.1.1/32 dev veth-inside
ip netns exec test-ns ip route add 10.0.0.1/32 dev veth-inside
ip netns exec test-ns ip route add default via 10.0.0.1
ip netns exec test-ns ping 10.0.0.1 -c 1 -i 1
sleep 10
ip link set veth-outside nomaster
ip link set vrf-100 down
ip link delete vrf-100 <= Never returns

The issue does not happen when I don't do the ping.

I've tracked down all calls to dev_hold and dev_put.
When the ping command is run there is the following call to dev_hold to which the corresponding dev_put seems to be missing (doesn't even happen when the VRF is set down or deleted):
[  284.528775] CPU: 2 PID: 1205 Comm: ping Not tainted 5.12.9 #1
[  284.528790] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  284.528796] Call Trace:
[  284.528802]  <IRQ>
[  284.528832]  dump_stack+0x7d/0x9c
[  284.528854]  dst_alloc.cold+0x11/0x2a
[  284.528866]  rt_dst_alloc+0x48/0xd0
[  284.528881]  ip_route_input_slow+0x507/0xc80
[  284.528900]  ip_route_input_rcu+0x258/0x270
[  284.528913]  ip_route_input_noref+0x2a/0x50
[  284.528923]  arp_process+0x4da/0x8a0
[  284.528938]  arp_rcv+0x1a9/0x1d0
[  284.528948]  ? trigger_load_balance+0x205/0x240
[  284.528961]  __netif_receive_skb_one_core+0x8d/0xa0
[  284.528974]  __netif_receive_skb+0x18/0x60
[  284.528984]  process_backlog+0xa2/0x170
[  284.528993]  __napi_poll+0x31/0x170
[  284.529002]  net_rx_action+0x22f/0x280
[  284.529012]  __do_softirq+0xce/0x281
[  284.529024]  do_softirq+0x77/0xa0
[  284.529049]  </IRQ>
[  284.529054]  __local_bh_enable_ip+0x50/0x60
[  284.529064]  ip_finish_output2+0x1ab/0x590
[  284.529073]  ? __cgroup_bpf_run_filter_skb+0x3ce/0x3e0
[  284.529086]  __ip_finish_output+0x110/0x270
[  284.529096]  ip_finish_output+0x2d/0xb0
[  284.529105]  ip_output+0x78/0x100
[  284.529114]  ? __ip_finish_output+0x270/0x270
[  284.529122]  ip_push_pending_frames+0xa3/0xb0
[  284.529131]  raw_sendmsg+0x5f0/0xdb0
[  284.529144]  ? setup_min_slab_ratio+0x68/0x90
[  284.529182]  ? __cond_resched+0x1a/0x50
[  284.529195]  ? aa_sk_perm+0x43/0x1b0
[  284.529211]  inet_sendmsg+0x6c/0x70
[  284.529221]  sock_sendmsg+0x5e/0x70
[  284.529234]  __sys_sendto+0x113/0x190
[  284.529249]  ? handle_mm_fault+0xda/0x2c0
[  284.529258]  ? do_user_addr_fault+0x1f5/0x670
[  284.529266]  ? exit_to_user_mode_prepare+0x37/0x190
[  284.529277]  __x64_sys_sendto+0x29/0x30
[  284.529287]  do_syscall_64+0x38/0x90
[  284.529298]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  284.529306] RIP: 0033:0x7f89f02db53a
[  284.529317] Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 f3 0f 1e fa 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 76 c3 0f 1f 44 00 00 55 48 83 ec 30 44 89 4c
[  284.529325] RSP: 002b:00007ffd7c1b0478 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  284.529335] RAX: ffffffffffffffda RBX: 00007ffd7c1b1c00 RCX: 00007f89f02db53a
[  284.529340] RDX: 0000000000000040 RSI: 00005592d86be100 RDI: 0000000000000003
[  284.529345] RBP: 00005592d86be100 R08: 00007ffd7c1b3e7c R09: 0000000000000010
[  284.529349] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000040
[  284.529354] R13: 00007ffd7c1b1bc0 R14: 00007ffd7c1b0480 R15: 0000001d00000001

Processing the incoming ARP request causes a call to ip_route_input_noref => ip_route_input_rcu => ip_route_input_slow => rt_dst_alloc => dst_alloc => dev_hold.
In a non VRF use-case the dst->dev would be the loopback interface that is never deleted. In the VRF use-case dst->dev is the VRF interface. And that one I would like to delete.

I've tracked down that dst_release() would call dev_put() but it seems dst_release is not called here (but should be I guess?). Thus, causing a dst_entry leak that causes the VRF device to be unremovable.
At least that's what it looks like to me.

So: Who's responsible for releasing dst_entry created by ip_route_input_noref in arp_process?

Kind Regards
Oliver
