Return-Path: <netdev+bounces-1715-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D734C6FEFAA
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0266C1C20F15
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4FB1C766;
	Thu, 11 May 2023 10:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15A61C740
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:10:23 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2098.outbound.protection.outlook.com [40.107.101.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CADC6E9D;
	Thu, 11 May 2023 03:10:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPbbq0KtR2171tWjad7A3ggqNZHeWteK3Qw+6Wp8H/YR73/sHrUO7ADH7gGk7n/WD80mprf0Z5XmwoSdHo/tohvgMaqauvD2mBGegJjCe3HGRUoc9n4NSye1tejek+lWvWW66frsv1+h6wWRzdt7ToEal9LAtEywiwWnfWamsz9BpnEZsPOjzIWA0lC02+hGcWi9f3bBRo1HnyylK6XZmpSa9gEAESw3e8zDGjDArQBRCplKJM2LXdOqKFJ1ylkhC+BXpzvpeSZulkJz4WDC2MYuFZsWYCVz/BTSUZbq0TIM25GR01mepDPmYjT4tucbLEo/YIFrydPxthmoC+JguA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5HB/6+rQbnuH1yr3EHOINO/vz49rLPGGQcHqp11bk80=;
 b=gf5P5rNpF7KSChKwUkbYniW5bLeN86fgK/SdAGzSXrjQAyMa7usWG5Cs3qY3j4T8lWBJeVgbikgKVt5NRhFvrdvf+mkgeS6bG9TQ7AgI1GBTBanoJQMhwATj4FSqE7YmGxYQ2NuSWgAJH7wMrK6Du35V40JnZCJffOcnN1PoN2vOK2J2uhOw6/PTHSUXjhbGvfHawq6FGII2UI9imEF4UCfkgwa0FPqZ+kIyQNVpvC7J5av9IsKwed4AZMRcUyScZAYkwBInZ4vIx6bi1CZmnOlAqQ1ESxtcv3i1XFhMp0iLg77UT/hxa+WrTF+frgqC1i8Q4mjlzvPHu6CNhP59Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HB/6+rQbnuH1yr3EHOINO/vz49rLPGGQcHqp11bk80=;
 b=dM8yMoI1mvIDKbAOTVbpLs9uI86OSSMvum/rIb6khquDs7gOmUSZ6hTrbxRDwduck27Asw/YfLmjv4k0QQ9l9mxi0gUOil28OrMs0BQCbj+pgTG3X2PW0zU57wgfODgRxeJ1XAW27lSs51wK1h4Qkz1SrwRta9Gj+JPAoBX4i3s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3848.namprd13.prod.outlook.com (2603:10b6:610:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 10:10:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:10:18 +0000
Date: Thu, 11 May 2023 12:10:11 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
	Peter Geis <pgwipeout@gmail.com>, Frank <Frank.Sae@motor-comm.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/3] net: phy: Allow drivers to always call
 into ->suspend()
Message-ID: <ZFy/A9vuxBl7WKt9@corigine.com>
References: <20230509223403.1852603-1-f.fainelli@gmail.com>
 <20230509223403.1852603-2-f.fainelli@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509223403.1852603-2-f.fainelli@gmail.com>
X-ClientProxiedBy: AM0PR02CA0030.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::43) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3848:EE_
X-MS-Office365-Filtering-Correlation-Id: aca7599f-8eae-42c2-80f1-08db5207ebfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0Ibpo1gC2FuqJnkwrNqI6b99+QokrWyhnxbWoOOl9yTBTPK/u4vxlYJfT66ds5SytI6o5/XPCRXwuIjuOpRQZ2fnzOGxiUCOcsuFLS8NlTU5I+bZrLswQZ5lytfXo2aPayFP4TAG6SwWvNfFWXutQypMfbNv0jU8j14HU7y4bTSMQgJtFNdmjtfm4tSlh24mwZPewJseJ1j4FIcDH+96DXH7SanVUgvT+YhKSaWeTAG5akKPjqZyaiRBystCKQw0PrvgnzSJ2hleYR845/jTREJ/+PiAbABgR/r1Rr8hivbEydpooHezTom57JRH/4K6dOr4pwxnkaOyMoSAiYXM094h93RQ2xpFE5epObGj2ROQqK2j1sYgE/LgdP87ohF4X91oqktdjySWM1A2v0tM4g9b5w84vHnJieAGgHhZv6G6GTWZfHgYUSIe8bbYqcZmjRI0BpgSN8bxlvd1zlHKf88GpGItOq1+DnxoToyJ9IsoojS+ZteRhgzWZiIaJTbMA2h9U3pYkMwATdee/SSlsgbxTEkDn89QMPE1cP8sU5LNlujE2qbrU1BZk3pQ+znz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(396003)(376002)(136003)(346002)(366004)(451199021)(83380400001)(8676002)(8936002)(54906003)(316002)(6666004)(15650500001)(66946007)(4744005)(4326008)(2616005)(6486002)(6916009)(44832011)(5660300002)(66556008)(7416002)(478600001)(66476007)(2906002)(86362001)(186003)(6512007)(6506007)(36756003)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jCZUfVHQoA9M3lnp9/qlHtW2vkWhvc6K59kcyNF8wO/LYNebmPIIPnvBiqRz?=
 =?us-ascii?Q?O9lmEgmR+dnCb9dZQ8OQg2FCqw9o+EmiAw+xhDVNMoreMiHNNEHTkjwscdSO?=
 =?us-ascii?Q?gcyiPNBbIJ6fkNFw+oFb8r04mgXRY0xJ25k5arkyRFxzOKYgQaqSd0ExWSUZ?=
 =?us-ascii?Q?GBC4iCxcNrqLIatyrStC8fr3I2IByAg5mP9oZhgfmortqzXRg/RXJ0NtzX2R?=
 =?us-ascii?Q?IOs4wF4mpEelPAG08Wm1UMXeMNSz0NaaPYQSpqXBbNGrkNAi0XQlFQvkMhec?=
 =?us-ascii?Q?T8kawX25G4jBIrB6iSmhnOTqsxUR3mXPQq08OA9rT/e/WUSTKmJzmFGcqCNz?=
 =?us-ascii?Q?6+Bo5Nb54fVNv0bnuHLHYjPMMMy9AGECjOV0QJvrLN5rg+BusDn+mTOghtfQ?=
 =?us-ascii?Q?j9Ajk34R5YWKne6xaXuNaJxd2AtcL2cw0hBnQfn3diUUrEebjLgAUTpKUGU6?=
 =?us-ascii?Q?XRHqjemZCwe/ualLEDtZOSE2H/jO9Ip7ORW1N+CI57h8WfnaN1igbQlnH6Fn?=
 =?us-ascii?Q?spjagktSzRyy4YyYQIMWkE8SqxhYGButjq6zlI4FhKC9kGBECmbzu8u7sG9n?=
 =?us-ascii?Q?i7KRaKRiP8SlfzpQ/R5fG/chWOk5M3b6VzpUT5J+7cI012CWDpz2lMle+GHI?=
 =?us-ascii?Q?V7eIsaRPeRiWWb6vEROJ6PMy1j1QeUgmmQh76hnhENBkTj9ilsl5+ZhhbTgN?=
 =?us-ascii?Q?u+7HVAV7o6pIeaNs81s0UGLUEN38+twurBlSOh5nUgLs64QtRi653nVqSMxc?=
 =?us-ascii?Q?pbFRUK88XLuIpqi7xLKqMkvCFFO36/5q61PwjvWyFrWsKWOxyCIym2UgyemA?=
 =?us-ascii?Q?ql7KvlZljHR2OQvYk1n7ZyBjcNRSe+omGTmqkV5qcfpVhWcX9GQtNsvAZv5c?=
 =?us-ascii?Q?/hHPqrYM56+thQQ0j8cEbuW53w7ahsbCqTGt/VZUz43fWeM3XMaQCHYUzU6j?=
 =?us-ascii?Q?GHb5QTP4G3Mr3CTopdUAqccwGmyebmVnKDkU6y+B39RV/Oo3p1bX//wFSKN9?=
 =?us-ascii?Q?efOYEVxs+M5SWaclHlrsWtIMsEXhmn9FMEAHkf3ST4QoiFRZbtfRJybCLeXJ?=
 =?us-ascii?Q?toYT7r+opm8aDSgq810pRDb4yb6IkRm5k/PGst0/hoBatD7smJZfsSaxgjDU?=
 =?us-ascii?Q?RDNddF1Tgad/L9+EL/vbIxa9ADpPy6p803VlTMDaWT5xfhfEd1G0lCcM9F7Y?=
 =?us-ascii?Q?dLMTq29jO+RjxjiifgXVznkv5KnsPDxg2n930rxEfqOW+N5rPEiOEy1dDoJ/?=
 =?us-ascii?Q?C2a/LTuCUAFBOG9LK2sWmeqmgAyTS/95QiO04EJq7/x3YEKDmOvw/Z2eOFCK?=
 =?us-ascii?Q?o8FpMwgex0wYYyfle5Crd3tG+Gdw0i0Hw8cHUVd9H/ia1y52ENq2FF/N3IBV?=
 =?us-ascii?Q?g7YkD3yznJo+66F2yIgXs7f48CDMTxkyBCbd2Af7/jRHwgqD/OZmRX1epaac?=
 =?us-ascii?Q?C2GfJiRqU/Z/mSy7IZqsZ00at4dBjaqYHP3lqiMZ6z2Nk0IcE/GGPmCirrOr?=
 =?us-ascii?Q?MHcRVRRq4n5ync9IjmKeVqzLf8i4F+gE9/TW4+3V71514o1o95dY4wrC4c5+?=
 =?us-ascii?Q?OxE7kP5yH4B9WIYPYlYqEPgfD1xvQRaT7Re2htEzYXZoK8FvrZlUGvOVO/or?=
 =?us-ascii?Q?KKMbAnM/UE8JWpVeWHrgITTENRrUXGttOMHubtk8MD7Xhvj1AVrgWOmXm3Zo?=
 =?us-ascii?Q?IhelWA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca7599f-8eae-42c2-80f1-08db5207ebfe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:10:18.3162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UsfJKcvhcH7DI+26MH07FPIaUg1BkiF78b66jEsN5K8NNWj9qeiCrbuT0H5jA9tMuRqZsNyEfpmWMzI0rP7agBcxXyfedBeX2MtSbPvPAwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 03:34:01PM -0700, Florian Fainelli wrote:
> A few PHY drivers are currently attempting to not suspend the PHY when
> Wake-on-LAN is enabled, however that code is not currently executing at
> all due to an early check in phy_suspend().
> 
> This prevents PHY drivers from making an appropriate decisions and put
> the hardware into a low power state if desired.
> 
> In order to allow the PHY drivers to opt into getting their ->suspend
> routine to be called, add a PHY_ALWAYS_CALL_SUSPEND bit which can be
> set. A boolean that tracks whether the PHY or the attached MAC has
> Wake-on-LAN enabled is also provided for convenience.
> 
> If phydev::wol_enabled then the PHY shall not prevent its own
> Wake-on-LAN detection logic from working and shall not prevent the
> Ethernet MAC from receiving packets for matching.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


