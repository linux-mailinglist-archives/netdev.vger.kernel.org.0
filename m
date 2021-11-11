Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D70744D82A
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhKKOYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:24:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20430 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230177AbhKKOYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 09:24:11 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABEHcJR013204;
        Thu, 11 Nov 2021 14:21:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=kCNY6In7nKAfQCB81jpWLqY0ap/JG26S1wytdEjZaUc=;
 b=bjcXzBZvDEOUbfrxbKLvxWvxZqzy2HOnqemFD+8pxKoreKyhLAobdrll2HBIZ/QGbysb
 GPJtXRELSdgf/MavhreuKwkt7IPGrlyHwrVvmHDi/6Z/shbfh47rNLkFctUP0TsNlY79
 4wuccemV5Bx1wRwJmT2C+Y8XfU1wgDEFKve3or+ak6a2BkJ3vtid6DHwVjrzm0rOiOdS
 t19Mi8FuZsN50Wa9e9y0ATuxgZyJCEAjA8XMg+vnvmr79/fCVYHFhdwc6TAD4xVk0Zii
 pnHsGM9ixgTYcyKABfxBBz0sUmnPmgBR3GB5K9eor80W51UJ1KfKqoXxnEZ7Ycw7PsGR 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c94tfg3ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 14:21:18 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ABEKNeb026530;
        Thu, 11 Nov 2021 14:21:18 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c94tfg3k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 14:21:18 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ABEIqEn020901;
        Thu, 11 Nov 2021 14:21:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3c5gyk6xtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 14:21:16 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ABEETKT61014400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 14:14:29 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10BE94204B;
        Thu, 11 Nov 2021 14:21:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8977A4203F;
        Thu, 11 Nov 2021 14:21:13 +0000 (GMT)
Received: from [9.145.188.132] (unknown [9.145.188.132])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Nov 2021 14:21:13 +0000 (GMT)
Message-ID: <369755c0-8b3e-cf69-d7f2-8993700efc4a@linux.ibm.com>
Date:   Thu, 11 Nov 2021 15:21:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [RFC PATCH 0/2] Two RFC patches for the same SMC socket wait
 queue mismatch issue
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, tonylu@linux.alibaba.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dust.li@linux.alibaba.com, xuanzhuo@linux.alibaba.com
References: <1636548651-44649-1-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1636548651-44649-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2JprdlmGAjfrsH1K4fUU7TkY0ipdRGBo
X-Proofpoint-GUID: iqSEhHc6cDV4AYy1gc5HrDPU4G0LKcwb
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_04,2021-11-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 malwarescore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2021 13:50, Wen Gu wrote:
> Hi, Karsten
> 
> Thanks for your reply. The previous discussion about the issue of socket
> wait queue mismatch in SMC fallback can be referred from:
> https://lore.kernel.org/all/db9acf73-abef-209e-6ec2-8ada92e2cfbc@linux.ibm.com/
> 
> This set of patches includes two RFC patches, they are both aimed to fix
> the same issue, the mismatch of socket wait queue in SMC fallback.
> 
> In your last reply, I am suggested to add the complete description about
> the intention of initial patch in order that readers can understand the
> idea behind it. This has been done in "[RFC PATCH net v2 0/2] net/smc: Fix
> socket wait queue mismatch issue caused by fallback" of this mail.
> 
> Unfortunately, I found a defect later in the solution of the initial patch
> or the v2 patch mentioned above. The defect is about fasync_list and related
> to 67f562e3e14 ("net/smc: transfer fasync_list in case of fallback").
> 
> When user applications use sock_fasync() to insert entries into fasync_list,
> the wait queue they operate is smc socket->wq. But in initial patch or
> the v2 patch, I swapped sk->sk_wq of smc socket and clcsocket in smc_create(),
> thus the sk_data_ready / sk_write_space.. of smc will wake up clcsocket->wq
> finally. So the entries added into smc socket->wq.fasync_list won't be woken
> up at all before fallback.
> 
> So the solution in initial patch or the v2 patch of this mail by swapping
> sk->sk_wq of smc socket and clcsocket seems a bad way to fix this issue.
> 
> Therefore, I tried another solution by removing the wait queue entries from
> smc socket->wq to clcsocket->wq during the fallback, which is described in the
> "[RFC PATCH net 2/2] net/smc: Transfer remaining wait queue entries" of this
> mail. In our test environment, this patch can fix the fallback issue well.

Still running final tests but overall its working well here, too.
Until we maybe find a 'cleaner' solution if this I would like to go with your
current fixes. But I would like to improve the wording of the commit message and
the comments a little bit if you are okay with that.

If you send a new series with the 2 patches then I would take them and post them
to the list again with my changes.

What do you think?
