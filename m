Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D365C5D924
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfGCAfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:35:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50196 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCAfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:35:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62MhXWD113859;
        Tue, 2 Jul 2019 22:47:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=aKrAeGkrm+TyZmwipGfhakABfSUMoiXw9bwJwlYu6rs=;
 b=eVFOOU0VSrE/gJ06wOXF42jhhw4FCllL0Dg1ppiQmTv1R/GSI+stD/NZxOm+I9uv6CyN
 Xg8GTjz/SpadJLgxEfRxPsq5bAu7SIoXKfZyaDf1h7AQHuW1IS7L1eH8aClB2utRfHe5
 /18GMJ/V5y/2DhDuUL5LQqYM5DRq8ECFex7vZ5HFmXjq4hmq0i/lwPoTjrTEeRQI+9O4
 RLJD8nqrDIm4p3DJbkrQ/0lECFGcHUUJ2YrWd31qTHw00fGBkJ4t29iC2nxhcXd7ZbLW
 uTaV5OtNyeGbPRUiaGUwDgoNkgLAJSxZdXx+KYw3S2+lpr8Vcmq+H91iOWBCLLpbV2bh jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2te5tbp8sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 22:47:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62MlSHT148052;
        Tue, 2 Jul 2019 22:47:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tebkuhqhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 22:47:29 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x62MlQhR012187;
        Tue, 2 Jul 2019 22:47:27 GMT
Received: from [10.209.243.59] (/10.209.243.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jul 2019 15:47:26 -0700
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
 <1759bca6-4511-6cd9-ab5d-8c9c30e5db67@oracle.com>
 <74255414-7e5c-e490-4745-9a8b9a73488d@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <5b98d27b-c6e8-0c35-97ba-ea65f9835655@oracle.com>
Date:   Tue, 2 Jul 2019 15:47:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <74255414-7e5c-e490-4745-9a8b9a73488d@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020252
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020251
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/2/19 3:12 PM, Gerd Rausch wrote:
> On 02/07/2019 14.18, santosh.shilimkar@oracle.com wrote:
>> On 7/2/19 2:05 PM, Gerd Rausch wrote:
>>> What do you call "RDS_GET_MR" semantics?
>>>
>> Its a blocking socket call. Meaning after this call return to the
>> user, the key must be valid. With async registration that can't be
>> guaranteed.
>>
> 
> If the "IB_WR_REG_MR" operation does not complete successfully within
> the given (to-be-discussed?) timeout, "rds_ib_post_reg_frmr" will return
> "-EBUSY".
> 
> And that should propagate up the entire stack and make its way into
> "setsockopt" returning "-1" with "errno == EBUSY".

This is an easy case and this doesn't need any waiting since call just
came back without posting work request.
> 
> Do you see a problem with this approach?
> Did you observe a situation where this did not work?
>
Calling rds_ib_post_reg_frmr() and looking at return value doesn't
grantee that the work request postred is gping to be successful.

> Are you saying that no timeout, no matter how large, is large enough?
> If that's the case, we can consider turning the "wait_event_timeout"
> into a "wait_event".
>
Yep. Basically till the ceq handler reports successful completion of
reg_mr or inval_mr, mr is not guaranteed to be registered or
invalidated.

>>> Are you suggesting to
>>> a) Not fix this bug right now and wait until some later point in time
>> When did I say that ? I said have you explored alternate approach to
>> fix the issue and if not could you try it out.
>>
> 
> Why explore an alternate approach?
> Do you see a problem with the proposed patch (other than the choice of timeout)?
> 
Yes the timeout based proceeding isn't safe. wait_event without timeout
would make it guaranteed and give sync like behavior. This is the
behavior with FMR reg and inval calls. If you make that as
wait_event then am fine with the change.

Regards,
Santosh
