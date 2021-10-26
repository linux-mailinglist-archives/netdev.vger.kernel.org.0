Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D8043B23F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbhJZMWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:22:38 -0400
Received: from mail-bn7nam10on2040.outbound.protection.outlook.com ([40.107.92.40]:33632
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235906AbhJZMWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:22:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCRkQ5u1xibrULELJETgDd/EahLO+GpPXYPj1byjUij0bJ7XHDFGJa93BQvRPxegMwrMnl641tWqAWx6HYqFOawUfrpxBVe6s52qwR3zQqIR4utIWS+cO9bUphKjMhaRfB3T89MrJid9s7swG4x7uZ9uTUJYVzx543puZBHXkCxHrqYLd2DUIRCONn43bhYH1yxfhMggMGh1VLa3V0kq/iwS0CdGemsuf4tBRLijrg9YE95Aa4pnV3H1Hm0EDOJpwUT2+FlmPhaqbo64B5HPQxdZdjbdD4QkPoqOJmSgeH/ZaCfOCK4mKMgFPrBwhyKowgztcW+1VHD2RmcLmFYtvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUrYagAwKOEvxBkncTn6+qDo22WgFkr3jSZ+2wdodas=;
 b=Qj0n65Ah8dpomj0gg4Wkiezr2ELMInV3G4jP7zuMziLD+hegOgwTJIn0gblQiGFNZlxQxIthT2SjCeAIyLMu2fnVh5vJZUT9tLPZrsekYEJSASOqEj3mlSGw1ANNn4F33MtjCn8AZMlILWpX9uPf+RcXltuUz6VXEaHoe8oSDwbtHfCMIwNCkR7GTxT4+MnHxKkV/ZRsj+sr4DyqhjtWz5TxIwFn3FizLbMBwW4BNv4ENRXUI7Tp8LPZjO6sfLTZAfqHeyFgFfSitZM2XGJvpmZVW9MHUWLiKyMRyjCtnOmfkv+tUD81ho3wp5voiZ5iQ0o/lk3TrRf4O01K8AlSOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUrYagAwKOEvxBkncTn6+qDo22WgFkr3jSZ+2wdodas=;
 b=d3RGTMD7uWagQJiwfuTFsKGm+4NX+xmYGnKjJezsC4NIscMIJt7lR3HVDpJzNjO98n9Ew1bZb54BcVa+0dLvPI+0LTFh0tZHyachAQB4+Z7m7LOhABE2jusc512tKt1wr9CkR2m013Nvln4EyevjiO5RQMm5cO0/aPNmFq/MtgN2UhCGLYstimOkx7LNeDSiv6LsvL/k1q9YV/aVRDxhII8LTmmU/dt+2sLgW+5EOFjjMdsBk2JIgnP+pzZvdS2lVwybklnh4tiHbY1LLpDvxTlLQTeSWQGxDG/AQYDpIL4wYSrzCagcw+XXnnLqrSBAzZXG34xmm58S8Ljty+ediw==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 26 Oct
 2021 12:20:11 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 12:20:11 +0000
Message-ID: <1d9c3666-4b29-17e6-1b65-8c64c5eed726@nvidia.com>
Date:   Tue, 26 Oct 2021 15:20:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH net-next 00/15] Synchronous feedback on FDB add/del
 from switchdev to the bridge
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
 <531e75e8-d5d1-407b-d665-aec2a66bf432@nvidia.com>
 <20211026112525.glv7n2fk27sjqubj@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211026112525.glv7n2fk27sjqubj@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::21) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 12:20:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b0f7856-7d6a-49c7-afb8-08d9987af516
X-MS-TrafficTypeDiagnostic: DM8PR12MB5400:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5400FC61E75F5EAD1E74F5A8DF849@DM8PR12MB5400.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a0ZFdrQZegO1Sx1foFHaujUJTHsOq3nL+JToPGbQEDfKd7XHmBEnOA5IHZ+E5uv4kG3MMQ2zeedmJwoVaPxrhIgls3yE5lfps3mDBwl5qaEQrvSV2afe9jJZ1f1O8alayCObnw0GXXRJvZlw3ktiKN7SJxxbworHUPMtHulh/9RJsENYw0iRdnTU1qZ8sk9KKcKtCFyKTrrAWcwO9zNgzUtavrrduJgbGf+vD60mgnyqom8l1d49M+/DssrFnCZc7pZ4Ho4cFtUakO/nkOCyBLeTM7cQC/rz/B1zxWPgpyclIi891jPuhw28p62BLDDr4kvD1gGq0aWnom/r9RO1OK/8NJp38pDbdZB6vwHHa6UBSakS9knfhuijlfq9zT0rDLWzj7C6Y0LhGO8DQoIQAG7E8puWy9CKw6QJ8SH4hG3Ed4BpqLMiQOhRFaQSnqN9VUkfW8FRPkfOhhlZii+NFd+MDaOYOjgvyn2XONqqHFee+1+c6aRNR3JGy7ldtDyDOaSPMi/ttZc9QIlxLR3JTH67M9IxjTEOgsJjg93H8EzAfRARhdmzDe27AXmBKF7awH8dn4Y1zO4F+0UhKbp/HrO8CMu+m50Cttln8bpqsSPbDg5l3pkcIXXNtHbVB3k+skOi200Pd6GBcRvGzz6ylyFOSqrgzXAw95QYMtVO5FcOJ4XKwg5tRmjEXIpdSQekQ5p+T+MCLMc57y0SAZqKN4YTJDRkPkKnkpgzCb1Q80Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(31696002)(83380400001)(53546011)(2906002)(508600001)(4326008)(6486002)(8936002)(5660300002)(8676002)(186003)(54906003)(66946007)(66476007)(66556008)(107886003)(16576012)(31686004)(316002)(38100700002)(36756003)(86362001)(6666004)(2616005)(956004)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OTlBZ0NQZy9sOFRDVWw4N1E0c2NBcHI3ZGdYYU5YWjIyVnVTSEV6bWtaQUwv?=
 =?utf-8?B?dDFwKzhqaEcwazhxY2dQMkpFbk1sdnZQZ0gyWmNXZU5YL3YzRHN1S2UxdWpO?=
 =?utf-8?B?aXR0YXlMSlFyL2xiOWVDdnpTY1ZEUkFUQk5TL1VQSzg0dE0vY3FvZk13ZWt5?=
 =?utf-8?B?VC9wc0ZXYnVRWWlBTzJNVmFHWk41WjFLeUpQR3ZGdjdOMDhzTm8zaUtmWEVl?=
 =?utf-8?B?aHpOeTQ2VzhyRDN1dGl6bnNWZ0hPQjNHbzl6elZzSkFpTWFXK3E0bnY4SjVp?=
 =?utf-8?B?d1hFYUxNNmdUMW9hV2NWMGJ5ZmN0Rm9nMFI1VENGYmt6cG1CMnhLb0hHVXBo?=
 =?utf-8?B?NzQxWVk3dXRoRVVzUm1uUHFWTFlGVmRjNFNJYWxWYzdleW5pQ3M5djd4U1hv?=
 =?utf-8?B?bEdIU1dZbW16eUVCRjVRQTJiRUc3THdHMFdPVFgvNGR6MEl1bUFsekoyMlFF?=
 =?utf-8?B?TEoxUERsT21yS2J3QmdVWFBtNVJmMHZ1NTlsLzFhSU9BTHpXSmJPU0NGYm1l?=
 =?utf-8?B?ZjkyenVoMHRicFhUTzZzdk9iaFVRUmN6Z0VETDRReWE2d3FtU1NWSFZQYldS?=
 =?utf-8?B?ckFMSjJPRWdrcEI2d2tCbFBsSzVSelFKMDZkQzVzdHAxSGU3QnVMN3grRUJ1?=
 =?utf-8?B?MWlpU0RZaDBRQXZ4eUk3bFdSa0RCUVJXUVBGQlZ2SXJraDh1SHFGKzdaM0Iv?=
 =?utf-8?B?cFNTNjlvSklubnpVR0I0SWxXM1VaWDVYOENGQ0RMemlKeGpjdnhrTmc3djJ0?=
 =?utf-8?B?OW5zZVVmZlFITEJyaDhPNi9OUE9SNWhqcC9UZ3lJdVQrcjJjL212WWxCOWND?=
 =?utf-8?B?SWV5YmlMUUlOTnVkc2tXMWE1Q2hJVnZrY1paeGtLVlNLTVFEdkhnSHNTUjVq?=
 =?utf-8?B?RFZnMkJWV1dnb0VkR2x2bkFhTGFVekZJVjBHbU82R3dRdnZOeUlwKzlZTjR2?=
 =?utf-8?B?aERkdHZCb2FhN2tITjlIS1B6d2VEdHlJeUd0WU9rYTVFRGNlbzZGTkNIeExN?=
 =?utf-8?B?MWRqM05VeWVSVGNwT2ZzZGZ1WHI3NS9pK1psdU1aeWRLK25xL0FmRDJZcW9m?=
 =?utf-8?B?YU9jQklvOG9LUDU4Y2lqazFIU3dKdXBpVmFURmcxWk8vV2tOYmJieUhRc29X?=
 =?utf-8?B?Vld2NHBZSmV3UlEwL2c2V1d5YkhhMW4xU2Y4SnZqOG1IZDBDeldtMTNMTVV5?=
 =?utf-8?B?bkFnTmw1eWQ2UHpHOSt2QmFpVlBIREwzNE1jOFN5Rkx4Ti9ITU9laEJEV29l?=
 =?utf-8?B?Z0dQK243OFBoMGhuZEhsQ1RyTENISFhtQmFtb3pITEM2U2JXaTFibU42Rnh1?=
 =?utf-8?B?VURSVzhuN0J1UUxzRlFmNzYyTWtTaVh5elJpalFDNWMyR2UzN0lPZWVLZ0hz?=
 =?utf-8?B?VVBOOFgzTkhCdzNyUmMyU2Fhb1Zrdm9TS2lHK2Z5ZFhYUmU5TnM2OEZHZ1c1?=
 =?utf-8?B?Vm9nT1VNRTY0TFFPOE54N0hqWXRDTE9HcXRvSUdTbE5jYVBocnpxN0dieEh5?=
 =?utf-8?B?Z1YrNTh6Z0ExL1Zjd1FOY3FraHVsRUlIdWl0UHcrWllZTVJBS3N2ZzRPTjc3?=
 =?utf-8?B?OEs4UGJCbXZBTytIUkNKNExINkRXSU94ODQ2endkMFlYSTBQdUhSZjdNNzNB?=
 =?utf-8?B?WG5JWkRJZGU3eE5sLy9QdVdBNURySkJsZTVvVjBKV2lxWGx3c1F3OUp3Si9N?=
 =?utf-8?B?TkhyN2tpSEFObm1KSnlYa2ZUcXBraEFSdlJQZnZ5Rkk3NDBWT1c2MmVsaGtM?=
 =?utf-8?B?b3hteXliTmo0VHNSMU5ERlZzUnBrdmNYcHVlVU8yTEVFUGJGN3JCVFN5cDFi?=
 =?utf-8?B?VEgyUFBYZ0VPM3RVS29GVXRGMFJqd1FzQVF0VFErTmRmVFZ5VG4vekFVNndz?=
 =?utf-8?B?Z0lKbWRMSFJMYmtaY0s3UFc0VlUwRlhoR3RYNUp4Wk5sYXp3SWRJRGtMK3Rt?=
 =?utf-8?B?VG5vYU9wNGM1MGNMR25YbEk2bTlmWmVIUFJNQmdBQ2JqRlh6aE0rb1ZCY29N?=
 =?utf-8?B?S1NxWUNDcGxsampZTFZMS0phc1N2d004SWJsNm44b3NWWlVpVE9VNUhpZ0NK?=
 =?utf-8?B?VnVobk9aSkVLaG11bStka1VRSWZnUnBpZFpvZFMySS9ja1RXSzJmQUpqcTJw?=
 =?utf-8?B?bXhRS2RKa2hUeEo0dG9malJ0OUxlaDljVzllK1RSS0xoOUhJMkhGakhyNmtT?=
 =?utf-8?Q?+/ubj62Vo1xxda6yvfRozDY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0f7856-7d6a-49c7-afb8-08d9987af516
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 12:20:11.7481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2QwHGI7yeeA43kElczRY1QpO0gIcgcCIV+FUwodeRzGVHANCMwdVEdOvkzxIl24b8o5E4COxwXzuOPnzG7vbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5400
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2021 14:25, Vladimir Oltean wrote:
> On Tue, Oct 26, 2021 at 01:40:15PM +0300, Nikolay Aleksandrov wrote:
>> Hi,
>> Interesting way to work around the asynchronous notifiers. :) I went over
>> the patch-set and given that we'll have to support and maintain this fragile
>> solution (e.g. playing with locking, possible races with fdb changes etc) I'm
>> inclined to go with Ido's previous proposition to convert the hash_lock into a mutex
>> with delayed learning from the fast-path to get a sleepable context where we can
>> use synchronous switchdev calls and get feedback immediately.
> 
> Delayed learning means that we'll receive a sequence of packets like this:
> 
>             br0--------\
>           /    \        \
>          /      \        \
>         /        \        \
>      swp0         swp1    swp2
>       |            |        |
>    station A   station B  station C
> 
> station A sends request to B, station B sends reply to A.
> Since the learning of station A's MAC SA races with the reply sent by
> station B, it now becomes theoretically possible for the reply packet to
> be flooded to station C as well, right? And that was not possible before
> (at least assuming an ageing time longer than the round-trip time of these packets).
> 
> And that will happen regardless of whether switchdev is used or not.
> I don't want to outright dismiss this (maybe I don't fully understand
> this either), but it seems like a pretty heavy-handed change.
> 

It will depending on lock contention, I plan to add a fast/uncontended case with
trylock from fast-path and if that fails then queue the fdb, but yes - in general
you are correct that the traffic could get flooded in the queue case before the delayed
learning processes the entry, it's a trade off if we want sleepable learning context.
Ido noted privately that's usually how hw acts anyway, also if people want guarantees
that the reply won't get flooded there are other methods to achieve that (ucast flood
disable, firewall rules etc). Today the reply could get flooded if the entry can't be programmed
as well, e.g. the atomic allocation might fail and we'll flood it again, granted it's much less likely
but still there haven't been any such guarantees. I think it's generally a good improvement and
will simplify a lot of processing complexity. We can bite the bullet and get the underlying delayed
infrastructure correct once now, then the locking rules and other use cases would be easier to enforce
and reason about in the future.

>> That would be the
>> cleanest and most straight-forward solution, it'd be less error-prone and easier
>> to maintain long term. I plan to convert the bridge hash_lock to a mutex and then
>> you can do the synchronous switchdev change if you don't mind and agree of course.
> 
> I agree that there are races and implications I haven't fully thought of,
> with this temporary dropping of the br->hash_lock. It doesn't appear ideal.
> 
> For example,
> 
> /* Delete an FDB entry and notify switchdev. */
> static int __br_fdb_delete(struct net_bridge *br,
> 			   const struct net_bridge_port *p,
> 			   const u8 *addr, u16 vlan,
> 			   struct netlink_ext_ack *extack)
> {
> 	struct br_switchdev_fdb_wait_ctx wait_ctx;
> 	struct net_bridge_fdb_entry *fdb;
> 	int err;
> 
> 	br_switchdev_fdb_wait_ctx_init(&wait_ctx);
> 
> 	spin_lock_bh(&br->hash_lock);
> 
> 	fdb = br_fdb_find(br, addr, vlan);
> 	if (!fdb || READ_ONCE(fdb->dst) != p) {
> 		spin_unlock_bh(&br->hash_lock);
> 		return -ENOENT;
> 	}
> 
> 	br_fdb_notify_async(br, fdb, RTM_DELNEIGH, extack, &wait_ctx);
> 
> 	spin_unlock_bh(&br->hash_lock);
> 
> 	err = br_switchdev_fdb_wait(&wait_ctx); <- at this stage (more comments below)
> 	if (err)
> 		return err;
> 
> 	/* We've notified rtnl and switchdev once, don't do it again,
> 	 * just delete.
> 	 */
> 	return fdb_delete_by_addr_and_port(br, p, addr, vlan, false);
> }
> 
> the software FDB still contains the entry, while the hardware doesn't.
> And we are no longer holding the lock, so somebody can either add or
> delete that entry.
> 
> If somebody else tries to concurrently add that entry, it should not
> notify switchdev again because it will see that the FDB entry exists,
> and we should finally end up deleting it and result in a consistent
> state.
> 
> If somebody else tries to concurrently delete that entry, it will
> probably be from a code path that ignores errors (because the code paths
> that don't are serialized by the rtnl_mutex). Switchdev will say "hey,
> but I don't have this FDB entry, you've just deleted it", but that will
> again be fine.
> 
> There seems to be a problem if somebody concurrently deletes that entry,
> _and_then_ it gets added back again, all that before we call
> fdb_delete_by_addr_and_port(). Because we don't notify switchdev the
> second time around, we'll end up with an address in hardware but no
> software counterpart.
> 
> I don't really know how to cleanly deal with that.
> 

Right, I'm sure new cases will come up and it won't be easy to reason about these
races when changes need to be made. I'd rather stick to a more straight-forward
and simpler approach.

>> By the way patches 1-6 can stand on their own, feel free to send them separately. 
> 
> Thanks, I will.
> 

