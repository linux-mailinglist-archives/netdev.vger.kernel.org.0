Return-Path: <netdev+bounces-6471-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7716716645
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:10:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E0A92811E6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90FD3261FE;
	Tue, 30 May 2023 15:09:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9F017AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:09:33 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A73E46;
	Tue, 30 May 2023 08:09:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ls9o0jfgQ5VXLNOIiQT7U1IP0QXaIUlBqiL2Ze4GG7EBm66pH6LiN+VaVqNnc0NvSx3IiiokyN/bSDt4nKtZ97xZhxU1dO83zwUKcJ1iq7LkEQjtJPGiCq4vFnIMXM/8Sinqj1WVsJf/IqNQxt/fpmyjiSyAOw1ojHZYUrmWERAdXbAg8HNkDFlBBUAZH4NNbvra+5E9YwO56Jzk15DfETuHXGGRz2bbH7EaRp0dBCjbRIbxqKia3+FE7bjLCA890e3xLoC1gKoYNvFN+L83ee5KoXUOmWDD7nS2QwWyU4KKH5W56Uli7X3KLu6doNPufXjqi34kyeWtbRnZasteIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/b4bRbjJyNlwlEqqjTXoOakEnz2PBdLODEYJN5zfyq0=;
 b=GQD49HiO7KK9em6wz4zTfU7BKHiGw5F36nVcFatC4aazJwkX29M10ZYgux2bdhc2qJK/m5MCj6MBIuYfgyOzn2ZWqhirUMLZSB+U9uxVp6+mLYF4t8M3f0IC4mQtlF8L5KORX/u0wf04T8zrgo3udhdeqKthlljmGpOtK3Z8Ky9rBSPheGnHGyFs60/JDC7GkDdPHcmSHaN/F5PYPystk9+MRpDCGPMoeEJlk945t6Zn2hUGUwkhh89tBDPsMf/54kNRUmUdazwLR8/utSLCZ1XrESutDQWc6dExicOiAsZsXTM+wL1X5ju0mS43RhBr0qR0FOyY1/SabciRIcrTJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/b4bRbjJyNlwlEqqjTXoOakEnz2PBdLODEYJN5zfyq0=;
 b=nh+pcSs6jVT2uNKXu/uC/j8HRV54gtnTM/6/I6veIUIaME/l5UPjDo7hXvNIgQQNgxLUD9bG8RF5Duz6lj53ukq4PBE/l/4ULDc0Drae+WBcrmcufAW/U4yu0jtFh5fXCjDnCuCmPThugNo4TQzet3viqZiKJK8fkOWaBiYYTb96eU/Ufx/h+knTFldOuz3yoCddtne1zeGBXkTDge8aE1lTCkxmvOIiiGhDSzsrSfhJ3o/rrL6RTZfgi1uC89Y9YB7GeGaM6yDtGBFcsRaSVjlK8qFkRTQ96Iq05GVs2oZCmMXzRaV78jSOjBbHmlBqnTDy8+ML89n6zrbBG+HU3w==
Received: from MW3PR05CA0010.namprd05.prod.outlook.com (2603:10b6:303:2b::15)
 by IA1PR12MB6649.namprd12.prod.outlook.com (2603:10b6:208:3a2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Tue, 30 May
 2023 15:08:46 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::1) by MW3PR05CA0010.outlook.office365.com
 (2603:10b6:303:2b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22 via Frontend
 Transport; Tue, 30 May 2023 15:08:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.22 via Frontend Transport; Tue, 30 May 2023 15:08:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 30 May 2023
 08:08:28 -0700
Received: from [172.27.0.60] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 30 May
 2023 08:08:25 -0700
Message-ID: <9d793d9f-0fca-2b0d-2a2e-abd527ffa8d4@nvidia.com>
Date: Tue, 30 May 2023 18:08:21 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: system hang on start-up (mlx5?)
Content-Language: en-US
To: Eli Cohen <elic@nvidia.com>, Chuck Lever III <chuck.lever@oracle.com>
CC: Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
	linux-rdma <linux-rdma@vger.kernel.org>, "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
 <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com> <875y8altrq.ffs@tglx>
 <0C0389AD-5DB9-42A8-993C-2C9DEDC958AC@oracle.com>
 <FD9A2C0A-1E3A-4D5B-9529-49F140771AAE@oracle.com>
 <DM8PR12MB54005117BF33730B4845DCD4AB4B9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <86B0E564-52C0-457E-A101-1BC4D6E22AC2@oracle.com>
 <DM8PR12MB540087BADA2458C51645E206AB4B9@DM8PR12MB5400.namprd12.prod.outlook.com>
From: Shay Drory <shayd@nvidia.com>
In-Reply-To: <DM8PR12MB540087BADA2458C51645E206AB4B9@DM8PR12MB5400.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT068:EE_|IA1PR12MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: a6335e34-1fda-4ce9-dee5-08db611fc3ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NFxpCAjcf1z4aUsj+seNzDBi4U2yD1y/MwmGoR/xf8lmXpS8/dfO1s865O+cozfotBzSRqDb5MfnbBrqSaJQrCaeKrKVNrNQMD+71eKKhT3Otqs8w60tSYAkuMiZ4vbEPF2n9zG9sGx9dhNEubfXRJTW+I7lLCcV6CXjAv8lBQmhXzkLL29R80JFe29wu+o36iZumhV8vIk1ceantKrwM3tczvxzadUpdvr8zO5HX75JQm+FTbC5w4jwVbDFEcPojjB7K+vDLtOMUuVAAX3hdBnBOVfVbW/jjupj5d161cF3zbyVdAONYqQNPSiUVRPL7J5G9n4S59joK5/dabVhg5rEre0M4oJq2XXuSN/L1E2BZ1Y57xnOSui3rfPjECoV0c3g2WbnJISRWhnphDhgDi3REtuAUj+1V84h8Ycb6Yq5uxIZqINiTlAgiuLSXZvCY4kO7UUbSn1JMFcZTUp8a3I0gbty4r7o7xCDpZq92CqqckT2LI0rjr6YClYCe3GCDjax0H+hG/oJJoUfjF2UOC4TXJOqjfWqwiMfqCQCmm3k3lLtq5sHXACrk5cwmqbSCiOOe0JNbUk8CmZuSVRzKRD6n8J5cxw5RiAh38NuY3uUk+3fjNM28cVTPi5rFsz+O2T6c/LhNlGwqWR4agBwQBoQ72qKUZ2HLR8tgMOoRf3MA5rwdhzElYhtUnrIUEd1m/iP+l81kF2V2MabgicHZMHgCv6hqTSstWFOYTZzK+mqCel6AU1NkeaiLPQokVq1H8MYl/kz/qfFd6YXxUAbmHjWmLiEklhnhglhaK0NP3iRgK6EuzHUME7LVRnppzLC
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199021)(36840700001)(40470700004)(46966006)(316002)(356005)(31686004)(83380400001)(70206006)(70586007)(36860700001)(54906003)(110136005)(16576012)(2906002)(966005)(26005)(7636003)(4326008)(82740400003)(31696002)(86362001)(426003)(336012)(47076005)(2616005)(478600001)(5660300002)(40460700003)(186003)(6666004)(16526019)(41300700001)(53546011)(36756003)(8936002)(8676002)(40480700001)(82310400005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 15:08:45.6196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6335e34-1fda-4ce9-dee5-08db611fc3ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6649
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 30/05/2023 16:54, Eli Cohen wrote:
>> -----Original Message-----
>> From: Chuck Lever III <chuck.lever@oracle.com>
>> Sent: Tuesday, 30 May 2023 16:51
>> To: Eli Cohen <elic@nvidia.com>
>> Cc: Shay Drory <shayd@nvidia.com>; Leon Romanovsky <leon@kernel.org>;
>> Saeed Mahameed <saeedm@nvidia.com>; linux-rdma <linux-
>> rdma@vger.kernel.org>; open list:NETWORKING [GENERAL]
>> <netdev@vger.kernel.org>; Thomas Gleixner <tglx@linutronix.de>
>> Subject: Re: system hang on start-up (mlx5?)
>>
>>
>>
>>> On May 30, 2023, at 9:48 AM, Eli Cohen <elic@nvidia.com> wrote:
>>>
>>>> From: Chuck Lever III <chuck.lever@oracle.com>
>>>> Sent: Tuesday, 30 May 2023 16:28
>>>> To: Eli Cohen <elic@nvidia.com>
>>>> Cc: Leon Romanovsky <leon@kernel.org>; Saeed Mahameed
>>>> <saeedm@nvidia.com>; linux-rdma <linux-rdma@vger.kernel.org>; open
>>>> list:NETWORKING [GENERAL] <netdev@vger.kernel.org>; Thomas Gleixner
>>>> <tglx@linutronix.de>
>>>> Subject: Re: system hang on start-up (mlx5?)
>>>>
>>>>
>>>>
>>>>> On May 30, 2023, at 9:09 AM, Chuck Lever III <chuck.lever@oracle.com>
>>>> wrote:
>>>>>> On May 29, 2023, at 5:20 PM, Thomas Gleixner <tglx@linutronix.de>
>>>> wrote:
>>>>>> On Sat, May 27 2023 at 20:16, Chuck Lever, III wrote:
>>>>>>>> On May 7, 2023, at 1:31 AM, Eli Cohen <elic@nvidia.com> wrote:
>>>>>>> I can boot the system with mlx5_core deny-listed. I log in, remove
>>>>>>> mlx5_core from the deny list, and then "modprobe mlx5_core" to
>>>>>>> reproduce the issue while the system is running.
>>>>>>>
>>>>>>> May 27 15:47:45 manet.1015granger.net kernel: mlx5_core
>> 0000:81:00.0:
>>>> firmware version: 16.35.2000
>>>>>>> May 27 15:47:45 manet.1015granger.net kernel: mlx5_core
>> 0000:81:00.0:
>>>> 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc:
>>>> pool=ffff9a3718e56180 i=0 af_desc=ffffb6c88493fc90
>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a3aefcf0f80 m-
>>>>> system_map=ffff9a33801990d0 end=236
>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a3aefcf0f60 end=236
>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_core
>> 0000:81:00.0:
>>>> Port module event: module 0, Cable plugged
>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc:
>>>> pool=ffff9a3718e56180 i=1 af_desc=ffffb6c88493fc60
>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_core
>> 0000:81:00.0:
>>>> mlx5_pcie_event:301:(pid 10): PCIe slot advertised sufficient power (27W).
>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a36efcf0f80 m-
>>>>> system_map=ffff9a33801990d0 end=236
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a36efcf0f60 end=236
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a36efd30f80 m-
>>>>> system_map=ffff9a33801990d0 end=236
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a36efd30f60
>> end=236
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a3aefc30f80 m-
>>>>> system_map=ffff9a33801990d0 end=236
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a3aefc30f60
>> end=236
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a3aefc70f80 m-
>>>>> system_map=ffff9a33801990d0 end=236
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a3aefc70f60
>> end=236
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a3aefd30f80 m-
>>>>> system_map=ffff9a33801990d0 end=236
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a3aefd30f60
>> end=236
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->managed_map=ffff9a3aefd70f80 m-
>>>>> system_map=ffff9a33801990d0 end=236
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->alloc_map=ffff9a3aefd70f60
>> end=236
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m-
>>>>> scratch_map=ffff9a33801990b0 cm->managed_map=ffffffffb9ef3f80 m-
>>>>> system_map=ffff9a33801990d0 end=236
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: BUG: unable to handle
>>>> page fault for address: ffffffffb9ef3f80
>>>>>>> ###
>>>>>>>
>>>>>>> The fault address is the cm->managed_map for one of the CPUs.
>>>>>> That does not make any sense at all. The irq matrix is initialized via:
>>>>>>
>>>>>> irq_alloc_matrix()
>>>>>> m = kzalloc(sizeof(matric);
>>>>>> m->maps = alloc_percpu(*m->maps);
>>>>>>
>>>>>> So how is any per CPU map which got allocated there supposed to be
>>>>>> invalid (not mapped):
>>>>>>
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: BUG: unable to handle
>>>> page fault for address: ffffffffb9ef3f80
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: #PF: supervisor read
>>>> access in kernel mode
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: #PF:
>> error_code(0x0000)
>>>> - not-present page
>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: PGD 54ec19067 P4D
>>>> 54ec19067 PUD 54ec1a063 PMD 482b83063 PTE 800ffffab110c062
>>>>>> But if you look at the address: 0xffffffffb9ef3f80
>>>>>>
>>>>>> That one is bogus:
>>>>>>
>>>>>>    managed_map=ffff9a36efcf0f80
>>>>>>    managed_map=ffff9a36efd30f80
>>>>>>    managed_map=ffff9a3aefc30f80
>>>>>>    managed_map=ffff9a3aefc70f80
>>>>>>    managed_map=ffff9a3aefd30f80
>>>>>>    managed_map=ffff9a3aefd70f80
>>>>>>    managed_map=ffffffffb9ef3f80
>>>>>>
>>>>>> Can you spot the fail?
>>>>>>
>>>>>> The first six are in the direct map and the last one is in module map,
>>>>>> which makes no sense at all.
>>>>> Indeed. The reason for that is that the affinity mask has bits
>>>>> set for CPU IDs that are not present on my system.
>>>>>
>>>>> After bbac70c74183 ("net/mlx5: Use newer affinity descriptor")
>>>>> that mask is set up like this:
>>>>>
>>>>> struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
>>>>> {
>>>>>        struct mlx5_irq_pool *pool = ctrl_irq_pool_get(dev);
>>>>> -       cpumask_var_t req_mask;
>>>>> +       struct irq_affinity_desc af_desc;
>>>>>        struct mlx5_irq *irq;
>>>>> -       if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL))
>>>>> -               return ERR_PTR(-ENOMEM);
>>>>> -       cpumask_copy(req_mask, cpu_online_mask);
>>>>> +       cpumask_copy(&af_desc.mask, cpu_online_mask);
>>>>> +       af_desc.is_managed = false;
>>>> By the way, why is "is_managed" set to false?
>>>>
>>>> This particular system is a NUMA system, and I'd like to be
>>>> able to set IRQ affinity for the card. Since is_managed is
>>>> set to false, writing to the /proc/irq files fails with EIO.
>>>>
>>> This is a control irq and is used for issuing configuration commands.
>>>
>>> This commit:
>>> commit c410abbbacb9b378365ba17a30df08b4b9eec64f
>>> Author: Dou Liyang <douliyangs@gmail.com>
>>> Date:   Tue Dec 4 23:51:21 2018 +0800
>>>
>>>     genirq/affinity: Add is_managed to struct irq_affinity_desc
>>>
>>> explains why it should not be managed.
>> Understood, but what about the other IRQs? I can't set any
>> of them. All writes to the proc files result in EIO.
>>
> I think @Shay Drory has a fix for that should go upstream.
> Shay was it sent?

The fix was send and merged.

https://lore.kernel.org/all/20230523054242.21596-15-saeed@kernel.org/
>>>>> Which normally works as you would expect. But for some historical
>>>>> reason, I have CONFIG_NR_CPUS=32 on my system, and the
>>>>> cpumask_copy() misbehaves.
>>>>>
>>>>> If I correct mlx5_ctrl_irq_request() to clear @af_desc before the
>>>>> copy, this crash goes away. But mlx5_core crashes during a later
>>>>> part of its init, in cpu_rmap_update(). cpu_rmap_update() does
>>>>> exactly the same thing (for_each_cpu() on an affinity mask created
>>>>> by copying), and crashes in a very similar fashion.
>>>>>
>>>>> If I set CONFIG_NR_CPUS to a larger value, like 512, the problem
>>>>> vanishes entirely, and "modprobe mlx5_core" works as expected.
>>>>>
>>>>> Thus I think the problem is with cpumask_copy() or for_each_cpu()
>>>>> when NR_CPUS is a small value (the default is 8192).
>>>>>
>>>>>
>>>>>> Can you please apply the debug patch below and provide the output?
>>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>>       tglx
>>>>>> ---
>>>>>> --- a/kernel/irq/matrix.c
>>>>>> +++ b/kernel/irq/matrix.c
>>>>>> @@ -51,6 +51,7 @@ struct irq_matrix {
>>>>>> unsigned int alloc_end)
>>>>>> {
>>>>>> struct irq_matrix *m;
>>>>>> + unsigned int cpu;
>>>>>>
>>>>>> if (matrix_bits > IRQ_MATRIX_BITS)
>>>>>> return NULL;
>>>>>> @@ -68,6 +69,8 @@ struct irq_matrix {
>>>>>> kfree(m);
>>>>>> return NULL;
>>>>>> }
>>>>>> + for_each_possible_cpu(cpu)
>>>>>> + pr_info("ALLOC: CPU%03u: %016lx\n", cpu, (unsigned
>>>> long)per_cpu_ptr(m->maps, cpu));
>>>>>> return m;
>>>>>> }
>>>>>>
>>>>>> @@ -215,6 +218,8 @@ int irq_matrix_reserve_managed(struct ir
>>>>>> struct cpumap *cm = per_cpu_ptr(m->maps, cpu);
>>>>>> unsigned int bit;
>>>>>>
>>>>>> + pr_info("RESERVE MANAGED: CPU%03u: %016lx\n", cpu, (unsigned
>>>> long)cm);
>>>>>> +
>>>>>> bit = matrix_alloc_area(m, cm, 1, true);
>>>>>> if (bit >= m->alloc_end)
>>>>>> goto cleanup;
>>>>> --
>>>>> Chuck Lever
>>>>
>>>> --
>>>> Chuck Lever
>>
>> --
>> Chuck Lever
>>

