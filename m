Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4371D41285F
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 23:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhITVqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 17:46:14 -0400
Received: from mail-eopbgr150080.outbound.protection.outlook.com ([40.107.15.80]:61831
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240143AbhITVoM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 17:44:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8VDwP4lal5bN9vvOR92cqgqW91d5MNrl1QietVQ0mt8WdZIX7Y7mFvVu0d2jwVYq0iyPsIq/aTlKaMdyB2N0r3cCALVkeEcHioNiMLsTlT8CaWNLDXXPSDU8PeD4ew6dqrRqLhNMR99fpnxkUISVo2bybgncxweePi8CtP6al0FlfYdOccCJZalcQVAXFc4m12sWnVMS6YOuqChfkcxYFqBxikD0zMGSlf2jGDa629e3i9zvRp5qUjCWpmT7VWdYkxRASOdqg4/CKgmrNHyARHj+3mmM831koQ67MUa+FqD6wKIlDIV6QdDAvNav7YnD4uuPf12ELDWkZ6CV+8+gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5rgNvva/MKeQs/T5q40/IqFG/xnDq4OuF/YrJDoWqhs=;
 b=cAnzZb2FQ/pUAms4Wwuc7VnE62TiRciRbEBdNc5mixkL1INL4ndA2EiIuXB7B3mqUY7WKm2+H95RqNouhAHt699OtRmNSTNHqoA+43NCrSskMRQiDzlbgeInpYaU1GSYx93DFYnM0uyM2Tn/SO0tNel+nCu5BEdBTukWx6gJKsChDwR5efGPOtrDW3IHL33RDMgEV9eeXLtnuN6kLkKG9vPpbKmoQWVII0N99/wvNuWHJYBG4RakUmAkSvki8PzQEpdifcOGmixHDapJn/k1wS2rxCuC39r/Vko26TVqKcFloqdv3M2+DPg3oN+CVLsxyEOCsTWjrVLca0R4GYBOcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rgNvva/MKeQs/T5q40/IqFG/xnDq4OuF/YrJDoWqhs=;
 b=WFX79GwxlHVlDHZivE22QUWNGyJM355i01ZoEqr9i6I599Tg/zqhs4d6mfql4Io1LMvg1ILc7uJ2rzR2XkpDwXpYagVHNjNgPN6mY6iwgTjzvvx4Vq9vNVtyXu/4xqpleOKjshzqTvJEDY04AErWw9vDDrv4kCWUsdcyNhWOucg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3198.eurprd04.prod.outlook.com (2603:10a6:802:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 21:42:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 21:42:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH net 0/2] Fix mdiobus users with devres
Date:   Tue, 21 Sep 2021 00:42:07 +0300
Message-Id: <20210920214209.1733768-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0092.eurprd04.prod.outlook.com
 (2603:10a6:208:be::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM0PR04CA0092.eurprd04.prod.outlook.com (2603:10a6:208:be::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Mon, 20 Sep 2021 21:42:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a6495ca-6f64-4246-acd4-08d97c7f9186
X-MS-TrafficTypeDiagnostic: VI1PR04MB3198:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3198B437DC37D502F68BB904E0A09@VI1PR04MB3198.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yaN5KlOrrTfB/2ARcudtkk+CdWm1u2kmyYfemccVYyt4IkYjHWZRBs7MAu/6+xjDph0p9VFEZOkMjhGvYB5SSfKPje0hXJcnfNCoqEUK66P1rtv/5cf5xF64hr4BCb4zCmfSmf3SPyPpsaPhAQEd19ZcMjqTT5YL9u7eIGyCwoBuHSe3OkL5Kx8QF5x9tntvYr6kESr49dAsNKMTBUbAP2CEnNZHrp+vhJ8qNF32Ore6Oitmq4lmPgPq16HJTiG2go2PN8KyiGYwABAhwiqNi/72uMMVGn7op6UdoTwzH2EiPM9XLzKthP0MhNEvpIOqltsoKkn9GvLWNAAsW052t5FE2M1WakSASzZl6kr4DzuUSlzwmgvIHylk4v0yxXyybPjCnvM5e603ByhlB6OvMBAAQ9E/TkloyMiSuJMH4IlTaZrIHjjCCDRbM8vkCW8eiZON3zT+cUc97HWccdPw3MWDwBR/dd/7h9UUSCxQj+DrHjxxyasxSJOXc/1VK/Ki1E07GN7DAAKupxfzoGwWVkHEYN8D61E0BCvu8do4Y3LorbDnUKtbSHg9pUwbEp+I8xxPg2qyunbTRmz3Fn7uOKjrxyS1NDpDGV0MuTLMh5f/J6bs7+wO4DDZ0ruugJSX+28j6iROZxXGPfbAzf9o7LoPNIUXt/f27/ndK64wL8Jwkv5wzqbZncqZxhuOjoxmlZVTR0GGeyD6WlfsDqo//g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(52116002)(38100700002)(38350700002)(4326008)(1076003)(44832011)(7416002)(83380400001)(66946007)(26005)(6486002)(8936002)(2616005)(8676002)(6512007)(6916009)(956004)(2906002)(478600001)(66476007)(66556008)(316002)(54906003)(36756003)(186003)(86362001)(6506007)(5660300002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djVHRUI0YmdnSmJ6U1lsMW91NlptTThyZ3FSUTVGY2dMa0FqQVF0WS8xVW1p?=
 =?utf-8?B?TWdKajhWZ0JkbTdtYkcwZmhoSWZETVVPMFNRZXQ2VERxd0dqdVN4dEpDQ0hx?=
 =?utf-8?B?ZlBQbHlUT3VMU0VGTG9ZUUdWT0wxNDlnaUVEMExjeXdWSmxuZDlwTDdrSHlw?=
 =?utf-8?B?TUx1UnBjdEEwaThuU1ZkeUlYWnpqRktoQm5OQmV6azRzNnVaNGY3NHZqak5D?=
 =?utf-8?B?UFJHM01nSnhORlgwWlNDSEFWOHIrT0hDU1FGRDF3NHlnRG0xK2N5elJnREx6?=
 =?utf-8?B?Mmw0ZDl1cG93VXZvUXRJbHVxajd5ZDZVdnI0WHFMcWJEQUpGVnI3S25WOGw4?=
 =?utf-8?B?M3FrNWt5TUFBeEhYbVFsWXF4OGNvV1ZjcnlEdlR6UFFlK296UXpMZkRpclFl?=
 =?utf-8?B?bW9TUUJGNk4vZ242K2ZpbEpyTUNBNHZvZ0xoRXJJNEE0Y1FkVHQyQU9tRGdz?=
 =?utf-8?B?UDV0UmFuZUdDWG55K0lPM0dJNVI2NG10ZkZHazJvNjVlZS85RDlXZXJHYUR6?=
 =?utf-8?B?WEdmUURoalR5elh6R0V6c0dQZTFSek9MZnVRQWhIZmJEYlhhOW9kS3UvQkpE?=
 =?utf-8?B?UnRTUnZkWEpPT1UzdVVVRUFkN2xJeVkxSGc2U1hsS2l3emZVOVhFSXZXcXBE?=
 =?utf-8?B?aWorWU4zaE01MjErMGxPZWM1TGFGd3YybDlYZWtRQmhHT29tOFBoVzZaYXNu?=
 =?utf-8?B?dFpOalVjeDdmeVB6UjZDYWtJMTd5OVZDMWlRNFRKaVNKYitkUUpzRzArVkEx?=
 =?utf-8?B?QmVOdHNXY0M0RytCSHorc0NnY1VRc3R1blNmd0l4eUROb0tKMnpOQlNpL1do?=
 =?utf-8?B?THpZWS9aekRlOEhsTWIwVFJrYlBPUDlNYS9VcTVOQlpTRlFuUW01VlZvWVJx?=
 =?utf-8?B?VWV6L3kydXdoMmYzTGl1eiszVU9oZDlZa0dFdEk5SWNhakFxdHZ6bmtSQVAw?=
 =?utf-8?B?cWxVMTcyVnIrVlpsajFsS2RmckpocUpRNTZOdUM2SE9aOHJDRUFvMnYvdCtJ?=
 =?utf-8?B?RGZIcEdTTWx5U2ZTemdVSis4b1lIaXN4ZEorWmFTRTVkRXVNbWorbjduTERW?=
 =?utf-8?B?bXVUZEpMcHRrZG83YWdtRlF5N2F4WWpvYlBMN0RVdkR0QVVOd3Q4QzFGakhl?=
 =?utf-8?B?UXQvQ1ZaV1VlWWM5ZzNjWnlpZm40MEwrbGYreU1kaVJkQk0vTFhsUjlybFlj?=
 =?utf-8?B?bUJZOG1vb1N3OXRlWVJ0c0Z3ZVRHbHh6WFIvRVBOUkdGZDZtazZ6WFVLbnFZ?=
 =?utf-8?B?WlpDaE1XT3FnZkF5Y3VRNkxLb25DQXpuUzdyOFJTV2pPcW5EeHN1cDIzMSt0?=
 =?utf-8?B?QWdiOVNPQzlUYk9DbXU1TURaT2I3aWJ5b2xLck9UNjVzV0ZEbmI3ZFNrQ3Fz?=
 =?utf-8?B?TFZnYnQvUFhudHhGcVBkaWoxaEN1RnNMZlkvWHo5SGJNM0RKVkR5UmtyakJE?=
 =?utf-8?B?UlF0Q05wZ0RUOS9LYkZrRGRhZ3NBTW5zelJ4L0M3eVhUZG9xWWVMdHpDTUND?=
 =?utf-8?B?b2FYNWdLcEhTbi9QOGNFM2dJbVlBRmFtc2s0NXd2cFdXUXhTRUxiRUVDdEll?=
 =?utf-8?B?bEY5aGpNMTk2SUNtR1FKMnl1QnRyc1lzd1h5V3JtV1hMdkJBMTdqZjJneGRr?=
 =?utf-8?B?U3dLc2kraVV1RmFpbjVSTUZnT3BsRGQyU0xmR1hvRjZoRXdlc0VuZmFaNVZU?=
 =?utf-8?B?N1NEZldjb1RyTnN0S3Z4a1FmRElSRUVFMis4WFM5MnN5UERxSEFlR2VIMWg5?=
 =?utf-8?Q?E10FHiN9nPRpjvL5Gz6x64UPrU4ngP4cNivhER1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a6495ca-6f64-4246-acd4-08d97c7f9186
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2021 21:42:39.5707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q2ISgDibuRUFWa08UjJiu1lGjFgGnIeK0SlwpcAY2HfF/xe4qOZ7cPbsGduML7nTAXCyARO49aozlA92rgQzpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3198
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ac3a68d56651 ("net: phy: don't abuse devres in
devm_mdiobus_register()") by Bartosz Golaszewski has introduced two
classes of potential bugs by making the devres callback of
devm_mdiobus_alloc stop calling mdiobus_unregister.

The exact buggy circumstances are presented in the individual commit
messages. I have searched the tree for other occurrences, but at the
moment:

- for issue (a) I have no concrete proof that other buses except SPI and
  I2C suffer from it, and the only SPI or I2C device drivers that call
  of_mdiobus_alloc are the DSA drivers that leave a NULL
  ds->slave_mii_bus and a non-NULL ds->ops->phy_read, aka ksz9477,
  ksz8795, lan9303_i2c, vsc73xx-spi.

- for issue (b), all drivers which call of_mdiobus_alloc either use
  of_mdiobus_register too, or call mdiobus_unregister sometime within
  the ->remove path.

Although at this point I've seen enough strangeness caused by this
"device_del during ->shutdown" that I'm just going to copy the SPI and
I2C subsystem maintainers to this patch series, to get their feedback
whether they've had reports about things like this before. I don't think
other buses behave in this way, it forces SPI and I2C devices to have to
protect themselves from a really strange set of issues.

Vladimir Oltean (2):
  net: dsa: don't allocate the slave_mii_bus using devres
  net: dsa: realtek: register the MDIO bus under devres

 drivers/net/dsa/realtek-smi-core.c |  2 +-
 net/dsa/dsa2.c                     | 12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
2.25.1

