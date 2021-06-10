Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1B93A3038
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhFJQKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:10:36 -0400
Received: from mail-eopbgr80113.outbound.protection.outlook.com ([40.107.8.113]:42247
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230166AbhFJQK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 12:10:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dV5o9n79T0v4OUO8/+EGtqv5k40wlD7fuf8IkfRKCjO2SHeGAyaPy+imQV7efFfKiBuZxiTkn5Iae4Vxr1bbhr0ztJAQA7Z5dAsWe24NsuzDFn+r5W7bRoaz6UEK/xh2RPQhQo8lSqteExhpMmbYPgXfJ9uvO7f9EEWOo/KH2mDrbYJcUtkbB5Im0GHLXcGnHJBoi7km4/jhnVc4f6pDmOBsB7ovfaZG0CdFHcYFP8t+cCv5/CASJSWHpXYeYPFh/kVvGd5mUNJwPT9EsOQ3NYXE4zO1YgE5mpRwjOm04ye4PS4UM0S7O0/d1B1cIOUoMOFGFJKKPW8Ov9fmOZiRAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnS5ednMH6uQ+ILIKkfff6BrBZscg0rbdVfmhDJ6K2s=;
 b=gFRWZJtd05j9YzBf4bpnuzx8JXo5V1x7REIS/qeF8HIQZCpfilyJn3PVNqQ8Ic6Ixkbn1RXrXdWqi6x5x4SPqnIzO9aZD4B03hoNuFP+cZp8Fc2MsfCE5eABpmjYalWAwndO4wyBnQMuPPPVW+sKiVqbra6/8DcO7DOCMHxyMX1qX9ZSvi8foturQbxb01p4iOLNmSLiXCjhW0654Br0CXIMwyt39dTRnmAaKP2Pwxy4UEecY5d+62WGo/9HxdCqkHlDLrENuIZqum6zmlDyTn6S2wTNoXbzrqqWuVfzIgapsojyj1TIIV/Zk+S+X8fLknqADw10GF0y7qcX3zE7hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnS5ednMH6uQ+ILIKkfff6BrBZscg0rbdVfmhDJ6K2s=;
 b=fDt3RqCrFFsdZ7zcEAxCZaPCy8RaiD/5xqZ9GVmqKSTYuLRQIS28gshtCbwWCOjfmG39XoD3x/L5qj8tIaYQYOoMmCQtpC+9wGysJcICz0ieTqrGxfCzrA+92KbRUDxddVs+9pIXZS/81hfEOEfXAo8kkVAh1xJBWL6NMpD2UJQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0428.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5c::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.27; Thu, 10 Jun 2021 16:08:31 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.023; Thu, 10 Jun 2021
 16:08:31 +0000
Date:   Thu, 10 Jun 2021 19:08:28 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Taras Chornyi <tchornyi@marvell.com>, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH v2 0/3] net: marvell: prestera: add LAG support
Message-ID: <20210610160828.GB29315@plvision.eu>
References: <20210610154311.23818-1-vadym.kochan@plvision.eu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610154311.23818-1-vadym.kochan@plvision.eu>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR01CA0120.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::25) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM0PR01CA0120.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 16:08:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19206592-d135-4852-bacc-08d92c29fd96
X-MS-TrafficTypeDiagnostic: HE1P190MB0428:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0428C0D12DCE89B9055E78E095359@HE1P190MB0428.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y7E08zoH1fbRCtEp69SkcpWSG954YBzesbxOUuJEDKKXNHKCSreN9EhHApbA0p8xQW5NnzOZUASFObnG81mX9BXm/2Pg6/eR+4GrEahG5LxB6/EQj7ZxZaCVKlUdGqI0daQiLMZk48gIa9OdnYOd1IFXoPHUKPgQa1X28r/Sxj5LUfzP6ZD54FNdi1P8rtsEHoCJiUyRIUX47Agx73GKwM1UX+2E/idGskn7uHvtD3Jsd6/z4y5iuw+P6Ef4NYMbQd/Yrwvj5MmXjgY0g7TPLXRdBggs0lgrUrs4nt+alRjh0UeQJLeRX3995rCqp3tScM4nIdLeeQxcnU+GZWCW+ozcslaD2W/ev7rvz66ytuByUSm/5PfDl6mxM/qEN7VvRcwrwhKc8zjBs71X3fSEM6m+E5zLBQ21Sp++QqK3kRU7N7RvTfryIposNLRKhdecSyFWWxkTzsLRP7ZEM6kwykzHEMLFwW2zH3j+HftZRu4t4PNA4dc5R46pha2PNjukUVk1mftX4a76B4zCQgVHd22aSl+UmgG1w8UrNH9afTv0amCHUqXXJHkTis/7Q/A2e0N4zSCX826XjLxxo8004KUFR68MIx/xRZQyy258UMFZv8vdcB36u61ZN6Ip6DiDumwYk+XRfWmEC3df8dsSS6t2UMOcezAgaALFmPRmeSu5ZQnsICKqePBmVIqruDm6oF3a6lrYB3Pv65ytenNIzPeaGHjdclqNlGuTM9GCZio6ZyndR8p6tW5REk/8oZWw3e2eCKraVgu+VBaVWgvoiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(366004)(39830400003)(376002)(110136005)(8936002)(26005)(36756003)(54906003)(8676002)(16526019)(956004)(186003)(8886007)(4326008)(44832011)(316002)(38350700002)(38100700002)(52116002)(966005)(478600001)(5660300002)(1076003)(86362001)(66946007)(66556008)(66476007)(55016002)(2616005)(33656002)(83380400001)(2906002)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6mPBVCQ4TOIyoe/CuuRiPpYyqI1MqVITqX0I/z6zYXzUszNDHBRPFCGNlUMa?=
 =?us-ascii?Q?g9LtM3MGWx5Dg6zAIEZwz61RxfiTrBG/ipenTnldEq7lYhi0hRdWy9W1u/P6?=
 =?us-ascii?Q?pdl/G0JF/H40oizW41dn93F12fTmcvmqdOhYZupFYkOsboQSz3+Zg350I+eu?=
 =?us-ascii?Q?j+WcBhak6aRPn/O9wBlg3wVWw608Rbs3L3O5CyKyNd42YNV/KcQbBpeuTLtb?=
 =?us-ascii?Q?AB3g/N4AJgU8EXQGE235QuS1VLjYvyqQ1BSiIrCK0bEYVBhGjaEa4qSO3YQG?=
 =?us-ascii?Q?3/9ltM5EKWkVVnMSRrdxS7JdenmW2GrgRWDPZqgDBADfSOgsXT/aFZMpGrqL?=
 =?us-ascii?Q?8Wgzp1Rr24FgHseGMl841ZR2VFHjcoNGRcr9Wh9QS8gD8Fogw5anh8W9koG3?=
 =?us-ascii?Q?CvJRfKyN2RFZD0X6iybVGSOFjU9Hz3f/nMCeRooCqFZSVxt3AliSzTSKoGQc?=
 =?us-ascii?Q?xH5sER8z3U1vMAR9B/33HpVl+d4ld0nyu+F1zdMQQM2OEnpgx6jzHuiZQxl2?=
 =?us-ascii?Q?tGrvzthOuLFBHbV+Ng9ULXf4gVWh10zrWRh3ubWg9pORl63oSa3LpLXQ8vqK?=
 =?us-ascii?Q?oGDE1XOL/YUFlQ10vROwXaLAQxHLSs0kBlwA9mof1G10M7XDbhceS4pvV3UJ?=
 =?us-ascii?Q?PaQZAGko9TIKRG+N1ORCULlnS0D7uLQki9QcB4snl6fFJC7JpOZMShlbTkL2?=
 =?us-ascii?Q?zBo6EaPdyplbFftmo1Jr7dIgGna7MIz4tmijsOqqxF+DS/dZ68L1CBPrrqOa?=
 =?us-ascii?Q?oUymwBFO1DwBGSruXb8n99wp4/SO7YGbqYqAuV8r4po8GQYG3X28Kn3ERHDa?=
 =?us-ascii?Q?rnAHMFCZ2bOwyk9Sj0rLLBKC3Nu0oosLBYqLAapsNg5zyuJhPxyyU7dsjtgN?=
 =?us-ascii?Q?U1HIFdtpv1uaufDVBtZTkSH/v6QiEoeuDRA206JfjpcCtotbGPKplw3xmn1A?=
 =?us-ascii?Q?M8LWcz/C7HSqYUgyy7xBbzarfIWmVFGzp5WS4/ero/g+u0qzAkEdYySba5VN?=
 =?us-ascii?Q?/YcWrPmC0qUCofjUTpfl/KT1AT3u3lP+Lpe08MNo3v+V7IefVMaySuvDsL4E?=
 =?us-ascii?Q?qkU7UK3GE7DYZFjl7cTU9uUZ5Ugi5pjeSccJ9YdVgiQcofA6gebOGE7u7qhX?=
 =?us-ascii?Q?meMJsOClJC6u/4quQ6vzZYYeHAIqlis2lYWiI/5X9yFbcpBUsbwVFKwE8bgL?=
 =?us-ascii?Q?nAA/SecCncGKCTVU5kOhkQjyT/C8G8+H6Y2w1EK1VYMG4MkWW/GfLE4ockru?=
 =?us-ascii?Q?FMmIChxdDRzD+jeRgVTpv65EEv6gQVUWD/vBpIRxeCA6eV4aLd0dJuHLcHQR?=
 =?us-ascii?Q?F2sw9Y6z3KOOoLTu7lOiNu/R?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 19206592-d135-4852-bacc-08d92c29fd96
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 16:08:31.0600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qJ52z+BXBMpaZNMnHHQiYREj1veBhWLgVbqOCQf/FeMgXnuoa2wMG41YHT9uKQQLaj6zuEVRtuOUcqDMgA+R30OvGJIYZfyLQ0r6SQAUl3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0428
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, I did not mark it with a "net-next", will resend.

On Thu, Jun 10, 2021 at 06:43:08PM +0300, Vadym Kochan wrote:
> From: Vadym Kochan <vkochan@marvell.com>
> 
> The following features are supported:
> 
>     - LAG basic operations
>         - create/delete LAG
>         - add/remove a member to LAG
>         - enable/disable member in LAG
>     - LAG Bridge support
>     - LAG VLAN support
>     - LAG FDB support
> 
> Limitations:
> 
>     - Only HASH lag tx type is supported
>     - The Hash parameters are not configurable. They are applied
>       during the LAG creation stage.
>     - Enslaving a port to the LAG device that already has an
>       upper device is not supported.
> 
> Changes extracted from:
> 
>     https://lkml.org/lkml/2021/2/3/877
> 
> and marked with "v2".
> 
> v2:
> 
>     There are 2 additional preparation patches which simplifies the
>     netdev topology handling.
> 
>     1) Initialize 'lag' with NULL in prestera_lag_create()             [suggested by Vladimir Oltean]
> 
>     2) Use -ENOSPC in prestera_lag_port_add() if max lag               [suggested by Vladimir Oltean]
>        numbers were reached.
> 
>     3) Do not propagate netdev events to prestera_switchdev            [suggested by Vladimir Oltean]
>        but call bridge specific funcs. It simplifies the code.
> 
>     4) Check on info->link_up in prestera_netdev_port_lower_event()    [suggested by Vladimir Oltean]
> 
>     5) Return -EOPNOTSUPP in prestera_netdev_port_event() in case      [suggested by Vladimir Oltean]
>        LAG hashing mode is not supported.
> 
>     6) Do not pass "lower" netdev to bridge join/leave functions.      [suggested by Vladimir Oltean]
>        It is not need as offloading settings applied on particular
>        physical port. It requires to do extra upper dev lookup
>        in case port is in the LAG which is in the bridge on vlans add/del.
> 
> Serhiy Boiko (1):
>   net: marvell: prestera: add LAG support
> 
> Vadym Kochan (2):
>   net: marvell: prestera: move netdev topology validation to
>     prestera_main
>   net: marvell: prestera: do not propagate netdev events to
>     prestera_switchdev.c
> 
>  .../net/ethernet/marvell/prestera/prestera.h  |  30 +-
>  .../ethernet/marvell/prestera/prestera_hw.c   | 180 +++++++++++-
>  .../ethernet/marvell/prestera/prestera_hw.h   |  14 +
>  .../ethernet/marvell/prestera/prestera_main.c | 267 +++++++++++++++++-
>  .../marvell/prestera/prestera_switchdev.c     | 163 ++++++-----
>  .../marvell/prestera/prestera_switchdev.h     |   7 +-
>  6 files changed, 573 insertions(+), 88 deletions(-)
> 
> -- 
> 2.17.1
> 
