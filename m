Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F4456D20B
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 01:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiGJXxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 19:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGJXxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 19:53:52 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2043.outbound.protection.outlook.com [40.107.212.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E8562D7
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 16:53:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjuDkPn9gtccLVh36TwtrRrWJbivYVIf9RJL0xYY6edwaJXHgp/5rj561398vmBHluKVnyLu2T6iAFRjTKs4Ep3PkM82WuIJ3wyIhNJFgzAR8GsVfYLeyOgw1SlN9jWWwoCBwzsaWf1sEt2d+qqyrzRJAG5CkQ0SXTqu9dNEM5+2uv507ET56n9ARh5ZEXb/JW2/SEAYCBfL9j0TtZR4B4cgWxqCiUAONuUtcu9f2LGZh7aNTYcKhxm1lY6h3Zn0cCja9xp1cE71rlwbZ6aDNyLJTE7nRwuz5QNHBDl3+o+UkeadA7QXFfqmE8L3Sj5ozGA9fj9C8pZcDd31tcrIuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ajigzhh+L2IK+Ifu9lIoi2arY4WhG7LPz4dvoWNj7H8=;
 b=fGschdynS8bfgh2jBWH6gmNhKw+qaJtrVBWTmQBn+9LYHyhSA7UqjXfqSjBS6daEnIUiKSWn+Pua9bcE7rPzZirYmbTSR87SjYW3RFo5Nxyp9csqTAziOo1L8WS5X67M7oE4ncB+50+pvfkxT4TK2m8yptua+PmyjaK2j6JAHBW7G79krjfGtjXuHrl5qP7AWgXFHttc/ImSaIkzls/AnAC4q4PUsXvfq9FM6nWcAz20pZ0WYbvbT6BqspwuWV2+7GoslpQX/IXP4uZaYWrRfuF+BuJ0nUvzdlRaOCIpo8snSVLD4i1jadGAlhMfXaVZTrUKJeOdKQvjPZxQM3rB0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ajigzhh+L2IK+Ifu9lIoi2arY4WhG7LPz4dvoWNj7H8=;
 b=cdvsKd+hrDGkfRGLXv2pDMuOFKOY99cUJ7r3nsP01gvgno3WbLtRUhayKZNqBJ7xrk0nOhy0hAYJpSCMFabMACLPYqk0TjNhP/uQpyD61l2bETVkaPcTGDcHiaNWM562Wd874SdeKWerLF1+/yhFUvJ+hKZQNxccyE2IACWhTyvZKXkz8dyrlebrmy9kJv5/vBfOrheQ+w3Exp3VNAOutiHURk5nkPz5T9apjMulH9kQMGhTmH53Wy3VLSR57fjalBEL0QjBUpV0cC0IykfPV3LLQPZitA/VM7Xzm5LeoHBxJeFW0YFElJIFyfVUJEmR5JPL8E5c5Y45fweBjLL+eg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (20.180.244.72) by
 BN6PR12MB1396.namprd12.prod.outlook.com (10.168.226.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.16; Sun, 10 Jul 2022 23:53:48 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e9e9:810c:102b:c6e5]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::e9e9:810c:102b:c6e5%3]) with mapi id 15.20.5417.025; Sun, 10 Jul 2022
 23:53:48 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2 0/5] Fix memory leaks in callers of rtnl_talk()
Date:   Mon, 11 Jul 2022 08:52:49 +0900
Message-Id: <20220710235254.568878-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0025.jpnprd01.prod.outlook.com
 (2603:1096:405:1::13) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7e6e138-949c-4a6e-ed22-08da62cf6e53
X-MS-TrafficTypeDiagnostic: BN6PR12MB1396:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KPe64pCjbmxesSMla7eczGcEjXfAu4TBEY+L4Hi8AyiiaGk3PXScsSyHNfLDlYnzmbxYkH3X/gHCKdMrCAYW8ZYAzu6fXRWjR80MbSQ6tmNZ8WN/bcpOKVuSrKUKkHx+LVeksmRcMQMUuKvbxb1g8RatG7fhb0YlJSX3tQ2p5XEmF6fI/f1WFRhVnBZY3QudetyAyNosxH1BLGps6U4Ikhcq6Ju1FSg+itbdX2n8tLzs4TCsl4h+no6NAvY/yYouenyFnsSU4rPKtQWugCzoCCoXr74qwhQrQ0jjysxjSX/F9CQfnQ3lum691rCnG6zFcZeQhz1hX0yVhtFxqf5rE5CUHQMWpSDA4CykZglij1AnSGBHkYKVqas+nbeal/AcYFDuj4bz6xNmBy7NvD93tx80LMLDKvi7AZPU9PqKTRimXVQUiZ24tZXrGRqfuQcV4lMb0ZZJeIWb7ZVzeSfHE7FrV73Nk0Jo8BSt13T7eWgOXJJh2D5AGH5Z/HLLS0JWZa8NAonYgnk2MGT/3DJVXqWeEfBjF/WvneOYB/LGlrgHuLRShOBkeTkUznC+ZFyojqEnkvaleYdypqTVULvr+FadigohFerukXo7NjxD/6lZww++PiOV6+uEw212Sa4lqmSDAEQM4aISwRY6VGBTG6HH3cbYtjycl1KVSjvCP9EAwjh4wA0l6h1evbSyGTbNnlDM+OyXwHmlu0yzXabiN+1lNBWanbhH3DhuQn8ibGBQslEcxHU/d2cWmrpNyI6B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(8936002)(6506007)(6512007)(38100700002)(2906002)(5660300002)(83380400001)(4744005)(316002)(4326008)(66946007)(6486002)(66556008)(66476007)(8676002)(186003)(1076003)(2616005)(36756003)(41300700001)(478600001)(86362001)(26005)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CVAuWdo/HwJt6aXXHzKnBi9eYMfYJ+TMBiZ+Q+NjCnG3QvlaqzGQDAcpk5sj?=
 =?us-ascii?Q?+R2kolNtbdtruQPqHZWE4+l2EjC6E+mzW6bxY8sbxsuC5MQeFu0Pe9ECG/0T?=
 =?us-ascii?Q?QH6e5/IyfAFM9JWgeOHegAJBduDwMzv103rWxQscPZr7+Juw3H6T7L8+pEge?=
 =?us-ascii?Q?XqXxvm3bMe2w5fAasYgufvxoSwkjIy2k8Ss24z0mH8Ow83q4iEnQexSBxao/?=
 =?us-ascii?Q?OmIvcsUtxPOG8L5nZKhjZYJCziJu1HfgHtgQU8kf2gfRbwZpxnF9SGHERlJv?=
 =?us-ascii?Q?2z63DKq5zZdZu4ISI2XjbqOkykhRe6X5y9qPes8eVK2zJOtZhV7HyC7BU0Zm?=
 =?us-ascii?Q?U01QykaRDm7LNFtg42RExdRer1O/Iray2pZY3P22AfygV009DDujpBca0zVS?=
 =?us-ascii?Q?nhJFje3Ltxy/CU6Yk9eR6LIhSHNH8oZQZ9SXZbfDUnG2VCxfWKH7Rz01F4mR?=
 =?us-ascii?Q?EEkZjtAKMxpx183yWf0VTvhFge8UUir2H/WP929T67y8qQkvbdtpz77W0OmT?=
 =?us-ascii?Q?4vZ4QA4Bf/UD27w2LpcVNgcBzQyGKaO8WRLg+eBak12T80AdXjH2imEDr7V5?=
 =?us-ascii?Q?l4o6OUdTgHU8RAKf3lH7zUAEe0CqNfKjb91lw9GoKzQ5Yi1p3UPdVmru6dKy?=
 =?us-ascii?Q?7kYZnXOp84e+koWZLFhnb5F+JOdTK98UMLhIccWxtllg710QCi37mg00JohF?=
 =?us-ascii?Q?qhKyt9dJ3p9HHx7ujjeMPbFYGvfvB27GG0mhZQdwJokhxTsR6RWgyAlymH2U?=
 =?us-ascii?Q?MY0pHBSPO/U4XAYLT+Rv430olI+BjJ3hqh8Rj05/U4VbmXew65irSfDgs+1P?=
 =?us-ascii?Q?P0C2lJFrT3amE6inoJWmdj0RJ2dah5TMzGCPNmJGE/qL2YtFhpHCQVIbJeUG?=
 =?us-ascii?Q?E5Jp84VpWgxYJkT+/APbYftzTxDn8Ah4+nTcJMcceDU6otPF5uidC3Byj9a2?=
 =?us-ascii?Q?ljAH/VhoWJaH5Nuk6uRjGG92PSPixr8H1ds5cj4XnWjIPJIHHzxGmc32ZPWq?=
 =?us-ascii?Q?v3P3AGdRQax06edG/FjTwzZPvKC4Acx+Ia22I2SvalHSuMlpeQVejQK7++S9?=
 =?us-ascii?Q?7N60bAxSnFoHIODCjbcJVLzeCUO9Ilcj2wYCIiw9h1BMpRzdgWu8OCELb9a7?=
 =?us-ascii?Q?AiF1l8c5cGsodQVnamu9tq/7wsCg8pR1VJfzJ5c0KmDdTFlK2qVWQ3DHX4aF?=
 =?us-ascii?Q?5wzND9SR5jePHFAEjj8jFwGVv/d4kgxhlnhF1/FIuYdLe1KFzmF7fLdkrOPP?=
 =?us-ascii?Q?kdGHkSPAR/ui5wzxKGvI5jBrPjLLbTzUc+2vJ8oMZpzgPoJgJ8332j0krWJy?=
 =?us-ascii?Q?BgWg1gASCASPL44CfneCRttRs1JOJzfbLBv6O3MofAMeEV4vZorpRMb2+M4r?=
 =?us-ascii?Q?isBStA1WV8v6CG8VRLgC4Y2MvR35LdPqr+OSZbiRCQnj+3X5FG9vWwRWPYfI?=
 =?us-ascii?Q?jeSzOdbqySsCcpZLTKhdMcDX67B3LAs/q2QVpRwcB3JR6u9ocPjydF8uiquV?=
 =?us-ascii?Q?PjkjvR2W2F6NxvehMaSir3T5N6VMDOVkMTlnNlAkGgm4c/lNsIxsJUcUkKIh?=
 =?us-ascii?Q?HQbX4AZ0ry7gd3aeIjRVmHVmV64Ra12JSO0fgWwg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7e6e138-949c-4a6e-ed22-08da62cf6e53
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2022 23:53:47.8373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8+9djbKZpCDElRrWRQgAUFv4sfw6Uhi0X/q3XI++io+f1AcBRUoGDY5QGwY4De2dFyosS6RuzAGYe2MEIz0Yhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1396
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The answer returned by rtnl_recvmsg() must be freed by the caller. A few
callers, through rtnl_talk(), mistakenly omit to free the result, leading
to memory leaks. The impact of these leaks is minimal but they clutter the
output of valgrind and similar tools and they lead to inconsistent code
patterns.

Benjamin Poirier (5):
  ip address: Fix memory leak when specifying device
  bridge: Fix memory leak when doing 'fdb get'
  mptcp: Fix memory leak when doing 'endpoint show'
  mptcp: Fix memory leak when getting limits
  ip neigh: Fix memory leak when doing 'get'

 bridge/fdb.c   |  7 +++++--
 ip/ipaddress.c |  2 ++
 ip/ipmptcp.c   | 11 ++++++++---
 ip/ipneigh.c   |  2 ++
 4 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.36.1

