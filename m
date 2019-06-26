Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBC95716C
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFZTRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:17:45 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:28530 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726104AbfFZTRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 15:17:44 -0400
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5QJGoW5001745;
        Wed, 26 Jun 2019 20:17:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=Pir0gkJXUFPTeChSDJFKfTOxl5NkQH/Lpa43okBDeiM=;
 b=TrV5TK8gV3VlrVWxPM8p4YyoZjmjSlSNYqi5H3vIs74PY/uOc+5EVMxdJw/BpG49cykI
 4fhfyKwoovQTm1UkJ4HOaiDKUpeCKNydgQx9f0/xFQipefhxf7aXCdVtt5ipWp5xi2oo
 S2x+WdZLlThTmpCIRIqzt3hzd3MkOIrPAE4FnQBcQhRPrq4GHi2YTY+1QcOXNfW9eX0R
 pHSqDWlineapWQi/LB7QYK+GnO+VuyonAPAtsE9PqumLtyVie/4TiNyCrqsiVoFXoZHe
 fP+SB4oNGmrh8yL7ykyu+FQ/vU6W+1gNy+7l+sXvrUSIwee/iSpwVja3QPbKDu/yPBB3 bQ== 
Received: from prod-mail-ppoint4 (prod-mail-ppoint4.akamai.com [96.6.114.87] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2tc7r1hesd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 20:17:06 +0100
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x5QJ1pg6014502;
        Wed, 26 Jun 2019 15:17:05 -0400
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint4.akamai.com with ESMTP id 2tce4egeha-1;
        Wed, 26 Jun 2019 15:17:04 -0400
Received: from [172.29.170.83] (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id C6E412006A;
        Wed, 26 Jun 2019 19:16:49 +0000 (GMT)
Subject: Re: [PATCH net-next] gso: enable udp gso for virtual devices
From:   Jason Baron <jbaron@akamai.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Joshua Hunt <johunt@akamai.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <1560381160-19584-1-git-send-email-jbaron@akamai.com>
 <CAKgT0Uej5CkBJpqsBnB61ozo2kAFKyAH8WY9KVbFQ67ZxPiDag@mail.gmail.com>
 <3af1e0da-8eb4-8462-3107-27917fec9286@akamai.com>
 <CAF=yD-+BMvToWvRwayTrxQBQ-Lgq7QVA6E+rGe3e5ic7rQ_gSg@mail.gmail.com>
 <f91fb37a-379a-4a59-7e04-cf8a6d161efa@akamai.com>
Openpgp: preference=signencrypt
Autocrypt: addr=jbaron@akamai.com; prefer-encrypt=mutual; keydata=
 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
 JeQ7iQ==
Message-ID: <d5dea281-67c0-1385-95c1-b476825e6afa@akamai.com>
Date:   Wed, 26 Jun 2019 15:15:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <f91fb37a-379a-4a59-7e04-cf8a6d161efa@akamai.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260220
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260224
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/14/19 4:53 PM, Jason Baron wrote:
> 
> 
> On 6/13/19 5:20 PM, Willem de Bruijn wrote:
>>>>> @@ -237,6 +237,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
>>>>>                                  NETIF_F_GSO_GRE_CSUM |                 \
>>>>>                                  NETIF_F_GSO_IPXIP4 |                   \
>>>>>                                  NETIF_F_GSO_IPXIP6 |                   \
>>>>> +                                NETIF_F_GSO_UDP_L4 |                   \
>>>>>                                  NETIF_F_GSO_UDP_TUNNEL |               \
>>>>>                                  NETIF_F_GSO_UDP_TUNNEL_CSUM)
>>>>
>>>> Are you adding this to NETIF_F_GSO_ENCAP_ALL? Wouldn't it make more
>>>> sense to add it to NETIF_F_GSO_SOFTWARE?
>>>>
>>>
>>> Yes, I'm adding to NETIF_F_GSO_ENCAP_ALL (not very clear from the
>>> context). I will fix the commit log.
>>>
>>> In: 83aa025 udp: add gso support to virtual devices, the support was
>>> also added to NETIF_F_GSO_ENCAP_ALL (although subsequently reverted due
>>> to UDP GRO not being in place), so I wonder what the reason was for that?
>>
>> That was probably just a bad choice on my part.
>>
>> It worked in practice, but if NETIF_F_GSO_SOFTWARE works the same
>> without unexpected side effects, then I agree that it is the better choice.
>>
>> That choice does appear to change behavior when sending over tunnel
>> devices. Might it send tunneled GSO packets over loopback?
>>
>>
> 
> I set up a test case using fou tunneling through a bridge device using
> the udpgso_bench_tx test where packets are not received correctly if
> NETIF_F_GSO_UDP_L4 is added to NETIF_F_GSO_SOFTWARE. If I have it added
> to NETIF_F_GSO_ENCAP_ALL, it does work correctly. So there are more
> fixes required to include it in NETIF_F_GSO_SOFTWARE.
> 
> The use-case I have only requires it to be in NETIF_F_GSO_ENCAP_ALL, but
> if it needs to go in NETIF_F_GSO_SOFTWARE, I can look at what's required
> more next week.
> 

Hi,

I haven't had a chance to investigate what goes wrong with including
NETIF_F_GSO_UDP_L4 in NETIF_F_GSO_SOFTWARE - but I was just wondering if
people are ok with NETIF_F_GSO_UDP_L4 being added to
NETIF_F_GSO_ENCAP_ALL and not NETIF_F_GSO_SOFTWARE (ie the original
patch as posted)?

As I mentioned that is sufficient for my use-case, and its how Willem
originally proposed this.

Thanks,

-Jason



> Thanks,
> 
> -Jason
> 
>>
>>> I agree that NETIF_F_GSO_SOFTWARE seems conceptually more logical and
>>> further I think it adds support for more 'virtual' devices. For example,
>>> I tested loopback with NETIF_F_GSO_UDP_L4 being added to
>>> NETIF_F_GSO_SOFTWARE and it shows a nice performance gain, whereas
>>> NETIF_F_GSO_ENCAP_ALL isn't included for loopback.
>>>
>>> Thanks,
>>>
>>> -Jason
