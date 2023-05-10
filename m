Return-Path: <netdev+bounces-1541-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1726FE3AF
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8605281523
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 18:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C19174D4;
	Wed, 10 May 2023 18:13:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0680914A81
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 18:13:03 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2116.outbound.protection.outlook.com [40.107.212.116])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A631B6189
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:13:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZowhbKXllTF6RBfricxbWYa6toRPRU710yosKiNPxJf3KT8urIJe1koUrgW6Vp4Xs5JnjzUDFD0yyLmctTEOpk1k32NmRRSVIBvajYqTDRW+hoOwv1TAPwejPTrKARO2eWEl+JkBwch/AYfz/YMrADhS8JJqN3aHXFl2LG3Ltnq8gfUEZDebSRK9Y6D6Vq/58D9YeDF9Si7OwaDf/NSyVM6J+pGnB3DHvBcz+lpYpPCn9C2ALii1UiP1d1vrEWj/7Q0yb3XW1kr0lnnpB7C/qqPWk4/2GnmVPqbCJEFkSZranEEeWuQrLQn0NRNBrqM3ohY0QEAERcskDeLkn430PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHHx1CLI00RDgHO2I+tYrLcjrPb9JpyFLHhdyujhaz8=;
 b=Edh72YlC2N4MKT96YAFAVyxYr0M/jT7EhzYW8o1y863XbEKvdnu+EJQoPmz0Ce9cI8Xjz+yPE+cDHJY6QQvCeH8TEbl4G0X9zCeYUunDvHbETpzbTQj30eLmUFq/gIOfpktovU0lAGFQNX2txf6H9n7PppYbHSmXSGdJvDBhdOAcf9HtPvv/DLGXvfxNdyD0JlGIfrB9WyKr5w1yy2iszpDy765zF89xX1g5DOaJQYoLWdgAW7URoVkQVB01aYKQgN/+PERwLeDbPCeMhRh9sNaByFrsPcnfn7JTsZQXyJlX5WPvoQmbtGNyTsFwfHE0uHT+BiqQe8JfJmFqIhxsQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHHx1CLI00RDgHO2I+tYrLcjrPb9JpyFLHhdyujhaz8=;
 b=naGrT+gAehe5qQNj3ip6WJEbYZHpO+KZw489N/WbaYLA4LJIH57wlZ1q/zFhOnXXpyTGSndJiIV8xISeV3ymD/H2e9BZEpy+NDvy/nL3lDdhEbM/9pAACfsBkncTDoOCzhuG22+VpMUWpxvg2JPbo+58/ZZ+IThwv+FFivpte0A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY1PR13MB6238.namprd13.prod.outlook.com (2603:10b6:a03:524::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Wed, 10 May
 2023 18:12:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 18:12:57 +0000
Date: Wed, 10 May 2023 20:12:49 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Subbaraya Sundeep <sbhatta@marvell.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, gakula@marvell.com,
	naveenm@marvell.com, hkelam@marvell.com, lcherian@marvell.com,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: Re: [net-next PATCH] octeontx2-pf: mcs: Offload extended packet
 number(XPN) feature
Message-ID: <ZFveofGebqWWY4vm@corigine.com>
References: <1683730283-9353-1-git-send-email-sbhatta@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1683730283-9353-1-git-send-email-sbhatta@marvell.com>
X-ClientProxiedBy: AM3PR03CA0067.eurprd03.prod.outlook.com
 (2603:10a6:207:5::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY1PR13MB6238:EE_
X-MS-Office365-Filtering-Correlation-Id: de60c56a-f31c-42d4-9ec2-08db51822e8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ppc1O5bzf4zOk8pmEinrJ3oWOS+3aHRyqYr3boShRbeBwEtVtiIFjEiGVKBvmUePYOvbqbu+I9BWkArzkpHU16Rb9rKtuq4y7zW9eS5Nbx16RVMe4MBdeek80JH2fQ3q2roGQbEtLhr7OTGXz8XFPWiij4OndxKvfBkiZgH1jpOgmwOmKxNzfEX5H0sMQR98VkqievRBy47IdQHvgcJ8YJGB3aWiPLWH8urdX3cL8zJ3zCfZWHY8uuKLphYPl4taJJDESp6V1vuon/JTbMU/I+cGzN9W0P7LGqwvfEj1FbWtwqWq4zMZNz9HeQbgysiasjoMruDEEZyWgzAiF4urRXfNpp5OBhngjqEAWb7C7aKPJtUC7DQW3SbiOAKk4DiCngrASsoV91BzZ46f2qnJqQ7oQSE07toTpGqW8t2vhCglh8QD4NMx1S6G3GTImg6Kw+QJXzi6KRW7PSY0PDoiI3CnAek99nOMPLxmUr/aNv8u++QNtm+ttiV/4JUa4TcXXOipoMsaRM72+8QHS7LJH/0gxZtMDUSSn8JX8rlAOk3dVPdc1szWF4oPHrNG2HDd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(346002)(39840400004)(376002)(451199021)(5660300002)(44832011)(7416002)(478600001)(6486002)(6666004)(41300700001)(8936002)(8676002)(316002)(6506007)(6916009)(66946007)(66556008)(66476007)(4326008)(6512007)(83380400001)(2906002)(2616005)(186003)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?He1zrE1RHhoTHoh/QLRM0Y2NfwbwejWsSfLEhxGNST/dDAE86LwZMn1Vl/vZ?=
 =?us-ascii?Q?jL8XGKTceuY31biJAAtcMMNzI+QuaJAldpz4DuqBv3xFPX1InV+DTiI82rEv?=
 =?us-ascii?Q?cxFFJfym/lOnp/OK1ifuSPUVE8oINefXYfQZOLE+BTki+5nj/8sbqBLP4p7f?=
 =?us-ascii?Q?wL4LK3T1SGcTAyznoPWVOiCsE6hWP+xi6DUVQxCyrPUymttiAUDWTGs3SawL?=
 =?us-ascii?Q?vv4+fnQTBDeD2nnFndM6cd1rgrzmODe7MtcuhNtGhCfLb4yG9e6OOzMue+Ii?=
 =?us-ascii?Q?bs/7ug5ZZkrxrUytq0ZIsZQxUOelMkHnvdjUiapm8z0Frj2/AOPraD3IJZ1Z?=
 =?us-ascii?Q?M5a0pS2mI7rcHmFNTqRE/BHfwNBXy8J4xqA1k59E2Hg3Y5BqQyVetTqmvcY7?=
 =?us-ascii?Q?z7ppKIDsrmpJc3euZYR1bkGyJbYWJDT9FrgrVwAhqGruow/wYK1m6A9u5T9T?=
 =?us-ascii?Q?Yph2G+r0ERBGHO5Fev79wOCXJ9MwqwYzHhYMHgKGEr3O0FKjaP4pTqeJVhkK?=
 =?us-ascii?Q?PN0Xii+hcHzncRnzqY7jfeeF68SpZlXw3ilPaxd8ZM5McQvI+6qAcMNzsdh+?=
 =?us-ascii?Q?2M2EcCki8pCOxIuBrO/E3+ibY+Y4OOCXS+tWi5dSXFqH7G2dz193ciDeGY+f?=
 =?us-ascii?Q?Ox6qn9YC7847W3nl3Sv+X6x5GQpSUFXccjrj9ihuvdu2XozN3EtI+dtiVT6c?=
 =?us-ascii?Q?Di1z71gY6n+3u6fZpRVfv+SZSqEVGQfBX+ZybYWa77rICKlP0TOZngH+jF0C?=
 =?us-ascii?Q?RgGNFP7kStI3SFE9977QWRm185b2LrTClaWuGhmisxol7O0dunHJF3aRp1M8?=
 =?us-ascii?Q?tcewUP+RziLOyrSMqx3mK/D+KnT0wwOOYDAX+n3i/q9cHPZPmavcOEJV7ibN?=
 =?us-ascii?Q?oplMBK82Cv5aLI3r8ZqJ8lwDvWi0MOdYHVbG4QLesaeT0mYBkZW2UKRvvNL8?=
 =?us-ascii?Q?qbRcBCNuc62IAOc4wWWSSOjXPzcOu9jGu2TWy+CgLrDp1hHGzSwThYj+OABm?=
 =?us-ascii?Q?vOPw+I1vUuT6aETj/j4PxYAs+8ojej7ynHM1isImbVnNQcntb1VCO9N5z/FU?=
 =?us-ascii?Q?4l6Z5yb9h6ZLEB8APsmoYU73lfc1ra1gobTbVEYZUX01vAJF2YZSN4BkC0iR?=
 =?us-ascii?Q?sv2EWZbHDnxtCU88nTPXr5aQzJQo+SkbE+rEnbG0wpSUPTxpy1ApRrErejID?=
 =?us-ascii?Q?p5bQIfdVU93vo2aadW8MqZkfZymYlIVzmC4wcqkop4Ackr/uvpScs7oKw1yL?=
 =?us-ascii?Q?UJfZq3lSHlD5M2tzCH25/4RT68FsjOfId4HPgI9wOdxKbOhuUMeV0fErX/OV?=
 =?us-ascii?Q?GhaSfWY1Qja0J89q9zwI9uBrOTmDq1jnHX8w9cWlI9VL7dhZ2ZcFxy/AY1Z2?=
 =?us-ascii?Q?HkliBFVrMwaGLuSEQlFFqkekUr9m3h0DFH6ho/IphCIXsgvDMLUsFUJLyhME?=
 =?us-ascii?Q?JX5I6zR1v+vjqdW/P5xbNnZkKYFJ6Lz0Kidpmlz0N6obSYDCf3DbAA9MRcP4?=
 =?us-ascii?Q?oMT9rHvHfAGXaoz8DC/AakYktnCLK8xriNNZVd7wwYQDTGNaVdafMEXCo5sk?=
 =?us-ascii?Q?N6pjKDlwmGthdI/HjbB4i4e+wydO45cSBYJCMm/n9NuBOeReKTKHymAeLYij?=
 =?us-ascii?Q?Bl9P8S4HgWGaCwucG4U6aqN/0uw3Lly6sC+B5YfzaBXt029ij+L2q4cAqaGb?=
 =?us-ascii?Q?998NZQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de60c56a-f31c-42d4-9ec2-08db51822e8d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 18:12:57.6680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qp9CdSXqkIErVyMix0daBBM3PfjUPSfiniAzdRJSMmO50u8SVFpUkq/lxAsjNxklO2IcZzo2gr+gHGkyYodu0BopgtlVsAkThsWzU3RvaWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR13MB6238
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 08:21:23PM +0530, Subbaraya Sundeep wrote:
> The macsec hardware block supports XPN cipher suites also.
> Hence added changes to offload XPN feature. Changes include
> configuring SecY policy to XPN cipher suite, Salt and SSCI values.
> 64 bit packet number is passed instead of 32 bit packet number.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>

...

> @@ -349,6 +366,15 @@ static int cn10k_mcs_write_rx_sa_plcy(struct otx2_nic *pfvf,
>  		reg++;
>  	}
>  
> +	if (secy->xpn) {
> +		memcpy((u8 *)&salt_63_0, salt_p, 8);
> +		memcpy((u8 *)&ssci_salt_95_64, salt_p + 8, 4);
> +		ssci_salt_95_64 |= (u64)rxsc->ssci[assoc_num] << 32;

Hi Subbaraya,

Sparse says:

drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c:372:37: warning: cast from restricted ssci_t
drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c:611:37: warning: cast from restricted ssci_t

I think if you really need a u64 here then you need (__force u64).
But of course at that point any help types and annotations give
you have been thrown out the window.

> +
> +		plcy_req->plcy[0][6] = salt_63_0;
> +		plcy_req->plcy[0][7] = ssci_salt_95_64;
> +	}
> +
>  	plcy_req->sa_index[0] = rxsc->hw_sa_id[assoc_num];
>  	plcy_req->sa_cnt = 1;
>  	plcy_req->dir = MCS_RX;

...

> @@ -561,6 +605,15 @@ static int cn10k_mcs_write_tx_sa_plcy(struct otx2_nic *pfvf,
>  		reg++;
>  	}
>  
> +	if (secy->xpn) {
> +		memcpy((u8 *)&salt_63_0, salt_p, 8);
> +		memcpy((u8 *)&ssci_salt_95_64, salt_p + 8, 4);
> +		ssci_salt_95_64 |= (u64)txsc->ssci[assoc_num] << 32;
> +
> +		plcy_req->plcy[0][6] = salt_63_0;
> +		plcy_req->plcy[0][7] = ssci_salt_95_64;
> +	}
> +
>  	plcy_req->plcy[0][8] = assoc_num;
>  	plcy_req->sa_index[0] = txsc->hw_sa_id[assoc_num];
>  	plcy_req->sa_cnt = 1;

...

