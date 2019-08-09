Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7828830E
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfHIS6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:58:20 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:43492 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbfHIS6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:58:20 -0400
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x79IviZg031943;
        Fri, 9 Aug 2019 19:58:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=S6KIJ/R3Q2d2yYbq4kupA3dQafDOXv/ccWDgej/drK8=;
 b=kaFmBOTH5ALYd2KwFACdouwlaA5qD9ynHHbBlPKEz9t+KXLIeE3qK8cn8LNxQJzW3GHD
 fzIEmS5EdH1O6lPEHAc534utOUYRUJdLHD7mogVQtY4B8E4dNrMyq2EYp7/Ysq304G2V
 ocGECFDcHF0PZi+UnhT40dva0VzkkmThZXAtNovm0WiMQ5id2mHPxbLSveNGI7QbVjg8
 2Ke0Og9YIB5rNVqd8X3CrB5mPlVAKb/yerM5XNwU4hTC5m0kWH55pmIeGwGHOCVuX8RY
 8VrDKXiuTNE2MvF21SPF/25OdnktrHpqLWwUH7ixQT4bFxPT4Wq0PJ35s3pTTXfLsIq9 Ig== 
Received: from prod-mail-ppoint7 (prod-mail-ppoint7.akamai.com [96.6.114.121] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2u52ahe0xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 19:58:09 +0100
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
        by prod-mail-ppoint7.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x79IlcWX019354;
        Fri, 9 Aug 2019 14:58:08 -0400
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint7.akamai.com with ESMTP id 2u55kw34hn-1;
        Fri, 09 Aug 2019 14:58:08 -0400
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id 059292006D;
        Fri,  9 Aug 2019 18:58:03 +0000 (GMT)
Subject: Re: [PATCH net-next] gso: enable udp gso for virtual devices
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jason Baron <jbaron@akamai.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <1560381160-19584-1-git-send-email-jbaron@akamai.com>
 <CAKgT0Uej5CkBJpqsBnB61ozo2kAFKyAH8WY9KVbFQ67ZxPiDag@mail.gmail.com>
 <3af1e0da-8eb4-8462-3107-27917fec9286@akamai.com>
 <CAF=yD-+BMvToWvRwayTrxQBQ-Lgq7QVA6E+rGe3e5ic7rQ_gSg@mail.gmail.com>
 <f91fb37a-379a-4a59-7e04-cf8a6d161efa@akamai.com>
 <d5dea281-67c0-1385-95c1-b476825e6afa@akamai.com>
 <CAF=yD-+zYGzTTYC-oYr392qugWiYpbgykMh1p8UrrgZ2ciR=aw@mail.gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <314b4ae8-ef99-e7a4-cb95-87b7ea74427f@akamai.com>
Date:   Fri, 9 Aug 2019 11:58:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-+zYGzTTYC-oYr392qugWiYpbgykMh1p8UrrgZ2ciR=aw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090184
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-09_06:2019-08-09,2019-08-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1908090186
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/26/19 4:41 PM, Willem de Bruijn wrote:
> On Wed, Jun 26, 2019 at 3:17 PM Jason Baron <jbaron@akamai.com> wrote:
>>
>>
>>
>> On 6/14/19 4:53 PM, Jason Baron wrote:
>>>
>>>
>>> On 6/13/19 5:20 PM, Willem de Bruijn wrote:
>>>>>>> @@ -237,6 +237,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
>>>>>>>                                   NETIF_F_GSO_GRE_CSUM |                 \
>>>>>>>                                   NETIF_F_GSO_IPXIP4 |                   \
>>>>>>>                                   NETIF_F_GSO_IPXIP6 |                   \
>>>>>>> +                                NETIF_F_GSO_UDP_L4 |                   \
>>>>>>>                                   NETIF_F_GSO_UDP_TUNNEL |               \
>>>>>>>                                   NETIF_F_GSO_UDP_TUNNEL_CSUM)
>>>>>>
>>>>>> Are you adding this to NETIF_F_GSO_ENCAP_ALL? Wouldn't it make more
>>>>>> sense to add it to NETIF_F_GSO_SOFTWARE?
>>>>>>
>>>>>
>>>>> Yes, I'm adding to NETIF_F_GSO_ENCAP_ALL (not very clear from the
>>>>> context). I will fix the commit log.
>>>>>
>>>>> In: 83aa025 udp: add gso support to virtual devices, the support was
>>>>> also added to NETIF_F_GSO_ENCAP_ALL (although subsequently reverted due
>>>>> to UDP GRO not being in place), so I wonder what the reason was for that?
>>>>
>>>> That was probably just a bad choice on my part.
>>>>
>>>> It worked in practice, but if NETIF_F_GSO_SOFTWARE works the same
>>>> without unexpected side effects, then I agree that it is the better choice.
>>>>
>>>> That choice does appear to change behavior when sending over tunnel
>>>> devices. Might it send tunneled GSO packets over loopback?
>>>>
>>>>
>>>
>>> I set up a test case using fou tunneling through a bridge device using
>>> the udpgso_bench_tx test where packets are not received correctly if
>>> NETIF_F_GSO_UDP_L4 is added to NETIF_F_GSO_SOFTWARE. If I have it added
>>> to NETIF_F_GSO_ENCAP_ALL, it does work correctly. So there are more
>>> fixes required to include it in NETIF_F_GSO_SOFTWARE.
>>>
>>> The use-case I have only requires it to be in NETIF_F_GSO_ENCAP_ALL, but
>>> if it needs to go in NETIF_F_GSO_SOFTWARE, I can look at what's required
>>> more next week.
>>>
>>
>> Hi,
>>
>> I haven't had a chance to investigate what goes wrong with including
>> NETIF_F_GSO_UDP_L4 in NETIF_F_GSO_SOFTWARE - but I was just wondering if
>> people are ok with NETIF_F_GSO_UDP_L4 being added to
>> NETIF_F_GSO_ENCAP_ALL and not NETIF_F_GSO_SOFTWARE (ie the original
>> patch as posted)?
>>
>> As I mentioned that is sufficient for my use-case, and its how Willem
>> originally proposed this.
> 
> Indeed, based on the previous discussion this sounds fine to me.
> 

Willem

Are you OK to ACK this? If not, is there something else you'd rather see 
here?

Thanks
Josh
