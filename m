Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7645027B4D1
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 20:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgI1SvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 14:51:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41920 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgI1SvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 14:51:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SIdWDP007098;
        Mon, 28 Sep 2020 18:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=A7uaJOX2ylrnWfar73KrPlgEDpbbRT5ZSGxJ+k3HwJY=;
 b=hQggJql8cUjSK9iWgMqy5xQgcy12AE8r2s2QYKWjZGnQjxNDYCOIvTsZl7H/Hl+Wml7D
 ADEjTkiXQinXUpbOzlaQ6NKhUqGqjvHVhkGvz2ChM2rxaskqSQ2hCfs4VUsmiggGJVng
 S7GaYKFgPCPRD1E0SoamcvSMcPK6ZpXfATNfNWKPHIUNrEtYUdyD0WcgvD0jAKn7Nw6t
 r8wjK95E26sUbXbNBUOmbhRVzFNVxgGd6Yxqb9706mcZoYKI5/E3EQGkH24mhB2rswUm
 B1vKLwc5usdoGjWsEoiid2sVLub2ktv5RGZheKa9wGNNNnqh63i0uDzHZPIsdZREb8y4 fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33swkkpr40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 18:50:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SIeM5K104213;
        Mon, 28 Sep 2020 18:50:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33tfhwmm91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 18:50:23 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SIo1mj032727;
        Mon, 28 Sep 2020 18:50:01 GMT
Received: from [10.74.86.78] (/10.74.86.78)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 11:50:01 -0700
Subject: Re: [PATCH v3 01/11] xen/manage: keep track of the on-going suspend
 mode
To:     Anchal Agarwal <anchalag@amazon.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, jgross@suse.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, kamatam@amazon.com, sstabellini@kernel.org,
        konrad.wilk@oracle.com, roger.pau@citrix.com, axboe@kernel.dk,
        davem@davemloft.net, rjw@rjwysocki.net, len.brown@intel.com,
        pavel@ucw.cz, peterz@infradead.org, eduval@amazon.com,
        sblbir@amazon.com, xen-devel@lists.xenproject.org,
        vkuznets@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw@amazon.co.uk,
        benh@kernel.crashing.org
References: <4b2bbc8b-7817-271a-4ff0-5ee5df956049@oracle.com>
 <20200914214754.GA19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <e9b94104-d20a-b6b2-cbe0-f79b1ed09c98@oracle.com>
 <20200915180055.GB19975@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <5f1e4772-7bd9-e6c0-3fe6-eef98bb72bd8@oracle.com>
 <20200921215447.GA28503@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <e3e447e5-2f7a-82a2-31c8-10c2ffcbfb2c@oracle.com>
 <20200922231736.GA24215@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200925190423.GA31885@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <274ddc57-5c98-5003-c850-411eed1aea4c@oracle.com>
 <20200925222826.GA11755@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <cc738014-6a79-a5ae-cb2a-a02ff15b4582@oracle.com>
Date:   Mon, 28 Sep 2020 14:49:56 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200925222826.GA11755@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/25/20 6:28 PM, Anchal Agarwal wrote:
> On Fri, Sep 25, 2020 at 04:02:58PM -0400, boris.ostrovsky@oracle.com wrote:
>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>
>>
>>
>> On 9/25/20 3:04 PM, Anchal Agarwal wrote:
>>> On Tue, Sep 22, 2020 at 11:17:36PM +0000, Anchal Agarwal wrote:
>>>> On Tue, Sep 22, 2020 at 12:18:05PM -0400, boris.ostrovsky@oracle.com wrote:
>>>>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>>>>
>>>>>
>>>>>
>>>>> On 9/21/20 5:54 PM, Anchal Agarwal wrote:

>>>>> Also, wrt KASLR stuff, that issue is still seen sometimes but I haven't had
>>>>> bandwidth to dive deep into the issue and fix it.
>>
>> So what's the plan there? You first mentioned this issue early this year and judged by your response it is not clear whether you will ever spend time looking at it.
>>
> I do want to fix it and did do some debugging earlier this year just haven't
> gotten back to it. Also, wanted to understand if the issue is a blocker to this
> series?


Integrating code with known bugs is less than ideal.


3% failure for this feature seems to be a manageable number from the reproducability perspective --- you should be able to script this and each iteration should take way under a minute, no?


> I had some theories when debugging around this like if the random base address picked by kaslr for the
> resuming kernel mismatches the suspended kernel and just jogging my memory, I didn't find that as the case.
> Another hunch was if physical address of registered vcpu info at boot is different from what suspended kernel
> has and that can cause CPU's to get stuck when coming online. 


I'd think if this were the case you'd have 100% failure rate. And we are also re-registering vcpu info on xen restore and I am not aware of any failures due to KASLR.


> The issue was only
> reproducible 3% of the time out of 3000 runs hence its hard to just reproduce this.
>
> Moreover, I also wanted to get an insight on if hibernation works correctly with KASLR
> generally and its only Xen causing the issue?


With KASLR being on by default I'd be surprised if it didn't.


-boris

