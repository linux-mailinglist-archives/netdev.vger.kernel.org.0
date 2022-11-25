Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4246383EE
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 07:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiKYGPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 01:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKYGPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 01:15:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FCAC1;
        Thu, 24 Nov 2022 22:15:47 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AP5h0Id003807;
        Fri, 25 Nov 2022 06:15:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=N3vd2+yfVdAcYklo4siKzwM76aFM6Stlw+nNg5/+siI=;
 b=QgNC2n+OkSCK1pRIakq+yS+l1oVxok1w2waQDlSHYhhGs8ObN+ImZn8KHedbPFpQs0wv
 5xfxrKjz8zGv29s45+AazHipevks31396VAdRSn3FjXZG0pm/Y5gtHq8clrX8NIc3bZP
 L+d4eEESUfuCp4ok9BJadJRf+Q0pcM47klEtlHHuZKdUFC3mjN/GjIq+bafx0ISbdd4s
 8MpCxOLJriw4NUvuW6teRYes0T5FWos9OACktQnxh3QJzYSPSeSV5ys4lOHSQhs9feOW
 9T9ekgUOi2JyOBsQxb6kW6q2hXmw4YJqfaDXPdMcXEKwe1XxqSnlUkAFdF/B7c1b8aNo zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2qt38kxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 06:15:42 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AP5vPqM023509;
        Fri, 25 Nov 2022 06:15:42 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2qt38kxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 06:15:41 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AP65SQ7026346;
        Fri, 25 Nov 2022 06:15:40 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3kxps8xk2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 06:15:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AP6FaDU14549574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 06:15:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADC8811C04A;
        Fri, 25 Nov 2022 06:15:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B45111C052;
        Fri, 25 Nov 2022 06:15:36 +0000 (GMT)
Received: from [9.179.19.184] (unknown [9.179.19.184])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 06:15:36 +0000 (GMT)
Message-ID: <a6e57be8-48e3-acf7-8474-fc9b81cd6615@linux.ibm.com>
Date:   Fri, 25 Nov 2022 07:15:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] net/smc: Fix expected buffersizes and sync logic
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
References: <20221123104907.14624-1-jaka@linux.ibm.com>
 <Y34JxFWBdUxvLQb4@TonyMac-Alibaba>
 <40428548-59b9-379c-857c-172db92afc0c@linux.ibm.com>
 <Y34i8nmJIeIiFuOP@TonyMac-Alibaba>
 <f5237afd-d57b-f317-4263-31b4bb3d0d17@linux.ibm.com>
 <1a36b6ba-e7bb-6f2a-c460-cf158cb64b1d@linux.ibm.com>
From:   Jan Karcher <jaka@linux.ibm.com>
Organization: IBM - Network Linux on Z
In-Reply-To: <1a36b6ba-e7bb-6f2a-c460-cf158cb64b1d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iICXTpl3Nwdpj8lNoKH4TKCnhlTv5aQp
X-Proofpoint-ORIG-GUID: DyjxIkJykXfOox26e-76thqT16I3RpJc
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_02,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 impostorscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/11/2022 15:07, Alexandra Winter wrote:
> 
> 
> On 24.11.22 14:00, Alexandra Winter wrote:
>>
>>
[ ... ]>>>>> On Wed, Nov 23, 2022 at 11:49:07AM +0100, Jan Karcher wrote:
>>>>>> The fixed commit changed the expected behavior of buffersizes
>>>>>> set by the user using the setsockopt mechanism.
>>>>>> Before the fixed patch the logic for determining the buffersizes used
>>>>>> was the following:
>>>>>>
>>>>>> default  = net.ipv4.tcp_{w|r}mem[1]
> Jan, you explained to me: "the minima is 16Kib. This is enforced in smc_compress_bufsize
> which would move any value <= 16Kib into bucket 0 - which is 16KiB "
> net.ipv4.tcp_wmem[1] defaults to 8Kib. So in the default case (unchanged net.ipv4.tcp_wmem[1])
> the default for the send path is not net.ipv4.tcp_wmem[1]. Should be clarified here.

The default value is still set to the net.ipv4.tcp_{w|r}mem[1]. This is 
a *very* top level overview about what is happening and *not* a 
documentation.
I don't really want to explain the full code flow here.

What we still should do - as Tony aggreed on - is documenting the SMC 
behavior. This is a follow up on my list.

>>>>>> sockopt  = the setsockopt mechanism
>>>>>> val      = the value assigned in default or via setsockopt
>>>>>> sk_buf   = short for sk_{snd|rcv}buf
>>>>>> real_buf = the real size of the buffer (sk_buf_size in __smc_buf_create)
>>>>>>
>>>>>>     exposed   | net/core/sock.c  |    af_smc.c    |  smc_core.c
>>>>>>               |                  |                |
>>>>>> +---------+ |                  | +------------+ | +-------------------+
>>>>>> | default |----------------------| sk_buf=val |---| real_buf=sk_buf/2 |
>>>>>> +---------+ |                  | +------------+ | +-------------------+
>>>>>>               |                  |                |    ^
>>>>>>               |                  |                |    |
>>>>>> +---------+ | +--------------+ |                |    |
>>>>>> | sockopt |---| sk_buf=val*2 |-----------------------|
>>>>>> +---------+ | +--------------+ |                |
>>>>>>               |                  |                |
>>>>>>
>>>>>> The fixed patch introduced a dedicated sysctl for smc
>>>>>> and removed the /2 in smc_core.c resulting in the following flow:
>>>>>>
>>>>>> default  = net.smc.{w|r}mem (which defaults to net.ipv4.tcp_{w|r}mem[1])
>>>>>> sockopt  = the setsockopt mechanism
>>>>>> val      = the value assigned in default or via setsockopt
>>>>>> sk_buf   = short for sk_{snd|rcv}buf
>>>>>> real_buf = the real size of the buffer (sk_buf_size in __smc_buf_create)
>>>>>>
>>>>>>     exposed   | net/core/sock.c  |    af_smc.c    |  smc_core.c
>>>>>>               |                  |                |
>>>>>> +---------+ |                  | +------------+ | +-----------------+
>>>>>> | default |----------------------| sk_buf=val |---| real_buf=sk_buf |
>>>>>> +---------+ |                  | +------------+ | +-----------------+
>>>>>>               |                  |                |    ^
>>>>>>               |                  |                |    |
>>>>>> +---------+ | +--------------+ |                |    |
>>>>>> | sockopt |---| sk_buf=val*2 |-----------------------|
>>>>>> +---------+ | +--------------+ |                |
>>>>>>               |                  |                |
>>>>>>
>>>>>> This would result in double of memory used for existing configurations
>>>>>> that are using setsockopt.
>>>>>
>>>>> Firstly, thanks for your detailed diagrams :-)
>>>>>
>>>>> And the original decision to use user-provided values rather than
>>>>> value/2 to follow the instructions of the socket manual [1].
>>>>>
>>>>>     SO_RCVBUF
>>>>>            Sets or gets the maximum socket receive buffer in bytes.
>>>>>            The kernel doubles this value (to allow space for
>>>>>            bookkeeping overhead) when it is set using setsockopt(2),
>>>>>            and this doubled value is returned by getsockopt(2).  The
>>>>>            default value is set by the
>>>>>            /proc/sys/net/core/rmem_default file, and the maximum
>>>>>            allowed value is set by the /proc/sys/net/core/rmem_max
>>>>>            file.  The minimum (doubled) value for this option is 256.
>>>>>
>>>>> [1] https://man7.org/linux/man-pages/man7/socket.7.html
>>>>>
>>>>> The user of SMC should know that setsockopt() with SO_{RCV|SND}BUF will
>>>>
>>>> I totally agree that an educated user of SMC should know about that behavior
>>>> if they decide to use it.
>>>> We do provide our users preload libraries where they can pass preferred
>>>> buffersizes via arguments and we handle the Sockopts for them.
>>>>
>>>>> double the values in kernel, and getsockopt() will return the doubled
>>>>> values. So that they should use half of the values which are passed to
>>>>> setsockopt(). The original patch tries to make things easier in SMC and
>>>>> let user-space to handle them following the socket manual.
>>>>>
>>>>>> SMC historically decided to use the explicit value given by the user
>>>>>> to allocate the memory. This is why we used the /2 in smc_core.c.
>>>>>> That logic was not applied to the default value.
>>>>>
>>>>> Yep, let back to the patch which introduced smc_{w|r}mem knobs, it's a
>>>>> trade-off to follow original logic of SMC, or follow the socket manual.
>>>>> We decides to follow the instruction of manuals in the end.
>>>>
>>>> I understand the point. I spend a lot of time trying to decide what to do.
>>>>
>>>> Since it was an intentional decision to not follow the general socket
>>>> option, and we do not have anyone complaining we do not really have a reason
>>>> to change it.
>>>> Changing it means that users with existing configurations would have to
>>>> change their configs on an update or suddenly expect double the memory
>>>> consumption.
>>>> That's why we in the end preffered to stay with the current logic.
>>>
>>> I can't agree with you more with the points to follow the historic logic
>>> and not break the user-space applications.
>>>
>>>> I'm thinking that maybe - if we stay with the historic logic - we should
>>>> document that desicion somewhere. So that in the future, if a user that
>>>> expects the man page behavior, has a way to understand what SMC is doing.
>>>> What do oyu think?
>>>
>>> Yep, we _really_ need to document it if we change the convention.
>>> Actually, I spent a lot of time to find the history about the logic of
>>> buffer (/2 and *2) in SMC. So I'm really in favor of adding
>>> documentation, at least code comments to help others to understand them.
>>>
>>> Cheers,
>>> Tony Lu
>> Iiuc you are changing the default values in this a patch and your other patch:
>> Default values for real_buf for send and receive:
>>
>> before 0227f058aa29 ("net/smc: Unbind r/w buffer size from clcsock and make them tunable")
>>      real_buf=net.ipv4.tcp_{w|r}mem[1]/2   send: 8k  recv: 64k
>        see above: 			    send: 16k recv: 64k
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
> See above, I stand corrected. However this patch fixes/restores the buffersize
> for setsockopt, but not for the default recieve path.
> Could you please clarify that in the title and description?
> 

I am trying to keep the commit title as crisp as possible while 
providing enough information and set the context in the commit message:

"The fixed commit changed the expected behavior of buffersizes set by 
the user using the setsockopt mechanism."

  + There is now a whole e-mail thread to consult in case of any further 
questions.

Thank you for your comments
- Jan

> Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
>>>   
>>>> - Jan
>>>>
>>>>>
>>>>> Cheers,
>>>>> Tony Lu
>>>>>
>>>>>> Since we now have our own sysctl, which is also exposed to the user,
>>>>>> we should sync the logic in a way that both values are the real value
>>>>>> used by our code and shown by smc_stats. To achieve this this patch
>>>>>> changes the behavior to:
>>>>>>
>>>>>> default  = net.smc.{w|r}mem (which defaults to net.ipv4.tcp_{w|r}mem[1])
>>>>>> sockopt  = the setsockopt mechanism
>>>>>> val      = the value assigned in default or via setsockopt
>>>>>> sk_buf   = short for sk_{snd|rcv}buf
>>>>>> real_buf = the real size of the buffer (sk_buf_size in __smc_buf_create)
>>>>>>
>>>>>>     exposed   | net/core/sock.c  |    af_smc.c     |  smc_core.c
>>>>>>               |                  |                 |
>>>>>> +---------+ |                  | +-------------+ | +-----------------+
>>>>>> | default |----------------------| sk_buf=val*2|---|real_buf=sk_buf/2|
>>>>>> +---------+ |                  | +-------------+ | +-----------------+
>>>>>>               |                  |                 |    ^
>>>>>>               |                  |                 |    |
>>>>>> +---------+ | +--------------+ |                 |    |
>>>>>> | sockopt |---| sk_buf=val*2 |------------------------|
>>>>>> +---------+ | +--------------+ |                 |
>>>>>>               |                  |                 |
>>>>>>
>>>>>> This way both paths follow the same pattern and the expected behavior
>>>>>> is re-established.
>>>>>>
>>>>>> Fixes: 0227f058aa29 ("net/smc: Unbind r/w buffer size from clcsock and make them tunable")
>>>>>> Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
>>>>>> Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
>>>>>> ---
>>>>>>    net/smc/af_smc.c   | 9 +++++++--
>>>>>>    net/smc/smc_core.c | 8 ++++----
>>>>>>    2 files changed, 11 insertions(+), 6 deletions(-)
>>>>>>
>>>>>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>>>>>> index 036532cf39aa..a8c84e7bac99 100644
>>>>>> --- a/net/smc/af_smc.c
>>>>>> +++ b/net/smc/af_smc.c
>>>>>> @@ -366,6 +366,7 @@ static void smc_destruct(struct sock *sk)
>>>>>>    static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
>>>>>>    				   int protocol)
>>>>>>    {
>>>>>> +	int buffersize_without_overhead;
>>>>>>    	struct smc_sock *smc;
>>>>>>    	struct proto *prot;
>>>>>>    	struct sock *sk;
>>>>>> @@ -379,8 +380,12 @@ static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
>>>>>>    	sk->sk_state = SMC_INIT;
>>>>>>    	sk->sk_destruct = smc_destruct;
>>>>>>    	sk->sk_protocol = protocol;
>>>>>> -	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(net->smc.sysctl_wmem));
>>>>>> -	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(net->smc.sysctl_rmem));
>>>>>> +	buffersize_without_overhead =
>>>>>> +		min_t(int, READ_ONCE(net->smc.sysctl_wmem), INT_MAX / 2);
>>>>>> +	WRITE_ONCE(sk->sk_sndbuf, buffersize_without_overhead * 2);
>>>>>> +	buffersize_without_overhead =
>>>>>> +		min_t(int, READ_ONCE(net->smc.sysctl_rmem), INT_MAX / 2);
>>>>>> +	WRITE_ONCE(sk->sk_rcvbuf, buffersize_without_overhead * 2);
>>>>>>    	smc = smc_sk(sk);
>>>>>>    	INIT_WORK(&smc->tcp_listen_work, smc_tcp_listen_work);
>>>>>>    	INIT_WORK(&smc->connect_work, smc_connect_work);
>>>>>> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>>>>>> index 00fb352c2765..36850a2ae167 100644
>>>>>> --- a/net/smc/smc_core.c
>>>>>> +++ b/net/smc/smc_core.c
>>>>>> @@ -2314,10 +2314,10 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
>>>>>>    	if (is_rmb)
>>>>>>    		/* use socket recv buffer size (w/o overhead) as start value */
>>>>>> -		sk_buf_size = smc->sk.sk_rcvbuf;
>>>>>> +		sk_buf_size = smc->sk.sk_rcvbuf / 2;
>>>>>>    	else
>>>>>>    		/* use socket send buffer size (w/o overhead) as start value */
>>>>>> -		sk_buf_size = smc->sk.sk_sndbuf;
>>>>>> +		sk_buf_size = smc->sk.sk_sndbuf / 2;
>>>>>>    	for (bufsize_short = smc_compress_bufsize(sk_buf_size, is_smcd, is_rmb);
>>>>>>    	     bufsize_short >= 0; bufsize_short--) {
>>>>>> @@ -2376,7 +2376,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
>>>>>>    	if (is_rmb) {
>>>>>>    		conn->rmb_desc = buf_desc;
>>>>>>    		conn->rmbe_size_short = bufsize_short;
>>>>>> -		smc->sk.sk_rcvbuf = bufsize;
>>>>>> +		smc->sk.sk_rcvbuf = bufsize * 2;
>>>>>>    		atomic_set(&conn->bytes_to_rcv, 0);
>>>>>>    		conn->rmbe_update_limit =
>>>>>>    			smc_rmb_wnd_update_limit(buf_desc->len);
>>>>>> @@ -2384,7 +2384,7 @@ static int __smc_buf_create(struct smc_sock *smc, bool is_smcd, bool is_rmb)
>>>>>>    			smc_ism_set_conn(conn); /* map RMB/smcd_dev to conn */
>>>>>>    	} else {
>>>>>>    		conn->sndbuf_desc = buf_desc;
>>>>>> -		smc->sk.sk_sndbuf = bufsize;
>>>>>> +		smc->sk.sk_sndbuf = bufsize * 2;
>>>>>>    		atomic_set(&conn->sndbuf_space, bufsize);
>>>>>>    	}
>>>>>>    	return 0;
>>>>>> -- 
>>>>>> 2.34.1
