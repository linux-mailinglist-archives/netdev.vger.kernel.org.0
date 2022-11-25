Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5318A638415
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 07:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiKYGiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 01:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiKYGiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 01:38:06 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3781BE83;
        Thu, 24 Nov 2022 22:38:04 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AP5r73C035486;
        Fri, 25 Nov 2022 06:37:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=23dUI5pNjTtKiL4U6xObkqU2qnR4bEEtsWxks2x3hM8=;
 b=F3bxG581cEBBJOQMDQ8HZ34pby/5Ldp5Trha60tWuXSWgdo+bn6aZeY6RrKa8Ra6lens
 bD/FZzAF8WEPVbPeRx0BBb1bIpoE0u1ZvzEmu0cDxYwk3y5Xc32cg/WRIFIA46DzZ73w
 TVBADxRxM63xQKKnNOq+r4dZMPxthwDvK//NRHfi54XIDMp9KFMIz7FUCV+KY27Vg54U
 oAlPfOyk4FHdzIAmIwkynUj+kgCaSai2rysvH0LhGIGGyVxcklqCb0n6L2kJdpzSUrVh
 q74kkE6Py1ssrAwjzvPQXtO/PW84fc0ZmJ5ZRQyUwhZbWaaiE1m57fLg2t3V27z6u8lZ HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2qy0gupd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 06:37:58 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AP6RJjH032661;
        Fri, 25 Nov 2022 06:37:58 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2qy0gunq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 06:37:58 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AP6Z69B001947;
        Fri, 25 Nov 2022 06:37:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3kxps8pjwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 06:37:56 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AP6bqmr22938094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 06:37:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4A3411C050;
        Fri, 25 Nov 2022 06:37:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1705D11C04A;
        Fri, 25 Nov 2022 06:37:52 +0000 (GMT)
Received: from [9.179.19.184] (unknown [9.179.19.184])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 06:37:52 +0000 (GMT)
Message-ID: <b0eeaed9-138f-6615-a240-8122e321edfd@linux.ibm.com>
Date:   Fri, 25 Nov 2022 07:37:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next] net/smc: Unbind smc control from tcp control
To:     Tony Lu <tonylu@linux.alibaba.com>,
        Alexandra Winter <wintera@linux.ibm.com>
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
 <245a7c52-ee18-56c2-7584-b75b0af1491f@linux.ibm.com>
 <Y3+mpjGhG1+JwBjN@TonyMac-Alibaba>
From:   Jan Karcher <jaka@linux.ibm.com>
Organization: IBM - Network Linux on Z
In-Reply-To: <Y3+mpjGhG1+JwBjN@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EZs-A17CaH_DdNJZVXjjUD75o8vovYoK
X-Proofpoint-ORIG-GUID: KqXz8cACpZPof83mTDqm8RWe-b6dlLOc
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_02,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 adultscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/11/2022 18:15, Tony Lu wrote:
> On Thu, Nov 24, 2022 at 02:00:35PM +0100, Alexandra Winter wrote:
>>
>>
>> On 23.11.22 12:25, Tony Lu wrote:
>>> On Wed, Nov 23, 2022 at 12:19:19PM +0100, Jan Karcher wrote:
>>>>
>>>>
>>>> On 23/11/2022 12:13, Tony Lu wrote:
>>>>> On Wed, Nov 23, 2022 at 11:58:30AM +0100, Jan Karcher wrote:
>>>>>> In the past SMC used the values of tcp_{w|r}mem to create the send
>>>>>> buffer and RMB. We now have our own sysctl knobs to tune them without
>>>>>> influencing the TCP default.
>>>>>>
>>>>>> This patch removes the dependency on the TCP control by providing our
>>>>>> own initial values which aim for a low memory footprint.
>>>>>
>>>>> +1, before introducing sysctl knobs of SMC, we were going to get rid of
>>>>> TCP and have SMC own values. Now this does it, So I very much agree with
>>>>> this.
>>>>>
>> Iiuc you are changing the default values in this a patch and your other patch:
>> Default values for real_buf for send and receive:
>>
>> before 0227f058aa29 ("net/smc: Unbind r/w buffer size from clcsock and make them tunable")
>>      real_buf=net.ipv4.tcp_{w|r}mem[1]/2   send: 8k  recv: 64k
>>      
>> after 0227f058aa29 ("net/smc: Unbind r/w buffer size from clcsock and make them tunable")
>> real_buf=net.ipv4.tcp_{w|r}mem[1]   send: 16k (16*1024) recv: 128k (131072)
>>
>> after net/smc: Fix expected buffersizes and sync logic
>> real_buf=net.ipv4.tcp_{w|r}mem[1]   send: 16k (16*1024) recv: 128k (131072)
>>
>> after net/smc: Unbind smc control from tcp control
>> real_buf=SMC_*BUF_INIT_SIZE   send: 16k (16384) recv: 64k (65536)
>>
>> If my understanding is correct, then I nack this.
>> Defaults should be restored to the values before 0227f058aa29.
>> Otherwise users will notice a change in memory usage that needs to
>> be avoided or announced more explicitely. (and don't change them twice)
> 
> The logic of buffer size are changed indeed. I very much agree that do
> not break the user space. I am wondering that the values of user-defined
> configurations should be the ABI/API compatibilities.
> 
> Actually before the patch of adding sysctls of buffers, the values of
> buffer size is bind to tcp_{w|r}mem[1] tightly. The people who changed
> the value of tcp_{w|r}mem[1] may break the convention of SMC by
> accident.

That's true. I think we cannot change our buffers without risking to 
break some user configuration. Which leaves us with the question if we 
value the benefit of having SMC uncoupled higher then the breaking of 
those configurations.
For me i would answer that with a yes with the following reasoning:
We do this to be more flexible and it is a one time action. So we do not 
expect to break it again.
But we should be aware of it and communicate it clearly, which also 
includes the next point:

> 
> After getting rid of tcp_{w|r}mem[1], SMC have its own sysctl for
> buffer size. I do think this a really good chance for us to determined
> the reasonable values of buffers and document them in a place that
> people are easy to learn, the logic of {set|get}sockopt in SMC are
> different from socket manual. What do you think?

Indeed. I think this is a reasonable approach for the future. I'm 
wondering - and maybe you have some experience/opinion ther Tony - where 
we should documen such things. I mean there are RFCs relating to SMC [1] 
we have IBM documentation [2] and there is a documentation file 
regarding our control in the kernel tree [3].

Having that many different places where information is stored inevitably 
means that someone forgets something at one point which results in 
parallel evolution which i would like to prevent.
So please share your thoughts on this!

[1] https://www.rfc-editor.org/rfc/rfc7609
[2] 
https://www.ibm.com/docs/en/linux-on-systems?topic=n-smc-protocol-support
[3] 
https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux/+/refs/heads/master/Documentation/networking/smc-sysctl.rst

Thank You
- Jan
> 
> Cheers,
> Tony Lu
> 
>>
>>>>>>
>>>>>> Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
>>>>>> Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
>>>>>> ---
>>>>>>    Documentation/networking/smc-sysctl.rst |  4 ++--
>>>>>>    net/smc/smc_core.h                      |  6 ++++--
>>>>>>    net/smc/smc_sysctl.c                    | 10 ++++++----
>>>>>>    3 files changed, 12 insertions(+), 8 deletions(-)
>>>>>>
>>>>>> diff --git a/Documentation/networking/smc-sysctl.rst b/Documentation/networking/smc-sysctl.rst
>>>>>> index 6d8acdbe9be1..a1c634d3690a 100644
>>>>>> --- a/Documentation/networking/smc-sysctl.rst
>>>>>> +++ b/Documentation/networking/smc-sysctl.rst
>>>>>> @@ -44,7 +44,7 @@ smcr_testlink_time - INTEGER
>>>>>>    wmem - INTEGER
>>>>>>    	Initial size of send buffer used by SMC sockets.
>>>>>> -	The default value inherits from net.ipv4.tcp_wmem[1].
>>>>>> +	The default value aims for a small memory footprint and is set to 16KiB.
>>>>>>    	The minimum value is 16KiB and there is no hard limit for max value, but
>>>>>>    	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
>>>>>> @@ -53,7 +53,7 @@ wmem - INTEGER
>>>>>>    rmem - INTEGER
>>>>>>    	Initial size of receive buffer (RMB) used by SMC sockets.
>>>>>> -	The default value inherits from net.ipv4.tcp_rmem[1].
>>>>>> +	The default value aims for a small memory footprint and is set to 64KiB.
>>>>>>    	The minimum value is 16KiB and there is no hard limit for max value, but
>>>>>>    	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
>>>>>> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
>>>>>> index 285f9bd8e232..67c3937f341d 100644
>>>>>> --- a/net/smc/smc_core.h
>>>>>> +++ b/net/smc/smc_core.h
>>>>>> @@ -206,8 +206,10 @@ struct smc_rtoken {				/* address/key of remote RMB */
>>>>>>    	u32			rkey;
>>>>>>    };
>>>>>> -#define SMC_BUF_MIN_SIZE	16384	/* minimum size of an RMB */
>>>>>> -#define SMC_RMBE_SIZES		16	/* number of distinct RMBE sizes */
>>>>>> +#define SMC_SNDBUF_INIT_SIZE 16384 /* initial size of send buffer */
>>>>>> +#define SMC_RCVBUF_INIT_SIZE 65536 /* initial size of receive buffer */
>>>>>> +#define SMC_BUF_MIN_SIZE	 16384	/* minimum size of an RMB */
>>>>>> +#define SMC_RMBE_SIZES		 16	/* number of distinct RMBE sizes */
>>>>>>    /* theoretically, the RFC states that largest size would be 512K,
>>>>>>     * i.e. compressed 5 and thus 6 sizes (0..5), despite
>>>>>>     * struct smc_clc_msg_accept_confirm.rmbe_size being a 4 bit value (0..15)
>>>>>> diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
>>>>>> index b6f79fabb9d3..a63aa79d4856 100644
>>>>>> --- a/net/smc/smc_sysctl.c
>>>>>> +++ b/net/smc/smc_sysctl.c
>>>>>> @@ -19,8 +19,10 @@
>>>>>>    #include "smc_llc.h"
>>>>>>    #include "smc_sysctl.h"
>>>>>> -static int min_sndbuf = SMC_BUF_MIN_SIZE;
>>>>>> -static int min_rcvbuf = SMC_BUF_MIN_SIZE;
>>>>>> +static int initial_sndbuf	= SMC_SNDBUF_INIT_SIZE;
>>>>>> +static int initial_rcvbuf	= SMC_RCVBUF_INIT_SIZE;
>>>>>> +static int min_sndbuf		= SMC_BUF_MIN_SIZE;
>>>>>> +static int min_rcvbuf		= SMC_BUF_MIN_SIZE;
>> Broken formatting
>>>>>>    static struct ctl_table smc_table[] = {
>>>>>>    	{
>>>>>> @@ -88,8 +90,8 @@ int __net_init smc_sysctl_net_init(struct net *net)
>>>>>>    	net->smc.sysctl_autocorking_size = SMC_AUTOCORKING_DEFAULT_SIZE;
>>>>>>    	net->smc.sysctl_smcr_buf_type = SMCR_PHYS_CONT_BUFS;
>>>>>>    	net->smc.sysctl_smcr_testlink_time = SMC_LLC_TESTLINK_DEFAULT_TIME;
>>>>>> -	WRITE_ONCE(net->smc.sysctl_wmem, READ_ONCE(net->ipv4.sysctl_tcp_wmem[1]));
>>>>>> -	WRITE_ONCE(net->smc.sysctl_rmem, READ_ONCE(net->ipv4.sysctl_tcp_rmem[1]));
>>>>>> +	WRITE_ONCE(net->smc.sysctl_wmem, initial_sndbuf);
>>>>>> +	WRITE_ONCE(net->smc.sysctl_rmem, initial_rcvbuf);
>>>>>
>>>>> Maybe we can use SMC_{SND|RCV}BUF_INIT_SIZE macro directly, instead of
>>>>> new variables.
>>>>
>>>> The reason i created the new variables is that min_{snd|rcv}buf also have
>>>> their own variables. I know it is not needed but thought it was cleaner.
>>>> If you have a strong opinion on using the value directly i can change it.
>>>> Please let me know if you want it changed.
>>>
>>> Yep, it's okay for me to use variables or macros. Just let it be.
>> I think it's better coding style to use the macros instead of unneccessary variables.
>> At least the variables could be defined as const.
>>>
>>> Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
>>>
>>> Cheers,
>>> Tony Lu
>>>
>>>>
>>>> - Jan
>>>>>
>>>>> Cheers,
>>>>> Tony Lu
>>>>>
>>>>>>    	return 0;
>>>>>> -- 
>>>>>> 2.34.1
