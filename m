Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FF36DD98C
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjDKLkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjDKLkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:40:01 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2060.outbound.protection.outlook.com [40.107.22.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A9E3C16
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:39:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWXEjhTDvSYN9XCccH58qUjd10zBCE/VO07OdUOQbJUCMNgvpZHX4tvtRAt3rcR2evi6WuNKKoF16k5qBHfBxtDJSyfJ4d3U/T27OPWDkpawV2UkdHVkRyth6EeJj84hXwayO9KYvyjmbawCkfmG//A2jJRb/cwPPN7B5tb6F241KX7Trb/x82Rtjw+iv79ZiZrBrE7dzW0xxsYsSLHn3RsyrNSuJrQn8T4ODl/XVrnFg6sa7yrkC8gxWVsWCNoVVGbyLWPjjW/MT4zN71GlrPaUWDLI4AJqzw+UgksSzvUMAECOSmYJmZ87Iu6rnm9PKRw6xSs/wh+tUWNFmVZfPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0OkC80JgXUYJHrPvWDEuLgnpiFo0WUbMKl6cgjtSjc=;
 b=WbNWFlBs5FZavMnAJ+lQBzdmksJmwei9JFKyP3DaaxBpgJQNZ3IbZY8LXfRw9HakMvuWEFtG1FzaubcxJKA4pIz/I9mbkwqDz+eAvvKqAsqQg/9+jpadrbLdh3/wY7+gZMW/OK+4Ti0GxvJh9QI1k0Z04ZwPQvgm860coM2PAIjyF2JVGgvAWed0kyiYt5In1knFJ4sF4JBei94rB4w2IcVJR5z4t0oGtlGIljjPuTzEYA7sJuUGyztk1uUPv52NBKWChG0POw20ZidHbUU04EkPGqaQcl7AKpR3cqRU05bVMbfAPp4/5NU3B1Iw1bt2EdmWea6PZuKUvyo/5OovFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0OkC80JgXUYJHrPvWDEuLgnpiFo0WUbMKl6cgjtSjc=;
 b=ixQgif8HcqDWwSiOPAw6gIgNu9EidcLgGz8wClQb+vbBFZOqZQ73V5EfRT6vea0FljuEDiZQkE3HqEcIU8Ynf5FxsxH69MsvoT59Zy7iT1KhlyKEkQRtSNDbu/3KMABW6npsG2NnasHnZiSFQK1GXgMLnYq0Wq1JPGzMvyhaIXM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DBBPR04MB7786.eurprd04.prod.outlook.com (2603:10a6:10:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 11:39:51 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Tue, 11 Apr 2023
 11:39:51 +0000
Date:   Tue, 11 Apr 2023 14:39:47 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     shawnguo@kernel.org, s.hauer@pengutronix.de,
        Russell King <rmk+kernel@armlinux.org.uk>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Message-ID: <20230411113947.hn2nonxhnqx4hvtb@skbuf>
References: <20230408152801.2336041-1-andrew@lunn.ch>
 <20230408152801.2336041-1-andrew@lunn.ch>
 <20230408152801.2336041-2-andrew@lunn.ch>
 <20230408152801.2336041-2-andrew@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408152801.2336041-2-andrew@lunn.ch>
 <20230408152801.2336041-2-andrew@lunn.ch>
X-ClientProxiedBy: FR0P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::22) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DBBPR04MB7786:EE_
X-MS-Office365-Filtering-Correlation-Id: 9db5947f-73f4-4388-a332-08db3a817607
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5rZ232MWbG6guj8Ywt83JFFZq4D6sLFxS9UaukGzyxDKwMxZkp48/btZNiTYJBqXkc+mq+kJEd8/fHtC9BYZVXp6U+t6ZaMHLVN9VkdWtKgI/gN4RG7q62SEbx91maMmLeQpAoLDvTO+GMIK9furUDlZKG9PWcjftHH3/fFcoCryPOaEbBh0r7eONLyH3VTZOvRsU2WAaMyeToYMKnLML+luVkGGumYln7LUdu2+IlHYukStwOTcqAUa/YdbuKiO77FR1w2bDsWp4V1X7yU5u0jcvS0Ii96XA2b4NMgiQmfBmdunruTBcS24ZWPn7PgjbZsCMGdeE+RyGjsLQuBvjvSJYpnu4c+kuLyl+z+JAm21PifbgS37xnJWCMeH/4Diq9s/G9ilpvx8shmQjgxyLtpJcRwB6PnfgDEpPIGKcWQQOOsOoNUL/zpOlTVnEVTSJmAqsrAueXAWDoqk5sdPbVc2tWgzw8/rjvtKeCVnFInoXhY/4p+WJiY3kiZMAjDXTcrPRfoV7H3vVya3qVbxEuo0SrKCZrOI3ZrO318thMku5cADuYQ4psYQ+gkkWDZf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(451199021)(86362001)(316002)(41300700001)(66946007)(6916009)(4326008)(66476007)(54906003)(66556008)(478600001)(6486002)(8676002)(33716001)(8936002)(2906002)(44832011)(4744005)(5660300002)(38100700002)(186003)(6512007)(6666004)(6506007)(9686003)(1076003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CJp33DZuHboAl9xCmEpVLU2zVfR8UlIZLBgzwuR+Z88ysPqofkrnYQezG1ke?=
 =?us-ascii?Q?NDsnRpj2Lvby5MU+EpYhOK62OfdsK0JdYDQ6Eqjwq7jh/MNLo2aXQucrGcvc?=
 =?us-ascii?Q?6ZbRz8/2vOfIRlYKsyrKNpbvWKtljcuq0H0KwYs7kqHhQBHkjiw17KXKFd+t?=
 =?us-ascii?Q?MfvFQXCRJqbkUkGFsH+5+6rupD4k3rjnWVJIceqBMtah9chmfyQ5evFJT0B0?=
 =?us-ascii?Q?OZlRXIDJerzUuaGe6FZpfqMXCtAQb0GrM+7St7kl6ix7SucazMrTFooaPt16?=
 =?us-ascii?Q?1ARPtggH7CuuUU8hfztTYg/zM2c92DUG+t/EuIo8oV+zXAEzh6F37eFIvfw6?=
 =?us-ascii?Q?UWZMkPp4LOv4foir5NL8933YX6kcvQTdM1xw88JadOQTnHz7lEmTDEqpTaTy?=
 =?us-ascii?Q?qF4GRw0OjwReG3G037BlRU62KnMQziTJzzpSXZohQeunxAEjKafnyJt7uWOw?=
 =?us-ascii?Q?MmrhJaHqgXkAbtyj87SAnfDoSdU8vxzAxeCmhWlCxYGGJQ+bR1AOIg7cEthi?=
 =?us-ascii?Q?iyvePK8Vd9898sRwz39WsGTotm/7/egt9ZYYRllZq31KaqYLy5PL6pPqRTkZ?=
 =?us-ascii?Q?DGDN836ozA1Zo6g9y1kv+WGxxrHW8de78vyYCnYdKSMOR3bmVQwfC2ODxsH5?=
 =?us-ascii?Q?s6ie/D0FRMQwihpZRVxgH/qOrWgDZOVAvIYMJFaYFx9HxFa543YILiLRBUYO?=
 =?us-ascii?Q?KNWvMkK9Puw2gzzpja5lV52vQYPs8jE4Hv5ofBj1WU72WLjdHGjeV+3JxyoM?=
 =?us-ascii?Q?Lcn2d7zfq0M+JE/8ga3JYA56URUtA42qNTFRrU/hki1H+Kou8akly/bnMjvC?=
 =?us-ascii?Q?FJ9rYIEGvptBT3biKEKY+vXcj4aIhwCuYDKpXP2NhZgWFBwEVvxzfKoyjN9D?=
 =?us-ascii?Q?qfduAQtndGeEhspasl+w11g0K6w0NWbW6QTVQFBUkFo2Pdhilph87SOjZdkL?=
 =?us-ascii?Q?ekly0YOlvv8KMm8eai/oNdhmUXX+VY6h8eDYfdNtZOCRQNEXJ7jqMwEFlMR1?=
 =?us-ascii?Q?vxWoXAx9Yp5dkHoXEbCoKcJb68eAhCDOKLSNytEMpsaVvNeWHh+F0qvwTME7?=
 =?us-ascii?Q?bw8SxnSSsg+qvciL49J1ImhnamxcCR8q0jmrOIOA7/3aFLKZvrSyeYBqbYC4?=
 =?us-ascii?Q?Sqo5PXnLgT8Ir5hg+GJgJgttXaimMriOlWN4IYV+TvlzdUdXxxMHhL21qAQO?=
 =?us-ascii?Q?uyEKQpvkPV+8VTZtIJ7uHmRUrXbiBFHf8bJQ/fmY3EQSfd0Obm5TLQ3k/OWL?=
 =?us-ascii?Q?MLvY/aibwLsEX86b0kTKRCz7t6Iyd2bUvGl/LgemJwWLprsQnmrsxi96bvkT?=
 =?us-ascii?Q?wkiSxRkKS7yzE0j0dU1dHHytg5KK9sG7ddI+dRcCV7EYroUv6LEa7Bn0xRZh?=
 =?us-ascii?Q?TsU6JgQiZQk1EZO3QdzuOL7CzRGvCLO8G975BMU917RbjtpYn4I/Z6R5Qkgn?=
 =?us-ascii?Q?U8qDx4lsvHMHckRVVG0VwEPTjgL5err28PvuvoLpOqg46CyAiR8FGXx6pJup?=
 =?us-ascii?Q?OCSAOS6f9/XreJSPy5+z5Azo3ZpYkC928+X3dH4WNaKM4C9gHoUzxi3IyBAR?=
 =?us-ascii?Q?p/3qcVBqGqfIi8TWQu2tmB6pv1+ndI+UTcS72pCNIJAr2WMIqT36s8iUccSc?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9db5947f-73f4-4388-a332-08db3a817607
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 11:39:51.0182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJTYZGbEzgZCvV3WjVnVWn+odZT8OxLcyOqSUyKT5hGXiIL/7YNeuf+iclw4hi6Hll32PC7aAtnAQ5sqWU137Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7786
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 08, 2023 at 05:27:59PM +0200, Andrew Lunn wrote:
> The DSA framework has got more picky about always having a phy-mode
> for the CPU port. The imx51 Ethernet supports MII, and RMII. Set the
> switch phy-mode based on how the SoC Ethernet port has been
> configured.
> 
> Additionally, the cpu label has never actually been used in the
> binding, so remove it.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
> v2: Use rev-mii for the side 'playing PHY'.
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
