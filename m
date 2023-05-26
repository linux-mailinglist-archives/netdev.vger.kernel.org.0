Return-Path: <netdev+bounces-5549-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E253712143
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:38:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3909628164F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 07:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC238492;
	Fri, 26 May 2023 07:38:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD0F53B5
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 07:38:26 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20728.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::728])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA671B4;
	Fri, 26 May 2023 00:37:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntwndkcG2DfBgGJ1WQW1df6odzL8B3EkPRqcVK46BaTRcQmFTRUEXM2nPXMc1v2PAbgfJFE+I9q/ptMWF7ZxzBkmHq173DgI1lBeJQQFt5RFemn3Gwa2lan7FamgGSiZ3dnr14wNAgFGEROtTRo0TMSCzsSn6OSBtrQbJeFUMX9LBKmod+X/PhhyfrW7viwJTqMrW8Tv8BUIUjT5L5Dm1qwsYCZIHW9BVgjlOD/idVq46dYhhAsfBUlXcGFKovkKU5XWie486LolNqRmRhkAS1VhV+qlSP/eVEx9XPuE5laDgrzE3LJLg0kpMO6gD20d6RWO7g4KnWvfykEly2EuLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qEvSgjQBDRc8Kqfh7W5q5KXUlELRXiOzITqcXVyBGbg=;
 b=oVus/dFJRSFxD3z6+E2ii/pKZHP/1qbAOn8UMNwL36fCluh7iHsi+WEuYbE6IJFLEX6BtkAndhbwb/aP7Ygqr/R85nlT+raLhypjONoXVDz2HW7WqVVkeV8rQFRcwxHB+BJXv/6reE1qZ7Ju1fu7CICHTKf6XF+ztVtjuA2LfpbW36dF6gJvSUnxYZ7uDiMYEJyufIZJDwyTumPwexlqWvArzTZkmOF8a7Gwph8H+n9mU62PPyizXXX+K+RB2DvKoClDkhE/Bq+hgCK7kCY2d8PxutXSOv2ABt7talEOeafxb1rgAzjJhETJyW3smc4NjHpbjVeEOxTQoh7z82ofIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qEvSgjQBDRc8Kqfh7W5q5KXUlELRXiOzITqcXVyBGbg=;
 b=P7jRWhm4/EOJcOh/qhvR300xPI2IuCPK9QGhVydWfIlRkfgRVrTZheRI8xXY8VEMUDlyQ2W3+mXjBpGK6+NJVTb5h5BLJzrWUjwPdkuVQi+azqc0n/3n5n6jQqxC6QxiVtcBJt6CINplIFxHufz6jSbvGeSBAQVecxvzcG1ExzE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3703.namprd13.prod.outlook.com (2603:10b6:610:98::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Fri, 26 May
 2023 07:37:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 07:37:40 +0000
Date: Fri, 26 May 2023 09:37:34 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, Doug Berger <doug.berger@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: phy: broadcom: Register dummy IRQ
 handler
Message-ID: <ZHBhvrJ7HyR6/Pgg@corigine.com>
References: <20230525175916.3550997-1-florian.fainelli@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525175916.3550997-1-florian.fainelli@broadcom.com>
X-ClientProxiedBy: AS4PR09CA0025.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3703:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b1a24e3-5d4b-43be-00fa-08db5dbc15cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SmMg3xyFeT9xK+sOGGuiG4ytolQq2dKlC3WxZBiXRfOpAhAo6kZqdhxpvPI1zElAWEk2sU/UgcAukP1kKlQz0h4O6RJQPltj0x8xZNKn1z2fIwvNE6347mvT4GTzsNbi5N7rbYO8K+e4vtoQbLoeNIGXztwjO4WaLWWNPdRinqfIWgXh+t4alR4PJP+zKBc4pufPbEd5bIIyVK6q0gWtq9z24hYC7YnTShOPYXUzshbk/oFLZF1uiQVYvE5snk8nrkB3nH33jomwrPQqo2tnwtOFFkz4qboeXW4ogN2xJDKFqlQQRlY3CCanC/TJbrW2M0y2DO2C+DFAic7GlUbH0IBjgcBGcXI7AORUSgsAm+YL8kGFFJbJmXb4S2FC4oEnCre0ly+Qt/rh4/fs4pd9dWMqxMu6mqTsdE0w7mOzXNYMTbcOsl/YVJ76DeAH2+EDKho445EZGMpi7Xyo/OJFBSUVsGQyHAuldnWYTsrtAOlT38PAJ4SCiQJ2EWVgBa3i4M4v+S9SC8jwsi2Q2+oYmPrN3OkTNwd24TY/lCUd04GjsGRwfRJRDWpOSuUdtuuc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39840400004)(136003)(376002)(346002)(451199021)(6916009)(66946007)(66476007)(66556008)(478600001)(316002)(54906003)(4326008)(86362001)(36756003)(2616005)(186003)(6512007)(6506007)(83380400001)(41300700001)(2906002)(8676002)(8936002)(44832011)(5660300002)(7416002)(6666004)(6486002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3v/Cnig0WaQTUAMrwje3ZJl+0BHN5qQUJnUCPgG0gnN3ZRR3ZqmeXE9BAL8/?=
 =?us-ascii?Q?6Yeux6IC6v4y1ZHpK6LGjRPeYOWaQSEByNd5bK4Og3mPDHiQ7bhnP53dwYad?=
 =?us-ascii?Q?Wdxs3aUaY0CaqG+jDi0QKxz1frf7TsAhFQWQtw3OMPhH0SLYg60pSPMEWtJv?=
 =?us-ascii?Q?D2IFw19hzTpD6XY3WNrVJ6zGlk4nZ8/6DiQvvubbV1rGr8Z+C7bCbZU8IRZm?=
 =?us-ascii?Q?NNXNn+N6YKeatJEFDDdqeqbDcJu+MAZidmMhtv1Geuw5ZbF4Nibxc1izi1VD?=
 =?us-ascii?Q?yK70fi3IsKumx5h17b9s5hoiSs9tVq5B5i2c+ozA3iai7tjHZin6ylmvCrTX?=
 =?us-ascii?Q?ggbKYL95kKiO/cqa5E7qHSh4D4eKsLX/xuGqY2i2D/EGxsuIGbeWSG3doxLk?=
 =?us-ascii?Q?/1mgU+d/0gYf1yMrXL3c8MUn5Q56FFcUcgSeoZ+lJ4/1vB8eTCk3Dh1i/gGM?=
 =?us-ascii?Q?5QBktkmf03u3lMw8y2HaR+mJBZbyWJe/erNJzesyo6fbMIY2ygDyE8rj8TmC?=
 =?us-ascii?Q?dFpeuQwzidEKl7sCkflpfRhLr3wKS4+6BrCvbm3VlX/Wn0p+CcVZrSDJmVI1?=
 =?us-ascii?Q?TFg3n3mSZGfqgkv+sjn1DXzOBCJOMCwRCDOBT4MhQOBw2VLiVyRDmeMp43DJ?=
 =?us-ascii?Q?LfBu0c7XCxCI/7L1zVsVe4QwU4k8DdRV+PS/3Gu94BVtUhfa/HfVI/O3uJZZ?=
 =?us-ascii?Q?G35LMp54zyOkSWPAUpU0UZsMpIMRIOb+uP8tKTwSoFj3J/P/VIoHeYrM1wJT?=
 =?us-ascii?Q?ufk+SHKow5vVDn7ZvNPg6nz7WNGFbAcf252yk83EWQwi55ewqvkKToJ5aFPs?=
 =?us-ascii?Q?GgcO3fSv3BftbsDvi+2bIYf/CjAIzIU7FbgzCM6+FZNHX0+7HBK9Ta7izgBk?=
 =?us-ascii?Q?gW90QWLaD0R6TuhSlooymFyHMSIlK4AI4cPMSQoq8Xn1BQANw1R4U5AU7BZb?=
 =?us-ascii?Q?riQqqrEgOyB3YQ6mXpdsfTgYVqkI1mdHcObI26ZVIFjG2vL2FSdo3fyLqSv6?=
 =?us-ascii?Q?c40Vx5+JkZOquXqtqmUmw3IliixyW5yPhVPe66uHiaHj8ZOpd92m/7tjajuX?=
 =?us-ascii?Q?Mbz6UwQVsVqExTy/bhKda9LJ/QBFCmJw1uk+7XzvKuJA9Rd/Zn3fWKAlychA?=
 =?us-ascii?Q?M6GtsHLWDprR0lAJDk/96EvFQj2xBkul61R3STULndbMzSFXE7dPn0+Lb6Jg?=
 =?us-ascii?Q?/k1HGUuf08mZAmmKIBAcm4PUpskTTgi+ccEzd2zDdfhC503DUItwRvVuhqxD?=
 =?us-ascii?Q?SN0lL0yjrg1tBRY2NNV3mXBbBfTaUUvJVq6XltDIWbRExu0bqRxff0v+Rz99?=
 =?us-ascii?Q?leyoqmUjmR7OtoZWcElaiM5/Ed0Yr+0O/LYq/sh/a7s6+8QtEix9fye/QMsB?=
 =?us-ascii?Q?YXj6TWEqcatOREOamtUJtJ1KtTLKelsvhs794iNq1ZUG5PvrcKa4sXUMo5kt?=
 =?us-ascii?Q?PRvhXzxLpuKEZHQnWf/WMHq4U9Gs9JSw6Dq7dKaYHHB8JSGWAXOS9rhWLl8s?=
 =?us-ascii?Q?Jn9Efxkxgl/7/gnpYk9wuwYELcAtsccTQyf/pQCUTzL0kPo2jGAha6rmOCrX?=
 =?us-ascii?Q?4Br4iqCKRV+x65CgJgJJK9qEaCP7/iSHX2Yos7KkcJe18ZGPtOTKNAiyhEcz?=
 =?us-ascii?Q?uTwaXvcB+szegNnoaH9FCi2z+zN/fa0pAHaun8dtFvOEAJfAWvtrWI3l2uvn?=
 =?us-ascii?Q?qvddFg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b1a24e3-5d4b-43be-00fa-08db5dbc15cd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 07:37:40.5369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bni0U/tVo2c669lxvxhPlUi56+U7MCuFw6N6LE9QlNirjWbFONHFd53d9hDq+xMQ6SzXZCbi+6lzMLViJ2aAEPw4IUrb4KyYTrabfhHmI0M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3703
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 10:59:15AM -0700, Florian Fainelli wrote:
> In order to have our interrupt descriptor fully setup and in particular
> the action, ensure that we register a full fledged interrupt handler.
> This also allow us to set the interrupt polarity and flow through the
> same call.
> 
> This is specifically necessary for kernel/irq/pm.c::suspend_device_irq
> to set the interrupt descriptor to the IRQD_WAKEUP_ARMED state and
> enable the interrupt for wake-up since it was still in a disabled state.
> 
> Without an interrupt descriptor we would have ran into cases where the
> wake-up interrupt is not capable of waking up the system, specifically
> if we resumed the system ACPI S5 using the Ethernet PHY. In that case
> the Ethernet PHY interrupt would be pending by the time the kernel
> booted, which it would acknowledge but then we could never use it as
> a wake-up source again.
> 
> Fixes: 8baddaa9d4ba ("net: phy: broadcom: Add support for Wake-on-LAN")
> Suggested-by: Doug Berger <doug.berger@broadcom.com>
> Debugged-by: Doug Berger <doug.berger@broadcom.com>
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



