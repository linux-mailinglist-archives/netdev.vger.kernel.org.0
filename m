Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1DDB68FB9D
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 00:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjBHXwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 18:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjBHXwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 18:52:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DB118B29
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 15:52:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KV6IuJP/czbpSNRPdvb0zIP/Ki8g2/hkP8v0fGBIGNobBH2X6+CaC0LuLhXzddYMurl66RTbwC5eo8JKMHdkk/vERpnSO2GotcwqrRSCa/zpNH9ERhCBfb6BtPUXZd7UJD+ISfte8i8g43YI8uYe7+7ujxhODAqAaJJA2FMz3GxQ1qq/5Z2fCuh1GI1/iSmUeJMAqirvogUh2i7qrvVOU6cjJIBGXyi/fNvsoOCG9M4IXGAxN67hMjLOFgVta0tpFCvf36j+7htaR6oIaQ+7AtScTv6q1HBbbLKxu9spKl5DzXPkBTqEavZpZ9BImanpyCur6VyJySS1f8phH9Bv4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Av4+QbhpEjnAQrc96IJNxDCEttul8pP4E3lC/vMvXYc=;
 b=BgRp2bzTOIvlHhYNNeQjlhyxM3KO4FWFIEdp5yUrQYZN3NvlLoSsfqYZAaeHeFuJ+3GQfnDi49XVk8GnIutPFxJ854PJlKuNo7ARUqIhAT8BZTbZ5E1ZC8QTyBTII3WmAFECqby7f33F0hb3ZTXlNRR4XVGtSX3NJwmg6OzVkyspR/8h4VGzljI5MaDBEh5ceVMV4of8K2OxVKZGQgJxyZwb1pjaVgwJe1SurmGBBib3XcLaTqRR9Wopn0zsTGq3DU4zFM9zKud5kFYYTls4pjnq++IJpmsZM4p3l4u+EP2g5sSRAE6Gb+4oYZCas3UXnCtXGjFQiqBvSKJpvRlOuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Av4+QbhpEjnAQrc96IJNxDCEttul8pP4E3lC/vMvXYc=;
 b=HuERAC8CdwmQ/woRPQuEM5YD6sGFLzNp0BlMnPKBxWox3UaSspIo3PK16cieufpN4NKxoJanJLjntQi0N7PuxsPo/ePvPHAgvU3FZgdCZ1hN/9gXQdpclE88HNilpU2AnGMvTosTc0B1uddjjv4Fx2nG12SgjHYG27GmtCbEWntm0sO3lHfjPQ9Q6s3Ep1TkYPv0E0LpRmP9XrKH2ER1QUFEk2emokyRBz4catbr5QF5CKW+0E9AgQDjF5iemhTB2qS8JPa0ruJQViuvToy3BFa2L0IcvJmm8fFJ+kyXHytzvs9mszHL2+2Zd/3GqNga5pSsuFhA2VeU5lwkjdYk2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by SA1PR12MB6703.namprd12.prod.outlook.com (2603:10b6:806:253::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 23:52:49 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.6064.031; Wed, 8 Feb 2023
 23:52:49 +0000
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
Date:   Wed, 08 Feb 2023 15:52:12 -0800
In-Reply-To: <3af8d360-bccb-a121-8e97-82a00472c93e@meta.com> (Vadim
        Fedorenko's message of "Wed, 8 Feb 2023 21:36:52 +0000")
Message-ID: <87ttzvn2ab.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|SA1PR12MB6703:EE_
X-MS-Office365-Filtering-Correlation-Id: fb599e8f-cb12-4296-ac4b-08db0a2f9558
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ToyiMq4IGCfULPemKHqmR7Nt+pXncMrfbc77Wig+JxzA0riyz4u6ktYWSzScCHmjiJD9H7UQSw7FFE9BHE67OGJyGBVAj0FHTM4EvQmZho/cstNFYcrgbgkdx3iSjppaaewW9/Lg2+cyW95ZQ2W1qXMqX+zpCxNejPsozHvxshEsv7aamUF3U1/kmuL5EXDpUmiVpPoktgbzslaWjrtJDy1N1GtviFN+IqnF83+A5+uTOL/l4Fdc9dNiZDTwtL2Sl9SbsHJpWIp/E/lCzheAMj4o3Jmk0c7JMeeA6rFV0QWUpPsPGLW8L0GdVaf+pnEWvvQwxMTE+z7ouwheCX81eKJMzqPLensMWQ4ydtWf1kQCC/E9lGxnXTdTuBJ6Kkg5XxAsOc+PgbSGrwZHwGEVRtUkEpRTcSneP09yl9KyapQvErOv8Rqb3gJAC6IROaM3PsxGP53enQI9DNHt7fftYup7Bv3Lv/1LeFupsE5B70xwzk7V37QSR9vnlq3uco5GcJ46IM2uQaPfNHb9Lq91GZgZe7/tc8NMX8YuuP2MIZndLzHywErkg1eqCaqR0c0QtJXDrTGbSSDSmaGtSbOVD+3NnyHADpdItqkJZx4SVFoiF4tn3uzZmvePuO8vT2X91QTfzrvU2Ubce+QyjbHZnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199018)(36756003)(86362001)(38100700002)(54906003)(316002)(4326008)(66946007)(66476007)(6916009)(8936002)(5660300002)(66556008)(41300700001)(8676002)(2906002)(2616005)(478600001)(83380400001)(6486002)(107886003)(186003)(6666004)(6512007)(6506007)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnZJOGdMbVBBbFlTTEpzTlY2L005K25RY056M2MwT0RZZkwyQm1VdFVveFcx?=
 =?utf-8?B?RW4xU1lsTHhKUWZYU2ZXWEVrWVpvS2ttRUI1Sk80NEpjai85U2JNbm55dk44?=
 =?utf-8?B?dmplSEF0MjFKaUgvNG5rby9pc2laSTZwaElNUlFGdFBReS9BQkNBWkd1am53?=
 =?utf-8?B?TjJGeHBlRzl5aHhuMVU3cno0QU9CNG9PdjBzWlRZK0c2cW85cHVscFBLWW5L?=
 =?utf-8?B?NVIzbnFEd3p5bkR5TlZydnljWGxCWUsveHRXUllQRnppVDNWNkVpSlpRZjZl?=
 =?utf-8?B?NnFwOTRxa2FCMG10OGl6VENBaDc5TjNMcDhYSllqZmlEbFRnRFExd0R4Y2hF?=
 =?utf-8?B?a1hHOFBJY3Z1YmZuUGx2czZoVm1IWDRQWHIvRFNTQk11ZCtYZFp0d0NVR2Mr?=
 =?utf-8?B?UkppdmtZd2V3Mm9rZXZ1SG9ZU2VzcEFQeEV5N0c2TGlYZk05MUFuS1M4Wmlj?=
 =?utf-8?B?Tzk1OXYxK0tGNCs3eWdIb3NvMEtoRSt3dEJXMW93RWdmcDRNOHlnQmVrQmxt?=
 =?utf-8?B?MkVXTjd5Q2UrT09CVWd3ZUo5dHBLbm5lSmUzU1Q0NGw5bDZneGltWndyeDRS?=
 =?utf-8?B?bThTSFlrenVlYzZDNFhIbklnTFNjSStNVVVHVVdhTkFlbjNYTGRnRGMrQVVG?=
 =?utf-8?B?Q3lzRndzTkduVWlOQnZYOWZWUGhtWC9CMFg3azJBOFE4TzhNUUdyOXExT1Iw?=
 =?utf-8?B?dlJTNElYVXNHUTJuNm5Hcmx1SHRjTXdFRTdUMGpuWWRZRjdWOFh5dklWOThp?=
 =?utf-8?B?Z0NyK1NLcXZCUE5FQlUrOVNMR0NHSVNDM21PNFlWbjQvU01FWEdwdWZQRWtW?=
 =?utf-8?B?ZEJjM3JJcTBTL09wNm1TWkExS3JxZmpPanZFQTN3b1VpeEszb1Z0Vmx5WkJw?=
 =?utf-8?B?OEZYU01ieG1qVUx3U2dlRDlvOHZ2UU5qRkxlWmppZFFsM0xyeG4xckMvMVVN?=
 =?utf-8?B?b09maC9GVHpNVzVjdWVXZ005aGtpTjZYQUlIU0VRb2lqVCtYTlNnZ3RKb24v?=
 =?utf-8?B?RG4rR1BKejFONXhPb0ZMMnVGSFhZUWV3NndxZ3V5WFlwWnVOQ2tJN043aHht?=
 =?utf-8?B?cDJLMDVoZXdqQ0tIY21SOFdyeExiaEsrRGFBV0RNRFlhcHZXYzJaUXQ3TW1D?=
 =?utf-8?B?WmFoWG5COW1jK0Z1OEhhMm9QL1IrTlpUbTZzRDdYZ2hxeFpjWW9mRk8xOXhk?=
 =?utf-8?B?akd0bFFzbnlBd2JaRUxEZmp1azdOQXlFMXN3Vk9RbGN5WklEb3l5U2tPQ2VG?=
 =?utf-8?B?UUw2OVRIc296L1g4V0RRSXdXTWtEQVRveDFLdjdjL09EYTRyeVFlYm9TbFBF?=
 =?utf-8?B?Yk83UDNQQzViSnpQb1NRMWpVT2IyR0RqOUdPMmtYZ2U2RDc4eXk3WG1rWWpX?=
 =?utf-8?B?MGFQMEZZMng5bXc0QWozUGJyNW5tc2U4QTZoa1JSTkErNGFnZXVJVFU2N2R4?=
 =?utf-8?B?b0tJRnREeHlYK2lLd1VFM0dPbFhZUXp6bU9hOFB6aGtUWVZQRXJNTkRlNXlo?=
 =?utf-8?B?Tno2RlMwN0Z6R2R1NzRLVzBnc08wZ3kxSzkrcjBEL3hsTEtYLzhnUU84cjRh?=
 =?utf-8?B?Q293RGJGZDF5RFVzc3VNaHI4WlRHYWlOWEhTdHJIYWxsT2Y0MVVLbXZUZmI3?=
 =?utf-8?B?d3F5NmlhQ3RlTWcrR1FrV0NXRTlxdXQyS1p2b0p5ekRid0dVc05IaGc4TVRB?=
 =?utf-8?B?dm9qb3BUY09RVjZaMnl4UkRsSFZjakxRMEE4K2tJalNmSi96M3czTzRxQVJH?=
 =?utf-8?B?OGdxMGxCQWY0T2J4U0FLZDZRNjdUZlNHR1hkT2t2QWtGZXJkTERJc29kYWJv?=
 =?utf-8?B?aERCUUdhL3dZT0hpNXh0NUpIbXE1c21JQ21VK2pJUjdLUTdJWGtsUXk5WWh1?=
 =?utf-8?B?eHkvK0R5VVdzWldNa0orWmcxKy9zUkU0eXk1RUxVL1ZRQkp2QzZuUlJYeVpK?=
 =?utf-8?B?TlZJUXl2MDR4NWg3VDZ0L1lYQ0lxaW5peFRTdjhpY01VbjZyN1JCdFVEcWJX?=
 =?utf-8?B?NWczRUJIRjY0aDdJbmY0aUp1UFBTOE5WVmFkbkhHOFVoZkpJOVB5bnEvWmlj?=
 =?utf-8?B?blpwejU1M2pTQitCaTRTb1lqVzNJS1ZBNFB1bjdrQ1NabVd6VFpaakFqWlUz?=
 =?utf-8?B?MTRTYVV3L3JlVk10elErVnlhZ1I4MEF1L29WNkR1eEQ4V2s0azBZNkxSS0lw?=
 =?utf-8?B?cTBuM3pWZHFIL1N2RityUXlKTWhsYURoaGMzbWxjU1U5bC8yaTZaUnc3MWNB?=
 =?utf-8?B?TTRrRlgxOWJjRmlTakdsK1A1cGR3PT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb599e8f-cb12-4296-ac4b-08db0a2f9558
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 23:52:49.1226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d1w92MgY3SIHPIZPmmdt20FPpSZD5FhULf4OzpoHzmjNJ9B0rEhSwwNZEGhfBEA2EqTP1+x8ClE98VPt8Knaqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6703
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 08 Feb, 2023 21:36:52 +0000 Vadim Fedorenko <vadfed@meta.com> wrote=
:
> On 08/02/2023 21:16, Rahul Rameshbabu wrote:
>> On Wed, 08 Feb, 2023 12:52:55 -0800 Saeed Mahameed <saeedm@nvidia.com> w=
rote:
>>> Hi Vadim,
>>>
>>> We have some new findings internally and Rahul is testing your patches,
>>> he found some issues where the patches don't handle the case where only=
 drops are happening, meanings no OOO.
>>>
>>> Rahul can share more details, he's still working on this and I believe =
we will have a fully detailed follow-up by the end of the week.
>> One thing I noticed was the conditional in mlx5e_ptp_ts_cqe_ooo in v5
>> does handle OOO but considers the monotomically increasing case of 1,3,4
>> for example to be OOO as well (a resync does not occur when I tested
>> this case).
>> A simple patch I made to verify this.
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>> index ae75e230170b..dfa5c53bd0d5 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
>> @@ -125,6 +125,8 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptp=
sq *ptpsq,
>>   	struct sk_buff *skb;
>>   	ktime_t hwtstamp;
>>   +	pr_info("wqe_counter value: %u\n", skb_id);
>> +
>>   	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
>>   		skb =3D mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
>>   		ptpsq->cq_stats->err_cqe++;
>> @@ -133,6 +135,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptp=
sq *ptpsq,
>>     	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id)) {
>>   		if (mlx5e_ptp_ts_cqe_ooo(ptpsq, skb_id)) {
>> +			pr_info("Marked ooo wqe_counter: %u\n", skb_id);
>>   			/* already handled by a previous resync */
>>   			ptpsq->cq_stats->ooo_cqe_drop++;
>>   			return;
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_tx.c
>> index f7897ddb29c5..8582f0535e21 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>> @@ -646,7 +646,7 @@ static void mlx5e_cqe_ts_id_eseg(struct mlx5e_ptpsq =
*ptpsq, struct sk_buff *skb,
>>   				 struct mlx5_wqe_eth_seg *eseg)
>>   {
>>   	if (ptpsq->ts_cqe_ctr_mask && unlikely(skb_shinfo(skb)->tx_flags & SK=
BTX_HW_TSTAMP))
>> -		eseg->flow_table_metadata =3D cpu_to_be32(ptpsq->skb_fifo_pc &
>> +		eseg->flow_table_metadata =3D cpu_to_be32((ptpsq->skb_fifo_pc * 2) &
>>   							ptpsq->ts_cqe_ctr_mask);
>>   }
>>   Basically, I multiply the wqe_counter written in the WQE by two. The
>> thing here is we have a situation where we have "lost" a CQE with
>> wqe_counter index of one, but the patch treats that as OOO, which
>> basically disables our normal resiliency path for resyncs on drops. At
>> that point, the patch could just remove the resync logic altogether when
>> a drop is detected.
>> What I noticed then was that the case of 0,2 was marked as OOO even
>> though out of order would be something like 0,2,1.
>>    [Feb 8 02:40] wqe_counter value: 0
>>    [ +24.199404] wqe_counter value: 2
>>    [=C2=A0 +0.001041] Marked ooo wqe_counter: 2
>> I acknowledge the OOO issue but not sure the patch as is, correctly
>> solves the issue.
>>=20
>
> With this patch it's not clear how many skbs were in the queue. AFAIU if =
there
> was only skb id =3D 1 in the queue, then the id =3D 2 is definitely OOO b=
ecause it
> couldn't be found in the queue. Otherwise resync should be triggered and =
that is
> what I have seen in our setup with v5 patches.

With this patch at the time of testing, the pc is only 2 because we
skipped generating a WQE with a wqe_counter of 1. This matches your
expectation that it's OOO since we don't have a pc of 3 (wqe_counter
<skb id> 1 was never actually put on the WQ).

One thing I am still concerned about then.

  wqe_counter   0   3   1   2
  skb_cc        0   1   2   3
  skb_pc        4   4   4   4

Lets say we encounter wqe_counter 3 and the pc is currently 4. OOO is
not triggered and we go into the resync logic. The resync logic then
consumers 3, 1, and 2 out of order which is still an issue?

>
>
>>>
>>> Sorry for the late update but these new findings are only from yesterda=
y.
>>>
>>> Thanks,
>>> Saeed.
>>>
>>>   ---------------------------------------------------------------------=
----------------------------------------------------
>>> From: Vadim Fedorenko <vadfed@meta.com>
>>> Sent: Wednesday, February 8, 2023 4:40 AM
>>> To: Saeed Mahameed <saeed@kernel.org>; Jakub Kicinski <kuba@kernel.org>
>>> Cc: Saeed Mahameed <saeedm@nvidia.com>; netdev@vger.kernel.org <netdev@=
vger.kernel.org>; Tariq Toukan <tariqt@nvidia.com>
>>> Subject: Re: [pull request][net 00/10] mlx5 fixes 2023-02-07
>>>   On 08/02/2023 03:02, Saeed Mahameed wrote:
>>>> From: Saeed Mahameed <saeedm@nvidia.com>
>>>>
>>>> This series provides bug fixes to mlx5 driver.
>>>> Please pull and let me know if there is any problem.
>>>>
>>> Still no patches for PTP queue? That's a bit wierd.
>>> Do you think that they are not ready to be in -net?
>> -- Rahul Rameshbabu
