Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A7757CAF8
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiGUM5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiGUM5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:57:05 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B248264;
        Thu, 21 Jul 2022 05:57:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERCyrrymx+zo4NEkTdQuvJxccceU5DgXMeXWwJr76vLnMRn60xlQ62alUHIFupe+NnzARPWAo+RF191vFj6skeBS13VB9XvwrTWKx+F+QmrwODOnulh5q2emNRRRefaFN5aX0sZ2+cipuET8j96sWM22A41Gi/JlW5EUvM58sXkIHybk7a4dG8/22t7Q4rlXhKhy1v0yUoaZwTttOYk9pIRyW2QXVrKr2Hd1sBx9MuEZf6Q7MmN7Zce8FGSc+IibIHRlMeKYdvR75kRW4oD9b3vcs1WFLtz3StWID6/u1wlsg3l/R8QHkvUP+UhnznbbEY/1Xcmg4HmIYMnTadmjFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3Ir3ezgUjgRVjpvZY0Yikbmurrw0pL5YMyUb5OqdZE=;
 b=HR/IevzwQ3szZc1ZZ3nXUkVqhR9Knq0XlWN2jKdhyWtjYB8D6pl/qUlXCvFhhvzeLgL+dOhN9jyJGAWWwFlUMlpJRCVn3EzDPMFhfxxb6FUvHytNeq6Ra5hK/hEOO0J6/dw8wYY8z9/ATSacuexM9XWw7ZJkBxQB2kxeBTab3ji8Wp8h8CB/N6o9Y0Kc+bYNnUgiv/WQDVgUpzuI9CKfxsI4YAOaWU50jn4Tpppkam5UDmubH6lzv2dr0BGwt4wFzrsrcsbCC5HZpT4m8aUiM31DRuARpGy86bLaa5e9mDCMrRoy4lpPydmXKsvNxB9lqErMImK+GEfOYwKDQ7ottw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3Ir3ezgUjgRVjpvZY0Yikbmurrw0pL5YMyUb5OqdZE=;
 b=rjIAJpwpLA+llosD1eDlh1+o3tOyUjQC1mmAJF7oVGIGg2RAkuTdmxcor8XZDoq1G+/fszS4b6+zWcTN4IUaIh0eFTd+94UcgJeL80+EgtiAtCAXIdrije2CUwIGRWyZFhyZKJCaAu5fhSx3sEQy+0sMXU801OdjqXooBLEZoBe88ImNzdttQcgRueaIftE1mYaix7BbuGpvb3u7XuZLZ9NjZaD4LiDVWp5Uj0Q3LNOpdx+WFv6t4zcgn42FJlpKrdaLK//0goJIaUMGZ2GGD+5ufOU48CCYzyrwub5sO/Q8K8aTDctnXlqZXxck3kd7Meu3uG/4xP6jIKDo1+ddAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by PH7PR12MB5709.namprd12.prod.outlook.com (2603:10b6:510:1e0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Thu, 21 Jul
 2022 12:57:02 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282%3]) with mapi id 15.20.5417.023; Thu, 21 Jul 2022
 12:57:01 +0000
Date:   Thu, 21 Jul 2022 14:56:57 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v4 1/3] devlink: introduce framework for
 selftests
Message-ID: <YtlNGWp0D7M3PXvJ@nanopsycho>
References: <20220718062032.22426-1-vikas.gupta@broadcom.com>
 <20220721072121.43648-1-vikas.gupta@broadcom.com>
 <20220721072121.43648-2-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721072121.43648-2-vikas.gupta@broadcom.com>
X-ClientProxiedBy: FR3P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::8) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2a22c94-3bd9-42c7-9c5a-08da6b188092
X-MS-TrafficTypeDiagnostic: PH7PR12MB5709:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dDDb8MH7Ek6hS0a/XmS53UUeS5FdSNmIsLbGQTqlxQx/V6WpOw7yvot/fMkgrIcn1ZPikg2DF9ijEdc2BxDM3OABvcxcO6zuu50CT47r9iHdXUGTwqMQ9AykDhe20ovPNcuCItVpilo5KplqH9SJMJr2R7Sze1Ih4tORWpnqD+zP4sJVjxY3YLYDycO+99kl6KG+B+umtLKCp7HRUopDQL1MP4dEA5qZ5uZ3jwHo+YRZ7HpjpifPV9jl4sHhmKlATYbCnitjC2iTEaEweWqt5VZBifXn39smy5G+6soB02oE77t3MicioW9Dk87l+CjQuX1Od4fCUmkg/8tC8uoGwiSMnsSdME7mdaDqXkfYpvUIn8L6n2rvm0qbuBiXJfojHbvMzva3Tw5Va37SVFbGHsO7UipnY0oNF6a83vgBEvlyHSoj8kFR3O+eK5i9OpzQpaq66lWSterI6rISVZfIE3TVDx02NNJCTLofslMSxv7lExKqkVEvRKlYiuhrKwjHlVySWDzfKW1rvxANAeZjT1NNzIqbwiyLMT7/eXaekiaSqqcxrBY4M7tIzzlKtUY2AD/mzrteWr2p/a48vGIc27migqfomQi17fTxObPJlsXOayKzWfUgICa2qH0gUvqbB0drd5GYFE9TCABhIHuQ6P0cyOeCnEosqCLNnY75pPI2SrLn9Pa1xafk1uTsT4gLrLvG/gVTL7FWuVrJG/GqdZv6rk1VMSeLh229B3A7+Hy0UrLMGwsaaRR+MmaRDgIX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(346002)(39860400002)(136003)(366004)(396003)(30864003)(26005)(86362001)(33716001)(83380400001)(6512007)(186003)(66946007)(9686003)(66476007)(6486002)(478600001)(6916009)(66556008)(5660300002)(7416002)(41300700001)(2906002)(8676002)(4326008)(316002)(38100700002)(6666004)(8936002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g1u5YGpiCl6kC033+DYeLjWbnUCHPIl1/mTgMPGFP+SX7Cv3QOh+Zz7ihjWj?=
 =?us-ascii?Q?TLxf3oUl1h8ji4tCCz4VPISLv5SRy1Px2PAURSDDwyTYjvJQvzTUjG5II4RB?=
 =?us-ascii?Q?UJqZ5r7MRVnqnKueO3+E9to1JyB6LiBZGI9FK9NTDuUfdWTQh43AYiTQiIGH?=
 =?us-ascii?Q?tXooEm7ncJuCoFukNhfRF4xhGhNxo5QrM7oAp3Wt/w3LFEy4DzxdwMqGvgqB?=
 =?us-ascii?Q?5z3MuPjokLJRxsZUllF2yoUq5v4GYIKlbGsHnbih7HMhQOL4hqkSevzMbwQ1?=
 =?us-ascii?Q?yp9s/1zw9FlTa3Wq0Y1KX26WsInliZj1AZvsajZGffoYiEn4SIONwLUD77CT?=
 =?us-ascii?Q?0eo4Ew9J6Tb+7W3wEzyfBTE1XkBZfZGNKJo14UpDCfL8DQ4a+UHoARv6cSsr?=
 =?us-ascii?Q?bEobklmze+5wvZZzeEel1PczBmQMcNVRmcb65zI2H9tgFqo8YfiU3hIfoRaL?=
 =?us-ascii?Q?JR8bx3gAcSLuvCfQ8eNAQbCEagpX9C60+zPhgz4YF6qQIKUVQQXYeVBPCYdn?=
 =?us-ascii?Q?77E/pV7FCpVaxvOjc7zRVubtRiaNqvsEOeBF2SY2o8KxUE5LAoe2I4KUvHWJ?=
 =?us-ascii?Q?90gtUU0AnHnLVizmFNFcFJqsm6fuol/7X/knBldIv+LRVwDE9mrYD4wVObGF?=
 =?us-ascii?Q?Fjzq3QUcBhZuG6iyjsxi6kmN9j9b6ISuhwHonljh6zxaB7t3j1v3kUjwGgo5?=
 =?us-ascii?Q?GabfY+qR0MsSx7FnUanC6ymmatH9KdQvHU1zoR5YYqAHhqTK0siU4iowQe7g?=
 =?us-ascii?Q?JfXkOgYLr8IvNY0UHfAD0LADrDIse3/83iEZwxJ38gNmGW3o9hrgVwbZeOEU?=
 =?us-ascii?Q?TwgAnYSGO4WbE91fRvkE/pTF9Q9RH5+qYaB52fLgBOZ7e6ZjwReSVO9KgtRJ?=
 =?us-ascii?Q?WimtDCb4xNb0PwyLmwHFayF5MSMGaGL0OGGghNZZ5fLky/5caPYWnrezH32p?=
 =?us-ascii?Q?L4x9ckFO4MAFsq5ASqvjOGkFLsD7LBwYQ05QgDJBiOFJIgCfmAzUS43DhBC4?=
 =?us-ascii?Q?T4Yz5gbjZiGY65dAvVNWKLkXiwib1tSfq5wPb+6gtkHnaSLRvltEhyCug9H9?=
 =?us-ascii?Q?ZuHmRWOYE1a3X6eEcK3J8VscFHkNsaj6TOARNCqLzIUtHCMz9G6xaV83j0xx?=
 =?us-ascii?Q?hu6Nv0jCj0wE1ViZSf94kClz3Obb7hFdkVobPPeCB4QbN8bPwk8tK2sUQ//L?=
 =?us-ascii?Q?JKnrJRndbT0PSw3vY/gZZcrx8zWqaAIhMhgtqY1HXDavl4p5X0Xsf6LgiwGk?=
 =?us-ascii?Q?MRutSKo9U6Me0cJU8slb6WTH6UG92Xo6halTQSux5kAOZDPA+Les91cEhyvf?=
 =?us-ascii?Q?D2wL4XFUMlLKQVhj4zZOvt6/exUTe4r3ZBLRXwO8n3EIHbiBA5U95IlZ/Li5?=
 =?us-ascii?Q?Gq4hlf9hGz0yXflXfACpvAPxy1DgbI2fknTruWKLZppi9LIOhNE7EbEPd8Ld?=
 =?us-ascii?Q?dSaQoatBUgQwz+AlwOkXkrfTygK/PsKm1xq8x7TmbhE7yK7BSQNuuMwYDRYn?=
 =?us-ascii?Q?hkBcVnd9+Zt3uox5/YoY1UZBBpD9VtO7ya7GkPiT0JsCi8MeAAhRsivypSDI?=
 =?us-ascii?Q?XR4ASiQWtRIn6G1vMipXZF1E0Z78qTK26H34mmqF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a22c94-3bd9-42c7-9c5a-08da6b188092
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 12:57:01.0418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D8jEieam1Goio4kI69CbFbCWYuVBnX0z8ZOETiPxTavQ7Iqa78ejTFJ02v5FDGFK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5709
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 09:21:19AM CEST, vikas.gupta@broadcom.com wrote:
>Add a framework for running selftests.
>Framework exposes devlink commands and test suite(s) to the user
>to execute and query the supported tests by the driver.
>
>Below are new entries in devlink_nl_ops
>devlink_nl_cmd_selftests_list_doit/dumpit: To query the supported
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
>---
> .../networking/devlink/devlink-selftests.rst  |  38 +++
> include/net/devlink.h                         |  20 ++
> include/uapi/linux/devlink.h                  |  29 +++
> net/core/devlink.c                            | 225 ++++++++++++++++++
> 4 files changed, 312 insertions(+)
> create mode 100644 Documentation/networking/devlink/devlink-selftests.rst
>
>diff --git a/Documentation/networking/devlink/devlink-selftests.rst b/Documentation/networking/devlink/devlink-selftests.rst
>new file mode 100644
>index 000000000000..0e9727895987
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
>+    $ devlink dev selftests run DEV test flash

"test_id" to be consistend with the attr name and outputs. Please see
below. Devlink cmdline would accept "test" as well, so you can still use
this.


>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 88c701b375a2..085d761f1cd3 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -1509,6 +1509,26 @@ struct devlink_ops {
> 				    struct devlink_rate *parent,
> 				    void *priv_child, void *priv_parent,
> 				    struct netlink_ext_ack *extack);
>+	/**
>+	 * selftests_check() - queries if selftest is supported
>+	 * @devlink: Devlink instance

Why capital "D"?


>+	 * @test_id: test index
>+	 * @extack: extack for reporting error messages
>+	 *
>+	 * Return: true if test is supported by the driver
>+	 */
>+	bool (*selftest_check)(struct devlink *devlink, int test_id,

Why this is an "int". I would be surprised to see a negative value here.
Have this unsigned please.


>+			       struct netlink_ext_ack *extack);
>+	/**
>+	 * selftest_run() - Runs a selftest
>+	 * @devlink: Devlink instance
>+	 * @test_id: test index
>+	 * @extack: extack for reporting error messages
>+	 *
>+	 * Return: Result of the test
>+	 */
>+	u8 (*selftest_run)(struct devlink *devlink, int test_id,

There too.


>+			   struct netlink_ext_ack *extack);
> };
> 
> void *devlink_priv(struct devlink *devlink);
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index b3d40a5d72ff..469846f40e6d 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -136,6 +136,9 @@ enum devlink_command {
> 	DEVLINK_CMD_LINECARD_NEW,
> 	DEVLINK_CMD_LINECARD_DEL,
> 
>+	DEVLINK_CMD_SELFTESTS_LIST,	/* can dump */

The rest of the commands are named "_GET". Please be consistent with
them.


>+	DEVLINK_CMD_SELFTESTS_RUN,
>+
> 	/* add new commands above here */
> 	__DEVLINK_CMD_MAX,
> 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
>@@ -276,6 +279,31 @@ enum {
> #define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
> 	(_BITUL(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)
> 
>+/* Commonly used test cases */

What do you mean by "commonly". Are there some others that are not
"common"? I don't follow.


>+enum devlink_selftest_attr {
>+	DEVLINK_SELFTEST_ATTR_UNSPEC,
>+	DEVLINK_SELFTEST_ATTR_FLASH,		/* flag */
>+
>+	__DEVLINK_SELFTEST_ATTR_MAX,
>+	DEVLINK_SELFTEST_ATTR_MAX = __DEVLINK_SELFTEST_ATTR_MAX - 1
>+};

To be consistent with the attr that caries this:

enum devlink_attr_selftest_test_id {
	DEVLINK_ATTR_SELFTEST_TEST_ID_UNSPEC,
	DEVLINK_ATTR_SELFTEST_TEST_ID_FLASH,		/* flag */

	__DEVLINK_ATTR_SELFTEST_TEST_ID_MAX,
	DEVLINK_ATTR_SELFTEST_TEST_ID_MAX = __DEVLINK_ATTR_SELFTEST_TEST_ID_MAX - 1

>+
>+enum devlink_selftest_result {
>+	DEVLINK_SELFTEST_SKIP,
>+	DEVLINK_SELFTEST_PASS,
>+	DEVLINK_SELFTEST_FAIL

It is common to have the enum name be root of names of the values.
Also, be consistent with the attr this value is carried over:

enum devlink_selftest_test_status {
	DEVLINK_SELFTEST_TEST_STATUS_SKIP,
	DEVLINK_SELFTEST_TEST_STATUS_PASS,
	DEVLINK_SELFTEST_TEST_STATUS_FAIL

That way, it is obvious to which enum the value belongs.


>+};
>+
>+enum devlink_selftest_result_attr {
>+	DEVLINK_SELFTEST_ATTR_RESULT_UNSPEC,
>+	DEVLINK_SELFTEST_ATTR_RESULT,		/* nested */
>+	DEVLINK_SELFTEST_ATTR_TEST_ID,		/* u32, devlink_selftest_attr */

add "enum" ?

>+	DEVLINK_SELFTEST_ATTR_TEST_STATUS,	/* u8, devlink_selftest_result */

add "enum" ?

The same note as above:
enum devlink_attr_selftest_result {
	DEVLINK_ATTR_SELFTEST_RESULT_UNSPEC,
	DEVLINK_ATTR_SELFTEST_RESULT,		  /* nested */
	DEVLINK_ATTR_SELFTEST_RESULT_TEST_ID,	  /* u32, enum devlink_selftest_attr */
	DEVLINK_ATTR_SELFTEST_RESULT_TEST_STATUS, /* u8, devlink_selftest_result */




>+
>+	__DEVLINK_SELFTEST_ATTR_RES_MAX,
>+	DEVLINK_SELFTEST_ATTR_RES_MAX = __DEVLINK_SELFTEST_ATTR_RES_MAX - 1
>+};
>+
> /**
>  * enum devlink_trap_action - Packet trap action.
>  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
>@@ -576,6 +604,7 @@ enum devlink_attr {
> 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
> 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
> 
>+	DEVLINK_ATTR_SELFTESTS_INFO,		/* nested */
> 	/* add new attributes above here, update the policy in devlink.c */
> 
> 	__DEVLINK_ATTR_MAX,
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index a9776ea923ae..ef9439f2502f 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -198,6 +198,10 @@ static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_
> 				 DEVLINK_PORT_FN_STATE_ACTIVE),
> };
> 
>+static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_SELFTEST_ATTR_MAX + 1] = {
>+	[DEVLINK_SELFTEST_ATTR_FLASH] = { .type = NLA_FLAG },
>+};
>+
> static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
> #define DEVLINK_REGISTERED XA_MARK_1
> 
>@@ -4791,6 +4795,215 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
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
>+			  DEVLINK_CMD_SELFTESTS_LIST);
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
>+	for (i = 1; i < DEVLINK_SELFTEST_ATTR_MAX + 1; i++) {

**)
It is a bit odd to see "1" here. Maybe "DEVLINK_SELFTEST_ATTR_UNSPEC + 1"
would be more obvious for the reader.

also:
i < DEVLINK_SELFTEST_ATTR_MAX + 1
would be rather nicer to be:
i <= DEVLINK_SELFTEST_ATTR_MAX


>+		if (devlink->ops->selftest_check(devlink, i, extack)) {
>+			err = nla_put_flag(msg, i);
>+			if (err)
>+				goto err_cancel_msg;
>+		}
>+	}
>+
>+	nla_nest_end(msg, selftests_list);
>+

No need for this empty line.


>+	genlmsg_end(msg, hdr);
>+

No need for this empty line.


>+	return 0;
>+
>+err_cancel_msg:
>+	genlmsg_cancel(msg, hdr);
>+	return err;
>+}
>+
>+static int devlink_nl_cmd_selftests_list_doit(struct sk_buff *skb,
>+					      struct genl_info *info)
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
>+static int devlink_nl_cmd_selftests_list_dumpit(struct sk_buff *msg,
>+						struct netlink_callback *cb)
>+{
>+	struct devlink *devlink;
>+	int start = cb->args[0];
>+	unsigned long index;
>+	int idx = 0;
>+	int err = 0;
>+
>+	mutex_lock(&devlink_mutex);
>+	xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
>+		if (!devlink_try_get(devlink))
>+			continue;
>+
>+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
>+			goto retry;
>+
>+		if (idx < start || !devlink->ops->selftest_check)
>+			goto inc;
>+
>+		mutex_lock(&devlink->lock);
>+		err = devlink_nl_selftests_fill(msg, devlink,
>+						NETLINK_CB(cb->skb).portid,
>+						cb->nlh->nlmsg_seq, NLM_F_MULTI,
>+						cb->extack);
>+		mutex_unlock(&devlink->lock);
>+		if (err) {
>+			devlink_put(devlink);
>+			break;
>+		}
>+inc:
>+		idx++;
>+retry:
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
>+static int devlink_selftest_result_put(struct sk_buff *skb, int test_id,

unsigned.

>+				       u8 result)

Please be consistend and call this "test_status"


>+{
>+	struct nlattr *result_attr;
>+
>+	result_attr = nla_nest_start(skb, DEVLINK_SELFTEST_ATTR_RESULT);
>+	if (!result_attr)
>+		return -EMSGSIZE;
>+
>+	if (nla_put_u32(skb, DEVLINK_SELFTEST_ATTR_TEST_ID, test_id) ||
>+	    nla_put_u8(skb, DEVLINK_SELFTEST_ATTR_TEST_STATUS, result))
>+		goto nla_put_failure;
>+
>+	nla_nest_end(skb, result_attr);
>+

No need for this empty line.


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
>+	struct nlattr *tb[DEVLINK_SELFTEST_ATTR_MAX + 1];
>+	struct devlink *devlink = info->user_ptr[0];
>+	struct nlattr *attrs, *tests_info;
>+	struct sk_buff *msg;
>+	void *hdr;
>+	int err;
>+	int i;
>+
>+	if (!devlink->ops->selftest_run)
>+		return -EOPNOTSUPP;
>+
>+	if (!info->attrs[DEVLINK_ATTR_SELFTESTS_INFO])

Fill extack message here please.


>+		return -EINVAL;
>+
>+	attrs = info->attrs[DEVLINK_ATTR_SELFTESTS_INFO];
>+
>+	err = nla_parse_nested(tb, DEVLINK_SELFTEST_ATTR_MAX, attrs,
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
>+	for (i = 1; i < DEVLINK_SELFTEST_ATTR_MAX + 1; i++) {

Same notes to the iteration as above. **


>+		u8 res = DEVLINK_SELFTEST_SKIP;

u8 test_status;


>+
>+		if (nla_get_flag(tb[i])) {
>+			if (devlink->ops->selftest_check &&

No need to test in every iteration. I think it is safe to assume
that driver that does not fill selftest_check() does not support
selftests at all, so please move to the beginning of this function
alongside selftest_run() check:

	if (!devlink->ops->selftest_run || !devlink->ops->selftest_check)
		return -EOPNOTSUPP;

>+			    !devlink->ops->selftest_check(devlink, i,
>+							  info->extack)) {
>+				err = devlink_selftest_result_put(msg, i, res);

Just do devlink_selftest_result_put(msg, i, .._SKIP); here and avoid
initializing "res" at the beginning.


>+				if (err)
>+					goto selftests_list_nest_cancel;
>+				continue;
>+			}
>+
>+			res = devlink->ops->selftest_run(devlink, i,
>+							 info->extack);
>+			err = devlink_selftest_result_put(msg, i, res);
>+			if (err)
>+				goto selftests_list_nest_cancel;
>+		}
>+	}
>+
>+	nla_nest_end(msg, tests_info);
>+

No need for this empty line.


>+	genlmsg_end(msg, hdr);
>+

No need for this empty line.


>+	return genlmsg_reply(msg, info);
>+
>+selftests_list_nest_cancel:
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
>@@ -8997,6 +9210,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
> 	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
> 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
> 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
>+	[DEVLINK_ATTR_SELFTESTS_INFO] = { .type = NLA_NESTED },
> };
> 
> static const struct genl_small_ops devlink_nl_ops[] = {
>@@ -9356,6 +9570,17 @@ static const struct genl_small_ops devlink_nl_ops[] = {
> 		.doit = devlink_nl_cmd_trap_policer_set_doit,
> 		.flags = GENL_ADMIN_PERM,
> 	},
>+	{
>+		.cmd = DEVLINK_CMD_SELFTESTS_LIST,
>+		.doit = devlink_nl_cmd_selftests_list_doit,
>+		.dumpit = devlink_nl_cmd_selftests_list_dumpit
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


