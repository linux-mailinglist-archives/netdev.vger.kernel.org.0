Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894274E72C8
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 13:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356979AbiCYMNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 08:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358651AbiCYMNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 08:13:13 -0400
Received: from smtp.tom.com (smtprz02.163.net [106.3.154.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0B4ED4C89
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 05:11:35 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id 73CBC440170
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 20:11:33 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648210293; bh=4gBl/8PBTXZHGwyekZf/dxSPXNIksPm2tZrpDmJmeGc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m3HSBprSh7LhJZUiJjiB2ZAjSKaW4/gK3UwPPg8HZEd4vo8FV9aMU1O9MxoApzOQm
         BSp6l9cxtc/+PAbgWlaCzMAvb7J2Hx0yuq2aTo2AT6Odz765FYHs8u6wbIAj2NMYNW
         lqUzOjoTCecAmyHkkzt6tM0bh+85EJqibzSZTG/g=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID -1438044712
          for <netdev@vger.kernel.org>;
          Fri, 25 Mar 2022 20:11:33 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648210293; bh=4gBl/8PBTXZHGwyekZf/dxSPXNIksPm2tZrpDmJmeGc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m3HSBprSh7LhJZUiJjiB2ZAjSKaW4/gK3UwPPg8HZEd4vo8FV9aMU1O9MxoApzOQm
         BSp6l9cxtc/+PAbgWlaCzMAvb7J2Hx0yuq2aTo2AT6Odz765FYHs8u6wbIAj2NMYNW
         lqUzOjoTCecAmyHkkzt6tM0bh+85EJqibzSZTG/g=
Received: from localhost (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id D519F15414FE;
        Fri, 25 Mar 2022 20:11:23 +0800 (CST)
Date:   Fri, 25 Mar 2022 20:11:23 +0800
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH v2 2/3] nvme-tcp: support specifying the
 congestion-control
Message-ID: <20220325201123.00002f28@tom.com>
In-Reply-To: <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
References: <20220311103414.8255-1-sunmingbao@tom.com>
        <20220311103414.8255-2-sunmingbao@tom.com>
        <7121e4be-0e25-dd5f-9d29-0fb02cdbe8de@grimberg.me>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 1. Can you please provide your measurements that support your claims?

Yes. I would provide a series of the testing result.
In the bottom of this mail, I would provide the first one.

> 
> 2. Can you please provide a real, existing use-case where this provides
> true, measureable value? And more specifically, please clarify how the
> use-case needs a local tuning for nvme-tcp that would not hold for
> other tcp streams that are running on the host (and vice-versa).
> 

As for the use-case.
I think multiple NVMe/TCP hosts simultaneously write data to a single target
is a much common use-case.
And this patchset just addresses the performance issue of this use-case.


Now let's see the measurements.

I have got 4 servers with exactly the same HW/SW combination.
Each server has a 50Gb bonding port consisted of 2 25Gb Mellanox ConnectX-4
Lx ports.

Basic SW info:
provo-dirt:~ # cat /etc/os-release 
NAME="SLES"
VERSION="15-SP3"
VERSION_ID="15.3"
PRETTY_NAME="SUSE Linux Enterprise Server 15 SP3"
......
provo-dirt:~ # uname -r
5.14.21-SP4-9c51d4e2+

Test method:
the first 3 servers TX, and the last one RX.
A small program was written to generate the traffic.
It prints the relative and absolute counters per second.
Each round last about 1 minute.


Here is the info and the role of these servers.

No.  NAME            IP                ROLE
1    provo-dirt      169.254.85.1      TX
2    sandy-dirt      169.254.85.2      TX
3    orem-dirt       169.254.85.3      TX
4    ogden-dirt      169.254.85.4      RX


The output looks like this on the TX nodes:

[time lasts]: 1
[conn-num 8][tx on][rx off][msg-len 65536][data-type seq-u64]

[Relative Stat]
        tx_total                            0x7bc6            (31,686)
        tx_total_bytes                      0x7bc60000        (2,076,573,696)
        tx_succ                             0x7bbe            (31,678)
        tx_succ_bytes                       0x7bbe0000        (2,076,049,408)

[Absolute Stat]
        tx_total                            0x7bc6            (31,686)
        tx_total_bytes                      0x7bc60000        (2,076,573,696)
        tx_succ                             0x7bbe            (31,678)
        tx_succ_bytes                       0x7bbe0000        (2,076,049,408)

[time lasts]: 2
[conn-num 8][tx on][rx off][msg-len 65536][data-type seq-u64]

[Relative Stat]
        tx_total                            0x7bfd            (31,741)
        tx_total_bytes                      0x7bfd0000        (2,080,178,176)
        tx_succ                             0x7bfd            (31,741)
        tx_succ_bytes                       0x7bfd0000        (2,080,178,176)

[Absolute Stat]
        tx_total                            0xf7c3            (63,427)
        tx_total_bytes                      0xf7c30000        (4,156,751,872)
        tx_succ                             0xf7bb            (63,419)
        tx_succ_bytes                       0xf7bb0000        (4,156,227,584)

[time lasts]: 3
[conn-num 8][tx on][rx off][msg-len 65536][data-type seq-u64]

[Relative Stat]
        tx_total                            0x7b8b            (31,627)
        tx_total_bytes                      0x7b8b0000        (2,072,707,072)
        tx_succ                             0x7b8b            (31,627)
        tx_succ_bytes                       0x7b8b0000        (2,072,707,072)

[Absolute Stat]
        tx_total                            0x1734e           (95,054)
        tx_total_bytes                      0x1734e0000       (6,229,458,944)
        tx_succ                             0x17346           (95,046)
        tx_succ_bytes                       0x173460000       (6,228,934,656)


And the output looks like this on the RX node:

[time lasts]: 3
[conn-num 24][tx off][rx on][msg-len 65536][data-type seq-u64]

[Relative Stat]
        rx_total                            0x170af           (94,383)
        rx_total_bytes                      0x170af0000       (6,185,484,288)
        rx_msg                              0x170af           (94,383)
        rx_msg_bytes                        0x170af0000       (6,185,484,288)
        rx_msg_succ                         0x170af           (94,383)
        rx_msg_succ_bytes                   0x170af0000       (6,185,484,288)

[Absolute Stat]
        rx_total                            0x44150           (278,864)
        rx_total_bytes                      0x441500000       (18,275,631,104)
        rx_msg                              0x44138           (278,840)
        rx_msg_bytes                        0x441380000       (18,274,058,240)
        rx_msg_succ                         0x44138           (278,840)
        rx_msg_succ_bytes                   0x441380000       (18,274,058,240)

[time lasts]: 4
[conn-num 24][tx off][rx on][msg-len 65536][data-type seq-u64]

[Relative Stat]
        rx_total                            0x170ab           (94,379)
        rx_total_bytes                      0x170ab0000       (6,185,222,144)
        rx_msg                              0x170ab           (94,379)
        rx_msg_bytes                        0x170ab0000       (6,185,222,144)
        rx_msg_succ                         0x170ab           (94,379)
        rx_msg_succ_bytes                   0x170ab0000       (6,185,222,144)

[Absolute Stat]
        rx_total                            0x5b1fb           (373,243)
        rx_total_bytes                      0x5b1fb0000       (24,460,853,248)
        rx_msg                              0x5b1e3           (373,219)
        rx_msg_bytes                        0x5b1e30000       (24,459,280,384)
        rx_msg_succ                         0x5b1e3           (373,219)
        rx_msg_succ_bytes                   0x5b1e30000       (24,459,280,384)

[time lasts]: 5
[conn-num 24][tx off][rx on][msg-len 65536][data-type seq-u64]

[Relative Stat]
        rx_total                            0x170ae           (94,382)
        rx_total_bytes                      0x170ae0000       (6,185,418,752)
        rx_msg                              0x170ae           (94,382)
        rx_msg_bytes                        0x170ae0000       (6,185,418,752)
        rx_msg_succ                         0x170ae           (94,382)
        rx_msg_succ_bytes                   0x170ae0000       (6,185,418,752)

[Absolute Stat]
        rx_total                            0x722a9           (467,625)
        rx_total_bytes                      0x722a90000       (30,646,272,000)
        rx_msg                              0x72291           (467,601)
        rx_msg_bytes                        0x722910000       (30,644,699,136)
        rx_msg_succ                         0x72291           (467,601)
        rx_msg_succ_bytes                   0x722910000       (30,644,699,136)

But for your convenience to fucos on the fluctuation of the bandwidth, 
and for reducing the length of the mail,
We get all other line muted, we only show tx_succ_bytes and rx_msg_succ_bytes
in each second.

[Combination 1] dctcp + switch ECN-marking on

This is the perfect scenario.
Bandwidth of each node is perfectly stable.
No packet dropping on switch at all.

/*
 * before loading traffic, clear the counters on the 2 switches.
 */

hound-dirt# clear qos statistics type queuing interface ethernet 1/1/4
hound-dirt# show queuing statistics interface ethernet 1/1/4
Interface ethernet1/1/4
Queue Packets                  Bytes                    Dropped-Packets          Dropped-Bytes            
0     0                        0                        0                        0                        
1     0                        0                        0                        0                        
2     0                        0                        0                        0                        
3     0                        0                        0                        0                        
4     0                        0                        0                        0                        
5     0                        0                        0                        0                        
6     0                        0                        0                        0                        
7     0                        0                        0                        0                        
hound-dirt#

hound-dirt# clear qos statistics type queuing interface ethernet 1/1/4
hound-dirt# show queuing statistics interface ethernet 1/1/4
Interface ethernet1/1/4
Queue Packets                  Bytes                    Dropped-Packets          Dropped-Bytes            
0     0                        0                        0                        0                        
1     0                        0                        0                        0                        
2     0                        0                        0                        0                        
3     0                        0                        0                        0                        
4     0                        0                        0                        0                        
5     0                        0                        0                        0                        
6     0                        0                        0                        0                        
7     0                        0                        0                        0                        
hound-dirt#



/*
 * logs of RX node.
 */

ogden-dirt:/home/admin/tyler # cat /proc/sys/net/ipv4/tcp_congestion_control
dctcp

ogden-dirt:/home/admin/tyler # date; ./tcp_perf.exe --server-ip 169.254.85.4  --server-port 10001 --msg-len 65536 --conn-num 24 -s -r  --data-random --svr-no-wait-all-conn-OK --show-bandwidth-only
Fri Mar 25 07:58:48 EDT 2022

DBG:/mnt/hgfs/src/linux-dev-framework-master/libs/app_utils/src/socket.c(104)-socket_init_2:
bind socket fd 3 to 169.254.85.4:10001 succeed
DBG:perf_frmwk.c(1472)-create_tcp_conns_start_load:
start listen on fd 3
conn [0] local 169.254.85.4:10001 peer 169.254.85.3:59660 created.
rx thread of conn 0 started
conn [1] local 169.254.85.4:10001 peer 169.254.85.3:59662 created.
rx thread of conn 1 started
conn [2] local 169.254.85.4:10001 peer 169.254.85.3:59664 created.
rx thread of conn 2 started
conn [3] local 169.254.85.4:10001 peer 169.254.85.3:59666 created.
rx thread of conn 3 started
conn [4] local 169.254.85.4:10001 peer 169.254.85.3:59668 created.
conn [5] local 169.254.85.4:10001 peer 169.254.85.3:59670 created.
rx thread of conn 4 started
conn [6] local 169.254.85.4:10001 peer 169.254.85.3:59672 created.
rx thread of conn 5 started
conn [7] local 169.254.85.4:10001 peer 169.254.85.3:59674 created.
rx thread of conn 6 started
rx thread of conn 7 started
conn [8] local 169.254.85.4:10001 peer 169.254.85.2:37956 created.
rx thread of conn 8 started
conn [9] local 169.254.85.4:10001 peer 169.254.85.2:37958 created.
rx thread of conn 9 started
conn [10] local 169.254.85.4:10001 peer 169.254.85.2:37960 created.
rx thread of conn 10 started
conn [11] local 169.254.85.4:10001 peer 169.254.85.2:37962 created.
rx thread of conn 11 started
conn [12] local 169.254.85.4:10001 peer 169.254.85.2:37964 created.
rx thread of conn 12 started
conn [13] local 169.254.85.4:10001 peer 169.254.85.2:37966 created.
rx thread of conn 13 started
conn [14] local 169.254.85.4:10001 peer 169.254.85.2:37968 created.
rx thread of conn 14 started
conn [15] local 169.254.85.4:10001 peer 169.254.85.2:37970 created.
rx thread of conn 15 started

[time lasts]: 1
        rx_msg_succ_bytes                   0x161500000       (5,927,600,128)
conn [16] local 169.254.85.4:10001 peer 169.254.85.1:49468 created.
rx thread of conn 16 started
conn [17] local 169.254.85.4:10001 peer 169.254.85.1:49470 created.
rx thread of conn 17 started
conn [18] local 169.254.85.4:10001 peer 169.254.85.1:49472 created.
rx thread of conn 18 started
conn [19] local 169.254.85.4:10001 peer 169.254.85.1:49474 created.
rx thread of conn 19 started
conn [20] local 169.254.85.4:10001 peer 169.254.85.1:49476 created.
rx thread of conn 20 started
conn [21] local 169.254.85.4:10001 peer 169.254.85.1:49478 created.
rx thread of conn 21 started
conn [22] local 169.254.85.4:10001 peer 169.254.85.1:49480 created.
rx thread of conn 22 started
conn [23] local 169.254.85.4:10001 peer 169.254.85.1:49482 created.
24 connection(s) created in total
rx thread of conn 23 started

[time lasts]: 2
        rx_msg_succ_bytes                   0x1709a0000       (6,184,108,032)

[time lasts]: 3
        rx_msg_succ_bytes                   0x170ac0000       (6,185,287,680)

[time lasts]: 4
        rx_msg_succ_bytes                   0x170ad0000       (6,185,353,216)

[time lasts]: 5
        rx_msg_succ_bytes                   0x170ad0000       (6,185,353,216)

[time lasts]: 6
        rx_msg_succ_bytes                   0x170b00000       (6,185,549,824)

[time lasts]: 7
        rx_msg_succ_bytes                   0x170590000       (6,179,848,192)

[time lasts]: 8
        rx_msg_succ_bytes                   0x170a90000       (6,185,091,072)

[time lasts]: 9
        rx_msg_succ_bytes                   0x170af0000       (6,185,484,288)

[time lasts]: 10
        rx_msg_succ_bytes                   0x170af0000       (6,185,484,288)

[time lasts]: 11
        rx_msg_succ_bytes                   0x170ad0000       (6,185,353,216)

[time lasts]: 12
        rx_msg_succ_bytes                   0x170ad0000       (6,185,353,216)

[time lasts]: 13
        rx_msg_succ_bytes                   0x170ab0000       (6,185,222,144)

[time lasts]: 14
        rx_msg_succ_bytes                   0x170b20000       (6,185,680,896)

[time lasts]: 15
        rx_msg_succ_bytes                   0x170a70000       (6,184,960,000)

[time lasts]: 16
        rx_msg_succ_bytes                   0x170ab0000       (6,185,222,144)

[time lasts]: 17
        rx_msg_succ_bytes                   0x170b20000       (6,185,680,896)

[time lasts]: 18
        rx_msg_succ_bytes                   0x170ab0000       (6,185,222,144)

[time lasts]: 19
        rx_msg_succ_bytes                   0x170ac0000       (6,185,287,680)

[time lasts]: 20
        rx_msg_succ_bytes                   0x170ac0000       (6,185,287,680)

[time lasts]: 21
        rx_msg_succ_bytes                   0x170ab0000       (6,185,222,144)

[time lasts]: 22
        rx_msg_succ_bytes                   0x170ac0000       (6,185,287,680)

[time lasts]: 23
        rx_msg_succ_bytes                   0x170ae0000       (6,185,418,752)

[time lasts]: 24
        rx_msg_succ_bytes                   0x170ad0000       (6,185,353,216)

[time lasts]: 25
        rx_msg_succ_bytes                   0x170ae0000       (6,185,418,752)

[time lasts]: 26
        rx_msg_succ_bytes                   0x170aa0000       (6,185,156,608)

[time lasts]: 27
        rx_msg_succ_bytes                   0x170ae0000       (6,185,418,752)

[time lasts]: 28
        rx_msg_succ_bytes                   0x170ad0000       (6,185,353,216)

[time lasts]: 29
        rx_msg_succ_bytes                   0x170aa0000       (6,185,156,608)

[time lasts]: 30
        rx_msg_succ_bytes                   0x170ac0000       (6,185,287,680)

[time lasts]: 31
        rx_msg_succ_bytes                   0x170ac0000       (6,185,287,680)

[time lasts]: 32
        rx_msg_succ_bytes                   0x170ae0000       (6,185,418,752)

[time lasts]: 33
        rx_msg_succ_bytes                   0x170ae0000       (6,185,418,752)

[time lasts]: 34
        rx_msg_succ_bytes                   0x170aa0000       (6,185,156,608)

[time lasts]: 35
        rx_msg_succ_bytes                   0x170ab0000       (6,185,222,144)

[time lasts]: 36
        rx_msg_succ_bytes                   0x170b10000       (6,185,615,360)

[time lasts]: 37
        rx_msg_succ_bytes                   0x170ad0000       (6,185,353,216)

[time lasts]: 38
        rx_msg_succ_bytes                   0x170a90000       (6,185,091,072)

[time lasts]: 39
        rx_msg_succ_bytes                   0x170ab0000       (6,185,222,144)

[time lasts]: 40
        rx_msg_succ_bytes                   0x170ad0000       (6,185,353,216)

[time lasts]: 41
        rx_msg_succ_bytes                   0x170ae0000       (6,185,418,752)

[time lasts]: 42
        rx_msg_succ_bytes                   0x170aa0000       (6,185,156,608)

[time lasts]: 43
        rx_msg_succ_bytes                   0x170ac0000       (6,185,287,680)

[time lasts]: 44
        rx_msg_succ_bytes                   0x170af0000       (6,185,484,288)

[time lasts]: 45
        rx_msg_succ_bytes                   0x170ac0000       (6,185,287,680)

[time lasts]: 46
        rx_msg_succ_bytes                   0x170aa0000       (6,185,156,608)

[time lasts]: 47
        rx_msg_succ_bytes                   0x170ac0000       (6,185,287,680)

[time lasts]: 48
        rx_msg_succ_bytes                   0x170af0000       (6,185,484,288)

[time lasts]: 49
        rx_msg_succ_bytes                   0x170ac0000       (6,185,287,680)

[time lasts]: 50
        rx_msg_succ_bytes                   0x170ae0000       (6,185,418,752)

[time lasts]: 51
        rx_msg_succ_bytes                   0x170ad0000       (6,185,353,216)

[time lasts]: 52
        rx_msg_succ_bytes                   0x170ab0000       (6,185,222,144)

[time lasts]: 53
        rx_msg_succ_bytes                   0x170ae0000       (6,185,418,752)

[time lasts]: 54
        rx_msg_succ_bytes                   0x170ac0000       (6,185,287,680)

[time lasts]: 55
        rx_msg_succ_bytes                   0x170ad0000       (6,185,353,216)

[time lasts]: 56
        rx_msg_succ_bytes                   0x170ae0000       (6,185,418,752)

[time lasts]: 57
        rx_msg_succ_bytes                   0x170a90000       (6,185,091,072)

[time lasts]: 58
        rx_msg_succ_bytes                   0x170af0000       (6,185,484,288)

[time lasts]: 59
        rx_msg_succ_bytes                   0x170aa0000       (6,185,156,608)

[time lasts]: 60
        rx_msg_succ_bytes                   0x170a50000       (6,184,828,928)

[time lasts]: 61
        rx_msg_succ_bytes                   0x170aa0000       (6,185,156,608)

[time lasts]: 62
        rx_msg_succ_bytes                   0x170ad0000       (6,185,353,216)

[time lasts]: 63
        rx_msg_succ_bytes                   0x170ab0000       (6,185,222,144)
^Ccaught signal 2


/*
 * logs of TX node 1.
 */

provo-dirt:/home/admin/tyler # cat /proc/sys/net/ipv4/tcp_congestion_control
dctcp

provo-dirt:/home/admin/tyler # date; ./tcp_perf.exe --server-ip 169.254.85.4  --server-port 10001 --msg-len 65536 --conn-num 8 -c -t --data-random --show-bandwidth-only
Fri Mar 25 07:58:53 EDT 2022

conn [0] local 169.254.85.1:49468 peer 169.254.85.4:10001 created.
conn [1] local 169.254.85.1:49470 peer 169.254.85.4:10001 created.
conn [2] local 169.254.85.1:49472 peer 169.254.85.4:10001 created.
conn [3] local 169.254.85.1:49474 peer 169.254.85.4:10001 created.
conn [4] local 169.254.85.1:49476 peer 169.254.85.4:10001 created.
conn [5] local 169.254.85.1:49478 peer 169.254.85.4:10001 created.
conn [6] local 169.254.85.1:49480 peer 169.254.85.4:10001 created.
conn [7] local 169.254.85.1:49482 peer 169.254.85.4:10001 created.
8 connection(s) created in total
tx thread of conn 0 started
tx thread of conn 1 started
tx thread of conn 2 started
tx thread of conn 3 started
tx thread of conn 4 started
tx thread of conn 5 started
tx thread of conn 6 started
tx thread of conn 7 started

[time lasts]: 1
        tx_succ_bytes                       0x765c0000        (1,985,740,800)

[time lasts]: 2
        tx_succ_bytes                       0x78f30000        (2,029,191,168)

[time lasts]: 3
        tx_succ_bytes                       0x783d0000        (2,017,263,616)

[time lasts]: 4
        tx_succ_bytes                       0x78c90000        (2,026,438,656)

[time lasts]: 5
        tx_succ_bytes                       0x76bf0000        (1,992,228,864)

[time lasts]: 6
        tx_succ_bytes                       0x784f0000        (2,018,443,264)

[time lasts]: 7
        tx_succ_bytes                       0x765c0000        (1,985,740,800)

[time lasts]: 8
        tx_succ_bytes                       0x78140000        (2,014,576,640)

[time lasts]: 9
        tx_succ_bytes                       0x77bf0000        (2,009,006,080)

[time lasts]: 10
        tx_succ_bytes                       0x79210000        (2,032,205,824)

[time lasts]: 11
        tx_succ_bytes                       0x786d0000        (2,020,409,344)

[time lasts]: 12
        tx_succ_bytes                       0x79480000        (2,034,761,728)

[time lasts]: 13
        tx_succ_bytes                       0x76610000        (1,986,068,480)

[time lasts]: 14
        tx_succ_bytes                       0x76940000        (1,989,410,816)

[time lasts]: 15
        tx_succ_bytes                       0x76ef0000        (1,995,374,592)

[time lasts]: 16
        tx_succ_bytes                       0x76f20000        (1,995,571,200)

[time lasts]: 17
        tx_succ_bytes                       0x78190000        (2,014,904,320)

[time lasts]: 18
        tx_succ_bytes                       0x775c0000        (2,002,518,016)

[time lasts]: 19
        tx_succ_bytes                       0x77040000        (1,996,750,848)

[time lasts]: 20
        tx_succ_bytes                       0x77d90000        (2,010,710,016)

[time lasts]: 21
        tx_succ_bytes                       0x79470000        (2,034,696,192)

[time lasts]: 22
        tx_succ_bytes                       0x79730000        (2,037,579,776)

[time lasts]: 23
        tx_succ_bytes                       0x760c0000        (1,980,497,920)

[time lasts]: 24
        tx_succ_bytes                       0x779e0000        (2,006,843,392)

[time lasts]: 25
        tx_succ_bytes                       0x78100000        (2,014,314,496)

[time lasts]: 26
        tx_succ_bytes                       0x78bb0000        (2,025,521,152)

[time lasts]: 27
        tx_succ_bytes                       0x77df0000        (2,011,103,232)

[time lasts]: 28
        tx_succ_bytes                       0x75840000        (1,971,585,024)

[time lasts]: 29
        tx_succ_bytes                       0x772d0000        (1,999,437,824)

[time lasts]: 30
        tx_succ_bytes                       0x785d0000        (2,019,360,768)

[time lasts]: 31
        tx_succ_bytes                       0x766f0000        (1,986,985,984)

[time lasts]: 32
        tx_succ_bytes                       0x77510000        (2,001,797,120)

[time lasts]: 33
        tx_succ_bytes                       0x78720000        (2,020,737,024)

[time lasts]: 34
        tx_succ_bytes                       0x790e0000        (2,030,960,640)

[time lasts]: 35
        tx_succ_bytes                       0x797b0000        (2,038,104,064)

[time lasts]: 36
        tx_succ_bytes                       0x78710000        (2,020,671,488)

[time lasts]: 37
        tx_succ_bytes                       0x79bb0000        (2,042,298,368)

[time lasts]: 38
        tx_succ_bytes                       0x76f80000        (1,995,964,416)

[time lasts]: 39
        tx_succ_bytes                       0x79780000        (2,037,907,456)

[time lasts]: 40
        tx_succ_bytes                       0x79270000        (2,032,599,040)

[time lasts]: 41
        tx_succ_bytes                       0x78660000        (2,019,950,592)

[time lasts]: 42
        tx_succ_bytes                       0x77970000        (2,006,384,640)

[time lasts]: 43
        tx_succ_bytes                       0x78270000        (2,015,821,824)

[time lasts]: 44
        tx_succ_bytes                       0x774d0000        (2,001,534,976)

[time lasts]: 45
        tx_succ_bytes                       0x77a80000        (2,007,498,752)

[time lasts]: 46
        tx_succ_bytes                       0x78790000        (2,021,195,776)

[time lasts]: 47
        tx_succ_bytes                       0x7a730000        (2,054,356,992)

[time lasts]: 48
        tx_succ_bytes                       0x78c80000        (2,026,373,120)

[time lasts]: 49
        tx_succ_bytes                       0x78eb0000        (2,028,666,880)

[time lasts]: 50
        tx_succ_bytes                       0x76fd0000        (1,996,292,096)

[time lasts]: 51
        tx_succ_bytes                       0x77e30000        (2,011,365,376)

[time lasts]: 52
        tx_succ_bytes                       0x78de0000        (2,027,814,912)

[time lasts]: 53
        tx_succ_bytes                       0x779f0000        (2,006,908,928)

[time lasts]: 54
        tx_succ_bytes                       0x78310000        (2,016,477,184)

[time lasts]: 55
        tx_succ_bytes                       0x77b20000        (2,008,154,112)

[time lasts]: 56
        tx_succ_bytes                       0x76760000        (1,987,444,736)

[time lasts]: 57
        tx_succ_bytes                       0x78060000        (2,013,659,136)

[time lasts]: 58
        tx_succ_bytes                       0x78a30000        (2,023,948,288)

[time lasts]: 59
        tx_succ_bytes                       0x79c20000        (2,042,757,120)

[time lasts]: 60
        tx_succ_bytes                       0x76ff0000        (1,996,423,168)

[time lasts]: 61
        tx_succ_bytes                       0x78d30000        (2,027,094,016)

[time lasts]: 62
        tx_succ_bytes                       0x77cd0000        (2,009,923,584)

/*
 * logs of TX node 2.
 */

sandy-dirt:/home/admin/tyler # cat /proc/sys/net/ipv4/tcp_congestion_control
dctcp

sandy-dirt:/home/admin/tyler # date; ./tcp_perf.exe --server-ip 169.254.85.4  --server-port 10001 --msg-len 65536 --conn-num 8 -c -t --data-random --show-bandwidth-only
Fri Mar 25 07:58:52 EDT 2022

conn [0] local 169.254.85.2:37956 peer 169.254.85.4:10001 created.
conn [1] local 169.254.85.2:37958 peer 169.254.85.4:10001 created.
conn [2] local 169.254.85.2:37960 peer 169.254.85.4:10001 created.
conn [3] local 169.254.85.2:37962 peer 169.254.85.4:10001 created.
conn [4] local 169.254.85.2:37964 peer 169.254.85.4:10001 created.
conn [5] local 169.254.85.2:37966 peer 169.254.85.4:10001 created.
conn [6] local 169.254.85.2:37968 peer 169.254.85.4:10001 created.
conn [7] local 169.254.85.2:37970 peer 169.254.85.4:10001 created.
8 connection(s) created in total
tx thread of conn 0 started
tx thread of conn 1 started
tx thread of conn 2 started
tx thread of conn 3 started
tx thread of conn 4 started
tx thread of conn 5 started
tx thread of conn 6 started
tx thread of conn 7 started

[time lasts]: 1
        tx_succ_bytes                       0xb7980000        (3,080,192,000)

[time lasts]: 2
        tx_succ_bytes                       0x83350000        (2,201,288,704)

[time lasts]: 3
        tx_succ_bytes                       0x80fd0000        (2,164,064,256)

[time lasts]: 4
        tx_succ_bytes                       0x80790000        (2,155,413,504)

[time lasts]: 5
        tx_succ_bytes                       0x82a00000        (2,191,523,840)

[time lasts]: 6
        tx_succ_bytes                       0x83350000        (2,201,288,704)

[time lasts]: 7
        tx_succ_bytes                       0x82350000        (2,184,511,488)

[time lasts]: 8
        tx_succ_bytes                       0x84260000        (2,217,082,880)

[time lasts]: 9
        tx_succ_bytes                       0x835c0000        (2,203,844,608)

[time lasts]: 10
        tx_succ_bytes                       0x81880000        (2,173,173,760)

[time lasts]: 11
        tx_succ_bytes                       0x80a70000        (2,158,428,160)

[time lasts]: 12
        tx_succ_bytes                       0x80db0000        (2,161,836,032)

[time lasts]: 13
        tx_succ_bytes                       0x7faa0000        (2,141,847,552)

[time lasts]: 14
        tx_succ_bytes                       0x82b10000        (2,192,637,952)

[time lasts]: 15
        tx_succ_bytes                       0x837e0000        (2,206,072,832)

[time lasts]: 16
        tx_succ_bytes                       0x82a60000        (2,191,917,056)

[time lasts]: 17
        tx_succ_bytes                       0x83f60000        (2,213,937,152)

[time lasts]: 18
        tx_succ_bytes                       0x82ac0000        (2,192,310,272)

[time lasts]: 19
        tx_succ_bytes                       0x83e90000        (2,213,085,184)

[time lasts]: 20
        tx_succ_bytes                       0x82420000        (2,185,363,456)

[time lasts]: 21
        tx_succ_bytes                       0x83ce0000        (2,211,315,712)

[time lasts]: 22
        tx_succ_bytes                       0x82480000        (2,185,756,672)

[time lasts]: 23
        tx_succ_bytes                       0x82470000        (2,185,691,136)

[time lasts]: 24
        tx_succ_bytes                       0x83450000        (2,202,337,280)

[time lasts]: 25
        tx_succ_bytes                       0x80820000        (2,156,003,328)

[time lasts]: 26
        tx_succ_bytes                       0x82d80000        (2,195,193,856)

[time lasts]: 27
        tx_succ_bytes                       0x81930000        (2,173,894,656)

[time lasts]: 28
        tx_succ_bytes                       0x816a0000        (2,171,207,680)

[time lasts]: 29
        tx_succ_bytes                       0x83cf0000        (2,211,381,248)

[time lasts]: 30
        tx_succ_bytes                       0x82330000        (2,184,380,416)

[time lasts]: 31
        tx_succ_bytes                       0x828d0000        (2,190,278,656)

[time lasts]: 32
        tx_succ_bytes                       0x82a50000        (2,191,851,520)

[time lasts]: 33
        tx_succ_bytes                       0x81600000        (2,170,552,320)

[time lasts]: 34
        tx_succ_bytes                       0x82060000        (2,181,431,296)

[time lasts]: 35
        tx_succ_bytes                       0x814b0000        (2,169,176,064)

[time lasts]: 36
        tx_succ_bytes                       0x81370000        (2,167,865,344)

[time lasts]: 37
        tx_succ_bytes                       0x811c0000        (2,166,095,872)

[time lasts]: 38
        tx_succ_bytes                       0x83010000        (2,197,880,832)

[time lasts]: 39
        tx_succ_bytes                       0x83c50000        (2,210,725,888)

[time lasts]: 40
        tx_succ_bytes                       0x82f70000        (2,197,225,472)

[time lasts]: 41
        tx_succ_bytes                       0x83730000        (2,205,351,936)

[time lasts]: 42
        tx_succ_bytes                       0x816a0000        (2,171,207,680)

[time lasts]: 43
        tx_succ_bytes                       0x83360000        (2,201,354,240)

[time lasts]: 44
        tx_succ_bytes                       0x81170000        (2,165,768,192)

[time lasts]: 45
        tx_succ_bytes                       0x83930000        (2,207,449,088)

[time lasts]: 46
        tx_succ_bytes                       0x84430000        (2,218,983,424)

[time lasts]: 47
        tx_succ_bytes                       0x81600000        (2,170,552,320)

[time lasts]: 48
        tx_succ_bytes                       0x812a0000        (2,167,013,376)

[time lasts]: 49
        tx_succ_bytes                       0x80860000        (2,156,265,472)

[time lasts]: 50
        tx_succ_bytes                       0x81b70000        (2,176,253,952)

[time lasts]: 51
        tx_succ_bytes                       0x83610000        (2,204,172,288)

[time lasts]: 52
        tx_succ_bytes                       0x82dc0000        (2,195,456,000)

[time lasts]: 53
        tx_succ_bytes                       0x83760000        (2,205,548,544)

[time lasts]: 54
        tx_succ_bytes                       0x83360000        (2,201,354,240)

[time lasts]: 55
        tx_succ_bytes                       0x82570000        (2,186,739,712)

[time lasts]: 56
        tx_succ_bytes                       0x82370000        (2,184,642,560)

[time lasts]: 57
        tx_succ_bytes                       0x83430000        (2,202,206,208)

[time lasts]: 58
        tx_succ_bytes                       0x81e40000        (2,179,203,072)

[time lasts]: 59
        tx_succ_bytes                       0x81d30000        (2,178,088,960)

[time lasts]: 60
        tx_succ_bytes                       0x80b50000        (2,159,345,664)

[time lasts]: 61
        tx_succ_bytes                       0x838c0000        (2,206,990,336)

[time lasts]: 62
        tx_succ_bytes                       0x82580000        (2,186,805,248)

[time lasts]: 63
        tx_succ_bytes                       0x81eb0000        (2,179,661,824)

/*
 * logs of TX node 3.
 */

orem-dirt:/home/admin/tyler # cat /proc/sys/net/ipv4/tcp_congestion_control
dctcp

orem-dirt:/home/admin/tyler # date; ./tcp_perf.exe --server-ip 169.254.85.4  --server-port 10001 --msg-len 65536 --conn-num 8 -c -t --data-random --show-bandwidth-only
Fri Mar 25 07:58:51 EDT 2022

conn [0] local 169.254.85.3:59660 peer 169.254.85.4:10001 created.
conn [1] local 169.254.85.3:59662 peer 169.254.85.4:10001 created.
conn [2] local 169.254.85.3:59664 peer 169.254.85.4:10001 created.
conn [3] local 169.254.85.3:59666 peer 169.254.85.4:10001 created.
conn [4] local 169.254.85.3:59668 peer 169.254.85.4:10001 created.
conn [5] local 169.254.85.3:59670 peer 169.254.85.4:10001 created.
conn [6] local 169.254.85.3:59672 peer 169.254.85.4:10001 created.
conn [7] local 169.254.85.3:59674 peer 169.254.85.4:10001 created.
8 connection(s) created in total
tx thread of conn 0 started
tx thread of conn 1 started
tx thread of conn 2 started
tx thread of conn 3 started
tx thread of conn 4 started
tx thread of conn 5 started
tx thread of conn 6 started
tx thread of conn 7 started

[time lasts]: 1
        tx_succ_bytes                       0x125530000       (4,921,163,776)

[time lasts]: 2
        tx_succ_bytes                       0xa22d0000        (2,720,858,112)

[time lasts]: 3
        tx_succ_bytes                       0x77530000        (2,001,928,192)

[time lasts]: 4
        tx_succ_bytes                       0x76b90000        (1,991,835,648)

[time lasts]: 5
        tx_succ_bytes                       0x78070000        (2,013,724,672)

[time lasts]: 6
        tx_succ_bytes                       0x74cd0000        (1,959,591,936)

[time lasts]: 7
        tx_succ_bytes                       0x76a80000        (1,990,721,536)

[time lasts]: 8
        tx_succ_bytes                       0x75dc0000        (1,977,352,192)

[time lasts]: 9
        tx_succ_bytes                       0x756b0000        (1,969,946,624)

[time lasts]: 10
        tx_succ_bytes                       0x76620000        (1,986,134,016)

[time lasts]: 11
        tx_succ_bytes                       0x772f0000        (1,999,568,896)

[time lasts]: 12
        tx_succ_bytes                       0x77090000        (1,997,078,528)

[time lasts]: 13
        tx_succ_bytes                       0x77220000        (1,998,716,928)

[time lasts]: 14
        tx_succ_bytes                       0x77ce0000        (2,009,989,120)

[time lasts]: 15
        tx_succ_bytes                       0x781d0000        (2,015,166,464)

[time lasts]: 16
        tx_succ_bytes                       0x762b0000        (1,982,529,536)

[time lasts]: 17
        tx_succ_bytes                       0x765c0000        (1,985,740,800)

[time lasts]: 18
        tx_succ_bytes                       0x77010000        (1,996,554,240)

[time lasts]: 19
        tx_succ_bytes                       0x74ad0000        (1,957,494,784)

[time lasts]: 20
        tx_succ_bytes                       0x76820000        (1,988,231,168)

[time lasts]: 21
        tx_succ_bytes                       0x75b70000        (1,974,927,360)

[time lasts]: 22
        tx_succ_bytes                       0x754f0000        (1,968,111,616)

[time lasts]: 23
        tx_succ_bytes                       0x75e30000        (1,977,810,944)

[time lasts]: 24
        tx_succ_bytes                       0x75730000        (1,970,470,912)

[time lasts]: 25
        tx_succ_bytes                       0x77380000        (2,000,158,720)

[time lasts]: 26
        tx_succ_bytes                       0x77900000        (2,005,925,888)

[time lasts]: 27
        tx_succ_bytes                       0x76c00000        (1,992,294,400)

[time lasts]: 28
        tx_succ_bytes                       0x75e10000        (1,977,679,872)

[time lasts]: 29
        tx_succ_bytes                       0x784c0000        (2,018,246,656)

[time lasts]: 30
        tx_succ_bytes                       0x768c0000        (1,988,886,528)

[time lasts]: 31
        tx_succ_bytes                       0x76c70000        (1,992,753,152)

[time lasts]: 32
        tx_succ_bytes                       0x76c80000        (1,992,818,688)

[time lasts]: 33
        tx_succ_bytes                       0x77c10000        (2,009,137,152)

[time lasts]: 34
        tx_succ_bytes                       0x78010000        (2,013,331,456)

[time lasts]: 35
        tx_succ_bytes                       0x74ef0000        (1,961,820,160)

[time lasts]: 36
        tx_succ_bytes                       0x76fe0000        (1,996,357,632)

[time lasts]: 37
        tx_succ_bytes                       0x76600000        (1,986,002,944)

[time lasts]: 38
        tx_succ_bytes                       0x76360000        (1,983,250,432)

[time lasts]: 39
        tx_succ_bytes                       0x73e40000        (1,944,322,048)

[time lasts]: 40
        tx_succ_bytes                       0x76120000        (1,980,891,136)

[time lasts]: 41
        tx_succ_bytes                       0x735b0000        (1,935,343,616)

[time lasts]: 42
        tx_succ_bytes                       0x74e30000        (1,961,033,728)

[time lasts]: 43
        tx_succ_bytes                       0x772f0000        (1,999,568,896)

[time lasts]: 44
        tx_succ_bytes                       0x75d30000        (1,976,762,368)

[time lasts]: 45
        tx_succ_bytes                       0x76a00000        (1,990,197,248)

[time lasts]: 46
        tx_succ_bytes                       0x76400000        (1,983,905,792)

[time lasts]: 47
        tx_succ_bytes                       0x75820000        (1,971,453,952)

[time lasts]: 48
        tx_succ_bytes                       0x768f0000        (1,989,083,136)

[time lasts]: 49
        tx_succ_bytes                       0x752c0000        (1,965,817,856)

[time lasts]: 50
        tx_succ_bytes                       0x76050000        (1,980,039,168)

[time lasts]: 51
        tx_succ_bytes                       0x77280000        (1,999,110,144)

[time lasts]: 52
        tx_succ_bytes                       0x757b0000        (1,970,995,200)

[time lasts]: 53
        tx_succ_bytes                       0x76220000        (1,981,939,712)

[time lasts]: 54
        tx_succ_bytes                       0x74de0000        (1,960,706,048)

[time lasts]: 55
        tx_succ_bytes                       0x75040000        (1,963,196,416)

[time lasts]: 56
        tx_succ_bytes                       0x76c10000        (1,992,359,936)

[time lasts]: 57
        tx_succ_bytes                       0x779d0000        (2,006,777,856)

[time lasts]: 58
        tx_succ_bytes                       0x766d0000        (1,986,854,912)

[time lasts]: 59
        tx_succ_bytes                       0x76a40000        (1,990,459,392)

[time lasts]: 60
        tx_succ_bytes                       0x760e0000        (1,980,628,992)

[time lasts]: 61
        tx_succ_bytes                       0x76910000        (1,989,214,208)

[time lasts]: 62
        tx_succ_bytes                       0x75270000        (1,965,490,176)

[time lasts]: 63
        tx_succ_bytes                       0x769d0000        (1,990,000,640)

[time lasts]: 64
        tx_succ_bytes                       0x77470000        (2,001,141,760)

/*
 * counters on the switch.
 * no packet dropping at all.
 */

hound-dirt# show queuing statistics interface ethernet 1/1/4
Interface ethernet1/1/4
Queue Packets                  Bytes                    Dropped-Packets          Dropped-Bytes            
0     0                        0                        0                        0                        
1     14                       1372                     0                        0                        
2     0                        0                        0                        0                        
3     0                        0                        0                        0                        
4     0                        0                        0                        0                        
5     22209070                 200252338712             0                        0                        
6     0                        0                        0                        0                        
7     0                        0                        0                        0                        
hound-dirt#

hound-dirt# show queuing statistics interface ethernet 1/1/4
Interface ethernet1/1/4
Queue Packets                  Bytes                    Dropped-Packets          Dropped-Bytes            
0     0                        0                        0                        0                        
1     14                       1372                     0                        0                        
2     0                        0                        0                        0                        
3     0                        0                        0                        0                        
4     0                        0                        0                        0                        
5     22209070                 200252338712             0                        0                        
6     0                        0                        0                        0                        
7     0                        0                        0                        0                        
hound-dirt#

