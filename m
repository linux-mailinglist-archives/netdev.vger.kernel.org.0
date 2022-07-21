Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D91B57C5CE
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiGUIFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiGUIFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:05:50 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15CB54648
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 01:05:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hiNQvXj51NM/ZpTeHfH+8hyIUhWWamje4CRySuG0y6OUwbMY0wX5j8kMC2NKjRPWX2OlGy4hMdPMA/I6o6y+xxM1O7AIB48+N1MvzuFrQ6uHXPaWPAjzYaJrI5sEyEhFLnMdvdnFI/50VWBMEYml387P9aEItOgs6NDbi2ewdWtXOm7foCgNYEf3dTmanurmTS430zkgfzM+Tnzp/NOuGBLv4sIzF1kPFaXuz3ZH10mwSn+mL6v76n1lmRv17Aprm23d9O1QarbmWpok/zU/G65DuQ6dOmYnpek4syfeoZvUTrGz3SADq92PAPbsVAWrIP3t8g7+2YfJ00nl4PqwPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9t95SjDeLVPqh0eiyjoo9BX6WcRlRMx5P1ix3rez4cg=;
 b=mK6/prUIJtG4zwBp6LOIwGbaRUPxC59e7rxxeZny4XeNLcQkx2LUPlrNOb3ehUjndItjxJ9sHg8Cbh/uCT7c6+bgcApH2SrCB7JZUc1gdng2gf7ykOwm8n0U1ODc+hkUd9FPrfpTrmFWYIy61NNGPOM0MXGSps0PFfuJ4KLTq2gVqicDMJzXLIFMrN0HZ8pyk4Vn/Ea1EXaWUQf9WjBZuz58W9YnEyADQHE0tciVz9AUO5BwmzIuhKJnxMTQYeLQK1oB4+dNfSqPDon84Jg50GkE8dlpWYHftuaTVBy5m92aWTAJvfEQWCuEz6FB9KiANL8XfBZJXYtB0AP7dYirVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9t95SjDeLVPqh0eiyjoo9BX6WcRlRMx5P1ix3rez4cg=;
 b=BSg3MLUofdHZbpwDSNhWa31Lwx7Ag6uVL48CTCW/MwQNNKwxSy/5RkpmuX8uvN1VWmYATJpXLggOpLyLx4qeVCRMNKEtUfl54GpyRyhstb12E1nw9vn3n7fUwI0O5gFxy3oeHP7Yu/JZhSx3sTr2eovrx6AsFLpwNNnVeF7bun+ICtOVwNTTbuNHvAwup8O+qzMCsXCsdUOSguYcU8JeJoOA1Ey4pDkyT06IIYcXqlsmxPPeShMOkzKbEUVgqghvJCo7AOHsHeWjstqeKctgkmsWf1KZEN23vclagMIRQ+RdqyujnymV0de4teFTBvBe65GlqUj5pRebTEVbynjUuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB6533.namprd12.prod.outlook.com (2603:10b6:8:c2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Thu, 21 Jul
 2022 08:05:48 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 08:05:48 +0000
Date:   Thu, 21 Jul 2022 11:05:42 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 04/11] mlxsw: core_linecards: Expose HW
 revision and INI version
Message-ID: <YtkI1mNdaZlp+3u/@shredder>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-5-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720151234.3873008-5-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR0101CA0078.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::46) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22b7814d-fba1-4c21-8c21-08da6aefd241
X-MS-TrafficTypeDiagnostic: DS0PR12MB6533:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s9hY3Gx2EqY/J1RHYlC0D9v+PDEH3BBpb5oZf5psGdHx7jZmz2Lxu2sOcUB14Jjlo9u3ZfG6Zl9XHXvV70Y7JiLwTyE4BOkOx7Fcw0uqzejK0128IdGqyqagUldC3ryLTQkwxfUus4I6qnqAzNm3duQs+52czfNBw2bH0sNBhxYA7c5p+Rs6cPWSXkzD4jqXFzuAVhdhQ1Rnz+gPkl2deFkOXGO5VNL70OvZMiy4auyzcs9P3m4PJ5Bd5MoR49ReeQ9J6sKOqRywYSzMNf0Lbn5iMlg1ODaM1NixbrM0Rk7QlueNVMW07wPHOS2OHMzWZYNQztQRQDQgZoRvHlAs3lkSftzQHFJtBqKSogWTuF3GbW1webSdE+qQvQ1jw82DOLCGlTyPy6vZEdyvWY5eW5vhq59Xz8/hfHnai/V8luVeBufDoW+UqH1e1XhZ8SXbt3bZbWQ7FQOLtAPYXCVdWVA0qGaKfY8QgchU7hUcOUBj8AugMORdL8nvJHrlMG5fkOa/aLuu5rnlJ8YNP1Oiqs/xkbVLuVwpG9u7se8QvNIbjXL04Z5r54pO4rTe1HKyzkzXXTqhx7Iupx1nRzVaVLzFRixp/oOzpcCqPaP0OmmzAY8Wmp6O3KRcjJY6beYkiB8m/2kr5uTwBcmpWtiZtHzwLvlJbq+sDA6AsoB8WafNG5dNcbUHV/9r1AM4RxI3jdxe3xU6I37Vw+tks6JApK5RuNBl8IuuF+caYmAw6CqLa98lRR96XZw3XeJlV8r3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(6512007)(86362001)(9686003)(478600001)(186003)(6486002)(4744005)(6666004)(41300700001)(6506007)(38100700002)(5660300002)(6916009)(2906002)(33716001)(8936002)(26005)(66946007)(4326008)(8676002)(66476007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1Gq8l9ptSnsu+qP2xIPCa9bh/pr433QhAS6HOFSFZfgRM/gBr6JqYZf2oHe1?=
 =?us-ascii?Q?LmxFIZsfSL56tfVSWBla2zUDcjdst6RO0LeRAryhupAYZ8w0FrVB/GZfJguK?=
 =?us-ascii?Q?UwCnsppumu+oboa4IjN00TfTIlnzSuPJ4SW0nnJ6/Wd4Sn1wVxtS9mtFFSQO?=
 =?us-ascii?Q?a0Iuen6CI8XUsHT6yZvXIy2liGzNpNYieBGwIgA66t357XFtAKD+FRBQoYNV?=
 =?us-ascii?Q?LdK9rm5povc8AVTmugKLiwGXAMGBqdU8J3ybiDYuZOb2Gj32lFveqUxmpqqd?=
 =?us-ascii?Q?ScWErn7WUaSyyp5BFWhmVQNnu1tr1z2BqAn3hNDRmzTuyJQOgzHqctMYHw/j?=
 =?us-ascii?Q?ht3d4eTKYa3al6t5fGaVGG4eUe7+RGPlJnRKu8RdFY+76eTFd4rRcUUPtrU9?=
 =?us-ascii?Q?mnjl82eTQw+Iv1oVZSRFbrnJ/TzDo1X4mhnyPhKsvMzDP0fEo9gKvfpSLrEe?=
 =?us-ascii?Q?SRDrCjxgFh2QPY5AsCgFxj412SqkrtDRGL8M7fSsS64nPhAJDtNMn3waU3oY?=
 =?us-ascii?Q?NVgETIYYbh5/uvdojWQGd1duv2hCo8sUI7Vp0pVXmIu4cZZRJRZ9QPW4wEnt?=
 =?us-ascii?Q?t++LOFhVClLntJaLhpHnZekgZDx6WGp4XS4S0X7T0VbcFXGWCMIeBSgIptS+?=
 =?us-ascii?Q?9FkN5OnrD70bCe7NRjbpynRjd7NfCiq7rU4AE+AUWHPMF+Ni7IXZoKbpUOCL?=
 =?us-ascii?Q?ghnARFZm+tPDSaHYw23BQrBcpkhZ3NFM41zGA9JE7laUKeB/VSHgychhHe60?=
 =?us-ascii?Q?IewA28CQtLEaDfsecNBlKXez5rvXu75VmvLgueooMyHaF+F3WPR1NYE7p1Fk?=
 =?us-ascii?Q?TT2yPCQ2WvUq+/a5zimb2+907Q8sxafm6tDCegrH1snSdhGt9a9IwjCyMAVP?=
 =?us-ascii?Q?jgntXt8L38et/1Q0lBVboJNyBBuamJpLhworHMeVtzBL1Yxv/ka0Q/2KnmNT?=
 =?us-ascii?Q?LzIYECx5lk9IZLeAIPmIVuAG7LpgegW/8muMMNdVmJhmtQJQ8t8JlQbnq5XM?=
 =?us-ascii?Q?LqoJX6ESqY9VzCjy6g8HK0QJqm721VedBq+9Nnp4F3Wye0eCa/+vL4xPHBMl?=
 =?us-ascii?Q?cBUrNOD3Sq9QjI4mJEF9+4fWLuQ3We7WRKBXNlMpaTYY3AGMZyC3r1IK4kRp?=
 =?us-ascii?Q?ct74G8cX633yIMN0NxAZJtEmxYcwXGWpuskjrhLdoXVNo/v9R7sGhjsQztBX?=
 =?us-ascii?Q?EesiBZ5tNGfIL/uO+D0FRqcZQBenzFRW6Xg2tkTsUse/9KxBcdGYFEv9UlZT?=
 =?us-ascii?Q?/aZdEbEWoWIMSBtIuNo3PtUZQB8c9XejYNFq6CdGBXHWJZfUGs2jTW2Y5BSW?=
 =?us-ascii?Q?t8Crnuh4JlCoeaEnu6CoBkn11yO84bFHpa05wqPodb1uAeyUw7cU4Ocksp2q?=
 =?us-ascii?Q?bAefxWiMwF8zAxxeXzwxTkIteKmfKgHf4RJSQKRa38J7BiO33g/Wf9C3cc8j?=
 =?us-ascii?Q?v3dQDbF1ypImL3YyWR7H8H2gS+tEEbUCeQc2WFnZsPBV3/k0runLq0nN9nnu?=
 =?us-ascii?Q?lc2Z5zZkH11Pbah8fzQogaJDSX+BYERSMeOn0agavzCjsWR6lOsIM80P7s7M?=
 =?us-ascii?Q?U9I4x9jUJqyRk6ieNsd2otfr+dFs43bNj+q3u/c+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b7814d-fba1-4c21-8c21-08da6aefd241
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 08:05:48.4678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ilv/EfPi7NuUfneUyLNuMN+GB6c8f6y/5GLx/J5Bx4bHQnhHx8eMLzeyJ1aLwU4D3HysicIrdqXO1J9LflGH2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6533
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 05:12:27PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Implement info_get() to expose HW revision of a linecard and loaded INI
> version.
> 
> Example:
> 
> $ devlink dev info auxiliary/mlxsw_core.lc.0
> auxiliary/mlxsw_core.lc.0:
>   versions:
>       fixed:
>         hw.revision 0
>       running:
>         ini.version 4
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
