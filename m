Return-Path: <netdev+bounces-1723-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E82E6FEFC0
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:14:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD9762816C2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEA451C772;
	Thu, 11 May 2023 10:14:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3201C740
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:14:41 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2102.outbound.protection.outlook.com [40.107.237.102])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59957A8D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:14:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhWXGxLzQt4hsxSaSzrFbd1lQMGIDXtbnGarGIAJ4ul7m5bVl+u59p/BonQTU5Ta5F4gYdzgtl0UCX/tNh+8IIohsy8p1kCfS5oYTfssfGy+/rEEVbSaDkaU16lmssbQUEuV0sYSIddnP/AZfBLg49IIkNCvaE/U0i8O1WQrNk4C7WIrfMmhLDet/IxW28d5+70BIZCFxpwM98bjBvJEHarY/D8hOWooQBw/ckZ8xbQWU3/iEQwWeTZUlIg/YDMZuPWCcqUumHkd7pXIGZfRUZm1zHPtA5Dsx8W/2ceWnSST4TJ0zbgS41xgGtN8pG/QA3+vlUBhK/XFcUm3bDcz3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERR6myRbH5XsZE0pkLGB98SNQEiUMKPTx8MPlqyUlJI=;
 b=PdXzMImh7sdV3hUdt4rB/l6/TyCoDUSzEZQj2ZFOfaOdNTsN3S2ktVP1BcihGjDihxy2kZdV2OgfeFln1zRVrQaRt6Ihcyd0CjI49x73gEP24waTvcXP9OrVRKe8CzMzIhX16eMzRDBvPaYPkNSJVLFUQdYtw5QAZxIZ2NHybHowt0nGvfXYBvSQAuK/KWRixM97qVgOKfIDHdkhlHaJ+1hj22r4UYUAq5QVzzbSTQsOwfUt3yLbnnjnUZrbKLxu38n01zw4SeAZbaB18lYPz067c71a6mz1v5/aITH3mIqVKbqbtHORqI7R8UF3kls5OCFXMEUrAg6XcOjTYlHgRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERR6myRbH5XsZE0pkLGB98SNQEiUMKPTx8MPlqyUlJI=;
 b=pMF4DW4w0066HocPssY2lUNd8e/jRFDBHFixOClCAf9J7dkbsHdJ5UaKoj8AQLhsfUkLNTngsIfS8UUqHch58dgrP1/59CW46pgcsQhqfqm0giFolNmJzF9SQ/xN3qIRCYx+ffNw2Gifd3cY/AffGJlwtU9wrYU9tO4e5JrBwtQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3848.namprd13.prod.outlook.com (2603:10b6:610:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 10:14:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:14:37 +0000
Date: Thu, 11 May 2023 12:14:30 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 6/7] net: sfp: add support for setting
 signalling rate
Message-ID: <ZFzABhD5MYHA2Mjp@corigine.com>
References: <ZFt+i+E8aUmUx4zd@shell.armlinux.org.uk>
 <E1pwhv4-001Xoa-BB@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pwhv4-001Xoa-BB@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AS4P189CA0022.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3848:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ce38eb6-f4c7-4cc0-7920-08db52088663
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	izsbMrmC2bA1sAHGNwq8udhcerZypOL75YeR0VrDOh8HBAE0y6qY4M3Hre9C4IJ3C5604VROm8QPydYdQylXWihr3U5laM7J9QTsnLxQLkj66dBgUCl5j6TQ6Cnwz6RZnd+1SsoRuBE+Bdxkd/u7ROwkmccFJetH0HwK43L3qZLih9/4yCPnWRkOJ6N8BK/8MM9/njEhEbe81Vgeq3Pq5TEIT+PAkOz4+kVXTBmXQEyH3+ivdcRhV/ujOI11l4avK4gdGioAfayf4mCK4lj1jBYrIThQipKGiv1AY/LtUpQpIlaBpr25ThXk185n9sEhnZ2Vri5Lei/NAvFUxgmf0t5/nM/Dntn7nk+PG9kIRnJsxqQyGg1sVHHn3UmCq2utW0wl/BWEiYHr7kysqIirr12vLur2uVs1bjHayQAeKhjIrC2TtX0kaMEEuwvb9oKCFfFpAiev6xQzbPeoHGh1aOg1EQ3CPPqwL4+7DHD5PpWyFvl1n93KRFLcvWugXKmniCK+CRWB8MFK1wN3bWV96bsvFz852eA/2WUh79Wy5PH77bD71AW3V81ic7LZAaIy
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(376002)(136003)(346002)(366004)(451199021)(8676002)(8936002)(54906003)(316002)(6666004)(66946007)(4744005)(4326008)(2616005)(6486002)(44832011)(5660300002)(66556008)(478600001)(66476007)(2906002)(86362001)(186003)(6512007)(6506007)(36756003)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NOoH7NwmPl0VjXOeMwndPLlNUvu+R4y7zVZEZUM3bghWNLFqkzWhgSim3oJa?=
 =?us-ascii?Q?ikguL2LJLzao65/HDZsegNU/BotVdPFSTGA7YpkLIE+o2bzpS0jtEr5g8A3g?=
 =?us-ascii?Q?Y9dotR3E9RFmy7C2e2vyuf3ucy4XWVYeWnOsP53rBIDGu9bSaWfmYq/bM9Wv?=
 =?us-ascii?Q?OMhCF9hjwpEkUpb9WuAbhWI1ebSTQkCQoIQUyWGbalKKbtSqo2X7PagtXcCa?=
 =?us-ascii?Q?J0PI4uxjXdEP60nEI/2eKvFpo/8gs5c4hh7uOK1ZczY9hWmaWesoJhFnMJwb?=
 =?us-ascii?Q?gz1EXLez3t99Pj8OtOps+VLOGG+2vVyE/c5KFNk9uz7rLT5QqwryHzS1LIT2?=
 =?us-ascii?Q?VdEoRzNTW1vwfcFwwxOkE4OjRqPPOp5VflOIJY49bIO8SJMCT11nlNAgiBTY?=
 =?us-ascii?Q?3nPchCinBs1XVEOq6fI8zkTqar9/Th5oYtKMlF7q+GktW6Zhs+3EiCuZ4jfN?=
 =?us-ascii?Q?dS5YHGHHm0CPt1odgYOFCMg2/KI4sOw91zuLniaTjty3wQpT3qA+yhGEAhlp?=
 =?us-ascii?Q?CnBbtgPaSooCisp7kEF2XRsCLzz+noDRp6KfDhZ6/HNagKzVIRKbF19hjoQ5?=
 =?us-ascii?Q?lLU3dinl6VR4mwhPckvdeXJj/mBxQD5kgA79KebsdZR0IOBB41luw/86WvHj?=
 =?us-ascii?Q?3xOHMVQ5YwOxVIy6PqB2VwU3opA6loUWOTwkhmAaJ7/iXtAWD0zXtY9LNLMy?=
 =?us-ascii?Q?e1vKc42rIv7ZJUjfo2oDMnVGNxulqyC+cFHhIDbCtwPjCy4SqK/DAKxhWJ1j?=
 =?us-ascii?Q?4TwjQwMl0/wY8NcPak0z5zzI2A6VvNI9M/dMPX+eTQ2PWZK0ZenWhlAuiOtZ?=
 =?us-ascii?Q?5x/6GL7S0T0Z0CsGJmRrqIAsFeOGdkozjAJgRzycD4267E8XnhcB2VFa9W8J?=
 =?us-ascii?Q?XdgXYxlVmF05SRvYK9ANKiQ7/oX4zqrX4ekxe+nDTlZ2F8RA53jGO/eoETvg?=
 =?us-ascii?Q?klCv0ZLaBEwi2VTryA2DlYGdSAsn7Rg9nO+nl1tSWf7Wv+w83J6X5aPywvV/?=
 =?us-ascii?Q?COPZsRJl7tOSfmFJEDsEHVNgmEqAXju0iEaMbvWQqIbYEiDRJjqFlNhZZqpg?=
 =?us-ascii?Q?WZlT5GpjrHF06goYcmBGuLFQ+cZH57CnaFZjeid4Y5x3smjrFEDxSqYtY70C?=
 =?us-ascii?Q?XDwdnTotrgx9Mu5fcI3aS1qOF5thX7L+2QI2ZOhcpQ4IeuM0SG3xSBauR+4Y?=
 =?us-ascii?Q?gfYqrplrmgGH2KyWmE6J/5a1Jvs4xZ0RB0i4lKPoAjdKsO85JJakQyHM7DKB?=
 =?us-ascii?Q?wZfnOHXxBO9q1OYLZ/fmiSwyNm8QgLD2/cDwwZfCQOvD63F0lyBcQWOiMQsl?=
 =?us-ascii?Q?RC7vf2dCkGZ+MuawwnjPF4+4kb9HXPca2kl/aqNoSopp9xDgof8p0nxO7f9c?=
 =?us-ascii?Q?F56Q177bPz/yTYPRo2S4E1aIEq3E0DI8e9ZuRQBl4lgb4i9NgbuYhvH1P+eV?=
 =?us-ascii?Q?MWk/vplPhAvsXrgetCzruLK0vRCG0cwcq6MGIDi/GFwM6om0SmBF/CpHDwxI?=
 =?us-ascii?Q?CK9+YtWUi1BMbyJLucEE4JaFb/+j1EHjgs4vr/2h1HZEkGhEeQ/x0qa0+Ksz?=
 =?us-ascii?Q?hq0uYarUR7ojTP4lY+yQS3/zzZHb+rrLA2PWFS9mWzW0zTqTJvhHSCwGD1B9?=
 =?us-ascii?Q?uzq6pROd+LOzHzuxlIAp1gRXC3MjmH9owN85iIC9YZFpsJFkYBilkHmPFMmE?=
 =?us-ascii?Q?ogQV9g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ce38eb6-f4c7-4cc0-7920-08db52088663
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:14:37.2470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v/lxKvnUNcDcCP7jNlyIKwSbyL6K3g863RwYhDECvEcKzzE1yzLoOpzEWfI4Q7XFiiZwlCaMDZWgjMwC5zmoYmTWPB9A5gYdahAsuRYPfP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 12:23:42PM +0100, Russell King (Oracle) wrote:
> Add support to the SFP layer to allow phylink to set the signalling
> rate for a SFP module. The rate given will be in units of kilo-baud
> (1000 baud).
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


