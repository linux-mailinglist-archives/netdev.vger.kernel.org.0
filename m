Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36865156E8
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbiD2VeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237435AbiD2VeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:34:13 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2123.outbound.protection.outlook.com [40.107.237.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFB4369DF;
        Fri, 29 Apr 2022 14:30:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QS7IxyS0nKmZDOCYU+D2iUnYJEneznhOJmRQoSW1lxS90H9VnAh6m7yd9IoxErp70BbpT233RuLk6+vcsen0dUcV3YlCdqHL8BditxQWMGk2mXAv9n7zYufA7Xng1G3emAggkPSFAnIuhfMqQSlTJSA0q955po4t2Bprsg+rrurrG83qnWCaxNDfPhCHRDPCoCMDiW9nVtUdzg/KS0eTz/lCS4/K1dXqq4WtYAjuI3MQnSvkVGnxG6FxK6ATCIZ7OKk4H3BRPI+9FC5SJCHNRHdUQXF6/V/lGOeRElGEY86lnxqQF93tJACiSBsJ09IYGX4YmHycGbpb7YY1vstlGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ygE+0/9jFGvkToLKUjXmTPQ0HxfSIKAOMb8VEQrV3QQ=;
 b=AoO720u72vWcqbtHpTCapIhU09/QLVg9SHRR1MZlYyBJhVbPJ/2AD4qWK1tZPOsTU9yPSMYLGqfC7vg/MILJDolP5S55lQrmSIyjkXQgTuZMKPxuME+q8pBlkXGsr01zkcx+z3pgBNQ1+U3FDpM91/Cxe4fxNzLUDi6haKrJPZb0CsN9QHuW+aDSTpT0yILw1XfNix9Cr8jx2Eq9wsmDYbV0yzL1gtGA26MfVGtpNN4545DaPjUijOrkt+/rTWUkyo/uO0fuNoWujh0IxEKi/BbkU8S+O/B0Jld2mIQhQSXzUy756HfErR3JYBIcx4Lhlzc4A0+kzHQNVL5FyIKXxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygE+0/9jFGvkToLKUjXmTPQ0HxfSIKAOMb8VEQrV3QQ=;
 b=uMej7AfcRR5DyeFBAX3GccY5/oGZr109ptf/LbHPaLn3rf8TkxATwO/PERUU3oj+34kR7EK6zc5tTVnzdaB1sx3JUmDrp91rm72LU1afrMc5WtuDEZxTcEHkL3S9h8rPmWKFcLD7nFi/PLSASXDmAE/yLcuALmFlYWyF+qVnVKs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR10MB1957.namprd10.prod.outlook.com
 (2603:10b6:903:127::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 21:30:49 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 21:30:48 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     aolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 0/1] net: ethernet: ocelot: remove num_stats initializer requirement
Date:   Fri, 29 Apr 2022 14:30:35 -0700
Message-Id: <20220429213036.3482333-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0200.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f6c852c-9a99-4df3-d16a-08da2a2786a2
X-MS-TrafficTypeDiagnostic: CY4PR10MB1957:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1957D6C4CA9E1F4AA5963FD3A4FC9@CY4PR10MB1957.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: efUS3NSR6K30b9MyY7R1FtpDJaBPNAPuOp/D+CYomMAspQkYfNVPXo/QDbE0pF0DViHgrkl2DaH+opEAsWiEEP36gVpT38yEEqlAOQSmNGcba4KGUQuHyR++TtKh6YkzBS77QfyEDrzvSpm8Vz5lGpMWFKQP8Pk7GB7qTU/9d1GzIC3zsTJSDlLpcI1kjUwOIoMQy82np6/ijtT8qld5IAueJbKdbW93i/GYRbCQVzyX5tvIBEqT+qrZTBVWX8EsmrP4aUn3MU70bPfC4H3JdUSEVZUJ8b8aTjiMsihR1KtHSqjlV25qDkC7J73SDrcDtBHzyyj2B/RC8yuhYxWHr8r5RJ2sp9Xwif1RvftPgK3gINlxPXCZTy/NKes90Ih+rTMWp/TLNV3q84Y9G5EDrrNmdq8LuClfUe/FAuFD4ikAFc5RBKIYavM02KZouftH4U+KkjI9b27Ncr5dNuMbUpQxfUotyWJzrSQgB/e/V+0VixrvW31h9/WswvuNSv1beC8BKRqV5LEfBLLK4Psml5TuNGORrA+iPXmkmIhxCwUS4gEbyzR25AfwFQ+1Ce2i2wJMLc2CpYGOs7eHcdycUKkwPTvW+fcjJ4fYB5XkVTVKQdhXRmLFo6uZm0bzmaZyiuYRd05HF9ffzM2YeJVcmuiCL9vRv69bDJiA51xgQzOWXu/DOeeYLwskSoFTgH2ANiNfrnF6NTiI3TygQbhTxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(39830400003)(396003)(136003)(346002)(86362001)(6486002)(54906003)(2616005)(1076003)(186003)(508600001)(8936002)(36756003)(44832011)(2906002)(7416002)(83380400001)(66946007)(8676002)(5660300002)(4326008)(66556008)(66476007)(26005)(6512007)(6506007)(6666004)(316002)(52116002)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nv9jI9vySsNzIxFaeNFALPwr0KUOMktG2xBO+QZHu+NoBs71V4uuP3Jr70Pt?=
 =?us-ascii?Q?Hk4GxojzasjibkiH5VL5EfPkO+E3mgsTqrLNWQp7tk9WU8YXzv1KI0SOr488?=
 =?us-ascii?Q?dknNpvhl934mqRfJ3Opeu2y2GEMyJabtnzLA6n2pfH5uc0PgXzn37tOWVC1L?=
 =?us-ascii?Q?EpI9EPKNsiizK+7WbFDcsr6UaMx+qLODYlkFMl58rAr9HzjghI6oL8t+P7SG?=
 =?us-ascii?Q?5igwtixEPeYdmP+CwqtgiqaWB7iQs/bx+wlLMlM4oWw9hwu7ytDNakX/hCHd?=
 =?us-ascii?Q?lXPsy0GF1E3Jwg41vXeg/FZVPwxXb4K7JS7XNvoZDPPhQmT7hTgi5L1veZao?=
 =?us-ascii?Q?1Y7DX5Y7Rb3ddtstKg+47LZUp4SqjFs1ANIFCst6Hs4xgWzbD4lxH4TPPyeG?=
 =?us-ascii?Q?u4ekV/8OilTU1PRrFpzz5lemWSN2e78A8ied4ew+JdPu82Vu4k+V+3NoY8Z5?=
 =?us-ascii?Q?a2oLtljjkKqaxBr6JvcyhRhYj9urIpTuu1YwFEU+7c1LtNBe/LeyVzj6o07k?=
 =?us-ascii?Q?6LGrq4LIrlFENd0REQ6vMj5gbo1MjK6qr6jPXAGlUcVXJ+Wxb38PLNeElUPl?=
 =?us-ascii?Q?PCPmUm/BTB3QAEH0Gq53En9j5xu8VkM7zwldYzHygI8HkjwdusjW7YxKEKC+?=
 =?us-ascii?Q?o0ZknJcxC9AS2Z7Oi89P08UDV/BbCiFhruVmiFr0kB5e9nv3Our5lsjUissk?=
 =?us-ascii?Q?zH3jBYpExyHT1SK8IcY0Y7cxodVYgurHYmDXfPmz7o+35emY61piT7wckAfj?=
 =?us-ascii?Q?p8q6XI0TRHkuoBSJNCAeKKVXaJP3YbTuIsD+K48namufPFGlukOoQ/pJwnvw?=
 =?us-ascii?Q?Bpmshnv1JKc85MAVW0OP/9Mj0ABUeBlpgU/MNr1JmDrbJlO4rDKQ5IeXGIFa?=
 =?us-ascii?Q?K+ZPFFE7Fm8OWtkSh9cauq9LAHnYWKZZqHjVf9SFaGIpvplhxGIG/iS9k3fI?=
 =?us-ascii?Q?MKmoIJ7FKyiMBRrLT5WYNqyGbuyPSJZ4iDN2o1UWxH2+uj5gxzZOIoHirw8t?=
 =?us-ascii?Q?1YuqFxzRjBASKUyAzYZ+ee9SNDo+yAbIakewx64KPFuzJpSav4oHQJ+7Al3V?=
 =?us-ascii?Q?LbuoBEXtZDi9QpfjHKGyQaO4T0hwdIOWtmJ7Hn610rtc3L7kTo5LnE2JwAAL?=
 =?us-ascii?Q?5Z19NlTOggR++BSpGWxH+0Y0t6JFMNDArk7C28MMrYWMqkzjPplWbiYq5C0j?=
 =?us-ascii?Q?RR2dP73Oi2WPjIMo0BBtFsdsn4SIpR850KhUAWjZqiDpd8vBZ/77WZ11ruwu?=
 =?us-ascii?Q?XnrdhLVtTjGqereE/3vS4wrZUQwHi7HScJ3jC/woDWnX2pQDnl6tefj6cN7Z?=
 =?us-ascii?Q?XjKRVw+fsJdDNBXXgRutesioYGP5+sKaT/NzOgHTduazXyCoZPn/Jkw+OUW6?=
 =?us-ascii?Q?M1A5wq9Gpg+sfAKUGP9xEWY9duDjlfdZr6581xqHlhBP8FkoulLoXvBw2ic1?=
 =?us-ascii?Q?OQc9iHZeVRHp6V+KBLdeabainhCFbnV4Hbo78+0Kd8+oZ3JY3wO1FIE/eeV4?=
 =?us-ascii?Q?OX0yk7JyynMghqNU/CMl1YaSQvr6CphAG19FRfaqZk3HmCMFO7PBQUU4+cLG?=
 =?us-ascii?Q?FanUPakuBfgukuQcc9kEF2a+dwHD7IZV0PBQYvHwUo+RM4kFYu1ZW38X+0Fu?=
 =?us-ascii?Q?+LIxIroofgak/TbcHBeqIdwiMjL3w+Yl2TZ5y0st9NBZsZfe2mv9a5ptJUwt?=
 =?us-ascii?Q?KQp6w8JnZqIPifFCtWbh2y6R+SBdkcIlchdnawwFXNIkzjbmnALxdltE4VxI?=
 =?us-ascii?Q?9WAdOIX8uupI/jYOGkE/omfVHWJBAYvXvwWQg5HF9hb4P8LO5pDP?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f6c852c-9a99-4df3-d16a-08da2a2786a2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 21:30:48.1942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c553Msb5p38c5DIayaYTXKodQmH/MYuCV0jlTkMgsQTojBWGLsoJKM5pAKfFRTS5U08AVRX7al9ppLRA8uCQJczGOuetY2G1wk0i0n3fadk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1957
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_stats_layout structure array is common with other chips,
specifically the VSC7512. It can only be controlled externally (SPI,
PCIe...)

During the VSC7512 / Felix driver development, it was noticed that
this array can be shared with the Ocelot driver. As with other arrays
shared between the VSC7514 and VSC7512, it makes sense to define them in
drivers/net/ethernet/mscc/vsc7514_regs.c, while declaring them in
include/soc/mscc/vsc7514_regs.h

The thing that makes the stats_layout unique is that it is not accessed
indirectly by way of a shared enumeration index, but instead is looped
over. As such, the num_stats parameter has been used as the loop bounds.

Since the array size isn't necessarily fixed-length, the size has to be
determined. This was done locally in the C file with ARRAY_SIZE, but
that isn't possible if the array is declared via:
extern const struct ocelot_stat_layout ocelot_stats_layout[];

Instead, determine the size by the elemenets of the structure itself.
This way stats can be added / removed as needed (though they rarely
should) without the requirement of dragging a size variable around.

I don't have felix / seville / vsc7514 hardware to test, so I'd
appreciate if someone could give it a test. I've verified functionality
on my in-development kernel, but wouldn't mind feedback from the
existing users who have had the misfortune of having to find my mistakes
when it was too late.

Colin Foster (1):
  net: ethernet: ocelot: remove the need for num_stats initializer

 drivers/net/dsa/ocelot/felix.c             |  1 -
 drivers/net/dsa/ocelot/felix.h             |  1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  2 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  2 +-
 drivers/net/ethernet/mscc/ocelot.c         |  5 +++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  2 +-
 include/soc/mscc/ocelot.h                  | 10 ++++++++++
 7 files changed, 18 insertions(+), 5 deletions(-)

-- 
2.25.1

