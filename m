Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 034AD5D8BC
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfGCA14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:27:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46442 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfGCA1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:27:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62LE7Hv052438;
        Tue, 2 Jul 2019 21:18:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=mvi67k/57m8ZtkiZD01vlzU9qHZRn3hc1l/6AsACbM0=;
 b=SNRXoB1HinF1JEDep9Htje/t/X3SXvYc737JauSue/MzVSIufRHLHvFcnxKr3nI3IOt9
 Up/8l5SDHGcXOJrScAqmkCOA4Onau5BqMYaH+HWfICAHREzG9YYWac5y6I8a4v5T/XJm
 tPw2WRySRrIC3gEG1P6WDnT8LaEYQT4KKLbxQW7sGjoXDF1fYX6obyL1gkKdEH0X/Kfb
 hSTIv6AlJNRoFIMDjK5xYkEl7GN5HqVh11KPaWkRxUQUhdtUv8kYB0W+2fIFS6yA/RWP
 jP5ItrEH7gWsI5LwIZFdCdZc9lIsNvMthTg8TYO4Ve+rsDgXWFTZ+sgsKyZZhddqpWDL UQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2te5tbp0yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 21:18:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62LCdJS118396;
        Tue, 2 Jul 2019 21:18:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2tebqgrdeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 21:18:16 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x62LIFkH019810;
        Tue, 2 Jul 2019 21:18:16 GMT
Received: from [10.11.0.40] (/10.11.0.40)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jul 2019 14:18:15 -0700
Subject: Re: [PATCH net-next 3/7] net/rds: Wait for the FRMR_IS_FREE (or
 FRMR_IS_STALE) transition after posting IB_WR_LOCAL_INV
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <505e9af7-a0cd-bf75-4a72-5d883ee06bf1@oracle.com>
 <c79821e0-307c-5736-6eb5-e20983097345@oracle.com>
 <01c251f4-c8f8-fcb8-bccc-341d4a3db90a@oracle.com>
 <b5669540-3892-9d79-85ba-79e96ddd3a81@oracle.com>
 <14c34ac2-38ed-9d51-f27d-74120ff34c54@oracle.com>
 <79d25e7c-ad9e-f6d8-b0fe-4ce04c658e1e@oracle.com>
 <6ff00a46-07f6-7be2-8e75-c87448568aa4@oracle.com>
 <d7ab5505-92e5-888c-a230-77bce3540261@oracle.com>
 <697adfba-ac8b-db4d-5819-f4c22ec6c76a@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <1759bca6-4511-6cd9-ab5d-8c9c30e5db67@oracle.com>
Date:   Tue, 2 Jul 2019 14:18:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <697adfba-ac8b-db4d-5819-f4c22ec6c76a@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020235
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020235
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/2/19 2:05 PM, Gerd Rausch wrote:
> On 02/07/2019 09.49, santosh.shilimkar@oracle.com wrote:
>> On 7/1/19 10:11 PM, Gerd Rausch wrote:
>>> For the registration work-requests there is a benefit to wait a short
>>> amount of time only (the trade-off described in patch #1 of this series).
>>>
>> Actually we should just switch this code to what Avinash has
>> finally made in downstream code. That keeps the RDS_GET_MR
>> semantics and makes sure MR is really valid before handing over
>> the key to userland. There is no need for any timeout
>> for registration case.
>>
> 
> What do you call "RDS_GET_MR" semantics?
> 
Its a blocking socket call. Meaning after this call return to the
user, the key must be valid. With async registration that can't be
guaranteed.

> The purpose of waiting for a IB_WR_REG_MR request to complete
> (inside rds_ib_post_reg_frmr) is in fact to make sure
> the memory region is valid.
> 
> Regardless of this being true after a specific time-out,
> or an infinite timeout.
> 
> For the non-infinite time-out case, there is a check if the request
> was handled by the firmware.
> 
> And if a time-out occurred and the firmware didn't handle the request,
> function "rds_ib_post_reg_frmr" will return -EBUSY.
> 
>>> Actually, no:
>>> Socket option RDS_GET_MR wasn't even in the code-path of the
>>> tests I performed:
>>>
>>> It were there RDS_CMSG_RDMA_MAP / RDS_CMSG_RDMA_DEST control
>>> messages that ended up calling '__rds_rdma_map".
>>>
>> What option did you use ? Default option with rds-stress is
>> RDS_GET_MR and hence the question.
>>
> 
> Not true!:
Its other way round. Thanks for info so default its using inline
registration instead of explicit call.

> How is socket option RDS_GET_MR special with regards to this proposed fix?
> 
>>> I don't understand, please elaborate:
>>> a) Are you saying this issue should not be fixed?
>>> b) Or are you suggesting to replace this fix with a different fix?
>>>      If it's the later, please point out what you have in mind.
>>> c) ???
>>>
>> All am saying is the code got changed for good reason and that changed
>> code makes some of these race conditions possibly not applicable.
> 
> I don't understand this. Please elaborate.
> 
>> So instead of these timeout fixes, am suggesting to use that
>> code as fix. At least test it with those changes and see whats
>> the behavior.
>>
> 
> Are you suggesting to
> a) Not fix this bug right now and wait until some later point in time
When did I say that ? I said have you explored alternate approach to
fix the issue and if not could you try it out.

> b) Use a different fix. If you've got a different fix, please share.
>
I don't but its a review of the fix and possible alternate needs to
be discussed. It is not like take my fix or provide an alternate fix.

> And besides these options, is there anything wrong with this fix
> (other than the discussion of what the timeout value ought to be,
>   which we can address)?
> 
That timeout is a problem because it doesn't guarantee the failure
of operation since its an asyn operation for registration. Instead
of timing out if you poll the CQ for that operation completion, it
makes it full proof. That is the change Avinash has done iirc and
am requesting to look at that fix.

Other 5 fixes from the series looks fine.

Regards,
Santosh

Regards,
Santosh
