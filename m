Return-Path: <netdev+bounces-9202-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65EF1727EEA
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:37:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B10561C20E9D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E1531118A;
	Thu,  8 Jun 2023 11:37:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812B463CF
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:37:37 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2110.outbound.protection.outlook.com [40.107.243.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C724E6C;
	Thu,  8 Jun 2023 04:37:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ea0Uj6ZEIdxlQqdh/vEok9M1hadpsULhaSRfcWtx8CAJln4Pw3kVjlx4rDHz69HJGXDdWeqdxlZELkik8OTYhLEoqltgTCoR3ujPfQAFn9Kzn8VMxRlh+JHcI9pB/yfU0ADaW/IQNTqr5vYKaLAfODgwMuaWJCzRBSIBVkj3RW0UAqGmG/hNSJ0MG3T7twHSWYDVCxSMPQS0D3D9anB9sFK+Z3BDTPth+SbB0mDpdG485i+pNVGctaIwQh1GYL/Wnyr+cMsxHik7EvCKM53rMbbEzeZ7BbrQSIftoWy/uZnNkbZM0jDVmJRlmxFXJNirJU5AeToqhA9RzMDKEfbn2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2bx9hZzO4UlsU1jHQzeqvRcfBQSurbN4r8TB98GS3k=;
 b=Y4iVrfrvccPmtFA7xCS1Vs6o0ZTc3Dn9j7hscjpi3KsdmwTws514Ta86nhB6SPvW+QeeQtigM55pGgJjR3IzIA3ZLn3cEIzTH/pld9CjkSjVZpPoKrJIcmkgfWazd1jK71uiVA+u9q/G+tcJmhQZKDYhR1Uiw61hA3qkN1i9H3Tnz/uVQRkQBDkr1JMbKCR+BTcYDYpgUCAO6fJpX4eRI1GGzSlAqCphGfZfOGqFRLHFD3ouQalBwef3VMPPwbl4sm+OCkcclkw9KCXdeEdW07Wmr4jn5s/COnmRQkQ03oZF7tlL6rKzYbfKJYEGPGjUQw+G7AU+fwdTCdhU7QsiyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2bx9hZzO4UlsU1jHQzeqvRcfBQSurbN4r8TB98GS3k=;
 b=fPNhF75Mv7MiY2yagwNyuHW2bMbq0x7cyzDq4f+Ty2icDBof71R7JXL3TBdKWGaa30l1nT1WtjQzcQQrEJDggxaBZYeKJGAO1Wke5QqYY8rh6wmlz32u0O8OCBGCEpVpDrAYASItQhi8f8EZWuRjhi7pG+2kAcGP0smS6ofUoV4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3623.namprd13.prod.outlook.com (2603:10b6:610:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Thu, 8 Jun
 2023 11:37:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 11:37:34 +0000
Date: Thu, 8 Jun 2023 13:37:27 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: phy: broadcom: Add support for setting LED
 brightness
Message-ID: <ZIG9d+nT64f93F8Y@corigine.com>
References: <20230607183453.2587726-1-florian.fainelli@broadcom.com>
 <20230607183453.2587726-3-florian.fainelli@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607183453.2587726-3-florian.fainelli@broadcom.com>
X-ClientProxiedBy: AM4PR0302CA0005.eurprd03.prod.outlook.com
 (2603:10a6:205:2::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3623:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ab073cd-eb0a-4ebe-c322-08db6814c0ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YoaYG4A6aPzQfBF1rSTfUFGxh5HODZQqP7UyhYhfTCRIiyi8bpAMHb1ou0K13t1besMNTN/oXK/lOAWT/J7qhnEfZJrj2Z36qFYtH1YS2y7WenedCOR6W0D43HPtBYWBZpOartSrW2nqQslzcboXw16DGHNGqrCfCbLCCkB3AWXIKCoZ1wmp//O5EOC+H2ShiOtm7MceTsByxw7bLzRFAZHeNJlIPwGW3r7ReP+HI72MNpspiSkoVoVe2Q25Ok2ZXoiRUHhjST5fN3Dk6f1oGERDStqC1E1ViE1xQY/3mPhsgvQmp1Pu86WWskhOLdgIQ09NbvxxpO18kljNFjFIvI2pL84S1lUxYJ+GkmIhotBiDCZy/nMnwm13gRLuTlLFvZO3ch1L48Q8UELy7FmG0iptC08egTAdDSUwTnL94K+FCdNdiQbVpuDb34eVbC110dpScjDuiGMQRvhRmxVS3IEvksnJ0DvEj65NvVH/pgulZdsaZGtmh2gx7UrEX89zDDsJUHZbdzdJMIdZkrGvvmVr1dESRp5fJaxQ3FtyQpvaiTWAyMlBfe1RK7Ptt6/UscheGXUJKFbcoufHQn0RBPtv0j1XbevQGcITlPveHUM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(366004)(396003)(346002)(39840400004)(451199021)(86362001)(36756003)(66556008)(54906003)(478600001)(6916009)(4326008)(316002)(66946007)(66476007)(6666004)(6486002)(8936002)(8676002)(41300700001)(5660300002)(4744005)(2906002)(7416002)(44832011)(38100700002)(2616005)(6512007)(6506007)(186003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xGzPJBHWdc1hjj7xnvcLwtNLLp4pfdeNPGk4PAJDPl5qTjhz7arM486g8aRQ?=
 =?us-ascii?Q?j4spOtsGWMTvFO6U0hkpUACgfgXCF+kHrvHPQg+1aPIEYFRHIj9DZGRbfnXi?=
 =?us-ascii?Q?qBgUTb3du891021ZhC+AlCfteWcUH/u5h63wRhvG5z6WJDr08Hx+84m62vyu?=
 =?us-ascii?Q?hiL3ZnVcXnsQ5Xesw45MByFfl6d4SZnh1GhCGDqS4UC516r8rOFh5+5J1CeJ?=
 =?us-ascii?Q?nqCI+gQc/ja7UbIXVYssyMg5LG+ZRv5biqY1fr/iN6s2u1rLvyGuKTAKNXbh?=
 =?us-ascii?Q?OcZwjwgvzhvhLzLJvM0bSXH6Y1tdXFV/TBMV7zhMSkEX7ijHuVKwpb3r6cL7?=
 =?us-ascii?Q?U61MjdOOHZwkRobWPc1fJVGEiqEmQml8PprdmG7P029Ib+wNxKqwhAZERVyf?=
 =?us-ascii?Q?ACREWABqnmfY5iho75omw4GViY5FiM5SwhAnnYUhREJhPhsVnSBzoyiIY1EX?=
 =?us-ascii?Q?O0IBxOzOnFnRtsjvIQdo9pNSAOnurut3tomNVKUd7+xs34vs+ghZAY9OSuDV?=
 =?us-ascii?Q?nRJGrRptYVLsN3ep1tRHDP54HgD3DCnSuCQ9M8BkksE5ld6waqjPw6I8g0m4?=
 =?us-ascii?Q?yZwhPOsIZuaJODxDDy9IU1yOH4pkovw/7ILADlNocCr3A5lkqk+4uLPsUk5H?=
 =?us-ascii?Q?8YYfvRk0fO8V1tJh52pnjCvgSn3h8+oH6pynlG2RXSOcOGBC3D66NlbzPDfW?=
 =?us-ascii?Q?KENXKEiHt8/e6xsioOJaXtwGvBTlJUF0InKp7BXXmT6vnWBlSTE9I5UOnFah?=
 =?us-ascii?Q?MvEG9hWvphlhwPlUGUM1whfDqGFN2OUzhbZT+bYqRMXH80463ZG2k/P0gqUe?=
 =?us-ascii?Q?M0xj1JMGH0knpJ2U/sT0ItNpo/GY8GbGXfNhcqNNy19Xcvq0DUjEcvkmN6JE?=
 =?us-ascii?Q?sQvLe3fYHiIvIpP3lBHAr79/+HuIbPqBVVphZ1AHh61DMg2gv+g5aEV6em67?=
 =?us-ascii?Q?0iO2gmN75KLl3QWVQXtCqCE/ARcWWBj6CyMns1C6mwrUL3JflP/7nJfopSvV?=
 =?us-ascii?Q?wTqBYqUgVtz9zYih8KG/E4JWShEEkhm9lc5sk51/6b0kmLP8vdxkhJBQdihK?=
 =?us-ascii?Q?2XXSW2Ci6etSjj0pAJZ+a6f18P+T6levr5LyuS2toohYq8cEAcmboS1Tvmrx?=
 =?us-ascii?Q?pXqyhIvfC8JXLuacc0zvmxFplAva4NsnY5MQLq5a6+zSEqi5IQdI8DF5D7aT?=
 =?us-ascii?Q?JBp0UrndfC7PTFSRU+Ga6xkHxSeCjsWhg7SUjVOuu8YQM3kYwNOvZL7Gz0/u?=
 =?us-ascii?Q?VvKC5U9ohbBoJ6Gv9F2fKBKztQrX4+93YD7UrtD6jeQwP/5khUUka2ROr7f9?=
 =?us-ascii?Q?WN66rebHwgwaJUpa3Glzv5g84KRMHJIL6UsXrlEtGJKUacmOmEg9YBXcEeyS?=
 =?us-ascii?Q?PZs73/IF3F6SnvnybJptHbdcekCoOup4IqbJKtfq3bmCrx45AT+sJOLfHP0B?=
 =?us-ascii?Q?fp59fAA1NKf5YccnbttvfU3zdotYz9J5maVE9GMEcWoVVGh7m26QHcRZVsu0?=
 =?us-ascii?Q?k1dNmzQe+YjBZ6pfxyci3pbgzsMLOrVoIFDeZY+AAh/3l5hxfCNMRtffVtsc?=
 =?us-ascii?Q?CETE5DZrcWlAZbr356kgMC+lsB+Klgy8Hncdws61SSduwFyzKfSGoWDPyfvW?=
 =?us-ascii?Q?vCDAx4fBRNub5NXy82ELwv/jp4L+0Sth5S6z6bu+BDq+ZVH+alvTqiVOfpC6?=
 =?us-ascii?Q?yzewyg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ab073cd-eb0a-4ebe-c322-08db6814c0ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 11:37:34.5521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xsPAWtNFh8Ax/y0sMQ55GLwgbhUwENcGFg3zf1oLDlFpxmdAxOiAiuVOr/DjKWfdACfwno9gZvaP21bwJTQHTRWnAMCtyGkXRgLz3UafUFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3623
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 11:34:53AM -0700, Florian Fainelli wrote:
> Broadcom PHYs have two LEDs selector registers which allow us to control
> the LED assignment, including how to turn them on/off.
> 
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



