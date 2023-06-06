Return-Path: <netdev+bounces-8417-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CCAAF723F8E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F4281C20F82
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC3D733C97;
	Tue,  6 Jun 2023 10:32:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA68B33C8A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:32:33 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BE310C8
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:32:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koddqJNOq/KWRDOKXm5usDr0VH67ZjcHVRQo9Fgy+QNQ4c8PJw3IrXHfQi87bvdCRmkfHn5fGrilSLIdxGc76+CcmBeS2woDWS8eVh9IWGNjbBTUzGW9fwxfQZ9vyOkWzaBHV4J5NF01HxGToNnIYxwG5mzRkdYrI2Sy4sqdykiE3Otqo34dB62iS/SQEGsQFlp3qwl5eWV/EXnvcMATI0mLnWvqJLpDmPMXDdrc1trfVVU0r/HPyycvZ/KKmzs8JKaV5gI2DHtjcKSwECRn5s49BkitFEPpK+yECb8L94srRE06cavJazT39Jusa1Z5VeCWExoEHhVhlgDA9Lanmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RN7zPhaJOVYijuhyw78bh2ko6/sDqhFNQ8x4RTNiwv0=;
 b=JEVBaW7yuUk34y/8Szk+BSZETJJSo1XLYUPckdOTggdJITBocsZGo109qlw6VnhSaCUbhgEQluYgf7T2IGaFl1mH/wX05bFrDKk/i959T3lnLDdtTaWl/BOB6ZD0VY93TFlhe7g/ngYerf9aiabwYLbPESt/Mll5H4e+VsjpcvLevGOO1WTCBZO+lC2LYP+qNb4CltvE/9KZWupmaqpsnS0vINTPC1QJK4hHxyPvf1ntnAUr73xrcCD5xLUlho2Jhbg7XS4zQl/141O9x2W9CRU1MUdhCD4uz8bAYxvwjpvAG/36jinagrET16t2Gy/44iVg7B8A3acC4gBRf6J87A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RN7zPhaJOVYijuhyw78bh2ko6/sDqhFNQ8x4RTNiwv0=;
 b=GRDw8g9NbWYbnLeNPvngWCKaxIFHgaX1O1scVfH/Ib4T9pBNGoDE5EI/2kImbBhkJr224wsiUuymrEOP8QLGtk3IUo15b1nd6DTMdDYsz5Zs5vunbYPKLXgPEph+nIS+pjvOkSR01po5+bqUgDVfewj4pVMGMyh0HVKzPmcQE4Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) by
 SN7PR12MB7249.namprd12.prod.outlook.com (2603:10b6:806:2a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 10:32:23 +0000
Received: from DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54]) by DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 10:32:23 +0000
Message-ID: <85a83dc1-62de-df3d-bf84-af8501cae039@amd.com>
Date: Tue, 6 Jun 2023 11:32:17 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: Re: [PATCH net-next 3/6] sfc: add function to atomically update a
 rule in the MAE
To: edward.cree@amd.com, linux-net-drivers@amd.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc: Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
 habetsm.xilinx@gmail.com
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
 <d72046e44328bab1fcfb8c7154a9e7cfcc30b209.1685992503.git.ecree.xilinx@gmail.com>
Content-Language: en-US
In-Reply-To: <d72046e44328bab1fcfb8c7154a9e7cfcc30b209.1685992503.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P123CA0005.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::17) To DM8PR12MB5398.namprd12.prod.outlook.com
 (2603:10b6:8:3f::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:EE_|SN7PR12MB7249:EE_
X-MS-Office365-Filtering-Correlation-Id: a9cbb860-fa57-427e-7f4a-08db667950ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qTFJZJXFWQr/PzsguzcqJb5E0JKjtXPz3IzRhp3QHdlLYW94VEyTDRkbWoSeTJ3gjdXRLDOdkeNYLbZV04clRZ3Al6D4jmzLDeQCB0Keb9FjVb6KwnZjDtEjjpiSqY1bX46pBdIOn3sLl86Wh0vHZg0y/0HFTG1h+cSa66LxjBZQjgnl9zIaKVzm7P3HFLKCytq5ajAkT4POgU3c/PSuKwVIXkmpRqm6nlpJWtCLGcVF2W4impF7jt5qH27IQots/OPFeLlvySsUst/X6UfE+imojh46Ltgo4r1efz1cbqZIz3oih9H/+bt5cXi0BqGXvjg7kFmzoQTA7jpiIdJK4V102q1DbaMV2GkF8o+iRtze5U4v1LR+ee9J3MFbfM+adWDp98KrPqWu8iAUOTCxL4km1oQoxTdDAH42V4BbR1a+gmkn2rKXP7hWC3YpygOespVeFZQWX+SlBZcTqElMaVeChC12xnxPmOeYaBXHo2/wrcT3wIm+wlvpHNi/EqWmvBHBrFES3GY661SKAUA0NWKgk6xqXzm5XqfDjsecCQrhjwq+bsEE3QoLEvE/7MwcQP5LtLTm5/h3TXhhOlSnvLLYwqI68RsayqRzFWAvi8qCBY0frH5NJdKqKVoZddrNv9qCpMDA6AyDi8XHcKEdXQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5398.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199021)(83380400001)(4326008)(478600001)(8936002)(8676002)(316002)(66556008)(66476007)(66946007)(31696002)(5660300002)(38100700002)(86362001)(41300700001)(6666004)(6486002)(36756003)(15650500001)(4744005)(2906002)(53546011)(186003)(6512007)(26005)(6506007)(31686004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K2wrRm5ObnZHcGxjb3QyMzZVNU94RUcxYmtFaytST2E1Q2RHTVF3NTM4Ly9x?=
 =?utf-8?B?NnFXNmJpai9UcFZHMVlzZk40eTFWMEdieHJEb2xmaGU5YWdPYU9UQ1Q2OTFr?=
 =?utf-8?B?b253UU5mTUhuSFZrUS9pUVNYUXFndEJtRUpEQWdHR3hhSTVlaHZUNVd5bDRT?=
 =?utf-8?B?NmxkZjBURThuR215UGl6Mms2bXdVMjIzdURvVDR3THk4bE51ZXVGa0xadGJC?=
 =?utf-8?B?cjVic0J1YnFBb1loYjdwbk1OWHovcmwzdU5lbnFzRU9hNENUa0tRQy9Za09U?=
 =?utf-8?B?b0dmcGRnZFFuT3o5bFV0K2psb0luMTNYekoxRDZ3Zk84eHFVY2R1QVVLbHE5?=
 =?utf-8?B?NEpWWmdCQlQ3QjAyL2c2NTZIbCs5UWFpZjQrdUhZWWNPbUc0OUhtWWVLOTBX?=
 =?utf-8?B?Vms3aXZjd2NRY1RRcnA0SXYva0dCVk1rVnRmY1lLTzJ6MmN0SWJHVCtmMmZ6?=
 =?utf-8?B?ZFFsQzVDQnZFbUxQa1JQMnViRnlWTlllcFcxY3VyNWVCUW8yUngvZExhOWcz?=
 =?utf-8?B?Rno0dGtoWXpJVWRHdHJPLzRrTlE5WnZzaFFHTWJwWGxTVElMa3hJSzEvbFNt?=
 =?utf-8?B?OEJrTU1rSTFzZXFvSURob056WlJVVTI2OTVRRDV1V0VQdVVpNWcvaklHdEdo?=
 =?utf-8?B?L0hib3M1T1BSZDJYdzUrakE2ZVVTbDZyR3ZNVTBVdVpCaGl6SFBpVmNBRDNF?=
 =?utf-8?B?czJ0UVg3VHU1VldIRXZ4RmhNYmd0VGdvdDV5ejIrYWxON0M3V3UwU3NDL0RB?=
 =?utf-8?B?dVlBZjNjUEpmNWlQL1VTRlZyRENkOUpmUVVBL1l3YjUvbllGam9ZWS9tWVE1?=
 =?utf-8?B?ODBZSVNQNlpaT2JvL2wvQi9YekxyTUZaM3hFMnZpQ3pJamM1bzJPUDJRbDhW?=
 =?utf-8?B?dTFJNVdPTEZXV2F4RVFvN1JMVjFZVllMRjcrbGRldTI0V09lNStZVVY2Rnky?=
 =?utf-8?B?Q0VqY1psYmtTVUZ6aFMwZGVyT3JTMGoxNkhaRzdpWUZTNFg1ZUZZRFI2cS9i?=
 =?utf-8?B?V00rUzRlL2JtNloySDdtRWlzTFk5MCs2QVphR280bTJWdmlaMEUvK0VXYWZu?=
 =?utf-8?B?cW15UUpqbXJFMVBLN1FyQzEyRGQ1a2RGeHVpVENvWXUwM2d6TXJ4WjBjeVp2?=
 =?utf-8?B?aWtOUEhuYjFqd1EzSkdnZzhBOW1QUmlyTHBBUVV2RmNBbEtoSHlhLzJYWGx6?=
 =?utf-8?B?YTluZGEzNC9HdGJuNGw3RmtWc0Y3OTB5NDg4b0ZpZ3BkUUJmdmt6TXdxRFNS?=
 =?utf-8?B?cWlEVm9GUVhEM1pqL0ZXcG1NMkZ3bUg4cTJoajlKSk5XS3BEME1xYldOMWNy?=
 =?utf-8?B?TytJV2puR3BhRmJRMEFLbnhzQTlseWhmaHFkbG5JUUxSVFlvdnFQUnJ5S1BL?=
 =?utf-8?B?Y1ZTdGhsaVFibWVKY0JIa2hKSjQ4SjFaaERDdkxxNTZlY3JaV2JNZDNMNW1w?=
 =?utf-8?B?cU5Pa1IvVnRHdWM4aGlvaW90d3dMckZidGtCbVZRVnJrQ3B4M0pqMVVtclhX?=
 =?utf-8?B?Yk96V2tzV2ZqOGlpbnJxKzk3bWV0TnFTOXlaa0ttazFYem5HOU9wem1WeVlP?=
 =?utf-8?B?TXlCdHcrMlJsQVZUcnlkUmJjNFlBTEozLzZXN1d3MHpRWHJDWG9rR0puZm5n?=
 =?utf-8?B?SzlzWjJOMk0yUEtOSUVLQkZVLzhQODhuSG5WaEo0d21iNjJ2dzNMUERRVSs2?=
 =?utf-8?B?akZ3bnlnNWxKNnRObUE5TkJ0R0ZqRmpoR0FLeFNybVNFSml2Sy9hM0RWZmFm?=
 =?utf-8?B?QXd1UDlqVVBpL3czMXNyeHpvZStSWVBTMkZmQUltclFzTktTM0xQUXRxaTRj?=
 =?utf-8?B?WFVmSHlJQWJLVlEyZnZsQ0JBTDVuSVVEeVpwbVduTkdBZGoyUTVEcUlTK0Jx?=
 =?utf-8?B?Q1VFelVIanRiTGlhZFplU0pYNmpFQTcwc0xyS2wxNVlkV0Q4dTVRTDJ0UkxF?=
 =?utf-8?B?cGpudVl2K09ib0g3NEJzMUNWUkExZWdHYUJSeVJ5YWhtVWJ2WUFSTXBZQ3lG?=
 =?utf-8?B?N2tXS3FhMTVaZmFlSjEyWFhOSjdRZkZrZDA0UzNNNE4zL2dnaDZ4UGR5bDJv?=
 =?utf-8?B?ejQ2SHduVU4yUGQ2bXEwSGJFNmV5b01Tb1grWllHVnZHckpOdis5aFNlbGVs?=
 =?utf-8?Q?gAkttmWX3d3SvxuqNXhmRxc9M?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9cbb860-fa57-427e-7f4a-08db667950ac
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5398.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 10:32:23.4549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: daDxyaYS0RFv9CN01lQBPN/4sOeldH9LEt3SeoBJ+XHQdguQNBDHi6YzsJk3tlO3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7249
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 05/06/2023 20:17, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> efx_mae_update_rule() changes the action-set-list attached to an MAE
>  flow rule in the Action Rule Table.
> We will use this when neighbouring updates change encap actions.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

