Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DC460CA23
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiJYKcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiJYKc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:32:29 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3491DBBC8;
        Tue, 25 Oct 2022 03:32:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8VDZVMRre5y1oWRWNeNvlFc02S5JSvyqYe3SUCs3Y2tjLvhJJ4utApAvYHfROZ0rK0XFLnYrtBNNSj/ediuVW1/hDsGldbcEbfvYgamyRR909KmRaHI84LcCHDzgKGey8F9Kc/YgDJgaua/VHpCT3844hAv+rmtmAp7mrjgLtJ/yq8wldeF4RX5NSQMh5tVnX3wYTrMr9wTrap+lQRjAbmn2ALPBrOtQ2cKDykNrwVe7KwqJOOnsT9PgalKYTQTuh7m39kAec9M/c8QTDEho3xsA9d37LuXurj/wxU3smJ94qIue+SCBeGl5lsPaKjBD+pdAJ7OOwoBFX2bY2uSsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lp5ftaQ+w+elr2TY1C3fPhUbV09J98BAZIYwBwXq6ak=;
 b=k6rFhJs5QAg6/imx+pMhm22hVrR9Xuaa0UIqlf/MqSkxZIK5qn/CHei8QGN+8HhskQ541qvVD2/4ii5ub1AnPUCLPQzW4AmPmMzNhjBoQIfl9WMyWdV9k5fZAJ+grU4HERQDKQ+cluNk0tEF0TtmdtXj+rHBVZ6s4IOmvh4w/p3MB2e4/Z2kgyumaopvpR775Pedty3cF5FMMeLscFU4lCsGZ6eGTP3MopPVyK4SRRo9PHS0K+pqiQXXXroVrTULgy60I5p4v64ePqWpk7DP98mfzRgaCTILTzRwb1vHuUZp8ORPe9SpZXfZ9b2AD+H7j0CR+OpiIAWdHLrVVcHv9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lp5ftaQ+w+elr2TY1C3fPhUbV09J98BAZIYwBwXq6ak=;
 b=e4VxufmAChSgH+estsREDLqeO78meX1GjKP4KGDOAkjInUzfhDZ1X7ij6UQqPsLDI5BFzDPZ1RY+PZ60ln5pacJ+0oMaIBIMu4AmzAfkL88/YiuKOV8ITbrEX4S5EgGSyOCy16Q8B0dy1nA/7WJz8qPGB/chhHen43vkIYPWxi9zT3mW77HGS7nB4qEMeIWaCCBZH7t2ndVgxzoX7Qbq/9CEZE5XWVlDemfG27sznBU4mEl75mgJesMKMFhaXgCVXlUuhFsHh61HDy8QTSOR7Xj4dEn4R4rk+DhUU0rvDf85Ta06lHVgCjfGMSfnYKeeParg2abpcA4XJEHZFrq/og==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW6PR12MB7072.namprd12.prod.outlook.com (2603:10b6:303:238::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Tue, 25 Oct
 2022 10:32:25 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:32:25 +0000
Date:   Tue, 25 Oct 2022 13:32:17 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>, vadimp@nvidia.com
Cc:     vadimp@nvidia.com, rafael@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MELLANOX ETHERNET SWITCH DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] thermal/drivers/mellanox: Use generic
 thermal_zone_get_trip() function
Message-ID: <Y1e7MRozZYSHgV0V@shredder>
References: <20221014073253.3719911-1-daniel.lezcano@linaro.org>
 <20221014073253.3719911-2-daniel.lezcano@linaro.org>
 <Y05Hmmz1jKzk3dfk@shredder>
 <cb44e8f7-92f6-0756-a622-1128d830291c@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb44e8f7-92f6-0756-a622-1128d830291c@linaro.org>
X-ClientProxiedBy: VI1PR0801CA0084.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::28) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW6PR12MB7072:EE_
X-MS-Office365-Filtering-Correlation-Id: ef4fa522-19d5-4638-6a6a-08dab674357e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hwf1BSQDKePwMIjQvEEACu3wOAKwkTBgrVTq7bp3ccQlIMl6/qvj9Dhm6H9NU0FuJVNnYKMDU3DNFXNoF1+N/XJP3QKVRJRFBbN3cUrEmoL3HKfDPxBE1XuBltlMua17bFEQCjRiFUFXL1aLwLxhLToUNt6W0Wk4pvoxzVchSOoWuR7mIxqdoGfWMFMQIYHbLLxI0zucE/yR0qwgMiDTahKy/AGcfSgZoMvq40PfD5RzjlDcj/sKd1y+NRlnoXUQVmPwxlR21TEagECXJd2gPCyvQns3QJGvxRGWa9pJgy3esYP+Jez03tq2vbNA9HXD8rGnt/c457A0G2FcAbAXtS2vj8jM5g13RZq9TV5NJ0X9CE/V7QVVgoeECiCiJU/Y4Md9D92t0IHl7gkiBmvPMQL9ZAIEoenvZd316SKvXQc0uFOjESRkqwS/CrdrtH5hvVpFvMLkRInETCc7Haq/3Td/9QzYKyqeMap4jlFL95vcsepkeA1cwX+QCClQuSww7pjyqLG+JQwdIIKtp6Qusr/0o0BU5XKzIIZiq97wN4n2J6lf6h/IZeI9ORtB+UvABukg2383qa4nIFLsE1K2t0itklNZxrXpql7YSKH5vxAc48Cg7wxz4vmV65JMTyK8osv723peLrdf5izWrReu+cAr5aya8chTINoskvu4EcdO7debl6WE+De10IvPwJvjS2+mny1OGziE/UQfhVjq4aghimCy7ofQfq+FBoBRTW1mKDlJmfNwTi6hAX9s/uDg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(451199015)(5660300002)(186003)(66476007)(2906002)(6506007)(38100700002)(26005)(4744005)(6666004)(316002)(6512007)(41300700001)(54906003)(86362001)(6636002)(66556008)(8676002)(8936002)(9686003)(6486002)(478600001)(4326008)(66946007)(33716001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TTNznXGWXiE5f0fi3znFI6XcDJfRvxN4SuavNvpOsAT4zM/alVv4c9cOBh4N?=
 =?us-ascii?Q?DF5d7HiIzmzUMBEhNncUeOdLIfYuk8gX7jZeAfE9n/8hVf2sUNm3EGcKAPH9?=
 =?us-ascii?Q?I5SZMB+OYtB6l9ZU2XXLDZamDexWM/PNUED6y1bvpTYAganl1a40cAA58IP6?=
 =?us-ascii?Q?c5IACs6U/BytKgD1cllLlnh66Kz4vmc/VPyAwSPrYb9QuQ2DkMGl/a1xjmtD?=
 =?us-ascii?Q?dJi33LZjZgs2vTCCziL8pkw8BcrC9/XZ0EgxYcWV9hQ3mslydUy3knzyKvMF?=
 =?us-ascii?Q?FayLYHzzs9BsDplqszO/C4vRFSDqQbsTLvtZ/CU97FFQ4kfulIrh8RgxRUFx?=
 =?us-ascii?Q?l8P27VaIKNRwABjxSUQ/mnzy5curobmDD/PkvZ4ibBky7sNZa8cf/rn21gFS?=
 =?us-ascii?Q?QnrUbXWVlIfzXvOALaea6acmOL71tT2CXxSBAXd55x7J8t2bf1YxkfVPIGBt?=
 =?us-ascii?Q?WzM87yZsyw0a/0gYz4RQNTw2Tv/c6zJ/XCv6IS3FmQkUQc9Bb101VRmqiwNa?=
 =?us-ascii?Q?NRaqQUXF4KCjLHvUiuQB6PI2VVVH+C1c315EtJHO1pgbbIr/WVuCLjXL6NKZ?=
 =?us-ascii?Q?WMM3d4jsHd4gpEq9kf8QLzAklA6DM4jUG+vvA1uh7D6eDCaWQxGDHmHwM2gd?=
 =?us-ascii?Q?SFRCXKI0K+2eUsQK7pyn7UAZ+rBXjifTou1QlxrPclWAfCCXdcmLjxWu/eE8?=
 =?us-ascii?Q?Mg3YXNKFNG0MWXe+wygIz6FkpbwJt1dU1XSnfObgBEuLIldtW/iI8DXO7bjV?=
 =?us-ascii?Q?TGJ6BJXCJfT3Wu4sIC+IJG6A4Bw718vGUFo1gbusHkdbUTA3t93tf55Z43Ve?=
 =?us-ascii?Q?ADhWEOndap2SlKy76V0DQe/1UpMYEFnJkJLjapbGL36swwKpJTjhiF5g18Jm?=
 =?us-ascii?Q?vdkx6pzSScixA3w0Ob/RzywA9qObg5af2RSUpB+tj07J691Avd2oPQ6ROtrm?=
 =?us-ascii?Q?IljT9htVpWvVfzcdczP8Pwf7SBSvcXxi2614fUm9MAPWRt6YN1wH2kefhDah?=
 =?us-ascii?Q?hPw8LvFJfZ2deiT5u5ug8ZiLDscHOWp4WcPKDecEdl7zq+nTHU65LO2xtuqY?=
 =?us-ascii?Q?ta2waPTq0BgQ6AsZVdspuSvdCxAry3ABJ3Jib9Bx67pvRxGHdN8ADRQTgaXb?=
 =?us-ascii?Q?wA83Kv2jEGIavyxgldyiw9KgJTyZwAJEPrltiCooSdRbaT1q164ncWNL3T68?=
 =?us-ascii?Q?JHv3B8Ur0FYv/ynQ/cNDAA+y/ZhdZRspJM6XINQsXC4VvrH2szMmh7DrkyBs?=
 =?us-ascii?Q?qIzcrVufK/Dy5noGna3BBk9AMBAZVjZ6qezwSatbve6w966LGtL7536agB6M?=
 =?us-ascii?Q?1OK4XVBHESijblMAfWnqRq3QqVwx2XeXJ5FT5dfv4rfUkZLD6giaAMk3Guho?=
 =?us-ascii?Q?YFDugsd45ORlbEz6/AM3u/jhurUQJJphHAv2GDcCOyJGMsakpdxSPNAlH6ju?=
 =?us-ascii?Q?p1IdYJ+U42YeLzAImJPLSgulfvV0SjejIuqPqCbhTPmvX/k9owKX/m4gx53H?=
 =?us-ascii?Q?MKHCafsvxQaS6oNiEca+m3Gs5nRkVHqDzFZLRkk3CKydQjUgiRHQT0X78yTZ?=
 =?us-ascii?Q?2+X2BFlx+5VjlD973lwcLhkkKWqAkHDj+5pIDiSR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4fa522-19d5-4638-6a6a-08dab674357e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:32:25.7536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fycMITTjiygbn5vcA8Sj3taYkFiJxKhw57sq3AECHguNRsWXpcNcHcYzo00+nvraaibaVctIq9jd3bffKMOJEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7072
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 09:02:23AM +0200, Daniel Lezcano wrote:
> Because I hope I can remove the ops->get_trip_ ops from thermal_ops
> structure before the end of this cycle.

OK. Vadim, any chance you can review the patch?

> May be you can consider moving the thermal driver into drivers/thermal?

I don't think it's worth the hassle (if possible at all). In practice,
this code is upstream for almost six years and IIRC we didn't have any
conflicts with the thermal tree. I don't expect conflicts this cycle
either.
