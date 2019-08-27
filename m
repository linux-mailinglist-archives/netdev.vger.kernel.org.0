Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF019DBF7
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 05:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbfH0DVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 23:21:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52042 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbfH0DVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 23:21:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7R3JIv1077319;
        Tue, 27 Aug 2019 03:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=YZCjMPDRKYYQ7LTbr1bN8lMFoNPERVT75eXzBSTmWm0=;
 b=KKC29qYaKj8BYEEgUdmAOCtAyz97O9TZe/NrApSKgZC7cer3l7GQw0aXsmJ1rZ6zPuUr
 sTnLS//XSZXWrUrUYTiWC/g0S1ZmwYNwLz7V0rRpkRD9dIC0UI+c/P6HtS3l+klBXgZv
 jrNnzeMNyQAq4e/IsKfetzLahPOW1MF7zHIIo9Lpc9naaPs7rx9xOuszf0qSDVhsAhZ7
 FJ5lTsvPgxYbkyeQG6zRXsSxvYrZTRX9VavHTFq/MP2k0L0UDaTFLkpcqnfbqV6Y7J+S
 aOBXE3VfEclYFm/7rYEeTMPrMMvkfVNjYB//RIrjnRIUPRp2AJYWlb7ufwPl6sHKYoC1 bQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2umveh00ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 03:21:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7R3IWuB173969;
        Tue, 27 Aug 2019 03:19:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2umj1ty0nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Aug 2019 03:19:07 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7R3J6GO177126;
        Tue, 27 Aug 2019 03:19:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2umj1ty0na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 03:19:06 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7R3J66c027148;
        Tue, 27 Aug 2019 03:19:06 GMT
Received: from [10.159.211.29] (/10.159.211.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 20:19:05 -0700
Subject: Re: [PATCH net-next] net/rds: Fix info leak in rds6_inc_info_copy()
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com
References: <1566443904-12671-1-git-send-email-ka-cheong.poon@oracle.com>
 <20190824.142047.32032287178584562.davem@davemloft.net>
From:   Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Organization: Oracle Corporation
Message-ID: <7bed2cb9-0e26-f64e-5c4e-6e656f143c78@oracle.com>
Date:   Tue, 27 Aug 2019 11:18:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190824.142047.32032287178584562.davem@davemloft.net>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908270035
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/19 5:20 AM, David Miller wrote:
> From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> Date: Wed, 21 Aug 2019 20:18:24 -0700
> 
>> The rds6_inc_info_copy() function has a couple struct members which
>> are leaking stack information.  The ->tos field should hold actual
>> information and the ->flags field needs to be zeroed out.
>>
>> Fixes: 3eb450367d08 ("rds: add type of service(tos) infrastructure")
>> Fixes: b7ff8b1036f0 ("rds: Extend RDS API for IPv6 support")
>> Reported-by: 黄ID蝴蝶 <butterflyhuangxx@gmail.com>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> 
> Why would an info leak bug fix, present in current kernels, be targetted
> at 'net-next' instead of 'net'?
> 
> Please retarget this at 'net' properly, thank you.


Retarget patch sent.  Thanks.


-- 
K. Poon
ka-cheong.poon@oracle.com


