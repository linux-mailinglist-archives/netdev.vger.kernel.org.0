Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DEC6C8DC1
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 13:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjCYMDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 08:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjCYMDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 08:03:32 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2108.outbound.protection.outlook.com [40.107.220.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17B25B8D
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 05:03:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAjWE4gycRLI/XdFptVOCRh6vhq4yft8TxPGk6aKBfEs7HuukBhrh8e5jOk+7x7mfPtbIAOwrsoNpBhzP0Y+m/Om8nsvllo668brUBrvKmZEFrUYCgNbHfK3Mo+1/kBp+R7p1nR5dsRW+0//fZqxgRYX4vbC9uIt/3xks8KxjySLHVULS4A6nwaoFQsYDfJogD7Z1cx0GDDNfJTEGR6dVAes5aF6KGPHZxuQBth45nxJgD5yMK0Z/MiAqzKm+a38nqkJAPqJ3snbJK9cYPZRvwCsX2I56viAEvfTYoAAVEodOLsiC5NdwO2xmF0D0igSBwVjAAuR+B+HwZhBL80Png==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IhDsNJDjJCKQK9wkxMvQPO0tZ0hUfA5BvCoEL6LPDY=;
 b=OmfGmz9MYpxUlO94s3laZ6r/JNMpvGXhgQMv9hfMvyXg3AdUXVySbPW5+BYHyoks5zNZvpIIB2kxAkw6dOcXKhWIiW411/Cf8qU7BjOT41OeMHY2XKRuPMSQa7JyZ3D++9BvkrZgiSUYicxU9BPc1zWtZdUlg9U7MbDQVIC1UD2zcJgpQCQG8OzGaeptd5X2HmqPr3tRda2eMMtMwDSbpgKfJ8DNaxRS6DSisZFCUZ2yy0p7VJ+qiGJmugQWcZtE/BeZ7fjiqs11RVrSwx5NAzDPSBIYQGF++jGr3STA3YAHglDy+vIzdAWK0DrnQ7QQvr6kric6UB1E2F2AgybgIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IhDsNJDjJCKQK9wkxMvQPO0tZ0hUfA5BvCoEL6LPDY=;
 b=CzrdpyX+8zz+D1Fq/SxqZUxVx0SpIGGqEaH52og/QvANRDStKsne9KVVZE2oz5Lw/TWRzfRy8OOGv1kHXe80JT4QmB3YS0POexwba6XlUtDx65PaRpsl5Y1HyeNJOrDpV6UTP41HcNi/+LpOO1VOodu4NGYXo+5pUPtWsk4hgUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3938.namprd13.prod.outlook.com (2603:10b6:5:2af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Sat, 25 Mar
 2023 12:03:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 12:03:21 +0000
Date:   Sat, 25 Mar 2023 13:03:14 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
Subject: Re: [PATCH net-next v2 2/6] sfc: add notion of match on enc keys to
 MAE machinery
Message-ID: <ZB7jApAGT9q3ntjL@corigine.com>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
 <fd5021315abf37e392e432021c6668c52da90dd1.1679603051.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd5021315abf37e392e432021c6668c52da90dd1.1679603051.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AM3PR07CA0110.eurprd07.prod.outlook.com
 (2603:10a6:207:7::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3938:EE_
X-MS-Office365-Filtering-Correlation-Id: df5d75a4-c075-4998-72fa-08db2d28ed9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: duiZhHRCvyVihtj3OgIhHcF4rDrGpRy5CDTg1RKDdDklzaEC9Sy+ke/zt4sx4LQPWg1Y9mIQQc8NItcvpmrUGwfqWkvbSI3zyrGeldV3GWYlNNZjDepiLZrzQ9HNB72lLRGdU/ZHow4zGVr9UEeDfDZI3zaXD5EPOn0QgVdsOXVgnwkP3vMZUC2iHdzoY4DaBvz3e0SiGKAO2OHCOarXRj/BhVr/4z05dEfvoJ+bYnAQFgLtVGfTw62a9YpqqeLz7TOtfkjckRI05qEz6JoczPlek3j3xkEzUdGMiKnT6nSGwSviavoevoLs9wErW+yV8IFY9TrzIPlr6To7yFWfQsKYWTd7ASzRG8eqwFE82CwA/kLdnd82wXQSCUoKiez0JAmaSW1SvGiEVKyXnZH0V3lTtEQ7B44srFoaCd1xUl+Ek9Em/z+rbt4tZ8BpzGTXUibi+mzqtbSgc0GHSQTX5MloDNKeonJ5dZ+ta5qMLl2CLMpAsg4A748m2QNrxYDm6kheDxUJRYjJ7NEBh97UsIGu1DVCiQXmCxpfkVD02u3dP0V8HEQocmcJhyAm89+C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39830400003)(136003)(366004)(396003)(451199021)(186003)(6666004)(36756003)(7416002)(83380400001)(2906002)(38100700002)(66556008)(8676002)(6512007)(4326008)(6486002)(6916009)(6506007)(66946007)(478600001)(316002)(66476007)(8936002)(5660300002)(41300700001)(86362001)(44832011)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wNovEfWSpZb40fcyVbXSk4L4KCIzio8mSLJy7cyZg3hkOX9lS335t+QaGKwA?=
 =?us-ascii?Q?6SvXRdb6t/PDBWp/a8T5eV0qbv8x0KLV31Tc7HbiI7S8Nq6ZjGZjLFpG/ccq?=
 =?us-ascii?Q?mN303BVBSBU40pO1pHQKu0atDRiarfr/rxrFxk9jB3PDHVOtzGWC6Guum8M+?=
 =?us-ascii?Q?tgt6uRAevaRakQYceTWvnGbssiMq6DvqW/YamPsqcde1qSHuf/YN0Ds+zAWR?=
 =?us-ascii?Q?6gCf22HCw349YZXKnCD5OHGO8dd1paDOnCp3JzX5AGCQ4EFrrYICa29kD6G5?=
 =?us-ascii?Q?S/FtptnXRFDeT2tbCwqrTNNsc/XcW3cM4f7xag2+olsKgD3JDgwSfjF3AJXu?=
 =?us-ascii?Q?jSK/MpDqimhhRFX9lc4caIRffMaXheMOpo54ifqkycCjs+YYmHpp8XizUffv?=
 =?us-ascii?Q?0BA0KaBfUNM+ndDDgl+kKP/kETTMVy3PkoytWeWy/72cf0nKLQoqMIBGeph7?=
 =?us-ascii?Q?HZpKTskCsjKHNM5mk/MpFpM+UYx1oS48CRDV8rlSvSUBt18sH/WtDsIK4dbr?=
 =?us-ascii?Q?c+UXwUasCh7kWP4MWZgcpXgzPUFlbuPKvF0IDvI3JA9woA1KfnoI0V6R5Wkj?=
 =?us-ascii?Q?3Ymwi9Hgrf/b4YJiyZxNmJXl4FKn9snYPfTxaXf+y0pu/6q/ba4agJ3TExAG?=
 =?us-ascii?Q?j8+cdYIF08F44tzUCngd/DexCBNwbQJ3bJLCBKv4Mox0wBb5cKBGVEJmIDxb?=
 =?us-ascii?Q?roIOGqWDsl7feinr7x/p3hGbz7+JdyxTLv42az9wxOUhcmXdDHKlNObV9Gtq?=
 =?us-ascii?Q?8MJ/2a068MwkhltOGDCuigX9Nohu0d4EX9Si73xPHcVxHPH4uwCOmigKYTLq?=
 =?us-ascii?Q?q6RyTcmCqG5V0p5Kd40smvz1vA4JVHT75mAq2WFXKNt/MyAwYpyfZYV4oSsY?=
 =?us-ascii?Q?uTKQdgV51zrgvQ0h+J4KU5Uz+LdjMhcdf4FSH4FPymkqHpPthSXDEA1kkTYA?=
 =?us-ascii?Q?C6RRWF+EqtMpIjcISVUmdhsDRLwV96AsVBvf8se2CeOm6zIgujF41GXmsNDj?=
 =?us-ascii?Q?mxCZo5l4IVCfF6QWZHUCNIbcLgFkGZt9NqF6rJ+yIJyh2cRI7rJtZGFKY3oe?=
 =?us-ascii?Q?OizhL0pPfjIV4XyU6Th/UzzKfsKXpl5AnZ6ibzirucX+j0TlHl4AepAlkm4y?=
 =?us-ascii?Q?rExuesEv6jx2fLgVwMAp4fpQmZRnOH/FjisjALIcBGKwpoFRzfChhzh0R9DK?=
 =?us-ascii?Q?m44MzDnUa+/CzPWzJeC/IS0QEEl6dcQ3BJK3FyhFsaqir9FRTxuSruf0uL4Z?=
 =?us-ascii?Q?RZ+E3WP794IHkJaKXgpZmPu6woYc9epfX/go85UJG0Jpgf2YDcy4C04tFa2t?=
 =?us-ascii?Q?n7Sm2qEZM+Hws8mTLrmQdUnJiznTzSSDki0SBFl66QesL2FIPFggbZHH+FYF?=
 =?us-ascii?Q?r103THcEeH6/RjGJDJw9pEo0Mr91FIkuAWDtcbf1YbMvzJZo3VEcPDY96AKS?=
 =?us-ascii?Q?UmtSCsp3e3oLUqjnZyNAiIb9FDREReFcj82OD5AR8a4410Gx3pzVALFCNSz/?=
 =?us-ascii?Q?FXDtEUbBV/zSGmL/nRz3ZF4/rl2Q/A7JhBmsDaFXR7GwH/70P75MZmmWw6lu?=
 =?us-ascii?Q?Y/OpAELKWfUI7DdnVkBOa/qJC//NBESG90fT7U8Ne6NaqSVkfonTD2+jCAq3?=
 =?us-ascii?Q?jNkb+4OPsaHBp1LbWCpVFicaR7Ba9FIDKaZY1hZrKdt7I4TiVxEgjMnMllpd?=
 =?us-ascii?Q?LkZFQA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df5d75a4-c075-4998-72fa-08db2d28ed9a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 12:03:21.3351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBxM/jOjbiKeix74FSIkRbjpf8Nb9oZDrs2Am8Wdr7c5kZ9g+VHTzXKVMTnGelCkQfRg6m8M2oKxjJbyBfjVIqjxoIjtkbpugtY45ZbzY3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3938
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Edward,

Looks good to me.
A few minor comments inline.

On Thu, Mar 23, 2023 at 08:45:10PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Extend the MAE caps check to validate that the hardware supports used
>  outer-header matches.

s/used// ?

> Extend efx_mae_populate_match_criteria() to fill in the outer rule ID
>  and VNI match fields.
> Nothing yet populates these match fields, nor creates outer rules.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

...

>  int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
>  {
>  	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTER_ALLOC_OUT_LEN(1));
> @@ -941,6 +1011,29 @@ static int efx_mae_populate_match_criteria(MCDI_DECLARE_STRUCT_PTR(match_crit),
>  				match->value.tcp_flags);
>  	MCDI_STRUCT_SET_WORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_TCP_FLAGS_BE_MASK,
>  				match->mask.tcp_flags);
> +	/* enc-keys are handled indirectly, through encap_match ID */
> +	if (match->encap) {
> +		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID,
> +				      match->encap->fw_id);
> +		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID_MASK,
> +				      U32_MAX);
> +		/* enc_keyid (VNI/VSID) is not part of the encap_match */
> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ENC_VNET_ID_BE,
> +					 match->value.enc_keyid);
> +		MCDI_STRUCT_SET_DWORD_BE(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_ENC_VNET_ID_BE_MASK,
> +					 match->mask.enc_keyid);

Is it intentional that value.enc_keyid is used as the mask.
Perhaps naively I would have expected something more like U32_MAX.

> +	} else if (WARN_ON_ONCE(match->mask.enc_src_ip) ||
> +		   WARN_ON_ONCE(match->mask.enc_dst_ip) ||
> +		   WARN_ON_ONCE(!ipv6_addr_any(&match->mask.enc_src_ip6)) ||
> +		   WARN_ON_ONCE(!ipv6_addr_any(&match->mask.enc_dst_ip6)) ||
> +		   WARN_ON_ONCE(match->mask.enc_ip_tos) ||
> +		   WARN_ON_ONCE(match->mask.enc_ip_ttl) ||
> +		   WARN_ON_ONCE(match->mask.enc_sport) ||
> +		   WARN_ON_ONCE(match->mask.enc_dport) ||
> +		   WARN_ON_ONCE(match->mask.enc_keyid)) {
> +		/* No enc-keys should appear in a rule without an encap_match */
> +		return -EOPNOTSUPP;
> +	}
>  	return 0;
>  }
