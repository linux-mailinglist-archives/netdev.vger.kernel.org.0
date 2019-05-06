Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE5B515104
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 18:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfEFQSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 12:18:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57234 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfEFQSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 12:18:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46GIU7t176999
        for <netdev@vger.kernel.org>; Mon, 6 May 2019 16:18:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=JF+NNzRiZ2f+Y3devj+oWS22mdTqrOiAaaqFkIUKNcw=;
 b=ESP2+FTQgSicbQLdvULhUFF9k6sR1TXrWKDONrYARTX1uVNoy8HsonCKQELkZPA+jUz2
 usKyoI184343E0/C8URrMZGedC5nq0vYbYwqa20cprOJ9lbhApgphHv/geABvBhSE1Oo
 fOa73omn549bOG3iS6x50DxA9elp2RuWCG4o9bBkyqNL0L2cFVe6KDVEMc3ULTT5jp3S
 fNxbK2hga+b33lJmJTk51pErgsBXXKh7eRZMSDPhyE+L4S/4npppibniKtH/NXcy0pNq
 XlOXV9o5Po9z3XJhTrkvfCJdvOEVHgCz+lFv+SRfCbGF5ZyAh4bE/IBR1tF7l03MLgpC Qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2s94b0fq18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 16:18:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46GIgaS010192
        for <netdev@vger.kernel.org>; Mon, 6 May 2019 16:18:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2s94af06mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 16:18:48 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x46GImFs030778
        for <netdev@vger.kernel.org>; Mon, 6 May 2019 16:18:48 GMT
Received: from nir-ThinkPad-T470.oracle.com (/10.74.127.120)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 May 2019 09:18:47 -0700
From:   Nir Weiner <nir.weiner@oracle.com>
To:     netdev@vger.kernel.org
Cc:     liran.alon@oracle.com, nir.weiner@oracle.com
Subject: [iproute2 0/3] Adding json support for showing htb&tbf classes
Date:   Mon,  6 May 2019 19:18:37 +0300
Message-Id: <20190506161840.30919-1-nir.weiner@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=874
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905060139
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1031
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=904 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905060139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding a json support for running the command 
tc -j class show dev <dev> 
for the htb kind and the tbf kind

Nir Weiner (3):
  tc: jsonify htb qdisc parameters
  tc: jsonify tbf qdisc parameters
  tc: jsonify class core

 tc/q_htb.c    | 19 ++++++++++---------
 tc/q_tbf.c    | 20 ++++++++++----------
 tc/tc_class.c | 29 +++++++++++++++++++----------
 3 files changed, 39 insertions(+), 29 deletions(-)

-- 
2.17.1

