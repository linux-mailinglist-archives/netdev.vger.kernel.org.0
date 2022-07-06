Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4137F567DFD
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 07:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiGFFpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 01:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiGFFpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 01:45:08 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A9517AA8
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 22:45:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdSmp/6LvZQOsLpZwi3S4Rb9t31IGP91uqO3GahPG/hAcjPN2Cpw942sTXDoSqUY1Nv+/fEK0mcKquvBrtQuAuJP2v3Fu5gQ4ytZWfYd0HYlAHiKVYpvDeeZFLErbZDlW1xmjBzL9FcQyC1cAXFukESl63cLyUnfdAPtEw5361pvbYXaCkqOXh941AMdhIpvqwauG78o7/dGm7B2d707Gh8buFejL1vo1yyKsblhHQ/EwliL9pcW03cW5lGHAPbN2Nn/EYe3ojiLRoNKV26UwviSmvUB9c+yD9SOutuk2Gwv3oWhgJvx9qe3rNgUMx2tz9Dw+ODTKcwHLV9NKcM1RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iwHZkZYMtp9VypRWXtK9GDlqOjSik4fYxUbqL+P0j+g=;
 b=iMfChfbhKTIfAGnf7e5V4dtlYHeCvEQUAgCbqyBY1ovgyINKNr1twepwB6S9SViB28Cj0AMR/5HSxbyDnh1G+uPKqCcfEvVpmj0kcmaj2INRjfmgDttjakOzZ3uQpWJAuAhmLQEgHFqDfYPZ5pg5Aiq/cB4wkDhnzQOykTEjsp4+eMm6hCOTDpkQFzBW4FERA5+uhcRqoNfu1YVeS08O+6crz9YQ9lf0N9Pk7nhzXGqr2IG+h/6gvyrEdAy5taM65tjw0l1VU2QKBKY0PxOzC6jFBQPXDsL8SBBNLa39uQ3dU/StK6Dyf/KXp6uUq6h0BH0NiAWy+71YmoFFK0JiRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwHZkZYMtp9VypRWXtK9GDlqOjSik4fYxUbqL+P0j+g=;
 b=GkEL9yjbjoa6tcJroTEBPDmFBHoKlNtnNEM6LOuGX4N34oASwIvbMif5y2uV+KLQdRIBPFMvWa7S6YptFkkxYq7AxMM6DMg/2S8U4HCDkLOlmCiW6kheCZHMyPVeT7shTiMSjyon/k56SEFKvpCsZG+siZyRSCnpFdJJ4aVWJAs7x4jJv5L+X+/DOeehZykx/pvM659rK6hq/sII5MYahGyGRKGtBY2DAPSTUsYCSqSFrKOKWzJw6gFp0Y/h0lhGjgPfa/judf+Y/FxsgZ3fR8zSHeIh3VXGUBOzHUVKaBiKK+Fl4WFL9Oma7EqaEdyNY9modjnknylCNmEAgPyoAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MWHPR12MB1263.namprd12.prod.outlook.com (2603:10b6:300:f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Wed, 6 Jul
 2022 05:45:06 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::3c4b:7012:620f:57f2]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::3c4b:7012:620f:57f2%5]) with mapi id 15.20.5417.016; Wed, 6 Jul 2022
 05:45:06 +0000
Date:   Tue, 5 Jul 2022 22:45:04 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jianbol@nvidia.com,
        idosch@nvidia.com, xiyou.wangcong@gmail.com, jhs@mojatatu.com,
        jiri@resnulli.us, netdev@vger.kernel.org, maord@nvidia.com
Subject: Re: [PATCH net 2/2] net/mlx5e: Fix matchall police parameters
 validation
Message-ID: <20220706054504.q4vz7gpqdk7udajf@sx1>
References: <20220704204405.2563457-1-vladbu@nvidia.com>
 <20220704204405.2563457-3-vladbu@nvidia.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220704204405.2563457-3-vladbu@nvidia.com>
X-ClientProxiedBy: SJ0PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::23) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9658263-0f89-46e6-6175-08da5f12ade9
X-MS-TrafficTypeDiagnostic: MWHPR12MB1263:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oD8zz9u07eOUymY59VUACnEvdKNFLRnuoVb7yVxvSYg4ka41PrU3MD+Nz+ZDNrrc8xC2klrsxZWlKrL1kKzLTFwwleDwWHiaPyrvXMRnklNxURMfvzHtH2dg8v3hi15EBmn+7/44nLqJ/W0JNi7ohti8wLwyND4xqodUdvRGdfmAoJw2KpOLXrnEiH2jd6aTnakbtFmOVSZtsQFzIC6i7KqmI9Qopt+0mM1XusKGx+aI17459HdBScbGGFRJL2QoPxFdZ7owLFd6C+e/C8Pm/ym+yr4Tq8eL7d7BsiIbCA+4cES0AutjsVnJMgPzeQ1bFMUVHpIs3+OB00DOREiaX4/bTCRoR82N2qSS62ER4oCXewK2rvv49T3GKTEVg6gMYtP0+ucUrhnuXOQn/RFpWUaPSV7WaLlOA2GcfOfL3wkACJOkDDQv48gDRH+uxdd+yRF1KyiSFBp5UVisfOyjn7j7GH8DPZelz6SNdHd+CB1HyqjMgB680Elf6iELJI5Lkb+5bGVSZC/YdRUX8HRkX2pTa1w1YrUi3NFGtR4dETBHVfCPOONfog7DKaSFbcAxLls+RC6QNHabLha3wFkG3IWrOTluDRej+B6J5qlO+PKFtwGUP8Gkb7H4CRT1xQWkHypUpw4nzgISEp8mrHV8k1kCstgKx+N9Ce0uwBPcrh8oa8GxM7O8HJXiSFpYH019pV4L03WnHo1S/SbuSLCsWbB2up9ak6aJ21l93zF2+II9wq51ftyfS4oz94xqDtfu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(39860400002)(346002)(376002)(366004)(136003)(8936002)(41300700001)(6862004)(4744005)(478600001)(86362001)(6486002)(5660300002)(2906002)(38100700002)(316002)(33716001)(1076003)(107886003)(66476007)(66556008)(66946007)(186003)(4326008)(8676002)(83380400001)(6506007)(26005)(6512007)(9686003)(6636002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UPs9mleWALmuMpoHCCxjazJgQElk8X2J2a0/z6w9ReIro+diiaQOyeku9NTk?=
 =?us-ascii?Q?aXFif9nLJfXelX36hyII9hVNCzl3ATPcyCoRwYpdrt6eIa6MHY1HJk1+0LzL?=
 =?us-ascii?Q?tAceCgTV7MjTpevkstFNQplo/VyIlb4kCIFbbkYbtsC11QzvOnGF56jMQ993?=
 =?us-ascii?Q?GmhGRCDSYHMqArfakINj1WoiKW+RGiRJZx67EExbZPDQBEPUNbd+Rcc465Ex?=
 =?us-ascii?Q?v0EjXI9Ycb4atqc2I9kqcPVsHIIFAvo8CbP4E+OTlwIk0yEcSrk3Yluiq70E?=
 =?us-ascii?Q?Wu0gfJazU/kDFXpmQHxx6/mrKx+kP0EstQWRieNYyaUzYbXUibyyYlczK/AB?=
 =?us-ascii?Q?ESkz2CQB7JnsR3DEwqcCXG5YqAW6LGIZOwnFhTQHP16XbVoUHmyAe9wPCyB2?=
 =?us-ascii?Q?MqA8H+J5SrheEQaRPbwfTkGCackcjzqFMIjrFGaxw3Ca7rEBcXBI3ATk0qiB?=
 =?us-ascii?Q?qJORTnAmjSj+EgVd8SCcownZwE9uFmLNbT/AUspZyzErKpkMHtpT144p0gjs?=
 =?us-ascii?Q?m+mcsu6qE/llvbdZXW5h24n8grv5xeNMgaB82XMj2cYegtttKsCCdZyJ88sJ?=
 =?us-ascii?Q?41qn8xvG17w8cnct4PPfSJyBMnnGSJbPeE+5k9MkI85yIHHIx8pABn0Buk1N?=
 =?us-ascii?Q?AvGb/6vtBQ0FQH6HYprGeSLvAttfGq90dieC2mkP0pUTdJi9FO70Y5YUvh7h?=
 =?us-ascii?Q?AjH7Twiw78uA3Z0sWLJq7INC3yCrvF8EeXLqjlgpPfD3EWXG4Wm7G+iN5Joy?=
 =?us-ascii?Q?GzcVsYNeaTshsbD7ND2mdwGqLa4jAgrwuxfA/+FREs9UJHGvyZt2oVcsngGD?=
 =?us-ascii?Q?COF07OnwXBCuVOqN8QlaavuK+o8HlSMJ+liLBXB8Gn3queXMwCPEx7EHFTfu?=
 =?us-ascii?Q?6iQ5/opeQfRDqwXrcrHRuiwSOpMgEQXQzSyJqO5LjGC8gEgZf8WKfPIQKZXC?=
 =?us-ascii?Q?Z+NCTq1RYcm4MK7Io0/82iC5BcpeQpBn0ErbCzF6y2C52FyQuxlwCxXg7VfD?=
 =?us-ascii?Q?emwbQYG/9CH5l7AXJAb1TB2WMTqr8LXXvQzDf4KJnch2+pXXZRNWjYiraf7g?=
 =?us-ascii?Q?LjT13wPaLv4mgf+SQbrYn9ajsUdBwjswt35Vf6JNIOxX6tdssZh1eyiyCQUH?=
 =?us-ascii?Q?RhmftghHopAM5lH23TadiZFnQTx+1BKh7gaqpMeoV+EZ6VPK+mfjFH8zP/pH?=
 =?us-ascii?Q?CmB7yDke+p9DbyE+F2/Dx6wxjUQwZJubTThc5hGFOnu/C8tBCH5yghNVdmWi?=
 =?us-ascii?Q?ziEWfJTjXtPLzYxCEMzNMeGU4G/9CyxsbJx1DLEDtlQ2en1f3K4wceUJZNQF?=
 =?us-ascii?Q?vi9HI0TyXv5WA+uNAFnB3aBgkrd5k73Bn90H0aivnHAjTYQsBvkmfF7SYU/6?=
 =?us-ascii?Q?A/BiyozsI9cRRdxRHbsPHWuOcyQlc99ZDwM9jTUUmSh/bmhK8+0KRGX0S67M?=
 =?us-ascii?Q?HZkDSsHujm8v7lzOhHXln/gwBHszEChPHAR7zW3uXdTCY4UR4sFDS8KPH/dg?=
 =?us-ascii?Q?rLia2tUsp0WBSaVOJnrXrXCgtyZlUKgB3AY2LHwoFc13SAYd/0QAQdg7m87+?=
 =?us-ascii?Q?ftD64XUXA+JQ3JJrsSW+Tw/JoGgm1th3ggSnMxJj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9658263-0f89-46e6-6175-08da5f12ade9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 05:45:05.9869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LFggfbsOp7RhKGG7byBfUGiT+7RU2DAnjBLgUrPsMY6FxtFah7k12Zb1KQFlScoaKivuDrMHKeqVsSNNw0MjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1263
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04 Jul 22:44, Vlad Buslov wrote:
>Referenced commit prepared the code for upcoming extension that allows mlx5
>to offload police action attached to flower classifier. However, with
>regard to existing matchall classifier offload validation should be
>reversed as FLOW_ACTION_CONTINUE is the only supported notexceed police
>action type. Fix the problem by allowing FLOW_ACTION_CONTINUE for police
>action and extend scan_tc_matchall_fdb_actions() to only allow such actions
>with matchall classifier.
>
>Fixes: d97b4b105ce7 ("flow_offload: reject offload for all drivers with invalid police parameters")
>Signed-off-by: Vlad Buslov <vladbu@nvidia.com>

Acked-by: Saeed Mahameed <saeedm@nvidia.com>

