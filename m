Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBCF9673EB0
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 17:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjASQZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 11:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjASQZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 11:25:17 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580CC8A729;
        Thu, 19 Jan 2023 08:25:13 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JG735k024404;
        Thu, 19 Jan 2023 16:25:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : from : subject : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=M4DKj8thb84wReVOmS3Yb02SiqMfR9e4zAcHp2KNyOg=;
 b=tKSAH3v5UJn2qGp8Pm4g7b+fXunan1S+KcpUMsiEwbdkZKxtNT+mlCqoIMkTSnw/PVLC
 gtmXYTtqpksAkP2gKirDXoHfWBGGkyTF8EKK+xIP6V0L6COf1nxm17ZzZrrzLmVXXMSa
 PPFqczJz4lRRF7MEjycVhzwVCZF9LO+jqO1h3RQ0sAPoH5unLol1lMVboPvhaTw47LpE
 9WJee2hlThN1HFWCamBGs5F96HxTmpRghrpV5qY31fGy2xQsFnCMJNQBMk3cCrmZvGSS
 ILp5MQPgJCDoYQ2dcZIflkXzUoX08cb8fzoA5UQrZbsPFB92IcAL+b5PU9czrwtMGGBx pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n77evbqkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 16:25:08 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JG7jxc029126;
        Thu, 19 Jan 2023 16:25:08 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n77evbqjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 16:25:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30J5WauG004659;
        Thu, 19 Jan 2023 16:25:06 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16pwhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 16:25:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JGP1qI48628192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 16:25:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A02652004D;
        Thu, 19 Jan 2023 16:25:01 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A64520043;
        Thu, 19 Jan 2023 16:25:01 +0000 (GMT)
Received: from [9.152.224.247] (unknown [9.152.224.247])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 16:25:01 +0000 (GMT)
Message-ID: <2ff23fc7-c393-46b8-e358-31a39ed2c56b@linux.ibm.com>
Date:   Thu, 19 Jan 2023 17:25:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
From:   Alexandra Winter <wintera@linux.ibm.com>
Subject: Re: [RFC PATCH net-next v2 1/5] net/smc: introduce SMC-D loopback
 device
To:     Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
 <1671506505-104676-2-git-send-email-guwen@linux.alibaba.com>
Content-Language: en-US
In-Reply-To: <1671506505-104676-2-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Nk29d41S6xM5fND4GPh4PMU0Kvkbd5L2
X-Proofpoint-ORIG-GUID: b87XHW8Kc8DGT3hAzS22DmiO4c6m2TnP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_09,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190130
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.12.22 04:21, Wen Gu wrote:
> This patch introduces a kind of loopback device for SMC-D, thus
> enabling the SMC communication between two local sockets in one
> kernel.
> 
> The loopback device supports basic capabilities defined by SMC-D,
> including registering DMB, unregistering DMB and moving data.
> 
> Considering that there is no ism device on other servers expect
> IBM z13, 

Please use the wording 'on other architectures except s390'.
That is how IBM Z is referred to in the Linux kernel.


> the loopback device can be used as a dummy device to
> test SMC-D logic for the broad community.
> 
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> ---

Hello Wen Gu,

as the general design discussions are ongoing, I didn't
do a thorough review. But here are some general remarks
that you may want to consider for future versions.

I would propose to add a module parameter (default off) to enable
SMC-D loopback.

>  include/net/smc.h      |   1 +
>  net/smc/Makefile       |   2 +-
>  net/smc/af_smc.c       |  12 ++-
>  net/smc/smc_cdc.c      |   6 ++
>  net/smc/smc_cdc.h      |   1 +
>  net/smc/smc_loopback.c | 282 +++++++++++++++++++++++++++++++++++++++++++++++++
>  net/smc/smc_loopback.h |  59 +++++++++++
>  7 files changed, 361 insertions(+), 2 deletions(-)
>  create mode 100644 net/smc/smc_loopback.c
>  create mode 100644 net/smc/smc_loopback.h
> 

I am not convinced that this warrants a separate file.

[...]
>
> +}
> +
> +static int lo_add_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
> +{
> +	return 0;
> +}
> +
> +static int lo_del_vlan_id(struct smcd_dev *smcd, u64 vlan_id)
> +{
> +	return 0;
> +}
> +
> +static int lo_set_vlan_required(struct smcd_dev *smcd)
> +{
> +	return 0;
> +}
> +
> +static int lo_reset_vlan_required(struct smcd_dev *smcd)
> +{
> +	return 0;
> +}

The VLAN functions are only required for SMC-Dv1
Seems you want to provide v1 support for loopback?
May be nice for testing v1 VLAN support.
But then you need proper VLAN support.

[...]
> +
> +static u8 *lo_get_system_eid(void)
> +{
> +	return &LO_SYSTEM_EID.seid_string[0];
> +}
SEID is for the whole system not per device.
We probably need to register a different function
for each architecture.

> +
> +static u16 lo_get_chid(struct smcd_dev *smcd)
> +{
> +	return 0;
> +}
> +

Shouldn't this return 0xFFFF in your current concept?



