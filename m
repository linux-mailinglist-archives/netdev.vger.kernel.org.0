Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946665D4AB
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfGBQtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:49:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33102 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBQtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:49:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62GhYbU131711;
        Tue, 2 Jul 2019 16:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=FgGpgdyeSdppZLtEFWoNhvvtMg7BRZhPlbyfqT5RG+k=;
 b=u9ZLezzB+mqKtmlzVmsOfvv+CnDIDJ3siMHGbuWLzvjitVpz6AWLUPdqVOumhngm/Ved
 IEjmuSTj7OXISwoYKitb7XYfp488o1b60ViRQdahtvuYXdzO3MmPQWcoRkMoJqYPsVMN
 xPyGJXZ8YPiPEz+MsduvD31tXg84+3vghC+Yq4qkVpzBBbujUicnb2OYIaHF8cajkOd7
 ei/kqsuvscCdcfkvt8uUibLLXf1bsRatV07jGoq3u8HPEBXF3SRYlF0hhD66NyzMlzGe
 Q+QRz+yyJvEsJI5tHtJwZdAjgvdLPJBxVmiSoL4hmfltE2C0kMIM/IyRsdkZ4yB0fnxH kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2te61e4um6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 16:49:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62GmCXc101929;
        Tue, 2 Jul 2019 16:49:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tebkucfrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 16:49:07 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x62Gn6YD003684;
        Tue, 2 Jul 2019 16:49:07 GMT
Received: from [10.209.242.19] (/10.209.242.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jul 2019 09:49:06 -0700
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
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <d7ab5505-92e5-888c-a230-77bce3540261@oracle.com>
Date:   Tue, 2 Jul 2019 09:49:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <6ff00a46-07f6-7be2-8e75-c87448568aa4@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020184
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020183
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 10:11 PM, Gerd Rausch wrote:
> Hi Santosh,
> 
> On 01/07/2019 19.28, santosh.shilimkar@oracle.com wrote:
>>>
>> Below. All command timeouts are 60 seconds.
>>
>> enum {
>>          MLX4_CMD_TIME_CLASS_A   = 60000,
>>          MLX4_CMD_TIME_CLASS_B   = 60000,
>>          MLX4_CMD_TIME_CLASS_C   = 60000,
>> };
>>
> 
> Thank you for the pointer.
> 
>> But having said that, I re-looked the code you are patching
>> and thats actually only FRWR code which is purely work-request
>> based so this command timeout shouldn't matter.
>>
> 
> Which brings us back full circle to the question of
> what the timeout ought to be?
> 
> Please keep in mind that prior to this fix,
> the RDS code didn't wait at all:
> 
> It simply posted those registration (IB_WR_REG_MR)
> and invalidation (IB_WR_LOCAL_INV)
> work-requests, with no regards to when the firmware
> would execute them.
> 
> Arguably, waiting any amount time greater than zero
> for the operation to complete is better than not waiting at all.
> 
> We can change the timeout to a high value, or even make it infinite
> by using "wait_event" instead of "wait_event_timeout".
> 
> For the registration work-requests there is a benefit to wait a short
> amount of time only (the trade-off described in patch #1 of this series).
>
Actually we should just switch this code to what Avinash has
finally made in downstream code. That keeps the RDS_GET_MR
semantics and makes sure MR is really valid before handing over
the key to userland. There is no need for any timeout
for registration case.

> For de-registration work-requests, it is beneficial to wait
> until they are truly done.
> But: Function "rds_ib_unreg_frmr" prior and post this change
> simply moves on after a failed de-registration attempt,
> and releases the pages owned by the memory region.
> 
> This patch does _not_ change that behavior.
> 
>> If the work request fails, then it will lead to flush errors and
>> MRs will be marked as STALE. So this wait may not be necessary
>>
> 
> This wait is necessary to avoid the 2 scenarios described
> in the commit-log message:
> 
> #1) Memory regions bouncing between "drop_list" and "clean_list"
>      as items on the "clean_list" aren't really clean until
>      their state transitions to "FRMR_IS_FREE".

> 
> #2) Prevent an access error as "rds_ib_post_inv" is called
>      just prior to de-referencing pages via "__rds_ib_teardown_mr".
>      And you certainly don't want those pages populated in the
>      HCA's memory-translation-table with full access, while
>      the Linux kernel 'thinks' you gave them back already
>      and starts re-purposing them.
> 
>> RDS_GET_MR case is what actually showing the issue you saw
>> and the fix for that Avinash has it in production kernel.
> 
> Actually, no:
> Socket option RDS_GET_MR wasn't even in the code-path of the
> tests I performed:
> 
> It were there RDS_CMSG_RDMA_MAP / RDS_CMSG_RDMA_DEST control
> messages that ended up calling '__rds_rdma_map".
>
What option did you use ? Default option with rds-stress is
RDS_GET_MR and hence the question.

>>
>> I believe with that change, registration issue becomes non-issue
>> already.
>>
> 
> Please explain how that is related to this fix-suggestion?
> 
> I submitted this patch #3 and the others in this series in order
> to fix bugs in the RDS that is currently shipped with Linux.
> 
> It may very well be the case that there are other changes
> that Avinash put into production kernels that would be better
> suited to fix this and other problems.
> 
> But that should not eliminate the need to fix what is currently broken.
> 
> Fixing what's broken does not preclude replacing the fixed code
> with newer or better versions of the same.
> 
>> And as far as invalidation concerned with proxy qp, it not longer
>> races with data path qp.
>>
> 
> I don't understand, please elaborate.
> 
>> May be you can try those changes if not already to see if it
>> addresses the couple of cases where you ended up adding
>> timeouts.
>>
> 
> I don't understand, please elaborate:
> a) Are you saying this issue should not be fixed?
> b) Or are you suggesting to replace this fix with a different fix?
>     If it's the later, please point out what you have in mind.
> c) ???
> 
All am saying is the code got changed for good reason and that changed
code makes some of these race conditions possibly not applicable.
So instead of these timeout fixes, am suggesting to use that
code as fix. At least test it with those changes and see whats
the behavior.

Regards,
Santosh
