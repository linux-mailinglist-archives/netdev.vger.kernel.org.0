Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A746D3361
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 21:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjDATTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 15:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDATTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 15:19:39 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2053.outbound.protection.outlook.com [40.107.6.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703CD1BF72
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 12:19:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iB7B0UsGG2AWnhEiPQ15Gj9Z9JFP3dE0NhJpz97ZEWJuZG0laDZKXo1zlYsIALX23PuVaW9GL+3+SpKmU0MgMi6BBpp6FbLkmwI/k6LhlCCPocz6FDj8oloVxitmXC1tpg85gJ7v2nOg/4zuoy8KDxcAgO7LXRi0z2nFhmZ5XzTi1D9h/1a7+7YMZKhusodOaB5uaDX0/Wx9rDycV76rOW14OkqROh+ou0Se3xEehAGz/8aaiR+/GnJinENyhI5kPSHUIhWG5zeDKr6ZgE4bA6teyuONI/JMfepp5KIN6UOegVnEz1jjS3XaCUXwLPivLEpVsXgtN8MWfAj1W8bCCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sUX4JRSiQ9we6CPy2RKAv6hIZFkwAO+SfAawzjYFUTw=;
 b=Ja4jBPZ//7MOcOcs4PTpA0fxLaIkNBWQdMKPaX3NBkB6xrQs7lTH1VDX8aJIiuALHyE8IGuGvQXhILVEQNgWvfLecPT9f1ILCiTWVkPyiv3A99/kOhTBnv/IKpiy8dvocVBghXog7/FZ+HtNQCBvpt+SzflNHWQmy5+ATIHWYoLYr0lgiCb0mknGHV1NixmNSe/alu5t9Wu/BqOMu3sn7Go9xL4Zb8lX4oKGTNyyf1TVEYvSkxCq9dlYBeSa1HV17T0RUciOTTyyOksXqYAIjJFVhWw0OLogT4UWcCTSFLfmXanl6Y0MbF7aM2/mPb4EEzqslj0/sOdYZWT3+z4rXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUX4JRSiQ9we6CPy2RKAv6hIZFkwAO+SfAawzjYFUTw=;
 b=JwlvPWUJpDwqj8uzRLTxf/PpnJCk/7As10Dks5Fdc8r9Pz2nsHywsnxUgHAlRbMSpEmgzfmsHgqH4KPsz+kL50wINUc08VA2jSpve/uKLaBAxOddLYvxrUoZmV/9QKUxHribZ/RV8YoCZq/qTNguICJOqDTkG0kx3lCLjl4DTUk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8149.eurprd04.prod.outlook.com (2603:10a6:20b:3fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Sat, 1 Apr
 2023 19:19:35 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sat, 1 Apr 2023
 19:19:35 +0000
Date:   Sat, 1 Apr 2023 22:19:32 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230401191932.e42efcurccriy3cy@skbuf>
References: <20230331045619.40256-1-glipus@gmail.com>
 <20230330223519.36ce7d23@kernel.org>
 <20230401160829.7tbxnm5l3ke5ggvr@skbuf>
 <20230401105533.240e27aa@kernel.org>
 <20230401182058.zt5qhgjmejm7lnst@skbuf>
 <20230401121451.4457de9c@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230401121451.4457de9c@kernel.org>
X-ClientProxiedBy: VI1PR03CA0048.eurprd03.prod.outlook.com
 (2603:10a6:803:50::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8149:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a1ff8b1-709e-439c-2b0e-08db32e60782
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rcTwioaklacdFEkucUit9JGbnvMBBoEbhbdO6X1Ap90T15Vmqhj1rIzE/sVG9GftGU8tliJkz0QXTDy9W5BBfwLUnnuhPP/FnXhDYZp4PTfHrDYFvXVgkZAtDIf1TFsJ9kjF9mPbCzjc7GgSyweW1PwT+18jAwmrjcfhyr6QZXD9DFXp7EJ/SawXFPeke3WoMRLTbscFJ+entp2NZ4Hr6f8F8sUUTumY1Qo0y3TXYaWCl9rT+TYhKsFsgFstuRrNVIb8kKIUypcd4zfcvbA81t9a5tHQr71letoXYIRnAXOc4sXgDXUV5OHAzZDc7+NfMrXk0QXCK643D2sTNrae9yqjqP3TgGnMtZOBDH+lRjRWPusYpKUdX+HMrwx1XrbDKDuX68FZBmflt+XJRxjR3QaZIMmvhnbKywbpDSFBHHW5+KoxN/RhgdBgkNO71SHfpkKVI7TwzOV39tRwRV+4w5KIZOOnDMoJgpHH/VItnCR66JOwXNeVMrw3BTqzKyupJP4KH/NK3kKzB46aC67HCLNhnDMttdoDDig3eVI3D5gBYtnbbJXwJRdWn7sESpV5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199021)(4326008)(6486002)(6916009)(66556008)(66946007)(316002)(66476007)(8676002)(558084003)(6512007)(9686003)(26005)(6506007)(6666004)(38100700002)(186003)(1076003)(33716001)(41300700001)(8936002)(5660300002)(478600001)(86362001)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?59XBP6IwMcXAc76BkHJh2Y51oJa9ku/sPX43UIK5+Tr47yFTV5xJFRo/sg1T?=
 =?us-ascii?Q?kS5VN7JMxezQntTgIdo4vZP5q0x2a14R6s1cWJwNv4ghsKhWCL/lNpmSmHpT?=
 =?us-ascii?Q?7msOD9jauwcN9jc0TvnvAWEudLJ2OxgK3NjChntfQ7NdmX1LIJ79NBkvdAlt?=
 =?us-ascii?Q?SVOJU3VBIXni5ueKWoOIIW/vOkl3Bjs46mBubxAtYcXFDjCfuZoVi4vcRvTs?=
 =?us-ascii?Q?O4Tfu4REnBCIhiTQgeBkDx5znZ6K9k2NBnpGsdjtQktdleXh/lmRpSgIeP3h?=
 =?us-ascii?Q?AhLdP2TgkhFm0v8PiB4FtM/3NaxvYDUTcDhaWgDLVO9axMhd/k4fGvUX6XuR?=
 =?us-ascii?Q?G95yh++riZX9k+84aaZd0MBTxSvn8qTZ7WostnFPndjY8pX65U2O51ugHoej?=
 =?us-ascii?Q?/AgMeaiQnlSzRZYK333dfDTQyW60ni5CCUqp58GyhZS9pu9YSxIA4jl6fluj?=
 =?us-ascii?Q?Ye9Bo+Y6bWpqy8cYRSHfWWBy5pRz/PWQNEJIZEU3uz3uICEktqe6KgKm/WMv?=
 =?us-ascii?Q?KrkSA2z5wG0YZL1M5bw1l2gWqzv4x9R6O7aFQutTBbvRLXP0h+gvFrULCWIh?=
 =?us-ascii?Q?1pBQZR60/Gva0B8O53oD9mZ7A4YdUmI48TzLdBRYlx1mgI/bnI1DOMwzchh6?=
 =?us-ascii?Q?KymIDRMsateTyXQj6++FSiJ+U+Dpo1a2Z1IoczxbuIZjq0g39VzkDaqbOg/a?=
 =?us-ascii?Q?0zFI9zYzr2zMPsCW4Ltn11BWajf91qx9z0YbKWBWtCXJCbzWVQ2QCLQpIrmD?=
 =?us-ascii?Q?vQ7ruodIpcNexKnBVSgyHE92T71++y7J6cjoyRtTVn8estyoCJ12D+jDgHA8?=
 =?us-ascii?Q?V5bIR5LnlrHRboLf2tS8ysaoGLJdfFtiNEoNignjQgxnGYje8hXqqVJ3dAD1?=
 =?us-ascii?Q?X37xJJpaAlEQomCb1w0e/N7pNI1mXfafwOqyWoH6MXGMVWwYdKcrrcH2tixB?=
 =?us-ascii?Q?2nfpEa9A2FmA40mZQmQXxREDSeQ25Cu0jhwo93DWGvAM46JdovY4aUO7BLkp?=
 =?us-ascii?Q?XXXDgZWLUzSgABOmaGqHeXaCx3wVwaKx+9NHDWaq4PQU0H/SQZ7wVMj1LLwF?=
 =?us-ascii?Q?cbq7J56RHybcj6N1JyxDbcxBbQAS4cFYcxIpDplspmx7O9kkxL5G6D85Mmj0?=
 =?us-ascii?Q?iRTqU/ckvc+x2Mq1Inr008QQWOqcdU9UcOxPPi2hFEaoqUPT0x9QmbLuc/mY?=
 =?us-ascii?Q?1+i8y4YdQ8G35mwxO7BwREgJK38T0na7veHFSzMfF5KOIbAgAhXgB56umjI5?=
 =?us-ascii?Q?mowcpAnQEIuPXQDX6l0ElY+OXbVITpHynpE8rmypuQlwfbv5vyPc9CyRZ8Zf?=
 =?us-ascii?Q?N0QNZbpAIufWutUMHbxVq5m+P10yFigpYxa0N8YNdFjEq8uTOcSh34nWxVyU?=
 =?us-ascii?Q?2zaqYPLGY/AxJ/gkIbGp5ylKRgFpZKX3I04PKpuwTj7mGvhOwoGrmUbTsIju?=
 =?us-ascii?Q?2kvYZ/vgcrUsXhFm/S1BkLLy7M2Hq0NpcjFNCW3mRhD9CneWaTXuHwrf4JjS?=
 =?us-ascii?Q?3KEOAaUYusj3EFaE6M/wsZG6Fp9hnZVENs0ExcCN/OMka2AZRovdnkxAxBuS?=
 =?us-ascii?Q?dIxu39pL/N3izGKAIrKtYoWqjyv6M1fak88IVIiZyx9vim6QE6u32jlWVhog?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a1ff8b1-709e-439c-2b0e-08db32e60782
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 19:19:35.4522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8gheU9ArrtrZLfEhrHPTE0qnU/OScaNSN4xugc00eEX/W0IjSMWeCpLT8Z1PL9iDIFpHhQKnNsJi0wjGb2dZKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8149
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 12:14:51PM -0700, Jakub Kicinski wrote:
> Do you see a reason not to code this the right way?

No. I didn't understand the justification you brought, and asked for
clarifications.
