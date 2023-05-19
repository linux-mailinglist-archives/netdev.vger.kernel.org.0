Return-Path: <netdev+bounces-3840-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81C4070912A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:01:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 571071C2122B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 831BC210B;
	Fri, 19 May 2023 08:01:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7050B3D3A4
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:01:42 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2096.outbound.protection.outlook.com [40.107.237.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929F91A5;
	Fri, 19 May 2023 01:01:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3MqnAXq+NxC58L5MNQQGwWJhU5Chixbz+ChNEPGNHTtPESDgShcEx9tiW5Fl1eC+MNTgsteUPqBpFLa9wQtjJ5uO9hKReC0FBAFv9K2EWYyox+8ZQT8kC5qmyR9IK6/Z/1dorb0BKAEWz+OKRLlRfx2evLlwHF4WLzqftBLfjSFSf+ddUle1O3dLbWcCcY3zczygdO53qjoRnhzq0Zwi3FJ8D8Xs/Q1DOPBOl4fDuJDUmfwe/150ijIh3qBW9c+5y4+T8naizq9Jp3omLS6ImYhD8E0oAUN1lCS2J7JXzpmaZkTKCyc/WFogION7Irwav+kRmT5n+OC8DNy89n7ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+78PRBA+UnUJhjaIA4ce5QY+7o099L6LnFA1vCDg1w=;
 b=bPb/fuDvNzzLASAlTpwenBFft+ggcHrPgsyLTXpYRE3Gfmcl6ser9tGjhiVe/smWFx5ahUeqEE7cWgw3W0rHQ9EBcDYLZKB8ZZVGQJnbZHDeOOBc2Q/1exy3qXnsGbGOommoril4otVHV89n7Kc78EQtc4+xn3y3hWEh9A9WvRbqV9WeCfTsbU2BRfE7OASn1U/ZflEp699iKea9neOgGhi3DEKbpmpFfICfUpmsUGw3Tmx3KZu/8PteERxPHej5hw3hYNPFRHwd3tTrFGaBzOC29gnmkbBOkaQqJgvd9HQfsjAS3xPfqytIy4p4nSJsLzoU/TBQWgIbns1F3j+wGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+78PRBA+UnUJhjaIA4ce5QY+7o099L6LnFA1vCDg1w=;
 b=H7GCJ89KSLoNYGSjadCGunziSO4Wr9fLFi3HDcf08meyrqV1Y2CZwuykti1y96IFg2UMd+dvZKYzs3oGXCae7vedJHJKXUqVP9z0KLqAYagOWawCMlvza/szuKXjm5P4+soNtox43kcenBds9XW1hhHfOF0XuC5ypTX62HNoNQM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by SA1PR13MB4992.namprd13.prod.outlook.com (2603:10b6:806:186::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 08:01:34 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 08:01:33 +0000
Date: Fri, 19 May 2023 10:01:26 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Min-Hua Chen <minhuadotchen@gmail.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: use le32_to_cpu for p->des0 and p->des1
Message-ID: <ZGcs1sdy0RTrwNby@corigine.com>
References: <20230519002522.3648-1-minhuadotchen@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519002522.3648-1-minhuadotchen@gmail.com>
X-ClientProxiedBy: AM0PR02CA0012.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::25) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|SA1PR13MB4992:EE_
X-MS-Office365-Filtering-Correlation-Id: 18ec1bc8-a16b-4842-0c68-08db583f4314
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WmJYUxLSt7jREvckRo3GDsCB20E+p1PdBYQs+FNXZCoN3gQcI3BWLO38qtJNflJaQFd3FFPMRVzQkTGTCaFKn/q0SdtrRy45EcKXg/QZ4/nsxsRVaoUpj18gLSXjAj1M/0w9OtOPLGur0BTehIQ044Dv8lfdcSgruUuucMm32gFszjYwE/u9gQtOcb+vgQR2SN+ZdN6RRoRoJDyfcchDH2+Ne1JN++gwShPer9rusx6toS6CO1IsLErSvf1v22eZ+zWp8UsHTqN3puEGuuVQ9HVqe/P2LChL9shgIvMV9qE0Ax5sNgI5qpsBln6VUWx6GrIy65DPQnu7UmeoiH6Dzvo9u8q3kGc7akp42eDlOG9WNdNd32hYoPDXUmaRPGez3FLFMsctAe9hfSCukCTP+sYYPrh/S8MpwifagHDvjh38D/dcCJJPHs5l1I8dncdkJruVw0Ga76CKiTkFd/4T3uF4lbGOB+PqkXWRYPNxmG8tYv6eqBnV5kswD970RXwSwrVlgz9/zmZpPVtdeuIh9+RA72MQjSFtC0Y2tKzrGZQkxmhfT5nogeD6FI19QPDL6VAV14o3WXOBH6sbjP3+CZzkmFxKf9EhHcCrZn8Pt+M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39830400003)(376002)(136003)(346002)(451199021)(4326008)(6916009)(66946007)(66556008)(66476007)(478600001)(54906003)(316002)(86362001)(36756003)(83380400001)(6512007)(6506007)(2616005)(186003)(41300700001)(5660300002)(8936002)(8676002)(7416002)(44832011)(2906002)(6486002)(6666004)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lxk0+v2Yc81snj7iF+xDQl25NIeAHxhMEARwgeOlpbZ2+ExfMYOzjX9bHQka?=
 =?us-ascii?Q?3xWxePMPDPMMcTqOqus950tzVEEg2Ct512C1kcgIT+s6ks71N+doEDmN+xMu?=
 =?us-ascii?Q?RotjcLShcn2nC+WFfQpaOjytlzUubjHI5xYJ5DjAkcl1u54W2GJRKJwBTAAg?=
 =?us-ascii?Q?VTQI1Hfi3EHo3AT0jP0ut5oUNQB5o1W46dMIUcAnVMV6J1y8AFIrA+25wz//?=
 =?us-ascii?Q?wIa8NCxVingOOHgFl9vR5NUtdxOVpDY0apgNpd5/dZ9kWS4nvGT9z+4qONqx?=
 =?us-ascii?Q?RGlXIOsM6DZRbk7CK9EKUR+vf9e1auZMcpr3uV76d0GHAMFjzjhN1TBYS8IM?=
 =?us-ascii?Q?uzyl8XxgoZkrKf7kQSuKDTw2UQmuZbJH/T6NR8p7rBVWunqNFVA7QWI+iCqL?=
 =?us-ascii?Q?GnYcmTFZai9cbKEXPjCpEOityjn+yYU4NvNr6C6XP4h8w0cDIfeY3HEUgd9a?=
 =?us-ascii?Q?zXbEVRdyQkhFd9xpPH1dyz06Ra/2neTJDwJuNcxGGX/DnCbFfft9V0Flqbg6?=
 =?us-ascii?Q?JzTIuQH1hbD5C+KGvxCcw1+W2rbW3/BTz6HElmw7sbkyAHfQ4kvO8KWZIJwB?=
 =?us-ascii?Q?ANqqQE8rimmquRRQM8YQ4BfquDBlliIBJtH/HCfJ0oFA1HFwa0+feXTZhdC4?=
 =?us-ascii?Q?Tlm/pg362Ie4hc/0mrh3gYW90MnMJG6+72eeVA+YEGVwnOjHgfT4ZxNzlZ/0?=
 =?us-ascii?Q?LiMOM3hg37zl1N1UcAMb/nWglZZ+Fe1oFUtelZFkCr9tGGG9iuQEeOXTOFHp?=
 =?us-ascii?Q?9KF9xT8zPUKsHcjGU016lCeT4IbTvCA1Xjs8/ds5xnGynGRbuGEoQhvikziY?=
 =?us-ascii?Q?r6FyLuLo+dz7MJuJ1WiaDzrfJLhWfzHcK+qL2HEPaTt4LrQAqu7yEKJVqIf0?=
 =?us-ascii?Q?oNwR6dVyMgYlPqnb4VDeSJNoxL3+ko8zry08c4sDLDMuKVNJVM7t2g7vhMQT?=
 =?us-ascii?Q?abF+MMh2FdM3vkKAdsElGyr+FsCxSKTiC4psygUhW4s9sog3HxUOjcCoiKdj?=
 =?us-ascii?Q?k6bTnB35olm2cMW/zOTdB1i9FjFZaQXaCcuxZuZSKu1D9XmkkRirX4lCfu/V?=
 =?us-ascii?Q?vu2V9KUoU6o1i9CpppGMOIlA27bnd5hlOUD+vZQowL4EbNk/576yRNrmqttX?=
 =?us-ascii?Q?+27GCvpeLJrhIB+v4/UJuDrgqS5LHZmuvJm3Qrr3oV6BLRulAT7xAxTYTzRl?=
 =?us-ascii?Q?yGJass1W3Q6mb166RGve4PRfA2UxPQrYC4BdVNTUzCT26EJt23pCyRzy5Dlr?=
 =?us-ascii?Q?+/jlbleq7aE7Oj41KV+T+1AbXwroG8mLueYn9bA4AT8i0h04SUPJRQQEOkoy?=
 =?us-ascii?Q?55VW2q5V/VfRmJCKsPiRnkbmceCi8MGuawXfSMbzqF7bLVril2MzqvcNDxXf?=
 =?us-ascii?Q?WQCUk8w5R9k9sMyYIOYP4SPl9LhVVjTgqRq+hji3wKNmIiuJqZSCitXPgEQf?=
 =?us-ascii?Q?vJ9TxPfT2fNauCNRIQUVnosxkBKC5VytdpDCdecYNw97AqQCK/UaGORh5/Gp?=
 =?us-ascii?Q?1pBYBnna/F+vPGWsQQVfgYkKVYySMpwrmAjZw7ZU7BzjYYemnO46gDLsJcGY?=
 =?us-ascii?Q?uJsZSH8avFnbjpkQqAQyWcM+t2+b7i0kHJFPRWFH47X4SIWv2bQYj0U3vS1V?=
 =?us-ascii?Q?eWELSqkEaiwejG9HDU+Nkbhb0QQtB8YTwz7asgdxVBGs1iOygsfo7eWYfBvI?=
 =?us-ascii?Q?W/MSXg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ec1bc8-a16b-4842-0c68-08db583f4314
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 08:01:33.8810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CPFZ1lFEewz1zvi56Mk1YQq5k+ZC0MdmYq/cthX6wZShwfLkD2NWiUTim+Bfg6kDaWXPwnt1IG3MAtd3MiurknpYAk8sMFptexqnDeYVYp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4992
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 08:25:21AM +0800, Min-Hua Chen wrote:
> Use le32_to_cpu for p->des0 and p->des1 to fix the
> following sparse warnings:
> 
> drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:23: sparse: warning: restricted __le32 degrades to integer
> drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:50: sparse: warning: restricted __le32 degrades to integer
> 
> Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
> index 13c347ee8be9..3d094d83e975 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
> @@ -107,7 +107,8 @@ static int dwxgmac2_rx_check_timestamp(void *desc)
>  	ts_valid = !(rdes3 & XGMAC_RDES3_TSD) && (rdes3 & XGMAC_RDES3_TSA);
>  
>  	if (likely(desc_valid && ts_valid)) {
> -		if ((p->des0 == 0xffffffff) && (p->des1 == 0xffffffff))
> +		if ((le32_to_cpu(p->des0) == 0xffffffff) &&
> +		    (le32_to_cpu(p->des1) == 0xffffffff))

Hi Min-Hua Chen,

I'm not sure if it makes a meaningful difference in practice - and
certainly it won't on LE systems. But I wonder if it's nicer to do the
conversion on the constant rather than the variable part of the comparison.

		if ((p->des0 == cpu_to_le32(0xffffffff)) &&
		    (p->des1 == cpu_to_le32(0xffffffff)))

>  			return -EINVAL;
>  		return 0;
>  	}
> -- 
> 2.34.1
> 
> 

