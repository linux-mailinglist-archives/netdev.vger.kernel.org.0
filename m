Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728E258210D
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 09:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiG0H1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 03:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiG0H06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 03:26:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E003E75E;
        Wed, 27 Jul 2022 00:26:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhY2jAjr9fjByV84GSSfVxZczB1Z+/bhdRcTzgP7obZob5yhnW6xMnZ7Ay9v1idDRhuKnmZLEkPLhHgAomX4etBHzERJ+j1HBgl4vMnoxOfwmL8E8rsNTYN7kfX9hrIbQ+hLPDfaw2+/jpGwPFF727JW3yhDWn7VMDoehTKJ9Rp1ZYoIBoUQPIiNmEfiry0orspWmbjcGtxXAC51cH5/8RulzyTUxcy8lPf+ELMPFd9b0vVllkhf1Ndo5FUz6v+YlHQfjz2Iv/+uD6TSTqETByXdSW4tS0EB/hKZ/ZPYfwy8ZbighC6MTvWCEmUnQ/KokKfCk3U5NauBFJD+5P/8rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LTheYFQ8m4OeoeFCcAH043i/GUxTdNRCH7ww34cc/nw=;
 b=I6bORkNhaalLbyB6U01StVfbsUlzyoQizQL7tdSUiUii9/3MZbMJdk3uFn7YDrLMMcqrzcdF6TjNHLLHrUUtpksvz3I2TQ8qDkFw5bw78jlOjdU3xSx0pSLdUExMZNkFOM7PbCfRQnzWOJZQucEVLPASYwzzYWCRad278dM1wUT1+uSGe4MM/ITgfew09UrawK/HIL2dGtvBE27Gm6MbrwfpZhgMGd2kSc/XDcLWnfvifPwbyUp+e6ecIwh3VFsufjPbxsvAHg9wPee2XrwtpWM63WWEBdosQk6K9neoIJyO59GPdefQZsQ2JJiLqDzSoBsmIIyOvV2QJQ9Li0YL7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTheYFQ8m4OeoeFCcAH043i/GUxTdNRCH7ww34cc/nw=;
 b=BgHFvEDS5JCh7IsG3v1IGhCqzhkCsG4NA5D4Zt3HCK4ja5qEDov/zzT+d8dDhWpD571D+2zBpaVZc0qj4t8Egex9LCi00P/aZ10LebhJxrjryvJoS8wEbsmF5F/lCggeDeq/MkbHNFcDauUWQiWTTKCmQXyZkEiakWZ9oFvBVswuwb8I4az+d1Jiylsq+nqmXiR3ctxN1Z7/84lRxu9pmH4ruk40KN1AyglndktVBQdvzp320Oco29QK3bc4bIJ2HNqENOx5Rcz7T1oy3NRLfoR31Liv24xHrTSXUPvB3x//tkxKH0LFSDFZ9c9XAvn7V+z908OgO9wN+VJICdUuTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by BY5PR12MB4226.namprd12.prod.outlook.com (2603:10b6:a03:203::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Wed, 27 Jul
 2022 07:26:53 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282%3]) with mapi id 15.20.5417.023; Wed, 27 Jul 2022
 07:26:53 +0000
Date:   Wed, 27 Jul 2022 09:26:48 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v7 1/2] devlink: introduce framework for
 selftests
Message-ID: <YuDouKrha/a+0uDT@nanopsycho>
References: <20220727063719.35125-1-vikas.gupta@broadcom.com>
 <20220727063719.35125-2-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727063719.35125-2-vikas.gupta@broadcom.com>
X-ClientProxiedBy: FR3P281CA0107.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::17) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 665a6406-b024-4530-bbf4-08da6fa160c4
X-MS-TrafficTypeDiagnostic: BY5PR12MB4226:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LdRpb6G6RAGJwg3DGeBQefgNkwWEn3DuKi/PIaTT0Py0CJOZPrHDCiTQshTls1VkwHDiH8jlvAfw/JU3ZoCLnu5m8XU+Bc5htARa5Ckcm9hNI26kvuAY21hFCYKikQKuMhGu83/ygl0Yx8YYLFsCdFGqcN1p4PB/WCJe036xi4SIC0PmM9gxGiDh1rKtxNnnLNeAMRZQEDXaT6GKZ4SU7dsZH2CO5+F9o1i3vUT6N38d+zDQr+DoKxbUBQrwumCZg69rAxreNOafJJOyeOJ3ecEDifqJSUD+n6sYOtMu4A55TAQdz8b6J1Z0F8j+JY8NkyNQoqva5N17sPxoDHmrPY5XAgUY47x5qU1kk8jQiD4RwFytxpad+sdKfFwcFWYirzwuO/LjMgHtC7JsIdRk5T6qymEqknB1ZR8IHSjqFZTAL6NddCVw7aiQN2jtGeUudHOR1vKf1irIpbYzewGtrdLMn7r4WeknFY4QY4xazdclJtbgLi9+9VXWlhP83MbSN6unIANOBma9LKePkSbQjYp/XyGqUB4MXuynzK48WYduv4TZOCM7HrQ7BOOsUcoCL65XRuR6VplunfGEQcGEPfPSMUBo5q/eDKeLGPtJ53CP47wkxyrvXDUYcz9oW8188+Tbhrn8P1TufuTk5rr5abUlThJcrZ51Jp3C0mxHkm5lPZc02C9W4gis9YgG34oHDyTmlLd1WjrzoGTtGVct6Oh+zE3wK1xn7VesWMwbUE7GHPXhCKzhcnqcGjSIrvi7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(6486002)(41300700001)(186003)(26005)(6512007)(9686003)(6506007)(6666004)(478600001)(38100700002)(83380400001)(7416002)(4326008)(8936002)(30864003)(5660300002)(66476007)(8676002)(33716001)(2906002)(66556008)(6916009)(316002)(66946007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ATkx61sKgFjBUGgvn3GSkEXrbf+D4eTuKclheVXAMR3NnFDLRYR5XpvsdPc3?=
 =?us-ascii?Q?DbcM1A8U8jU+B/96ld7UPC5mRkjtv65Td+GeEUefRHSyXDCsLrQEnbtSkqqJ?=
 =?us-ascii?Q?sHWgSYbE84i8NorLOFK2I4RaVUBG+rcV1gPQJSUMDHEq7zX8sSTYZ68JDdWY?=
 =?us-ascii?Q?of6xMT2DyeTXcY+etCzmjXzlbXPtOu+fPrHqc9en3HjheHqny3qD6fc52YgY?=
 =?us-ascii?Q?j4BcHCtksHpwDDIVPOJm1O/pK/7s0B+6rkmOkoApuOVzyTOoL+4HgS6VArxQ?=
 =?us-ascii?Q?ZDHKN69UmzockKyuiC6ew/v1L/Xx+RLM+IcNJWOl3fCqZA/le6Nrnw2sh7Q3?=
 =?us-ascii?Q?ViWPNyQbJojwtxLjvR6HYPW1KfFn9Xbmbe2RIKzCN4F7FzC3GIVb1g2eB6jv?=
 =?us-ascii?Q?AKPirvm3jH7cAGKyWOk4otBAB7Q8w6PYESWkx72XVeLUdfs+cOx4JLlkZWBv?=
 =?us-ascii?Q?FW+1lLYguavG91+hzWODuBXhhYzed3hvJfnyTGI6+qPLqcFMXbNSYol41Drb?=
 =?us-ascii?Q?EtWrNMp4KxZ2MhvpxBrBN4Vz8fYttQPzo2ltqbfhYIaRiZyzQ0+5Wdl4uEIF?=
 =?us-ascii?Q?28Dj+rdmcRL8J1mwoBuv/0SbSYVwKK8aQ3L6m9KEW8nGPZRwit8XrQI2156f?=
 =?us-ascii?Q?rqJzqomXQzaFPuY1INkAGw37oiCCQ5Qd6RP1u1dU2cDnu8/nzFDNYfzA3Udg?=
 =?us-ascii?Q?j93KGyHfaGn3TzfxzL7Ek32l3pCOOObkJlEt7+CquGeIvYwTXk4Cd6i02j5D?=
 =?us-ascii?Q?LPJ3Ra3F/gDDWjffXqvUulSKvpEvw75tWfoLoTDDZNUDkXMOXxmw1Jk/bj3V?=
 =?us-ascii?Q?YK6mzmW3C1HZP/pFr5WIuctFEDX16ZdpjMZxo686aVZHH88NRAJl5O9Akboe?=
 =?us-ascii?Q?1exo1AS94L5DM27kMznQjbryegE7wvkM+lcPmDAZOFyG+x+/XrS6Bn1Tl+id?=
 =?us-ascii?Q?sY+HRCQcKD8nO4cFVXgVHAG1wBifD7PxEIE2l4FTDxahXQdyOo9D8NbwCE0N?=
 =?us-ascii?Q?kDrDNwjLKoA/moiEEM2ZILQMqPH3i7XyUr8aN/SKtD6IxuH3ex8a+MvYCr7J?=
 =?us-ascii?Q?5+ez0eBookU4oCk1xC5mSYfkWKq0SddUoskArRd6aPRZEsR5hdrLXX8a47/T?=
 =?us-ascii?Q?UIaqxRd75bYsa94yle/jUNSIfGPM0XbyGgl19SEU8VBLRnAOcOKAhVmHea0L?=
 =?us-ascii?Q?05XChveM1Lz/Jdryo6uszi6kLBBiILFOUp87Luq4zkVM01AnOsASfTMvDS9f?=
 =?us-ascii?Q?5skb6M0APIczSw6LHszVaO6cSU/ADVvdazbzxLwDTsvlTVem4RwARLAcoWew?=
 =?us-ascii?Q?mT+PN9fvlTK/b7SrGXowIecmgIsXrg2wPxPE+rCBWHbjya5ssylEKpgKl2MU?=
 =?us-ascii?Q?2cWi/YQ/S9Hcfg4ALjnYfkCabKt3uVHwsWSM7vaRGgXBhfJtU6geoEG3xK3o?=
 =?us-ascii?Q?RgVcMeE0bfaVir/3jsy3kRtmlbo04Pi2/njkCLI3Ex7LLvEEHWKfxSVNnZVM?=
 =?us-ascii?Q?LnHLx2jeOjS7aHDxaBQFT5Wp28pTlvOgyyIKEsiNRZzPAprdHmfqp22CFiBz?=
 =?us-ascii?Q?jIaUwYJo5nFF5aIGVevoAMY4YeyO9aiOeykbtnsh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 665a6406-b024-4530-bbf4-08da6fa160c4
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 07:26:53.3394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQL+wYvCrcnqgnh+nh2GfhgInccbhOeGev8dajYxD1To7cZ9nxMEX2Wui7GXqROg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4226
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 27, 2022 at 08:37:18AM CEST, vikas.gupta@broadcom.com wrote:
>Add a framework for running selftests.
>Framework exposes devlink commands and test suite(s) to the user
>to execute and query the supported tests by the driver.
>
>Below are new entries in devlink_nl_ops
>devlink_nl_cmd_selftests_show_doit/dumpit: To query the supported
>selftests by the drivers.
>devlink_nl_cmd_selftests_run: To execute selftests. Users can
>provide a test mask for executing group tests or standalone tests.
>
>Documentation/networking/devlink/ path is already part of MAINTAINERS &
>the new files come under this path. Hence no update needed to the
>MAINTAINERS
>
>Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
>Reviewed-by: Michael Chan <michael.chan@broadcom.com>
>Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>

Note that if the patch changed since the person provided the review tag,
you should drop it. I'm pretty sure that you carry these tags from V1.

Looks good, couple small nits and I will be fine :)


>---
> .../networking/devlink/devlink-selftests.rst  |  38 +++
> include/net/devlink.h                         |  21 ++
> include/uapi/linux/devlink.h                  |  29 +++
> net/core/devlink.c                            | 216 ++++++++++++++++++
> 4 files changed, 304 insertions(+)
> create mode 100644 Documentation/networking/devlink/devlink-selftests.rst
>
>diff --git a/Documentation/networking/devlink/devlink-selftests.rst b/Documentation/networking/devlink/devlink-selftests.rst
>new file mode 100644
>index 000000000000..c0aa1f3aef0d
>--- /dev/null
>+++ b/Documentation/networking/devlink/devlink-selftests.rst
>@@ -0,0 +1,38 @@
>+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>+
>+=================
>+Devlink Selftests
>+=================
>+
>+The ``devlink-selftests`` API allows executing selftests on the device.
>+
>+Tests Mask
>+==========
>+The ``devlink-selftests`` command should be run with a mask indicating
>+the tests to be executed.
>+
>+Tests Description
>+=================
>+The following is a list of tests that drivers may execute.
>+
>+.. list-table:: List of tests
>+   :widths: 5 90
>+
>+   * - Name
>+     - Description
>+   * - ``DEVLINK_SELFTEST_FLASH``
>+     - Devices may have the firmware on non-volatile memory on the board, e.g.
>+       flash. This particular test helps to run a flash selftest on the device.
>+       Implementation of the test is left to the driver/firmware.
>+
>+example usage
>+-------------
>+
>+.. code:: shell
>+
>+    # Query selftests supported on the devlink device
>+    $ devlink dev selftests show DEV
>+    # Query selftests supported on all devlink devices
>+    $ devlink dev selftests show
>+    # Executes selftests on the device
>+    $ devlink dev selftests run DEV id flash
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 5bd3fac12e9e..b311055cc29a 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -1509,6 +1509,27 @@ struct devlink_ops {
> 				    struct devlink_rate *parent,
> 				    void *priv_child, void *priv_parent,
> 				    struct netlink_ext_ack *extack);
>+	/**
>+	 * selftests_check() - queries if selftest is supported
>+	 * @devlink: devlink instance
>+	 * @test_id: test index
>+	 * @extack: extack for reporting error messages
>+	 *
>+	 * Return: true if test is supported by the driver
>+	 */
>+	bool (*selftest_check)(struct devlink *devlink, unsigned int test_id,

Should be just "id" to be consistent with the rest of the code.


>+			       struct netlink_ext_ack *extack);
>+	/**
>+	 * selftest_run() - Runs a selftest
>+	 * @devlink: devlink instance
>+	 * @test_id: test index
>+	 * @extack: extack for reporting error messages
>+	 *
>+	 * Return: status of the test
>+	 */
>+	enum devlink_selftest_status
>+	(*selftest_run)(struct devlink *devlink, unsigned int test_id,

Same here.


>+			struct netlink_ext_ack *extack);
> };
> 
> void *devlink_priv(struct devlink *devlink);
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index 541321695f52..d6e2d3b76e47 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -136,6 +136,9 @@ enum devlink_command {
> 	DEVLINK_CMD_LINECARD_NEW,
> 	DEVLINK_CMD_LINECARD_DEL,
> 
>+	DEVLINK_CMD_SELFTESTS_GET,	/* can dump */
>+	DEVLINK_CMD_SELFTESTS_RUN,
>+
> 	/* add new commands above here */
> 	__DEVLINK_CMD_MAX,
> 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
>@@ -276,6 +279,30 @@ enum {
> #define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
> 	(_BITUL(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)
> 
>+enum devlink_attr_selftest_id {
>+	DEVLINK_ATTR_SELFTEST_ID_UNSPEC,
>+	DEVLINK_ATTR_SELFTEST_ID_FLASH,	/* flag */
>+
>+	__DEVLINK_ATTR_SELFTEST_ID_MAX,
>+	DEVLINK_ATTR_SELFTEST_ID_MAX = __DEVLINK_ATTR_SELFTEST_ID_MAX - 1
>+};
>+
>+enum devlink_selftest_status {
>+	DEVLINK_SELFTEST_STATUS_SKIP,
>+	DEVLINK_SELFTEST_STATUS_PASS,
>+	DEVLINK_SELFTEST_STATUS_FAIL
>+};
>+
>+enum devlink_attr_selftest_result {
>+	DEVLINK_ATTR_SELFTEST_RESULT_UNSPEC,
>+	DEVLINK_ATTR_SELFTEST_RESULT,		/* nested */
>+	DEVLINK_ATTR_SELFTEST_RESULT_ID,	/* u32, enum devlink_attr_selftest_id */
>+	DEVLINK_ATTR_SELFTEST_RESULT_STATUS,	/* u8, enum devlink_selftest_status */
>+
>+	__DEVLINK_ATTR_SELFTEST_RESULT_MAX,
>+	DEVLINK_ATTR_SELFTEST_RESULT_MAX = __DEVLINK_ATTR_SELFTEST_RESULT_MAX - 1
>+};
>+
> /**
>  * enum devlink_trap_action - Packet trap action.
>  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
>@@ -578,6 +605,8 @@ enum devlink_attr {
> 
> 	DEVLINK_ATTR_NESTED_DEVLINK,		/* nested */
> 
>+	DEVLINK_ATTR_SELFTESTS_INFO,		/* nested */

Drop "INFO". There are no information, just data passed there and back.
"info" is odd. DEVLINK_ATTR_SELFTESTS is enough to carry the data there
and back.


>+
> 	/* add new attributes above here, update the policy in devlink.c */
> 
> 	__DEVLINK_ATTR_MAX,
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 698b2d6e0ec7..a942b3c9223c 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -201,6 +201,10 @@ static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_
> 				 DEVLINK_PORT_FN_STATE_ACTIVE),
> };
> 
>+static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_ATTR_SELFTEST_ID_MAX + 1] = {
>+	[DEVLINK_ATTR_SELFTEST_ID_FLASH] = { .type = NLA_FLAG },
>+};
>+
> static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
> #define DEVLINK_REGISTERED XA_MARK_1
> 
>@@ -4827,6 +4831,206 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> 	return ret;
> }
> 
>+static int
>+devlink_nl_selftests_fill(struct sk_buff *msg, struct devlink *devlink,
>+			  u32 portid, u32 seq, int flags,
>+			  struct netlink_ext_ack *extack)
>+{
>+	struct nlattr *selftests_list;
>+	void *hdr;
>+	int err;
>+	int i;
>+
>+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags,
>+			  DEVLINK_CMD_SELFTESTS_GET);
>+	if (!hdr)
>+		return -EMSGSIZE;
>+
>+	err = -EMSGSIZE;
>+	if (devlink_nl_put_handle(msg, devlink))
>+		goto err_cancel_msg;
>+
>+	selftests_list = nla_nest_start(msg, DEVLINK_ATTR_SELFTESTS_INFO);
>+	if (!selftests_list)
>+		goto err_cancel_msg;
>+
>+	for (i = DEVLINK_ATTR_SELFTEST_ID_UNSPEC + 1;
>+	     i <= DEVLINK_ATTR_SELFTEST_ID_MAX; i++) {
>+		if (devlink->ops->selftest_check(devlink, i, extack)) {
>+			err = nla_put_flag(msg, i);
>+			if (err)
>+				goto err_cancel_msg;
>+		}
>+	}
>+
>+	nla_nest_end(msg, selftests_list);
>+	genlmsg_end(msg, hdr);
>+	return 0;
>+
>+err_cancel_msg:
>+	genlmsg_cancel(msg, hdr);
>+	return err;
>+}
>+
>+static int devlink_nl_cmd_selftests_get_doit(struct sk_buff *skb,
>+					     struct genl_info *info)
>+{
>+	struct devlink *devlink = info->user_ptr[0];
>+	struct sk_buff *msg;
>+	int err;
>+
>+	if (!devlink->ops->selftest_check)
>+		return -EOPNOTSUPP;
>+
>+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+
>+	err = devlink_nl_selftests_fill(msg, devlink, info->snd_portid,
>+					info->snd_seq, 0, info->extack);
>+	if (err) {
>+		nlmsg_free(msg);
>+		return err;
>+	}
>+
>+	return genlmsg_reply(msg, info);
>+}
>+
>+static int devlink_nl_cmd_selftests_get_dumpit(struct sk_buff *msg,
>+					       struct netlink_callback *cb)
>+{
>+	struct devlink *devlink;
>+	int start = cb->args[0];
>+	unsigned long index;
>+	int idx = 0;
>+	int err = 0;
>+
>+	mutex_lock(&devlink_mutex);
>+	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
>+		if (idx < start || !devlink->ops->selftest_check)
>+			goto inc;
>+
>+		devl_lock(devlink);
>+		err = devlink_nl_selftests_fill(msg, devlink,
>+						NETLINK_CB(cb->skb).portid,
>+						cb->nlh->nlmsg_seq, NLM_F_MULTI,
>+						cb->extack);
>+		devl_unlock(devlink);
>+		if (err) {
>+			devlink_put(devlink);
>+			break;
>+		}
>+inc:
>+		idx++;
>+		devlink_put(devlink);
>+	}
>+	mutex_unlock(&devlink_mutex);
>+
>+	if (err != -EMSGSIZE)
>+		return err;
>+
>+	cb->args[0] = idx;
>+	return msg->len;
>+}
>+
>+static int devlink_selftest_result_put(struct sk_buff *skb, unsigned int test_id,
>+				       enum devlink_selftest_status test_status)
>+{
>+	struct nlattr *result_attr;
>+
>+	result_attr = nla_nest_start(skb, DEVLINK_ATTR_SELFTEST_RESULT);
>+	if (!result_attr)
>+		return -EMSGSIZE;
>+
>+	if (nla_put_u32(skb, DEVLINK_ATTR_SELFTEST_RESULT_ID, test_id) ||
>+	    nla_put_u8(skb, DEVLINK_ATTR_SELFTEST_RESULT_STATUS,
>+		       test_status))
>+		goto nla_put_failure;
>+
>+	nla_nest_end(skb, result_attr);
>+	return 0;
>+
>+nla_put_failure:
>+	nla_nest_cancel(skb, result_attr);
>+	return -EMSGSIZE;
>+}
>+
>+static int devlink_nl_cmd_selftests_run(struct sk_buff *skb,
>+					struct genl_info *info)
>+{
>+	struct nlattr *tb[DEVLINK_ATTR_SELFTEST_ID_MAX + 1];
>+	struct devlink *devlink = info->user_ptr[0];
>+	struct nlattr *attrs, *tests_info;
>+	struct sk_buff *msg;
>+	void *hdr;
>+	int err;
>+	int i;
>+
>+	if (!devlink->ops->selftest_run || !devlink->ops->selftest_check)
>+		return -EOPNOTSUPP;
>+
>+	if (!info->attrs[DEVLINK_ATTR_SELFTESTS_INFO]) {
>+		NL_SET_ERR_MSG_MOD(info->extack, "selftest information required");

no "information"


>+		return -EINVAL;
>+	}
>+
>+	attrs = info->attrs[DEVLINK_ATTR_SELFTESTS_INFO];
>+
>+	err = nla_parse_nested(tb, DEVLINK_ATTR_SELFTEST_ID_MAX, attrs,
>+			       devlink_selftest_nl_policy, info->extack);
>+	if (err < 0)
>+		return err;
>+
>+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+
>+	err = -EMSGSIZE;
>+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
>+			  &devlink_nl_family, 0, DEVLINK_CMD_SELFTESTS_RUN);
>+	if (!hdr)
>+		goto free_msg;
>+
>+	if (devlink_nl_put_handle(msg, devlink))
>+		goto genlmsg_cancel;
>+
>+	tests_info = nla_nest_start(msg, DEVLINK_ATTR_SELFTESTS_INFO);
>+	if (!tests_info)
>+		goto genlmsg_cancel;
>+
>+	for (i = DEVLINK_ATTR_SELFTEST_ID_UNSPEC + 1;
>+	     i <= DEVLINK_ATTR_SELFTEST_ID_MAX; i++) {
>+		enum devlink_selftest_status test_status;
>+
>+		if (nla_get_flag(tb[i])) {
>+			if (!devlink->ops->selftest_check(devlink, i,
>+							  info->extack)) {
>+				if (devlink_selftest_result_put(msg, i,
>+								DEVLINK_SELFTEST_STATUS_SKIP))
>+					goto selftests_info_nest_cancel;
>+				continue;
>+			}
>+
>+			test_status = devlink->ops->selftest_run(devlink, i,
>+								 info->extack);
>+			if (devlink_selftest_result_put(msg, i, test_status))
>+				goto selftests_info_nest_cancel;
>+		}
>+	}
>+
>+	nla_nest_end(msg, tests_info);
>+	genlmsg_end(msg, hdr);
>+	return genlmsg_reply(msg, info);
>+
>+selftests_info_nest_cancel:
>+	nla_nest_cancel(msg, tests_info);
>+genlmsg_cancel:
>+	genlmsg_cancel(msg, hdr);
>+free_msg:
>+	nlmsg_free(msg);
>+	return err;
>+}
>+
> static const struct devlink_param devlink_param_generic[] = {
> 	{
> 		.id = DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
>@@ -8970,6 +9174,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
> 	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
> 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
> 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
>+	[DEVLINK_ATTR_SELFTESTS_INFO] = { .type = NLA_NESTED },
> };
> 
> static const struct genl_small_ops devlink_nl_ops[] = {
>@@ -9329,6 +9534,17 @@ static const struct genl_small_ops devlink_nl_ops[] = {
> 		.doit = devlink_nl_cmd_trap_policer_set_doit,
> 		.flags = GENL_ADMIN_PERM,
> 	},
>+	{
>+		.cmd = DEVLINK_CMD_SELFTESTS_GET,
>+		.doit = devlink_nl_cmd_selftests_get_doit,
>+		.dumpit = devlink_nl_cmd_selftests_get_dumpit
>+		/* can be retrieved by unprivileged users */
>+	},
>+	{
>+		.cmd = DEVLINK_CMD_SELFTESTS_RUN,
>+		.doit = devlink_nl_cmd_selftests_run,
>+		.flags = GENL_ADMIN_PERM,
>+	},
> };
> 
> static struct genl_family devlink_nl_family __ro_after_init = {
>-- 
>2.31.1
>


