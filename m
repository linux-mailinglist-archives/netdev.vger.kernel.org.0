Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155986DC40B
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 09:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjDJHzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 03:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjDJHzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 03:55:12 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2590B4204
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 00:55:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZ4+aS+ALG9hMwKr8pkpzVviF1N+sZCR2rB2rIU+DSq3POoLWyl+rklRGG85mmlC2kHZqFJEVGpY1VO5ld3CPBIZo15wkZ8lMvqXDu3O4QKeMnGQMljQsTysT9ugtcON4h5rQarhvzM49GGBzozjgRtFKzHn6Ojix8fi1QZr6CwfECljO+lR6/XHUXecKr7gKLUjiOcEZ9XyFSzutB/GYGScuF3t/VZPIPmwr35Ks7r+sQoY0CPUZILjakQsbbCyu6dqSCdSZojbPWIIFpm2spgoRsF76O5pQyTGWycV9SeS0iqb9+eWI+jzK+zA4ljU5hLvBGAqhyXWx1J1X7xuOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCZl+jltwAhJl561FFE3janDxgB6LB+tTsS0V2Fqc1c=;
 b=kmuGmwlVMfIcwkJOvqizBzKzaWe6yM4Z5pz0puGsKwM9fVmJbiUm/daxVy4oLHp5yXq0ksfaecJlWalLquSJrRRTmrHQBBwNm2GHjRZ7kFRzcfkIhT7S1UYzgRIr0QABujEqcztMwJscHzAkbvKiufc8DdAftVt3ZgHpquuKqoSiqYrfH+lHHOoyPViLybIxbtp9hXOu1oAc3kz3DX45vTCgSCF2CFuNO8Aj2FBw91JAF7NiYVysiPUp31SGZ7iS61fd2vqUuasn/2x5lIJ1q92ySTii1YBgR35vHKZt/+BA65BmitYj6EqWC8hRxu7AI5KVk5vE8tDSJKarN3pPeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCZl+jltwAhJl561FFE3janDxgB6LB+tTsS0V2Fqc1c=;
 b=TrSGWaMND+lYcH6LC5d2hiupuAyJdgAZ5neaposY5LhaFGjsg4krInCOthxw5vkMRiWP0Q5igOLdH7QUQMqYwEKjp0Q1nQtLHyDXH4Xx8rw7xLWaacH9+/as2equV8A1FuoxQfSJnjNJ9KxwCyZ79vKDz9PgSUDDxcowm6o/+i/HfHondYwSV8ol50ZrvEvkbatglkURqaDxLKySMbmsV1NmXEPt4NxM5bCZ3JYkkp8BZaI5zb0TOwqt8Ozv7h7T2K7H8B3SdY8mg5rivVWzYOge4j54XWI/VpnY+6oIvml/Ob/cHQiAQh1qtO6Gk8K2VqYb0h6CEgQ3XkqILw2yBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB5717.namprd12.prod.outlook.com (2603:10b6:8:70::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Mon, 10 Apr
 2023 07:55:09 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Mon, 10 Apr 2023
 07:55:09 +0000
Date:   Mon, 10 Apr 2023 10:55:02 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [RFC PATCH net] net: ipv4/ipv6 addrconf: call
 igmp{,6}_group_dropped() while dev is still up
Message-ID: <ZDPA1pv7tqOvKHqe@shredder>
References: <20230406233058.780721-1-vladimir.oltean@nxp.com>
 <febbbc75-2cf5-1cf9-8ed9-6a42ff295ab9@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <febbbc75-2cf5-1cf9-8ed9-6a42ff295ab9@kernel.org>
X-ClientProxiedBy: LO4P123CA0273.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::8) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS7PR12MB5717:EE_
X-MS-Office365-Filtering-Correlation-Id: cfd3a5cd-e110-47df-7efa-08db3998e7d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1hXHFnMq9Tm0erOTIg6s/ukf+JTv90qlPxFu4/fZL7S9imQ68tGeEVU6hRyjvtlpw9DTBDIYAbzRHhM0pWKpzUJ2KGb6k1ybuKxa991JFeiRvpTLsTh2/1RviuVEl1/pExZRodqrAGIjA+E5HF0L9tiH3UJBADCngEpwL8RrWhmJY2dGlztNnBwelz7skJz9sduO4GTQJv5ZGoLUgJNLyMPVHfywbiucjvbJQ4KfStkkLhF5yw722aT+LGF3a3J+7qKNCfkx5ux24W9iYWppmstaeCveqzpyg7RGC3IGgpBN35AXQFXdZOdvfbPdGvtDguPN8toqEyzeNy5NaO5D8Ihd7WRa7rzVGYFWAYGWM3DiPm5RhQdwtYA5OUHxiHbTGfitKZYN1i+16DSSxps2qxAsFhV9efG+xZqJR5lwv6meridpwgP5g2zL6YOZTDx/OVJLVNKbA5bvhs5vuXNLRUCTux41ojLlQiPnPv0PA1U+5/gBEcp3eQjkxsuxEkhak1oVerXlqciBvuFwGc7Q1MQC6hwUulCXLZUVBLfALIWElK/9lyxKb04nP8UvJyr5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199021)(6916009)(54906003)(66556008)(6486002)(66946007)(4326008)(66476007)(316002)(6506007)(6512007)(26005)(83380400001)(38100700002)(186003)(9686003)(5660300002)(41300700001)(33716001)(8936002)(8676002)(478600001)(6666004)(53546011)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e7s+15h6reMhbRl42a1kqauQ7I/hZp8ww3adejmoRG7LCxI6+f43RPRnaIpb?=
 =?us-ascii?Q?0gczw95OFF9q8q9OEGFz5/DPqV0Y+o9rV9HODilQRvm/HiQ5EKXe8EspOMBH?=
 =?us-ascii?Q?3bNqykb822U1HxUMz9rHrJQq8/LSNyuqom7ASA/K6pdx93kM7+D4OV061IP8?=
 =?us-ascii?Q?vuHYEYC/6vINI1zR+1ENK6pzLuIPzFpuRzBIRVZ0Di9bvY3dv8pqkBo6n6Z6?=
 =?us-ascii?Q?mK4zKWndeccfgBiNNva/svYBz2Crz7Yy59xRj7gfMnerRy0EGRyUGhQxySKa?=
 =?us-ascii?Q?c4bnm42sMRg1NW2XSQb2ZoFPzeBHBRgBrqKC4IOyLSlnRu2iBUpbRdTEPaxb?=
 =?us-ascii?Q?jRwa+Rqz5EMGV33+igHbI/WPKZITLL/cilp09biL29C2tqmF+n3Q1H/nKz5X?=
 =?us-ascii?Q?c8qDlwu74D5uRsQW6kwzXWaxiXvRmLWw2MAHxvO2ov5dKzTKxAQ28GNi6Raw?=
 =?us-ascii?Q?rR5j8YaoanYFd6dzZ6ZghgKRMl+qZkgmri9T82H8z/5umrU973qPBbC9pS9e?=
 =?us-ascii?Q?AgyPP0QYzIiXKq1zzbDOvHqywODmjIvOZZD6FoxBRI+P08KL8PjVVACL19Es?=
 =?us-ascii?Q?caHbsNfFPnw2JqZG12auQtxF0MDVddNVv0BYEHu1n5ROJZYqIbpnC/PqkZHW?=
 =?us-ascii?Q?OZlbywL8XY12wQlk8q2ttC2253Ykq7VLoInDAV4Ei+srpEdRfM1pBb3xKtJZ?=
 =?us-ascii?Q?9dSMn4BCB6QQI54l6r2EuEPj+nL7TRoLDKXU6ern7rX9DnBryZN0vIXTi4cX?=
 =?us-ascii?Q?FBPnUmK58OyV+XW3ZC5tWc3c7tco90qpNdt+QuTrdAjrsU21kd1xonVbCVM3?=
 =?us-ascii?Q?JD5fuOTwcpAGByLyUWrK5RBRcsftYBUli07phxg39UwLHVeshXPko478ESAu?=
 =?us-ascii?Q?z8deB0kibIlhoGEg4dRAgWh6VPW1DbuOAoNNbH57ge8P8BRk35WtLo9GQLJ9?=
 =?us-ascii?Q?69tEt8rC2rmfc3TEmMgOi3z0hN6YqkWT1XASe1k1GHhRkdCiWL1GB1yW5C/4?=
 =?us-ascii?Q?Lk8ODj1dnN7IXXy2qmNHZrNkpd8jgH8T4Zi95b/aMjGiiG8ntiKGK+frdOec?=
 =?us-ascii?Q?vGm/+xDuoC8/xzpxMfALG0Z0wKYGcB6mdFKwBDDaYp6bwiVT65XQGGyderD9?=
 =?us-ascii?Q?dq2o19gaaUZryfXo1eCFdAibulekj0pUDv6486F2Cx7BENPyVCB0tAZxounz?=
 =?us-ascii?Q?WBHaPbkNm1TdgiEHRfP/GAT9oAOiHViRS9oNCMGmIfP/I7R6y0P6HdPVUNyf?=
 =?us-ascii?Q?GQ2cUrHftROpukh2Y8PDNFXG4akhUvgij6G4ArB8mUNh6C1czkATWCO7YPi8?=
 =?us-ascii?Q?A1AiLmyyDeVPI5ViFBgZyElU5C0qR2dpyiUWxSahowwJ9md/ObG3QjFJCYpt?=
 =?us-ascii?Q?XotqM+wLFlHvSd49yPOmtjg+cIf39NPN/101eAkvqnXCSB2TVqhzYC1cDAO/?=
 =?us-ascii?Q?Kbj9KUp2idzO11s+qQatq/4FqKHUNXIklF47rGL4o9tA7g3seCFxl4x2UYOu?=
 =?us-ascii?Q?5Yc4ILqNsSVac/O3t24giEo2LfdBJVqFPpjsWoMiZSeEeQGXrTPkZgRryHGZ?=
 =?us-ascii?Q?iSDof7bjGhkxZkppzuoieYA62kHad1I92kIHi++4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd3a5cd-e110-47df-7efa-08db3998e7d0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 07:55:09.1424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fdto7ReSD3wi0+2QCS2BS6TlmDN7vkcDy7C+3gaNzZudNHHmgmnzrhMGB0SWpOrRwYv61cs77jcObWOtzNEohA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5717
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 09, 2023 at 08:08:01PM -0600, David Ahern wrote:
> [ cc Ido in case such a change has implications to mlxsw ]

Thanks

> 
> On 4/6/23 5:30 PM, Vladimir Oltean wrote:
> > ipv4 devinet calls ip_mc_down(), and ipv6 calls addrconf_ifdown(), and
> > both of these eventually result in calls to dev_mc_del(), either through
> > igmp_group_dropped() or igmp6_group_dropped().
> > 
> > The problem is that dev_mc_del() does call __dev_set_rx_mode(), but this
> > will not propagate all the way to the ndo_set_rx_mode() of the device,
> > because of this check:
> > 
> > 	/* dev_open will call this function so the list will stay sane. */
> > 	if (!(dev->flags&IFF_UP))
> > 		return;
> > 
> > and the NETDEV_DOWN notifier is emitted while the interface is already
> > down. OTOH we have NETDEV_GOING_DOWN which is emitted a bit earlier -
> > see:
> > 
> > dev_close_many()
> > -> __dev_close_many()
> >    -> call_netdevice_notifiers(NETDEV_GOING_DOWN, dev);
> >    -> dev->flags &= ~IFF_UP;
> > -> call_netdevice_notifiers(NETDEV_DOWN, dev);
> > 
> > Normally this oversight is easy to miss, because the addresses aren't
> > lost, just not synced to the device until the next up event.
> > 
> > DSA does some processing in its dsa_slave_set_rx_mode(), and assumes
> > that all addresses that were synced are also unsynced by the time the
> > device is unregistered. Due to that assumption not being satisfied,
> > the WARN_ON(!list_empty(&dp->mdbs)); from dsa_switch_release_ports()
> > triggers, and we leak memory corresponding to the multicast addresses
> > that were never synced.
> > 
> > Minimal reproducer:
> > ip link set swp0 up
> > ip link set swp0 down
> > echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind
> > 
> > The proposal is to respond to that slightly earlier notifier with the
> > IGMP address deletion, so that the ndo_set_rx_mode() of the device does
> > actually get called. I am not familiar with the details of these layers,
> > but it appeared to me that NETDEV_DOWN needed to be replaced everywhere
> > with NETDEV_GOING_DOWN, so I blindly did that and it worked.

I think there is a confusion here between the netdev notifier and
inetaddr notifiers. They all use "NETDEV_DOWN", but in the inetaddr
notifiers it means that an address is being deleted. Changing the event
to "NETDEV_GOING_DOWN" is going to break a lot of users since none of
the inetaddr listeners respond to "NETDEV_GOING_DOWN".

IOW, I believe you only need this change for IPv4 (and similarly for
IPv6):

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 5deac0517ef7..679c9819f25b 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1588,7 +1588,7 @@ static int inetdev_event(struct notifier_block *this, unsigned long event,
 		/* Send gratuitous ARP to notify of link change */
 		inetdev_send_gratuitous_arp(dev, in_dev);
 		break;
-	case NETDEV_DOWN:
+	case NETDEV_GOING_DOWN:
 		ip_mc_down(in_dev);
 		break;
 	case NETDEV_PRE_TYPE_CHANGE:
