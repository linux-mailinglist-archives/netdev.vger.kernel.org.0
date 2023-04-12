Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EAE6DF826
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 16:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjDLOPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 10:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjDLOPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 10:15:19 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E3772BE;
        Wed, 12 Apr 2023 07:15:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S60BNqiyPwKbf1if0gvSwbT7T5WU5eTd2glHD2gZR8SC8vVBRyls7Fzs5Z0CLNvWnWQulOHpYrO559aRHkLJTs8/IWMANPjXakwY5pzDWwIHf4prFJLiv9c/8wEzNuoRazX8TJYwk3FBGaL8cWmAVoov/BgVzM73idZobWCyUCBELoAAwjRzL92QIG2O1enevDwJCr4BwxtfCxzph54nOVvqJCWxxJA5gjYKLnNaSIdFLwci8F8w3j16x7JEgaXpUnFC8AkWCj4fzEX5HCY6vHbrv3xrKyg2vCFYUGGHsOMw9Z/EAHUqDs/ZvN9yBclSPdZwRoFHfl5hvSVvSyKYbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iH0gKl7qgURtjNCdREaA1hKm1GwxqNYtnIpddCoM3kQ=;
 b=g7ZklUfZR6ngLYXvGI+Y3bRK5sqRFuspNUklnzpR/tZchP0IXeT7uZ9pIJz4/mwR7tqSPVLYIqEOOwTZlMiJfWtTvsm3ZuqGO1j9nIhGMszk5cUPJ1m7AkvsaCU00DXrxXhcRbyVcKdRmOBSBRNxn+2ZUAXqNvpgACYxi2rUw86T5aEySI2k7ve/w8Vonm4VjpRRVr8ygxfxPnD/ORI3SnbplWqxRFjBFakuvSr3hUqvZZHKLtEj1onxBg4LGJbBGp3VB81TcgBPEOwKxkTgvrdrWqkhOkpTc7LXWgJQHKLLevIdDc1WEwA8/MX8dt4wkKETse74bAILsh+8Iw2sgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH0gKl7qgURtjNCdREaA1hKm1GwxqNYtnIpddCoM3kQ=;
 b=XeRN37LnvG1hC8+lOlebQBgkbvzEx/c0eB2Inm9gsy7n6zut2ckIq66vmVrACgoenMJJ/1qjRiefmn+l5aZpG88CpYZQSd3/lPEfzkUPMhv4pRWGgVoXsTmf9DyV4Rnd7ramwocPZbo8gZuicLn8ABW6apIo9dZanp50d8rzBt2z2VVfJkFf0umzmFCJoJyqlAMaPMParbBPCMCC+bYQiLQrhfQUkCyDaLaSOVWluDLdH6odWPza/E0a1BSa/x2GB2LCroD9WwTQFpQPb5SVkHWbaRErGZ8rmdd4/T1UjJ9NHOKzWiHVO37guS4CoaFFnU5G7mXbxEhYQDqnjY1AYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BY5PR12MB4997.namprd12.prod.outlook.com (2603:10b6:a03:1d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 14:15:10 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 14:15:10 +0000
Date:   Wed, 12 Apr 2023 17:15:03 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Arkadi Sharshevsky <arkadis@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: bridge: switchdev: don't notify FDB entries
 with "master dynamic"
Message-ID: <ZDa856x2rhzNrrXa@shredder>
References: <20230410204951.1359485-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410204951.1359485-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: VE1PR03CA0005.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BY5PR12MB4997:EE_
X-MS-Office365-Filtering-Correlation-Id: 95c0586d-1295-4bda-9656-08db3b605300
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HDAWHDu7R2nVIEvTcVVBjYZU3THe0x8YT4VVjz3uNSh39uBOtPZBhqB8UmnXT3mE2DhfT0jlxmv0yc5YmsD8mZi7FHmtltUeXhDTnniM7Vijce6xD5wUM62ruk9tiG5jwHfUArOhbshJZKAfPXNtevL9MSNyc2JZejsSvLJYVqM0746mPYw/84Hr8gKeJI5GFjtGdbipXvPnCuOs2WjOD3xHaCfs3osDLjA0XguHuEHHELjtd3aI6are/Eyvi0xzTdgUx0Ql9eqoQiJjXcHPzRLWhNVUw0mI18NCFoKSsD5PXSJCM/OrJJHiNz51e2cAFEadCZjlbu4eCJNOnx6Z5yq+HszmJOwO9xr82sHwIiBdeW57pFUIunjFGtF7eqqWF4Vk8vJyQUA89wiWjjDLvwoyhDR/EOb0u2x+BdnyEpVhgenenxL5IrUSMiwOR4dxrroXiI5ouJZJ4Iml40ucm2X5blIblDaTkb00KMD4vjOapkAQrnRR7sG1pq6R3K1+Lq45EgC8zoR/gOE95iwylas7/pZmE0U2rrEbjBuwu+RCRKF1x3smhi1COSk1/pjQRVG0FxkSqE0D0Il+zTOaxYChmBVJ/M2Qa9nMIoG3BR8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(396003)(376002)(366004)(136003)(346002)(39860400002)(451199021)(86362001)(316002)(54906003)(41300700001)(66476007)(478600001)(6486002)(4326008)(6916009)(966005)(66556008)(66946007)(8676002)(33716001)(5660300002)(2906002)(8936002)(7416002)(38100700002)(186003)(83380400001)(6666004)(9686003)(6506007)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pwaCYnD7Fu9oJoRPz+s3dAZgHUTm0DnMWiRhTEc7faFdW/rWMsdoSaU4Gkqo?=
 =?us-ascii?Q?OxqIPOVgcYxP6dNBrosUbvZ7FLGguAmHuTl70mlOuMMbqznXJjp55aAm8pP1?=
 =?us-ascii?Q?gLTUG1Ru/xrMr5nzrGtKRo/dTX8rN/+KADH45NIxTeeB1ou7ux4tmAoTF/tg?=
 =?us-ascii?Q?otEXkZ57/EG3J1QAi5tq1e6rJTZYT8TDsuu0ShrVSM9VDlBtBAO/LmzY2EDF?=
 =?us-ascii?Q?zzM+eHFLjzQOaKCbEmH4Nyo4rokx3eNqQoKg+X5tNVe4v/EQOfb6G+AD2GNN?=
 =?us-ascii?Q?joCFOLrtyoEOODCYtw0psZ+IbxIopfjzCVZ3VkRPPDn9oY8nb0VQyeB4y81L?=
 =?us-ascii?Q?COWGRzZjUTSF+OdbFFAbti3zHmRC5LfwgeOT9JX8VRYCnrReAZ0g+BD3uXWc?=
 =?us-ascii?Q?R5tMEfoMF2t/V40zYO6h0CogbMl9LcbLxplGRATJvUUExOea9hO9vxnply4R?=
 =?us-ascii?Q?vH9SvxwUqiqR0iiESbB8SrHjMwFsJrBG7kzhzdzlyXQHx4KI5QI8KRCQRmqP?=
 =?us-ascii?Q?ASSi+MyGd6Jxs+x14rmusym2+eEBMImG7BQGzFPKb3ykAjRoWhCaIFFC2i2v?=
 =?us-ascii?Q?znO9HkkaShYz0r3jPN3vvzBPaxhkOYdFWesHt+JocP6XcxhdnFDgR2IQLeWe?=
 =?us-ascii?Q?OWl9ECnViSNxxad1ymIl2viHhq23meIYVt7mfgNvxaRsCwW0utu2VjHdP+VG?=
 =?us-ascii?Q?uP+mZvEN+gpTsXq9hY2xk/8FLDzBsxW7mHp6QCIGE/sTrumOw5xjaGm0jqsb?=
 =?us-ascii?Q?dst42yQSOatcYuMc+GkYwIwqfoL5b2bzG56tvUMCwqcuf4U4HrG9ngU7/4Uk?=
 =?us-ascii?Q?KJg/FaPz2yeCqdwIuK+HECquTz+O920AluZLW0JBIAaPEDJvh7n6RVVoHM1n?=
 =?us-ascii?Q?zWz2JSEzWiDOEqwtc8RKccCv2fjqw7tKpGbGPgWfEXj1u2LuAgr7xaX2pRAC?=
 =?us-ascii?Q?IZIdrNKHuMXQCLtk/28OqxcdcnXlq5VXt8fByMFJNAPWdwLa4NhY//1alXuK?=
 =?us-ascii?Q?uc+h1m8JjtuGT0U0tkoWO/kZyuQ4hgTgb/5832fYIPePwD8uR7jkiKlQkk3p?=
 =?us-ascii?Q?Cxj3QSeUyO+qjHdIzga6t8DEv18mgAjt3AP9UD3ovFvVdt0uKC8XQ+cQ7Bjj?=
 =?us-ascii?Q?JsEdL/zc8fkYF6eel0oPUbbAMg4+SDHZY/AE7ddchN8OAe9rXMQpr/e0lhyO?=
 =?us-ascii?Q?1y03bs92jeDtLyFu9My16Ga9ZRQLZtCUE5dYJb0g1+Iw70mdzGwQw/zxDhKy?=
 =?us-ascii?Q?zyEQDl2XNHKA2Cpt49EooPfuuNJeoKSqXVZ4nchhi6/rPDUOx2ZIf5V3aQgd?=
 =?us-ascii?Q?aGKSd+EHkbYfa8zUzLC4KHKWTN4mdm8kfD8N9ZP8SSFq2PPGJKpoQuoNaw4Q?=
 =?us-ascii?Q?8chT8AN1nVjWnEdnEYkRkRlVYizp4jmIONrq8SKPLNrZx1POcbuoOmriiuWq?=
 =?us-ascii?Q?dxnoPLfTe+voVrjAIZC2aguODrFdchB0m6sfWhFAIE2Gm68LKQWkADlwb/ob?=
 =?us-ascii?Q?jKqE1OW5+nis2bZZ7psDpE8G97bxxJE0cPhYKHnh8qXUEH1mT4woPQbySNyF?=
 =?us-ascii?Q?C9zm8yfjJlEzP/9XpTOAwMeXYkKi4AIO4XvJ9oqt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95c0586d-1295-4bda-9656-08db3b605300
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 14:15:10.0828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DfhBiy51x6B5EvOwok6YPTfHcBnAOpZ0aPhjH853HJBZiIBG4S/aV+kIb0UN7JCqgBcCeeFNHq++Nga4xx2uag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4997
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 11:49:51PM +0300, Vladimir Oltean wrote:
> There is a structural problem in switchdev, where the flag bits in
> struct switchdev_notifier_fdb_info (added_by_user, is_local etc) only
> represent a simplified / denatured view of what's in struct
> net_bridge_fdb_entry :: flags (BR_FDB_ADDED_BY_USER, BR_FDB_LOCAL etc).
> Each time we want to pass more information about struct
> net_bridge_fdb_entry :: flags to struct switchdev_notifier_fdb_info
> (here, BR_FDB_STATIC), we find that FDB entries were already notified to
> switchdev with no regard to this flag, and thus, switchdev drivers had
> no indication whether the notified entries were static or not.
> 
> For example, this command:
> 
> ip link add br0 type bridge && ip link set swp0 master br0
> bridge fdb add dev swp0 00:01:02:03:04:05 master dynamic
> 
> causes a struct net_bridge_fdb_entry to be passed to
> br_switchdev_fdb_notify() which has a single flag set:
> BR_FDB_ADDED_BY_USER.
> 
> This is further passed to the switchdev notifier chain, where interested
> drivers have no choice but to assume this is a static FDB entry.
> So currently, all drivers offload it to hardware as such.
> 
> bridge fdb get 00:01:02:03:04:05 dev swp0 master
> 00:01:02:03:04:05 dev swp0 offload master br0
> 
> The software FDB entry expires after the $ageing_time and the bridge
> notifies its deletion as well, so it eventually disappears from hardware
> too.
> 
> This is a problem, because it is actually desirable to start offloading
> "master dynamic" FDB entries correctly, and this is how the current
> incorrect behavior was discovered.
> 
> To see why the current behavior of "here's a static FDB entry when you
> asked for a dynamic one" is incorrect, it is possible to imagine a
> scenario like below, where this decision could lead to packet loss:
> 
> Step 1: management prepares FDB entries like this:
> 
> bridge fdb add dev swp0 ${MAC_A} master dynamic
> bridge fdb add dev swp2 ${MAC_B} master dynamic
> 
>         br0
>       /  |  \
>      /   |   \
>   swp0  swp1  swp2
>    |           |
>    A           B
> 
> Step 2: station A migrates to swp1 (assume that swp0's link doesn't flap
> during that time so that the port isn't flushed, for example station A
> was behind an intermediary switch):
> 
>         br0
>       /  |  \
>      /   |   \
>   swp0  swp1  swp2
>    |     |     |
>          A     B
> 
> Whenever A wants to ping B, its packets will be autonomously forwarded
> by the switch (because ${MAC_B} is known). So the software will never
> see packets from ${MAC_A} as source address, and will never know it
> needs to invalidate the dynamic FDB entry towards swp0. As for the
> hardware FDB entry, that's static, it doesn't move when the station
> roams.
> 
> So when B wants to reply to A's pings, the switch will forward those
> replies to swp0 until the software bridge ages out its dynamic entry,
> and that can cause connectivity loss for up to 5 minutes after roaming.
> 
> With a correctly offloaded dynamic FDB entry, the switch would update
> its entry for ${MAC_A} to be towards swp1 as soon as it sees packets
> from it (no need for CPU intervention).
> 
> Looking at tools/testing/selftests/net/forwarding/, there is no valid
> use of the "bridge fdb add ... master dynamic" command there, so I am
> fairly confident that no one used to rely on this behavior.

Yes, but there are tests that use "extern_learn". If you post a v2 that
takes "BR_FDB_ADDED_BY_EXT_LEARN" into account, then I can ask Petr to
run it through our regression and report back (not sure we will make it
to this week's PR though).

Thanks

> 
> With the change in place, these FDB entries are no longer offloaded:
> 
> bridge fdb get 00:01:02:03:04:05 dev swp0 master
> 00:01:02:03:04:05 dev swp0 master br0
> 
> and this also constitutes a better way (assuming a backport to stable
> kernels) for user space to determine whether the switchdev driver did
> actually act upon the dynamic FDB entry or not.
> 
> Fixes: 6b26b51b1d13 ("net: bridge: Add support for notifying devices about FDB add/del")
> Link: https://lore.kernel.org/netdev/20230327115206.jk5q5l753aoelwus@skbuf/
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_switchdev.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index de18e9c1d7a7..0ec3d5e5e77d 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -148,6 +148,10 @@ br_switchdev_fdb_notify(struct net_bridge *br,
>  	if (test_bit(BR_FDB_LOCKED, &fdb->flags))
>  		return;
>  
> +	if (test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags) &&
> +	    !test_bit(BR_FDB_STATIC, &fdb->flags))
> +		return;
> +
>  	br_switchdev_fdb_populate(br, &item, fdb, NULL);
>  
>  	switch (type) {
> -- 
> 2.34.1
> 
