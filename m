Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0939857D2DE
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiGUSBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiGUSBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:01:36 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2059.outbound.protection.outlook.com [40.107.102.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D278AEE2
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 11:01:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c99ibwgX0QVNUk2eBxACpym0tyL+9ZE0TZWAnhG+KaQX1s3pIWUri6GuoN04ELlRGC5lqkcfOmupKM9QHRCGm+P/TyHgCSaCRsMOFLTQuRyP+mGonTITiWVpkpzdL2jZ8IUFkDKEIrFu9V1dLfzjG668Ii8RWEYT3PRygnqzMvdNyFtxYzTVvVcaRKpkilnZVP4gSJu64aBwgdKbs/iQFTCK6HerD9D8fbXB65aKMYcCgsBCKULyMlEfFZNtcZOr+yDyEZZimxnSYVf1fpf4F+eBUF8pdDGZIv4kQq2MqMeXJIOyMLk3LpeO1xKpkueiV9pufEy4W2BIZ/b3w/c5sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47unfUySbWMP15W9DTStFFsd7VfDfwZLweoHw/ZAYag=;
 b=Q2w5hP4/Z/OCzmmrVQCSjV5EsZLurT0xI6ayKhEGgcGxt1Ngmd/v/jS6TOm0KexPrg/CcDIjokSX73ccMOEpaQxki0/C8wpOJ/TK0BZSaUa82xuO6fYIlUB3uzhm0mcqoxrnLy1SduHbaQt0PzDiO2zHI2Jbj/UejS1KUNcKTMnPt9HLv5En/bOzJHiKjVzPXF6fBtEwEHZMKyPgcoO3clLRr1FjJNLaC+ic1ybmGKI+vhHAz93lbJ0rY1UcVqcVLEYgqPbE32U+5zDcMa9BsHMN0xGtXJcN0JxlXmkdWiV7b6fMEAfCHafOgGQMN3PYeh7YYxO7Bukh2EWNkR48KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47unfUySbWMP15W9DTStFFsd7VfDfwZLweoHw/ZAYag=;
 b=mKc9JCMGoGcy5GIXfey+vo8Y25w/nx5ZS/rm4XH1VvlCQ0RIAuoupG/mkbY383P8n05mR6ILqv9Jg7vs1MM4HODEylAZCxqipcPeVypUJnJCIvFjzHLFEJVxrFIDYUZxmM9qERievvxEIhnAKa66diOvBF+mcTUhGEoDZ2YIgPHiv9PQyzx6iSbTq0SSex0ayy2JVEHceuhyQsycn7JDhlZCTIzl8Cfya2yMn09rCOsukLAAmFFpGS+5gf99DuN7CbpYkLJu2IbpCbZnC2NOispiTU6N5kZR1S23pcFkwBGYZYZp1YkjowWW6kGQkaqIaDvweAJ5UT1Ee8Tybb76uA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY4PR12MB1815.namprd12.prod.outlook.com (2603:10b6:903:122::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Thu, 21 Jul
 2022 18:01:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 18:01:33 +0000
Date:   Thu, 21 Jul 2022 21:01:26 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next] mlxsw: core: Fix use-after-free calling
 devl_unlock() in mlxsw_core_bus_device_unregister()
Message-ID: <YtmUdnBNEuhlDVFJ@shredder>
References: <20220721142424.3975704-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721142424.3975704-1-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR0202CA0011.eurprd02.prod.outlook.com
 (2603:10a6:803:14::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8065eae-cd97-410e-4e7f-08da6b430bb6
X-MS-TrafficTypeDiagnostic: CY4PR12MB1815:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgNr/PmLOilgbrN9eaz+XmnzQoth18yxTt9GyKYCzfYPDP6sScadvvYUWl330H4p7NLn93jDG/TdTX1YI6bmjXeE5BUnUfvDqTKSRwK1kn6Hba3hm/wHOUR0EfDrU5ZU6rIXVSi5snRPjcjrqNtL65I26n2tE9t/LweAl5Sgs39VaOh8xOE/jobci4VG5QRV2Zq1vb9ZscxCx+kVaGVq2NYNzIfLBiR08H8A+wQi9/A9kGuHqmXG/jBb/IMbzxcMzeHGkoBQ/HADA8LXZjQogBDWOoJ9uLYjyzOVeY35UKQvEzAshPvuKFSHF5CY6nOFD3XLw9WFHUD2hB95L8snp0PJtakfMS24TabU3/R7h6Zf2LcY+tw2v5d6OwTyIEX40f1zmvABDicpvM2F4cxWpfX5Cj+5Cj1xwhoMvrbInUWl9gKRs8QwXquWRNLCiTjRo9cdP9DH3yaO5wC19j3jWnvNbfSGR6ohRD+B+38wZq+GrXnB82bbg9hsJ96zTDU5pG8Xajsx+v5Tal7rHl5JpkOhq0nKMQLVVc2bJmg4F90QfmdvDPHYEhp18zu/NMH0n4Fo8kDTQkPmaceivEXAY6R4zqewCA6fNL0D3UvrR8fri/OLyNuI7a+exDaZKqE/5tW2iqg55bQFwHx4ANqkDsJjt9n31awnY6T6bEonWeIfrH4+StUMsCCJy3rfDdpSbOVrWoeil6A/kh+wyBIN+QgrVdpwGta/52JOK1oSoUzDEOv0YfrjffPSKzd90Mfg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(376002)(136003)(346002)(366004)(39860400002)(33716001)(8936002)(5660300002)(38100700002)(6512007)(478600001)(66476007)(9686003)(186003)(8676002)(66946007)(316002)(6916009)(4326008)(107886003)(66556008)(26005)(6486002)(6666004)(4744005)(6506007)(86362001)(2906002)(83380400001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EbZ7g2uz1jRYXlaWnjpK2JJ3mNWQSp9u6Jm/tu/A+B/Sp0WK0sCz3BEPIku7?=
 =?us-ascii?Q?ZOuw65D3/ZVZcLZPLfMS6mJwOTINUIFSeB2Y3wx4YQ4F8gtGRjqLsg33in50?=
 =?us-ascii?Q?o6Eit1IHNIT0rPBnB5/359XIiCrlt4opPX6+SXGPAZGt+lhvRvwoGwFgWZ+0?=
 =?us-ascii?Q?adjiMetgmFj55LFie4MAs1vJ3eTXu9ICjAB81wtnEaykAAqdpDmkSx27Cyv1?=
 =?us-ascii?Q?RBmF2IHhdhe7JMfwwQOU0c+1GI0Va4Y5OQv+Z0U/C+Qe6TomgSP6IYPg7txI?=
 =?us-ascii?Q?Udt5DwGL9nzXVZcm89XiA9VJijzi5tjuqWsxk8zdHxHy4JJAoMRhpUeNMLan?=
 =?us-ascii?Q?ARg9REFC6V1Z+SbHfVwoHxjlvuVpVLG5B+gpwy5j1jS2zWlJCkZNBpF75VOt?=
 =?us-ascii?Q?jzBGIwNBr6apYVHzVXLSuvbpnAXPVB+YkQHIWiPYzl4sZ7OKUBaXtamK6h6h?=
 =?us-ascii?Q?JeYLVnU8bU8U8c8ttS+XylpvOGycC0vAizv/nYqrLfK1ztSBWT0MjJpTOFDc?=
 =?us-ascii?Q?xsdEBRDFJM0EY8l0x7VXNpZgticXITW8IGw5Qi7EaLDAukn/Ut7sNzbUIUVv?=
 =?us-ascii?Q?LwL6/lBz2JU/g832yGDxaP7yA1sCRBEyhjVrYaSmZBpCCNYIsp+E85sNF7NQ?=
 =?us-ascii?Q?w9QpeOiRnshUTp7YlqpZIaPSChxk6T40/xHTq/6K99D8UHLlX8XNR/ws2+78?=
 =?us-ascii?Q?gwDv1d7/XF+ilWBQKkWSIxc7dA8mU05y+IfpBhlnXtSLhyFLLkg6FXEC4ERm?=
 =?us-ascii?Q?5dyLI400kCxsCd/SzJO+/S9i5naFtu0q43z0OEBUkohE59SLUL+pxN1B2iwv?=
 =?us-ascii?Q?7cFzmyccrJfzVgAJJsHO5dxi4pEzM5qjJkXhuzyxwpSyYrGgns1Yd+JhiT+L?=
 =?us-ascii?Q?WxvuDfik4band0Gf2jN1LMIMRGMflSRGM+xS+XZBVC38bP9gEE6qcjQ6OwLQ?=
 =?us-ascii?Q?4bkGxS2Y1LkBTd/PTTnaICD8Xq2AoJO5d46jrRC/LEtCYwix+2HiHol0XcFu?=
 =?us-ascii?Q?KcBopb5ztB3fvtwZqWAH4hXZmkQhIjPxPnGCyE49mPeN1cff/CAM2143NpU1?=
 =?us-ascii?Q?HF+gRTsGfXfvoiwJLyAN9i6kKzJTBuMNaKqLhR4Sy6zcaPX7ck/X4+I1751e?=
 =?us-ascii?Q?wGuVmJby4dHgpZKxjNGbkKukWE0ilKfKgmK4PakeWf5rGqTxmv9Z+zLe29XV?=
 =?us-ascii?Q?zX36K0kZypx7Zl8VH4TvVckLCNUrgPjOFUo8w4GkQj3c+fgInusOoZ1c5cGt?=
 =?us-ascii?Q?szVzQ+uE3zCuXx+QEM1FkwDFUJTnW1ITGMZi6qOlVnCA/Hb4VwXX6vuDDTPN?=
 =?us-ascii?Q?K1GgjYlluzuFNgJLkRUrYOgCcQ+TdEgLL1ikB0CLz8pt/wTVV6TCFgEhW/+j?=
 =?us-ascii?Q?zcWzJ7BmhgYM6p6wMXt6Huz4RUQaEqKrypg7Rld2QURFt8oMS9pH6xWkKcGN?=
 =?us-ascii?Q?pS/CQ442AA+dpRJT31h/SMpCoDNaR3mvjU3gpwyaiXGBW3Mhm2p43sBsS7Bc?=
 =?us-ascii?Q?levq0mdOt42/mjLdelF11tX1GULnRWNtQKKkALXNrpIxC/6CAT5F9QsqZOQS?=
 =?us-ascii?Q?ay0lsFLKeSadJabQbz4Rb12kzNfelkZfjdUHdqn2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8065eae-cd97-410e-4e7f-08da6b430bb6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 18:01:33.1230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5m9Vlt17AjdGDrris/XOFNV0Wiw0SmjEe4L3uMHcaSV9Uv5AxY+d2oXeDeiu5DLG/2w0Hh8535dFGUZRZpySjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1815
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 04:24:24PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Do devl_unlock() before freeing the devlink in
> mlxsw_core_bus_device_unregister() function.
> 
> Reported-by: Ido Schimmel <idosch@nvidia.com>
> Fixes: 72a4c8c94efa ("mlxsw: convert driver to use unlocked devlink API during init/fini")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
