Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37239579677
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 11:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236843AbiGSJjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 05:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237171AbiGSJjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 05:39:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815B3193EF
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 02:39:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9fWeCSrX6h5DW4AexLxU76KTZTgr1QnNyEuq2o7c0eDxZtRew0V32cHbBUCGRaGyQODJ0toypmzToXaVdrY7D2tUoSAfs50uq1ubaxNfNidNIV/kBRkSwQA/oEGR30gm4PpOjSy5EG8Bf49jsB2dwxIVDjpqdkmMWAaTqhKGJiGwBRRxCMFSLhbx0LwTELYC7h54VFs5x+oFpKpeCqtMS1LapM5d0axuCSNDsAZywXq70i2/x549Fnts6wxNW443NFwIVc5sT2VIZCCAMlePWG5gO3xdZwF9CXnPFKvxZVf+iYEJ21ozch6Ie/Vhe3Jae525XF5pGj2/zhUo7LXNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAJrQJGiaMPKXexuZwNkyGgRAAG3t6foXrbp7s2HOaU=;
 b=YKGiuascPuxPNt3ncFc3VV4BV5FRQt9lAbAojvLC04tt3nIlLec/6LHD+pKvUbZVMFEUZrmK4p14j72ZgNtG8heLRZnJ+53BMh+bxvuhFK4rETbdtggqIlIqxWBINi75Fz/d77OkhbdscC2G6IraapQdLcviDQiAc6/gIcAOkKP9iCTyT1V6ZGhYB/OLrMh+57rhyi72X/qthxevTZmLlKcZj53zEzCxb5Z1MvJTpXhy+HD8QAKZKM/EFvy1z4/VW5kB2zE28quud11X6tYoXDLf/A3SjOm9qaFmHu31WdT09xMazcgFs/udOU25+Lz+Zj8LThBeiKtq/oGejWmfjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAJrQJGiaMPKXexuZwNkyGgRAAG3t6foXrbp7s2HOaU=;
 b=UpOJzBL+pheiKkPLP1/hk/QoMb1QKqrUre1fXXAhV6QJz+imtTityKYV5ag/NLdxWCSAGpWHj85Ha7VhOuaS6lZKz5V/Ctt8nZ0k1HmfkD7Rr3ejMhb0btDUCPdM63orYOpDfrSnd85wcu/f2KR4ULYkmehJxxOzP8c7mSGnCHFqDcfa3r6eNrIAMI/NmMaaZ2uazvCm1SyCQjoX0UPpeBJZUpfD0p47+VbxKbvWSw3//Dlze6CQlzZACALGipJfvLJWa7kKh11gLmpeVGPoluPs+FdqZGA9KzdEZGbIn4bARIDAYIUHqcEJ91Layf6soTuqrF3CZe2GluY+LZsD6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by MN0PR12MB6030.namprd12.prod.outlook.com (2603:10b6:208:3ce::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 09:39:04 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::d1f6:16f4:16b5:b71b]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::d1f6:16f4:16b5:b71b%8]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 09:39:03 +0000
Date:   Tue, 19 Jul 2022 12:38:57 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 net 03/15] ipv4: Fix data-races around
 sysctl_fib_multipath_hash_fields.
Message-ID: <YtZ7sRBHgtq4r7LW@shredder>
References: <20220718172653.22111-1-kuniyu@amazon.com>
 <20220718172653.22111-4-kuniyu@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718172653.22111-4-kuniyu@amazon.com>
X-ClientProxiedBy: VI1PR06CA0118.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::47) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56efa36d-8988-416f-29c8-08da696a8486
X-MS-TrafficTypeDiagnostic: MN0PR12MB6030:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YHbzWfrAD6J9dBtrVeNBdIQzClcaq4xJkUYXf0Re8NPPj9f2GpJziiKSJ3p4nN4te6nkc1BZEIHdpgRi1piNekREqraPWcAqVDfcsrVQCXUAVVNgAlqoO121XqpfgYxnSI8dL1qhHdQvv8sm3Ppdw/eCxb2n453tMhx6S8SbimXQ4eSOyFu8C2wJJBntLy3wh6FhaqOTUatqGQ9nVXE9ral5Hc6CSSxljruuouN7/+zaDYzeVa5T3pDOP+rk8OSr6w/AUq5EoKvca0HeEXCSLRyZlKeOq+5genGZUELs9f+RBrFNSg5Cz/7rij9wQgHKbkWos0s6uqLpvQWdAwJx9b3OGYbZIJlccuTHJIokMp41sq5M9AnYKwOwh3nfnGCNKlPsmw7S8/GsTNTCsH0Kb4kUmMuWAfamHWReNsaH/GHX7y95HzcuGpNdgnD7DA8GYFSAp+tJ3yqiXbr4Dqd5Nyr2p9cWhxjmAwRIfeKItaBV9yQH4v11WzctWKsRzvI3rmVrGX+R+ZxuRSpISU5pKwfrj23VJ1ZduiHY5b6UKNx0lpkWi2wgShzRvFriufps2an7ojoA2Bw8knxeoCdFqbD8a4RRAiTVnYsm4LWjLYfCLbDGtYf7Faa4O12newbLrO+LQoZdxZDPFas7tl+TGN/JnXRKxL7WLp3Jm6wy7p1vDGQK7qReJx3pFBKEZEkf2JvJqeeq5SAYf0U7qvERnLonfH/Tn6NuDnYdnjlM96dxrV7hegG7v89NKeZOFRhj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(66946007)(4326008)(66556008)(66476007)(8676002)(478600001)(8936002)(6486002)(316002)(38100700002)(5660300002)(6916009)(86362001)(186003)(6506007)(41300700001)(6666004)(9686003)(6512007)(4744005)(54906003)(2906002)(33716001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S5qu+A+Z1bHkmjcZ/MNKbUWVmWhoH7aI+DpAGM7vOcCCUOJqwQu4wECvyM5t?=
 =?us-ascii?Q?DF31ZKbXIt5ctbm0ig5LO/wZil/vuB+1WMp+XZkDH0myGwg4UvLzNwZU5hku?=
 =?us-ascii?Q?1upbus8dNMxlzPKAxly9puVpPl6pTx0O9vkwCyVRjxkMphNzUVsd21GhKeMb?=
 =?us-ascii?Q?DSFfLddo43gPKYnK3Ts6t/6lXWsrZzrwAcutnEIpdXoaoIisu5HwOSFkXKif?=
 =?us-ascii?Q?rpT+2wK37DWr8YgQU/qzexgPNtysgKcoHjfutulLJIfibMMtWmnxTwUwRdkU?=
 =?us-ascii?Q?lkGt/o+1p45KKFcM8pKTzKapO7AR7ohh0UtzskE9u/yO043Izt3QEOEKXQx5?=
 =?us-ascii?Q?UoBtvNOznYE9bsO29bhqj/Uw5Orr9G4FxNhL9L9bQjoCY7EQzEshMLFBBqLF?=
 =?us-ascii?Q?9Lr9QTqCEOH9jcB+7sDHfPgjj4jO1rlWHnt7mDrz0fa0GqBWOG5HXXPJwAod?=
 =?us-ascii?Q?jNfTLswSRrAimsF5EIhbIe9MncDfz8EFs9s0Pnsh0tQJS7ecWY7jc/URhnNP?=
 =?us-ascii?Q?TgAz+dX3k7WYEfIeAzyPMsrfv46zFzeVxhO2diJbQOfIFQ7E3MwK80/unZJO?=
 =?us-ascii?Q?dmOCURa8VTECYKfUrKXpE3Iv1CfKpSjN/nqQfl2L6nrFtst/gN/xs8odbIDQ?=
 =?us-ascii?Q?6dIPJJv9j7tybYX3B9RTThi2FILJcuv9F8kuQrFGyBb8q8wegxigi/GitaTO?=
 =?us-ascii?Q?TL93WMilSwyEz881EC1S/Udc9pCHBTQFPN2P0HK5OKllCJh/uLHO4o0o+hYu?=
 =?us-ascii?Q?RNn1EKQdwflkF1qoKq+O3940qJII1CTriB4oaYCTOwC6eHqC0RA/suEoGT/F?=
 =?us-ascii?Q?LrlLOoBI1cLn4fCJALePZf868kUCJJNF7ba3tq2WcUT/p1uU3Un9hXC7+4Oe?=
 =?us-ascii?Q?PGuAEqwcpuXFvomPBQfXfdDKBIE6XRBhMiZ36NPpBm+tpW28+sMAx9IXX2CW?=
 =?us-ascii?Q?+4QG1F+XQqr7Nwi92MPqutqyOHmK+kxnPKsJQ2bq4pbFA/pazDZvon8lq9Mw?=
 =?us-ascii?Q?g9yhdgtblyUJgjfLYrG5f5TtZf28U5+rbKt/1+v/dwp3+a/r0EJBimCVXwHe?=
 =?us-ascii?Q?tHs6uZcMGaaitWM170npoi6Y9vaulXU9u49WtSUkuPjY2hUrbSsKfSRLNC43?=
 =?us-ascii?Q?AaD0khe+vgzm/04eadJoxnGOkxitRaLvzHoUXJ8Lwnb1njf3pc2svoC12phZ?=
 =?us-ascii?Q?jrxiAwmnm9E1gy68nZymR33IwfqxePdeqGjSBSEE36L4qGqg4jQa7Rl+4cza?=
 =?us-ascii?Q?0PEA/uFnY+j8l5TqqY3V10xJz+RwwCaZ4XJqXvUQkmqxpASJp8KXkP/DRP5Q?=
 =?us-ascii?Q?D0lV8gULkif/G/ex+OA42N9z8hpsWHcrJfYjfEWLn5LRqZIKY6rT3OOsRSLv?=
 =?us-ascii?Q?VAIW5xTlnNmfyTQY4tgwVLFbBtRI9GmScJUnQcnMyCyGW5lMN8oC42NYXSeP?=
 =?us-ascii?Q?TeDbaHhMYQR4rQi7hcuCxv7XNPazs+nJSqwcolt7GmHfUGcVXS9LfTnGNFre?=
 =?us-ascii?Q?5CnSgwxDlNKxNInaPFNh7l/G/GrG7PGwutXG0uYyDstJjoPDFBi7yhWLheJH?=
 =?us-ascii?Q?CPZJpPDhSYnhD7ysyv6RzeuqNWGqMQfI/vsrEtJw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56efa36d-8988-416f-29c8-08da696a8486
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 09:39:03.8431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n96Pwp2LLY8TKiwiUR8SnSMOsT39bILwJhmxu/QGRu4Q46wbDPZVIDonqzxAuG5R9L39iZK5yolUzFGu8+gn0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6030
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 10:26:41AM -0700, Kuniyuki Iwashima wrote:
> While reading sysctl_fib_multipath_hash_fields, it can be changed
> concurrently.  Thus, we need to add READ_ONCE() to its readers.
> 
> Fixes: ce5c9c20d364 ("ipv4: Add a sysctl to control multipath hash fields")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> CC: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
