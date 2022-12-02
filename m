Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63056640CF0
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbiLBSRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiLBSRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:17:37 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2065.outbound.protection.outlook.com [40.107.105.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D66B30;
        Fri,  2 Dec 2022 10:17:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klGYqgX7DKl13lNBrhts+TgTe5pUaC2p1Elv2VEzgd6e2+5xZc1Mo76z2nEYS84JSKv43iPxaxbR1sk4cwR+YMrua+OrBxeo78/eeHyzlTu8MYuLjedJsq4RGQGiOTVyZLU5lOkqGTekTdCusXEHqIdpPZwjbMWZE/PHCUd6kJLS4B3bY9sxYwj8hf0wq29TtahaFtaCC3htF1k1K7edN44StKy5fBYCzSEe31m7D3ybOBH3FqooWBJpeBRiQB0ReTrL0PNYo8r4HdUI32RV8/uz2KXSjEAjcGm8mogbZSMwxCyyIBKS1n4WbaZzxWNcRgFpvUkQClOQkxFoGuhRew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSKrQhxPKU8KcJOoUBRFJquz0QyCs7ZRoOF2JuM6Ims=;
 b=SIQg4dh2F+30iu9vJU+8VuGzh8JI1vpZFQrO+aTHIoXjP1l7QxJ+JXU+wMt763loUXYn2rKDTyUBVhGI1LYdcLdTLp9vn98zBXTle/0NLKtCSGa2caYFqcyDEllwzcuAFTii/EaOeWpgNcyF/3uJQoMPSKIbYLlaraXW+IJedBTkZW6On1zac5kdxb6qU8S/KnMt1tnjLMqCJtzVSEHpUuB3szyZY6o51ROXASVPm5PrRzXCpxeFp9sCY3Hek8Sk2Txk8blUvl6xqBZNtRamh1h7iTWId+cprX8A+ky6mh7MhxnO5J5oBMBLgi7/IsfnlHOjfKBUXLsp7uQ3PtkIcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSKrQhxPKU8KcJOoUBRFJquz0QyCs7ZRoOF2JuM6Ims=;
 b=Gc2QrTdqRCPW/+xdggkSCu7vYeJpc8Q6kYAYjK9xKDtThqGYjptNOA+BRYtpQjrT95TkmzCmvruAPC08QW1eSNRw8I1o8/sx19+9bWv4uUHRwlgFPlfTY3nO2Sd9puaDZLEHuZ0Q5IW714NH4q5k93vm0nRZG4VdyhHkb3OlXp8dlxrSJbsLE0BoNSssHZuN35gB9vj3UUtoxIN5BxItaX9oLnMBH70xNWCeD/f4Kk0eweF4XMB7WZARFJ1pBNYctmt/l7s6MhZmIqZAlJqZcjXd1UNqMnkezaK5n1s9NyyANpaBsqnXmLxvwyx9dbTHjRJHYsUm7aVBHLNNjxW6uA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DBBPR03MB7081.eurprd03.prod.outlook.com (2603:10a6:10:206::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 18:17:31 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 18:17:30 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 0/3] phy: aquantia: Determine rate adaptation support from registers
Date:   Fri,  2 Dec 2022 13:17:15 -0500
Message-Id: <20221202181719.1068869-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0012.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::17) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DBBPR03MB7081:EE_
X-MS-Office365-Filtering-Correlation-Id: 32ff6a25-478c-44b5-5e0a-08dad491790f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6BoWFZQJmISJueSG3Hf4uayRx4BE3sIM5g9LgcZkN+B48tzopC0Tt2810HjmXZ7VVMJM87+p237NJMdEnvt369YoPjWqKdo8phiIzGjxr8P2b/Wpw7N0P5ESYYECG0QLDUpevPIFgZ5kyKlcOTDXcdR7MATc0JICBfXsoNYjI8dkCgGQ+SED4Ncn9NlVGutwJxH5S7nYqpnhrUxdOgBEtCtixFcWDvL/EQa7I0ALkxtm2lgVjUSlaJ1N36RmAbBF0tR4fJdiABvU82PcuJOQEAKRRsHqrXSeAvUQIsgZh/MxkV0FpKcEeqCIjffObZDMbavOfHFX0Nt9YQP9sjkJ2yWWjh/vDD0UTOoDFUfdg+iyUwYAXZ4qlR3AJGqEe6qD/4bvY083Xpq+IAj/IM0TvFTfmxTnQ2eXPNcHeW69gVRh2LJtLLatVK5EGov6ql3rm+ueU5CJcNSWUaFmr5Wso6lFGDeP+U6ypP8y/aSRhrWogkShvK0lAjZNUTy2Juz+nl1+t20K4zkM0i+JdK0oCzx97wvpfEvZ/KBdi6OdlpCj/9NGxx1W7D9m18Z6LNaTZbiaxK+SiroRoEgCr7ToNFWsh/8Z+FPnPdltMfACa+IqMbd9jk0PRIfeItIMkkpYD3nQ6RkMdrENLDzOB8sNvzAmALkelyPLLzWKO0UdzTeQIBsALp8bSgJK8+HlOADrvF/SHX9M3VZTcAN2P6OaGKqtkQzS0mqyb4QlEOy5zt4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39850400004)(396003)(366004)(376002)(451199015)(36756003)(38100700002)(38350700002)(86362001)(54906003)(316002)(110136005)(8676002)(107886003)(6666004)(478600001)(6486002)(26005)(6512007)(6506007)(966005)(52116002)(83380400001)(1076003)(186003)(41300700001)(2906002)(66556008)(66476007)(2616005)(7416002)(5660300002)(4326008)(66946007)(44832011)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PgLD9AEBh0FdYusD3j05k77UwaC1W96v7v0DSC8I8sBclHWqT4yaMHhW0cGF?=
 =?us-ascii?Q?mSVBjAiUFQdXFMrfsHy8rMXQ2kWlt0JNQZcVnY99mWq0fT8dVUo3cnC1Hii5?=
 =?us-ascii?Q?Ro+GsWlti7izDu3S21nquBXLybbuzTCzn+w8lembmJ9HT2xQRFu0Y/zQfcVC?=
 =?us-ascii?Q?R7rHbbfM8QuMpsjroAept3mlrLyOpZUbq4eR76ke0BXdi1kH49MApZdrmDPo?=
 =?us-ascii?Q?oqji/Tg9Vj9DbQDNnlQfHjEXZVJm4z0PG0Vs+NzyJx3B9lmEM3FXm14/Vp6d?=
 =?us-ascii?Q?5/nvXme/UC/v5cWmXxfpRdpB2njqfCMNbKv82HW7VQRpuLS7srkHFtDcukz7?=
 =?us-ascii?Q?KVp5Nq8RQdWZTKzxn6Ql08L6vf3vgml388pN5Z7z6b3pAaQIkdarkwQJ1qwG?=
 =?us-ascii?Q?m/M1D+A31VxTLTy111q9g2AuEKRXL1BXw2Vmy305j6dQifddKFnNd2lqtd2/?=
 =?us-ascii?Q?bBqyneRLML8t9Vjk+h1jvqibMpXcFscnYvLkdMa3a2VvsRmP37ZMjAvUTBht?=
 =?us-ascii?Q?nBktNatzsqI9D+HxwWJt3Jlr/K2HqEJXkZUvdk9qrKqYbGaX8JSFY9/4tJVs?=
 =?us-ascii?Q?GrRmBjUbHtpa9lgozGGEx37zMZBYLZDeMvfVOOl/d6+QExku926lZ3lPbpe+?=
 =?us-ascii?Q?9GSNVP0WQ2Ut1sXjKlPGyo6yrNmZVkedJktj0R3dAgHtWluAl4LChF3+aYDo?=
 =?us-ascii?Q?U9cQMgGcTWAJBFtdbAnrSMYpvPtzMoHsaXtTquE32eGJXrfcGLq8zR4AZWWZ?=
 =?us-ascii?Q?yrKkCkWjRlINPQhwP/VwsMPEqLi15DB8vB6jp9dp1iMqdtjdWtZvYEEQL0za?=
 =?us-ascii?Q?qvr6WWwfaJLy83oj0sgYHZcM4r4gRwnTqiDINS2K1VFBg0F7mbXMN98TFQwQ?=
 =?us-ascii?Q?ft8I/8R8/cQaGWejdMK25iQegKhb0FtWc718lJNawQlFsAtXXq0GwOBBx0C6?=
 =?us-ascii?Q?IYM585mOik4lXtH8JgBjpbL/OvO+bIEjstkJFuMUUPuXcUt0iaEzTJVzx/HZ?=
 =?us-ascii?Q?zQV2FD5Zypv/Ci8hG/O6bc5K2bZ9FWaT5tt7NvlwvvN23M7A31YBij5tWNHx?=
 =?us-ascii?Q?ToKZwqHDySd8qZ0SaoSHtqjqzkiTjky0FGynI5u+Tfo2qmwbSq8ImvTMnNo8?=
 =?us-ascii?Q?GI4Han5TXHyrg/W5QZvVdfyFaBJ2bSiqiHnDLqTzcljLnoxYXoW8O04Zs7qN?=
 =?us-ascii?Q?dT06Rr5VFjQULf7kU/X4NdI46cOEpd1L+cXWtLC/ep/SzRW/v7+SfP4WPSVu?=
 =?us-ascii?Q?Kcp8GFjGAw0IKV0oLRuOFoLMP0s2hr0Nc8QP/RtmnsmAkhkb4GqZR75DBdtO?=
 =?us-ascii?Q?NlukdPwgnfmv70DgGgmpnxHh++NMAjzTRfWh419ibOGwF3dDOUpQYFEVeRdw?=
 =?us-ascii?Q?DgCoBgQsED8joQdsXA8qwW7212e21Qvd6XTbq3MbUXq02zUJ5NRXlpitjxn5?=
 =?us-ascii?Q?qM5MRUaMazDhz/sRcMNqA1codIeeHFeJEMARzc3hcTvbrq7UfwaSWW5J7n5V?=
 =?us-ascii?Q?XaZBm1kWULzTA4XVNGF5h4qSERjZ/iuy4ywfGWyFF84VLkYHFYmmZoC5Q2hC?=
 =?us-ascii?Q?mhm9Ypk4cT98gJCKk6fCtkjirY7kHiW8HVdV/g4q2uBBoVEn9argcf5tCOYN?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32ff6a25-478c-44b5-5e0a-08dad491790f
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 18:17:30.8392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YOFnrXF2c3b09ALDfbPtOfRLQ3sJapKtINv438fwB00isXxW5qZHwyHrI7OB7cRaWJg/JclZp9eUHx8FaWdGIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB7081
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This attempts to address the problems first reported in [1]. Tim has an
Aquantia phy where the firmware is set up to use "5G XFI" (underclocked
10GBASE-R) when rate adapting lower speeds. This results in us
advertising that we support lower speeds and then failing to bring the
link up. To avoid this, determine whether to enable rate adaptation
based on what's programmed by the firmware. This is "the worst choice"
[2], but we can't really do better until we have more insight into
what the firmware is doing. At the very least, we can prevent bad
firmware from causing us to advertise the wrong modes.

Past submissions may be found at [3, 4].

[1] https://lore.kernel.org/netdev/CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com/
[2] https://lore.kernel.org/netdev/20221118171643.vu6uxbnmog4sna65@skbuf/
[3] https://lore.kernel.org/netdev/20221114210740.3332937-1-sean.anderson@seco.com/
[4] https://lore.kernel.org/netdev/20221128195409.100873-1-sean.anderson@seco.com/

Changes in v3:
- Update speed register bits
- Fix incorrect bits for PMA/PMD speed

Changes in v2:
- Move/rename phylink_interface_max_speed
- Rework to just validate things instead of modifying registers

Sean Anderson (3):
  net: phy: Move/rename phylink_interface_max_speed
  net: mdio: Update speed register bits
  phy: aquantia: Determine rate adaptation support from registers

 drivers/net/phy/aquantia_main.c | 160 ++++++++++++++++++++++++++++++--
 drivers/net/phy/phy-core.c      |  70 ++++++++++++++
 drivers/net/phy/phylink.c       |  75 +--------------
 include/linux/phy.h             |   1 +
 include/uapi/linux/mdio.h       |  22 ++++-
 5 files changed, 249 insertions(+), 79 deletions(-)

-- 
2.35.1.1320.gc452695387.dirty

