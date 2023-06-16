Return-Path: <netdev+bounces-11410-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8564733058
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:47:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 938132816E5
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9B714A8D;
	Fri, 16 Jun 2023 11:47:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FF01428F
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 11:47:53 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2121.outbound.protection.outlook.com [40.107.220.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877C2294C;
	Fri, 16 Jun 2023 04:47:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMiSP64pdeyWDNekkTqakLw/tgH25IDaUo+vIWmS8oTSPwpVApgN9vu3BOtLpFrfqFcP9L1NFyVtrRSDmUICwRM1SFXVu3rRTNg9rFoRQA3cFxtWKtwLkpYFshHjiCrx8F6i4tCkAEWf3810Zk4kVJ4XDqHOqhwyvLZzdgkQBFcAp6+J/T5YyQi5UiOovlncBGHvspCjSnwc/UDAA5idH3M8y0CiDNgFgyf2a/j+0CPc19jg/qRHGH1WAjMjkRX3JrqKW5DV+msvQyzfBwLUkd1MJoNdzun0I5Akz9VF96TgLDy2PsJ+KVatapBiV2c8vm55PvtnyaS16KvM4ZNWKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=brcZfK4cFuE8FHxY/O8yTFVyQ9t1og+0gPD8DFv0izs=;
 b=Nyax3zi15Yp39iIlOqbvAfVzlEmlzL9Fo4vEMCmTr5hMwuwBZE+LP+ICW83eaNIbQpKsqz5a7geyInNkprEJFvKCDoTMuEysnXl/VHDcEYZUPS6KSM+uV2PKdBxSYr1Vzcv9tTxPSx5zkcqIw6WsTiSPjjqT52RAhNKE4MHm9zvuMLvGUgrPyeNXLFIm+4/wPQ0Sol02wyrJwp+hivI0mNfqdqGasj4eFJF6z8Sd6RmARYSXyIh4n2HuMX+GpfJy2RzSD7pdic4RVBaUDHb1B1UfX82EmmUf2Obj1tsikEaEJr3+0y4SpHRYWfwsbdUI2zCQ+WdG6x3ouS53D0Kitg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brcZfK4cFuE8FHxY/O8yTFVyQ9t1og+0gPD8DFv0izs=;
 b=Rt7ZStuFkesh+ImUj4l+aemB5Jt3GuPIuQMt0CGy9/VhGlna1U194YBSQQqKdeaxGUVcelyfbYl1LRJzRcUuM7Zz4aSr2MHgo5Nhk5xIXWJDYGr1eCh0nmTGUmr/DMnaJQYBe1yaqong8CN4rGxCR35P0vm4tGcWOF2Bhi2Hw30=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5684.namprd13.prod.outlook.com (2603:10b6:510:113::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Fri, 16 Jun
 2023 11:47:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 11:47:45 +0000
Date: Fri, 16 Jun 2023 13:47:35 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?utf-8?B?UmFtw7Nu?= Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>,
	Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>,
	Frank Sae <Frank.Sae@motor-comm.com>,
	Michael Walle <michael@walle.cc>,
	Daniel Golle <daniel@makrotopia.org>,
	Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] net: phy: mediatek: fix compile-test dependencies
Message-ID: <ZIxL16HWci5dd7Ah@corigine.com>
References: <20230616093009.3511692-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616093009.3511692-1-arnd@kernel.org>
X-ClientProxiedBy: AS4P192CA0021.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5684:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b4decf8-fc1c-46c2-49e1-08db6e5f7ffd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zEzoVFq5opPdh0qzzCcvbjYdmUy40okL97WBQzYuQBhMmVUAHok2SbMlY3WW1Tf5pA2g7gIJmn3KnI0evi2oUeLrRzbk90F2CKXGJDHqqcHx5M1iPWOBlew+HJCWjPip6tmfs7PLrke2Qmf4ywCiCcBRtkEjRh1Kls5BCXV5BnDyW1K2tGp/9HnAQu28RAUPxTRnyccaS5VawQWhEJ6xg7xGM0jaQZPodDum6eCj8cEnep443HOJuxT7d12GaCgG17vD3AIwIrZExXmhZXVzUlnycCvT2bDMA31OYk+gXT3Wmwhx35PvmI0LOQUNDGufMiX8NFfOnWlBTAxqgDyu9ITXw5lIFNbB5PAge8KAeNuRvhjk6TNYIgfTRwXKSs8JtuaB6GeMIJA5Ieb/iNn0d5pDLFPVIUrJXeIQJ/Y1tl/qgMXWWSqzA+9VWGcgc9045XbkqppF+loPxQ5ta3vFVV8r/NfDBaZti3wOMp1TvaQr/ZF/3aYEZxTYCBaziNOrU5XQs7c/vziJYFYDEieC47MxNgtwuB4v0PWJ4w3uY7BluEkmpfj83AXYBV7E4Rzm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(346002)(396003)(39840400004)(451199021)(316002)(6486002)(41300700001)(83380400001)(2616005)(186003)(44832011)(6506007)(6512007)(2906002)(86362001)(7416002)(38100700002)(5660300002)(36756003)(8936002)(8676002)(66946007)(478600001)(54906003)(66556008)(6916009)(6666004)(66476007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PCqoKms2CVFTCCdFTI1RbP/UFQ5gLflmVqkZjfJVG8IAhNq+/J1Ufz3A41ur?=
 =?us-ascii?Q?cSBV0oo2zwn93CQ2ipB4oXY9MMkR9y2HTAAJnbOz/I+I8F103AnGmFhF+O0p?=
 =?us-ascii?Q?88dmpGdUHszjufoA5widvl+KbVRZBowgKolw1rVwQuWuj5IY+tcMndVoDlq9?=
 =?us-ascii?Q?R8F/bOVk9JhrJbTg8ksdYZq+2/xBWcUcNyrSUWFSgYlZLu9R+KYwOMCQmCug?=
 =?us-ascii?Q?BGYjLEE/yOimd8KAs3dFeEC2aIN9VDI0cHkI+aayvw2nw4NG1TbMgXX14wdz?=
 =?us-ascii?Q?DURqX6TFIvLzAbwPBMwyZI07uK9h7tYzu4FJbhWG2TAAxlz115eJtl4vWeCh?=
 =?us-ascii?Q?Ffqsm8EC6C3RNHeMWQWUa32DvxF+ZkKY9kiDNEBbBJ41Jy/mgSpGmG4Y7SQD?=
 =?us-ascii?Q?gStvWoFbpUid7+vUSuR6o0N+JVOfFrTIAYoBMVaWTKGgEb2kkHL6QHxUSLny?=
 =?us-ascii?Q?cadAH8LC8MkCFK8oWvj+iZOob4JGvH/xLTjuihXFC+kJ81ZBHnglhOiR+T1t?=
 =?us-ascii?Q?Ei9pe3DZ8DcaEgx3v2z/5JCO/495YRSJ8eBdg3cX8Bknhc9UPGK4mwYP9jNQ?=
 =?us-ascii?Q?QalevnkPCXp+rYbyQljqqS3yyXX5JWosX13meoyo+wicMAZS0IL2f5rWnp6A?=
 =?us-ascii?Q?0U2K9+vdrF5EhUasE5MVZuuKCsM/DdIHn0+jCT1Qrhu2Q6qK5FHVWtFdPjg5?=
 =?us-ascii?Q?T1FR5fkplm8U5tbdRp/nS2iTlrRNo+XHMwEDZGCWBpqp4u5hPtN6ITMYpwAd?=
 =?us-ascii?Q?Ovosc1OPFOGp/V/LzCWyEXGKsntTYOWzQ43EWC92hTnzQEkKUTngEJGWRMGT?=
 =?us-ascii?Q?Td/PKciOmVueN6clYKHp/BuP1AooxEyisGMrVvIhY6zFH+gDxWNacFk8yCis?=
 =?us-ascii?Q?WIXI0J9YksTuwontJa/FZwhhQLPqf2Shr5zVFyCAgIHOkKHKExxWHIWWmnYm?=
 =?us-ascii?Q?sAFr8G3w5PEfVhLrwWWASG2bDt04plxL/OE6ykOBXX5HaQ0D58UaABrRC3VX?=
 =?us-ascii?Q?IR5/g0XHgBvWJJ596vM09pnPfZPYQgJJu+GeWrbBGRUHNQJlUvs5WKhkx4dT?=
 =?us-ascii?Q?9k2ODaWs4wLyZGoCLUHal7QBh8MczIVX+FhkoE/7AVIzD9WtI7UFsmOuXkPP?=
 =?us-ascii?Q?2ccAOGjx2uUsjV1JjHfJ3+uFF+OFSOck+ZItMM7mVD2/jH71qdLB/WAnYAtv?=
 =?us-ascii?Q?riq24QwlHCYsXZlrmX9M1bQeWeksje84lny/0YNlJp99uHjHh/97RDXtaoPc?=
 =?us-ascii?Q?hZZo4rX+dtXIOdmIqL5Lc03nUVMT9MKceGK86wQ/9PYPvuSxnKGxXBVYMUjN?=
 =?us-ascii?Q?TO7+AeyYVAVnj7+7OXgCPiMmkCuF62wKANSoxTZFXNKIXNwHn6bzC4cNXIIs?=
 =?us-ascii?Q?Ygx5z6/xulNssm5uEnStS8youQeBjS3epsK2c9JLuMhXhAgAi6ryi5blxCnt?=
 =?us-ascii?Q?BAaRlsXWDN5T993CnKnROcvzvv7Ti/cdaJb3oa5aGWrR+25Oe7FN9j4SwDPK?=
 =?us-ascii?Q?RtudIqS3UnFAuZhevOd3hs5Bp9+ATe3yEknHmVmBONScRpIWjZ/ZGURZ+D2T?=
 =?us-ascii?Q?mk5FSO9A/YdzgWbOh3uSl2OIgBaG8CK2Djnz0Z4whHC1HhzaxYGQmx6X6uTT?=
 =?us-ascii?Q?5Fp7+6il5Xb47/IvG1bLy8NHTLpDkDI934DJ02ffXlCr9D1aDMMmwvQIPiyO?=
 =?us-ascii?Q?UZ5N/w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b4decf8-fc1c-46c2-49e1-08db6e5f7ffd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 11:47:45.3163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /4v0fAIDmie2yOzCDCYiNVcuG9iwaJOiH/dKPaszZit1x+OPTWyZR6pa2dJiq+7wLThe2HCUJHLWyLAEa1xj3xOAA2blAYzwR74jpw7wB9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5684
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 11:29:54AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The new phy driver attempts to select a driver from another subsystem,
> but that fails when the NVMEM subsystem is disabled:
> 
> WARNING: unmet direct dependencies detected for NVMEM_MTK_EFUSE
>   Depends on [n]: NVMEM [=n] && (ARCH_MEDIATEK [=n] || COMPILE_TEST [=y]) && HAS_IOMEM [=y]
>   Selected by [y]:
>   - MEDIATEK_GE_SOC_PHY [=y] && NETDEVICES [=y] && PHYLIB [=y] && (ARM64 && ARCH_MEDIATEK [=n] || COMPILE_TEST [=y])
> 
> I could not see an actual compile time dependency, so presumably this
> is only needed for for working correctly but not technically a dependency

nit: for for -> for
     or
     for for working correctly -> for correct operation

> on that particular nvmem driver implementation, so it would likely
> be safe to remove the select for compile testing.
> 
> To keep the spirit of the original 'select', just replace this with a
> 'depends on' that ensures that the driver will work but does not get in
> the way of build testing.
> 
> Fixes: 98c485eaf509b ("net: phy: add driver for MediaTek SoC built-in GE PHYs")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I don't know the answer to the question of if this dependency is needed or
not. But I do agree that it does what it says on the box.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


