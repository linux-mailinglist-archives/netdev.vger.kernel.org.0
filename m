Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E31B6219F9
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbiKHRDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiKHRDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:03:16 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2138.outbound.protection.outlook.com [40.107.249.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FB4E11;
        Tue,  8 Nov 2022 09:03:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFI5gFvxqWD8HPRYQpvUenhzwnP9rRAYqh8b4iP02kMJgKIU6rBxOIsZPB9MvZW2mBQKeca2PS4W3LQe9BosHT6/EvX0JYTCrbe9SeI6vwYmELCvKgaQrvW9zRsvpK5flVXue1ora8qWTSZKMv8nQ/pgPT44fFc85Y7TcaDLYdR1a1JFjQ8W1njTaxw2u+VZdAywweDE5MMpZimRaK8p9eK7LCAs0Pf6jw2rNEXqx1t2Hihb0gTW3ZcStW/oRfo0a1XAciX5ILKmPRmRnu2nXDhBj3h3oImzfBnOScMmrunC21e7Q0u26Dlz/u/gBkYfWrcU7qPRFLVGCjjCvAsyOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AH+JwV70ixUWQs/S4ePrqrs8t0W9Z048c5g/NR+9wLw=;
 b=mYm1G48xPn/NUAZ0BsloyNyXCmHtPvU7vLJYWCHAxdSssNkEzS0V2xSg47QxIWgdg2R6WdLEtj3gDs/mhVtE1VKiNPnHCXkQGkaMT3dzMPJiNvDhd8BkvlESYq2C4HjA7BDH9SjESydX2qjQ5WvFPanP48W+cQNDsLvrNnTNmBdZ6j6wHixa9mFxsdWMpqWnpkmu3pMJ1VBA2il4samRNS7+drUwwt1tSNbS+S9u1VfYOSPpHcIi4/cvY82iuZgdBUAFolIoB2PFjmAZfhYFdhKajIUQVRsBRtuDx91hUmxkRaaKN/vR5Zchx7bxQMIcad3uZnU25oIh+bvCmNvKkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AH+JwV70ixUWQs/S4ePrqrs8t0W9Z048c5g/NR+9wLw=;
 b=Axosxqj4LQK8C2AoYF/YZNBazmvG45cdECcxP3LmGNSWUBXoQYyqfAfx+UteSYLN93u6oujCz8PQDlyBEV1eJXGkB5KvrmSeVsr3KIZreUipcDDeiL15GyzSgV8eG2Gzc2qIDZWZh9My9ORKPavBfHVsEVZ1Z1D/6X7T+j/puts=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by AS4P190MB1951.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:516::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Tue, 8 Nov
 2022 17:03:13 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::4162:747a:1be7:da87]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::4162:747a:1be7:da87%4]) with mapi id 15.20.5791.022; Tue, 8 Nov 2022
 17:03:13 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     linux-firmware@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mickeyr@marvell.com, oleksandr.mazur@plvision.eu,
        serhiy.boiko@plvision.eu, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, vadym.kochan@plvision.eu,
        volodymyr.mytnyk@plvision.eu, yevhen.orlov@plvision.eu,
        maksym.glubokiy@plvision.eu
Subject: [GIT PULL] linux-firmware: mrvl: prestera: Update Marvell Prestera Switchdev v4.1
Date:   Tue,  8 Nov 2022 19:03:01 +0200
Message-Id: <20221108170301.8539-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::18) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1P190MB2019:EE_|AS4P190MB1951:EE_
X-MS-Office365-Filtering-Correlation-Id: 81fdd3eb-5e5b-44fc-54af-08dac1ab1ee3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zQMeNnrblZtXzb/EqlIZOG9ym1aJQSUEzD89WB1vU8TAcmB+rKMecZrB8rNLk1aS8MsxLf4mE8byC9lc9tXYO3biDTQ9T13yfsDmaLx9ZQtffoktwIrYbSOYS564zGI1aK/qkKm8I2yLqSxb2l4uCogPp98nIBTZymtxcfN2p1a9joFN0ocWEY6uB5Rvt8NrpKLI6vHTMdyMMuWvke5hINdz3JkjLEzVcYlJwkuutB7y7r4VnZ42NY9TVwX+umJjKILVDhDRQUlYl11hibrpgGwdqTrC+fEr/2kRNaO69BcWzQN1TAtkeXaDaP00g/2hQGlJQGn05ZM3ePpiTwzTQcBnlUu9HlVh9j0RXR22QiX8/KKCVX8TD55iapsSbpPJV42wVI9htfZZEkixgXNzAv7dkB9Ng+jCLUqzVkVItSBbh6pb8ItJe/+GYFZO4Socq2oq7nVXLmOxth5tPfc5Mr3ONQNVbL6A2Ph6D2g1cXOrZfb4HZuxgW0/AZR3uZDH1tG1/UH1NxUOcm/F0/jFHHEcdZQ6TzW8MO8iZ9nTKyfszMhEMtb8sFnzO1PF17Ci4WBUYUoHjuJn024qGSAXtK/WwOU+9e2xTc93dOJs/cqSKWikqP+s8LbQhX8svyL60IxxqE9wGY8DU/+TX4uLfCg9TWHRSzlONQufkLJDdOXbXkDjQ3nH3N2wj+l1U1w4hvTeR/qY5bIfpNza01/ijScNXENWJBH0USZjij+8bvViwQlgHQ+yZr0kFzVu0EDuHf8eN7HrnCJtz62nkR9z3jgcBV5COpuREBylWxXuJcU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(346002)(136003)(39830400003)(34036004)(451199015)(6486002)(6666004)(6512007)(15650500001)(107886003)(26005)(6506007)(2906002)(36756003)(966005)(52116002)(316002)(508600001)(41300700001)(38100700002)(8936002)(6916009)(38350700002)(66946007)(4326008)(66476007)(66556008)(4744005)(4001150100001)(86362001)(44832011)(8676002)(5660300002)(2616005)(83380400001)(41320700001)(1076003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?obAcfPEnHsUFF4a5UReAk5S8OtoV5hkups1FMp0UOFSYg7dq8iW/KCMqcdu2?=
 =?us-ascii?Q?uBE3lKu4VxMdN9VFxaM0hLKaQ49aYYjvPlRCD21Tt8y7Q5eYiRuPsVVGR4nN?=
 =?us-ascii?Q?++IuZtOuSMhCZOMW9ShBN2tP4IxA3+fUtO9NMChey+uwkeNxL0kXHxy9A5Fb?=
 =?us-ascii?Q?uLJ9GENHyxHP3WwEuRI2x4/WStv7IoGSnzhvBVAtgZAlokQ26q/kbBdR/qvA?=
 =?us-ascii?Q?hrSWrVpfMVrpc9Col79LE/m4T++eyBP3zoeJaHqYbcZppPqOhxRtPAVYOxyR?=
 =?us-ascii?Q?ChKW8dkCqlSji7Sf8/mtMb8N7HpQ/q18a6COO47htvzhDw6Kb3VbQy9pwhxI?=
 =?us-ascii?Q?WLi/OezTWfLSkW2OH1EqEkjKzfdXOjPq3xcLOE5W0ZrXIVNrKw6phCAGgKTf?=
 =?us-ascii?Q?QqhCJixXVjw+jZIk/jiaWlYC7GR4QPZCDsB7N9Eq47z+0nsZJO90pXVqNDJY?=
 =?us-ascii?Q?GhWYwmHYmYsrJDgLj7o+j5UXtS4h2mclkC7NNspFa8JMuSmNrLdp1gjDIjP6?=
 =?us-ascii?Q?ughkyIjHcF4HflaObEDQWG/ir+2BB67AvDZiOTR0BCMKbiIX8Zx73/e8Y+wh?=
 =?us-ascii?Q?r5BJEx8hsI3ThgMfKmYGqN3re9ZuypO6ogcxy3Mq3qaiLIzcJqFZqNEEoaco?=
 =?us-ascii?Q?olklbgn02CfKfv0P42snbENDjyj4MKDqC243UNljJ8L5Ib7oQKotDUrfuEBm?=
 =?us-ascii?Q?6Qb3QZIjHbpw/KUJSHMpatZTktwWHg3DBS9fy1jiKHfh7DbF/gPGpY4tcYQ3?=
 =?us-ascii?Q?rv2Iu8wp78pB3I1N2a4MngLhhM8rol5qByCrr3UzHvv6CATP6u6y7b0psY9e?=
 =?us-ascii?Q?gW++ZuYNdmdpZWhkcgytOixemTwW6mytcd9HI9Pi72ZBqEef7AGBJR0KEvJf?=
 =?us-ascii?Q?mKtfvDHEyeRU1DX6DveS1XjEJo3JS1HddPgrRaFUun+gvSaNhsAxhPFHZtJh?=
 =?us-ascii?Q?jAloT2FcTJ216LHcpXgV3oD/0PqCLVvdUDPnuk5CWiaQQyrPL71pfWiwEF0/?=
 =?us-ascii?Q?bs29G1mNxV8JR3FpbcnoF42jddGTulw+RQHexYFUAmbO80yJuFjMP2ADGNw+?=
 =?us-ascii?Q?XWmnC9yZBBP4ZbcfTYNQqAuD9zUorBOGxqjIf3nJDK1cw10Zrcca+NeVOIx8?=
 =?us-ascii?Q?gjnXS2AAi52BDIfMFEWWdDbzA+AUMhW7tCnC53HAfqdoePqu+wKH+4f6Ogss?=
 =?us-ascii?Q?OtTRt17+u1aNyXVk25NO1SI2kZtCOAERy76ieRgwml8sKL3lCo2Y3MFJHcZx?=
 =?us-ascii?Q?mINqTiGovWK/f/G/o0d9yvB+OJRlikIXtOkXLW+92VCeO+wA2i7wzymWYfpg?=
 =?us-ascii?Q?Q4q1v/hmggxpDxnPHAFZalSErcFd9rT+5fkGLey03VzeVQf93ENQ1GXU5ZDW?=
 =?us-ascii?Q?aZRl7Du619TJOkLQI1kuL3O57VdkwpQ1AxW3ye7l9+GI1Am0COj0H8UFyGUW?=
 =?us-ascii?Q?vb0/gOLllVuLFYBGEhVjzu7Xs/U+xMQ/kK2anhzhL3x5Ah3hwPYAugvMFmA6?=
 =?us-ascii?Q?gVxB2upBhJ1DGiJIWDe2ipNXZrRyCfiUNc29tQuQuoH4Ax58ctxX9iNpxZ9z?=
 =?us-ascii?Q?8q8FkJ7zdyASOv6kwFSJ/r/6hY5iQeYvkjT9pLw43yfWXBgt2JkDvDC48zL4?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 81fdd3eb-5e5b-44fc-54af-08dac1ab1ee3
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:03:12.9848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+ndqpi3D3U7HiosfwDefsqjUE6HxtB/pKC/uNVXoLlkxodsimQ/IF27sbYrwReUIy30LuOJygMdr+SCpsZMIquLhgnzM5xUM4GbCXL7anE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P190MB1951
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 8bb75626e9dd831d323c4e460414b56260f0b700:

  Merge branch 'for-upstream' of https://github.com/CirrusLogic/linux-firmware (2022-10-31 11:12:54 -0400)

are available in the Git repository at:

  https://github.com/PLVision/linux-firmware/ prestera-v4.1

for you to fetch changes up to b15fc2134a655900168832efea6ae49d96a003c7:

  WHENCE: mrvl: prestera: Add WHENCE entries for newly updated 4.1 FW images (2022-11-08 18:42:45 +0200)

----------------------------------------------------------------
Oleksandr Mazur (2):
      mrvl: prestera: Update Marvell Prestera Switchdev FW to v4.1
      WHENCE: mrvl: prestera: Add WHENCE entries for newly updated 4.1 FW images

 WHENCE                                        |   2 ++
 mrvl/prestera/mvsw_prestera_fw-v4.1.img       | Bin 0 -> 15369292 bytes
 mrvl/prestera/mvsw_prestera_fw_arm64-v4.1.img | Bin 0 -> 17505368 bytes
 3 files changed, 2 insertions(+)
 create mode 100644 mrvl/prestera/mvsw_prestera_fw-v4.1.img
 create mode 100644 mrvl/prestera/mvsw_prestera_fw_arm64-v4.1.img
