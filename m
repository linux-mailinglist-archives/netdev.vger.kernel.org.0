Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4583937902
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 17:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbfFFP5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 11:57:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45524 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729165AbfFFP5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 11:57:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56FsPE1183115;
        Thu, 6 Jun 2019 15:57:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=e9tXhqutf+gIjtNsdxE4py+UbQk4Ifj4FQBivnfx9gE=;
 b=5g6BZRVcdkbheb3LC5qCuHWNU8OGlLKxY1A5JmHiMFgm3DZ2Mc0xgZxUscJGuCk0f1K1
 /uFjeNnTvFvsk+vAJA/PY7bFCnZthzyu74gC1ww948P3kQousQ4IFqjUFAtvB96fhDJI
 PMKdf9G8XRzElDN2ybIwciN8GI/6Ti6cKBVwxH8VBn0HCDxgOrC9/cZtfyaUDj2kbqBv
 XIXQAqdB5YzOlYTFHQiaB8V14/CVYfewaEU3Pg+0K56RcDPqKg87CZWpD1qJZC1s3/gk
 6d1UtXIq0tvUI3o4v6QK4fAakWC/iHCos6EIe1QkIqHV8mxzeaL/RqIxi1ZMQpWUoRRb +A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2suj0qsa7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 15:57:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x56Fv5hg016481;
        Thu, 6 Jun 2019 15:57:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2swngmk2f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Jun 2019 15:57:27 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x56FvRw7017402;
        Thu, 6 Jun 2019 15:57:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2swngmk2f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Jun 2019 15:57:27 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x56FvPUu024299;
        Thu, 6 Jun 2019 15:57:25 GMT
Received: from [10.11.0.40] (/10.11.0.40)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Jun 2019 08:57:25 -0700
Subject: Re: [PATCH 1/1] net: rds: fix memory leak in rds_ib_flush_mr_pool
To:     Zhu Yanjun <yanjun.zhu@oracle.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
References: <1559808003-1030-1-git-send-email-yanjun.zhu@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <7519cb35-07b3-e530-0402-67f76c16a6b4@oracle.com>
Date:   Thu, 6 Jun 2019 08:57:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1559808003-1030-1-git-send-email-yanjun.zhu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9280 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906060108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/19 1:00 AM, Zhu Yanjun wrote:
> When the following tests last for several hours, the problem will occur.
> 
> Server:
>      rds-stress -r 1.1.1.16 -D 1M
> Client:
>      rds-stress -r 1.1.1.14 -s 1.1.1.16 -D 1M -T 30
> 
> The following will occur.
> 
> "
> Starting up....
> tsks   tx/s   rx/s  tx+rx K/s    mbi K/s    mbo K/s tx us/c   rtt us cpu
> %
>    1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
>    1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
>    1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
>    1      0      0       0.00       0.00       0.00    0.00 0.00 -1.00
> "
>  From vmcore, we can find that clean_list is NULL.
> 
>  From the source code, rds_mr_flushd calls rds_ib_mr_pool_flush_worker.
> Then rds_ib_mr_pool_flush_worker calls
> "
>   rds_ib_flush_mr_pool(pool, 0, NULL);
> "
> Then in function
> "
> int rds_ib_flush_mr_pool(struct rds_ib_mr_pool *pool,
>                           int free_all, struct rds_ib_mr **ibmr_ret)
> "
> ibmr_ret is NULL.
> 
> In the source code,
> "
> ...
> list_to_llist_nodes(pool, &unmap_list, &clean_nodes, &clean_tail);
> if (ibmr_ret)
>          *ibmr_ret = llist_entry(clean_nodes, struct rds_ib_mr, llnode);
> 
> /* more than one entry in llist nodes */
> if (clean_nodes->next)
>          llist_add_batch(clean_nodes->next, clean_tail, &pool->clean_list);
> ...
> "
> When ibmr_ret is NULL, llist_entry is not executed. clean_nodes->next
> instead of clean_nodes is added in clean_list.
> So clean_nodes is discarded. It can not be used again.
> The workqueue is executed periodically. So more and more clean_nodes are
> discarded. Finally the clean_list is NULL.
> Then this problem will occur.
> 
> Fixes: 1bc144b62524 ("net, rds, Replace xlist in net/rds/xlist.h with llist")
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
Thanks.
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
