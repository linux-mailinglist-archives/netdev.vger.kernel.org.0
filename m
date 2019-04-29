Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E6AECB9
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfD2W0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:26:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48898 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbfD2W0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:26:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3TMOf4G142388;
        Mon, 29 Apr 2019 22:26:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=EwsIHPEi8IetSwNSJ8MMeoyI2TsTx56yUnG0nvfQxmQ=;
 b=bAkrNudpQzYfPrY0yKeh/uL+aNBVUfBSIXo6wbXSTeRSfkNFaes5nAMJTdzEUPr1Ltie
 lKQkD/39vm9yL/5RBiBX3Q3AchT7xTSNQLiS5nKoRjH54HE0D0wkI8iIYiKSJI7fuc6M
 OtebmU0NzQBip2w5xOXm+ilP99W4/YK4G0kqWyJWAUGV6Ar//ELU4r0ySMghYRnK10ZZ
 z0cOfk/lxFI7KbOmZ/n6MbF+GBUCVI2UlvMURBqLvnkiTDhZWzqvjjbNYEPmp3RCi9p6
 eexyZW8XZnW+Ytcu0NrOlSRMo3FshyFAU30G/Z4kK8dv844YX7xNeiQzzjPauENP11+1 JQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2s4fqq14u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 22:26:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3TMQgbn037783;
        Mon, 29 Apr 2019 22:26:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2s4d4a6c6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 22:26:41 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3TMQeaH029144;
        Mon, 29 Apr 2019 22:26:40 GMT
Received: from Santoshs-MacBook-Pro.local (/10.11.38.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Apr 2019 15:26:40 -0700
Subject: Re: [net-next][PATCH 1/2] rds: handle unsupported rdma request to fs
 dax memory
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <1556239470-26908-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556239470-26908-2-git-send-email-santosh.shilimkar@oracle.com>
 <20190429.182528.1266021884484046928.davem@davemloft.net>
From:   "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <f74e4e12-47aa-00ec-4d57-03808dbcef2b@oracle.com>
Date:   Mon, 29 Apr 2019 15:26:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429.182528.1266021884484046928.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9242 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=996
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904290145
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9242 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904290145
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/19 3:25 PM, David Miller wrote:
> From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> Date: Thu, 25 Apr 2019 17:44:29 -0700
> 
>> @@ -158,8 +158,9 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
>>   {
>>   	int ret;
>>   
>> -	ret = get_user_pages_fast(user_addr, nr_pages, write, pages);
>> -
>> +      /* get_user_pages return -EOPNOTSUPP for fs_dax memory */
>     ^^^^^^
> 
Opps. Let me fix that and post v2.

Regards,
Santosh
