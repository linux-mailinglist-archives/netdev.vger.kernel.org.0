Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C0F4E74DF
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359312AbiCYONX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359420AbiCYONO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:13:14 -0400
Received: from smtp.tom.com (smtprz02.163.net [106.3.154.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6238D8F72
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:11:38 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id C62614400C1
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 22:11:36 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648217496; bh=/m2ybB/NjJ4UGfxo1AvnXEnKFTufKaHDdytJvZRdr6I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n7CqYAH1y5B8o1gOBMGGo8E1vIxF+Sqtfr7ggOiQXk4XJacPzrPkllAzwjRlT+IJw
         GHw9427JD1kbfDtvbqhqEk41hyroDNAX8tcbnuaO7XI7EfZ9gCljfI+jrA1al13zGv
         YbNBsPJayfuhiB1w6RjrZZGEbVARe0+zC6R9Qvio=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID -1032428196
          for <netdev@vger.kernel.org>;
          Fri, 25 Mar 2022 22:11:36 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1648217496; bh=/m2ybB/NjJ4UGfxo1AvnXEnKFTufKaHDdytJvZRdr6I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n7CqYAH1y5B8o1gOBMGGo8E1vIxF+Sqtfr7ggOiQXk4XJacPzrPkllAzwjRlT+IJw
         GHw9427JD1kbfDtvbqhqEk41hyroDNAX8tcbnuaO7XI7EfZ9gCljfI+jrA1al13zGv
         YbNBsPJayfuhiB1w6RjrZZGEbVARe0+zC6R9Qvio=
Received: from localhost (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id 2A20215414FE;
        Fri, 25 Mar 2022 22:11:30 +0800 (CST)
Date:   Fri, 25 Mar 2022 22:11:29 +0800
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
Message-ID: <20220325221129.00003cfc@tom.com>
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

[Combination 3] dctcp + switch ECN-marking off

This is a wrong usage of dctcp.
Since the ECN-marking required by dctcp is disabled on the switch.
The condition of the bandwidth is about as bad as [Combination 2].
Since packet dropping occured.

/*
 * before loading traffic, disable ECN-marking and clear the
 * counters on the 2 switches.
 */

hound-dirt# configure terminal
hound-dirt(config)# wred LOSSLESS_ECN_5
hound-dirt(config-wred)# no random-detect ecn
hound-dirt(config-wred)# end
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

fox-dirt# configure terminal
fox-dirt(config)# wred LOSSLESS_ECN_5
fox-dirt(config-wred)# no random-detect ecn
fox-dirt(config-wred)# end
fox-dirt# 
fox-dirt# clear qos statistics type queuing interface ethernet 1/1/4
fox-dirt# show queuing statistics interface ethernet 1/1/4
Interface ethernet1/1/4
Queue Packets                  Bytes                    Dropped-Packets          Dropped-Bytes            
0     2                        128                      0                        0                        
1     2                        196                      0                        0                        
2     0                        0                        0                        0                        
3     0                        0                        0                        0                        
4     0                        0                        0                        0                        
5     0                        0                        0                        0                        
6     0                        0                        0                        0                        
7     0                        0                        0                        0                        
fox-dirt# 



/*
 * logs of RX node.
 */

ogden-dirt:/home/admin/tyler # echo dctcp >/proc/sys/net/ipv4/tcp_congestion_control 
ogden-dirt:/home/admin/tyler # cat /proc/sys/net/ipv4/tcp_congestion_control
dctcp

ogden-dirt:/home/admin/tyler # date; ./tcp_perf.exe --server-ip 169.254.85.4  --server-port 10001 --msg-len 65536 --conn-num 24 -s -r  --data-random --svr-no-wait-all-conn-OK --show-bandwidth-only
Fri Mar 25 09:53:47 EDT 2022

DBG:/mnt/hgfs/src/linux-dev-framework-master/libs/app_utils/src/socket.c(104)-socket_init_2:
bind socket fd 3 to 169.254.85.4:10001 succeed
DBG:perf_frmwk.c(1472)-create_tcp_conns_start_load:
start listen on fd 3
conn [0] local 169.254.85.4:10001 peer 169.254.85.3:59692 created.
rx thread of conn 0 started
conn [1] local 169.254.85.4:10001 peer 169.254.85.3:59694 created.
rx thread of conn 1 started
conn [2] local 169.254.85.4:10001 peer 169.254.85.3:59696 created.
rx thread of conn 2 started
conn [3] local 169.254.85.4:10001 peer 169.254.85.3:59698 created.
rx thread of conn 3 started
conn [4] local 169.254.85.4:10001 peer 169.254.85.3:59700 created.
conn [5] local 169.254.85.4:10001 peer 169.254.85.3:59702 created.
rx thread of conn 4 started
conn [6] local 169.254.85.4:10001 peer 169.254.85.3:59706 created.
rx thread of conn 5 started
conn [7] local 169.254.85.4:10001 peer 169.254.85.3:59708 created.
rx thread of conn 6 started
rx thread of conn 7 started
conn [8] local 169.254.85.4:10001 peer 169.254.85.2:37992 created.
rx thread of conn 8 started
conn [9] local 169.254.85.4:10001 peer 169.254.85.2:37994 created.
rx thread of conn 9 started
conn [10] local 169.254.85.4:10001 peer 169.254.85.2:37996 created.
rx thread of conn 10 started
conn [11] local 169.254.85.4:10001 peer 169.254.85.2:37998 created.
rx thread of conn 11 started
conn [12] local 169.254.85.4:10001 peer 169.254.85.2:38000 created.
rx thread of conn 12 started
conn [13] local 169.254.85.4:10001 peer 169.254.85.2:38002 created.
rx thread of conn 13 started
conn [14] local 169.254.85.4:10001 peer 169.254.85.2:38004 created.
conn [15] local 169.254.85.4:10001 peer 169.254.85.2:38006 created.
rx thread of conn 14 started
rx thread of conn 15 started

[time lasts]: 1
        rx_msg_succ_bytes                   0x15b4f0000       (5,826,871,296)
conn [16] local 169.254.85.4:10001 peer 169.254.85.1:49500 created.
rx thread of conn 16 started
conn [17] local 169.254.85.4:10001 peer 169.254.85.1:49502 created.
rx thread of conn 17 started
conn [18] local 169.254.85.4:10001 peer 169.254.85.1:49504 created.
rx thread of conn 18 started
conn [19] local 169.254.85.4:10001 peer 169.254.85.1:49506 created.
rx thread of conn 19 started
conn [20] local 169.254.85.4:10001 peer 169.254.85.1:49508 created.
rx thread of conn 20 started
conn [21] local 169.254.85.4:10001 peer 169.254.85.1:49510 created.
rx thread of conn 21 started
conn [22] local 169.254.85.4:10001 peer 169.254.85.1:49512 created.
rx thread of conn 22 started
conn [23] local 169.254.85.4:10001 peer 169.254.85.1:49514 created.
24 connection(s) created in total
rx thread of conn 23 started

[time lasts]: 2
        rx_msg_succ_bytes                   0x159db0000       (5,802,491,904)

[time lasts]: 3
        rx_msg_succ_bytes                   0x15a770000       (5,812,715,520)

[time lasts]: 4
        rx_msg_succ_bytes                   0x159680000       (5,794,955,264)

[time lasts]: 5
        rx_msg_succ_bytes                   0x15b130000       (5,822,939,136)

[time lasts]: 6
        rx_msg_succ_bytes                   0x1574b0000       (5,759,500,288)

[time lasts]: 7
        rx_msg_succ_bytes                   0x159850000       (5,796,855,808)

[time lasts]: 8
        rx_msg_succ_bytes                   0x15ae60000       (5,819,990,016)

[time lasts]: 9
        rx_msg_succ_bytes                   0x15be90000       (5,836,963,840)

[time lasts]: 10
        rx_msg_succ_bytes                   0x158ef0000       (5,787,025,408)

[time lasts]: 11
        rx_msg_succ_bytes                   0x15ad30000       (5,818,744,832)

[time lasts]: 12
        rx_msg_succ_bytes                   0x159ee0000       (5,803,737,088)

[time lasts]: 13
        rx_msg_succ_bytes                   0x15bc00000       (5,834,276,864)

[time lasts]: 14
        rx_msg_succ_bytes                   0x1589d0000       (5,781,651,456)

[time lasts]: 15
        rx_msg_succ_bytes                   0x157f60000       (5,770,706,944)

[time lasts]: 16
        rx_msg_succ_bytes                   0x15a290000       (5,807,603,712)

[time lasts]: 17
        rx_msg_succ_bytes                   0x1582f0000       (5,774,442,496)

[time lasts]: 18
        rx_msg_succ_bytes                   0x15b3e0000       (5,825,757,184)

[time lasts]: 19
        rx_msg_succ_bytes                   0x15abc0000       (5,817,237,504)

[time lasts]: 20
        rx_msg_succ_bytes                   0x159010000       (5,788,205,056)

[time lasts]: 21
        rx_msg_succ_bytes                   0x15c080000       (5,838,995,456)

[time lasts]: 22
        rx_msg_succ_bytes                   0x159410000       (5,792,399,360)

[time lasts]: 23
        rx_msg_succ_bytes                   0x158fc0000       (5,787,877,376)

[time lasts]: 24
        rx_msg_succ_bytes                   0x1531c0000       (5,689,311,232)

[time lasts]: 25
        rx_msg_succ_bytes                   0x158520000       (5,776,736,256)

[time lasts]: 26
        rx_msg_succ_bytes                   0x15a720000       (5,812,387,840)

[time lasts]: 27
        rx_msg_succ_bytes                   0x157980000       (5,764,546,560)

[time lasts]: 28
        rx_msg_succ_bytes                   0x159660000       (5,794,824,192)

[time lasts]: 29
        rx_msg_succ_bytes                   0x157d30000       (5,768,413,184)

[time lasts]: 30
        rx_msg_succ_bytes                   0x15a890000       (5,813,895,168)

[time lasts]: 31
        rx_msg_succ_bytes                   0x159630000       (5,794,627,584)

[time lasts]: 32
        rx_msg_succ_bytes                   0x15cff0000       (5,855,182,848)

[time lasts]: 33
        rx_msg_succ_bytes                   0x15d700000       (5,862,588,416)

[time lasts]: 34
        rx_msg_succ_bytes                   0x158100000       (5,772,410,880)

[time lasts]: 35
        rx_msg_succ_bytes                   0x15ccf0000       (5,852,037,120)

[time lasts]: 36
        rx_msg_succ_bytes                   0x15b790000       (5,829,623,808)

[time lasts]: 37
        rx_msg_succ_bytes                   0x159570000       (5,793,841,152)

[time lasts]: 38
        rx_msg_succ_bytes                   0x15c070000       (5,838,929,920)

[time lasts]: 39
        rx_msg_succ_bytes                   0x158380000       (5,775,032,320)

[time lasts]: 40
        rx_msg_succ_bytes                   0x155d40000       (5,734,924,288)

[time lasts]: 41
        rx_msg_succ_bytes                   0x15af50000       (5,820,973,056)

[time lasts]: 42
        rx_msg_succ_bytes                   0x157c20000       (5,767,299,072)

[time lasts]: 43
        rx_msg_succ_bytes                   0x158530000       (5,776,801,792)

[time lasts]: 44
        rx_msg_succ_bytes                   0x15b2f0000       (5,824,774,144)

[time lasts]: 45
        rx_msg_succ_bytes                   0x15a660000       (5,811,601,408)

[time lasts]: 46
        rx_msg_succ_bytes                   0x158840000       (5,780,013,056)

[time lasts]: 47
        rx_msg_succ_bytes                   0x1585e0000       (5,777,522,688)

[time lasts]: 48
        rx_msg_succ_bytes                   0x158070000       (5,771,821,056)

[time lasts]: 49
        rx_msg_succ_bytes                   0x156ce0000       (5,751,308,288)

[time lasts]: 50
        rx_msg_succ_bytes                   0x158ed0000       (5,786,894,336)

[time lasts]: 51
        rx_msg_succ_bytes                   0x15a580000       (5,810,683,904)

[time lasts]: 52
        rx_msg_succ_bytes                   0x15adc0000       (5,819,334,656)

[time lasts]: 53
        rx_msg_succ_bytes                   0x1589d0000       (5,781,651,456)

[time lasts]: 54
        rx_msg_succ_bytes                   0x15b410000       (5,825,953,792)

[time lasts]: 55
        rx_msg_succ_bytes                   0x158890000       (5,780,340,736)

[time lasts]: 56
        rx_msg_succ_bytes                   0x153660000       (5,694,160,896)

[time lasts]: 57
        rx_msg_succ_bytes                   0x15a7a0000       (5,812,912,128)

[time lasts]: 58
        rx_msg_succ_bytes                   0x158ce0000       (5,784,862,720)

[time lasts]: 59
        rx_msg_succ_bytes                   0x157720000       (5,762,056,192)

[time lasts]: 60
        rx_msg_succ_bytes                   0x158d80000       (5,785,518,080)

[time lasts]: 61
        rx_msg_succ_bytes                   0x158440000       (5,775,818,752)

[time lasts]: 62
        rx_msg_succ_bytes                   0x157430000       (5,758,976,000)

[time lasts]: 63
        rx_msg_succ_bytes                   0x159c60000       (5,801,115,648)

[time lasts]: 64
        rx_msg_succ_bytes                   0x15a440000       (5,809,373,184)
^Ccaught signal 2

/*
 * logs of TX node 1.
 */

provo-dirt:/home/admin/tyler # echo dctcp >/proc/sys/net/ipv4/tcp_congestion_control
provo-dirt:/home/admin/tyler # cat /proc/sys/net/ipv4/tcp_congestion_control
dctcp

provo-dirt:/home/admin/tyler # date; ./tcp_perf.exe --server-ip 169.254.85.4  --server-port 10001 --msg-len 65536 --conn-num 8 -c -t --data-random --show-bandwidth-only
Fri Mar 25 09:53:52 EDT 2022

conn [0] local 169.254.85.1:49500 peer 169.254.85.4:10001 created.
conn [1] local 169.254.85.1:49502 peer 169.254.85.4:10001 created.
conn [2] local 169.254.85.1:49504 peer 169.254.85.4:10001 created.
conn [3] local 169.254.85.1:49506 peer 169.254.85.4:10001 created.
conn [4] local 169.254.85.1:49508 peer 169.254.85.4:10001 created.
conn [5] local 169.254.85.1:49510 peer 169.254.85.4:10001 created.
conn [6] local 169.254.85.1:49512 peer 169.254.85.4:10001 created.
conn [7] local 169.254.85.1:49514 peer 169.254.85.4:10001 created.
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
        tx_succ_bytes                       0x82fd0000        (2,197,618,688)

[time lasts]: 2
        tx_succ_bytes                       0x7dbe0000        (2,109,603,840)

[time lasts]: 3
        tx_succ_bytes                       0x82120000        (2,182,217,728)

[time lasts]: 4
        tx_succ_bytes                       0x75890000        (1,971,912,704)

[time lasts]: 5
        tx_succ_bytes                       0x67040000        (1,728,315,392)

[time lasts]: 6
        tx_succ_bytes                       0x754d0000        (1,967,980,544)

[time lasts]: 7
        tx_succ_bytes                       0x74be0000        (1,958,608,896)

[time lasts]: 8
        tx_succ_bytes                       0x79670000        (2,036,793,344)

[time lasts]: 9
        tx_succ_bytes                       0x7fb00000        (2,142,240,768)

[time lasts]: 10
        tx_succ_bytes                       0x730d0000        (1,930,231,808)

[time lasts]: 11
        tx_succ_bytes                       0x6f9b0000        (1,872,429,056)

[time lasts]: 12
        tx_succ_bytes                       0x58d60000        (1,490,419,712)

[time lasts]: 13
        tx_succ_bytes                       0x72b40000        (1,924,399,104)

[time lasts]: 14
        tx_succ_bytes                       0x5f190000        (1,595,473,920)

[time lasts]: 15
        tx_succ_bytes                       0x66590000        (1,717,108,736)

[time lasts]: 16
        tx_succ_bytes                       0x72bc0000        (1,924,923,392)

[time lasts]: 17
        tx_succ_bytes                       0x69460000        (1,766,195,200)

[time lasts]: 18
        tx_succ_bytes                       0x7a8c0000        (2,055,995,392)

[time lasts]: 19
        tx_succ_bytes                       0x630c0000        (1,661,730,816)

[time lasts]: 20
        tx_succ_bytes                       0x608c0000        (1,619,787,776)

[time lasts]: 21
        tx_succ_bytes                       0x64680000        (1,684,537,344)

[time lasts]: 22
        tx_succ_bytes                       0x5d250000        (1,562,705,920)

[time lasts]: 23
        tx_succ_bytes                       0x7ba60000        (2,074,476,544)

[time lasts]: 24
        tx_succ_bytes                       0x76120000        (1,980,891,136)

[time lasts]: 25
        tx_succ_bytes                       0x5a2a0000        (1,512,701,952)

[time lasts]: 26
        tx_succ_bytes                       0x6e550000        (1,851,064,320)

[time lasts]: 27
        tx_succ_bytes                       0x60650000        (1,617,231,872)

[time lasts]: 28
        tx_succ_bytes                       0x78cb0000        (2,026,569,728)

[time lasts]: 29
        tx_succ_bytes                       0x71c80000        (1,908,932,608)

[time lasts]: 30
        tx_succ_bytes                       0x66190000        (1,712,914,432)

[time lasts]: 31
        tx_succ_bytes                       0x6c760000        (1,819,672,576)

[time lasts]: 32
        tx_succ_bytes                       0x77b20000        (2,008,154,112)

[time lasts]: 33
        tx_succ_bytes                       0x6eab0000        (1,856,700,416)

[time lasts]: 34
        tx_succ_bytes                       0x85160000        (2,232,811,520)

[time lasts]: 35
        tx_succ_bytes                       0x71f70000        (1,912,012,800)

[time lasts]: 36
        tx_succ_bytes                       0x6ec30000        (1,858,273,280)

[time lasts]: 37
        tx_succ_bytes                       0x7b1d0000        (2,065,498,112)

[time lasts]: 38
        tx_succ_bytes                       0x74eb0000        (1,961,558,016)

[time lasts]: 39
        tx_succ_bytes                       0x72eb0000        (1,928,003,584)

[time lasts]: 40
        tx_succ_bytes                       0x76700000        (1,987,051,520)

[time lasts]: 41
        tx_succ_bytes                       0x721a0000        (1,914,306,560)

[time lasts]: 42
        tx_succ_bytes                       0x69500000        (1,766,850,560)

[time lasts]: 43
        tx_succ_bytes                       0x70fe0000        (1,895,694,336)

[time lasts]: 44
        tx_succ_bytes                       0x7e640000        (2,120,482,816)

[time lasts]: 45
        tx_succ_bytes                       0x6a090000        (1,778,974,720)

[time lasts]: 46
        tx_succ_bytes                       0x6e2b0000        (1,848,311,808)

[time lasts]: 47
        tx_succ_bytes                       0x5e0f0000        (1,578,041,344)

[time lasts]: 48
        tx_succ_bytes                       0x670f0000        (1,729,036,288)

[time lasts]: 49
        tx_succ_bytes                       0x77390000        (2,000,224,256)

[time lasts]: 50
        tx_succ_bytes                       0x77360000        (2,000,027,648)

[time lasts]: 51
        tx_succ_bytes                       0x7c040000        (2,080,636,928)

[time lasts]: 52
        tx_succ_bytes                       0x678c0000        (1,737,228,288)

[time lasts]: 53
        tx_succ_bytes                       0x69720000        (1,769,078,784)

[time lasts]: 54
        tx_succ_bytes                       0x683a0000        (1,748,631,552)

[time lasts]: 55
        tx_succ_bytes                       0x769d0000        (1,990,000,640)

[time lasts]: 56
        tx_succ_bytes                       0x77270000        (1,999,044,608)

[time lasts]: 57
        tx_succ_bytes                       0x671a0000        (1,729,757,184)

[time lasts]: 58
        tx_succ_bytes                       0x6c4a0000        (1,816,788,992)

[time lasts]: 59
        tx_succ_bytes                       0x7c370000        (2,083,979,264)

[time lasts]: 60
        tx_succ_bytes                       0x82a00000        (2,191,523,840)

[time lasts]: 61
        tx_succ_bytes                       0x6f980000        (1,872,232,448)

[time lasts]: 62
        tx_succ_bytes                       0x75d50000        (1,976,893,440)

[time lasts]: 63
        tx_succ_bytes                       0x75a20000        (1,973,551,104)

/*
 * logs of TX node 2.
 */

sandy-dirt:/home/admin/tyler # echo dctcp >/proc/sys/net/ipv4/tcp_congestion_control
sandy-dirt:/home/admin/tyler # cat /proc/sys/net/ipv4/tcp_congestion_control
dctcp

sandy-dirt:/home/admin/tyler # date; ./tcp_perf.exe --server-ip 169.254.85.4  --server-port 10001 --msg-len 65536 --conn-num 8 -c -t --data-random --show-bandwidth-only
Fri Mar 25 09:53:51 EDT 2022

conn [0] local 169.254.85.2:37992 peer 169.254.85.4:10001 created.
conn [1] local 169.254.85.2:37994 peer 169.254.85.4:10001 created.
conn [2] local 169.254.85.2:37996 peer 169.254.85.4:10001 created.
conn [3] local 169.254.85.2:37998 peer 169.254.85.4:10001 created.
conn [4] local 169.254.85.2:38000 peer 169.254.85.4:10001 created.
conn [5] local 169.254.85.2:38002 peer 169.254.85.4:10001 created.
conn [6] local 169.254.85.2:38004 peer 169.254.85.4:10001 created.
conn [7] local 169.254.85.2:38006 peer 169.254.85.4:10001 created.
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
        tx_succ_bytes                       0x9acb0000        (2,596,995,072)

[time lasts]: 2
        tx_succ_bytes                       0x6d5b0000        (1,834,680,320)

[time lasts]: 3
        tx_succ_bytes                       0x77070000        (1,996,947,456)

[time lasts]: 4
        tx_succ_bytes                       0x5f3b0000        (1,597,702,144)

[time lasts]: 5
        tx_succ_bytes                       0x6f690000        (1,869,152,256)

[time lasts]: 6
        tx_succ_bytes                       0x80690000        (2,154,364,928)

[time lasts]: 7
        tx_succ_bytes                       0x6c880000        (1,820,852,224)

[time lasts]: 8
        tx_succ_bytes                       0x6a640000        (1,784,938,496)

[time lasts]: 9
        tx_succ_bytes                       0x6dc50000        (1,841,627,136)

[time lasts]: 10
        tx_succ_bytes                       0x694d0000        (1,766,653,952)

[time lasts]: 11
        tx_succ_bytes                       0x69ee0000        (1,777,205,248)

[time lasts]: 12
        tx_succ_bytes                       0x6e630000        (1,851,981,824)

[time lasts]: 13
        tx_succ_bytes                       0x79a50000        (2,040,856,576)

[time lasts]: 14
        tx_succ_bytes                       0x73f90000        (1,945,698,304)

[time lasts]: 15
        tx_succ_bytes                       0x79280000        (2,032,664,576)

[time lasts]: 16
        tx_succ_bytes                       0x743b0000        (1,950,023,680)

[time lasts]: 17
        tx_succ_bytes                       0x6be00000        (1,809,842,176)

[time lasts]: 18
        tx_succ_bytes                       0x63d10000        (1,674,641,408)

[time lasts]: 19
        tx_succ_bytes                       0x69570000        (1,767,309,312)

[time lasts]: 20
        tx_succ_bytes                       0x87ed0000        (2,280,456,192)

[time lasts]: 21
        tx_succ_bytes                       0x76730000        (1,987,248,128)

[time lasts]: 22
        tx_succ_bytes                       0x75fa0000        (1,979,318,272)

[time lasts]: 23
        tx_succ_bytes                       0x84760000        (2,222,325,760)

[time lasts]: 24
        tx_succ_bytes                       0x6de60000        (1,843,789,824)

[time lasts]: 25
        tx_succ_bytes                       0x701b0000        (1,880,817,664)

[time lasts]: 26
        tx_succ_bytes                       0x7d400000        (2,101,346,304)

[time lasts]: 27
        tx_succ_bytes                       0x77650000        (2,003,107,840)

[time lasts]: 28
        tx_succ_bytes                       0x71570000        (1,901,527,040)

[time lasts]: 29
        tx_succ_bytes                       0x798e0000        (2,039,349,248)

[time lasts]: 30
        tx_succ_bytes                       0x70490000        (1,883,832,320)

[time lasts]: 31
        tx_succ_bytes                       0x84820000        (2,223,112,192)

[time lasts]: 32
        tx_succ_bytes                       0x88690000        (2,288,582,656)

[time lasts]: 33
        tx_succ_bytes                       0x72a30000        (1,923,284,992)

[time lasts]: 34
        tx_succ_bytes                       0x79ae0000        (2,041,446,400)

[time lasts]: 35
        tx_succ_bytes                       0x6fce0000        (1,875,771,392)

[time lasts]: 36
        tx_succ_bytes                       0x69680000        (1,768,423,424)

[time lasts]: 37
        tx_succ_bytes                       0x65430000        (1,698,889,728)

[time lasts]: 38
        tx_succ_bytes                       0x84ff0000        (2,231,304,192)

[time lasts]: 39
        tx_succ_bytes                       0x7dd10000        (2,110,849,024)

[time lasts]: 40
        tx_succ_bytes                       0x70480000        (1,883,766,784)

[time lasts]: 41
        tx_succ_bytes                       0x7b8c0000        (2,072,772,608)

[time lasts]: 42
        tx_succ_bytes                       0x75a90000        (1,974,009,856)

[time lasts]: 43
        tx_succ_bytes                       0x83110000        (2,198,929,408)

[time lasts]: 44
        tx_succ_bytes                       0x739e0000        (1,939,734,528)

[time lasts]: 45
        tx_succ_bytes                       0x665a0000        (1,717,174,272)

[time lasts]: 46
        tx_succ_bytes                       0x6f0c0000        (1,863,057,408)

[time lasts]: 47
        tx_succ_bytes                       0x7b530000        (2,069,037,056)

[time lasts]: 48
        tx_succ_bytes                       0x850d0000        (2,232,221,696)

[time lasts]: 49
        tx_succ_bytes                       0x7c6c0000        (2,087,452,672)

[time lasts]: 50
        tx_succ_bytes                       0x72d60000        (1,926,627,328)

[time lasts]: 51
        tx_succ_bytes                       0x6f790000        (1,870,200,832)

[time lasts]: 52
        tx_succ_bytes                       0x65be0000        (1,706,950,656)

[time lasts]: 53
        tx_succ_bytes                       0x89470000        (2,303,131,648)

[time lasts]: 54
        tx_succ_bytes                       0x84290000        (2,217,279,488)

[time lasts]: 55
        tx_succ_bytes                       0x739a0000        (1,939,472,384)

[time lasts]: 56
        tx_succ_bytes                       0x60fb0000        (1,627,062,272)

[time lasts]: 57
        tx_succ_bytes                       0x82570000        (2,186,739,712)

[time lasts]: 58
        tx_succ_bytes                       0x76fb0000        (1,996,161,024)

[time lasts]: 59
        tx_succ_bytes                       0x71dc0000        (1,910,243,328)

[time lasts]: 60
        tx_succ_bytes                       0x73fd0000        (1,945,960,448)

[time lasts]: 61
        tx_succ_bytes                       0x710c0000        (1,896,611,840)

[time lasts]: 62
        tx_succ_bytes                       0x77ea0000        (2,011,824,128)

[time lasts]: 63
        tx_succ_bytes                       0x6b9b0000        (1,805,320,192)

/*
 * logs of TX node 3.
 */

orem-dirt:/home/admin/tyler # echo dctcp >/proc/sys/net/ipv4/tcp_congestion_control
orem-dirt:/home/admin/tyler # cat /proc/sys/net/ipv4/tcp_congestion_control
dctcp

orem-dirt:/home/admin/tyler # date; ./tcp_perf.exe --server-ip 169.254.85.4  --server-port 10001 --msg-len 65536 --conn-num 8 -c -t --data-random --show-bandwidth-only
Fri Mar 25 09:53:50 EDT 2022

conn [0] local 169.254.85.3:59692 peer 169.254.85.4:10001 created.
conn [1] local 169.254.85.3:59694 peer 169.254.85.4:10001 created.
conn [2] local 169.254.85.3:59696 peer 169.254.85.4:10001 created.
conn [3] local 169.254.85.3:59698 peer 169.254.85.4:10001 created.
conn [4] local 169.254.85.3:59700 peer 169.254.85.4:10001 created.
conn [5] local 169.254.85.3:59702 peer 169.254.85.4:10001 created.
conn [6] local 169.254.85.3:59706 peer 169.254.85.4:10001 created.
conn [7] local 169.254.85.3:59708 peer 169.254.85.4:10001 created.
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
        tx_succ_bytes                       0x123670000       (4,888,920,064)

[time lasts]: 2
        tx_succ_bytes                       0x83950000        (2,207,580,160)

[time lasts]: 3
        tx_succ_bytes                       0x76440000        (1,984,167,936)

[time lasts]: 4
        tx_succ_bytes                       0x69280000        (1,764,229,120)

[time lasts]: 5
        tx_succ_bytes                       0x79240000        (2,032,402,432)

[time lasts]: 6
        tx_succ_bytes                       0x79ab0000        (2,041,249,792)

[time lasts]: 7
        tx_succ_bytes                       0x70370000        (1,882,652,672)

[time lasts]: 8
        tx_succ_bytes                       0x79660000        (2,036,727,808)

[time lasts]: 9
        tx_succ_bytes                       0x7e170000        (2,115,436,544)

[time lasts]: 10
        tx_succ_bytes                       0x719f0000        (1,906,245,632)

[time lasts]: 11
        tx_succ_bytes                       0x69e20000        (1,776,418,816)

[time lasts]: 12
        tx_succ_bytes                       0x7bbd0000        (2,075,983,872)

[time lasts]: 13
        tx_succ_bytes                       0x89910000        (2,307,981,312)

[time lasts]: 14
        tx_succ_bytes                       0x7a750000        (2,054,488,064)

[time lasts]: 15
        tx_succ_bytes                       0x7c7e0000        (2,088,632,320)

[time lasts]: 16
        tx_succ_bytes                       0x88b00000        (2,293,235,712)

[time lasts]: 17
        tx_succ_bytes                       0x71d10000        (1,909,522,432)

[time lasts]: 18
        tx_succ_bytes                       0x897a0000        (2,306,473,984)

[time lasts]: 19
        tx_succ_bytes                       0x78cf0000        (2,026,831,872)

[time lasts]: 20
        tx_succ_bytes                       0x7cc80000        (2,093,481,984)

[time lasts]: 21
        tx_succ_bytes                       0x803f0000        (2,151,612,416)

[time lasts]: 22
        tx_succ_bytes                       0x77170000        (1,997,996,032)

[time lasts]: 23
        tx_succ_bytes                       0x7bf80000        (2,079,850,496)

[time lasts]: 24
        tx_succ_bytes                       0x686c0000        (1,751,908,352)

[time lasts]: 25
        tx_succ_bytes                       0x764b0000        (1,984,626,688)

[time lasts]: 26
        tx_succ_bytes                       0x78b80000        (2,025,324,544)

[time lasts]: 27
        tx_succ_bytes                       0x77d40000        (2,010,382,336)

[time lasts]: 28
        tx_succ_bytes                       0x86830000        (2,256,732,160)

[time lasts]: 29
        tx_succ_bytes                       0x761b0000        (1,981,480,960)

[time lasts]: 30
        tx_succ_bytes                       0x6d880000        (1,837,629,440)

[time lasts]: 31
        tx_succ_bytes                       0x74060000        (1,946,550,272)

[time lasts]: 32
        tx_succ_bytes                       0x74aa0000        (1,957,298,176)

[time lasts]: 33
        tx_succ_bytes                       0x61a60000        (1,638,268,928)

[time lasts]: 34
        tx_succ_bytes                       0x735b0000        (1,935,343,616)

[time lasts]: 35
        tx_succ_bytes                       0x6f220000        (1,864,499,200)

[time lasts]: 36
        tx_succ_bytes                       0x73240000        (1,931,739,136)

[time lasts]: 37
        tx_succ_bytes                       0x755c0000        (1,968,963,584)

[time lasts]: 38
        tx_succ_bytes                       0x6e0a0000        (1,846,149,120)

[time lasts]: 39
        tx_succ_bytes                       0x682f0000        (1,747,910,656)

[time lasts]: 40
        tx_succ_bytes                       0x676b0000        (1,735,065,600)

[time lasts]: 41
        tx_succ_bytes                       0x71ca0000        (1,909,063,680)

[time lasts]: 42
        tx_succ_bytes                       0x6d740000        (1,836,318,720)

[time lasts]: 43
        tx_succ_bytes                       0x6f9d0000        (1,872,560,128)

[time lasts]: 44
        tx_succ_bytes                       0x6cec0000        (1,827,405,824)

[time lasts]: 45
        tx_succ_bytes                       0x82ae0000        (2,192,441,344)

[time lasts]: 46
        tx_succ_bytes                       0x783b0000        (2,017,132,544)

[time lasts]: 47
        tx_succ_bytes                       0x73300000        (1,932,525,568)

[time lasts]: 48
        tx_succ_bytes                       0x6e580000        (1,851,260,928)

[time lasts]: 49
        tx_succ_bytes                       0x77ab0000        (2,007,695,360)

[time lasts]: 50
        tx_succ_bytes                       0x67a80000        (1,739,063,296)

[time lasts]: 51
        tx_succ_bytes                       0x7a490000        (2,051,604,480)

[time lasts]: 52
        tx_succ_bytes                       0x73d00000        (1,943,011,328)

[time lasts]: 53
        tx_succ_bytes                       0x74110000        (1,947,271,168)

[time lasts]: 54
        tx_succ_bytes                       0x6d360000        (1,832,255,488)

[time lasts]: 55
        tx_succ_bytes                       0x730c0000        (1,930,166,272)

[time lasts]: 56
        tx_succ_bytes                       0x6ed20000        (1,859,256,320)

[time lasts]: 57
        tx_succ_bytes                       0x73de0000        (1,943,928,832)

[time lasts]: 58
        tx_succ_bytes                       0x70660000        (1,885,732,864)

[time lasts]: 59
        tx_succ_bytes                       0x723e0000        (1,916,665,856)

[time lasts]: 60
        tx_succ_bytes                       0x7a4c0000        (2,051,801,088)

[time lasts]: 61
        tx_succ_bytes                       0x6d8a0000        (1,837,760,512)

[time lasts]: 62
        tx_succ_bytes                       0x5f650000        (1,600,454,656)

[time lasts]: 63
        tx_succ_bytes                       0x74180000        (1,947,729,920)

/*
 * counters on the switch.
 * we can see, the rate of packet dropping is so high (~5%).
 */

hound-dirt# show queuing statistics interface ethernet 1/1/4
Interface ethernet1/1/4
Queue Packets                  Bytes                    Dropped-Packets          Dropped-Bytes            
0     18                       1218                     0                        0                        
1     36                       3528                     0                        0                        
2     0                        0                        0                        0                        
3     0                        0                        0                        0                        
4     0                        0                        0                        0                        
5     21037361                 189283361906             953632                   8583259654               
6     0                        0                        0                        0                        
7     0                        0                        0                        0                        
hound-dirt#

fox-dirt# show queuing statistics interface ethernet 1/1/4
Interface ethernet1/1/4
Queue Packets                  Bytes                    Dropped-Packets          Dropped-Bytes            
0     41                       2666                     0                        0                        
1     28                       2744                     0                        0                        
2     0                        0                        0                        0                        
3     0                        0                        0                        0                        
4     0                        0                        0                        0                        
5     21026196                 189216241992             962777                   8667910211               
6     0                        0                        0                        0                        
7     0                        0                        0                        0                        
fox-dirt#
