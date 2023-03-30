Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A036CFC21
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 09:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjC3HCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 03:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjC3HCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 03:02:13 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2043.outbound.protection.outlook.com [40.107.95.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD5B1FE2
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 00:02:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2LPAd2B67PZBmH5UHHM+NCP2Mi9lEtnG5l6lX4bF1gSZ0IcLwk5vSR9L9i0cjvm5wsANABML11ZHjvBsS8x7jbkoCyxdEUUgZ8fGQyxmqJ2WAKMlNAEDLy13TDQedCVQ7VTmjktJYg5gNTfwXazxh448Gv8H85Qx7jEKYHOTDsfeLLC/SNKRJ2TeQtp53xOQ2WOqRUbBxhKQvz6UhKaKTKbCgR9iLomenmyk8KEU30vql/Bie3ca907UW3hkz5pJ8zWuHG7M9poYOOUjX0PLllzp+YjoSKbDpZsFhGbgKUk53II8fJvVy46S0cLIoesqA0l34bEVjB7bceTC/7www==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14zvnxyah6qS25QRMX3INpnDTGgvp3znm4SzoE3NFD0=;
 b=TeK4i288g5Ly+DjOCfqFyhDJdOk4pJlA2T370KJok1X5Mmo9wavkSgazVc0qjhGKonlAkvtoib2y+AXNDb4bgaCBynLfNTDYCZVmy4DxAAHtB86bntA3p/jmX+ykx6AONCRDhGP18wN0gqnFa8BCkHkDatZ58ml7LxgmfSwk+swdIAz0VrBSXt1Rxyzy3u3znei5GOHEXzLmcOOikmPLwDzRMzdGgvNsDP8fJ24+IQb2zOR/oqwvKQhcWvdr0mpzIw/2iD8Ee/PpBaFT2NsNlOENI98byKwDNa6o2tFyu1HerfRwt8UzGFk8hFlzh5Cu3+NC7jxyGTOnLDNkJLVvGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14zvnxyah6qS25QRMX3INpnDTGgvp3znm4SzoE3NFD0=;
 b=niuogvoljYNOPJOsEHqzovl+Ikkj44pyJwMtATb8K3PHlbV6xgBm57ghOSa3Y9E6DVXX1fzAa4WKG4/LmNtjzPSO4UFt6XwNoi4Tzvaqbc7fmTlaDUpgPNSU/iLRlOZYtxgCkYV5haMa4R4swfmBXxlZoubiRJOQva/B8k7XlF8ttII76+9uCOmvd6rE4AcQyYzU94LS8AsTk5133gjYhKQ08hXRhG4TiLEPr9ihSbJN1Zc/HIwDnhDbcXgTz2egRWaKy6QuStwAr754Re8Hp3B/5ac0PpJsdBryzG6s8dYmOiy+QNKJ8tthxzpaNCoAr/zGYMS9GWm5bLYQIuwcQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB7785.namprd12.prod.outlook.com (2603:10b6:806:346::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Thu, 30 Mar
 2023 07:02:10 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6254.022; Thu, 30 Mar 2023
 07:02:10 +0000
Date:   Thu, 30 Mar 2023 10:02:04 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH net-next] selftests: rtnetlink: Fix
 do_test_address_proto()
Message-ID: <ZCUz7P66OGRJ9X2k@shredder>
References: <53a579bc883e1bf2fe490d58427cf22c2d1aa21f.1680102695.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53a579bc883e1bf2fe490d58427cf22c2d1aa21f.1680102695.git.petrm@nvidia.com>
X-ClientProxiedBy: VI1PR0502CA0016.eurprd05.prod.outlook.com
 (2603:10a6:803:1::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB7785:EE_
X-MS-Office365-Filtering-Correlation-Id: c32ebf11-9530-4f0f-c479-08db30ecae8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hh84Tpkg5kip0mz5gZKcUBqAoq02pB6P8gn0XL05ZRoTb8J2fbKY3m4oObn2Ob2bUSw+ERFL0FyJpxqJ9dsabZPujegTiM2TpWGNauqzIsF1khcNLk8FXoSwfTHY1+bEMxa37zVAg44cCUoC2F5quHQia0heWe2RmXJwaYH+TQYOoPqxsYEoxA1C2jXff15eQOt76AUXQBzXebcp4qQr0X6hnTctL8kkLRKKvq7MO4CNVC/vxFr0wJ1ghPm7zRzyoc1X5Chdpl3cl65ee+W71zWsyBZO0l9RmrHCPDXznhdn0Quqn25tJG84mlTU3P3DE6GK2l20BqKv0HBjbwsV6N+VgOJVJtwpAbhBNkI3xhSkty+hl+gocwars3iD6ouXob5P+DUbLlklLqziB9JP8jbb6f5zs3cjUWgO8LYGAjAQGECXavMs/bjzT65R/XPSCoF4MP64uKBaKraRJ6nvVQbTNzF6Olb1/9XJ9+2XlVjGIoAB4MUTZDqXpD7CfHjJ1hybRa9dWEaNUMdWZf0DQ7U8lKQp+ObwSQIWr5/BpGfaFkyO160NtpV1xvK837Q8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(451199021)(4326008)(66946007)(316002)(8936002)(66476007)(26005)(6506007)(54906003)(41300700001)(5660300002)(6636002)(6862004)(83380400001)(4744005)(186003)(6486002)(9686003)(8676002)(478600001)(66556008)(6666004)(6512007)(38100700002)(86362001)(2906002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r0FRv5KrMrszVkEk2zlOqcDhCZm//7DYCEFkVaQtBdOhmDv39CNYvuiSKGGA?=
 =?us-ascii?Q?fgi74Ck6x/55bi2qV9JZh1rA0eSVzLOOZITdOLN03yuTGLan6gbrZCtT0n7P?=
 =?us-ascii?Q?aq3SYQuvhcVmHcKw3FwD4PLSk9THNzafRWgOpyvQNk4l9ChSwha2swUm1cLm?=
 =?us-ascii?Q?Z79XMbfg1ohMgLAO0+/xAkaxP/1OXiVkZK4eMGuJwzw5qeKSFTZ/LIQnJq0R?=
 =?us-ascii?Q?j8oQtKlHCMjNUGXlNRlpbbtZwv9SyBtb+RFQkFqMrUNv3jysnqWaxxi7TQVF?=
 =?us-ascii?Q?8eTXyvdLiYQpYCMYzNOGldzuWWBwITuzsKebwhmMjmOXNBYFoUQNLgH0rtre?=
 =?us-ascii?Q?ATt9CoXsKNAnbNDf5O/3VLJf1sOTcnRfxqxDBAQ5iwdOLDj2AzUaM88eGOaO?=
 =?us-ascii?Q?l5oYlaRUj/Y7fmwUDMPJNFztyVxK3L1WgYbYDq7LaLjF9r2MOKGrIzVb+a5H?=
 =?us-ascii?Q?YhZ7ECKubGpYctS9ut2zyxQeuEKEL/D75giE/Lo9qboi9IG0IqjU1tqhLjDw?=
 =?us-ascii?Q?45QhmkfClfZGDj0NQF/rR0gFrAWbp7Gjw3dWf3nRiF0pBMUW9WGf4+yEUPwJ?=
 =?us-ascii?Q?7KkDKfheL4+2ED9MpGeW2G86j9kgbtEwm+/T+Hw35M0XHTq5E/8WnM73ll5h?=
 =?us-ascii?Q?rImfv6ad0rK80lhRYTwYB9PnXnCTxAjjqcBVQSeoVeDAiLZfJ2pTZrgvaZml?=
 =?us-ascii?Q?bkapzYGBHlNwlTv7sZHPv33X2m4r9Kd5KsbyjWO/OP5iHLnnsl7OzZeLM0Ry?=
 =?us-ascii?Q?/9me7HDj818jsnovhn62CvrFyhwyY55CqCjsx2lAggcLH5dn4ufqO1tVgt96?=
 =?us-ascii?Q?Hp5sGp9BjKnktAprI7WQ88e2MOus7lbyWcsB4BtmptxB8v5n2Pe97pscGDAw?=
 =?us-ascii?Q?z1RFBbcuSm/Exf1qXGHoZSAgHRmP211SUsLDyIpGyUwQ6rHMV9G/YDkNqnFO?=
 =?us-ascii?Q?acsGlB7FZthKozDlX4VRE9RoYTRZSfHj4Fw/fcLszjnAp2c+eSMMUD2uM6fA?=
 =?us-ascii?Q?BGx3JNEXgbkYf8GIAj1zgyxBwg9TAuDjxUi6u6a/8bhv+p55lJvKlltD+CqB?=
 =?us-ascii?Q?1WVRzgORC24ok4BDOBXgym1/pXRlSJ/L3rAdN7PeORFr9eIvUz9STaaC0ngy?=
 =?us-ascii?Q?V9w/fYduvnUg8yu1pF0nJwZYlMBCG2ysGVi4/3jJovPg/s9WS9xZZW0fbaIh?=
 =?us-ascii?Q?1M92UyydeJgQ3OYpUg5Pxc4C8klMNQvP4KpZnwkb3Xc1MSupAOOyN/npwBo5?=
 =?us-ascii?Q?K+LUoLobFCkwbHwYl0pP0/H5CuxDsl4iAsrKk5eisQ3QLxwIfldAm5rStuF4?=
 =?us-ascii?Q?489Hw2fgHAYkmS+OYy7XkwslVv1vZXCsXWWMupG+J9Bo+HjHoxYf2OicQ/jN?=
 =?us-ascii?Q?xmfaQFjsrdkYsP6mDAa2m8zEyYrmB2w2QLSAsFNFXvpgwsO+f27aOIdj6akn?=
 =?us-ascii?Q?S0nJkpdeqkyXkEiTYA82XN41ZPZhPs/S3/SRJ5pAEdX5/kVcjIqdxJVFFOSo?=
 =?us-ascii?Q?id+Sn9yScPH8A6MxwGp6uFuw5aVijsyaGZkWeKCUT5rEztfG0dSZRmKKetzA?=
 =?us-ascii?Q?zvkOM2B3j/r3k3Kit5+NY744JrdMrDeYmVH0p7G5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c32ebf11-9530-4f0f-c479-08db30ecae8b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 07:02:10.3865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/eMK2az2W1Y1RY8jSoZ9ZqQNgnAPHfvI7RtDHInPZcpoynG/MPAGV+fr9B2ZYJn4Q9qvyz5wGh+FCxifKQRCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7785
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 05:24:53PM +0200, Petr Machata wrote:
> This selftest was introduced recently in the commit cited below. It misses
> several check_err() invocations to actually verify that the previous
> command succeeded. When these are added, the first one fails, because
> besides the addresses added by hand, there can be a link-local address
> added by the kernel. Adjust the check to expect at least three addresses
> instead of exactly three, and add the missing check_err's.
> 
> Furthermore, the explanatory comments assume that the address with no
> protocol is $addr2, when in fact it is $addr3. Update the comments.
> 
> Fixes: 6a414fd77f61 ("selftests: rtnetlink: Add an address proto test")
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
