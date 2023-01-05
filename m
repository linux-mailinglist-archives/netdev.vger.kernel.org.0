Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718CC65EA8D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 13:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbjAEMR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 07:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbjAEMRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 07:17:53 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D485A58FB4;
        Thu,  5 Jan 2023 04:17:51 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305BgmS3032003;
        Thu, 5 Jan 2023 12:17:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=5F/YFHehYM03qImAEfUwzbfjgcKlIcmRxOHpxAMS35Y=;
 b=kh1uwG9SzqbSrIny/6jaB1cOo5q8ujbocUEqcoGebSk7Ihs3kQzlxqa3C23BqDxKdTO5
 Rxf/HGuwQHru083xWgkOpL8TdbGzTHWGC3sFLAJuUV8H71fcIX9Qsh0vXwCPPUbIdr9G
 QbPtA2nNlhkAXFJHHcbq2WS5B0YNw3M8RIXFxDlRVq4CbUsASCkPDOJbyXvNagzTKWJX
 4qzYH1Ch4NBguC3aRRvO5H8cPSErE8HprDl+hoqhlXrTNZPhEH+6o+SPbpfSuK/kB9E3
 +lo+gmhCbeSmGG5RM7dnoYfucK0AHlsMEujFVCVk9+S26HohOGVCHbTceLEPRfIHEKYt 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwwwvrpy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 12:17:34 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305BmeA2019021;
        Thu, 5 Jan 2023 12:17:33 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwwwvrpx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 12:17:33 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 304NvbIW000998;
        Thu, 5 Jan 2023 12:17:31 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3mtcbfmy8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 12:17:31 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305CHR7739453130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 12:17:27 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A42120043;
        Thu,  5 Jan 2023 12:17:27 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAC6220040;
        Thu,  5 Jan 2023 12:17:26 +0000 (GMT)
Received: from [9.171.49.209] (unknown [9.171.49.209])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 12:17:26 +0000 (GMT)
Message-ID: <645e311c-9aca-b42d-c13c-b4365635e4c2@linux.ibm.com>
Date:   Thu, 5 Jan 2023 13:17:26 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] s390/qeth: convert sysfs snprintf to sysfs_emit
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        patchwork-bot+netdevbpf@kernel.org
Cc:     Xuezhi Zhang <zhangxuezhi3@gmail.com>, zhangxuezhi1@coolpad.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221227110352.1436120-1-zhangxuezhi3@gmail.com>
 <167223001583.30539.3371420401703338150.git-patchwork-notify@kernel.org>
 <Y7a8OaOnQtRmGLIu@corigine.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <Y7a8OaOnQtRmGLIu@corigine.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M11VbWyu_4CvEv5Gi_wAcKVgdFqizTHo
X-Proofpoint-ORIG-GUID: cQ-NWJcSjYMQYGzEbJvV0x9tvpIN-92K
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_04,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 priorityscore=1501 malwarescore=0 mlxscore=0 mlxlogscore=483 bulkscore=0
 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301050095
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05.01.23 13:02, Simon Horman wrote:
> On Wed, Dec 28, 2022 at 12:20:15PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
>> Hello:
>>
>> This patch was applied to netdev/net.git (master)
>> by David S. Miller <davem@davemloft.net>:
>>
>> On Tue, 27 Dec 2022 19:03:52 +0800 you wrote:
>>> From: Xuezhi Zhang <zhangxuezhi1@coolpad.com>
>>>
>>> Follow the advice of the Documentation/filesystems/sysfs.rst
>>> and show() should only use sysfs_emit() or sysfs_emit_at()
>>> when formatting the value to be returned to user space.
>>>
>>> Signed-off-by: Xuezhi Zhang <zhangxuezhi1@coolpad.com>
>>>
>>> [...]
>>
>> Here is the summary with links:
>>   - s390/qeth: convert sysfs snprintf to sysfs_emit
>>     https://git.kernel.org/netdev/net/c/c2052189f19b
> 
> I'm a little late to the party here, but should the use of sprintf() in
> show functions elsewhere in the qeth_core_sys.c also be updated?
> 

Yes, we are working on this. Several patches will come soon, that cleanup whole files.
No need to send additional small patches on this topic at the moment.
