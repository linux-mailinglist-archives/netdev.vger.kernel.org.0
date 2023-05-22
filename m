Return-Path: <netdev+bounces-4294-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7497A70BEA8
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:47:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FFC9280FDF
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:47:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A24412B98;
	Mon, 22 May 2023 12:47:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8A912B70
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:47:41 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20626.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::626])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5096B8F
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 05:47:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/HRqUOlPZKFVqb4VrtUd9vdHZXuuUHCIltxELZnuGyPwh2vY7U2mVFnKZb6tDOEenglQtSQt1/W6K9DoCcL70f8Q+K89VzXRo6LVWS57o1InMSjNvsAOpFRqgShCFEdbHXJnyaKtX6tTRMpOgvTKstWHBV3NIiuclFAnERL2huqdoP4iPhVKFGxvnMlWBD3bzi970ASXQ7E1qFbpZ22DK67w32AggfGVFsjZWqrxB2C7trHITEKHKk1o4wnWIMtGqtC1RGnCBUafwo6epFhjk7joKxHrPH79U44oSnsM8cO1XOt4kOM2BU8/eKGUDweYJmNsxB8knLlsfkUk0ZNRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UerZqYx4EKtxFAgXpqJkYJDwdSJ8rL1q1BnySGjysNI=;
 b=MByaXXq+YttDwC2eytS7KbO7EwpWLpQxJaIQBuVQPIACs6eamk4WOY0DjsoCE14D7ZHBJZkqiWfTU9rkMEIh+ejWSkxOZjq0oVrFjoCzpQbkYc6xComy9YzsaA8OQrpO7Km/5gQI50yiYkjzjyV2vbnm4pBz+kDqDrtGmmIL8UnyKx428HX3vHPK5hQTKmci97aVdtkrcYc45vO4TnZSQfIwI1k7q2TsF5vBSD9gZEzjhc6l9PR8p7XvLamyBXOCblQkQqJT2Uxnwic0ybaybk1W64aNvE2LLuVVf8zF4+YKrz2/U5X8prJm0/tgtuPcmp1RXgnr0dmXlJ/wAs8rHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UerZqYx4EKtxFAgXpqJkYJDwdSJ8rL1q1BnySGjysNI=;
 b=uX4yLlYsFQes64lckU8+mF0enUxPECdwvQD3F0X3lv9G1lY+g5LWj0hudIDb8ax0cowVzRBNQM18y+2k3fHZKTWrTrSrD3F6U5c2DL45L01MVKQnugDhYnfoq6kLhdlvi7PAIxkjRRcNn3DW5lpAbMd+H1p51GhcZYAn4Up/tfaVd5iAdu8QR1YRgj2oTcEQWdzxs9M8X7oeiHFlhpIDpGJ/zt/htUGLb1PH+mhl6aPNu8sJSnvvuUSfhv4AQtBBXbVADF/yR7BeWvBTdPQWcprbrsLGgRqsm6jIrVHRSKN6KTHfAatP9K8dFl29PpQirqmPnsW4CcclVgEYWiZloA==
Received: from SJ0PR03CA0050.namprd03.prod.outlook.com (2603:10b6:a03:33e::25)
 by SN7PR12MB8171.namprd12.prod.outlook.com (2603:10b6:806:322::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 12:47:37 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:33e:cafe::49) by SJ0PR03CA0050.outlook.office365.com
 (2603:10b6:a03:33e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28 via Frontend
 Transport; Mon, 22 May 2023 12:47:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28 via Frontend Transport; Mon, 22 May 2023 12:47:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 22 May 2023
 05:47:20 -0700
Received: from [10.80.21.140] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 22 May
 2023 05:47:18 -0700
Message-ID: <89831a73-89c5-c5b6-d345-72908d8db304@nvidia.com>
Date: Mon, 22 May 2023 15:47:15 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next] net/mlx5: Introduce SF direction
To: Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>, Saeed Mahameed <saeedm@nvidia.com>,
	<netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>
References: <20230519183044.19065-1-saeed@kernel.org>
 <20230519214101.2452af83@kernel.org>
Content-Language: en-US
From: Shay Drory <shayd@nvidia.com>
In-Reply-To: <20230519214101.2452af83@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT012:EE_|SN7PR12MB8171:EE_
X-MS-Office365-Filtering-Correlation-Id: 718071ea-b98a-4703-b442-08db5ac2b864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1RrbhF0FEMDJCDdihF8AEq1+x/zgUB5bbHhbTkuclAk84E1BfGaL5aURqbSH9SfJdKA1E8JpcMlwDXXIRAez+uEXrvUXIQyPpRzlPOnCjxeDJBPfrjB9mEffKjyFsOGMQOObTqfp0VuQXpGQk63Rrllf8/p4kEwhT8unJGVZ0g/cuqc9EoJhR/hTgwePk2aOqdey3zOxIL/rnS7l5kRUyz+c6J6d2kVlVPkxo0Ha1F42JSjkGewqkXm1+Bxc5MJ+o50b5ScICaYZgdBaCRToXEo0jPgrokFVM0yWBwQ8VhOr1gZUgfsa3+WpHZD2FG41nxsuQCgFOz9y83zRS0I2vvaTfxwrE+snj7EtQaLrLiIBjZK2tjmdGySPfoHGKn2958Y5Gjp5tY3vXWVN3DX+6hnEAIObQy/o3Wf3+ivDRp0jzok98FlLhpjICA48/T5fxpjLNGdJy6HYEdgmjX7E3Mkw0Rnd+cCZl9toND6LD4H9QAT7xlxshbuNEXNMNKcaWvrznglLCp1Ssizd2nBQv0ld1tmzt26U1Kepq48rwZEczKtcXwJjrGb8TUDLKifsjT2EEOQHaIxtpkMCKsNYLBNtw25t0RV5vkRN3YDODvYE9j4C+QIeOGmbqinsmRi9ANEBo+7kYgKESmQKI5+FnAFxSb3E1ltserEvvCKrigAcYoYFA4QIgQterVBVvmhTzViQ7M52DVHLBftFIgoKhi8oZUupYJzcx57+ycOkk7ihYKK0lxJQn490puJeYuRQL9I44ocGLNCOT62KrMnO5Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(31686004)(2906002)(5660300002)(83380400001)(8676002)(8936002)(82310400005)(36756003)(70586007)(70206006)(4326008)(110136005)(54906003)(316002)(16576012)(478600001)(41300700001)(6666004)(40480700001)(426003)(86362001)(336012)(26005)(31696002)(2616005)(107886003)(356005)(82740400003)(36860700001)(47076005)(186003)(16526019)(53546011)(7636003)(40460700003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 12:47:36.5257
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 718071ea-b98a-4703-b442-08db5ac2b864
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8171
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 20/05/2023 7:41, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Fri, 19 May 2023 11:30:44 -0700 Saeed Mahameed wrote:
>> Whenever multiple Virtual Network functions (VNFs) are used by Service
>> Function Chaining (SFC), each packet is passing through all the VNFs,
>> and each VNF is performing hairpin in order to pass the packet to the
>> next function in the chain.
>>
>> In case one mlx5 NIC is servicing multiple VNFs of the SFC, mlx5 need
>> user input in order to optimize this hairpin to a simple forward rule.
>>
>> The optimization is performed by binding two PCI SFs to each VNF, as
>> can be seen bellow:
>>
>>               -----------          -----------
>>               |   VNF1  |          |   VNF2  |
>>               -----------          -----------
>>                  |  |                 |  |
>>         (Net) SF1|  |SF2     (Net) SF3|  |SF4
>>                  |  |                 |  |
>>               -------------------------------
>>               | /   \________________/    \ |
>>      uplink---|/                           \|----host
>>               |                NIC(SFC)     |
>>               |                             |
>>               -------------------------------
>>
>> Define SF1 and SF3 as SFs with network direction tell the driver to
>> configure the E-switch in a way that the packet arriving from SF1 will
>> do forward to SF2 instead of hairpin.
>>
>> This marking is done via sfnum command line argument, where bit 16
>> marks the SF as facing the Network, and bit 17 marks the SF as
>> facing the Host.
> What does it mean that an SF is "facing" the network?


Facing the physical wire, like an UPLINK vport.

> Why can't the device automatically "optimize" the hairpin?


Our FW/HW can do steering optimization if we know the direction in advance.

> Or SF1 / SF2 will be uni-directional after this patch?


No. every SF will continue to be bi-directional. the change will only 
affect steering optimization.

> --
> pw-bot: cr

