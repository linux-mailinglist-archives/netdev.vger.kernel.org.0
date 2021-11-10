Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38B844C1F5
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbhKJNRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:17:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35864 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231641AbhKJNRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:17:49 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AABgZZp030024;
        Wed, 10 Nov 2021 13:15:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=COOlmpUd/EPF0l1orxpaEzcUREam8OWI2PtRBKIZVkg=;
 b=ULLiL4AzlegoqrCQAa+IlN0p5hDwoXKaWX3rRjvaHQQCoqAU4jzWER0ppwdzHqw3/ghL
 9G8D/fxmJSV7Ij6BRd+YVbolwUwbNHhjRWmvdVpJzx2nyndNOSqPctNdRbedfrXNzLcp
 d70MoUfD+kJuXLK6IXm0c855adhlUUxcWDMSJUE9ZHT2x1Xk4yVEZ3LaK5K1WnzAeh6W
 08qEEJYw/FZ88DTOJPiUEisDykBi6C8J7U/YJdZ99tfV+R//roFQAJfWlMmIuCWhNjz3
 A73k5RVLaxWzuADmFl+ZycQR2E1MSo3EG+UlEqx7X73EDge+qUxlhPHCyBfIYhHN+lm8 vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c8derhxkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Nov 2021 13:15:01 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AACoGW8000855;
        Wed, 10 Nov 2021 13:15:01 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c8derhxjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Nov 2021 13:15:01 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AADC03M009676;
        Wed, 10 Nov 2021 13:14:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3c5hb9r9te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Nov 2021 13:14:58 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AADEuGZ65798610
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Nov 2021 13:14:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B08211C04C;
        Wed, 10 Nov 2021 13:14:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DF07611C05B;
        Wed, 10 Nov 2021 13:14:55 +0000 (GMT)
Received: from [9.145.47.152] (unknown [9.145.47.152])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Nov 2021 13:14:55 +0000 (GMT)
Message-ID: <0b6d5916-fad0-ccc1-9c37-21a92ffa8293@linux.ibm.com>
Date:   Wed, 10 Nov 2021 14:14:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net] net/smc: fix sk_refcnt underflow on linkdown and
 fallback
Content-Language: en-US
To:     Dust Li <dust.li@linux.alibaba.com>,
        Ursula Braun <ubraun@linux.vnet.ibm.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>, guwen@linux.alibaba.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org
References: <20211110070234.60527-1-dust.li@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20211110070234.60527-1-dust.li@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t7GsbITeQp8xcTQNJjbBSoSp35HwC8nE
X-Proofpoint-ORIG-GUID: 5o9qha51cN0eOuR3Kdt5FDTDo7My730a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-10_04,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=978 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111100069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2021 08:02, Dust Li wrote:
> We got the following WARNING when running ab/nginx
> test with RDMA link flapping (up-down-up).
> The reason is when smc_sock fallback and at linkdown
> happens simultaneously, we may got the following situation:
> 
<snip>


Acked-by: Karsten Graul <kgraul@linux.ibm.com>
