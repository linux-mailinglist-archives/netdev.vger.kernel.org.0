Return-Path: <netdev+bounces-2224-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39EB7700C66
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:56:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 594811C21299
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D24514299;
	Fri, 12 May 2023 15:56:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC2AA920
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 15:56:52 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2138.outbound.protection.outlook.com [40.107.220.138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA511FE2
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:56:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aw9gPd84fuLRnYEQGRUVXKKfVHGphCj9PRe+CIKKa+piolAD/050BYrhlvs4Gsej7SZyKtIlywRHVReSmeFZFX52Dx9sryprcNadC/r+ZF5c+JV2SnUwHhnfH/T7Y5Qw920vvYkMZ4rsYU15xrjSIGAe3UfhWROoGKPkk1pvStr5WfNOVIplEhdeLkIDIzfyPdg83G8ChEF0ANqVHy8Vd6rw2B02oDU4ZMfiePVdO2ZskKFdVbDHofxWXRahAuW9lz9d5pe8Qx/MGWjBs4XjZyZivyx1cPlBORY0mqkaYfNXpLHU92J5GqO66bbYsrgpZN/4tDlWXS0OxA/e1jG/nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2rxiIEYCpefKpoDheYGT+tTpqPGCuceyMD82tFenwk=;
 b=FRkFVmjGO8W8xkZC9Hg1iE/YYuSGkryF52igJWZDm/wUiKstzrBeFrmxGvm0kHn/H69AvdXkJpEG5elT/QHT/VwMwC0cwLKtnSGiWCKVuuhqR2Jgskx00dgoGKunDjqkqFzeHEiORcCwUSOiDkD6Q5rhJp4ZZwhYt+fPHtPawDBekc0lVuBCHjmtJmZ6l0gxSKRlG5Gnpwc422xGQGqsgwLneW3f1pzHlAWBrOAn4OI6DjbbL2Eo6ngSn6Bo0uZUmtNvgv+ZpGb1dTgVtGWqP2hsmpSNXmi46WgmzAr87o8DlnzzThThIMcMe1NnCQ6q3YBKQB+nO06yvuXlCoiRPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2rxiIEYCpefKpoDheYGT+tTpqPGCuceyMD82tFenwk=;
 b=FFfU0uMnyLHHaC81dVwbw9kRZIDbGHqGwzC1j5YhY4+h5leihCtR3fjh8+9ejM+2OrgvCMr4fsRmgl4QuUjKa4vp0Q68afiImwp3i2UMRVQ8OL6iq1SBHxiSmPH1jSQZdJFsi3wkJHpfKH+L1Kry2KTOLTCvhHswbJq7oUwLMnw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4639.namprd13.prod.outlook.com (2603:10b6:5:3ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24; Fri, 12 May
 2023 15:56:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 15:56:45 +0000
Date: Fri, 12 May 2023 17:56:38 +0200
From: Simon Horman <simon.horman@corigine.com>
To: edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com,
	Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
	habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next] sfc: fix use-after-free in
 efx_tc_flower_record_encap_match()
Message-ID: <ZF5htreYutPyj67r@corigine.com>
References: <20230512153558.15025-1-edward.cree@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512153558.15025-1-edward.cree@amd.com>
X-ClientProxiedBy: AM9P250CA0008.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4639:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bb47291-a1e5-4e17-584c-08db53017c43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Lvbksch4kboRHUycsoYLsnWJfv6wwrNSLE1wHsIfvQjcvmBPC09f7pIN9eCrM4Z2wvKviC6bFWu9gc1BFDZGauvJH/wIGRpfV6AX2NI68ubj9UXxlqSiI6vMVo2zGYeOZIWC98A6gfyGdUYcZ/3fpKRW3lABLkUMBLcaMx1T1h7JtjxhhjGyU9NrM2n7PA5aFSAS0/g+3Kk/h6EUy+XEjUUbuKHrzENEVewkOZKq97NnN/t9PIZ2vdlPbe+X6k57GLIIVQJXwxnIjRboj8RP/peZEqQDb381gqTkbnGbmnfqK4pFYkwcjhlhcpMU0a2nKDlXwVWG64uzfic0cZus5tgVHm8VJQ+EDdoDbMOMEMyXFkz0xxVA3f2zyEMsYPvgLosHbGRmZq86baQgHJ08hRVim6V70OrrxY7KnUYBHjbhaJyXwChcQU4+Jjvr77u4cJrY/ceKfiqpZUJvo0yggDX7kU8tQbRSSrP07pgflBPFuTM6/p2Tb1e7OTkpzhmbArWOUdDUnAAV4vBmZaS4i5X0+a7dyq14ZCsKiFJsKtPAbYScCi+fhjINFXhBLu41
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39840400004)(366004)(451199021)(4326008)(478600001)(6916009)(66946007)(66556008)(66476007)(6486002)(316002)(86362001)(36756003)(83380400001)(2616005)(186003)(6506007)(6512007)(8936002)(5660300002)(8676002)(44832011)(6666004)(2906002)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/XX6zYhpIaHe6rxhX9TV1uzEw6SOUT1x60V3ALEvLm0jcJsM2vNAoYwnrxqf?=
 =?us-ascii?Q?B6fRweaxLIxldcYbdeusAE11ifALBna8Btl7eDcfw6/vnh4yELbT0jP/mMDj?=
 =?us-ascii?Q?fyGKW7fnom+NVpq6wc5JTdiolkcQfmy8yDOpLtCu+jcGyJjl0NEbOEozzwQb?=
 =?us-ascii?Q?tm4IYHzifXXglhRL9mI9qqZJ6fAb+b7s+H0Vyg3YQJqKBLbzp9vaOaz8SzKP?=
 =?us-ascii?Q?3p9krgqRub4hnAkCHYYjSf6CWwLisj4ZqpW6C1b1yetTEgQImA6+Xpj9nnck?=
 =?us-ascii?Q?38BMjlKXXPLIF1vM9GaoTaS8Yr5XQUy+78k3Sc2k33zqfaZr5VpNMEdBd7xB?=
 =?us-ascii?Q?qhUPPRC/YtSlR0yIQghwCsfXQarUo16tQUAj861iFGNCRu0lfpny/SRJW0Fd?=
 =?us-ascii?Q?SghXp6aBQII/oRlRuv7hGM/0MRAqbOkf8cxg2wkIj0Q526btO5Kj1zS1Gfhb?=
 =?us-ascii?Q?n0SD9dDo/WIJfrusxla1tv+hfx7LPeKvexpWzdwIC3J+eWMaIeY75P7Kj3K9?=
 =?us-ascii?Q?qXNGbqheTl6jqwqPir7If6pvZreBMEtE+SOmBMiPOOHJUTNX7j4OjaGdWZ1l?=
 =?us-ascii?Q?YFLzPJtHRYrUlQ5w42oH83ljWHbMXIGBV2IP9RVz09Up11L5zI+2mqrG8MhL?=
 =?us-ascii?Q?Fff55TZ9uZ9+OOd5lJgm/wgqCacD/TD5QcCpe5txUJiKRA6SL4mzPsXnARYB?=
 =?us-ascii?Q?Prt2xxxWVTG/c+0XUM6qrsch2LLZMZMtzxrOLRDJN0uCRP7MJpIp/JzvjcKa?=
 =?us-ascii?Q?IqL3UIBTl6l5D+T5PlIZd6yJz1stq1PrXm1Ky16aym4p94P7Hmq6JzpCSInD?=
 =?us-ascii?Q?FsqhKKM3Nsf2HHPaxfxPz/YA6ahB2HGMXwlkB6hf3W8sCwi+mUqUP66Usgjh?=
 =?us-ascii?Q?6v30rKd+JAUgnnehKy+At3GMobsiEk1ur/pjZdxYVvgADZ99FN6g7f2B2NDO?=
 =?us-ascii?Q?jEhQF0t6djTz8MhdqzSylJMuXPnAa2mMIPGrxhpIkuPeepA3Psp986oKtFv0?=
 =?us-ascii?Q?uhgTlYDI3Wn52UhJIzEc5xAUhbZkr1PfCr44UFWPpIYGttdktb13CAmSWO7u?=
 =?us-ascii?Q?XwMzrGGS+u8h1eINxch6asMMz4fZKtMVYW74ShmtNySEdt/nB7L8GVj021OW?=
 =?us-ascii?Q?xTiu4xJlBeoJg9mj9lzQG7X2qVc3iUcJYUOz8bceEdOykQcr4r5zeL71hP9O?=
 =?us-ascii?Q?YcsUknF1eANpihRWPnpgr/w8aGpWC00JzP4NNmNlqpmHA6gNmI31ikhtRI1Q?=
 =?us-ascii?Q?bKzQmJRWPhkRT8mJx/8QaULwNr5bWMwxCGk30RU+ZRg4VCCNZ8Y2j00+pAr/?=
 =?us-ascii?Q?9aibh+rD2Jg/MtwQjD3ldkTVK2ayuoXTq0SuLw2iIFDXqWUAllA+qT7cS3pV?=
 =?us-ascii?Q?/6fbc15ODUarTrdmR8nv7J5xGaCi+pBRGGMC04mqfyE9nke2lv+jJz7RceCA?=
 =?us-ascii?Q?rECNWLpDmplPp2lwISMQLsLt4WnOXDvkZsfKfnXWqn6ZyWaZfhLtbE8jiiKu?=
 =?us-ascii?Q?spZ0dI1eUuE0NWH5gZOSyN4XZnVZ0HeLIRFqKmjFPw/WsC5BcAZHblt0MqqZ?=
 =?us-ascii?Q?jujfCGFnc77eV/yVOnBMQr8ahJDLuM/1UxSlObOzRSw/UyrZWPOApp5LHkrb?=
 =?us-ascii?Q?Wq+gbpKV1cCLAP0q1sojb2HrPxB9w/XmCfcroUiELNnqHOc/B8DUtRVXXiQZ?=
 =?us-ascii?Q?J77Ofg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb47291-a1e5-4e17-584c-08db53017c43
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 15:56:44.9525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UI8oixZedwqjs73gxpnyUo1DjwS7Csa+My9YumbMoujTW17tR9dP5U20edwhFRVK5zPeObta/AebMUxPVOrdmUVxjSle8y8gIpFB6/XFKXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4639
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 04:35:58PM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> When writing error messages to extack for pseudo collisions, we can't
>  use encap->type as encap has already been freed.  Fortunately the
>  same value is stored in local variable em_type, so use that instead.
> 
> Fixes: 3c9561c0a5b9 ("sfc: support TC decap rules matching on enc_ip_tos")
> Reported-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Thanks,

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/ethernet/sfc/tc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
> index da684b4b7211..6dfbdb39f2fe 100644
> --- a/drivers/net/ethernet/sfc/tc.c
> +++ b/drivers/net/ethernet/sfc/tc.c
> @@ -504,7 +504,7 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
>  			if (em_type != EFX_TC_EM_PSEUDO_MASK) {
>  				NL_SET_ERR_MSG_FMT_MOD(extack,
>  						       "%s encap match conflicts with existing pseudo(MASK) entry",
> -						       encap->type ? "Pseudo" : "Direct");
> +						       em_type ? "Pseudo" : "Direct");
>  				return -EEXIST;
>  			}
>  			if (child_ip_tos_mask != old->child_ip_tos_mask) {
> @@ -525,7 +525,7 @@ static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
>  		default: /* Unrecognised pseudo-type.  Just say no */
>  			NL_SET_ERR_MSG_FMT_MOD(extack,
>  					       "%s encap match conflicts with existing pseudo(%d) entry",
> -					       encap->type ? "Pseudo" : "Direct",
> +					       em_type ? "Pseudo" : "Direct",
>  					       old->type);
>  			return -EEXIST;
>  		}
> 

