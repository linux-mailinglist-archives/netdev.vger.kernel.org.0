Return-Path: <netdev+bounces-11068-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B406A7316BD
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:34:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6842528170B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1215F125B1;
	Thu, 15 Jun 2023 11:34:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0441E12B67
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:34:50 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2111.outbound.protection.outlook.com [40.107.102.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6236ED
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:34:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGx6dJXCBoJaU/+OqkQCFb9/QXhv4mW5L8vw/O7o+YAXknCnifvLBJE+9RgBcnDnTPD0qNKuo+wCBxYZqzI0r2k7UF0xmEpx5Z4R1qvRJuCHeS4RF6scbcImRpiMfM5G5GMx9/9KdmeSYQUnGC109jDKxslc9EVs2IDt1zCqn/KxISHTowoqIoGeerNGqeCe9JFrZ0MC9eMoIsaG89/3lnfqlc4TQT0lzURDy4E0Cf9UHLawNGXjzV5sHHMFddyQ70H2mJoq9Uul2oCFL7lRyvqMZqZH46QyCLlRLOhras7vefbFHgGnveG4uP7RDyx4xN70F5ZP3z4A2SVVsmvz5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YHFfCanPKi1Cf2VFEG1yz0UvZs3j/9mzKLoho5SUCQo=;
 b=jqQZo9yaHZGx7f0X2vJUiwcYDuSlGN2lbGBeA508dbn+DhuEWecFyrDVAoGyNAvi+IHD8gy1JgrRNndjnmAeEQJcdQnw4s85M5rhD8IItV2K1lonBV0w5TkmzdyRJ9jyYA8aVqimLVGa0ZT3ZziaZz9HqtLa12pW5jlHzl1hN5Rj4VV2ywF861v+N2rCylVbx6JNMVbc1tL50O75HF/lQlG1RrjVmX+p0LEHytE0uFe9BkeAh45V99EVy5Jqf/8VMa+hOwSVANTg6Pt3h1a3ED6DLFZ6dTmCKN7jgduVg/qLHtPVNYoLYCSunmz1aCPFHSJUXuUbzUfY6rQvdbD84Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YHFfCanPKi1Cf2VFEG1yz0UvZs3j/9mzKLoho5SUCQo=;
 b=AMKqO0SxfBn54L9JRpPOXwe63fDnZ1xkhnGR5GBkz5nnQCHKhc5vCN+ZVwyzAwoIEx4ykxSEDJbjwM4DkivBWGt+ZE05XV9wvbyOlzNUEEP0cYAqpsk2E4offiUoI+a/RWbvpSjaGDkJ5pSlQLSaLEPyIdJOXksDjB7WMY0PTZ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6267.namprd13.prod.outlook.com (2603:10b6:510:24e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Thu, 15 Jun
 2023 11:34:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 11:34:47 +0000
Date: Thu, 15 Jun 2023 13:34:40 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
Cc: netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	przemyslaw.kitszel@intel.com, michal.swiatkowski@linux.intel.com,
	pmenzel@molgen.mpg.de, kuba@kernel.org,
	maciej.fijalkowski@intel.com, anthony.l.nguyen@intel.com,
	aleksander.lobakin@intel.com
Subject: Re: [PATCH net-next v3 2/3] i40e: remove unnecessary check for old
 MAC == new MAC
Message-ID: <ZIr3UGQv37C317VC@corigine.com>
References: <20230614145302.902301-1-piotrx.gardocki@intel.com>
 <20230614145302.902301-3-piotrx.gardocki@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614145302.902301-3-piotrx.gardocki@intel.com>
X-ClientProxiedBy: AM3PR05CA0099.eurprd05.prod.outlook.com
 (2603:10a6:207:1::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6267:EE_
X-MS-Office365-Filtering-Correlation-Id: b3cc5e6b-626c-46b3-eb2d-08db6d9485c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NwcgN8C9kwuzzfvwUvc+Sd88FiN7aQ3ow/uuhGdW0TGQG7E5Y9pARCk3nDbfC0W2Uq1bO3vcm8O3owkMhFuypaypTn8e1DfwOMR+SecKTwztERqk6hUpQUcCt7s5qsyyGmYR4cDemyVAMuixiz/zDh5Cv2+GmXrAIWf/RPoZB8MSoWaBdw++w6DpjV4kPL2s4xOMh7yCwCQ5CpFVSXT1qhaHDB7duLS8O+t+SnIRYn0jbXWAxGGTER3eKex+qCaOom5AsftMw804M5m4V76vLJ6h8b+x1zLG15UYAb750T8h/gSEW2dDd20ytCXqcc0SDECefbGQ+QtBIsp3r8ckTa5nFDPj6EuL2/1aBlkMiBL1UzZ8Z7Ky/IUGGC40OlaKPdsP1XtNEvUuAgSmrl25CC8ZB3w6oxhLnPPEYSrZMV3Jba2TB4GX794VRxbHw9/DvT5/sgnAzE2bQlEyxf4lK49xzTtt6Lng4EVt0c2YflAtVEjNTe/jDPm22PA9qORXVDz2agie8VtsyuUCENEnU9xFCOeucGBr2B7IU3LTGa03yHFlMw/rC2L/HK7pNn8E+yiRcjGGjLGdIpaCRZkQQvaZRQPrbJL52Oftfba90es=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(396003)(366004)(376002)(451199021)(66476007)(478600001)(66556008)(6916009)(316002)(66946007)(4326008)(2616005)(86362001)(6666004)(36756003)(6512007)(186003)(6506007)(6486002)(5660300002)(44832011)(7416002)(8676002)(8936002)(4744005)(41300700001)(2906002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VAqchk/u1MKhE3jk9LsSBW1FQmoMxb6Gr9JLBoSCzry+V20z7IQ1pEb117zF?=
 =?us-ascii?Q?ErpwZnOWYcSXQJ5luX8IFH1/E2sKaqAKiTQ6T0pwITkS4FYx+9nLyP+VfUr1?=
 =?us-ascii?Q?9X2YRY4gt3QZ0U28Ft1orxhLa1bFuNxXhNKxVVZg+V+kqkw7meoF1DMPWAZj?=
 =?us-ascii?Q?AEKu8GxKIpCqpDKNLTJR2EOWBj2vdLockvOZlJMbS/u0KPLB5BgKPp6dVRj0?=
 =?us-ascii?Q?9gFLGMPCqIi+l2LuzAqkhkREUn18x0FmwuU14YCatIOaGbk0trgtLe9CzayJ?=
 =?us-ascii?Q?82dic+XCY+JHsMHlMo5jT27SHcd/NCPPunwizubPaDWmHHgVxRO5azOmXaWM?=
 =?us-ascii?Q?Uke10A+8CjcM78ANsobOaCGMt7+mSGBifOzKDlptBtX3vpdXSrXqXyHwlw6B?=
 =?us-ascii?Q?dORBOqKm+1tAnlFTApURM8tr5Gh9rgePb5iilBiaL17zq4Fevbt2jFGYCnDD?=
 =?us-ascii?Q?FeyFswwSepbKqg9p57wVSRGu+BoJcYOtkKAPmHzY1yxpaW37uhHjTvzZOKvy?=
 =?us-ascii?Q?8yuApmQeydqcPdSrD/68upKOGtdnN3tAU2CcTq/n5O1IbBT+Al+M+ZRDTK76?=
 =?us-ascii?Q?AbDN/P5YueuKoXOMqJfZQTwlUxkqb3NaLKsyJf5MxlEGMo1ePzLPH0Z6h6EZ?=
 =?us-ascii?Q?LzU65gy0XoVy9dX4u7mZfQ3+2Kyr9e6N6O8HZciVwlBAKFgffxp4Z2PoMxyc?=
 =?us-ascii?Q?FwPEQHe25tzdZOgTR5gzw3e5Wl2eWIujnuP9B3yYX4Bbt4kCSn7Gar+Qoz2Q?=
 =?us-ascii?Q?U1Y4qgV34c1WT1urHdmn6GRFHFhsvKGUxbwRFeb9bDup1hQEO8j+rKYsAewE?=
 =?us-ascii?Q?oI5QLLuUhBjjsjvysg7F/FNuX/4o3bkm+YlAJjMKdk2Hl5AdY+YqqUE1IcMB?=
 =?us-ascii?Q?+euFY10AbwlbkNliG0IwhrsjpyDwurciaW8QMVfWaR2MXMqA4f2+Qtj69uIM?=
 =?us-ascii?Q?L/vTpzpFhrvsKVvVDH08LmXM3dPwG3vtk2FgNSLDbI1/2InRNRPjkolRsPLV?=
 =?us-ascii?Q?hOj+lp7rxIcxQKr3PYef9EqCcXhcO/S4fqi8J4PDmBPI6V7yidfq779pJhcc?=
 =?us-ascii?Q?bczgNkPayKhsCmpcC23NGWs96RyKMoVkUMiMbqMrb9qDU/Dw/xhYXiBv7RTX?=
 =?us-ascii?Q?v19eDMPZZSHgpnm0zNHwLakeOs9iyJophWpU8aeHyTBSTQvBH/x+eiA661IW?=
 =?us-ascii?Q?HVdHFxs4AcugTD7z3DCO4kP7nVtVqEGl3xCpUtQfy6fSpALiVdbaNO5FoKq3?=
 =?us-ascii?Q?b7qQgYVl0LvySVvO/Kjyg9SFGZILSbRQXk8guYbHFNau62RgfjBOfQ3oyqve?=
 =?us-ascii?Q?K3n0NvZdlmmDMLqUW60UW3RSi+wghZVASrG1/O89j3yBKdC0sCbukuCz/PTq?=
 =?us-ascii?Q?xgdO1KpVh8SGDMXciZ3G+U0bglaJ56ys10oXzIrwq+y8bOGf2BWLz5Wr6GtN?=
 =?us-ascii?Q?sANNpZ5heiXNhsQ3dm1Saeh3k/mJ67zlfMxMXWUMpTWX9nIxnIoHGiIpe3bm?=
 =?us-ascii?Q?11jCXNh/oIYLLIKkxKeJOOO7Oa/ZpZLAUSGTLABTZnNq80Tdi8UoklV8iaIn?=
 =?us-ascii?Q?nwzdJAKZGS8XgVXeanYtpWbHnJntFsf3AMkP7aLrn2jfHKYteQx7ifY38aww?=
 =?us-ascii?Q?Hxv5rEkXC4PeacNU++KWMcyAtUjBD+O6k/5o4LAz9L9Im5+EfG30mda444/y?=
 =?us-ascii?Q?wpmumQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3cc5e6b-626c-46b3-eb2d-08db6d9485c9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 11:34:47.1347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2DlzngS3+M4bfm3tIe+EfzN+gzTI847gY/XkvER/szZBqyoLWgyJ4dFGW5Kp7T9i7EIdd67ABNBepCcNUtZsBoaIMtlufYhAl2NnSf96A0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6267
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 04:53:01PM +0200, Piotr Gardocki wrote:
> The check has been moved to core. The ndo_set_mac_address callback
> is not being called with new MAC address equal to the old one anymore.
> 
> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


