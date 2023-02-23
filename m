Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F066A0659
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbjBWKgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjBWKgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:36:53 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2076.outbound.protection.outlook.com [40.107.21.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C0734F6B;
        Thu, 23 Feb 2023 02:36:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJr8ocO7RJUe7VGjSYCNOz0Koqv/ytaRmKCiKIxsiXHYPySJhRicjgjeMuzQU7JD1WMRTG+Yc+i4pFyT1Z+3SE144No3K7NIKLc9esAVl62SbYogMS4+jmQBtcuAQ07cR4Y6XJqctV5DFcLwZGeUsjMe1hVoX+oymNSyEDEjsh4v1YKWGSo1pONGRKNBNkDvElT5QbBWS/Sq52RCMJV+bb+wtmCjlrobDs2K+GK4SdgXbHY5wB2do63LIShe87lpnbTRJggYbrAVE4Zr1qAWQfzMyHHwj1ep1EfyFhSB2HNhM1zpYGfVauAAi/N8IuPm/9PFmUXijCCcGfbj4sZrfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dNadIwxG4tpRFeVbjiIn44BCI/L0SyApl+zp6PkYwXw=;
 b=l5+JYKmQygdCPQzIgAEp24GB1v6giz+psjzYHOFfeLqicTJm2V3gT4Nuq87C7EBeJCmwZJNs/6Hana58GnlvnSoK8d/NsP9LGUtunxDi8eMI27OfBDA5/nK8+rWX/sVdgcXcrkAFHFg2Y72u6gAGBoyj//eexlA9vSxY8CeNOtFLJeSMkuKbrya5WbxqkjeQe5W3zPppgqBa9f5cGG6Yq1lKz0Vto6go894ABvdyoNqJ9fqrpOtxZIo1lg7bIfFTqsU8ZrZbtoXU6j+kzyA9U/B0SAlDyDqqcEsGjHvkiUAlca4jsuZWJeLPiHPRKMsk9QeM5m9DR0YI8lTdpdL9Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNadIwxG4tpRFeVbjiIn44BCI/L0SyApl+zp6PkYwXw=;
 b=NuK0aVqkN8VXGHnndKl6Rb01Avt/7MSXl2eDTA/uRSqBTuq7Qkg/kTRwhOQZoDpuSWo88W4mefbczXGgUeEYA+MVEU+5BrjUvZK64gW5+Lt2dAI2mJCCk1yzmLuP8BHRUjPkBWbnED79BEkGL5iGlY7qLfhS+Z1LOAlh2+NtRjM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM9PR04MB8195.eurprd04.prod.outlook.com (2603:10a6:20b:3b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 10:36:49 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%9]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 10:36:49 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v5 0/3] Add support for NXP bluetooth chipsets
Date:   Thu, 23 Feb 2023 16:06:11 +0530
Message-Id: <20230223103614.4137309-1-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0137.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::42) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|AM9PR04MB8195:EE_
X-MS-Office365-Filtering-Correlation-Id: d6d0bbce-2740-4241-ab5e-08db1589de7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AaKyNDpd6NXA5Zm8/dg1Qtn+1/6Ytd42OthXIsSy2k78yX4rJ/Iq+cTkTgHMqQQTAUDMjCe58qqFoE2QxjVsfP6xhhdHLr/zdVsnWYnDXtkTzSIeGzLBMMwlqWJHGKXm2YzEwSEQPCXpCGDHgiorE3y4LMqpuEFFRGFmTGF1Dtdi45npN+HhjbGfn6z6tHOan07Aby40ZrZqaE+Se/JjKRcGT1INB0qCZIJF2q8+BQtcJaBQu9cCpWWYkM2bE77hEtaGdgjEH/HF8auUkOTTlsbC6padMMIKUUBwvjGf7pAmdfnVWrwyRnJG4v1vnYKV6os49J45J55ccox6iffV19jlYfPA7SBVILgQ0bCRSW6Pb98sCoPcEYKVw0ilo5Nu4CMm4lDR0MHwNwsQnmSH9MUiHXsuPWvgryWvZVUGz/yzRMwFTKKraTg/6jzr3Q5KMrVzMp/ZTUkYMjmMsYyf3AYs4rNgneerW2sHL4vlE1NBnUVJuf8ix251eGufJOsXON3yI1cp67cKon5mK6XJvJqsr4SdwapIffSHW5ntGNrVSVhTTPW0qy9giUZ7ai65V6pNP4vEO2gMrSDZCVUQljc+b1duMIaicvpApRZydNQXcP0prja87KRT/2W/hMJMXbl2cqzg1QD3nYMSg/HKJr3xKpbbhmnZuab7BxcafQW8ILW6HIM2oEeAjUDnOOPA8NSxVTt55uC3uFkXIb7iDNqmydmeze4i7/wui4RXwtc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199018)(66946007)(66556008)(66476007)(83380400001)(8676002)(8936002)(316002)(5660300002)(4326008)(41300700001)(1076003)(6506007)(2616005)(186003)(6512007)(6666004)(26005)(478600001)(6486002)(52116002)(921005)(36756003)(86362001)(2906002)(7416002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qN9gf9qWDx6quJtRDmh0FdTh3Spmg37v0MXVvtn3aOvO2ylg2JaC8+eIr5uB?=
 =?us-ascii?Q?xshnmv0egKRW378G6d3MYbMGJp7OjY4BxS2XrX6HNjlxpnYgctnJOewrqmmS?=
 =?us-ascii?Q?Lyy4AH3dU2b259m7ZUPS+s/25+RZ9jkHAzc2caimHgqd6YmztguWfuPhg2Pz?=
 =?us-ascii?Q?lDDvmQETJLILC7j1fYXaWUXiT9fWAMTCfnveLYYg/hRjlEGyQqjVRu63ozx0?=
 =?us-ascii?Q?WwdIwzzv5jXZKLO03+FGxQ+KFIpQr91uKhkW77PpqpEn71ua4PCipNb6PGJ9?=
 =?us-ascii?Q?5TyJOJXAsaxiE82NX5pxE3JnyPw7K1sWVfqoAqSeJpuRer/GzNZxwo3wxPcT?=
 =?us-ascii?Q?0AfXOd5Kiz67+UfYcPUgXM8i84jOSh7n9QWmGm80aVd5yDJvQT2K2T0WVViv?=
 =?us-ascii?Q?1Z6ihRF5tFzDbL9Pn6V+WPo0rRvu/H8CtglfUhA7YQmKobc7HUBJhZ8uhITJ?=
 =?us-ascii?Q?WJilzW2sMvYRBNXqRG+Y3sPCGuOYxaV9fqtSNoSBxaB8McUZPT2bpkmcnNE2?=
 =?us-ascii?Q?pE1E7YRxsfIngqw1QQKJDXJ1QGdrFPYzLosqSJ97xnu1JTcwQB896TAk1mmo?=
 =?us-ascii?Q?44aadOiJ6w9Wz3SglJvc9VcytSdDQ8KknNCabk/2pcOTdoBenSL5moW7eEE3?=
 =?us-ascii?Q?hTDR2YW5WMZIFqOhp/QiLjq+MlCx2v8NoIbaUxg3QFq+UmltENBgTBhnRoxW?=
 =?us-ascii?Q?3y7+ZsRTM54RhdQ5xcal1awZK4f5vX2baeL+h7de12S/fv6W4FW4qH9bv1mX?=
 =?us-ascii?Q?KpvrfQASc8G6+wEtkLll7Rq4L5JPxtQKFs1N1PQhl7EekuW2oBhXECsRMb6n?=
 =?us-ascii?Q?Iz3x5GtvvBjdf4PiV93YHz5UNSABNXc4HXTO7sYmRjiwdaPwsmq9Z7Ng9NKE?=
 =?us-ascii?Q?z29kmK+TIJrSSiH5vc3gAiX52vLp+tnzv6viWIpG+l2+Oc1S7yYaJD5oi/pL?=
 =?us-ascii?Q?nlfYltsQF5nx0rpp8St+6r5+kMMgCWshiAegi9ImbqAhFLMaIilYcERZrvYj?=
 =?us-ascii?Q?j4Zy/nQ+ZJT7A9Oc48wH7MFz4hG7meMFjS7/KV3FNTgSBYMNSVrf7asEYZoR?=
 =?us-ascii?Q?DGcGKN23oaFqVT3NKBzK27B00P5cKjUO4LO+eMzWZPKziB7zDn2eUUZb8hne?=
 =?us-ascii?Q?7Ss6Pl+Zh/8THfBS1u1Zi2QJgQjjc9s+3FMTYefQ2TMQXKcVfo9ROjq0GywU?=
 =?us-ascii?Q?rbPAk5Y3g6Rv5kIWCMcyNemBYbhhpwVZS2B+PKvPOFsV2QFCXhMit2pef88H?=
 =?us-ascii?Q?8Z2+yJIAYGHfgrZTnCh+dtSN8R+Dygdti6o/dmnSoFmC/0AbvZZZZte+leoQ?=
 =?us-ascii?Q?iANcl8uFaKpFUKn7BK7KTAW6vEg9abvlv/R7m1rfuAWw/gIEn4CZkfgwjUgz?=
 =?us-ascii?Q?rz+GJNcTVMbWOFnw8X+hxJEcY6znqq7a1kcQWbsHrOj2n5EIYB6bmTZ0S8lf?=
 =?us-ascii?Q?//Hg+PWRUM2SepvHTDgJ0CXSaG5RbTM00PxFKJpKKmfh6Fo8HSqxWGnZsZcX?=
 =?us-ascii?Q?ckq/IsqjXy6J7gHpV9ozp1NxOt+1rPh1GFukaDI5qTBwxCuADTIJiNm8O6cL?=
 =?us-ascii?Q?61yDX7UF8puQt3C5tzkfdvn3EQEt5ofx6/QCV0qlqBgs/8XUTk3VN+Jp3LXt?=
 =?us-ascii?Q?+g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d0bbce-2740-4241-ab5e-08db1589de7f
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 10:36:49.3962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lQPAIMRg8bvDP8ohL8vAL3nEMCFt7pUgDYNKtTXOP3pkpvncsNpKvpe423L2ZtxP5YcBE3h2hHUowXiD6wpLEln/bp3kbXNINCr1gyIIq/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8195
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a driver for NXP bluetooth chipsets.

The driver is based on H4 protocol, and uses serdev APIs. It supports
host to chip power save feature, which is signalled by the host by
asserting break over UART TX lines, to put the chip into sleep state.

To support this feature, break_ctl has also been added to serdev-tty
along with a new serdev API serdev_device_break_ctl().

This driver is capable of downloading firmware into the chip over UART.

The document specifying device tree bindings for this driver is also
included in this patch series.

Neeraj Sanjay Kale (3):
  serdev: Add method to assert break signal over tty UART port
  dt-bindings: net: bluetooth: Add NXP bluetooth support
  Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets

 .../net/bluetooth/nxp,88w8987-bt.yaml         |   38 +
 MAINTAINERS                                   |    6 +
 drivers/bluetooth/Kconfig                     |   11 +
 drivers/bluetooth/Makefile                    |    1 +
 drivers/bluetooth/btnxpuart.c                 | 1313 +++++++++++++++++
 drivers/tty/serdev/core.c                     |   11 +
 drivers/tty/serdev/serdev-ttyport.c           |   17 +
 include/linux/serdev.h                        |    6 +
 8 files changed, 1403 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
 create mode 100644 drivers/bluetooth/btnxpuart.c

-- 
2.34.1

