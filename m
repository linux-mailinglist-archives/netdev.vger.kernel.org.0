Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FFB679C1E
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbjAXOjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbjAXOjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:39:31 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363B5B9
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:39:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcaUVNDpQCSJ9SgNx1PJYCIcvLItKHuwta0fG+rzXBx46EyN6tmB8gbWVru3YRLSdsHviWztYBQPFDlJK/QMcC7O/mnHxEUeFynGX1hBCT41hMVFoAn/bqTkXeWzJ5D5oGGApi88uhwZupspTgm7R2QPteaO4BZZMs5I5+bcV9GpRCLtpiejc2q6xZ9eyGWSDqZNMviXs+RSgf5uud1YPEE94kCu2vIUSkcAZEmmp5uQukeCVE6iF2J9/eibaTFcpqkJaTc8Wo7RxG/yu037RMmTLHfLq8zgzEAek8JU3PpKsDQwyBn9BUdTuZ23v2b37kMEM5lAMRE27F7Xj1NOfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vgk1RDSKt7YdOWYPbo/twZ1ViRgjf/rR4e4LDsSfIls=;
 b=APKynF4BguIyHbDJpQ/jVcp1d3inZUQd15oQQhQ5ltGUbCcdMxZnuTbivRFQvmKrojAsYUshm/MxwyZnqZJMzKQ9JjpZNCrIWTTgdR6KU+pHZQfTzX7mUVUw6IAGTwUzNdyzfd+NNumLvnxasrFvPvwJVcaW+5YhgVE8u0Yquq9BVHMpnPU6+yN2/5Sx8TkPKbcga9O1xttDLrxPPaoKlwqQvqWmx+I9HxWDwycOs51dqJcRUQD46XYLDeFQeb1Jugj+mWhWz0MGtktUhtOBQIQvrHwEd+ZdhFlsrNEqcVYPoJSwV27KGAqzUnJQqR9a+qpMMmaYtedrDqvbU2Eg/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgk1RDSKt7YdOWYPbo/twZ1ViRgjf/rR4e4LDsSfIls=;
 b=gxlbuybIMeX0Ow9rnEeEBbLoJ8I8rlh1md/Fzf8qIS2QjyNUhjk69/GL/YC5D7Ppmd9cuph+LaFZ0VlLrrozPscD81870s+GOqEW+7GQ8RQ+/i4utXvJj76PEGyjuvkKADKVFdaJ4WKhTa2Fx9SW5Ghb73Jnq1OUIVcezUHqaC0PbVG0ePCaWB6G0U19CopNlS9KAIL/n8vJobOi6pfz5Eb4S+LShm5CRQYKp1HckkSvPJ1duiiYa24Rw7uVIoO4ik/1rFFXYtdY2xQxc6qhdVl46rC0pSXm/sHCC+gPBnGgdSbWdqH3CaX3dXtRAdXMJEH8oknGJtjWuMiIx3p9wA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 PH7PR12MB8428.namprd12.prod.outlook.com (2603:10b6:510:243::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:39:28 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9%3]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 14:39:28 +0000
Message-ID: <46b57864-5a1a-7707-442c-b53e14d3a6b8@nvidia.com>
Date:   Tue, 24 Jan 2023 16:39:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230122161602.1958577-1-vadfed@meta.com>
 <20230122161602.1958577-2-vadfed@meta.com>
 <c73fe66a-2d9a-d675-79bc-09d7f63caa53@meta.com>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <c73fe66a-2d9a-d675-79bc-09d7f63caa53@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0162.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::20) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|PH7PR12MB8428:EE_
X-MS-Office365-Filtering-Correlation-Id: cc9a9880-2264-4fbd-ab07-08dafe18cbd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qLetXxkc1nm+3ZWKhjvcTNpuK6KDh12yBzY0FHMBg09yN0NFxqylkYi0OwpiZZyNxVl785AHxWn2ypXZDUb1F+DpRqoIvThFCb0pjg4aIzh5XrpVmzhzWHdMddtLhJr50feDcbGPBvv1h27ivhLFMPdE/Dl7rib3HYqS3RuvWi32E7dcQf9yuDvYylVu3aWUKpnxehP1RDpifRim8rHoIfoyvCbbqGXJ6zRtfFHc1VvDhRChakj5xUr1rX3ZHosyMgIaLl4foK0OwHMJj7c9A+t0m0mU0NzWnTusbJTOFEKG84babZStpOwokQqpRgPcR/yS1Y7BWvU4ZckxSmwC9H+B7TpFFNIQ9k/BUdZQ/t7jPMZjrGIafN9Ec2FEL1dclF0fEHQMM2flMinPxenOLoHRE3JrhGrBSlNA+1ZGL+Krw9Zr+rv89IY90LN8IZQdrWBA/+qLRzeB77pLYlgcEpk6FoGWeei3RP6HqTFd094ml7D8PhOWqhVZ22LiUPnTy0JmwX6EJZ4DYNTOITJnLZKCMPElMT2wyiSkoOIjchvBreIHhh9iPfpxozGZLcY4Wno1Q3z08XHomfRzwdNwrVMMrExLFiF4VZKbh6Ryu0wSZzxUI/A5RoEko4y5i4elV0TSvut4UNYEsJwX21zBC65UnxzIrstzB1QyXJ+YfkN8WHjXD75becpYld16iKTk6iybq0hTBoupJAx6dul0lb3CyO9gCrTIEplz2q1qGnk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199015)(36756003)(41300700001)(86362001)(38100700002)(8936002)(5660300002)(4326008)(2906002)(83380400001)(31696002)(6486002)(478600001)(31686004)(66946007)(53546011)(6512007)(6916009)(26005)(6506007)(186003)(8676002)(316002)(54906003)(2616005)(66476007)(6666004)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXkyUzFHMWNQdU53VEdTWjhmYnhjSDh5N1lEN1I2cDk0OVhsQkZ4ZjhWbHUw?=
 =?utf-8?B?RkJPQUJ5Y3BBZnAzUGcrWnQ5NHllN0ltSjFEeVN2MmlvRk9MZzhBZnRXVFlC?=
 =?utf-8?B?Y3BBK1lxQTd0eW0vUTdXZEJNOHdNVDQ1SUxDeFdxT2V4S040OVN2N0RIR0V6?=
 =?utf-8?B?ZXFLQWpaakVTYkxGZ3lxY1FJR0FKc3FmOGNCSSt6VElHVW1vTnVRR1Q3NGox?=
 =?utf-8?B?SjFqa2dwL0hVVzhON2RIR2l6OElsNURYbFg4NkU3WjFTZnROd3l1ZEV6YVJn?=
 =?utf-8?B?Rm94NmhDbkY3eTM0eDZpajA3OEcva0lUVnIrQVl0N08xOUNVWlZkdUlhUDEw?=
 =?utf-8?B?ZTh5d1pHZXkva0oyK09lL2U2UjlzN20rYkpWRGJiUG1Ka2p4QWVJR0h6ME1u?=
 =?utf-8?B?dFQvUmkzUTdtL1ZIVzlnWUlTU3ZVMTh4RzduSHBpUTUyY0c4QklIUTZxcGIz?=
 =?utf-8?B?NzRkd3ZGMjY2UjlDRlRJT3crTEM3Y1Q4a3NMdUN4aDBoL2JZaWdYVGl5Q0FT?=
 =?utf-8?B?TVhUOXBRb1FqS1pLVlFtMG1YemtYdzA4a242b2REeG81dG4xUlc3MmlDbVRJ?=
 =?utf-8?B?UElkWEpFTkwvY1JsQzZ6cUJiS1VpRFNhcjVaeFRDSUgwakllWUYxVkM2WFN0?=
 =?utf-8?B?c05ENWVjWmFnSEpiZGFmczZHQk9wcUVMeUtXek1jMGl2VlVwZDk2OHMrajQx?=
 =?utf-8?B?VG5aUU1BLzkzeHBMamRyakpKOXRrR1VJbnBCaWZ4bnM0akpoT0tUOCtHUGlZ?=
 =?utf-8?B?WU8vMWdOU1Z6TEN0Q3R5T0wyYkdWa2c0ZzNQQ1VaR2lEWEJ6WFZBVTVnNUtK?=
 =?utf-8?B?aGt3Z0MyQUp2OGpxSXYrWkJ4Q0RyT2FMWHIvUVhyWXlpZU9JYzNaZ0FWSzZF?=
 =?utf-8?B?TXdrT1U1NEptb3VLQkJQUHRhbUhtdFc2UlVadVk2ZUR4dlgybmIwNU96RGdk?=
 =?utf-8?B?ZllHSFpaekUrOTVNVUV2Q0NJTUJBaUJRNG9MaGlBTHVJMFhrL3NEY1JJMmd3?=
 =?utf-8?B?b0lTeDFmdmJlM3VidDlhQVRyT09Ybi9Sc0VsVzBhbW5VcTlkL3BHYTliRzFH?=
 =?utf-8?B?dFNoeVF4QmhVK0ZiZmlNa2ZvZUpybkd4eEJkYnBXaWl3cjliZ1R0a0JqN2dY?=
 =?utf-8?B?TzFOQ0RFMlRYakl4Vk1POVRmakZZZ1R0WEl3OXNPYW4vbXMwby9nbERmbTVQ?=
 =?utf-8?B?NmpEaTQ4MVIzaHpPQlFCb3JQYi9IeXh2bVc5aUpQWHhMY3lvSkZ6b25TYTd0?=
 =?utf-8?B?OEZCVytjZTNqU2E1YjJjZXkwTEx4Szl4Wlk3ZXJscWVKTWxIVDdMbFFtSVhs?=
 =?utf-8?B?MkxrMXk0Q3gyK0pqbDVaaWlrY293Wk1TbFZWSEJ4UXBhNjg5WjJGK2FzVmV3?=
 =?utf-8?B?NG5zZ3RjTkdRYzJmWlVSY1greGFFS3RDbWpjUnlPMWFwZWRGNEpyTmRrMjNk?=
 =?utf-8?B?SWVJVEcxRC95SzQ2eTNHbXhHUnEwa2ErT2xPa3FhSHRYS1J0b2NGSXpjeFJ6?=
 =?utf-8?B?KzNhYjBwZWp1Z3JtdjI4bHkrZlVNZ3BzalhwazhyekZvVlY4OEQxZHQ4SFdi?=
 =?utf-8?B?U3BZK2ZLaGR4RnA3ZUlqOVRTdVV5SDNlRktaWlBEUzZDZTUvU3dQRGVuUStI?=
 =?utf-8?B?eFpXWGhHeHV1QVNJT2twL3dacTdQSEFHRE5wKzhCVGxON2hPeEh5ZUFZbyty?=
 =?utf-8?B?Visya1NjeFo4aDFOS3RucS9sMy9KL1BjWXZVVXhDWnFrcGRJMFZYNjdZcGly?=
 =?utf-8?B?cDlOL25qN1JPSyt5cUVUbitkYXNGc0l0VzdjU1VkdDNLV3hBN2Y2dmtSaXBp?=
 =?utf-8?B?elVSREx4SVJJQlAyUmROMi9WNDlEeHBCQS9MQUtMTG1hc2g2bkRSd3hZSDZm?=
 =?utf-8?B?RkVsT1VlN05ZbTk4RjJXTDloTVJ0VWRIMkdsWUpZTm1ReGwveGFrSlNzMk5Y?=
 =?utf-8?B?RlZydlMzcW1XRWNuR3NIUnl6WHdaaFdGTmJZRUZFa0VDd1ZWUytzaDN4cWg4?=
 =?utf-8?B?cnRjUEJUY29PUm9wOTJRVFFYN1ZONHBLcW1iVzFiaWFaTC9YSGtvUHI2blFm?=
 =?utf-8?B?K3lFYTU3QmIySk55M1RWZVJNeFVrdVZQeVpCd1Z0eXNuamdsT1JXVDFQQXFm?=
 =?utf-8?Q?T2l8MuxwS1ZaklnvWZvMd3Apt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc9a9880-2264-4fbd-ab07-08dafe18cbd0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:39:28.0823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fl4s9peK18ujj7tAzWTgkd7TyZLGjYbblMCeBId83vFfOeWnLQMaVqwcwF65IvYL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8428
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/2023 19:24, Vadim Fedorenko wrote:
>  > Hi Vadim,
>  >
> 
> Hi Gal!
> Your mail didn't show up in my mailbox for some reasons, so I tried to 
> construct it back from mailing list. This may end up with some side 
> effects, but I did my best to avoid it.
> 
>  > On 22/01/2023 18:16, Vadim Fedorenko wrote:
>  >> Fifo pointers are not checked for overflow and this could potentially
>  >> lead to overflow and double free under heavy PTP traffic.
>  >>
>  >> Also there were accidental OOO cqe which lead to absolutely broken fifo.
>  >> Add checks to workaround OOO cqe and add counters to show the amount of
>  >> such events.
>  >>
>  >> Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include 
> PTP-SQ")
>  >
>  > Isn't 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port
>  > timestamp") more appropriate?
> 
> It looks like the bugs were actually introduced by the commit in Fixes 
> even though the commit you mentioned introduced the feature itself. But 
> I might be wrong, I'll recheck it.
> 
>  >> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
>  >> ---
>  >>  .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 28 ++++++++++++++-----
>  >>  .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  6 +++-
>  >>  .../ethernet/mellanox/mlx5/core/en_stats.c    |  2 ++
>  >>  .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 ++
>  >>  4 files changed, 30 insertions(+), 8 deletions(-)
>  >>
>  >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c 
> b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>  >> index 903de88bab53..11a99e0f00c6 100644
>  >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>  >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>  >> @@ -86,20 +86,31 @@ static bool mlx5e_ptp_ts_cqe_drop(struct 
> mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
>  >>  	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
>  >>  }
>  >>
>  >> -static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq 
> *ptpsq, u16 skb_cc, u16 skb_id)
>  >> +static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq 
> *ptpsq, u16 skb_cc, u16 skb_id)
>  >>  {
>  >>  	struct skb_shared_hwtstamps hwts = {};
>  >>  	struct sk_buff *skb;
>  >>
>  >>  	ptpsq->cq_stats->resync_event++;
>  >>
>  >> -	while (skb_cc != skb_id) {
>  >> -		skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
>  >> +	if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id) {

Can you explain how this checks for ooo?

>  >> +		ptpsq->cq_stats->ooo_cqe++;
>  >> +		return false;
>  >> +	}
>  >
>  >I honestly don't understand how this could happen, can you please
>  >provide more information about your issue? Did you actually witness ooo
>  >completions or is it a theoretical issue?
>  >We know ptp CQEs can be dropped in some rare cases (that's the reason we
>  >implemented this resync flow), but completions should always arrive
>  >in-order.
> 
> I was also surprised to see OOO completions but it's the reality. With a 
> little bit of debug I found this issue:

Where are these prints added? I assume inside the 'if
(mlx5e_ptp_ts_cqe_drop())' statement?

> 
> [65578.231710] FIFO drop found, skb_cc = 141, skb_id = 140

Is this the first drop? In order for skb_cc to reach 141 it means it has
already seen skb_id 140 (and consumed it). But here we see skb_id 140
again? Is it a duplicate completion? Or is it a full wraparound?
I'm now realising that the naming of the variables is very confusing,
skb_cc isn't really the consumer counter, it is the cosumer index
(masked value).

> [65578.293358] FIFO drop found, skb_cc = 141, skb_id = 143

How come we see the same skb_cc twice? When a drop is found we increment it.

> [65578.301240] FIFO drop found, skb_cc = 145, skb_id = 142
> [65578.365277] FIFO drop found, skb_cc = 173, skb_id = 141
> [65578.426681] FIFO drop found, skb_cc = 173, skb_id = 145
> [65578.488089] FIFO drop found, skb_cc = 173, skb_id = 146
> [65578.549489] FIFO drop found, skb_cc = 173, skb_id = 147
> [65578.610897] FIFO drop found, skb_cc = 173, skb_id = 148
> [65578.672301] FIFO drop found, skb_cc = 173, skb_id = 149

Confusing :S, did you manage to make sense out of these prints? We need
prints when !dropped as well, otherwise it's impossible to tell when a
wraparound occurred.

Anyway, I'd like to zoom out for a second, the whole fifo was designed
under the assumption that completions are in-order (this is a guarantee
for all SQs, not just ptp ones!), this fix seems more of a bandage that
potentially hides a more severe issue.

> 
> It really shows that CQE are coming OOO sometimes.

Can we reproduce it somehow?
Can you please try to update your firmware version? I'm quite confident
that this issue is fixed already.

> 
>  >> +
>  >> +	while (skb_cc != skb_id && (skb = 
> mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
>  >>  		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
>  >>  		skb_tstamp_tx(skb, &hwts);
>  >>  		ptpsq->cq_stats->resync_cqe++;
>  >>  		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>  >>  	}
>  >> +
>  >> +	if (!skb) {
>  >> +		ptpsq->cq_stats->fifo_empty++;
>  >
>  >Hmm, for this to happen you need _all_ ptp CQEs to drop and wraparound
>  >the SQ?
> 
> Yep, and that's what I've seen before I fixed mlx5e_ptp_ts_cqe_drop() 
> check. I added this counter just to be sure I won't happen again.
> 
>  >> +		return false;
>  >> +	}
>  >> +
>  >> +	return true;
>  >>  }
>  >>
>  >>  static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>  >> @@ -109,7 +120,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct 
> mlx5e_ptpsq *ptpsq,
>  >>  	u16 skb_id = PTP_WQE_CTR2IDX(be16_to_cpu(cqe->wqe_counter));
>  >>  	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>  >>  	struct mlx5e_txqsq *sq = &ptpsq->txqsq;
>  >> -	struct sk_buff *skb;
>  >> +	struct sk_buff *skb = NULL;
>  >>  	ktime_t hwtstamp;
>  >>
>  >>  	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
>  >> @@ -118,8 +129,10 @@ static void mlx5e_ptp_handle_ts_cqe(struct 
> mlx5e_ptpsq *ptpsq,
>  >>  		goto out;
>  >>  	}
>  >>
>  >> -	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
>  >> -		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id);
>  >> +	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id) &&
>  >> +	    !mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id)) {
>  >> +		goto out;
>  >> +	}
>  >>
>  >>  	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
>  >>  	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, 
> get_cqe_ts(cqe));
>  >> @@ -128,7 +141,8 @@ static void mlx5e_ptp_handle_ts_cqe(struct 
> mlx5e_ptpsq *ptpsq,
>  >>  	ptpsq->cq_stats->cqe++;
>  >>
>  >>  out:
>  >> -	napi_consume_skb(skb, budget);
>  >> +	if (skb)
>  >> +		napi_consume_skb(skb, budget);
>  >>  }
>  >>
>  >>  static bool mlx5e_ptp_poll_ts_cq(struct mlx5e_cq *cq, int budget)
>  >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h 
> b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>  >> index aeed165a2dec..0bd2dd694f04 100644
>  >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>  >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>  >> @@ -81,7 +81,7 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
>  >>  static inline bool
>  >>  mlx5e_skb_fifo_has_room(struct mlx5e_skb_fifo *fifo)
>  >>  {
>  >> -	return (*fifo->pc - *fifo->cc) < fifo->mask;
>  >> +	return (u16)(*fifo->pc - *fifo->cc) < fifo->mask;
>  >
>  >What is this cast for?
> 
> To properly check u16 overflow cases. (*fifo->pc - *fifo->cc) is casted 
> to int if we don't put explicit cast here. And it easily ends up with 
> negative value which we be less than mask until fifo->cc overflows too.

Ack.

> 
>  >>  }
>  >>
>  >>  static inline bool
>  >> @@ -291,12 +291,16 @@ void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo 
> *fifo, struct sk_buff *skb)
>  >>  {
>  >>  	struct sk_buff **skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
>  >>
>  >> +	WARN_ONCE((u16)(*fifo->pc - *fifo->cc) > fifo->mask, "%s 
> overflow", __func__);
>  >
>  >The fifo is the same size of the SQ, how can it overflow?
>  >
> 
> There is one fifo_push call in mlx5e_txwqe_complete before 
> mlx5e_skb_fifo_has_room() is checked, so it can potentially overflow.
> 
>  >>  	*skb_item = skb;
>  >>  }
