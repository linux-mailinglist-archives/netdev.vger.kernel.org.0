Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A639446DFA
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 13:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbhKFMxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 08:53:33 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49982 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232307AbhKFMxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 08:53:32 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A6AkvN6030379;
        Sat, 6 Nov 2021 12:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jvbZUEl/K/NQhQU75ed49jIGXG6AlIWCyocwbGDQMbk=;
 b=g+GtahJV2s0hJ0wNz3M7aopI7AaBnSnVYlQTxM/qrKtW4D6hRDCe1dIRoZQmBZC+Yci3
 b4SqNyJOzPuxn0aVvh6qPtwxjGiAUO0D0lf6ah/n1VT2U6i28rg/NUqUU6dH01/ZEB2J
 yeSL3iz/CQFtUy2g+Z0R2eLvlYi59j3s3NC7366Vm/Mfl4CZPxzIxFBNzGXbhdfkdIPB
 8yeVgBU0QHQ+raKvxgVIb5+jroDpX4ZVGGDdl/sto4uo44zPzL4u1ZtZM7WhzuYqd7/w
 OdCHNoiYRJJkycSlMTbk+Q5luiHTFDgxhGWasJwSd+hAocuQVnpb2f/3JXwjJHJjTHpR 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c5r8khg4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 Nov 2021 12:50:48 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A6CaUOD031545;
        Sat, 6 Nov 2021 12:50:48 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c5r8khg4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 Nov 2021 12:50:48 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A6ClZDY009745;
        Sat, 6 Nov 2021 12:50:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3c5hb9hvk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 06 Nov 2021 12:50:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A6CohFW7537288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 6 Nov 2021 12:50:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD4F5A4053;
        Sat,  6 Nov 2021 12:50:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B360A4040;
        Sat,  6 Nov 2021 12:50:43 +0000 (GMT)
Received: from [9.145.174.141] (unknown [9.145.174.141])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  6 Nov 2021 12:50:43 +0000 (GMT)
Message-ID: <db9acf73-abef-209e-6ec2-8ada92e2cfbc@linux.ibm.com>
Date:   Sat, 6 Nov 2021 13:51:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH net 4/4] net/smc: Fix wq mismatch issue caused by smc
 fallback
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, dust.li@linux.alibaba.com,
        davem@davemloft.net, kuba@kernel.org
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-5-tonylu@linux.alibaba.com>
 <acaf3d5a-219b-3eec-3a65-91d3fdfb21e9@linux.ibm.com>
 <d4e23c6c-38a1-b38d-e394-aa32ebfc80b5@linux.alibaba.com>
 <f51d3e86-0044-bc92-cdac-52bd978b056b@linux.ibm.com>
 <c26da743-36fb-e1c3-c13f-460b3d2dbb4c@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <c26da743-36fb-e1c3-c13f-460b3d2dbb4c@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zfnZzWkqSHH8TbgLzefs0Egelm6qupVJ
X-Proofpoint-GUID: CmU5AlErrw_9QAHatFuqX4-LBGcDfPVR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-06_02,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111060077
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/11/2021 05:39, Wen Gu wrote:
> Thanks for your suggestions about implementing SMC own sk_data_ready / sk_write_space and forwarding call to clcsock. It's a great idea. But I found some difficulties here in implementation process:
> 
> In my humble opinion, SMC own sk_write_space implementation should be called by clcsk->sk_write_space and complete the following steps:
> 
> 1) Get smc_sock through clcsk->sk_user_data, like what did in smc_clcsock_data_ready().
> 
> 2) Forward call to original clcsk->sk_write_space, it MIGHT wake up clcsk->sk_wq, depending on whether certain conditions are met.
> 
> 3) Wake up smc sk->sk_wq to nodify application if clcsk->sk_write_space acctually wakes up clcsk->sk_wq.
> 
> In step 3), it seems a bit troublesome for SMC to know whether clcsk->sk_write_space acctually wake up clcsk->sk_wq, which is a black box to SMC.
> 
> There might be a feasible way that add a wait_queue_head_t to clcsk->sk_wq and report to SMC when clcsk->sk_wq is waked up. Then SMC can report to application by waking up smc sk->sk_wq. But that seems to be complex and redundancy.

Hmm so when more certain conditions have to be met in (2) to 
actually wake up clcsk->sk_wq then this might not be the right
way to go...
So when there are no better ways I would vote for your initial patch.
But please add the complete description about how this is intended to 
work to this patch to allow readers to understand the idea behind it.

Thank you.
