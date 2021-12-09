Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4009346ECFF
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhLIQ1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:27:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11562 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233101AbhLIQ1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:27:43 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9G3b0g030860;
        Thu, 9 Dec 2021 16:23:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pPYIqOum+kWGmr9UcHugonJB5YOcVJ8LPLWdoBtPrq8=;
 b=oRLT/sT/ScgHL2ffpDrmrwFLftCJ7h7YVo5Hb5x1B4TF1Gbg4qPS0pQeOhztZ0uq45Uw
 mHpSMCPjpLwa6xTY8dybWTwX/mBDwgZXnnhpr+pDkCXyeKJ8Fkz8//fq/2XkRtpgZ/s3
 fziHc26NiiFlLGysKEwPq469ry+wHncAH4e8x3GL9vDg2GXcI4uPE2WuYPGNM8bO1hZY
 4hJp6uxADx7aYkdAacbZcDMmEOFLIxwxIaP11DzCwNrEkyC+L/dbIPf84UkrkFsLJhp1
 BzgPZCdrDvV+hOroKjEztGxMsvwPh1VHZIo2AvdMA6rn+yKrZFmSxmQo8fXFI3XRODDS Pw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cum471ymc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 16:23:40 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9GJ8fN000635;
        Thu, 9 Dec 2021 16:23:38 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3cqyya1hka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 16:23:38 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9GFoTN29884694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 16:15:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 128ECAE04D;
        Thu,  9 Dec 2021 16:23:36 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC302AE058;
        Thu,  9 Dec 2021 16:23:35 +0000 (GMT)
Received: from [9.152.224.55] (unknown [9.152.224.55])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 16:23:35 +0000 (GMT)
Message-ID: <ada96eed-33f1-119f-022c-99abcf4bf666@linux.ibm.com>
Date:   Thu, 9 Dec 2021 17:23:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH] bridge: extend BR_ISOLATE to full split-horizon
Content-Language: en-US
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Lamparter <equinox@diac24.net>
Cc:     netdev@vger.kernel.org
References: <20211209121432.473979-1-equinox@diac24.net>
 <20211209074204.4be34975@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4d18d015-4154-5a0c-e93d-16b8bdbdaddb@nvidia.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <4d18d015-4154-5a0c-e93d-16b8bdbdaddb@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4Cq60jZNsYJsQPQllJvj81cuMXP49dKS
X-Proofpoint-GUID: 4Cq60jZNsYJsQPQllJvj81cuMXP49dKS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_07,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112090087
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.12.21 17:08, Nikolay Aleksandrov wrote:
> On 09/12/2021 17:42, Jakub Kicinski wrote:
>> On Thu,  9 Dec 2021 13:14:32 +0100 David Lamparter wrote:
>>> Split-horizon essentially just means being able to create multiple
>>> groups of isolated ports that are isolated within the group, but not
>>> with respect to each other.
>>>
>>> The intent is very different, while isolation is a policy feature,
>>> split-horizon is intended to provide functional "multiple member ports
>>> are treated as one for loop avoidance."  But it boils down to the same
>>> thing in the end.
>>>
>>> Signed-off-by: David Lamparter <equinox@diac24.net>
>>> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
>>> Cc: Alexandra Winter <wintera@linux.ibm.com>
>>
>> Does not apply to net-next, you'll need to repost even if the code is
>> good. Please put [PATCH net-next] in the subject.
>>
> 
> Hi,
> For some reason this patch didn't make it to my inbox.. Anyway I was
> able to see it now online, a few comments (sorry can't do them inline due
> to missing mbox patch):
> - please drop the sysfs part, we're not extending sysfs anymore
> - split the bridge change from the driver
> - drop the /* BR_ISOLATED - previously BIT(16) */ comment
> - [IFLA_BRPORT_HORIZON_GROUP] = NLA_POLICY_MIN(NLA_S32, 0), why not just { .type = NLA_U32 } ?
> - just forbid having both set (tb[IFLA_BRPORT_ISOLATED] && tb[IFLA_BRPORT_HORIZON_GROUP])
>   user-space should use just one of the two, if isolated is set then it overwrites any older
>   IFLA_BRPORT_HORIZON_GROUP settings, that should simplify things considerably
Yes, please keep it compatible with userspace setting IFLA_BRPORT_ISOLATED only.
> 
> Why the limitation (UAPI limited to positive signed int. (recommended ifindex namespace)) ?
> You have the full unsigned space available, user-space can use it as it sees fit.
> You can just remove the comment about recommended ifindex.
> 
> Also please extend the port isolation self-test with a test for a different horizon group.
> 
> Thanks,
>  Nik
> 
> 
> 
> 
