Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20B263605A
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238396AbiKWNsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237677AbiKWNrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:47:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ADE4387B;
        Wed, 23 Nov 2022 05:37:16 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AND82aJ021801;
        Wed, 23 Nov 2022 13:37:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VeTRbnVSUNF7M1ilNOoDbMlUYlDy4KO21rFM4qDPcZQ=;
 b=Y/ub/ERd2gZgnrWARP1qO0nvgguTPr/EeVab9FEU2nw/4MJ3NrrR3N40zcz1ulIZQZon
 ZKS4eKSXepJU2v6bhk+avcBieHY+MAD3rdkrvjwcjq9RYWomn4watcBnFDbRT1izBf3p
 h/iv9l9sV8Uw4hkxiS3bHaKTt9dnKqpmLzcjDmLf4mTIVem6sxf7S9BnJuA1lF9Zic1i
 fbGfANyXVmgVVgNKQ+Zu8X6dqZcEiKG/sTmUYGoSLo/kMBNvHB/dtolEtc9CdTGYWzIR
 X/77CAzECdk2yyL0dKuEYGzSA7R4+h4qWS6LAGAWhMZrMueQTs4ifFKXIbBHy/47O3J5 kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1152vp5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:37:12 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANDUV4n020308;
        Wed, 23 Nov 2022 13:37:11 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m1152vp2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:37:10 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ANDZxhL025206;
        Wed, 23 Nov 2022 13:37:03 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3kxps8v7pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:37:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ANDaxsh64291104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 13:36:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E40D4C046;
        Wed, 23 Nov 2022 13:36:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F07D44C050;
        Wed, 23 Nov 2022 13:36:58 +0000 (GMT)
Received: from [9.171.0.166] (unknown [9.171.0.166])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 13:36:58 +0000 (GMT)
Message-ID: <21f0ecf6-6154-78c0-7866-bfb4212ead99@linux.ibm.com>
Date:   Wed, 23 Nov 2022 14:36:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next] net/smc: Unbind smc control from tcp control
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
References: <20221123105830.17167-1-jaka@linux.ibm.com>
 <Y34NFlco13Y3LpOc@TonyMac-Alibaba>
From:   Jan Karcher <jaka@linux.ibm.com>
Organization: IBM - Network Linux on Z
In-Reply-To: <Y34NFlco13Y3LpOc@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zKYzg-X8gg-8xp3teLg09iFwbMLk-Wit
X-Proofpoint-GUID: 1A9AB9FzHlNhtLYk30H_g3bssSqbRBmN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211230097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/11/2022 13:07, Tony Lu wrote:
> On Wed, Nov 23, 2022 at 11:58:30AM +0100, Jan Karcher wrote:
>> In the past SMC used the values of tcp_{w|r}mem to create the send
>> buffer and RMB. We now have our own sysctl knobs to tune them without
>> influencing the TCP default.
>>
>> This patch removes the dependency on the TCP control by providing our
>> own initial values which aim for a low memory footprint.
>>
>> Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
>> Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
>> ---
>>   Documentation/networking/smc-sysctl.rst |  4 ++--
>>   net/smc/smc_core.h                      |  6 ++++--
>>   net/smc/smc_sysctl.c                    | 10 ++++++----
>>   3 files changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/Documentation/networking/smc-sysctl.rst b/Documentation/networking/smc-sysctl.rst
>> index 6d8acdbe9be1..a1c634d3690a 100644
>> --- a/Documentation/networking/smc-sysctl.rst
>> +++ b/Documentation/networking/smc-sysctl.rst
>> @@ -44,7 +44,7 @@ smcr_testlink_time - INTEGER
>>   
>>   wmem - INTEGER
>>   	Initial size of send buffer used by SMC sockets.
>> -	The default value inherits from net.ipv4.tcp_wmem[1].
>> +	The default value aims for a small memory footprint and is set to 16KiB.
>>   
>>   	The minimum value is 16KiB and there is no hard limit for max value, but
>>   	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
>> @@ -53,7 +53,7 @@ wmem - INTEGER
>>   
>>   rmem - INTEGER
>>   	Initial size of receive buffer (RMB) used by SMC sockets.
>> -	The default value inherits from net.ipv4.tcp_rmem[1].
>> +	The default value aims for a small memory footprint and is set to 64KiB.
>>   
>>   	The minimum value is 16KiB and there is no hard limit for max value, but
>>   	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
>> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
>> index 285f9bd8e232..67c3937f341d 100644
>> --- a/net/smc/smc_core.h
>> +++ b/net/smc/smc_core.h
>> @@ -206,8 +206,10 @@ struct smc_rtoken {				/* address/key of remote RMB */
>>   	u32			rkey;
>>   };
>>   
>> -#define SMC_BUF_MIN_SIZE	16384	/* minimum size of an RMB */
> 
> Hi Jan,
> 
> This patch inspired me that the min value of RMB and sndbuffer is 16KiB,
> it means that every connection costs 32KiB at least. It's still a large
> size for small environments, such as virtual machines or containers.
> 
> Also we have tested some cases with smaller buffer size (4KiB, with
> hacked code), it also shows good performance compared with larger buffer
> size.
> 
> So I am wondering that we could reduce the min value of RMB/send buffer,
> such as 4KiB.

That sounds interesting.
We did not think about reducing the minimum value.
One thing I'm wondering is if other OS like z/OS have own architectural 
limits or limits in general that we would have to consider in any way.
Let us look into it if we run into any trouble with lower memory.

- Jan

> 
> Cheers,
> Tony Lu
> 
>> -#define SMC_RMBE_SIZES		16	/* number of distinct RMBE sizes */
>> +#define SMC_SNDBUF_INIT_SIZE 16384 /* initial size of send buffer */
>> +#define SMC_RCVBUF_INIT_SIZE 65536 /* initial size of receive buffer */
>> +#define SMC_BUF_MIN_SIZE	 16384	/* minimum size of an RMB */
>> +#define SMC_RMBE_SIZES		 16	/* number of distinct RMBE sizes */
>>   /* theoretically, the RFC states that largest size would be 512K,
>>    * i.e. compressed 5 and thus 6 sizes (0..5), despite
>>    * struct smc_clc_msg_accept_confirm.rmbe_size being a 4 bit value (0..15)
>> diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
>> index b6f79fabb9d3..a63aa79d4856 100644
>> --- a/net/smc/smc_sysctl.c
>> +++ b/net/smc/smc_sysctl.c
>> @@ -19,8 +19,10 @@
>>   #include "smc_llc.h"
>>   #include "smc_sysctl.h"
>>   
>> -static int min_sndbuf = SMC_BUF_MIN_SIZE;
>> -static int min_rcvbuf = SMC_BUF_MIN_SIZE;
>> +static int initial_sndbuf	= SMC_SNDBUF_INIT_SIZE;
>> +static int initial_rcvbuf	= SMC_RCVBUF_INIT_SIZE;
>> +static int min_sndbuf		= SMC_BUF_MIN_SIZE;
>> +static int min_rcvbuf		= SMC_BUF_MIN_SIZE;
>>   
>>   static struct ctl_table smc_table[] = {
>>   	{
>> @@ -88,8 +90,8 @@ int __net_init smc_sysctl_net_init(struct net *net)
>>   	net->smc.sysctl_autocorking_size = SMC_AUTOCORKING_DEFAULT_SIZE;
>>   	net->smc.sysctl_smcr_buf_type = SMCR_PHYS_CONT_BUFS;
>>   	net->smc.sysctl_smcr_testlink_time = SMC_LLC_TESTLINK_DEFAULT_TIME;
>> -	WRITE_ONCE(net->smc.sysctl_wmem, READ_ONCE(net->ipv4.sysctl_tcp_wmem[1]));
>> -	WRITE_ONCE(net->smc.sysctl_rmem, READ_ONCE(net->ipv4.sysctl_tcp_rmem[1]));
>> +	WRITE_ONCE(net->smc.sysctl_wmem, initial_sndbuf);
>> +	WRITE_ONCE(net->smc.sysctl_rmem, initial_rcvbuf);
>>   
>>   	return 0;
>>   
>> -- 
>> 2.34.1
