Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDBB26D142
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 04:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgIQCff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 22:35:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40820 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQCfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 22:35:33 -0400
X-Greylist: delayed 793 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 22:35:32 EDT
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GLOubF189833;
        Wed, 16 Sep 2020 21:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=XEkn+PRG+g+AbtT6X5MksZytyHpfPd4kiSU7ea3QcIg=;
 b=FO4jXeBnIpXbw10aBukdgYuRQrdCi/yA/8TwxN6jiSCXgVB+0wQA7m0mn2HJMHNK6Y6X
 T1lept7Ezi+JKqUhv82MNikvFtLYhNmH6eXXiympyph+eEGD1Ts1eo2QwS3mrM4UJ9/G
 oebBSPAxvb3k3MgyZxtLmxSVul0kOBwofVylFLl0gWNNnwdA6HS24W17LA9M8zChBNon
 TaIZtGJ6vyu1/z7Hby7AwZrZKxEHrOxQjiSfn3dEnSkbhOYwUIr6NJL8Fk4zfNzYj4GC
 pz5sb68CwP5WkH74vPSyMOglkSAH8FYU3DBdbVC9YpoLN+zh908mlOzaB2WMc5cxxlo6 eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9mdka5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 21:25:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GLA1xw147608;
        Wed, 16 Sep 2020 21:25:27 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33khpm29au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 21:25:27 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08GLPRCa031109;
        Wed, 16 Sep 2020 21:25:27 GMT
Received: from [10.74.111.69] (/10.74.111.69)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 21:25:27 +0000
Subject: Re: [PATCH 1/1] net/rds: suppress page allocation failure error in
 recv buffer refill
To:     Manjunath Patil <manjunath.b.patil@oracle.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        aruna.ramakrishna@oracle.com, rama.nichanamatlu@oracle.com
References: <1600283326-30323-1-git-send-email-manjunath.b.patil@oracle.com>
 <389b52c6-0d9a-7644-49f6-66eb7a45b3e6@oracle.com>
 <392801e0-cebd-d0dd-fc65-666161c6599b@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <30c39b36-a7c4-6214-4265-2df5546c0025@oracle.com>
Date:   Wed, 16 Sep 2020 14:25:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <392801e0-cebd-d0dd-fc65-666161c6599b@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160156
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/20 2:15 PM, Manjunath Patil wrote:
> Hi Santosh,
> 
> inline.
> On 9/16/2020 12:27 PM, santosh.shilimkar@oracle.com wrote:
>> On 9/16/20 12:08 PM, Manjunath Patil wrote:
>>> RDS/IB tries to refill the recv buffer in softirq context using
>>> GFP_NOWAIT flag. However alloc failure is handled by queueing a work to
>>> refill the recv buffer with GFP_KERNEL flag. This means failure to
>>> allocate with GFP_NOWAIT isn't fatal. Do not print the PAF warnings if
>>> softirq context fails to refill the recv buffer, instead print a one
>>> line warning once a day.
>>>
>>> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
>>> Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
>>> ---
>>>   net/rds/ib_recv.c | 16 +++++++++++++---
>>>   1 file changed, 13 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
>>> index 694d411dc72f..38d2894f6bb2 100644
>>> --- a/net/rds/ib_recv.c
>>> +++ b/net/rds/ib_recv.c
>>> @@ -310,8 +310,8 @@ static int rds_ib_recv_refill_one(struct 
>>> rds_connection *conn,
>>>       struct rds_ib_connection *ic = conn->c_transport_data;
>>>       struct ib_sge *sge;
>>>       int ret = -ENOMEM;
>>> -    gfp_t slab_mask = GFP_NOWAIT;
>>> -    gfp_t page_mask = GFP_NOWAIT;
>>> +    gfp_t slab_mask = gfp;
>>> +    gfp_t page_mask = gfp;
>>>         if (gfp & __GFP_DIRECT_RECLAIM) {
>>>           slab_mask = GFP_KERNEL;
>>> @@ -406,6 +406,16 @@ void rds_ib_recv_refill(struct rds_connection 
>>> *conn, int prefill, gfp_t gfp)
>>>           recv = &ic->i_recvs[pos];
>>>           ret = rds_ib_recv_refill_one(conn, recv, gfp);
>>>           if (ret) {
>>> +            static unsigned long warn_time;
>> Comment should start on next line.
> I will add new line. checkpatch.pl didn't find it though.
>>> +            /* warn max once per day. This should be enough to
>>> +             * warn users about low mem situation.
>>> +             */
>>> +            if (printk_timed_ratelimit(&warn_time,
>>> +                           24 * 60 * 60 * 1000))
>>> +                pr_warn("RDS/IB: failed to refill recv buffer for 
>>> <%pI6c,%pI6c,%d>, waking worker\n",
>>> +                    &conn->c_laddr, &conn->c_faddr,
>>> +                    conn->c_tos);
>> Didn't notice this before.
>> Why not just use "pr_warn_ratelimited()" ?
> I think you meant, get rid of if clause and use "pr_warn_ratelimited()" 
> instead.
> That can still produce more than needed logs during low memory situation.
> 
Try it out. It will do the same job as what you are trying to do.
