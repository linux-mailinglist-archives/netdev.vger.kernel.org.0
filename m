Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51BA5AFE4D
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiIGIAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiIGIAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:00:38 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BDE4A124;
        Wed,  7 Sep 2022 01:00:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WG0q1NnziZvfJ2hYNczlqYhm7+zfPRcaGKSj7Wu6/Oxq6unxrIWPXCcU9jkrrrc7rwIh8caYgu1E9/GyQhZZFyDDEDVRuYCYCXAAy0G0DB0TqFjNmLaVEM4WP1Y+aS9FpCkjiO52xmT/32GQmzWvx4EpwwU5Np/jv+Gb0/It64eQWOE8cC1xHKQFJA7rbFY6ooMKpNBV4wnfSRPrEvAjyaGiX9FyMiJDInO214Ujn1oNzgxlJnLCFyZiNXtJhpOqunRg1ZhrHuCrtZuisUQqYjs/+BvwmSFTzQxw8Jl+gc4h7Bq25PfMGJP13Z7hY5F454Vbhoe5wkRUKueMpQ8brw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/tNg58DSCLZ2F3Wk2SxnoEgj1muFl9F8pIQIAJ4BCHc=;
 b=YdTXsVJCqQlpRlFTffUkgbXgzbjcHTTOBZFosW/mMHMZ9+U0baFPGtQbNh/7dUtRNhtQUdVaKB21ah0cCKC4O1TarbUNVFxJ16fXuR3MDnzSf+kS3mVmVl4xCAKWqTBw/9ZqqPWTMUqzNqtI4vzEPy/8I4rXu+OA8uP3N6cxRJwTds4Mblwczc5+HB2FJdG/QBNuI1UlsMlqn3bpm7A53X4k4TVmrHp3v446o4xDA9ICbcNf+9R/P88uVYEz+Im9L1Q6vPtdirt/ZzWUV+OLXkcpgDbkEYzEA9f/Zvw/ehE50Qs+I/X5kj2nyVFdUtQHWlvGzTJIhqawoQYDPuLxbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/tNg58DSCLZ2F3Wk2SxnoEgj1muFl9F8pIQIAJ4BCHc=;
 b=WJLVpdsf7J+uCAVSAX2gtclShX/kF+cL6mGGjNuxPWWTmwB3PM7CbhVpvzX7SefPeU/1QrMqS9Ik2wTadzCxaEyMDH7+YqBPETYbcpRvac3VS2iNn/GdKnmoAA4sBQbNYBkMelhbHbHTFdG/MIKUDJfMIRjU9px1hffeFpa3z6hl9TLmYb3A4rhGM4oF0fBjMxTpnELZpi+WudH8L6ei3O/DFMLUCpszsUIZpDWxn2Tohf2GmSYFRKsBhid4bHuzj0xYpNxDTZ3gR/L8xhqGWQe3oMnJyisdEKtV/VdJNMCwB7AJLF2XkNUte7eREa/CP7SeQwnMBwJN0T3p+K5mrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Wed, 7 Sep
 2022 08:00:30 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 08:00:30 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net v3 0/4] Unsync addresses from ports when stopping aggregated devices
Date:   Wed,  7 Sep 2022 16:56:38 +0900
Message-Id: <20220907075642.475236-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0030.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::17) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9abcfad3-1d33-456a-38f0-08da90a708c5
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BBphhzRazDw0h/UhpyfB5OiOkzsdNGvE/lRhiSZ+gb18X4glkmlg0r0Ue+TXpVj0vBu8YG3x/YtbAs69yxdDE1lZsvbs7Dgpjkktu0FeE0TEb36PVsPIes5tzpuGavqcHrCFdVYgwD9nwShbgzYazThdTPrSwKRygdBUfGDf+MixJ8+tQ7Z/nyT6+ZJSt9Wp3riv4GyRkGsXCpwxWSzamEoDQLKNUulcX7jEDtyflwyorx3hGyzW4b3CvZeqYqaz5nWB+WfBW8oTyXZMKhLIec2pZgIZNx+CMcNfeRCYWqs75P67W6PPIPQOyZyDXavvQRrFdGZIkZNopXsW/sHXKzGpwvsVe3Zf2wSgpNmaTxT6pm7n8cI50O5mmIYs+EYTdGS/sj7NiRjKaXUgXXwNLIpC58he1sh2Z9JorkY2Znb8Ah5mTV3UVPX7BVjOasUHm/2Rbuea/frjo/tTPuQmqKj1uocBfc7wdtUF7XXhEwhGeZdskHqeTEUzvK/RrRHKohIn6YmchcyphRgM685wBsJlGPGUx8xsqgUQWdtAtZtcCZPMfybDJU2InLxK+Uz7WvQiqRngqIcn1PVgZnpQcee8CPyeaNuidJejYnlorduCjpg5niP/AFvubM/T/39QloNLm0PWLSL3XPiVmwlcPJVsXH6C+4+oJ8mgDCYSMx42KTxKWLD1eWps5GbtvKhaPQgtK4uwFpV6gi/H/jqLug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(2906002)(5660300002)(7416002)(38100700002)(6486002)(8936002)(478600001)(6506007)(41300700001)(316002)(6916009)(54906003)(4326008)(66556008)(83380400001)(66946007)(66476007)(8676002)(1076003)(26005)(6512007)(186003)(2616005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eh+mnpWEzRkkre0ilhpBjW5FTnzs6HpNLYk/nYu4Idb1uBcEvbMst8aXdqqE?=
 =?us-ascii?Q?3iOjUq5g1ydqiBwlx5NCBC1vRC7BKPKuZzbooYqYGqmquwAozG4FORM+IFxG?=
 =?us-ascii?Q?NrCEHYJcRFchpVAuyMEQiAgR+tgSdxjNjD/0GVe485WnVDLYP2Pg2YyuwAtW?=
 =?us-ascii?Q?lKC0PUkITWQIoI4XShjAb9luFaJHw2HDxCwWHH1h5dhxmkT3N7l8b3Zu6uuF?=
 =?us-ascii?Q?FZO/kZ5uw+x+OwOd7YoD+lmOxD8b0i1nCLcNKNNuSr/1m6l0IzAdA5pr7vST?=
 =?us-ascii?Q?RhBl3SqgGzPyjL9OLDtgJGduFkxCAdSAPsXvEswzGAWdTHivf7GYuVgJDynf?=
 =?us-ascii?Q?dBdhdYwjREPyHd2Irn8yEsd93rivu+pfDqPk/1SlSu4oKIubDqQ94ETp1OmC?=
 =?us-ascii?Q?khqbtgG68t14kNJJ0UxPMjJHvMbS8d6cnSDqHoyIfltHzZSUWaktbc4nfRRC?=
 =?us-ascii?Q?4arsO6JpG0SXQGfYMhBUsXLC17RHRlGB0+oC10CLYf5jrTrNKrGTDDEquBjQ?=
 =?us-ascii?Q?ysFHbzGBf2JydvC6U4MUocxYgi1MtiLaYmOi9IjQq/mrKFxFqQxgPiOUapYD?=
 =?us-ascii?Q?WEW/aWh6DiSf/M9IchhmRQHGUuts8Lxax9jRn+4glPY+Rhem8ZbPOM+exm7g?=
 =?us-ascii?Q?i02cpMXFCa1XYL3IbF8Jb+TUW7HvFaEKHbGIlUBWSkSitIi3pt+PNT3dbEMV?=
 =?us-ascii?Q?WAG+JLWvHEuaDZZ/AGq5ti6cCrS5vqSraY1kzZQ4B5AKJSNTCoRUE7EoWBOP?=
 =?us-ascii?Q?owJrY7nvJ/H3PuvR675KW4dQQH1ZPyc26fJ5d8wyYu4c7kP7IuHRMaWU+9ph?=
 =?us-ascii?Q?J/w++oDLCtGVi1Sj6rNUCtMycsrcNEJzEI+EYD3BkGz7kbCOBE/DYDSkryj6?=
 =?us-ascii?Q?Vr/cWrapHtnxRWagV7vA0F298qRJHobOx3ou+cI+mF72bQioi/2TlhUIeboO?=
 =?us-ascii?Q?0PRE/V7+iTEOKWPXfhwQA84/C/jthbIOUJfo+SKjCOwlFqckOAJXqmClsZYe?=
 =?us-ascii?Q?gk5YDMQI1vVUHFyhgsueseFe1fG+MZ8Xj9ZuBA0HlHKPyfviICr5mGnzYi4B?=
 =?us-ascii?Q?Ja5coydcFRb/RmVrqniSTnh+oFFx952q9rCGgWfKkpONyrlVLZ21EKRJrVMH?=
 =?us-ascii?Q?5dQOBgVJMZyOjyv6WWfjf8WjrjNrQFhLJDAQj+cEvGFctbEf1/6iTJWlK8Ew?=
 =?us-ascii?Q?7//WuRI2JvyQaK9R8mdn0WQ80a59mSf9EQfydL4hxXvDa0jU+mYYizfZ9pyq?=
 =?us-ascii?Q?kwygBiPDhgAei4VRpGJ0NXl45GfY5dxY7IGA0jiaZVOwUoS3Y9QQFxe3CGfw?=
 =?us-ascii?Q?hvOp9tYfrt7finMrvgeNr87GyTXA3jZjmzxNPwqK4gbvSLAdrW27O4WS2TBY?=
 =?us-ascii?Q?5M7Uuqg6EKx6srhMYBc/C+chuWwcxe7YNonrQ7UwgBXynpY/3wOu4jK+43cb?=
 =?us-ascii?Q?vBkvxbbEnNyilnCH1fJlr4RQ8vjcrxRo0E32a2Haz1kMEGJdc2quWWTDUygS?=
 =?us-ascii?Q?x1V0vh0Fc6AUrYziKoWeOnYLy1mMUc44pxlYchwjoM+cPKLkVe/bAxi7XxKk?=
 =?us-ascii?Q?t2Jib4kTyws3ZhmYVeK0Wv/8WyzDxfs8U1Zt2zu+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9abcfad3-1d33-456a-38f0-08da90a708c5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 08:00:30.8364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lsrJnLJ2ZGfQmuXRWRbi1y9cchmbzMk9E5VcSvS7tR/nTTa2g/wplzZ6tP9AhdNJ9oW4HtxL5+gOizb7JXZdXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes similar problems in the bonding and team drivers.

Because of missing dev_{uc,mc}_unsync() calls, addresses added to
underlying devices may be leftover after the aggregated device is deleted.
Add the missing calls and a few related tests.

v2:
* fix selftest installation, see patch 3

v3:
* Split lacpdu_multicast changes to their own patch, #1
* In ndo_{add,del}_slave methods, only perform address list changes when
  the aggregated device is up (patches 2 & 3)
* Add selftest function related to the above change (patch 4)

Benjamin Poirier (4):
  net: bonding: Share lacpdu_mcast_addr definition
  net: bonding: Unsync device addresses on ndo_stop
  net: team: Unsync device addresses on ndo_stop
  net: Add tests for bonding and team address list management

 MAINTAINERS                                   |   1 +
 drivers/net/bonding/bond_3ad.c                |   5 +-
 drivers/net/bonding/bond_main.c               |  57 +++++----
 drivers/net/team/team.c                       |  24 +++-
 include/net/bond_3ad.h                        |   2 -
 include/net/bonding.h                         |   3 +
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/drivers/net/bonding/Makefile    |   5 +-
 .../selftests/drivers/net/bonding/config      |   1 +
 .../drivers/net/bonding/dev_addr_lists.sh     | 109 ++++++++++++++++++
 .../selftests/drivers/net/bonding/lag_lib.sh  |  61 ++++++++++
 .../selftests/drivers/net/team/Makefile       |   6 +
 .../testing/selftests/drivers/net/team/config |   3 +
 .../drivers/net/team/dev_addr_lists.sh        |  51 ++++++++
 14 files changed, 297 insertions(+), 32 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/lag_lib.sh
 create mode 100644 tools/testing/selftests/drivers/net/team/Makefile
 create mode 100644 tools/testing/selftests/drivers/net/team/config
 create mode 100755 tools/testing/selftests/drivers/net/team/dev_addr_lists.sh

-- 
2.37.2

