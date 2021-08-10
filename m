Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2A13E5A2C
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240718AbhHJMml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:42:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240686AbhHJMmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 08:42:38 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ACZnjb006759;
        Tue, 10 Aug 2021 08:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RHsR6aVGy+GaELvcNwuiB11e5P4OeCZdzOOLRCSalVI=;
 b=UgSXAUjX8e9BxPI3R7A8uMNgvRpfJTmyKTpNNjav7mbpqx2AIVKSleA2bj0rNFBZvFSM
 aKMuoQDRWM7UGi3LrKdC9P4scRndC+kNOI88NLYCD76sdDEOdcOaFsZWKqgWT34sillS
 JVybsByWa4Id0LaT84AC2aauGA8RwwSQs8dmqmag8PE2Nc/ZZiAZx9mEa+3q4588wf4w
 GY619hOs+QeuI7OyMVgxDfi/zZLgDAfTZwtCmxlRdjj1qSfCAgj0GZpq/ThLzRMpcPO+
 GEJPB0s+JFoALdiWWHiN6gIHTQLyj/CAfx2P5QsJrHsrNJWntpS+eiBoRcs07bNXmMWt ng== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ab8kk9qc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 08:41:55 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17ACbMF8004746;
        Tue, 10 Aug 2021 12:41:52 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3a9ht8ne50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 12:41:52 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17ACfohE59310512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 12:41:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBE1D4C050;
        Tue, 10 Aug 2021 12:41:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 005204C044;
        Tue, 10 Aug 2021 12:41:48 +0000 (GMT)
Received: from [9.171.19.103] (unknown [9.171.19.103])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Aug 2021 12:41:47 +0000 (GMT)
Subject: Re: [PATCH v2 net] net: switchdev: zero-initialize struct
 switchdev_notifier_fdb_info emitted by drivers towards the bridge
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-s390@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@idosch.org>
References: <20210810115024.1629983-1-vladimir.oltean@nxp.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <dfa98bf7-cab4-4076-ef5f-880a8baa89ee@linux.ibm.com>
Date:   Tue, 10 Aug 2021 14:41:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810115024.1629983-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _j8fSda4zE-t-vI3t2qAYb9FXmKJ_HIy
X-Proofpoint-ORIG-GUID: _j8fSda4zE-t-vI3t2qAYb9FXmKJ_HIy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_05:2021-08-10,2021-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 clxscore=1011 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=999 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/08/2021 13:50, Vladimir Oltean wrote:
> The blamed commit a new field to struct switchdev_notifier_fdb_info, but
                  ^^^ added?

> did not make sure that all call paths set it to something valid. For
> example, a switchdev driver may emit a SWITCHDEV_FDB_ADD_TO_BRIDGE
> notifier, and since the 'is_local' flag is not set, it contains junk
> from the stack, so the bridge might interpret those notifications as
> being for local FDB entries when that was not intended.
> 
> To avoid that now and in the future, zero-initialize all
> switchdev_notifier_fdb_info structures created by drivers such that all
> newly added fields to not need to touch drivers again.
> 
> Fixes: 2c4eca3ef716 ("net: bridge: switchdev: include local flag in FDB notifications")
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>
> ---
> v1->v2: use an empty struct initializer as opposed to memset, as
>         suggested by Leon Romanovsky

For drivers/s390/net/qeth_l2_main.c :

Reviewed-by: Karsten Graul <kgraul@linux.ibm.com>

Thanks
