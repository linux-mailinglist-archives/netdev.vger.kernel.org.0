Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4625C8A1
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 07:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbfGBFLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 01:11:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51020 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfGBFLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 01:11:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6259Ax4024258;
        Tue, 2 Jul 2019 05:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=6UCewGARmKumTm5Gbhlniu5MsOlGBti/jYiftszZXGI=;
 b=LI5LPBx+7ZSJzvEv9+v4vNkIeNO0GHN9XKj6eMONKowxRjatINSYbg8YAVCcaRH/2h2k
 r69dk3QurI8Sfw6L74DCXIdRrjbI7wqtGXbnD89Y+FyFNI1SNkSp5eDpMWocRASYo1Ij
 DSQVI6K3XujRHX9/bHnY9kke9P89TTNyc/P9K+9k+w4dDdMzkaqbcz3UfD61uGuyQzVq
 SxgfF79IT1ml4ksGoDTjWOaxPKnteV3+YpTLux2ndXSd5h5iD4hSRbdlt2v946RLNCYP
 4Hbz5QzAfvJsLaQZOtRiD8nH8YsSvKg29AU67oORj6ZccMhjg3HFFgd0IaFuz/SbkCZw Lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2te5tbh49c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 05:11:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6258H1q101763;
        Tue, 2 Jul 2019 05:11:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2tebakhrr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 05:11:02 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x625B22N029537;
        Tue, 2 Jul 2019 05:11:02 GMT
Received: from [10.159.132.220] (/10.159.132.220)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 22:11:02 -0700
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
From:   Gerd Rausch <gerd.rausch@oracle.com>
Message-ID: <6ff00a46-07f6-7be2-8e75-c87448568aa4@oracle.com>
Date:   Mon, 1 Jul 2019 22:11:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <79d25e7c-ad9e-f6d8-b0fe-4ce04c658e1e@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020056
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020057
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Santosh,

On 01/07/2019 19.28, santosh.shilimkar@oracle.com wrote:
>>
> Below. All command timeouts are 60 seconds.
> 
> enum {
>         MLX4_CMD_TIME_CLASS_A   = 60000,
>         MLX4_CMD_TIME_CLASS_B   = 60000,
>         MLX4_CMD_TIME_CLASS_C   = 60000,
> };
> 

Thank you for the pointer.

> But having said that, I re-looked the code you are patching
> and thats actually only FRWR code which is purely work-request
> based so this command timeout shouldn't matter.
> 

Which brings us back full circle to the question of
what the timeout ought to be?

Please keep in mind that prior to this fix,
the RDS code didn't wait at all:

It simply posted those registration (IB_WR_REG_MR)
and invalidation (IB_WR_LOCAL_INV)
work-requests, with no regards to when the firmware
would execute them.

Arguably, waiting any amount time greater than zero
for the operation to complete is better than not waiting at all.

We can change the timeout to a high value, or even make it infinite
by using "wait_event" instead of "wait_event_timeout".

For the registration work-requests there is a benefit to wait a short
amount of time only (the trade-off described in patch #1 of this series).

For de-registration work-requests, it is beneficial to wait
until they are truly done.
But: Function "rds_ib_unreg_frmr" prior and post this change
simply moves on after a failed de-registration attempt,
and releases the pages owned by the memory region.

This patch does _not_ change that behavior.

> If the work request fails, then it will lead to flush errors and
> MRs will be marked as STALE. So this wait may not be necessary
> 

This wait is necessary to avoid the 2 scenarios described
in the commit-log message:

#1) Memory regions bouncing between "drop_list" and "clean_list"
    as items on the "clean_list" aren't really clean until
    their state transitions to "FRMR_IS_FREE".

#2) Prevent an access error as "rds_ib_post_inv" is called
    just prior to de-referencing pages via "__rds_ib_teardown_mr".
    And you certainly don't want those pages populated in the
    HCA's memory-translation-table with full access, while
    the Linux kernel 'thinks' you gave them back already
    and starts re-purposing them.

> RDS_GET_MR case is what actually showing the issue you saw
> and the fix for that Avinash has it in production kernel.

Actually, no:
Socket option RDS_GET_MR wasn't even in the code-path of the
tests I performed:

It were there RDS_CMSG_RDMA_MAP / RDS_CMSG_RDMA_DEST control
messages that ended up calling '__rds_rdma_map".

> 
> I believe with that change, registration issue becomes non-issue
> already.
> 

Please explain how that is related to this fix-suggestion?

I submitted this patch #3 and the others in this series in order
to fix bugs in the RDS that is currently shipped with Linux.

It may very well be the case that there are other changes
that Avinash put into production kernels that would be better
suited to fix this and other problems.

But that should not eliminate the need to fix what is currently broken.

Fixing what's broken does not preclude replacing the fixed code
with newer or better versions of the same.

> And as far as invalidation concerned with proxy qp, it not longer
> races with data path qp.
> 

I don't understand, please elaborate.

> May be you can try those changes if not already to see if it
> addresses the couple of cases where you ended up adding
> timeouts.
> 

I don't understand, please elaborate:
a) Are you saying this issue should not be fixed?
b) Or are you suggesting to replace this fix with a different fix?
   If it's the later, please point out what you have in mind.
c) ???

Thanks,

  Gerd
