Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D639243E34E
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhJ1OSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:18:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48294 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230258AbhJ1OSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:18:51 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19SCHNRD031947;
        Thu, 28 Oct 2021 14:16:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=szaWRJZ4UZQ8W7si1vNcRebSoAnTi0y31cGU/aMzOl8=;
 b=XjNn9/tQmfYvWZ3weZ12hrfgKvhODNT3slgCVYW2EkDpNU8o32VlAntDupc5LIJkWQSm
 o3A4vkeIiu1yh/ZJ15QUPemF1emk2wrJFpiUE6ZmcQUbPezEp64s93DBxn4f71QIHE5W
 6LdqdXy2JLei1OePly/5gYt9M9NQH5Svb0/g2jYLCEgi04Sqd6XIM+ZqIapCg1TBUaGH
 ixSLxCcmfuLp//yDSiAkQ2qKqbkf+NmZUXoxH+y5gagrDbvBMh5YpPtxk3S6k9NfEFix
 jgsrwSbX1FJSArq3CWzmr9BIolaujND0b5F5plKjdRSQ19/Xbkr3jtZjbiP6UyQ2YBX1 yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3byur4atcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 14:16:22 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19SDv4Yh008996;
        Thu, 28 Oct 2021 14:16:22 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3byur4atbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 14:16:22 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19SEDXWG005723;
        Thu, 28 Oct 2021 14:16:19 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3bx4f80k2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Oct 2021 14:16:19 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19SEA4pw36438448
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Oct 2021 14:10:04 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D42B0A4055;
        Thu, 28 Oct 2021 14:16:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 689DBA4057;
        Thu, 28 Oct 2021 14:16:16 +0000 (GMT)
Received: from [9.145.20.114] (unknown [9.145.20.114])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Oct 2021 14:16:16 +0000 (GMT)
Message-ID: <0c304740-dc87-c022-5397-96c6058732c0@linux.ibm.com>
Date:   Thu, 28 Oct 2021 16:16:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH net 4/4] net/smc: Fix wq mismatch issue caused by smc
 fallback
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-5-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211027085208.16048-5-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ckMfRJImVifWrh7T3XDE5FMdQFKJos4Z
X-Proofpoint-ORIG-GUID: s0_mfw1tCGSEF8-vO0Z78GtNikMAYmJb
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-28_01,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 priorityscore=1501
 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110280079
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 10:52, Tony Lu wrote:
> From: Wen Gu <guwen@linux.alibaba.com>
> 
> A socket_wq mismatch issue may occur because of fallback.
> 
> When use SMC to replace TCP, applications add an epoll entry into SMC
> socket's wq, but kernel uses clcsock's wq instead of SMC socket's wq
> once fallback occurs, which means the application's epoll fd dosen't
> work anymore.
> 
> For example:
> server: nginx -g 'daemon off;'
> 
> client: smc_run wrk -c 1 -t 1 -d 5 http://11.200.15.93/index.html
> 
>   Running 5s test @ http://11.200.15.93/index.html
>     1 threads and 1 connections
>     Thread Stats   Avg      Stdev     Max   +/- Stdev
>       Latency     0.00us    0.00us   0.00us    -nan%
>       Req/Sec     0.00      0.00     0.00      -nan%
>     0 requests in 5.00s, 0.00B read
>   Requests/sec:      0.00
>   Transfer/sec:       0.00B
> 
> This patch fixes this issue by using clcsock's wq regardless of
> whether fallback occurs.
> 

I need to spend some more time testing and thinking about this fix.
Thank you.
