Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA0C1BF033
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 08:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgD3GYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 02:24:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40608 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbgD3GYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 02:24:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U6Ix6B082343;
        Thu, 30 Apr 2020 06:24:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : from : subject :
 message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=XUwJL7oKOvoszyS/pb+1mdNcUr5KwBxkTglA4j36pMU=;
 b=kQc87b/I3J5Nnjil4m2k/qesDrfxTbSs+pH0DiRKA0liP76VzmH4QFoP4jURYACzUNPj
 6fsWBUo/xCL7DeKC69eIHOoCkFag642cL9v8zIGU3XBCkUPsvrpSAHgXmLYQdjM5YN0P
 5+uGWkzzJfQI5Ixp88QkGWiUYtAEKVfzLa6AsJ1wMXBS0YRkB802FpHtJcQznEhL6YxB
 6Osv+4blmVNyI3wU2ZPHV0sPkRkTuZ/zb44XinYerutnz2A06OW88tRM3uUu9CndTqz3
 tIZqIYZblRaFaDPteHcGtOCWVqY0v7H9UfWrvr0VRixIzbZSBWFcDmKhCzX6wzbF0F1U cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucg9huy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 06:24:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U6Cmx4065196;
        Thu, 30 Apr 2020 06:24:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30mxpmvs20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 06:24:29 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03U6OQn1019770;
        Thu, 30 Apr 2020 06:24:26 GMT
Received: from [10.166.176.96] (/10.166.176.96)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 23:24:26 -0700
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
From:   Allen <allen.pais@oracle.com>
Subject: Net: [DSA]: dsa-loop kernel panic
Message-ID: <9d7ac811-f3c9-ff13-5b81-259daa8c424f@oracle.com>
Date:   Thu, 30 Apr 2020 11:54:15 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=762 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 mlxlogscore=817 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300050
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

   We ran into a kernel panic with dsa-loop.
Here are the details:

VM: aarch64 kvm running 5.7.0-rc3+

$ modprobe dsa-loop
[   25.968427] dsa-loop fixed-0:1f: DSA mockup driver: 0x1f
[   25.978156] libphy: dsa slave smi: probed
[   25.979230] dsa-loop fixed-0:1f: nonfatal error -95 setting MTU on port 0
[   25.980974] dsa-loop fixed-0:1f lan1 (uninitialized): PHY 
[dsa-0.0:00] driver [Generic PHY] (irq=POLL)
[   25.983855] dsa-loop fixed-0:1f: nonfatal error -95 setting MTU on port 1
[   25.985523] dsa-loop fixed-0:1f lan2 (uninitialized): PHY 
[dsa-0.0:01] driver [Generic PHY] (irq=POLL)
[   25.988127] dsa-loop fixed-0:1f: nonfatal error -95 setting MTU on port 2
[   25.989775] dsa-loop fixed-0:1f lan3 (uninitialized): PHY 
[dsa-0.0:02] driver [Generic PHY] (irq=POLL)
[   25.992651] dsa-loop fixed-0:1f: nonfatal error -95 setting MTU on port 3
[   25.994472] dsa-loop fixed-0:1f lan4 (uninitialized): PHY 
[dsa-0.0:03] driver [Generic PHY] (irq=POLL)
[   25.997015] DSA: tree 0 setup
[root@localhost ~]# [   26.002672] dsa-loop fixed-0:1f lan1: configuring 
for phy/gmii link mode
[   26.008264] dsa-loop fixed-0:1f lan1: Link is Up - 100Mbps/Full - 
flow control off
[   26.010098] IPv6: ADDRCONF(NETDEV_CHANGE): lan1: link becomes ready
[   26.014539] dsa-loop fixed-0:1f lan3: configuring for phy/gmii link mode
[   26.021323] dsa-loop fixed-0:1f lan2: configuring for phy/gmii link mode
[   26.023274] dsa-loop fixed-0:1f lan3: Link is Up - 100Mbps/Full - 
flow control off
[   26.028358] dsa-loop fixed-0:1f lan4: configuring for phy/gmii link mode
[   26.036157] dsa-loop fixed-0:1f lan2: Link is Up - 100Mbps/Full - 
flow control off
[   26.037875] dsa-loop fixed-0:1f lan4: Link is Up - 100Mbps/Full - 
flow control off
[   26.039858] IPv6: ADDRCONF(NETDEV_CHANGE): lan3: link becomes ready
[   26.041527] IPv6: ADDRCONF(NETDEV_CHANGE): lan2: link becomes ready
[   26.043219] IPv6: ADDRCONF(NETDEV_CHANGE): lan4: link becomes ready



$ rmmod dsa-loop
[   50.688935] Unable to handle kernel read from unreadable memory at 
virtual address 0000000000000040
[   50.690775] Mem abort info:
[   50.691285]   ESR = 0x96000005
[   50.691831]   EC = 0x25: DABT (current EL), IL = 32 bits
[   50.693061]   SET = 0, FnV = 0
[   50.693799]   EA = 0, S1PTW = 0
[   50.694542] Data abort info:
[   50.695093]   ISV = 0, ISS = 0x00000005
[   50.695841]   CM = 0, WnR = 0
[   50.696543] user pgtable: 64k pages, 48-bit VAs, pgdp=000000020dde7000
[   50.697925] [0000000000000040] pgd=000000020bec0003, 
pud=000000020bec0003, pmd=0000000212ab0003, pte=0000000000000000
[   50.700057] Internal error: Oops: 96000005 [#1] SMP

p650M.e7s0s1a0g4e8 ]f rMoomd uslyseslo lgdin@lkeocd alinh: osdst a_atlo 
oAppr(- 2) 9 ip236t:1_r4:pf06il .te..r
_ t _kReEJrnECelT :Infnt_rerejnaecl t_eirprovr6:  iOpotp_sR:E J9E6C0T0 
0n0f0_5re j[e#c1t]_ iSpMvP4 xt
onntrack ebtable_nat ebtable_broute ip6table_nat ip6table_mangle 
ip6table_security ip6table_raw iptable_nat nf_nat iptable_mangle 
iptable_security iptable_raw nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 
ip_set ebtable_filter ebtables rfkill ip6table_filter ip6_tables 
iptable_filter vfat fat aes_ce_blk crypto_simd cryptd aes_ce_cipher 
crct10dif_ce ghash_ce sha2_ce sha256_arm64 sha1_ce virtio_rng button 
qemu_fw_cfg ip_tables xfs libcrc32c virtio_net net_failover 
virtio_console failover virtio_scsi virtio_pci
[   50.715211] CPU: 3 PID: 1559 Comm: rmmod Not tainted 5.7.0-rc3+ #3
[   50.716620] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 
02/06/2015
[   50.718185] pstate: 60400005 (nZCv daif +PAN -UAO)
[   50.719274] pc : __dev_set_rx_mode+0x48/0xa0
[   50.720252] lr : dev_mc_unsync+0xbc/0xfc
[   50.721129] sp : ffff800010f6f960
[   50.721875] x29: ffff800010f6f960 x28: ffff0001c10d5d40
[   50.723085] x27: 0000000000000000 x26: ffffa039806cfcd0
[   50.724301] x25: ffffa03980f53000 x24: ffffa03980f53000
[   50.725488] x23: 0000000000000001 x22: ffffa03980f53000
[   50.726669] x21: ffffa03980137f1c x20: 0000000000000000
[   50.727849] x19: ffff0001c11a2000 x18: 0000000000000000
[   50.729046] x17: 0000000000000000 x16: ffffa0397fd53578
[   50.730236] x15: 6e04191515120a09 x14: 0000000000000000
[   50.731451] x13: ffff000000000000 x12: ffffffffffffffff
[   50.732681] x11: 0000000000000030 x10: 0000000000001bd0
[   50.733874] x9 : ffff800010f6f6d0 x8 : 0000000000000000
[   50.735054] x7 : ffffffffffffffff x6 : 000000000000ffff
[   50.736261] x5 : 0000000000000001 x4 : ffff0001c2e32f00
[   50.737446] x3 : 0000000000000000 x2 : 0000000000000000
[   50.738631] x1 : ffff0001c2e3bd00 x0 : 0000000000029820
[   50.739815] Call trace:
[   50.740385]  __dev_set_rx_mode+0x48/0xa0
[   50.741267]  dev_mc_unsync+0xbc/0xfc
[   50.742064]  dsa_slave_close+0x34/0xb4
[   50.742905]  __dev_close_many+0xbc/0x13c
[   50.743782]  dev_close_many+0xb8/0x184
[   50.744637]  rollback_registered_many+0x160/0x558
[   50.745691]  rollback_registered+0x68/0xac
[   50.746606]  unregister_netdevice_queue+0x9c/0x128
[   50.747673]  unregister_netdev+0x28/0x38
[   50.748564]  dsa_slave_destroy+0x4c/0x74
[   50.749447]  dsa_port_teardown+0xac/0xb8
[   50.750326]  dsa_tree_teardown_switches+0x38/0x9c
[   50.751372]  dsa_unregister_switch+0x104/0x1c0
[   50.752384]  dsa_loop_drv_remove+0x24/0x54 [dsa_loop]
[   50.753518]  mdio_remove+0x2c/0x48
[   50.754284]  device_release_driver_internal+0xfc/0x1ac
[   50.755428]  driver_detach+0x6c/0xdc
[   50.756244]  bus_remove_driver+0x74/0xe8
[   50.757120]  driver_unregister+0x34/0x5c
[   50.758039]  mdio_driver_unregister+0x20/0x2c
[   50.759026]  dsa_loop_exit+0x1c/0xf670 [dsa_loop]
[   50.760094]  __arm64_sys_delete_module+0x18c/0x29c
[   50.761177]  el0_svc_common.constprop.3+0xdc/0x194
[   50.762288]  do_el0_svc+0x84/0xa0
[   50.763029]  el0_sync_handler+0x80/0x9c
[   50.763888]  el0_sync+0x164/0x180
[   50.764654] Code: b9429275 35000175 3949f660 35000220 (f9402281)
[   50.766046] ---[ end trace 9e9af4eb8dcf17ac ]---
[   50.767088] Kernel panic - not syncing: Fatal exception in interrupt
[   50.768527] SMP: stopping secondary CPUs
[   50.769431] Kernel Offset: 0x20396f4a0000 from 0xffff800010000000
[   50.770796] PHYS_OFFSET: 0xffffd52500000000
[   50.771733] CPU features: 0x080002,20802008
[   50.772620] Memory Limit: none
[   50.773260] ---[ end Kernel panic - not syncing: Fatal exception in 
interrupt ]---

  I haven't had much luck trying to figure what exactly is causing the
panic. Will keep looking, any help here would be great.

Thanks,
- Allen
