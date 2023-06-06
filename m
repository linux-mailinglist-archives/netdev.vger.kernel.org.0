Return-Path: <netdev+bounces-8415-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55F4D723F77
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C5FE2811D7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DAB5468F;
	Tue,  6 Jun 2023 10:30:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCE42A9E7
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:30:14 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02D710C4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:30:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BhOQIgIkoQOS8Q/p4fs5OheWT1xTlmO5HWymHLertHE/TSuJqKaT1OBc+HRxD8z6GGaCLXNQPAev/67G0KNoQVMBBlklKw8Knb4f64obnQD2qPpvaf8Lg/T5uz5NeAkUG190r1257Zp031tl0LcbhoWM4T6YvjLNnKd9tPhOoOcGgcLi8MBqm1UO/n+4l3IXgy3HxneQbsg/C2I4O36w11kpIWoHmtGvg6J81nBZ/damZI7SxMN8/hbkruqZZd8ZmwrX8ueox60pFNaABQUwK4LQDhZSiR2caxmfrtwi40K7jnW4QDuBxde3i9vIMo5k4sV6A4GuYp2Zgw9QSgzpgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGlAAu4GQkefziD06QDGRB2cix5iyDswOaNXkxt53fo=;
 b=lYpo/WIE9GzXm2mgnRFXoVmd+zsrOHepcLRPI4G9MCK+CKUkC7B7GsuUXdaIsRtHgxVGuDpfgNfinIMF4mjTEPx/HScaaK3jT6kxuSXReYg6QUo4zH3jp+sJHlFbKpVXjlzCMeLQO1XJf9Wx632Vzu3uXXVnMPT9P7/7K+ZfJRqNVxE8Xs4lx7PAfoQ8RcYoSDr/Xr3XLpDrDKEBLdB28JxRQc6RjtDQJkb9izBXmjPyViRIXi4oOqoAsqEolgkSLl0MaLAYrxi58ZK1D1yJSm/L86VyD9lDhPNGbg8iXWMkaG96EOS1ZY6Qa1p6Cph/MDL1C4jNPsXFEgM8qAbDbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGlAAu4GQkefziD06QDGRB2cix5iyDswOaNXkxt53fo=;
 b=i393XxRLhYXrqB+b229qlLFN6vHcOvZFPi8X7V2CRDcqUX9v0wHqJXyCKcy4D6IZjSWlOIVrbbZGP0Y09bjwywOcxBmyhO4EgRatsmRAyVX084iINbqJQolIUPjXzXf7ZNZyS76uzvblQDpTcdKKd8gP2IzDVHIjDLJNf43opro=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) by
 BY5PR12MB4033.namprd12.prod.outlook.com (2603:10b6:a03:213::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 10:30:07 +0000
Received: from DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54]) by DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 10:30:07 +0000
Message-ID: <b65e34f9-cdc6-533e-6e1c-a36043856939@amd.com>
Date: Tue, 6 Jun 2023 11:30:00 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: Re: [PATCH net-next 2/6] sfc: some plumbing towards TC encap action
 offload
To: edward.cree@amd.com, linux-net-drivers@amd.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc: Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
 habetsm.xilinx@gmail.com
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
 <8664a34d8286c166c6058527374c11058019591b.1685992503.git.ecree.xilinx@gmail.com>
Content-Language: en-US
In-Reply-To: <8664a34d8286c166c6058527374c11058019591b.1685992503.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0253.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::6) To DM8PR12MB5398.namprd12.prod.outlook.com
 (2603:10b6:8:3f::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:EE_|BY5PR12MB4033:EE_
X-MS-Office365-Filtering-Correlation-Id: 19a8d300-73a5-4bd6-99e1-08db6678ff64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lc7UhiVkTrcmkyhxYV4jg5+cirOHdukfIHLyHFPxy5MZNd8aQQltFjCJxYk/IUr0Nfla11BxTqwHHIcKe2mm4SPucJqKNF5CQxOGzlQImv2wnIY0KK6FKDDqBlEqB55P0BgfkUZ1qyf69VNftW8N1S12f63oUqAnt4xE7Gqzx0xfxbxLsokAfUGc1nhQ70qGs4QfKGQDdOlNj5UJR9rg1sYWTwJKuuHx1Zh0tZZ2COT8hcyMFJ6yuHx+cDGmtqs/epkhzM6k+6ClrInlhoZauPKJmxuulOsRmAhIfNm255/ogXrtactxmIfvtBAQH7S7IGrjVS4KjIrWmBwS1KGZUQC18IS1UJ6BAACCNwCazD0CnIP9+7KI4zl2FDc1xoeXEsKGArBCUClglMvJtyXjjOM7dBhJVAHHGQHMywKKadczkMXcjD4fidu63GeQTt7td484Cnbmh1nrMfgBfCJttw1kkYDajCdC+JFUwcEaQlBty/hzv9/0PH5C8Y3RfamZBZ8ofB04BzmLqfhqH6pa6ijqfKQt6fgdov2SnMD3LdLILsutR01GdBCQ5wTjjAbL8XN6UrJu9Pa9drgFeJn3Ho+3OPAzWOCYeGA3eeo7JALWLoSZKKMPllD1ArDOw/jZ5bHqsmFd/oeBso2s9Fbscg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5398.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199021)(478600001)(2906002)(4744005)(26005)(36756003)(6486002)(6666004)(2616005)(53546011)(86362001)(31696002)(186003)(6506007)(38100700002)(6512007)(316002)(5660300002)(8676002)(66946007)(8936002)(31686004)(4326008)(66556008)(66476007)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wm0vYW1xeGtsVjJzWTZZVVNDNmtySHlNTW1rcWRNRHdjWXFac0hEL1hLcFNO?=
 =?utf-8?B?N2NFc1I4MHl3SDgrSngzc0FNblFuYk41QXZCREdaYUtjRXJwRVBtckYyK0RR?=
 =?utf-8?B?YWl4ZEhQZm56bHhNYW5wSjFJeFN1Tk9nNkZHbXEvOVAzSys3azFqckFXbmdO?=
 =?utf-8?B?U2JSSFBkdUJ6bjh2R1FpMkNZQ01iOC8yd1I0RHNGL0N0R1p1a2RVTXVMVXBK?=
 =?utf-8?B?Y1BLQ2NQM1RTNkF2L3FjZGVUMXB2YzdGeGk1Ullob2U3QXFScUZPU01YTElj?=
 =?utf-8?B?WmpicGFLcldVaTdJTDlPMUs5WkM5UHhjMXpENlJLNXZaZ0ZHcTJ1T0s2ZVJW?=
 =?utf-8?B?NGx2THdmMy9qZkdMdGRONWYrMC92MUFUT1lrYkdsV3g5Mno4NXhmZXRzdnpI?=
 =?utf-8?B?Z3hNMGNkZE85NW0rcjlSSS9LWG9SVjlrZXZZMEZieXBDa3JiYVlLYVJiOGtB?=
 =?utf-8?B?NlZhMDRUc2hpSGJ2UmVDbzd3MU9IUFNGRnpuR3ltMkUvSUEyT1I3M3FIS2Y3?=
 =?utf-8?B?OU5kVzVKWUZ0L3VqME12MW5SK25xZXY4eTNqcHVCNGdUcTFWekdSWFZJTlpl?=
 =?utf-8?B?ZEY4QU5EVW5IeUFnTlh1K1Zma1EvcFRrbkdVVGQ2OEpyM3FLWURraUZFRjh6?=
 =?utf-8?B?L0h0MnB4RHZvVkNQUkk0RnNLSysvTk0ydmxrNkJNNUFlTFZBemx4Y2ZHK2NG?=
 =?utf-8?B?ZUF1YXV0VWVMZWdvcTM0NDBsSmdMd0ZVUDlCdmd6QXRNelZNM2NqN0lHWmRL?=
 =?utf-8?B?TjhyOEwyNEs1VXdjRCtEd1daQlFIYkFla2cwdHFMK281VmVIU0t1aS9JTUR2?=
 =?utf-8?B?aDdyYTA5R0h2c3hpTDcvYmpYb0dLaFNiZlltdC81SlVxSHZZVkZnQ1F1NU9C?=
 =?utf-8?B?ZHpxdmFDM0Z2MHFDWXpmOXpsZ0xYZUMvWW1kcHBGU0pIQWhIeFlGZ0gwUkkx?=
 =?utf-8?B?RlFlVFFtMS9jaTFvQ2UxSEg5dzdYaWRSd0R6R2JlenhMaUFJRWQzNXo1V3Zr?=
 =?utf-8?B?U2drODhNcTlqdElhV2dyMzNPb25wSkVWL1FBZEU3MHNLZFl3VjVMMy9GcGt4?=
 =?utf-8?B?SjBIK1RwWkFKQnQ1UW03ZHhuRy83bWJVNWJjb1J5cWh5UjYyRS9jQVpCUTN3?=
 =?utf-8?B?YndqYjNsRmxqSlFBN2J3Rll0eVgyWXRTRUFFbll6TmEyam1zN2I1dE9MZmFj?=
 =?utf-8?B?amRWWDZQUDlieGNIWFJRWGVuQ3h5R0xLYnZxejNHSUp1U1NsSTdZdzVjRzc1?=
 =?utf-8?B?RUFzbHc2bjFodU5Ub0ExbkJLWVFGSEhHMTNyUFRjczNneDkrOXJtbjNRZW0x?=
 =?utf-8?B?N2JlRGpHYkg5RkxDa2wvNXZKbDkwaWdnOEJyemJHcmlZTFlHZXhHU1NwK0JU?=
 =?utf-8?B?TFl3UW1jRWtQMm9iQVFLYUJZS3pzaS91WHN2MVlRODZHZ0FhWmZBVTgycEl1?=
 =?utf-8?B?UjBmazBFemhzZExlT3pxNmJ6ZkxOSEQ4eHRLbU1Qb1VXZWhFRGlqOWFiN1Nw?=
 =?utf-8?B?dUJkTlVWZ3AyMzZyTTRlbEF1OGQzZVZLNmcxY2pKTXQ1M1lreUwxOWxwcjZC?=
 =?utf-8?B?K1NHQkk1bWdHdTFIQ25NNEVoR1ZTbkZLWGs2U0hOVmhFdnpOQkRRQkRZRmd1?=
 =?utf-8?B?MnlvV2tpZTBjZjg5ZUVWU3B3QzlnSVRhbW5pc2hkcWlYTFNBTWtxUHQ2N3FH?=
 =?utf-8?B?MUJzVWwwQ3B3SHhHVFFiOXVkaGtFc3FMbmtZU1VSZGlkemZHbFlxTDlFaDdX?=
 =?utf-8?B?ckN3U1UxSGt6cjhrRDY2U2xnOHV0TEorUXdPNU5HSm4yK085UzZuVHFGY2Rr?=
 =?utf-8?B?aXVBc1paRDlCYU1IMTU3WjB2SXllRE5WZDE0UE5mQ0UzUDRVTEgzc3dxVWhI?=
 =?utf-8?B?Q20yNzBxdEhNZnIwQ1c1aXZMa0lzNEVnd0F5KzlqQXh1a2xnbTAraEt2NFJ3?=
 =?utf-8?B?eFZjTDRHcUtVR3FMY1NWK3ZleE9GYlpNUGp2TGwzajFlQTJwaHl2UHdZNzVr?=
 =?utf-8?B?NE9Bb0EvbkVmZ2psRllUSGpLKzJBYyt1ZTZFc3Y3cUx0L0w2SlJ4R25NOXlC?=
 =?utf-8?B?bHlBZmhWVGhndDBCYzRCS2pmVzBNTDcyVXp3UVFvQTNKclZmVEpVV2MyeDNm?=
 =?utf-8?Q?EO+zIuZ0+RAmjcFE5+dCyXcNb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a8d300-73a5-4bd6-99e1-08db6678ff64
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5398.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 10:30:07.2737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hbxPrZBnSqi6UbO/4K6pmClqxiwJ0U9bQ9RwaxvWiXYC8MQk0bbzMj26vMJ+iAYZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4033
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
> Create software objects to manage the metadata for encap actions that
>  can be attached to TC rules.  However, since we don't yet have the
>  neighbouring information (needed to generate the Ethernet header),
>  all rules with encap actions are marked as "unready" and thus insert
>  the fallback action into hardware rather than actually offloading the
>  encapsulation action.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

