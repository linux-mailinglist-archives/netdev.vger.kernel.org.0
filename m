Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723BA68BAD7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjBFK6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBFK55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:57:57 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA50135;
        Mon,  6 Feb 2023 02:57:55 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 316AFtlc020349;
        Mon, 6 Feb 2023 10:57:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=N5e6CxKTSSvxYdy4g0/8NVHnMoEkoUpQy0J+sgvnAsA=;
 b=UDL9S0t7zwttg438bXcr8LxeaWLhvpspCbYJQSAPcHhI+m4lizB8R+y1CwsqkauEh02T
 Rbizz6YZeuYBF+mEO0zY0bC9FB9NaqM91YE/Ng63V42et1x1aWeZkXvWUgz6qnZD9HOI
 w55P7Em6GhtDHSDZJz45ah4o7qzzA9d/KuVc1BOGm8x9S549Jv70Fos8p19WD4IZkMzt
 YNHQNxwkXW92zHhf6vAn+REdEHRlg+O1/CQVx4ArTu1BD25OM52MKmltfpAuxtKYlD6E
 JMLQByhJtG4gILkoPZSW9FlFu8xaBjVq01FrMS1PYHv2lXUzhEN9RQFWfEJomG7pISp8 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3njyn5rsw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 10:57:51 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 316AjWNd003934;
        Mon, 6 Feb 2023 10:57:50 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3njyn5rsvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 10:57:50 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31693WV8003058;
        Mon, 6 Feb 2023 10:57:49 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3nhf07cv3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Feb 2023 10:57:49 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 316Avlls41746890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Feb 2023 10:57:47 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A202658058;
        Mon,  6 Feb 2023 10:57:47 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4941258054;
        Mon,  6 Feb 2023 10:57:43 +0000 (GMT)
Received: from [9.163.48.193] (unknown [9.163.48.193])
        by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  6 Feb 2023 10:57:42 +0000 (GMT)
Message-ID: <8fecb6e2-e15c-3afb-8772-157e5b5ef465@linux.ibm.com>
Date:   Mon, 6 Feb 2023 11:57:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [net-next v2 0/8] drivers/s390/net/ism: Add generalized interface
To:     dust.li@linux.alibaba.com, Jan Karcher <jaka@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Nils Hoppmann <niho@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>
References: <20230123181752.1068-1-jaka@linux.ibm.com>
 <20230129114821.GF74595@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <20230129114821.GF74595@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8R4xZSPMF_T--KE03ZO7q2U0vdQVyB6s
X-Proofpoint-ORIG-GUID: 8mYpS95mfsoF0ZVEDSfKNNAF5WZbruA2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-06_05,2023-02-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 spamscore=0 bulkscore=0 impostorscore=0
 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=941 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302060091
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29.01.23 12:48, Dust Li wrote:
> On Mon, Jan 23, 2023 at 07:17:44PM +0100, Jan Karcher wrote:
>> Previously, there was no clean separation between SMC-D code and the ISM
>> device driver.This patch series addresses the situation to make ISM available
>> for uses outside of SMC-D.
>> In detail: SMC-D offers an interface via struct smcd_ops, which only the
>> ISM module implements so far. However, there is no real separation between
>> the smcd and ism modules, which starts right with the ISM device
>> initialization, which calls directly into the SMC-D code.
>> This patch series introduces a new API in the ISM module, which allows
>> registration of arbitrary clients via include/linux/ism.h: struct ism_client.
>> Furthermore, it introduces a "pure" struct ism_dev (i.e. getting rid of
>> dependencies on SMC-D in the device structure), and adds a number of API
>> calls for data transfers via ISM (see ism_register_dmb() & friends).
>> Still, the ISM module implements the SMC-D API, and therefore has a number
>> of internal helper functions for that matter.
>> Note that the ISM API is consciously kept thin for now (as compared to the
>> SMC-D API calls), as a number of API calls are only used with SMC-D and
>> hardly have any meaningful usage beyond SMC-D, e.g. the VLAN-related calls.
> 
> Hi,
> 
> Great work ! This makes the SMC & ISM code much more clear !
> 
> I like this patchset, just some questions on this refactor.
> I still see there are some SMC related code in
> 'drivers/s390/net/ism_drv.c', mainly to implement smcd_ops.
> 
> As ISM is the lower layer of SMC, I think remove the dependency
> on SMC would be better ? Do you have any plan to do that ?
> 
Since SMC is the main user of the ISM currently, we still want to keep 
the dependency for now, Sure, I agree with you, in the future we should 
remove the dependency.

> One more thing:
> I didn't find any call for smcd_ops->set_vlan_required/reset_vlan_required,
> looks it's not needed, so why not remove it, am I missed something ?
> 
You didn't miss anything, that’s just for the usage in case

> Thanks!
> 
>>
>> v1 -> v2:
>>   Removed s390x dependency which broke config for other archs.
>>
>> Stefan Raspl (8):
>>   net/smc: Terminate connections prior to device removal
>>   net/ism: Add missing calls to disable bus-mastering
>>   s390/ism: Introduce struct ism_dmb
>>   net/ism: Add new API for client registration
>>   net/smc: Register SMC-D as ISM client
>>   net/smc: Separate SMC-D and ISM APIs
>>   s390/ism: Consolidate SMC-D-related code
>>   net/smc: De-tangle ism and smc device initialization
>>
>> drivers/s390/net/ism.h     |  19 +-
>> drivers/s390/net/ism_drv.c | 376 ++++++++++++++++++++++++++++++-------
>> include/linux/ism.h        |  98 ++++++++++
>> include/net/smc.h          |  24 +--
>> net/smc/af_smc.c           |   9 +-
>> net/smc/smc_clc.c          |  11 +-
>> net/smc/smc_core.c         |  13 +-
>> net/smc/smc_diag.c         |   3 +-
>> net/smc/smc_ism.c          | 180 ++++++++++--------
>> net/smc/smc_ism.h          |   3 +-
>> net/smc/smc_pnet.c         |  40 ++--
>> 11 files changed, 560 insertions(+), 216 deletions(-)
>> create mode 100644 include/linux/ism.h
>>
>> -- 
>> 2.25.1
