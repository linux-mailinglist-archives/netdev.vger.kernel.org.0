Return-Path: <netdev+bounces-2103-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25B8D700447
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:51:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3E811C21134
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:51:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFC56BE6D;
	Fri, 12 May 2023 09:51:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A73BA3B
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:51:44 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2135.outbound.protection.outlook.com [40.107.94.135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04420618D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 02:51:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgHVTOv1zWZOTfFyXTCGfPHX4SnWuWNk1yie0jaf2HdvSHLhXvRcqrvkr20C38gZLgYk+ync6tH37hCoc8o+Flz1ibjQ+a8Swzl31Zx3ZVRr04B9jxg/0HvRFDXwTXR6VsToTfdE9h6Q9zSiZ08jr5YEj/HHtr5K+/1dmb2NE/e2Y+XaBRfyemcyWzsldjNHWoWMC4xFtQzop+/HeUZJwhwBiJ34Q2+6YrPtnqcmEd+Lv4TUEWF4l41vb3jlfsnC2aLNwWyX+hQUSTdyiUtCzo8CaXI5cwqAiPibod+qyA2Tce1xefDan5Imq40bjrWcHCPcvupLFXxGLSuAASTHYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oR1z9hP97u68uZtS5hSfn+BtpjD39hC5w7gyBeycPK0=;
 b=WfTURWuMIDH0Gs4Ag4Gdilr+CY0sgLkezr6KOM0qbp+45gtxze6qashrqJ0U963FX5vJ52Ti/dGIcoNxcrjBg3jPtAxZF4yD0sFrvjiwxHD40UBHZg7j36x7H9IOhXJ/ZGVgEYvSt2/2rfbLl6Jig5RNlLiyaPBJJqs7/dq6OfRXpM9opr4Cor459ufZsUyyNnuZG9uM0Wq1ngkvj4DYX7tI9DlbFAc6WlpwWYLaPxzt+Sx4pm4Bc+hoYPeO9P2f629ifBAjm66rCjEfrWbbHrEdSPAiQkVyPrP2mbaU7TASaMK3NWiXoj8idvRUX0EZACLcyGCoAiNtnXPeWZPxIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oR1z9hP97u68uZtS5hSfn+BtpjD39hC5w7gyBeycPK0=;
 b=lq9VtE9Sy4SsK/ig4/XjWME4KRlDe3NaTuvupR2Qq06W5jGsOo9LKZupw/iJ/oKtbkThvKL4A4GhYVRuHHUsERH9OWMLm+noMAggDGCaWM2eIZgtjhG9vNIYSyDSfen9TO91z54hQEQ/w4YPOW8t3y7UhzXIeO19BJ338s3EKdc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4757.namprd13.prod.outlook.com (2603:10b6:408:124::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.23; Fri, 12 May
 2023 09:51:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 09:51:40 +0000
Date: Fri, 12 May 2023 11:51:33 +0200
From: Simon Horman <simon.horman@corigine.com>
To: edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com,
	Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
	habetsm.xilinx@gmail.com
Subject: Re: [PATCH v2 net-next 3/4] sfc: support TC decap rules matching on
 enc_ip_tos
Message-ID: <ZF4MJaY8/3bC4G5e@corigine.com>
References: <cover.1683834261.git.ecree.xilinx@gmail.com>
 <acc9f66562f7a82b2b033bc3ee3470e580036b81.1683834261.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acc9f66562f7a82b2b033bc3ee3470e580036b81.1683834261.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AM4PR0501CA0060.eurprd05.prod.outlook.com
 (2603:10a6:200:68::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4757:EE_
X-MS-Office365-Filtering-Correlation-Id: cdfb1705-7e33-440e-31b9-08db52ce7bde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	svVbnrgqAJrWmFRe/z+zjKr12tHffB1hUR+pSyIvZCe7M/dpoYc10uXdOpE2pDQ1ZQANBH/TQvnJwBS8Z5W6DE9izmw/Zan4UGouxqfONAhYeY1gGwVlz/Tq+5fiFFqsq0ZevcRxQyUXMkhGNUu/a6Z7fIazt7+Ak7NSBTrOP7dNINSOyZub0SayuYyLEDaM0//+ZdpBSkM9sN6LnxM2ynjIx9bgyOi2scst0aE9PxBJkgAQiujBzZvsIzJK6UieuIUFz0cH0qU/Y2CXDJxZJ+ZRi5n8pDD43Lpp/eV4f4FH4nQ2H4Xrs+w3RYm/8yx/kDdcJ8/MHAEWgIAtlj10qFUkzrkbSlcZ+rxvQAnX9Kcnmd5pFso6+NbfbJdnl7FPbdUmDiVRIaN8JSydFRduw7IDE+2wflWv9ECP0LAx+TfsxVEym0aWqAs1CKIcX+yi3jJ976CxebWzldC8jZuDdkSWZgiCcADhkq5spsjOj9FHpe6JAG9WQN+9OKIWTsSxXzXQrsF1Q0Zc8GDHJt6/2EoF2gHaIHIUYeglJ3hdYXD3vrbH8btVGo2rDQzAAEPk
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(396003)(366004)(376002)(346002)(136003)(451199021)(5660300002)(8676002)(2616005)(66946007)(66476007)(66556008)(8936002)(36756003)(44832011)(86362001)(4326008)(316002)(6916009)(41300700001)(6666004)(186003)(478600001)(6506007)(6512007)(2906002)(38100700002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RGtTbJoIXAPYKYECh3XmCUBIqpUvOUZqn9pJlixGu5pOqXdCVtR5A8rG/6gJ?=
 =?us-ascii?Q?RewZlD0abGk99NmVqCysueJWhHqB9/97Ts1d67ZKkPUooEt7MRSGxJoArxBv?=
 =?us-ascii?Q?62kFbf7nXDucYOExxjU4krnXmrZSxDLdlXIVWUY4Nt+t21exgxXFdVa6csY5?=
 =?us-ascii?Q?jdUMH5jDVRMHcc/NEA0N1crc97iEnmCoKgs/ROsj2bPOnjcMf8tn8HSWQRzp?=
 =?us-ascii?Q?s/G2m7XlL1b+Bk1i0e9Oz2/N/NnaRw3isme36sZ59iJZ9ZX9/01gifQM6p0f?=
 =?us-ascii?Q?vjwf5oKRqrVSRDUGcLvAA5o7GCAFBObwV7xKHuW5zUkoOsuMOsJaHsAqdZ1V?=
 =?us-ascii?Q?cewRr/L6nPwt3FYiO9mMYhBbt4iACjRcBSXUaZD0k1SYgRMCPuBonHpkuUDX?=
 =?us-ascii?Q?A1u3//AjKus3Seiq8/kZ9Ks+ByW9JrgF3ohjGHS1/HAD1MHt7oPF4NugqnIJ?=
 =?us-ascii?Q?ICmVFSgCpioG3SjwAHRlheMUkKvRaIf66dT4yb7UUsIbRS9lX24+ZrFhE7Sj?=
 =?us-ascii?Q?VoGiYB3c/XkPGY769foSQifpRdTN3aNGL5MHc0YeQHeoZl6pjz/Ix8WSTBO6?=
 =?us-ascii?Q?p9yFOhp2Rvn/X6U285AxsAcz9v0Dlk02PwJPSV4FlHUwJGzFhCG2H4SuobMq?=
 =?us-ascii?Q?ageObX31/bfq7ubBcgJuhsf82BGU40tS5/O7Ri7r0M03C3G4XDgRfTO1ephS?=
 =?us-ascii?Q?I3X0qAu12KJFdXakKLFGwGkYUm7hCHHznfnwA06u+xaZ/n5fQPml+pbLmrTs?=
 =?us-ascii?Q?Z63aniwaK2SxUK0noLseTPjDkNTYdXcsoCrJ9a8VS17yzk4xX3RQpDuwC08m?=
 =?us-ascii?Q?IqwWmBRXpt3mF4k5aa4FbceM2cazxJxbGDJ/Hu+ybZndIYRXT91CtvaKhhNE?=
 =?us-ascii?Q?l+IFdFvmULMIAFXL8CfayKb7XGk+q4aTQdfW2IRHD8lMKeRu8IfYCxFcA+gI?=
 =?us-ascii?Q?HmK+WQzqUh51XHVszZu2cam11keNaG7aEXzm+Q47VGgxb6F7WDBNQAGQJBb7?=
 =?us-ascii?Q?VFKjG6Y1ammb6JEKR2FA9I0hpQYrurEbwxOaateLDk8lSxNSrDpRouFDJKNR?=
 =?us-ascii?Q?nGvdvp6/SXjXdZYzFQk99gXAVB8ZCcnWzw3EmXPbFRSOX89B7bXpVsH/ELZt?=
 =?us-ascii?Q?FnT4XM8BB8RbgadkWLVtNbYmo+VF7GY9H9oGhWXG1TjhdTYJk+rB37pmXX54?=
 =?us-ascii?Q?UqyICnzPbPaEwN/ZbpTaTBASj+KjokravOEYrY1fcZ4zkZ06t4wrCGFwez7t?=
 =?us-ascii?Q?rPt/Usw/QTQuPeRLMDJLjVICuq9Fcq2zac/fT54r77145C2wBiT28P37g3BI?=
 =?us-ascii?Q?byqHKZcEAhpAM57WqRUX6OCf5+8dC/sb714R2xsTLlXGJHey+NouA4AZ8pFo?=
 =?us-ascii?Q?G6CR3ZPesQ7x1fTDOggJWvbiKmqKyiNKI1Aiez1+43yEroEMFxRmvWQDLsq3?=
 =?us-ascii?Q?vxUNlChwgr7x2DvqrBNVD7r3XHmkHDCGI4VGAlw//FyLaMdfjxx7X5l77gce?=
 =?us-ascii?Q?/bK2ztp3wP4U4TqUKlsqNIeRa3w1luwBAhmGIK62RrhVHkHKGUCnp2cFOM0m?=
 =?us-ascii?Q?xyvLIhB/g/RW7QBtAED8rtnENTaPmBj4B+tz/y6Wu8m4YM/wuBHuPRDBGXVC?=
 =?us-ascii?Q?CeqttdZFzIr6YYQSefavLji95LQDyia4uOhfiiylsFqLU/O2K1BeZKEqRm+Q?=
 =?us-ascii?Q?5bwxIw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdfb1705-7e33-440e-31b9-08db52ce7bde
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 09:51:39.9874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PSfHx8axsYsdHRkOCSc3XXy73VY0a1DamS0VdQwzmPfZdmdWtTrbYq6DToa8gXR2KLfefQctpHZ+ak8k3WJEpTNUZFtYP6O82vLFQy+LnKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4757
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:47:30PM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Allow efx_tc_encap_match entries to include an ip_tos and ip_tos_mask.
> To avoid partially-overlapping Outer Rules (which can lead to undefined
>  behaviour in the hardware), store extra "pseudo" entries in our
>  encap_match hashtable, which are used to enforce that all Outer Rule
>  entries within a given <src_ip,dst_ip,udp_dport> tuple (or IPv6
>  equivalent) have the same ip_tos_mask.
> The "direct" encap_match entry takes a reference on the "pseudo",
>  allowing it to be destroyed when all "direct" entries using it are
>  removed.
> efx_tc_em_pseudo_type is an enum rather than just a bool because in
>  future an additional pseudo-type will be added to support Conntrack
>  offload.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

...

> @@ -425,12 +469,56 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
>  #endif
>  	encap->udp_dport = match->value.enc_dport;
>  	encap->tun_type = type;
> +	encap->ip_tos = match->value.enc_ip_tos;
> +	encap->ip_tos_mask = match->mask.enc_ip_tos;
> +	encap->child_ip_tos_mask = child_ip_tos_mask;
> +	encap->type = em_type;
> +	encap->pseudo = pseudo;
>  	old = rhashtable_lookup_get_insert_fast(&efx->tc->encap_match_ht,
>  						&encap->linkage,
>  						efx_tc_encap_match_ht_params);
>  	if (old) {
>  		/* don't need our new entry */
>  		kfree(encap);

Hi Ed,

encap is freed here.

> +		if (pseudo) /* don't need our new pseudo either */
> +			efx_tc_flower_release_encap_match(efx, pseudo);
> +		/* check old and new em_types are compatible */
> +		switch (old->type) {
> +		case EFX_TC_EM_DIRECT:
> +			/* old EM is in hardware, so mustn't overlap with a
> +			 * pseudo, but may be shared with another direct EM
> +			 */
> +			if (em_type == EFX_TC_EM_DIRECT)
> +				break;
> +			NL_SET_ERR_MSG_MOD(extack, "Pseudo encap match conflicts with existing direct entry");
> +			return -EEXIST;
> +		case EFX_TC_EM_PSEUDO_MASK:
> +			/* old EM is protecting a ToS-qualified filter, so may
> +			 * only be shared with another pseudo for the same
> +			 * ToS mask.
> +			 */
> +			if (em_type != EFX_TC_EM_PSEUDO_MASK) {
> +				NL_SET_ERR_MSG_FMT_MOD(extack,
> +						       "%s encap match conflicts with existing pseudo(MASK) entry",
> +						       encap->type ? "Pseudo" : "Direct");

But dereferenced here.

> +				return -EEXIST;
> +			}
> +			if (child_ip_tos_mask != old->child_ip_tos_mask) {
> +				NL_SET_ERR_MSG_FMT_MOD(extack,
> +						       "Pseudo encap match for TOS mask %#04x conflicts with existing pseudo(MASK) entry for TOS mask %#04x",
> +						       child_ip_tos_mask,
> +						       old->child_ip_tos_mask);
> +				return -EEXIST;
> +			}
> +			break;
> +		default: /* Unrecognised pseudo-type.  Just say no */
> +			NL_SET_ERR_MSG_FMT_MOD(extack,
> +					       "%s encap match conflicts with existing pseudo(%d) entry",
> +					       encap->type ? "Pseudo" : "Direct",

And here.

> +					       old->type);
> +			return -EEXIST;
> +		}
> +		/* check old and new tun_types are compatible */
>  		if (old->tun_type != type) {
>  			NL_SET_ERR_MSG_FMT_MOD(extack,
>  					       "Egress encap match with conflicting tun_type %u != %u",

...

