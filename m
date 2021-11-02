Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776A6442A59
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 10:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhKBJ2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 05:28:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33188 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229778AbhKBJ2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 05:28:20 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A27Gb0J007823;
        Tue, 2 Nov 2021 09:25:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4xV4QIiIniU5urU7NwQLAtW/WromjLhZE7bAgUKyKV8=;
 b=ectcXy+1L6nIaSbX+4s6HjVT81uGGpp7EqzwyPxs9cLXWyxwRMyze0N7+FDrktvvfnbA
 bhN+jQgJT8EYB/OKuZ6mi1m/I+97+T1/dpXUoXuZSk4iGB5vnsU+cWf594YeHS/LDMCv
 cR4MST+osur7nE7kUozaq0rbXThnZ2AFm8KGu5x//lx1WnxGTz2FJwaH3aKfY3pMLKq4
 d9mzVTmgdHerqPPFV3f7ydoXpJZGJSQ/vi3Nl/rmpD7MfbWDhtsq7lRtgjjseKq8FV1H
 QsMLKu7ssuwJnUwwaR/Pt4Y3oc1GBRAxSSdX3iGNhyDp4xB2ip3ePz7UlQ/StX29lPBz HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c30t4jnjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 09:25:42 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A28daxl008264;
        Tue, 2 Nov 2021 09:25:42 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c30t4jnj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 09:25:42 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A29D1FQ001395;
        Tue, 2 Nov 2021 09:25:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3c0wp9gatr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 09:25:40 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A29PbL962390696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Nov 2021 09:25:37 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0EF94C05A;
        Tue,  2 Nov 2021 09:25:37 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CD784C04E;
        Tue,  2 Nov 2021 09:25:37 +0000 (GMT)
Received: from [9.145.173.195] (unknown [9.145.173.195])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Nov 2021 09:25:37 +0000 (GMT)
Message-ID: <f51d3e86-0044-bc92-cdac-52bd978b056b@linux.ibm.com>
Date:   Tue, 2 Nov 2021 10:25:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH net 4/4] net/smc: Fix wq mismatch issue caused by smc
 fallback
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, dust.li@linux.alibaba.com
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-5-tonylu@linux.alibaba.com>
 <acaf3d5a-219b-3eec-3a65-91d3fdfb21e9@linux.ibm.com>
 <d4e23c6c-38a1-b38d-e394-aa32ebfc80b5@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <d4e23c6c-38a1-b38d-e394-aa32ebfc80b5@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hew-xnOh2km4bCwxYyMt94OrgEKDrqwG
X-Proofpoint-GUID: dntNlaN0hxOPG-cssBvSM-X9KyuuM6AN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_06,2021-11-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111020054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/11/2021 07:15, Wen Gu wrote:
> Before explaining my intentions, I thought it would be better to describe the issue I encountered first：
> 
> In nginx/wrk tests, when nginx uses TCP and wrk uses SMC to replace TCP, wrk should fall back to TCP and get correct results theoretically, But in fact it only got all zeros.

Thank you for the very detailed description, I now understand the situation.

The fix is not obvious and not easy to understand for the reader of the code,
did you think about a fix that uses own sk_data_ready / sk_write_space
implementations on the SMC socket to forward the call to the clcsock in the 
fallback situation?

I.e. we already have smc_tx_write_space(), and there is smc_clcsock_data_ready()
which is right now only used for the listening socket case.

If this works this would be a much cleaner and more understandable way to fix this issue.
