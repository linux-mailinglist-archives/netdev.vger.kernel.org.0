Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BD742BFFB
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 14:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhJMMbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 08:31:00 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.7]:60770 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233182AbhJMMa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 08:30:59 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04lp2058.outbound.protection.outlook.com [104.47.14.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 272F040084;
        Wed, 13 Oct 2021 12:28:54 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agMKCzz8bsGlFc5dW3KEoG88bUSJwSnn5ck/1/KngG8UBZlr7KsvXmD2E4aR0wkRfeH7Mnhipadqjqny9L82Fn+MzEHKomC2ccDBOIxGzt6IGtIZe3lL5jUTCyC1wWyViYe8jwNiVpj3mMx00qAKlP4mkys5YiZRzjIfUW2W6LI1fdKtikX8097GBHSSUWb8X488OeUGQWWTH6b/M+4D6gWBfXrQOLI/872cQAsknYLaQgNmgdo/c6s27G2c3LqRL5All8YEjdyebAtcHzyrbm93k5j+7IBgej1/AUExmf90AFQc8Z3DSRvoCziMGc+rcTWNLKDYu7yit9PL9t8HLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZOiuLvzEquwtO7dNsKr43X6hnnlLJHKx6JzHi2mQVM=;
 b=HO1dgIL69Av6wcIylBJ5whkqH53r6Q98AkbO+OyHxq1/fWNgZhj25xcTA6H3m+L/7h4sNR5iJTD2X+dR8ILeCzwx1XM++BCCzyk9ab3BcZmx0KUeNuRPsSs/SIghwhOhDWpq6wbjXzfn4av/SDaL/szJOV1vp3WdgJdtpvYX2N88X+iSRfvl9iVVdqfKXFhjYlrbFBZpXf6uUci8q3U47t4LYslAC8Us17LahEBl1efZMfoH7rZOv9TTdaXzK+FPEzdwlgu7uod9G+sPeJXalfaUkTdP1i6MS40HX2mvHfx1RL75zvNZHuhMaVuDVI62bxDrUogWCFapmMZx/II2iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZOiuLvzEquwtO7dNsKr43X6hnnlLJHKx6JzHi2mQVM=;
 b=ggQwup03WF+Ap6u+gdtL7noeKrRi8tANiUdxTlyVrqScrYqTHHCTqrjmUv/FLDVV4P0TI3f7xgT5sLRrEhHJ4WAa7pC+3Bi/RlD//oSu+y0u8j8GPQGPHZgYgGbns8/iFlln2jVum7M3ySPEVnPECkfBegFihwYE3ihddr0dkEU=
Authentication-Results: average.org; dkim=none (message not signed)
 header.d=none;average.org; dmarc=none action=none header.from=drivenets.com;
Received: from AM6PR08MB3510.eurprd08.prod.outlook.com (2603:10a6:20b:48::30)
 by AM6PR08MB3397.eurprd08.prod.outlook.com (2603:10a6:20b:43::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Wed, 13 Oct
 2021 12:28:52 +0000
Received: from AM6PR08MB3510.eurprd08.prod.outlook.com
 ([fe80::fda2:99f0:7b93:53e2]) by AM6PR08MB3510.eurprd08.prod.outlook.com
 ([fe80::fda2:99f0:7b93:53e2%7]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 12:28:52 +0000
Date:   Wed, 13 Oct 2021 15:28:43 +0300
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     Eugene Crosser <crosser@average.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        David Ahern <dsahern@kernel.org>
Subject: Re: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset skb
 conntrack connection on VRF rcv" breaks expected netfilter behaviour
Message-ID: <20211013122843.wxj7jtyzifwng3j4@kgollan-pc>
References: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: AM6PR10CA0044.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:80::21) To AM6PR08MB3510.eurprd08.prod.outlook.com
 (2603:10a6:20b:48::30)
MIME-Version: 1.0
Received: from kgollan-pc (199.203.244.232) by AM6PR10CA0044.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 12:28:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdb160d6-7b42-4cc1-bb1e-08d98e450436
X-MS-TrafficTypeDiagnostic: AM6PR08MB3397:
X-Microsoft-Antispam-PRVS: <AM6PR08MB3397654087E8ED0D10461BA8CCB79@AM6PR08MB3397.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sz39c8cFQXj3VoJMrnrc5AZJ2dXeCgFw4hN/iINVpI3CSTW9Z2PpQBHBedpgCO/UtPJmm06la5rH3r7OqcvAahpotCouudbIL4iMsjqHJGmdEF3NNqnfqgDVPR+ASMBPfTfLORPi6mV1Amux3lcSx+1LggL6lB5mnMn7bBKV9FFaq9qtYiABbhYv/AnKoysfMYn9b8QZ8hVXij4OaTEvFCTawMvWJXY8KnCRnrR5F4kvcWjX+hJJsYe3eEk2wVIcJ+Pwn5ojCJWvJSsSM8+ZwvbeBK4jbteVvBPhzA5yW22918//hUPGFhUezknibktpbt9SgbRB1sQwUnd2RSL3+DhfYrCt2zQ8nmb7kwJGUL1L6WSGsRSTawnGjHxR0XOb6Oc+OvfwFoaQlJSczd+ZIIFsRrw6DcDZnUsWfyuT8RzIHFHo8A92jFl2wYyve+49fcXDqZIt+EyQKcbMvG9fbOTShcQCMJ8fz950Rgvf9XVBM1ic9cYszDKxPK0g1//+5kGt9CSKxI/+Fq2Av5E/hmJ0rctMrY/Rq3ArwN9wyTCUiX7cQeZ10y/acbimpiZ4mVX6aNRLk5WGlFE9SVKoDHnuS7oYOdQjv7LOkcUgYy4oYUhu39hydT6q1SOFIn7XR3hrvI26V/zuwBplgr1VmIEObPAQLf5UJGC5KVRueBPE9NXwi6JXrKWCaxHzrqKfpxtrEHSdI8jHwn7PyWOnwcjeJ7+mOpD/kAqgiTQAaf3m5wtGIcaKn1W/b9Ts2DcbOnB9dCqOLohFuPJln4Qy2PhzAc0VUoj3s9COXwkTxF5oO/bXeviSJj29nj1mGRkX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3510.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(83380400001)(86362001)(66476007)(6916009)(316002)(8936002)(52116002)(5660300002)(6496006)(1076003)(956004)(26005)(6666004)(33716001)(2906002)(508600001)(4326008)(186003)(66946007)(55016002)(38350700002)(66556008)(38100700002)(8676002)(966005)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?80I6m+sU4Vc1684KqlBIjySmqsDx/2U4IpG3/MT42dnpIBpWhEAmeGCLIfL6?=
 =?us-ascii?Q?90zgBmcXCT/ZQgTZZvVFUmzQLAPhxZJnED96nI5Jx4kjKoUrCXhzEU1LOZrL?=
 =?us-ascii?Q?9xlj3JmydfoydCXs0xHsxeOtK5Ne25dzPvjHVgPAYJjE2nhOOeFdY7JYvZ5k?=
 =?us-ascii?Q?+AJS5zlYvxrNeAD7wbCDh5rP/tkFTrhSq7/u7sYPhVBp+ozSWmLNfS31bnxf?=
 =?us-ascii?Q?P+uBkm5LpHqZozvDpKqZWpJ+PwIIAqg1qJkAtma4ULfdo9a4JIHf+5vjqGz7?=
 =?us-ascii?Q?grySWVhPaB5T9p0PINKj1sRLwPCUD2IDizRAWtT1g6uOa18rX4RoXwT0dV9X?=
 =?us-ascii?Q?0+sL+8WsqE/cxAOFRhNf+euq9SkL1bud6TdX+30QUYJVH7GjWkY6dtH+ysGb?=
 =?us-ascii?Q?gDFs3Qhkc6bUcuuBErj3WMPMzaag2nSycTb9eIYG+8e+XCBG0S9pG3brstHw?=
 =?us-ascii?Q?iUkJ6Wg0z74aWl4JwZd6Jrq1shEx6pkEzhjw2D1YZt/r3YR+YNx6Qx6m3v/+?=
 =?us-ascii?Q?cfeHrfD3l2qGtH1CMJbYy4bgUJwY/OdeiyWlK8tr/q7t8BS43XO43xDiELyb?=
 =?us-ascii?Q?H+Q52h7mYeZ5tj0EsHA8uECXyiA8A6cFnm3wzerloZ3/jd9uaUFQuTK6XaMF?=
 =?us-ascii?Q?sr/WthnmW1eipWPgVOpCml91AN5fv6+mxkXt7GR6HX1VQggQmdQKOXf8PR9p?=
 =?us-ascii?Q?OVWJ+BosMGtdlSVtDdzqRPgKrxt26GycoiZ0FEuSbIe6zv1CpUI5xjfpjiET?=
 =?us-ascii?Q?1C1bka78t4jHBRaRkoVGsauwRo5oLV3P4eP59VQC/TDsiTuAmhY2GVjxadcV?=
 =?us-ascii?Q?gYWdM0aEj7DW9Uq/GsLLgYvaynw49XuwvhTIDWJyReJF3bE2q7GMKtQFZdLn?=
 =?us-ascii?Q?yWckb8SITS4thDBKj9Lrrfc3J+p4J/owf9d43vzemcd+9KJG2sajs//zi2a1?=
 =?us-ascii?Q?tuUjC1f/TpqyM6x8ICQqcFSBT3cGRTueiR7NqDktFnphDDdmwb+cinBk0Nv/?=
 =?us-ascii?Q?gTcHQFIbAW+3CASEWJu4UR5Qbn593HMzMiAoLCWEbfCipWtc4Ho0PW5AuDFX?=
 =?us-ascii?Q?1rz8Ked+UQrHQSimNQ/VVhzENCljDn64ln7UJ2Zv8KjHECRBbnmv3SWyb5HM?=
 =?us-ascii?Q?V32sh/hxL2p+uZgZSJw5tmmxKQPoABo7k/ctBDE3/1OxLBsDffo5tvlld0Os?=
 =?us-ascii?Q?TpTw5NlawlyPdA71VYeh+PitL+ZaOvJGra9CeslGoDfhe0mgCoZapLSb5tP9?=
 =?us-ascii?Q?9HniVi0WsFIUgMTL5mErE4fK3dcJdJngCHJelAWM/ymj5L0ODiL8Nw80ERHs?=
 =?us-ascii?Q?eBfhf2Z25+FAgs/yqTW8+uAw?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb160d6-7b42-4cc1-bb1e-08d98e450436
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB3510.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 12:28:52.6357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nKbJhReVxV0BGOh0R0vDShK0UGVp330D8iSh3QCxxEm+xX4PckUf0W0eMAkWsQUw9jKiyAiRj/3CgZd0A/FrZDlxBfJk/ISzuX2PutmXBYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3397
X-MDID: 1634128135-Sm6CE4sOl-3h
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 03:28:39PM +0200, Eugene Crosser wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>

> Date: Tue, 12 Oct 2021 15:28:39 +0200
> From: Eugene Crosser <crosser@average.org>
> To: netdev@vger.kernel.org
> Cc: netfilter-devel@vger.kernel.org, Lahav Schlesinger
>  <lschlesinger@drivenets.com>, David Ahern <dsahern@kernel.org>
> Subject: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset skb
>  conntrack connection on VRF rcv" breaks expected netfilter behaviour
> User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
>  Thunderbird/78.13.0
>
> Hello all,
>
>
> Commit mentioned in the subject was intended to avoid creation of stray
> conntrack entries when input interface is enslaved in a VRF, and thus
> prerouting conntrack hook is called twice: once in the context of the
> original input interface, and once in the context of the VRF interface.
> Solution was to nuke conntrack related data associated with the skb when
> it enters VRF context.
>
>
>
> However this breaks netfilter operation. Imagine a use case when
> conntrack zone must be assigned based on the (original, "real") input
> interface, rather than VRF interface (that can enslave multiple "real"
> interfaces, that would become indistinguishable). One could create
> netfilter rules similar to these:
>
>
>
>         chain rawprerouting {
>
>                 type filter hook prerouting priority raw;
>
>                 iif realiface1 ct zone set 1 return
>
>                 iif realiface2 ct zone set 2 return
>
>         }
>
>
>
> This works before the mentioned commit, but not after: zone assignment
> is "forgotten", and any subsequent NAT or filtering that is dependent on
> the conntrack zone does not work.
>
>
>
> There is a reproducer script at the bottom of this message that
> demonstrates the difference in behaviour.
>
>
>
> Maybe a better solution for stray conntrack entries would be to
> introduce finer control in netfilter? One possible idea would be to
> implement both "track" and "notrack" targets; then a working
> configuration would look like this:
>
>
>
>         chain rawprerouting {
>
>                 type filter hook prerouting priority raw;
>
>                 iif realiface1 ct zone set 1 notrack
>
>                 iif realiface2 ct zone set 2 notrack
>
>                 iif vrfmaster track
>
>         }
>
>
>
> so in the original input interface context, zone is assigned, but
> conntrack processing itself is shortcircuited. When the packet enters
> VRF context, conntracking is reenabled, so one entry is created, in the
> zone assigned at an earlier stage.
>
>
>
> This is just an idea, I don't have enough knowledge to judge how
> workable is it.
>
>
>
> For reference, this is a thread about the issue in netfilter-devel:
> https://marc.info/?t=163310182600001&r=1&w=2
>
>
>
> Thank you,
>
>
>
> Eugene
>
>
>
> ==========
>
> #!/bin/sh
>
>
>
> # This script demonstrates unexpected change of nftables behaviour
>
> # caused by commit 09e856d54bda5f28 ""vrf: Reset skb conntrack
>
> # connection on VRF rcv"
>
> #
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=09e856d54bda5f288ef8437a90ab2b9b3eab83d1
>
> #
>
> # Before the commit, it was possible to assign conntrack zone to a
>
> # packet (or mark it for `notracking`) in the prerouting chanin, raw
>
> # priority, based on the `iif` (interface from which the packet
>
> # arrived).
>
> # After the change, # if the interface is enslaved in a VRF, such
>
> # assignment is lost. Instead, assignment based on the `iif` matching
>
> # the VRF master interface is honored. Thus it is impossible to
>
> # distinguish packets based on the original interface.
>
> #
>
> # This script demonstrates this change of behaviour: conntrack zone 1
>
> # or 2 is assigned depending on the match with the original interface
>
> # or the vrf master interface. It can be observed that conntrack entry
>
> # appears in different zone in the kernel versions before and after
>
> # the commit. Additionaly, the script produces netfilter trace files
>
> # that can be used for debugging the issue.
>
>
>
> IPIN=172.30.30.1
>
> IPOUT=172.30.30.2
>
> PFXL=30
>
>
>
> ip li sh vein >/dev/null 2>&1 && ip li del vein
>
> ip li sh tvrf >/dev/null 2>&1 && ip li del tvrf
>
> nft list table testct >/dev/null 2>&1 && nft delete table testct
>
>
>
> ip li add vein type veth peer veout
>
> ip li add tvrf type vrf table 9876
>
> ip li set veout master tvrf
>
> ip li set vein up
>
> ip li set veout up
>
> ip li set tvrf up
>
> /sbin/sysctl -w net.ipv4.conf.veout.accept_local=1
>
> /sbin/sysctl -w net.ipv4.conf.veout.rp_filter=0
>
> ip addr add $IPIN/$PFXL dev vein
>
> ip addr add $IPOUT/$PFXL dev veout
>
>
>
> nft -f - <<__END__
>
> table testct {
>
> 	chain rawpre {
>
> 		type filter hook prerouting priority raw;
>
> 		iif { veout, tvrf } meta nftrace set 1
>
> 		iif veout ct zone set 1 return
>
> 		iif tvrf ct zone set 2 return
>
> 		notrack
>
> 	}
>
> 	chain rawout {
>
> 		type filter hook output priority raw;
>
> 		notrack
>
> 	}
>
> }
>
> __END__
>
>
>
> uname -rv
>
> conntrack -F
>
> stdbuf -o0 nft monitor trace >nftrace.`uname -r`.txt &
>
> monpid=$!
>
> ping -W 1 -c 1 -I vein $IPOUT
>
> conntrack -L
>
> sleep 1
>
> kill -15 $monpid
>
> wait
>



Hi Eugene, I apologie for the late response (was on vacation).

The call to nf_reset_ct() I added was to match the existing call in the
egress flow, which I didn't want to change in order to not break
existing behaviour (which I unintentionally still did :-)).

Seems like any combination of calling nf_reset_ct() will lead to
something breaking. So continuing on what Florian suggested, another
possibility is to make the calls to nf_reset_ct() in both ingress and egress
flow configurable (procfs or new flags to RTM_NEWLINK).

One benefit of this is that disabling nf_reset_ct() on the egress flow will
mean no port SNAT will take place when SNAT rule is installed on a VRF
(as I described in my original commit), which can break applications
that depend on using a specific source port.

I'll need to think about it some more though, I don't have any better solution
right now.
