Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48C6668BACF
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBFKw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBFKw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:52:58 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2115.outbound.protection.outlook.com [40.107.223.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEC05BB0
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 02:52:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTsL7zm2sITORzlPCsIRd25mihj7u085FxaetvsojK0lzBz76rIoJoUeDUD2bNb0RiY9bQsoeRGh9pje+5wDm6nLLa4/1yRoQLPcRuWEvLLXZKw9A1HZI/0pDPDmE8wEe36EamFsjE+Ur+1XmXUg1mmmHgUJ7CdYRkZk9dWtzA+KlKonnb7yAb7uQGgnVdoz9IY2rptFb3RYovXxrVQ498T/ewv3FVGHlU7wN/BnPsejS9pPOHrEayHocBhPbWP+BVLHt1PZyoF0GT9W9TL/VHTpNZ1UFKPzTUhsSUtXemrh7+tckl1pyIax+BICd2CbDnk+ZhOK5whOes6Uz5/P8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K8iY8pjC/nbs1tZSSt7qS4QIPpy3mJkhDaNvTEw0dE0=;
 b=dtzI6hP88XGEqajVUy3Rn0FZKoKfGSRZq8K6DzyZPt9laUURQlUWoNXLb+fJV6Nr6ebv/8MJJVuFhr0DsfC+0yXM/FMywrtvykDhhJi3O+T7ALTzBt0XkbiSCZeRC194nq/O+Mk16+N061nQjvtVcTqqRrmuvxY/PadVzMUUkc0UdwkMYXeXsV3CXhKXiq41kywKgV57So6uxo/KD7HNTqCm7KNi0j531ttXxBFTRePayweHl97fjlTmnuPi7c27C22hwGdPkj8/D7cw17dkMu3uqVVR2xw/i95OjgAR2PT9nw4H9tbFMrmg7pW97llVH8h4y+4nbTds8YAb5v1+8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K8iY8pjC/nbs1tZSSt7qS4QIPpy3mJkhDaNvTEw0dE0=;
 b=g0x7IQuECOkIxgsMXilbdjFN2rwpzjd6MDU3dTxHxnRPGSXdNGLsTsS8wSgsC23FgRY6lna9OnYzBjyjHOgJk9w7OChcHZR1w3hrl1Wuhu1Dw2fanXwR5ZBQI/rpW3J7VOjkoELCwgMupVgijXSczIC7viuOfL8tuNmGG8l9FHg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5049.namprd13.prod.outlook.com (2603:10b6:510:95::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Mon, 6 Feb
 2023 10:52:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:52:47 +0000
Date:   Mon, 6 Feb 2023 11:52:41 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next v2 5/9] net/sched: support per action hw stats
Message-ID: <Y+Db+TORfF4a6gHA@corigine.com>
References: <20230205135525.27760-1-ozsh@nvidia.com>
 <20230205135525.27760-6-ozsh@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205135525.27760-6-ozsh@nvidia.com>
X-ClientProxiedBy: AM3PR05CA0142.eurprd05.prod.outlook.com
 (2603:10a6:207:3::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5049:EE_
X-MS-Office365-Filtering-Correlation-Id: e9f13f8e-97f3-4eeb-91cc-08db083048c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5JJv5eGr1RN9rr1v6x9AlEcakfGGSahWOAP6g4a4GXEq1+xX4M0HdJfURLc/0dyY4FyguCspqKPomFCdV+i0ptGSd88rPxqftfBLg/JvroJYADnvwazpVsG4F1ARHIeoa2KwpZGqI1F2BVvb9VZZ/4h6NyEz3MX8hFoZZsma6PVByN/izYPsqwtQf3BF8MqFpVmfVgTKUS4qSzE+/MIse94nezc6RInpTfGeLaencZ7EOjWnd0dvwrWwMl32bW5+5DxNFt3okcNP0Cd7gkJ8aJrM44Jtx/6RCEhXOFVdYfVwDqxMmGnQRTuborgqbpcCMt/NmTKmRFwsFdkbqkZ4ARpb6RP8e+DUQfNJ2zTJvhwtJgMYEKOYA7jNRBO7lyeiVp+a3t/oY5K0U7YQO4ilAp8e/RiUmDfL5WbCBOScfRogbTs6Omtay4nV6kE0z01WXBMnmLmjAwSh+Ez9i/jwTfdLbz30UQDMGUHSZSOPzvumQxaK1zzsRyKMmCfmazQxBqvd/GqxvdRO2UGTKSCEiVsolXpOCJwAUItNXvi7D4u9yh4cXuKvXo+xIeMDuDg1tPkg44iCEUuKPlitXJbXtsO8OWdNjoNYq5sD2zJboPma6GA33WhGiZLhJZ41XBWaL2Ql92HJsej7m7lwrHf7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(376002)(346002)(366004)(136003)(396003)(451199018)(2906002)(5660300002)(66476007)(316002)(36756003)(6512007)(44832011)(66946007)(86362001)(8936002)(4326008)(8676002)(6916009)(41300700001)(6486002)(6666004)(66556008)(38100700002)(54906003)(478600001)(6506007)(186003)(2616005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AozAsxXvdQ3YBx/ZWDMIYR2a+KrbFUDd7+Q4HH4PcV2JLHbloyA0jwyfgCQy?=
 =?us-ascii?Q?esgtDQrcX82seievA0nRZbzLkScDo9Dfg/oNPERPg7hu7IMHBM5nvM5RKh8+?=
 =?us-ascii?Q?JVzwog1sZm3puxlr9/ekZ1TadE0egGOLhRuNIOpH8OoFSBoSFYsI6xnXwaCP?=
 =?us-ascii?Q?dRya5aRigu+Sin3Ub8EiCA1Dxiw3RD3VhSdWbalMUILKuRU9Rihu3XK4GYm4?=
 =?us-ascii?Q?5ZMXxI28o+TTv2yfhTKeAtUY43uoDSC/awLOQRCffltH3Yw9n4l2uouKVgw4?=
 =?us-ascii?Q?CftatCZ1PZeYd+nKU+yKaJM/PETbC5lAhGvayJh7nJ74puEVmjxU2+g1UXB6?=
 =?us-ascii?Q?cNy2n8pby2ZzdLieu83XeVefBYylJGJ7o7D2mSoOUvo2PHQuDiEeP0KJepyo?=
 =?us-ascii?Q?UFJ7Rh8+IqNawgK1Uzli69WDZtMObJNN+FTCo2kuHYS6sSfpXo3KcJGT690s?=
 =?us-ascii?Q?JQ6RSFE69XmJvrY+oQNCcJqNNBjSFXRT1YVm6XFv6IvSWpqibn7/PAGokO9l?=
 =?us-ascii?Q?5Pee5dobV7B3c/sVXBnFMdz67Y8O1WVpH/8kLygKTey77N7LQA7hdpabvnVV?=
 =?us-ascii?Q?BKw3MiSTC9Kk16uxzZRl/tOQmy9FoTK8M0iYovI5OSLxmkI/Kh6d0zgf+Zo6?=
 =?us-ascii?Q?kQciY7DbH25Oc/+rBT+3TQoFydrxZ9l6q0y5m2hHAK2ieTX3ULZ4iRPzukPP?=
 =?us-ascii?Q?H4OusTGZKbZgl2wtfsZjvX5JyQJ9dneZMAJJQPHyXVlX1IKlZ8QIlYNgXDLm?=
 =?us-ascii?Q?ak4dhMYwJjAyTw80UuOPmWlQZk/PXEghm9wwhBD15CTP2z6hSEyEWWFSAomk?=
 =?us-ascii?Q?Hyy8543V+D+1kBHO3odGti9RYsY/zqnLseq9srMNOXt4HHG7YGGX0C9rxmY9?=
 =?us-ascii?Q?sMe0LsL1npE3MDgs5AoVTQJn/rMLXx546pSmoxLil++4Iy78YpaQuEfON8DJ?=
 =?us-ascii?Q?5Rk9SKR5tV6xMmLlT06NjzXGtHEYTNgbIMz4/upUvzlwFGrCE/s/P7D7B56x?=
 =?us-ascii?Q?uDddhEk/Q/1f+kRyPbji9CBSJzXp4gadsEMWkKynuFALT0wgexb19Agn/k4P?=
 =?us-ascii?Q?SPWoWfxkwSv3Ymmuq34opE38iq0YPzJjqHS2H5oZyDuhYEPOqXBoi8RCcu0f?=
 =?us-ascii?Q?S93xqxOi5U4jsmjQ4MqFb2enpL5ovD6s9CA3WBQJ9AXu3+Bkz6aiVXu4noal?=
 =?us-ascii?Q?/R589HT4F/4vOnAorv+mlmze0BrR8sw6q0LP+ew2RDR9pc8IdFI+2sZ1IAkh?=
 =?us-ascii?Q?zAGW3GshFbX5Vw+1pdhJqNOOPIe8LCwtH85sJpCgDiJEFkikp37DUDqQ2rI/?=
 =?us-ascii?Q?oXP3OBiEoR+JGXT06/HttD7qa3LnWLBRPsuWizhDJtlOEndc7prRRmopJHpy?=
 =?us-ascii?Q?Nswk0J+Lj6Q+focwkAVxsNYYG3Or8Jj0We+yCyFiETQGLweCOSI+aRwgGgYD?=
 =?us-ascii?Q?hrcJ3SBWasJTl2sa5d10ma4x3vcmy8X4DQYK3nqf2wMdrsP1TNuK3hqf1p8j?=
 =?us-ascii?Q?yGvhdsiDb3BIOWQ3yAIoqCWexwCw2W3bvr4Mo66ej+OV+yhnB7EvpD8KDum3?=
 =?us-ascii?Q?gzrtaxJfUH+NhDKf6RIfWMNW/1T0zk7OMkU7+jnLL4HgBbArlIkzKNha4OwD?=
 =?us-ascii?Q?cUPaGOacWmbdAS4Zvw8Ooy3UkbXawWlLhoDGXJEI5gJCgDrYczzdLKeej8lC?=
 =?us-ascii?Q?UYbkuA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f13f8e-97f3-4eeb-91cc-08db083048c5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:52:47.6979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iu+O/iexm32Ht7/jeAmGBm+Q/lEygDMCLUbSZIlx7vLfUWqL1Gxz5dZnaNkT5RNNuKbF9R9hLYMQZfhxAzRREW9zTuCHMcxQ/9al9bJbRsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5049
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 03:55:21PM +0200, Oz Shlomo wrote:
> There are currently two mechanisms for populating hardware stats:
> 1. Using flow_offload api to query the flow's statistics.
>    The api assumes that the same stats values apply to all
>    the flow's actions.
>    This assumption breaks when action drops or jumps over following
>    actions.
> 2. Using hw_action api to query specific action stats via a driver
>    callback method. This api assures the correct action stats for
>    the offloaded action, however, it does not apply to the rest of the
>    actions in the flow's actions array.
> 
> Extend the flow_offload stats callback to indicate that a per action
> stats update is required.
> Use the existing flow_offload_action api to query the action's hw stats.
> In addition, currently the tc action stats utility only updates hw actions.
> Reuse the existing action stats cb infrastructure to query any action
> stats.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

