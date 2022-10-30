Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E50E612A9E
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 13:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiJ3MsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 08:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3MsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 08:48:20 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B50A469
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 05:48:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TP02t9pIvGi6DYS0CZMMyhzB9GE9AxK/tRNrxuL+UW0rxTHTCmwT+zI8ClzIDpg4mAEkFbd4Ic91OT2VsvBLY088Fu/MbxokrWXXO6W4z11AWEV23r3EyK6J63+tdgWLjq+PLrXoMtnKWVpGEYgwMhQuYb1BpkURohBqkd5ASVJgQ0+dkculMpVZgNUan8DupKZJXmxHmVrS7lRpjRls4C2CcAfj2l8pMf/dD6Tx9aiRwWcrugFNdFXOsxuFAQH8ZCJS/xS4Gv2wIbidxv1qPdYKntnKGz4zJColptwlAqkoBohwlU76TAFhAbUx8J5LwsZWPp7GSXlPwi65L++jhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UtO4U7/EbBgufiT2h61+/lk5j0vYNdzAggxl6HGJzPs=;
 b=EXCPaIGcrdIVJ1QPctv5Su29zWOoCD9qWD3bnqLGhH5OaulhFjo6li3oBfm79qB0Cyp4epHbpJAI7MlJ+i2QsSowUtF7qapzXhjez/nS+EF+xtQlmchY/pTVvmSx+YTMFQZOjt9py+/EqxAWWXp5YoiPUmMA15DyDskZZFwXXSDngRayHhpyoOZK0sUa96N2CAISBTEIybpJUUCUUFNFqH0aZWy0V6+VvZ8abEAQxeWj8r8Nta7wrCTNJFeUmEQY62txFTmGWfhfJu3lGu/m1ZKJHux4YyG1ncQo+q5qBKeQSwW69GSMO3v1BBqnRTKo8zHfON72k7GOOjXIsjFjfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UtO4U7/EbBgufiT2h61+/lk5j0vYNdzAggxl6HGJzPs=;
 b=M3JQJcW/T0YDTyovzhBg9IprY/yAuBzk39jyRdYsmU7LSVtSwBrn5vRfQGtnHMXxRM2WbRsQR219swpZms/7zIPqwxPc5CotC8sYCXpU0CNv1xDOYs/dRvweDm39NkSpSnz848pNKvHVmnE/iVJLRmajjj5spRs31YYyw18SllhztkldtRntHZhAZWNJKrAxRwLH9nX61PEGoM6LOD3COt97e1sgHucFtQW90pcsc+m4SBMUSaYx+4CgNUbhTN0L7ZfbEjC5AkdavmL2jqtlxdQJwAOTCihtUMCy+vUP8fJhHgENm3WF/VwaRZ4+vRJyKj4F92qZLg+fWN4FWLkPXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY8PR12MB7315.namprd12.prod.outlook.com (2603:10b6:930:51::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Sun, 30 Oct
 2022 12:48:15 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Sun, 30 Oct 2022
 12:48:15 +0000
Date:   Sun, 30 Oct 2022 14:48:10 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [RFC PATCH net-next 01/16] bridge: Add MAC Authentication Bypass
 (MAB) support
Message-ID: <Y15yitWoBeDVi43l@shredder>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-2-idosch@nvidia.com>
 <20221027225832.2yg4ljivjymuj353@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027225832.2yg4ljivjymuj353@skbuf>
X-ClientProxiedBy: LO4P123CA0322.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY8PR12MB7315:EE_
X-MS-Office365-Filtering-Correlation-Id: bc90bbb2-f49e-4bbb-d85f-08daba75033b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b0VuMIfU+Ed68+Cs8Vmtvaxg4zdEVDhZ4zNFZtv702wbQJtIWiz2rP4wo+97TvxV9m5cF9CY7wbnmkS7Sq3BKOnpVd0i/lUSI+tLlpr7uy5UJkVn0lTIZrFZn4CqMZeu11vD0gxau3NvEYsXeMyQBoOFXnJffjruEUGkxV6W8v7ut0yLVelhTokAUQ+y/kSdqmcPx5cijKQ4b6RdnySeTkdnKklqJNoLtj/0ycd0LW/hfBoB4pgorEDnm9Y6vlJUryvAlJPAJ27cbaGcFpw/YxWRMUEvUWBK9+onfRnJ/PAuUYX83TT9naItyt1VZ8P+D52mQvuwGnBWt0HiAbopkbdt46/BXxWdpzd4LhOWi/iOZtyFb5rQkIRofvcuOzk4GpOFBnSelqjh/z5zV74hibqRarMvOF8Iymv4/rcy4Ab+xEUjCqJ73OwBhlbGtfPUWGnIEXjhxILnAMX+JYNkT6AyNXYCO2h9cA+ijdwZ45qqD5ERDvd+GZf2ym7CCU652Yq511lciNvzIf20A7JZ9ooP8vSkhGOGak/kw5KDzuDnhv4Ctuyx0GJpgvqGqEgr1LWo/CE1HG8cEcIZKFbvy5ReY5TKC8O2u3VU6w+0WuqlCaGDNjF3snuYucjwbMA8u3V6vt72Svy4llRVThR+LxkGwcAL3620/J5RsIEYIIrp5eIyvRFfl+6ZVq8DF/AMHnq/bCW1jb3LCa3oeLC9dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(346002)(396003)(39860400002)(136003)(376002)(451199015)(41300700001)(6506007)(6666004)(38100700002)(107886003)(478600001)(8936002)(6486002)(9686003)(26005)(6512007)(316002)(6916009)(54906003)(66556008)(66946007)(4326008)(8676002)(66476007)(33716001)(83380400001)(2906002)(7416002)(5660300002)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ky50w0HtlY0/ca7bDACgtsiPsLEcfreZyNWX8PTYSbzw8cZisdgODCnIKjLB?=
 =?us-ascii?Q?IdFvclXcQhUbB4AKpZK/ENWjBQquxfoPrVIky6OSorY8aC8ZB+WuI3PvB1kh?=
 =?us-ascii?Q?n/HW9V9/Pk5Cj5f5BrN9wci4SSDdoMj5yIhTqJBBVoUdH+OPXsAVYxSOKkRf?=
 =?us-ascii?Q?54KG39dA8HnNsJUEvlzw87m4pTKMlr32uB2KXAMRKQnUW2Dnr01tjGPtPs1h?=
 =?us-ascii?Q?Pi4394QslpC9kZVfKvdq5GEUtxSJhtT/rtQ5LxLb+7GJIno7rGidAUnM8hGI?=
 =?us-ascii?Q?eArmWedI3KDGnJwZX8mRm5rjeJZQS16q+o8VEP1+TgUdlIm6Kj/94wPJOhqa?=
 =?us-ascii?Q?5K/TWoxtl/T96QPU5zlRmTVEVQtQh+nrfHr3EEtNi2PDrvyvwrhI6VuVnuaz?=
 =?us-ascii?Q?rX3EHBw9U8z59rRbKa2wr5JVm0YsWF++Yg1x0VryB5XSz8OF4ejA0UbzJTNL?=
 =?us-ascii?Q?htQOTrXnvF0VdbBKwD+YhlXb+iw6dQ0dVY+CugGDKnzg4MeyEsHkUH83vgQH?=
 =?us-ascii?Q?0erVzIp6FUQsxs+FOAbQvEYSO8AFOW5pNgLGTjBEaapsKhT9wbjOTB1XRuA+?=
 =?us-ascii?Q?Y6Vtq0O4CMAlo8IjebC+aPDqGsPmEm4SHb9EKrbJU1Drcka2thqJKuxFeqyo?=
 =?us-ascii?Q?XGLEGVyaqWdfj5xNc4yAfbmhrEA7Apo0+M0fyduFT18SZ/JmZHaV767LkC/A?=
 =?us-ascii?Q?NcPZ3AZUAP17QvTeWSqbjqbRMxpSSjSusGNHrtvyxMWDnrqYmJTnwilGEHDS?=
 =?us-ascii?Q?2rp0bdnCp+nfL9s/i21BsqMpb1dgx2MoQ7x3wjzGS1bTR460rvVZENicXOL6?=
 =?us-ascii?Q?DaxTcE/QidXhdFnF4g53RAV4HTs8MtFnrkhunhnw560E77shfIKLutpA/VKw?=
 =?us-ascii?Q?7vgB5KQmcTK5XvC+GrTbzWJncIysNAQJGVUgJLyAX9PqLMsl48SY16K6Kr/X?=
 =?us-ascii?Q?RuNXTl4FyYoZBFwjJxyW/g+4yD1+ciWiD77YERyDsMgGNIylMtAFQEf1xy6j?=
 =?us-ascii?Q?tVjstf7aQFx7oH367vOxkHtK7mwoY7usPijC5kFSCV3haLZp5zADr75sWv+Y?=
 =?us-ascii?Q?83rb1PtZaQI9XT+Xk1JGnJwJQDdIs9gfmVaYnxgh3019s0uke6ISsf1ERn81?=
 =?us-ascii?Q?TGiWfJHIR/oeXfQt3TRluzMeyVEOhxVnGAEKFFfFFUyylTT+aZNa/bx5J5D+?=
 =?us-ascii?Q?CcHdvQcz65HqOrGLLQQuxU5pBA+gyZpeu8x+hI9B2yagRXfA3zes0OUVi55V?=
 =?us-ascii?Q?67odhpWBzsyjKuJvNgXm5zqf4objdPpYlaAl3sbulUwN1FPRCAtYUli7ghGM?=
 =?us-ascii?Q?K14wWQ2vbHGfSZC44vPRia8Wtlz2lcZ7dH4RWmk6N3pgKJboRmHWuA7iA0VZ?=
 =?us-ascii?Q?LY/np8Tm/Dsa+OSEtEESzX2vKUVtg4NlRl7HDpzCeXAjyIaUqexaTu94fWWk?=
 =?us-ascii?Q?HMrukq72DWp9nV/x8bnD+6wuHNnCTqTcjpvjdh5pof0oevAZf/VO8nHRIZAr?=
 =?us-ascii?Q?jbqLQdMP8e02MHG6Z9AZLmmW1chnIwaC9bSuA3zgGhmcXldw3ODsnH63boV6?=
 =?us-ascii?Q?2uSSdXbXkWBptNdTqFk4r92HH4Dj/PSdAc/FM1Xl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc90bbb2-f49e-4bbb-d85f-08daba75033b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 12:48:15.7039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odh2A4X09/cZIMHMN0N+ylx2g/+vTY9/4YU8tRS4TfZ9ep571Cy51lNWSSDGZnHfYaDWRb02Fz3G5sdLoMv7pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7315
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 10:58:32PM +0000, Vladimir Oltean wrote:
> Hi Ido,
> 
> Thanks for the commit message. It is very good.
> 
> On Tue, Oct 25, 2022 at 01:00:09PM +0300, Ido Schimmel wrote:
> > From: "Hans J. Schultz" <netdev@kapio-technology.com>
> > 
> > Hosts that support 802.1X authentication are able to authenticate
> > themselves by exchanging EAPOL frames with an authenticator (Ethernet
> > bridge, in this case) and an authentication server. Access to the
> > network is only granted by the authenticator to successfully
> > authenticated hosts.
> > 
> > The above is implemented in the bridge using the "locked" bridge port
> > option. When enabled, link-local frames (e.g., EAPOL) can be locally
> > received by the bridge, but all other frames are dropped unless the host
> > is authenticated. That is, unless the user space control plane installed
> > an FDB entry according to which the source address of the frame is
> > located behind the locked ingress port. The entry can be dynamic, in
> > which case learning needs to be enabled so that the entry will be
> > refreshed by incoming traffic.
> > 
> > There are deployments in which not all the devices connected to the
> > authenticator (the bridge) support 802.1X. Such devices can include
> > printers and cameras. One option to support such deployments is to
> > unlock the bridge ports connecting these devices, but a slightly more
> > secure option is to use MAB. When MAB is enabled, the MAC address of the
> > connected device is used as the user name and password for the
> > authentication.
> > 
> > For MAB to work, the user space control plane needs to be notified about
> > MAC addresses that are trying to gain access so that they will be
> > compared against an allow list. This can be implemented via the regular
> > learning process with the following differences:
> > 
> > 1. Learned FDB entries are installed with a new "locked" flag indicating
> >    that the entry cannot be used to authenticate the device. The flag
> >    cannot be set by user space, but user space can clear the flag by
> >    replacing the entry, thereby authenticating the device.
> > 
> > 2. FDB entries cannot roam to locked ports to prevent unauthenticated
> >    devices from disrupting traffic destined to already authenticated
> >    devices.
> 
> The behavior described in (2) has nothing to do with locked FDB entries
> or MAB (what is described in this paragraph), it applies to all of them,
> no? The code was already there:
> 
> 	if (p->flags & BR_PORT_LOCKED)
> 		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
> 		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
> 			goto drop;
> 
> I think you mean to say: the above already holds true, but the relevant
> implication here is that locked FDB entries will not be created if the
> MAC address is present in the FDB on any other port?

Yes, will reword to make this clearer.

> 
> I think some part of this comment should also go to the convoluted
> BR_PORT_LOCKED block from br_handle_frame_finish()?

Sure, will add a comment.

> 
> I was going to ask if we should bother to add code to prohibit packets
> from being forwarded to an FDB entry that was learned as LOCKED, since
> that FDB entry is more of a "ghost" and not something fully committed?
> 
> But with the "never roam to locked port" policy, I don't think there is
> any practical risk that the extra code would mitigate. Assume that a
> "snooper" wants to get the traffic destined for a MAC DA X, so it creates
> a LOCKED FDB entry. It has to time itself just right, 5 minutes after
> the station it wants to intercept has gone silent (or before the station
> said anything). Anyone thinking it's talking to X now talks to the snooper.
> But this attack vector is bounded in time. As long as X says anything,
> the LOCKED FDB entry moves towards X, and the LOCKED flag gets cleared.

I think it is best if we keep the semantic of the "locked" flag as the
"entry cannot be used to authenticate the device" and let the MAB user
space daemon worry about the rest. For example, if a MAC address that is
not in the allow list appears behind a locked port, user space can
decide to shutdown the port or install a flower filter that drops
packets destined to this MAC DA.

> 
> > 
> > Enable this behavior using a new bridge port option called "mab". It can
> > only be enabled on a bridge port that is both locked and has learning
> > enabled. A new option is added because there are pure 802.1X deployments
> > that are not interested in notifications about "locked" FDB entries.
> > 
> > Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> > ---
> > 
> > Notes:
> >     Changes made by me:
> >     
> >      * Reword commit message.
> >      * Reword comment regarding 'NTF_EXT_LOCKED'.
> >      * Use extack in br_fdb_add().
> >      * Forbid MAB when learning is disabled.
> 
> Forbidding MAB when learning is disabled makes sense to me, since it
> means accepting that MAB is a form of learning (as the implementation
> also shows; all other callers of br_fdb_update() are guarded by a
> port learning check). I believe this will also make life easier with
> offloading drivers. Thanks.
> 
> >  include/linux/if_bridge.h      |  1 +
> >  include/uapi/linux/if_link.h   |  1 +
> >  include/uapi/linux/neighbour.h |  8 +++++++-
> >  net/bridge/br_fdb.c            | 24 ++++++++++++++++++++++++
> >  net/bridge/br_input.c          | 15 +++++++++++++--
> >  net/bridge/br_netlink.c        | 13 ++++++++++++-
> >  net/bridge/br_private.h        |  3 ++-
> >  net/core/rtnetlink.c           |  5 +++++
> >  8 files changed, 65 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> > index d62ef428e3aa..1668ac4d7adc 100644
> > --- a/include/linux/if_bridge.h
> > +++ b/include/linux/if_bridge.h
> > @@ -59,6 +59,7 @@ struct br_ip_list {
> >  #define BR_MRP_LOST_IN_CONT	BIT(19)
> >  #define BR_TX_FWD_OFFLOAD	BIT(20)
> >  #define BR_PORT_LOCKED		BIT(21)
> > +#define BR_PORT_MAB		BIT(22)
> 
> Question about unsetting BR_PORT_MAB using IFLA_BRPORT_MAB: should this
> operation flush BR_FDB_LOCKED entries on the port?

Good point. Will try to do that using br_fdb_flush() and add a test
case.

> 
> > diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> > index 68b3e850bcb9..068fced7693c 100644
> > --- a/net/bridge/br_input.c
> > +++ b/net/bridge/br_input.c
> > @@ -109,9 +109,20 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
> >  		struct net_bridge_fdb_entry *fdb_src =
> >  			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
> >  
> > -		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
> > -		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
> > +		if (!fdb_src) {
> > +			unsigned long flags = 0;
> > +
> > +			if (p->flags & BR_PORT_MAB) {
> > +				__set_bit(BR_FDB_LOCKED, &flags);
> > +				br_fdb_update(br, p, eth_hdr(skb)->h_source,
> > +					      vid, flags);
> > +			}
> >  			goto drop;
> > +		} else if (READ_ONCE(fdb_src->dst) != p ||
> > +			   test_bit(BR_FDB_LOCAL, &fdb_src->flags) ||
> > +			   test_bit(BR_FDB_LOCKED, &fdb_src->flags)) {
> 
> Minor nitpick: shouldn't br_fdb_update() also be called when the packet
> matched on a BR_FDB_LOCKED entry on port p, so as to refresh it, if the
> station is persistent? Currently I believe the FDB entry will expire
> within 5 minutes of the first packet, regardless of subsequent traffic.

Makes sense. Will add.

Thanks!

> 
> > +			goto drop;
> > +		}
> >  	}
> >  
> >  	nbp_switchdev_frame_mark(p, skb);
