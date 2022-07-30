Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6303F58598F
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 11:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbiG3J0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 05:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiG3J0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 05:26:45 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696D914D0A
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 02:26:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9b+lLE29fWwX+chF3fnrUAdBjs+g28NzvoC+a7PaA1ZhF1aq63uLxh8W8nhSzhEJPp4OgpQwyecLqtPvYneBQ6d3LpkPgoqc1WyKUdVsxGNJzzgHTx02MINdDPeNZ7+GU7hqqSlRPllR6NFrgsoLQD8b9hVA0Oxr97oyrKO0Ej7djMyRWVvTLnao1hgUlSgcbpMKUIl4SbBydFwmIYS/ZcxrLu6juD2F2bbiesQk25vS1Nkb450yHIVAkE5qXFbbuqYNtiIUGbm5eXpjulCm8Ksu0idYw8mcR2hdVoYiLRs8VfA3xkpWTM05OfiNlQe+l2zWcmOFztkF6nklX5jcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CrRtedMZ/pQuTs9t2A0+pfB2fuLj5zygOvpkcWNpw3M=;
 b=lDehjb1YEtCr3XuKzx7srjpeLcWPHM+Vm+oHQ86bSZl5zZG84dg+6SfSGOKWiNAemMals1lXvyN0Gv/FmRHJQH1cn0XhVu10FqHF8vOAAApUDuLhZ8ugmrldHK5VVDD9YzdO6cRFfogtfOKmotDsPgVkzhDhTMx/Om05UOczh2uNyscxm+/d++7oLoYebS6CFCRYkOsisK2cPMDuz1FqFgfen5Uu5NERIV6uhTqxhr4uu1S+FfEBgs+gfqJFSfNvCXh+hrbkxx1CYiWnqbxnQ799svs3Woc2uZFHjsKxnZiB6xuIiXHV0PS+BNIFMAFDRlqY1W2872c22P81t6hQSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrRtedMZ/pQuTs9t2A0+pfB2fuLj5zygOvpkcWNpw3M=;
 b=hst1M47tPHjU87eMeHBEPasosXVS1T92qez0Bw4uQfRIRY0tlyiz/b731TD6WPZgwbM5QGwk5u80miPhD+ndwZGY68NcS6DaA0bpeYc562gY+jQK6ZqOEttb4mk6LnCJsZqpgSAlOMZ8AyYWcGCexQUNtMh7nwn369ExSqwN2eBx1psdwgwNtj/QF0zdnR00KcDr41Aa1Pc8mQ8U4eWwPDyCE8AfMz7+vggWfgno3KeHswh6qXUTPp+nuoBpTRR/OrooztCESh0kCQ84lqmDMHESdh4DAinrmUj5NAhnIa1rYXIp/EBx8sAEcnvcZjNjf+dB+CtbAVuNOJ4ovuohBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by DM5PR12MB2455.namprd12.prod.outlook.com (2603:10b6:4:b7::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.21; Sat, 30 Jul
 2022 09:26:41 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::4c33:6e01:fd71:d2e0]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::4c33:6e01:fd71:d2e0%6]) with mapi id 15.20.5482.011; Sat, 30 Jul 2022
 09:26:41 +0000
Date:   Sat, 30 Jul 2022 11:26:35 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, idosch@nvidia.com, leon@kernel.org,
        moshe@nvidia.com, netdev@vger.kernel.org, davem@davemloft.net,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, tariqt@nvidia.com
Subject: Re: [patch net-next 0/4] net: devlink: allow parallel commands on
 multiple devlinks
Message-ID: <YuT5SzT4U7F2Bz+0@nanopsycho>
References: <20220729071038.983101-1-jiri@resnulli.us>
 <20220729200434.4c20db10@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729200434.4c20db10@kernel.org>
X-ClientProxiedBy: AS8PR05CA0004.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::9) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d75103e-c631-44dc-6ed5-08da720d9c76
X-MS-TrafficTypeDiagnostic: DM5PR12MB2455:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9gmJEdsBmyAoxxyWxpSE28t12s5OreI6f3VAbJFA7DnF7cc3ZDCvA4+/mulAFEtXZlO+fUGBYpLRBkqpU/ff/m6m6QU17Uoy20/aedAdh+jbF5y+uHmEmNeGrZEzdOdhFfgLYmy26l6UFTvPzNcq4rG9CO1tCzvk1OCd8fO72qHB2btgz+/4V9qKe9Uo3r7jX4bNXwLp0vreOF7ouoptnk/JodPZC4zx2ad7OMogpUsqrSMqsSVoW1LZ8Mygm7sUfUplIbiPoaqDeqNvJ/AcBcDTWJzOorIxxo9ZnkwO60ZU6kCDCxwIXayCaVc4yjM5V4Isb/ZKXKbTRcA9WK+DkFL7QFpNgjFSJp0INlb3M8VPqxzQqso0mjP9j7L19s1Gh9as7ybNeXrPUzYSi43pK8X+dAJvfXemfkMTzg47ghD4Vbrsu837aTwkVBSmyEGuuKHPTknmQ/Sl5lv/mbATzgX2S6n5SfV5c9qiRRN7aV276KDAXb3ht4zUf6FKHsxYxRM6mDXeRnfVArDvkse/W+rRuVGwt3HtRmpLbz/maaTtWUw/MNn6suIpqVetKGM0nRK+ZRC83064+vzcLEoOi0iN0JZAkhkGJRD6GlyugtySR/cCijY6zWhXIapWI8AHq6jjoJ65kzCUGr59fmhkqK6LiHspv5yzc/DjSVhCgkuQzGXH8aZiKjRNMXm6sBcDuvJoaqDOHqmIwufx8KdHvPKbVjIRtVCXTvioC+N/qlvUMddu2UA5gclMYbZr1e623WITZvSAYOxxSnWluo9YHS3yt5Xxv68ppLTYIBcoJ9Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(38100700002)(6512007)(8936002)(41300700001)(86362001)(2906002)(5660300002)(186003)(4744005)(107886003)(9686003)(316002)(8676002)(6666004)(66476007)(6916009)(4326008)(6486002)(66556008)(33716001)(6506007)(66946007)(26005)(478600001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5e280vnKiH/XCYLS00K2GL2LoB/KQckjbMS65o7BwNFPlL8gXLXXnpfMk7KP?=
 =?us-ascii?Q?IVyHgyJ7bPJbmwp8F7EcQpNOUTh0UzXnP00U+5oYzK0ua3C+EYtJK5ZUryCD?=
 =?us-ascii?Q?TPAjLORuECE5GKGnJ7k33mbzQZqk8qSWKKxUchEIIZEabUdScoeiwzNyPhGj?=
 =?us-ascii?Q?5BblenY6oE3BrPcRsLpgnEREpe+zt6kbEtUWi8D2s83+qkM51/PfOcdcyD9+?=
 =?us-ascii?Q?3tM+JsA0Zi2cUbQKe+0AoPekvmYqFEj8eHJ+8XPktGtTSJIHS+rokleisXI0?=
 =?us-ascii?Q?epXoxZ9l2DVgmhlLsR7fZ9EQLiMGb3BcjOkL4tBenp3V97JE7GUwDRR/BQ4u?=
 =?us-ascii?Q?KWjODKMQQJFvILNsFvlaa8S8KGpp7e9F1ZUJ/3nCLxXM+JVP6nXpOX78FPCh?=
 =?us-ascii?Q?PUWREyvhMS8kI9nykz5U8fC+fARepmHC6IJjVGCzvpdZv0O0U9TW1bxZcZ1w?=
 =?us-ascii?Q?5VbMjPSi2/0F1/NJ+rhawcADeYE25OnIWnUTMIiCxc2gLjL311sgcDKMdTfw?=
 =?us-ascii?Q?1jJSxL5KP/MXGuK/TFfVhFs+QP4sB0N8Yn8wxK19ZOgu4ddVlqlX5TYvxRxA?=
 =?us-ascii?Q?0D/IVO+zmK/YRa3B6nmMocGM3nl3wzPZIVfk2Vra/lz4+WTLGNeXymhtl/MD?=
 =?us-ascii?Q?3VyNWcrXEmKnc/9mUxw4Vgxr2knThFULU4TIQnaQUFIL/+OpbZAHI9ABRfdF?=
 =?us-ascii?Q?PQgh/rRX0h8KFQ4zgOgSJOdEuzw0l8zxO6x3ykqdftuKIzw0k1oYidSpTXeR?=
 =?us-ascii?Q?FXqGBsbiBKty9XqD+HJeyZVJTYNVuFYj/udyTAPbFGX0eym6Cad8hguiWSG+?=
 =?us-ascii?Q?Dm1tKuz3I/IvC3MbZdaXmVaRZU2yToyfb+7N+b+6iJgfkL1a2od/hFP0H2Qv?=
 =?us-ascii?Q?QTX4sg9seTBUMQe/kTe7Dv48zpB46gArs6faZLT9Gnxk/VXztqr9f7HgHgWx?=
 =?us-ascii?Q?oeZDtmWNL/oKNXoaPaGYIfdLT9/hkG0+qElmdJlvbibuHLmm5+8K4Mr9c9+I?=
 =?us-ascii?Q?lYLLRlTt0ld6m5Kf9zoPdg3K7sysT41d9cGMLzqWO7pOPsDd5Ghx/NAM7Wsw?=
 =?us-ascii?Q?/wkFL7ZKCIi733GX3ofnrvBksgUKuNr6j74Nujk+5+CqC3KodFZQsZxKXdmK?=
 =?us-ascii?Q?pDpwbiyGHdI9q2+QWR4SVU7+2eG+EneWQwY/5Y8WErpAw3i9wkbIYsQG6TU9?=
 =?us-ascii?Q?aHgRsDbuUF6huxnmYqdXoqnlVozX1cYbPZ7BFL7O/KejCebxCab9l+NDWVyy?=
 =?us-ascii?Q?gTW49hTJMxcF/yid2umss4JprAZwxvN04i1qSSaLMbsmMAr5FIH7vLJ7i3KM?=
 =?us-ascii?Q?UXiq+EGaDyv0QJ7e6QFeZ2W1s+a2fRjzXykgiWSRUuHIfMPmrQsk7FCK0YCq?=
 =?us-ascii?Q?MuUPDLGqoP+WJzaIfQEJQwzPkVNV4ui/LOYe5KPCXCKFmbvuYLbGwx3uOVzd?=
 =?us-ascii?Q?bfEtJG3/npRQzc4czwFFlQNLxhUsInqdReHq+tCBeGvSjtAesVK+FNI6HK3l?=
 =?us-ascii?Q?eqVkwW979V2zypdYGfE36qIZ3mWmw8UXRs1SiTFR/NgADcai+zFHHiMw34Vo?=
 =?us-ascii?Q?ce6iMIOx9BlmuWjzMJcCWrsspIB0zbDQqiNUwlFx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d75103e-c631-44dc-6ed5-08da720d9c76
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2022 09:26:41.3838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6WEpTOSAQOjgxRtJEa6JcCXUEQfNiK1OAezkFtaaAZw1pir/OlTRGgManPyJ7XJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2455
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 30, 2022 at 05:04:34AM CEST, kuba@kernel.org wrote:
>On Fri, 29 Jul 2022 09:10:34 +0200 Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Aim of this patchset is to remove devlink_mutex and eventually to enable
>> parallel ops on devlink netlink interface.
>
>Let's do this! Worse comes to worst it's a relatively small revert.
>
>Reviewed-by: Jakub Kicinski <kuba@kernel.org>
>
>Thanks to everyone involved!

Thanks!
