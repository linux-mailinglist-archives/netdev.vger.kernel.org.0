Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3176B57123E
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 08:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbiGLG3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 02:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiGLG3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 02:29:00 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C9DB852;
        Mon, 11 Jul 2022 23:28:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/Velo1h4xSKKvS73lGM1HqI61+GMuWGnrf3DdmOLDxvWIWaMAAxvNhzV9JO8smBdp7oTRiOZ1NKXD4QhIoH2zykaoR/THaayRZZOEAekbHBqq7EVuL+RsKaTmIVUvl7W/QpENZNj8sou3dvLPmrBywkyt4kyoK8dnYcrE3yGE7jxk1SA/UWDHB0jTCZmgDKGUJ1eRfcaPVDvdCpvlfYwrjCu0AzxgFD7LQnbGhbQz2Ra1/Pv0Fjs0vunEaXw9q8m2jDELzyi7S8UuwbHxMNkfl6KtDtX+JiZMvsCpuMngo32MZYTa+qXfbrSLLRa1dV13bd0kEITxhx8JHquXDoLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvS6qx61rH9wpbuv9X0bRuLu8MlUCGzksxB0/LKZRJ4=;
 b=f2Jbnlpusg1GABBMWueGx31EVdn6Am/wzxGjRG1W9zejGmi/u2o1/wCkNe6SDBepeRPW6omdu0g2JkVAqgJTW0rc717gU308jzNrq9hrmkups7JxMhhux0sF+6l7/WbhSXT8KpHpeFZvV/gZAySenh/X6GdW+aoZ1GFRCDMbU9rvvkwk8GFIR+JGQ2FzJP3A5Ju4ZMqflvGdQwwKLsDSEHabwgJivKwcZ3gpq97FmjV2HqxBKCUFgWBOsyLu8zFsHx7nP3E2+9emt0OfEw7BP5Bv74KgbX0yaAN+mdzTr2xs9JoxhfnG/h1ZhXH8MJFTaeHJaqLKrrwaIOEeNTggbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvS6qx61rH9wpbuv9X0bRuLu8MlUCGzksxB0/LKZRJ4=;
 b=SeBbxWTnR0EnZMoNu8Y3GARkxy7ntIGPFKFmjJVQP8U4AA/aq47rkxNT4FJqgjL7I0LsR3/+H+sx72Ibt5oZlE0y1iy1rnzkLcfIRlZ7hT2hHZ5kDWrb0/vy2lr6YbOmlbNjekO2Ca/Wr78p5bQ3MIsAEcVC8aWFjCGdRePVkSOsndPfWbMaJcCwZwBB/fcMtSo/Oj8d1/Xzt9Kim3WpIHgfCTX8H67oCNd/tX5LA/qcZx/50rtBVxL2WCwkjznAP056V2bbemw13p0NMMoYGJWtE4qAI0f75pPAIvFHFFAO4k9HDshVG3YlPDcxk0S2TBrbsVk883QNyrZ+bhpF1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Tue, 12 Jul
 2022 06:28:57 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282%3]) with mapi id 15.20.5417.023; Tue, 12 Jul 2022
 06:28:57 +0000
Date:   Tue, 12 Jul 2022 08:28:52 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, dsahern@kernel.org,
        stephen@networkplumber.org, Eric Dumazet <edumazet@google.com>,
        pabeni@redhat.com, ast@kernel.org, leon@kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net,
        Michael Chan <michael.chan@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next v2 1/3] devlink: introduce framework for
 selftests
Message-ID: <Ys0UpFtcOGWjK/sZ@nanopsycho>
References: <20220628164241.44360-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-2-vikas.gupta@broadcom.com>
 <YswaKcUs6nOndU2V@nanopsycho>
 <CAHLZf_t9ihOQPvcQa8cZsDDVUX1wisrBjC30tHG_-Dz13zg=qQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHLZf_t9ihOQPvcQa8cZsDDVUX1wisrBjC30tHG_-Dz13zg=qQ@mail.gmail.com>
X-ClientProxiedBy: FR0P281CA0050.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::13) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2d9429f-92a5-44f1-e00f-08da63cfcc8e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5971:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y+czXr2OQ+bxR2ORHyJkAz8XqtMsmgPbx9PJ4u5SX42kNSOPcbDKdO5T0D1RP7CM9JOqYinu9gkU4H3i2iOdZfyE9Ex3gxmMGQebuY4jS1yyS6DF72JCyeQwLzH2dYphnlnBZv4jgMnat+GubwUa3gOLC+yo2CUTbieVj8ccKkQhw7F8UUmwTr8Z4gKvh8AV/tuvwM02XcB5bE5QiU/MCAVViDGERuJWKSw/ERwweD7XuYLrJesP/WAV2dSASFHe+f1WTC6Ugsgogg9+eEC3cYMYZeuzK93Nn7l9AujN/BpuT1lpRaLef4ROIwQBdl1zFzXkFMLobUwLLoot4i31mUMkJozey6/bmXqq0Am7EEdBKtkkF/Es7mQ8h7ROk+6CQPSSRhUZgq1AlEFmskjqllzUS8n0qyPsI9GOTJIZOYaNPPj0dCVvEwilM8Zsn1Pc6VUXKa/JjRH3qseCGvuDMHczRRWK1m9GQ+meuC3kacjmX5v8UUb7X4sZui8dUeNlih7odE69lr8OKJMwuvH3VedEqpN4DZ8vk3AzL/43qj8IlnQlzYUbw8agsGQDbTJb4c7F6nAHXkrDl4/CVEuLnqekdXfEMbMmBNY35VEEkifWDEsXkghKMThkYhtv4G+gJ/3n4v/VOJjCM290x9aAaLdrIOgb+lOpI8sJlV9t8uxkK9Xd3BrqOmoekDVWO4bsQHlXUh0H5jGY+R1LinwlqfE4Ray1aq/EBnt8RNWaWsRYx9FrREiKVjDZfKaMp9G9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(54906003)(6916009)(5660300002)(86362001)(8936002)(66476007)(66556008)(316002)(38100700002)(6506007)(66946007)(9686003)(8676002)(26005)(41300700001)(4326008)(6512007)(33716001)(186003)(6666004)(83380400001)(7416002)(478600001)(2906002)(6486002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kAnRVKaZbRSLhghszA+Xpc8Ydza71GIC+bJH/Py+ncLvy+oY/H3adKfv7PSW?=
 =?us-ascii?Q?K3fUnrCcr1wxIIgm1lQnRBwmFXU9ccg1kUsCUyEi+rd14vYCYuBNGlxWrybg?=
 =?us-ascii?Q?XlUVQZsq3FAP1swHXfGvrJQO5BXNojnXKsIyH+ysDt6DGDEi10S5MT+3l3vL?=
 =?us-ascii?Q?fbz2slcA8yr8wxlUDTgQlV0emvxsGcuT4j78VuT8yC9SM9tl33OsH9KRm5Ez?=
 =?us-ascii?Q?Ah7cuAOB5n7vP++5kSKKXfTy55Bdp/OKypoTc9sJ+6A61R8aC4pWZIUADoKP?=
 =?us-ascii?Q?kx/YaWyIqA23wqaEJdf/KtfhKs0URoq7eEcHjwMLRZHbcPTMlWK0RcbJ15YT?=
 =?us-ascii?Q?rYiOorlrSQdH1OfZ2La8pMSfkXOG5HdF0k/5HVpdQcEKaVfYtPCOi9v1NFCJ?=
 =?us-ascii?Q?A4xOp+JGO6HldYCKhseWtkInamqGk5dvs3EvUZ7ZemtgeJwl4ZmLvfLJrfIq?=
 =?us-ascii?Q?eUEJ4u6F2GJbsIac9XpVwUDhLRFOoGZOP8i6T4IHbJntjJnjxrX4ywNYFgNo?=
 =?us-ascii?Q?tF0EuRTc0o2WQ+FPZSj6B8YWCbx4jvibjI/UYvEaxX8SWhRRA4f8MzzP1xnt?=
 =?us-ascii?Q?puOjh7MCSr6kN1Oq4/I/ZTqNAjK0b1pOAJLEQJG3BF5WMcJzwP34IZiqMHuL?=
 =?us-ascii?Q?D9Tu5y+fFJ1izFGyR0/2kGuwPdNUOqc56Q5c1ckcc+OUKEkDxRamH17SeCYc?=
 =?us-ascii?Q?qJT+q2YXOplYJ0LFx6UL5bAP2fcLI0aZwhz57oAfVT2CLE+eUv9boJ1+BgdT?=
 =?us-ascii?Q?k/Yz3rC9zhFZmhHPilXF5MK2fgRBgxexg8MP/m1fwJHnkYSjyJyW8dYh1wdi?=
 =?us-ascii?Q?PgmV/ydRaQV9DNLgEbj4E18+5jSMu+DG1bv3AQGwOipoq/2Ud8R6J/Gv2AJo?=
 =?us-ascii?Q?IlbSSUFwd5HmvidxddCTkj6DtymOyItyMZgn82ADb//XbOcPEUjP/hFThtHP?=
 =?us-ascii?Q?1/vzh8qzOzkm1cTBauZDW4Xdqnf6tU25TJDeUIGrARIcqtle3LUKn9Z5WA/V?=
 =?us-ascii?Q?xkWzGnoAZJ6DnVOXBz+NvlXOeLGPB+pBo+YBUCBrrJjuLRWArDtFi+64mvwd?=
 =?us-ascii?Q?IBsLt+KtPkiQRyf8iyciz+IzSN7vMhB/sdmFp67md1NrXI+ycAc/2Gm0GX1f?=
 =?us-ascii?Q?+/8CXPDTrCgzsaGKUqL+8OLQ3/zoADl1O1MkNZz7uMtjYze6Y5bJR2Xb04NL?=
 =?us-ascii?Q?oZiytNm8R6ey6GC3QsIfBoQg07DUAb/e/dVhaXbsfXkawdrq/lA5FkbNet8q?=
 =?us-ascii?Q?TNUXMLibyDlHLatUg22QvTX2j95unUwrFkuIB0+Vnq+P8X867rDb+Y8DvvsJ?=
 =?us-ascii?Q?07VnibUV71xf2V/LwP0NH0YLXAWJB3x4AGUBatlhsOSrJdeMZW3/fW05e3Hr?=
 =?us-ascii?Q?SNFLp4q7H2lW2SH8qnRBBj3IhXsJCz1LE9FBIpBa70HR7nj4pPz9V8Lej99n?=
 =?us-ascii?Q?EnF++wHvgc8yrUOh2agEAopNDb0W4wtNJ/Q1uTRSrRIe3ZnSZb/zc7NMCxW9?=
 =?us-ascii?Q?/aHpW7BVmZLWi8vS62BSOVG1JFq20JLuL9g1UP4+ajWtBgSEctv9rXYu3zaw?=
 =?us-ascii?Q?HJMZLxPHlIUFL+h6YnE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d9429f-92a5-44f1-e00f-08da63cfcc8e
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 06:28:56.9985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rgAsxnuj/FP5ukg693ADH0yEn5bhUQFc6KXZlqia4pUGbfKybURb9Fz8z8dZh+jV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 12, 2022 at 08:16:11AM CEST, vikas.gupta@broadcom.com wrote:
>Hi Jiri,
>
>On Mon, Jul 11, 2022 at 6:10 PM Jiri Pirko <jiri@nvidia.com> wrote:
>
>> Thu, Jul 07, 2022 at 08:29:48PM CEST, vikas.gupta@broadcom.com wrote:
>> >Add a framework for running selftests.
>> >Framework exposes devlink commands and test suite(s) to the user
>> >to execute and query the supported tests by the driver.
>> >
>> >Below are new entries in devlink_nl_ops
>> >devlink_nl_cmd_selftests_show: To query the supported selftests
>> >by the driver.
>> >devlink_nl_cmd_selftests_run: To execute selftests. Users can
>> >provide a test mask for executing group tests or standalone tests.
>> >
>> >Documentation/networking/devlink/ path is already part of MAINTAINERS &
>> >the new files come under this path. Hence no update needed to the
>> >MAINTAINERS
>> >
>> >Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
>> >Reviewed-by: Michael Chan <michael.chan@broadcom.com>
>> >Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
>> >---
>> > .../networking/devlink/devlink-selftests.rst  |  34 +++++
>> > include/net/devlink.h                         |  30 ++++
>> > include/uapi/linux/devlink.h                  |  26 ++++
>> > net/core/devlink.c                            | 144 ++++++++++++++++++
>> > 4 files changed, 234 insertions(+)
>> > create mode 100644 Documentation/networking/devlink/devlink-selftests.rst
>> >
>> >diff --git a/Documentation/networking/devlink/devlink-selftests.rst
>> b/Documentation/networking/devlink/devlink-selftests.rst
>> >new file mode 100644
>> >index 000000000000..796d38f77038
>> >--- /dev/null
>> >+++ b/Documentation/networking/devlink/devlink-selftests.rst
>> >@@ -0,0 +1,34 @@
>> >+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> >+
>> >+=================
>> >+Devlink Selftests
>> >+=================
>> >+
>> >+The ``devlink-selftests`` API allows executing selftests on the device.
>> >+
>> >+Tests Mask
>> >+==========
>> >+The ``devlink-selftests`` command should be run with a mask indicating
>> >+the tests to be executed.
>> >+
>> >+Tests Description
>> >+=================
>> >+The following is a list of tests that drivers may execute.
>> >+
>> >+.. list-table:: List of tests
>> >+   :widths: 5 90
>> >+
>> >+   * - Name
>> >+     - Description
>> >+   * - ``DEVLINK_SELFTEST_FLASH``
>> >+     - Runs a flash test on the device.
>> >+
>> >+example usage
>> >+-------------
>> >+
>> >+.. code:: shell
>> >+
>> >+    # Query selftests supported on the device
>> >+    $ devlink dev selftests show DEV
>> >+    # Executes selftests on the device
>> >+    $ devlink dev selftests run DEV test {flash | all}
>> >diff --git a/include/net/devlink.h b/include/net/devlink.h
>> >index 2a2a2a0c93f7..cb7c378cf720 100644
>> >--- a/include/net/devlink.h
>> >+++ b/include/net/devlink.h
>> >@@ -1215,6 +1215,18 @@ enum {
>> >       DEVLINK_F_RELOAD = 1UL << 0,
>> > };
>> >
>> >+#define DEVLINK_SELFTEST_FLASH_TEST_NAME "flash"
>> >+
>> >+static inline const char *devlink_selftest_name(int test)
>>
>> I don't understand why this is needed. Better not to expose string to
>> the user. Just have it as well defined attr.
>
>
> OK. Will remove this function and corresponding attr
>DEVLINK_ATTR_TEST_NAME added in this patch.
>
>
>
>
>>
>> >+{
>> >+      switch (test) {
>> >+      case DEVLINK_SELFTEST_FLASH_BIT:
>> >+              return DEVLINK_SELFTEST_FLASH_TEST_NAME;
>> >+      default:
>> >+              return "unknown";
>> >+      }
>> >+}
>> >+
>> > struct devlink_ops {
>> >       /**
>> >        * @supported_flash_update_params:
>> >@@ -1509,6 +1521,24 @@ struct devlink_ops {
>> >                                   struct devlink_rate *parent,
>> >                                   void *priv_child, void *priv_parent,
>> >                                   struct netlink_ext_ack *extack);
>> >+      /**
>> >+       * selftests_show() - Shows selftests supported by device
>> >+       * @devlink: Devlink instance
>> >+       * @extack: extack for reporting error messages
>> >+       *
>> >+       * Return: test mask supported by driver
>> >+       */
>> >+      u32 (*selftests_show)(struct devlink *devlink,
>> >+                            struct netlink_ext_ack *extack);
>> >+      /**
>> >+       * selftests_run() - Runs selftests
>> >+       * @devlink: Devlink instance
>> >+       * @tests_mask: tests to be run by driver
>> >+       * @results: test results by driver
>> >+       * @extack: extack for reporting error messages
>> >+       */
>> >+      void (*selftests_run)(struct devlink *devlink, u32 tests_mask,
>> >+                            u8 *results, struct netlink_ext_ack *extack);
>> > };
>> >
>> > void *devlink_priv(struct devlink *devlink);
>> >diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> >index b3d40a5d72ff..1dba262328b9 100644
>> >--- a/include/uapi/linux/devlink.h
>> >+++ b/include/uapi/linux/devlink.h
>> >@@ -136,6 +136,9 @@ enum devlink_command {
>> >       DEVLINK_CMD_LINECARD_NEW,
>> >       DEVLINK_CMD_LINECARD_DEL,
>> >
>> >+      DEVLINK_CMD_SELFTESTS_SHOW,
>> >+      DEVLINK_CMD_SELFTESTS_RUN,
>> >+
>> >       /* add new commands above here */
>> >       __DEVLINK_CMD_MAX,
>> >       DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
>> >@@ -276,6 +279,25 @@ enum {
>> > #define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
>> >       (_BITUL(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)
>> >
>> >+/* Commonly used test cases */
>> >+enum {
>> >+      DEVLINK_SELFTEST_FLASH_BIT,
>> >+
>> >+      __DEVLINK_SELFTEST_MAX_BIT,
>> >+      DEVLINK_SELFTEST_MAX_BIT = __DEVLINK_SELFTEST_MAX_BIT - 1
>> >+};
>> >+
>> >+#define DEVLINK_SELFTEST_FLASH _BITUL(DEVLINK_SELFTEST_FLASH_BIT)
>> >+
>> >+#define DEVLINK_SELFTESTS_MASK \
>> >+      (_BITUL(__DEVLINK_SELFTEST_MAX_BIT) - 1)
>> >+
>> >+enum {
>> >+      DEVLINK_SELFTEST_SKIP,
>> >+      DEVLINK_SELFTEST_PASS,
>> >+      DEVLINK_SELFTEST_FAIL
>> >+};
>> >+
>> > /**
>> >  * enum devlink_trap_action - Packet trap action.
>> >  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy
>> is not
>> >@@ -576,6 +598,10 @@ enum devlink_attr {
>> >       DEVLINK_ATTR_LINECARD_TYPE,             /* string */
>> >       DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,  /* nested */
>> >
>> >+      DEVLINK_ATTR_SELFTESTS_MASK,            /* u32 */
>>
>> I don't see why this is u32 bitset. Just have one attr per test
>> (NLA_FLAG) in a nested attr instead.
>>
>
>As per your suggestion, for an example it should be like as below
>
>        DEVLINK_ATTR_SELFTESTS,                 /* nested */
>
>        DEVLINK_ATTR_SELFTESTS_SOMETEST1            /* flag */
>
>        DEVLINK_ATTR_SELFTESTS_SOMETEST2           /* flag */

Yeah, but have the flags in separate enum, no need to pullute the
devlink_attr enum by them.


>
>....    <SOME MORE TESTS>
>
>.....
>
>        DEVLINK_ATTR_SLEFTESTS_RESULT_VAL,      /* u8 */
>
>
>
> If we have this way then we need to have a mapping (probably a function)
>for drivers to tell them what tests need to be executed based on the flags
>that are set.
> Does this look OK?
>  The rationale behind choosing a mask is that we could directly pass the
>mask-value to the drivers.

If you have separate enum, you can use the attrs as bits internally in
kernel. Add a helper that would help the driver to work with it.
Pass a struct containing u32 (or u8) not to drivers. Once there are more
tests than that, this structure can be easily extended and the helpers
changed. This would make this scalable. No need for UAPI change or even
internel driver api change.


>
>
>>
>>
>>
>> >+      DEVLINK_ATTR_TEST_RESULT,               /* nested */
>> >+      DEVLINK_ATTR_TEST_NAME,                 /* string */
>> >+      DEVLINK_ATTR_TEST_RESULT_VAL,           /* u8 */
>>
>> Could you maintain the same "namespace" for all attrs related to
>> selftests?
>>
>
>Will fix it.
>
>
>>
>> >       /* add new attributes above here, update the policy in devlink.c */
>> >
>> >       __DEVLINK_ATTR_MAX,
>> >diff --git a/net/core/devlink.c b/net/core/devlink.c
>> >index db61f3a341cb..0b7341ab6379 100644
>> >--- a/net/core/devlink.c
>> >+++ b/net/core/devlink.c
>> >@@ -4794,6 +4794,136 @@ static int devlink_nl_cmd_flash_update(struct
>> sk_buff *skb,
>> >       return ret;
>> > }
>> >
>> >+static int devlink_selftest_name_put(struct sk_buff *skb, int test)
>> >+{
>> >+      const char *name = devlink_selftest_name(test);
>> >+      if (nla_put_string(skb, DEVLINK_ATTR_TEST_NAME, name))
>> >+              return -EMSGSIZE;
>> >+
>> >+      return 0;
>> >+}
>> >+
>> >+static int devlink_nl_cmd_selftests_show(struct sk_buff *skb,
>> >+                                       struct genl_info *info)
>> >+{
>> >+      struct devlink *devlink = info->user_ptr[0];
>> >+      struct sk_buff *msg;
>> >+      unsigned long tests;
>> >+      int err = 0;
>> >+      void *hdr;
>> >+      int test;
>> >+
>> >+      if (!devlink->ops->selftests_show)
>> >+              return -EOPNOTSUPP;
>> >+
>> >+      msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> >+      if (!msg)
>> >+              return -ENOMEM;
>> >+
>> >+      hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
>> >+                        &devlink_nl_family, 0,
>> DEVLINK_CMD_SELFTESTS_SHOW);
>> >+      if (!hdr)
>> >+              goto free_msg;
>> >+
>> >+      if (devlink_nl_put_handle(msg, devlink))
>> >+              goto genlmsg_cancel;
>> >+
>> >+      tests = devlink->ops->selftests_show(devlink, info->extack);
>> >+
>> >+      for_each_set_bit(test, &tests, __DEVLINK_SELFTEST_MAX_BIT) {
>> >+              err = devlink_selftest_name_put(msg, test);
>> >+              if (err)
>> >+                      goto genlmsg_cancel;
>> >+      }
>> >+
>> >+      genlmsg_end(msg, hdr);
>> >+
>> >+      return genlmsg_reply(msg, info);
>> >+
>> >+genlmsg_cancel:
>> >+      genlmsg_cancel(msg, hdr);
>> >+free_msg:
>> >+      nlmsg_free(msg);
>> >+      return err;
>> >+}
>> >+
>> >+static int devlink_selftest_result_put(struct sk_buff *skb, int test,
>> >+                                     u8 result)
>> >+{
>> >+      const char *name = devlink_selftest_name(test);
>> >+      struct nlattr *result_attr;
>> >+
>> >+      result_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_TEST_RESULT);
>> >+      if (!result_attr)
>> >+              return -EMSGSIZE;
>> >+
>> >+      if (nla_put_string(skb, DEVLINK_ATTR_TEST_NAME, name) ||
>> >+          nla_put_u8(skb, DEVLINK_ATTR_TEST_RESULT_VAL, result))
>> >+              goto nla_put_failure;
>> >+
>> >+      nla_nest_end(skb, result_attr);
>> >+
>> >+      return 0;
>> >+
>> >+nla_put_failure:
>> >+      nla_nest_cancel(skb, result_attr);
>> >+      return -EMSGSIZE;
>> >+}
>> >+
>> >+static int devlink_nl_cmd_selftests_run(struct sk_buff *skb,
>> >+                                      struct genl_info *info)
>> >+{
>> >+      u8 test_results[DEVLINK_SELFTEST_MAX_BIT + 1] = {};
>> >+      struct devlink *devlink = info->user_ptr[0];
>> >+      unsigned long tests;
>> >+      struct sk_buff *msg;
>> >+      u32 tests_mask;
>> >+      void *hdr;
>> >+      int err = 0;
>> >+      int test;
>> >+
>> >+      if (!devlink->ops->selftests_run)
>> >+              return -EOPNOTSUPP;
>> >+
>> >+      if (!info->attrs[DEVLINK_ATTR_SELFTESTS_MASK])
>> >+              return -EINVAL;
>> >+
>> >+      msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> >+      if (!msg)
>> >+              return -ENOMEM;
>> >+
>> >+      hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
>> >+                        &devlink_nl_family, 0,
>> DEVLINK_CMD_SELFTESTS_RUN);
>> >+      if (!hdr)
>> >+              goto free_msg;
>> >+
>> >+      if (devlink_nl_put_handle(msg, devlink))
>> >+              goto genlmsg_cancel;
>> >+
>> >+      tests_mask = nla_get_u32(info->attrs[DEVLINK_ATTR_SELFTESTS_MASK]);
>> >+
>> >+      devlink->ops->selftests_run(devlink, tests_mask, test_results,
>>
>> Why don't you run it 1 by 1 and fill up the NL message 1 by 1 too?
>>
>>      I`ll consider it in the next patch set.

Please do. This array of results returned from driver looks sloppy.


>
>
>>
>> >+                                  info->extack);
>> >+      tests = tests_mask;
>> >+
>> >+      for_each_set_bit(test, &tests, __DEVLINK_SELFTEST_MAX_BIT) {
>> >+              err = devlink_selftest_result_put(msg, test,
>> >+                                                test_results[test]);
>> >+              if (err)
>> >+                      goto genlmsg_cancel;
>> >+      }
>> >+
>> >+      genlmsg_end(msg, hdr);
>> >+
>> >+      return genlmsg_reply(msg, info);
>> >+
>> >+genlmsg_cancel:
>> >+      genlmsg_cancel(msg, hdr);
>> >+free_msg:
>> >+      nlmsg_free(msg);
>> >+      return err;
>> >+}
>> >+
>> > static const struct devlink_param devlink_param_generic[] = {
>> >       {
>> >               .id = DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
>> >@@ -9000,6 +9130,8 @@ static const struct nla_policy
>> devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>> >       [DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
>> >       [DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
>> >       [DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
>> >+      [DEVLINK_ATTR_SELFTESTS_MASK] = NLA_POLICY_MASK(NLA_U32,
>> >+
>> DEVLINK_SELFTESTS_MASK),
>> > };
>> >
>> > static const struct genl_small_ops devlink_nl_ops[] = {
>> >@@ -9361,6 +9493,18 @@ static const struct genl_small_ops
>> devlink_nl_ops[] = {
>> >               .doit = devlink_nl_cmd_trap_policer_set_doit,
>> >               .flags = GENL_ADMIN_PERM,
>> >       },
>> >+      {
>> >+              .cmd = DEVLINK_CMD_SELFTESTS_SHOW,
>> >+              .validate = GENL_DONT_VALIDATE_STRICT |
>> GENL_DONT_VALIDATE_DUMP,
>> >+              .doit = devlink_nl_cmd_selftests_show,
>>
>> Why don't dump?
>>
>
>  I`ll add a dump in the next patchset.
>
>Thanks,
>Vikas
>
>
>>
>>
>> >+              .flags = GENL_ADMIN_PERM,
>> >+      },
>> >+      {
>> >+              .cmd = DEVLINK_CMD_SELFTESTS_RUN,
>> >+              .validate = GENL_DONT_VALIDATE_STRICT |
>> GENL_DONT_VALIDATE_DUMP,
>> >+              .doit = devlink_nl_cmd_selftests_run,
>> >+              .flags = GENL_ADMIN_PERM,
>> >+      },
>> > };
>> >
>> > static struct genl_family devlink_nl_family __ro_after_init = {
>> >--
>> >2.31.1
>> >
>>
>>
>>


