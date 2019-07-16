Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7497D6B1D0
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388711AbfGPW27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:28:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44262 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728566AbfGPW24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 18:28:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMDmTt109905;
        Tue, 16 Jul 2019 22:28:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=fBqQSLWxnoVlHiuschLf4pxHxPE3fTPbmNAmMqYdX1Y=;
 b=0BCqiFj1OtLSIjtBOaURmw2LHDKidDRMihL2bOuSC95MakdE/7VnjhmpmODpyDNZEtV1
 ekqop0cFj4GK4g+7rRj1lV/N/iz8dt6JXDmCzm3O4e97a0eBm/mxr4+23QCbvC+PwgkE
 W5VKBLUvFD/b+9uc8NYjUh4l39um0uqyrJwCHp72YvWzSNWn1cYoNrV6XEkzOWVWDfFq
 UemwtW/sZ9CZStLnsCz5mk+nc0QPtmOd7QKuoWB93LcyILO+azd+ib0Z9uvh57j51Rh3
 Yy0M1CXGD8Yz5ACrGKoRIJM3aagjNHIv3dgrOlTXNTKuP0rVvBjDTv7VtpIOMp938NaT HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tq7xqy4eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:28:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6GMCg30064546;
        Tue, 16 Jul 2019 22:28:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2tq5bcnrvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jul 2019 22:28:46 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x6GMSkF8096156;
        Tue, 16 Jul 2019 22:28:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tq5bcnrvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:28:46 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6GMSjiE017566;
        Tue, 16 Jul 2019 22:28:45 GMT
Received: from [10.211.55.164] (/10.211.55.164)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jul 2019 22:28:43 +0000
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net v3 0/7] net/rds: RDMA fixes
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <3fd6ddd1-97e2-2c64-1772-b689eb3ee7ba@oracle.com>
Date:   Tue, 16 Jul 2019 15:28:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9320 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160261
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

 net/rds/ib.h      |  1 +
 net/rds/ib_cm.c   |  9 ++++-
 net/rds/ib_frmr.c | 84 ++++++++++++++++++++++++++++++++++++++++++-----
 net/rds/ib_mr.h   |  4 +++
 net/rds/ib_rdma.c | 60 +++++++++++----------------------
 5 files changed, 109 insertions(+), 49 deletions(-)

-- 

Changes in submitted patch v3:
* Use "wait_event" instead of "wait_event_timeout" in order to
  not have a deadline for the HCA firmware to respond.
