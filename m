Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581813F8A2F
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 16:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242856AbhHZOhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 10:37:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46124 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231458AbhHZOhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 10:37:38 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17QEYJL2096732;
        Thu, 26 Aug 2021 10:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=oFu4tAToJWIk7c3Qa8CsjkkSJvwsjC85jL4/ArKz850=;
 b=LjG5E5ZrIga3S32e2j2j3uPBcPcA6IyNqIbcEeDChsYrT6x3lPcozhQJAB8fnJlfu6g7
 nW/PAjomvlg4MSRlkAdLAOOAnotW4X+Ouhv3OM6KPj+I42/GXcf6pYCHGp9DlCEfiLaq
 jWy2N80GK3Wrfhlm+RHfrI1Lv8aT/YGbrAyuSAEcCbog5cB5Qc2KPeXgsMybVdIF3NXr
 0Efp07mbp95IRkrdS1Ic/6Juia2TjKiRZya5jRiukeluR9qLQR2ZP4O5pOSfMu8vUY5P
 pO2xNaESYf8VW4Ppmw+tGZqsePYKow+F8toXqBK3wWKmZBsHsKZ7jmJ5ozjR5/pO+e2j 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ap94nepan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 10:36:08 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17QEYQhR098754;
        Thu, 26 Aug 2021 10:36:07 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ap94nep9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 10:36:07 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17QERG1B030839;
        Thu, 26 Aug 2021 14:36:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ajs491k1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 14:36:04 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17QEWCIq56557884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Aug 2021 14:32:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DB7D4205C;
        Thu, 26 Aug 2021 14:36:00 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E53C34204D;
        Thu, 26 Aug 2021 14:35:58 +0000 (GMT)
Received: from Alexandras-MBP.fritz.box (unknown [9.145.12.172])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 26 Aug 2021 14:35:58 +0000 (GMT)
Subject: Re: [PATCH v3 net-next 0/7] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-s390@vger.kernel.org
References: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
Message-ID: <1ebabba2-cb37-1f37-7d9e-4e7b3fee6c1e@linux.ibm.com>
Date:   Thu, 26 Aug 2021 16:35:58 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
In-Reply-To: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JOheKjxdrPdL9eAvbqKy0muSI7couE7d
X-Proofpoint-ORIG-GUID: enS_0iYhiCymUeZOgMrnC44LyDRwCbN0
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-26_04:2021-08-26,2021-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 clxscore=1011 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108260085
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.08.21 13:57, Vladimir Oltean wrote:
> Problem statement:
> 
> Any time a driver needs to create a private association between a bridge
> upper interface and use that association within its
> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
> entries deleted by the bridge when the port leaves. The issue is that
> all switchdev drivers schedule a work item to have sleepable context,
> and that work item can be actually scheduled after the port has left the
> bridge, which means the association might have already been broken by
> the time the scheduled FDB work item attempts to use it.
> 
> The solution is to modify switchdev to use its embedded SWITCHDEV_F_DEFER
> mechanism to make the FDB notifiers emitted from the fastpath be
> scheduled in sleepable context. All drivers are converted to handle
> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE from their blocking notifier block
> handler (or register a blocking switchdev notifier handler if they
> didn't have one). This solves the aforementioned problem because the
> bridge waits for the switchdev deferred work items to finish before a
> port leaves (del_nbp calls switchdev_deferred_process), whereas a work
> item privately scheduled by the driver will obviously not be waited upon
> by the bridge, leading to the possibility of having the race.
> 
> This is a dependency for the "DSA FDB isolation" posted here. It was
> split out of that series hence the numbering starts directly at v2.
> 
> https://patchwork.kernel.org/project/netdevbpf/cover/20210818120150.892647-1-vladimir.oltean@nxp.com/
> 
> Changes in v3:
> - make "addr" part of switchdev_fdb_notifier_info to avoid dangling
>   pointers not watched by RCU
> - mlx5 correction
> - build fixes in the S/390 qeth driver
> 
> Vladimir Oltean (7):
>   net: bridge: move br_fdb_replay inside br_switchdev.c
>   net: switchdev: keep the MAC address by value in struct
>     switchdev_notifier_fdb_info
>   net: switchdev: move SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE to the blocking
>     notifier chain
>   net: bridge: switchdev: make br_fdb_replay offer sleepable context to
>     consumers
>   net: switchdev: drop the atomic notifier block from
>     switchdev_bridge_port_{,un}offload
>   net: switchdev: don't assume RCU context in
>     switchdev_handle_fdb_{add,del}_to_device
>   net: dsa: handle SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE synchronously
> 
>  .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  75 ++++------
>  .../marvell/prestera/prestera_switchdev.c     | 104 ++++++-------
>  .../mellanox/mlx5/core/en/rep/bridge.c        |  65 +++++++--
>  .../ethernet/mellanox/mlx5/core/esw/bridge.c  |   2 +-
>  .../ethernet/mellanox/mlxsw/spectrum_router.c |   4 +-
>  .../mellanox/mlxsw/spectrum_switchdev.c       |  62 ++++++--
>  .../microchip/sparx5/sparx5_mactable.c        |   2 +-
>  .../microchip/sparx5/sparx5_switchdev.c       |  72 ++++-----
>  drivers/net/ethernet/mscc/ocelot_net.c        |   3 -
>  drivers/net/ethernet/rocker/rocker_main.c     |  67 ++++-----
>  drivers/net/ethernet/rocker/rocker_ofdpa.c    |   6 +-
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   4 +-
>  drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  54 +++----
>  drivers/net/ethernet/ti/cpsw_new.c            |   4 +-
>  drivers/net/ethernet/ti/cpsw_switchdev.c      |  57 ++++----
>  drivers/s390/net/qeth_l2_main.c               |  26 ++--
>  include/net/switchdev.h                       |  33 ++++-
>  net/bridge/br.c                               |   5 +-
>  net/bridge/br_fdb.c                           |  54 -------
>  net/bridge/br_private.h                       |   6 -
>  net/bridge/br_switchdev.c                     | 128 +++++++++++++---
>  net/dsa/dsa.c                                 |  15 --
>  net/dsa/dsa_priv.h                            |  15 --
>  net/dsa/port.c                                |   3 -
>  net/dsa/slave.c                               | 138 ++++++------------
>  net/switchdev/switchdev.c                     |  61 +++++++-
>  26 files changed, 550 insertions(+), 515 deletions(-)
> 

For drivers/s390/net/qeth_l2_main.c :

Reviewed-and-tested-by: Alexandra Winter <wintera@linux.ibm.com>

Thank you for this proposal, it makes qeth switchdev code more robust, cleaner and gives the
opportunity for future enhancements, like you proposed.
