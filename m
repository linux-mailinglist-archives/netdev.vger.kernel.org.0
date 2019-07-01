Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 357735C148
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbfGAQjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:39:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50330 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727702AbfGAQju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:39:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GY0ha171840;
        Mon, 1 Jul 2019 16:39:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=X2HfOX10qMM3IXRLjZ3P4ljaXf5cgv+Ckl5SExq3IfE=;
 b=hzcIBa4jqOlHRSkGL4W0Xa6xLbRxU76BPuca4IVDkWVgm2+y5tbEY3yi/JrWD+79jihq
 imB/C4y/hRxLo7wsm7PLXE8w1v3QVd7p0u63d6iaSpdMxhUtIlTFeYijdbgYPWatteUA
 iNrXAKXntZsD0BFLKOpYfQ2LEtfuw4FV1fe/qgS+PIEaHOahgrBbPgBYp+4XNzXjEU+B
 0vqxQmg4jWjYj3wEfjlMDPqEUierPIdcvFkLQtxsNjup+oF5W7ejBqDsAW1J/yPQDhsl
 VMm84rJBz69CStW6E23N2d8LPoUp15x7eDjiJKRaG4QRv5CzSm4PCzxUORRdAM4rq91b EQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2te61dxqut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:39:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61GWW7R045048;
        Mon, 1 Jul 2019 16:39:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tebak9bfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 16:39:41 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x61Gddht018432;
        Mon, 1 Jul 2019 16:39:40 GMT
Received: from [10.159.137.152] (/10.159.137.152)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 09:39:39 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next 0/7] net/rds: RDMA fixes
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Message-ID: <f1f5ca90-a98a-4c7a-c918-ef26f02f6ee7@oracle.com>
Date:   Mon, 1 Jul 2019 09:39:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010200
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A number of net/rds fixes necessary to make "rds_rdma.ko"
pass some basic Oracle internal tests.

Gerd Rausch (7):
  net/rds: Give fr_state a chance to transition to FRMR_IS_FREE
  net/rds: Get rid of "wait_clean_list_grace" and add locking
  net/rds: Wait for the FRMR_IS_FREE (or FRMR_IS_STALE) transition after
    posting IB_WR_LOCAL_INV
  net/rds: Fix NULL/ERR_PTR inconsistency
  net/rds: Set fr_state only to FRMR_IS_FREE if IB_WR_LOCAL_INV had been
    successful
  net/rds: Keep track of and wait for FRWR segments in use upon shutdown
  net/rds: Initialize ic->i_fastreg_wrs upon allocation

 net/rds/ib.h      |   1 +
 net/rds/ib_cm.c   |   9 +++-
 net/rds/ib_frmr.c | 103 ++++++++++++++++++++++++++++++++++++++++++----
 net/rds/ib_mr.h   |   4 ++
 net/rds/ib_rdma.c |  60 +++++++++------------------
 5 files changed, 128 insertions(+), 49 deletions(-)

-- 
2.18.0

