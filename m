Return-Path: <netdev+bounces-4920-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A8A670F2B5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:25:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5D641C20CC3
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00F03C2F8;
	Wed, 24 May 2023 09:25:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1280C2D5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:25:04 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2129.outbound.protection.outlook.com [40.107.244.129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB32139;
	Wed, 24 May 2023 02:25:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GleLqPFXe/6JIgWsGh7tVfL7D6pWPYf/YJPSAkZ6XSWeE607Y7Mnd0SXMlTwWAE8WtsFEzNzkTG8g17h7TXVK2iZ9QoUyGFXIn5FBXV8j5u9ukmjUFiHdKtheswHFzByIojXTcUKNYzvmqqjUXcvqnbHsflH9LgSj5Tj/5qMKvE3+o4CZ5Sm3HLAniAT39lX0+mxcN9CW5wOI1vV7YZ2X4oYZeajrArDik5dfZp0xMeHtpNX9U3teje74iqI6KVFdffnc1PSiglR3HURQUp50C5fvR8umi4hphnwG17ycF84dYDxAZDqvReKqC781ZcsC65LwgVpSiPXNBosXVv6xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=35ZpsytaxATVUwaLtxrxjiyOAJm2LbPjWnummdyHkO4=;
 b=OdeWVSEM7NmI8g/J34GTRudiOkTd5I5McRvRkp8ttOP3YPfTTx2RQN6nLcwMMyk8S/fdudQ58b3PRShREWD3JgP9LXss30iUNELIqGt5vmitvD/q1s2Me+zXaeeZ7IHRL0eQ5eUVtPTMa1dZA7PeZc/MV9GjXMtNqvrm7s2rhLmUUXsMWwu62ftkS8v3nuJz2+8NtLdyCYwv9WQMO5i1XVXm0MY0Ac1++yl3xiT0H/yRPdzL80LT6qLBL0g+60DQfpoSlmy3gkFpwD/3+YOJPRx8qcn/DT6zX8goY6Jay5YbxCiCOvBNUhY0e4FhpSpLyl9d8zVyHpTyqKMwvLvAbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35ZpsytaxATVUwaLtxrxjiyOAJm2LbPjWnummdyHkO4=;
 b=S8iCmygT2kSI5cLXr00Wlbk2H7uTzJnbBa8YX/0IHYngy6GWyWoqZ1GY8nJ6oVmOGt15l5UNurz98I197fRCJm+cBkQqrjsj48dmCMpY3+Y6T50K9HP932sK1hibGs4x1MGEA+7eiPgVc7hTC5DAidjnW3dTangJv6M8N+SAA9s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4425.namprd13.prod.outlook.com (2603:10b6:610:6c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 09:24:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 09:24:58 +0000
Date: Wed, 24 May 2023 11:24:50 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com, justinpopo6@gmail.com,
	f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
	andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	richardcochran@gmail.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com, conor@kernel.org,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: Re: [PATCH net-next v4 5/6] net: phy: bcm7xxx: Add EPHY entry for
 74165
Message-ID: <ZG3X4oPxTrfv5o48@corigine.com>
References: <1684878827-40672-1-git-send-email-justin.chen@broadcom.com>
 <1684878827-40672-6-git-send-email-justin.chen@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684878827-40672-6-git-send-email-justin.chen@broadcom.com>
X-ClientProxiedBy: AS4P190CA0007.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4425:EE_
X-MS-Office365-Filtering-Correlation-Id: c3ed9105-3554-4e83-8f12-08db5c38be79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4KnZ76QxIEdoIJebr6zLoSdsqxdNhmJzzvwzInMLs+0CBE7QvDu701Bg77cTyuTUR24O2WUS8P8P20uQf3fkoDRyOSPY7SxYBG5bSkPBBogDP//UYex0lDx3598FmpZPWJQnU6Vzu+zuO60ChP4NRbALPJMulyl6zcxvk2HgLNQE5EihOMq4D7HN73ixyrsiayjVhfa817ymhRSgCvXyl528Kicc1EFmz9Ir05Eg89TSf+RypHrnFMMoc2LvPR83/YPujVvvYNMlMzCei/WPQzXFu6xKbW15fJRsaVKOcavZ3whnMhNsRqAfPdSKqAwjC6TIdrRUPk5A3lHggQO9SoG6l/O8pJVb/vRRg6UBhlNq+FbBxe0LORcAaMNKwY9duLiRI9CZ83IInHr1EkSCLwcvmo8lbIKkuQGznMDn8dDc0wWpVg7dfWCttqcKgDIYeSjASRdJAnlfNMTwgmNIlVf3Y9leWFI2YFbpQdyBNTndHngXaG+/F3lJhnM2GXdhHCPAYWZHupV3HmJ68pVqQdP2rGZ0sToumOFhLGrva58CMWnQdhkrBDkvFTyZflS3Zs8+5xJIyp0Tc0usFANwEExOvme+xTDOss11kyqAs+g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(346002)(376002)(39840400004)(451199021)(86362001)(6486002)(41300700001)(478600001)(6916009)(4326008)(66556008)(6666004)(316002)(66946007)(66476007)(5660300002)(8676002)(8936002)(4744005)(38100700002)(44832011)(7416002)(6512007)(186003)(2906002)(6506007)(83380400001)(2616005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uxZs46RCVV0lkpPx3Rni5FDbacfTKAxRjWcO0ZWIxtqVL/1E+Ez0vCJ69h1F?=
 =?us-ascii?Q?KlJgr6sY0jHrB1NsCj4Y1PCsxgl3Wdy/2rnvnhLtmzviOA1akO+QI0I7HV6z?=
 =?us-ascii?Q?KGQxi87v3p/JGSdHWWb0CwkAqyIyTYPcTQBSkiVTDIncE0UBF7CDpKN3YjL5?=
 =?us-ascii?Q?6eGIcY6AQj6UngSzhyQzR+2q9axx8gtNUmhBSW8A2E0bcnQ2wR25mi6+dSLj?=
 =?us-ascii?Q?t92h74j8RGAEGkKmVKNAD0MKXA1rPo3i5IBZNjLeAHLSvuh+ahwmnAotmUY7?=
 =?us-ascii?Q?cqVdfB29jA2YmtMU6ZsZXyquqbcwCYg4WuDmjbu3yn+W+Kw6HfXr1cEIGYh6?=
 =?us-ascii?Q?sXxvtfa4VRHaY6OabNWEJs281PpT11TFsXF+Z1bwVZ7bEGjvJmTQ7EZjF9XK?=
 =?us-ascii?Q?uRD5PdJeTllmk0SHAODBXECujb7iXweNyxEqxpOuA2N+laQmyc6SFU1UIan2?=
 =?us-ascii?Q?NhIPb6E9cH+p4sCKIsD+dsDqvR5Db96czHmEjp3lBORpHT8Q183aRnIrrZP2?=
 =?us-ascii?Q?6Uh3PqPH3wiDdkpUaWH72ca2vk/7+7lUzW6Qf8iO20VeqgLgpJrKMU39pCRX?=
 =?us-ascii?Q?nPcKoyyG5xz0cwYy/8zNy9shDDjmRDZbIobT7J0c4TlZahBwtBocqDWHquqS?=
 =?us-ascii?Q?IeY+6xLYRlzsWlkaRp4+/MPX1uQp64zJURPawxku5fJu7gn2oLGcJMLo3k0B?=
 =?us-ascii?Q?S+c0S4gJ/EY7tSm4T99tPdIIlii9sfsFbctmWpGDDx4NhBhzOWlDpY+577D8?=
 =?us-ascii?Q?WOLdvU58VQBUH0wZc/8hQKeyqYobbzf4IY2rDHNELdTubqEDCB4yWM3IEWcb?=
 =?us-ascii?Q?Cw/LlWdkb1KpN8VJnNQ4o/dhu/KwuEjUMMEYMwhSr6OK1LLFI17Fy5R+Qpip?=
 =?us-ascii?Q?2MF0PWynLRY5pfyl6+HmfOw1A6/X0vPi4Lp5yzPRhChRk0/2Rquawz+ofSPE?=
 =?us-ascii?Q?NIhbW3c4hwem6+Gxigsl5BCk/Z77XN5ba+Jh+Eq1VOAQ0FXkSYIdfsNJQp5z?=
 =?us-ascii?Q?swBkq5hVVn2mnmAsf3mVAJOrhxKgdNrxOTAxKm2btMPiwTtS73d1Zfiykd0h?=
 =?us-ascii?Q?pAeC+gezHQhpmwRnPBOidnpJNxmFo5mKPBk2eFlkJUUcQofz/8lwFCdZrkNm?=
 =?us-ascii?Q?K8u4d8BjqOrTceec64gFlzhSe1n6GDeUkwBJynF7BMmSYzYFZDvijOlcnHfP?=
 =?us-ascii?Q?HGF056dQTZOhXkFKi6ZCcL1ILmVUtBaMad0sEwUQep6nIGIzzo5393lTFmA3?=
 =?us-ascii?Q?nAztA//asU95nj9Zttgl708sY9jLXUQcxWlmAFvS3prF/4qnlX4B0nyc7tpR?=
 =?us-ascii?Q?kcDQ+h4AQtPFxkS0Mupx8GcC0V1bGFTAHRzRWJK9bikHTU/lugHKztZV5qEO?=
 =?us-ascii?Q?FLaZUyAeHAHvIjef6BWdC4vFJCiKrT2Ns9ISESmG9nxPLtbLIGr0T3ighsev?=
 =?us-ascii?Q?vBnIqA8S+Kqffmxq0wIsFyHKDqvm5Va5ufSQXarSJQ8qJ+r186wjtlDgXGiu?=
 =?us-ascii?Q?UFs7ofGu/szq4QLpzKLxWsZ8brPvIKLSGcMzjQMOKtjgbaIcQ+d9UVZBgFnU?=
 =?us-ascii?Q?mA+c+ovWSNFHQGYfI+OXTchhtG9pGg9WgZYjuZNAwv6/Qm0zwQtLVBslvvkt?=
 =?us-ascii?Q?qomo37ysD0G2u37pcG1B1Yd5txOlnmm/dBkzs4+4pWV++AwrI/UNG7HUgYCu?=
 =?us-ascii?Q?RsVVnA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ed9105-3554-4e83-8f12-08db5c38be79
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 09:24:58.8192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: adv7XPyjGfpu4b4lVx23hiBELL49EXGxn/o3xolBOq2Jtl4JCL6BmYWUmkVFD2pbqAE+1qebx5Exx4ayKdiUMyaOy+GTd59+yOQt0l0h0z8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4425
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 02:53:46PM -0700, Justin Chen wrote:
> From: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> 74165 is a 16nm process SoC with a 10/100 integrated Ethernet PHY,
> utilize the recently defined 16nm EPHY macro to configure that PHY.
> 
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> Signed-off-by: Justin Chen <justin.chen@broadcom.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



