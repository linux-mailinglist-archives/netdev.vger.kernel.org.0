Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34444BB902
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 18:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732701AbfIWQFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 12:05:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39200 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbfIWQFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 12:05:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8NFxEot156139;
        Mon, 23 Sep 2019 16:05:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Ag6eGs6p7AYJ/7Lz8wwYRNXQo+SM6fu7j8fqxf23W1o=;
 b=loB5UiydHbWh8uj4yi0YKTjdb+AnTv7PblK30VdqOnmg6iLkt6UWdZDazWoJCzfUtfz9
 ERPvMLcCnWoCGsyoD+VjdJ8sKc8IfqMnmiD9a0T8M0Nap5OwBI5nYRlFW98x/0umycEX
 lztM5G9kxV1xUj2NN1PEDV9trrnYBax6Is8xIfTFpYl2orJnevZZVPrfP0Gr5ytfPsd1
 si2x65eTBCAk+zl8I0E2I4iM+eFHiTKR23wxL/+YCVEqP8SZFyG0PnOfsdEoWJXXHmm+
 ZwuMFIofbF5NSOqg8g4cDetA6so4Oy8pa+PiqVlD1X70mAGQsLI9hSlawm6MZhFJTuAd Ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v5btpr0p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 16:05:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8NG4cqF071633;
        Mon, 23 Sep 2019 16:05:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2v6yvpmx4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 16:05:01 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8NG4xQd004101;
        Mon, 23 Sep 2019 16:04:59 GMT
Received: from [10.191.241.21] (/10.191.241.21)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 09:04:59 -0700
Subject: Re: [PATCH] drivers/net/fjes: fix a potential NULL pointer
 dereference
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org
References: <1568824395-4162-1-git-send-email-allen.pais@oracle.com>
 <20190921184009.32edfa43@cakuba.netronome.com>
From:   Allen <allen.pais@oracle.com>
Message-ID: <12b96a9f-27c7-86b4-af90-cad594240bf8@oracle.com>
Date:   Mon, 23 Sep 2019 21:34:50 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190921184009.32edfa43@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909230152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909230152
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> 
> If I'm looking at this right you are jumping to err_free_netdev without
> setting the err variable. It must had been set to 0 from the return of
> fjes_sw_init(). This means we will free the netdev, and return 0. This
> means probe will not fail and driver's remove function will be run
> at some point. fjes_remove it will try to free the netdev again.

  Good catch. Here's a quick diff what I should have done,

--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -1236,9 +1236,21 @@ static int fjes_probe(struct platform_device 
*plat_dev)
         adapter->force_reset = false;
         adapter->open_guard = false;

+       /* Re-initialize err to -ENOMEM to handle workqueue allocation 
failures,
+          and we don't return 0 on failure.
+       */
+       err = -ENOMEM;
+
         adapter->txrx_wq = alloc_workqueue(DRV_NAME "/txrx", 
WQ_MEM_RECLAIM, 0);
+       if (unlikely(!adapter->txrx_wq))
+               goto err_free_netdev;
+
         adapter->control_wq = alloc_workqueue(DRV_NAME "/control",
                                               WQ_MEM_RECLAIM, 0);
+       if (unlikely(!adapter->control_wq)) {
+               destroy_workqueue(adapter->txrx_wq);
+               goto err_free_netdev;
+       }


> Looks like there's another existing bug here in that the work queues
> are not free when something fails in fjes_probe, just the netdev.

I shall look into it and send out a separate fix.

> Once you untangle that, and before you post a v2, could you please try
> to identify which commit introduced the regression and provide an
> appropriate "Fixes" tag?
> 

Fixes: f2edc4e1b078("net: fjes: fjes_main: Remove create_workqueue")

- Allen
