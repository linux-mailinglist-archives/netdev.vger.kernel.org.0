Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB80D284235
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 23:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgJEVjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 17:39:24 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40942 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbgJEVjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 17:39:23 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095LY6dl152074;
        Mon, 5 Oct 2020 21:39:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Vnwe+J4HHzmNTUOjoBPWeNeO4kQiUOlBVNSU7B+umR4=;
 b=MhJeOq5Lw0InBOb/HCB7g4vcPq0stujIevs/OhMOPW8WLhqnwkUe/XYNlpHWdZLGvL1E
 gDgCfexWQPqJY00AdSHT/av6Tz0bFWJ0eiZMnSDJvuTbVWB38PUpWP/G6CnZ+/pOVN4L
 kidntXmbS0iCslegVAd/cVPnuH5CMRka/vzsPy8R4HNbYN+27maZErxyT+aFSyovuI35
 g8EU/yFowjud6VdknHZaCVgjr6wf9NOjzrVCmKRygYMzNTP3GLtgr67HURgAdTQp+945
 CZl4r8cTr/67CUzWhjOjHAhSC2ZVoIgENirfe5dbB1EnkDcFoQgfMPzSovy4c61XHtkx 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetar4jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 05 Oct 2020 21:39:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 095LYlnc003805;
        Mon, 5 Oct 2020 21:39:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33y36x1drq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Oct 2020 21:39:18 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 095LdHn7020551;
        Mon, 5 Oct 2020 21:39:18 GMT
Received: from [10.159.155.16] (/10.159.155.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 05 Oct 2020 14:39:17 -0700
Subject: Re: [PATCH 1/1] net/rds: suppress page allocation failure error in
 recv buffer refill
To:     David Miller <davem@davemloft.net>
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, aruna.ramakrishna@oracle.com,
        rama.nichanamatlu@oracle.com
References: <1601669145-13604-1-git-send-email-manjunath.b.patil@oracle.com>
 <20201003.172647.2111926819782777286.davem@davemloft.net>
From:   Manjunath Patil <manjunath.b.patil@oracle.com>
Organization: Oracle Corporation
Message-ID: <be52df74-493e-c17b-5013-a55391417297@oracle.com>
Date:   Mon, 5 Oct 2020 14:39:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201003.172647.2111926819782777286.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9765 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010050153
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks David for your feedback.

I will submit v3 of this patch removing the warning.

-Manjunath
On 10/3/2020 5:26 PM, David Miller wrote:
> From: Manjunath Patil <manjunath.b.patil@oracle.com>
> Date: Fri,  2 Oct 2020 13:05:45 -0700
>
>> RDS/IB tries to refill the recv buffer in softirq context using
>> GFP_NOWAIT flag. However alloc failure is handled by queueing a work to
>> refill the recv buffer with GFP_KERNEL flag. This means failure to
>> allocate with GFP_NOWAIT isn't fatal. Do not print the PAF warnings if
>> softirq context fails to refill the recv buffer, instead print rate
>> limited warnings.
>>
>> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
>> Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
> Honestly I don't think the subsystem should print any warning at all.
>
> Either it's a softirq failure, and that's ok because you will push
> the allocation to GFP_KERNEL via a work job.  Or it's a GFP_KERNEL
> failure in non-softirq context and the kernel will print a warning
> and a stack backtrace from the memory allocator.
>
> Therefore, please remove all of the warnings in the rds code.
>
> Thanks.

