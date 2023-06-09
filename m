Return-Path: <netdev+bounces-9697-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FEAE72A41A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:09:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B4BF2819E4
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A627C21CE6;
	Fri,  9 Jun 2023 20:09:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937E218C34
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:09:07 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5521B9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:09:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YT7FP/VUfP6Fh3XIUFgrrScbx02f1HviSJLXMIl+kmlNTzehUDVxR2VcpgziisED6YgaCBGASCFSzVwKI2+OBkrRA6QU4/SNCQ5BZW/00L9DDk4FZPn8+DlTzskf1YRQMgZW4LTZ0w0D79jUNjmuhxggfVwKR9IfO+E9+S1NDKvIB5NzAEFPrQ8ps7NBqZYrBUqK0YscZ0Tu+kdSEdxOMUTFeCpL+3uaTRnUmzJIis/ZlU9FaCWnx1+o2YuFI3gZxohnxXaaqYDUSScssu4o+QJzfBMnG0m412z2q0R8JGdL0olhD/6ubJ+KP1hqrA0S6BlbPGeTR3Reesf8qHsALg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+HMgb6csLetEYsPix5IhJMIpQy8cyPDKxKHOyxAJjQ=;
 b=SoWGWQgCK0TvqEkuswISl3N167cxNr/KQ3wR3A8BHve+OX5tnZaRSrKX4rQh1cRqaVBULNg0Vv/2EyITyRRJSwF3Q/KMWkxMTDTn+DsdjCEMq0JmSUPMkiVsyrbWsT6qyQduSiKO9aZa6NtYx8NbIJ3PIsge4eM/eFBjwd9WoRINV+QJPZ/D1ElmhIm318Hr7orQdegMllxDn3sVHEIQO5rfRpMgrreVKJNlg2w5nwIWDSEozguL0tF8CJqVAXdBtJnZIUIevbRXXp+86USpXOEwdtNnfn3sXmFTCta6XGengBeuDsYsB2w8fVCvlsHVKUiwRHTKKHKUk7QKin0r7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+HMgb6csLetEYsPix5IhJMIpQy8cyPDKxKHOyxAJjQ=;
 b=qlB/NKOR8bgrSY3sz7ENLzF2SFC8pnuiQJoUSDvUqQLbhGspbeSEcaM5mM55JocQkQsTrR7WBeNucSNUHQvDj6XCFz9F+XlXatHR4D5tW+5oWCZ5ArFdg+fReZHOsVMvVTBOgK/cDE3sqwMzlK2xTHrF4GB1wVmJUX4EdARuiTE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4708.namprd13.prod.outlook.com (2603:10b6:208:30e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Fri, 9 Jun
 2023 20:09:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 20:09:03 +0000
Date: Fri, 9 Jun 2023 22:08:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Petr Machata <petrm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
	Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 8/8] mlxsw: spectrum_router: Privatize
 mlxsw_sp_rif_dev()
Message-ID: <ZIOG2CLy0DChO1+P@corigine.com>
References: <cover.1686330238.git.petrm@nvidia.com>
 <1e9aef91a823932bee6114371279d5cf2cddf704.1686330239.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e9aef91a823932bee6114371279d5cf2cddf704.1686330239.git.petrm@nvidia.com>
X-ClientProxiedBy: AM3PR05CA0126.eurprd05.prod.outlook.com
 (2603:10a6:207:2::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4708:EE_
X-MS-Office365-Filtering-Correlation-Id: 588d780e-09fb-438e-29f0-08db69255f11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hQ0OEW/wJTMClslbhMjOWLXg19gEnMPgB61kob3DrAyujUXtSg0XXg/f2K5ms8cxzf96YvM1EH6ODQ7dm4AqxyxjYzcMFKTgr4VK+wvvd+6FRKrDjMl53cvvogkAS7j/SOfpya8+9/W4J6Fl8YvJrKSkBsYOW6xylBg30+NlB/Qemhl9xHHJI7W37o3zCIyWTA5tgNHMzj4X+blofQtnj42WtlMHGjpeV77sqbLhNFEC4oE80kr1YNHv6haOw2Z0bb9KxCiZX+7S/Jo0+p7uvwGEHnzqE5cZg3sL6+mIU1dLVd8sFoTulJJzNa7wUzeCQL4GwWvlEBDzJ/z85w7HFe7GlxDOxJma0UxHXuBxXxpc5Zqd8g4bCDaRANyUWYbREK35vO04F9aEc0Sv5AZhdYkYaI6sEPQPDW+3na6C0p9D5t7/rkGW/eCEC+Bz7ZAb8EA+3o9jcF1AX3zJdYz/1+iGFWTiAQd+soptqCmkz+D0GIsjk34yFsVTjXVEk2hhwpmbzBgl3TiFvHrrM0/TA0FxUoqOlNtx4VwmoF/cqqKVMPdXValmnMY9ajTZ5sS2P3mOXMpOmgR4bDWKPJgeq0lGHamRhGm+8tb+rg5x5H4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(376002)(39830400003)(396003)(451199021)(478600001)(4744005)(2906002)(2616005)(6506007)(6512007)(186003)(86362001)(38100700002)(6486002)(6666004)(5660300002)(8936002)(8676002)(41300700001)(66476007)(4326008)(66556008)(316002)(36756003)(6916009)(66946007)(54906003)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E4o2VrEmnhmXs9O+OIgSZK2uKr6wwNL0tk9/v3vCG/f8EdkVgk0m9KtfEdVe?=
 =?us-ascii?Q?86VciKFWymA5GYwuKPx0/XGQ307+6AxUDd/YvnyvESvMdv4bzjbxkjNnvtdk?=
 =?us-ascii?Q?PlGvQjKvIGzvEM1hLTbrWWciG/XAylkktinbJ+IAq6u4VuZOgFAkqwltBdIa?=
 =?us-ascii?Q?Zy/1QUT4Z++l2Wbz1G8bEYkvXcFcWwrXesSl99X7dyw0OqsyFcK86zN7sn+J?=
 =?us-ascii?Q?9LDYkDH2wnXsqIcHDMNTQAE9eBGoW50SBytyHrMZxzKVOk6PES9kfkUImyQT?=
 =?us-ascii?Q?+XtxsGFKfCoAlA1kSQz1y269gJ77yV4WX68s6Z6CMIMVMM877cVqzKgP5BMD?=
 =?us-ascii?Q?cLeudoytvlXSjb6PcNd896m6U87VV5IGTlvq8cRffTIkIdPu9gEUAqxJB7jq?=
 =?us-ascii?Q?MVGovgyS/yvIhiiv300I83h1jHoCOWYQBBne+kYzscrA3veHog5nRDg7hmOI?=
 =?us-ascii?Q?5awjgmPqyX7Ay/R4W43kNA3Yxi7iG9S/LS9DddCFqRFXClU/QZZz/wTv5v1E?=
 =?us-ascii?Q?m2JQutQPE9Kl6ZyLYgNpBb/JYC/D7Mz28gRvc6YkQseEVzUvSH5zd2oozXPz?=
 =?us-ascii?Q?la7la2n1v3GIeErS8VvqhW23HcafOta+OSANCVyxiXReqAHg83mwJCn+fQ2H?=
 =?us-ascii?Q?x1NXAYwfkZnKp/Z7n6LwygoOw+3GqA76UUPzv6Z43WselTIk/TLBj1c4rfk+?=
 =?us-ascii?Q?za5Yo/mDxgvKjDkbSFPUOqS9R0XMqBOlD5t/UF+MUNwwgcS5x+I5zkSHyBwb?=
 =?us-ascii?Q?BL5wTc4yaukTzQMmQhkLA9ivbernKsFWgM7lBEyP+rvHiFDT+D8WgYurhxCr?=
 =?us-ascii?Q?Gf3UXxH+I/JeyGpoomUfvvkOlw4eKUkup0EVctB3U3RDLJf032kSIkcnpt6h?=
 =?us-ascii?Q?3FN4+htXW8Pxu8M7swEKhWt8DxSj4qUGxDOKF183fpRWPzzWwxBY3+SCjOg9?=
 =?us-ascii?Q?jQYOEu+RtYqjcRUwRbVZsXtAU2Cgv0FbsVaw+w1CiYW54FEUu3a3LOsVeenz?=
 =?us-ascii?Q?1QhYBD07FMkOZkJh42Xkhhw93GmGi3wajTAkuNP/MBs0vK4A4N1Er5l0CEyU?=
 =?us-ascii?Q?qLFs1z/sehAGY56w64igUQaX8e6digOVVYcm1XQsc743HB/EbDpZA42vp7BQ?=
 =?us-ascii?Q?p6YxLQuHhdU1dHsp6vJejYO1RyxnHLo4ypy9itWiCo0UlaahUC587pkFE6ah?=
 =?us-ascii?Q?MwPmbokY6Imnuk2BbEzpeh2OgQ230o5gTCveXeKw0FLYW1Vc/BfVGMKwMx1o?=
 =?us-ascii?Q?k1X3MpK222RacLP5wjhAAGFOu0EkZFuZck6EICSi3XwHDiP/T/hmY98lQh54?=
 =?us-ascii?Q?XBexdDjCDV1bNkbhYZOPFmlTROxv5l9lObEt6pnZqxedN5BB895Fx73hEbku?=
 =?us-ascii?Q?6NtXuDJV3SZ9HHlquy4lxlbbShskXaGAg5QQQOWreUO8fUXf/N03GMOXzYet?=
 =?us-ascii?Q?DHMJuf6w3vrmCbeyWr4//pYQGyiuKXEgysvrDIY/tosw5rcaCPhp5CaQWn2t?=
 =?us-ascii?Q?sO6xcg63QNVmnhaDKOX2qVWj9XSXSuLY4lOX8tYaOwdR8OMaC1Ur7jOTPA88?=
 =?us-ascii?Q?fXyo25A3woz0PUyfAFNbQRxNYlvRMiG7jVE5TeP842Z4u43QCcOEP/rFdIyk?=
 =?us-ascii?Q?Gdapl440fuSkL4p/WJLg4SQZTNcAdCPTkaYCH3RY8t3K289FJzaP8IVtYLjL?=
 =?us-ascii?Q?iMDiVg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588d780e-09fb-438e-29f0-08db69255f11
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 20:09:03.5876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGhOOQjKhWFZGW2YPI1RFfoqL39FqSJz/O8L8NR9rtBGKPiv0ADchU/PQpAPRf5rQ0oDrpR2EEW+5otV5s3ClU/zSBoaEJ4KcZwzngDmqfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4708
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 07:32:13PM +0200, Petr Machata wrote:
> Now that the external users of mlxsw_sp_rif_dev() have been converted in
> the preceding patches, make the function static.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


