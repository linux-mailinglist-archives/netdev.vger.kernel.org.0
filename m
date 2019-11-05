Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6ECEF1AF
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 01:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbfKEALN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 19:11:13 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45112 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729863AbfKEALN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 19:11:13 -0500
Received: by mail-pf1-f194.google.com with SMTP id z4so7728351pfn.12
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 16:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:subject:in-reply-to:references:date:message-id:mime-version;
        bh=FGYA88uNEcJykVhSbccThExUs6NC0aEqf9Phs6SxNGQ=;
        b=KxV5hg3uuWFy9/TeH0EB9sUH0UQScp4XvNf0z6bH5R0jj966X8txVGWIx1r+XkvnHI
         Gf/wnT+Lfonrb+BCY0O3G7pQwI5XdpRaPNTm3Vv/LPaQgnDRY5auUAuVwMAhYHpfadG6
         4VQXwYNdBCkZIPI5Nmru9FsKLJEK4JM/wfLgo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FGYA88uNEcJykVhSbccThExUs6NC0aEqf9Phs6SxNGQ=;
        b=gRhT6IdkF4ptKFQCo+hMm3pvtr8y0+5WY2M51rLuVqDUuSpYPG7Cb4KEFzqwgMaPSe
         qzjLOchNwY2rBshqGV8QE46QrDbSasm/mw7q8QdNGduDqlJYhhQ2YdVzYEXfFGTSl7jN
         Kgtq1zLT/PauB3gPG6b2Bszy3Nu6VLXNjFPtFgy+GfGa4l/mw0/eE5EnTW8IhaVZy85r
         ZlXHLFSCc5yuvbKYb5LNRT8mlOPLgIsUJzzGctVCGVVe+L4f0vXG5HsZ3kD22KMVKao4
         j056owO70mnIWtgEXx1Y+B/fMxlOiOWmt7kD/nwXTTrYuAZtiwcdJwSb1so7nSJ6WvW3
         Z4Qw==
X-Gm-Message-State: APjAAAWthNNFv5nM8XgREAdO8JNLoUck03eHzbsGruNFo7oltynib9tt
        nkLwiS1Qd1LxP9+P/zREIUZ71g==
X-Google-Smtp-Source: APXvYqwgwTBHQ4nLYIQKzDc7soViw5YJoY1O6ZPozN476TqWg47nkbsQx4t8+JWLNzqGXl4mNPi7hg==
X-Received: by 2002:a62:be0c:: with SMTP id l12mr23045117pff.256.1572912672397;
        Mon, 04 Nov 2019 16:11:12 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-40d3-eca3-e70b-6bc4.static.ipv6.internode.on.net. [2001:44b8:1113:6700:40d3:eca3:e70b:6bc4])
        by smtp.gmail.com with ESMTPSA id d9sm16781675pgc.80.2019.11.04.16.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 16:11:11 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Ramana Reddy <gtvrreddy@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, inux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: gso packet is failing with af_packet socket with packet_vnet_hdr
In-Reply-To: <CAL2CrsOE1Td1NTSava-0O4wJ0kr+i4FA_cRwNcPH9Nt9dTmnVQ@mail.gmail.com>
References: <CAL2CrsOE1Td1NTSava-0O4wJ0kr+i4FA_cRwNcPH9Nt9dTmnVQ@mail.gmail.com>
Date:   Tue, 05 Nov 2019 11:11:07 +1100
Message-ID: <87wocfkwro.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ramana,

> Some more info:
> [root@xx ~]# uname -r
> 3.10.0-1062.4.1.el7.x86_64
> [root@xx ~]# cat /etc/redhat-release
> Red Hat Enterprise Linux Server release 7.7 (Maipo)

Are you able to reproduce your issue with an upstream kernel? If you
have a problem with a vendor kernel - especially one based on a kernel
that old - you will need to talk to your vendor. If you can reproduce it
on an upstream kernel, then I might be able to help.

Regards,
Daniel


> [root@xx]# ovs-vsctl --version
> ovs-vsctl (Open vSwitch) 2.9.0
> DB Schema 7.15.1
>
> And dump_stack output with af_packet:
> [ 4833.637460]  <IRQ>  [<ffffffff81979612>] dump_stack+0x19/0x1b
> [ 4833.637474]  [<ffffffff8197c3ca>] ip_fragment.constprop.55+0xc3/0x141
> [ 4833.637481]  [<ffffffff8189dd84>] ip_finish_output+0x314/0x350
> [ 4833.637484]  [<ffffffff8189eb83>] ip_output+0xb3/0x130
> [ 4833.637490]  [<ffffffff8189da70>] ? ip_do_fragment+0x910/0x910
> [ 4833.637493]  [<ffffffff8189cac9>] ip_local_out_sk+0xf9/0x180
> [ 4833.637497]  [<ffffffff818e6f6c>] iptunnel_xmit+0x18c/0x220
> [ 4833.637505]  [<ffffffffc073b2e7>] udp_tunnel_xmit_skb+0x117/0x130
> [udp_tunnel]
> [ 4833.637538]  [<ffffffffc074585a>] vxlan_xmit_one+0xb6a/0xb70 [vxlan]
> [ 4833.637545]  [<ffffffff8129dad9>] ? vprintk_default+0x29/0x40
> [ 4833.637551]  [<ffffffffc074765e>] vxlan_xmit+0xc9e/0xef0 [vxlan]
> [ 4833.637555]  [<ffffffff818356e7>] ? kfree_skbmem+0x37/0x90
> [ 4833.637559]  [<ffffffff81836c24>] ? consume_skb+0x34/0x90
> [ 4833.637564]  [<ffffffff819547bc>] ? packet_rcv+0x4c/0x3e0
> [ 4833.637570]  [<ffffffff8184d346>] dev_hard_start_xmit+0x246/0x3b0
> [ 4833.637574]  [<ffffffff81850339>] __dev_queue_xmit+0x519/0x650
> [ 4833.637580]  [<ffffffff812d9df0>] ? try_to_wake_up+0x190/0x390
> [ 4833.637585]  [<ffffffff81850480>] dev_queue_xmit+0x10/0x20
> [ 4833.637592]  [<ffffffffc0724316>] ovs_vport_send+0xa6/0x180 [openvswitch]
> [ 4833.637599]  [<ffffffffc07150fe>] do_output+0x4e/0xd0 [openvswitch]
> [ 4833.637604]  [<ffffffffc0716699>] do_execute_actions+0xa29/0xa40
> [openvswitch]
> [ 4833.637610]  [<ffffffff812d24d2>] ? __wake_up_common+0x82/0x120
> [ 4833.637615]  [<ffffffffc0716aac>] ovs_execute_actions+0x4c/0x140
> [openvswitch]
> [ 4833.637621]  [<ffffffffc071a824>] ovs_dp_process_packet+0x84/0x120
> [openvswitch]
> [ 4833.637627]  [<ffffffffc0725404>] ? ovs_ct_update_key+0xc4/0x150
> [openvswitch]
> [ 4833.637633]  [<ffffffffc0724213>] ovs_vport_receive+0x73/0xd0
> [openvswitch]
> [ 4833.637638]  [<ffffffff812d666f>] ? ttwu_do_activate+0x6f/0x80
> [ 4833.637642]  [<ffffffff812d9df0>] ? try_to_wake_up+0x190/0x390
> [ 4833.637646]  [<ffffffff812da0c2>] ? default_wake_function+0x12/0x20
> [ 4833.637651]  [<ffffffff812c61eb>] ? autoremove_wake_function+0x2b/0x40
> [ 4833.637657]  [<ffffffff812d24d2>] ? __wake_up_common+0x82/0x120
> [ 4833.637661]  [<ffffffff812e3ae9>] ? update_cfs_shares+0xa9/0xf0
> [ 4833.637665]  [<ffffffff812e3696>] ? update_curr+0x86/0x1e0
> [ 4833.637669]  [<ffffffff812dee88>] ? __enqueue_entity+0x78/0x80
> [ 4833.637677]  [<ffffffffc0724cbe>] netdev_frame_hook+0xde/0x180
> [openvswitch]
> [ 4833.637682]  [<ffffffff8184d6aa>] __netif_receive_skb_core+0x1fa/0xa10
> [ 4833.637688]  [<ffffffffc0724be0>] ? vport_netdev_free+0x30/0x30
> [openvswitch]
> [ 4833.637692]  [<ffffffff812d6539>] ? ttwu_do_wakeup+0x19/0xe0
> [ 4833.637697]  [<ffffffff8184ded8>] __netif_receive_skb+0x18/0x60
> [ 4833.637703]  [<ffffffff8184ee9e>] process_backlog+0xae/0x180
> [ 4833.637707]  [<ffffffff8184e57f>] net_rx_action+0x26f/0x390
> [ 4833.637713]  [<ffffffff812a41e5>] __do_softirq+0xf5/0x280
> [ 4833.637719]  [<ffffffff8199042c>] call_softirq+0x1c/0x30
> [ 4833.637723]  <EOI>  [<ffffffff8122f675>] do_softirq+0x65/0xa0
> [ 4833.637730]  [<ffffffff812a363b>] __local_bh_enable_ip+0x9b/0xb0
> [ 4833.637735]  [<ffffffff812a3667>] local_bh_enable+0x17/0x20
> [ 4833.637741]  [<ffffffff81850065>] __dev_queue_xmit+0x245/0x650
> [ 4833.637746]  [<ffffffff81972e28>] ? printk+0x60/0x77
> [ 4833.637752]  [<ffffffff81850480>] dev_queue_xmit+0x10/0x20
> [ 4833.637757]  [<ffffffff81957a75>] packet_sendmsg+0xf65/0x1210
> [ 4833.637761]  [<ffffffff813d7524>] ? shmem_fault+0x84/0x1f0
> [ 4833.637768]  [<ffffffff8182d3a6>] sock_sendmsg+0xb6/0xf0
> [ 4833.637772]  [<ffffffff812e3696>] ? update_curr+0x86/0x1e0
> [ 4833.637777]  [<ffffffff812e3ae9>] ? update_cfs_shares+0xa9/0xf0
> [ 4833.637781]  [<ffffffff8122b621>] ? __switch_to+0x151/0x580
> [ 4833.637786]  [<ffffffff8182dad1>] SYSC_sendto+0x121/0x1c0
> [ 4833.637793]  [<ffffffff812c8d10>] ? hrtimer_get_res+0x50/0x50
> [ 4833.637797]  [<ffffffff8197e54b>] ? do_nanosleep+0x5b/0x100
> [ 4833.637802]  [<ffffffff8182f5ee>] SyS_sendto+0xe/0x10
> [ 4833.637806]  [<ffffffff8198cede>] system_call_fastpath+0x25/0x2a
>
> Looking forward to your reply.
>
> Regards,
> Ramana
