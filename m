Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001A1569E64
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 11:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbiGGJPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 05:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiGGJPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 05:15:16 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7E02B277;
        Thu,  7 Jul 2022 02:15:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/xV++uW1XHYgTF2dii53ZBwrJHz7wDFZaMhOfJyhU776OFpA18EkyyilHfue4YI0lCHL3atIPPrR3ChMYOkVrv2O+ZaOIBrhCL6IrnJg2bEj3T3IAUr4wg4Aw8St5Kxs9PJLB2D/d3jBkM/9bjwkoS+vEpdgKonRu3ORv+nX/i7TQl1zf8G82d94In1NJQQvDxY8w8RQb/jxwWm7EdfW8lC8D2dpjNBKEhIaXutwh8RWdZKeDHLynH0/uxOYfpDS3QyfvARp4/BNbyuKSrthIsf0ExMYvHx5QuQmH3RRWfrlIbF6LbIUdrG0ls9cNVuuntRwto6FQOz/sgi1upoVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OhAzK1lhjBnvkfN91Iyl9DTVWXxz4olCaxcYx4WJRcA=;
 b=Eak51CRkluXR73TjuRIUYj7pzzPpO+CiBgr2zX22Q7Aimj+Z6LHujPcIWfhpuAU4UJc02h9+MOcyi2o++DeWPWmY+r9TuUS4oLcyXZuhztBFg08OlzG+YdQbXKV711kBWkpjlH+30PiTY9qllVE+Fo2tUMYQYP+9Vp5ykIpsg0dXyGf9j6E118908Li1OpfHCeteV4/2tkDmOVmKvKMbHNG7GXbi9sNYFG+j6S2mUmV0Xvz+41yaVoRGDUUT8QbltWiCXuQAFsA1y6owSe1ZRtqA6Q1y5ytGVVwa28AxSgbWuoUR2sZZpgC/2HCCF/L69rK34Jz4NKU+jc8BBo1CVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhAzK1lhjBnvkfN91Iyl9DTVWXxz4olCaxcYx4WJRcA=;
 b=irVFx9XLVFcb/wtb4kHtXYmh5mghgRtUjjAZDFPuqrym3vhuR9yJqvYmZ1E2rbVUWMBrzn3/9ZcM2puZWgVLv+XsiN1dr3tU+YBk0P0CHhcCaCsaGLBHsw8VTc7fThF3buDVDZbH+PqUe5EEsfNJ4lvnRntAp5tb4ToW6eM2adc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by HE1PR0402MB3595.eurprd04.prod.outlook.com (2603:10a6:7:8e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Thu, 7 Jul
 2022 09:15:11 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%5]) with mapi id 15.20.5373.018; Thu, 7 Jul 2022
 09:15:11 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     robh+dt@kernel.org, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 4/4] arch: arm64: dts: marvell: rename the sfp GPIO properties
Date:   Thu,  7 Jul 2022 12:14:37 +0300
Message-Id: <20220707091437.446458-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220707091437.446458-1-ioana.ciornei@nxp.com>
References: <20220707091437.446458-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0125.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::30) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 400b916c-2d85-4696-bb59-08da5ff9319d
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3595:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7hCeyuN3RQUTwHMBP44/vtTdNdJp506SessFiK3slpSAuH4qClKmzjsiik2BDZXFdC/k/t/nrp9EIWOYxdbAja7C5Uw9NYUPRTY9PB+ztJywis3i75+BBj55x/sAa9E3nWMmvgaYqy5eZFFjrNMOwZzotmDDRxdRt5nLhDvccnncAt3nzmFIT7T68bIo1fCl85b9fPfjt1/YLqApkLM8vk3SFB7uRzED863PP+60oN7lF9YWFQIb6iIXHo5VSuZV0OGmnOZ3tisPFI6owU+pGUchlJ7pH1TL6ngtfU+MV4vnGtX7jJsAuFvbYNXwq1tGFyQl4Xq8Vwim+Rk8Nj3np0n/vSREezzWpe1yOaGJVRfk1IO8Fb9gp+/ev1rSOsBwXeacIc8zFtW0YraF10OL9e2Za+fiG82N7fDHMKHIlfJlETGHIXBrECU+RujzSt7it917NLgxgRy2PHOVYT+tFAID6eSEmNKqi0WqSsNfMCaN4ybeIKedXYMMoJIO4rrDi8Y/6MdxO7UeIjRj9OmQOoQZOdfcqP4Jf/ZgdYIccnJc9vjwfrG9DXb75UPUNbfVkTk5U9OvdzhnSgvDxi1FZ0IalEWS8pkwl/pfG+6UrOs50t6V7rfYbzvFMXdk/9SC+9jNEPlHdydf7i+CL44p6tOVwXgda7DhLcXwllBtIkVPpuIxjQx1FAubS/9Mq1cnX7U0iORKRk1c4rC7t7FZ0qP+9TN9p6XmA/Bx9K4r2ENl6+7RyljOlim/f7L5iwvV6uyfvthWiZeW903+7lUdGQ5coIiWf/IBDWWIy0WMjgQ6NUbBw82fNaLRYGTEVzmY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(316002)(83380400001)(186003)(26005)(36756003)(6512007)(66556008)(66476007)(30864003)(6506007)(5660300002)(86362001)(2906002)(8676002)(4326008)(66946007)(1076003)(38350700002)(38100700002)(478600001)(6666004)(6486002)(44832011)(41300700001)(2616005)(52116002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GX8Jhn6orzlmN7oXlaEukaBgf+k9ddeaflonmvBzy1Inv2MLQy4Mnvm5N1rE?=
 =?us-ascii?Q?Q21nLQkJ4HPxzPAy6LgRJAVan5KuRiTgfRvPYPuOAw7GXB/JahBDuicTkWu+?=
 =?us-ascii?Q?D/8B6yhcm2eI7aClILEB6HqVsAqwQkRe8VjjRYjQL1qLEAIBZt5wN/nVg2dP?=
 =?us-ascii?Q?A8XViUPDjeS/Si67WcOxA4nANEkAvCgpScuLcMqBj0IUy/Lvfm47SopQk5eI?=
 =?us-ascii?Q?3Rx5gHfhEryKj2t0y1TrZ2KUPJ223Rw6klybhOpfiGQboHTHXrsCKHMuhbhp?=
 =?us-ascii?Q?Ilum5Tdngx9BLWz/H4m6pZZ5T6r13KwFkjxpDY/DfEp3T0wOVoQa0yXw7BRK?=
 =?us-ascii?Q?PdnLFzO1S2PyYgS3qkvzjA3Wt/ex8scw/R7oX1IEG4DBMxDbWLf/7W6HJHSN?=
 =?us-ascii?Q?po/rxbypf5GsnW/2oKSToQTeQnB4+0e+gb1J/n+hy574FeLZlTMFv6kH8D/E?=
 =?us-ascii?Q?gYLrA2UDIsYMmLyO4qJTt2J7gkyNu4PX8GS+uNOK+wOCZuj6CJrB74QZSOsJ?=
 =?us-ascii?Q?FrKEVDwgxHXIYWfbylUAyfr9x6YAjwVQOjHinMybvT4nvdJevEr+NPV0M0n1?=
 =?us-ascii?Q?0j04WmkPbXaJdAbjs3z987S+0oH8M8Xg9FyxjHN7otFbLOmSbMGJsbpMvUZ4?=
 =?us-ascii?Q?0aBvvvzpr5S4gB57CZT/GbcMtfMpCFGzoYwwU5gkqaaI3qgm9MLlv1B7vo1P?=
 =?us-ascii?Q?OLGziyaA4mhklxc4RwZ+gv/0UY8x0GnqL6h2rfQF68kG5EfBwQk5ApHAEZol?=
 =?us-ascii?Q?R6STccr1ZujR/eJkSrkV5w4e0e0mGl/fVNdwJ2uJIpfN50pP8t2HgsWl4f6C?=
 =?us-ascii?Q?YPabX9U7EtkJdm9WV3AK5NUq+BusVZx9zaw+/D89Hrb8ecDTZz37eN03JKMC?=
 =?us-ascii?Q?vpFbZv+1B5ezcRmyQKGkbAVGaEw/UrtQM1ww85CqFIY2EFloraXJavhSt+Bb?=
 =?us-ascii?Q?J0jyJ9JFAvmdsLlLZnYZZ1KQjoESR8wGvigXYYQfi5uEjez82sv4IRHoX3AV?=
 =?us-ascii?Q?EDLvVPstifb/my2CHBbdyDWdnqPsjtamaWZirKcIDxqqjAgIyI2kH10LSaYj?=
 =?us-ascii?Q?I4XgRiH1lsdDlwUVNoeKQN3RdUsCpfit2JZmK53AFCA61300dikiyvMsYN3S?=
 =?us-ascii?Q?2nxXyig/J0aYv/OvQzg1cqcHv+ZTmCtQDvHgI2y2SXnc8G3kUmotrFAldFS8?=
 =?us-ascii?Q?k/AAbuT99X+2ueyb6c4c78c5JbN7SOtx+eAQ7h+83w2aS2ToOmvvT34ET3DA?=
 =?us-ascii?Q?kG7N5GAOC4ToxWuycpm34YlAQETeMezuFV5mN5AKqXMfHcObrkwX+remE7IC?=
 =?us-ascii?Q?md9b1w19+tUqbpwF48X+b+9zHvAc3+JzNEm8svDGoXnH8LBIEf/tJKFHKibS?=
 =?us-ascii?Q?wICdDM/pm4+RXsfkhguYfwkXfzyYSglfrVrlHPES+R+n2dZnHHeUEsD1m9pG?=
 =?us-ascii?Q?A3ulXWl1ByoTg+iQ9R+jsLJHEHIfFNqbu/qnlJDsrXn+x3lnDBk6pY22jkxY?=
 =?us-ascii?Q?O9i4JouDafDlx38P4LZgiZSx33lPyqGTuU8QL5e/5+IWbU/hvbrocuwMrJ/d?=
 =?us-ascii?Q?83MKvvXVZJUTaGOtg91OCJmvW0z3U5blJcwBokCu?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 400b916c-2d85-4696-bb59-08da5ff9319d
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 09:15:11.3104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5CS47sjSdFll9iokbJ2HIWj3tnCgRv1pK19xJ5mqtr99H4XYpLAwmqNgKcdovbhoiNoaUfE741n5PdAS/zVaIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3595
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the GPIO related sfp properties to include the preffered -gpios
suffix. Also, with this change the dtb_check will no longer complain
when trying to verify the DTS against the sff,sfp.yaml binding.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - new patch
Changes in v3:
 - none

 .../dts/marvell/armada-3720-turris-mox.dts    | 10 ++++----
 .../boot/dts/marvell/armada-3720-uDPU.dts     | 16 ++++++-------
 .../boot/dts/marvell/armada-7040-mochabin.dts | 16 ++++++-------
 .../marvell/armada-8040-clearfog-gt-8k.dts    |  4 ++--
 .../boot/dts/marvell/armada-8040-mcbin.dtsi   | 24 +++++++++----------
 .../dts/marvell/armada-8040-puzzle-m801.dts   | 16 ++++++-------
 arch/arm64/boot/dts/marvell/cn9130-crb.dtsi   |  6 ++---
 arch/arm64/boot/dts/marvell/cn9130-db.dtsi    |  8 +++----
 arch/arm64/boot/dts/marvell/cn9131-db.dtsi    |  8 +++----
 arch/arm64/boot/dts/marvell/cn9132-db.dtsi    |  8 +++----
 10 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index caf9c8529fca..cbf75ddd6857 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -100,11 +100,11 @@ sdhci1_pwrseq: sdhci1-pwrseq {
 	sfp: sfp {
 		compatible = "sff,sfp";
 		i2c-bus = <&i2c0>;
-		los-gpio = <&moxtet_sfp 0 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&moxtet_sfp 1 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&moxtet_sfp 2 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&moxtet_sfp 4 GPIO_ACTIVE_HIGH>;
-		rate-select0-gpio = <&moxtet_sfp 5 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&moxtet_sfp 0 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&moxtet_sfp 1 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&moxtet_sfp 2 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&moxtet_sfp 4 GPIO_ACTIVE_HIGH>;
+		rate-select0-gpios = <&moxtet_sfp 5 GPIO_ACTIVE_HIGH>;
 		maximum-power-milliwatt = <3000>;
 
 		/* enabled by U-Boot if SFP module is present */
diff --git a/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts b/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts
index a35317d24d6c..b20c8e7d923b 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts
@@ -65,20 +65,20 @@ alarm2 {
 	sfp_eth0: sfp-eth0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&i2c0>;
-		los-gpio = <&gpiosb 2 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&gpiosb 3 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&gpiosb 4 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&gpiosb 5 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&gpiosb 2 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&gpiosb 3 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&gpiosb 4 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&gpiosb 5 GPIO_ACTIVE_HIGH>;
 		maximum-power-milliwatt = <3000>;
 	};
 
 	sfp_eth1: sfp-eth1 {
 		compatible = "sff,sfp";
 		i2c-bus = <&i2c1>;
-		los-gpio = <&gpiosb 7 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&gpiosb 8 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&gpiosb 9 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&gpiosb 10 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&gpiosb 7 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&gpiosb 8 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&gpiosb 9 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&gpiosb 10 GPIO_ACTIVE_HIGH>;
 		maximum-power-milliwatt = <3000>;
 	};
 };
diff --git a/arch/arm64/boot/dts/marvell/armada-7040-mochabin.dts b/arch/arm64/boot/dts/marvell/armada-7040-mochabin.dts
index 39a8e5e99d79..5f6ed735e31a 100644
--- a/arch/arm64/boot/dts/marvell/armada-7040-mochabin.dts
+++ b/arch/arm64/boot/dts/marvell/armada-7040-mochabin.dts
@@ -34,20 +34,20 @@ aliases {
 	sfp_eth0: sfp-eth0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&cp0_i2c1>;
-		los-gpio = <&sfp_gpio 3 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&sfp_gpio 2 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&sfp_gpio 1 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio  = <&sfp_gpio 0 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&sfp_gpio 3 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&sfp_gpio 2 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&sfp_gpio 1 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios  = <&sfp_gpio 0 GPIO_ACTIVE_HIGH>;
 	};
 
 	/* SFP 1G */
 	sfp_eth2: sfp-eth2 {
 		compatible = "sff,sfp";
 		i2c-bus = <&cp0_i2c0>;
-		los-gpio = <&sfp_gpio 7 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&sfp_gpio 6 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&sfp_gpio 5 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio  = <&sfp_gpio 4 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&sfp_gpio 7 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&sfp_gpio 6 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&sfp_gpio 5 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios  = <&sfp_gpio 4 GPIO_ACTIVE_HIGH>;
 	};
 };
 
diff --git a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
index 871f84b4a6ed..079c2745070a 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
+++ b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
@@ -64,8 +64,8 @@ v_5v0_usb3_hst_vbus: regulator-usb3-vbus0 {
 	sfp_cp0_eth0: sfp-cp0-eth0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&cp0_i2c1>;
-		mod-def0-gpio = <&cp0_gpio2 17 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp1_gpio1 29 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp0_gpio2 17 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp1_gpio1 29 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&cp0_sfp_present_pins &cp1_sfp_tx_disable_pins>;
 		maximum-power-milliwatt = <2000>;
diff --git a/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi b/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi
index 779cf167c33e..33c179838e24 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi
@@ -65,10 +65,10 @@ sfp_eth0: sfp-eth0 {
 		/* CON15,16 - CPM lane 4 */
 		compatible = "sff,sfp";
 		i2c-bus = <&sfpp0_i2c>;
-		los-gpio = <&cp1_gpio1 28 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&cp1_gpio1 27 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp1_gpio1 29 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio  = <&cp1_gpio1 26 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&cp1_gpio1 28 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp1_gpio1 27 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp1_gpio1 29 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios  = <&cp1_gpio1 26 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&cp1_sfpp0_pins>;
 		maximum-power-milliwatt = <2000>;
@@ -78,10 +78,10 @@ sfp_eth1: sfp-eth1 {
 		/* CON17,18 - CPS lane 4 */
 		compatible = "sff,sfp";
 		i2c-bus = <&sfpp1_i2c>;
-		los-gpio = <&cp1_gpio1 8 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&cp1_gpio1 11 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp1_gpio1 10 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&cp0_gpio2 30 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&cp1_gpio1 8 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp1_gpio1 11 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp1_gpio1 10 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&cp0_gpio2 30 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&cp1_sfpp1_pins &cp0_sfpp1_pins>;
 		maximum-power-milliwatt = <2000>;
@@ -91,10 +91,10 @@ sfp_eth3: sfp-eth3 {
 		/* CON13,14 - CPS lane 5 */
 		compatible = "sff,sfp";
 		i2c-bus = <&sfp_1g_i2c>;
-		los-gpio = <&cp0_gpio2 22 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&cp0_gpio2 21 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp1_gpio1 24 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&cp0_gpio2 19 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&cp0_gpio2 22 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp0_gpio2 21 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp1_gpio1 24 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&cp0_gpio2 19 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&cp0_sfp_1g_pins &cp1_sfp_1g_pins>;
 		maximum-power-milliwatt = <2000>;
diff --git a/arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dts b/arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dts
index 74bed79e4f5e..72e9b0f671a9 100644
--- a/arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dts
+++ b/arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dts
@@ -67,20 +67,20 @@ v_vddo_h: regulator-1-8v {
 	sfp_cp0_eth0: sfp-cp0-eth0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&sfpplus0_i2c>;
-		los-gpio = <&sfpplus_gpio 11 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&sfpplus_gpio 10 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&sfpplus_gpio 9 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio  = <&sfpplus_gpio 8 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&sfpplus_gpio 11 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&sfpplus_gpio 10 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&sfpplus_gpio 9 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios  = <&sfpplus_gpio 8 GPIO_ACTIVE_HIGH>;
 		maximum-power-milliwatt = <3000>;
 	};
 
 	sfp_cp1_eth0: sfp-cp1-eth0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&sfpplus1_i2c>;
-		los-gpio = <&sfpplus_gpio 3 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&sfpplus_gpio 2 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&sfpplus_gpio 1 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio  = <&sfpplus_gpio 0 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&sfpplus_gpio 3 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&sfpplus_gpio 2 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&sfpplus_gpio 1 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios  = <&sfpplus_gpio 0 GPIO_ACTIVE_HIGH>;
 		maximum-power-milliwatt = <3000>;
 	};
 
diff --git a/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi b/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
index 1acd746284dc..8e4ec243fb8f 100644
--- a/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
@@ -78,9 +78,9 @@ sfp: sfp {
 		compatible = "sff,sfp";
 		i2c-bus = <&cp0_i2c1>;
 		mod-def0-gpios = <&expander0 3 GPIO_ACTIVE_LOW>;
-		los-gpio = <&expander0 15 GPIO_ACTIVE_HIGH>;
-		tx-disable-gpio = <&expander0 2 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&cp0_gpio1 24 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&expander0 15 GPIO_ACTIVE_HIGH>;
+		tx-disable-gpios = <&expander0 2 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&cp0_gpio1 24 GPIO_ACTIVE_HIGH>;
 		maximum-power-milliwatt = <3000>;
 		status = "okay";
 	};
diff --git a/arch/arm64/boot/dts/marvell/cn9130-db.dtsi b/arch/arm64/boot/dts/marvell/cn9130-db.dtsi
index 7e20987253a3..85d7ce13e70a 100644
--- a/arch/arm64/boot/dts/marvell/cn9130-db.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9130-db.dtsi
@@ -90,10 +90,10 @@ cp0_reg_sd_vcc: cp0_sd_vcc@0 {
 	cp0_sfp_eth0: sfp-eth@0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&cp0_sfpp0_i2c>;
-		los-gpio = <&cp0_module_expander1 11 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&cp0_module_expander1 10 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp0_module_expander1 9 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&cp0_module_expander1 8 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&cp0_module_expander1 11 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp0_module_expander1 10 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp0_module_expander1 9 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&cp0_module_expander1 8 GPIO_ACTIVE_HIGH>;
 		/*
 		 * SFP cages are unconnected on early PCBs because of an the I2C
 		 * lanes not being connected. Prevent the port for being
diff --git a/arch/arm64/boot/dts/marvell/cn9131-db.dtsi b/arch/arm64/boot/dts/marvell/cn9131-db.dtsi
index b7fc241a228c..ff8422fae31b 100644
--- a/arch/arm64/boot/dts/marvell/cn9131-db.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9131-db.dtsi
@@ -37,10 +37,10 @@ cp1_usb3_0_phy0: cp1_usb3_phy0 {
 	cp1_sfp_eth1: sfp-eth1 {
 		compatible = "sff,sfp";
 		i2c-bus = <&cp1_i2c0>;
-		los-gpio = <&cp1_gpio1 11 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&cp1_gpio1 10 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp1_gpio1 9 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&cp1_gpio1 8 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&cp1_gpio1 11 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp1_gpio1 10 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp1_gpio1 9 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&cp1_gpio1 8 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&cp1_sfp_pins>;
 		/*
diff --git a/arch/arm64/boot/dts/marvell/cn9132-db.dtsi b/arch/arm64/boot/dts/marvell/cn9132-db.dtsi
index 3f1795fb4fe7..512a4fa2861e 100644
--- a/arch/arm64/boot/dts/marvell/cn9132-db.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9132-db.dtsi
@@ -57,10 +57,10 @@ cp2_reg_sd_vccq: cp2_sd_vccq@0 {
 	cp2_sfp_eth0: sfp-eth0 {
 		compatible = "sff,sfp";
 		i2c-bus = <&cp2_sfpp0_i2c>;
-		los-gpio = <&cp2_module_expander1 11 GPIO_ACTIVE_HIGH>;
-		mod-def0-gpio = <&cp2_module_expander1 10 GPIO_ACTIVE_LOW>;
-		tx-disable-gpio = <&cp2_module_expander1 9 GPIO_ACTIVE_HIGH>;
-		tx-fault-gpio = <&cp2_module_expander1 8 GPIO_ACTIVE_HIGH>;
+		los-gpios = <&cp2_module_expander1 11 GPIO_ACTIVE_HIGH>;
+		mod-def0-gpios = <&cp2_module_expander1 10 GPIO_ACTIVE_LOW>;
+		tx-disable-gpios = <&cp2_module_expander1 9 GPIO_ACTIVE_HIGH>;
+		tx-fault-gpios = <&cp2_module_expander1 8 GPIO_ACTIVE_HIGH>;
 		/*
 		 * SFP cages are unconnected on early PCBs because of an the I2C
 		 * lanes not being connected. Prevent the port for being
-- 
2.34.1

