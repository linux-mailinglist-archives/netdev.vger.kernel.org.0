Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B987C59B763
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 04:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiHVB7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 21:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbiHVB7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 21:59:47 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2084.outbound.protection.outlook.com [40.107.22.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C608F21815;
        Sun, 21 Aug 2022 18:59:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUBQjJvoOvHmb83UZ1nhJXiImyeRTMKoiIRisNISC3E1oNKMdcowoz4fmahPm5Dk0nek3eTJ8Wh65Uw54FMFS4OzX7f2A/t0j5E0FMXDAtKv/ZgJOYpo1fR41u2V7HlzkjyHUpUZMAkTTV/oWvfK9yJ8lyMmNmxytGwB2C0tXYOIFaj+WcAMchqY/1+0x0ji9JNhvMIUXqY56YkZpxBgsMkxkVESNaM+MATFjuyIoXuVogTBuyXhik2+hWZvd27Ed3s0NuybBeqwNLy4dhAouGXZb28Qmu2LbIFVKa0+BsWJS0mSVAPvh8pwSpeXn4SU5C77Bhg2SkAStV6190/HRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CULa9flY15bsPQVIiuBuA6ls7ndbAXl9Ec3WwDk5sj4=;
 b=ofiFHj7CKFrl7B3+ZwzE3/qPYwdgSmBpMUWkYyqHpE3+pmrKTeFRAXbAQYup90QFWC03MAYz6b4HrBQwCUl3Zq0KsSsse+vCIh6BqDp3DxCICnwV4g0u1Ztp85Sy6KPLoAlZRc7o3kyJLd0GCGXP8dshMtScC4mh8528gokYE5haJZV/kMIqT+sS4h+7o25qeNcAZg36+gDv//GaoYwqvawfas9wb5d3GP4Vl8XnxSY0Voc/zDgR05IcCq2MuYJh/sASMrCWQ5SjpQxGqvxy6scynAsT6eUr2PKCbeOXimXqvi7NQ+lt/gDbyomaPUCWFAKExWQQ0WLf9NMA1qAlcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CULa9flY15bsPQVIiuBuA6ls7ndbAXl9Ec3WwDk5sj4=;
 b=ZcTw2aN1bsvuzlvdhIvlKkA5GU2jb+wV1e9HewknBUIRej2PfhJRdoMtG4L60RS7ChPpkQGxbOFfsUfR+YAmJCkDKifHdnmy7p0XvG//mbIB++WNszmKhijj/tNPpWW8xkqZ/VnT5rUh4sVVt1/Zcp58ONJ/AsZ6QS8QNkielCs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM6PR0402MB3335.eurprd04.prod.outlook.com (2603:10a6:209:a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 22 Aug
 2022 01:59:43 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%9]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 01:59:43 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 0/2] add interface mode select and RMII
Date:   Mon, 22 Aug 2022 09:59:47 +0800
Message-Id: <20220822015949.1569969-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0029.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::16)
 To DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ce43109-183e-440e-b239-08da83e1fb4a
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R0sw44voXIqKf5J+WON5tlH/YVl7Vz3jzzfjJ8+/Twn95TGuLnsBOU5sS6OjfcDv6MAKbWPY4WxzYAIEaHoEX1wRHUYJfl8IXfdSb+Eow9cLxTpj+KrMBm/Wkg2vCUyt8IlGU8Z4yJGEugCP4qqIdmbJuAPEo8IIdlurE7iwO4XFwNVYfJKQ1gu+OVZ93YCxg1nIpsnO8iZ0sy00mr3wCuX89/nTqKMfMTq/4HYPP/q4wfwSfaEgJlNO8X9LuwsHwlPdtPGRXu0941OVVmzIyIY4mUWCOO0R6S5d1C7ozqKX4xci6E+rkgeuJSrg4kkbCjNUU+hP2ZmJ9ZmuItgXVaJ+3IxfkRr98Q6flJv4qqRrF7fdZkGlF7Zp3Pb6B8XHqY/adiYzWUY8FCjC2oImEph6KB+39cm39ka6WvJW1KdMdAd4Jnie4/ZmhkEmZ//XPUJJSf2q3zw9IbchFYsGXZiHmA5ALWF+j8zYpyHwunVSKJjCH0xiBQrah4S98UNARe95QNgDYu9RInlimtMe1xu2olU7MQ1ZNY//D/4o3Sbm6QZKjYe0f+PKJwy54kWPkUyQfKdp6N1ey3TGOV+X/glGuA/w4a/YIqarFPG5DmxRGpdAOOD0ONtpqQ/cN2637SPWPMwgB6fZJDtSjFzh1jmAoazkzSNaZxk8s+dfd2nJlAY4+0665acYXZxHgpwUScqWqCzr2GC7Igb6Bo826CGdtLMdrHXFamVjwxlHCh+Na1MsKWlgZjZro8ONGEx8/FTgcTBooMQ3vjzwMvLpOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(66476007)(66946007)(38350700002)(4326008)(86362001)(8676002)(4744005)(66556008)(921005)(8936002)(36756003)(38100700002)(6512007)(6506007)(6486002)(1076003)(52116002)(316002)(478600001)(2616005)(2906002)(83380400001)(41300700001)(5660300002)(9686003)(26005)(7416002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZQR4uqErITNyJMb1sNbgnw0JWJ7ULgCD4WvaySoIr78k2EuovpcJeixAoNNu?=
 =?us-ascii?Q?XrT8wFQIHcFtxcUZo213i//NBsA8Q6QlUxAxRW98lhOFnEkAqlIhlD7IbD9O?=
 =?us-ascii?Q?e+G7ZRh9YyUJegwKM9FidKDXgNeLZQ3u/5aVxyQfDFqrocBusPEIebxMc3ZX?=
 =?us-ascii?Q?Y9+cxGTzWHy0/uPYXQ/QzU52aQjNLBuJVNoc3Cevp3lwKly+l7k1YbXkFSYs?=
 =?us-ascii?Q?pp3TKXWFC5FpmCmsr4yLQjdGN/Z6sgPM96lOWDmeU1iJo2+3Ynx0tXe1P9u5?=
 =?us-ascii?Q?d/WillQjqKf9FitzIGhIqI65Zcoe6gF8ecH8Ygbp9uWH0Sp8nFUhO5R0v6DP?=
 =?us-ascii?Q?moOwOciPNZHy+9+yq+Rq325VKWkWrOVp/BQM2+JGHcTsUnCuCiOZz0+q56MY?=
 =?us-ascii?Q?attevwVkkOXUPM6Hmgmow9bhFoD9BU2maSp+MVLsF8oiVuuULaxePxW+2oKa?=
 =?us-ascii?Q?sZYC7i7sxk0tUJoS1UcaV59wiwPqvsbz+6ukkEVmx2/I4Ou/UFABWvlDUMkG?=
 =?us-ascii?Q?Mzf8RRbs1SxS3eWT0WNJeX78UFrZ5oxHl+xk8I4OoqKi0uS4uPz6sDLXuStj?=
 =?us-ascii?Q?T5OBdbWk01sl70nxcMhvfO0yylQOItVudvdPKwlsHAdQbKkO7gKBnuNsr50Y?=
 =?us-ascii?Q?ojeoHBSuQYCA6F8ouOK6xsdK/u6SHllIWoM1Ncnu9vFUPa/hGQ46DHXBLuZi?=
 =?us-ascii?Q?+oL5NfBYqgUz1pJYd1FeBwTcbvMfnuUj5vBRP77rY5AyIf/rtHOak43KYZr7?=
 =?us-ascii?Q?/myW4uXmF022Yx3Ry7fYfDkYSM5uq8BaIHQUeiQvjOxjCJ15b4UF5s85qAoQ?=
 =?us-ascii?Q?/xqwhrOBMqw1otaeYp/3cKFVac8iShGi/gDTGPbXypyLDinmK+Zl4yjQo/Y2?=
 =?us-ascii?Q?AYilB5kZSgM29g5h8s6zbnxH4e2LCnZvR74e29WQFlPbg0NqUce2zZILLTeP?=
 =?us-ascii?Q?hnInQvvKhrwj0lTC47dO2xvKIcOiZR7YfNbjXjHweTN0BMXEJwOociIMtDQM?=
 =?us-ascii?Q?ug4szf6xzkt4S2siy0w9UDr0czkDsy0kMmeJASSpQWzoK6sK5lPtoQf+8qbp?=
 =?us-ascii?Q?74mqa8tbwOAc/e8i+jxfWxpMvOUaGH4e1gHVe6xEM/TI2K7ppQ/t88cPcm/B?=
 =?us-ascii?Q?XuPOhugC2s0vxdKGgJju2ifmkpk3DDp1wNACv25CVlOCA1yKPcEGUlsu/xZG?=
 =?us-ascii?Q?TeTiPU8egst9KjyTVpRq3uvOsNj5rv6v8QNu5hd/9V68Pam/XB4nyEZm6k8A?=
 =?us-ascii?Q?j42ivayzakcGWzb0s33G9d0+dvxPX8Bd6HG+Z7UV377bMrYJh/D9SyonNbls?=
 =?us-ascii?Q?K5u5Iw/9PCF7lYrLgb8lMNlxqRrYTRDmeILl4Ai82Kgczed2jGMWjKK/Zxjk?=
 =?us-ascii?Q?24kRVWwPZmmzaY2U5CNlQHljgrdw+L2JmV8c92CsugULW592X0H+0fC3WZe9?=
 =?us-ascii?Q?qrP0XWQPp9qK0EMCuPNcAdnp+XEhbRfUeG36LTEUk535sWVLss7T76e9djEV?=
 =?us-ascii?Q?FmXSDvGbLNXP9zXqrTpWUm6SnHXFWf0FG1B1+f8CipL5xPppTH1n+uZt81AN?=
 =?us-ascii?Q?bpwNq5hhnNQmHYXUh1p/X2JMep15VCMs9Ox3E7Vq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce43109-183e-440e-b239-08da83e1fb4a
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 01:59:43.6484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJnmKzTwbPctp5pup80qvA3GETZR2Nt1/JAL23JCSE8fNe8kO5jvS1WBW8bEr6LO/+uf3vlt8j7qUB+n09ny1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3335
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

The patches add the below feature support for both TJA1100 and
TJA1101 PHYs cards:
- Add MII and RMII mode support.
- Add REF_CLK input/output support for RMII mode.

Wei Fang (2):
  dt-bindings: net: tja11xx: add nxp,refclk_in property
  net: phy: tja11xx: add interface mode and RMII REF_CLK support

 .../devicetree/bindings/net/nxp,tja11xx.yaml  | 17 ++++
 drivers/net/phy/nxp-tja11xx.c                 | 83 +++++++++++++++++--
 2 files changed, 95 insertions(+), 5 deletions(-)

-- 
2.25.1

