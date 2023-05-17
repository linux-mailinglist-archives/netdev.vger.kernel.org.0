Return-Path: <netdev+bounces-3240-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 537467062DD
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03B1B1C20E4A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32FFF154BD;
	Wed, 17 May 2023 08:29:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210FCAD2E
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:29:49 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2116.outbound.protection.outlook.com [40.107.96.116])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BD86596;
	Wed, 17 May 2023 01:29:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBw3JTzqEeSiWpFSr/cWgbY1z2bi6ncLWZUzkmDK12BD9kdWHhfg2hGpmu8+H2rL6YhXUGKFnX2F3vKx0ns1gfrpw2xb6vPy4BoaIFCRe4N+2NbctFEplnLa0SkiALzM7LAxBelZ2EAauRPUlK6n0U+qxz27zZskV9hP/5zv2pwKpCtg8fx1QpXanamICp0rwRPmHJaPm5OSkxz/oxZt6VkscdJAqRYwjauz2hs8vUHGSBExMP6kDWD0247yQFAcDvkWDHuBN5dTwANz8aCaSxjij6UVEuv508tGCNq6ZXhGbDTueUNa5BwJIDlUAskl9ozvUoa7ZihAM4Al8Yod5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q3pzO2zaYpAMuHU9+cMXbAVG+llvsTkon0vceUq9Wb0=;
 b=iW+OhwZ8YE6G95q4CMUbn/PTRKQPZLchO6YspQ3L6K2Rtbbw7pkHyyB2KGIwLJ9nVoJEu7XDvuBbTOrJpnFQ06Zkso3TsihiD37SkXIP9QRFkR/07cTQ6nJRfGXc7KNTKiEWDA9cOwlTcGsBNyn1/SmT8HbyRX7/C3bIJ75nCDsHpIqNrm5Tf1qqhQvddw6SeAwnffjFqfXIWhDV+Bt3k006jhgETd7E5P+o3L53SDOMAw+nhdc04tefY53i8SldyPoJ+Oa/j+tY6IwmnnJUS7gRY25ajkiUV672XTE5KgrypXJVJ6IXX9HKf68qYFDs+TSlNoVgYVNjvG30HEuYJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3pzO2zaYpAMuHU9+cMXbAVG+llvsTkon0vceUq9Wb0=;
 b=TIHzMhor5df7oBspXZKGIm4RInECAbbD5Z/Bvylkwxzkby5ngdnyD1uGsmIu8vZg35K11FNzi3hKLDCe7jlUdcG3/VM81KstHv0WcCUzBgZxvG20NIctGrGubygB6CN3xlFhljjeO5ty1XW1VTH0vkQhfU9cfTAbl+BovUR8PJA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3831.namprd13.prod.outlook.com (2603:10b6:610:a3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.21; Wed, 17 May
 2023 08:29:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 08:29:42 +0000
Date: Wed, 17 May 2023 10:29:34 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, Doug Berger <doug.berger@broadcom.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: broadcom: Register dummy IRQ handler
Message-ID: <ZGSQbsaki8RmR51h@corigine.com>
References: <20230516225640.2858994-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516225640.2858994-1-f.fainelli@gmail.com>
X-ClientProxiedBy: AM0PR04CA0021.eurprd04.prod.outlook.com
 (2603:10a6:208:122::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3831:EE_
X-MS-Office365-Filtering-Correlation-Id: d1ba0ac8-8a5a-4247-c326-08db56b0dcd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yYDhgURdu3kNl0lQR3JLljMwfxHXmaTs+VpqymqYoj/dMzAUUAIxpGUQgX93Z4x3cIGxje8zbrEpOQXLgq54E5hVokXYMkIGVWCiBj8L/ZC7npOfwrho/k0rDGcg7tpllKQZGJ2PJe+nNm/JXQ5u2Z0EcwUiVh+y8+DTHk8/iIicjnn5bHMjbF2q/al4i+YuJf2Es8QX7oK5n/I1xgMhE5uhcxmqHhvKhmIXdEGe5/N8DKafc3vo8DikebgDxwuwUQM1armOXRC3W87gPgFHSl8An/dTzKjdQHjoHKjPEN3YOcnaGNMNqqcR2QzAtmaBRoH3V7HyurnjnxLr05FclkcJX/ggHdnzCXgG/d68oYzHfn0t372scwdnOrAsswof2jVEd9j0lRaxV+bcqpnEEGWL1Fuc7KoZDeatw9nirDxMyqBXHgyvKpS+s5a9oF1kVe+5wdKUVDpl4UFre6O3+OmVIS/CVnn1WC6DuQUVxqkLsKCnmkHsVjKEqZB09mfoMWzFWbtcAPg2rnqI+omx2B/du6YVkb4NMmuLztGjcldLVY3ztIbDjUQhwYPpfHiV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39830400003)(366004)(376002)(136003)(451199021)(8936002)(5660300002)(6486002)(8676002)(38100700002)(44832011)(54906003)(36756003)(7416002)(66476007)(66556008)(66946007)(316002)(4326008)(6916009)(478600001)(41300700001)(6666004)(4744005)(86362001)(2906002)(2616005)(186003)(6512007)(83380400001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o5UNQ+9vQa4sMTXuaNK1NnMLw6r2kMNjR6li+32CwBR7IkOTrVsqSJsE53s7?=
 =?us-ascii?Q?e2BFP8z1qLPIwuo5cg5KTi1b2TjLZhSHGy5tFoZOr1GoHBmCn36jR6Tuy4UD?=
 =?us-ascii?Q?NGQYt31ocip4RF7phkYTcW9EjL4eGYYVT52uHM6aaWu7ckbL505MFiHOIrsN?=
 =?us-ascii?Q?JAuez7FyVWigTCCXJmwcds8NqRpmQeCp7BgoxkjbDuvpHS+5+lxk/Itdm9Rk?=
 =?us-ascii?Q?Dbhb2X+A84KUeZZeVBg2bQHbIzTwDPLq66d+s63KwWy3sbkbNGuFYVUW60rG?=
 =?us-ascii?Q?8t95buHQpBF+9dWxiTtgvgqSbh25YmKDeXH1VPTvp0XZcawlh4darRcIz8Jv?=
 =?us-ascii?Q?JnRnj4Skmsc8goitIZBHYPRTL6Jr63bY8ISrmcqT9Qme4FeIOyRCvW8Yiyyj?=
 =?us-ascii?Q?ELSxZ4LqdQJ68OwRhtytBkhV3tOspH/SyGGrK2UbJA52S+QHdMHcTPVH2eip?=
 =?us-ascii?Q?xevwmjHr10uIlC9Wt35045Xbh2wTtrYmd+yjjXtTxFYJSoARW7H5Xi6qQrz9?=
 =?us-ascii?Q?P8dhZ7NjlJIhOHUPe5VGUaBhOSIDPAUotUIKfDRLc+YJOdjxZiKrUOSdZtB9?=
 =?us-ascii?Q?uf9WgcMZ+h9+mkznqfRjT5pf8vAQFxALccpbh2ptGIZz2/LxYx35PTwbDaq0?=
 =?us-ascii?Q?WMpFaXx1kzEc4pIeNdR92EnxtQodw59w4bcTfNneQ2WMesLFzbnRtX7RyGK3?=
 =?us-ascii?Q?zqgAyX+9ZXErBmDqK+armerissgHjsR2m8iAr6a67fevlXh7R+YkyNQHlF5S?=
 =?us-ascii?Q?ZlBidB7imwr/PmJd6O+/wzuhE0+YApLThFzu+4Q1vS1V/4ny9MDi5dCIYhWu?=
 =?us-ascii?Q?iY6rmH8kOCVN+WQY3/nprTU+44/44wav3CgOFWJTeSiuVML6yHV7K34huu3W?=
 =?us-ascii?Q?0gEf262HUQMUfGiMnMGY5YHI28A25NgxHAgOVLdKqZI8CcFvBBgU1j510CH0?=
 =?us-ascii?Q?by56lUt97qhPwqVGIHOJCe02gUP/fs5zmxLp/KVRXVrEkisxkjX2LjJeI9PL?=
 =?us-ascii?Q?G5p26LhpAa4qupFaThWJDZSJZEEb47nsRovp1DX6NCAkjyG0OgbABOFx/CFX?=
 =?us-ascii?Q?tSfSsfaDs5rRXdaMPH8awIRmaGOp72LIVMIlW+LbW/+rnHeH0UErkTOyldyu?=
 =?us-ascii?Q?bsOMXCfWmxGOq7kxPvAI/Z+JwcFLiTsmVOnNijmomLwohbye+b7zh+qUmVhe?=
 =?us-ascii?Q?259lrAljsE45gwScTmV5iA1/Np7KiQi/KFp4AlFXNJv8/0uzI59LBsq/SbAp?=
 =?us-ascii?Q?skwwHGGcqunnMYzkgruXP24o65Aq46allhQJkEY2KzZfaHMn66nJ6QqOANjN?=
 =?us-ascii?Q?dXmIVUFlJaCYCSWbUu1DWjV2jB7hbu7UxF7KGRGb1eTJzeutd7+zRMEzWXHl?=
 =?us-ascii?Q?UjlPbE13wEsbqJ+iDJbvZYuO/lJmxuP10Z3PApXWu8tzlosFvPGukIozC2na?=
 =?us-ascii?Q?2X4M2BXoix1U2CjOAeJTYiNM3pX9MTpNQxvPctMUvpUjZxvY8ymsTOW44a0b?=
 =?us-ascii?Q?USLucAS5RLyNQBtWenI6YrmSeimqoX8PprP+jJ6Sp1gO/NeOtl7YqIzXmEfu?=
 =?us-ascii?Q?B5qa8q5XhB2fgIo1RioP9aIrppm/wOECxDEPGR32MuHlNeFgBtsW6J7ahbJv?=
 =?us-ascii?Q?zueQiHs/4ejQ/mY34ZwIARzzc/5MmBGn31LOcCsMjvJXvxzFVj63uvJffpqs?=
 =?us-ascii?Q?fu2Yzg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ba0ac8-8a5a-4247-c326-08db56b0dcd0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 08:29:42.4773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aeDdBxg8MEw0hiTb4+lX5zofxZq/W5Ozt+qO/XxaSai7oCF+et7Xae8aNajctbJ8I1E/rlywdt4h2AK3mJK5rLqhNTUcDLIMJI+LRHvDOdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3831
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 03:56:39PM -0700, Florian Fainelli wrote:
> From: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> In order to have our interrupt descriptor fully setup, and in particular
> the action, ensure that we register a full fledged interrupt handler.
> This is in particular necessary for the kernel to properly manage early
> wake-up scenarios and arm the wake-up interrupt, otherwise there would
> be risks of missing the interrupt and leaving it in a state where it
> would not be handled correctly at all, including for wake-up purposes.
> 
> Fixes: 8baddaa9d4ba ("net: phy: broadcom: Add support for Wake-on-LAN")
> Suggested-by: Doug Berger <doug.berger@broadcom.com>
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



