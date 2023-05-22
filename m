Return-Path: <netdev+bounces-4199-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C19470B9B1
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8ECC21C20A01
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 10:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7B3AD5A;
	Mon, 22 May 2023 10:13:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E5FAD55
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:13:06 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2102.outbound.protection.outlook.com [40.107.96.102])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C471A8;
	Mon, 22 May 2023 03:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0fiKbhnJaGDfyI06PdQC+HrRiHj6kCSsqYtFCLA82pedAvm9pD9fffkEZBRM7pPQlDWtmJevNWcXCvNx8DOB4vAsN947K4nzhK30ekcFTOrY7kbEniChjz/dBTw7oXu21+NbCuaMivQc+Xf+fC/nTifXGbyaOYe09gOcDgLCvkBo0y9670dY03Y5nkuFPfDrMEo5Uyf7GW4tlk+AEWNCRbuuzIuj0dJ5hGmu0NB3gib+YRqv4uwu7YKdnnodUTM/o+Kl4qBfkn70H9r9FL1aKxnc5mMRysE+MSnLrhRexzIzwQbbhuCntkJS6A7CunUFe/2nct5d983eUCgD4KMdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ljb8ZHnMYk3jRb+F4Gc8fuedpob2eALgXU0k9eIBRk0=;
 b=EfR+Lfs2ftvNRTjG1VIkTeRonv8SGKb3MYub4sUIhiIlFXrs4+80bamlzZ7aXSoInkp0DeuJdoH61jinF96byxd42m8mboGVY+wPBxV3+PguPy4iXETrIg1JnUq8vmVglF/rff2SVVCpisHq63a2VLfO64MtTa7VHSuhxFQ2MA0WrIGTZUREx0FeDl00e35ggr9DT9bx0hrL2YjPd3o9Odsi+1xQBTIhXFuj/SbxgNeBCo5UI5hQgHupnz4tPUugL1rQd97N5uXfJRtfQGzK7hNTYkTkummIvwenJkn/9PJm/MKUnI7VGsnl/ElL/sCi5bUI1wZzpD1gAdne/d5xfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljb8ZHnMYk3jRb+F4Gc8fuedpob2eALgXU0k9eIBRk0=;
 b=GjCFMDEVFrGM3cxINReAODBOn/ZqG46MUgSTK7ua3CDcjW4WbJVVPON4duazAlSjHdkCf5/DvB1vzZzjhU2h1nNqJj7gfqMNVmbFkBYBuKP6kddqxtgR2Izgb46I55YVyxNDKHa6Ur01HFiXFvc8pHoghJdhTEY22AxjksLFV+s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB6027.namprd13.prod.outlook.com (2603:10b6:a03:3df::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 10:12:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 10:12:55 +0000
Date: Mon, 22 May 2023 12:12:48 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Rain River <rain.1986.08.12@gmail.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Ayaz Abdulla <aabdulla@nvidia.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] forcedeth: Fix an error handling path in nv_probe()
Message-ID: <ZGtAIJZ3QzkBJgHI@corigine.com>
References: <355e9a7d351b32ad897251b6f81b5886fcdc6766.1684571393.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <355e9a7d351b32ad897251b6f81b5886fcdc6766.1684571393.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM3PR03CA0066.eurprd03.prod.outlook.com
 (2603:10a6:207:5::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB6027:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fc312aa-6707-46d2-7b9b-08db5aad1bfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aTvqHTtx1mRxcheKiotuBmdy9YzISvOfsUp/f7kNDfNgfwMpULJFwGeYoW+A9kl+fiEyC3Y6Aj9sCg1pLHr0QqPZCD+26t5oXRCP8RbDUUHcSOq+6CG2P7dkYalP/utxEYj6SaE/+3gKIFj2HGYB6pWrRkgcKsssXx8B4nmBaCisCtGS3qe5/2+iC7Lo6jffVxzXeLQTQQn2AP7S8CRPYMwTfijJPAgbaDK74rYb/nHkoSqGgK2miS50T3c9O9nvEPmPAPlnw/ootMNccHxWg19LlsSkWj5zVYxU+FjSGA/wG5h+gvFQVY4sTAAP4lmR3dyQk1m9qo+ijCO3OSopuP5NXsW4KDSlwht8n02xTGF803Pirid6yzTpTTmU7OJlaJ2dYyffnkBwq0Z1Sf0SqcRPeP2qsPefR0UB6LrEskpSYCEBEiIIDVgzltUh2p3n5JSxpYIaqIUt5Y9QewNEbr0B8qwt5KENAo5onb+K8JLPILeYlOWfVYYd/YwAsdOhCPYpNgyYyPHfLvyJvJiL9UXA0WKXReOgSkJtOm1nHyqOjF3BbYdiLyXauOTHqVx/+DGv3Ko4jKrmWpzHKVKWTrJchzA/ZOWajFOnQul2lb0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39830400003)(346002)(136003)(451199021)(6486002)(6666004)(478600001)(2616005)(36756003)(186003)(6512007)(6506007)(38100700002)(86362001)(66946007)(66556008)(4326008)(6916009)(66476007)(7416002)(2906002)(8676002)(8936002)(316002)(5660300002)(41300700001)(54906003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Va3hUDnTPkxTfMk/m27xw/VOyBwfkcT3eDSbdDie2sCHgl7W4vOw688ik7rL?=
 =?us-ascii?Q?K8yLiVCu56PGlzaQXBAUOBXW11UIHxKHzz8p+h2zpcRQMsNpaiWDiaPFEZg6?=
 =?us-ascii?Q?PBkjRSfpgoIByYIXFozQSH7kM/OhAPC8ViIfXMNlOlsO2aGRiKjdD6T6+7Wi?=
 =?us-ascii?Q?l8TGnx9E1bTx7T0FCvoC2vInPyP4gHznrwjDJUp3ArEpHDpI2NPf/Dx5nBib?=
 =?us-ascii?Q?YRio8mbn7JAINht04yXGdfyA5Ipb98bBsQq0u1ZcMRo82Z7jvy2BjPj6QMH9?=
 =?us-ascii?Q?5fDh6KUq+yRuOO/iOYQTnpEAi5g49YnLMKllY6Lz9R5Kz9LzW+nlweHGFsx4?=
 =?us-ascii?Q?lZZbTLBKh6Aa3hUxF6ekOlz8Edf24nmpjXUaBQjMPs4s/q5V0Ka3pWKx1NtL?=
 =?us-ascii?Q?FZ/AnzVzBTlVAlJ2FlPa2znrzvStMbKmAXROjLjf3mv9bZ9OgbG9Dep/duty?=
 =?us-ascii?Q?0HLlPac6RX2E1fa36zzCKSCRL/p60nDkMpdibksRGBwfJTJ50xmVBGGW+igj?=
 =?us-ascii?Q?01wK6J/PXC+q2TUPcHxg1iHi1s89aL8abhr0+2Lt3al3Ffl9xw9SXLgqEgia?=
 =?us-ascii?Q?Og9vbOw30KRMGgOcQ6fW7mCmxLRIde1lq5MBpaG5sc7XNxWZLUwW2OCl14E4?=
 =?us-ascii?Q?+O5MCLFk6Sq5IDdDiKrNEAIn2LnVR76z5DKhQauatJmR3Tm0dNEusQnPNTzn?=
 =?us-ascii?Q?cL2tvF1JmnfI2lH3wemoR4pc+UIX+TRgshEQDTFQxq9Igp6XLSKLY0mSv/eo?=
 =?us-ascii?Q?UBhVr/y3S08dHY5aZton3qbUNcznm46YGsLVMIclF+5UQOngJWc6czI1rDms?=
 =?us-ascii?Q?mbliyeojQqE6aapV17AV3ANlAb736RA/zYWW+bunyjpUtFVYIJIbrNbXrI2V?=
 =?us-ascii?Q?9GwwBtHFkU/SGJTHkt/sWtPXh1QMw+PzprHO19rds/a2kWt79hgOOwn4w5Ik?=
 =?us-ascii?Q?eqGyQRWqy49oJ/9ZJIYciMRIz0Txf+/Im+8Uy6xnq6TgROKgAUPiKJQeZsic?=
 =?us-ascii?Q?IT6PX2bIogGqtuDmOYENqUlv+ZulvavoyDIHdeakcdU3kPxZdsYNWovOVRA6?=
 =?us-ascii?Q?4LrtHBJZeTO8xFqDF9AmOQeJgVFRfRXMsIPAGKT58SpEpTQXwUGExvn8W4zJ?=
 =?us-ascii?Q?w7GMKid5z++2ZdVLsVWdGrIXqnlrX9g0P2BViSMevDQ+xjc9zgpP+dUYW8F+?=
 =?us-ascii?Q?B7Z2xD18sAHZnqzYbtI8FbWctN9Jnv8S6xcI9TR1jYyUkZLhuTbaikWGp7iI?=
 =?us-ascii?Q?G85rg9HaHmsb7lA1a5l0TEC8YC9KU4WyjrS6n9rHUQP6V2ZNYRnyYHsarw8W?=
 =?us-ascii?Q?7r9KRJi00LXhT3zsQ5MD8S7wqRu8zKst4CYtpOTBTuXJTRIhi4521cVFWnhT?=
 =?us-ascii?Q?MXiPmVKIF7tJKBjJ7mlrlDzxOt18uwtcG59yIv7Cfd2VMc/vnObdzC+9mPik?=
 =?us-ascii?Q?aH2R8r4Id9/EC9tp/YqNlElEYUpSbUX2oXDcGRcJaHXdhYJKWBOMKULNlEnv?=
 =?us-ascii?Q?M1qwJDIZQJQZVoXlfacCnmS3OQVbaLaUvKlyOVx+ch7hYspyyTPJJ3QhJnm3?=
 =?us-ascii?Q?MiuCLP5yYsVYh9esuKatcYUf32dFeEvGDfiaGiXBd+Njc2HYTW9YYFnbTR4Q?=
 =?us-ascii?Q?1GAGvOML9Q8hLIpQKZ29bFVaPPp08OizIzXLp9+f6GyPmIU/DgjEXZcXmrf/?=
 =?us-ascii?Q?KXwhCw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc312aa-6707-46d2-7b9b-08db5aad1bfc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 10:12:55.2675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtPOJ+0X/8MSmc2XRKjb597SlI+2Fa83cTjm42TKpccVuRNlizapHqjoUmAmLop7cPF/GsaLg20xA91M02jPK0qz84/4g9c1Nrbn3O9SaLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB6027
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 20, 2023 at 10:30:17AM +0200, Christophe JAILLET wrote:
> If an error occures after calling nv_mgmt_acquire_sema(), it should be
> undone with a corresponding nv_mgmt_release_sema() call.

nit: s/occures/occurs/

> 
> Add it in the error handling path of the probe as already done in the
> remove function.

I was going to ask what happens if nv_mgmt_acquire_sema() fails.
Then I realised that it always returns 0.

Perhaps it would be worth changing it's return type to void at some point.

> Fixes: cac1c52c3621 ("forcedeth: mgmt unit interface")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> I don't think that the Fixes tag is really accurate, but
> nv_mgmt_release_sema() was introduced here. And cac1c52c3621 is already old
> so should be good enough.
> ---
>  drivers/net/ethernet/nvidia/forcedeth.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index 0605d1ee490d..7a549b834e97 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -6138,6 +6138,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
>  	return 0;
>  
>  out_error:
> +	nv_mgmt_release_sema(dev);
>  	if (phystate_orig)
>  		writel(phystate|NVREG_ADAPTCTL_RUNNING, base + NvRegAdapterControl);
>  out_freering:
> -- 
> 2.34.1
> 
> 

