Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E175C491
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfGAUue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:50:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52590 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfGAUue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:50:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KnHtR086290;
        Mon, 1 Jul 2019 20:50:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dZkmdtjN7nciO92aOw+Gy4mS/ugKlNlelBUxHRJhEUY=;
 b=B3yHekpug5burPIPsnUqN/Wi89QKGbE0DadWK+pp1YzZBS+y9GvxgcxfwoNzWNRpXogp
 RNJWqiHVhrACXZDXrIHEFOy2WAHvA9puiTSMnXVH11Lov+FsDXFaTOoFBBuLRjgAOEjl
 ctufgU4G49wDaGaQq7GC/UtDZPna0KdAmbMn6StZAjVApI83UUXPq4IJw6bxAD/H+jlJ
 w4V3X/EJnB+pR8OZxBuv+0LLXoNYktRhjw2gLy1uLDJhMe91UQICtQg1G8YTtsABZtsA
 klCHVUzOSaN3aSBOqOexC34IN+AkevAx6pdsTHHrod0D+uRgq1UjXlTfKZYFB4e2+X6G IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2te5tbfw3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:50:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KlU62155943;
        Mon, 1 Jul 2019 20:50:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tebktw2sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:50:26 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x61KoMSo013850;
        Mon, 1 Jul 2019 20:50:22 GMT
Received: from [10.211.54.238] (/10.211.54.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 13:50:21 -0700
Subject: Re: [PATCH net-next 1/7] net/rds: Give fr_state a chance to
 transition to FRMR_IS_FREE
To:     David Miller <davem@davemloft.net>
Cc:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org
References: <44f1794c-7c9c-35bc-dc64-a2a993d06a6e@oracle.com>
 <20190701.112751.509316780582361121.davem@davemloft.net>
From:   Gerd Rausch <gerd.rausch@oracle.com>
Message-ID: <a4834749-4aa2-7e79-dbf8-004580364a39@oracle.com>
Date:   Mon, 1 Jul 2019 13:50:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190701.112751.509316780582361121.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010242
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

Hi David,

On 01/07/2019 11.27, David Miller wrote:
> From: Gerd Rausch <gerd.rausch@oracle.com>
> Date: Mon, 1 Jul 2019 09:39:44 -0700
> 
>> +			/* Memory regions make it onto the "clean_list" via
>> +			 * "rds_ib_flush_mr_pool", after the memory region has
>> +			 * been posted for invalidation via "rds_ib_post_inv".
>> +			 *
>> +			 * At that point in time, "fr_state" may still be
>> +			 * in state "FRMR_IS_INUSE", since the only place where
>> +			 * "fr_state" transitions to "FRMR_IS_FREE" is in
>> +			 * is in "rds_ib_mr_cqe_handler", which is
>> +			 * triggered by a tasklet.
>> +			 *
>> +			 * So in case we notice that
>> +			 * "fr_state != FRMR_IS_FREE" (see below), * we wait for
>> +			 * "fr_inv_done" to trigger with a maximum of 10msec.
>> +			 * Then we check again, and only put the memory region
>> +			 * onto the drop_list (via "rds_ib_free_frmr")
>> +			 * in case the situation remains unchanged.
>> +			 *
>> +			 * This avoids the problem of memory-regions bouncing
>> +			 * between "clean_list" and "drop_list" before they
>> +			 * even have a chance to be properly invalidated.
>> +			 */
>> +			frmr = &ibmr->u.frmr;
>> +			wait_event_timeout(frmr->fr_inv_done,
>> +					   frmr->fr_state == FRMR_IS_FREE,
>> +					   msecs_to_jiffies(10));
>> +			if (frmr->fr_state == FRMR_IS_FREE)
>> +				break;
> 
> If we see FRMR_IS_FREE after the timeout, what cleans this up?
> 

In that case, the memory-region is subjected to the
"rds_ib_free_frmr(ibmr, true)" call that follows:
In essence making it onto the "drop_list".

It's the same as if it wouldn't transition to FRMR_IS_FREE at all.
In both cases, the memory region should get dropped, and the application
would have been penalized by an extra 10msec wait-time (for having tried to invalidate it).

> Also, why 10msec?

It's empirical.
I had added some debugging code (not part of this submission) that traced
the return value of "wait_event_timeout" in order to see the out-lier in terms
of processing the "IB_WR_LOCAL_INV" request.

On my test-systems the majority of requests were done in less than 1msec.
I saw an outlier at almost 2msec once.
So I gave it an extra order-of-magnitude multiplier for extra buffer / paranoia.

> Why that specific value and not some other value?

I looked around to find what Mellanox or any other reference material had
so say about the expected turn--around time of an "IB_WR_LOCAL_INV" ought to be.
I wasn't able to find any.

Please note that even if there was an upper-bound specified, such as minutes:
It wouldn't necessarily be a good idea to penalize an application by wait-times
up to one minute, if the alternative is to just put this memory region on a
drop-list and pick another one (which is suggested here).

> Why not wait for however long it takes for the tasklet to run and clean it up?

Two reasons I can think of:
1) The penalty of long wait-times would go to the application
2) If there were a firmware-bug, the "wait_event" would not terminate

Thanks,

  Gerd

