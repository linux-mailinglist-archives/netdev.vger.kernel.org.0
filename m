Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E1DC4459
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 01:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbfJAXe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 19:34:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44080 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729098AbfJAXe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 19:34:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91NT2ge186027;
        Tue, 1 Oct 2019 23:34:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=NKug3I7JzsvWiQQzKkZNaijdO1xE0cp8b6ubsby2K/k=;
 b=Xd9fxBc5ART5BOMSq4N8eZOnJHGipepQF+ZIhcieAnsnLySe7+RD42yex3khEhr2ehIU
 kVF0Ubb3fXq4kbYIa9TQ0xjZMcCVtbZXlwtV+YBLRMlbx6IqdX/BaW/B5Rb7VxvnYkcN
 g1IodM9IIDsXL7+cxRUH7FUnWZwwvPdNEFLeZMFo7neexOoJ5EFTKFK68tUCBgWmDHiN
 jlNRtZ4KkHrLqEN+pCcBLwUonlmizjyK094QEBRdJ/9o3XZ4Sf+us8zKlqU4/piwSuBa
 6n5W7b3jsCNhM9x8ZNIuZS79kkpz8BKdmcq8nbAYURnXVHUynaH5+L00R/7K8tgYS7mq Ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2va05rsfeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 23:34:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x91NYGZC071620;
        Tue, 1 Oct 2019 23:34:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 2vcg600ycn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Oct 2019 23:34:49 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x91NYnWY073533;
        Tue, 1 Oct 2019 23:34:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2vcg600yca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Oct 2019 23:34:49 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x91NYmcK005310;
        Tue, 1 Oct 2019 23:34:48 GMT
Received: from [10.159.236.60] (/10.159.236.60)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Oct 2019 16:34:47 -0700
Subject: Re: [PATCH net-next] net/rds: Log vendor error if send/recv Work
 requests fail
To:     santosh.shilimkar@oracle.com, netdev@vger.kernel.org,
        davem@davemloft.net, rds-devel@oss.oracle.com
References: <1569969676-46142-1-git-send-email-sudhakar.dindukurti@oracle.com>
 <9baf7ba8-3b09-f657-d777-deaf325de4f5@oracle.com>
From:   sudhakar.dindukurti@oracle.com
Organization: Oracle Corporation
Message-ID: <efe8f603-3500-15f6-5e2d-5f6013330325@oracle.com>
Date:   Tue, 1 Oct 2019 16:34:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <9baf7ba8-3b09-f657-d777-deaf325de4f5@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910010200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Santosh.

Will send the v2 with the below suggestion

regards,

Sudhakar



On 10/01/2019 04:08 PM, santosh.shilimkar@oracle.com wrote:
> On 10/1/19 3:41 PM, Sudhakar Dindukurti wrote:
>> Logs vendor error if work requests fail. Vendor error provides
> s/Logs/Log
>> more information that is used for debugging the issue.
>>
>> Signed-off-by: Sudhakar Dindukurti <sudhakar.dindukurti@oracle.com>
>> ---
> rds_ib_mr_cqe_handler() is already patched so good to patch these
> two messages as well. Thanks !!
>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

