Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16A51A0C49
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 12:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgDGKwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 06:52:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39366 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728255AbgDGKwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 06:52:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037AmxcH031144;
        Tue, 7 Apr 2020 10:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=a406pEmkdKb9IqkQkIJIzGh/Bjq1L2qpLfE6qFITsK8=;
 b=sw7FeeaPeLBdlw4ZI9lU+BTThgDy2AvChnC/TshWUujbnb+3mFVYW33YPWu05DIoEoRb
 LXKkBQpBea1LsWabAJHkTDrYnSjpJ5Vgrca44MeX1Vj9j/RzBYGwHi4SZ/VhT00uLrG2
 SvZfw8h/YmZJp5J4RYfWHb01lRStVUHutfD258AWkuwqvmryHNNfss7dmZxq07WFjjH8
 HOznF2Z5BusZPR7N60Jc7CoSbqQ8akJkGT9ldR01dHXUq5iIcFuOMJrRIqRPrJnRfLcJ
 HhBb47Lv3oj+i0BNZLSxeROO9m7k/2tPm1Ii/P526/XBI/31fhjXUwimNzJEl3MVw0er aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 306jvn41jq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 10:52:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 037AlTt5135720;
        Tue, 7 Apr 2020 10:52:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30741dukwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Apr 2020 10:52:05 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 037Aq3ex016924;
        Tue, 7 Apr 2020 10:52:03 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 03:52:03 -0700
Date:   Tue, 7 Apr 2020 13:51:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Qiujun Huang <hqjagain@gmail.com>
Cc:     kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anenbupt@gmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH 1/5] ath9k: Fix use-after-free Read in htc_connect_service
Message-ID: <20200407105154.GI2001@kadam>
References: <20200404041838.10426-1-hqjagain@gmail.com>
 <20200404041838.10426-2-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404041838.10426-2-hqjagain@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=736
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9583 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=2
 mlxlogscore=813 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1011 malwarescore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070093
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is correct but there are a lot of error paths in
hif_usb_send() which don't free the skb.  Some error paths *do* free
the skb but most don't.  It's really a lot of work to sort through and
fix.

regards,
dan carpenter

