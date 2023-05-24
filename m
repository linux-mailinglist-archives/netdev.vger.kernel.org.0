Return-Path: <netdev+bounces-4919-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD07E70F2B2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:25:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F588281216
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A99ACC2F2;
	Wed, 24 May 2023 09:24:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97601C2D9
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:24:46 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2106.outbound.protection.outlook.com [40.107.244.106])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFF118C;
	Wed, 24 May 2023 02:24:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5OVxk9DQffL/Od08yL2PwAePlrQm41kQHYO9lkUJY3+8Uev3ia3UxfHWSjLvR+2ViwFRPanEsdMYV38mIZwUeSp31VTU7UJArgXQ3NYcJmmmebFxa2ZEqbBh/mmER9SYrpakxvsqbyEsPgp/8ltjRjTw78sdHYXtQmvbbzvKeeiu1fVb4Vucv3Ul/xUBX5p4wvsIcm7LWJllNApR3Xj+qkcsJPQXi2P9KszImNb5vleEntv+5GyC+EsPJ16kVTGzaCY46s2gjhlMJ182kJcKzNiIi1CeTpbZJvhhKki/iLyVFcAYJbOHpJ9EnKxgSqso5sPkDtLvXA2WBqRWSMJtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/7DXerPWSCrj1i6KigMrV+mmeVKMZSOjyEhKEXMZAQ=;
 b=QRdWUZMEbuxMq/7+uURoJFNxwCu7ImYLJ3sHYQfnfmFmfLFfmx4Xvwy+U6fRJuc0wWaHNfA4rSfn81Fbwl+f+1mi557a8sa/fsV1aOmV7SoEKyeGX1KAKOf0UZVYJpCfVR6i8xieLqmBuXa32dLVP8V0dSmjpt4uzKMuTE6g3MAV5gE/VWcaZ7sWcIDhhiEbt++NbWxRp/LZRbjpM6I488gNjKgb8dxtqiQxQ8SZPQlt1YGVKHR7WCbahl1QyWAKdL9MTK6iiliRdjb5CBifcAKAawr/bB8WW4jewm/kfu8l1PPaJoH5h+ewhUPLM0AhJkdR6dniQ2xGBsyTDVkiRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/7DXerPWSCrj1i6KigMrV+mmeVKMZSOjyEhKEXMZAQ=;
 b=HYDlBmkRol6YFU0xWfkcsvUVsIZFVK4GIVIgmo3dGJD34q27AgFSm/20GwW7hxip5t9zz8pWkAzX158G/c6gUlZuACeKiVbCfzlslVtKJxQfVT0RtSPytm8WhILZmPb//ro4qZqq+tmxPs7+abTT3RzqT+gzcBE2OS0KcXBELGo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4425.namprd13.prod.outlook.com (2603:10b6:610:6c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 09:24:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 09:24:36 +0000
Date: Wed, 24 May 2023 11:24:27 +0200
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
Subject: Re: [PATCH net-next v4 4/6] net: phy: mdio-bcm-unimac: Add asp v2.0
 support
Message-ID: <ZG3Xy3UPVDeUTQVy@corigine.com>
References: <1684878827-40672-1-git-send-email-justin.chen@broadcom.com>
 <1684878827-40672-5-git-send-email-justin.chen@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684878827-40672-5-git-send-email-justin.chen@broadcom.com>
X-ClientProxiedBy: AS4P192CA0044.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4425:EE_
X-MS-Office365-Filtering-Correlation-Id: 58aa4a18-fa6f-4996-46b1-08db5c38b0e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AhlZik5gNq7lPNCpFYsgrVfl208BkthyU9GVtDZWbbCnU88IBsOIRMjHqcrUuGZ6bzA5cJyWMJTsIedOkm+ZZW1A2DagYyNwtVMecqLBJ2TqUaZFFVG4oMha5wmcSIWweENZWAIMj2uDPunWIfCR6Ye+Li8TVWGWmSfDMx30f1xy0Gfqr68b06vSuw2z1Mejh4R3s4xDcwN9r3UO2nKBGMLFT0M0qIWNdpvB7JtvGQWm/Zvqb6nXmE2l7IOC1M26xhDUbItFvkUZAlOz6TJwIdzSF9nxH//lNd1uQZ8bAW9EozA1t5gxjgD9AO2uQETo9p41kEdAIllEI9y9pbylJ8PD463rUC5/L0MEd/98566JePNo/S+3gXiVbgSjQMv2b4AZXXqNZWH51u4CxGVz3uI21zrVLlbP/VVDJZ2tXgG/HsbP2V9MgOn0of4CKlg5+sIm5wyNlD/5t4xpRl/K1H5951jaxcpVeb1uTTR8IA9FTZACL7Yg/ZmUHEubId5kmvP4ps/ix4wfqhGYljO5JrXaSOUMwPeSqLwa1rGGeN7PpHgy8wn0E5ynLFsNAeNi7tffSQjbk91Ai5FNHA0ZL84THTRi8tvFp23FPHyMGnI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(346002)(376002)(39840400004)(451199021)(86362001)(6486002)(41300700001)(478600001)(6916009)(4326008)(66556008)(6666004)(316002)(66946007)(66476007)(5660300002)(8676002)(8936002)(4744005)(38100700002)(44832011)(7416002)(6512007)(186003)(2906002)(6506007)(2616005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?POcwgO7Bz9s7peQTviE7U5ZAFbTPi3qlEVVp/RrR3/h/IGzJ3hig43hQpe/8?=
 =?us-ascii?Q?UZHDktTJ8EkNUeGdKEuaiw/Gy7idFoljG/XYXiAVw38XC7xfkSj7cHKV5eA6?=
 =?us-ascii?Q?+LkYZIcps5BwNR2xna0kGwZQ6Lz+0rhi7/pwErgTk7Ggu3JouxF6UzMrbf4N?=
 =?us-ascii?Q?WFF8uEfq+OL5/XojD+eBMBAtA6l4NnDBHkZILh8gO455VvGxm7bGFdOef7NH?=
 =?us-ascii?Q?7dGXEOZpwFJHwhW62FGjQ5Xcc9QFr20Vcfv8dBQT+ViVW5CKWAKxroctIwJ9?=
 =?us-ascii?Q?xtuA23DJvHQ007NObuDkfOQ5FU2rvj/PNinNjG4iIRHq68WFh31wT4pVe2oJ?=
 =?us-ascii?Q?ozthDWrO+eML4SoyxxozxYBpYZBK1Wg8z1V7si/K/7Bc90r72GnPrDco8pxY?=
 =?us-ascii?Q?Uj7cJYB3m5WE/9rF1xBJBCzA82wotsZLsF9YcqjAw0/XTGkpL9EAqMmKT/4I?=
 =?us-ascii?Q?ZIYxzORhJL5ac1jAuqhPSmB/6nB44Gg6XiyhW8BpsqZBLcyydqsg6mUi5dwV?=
 =?us-ascii?Q?Dwr7mdEfzQNq4PEx/h01a0X5vinX/G6+c4SOiZ8ZNTxuWnHe76JoKBpHRlG5?=
 =?us-ascii?Q?Meiv95i2Hrk22zf4o54CpVQDEUiE5zsjQ7EBCLM0z9m7rOK+4SFKYQDpM/NW?=
 =?us-ascii?Q?GKrDh6KAvSy3/6ntXol1UQxqOzeXoG2E2d2ijt8I5OFoBc3L+pNPaK5c/28H?=
 =?us-ascii?Q?+vN8293UYhLBkmD6O5DpnCIsSiTwauqLJQqztRf5q3nUGvdbZG3WonrWwFGX?=
 =?us-ascii?Q?rHa1SwbhsG0iIFEUo3pJdIUn72NUwvHMuO8qLV1B/ccmcMq/M6TT26IF59fV?=
 =?us-ascii?Q?qg7AObjLKPnDaKCfKmY4ZcudLTRbSuQi5M+gVLCGNmohupRHX3jhLBGjRLJb?=
 =?us-ascii?Q?VGcdIkL6ZTjQokIDx2iuYriO6TYkRfgRPkWn310Ejy98qz85i8I9gnG6YPBZ?=
 =?us-ascii?Q?Np6QgPnfmX+3V591AF8qaRrWBSOUI8fWKCZrTQ1VwL0PQiwxeL0R9EMy5hEb?=
 =?us-ascii?Q?hOxDUkdZtEesFA9/ymsR0BuLPUz3UTnjI6NY/h7+uUamH8EbGaMNMt9keYPU?=
 =?us-ascii?Q?lI1QGJzLRtnOfL4xn0XMGWBZuDFNMp1zMHLphjedW4EZOdSWMOcplnu2fmqT?=
 =?us-ascii?Q?NpMN44NYIc5beMJ7GZE6m9r03xLLbwuqiHb/ptO7MLn2RATAR53pzPwPxFKj?=
 =?us-ascii?Q?9Wr6UinpqQoWgrJm3qKCNIqpQB5wvImXAdDwV8w+BZDOr2O04Tu2b87xvzBF?=
 =?us-ascii?Q?lCwN4Jy08OzPzsIsw9gCKh6Gnd3KDhzCRwW0fFiLWP2NJKfEkhSjxKck2LKZ?=
 =?us-ascii?Q?W1auy1nytGucZomQo0JmM7RsHK/f2JoiGkn6Sbgdhsf80rFkQOXAwngsrdfl?=
 =?us-ascii?Q?jLVPzKE7Ehd8ulWrHK6kXx5zqN35eVpyD7WJifPW9Ta3ULULebVATEs1hZ2V?=
 =?us-ascii?Q?Gvi+WPgPbX6dGS5sDLlGqCMu/g54Vse444br4lWLBLuAGDcA2MCIvHknPc1M?=
 =?us-ascii?Q?f0ocnlkre8fFFHANKwWbtQkYqkclwM4LRUnktLNzHyAQPu9WhvkvzR2YsLkL?=
 =?us-ascii?Q?/fFOdKTTOnyVQbju1EfONf9/SCZNxDQSjqytYH5pbQ1oq+bcEFTdNRSf+jIt?=
 =?us-ascii?Q?ytzbWggl0VhiX95vZ5vXdNs/7razgzwJG6FILStd9ng6SvrCmKiP2KcrFOYy?=
 =?us-ascii?Q?B9/NcQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58aa4a18-fa6f-4996-46b1-08db5c38b0e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 09:24:35.9895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNs2Z1UNwv3f4/YlkUp7HQKoYyQ+QHYG8bfTTpi1hkfOox/HZlm3c2UpNp6Ace7tB4UY2MZIQwDz+pjxq4c68F510F5U3bf+43Sk0BIgSmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4425
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 02:53:45PM -0700, Justin Chen wrote:
> Add mdio compat string for ASP 2.0 ethernet driver.
> 
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> Signed-off-by: Justin Chen <justin.chen@broadcom.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



