Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889288EE71
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731760AbfHOOki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:40:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59616 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729820AbfHOOkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:40:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FEWUDD095032;
        Thu, 15 Aug 2019 14:40:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=u7iCHZBLlf374ODvm9c4+zyfb5Zw9jRZAYXzhXJte0o=;
 b=IOVeWPe/Mh1ML5aYfxxVjXJ15xcOK75ZHk9c01IFzCOlTRwxxhF1e2//uGi4m3VYp2Ds
 LBUUF7v0jYZqrTjpjHrowiahJ8h51e5cj7X3gROAyWYVEZ962PrWSWXcQqjKu35B8bMk
 Vm9IQTnXjlM8UW4X0mdVg69MO1ESCU5yCWelPed11G24PMNgbogMfWbGjkqRb5QZ3Ohx
 QbcwuI2kZGG8uCftzx1Y26goYErF14LF4RGU3YfdoNji0o19eVy/GNlh/8H1MLO+owG3
 s0y/KROhNamIWIqjmr3JB8OYBo7XPRo06CqashZpZ02CBEUzQNQknPyIt+16h9bpjhvG ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u9pjqtyq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 14:40:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FEWrgl044605;
        Thu, 15 Aug 2019 14:40:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2ucs881b3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 14:40:27 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7FEeRMS062176;
        Thu, 15 Aug 2019 14:40:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ucs881b36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 14:40:27 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7FEePl3025898;
        Thu, 15 Aug 2019 14:40:25 GMT
Received: from [10.159.252.166] (/10.159.252.166)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 07:40:25 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next v2 0/4] net/rds: Fixes from internal Oracle repo
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <20190814.212525.326606319186601317.davem@davemloft.net>
Message-ID: <ee77e550-2231-be7f-861f-31d609631e9f@oracle.com>
Date:   Thu, 15 Aug 2019 07:40:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814.212525.326606319186601317.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the first set of (mostly old) patches from our internal repository
in an effort to synchronize what Oracle had been using internally
with what is shipped with the Linux kernel.

Andy Grover (1):
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
 5 files changed, 28 insertions(+), 3 deletions(-)

-- 

Changes in submitted patch v2:
* Dropped the controversial "sysctl" patch:
  https://lore.kernel.org/netdev/20190814.142112.1080694155114782651.davem@davemloft.net/
