Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799D4637998
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 14:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiKXNBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 08:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKXNA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 08:00:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C4E10FEC0;
        Thu, 24 Nov 2022 05:00:47 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AOBw9iL002548;
        Thu, 24 Nov 2022 13:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LDFmVqfYp04sON/Yw628DZQ3An/zJJU7poje5q9apf4=;
 b=fnv8MRRFkJW0cK4dDtpA/vDNI3cO6tofzaLJx1c8Qwo0FzVk9oVaSLQT66/YHrSC1ewH
 yddLfWAlvGejCG6hpLzWCvpcd80qon7Q4T480LXN9fIsuVoEJMWc8HKc97uJueFUImc3
 uxZA1Jv1ESikzh68mwol8qv/kDg7MzE3fE7F+IoLNPC7MQIO3d3sDfx4/W71x5u/tFKe
 szZLyfqdkvyKQLfQGvyX7lR9FRJmJ3GEg5o6+s1kBT6hgj5jN71xbjWOGJaZu1/gOu5D
 p58s8gHUXNfROVwFHX+IR2fQm2nOtCdp0lMGdxzUuv0NOoCK/yoIXHsSYDQcMl5pogEj mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100tvq6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 13:00:42 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AOBoJc9013674;
        Thu, 24 Nov 2022 13:00:42 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m100tvq4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 13:00:41 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AOCpM7S009208;
        Thu, 24 Nov 2022 13:00:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3kxpdj079a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 13:00:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AOCsJCj4784696
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 12:54:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4985052057;
        Thu, 24 Nov 2022 13:00:36 +0000 (GMT)
Received: from [9.152.224.55] (unknown [9.152.224.55])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E73C45204E;
        Thu, 24 Nov 2022 13:00:35 +0000 (GMT)
Message-ID: <245a7c52-ee18-56c2-7584-b75b0af1491f@linux.ibm.com>
Date:   Thu, 24 Nov 2022 14:00:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH net-next] net/smc: Unbind smc control from tcp control
To:     Tony Lu <tonylu@linux.alibaba.com>,
        Jan Karcher <jaka@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
References: <20221123105830.17167-1-jaka@linux.ibm.com>
 <Y34Aa3MXGqyd+nlQ@TonyMac-Alibaba>
 <4c5d74f8-c5de-d50c-0682-4435de21660a@linux.ibm.com>
 <Y34DI815COX7+V0x@TonyMac-Alibaba>
Content-Language: en-US
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <Y34DI815COX7+V0x@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R8cVWfSczB6iwjiLI5rNlkSC8ZGsCdVZ
X-Proofpoint-ORIG-GUID: jhX_1gD4s9gmiPW5gdmqWKVO8qDo1Rpo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_09,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23.11.22 12:25, Tony Lu wrote:
> On Wed, Nov 23, 2022 at 12:19:19PM +0100, Jan Karcher wrote:
>>
>>
>> On 23/11/2022 12:13, Tony Lu wrote:
>>> On Wed, Nov 23, 2022 at 11:58:30AM +0100, Jan Karcher wrote:
>>>> In the past SMC used the values of tcp_{w|r}mem to create the send
>>>> buffer and RMB. We now have our own sysctl knobs to tune them without
>>>> influencing the TCP default.
>>>>
>>>> This patch removes the dependency on the TCP control by providing our
>>>> own initial values which aim for a low memory footprint.
>>>
>>> +1, before introducing sysctl knobs of SMC, we were going to get rid of
>>> TCP and have SMC own values. Now this does it, So I very much agree with
>>> this.
>>>
Iiuc you are changing the default values in this a patch and your other patch:
Default values for real_buf for send and receive:

before 0227f058aa29 ("net/smc: Unbind r/w buffer size from clcsock and make them tunable")
    real_buf=net.ipv4.tcp_{w|r}mem[1]/2   send: 8k  recv: 64k 
    
after 0227f058aa29 ("net/smc: Unbind r/w buffer size from clcsock and make them tunable")
real_buf=net.ipv4.tcp_{w|r}mem[1]   send: 16k (16*1024) recv: 128k (131072) 

after net/smc: Fix expected buffersizes and sync logic
real_buf=net.ipv4.tcp_{w|r}mem[1]   send: 16k (16*1024) recv: 128k (131072) 

after net/smc: Unbind smc control from tcp control
real_buf=SMC_*BUF_INIT_SIZE   send: 16k (16384) recv: 64k (65536)

If my understanding is correct, then I nack this. 
Defaults should be restored to the values before 0227f058aa29.
Otherwise users will notice a change in memory usage that needs to
be avoided or announced more explicitely. (and don't change them twice)

>>>>
>>>> Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
>>>> Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
>>>> ---
>>>>   Documentation/networking/smc-sysctl.rst |  4 ++--
>>>>   net/smc/smc_core.h                      |  6 ++++--
>>>>   net/smc/smc_sysctl.c                    | 10 ++++++----
>>>>   3 files changed, 12 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/Documentation/networking/smc-sysctl.rst b/Documentation/networking/smc-sysctl.rst
>>>> index 6d8acdbe9be1..a1c634d3690a 100644
>>>> --- a/Documentation/networking/smc-sysctl.rst
>>>> +++ b/Documentation/networking/smc-sysctl.rst
>>>> @@ -44,7 +44,7 @@ smcr_testlink_time - INTEGER
>>>>   wmem - INTEGER
>>>>   	Initial size of send buffer used by SMC sockets.
>>>> -	The default value inherits from net.ipv4.tcp_wmem[1].
>>>> +	The default value aims for a small memory footprint and is set to 16KiB.
>>>>   	The minimum value is 16KiB and there is no hard limit for max value, but
>>>>   	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
>>>> @@ -53,7 +53,7 @@ wmem - INTEGER
>>>>   rmem - INTEGER
>>>>   	Initial size of receive buffer (RMB) used by SMC sockets.
>>>> -	The default value inherits from net.ipv4.tcp_rmem[1].
>>>> +	The default value aims for a small memory footprint and is set to 64KiB.
>>>>   	The minimum value is 16KiB and there is no hard limit for max value, but
>>>>   	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
>>>> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
>>>> index 285f9bd8e232..67c3937f341d 100644
>>>> --- a/net/smc/smc_core.h
>>>> +++ b/net/smc/smc_core.h
>>>> @@ -206,8 +206,10 @@ struct smc_rtoken {				/* address/key of remote RMB */
>>>>   	u32			rkey;
>>>>   };
>>>> -#define SMC_BUF_MIN_SIZE	16384	/* minimum size of an RMB */
>>>> -#define SMC_RMBE_SIZES		16	/* number of distinct RMBE sizes */
>>>> +#define SMC_SNDBUF_INIT_SIZE 16384 /* initial size of send buffer */
>>>> +#define SMC_RCVBUF_INIT_SIZE 65536 /* initial size of receive buffer */
>>>> +#define SMC_BUF_MIN_SIZE	 16384	/* minimum size of an RMB */
>>>> +#define SMC_RMBE_SIZES		 16	/* number of distinct RMBE sizes */
>>>>   /* theoretically, the RFC states that largest size would be 512K,
>>>>    * i.e. compressed 5 and thus 6 sizes (0..5), despite
>>>>    * struct smc_clc_msg_accept_confirm.rmbe_size being a 4 bit value (0..15)
>>>> diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
>>>> index b6f79fabb9d3..a63aa79d4856 100644
>>>> --- a/net/smc/smc_sysctl.c
>>>> +++ b/net/smc/smc_sysctl.c
>>>> @@ -19,8 +19,10 @@
>>>>   #include "smc_llc.h"
>>>>   #include "smc_sysctl.h"
>>>> -static int min_sndbuf = SMC_BUF_MIN_SIZE;
>>>> -static int min_rcvbuf = SMC_BUF_MIN_SIZE;
>>>> +static int initial_sndbuf	= SMC_SNDBUF_INIT_SIZE;
>>>> +static int initial_rcvbuf	= SMC_RCVBUF_INIT_SIZE;
>>>> +static int min_sndbuf		= SMC_BUF_MIN_SIZE;
>>>> +static int min_rcvbuf		= SMC_BUF_MIN_SIZE;
Broken formatting
>>>>   static struct ctl_table smc_table[] = {
>>>>   	{
>>>> @@ -88,8 +90,8 @@ int __net_init smc_sysctl_net_init(struct net *net)
>>>>   	net->smc.sysctl_autocorking_size = SMC_AUTOCORKING_DEFAULT_SIZE;
>>>>   	net->smc.sysctl_smcr_buf_type = SMCR_PHYS_CONT_BUFS;
>>>>   	net->smc.sysctl_smcr_testlink_time = SMC_LLC_TESTLINK_DEFAULT_TIME;
>>>> -	WRITE_ONCE(net->smc.sysctl_wmem, READ_ONCE(net->ipv4.sysctl_tcp_wmem[1]));
>>>> -	WRITE_ONCE(net->smc.sysctl_rmem, READ_ONCE(net->ipv4.sysctl_tcp_rmem[1]));
>>>> +	WRITE_ONCE(net->smc.sysctl_wmem, initial_sndbuf);
>>>> +	WRITE_ONCE(net->smc.sysctl_rmem, initial_rcvbuf);
>>>
>>> Maybe we can use SMC_{SND|RCV}BUF_INIT_SIZE macro directly, instead of
>>> new variables.
>>
>> The reason i created the new variables is that min_{snd|rcv}buf also have
>> their own variables. I know it is not needed but thought it was cleaner.
>> If you have a strong opinion on using the value directly i can change it.
>> Please let me know if you want it changed.
> 
> Yep, it's okay for me to use variables or macros. Just let it be.
I think it's better coding style to use the macros instead of unneccessary variables.
At least the variables could be defined as const.
> 
> Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
> 
> Cheers,
> Tony Lu
> 
>>
>> - Jan
>>>
>>> Cheers,
>>> Tony Lu
>>>
>>>>   	return 0;
>>>> -- 
>>>> 2.34.1
