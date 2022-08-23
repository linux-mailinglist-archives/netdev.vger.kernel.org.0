Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBC459D2CB
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 09:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241171AbiHWH46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 03:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237982AbiHWH45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 03:56:57 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FAB6566C;
        Tue, 23 Aug 2022 00:56:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPYQ4h0xHsp90P1DyuYDnTVd9r0iaPf1e2PfRt5D3IoDsQCIKetzKXrs7nTc12EI0vLJZM8zsFIm9tRVCA1ap2qrxcgrA+9so+zlJi6A9Ah9kjpFbxZuGAL7Kf7AcNJlKzpfsfup58CKDieWwmGJW1gQr2nHXO0p9F92ofEc2LgSVq1iBjhQ4+0OUv7KALWjpVhan0MoO4m7QCvzoVUKOd9mklPnE9m5Hhg7rEw7xRSJJRxmZSFUnA7LzRb+/xuIH5R4JBcq6gNSUdrMz010TQogNber4TVeWzsm9AcxXIFZ8ChMKbIevE5JysZErKQ3yZyBvej8YFwjJYUQH+0wRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWw5+KxVyiv6IS0y3dfZFDthFc4dO6AY2cxGXFahx08=;
 b=dOGN//uggtlTw4B9Rjzi73JHKKBEeNAXodNni7Fdu/fErw7k2afepHe8PDA10h+vV4xgWxSSx/bBWgswg+YNuoOdHhqU3ibj1zQDKdMlAXA4MA6UIpaWvlMUdsgjU0Vf/3lji1JzkgRFwtCrApHLU2z0iuP5yiqpT6rpX+0S041dKI/eSC0tjAJIB6eC8zsVk9F+QnYhittt6bh7Rqw9qNxfnyQ2W8ycxLzNIV5iJoW5B1meqYEzRgMk3SypBl1Yrrpe1t1zlTB/SGPSHZ7AXVJLuRf9ujNom+EcMhtnTVf6kJ6aC/eyM0T0nluSDdHC1clFjnISYiMPDEkHInv0HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWw5+KxVyiv6IS0y3dfZFDthFc4dO6AY2cxGXFahx08=;
 b=Z739qIrMOn+RX2ARf/pYifpDz/7awUoR05VB1VMLM7eFPb/fMfQ/5198lk1d/7XYJtRn8BK9/rhs9Ws3UiT70ZPB/NOLwzW6B3dlhhl7KqWWoc5UQD+qRN2RvR4kiTGuJ1zIGEH9L205Bl70R/KSRvYpEOeSl5QmINqyftr72AO2ZrUYalgPnxpRUkqQfFaQCJIElqvwqelGSnYH78oVLkJj+dwXyMnXkB8TnnOluPUUt1BPFl0DIfX47pAqAvm93vtsKxKgUwCRbWWxvZVCEVISa5ReZFhqay9yG89kYPEfF3hKWT731yoCdmv/EvVehGVV2jM5UsixYqX/TA1kKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by DM5PR12MB2423.namprd12.prod.outlook.com (2603:10b6:4:b3::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Tue, 23 Aug
 2022 07:56:53 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::61f4:2661:ffa2:e365]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::61f4:2661:ffa2:e365%5]) with mapi id 15.20.5546.016; Tue, 23 Aug 2022
 07:56:53 +0000
Message-ID: <379a510a-310d-7479-6751-995c6c05ff7e@nvidia.com>
Date:   Tue, 23 Aug 2022 10:56:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net 1/1] netfilter: flowtable: Fix use after free after
 freeing flow table
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        netfilter-devel@vger.kernel.org
References: <1660807674-28447-1-git-send-email-paulb@nvidia.com>
 <Yv7FauVMX2Smkiqb@salvia> <11b87f33-98fb-e49a-5f63-491d4f27e908@nvidia.com>
 <YwPw1ZqiiuGdCGeB@salvia>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <YwPw1ZqiiuGdCGeB@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0002.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::22) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0427e41c-caaa-45fc-7114-08da84dd0ab0
X-MS-TrafficTypeDiagnostic: DM5PR12MB2423:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vZvpmTT0RvGwe6ifkDfEwDG+gLlQFOdZ9f15L9AFssEvlwSBY/3/zpdl52xguKdirHvg3zSQbRHQFLqIJqsBehmk3SG4Rf1zS3dS8V8omD4ABcpM2xoBsya5e73vFllgTiSKGPZe7scLe6lAF9GP0gkz4mpzMaF/t8CX5ZEpkvF9CDI6N7j7KmLVas5IDus9cwMp/JpJ3mhpq/U5CW7ZSPf5tLmvmm5Kk2ahqnO2ADZQwn+JXJuxHjZzS5MN4ynLPsZbMXCXKH8OYwDnTtjETaRlK/kKVBaS+/siRnRLCW0Voadt5OSXdtlixyq2sP7t1DsSYYLOXGyue5N6mVC+sOV2MNCEp8v3DxPfQdMEF00e/L4ZsJJ6TI0ItiMUiI/m86CTOsbf379lV7q75paco2Oz0FG6IcRhLJTllD8mlNEBo1mffOBIJGgWXSuIb5atzYItOM5bMoRVzsC+GMxgM4mRQjGpNto4uQg8a/p6aHsDAIUdtlBa6bG3y4AujF/0Ovd6hoWb7tYBlB17oWBvascBDmvlzt5NF48r6qira4s76GI1kXuQbLxn5WSDn4IGvfQauoy/G8cMbP/8JONERcDX0pJ1gUGF6ogww/Oqm7U47IFbhaUPWn/IJI3OlxDISJp+U85T2P0xp142ujKo3lK8Ll6bgQNmy8PQ/oahPqdX7fI/+Fzo4XPvCK9/PH0WQLXs3IQBEOx95vOC7TK/3YLDb5S7j2Tlk3d4uDXtcemFIqdDhpjq5RopIh5EJ0zjeFxsChTguCJzscucXLnoRnB4KghqGl7b0qlLThm5ecQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(6666004)(31686004)(6512007)(53546011)(6506007)(41300700001)(478600001)(38100700002)(186003)(26005)(2616005)(6486002)(6916009)(66556008)(66476007)(66946007)(8676002)(31696002)(4326008)(54906003)(2906002)(8936002)(86362001)(316002)(5660300002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0xqNlV6bEhTck50dTFMTElmQm00emVLT3hHQjdNUzZkclBsenRKWTV0NklJ?=
 =?utf-8?B?N1h4KzM1U21wTkplYW5DYVV1L1U1NS9jRzhSdGdtUnQvUFhnS2pqWHlsOHor?=
 =?utf-8?B?WEQzejBUaThJL2pLcEtXdk5KK3A0RlZxck5QZVBJMXpPZ3pYekZEQUxneUha?=
 =?utf-8?B?dHRGNGo0amN0QmRZQnRLY0tDNGJNa1dyNW5xYlVXV2svTGIrZWp2QmRvNmNW?=
 =?utf-8?B?Y1N2RS96eTRpS0NFbWM0bjNrc1VpY1R1dWZRRnZzNzlDenhsSkVOamc1VDRo?=
 =?utf-8?B?WFJJVnM4UlNHVkZ1UGhQcitzOHpMUzVTbjRrY2lXR2hmWVVoeFpJM1FWY25I?=
 =?utf-8?B?VVRiMkVQamRYWnRJSUcwSG4wZno1VlF2WnA3WGRYUldGVHdySUNZS3dLWlVh?=
 =?utf-8?B?dmw2SUIvSm8wU3llTzVkdWpJZkZGYStoUm5ra3RMOUkvYW9tb3RuajNHd3Rl?=
 =?utf-8?B?NlRObHlQR3M4Z2ZMWHBjZWpzcFJHRU5qeHJjUzFwRzIxSnBUOWgwM0pSY2U4?=
 =?utf-8?B?YlJHQ0t6Zmp6YnZYb0JXZmM0UzJJV3NhMXRYT09leGQ0YW43UTVqWnJGWU9z?=
 =?utf-8?B?UTl0ZzQ0a2IveDVpLzZ4REhJR2RlMlJxQkFMODFoNUl6OHNxdFkvZHY3MFU1?=
 =?utf-8?B?bmhESzk2VG1ZUGt0b2p0ZEtzSjhRSy9JRTB6K1Q1a1lQUXBYYWRYQXQ4T2dY?=
 =?utf-8?B?cUMzaWIwckx3QTJHNEp3NzN2TGR2Q1Q4VWY1UTBGMFA3aUU4aUJPMUFzR3Ni?=
 =?utf-8?B?ZTQvSEdFREU4WUI3RDJ2K3RqYUJIN0huMWx3bzlubFVEblhiNHFwaFpBaGVo?=
 =?utf-8?B?Sms1TzhhMWlYZUVsakhkVGs0V1dKRSt2MDZjb1orb2l0L3dnSGdGcE5saC9Q?=
 =?utf-8?B?ck9uUDFyVEV4TU1KVDl3OEowNks0VVppcGhZRFAzVFNvMHYvdFFlZHRMdUlL?=
 =?utf-8?B?NGhKRWZ4cFJxd203YjR5K0U5c3Z4WUJnaDBncWFPMzIrMXZoREZCNGphYkVO?=
 =?utf-8?B?ZTRsZkxlWFprY04xbTRJUVhFbjdJa01yZ28zWVBhM2grcnY3RWI3NU93ei9l?=
 =?utf-8?B?YUllTmhqbFp2eFRJcDF1ZWRyWW5rQVFBMVZ2QjNZQXJvNmtIM3pYYk9aWDM2?=
 =?utf-8?B?R2p6SW1wWFF1dzJyWmNMWER4L0RSUjA2QTZWVmhGc2xqR25GU3cwZ2oxYlVH?=
 =?utf-8?B?L1lHNlFPSnc0cTBzakdKM2lacHdmbTY1dGNMWVBFMTY2K0xNSy84OGhsSmtu?=
 =?utf-8?B?MkRBeTFRWjJhckJ1WFl1Y0txbk9MUmxoU2JSUENSekZWN2NnWG9ySWQxRW5B?=
 =?utf-8?B?blE2SEZEaksvOTVxN1ZMUU5kSFpZT2dvdUE2aFhCTXFzK3JZMFhmQmlhb2dr?=
 =?utf-8?B?Y2Z0VkpBWGhwK2VyVEtlWU8zOFJUT1AzQUJtYVNBVVBadTlLZkkxV1RWOGhv?=
 =?utf-8?B?ZFl2N3RXbmhSeVBlaDhDSDdzM0NldkhJeFV6U213NnFoVUp6Z3VORm1JMVdj?=
 =?utf-8?B?Y2xvU0s0Ymc4eU9HaUIzeUhtVndTQXNpd044NzA3U3BwOUEwZnl1VEI3akNM?=
 =?utf-8?B?Si9wbkwvT1FnY1RzR2krc2V3YnZjbjNxYXFBL2I0Mytkc3pzTjV0NG9RTzBC?=
 =?utf-8?B?SFVHSkhuTU9ZOWs4Q051VGhKY0RmcmhxYU5LeFZhdzBkbFk5ajBFQWR0NTVy?=
 =?utf-8?B?SmZwbGZvUGF5ek5xemZ5eEdreUkrTFpDUk1rcTh0L3ZHRDFvUWh2Z0N4U2l2?=
 =?utf-8?B?WXMrYnNaRm9GdXhXNC8zZW94SkxHbGN2Zk5rOGJ4TE90UXRhYllBSmpXVXl0?=
 =?utf-8?B?OXJHTDVSTlluQVpkMGRILzk1QXM1R2hYRTJCRWNLaEJaK1NyVnNHSVBwYmlH?=
 =?utf-8?B?WW5GaUJwNCtvNy9xY2xMTnJKYUE1a2lQaXBCaFAxTjlQa0wranUvcVNuYzJU?=
 =?utf-8?B?cGN5b0Q3SEcrdmoxbDV1dEx5bnRCWHJHWEwrNG1iY1BrWW0yUDJrT3lxaUJ6?=
 =?utf-8?B?TUVGbWZ6bFBSa2Z4ODVROTU5OThRME5zMmhYWDFTdk90ZHZQREdlSkkzenEr?=
 =?utf-8?B?UTBHcEFrcXAyVDNCTm9WOGpjdi8ycVZtd280eFNIaHV3bElkOXVxZDkxNGph?=
 =?utf-8?Q?pYB1ycREnWflCU7BaVvtOkmOI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0427e41c-caaa-45fc-7114-08da84dd0ab0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 07:56:53.1288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WG8U9mtanjr2TetGf6/x/Wz8nCxMTa6ZrLnfdrMy5YERR7YGoibkXWaF4IWDZrzcWtboXTmVH8DhlpTy6tO1cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2423
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



On 23/08/2022 00:10, Pablo Neira Ayuso wrote:
> Hi Paul,
> 
> On Sun, Aug 21, 2022 at 12:23:39PM +0300, Paul Blakey wrote:
>> Hi!
>>
>> The only functional difference here (for HW table) is your patches call
>> flush just for the del workqueue instead of del/stats/add, right?
>>
>> Because in the end you do:
>> cancel_delayed_work_sync(&flow_table->gc_work);
>> nf_flow_table_offload_flush(flow_table);
>> nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
>> nf_flow_table_gc_run(flow_table);
>> nf_flow_table_offload_flush_cleanup(flow_table);
>>
>>
>> resulting in the following sequence (after expending flush_cleanup()):
>>
>> cancel_delayed_work_sync(&flow_table->gc_work);
>> nf_flow_table_offload_flush(flow_table);
>> nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
>> nf_flow_table_gc_run(flow_table);
>> flush_workqueue(nf_flow_offload_del_wq);
>> nf_flow_table_gc_run(flowtable);
>>
>>
>> Where as my (and Volodymyr's) patch does:
>>
>> cancel_delayed_work_sync(&flow_table->gc_work);
>> nf_flow_table_offload_flush(flow_table);
>> nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
>> nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
>> nf_flow_table_offload_flush(flow_table);
>> nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
>>
>>
>> so almost identical, I don't see "extra reiterative calls to flush" here,
>> but I'm fine with just your patch as it's more efficient, can we take yours
>> to both gits?
> 
> Yes, I'll submit them. I'll re-use your patch description.
> 
> Maybe I get a Tested-by: tag from you?
> 
> Thanks!

Sure I'll test and post.
Thanks.
