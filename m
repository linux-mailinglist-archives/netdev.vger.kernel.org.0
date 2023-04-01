Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7311A6D338B
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 21:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDATa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 15:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjDATa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 15:30:56 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2073.outbound.protection.outlook.com [40.107.249.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1575C66F
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 12:30:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZWkV9+3B4VBKu7O/bYEDZ67xd+TWttjca8hZ9nI8qyFGaHnWC4bVqVEMsCSPrJel+47/K11CiTO8zd+PmkfplvHJaQrCQjAnEc/1S0awtIooYvWrdWvM96JYV5HYQnAr/5uIVLdVU/wFwNuNbxHA4JqkXFZwkmNPq+0LglCUidazbAz+Fdq1ogjYQ0UWWhBNGGE/GI+6GeeEdxjehudCtSZaMdFzM/xB7/eAKh/T0SVoq4GYJ6evfibfYj1vOen08znB7sXb45K0SyFIxEapgx9C9qj/IuCIKCLNKc+MVAU+IeTwsfEUahAU1KTJQPEZz3dwLeGSmGmTcBhvMehjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cmw0hG94esq+mjpmbmWiKEUSV/KNtf2LbmOadUHVu38=;
 b=JDEhOFAGTcYFmZDjaRHtv5vK6Il+jJNPkstA/SVwAQR8hiO6KZGUu9DwV1udmBYsiI5vaB90HwDg0YsQNNLjR91LaJ6mwWdSVR74j3vVoYv/aZJDL30cEKqkXnT9loglnNw2SwFFXxj8wYCzm50Hyawow0uZWYcbeu4MO8zPfUAGfrY3PbQK+Gfm3+7ktn+TTS8uhQWpdSQviYEZuUlUzk/3bRbkHz+GD/qVMq+zQ3M1ZXC42SrlFNRgpEVnsx9/6w6qm0ImDdDpL0Xd1Yp9H8aEPZslsDuC8i8FPWdV/83B9Up2iRoUDqvpLGIZFazMbXXMZ96sZLg0gafhAJhCAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cmw0hG94esq+mjpmbmWiKEUSV/KNtf2LbmOadUHVu38=;
 b=mqAuMMwgcLXOYjBOuOFTFmBL+OgMB5M0RHGa9vO3p/AXZCiem9bOewzqf+kpjFK8TdiJ64d3Fk4G9ZSUej1SthwOt8gwAVswar8q9G5kHArcuO5/eKXtZF/QvIyzYIFRhqKVVD5FpehuwUP4bl8Fk+GBF7qH0cO4G913BJuuQu4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GVXPR04MB9849.eurprd04.prod.outlook.com (2603:10a6:150:112::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Sat, 1 Apr
 2023 19:30:51 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sat, 1 Apr 2023
 19:30:51 +0000
Date:   Sat, 1 Apr 2023 22:30:48 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Max Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230401193048.f4j3h6mbe7ti2zo6@skbuf>
References: <20230331045619.40256-1-glipus@gmail.com>
 <20230330223519.36ce7d23@kernel.org>
 <CAP5jrPHzQN25gWmNCXYdCO0U7Fxx_wB0WdbKRNd8Owqp1Gftsg@mail.gmail.com>
 <20230331111041.0dc5327c@kernel.org>
 <20230401191215.tvveoi3lkawgg6g4@skbuf>
 <20230401122450.0fd88313@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230401122450.0fd88313@kernel.org>
X-ClientProxiedBy: VI1PR08CA0217.eurprd08.prod.outlook.com
 (2603:10a6:802:15::26) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GVXPR04MB9849:EE_
X-MS-Office365-Filtering-Correlation-Id: f0b07ba2-5449-445f-0ffe-08db32e79a82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8O7c3KDCe82lxc6EqitEmZkbAJ2Iv6eKYa4sHfIr/g1Y29Z6xVdsPAOQvNzrRLBQ5N99No4v5umWBxlh+J7yUE0vySj3hBK8z9KW6tn9Trnc/YGY+xaYo41Q+C52G5SbRq3O+UQwe1gr2M2pdHBmbKTC1DErot7ofhrU8M0T9JQCYwkDhXzSrsBYdJTB/pu1mN14+UvU5XAU+keA0POrbUUPVlvPGvy7ymWv+UTEg/63sN4kfydjFMPCUHDMVupvpMkBimC7Wv3J6wYRyzgq10zgjmfNZsIIVG0xHb0qXAeKKF3T0hSDqAQpKOWAGEu0/PZfBWdGm4ogXoyyTR3S28JqrervZnWWt+apHLYZU+Gl9lQvvE5ND2x7e5I+7xSezfp5npN8KNCjlqQDTrmGW4RHqIxbeAhbhx1e9E1TLcGKlHQppJazThJ46eG0+6nTue+I0qC8asRrTGM2wNzTxg0IZt7DVeBhVPUU9NJvz7jVWjdz9We+j4hoIBaOAESLxFSyBb4vHOVRp5P9K0YSDowf+A0Gat+4lUdSuwoypQVnL4vZibYu3bJ9JnFwPF9C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199021)(8676002)(66476007)(6916009)(66946007)(66556008)(4326008)(44832011)(5660300002)(41300700001)(8936002)(38100700002)(86362001)(33716001)(4744005)(2906002)(478600001)(26005)(186003)(6666004)(6512007)(6506007)(9686003)(1076003)(316002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RXgUKq60aRHNxfDs2ewz4XuMbh3an5tKw6RsXIt4+l4uBIJAde4ge00MtUXQ?=
 =?us-ascii?Q?hO3Zk5VbZECOpcGIk1qGW/BVOqwA9TvIBb8kKvKMgQwM9JDJv8CnJwsvofEm?=
 =?us-ascii?Q?Lg9dloBsbmlW5ZCp3RfjogHXGSiqNuArWyt07fEvQm7XwB3wsl2jvS8lmawO?=
 =?us-ascii?Q?f2eekLJkr0W5RaZZ7DEh5ARYWxcFEpAY0keSHrFI8VC5HXg6bc5Qz0Rnomb5?=
 =?us-ascii?Q?qkPzkb4sQG/XcPbHKpAUEzY9RdFKkaTohvsbeyQulO0qv5ZURz2x0iuEIUrH?=
 =?us-ascii?Q?hPmL5/XWWxRX8hLvEE6GsG0pSjwG9Qxz7rWtad7lVjGqcEfgAc7+jW2wdUtw?=
 =?us-ascii?Q?MmEBzvD9MBDaPBB/KZ44T0imc3zAyy7U4SdEaNtz0levO0dmtZCfDj4kQBBW?=
 =?us-ascii?Q?Gd3nsJn5SLlDfLs1wSe0rwXkSHkOd2ZHRTur2QJl0WvdVPs8kW8JwPEuaInA?=
 =?us-ascii?Q?u8L1I8UljiFPa3IbfuggoJCB+SmOhDhQ8iT1frcBxCM2TbWBsTcVKN+fov8m?=
 =?us-ascii?Q?aLzp1QUdVLH33DNeO3hkeiKaWrQnSTbhmYPxE9sCDcv37FK/PblCX+pZbR9p?=
 =?us-ascii?Q?3Jbj5bEmE0T+Wn8mXhXIvlYn+2rSauonh+C6ELQidWpZ7PbrReXLTQsI2fw8?=
 =?us-ascii?Q?93yflbokryAS4m2Vn5Qv2d3jHPGiWxNG9hkKxwh084Kzi0hywvE9kGtJF951?=
 =?us-ascii?Q?a52Aoniwwl5bywgQ2Uo5ZA+Rwczhckn9tidjudcSooTfIMacHvmei5WIQrKA?=
 =?us-ascii?Q?17Njkq6opw9hQDmdc/0vmR4EfHjMO+qvV5GNYpn6BKylzC20QMXNJhyiiUJ2?=
 =?us-ascii?Q?QT5f20BfEtkOcWZHtgqjv8Gf61pXRdESNbsmdMtu/Ft2WEc5kY4wsvJVakIj?=
 =?us-ascii?Q?M6Q6aTHhurxeZLyhUyKv1Q0RNVLwpqo8jcwFs08wPhfxR6mvBtrTx3famPO9?=
 =?us-ascii?Q?TZnYG4yTxG3XIkmFbBkniMwlrux7ZlJQ3F+PvBzmMe+lVkii35ARlRdWVZ2B?=
 =?us-ascii?Q?wGxJ8BVJsjxlmQwLKaRgFbZiK1QnYpXRyATn7S061jg9nCw9ETEE9iYsZS+E?=
 =?us-ascii?Q?DPPPPRx15v+HqrmQFEqPIUNIolZX/ZunjTqR8hUpyoxOznDSYnYrKmGsELC1?=
 =?us-ascii?Q?AN/fbVoDoUjkz5jnn61IgST29k5hsHOhxOecxcVOI9t4kXlDYIRaU9Rw/7o7?=
 =?us-ascii?Q?NfTlSvZ1Pslz4iS3XXv0GHmTj/81NyY2sIhEzIe7IaYriU0X4vugAn3vG6h+?=
 =?us-ascii?Q?2kiTZhtGnhoLQcs85pQnLFX7tH2osugIdYTja/O2FCQnC3jZhRuXicnubXo8?=
 =?us-ascii?Q?4QLAkuAjeIcgIcvaO6ArhDZvpYY7CSPK1WdZZn6jBA8k4EbeXfrXFsA2YQX1?=
 =?us-ascii?Q?8DMk/REIF7bz+0/otQXL2GpX4AjTd4Quj/QwykeZx+IJtvmSw4snGtvlrR8r?=
 =?us-ascii?Q?JKRcaDw48axj0bHEWnsZyipn/yO0daRwHvqa4BMXhEfc5C+y9Omj6dJALbdf?=
 =?us-ascii?Q?2oeD0kW3kEHvM5Xe4I6K2pHJKy1kKXPDj89enfDi4bzDT5eCCZj9ZBbCN4o7?=
 =?us-ascii?Q?zIlBbfikeMWB3RnsSxmprL3g7PxUuIq/l9gSuAYRmzldi/TPfjlIXCHqZjv3?=
 =?us-ascii?Q?AA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b07ba2-5449-445f-0ffe-08db32e79a82
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 19:30:51.5720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rBke4471hU8FfRGGuWmXtyWwrbICL5fcIYwBkMmItoc/lwub1txTmnbp1c9Z5PqY3ApBNXzv2wTzOwKBsMf6QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB9849
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 12:24:50PM -0700, Jakub Kicinski wrote:
> On Sat, 1 Apr 2023 22:12:15 +0300 Vladimir Oltean wrote:
> > My understanding of Jakub's objection is that the scope of the
> > NETDEV_ETH_IOCTL is too wide, and as such, it would need to change to
> > something like NETDEV_HWTSTAMP_SET. I can make that change if that is
> > the only objection, and resubmit that as preparation work for the
> > ndo_hwtstamp_set() effort.
> 
> My objection to the IOCTL is that there's a lot of boilerplate that 
> the drivers have to copy and that it makes it harder to do meaningful
> work in the core.

By "NETDEV_ETH_IOCTL" I mean a netdev notifier with this name, and so,
I was expecting objections to that...

I can change that notifier proposal to be scoped only to the hwtstamping
operation, and that notifier would be 100% orthogonal to which API is
used to get/set hwtstamping, ndo_eth_ioctl() or ndo_hwtstamp_set().
