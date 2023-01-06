Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFC265FE8C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbjAFKLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbjAFKLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:11:10 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A853C0C5;
        Fri,  6 Jan 2023 02:11:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHIURIrV1O2ttTlagvi68UrPW3Bp2MvowjEDC5NUpVYSIVmOBCAcZFZNB5yty7p/HAucKOZLtMR/KCA3ueWNDrmHC4qATbf44Cyovg+fzoMUKMDI4O78bsx+AW5uP0/JNl7Rr02pGxHFluOB/0nGjIomn9icmFZBXbygSff0+SNUniBse2I2ArQqpMLlYEBC8AgY8UL1MYvSgAPjBT6LQshp/hh8QcQibYavJ2xJf0G63GPUCDV7vEmkvz7nkIyMtLIMO8ar3kGPZq6fHOA/gS86hX+aMA8wMyQH8XCfrEOUbBgH+ZnkOfUKARppO1bunLNYlEStbpyPu0IkSuvh4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQkh+S+xY+4cstl5gDCysc0d59+JBEjM26yIGo8VLTc=;
 b=lK0tQFvndM0u3L6kC7njzNAT/vDw2uiZgoMQqBXvbq0tDn+dIcikRLND/0tRzNK+ke6WtFxb7DircrESCwNiVOdq7GIUHKcUtryfUnqQc4jUfbhC/2xoYqHae10wALAEDMwEKJKgNRh6cAKoEokmtMAfLZraeCl+vOV3+1OH9CJ8rFNvFIDtkE03ZAoDdED6XiXxwmfT43xV5G4kg2Eu3RGkpHgptzH7Ezyigd2ZWM04mDy54K7+7h3LCpkFQc9D0Y8ISf7VZqjZm+6B8PSWNoVZvn/lhz7kRLssDQKEZsx7DovlN+JHfONEHnoLhp4MuzeE4ovXeN1soTjtRTyEPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQkh+S+xY+4cstl5gDCysc0d59+JBEjM26yIGo8VLTc=;
 b=prElmeFOJEaipLYsFI881f2RkJu/9je3Y0PUdje/P+nKGchZAxmrHMjjFbU2ZBTd4xQs6+T7lwKsvGTnIfwB9bQTzxSvQxDyr1vIh2EGd9QUTgK/vnVh0+lGWAQ/gJLX1NxdAkZ5L4cDsEWsgd9qAKbDylkgG3KsiTWm2zrMMzvzn0cPh39wrloWNYienUMpgfKtIASTKKRKw9a8kLIBjQt9+iasHbPLejg3S2yA2qDQT+w+SH0U/HU7Y1ZQRPxeDlJ3KwR9ppp6NdLmV6OzgEhtsGaon3WbGC61+im2+aBJtUSZtHO4tc6ReHj9b3IK1JaNjFAUlkljw2cZhKGF5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB7970.namprd12.prod.outlook.com (2603:10b6:8:149::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 10:11:02 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 10:11:02 +0000
Date:   Fri, 6 Jan 2023 12:10:57 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] mlxsw: spectrum_router: Replace 0-length array with
 flexible array
Message-ID: <Y7fzsd7aH/tCAMyf@shredder>
References: <20230105232224.never.150-kees@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105232224.never.150-kees@kernel.org>
X-ClientProxiedBy: VI1P191CA0004.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::10) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS0PR12MB7970:EE_
X-MS-Office365-Filtering-Correlation-Id: e4df2247-b577-4d27-f4bd-08daefce50d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FK9ImDUa+jFfFoiSRWc5CyGfqHOBD4jMsUp9pZgWLrP9ROIxcGsGBbXFr0zuhuL9+YQeA7x+OxYND4kjPNpjT/fTrT84na36eTHddj8ILb/pYyPGarQVXt5tX4CkfwCBbmAPhh77lXt2zQG6SU4CWLbJ7pB0sR6KHJgRoPlY/w/qlUcqrEbn1mkvq928G3NPimwYDw9XE8XdLcVZr7YsZuV5N66xnOAUcD46HZTyTekd3Bs3XLHghcRLgWppENKecULLO1POKo/4kJfdzs+yR/wSsHLH+4WjVdcjFmRjMTUiI+Nd7gjrXBje/9nUOo26SK7BWzq8EsPVroxTxX+FYBnyfLJQL3aN3A2bl9VWd8GbFtczMnZaHVSqVmlWi+e4bUOYuJ1/YZ7SWUfWjFtfbKa+/qYPTUwofZZ3DSFbsQ1mPgij7PgB6vTkGop0kAuAGL/AZSAIGeFPkgCVoHgMY019k8bPy3FlnGh5HQ6qIGr4tu8Bi8lH073NBpIZ/fP6Xul99bMX8Y6xai/ZlQc+7GbFul9P2RQJXv0ViTHpb8kIRx0YstKvVJ9aElEnCzIVXghLUJnrI0PG16v/4kzzW5pzzod3DRaz8Z7XtFFaKFV4Tp679np3YMYpc7DnIjxsEauggeAacBO4u//HhC8qOSXiJBmZz4FPs2/4mf6LfT1OzHINoC1PW6Hsa0f+q+05DCelal1gvXp0HmNXY7eNSOcPhAlRp5gHxw4cr2ELeOo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(346002)(39860400002)(376002)(396003)(136003)(451199015)(83380400001)(66574015)(26005)(6512007)(9686003)(6666004)(6506007)(33716001)(86362001)(186003)(38100700002)(316002)(478600001)(4326008)(41300700001)(8676002)(2906002)(5660300002)(8936002)(966005)(6486002)(66476007)(66556008)(54906003)(66946007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y6qpmSSZ5HhAHyhwbQ0KhL3muU4WfzdZcvAkyzbIvUpzULJcGjz8t/MxhWAw?=
 =?us-ascii?Q?PtNYE7GF2BCUiZW3nc4IDhMvtjL8j1hal1Zd04mude6aYrB9EWNVS1QGUNMV?=
 =?us-ascii?Q?x0GkjxZSmHiSkMyVihNb7KAPMuZcnYRV24OYPMIZNxf4cO3Cf+D9wDwLoGyl?=
 =?us-ascii?Q?N3O03lBXbxr3FUNxsuOcDNfsL2VM0CmSsa9+5ECwVqG46J0EUXPzHK5Gjcm/?=
 =?us-ascii?Q?Akur7CKYZEYjtjTLJ5Ylxc9xCqVunW7hp6qsuh8j1ANwYM4QlijLbHwbfOiR?=
 =?us-ascii?Q?1qcMhtVIdpaBT/kK3gFsxpLjylRW6fTdCTOT/JWt9nCZZPXO1Zqddpuiv9cR?=
 =?us-ascii?Q?9+G+N0kkgHcY9pZexnZhe4+rmDIn/O0GZixLYfs/uWsGe3PXZ5DoDCIk/bKW?=
 =?us-ascii?Q?BvSJlg3ZFl/fjO6iPn8h0b+cI/TjE2aFUqWpknU+RzSxlq7YvtK5zgRXks8P?=
 =?us-ascii?Q?p+GnkpW+rHJl2ptwSp5Z9fhiANrkrLhxOMBWV8thu5+/Q4M32pA6h3HqMUZX?=
 =?us-ascii?Q?tUD6D/nN3mQePzcQe2Fm1LKt5SvXp4tudN99KYY0wBOaIw1jMuTDqpjqGwN8?=
 =?us-ascii?Q?fPWjyQ4vbFOYHTCtNHc5cYIMZbMgJRDwCa5rklUIG3PoJWhjSrXjiHIWEf6z?=
 =?us-ascii?Q?6Q2wv5bBDJvRgWYZNe4oigTltCq8urQfoW54KOPRAlE/U6Z8RGdewsgsArtu?=
 =?us-ascii?Q?ezZ+Lt0WJYLPged23sjxxaOubyVsLw+y7NwyxxZ2AF+Qx8LbLlUflnHQN8xF?=
 =?us-ascii?Q?1V9bIT1ixALIJjYcCanINXwWWpP6MVZuoAr5ZRq8PV1iC+xE9BcokyTaLjC4?=
 =?us-ascii?Q?opo33RCcTSBJtPGVvI94QfQYKYPrzHEQxjz3sWq2k/xVMK1dO2qSBpvwtev5?=
 =?us-ascii?Q?mmFqcyiL68hbyzH1ILiDlVxQ115hjBlr5VS0aPlBqS5Wetim6Lj6+0Bij7uv?=
 =?us-ascii?Q?Y7sMK6j0QW82D/l5rb/KxyIpVNHQVogt+WC33CHvVHO/zqUmYPB4221A2nRV?=
 =?us-ascii?Q?JN8tgVhf8mGC2i4wq6JQCR91hjh2hhJRl1UfI8DzDcLVQ8kzk83d8/KTmLRM?=
 =?us-ascii?Q?spyeQZjD1tiHZOpcL6cUlkbDYClwStJf210KlbdqHxmm3K64kx6OnctDwGMA?=
 =?us-ascii?Q?lHgIkWNchgyjrOMZHQwZInlMEUBoguJE1lbpip0CDcP7eXXrTWkcJwDF9q+K?=
 =?us-ascii?Q?f29HVekdQ4y0yIplExKD1UsJlYnPT7GtqbSNk64jv+MbMm8kjFBPkVE5E111?=
 =?us-ascii?Q?MQTQXnplOoplRLlsJrkdS+WIZBLY2hGMmZm45lRjK+fZdRipoqVTQ5f7Izkp?=
 =?us-ascii?Q?48CzvI16XtMMI/gNDsgoKm4Jq+8EJpG5XrKrS+3Khk9Py7ativd0a7nvThfJ?=
 =?us-ascii?Q?lpTGoE+jy5oorqmR0fgDb4OoyQFNU35dzf7C2cGABdfVSj4YYclzbzTRMDbk?=
 =?us-ascii?Q?CrLIpTZH1c5xu9zDHfPgyLRDYjEn30LrziZIAPUCUmyzOEojk94S+HFLMwcc?=
 =?us-ascii?Q?tADIK5/d86rbtNPbjUJn0ddOQ1bBgC5fFGsW4KeVL1Au5I7+erSWh2g4DDDl?=
 =?us-ascii?Q?QwvqjJ96lcTbtYPhhm/5sEXmkEYX7+zsYBrBTtaO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4df2247-b577-4d27-f4bd-08daefce50d2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 10:11:02.6680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7kREhydDK6umth2koU+OkFcyv/tig3BmTZEz9GU0GPjc/uW4mZYmooO5z2zWL+vUjbomUI7BASwNCZh9qHZChg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7970
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 03:22:29PM -0800, Kees Cook wrote:
> Zero-length arrays are deprecated[1]. Replace struct
> mlxsw_sp_nexthop_group_info's "nexthops" 0-length array with a flexible
> array. Detected with GCC 13, using -fstrict-flex-arrays=3:
> 
> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c: In function 'mlxsw_sp_nexthop_group_hash_obj':
> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:3278:38: warning: array subscript i is outside array bounds of 'struct mlxsw_sp_nexthop[0]' [-Warray-bounds=]
>  3278 |                         val ^= jhash(&nh->ifindex, sizeof(nh->ifindex), seed);
>       |                                      ^~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:2954:33: note: while referencing 'nexthops'
>  2954 |         struct mlxsw_sp_nexthop nexthops[0];
>       |                                 ^~~~~~~~
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Cc: Ido Schimmel <idosch@nvidia.com>
> Cc: Petr Machata <petrm@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks
