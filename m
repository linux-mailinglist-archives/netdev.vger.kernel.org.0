Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4169D38E260
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 10:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhEXIgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 04:36:33 -0400
Received: from mail-dm6nam10on2065.outbound.protection.outlook.com ([40.107.93.65]:58208
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232313AbhEXIgc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 04:36:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ux3TeafpfP9PsWq6nt9Q0aHn/0DDq33wTjlsh/t9rgAFZ68U58wtKjrmzlEr9So5oZU7NoP60vgemqctPy9TQ8cyJqInIELn9fAcQUo4l2pq2Ewe4eQbUdYw6ZD4K2gDH03ITxPt4QAeJ8+zgoi0Wb5pKCYXWTUN99wsvyE8uYZPrgrAh2mptoGwfQiio0vV/Hmj/EoEX44+SBJrpW3vem8xQezLJM/c6z27Qs8XU808cDVfbPRvlMP8PDWMKQxHD8KoE4IrDUt/iHZHfnGSz9SvsTBXFuLWgX37RUD41d1k8d8NHTkruBlaparBKis0PbNsHc5hXXBHfMwsucHjNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1Mz+KO6pc1R+M0gRZVplDVFmHeVJjtJLKbqIGv19Es=;
 b=MaFOg4yjOPVQSmgMjuPTrdtmEXgLClre+yJ9I2KIy6fwzquYVRwvG27CWfzIcNoJ5a/EfgQVwjfGbOa1Ch/m9+M3Mqv8q4gleyVc/eLtNV/kqQs5hvVyQrzLM4b4sHIcmIwT/EwBcOP691KhlqCsKqQD1brHLlWU2N7i6w/iYz4B/ogyvlr/uPvA3lKtPIHOg7tiqSrESSD0KvWdYj12qmqQ0JJzfwXUjdNimt6Za2j0Z/UPgUnzIhqo1IckYgkEcM0lGYlngeyQXqz5S6DLFnMZx3U89+0cpVWKnxUhBAXLu5lVBssHaBGPLYVJGOsL/k3DK7rdv5xI8xGqtJnVtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1Mz+KO6pc1R+M0gRZVplDVFmHeVJjtJLKbqIGv19Es=;
 b=ek9aFYg9kypqtmtfqrR9xWWkE3YhbVof3RSU4DYjKX4ZZ8xx0E4kghMTi7coqkQk1lgaTAwhlOm0AQBldGq5aLZDcs4cLqmup+aPKPkyouGmEibk47HCjkQTYRs6KRbI7Sl2QW8nrJ/sVm4YkSNLB6tkWrcprSG2OkNoRR5VL9usMirEbf3EQx9pRRtPlGmlAC8kiwwftfxls6ej4nSxPdANzFKlS0j7AwzQx+JJgHycPPUjb3ekWd4RJS477LfZne6Ifv4cDQ/teVPtvD1jo9PHHttIBD/Jx66OMBeq8NT63Ud/sdcDmyyqQKDpBdSaip4Z1iVAG829IRRFYfYZDw==
Received: from MW4PR03CA0039.namprd03.prod.outlook.com (2603:10b6:303:8e::14)
 by CY4PR1201MB0152.namprd12.prod.outlook.com (2603:10b6:910:1b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Mon, 24 May
 2021 08:35:03 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::d7) by MW4PR03CA0039.outlook.office365.com
 (2603:10b6:303:8e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Mon, 24 May 2021 08:35:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 24 May 2021 08:35:01 +0000
Received: from [172.27.15.6] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 May
 2021 08:34:59 +0000
Subject: Re: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
To:     Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Guodeqing (A)" <geffrey.guo@huawei.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>
References: <1621821978.04102-1-xuanzhuo@linux.alibaba.com>
 <36d1b92c-7dc5-f84e-ef86-980b15c39965@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <1f23afa3-645e-81b6-76da-94c7806ef6ed@nvidia.com>
Date:   Mon, 24 May 2021 11:34:56 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <36d1b92c-7dc5-f84e-ef86-980b15c39965@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1c28f5e-ad72-4375-fc2c-08d91e8ed2b2
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0152:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0152FC9BBCFADA449490BDF0DE269@CY4PR1201MB0152.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /W1ACLMMZKwqFTGgEZsp9S4ELQTecL/aKsNpSiYRjOUSs29VtIUqpglyOE5tIVk6sBKimjsD/xXsB/XcRGvi3LEfrm5GIhILLE1yaA9R59HUHPe7nQ7o3YxUvBTYzNehAhmabLJ2eJztpKDCO/oWBn3hV019mm/0TBS3L62PyBYFsAlge8lrJ/c92aKZYIJAcjkayv0v8WKUtGk2y2N+KD7Ce/WVbvkRkbhQaOW332drd5HS/TzXb8bOgtC/kXOSMKWGrevdUkuXBBRv/qnV/Bd7a89GnqH4GILFQWm4lkRBRiMQ0cjMO9wfnqgTu8rasIgR4qAJgjkmMQwGAur5mRoJvBUctJSnxzu8+x/yvGTMnkWFnBNw9f4ODJ7XTCXETSY4wGickQC3dy54evkU3SzMdU8L+oP5HlpsUD6ffK8oW3D8g82Jx5yh4ah4119zDLUTFbohki7OXqOxBrp/J4+Sy4gc6d8sRH0tlD9RcaU3yt5MIDjRv5G9W3B7q/X+Hdbe2/gYXY2hcGg+nvXWfB+mNaACcQ5mPy7f37BhU4LrWWsB9YWyZ6FH4deANlc1j4Xqq8NLK+XnYPDnRqZ26oEHMSpUxcLTttvn3MR6DLNPxj8FVExyD7l5z9xWopNVT886GG+bPyWm+qUHegT/3WTOQ+C8Ll+0DD0FD1s0F5ibntcNBGZcOxrKGTR4kho/
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(346002)(36840700001)(46966006)(478600001)(54906003)(110136005)(6666004)(4326008)(53546011)(5660300002)(2906002)(31696002)(86362001)(16526019)(70206006)(356005)(186003)(16576012)(36860700001)(36906005)(316002)(70586007)(47076005)(82310400003)(82740400003)(31686004)(2616005)(7636003)(83380400001)(336012)(8676002)(426003)(8936002)(36756003)(26005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 08:35:01.7201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1c28f5e-ad72-4375-fc2c-08d91e8ed2b2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0152
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/24/2021 5:37 AM, Jason Wang wrote:
>
> 在 2021/5/24 上午10:06, Xuan Zhuo 写道:
>> On Mon, 24 May 2021 01:48:53 +0000, Guodeqing (A) 
>> <geffrey.guo@huawei.com> wrote:
>>>
>>>> -----Original Message-----
>>>> From: Max Gurtovoy [mailto:mgurtovoy@nvidia.com]
>>>> Sent: Sunday, May 23, 2021 15:25
>>>> To: Guodeqing (A) <geffrey.guo@huawei.com>; mst@redhat.com
>>>> Cc: jasowang@redhat.com; davem@davemloft.net; kuba@kernel.org;
>>>> virtualization@lists.linux-foundation.org; netdev@vger.kernel.org
>>>> Subject: Re: [PATCH] virtio-net: fix the kzalloc/kfree mismatch 
>>>> problem
>>>>
>>>>
>>>> On 5/22/2021 11:02 AM, guodeqing wrote:
>>>>> If the virtio_net device does not suppurt the ctrl queue feature, the
>>>>> vi->ctrl was not allocated, so there is no need to free it.
>>>> you don't need this check.
>>>>
>>>> from kfree doc:
>>>>
>>>> "If @objp is NULL, no operation is performed."
>>>>
>>>> This is not a bug. I've set vi->ctrl to be NULL in case !vi->has_cvq.
>>>>
>>>>
>>>    yes,  this is not a bug, the patch is just a optimization, 
>>> because the vi->ctrl maybe
>>>    be freed which  was not allocated, this may give people a 
>>> misunderstanding.
>>>    Thanks.
>>
>> I think it may be enough to add a comment, and the code does not need 
>> to be
>> modified.
>>
>> Thanks.
>
>
> Or even just leave the current code as is. A lot of kernel codes was 
> wrote under the assumption that kfree() should deal with NULL.
>
> Thanks
>
>
exactly.


>>
>>>>> Here I adjust the initialization sequence and the check of 
>>>>> vi->has_cvq
>>>>> to slove this problem.
>>>>>
>>>>> Fixes:     122b84a1267a ("virtio-net: don't allocate control_buf 
>>>>> if not
>>>> supported")


"Fixes" line should be added only if you fix some bug.


>>>>> Signed-off-by: guodeqing <geffrey.guo@huawei.com>
>>>>> ---
>>>>>    drivers/net/virtio_net.c | 20 ++++++++++----------
>>>>>    1 file changed, 10 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c 
>>>>> index
>>>>> 9b6a4a875c55..894f894d3a29 100644
>>>>> --- a/drivers/net/virtio_net.c
>>>>> +++ b/drivers/net/virtio_net.c
>>>>> @@ -2691,7 +2691,8 @@ static void virtnet_free_queues(struct
>>>>> virtnet_info *vi)
>>>>>
>>>>>        kfree(vi->rq);
>>>>>        kfree(vi->sq);
>>>>> -    kfree(vi->ctrl);
>>>>> +    if (vi->has_cvq)
>>>>> +        kfree(vi->ctrl);
>>>>>    }
>>>>>
>>>>>    static void _free_receive_bufs(struct virtnet_info *vi) @@ 
>>>>> -2870,13
>>>>> +2871,6 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
>>>>>    {
>>>>>        int i;
>>>>>
>>>>> -    if (vi->has_cvq) {
>>>>> -        vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
>>>>> -        if (!vi->ctrl)
>>>>> -            goto err_ctrl;
>>>>> -    } else {
>>>>> -        vi->ctrl = NULL;
>>>>> -    }
>>>>>        vi->sq = kcalloc(vi->max_queue_pairs, sizeof(*vi->sq), 
>>>>> GFP_KERNEL);
>>>>>        if (!vi->sq)
>>>>>            goto err_sq;
>>>>> @@ -2884,6 +2878,12 @@ static int virtnet_alloc_queues(struct
>>>> virtnet_info *vi)
>>>>>        if (!vi->rq)
>>>>>            goto err_rq;
>>>>>
>>>>> +    if (vi->has_cvq) {
>>>>> +        vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
>>>>> +        if (!vi->ctrl)
>>>>> +            goto err_ctrl;
>>>>> +    }
>>>>> +
>>>>>        INIT_DELAYED_WORK(&vi->refill, refill_work);
>>>>>        for (i = 0; i < vi->max_queue_pairs; i++) {
>>>>>            vi->rq[i].pages = NULL;
>>>>> @@ -2902,11 +2902,11 @@ static int virtnet_alloc_queues(struct
>>>>> virtnet_info *vi)
>>>>>
>>>>>        return 0;
>>>>>
>>>>> +err_ctrl:
>>>>> +    kfree(vi->rq);
>>>>>    err_rq:
>>>>>        kfree(vi->sq);
>>>>>    err_sq:
>>>>> -    kfree(vi->ctrl);
>>>>> -err_ctrl:
>>>>>        return -ENOMEM;
>>>>>    }
>>>>>
>
