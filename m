Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7DC51EC1B
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 09:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiEHH4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 03:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiEHH4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 03:56:51 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F9265A8
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 00:53:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVfj82Nyi7YqSVHnmjefMEOfAWicqQpcVfAa8d7XoQLQz0jDacrlgHDcyBG+PhmK2LfLFGgF5vNVqL6XQTTtaYdIbkYlaB4twafzA8MgNvdhgZQ+xG21lqn1P+zUa+J9DKy8nLm5dU6PFLnk5z2uTZJJ3jqwnZNkWIZCwkdigoe91ODcfjxPFX6zu11YfBOlEr3bLNiHT/PD9hht+OnCwMj97Fbrzokq+vK5PuTlBO7hDJcOzLcShI/VVW5XQSISOB0w0b7kWX0auvVTr/3UnpqsumuXXiRvtc0KatxtsxvwDOiAk43jzKjgiidzbFFnz+9XOnl0pTwVqZL6SqGfXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+coYDT6nC/hhcdlPzwpYMKSVihK1EjX5fUZMAByoGU4=;
 b=KvWbXa2/aAT1F6jw7agODnM1zlGK2YZDF1O+GiW7N5qvTzNoeClqJObsVn0qEsKkEC289cftBOimHu0ahnDPGw8BDiWMj/e7lP+5gCpKSYNJ7//DhGpFfJ0Oba/jSfvwYgWffL15CH2ed4oky5/F76nC7A/yYTDo0k+oGQoz4Re7bi4PAtz5HL6wcOupJiCsKcVzPZkb5uFPdVqwAET/OYDo7bjCj0xGkHJ2SSIdPX9ifiuoFIkx/YmS1xPUVXjgwvNYcDyMOqIBT6v3tey24qdw2Ff3WlOzN3uGL19d5wMbio8z5zfFGaF42xOqwaOMiOdFR+YG3wfK6+n5yi/H9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+coYDT6nC/hhcdlPzwpYMKSVihK1EjX5fUZMAByoGU4=;
 b=DNNzCL6nnPSFKejjL96mrY+2VS0LSYr/ZDJe8wBB2vdp834d5KKpFL/rD2imqIX0YURxcc1QnHHYnQpkBmlC3krRInUyPRkcjsJHc8zwITrZr+FSVrUhiEhW/KkbrxhEJlIof/gYNMRKyFVHqHWk6tFHWmW4Viv4TFp/1nKfyw+fUjO07NxdiFh3lvmzBiE0wujzy2wrJZsmVPIrEobc6Wejd0wtqLOqq96nrpQLQ8iB2FHe2brFUC8Z1smw/meP6LS8bVuu6rlimdp6FiWw72Bsm947bo/MtyN7hp/sbr/uvmd5gBIpwaFjrLjKXIR3CfoGdp1O/UJ0o4Zww1ESbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM4PR12MB5184.namprd12.prod.outlook.com (2603:10b6:5:397::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 07:53:00 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 07:53:00 +0000
Date:   Sun, 8 May 2022 10:52:55 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@mellanox.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH RFC] net: bridge: Clear offload_fwd_mark when passing
 frame up bridge interface.
Message-ID: <Ynd213m/0uXfjArm@shredder>
References: <20220505225904.342388-1-andrew@lunn.ch>
 <20220506143644.mzfffht44t3glwci@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506143644.mzfffht44t3glwci@skbuf>
X-ClientProxiedBy: LO4P123CA0027.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::14) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c6f6dec-c643-4937-e9e6-08da30c7c5c4
X-MS-TrafficTypeDiagnostic: DM4PR12MB5184:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5184D9C6C9416A1B8C31D735B2C79@DM4PR12MB5184.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +dp6WBqZ9O/nMpbjANVfIcD4LHCcPMoPmNKzQVPUw1sJDe6o5rIVhA9fMUTNo0g2DsYNpMN8QGVOYpRTTV+Q+WzpmxaI19Ki2vGqUL36daxEHkPq1GLb9d6MMTsnv7j6PqDIgGF8HAsuq9SOWd1WDvcK7cFYQKricfCloNASaYNbR096fHe2vJocrNT41zIcGCY2F8flu5WtfVQ1ATRIIYOZ5TcNkZadYGTkcJDQEXfF8BwzuMuV9vkhkEot14Zs7JgGKEUsKuKb+9sR7AlsvrM/tFIOYO07WbnJ6do3onziS8YrdgcKCEnGjsSZ0EGlrZL9+GobpMYMh031S5wFbPIw7EqC+o9UxyEoPXOdY7YjH8UQUz3vr77JuG1C66FGF1tT7DAESPBxC9QFb6lmFE6JoPveethQ/7YRm8JxPQCHirKTWX95xvvbgi3deinzKa3eFHEgvcWY/+z2W9BFgDvnEy1TVoMVEOssEnwspBAt6Vr0qdh1cfhPPBPY3I/KRIDuAB/zreLJ36zqsyO5JHTHQgcRH5U0MyCgOE93NLJOYAupkF0z/mj6olXJ7HyI7ghEck5ZkaczGSCLVOuw8Sy03+gIN9SWSCKO1+PtBborbV6rlHNpMZX8kqploQyjUmzTs4DgVFxSSRZuZDfoNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(33716001)(186003)(66946007)(66476007)(66556008)(8936002)(5660300002)(26005)(83380400001)(9686003)(6512007)(8676002)(4326008)(38100700002)(54906003)(86362001)(508600001)(6916009)(6506007)(6486002)(6666004)(2906002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UFm+KtZMW8ugNLW1Kbufh1bxQ6tBL+YEZ9Budhyzhdz/dESR2MBc1RelTQue?=
 =?us-ascii?Q?qIqMpnDkP08egBYuISOde/FfwVq8XPwA9J7GSDSsE4c64JINNJzOqb/Av/ml?=
 =?us-ascii?Q?lb+j15bWIH8By5k3/kv6AuAF9Sw56OIoa5QgdVp9YVCQJQnzlvhphnIzy8Wa?=
 =?us-ascii?Q?o6c4on93pmxvAhAtJXIVNeLkZkvQvFy1DejnHUtLHjS3rxjNMx4XjvLRR7Dz?=
 =?us-ascii?Q?kEl6s9fvY6A9ZhCKR/M7ADhZbTngmvAhpZx8ylDUtHllcH6IcKecsFecjXU4?=
 =?us-ascii?Q?Ypikak629gIa+v4tEvG9hBOw2YLyVq6NBKcMetDaFcBQjTY/O0Cohdxv/7Se?=
 =?us-ascii?Q?EJv0VRrSaBHy6sURcbHzGUU9F9YGdeIBsjrhKjrcP0JNp2V8cEWMwjVoRRFI?=
 =?us-ascii?Q?JuoW5cyhrhyqiFFUosmp1SFBHsTDA0/d+dIDiqNJVdXi0AWYymKDFE7LZMqX?=
 =?us-ascii?Q?BSuhsiu4PCRKWyTmwYtDm1Cd3S7a6bCiwvP5zxyA+fIQGmP5CJrWIsXZ6sgv?=
 =?us-ascii?Q?I8lhJpNCJmimKPZ3h60WYVKEDuwbxEJSonifOibJXltOLYRQW5gBXHQUVDjH?=
 =?us-ascii?Q?qDddUdYyp+ZSub4dhNApx6va9yAFUKt/hhqE+m/eq5p5sJjpD+ZBRsSCKbng?=
 =?us-ascii?Q?wEUF0xxDaJf4WT9DyxbGm3T2lPZr6KPIbOyRw8FnKCs/1Q+0i0Lb0AY+LDSI?=
 =?us-ascii?Q?PrADG3yzFzsY7O9EYlEJ2bljKviXn+CHToWnb8S+HVH94k+eK/M6n3CoVRab?=
 =?us-ascii?Q?Nl1dZGTUMCMuIjoHPPkTDOLIHvbmigV+WSaTP3NOS6YnZu3BodF4BSa8IMJ7?=
 =?us-ascii?Q?iPpmWi1JIWU8600hAgX8gPwNSLKbN6P6K5Okxw1hrYKSi2lWK7qnPiIRCgNZ?=
 =?us-ascii?Q?dC/jIxg0bWxhW40KDoHhCYQ2RaiErcXtl2Sm0Q739ozDPH8056lCAQT7V9E0?=
 =?us-ascii?Q?wBdSGAM8YG10RgQqygxITOhGiMHC0fS0pcOX/N4pxHAmmFlpVOoEyxt4fc10?=
 =?us-ascii?Q?T1XVYLBmp/Mdg3JgbU8eiteXaQ6/r0+V2oxDDQs2oIl7MXTT+pUKA4RfXAed?=
 =?us-ascii?Q?XNsd8KFi4ks3Ak+JoC+AQZNhvOd8kIDPfRupKvadtIqnhiQAPsMUWZ2GEmIB?=
 =?us-ascii?Q?fJlZtuFn/iI/CZ3h7d3kR5cuG4nibQvXIXlPK5Z9T1NlHOZxj5Jslw4mW1fM?=
 =?us-ascii?Q?wVsiSPVZ1aWrVZSKZle9jc8W/k+KsUO938mjqzV+PqSWiamCuDtQTmeSB37g?=
 =?us-ascii?Q?LuSiAtW659QvskM0SwsHBsZ4hhs5IBH8mJYufijJ6WJqe+6ZQCGnJpy3nZIj?=
 =?us-ascii?Q?N3xtYXCAVnd7uB+E8fNLKLf5FI+mkOeEyIiFnEEBW00dE1laSu7Y0/hfCfp7?=
 =?us-ascii?Q?425XP/CzQsaDQlIvky7JJmhcHo7SERF3whkwQiGnU6gwvm0xf3lr3ZJdThuz?=
 =?us-ascii?Q?dVkZPeuxwV+IRCxCxBv+p+swG5MY2zF0cdpZbWDp1h88Iq+kXnWpRWPpoLq7?=
 =?us-ascii?Q?9z9UvjjagBHGMOHjhq85ZpGfpx2P8yZEZJ+dtAcoi1WCcBbvMU/3EWkWik+7?=
 =?us-ascii?Q?U4wp0bK9p4RBaHTCyNEd+O8T+FCOigjTa/F3QEXgGdtUbUwBZpnAj7c4RKsj?=
 =?us-ascii?Q?4MQDiaK/jHIP7mVFGu/g8iti6Hyy/kt+41JSuMtntF+0TXZwcnOti5VGyIqX?=
 =?us-ascii?Q?pCV2hNHr94gj/qPYUrfBrUKeTYpTcTcE746273KvdRb3RWdlhEar0iWXxTB+?=
 =?us-ascii?Q?tkIFFkq0Zg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c6f6dec-c643-4937-e9e6-08da30c7c5c4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 07:53:00.3643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8BLRjgZaT7axj5oISodpl9a/RMd+KIWgNwei2yL4fY9PCro3MPNigr6lS49aMFJ3o3EBOBtdHq3idycArhMbKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5184
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 02:36:45PM +0000, Vladimir Oltean wrote:
> Hi Andrew,
> 
> On Fri, May 06, 2022 at 12:59:04AM +0200, Andrew Lunn wrote:
> > It is possible to stack bridges on top of each other. Consider the
> > following which makes use of an Ethernet switch:
> > 
> >        br1
> >      /    \
> >     /      \
> >    /        \
> >  br0.11    wlan0
> >    |
> >    br0
> >  /  |  \
> > p1  p2  p3
> > 
> > br0 is offloaded to the switch. Above br0 is a vlan interface, for
> > vlan 11. This vlan interface is then a slave of br1. br1 also has
> > wireless interface as a slave. This setup trunks wireless lan traffic
> > over the copper network inside a VLAN.
> > 
> > A frame received on p1 which is passed up to the bridge has the
> > skb->offload_fwd_mark flag set to true, indicating it that the switch
> > has dealt with forwarding the frame out ports p2 and p3 as
> > needed. This flag instructs the software bridge it does not need to
> > pass the frame back down again. However, the flag is not getting reset
> > when the frame is passed upwards. As a result br1 sees the flag,
> > wrongly interprets it, and fails to forward the frame to wlan0.
> > 
> > When passing a frame upwards, clear the flag.
> > 
> > RFC because i don't know the bridge code well enough if this is the
> > correct place to do this, and if there are any side effects, could the
> > skb be a clone, etc.
> 
> Each skb has its own offload_fwd_mark, so clearing it for this skb does
> not affect a clone. And when a packet is simultaneously forwarded and
> locally received, the order is first forward/flood it, then receive it.
> Cloning takes place during forwarding using deliver_clone(), so it
> shouldn't be the case that you are clearing the offload_fwd_mark for a
> yet-to-be-forwarded packet, either. So I think we're good there.
> 
> > 
> > Fixes: f1c2eddf4cb6 ("bridge: switchdev: Use an helper to clear forward mark")
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  net/bridge/br_input.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> > index 196417859c4a..9327a5fad1df 100644
> > --- a/net/bridge/br_input.c
> > +++ b/net/bridge/br_input.c
> > @@ -39,6 +39,13 @@ static int br_pass_frame_up(struct sk_buff *skb)
> >  	dev_sw_netstats_rx_add(brdev, skb->len);
> >  
> >  	vg = br_vlan_group_rcu(br);
> > +
> > +	/* Reset the offload_fwd_mark because there could be a stacked
> > +	 * bridge above, and it should not think this bridge it doing
> > +	 * that bridges work forward out its ports.
> 
> "this bridge is doing that bridge's work forwarding out its ports"
> 
> > +	 */
> > +	br_switchdev_frame_unmark(skb);
> > +
> >  	/* Bridge is just like any other port.  Make sure the
> >  	 * packet is allowed except in promisc mode when someone
> >  	 * may be running packet capture.
> > -- 
> > 2.36.0
> >
> 
> The good thing with this patch is that it avoids conditionals.
> The bad thing is that it prevents true offloading of this configuration
> from being possible (when "wlan0" is "p4").
> 
> I don't know what hardware is capable of doing this, but I think it's
> cautious to not exclude it, either.
> 
> Some safer alternatives to this patch are based on the idea that we
> could ignore skb->offload_fwd_mark coming from an unoffloaded bridge
> port (i.e. treat this condition at br1, not at br0). We could:
> - clear skb->offload_fwd_mark in br_handle_frame_finish(), if p->hwdom is 0
> - change nbp_switchdev_allowed_egress() to return true if cb->src_hwdom == 0

I like Andrew's patch because it is the Rx equivalent of
br_switchdev_frame_unmark() in br_dev_xmit(). However, if we go with the
second option, it should allow us to remove the clearing of the mark in
the Tx path as the control block is cleared in the Tx path since commit
fd65e5a95d08 ("net: bridge: clear bridge's private skb space on xmit").

I don't know how far back Nik's patch was backported and I don't know
how far back Andrew's patch will be backported, so it might be best to
submit Andrew's patch to net as-is and then in net-next change
nbp_switchdev_allowed_egress() and remove br_switchdev_frame_unmark()
from both the Rx and Tx paths.

Anyway, I have applied this patch to our tree for testing. Will report
tomorrow in case there are any regressions.
