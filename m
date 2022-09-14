Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2B15B8271
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 09:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiINHzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 03:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiINHzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 03:55:20 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB4314D34
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 00:54:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VaaCBlzdX6/u5nl45m9bMlOf1gzMJO0OVSOTiDUDWpI34YIXW6YTXArDsraH+ifHL5UIPg3AuGvyy0QfM0QilP84FW/bbt14aRhgspTLvvC+kmbDiHkFZrZI1UeU4g9HE9qUd2DIrySG+xxhQWTVKf4lm9+zhlnJshHlIMznYiv/CX7srH+sj7VDWTaeAg/eeTQYTttqB9yJeUl8qpoJobuB6uFwpOepd8Y6H3AXWPr/NyD9iW4SNQQuHzKQ+T4WhNkWm2Z3EYYzQFY4TnC5rjPoRv6UKaOCQh8ZS4w5vry7MXggM7J/w98Du1edBvzuGw0qiHN4E+nwVagqCfnBoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UMODxaFu+kiMDjNIRWcM/9VV/Vfgy1pYTF0zQ+KE78=;
 b=EBpfLgfwYovwq6rr4qP5+B5JBwpKsWDg5aBc/j+mwO2ts5HGmsjbiUoHCxdLnUqBlhdOyuPjDoO8HAzodTYTYqJ9KIzlEBos2gR2kjYu4EI8C5aOH/PaH7hwivL3q76mTJKD06FzcxglziNN9UTo4bsysDkKqiVjTyFqVKzr10uoZxF1U7Gjo8qtQPM2sBD+RUlSNLXj80Nypxbj8MQ8hdG/mGCjSWbtk41sb4OAi7SsVwWCYl3tN5bS3mWzecFUJGfquBs7YiCGnwhzsEkLvLARdLqri0M3IdqK1HJo1tGBUoVmWutkrLyf/5wC/qngScarkwf2HBlWFLrLoWIxaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4UMODxaFu+kiMDjNIRWcM/9VV/Vfgy1pYTF0zQ+KE78=;
 b=l8qhWoSuN3dCs5Jx3Iy6uRwAXCQcO59+w7CRW8is+gPHZzmCiXKDwtlBpheW7EngSGZBl9/zkErogb6v+1dFCJg/F7TiVdP2SRvu319uCRRqKBzFHG+S1BHwAsl0OwnmSzvAKl//hioQsQBylnc0GRMmhnpTCJCHB9/uskzJFmAZMjLE71q13ZAV7GjbGDKQdTz2ZW9tFS0QUZE3WVLsXQjHdQVh+iEeMfgWCEAbFPEq9Fsqa06++uVp9tGAYH1VRI1qD7nUpbEA/YTUCJCNoMlEPTadtxaPdUFRlMhhDb172MbFbFygeM+Y02YPciyqVQe3Q69EKhvkGtK6Yqxdtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5454.namprd12.prod.outlook.com (2603:10b6:a03:304::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 07:54:50 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::18a5:7a35:3bb2:929b]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::18a5:7a35:3bb2:929b%3]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 07:54:50 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/2] ipmr: Always call ip{,6}_mr_forward() from RCU read-side critical section
Date:   Wed, 14 Sep 2022 10:53:37 +0300
Message-Id: <20220914075339.4074096-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ0PR12MB5454:EE_
X-MS-Office365-Filtering-Correlation-Id: 812e0876-e14f-49e5-deba-08da962666af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AIbrtx346LsetZHx6Q2BqfQ95NyE9XN0+cd9ILE8rwitrdNHOwbIdX/bgjRDDR9QJRAc8wbcWWbPOJkpOSiDeYMmKhAd6ClIn5R7FOhN3+OrryQcXGP7a/1xCW/Xk4LiqaJSpEprE2UIHNFPkwam/9zM0u+NK5i5HelSN7BMYGc/2Z2hgNtIKKL0voVhKc+6qvY5c+bYv054VKVHM4dE7WNQo7gTpvu3Wtt1tsTsa31ikVwRZlRUOUy39pHMKyORFK7uhwRrsoIWv8DlmDM9Ue35j81bs2kb08hA6hHmWWTUbvZxxN8Mvci4WyCmIE9wy58ZEC2pr+c2dRJMfKmzQugrfTJmvpyZBI1rY0dM2sq/k/fE6xmlcu1REwSUg8huouvnw9oq+8ic3sfzsBV6Zns2wTGvH+4w+2n61+jhsh+PwCQWp1ptCpq0TjLZ7Qo+oFCBNHPSbL74JiKqCvf/soEFKFqMxEzRGw95L6lTPtqs/9GIfP2530n8yjyJIs2s/pNB+9NctONF1FuDFUj4f6Z90yNOWbbxAQwbUGSkpgP7g3W8vAQmMamgE+GOROAPJFvhW1Z60vB6rcDkMnrdCSJaxFN2e+BH/yvBOe3nGPBebOJT72l8rUpwZRDY9pqC0OfgkahqRiA9Z5sG6cOqigjgjUxvFsPIg+pGZ3UK7k592Y/PN7YClvAZU/vR9fNkMfljuhdAe5X1axUea8BQQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(86362001)(38100700002)(6666004)(41300700001)(107886003)(66946007)(66476007)(8936002)(4326008)(8676002)(66556008)(26005)(5660300002)(6506007)(6486002)(478600001)(6916009)(83380400001)(66574015)(2906002)(316002)(4744005)(2616005)(6512007)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+qb8xOTIQjCr25MFeL3d0CwJo+aZDb+5ZJRlpInVE+YVv8q76HgbwyF9CYoU?=
 =?us-ascii?Q?BoRsnqVcCTHXAHH82GistvbRX4n+pk6fAWi/3wUo8t2TQl1WxVqHbWYbqg0D?=
 =?us-ascii?Q?u5iapb+qh9kDo+GzhUpPlA629GVLZ3N8wbR49uNIDd7ycNIs8hWHcspqSBgL?=
 =?us-ascii?Q?Nae0v8+4c20qnstixiJDIFFY5geaJYlvLCDVDrW5mlVfpJbDbp+T0W1ZcOkg?=
 =?us-ascii?Q?TKJDWfUQ5Re3HWYHjKh0sUpq2WmM9kE/N/GX8YJnTPGIRng7fJTJN4P+aEyn?=
 =?us-ascii?Q?14b5kurjQNZ8xSlYIclWDmSYw2+BbHUg7eP/6b2wEy+Ulqj7bJqDbkbQCPLk?=
 =?us-ascii?Q?4/1dfsoD1F9MtmxBnTrUfcuZqx4aWVoYDxXlswl13tEIllZIjD316Fv8bTy2?=
 =?us-ascii?Q?vai7ge3qMIk01aiQNiqqNFVo0DRenA5I2JZypPKhfUzFud7Zo6XkKFQYFObC?=
 =?us-ascii?Q?6NGOHgk78LqQAZKwFu/fDC/UcaIiIfKCReolLXuKmJPQpipURsDNgPhDWIgO?=
 =?us-ascii?Q?xMQ/srI65Bic8Pq3kxNS1MZUBm4TvDW6or5JgdTdAt5EC3SqpxDK5RwC/jqf?=
 =?us-ascii?Q?i/Fv2uhKX8+Q8MvX22HXR336tDp8xyuriD57TMBl8KNflCX+8RpqWd+EQXJD?=
 =?us-ascii?Q?174QsQ9EhiU3q0mOQbQB4ps1IilQwPNu8f/f0wz/VTluB5d+46026k4V6y6w?=
 =?us-ascii?Q?hfo12167crHNH96HvitZyOzKlebLLzq9O2ROpmlzQxXw45c7sikWOTtROLuL?=
 =?us-ascii?Q?8ljn9u2afChffUfGpxaD9D3TLZA3m9xB1vs2UD5MmEx+b4ghwfCe7TnLGGE5?=
 =?us-ascii?Q?q4hW0AOesM1NYjtIMUuIDhdtKihR8UIknmgbV6zvLSz/MgqSEhuhIWcFOYIn?=
 =?us-ascii?Q?oBSS+ihcyqn8/MGcyoktnhswf2nNxFs0XS90JlqCXcClS6eFivb4L2G4uB7T?=
 =?us-ascii?Q?c8VM2qXFXuWG6vmiPwIoLZzgWrE/AX5zS/3N+WSG/Fg7EVM5Fx8Q2k+L8Su5?=
 =?us-ascii?Q?HXeP0JoxX7UUOAwu01gq4tVONW1ZSdMIqqN8oRW+Okb2vM6tPhKVMv3MYXTh?=
 =?us-ascii?Q?PRLPB/Ll15zQ9C6npdL82vOfHSuMp2Xnl4lJoj83CTckwMi4Vg1PMLW9w3Uw?=
 =?us-ascii?Q?c456QFb+Jb6zxDIkRFUCtlpYSf4slMf+swfYs7D9owlw9DwO1YTqVGbAt2aP?=
 =?us-ascii?Q?1DIcNazE4g9YqWjV6rAtzE4505Z0IQLTXYMs+8OwXcn9s+kraIj4OUmxrWUL?=
 =?us-ascii?Q?W5rBPhiQm7xAL3yfnErmrnlzcAe63irZ5KfW643dH6mCIxxwvOlRKf1PCPSU?=
 =?us-ascii?Q?FH9F2dwMohOYPCYD65cSF/2tef2ghqdOQKJTDZGNM3uGpBGP/JK0frS7S52t?=
 =?us-ascii?Q?YlnBU64QOlijxIDbw1rNyw4P+MiLAHGSTjy/5wemxqhMFBeXwvBuC8lvJHgf?=
 =?us-ascii?Q?NlgoYeJk0vhkLRlXGl9uh6CP5HJu6pqdHF9TX6iZcLA4sgojXJqnHXz1u44M?=
 =?us-ascii?Q?QvVUsHZk6Gq8J5N3rR1XGxROfqXqYMyFiD2H0s9/UvgHYiQ6jLLyLEB5xv7v?=
 =?us-ascii?Q?WjHSNOx+//d8I6HZK8+lHVMZJ5yJK29O7nRiD4VS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 812e0876-e14f-49e5-deba-08da962666af
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 07:54:50.3009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQO0ylgOEToc3Dxdmae/AoC9h/w46xT9aFBwEMsesle1NDD+AJe5qFzi7RvzXs52ob+ZoBZlBA9j+aq5zXILLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5454
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 fixes a bug in ipmr code.

Patch #2 adds corresponding test cases.

Ido Schimmel (2):
  ipmr: Always call ip{,6}_mr_forward() from RCU read-side critical
    section
  selftests: forwarding: Add test cases for unresolved multicast routes

 net/ipv4/ipmr.c                               |  2 +
 net/ipv6/ip6mr.c                              |  5 +-
 .../net/forwarding/router_multicast.sh        | 92 ++++++++++++++++++-
 3 files changed, 97 insertions(+), 2 deletions(-)

-- 
2.37.1

