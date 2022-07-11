Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099DC5702D3
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 14:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiGKMkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 08:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiGKMkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 08:40:24 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505E44E855;
        Mon, 11 Jul 2022 05:40:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0sjFmiWG4qxJkEidW4yer8qN1JFTG4ge3wPhz8xa3D3GVhDVK5MekbOCF7A+kXIMRswY2Waa3Qp7wHMafDxKJ6nllx8jFKfXvLvtYYdYhe3sJyNe+C0pSOFMg/ehHZexhpI07nGZkDhVwbuucKj/po12TGXlU5dGwDA1Lh0DELHWAS0UmD6UOrh+jnJ6OKORp0YZAt9Bl1Oae2zL8Xcp1GtjcGC7Kl1Q9xL8Df6gAR1y+18/sVyZ3x63SPgOnC+WizN9uyMZGJ8izWASdSTHeIO3OGIfV5w1dQrGgTvZMfDekfFENmxzENcPQ79eA/OcJeF6sL1q+s/Jfwh3lsIzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SiAh0WmFYpd1TfqvH6U+Twy0IRhmGUd+bjL20Zo2cNQ=;
 b=lYfqTMzCLXtdPNYNRrNhOl+up+i7BvL7M6Mc9om9RSkn50gbBo0nK0ccPx9YIPtJxYyU5d38SHGFqZOxcvW4sq+CWAkybRjcVYJr2H3f7egF5aGmdVgAsecQp0p7IF5G+6s1CMoHiRhawOjtmWj77V2C2X26nZqrJrfeI+hlKN11vu6vbwYbGstR0uDmX6KYv52lhdiKp9zTlJYTPENeXVGWpLCETS7v892neBjvbfzIIcgnjTf92GQfydNyY/u+D6BplOQJzibGxRyGyw5QoSLbrZ9C3Zu80TOWlH0odX8WcWl2uMCDYjH1UgFameynNPwGAgIiJWBq9cqpszl+og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiAh0WmFYpd1TfqvH6U+Twy0IRhmGUd+bjL20Zo2cNQ=;
 b=qGE9w0GR4Q2RaKT7TzqKMhOI/TS1HuRNRkW4aUWI8QiEVe0dt4C6YNeVqDDzyJOeVwp0JTn+KV/kcPJ6SzZuDv2t5j/hgFBm3Z2Nf2qb6+xhObtwXlYtSQH5lGCXW7Bn028sOsFpqXP66NLxvb9YgzMsWl8uOXBg9V1U6aVonbmQmyn6LMDCZb3ufjJx2/OhvCJwCCq+qX5tYG5qHJDmJdQZ6tQx7sPopHTWRtGkA23KCB7T12pt4vvZZc08gbw+jcmpZmtJGuTk/MVX/j9mLAr1INHXAt6HdUo9CSLFYiaJUSxfnJvttbwEmt4d5quiBTKp9Bo3zuBkYIZFchnLKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by CH2PR12MB3799.namprd12.prod.outlook.com (2603:10b6:610:21::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Mon, 11 Jul
 2022 12:40:14 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282%3]) with mapi id 15.20.5417.023; Mon, 11 Jul 2022
 12:40:14 +0000
Date:   Mon, 11 Jul 2022 14:40:09 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v2 1/3] devlink: introduce framework for
 selftests
Message-ID: <YswaKcUs6nOndU2V@nanopsycho>
References: <20220628164241.44360-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-2-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707182950.29348-2-vikas.gupta@broadcom.com>
X-ClientProxiedBy: FR0P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::20) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1284d039-6a53-456b-d1bf-08da633a8062
X-MS-TrafficTypeDiagnostic: CH2PR12MB3799:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhZNmShM6dmirfpppYrYOrieUTkL9IaMMKW+N+aFSy53YkFLb2UuzKkNh3dXOQc9c5Weu6uuVFxGF8SSGD0KYaefWmGVPpED7oF+Cd8Jitet0xiXEAYkPS9hO966hRK7uxNrl9py3aFVXzyYpcFOIeIEPIq5uQttV/z6BWOdNoqsUnlb9elINFv/uniwzOhOFmys5G8R7HFc7vrjXmiKWFWQRgr8vMa6/nFmxuZX2LKSDO180Gcy4whevHQvdIp94qubhlh1oO7LPDmDrM2rHzUYdISuBKxqL4O1tOl2FEprezcfZfHtMkfzjUpz8ExNqU7rEGm2HbS7Kf5q1CzDI+0p3kbANfy2/01lkQWlmL7T+FJKf/9jynNNpRcQAFVkHLWuAvSxUacQUhK5jtOZ4hmU4Mgb2qzRmWcUV5lb0+iXuso8q18l4uYu5oOaCropmh75W3o0kZLfjqOdA//YbQh+yLXcxTtjK8pufTxREXUri2PoVs8D2hILAav0C/IHZU8rlO9WPe5mMAqljsBdbvWKAxK4I0TupbnEgumjKfWRed8tyZofyf0aakmqUX2mGOKj/KE4UQp+Y1Qyn8qJoLH3jC272ax33++nDKP0GhPoPWmszGyh0gAhO6TKAy0tyQDuAYhCwRQa6zpzFdCJ++kBOaj58t6IUon2E5hz6Wjz79qIuFDH5bxf3TyzFufERPF5Gikxt3yU8FsC1el7mgs1d8KrS48C382/fEc//DgytK+wQa1/VeL6xc8BkPxd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(366004)(39860400002)(136003)(376002)(396003)(66476007)(66556008)(8676002)(66946007)(478600001)(6486002)(4326008)(316002)(6916009)(186003)(83380400001)(6666004)(41300700001)(26005)(6506007)(9686003)(38100700002)(6512007)(8936002)(7416002)(5660300002)(2906002)(30864003)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L6ioURc+JxAkv3fpo9DtshNileKnT0aOM9HL9MTM70fWgH+3yHocZmC0DqWo?=
 =?us-ascii?Q?5G7tEQ3EgjSRRqcBiPcg1ghw6MFYXL3N/tglDEOk3wyN306JANCYXXrowIdp?=
 =?us-ascii?Q?X1dqlVtpgEQoaa78J45/rgr2zwtRhVOlHnCITwwKcuPjOhB6kA7faX4RxMmj?=
 =?us-ascii?Q?Iog8qLFBycKcBZ+xM+DIyyKyXRYiAdHAYY/9M/UcWJ4qVWwcUYfB3Qu/zhz0?=
 =?us-ascii?Q?Tjiqm6gcVJaXasIj83axLHIxiztYZINxn9U/oRrcawCtgyPpwu33GVO10O+1?=
 =?us-ascii?Q?J1UtD5YcgdAd259wjSNR3UmyjWwjdkNs+2hR/FT2YQNMW/2ICvFoKiqyynF8?=
 =?us-ascii?Q?9s5wIjT5Mc3LF1TCS17s0j59TXr2XPOWUVY+1M/f+sGuE4OJ0a5HlcIPTvSS?=
 =?us-ascii?Q?JA8XVIxnghw+rZ6HzokFyJ7IEnYLkgZXUdEUJDj7B+fu8P6MO62ziVEKoCvd?=
 =?us-ascii?Q?j54EytN9bkdt0C7l/h44Bi8PDSoYrNC4mCfGI85Kt4CT7E7RP8uEjFjS6FE6?=
 =?us-ascii?Q?foww1rosS0j8chgalQLwTr96OEbyypnwI7LQYFOcgmUEaFDSoIBTL1VpluQH?=
 =?us-ascii?Q?faQlkmAL5PvE9xBoMGKaeJi7FYFszvxjbXuXpmL6vKtDbJvOlp6LXBf2UXMI?=
 =?us-ascii?Q?RibP11IqY+k6v5tMGoFZVHMLabxEAtiiEGJXPGnw5ab4JKxG6myL8F6OeNI1?=
 =?us-ascii?Q?q/TIgNhYzg0wuvO3nhoWS6DgDo/tBQ5wCPrT2KQXoNEph4XXPbM8GJR0jcIS?=
 =?us-ascii?Q?N+D0DqadByQqx5TP4gil+NjpQqkQhU12BjWEdjnbXdd/ZK3tIjpSP7prhzIK?=
 =?us-ascii?Q?k3Oyhp70EcHKvy+IsUIGGM3TXgtW6rNC3Y7BGQOT67jgbV7rYB0dm9mNoswg?=
 =?us-ascii?Q?xe1aae5cj2wrP0Uu6/h4nYeh7Gjdxrj2408lv5d+QixbY5WoSjh8IDlc5KKQ?=
 =?us-ascii?Q?Lly1tQZfFLcrRoBL7CEz3o+9PFqnzjnKQbn1sPDbinWHeWsVR5zPP9x6LAi+?=
 =?us-ascii?Q?XdfwV3geAOs+Jjtt7h2EEHeoyQijsvpnDiS8bMw5M6K7VMNWxj4bve7gufpE?=
 =?us-ascii?Q?n0/5p2vioJFWJFN+nu5/lpnz7zXB/Dc/yL/PqDEWbe5ruHy32kj2vPiwqZ6n?=
 =?us-ascii?Q?gEDXNCCWuO6UgL7OSaQO07hnrz/bWQjtF8No3Bty6ubYnJ8IAw6s3ApGVSuc?=
 =?us-ascii?Q?12zVIlwuzRrbUI/zAcsgBqMLxSXEFJ+aZRMN9TxltuZNKHuSjvBH0UApaFgj?=
 =?us-ascii?Q?xg+DzVBqmK8cpolKs3oBt69EO7auseSnRZTlKuq/ZbtiqEQ07F5l2aqAQ6ln?=
 =?us-ascii?Q?xyitX48E0Sin1thvLiRTC0uL8rL4NwYDPrLLD8rAHUq+xymI2SmyOx+r23BV?=
 =?us-ascii?Q?XMXWtyiqTFkryR3W+Svsn9vXt8IjrhdEIBfwSK4MSgPpGPlO7KHZY5xdsPaA?=
 =?us-ascii?Q?dVS3kfEVffomIHssAxRNQJVKF23yu8xiyPi6MTN89NBoII8CDdE0GvCdR0kI?=
 =?us-ascii?Q?Ts7/nIdJmyynBLfUTQvqquYCEcvZjdaHQnK383P+e0Q3iNo3bmnj0R8A7vHE?=
 =?us-ascii?Q?rmrlwfBwqj24DdCLjWi3ouvxGzqDv21T1MPvtTN1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1284d039-6a53-456b-d1bf-08da633a8062
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 12:40:14.3308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JORiUrHg22WctaSKvpoBKVs0jUwh509c+j6KkAtQz/kpDlV2kTktEPT9A7yj4XfE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3799
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 07, 2022 at 08:29:48PM CEST, vikas.gupta@broadcom.com wrote:
>Add a framework for running selftests.
>Framework exposes devlink commands and test suite(s) to the user
>to execute and query the supported tests by the driver.
>
>Below are new entries in devlink_nl_ops
>devlink_nl_cmd_selftests_show: To query the supported selftests
>by the driver.
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
> .../networking/devlink/devlink-selftests.rst  |  34 +++++
> include/net/devlink.h                         |  30 ++++
> include/uapi/linux/devlink.h                  |  26 ++++
> net/core/devlink.c                            | 144 ++++++++++++++++++
> 4 files changed, 234 insertions(+)
> create mode 100644 Documentation/networking/devlink/devlink-selftests.rst
>
>diff --git a/Documentation/networking/devlink/devlink-selftests.rst b/Documentation/networking/devlink/devlink-selftests.rst
>new file mode 100644
>index 000000000000..796d38f77038
>--- /dev/null
>+++ b/Documentation/networking/devlink/devlink-selftests.rst
>@@ -0,0 +1,34 @@
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
>+     - Runs a flash test on the device.
>+
>+example usage
>+-------------
>+
>+.. code:: shell
>+
>+    # Query selftests supported on the device
>+    $ devlink dev selftests show DEV
>+    # Executes selftests on the device
>+    $ devlink dev selftests run DEV test {flash | all}
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 2a2a2a0c93f7..cb7c378cf720 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -1215,6 +1215,18 @@ enum {
> 	DEVLINK_F_RELOAD = 1UL << 0,
> };
> 
>+#define DEVLINK_SELFTEST_FLASH_TEST_NAME "flash"
>+
>+static inline const char *devlink_selftest_name(int test)

I don't understand why this is needed. Better not to expose string to
the user. Just have it as well defined attr.


>+{
>+	switch (test) {
>+	case DEVLINK_SELFTEST_FLASH_BIT:
>+		return DEVLINK_SELFTEST_FLASH_TEST_NAME;
>+	default:
>+		return "unknown";
>+	}
>+}
>+
> struct devlink_ops {
> 	/**
> 	 * @supported_flash_update_params:
>@@ -1509,6 +1521,24 @@ struct devlink_ops {
> 				    struct devlink_rate *parent,
> 				    void *priv_child, void *priv_parent,
> 				    struct netlink_ext_ack *extack);
>+	/**
>+	 * selftests_show() - Shows selftests supported by device
>+	 * @devlink: Devlink instance
>+	 * @extack: extack for reporting error messages
>+	 *
>+	 * Return: test mask supported by driver
>+	 */
>+	u32 (*selftests_show)(struct devlink *devlink,
>+			      struct netlink_ext_ack *extack);
>+	/**
>+	 * selftests_run() - Runs selftests
>+	 * @devlink: Devlink instance
>+	 * @tests_mask: tests to be run by driver
>+	 * @results: test results by driver
>+	 * @extack: extack for reporting error messages
>+	 */
>+	void (*selftests_run)(struct devlink *devlink, u32 tests_mask,
>+			      u8 *results, struct netlink_ext_ack *extack);
> };
> 
> void *devlink_priv(struct devlink *devlink);
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index b3d40a5d72ff..1dba262328b9 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -136,6 +136,9 @@ enum devlink_command {
> 	DEVLINK_CMD_LINECARD_NEW,
> 	DEVLINK_CMD_LINECARD_DEL,
> 
>+	DEVLINK_CMD_SELFTESTS_SHOW,
>+	DEVLINK_CMD_SELFTESTS_RUN,
>+
> 	/* add new commands above here */
> 	__DEVLINK_CMD_MAX,
> 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
>@@ -276,6 +279,25 @@ enum {
> #define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
> 	(_BITUL(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)
> 
>+/* Commonly used test cases */
>+enum {
>+	DEVLINK_SELFTEST_FLASH_BIT,
>+
>+	__DEVLINK_SELFTEST_MAX_BIT,
>+	DEVLINK_SELFTEST_MAX_BIT = __DEVLINK_SELFTEST_MAX_BIT - 1
>+};
>+
>+#define DEVLINK_SELFTEST_FLASH _BITUL(DEVLINK_SELFTEST_FLASH_BIT)
>+
>+#define DEVLINK_SELFTESTS_MASK \
>+	(_BITUL(__DEVLINK_SELFTEST_MAX_BIT) - 1)
>+
>+enum {
>+	DEVLINK_SELFTEST_SKIP,
>+	DEVLINK_SELFTEST_PASS,
>+	DEVLINK_SELFTEST_FAIL
>+};
>+
> /**
>  * enum devlink_trap_action - Packet trap action.
>  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
>@@ -576,6 +598,10 @@ enum devlink_attr {
> 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
> 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
> 
>+	DEVLINK_ATTR_SELFTESTS_MASK,		/* u32 */

I don't see why this is u32 bitset. Just have one attr per test
(NLA_FLAG) in a nested attr instead.



>+	DEVLINK_ATTR_TEST_RESULT,		/* nested */
>+	DEVLINK_ATTR_TEST_NAME,			/* string */
>+	DEVLINK_ATTR_TEST_RESULT_VAL,		/* u8 */

Could you maintain the same "namespace" for all attrs related to
selftests?


> 	/* add new attributes above here, update the policy in devlink.c */
> 
> 	__DEVLINK_ATTR_MAX,
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index db61f3a341cb..0b7341ab6379 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -4794,6 +4794,136 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> 	return ret;
> }
> 
>+static int devlink_selftest_name_put(struct sk_buff *skb, int test)
>+{
>+	const char *name = devlink_selftest_name(test);
>+	if (nla_put_string(skb, DEVLINK_ATTR_TEST_NAME, name))
>+		return -EMSGSIZE;
>+
>+	return 0;
>+}
>+
>+static int devlink_nl_cmd_selftests_show(struct sk_buff *skb,
>+					 struct genl_info *info)
>+{
>+	struct devlink *devlink = info->user_ptr[0];
>+	struct sk_buff *msg;
>+	unsigned long tests;
>+	int err = 0;
>+	void *hdr;
>+	int test;
>+
>+	if (!devlink->ops->selftests_show)
>+		return -EOPNOTSUPP;
>+
>+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+
>+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
>+			  &devlink_nl_family, 0, DEVLINK_CMD_SELFTESTS_SHOW);
>+	if (!hdr)
>+		goto free_msg;
>+
>+	if (devlink_nl_put_handle(msg, devlink))
>+		goto genlmsg_cancel;
>+
>+	tests = devlink->ops->selftests_show(devlink, info->extack);
>+
>+	for_each_set_bit(test, &tests, __DEVLINK_SELFTEST_MAX_BIT) {
>+		err = devlink_selftest_name_put(msg, test);
>+		if (err)
>+			goto genlmsg_cancel;
>+	}
>+
>+	genlmsg_end(msg, hdr);
>+
>+	return genlmsg_reply(msg, info);
>+
>+genlmsg_cancel:
>+	genlmsg_cancel(msg, hdr);
>+free_msg:
>+	nlmsg_free(msg);
>+	return err;
>+}
>+
>+static int devlink_selftest_result_put(struct sk_buff *skb, int test,
>+				       u8 result)
>+{
>+	const char *name = devlink_selftest_name(test);
>+	struct nlattr *result_attr;
>+
>+	result_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_TEST_RESULT);
>+	if (!result_attr)
>+		return -EMSGSIZE;
>+
>+	if (nla_put_string(skb, DEVLINK_ATTR_TEST_NAME, name) ||
>+	    nla_put_u8(skb, DEVLINK_ATTR_TEST_RESULT_VAL, result))
>+		goto nla_put_failure;
>+
>+	nla_nest_end(skb, result_attr);
>+
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
>+	u8 test_results[DEVLINK_SELFTEST_MAX_BIT + 1] = {};
>+	struct devlink *devlink = info->user_ptr[0];
>+	unsigned long tests;
>+	struct sk_buff *msg;
>+	u32 tests_mask;
>+	void *hdr;
>+	int err = 0;
>+	int test;
>+
>+	if (!devlink->ops->selftests_run)
>+		return -EOPNOTSUPP;
>+
>+	if (!info->attrs[DEVLINK_ATTR_SELFTESTS_MASK])
>+		return -EINVAL;
>+
>+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>+	if (!msg)
>+		return -ENOMEM;
>+
>+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
>+			  &devlink_nl_family, 0, DEVLINK_CMD_SELFTESTS_RUN);
>+	if (!hdr)
>+		goto free_msg;
>+
>+	if (devlink_nl_put_handle(msg, devlink))
>+		goto genlmsg_cancel;
>+
>+	tests_mask = nla_get_u32(info->attrs[DEVLINK_ATTR_SELFTESTS_MASK]);
>+
>+	devlink->ops->selftests_run(devlink, tests_mask, test_results,

Why don't you run it 1 by 1 and fill up the NL message 1 by 1 too?


>+				    info->extack);
>+	tests = tests_mask;
>+
>+	for_each_set_bit(test, &tests, __DEVLINK_SELFTEST_MAX_BIT) {
>+		err = devlink_selftest_result_put(msg, test,
>+						  test_results[test]);
>+		if (err)
>+			goto genlmsg_cancel;
>+	}
>+
>+	genlmsg_end(msg, hdr);
>+
>+	return genlmsg_reply(msg, info);
>+
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
>@@ -9000,6 +9130,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
> 	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
> 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
> 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
>+	[DEVLINK_ATTR_SELFTESTS_MASK] = NLA_POLICY_MASK(NLA_U32,
>+							DEVLINK_SELFTESTS_MASK),
> };
> 
> static const struct genl_small_ops devlink_nl_ops[] = {
>@@ -9361,6 +9493,18 @@ static const struct genl_small_ops devlink_nl_ops[] = {
> 		.doit = devlink_nl_cmd_trap_policer_set_doit,
> 		.flags = GENL_ADMIN_PERM,
> 	},
>+	{
>+		.cmd = DEVLINK_CMD_SELFTESTS_SHOW,
>+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>+		.doit = devlink_nl_cmd_selftests_show,

Why don't dump?


>+		.flags = GENL_ADMIN_PERM,
>+	},
>+	{
>+		.cmd = DEVLINK_CMD_SELFTESTS_RUN,
>+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
>+		.doit = devlink_nl_cmd_selftests_run,
>+		.flags = GENL_ADMIN_PERM,
>+	},
> };
> 
> static struct genl_family devlink_nl_family __ro_after_init = {
>-- 
>2.31.1
>


