Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9D55329EA
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbiEXMET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiEXMER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:04:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2CF6352A;
        Tue, 24 May 2022 05:04:15 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OBCI6T009108;
        Tue, 24 May 2022 12:04:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pkpvet2aYFdtsPpPVLW0UUn/mKDsVwZB965VQgGhu9I=;
 b=guRLXgz+HBGg8AkKbMlI/HVVqOEU7KpnVJ2Lee2cEcjQwZZVZc4lO77Oa5tQhnA6i9yo
 Rr63WFqXuyMxf2z03X7v36i0SXCQXNzqqlWpi91n700NXpy5d91KuGw8ZEOnIshHfmJF
 nJCfWytKykLvo15/DAHa6Iw7r/MpOxP9dIGMaG0zcLvEcfKv7iVDGqoT0R/32EmQcfSO
 aMkW22hQKgNiPsJeNN+C6IQNuwCb3SeVYyPtG0rEEvT5G6er8fdjhkeHBMGD0MKx70HO
 QvZK/HsjVa3H3cs+RBqQxLSOfJN7TNmm/vFypydCjsnNkiuKAQpYT6sSOPCIeULSDEFn 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8x97rx45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 12:04:12 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OBwLgd014886;
        Tue, 24 May 2022 12:04:12 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8x97rx36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 12:04:12 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OC2UCr026206;
        Tue, 24 May 2022 12:04:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3g6qq9cdak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 12:04:09 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OC475M56426970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 12:04:07 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F1EC42042;
        Tue, 24 May 2022 12:04:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FBC242041;
        Tue, 24 May 2022 12:04:07 +0000 (GMT)
Received: from [9.171.67.153] (unknown [9.171.67.153])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 12:04:06 +0000 (GMT)
Message-ID: <26d43c65-1f23-5b83-6377-3327854387c4@linux.ibm.com>
Date:   Tue, 24 May 2022 14:04:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v2] net/smc: align the connect behaviour with TCP
Content-Language: en-US
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220513022453.7256-1-guangguan.wang@linux.alibaba.com>
 <3f0405e7-d92b-e8d0-cc61-b25a11644264@linux.ibm.com>
 <45a19f8b-1b64-3459-c28c-aebab4fd8f1e@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <45a19f8b-1b64-3459-c28c-aebab4fd8f1e@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I1DRdadF9gkCsCORK4RnpgAzFH3e3LMc
X-Proofpoint-GUID: Pqb8uBDMQwbd9Q3WF0vjoW5BcGhmVIXx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205240063
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/05/2022 04:59, Guangguan Wang wrote:
> 
> 
> On 2022/5/23 20:24, Karsten Graul wrote:
>> On 13/05/2022 04:24, Guangguan Wang wrote:
>>> Connect with O_NONBLOCK will not be completed immediately
>>> and returns -EINPROGRESS. It is possible to use selector/poll
>>> for completion by selecting the socket for writing. After select
>>> indicates writability, a second connect function call will return
>>> 0 to indicate connected successfully as TCP does, but smc returns
>>> -EISCONN. Use socket state for smc to indicate connect state, which
>>> can help smc aligning the connect behaviour with TCP.
>>>
>>> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
>>> Acked-by: Karsten Graul <kgraul@linux.ibm.com>
>>> ---
>>>  net/smc/af_smc.c | 50 ++++++++++++++++++++++++++++++++++++++++++++----
>>>  1 file changed, 46 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>>> index fce16b9d6e1a..5f70642a8044 100644
>>> --- a/net/smc/af_smc.c
>>> +++ b/net/smc/af_smc.c
>>> @@ -1544,9 +1544,29 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
>>>  		goto out_err;
>>>  
>>>  	lock_sock(sk);
>>> +	switch (sock->state) {
>>> +	default:
>>> +		rc = -EINVAL;
>>> +		goto out;
>>> +	case SS_CONNECTED:
>>> +		rc = sk->sk_state == SMC_ACTIVE ? -EISCONN : -EINVAL;
>>> +		goto out;
>>> +	case SS_CONNECTING:
>>> +		if (sk->sk_state == SMC_ACTIVE)
>>> +			goto connected;
>>
>> I stumbled over this when thinking about the fallback processing. If for whatever reason
>> fallback==true during smc_connect(), the "if (smc->use_fallback)" below would set sock->state
>> to e.g. SS_CONNECTED. But in the fallback case sk_state keeps SMC_INIT. So during the next call
>> the SS_CONNECTING case above would break because sk_state in NOT SMC_ACTIVE, and we would end
>> up calling kernel_connect() again. Which seems to be no problem when kernel_connect() returns 
>> -EISCONN and we return this to the caller. But is this how it should work, or does it work by chance?
>>
> 
> Since the sk_state keeps SMC_INIT and does not correctly indicate the state of clcsock, it should end
> up calling kernel_connect() again to get the actual connection state of clcsock.
> 
> And I'm sorry there is a problem that if sock->state==SS_CONNECTED and sk_state==SMC_INIT, further call
> of smc_connect will return -EINVAL where -EISCONN is preferred. 
> The steps to reproduce:
> 1）switch fallback before connect, such as setsockopt TCP_FASTOPEN
> 2）connect with noblocking and returns -EINPROGRESS. (sock->state changes to SS_CONNECTING)
> 3) end up calling connect with noblocking again and returns 0. (kernel_connect() returns 0 and sock->state changes to
>    SS_CONNECTED but sk->sk_state stays SMC_INIT)
> 4) call connect again, maybe by mistake, will return -EINVAL, but -EISCONN is preferred.
> 
> What do you think about if we synchronize the sk_state to SMC_ACTIVE instead of keeping SMC_INIT when clcsock
> connected successfully in fallback case described above.
> 
> ...

I start thinking that the fix in 86434744 introduced a problem. Before that fix a connect with
fallback always reached __smc_connect() and on top of that function in case of fallback
smc_connect_fallback() is called, which itself sets sk_state to SMC_ACTIVE.

86434744 removed that code path and I wonder what it actually fixed, because at this time the 
fallback check in __smc_connect() was already present.

Without that "goto out;" the state would be set correctly in smc_connect_fallback(), and the 
socket close processing would work as expected.
