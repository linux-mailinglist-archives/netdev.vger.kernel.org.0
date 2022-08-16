Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 848E6596062
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 18:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236510AbiHPQhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 12:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbiHPQhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 12:37:19 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150080.outbound.protection.outlook.com [40.107.15.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9071780B51;
        Tue, 16 Aug 2022 09:37:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAK7a+d/SQv7PJniARy8O1kJkCCjd9aXc2wZIeI1vXgC8Q7twv7r05fTtQYMcdSk8g9bw4KhnESvr09uYfUGVbsgbrJJx5qgIxi0me0ATxzaX225K8gVPThmOjlCbiwxKBqzPykaXwAFI8uB8W2Cr8jN3AVaGAFHOSBXd2nLipt4VgJNj0+zvjvktps8WvzmgeErKc0SmkiBOLZZZCDVDtUAMzJJUQmRp5uUiibCEpj80PDZE0qy0pwVKv4bfdxpSsI/tOIaAEOYt/Y3mXljlgileX9X5MmvpD8s/wwtVGXwapI117DNod7lxkmjy4NPZ0pcK1/w/EcM1G6jLn5N4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7eA01Fxk1yEmtTWc14VxM5mRczbXp92HhdZMlJhkfp0=;
 b=jbQBCLvJX84FQcJ5xe3ef3mEweT9sPoK49UbTlqCUdEmd5YuPHPyG7LfUfDZ1H/NLVvVm3vbZUNiRMGG5rkyErqifAGLwROJE0At2zvAysmYjQOl99XXpuiKBOKa7Xg4BTfYIJ+kYN42xZnnZpeuY50AAowmSPXSMxysT0nJVWqHILiKcRFZifX+3WUigQAbW7P0ZXZsoBi5WLEnJZkIBxmiF3c/MbzFofXRJHkQEnNNp2H87me80ezHstBp2084rJKtgFy6YO7sP+xBQujjUEN2Lv90nwstV0KaIN1PP/PjaH4KwxGaMbYmDMB5HBijet23BTrdPgS6lZ39bNILVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eA01Fxk1yEmtTWc14VxM5mRczbXp92HhdZMlJhkfp0=;
 b=yXBcJLNd3vdZHd+5hFJhcONP17zmxsgHkLoXDDGkRxsjo48k/pJgpvpGZRaRf9loHbyWY5ryDkxnKAJdltpEKYDWPjol09l6JCkZV095mOwhEDdsdQDuE3LpxNFnpv9jylal9PUtD+0X9gNXbk0bCsCge0OgSmPLVk0rgHOW0z/0iL5zGVUxKpQ6+aiq2QmcASSywAFUVXcAGz6JE7UYbqOSVJZZ9TlvWj8RoYKOp3tDFwkKbjtZaHhH2Yu+Xuy0i8G8QCNQ7V7a0weZhlQAPMtZQxzF8AUWKO3wLBYNIJpZ31i/y5dvtR3JJJfWESnCkwGo99DsHDQ4nR/Z2DiPDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR0302MB3288.eurprd03.prod.outlook.com (2603:10a6:209:22::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 16:37:14 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Tue, 16 Aug 2022
 16:37:14 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net] net: phy: Warn if phy is attached when removing
Date:   Tue, 16 Aug 2022 12:37:01 -0400
Message-Id: <20220816163701.1578850-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:610:54::28) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e725b9ae-452a-4202-a585-08da7fa59327
X-MS-TrafficTypeDiagnostic: AM6PR0302MB3288:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z6klGkI0AMmq/DAyKvWPOfq4rbRso75UIt4RLi3e2XaG0FV2HhwO8QgckvLW+qP/RfM1e4FE2gswlfQcFBkLkK/M1+a3NpIYfBvwwG37UjU61nXbQIZijZrdOVrumqPxXSZz5Sexe3k7lybCL6vUAz8kcPQnczCCqrMY9uWEqtcLG4bZVqcPZmPEq/GrufHEGZVTBD24WLOZvMTzvU/yPoIsIpJ4PflPnsrp+fZ+l5cpKlmeey3yJW238KxB7CyyCgjQuUcrAN9GXfAa8P1U/kerxnrsoDNc9C6uzwbMZ9iErXtF+v/JjjG0cXRUk5h1DicLAD4LSVet/cC2wRLABq9FRN9Go6XmjvjEz/kuiXvoc7xrZesHBMEsYw8djDgiGc+GJqP5EYREP/zNg4ESSqmNsHBtTshI+1lkmc2ORJKQB7nFjSenvp5MSBmsufdrEBxx3gL8JFU7N13Z4GUx+iiJeBOqjpeSZi4DijoYh3PzTLf4yZ6P0DsD7se1nTsAykPU5YdKRF24rST9JpFKSZtSWhJeNRIINZlNwksRngj97SnTaY0DU41aSrUFrflQX3tMDo4cBJNgb3Jon+tDg+6JrHYj305vwdtwlHjFwyzvQicK7BgVJSivcHCj6/IDgmH3TaGz64oQFB9St2rEHIO/43AHHrc6WMckHYxx8qltRkFYiaagEgnRhLDjNCdF9D80/J9MPl6BIOHLJ3r49ttmF5XT0KY9Eoqbp4DIqM5lSsrYXy/i79xmJ26j73KUtnDAeFQVJgbLObd7d18u8gQGBAjmlDDuYs1ecU+txMA0IsEDBfmbXp9dB7AXr5VmMQRujGCcdpsnktyNOD35Ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(136003)(396003)(346002)(39850400004)(86362001)(186003)(36756003)(107886003)(2616005)(52116002)(83380400001)(6512007)(1076003)(6506007)(6666004)(316002)(54906003)(478600001)(38350700002)(966005)(41300700001)(44832011)(8936002)(66946007)(110136005)(7416002)(8676002)(2906002)(26005)(5660300002)(66476007)(66556008)(38100700002)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FymRWuW5RoJ9jttvNcDnhuzU4JWxXJ13o+ochrgIe6CTjeGo5B1Tf6BIte5J?=
 =?us-ascii?Q?GNt1s37T+40LC+aAm6/jy1WCuwTWmowzgql0X7WsJAuqIe6kVBJvxeL1/lBv?=
 =?us-ascii?Q?/+usCcwjJ8PO2Vm17KmIQzyUoJ9B43GB3F1qRxWJZySTBBKidwaFe1U6J+iB?=
 =?us-ascii?Q?AM8wKrQsvkg5DGfqwJVeoAPULnOAAvAHk2fvSO4XBVYe69AJVvK5EOEWvFMC?=
 =?us-ascii?Q?bjwKlGlK8wrZel+8Lbyqbr6iII6NQKClXu4gm7pM/DbEBfsuNxXLZbiGPb6S?=
 =?us-ascii?Q?Kmqf4GFGuKz2WOZiYELXXXyA+rJcLyFtS1hVY7g17o5EwhHR9sAECwpLSMBL?=
 =?us-ascii?Q?IglN0bW/OYGrEu2PxQcTxzpuTn+PcyHYM1NFZ2/7IV2q2aOCb3+gC8CXfyoL?=
 =?us-ascii?Q?pstJNcrf58gbx6axjXFKrs+FKtesQqOCL9k1/M+HnXS3TNc72iDa22apVks0?=
 =?us-ascii?Q?xQjWIA+cyK9OnQK9M14YTZHu7AieA/sqM0mez6RB3BD1+37LIuB566YDcTnj?=
 =?us-ascii?Q?hXVd27ugj6vQhyuPTzRYFKTkXj4AjVWbBf3vfXxV8N6OIhX4NGdf4MJ98dsv?=
 =?us-ascii?Q?xHFbKq0iAJZPHU+CkKMQsFaxq2Th8tSC58N1OjpCg8yf2N8RHAqPyHNFdBe4?=
 =?us-ascii?Q?gWKcGPnUKXtTH7r47nBx24TrMh3JB5Gq8WzkuRI9REso077W4EtxmTspJntP?=
 =?us-ascii?Q?Rlicno16hIQjP2x3+aXur01Whhd+ZjlognC78WXreX0rJEduB+ksef3zDaoU?=
 =?us-ascii?Q?becULEQyeu2LMsO2Y8h4py8FhABd40/C8FT4ZH8gwTxqXyyVgWu0Rc17VQun?=
 =?us-ascii?Q?GayDs7QFdyquCFiXhwwT0VTvX3gPReMXPC7UrOxCjSCH4e9Q/HJ2rZz14sYZ?=
 =?us-ascii?Q?LNKdOofOmtnc5k1fUzfygf3+D5mBcx1rhYY1+NB5gLm+z2nevB/77RyuSj8L?=
 =?us-ascii?Q?NoJ/T2zhPBpPVZXbhd+++B4+BHK0puRkUlk6tly/eK70Z4rsMb5ak9//a8pV?=
 =?us-ascii?Q?s1q0IrCNqu07DvdSOG0QMPVWjPbhTSt0x2FRD4xzsmT4CpBBQhWo9JUdpIhj?=
 =?us-ascii?Q?F1uZxTGgaiUHmbo01n/wTWd8UrM4Bm0x5/KpQwmHIM13E0yB08vtmynkeXDn?=
 =?us-ascii?Q?atF5L7hw4scb85+/6TnO8we52g1Xq+45FTrI2rtnWi3NYJCuXvtVFAy1n0Q8?=
 =?us-ascii?Q?xWFEd2qzG7Tfknxz/C8+808AfBafqaJOU2Wmmykc4gH6C3eE+MIG4q41mk1R?=
 =?us-ascii?Q?n8PNdLgnUvF1UukRHxRNGaCe2G4p83FMuMSoIGIZMklBNNG0y+pXINIjlIU8?=
 =?us-ascii?Q?U2KadPiUghiuTVrTug3e9YOZd7fDvlsb/g3u2E22kv0t1ZAJO98z1wDXMJag?=
 =?us-ascii?Q?aPPuqkC2hL9vPOiGPKNyML8OeeaaRVzfHqVla55v+IxhSgkcJV0r8knKEDRB?=
 =?us-ascii?Q?VuoVaHR9hCDboJ1Fx8PZkQ7bzzKIcK992ca0V4kMUUtlgLTfFFIcHi8rlRyo?=
 =?us-ascii?Q?gIxhV55aTRypU74bKnTgvv3sBRYgzQAxFTixyCxESc0CPIZVEhQt6wF88rfY?=
 =?us-ascii?Q?g7yztm14ciJVcqatb83lLXJG7siU3EcgMaFYX7UCXGus0IBcc/vpDKHZSIWO?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e725b9ae-452a-4202-a585-08da7fa59327
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 16:37:14.6839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbbpYox9+uu8/VjkAAKlAf9uJoMERocNFvexG35boa8WETwF8sywG4gvLcGlNatwIrmxMXnDTiMxwq7j/pKX1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0302MB3288
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdevs using phylib can be oopsed from userspace in the following
manner:

$ ip link set $iface up
$ echo $(basename $(readlink /sys/class/net/$iface/phydev)) > \
      /sys/class/net/$iface/phydev/driver/unbind
$ ip link set $iface down

However, the traceback provided is a bit too late, since it does not
capture the root of the problem (unbinding the driver). It's also
possible that the memory has been reallocated if sufficient time passes
between when the phy is detached and when the netdev touches the phy
(which could result in silent memory corruption). Add a warning at the
source of the problem. A future patch could make this more robust by
calling dev_close.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This is a result of discussion around my attempt to make PCS devices
proper devices [1]. Russell pointed out [2] that someone could unbind
the PCS at any time. However, the same issue applies to ethernet phys,
as well as serdes phys. Both of these can be unbound at any time, yet
no precautions are taken to avoid dereferencing a stale pointer.

As I discussed [3], we have (in general) four ways to approach this

- Just warn and accept that we are going to oops later on
- Create devlinks between the consumer/supplier
- Create a composite device composed of the consumer and its suppliers
- Add a callback (such as dev_close) and call it when the consumer goes
  away

It is (of course) also possible to rewrite phylib so that devices are
not used (preventing the phy from being unbound). However, I suspect
that this is quite undesirable.

This patch implements the first option, which, while fixing nothing, at
least provides some better debug information.

[1] https://lore.kernel.org/netdev/20220711160519.741990-1-sean.anderson@seco.com/
[2] https://lore.kernel.org/netdev/YsyPGMOiIGktUlqD@shell.armlinux.org.uk/
[3] https://lore.kernel.org/netdev/9747f8ef-66b3-0870-cbc0-c1783896b30d@seco.com/

 drivers/net/phy/phy_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 0c6efd792690..d75ca97f74d4 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3119,6 +3119,8 @@ static int phy_remove(struct device *dev)
 
 	cancel_delayed_work_sync(&phydev->state_queue);
 
+	WARN_ON(phydev->attached_dev);
+
 	mutex_lock(&phydev->lock);
 	phydev->state = PHY_DOWN;
 	mutex_unlock(&phydev->lock);
-- 
2.35.1.1320.gc452695387.dirty

