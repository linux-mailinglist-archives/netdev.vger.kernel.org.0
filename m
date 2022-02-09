Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6C94AEDFD
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiBIJ0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:26:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiBIJ0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:26:17 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0606.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::606])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DAAE01D5D6
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 01:26:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPXofw/15K4933CsrU9YaRNhUb2ZESwCDsrWWpUZPDwSbK/eyrdR6F7OEbWFP/SCho7nmjpz8+THETB5mcmOizvt5ex77YKycmq/TFcsYEkPyUwFgEWZlHbAX+0vhQsykIozFGAPpuqTZ3Rrw4e8VDwAlOoX/twiFBuS+g9oXUus26gPbLPTuDVEU+xetxMXiB6Oe6u1ZUIJ2XmTNHuodAc18rPriXQX4prv/0hBTLG1hAUoccg0ZQ0zI4lTj395tL1+lT/xLR6Gnw76C8Yiwu/nBW3oUPgQalP6Ju+gsfJCJLlMQGMtqgnDGKrahpN8vCI2xoVwAP7UGdcOgSH3jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3sDNXBcDbrLOAZwvhmHds7YjINQKzlK4qsorA00EPI=;
 b=DZ5wEnEM4t/ZBPDo6rJkz1J2zqiu1B1FxXN5om3swt87RDwJMzYzAz0AL1dor6VBP7RE0sMKnBi6XBaz+A4sXiQnf4LeolaYJcdw3QqrAFiDRXZf1GmbIINiwu8Pxx9d5+KsXV8LXzSWJOe95b9Q/+TNFhx5tqAoKqsB07+YB5qvfqUOWI8Z9kNINDRMBQIbFFAYVN7CbqKV4qo1VT+yY39O2hqSxAD/05nCmqGhbv1GxPHjdzGdww9WtGPcjVbOLp8CBZFx97lg0rmOUhAA7lIA5jHqNpFN2Y833W0FJZHMUiBbfkn4sVfeLkvFSwbr6UMb40Krfawn4pBq54riYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3sDNXBcDbrLOAZwvhmHds7YjINQKzlK4qsorA00EPI=;
 b=rboKlxLFIUxf2ugsrrs3NjLHlFkMRENp0mIJ56fV9DdMJvvmSrHYLX0frBtDGvAnwI1BDo1aQhdX2uqY+vMFFLH98mxdKb20hCYFT8txRbRC8ZNPoZXCsPrF2xPI05DducEDXho+yy9Ff1vuwMLsbgf3O4mRBdsT1JnQuaIC0OY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB5423.eurprd04.prod.outlook.com (2603:10a6:803:da::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Wed, 9 Feb
 2022 09:23:59 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::5df9:5bf0:7ac1:a793%9]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 09:23:59 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/7] dpaa2-eth: add support for software TSO
Date:   Wed,  9 Feb 2022 11:23:28 +0200
Message-Id: <20220209092335.3064731-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0037.eurprd03.prod.outlook.com (2603:10a6:208::14)
 To AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4a1e167-24e1-4ecf-416a-08d9ebade6f8
X-MS-TrafficTypeDiagnostic: VI1PR04MB5423:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB54231194CF0D7CE09922A466E02E9@VI1PR04MB5423.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vp0MnWKpkFJavYYZK+oGZrtXCgjEWn0Z2/B3AIv61+XNo3aqw+lMf7pA9i1Y24p1Xgdecd6KZo1PfoIx2h1p8/SRsHaVG4BnXFYN/UeLYZkNOgWOfgOWXjvPjuB7rJjse/LJmQMbNjvbSKFqaX0PaAnBApCFTynIE7FIFwmusSGCUatW5aQjms9Xl5K+dHjBMaT44NVSk0QgJt0FYaX6YXO3r0VaS/tSjq2LAEHRLDpONSYDr76eHFXj1NLLK/iubrL/FpkvGqvAdil7j3KYP7hf/r+ZB+LERoJV43z7QFb7ZE/MPQK5z0fQSrL/iXH/OvNIkRMALispHXF/YezRxw0PTDDvIqwez2BWGqdY1CLH828cK/AHYwz+jkiAVi3vEtevYZpnm5RUUCtDoxIkRw5gTmiI3FFqXvtC36tli+9UQ1VFcGBwNhezDAjd47RGUN9pEbX06P+TEkp+lHaflsdqJEU99Yk0ycQsjT8T3r31iOys5y2f8sSwAntqYD/RRmO7N3/N/nnmiAwCfnpapQ7dQzKWnXvUjhNDzdx4Ow1ucMEdIgiSCwBhhsNrvI96SPvRtnwD/41oE88Xb015x9QoaixWGvHHW8ZNebU48Zc+2kzk40/bMvySVG8b9iXwaXweATSTzyHoyXsTryYd21M1DMUGqbSiCKU3YbVFZIFVMBJuTcl3ZhoQNqG5DyoGEV+4hFxwn8A0GUBKTLWqQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(83380400001)(66556008)(66476007)(8936002)(4326008)(8676002)(2906002)(1076003)(26005)(36756003)(6486002)(5660300002)(44832011)(52116002)(66946007)(86362001)(38350700002)(508600001)(38100700002)(186003)(316002)(6506007)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q5Luo9bigm5Ibbk/2B2jZYNK0EHwj7FEjmR1V0B9lJ9awDrkXuwJEbnO+WXy?=
 =?us-ascii?Q?aFA9Gs0+JOjTHhG+cq4SJ3yu7Sf6OQvYYiEoIb7bFc1Ie8mG8eyqAGRglfiI?=
 =?us-ascii?Q?E/zYhAqpCMcVZf3hizgkHzuwLFwIKFStpawJXW4O75jVE1t7nrqfRvt95J6u?=
 =?us-ascii?Q?sHVHJ2hFXNeKAGgs7aJkgznMkGdEjbxtPSW689TZ0NoTLk0sBDSK0z2flyZZ?=
 =?us-ascii?Q?ptLrE9AJEgxBPb4EsT5Slro1JMVCcqtf2cwFQPW3BgMCakHhcSHavoRX5FBs?=
 =?us-ascii?Q?IURMTg7mWmwB2NmeYm/7oyfbdaclwPMjmmJjFRSg1oFhWeIs9a4MkXRxvoPh?=
 =?us-ascii?Q?UR0uQRcUttNBipr4BBiJ3YCbxkAGWCqtuTT2TjeVQF246bEHy8OcLMoAmT82?=
 =?us-ascii?Q?sM6YXDyh39hE0Lu/rb2Me8QK9gW2gsHSgsONLgK0S1MAdGc2Y8n9H0uCxRiu?=
 =?us-ascii?Q?Ru4lYoIVeMZ+83mY2Jz8SHlxIBaQZpmN2V02Z9onDOOtFa77e53ugTAmVitv?=
 =?us-ascii?Q?UODcp/ObU/O8KfIc/V/NWEeP/JruKD6dW57aQqCnHFq3JxMjmOhyPMGNtRVK?=
 =?us-ascii?Q?f7ayzhCluZzPFT05seVT7tuY2JYhbC6ao6Oh2XygRkFq6Flt6+Xjs9auRnTq?=
 =?us-ascii?Q?8LhjY28qpjZc1UiRoWHPyR9msEjEc3mJdCoV451eds3h7FPwIPal/TpSqqbc?=
 =?us-ascii?Q?rx3LhKH5qDD3d2FyuJMvulUi1tP77eOzvIWf///iE44t2t5jOjfdV9KNDDWW?=
 =?us-ascii?Q?ttXs5GhgvxPnCjdn7qGbKN9WLuex0QcF2zZ0oPLXKXwWfDtOwLQVpk4oXmBO?=
 =?us-ascii?Q?ixnPqOH8NgFN1osRsspBJ12yQj7sIpWhwFQ+WI3S0S6UiQWDLEFpU8dlnNXP?=
 =?us-ascii?Q?rRgIWZLw/taOV662jPDr4BjfRE2PRWeOXcZLBwNlfYjzxm0ldbezpSpfqCcg?=
 =?us-ascii?Q?9CJOTZE/BQZjwRuDM2n0w0ggNBXYSpMYb5OdKspUU+/BL4HDyHMGu6notRox?=
 =?us-ascii?Q?YLpXhk6TGJccit/FdLbOgPYIVrDtBCptCg376ZtTRKYJSMuXkRIOQ7R9Wob7?=
 =?us-ascii?Q?DsONaeZtlPTsY8VpoXEa3MyjBizuzPybu/UGejp4lXGcwwv1cO4xuz3fETf8?=
 =?us-ascii?Q?IxmbAHmFpLnG78IoszJCvxtpmP/HcAl4nzOZPSW9sKBqtlPIY786zcOJkXOF?=
 =?us-ascii?Q?gSMlbgoHN/GZifX02WwJaUWs3uVyHA/Kei1HxSQp10ou0fz0prG6Xropb2sI?=
 =?us-ascii?Q?YobPhpUSS82oZyeMDdJ0vWbXcGFdiqctT/r86Nh7rL/k7Ik1G+EhJEuuRBqX?=
 =?us-ascii?Q?OwTGyH/i73wYguuH0jmBJuQIGauH1/2kZVpVQA4kG2+Z1W73S8wV2DynmXF/?=
 =?us-ascii?Q?8tIIpxl9qHYVu8YmadydwzmC0gOCxbDRmuYLNaxR1g48gzVLsY20FKvFmyCE?=
 =?us-ascii?Q?nCl6X3/hmDcvSL9tXvllGRM1uzKfSihR4lxIr08BygLujZNmpkbn6ByRnDym?=
 =?us-ascii?Q?GTOUSKUAWk5Qmhsmyw8jjYq+S48jKlCxPCfgNzmZdn+Abp+4tia5fLI0GlfC?=
 =?us-ascii?Q?08GE05QkQYXaPEaXd3oXADehuJkMydWsw32kwSGZib620QPgCORUXfzCgizb?=
 =?us-ascii?Q?aYobdKz8GyM0jtHuVc1McHM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4a1e167-24e1-4ecf-416a-08d9ebade6f8
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 09:23:59.3267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ym1cCUccrfc6kFlWX05rk8Vrlroo9t6wEryVU9hnxPUmjXk3+cjTZfwdT8GDTGSPlcYBg1GwAwGUUfVWCL3p/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5423
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for driver level TSO in the dpaa2-eth driver.

The first 5 patches lay the ground work for the actual feature:
rearrange some variable declaration, cleaning up the interraction with
the S/G Table buffer cache etc.

The 6th patch adds the actual driver level software TSO support by using
the usual tso_build_hdr()/tso_build_data() APIs and creates the S/G FDs.

With this patch set we can see the following improvement in a TCP flow
running on a single A72@2.2GHz of the LX2160A SoC:

before: 6.38Gbit/s
after:  8.48Gbit/s

Ioana Ciornei (7):
  dpaa2-eth: rearrange variable declaration in __dpaa2_eth_tx
  dpaa2-eth: allocate a fragment already aligned
  dpaa2-eth: extract the S/G table buffer cache interaction into
    functions
  dpaa2-eth: use the S/G table cache also for the normal S/G path
  dpaa2-eth: work with an array of FDs
  dpaa2-eth: add support for software TSO
  soc: fsl: dpio: read the consumer index from the cache inhibited area

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 343 ++++++++++++++----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  18 +
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |   2 +
 drivers/soc/fsl/dpio/qbman-portal.c           |   8 +-
 4 files changed, 301 insertions(+), 70 deletions(-)

-- 
2.33.1

