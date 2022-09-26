Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCEF5E9E9F
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 12:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbiIZKIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 06:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234955AbiIZKHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 06:07:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E07F3DBDE;
        Mon, 26 Sep 2022 03:07:12 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28Q9qOpC013194;
        Mon, 26 Sep 2022 10:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0wv6JA6clDMXUcpn5wdXS3V0pT1LzCzVU03fvOdHOwk=;
 b=aaSqML4GaDpccK8gWdDkh9GcoMru7skhjRDp7F/xgvfvz0A+uR/QeTXJxagJeUs2gGuu
 1XsnYBtW6zSA5xUSYa0XtEVl0c1JuKk0ZMRx302Frf+qmIx47Ghk9p1O04uYDqQqzhEV
 PLO831syPyqPoe0H4oM/ldgFPE31UHjUwjp63slMjrUIJshxEMkVbgYauc+Af/40j378
 edZcIrWXdFt+AELdHmccDLuYVBWN1mmL3q4D8yWTXHHpXMM/8syYfMkueEqoQppQjuDn
 Q84ekGMzqZiMXMKPEF9Jc4++hG6hWyeJP+8Ln7W+2sBjPKF5knUexwBe63jpjYVlcLDs 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ju9tvge6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 10:07:06 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28Q9pskU012317;
        Mon, 26 Sep 2022 10:07:05 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ju9tvge5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 10:07:05 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28Q9sBMI024754;
        Mon, 26 Sep 2022 10:07:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3jssh91pkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Sep 2022 10:07:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28QA701m44827124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 10:07:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 238C8A4040;
        Mon, 26 Sep 2022 10:07:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B29E5A404D;
        Mon, 26 Sep 2022 10:06:59 +0000 (GMT)
Received: from [9.145.176.233] (unknown [9.145.176.233])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 26 Sep 2022 10:06:59 +0000 (GMT)
Message-ID: <886c690b-cc35-39a0-8397-834e70fb329b@linux.ibm.com>
Date:   Mon, 26 Sep 2022 12:06:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [RFC net] net/mlx5: Fix performance regression for
 request-response workloads
Content-Language: en-US
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        netdev <netdev@vger.kernel.org>, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Dumazet <edumazet@google.com>
References: <20220907122505.26953-1-wintera@linux.ibm.com>
 <CANn89iLP15xQjmPHxvQBQ=bWbbVk4_41yLC8o5E97TQWFmRioQ@mail.gmail.com>
 <375efe42-910d-69ae-e48d-cff0298dd104@linux.ibm.com>
 <CANn89iKjxMMDEcOCKiqWiMybiYVd7ZqspnEkT0-puqxrknLtRA@mail.gmail.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <CANn89iKjxMMDEcOCKiqWiMybiYVd7ZqspnEkT0-puqxrknLtRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2oLo_FHsEypOpQkY6_2wJBpqnqG-Oq_c
X-Proofpoint-GUID: VZxltBHNgErOntGT_a1sVUiaq8OVfRV2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_08,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1011 phishscore=0
 spamscore=0 impostorscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2209260064
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08.09.22 14:41, Eric Dumazet wrote:
> On Thu, Sep 8, 2022 at 2:40 AM Christian Borntraeger
> <borntraeger@linux.ibm.com> wrote:
>>
>> Am 07.09.22 um 18:06 schrieb Eric Dumazet:
>>> On Wed, Sep 7, 2022 at 5:26 AM Alexandra Winter <wintera@linux.ibm.com> wrote:
>>>>
>>>> Since linear payload was removed even for single small messages,
>>>> an additional page is required and we are measuring performance impact.
>>>>
>>>> 3613b3dbd1ad ("tcp: prepare skbs for better sack shifting")
>>>> explicitely allowed "payload in skb->head for first skb put in the queue,
>>>> to not impact RPC workloads."
>>>> 472c2e07eef0 ("tcp: add one skb cache for tx")
>>>> made that obsolete and removed it.
>>>> When
>>>> d8b81175e412 ("tcp: remove sk_{tr}x_skb_cache")
>>>> reverted it, this piece was not reverted and not added back in.
>>>>
>>>> When running uperf with a request-response pattern with 1k payload
>>>> and 250 connections parallel, we measure 13% difference in throughput
>>>> for our PCI based network interfaces since 472c2e07eef0.
>>>> (our IO MMU is sensitive to the number of mapped pages)
>>>
>>>
>>>
>>>>
>>>> Could you please consider allowing linear payload for the first
>>>> skb in queue again? A patch proposal is appended below.
>>>
>>> No.
>>>
>>> Please add a work around in your driver.
>>>
>>> You can increase throughput by 20% by premapping a coherent piece of
>>> memory in which
>>> you can copy small skbs (skb->head included)
>>>
>>> Something like 256 bytes per slot in the TX ring.
>>>
>>
>> FWIW this regression was withthe standard mellanox driver (nothing s390 specific).
> 
> I did not claim this was s390 specific.
> 
> Only IOMMU mode.
> 
> I would rather not add back something which makes TCP stack slower
> (more tests in fast path)
> for the majority of us _not_ using IOMMU.
> 
> In our own tests, this trick of using linear skbs was only helping
> benchmarks, not real workloads.
> 
> Many drivers have to map skb->head a second time if they contain TCP payload,
> thus adding yet another corner case in their fast path.
> 
> - Typical RPC workloads are playing with TCP_NODELAY
> - Typical bulk flows never have empty write queues...
> 
> Really, I do not want this optimization back, this is not worth it.
> 
> Again, a driver knows better if it is using IOMMU and if pathological
> layouts can be optimized
> to non SG ones, and using a pre-dma-map zone will also benefit pure
> TCP ACK packets (which do not have any payload)
> 
> Here is the changelog of a patch I did for our GQ NIC (not yet
> upstreamed, but will be soon)
> 
[...]

Saeed,
As discussed at LPC, could you please consider adding a workaround to the
Mellanox driver, to use non-SG SKBs for small messages? As mentioned above
we are seeing 13% throughput degradation, if 2 pages need to be mapped
instead of 1.

While Eric's ideas sound very promising, just using non-SG in these cases
should be enough to mitigate the performance regression we see.

Thank you in advance.
Alexandra
