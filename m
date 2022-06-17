Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D2E54FE70
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 22:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355679AbiFQUeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244773AbiFQUds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:33:48 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6498A5C861;
        Fri, 17 Jun 2022 13:33:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0LdQquNrdWAhrwb/TMx6bpQW/bWF4evuRternIAGg3iUrNMOHp99SKKmXtEdvzP0xn4eG+QLhl0C1OLrkUJRHwy1Lci2jmxK9/W6V/3YsiTpzPQ2gZU1+LdlczgitZpnbxKxMizRIqRqtJyWEi1dAFEigs6xerwp41ZohXsp5DkLugk2Sm4CzuwiKOK0epIgqTz2JFPmC6RMNnhYhHKl4qKagKpi1oi4vygGqc4jSIc5NjtP7dWaUjZRrT5v7hCisJ9SB9Zxl6qvT2n53LoULNMbYW0WOBuTRDA8GutmRpyLHWaR16vZGMQu/PC0ZQP38LJ2gcIx4SZ7dcVe66vZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZQL8DuiiHr4b/Jw5JGC2VAjAoOOVoDymodmZjPki4A=;
 b=QmHu2f/SIU4uB2wkUOqFxT+47Be4uhQHpMrRawWG/jiPLmZUKP/mXCGXJzkCsz2LVGG5SUsRTMQxqlwdOyhp1WcCwBHh9MQRq62qR9vAIlwOUN/Csep50OZhXiWkySIuMhjHIqtp0MY915fP9B6IO4YUhltQrTN8MFWSXwg3X5e6N27aU+RNxa7IYi2zZbDLIQrB4p+x7XkvfBce/4pz3BglJVDgomV4BgMt3JEo1mAHgQiZMcErH1Zk4kbwnhh7iMvC2oqb4URsTdKmrq+9gS26W8WGYzB09vVj0qPt52KG/brkigm3Og+RnJPf9rWYuxhPq8oQezmxFnnGm/calw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZQL8DuiiHr4b/Jw5JGC2VAjAoOOVoDymodmZjPki4A=;
 b=kYNOTrG6YDzB3ch16+La7KaTU9hKQuIWLINJ3+hBkSbXT6j9EkcIwHYZ4QVwL50vasORYMtZTe7ZehFDan2E1oE4beWhqZEWDkawyK0wzmjpDMTxx32xtopiSGkZD0K8HAU4s3AM9Dst7L3dlm5toMEo+LFZyUNejAprOdyWYSKX+dRbBNyGsWY+Kma6vaFlZP3eceiZPgebckxTmGD5Fc0QHW8gL0uINPtHvSIn2B8/JqWdI90/xagymuXCM+g/3cCqI2oZu26Dt7r74LQwcsDn1FOy65spWodD9vruhoKM+CgiorhAQiMHwftP8Lr9GacSJB7m/qYlAex2E+e7ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBAPR03MB6438.eurprd03.prod.outlook.com (2603:10a6:10:19f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:33:41 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:33:41 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org
Subject: [PATCH net-next 03/28] phy: fsl: Add QorIQ SerDes driver
Date:   Fri, 17 Jun 2022 16:32:47 -0400
Message-Id: <20220617203312.3799646-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b08c7b14-f277-411a-cb25-08da50a0aa57
X-MS-TrafficTypeDiagnostic: DBAPR03MB6438:EE_
X-Microsoft-Antispam-PRVS: <DBAPR03MB64381027D3BC1B222CEEF28496AF9@DBAPR03MB6438.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pMPHkVL50YAvlnBOXSIlKoXuicKJcpsipf0wOIOIhhuzoJtVyuxsn9G//22E7foZdz4X3W2SvPD0ynyclee9VSLhGH1ah7YfN3zAO2pewr6zFUG3sqsPXX8u27KwJXTVhjS2j1l/sx9b2VDVpkM1YyhO4FtFCZ7qOG9seywzmAOKw6sssQfL82FyncwOFnq5mwjZxdl4CoOlem0qDCkUMa4sJO0SHBmaj8Ae7X0Pllz9+qJ8ipUC0b2POpRaKL7JqCjJco83O+4TCCAgPFdU7Ttd6Y97q8dkJJj/k/bjfWJgFyen1Hp6IhfZ2uWN729yIZyAhfYENOI9TcjW7JJXxqZJz0LGuvtPtZ1VNgryacOVheEqvDPi/nvRDu2ScAf59HiPhZB3NXg5G9G6+6JC5CMq3oH9a09NNNPOpyhVYF3ZgFCmCXx5HFFJpz1bUwIEzoDsvtBwE8jSqACOOl6r0CRvWM2OoEYeIzLqKVVm3mDKphEAVDWF7mrBGNFOWPukxXdfWZUGeZqkj62OnBN3BSGkwGEyOuwGdLX5RfgRzdX0l0Cm3QRAXm8zWKB99Yb7U2pNH6eiWgUdnSZb5ZMwJJl7G6wj2l19fJpyXce6iitgugHsxhq+2DKlPpbVL1UdlS1VwqgpZ3sUJpkaQm64Hg5YdC7IXJGEIW/89z1oJ8Jvp7pNUuvUosPjzcu0RAM6tEpG/LUwaFPJNKZuolS87ksXj8LpAtvWi4Z2n6EmpW8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(38350700002)(86362001)(7416002)(38100700002)(186003)(2616005)(5660300002)(6512007)(6486002)(52116002)(2906002)(6506007)(110136005)(8936002)(54906003)(498600001)(316002)(1076003)(66946007)(36756003)(30864003)(8676002)(26005)(83380400001)(4326008)(66556008)(66476007)(21314003)(579004)(559001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rrAjCUBaXEWbhVyha7qA/VFgQhXiS+SUUCHXVfKyk8HXHOAYm+0Y98kQgcII?=
 =?us-ascii?Q?Z/tL6G8bTkv2gQJvhvxzsnPKmqric1A4lDtwmXJENYxD21BekkxH8tu89CFH?=
 =?us-ascii?Q?cI9xXzhkqwzJwaYT9VatmaVrxf7F7se6FFGZCiKh/goZwTobQnHJMCBBEqH8?=
 =?us-ascii?Q?kzisO00UOo8jOIwqtvZKM79GMLwkBMOB9FZnNTZ09KD8DRL4S6dgro2pDDrz?=
 =?us-ascii?Q?6xg8GHPvXMuyVeQmWu8BYU8je5UWSLyjrPlidmREmrgrjjxjHQeSzAv3tr3u?=
 =?us-ascii?Q?s7Qhvs9Bja251IkZBH5P3vk6vL+OujeaJ8njrgWvQ/F8aYumVP7Q1zg/YLoS?=
 =?us-ascii?Q?gpMSsCDo+ZD5a3RY66cUcJVakUMmRSfmhF3lOqY+PLbbpVIHkMnp+zo/pyVt?=
 =?us-ascii?Q?13POaDApQ2PuH5EWNpILsrsxqPPm6VRhldFRMgE+sxOoo7FCzgfnQYNCSqIW?=
 =?us-ascii?Q?Uix9HAS7h/NImR7jD5EWwYm5k2/2eMpjf25IfRn4KR+P7I0Ko1a35CxNGRG9?=
 =?us-ascii?Q?8gTYiGQP/oP0/cDzIgVc2DyLl2XzzcCaPBF3wAinW86hb6AISNgIcuzWgUIU?=
 =?us-ascii?Q?PyefaEssArGooIP1X6LaZ3071vgql7otzQ1lr+4XbIU0MwpHGJWBMVhTeIoe?=
 =?us-ascii?Q?8x8fR3UPMWoZjRdiDU3WG4pZCAxPPY87xK7dT2Baw/sEihALpjzSbkP+XPA8?=
 =?us-ascii?Q?5CcaC0QThu7FYPw3Fr1ce9wsYOiTdNXzMlwwzl+lciEEIQ4Y0NEuvKx0wy8B?=
 =?us-ascii?Q?ECjMQ73dWZkcsUyjYGpUMLnusZpsJD0198wtwSScHU84SvOSmidZfO+90W9t?=
 =?us-ascii?Q?eOwjn4pM0Drh4M17nAO+pDkXcAlbPYvN6oTlXDBB4091vKb6efiDSboEEVSm?=
 =?us-ascii?Q?m2zQV8f4vfvAqe6UJpkSzumiirTEK3Lf2NlRR7sSXIb1+va9iM61p7lsQtEz?=
 =?us-ascii?Q?nf4Jd3wfg3DNnpQdcn9F8yHEnnDaqkhX+FbBQHTFashqghuhAZETdbw0+L//?=
 =?us-ascii?Q?2QgMLKct+Qf/pU8fhx/+aZoY6thT5fK8bNmUWjPuzDnNjJOhQvfp6dbcdv2y?=
 =?us-ascii?Q?x+73kqJaoCwXfRY4+3xef0vs4P+L8rETvdIe1xjrOa12kR/lh8zC7p1oaepz?=
 =?us-ascii?Q?+T1E/Y4Qn4ZEqMoq2SsdxPRRC73nZ4toyY2nhzwOzARsRLd3l9otRCN/pELK?=
 =?us-ascii?Q?Cr46zpOE3XwkRkAvYoDhRkcrFhgm7Kxw69lQH1jqul+Qr/oW2sVf3wlw/QVt?=
 =?us-ascii?Q?qT32kYUdJnkgS2KzxA/qrOAs6ZKGkDV5O80lSrMj4A+r3MqCFnELwS1AV6HV?=
 =?us-ascii?Q?uo2lq3dmUdd5Ro4j688AIK3J4HDv/mkV8HryUZlPhiN3Y1dNEanuMW1Pbukj?=
 =?us-ascii?Q?FPVbyTiqY5nKemxTa5naSyM0RoOv0/HmYOJU0M+jmmaXeRSXHre/9UUS3xOh?=
 =?us-ascii?Q?q2mwDXefstnka7UG/wZgPwWQwKbQbQx0RBg/PjkQQqXnKtkqp4hIrRftxmRQ?=
 =?us-ascii?Q?1yqE7Y91ekDNC4l7PBwe7TTHvAvQg5+Zt6HhxrqtIpFKLfXF7pZWOvlpzo1P?=
 =?us-ascii?Q?g9w/p3YWup/IXyGCjiENxMhRyJmoJEL0+1AKQBF32HureVWER5cdyJICj44Q?=
 =?us-ascii?Q?LUiyXDniWIDluX1+95E1e2kz3pooj2a6cgrwqFNf8a5m06V2OCi5k8olMWyo?=
 =?us-ascii?Q?XrAIarQy5xErQzYqlIMljLR8sAcuR7Y+m7XOoEEhI8bYvmSK/IiM7tjzQQyB?=
 =?us-ascii?Q?bDmj6WIqPciPUkgCFcYEEzf+YwqEy0Q=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b08c7b14-f277-411a-cb25-08da50a0aa57
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:33:41.1716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: omsolLEP857N4olwHZe3CZ3ittePvT0UJEvDPqyDDWEAlKcYJwAulZo1fO9U1if8Yycv4DCKXyvUoGAWEL6KJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6438
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for the "SerDes" devices found on various NXP QorIQ SoCs.
There may be up to four SerDes devices on each SoC, each supporting up to
eight lanes. Protocol support for each SerDes is highly heterogeneous, with
each SoC typically having a totally different selection of supported
protocols for each lane. Additionally, the SerDes devices on each SoC also
have differing support. One SerDes will typically support Ethernet on most
lanes, while the other will typically support PCIe on most lanes.

There is wide hardware support for this SerDes. I have not done extensive
digging, but it seems to be used on almost every QorIQ device, including
the AMP and Layerscape series. Because each SoC typically has specific
instructions and exceptions for its SerDes, I have limited the initial
scope of this module to just the LS1046A. Additionally, I have only added
support for Ethernet protocols. There is not a great need for dynamic
reconfiguration for other protocols (SATA and PCIe handle rate changes in
hardware), so support for them may never be added.

Nevertheless, I have tried to provide an obvious path for adding support
for other SoCs as well as other protocols. SATA just needs support for
configuring LNmSSCR0. PCIe may need to configure the equalization
registers. It also uses multiple lanes. I have tried to write the driver
with multi-lane support in mind, so there should not need to be any large
changes. Although there are 6 protocols supported, I have only tested SGMII
and XFI. The rest have been implemented as described in the datasheet.

The PLLs are modeled as clocks proper. This lets us take advantage of the
existing clock infrastructure. I have not given the same treatment to the
lane "clocks" (dividers) because they need to be programmed in-concert with
the rest of the lane settings. One tricky thing is that the VCO (pll) rate
exceeds 2^32 (maxing out at around 5GHz). This will be a problem on 32-bit
platforms, since clock rates are stored as unsigned longs. To work around
this, the pll clock rate is generally treated in units of kHz.

The PLLs are configured rather interestingly. Instead of the usual direct
programming of the appropriate divisors, the input and output clock rates
are selected directly. Generally, the only restriction is that the input
and output must be integer multiples of each other. This suggests some kind
of internal look-up table. The datasheets generally list out the supported
combinations explicitly, and not all input/output combinations are
documented. I'm not sure if this is due to lack of support, or due to an
oversight. If this becomes an issue, then some combinations can be
blacklisted (or whitelisted). This may also be necessary for other SoCs
which have more stringent clock requirements.

The general API call list for this PHY is documented under the driver-api
docs. I think this is rather standard, except that most driverts configure
the mode (protocol) at xlate-time. Unlike some other phys where e.g. PCIe
x4 will use 4 separate phys all configured for PCIe, this driver uses one
phy configured to use 4 lanes. This is because while the individual lanes
may be configured individually, the protocol selection acts on all lanes at
once. Additionally, the order which lanes should be configured in is
specified by the datasheet.  To coordinate this, lanes are reserved in
phy_init, and released in phy_exit.

When getting a phy, if a phy already exists for those lanes, it is reused.
This is to make things like QSGMII work. Four MACs will all want to ensure
that the lane is configured properly, and we need to ensure they can all
call phy_init, etc. There is refcounting for phy_init and phy_power_on, so
the phy will only be powered on once. However, there is no refcounting for
phy_set_mode. A "rogue" MAC could set the mode to something non-QSGMII and
break the other MACs. Perhaps there is an opportunity for future
enhancement here.

This driver was written with reference to the LS1046A reference manual.
However, it was informed by reference manuals for all processors with
MEMACs, especially the T4240 (which appears to have a "maxed-out"
configuration).

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This appears to be the same underlying hardware as the Lynx 28G phy
added in 8f73b37cf3fb ("phy: add support for the Layerscape SerDes
28G"). I was working off an older Linux when preparing this series, so I
did not notice it. However, I believe this implementation is more
comprehensive/versatile. I will look into resolving the differences in
the future.

 Documentation/driver-api/phy/index.rst |    1 +
 Documentation/driver-api/phy/qoriq.rst |   91 ++
 MAINTAINERS                            |    6 +
 drivers/phy/freescale/Kconfig          |   19 +
 drivers/phy/freescale/Makefile         |    1 +
 drivers/phy/freescale/phy-qoriq.c      | 1441 ++++++++++++++++++++++++
 6 files changed, 1559 insertions(+)
 create mode 100644 Documentation/driver-api/phy/qoriq.rst
 create mode 100644 drivers/phy/freescale/phy-qoriq.c

diff --git a/Documentation/driver-api/phy/index.rst b/Documentation/driver-api/phy/index.rst
index 69ba1216de72..cc7ded8b969c 100644
--- a/Documentation/driver-api/phy/index.rst
+++ b/Documentation/driver-api/phy/index.rst
@@ -7,6 +7,7 @@ Generic PHY Framework
 .. toctree::
 
    phy
+   qoriq
    samsung-usb2
 
 .. only::  subproject and html
diff --git a/Documentation/driver-api/phy/qoriq.rst b/Documentation/driver-api/phy/qoriq.rst
new file mode 100644
index 000000000000..ea60fb75a295
--- /dev/null
+++ b/Documentation/driver-api/phy/qoriq.rst
@@ -0,0 +1,91 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============
+QorIQ SerDes
+============
+
+Using this phy
+--------------
+
+The general order of calls should be::
+
+    [devm_][of_]phy_get()
+    phy_init()
+    phy_power_on()
+    phy_set_mode[_ext]()
+    ...
+    phy_power_off()
+    phy_exit()
+    [[of_]phy_put()]
+
+:c:func:`phy_get` just gets (or creates) a new :c:type:`phy` with the lanes
+described in the phandle. :c:func:`phy_init` is what actually reserves the
+lanes for use. Unlike some other drivers, when the phy is created, there is no
+default protocol. :c:func:`phy_set_mode <phy_set_mode_ext>` must be called in
+order to set the protocol.
+
+Supporting SoCs
+---------------
+
+Each new SoC needs a :c:type:`struct qs_conf <qs_conf>` for each SerDes. The
+most important member is `modes`, which is an array of :c:type:`struct qs_mode
+<qs_mode>`. Each "mode" represents a configuration which can be programmed into
+a protocol control register. Modes can support multiple lanes (such for PCIe x2
+or x4), as well as multiple protocols (such as SGMII and 1000Base-KX). There
+are several helper macros to make configuring each mode easier. It is important
+that the list of modes is complete, even if not all protocols are supported.
+This lets the driver know which lanes are available, and which have been
+configured by the RCW.
+
+If a protocol is missing, add it to :c:type:`enum qs_protocol <qs_protocol>`,
+and to ``UNSUPPORTED_PROTOS``. If the PCCR shifts/masks for your protocol are
+missing, you will need to add them to :c:func:`qs_proto_mode_mask` and
+:c:func:`qs_proto_mode_shift`.
+
+For example, the configuration for SerDes1 of the LS1046A is::
+
+    static const struct qs_mode ls1046a_modes1[] = {
+        CONF_SINGLE(1, PCIE, 0x0, 1, 0b001),
+        CONF_1000BASEKX(0, 0x8, 0, 0b001),
+        CONF_SGMII25KX(1, 0x8, 1, 0b001),
+        CONF_SGMII25KX(2, 0x8, 2, 0b001),
+        CONF_SGMII25KX(3, 0x8, 3, 0b001),
+        CONF_SINGLE(1, QSGMII, 0x9, 2, 0b001),
+        CONF_XFI(2, 0xB, 0, 0b010),
+        CONF_XFI(3, 0xB, 1, 0b001),
+    };
+
+    static const struct qs_conf ls1046a_conf1 = {
+        .modes = ls1046a_modes1,
+        .mode_count = ARRAY_SIZE(ls1046a_modes1),
+        .lanes = 4,
+        .endian = REGMAP_ENDIAN_BIG,
+    };
+
+There is an additional set of configuration for SerDes2, which supports a
+different set of modes. Both configurations should be added to the match table::
+
+    { .compatible = "fsl,ls1046-serdes-1", .data = &ls1046a_conf1 },
+    { .compatible = "fsl,ls1046-serdes-2", .data = &ls1046a_conf2 },
+
+Supporting Protocols
+--------------------
+
+Each protocol is a combination of values which must be programmed into the lane
+registers. To add a new protocol, first add it to :c:type:`enum qs_protocol
+<qs_protocol>`. If it is in ``UNSUPPORTED_PROTOS``, remove it. Add a new entry to
+`qs_proto_params`, and populate the appropriate fields. You may need to add
+some new members to support new fields. Modify `qs_lookup_proto` to map the
+:c:type:`enum phy_mode <phy_mode>` to :c:type:`enum qs_protocol <qs_protocol>`.
+Ensure that :c:func:`qs_proto_mode_mask` and :c:func:`qs_proto_mode_shift` have
+been updated with support for your protocol.
+
+You may need to modify :c:func:`qs_set_mode` in order to support your procotol.
+This can happen when you have added members to :c:type:`struct qs_proto_params
+<qs_proto_params>`. It can also happen if you have specific clocking
+requirements, or protocol-specific registers to program.
+
+Internal API Reference
+----------------------
+
+.. kernel-doc:: drivers/phy/freescale/phy-qoriq.c
diff --git a/MAINTAINERS b/MAINTAINERS
index ca95b1833b97..ef65e2acdb48 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7977,6 +7977,12 @@ F:	drivers/ptp/ptp_qoriq.c
 F:	drivers/ptp/ptp_qoriq_debugfs.c
 F:	include/linux/fsl/ptp_qoriq.h
 
+FREESCALE QORIQ SERDES DRIVER
+M:	Sean Anderson <sean.anderson@seco.com>
+S:	Maintained
+F:	Documentation/driver-api/phy/qoriq.rst
+F:	drivers/phy/freescale/phy-qoriq.c
+
 FREESCALE QUAD SPI DRIVER
 M:	Han Xu <han.xu@nxp.com>
 L:	linux-spi@vger.kernel.org
diff --git a/drivers/phy/freescale/Kconfig b/drivers/phy/freescale/Kconfig
index f9c54cd02036..c65dbcc58565 100644
--- a/drivers/phy/freescale/Kconfig
+++ b/drivers/phy/freescale/Kconfig
@@ -38,3 +38,22 @@ config PHY_FSL_LYNX_28G
 	  found on NXP's Layerscape platforms such as LX2160A.
 	  Used to change the protocol running on SerDes lanes at runtime.
 	  Only useful for a restricted set of Ethernet protocols.
+
+config PHY_QORIQ
+	tristate "QorIQ SerDes support"
+	select GENERIC_PHY
+	select REGMAP_MMIO
+	help
+	  This adds support for the "SerDes" devices found on various QorIQ
+	  SoCs. There may be up to four SerDes devices on each SoC, and each
+	  device supports up to eight lanes. The SerDes is configured by
+	  default by the RCW, but this module is necessary in order to support
+	  dynamic reconfiguration (such as to support 1G and 10G ethernet on
+	  the same interface). The hardware supports a variety of protocols,
+	  including Ethernet, SATA, PCIe, and more exotic links such as
+	  Interlaken and Aurora. This driver only supports Ethernet, but it
+	  will try not to touch lanes configured for other protocols.
+
+	  If you have a QorIQ processor and want to dynamically reconfigure
+	  your SerDes, say Y. If this driver is compiled as a module, it will
+	  be named phy-qoriq.
diff --git a/drivers/phy/freescale/Makefile b/drivers/phy/freescale/Makefile
index 3518d5dbe8a7..2aca938d9e75 100644
--- a/drivers/phy/freescale/Makefile
+++ b/drivers/phy/freescale/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_PHY_FSL_IMX8MQ_USB)	+= phy-fsl-imx8mq-usb.o
 obj-$(CONFIG_PHY_MIXEL_MIPI_DPHY)	+= phy-fsl-imx8-mipi-dphy.o
 obj-$(CONFIG_PHY_FSL_IMX8M_PCIE)	+= phy-fsl-imx8m-pcie.o
 obj-$(CONFIG_PHY_FSL_LYNX_28G)		+= phy-fsl-lynx-28g.o
+obj-$(CONFIG_PHY_QORIQ)			+= phy-qoriq.o
diff --git a/drivers/phy/freescale/phy-qoriq.c b/drivers/phy/freescale/phy-qoriq.c
new file mode 100644
index 000000000000..6edd770a4c4f
--- /dev/null
+++ b/drivers/phy/freescale/phy-qoriq.c
@@ -0,0 +1,1441 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Sean Anderson <sean.anderson@seco.com>
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/math64.h>
+#include <linux/platform_device.h>
+#include <linux/phy.h>
+#include <linux/phy/phy.h>
+#include <linux/regmap.h>
+#include <linux/units.h>
+
+#define PLL_STRIDE	0x20
+#define PLLa(a, off)	((a) * PLL_STRIDE + (off))
+#define PLLaRSTCTL(a)	PLLa(a, 0x00)
+#define PLLaCR0(a)	PLLa(a, 0x04)
+
+#define PLLaRSTCTL_RSTREQ	BIT(31)
+#define PLLaRSTCTL_RST_DONE	BIT(30)
+#define PLLaRSTCTL_RST_ERR	BIT(29)
+#define PLLaRSTCTL_PLLRST_B	BIT(7)
+#define PLLaRSTCTL_SDRST_B	BIT(6)
+#define PLLaRSTCTL_SDEN		BIT(5)
+
+#define PLLaCR0_POFF		BIT(31)
+#define PLLaCR0_RFCLK_SEL	GENMASK(30, 28)
+#define PLLaCR0_PLL_LCK		BIT(23)
+#define PLLaCR0_FRATE_SEL	GENMASK(19, 16)
+#define PLLaCR0_DLYDIV_SEL	GENMASK(1, 0)
+
+#define PCCR_BASE	0x200
+#define PCCR_STRIDE	0x4
+#define PCCRn(n)	(PCCR_BASE + n * PCCR_STRIDE)
+
+#define PCCR0_PEXa_MASK		GENMASK(2, 0)
+#define PCCR0_PEXa_SHIFT(a)	(28 - (a) * 4)
+
+#define PCCR2_SATAa_MASK	GENMASK(2, 0)
+#define PCCR2_SATAa_SHIFT(a)	(28 - (a) * 4)
+
+#define PCCR8_SGMIIa_KX(a)	BIT(31 - ((a) * 4))
+#define PCCR8_SGMIIa_MASK	GENMASK(2, 0)
+#define PCCR8_SGMIIa_SHIFT(a)	(28 - (a) * 4)
+
+#define PCCR9_QSGMIIa_MASK	GENMASK(2, 0)
+#define PCCR9_QSGMIIa_SHIFT(a)	(28 - (a) * 4)
+
+#define PCCRB_XFIa_MASK		GENMASK(2, 0)
+#define PCCRB_XFIa_SHIFT(a)	(28 - (a) * 4)
+
+#define LANE_BASE	0x800
+#define LANE_STRIDE	0x40
+#define LNm(m, off)	(LANE_BASE + (m) * LANE_STRIDE + (off))
+#define LNmGCR0(m)	LNm(m, 0x00)
+#define LNmGCR1(m)	LNm(m, 0x04)
+#define LNmSSCR0(m)	LNm(m, 0x0C)
+#define LNmRECR0(m)	LNm(m, 0x10)
+#define LNmRECR1(m)	LNm(m, 0x14)
+#define LNmTECR0(m)	LNm(m, 0x18)
+#define LNmSSCR1(m)	LNm(m, 0x1C)
+#define LNmTTLCR0(m)	LNm(m, 0x20)
+
+#define LNmGCR0_RPLL_LES	BIT(31)
+#define LNmGCR0_RRAT_SEL	GENMASK(29, 28)
+#define LNmGCR0_TPLL_LES	BIT(27)
+#define LNmGCR0_TRAT_SEL	GENMASK(25, 24)
+#define LNmGCR0_RRST_B		BIT(22)
+#define LNmGCR0_TRST_B		BIT(21)
+#define LNmGCR0_RX_PD		BIT(20)
+#define LNmGCR0_TX_PD		BIT(19)
+#define LNmGCR0_IF20BIT_EN	BIT(18)
+#define LNmGCR0_FIRST_LANE	BIT(16)
+#define LNmGCR0_TTRM_VM_SEL	GENMASK(13, 12)
+#define LNmGCR0_PROTS		GENMASK(11, 7)
+
+#define LNmGCR0_RAT_SEL_SAME		0b00
+#define LNmGCR0_RAT_SEL_HALF		0b01
+#define LNmGCR0_RAT_SEL_QUARTER		0b10
+#define LNmGCR0_RAT_SEL_DOUBLE		0b11
+
+#define LNmGCR0_PROTS_PCIE		0b00000
+#define LNmGCR0_PROTS_SGMII		0b00001
+#define LNmGCR0_PROTS_SATA		0b00010
+#define LNmGCR0_PROTS_XFI		0b01010
+
+#define LNmGCR1_RDAT_INV	BIT(31)
+#define LNmGCR1_TDAT_INV	BIT(30)
+#define LNmGCR1_OPAD_CTL	BIT(26)
+#define LNmGCR1_REIDL_TH	GENMASK(22, 20)
+#define LNmGCR1_REIDL_EX_SEL	GENMASK(19, 18)
+#define LNmGCR1_REIDL_ET_SEL	GENMASK(17, 16)
+#define LNmGCR1_REIDL_EX_MSB	BIT(15)
+#define LNmGCR1_REIDL_ET_MSB	BIT(14)
+#define LNmGCR1_REQ_CTL_SNP	BIT(13)
+#define LNmGCR1_REQ_CDR_SNP	BIT(12)
+#define LNmGCR1_TRSTDIR		BIT(7)
+#define LNmGCR1_REQ_BIN_SNP	BIT(6)
+#define LNmGCR1_ISLEW_RCTL	GENMASK(5, 4)
+#define LNmGCR1_OSLEW_RCTL	GENMASK(1, 0)
+
+#define LNmRECR0_GK2OVD		GENMASK(27, 24)
+#define LNmRECR0_GK3OVD		GENMASK(19, 16)
+#define LNmRECR0_GK2OVD_EN	BIT(15)
+#define LNmRECR0_GK3OVD_EN	BIT(16)
+#define LNmRECR0_BASE_WAND	GENMASK(11, 10)
+#define LNmRECR0_OSETOVD	GENMASK(5, 0)
+
+#define LNmRECR0_BASE_WAND_OFF		0b00
+#define LNmRECR0_BASE_WAND_DEFAULT	0b01
+#define LNmRECR0_BASE_WAND_ALTERNATE	0b10
+#define LNmRECR0_BASE_WAND_OSETOVD	0b11
+
+#define LNmTECR0_TEQ_TYPE	GENMASK(29, 28)
+#define LNmTECR0_SGN_PREQ	BIT(26)
+#define LNmTECR0_RATIO_PREQ	GENMASK(25, 22)
+#define LNmTECR0_SGN_POST1Q	BIT(21)
+#define LNmTECR0_RATIO_PST1Q	GENMASK(20, 16)
+#define LNmTECR0_ADPT_EQ	GENMASK(13, 8)
+#define LNmTECR0_AMP_RED	GENMASK(5, 0)
+
+#define LNmTECR0_TEQ_TYPE_NONE		0b00
+#define LNmTECR0_TEQ_TYPE_PRE		0b01
+#define LNmTECR0_TEQ_TYPE_BOTH		0b10
+
+#define LNmTTLCR0_FLT_SEL	GENMASK(29, 24)
+
+#define PCS_STRIDE	0x10
+#define CR_STRIDE	0x4
+#define PCSa(a, base, cr)	(base + (a) * PCS_STRIDE + (cr) * CR_STRIDE)
+
+#define PCSaCR1_MDEV_PORT	GENMASK(31, 27)
+
+#define SGMII_BASE	0x1800
+#define SGMIIaCR1(a)	PCSa(a, SGMII_BASE, 1)
+
+#define SGMIIaCR1_SGPCS_EN	BIT(11)
+
+#define QSGMII_OFFSET	0x1880
+#define QSGMIIaCR1(a)	PCSa(a, QSGMII_BASE, 1)
+
+#define XFI_OFFSET	0x1980
+#define XFIaCR1(a)	PCSa(a, XFI_BASE, 1)
+
+/* The maximum number of lanes in a single serdes */
+#define MAX_LANES	8
+
+enum qs_protocol {
+	QS_PROTO_UNKNOWN = 0,
+	QS_PROTO_SGMII,
+	QS_PROTO_SGMII25,
+	QS_PROTO_1000BASEKX,
+	QS_PROTO_QSGMII,
+	QS_PROTO_XFI,
+	QS_PROTO_10GKR,
+	QS_PROTO_PCIE, /* Not implemented */
+	QS_PROTO_SATA, /* Not implemented */
+	QS_PROTO_LAST,
+};
+
+static const char qs_proto_str[][16] = {
+	[QS_PROTO_UNKNOWN] = "unknown",
+	[QS_PROTO_SGMII] = "SGMII",
+	[QS_PROTO_SGMII25] = "2.5G SGMII",
+	[QS_PROTO_1000BASEKX] = "1000Base-KX",
+	[QS_PROTO_QSGMII] = "QSGMII",
+	[QS_PROTO_XFI] = "XFI",
+	[QS_PROTO_10GKR] = "10GBase-KR",
+	[QS_PROTO_PCIE] = "PCIe",
+	[QS_PROTO_SATA] = "SATA",
+};
+
+#define PROTO_MASK(proto) BIT(QS_PROTO_##proto)
+#define UNSUPPORTED_PROTOS (PROTO_MASK(SATA) | PROTO_MASK(PCIE))
+
+/**
+ * struct qs_proto_params - Parameters for configuring a protocol
+ * @frate_khz: The PLL rate, in kHz
+ * @rat_sel: The divider to get the line rate
+ * @if20bit: Whether the proto is 20 bits or 10 bits
+ * @prots: Lane protocol select
+ * @reidl_th: Receiver electrical idle detection threshold
+ * @reidl_ex: Exit electrical idle filter
+ * @reidl_et: Enter idle filter
+ * @slew: Slew control
+ * @baseline_wander: Enable baseline wander correction
+ * @gain: Adaptive equalization gain override
+ * @offset_override: Adaptive equalization offset override
+ * @teq: Transmit equalization type (none, precursor, or precursor and
+ *       postcursor). The next few values are only used for appropriate
+ *       equalization types.
+ * @preq_ratio: Ratio of full swing transition bit to pre-cursor
+ * @postq_ratio: Ratio of full swing transition bit to first post-cursor.
+ * @adpt_eq: Transmitter Adjustments for 8G/10G
+ * @amp_red: Overall TX Amplitude Reduction
+ * @flt_sel: TTL configuration selector
+ */
+struct qs_proto_params {
+	u32 frate_khz;
+	u8 rat_sel;
+	u8 prots;
+	u8 reidl_th;
+	u8 reidl_ex;
+	u8 reidl_et;
+	u8 slew;
+	u8 gain;
+	u8 baseline_wander;
+	u8 offset_override;
+	u8 teq;
+	u8 preq_ratio;
+	u8 postq_ratio;
+	u8 adpt_eq;
+	u8 amp_red;
+	u8 flt_sel;
+	bool if20bit;
+};
+
+static const struct qs_proto_params qs_proto_params[] = {
+	[QS_PROTO_SGMII] = {
+		.frate_khz = 5000000,
+		.rat_sel = LNmGCR0_RAT_SEL_QUARTER,
+		.if20bit = false,
+		.prots = LNmGCR0_PROTS_SGMII,
+		.reidl_th = 0b001,
+		.reidl_ex = 0b011,
+		.reidl_et = 0b100,
+		.slew = 0b01,
+		.gain = 0b1111,
+		.offset_override = 0b0011111,
+		.teq = LNmTECR0_TEQ_TYPE_NONE,
+		.adpt_eq = 0b110000,
+		.amp_red = 0b000110,
+		.flt_sel = 0b111001,
+	},
+	[QS_PROTO_1000BASEKX] = {
+		.frate_khz = 5000000,
+		.rat_sel = LNmGCR0_RAT_SEL_QUARTER,
+		.if20bit = false,
+		.prots = LNmGCR0_PROTS_SGMII,
+		.slew = 0b01,
+		.gain = 0b1111,
+		.offset_override = 0b0011111,
+		.teq = LNmTECR0_TEQ_TYPE_NONE,
+		.adpt_eq = 0b110000,
+		.flt_sel = 0b111001,
+	},
+	[QS_PROTO_SGMII25] = {
+		.frate_khz = 3125000,
+		.rat_sel = LNmGCR0_RAT_SEL_SAME,
+		.if20bit = false,
+		.prots = LNmGCR0_PROTS_SGMII,
+		.slew = 0b10,
+		.offset_override = 0b0011111,
+		.teq = LNmTECR0_TEQ_TYPE_PRE,
+		.postq_ratio = 0b00110,
+		.adpt_eq = 0b110000,
+	},
+	[QS_PROTO_QSGMII] = {
+		.frate_khz = 5000000,
+		.rat_sel = LNmGCR0_RAT_SEL_SAME,
+		.if20bit = true,
+		.prots = LNmGCR0_PROTS_SGMII,
+		.slew = 0b01,
+		.offset_override = 0b0011111,
+		.teq = LNmTECR0_TEQ_TYPE_PRE,
+		.postq_ratio = 0b00110,
+		.adpt_eq = 0b110000,
+		.amp_red = 0b000010,
+	},
+	[QS_PROTO_XFI] = {
+		.frate_khz = 5156250,
+		.rat_sel = LNmGCR0_RAT_SEL_DOUBLE,
+		.if20bit = true,
+		.prots = LNmGCR0_PROTS_XFI,
+		.slew = 0b01,
+		.baseline_wander = LNmRECR0_BASE_WAND_DEFAULT,
+		.offset_override = 0b1011111,
+		.teq = LNmTECR0_TEQ_TYPE_PRE,
+		.postq_ratio = 0b00011,
+		.adpt_eq = 0b110000,
+		.amp_red = 0b000111,
+	},
+	[QS_PROTO_10GKR] = {
+		.frate_khz = 5156250,
+		.rat_sel = LNmGCR0_RAT_SEL_DOUBLE,
+		.prots = LNmGCR0_PROTS_XFI,
+		.slew = 0b01,
+		.baseline_wander = LNmRECR0_BASE_WAND_DEFAULT,
+		.offset_override = 0b1011111,
+		.teq = LNmTECR0_TEQ_TYPE_BOTH,
+		.preq_ratio = 0b0011,
+		.postq_ratio = 0b01100,
+		.adpt_eq = 0b110000,
+	},
+};
+
+/**
+ * struct qs_mode - A single configuration of a protocol controller
+ * @protos: A bitmask of the &enum qs_protocol this mode supports
+ * @lanes: A bitbask of the lanes which will be used when this config is
+ *         selected
+ * @pccr: The number of the PCCR which contains this mode
+ * @idx: The index of the protocol controller. For example, SGMIIB would have
+ *       index 1.
+ * @cfg: The value to program into the controller to select this mode
+ *
+ * The serdes has multiple protocol controllers which can be each be selected
+ * independently. Depending on their configuration, they may use multiple lanes
+ * at once (e.g. AUI or PCIe x4). Additionally, multiple protocols may be
+ * supported by a single mode (XFI and 10GKR differ only in their protocol
+ * parameters).
+ */
+struct qs_mode {
+	u16 protos;
+	u8 lanes;
+	u8 pccr;
+	u8 idx;
+	u8 cfg;
+};
+
+static_assert(QS_PROTO_LAST - 1 <=
+	      sizeof_field(struct qs_mode, protos) * BITS_PER_BYTE);
+static_assert(MAX_LANES <=
+	      sizeof_field(struct qs_mode, lanes) * BITS_PER_BYTE);
+
+#define CONF(_lanes, _protos, _pccr, _idx, _cfg) { \
+	.lanes = _lanes, \
+	.protos = _protos, \
+	.pccr = _pccr, \
+	.idx = _idx, \
+	.cfg = _cfg, \
+}
+
+#define CONF_SINGLE(lane, proto, pccr, idx, cfg) \
+	CONF(BIT(lane), PROTO_MASK(proto), pccr, idx, cfg)
+
+#define CONF_1000BASEKX(lane, pccr, idx, cfg) \
+	CONF(BIT(lane), PROTO_MASK(SGMII) | PROTO_MASK(1000BASEKX), \
+	     pccr, idx, cfg)
+
+#define CONF_SGMII25(lane, pccr, idx, cfg) \
+	CONF(BIT(lane), PROTO_MASK(SGMII) | PROTO_MASK(SGMII25), \
+	     pccr, idx, cfg)
+
+#define CONF_SGMII25KX(lane, pccr, idx, cfg) \
+	CONF(BIT(lane), \
+	     PROTO_MASK(SGMII) | PROTO_MASK(1000BASEKX) | PROTO_MASK(SGMII25), \
+	     pccr, idx, cfg)
+
+#define CONF_XFI(lane, pccr, idx, cfg) \
+	CONF(BIT(lane), PROTO_MASK(XFI) | PROTO_MASK(10GKR), pccr, idx, cfg)
+
+/**
+ * struct qs_conf - Configuration for a particular serdes
+ * @modes: Valid protocol controller configurations
+ * @mode_count: Number of modes in @modes
+ * @lanes: Number of lanes
+ * @endian: Endianness of the registers
+ */
+struct qs_conf {
+	const struct qs_mode *modes;
+	size_t mode_count;
+	unsigned int lanes;
+	enum regmap_endian endian;
+};
+
+struct qs_priv;
+
+/**
+ * struct qs_clk - Driver data for the PLLs
+ * @hw: The clock hardware
+ * @serdes: The parent serdes
+ * @idx: Which PLL this clock is for
+ */
+struct qs_clk {
+	struct clk_hw hw;
+	struct qs_priv *serdes;
+	unsigned int idx;
+};
+
+struct qs_clk *qs_clk_hw_to_priv(struct clk_hw *hw)
+{
+	return container_of(hw, struct qs_clk, hw);
+}
+
+/**
+ * struct qs_priv - Driver data for the serdes
+ * @lock: A lock protecting "common" registers in @regmap, as well as the
+ *        members of this struct. Lane-specific registers are protected by the
+ *        phy's lock. PLL registers are protected by the clock's lock.
+ * @pll: The PLL clocks
+ * @ref: The reference clocks for the PLLs
+ * @dev: The serdes device
+ * @regmap: The backing regmap
+ * @conf: The configuration for this serdes
+ * @used_lanes: Bitmap of the lanes currently used by phys
+ * @groups: List of the created groups
+ */
+struct qs_priv {
+	struct mutex lock;
+	struct qs_clk pll[2];
+	struct clk *ref[2];
+	struct device *dev;
+	struct regmap *regmap;
+	const struct qs_conf *conf;
+	unsigned int used_lanes;
+	struct list_head groups;
+};
+
+/**
+ * struct qs_group - Driver data for a group of lanes
+ * @groups: List of other groups; protected by @serdes->lock.
+ * @phy: The associated phy
+ * @serdes: The parent serdes
+ * @pll: The currently-used pll
+ * @first_lane: The first lane in the group
+ * @last_lane: The last lane in the group
+ * @proto: The currently-configured protocol
+ * @users: Number of current users; protected by @serdes->lock.
+ */
+struct qs_group {
+	struct list_head groups;
+	struct phy *phy;
+	struct qs_priv *serdes;
+	struct clk *pll;
+	unsigned int first_lane;
+	unsigned int last_lane;
+	enum qs_protocol proto;
+	unsigned int users;
+};
+
+static u32 qs_read(struct qs_priv *serdes, u32 reg)
+{
+	unsigned int ret = 0;
+
+	WARN_ON_ONCE(regmap_read(serdes->regmap, reg, &ret));
+	return ret;
+}
+
+static void qs_write(struct qs_priv *serdes, u32 val, u32 reg)
+{
+	WARN_ON_ONCE(regmap_write(serdes->regmap, reg, val));
+}
+
+/* XXX: The output rate is in kHz to avoid overflow on 32-bit arches */
+
+static void qs_pll_disable(struct clk_hw *hw)
+{
+	struct qs_clk *clk = qs_clk_hw_to_priv(hw);
+	struct qs_priv *serdes = clk->serdes;
+	u32 rstctl = qs_read(serdes, PLLaRSTCTL(clk->idx));
+
+	dev_dbg(clk->serdes->dev, "%s(pll%d)\n", __func__, clk->idx);
+
+	rstctl &= ~PLLaRSTCTL_SDRST_B;
+	qs_write(serdes, rstctl, PLLaRSTCTL(clk->idx));
+	ndelay(50);
+	rstctl &= ~(PLLaRSTCTL_SDEN | PLLaRSTCTL_PLLRST_B);
+	qs_write(serdes, rstctl, PLLaRSTCTL(clk->idx));
+	ndelay(100);
+}
+
+static int qs_pll_enable(struct clk_hw *hw)
+{
+	struct qs_clk *clk = qs_clk_hw_to_priv(hw);
+	struct qs_priv *serdes = clk->serdes;
+	u32 rstctl = qs_read(serdes, PLLaRSTCTL(clk->idx));
+
+	dev_dbg(clk->serdes->dev, "%s(pll%d)\n", __func__, clk->idx);
+
+	rstctl |= PLLaRSTCTL_RSTREQ;
+	qs_write(serdes, rstctl, PLLaRSTCTL(clk->idx));
+
+	rstctl &= ~PLLaRSTCTL_RSTREQ;
+	rstctl |= PLLaRSTCTL_SDEN | PLLaRSTCTL_PLLRST_B | PLLaRSTCTL_SDRST_B;
+	qs_write(serdes, rstctl, PLLaRSTCTL(clk->idx));
+
+	/* TODO: wait for the PLL to lock */
+
+	return 0;
+}
+
+static int qs_pll_is_enabled(struct clk_hw *hw)
+{
+	struct qs_clk *clk = qs_clk_hw_to_priv(hw);
+	struct qs_priv *serdes = clk->serdes;
+	u32 rstctl = qs_read(serdes, PLLaRSTCTL(clk->idx));
+
+	dev_dbg(clk->serdes->dev, "%s(pll%d)\n", __func__, clk->idx);
+
+	return rstctl & PLLaRSTCTL_RST_DONE && !(rstctl & PLLaRSTCTL_RST_ERR);
+}
+
+static const u32 rfclk_sel_map[8] = {
+	[0b000] = 100000000,
+	[0b001] = 125000000,
+	[0b010] = 156250000,
+	[0b011] = 150000000,
+};
+
+/**
+ * qs_rfclk_to_sel() - Convert a reference clock rate to a selector
+ * @rate: The reference clock rate
+ *
+ * To allow for some variation in the reference clock rate, up to 100ppm of
+ * error is allowed.
+ *
+ * Return: An appropriate selector for @rate, or -%EINVAL.
+ */
+static int qs_rfclk_to_sel(u32 rate)
+{
+	int ret;
+
+	for (ret = 0; ret < ARRAY_SIZE(rfclk_sel_map); ret++) {
+		u32 rfclk_rate = rfclk_sel_map[ret];
+		/* Allow an error of 100ppm */
+		u32 error = rfclk_rate / 10000;
+
+		if (rate > rfclk_rate - error && rate < rfclk_rate + error)
+			return ret;
+	}
+
+	return -EINVAL;
+}
+
+static const u32 frate_sel_map[16] = {
+	[0b0000] = 5000000,
+	[0b0101] = 3750000,
+	[0b0110] = 5156250,
+	[0b0111] = 4000000,
+	[0b1001] = 3125000,
+	[0b1010] = 3000000,
+};
+
+/**
+ * qs_frate_to_sel() - Convert a VCO clock rate to a selector
+ * @rate_khz: The VCO frequency, in kHz
+ *
+ * Return: An appropriate selector for @rate_khz, or -%EINVAL.
+ */
+static int qs_frate_to_sel(u32 rate_khz)
+{
+	int ret;
+
+	for (ret = 0; ret < ARRAY_SIZE(frate_sel_map); ret++)
+		if (frate_sel_map[ret] == rate_khz)
+			return ret;
+
+	return -EINVAL;
+}
+
+static u32 qs_pll_ratio(u32 frate_sel, u32 rfclk_sel)
+{
+	u64 frate;
+	u32 rfclk, error, ratio;
+
+	frate = frate_sel_map[frate_sel] * (u64)HZ_PER_KHZ;
+	rfclk = rfclk_sel_map[rfclk_sel];
+
+	if (!frate || !rfclk)
+		return 0;
+
+	ratio = div_u64_rem(frate, rfclk, &error);
+	if (!error)
+		return ratio;
+	return 0;
+}
+
+static unsigned long qs_pll_recalc_rate(struct clk_hw *hw,
+					unsigned long parent_rate)
+{
+	struct qs_clk *clk = qs_clk_hw_to_priv(hw);
+	struct qs_priv *serdes = clk->serdes;
+	u32 cr0 = qs_read(serdes, PLLaCR0(clk->idx));
+	u32 frate_sel = FIELD_GET(PLLaCR0_FRATE_SEL, cr0);
+	u32 rfclk_sel = FIELD_GET(PLLaCR0_RFCLK_SEL, cr0);
+	unsigned long ret;
+
+	dev_dbg(clk->serdes->dev, "%s(pll%d, %lu)\n", __func__,
+		clk->idx, parent_rate);
+
+	ret = mult_frac(parent_rate, qs_pll_ratio(frate_sel, rfclk_sel),
+			 HZ_PER_KHZ);
+	return ret;
+}
+
+static long qs_pll_round_rate(struct clk_hw *hw, unsigned long rate_khz,
+			      unsigned long *parent_rate)
+{
+	int frate_sel, rfclk_sel;
+	struct qs_clk *clk = qs_clk_hw_to_priv(hw);
+	u32 ratio;
+
+	dev_dbg(clk->serdes->dev, "%s(pll%d, %lu, %lu)\n", __func__,
+		clk->idx, rate_khz, *parent_rate);
+
+	frate_sel = qs_frate_to_sel(rate_khz);
+	if (frate_sel < 0)
+		return frate_sel;
+
+	rfclk_sel = qs_rfclk_to_sel(*parent_rate);
+	if (rfclk_sel >= 0) {
+		ratio = qs_pll_ratio(frate_sel, rfclk_sel);
+		if (ratio)
+			return mult_frac(*parent_rate, ratio, HZ_PER_KHZ);
+	}
+
+	for (rfclk_sel = 0;
+	     rfclk_sel < ARRAY_SIZE(rfclk_sel_map);
+	     rfclk_sel++) {
+		ratio = qs_pll_ratio(frate_sel, rfclk_sel);
+		if (ratio) {
+			*parent_rate = rfclk_sel_map[rfclk_sel];
+			return mult_frac(*parent_rate, ratio, HZ_PER_KHZ);
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int qs_pll_set_rate(struct clk_hw *hw, unsigned long rate_khz,
+			   unsigned long parent_rate)
+{
+	int frate_sel, rfclk_sel, ret;
+	struct qs_clk *clk = qs_clk_hw_to_priv(hw);
+	struct qs_priv *serdes = clk->serdes;
+	u32 ratio, cr0 = qs_read(serdes, PLLaCR0(clk->idx));
+
+	dev_dbg(clk->serdes->dev, "%s(pll%d, %lu, %lu)\n", __func__,
+		clk->idx, rate_khz, parent_rate);
+
+	frate_sel = qs_frate_to_sel(rate_khz);
+	if (frate_sel < 0)
+		return frate_sel;
+
+	/* First try the existing rate */
+	rfclk_sel = qs_rfclk_to_sel(parent_rate);
+	if (rfclk_sel >= 0) {
+		ratio = qs_pll_ratio(frate_sel, rfclk_sel);
+		if (ratio)
+			goto got_rfclk;
+	}
+
+	for (rfclk_sel = 0;
+	     rfclk_sel < ARRAY_SIZE(rfclk_sel_map);
+	     rfclk_sel++) {
+		ratio = qs_pll_ratio(frate_sel, rfclk_sel);
+		if (ratio) {
+			ret = clk_set_rate(serdes->ref[clk->idx],
+					   rfclk_sel_map[rfclk_sel]);
+			if (!ret)
+				goto got_rfclk;
+		}
+	}
+
+	return ret;
+
+got_rfclk:
+	cr0 &= ~(PLLaCR0_RFCLK_SEL | PLLaCR0_FRATE_SEL);
+	cr0 |= FIELD_PREP(PLLaCR0_RFCLK_SEL, rfclk_sel);
+	cr0 |= FIELD_PREP(PLLaCR0_FRATE_SEL, frate_sel);
+	qs_write(serdes, cr0, PLLaCR0(clk->idx));
+	return 0;
+}
+
+static const struct clk_ops qs_pll_clk_ops = {
+	.enable = qs_pll_enable,
+	.disable = qs_pll_disable,
+	.is_enabled = qs_pll_is_enabled,
+	.recalc_rate = qs_pll_recalc_rate,
+	.round_rate = qs_pll_round_rate,
+	.set_rate = qs_pll_set_rate,
+};
+
+/**
+ * qs_lane_bitmap() - Get a bitmap for a group of lanes
+ * @group: The group of lanes
+ *
+ * Return: A mask containing all bits between @group->first and @group->last
+ */
+static unsigned int qs_lane_bitmap(struct qs_group *group)
+{
+	if (group->first_lane > group->last_lane)
+		return GENMASK(group->first_lane, group->last_lane);
+	else
+		return GENMASK(group->last_lane, group->first_lane);
+}
+
+static int qs_init(struct phy *phy)
+{
+	int ret = 0;
+	struct qs_group *group = phy_get_drvdata(phy);
+	struct qs_priv *serdes = group->serdes;
+	unsigned int lane_mask = qs_lane_bitmap(group);
+
+	mutex_lock(&serdes->lock);
+	if (serdes->used_lanes & lane_mask)
+		ret = -EBUSY;
+	else
+		serdes->used_lanes |= lane_mask;
+	mutex_unlock(&serdes->lock);
+	return ret;
+}
+
+static int qs_exit(struct phy *phy)
+{
+	struct qs_group *group = phy_get_drvdata(phy);
+	struct qs_priv *serdes = group->serdes;
+
+	clk_disable_unprepare(group->pll);
+	clk_rate_exclusive_put(group->pll);
+	mutex_lock(&serdes->lock);
+	serdes->used_lanes &= ~qs_lane_bitmap(group);
+	mutex_unlock(&serdes->lock);
+	return 0;
+}
+
+/*
+ * This is tricky. If first_lane=1 and last_lane=0, the condition will see 2,
+ * 1, 0. But the loop body will see 1, 0. We do this to avoid underflow. We
+ * can't pull the same trick when incrementing, because then we might have to
+ * start at -1 if (e.g.) first_lane = 0.
+ */
+#define for_range(val, start, end) \
+	for (val = start < end ? start : start + 1; \
+	     start < end ? val <= end : val-- > end; \
+	     start < end ? val++ : 0)
+#define for_each_lane(lane, group) \
+	for_range(lane, group->first_lane, group->last_lane)
+#define for_each_lane_reverse(lane, group) \
+	for_range(lane, group->last_lane, group->first_lane)
+
+static int qs_power_on(struct phy *phy)
+{
+	int i;
+	struct qs_group *group = phy_get_drvdata(phy);
+	u32 gcr0;
+
+	for_each_lane(i, group) {
+		gcr0 = qs_read(group->serdes, LNmGCR0(i));
+		gcr0 &= ~(LNmGCR0_RX_PD | LNmGCR0_TX_PD);
+		qs_write(group->serdes, gcr0, LNmGCR0(i));
+
+		usleep_range(15, 30);
+		gcr0 |= LNmGCR0_RRST_B | LNmGCR0_TRST_B;
+		qs_write(group->serdes, gcr0, LNmGCR0(i));
+	}
+
+	return 0;
+}
+
+static int qs_power_off(struct phy *phy)
+{
+	int i;
+	struct qs_group *group = phy_get_drvdata(phy);
+	u32 gcr0;
+
+	for_each_lane_reverse(i, group) {
+		gcr0 = qs_read(group->serdes, LNmGCR0(i));
+		gcr0 |= LNmGCR0_RX_PD | LNmGCR0_TX_PD;
+		gcr0 &= ~(LNmGCR0_RRST_B | LNmGCR0_TRST_B);
+		qs_write(group->serdes, gcr0, LNmGCR0(i));
+	}
+
+	return 0;
+}
+
+/**
+ * qs_lookup_proto() - Convert a phy-subsystem mode to a protocol
+ * @mode: The mode to convert
+ * @submode: The submode of @mode
+ *
+ * Return: A corresponding serdes-specific mode
+ */
+static enum qs_protocol qs_lookup_proto(enum phy_mode mode, int submode)
+{
+	switch (mode) {
+	case PHY_MODE_ETHERNET:
+		switch (submode) {
+		case PHY_INTERFACE_MODE_SGMII:
+		case PHY_INTERFACE_MODE_1000BASEX:
+			return QS_PROTO_SGMII;
+		case PHY_INTERFACE_MODE_2500BASEX:
+			return QS_PROTO_SGMII;
+		case PHY_INTERFACE_MODE_QSGMII:
+			return QS_PROTO_QSGMII;
+		case PHY_INTERFACE_MODE_XGMII:
+		case PHY_INTERFACE_MODE_10GBASER:
+			return QS_PROTO_XFI;
+		case PHY_INTERFACE_MODE_10GKR:
+			return QS_PROTO_10GKR;
+		default:
+			return QS_PROTO_UNKNOWN;
+		}
+	/* Not implemented (yet) */
+	case PHY_MODE_PCIE:
+	case PHY_MODE_SATA:
+	default:
+		return QS_PROTO_UNKNOWN;
+	}
+}
+
+/**
+ * qs_lookup_mode() - Get the mode for a group/protocol combination
+ * @group: The group of lanes to use
+ * @proto: The protocol to use
+ *
+ * Return: An appropriate mode to use, or %NULL if none match.
+ */
+static const struct qs_mode *qs_lookup_mode(struct qs_group *group,
+					    enum qs_protocol proto)
+{
+	int i;
+	const struct qs_conf *conf = group->serdes->conf;
+
+	for (i = 0; i < conf->mode_count; i++) {
+		const struct qs_mode *mode = &conf->modes[i];
+
+		if (BIT(proto) & mode->protos &&
+		    qs_lane_bitmap(group) == mode->lanes)
+			return mode;
+	}
+
+	return NULL;
+}
+
+static int qs_validate(struct phy *phy, enum phy_mode phy_mode, int submode,
+		       union phy_configure_opts *opts)
+{
+	enum qs_protocol proto;
+	struct qs_group *group = phy_get_drvdata(phy);
+	const struct qs_mode *mode;
+
+	proto = qs_lookup_proto(phy_mode, submode);
+	if (proto == QS_PROTO_UNKNOWN)
+		return -EINVAL;
+
+	/* Nothing to do */
+	if (proto == group->proto)
+		return 0;
+
+	mode = qs_lookup_mode(group, proto);
+	if (!mode)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * qs_proto_mode_mask() - Get the mask for a PCCR config
+ * @mode: The mode to use
+ *
+ * Return: The mask, shifted down to the lsb.
+ */
+static u32 qs_proto_mode_mask(const struct qs_mode *mode)
+{
+	switch (mode->pccr) {
+	case 0x0:
+		if (mode->protos & PROTO_MASK(PCIE))
+			return PCCR0_PEXa_MASK;
+		break;
+	case 0x2:
+		if (mode->protos & PROTO_MASK(SATA))
+			return PCCR2_SATAa_MASK;
+		break;
+	case 0x8:
+		if (mode->protos & PROTO_MASK(SGMII))
+			return PCCR8_SGMIIa_MASK;
+		break;
+	case 0x9:
+		if (mode->protos & PROTO_MASK(QSGMII))
+			return PCCR9_QSGMIIa_MASK;
+		break;
+	case 0xB:
+		if (mode->protos & PROTO_MASK(XFI))
+			return PCCRB_XFIa_MASK;
+		break;
+	}
+	pr_debug("unknown mode PCCR%X %s%c\n", mode->pccr,
+		 qs_proto_str[mode->protos], 'A' + mode->idx);
+	return 0;
+}
+
+/**
+ * qs_proto_mode_shift() - Get the shift for a PCCR config
+ * @mode: The mode to use
+ *
+ * Return: The amount of bits to shift the mask.
+ */
+static u32 qs_proto_mode_shift(const struct qs_mode *mode)
+{
+	switch (mode->pccr) {
+	case 0x0:
+		if (mode->protos & PROTO_MASK(PCIE))
+			return PCCR0_PEXa_SHIFT(mode->idx);
+		break;
+	case 0x2:
+		if (mode->protos & PROTO_MASK(SATA))
+			return PCCR2_SATAa_SHIFT(mode->idx);
+		break;
+	case 0x8:
+		if (mode->protos & PROTO_MASK(SGMII))
+			return PCCR8_SGMIIa_SHIFT(mode->idx);
+		break;
+	case 0x9:
+		if (mode->protos & PROTO_MASK(QSGMII))
+			return PCCR9_QSGMIIa_SHIFT(mode->idx);
+		break;
+	case 0xB:
+		if (mode->protos & PROTO_MASK(XFI))
+			return PCCRB_XFIa_SHIFT(mode->idx);
+		break;
+	}
+	pr_debug("unknown mode PCCR%X %s%c\n", mode->pccr,
+		 qs_proto_str[mode->protos], 'A' + mode->idx);
+	return 0;
+}
+
+/**
+ * qs_proto_mode_get() - Get the current config for a PCCR mode
+ * @mode: The mode to use
+ * @pccr: The current value of the PCCR
+ *
+ * Return: The current value of the PCCR config for this mode
+ */
+static u32 qs_proto_mode_get(const struct qs_mode *mode, u32 pccr)
+{
+	return (pccr >> qs_proto_mode_shift(mode)) & qs_proto_mode_mask(mode);
+}
+
+/**
+ * qs_proto_mode_prep() - Configure a PCCR for a mode
+ * @mode: The mode to configure
+ * @pccr: The current value of the PCCR
+ * @cfg: The config to program
+ *
+ * Return: The new value for the PCCR
+ */
+static u32 qs_proto_mode_prep(const struct qs_mode *mode, u32 pccr, u32 cfg)
+{
+	u32 shift = qs_proto_mode_shift(mode);
+
+	pccr &= ~(qs_proto_mode_mask(mode) << shift);
+	return pccr | cfg << shift;
+}
+
+#define abs_diff(a, b) ({ \
+	typeof(a) _a = (a); \
+	typeof(b) _b = (b); \
+	_a > _b ? _a - _b : _b - _a; \
+})
+
+static int qs_set_mode(struct phy *phy, enum phy_mode phy_mode, int submode)
+{
+	enum qs_protocol proto;
+	const struct qs_proto_params *params;
+	const struct qs_mode *old_mode = NULL, *new_mode;
+	int i, pll, ret;
+	struct qs_group *group = phy_get_drvdata(phy);
+	struct qs_priv *serdes = group->serdes;
+	u32 mask, tmp;
+	u32 gcr0 = 0, gcr1 = 0, recr0 = 0, tecr0 = 0;
+	u32 gcr0_mask = 0, gcr1_mask = 0, recr0_mask = 0, tecr0_mask = 0;
+
+	proto = qs_lookup_proto(phy_mode, submode);
+	if (proto == QS_PROTO_UNKNOWN) {
+		dev_dbg(&phy->dev, "unknown mode/submode %d/%d\n",
+			phy_mode, submode);
+		return -EINVAL;
+	}
+
+	/* Nothing to do */
+	if (proto == group->proto)
+		return 0;
+
+	new_mode = qs_lookup_mode(group, proto);
+	if (!new_mode) {
+		dev_dbg(&phy->dev, "could not find mode for %s on lanes %u to %u\n",
+			qs_proto_str[proto], group->first_lane,
+			group->last_lane);
+		return -EINVAL;
+	}
+
+	if (group->proto != QS_PROTO_UNKNOWN) {
+		old_mode = qs_lookup_mode(group, group->proto);
+		if (!old_mode) {
+			dev_err(&phy->dev, "could not find mode for %s\n",
+				qs_proto_str[group->proto]);
+			return -EBUSY;
+		}
+	}
+
+	clk_disable_unprepare(group->pll);
+	clk_rate_exclusive_put(group->pll);
+	group->pll = NULL;
+
+	/* First, try to use a PLL which already has the correct rate */
+	params = &qs_proto_params[proto];
+	for (pll = 0; pll < ARRAY_SIZE(serdes->pll); pll++) {
+		struct clk *clk = serdes->pll[pll].hw.clk;
+		unsigned long rate = clk_get_rate(clk);
+		unsigned long error = abs_diff(rate, params->frate_khz);
+
+		dev_dbg(&phy->dev, "pll%d has rate %lu\n", pll, rate);
+		/* Accept up to 100ppm deviation */
+		if ((!error || params->frate_khz / error > 10000) &&
+		    !clk_set_rate_exclusive(clk, rate))
+			goto got_pll;
+		/* Someone else got a different rate first */
+	}
+
+	/* If neither PLL has the right rate, try setting it */
+	for (pll = 0; pll < 2; pll++) {
+		ret = clk_set_rate_exclusive(serdes->pll[pll].hw.clk,
+					     params->frate_khz);
+		if (!ret)
+			goto got_pll;
+	}
+
+	dev_dbg(&phy->dev, "could not get a pll at %ukHz\n",
+		params->frate_khz);
+	return ret;
+
+got_pll:
+	group->pll = serdes->pll[pll].hw.clk;
+	clk_prepare_enable(group->pll);
+
+	gcr0_mask |= LNmGCR0_RRAT_SEL | LNmGCR0_TRAT_SEL;
+	gcr0_mask |= LNmGCR0_RPLL_LES | LNmGCR0_TPLL_LES;
+	gcr0_mask |= LNmGCR0_RRST_B | LNmGCR0_TRST_B;
+	gcr0_mask |= LNmGCR0_RX_PD | LNmGCR0_TX_PD;
+	gcr0_mask |= LNmGCR0_IF20BIT_EN | LNmGCR0_PROTS;
+	gcr0 |= FIELD_PREP(LNmGCR0_RPLL_LES, !pll);
+	gcr0 |= FIELD_PREP(LNmGCR0_TPLL_LES, !pll);
+	gcr0 |= FIELD_PREP(LNmGCR0_RRAT_SEL, params->rat_sel);
+	gcr0 |= FIELD_PREP(LNmGCR0_TRAT_SEL, params->rat_sel);
+	gcr0 |= FIELD_PREP(LNmGCR0_IF20BIT_EN, params->if20bit);
+	gcr0 |= FIELD_PREP(LNmGCR0_PROTS, params->prots);
+
+	gcr1_mask |= LNmGCR1_RDAT_INV | LNmGCR1_TDAT_INV;
+	gcr1_mask |= LNmGCR1_OPAD_CTL | LNmGCR1_REIDL_TH;
+	gcr1_mask |= LNmGCR1_REIDL_EX_SEL | LNmGCR1_REIDL_ET_SEL;
+	gcr1_mask |= LNmGCR1_REIDL_EX_MSB | LNmGCR1_REIDL_ET_MSB;
+	gcr1_mask |= LNmGCR1_REQ_CTL_SNP | LNmGCR1_REQ_CDR_SNP;
+	gcr1_mask |= LNmGCR1_TRSTDIR | LNmGCR1_REQ_BIN_SNP;
+	gcr1_mask |= LNmGCR1_ISLEW_RCTL | LNmGCR1_OSLEW_RCTL;
+	gcr1 |= FIELD_PREP(LNmGCR1_REIDL_TH, params->reidl_th);
+	gcr1 |= FIELD_PREP(LNmGCR1_REIDL_EX_SEL, params->reidl_ex & 3);
+	gcr1 |= FIELD_PREP(LNmGCR1_REIDL_ET_SEL, params->reidl_et & 3);
+	gcr1 |= FIELD_PREP(LNmGCR1_REIDL_EX_MSB, params->reidl_ex >> 2);
+	gcr1 |= FIELD_PREP(LNmGCR1_REIDL_ET_MSB, params->reidl_et >> 2);
+	gcr1 |= FIELD_PREP(LNmGCR1_TRSTDIR,
+			   group->first_lane > group->last_lane);
+	gcr1 |= FIELD_PREP(LNmGCR1_ISLEW_RCTL, params->slew);
+	gcr1 |= FIELD_PREP(LNmGCR1_OSLEW_RCTL, params->slew);
+
+	recr0_mask |= LNmRECR0_GK2OVD | LNmRECR0_GK3OVD;
+	recr0_mask |= LNmRECR0_GK2OVD_EN | LNmRECR0_GK3OVD_EN;
+	recr0_mask |= LNmRECR0_BASE_WAND | LNmRECR0_OSETOVD;
+	if (params->gain) {
+		recr0 |= FIELD_PREP(LNmRECR0_GK2OVD, params->gain);
+		recr0 |= FIELD_PREP(LNmRECR0_GK3OVD, params->gain);
+		recr0 |= LNmRECR0_GK2OVD_EN | LNmRECR0_GK3OVD_EN;
+	}
+	recr0 |= FIELD_PREP(LNmRECR0_BASE_WAND, params->baseline_wander);
+	recr0 |= FIELD_PREP(LNmRECR0_OSETOVD, params->offset_override);
+
+	tecr0_mask |= LNmTECR0_TEQ_TYPE;
+	tecr0_mask |= LNmTECR0_SGN_PREQ | LNmTECR0_RATIO_PREQ;
+	tecr0_mask |= LNmTECR0_SGN_POST1Q | LNmTECR0_RATIO_PST1Q;
+	tecr0_mask |= LNmTECR0_ADPT_EQ | LNmTECR0_AMP_RED;
+	tecr0 |= FIELD_PREP(LNmTECR0_TEQ_TYPE, params->teq);
+	if (params->preq_ratio) {
+		tecr0 |= FIELD_PREP(LNmTECR0_SGN_PREQ, 1);
+		tecr0 |= FIELD_PREP(LNmTECR0_RATIO_PREQ, params->preq_ratio);
+	}
+	if (params->postq_ratio) {
+		tecr0 |= FIELD_PREP(LNmTECR0_SGN_POST1Q, 1);
+		tecr0 |= FIELD_PREP(LNmTECR0_RATIO_PST1Q, params->postq_ratio);
+	}
+	tecr0 |= FIELD_PREP(LNmTECR0_ADPT_EQ, params->adpt_eq);
+	tecr0 |= FIELD_PREP(LNmTECR0_AMP_RED, params->amp_red);
+
+	mutex_lock(&serdes->lock);
+
+	/* Disable the old controller */
+	if (old_mode) {
+		tmp = qs_read(serdes, PCCRn(old_mode->pccr));
+		tmp = qs_proto_mode_prep(old_mode, tmp, 0);
+		qs_write(serdes, tmp, PCCRn(old_mode->pccr));
+
+		if (old_mode->protos & PROTO_MASK(SGMII)) {
+			tmp = qs_read(serdes, SGMIIaCR1(old_mode->idx));
+			tmp &= SGMIIaCR1_SGPCS_EN;
+			qs_write(serdes, tmp, SGMIIaCR1(old_mode->idx));
+		}
+	}
+
+	for_each_lane_reverse(i, group) {
+		tmp = qs_read(serdes, LNmGCR0(i));
+		tmp &= ~(LNmGCR0_RRST_B | LNmGCR0_TRST_B);
+		qs_write(serdes, tmp, LNmGCR0(i));
+		ndelay(50);
+
+		tmp &= ~gcr0_mask;
+		tmp |= gcr0;
+		tmp |= FIELD_PREP(LNmGCR0_FIRST_LANE, i == group->first_lane);
+		qs_write(serdes, tmp, LNmGCR0(i));
+
+		tmp = qs_read(serdes, LNmGCR1(i));
+		tmp &= ~gcr1_mask;
+		tmp |= gcr1;
+		qs_write(serdes, tmp, LNmGCR1(i));
+
+		tmp = qs_read(serdes, LNmRECR0(i));
+		tmp &= ~recr0_mask;
+		tmp |= recr0;
+		qs_write(serdes, tmp, LNmRECR0(i));
+
+		tmp = qs_read(serdes, LNmTECR0(i));
+		tmp &= ~tecr0_mask;
+		tmp |= tecr0;
+		qs_write(serdes, tmp, LNmTECR0(i));
+
+		tmp = qs_read(serdes, LNmTTLCR0(i));
+		tmp &= ~LNmTTLCR0_FLT_SEL;
+		tmp |= FIELD_PREP(LNmTTLCR0_FLT_SEL, params->flt_sel);
+		qs_write(serdes, tmp, LNmTTLCR0(i));
+
+		ndelay(120);
+		tmp = qs_read(serdes, LNmGCR0(i));
+		tmp |= LNmGCR0_RRST_B | LNmGCR0_TRST_B;
+		qs_write(serdes, tmp, LNmGCR0(i));
+	}
+
+	if (proto == QS_PROTO_1000BASEKX) {
+		/* FIXME: this races with clock updates */
+		tmp = qs_read(serdes, PLLaCR0(pll));
+		tmp &= ~PLLaCR0_DLYDIV_SEL;
+		tmp |= FIELD_PREP(PLLaCR0_DLYDIV_SEL, 1);
+		qs_write(serdes, tmp, PLLaCR0(pll));
+	}
+
+	/* Enable the new controller */
+	tmp = qs_read(serdes, PCCRn(new_mode->pccr));
+	tmp = qs_proto_mode_prep(new_mode, tmp, new_mode->cfg);
+	if (new_mode->protos & PROTO_MASK(1000BASEKX)) {
+		if (new_mode->pccr == 8) {
+			mask = PCCR8_SGMIIa_KX(new_mode->idx);
+		} else {
+			dev_err(&phy->dev, "PCCR%X doesn't have a KX bit\n",
+				new_mode->pccr);
+			mask = 0;
+		}
+
+		if (proto == QS_PROTO_1000BASEKX)
+			tmp |= mask;
+		else
+			tmp &= ~mask;
+	}
+	qs_write(serdes, tmp, PCCRn(new_mode->pccr));
+
+	if (new_mode->protos & PROTO_MASK(SGMII)) {
+		tmp = qs_read(serdes, SGMIIaCR1(new_mode->idx));
+		tmp |= SGMIIaCR1_SGPCS_EN;
+		qs_write(serdes, tmp, SGMIIaCR1(new_mode->idx));
+	}
+
+	mutex_unlock(&serdes->lock);
+
+	group->proto = proto;
+	dev_dbg(&phy->dev, "set mode to %s on lanes %u to %u\n",
+		qs_proto_str[proto], group->first_lane, group->last_lane);
+	return 0;
+}
+
+static void qs_release(struct phy *phy)
+{
+	struct qs_group *group = phy_get_drvdata(phy);
+	struct qs_priv *serdes = group->serdes;
+
+	mutex_lock(&serdes->lock);
+	if (--group->users) {
+		mutex_unlock(&serdes->lock);
+		return;
+	}
+	list_del(&group->groups);
+	mutex_unlock(&serdes->lock);
+
+	phy_destroy(phy);
+	kfree(group);
+}
+
+static const struct phy_ops qs_phy_ops = {
+	.init = qs_init,
+	.exit = qs_exit,
+	.power_on = qs_power_on,
+	.power_off = qs_power_off,
+	.set_mode = qs_set_mode,
+	.validate = qs_validate,
+	.release = qs_release,
+	.owner = THIS_MODULE,
+};
+
+static struct phy *qs_xlate(struct device *dev, struct of_phandle_args *args)
+{
+	struct phy *phy;
+	struct list_head *head;
+	struct qs_group *group;
+	struct qs_priv *serdes = dev_get_drvdata(dev);
+
+	if (args->args_count != 2)
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&serdes->lock);
+
+	/* Look for an existing group */
+	list_for_each(head, &serdes->groups) {
+		group = container_of(head, struct qs_group, groups);
+		if (group->first_lane == args->args[0] &&
+		    group->last_lane == args->args[1]) {
+			group->users++;
+			return group->phy;
+		}
+	}
+
+	/* None found, create our own */
+	group = kzalloc(sizeof(*group), GFP_KERNEL);
+	if (!group) {
+		mutex_unlock(&serdes->lock);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	group->serdes = serdes;
+	group->first_lane = args->args[0];
+	group->last_lane = args->args[1];
+	group->users = 1;
+	phy = phy_create(dev, NULL, &qs_phy_ops);
+	if (IS_ERR(phy)) {
+		kfree(group);
+	} else {
+		group->phy = phy;
+		phy_set_drvdata(phy, group);
+		list_add(&group->groups, &serdes->groups);
+	}
+
+	mutex_unlock(&serdes->lock);
+	return phy;
+}
+
+static int qs_probe(struct platform_device *pdev)
+{
+	bool grabbed_clocks = false;
+	int i, ret;
+	struct device *dev = &pdev->dev;
+	struct qs_priv *serdes;
+	struct regmap_config regmap_config = {};
+	const struct qs_conf *conf;
+	struct resource *res;
+	void __iomem *base;
+
+	serdes = devm_kzalloc(dev, sizeof(*serdes), GFP_KERNEL);
+	if (!serdes)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, serdes);
+	mutex_init(&serdes->lock);
+	INIT_LIST_HEAD(&serdes->groups);
+	serdes->dev = dev;
+
+	base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
+	if (IS_ERR(base)) {
+		ret = PTR_ERR(base);
+		dev_err_probe(dev, ret, "could not get/map registers\n");
+		return ret;
+	}
+
+	conf = device_get_match_data(dev);
+	serdes->conf = conf;
+	regmap_config.reg_bits = 32;
+	regmap_config.reg_stride = 4;
+	regmap_config.val_bits = 32;
+	regmap_config.val_format_endian = conf->endian;
+	regmap_config.max_register = res->end - res->start;
+	regmap_config.disable_locking = true;
+	serdes->regmap = devm_regmap_init_mmio(dev, base, &regmap_config);
+	if (IS_ERR(serdes->regmap)) {
+		ret = PTR_ERR(serdes->regmap);
+		dev_err_probe(dev, ret, "could not create regmap\n");
+		return ret;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(serdes->ref); i++) {
+		static const char fmt[] = "ref%d";
+		char name[sizeof(fmt)];
+
+		snprintf(name, sizeof(name), fmt, i);
+		serdes->ref[i] = devm_clk_get(dev, name);
+		if (IS_ERR(serdes->ref[i])) {
+			ret = PTR_ERR(serdes->ref[i]);
+			dev_err_probe(dev, ret, "could not get %s\n", name);
+			return ret;
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(serdes->pll); i++) {
+		static const char fmt[] = "%s.pll%d";
+		char *name;
+		const struct clk_hw *ref_hw[] = {
+			__clk_get_hw(serdes->ref[i]),
+		};
+		size_t len;
+		struct clk_init_data init = {};
+
+		len = snprintf(NULL, 0, fmt, pdev->name, i);
+		name = devm_kzalloc(dev, len + 1, GFP_KERNEL);
+		if (!name)
+			return -ENOMEM;
+
+		snprintf(name, len + 1, fmt, pdev->name, i);
+		init.name = name;
+		init.ops = &qs_pll_clk_ops;
+		init.parent_hws = ref_hw;
+		init.num_parents = 1;
+		init.flags = CLK_SET_RATE_GATE | CLK_GET_RATE_NOCACHE;
+		init.flags |= CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE;
+
+		serdes->pll[i].hw.init = &init;
+		serdes->pll[i].serdes = serdes;
+		serdes->pll[i].idx = i;
+		ret = devm_clk_hw_register(dev, &serdes->pll[i].hw);
+		if (ret) {
+			dev_err_probe(dev, ret, "could not register %s\n",
+				      name);
+			return ret;
+		}
+	}
+
+	/* Deselect anything configured by the RCW/bootloader */
+	for (i = 0; i < conf->mode_count; i++) {
+		const struct qs_mode *mode = &conf->modes[i];
+		u32 pccr = qs_read(serdes, PCCRn(mode->pccr));
+
+		if (qs_proto_mode_get(mode, pccr) == mode->cfg) {
+			if (mode->protos & UNSUPPORTED_PROTOS) {
+				/* Don't mess with modes we don't support */
+				serdes->used_lanes |= mode->lanes;
+				if (grabbed_clocks)
+					continue;
+
+				grabbed_clocks = true;
+				clk_prepare_enable(serdes->pll[0].hw.clk);
+				clk_prepare_enable(serdes->pll[1].hw.clk);
+				clk_rate_exclusive_get(serdes->pll[0].hw.clk);
+				clk_rate_exclusive_get(serdes->pll[1].hw.clk);
+			} else {
+				/* Otherwise, clear out the existing config */
+				pccr = qs_proto_mode_prep(mode, pccr, 0);
+				qs_write(serdes, pccr, PCCRn(mode->pccr));
+			}
+		}
+	}
+
+	/* TODO: clear SGMIIaCR1 */
+
+	/* TODO: power off unused lanes */
+
+	ret = PTR_ERR_OR_ZERO(devm_of_phy_provider_register(dev, qs_xlate));
+	if (ret)
+		dev_err_probe(dev, ret, "could not register phy provider\n");
+	else
+		dev_info(dev, "probed with %d lanes\n", conf->lanes);
+	return ret;
+}
+
+/*
+ * XXX: For SerDes1, lane A uses pins SD1_RX3_P/N! That is, the lane numbers
+ * and pin numbers are _reversed_. In addition, the PCCR documentation is
+ * _inconsistent_ in its usage of these terms!
+ *
+ * PCCR "Lane 0" refers to...
+ * ==== =====================
+ *    0 Lane A
+ *    2 Lane A
+ *    8 Lane A
+ *    9 Lane A
+ *    B Lane D!
+ */
+static const struct qs_mode ls1046a_modes1[] = {
+	CONF_SINGLE(1, PCIE, 0x0, 1, 0b001), /* PCIe.1 */
+	CONF_1000BASEKX(0, 0x8, 0, 0b001), /* SGMII.6 */
+	CONF_SGMII25KX(1, 0x8, 1, 0b001), /* SGMII.5 */
+	CONF_SGMII25KX(2, 0x8, 2, 0b001), /* SGMII.10 */
+	CONF_SGMII25KX(3, 0x8, 3, 0b001), /* SGMII.9 */
+	CONF_SINGLE(1, QSGMII, 0x9, 2, 0b001), /* QSGMII.6,5,10,1 */
+	CONF_XFI(2, 0xB, 0, 0b010), /* XFI.10 */
+	CONF_XFI(3, 0xB, 1, 0b001), /* XFI.9 */
+};
+
+static const struct qs_conf ls1046a_conf1 = {
+	.modes = ls1046a_modes1,
+	.mode_count = ARRAY_SIZE(ls1046a_modes1),
+	.lanes = 4,
+	.endian = REGMAP_ENDIAN_BIG,
+};
+
+static const struct qs_mode ls1046a_modes2[] = {
+	CONF_SINGLE(0, PCIE, 0x0, 0, 0b001), /* PCIe.1 x1 */
+	CONF(GENMASK(3, 0), PROTO_MASK(PCIE), 0x0, 0, 0b011), /* PCIe.1 x4 */
+	CONF_SINGLE(2, PCIE, 0x0, 2, 0b001), /* PCIe.2 x1 */
+	CONF(GENMASK(3, 2), PROTO_MASK(PCIE), 0x0, 2, 0b010), /* PCIe.3 x2 */
+	CONF_SINGLE(3, PCIE, 0x0, 2, 0b011), /* PCIe.3 x1 */
+	CONF_SINGLE(3, SATA, 0x2, 0, 0b001), /* SATA */
+	CONF_1000BASEKX(1, 0x8, 1, 0b001), /* SGMII.2 */
+};
+
+static const struct qs_conf ls1046a_conf2 = {
+	.modes = ls1046a_modes2,
+	.mode_count = ARRAY_SIZE(ls1046a_modes2),
+	.lanes = 4,
+	.endian = REGMAP_ENDIAN_BIG,
+};
+
+static const struct of_device_id qs_of_match[] = {
+	{ .compatible = "fsl,ls1046a-serdes-1", .data = &ls1046a_conf1 },
+	{ .compatible = "fsl,ls1046a-serdes-2", .data = &ls1046a_conf2 },
+};
+MODULE_DEVICE_TABLE(of, qs_of_match);
+
+static struct platform_driver qs_driver = {
+	.probe = qs_probe,
+	.driver = {
+		.name = "qoriq_serdes",
+		.of_match_table = qs_of_match,
+	},
+};
+module_platform_driver(qs_driver);
+
+MODULE_AUTHOR("Sean Anderson <sean.anderson@seco.com>");
+MODULE_DESCRIPTION("QorIQ SerDes driver");
+MODULE_LICENSE("GPL");
-- 
2.35.1.1320.gc452695387.dirty

