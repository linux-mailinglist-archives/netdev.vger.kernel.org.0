Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1612B59B8C8
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 07:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiHVFk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 01:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiHVFk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 01:40:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E8725C62;
        Sun, 21 Aug 2022 22:40:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzQ7MNdCmHLjDwXId0yKnbCeEc9LlfbR9LqZuOergrdDGaZ7rdHs35NjscmZYLjxedE3rl0hL6XO2nvMNIZ5lBFZ46svR/DvyoUYZnDorJKtXuQeRhtM+puzrkTNQdzItSlB6YoWWEg0P05DXo4VyNPHd5bb5Otj/dqdIauldSfycZncqLpaGDr2bOwa7SUjpxjJOnLV6lCNePvICMhLq5vZYhqcexkO/P94oddwal8/F+eypRQm5rNnPLAWnvYhpyzH8Jzi7pZFApPcREhJThH9/hv2doKhJcwTRw6TkAYlGNn2He378yGWOkJEfZMvet/6VY3CKpgx2GlmZYRXsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TAzUnFYPTTXluzRylKeqzYDi4FW5J5JLhIbJmA72FVM=;
 b=Mw2TVllAiNIAB/YkQ0tvqQbIPBTBEzmZgjx1hJungYWKXea31Yqtp/LSkCcD9AGW6irJkas/aFm+7PriU9JDGs1/LQ9Fq9WxWsJYwN25gQVNUTe0HcGuvDku/QW5CWupsOEaxsuZm/UG41J2nnXjpSWHXE0Pc2cab/SDBUneSJV638USn1H+JrIW93PQYgYuKmGoScLYPbUsdCghwxn4gIerQ2iGRm7dD08ozLIit/k65cIe7pLFLBxplj3YuMs1k69Q/i1IaAOTb3nXJ1muoXQrwIJgPI4cx39fx8jzYkiWhz8/nsrxzlMFwWTvirhKjWH/zcZrIfnhfi4ltBMcGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAzUnFYPTTXluzRylKeqzYDi4FW5J5JLhIbJmA72FVM=;
 b=PKXKOeniXiGCQ7nDQR5Q7qIbLbHN//gM4Obk6a4ywa4z2/SvVcP/4RjVI6UofUl/xYkK9BWVmKuDgemgQFwAh7exrj3jBYbC9dusAQPUnXQdAkhOelMCS/4HUrOwJfmQ0HiVgF1HjX18/sB0IaNuqcKmNhy8hT5L7kXfG1rcLir8/Z6L2gRae+Q21QTqEZ2YTbkDGj7sA81nTzG4iGpwSKSbYyy6V0K/VutCzaWAGRjQ5x3blPqajVQSIlRoBQDGWliIaTW5+Lad3proswUFLIRr2bHFcIoBwxCcO78FA47fiq2v5FNKqZ8/j0fgOiKqovTTQH+W7S/az3OTh3OUSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by DM6PR12MB4732.namprd12.prod.outlook.com (2603:10b6:5:32::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Mon, 22 Aug
 2022 05:40:55 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 05:40:55 +0000
Date:   Mon, 22 Aug 2022 08:40:50 +0300
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
Message-ID: <YwMW4iGccDu6jpaZ@shredder>
References: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
 <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
 <YwHZ1J9DZW00aJDU@shredder>
 <ce4266571b2b47ae8d56bd1f790cb82a@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce4266571b2b47ae8d56bd1f790cb82a@kapio-technology.com>
X-ClientProxiedBy: LO2P265CA0087.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::27) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c43f4c38-b4a8-4270-2a87-08da8400e21c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4732:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GrN5iuyrW3T4J4bxizMycALlJpU04r8HQ+hWqL3HwrBjxNLdlKUD4J25P7WtVOObs2BRblMXb4woAz/oVtqk4T0NxOFUaqMGBqAqCtM23z1CCZlif98vUkp5FRetS0ka8lqNNhVNzM1xNaBfsis7oGQDyjTG2yJOxXDeYVPgD1kKakRpLj9KcDnQbGrDbTQr4AFXHnpd2NuRPNakZNX/DZyXaBxfvIyq35whKdS2V5yb0pnDb/nuaTwoQ6m23oLEvftF0G7IhGTxlueBnvRXhuShWiYlzoIxIyf3OrZxrXGq3KtlwA5gMzOj5GLegGQJGMoISm64ktQaae19sqDGKTX0QwZSAnRokf6c7GJHcUtdSZ3qnEsRkrUvrHP/cN3weNB9Ko/4jHGRZNWvleUTM94DTGBikO0MD+YnWGrapk/IqUUuQDfNK29EFWe2DjUa5KY/Q9x8O1B7d7vz7TwlBQKAs2OjPa9UUVgKx4KYHKnrk1WpVC4VXC5HzzkCtE1UpG6AK45r7TwxNVJZngx4hU880fxXFz5IzOOOQPg3khI4VR9P85xMxQbgmMuYNb9TE0R51IgSh8YRpaEN10//Qta7aetX1u2+caQCVMK+esgrdfL0o/dk5YGj6gW++B7jKVq7wrHq94RD/LUTyi89oE7w4eJCI3gEuRb6cxSumvrSYqwPV3qWdzXcMODwwUmso56s/Txvg1gZYQ/iKM45ew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(376002)(366004)(396003)(346002)(39860400002)(33716001)(2906002)(6512007)(7416002)(316002)(4326008)(6486002)(8936002)(54906003)(5660300002)(6916009)(9686003)(478600001)(6666004)(53546011)(26005)(41300700001)(6506007)(186003)(66574015)(38100700002)(86362001)(8676002)(66476007)(66556008)(66946007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a4wRqxX2nrBJieIXMeVo7Begj2P8+RSoRaa2IDyeqLw7qhrerb7SorkST4Ui?=
 =?us-ascii?Q?h8XWY65y4ILA1msTcs0jc5DyHpivD8qme794Zs+T0Dzh/zoDbm+ySpyv7s/N?=
 =?us-ascii?Q?8bjz5csfJGdtt/YzyxbxZtPVl1r8lFZtEN7Ad3EN1/cSjTg/gTR8ue0XNtAv?=
 =?us-ascii?Q?CbxY76i92Q2NM7yXdB9WKZhX5nNVKFIdmCAUHdwCTUwP03fs0yq34BIx1YOf?=
 =?us-ascii?Q?TLwhu/GQIVHcuoLOrSYUjL8elq/k79Sd08aX6cGxEIe+kC6ZB2WrHuGk99BC?=
 =?us-ascii?Q?vajomMw0rsOkewCs4dE8oa1wgWnMj6h/h4Xq4BF3l/2mverX/YBBo/Q/ugee?=
 =?us-ascii?Q?8NPpihZECfiv/0VCaxJEzF+Gpg7c4IKRrByl+l4r/jw4KBAuivz5bUDJlpjR?=
 =?us-ascii?Q?DP4k4VuP4jmtt9+NpyTgw5nvahWw8nSDBtAObDDdxDbR9DJyglmfg3n3srkZ?=
 =?us-ascii?Q?WVybF8t1XsXgRJqMxGEb8D37YKwRqDMOez2ayezSo3pByn/WqVjK3MtPVEQs?=
 =?us-ascii?Q?/uH6lnxMD2gjdgqjvB18hJaaxphz0wTBGqBEk5l9Uhye/8Uq316z35afZLDa?=
 =?us-ascii?Q?TV/8VTKoycg9VOXPRO/7rvlekMactQqDXrxGktZehz3FL0674firdoyEN1uu?=
 =?us-ascii?Q?2I4HxTtctktfHERZjhmpXI00jEOOjokqupGZqjEhduXrJCs1HuBVKB0Qi2mI?=
 =?us-ascii?Q?zYLgviZVq8wBIB3gp3My8ob++Jgx0zH3CCIz++0JPclFF91Teitiq/lpQW0j?=
 =?us-ascii?Q?uf3fCBzXmanC8DjaexHD2ZHcHOVJxdbG/ph+BR/NNDOojbWKSMVKu3Nazo6g?=
 =?us-ascii?Q?W7WWML7IrYP9/LY1+kAcT10MqeW/fNlUO9Ra5Xx6GV/cxKMz3rIX8P4n8+ZX?=
 =?us-ascii?Q?G+lNBpHJzpFKK7fs3V4QpdgoEl+4MY4xImJnsk5hejkv6j8bgr1Nxwgszr1Z?=
 =?us-ascii?Q?wAhV6350lBqMGrzyCEywYSMUkYj+nKNRTiJcyDOix0RTvzGLog6mU8Cnsze7?=
 =?us-ascii?Q?inG47kdoZulBugunMyGrMC4AdkabMfaAYGJznEDgGK8BBIZYjyCOhtK6ipmI?=
 =?us-ascii?Q?SAL/TbBtuF79jpInjaJUOifiOWtoekXFveWGmbujhR0NknD2dJyljFG3h7l2?=
 =?us-ascii?Q?nRWKDKicOkiWJyL2DTvjiCDKFxWnm5lF8i9ETGMCB0hSARlrMdnOHsNLn/tj?=
 =?us-ascii?Q?zDA3nN/Mlph2WoItpCjFd1zgXixv/WMB8G/Eeevibi7RarVrgNCXzVR1azF+?=
 =?us-ascii?Q?IzNyPGWL88+93dvwdSaErwOmX4sT5Q4acWEaRSOx4eWlJAWCLmeJCTvvKqst?=
 =?us-ascii?Q?eQR+pUiMwFHD4JTkKOEMxyLi5QkFVFXGXgKUWNy+qlDQzAGrhISR08jdhVWY?=
 =?us-ascii?Q?Kcxq6OEjdH00e+mfNvX2T7vMwa1Jy3WMaN20hD3PyhFKNoAWZXMw9HWQQ6ST?=
 =?us-ascii?Q?4GoQyq9YrsHPsX1WJ73EfxXZyd1FaGn/ze/Cf7nGvCaDz1oSe14q47IMTCDm?=
 =?us-ascii?Q?/sCmI9xD9Y/pJz1D2LqRpZbCAHARPzZntk0S25rICkXYqc78glo1xpLbyFOT?=
 =?us-ascii?Q?HxMSjxuj9gWwFIWrWrY8AGhqVbMvUGE6TE76T8nH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c43f4c38-b4a8-4270-2a87-08da8400e21c
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 05:40:55.6583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n4D6E1QfniNIP4UhCp+Sxjb+4ccGuHSUnzmG85u7PQrXNYFk6671FIkdvCCZjiCIgH43aTur6/Dv2RPzT/V7ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4732
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 21, 2022 at 03:43:04PM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-21 09:08, Ido Schimmel wrote:
> > On Fri, Aug 19, 2022 at 11:51:11AM +0200, netdev@kapio-technology.com
> > wrote:
> > > On 2022-08-14 16:55, Ido Schimmel wrote:
> > > > On Fri, Aug 12, 2022 at 02:29:48PM +0200, netdev@kapio-technology.com
> > > > wrote:
> > > > > On 2022-08-11 13:28, Ido Schimmel wrote:
> > > > >
> > > > > > > > I'm talking about roaming, not forwarding. Let's say you have a locked
> > > > > > > > entry with MAC X pointing to port Y. Now you get a packet with SMAC X
> > > > > > > > from port Z which is unlocked. Will the FDB entry roam to port Z? I
> > > > > > > > think it should, but at least in current implementation it seems that
> > > > > > > > the "locked" flag will not be reset and having locked entries pointing
> > > > > > > > to an unlocked port looks like a bug.
> > > 
> > > I have made the locked entries sticky in the bridge, so that they
> > > don't move
> > > to other ports.
> > 
> > Please make sure that this design choice is explained in the commit
> > message. To be clear, it cannot be "this is how device X happens to
> > work".
> > 
> 
> The real issue I think is that the locked entry should mask the MAC address
> involved (as the description I gave for zero-DPV entries and actually also
> storm prevention entries ensure), so that there is no forwarding to the
> address on any port, otherwise it will allow one-way traffic to a host that
> is not trusted. Thus flooding of unknown unicast on a locked port should of
> course be disabled ('flood off'), so that there is no way of sending to an
> unauthorized silent host behind the locked port.
> 
> The issue with the locked entry appearing on another SW bridge port from
> where it originated, I think is more of a cosmetic bug, though I could be
> mistaken. But adding the sticky flag to locked entries ensures that they do
> not move to another port.
> 
> This of course does that instant roaming is not possible, but I think that
> the right approach is to use the ageing out of entries to allow the station
> move/roaming.

I personally think that the mv88e6xxx semantics are very weird (e.g., no
roaming, traffic blackhole) and I don't want them to determine how the
feature works in the pure software bridge or other hardware
implementations. On the other hand, I understand your constraints and I
don't want to create a situation where user space is unable to
understand how the data path works from the bridge FDB dump with
mv88e6xxx.

My suggestion is to have mv88e6xxx report the "locked" entry to the
bridge driver with additional flags that describe its behavior in terms
of roaming, ageing and forwarding.

In terms of roaming, since in mv88e6xxx the entry can't roam you should
report the entry with the "sticky" flag. In terms of ageing, since
mv88e6xxx is the one doing the ageing and not the bridge driver, report
the entry with the "extern_learn" flag. In terms of forwarding, in
mv88e6xxx the entry discards all matching packets. We can introduce a
new FDB flag that instructs the entry to silently discard all matching
packets. Like we have with blackhole routes and nexthops.

I believe that the above suggestion allows you to fully describe how
these entries work in mv88e6xxx while keeping the bridge driver in sync
with complete visibility towards user space.

It also frees the pure software implementation from the constraints of
mv88e6xxx, allowing "locked" entries to behave like any other
dynamically learned entries modulo the fact that they cannot "unlock" a
locked port.

Yes, it does mean that user space will get a bit different behavior with
mv88e6xxx compared to a pure software solution, but a) It's only the
corner cases that act a bit differently. As a whole, the feature works
largely the same. b) User space has complete visibility to understand
the behavior of the offloaded data path.

> 
> The case of unwanted traffic to a MAC behind a locked port with a locked
> entry is what I would regard as more worthy of a selftest. The sticky flag I
> know will ensure that the locked entries do not move to other ports, and
> since it is only in the bridge this can be tested (e.g. using 'bridge fdb
> show dev DEV'), I think that the test would be superfluos. What do you think
> of that and my other consideration for a test?

If we go with the above suggestion, then you can have a
mv88e6xxx-specific selftest that tests the corner cases where mv88e6xxx
acts a bit differently from the pure software bridge.

> 
> 
> > > I have now created the flag to enable Mac-Auth/MAB with iproute2:
> > > bridge link set dev DEV macauth on|off
> > 
> > You have 'macauth' here, but 'mab' in the output below. They need to
> > match. I prefer the latter unless you have a good reason to use
> > 'macauth'.
> > 
> > > 
> > > with the example output from 'bridge -d link show dev DEV' when
> > > macauth is
> > > enabled:
> > > 1: ethX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state
> > > forwarding priority 32 cost 19
> > >     hairpin off guard off root_block off fastleave off learning on
> > > flood off
> > > mcast_flood on bcast_flood on mcast_router 1 mcast_to_unicast off
> > > neigh_suppress off vlan_tunnel off isolated off locked mab on
> > > 
> > > The flag itself in the code is called BR_PORT_MACAUTH.
> > > 
> > > >
> > > > Fine by me, but I'm not sure everyone agrees.
> 
> I will change it in iproute2 to:
> bridge link set dev DEV mab on|off

And s/BR_PORT_MACAUTH/BR_PORT_MAB/ ?
