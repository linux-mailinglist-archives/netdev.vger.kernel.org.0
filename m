Return-Path: <netdev+bounces-464-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2AE86F7779
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:52:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06655280DFE
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9BFA959;
	Thu,  4 May 2023 20:52:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D9D7C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 20:52:38 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61598526A
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 13:52:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6d1yWr7ng3QLu5eDFIk7q6upmqPvX94fOez+f072YWuX20bciiCQlWW32PWLyLQI5JWjmCv7ZKjIlrwBY5CLwR64Ji8vBcI1gEjVaKmGGxxISrKVW45yj67qaJt3yZKxdg+0s9bWEbQP92y3fgzkqzV0/VAgalsJZBu398sxBEQNXJfnuT2nzAVsReS4+FSU1n3q36bMQx3RNesjgJg7IzwR2lBtkLfxihYvfmCY0ALJIRCHbeLH4meu2K6tGGK7kyQCfu8eo1IPsL5ohinScBv0C/e57oCWZDClZek0hATLdGGqYrl37HqxvwlIN8eEihd1cdQWvMG3tudZ5KE7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XKb4j3Oaxg5husCtEszyjDnG8/lqdTOtp/xHLMm3iw0=;
 b=L2Wal5LdOppQ0mzljwa0PKKLRIwB7uC9IANQoN9F5uPVNFVF/2fm+TSEGgfWtzre3/lpfYHIfzBBUUy5t60DETQ1ex0sPKytWiK+k4B2vdfmdx2ZnrZxATgZ1TEUFdsPHEUzhYLOqXPw4qHSN2E3fRaTaxZXdCtgIGkzf2UjnjNKpFyvKerS3+cZYKcEyx/ekAWkI50LnbCaTmgnCCKaMmrS5kqnVCbOg3pls92dbiv7fwQIeyAEDNaxdQOQb+TiAxXRPAyvLFgS+DO8LD+IgwtUnFSFgsAgFs1C9fhOC5Mw7Q0KEN+KcoBUL4VBcGdOdCrDzUvwesICwWz9e1q/Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XKb4j3Oaxg5husCtEszyjDnG8/lqdTOtp/xHLMm3iw0=;
 b=xQVoHvHdVBY1eR88FXBdFJzH6hZuNkdUlYCn46pojlPTv0SpQfDKlVld0lyaqg4c8ZUEWg86eyOJQJg8Whlun3ENJjeFXquKh4boRIvY2PmCegjiFFAWGWgQ16Tm8IgcXidDy16158uDQBrtsCrCZHJz9V8Wj7QXJElnYDBRDfg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH0PR12MB5188.namprd12.prod.outlook.com (2603:10b6:610:bb::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.26; Thu, 4 May 2023 20:51:17 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::fc3e:a5b4:7568:82bc%5]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 20:51:17 +0000
Message-ID: <ad5bf0ee-9d93-e0c0-cb22-7b572b75d6a2@amd.com>
Date: Thu, 4 May 2023 13:51:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH RFC net-next 0/2] pds_core: add switchdev and tc for vlan
 offload
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: brett.creeley@amd.com, netdev@vger.kernel.org, drivers@pensando.io
References: <20230427164546.31296-1-shannon.nelson@amd.com>
 <20230502164336.1e8974af@kernel.org>
 <ccfccde0-9753-1e54-75b0-f6f1d683d765@amd.com>
 <20230503182708.70f479d9@kernel.org>
From: Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230503182708.70f479d9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::13) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH0PR12MB5188:EE_
X-MS-Office365-Filtering-Correlation-Id: bb489704-d830-4505-8555-08db4ce14e43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Yb5zjsNaGu4VhDvXc4o0vcF8yPXWtX2VHPY1231U6KHqgR/I8WptGh2/2WTwjtP92bzcAj3yHARe3gQpAiaCv/cp2av+/L91CpiMa3Js7Jb2kA6WL8cuAcUzHZhj4aV6kdG1VycSQ7v7SFcs0FTsTuFskf1m3282FIwHLhwQqToCjp4IQdsm4vMyjfuLcR69ib5xxhGkp9fSFLHhWY2E5ITVewe9Q2Bs8XLETL8ACJYPI3EQXvJs2HTPCR+MJs2n4j0o0iK1r7Vn7qXLuopdYhCJAGMdSEqE3saGwVLVsQP/WtYc2C//N0BfYZzAe6YZ73NFqB53qQsGBf1DBOvYJDbHmbqrkWKE4J8/2BIPpwSY1fqbFfUjldzj6kAHFt7RoFeni96HGYLeI8gdhq+jhN3aZhZjYUniRT1T9d6g743JQAJ6QcYEkb0MOUQYzmRWtvyJI1QdbzZkCDOIPzL/CeDfLlE+VLY9JlrZ3+pkwTaDU9tWz+VKyc9JOyB8uN7lEh6V4NlJvV3Bi2ex3XV6F3GDli6rIsDBzFxZfYODzFbX4nhxEjfmwf3ULjaLLOlJxkkFY8apGOCBsJ05f06AhRBbkSwIaAM6tv6kFD0jdNnsyF2Yey7Q32UD3KDwv+rgOY6YZb1com+puqlVglTvSA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199021)(41300700001)(6506007)(53546011)(26005)(478600001)(6916009)(4326008)(31696002)(6666004)(86362001)(2616005)(36756003)(6486002)(66556008)(66476007)(44832011)(66946007)(38100700002)(31686004)(316002)(186003)(6512007)(5660300002)(83380400001)(2906002)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mjlmb3cyaFJUTm9LU1F1OFNOSHlwd1ZMUFU0akdVQ0FiUDNrRjhmckNYVC8z?=
 =?utf-8?B?MUZvN0hLdzBjLzMvaFlIZG56WWtvaXpwaStBRW0zcGNvN0U5Mndob2trc3Bk?=
 =?utf-8?B?elFKVHNxaEVLTDFCNThZSjlJZVZPMWFYdUNjNmFpMmVWV2d6L0dPTGhJWGJz?=
 =?utf-8?B?ZFJIMmwzalZna1dwQ3NxYms2Y1RoaURUWmpOODQ5bzltd3E1SHU1am5PczFJ?=
 =?utf-8?B?VTRwYnVtNklmM1pKNDZjajhGaUhjNW1ORHFNbVA2eEY4a0dRZHowcjMrQmZk?=
 =?utf-8?B?Wi9SNS9UWms4RHlJQitGSkQ3VitreFQxamNQazFaSHdlNHJTQ1NpL0N4RXZn?=
 =?utf-8?B?cTlncHNHWTRKanVScEtQNnVpalRadG9PR2VHSGZpUk1hdTlJaFpsQmIxMy9J?=
 =?utf-8?B?dTQ4Y1p0b1lSeFN4dnB6TElkL1J4MjdXd2lESnUxVnRlRFNOWW5BRXpLNCtL?=
 =?utf-8?B?ZytCUWVIQ2E1YlRvODdYcHJ2enp5RWxDVEw4VmJFVVBHNGZ6dVdhblIxdVZl?=
 =?utf-8?B?elhGLzMrTC9MMWxNVTJqZHVncnpmd2hIUGxNWlJJOCtlWW03TTlKMm5VeWRn?=
 =?utf-8?B?aDRudkhMSVJ6UnF6UVhYbks4bXBsVUVmaTVJUzFGc3RiM2x6d082MlFuemxC?=
 =?utf-8?B?YWZBQ0lCck9aVlh6RDNVdGlMd1NaNnZjY3lGS1p5ZEJzT01qYzhTdElLTDND?=
 =?utf-8?B?NnVBS1YvSWhBeTNtOFJVSXlWYkJQNUpNaC9xRmpMbndMVkxjemtzaGwwOFB5?=
 =?utf-8?B?aytkL2dwVUNQRkt5NGZZdjBvNmhaODlTam00UGhvZUt1SHF6Y3VNNjVDdktE?=
 =?utf-8?B?aHJQelI5T0JoZFlBU1RkS21WalFGdk5jWTVkcUhhUTV2QUN0a1RWZjIwZURU?=
 =?utf-8?B?VFBzZE04cDJ5RUxKVHJHY3VESzN2blBrN3BSc0xQT3hwYXBCMmF3VE9NMStq?=
 =?utf-8?B?aHFhVVIvaXlOV1lSamVwbGw2UVFFdTdzOXRVREpVOWZTVGxwK1lNdjlIT25j?=
 =?utf-8?B?dzFhQVVLN2srUWpkdXhRV1dFeTF0cVVNSURzRjJNZXF2L21IMmpnaEhpdU16?=
 =?utf-8?B?UjBWZkVMYnFsKzhjbXM2eTByMUlkdzNseWJyK1BmMm80ZHBPYWxOdjVUZ3dN?=
 =?utf-8?B?QWQ2bEs3TmhuTWEvRElXTjBmaGY2WVltSkp2djVyajlDT3hqZ1VSc0hiVTVZ?=
 =?utf-8?B?NnJieWxvRHRHL1FyZDJVaWwyME1pSU1vcmpUKzFCVXZEM2w1VlFSNFBJOEZ1?=
 =?utf-8?B?Njk4blQydXhRYnpLcnJJSUZVdlNEZHljT3l4WW9BWGlXNFhreFJmWDB0T3hw?=
 =?utf-8?B?eHkxQ2JPUnJidWYvK0VsV25uaDR3RUR5QytpZjArV01aMmpEUjJSSFo4d0dQ?=
 =?utf-8?B?NWViMzgrcmtxbytXNnlsSlk5MjYvUUg1Q1ZBekszWVNJaUs4SVJtWEp0clkv?=
 =?utf-8?B?YVlaSlZxZlA3THcyWmZ5NWwzbCtnS1NET2FMeXIzeng5RnU5eWQwTmlxdytr?=
 =?utf-8?B?N3d4OWFjSjVqMm4zZ2xEM0ZEU1BkWW5HSTZQZ1phbTJTNklTLzJIRlVvVmsz?=
 =?utf-8?B?bnRBRTVUMGQ5OEhLTTd0R0p2K0ZDSDlPNmRlSU1YSzgzUGphL2hwSXhaNisx?=
 =?utf-8?B?dURMTnFCTmxSWFRlbzdNN1YzWDBqZVVjOUJEL3BOdHg4SXVqbUUxOTd2Ulpv?=
 =?utf-8?B?bTFNVHFzMTVLWkZ4dTgvWUtvc1ZCQWVReVc3cnFpbHlpRXJkN0tFc2lHT3JT?=
 =?utf-8?B?L3l0dUNXSVV1WnFQa0Y5eFVGb1dQUk5SazdrMzkrVDRzRnlrNmhwQ3VkbGsr?=
 =?utf-8?B?RkhNWlgrVHJmZG5WelVuSGQwVkhkY3phcDYxSDhzRi9Mb3NZaEJ4VzU0Z1lo?=
 =?utf-8?B?UDFiUE1PaGg5Tk5VTmFkZHkvL2RFR29VM2FLbjJmS1JzQ2R3elZHVGh0ckRF?=
 =?utf-8?B?Q1pJaTdrYit6T3Z1L3E1RU1ZRm1aN1IxV3l6QzN3cFRBa0psQy9zR1BDNW1W?=
 =?utf-8?B?Qm5UcTR1dCtYYkJzY0hONlp5T0J1bnZYQXNIK2dGTzNTZy9kM3BwVUt0RjR1?=
 =?utf-8?B?Y1FZODhZTlBxOHgzUFQrR0R6cGUvTEV5VE14c2svTU1lOGh0QkJLQkFEMXJq?=
 =?utf-8?Q?o+Vh8ivCrFtgY99ANDFhcW63g?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb489704-d830-4505-8555-08db4ce14e43
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 20:51:16.9396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ud4P20qu2ORdIlZB8AHd46FvktvKwxCfeXC7ja93wUU9PU5jpqu/41u1z+2OjoGD5l44bTgZ4+oZf0AdiOC1Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5188
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/3/23 6:27 PM, Jakub Kicinski wrote:
> 
> On Wed, 3 May 2023 15:49:27 -0700 Shannon Nelson wrote:
>> Given that there is no traffic to the host PF in this case, and I can't
>> do anything more than wave my hands at vague promises for the future,
>> perhaps tc and representors is the wrong path for now.
> 
> If it's not a priority for AMD to have an upstream implementation
> that's fine. There's not point over-complicating the discussion.
> 
>> But there remains a need for some port related configuration.  I can
>> take a stab at adding this concept to "devlink port function" and see
>> what discussion follows from there.
> 
> You mean setting vlan encap via devlink?
> I don't know why you'd do that. It will certainly aggravate me,
> and I doubt anyone will care/support you.

We're trying to solve what would seem to be a simple problem for our 
customer: how to do basic vlan encap/decap on all traffic going in and 
of a VF.  With no host PF traffic, the legacy ip-link and the newer 
switchdev+tc solutions don't fit.  As this is VF port setup, and devlink 
is meant for device setup, it would seem to fit in the devlink port 
function model similar to the setting of the port hw_addr.  What am I 
missing that makes this an unacceptable answer?

I understand you don't like this devlink port function suggestion, but 
when I go back to negotiate with internal management, architects, etc, I 
can get a lot further with them if I have a technical explanation of why 
this is not acceptable.  So, at the risk of further aggravating you, can 
I request a little more detail on why this is a bad idea?

Thanks,
sln

