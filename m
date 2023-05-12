Return-Path: <netdev+bounces-2264-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0301C700F5A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6CF51C2135F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C4CF23D6C;
	Fri, 12 May 2023 19:38:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B9723D48
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 19:38:52 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2117.outbound.protection.outlook.com [40.107.243.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0382108
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 12:38:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3RrtFAZt/BlTm6wvr7aRrU1D5iQXFK9oTmpiGc4Ra9myp2kq+TKGvtumJUvYUCag37tenK/WOQdqs3LwbWUfrg94quTU32dobvnOsA+xcg5sJNJPZ/vHR4bT36QQyAqIXCuxvPYp2Rb2j5xVBtp215RI//8HadtRFhQMBjtKJ7JUK4yGq0L7HLOJH7+RITOkzjthTHfLjcallhZR02ajTepscJsSxuMd9WVvdg1I8VjCS2R04Xx1Be6+i4CvYf3s+9B21yr6JUhuEn3iT19HGDqRBZdfGk4qQ/BAfQglVuVhIEjPrZZiTU2J+gbI4Ti4s7xoqBDxPwu7caeOe+Ayg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Z5pQHAw9aG36hwy+FgsLNwsQMTz/zUH4nCtdioPkUU=;
 b=Lh8wxhZd2dkOY5QG98cy5zVEc43r/RJhkoSlsG7cXlQ4j1jzI4MtsI1OJwoTXToziUbxBY8y4U20ndD2optDhutAXnhJ/cJL8DsYLPnFMd8r7IctF8iNE64h5xZq3y5CgwNCwyPerCw10pnxwrePaiP+ezZJQy1yOfIMRnxsG/VodANkAwb1QzYKbrXqEnqVZmgi/KiQtHAjo2kUe/7yBhhyzfHoIxL4YTtcyBK1AZsESuDO2rs9Mj1cOZIvsXKfG9SdBrJsYA77MXNo44Uig6NNsUUj4uUrv48vQ1cjAZZD14mtwHlGRwl+6aV7jMIhguWA2dfbXVuVzyq/PjKVpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Z5pQHAw9aG36hwy+FgsLNwsQMTz/zUH4nCtdioPkUU=;
 b=aYCX9jyGTs+3d7upfyZX/19rpM41G7LdXHG7cXMvtpIglc3jAdxqzTBNyCYjIzHixdxbHWidV4QMAVb4mSFIj43yqKj1zHtarpLf/7tay1U8N/zrYyd4jrTL6EY1ZSOV9Brrkgxz8fOFcrDK9kEkdBHJRxi8atACl3+qLncmc8E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5174.namprd13.prod.outlook.com (2603:10b6:8:1::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.23; Fri, 12 May 2023 19:38:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 19:38:46 +0000
Date: Fri, 12 May 2023 21:38:39 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC net-next 8/9] net: pcs: xpcs: use
 phylink_resolve_c73() helper
Message-ID: <ZF6Vv+TBU0efLXwy@corigine.com>
References: <ZF52z7PqH2HLrWEU@shell.armlinux.org.uk>
 <E1pxWYO-002Qsa-My@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pxWYO-002Qsa-My@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AS4PR10CA0007.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5174:EE_
X-MS-Office365-Filtering-Correlation-Id: 22d38cfe-f806-42f4-c9e9-08db53208070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	q2uQzgbGJjOzmkS/NzDIQBNvWkKNR47/+JCG+fC5V/VFcKRCYA7e7WeKCPoTFR3NUK38DubnMDh7WAViGwloIe0HacxWxFAdFc9crr4AxB/wWw+Y9wY1bdxYmPUCCzavE9AnQszBLgJWHDPfZxTqMCANJ/GkIB9OimgXbJJynMrrISFzQ/5YRYAZ6JvaPwMRR82CF99FssIamvaSanEBW8ZN+nbYHrfTtqK8Jopk2e6zu2Hu8MZClEvK+2qfa1mNT7drzx+/mwX92tTbGnEafXVIuHJoCozZIH3DZ5beu2U/hrVWbIdtVjFxN2PDh8M0+vLme8FmHNWr4ZU30tfLL8htx3dQRlwarjgjPf4rJQgTAl/P5yJOHBYP33X8DKT6p4vWmGPsFFVc0hPhGE8bsLuw6jN9644Jh/x8uPXQXgq2vsoFh4DiTwXccTkpbKv+K1bHq2EYAvK6UKRq1TSeWyJlmcu22CZ5v0RekJBSSn0M7WtrSiUj8qiV8/xDQnQQMH30tyAudD9ssm1BnKJVnW5IRVrh3qe+G2/nHhjy/+QOKEY2W+zxfc6eHcg36zfgMUx4I7hJmPFsvnun10e6GpOhYjZZifQDvlZ3PecHvXbSPgHFKlVMWfwRaUKVhh65+rroGdvaSdFZxkb14UFL6UQBh6acMBZyT17t+UUnwBI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39840400004)(396003)(376002)(136003)(451199021)(36756003)(8676002)(558084003)(8936002)(5660300002)(44832011)(2906002)(2616005)(66476007)(66556008)(66946007)(41300700001)(4326008)(86362001)(316002)(186003)(6506007)(6512007)(478600001)(54906003)(38100700002)(6666004)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qc2RYI5cmtM+H7uTTJ8HMYa4Kk3LyORFl1qMa7Xh8II4UNwQiBIW/ZFzOhDA?=
 =?us-ascii?Q?qg7hXeeBtNvYpjefP+eY13iUVMGStt++bOo5L0vovn3HLsg5O/sj728bLP2v?=
 =?us-ascii?Q?gLU0Sa/H08/h+iJ2NlKs6fcUjatgNSpxhrlEGpfVdu1m8mNSSqZ3aSdomnOb?=
 =?us-ascii?Q?aDXKOshMbPRsjWkO2fmxU5FM6U/woZ03wUZZ+KDZj2J80ePaOEnCEMtCy802?=
 =?us-ascii?Q?C6Zreui5ggHbTXa5R2wkpYNou6KuNI6uRg6d/vNy0owVT1UFfhR/3ehrEg2k?=
 =?us-ascii?Q?VPrnN4EsqYVA9WGnDfJtlc/nZ52cUnVomR5I3bDrRLsP5PHfTrx15ensS6xU?=
 =?us-ascii?Q?Xgd8dPm+R7cRvJ/VYDVyrwJKYreYok54Cp8JTTd7sjRa0x8KvMZ1iYXe5SKA?=
 =?us-ascii?Q?h7Aa3eRRuBgf7yDtUk9EvEPlFuSzVeI0B1E4uNR9JRMCwMJ2WPGska0r9+3R?=
 =?us-ascii?Q?zKRJ0n84ajVBCEAkRwBei9T0uw6WqoqDqEP0+k8kzt4ffH8Xfgw2qHzoDGAx?=
 =?us-ascii?Q?G/NbrZiVkM1fu7k09CnuUZvECf5Kbxj5Uq1Xb7bl7ADw0FmhCUtXYnIJqzy6?=
 =?us-ascii?Q?E3vgtjNnrt0yq5FBIRw3mm/35p3oGgfC1XfdcyN++MSYdLjAIfJJJSkKJA2y?=
 =?us-ascii?Q?/X+d60uS1kVuXmsWLYdH+4JbeQDsdHBUVHs93RGHjHN+pAFFCASKUjkh2Rm5?=
 =?us-ascii?Q?TtegWh7ylV87Sv0USPwwjMb0ydd0aExcTEiiFftFzmnR6L+m2dvlSkKr3T7y?=
 =?us-ascii?Q?IZyKvKdaJalziOjNhdZzJ3zg/4tYNeFWK/akDMwzF1M95+cq/v1iiLmgnVzA?=
 =?us-ascii?Q?+L3h0ecL6eC1LQz7Gs1UK5cpzNno/z5QPO1jY+6vxycJy1n1Kv1xWBG28TKu?=
 =?us-ascii?Q?wXdGD3Azi/29ERNu1THnqfZeLS6dnlJikLbZwPHP6cGZDTFMcKvs8WVulJ2c?=
 =?us-ascii?Q?43Mrj1sba31G1SU23NU+H3iABVKWr2Sn4ngflUuDYQl5ym3pfr1nocBfRql5?=
 =?us-ascii?Q?eGl9VNkIhmiYZfgvR0FAqfNi2MSSKJnCa+LUOZd1nX9PjjX5DZUbNL5GMyG0?=
 =?us-ascii?Q?hFoZOhmljTb9Azzh5JJvtFATagzNn9Oohh/+TjUuPgtZjK7kkYG4iSHwFEYb?=
 =?us-ascii?Q?xwMBHjV3MiB92KLZ6jqRqDaXg9eWZyCz2Sc5cQZkpSbASBglb8qqLnbdxMeq?=
 =?us-ascii?Q?REO9Y9tkLHTToJCeH73A5IJlDrEKZPLX7h7IKROGEz1saKeTBjnUQ5Oy585d?=
 =?us-ascii?Q?lIg4Js1A8QlKa+TFl251V3v/+WcnlLMMUx5+iXl2WUYnmqotpoyeWh9m6Gug?=
 =?us-ascii?Q?ZU4yHIh/CWtM/9T95rGZCqiZ+HBYS4RCFb0wnwRMMv3wOvNpXS9l5X2Uqg9D?=
 =?us-ascii?Q?xUVVU4xOjTGNQ9H4I4NJtjyExr/QUWucettzWboG2u2OHMMhOWrJ7EGF5Pwa?=
 =?us-ascii?Q?QwCl+LDdS8AaAbY1Ge7N20A50v9/h7CHKrABw1oyqXwX3nVZi2yTaFl28jx+?=
 =?us-ascii?Q?HNad5XRIMV67JgIisQtw0Bg0KBlIXrqypoc6BVN3OKB8bLp3PG9D5+Q8NiX6?=
 =?us-ascii?Q?2E55NbmjzQT7PXC0DG1sOTKQ0Kefv6P4PGz5nTZMjEzhWDyZI4AjSFQ/lViP?=
 =?us-ascii?Q?51yB2wZGLbp6TqmX1uZieOI3SNjdMka7gH6uwOGjFqf5gAc/SGLZyxkCgTr6?=
 =?us-ascii?Q?KKPBQw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d38cfe-f806-42f4-c9e9-08db53208070
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 19:38:46.3880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wXCloRxw4s9VriAfU0sjkGs9iv8OmcVfZaZbZo4sTkSRrdeJGClp6Og0hy8S/oshiQEALGQtFPO0RX0T3iMCHceshIPYhwhNv0pBmnXtH3k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5174
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 06:27:40PM +0100, Russell King (Oracle) wrote:
> Use phylink_resolve_c73() to resolve the clause 73 autonegotation
> result.

nit: s/autonegotation/autonegotiation/

...

