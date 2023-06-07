Return-Path: <netdev+bounces-8926-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8192272650E
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E0821C20E3D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14312370EA;
	Wed,  7 Jun 2023 15:52:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0200734D94
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:52:31 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2128.outbound.protection.outlook.com [40.107.95.128])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744C41988;
	Wed,  7 Jun 2023 08:52:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrbPKK/vYtb0SVOM1AUSdyrHAKMWpvWGiVwq9TR+5Qi25DpxWYFh3OI/F9qa40lG51gNHtGeci+dPAsFLuDi9jHGN1PsjTFU/76ZDHJUGn6a2xb7Y/ju39jIOFtx40p95cCXzIAoBPhED0pNKaS4zbHIVckbicRzTerYjIVizfxkTzxSMRtcxo8hYNk0B444Ep74PKoGWGZMwbFzEZr0X9CAoDxk8Qg6KkiU1aOGZJca3Nq4OAHwhXHqoWYGtwpm4u/uC//G/Lz4gN3JGLMlfXU4Rt26O0C1ir/X3O86+DSJC2nk0BjexkePJH7FN5DkWslYD+zBUFwxZmkcPS9mfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAjBODfWdZ0cEgqVEGbuqO/t+lqZsEnq+W+26Tu3W4w=;
 b=EJXWFs4bC4QFwUOBbRBFf9zjoU9Torj6nD+i6QIWVR/1c1q8vs4UAX8uWSJ11sUOn5m4UmtnMtglqH0mJ/6sVQn52lx/GRTEb6p+wDLjGL7kcVxrmRmEeGz7fnmjyMmxwNDaBIGkA4YPdxJYexUB0lyzPAtol5zn/vvcBjYlZnAP3dI3MO8IEmUGcGdi8WyVdMUJ/99EVQ3OUrNpfzQiLCBSmz+q0VESkQR79Y2uBiZ+VK3uA/iWSHbMDA+1Uc/TVaMxhuQFD3+RwpeEnKJ8na0t8J1hgYrAvxEWc00JNpvZeh2u8B/y+64p7pZvo/iqhk41n1MtsbiER+QG4IdSKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAjBODfWdZ0cEgqVEGbuqO/t+lqZsEnq+W+26Tu3W4w=;
 b=C7xAA+ydcS/RBYZCLcNqwneGxwDXiTPmBeIJmzVl/9hTA2TQ/EVhIFNQCG8AqXwZaln/UwwL4eX9hRpWCjf/WVDI4b00deaDXtxcihAYazCZhtyTIO4/P/eC73m2kMk/YQztYTGGq14IYOsOUV3dQpdKdnZFoM79Q7D1RGJfiyw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by SN7PR13MB6302.namprd13.prod.outlook.com (2603:10b6:806:2e9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Wed, 7 Jun
 2023 15:52:27 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e%7]) with mapi id 15.20.6455.037; Wed, 7 Jun 2023
 15:52:27 +0000
Date: Wed, 7 Jun 2023 17:52:19 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Arnd Bergmann <arnd@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Bhadram Varka <vbhadram@nvidia.com>,
	Samin Guo <samin.guo@starfivetech.com>, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] stmmac: fix pcs_lynx link failure
Message-ID: <ZICns6xA6geSGobk@corigine.com>
References: <20230607135638.1341101-1-arnd@kernel.org>
 <ZICQMHTowGQTzbxm@shell.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZICQMHTowGQTzbxm@shell.armlinux.org.uk>
X-ClientProxiedBy: AM3PR07CA0075.eurprd07.prod.outlook.com
 (2603:10a6:207:4::33) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|SN7PR13MB6302:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d9f4182-5338-449e-891b-08db676f314a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wu8c71tazx6Znc0j7wlMYIcR53VoGPZiZSir7c48wbwIym6IjSOtoFMdSV1eSqLBNN0Uum6QQQ9QCQ/3+Igx6os6BlIK9efQyJu4oudmSlTPtSBkj0whK14xEyq678HZKXanwzGYmWgSFkxwioda7wG5RvThq8Yx0amQwyXAW9Z4hBkVO6kbrKS4grPq2Jvntu512Mt/f+RLUZJA+R1pSUlkJZoeuTffVCEJW8iFlNEs74xZlOV33FdgkJCXujOsDtuWx3fhZX4AWjWwrfssiqWG8qLG+w0NXh69rxc3/lKWPdbX8/bbb8wNBsPErojLyYqD/2rCEVYmslZm0tGWS7zDqUGT+6BnvC6ogUyBUbaB6Cbjn4XljNasBQLjOjqBh/9inXQAMhvw4VlwxuByPgJ4s864upoLDMlfF/GT3yK3ykC/VmaV9TuOUdESIMI+9U8PN42ENpfLRxYYdUZtZUYtum2rHPbDG5py1Jgomf3qTPJS5Q4FHjXt4l0rwL1lALqFxOSLIszMuDoRN+Qp5w/b8ujiN5lLF8n4f1aL+qc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(346002)(366004)(376002)(136003)(451199021)(54906003)(478600001)(5660300002)(8676002)(44832011)(36756003)(86362001)(2906002)(66946007)(8936002)(4326008)(66476007)(66556008)(316002)(7416002)(6916009)(41300700001)(6666004)(83380400001)(38100700002)(6506007)(2616005)(6512007)(186003)(966005)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/bF8syT/pa0xNk/3bh8dx03kaljdHuQu9FNy844oacEGEqHxhD00n2Bi4+L6?=
 =?us-ascii?Q?2I67xsUwKWHKrO2nf8u95T8yjsjj2LZqyJvnZM4JiRmaOjNkctbo/VAEO9SG?=
 =?us-ascii?Q?evx8EaGbqbpbCTxdMluKHYjDJ8okaGFgCxN2QAuYoAne07aOhVv4a5VGmtQn?=
 =?us-ascii?Q?MrWgnPaUTk6/X+fh4ABi9ZSQMnN1bCAOrXOxBmRzFOwYPZReiqzi2zT9dAUJ?=
 =?us-ascii?Q?iQbDLARKUOexcO80a0GpA7aoUhl8OD/k1p1hP5P0UNyO5vianG6BQyu1Fny6?=
 =?us-ascii?Q?OFpe7vddPCiS7KXtGDIdIvxSR2sDGPiJqdcfet3LRwSUVwuqD6Z1DWMu47OW?=
 =?us-ascii?Q?XwbDE7LAxdgKbSIaNkw48tv4oohA3A627oy2jWQ5XvIUuAGUaLwkkRmlaq1r?=
 =?us-ascii?Q?ol9YoyDC6hxYTruzY9U4/gvn1FUtcmUQ9ZId5eypO1Q4arRGgqMCS5ILEwZr?=
 =?us-ascii?Q?bh94yDzSbdCUxFrgBkK5JiycD7de81HC3Bzy3sG28FwfVExfYkKAqNZ8bMcQ?=
 =?us-ascii?Q?V3dv/bYXpapwlP+YBHXYV7+VxtErzmRKossxq2s/BjU7Mif5VpPNCSmz40DY?=
 =?us-ascii?Q?kArG6pBnsJa5pGCRDlRK8Icz//4f48UN25O8yNDihxJgoHN3CjJpWE/xyQjt?=
 =?us-ascii?Q?N66onI6UxwGvKtAO1YnSw2rGEK27ZH2Q2bGcCq5qpe+1e8CExievKkulC+wE?=
 =?us-ascii?Q?ZYi9S4/cREJPa9bW0covQxCsQdqbGbzL/TfN8EEG1948ukmQOGJrdPL4Xk6d?=
 =?us-ascii?Q?EGzc3Q54AXEJme8r8wn929Ju0PU4Hj8BYDogO+6n9SwcOHrmDJGfQNIC0Y3K?=
 =?us-ascii?Q?7eljQ5xxqysjULhxOH8Le3E5cCHWadZ7Cqkrf+F3twYt6XQU/kbsmDGFmAy+?=
 =?us-ascii?Q?u2BWhtDPviGmx2x98o8rQIlJgTtBpnkLeXBDOu+EfRW4wLfMoAKB4e+bWa4k?=
 =?us-ascii?Q?jdAlMnrf3XmT4vvjjmEzA9SK7MJ0GxEa7SkX9VSIaGmEOQ8LZlL2RRMbqetX?=
 =?us-ascii?Q?agbgOwIzWMQhKISmL4d/IM8DvtYoTzUnAT4Ji+ZRvGOI63DXYKMhEiwGsl3D?=
 =?us-ascii?Q?5I90rTtxHa9aeOs5GrWqtBj2wP9nF6Xy32h28Fu19+ihFsqRG5NqW8vAEgdd?=
 =?us-ascii?Q?rIgwXUHKF9o6+6bIKTgIbPCfoIEPq6i5ouYPZxmoQMZTh0TPESE5QpIJC58u?=
 =?us-ascii?Q?rPbwLkxebmcu4FyzqLnYFsFn0+daew2/LWiDfBiKe03ZEPwppuxOhfasmEsJ?=
 =?us-ascii?Q?wwghzNjMc+smZsTgsixLyL6TTdKUiBkF80HRJ6ZpF66CnR+XCmkkK0p167Vu?=
 =?us-ascii?Q?zDStHPDFg4+eM9NIXX/RRURwRJpDTdAMCgkbi4wL/xE0NJME7G1bEOInhWZs?=
 =?us-ascii?Q?FMQ4F8wZjugUPBu0A+QqzFfJlGyPItUoNTa8FbvdWqtfjIE786MptkGhraIw?=
 =?us-ascii?Q?DhclnJGScv0Xp5uvR420gyUo4tJZgvfxfABnByY70/5UDKwgoY7yulSVW2wa?=
 =?us-ascii?Q?pqSxJGXDdtBtum4HppLHJf5VSMV5zlL3lR4Qek/f/gKUjLbfqHXrcCUKYuna?=
 =?us-ascii?Q?hXGBwE0mG8iCWbSse3NZZPhA7R6lmKKeJkxfKJQMOKNDNI3Jpx+Tt3N+PXSS?=
 =?us-ascii?Q?/xoHxdrhsdMILKhX2tbyeXvNf4iNJ4zAOqPPKaVIA2qttxnI2jma2A2D42e0?=
 =?us-ascii?Q?LMmE/w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d9f4182-5338-449e-891b-08db676f314a
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 15:52:27.0765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xq3a9JN528NXtzcv/Mf5le5DeftEI87i+na1tYJAr8YR5bEmTPJ9NNDU86ZVMDhXbXm04WGJWASJCHkZmQ1RDPX9/91Nf/ywSisIt5adtBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6302
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 03:12:00PM +0100, Russell King (Oracle) wrote:
> On Wed, Jun 07, 2023 at 03:56:32PM +0200, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > The mdio code in stmmac now directly links into both the lynx_pcs and
> > the xpcs device drivers, but the lynx_pcs dependency is only enforced
> > for the altera variant of stmmac, which is the one that actually uses it.
> > 
> > Building stmmac for a non-altera platform therefore causes a link
> > failure:
> > 
> > arm-linux-gnueabi-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o: in function `stmmac_mdio_unregister':
> > stmmac_mdio.c:(.text+0x1418): undefined reference to `lynx_pcs_destroy'
> > 
> > I've tried to come up with a patch that moves this dependency back into
> > the dwmac-socfpga.c file, but there was no easy and obvious way to
> > do this. It also seems that this would not be a proper solution, but
> > instead there should be a real abstraction for pcs drivers that lets
> > device drivers handle this transparently.
> 
> There is already a patch set on netdev fixing this properly.

Yes, let's focus on the solution proposed here:
https://lore.kernel.org/netdev/20230607135941.407054-1-maxime.chevallier@bootlin.com/T/#t

-- 
pw-bot: reject


