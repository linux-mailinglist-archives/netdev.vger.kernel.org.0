Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D16563722
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 17:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiGAPoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 11:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiGAPoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 11:44:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D902C11F;
        Fri,  1 Jul 2022 08:44:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VV4TOIO+Dd5jfTHb8+vtpns2LeInYvZMHp8RpTb81Erlm63FMO7STuwGL8SE4YL6hWdTYbJDVy/CM+BUHOEU0lG1Vo1bfUT2GBuCI072jDBUN41IdBlmH6yPzagqi9nk5yIUgpSfkHEbN0k2WhBc2DtJpry6ix7xeOOXLHzPVy1oyUcZS8Z8+K6WRvIjx9NSvYUhOCIeN7c4mI5eLbxE8lH/Oa+Gh/KiQ/dV8UFGpKaAH1jvDR1ZiGAT8ZDMFPSnXvQh4+FwugIe3HATktIHfAPHITEcJBOe1c779BcNmTaMcKqB26b/+xHoNLWuN/0ZK2+yUIKQQ03xtVBeUwT+dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2W+jlpxCiLxqPrdit5yv1HIE5bJMcahl5oA1vEeJTqc=;
 b=frQEKA3a9oXcMvTh8IeB7peWF6DcvXpsfBH2I19gR2vy3kgnOQ3xgqDXzUemDNs8dTtW1z09zOkXXQjqWcgxh5rca8JthQSRF5DvVlSRJfPf1wfNU2hi7pEl8kHa87aJGg5kIXrwChHwgzxvlA9S68jWmLI7lR7AkkQEwEzxTrhjSj5Rxl4cXUZ1lTz+/d1ZHUF/UE0xcNP4F9fJw1GEn4dA6YWKdpxwMNt+mFVaBARBmyiteqdLGjzntb9vS5wD/zJ5Aq+jNG+7JXsHPIyJhEuUsvMBr/eMDknDx0pHjpOGj9W/udjjhFseivTaTde9VSqvVL3qTaXLb54N9q1nlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2W+jlpxCiLxqPrdit5yv1HIE5bJMcahl5oA1vEeJTqc=;
 b=qVh3FVpBNSOcxk66xv0Un6crB47gVcB1/sg5YJyG6P0+nbkFcbJYq0B3hhPldLxsLZEs/RLq4pyhK5zJA7/1exCNuoATqMWL0AmU/nKW9JhXPuFMwGqagXSsrzy2P8Dm2wdmHNlkei5QQLcTTZ6vAKNxcn1iQGsdcGnRbK61knjNO+eS4CR9RqsSt34tGxU8Tgq5RfALV9E9+RNKLjnRy3WgoheNecHIZ1qJbSyG6RckET0b98ZNqkrKbXSodDN6NDsqTwGnMPh8QfM+aT4nNBNMBHrZhr9gxgVS/Fgd2UiWKaiMjuKPRQ7D8+R90XlpqOeWjwWSkckqkG7BfMfMkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB4893.namprd12.prod.outlook.com (2603:10b6:5:1bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 15:44:52 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Fri, 1 Jul 2022
 15:44:52 +0000
Date:   Fri, 1 Jul 2022 18:44:47 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Hans S <schultz.hans@gmail.com>,
        Hans Schultz <hans@kapio-technology.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
Message-ID: <Yr8Wb9mTTnHsMQLL@shredder>
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder>
 <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder>
 <20220701152700.sf2h6wbxx6dgll7a@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701152700.sf2h6wbxx6dgll7a@skbuf>
X-ClientProxiedBy: VI1PR0902CA0053.eurprd09.prod.outlook.com
 (2603:10a6:802:1::42) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b8a4a07-dcb3-4346-ff32-08da5b78a364
X-MS-TrafficTypeDiagnostic: DM6PR12MB4893:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQPhJ5TiwWJA20vrD3k4dkMHZNr5SOn+39m+C23XFAPelXNq1yMivCoUEwmZ+BMBXTkfpll5c07sEwm1HgIg6cNE3tXWHugITR5Dwqd1GkKwx9KGzov7NAKHlveG5GAKRGDgVZXL6Rp7dHXqfWqffHgFC6LaudvV1iB4ddgAiTGmySA7TSMM+mZ7xEfFrcWqm0hgMPWJt9/4nd5Jkh+sxR7Ojr+dIehN+ZZUcT3jer57AI0linTykh3c5lzCwbbnE9RJjVzdGNv+sHDtjB6vEnffA3vnItKn5hMLdq2EON3/l+KI5QqsPw1XF++Q12GqD2ZXeDOguzrippRbiEQtK2Heestseewl6JJEtbTbyKYACe0k5oBEiZxaTLOq9rIY/Hj/IoKVXO5ZYT70e9d7KKIH7r2FFGOVCH7ybm4kLTz5BWsY33Hu7r7SC64gPTSJU+EecKRqke5WXeiNmgKqYwqqeXjVWNhNVAyDyev4U0x8f+su/+gtAHyEXzOWpT/0w45qYPkq4P0lMfAjRwoQ5WtlVhi39VMmZPSP9sdhDQ17UgoaeKB2xp+gFPWiQb60lLLTZN4ZXSL4q7+dPMYdQXUIc8Qz7ZxUUDAF0NHmvJvSRKus2RaXQxw68l7OQHik3Zg4N5Qa51kzwDSvS7gLhzEH8hTgiPMejGOU/EGc8pwaqb0J0P4x5x3gNpekrZyTqiTwPEySqZ1wOvCtAcPwrL4+cQ2oM3n6/5aADlFtQfGRIjk6XjvyfWOTXfffx1x+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(346002)(396003)(366004)(39860400002)(136003)(6512007)(2906002)(41300700001)(478600001)(6486002)(7416002)(8936002)(8676002)(5660300002)(9686003)(66476007)(4326008)(66946007)(66556008)(6666004)(86362001)(6506007)(33716001)(26005)(38100700002)(54906003)(186003)(6916009)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pUm2x8XhY0Vx5/RuZ0AroamD1RYbNkxqnh+shZfr8L8K3e1yeFw7bS0AEsdB?=
 =?us-ascii?Q?CXYyBRhpli76GRZW0xBOwTcEmnqbpZQPmT0haqhOC5bbem7umUzYe2aPVAf8?=
 =?us-ascii?Q?JdEn61iIM54qj9kLW5rc7RDEO63z4tW8251PNqlL5at+LzTZtd4p+fv8gdms?=
 =?us-ascii?Q?sqiHxgL3myNiRQE+q3lDU/b1MVZJYmuV08YcW/u/Bbh5OxET6siigwKnSKMF?=
 =?us-ascii?Q?oYAiXifTelU9W10tstXB9d8X1NeILpDBw+eNYxMJXnD/1R8G/zFs03AwJo8f?=
 =?us-ascii?Q?c0eSYI8fw0adTOcHjmpeVi/PcULigCXuKXgJnZsG5i/ZRhS2ojc3l9bQJ3nP?=
 =?us-ascii?Q?XPnx0Pq9BAtSq7mRXrqVHd3pDHP35iTIWnJUC8gykoG5AWvY9YS+gfR+e2Wx?=
 =?us-ascii?Q?8GYRT/FsmZhOHX1iUm+2tI3l4Dh2WwQ5YX4Ov/H/I/oYjcJd7+KpSo36rtDA?=
 =?us-ascii?Q?fZBkLJtgieyOyfV6jGYJOJ4ywalJdrH6iA9bKbloGJ81v86JMSf16BTK6L3r?=
 =?us-ascii?Q?iQTFCIMx9rYM7/QcGFoB+dt1CIr3FruFLuyDGlbcZ/GkM/isSyV+IGVqFEBy?=
 =?us-ascii?Q?YMC4h8891GnCxGGPm1DNRUlw/3FXOMncIy/4MU8bNQL8j5xI07yKzghLJ8VJ?=
 =?us-ascii?Q?WyU2Qu093RA7AKDIWdM2NKeKfFuuO5Fa8Ayk5SH1ewxhTXhZ77motYS5r57D?=
 =?us-ascii?Q?HGLJo3sM0rZRj2qVoaUUGBLLgh/X4XtSrFDITf/Rw4FAHHCGytu/FL+/nQHv?=
 =?us-ascii?Q?nHgIHJMixrVfT88ZcBeGRXDungRXqdod4SuBOXq/3DBM0Kzqxv+DkZupMdSv?=
 =?us-ascii?Q?5IzHA8RsjbVoBPo1ELxvtXfitytlAn4YPdad2nNs+ZHJhL/3fyiOImLQhkqZ?=
 =?us-ascii?Q?LFlkHq/tTdCcm76iGtb/PHkMPfJdABX+FHMN0ct9yo5yO4JUY1mlMePu8gXA?=
 =?us-ascii?Q?97I4ksoVzKqBFmjBNA6Rwapo6gDaQfvmbQuL5KulsFu7SxUOCUOyzL3O1ChV?=
 =?us-ascii?Q?bVA4Wovc/KoDwFMZheJJdKkwNzsG0KiwN9zfWTgQJ6hMAhPxQ+ragYpP2ISZ?=
 =?us-ascii?Q?UGOAOyL7gDgD4osUy6KzW/DwaX5zUEs6ijZrMgMiRyBOgR+Z5yDQEO71vDbU?=
 =?us-ascii?Q?ZPnxH+iKB2WVe2C79T13Y+UVA5Hojg0PqbGP4bXDKI+Aqwha7sDpkB0vZFvi?=
 =?us-ascii?Q?s0CbVzBy2ZQqjp99Zdr8eIChCEX39Y4wfxgU6ZrhwoWeQRIX+FVsZp/5Lgch?=
 =?us-ascii?Q?Sw2CzQgscaGeMgQmi24IA0Xfh65x9WyJsM5uXgxlobivp2ell9RKcH9j1Jye?=
 =?us-ascii?Q?NMKu2EKCn7Qwtrz2XmB1dQN8QAFD4u3rruEhIbRkTQ3stXyMW0FGbM3WN+lf?=
 =?us-ascii?Q?QEoapE/+vBRXh/eEUfdlJrcZHU6fqvnpKai5F+OGHajekAYv4sYh6q3l25MV?=
 =?us-ascii?Q?lQbmjNIsYpGPj6Yohk/nijlRLMS3Ho2MF6P8k8O8uC1Ot897FUYY7pKHQ1if?=
 =?us-ascii?Q?jva0x8MemIg3kk/XEcjNNBP2FUsp/pCkCg/XNAErcqAKvWhskwJ3/pam/Uoy?=
 =?us-ascii?Q?6uh5INjpIlpWz8ckBG0Rgjv+5FElEmVQcopgwsX0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b8a4a07-dcb3-4346-ff32-08da5b78a364
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 15:44:52.3105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 32CQpaRlyIRTkJjGv57iPO+4LXZBlbx8/Z7b0MhKRfuMNb87yEWdbb8EsW8mpRiClUN8IkpFLc9Tu0aaNGG2zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4893
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 06:27:00PM +0300, Vladimir Oltean wrote:
> On Fri, Jul 01, 2022 at 04:51:44PM +0300, Ido Schimmel wrote:
> > On Fri, Jul 01, 2022 at 09:47:24AM +0200, Hans S wrote:
> > > One question though... wouldn't it be an issue that the mentioned
> > > option setting is bridge wide, while the patch applies a per-port
> > > effect?
> > 
> > Why would it be an issue? To me, the bigger issue is changing the
> > semantics of "locked" in 5.20 compared to previous kernels.
> > 
> > What is even the use case for enabling learning when the port is locked?
> > In current kernels, only SAs from link local traffic will be learned,
> > but with this patch, nothing will be learned. So why enable learning in
> > the first place? As an administrator, I mark a port as "locked" so that
> > only traffic with SAs that I configured will be allowed. Enabling
> > learning when the port is locked seems to defeat the purpose?
> 
> I think if learning on a locked port doesn't make sense, the bridge
> should just reject that configuration.

I tend to agree... Let's wait for Hans to explain why learning needs to
be enabled on mv88e6xxx and see how we handle it in mv88e6xxx and the
bridge.
