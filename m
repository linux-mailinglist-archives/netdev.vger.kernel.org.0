Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B17225C495
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGAUx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:53:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36774 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfGAUx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:53:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61Kmsdo188755;
        Mon, 1 Jul 2019 20:53:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=wPkt4b4Lgoo+zVwiz7ZxF/u4O2AeD4+s9WdhtOqE5+4=;
 b=r8YfpMjMRfRFjnYislKfqWH9Jit48D+Idq8o4hCvgkMp0fBOWJozenrcpBmgLBuAcZtf
 KaeWPnNm7ue023YXZDgZf591X3Lt4t3842SiryKhnHstGqnwwejmKbA9WCLpgWQe3rK3
 QQQMIDnh5FbpvScr9rzb314CneY+IVX80JP8GK/XOLB6r2W4WxHlBWeAHmK0n79/NSEx
 DgAH29w/X4na7iLrIrS5ziCYZEuupjT9gmjusd1mMPvIWC3NKgIQOH+KnrXAexq4Hkpg
 iyQRE8pfa96MhMes9UK8viH90lhb7WPPe/p3ZToyI/GODyFEnU8pn32SwVBqVB9Crpgi FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2te61pqv8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:53:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KrJ5x190596;
        Mon, 1 Jul 2019 20:53:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tebbjd54m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:53:25 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x61KrO57015774;
        Mon, 1 Jul 2019 20:53:24 GMT
Received: from [10.209.242.148] (/10.209.242.148)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 13:53:24 -0700
Subject: Re: [PATCH net-next 1/7] net/rds: Give fr_state a chance to
 transition to FRMR_IS_FREE
To:     Gerd Rausch <gerd.rausch@oracle.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <44f1794c-7c9c-35bc-dc64-a2a993d06a6e@oracle.com>
 <20190701.112751.509316780582361121.davem@davemloft.net>
 <a4834749-4aa2-7e79-dbf8-004580364a39@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <95d566af-30dc-fecc-9a1b-3c8c7d69b880@oracle.com>
Date:   Mon, 1 Jul 2019 13:53:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <a4834749-4aa2-7e79-dbf8-004580364a39@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010243
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010242
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 1:50 PM, Gerd Rausch wrote:
> Hi David,
> 
> On 01/07/2019 11.27, David Miller wrote:
>> From: Gerd Rausch <gerd.rausch@oracle.com>
>> Date: Mon, 1 Jul 2019 09:39:44 -0700
>>
>>> +			/* Memory regions make it onto the "clean_list" via
>>> +			 * "rds_ib_flush_mr_pool", after the memory region has
>>> +			 * been posted for invalidation via "rds_ib_post_inv".
>>> +			 *
>>> +			 * At that point in time, "fr_state" may still be
>>> +			 * in state "FRMR_IS_INUSE", since the only place where
>>> +			 * "fr_state" transitions to "FRMR_IS_FREE" is in
>>> +			 * is in "rds_ib_mr_cqe_handler", which is
>>> +			 * triggered by a tasklet.
>>> +			 *
>>> +			 * So in case we notice that
>>> +			 * "fr_state != FRMR_IS_FREE" (see below), * we wait for
>>> +			 * "fr_inv_done" to trigger with a maximum of 10msec.
>>> +			 * Then we check again, and only put the memory region
>>> +			 * onto the drop_list (via "rds_ib_free_frmr")
>>> +			 * in case the situation remains unchanged.
>>> +			 *
>>> +			 * This avoids the problem of memory-regions bouncing
>>> +			 * between "clean_list" and "drop_list" before they
>>> +			 * even have a chance to be properly invalidated.
>>> +			 */
>>> +			frmr = &ibmr->u.frmr;
>>> +			wait_event_timeout(frmr->fr_inv_done,
>>> +					   frmr->fr_state == FRMR_IS_FREE,
>>> +					   msecs_to_jiffies(10));
>>> +			if (frmr->fr_state == FRMR_IS_FREE)
>>> +				break;
>>
>> If we see FRMR_IS_FREE after the timeout, what cleans this up?
>>
> 
> In that case, the memory-region is subjected to the
> "rds_ib_free_frmr(ibmr, true)" call that follows:
> In essence making it onto the "drop_list".
> 
> It's the same as if it wouldn't transition to FRMR_IS_FREE at all.
> In both cases, the memory region should get dropped, and the application
> would have been penalized by an extra 10msec wait-time (for having tried to invalidate it).
> 
>> Also, why 10msec?
> 
> It's empirical.
> I had added some debugging code (not part of this submission) that traced
> the return value of "wait_event_timeout" in order to see the out-lier in terms
> of processing the "IB_WR_LOCAL_INV" request.
> 
> On my test-systems the majority of requests were done in less than 1msec.
> I saw an outlier at almost 2msec once.
> So I gave it an extra order-of-magnitude multiplier for extra buffer / paranoia.
> 
>> Why that specific value and not some other value?
> 
> I looked around to find what Mellanox or any other reference material had
> so say about the expected turn--around time of an "IB_WR_LOCAL_INV" ought to be.
> I wasn't able to find any.
> 
LOCAL_INV/REG etc are all end being HCA commands and the command 
timeouts are large. 60 seconds is what CX3 HCA has for example.
Thats the worst case timeout from HCA before marking the command
to be timeout and hence the operation to be failed.

Regards,
Santosh
