Return-Path: <netdev+bounces-8401-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7731E723EFA
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D03B928160E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C42B2A700;
	Tue,  6 Jun 2023 10:10:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A15F2A6EA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:10:33 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84DCE7A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:10:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UA0ktjaUZl0My9ESsDKUraIFASe/aLe5FhrXl0QZKwzl5vrpLwez/4Afa7oH+uh7dSyR06PNzS+xxZi87Q1NayUYV74cl2ekq9cXqBVnD/fBDbKK7kqbJHANFJ/7IwabC1tG09+0PAZP66Jn6EdDFUgY3v+E8mdq+I70zH3O32h8iAcdv6zIgco92Fn/6FQLSgJ2hltTadOyUQgjAV9UQoKC6Uxi7ePqk91gSgrYjGr6VjZNu2huTqcq1nZODeDLo+NXhb5AnG1VG0iCsSfHVF9zXA90X/JOeMGwjB7dhJal2rX9J8FzQ+58nriFgSrRUxJFR3KB9r00yXlmFo0M3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xFyZw7ETqlmKB2N9Pr9R6IMqP6JEcJZy9zi6U4Ii2o=;
 b=Kxxy6cFNv0nu1ZLF/mR9cuBwK4Yxpgz4nnEZwGl6ZLUPF2PiPgoUQ9+1Y+OAYzVG6C/KDClOmB1IwrKE3IrBX2YX7YS6BPiMmu/5279ezKfaHAtQkCcM48zcDWu3Ct2yxSLt2tGpzzqpj1PenB3iNyqxBWBp+/Wk0LUwk7LkV/uQeCafUvB54fG1zRVyCZw1OhOD/6B5wongSrQdmDcefjhDnI5eomI6K0jPZInUQLmGbha/2I4NObOlR91FYEeoPUsA/fTZuZQGNR80YlxXRJeDqmFbYFKLaRgC2d11V/2gvuabVT8i1e26FuqEDtkmQtQUTX4QQ1T4t8xrjt5vMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xFyZw7ETqlmKB2N9Pr9R6IMqP6JEcJZy9zi6U4Ii2o=;
 b=4uuUfEVMol3S0pVwmpVqePbLEeXBeFKmQVftOGRR/T/+urjkz8yt3Gewkzj28QX9Y69kI8ywBqM+YLnFtMA3U9F0vVCMjO/DXH7fHsNZJ5n9Gwy6Q3VvF8jDNbROau/cEZf6MlrWa4OBFiov1oPuf1NJCn79XV+/hQNJnCC9olk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) by
 DM4PR12MB8569.namprd12.prod.outlook.com (2603:10b6:8:18a::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Tue, 6 Jun 2023 10:10:26 +0000
Received: from DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54]) by DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 10:10:26 +0000
Message-ID: <eb9ebd99-414a-5a09-4148-18b472331d1f@amd.com>
Date: Tue, 6 Jun 2023 11:10:19 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: Re: [PATCH net-next 1/6] sfc: add fallback action-set-lists for TC
 offload
To: edward.cree@amd.com, linux-net-drivers@amd.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc: Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
 habetsm.xilinx@gmail.com
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
 <096d731b63e7edbec1a64283387ec5da378664c9.1685992503.git.ecree.xilinx@gmail.com>
Content-Language: en-US
In-Reply-To: <096d731b63e7edbec1a64283387ec5da378664c9.1685992503.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0024.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::10) To DM8PR12MB5398.namprd12.prod.outlook.com
 (2603:10b6:8:3f::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:EE_|DM4PR12MB8569:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c505c83-f4a2-4d66-4476-08db66763fb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9J9bVs3sDnDPauX3pWy1ceznPlic/zVpNmPR0mySE2Y2gad36HpRYs6+EQKwRAJXTu43rbVU+Unn/KCxqUVwTEKKMozNu8H0/QyRYdaP7MEmXOs/jHfVYi6UgX/ObDrO9VusFE/8Azv7PQ0ymE84KuHzvl2XsgrdIob2oIuMCRru/Fdhvqi3nFvy258NQgN/FnNW8Z9rsB4cTLBoPr08MQJGZgumEPWylBTpMDqQbMa9xI9d+ozFyieIx+uP6iMjXerPxpaMX1ZrW0rPhIl2ladhieL/pvCRwxTn28e3FSX28ISQEv2yWxnBsbkJIUsF4xAtfrtiZ6T0Z36mB/4EisrFGKVcbW9htRgDlrMChlQzxCAfMU5pkpd+CoaA0aGTTKbO77Zxj/XBX1N4rYZrA/KGDcE7C9YFQ7Rydm7HiAFMVSdxJqnZMH0Qz8qBKYPr/uLtynKMmsCOBdmuznvzaRaHkeK1A3gupc9Dd9AqWjxXEoN2rwt8yi3p1oFXZKSaJ6Oz60kskCcZFUNqOi/xrQZD422UKwpBSaTs5UXxJLkHIXoaxJLP4IKP5b+qNYuKwUa1xcqC+9PSCZWpVc1Nkmrg/tMsxlWXVJFfO2jFtS1drn5XdKDTlRO1HJ8gWH7IlC7JeKgg5Y9vx5nugcpHRA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5398.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(451199021)(8676002)(8936002)(478600001)(41300700001)(6506007)(5660300002)(6666004)(316002)(6486002)(26005)(31686004)(4326008)(66556008)(66476007)(66946007)(53546011)(6512007)(2616005)(186003)(83380400001)(2906002)(38100700002)(31696002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEdUMmJKdEZkWHBRUHlEaU12elM4MHN1N21vZU51aUd1LzdTQnEzM2F3Vjhi?=
 =?utf-8?B?eGpwdmUranF1Q01xK0hPN2RBa3F5cHN5YkNEQ09NVDR0d2hQMDNmdkc5TnEy?=
 =?utf-8?B?QkEyOEtGWEJjdWhxcW5SYytRLyt6b3JzMW9zbVBkQVpwbmFXM2twYXdJNEFh?=
 =?utf-8?B?Z2hxSThaNDhrYnN5eVhML3pVbDZtYzBPcS9HUk5oYnptYit5QjRNcG5TbjFi?=
 =?utf-8?B?V25neEp6Nlozb2hQTFNmenhFaG02ZEIwVlhWWmtYRll2dUlucDBxRUZmQXo2?=
 =?utf-8?B?clAyUU9HOWVUanFocitPQmIybUNNbjc4cXZUanMydkx6eWRJT2JqMkdIYjI2?=
 =?utf-8?B?cnlxNVY3WnNEYno3N3dLWGFqbVJBV2hGalN3RXFTRndBZUdZQ1ZsSHlobnhM?=
 =?utf-8?B?ZDhtTkhoWFgyUUJLZmM4cWhhUW8rakNFWmNTcjVnU1hUVmhZNnIzYWpPR0dt?=
 =?utf-8?B?U0VUTFJMTHJOTVBmZDN4TjlUTW1EdGhBWk1tNWRKd3FFdTBvTkFmZUlKY0xr?=
 =?utf-8?B?d0tPNTZsR3hmWGVvQWRBSE9JQVFoNHJlK2VsODRaaWFsQUdFV21jS21NNU8r?=
 =?utf-8?B?dUlQdEtXMDhvL1A2QlpFQ1Blbng3VEk1NDI5K09KZGpFY1M4Wk9LbWJKZnp0?=
 =?utf-8?B?eFkrNmdIeGpibFozS2pSSEdMMTJHc2Q5RUc1aU42cUU0QTc5WUtsck11L2I2?=
 =?utf-8?B?dERBTm5TUXBMaTQranBjZklJTFhDYU5QMG1pa3FuNWl5bHJOSisvT1pMeGZZ?=
 =?utf-8?B?b2ZjRHFkN3pKS2NhREpNbCtXZXpjYjNuaWhCVjFzdWk2MVlBa3lSdHhCakFX?=
 =?utf-8?B?Nk1FL250dGNCNVdwZG9kallBRE01S3lPNk85YXJmeHhGZXp6RnJrT0g1Z05k?=
 =?utf-8?B?ZzhoMGNCRVJFVkNMSmVPYTVXOEswdzdVNEZQM21od3loclV1dHN4WThLN0VJ?=
 =?utf-8?B?S0JQNnRSbWtES21RVCt6YVJocU5YZnhaemx5MUs4d2ZXUmwrYzVMUW5qay8x?=
 =?utf-8?B?V2Q3T2VhY3l1OU9qWWxTUkVJaHZtbmtQU01Rd2RERmJKei9aQ0IrZTkwOElj?=
 =?utf-8?B?RWJHY2E0bVAwT3ZlTFhXdHBIa05ZSXQzaHZKdUxKWjNKdmNsNnVGdHNYS2k4?=
 =?utf-8?B?SlE1aXdobU5rT2tYaGtlRFU3RFd0UHpsU2xaelhGQy9SbjdSQ1lMYkpRU3ZI?=
 =?utf-8?B?RlB3WGx6ZDF1TmNSWWpVWnZibXkxTWdxb2tta1A0MWpEQWQ1c1ZSeVJrUW13?=
 =?utf-8?B?a0lzaDJYaG1OSVVoNVI0dExuVjJNeGNwK0IzNGFaeVJQNFZCczRORjlkY254?=
 =?utf-8?B?YUUrbldKbUtERG94YkxlampvY3ZGc3lqYzVSWURkaEJUT2d5MWthWUZWWnAy?=
 =?utf-8?B?alVSZlFoSXQwcUgzUHdaUlE1MU1UYnZRL1R1WUR6OTIyM2I0RWUvN3pFOUJU?=
 =?utf-8?B?RHBnRVI1Z1YzTHd3Y3hpanY1clFjZlFRTXdsUjdsUzV2eFl1TVluVGR3dVk4?=
 =?utf-8?B?dExIc1FZUk5kek9lNlByWXl2M3E3UldQUGNoVmtjSjlJWjAxWHJMTDV0bTJY?=
 =?utf-8?B?a1l5WU80dTFrM09jYlBiS1NqNGtRYVMzR0daOEN4UHRmdm9jeGl2TmJiTDJs?=
 =?utf-8?B?SjM5WEdic0RFYmFBSmUzV0NJY2E1TjJJbXFxUXpndjZZK1pzbWk4OEtSVjlw?=
 =?utf-8?B?b0h4R2tCWm1QSGFmREtPdm1qbHJIQkVjdFJWeEhSbS9KLzZPckdoYm9JYmpi?=
 =?utf-8?B?Vjlha3VBekJSa3RySXdLRTZpYTdVU3VIakZOSUN4d2trWjJhN05EMkc3WVNt?=
 =?utf-8?B?THZEWEY0WnFlTDErQjJMQ1M0Y0lwV2RqRkk1dHFNTDFBQjkwaStZRjlCL1ZK?=
 =?utf-8?B?OFNMbUxyT2ttQTEwcTBIODkvcG5zc2g1bk5GaXk5SzlZZVdXNmVmR1lFV3RI?=
 =?utf-8?B?MVAxTVBHNUJMUzVNd1RzQnhEWmlqTWlZY0tHMXlSTGZMT3VSVm5OcENlNzFt?=
 =?utf-8?B?dFR6cGdldlcwVzhIcGU2QnVHT1FOWkpmeTN3aUJ0MFVCc2hjUlc1YWQxZ2lp?=
 =?utf-8?B?eVNOTEcrM3hDVlN4Q2dNZTVkaHZEUmpDRGdiWThkWFJGZlZaQllpT1Y4THZL?=
 =?utf-8?Q?eDhKnu5VyxG2LTJ998XnmJQxp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c505c83-f4a2-4d66-4476-08db66763fb7
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5398.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 10:10:26.6619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T9UXwYK98xZR6UtREz8iMt9wtvTSSO+fGGM6Sp4RTxjN0S3YwEQKVg5Htp7r+MtJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8569
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
> When offloading a TC encap action, the action information for the
>  hardware might not be "ready": if there's currently no neighbour entry
>  available for the destination address, we can't construct the Ethernet
>  header to prepend to the packet.  In this case, we still offload the
>  flow rule, but with its action-set-list ID pointing at a "fallback"
>  action which simply delivers the packet to its default destination (as
>  though no flow rule had matched), thus allowing software TC to handle
>  it.  Later, when we receive a neighbouring update that allows us to
>  construct the encap header, the rule will become "ready" and we will
>  update its action-set-list ID in hardware to point at the actual
>  offloaded actions.
> This patch sets up these fallback ASLs, but does not yet use them.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

