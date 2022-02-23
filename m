Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2AA4C0C8B
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 07:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbiBWGb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 01:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbiBWGby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 01:31:54 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3059560CDD
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 22:31:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdsgufcqxQexiyyR0zSX6xfDLzRacznfu5GSVMGle04RLa/cLYVEu2/tvGF/9su/KkjcCP4A3/hUypYtDT6FwgPpurx98FWLOHK7KlzV4NaF35tsp0AMFPFJuAPVszo7D+xlICE3k+ke8adeYUeLY3+chhQqLb5aVK4DiuSPXRt/RtqdjGDbMkuA4cUoYDvwvLUlmz3hwKb0OGFmj40kyxA6l7LDLGRxPZvQPUHBgBM9ZoJdayE/AAavIJ5fM6+I50aEmT//IEBDTA6IKYG9WVqXvNx/LWZeXO1LV8J+03NZSUgV2Oc3sxT/43PuzIzBNHobzk5TAATJrfsM+ssAKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbRWJyPOqr9RHroLl5kabDzXgPfL7491JLtCjesEaYM=;
 b=Wi0UzOYv4A9LJoB78pJr9xAvrqD3Oj+yM3uuq/wBwZ3KFPBEAm3+IdHDgVyBKBnBlUzPKpXtYLQc8q9xLBv7fqnPPyyleO8tzS5167+QN60X/5DaqircyahTRzogiyo6CctEHfU64sGQf2SXOIlfsb7LkePlQh79Ow1wj5G4BpLRx8fTn276PhlnVRJcjw3GndxhYxPbgXUbVEOb8Rf0pxclFYcS1A1/3yWm3I1QRcFPCl98/uI5WHzYc5Y1YkJmlrZTNqf6ZreyRzY79oP0bYEeYPhXQPFH6/AB2P/B0G1OXs+fjJFRGFAiTfY1VAu0l822p+avhWugUJIg42D0gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbRWJyPOqr9RHroLl5kabDzXgPfL7491JLtCjesEaYM=;
 b=jxiW7L6Ne0ClTq8ovSN5cGngBjz1hEYVX0NZ0XeIOmEuABkbYB1sbtJ1KUu9OrZDGlwc0GRsMxs5bZlBKiXppzhG0oOB4MZupdP4tQYfpZnv/hT2hEA8VDEOtKPMfjV0e8oCo/iabpLLEWDBrE+XNdufj9qOS0QPgMHtMYnPbyyQUa/IjKVAdudng03j5vaw1xd4h5PwZ7sCh0eQqiBqxTZfYO9y8oqjUoSZy0RzUZgCsZoyDh28BKZA4VOnoqCBEr+nj/V2CfSSW0sCsEOk6bMpnvBRfXarfSIelAxnebJEt/RV1wp9e2EtdTovGYMxX7mtZPmPoZD4pXFeWJrTfw==
Received: from MWHPR15CA0042.namprd15.prod.outlook.com (2603:10b6:300:ad::28)
 by BL0PR12MB5508.namprd12.prod.outlook.com (2603:10b6:208:1c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 06:31:25 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ad:cafe::9b) by MWHPR15CA0042.outlook.office365.com
 (2603:10b6:300:ad::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Wed, 23 Feb 2022 06:31:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Wed, 23 Feb 2022 06:31:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Feb
 2022 06:31:21 +0000
Received: from [10.2.163.46] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 22:31:20 -0800
Subject: Re: [PATCH net-next v2 07/12] rtnetlink: add new rtm tunnel api for
 tunnel id filtering
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <stephen@networkplumber.org>, <nikolay@cumulusnetworks.com>,
        <idosch@nvidia.com>, <dsahern@gmail.com>, <bpoirier@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
 <20220222025230.2119189-8-roopa@nvidia.com>
 <20220222172630.44bba0d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <920ce92c-46e2-3b8a-4d0a-40daaf049b64@nvidia.com>
 <20220222195044.06313f11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <7184c4eb-7378-5ce3-f24e-4a8e9344aa87@nvidia.com>
Date:   Tue, 22 Feb 2022 22:31:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220222195044.06313f11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 766daa97-9547-44f3-fbd0-08d9f6961d32
X-MS-TrafficTypeDiagnostic: BL0PR12MB5508:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB550878F3B3301DB972A505A6CB3C9@BL0PR12MB5508.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: If8cyW2RJ5gmHWgqmfLc1Fjq6LktH5qvFZyyrMNIMR4AU37OtleAZEBpX/LSROGCGf2ylACVU/ujfgXuEznTdcPvGanOI7pWeCPKs8baCcrnmqCmzlyGyvjDdjRywSVLGQWlEfSNo1DRC86FfU38oWpHHm8PFXi0/6qEvwbRAOQp1V1X/UfW/kKfEbu5S20/ox19BMHWVAsJQnnh+reJElr+G8fadUXD+Osj27yz4jNo1blZLgFmhpZY00jH0qxcReb7kgDQZajWsf7hJV5VjZ9zT0TerjOvd9FJAOHFR1ecF/9fdAaG5lDpWeHIEH6J/M5IM1OYoHrtcpx97BMyQX9D16LJfzcIcGlPeM/Gv4Q52a2kzvc94llWIOr96YZ2VdV6ckxGUEvspt30up+sX60kkd05ToWLeZmylCP7lgjjkXcJR+qvxWKl3hwmo41k3WFxH4Oq9HF14k4V1zFxEsbsObR/LCzSTkSvOHkT5Tc38jd72F/HknYYLxJikXUmffK3tyuJUiDyDobAombcRjsYqUjyFi/7YWVlYIFyVRlMryVNkVnimJ8oqkiUUYJLZ5/qsWHWnFeLndZhh+Lx5rSU9rQVR5tzZPlFdD6Fn5xhopJEgcAAvPRhb/My+YzUQgQvPvZqoWt09acJhllxahVemO46dE2600mV4X25oQU8IoBTtTqrWQJt/1ROZvGk5L1Uj0Hfyq//6fC/gRnpRonVge8f5e1vsYyjkeFIasEXFwFTnOLkfMu5Ikv6MhNk
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(508600001)(82310400004)(107886003)(2616005)(47076005)(26005)(186003)(16526019)(53546011)(86362001)(2906002)(83380400001)(31696002)(336012)(36860700001)(426003)(54906003)(316002)(31686004)(356005)(5660300002)(8676002)(4326008)(8936002)(36756003)(40460700003)(81166007)(70206006)(70586007)(6916009)(16576012)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 06:31:24.3950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 766daa97-9547-44f3-fbd0-08d9f6961d32
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5508
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/22/22 7:50 PM, Jakub Kicinski wrote:
> On Tue, 22 Feb 2022 18:49:03 -0800 Roopa Prabhu wrote:
>> On 2/22/22 5:26 PM, Jakub Kicinski wrote:
>>> Why create new RTM_ commands instead of using changelink?
>>>
>>> I thought we had to add special commands for bridge because
>>> if the target of the command is not a bridge device but possibly
>>> a bridge port, which could be anything. That's not the case here.
>>>
>>> Is it only about the convenience of add/del vs changelink where
>>> we'd potentially have to pass and parse the entire vni list each time?
>> yes, exactly. that's the reason. My first internal version used
>> changelink and soon realized it was too limiting.
>>
>> especially notifications. Its too heavy to notify the full vni list
>> every-time.
>>
>> IIRC bridge also went through a similar transition. Now bridge also has
>> RTM_*VLAN commands.
> Makes sense. I wasn't quite sure if this isn't over-engineering
>   - do deployments really use VxLAN devs with many VNIs?


yes, vnis are unfortunately used to stretch layer 2 domains exceeding 
the 4k vlan limit

In the example provided in this series, vnis can be deployed in the 
ranges of more than 15k if each customer is allocated a 4k vlan range 
(bridge domain),

and a single switch can host 3-4 customers.

the scale is also the reason to switch to dst metadata devices when 
deployed vni numbers get large. The traditional vxlan netdev per vni 
does not work well at this scale.



>
>> Couldn't think of another way than adding a new msg. Tried to keep the
>> name generic for use by potentially other dst/collect metadata devices
> Ack, I don't have any better ideas either :)

