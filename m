Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251955C49F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfGAU5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:57:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39566 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfGAU5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:57:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KrgdT192692;
        Mon, 1 Jul 2019 20:57:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Ww5UCsee58KDWw9JgP44rnEaHAXmWcdqr+ymfQPzisQ=;
 b=VZ3dHSOKmYiDEjWWwOlJz2kfia4BpNZ4Vc9jI3Vu42hJ1SEbhKbQ/RCJtjprzs3soJjI
 gRFHTqC95SdRA5dbuJJfvibzNGgxfaA3A2zpCwqxX97KQLs3/ZfWTOA17K4Kf72F5EEp
 CaMkvqIqGAoA2iO53vpIG0mtCulcus8cWW+lWgW7tiINM0tcy/05tWEGRwhm/AhPz15f
 +awUV8vaKm6BlWt9HLnmTVfAimuS3b5OvpF/K1beGrxX+OEcdYUBikuDYb6HGaZsPMnp
 qQoKlo0SZE9LBY80ZPeuD1S/UvHq7AJeebMYeS25nsVmnLOmoc8svOFMObCekZyPxowq ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2te61pqvqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:57:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KrKnv166399;
        Mon, 1 Jul 2019 20:55:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tebktw4ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:55:29 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x61KtS49015013;
        Mon, 1 Jul 2019 20:55:28 GMT
Received: from [10.211.54.238] (/10.211.54.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 13:55:28 -0700
Subject: Re: [PATCH net-next 3/7] net/rds: Wait for the FRMR_IS_FREE (or
 FRMR_IS_STALE) transition after posting IB_WR_LOCAL_INV
To:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <505e9af7-a0cd-bf75-4a72-5d883ee06bf1@oracle.com>
 <c79821e0-307c-5736-6eb5-e20983097345@oracle.com>
From:   Gerd Rausch <gerd.rausch@oracle.com>
Message-ID: <01c251f4-c8f8-fcb8-bccc-341d4a3db90a@oracle.com>
Date:   Mon, 1 Jul 2019 13:55:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <c79821e0-307c-5736-6eb5-e20983097345@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010243
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010243
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Santosh,

On 01/07/2019 13.41, santosh.shilimkar@oracle.com wrote:
>> @@ -144,7 +146,29 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
>>           if (printk_ratelimit())
>>               pr_warn("RDS/IB: %s returned error(%d)\n",
>>                   __func__, ret);
>> +        goto out;
>> +    }
>> +
>> +    if (!frmr->fr_reg)
>> +        goto out;
>> +
>> +    /* Wait for the registration to complete in order to prevent an invalid
>> +     * access error resulting from a race between the memory region already
>> +     * being accessed while registration is still pending.
>> +     */
>> +    wait_event_timeout(frmr->fr_reg_done, !frmr->fr_reg,
>> +               msecs_to_jiffies(100));
>> +
> This arbitrary timeout in this patch as well as pacth 1/7 which
> Dave pointed out has any logic ?
> 

It's empirical (see my response to David's question):
Memory registrations took longer than invalidations, hence 100msec instead of 10msec.

> MR registration command issued to hardware can at times take as
> much as command timeout(e.g 60 seconds in CX3) and upto that its still
> legitimate operation and not necessary failure. We shouldn't add
> arbitrary time outs in ULPs.

Where did you find the 60 seconds for CX3 you are referring to?
Is there a "generic" upper-bound that is not tied to a specific vendor / HCA?
Can you provide a pointer?

Thanks,

  Gerd

