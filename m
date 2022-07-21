Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE3857C5E8
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiGUINa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiGUIN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:13:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2D8785BA
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 01:13:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMNnQrExzIxQheO16QkOgPEcOwhgpZpB3JT7cZMWeIf94mVtyHIVp+qnBhJlh+BSDUzlsFecmcjpRf6vnGXB2j4qMZm1DLAN+26BSE29S5cSLnF4JV0Blgu1/2b4JZfiXfchqo+EJViApezY2ZxyG2y538ak1xt/ekV/CIIGppUjUAzAbtnncXm8HQxzwsIeOYk5cxRXLWGevO0EeNf6p0BfqIO4ln5S49re1+BK+hs37K1RBVmZZTi6hw8Th+B3PD9YUXWwLJyjiUeCpcg4IueWjV/9/XCpk5vimzYAkU2x1cYt9SIBptWQVohOCKaktjVdzTb9PCnau0zhfuFs6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fDY2v3tx33xuVQlo9OQ5qlrKE8mW7N/Knfm6xXdYWHk=;
 b=IlY0CX9cOt8HhKDlDhb2QqEBQhX++7yFoyXg5u0M3jCqoUafxbxcroxbiYKbCtb+rvjZlFPnJu3xPC+SJ/iNbbkJ5hL7IBl/kS8I/LLM3kn0NGb3qe/mp9FRA/Z4MtBHzcTfKmpYCi5Z3Z1Z02Q/dTFfBy4nMJB2lSHIMToglCOME64NdkXiwiR9dH4IjhNw7iiCABKWCURHcALwIiOHojzNanHrk4e8NqiDJnOU2n3MRSqCB9EoNepx665kC1FyylsAd6sRVqOn+4aFpKkWLQwnu6BaMKe56SGl1e8YHySpizOUB/OMJiRARSdMeIJqGzn+vVWEAqgDgswrsVj4Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDY2v3tx33xuVQlo9OQ5qlrKE8mW7N/Knfm6xXdYWHk=;
 b=C4cJiZRNOvREANPkPML0NnxoxMnqVBNbbblamBllekQydgEKhd4bBh58MR0gEPZhc3gEb8FWTUa2G1L+DF9ZrB4YhU2Wk19o17vInd74v+iSxLzjFMSHh3LVOVvS39F+lW48w0IdIaQ4dD5jzCfPlVqIzvtEyOLuhn65qtpxaMzlKgDjKrb9fweCZR3en/zU4OrswcxM/IJ+INkzHaw/Pa4svtZkwZt16xjJxAOtKxp1HpxhAYlu3TRljzkBhqDsKbTpwUywXIGQs1GNqeR9Aa18jskGudMYNl3pHUP6LOBQRDgX4Z1OQxXYixPlvMmUnWxR1Dee/sGhfFjbPqrrhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY4PR12MB1176.namprd12.prod.outlook.com (2603:10b6:903:38::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Thu, 21 Jul
 2022 08:13:26 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 08:13:26 +0000
Date:   Thu, 21 Jul 2022 11:13:20 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 08/11] mlxsw: core_linecards: Expose device
 PSID over device info
Message-ID: <YtkKoMVTPaCYJCVh@shredder>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-9-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720151234.3873008-9-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR09CA0110.eurprd09.prod.outlook.com
 (2603:10a6:803:78::33) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f5237d2-72d3-4eb4-5646-08da6af0e35f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1176:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jsLe9A0Lc7hz2SFOWKoSGeWaKYKnnIIgB+IljiRKuhsqnAMNAya6wjoL0pjDdv7pH3o57vVI6JgffCs2P7KDDN8wa7LBuvO+VNGXZTQVZhAUBgJ4pe8hWDQVUAydG/H5+MQU2iKbI3AVXRIQzzqBQfrqoA4o4uBlIwOVErkl9kAg9LQ0NxV3J6uFlN5JA3eoaTuJanmrqJbcwNanorCAAYHVG2lmq1cOOA8rZhDUXga4yXXxV8JUyDaobiDIDWSn+BS/SJEcZKTYzA4j+0aLLM0bkXtHOuLI/BpQVapUHhQYxhM6j+KHxWIy2r3eNGKaoj1XZvXlxXB6NtFoiAo380+W8KHH/ZwQE7GutVOEagkaaYeUAqDIZ5OWAajFH61yfbb2mptf9UvkPsNmzPoIEXCv7qzTQhjog5d70s6APkbWf4ibN98sRUMiNOA0ZJdr5BjFoc1BML+dsyTSJIltNiE9+7BGX6o4hqpz0LWqG/rhEHyeINRem1HTIsHBNkt+2Dd5+pSfccyK5z30w2oF7qvXYs/oWjKpbAWWkY/5Em+v3xg8OaP6SIjDM4gsJaYo2gFUz3PnQ1K/a9YDc2hN4JFhj3/yu7zhzm41v+RC9vEUpxM9C4BIRZRph1lEytY/7/tzI6ZgRLqk2NLLu6IOFIpDl4Qbh2m17Hlpf4POpQCXhvb37gWWprvBuLYizA0EP2dt0syeowE56DZOWhqlo3Ayi0/GbZGlx+PjPW1kY4PjhWVX046q/nUCsZL0SgII
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(136003)(396003)(376002)(39860400002)(346002)(186003)(33716001)(6666004)(9686003)(6486002)(26005)(41300700001)(6506007)(6512007)(4744005)(478600001)(2906002)(66476007)(5660300002)(8936002)(4326008)(66556008)(8676002)(86362001)(66946007)(316002)(6916009)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?61bAP5VAN1B6mRRhY4vJgvTfEMD8WA9TAlUV4y5tQmEwdylHeRDGkMiF2l6c?=
 =?us-ascii?Q?JPVmNKc5qogfQcOY8s8l0a9DijWAcl5rEl/1PEIUSFwsSqRBQzfT7wnJwhoY?=
 =?us-ascii?Q?VtMqFJc2Z2Fd2y6ors4iefjZSNt1HXIhbY67hroNlrfKhvzkspmU/5L/vNO8?=
 =?us-ascii?Q?ifTrc3MnuAgzxYM4U9e5pzn89JOsC3tWc/5mf3S0MDi0eO4Os2p5CnviuPEq?=
 =?us-ascii?Q?fXqYaftCJGpnEvq0MFT0vChcGlqbwtKQKKOk39ATG10pyvEN4oYVijWr4bJ3?=
 =?us-ascii?Q?pwaJltg08mII4uL20cRleN4cLusw3Qfz9AdPPsTeVBaH5TRHkbmUfF5pPVP0?=
 =?us-ascii?Q?WVuWnpv7TthiEq7bDZC1Wzn3Ank02c/Hb0WL6suYsqECUZ+Ytu8Vc/YZnecF?=
 =?us-ascii?Q?OYTBjlauiMcUWdHj3aTbLXjGyU78xm4t/viLXGgwp886g5moKfMQlUMzdcZz?=
 =?us-ascii?Q?ObuCpCh7yr3u7Gdyy1gkKW89AqKfl7Pvj/odVuG+kGVokpLitwudPjFb+ZGE?=
 =?us-ascii?Q?qtukVD0NqMWxznhfCUjqsUZS1J3A0Rs+9rEMvaQgNdHBKuNC31R1kVVa5+lx?=
 =?us-ascii?Q?0dvzRU2y5iOhrBFn7Zun3mtqDlKfPQujkX2TTutJ1eVkrkQc5pIETWEArTJ0?=
 =?us-ascii?Q?bK5bVkj5xNx538/0gMJtopu1lhLyjxkrUWvOeFBaxHC1HBdaSFRzRlkEoEcc?=
 =?us-ascii?Q?CH5rO90/FGjQvgP6cdn5c9jra5tCTb+X7RN3Ptiktxa7+JQwsjt51Rqpl7d0?=
 =?us-ascii?Q?6yyUw2s/7WFf9SQNNSAalREMm7e7Zy/3nNZQfQ0ev9lkPKcnSE//rEvHx4LY?=
 =?us-ascii?Q?X78N1gEXjLcREtdZTd6TrkfAA7HI5SL0QbUMyTy7x9/GxsBwki6VgU14D127?=
 =?us-ascii?Q?dZkswmTVk2zxZWRjeVXequwuunbPG+I+FIs3Zel0j3ZCg+XHNletFGRMs2UD?=
 =?us-ascii?Q?db264KtawFI95yZyf6wwkWuFlf3nOdlkRd72PgjDJPyvrXvGPXqiYiKCGpUc?=
 =?us-ascii?Q?xpQLu+jkw56ZEhNaV+QnFY9WPFIUNeVg534qDe2w5+9io28BMgTHKCs5VKOx?=
 =?us-ascii?Q?PjfWEOk4O1SUoW2RH9JuPYnvvpoCAdbhX8BgejqE6TidBZKjFZCQDa1KPV2q?=
 =?us-ascii?Q?M4boJlsmGWUMptNQVI2eOVN8ikCfPI85yK+qrbPGu+gWH04DigJI4v9GGMLO?=
 =?us-ascii?Q?BfaO4RoCJIsW3P87Wu5XymXG51vGBfWOnG1uclcOioqlWGHVrlldbHJxRPf9?=
 =?us-ascii?Q?rQM2ryFTz4mbVNOfwACrdlAFvyKhxdF5Wxg6KWoR8Xhv9kQKqNdewGpkmQOI?=
 =?us-ascii?Q?BupCUWRQMwdg0Ouah4e0ttv2VWBTk95rHgg3vFpKQuR94uDFH2Ron5gTdi0c?=
 =?us-ascii?Q?tpZqU+Pfonmn+0nmoYFSp/QO7dR88M/tMncDHbgNbgjxEgwpPjq48ilyncyP?=
 =?us-ascii?Q?6RakDyC+s2Dq6WnhLBnTd+9Sp1u6LNeFjbgsr9mMrKAi/g07EiP3QFDMdeE6?=
 =?us-ascii?Q?t5TRdqVbDMPiT1GFV6UhIYHhxczZVhsdQBeS7SOulhDgcn90XwI+cvnX9lD/?=
 =?us-ascii?Q?pXktInowSBk81Es2/y9H5C1SvRyJXqHrQyfDuvGc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f5237d2-72d3-4eb4-5646-08da6af0e35f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 08:13:26.6498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZIAuQQZubLgFkN86X5NKEiKXa9vvewUI/Tlf+3k+9BSdXfVToO2CoipeONVNn+ZB29ic0YXqCUEVo6p3xLHEew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1176
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 05:12:31PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Use tunneled MGIR to obtain PSID of line card device and extend
> device_info_get() op to fill up the info with that.
> 
> Example:
> 
> $ devlink dev info auxiliary/mlxsw_core.lc.0
> auxiliary/mlxsw_core.lc.0:
>   versions:
>       fixed:
>         hw.revision 0
>         fw.psid MT_0000000749
>       running:
>         ini.version 4
>         fw 19.2010.1312
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
