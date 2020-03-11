Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A9B181B72
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 15:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgCKOgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 10:36:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45706 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729309AbgCKOgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 10:36:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BEWq5E162890;
        Wed, 11 Mar 2020 14:36:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7oDmjhNiC55YU6iZrb3bKn3r9UG+93Yy3XlSaDUipFE=;
 b=nc5j35BudsPbeI64DiBG+CYnaTzjY+8A/JXN6aStyZ+vb3udFhYyT52i9b44tZxBw6lg
 cKLhz4YBKXqWOfVCD1WVNs/UQvfS+3Ku5Y7v3RbJvb5pt4bvHFtXWdxFqECjCZUf4zqN
 F8fqgkHg7eW8TfX14XLFtQkUTudsAjeKomn6bcZJraAedMvpE/gS9/Q19yGopZ3MkRqz
 8wrs9b6lfLJbqM4W4s72omqI3k2KKwmJzLMY8lzKWvnMfCdqt0sHT3XUOc3WQh+UeMYL
 SBGYDJO4jWJ21vZZjRFjE30FLDiwwiecs0aBA2BGB6tzDQpqJupvbf4Z82+NNbYQwbal JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yp9v6749s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 14:35:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BEWp0J140078;
        Wed, 11 Mar 2020 14:35:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yp8p3cbh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 14:35:58 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02BEZv3E006453;
        Wed, 11 Mar 2020 14:35:57 GMT
Received: from [10.11.0.40] (/10.11.0.40)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 07:35:57 -0700
Subject: Re: Maybe a race condition in net/rds/rdma.c?
To:     zerons <sironhide0null@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        haakon.bugge@oracle.com
References: <afd9225d-5c43-8cc7-0eed-455837b53e10@gmail.com>
 <D8EB4A77-77D7-41EB-9021-EA7BB8C3FA5B@oracle.com>
 <94b20d30-1d7d-7a66-b943-d75a05bcb46e@oracle.com>
 <e525ec74-b62f-6e7c-e6bc-aad93d349f65@gmail.com>
 <54d1140d-3347-a2b1-1b20-9a3959d3b451@oracle.com>
 <603ec723-842c-f6e1-01ee-6889c3925a63@gmail.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <d9004325-2a97-c711-3abc-eb2550e047b1@oracle.com>
Date:   Wed, 11 Mar 2020 07:35:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <603ec723-842c-f6e1-01ee-6889c3925a63@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110093
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/20 9:48 PM, zerons wrote:
> 
> 
> On 3/11/20 01:53, santosh.shilimkar@oracle.com wrote:
>> On 3/6/20 4:11 AM, zerons wrote:
>>>
>>>
>>> On 2/28/20 02:10, santosh.shilimkar@oracle.com wrote:
>>>>
>>>>>> On 18 Feb 2020, at 14:13, zerons <sironhide0null@gmail.com> wrote:
>>>>>>
>>>>>> Hi, all
>>>>>>
>>>>>> In net/rds/rdma.c
>>>>>> (https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/rds/rdma.c?h=v5.5.3*n419__;Iw!!GqivPVa7Brio!OwwQCLtjDsKmhaIz0sfaOVSuC4ai5t5_FgB7yqNExGOCBtACtIGLF61NNJyqSDtIAcGoPg$ ),
>>>>>> there may be a race condition between rds_rdma_unuse() and rds_free_mr().
>>>>>>
>>>> Hmmm.. I didn't see email before in my inbox. Please post questions/patches on netdev in future which is the correct mailing list.
>>>>
>>>>>> It seems that this one need some specific devices to run test,
>>>>>> unfortunately, I don't have any of these.
>>>>>> I've already sent two emails to the maintainer for help, no response yet,
>>>>>> (the email address may not be in use).
>>>>>>
>>>>>> 0) in rds_recv_incoming_exthdrs(), it calls rds_rdma_unuse() when receive an
>>>>>> extension header with force=0, if the victim mr does not have RDS_RDMA_USE_ONCE
>>>>>> flag set, then the mr would stay in the rbtree. Without any lock, it tries to
>>>>>> call mr->r_trans->sync_mr().
>>>>>>
>> MR won't stay in the rbtree with force flag. If the MR is used or
>> use_once is set in both cases its removed from the tree.
>> See "if (mr->r_use_once || force)"
>>
> 
> Sorry, I may misunderstand. Did you mean that if the MR is *used*,
> it is removed from the tree with or without the force flag in
> rds_rdma_unuse(), even when r_use_once is not set?
> 
Once the MR is being used with use_once semantics it gets removed with 
or without remote side indicating it via extended header. use_once
optimization was added later. The base behavior is once the MR is
used by remote and same information is sent via extended header,
it gets cleaned up with force flag. Force flag ignores whether
its marked as used_once or not.

Regards,
Santosh

