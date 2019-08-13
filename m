Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 657538C073
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfHMSUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:20:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32802 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728378AbfHMSUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:20:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DI90Ba088266;
        Tue, 13 Aug 2019 18:20:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=K7033Y1N3uQWB/VCYVZCi6zyEc4uuyZrDuc+OMOhqNw=;
 b=P3pxaHzOx1S3wJ7l8l50/P/cS8XXiEc6PUFu+R7aPMoAe3Oo7cm1vCNLyNAar4h3TYDp
 DhEg+1HV7CobrUl21s7JpP8aU6tgEqYIlCqVXpOlwFdVSK9llLillZsCXUMszbVStqjG
 MfipMdeZdw3ECKei6dM6oJKrxbr1ATdoc6vWvGJAXn1TZcC7qugZ0v3YouuOEtGNZ8Qz
 XMzgplN+H78BsaE/BRcsRfHbh7ZSYZzDeYKoW2VKsijulrOvDDWLGRE5MIcqa1n2cLFA
 I+dTA6qVYEPxKQEHdADcDfDYGH41cCwGRV91XJERcM+a4OcUijG5Vj2f52zB81jVvQGU Dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u9pjqfx4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 18:20:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DID881087678;
        Tue, 13 Aug 2019 18:20:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2ubwrga6p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Aug 2019 18:20:51 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7DIKo2Q109278;
        Tue, 13 Aug 2019 18:20:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ubwrga6nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 18:20:50 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7DIKoeL031843;
        Tue, 13 Aug 2019 18:20:50 GMT
Received: from [10.211.54.53] (/10.211.54.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 11:20:50 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next 0/5] net/rds: Fixes from internal Oracle repo
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <0b05ed75-6772-e339-11e6-1fb5714981c0@oracle.com>
Date:   Tue, 13 Aug 2019 11:20:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9348 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the first set of (mostly old) patches from our internal repository
in an effort to synchronize what Oracle had been using internally
with what is shipped with the Linux kernel.

Andy Grover (2):
  RDS: Re-add pf/sol access via sysctl
  rds: check for excessive looping in rds_send_xmit

Chris Mason (2):
  RDS: limit the number of times we loop in rds_send_xmit
  RDS: don't use GFP_ATOMIC for sk_alloc in rds_create

Gerd Rausch (1):
  net/rds: Add a few missing rds_stat_names entries

 net/rds/af_rds.c  |  2 +-
 net/rds/ib_recv.c | 12 +++++++++++-
 net/rds/rds.h     |  2 +-
 net/rds/send.c    | 12 ++++++++++++
 net/rds/stats.c   |  3 +++
 net/rds/sysctl.c  | 21 +++++++++++++++++++++
 6 files changed, 49 insertions(+), 3 deletions(-)

-- 
2.22.0

