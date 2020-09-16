Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232AB26D16A
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 05:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgIQDDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 23:03:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60278 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgIQDDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 23:03:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GL8uCS160374;
        Wed, 16 Sep 2020 21:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=AVQPLWUU6K3yO+73vDw9BdNKEyDGmBgF91TwAjI7JwI=;
 b=bXOwmSRY052K6room7bqoNWMZPTAHbjC1b5arRkxd6a8dXVL7XgEK1yoc/J9bxuy02zH
 I1VzYshe6d2hib3DsMu1e+EIs5gKPBDAudNSM82VFUUK6YFczSTggQ2gPDv/Yuk58EzY
 NZIhjJ4I+xzk9G1pfWQDF7jOqyUU9Y97RF4LetOrH3lYRJM6L9rGdc+yWRwz7N8cDazo
 8ULOrIbidwEo2zn7uhZjt+XF4aGCGg0tmVC6VRftkvH+tZByCfqa0AyLiOIfUaKS+f1c
 K4Daz1AdDO3YVyJxkJQ/zBvgtbwaen3QsQ4bv+S/os3KGUwYiPJJec9ASGWZCXTc1qVF fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9mdj1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 21:15:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GL9w92071742;
        Wed, 16 Sep 2020 21:15:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33hm33hw1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 21:15:11 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08GLFASO027204;
        Wed, 16 Sep 2020 21:15:10 GMT
Received: from [10.159.236.249] (/10.159.236.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 21:15:10 +0000
Subject: Re: [PATCH 1/1] net/rds: suppress page allocation failure error in
 recv buffer refill
To:     santosh.shilimkar@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        aruna.ramakrishna@oracle.com, rama.nichanamatlu@oracle.com
References: <1600283326-30323-1-git-send-email-manjunath.b.patil@oracle.com>
 <389b52c6-0d9a-7644-49f6-66eb7a45b3e6@oracle.com>
From:   Manjunath Patil <manjunath.b.patil@oracle.com>
Organization: Oracle Corporation
Message-ID: <392801e0-cebd-d0dd-fc65-666161c6599b@oracle.com>
Date:   Wed, 16 Sep 2020 14:15:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <389b52c6-0d9a-7644-49f6-66eb7a45b3e6@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160155
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Santosh,

inline.
On 9/16/2020 12:27 PM, santosh.shilimkar@oracle.com wrote:
> On 9/16/20 12:08 PM, Manjunath Patil wrote:
>> RDS/IB tries to refill the recv buffer in softirq context using
>> GFP_NOWAIT flag. However alloc failure is handled by queueing a work to
>> refill the recv buffer with GFP_KERNEL flag. This means failure to
>> allocate with GFP_NOWAIT isn't fatal. Do not print the PAF warnings if
>> softirq context fails to refill the recv buffer, instead print a one
>> line warning once a day.
>>
>> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
>> Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
>> ---
>>   net/rds/ib_recv.c | 16 +++++++++++++---
>>   1 file changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
>> index 694d411dc72f..38d2894f6bb2 100644
>> --- a/net/rds/ib_recv.c
>> +++ b/net/rds/ib_recv.c
>> @@ -310,8 +310,8 @@ static int rds_ib_recv_refill_one(struct 
>> rds_connection *conn,
>>       struct rds_ib_connection *ic = conn->c_transport_data;
>>       struct ib_sge *sge;
>>       int ret = -ENOMEM;
>> -    gfp_t slab_mask = GFP_NOWAIT;
>> -    gfp_t page_mask = GFP_NOWAIT;
>> +    gfp_t slab_mask = gfp;
>> +    gfp_t page_mask = gfp;
>>         if (gfp & __GFP_DIRECT_RECLAIM) {
>>           slab_mask = GFP_KERNEL;
>> @@ -406,6 +406,16 @@ void rds_ib_recv_refill(struct rds_connection 
>> *conn, int prefill, gfp_t gfp)
>>           recv = &ic->i_recvs[pos];
>>           ret = rds_ib_recv_refill_one(conn, recv, gfp);
>>           if (ret) {
>> +            static unsigned long warn_time;
> Comment should start on next line.
I will add new line. checkpatch.pl didn't find it though.
>> +            /* warn max once per day. This should be enough to
>> +             * warn users about low mem situation.
>> +             */
>> +            if (printk_timed_ratelimit(&warn_time,
>> +                           24 * 60 * 60 * 1000))
>> +                pr_warn("RDS/IB: failed to refill recv buffer for 
>> <%pI6c,%pI6c,%d>, waking worker\n",
>> +                    &conn->c_laddr, &conn->c_faddr,
>> +                    conn->c_tos);
> Didn't notice this before.
> Why not just use "pr_warn_ratelimited()" ?
I think you meant, get rid of if clause and use "pr_warn_ratelimited()" 
instead.
That can still produce more than needed logs during low memory situation.

-Thanks,
Manjunath
>> +
>>               must_wake = true;
>>               break;
>>           }
>> @@ -1020,7 +1030,7 @@ void rds_ib_recv_cqe_handler(struct 
>> rds_ib_connection *ic,
>>           rds_ib_stats_inc(s_ib_rx_ring_empty);
>>         if (rds_ib_ring_low(&ic->i_recv_ring)) {
>> -        rds_ib_recv_refill(conn, 0, GFP_NOWAIT);
>> +        rds_ib_recv_refill(conn, 0, GFP_NOWAIT | __GFP_NOWARN);
>>           rds_ib_stats_inc(s_ib_rx_refill_from_cq);
>>       }
>>   }
>>

