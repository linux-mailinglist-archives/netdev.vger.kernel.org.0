Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A079567C527
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbjAZHvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbjAZHvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:51:00 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546E98698
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:50:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCxPX5kFXBJpKx+yhb/XvP1iFMwQDr8jUkkXGmZUhk+Te60zoJ1ec/17AGGo2/K0erkyElNLCq5nsZJaWMmanxH43U8ST7cqVJNMicAXEgKQjuq6gv7PvrcIGsqtGF3MjBXogyOl9ouDUfOAMzvreIMnEE6Wa3OfOsR13ELVNtQDxY4yscKhTyUmtn/Xf95mLoQKy4s6lPZYD8tIzsDr2i7JiospKfxzSs3HypZxqOqh54potYIMEcPGa0xr13BYQ1IzN5RSXDJa6mjsW8EPk8kWxl0Mdsvk0YPlBi1QKvIqAGFAwbDWRmJwb+4AEDNy5+++oL1DPwGeLEFXD6S2uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dv7vEiE3g03ActMkKqcxLaBqZJ5ZE9thrPs8h9jOtdc=;
 b=Fdo/fskanCOPlOGMQ1lsFHTeyVwKsb6gS4i8YhtiKyZTdYE7IuV0d9Op6pci4dEmWmzHHwlXHSd9M6J7P6WpYGdDa12A1zG+wXzrNMVScKPJykxbIbqbOx3C2qHnuf4h9jCzvNUWhP66ipq71upj9w/rl8YQBHaJ2igS9m8bK47u2PhF7D8lyw9m73hhT5NalsHisiE7j3oUfkrckj8cRaVaomt1RckstzPLyo5hB6WFID+90q1gbKimzhWVqaOrd0IaVzLXN97VEQ8gvtiCZgqte2su/rUD5KhVQvGVBtOzM914sFxmrvc810kPa1aNi6YMXQYlwoKQrKUKUp23cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dv7vEiE3g03ActMkKqcxLaBqZJ5ZE9thrPs8h9jOtdc=;
 b=bUaTor65nn+zNHKkXiGocvHOT9VT2vz5vCgCqNsbRF0c3OLB5qS7oh/P3s6Yp8z2qcujODrZx2Z73z3/9C2++72j0ijLzjtdSdZ8wEFcmdUZyZxBwv4dPyoNx5gNIefaRl3RXIFk4m6C/WXHfGgw1SHOHEQUmeKV32v22rCdfey32i2veyfbeOsA5PKmzl5maqIXqrjzXwZFMqqTOsK4en6CeJA0uyD+R9gtdXhJIlG+Fnl0NAKLrdFFJ22QbaUV2eg59L0mm0XxrnUSztWgokEvgS5YM+6P3Y64xaYMc+6CajZrSYm9n0fzk5WjvkPpduUlOE+P7XUmqcgnhY+2KQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5223.namprd12.prod.outlook.com (2603:10b6:208:315::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 07:50:57 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 07:50:57 +0000
Date:   Thu, 26 Jan 2023 09:50:50 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, simon.horman@corigine.com, aelior@marvell.com,
        manishc@marvell.com, jacob.e.keller@intel.com, gal@nvidia.com,
        yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: Re: [patch net-next 09/12] devlink: protect devlink param list by
 instance lock
Message-ID: <Y9Iw2r5yEQnyFgS/@shredder>
References: <20230125141412.1592256-1-jiri@resnulli.us>
 <20230125141412.1592256-10-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125141412.1592256-10-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR04CA0076.eurprd04.prod.outlook.com
 (2603:10a6:802:2::47) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL1PR12MB5223:EE_
X-MS-Office365-Filtering-Correlation-Id: 75bd40d4-8b35-444a-9226-08daff720f19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KPsjaCWBsCXyLI7E+jPz3lJGUOgkc5IrUOnhla/JuiVRmm6hWOW44ie/m/T/cVLafHs1ITCwi0ERY0x4GpbuQw+aC0i7Z97IYzL/N4J7lmkiDZY/js/QFq1p6ULg0wWNEeBzoQIeYe9Bilb4dvX3bRCDdySafSWwcKDow1IDqGve7jKeIuh5fqxwwQQWEk5jOzh7AJ0JToMNCXvfWQrNwQG2szAQL0QmhYGn2G3e26SiI21GVjxHbo4nCAeHhKumHS3+iIGbMXw+ow1BPlkBVC9kUSKOLOjzOwpFJIv/OjfeKGIKdIDsvGfAMInfYTrNVvpzz0TOu5hLDLtUVcmLg8sJ428w6MHCUEd2aRIKp7lqS476oi2+7Mk3CVVLsjxZWwafx5Vplr+wwFCUdJs7YhA+rXdCz0mrhM6UiFJRAhUKZe5wHOGB2lVaAOGXpuXPNlowHqgUqCnaczdxS5i8gUUyq6GTWB5uSeqMtSVuhbE/2WImyckcbgKn31W1UFxx1khDS3aljsPvJblID7hAk29xLFh0Cy7BS5gyEKyNaEGry+AOsMTErDyzoDO3FReoR9jBq6xFGb8zRZygQ7HRkFJbDxp6SSFXSn03iC9wS+JXW+QxwLRPw0R9/P3tqYI0p1vXWCW1rNkL5OMSDWp0EA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199018)(66476007)(66556008)(6916009)(8936002)(41300700001)(4744005)(5660300002)(7416002)(2906002)(33716001)(66946007)(8676002)(478600001)(4326008)(6486002)(38100700002)(86362001)(83380400001)(316002)(186003)(26005)(9686003)(6512007)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S6eQw+ZEjSDUbFkPf4fzj1N31h6rO1XONUx4LTZjYeWrRiUAfgovMTQpLy3z?=
 =?us-ascii?Q?yutT4vwmRloGW1TbcYu5dKOWUKOeFYxtEPFUDhv42GzBapAAy2BX3CrEQDpr?=
 =?us-ascii?Q?U4LYJ3WPe5GoLsgLsXRA8YDw2o64qNDZnRI++3ZhkUiMSsjzfKVK5B3xgBBI?=
 =?us-ascii?Q?+rq6Vu3tibnAwXhauHEL5gX8SKC6X9RTLldPuFNLXTyJ6kmPiqNwDzxTj/41?=
 =?us-ascii?Q?YHPX+RnvR8NSdXdrMFsMd9dTbQeI3eS2T83epc3uvdMQMrfU0TWY+4PQbWUS?=
 =?us-ascii?Q?Yixi9/Oa6w3yCMaUyZkf/JC+oS/jCNsbXixqfjsUiPh/b6wTByVSQHFU6VRQ?=
 =?us-ascii?Q?d0JhFK2J5RSkemcpAmOZlHlrzLj25tIcsp6jaD1J5zQfwYUYrvQNcF9wn4Mh?=
 =?us-ascii?Q?98vAUvYNqHL+o3o6XakXh3m6qryLtI3R3GBa5pHuof9X4oGb/kERFCuoG+cP?=
 =?us-ascii?Q?pP2+/PMC4hpwV1RD4eV5VbGWwq2rSt5B4ynKYOgajFOksU4ft69ikGHp8QO7?=
 =?us-ascii?Q?KrLwqhkV36Z7Sf80+m+VtqybI0mFKJeE41GZCJS7A0qeh1y0ZDBPAxRr2Pg4?=
 =?us-ascii?Q?uoh0YW/gMVZ3FZzpqwtHoROqOam504wk0NodlrYH0KOOKbSHTjN/3vPZhM1N?=
 =?us-ascii?Q?c9oZYq63sOnZTqTxefYvoUCfZz4IenZ9NAfCU6upfZ8l/Gp0x7PZcbqZZqAS?=
 =?us-ascii?Q?4Bcai6++7h+U1h9xDDkVvRocIGFP02DAca7F1AYAM697LC7Aic2vafECOByo?=
 =?us-ascii?Q?+RKLsRVCMV6g2aaCzfoZIg0TKQHDB5mkqMl8Ji6s518EfoXOhhG4p2zWTToo?=
 =?us-ascii?Q?wheC/JmrMN+VYBnOVWb4yM2Cq7g2O81ywIupOlVJbFBGheBPT8lxOwb1PPAA?=
 =?us-ascii?Q?UR1UG7OPKVrgoIY6x7ikAL2LO2dJgnhy/m4m1MtXcLLWhSMuBsjoM0uEBvw8?=
 =?us-ascii?Q?ZJxDsp345UGOofqfxHlOtpLdWU4Fko6aSx5g+wonb7JQhFa9N7jZBvucLEAo?=
 =?us-ascii?Q?w5u2GVPadx7MRAoXVbCc7BBmnwB5ejQ7Pfnef5oMCSph1yM8UpZjVpMb+wbB?=
 =?us-ascii?Q?GMNob819FvYDhtuEg+DFJZ1UQ71q+zrA0hxzzs4SSqNHmyTTmdRjWC7OkgTl?=
 =?us-ascii?Q?tXbEarWLU0lyYFxBYDW5UW92OkBIWO15SAl7owkgqNvJNU7OUUSZ2K2MY18Y?=
 =?us-ascii?Q?fE19ZxK8WbwE/HA5/bh5SgHCVQRDGXaeAKhwyUi/WcRCxjwnB0SiBYNPneVd?=
 =?us-ascii?Q?Rb4Z5/7cK+gACJuUfrqZL9YGKbd6ytA2U77GEn6615ryv0gR7AYebquUGEn1?=
 =?us-ascii?Q?Q7WPath5myqRXv9fQJ5XqPto1iPeycQvgv85qkQ9X9kTkYZxoXNr1CGTTFbz?=
 =?us-ascii?Q?IUPdi1E5xLZvBh5p6Q8ZpSE3gvMxHKXzkwx2L4nWeeru2YGyzwmShdTWkd5S?=
 =?us-ascii?Q?mbYiQhDo0RAR2sGU+oyttFUkpM90FU+DNgXv4o7NE8VkaIE2PPf5J01XTqtc?=
 =?us-ascii?Q?BG7MEQTvsVEI45PBZRdiLFSOLWR06ntV674gPJT+WIYkx/KGWEirxVmgwJlj?=
 =?us-ascii?Q?DRm+8o45g7D8HgTuF1DsLYAu0yDvbkbWBtfuKudJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75bd40d4-8b35-444a-9226-08daff720f19
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 07:50:57.4628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C6tmeiRURmRutpY1Pmk8nXhcIzLmdTJZrgmvkIa39NbR1o/+ocUqiaxUHHmoBBN4CjxWNC5dR1tG2off92zeZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5223
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 03:14:09PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Commit 1d18bb1a4ddd ("devlink: allow registering parameters after
> the instance") as the subject implies introduced possibility to register
> devlink params even for already registered devlink instance. This is a
> bit problematic, as the consistency or params list was originally
> secured by the fact it is static during devlink lifetime. So in order to
> protect the params list, take devlink instance lock during the params
> operations. Introduce unlocked function variants and use them in drivers
> in locked context. Put lock assertions to appropriate places.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
