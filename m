Return-Path: <netdev+bounces-4763-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7735C70E27D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:56:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E76C81C20DAC
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464311F935;
	Tue, 23 May 2023 16:56:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F25B2069F
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:56:11 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDDDDD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:56:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FM48TA4Q5cPINOrBR0rZAf8W+77YhHtJaYILKOLSJeTb/EQ2Xjz2H+vD02Y+dV1UMsJJGojX3AZwmTQcUXYNu7/6F0ZZN6RnNVNwBXLPDpVhx6PZutARuu783PehPwIwWjRUg0IODKyG/7sV8ARjo2jqST5wgY8Qh/CL95UkpX8jZ/oHpBMK5sJBC2hxr4keJhsDs+zdbJsXNQAWM+uMgRFsXNL9HC1Vrc9vlXzR3J7AtxKiLC6+YgI0lx0lVKulR7S9rhfNJU/65foTY/Jtv6sLr+PszDo0q9qFWDnPRs17Lp1vwlrNG1tYeArxHYPkz+Eg8nXciGaGHX4WilPaDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yd9nf9stIP6yn+VinI8bLPwDr7/SDQlWwlzJ+sQ+Jwk=;
 b=EWjoT636R/jF2dJ/XAFxks9Wyxv+uqcyt/y8VV8DTV2TtlC4hOlu8mYBZYbuj7f2sYZU0ZmzUe1/YXxqsnELfBrtvYMRVfubMmnRSG9J8jQz6mSCJNiNCZYMlZbPnvT5iUbs2YQZisVkh0FqTo00iAFztVJekHTRFPysJ6Gzi+jONZm6uwfTqy0AARznSY5Slzed0q0fnUVTQaBm0gkBSQiQBMUWpJD40NcusowH7oPA6i8t4ztax2DZyokSzeRU62DoqQThbklijO2cDtsPtHQmFIa8fCkWVxmWePc1owIWphsN7R8q6AhK+czQbHgaMBedzldbG1sUqhBs4lKyGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yd9nf9stIP6yn+VinI8bLPwDr7/SDQlWwlzJ+sQ+Jwk=;
 b=N94jTThuGIGYRivLE3locKiFbylJafOI/msGbPPenRPW38AzqPwev9leOSRVT7RGKczJP6awTBKgpwNiKAQtGeMKsFJQzMwxIlASGz0CTLp3w/g0Db3teRhq5NLaHUriNrbsMBB8qOjDqzud1aSSB6W6e5NtcKB1Ee/cvdjB8PV+Pr9b7SGwK21CyraerRH+7UD+2MrCd7Chdy10p4bhu1tA/iqRHFz6oOvXF0+xfFu5umhMhefgi6qSQMxfSRib6m9udVro4xEDvId9L5ww3i791VXO7I8a/hci0EG2eXN3WgRSqNH2mHNePf+3cKBAZDEwkDUhKi74+hwXAt4tXg==
Received: from MW4PR03CA0320.namprd03.prod.outlook.com (2603:10b6:303:dd::25)
 by MW5PR12MB5652.namprd12.prod.outlook.com (2603:10b6:303:1a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 16:56:01 +0000
Received: from CO1NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::36) by MW4PR03CA0320.outlook.office365.com
 (2603:10b6:303:dd::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29 via Frontend
 Transport; Tue, 23 May 2023 16:56:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT086.mail.protection.outlook.com (10.13.175.73) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.29 via Frontend Transport; Tue, 23 May 2023 16:56:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 23 May 2023
 09:55:49 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 23 May
 2023 09:55:47 -0700
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-9-83adc1f93356@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 9/9] man: dcb-app: clean up a few mistakes
Date: Tue, 23 May 2023 18:49:17 +0200
In-Reply-To: <20230510-dcb-rewr-v1-9-83adc1f93356@microchip.com>
Message-ID: <87zg5v3s32.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT086:EE_|MW5PR12MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 636d4538-67f6-4ef6-c91a-08db5bae9704
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+MnfNoaSeLlPu8vIW0srzR9umL8ZWnZlTBd+6HF+Wub8HhkhMzWmpcoPNSRdau4Q2BqkhdvqRGfgI6EFuRAcPgWmhjg+NMnchCXXIruEtvhWdABrP1ZtGRayCzEgGEbE8B+yNI0T5+sNYWYdBS3rEkZJPMla1zlpay/69bgsYncgh15GwnqYASSPYRVP8eas5pXAar6oqbqryypZTgvc8A/bjfQEDOrrcos47iUiYDCbmvkIeX7Xw2Aaoq4j96TLQuW6fI1MUnVPafeSG6DA/S3Vuhflm6XnrUMKGzfax6ciWZWP6a6dbULcDvbrcxN1AZ5Nt2a9hMfXyy2Ex8tRlat2ZfkuY2WFIcZvE0AMfZypcZrDmAS0NcJhXQ6t5DDoo9Yavdgx+7+bqybuMrXd5M18t1p+r6FWvRJ2nW1AaAljaNSeBbJ8vbfd06xXACUcBMkJ5WXtduOBwkdGRZt+4zOcp4gAK3SbBcfJOqmXXxkC1MN13fdzdMHcy8snqf1ULJYFx+UvD/YU1zmaT9mvvTKJSrPgDPsCKBk2e8vVczM7VSrhtVChZKTCHOFSLfq9BAukGpVA1qT6IlKfbWN3x917yMEgehV/MgT+t5rEpME3iOXzwBT9ad5Y9tp5SOl4A+hMfS4rLd6YC2jcM2qoS0+WikDl1qSmqdqwgiMMFiG6A/l7/s1l4oaXgEA79279dFO+s09Gmz40j+q3yxNQNMtk3+YUn2h3oWB4Kd15EW0A9OLXSuN/icj1k2x7fejP
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(336012)(426003)(2616005)(186003)(47076005)(2906002)(83380400001)(16526019)(36860700001)(478600001)(4326008)(6916009)(70206006)(70586007)(41300700001)(6666004)(316002)(54906003)(26005)(5660300002)(8676002)(8936002)(40480700001)(82310400005)(86362001)(82740400003)(7636003)(356005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 16:56:01.7605
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 636d4538-67f6-4ef6-c91a-08db5bae9704
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5652
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> While referencing the dcb-app manpage, I spotted a few mistakes. Lets
> fix them.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  man/man8/dcb-app.8 | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/man/man8/dcb-app.8 b/man/man8/dcb-app.8
> index ecb38591168e..ebec67c90801 100644
> --- a/man/man8/dcb-app.8
> +++ b/man/man8/dcb-app.8
> @@ -1,4 +1,4 @@
> -.TH DCB-ETS 8 "6 December 2020" "iproute2" "Linux"
> +.TH DCB-APP 8 "6 December 2020" "iproute2" "Linux"
>  .SH NAME
>  dcb-app \- show / manipulate application priority table of
>  the DCB (Data Center Bridging) subsystem
> @@ -26,7 +26,7 @@ the DCB (Data Center Bridging) subsystem
>  .RB "[ " pcp-prio " ]"
>  
>  .ti -8
> -.B dcb ets " { " add " | " del " | " replace " } " dev
> +.B dcb app " { " add " | " del " | " replace " } " dev
>  .RI DEV
>  .RB "[ " default-prio " " \fIPRIO-LIST\fB " ]"
>  .RB "[ " ethtype-prio " " \fIET-MAP\fB " ]"
> @@ -106,7 +106,7 @@ individual APP 3-tuples through
>  .B add
>  and
>  .B del
> -commands. On the other other hand, the command
> +commands. On the other hand, the command

Heh, neat typo.

>  .B replace
>  does what one would typically want in this situation--first adds the new
>  configuration, and then removes the obsolete one, so that only one
> @@ -184,7 +184,7 @@ for details. Keys are DSCP points, values are priorities assigned to
>  traffic with matching DSCP. DSCP points can be written either directly as
>  numeric values, or using symbolic names specified in
>  .B /etc/iproute2/rt_dsfield
> -(however note that that file specifies full 8-bit dsfield values, whereas
> +(however note that file specifies full 8-bit dsfield values, whereas

Nope, this one's correct. The first that is a conjunction, the second
one... a pronoun? Not sure.

Maybe make it "note that the file"? It's clear what file we are talking
about and the grating "that that" goes away. Pretty sure it's a
stylistic faux pas.

>  .B dcb app
>  will only use the higher six bits).
>  .B dcb app show
> @@ -230,7 +230,7 @@ priority 4:
>  .P
>  # dcb app replace dev eth0 dscp-prio 24:4
>  .br
> -# dcb app show dev eth0 dscp-prio
> +# dcb app -N show dev eth0 dscp-prio
>  .br
>  dscp-prio 0:0 24:4 48:6


