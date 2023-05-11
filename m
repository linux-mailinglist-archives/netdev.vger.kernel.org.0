Return-Path: <netdev+bounces-1719-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3AA76FEFB6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:13:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E6702816DB
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40E81C76B;
	Thu, 11 May 2023 10:13:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF50B1C745
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:13:11 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2125.outbound.protection.outlook.com [40.107.237.125])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89F8A1
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:13:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9DpJPVHcYCwKB2aROhiYo9ozZv9iJtwYXJGYsoDxeouDp65l5gpUHRqvF9548L0sTm/rz5A7TbwsHayibEBALpIX3/X4wDcetdh/mjD7CniFbUEPm1vGJzFw9AvMezgk1XZfPuqt9/5CiXTDYXQYJSM8uTeeRAKpHFO4vkwBrt7tB+6ldwwwKZybjE1gN3c90OzGybh0nGoyMglBMO26401cos1rzpUuE4IzfPMviYcazVvQvm1vwhU4IH0Ig8YrwdAPd0IaCHoyVToiemOKTYtmwsFnM+dBdF5CyO0BfWwLviNjZ1vQZV7yPkkW57yxI6mNHqFd/X5S8FvXx8YNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ia/OEia78dHyPDmEKPu3bVQD8s+rcR5wyfRlvBw93ME=;
 b=cpSHpGAPH4fTnA68N7Ayu7BM/qA3aBC7jP7ZJKhgrw6a3IArt1BM4kGV3lCLw5XLDkERmS9SP+lrDOZPFEbG1zpwiz9tXKk+ztY4mHPdZb5i7QoFekT1abMwrBtsqfW3y0rMIW8GGGXIUsaWpbIw+mpAjUzjxgT8ZQBDt4UwC8SHfLqbsylBanaJnJYq/SxoDhvTy3kIYWZMXQ+naCIPQuJT2PzpFxr1cmYKxllIWE9OhOmPCmorsg1rOVi4GXBfyYdlztuW/zrozEemLwuLLjaAGwJjTqXoUo9O54NnuNaR21w9hvh7U9DSlEgviKY1e4VFAPY42ptclgj5CGrVwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ia/OEia78dHyPDmEKPu3bVQD8s+rcR5wyfRlvBw93ME=;
 b=raBKbp/WrqHZABIyL3+5j6QhCoVcoaAQUCKhZjw/KU/KJrO6hUDlq8sR8o3Tj/AzsFkmC9Mmo0g7ADn5dM5/ili4uPfjEuxXXUEdg00AEf7B/mK6jMi7PjkYOgEZSz2XI1Nho2GCToIbtQfziOHmz6hA9hOMbjp1jofrhj3BEtA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3848.namprd13.prod.outlook.com (2603:10b6:610:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 10:13:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:13:02 +0000
Date: Thu, 11 May 2023 12:12:55 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 2/7] net: sfp: move rtnl lock to cover
 reading state
Message-ID: <ZFy/p+9uMW6arnas@corigine.com>
References: <ZFt+i+E8aUmUx4zd@shell.armlinux.org.uk>
 <E1pwhuj-001XoA-Oe@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pwhuj-001XoA-Oe@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM3PR07CA0073.eurprd07.prod.outlook.com
 (2603:10a6:207:4::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3848:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ea253a2-b00e-4922-5525-08db52084df8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	D2Nqqxu1Ty7FRTWt10KbXw7qgyzxpTTm84EOkZx0r0EYEU3Rpnr7uVg3vDhG6mGqLFCze/D30I/83BD4cFTk7knCAKtOetCuc1IqpW9cNga1TktNhQC37FujUtCY6/V0npPHpW6CiaTH4B5GyLl/3OeeGu8CKiUs1S1TneNT9y7JjgK0Q7Lm2m7P6WWFEEuKGPlaofKn3Dy7V4F4ayCRHllptwyifHcsrNt519zgN4uBumRFc/fOrtdE3ljFRs+N988ZQ7c3Kst57GaypQ9kDUUF9LaeIbhmMITlFQfh3t3zm9Ro2ejmjrFLZCDbeKytoIljMAixRsOw4WIULYexqoP9Eeud+5zNbDLnaXkWawn4ncdwArLYBRpmu0qm7e0R5D0vg+gi7t4Du6jDqn21HJra0/KEM+QYP1qomUGXFsFVWqr8SbpoxAMf8K/NcWyXkgI//rrOOIufKt9iyxBPvsrj5UjXEphNwEpb/HJr5rgy3gb9HLQT3JUtuO5VwqgVl+fw+1AI/68uKfvAyoYxDgURMQHY71bgdHzuZtcDhtikCIEcMP/CW/tPrwSVDltw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(376002)(136003)(346002)(366004)(451199021)(83380400001)(8676002)(8936002)(54906003)(316002)(6666004)(66946007)(4744005)(4326008)(2616005)(6486002)(44832011)(5660300002)(66556008)(478600001)(66476007)(2906002)(86362001)(186003)(6512007)(6506007)(36756003)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?23flu+3vFbUKcBLb/Bn9A/6wqGv38irq89AgjH3rgQFONSR706o3WMsXUdoJ?=
 =?us-ascii?Q?7KaadqWSasxoOi4TGC9uongIlKo4mPopQsSTicyDM3p+P+iJMoSBUW0OZEzf?=
 =?us-ascii?Q?ofKjtlBrsII2xLdDLq1OunRr3Wcv/tkLjU9B+DIM59Ee3GGUjpPY7GTFfNAz?=
 =?us-ascii?Q?MwC504UN6so/h/zw+l41Tm+n/wNPbHbL8t5neH0yuOxaQsg+6IbnWuxz0Nki?=
 =?us-ascii?Q?Cv44Szs5bVA74d9GDOS986yXt8OCm6/t+H8Uq6R0508ttiOVu26h7Z/qYGDD?=
 =?us-ascii?Q?uOOXsN0WgLzHAWEjvI+N71wL2+BfA0KeE6l6O7OhGFiRtvg88j7uXzpCHxIi?=
 =?us-ascii?Q?sgyjqQLX4TSvmINhorAZ1HVDO2yD6NsOqFhHaV3SSkitVaXw1R31Y4DDTDdR?=
 =?us-ascii?Q?nAabYnDiVvKllsEIuWDiLaNscGIuj8Bf1PQd+ytRZAlgBIjqge+wdP9iirmQ?=
 =?us-ascii?Q?sBKbpjZzrIu0T1Ersv97jOxVh4INLALVS8bqgDjF2CjpwVxoIhlT2G+s/e6O?=
 =?us-ascii?Q?wckFTnzr3IWokAGNGzHke/gQU8UIiwDl8k02poBqHntwfgTihbgWrxZDwJ28?=
 =?us-ascii?Q?oqUbBFUcivkL5i87bOtedamod6QUuNOjqEJ9NLvV2P3WKjvw6JdA53c9/7DB?=
 =?us-ascii?Q?D4e/+gO2eZtEOMgkL8NhS/qkMNbUnQI7NjscX8A8HPtTKyDUwckMs3y5GeNE?=
 =?us-ascii?Q?AL0cgzO9FznguEkv0GbZqTMikRL5kmZfW6t+uwDRA1u8adWEC1L7JAyVD/8p?=
 =?us-ascii?Q?pntqtTX//6R34is2iMM01NFHWBBWLDUP/m93+tucq0BsTW9x4pZNOyPZuwnT?=
 =?us-ascii?Q?hl9qce9ORLhoefdyE/VS8tb5fEzH6qBwhr007tRv5S5fe+dFZwW87WcRa5aR?=
 =?us-ascii?Q?HiTmZjtJtkb0Ou8Z4jRKCbbVARrVSd57RPzO5nh/d9SF81oEzNcNZuzZHUlF?=
 =?us-ascii?Q?h7JF4NxHmx3HGnXD/46iK9dy4gyehTtL2QbWtwozgztME5ZiEQ3bERaMDyMg?=
 =?us-ascii?Q?PJlGiC7AqYiq1lM/qpZXMA41Zr9537Tifew3WkyuZml3ERldh+mGeFajR3z2?=
 =?us-ascii?Q?H1YhxHv9sjLHPScksfVz52KyX9k7GQQ7gNqWaQNPWwcKJdVgIicvxe8+3Nvi?=
 =?us-ascii?Q?Mwb1uvi+IP+GapRppgYpbIdIEM5YvSnNzTET67LEn0UM5tbIrzKk2EEgSuBZ?=
 =?us-ascii?Q?KIqsMmPXsNzOg4aya50uXZR2W0AIidVrVQfyDNHqkeQGLHAhiVTXBI98l/3Z?=
 =?us-ascii?Q?cHqM27FeZoj6SkLsi3rtSJ/tNqvuJvntL1vIFkNzlLn6iXFND+tJ1waIk7K1?=
 =?us-ascii?Q?b4qHQhx4W0OParL7ISY4wLKuOO4Kpk3d27vYQlXbmZzw8JkysTnIx+6uJYud?=
 =?us-ascii?Q?8Cb36o3H0YwG92jOXTKUxMLNsIzaiuW0cxdwtz34Iul2yzjDKCC3h6hohUBA?=
 =?us-ascii?Q?pEY+EPKZmZCUZmIgR4WKeVc6bp5hFxjmbrD64nIObSa0JZutjMc7PrziMdbP?=
 =?us-ascii?Q?091xH2NHmfHqB7GUG5CyuCWFbLariuvf32Bbm2uspu2rzvUc8WwS5/4dPoZz?=
 =?us-ascii?Q?NZEoRLfLcxOM8RoND08i0MRgks3PuIwW3j9K9SmzSIlGoMWHU4KmOdn1RVyo?=
 =?us-ascii?Q?boeDhUjJUzIPpKjLZnBNsdcWZlRUkaiBBxhcnGNDGF/vOWLln8ZMD7DJ03G3?=
 =?us-ascii?Q?V8P+UA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea253a2-b00e-4922-5525-08db52084df8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:13:02.6058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ea9vPDXWZhzMPf1tTtAZD8p1SWls64ubLbu5zZKXU3M1uQpjjb0FOKaZ+DOgmy5uKgR+c6qte8u9Ok/4BkGJvreRThoB1egyZHqByN0tORg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 12:23:21PM +0100, Russell King (Oracle) wrote:
> As preparation to moving st_mutex inside rtnl_lock, we need to first
> move the rtnl lock to cover reading the state.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


