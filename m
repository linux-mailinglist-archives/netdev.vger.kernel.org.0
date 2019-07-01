Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE3B5C4BD
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfGAVAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:00:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41582 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfGAVAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:00:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61L0dIH001605;
        Mon, 1 Jul 2019 21:00:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=z7EOD44PUdbOdHUOKi9WiR9CJG8U/xJiM8deCC7Il7A=;
 b=p++alRx6ncOwZQF+Qi8l5yLilsNLPkmF0hhVyEemVevIullgyPAzZgqV9LyelNWcCe8l
 QtrVFT1q7eyurAkcQq1R56j3KV7U32LQX74PiOAxB/BGeZjr3GMkqgHYevBPnNeKAUvR
 tW7zh01QJXyMUQeD1idnJgpfdxt4SDjgBJqLABihVWyMbLVfhynFu5Xo+cUmoC2eFrhy
 jJbsCc4LEjycakpZV+0+Jt0MbfeWNorwyiq7Pqk17K/gk69XWqvUWUW6m0W4Obs+R81m
 CwSfYnPVhFFsXcPNhxwTCLq5iQedfFFXgj85qQ3gewMS6YCYNU89p/5NkkE/MWJFF1wd ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2te61pqw1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 21:00:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KvNxm067844;
        Mon, 1 Jul 2019 21:00:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2tebakd6bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 21:00:38 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x61L0cVQ019947;
        Mon, 1 Jul 2019 21:00:38 GMT
Received: from [10.11.38.58] (/10.11.38.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 14:00:37 -0700
Subject: Re: [PATCH net-next 3/7] net/rds: Wait for the FRMR_IS_FREE (or
 FRMR_IS_STALE) transition after posting IB_WR_LOCAL_INV
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <505e9af7-a0cd-bf75-4a72-5d883ee06bf1@oracle.com>
 <c79821e0-307c-5736-6eb5-e20983097345@oracle.com>
 <01c251f4-c8f8-fcb8-bccc-341d4a3db90a@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <b5669540-3892-9d79-85ba-79e96ddd3a81@oracle.com>
Date:   Mon, 1 Jul 2019 14:00:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <01c251f4-c8f8-fcb8-bccc-341d4a3db90a@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010244
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010244
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 1:55 PM, Gerd Rausch wrote:
> Hi Santosh,
> 
> On 01/07/2019 13.41, santosh.shilimkar@oracle.com wrote:
>>> @@ -144,7 +146,29 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
>>>            if (printk_ratelimit())
>>>                pr_warn("RDS/IB: %s returned error(%d)\n",
>>>                    __func__, ret);
>>> +        goto out;
>>> +    }
>>> +
>>> +    if (!frmr->fr_reg)
>>> +        goto out;
>>> +
>>> +    /* Wait for the registration to complete in order to prevent an invalid
>>> +     * access error resulting from a race between the memory region already
>>> +     * being accessed while registration is still pending.
>>> +     */
>>> +    wait_event_timeout(frmr->fr_reg_done, !frmr->fr_reg,
>>> +               msecs_to_jiffies(100));
>>> +
>> This arbitrary timeout in this patch as well as pacth 1/7 which
>> Dave pointed out has any logic ?
>>
> 
> It's empirical (see my response to David's question):
> Memory registrations took longer than invalidations, hence 100msec instead of 10msec.
> 
>> MR registration command issued to hardware can at times take as
>> much as command timeout(e.g 60 seconds in CX3) and upto that its still
>> legitimate operation and not necessary failure. We shouldn't add
>> arbitrary time outs in ULPs.
> 
> Where did you find the 60 seconds for CX3 you are referring to?
> Is there a "generic" upper-bound that is not tied to a specific vendor / HCA?
> Can you provide a pointer?
> 
Look for command timeout in CX3 sources. 60 second is upper bound in
CX3. Its not standard in specs(at least not that I know) though
and may vary from vendor to vendor.

Regards,
Santosh

