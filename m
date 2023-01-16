Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B676466BDA5
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 13:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjAPMSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 07:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjAPMRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 07:17:52 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2047.outbound.protection.outlook.com [40.107.7.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C02E1E29A;
        Mon, 16 Jan 2023 04:17:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWvfjPLitYt164zaS7/BjZTfIR8KUZEaTN+QVlOu4AjutT/bJkPz/8jGzaeJuVq/Hb6CwXjoMttFx7syPuKmdvADwdmKvumHlyIZcnJQfBh6HyhodqOOqBpl7cjzpN7CLcEuuuRVQ8niczRhJEa4QPlQq8al+SbzG+kkDKazAOZC2P9H6NIQwtX7VBMYundwL9BlEKRHVzCrTjBgqko6QnOR7fdZFJ3n1TzSz/ZFwEIza6BZtgujuh96uM0aabZT07EsC3iY5V8CPD3EXaj0vpRyKeZu5MTGIpWh6hYZj00nphI9ER78AJ2inrMDQc86U+4TekQn6qZfL0nLZHmq+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Wq2GoUm1Ep3bz/1sRkIXS6kV41mKnZ1Cb4ZCARJAN4=;
 b=X2B+iUwwTVjVe7MzV4IWxWZBGBnZbKFqZQhLCeiioGTnZ2cLa2sqOz2QFDKVa5NPozrIsQyq/NG13SOj0JWNuuuR5rioW65k3wcgTl5uQjcHLyPHhxxV7U816UQrrSDMehjp5BEM0TINzhtBRxg1WEl5sla2t2KTrJd3QoOukCjafp69bP+QcRejwAspaPDDlJPCaEvbls8rTw/rcDx5wjG3UwP0ler/XDpmGYlLZz1zw/Cc8vr2KlxX73TvAGR9/xnYGneSms0hlXkADh4x0HcOW51JI9E1C/kOuSs54Scm1bHU9g+A8vR06sAxBWETFM+HfPZGZLUcOE339ftsTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Wq2GoUm1Ep3bz/1sRkIXS6kV41mKnZ1Cb4ZCARJAN4=;
 b=Qra4NGHZQAznTA1WCB0VauEDgfE9qTQ3sIHypB0NU7rgOsF+uHKLqn3EeCHOp35LH2HvyX2S9tRs+ym81G8ymkAQmuyLVzc97k6LnK/ig6hVsbWeKdFB4DI3HwXLsK+guk6GDtHtPuXL+cX63w3l9Qr7sTuci21SxqsMYBhIAlU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9313.eurprd04.prod.outlook.com (2603:10a6:20b:4e4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 12:17:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 12:17:29 +0000
Date:   Mon, 16 Jan 2023 14:17:25 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Somisetty, Pranavi" <pranavi.somisetty@amd.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next 02/12] net: ethtool: add support for MAC
 Merge layer
Message-ID: <20230116121725.wsf3hfv3biyozno4@skbuf>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
 <20230111161706.1465242-3-vladimir.oltean@nxp.com>
 <BN8PR12MB28529854BAE0543212FF8E13F7C19@BN8PR12MB2852.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB28529854BAE0543212FF8E13F7C19@BN8PR12MB2852.namprd12.prod.outlook.com>
X-ClientProxiedBy: VI1PR04CA0110.eurprd04.prod.outlook.com
 (2603:10a6:803:64::45) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS4PR04MB9313:EE_
X-MS-Office365-Filtering-Correlation-Id: aa8620d0-d859-4e2f-e391-08daf7bba2eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 79tgCEDQXdeOITF5FtpwIuDmNMrie/gqU4zmjfKkmWHQQ4t34wDO5H89pY50qPfI7tUoh+18iiUCvWwDJoN9LipTf/PvufHXv42QVTY9ErPivCgiTKuOFGAAF99b7ZShexj0QjP0lEnIgtX9jCGgwaCaz0kUbCMc07R+5TJWzY/IgCo0cl7lj50QKnBq0Z+FXhJ+DXXHWOHINv0/NN4cgIvPJWXcHQAx4rhRil/EVUFPxM1fjxCgabbpsun8uAsN5/7YLoWvxhx7YYbkbWXkSpHhzFjZc5lQfzlSZfT01oL/pLtvu19YGZUGy6oTCc+ZZgEOl+r1wXXR+avRw4Fh5ic60oMDVP0rebMB3hxcfplY3kpqGviUu1bdPWKuRkCapUY5zCwxpzlxyD6H0A3IM3k0VzMXuYAGfmENxQTRdxQSRyGL2KgNOSf6E1zvPpqqpdbFcV8eO4zerIahOXkKaxN67ys3Fj5uOBpcTepWu7Y77CCwmte43Gkv/lhXZlAuE33RmYostXyyf5OWjm4VHZAg5qEuQZe+AUAT8j7wUdkczDJzIiQmzmqd75F9Rn7XFxyQMZMdNT+udWGRs8O73SY/RPeMKsoKJP6xoWf8BqJMXwmElAKEdIthj67dZs10mH5FHRXDgcykYzHb8epGwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199015)(86362001)(66556008)(8936002)(44832011)(6916009)(8676002)(66946007)(66476007)(2906002)(5660300002)(7416002)(4326008)(83380400001)(38100700002)(478600001)(6486002)(54906003)(6666004)(316002)(33716001)(41300700001)(1076003)(6512007)(9686003)(26005)(6506007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bU84YpP2HKKgC2gXa3Cu2fUZ+0UsYJ+oBCCcro0fiYql4QrIR8HVGKd0wwvm?=
 =?us-ascii?Q?zsWLi5xZ9rSuq1nPXIDTADLUqxxVlMeZdFc6PNDp/A7NWsZ49G4n2AeFIagT?=
 =?us-ascii?Q?TwQxeamE6WmC/4R2eI43Xw7DsDPblBpxPdoLSLqyo+I5tPkb8tEEsw3ejxdG?=
 =?us-ascii?Q?Y8uAzD+xYE4DpEajWRBMGyEoC+Rc3G7xRQqVRXvDzIusW/OiuM3IMUnRhIZw?=
 =?us-ascii?Q?VpZtRs8x9Czxye8v1pUMrb3Y9xhQ6roixtwyIoW9J3bUas3JLRAtDqFnlCAW?=
 =?us-ascii?Q?8y6qBmIZ+S/LRbXHFWzJqranAxQTFIhuOpd5jt/zXZHlb44F0ausabX6ZttW?=
 =?us-ascii?Q?4hCQAeQJaU0EmIKmR251JINNdpfJ6v7Z1YLNaCdtTpe2jytL9SLQnQEI+MVl?=
 =?us-ascii?Q?6p+LFfBYdnwemo/RwP9Vgqm/3P2dcK0zw9w4YMUNNYA4OE7lCGaHHO+Cc7BF?=
 =?us-ascii?Q?KztDepjFoq9/7x3zIQlkh8KeLZ0Iol5bjHkmzi29fDF0uD9IjHIl3D1IV9/0?=
 =?us-ascii?Q?1IvRT4zvtPBrQU0HBRqwIl6DZ1ORxpfT48DInbters/gFct2nAB5uWKT3MhV?=
 =?us-ascii?Q?k1aoQIUn0f86DaepCPuIJjMdg0XCIphWbTgkOzcsr29/n1Si/6PoN1nwx3Fa?=
 =?us-ascii?Q?itkq7XF4eam3VEdgtFI8nBUf+Nk0TJ8WwPv4fcDYkGHi3nw6doUd64ioASsZ?=
 =?us-ascii?Q?Ur/1wxapWTg7/isXPySVPKq/rk8YH05rDF1oW2VVlI3vXGRRyoSkdfZ86NUX?=
 =?us-ascii?Q?d2Vs3dn4vAQfvyH7MKDZsE0ZodNfVRKcsL2MTaVFbwQ/U4jTdySdkEw6Y9m7?=
 =?us-ascii?Q?f8pJiYqyzVvfgp8irHriYXAdfdJBDkhDsr+DfPmZ72ma4CwPm2ZD6ND9YDLv?=
 =?us-ascii?Q?fto3lSexeu0RueoOy7pSq70K6iyNo/4vOMegKRkle3asm8SrWW0Rfd3GeaqX?=
 =?us-ascii?Q?xgk50SyjAZw5V5XRbfyWQO2ZWEzyVSCOCnDvbF2l3hp1gcT2CVd8+zb61xeN?=
 =?us-ascii?Q?aNe1gV5/o+hp3RmFDiqE8E9QYBJezrH1JBni6WsFmhBK6mAUF5E9p4jWheRc?=
 =?us-ascii?Q?9ZXJ3034MQxZC4VetJ1CeWZ37+sdjM/mY+2wycXbvlzZmQg8CWT+cdZqV0VW?=
 =?us-ascii?Q?mqp9sjrGFGL9nSnpJeMR3qZnD1bmJf+Cpl7MRaIl2lt8zX2hss12YUAUFkY/?=
 =?us-ascii?Q?/EZM/m/clsQSEMOJX3jHM+j4REGT+/YtAD2exI+6gNzzmSplPIo9Pcz1+mAq?=
 =?us-ascii?Q?BiDouGfkwD1yJSC9vKXAU+9UozDyYrjyVo2I7tnSo1jNCA1Aks7SKWR9v2cN?=
 =?us-ascii?Q?1f9ir9873efMuJo3h/LM6uMgYHyGI1f/vB0KK++QE1wpHHySf5vBvviLlLfj?=
 =?us-ascii?Q?ywEyYPzHkkRct5LXRpXl2g8z9Y9X3PHwfRphzrgHRiM7t6iUr4QBuHN0PkTo?=
 =?us-ascii?Q?AVg3H03rjkpPe+y7t44czAE6M0QYrUaKDspyo65LkfpnWxaGOnUrtYD26FnR?=
 =?us-ascii?Q?8qvODEeCSB19BK26NcUeSeG+qJ/16vv+JRGFb2SVOc3h39lirFu4N+cgTkPP?=
 =?us-ascii?Q?w+qud5QfZLYgQ5yq696BADz6OZ8fn4mlD9Jy6EtefRSnQZHwkWQhy++u/qJS?=
 =?us-ascii?Q?EA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa8620d0-d859-4e2f-e391-08daf7bba2eb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 12:17:29.3784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tgSoXCpU4cZ5DkTvrd+JUFmxOTo3DYXIymht4ykTw++fGMiys94jl+KwuwnVRugZC+DE7E8U8glDkfFNnnQYdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9313
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 09:02:55AM +0000, Somisetty, Pranavi wrote:
> Does it make sense to have two separate functions, one to
> enable/disable pmac and tx preemption status and configure additional
> fragment size (both parameters can be configured after negotiating
> with the link partner), and another to modify the verification related
> parameters, i.e, enable/disable verification and verify time value?
> 
> For example, if the user wants to change the verify time value, Is
> there a way to change it without disturbing the value of the
> additional fragment size that has been set through LLDP after
> negotiating with the link partner?

Could you please clarify what you mean by "disturbing"? The handler for
the ETHTOOL_MSG_MM_SET message first calls get_mm(struct ethtool_mm_state),
then mm_state_to_cfg(struct ethtool_mm_state, struct ethtool_mm_cfg),
then set_mm(struct ethtool_mm_cfg). In other words, a SET ethtool
command translates into a read-modify-write in the kernel. If user space
did not request the modification of the additional fragment size, just
the verify time, then the set_mm() call will contain the old additional
fragment size and the new verify time.
