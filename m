Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012676A001
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 02:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733011AbfGPAly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 20:41:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54522 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730383AbfGPAly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 20:41:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6G0eSil053466;
        Tue, 16 Jul 2019 00:41:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=fqIgnIYTK9iAcWYx66nRvxPH9K+G+UHnuLByGtnv5H0=;
 b=4IRGoMtpCnsAkoP9Sst8iU/FIAcKVhNn5gOVPqlgB06wm0AtdVHFJ1EDomiLKTWOnyfK
 n4zk9aMjq6wFgt8SFQWhl1S62f9SEvj4ribnwdNYZNp35wEoaE22gL7lOYK1uO95DyJl
 idud+NCN0H328wgBO/PWOptIgdouzsMruMTqu8dHsaIlWNS/YBMKMj206FkFqesr07j0
 OxNOYaBn9bFHTKWQj430Kl4EF4cW26x3U+iri+SmQk0UMz/dmksqNb9g7FTKG7jYGGHQ
 3qVBdX/ecQoTl3rTz3tRV4y3Lv6c2E9a4MWORp/YPTXtqoxc/lnvQrhdRX+3BKAX4Qnq jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tq7xqsd0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 00:41:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6G0cFJd105590;
        Tue, 16 Jul 2019 00:41:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tq6mmjrrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 00:41:45 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6G0fiVP025234;
        Tue, 16 Jul 2019 00:41:44 GMT
Received: from [10.211.54.105] (/10.211.54.105)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jul 2019 17:41:43 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next v2 0/7] net/rds: RDMA fixes
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Message-ID: <510cd678-67d6-bd53-1d8e-7a74c4efb14a@oracle.com>
Date:   Mon, 15 Jul 2019 17:41:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907160004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907160004
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

Changes in submitted patch v2:
* Use "wait_event" instead of "wait_event_timeout" in order to
  not have a deadline for the HCA firmware to respond.
