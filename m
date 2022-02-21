Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709FF4BDECE
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379258AbiBUPbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 10:31:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379132AbiBUPbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 10:31:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C60E1EADC;
        Mon, 21 Feb 2022 07:30:40 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LEABYR020548;
        Mon, 21 Feb 2022 15:30:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=FEbbldpcjXOBTeshYFzuve/tya51ru7VmYw2y5imrvI=;
 b=l3zwljkbSTSfCsEgQAOVNo9yxsLmEq4T8ypqzDbIxvH6ieqxBhPUJTk/uVDrozFbu1Ej
 LOnCLxcEEbZuEfeOtlLEfZMk9+LB1oywHGzxpr4vAcukPXJ3p9V6Hg8qwkIlBqKHMNVI
 tNQR0azf/xLRnybtD72/KNoq+MWiMgQ+VGn0H5E0LvISrfAIu6pljIrqou++8OS6qYqW
 d3XK0wWnXSfE7pEaSRpsSCODoQZEmdRWbvDPneeE0hx+aDu8vlhtmNaBv1+Oy6JDiTF6
 u03uw3ZuxFilwTF/eInbbFwyNUqDJ1I9wl+rZ63puq/OT0aQVoOTX36rwFJxuMEufjC5 sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eca3smxkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 15:30:39 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21LFT01D004663;
        Mon, 21 Feb 2022 15:30:39 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eca3smxjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 15:30:39 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LFCvoN015745;
        Mon, 21 Feb 2022 15:30:37 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ear68un45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 15:30:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LFUXGn44630276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 15:30:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76C004C046;
        Mon, 21 Feb 2022 15:30:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DA114C04A;
        Mon, 21 Feb 2022 15:30:33 +0000 (GMT)
Received: from sig-9-145-162-217.de.ibm.com (unknown [9.145.162.217])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Feb 2022 15:30:32 +0000 (GMT)
Message-ID: <0849c2a2e2f95a0adbbea04ef3cf12a35ce16645.camel@linux.ibm.com>
Subject: Re: [PATCH 0/4] RDMA device net namespace support for SMC
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, kgraul@linux.ibm.com,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>
Date:   Mon, 21 Feb 2022 16:30:32 +0100
In-Reply-To: <YhM3OC3Bz6pVeIwr@TonyMac-Alibaba>
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
         <8701fa4557026983a9ec687cfdd7ac5b3b85fd39.camel@linux.ibm.com>
         <YhM3OC3Bz6pVeIwr@TonyMac-Alibaba>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gyBSUUiY3cfPwKR2HddvFasd30OFVAhN
X-Proofpoint-ORIG-GUID: LJ9eSUbcCIWMth2s-eUFEJcnUu7XiaWR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_07,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-02-21 at 14:54 +0800, Tony Lu wrote:
> On Thu, Feb 17, 2022 at 12:33:06PM +0100, Niklas Schnelle wrote:
> > On Tue, 2021-12-28 at 21:06 +0800, Tony Lu wrote:
> > 
---8<---
> > Hi Tony,
> > 
> > I'm having a bit of trouble getting this to work for me and was
> > wondering if you could test my scenario or help me figure out what's
> > wrong.
> > 
> > I'm using network namespacing to be able to test traffic between two
> > VFs of the same card/port with a single Linux system. By having one VF
> > in each of a client and server namespace, traffic doesn't shortcut via
> > loopback. This works great for TCP and with "rdma system set netns
> > exclusive" I can also verify that RDMA with "qperf -cm1 ... rc_bw" only
> > works once the respective RDMA device is also added to each namespace.
> > 
> > When I try the same with SMC-R I tried:
> > 
> >   ip netns exec server smc_run qperf &
> >   ip netns exec client smc_run qperf <ip_server> tcp_bw
> > 
> > With that however I only see fallback TCP connections in "ip netns exec
> > client watch smc_dbg". It doesn't seem to be an "smc_dbg" problem
> > either since the performance with and without smc_run is the same. I
> > also do have the same PNET_ID set on the interfaces.
> 
> Hi Niklas,
> 
> I understood your problem. This connection falls back to TCP for unknown
> reasons. You can find out the fallback reason of this connection. It can
> help us find out the root cause of fallbacks. For example,
> if SMC_CLC_DECL_MEM (0x01010000) is occurred in this connection, it
> means that there is no enough memory (smc_init_info, sndbuf, RMB,
> proposal buf, clc msg).

Regarding fallback reason. It seems to be that the RDMA device is not
found (0x03030000) in smd_dbg on I see the following lines:

Server:
State          UID   Inode   Local Address           Peer Address            Intf Mode Shutd Token    Sndbuf ..
LISTEN         00000 0103804 0.0.0.0:37373
ACTIVE         00000 0112895 ::ffff:10.10.93..:46093 ::ffff:10.10.93..:54474 0000 TCP 0x03030000
ACTIVE         00000 0112701 ::ffff:10.10.93..:19765 ::ffff:10.10.93..:51934 0000 TCP 0x03030000
LISTEN         00000 0112699 0.0.0.0:19765

Client:
State          UID   Inode   Local Address           Peer Address            Intf Mode Shutd Token    Sndbuf ...
ACTIVE         00000 0116203 10.10.93.11:54474       10.10.93.12:46093       0000 TCP 0x05000000/0x03030000
ACTIVE         00000 0116201 10.10.93.11:51934       10.10.93.12:19765       0000 TCP 0x05000000/0x03030000


However this doesn't match what I'm seeing in the other commands below

> 
> Before you giving out the fallback reason, based on your environment,
> this are some potential possibilities. You can check this list:
> 
> - RDMA device availability in netns. Run "ip netns exec server rdma dev"
>   to check RDMA device in both server/client. If exclusive mode is setted,
>   it should have different devices in different netns.

I get the following output that looks as expected to me:

Server:
2: roceP9p0s0: node_type ca fw 14.25.1020 node_guid 1d82:ff9b:1bfe:2c28 sys_image_guid 282c:001b:9b03:9803
Client:
4: roceP11p0s0: node_type ca fw 14.25.1020 node_guid 0982:ff9b:63fe:64e7 sys_image_guid e764:0063:9b03:9803


> - SMC-R device availability in netns. Run "ip netns exec server smcr d"
>   to check SMC device available list. Only if we have eth name in the
>   list, it can access by this netns. smc-tools matches ethernet NIC and
>   RDMA device, it can only find the name of eth nic in this netns, so
>   there is no name if this eth nic doesn't belong to this netns.
> 
>   Net-Dev         IB-Dev   IB-P  IB-State  Type          Crit  #Links  PNET-ID
>                   mlx5_0      1    ACTIVE  RoCE_Express2   No       0
>   eth2            mlx5_1      1    ACTIVE  RoCE_Express2   No       0
> 
>   This output shows we have ONE available RDMA device in this netns.

Here too things look good to me:

Server:

Net-Dev         IB-Dev   IB-P  IB-State  Type          Crit  #Links  PNET-ID
...
          roceP12p    1    ACTIVE  RoCE_Express2   No       0  NET26
          roceP11p    1    ACTIVE  RoCE_Express2   No       0  NET25
ens2076         roceP9p0    1    ACTIVE  RoCE_Express2   No       0  NET25

Client:

Net-Dev         IB-Dev   IB-P  IB-State  Type          Crit  #Links  PNET-ID
...
          roceP12p    1    ACTIVE  RoCE_Express2   No       0  NET26
ens1296         roceP11p    1    ACTIVE  RoCE_Express2   No       0  NET25
          roceP9p0    1    ACTIVE  RoCE_Express2   No       0  NET25

And I again confirmed that a pure RDMA workload ("qperf -cm1 ... rc_bw")
works with the RDMA namespacing set to exclusive but only if I add the
RDMA devices to the namespaces. I do wonder why the other RDMA devices are still
visible in the above output though?

> - Misc checks, such as memory usage, loop back connection and so on.
>   Also, you can check dmesg for device operations if you moved netns of
>   RDMA device. Every device's operation will log in dmesg.
> 
>   # SMC module init, adds two RDMA device.
>   [  +0.000512] smc: adding ib device mlx5_0 with port count 1
>   [  +0.000534] smc:    ib device mlx5_0 port 1 has pnetid
>   [  +0.000516] smc: adding ib device mlx5_1 with port count 1
>   [  +0.000525] smc:    ib device mlx5_1 port 1 has pnetid
> 
>   # Move one RDMA device to another netns.
>   [Feb21 14:16] smc: removing ib device mlx5_1
>   [  +0.015723] smc: adding ib device mlx5_1 with port count 1
>   [  +0.000600] smc:    ib device mlx5_1 port 1 has pnetid

There is no memory pressure and SMC-R between two systems works.

I also see the smc add/remove messages in dmesg as you describe:

smc: removing ib device roceP11p0s0
smc: adding ib device roceP11p0s0 with port count 1
smc:    ib device roceP11p0s0 port 1 has pnetid NET25
smc: removing ib device roceP9p0s0
smc: adding ib device roceP9p0s0 with port count 1
smc:    ib device roceP9p0s0 port 1 has pnetid NET25
mlx5_core 000b:00:00.0 ens1296: Link up
mlx5_core 0009:00:00.0 ens2076: Link up
IPv6: ADDRCONF(NETDEV_CHANGE): ens2076: link becomes ready
smc: removing ib device roceP11p0s0
smc: adding ib device roceP11p0s0 with port count 1
smc:    ib device roceP11p0s0 port 1 has pnetid NET25
mlx5_core 000b:00:00.0 ens1296: Link up
mlx5_core 0009:00:00.0 ens2076: Link up
smc: removing ib device roceP9p0s0
smc: adding ib device roceP9p0s0 with port count 1
smc:    ib device roceP9p0s0 port 1 has pnetid NET25
IPv6: ADDRCONF(NETDEV_CHANGE): ens1296: link becomes ready

(The PCI addresses and resulting names are normal for s390)

One thing I notice is that you don't seem to have a pnetid set
in your output, did you redact those or are you dealing differently
with PNETIDs? Maybe there is an issue with matching PNETIDs betwen
RDMA devices and network devices when namespaced?

I also tested with smc_chk instead of qperf to make sure it's not a
problem with LD_PRELOAD or anything like that. With that it simply
doesn't connect. 


