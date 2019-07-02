Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1BA05C74F
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfGBC24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:28:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36082 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfGBC2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:28:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x622Nfps017509;
        Tue, 2 Jul 2019 02:28:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=P8OgiDfBC4NDMAOUr0W/55iaFxGNy4leDtMD4bsZGfY=;
 b=RaiZNwaop1lxaQkqChcL/FdSJZig2d31PXwFg85WDp+r0oGoQcK5KVn404caxcn57MCx
 jTUI7ARHIBmKs40k1Z+aoU+xdrBpg0X99A0tTS2Izwie1reVEq503WYlAmJEou+WJ5oA
 NtelKWpKosEIMtbvb3YGmvFsubpDRv3h/sFbAdMizeJZZFw9v4tTsoQcKIqcsq2mPRYP
 VnQ71G4dEMLv18UK6D40QeUXy6/x3wcwx0ng7f2iO3aWIEI96nbxGjpueViZiBjad2j5
 h627+oWtjh9xfSvadzsSCJ8HSwn9cwO06wa5N07LUxAW1GNgqcLKrPmJXmi8G2CxJOQD bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2te61prpha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 02:28:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x622NRU3140721;
        Tue, 2 Jul 2019 02:28:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tebku0b43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jul 2019 02:28:46 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x622SjJE004739;
        Tue, 2 Jul 2019 02:28:45 GMT
Received: from [10.159.132.152] (/10.159.132.152)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 19:28:45 -0700
Subject: Re: [PATCH net-next 3/7] net/rds: Wait for the FRMR_IS_FREE (or
 FRMR_IS_STALE) transition after posting IB_WR_LOCAL_INV
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <505e9af7-a0cd-bf75-4a72-5d883ee06bf1@oracle.com>
 <c79821e0-307c-5736-6eb5-e20983097345@oracle.com>
 <01c251f4-c8f8-fcb8-bccc-341d4a3db90a@oracle.com>
 <b5669540-3892-9d79-85ba-79e96ddd3a81@oracle.com>
 <14c34ac2-38ed-9d51-f27d-74120ff34c54@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <79d25e7c-ad9e-f6d8-b0fe-4ce04c658e1e@oracle.com>
Date:   Mon, 1 Jul 2019 19:28:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <14c34ac2-38ed-9d51-f27d-74120ff34c54@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020023
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/1/19 2:06 PM, Gerd Rausch wrote:
> Hi Santosh,
> 
> On 01/07/2019 14.00, santosh.shilimkar@oracle.com wrote:
>>>
>> Look for command timeout in CX3 sources. 60 second is upper bound in
>> CX3. Its not standard in specs(at least not that I know) though
>> and may vary from vendor to vendor.
>>
> 
> I am not seeing it. Can you point me to the right place?
>
Below. All command timeouts are 60 seconds.

enum {
         MLX4_CMD_TIME_CLASS_A   = 60000,
         MLX4_CMD_TIME_CLASS_B   = 60000,
         MLX4_CMD_TIME_CLASS_C   = 60000,
};

But having said that, I re-looked the code you are patching
and thats actually only FRWR code which is purely work-request
based so this command timeout shouldn't matter.

If the work request fails, then it will lead to flush errors and
MRs will be marked as STALE. So this wait may not be necessary

There is a socket call RDS_GET_MR which needs to be synchronous
and that Avinash has actually fixed by making this MR registration
processes synchronous. Inline registration is still kept async.
RDS_GET_MR case is what actually showing the issue you saw
and the fix for that Avinash has it in production kernel.

I believe with that change, registration issue becomes non-issue
already.

And as far as invalidation concerned with proxy qp, it not longer
races with data path qp.

May be you can try those changes if not already to see if it
addresses the couple of cases where you ended up adding
timeouts.

Regards,
Santosh
