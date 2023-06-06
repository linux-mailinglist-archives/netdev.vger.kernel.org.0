Return-Path: <netdev+bounces-8427-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E5B0724028
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:54:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 008891C20EFB
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC7514A90;
	Tue,  6 Jun 2023 10:54:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05AE107BE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:54:47 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2040.outbound.protection.outlook.com [40.107.101.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325D710E4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:54:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PH1EqzYba47lTbhf78RHR8zZMa8y2hFWb07DD+op7roybjBOiOcYVNNoDcveEwb7ixvmR5GR9/jSauHUgJt8l/2HfQrv7isFtaDxaNJlI4mI5SAeA5GNia5jEagybYVxBdFQFrZLEMtgRG3Wof2f6E9FoS84BMuDs96KX60Affo5uUkUsPX2NktxtBHF+Yz+wFoOOI2q6U9ir/B4TDgLIvOML7AUOkweH/WlL3j0yDHTtK4xBsPTX1M3vKMQf8Fnfq2l7jyWUycAi2XxYPT7UtqxN4026bDXmeL+TIxSCIBC1rh0F9gt9ehalp7yOIe6y7vEyL5+MixOVNAo7hRS5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zw4kwIWgagVf4pbYUXzFF5xqc+by2U9isrLbf00owgg=;
 b=Gn6ZQ6BJ1gEGiWppvxMFSW4aErpAuK4xFWw5uBdQn1e9drKy49DKm0xROekmwnqTyJ68EZvhyT/ThTg8/m4pIAdK+1tNDljPt1H6QcOnsne9JouaENIMBeAExXgLoKI25QqeIwM4T4K6o+u1W3qdAl1+2xY9lX3a5KG9jORGFZ2iZpBuBZrxs2fQHZk3/CRGh4jqhIzdrO9vd6HP0GaPRE4eKEzLdG+9R0dnFUg7zgCEwAQ3RRHiQkNb/b40gvsmvqXWjoa313ZD6d3OK5bviIEFy+4Ylh4hMxr7hNqhJAmABbOnJ/uA5R+o/rerGv0CLNdh7AgeBkDGMrNuXNGvsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zw4kwIWgagVf4pbYUXzFF5xqc+by2U9isrLbf00owgg=;
 b=5QVVdD63JcZMEt6JSUc5PPCzWy7ekUKKfCUl9aUPBbfskhvOiWC0om5ncIcM0MI+DinixPWiKNdaIDPdX71IzTGfYrr9rr6Xb+Nxn/rpeiY9nDrzijeBsHZhzTO7ZYByDjOgvOX9SN9KyBWPfOx7vET64hZxjcCk0RKM7BFyWD8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) by
 PH0PR12MB8823.namprd12.prod.outlook.com (2603:10b6:510:28e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 10:54:42 +0000
Received: from DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54]) by DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 10:54:42 +0000
Message-ID: <a212cce0-6c51-546f-4ca4-24052bfbf3cc@amd.com>
Date: Tue, 6 Jun 2023 11:54:35 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: Re: [PATCH net-next 5/6] sfc: neighbour lookup for TC encap action
 offload
To: edward.cree@amd.com, linux-net-drivers@amd.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc: Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
 habetsm.xilinx@gmail.com
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
 <286b3685eabf6cdd98021215b9b00020b442a42b.1685992503.git.ecree.xilinx@gmail.com>
Content-Language: en-US
In-Reply-To: <286b3685eabf6cdd98021215b9b00020b442a42b.1685992503.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0586.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::7) To DM8PR12MB5398.namprd12.prod.outlook.com
 (2603:10b6:8:3f::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:EE_|PH0PR12MB8823:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ae33763-ebfb-4fdc-5952-08db667c6ea6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fomGOzcd5XVkIPmiQ7aZkZbzcgWeWG816FAlQ7LPqG+8JAm21SGzfe6r1TjAjNsZMZdX/3ysKnRAOR1mhVZfVYZ5aEP5NKl2xK2v4tu7sKaSURmoLM4tgKKQeDRiS4LiDB/NZQwie5iH6qEV18j/eS71lnrA+emZqNcfkWcTbKevM8GhQ+3uHVEiorn0knjF6twbI+znBPmHTn+aAHptDLVbe+cC+ua3HVV+OmHWKEz73to4jgxUXaY6R4/rs0DwwOpYQv964axaQ+nzV+xMcwUobJKxuTsQe+S25QUsL6oYvLayEFN/ODVaok/MWl5ANPkRlUTwQMxDIE6dPgE7zntWMOI67ovoW/9hjbNRnQzonSvjb9UogfjH52liHibP4yUeVcLihAoMoJYHPGxbX74Eh+WH+PHgukzUFem/xF0BHU6Hr1/SQcbVgio7vTRphRBwNg8iW/MONsEFSd4IVwnw6OY86ih2zrDKY3WJKgkmGcpWhdp9ucvj6GP4CQEKjmVEL481/eWMecxHYU9TRQ4BOnEHm33Phc8eZKWihfEm52KMxwn04t0/ZLYhoYnmyyQ21y2VadYUCB3JIQwrLqfMVQU2oVqt95si7k9EdapS3RAJLzED/76vfBDrm6PXZ88sp65x0qxethsmIZXkcw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5398.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199021)(6666004)(6486002)(36756003)(2616005)(83380400001)(31696002)(86362001)(38100700002)(6506007)(6512007)(26005)(53546011)(186003)(8936002)(5660300002)(41300700001)(8676002)(316002)(2906002)(4744005)(31686004)(478600001)(66946007)(4326008)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHdzbEpEN3U3VGlZeFBLd1A1S1d2ZVNwNXZrZVY5U3ppRktlYUNSQy96UzFt?=
 =?utf-8?B?dU5QZ0pYMGQzbnFyZ0JRaWZHZTMzMWdJbENweDFLL1haMUY5eE9RQUc0dksz?=
 =?utf-8?B?ODFVMlJVeGxzS1lRNFVlQ3JYRzJ4QStOQWVmbkNKWWhINThtdG5JbllQUkRE?=
 =?utf-8?B?NUgySk5IYUxzMkRZcTVES2psdUFvWjlQMms5aGQwRkl4UzI4bkhlYnA1bWJh?=
 =?utf-8?B?VnBEV1RmYk1NYTU1bGZmckhGc3g4NTZDeFZtT3A2cU52ZEFENHo5OEh6S1FX?=
 =?utf-8?B?N3dCcStqM3BObFoyZzNCMUx0Q1FtbGxZVnpVNCtTNzFKbTgxWmRYWDBrV212?=
 =?utf-8?B?M0RYTlNkSGdIV0NXUUVpYjluTVBZUHRzYmhmdlV1dDFneitMNktjNEVhZmd1?=
 =?utf-8?B?blhST1Q2TWlKOHNOU1N4NDNqbE13MEhEd08rRllIK3ErVC9BN3ErOVQrbEo2?=
 =?utf-8?B?cDVYeXQxYWlSa1BuRSt6ME9jaHJCcVNidjZxTGZYVnRvL0V4aDVQbVo2S2Yx?=
 =?utf-8?B?ZnpyTnJINXVpZjJDcWRIVlZFd1JBSEhVUEFjSzdYbVZEREdtZ1ZpMStRQ3p2?=
 =?utf-8?B?a1FVWjJ2eVJUS1BvQURsUkJkdGpvMkx4MGxZYUxPKzRaODZnc2paWTYwZUxr?=
 =?utf-8?B?eUJnQXlYdFNpUHE4RWFvQ3B5VGhIQjBHeTcza1Y4QkZCM3VJY205NElEeWRN?=
 =?utf-8?B?TlVnQncrN3phVG1XeXg3QitXSFRwWGw5ZVRjYWkrcWNXMHcwQ3ZyZDFqUnhP?=
 =?utf-8?B?QTYyUzZEUzlObVJnZ1krTTJQMWhVNksyR0JJOE5LK0o2U1FzU3dTWkFpNW9u?=
 =?utf-8?B?UENkc0lEU0FNZmttc0VLbkc5UytNQlVlaFdrMG1Gd1dMNkpML0QxRlNRQ0NY?=
 =?utf-8?B?cHhIdkdtRXdKNERrZjc5NGFPZWN6b1haTEVVTlVma21Qb0dlYXp4V1dmcmdG?=
 =?utf-8?B?ZFU0bHUvWm9sSy9JTFVJRFVSMFQyd25mS3FuNkVzU0FVbHRBU3RTbTBnTkJG?=
 =?utf-8?B?eE14bmNDTC9HQ2xKQkRnMXN2L1R1cFo0Q3ZUcmxqUW16dGMrWTE2NzVpeitk?=
 =?utf-8?B?TXZ2Qm90M1ZpdXczS2VCdXRkN1F6MldHZXoyQmxkTUg5dTExSjhtMEVDWXhj?=
 =?utf-8?B?dFlVWU0xbVBxd2xRRkFhRERSbk1jT2RSTTBvYnlSVGp2a1o5akZ0bk5tV1Nq?=
 =?utf-8?B?cFc0S24vSUs0bXNRbTNEbGlnMnJIK0V0V2NnNDhEcEFhMDUzeE1Sa3gvU3F2?=
 =?utf-8?B?MGxaUHZPaEYzY1Z4Tk0rT2NMY1pOK09MZkhzU0l5TzVEY28yaFJzL2VjanhD?=
 =?utf-8?B?RW1oZmN1eXNiV3g0TGRhLzBVNDJYNUdyL0tETkF6R0o4U1pRc3ZJU3RnaXJF?=
 =?utf-8?B?dGpOaVFFc3VrbytjSyt3MWR0cjlmQXhjRVRnU1pQb3lWSndZZ09WcldXeU5G?=
 =?utf-8?B?K3k4dnJvR2NwMVV4MkRuOEZGMEZvSUY2SWhJbnhCQ3BWQmkvQjBUT0dIYnMw?=
 =?utf-8?B?NGlOVmZ2TERTdjNicExSQzREOEM5eGZqZkYvbWZKQStKMnFPRXNXT0EzbjFk?=
 =?utf-8?B?THNONVpKUWlUbjBtTUFES0ppZmMzSTNFbGg2UGlxSDk2d2tsZG94dTBaaDJB?=
 =?utf-8?B?WU02NjVWQ3JkT21qQXFWRktjWmpEMmdnQUxnVDVtcHJIaFdTaGN5amV6cFJm?=
 =?utf-8?B?NHZFajc4K0pMR295Z1lmYTlka0pIdzdOSmlxc0pjTEwwNkI5dUtudUNkajZu?=
 =?utf-8?B?eWM3UlpqZE1LbWE4SU8veUY0aHZmQnk0MXU1SjF6dmx6TXlqNVJPWk5iRUhD?=
 =?utf-8?B?WVlOZ3oralY0K1V3VGtsL2JDK1I2bWdJck43MksxbDhrVlg4eGRPQ05FK2Ex?=
 =?utf-8?B?Y2JaYktSV0JKNU9IajJ4SlFKNXY3c1VaNjhXRjh1QkI0aFliVVBxVnFXcGNm?=
 =?utf-8?B?MklBM0Z4a21TeENEMUM3cE9ZcmF3N3hwOXJ2dDcwRnZncDNBakk4c1ArRFVS?=
 =?utf-8?B?WVErMlgzUGxTS2pPRlNwWi9CQVNmZmwxK2FMbW15VkdETkxDUGFIR2FXTjFi?=
 =?utf-8?B?bi9DM0ZSZXN6UFp3ZG02R1JBZUJpUndaMDY0WFh0ajkxOVZqRVovVjdnc2RK?=
 =?utf-8?Q?v+fi/J4K/45W2uSnje9hje9tV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ae33763-ebfb-4fdc-5952-08db667c6ea6
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5398.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 10:54:42.3434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CtDe8ME+zJbbNdjB1Vne4GDDLay1O+0RaPvMTvCPao/ibPLke3TxZmlwce3FDENY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8823
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
> For each neighbour we're interested in, create a struct efx_neigh_binder
>  object which has a list of all the encap_actions using it.  When we
>  receive a neighbouring update (through the netevent notifier), find the
>  corresponding efx_neigh_binder and update all its users.
> Since the actual generation of encap headers is still only a stub, the
>  resulting rules still get left on fallback actions.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

