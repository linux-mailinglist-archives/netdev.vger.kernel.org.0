Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB88E6D847A
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjDEREl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjDEREX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:04:23 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2043.outbound.protection.outlook.com [40.107.104.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04816A77
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 10:03:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLcUSnF9mTmb/NE8yZOlPXN7MudVX6opi7BwIc5pY1ek9eeML/cL+I9LDex1Uh/LWibNpI9SLtyXsG66SXhG5RzoBM0dG0GkdHvhlrbxWhYR5SEuHIqntFLz0ZgXPoc9H5yVk+tZKklx4q03zoP/UlyJYdZR9qeKOdGGFBxOiZLnQUK2kAO9pB8IATc8szipk0BZMP635O+Grej3vBaLV/9pIQSrljf5IG+eH2dqT2SpjZE2JXGQznJq1IN7Id0VjFlLYDPIPfgOi4ny8BWFsSz/aEOKXTRJLwOh3oWIJIoEEmXU0w2/DV/d1fAOP6w3IP7HwyUZWZKjrPB5qvoS6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bS4R7E8lcmCPIrmC6TgWJwphdBbmhmivExH16gzNLeo=;
 b=efm+YPJfXK3PYfO2olUAJxYvVKncqiStoLw3ebMWLz1mcov3o+BR81LCdicJNdCuTc/EGpBdg+fnhQdsogcGCk1SryliCCCfDbLQal+iU70nQMmRKB/JFg/xfag3LIm+chxt8T3iRYtTKv/232eibRxN1W9HDiJ36xV2OoHYS1AiQiWleAdnOCswtiHx6R8nN35C206JolelUhvuJBfBN23FzaCcTvncd5FP7AZOi5gdvTOFsWj5o73fSmb7Tmji56CbcD91h81xN+9PMznKx61LzNJyPqtaukjQMYBV8unMOjNC1uBnVzwlNoF5OafsclfhBlyzsgrhJ8fBySmivQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bS4R7E8lcmCPIrmC6TgWJwphdBbmhmivExH16gzNLeo=;
 b=FZLhcl3AtvX9L/574fqIV3w9GXkGA/1tfuoBjV/KVPHZPr6KYYPZV9ntUNQdtNeZUNpCPfgkKVtTH7xF2m1exVkv3k4wHrn2+0lzUVni20yr3Mw+KULD7NMX8xaYz+kKEF4dhDtUkTcFftcDAtixEHMESKb360eiWx/qzP0c/r4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8405.eurprd04.prod.outlook.com (2603:10a6:102:1c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Wed, 5 Apr
 2023 17:03:25 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 17:03:25 +0000
Date:   Wed, 5 Apr 2023 20:03:22 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan code
 path
Message-ID: <20230405170322.epknfkxdupctg6um@skbuf>
References: <20230405063323.36270-1-glipus@gmail.com>
 <20230405094210.32c013a7@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405094210.32c013a7@kernel.org>
X-ClientProxiedBy: FR0P281CA0074.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8405:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cd4e41d-438e-4af1-515a-08db35f7ab66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T5C1eFEb3Bo3b5sl3LhNnstOxzIa76JDgx9sWGg0Aa92gYOfWZa4QwxvRQzDKUi7xdVOwtfl+BslfBVDifOck7ougfAgUDQdvl/8hwVELhBeM/wKyTmYrb+hc/NpzlRSfaC7Xh5/CmGrMRKmzHKBQAgu4LtDsMa56EtHBSn5+HEYlYI8uqsSUNqQZIiLwP3kkeUi+ZSZMMVdyGrXnY6ZHqZgLQAfHmqM3w6J58uQfLFnvBeIj4XetBJRZ0tIbXln86hDgCb+YGk3OzN05rpWv/c2Pme/tXJ8neZgBVxChueBw/trVL69o+LilXrqRPBLDXxigrx2IiDiBv23SDp6TStlFiRExrZjGadzmU+bG1jU/bRKR/WY26bQ6VP4+mbGKBxjNSuMnUWujvEQJgXrMyV1rp7+im7H80puSYR4rVCI+gYXAYya+BcAAMwfSMoHQhXMgm9evyCQ80DCbs4KQm47BPh1GRG5CFk2U2vzD/unNjiRWfTKSNm0TRpxxegOaM7u9DcVZbnrwGEO3z5dTG+rEXcfYmAWimpPDXb8N2+vwORXT+rVINDuyUc+KvMh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(451199021)(86362001)(2906002)(33716001)(8936002)(6486002)(6506007)(44832011)(186003)(6666004)(6512007)(1076003)(26005)(478600001)(66476007)(66946007)(6916009)(41300700001)(4744005)(9686003)(66556008)(4326008)(5660300002)(38100700002)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QjH1w7A2BoAb8o/l9IBMJMkE1sPH06nYgLEbIwTVEGQFtBxcIEZYXXW2tYMI?=
 =?us-ascii?Q?LqZVwzgRn77Hz/6Y1lsklsYIFQHoDLJaltNfSRhr3AKBLj73cU0eDP9dFEAx?=
 =?us-ascii?Q?3g6QGTE99BpAzmNvkkUFzPcgqUzmNMQ3E4kU+Qq98N8HJ2snMW2cCm3ddjSJ?=
 =?us-ascii?Q?0M2hXA622Q/cO51RmhbpDizmUhGxcEK0VCLLqk0AsyoowNxcgaoazo6pV+Jq?=
 =?us-ascii?Q?CowNpcnQFbay+AurCY4GVq8cS9SftQ2MZPnd+3gWcTx2yu09Rvp+E1x8kacM?=
 =?us-ascii?Q?CsDQHEOTtiV8NOxl+/IwtyTpwEnOIR1UdlI2CV6zD1ARIlMNz5GlslOnF+Dw?=
 =?us-ascii?Q?2NO3sH77wTfsaLW9U5NMsezLATQ2NLYUUZNcc6HKkaNMjUdwkzSHLFNvEELf?=
 =?us-ascii?Q?ZkCMjnJuXffS9U+6I7Tg6mBm8BTaAi3yEDZrzkyu8xfCeLEhJAvGm4ubYvdl?=
 =?us-ascii?Q?ElrwWWtd0nQe1RBCUpBghhdS3caoB5JgmQ1Y2lHgr1GiYdl9qtOy9mkDSD8k?=
 =?us-ascii?Q?EO6FRerUIySfZ1gbKVnR0VhyWRrWRdR6cx41eEgoslZi08PbkQBXWjAeULqs?=
 =?us-ascii?Q?JDgsjQ2J/E79r1aaLw1NRcKRxfPeDOfM65z7nP/Ia5rV14bTdxwezHIPtY85?=
 =?us-ascii?Q?2Isr5Ca2md7fXKJw2BjwSYrAZDNKfsa5BqN8oPNtsGkDZnGhWI7oSgCQGqdy?=
 =?us-ascii?Q?xmI93vZe4p2izQy0gCg5/0MwRQT/kBgqT20xOwpP+SSmL0gZTg0liyHejg/w?=
 =?us-ascii?Q?+QsiIqUndar3ARI0mixREMPtBsDAfHZ6DNW1cOULWek8fbM1xn/4RM/N+JMe?=
 =?us-ascii?Q?GgbGjXR9BqbO9Hv+pnFOAyk5VviBQD9LnpIX/jYCXzZga2iCenTYDLeNjfDm?=
 =?us-ascii?Q?iYD5Q7s2L/9CX6R6CBbGMY72351bWHTtTVPloyTbD3hQNa+orp3LtCWsuCej?=
 =?us-ascii?Q?AuO5pFzqCUGWGR1rqT0xAwUJbdMNxRQoub/nPuSpGrTB7Gl8yJozQDKDJJ/U?=
 =?us-ascii?Q?5BtCuYJLrBBEabxHFZzdNjyCq3dZDJtbZVZY1dzv2SMHm6K0oydNb6bhzqoV?=
 =?us-ascii?Q?TuRT14AD/lPy7PeMCOugfEKzxx+/xHvXVvO0rknYEGBxBMwg8INDhOF3QzxS?=
 =?us-ascii?Q?J1V7ltkRME687vND7RVlAeDpSkU+8E9LarjbD3qcmXsDkgR7HPUpNxyN9iM/?=
 =?us-ascii?Q?1XLyYDSjo3tRo8Gez95C5+JROpr+nx/cG1rwcR0BL8zCbKeH1NyD/b3W3S6w?=
 =?us-ascii?Q?0xoAyz+UG+TW0PsiQ6mBLdAvgB3Mt+Cdi/ZyvnZi6M9Nplgs7GzbnfjkPDWs?=
 =?us-ascii?Q?89iOEcz6srBdnV5Brwwi6XvJlzSCPscsiFCTJx1yefHfvWj3ctrz9o/GnGHf?=
 =?us-ascii?Q?snEwM4faqKp9Ez2jh9e3UfSUH9mBtHqoweg7p4ikrngoqNXotnJfVOi6zNhA?=
 =?us-ascii?Q?LRaeU3xEj8KQYu2+fQFwQki6j1vbNr16KPX6Rgc3TRa74G5VluvJI/nd+A7n?=
 =?us-ascii?Q?M5yzSeli5fr3Zab389/HItZFWsFuXG+hnvEnWjnSk6tLxuQimwplQ781QKzE?=
 =?us-ascii?Q?iZ1DRwTK6k5cDNacvFZRx/wkXwt7n137/QLMdcHEd6E2BEjOVhTjelqqbeVO?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd4e41d-438e-4af1-515a-08db35f7ab66
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 17:03:25.4141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gqoN6GJzfZjSgo/ZMOPtfuPzwsSR7FSwNPmIoziyhqZ6N6CcTkXn0KY7HezcI6V59mUhpuueTBuVAN8pFOJmxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8405
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 09:42:10AM -0700, Jakub Kicinski wrote:
> This needs to live in the core. I think the real_dev is a lower of the
> vlan device? All the vlan driver should do is attach the generic helper:
> 
> 	.ndo_hwtstamp_get = generic_hwtstamp_get_lower,
> 
> and the same for set. No?

The goal would be for macvlan and bonding to use the same generic_hwtstamp_get_lower()?
How would the generic helper get to bond_option_active_slave_get_rcu(),
vlan_dev_priv(dev)->real_dev, macvlan_dev_real_dev(dev)?

Perhaps a generic_hwtstamp_get_lower() that takes the lower as argument,
and 3 small wrappers in vlan, macvlan, bonding which identify that lower?
