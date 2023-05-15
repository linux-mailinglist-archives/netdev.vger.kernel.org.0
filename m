Return-Path: <netdev+bounces-2672-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5B00702F49
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:09:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF7752810CC
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314E4D524;
	Mon, 15 May 2023 14:09:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB2E63CA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 14:09:17 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2133.outbound.protection.outlook.com [40.107.237.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4731E1BF0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:09:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARhmSMJAtEB8ph9iwu6oSHBFsBHQoctoo18kqzcXopIOf3s1UUDLxeHga++8to6ez+XkgPhdCe/xoWUoCLlrEM2Pc9PbjxqO7APFQ6z7ciEM1V0781ZOYyYlzxDcAv62KkEYJ+j26RC21h4kvPYFXI5qnQdpdT+fMwkyWWdzZIhyuSdK2IxFFSUcyh9HeUmxO/NmI59fglTLUu06+exDVZlAQo/u9yrQN8qJEOOEUPIoXBWgTZ5L/jmcJ8W8A3vfXCr34ahc9FyXxeMFOAX//T9KxhXvI4W7Nx2zosdzc3h9tpbNS9Ams03Fk7cBoFCc6ev61zaT2UVUgQsVSgGSGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RnOQgwIOjflOsJq39U0XxmmTbJ2rGEGzJPhLYNJoOAM=;
 b=Ny+BmFRuR5ElgTPDiogenLGSRb1kTkLy9f0QiBxuNj5Qh6sY53PnaL2ULEGkaQZvc6Gk/Iyb+KCxJI6DA1jyBX7AVL/2Ti93sowxO19+9I/av+E/GWTKGNsLt15AGDd4tLQGVt6q3f2Qa+TueRswjEBc4tiqzpSpYs2AoynYPa3sQPocMHfmJOBAi3rqKdH4JeR/4c9HNsT4a/keJSZHVUy5S0ZWPQlUOjZmOpySNIItgsfsbR95d0fCd2ULSRzLumd8efnFEGsP1tFxXRUE+ztfqVO9gw+egjmtnALKPSq5NLpTUjIjUdycDLwBJH+CgQfY/35Stx6n1FRKC3LpwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnOQgwIOjflOsJq39U0XxmmTbJ2rGEGzJPhLYNJoOAM=;
 b=bw0ehmyTIlBoTrXdeLi1AIVWRemTIe0wpkwjOK0SAOhhD0QRj5U8kgYrtazaCa0vF21vE9vJWC4jCGhuZ6NI8CF6z5SUruI5/xB8r+pnhLCtto1GaU7HmlW4eQCJ9gp31dIRf2kZIGzpopgomfj8VA3jkPd8Fgsxjl+3jxhOCwo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5085.namprd13.prod.outlook.com (2603:10b6:408:148::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 14:09:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 14:09:12 +0000
Date: Mon, 15 May 2023 16:09:04 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Subbaraya Sundeep <sbhatta@marvell.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, gakula@marvell.com,
	naveenm@marvell.com, hkelam@marvell.com, lcherian@marvell.com,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: Re: [net-next PATCH] octeontx2-pf: mcs: Support VLAN in clear text
Message-ID: <ZGI9ADCCUDBXtRec@corigine.com>
References: <1684148326-29569-1-git-send-email-sbhatta@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684148326-29569-1-git-send-email-sbhatta@marvell.com>
X-ClientProxiedBy: AM0PR10CA0054.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5085:EE_
X-MS-Office365-Filtering-Correlation-Id: 5748cc50-e96b-4d4e-130a-08db554df567
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DreB9vK0DqRGMtEOy8R+S+wSJERKbvND0/bc0jB4M7xh8cq4JK9MfTF9BUPk27vvCWrsscdCQ40TdAwP2cjjCGXt1BJYXZNZRlyq9IcAoSqXXHqy3in/8X6H9BjOg5loB7uMVGjlLUt82sMI9Tzz9q3GW3tOU1TQI1SJ8eqf/8F49DezVRirtiPryHGHx1w9eTnpnZctQb51xnF9Vj8+OS2IkK7lPEnlJkM60U/T6ijWk50SiUPnLcO4LkhVQH+AhSkzjh2+VzGyzt1Dykqh1ioHWrI+90qnstEQpzmMcv0aurEcTxGLZHpanyz1uIdHJdq1QMpqPoYhyIe4UApy3m9sQsDFw93iXH/jQTv8fJUO+xMjrzQnq6Jkp2gZEbvX2twEAtEIUp94Cw0WPGWCjj9bgFOYGaMnnECcZZraKVwgwX/EqvBq/MDAr4WtnbqoPSK9NKfltgUdc/A6z14BKquzXuORq1s4UWJRuBx9+MM6APYFdkCaghMzxJuFaiZ6KII+8ndA7AgVz/GQHaV4C8qM/TdpafT+efezKzwn+xiSeNrktMhgHzPhEjQrpaRW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(39840400004)(396003)(376002)(451199021)(83380400001)(66476007)(66556008)(316002)(66946007)(2616005)(6486002)(6506007)(6512007)(478600001)(2906002)(6666004)(86362001)(186003)(44832011)(7416002)(8676002)(8936002)(5660300002)(36756003)(4326008)(6916009)(38100700002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qEicaqc4Ual7Hk2fPVJWOa+OFzd7Frj+vvvyyvtaHAkxWj/lEA4vd2x1P1S5?=
 =?us-ascii?Q?tZxpn0RQmTOVVUzLZOb9UdAIwx2u8o68Me/mHendg4Lkr7x8k3GJRjdqu0s1?=
 =?us-ascii?Q?9mcBLznpWlzFehykCSXGPeNt0EBRPfS58FL7wkeYeY/VvaG2hH+Tpux/wXLp?=
 =?us-ascii?Q?C8A9kUWUZRBGwe6oiGdM7c0/aNQifLinxTdY3WOcFMUpioYUviY8ZWIjq3us?=
 =?us-ascii?Q?2igf/GJNNDCj04xqXjH5xg9oiLRTih8NkJEF0LRhI0VpunVIM1WEFBIc33qt?=
 =?us-ascii?Q?8C7cTTF3lB4u9Com9P0FK+TPI+pZPK26LZt3wC11VqIbVTOEex+3aIi6l0dK?=
 =?us-ascii?Q?cNrJZZR25f4AXMsTRXAA5hOBSBN61X2Kmfpd2mcFCgxByhlzfBpmsQgLrPPp?=
 =?us-ascii?Q?tnM8bJM59QkrSKMphMH8g1PsQKqCGJTiR1pma1twfPEwA1zE9l3j/ApWlByi?=
 =?us-ascii?Q?SnH1J/qpsDhu0MMM0OkpQrwn6vUSRmrV2p2lkCCktstWwpFVwrFhf4LzZPb5?=
 =?us-ascii?Q?MZdA/4ExcGXULtgPhHtH97MQ7EgnOeq2hqp1xECL1wU3Qh+nId3pMaP0TbUr?=
 =?us-ascii?Q?xX8efiAXwUw7e0sPbnPUc6JEzgswfHJBX2KFI+KJyls33xRFlC4v2lgaZrEk?=
 =?us-ascii?Q?0aARDeSmiM7kwf9r9PDva9LWuRPvM7ildtcBfx+5Ghqc0wmYivK1TEQTdJv2?=
 =?us-ascii?Q?rh+nRrWQbofaIqGX2ovvnleDxdObxLqgEp++OJacR+we/tdu6mrYwWJw7R5h?=
 =?us-ascii?Q?WKtJ+XG8Q1t+rI9oF2qFK7hzY7mOyadhlO1CpdKVKWqIrOSDMmy/y6KgKF5n?=
 =?us-ascii?Q?d2v3rg845BUsCH7qPiF1tkuNc9CFnuR9YbFubckR5ORUtj84X+gIr3FANkm0?=
 =?us-ascii?Q?dQiP9KbtuuYqSmfcg71i1Z30CDRrpChwM58O7WNjv9XUCwS22Z7NgN9j2PxB?=
 =?us-ascii?Q?EzDXh0UrAz3O1aM8kZlRS59SRZ49WsJQ83ocDVjK8Tx0NUUj2Bq5zC9i5V2t?=
 =?us-ascii?Q?NSqF6Qsu6TtvWXRwjaBGJO8I8zapFu0kXniICWj0DFLoCURElBSVmffICPb8?=
 =?us-ascii?Q?UH2pCX/CAeTw68Zbw96LkugzQ1Ksz4MmmCcZ3Z5+FjZ9EHRWte91L7H2urbT?=
 =?us-ascii?Q?IennmGRD5Rf0qhjoDow6GLMiLrrLRM/Ete27N/MdYOX+i5hjYIQddfJFMfyl?=
 =?us-ascii?Q?MvqQNMbrpELiBY8pguN0mBkwjgYF6TRfj4fTd2uiytWCOic8Cg2PPH0fU+Bq?=
 =?us-ascii?Q?+igy9oZ9/7AlAG6/DWCqsyQ0qivkCm5H4sUZOIG82cfKqZeK2qS//0Pbn/k2?=
 =?us-ascii?Q?gMZ6dyTyOrhyrPISbDtZX4BA9Zee8EpIQAaLQndmSAF00fpq9rjTycn38Egz?=
 =?us-ascii?Q?FKqLVlpdHcZB5SdGD0l6b1/2pSzL1muDCCnpMxx+Zc4wkrXl0o8oz7n6zZzo?=
 =?us-ascii?Q?/BEnCrwXKouUbvOVcTY3jfXffkUGlONvfkQcB7MFTPfEZrikBg7YNzx6whNK?=
 =?us-ascii?Q?5r1/mhbqOOM5GrHhRfZz/W/BMGZHcpH1nMC2pFM2oOzcVDsbV8Gv5r8YV9J6?=
 =?us-ascii?Q?YvDbo24AtZKTGou7pM/ZCcLTSi6zKR80KD8Qam7mXNW4hEUrxK4n22jKryBo?=
 =?us-ascii?Q?bSU0IjhQr6YLqrftmRSiqxoesxOXXXoqqVSogNdwcJ56AIGug6p9qfTBWau4?=
 =?us-ascii?Q?dJl3Cw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5748cc50-e96b-4d4e-130a-08db554df567
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 14:09:12.4900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRfjSCPnjHQ6DlcA+sj8Y2n3GsAFvX1u/2ZERzjV95u40SYPIYA0zFlQv5pCXlPUKYtywznv8/vZAsw8Ch1LW9Hn52DJ2+5pMsP7A+uWHQI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5085
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 04:28:46PM +0530, Subbaraya Sundeep wrote:
> Detect whether macsec secy is running on top of VLAN
> which implies transmitting VLAN tag in clear text before
> macsec SecTag. In this case configure hardware to insert
> SecTag after VLAN tag.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 7 +++++--
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h  | 1 +
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
> index b59532c..c5e6d57 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
> @@ -426,8 +426,10 @@ static int cn10k_mcs_write_tx_secy(struct otx2_nic *pfvf,
>  	struct mcs_secy_plcy_write_req *req;
>  	struct mbox *mbox = &pfvf->mbox;
>  	struct macsec_tx_sc *sw_tx_sc;
> -	/* Insert SecTag after 12 bytes (DA+SA)*/
> -	u8 tag_offset = 12;
> +	/* Insert SecTag after 12 bytes (DA+SA) or 16 bytes
> +	 * if VLAN tag needs to be sent in clear text.
> +	 */
> +	u8 tag_offset = txsc->vlan_dev ? 16 : 12;
>  	u8 sectag_tci = 0;
>  	u64 policy;
>  	u8 cipher;

For networking code, please arrange local variables in reverse xmas tree
order - longest line to shortest.

I would suggest in this case something like:

        struct mcs_secy_plcy_write_req *req;
        struct mbox *mbox = &pfvf->mbox;
        struct macsec_tx_sc *sw_tx_sc;
        u8 sectag_tci = 0;
        u8 tag_offset
        u64 policy;
        u8 cipher;
        int ret;

        /* Insert SecTag after 12 bytes (DA+SA)*/
        tag_offset = txsc->vlan_dev ? 16 : 12;

> @@ -1163,6 +1165,7 @@ static int cn10k_mdo_add_secy(struct macsec_context *ctx)
>  	txsc->encoding_sa = secy->tx_sc.encoding_sa;
>  	txsc->last_validate_frames = secy->validate_frames;
>  	txsc->last_replay_protect = secy->replay_protect;
> +	txsc->vlan_dev = is_vlan_dev(ctx->netdev);
>  
>  	list_add(&txsc->entry, &cfg->txsc_list);
>  
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> index 0f2b2a9..b2267c8 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> @@ -419,6 +419,7 @@ struct cn10k_mcs_txsc {
>  	u8 encoding_sa;
>  	u8 salt[CN10K_MCS_SA_PER_SC][MACSEC_SALT_LEN];
>  	ssci_t ssci[CN10K_MCS_SA_PER_SC];
> +	bool vlan_dev; /* macsec running on VLAN ? */

I think it would be good, as a follow-up, to consider adding
a kdoc for this structure.

>  };
>  
>  struct cn10k_mcs_rxsc {

--
pw-bot: cr

