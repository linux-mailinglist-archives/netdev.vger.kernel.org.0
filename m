Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F85559E6C4
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243565AbiHWQPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244223AbiHWQPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:15:15 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEF916BB98;
        Tue, 23 Aug 2022 05:37:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPyKQEB14qU8NggV3WqWjx/6ZlW1BXr4NDTQ54Ngs+xnNb6hJh8iXi2bZEygvbNJl8rwxH+lV4Vyw8yWe/hXa4YM9y9GdwjzxOVG1B/DZIpy+yKXw5IU9/YNH3piNK22Pxb6Mr3TQGDPfBqcYX2JsIQK4FKj/3/lDuwvRtl5zpdcQP0f8/i/f/qBtikbrZL4mtGv/V9qJtb6yA0+szpbZ98/Z1HWlFzau6+7PbhwWXEe3GUilKcI6g8IpvylYDVD6l+/W2MfFWgR/rId6tT0Ddv/Lr+OlWiwzOskYFl/nTbS97yFV9/+/DIXRMMd8INL8f9ZeQdwHH1dt2LJIczBwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7Yoz7i+X78Q6PY52NJZfwNPyqtSMpBgclD3IJggYOU=;
 b=bJJp8acXQLSJ6LrH94fHi6pMyuJptc1KQ5Ezjg3dOXVsU+5FwmoqXW+ahFV7bbCgu4KQU6QY17Dfo5skNwKpmkTwf2dHDVbno5tnYIsiHaSgsIpp2KZ3Ixh4tLNWwvTCvv4gEHHvStEDdOLR9GzxsOAKhKQomUgGsaW4jeSzy7E6p63jXDQG5SeCWbYSoEjn5eO6HDzdln4w5Whu71no0HBii/4+LiiN84wecaPfw85w91IEHpN/9hyIDEFChLuyVCDjB1JBKfjOw8EGKzYD7un4lzg/lgaG8nhcvGwo9uSvIeQU0W6jMo5IJCXy5jIZ4+1ob6kNlicxFEZPhqj/Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n7Yoz7i+X78Q6PY52NJZfwNPyqtSMpBgclD3IJggYOU=;
 b=UGfphOECnWHOfHo2rg+cZuyQK8TIET4Rj/sHq3pTNkicF4aJNGRiWxPtMRtAIsj8Z7TZnawCYF/ZWvAtpGuXU22r3/4O/rVO0VptO8GVeK60owaUvQEDpBtPvFGFZ+UyHThmmbmwJ6u0zDHEmxLfggi2MLzsTq9MPKKA5RBx0d2B5FArS5ltplH8kAKTfRUlinTWL8lVC/TVCZLF9jKM0XdSd2/3z9AxgvZiQZryTanWyUrtFgl118CfxhGBhD7XT0eTODerNvYKWCWjF7xKJHI7xrmXKI6YgfSUKee0VVWwyPNjgvFc8TBKU4Vu1qap3oaRMukg+g6KwHOYhu2DwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by MN2PR12MB4423.namprd12.prod.outlook.com (2603:10b6:208:24f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Tue, 23 Aug
 2022 12:36:59 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5546.022; Tue, 23 Aug 2022
 12:36:59 +0000
Date:   Tue, 23 Aug 2022 15:36:53 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
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
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <YwTJ5f5RzkC/DSdi@shredder>
References: <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
 <YwHZ1J9DZW00aJDU@shredder>
 <ce4266571b2b47ae8d56bd1f790cb82a@kapio-technology.com>
 <YwMW4iGccDu6jpaZ@shredder>
 <c2822d6dd66a1239ff8b7bfd06019008@kapio-technology.com>
 <YwR4MQ2xOMlvKocw@shredder>
 <9dcb4db4a77811308c56fe5b9b7c5257@kapio-technology.com>
 <YwSAtgS7fgHNLMEy@shredder>
 <553c573ad6a2ddfccfc47c7847cc5fb7@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <553c573ad6a2ddfccfc47c7847cc5fb7@kapio-technology.com>
X-ClientProxiedBy: VI1PR0902CA0051.eurprd09.prod.outlook.com
 (2603:10a6:802:1::40) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 091cd502-32e4-44e9-3b70-08da85042c16
X-MS-TrafficTypeDiagnostic: MN2PR12MB4423:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: It8QFALzmJame0EyuNwo7GT35vq0CzgdNW6ee3DjMPt8YoIxPuz/zgtl2+k5nkZXNZDEm1UtEF2bCg6RNSkEnLUDpEmmWndxvk8lW/2nfhpdQRbNvzJ4OjQLr3SxaihzMcF0ljxUgfTrS+IGCc/MrZgVytDxQgazONAFLX8Z8tBjxNcjeiOD2rQBMmYDd79HxdkikZtERHuhI3lttSf87++of0aysUMb28f7v9k+S6DKtFtvegwk5ZixybWeVnjEMJooE5FL5jbBSe4eAKT+Bywu1YMAheXmrpA3AbTQbkLr5+25viGdo8h0Od9f48V5MNf3Cd2Rn246R3/eCOdA5yCwX1oRRT42DgceBeuL7jgMT6h6jvsF1sGc+QxKwdh8d6YL7JO7/TMSDhSmb3TA649cAThdz15xX36YlNpV2+ls4HuGle4Qx0VponnWtLQUzqs12/49MqWM6lK91lY2s0f4OVynBxVjk4VdwD4SY9BuMbjJbcdVuJgvvxeRq2noCBHCyvhcj9XIS99ZuHc/s+UQ1rLjwGFwdWHtRWvTzCXs6fcCvzR8dc2tAI+CRPMcQFL7m6fciACpBx47+00vtzlGO1lPvnxanESY20f6lh6pYD9y3rVLtunUqp0abORchBUZ7e3BnhR3Yjhd0vVaHkW/I7InHHpmqT4sBdm1Tt0HLnFxO6csHddmk9aqSDy3ZP0zO+LRKtpFvgp6sTW/5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(136003)(376002)(39860400002)(366004)(396003)(86362001)(316002)(6916009)(8936002)(54906003)(7416002)(186003)(53546011)(26005)(9686003)(6506007)(6512007)(6666004)(2906002)(4326008)(66946007)(8676002)(66556008)(66476007)(478600001)(33716001)(83380400001)(38100700002)(41300700001)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mSMHOXzLaaJKSBzty0ssdOGONMsGcn8awYX902IulhtbKMida4b7zD3uv5zE?=
 =?us-ascii?Q?kP7lh6S4ilMZwpG92NiiuQ50Wr/Q5yc7RmJRaLsc9a32nSbkGIvH+LdUamFA?=
 =?us-ascii?Q?s+ByaTMEI33Sfr61/P0NpNgKKY86+6+KoEpGuRKtevvF1wqOUx1ht47kyF1X?=
 =?us-ascii?Q?l58X1FL246Yj+iCYCGpJWwRvS5hTyvi8w68UVTEnufLEpEimNifp4crdraFB?=
 =?us-ascii?Q?m6y2qrKdfb7KiekK0p6N6G6JdOdnLUSRu0QRuEXcDoj7QfqDH3bQT33FI+7i?=
 =?us-ascii?Q?IEWwRIgvtPXdmsQ2/7vxrZbiVFCgo153+f7jTb2kYAWEBDL3lWh9zHSe6dhD?=
 =?us-ascii?Q?2WpCFOr8PYCGKh3WAflGcJ0W9xqQLZ1ifu29LA8wYAEzHJ/vLunpm750Uhfo?=
 =?us-ascii?Q?YKah46FYPxEw/xW5UtBntKjv7O1PSnXbZws116u/vP5X+kxinlt9+53FiwBN?=
 =?us-ascii?Q?LTtq/6FZQK7ZMQy0SNlP/nGzkc50L1JyJhPDnoyxNkbz3fR1CDG+XPed588H?=
 =?us-ascii?Q?eSp2lDQU31bB9j3808ChqsIenJNQZ3I7hUEpwPLFV01Gah1ocWvmFLTMcVNA?=
 =?us-ascii?Q?fh0Ph5KypDes4Jn5VR8qfHIi1Pgd5dzX4tcpLkLRqtO0rK+VepCT+GcKMmv3?=
 =?us-ascii?Q?XHEftKbBp1yrhuMP2Yz3lHcvylDV/V0auOpyoBat6fCcqFKpexUDtxnOznsD?=
 =?us-ascii?Q?KyTamZWRA5NgtzBk1MgejvcVyWdZg3n13hp7zyJuxJvWwHkVy/DDc3U/7DqV?=
 =?us-ascii?Q?9wF30ihnUAkMFqqK08IhwuBujmcKC5Yt5XEPsimPcXgFri31o50SGDUdIgfr?=
 =?us-ascii?Q?FJP/ROysEGs/2QBe2bsuz1CWDn0ZIhPURwDfmeWG/pB/AtlG5OXf+WMxsteT?=
 =?us-ascii?Q?LX9fHj2aRLFcEmLnfirRCB2yzkbgK/eMiJORGlftszeoO40c6Zel3W9HHNxn?=
 =?us-ascii?Q?LhjfJ97/VhMnTwErnBrqR34r8xeWK7r9/5ZJf48lqwlk+tFm9JTt0FXPgQMT?=
 =?us-ascii?Q?oDeUX0tY0SuBnYNy4BpGME3BOvzyxysVnx5YlRAKcInnrcNAPz5d1LqZFFN1?=
 =?us-ascii?Q?Tosy4AkehvdsR2EnEtAJYbeI8eV7AT3Aw6XdYByPIG9kX8LR/LVknCtUxEVY?=
 =?us-ascii?Q?6jnmF+iLtyzBAKHlIf4xJE9ZKOSRLO3vA0DvBV3u92rSe2KdgxYQduY4onl2?=
 =?us-ascii?Q?OJX2dGgBYLJ+yodZbAGx0HJSIGHEN9XKHHSYZaPRldM3C6XXUoPQOAPwOANG?=
 =?us-ascii?Q?utemW/X9KQmBQwSiCknpRWhgNY4Qo1J8jWKtHkWlvmpS4OQnbdL+0aiCwTNh?=
 =?us-ascii?Q?hAlvHNL8KaEX0A3/uFkCdaStCEqcSVeO7hXvJlBvnTkY4GbcZVVU3qli9K07?=
 =?us-ascii?Q?9oPYPK1mFAtAlKSR49mhteOnCaXMExxRi3TAfJ/LOJn7D1CHB+YWskdGxrZy?=
 =?us-ascii?Q?WQebfmGMFn7DYth4CWGiRdHaStWjtwd4UbHXOJjpDB5YbPmDxhkeAZHXirB9?=
 =?us-ascii?Q?YSl+SxXsO4RhDSqINqoyMUxsIsY9IH2NGc0iNnwHOlH0ScFA7y/blfN95tdI?=
 =?us-ascii?Q?cN9YsT0US4CAQ+7G54HQKsXQY1Thq/VM7JMvV5er?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 091cd502-32e4-44e9-3b70-08da85042c16
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 12:36:59.5657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oc63abwyGTRX/HlgHyd4iZzZ2tqdMskW0lNkcDmz/LrWH36xkcr5IJgp2wYhXPoxuTcJ1zEclHXVVw117ZwVgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4423
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 09:37:54AM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-23 09:24, Ido Schimmel wrote:
> > On Tue, Aug 23, 2022 at 09:13:54AM +0200, netdev@kapio-technology.com
> > wrote:
> > > On 2022-08-23 08:48, Ido Schimmel wrote:
> > > > On Mon, Aug 22, 2022 at 09:49:28AM +0200, netdev@kapio-technology.com
> > > > wrote:
> > > 
> > > > > As I am not familiar with roaming in this context, I need to know
> > > > > how the SW
> > > > > bridge should behave in this case.
> > > >
> > > 
> > > > > In this case, is the roaming only between locked ports or does the
> > > > > roaming include that the entry can move to a unlocked port, resulting
> > > > > in the locked flag getting removed?
> > > >
> > > > Any two ports. If the "locked" entry in mv88e6xxx cannot move once
> > > > installed, then the "sticky" flag accurately describes it.
> > > >
> > > 
> > > But since I am also doing the SW bridge implementation without
> > > mv88e6xxx I
> > > need it to function according to needs.
> > > Thus the locked entries created in the bridge I shall not put the
> > > sticky
> > > flag on, but there will be the situation where a locked entry can
> > > move to an
> > > unlocked port, which we regarded as a bug.
> > 
> > I do not regard this as a bug. It makes sense to me that an authorized
> > port can cause an entry pointing to an unauthorized port to roam to
> > itself. Just like normal learned entries. What I considered as a bug is
> > the fact that the "locked" flag is not cleared when roaming to an
> > authorized port.
> > 
> > > In that case there is two possibilities, the locked entry can move to
> > > an unlocked port with the locked flag being removed or the locked
> > > entry can only move to another locked port?
> > 
> > My suggestion is to allow roaming and maintain / clear the "locked" flag
> > based on whether the new destination port is locked or not.
> 
> Thus I understand it as saying that the "locked" flag can also be set when
> roaming from an unlocked port to a locked port?

"learning on locked on" is really a misconfiguration, but it can also
happen today and entries do not roam with the "locked" flag for the
simple reason that it does not exist. I see two options:

1. Do not clear / set "locked" flag during roaming. Given learning
should be disabled on locked ports, then the only half interesting case
is roaming to an unlocked port. Keeping the "locked" flag basically
means "if you were to lock the port, then the presence of this entry is
not enough to let traffic with the SA be forwarded by the bridge".
Unlikely that anyone will do that.

2. Always set "locked" flag for learned entries (new & roamed) on locked
ports and clear it for learned entries on unlocked ports.

Both options are consistent in how they treat the "locked" flag (either
always do nothing or always set/clear) and both do not impact the
integrity of the solution when configured correctly (disabling learning
on locked ports). I guess users will find option 2 easier to understand
/ work with.
