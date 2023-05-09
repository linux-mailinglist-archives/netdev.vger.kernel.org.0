Return-Path: <netdev+bounces-1072-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D796FC159
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:09:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2006F1C20A1F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D790B17AC4;
	Tue,  9 May 2023 08:09:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B5B17AA8
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:09:12 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20730.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::730])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2217DC4B;
	Tue,  9 May 2023 01:08:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOzlbJzGl60V8h3lhVfHC854nFAqRguui1lGF8lx1jHvTljjlN0/4h2QZijKjameJHJDroXFCit0fxcIVhnAhKD3opg6b/ITu2VrBN+5ZspFHILvz5pGuYhwbzC/UaG2S+mjthnrNF1U6+qem1VvOe2Z9QHjittdVwEocRpkYvEN1S5gD3zKDNdmNPpv6zDA1Ed29WBMFwk9/W+1YKUdmeDP95DGFBnPxM6HqUfe0IZPv7NClcEaUQsOkfEBxpI37KUsleVkk/58LkydXr4GCSPGLGvyXw8JHLPnOHF+i3Y/lUSFtHYVlJgcMgZ/hjfM1tQUtyJQ34pGoNJtQP79VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+tP0VACM95FYybAPJwkv1oXx0toRPqPZMtk2l+F+5I=;
 b=JdHvc2gOhlf3xoOcKdF5ftnMJaZfR0EhwGp6x42beZfRAYvTUrcc5iafpd/MGQpQl8Uiq+8gfvvENEYU+eGd9vTjZO9rQyf6M16r6GQ6pfDvz1Ge001xIKqpasPrW+vsJKxYd7lNb/15Kp85tJenaxamCcVbqQ4ySX84SJzHuuFoc5TmkpJLg8s+xvyCH+UPsLizqG3EkcW6ES2Fjg0E0cAHASreNx5zcOa4yodi0NXCAaNjdCioPa9CPopxzAW/P2j8TLuBYeT25h1WHN0lkvyAh7p+LuT0f1cNB9APxbLUo/Pkh57Ff1tYdvOKHXZHsn87Wj0CbHZPWSdW4PJZtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+tP0VACM95FYybAPJwkv1oXx0toRPqPZMtk2l+F+5I=;
 b=haN9o8xo0u1N3xtIFCOioY2oh6e+Y2mHO7zx2OkGT0OPRjexUN3pgeV5kT6vEu/baYnx+HeCYE4yaBoOBAZvglYv7AOBkSLy6gNM9KVQ/vUojlJHAB7mxy774YNlmBgtbd0PZyOQDw47qHshI/4Xfsmthj+8NYr/uUk2T9fDPyM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6260.namprd13.prod.outlook.com (2603:10b6:806:2fd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 08:03:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 08:03:13 +0000
Date: Tue, 9 May 2023 10:03:06 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: bcm7xx: Correct read from expansion
 register
Message-ID: <ZFn+OqjoT9Kg0BQ/@corigine.com>
References: <20230508231749.1681169-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508231749.1681169-1-f.fainelli@gmail.com>
X-ClientProxiedBy: AM0PR01CA0099.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6260:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a2f1b61-6515-46b2-376f-08db5063d698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	81mEX3jSxFDX6SbIEgoc89Hup3lgk2SXOVZZPUrqleGYI6bj5OcbaKl2EMgPdsLOmE/ThLB68nF+ys4H7/ykWH30cY2NRLJMy6rS1NWT3fbC070/uRE8UpMMbFVDoLFEGrBWXwzsXLpmxn8J8gGtHNlsPCkDSyb95UtHI1f1SNyDfWDgYEh2SIn4haIuSacaK02FrJk0/c+VD0DWvodnwfDqPXEXgk/8oB4pSQ3BJptURNc1PwbA2NJ6W4u2SLAQaq9AqHFRvERhhAtfsIiupSvzwMF0sm4muGcz+6Q+UdyBnwWhrTsWkrS00um/L3yv8KL7qaxCWfDgEpDfWuw9DuOYsPv8+NtmNh/MZLKeAfgnvNBHXYNC4gyWOhbHTRH0qqsBs6BmhKRyvYMa8ozYAf3jWCwke5VGBzAk1L8i0gkwL7UMyYS3IFzxSctgnxooPaJSJ/XgPz0M46z8KGaqsi6ASeXFbHvsGRAzX9in49eRpXRKUPWHszUd14Qgf7Xn++dsUh5DEz4PLWprwZAgTemKfd8MPGhVlRuST3Ub9kG9zSt+daVOwcPCX4gB5bz4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(39840400004)(366004)(346002)(451199021)(6666004)(4326008)(6916009)(316002)(5660300002)(44832011)(41300700001)(38100700002)(86362001)(54906003)(66556008)(66946007)(66476007)(6512007)(6506007)(2906002)(4744005)(8936002)(8676002)(7416002)(186003)(6486002)(36756003)(478600001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8BS6O86Dr0u+7XL4Jn1HseffKGeIYJgMGii7MBJN/7fCJ6Vxb8ZqKJAjIkFn?=
 =?us-ascii?Q?LFEbjY6lCTDa93Zn2HYO3kbFGQInGdXCrIY10l6hvmpz2pNZugARZFSIsyp5?=
 =?us-ascii?Q?Fka+Qx+L6a2ZKvohQWN3pVnUBg/weyTffeLYRdpkvEVFan3HOVqrBuq5grNk?=
 =?us-ascii?Q?nnq6ugT36ac6kSrRW688FcXs6cQqo8SOh4sAcN+iAwKwofQIA7ryedGYWGBM?=
 =?us-ascii?Q?eD228IyPI+XV7xxm/mHI7aWd2S+0iDnJouv/aSd8B7y4uvbVz+WJuR8GOm3X?=
 =?us-ascii?Q?Wp2b3DMOBTq8YWrBMjM1X6RGWo2pi8LRWLpJqEv36hkecoKC8Hmke8tfHWpv?=
 =?us-ascii?Q?WeCOmiN6f6k4EaxG07bbr3GDqZlwII9/togOqAgy8K7O8KpMs+YquVs5h7Jl?=
 =?us-ascii?Q?5B23E2o/kfPJNxwG1hKw/J8c65ZtLY5aKEktva1G0eeHImGIu4HAxjnN7+Yu?=
 =?us-ascii?Q?NWR/hSw8zN51aNDvxI36mU1bcRDhor85HgqWuVKYqUaaCykWADPEWfZdZcCZ?=
 =?us-ascii?Q?Iqufx3XJLynOPErAFXvAIY/RhKcCkWPdJl0W/EwsEEYm6rMWCHrxfP9EsqvQ?=
 =?us-ascii?Q?gR2BwFF1+JP7rRI64Od3yj1Sw69Lg0Pj+DspPPlQPFwL4f8RSDiTExm9FMsn?=
 =?us-ascii?Q?sgFwepMafDBy9URO+sE6kaBr4ptU6sXIHlUZJQtf8tXkxGXbd04oe0dFo4Nx?=
 =?us-ascii?Q?EmNGs0RmcPzGd3X/cdhYralYRRLwdDQYeREaj2j5btGrY4KtacEym1vgDDOG?=
 =?us-ascii?Q?vlcxDrGZpI6SuIknqpnw6hRiNzK6XPELwZ8A/o/Vp429bH3eZC8ZEY8ebVJy?=
 =?us-ascii?Q?rLMpoYerMEj9RnQS4xjuiHFOLqrZYn3NUZhXcZQvOhW0DVLO7A7jVr/rSa5g?=
 =?us-ascii?Q?m/Qhs7vrCge9he+v8E1+7r8EHlYD0xtBqkrxZoy0fKxQETYyOUF5zG0AQpNs?=
 =?us-ascii?Q?5gkmbSB/bVhj0vlCCxbkFgHhmDpC4esuqpW7ObuX17oclsyHVWuEpT80bWyh?=
 =?us-ascii?Q?0d05noqjc1e7Oo64/hBUGo6JQa1PYtRE+nyM6bmuPFXHkeoGrsd902QfoqNK?=
 =?us-ascii?Q?5kIYjzCHIF2g1Gv+aV3qoWE6AP/d6Bn9loi9Y165KvdXOPHmsJQ1zhmb1MzQ?=
 =?us-ascii?Q?WVKjX62G4cE26LwiArR2tdoRFxO7TwMDHe8iFxaDhOU9Z290F+o12pIRaoZh?=
 =?us-ascii?Q?2eEhVFqP8gkrhajnAVJ0k2358dkhP+bLvWYeddsDhIkAi5tu6JSPjRa37ywC?=
 =?us-ascii?Q?X+yuY6rXzZiR0sO+FdwP1vhKOUrkg8KLFUIzKd3PCCei1usvAWJ/LUi3+0p6?=
 =?us-ascii?Q?XM5TKrd/sXWlYgXWAdU4hxC5zKol3dAmX2SWtTIc3BJEleP5YfcNWPkFJjER?=
 =?us-ascii?Q?1zXqz/ITGzXIm6DxeMSuvixd2DoUS/zZGCakCWHlDCutcZKRSarkktYB2vke?=
 =?us-ascii?Q?llFWrlzE4o+80uuqUVMkOCZxi32E4c4N48z3RfKY+N5TFHImkrnspZaZVvXQ?=
 =?us-ascii?Q?Ba1aZHShWA4e4gV6GhhPYq7bBPjEhJGtxytGac2PNsSZQoZFZuSr8xigY49y?=
 =?us-ascii?Q?qzbhXSoEPkYkso3E5QzILdJnI96n714lNNVptyV0JtSMrqskNRimcQZW+II+?=
 =?us-ascii?Q?P2B9TESH5b0rsu4ekn5n3cXx/e/FCQBM5uviOBfXueZnafycq1FxYYRuv5I5?=
 =?us-ascii?Q?wHCQzg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a2f1b61-6515-46b2-376f-08db5063d698
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 08:03:13.8281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8YAHp+QxIIm/XNUjUa+Xurbq7lxasZD9HSRzVSB0CcRG97FkOkYjO6CQdraKjuR+mzunYsk1UYZ3FcHU0iXiJbcSvQlHx2Pf2gAXH8Hlhis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6260
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 04:17:49PM -0700, Florian Fainelli wrote:
> Since the driver works in the "legacy" addressing mode, we need to write
> to the expansion register (0x17) with bits 11:8 set to 0xf to properly
> select the expansion register passed as argument.
> 
> Fixes: f68d08c437f9 ("net: phy: bcm7xxx: Add EPHY entry for 72165")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

