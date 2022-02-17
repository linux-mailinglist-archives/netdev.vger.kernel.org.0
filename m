Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC654B9C24
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 10:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238740AbiBQJhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 04:37:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238736AbiBQJhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 04:37:54 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709961A0C0B;
        Thu, 17 Feb 2022 01:37:39 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21H97L89003737;
        Thu, 17 Feb 2022 09:37:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=zBrzxf8AhGHTrwIr3gzDwVxDc8WTumfDo5TxLvlETn8=;
 b=J1Yyl5uXFl8LKKELFTNKw94fN2JMccVX5uQVNE598R0F/nN1GLAxnYeZsMqEEw3njyEa
 V3FQCd9U+mOIcxNi33YCWaEXkh0XkqRhBvHDnNY4CzbiT4MHMxNm47z3+KJ1CYlSTQHw
 eg4qJbAFK1O1whVM0MfyPxHw4eFfa9srk3R7tC8exf3tEs3/QcoA6hiE8V8ieaEPcICF
 aEeUa7NCMrRr2VMiW5K7SFpMZLka0bmmf572a87pbB4wcvScZ9cFVmQdUPHHFuU7UgnG
 +nDvwBgptlnEaHVSJfMRo7bm2TFrY2I64Si5gvhg7EIAMOO12BiGgSY4LJHTWiacVL2K zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9gh7urr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 09:37:34 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21H9YtqW006228;
        Thu, 17 Feb 2022 09:37:33 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e9gh7urqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 09:37:33 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21H9YpOV001790;
        Thu, 17 Feb 2022 09:37:32 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3e645k8crj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 09:37:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21H9bTUt25559460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 09:37:29 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85EC44C058;
        Thu, 17 Feb 2022 09:37:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DB534C064;
        Thu, 17 Feb 2022 09:37:29 +0000 (GMT)
Received: from [9.171.73.63] (unknown [9.171.73.63])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 09:37:29 +0000 (GMT)
Message-ID: <454b5efd-e611-2dfb-e462-e7ceaee0da4d@linux.ibm.com>
Date:   Thu, 17 Feb 2022 10:37:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net/smc: Add autocork support
Content-Language: en-US
To:     dust.li@linux.alibaba.com, Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20220216034903.20173-1-dust.li@linux.alibaba.com>
 <68e9534b-7ff5-5a65-9017-124dbae0c74b@linux.ibm.com>
 <20220216152721.GB39286@linux.alibaba.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
In-Reply-To: <20220216152721.GB39286@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5BrP4_B9PSRNLXoaypCf-thWgmPgedmn
X-Proofpoint-ORIG-GUID: DIOp5fnKFz-lKh64r_6_ylAp37ca-QGO
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_03,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 adultscore=0
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202170042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22 16:27, dust.li wrote:
> On Wed, Feb 16, 2022 at 02:58:32PM +0100, Stefan Raspl wrote:
>> On 2/16/22 04:49, Dust Li wrote:
>>> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
>>> index 5df3940d4543..bc737ac79805 100644
>>> --- a/net/smc/smc_tx.c
>>> +++ b/net/smc/smc_tx.c
>>> @@ -31,6 +31,7 @@
>>>    #include "smc_tracepoint.h"
>>>    #define SMC_TX_WORK_DELAY	0
>>> +#define SMC_DEFAULT_AUTOCORK_SIZE	(64 * 1024)
>>
>> Probably a matter of taste, but why not use hex here?
> 
> Yeah, I have no option on this, I will change it in the next version.
> But I think it should have no real difference since the compiler
> should do the calculation.

Agreed - this is just to make it a tiny bit easier to digest.


>> Are there any fixed plans to make SMC_DEFAULT_AUTOCORK dynamic...? 'cause
>> otherwise we could simply eliminate this parameter, and use the define within
>> smc_should_autocork() instead.
> 
> Yes! Actually I'd like it to be dynamic variable too...
> 
> I didn't do it because I also want to add a control switch for the autocork
> feature just like TCP. In that case I need to add 2 variables here.
> But I found adding dynamic variables using netlink would introduce a lot of
> redundant code and may even bring ABI compatibility issues in the future, as
> I mentioned here:
> https://lore.kernel.org/netdev/20220216114618.GA39286@linux.alibaba.com/T/#mecfcd3f8c816d07dbe35e4748d17008331c89523
> 
> I'm not sure that's the right way to do it. In this case, I prefer using
> sysctl which I think would be easier, but I would like to listen to your advice.

Extending the Netlink interface should be possible without breaking the API - 
we'd be adding further variables, not modifying or removing existing ones.
Conceptually, Netlink is the way to go for any userspace interaction with SMC, 
which includes anything config-related.
Now we understand that cloud workloads are a bit different, and the desire to be 
able to modify the environment of a container while leaving the container image 
unmodified is understandable. But then again, enabling the base image would be 
the cloud way to address this. The question to us is: How do other parts of the 
kernel address this?

Ciao,
Stefan


