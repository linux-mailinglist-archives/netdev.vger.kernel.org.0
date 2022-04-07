Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89444F77BD
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241973AbiDGHkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241976AbiDGHk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:40:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403BB37ABD
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:38:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jK0psYbHgGP3u3h+/xjfWXCv6qY4LEohTc2OcZmhnBmce+8CUb9p/OjFIyNTo33vRl/qJJgVPgVjt2tvBlQ8bSpxynK07MHH+sJ0xqrreV/iQWlTmDl0lUmxHq22fXB5s47kQOI737so+eV8uxCciy6b09hz4I07ZkcDci5XJd2LJi0EgrCsjSKx26aEv2efZTwuoCJMEF2nBPhM1sYeJVrMxSvmpH2D6Wz2qLg/Kd17tT3MoZ1eV+TWzW3LACrkmaXN0qND6bWrqjb35u5iOBAyiQ/pcOQoydrtlUsuJapLY6z9WugqwAFz6o9ng9CZwkgEr3g/c0Iz8vnMnxTniQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lu0R+wJsAbu0+xvNjIjLauta2rmdenitXyOP6L280q0=;
 b=XdNrQEvrpUKSzRPcl/zI/XMrX10ApAO0RYopjfHcZtGJJiJsNCm4mtip63jy9aEkpXqpdLvWWWVMdCxYXW2Yp8gjwkr4sM72cNLSSAuWSKXMhTDWWzuxxcYnD9szPPeigTr9ogub55tUui2kaC+cFvrHXFNu+2WaKQDNVcgG1YGUHNXQAW/qo7KD9NVYoC9suI2HIuQEG82xuYOSWGAI5STdRZn+AC5OyLEnXQL/0GbuKOB7sILsxqO58tZZ/Ds6fZ+/dRW6oH4/K34Ow8OIAsi6zrN4LmWoxBVGm75bk2IpzXSJEJS4y6PmbkSz6SbhY30ZHaL2Aw3LUOSo1TIYqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lu0R+wJsAbu0+xvNjIjLauta2rmdenitXyOP6L280q0=;
 b=OB/MghxXW9zZz/wmJWliqCZsJRQreGzOh4ICxqamL0EZCfgZ0DdsBKM8m9gTEPtrVhRxnDeWvDFbYmLwxGwrtnY0j0IoC3wiYgJLsgFdJIWMkSLX4X3iZoEeP7t1u6JcaSY0ER9l3GudFgVrWRaiKjJWd00GrtSWarHxJ25qGH4r8zBGZ3bG9NJd+UlWdYdh7X49on5WvUcQW8Z6HBsBzxGNk62BpcG661TVReopdZtJLhXQyxSIsQGSIRoKIaIHHNkDfHBPdW14WCh6oFdrpvWbHNF8zStpw5ACesjK/9FWPYU/NM37wnGa+FbStTiwNMVz1EwGHayk8xdgXprvww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM5PR1201MB0188.namprd12.prod.outlook.com (2603:10b6:4:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 07:38:21 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:38:21 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/14] net/sched: act_pedit: Add extack message for offload failure
Date:   Thu,  7 Apr 2022 10:35:26 +0300
Message-Id: <20220407073533.2422896-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0001.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::13) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 086d814f-cc93-4f14-1879-08da186996dc
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0188:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0188E132CCDF6E99C5C7B6A4B2E69@DM5PR1201MB0188.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YUKdKJh/DtxyMhu7Yulia33LwLmuRBP05ZvBmDdcxO3Fjtj/Co/ccssN+vNLvgG3vv+eMpboqYsTmeOQUZJwrbu/Sg9X73qtRngX/KUPxBexj7RurIgvnmb33qxg4XUcTEiEnI0f3Fs6V4o31SBxykqJcuCAZV8rx0w9M1R2OBE445Rkyns0XAaSU3CuCJdgvwiZFOa1rvAxjDNEIhw3LN1Y3LKFNLO9ecO91ww+FyJ0WrvQHFnzplUYm1RbX+MkdU498EsnXcaXfm/bPfxEuIlNGI2pkLcAQLDkHTiFSpG4Ds8t/0DuViukNb0Exq+b+msMEnYc2Gf7drwHSykkrqhO2zLfTokwbVv070hWW3oP477o86zpZsu1/vyyYV9922klXfr1quS5lcf4l0jqtMUqUtPB34hEycH0E0NO8P5M9LBi77xAX/koDcm35veWaXvstpE8azJJ7LScp07VpGpOqn4hW4hx5f9hS0kRyJa8f6jxl9N7xpx4CHFCMvzaFd3fu0Pbc5apeofrAHBVx5xiB3sbQnga3bZMgeUkmCCbTv39PCFfaNA0JZABP4tQREdCrtAq2IWpS+S0xrKXvOKsSq2KhdY+X509pidKsFYhJWWdSKYmZp1jmTjJxutQXKFTmKMX/DxhuWFgA7zFRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(38100700002)(186003)(15650500001)(26005)(2906002)(6512007)(83380400001)(6506007)(1076003)(4744005)(36756003)(316002)(6916009)(508600001)(6486002)(4326008)(66946007)(7416002)(66476007)(86362001)(8936002)(8676002)(2616005)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vw+7OeBfbwhbaewI3Q4y/7mfSmZ2GhWJfQa5wQakZuMNyDOMLthtHJI9UWwA?=
 =?us-ascii?Q?FRCQHGqpvrcnZbyaIxl2/w/YdEP+sP9pNONcMslITnNWbmrVc8N8r88Ph8A7?=
 =?us-ascii?Q?Fce0vTfkq0EtUJGJ93job+2dv31e1D+IJrsPw+JOzIE7UkCR7uLDPZNv1DXm?=
 =?us-ascii?Q?+hsCBqNm2ArLl7H2z1NBphdpBZn9/Rk363ge3Hyp5NEs+/OQp6lZaF+8Ub6E?=
 =?us-ascii?Q?nV82wyi6pVwaM9O2+pXp5cpbC4zekuPx5IIoWVEfmphzhEkDdR5hkahrkO+x?=
 =?us-ascii?Q?vKLntMNCb/VTt1kNH992Weedw5tglfYztHl4knuqjRJVZcjXBx0vm0qU540T?=
 =?us-ascii?Q?yaCsTgxWHnZSY7bTkoVwAJwpDyCh5L86OMggbpg3ydALEauRubRKq3gE1zZw?=
 =?us-ascii?Q?D9moQ+atCjA+rFauyVHQO43Wvu1RGUH3ULFEMQj0tXn9MuY70m4UIZwZe0S0?=
 =?us-ascii?Q?QEuV3JBLXxrpubNUjOJsMMeylStdeoINhztkdFR8RSFm1IanbemVm4nthcMV?=
 =?us-ascii?Q?5u8t26zlXbL0FXUA+9V4MqjMMmTG/bB8PxPSCcoo/aH9uQxRwbHe5ey6OapF?=
 =?us-ascii?Q?fY8FBKZBJULd8CwcNBxKAqgDVhx8k21Pz/GfpLP1qRImZXf+w/wzzhGzLwZy?=
 =?us-ascii?Q?qZpczBvK62AEV3dXo/8aah1BpopwXasiaKritrDTgCNioaBVAg03ifDgMZpQ?=
 =?us-ascii?Q?3lAevsvC77g7tzcymGVtXlwZ1Y2TnXlpC78p9YfoREUJwyHx88CO3kFGaink?=
 =?us-ascii?Q?KaksgZDF3y15yRq2JS/5czob7yctSt5+G6kXxTRc+YOg3KNX0L5YivqY1ZOa?=
 =?us-ascii?Q?7kALd6lAiiqm2GgHsKrea7KWXyjrKy0KjHafQLYmCPOvLMIyNVlPZXgtHgxS?=
 =?us-ascii?Q?VyX80qsN53JECd0LHGlbO5B9jgyakEpCmYOY0yXeJEHZuZYzBDQhjA47kNLQ?=
 =?us-ascii?Q?tLQJmVcQFql1e1hBkRjjB7Q3q2+/Ds5CHSIM6oZaC10hCu7rZcT2fttx7ZA2?=
 =?us-ascii?Q?id6Ptdo6um90rtdEJvc/InLlwG7A7Vl72k7NfQoIE5g0LoHJfnOSHr3xSu1D?=
 =?us-ascii?Q?gKR0ZUpmlv8GZbw2+mq5GFADgrXnlTJ2zyNDfPLpIVrjzKoJWxZ3jBgph3Y4?=
 =?us-ascii?Q?aVLIWBy9+DEXTiEt8+4MXJyM/m1FqwIIVxSWe5liq7Rfv3Fea+YZauZ/qgAo?=
 =?us-ascii?Q?KY6EZjxXurUqSmXqIG/nu8Ecqes4qvCAmWTfnDJg1UWVkzldx8uv+rQo7+0k?=
 =?us-ascii?Q?WwUehSC3VbldVtGBiqMMujPPs5TYDjeBOPlNlLCNGfyK2AxMjM0fasgpz+ls?=
 =?us-ascii?Q?9MDHbWUaQ51DffeUrC8F+M+8hJU6l7QCRx5XubekTWQ2g5jTe0XSSVlWn6ie?=
 =?us-ascii?Q?nZyOfi49DCfjRzEGzOpxELirLMPYNZ14gJufCfKqFSSWzSeY+fqb1OXuCvcI?=
 =?us-ascii?Q?yh9oxr6XKWc1pwK8KhLJaMm3rm9j32/bbzwoiiEK2nqgjfRD8uy7Ti6S+0w0?=
 =?us-ascii?Q?okwoMK2l7TFQ7lx/bZcn/lmbSjWLRXWXLnXdh9wXZEb3YI8zsofYYL6TrUAH?=
 =?us-ascii?Q?z59GM8+Rx5J+yWu2uepO4lIsEKJssMPadQu1CdIKxdRmrW0tZzT4hXR9+pB4?=
 =?us-ascii?Q?dPnBYOkWHnttHb7fufwIG0YUUk0uijZI1mGAPtoqIKBoi6vEXV3TVngwRRdw?=
 =?us-ascii?Q?Gxgk35inRCaf8OpckLDzkHqRgSxkcp2MsC4k+OhfvjPKwZvMT+syFIYb+9h2?=
 =?us-ascii?Q?/WPkFu+6dw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 086d814f-cc93-4f14-1879-08da186996dc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:38:20.8610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1aaCIqoVk1SEJy8HzJ095MBGceY7ViOHmRgh3jjIu/XDAHCVKl2ha0ZejzlbUJGibXOeO7xAShUCKvQt5+yNEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0188
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

For better error reporting to user space, add an extack message when
pedit action offload fails.

Currently, the failure cannot be triggered, but add a message in case
the action is extended in the future to support more than set/add
commands.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 net/sched/act_pedit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index dc12d502c4fe..e01ef7f109f4 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -504,6 +504,7 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
 				entry->id = FLOW_ACTION_ADD;
 				break;
 			default:
+				NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
 				return -EOPNOTSUPP;
 			}
 			entry->mangle.htype = tcf_pedit_htype(act, k);
-- 
2.33.1

