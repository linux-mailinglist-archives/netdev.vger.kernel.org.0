Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6312657388F
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbiGMORQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235703AbiGMORO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:17:14 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68459255BB
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 07:17:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9skXs9R+q0xIAwyXcyzx+k+z/Nn1tzpYWWXzgl+QEfdf1FUHFX6797VCyjmZ1CvDUgT+43ZtGfsLQNBV7+yITXRRP1kwyk60qw8E/vzEnhzjTLdBRww94MWfpLqU03NKqlHjZI7BpcVj/GqJXwV0gwzv3pJaHT1M4IKQ7Ji2nQicJ/9w1jC22+gqi8ToXB33ucVNjE65k81Spesd3z9EmOqkjOx4CUXjCq3iaFNCiZHcDM3PHz2UK2r4MKQimcLeuPeBuu9jrHgtE/8zt2H+Iapc20QzeOcFfHFI7kb1e3A4q4MjAEMNi4SKEtXAnffL4hEI5WX7UdoF1DPKpimMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nyblavHvyQyTRtlxXiWn31N5ISsGilTIUj1VTdk49A0=;
 b=Jqenl2lhPRi8Fdr2FoV+fFEbyIA7q+Z3Tdyl+Mq/KrjaSmv6ef10mZtrcp2azRAGfhc3WDJiKICmFSA5OXUIy6Lu7Qy4CXtiNOObQW+m1daQMa6aKrpKU46BxRgamecpzkuygVeu93gIamjN7f+vxxzvC/c3qYHS0vGnvEcUJbrFA3akWXDZhGVKZJnrvb9lbwPWaTGQBlGIkyxFWo0KLifrrjEwSZEqf4OgTdrMDGegXzeTGnzgutyb0JHL6riAoijlAQO/h9yVM2j9ADdbOp0H9dInR+41jrwd58uq7SYJ19lHQUATYUjemmZDy4CYC38uFdC+CkyM4mUfuCs5NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyblavHvyQyTRtlxXiWn31N5ISsGilTIUj1VTdk49A0=;
 b=U/nNqEVJHBRT7qfHzB4bx70JgJRdo4e3DpDp32ko7+/srIh6DsGfKy7JnPvaXyNiRy1QW/13+sLEU07CAEcx+OUDRjp1zAnonaEHxfogf4I7X3x3sPOENy+QPVLHCJSowFIUEImdZUyFPjxVhJTCENNjKEaS73FheiY4RH7MCNk+bgslkz5TvIvlDQII204eG0KV5JLpp+SLmjJ22MZ98ne7hAxPfQZDCgwV56S1HJWdMhtDpZBLjKi9k8ZUv8Ghm+GmqYRHW+ewr6auE+e9gd2qGXa1Hkfkja61TzSuEdQsq1Ynejo8Zcxour6gL/4gZqAi9ehHnCluvhRaRr7ftA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Wed, 13 Jul
 2022 14:17:10 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282%3]) with mapi id 15.20.5417.023; Wed, 13 Jul 2022
 14:17:10 +0000
Date:   Wed, 13 Jul 2022 16:17:04 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [patch net-next 0/3] net: devlink: couple of trivial fixes
Message-ID: <Ys7T4FJ/jbK5s7uh@nanopsycho>
References: <20220712104853.2831646-1-jiri@resnulli.us>
 <Ys7QpWEVIh7NfrAx@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys7QpWEVIh7NfrAx@nanopsycho>
X-ClientProxiedBy: AS8PR05CA0008.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::13) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e24e81f7-9458-45db-31ac-08da64da5fdb
X-MS-TrafficTypeDiagnostic: SA0PR12MB4431:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: adjqH52vkZZiM4b4PstoCZFeChSktHVbwbiC+t141UxsIOZBTKCETiuKPZyqcFhOrO71xIGbQm9J6er+c5nfaB3tfuGL2zwSPa6oVBvRzb4ukFL1gq/05sIWFlHtXRqesBUO1B+cXFXzney2L9tZc2KHaOAjzQsxrCPh7pFv5cC1nokoWoawYTyZVcdnOBhLktuoPntHHeQrt+XRxcrs26bAze7GDfSZMX9ADgn5G+Is8kt7b2x77IeJbCIMCgXvhl5mchRK+w4WHdZfiYHQ3gGWdPL2UlrOUiXWKAheNRTVOjck+p/wuGLoTzKokL/uwe25+c8EYAmA94IA+V/qJUx84yZdsPWVfdiXumWN6oKTJGv1qi/3CMO439YB4onuFII4Tg0PQRUGLQ/+s0ZHMLuwZfQOAV20n8TDYkJd6sXDph1v6bjxkqFDFk3JdTrywL4x23B+mTaFs53CsCnjhEAuo30uqHEZCT+L0iOQzFrusfp2utq/AgAtpCK0GLGZvrm55XjGipspxKH32HHK5ypfbwE7UDAst6MVo2JihFwDNmpM1zuqSGPC6hnK03bnj55PI8TdZHAFqqZAYF03JKJ7t7UHcX0Q8sg4GAnPArWJuV4A9KwX1zH5/yTQiccYoA0sXEmSIGVh9qA/pX8VQBrmOxtgKSIHcbibEF4z27NsQxNlcXkQ00Y6iSHT9CC7Yyxmh+PoRicI0pFySzmiwiTeilnzfxRkVrjmjRDMuNYRqTGvZ3rOHMTOSnztuBev
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(316002)(4744005)(5660300002)(6916009)(2906002)(33716001)(478600001)(86362001)(38100700002)(66946007)(66476007)(8676002)(6512007)(83380400001)(6486002)(6666004)(9686003)(26005)(4326008)(6506007)(66556008)(8936002)(186003)(41300700001)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AfG8iP6yVHf3i7cX8G0UqWIAabWiVyiVNRogYnHspAmmoOXCmC12geE0YjYb?=
 =?us-ascii?Q?esi4aQwsOWVuOUddlgPLeqr6bUFFi1CRBqDffcu7t8Y8R4+DNnLA52ECiREm?=
 =?us-ascii?Q?TwniuwalPQU3zGEAWaI0lr53YTjni5nQFg/cQG3DZHRpdN8IVbZ0gqV224B2?=
 =?us-ascii?Q?T5K1/pNrSYUmPhGj43XQtT8J0rM0erTZEvmf3empQj/0vsv8zTRFtvaGmlzX?=
 =?us-ascii?Q?IF7/Ic/PLrzSgoS4uF6c+GCKfBz49jIrsmAsNn8PJ+bLgxF73QjQK1m+3mAt?=
 =?us-ascii?Q?6B3lZqzCUt/yu0JSkfYSqmRz9hmRc/yccLoay5xLSugMuK1extgwtTCVW+/i?=
 =?us-ascii?Q?bd88wjvY47ke/kFZcWHHo0QHc0RruLfSzfAMVyvDiZyEBs1doRwie+CgLPlD?=
 =?us-ascii?Q?uUO1yFl8upX/fZlBi2bMLywq/FsD4vZ2w3X9G835deQedocDJdQDLyrkG49M?=
 =?us-ascii?Q?4xq2x241rbAl4/6gV5etX6in8O6tprKqiyvhG+pV0XyjKIW7CdCSmjw6rRg4?=
 =?us-ascii?Q?0libNKqLAEoMT0VJnb/fWuNPxqtoDjt+A/r29OEt/m8DYH0cZ4ihOJyA9MeC?=
 =?us-ascii?Q?liJl1/5jMD13BkaIm79zKPtWsV4J3RneQZ3ruGU7lWcdDhZjVioOwKAX0gI6?=
 =?us-ascii?Q?pfVUUNDGPsoqqmxetc3plS95bOFsGGn6jf6Gwq3iK7awIp4Twj7AoNwOhbaf?=
 =?us-ascii?Q?eAllH7pDZ8IDTLchwSBH/wqhYtrQA9x1RA+6QBH9WE+20Egh7X4qoZnUUUGJ?=
 =?us-ascii?Q?KjpGdQROhe4dY6NDYE3I2oLV02aj5OALm+kcSDGwU9ueOW6GazsynaJJKJPm?=
 =?us-ascii?Q?4pIEQZf8obGsQvjiMFWll1ac1DDXnWg2gKfotlFJy62nt1zaHH8omjaqwJjg?=
 =?us-ascii?Q?Pe1OifNUwrViRk5cFP9EdZBPalwjikwL/Nl4c9tDuUbutvc9rSMgwQ0K6mTU?=
 =?us-ascii?Q?OokGyMD6OafgUMi+4GDe7epo8cVwWWOJl2FxP9FdOFZ2NVGIBjf19E87Z5dj?=
 =?us-ascii?Q?2kmPaWpLzlPphW6aNgKycqA43etx3NgLxOkhhzWARSBrBXsrNemvdxK+v9Zb?=
 =?us-ascii?Q?viWzvz/0nd+pU5UnpitEfSoVYsdfYGyIqPznZcbR5RAUPzcjOE88GY6b8S5y?=
 =?us-ascii?Q?M9aLYCPDQp+eeQKGmstHlzp9ZXqS1m4tVzaNpINSJH0CnQImmnGZ6EJQwAow?=
 =?us-ascii?Q?awxZPwwfFSdOyt605BjQ5kFtWC4YOEkgKKcW9kyTRcRvJ5CJCidE/XyJynP0?=
 =?us-ascii?Q?uOG11zlmLyQg2g/DqxR2u6PxgpXld6PXHmpPmdFX3iLFcbNjcjPrRI60rMCs?=
 =?us-ascii?Q?7v6AdY5w7piTfzrva2cc40cxnLtYZWcswr48JSe5tAgUuJ0j55zD38oghtie?=
 =?us-ascii?Q?LOJFWE5unT7JloXbgH8kvnhAkhLMDa1+RCRSyjZ9ISwHkZgrdldbCLM+pcCs?=
 =?us-ascii?Q?hjOE36XDQv5f4QvACPckv4AYs/5Qh8yJysn8uBHoCNsTw+nESjyftM9feHQC?=
 =?us-ascii?Q?8Py+BXgI7uKD+ZC6kqV5gqZXmerk9BwAh5pxQsCJV26ez693nRnNjLwiBGfb?=
 =?us-ascii?Q?bYSuRmkY2penHiFsFNL3dU+UTm/iwE62uWs4hZ5y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e24e81f7-9458-45db-31ac-08da64da5fdb
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 14:17:10.1913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VEoOt4gvMQ/TDA4FevtbHssPJhcJfOd9ztvfPTWt/Ks/feZEhFn9Yg/CkGfWCIMe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 13, 2022 at 04:03:17PM CEST, jiri@resnulli.us wrote:
>Guys, this is incorrectly marked as "Changes Requested" in patchwork,
>however I got ack from Jakub and no changes were requested.
>Could you apply, or should I re-send?

I see, the previous patchset was not applied when robot tried to apply
this, and the apply failed. Will repost, sorry for fuzz.

>
>Thanks!
>
>
>Tue, Jul 12, 2022 at 12:48:50PM CEST, jiri@resnulli.us wrote:
>>From: Jiri Pirko <jiri@nvidia.com>
>>
>>Just a couple of trivial fixes I found on the way.
>>
>>Jiri Pirko (3):
>>  net: devlink: make devlink_dpipe_headers_register() return void
>>  net: devlink: fix a typo in function name devlink_port_new_notifiy()
>>  net: devlink: fix return statement in devlink_port_new_notify()
>>
>> .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c |  6 ++----
>> include/net/devlink.h                            |  2 +-
>> net/core/devlink.c                               | 16 +++++++---------
>> 3 files changed, 10 insertions(+), 14 deletions(-)
>>
>>-- 
>>2.35.3
>>
