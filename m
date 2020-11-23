Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EBA2C0D6A
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 15:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbgKWO0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 09:26:05 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10508 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730597AbgKWO0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 09:26:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbbc67f0000>; Mon, 23 Nov 2020 06:26:07 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 23 Nov
 2020 14:26:04 +0000
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 23 Nov 2020 14:26:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/WKIejlMVzn6qRT54ZzZhRFdPmX8JaJr0wydAgEi8MbRUts232ngrOyqEi2z+9LTqWC66/Y6Tsbl9O+AvGkghtxtm9s4Zugzp5k4hHGQlfwC8dAArPzaziq6lo0eOYRv1yy7oF86u/Pa2UYjou+OVYzsIYkZi2w+nWsrbv3WLUyxhqoUhuaNPM2l0W6t4cEv/lv24Sa6UGS/0trLwXliWA6NM2pU/nSzZDV0fU9lgonHX3p8q+wALHvb+P9RvyqlE/JPlOdqKeNlTChJHc87xEo0ZdWy5+4/6bDbNNfU+8YnH76p9kcZJBQ682T3010SaTKMxirL1ZO+/ohLyDxrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t9g/+ANM13Dd7AFIX9QFifJ0Zzs7LGDlOOCaCxD+FV0=;
 b=agcJVg9HYvQuuU/XOUDejSKChySrJiJgVTzDjzjtuS32Jz8jsvqBAU4x5BGwP+dUJXV1LzLm0xqC+H4HDY+g83HS/oferuINcPGp59eTIYY6YU3eSi/F0yA8yp6E4hH6iQKTSK11MgxCFXFGjYMyzJHopGCUuGqHunAfqs/gw4S+sTQwgm/A02FRJCmnYtGY/yT8z3q6Jf8wwoTgCDQhwCG7B6onEmLs8o2SoDcZHH/OVi/XzpzzCzQe9IzPziR41NIn2nL8ACu6tXOVOrVDZ0KbsvGaQW1E4XunlfxfMMqobxkIY9skTAyLeYBUQJ2O+D+xJ8F2SM3IeYogIPDgGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM6PR12MB2780.namprd12.prod.outlook.com (2603:10b6:5:4e::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.24; Mon, 23 Nov 2020 14:26:02 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3589.028; Mon, 23 Nov 2020
 14:26:02 +0000
Subject: Re: [PATCH net-next] bridge: mrp: Implement LC mode for MRP
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <roopa@nvidia.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
References: <20201123111401.136952-1-horatiu.vultur@microchip.com>
 <5ffa6f9f-d1f3-adc7-ddb8-e8107ea78da5@nvidia.com>
 <20201123123132.uxvec6uwuegioc25@soft-dev3.localdomain>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <13cef7c2-cacc-2c24-c0d5-e462b0e3b4df@nvidia.com>
Date:   Mon, 23 Nov 2020 16:25:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <20201123123132.uxvec6uwuegioc25@soft-dev3.localdomain>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0097.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::12) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.83] (213.179.129.39) by ZR0P278CA0097.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Mon, 23 Nov 2020 14:25:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3813e70c-1516-4d61-e7d6-08d88fbbb450
X-MS-TrafficTypeDiagnostic: DM6PR12MB2780:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2780596C3CC698F3B72BB49ADFFC0@DM6PR12MB2780.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s8jkgl4VllEkMsSNjj7PPoOq3h+z2lHm5B8HDbwmbh7eomFaDzKj1bGXqwGDkpkRFr4OjmsWSgnHVJoxiZeggKjmDrUGQbNH0QTFebMHaH/WfBnIfduyiQoqtSzPs2mAywtv92h/4FTIqqhu5L0Jnd0HiOEOadWXRkClV1k3fQPanB4KujYyBRhnZhu8KQBhhiRoU4o/dEEZrXS0YlXWCJN0K9c5L2tgYntE3Za9bRiz54hGePfMIR/dfWZxYDJpyT9hUi2Lzo67fnLBHaNuvrUqLn6/2l/yoivm1292Wec+ExilDQECX3SrIEQ2Dv3+rrhVRajw7zv7vYgJQmo0Rlb5IJX2CN3gVKHUCxO2KVzMwQ6vJIk+sUMFBD5YdEbt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(346002)(136003)(376002)(2906002)(36756003)(186003)(4326008)(8936002)(53546011)(6486002)(16526019)(8676002)(316002)(26005)(2616005)(16576012)(83380400001)(956004)(478600001)(66946007)(66556008)(31686004)(66476007)(86362001)(6916009)(31696002)(6666004)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mkG2EisYR0Iq9A1LywM9ov2xoXuAANw140exRXeThMqBuT/PFMw5rC0aPRtZGcHIrhlcGh3pYKqjUq4BWbsY8FBdrK9pP4w6F+zQczI2W7S80e/EreyAhiLZ1wpMJP6Aik+iNK6vj5vRtYdyTMXS4iGAzmYmXPbgcwV2r/TLLsPhCERaQaNaPV8TtG12wKpGBovs/MmWEqOJnngefNrA8+QRUEn/7Y9qNGVlhtmAqD9ifSvJzthw+WOUFQLSpZL5IpH5ptZDMZj9UL7gFXgL6He7npGBALIkgJcoOTV6wPwdUv0Ds5leZoWvuvZlw+gn1efeeBSbkTmb635BhzGLG/wEiHofw/+Rmr4El2uRXI3FiDQIrKgTenmwZpaS3uRZwO3Tg6XAx9aQN6+f6bv8bWb3Hs5LpCmEGBhQ6eVhezDLro5HITxB108302Ekpt7hk1zQqb6PoRMXb9BIu0PNoapza+I58X5GAPr18r7nuj19LdILaPZ5o7hoY2jrECzp1xRBL1D5gX4V9JIXDQSOIWGhKrcAoWiDmvjxIBjmhvoHyaEmjDgFHHiFh3OWZTVea/inXPNSBMdEfZqCY+SszSGj4RdZDuOKQC+KEoOykqRiVpXy02r5+LUxAKujVmsI2hfQ+uRC0jUdZGqI5QOPEA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3813e70c-1516-4d61-e7d6-08d88fbbb450
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2020 14:26:02.4270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jehMCAmls/u7QPXXoTQU80mTwxZ9GV9W+16Av4kzfnRVJqFlB4w/iC/SyQ81bYSQxVMS7SLQhjFM7uzzBGf0sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2780
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606141567; bh=t9g/+ANM13Dd7AFIX9QFifJ0Zzs7LGDlOOCaCxD+FV0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=qQjRRjhlQrPEVOY/mUe281ZY7gCs/AXrR1dQ8dm3D8r9EZcUvJios4qoImVIVp79e
         Vl/9BywJKUd57Ug1BfGyVuFxIErXg+RUO/WIuAsnEUuneEwHOg310MqxSpp2VNYZ5h
         sbqeiUv4CJw4FYRMtHAoVbT6E03MgoyFdltTwAFi9ySzs2XYTuZvkCD3IpWVRuzgoD
         TQ305FTCh8Sn//ndkTogQzdNEG3ODpIGRQs5+TR+axdc4x1LGPMQimOP5Odum9ARnp
         TxSL+zFNpuT6asiKEgE3iJk6pj3+NraslDAfbk0CTmLb7oS7QWgAuismJtaD7ACamB
         hf9PFQqA0U33g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/11/2020 14:31, Horatiu Vultur wrote:
> The 11/23/2020 14:13, Nikolay Aleksandrov wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On 23/11/2020 13:14, Horatiu Vultur wrote:
>>> Extend MRP to support LC mode(link check) for the interconnect port.
>>> This applies only to the interconnect ring.
>>>
>>> Opposite to RC mode(ring check) the LC mode is using CFM frames to
>>> detect when the link goes up or down and based on that the userspace
>>> will need to react.
>>> One advantage of the LC mode over RC mode is that there will be fewer
>>> frames in the normal rings. Because RC mode generates InTest on all
>>> ports while LC mode sends CFM frame only on the interconnect port.
>>>
>>> All 4 nodes part of the interconnect ring needs to have the same mode.
>>> And it is not possible to have running LC and RC mode at the same time
>>> on a node.
>>>
>>> Whenever the MIM starts it needs to detect the status of the other 3
>>> nodes in the interconnect ring so it would send a frame called
>>> InLinkStatus, on which the clients needs to reply with their link
>>> status.
>>>
>>> This patch adds the frame header for the frame InLinkStatus and
>>> extends existing rules on how to forward this frame.
>>>
>>> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
>>> ---
>>>  include/uapi/linux/mrp_bridge.h |  7 +++++++
>>>  net/bridge/br_mrp.c             | 18 +++++++++++++++---
>>>  2 files changed, 22 insertions(+), 3 deletions(-)
>>>
>>
>> Hi Horatiu,
>> The patch looks good overall, just one question below.
> 
> Hi Nik,
> 
> Thanks for taking time to review the patch.
> 
>>
>>> diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
>>> index 6aeb13ef0b1e..450f6941a5a1 100644
>>> --- a/include/uapi/linux/mrp_bridge.h
>>> +++ b/include/uapi/linux/mrp_bridge.h
>>> @@ -61,6 +61,7 @@ enum br_mrp_tlv_header_type {
>>>       BR_MRP_TLV_HEADER_IN_TOPO = 0x7,
>>>       BR_MRP_TLV_HEADER_IN_LINK_DOWN = 0x8,
>>>       BR_MRP_TLV_HEADER_IN_LINK_UP = 0x9,
>>> +     BR_MRP_TLV_HEADER_IN_LINK_STATUS = 0xa,
>>>       BR_MRP_TLV_HEADER_OPTION = 0x7f,
>>>  };
>>>
>>> @@ -156,4 +157,10 @@ struct br_mrp_in_link_hdr {
>>>       __be16 interval;
>>>  };
>>>
>>> +struct br_mrp_in_link_status_hdr {
>>> +     __u8 sa[ETH_ALEN];
>>> +     __be16 port_role;
>>> +     __be16 id;
>>> +};
>>> +
>>
>> I didn't see this struct used anywhere, am I missing anything?
> 
> Yes, you are right, the struct is not used any. But I put it there as I
> put the other frame types for MRP.
> 

I see, we don't usually add unused code. The patch is fine as-is and since
this is already the case for other MRP parts I'm not strictly against it, so:

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

If Jakub decides to adhere to that rule you can keep my acked-by and just remove
the struct for v2.

Thanks,
 Nik

