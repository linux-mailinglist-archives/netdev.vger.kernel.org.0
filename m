Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C156C8DCC
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 13:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjCYMFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 08:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjCYMFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 08:05:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20710.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::710])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E9B3AB4
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 05:05:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZk+cuJRcwc5sGRL61BerIYF+A1LVQxGGwQxIvgXG6uEvSW6Pmwy8UNmu9PytH8bMBcR0iMbHuWwi1XrXkyEC8KivxZKReW1IS/zsIsg7Hh6eHl5+lrQrFXl/JZOntG2ZSBuxtcDkt5G1L63mrhumk0UkPUxyGfmV3AIhUPjm9K2+n9q5TxxtQQ/mL2nkUHR1JzXdnsy8Lgp6l2vA3I4WRN2aCvxLYLinzWpq0oyetCi7IiAbIS9rQqqHAlYnit6DK4LQqoK7LIggJjN/fLhHkljiziebJGKKjQbrpWUpCxnd+WoNGr0coGIOj+na/D0BK7lKvyBBemvNkBgdUhATw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ET2sS7xxet4x66XWY0yXPjoXoEcUJyB+LkRo/oGylw4=;
 b=KsAhs3Vax7ssaYFHas/6WyoHEAbYB8+br3CuRYtLQB9YKAG/3gAInYihM3ZXZfEZBmLhVjed6UQ3cH+yYNA6/ss5d1jAQhs0YdyE76H62cHNyp5Jj8n2aK3s3Zlz/1UszsdZU4f7S6Ys/dKwcCjpurJymuKuhqMwU2rh4og+2dJV9NytLxjQifLIO35HQLnLWz2Wst1hj8p8Xqp0q9W4D8i0OLO563JoaVC9QDmgmhzD5pfIsdMaN+vPglUwopDKrOmtUU6prjyoVabKI2qBBsDzW1Hs/MQQRev6H4IseZR5kSzQvuNkWyNHaoBFh2q544g75VNBOJIAcyp7w3C0XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ET2sS7xxet4x66XWY0yXPjoXoEcUJyB+LkRo/oGylw4=;
 b=B/5TV2GLggRWICknHJw2Pc/4kl3px9EOLE3D9BXB5JptMtyUYjFTnpsG30K1Mzh+3affUtOvZMgyS9ZWcmTdDYrxvrEtAuqsZHu3N3eBawR3SHi8wDufFDcjFDJ+cAaYDzIO6zkwcftIANxDOUaRYPCdNzH/CTMJpGg+TVWGYVI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3938.namprd13.prod.outlook.com (2603:10b6:5:2af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Sat, 25 Mar
 2023 12:05:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 12:05:03 +0000
Date:   Sat, 25 Mar 2023 13:04:57 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
Subject: Re: [PATCH net-next v2 4/6] sfc: add functions to insert encap
 matches into the MAE
Message-ID: <ZB7jadqopcv250l2@corigine.com>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
 <b9798c4b1f176257cb9b690d350f3a3c66c1b401.1679603051.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9798c4b1f176257cb9b690d350f3a3c66c1b401.1679603051.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AM0PR04CA0101.eurprd04.prod.outlook.com
 (2603:10a6:208:be::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3938:EE_
X-MS-Office365-Filtering-Correlation-Id: 06177a95-8638-4206-6656-08db2d292aa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eT8Q9cydawPR2+mogtpsVzWfN1jVg283We2k7NirFTkORlYb0T0NkV5eT5PzaR33GxoHo1ra6+OwGtFKMTCSsCd6+ahx+xgVcu6/uSbvBgtczF2ZT9pAkPh2Bo9R30WCndO3L66V1iS1fnwWkZesWTYlaFvHXt1lz+pV1e2eZ+xs11VyeDhMuO2k1lgIDJDBCTCdn1Nk1tHg68t2FmI3tD3fRNWuET2E2+fju6nn4omvFvVURuBD7M7cwPm0Ry+PJm7OSYvuR6YcU8pT12S2MCZSmZ7P5cPdlm1aWpzKxIfMIKnAqnQzfjRHarxvZvKdAESjDFzMm0B7J3t1pNaocLdlqcVsTWVQpv4Uo7H827uCnZfqrpQSylXg/cLB3wnX3Ogbcyvx8D+AVIZrLXK8tZwSZMMf/lY+yA8e34n31R0QLcdLzbMezJPElR58vZMfHcyHFd9DEKJbM/Z3SjSPgtEtyz57jY68JAcn0bDef6+bDLCs8+QDmT35oQeWayug3iX27qxSTveAPwko4blmsjM+GmcTBFiGe6K7Jh3bflC/paZ7T25y9oqu8b3C0Hv0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39830400003)(136003)(366004)(396003)(451199021)(186003)(6666004)(36756003)(7416002)(2906002)(38100700002)(66556008)(8676002)(6512007)(4326008)(6486002)(6916009)(6506007)(66946007)(478600001)(316002)(66476007)(8936002)(5660300002)(41300700001)(86362001)(44832011)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1I6vrb0WOwes6nocUzprWK/rxbEoAB2v8fMWQK275jOk/ICis+cX1nSIqFCm?=
 =?us-ascii?Q?jkBjPdp/hMrNOFP4+EsgU6sQdq/Prxt3GDswp11WizGEqLjklY3yTwwbvYqu?=
 =?us-ascii?Q?bjOi206GcYs6ASWRUDemH0hq7AFck9ZKlaVSrInpBzXR6oEAcE3Lb6eNohSI?=
 =?us-ascii?Q?DLK2ZIxyncp32TCJngbv/1byb0fFX2hK1RN3TDy/KTHx3q6u2AakhbY/17Wm?=
 =?us-ascii?Q?oR3HHjaSlzZqlOsvuc3L8lZUUC3Q9Mua0gyOt+GSo+pICNPzDhi1Xqh1Ccur?=
 =?us-ascii?Q?UeSJyZmgjerZAyvWk6CqdcCh3T5dDYz+u4RV/LfJgWGv6cKnUCUd8Z1xpT82?=
 =?us-ascii?Q?SqbqJmlD1Xtb0spPU2ymj1ohcgubp+YRs8oIW6LI1MUVafWQATBMUMaoXeDX?=
 =?us-ascii?Q?jkIkvWtggUifk61e9Ov3WKqvQF6khb9h6beAg4Q9FEH6w5MnRC88TYVIekaa?=
 =?us-ascii?Q?rZtxLLIUW9l7ROguPs+2sz/BRky+6n3JCL8Q7vKCVf3fYjHjuGdo8iQqEaBk?=
 =?us-ascii?Q?jE0NRE4tDrdfK2xYe7Vps3daXhFhbVMZBrFNlj3J0nwN5cn47DkS3koZgqxj?=
 =?us-ascii?Q?38KCpyhCgSdlXMAVkCM4AvEPrh4If/jzTZMa9emtsyZby3bo6Im37cm/5XB2?=
 =?us-ascii?Q?XXgQJRFn/yKxncPq5y1wOBM1nFtBwjh2Y/xn8UWRrRHQwPdBfVvgyWBoZ3qE?=
 =?us-ascii?Q?U/VApl/nNlhQMbm3eI4gbPE0jaMxVQw6E26GnRFEKY69Et2VNBmqNNww72Ul?=
 =?us-ascii?Q?oQG/Cwdc02wMvoSg2nnokq624TdrGN+1KmOnXT1VTV6CZLAYScG6WOsnhczf?=
 =?us-ascii?Q?hEwlSqNbQcKnBtO9msBEUIp1VJPNnn2e9ap5nIzUGUP80cipUuysGb/GcdkV?=
 =?us-ascii?Q?ZXAQRylYOLE45YTDCvX9ltOf6kKprxi73RJaoHL11b9XvceCX+r7OCLZ1Jf0?=
 =?us-ascii?Q?30KjkxtfeGUOdLAhMVQNV1mkxAzLamuJrq4qJWQ2AN8w4Xbs6F0vLezJbj49?=
 =?us-ascii?Q?9O3twqGZkFC2KbI7WSOJQ/ZCuPP6aTLsRbDtVUXIUKvDleGMa2bcDm5kxkEx?=
 =?us-ascii?Q?IBZsNhcah3wFPtO+IW/hk5VhfYt4lQRaMtwWCs5/X+uErEjTYViKbeY9raR6?=
 =?us-ascii?Q?3Zah2x2HQq6YuB/LEw376ADIzb8E7q3vNZN8fOY9h7Wc4Gk93kDlXd/d5xvJ?=
 =?us-ascii?Q?76p/ixwte5/rjhQIOIDzg9dZimjbPTWlbQp+FniNjx03qXtyXu0awoh48bDU?=
 =?us-ascii?Q?VtYNJDVTKIHIIxjef9IL6BfTyPORgv4+mJ1T0kCHM5B7WJsXrVN4VtirWmzt?=
 =?us-ascii?Q?ocjPwOvwIyjyIDY6EWydegQsMQp/K14frNaO4uj0hQZr1IyUCj+c2EKNnb0T?=
 =?us-ascii?Q?1vTxCWsMOueBHc2LncpIIwJ/K9cAlzfIe+7FHsiudKQ7tvKF6IJ86Xtp+WNd?=
 =?us-ascii?Q?s6Mo6wRY7UPL/YwdaPTPyUuivvbZkwaWrosShTK91qsziC1YjtvCOrZOMPUD?=
 =?us-ascii?Q?rZndHveMJShYLMBqL7EcWc9VRm4spZPLcpD5g0jxgjkggJvbLDGfH5sJowGc?=
 =?us-ascii?Q?7xY5jltDiM1uzmevBGrMZi/MJP3Rzuuf1LngAmFb+WfSY+z6OF3xa3G2G3xW?=
 =?us-ascii?Q?yWX6/Ex9TBwCJDIe7fkaFkFdXaWT3TnmYtEzc06K8RFbp/H6zXtR+HhLd0ks?=
 =?us-ascii?Q?ruV3IA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06177a95-8638-4206-6656-08db2d292aa9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 12:05:03.7272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kNbkPSvgev9+749llpHHb5+7njMYe8Q0ruiXpmxILBwRJI+Lg6+2eMidPZzJALBGnlhjhfgTkWz/PUUAx6JGVkoCGiFUnvN1qD40T3wC/cU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3938
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 08:45:12PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> An encap match corresponds to an entry in the exact-match Outer Rule
>  table; the lookup response includes the encap type (protocol) allowing
>  the hardware to continue parsing into the inner headers.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Hi Edward,

this also looks good to me.

Minor nit below not withstanding.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
> index 2290a63908c5..92f1383ee4b9 100644
> --- a/drivers/net/ethernet/sfc/mae.c
> +++ b/drivers/net/ethernet/sfc/mae.c
> @@ -558,6 +558,20 @@ int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
>  	return 0;
>  }
>  
> +static int efx_mae_encap_type_to_mae_type(enum efx_encap_type type)
> +{
> +	switch (type & EFX_ENCAP_TYPES_MASK) {
> +	case EFX_ENCAP_TYPE_NONE:
> +		return MAE_MCDI_ENCAP_TYPE_NONE;
> +	case EFX_ENCAP_TYPE_VXLAN:
> +		return MAE_MCDI_ENCAP_TYPE_VXLAN;
> +	case EFX_ENCAP_TYPE_GENEVE:
> +		return MAE_MCDI_ENCAP_TYPE_GENEVE;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>  int efx_mae_lookup_mport(struct efx_nic *efx, u32 vf_idx, u32 *id)
>  {
>  	struct ef100_nic_data *nic_data = efx->nic_data;
> @@ -915,6 +929,97 @@ int efx_mae_free_action_set_list(struct efx_nic *efx,
>  	return 0;
>  }
>  
> +int efx_mae_register_encap_match(struct efx_nic *efx,
> +				 struct efx_tc_encap_match *encap)
> +{
> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_OUTER_RULE_INSERT_IN_LEN(MAE_ENC_FIELD_PAIRS_LEN));
> +	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_OUTER_RULE_INSERT_OUT_LEN);
> +	MCDI_DECLARE_STRUCT_PTR(match_crit);
> +	size_t outlen;
> +	int rc;
> +
> +	rc = efx_mae_encap_type_to_mae_type(encap->tun_type);
> +	if (rc < 0)
> +		return rc;

...

> diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
> index c1485679507c..19782c9a4354 100644
> --- a/drivers/net/ethernet/sfc/tc.h
> +++ b/drivers/net/ethernet/sfc/tc.h
> @@ -70,6 +70,7 @@ struct efx_tc_encap_match {
>  	__be32 src_ip, dst_ip;
>  	struct in6_addr src_ip6, dst_ip6;
>  	__be16 udp_dport;
> +	u16 tun_type; /* enum efx_encap_type */

nit: maybe the type of tyn_type can be enum efx_encap_type.

>  	u32 fw_id; /* index of this entry in firmware encap match table */
>  };
>  
> 
