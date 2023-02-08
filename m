Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD2568F998
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 22:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjBHVQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 16:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBHVQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 16:16:28 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8B8CC08
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 13:16:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQjq46uOG8Q4EvQN/LXahkXO0oO020BYP/JFW7FuHFQTzFD+aAqL9CRJYIv26fvFINZnFyQD0OOhQOs4rNrwX074GUS/1vWTK1E+YA0LN9Gl0OAfTL7jAiuv73bKQZmW2VGokDDluasujLY1XoGzzGYCtZiubrUQkyFYOjP6YG09/jlI9Qflv3Ku1/qejbk4Lghgew3GNHy81BidycEnvgOK0mhm7PGH182A7rdj6H8c3tAtSluf/RMuW0s8gPbEByTG+W2EhOwsgulabclonYhq6vPrz/EXA/6RM8idMDRdbMyaMf+RZXWLV2lSj4WaiW3oQmGwgYH5Gl0JOpIo9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhO8tiGr2YASfNoKFoXxs+CQ3BJ8Qa6Ygssg75lUGxs=;
 b=NZ3qp2QZO0I3mwchacejNMyfAksjFyagbTDCOBoAOxPSKixXBLzIt+XSVwB0RBHtQTEfBzxv1f4RavOVlpBIARN9N/khvCerst6wXRaiRz23ZahToHSwmZRq+TyzTvlcOj1950CekSDuFebz7Scwe4KwIzsIXVLqEdYT61t3QYmcA3G69kTre2qNo28CiD8Qvuy4WJ5ot2nCxsRmTpx0NZiRdlBFxPwedjZIZolbf//1Fcw1UloxZ+C9YG3FLMd6sr5u8aJ5V4C0UH8xWTG1ENV1P6RJx8xMXtgxqgv6gIznFDvGINwKSj6TZ8XaL5faI4XX9u1J8tmRr1Q0X5VpmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhO8tiGr2YASfNoKFoXxs+CQ3BJ8Qa6Ygssg75lUGxs=;
 b=mNF22LGZEidzQw3WkOHc5i9ICCV+gKX3PI0O/+w2BjZ0m+fEXewRUh90CUCAqmPilfEtuJg2OoCHN81TviJTRh6nbP9/l67CZKMMHuQgOpJ/QbMpCQ/uA7+8bWE9RIUK2Ma3wig+hqN1m5EfwSGcoKIzQ9XGaM9+n3buqfvQBGSPNTCqHcyHjD8VbxaegL1uPCrUYeK90Utnl2/jHim0F5RocReZk76t4O6BbtglCRXRxC/SgatgGLYPcA15F7UREFf+UULPTtu90isE0gIroYO6ubtcQ88b7JAbfoc9/UtgoJ0iBpTPUtlpaP6M/whz2oUd7gcx+DTFdu0fwagIUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DM6PR12MB4106.namprd12.prod.outlook.com (2603:10b6:5:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 21:16:25 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.6064.031; Wed, 8 Feb 2023
 21:16:24 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [pull request][net 00/10] mlx5 fixes 2023-02-07
References: <20230208030302.95378-1-saeed@kernel.org>
        <66d29f48-f8e1-7a2e-cc46-3872a963c33a@meta.com>
        <DM5PR12MB134054EC92BC13E36B6C5711B3D89@DM5PR12MB1340.namprd12.prod.outlook.com>
Date:   Wed, 08 Feb 2023 13:16:12 -0800
In-Reply-To: <DM5PR12MB134054EC92BC13E36B6C5711B3D89@DM5PR12MB1340.namprd12.prod.outlook.com>
        (Saeed Mahameed's message of "Wed, 8 Feb 2023 12:52:55 -0800")
Message-ID: <871qmzoo2r.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0152.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::7) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DM6PR12MB4106:EE_
X-MS-Office365-Filtering-Correlation-Id: 8def3be9-1b01-48ef-2874-08db0a19bbd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xznXPYgYGEcQrCb6fHvo0j6BmzuchtR7z/nF42pJy4o1LOf/jtivw9anrp9tg/LYof0ONWFQp3T7/Hmfd/AKKY5vunh5iRojnpMB965+FRFXJPvp2SL54FBxqyATwDWljjZGP1n1FmHmygr3isZ7u0x+1+WZBJ0RGYj7ddv0J4iY/rX0uuFFWXpvfTMt5qMCvyNtpataNId8uplk5G6HQnngSCCAAVqEEZlKi/CgIzmsmTM/FDWRswg+n/S04GqzIEcwmeuXAH5dyf5cTSEIOfnvjG/wqNG870V+bXFBVfwFdFhblSU1sSdZo/OXQ7LY974nCmGboX6iBNLpo6DWss0xyVdWalvMIV/d1V0xE/hoKpg6KkxT+6LVrOePqThYaSusP8ua5XtB9GuJSjI/kARpTSwB/KPsl4PH0RfcPsX6KVhp6i1Ywo3i+on+ncEotdg6pM5Sh+n3+WWYUN2ie2rZQP+6xkv8oCnnXzi5z7gbY2WN9pEsLKCZrVRl5/D5fEHl5jPdGKJcrvHYEcxV28C3axWdGD1nRzC1SqB88rau+ckC5nmQ/DUYufo6Cd9dEksPuoFCT3g1XNcD8/g8Y5RE7dLoWLAPSjh67A1/kPhCrpfzd31niQkQYJ3QN6k3SpuCj7/YxHMrpdnZ6fES0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199018)(2906002)(5660300002)(38100700002)(6666004)(107886003)(478600001)(36756003)(6486002)(2616005)(86362001)(53546011)(6506007)(6512007)(66476007)(8676002)(66556008)(66946007)(8936002)(41300700001)(4326008)(83380400001)(186003)(6862004)(6636002)(54906003)(316002)(37006003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWZ6d1hueUZFa3pKSzJ2V1RiZSthR1ZRRDR1S003RmZiUlN3dW5tQWF2U1Ar?=
 =?utf-8?B?Y0hFTUpPNzkwNE9HeUJ5RndRRnVlTldxZG9mbU83ZUdSWEFYcHpRZWFNQVRp?=
 =?utf-8?B?MXNLYzlYM242SFlIelZSLzk3ZTMrdEUwZWlWbWtlTHNhRkl0V0x3TWpub0VY?=
 =?utf-8?B?OXAwajdVL1ZmdlNqaDgrelRrd1kzR3NHM3d1VjBDemhGb1Nqd3NDWU8rbzg1?=
 =?utf-8?B?am0vVGROSXlGY05NMXhQVnIzY09oWEJiTi9NazMyU2xwcEszcW11ZmpqL1E4?=
 =?utf-8?B?VkFDK0MxY0h5amN3QUhhMDlUYmpIN0Z2cE81d01TY2R5bFhYY2VPdlJ6bndV?=
 =?utf-8?B?YWkyRHkwbkZ2aTNId082ZXFvZ0xYY2NYQzhkdkFHOGdOQUs3UklrTDUzdktp?=
 =?utf-8?B?eXB4NTJBSHBMWmdWZ29HM0VtdE5hVlhSS3pJbFZ5cExnMkYyQWlwalVYVDE1?=
 =?utf-8?B?OFZ4a1ovK3F0eTVuWFNvVlZSb2dqM2JGbGxVWWlXR3U3cXNacW1XRXZmS2Z4?=
 =?utf-8?B?Ky9HOWFlR0xRNzYwMjQyZzl1SWtaSHNIeTNXb0pMN0lETFBFQW8zRmdoalhR?=
 =?utf-8?B?MGp4emVjVDR1V0NZUWFvSWN6V2l6Uzl1UFhqeUZ1ODdPelZ1N24veHBKazZO?=
 =?utf-8?B?QlJ2bEJSazBHY1ZlTHNLM0R0a3FESm83TjI4a2UyQTYzU2o0d0N5VXdkUXlU?=
 =?utf-8?B?b2hGeWhZTEZ5M1JYMUVHQVVGRlRSZHBRWjkyTUZ0Q3hkajNodTlqVmhqTHBh?=
 =?utf-8?B?U0hWSEhhRzJJZEp1ejUvby9wcXVQcGJWdndhVnRsUEVwVnhlVTRUUFA4c2Fp?=
 =?utf-8?B?Zmt6eEhnV2pyTERIWHFDM0c5aVNDZi9hWUVOUXlYNTJZM2N2YjdlZTgzSU5q?=
 =?utf-8?B?OStiWkt6aFRzaU9zSFd5V1NOeHVhTjV2WmtwMTJVMnY3RGlKVjFTQnRoeVZ5?=
 =?utf-8?B?akhqaUkvZ3BOejhQUHFUR0I5dkd0RzNqU3oxSm1CdU1KZVVIZytVZmdYOTBE?=
 =?utf-8?B?ait6TkdpU3hBSjloaGpmUEJJcU4zSEJFdmdYR0RxaXFlRUJHSnl5bUNkUlFo?=
 =?utf-8?B?Q2EvUzc0OTNlRzhIMmQvRHM2N2RkdDIzSlJVRElrbmE4cjVENnNZRVErSzhI?=
 =?utf-8?B?aUJPZWF3dHRXYlVETjhaU0x1dDd6eU55RXlnaitxZmljWDNpSVdSQ2crUWNT?=
 =?utf-8?B?RW9JdlViRnROYzBkUjVtSlRYWWJCcXcvWkd6d3k2eHBzWDBha2NLNEhyUGpN?=
 =?utf-8?B?SWZqaUtETFRmcjBBRm5rVDNCeDIxUm9CNWpsazIxRU85TnlRNmFhWlZBYzRY?=
 =?utf-8?B?bFUxQzVib3JCYUdwcUVrSlY4blUzQ0FFNjhRdkVsKytHNkhWYTBLZ1pnVGtR?=
 =?utf-8?B?QTErVldjdzRPS1d6cTdGKzd3Mm5Nd0xrVnFBVTB0em5IN05TWit0Vm1vY2tF?=
 =?utf-8?B?WnZhVmFDTTAzbFBSNWVqaTdISE4rSFE3RkFFbjZyVVA1ZGl1U1VYR0N5VWM4?=
 =?utf-8?B?dS9SRSsraFpQVUpuU3dOd3p6U0RJa0NXcEsrRXg2N1p2dGhvaHJTa1kvbUFQ?=
 =?utf-8?B?NlIxeFk0ZlhIUE02SXhJNkJ6SUlaVi8yNlVPYXY5b251SC80Rm9yMUVBNENm?=
 =?utf-8?B?cjJlWFNzUCtqTStkY0NPb0VWZUo3MXZrQzUxVHFMQWJsMU9aWmdOSW8zVm96?=
 =?utf-8?B?dnYyMGdKbytiNUlDZlBTbWQwaGRqZTE5MzU2aDlDZXgyVmFuM2gvZ3JpOHJi?=
 =?utf-8?B?OTdEeW5YZERyV0xwM0F4M2N1WXNuWXdYak5rb3J3WEtIdjhKNWlqTUtVUkZo?=
 =?utf-8?B?ckp3QnV4VXBsZkpYcXhiVy9YNG1GQzNEMmVrN29aQjN5aTlrMnNwZDRDamJw?=
 =?utf-8?B?dDArT2IzM0E3K1JPN2wydTdIQllNdTlkeUNKSmlHem5CQ3ViZG9xR3FlTjNn?=
 =?utf-8?B?OEo1NW1QRkpzMHVURmhuV1VWSllWKysrNjNmOFl6L0tBYjBjajc2akE5YVdZ?=
 =?utf-8?B?d2xxYXV2TG1RZzg5bVdFZ09jL1Q2d2RTLy9MVUlMbFJubzFZRHFmbzF2VE5X?=
 =?utf-8?B?OEZpWnJvQWQ3VHIzQmZYL2Y3RWJUTG51SnZHQ200VTdyRGF6bHhHWW1MUjZu?=
 =?utf-8?B?UDRNbmxaWHNMWVgxQUJZeWJqVVpRYnp3QnJJUWt2aFA0eU9rakNiN2dXcFRi?=
 =?utf-8?B?VCtiR1dyc3FGbGIrbDFCTWVQZlNqeFU4KzBjemFub3NmWVRsSVlDVVJBNElj?=
 =?utf-8?B?M0plM0pSbmpZZXBnWHM2S1BxNi9nPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8def3be9-1b01-48ef-2874-08db0a19bbd0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 21:16:24.6685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9L6ncPlBXZqaGUnxedvWOtLiIdMBuIFu2FqZbwNxCGogh/r0BkriW97hzWc9cVag6dYtotTyIMCWSzT/kSGpIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 08 Feb, 2023 12:52:55 -0800 Saeed Mahameed <saeedm@nvidia.com> wrot=
e:
> Hi Vadim,
>
> We have some new findings internally and Rahul is testing your patches,
> he found some issues where the patches don't handle the case where only d=
rops are happening, meanings no OOO.
>
> Rahul can share more details, he's still working on this and I believe we=
 will have a fully detailed follow-up by the end of the week.

One thing I noticed was the conditional in mlx5e_ptp_ts_cqe_ooo in v5
does handle OOO but considers the monotomically increasing case of 1,3,4
for example to be OOO as well (a resync does not occur when I tested
this case).

A simple patch I made to verify this.

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/ptp.c
index ae75e230170b..dfa5c53bd0d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -125,6 +125,8 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq =
*ptpsq,
 	struct sk_buff *skb;
 	ktime_t hwtstamp;
=20
+	pr_info("wqe_counter value: %u\n", skb_id);
+
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
 		skb =3D mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
 		ptpsq->cq_stats->err_cqe++;
@@ -133,6 +135,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq =
*ptpsq,
=20
 	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id)) {
 		if (mlx5e_ptp_ts_cqe_ooo(ptpsq, skb_id)) {
+			pr_info("Marked ooo wqe_counter: %u\n", skb_id);
 			/* already handled by a previous resync */
 			ptpsq->cq_stats->ooo_cqe_drop++;
 			return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index f7897ddb29c5..8582f0535e21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -646,7 +646,7 @@ static void mlx5e_cqe_ts_id_eseg(struct mlx5e_ptpsq *pt=
psq, struct sk_buff *skb,
 				 struct mlx5_wqe_eth_seg *eseg)
 {
 	if (ptpsq->ts_cqe_ctr_mask && unlikely(skb_shinfo(skb)->tx_flags & SKBTX_=
HW_TSTAMP))
-		eseg->flow_table_metadata =3D cpu_to_be32(ptpsq->skb_fifo_pc &
+		eseg->flow_table_metadata =3D cpu_to_be32((ptpsq->skb_fifo_pc * 2) &
 							ptpsq->ts_cqe_ctr_mask);
 }
=20
Basically, I multiply the wqe_counter written in the WQE by two. The
thing here is we have a situation where we have "lost" a CQE with
wqe_counter index of one, but the patch treats that as OOO, which
basically disables our normal resiliency path for resyncs on drops. At
that point, the patch could just remove the resync logic altogether when
a drop is detected.

What I noticed then was that the case of 0,2 was marked as OOO even
though out of order would be something like 0,2,1.

  [Feb 8 02:40] wqe_counter value: 0
  [ +24.199404] wqe_counter value: 2
  [=C2=A0 +0.001041] Marked ooo wqe_counter: 2

I acknowledge the OOO issue but not sure the patch as is, correctly
solves the issue.

>
> Sorry for the late update but these new findings are only from yesterday.
>
> Thanks,
> Saeed.
>
> =20
> -------------------------------------------------------------------------=
------------------------------------------------
> From: Vadim Fedorenko <vadfed@meta.com>
> Sent: Wednesday, February 8, 2023 4:40 AM
> To: Saeed Mahameed <saeed@kernel.org>; Jakub Kicinski <kuba@kernel.org>
> Cc: Saeed Mahameed <saeedm@nvidia.com>; netdev@vger.kernel.org <netdev@vg=
er.kernel.org>; Tariq Toukan <tariqt@nvidia.com>
> Subject: Re: [pull request][net 00/10] mlx5 fixes 2023-02-07=20
> =20
> On 08/02/2023 03:02, Saeed Mahameed wrote:
>> From: Saeed Mahameed <saeedm@nvidia.com>
>>=20
>> This series provides bug fixes to mlx5 driver.
>> Please pull and let me know if there is any problem.
>>=20
> Still no patches for PTP queue? That's a bit wierd.
> Do you think that they are not ready to be in -net?

-- Rahul Rameshbabu
