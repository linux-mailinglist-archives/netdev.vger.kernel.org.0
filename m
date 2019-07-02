Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEA85DADE
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfGCBbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:31:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54048 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbfGCBbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:31:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62M9hkO091498;
        Tue, 2 Jul 2019 22:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=vOJPmmjMdSkXlRHfTl5SSewfvum7M/K5nDwylVV+JoI=;
 b=t8Wi9CuEHJovmT1ibLk6uoDM08q16g7yX460Sv3WdmrKVbKmDG54WR3YkMpfJePCYiXC
 nz2gBOUSgj62iTXJm1DbIFq218Vp5PpMXaaCHHrXcXaO5IQ8+Qr5vtflWxvcBJ6F+Xdb
 ED6EJao1DdqPf2D9oE+MbF1DSAu1PajY5K556SyIrAgs4+HR5F/L41I6KX64d+D0Q3Ka
 7TqfhVLib5Qr2bhSvPPVi5Hh9GAElIZOSEba4aCXIpaLI8z1CU6qm331x9gYUfJrWvrk
 /+qKQpLO/T/quJgDC8/iwpcIUUpXhfFMVn/3W9QwL6BnUcVHLs2W4nXeYaJLIrcpnhoj PQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2te5tbp682-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 22:12:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62MCdRs165596;
        Tue, 2 Jul 2019 22:12:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2tebam18jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 22:12:39 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x62MCaZn027426;
        Tue, 2 Jul 2019 22:12:37 GMT
Received: from [10.211.54.238] (/10.211.54.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jul 2019 15:12:36 -0700
Subject: Re: [PATCH net-next 3/7] net/rds: Wait for the FRMR_IS_FREE (or
 FRMR_IS_STALE) transition after posting IB_WR_LOCAL_INV
To:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org
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
From:   Gerd Rausch <gerd.rausch@oracle.com>
Message-ID: <74255414-7e5c-e490-4745-9a8b9a73488d@oracle.com>
Date:   Tue, 2 Jul 2019 15:12:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1759bca6-4511-6cd9-ab5d-8c9c30e5db67@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020245
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020244
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/07/2019 14.18, santosh.shilimkar@oracle.com wrote:
> On 7/2/19 2:05 PM, Gerd Rausch wrote:
>> What do you call "RDS_GET_MR" semantics?
>>
> Its a blocking socket call. Meaning after this call return to the
> user, the key must be valid. With async registration that can't be
> guaranteed.
> 

If the "IB_WR_REG_MR" operation does not complete successfully within 
the given (to-be-discussed?) timeout, "rds_ib_post_reg_frmr" will return
"-EBUSY".

And that should propagate up the entire stack and make its way into
"setsockopt" returning "-1" with "errno == EBUSY".

Do you see a problem with this approach?
Did you observe a situation where this did not work?

Are you saying that no timeout, no matter how large, is large enough?
If that's the case, we can consider turning the "wait_event_timeout"
into a "wait_event".

>> Are you suggesting to
>> a) Not fix this bug right now and wait until some later point in time
> When did I say that ? I said have you explored alternate approach to
> fix the issue and if not could you try it out.
> 

Why explore an alternate approach?
Do you see a problem with the proposed patch (other than the choice of timeout)?

>> b) Use a different fix. If you've got a different fix, please share.
>>
> I don't but its a review of the fix and possible alternate needs to
> be discussed. It is not like take my fix or provide an alternate fix.
> 

As it is, the upstream implementation of RDS does not work.
IMO, it is desirable to make it work.

If there are future and better implementation of existing functionality
that is fine.
That should not preclude us from fixing what is broken as soon as we can.

>> And besides these options, is there anything wrong with this fix
>> (other than the discussion of what the timeout value ought to be,
>>   which we can address)?
>>
> That timeout is a problem because it doesn't guarantee the failure
> of operation since its an asyn operation for registration.

The fact that the work-request is asynchroneous is precisely what
makes it necessary to wait for the completion before moving on.

That is the proposed change of waiting for the completion
(or a time-out to put an upper bound to the wait)
does.

Replace the "wait_event_timeout" mentally with a "wait_event":
In that case, the process will be stuck in the corresponding function
(e.g. "rds_ib_post_reg_frmr") until the completion handler has occurred
and the "wake_up" call was issued.

It is the job of the "rds_ib_mr_cqe_handler" handler to inspect
the status of the work-completion and set the "fr_state" accordingly.

As far as I can tell, that is happening.

The debate on whether to use a "wait_event" or "wait_event_timeout"
is strictly a debate over whether or not there should
be an upper bound for the firmware to respond.

If there is not: It should be "wait_event".

If there is: It should be "wait_event_timeout", and we need to specify
what that upper bound is.

> Instead of timing out if you poll the CQ for that operation completion, it
> makes it full proof. That is the change Avinash has done iirc and
> am requesting to look at that fix.
> 

The "wake_up" call is issued from within the completion handler.

The completion handler "rds_ib_mr_cqe_handler" is called upon
handling the work-completions coming out of "ib_poll_cq".

That is necessary in order to check the status of the completion.

There are many changes that were done in the Oracle internal repository
(including changes that Avinash had done),
that we will go through in order to see what needs to be fixed in the
upstream version of RDS.

But unless you can see something that is wrong with this proposed fix,
I would suggest we don't leave the upstream RDS broken for extended
periods of time, but rather fix it.

> Other 5 fixes from the series looks fine.
> 

Thank you,

  Gerd

