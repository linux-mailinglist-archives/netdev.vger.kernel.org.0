Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3726E57F4C5
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 13:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiGXLLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 07:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGXLLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 07:11:01 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2E013E91;
        Sun, 24 Jul 2022 04:11:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1gbP13gC6GAtOssPywrpELHCYzbQbi7P1a0p+dVpLp2kYVYbqCA2cr7cL/HNl1lujTzfbRjlvZ2HsLie/H9Izyk/bzaTDlmpKxO7gjNkovm40knWnNqAP3EenraO3oDjxNKOqp6x58U81r4aG9feaW21mwQfpZNBOxY6KgT5gvdrBMyjFoYRb51YQETiBoW5VSWNUovqFx22Zmms9+kyDQSd6hDO3qTP2HnVYCx82kRRKmFrKSNvsm1rJeSAEuEE5MMKkU8qjp6FW/HVeMpldevnZ+pCOh+S1brlq2bgBd3KwFg10cFEFKKeJ2Ud9M/V9GRnMQd2EEXb/1sNIzRXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0MNcQKxcsAcnnB4B7MQ33OX51yaU5uWz/muePUqkNZ0=;
 b=N5W7O2wamM1A9kZI4LBmjT2qH0be+YV2p6v6IkUMGEGflrM9/2+N7pEF4B6EtUTF+HIKkY7/+0pNzrHjnbeHA0LyV5JHcElUzcAxGXXhQ46xkOO2v6u42Nb2CR6YQGbDmcK9gKp63wp8H7m/q2er3CXryLfU0+q0GplmFH5ZXJIlUi7v1VJOl4qXrdgD7MnaA6p6jJDKv5jPQiYBXmxlW0nXu3eIksuGvT/jbln5eA7eK/mFtvmnlBed2dWYjFk/5T8hkFreUK+Ww+XcxCwfSXvKco4brJW82KOePV4p0n0EeXUc+S5sZcTAfhFEAutgq2utG84OqicSCZ8uAkqtEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MNcQKxcsAcnnB4B7MQ33OX51yaU5uWz/muePUqkNZ0=;
 b=kkJYLKLmW4CQUAD+E80e53pPE8jGoxSr/1Mt86UIjHWKZi8hSrYan1dKDKy5DpriH9STiHEIn9OsQAVgnnAMwuFenwm23ZDj+QLIYYYxivzt04S4E/9EzbEhSg5pyyL+krYwJMbyHgJggCaCPk5EvHQuB0ihwbiZkH8X215ggfjysuaLoP+sGM/75utYCMJhFJWpidJfqS0lSfhmcMIlU6TBSKv98NDNH7pQpVC+69UR9lzB3nqFXVPyryNtVr8M/XYN51S+LggPp2PHpFnxW3y7A8d1CcoaqCQYeJHZr+322Rg/wk/98/UnMaCg1kx8jlrRnBeGgMkKXGGrkGw9fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by BN9PR12MB5337.namprd12.prod.outlook.com (2603:10b6:408:102::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Sun, 24 Jul
 2022 11:10:58 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::d1f6:16f4:16b5:b71b]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::d1f6:16f4:16b5:b71b%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 11:10:58 +0000
Date:   Sun, 24 Jul 2022 14:10:50 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@kapio-technology.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <Yt0ouiEcAHs8AqAA@shredder>
References: <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <648ba6718813bf76e7b973150b73f028@kapio-technology.com>
 <YtQosZV0exwyH6qo@shredder>
 <4500e01ec4e2f34a8bbb58ac9b657a40@kapio-technology.com>
 <20220721115935.5ctsbtoojtoxxubi@skbuf>
 <YtlUWGdgViyjF6MK@shredder>
 <20220721142001.twcmiyvhvlxmp24j@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721142001.twcmiyvhvlxmp24j@skbuf>
X-ClientProxiedBy: LO6P265CA0002.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::11) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14040355-3404-4ad5-fefa-08da6d652f89
X-MS-TrafficTypeDiagnostic: BN9PR12MB5337:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TbuTa51tGVcKKr7iQW1uhQH7h1kt3CiCGyPV/qyknxD71hyPmM6cB+K25ZjXR7m+oqr+p610qdfidLh1LIByGcgfrlhyYCqWw1HCmPK/oXyGmR2AiVfh+fVjHPNuBqa8tjxOxpMJWA1si7k/VJSjHCaVM5TSl20e1ZIQqYl1Zg/J2Ysz2At1bJ+oadATddD3D23bMEq6Tr0CbKOZ7vGsl0yD63tkfX7fty1C36LN+MO5otcC07ZZbtPWKhYYpGNh94kGpmxqKWfqhYYWWl9hyLkqn3FCQy404LoGzSZS560BV1/OdJIFvf8jXUbCw088DxrBrO7y/ycO/qwCnmh8SxXD3c0zHgTCyoo2d5Pif+7aiOFDl8tochZ6LFeysEewdDH9eQCN4kKkwvvBRuxXYD02iYPWDJjB0HA1Qut+KTcPD2dJ2D3fZgQU6UF03zCRNa3BHymuU4SgC8lwrWlgkXpntAHtzoGQSMyRk4TYgJVaSgXUa4P97e1O40ZS6WYptIotz6Rb9Jsu2o9oaPSFdiIBfaZfXPSDsoYDDAeLp/jX2bVU3B6d0cbd9ogOFBi6B9x9Io6XtgRYiZ+UrIQ4JN8nHQfJV/cEMvlFqH+O556h0z3B9zi5EIKWJFN0frIbjCap9e95aavRbxNT1SxE9QjVc0jXLyguSrPeoOprmeXvvPfH9+aMA4bfCtaDRRUX283dVwzf1uLaAs5PYKpK/hLMyBmNCtpi+wqHTkcJIjwPFdDyDqUb44MQltZ+z57i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(86362001)(8936002)(26005)(83380400001)(9686003)(186003)(38100700002)(6512007)(6506007)(478600001)(41300700001)(6666004)(6486002)(54906003)(6916009)(316002)(66946007)(7416002)(5660300002)(8676002)(66476007)(4326008)(2906002)(33716001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hI+sUhXj98dpw/YFfXfWKrpQXF3kOBN5wGtABYGg4n4VUIMn4aYV2jQ8HGcZ?=
 =?us-ascii?Q?qskObtFoybUgMMv6N+HRl253oh10uaQMZlFXg6JXy+MapehFCM7qe8W6MiYv?=
 =?us-ascii?Q?6w6bDXybIUcPRSV4T9bVlTQQ2dxMZMW5Lj7x47BHWuVmQTo4rznIV+tTdHvT?=
 =?us-ascii?Q?YYEQLapVYFFVMwf83WxAsGHuowFWRsGkpf7jkdXEH3nLdeU3J+05x9ql3k23?=
 =?us-ascii?Q?q+jbFxMUdsQbuaxF6WFusVm536V5CIW7btAefUmf/dtDNo+1sRzzZTwh3XWc?=
 =?us-ascii?Q?p60uBxKL55dv6EoyWA/QkekFfikYmZAkz7BQxpasvt9nsXP1yN9Bhm38YcKz?=
 =?us-ascii?Q?ZYgCcMDtz+2xruiYiKrspnpp4nSkGD4i3rurGdb4VCdn7Gb2aghRToV3yhNc?=
 =?us-ascii?Q?muj7/vvLk2EZM6l7kgBmxDUAhy5FhwX0azQ1CbthsnhpRjG1SQNfvc9QH+W4?=
 =?us-ascii?Q?dVZb6mkl+uK8sBwlsMv/7KBX3dY1UfN/m/Rnx+dO+uIm+Kj4SgSwVMSRJaO4?=
 =?us-ascii?Q?hfEVn1V2k7YbJzZCswjkbykKTT1V1pxTd9IJSXNS1KRbHfiyBYbhT3oVh/Lz?=
 =?us-ascii?Q?lA6kKLeT59prDAuwJwGMO1QFSuiFddBPGM+B8PRJ8Rp+FVROzTtUMTD12gZb?=
 =?us-ascii?Q?DDOpS24dTF8V6Rd7lcaSurBceM8exHt0pCv1TkI4GlPLKYnZQ377HyNsrwRk?=
 =?us-ascii?Q?m1pfgfwwmEdaStWvgA3hsmMg/tRtEjvl4MmPUu/rGEf+49P46KqRePOeSyRm?=
 =?us-ascii?Q?5EB8/FDgnXTLZcjPohBIiYURiSI9QRwCGwplPm9R/SrMmPdYiwwXA2Z7Dj65?=
 =?us-ascii?Q?/CpcRuU8r24HwhWcaJmBeOaoEyWj3+ES13hXyvcAs3udJaGG7OvzLjhY8Ion?=
 =?us-ascii?Q?lYPJzZQi2D/Bzo5R9ZOUC9qgAXkz5Hh58q0cn44Mfll/Ss+s1PN7qCVD6Jq9?=
 =?us-ascii?Q?DdcVzdp6UwhH+q7PZaf55p3QtxqaJqNZwayTq2YMpJ2whHZFq9IGoLyHS8wt?=
 =?us-ascii?Q?4LqTUe4XpxjL8+MIE8XDKOOo23b82ScRqyyAQf8+dN+vwHR6W80Bbi8d4liB?=
 =?us-ascii?Q?GOiLKJRHO0KPZLkzXhBq5LDbL7pQ1OkoA7hDMZNJrPU3aisIPeS2e7ck5Ztm?=
 =?us-ascii?Q?lRWn47Ddu/oSPH1lvs282FfSPJ02l94/aHCJhPf6M2Yeq7F1a6xvASoKdyZ0?=
 =?us-ascii?Q?ROuDftHQ/rQ7aOBny+OJzdHgWcNjpXgGvMxK7ynbpBUTHEQihWf6VsgtjR/v?=
 =?us-ascii?Q?fvA4WzaHIxOK3SOFkVdJC/HC0mD/8dvdFOVOgQuwiDwhjOoViOmX/aHLlgCr?=
 =?us-ascii?Q?Ix43mOSZhvQPvJ5uUqKH0XP1NVPwDCuZuF4HVBGp9tt9pJO+EnDEIXC+iLfs?=
 =?us-ascii?Q?T/aheHGqeFfcFFRWpIbE2gUf3d7RcUYaum3etYCztJ/qfBX8LJ2Vea9KRD4i?=
 =?us-ascii?Q?my/xIniMgjSQQONq5BGxLSRvxq/2YZR3IiJg9Z4neDsDgrs3XKcAmo6QzTD7?=
 =?us-ascii?Q?fLsARAdrpF5nae/HoWl3iD9jMGkVT/vA8xU181wc4qXtOxtaF+84kBaeZM/y?=
 =?us-ascii?Q?ZBuO9dBf0e49uYOScqbg5uo/9EzEDzhdjsJAW5aI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14040355-3404-4ad5-fefa-08da6d652f89
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 11:10:58.4606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ZxpNaESLCgDSvGtiNH2PzcuOjCzd7wP8PmzKSExhMWxXMAZQQCo+Sj8aGe2cK5slN3a7XsSQ9lYwf2oSpeHVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5337
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 05:20:01PM +0300, Vladimir Oltean wrote:
> On Thu, Jul 21, 2022 at 04:27:52PM +0300, Ido Schimmel wrote:
> > I tried looking information about MAB online, but couldn't find
> > detailed material that answers my questions, so my answers are based
> > on what I believe is logical, which might be wrong.
> 
> I'm kind of in the same situation here.

:(

> 
> > Currently, the bridge will forward packets to a locked entry which
> > effectively means that an unauthorized host can cause the bridge to
> > direct packets to it and sniff them. Yes, the host can't send any
> > packets through the port (while locked) and can't overtake an existing
> > (unlocked) FDB entry, but it still seems like an odd decision. IMO, the
> > situation in mv88e6xxx is even worse because there an unauthorized host
> > can cause packets to a certain DMAC to be blackholed via its zero-DPV
> > entry.
> > 
> > Another (minor?) issue is that locked entries cannot roam between locked
> > ports. Lets say that my user space MAB policy is to authorize MAC X if
> > it appears behind one of the locked ports swp1-swp4. An unauthorized
> > host behind locked port swp5 can generate packets with SMAC X,
> > preventing the true owner of this MAC behind swp1 from ever being
> > authorized.
> 
> In the mv88e6xxx offload implementation, the locked entries eventually
> age out from time to time, practically giving the true owner of the MAC
> address another chance every 5 minutes or so. In the pure software
> implementation of locked FDB entries I'm not quite sure. It wouldn't
> make much sense for the behavior to differ significantly though.

From what I can tell, the same happens in software, but this behavior
does not really make sense to me. It differs from how other learned
entries age/roam and can lead to problems such as the one described
above. It is also not documented anywhere, so I can't tell if it's
intentional or an oversight. We need to have a good reason for such a
behavior other than the fact that it appears to conform to the quirks of
one hardware implementation.

> 
> > It seems like the main purpose of these locked entries is to signal to
> > user space the presence of a certain MAC behind a locked port, but they
> > should not be able to affect packet forwarding in the bridge, unlike
> > regular entries.
> 
> So essentially what you want is for br_handle_frame_finish() to treat
> "dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);" as NULL if
> test_bit(BR_FDB_LOCKED, &dst->flags) is true?

Yes. It's not clear to me why unauthorized hosts should be given the
ability to affect packet forwarding in the bridge through these locked
entries when their primary purpose seems to be notifying user space
about the presence of the MAC. At the very least this should be
explained in the commit message, to indicate that some thought went into
this decision.

> 
> > Regarding a separate knob for MAB, I tend to agree we need it. Otherwise
> > we cannot control which locked ports are able to populate the FDB with
> > locked entries. I don't particularly like the fact that we overload an
> > existing flag ("learning") for that. Any reason not to add an explicit
> > flag ("mab")? At least with the current implementation, locked entries
> > cannot roam between locked ports and cannot be refreshed, which differs
> > from regular learning.
> 
> Well, assuming we model the software bridge closer to mv88e6xxx (where
> locked FDB entries can roam after a certain time), does this change things?
> In the software implementation I think it would make sense for them to
> be able to roam right away (the age-out interval in mv88e6xxx is just a
> compromise between responsiveness to roaming and resistance to DoS).

Exactly. If this is the best that we can do with mv88e6xxx, then so be
it, but other implementations (software/hardware) do not have the same
limitations and I don't see a reason to bend them.

Regarding "learning" vs. "mab" (or something else), the former is a
well-defined flag available since forever. In 5.18 and 5.19 it can also
be enabled together with "locked" and packets from an unauthorized host
(modulo link-local ones) will not populate the FDB. I prefer not to
change an existing behavior.

From usability point of view, I think a new flag would be easier to
explain than explaining that "learning on" behaves like A or B, based on
whether "locked on" is set. The bridge can also be taught to forbid the
new flag from being set when "locked" is not set.

A user space daemon that wants to try 802.1x and fallback to MAB can
enable both flags or enable "mab" after some timer expires.
