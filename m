Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3861144CA3
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 08:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgAVHvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 02:51:46 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:4274 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgAVHvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 02:51:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579679505; x=1611215505;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=mpadmLr9FtxKUfJDghn8pAijhZNwbgE7Xd9vSf5WDx8=;
  b=NiSnd81dtkoTGcCFk7oNoRiDNjBOsAKQTt/DLpG6EQHMb3VGlzOlVQiz
   0e/d6weduzK3/gSso6yW8NK1i/9buAVRjPv0X8mV3W7mtkyuCWnbrRwlZ
   GfPub/LNwhH64wITe9giiUoaZyvCJck7y2xj1A9SS6tc6Jd08gWbdCvFq
   s=;
IronPort-SDR: e+HJFBEvQg6YHvUdR1shvxFbQ6/HUXVljYULbq8xH6II9zGPWxANTuvaWyLwiigJzzv2jl04kt
 1qBtZTIi1mlg==
X-IronPort-AV: E=Sophos;i="5.70,348,1574121600"; 
   d="scan'208";a="13638237"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 Jan 2020 07:51:43 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 9A29EA1844;
        Wed, 22 Jan 2020 07:51:42 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Wed, 22 Jan 2020 07:51:42 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.162.224) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 22 Jan 2020 07:51:37 +0000
Subject: Re: [PATCH rdma-next 07/10] RDMA/efa: Allow passing of optional
 access flags for MR registration
To:     Yishai Hadas <yishaih@dev.mellanox.co.il>
CC:     Yishai Hadas <yishaih@mellanox.com>, <linux-rdma@vger.kernel.org>,
        <jgg@mellanox.com>, <dledford@redhat.com>, <saeedm@mellanox.com>,
        <maorg@mellanox.com>, <michaelgur@mellanox.com>,
        <netdev@vger.kernel.org>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
 <1578506740-22188-8-git-send-email-yishaih@mellanox.com>
 <6df1dbee-f35e-a5ad-019b-1bf572608974@amazon.com>
 <89ddb3c3-a386-1aa4-e3e4-a4b0531b0978@dev.mellanox.co.il>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <b5540297-cc8d-c8fa-1934-a25f708e273c@amazon.com>
Date:   Wed, 22 Jan 2020 09:51:32 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <89ddb3c3-a386-1aa4-e3e4-a4b0531b0978@dev.mellanox.co.il>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.162.224]
X-ClientProxiedBy: EX13D21UWB001.ant.amazon.com (10.43.161.108) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/01/2020 18:57, Yishai Hadas wrote:
> On 1/21/2020 6:37 PM, Gal Pressman wrote:
>> On 08/01/2020 20:05, Yishai Hadas wrote:
>>> From: Michael Guralnik <michaelgur@mellanox.com>
>>>
>>> As part of adding a range of optional access flags that drivers need to
>>> be able to accept, mask this range inside efa driver.
>>> This will prevent the driver from failing when an access flag from
>>> that range is passed.
>>>
>>> Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
>>> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
>>> ---
>>>   drivers/infiniband/hw/efa/efa_verbs.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/infiniband/hw/efa/efa_verbs.c
>>> b/drivers/infiniband/hw/efa/efa_verbs.c
>>> index 50c2257..b6b936c 100644
>>> --- a/drivers/infiniband/hw/efa/efa_verbs.c
>>> +++ b/drivers/infiniband/hw/efa/efa_verbs.c
>>> @@ -1370,6 +1370,7 @@ struct ib_mr *efa_reg_mr(struct ib_pd *ibpd, u64 start,
>>> u64 length,
>>>           IB_ACCESS_LOCAL_WRITE |
>>>           (is_rdma_read_cap(dev) ? IB_ACCESS_REMOTE_READ : 0);
>>>   +    access_flags &= ~IB_UVERBS_ACCESS_OPTIONAL_RANGE;
>>
>> Hi Yishai,
>> access_flags should be masked with IB_ACCESS_OPTIONAL instead of
>> IB_UVERBS_ACCESS_OPTIONAL_RANGE.
>>
> 
> You are talking from namespace point of view, right ? both have same value.
> 
> If it's important, can you send some patch to replace ?

I'll send a patch, thanks.
