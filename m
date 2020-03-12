Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D43C1183803
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 18:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgCLRvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 13:51:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38300 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgCLRvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 13:51:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CHnM8l101124;
        Thu, 12 Mar 2020 17:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nMJD+EqG4C08alZ/aPPp3eN9qOh9sPZa/hKMnF88LxI=;
 b=nBrkDmHTEKBBpThW/Hc0tvsClAV7f5ZoIkoaBLHRRBRaYGxr7a1EgggKBKP7vjLNrWji
 oC4bcAc1LiBT+hYLOEowaxw2cYcOPZPEaMzEWY0XirJ5HOTrY6Mc6k90pNfHh545JFyu
 YXkbeZjOPUiG0s8NbTqkzZIrsBtFLTydYFtvcIt6x89WLrDmtnTBuAQw8mBGQ52SJ8am
 EZN+U/LfrmVv0v9Mw3aLupSCAAKCtnspwmGxTTiYSqnlvVRshLG4S9qA1Q1xhF/ymf4t
 sxhMan2j9Uvqp/06pKdBfHr9unS280N3sG8KbwPkz5FXEfs+0mOD6vU4+GqSxW38j8j0 fg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2yqkg8a9es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:51:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CHnNte163174;
        Thu, 12 Mar 2020 17:49:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yp8p84m6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:49:51 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02CHno3f021967;
        Thu, 12 Mar 2020 17:49:50 GMT
Received: from [10.159.227.222] (/10.159.227.222)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 10:49:50 -0700
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
 <d9004325-2a97-c711-3abc-eb2550e047b1@oracle.com>
 <a5990ab2-7d6b-8d5a-d461-8ad4bec104a4@gmail.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <2079e907-56b9-c665-bdfc-bda6daaca1d1@oracle.com>
Date:   Thu, 12 Mar 2020 10:49:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <a5990ab2-7d6b-8d5a-d461-8ad4bec104a4@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9558 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120091
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/20 1:58 AM, zerons wrote:
> 
[...]
>>>> MR won't stay in the rbtree with force flag. If the MR is used or
>>>> use_once is set in both cases its removed from the tree.
>>>> See "if (mr->r_use_once || force)"
>>>>
>>>
>>> Sorry, I may misunderstand. Did you mean that if the MR is *used*,
>>> it is removed from the tree with or without the force flag in
>>> rds_rdma_unuse(), even when r_use_once is not set?
>>>
>> Once the MR is being used with use_once semantics it gets removed with or without remote side indicating it via extended header. use_once
>> optimization was added later. The base behavior is once the MR is
>> used by remote and same information is sent via extended header,
>> it gets cleaned up with force flag. Force flag ignores whether
>> its marked as used_once or not.
>>
> 
> Sorry, I am still confused.
> 
> I check the code again. The rds_rdma_unuse() is called in two functions,
> rds_recv_incoming_exthdrs() and rds_sendmsg().
> 
> In rds_sendmsg(), it calls rds_rdma_unuse() *with* force flag only when
> the user included a RDMA_MAP cmsg *and* sendmsg() is failed.
>
correct.

> In rds_recv_incoming_exthdrs(), the force is *false*. So we can consider
> the rds_rdma_unuse() called *without* force flag.
> Then I go check where r_use_once can be set.
> 
> __rds_rdma_map()
> 	rds_get_mr()
> 		rds_setsockopt()
> 
> 	rds_get_mr_for_dest()
> 		rds_setsockopt()
> 
> 	rds_cmsg_rdma_map()
> 		rds_cmsg_send()
> 			rds_sendmsg()
> 
> It seems to me that r_use_once is controlled by user applications.
>
yes it is and its being set in the application using this in
production. But You do have point that if application don't set it
then even after MR being used and remote node indicated it being
used, the MR still remains in the RB tree.


> Sorry to keep bothering you with my questions. I wish I had such a device
> that I can test it on.
> 
Not at all. You mostly found a race condition when use_once is not used
but need to verify it. We will look into it more. Thanks for your
patience.

Regards,
Santosh

