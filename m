Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EF25634B4
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiGANvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiGANvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:51:53 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8967727CC2;
        Fri,  1 Jul 2022 06:51:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pmw/PJkoMiEpvbihMAQ7bz5qtYRpo5iWUsdMQT8lHqyonehQa983VpdOGjp2vd1VQWHdq55ls8ZDUbxjKXY66jSChwH4hGIyabPiq6nuwlY1iWK522anBp/ZbkdNY0HXLU0m5Uvyz5FvWOT4g98Mm3zJzgfZHQhZvP6B6ulOp5AAf7ZcP4ZEdnyC4zdzTmsuHoUnj8w4X+0/iZJbEnM14UtN9omLN2abhQMzK+O0LkryYkaWJ1KumN1LYug39/+Q2zZVdOMFjRQrhoUQB3U5j6/KeRM1TY8Mc6LX686RkiNTsPo570kXPvRUXsNQF3FtY4J5kVnDyzRjbHgiF0EUkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6+9i5SuUEh0ZfHLFomcmco8y7vOn2ICelFhVSEAttY=;
 b=W+9nVnFCC6C+/5MsAmWQ/lWlnJcahSvRAh+Ktx3pz1cLO2aFBQvCpmmAPISqNPxMoCkk92R4S/EM8sBpIiK6SF2wKbvxeAjMHXPZdOSyDUpSu8A7/pBxTfaz5Z2pifMqvAHJd0EDmxywbqdrZNTVQmjcXMTVWWgJd+TKE/NYeW3slvJvjk1NfeNF3zE3cjyno8LSkQQoEPAQJvq3+ctlcoofGd5MfPragAIw5y9ueYigWYklPhYM0YQakz5h7YezKshYlsADSnCtE0QJr5oGLsfxQD/gf+XYcYP8O2fCIFp88DslvT40HjgIyHtN3Xr/UlaSGkfEjbWlLKrO77+Tmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6+9i5SuUEh0ZfHLFomcmco8y7vOn2ICelFhVSEAttY=;
 b=T1xLn7bFguZH0ng3kiPZlm+6qHbEt1sr3eqL+G3tWgBLub0f9wSshlk90F9A4TkZsgqlOO67rmniorp4SNjiYoXC9AT/vwpELoXZ4bAvsFK1vhi48DCRIwFOKtMLBes3aSp/UYIlGscf/VnlaiTXtQAC+MNFzX9jYcTowBm7AYsi/uoTQwtwXPAnRjF4ZgIgybdTEEKU38NL1+RjQs+chdF9j0dA/wC11Foka6McoKCBkcOvE2hgHpC8YwuVtFlsu63dp/C2l2F/q9MRdy4nklJ5MBgsqui5KNCcHRAOS8CtlMpdVA8Z4BHX3JHBdboIH7iZ7JmvwYZD14JWslw3zg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY5PR12MB6647.namprd12.prod.outlook.com (2603:10b6:930:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Fri, 1 Jul
 2022 13:51:51 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Fri, 1 Jul 2022
 13:51:51 +0000
Date:   Fri, 1 Jul 2022 16:51:44 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Hans S <schultz.hans@gmail.com>
Cc:     Hans Schultz <hans@kapio-technology.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
Message-ID: <Yr778K/7L7Wqwws2@shredder>
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder>
 <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
X-ClientProxiedBy: VI1P194CA0035.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a650a42d-d4bd-4c45-0478-08da5b68d985
X-MS-TrafficTypeDiagnostic: CY5PR12MB6647:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g9G0QHuNmB54m5F1smH9MwwiVlzQ7dMyO5DPpd2FXNO73eWO8Jh2gS8KRQYCIq94HaIYcr8JdDMsOAeCFhSC37fkRt/Kr1MWZ4idI73cQC8TW5PCoFuNij7lZ2cTJnt4oFwP7tPZ20zlvKrT1efOOxXqJZYxFGBXBg/2SFL31S7QpaCyshMK+kk4vrQ93g/jT8t3JP+pSApMjcH7pnUlMn/tRhk40R7daunMlz7/eY7CrqQkYYnbvSusZcUbtQ7zgRBLLmwMUuCCg28BCd6J0RayZCfVDgM120LqCMwCvvodkmieiQRa8NvvwUmiWayrrAoBlWTpOjjXmK1cIeGWGgGXo/rBnIrITCDjuAwXpuo0bl5DBv3GJi9qVzK4BHLOqNIVuRk1r/FS2pCMb7VgvrNWZS1ym0KGYaaBxQ/QeQ6UWevTHRVaacn/C8ne1LrVelHPEn/ymj13ZF36V4zJNOk/sI2J/xUafH/Ol5+FESUwU/8RJ8CoUBQAh9V5fD/lqifvf69HE2pGnXBhSkUXoOvfyby0nn5uH1agyMwgjrdG8AW0hAF+TQiNl6Xf3cuVTCMmSdB1Na4b1klV0UTyMV30YRXrkfEjvjlc9i+m2BG+Y/iEoIP0nBexkRg556XR8d/dqWh7SKQVRnKhsxCRhISXtmaNM9jFr3taVCVcUkfJKSeVqShff3NPZiqr8nlDPpRrKzBznETIJhdl152BZOpEskZRt6N/z3ZTIlU7/fqLpVdx96dDEgyxrm7/VaUP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(39860400002)(346002)(376002)(366004)(136003)(8936002)(5660300002)(7416002)(83380400001)(478600001)(4326008)(8676002)(6486002)(26005)(6512007)(186003)(9686003)(6506007)(86362001)(41300700001)(2906002)(6666004)(54906003)(316002)(33716001)(38100700002)(6916009)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SyltQoOGQIZumMPIpCw+Ie6tr0S36+7blcOVw8WVshwF2mDg+ET8GcohTroo?=
 =?us-ascii?Q?ADzs/e4Fr8hp4runa0rI8QNIZNmVI6jDLS6E9v9nvaLVg9P0AjHb7kAb3Ltw?=
 =?us-ascii?Q?6bxQrjybaY0dSC7WeAEIQ/C1Bk0WLOQKzv3uJYn+O8hUpLO9nPmyLl24XUSJ?=
 =?us-ascii?Q?ejKsMJZjk5BgL82zGSs5tzmqZEULxuCenjGY5N3LR9dKFHe7/KY2hKks5Ynb?=
 =?us-ascii?Q?eDL+XF/8Bnkeccu8VV9pXzBM6T9179fl9YT06RJbTacAEVSUIJtIsjA+t7xd?=
 =?us-ascii?Q?8Bh/+AQtbjRNgnrXiHzewFit4opKVkvU43yvsADUyNjnFYkDvE0i9mgM7eD2?=
 =?us-ascii?Q?DVK4MvDTUJ17LvBLS3byn8S4sPF3EkkGHSLGxvyrGLuOgjiS3QYSyH4G6AL0?=
 =?us-ascii?Q?tkMj9o6nUeIQ5Mk2qv8O7H9cw6DjPslXWxrGC5hEMmjIAo/hC3rCVIxoNzXK?=
 =?us-ascii?Q?wvR0XRBP7kyQyVjk25qNNXarQpnqsFmN0k4fD9ndhjIPt/p7c5W4iEiNg5tB?=
 =?us-ascii?Q?aBdan2OE1hJwFcgONH7CfUOK1q0T4PFxppWpckMvi+BbP49+7No945fRYk9+?=
 =?us-ascii?Q?7IXGSQShTGIA5MQ5RCAQLd//OjOggeTpMYncCKd8XDxaAbHrETMsBnoTNg/6?=
 =?us-ascii?Q?hZ4CcFCfbMUNcVdYMdEwemKkGeC99wpjdX+kouOgalnRVUtBPqdl1EvU1QRD?=
 =?us-ascii?Q?2mKZst7UncaRdwoTh0J5wlZ6gYCiqHKkVpbfbCXNlwCDlJgPYS0fs1NPdN/a?=
 =?us-ascii?Q?KPuHUYH0wsH/WZ1fNFbnGtKM0c3Iqb2hDCd2hLCzl6iL0SuOpxBwfKYmRs+h?=
 =?us-ascii?Q?OwWCZ2Nr3LD8RfrAlAlGOkP1m+xRTKu3Dsw8dUaPVSAQqnCgFiDivk8i38lj?=
 =?us-ascii?Q?SREiG2+I32PtAMjRm1AqgKwbn7hcBkKl41556A2h7TLdw4yjUJbbUtKyLAZh?=
 =?us-ascii?Q?/vCgsLKevW88zVaYp84VEcXH6Ph1xvLdfUdu0AcdsGNpq/LTITR0LjtPjTdk?=
 =?us-ascii?Q?oIH1s/P7AU0U9f3L2vD1h1QI2Su7q0Tv59ll6xfpd0nB4hj47q4KmkcuiiZ2?=
 =?us-ascii?Q?2CmvN6C8XMGU1uU+lgXw10PCRdSFg1c4/c5EwAvi2s0KwRN6PxQkEYi3FYsz?=
 =?us-ascii?Q?r5RK/dzQFbfvRlT0DpPOEz9IlOsV6TKbXKyW7Y48ypR1SFyFc83QXfA41lN8?=
 =?us-ascii?Q?7plIsrFGh6tBBxGSvAP07mJw1izotDYOnso6p51zIlPTUz4FGQpUP4zdh0bC?=
 =?us-ascii?Q?lIZwDq5Wup3VT/2lBaA3/46sJD36QFwCt3nCHWP2PNHRActyAP5OuV1vGEhN?=
 =?us-ascii?Q?+L4c/dHDkySstUz95+pJULrG6xraidt3UidxlBZshMPW/gNhL3X++hnsBWXV?=
 =?us-ascii?Q?bRL60kADKP1pcvKJl4nTInm8QkG9SZn/Kmk87IsTTm9O4gpe8mQq8ncWTm/0?=
 =?us-ascii?Q?h6DCg5vBYVnApNT6ItKGlW8mo2DHtHhMOw5LK3ThMldCI39LKOd0gbLl64zw?=
 =?us-ascii?Q?kJSlUxN0OYG7zIgRdXd7niHhVEnZtDA12DAl7eCGQ3baj9ybPPls9WAEd2ug?=
 =?us-ascii?Q?GevvMcWgczqnJo4RZ7a/VbshFjd4T4drzD5tcYT/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a650a42d-d4bd-4c45-0478-08da5b68d985
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 13:51:51.2008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3gah5qOiYCggE9h+Cx7/hcyuNouCZOPB5+V4U7rY6h6W4YCXnhIlOVrdG8Ksgdo4bCfiI9XmSyZMDVlvuhe3PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6647
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 09:47:24AM +0200, Hans S wrote:
> One question though... wouldn't it be an issue that the mentioned
> option setting is bridge wide, while the patch applies a per-port
> effect?

Why would it be an issue? To me, the bigger issue is changing the
semantics of "locked" in 5.20 compared to previous kernels.

What is even the use case for enabling learning when the port is locked?
In current kernels, only SAs from link local traffic will be learned,
but with this patch, nothing will be learned. So why enable learning in
the first place? As an administrator, I mark a port as "locked" so that
only traffic with SAs that I configured will be allowed. Enabling
learning when the port is locked seems to defeat the purpose?

It would be helpful to explain why mv88e6xxx needs to have learning
enabled in the first place. IIUC, the software bridge can function
correctly with learning disabled. It might be better to solve this in
mv88e6xxx so that user space would not need to enable learning on the SW
bridge and then work around issues caused by it such as learning from
link local traffic.
