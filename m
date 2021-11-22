Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE564589D4
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 08:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238805AbhKVHb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 02:31:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18054 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238743AbhKVHb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 02:31:56 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AM7DfSB013255;
        Mon, 22 Nov 2021 07:28:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NRPuo7ek4lqiGCVnGy6vYMrURJtcMjij+XfqfQqPfP8=;
 b=rZQFhd92BxOLSOrECbjZ+GCJKp59gFp0LYk6Eh91trDkPHnc3xC0XjPirSrStCIR6Nr7
 umtzLYrku/ed9gbR8sue9YLU3KKdoY8EPrQB26i9OzDdc/3sp1ecH2VIssaGtjbJT4s3
 on3Z093Xggyx33ltAJtkk9LQ+ie9hxE03Fc6vAj3VFEZcA03lhtUR33EGdyhJTk3lOgA
 ImPTN5qxDKzzCOjQN3j5TALUsQjpUUB+lPp3ZCZ6rxMUMewL0Cvefr7IKUj488qOnjSd
 GQYRmXwqv7Oxm+z25DLP1yz3hJvj0upufx0Q8VVefQL6QyYZIq07nntkjiX/dawAn+KB 7w== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cg6mqg8ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Nov 2021 07:28:40 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AM7CxMf027422;
        Mon, 22 Nov 2021 07:28:38 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3cernaapkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Nov 2021 07:28:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AM7SYM01376812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 07:28:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 899CB4204F;
        Mon, 22 Nov 2021 07:28:34 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4285142056;
        Mon, 22 Nov 2021 07:28:34 +0000 (GMT)
Received: from [9.145.56.120] (unknown [9.145.56.120])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Nov 2021 07:28:34 +0000 (GMT)
Message-ID: <ac52dbfe-edd9-dd8f-c2f8-a96fea10884d@linux.ibm.com>
Date:   Mon, 22 Nov 2021 08:28:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] net/smc: loop in smc_listen
Content-Language: en-US
To:     Daxing Guo <guodaxing@huawei.com>, netdev@vger.kernel.org
Cc:     chenzhe@huawei.com, linux-s390@vger.kernel.org, greg@kroah.com
References: <20211120075451.16764-1-guodaxing@huawei.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211120075451.16764-1-guodaxing@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ks13eRq9j0iJDLqJHhKHrjEemt_kkdql
X-Proofpoint-ORIG-GUID: Ks13eRq9j0iJDLqJHhKHrjEemt_kkdql
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-22_02,2021-11-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=897 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111220035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/11/2021 08:54, Daxing Guo wrote:
> From: Guo DaXing <guodaxing@huawei.com>
> 
> The kernel_listen function in smc_listen will fail when all the available
> ports are occupied.  At this point smc->clcsock->sk->sk_data_ready has 
> been changed to smc_clcsock_data_ready.  When we call smc_listen again, 
> now both smc->clcsock->sk->sk_data_ready and smc->clcsk_data_ready point 
> to the smc_clcsock_data_ready function.
> 
> The smc_clcsock_data_ready() function calls lsmc->clcsk_data_ready which 
> now points to itself resulting in an infinite loop.
> 
> This patch restores smc->clcsock->sk->sk_data_ready with the old value.
> 
> Signed-off-by: Guo DaXing <guodaxing@huawei.com>
> ---

Thanks for your patch, I will pick it up and submit it to the net tree.

