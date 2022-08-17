Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F665973CE
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240973AbiHQQMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240969AbiHQQL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:11:26 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EDB4DF1B;
        Wed, 17 Aug 2022 09:11:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnNjrfZApijrC6wzuRUhJjfV693GX8eHE1NginJ622F3CUHPaszqkncuLIueepyJNa3UO6JZtcGKu9NRB0f+xbsn8iOpW7AvLbuL2poGO5WibGyyLFQhmuyvj83ghLDjTNhkxzR4jL23Ib0i6xkAmdCXIVXxmqqR4q3IdM27qDiDupqyuxTOwAj0BDx95mjGjh41XvlzWZ9tHcnawE5KPA9bQZ8VsL8hAoWvtk+gn0sSYMNDdmkdR5p3/CffoBelcHqwmhFPXoYEKm+We2x8IX7tlM6sEa50pzVzsANt5dDDKaS47X9BsU2hhmDJIH2D8O7W34+br5Y+KYk+tUK5nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0SEeXgUE5N1X4kR0NMLSQ0GDyajbT54Mz0wrHg4Ndw=;
 b=dtzxrPatm+28vVcfWpS/HeycKtFduotaRAYsrqLfKzUpuFwp5BXBiDBxKoSsSdriDH9GF277wxzPjRS0g9wWhJv+Ym/8GS6h2/zhDBTwx1gxwPPTnruW2uoNbwOM7L8Melu5LiaYr09qrI01yTR8fIKJ1tDx1W1GwN9Reo9mt7HBGftkREtIu0JrTMISU9vFJbD5koJM5aPeXPoBhic1XbLsQTGgxa2wBr+c8kWXlmxYqW6vGs7UAmbippp0WEuS4t6bzVpv+0cUv0v/1rahqoB0wkXBJFj6RSUy08lK0i7DC+Ya0Lup+yatEYlpoOHCz6BL1E+/4BegJ51Y6oWl6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0SEeXgUE5N1X4kR0NMLSQ0GDyajbT54Mz0wrHg4Ndw=;
 b=WXH8F1bPezUk5uMXZ+syrP8Qw8xMeoCuseKnOjlM5nkQn2zE2wjb7hrrPZE0TZRDKSlkxZKHq+3DhrstFzpOz9w/JJdqgYB12wAXCWW0yvItsL+6HiP0tlA+TIr4KcCv0cZwH2HEa91nsqXViliZ5k96Pw4YCeUnfv62PpI6Y0z0TWSqNtsZZlgzHh4F2reZyfd2AKZPP/17dJR+RdUXSrIiLAEV2BJacwM86riaN9Eaj85VMfdx47fokyFGfpduld/+4Xme/NWf6EqkFFqcfz3/S9TYq05HAM7fu/BoTtNXtoftVWvKxc9ccC0Fofo8+p9kJESxGGUS5DYIwNlfUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by PH7PR12MB6491.namprd12.prod.outlook.com (2603:10b6:510:1f4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Wed, 17 Aug
 2022 16:11:18 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5504.027; Wed, 17 Aug 2022
 16:11:18 +0000
Date:   Wed, 17 Aug 2022 19:11:12 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>, kuba@kernel.org
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org, vadimp@mellanox.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vadimp@nvidia.com, petrm@nvidia.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v4] Revert "mlxsw: core: Add the hottest thermal zone
 detection"
Message-ID: <Yv0TIH0LsjFJwV0L@shredder>
References: <20220817153040.2464245-1-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817153040.2464245-1-daniel.lezcano@linaro.org>
X-ClientProxiedBy: VI1PR08CA0175.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::29) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 440bf2ed-f120-4d4d-0480-08da806b1deb
X-MS-TrafficTypeDiagnostic: PH7PR12MB6491:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wIEp6xRRzmWMCg8y3Q5rfarpWWsx1D06csLFhuS+1FN9gwUdidQsw7PwLO1gE1mAPwTxaCllQYeqL2G/0Hv7U3NFWkbUMSSfAJi/zNDYcIzYKF4eBeRPIvVBsQuJFOOYHyzZIbE5rjzGfcDLQw+h0vQwp8/4K07RGn8N+nMk0bsxLS21bXYVbcFXsqOq9LEm8uzr/U+X7CmrL6jT7Q5d+cB/D0Drk3fDOfgYO8Fd1ind58CvIXMXhAsz369Ph6ZEDsP61agWeDk7vY2wad0sU2rqsPVYPRI+Ql8IJ5nY3MNU+YIq7piGeiWrpdhzM8JY7hD0/UVGH3xDqVOlMSeGXjJUFgr2VsP06Wpuw9EvtMrezD+qRtJFDEE954PKrGgGKZC6rI2lyG+7N07/JFuR5faE18s9QjT3RwnXWtixGu5UHthDyQ3uo50cJUwSGkvEc+oaDy1TItJy4Wvb7OTmt+aljCJuzchyKlani5iN6WA5JIkZ1jhvPlIO64Ue7myHv9Na1SvqRKtYAHdacbvEfYQ8opf24xN9iZu/0gTpBHF8M7rGuAClen2Ws/ToCCUWKwLC1xJMTCZPA+3cW/PST3CT0SlmkKb4ALmvsK0GnWgcaJNXx7mLz1ze2tXvNm/K6nKXXzkSwfWiZwdE4+w/Wsl/dKF/4Ky81S6lJu0Cyo7raR+XZtsJsWpmcoXsSeqJPm9qhKkjFtalu0aZoKvinxYihBBBzh4pbg96zkGkc9u16mPx7E7L62mzxR2E742rPVdtjtlUv5kFKCO5MTSzEe1DQbxwbO7pYQi1frd+ot3xW5Y1ilEdz2uyqmfjQ+m1XGWTArx/uiRFcfmPTaBh8/93mwdeQ1AbLpBOEN5jUQc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(39860400002)(136003)(376002)(366004)(346002)(83380400001)(186003)(38100700002)(5660300002)(66946007)(8936002)(6486002)(8676002)(33716001)(66476007)(478600001)(4326008)(966005)(2906002)(41300700001)(6512007)(9686003)(6666004)(26005)(66556008)(316002)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eueegQdT8561w8aU9ZTwiwosDh2Ns42Dol4UGNVSZHmnMYV6y3Wwdy6tPcXx?=
 =?us-ascii?Q?9uDsc1mPUVZfvS1xQQQ2MKdaFvonmbwHEZpe56nKjv5bqSfcy34IG/hmu8l1?=
 =?us-ascii?Q?MAdys1kUxawgjlz3HmUjdNm7ujbl0BGpy7muY+ILVJ25z0yHS3V+JjUjgPm4?=
 =?us-ascii?Q?3n1y6nYQ5FH9212jXO2xZ6uHxUwcGlYYFxaxMloLdBol5FaJ3LMU4V2+/L1k?=
 =?us-ascii?Q?Ys4R1AnMAt2CktP3fZtQo/bF5md2YPuFoKMrBIAaSOoeU7PunaRe+nBUPB0f?=
 =?us-ascii?Q?Y+FFMBHVx+SrbKuhgQ8Z2ub6nWy8rXLK5NZe0XRPN3ym5SmHz62pjJFuYk4b?=
 =?us-ascii?Q?3FuVOU71hbD8Hv5c1847DOIsIzcbX5SL+V3zHBg3q9go5nnwkZVrqUDtNdyS?=
 =?us-ascii?Q?Avi5yb8pXN8+clTG/9Gv1P//58chG0W6MvR0v55dkOM6RSFeidXWOIhRigM6?=
 =?us-ascii?Q?fUhI9FGyaKQc/MkQdp4ohUX7xBQQQcKuw+wIjwMGvVUwb+9Q1tDZz17eIQWa?=
 =?us-ascii?Q?E3uPqiew7xliKymnsdjGzUQHasic+s6L13MiRvKJeTwhSp5Hx1ztJ8XHPEU0?=
 =?us-ascii?Q?UXOE81G7SREV/N39ORyFDse/DivRglBpgxrjODGaJ5SMtV92ZFY7KBsBYqyi?=
 =?us-ascii?Q?1gHJ8ruRECamoqqWmJs7qSL3H2piHtvHWu9muWOErvaWTTvwffKa4T2Z+opp?=
 =?us-ascii?Q?Fz8Fk0Bd+446UvGbkmfTWnr8xUInr9Plp5ftrRY/dbEgp5iWKD2LQUDAt+QT?=
 =?us-ascii?Q?8eFqoybwSIhRhLXTPQC5+avYS7LL14jqeTD6MJ2d8xRdRC2ASYKrpY1StCvt?=
 =?us-ascii?Q?C7R0o/y6THI3qmLR98E+SGe68GxCAeMMiAkyPgkH+6ldaIIRIvNAOi+1Dp3U?=
 =?us-ascii?Q?6GW5y4FDFJNYZ53O55ty9zAYnJcRWoVQhSUa/hMu/7+YNOl6JVINDB6xu+ex?=
 =?us-ascii?Q?Th0aljebwpKrxuKJZy51ZjIB242vY41rNVXKYkx0mM5uoQy/LI9/Lr3IcmJm?=
 =?us-ascii?Q?2YfgSpZw9WpKYakisVJ6CSTTC9fUgAFOcoprSXmGTXmP0qXqPFPVK3rq1o7m?=
 =?us-ascii?Q?10WcXn5pkDDB88ImlB+3lQ/URGkA0lia4QwnuVmKhMri+w7mKgaFlbeeL+lY?=
 =?us-ascii?Q?rabMYnXRvzeeBiec8YaZInVkRpZ3HifSmfwxPdC+5/08ppiOge3pZ2FY8IxY?=
 =?us-ascii?Q?HXJ+kTr0x8MMmO4CnMpKEspJ3zesyNKeYS0dS7VIPZI51nXUpkHJJDCETiNL?=
 =?us-ascii?Q?TlDtcqteSmwBYmyGoZikTCZUFlSPnTRhZ1MDU/GMt4UWyp0RjPTZ0fJLRGWu?=
 =?us-ascii?Q?MPe4nQ35sXhYgoWA7Xynl0kdWoltx1t3T1YU6zicvePUDfQI//r/fj4dc6t4?=
 =?us-ascii?Q?btjeqzP4QNan2ybmz/Qb8aUG+M5xh7mGA8kWJ+OzjCsb7teVAmvU10isRF7w?=
 =?us-ascii?Q?QfYlb8W9TmihJX2aaxsiBgAdUPMmm204fV6H3UhPkionuQn0UWaLrkYN6sJy?=
 =?us-ascii?Q?RnOp8lzbQzyasF4oGSabSICH7/AhfsAPSmk3huQ2t8EfBcpXmlLyThdVsrmR?=
 =?us-ascii?Q?vgQd8THdoOCAYQNgvWDTVYYXxUrQHHKU/60h4IaG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 440bf2ed-f120-4d4d-0480-08da806b1deb
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:11:18.0018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t2uw3bwqRnQ01LK8FAWOvwk0TTNdAtBL5RxKWPqfx13F0DnjbXYlI0usPAUKePthfqnIH1IiYDbMQcHd2zIm8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6491
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 05:30:40PM +0200, Daniel Lezcano wrote:
> This reverts commit 2dc2f760052da4925482ecdcdc5c94d4a599153c and
> commit 6f73862fabd93213de157d9cc6ef76084311c628.
> 
> As discussed in the thread:
> 
> https://lore.kernel.org/all/f3c62ebe-7d59-c537-a010-bff366c8aeba@linaro.org/
> 
> the feature provided by commits 2dc2f760052da and 6f73862fabd93 is
> actually already handled by the thermal framework via the cooling
> device state aggregation, thus all this code is pointless.
> 
> The revert conflicts with the following changes:
>  - 7f4957be0d5b8: thermal: Use mode helpers in drivers
>  - 6a79507cfe94c: mlxsw: core: Extend thermal module with per QSFP module thermal zones
> 
> These conflicts were fixed and the resulting changes are in this patch.
> 
> Both reverts are in the same change as requested by Ido Schimmel:
> 
> https://lore.kernel.org/all/Yvz7+RUsmVco3Xpj@shredder/
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Tested-by: Vadim Pasternak <vadimp@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Jakub, Daniel wants to route this patch via his tree. Do you mind?
I spoke with Vadim earlier this week and we do not expect changes to
this file during the current cycle.

Thanks
