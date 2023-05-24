Return-Path: <netdev+bounces-4928-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C810670F390
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C0D0281325
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5410BC8E5;
	Wed, 24 May 2023 09:56:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E65C2FD
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:56:55 +0000 (UTC)
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2087.outbound.protection.outlook.com [40.107.249.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C71693;
	Wed, 24 May 2023 02:56:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EksD0KqEfeAfWaZ1sFX9f4fORABAghil0qOJ/O+fNOOlIal3FuBVfJFnlB3wS4ZqvgG+NkQUP+Xiw0JA9TNylSI2RUrcNnKuMvyRCMdFt5F33n0UCKhGjVk76evzYRSmNpwqsRXVZLuSC1XQ6A3sQ8jjPiGeQkQhhlgEojivOVvOJNQRyV6Aacs9DQy1X+3EEu1jM8roVD4j/584Ty5XZRol3BGkMBGoTzo6LC0NhS0NAwlmJGTlr2fSynhQyDkwZbRaS8Z53nCD1Jvur3IiSA3Eq7V/cxmBk5SU4hme2nOvdQyKcfdUpm9IV+7pZyJwEkmcoZB1W6ReqNpJH9YFYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNT1+yE/WxpbZmx2QC+0SG+W5mS0geOCs/5+X5qBzqw=;
 b=T130sKqCQRs5I3QrhELVH5+GhhBtScJF2qAaBER2VzbuzdcipVdZua59BnPaEjmLMjzLEKvhUGriVQBUreL2Gjn6HHuRj3zeYoI9f1c9I3XGUSA5Ti0dxhwRkldeLwr8n33FbZpEEodiYptrbh7ajJ5Xcd6PTFq/1dXIz/LUUAOeiLmzUzgDw45YMb91+PJE/4zT2+YNhn+8zHutSBmC3w2iQ21FCGx2idtK7cJEYhOdsrHv9sQELqYxE+n8Ic/NO+X2/si161DsNvSexBTEBghcpjxTi0jU16e+ueFVijL72wtJx8piGOGpiZ0m3xUzmCxVPwbp0Q9QHB8j9ROKgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gNT1+yE/WxpbZmx2QC+0SG+W5mS0geOCs/5+X5qBzqw=;
 b=QOpq0XFflFNbm0bv9QfG1NYVIYYKAe5LawPljwa7XdV2wFez1RZkRxDHX2SqlssHJOezYc8n+E9VzpSZpKP5GqsJsNyCDrILHdG7ApTEsJMg6sICISoCShKBWjqq/1uP+c44hGbZbQcS79cakrKPk1V2VACjNQxvFS3GclnI7a8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DBAPR04MB7464.eurprd04.prod.outlook.com (2603:10a6:10:1a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Wed, 24 May
 2023 09:56:49 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 09:56:49 +0000
Date: Wed, 24 May 2023 12:56:45 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Harini Katakam <harini.katakam@amd.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
	pabeni@redhat.com, wsa+renesas@sang-engineering.com,
	simon.horman@corigine.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com,
	michal.simek@amd.com, radhey.shyam.pandey@amd.com
Subject: Re: [PATCH net-next v4 0/2] Add support for VSC85xx DT RGMII delays
Message-ID: <20230524095645.5sveiut26vz7yv4x@skbuf>
References: <20230522122829.24945-1-harini.katakam@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522122829.24945-1-harini.katakam@amd.com>
X-ClientProxiedBy: FR2P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DBAPR04MB7464:EE_
X-MS-Office365-Filtering-Correlation-Id: 99a4f016-2301-4806-aa17-08db5c3d310e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xsb4hdYsC68LzC/ax7U4o6Uapuhrqw7rKfUfnh9BKc3OKPc8Gso8M/M2OohshZjpbnnSjVzi4LdPb/h7XNP1at/vBtRMu9ac6Nd3bAtOx/Ge/Vi8bLgridEZOJSbBquR4NMxTfiWVLsiOEZz2FVZ/zdgmRIptc93vPy0mbyAZdISimsLIRS7ptohdQ+GhmXcApGOfBqCz6omOz9Q0cmSNrv8XfPk6hChnLMIN7RnYUFe4NAJSKkw6sglMY4fpJxzJiYTlKuUkR5X0rShSUxIjjtAchBdtN21qJywCdphZ9jVcyqV47OSzNk9ZM+tSrIDaNJssYeaXTJL0n8bNRh3jQhL+l84qOchSaGXX1BsloO8OOiGqZOMV//triYM36AsFP5djyZhv9cu7EmdGg6vjMhuc3THpkOGD4ecUHpdYR5NtaFyfOGjvF/KGjraUgG9v6rI62DG0X3wsnU4h3o4Prl3YtdNLgzUHcuFqy0biDuWq7RqQT1xumvVf5Io2si1X2Oxl921vsmWsdVSk7h+APKhpkRodA8+CsdofwbVm5E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199021)(8676002)(5660300002)(8936002)(966005)(2906002)(6512007)(9686003)(26005)(1076003)(6506007)(83380400001)(186003)(7416002)(4744005)(44832011)(86362001)(66946007)(4326008)(66476007)(66556008)(6916009)(33716001)(316002)(38100700002)(478600001)(6486002)(41300700001)(66899021)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kYgJXFIYkgm/vr96SbwElgUvtSKerudwXT1dHWttnnvL2pCGx9YF9oFNl5Co?=
 =?us-ascii?Q?QU9mXJCZylzIQD1mFN/R4ig2gyi1lHhdsa97fx/FdK8LV5aQoW+GBNwriTQh?=
 =?us-ascii?Q?3v8BSBIz7dQ/PoxoRPQ6UF8u2cg8d2l+CFNdKt6uZg45x82WzeumKcdZgysc?=
 =?us-ascii?Q?GsRDEKOj5VINp5mwHKA5YPfzcv+/5HkqaV4ztKWfclFr3rmAO6rrKY52jwvQ?=
 =?us-ascii?Q?CpGhP1A58JrSrvk4+Iq0vLy3B1DkN6Y1pOaA44GaHV+OvhbmX/q7f7FL8K6Q?=
 =?us-ascii?Q?QwtokqG4cABU6zCb+KWlmm76gJ/EEp79CEydzYENNPJzRiOWcbKvWAGSYPjJ?=
 =?us-ascii?Q?ALNgdLesC52lqxuAofbn43ZdA+yuJy5y4xVDkgDCHP04yKGSLC+7lvyJBtyd?=
 =?us-ascii?Q?8oWyqWRvD4pDaZ/I7AdZ2n9/DdFkB0aOg3Srfr5SHTSTBYejSmhMnUFhgiH9?=
 =?us-ascii?Q?6vPwQvrcqZIShEqAmqXfXsU0zmRE8ASVHH8VI+cZP1owESY29+ksN2Hoh86x?=
 =?us-ascii?Q?dDFg4X5bkLB9Z58BRYHRR8jVAuAdSQhmeiTY3ioKjol2fEXNO1Dt5rtOXF7n?=
 =?us-ascii?Q?TcAAWGd5ZoHnEJpLSMhc4G3GF5R4XppvPpePLibYdsjagtRcsT2dfUCEFWgF?=
 =?us-ascii?Q?PWAzc1RCfFFDcVvMDEhE+h0LHmLDE86BiaRFxsgmVgGSSuu92rwrF3F0j8OH?=
 =?us-ascii?Q?73H2FIgzegSO+wlevjR/d/eVQqEXjWf6W1nou+ae/1iIaCx2tfCeR3T75dMT?=
 =?us-ascii?Q?JlQ2AqEpudz/zm0pikS6opBvpwx9REed6Vcl3LEUdJi1WyTtsu4BIxWX/m5e?=
 =?us-ascii?Q?RfmzN0iS7WWezLvz4O6ZIPX5KE4yEFW+vKDwpn5RCwaSzBp+/bOXT6/uws70?=
 =?us-ascii?Q?1iU29LPPnf7tljdJBuoLC5rYJv+GtkNc1iK5RIUek4eTdlOTBXbUXNAblr4G?=
 =?us-ascii?Q?4SNRE/Yx9ZfVeixhz69m3cwiuip3LORNw4+2zsnkGmGwnq4LoUK0zxqlYWxp?=
 =?us-ascii?Q?xjVpkOTLoCz+FygPgTOf73XTN52/ye34NTF55kpETfK0loRqZrwHE8nFm2cJ?=
 =?us-ascii?Q?kCDaApZlAs368DvfFkQAiDmWmjsliS/mbQFyrK/0XfVqLUIAx+n0+apSCUKf?=
 =?us-ascii?Q?k7ErduRKPHNdeqDRCv6nE+OIcYr4SA3bEFFKwXtz2SKw4pyMYE6+O3JZBSXH?=
 =?us-ascii?Q?64DcUokNgsJ4jx42DuxhhY76CxGPCUzM9ipz8IUmTURmIP8yyLEhY7A47lv7?=
 =?us-ascii?Q?gmWsBdqWyiUvNu+P4ZwHQDKfudmOJpat1O7rhzHe8v1tHVTMhkwx4+gFusIB?=
 =?us-ascii?Q?nbd9EHgJgktcEt+B3ZPR+ps31qlssmXbwgPD9FEtma25KQHhOkdE+nrZXvRT?=
 =?us-ascii?Q?8KkOutATl1HTDVHxzjJEomVAhqF+rsRp4PUlNYrw0x4WXzlZcIJN/uoZsfki?=
 =?us-ascii?Q?K7mcZgdlcY9bW70c2WVA+nvLt5q+Z8ir9LYXk+927rIcr+PgN1QbKMkoNqk9?=
 =?us-ascii?Q?diwDKiC8Hr1qLBmcRL4RI81A6D0MMgGG7igQAXQMV34wk82YUPzaaGj4GVgq?=
 =?us-ascii?Q?8+qWdkPOSrDkfPQcpzakKnkM5j9O2VmMjk07lS5bBITNWPaFc9w/2QewgG3R?=
 =?us-ascii?Q?yg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a4f016-2301-4806-aa17-08db5c3d310e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 09:56:49.0906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oh0izIck0kojQ5MbRibmWtssID342zxdsKHmh/1bSOFxXi0ChtxlpSRmTP3xdeTxlFYy2fyTsPHvbmOtETwdMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7464
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Harini,

On Mon, May 22, 2023 at 05:58:27PM +0530, Harini Katakam wrote:
> Provide an option to change RGMII delay value via devicetree.
> 
> v4:
> - Remove VSC8531_02 support. Existing code will identify VSC8531_01/02
> and there is no unique functionality to be added for either version.
> - Correct type of rx/tx_delay to accept correct return value.
> - Added Andrew's tag to patch 1

Would you mind waiting until this patch set for "net" is merged first,
then rebasing your "net-next" work on top of it?
https://patchwork.kernel.org/project/netdevbpf/cover/20230523153108.18548-1-david.epping@missinglinkelectronics.com/

You should be able to resend your patch set tomorrow, after the net pull
request and the subsequent net -> net-next merge.

There are going to be merge conflicts if your series gets applied
simultaneously, and they're ugly enough that I would prefer you to deal
with them locally, before submitting, rather than leaving the netdev
maintainers do it.

