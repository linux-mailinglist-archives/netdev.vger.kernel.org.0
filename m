Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C6B560B0E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 22:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiF2UbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 16:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiF2UbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 16:31:04 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6085934BA1;
        Wed, 29 Jun 2022 13:31:03 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25TKKxe4012483;
        Wed, 29 Jun 2022 20:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Pj0bPZ/Lp9qBnUf08mWpe+cFqgQb1bLxM1/+EpPGJ9E=;
 b=BHsxpdr3fGeP3domTIqa/nQNCXCqkU5gd+OFh+qw/UkMiyMHx0TNa8XANp0OJPVMKu0w
 1nUPZW3ZukGSIy56Vw/MKWW4Vk2GBdojUKHGvhk54DV5w+lFfWKl5SFanI8teOSEp9BY
 Xk/pkRtOG20MnfECZ3EHODCFWbD/dMEa4/y3f6O1pO6AECRfBus2GcSSRavCD2Yuihih
 JPqhodH7wA7X19MkFfnqKSAnhxEPOVZhb5k5OdSX/kivvmEYXej50EqtfjGcU2shE8uL
 URm2vANahEfKyCbWeZ1nENssx9LuJDF3Pr2X6n5Q0aE3OQJ1TI0LjEMDaUN5PZPgoacd Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h0wpk0865-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 20:30:58 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25TKLbTq014021;
        Wed, 29 Jun 2022 20:30:58 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h0wpk084r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 20:30:58 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25TKM1s0025507;
        Wed, 29 Jun 2022 20:30:25 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03wdc.us.ibm.com with ESMTP id 3gwt09udw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Jun 2022 20:30:25 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25TKUPYw64422394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jun 2022 20:30:25 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A12B112061;
        Wed, 29 Jun 2022 20:30:25 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28A8F112063;
        Wed, 29 Jun 2022 20:30:23 +0000 (GMT)
Received: from [9.211.37.55] (unknown [9.211.37.55])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 29 Jun 2022 20:30:22 +0000 (GMT)
Message-ID: <f916f306-acff-3537-1bcc-9f19c4794e81@linux.ibm.com>
Date:   Wed, 29 Jun 2022 22:29:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2] net/smc: align the connect behaviour with TCP
To:     guangguan.wang@linux.alibaba.com
Cc:     Karsten Graul <kgraul@linux.ibm.com>, liuyacan@corp.netease.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
References: <26d43c65-1f23-5b83-6377-3327854387c4@linux.ibm.com>
 <20220524125725.951315-1-liuyacan@corp.netease.com>
 <3bb9366d-f271-a603-a280-b70ae2d59c00@linux.ibm.com>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <3bb9366d-f271-a603-a280-b70ae2d59c00@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: h3K-yAZgwBhezQ-hJPPy0ieO-hN4Xv9s
X-Proofpoint-ORIG-GUID: cjKtaRJ5iqGOuLbpQ0HBNA74ZxX3_IAx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-29_21,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206290070
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24.05.22 15:05, Karsten Graul wrote:
> On 24/05/2022 14:57, liuyacan@corp.netease.com wrote:
>>>>
>>>>
>>>> On 2022/5/23 20:24, Karsten Graul wrote:
>>>>> On 13/05/2022 04:24, Guangguan Wang wrote:
>>>>>> Connect with O_NONBLOCK will not be completed immediately
>>>>>> and returns -EINPROGRESS. It is possible to use selector/poll
>>>>>> for completion by selecting the socket for writing. After select
>>>>>> indicates writability, a second connect function call will return
>>>>>> 0 to indicate connected successfully as TCP does, but smc returns
>>>>>> -EISCONN. Use socket state for smc to indicate connect state, which
>>>>>> can help smc aligning the connect behaviour with TCP.
>>>>>>
>>>>>> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
>>>>>> Acked-by: Karsten Graul <kgraul@linux.ibm.com>
>>>>>> ---
>>>>>>   net/smc/af_smc.c | 50 ++++++++++++++++++++++++++++++++++++++++++++----
>>>>>>   1 file changed, 46 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>>>>>> index fce16b9d6e1a..5f70642a8044 100644
>>>>>> --- a/net/smc/af_smc.c
>>>>>> +++ b/net/smc/af_smc.c
>>>>>> @@ -1544,9 +1544,29 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
>>>>>>   		goto out_err;
>>>>>>   
>>>>>>   	lock_sock(sk);
>>>>>> +	switch (sock->state) {
>>>>>> +	default:
>>>>>> +		rc = -EINVAL;
>>>>>> +		goto out;
>>>>>> +	case SS_CONNECTED:
>>>>>> +		rc = sk->sk_state == SMC_ACTIVE ? -EISCONN : -EINVAL;
>>>>>> +		goto out;
>>>>>> +	case SS_CONNECTING:
>>>>>> +		if (sk->sk_state == SMC_ACTIVE)
>>>>>> +			goto connected;
>>>>>
>>>>> I stumbled over this when thinking about the fallback processing. If for whatever reason
>>>>> fallback==true during smc_connect(), the "if (smc->use_fallback)" below would set sock->state
>>>>> to e.g. SS_CONNECTED. But in the fallback case sk_state keeps SMC_INIT. So during the next call
>>>>> the SS_CONNECTING case above would break because sk_state in NOT SMC_ACTIVE, and we would end
>>>>> up calling kernel_connect() again. Which seems to be no problem when kernel_connect() returns
>>>>> -EISCONN and we return this to the caller. But is this how it should work, or does it work by chance?
>>>>>
>>>>
>>>> Since the sk_state keeps SMC_INIT and does not correctly indicate the state of clcsock, it should end
>>>> up calling kernel_connect() again to get the actual connection state of clcsock.
>>>>
>>>> And I'm sorry there is a problem that if sock->state==SS_CONNECTED and sk_state==SMC_INIT, further call
>>>> of smc_connect will return -EINVAL where -EISCONN is preferred.
>>>> The steps to reproduce:
>>>> 1）switch fallback before connect, such as setsockopt TCP_FASTOPEN
>>>> 2）connect with noblocking and returns -EINPROGRESS. (sock->state changes to SS_CONNECTING)
>>>> 3) end up calling connect with noblocking again and returns 0. (kernel_connect() returns 0 and sock->state changes to
>>>>     SS_CONNECTED but sk->sk_state stays SMC_INIT)
>>>> 4) call connect again, maybe by mistake, will return -EINVAL, but -EISCONN is preferred.
>>>>
>>>> What do you think about if we synchronize the sk_state to SMC_ACTIVE instead of keeping SMC_INIT when clcsock
>>>> connected successfully in fallback case described above.
>>>>
>>>> ...
>>>
>>> I start thinking that the fix in 86434744 introduced a problem. Before that fix a connect with
>>> fallback always reached __smc_connect() and on top of that function in case of fallback
>>> smc_connect_fallback() is called, which itself sets sk_state to SMC_ACTIVE.
>>>
>>> 86434744 removed that code path and I wonder what it actually fixed, because at this time the
>>> fallback check in __smc_connect() was already present.
>>>
>>> Without that "goto out;" the state would be set correctly in smc_connect_fallback(), and the
>>> socket close processing would work as expected.
>>
>> I think it is OK without that "goto out;". And I guess the purpose of "goto out;" is to avoid calling __smc_connect(),
>> because it is impossible to establish an rdma channel at this time.
> 
> Yes that was the purpose, but this disabled all the extra processing that should be done
> for fallback sockets during connect().
> 
Since Karsten's suggestion, we didn't hear from you any more. We just 
want to know:

- What do you think about the commit (86434744)? Could it be the trigger 
of the problem you met?

- Have you ever tried to just remove the following lines from 
smc_connection(), and check if your scenario could run correctly?

       if (smc->use_fallback)
               goto out;

In our opinion, we don't see the necessity of the patch, if partly 
reverting the commit (86434744) could solve the problem.
