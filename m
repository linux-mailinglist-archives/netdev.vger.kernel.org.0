Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9635BE7D5
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiITOAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbiITOAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:00:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2690A17051;
        Tue, 20 Sep 2022 07:00:30 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KDkAw5010415;
        Tue, 20 Sep 2022 14:00:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=j+EMvjBsy0IMEg+i0Vc5T5tC5c3LuWqT+jfH1OLp0qE=;
 b=ngEDVwmakLzLg0EZwmF+gK3XMK39n1gOrWot4J6jp2nHJfz9lUUWwPImwlmHDzIPia9Z
 OtxhHgbsczFZBEVZi2++yTCq6kxzCY1KMbZ1rsiAhHUvyP+tOwKB5qDqmBX54Q5eojhY
 siJL96KC2RAM/lW6HRNbGJrcNQs5FaEM9yJ4P8h4MFK2Tg7f+5KgWF0fVizUIf7XqhbO
 izajrDcRxYeGMmFSAT9C+tpQX+6x7dOL2RpG8jl0RKydavyuZmztB2tTJy97olHhgVxz
 eFUxbYHhmh6Zc/L2d1HzF4g6oImuuhcnV6XgpOc8I4gLWzBU2lb1Ol7EyVCj9Xx+WgJc bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqepr0daf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 14:00:18 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28KDlE9U013676;
        Tue, 20 Sep 2022 14:00:16 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jqepr0d4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 14:00:15 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28KDt1cv003987;
        Tue, 20 Sep 2022 14:00:12 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 3jn5v9s46s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 14:00:12 +0000
Received: from smtpav05.wdc07v.mail.ibm.com ([9.208.128.117])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28KE0BrO65601932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 14:00:12 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 199C958043;
        Tue, 20 Sep 2022 14:00:11 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45E065805F;
        Tue, 20 Sep 2022 14:00:09 +0000 (GMT)
Received: from [9.155.210.227] (unknown [9.155.210.227])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 14:00:09 +0000 (GMT)
Message-ID: <52b73ecf-1a00-69ce-1cb8-8adb8bdd97c8@linux.ibm.com>
Date:   Tue, 20 Sep 2022 16:00:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH net-next v2 0/2] Separate SMC parameter settings from TCP
 sysctls
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1663667542-119851-1-git-send-email-guwen@linux.alibaba.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <1663667542-119851-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NbJ7CKR4-1Qc9gUnA9A7-QUt7h1mbzgh
X-Proofpoint-GUID: eHeb1O3jttufCdabq3PARyDWTOADBkRZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=968 clxscore=1011 impostorscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200079
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.09.22 11:52, Wen Gu wrote:
> SMC shares some sysctls with TCP, but considering the difference
> between these two protocols, it may not be very suitable for SMC
> to reuse TCP parameter settings in some cases, such as keepalive
> time or buffer size.
> 
> So this patch set aims to introduce some SMC specific sysctls to
> independently and flexibly set the parameters that suit SMC.
> 
> v2->v1:
> - Use proc_dointvec_jiffies as proc_handler and allow value 0 to
>    disable TEST_LINK.
> 
> Tony Lu (1):
>    net/smc: Unbind r/w buffer size from clcsock and make them tunable
> 
> Wen Gu (1):
>    net/smc: Introduce a specific sysctl for TEST_LINK time
> 
>   Documentation/networking/smc-sysctl.rst | 25 +++++++++++++++++++++++++
>   include/net/netns/smc.h                 |  3 +++
>   net/smc/af_smc.c                        |  5 ++---
>   net/smc/smc_core.c                      |  8 ++++----
>   net/smc/smc_llc.c                       |  2 +-
>   net/smc/smc_llc.h                       |  1 +
>   net/smc/smc_sysctl.c                    | 30 ++++++++++++++++++++++++++++++
>   7 files changed, 66 insertions(+), 8 deletions(-)
> 
Looks good. Thank you!

For the series:
Acked-by: Wenjia Zhang <wenjia@linux.ibm.com>
