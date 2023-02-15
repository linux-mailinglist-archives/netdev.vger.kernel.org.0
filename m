Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E7B6974C5
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 04:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjBODTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 22:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjBODTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 22:19:49 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C7A2B2B3
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 19:19:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ISpD0+LVqL9xBAdWIDDDDpzv+mMuMEN0268d+yAVR9iDd7K5RLDmk4Jwm2OhtrXX/BTg0Yq0ceBNwoWl4UpCh9CsocL+MfveYUxernPxdl1oHlDbLcxYmAG5BuR9l7a0DzckeUNflEjXDpf2vQ7hWgI5yfbiJ1p/ak8XtZX+0tCJbYcYDX/L/zl7fm2Uvd7QgNyhu/3U6UQcvk+51Ta+LtzsLLuoY/jphSLQSR5EzGBTdfom0l678MigDV2yDU3w89WulrWppasGYjCa6LgsRgyChQv8uYU4pcyz63tOmApQa6Ne+Y0KcbXsZJHBBATr3RkYJfJWHqPLm8Ko9TETdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fgRov+wkTvbEGQ4kIx5uxWG3UnTiZgp5ZBxDSjO1U1w=;
 b=CubYkykBmDHhsEAEhrjd3xMIuiSZpeAr0kIydWbYmOpgOX1HAdLyVMAWmN6m4y55Nm7LidaeaHhedu4kiKKExE5lU53mUeijxFawA4sIpW5oEKZiFmVGOXflhTx9odz/+ABjgg92NRPkRiwzmkp5H+T4uQgpCFDkr4BL/qkDzTZ/toL9ohbrHAy5DT19z8FolRKaXf7E30VvDx3S+JaTgzw2jBhTYmCTz+lisnGA/iskMKrlVmPdgzdjt68qsFco88P62N4xCTwKuobTMcIT5X2owweTjuxFRBWrby7Sllys04bnHDycXURF8Kzd+i3ResPa5ryWW6NantpOvC8RGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgRov+wkTvbEGQ4kIx5uxWG3UnTiZgp5ZBxDSjO1U1w=;
 b=GXPBB9AfYIOzwCqSrJaZvhR2ErwzBBrHHJ0VezGr7KoeUUC01sBH9/pt6XdbRQx5WJ6CENkMvAI0iHX6Ri+PxA7r86O0/JoR8zFeWLWe6OSjb124ZeRZi5HFMat9HyHLhiLGUv3lAHWku8cDUIWvixRdP3USfWKKXMyh68O148U3TWsx/EeCiCA21C3ZQ9Q3jAnfKt0tXpLqg81/TJwuYauM2x789tPD2pSNamrsKTcmiKbMIsBVHxBaDZh3xrc6fR15JaarkkI3jvEk6/n1bwGz/eroXh9SKMJqS+BGlkVYV6LumOez4vCFsh6kTMWL9lopBUBCTuvxOvvMHl68jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN7PR12MB2740.namprd12.prod.outlook.com (2603:10b6:408:23::16)
 by DM6PR12MB4268.namprd12.prod.outlook.com (2603:10b6:5:223::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 03:19:46 +0000
Received: from BN7PR12MB2740.namprd12.prod.outlook.com
 ([fe80::4136:66b8:8b5a:2214]) by BN7PR12MB2740.namprd12.prod.outlook.com
 ([fe80::4136:66b8:8b5a:2214%2]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 03:19:45 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [pull request][net 00/10] mlx5 fixes 2023-02-07
References: <20230208030302.95378-1-saeed@kernel.org>
        <66d29f48-f8e1-7a2e-cc46-3872a963c33a@meta.com>
        <DM5PR12MB134054EC92BC13E36B6C5711B3D89@DM5PR12MB1340.namprd12.prod.outlook.com>
        <871qmzoo2r.fsf@nvidia.com> <3af8d360-bccb-a121-8e97-82a00472c93e@meta.com>
        <87ttzvn2ab.fsf@nvidia.com> <5c6cad41-b54f-ed86-e067-b84c0e4bd647@meta.com>
Date:   Tue, 14 Feb 2023 19:19:33 -0800
In-Reply-To: <5c6cad41-b54f-ed86-e067-b84c0e4bd647@meta.com> (Vadim
        Fedorenko's message of "Thu, 9 Feb 2023 01:10:50 +0000")
Message-ID: <87edqraa4a.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::26) To BN7PR12MB2740.namprd12.prod.outlook.com
 (2603:10b6:408:23::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PR12MB2740:EE_|DM6PR12MB4268:EE_
X-MS-Office365-Filtering-Correlation-Id: 3435c008-289a-4414-e9f6-08db0f037cb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TLBTE24WWt73mTHPYTaekx8+3IfyioVXb4FOvSWBp4+pkBwSt+lWZdt2RwErpcvHyOcOwZRJWJavO7tnF7opQ8WyGCZishEKa1xDLFew6gNZglEpXfhL1gMneXfAo5GCn+FlBonOWaOO0ehJ2a7lWN8Yi6KSqLBtW1ufIRSX4I8C0mGFAd2S/ZElsT6Kb+bKqONZilmAImQGvLFwl9feS2pfYp0CahQ174iMWNnSytWg2JI/eNAugxWog62lYoRvZkbtlnWa5Z5FHGsCYk+ibGJoGKc7x3fHw00YHADhhW/c0BQQrPYS61hhfAii2K6sP8pRQ1Ktwx9GwmxiQlTVPzTpmKdJPNAJGGQZgoAzu/gbMzYB0PZTl/zQajKFTwJ46OvJCVYg493XZRhfmzASpsFGfTmfWB17Lp1DJPLHR7VT9BKV2eZL8N3u82tE3kPxeMQZSwLcEstsUZUsjl3WSg9UzXyVOK/T9aKJXvApvqyFb+B24vLQxlJUznBmhA8P0TMYIYrf9xdK/aCpQ5ElBaxXcTLYNG/yyGY8302yQeWjVxg570dAVF4oAtoYeF1wuQgMpQFQKHmYgj+3OUxsaBty6Hqn+tnZXobpYrF0RY+Lr12L2oCS6ohKKrkKw4fxBnOSsUZQiydCmZpXqIjZTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR12MB2740.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199018)(8936002)(316002)(38100700002)(66556008)(6916009)(41300700001)(8676002)(66476007)(4326008)(2906002)(66946007)(5660300002)(6666004)(107886003)(2616005)(6486002)(478600001)(53546011)(6506007)(6512007)(186003)(86362001)(54906003)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUMxdDBFTlhxS1ErU3VlVm9jZGlIK1hUQm1KOGtMVENPd09wazlGWVBlWlBO?=
 =?utf-8?B?YUJ0Y3FHZjVFZUhURHl1U0pHUmV1dW10QkFTNHNuanZGTzMrTEk3WTZ1VEY1?=
 =?utf-8?B?QXRRM2hzVEczRFZCNWE5Tm0xeWpGUHhOMXRrYVRhSzhMdEtZM2EwK0wwWnEr?=
 =?utf-8?B?bDcyc3pQQnBBZS9aSkQ0QUJRMUNPbHlVdlpEUEJwRjRodnY4Rit1VjZRai9I?=
 =?utf-8?B?c0JDaGY3UGV0U0RmZEpkRFRvWTFwOGttTVVlcmEvZitHSkNabkYzejFMM3lR?=
 =?utf-8?B?UmR0djMreEZuRXdubW53YzgyTU1Qcmx2bTUzZS9QUldEK2VycVJmUXlYYkxo?=
 =?utf-8?B?Q1U3WmpPcFQra2p6OVZRYStacGFBdWpUcWJQTk0xbndpVkZ1Tm5yZWs1S2lF?=
 =?utf-8?B?bGxCSlhmTDhKb1lEQkhNbW5SbmtXME01alRocUxPaWxyeVBOay9RRVhCcTBk?=
 =?utf-8?B?U2pQK3NZWTZVcmFxTWV2KzBoTkttaDBxMFYraS90TVFHbnlUY1FJNjZQQUln?=
 =?utf-8?B?bnBWTzQ1T3NjaE9YQlpUU2xnV2VaR0ZuZkRVM0hUMkNBYVdnOEE2R3NtaFF0?=
 =?utf-8?B?dWJ1bkJoR0tFL3FnVWVLZnprZ25uSjVlSzBPcGFGNng2MkRUS0VQcEJGQ3FP?=
 =?utf-8?B?S1hYY3RBcTIySGV6WGpzM0g1MUNMQVBvV3VacVVmamcvU3FKdEhFandIQ0xX?=
 =?utf-8?B?LzZHejhkK09uNjIxZGUyTjErQXVmNXJXcDgzdWU5U1U0cjBiU3ZaL0hkdUF6?=
 =?utf-8?B?enB4dVEyLzlEMi9ZT0drb0trZ1NlREZVZ3pSNjk0QUtSRkFucnZCRFZ2SjB1?=
 =?utf-8?B?T2VIa0xaWVAvakE2M3RpV08rTXY3Z1RJQlo1T244c0wvbDl2TS90YlNlb3Bj?=
 =?utf-8?B?djJveml0UjFzVVZ1SFNqTzUwaEIxaFo4eWJpUENORVo2ckJCOExNTU9qTnpC?=
 =?utf-8?B?KzlKQ1NrQzVKcWpWTkpLWkpwemgxbzA2V2crbWp1TS8rVjAwRzE4aENITXV0?=
 =?utf-8?B?REpCQTBBVE5DNW51QkZ6YjlrV2V3RzN2UWVVbk03UG1kclNrdmlzbUtuVHh6?=
 =?utf-8?B?Ym1LczZZMGM0ZmkxcEJhYUphQlpSbnVuM0ZoMkVzVUd3Snl3cWNyVjFWZ0JU?=
 =?utf-8?B?NWFRcDEvc3I1OTVTTklrUHlQMno0SlpBeE1XeGllaWQ4NWVHVC8zYzVqeEJm?=
 =?utf-8?B?OXJUZXNoS2ZIRHpmZVRmMEdGc0JiemdVTm1zd0g4SkNLeEJWWHhGU3BqaU9k?=
 =?utf-8?B?c0Mvb0VUajhWcE9pNFFTaSsyR0RhQ0dHTFo0VjExcEVnRjY4RmY2alUvc2tx?=
 =?utf-8?B?NWlxZVM4U0pWUjJyR1JmRHY0VnVCV3hUMHk0Z3ZaZFNqcUpwOHIrRkNHaVZY?=
 =?utf-8?B?MjNlaG1JK3QwR0o0L29xc3dJVS9lMUplSExuUXg2YVFaK1hmelo3ZTRjZHNE?=
 =?utf-8?B?WmFMS3RkWG1jMDExT1lZSmtqRGJkaTN4MUpHZjdQOWJzTmtXWU9wOHdHaWMz?=
 =?utf-8?B?T1djVXB2QjFMaDhESEFZNWdCMnlrNGFiWEhaZjBic1VrTmJRRWs0eU9lR3ZF?=
 =?utf-8?B?MnVUU1FZcEtONEozU0lOVG9XbGMvT2gxU3REOGdKUVZJekZJMWRqeU5RRldI?=
 =?utf-8?B?ak95eSttRmpJaGhyTCs5dDhlYjdFRlZDUnRFUXh2RjhFOVE5a09OZVZwVFlW?=
 =?utf-8?B?ZVVMOUN3UzNNNTNoamduVEtmTVR4N0NKTC9MNTk2c1UvcFRBbEh2T0tsaVBm?=
 =?utf-8?B?U0xjZzY0dUtzWmNrbWlXZjhBY041aFdBc1lZZjF6VEs2UUE1SEJxV0haMGlV?=
 =?utf-8?B?dUMySUJkamRCU2VVdk1SRnROVW5IakV6dzlRdk92YWpFMlR3ZUhBTUJIbENv?=
 =?utf-8?B?YlQzaVF5dGVXMXdmczdZTWNQNkhEU3NmRUZEWm5ZLzNtbmZJNm1VK05Benpo?=
 =?utf-8?B?bDRkSHZZRXhnUTl3eG8xVjdEcHJybXRHL0E2TUhJNndndERrMGNHTWhTK1hV?=
 =?utf-8?B?dTl1dFdIKzdjQW9GaHdJYUFybGJOTHVkSnlSVGRRV0htWXUrbFYyMHZkeHBI?=
 =?utf-8?B?ckpTNkpzVjBKOTB5dHlEelVqSExnMW1QMVdMSlE4WlJyZzcxRTE4QzZBdVBS?=
 =?utf-8?B?cFJXQ0lpUXNQQlZOMGExcHFBY2JzTFhVdFFxZldkUDJmUGdXLy93c0I2ZkdZ?=
 =?utf-8?B?NzF4Z1JoZGdjbitPR2piNGM4S0wrL1prUGRtcXlVUnlvSnU4RkNDY0NSeUNZ?=
 =?utf-8?B?WlJJU2MxY0hZUWRqR1laUEY5Z1NnPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3435c008-289a-4414-e9f6-08db0f037cb3
X-MS-Exchange-CrossTenant-AuthSource: BN7PR12MB2740.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 03:19:45.7353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AmhwD6KcXPWuyx2ZbOsFmaklep+K/M6FmsqYObxa4b+JkOlZZ2GQzWsbTorfO+hkRrgHiicYt62orEf/yZ8y4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4268
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for the late response. Needed a bit of time to wrap my head around
the patch.

On Thu, 09 Feb, 2023 01:10:50 +0000 Vadim Fedorenko <vadfed@meta.com> wrote=
:
> On 08/02/2023 23:52, Rahul Rameshbabu wrote:
>> On Wed, 08 Feb, 2023 21:36:52 +0000 Vadim Fedorenko <vadfed@meta.com> wr=
ote:
>>> On 08/02/2023 21:16, Rahul Rameshbabu wrote:
>>>> On Wed, 08 Feb, 2023 12:52:55 -0800 Saeed Mahameed <saeedm@nvidia.com>=
 wrote:
>>>>> Hi Vadim,
>>>>>
>>>>> We have some new findings internally and Rahul is testing your patche=
s,
>>>>> he found some issues where the patches don't handle the case where on=
ly drops are happening, meanings no OOO.
>>>>>
>>>>> Rahul can share more details, he's still working on this and I believ=
e we will have a fully detailed follow-up by the end of the week.
>>>> One thing I noticed was the conditional in mlx5e_ptp_ts_cqe_ooo in v5
>>>> does handle OOO but considers the monotomically increasing case of 1,3=
,4
>>>> for example to be OOO as well (a resync does not occur when I tested
>>>> this case).
>>>> A simple patch I made to verify this.
>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>>>> b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>>>> index ae75e230170b..dfa5c53bd0d5 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>>>> @@ -125,6 +125,8 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_p=
tpsq *ptpsq,
>>>>    	struct sk_buff *skb;
>>>>    	ktime_t hwtstamp;
>>>>    +	pr_info("wqe_counter value: %u\n", skb_id);
>>>> +
>>>>    	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
>>>>    		skb =3D mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
>>>>    		ptpsq->cq_stats->err_cqe++;
>>>> @@ -133,6 +135,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_p=
tpsq *ptpsq,
>>>>      	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id)) {
>>>>    		if (mlx5e_ptp_ts_cqe_ooo(ptpsq, skb_id)) {
>>>> +			pr_info("Marked ooo wqe_counter: %u\n", skb_id);
>>>>    			/* already handled by a previous resync */
>>>>    			ptpsq->cq_stats->ooo_cqe_drop++;
>>>>    			return;
>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_tx.c
>>>> index f7897ddb29c5..8582f0535e21 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>>>> @@ -646,7 +646,7 @@ static void mlx5e_cqe_ts_id_eseg(struct mlx5e_ptps=
q *ptpsq, struct sk_buff *skb,
>>>>    				 struct mlx5_wqe_eth_seg *eseg)
>>>>    {
>>>>    	if (ptpsq->ts_cqe_ctr_mask && unlikely(skb_shinfo(skb)->tx_flags &=
 SKBTX_HW_TSTAMP))
>>>> -		eseg->flow_table_metadata =3D cpu_to_be32(ptpsq->skb_fifo_pc &
>>>> +		eseg->flow_table_metadata =3D cpu_to_be32((ptpsq->skb_fifo_pc * 2) =
&
>>>>    							ptpsq->ts_cqe_ctr_mask);
>>>>    }
>>>>    Basically, I multiply the wqe_counter written in the WQE by two. Th=
e
>>>> thing here is we have a situation where we have "lost" a CQE with
>>>> wqe_counter index of one, but the patch treats that as OOO, which
>>>> basically disables our normal resiliency path for resyncs on drops. At
>>>> that point, the patch could just remove the resync logic altogether wh=
en
>>>> a drop is detected.
>>>> What I noticed then was that the case of 0,2 was marked as OOO even
>>>> though out of order would be something like 0,2,1.
>>>>     [Feb 8 02:40] wqe_counter value: 0
>>>>     [ +24.199404] wqe_counter value: 2
>>>>     [=C2=A0 +0.001041] Marked ooo wqe_counter: 2
>>>> I acknowledge the OOO issue but not sure the patch as is, correctly
>>>> solves the issue.
>>>>
>>>
>>> With this patch it's not clear how many skbs were in the queue. AFAIU i=
f there
>>> was only skb id =3D 1 in the queue, then the id =3D 2 is definitely OOO=
 because it
>>> couldn't be found in the queue. Otherwise resync should be triggered an=
d that is
>>> what I have seen in our setup with v5 patches.
>>=20
>> With this patch at the time of testing, the pc is only 2 because we
>> skipped generating a WQE with a wqe_counter of 1. This matches your
>> expectation that it's OOO since we don't have a pc of 3 (wqe_counter
>> <skb id> 1 was never actually put on the WQ).
>>=20
>> One thing I am still concerned about then.
>>=20
>>    wqe_counter   0   3   1   2
>>    skb_cc        0   1   2   3
>>    skb_pc        4   4   4   4
>>=20
>> Lets say we encounter wqe_counter 3 and the pc is currently 4. OOO is
>> not triggered and we go into the resync logic. The resync logic then
>> consumers 3, 1, and 2 out of order which is still an issue?
>
> Resync logic will drop 1 and 2. The 3 will be consumed and the logic=20
> will wait for 4 as the next one. And in this case it's OK to count 1 and=
=20
> 2 as OOO because both of them have arrived after 3. I have to mention=20
> that I didn't implement "resync logic". It was implemented before as=20
> there should never be OOO cqes according to what was stated in the=20
> previous versions of patches by reviewers. My patches do not change=20
> logic, they just fix the implementation which is currently crashes the=20
> kernel. Once the root cause in FW (which is completely closed source and=
=20
> I can only guess what logic is implemented in it) is found we can=20
> re-think the logic. But for now I just want to fix the easy reproducible=
=20
> crash, even if the patch is "bandage".
>

Agree with this explanation and tested the behavior just to confirm.
Also, tested a couple other cases and logically understand how this
patch can make use of the resync logic to drop out-of-order skbs using
the resync logic and then ignore the corresponding CQEs with the OOO
check.

>>=20
>>>
>>>
>>>>>
>>>>> Sorry for the late update but these new findings are only from yester=
day.
>>>>>
>>>>> Thanks,
>>>>> Saeed.
>>>>>
>>>>>    ------------------------------------------------------------------=
-------------------------------------------------------
>>>>> From: Vadim Fedorenko <vadfed@meta.com>
>>>>> Sent: Wednesday, February 8, 2023 4:40 AM
>>>>> To: Saeed Mahameed <saeed@kernel.org>; Jakub Kicinski <kuba@kernel.or=
g>
>>>>> Cc: Saeed Mahameed <saeedm@nvidia.com>; netdev@vger.kernel.org <netde=
v@vger.kernel.org>; Tariq Toukan <tariqt@nvidia.com>
>>>>> Subject: Re: [pull request][net 00/10] mlx5 fixes 2023-02-07
>>>>>    On 08/02/2023 03:02, Saeed Mahameed wrote:
>>>>>> From: Saeed Mahameed <saeedm@nvidia.com>
>>>>>>
>>>>>> This series provides bug fixes to mlx5 driver.
>>>>>> Please pull and let me know if there is any problem.
>>>>>>
>>>>> Still no patches for PTP queue? That's a bit wierd.
>>>>> Do you think that they are not ready to be in -net?
>>>> -- Rahul Rameshbabu

Acked-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
