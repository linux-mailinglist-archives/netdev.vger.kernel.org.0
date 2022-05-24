Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2161532ACB
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 15:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237554AbiEXNFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 09:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237549AbiEXNFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 09:05:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3E4915BB;
        Tue, 24 May 2022 06:05:44 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OCmTT5009976;
        Tue, 24 May 2022 13:05:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4a02P7CwzQE7rJFeSSIkifhto597iNOCRT9Q3Xdads0=;
 b=sZ62Q3Sx0GYwkncyIN7dvZXN6kSXQYtFPA8CyqlwwJDVhEEQ7XaMyBcQ6mUYTFQVkedp
 us81ieGDj/iCLrq25n+VBC431h8ki01MkXpcfJS4J17917eHR9yZ7qOfpAicOJRn501V
 sl6/TjicjSROrk1qQgnoyzeBcu5QMDVXFYENixdV+ykDt8QewKe6bA3Rg+psAZDSaCGZ
 pGdOTNl3Y6FxCqNV/5CVAmk+HD6AiO3dnXknhuU2MnCXP4+SRthSjHANcAyY1rm+IYFb
 NbHjYCuS4e88yXxq18oXUiddac391NO79+WBe94nqcVtlYX1cF5hzWR+nywRGNTdJQST RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8ypp0ckm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 13:05:38 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OCwX53015800;
        Tue, 24 May 2022 13:05:38 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8ypp0cj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 13:05:38 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OD2wja018845;
        Tue, 24 May 2022 13:05:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3g6qq9cg59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 13:05:35 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OD5Xkh41091496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 13:05:33 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C53D42059;
        Tue, 24 May 2022 13:05:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C75542054;
        Tue, 24 May 2022 13:05:32 +0000 (GMT)
Received: from [9.171.67.153] (unknown [9.171.67.153])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 13:05:32 +0000 (GMT)
Message-ID: <3bb9366d-f271-a603-a280-b70ae2d59c00@linux.ibm.com>
Date:   Tue, 24 May 2022 15:05:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v2] net/smc: align the connect behaviour with TCP
Content-Language: en-US
To:     liuyacan@corp.netease.com
Cc:     davem@davemloft.net, guangguan.wang@linux.alibaba.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
References: <26d43c65-1f23-5b83-6377-3327854387c4@linux.ibm.com>
 <20220524125725.951315-1-liuyacan@corp.netease.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220524125725.951315-1-liuyacan@corp.netease.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EbIdf1uvrDDLu7lzyKTYwM9kL8ycI-13
X-Proofpoint-GUID: TMR7-1BRReiakQPwFydyWLd3M1H1qbrK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 mlxscore=0 clxscore=1015 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205240066
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/05/2022 14:57, liuyacan@corp.netease.com wrote:
>>>
>>>
>>> On 2022/5/23 20:24, Karsten Graul wrote:
>>>> On 13/05/2022 04:24, Guangguan Wang wrote:
>>>>> Connect with O_NONBLOCK will not be completed immediately
>>>>> and returns -EINPROGRESS. It is possible to use selector/poll
>>>>> for completion by selecting the socket for writing. After select
>>>>> indicates writability, a second connect function call will return
>>>>> 0 to indicate connected successfully as TCP does, but smc returns
>>>>> -EISCONN. Use socket state for smc to indicate connect state, which
>>>>> can help smc aligning the connect behaviour with TCP.
>>>>>
>>>>> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
>>>>> Acked-by: Karsten Graul <kgraul@linux.ibm.com>
>>>>> ---
>>>>>  net/smc/af_smc.c | 50 ++++++++++++++++++++++++++++++++++++++++++++----
>>>>>  1 file changed, 46 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>>>>> index fce16b9d6e1a..5f70642a8044 100644
>>>>> --- a/net/smc/af_smc.c
>>>>> +++ b/net/smc/af_smc.c
>>>>> @@ -1544,9 +1544,29 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
>>>>>  		goto out_err;
>>>>>  
>>>>>  	lock_sock(sk);
>>>>> +	switch (sock->state) {
>>>>> +	default:
>>>>> +		rc = -EINVAL;
>>>>> +		goto out;
>>>>> +	case SS_CONNECTED:
>>>>> +		rc = sk->sk_state == SMC_ACTIVE ? -EISCONN : -EINVAL;
>>>>> +		goto out;
>>>>> +	case SS_CONNECTING:
>>>>> +		if (sk->sk_state == SMC_ACTIVE)
>>>>> +			goto connected;
>>>>
>>>> I stumbled over this when thinking about the fallback processing. If for whatever reason
>>>> fallback==true during smc_connect(), the "if (smc->use_fallback)" below would set sock->state
>>>> to e.g. SS_CONNECTED. But in the fallback case sk_state keeps SMC_INIT. So during the next call
>>>> the SS_CONNECTING case above would break because sk_state in NOT SMC_ACTIVE, and we would end
>>>> up calling kernel_connect() again. Which seems to be no problem when kernel_connect() returns 
>>>> -EISCONN and we return this to the caller. But is this how it should work, or does it work by chance?
>>>>
>>>
>>> Since the sk_state keeps SMC_INIT and does not correctly indicate the state of clcsock, it should end
>>> up calling kernel_connect() again to get the actual connection state of clcsock.
>>>
>>> And I'm sorry there is a problem that if sock->state==SS_CONNECTED and sk_state==SMC_INIT, further call
>>> of smc_connect will return -EINVAL where -EISCONN is preferred. 
>>> The steps to reproduce:
>>> 1）switch fallback before connect, such as setsockopt TCP_FASTOPEN
>>> 2）connect with noblocking and returns -EINPROGRESS. (sock->state changes to SS_CONNECTING)
>>> 3) end up calling connect with noblocking again and returns 0. (kernel_connect() returns 0 and sock->state changes to
>>>    SS_CONNECTED but sk->sk_state stays SMC_INIT)
>>> 4) call connect again, maybe by mistake, will return -EINVAL, but -EISCONN is preferred.
>>>
>>> What do you think about if we synchronize the sk_state to SMC_ACTIVE instead of keeping SMC_INIT when clcsock
>>> connected successfully in fallback case described above.
>>>
>>> ...
>>
>> I start thinking that the fix in 86434744 introduced a problem. Before that fix a connect with
>> fallback always reached __smc_connect() and on top of that function in case of fallback
>> smc_connect_fallback() is called, which itself sets sk_state to SMC_ACTIVE.
>>
>> 86434744 removed that code path and I wonder what it actually fixed, because at this time the 
>> fallback check in __smc_connect() was already present.
>>
>> Without that "goto out;" the state would be set correctly in smc_connect_fallback(), and the 
>> socket close processing would work as expected.
> 
> I think it is OK without that "goto out;". And I guess the purpose of "goto out;" is to avoid calling __smc_connect(), 
> because it is impossible to establish an rdma channel at this time.

Yes that was the purpose, but this disabled all the extra processing that should be done
for fallback sockets during connect().

