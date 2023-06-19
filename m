Return-Path: <netdev+bounces-12023-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B37F735B30
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:34:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8887828103D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A686212B8B;
	Mon, 19 Jun 2023 15:34:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DC0D2F8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 15:34:51 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA78CC
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:34:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHUiKAp8g6o6Cby+bZ1BEAmT7IUorGbzRg/i+RUYMWpeJatCmK4H93eUMcik/vCqFCg3A1aA2lKvRl/rnTEan8jdwx+yrgMXIoyXdk3WqBG7prHcKjpv0jd46/CzALj9r756HbvcXwLTn2XBmWkweSNnuIt2zznMP22SAERMB7chBoVbgyJCNUMkbtzV1WjNvbRK9u9+MNtUHJwzb1ShXtxJ5iIqglK5136IMSCjecT0jBmBDYEyunf+nHP6B/q/NXm+cCZULjA+fojmvYSi9PFIXmY6yu0tDKniAqQitKZRzJa66zwQlZattAl42RioQ5kRC36ANTyV813kAOFOGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nHQRAfrOs8cAqcloifhRR4ZwCmIWn3ddM4tCJBqgv0U=;
 b=K8Nm3KoMKvW7UwlOB6WFN5CgLQjZLEAIdD+BQaQJY5FixsPesQTWr+deK9AbvYRlDZwYgCJksi00dICKDJqg+HZxoIux/udLUNpmQe0bW2pU8C87boZ8smIoZT29oI01yc5XHbraGex2idqlQr5p7uNVmsDvYheYiLp6LpCpS1IHO1W4o/srk2kdiefo6c4ata7rh8iMD6ca89yj10mnJyvujVLpaUmbPoulTJUlDeKW9ek3TLbsqKU2ZXOvKKSwGbwUErkvtLBaf1k4hVEIlPK2cCj5jJEPQ9Ko1v1itgGZ2Hro1MjJ7M0v4vLpmVLkHycJwSNt/q9hp2OgVJLr1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nHQRAfrOs8cAqcloifhRR4ZwCmIWn3ddM4tCJBqgv0U=;
 b=si6uWvDp7Baxk0/T0qL8l+wqebMOkGbToI9yPeRvuC3iSmWBi6qDiMx7erUuz6SgkOBuXST1WKJUDHzZyQehYKvPufugd5PTmTDZXSNM4874FyVsgdyuDAb/dP+I/wXbx7u2RhGY3s0gkj91J6PuRT1NpYe703IWKJsoEgUIhxxco2Q9G/GWzP+Sf6lIOTVO5u/uGBQxA1oIap1P/E642ox6ltZp30LW1KCiOpzlrd7fjCvY73h5OGFShvBLCPg6HMOClb8vRLlKnIr4n+CuqDRyCzzD/3po8yjO1vuQHhMVkj0XrF0x2wACjGS5ZU2BjC1O575LibE329yYMGagcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH3PR12MB7740.namprd12.prod.outlook.com (2603:10b6:610:145::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Mon, 19 Jun
 2023 15:34:46 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 15:34:46 +0000
Date: Mon, 19 Jun 2023 18:34:39 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Johannes Nixdorf <jnixdorf-oss@avm.de>
Cc: bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
	David Ahern <dsahern@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next v2 2/3] bridge: Add a limit on learned FDB
 entries
Message-ID: <ZJB1j0Vk4g0yW3dc@shredder>
References: <20230619071444.14625-1-jnixdorf-oss@avm.de>
 <20230619071444.14625-3-jnixdorf-oss@avm.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230619071444.14625-3-jnixdorf-oss@avm.de>
X-ClientProxiedBy: LO6P123CA0050.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::6) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH3PR12MB7740:EE_
X-MS-Office365-Filtering-Correlation-Id: ea6b2ae4-5000-4fbb-2d93-08db70dab5b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fZ8wchNwf3VDR7m9aeKjNq0xbVRnoWj/UbXPtVinK0oI9rd/x+bpObEtMlYVEJ2stSwZdLL3uHPnZL8hXOWix0QjOaQbVymogP1XXnEqFH0c/tUhe0Lwp4BIeSbN4SkEZm8Y5R75Ejz5oJ/ZZJ1xzFVuiDE+TLvVrHfFQvLLvmBniaiwZBx5tKhX5Wk0vAYKCvTiXAOFY7qGwzu9KqqBRyuATgA6VuRRWGHRsuDCz5Y/rF/9C4pIp82hic9PU4Yd6tYUpbk3XcJgoU6avZsnITzhZQb2WQGz8aiyoo+pyAsNkFUo5YFnf2pqy+rF2KcxaRdjeXjYlgT4ObVuqcHbqGaBKvpKx0awq8wHBE9hfE5luBk54Zc9obF6VT5sxYKfRc3U0FzoLll0aWoRxy91EQz1sc5vI7PH2IiJk0Jw71ynzvmU6fO4GhMg8IG0f4yusQnZ3ElcSDjizKaGmGHiliho38fDhHiJ6tDLv5de82KQHkFKnz3LOdFEq7RT2UKxea1Ki8WOGiUkbyzQ7FtQc52mZDVNLVrEPQDjZPIGx0oBm1dWHbFfqHoKAXbQEgQyx618KEm7a5zmpz5svByXz+lOYf3ksaxQjIRh14e29us=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199021)(83380400001)(66574015)(186003)(6512007)(26005)(6506007)(9686003)(107886003)(33716001)(54906003)(38100700002)(478600001)(6666004)(966005)(6486002)(86362001)(8676002)(41300700001)(66476007)(316002)(4326008)(66946007)(66556008)(5660300002)(8936002)(6916009)(30864003)(2906002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnJwdVdDOWE2SUpJZk9iWXloS3NTUndLQ2RCWGMzQXkvYmlwZENqUXpRYmt4?=
 =?utf-8?B?UGJUS3BHVDlhVHgrRGhiQU5xQkVFRjhFNldFZUIzMVhUWGhEN3NxMndyUFRr?=
 =?utf-8?B?Vzl5M2FabVh3Q2xOSm90VlA0TUZCTHBid0dvQncvbEVFZHYzbmNiSG9tOUlV?=
 =?utf-8?B?eTJFVUI4VkJUemt0T2hKaFFKVmxrWk4yUUlSaEpwblV6enpieDRIZTRlRkpm?=
 =?utf-8?B?dzZFanNZekozSWNtME9ialdqMXVkVEhoUk54emxpaHE0ZTFmMFpCMDhlSHNh?=
 =?utf-8?B?T0xsY0RGQlhpVWRGYzNQSHRjVVhRSk15QlBhZkQwMG42Y0EzQTFMN2lJei9L?=
 =?utf-8?B?cEJxRjZxZXdmdGJocWc2QjI5QXRTQXUrVVEzQjZMRy9mNnpZdUwwVlZnQzY1?=
 =?utf-8?B?Ry9UY0RtZ3luNVJwREtXOWp2bVYwZ20rR0s0OVZYeGsvdXVVeWpEQTRkeUR5?=
 =?utf-8?B?ZEEvZ2Y4YmRjUXZrNlY4ek9EQUZYQjE1V1RkZS9TYkQ3TUV2NGZ2VldqSW9y?=
 =?utf-8?B?NkFqU0oxNXBXeVZ0RG53OFpwZytndGRWYnFKZ0VJRFJvNC9DRnIyaUZTRy9J?=
 =?utf-8?B?a0dzR2VkWkRCK3owMXNlNFgxL2FML1haaHNXUFhwN2x5cENKT2JoWjhoa1lr?=
 =?utf-8?B?RSs1ZE14VldCNVlXWGJsRVVlMzdXeVc5ZGlCdEdzcVJOaUM5bWxOZU5rNWlC?=
 =?utf-8?B?YkxDZGlZUC85ZmduTHlXVWk4UWtheWxkTEhYcUdHZzI5bmJsV3FqTVVvNXBM?=
 =?utf-8?B?UEIzUkUrU2h1OUk4S0lZbkhrMXcrbjVpRmVnY09qdDBFVnp6S1MzUDQ3Smdw?=
 =?utf-8?B?QWhDaWZDN0d3YjlSME5MaU5CZDE3Y2NFT1J6cDNXYUhDR1loaGlWcjRxOUJZ?=
 =?utf-8?B?MFVpUSt3YUhMOGR0SHRsVFVvK3pKVnRpZStYWkZYbHQzb2JxaXQ5TXdmaGFE?=
 =?utf-8?B?d1E3SDN3OGsxQ3BqOFFGTEI5MEhlUGppWnlGb0MvOFAxL1Z1eHFFd3BUUjZt?=
 =?utf-8?B?TTcycHNoMXU5NnRnNXlGcFpMV0ppRWFsNGJQVVpmekVOSENBQ1hLY2ZwRGxq?=
 =?utf-8?B?RkgyNkRzNUx2M21IVVE1YjFiTThCL0RJWTJvR3JBNDRLaElXQk0waDQ3blZZ?=
 =?utf-8?B?SjRDY0NoNDFmUFprSWVJVGJEbnNwYnpVNTVNdkYvK2U1cGhsdDRwVm1VMnRx?=
 =?utf-8?B?U09naGhPL1c5WTZ6bkNGaGI4Z3NaM0NBckdQMC9KTzFSSngyUlpsR1VaSk1R?=
 =?utf-8?B?QU9lTFZWSEN1WkN0Z2Z5a1Nmanp0UTdXRGpnY1ZTREVLdGt2WXJhTTA4dmJm?=
 =?utf-8?B?MU9JcEs3RHVNWklzK05YWDhmVjdpR20raXpKRE1FYmVpOEt4c1F6UzNnZHVP?=
 =?utf-8?B?OEJKcUZUVG5YYnBJaE5jMUZNNGtNbzBDdlBHZ0NzM2dKQmt2KzF4TjdmNmZL?=
 =?utf-8?B?dGxsM3RiQ28ydlREUEdGdWxRSlpJN3Rndnp2TERzNTNLNXM3YW5xNlBEdWhl?=
 =?utf-8?B?L003bnRTeHZ2SWtvVkVEc2gwdXRybmRDcVZWeW9VLzNqdVJiTXBBdjE5Ulgx?=
 =?utf-8?B?azFFdHRoUnVDd1hpaEswcUg5QVV5czZMdS9XZlJnZWR2ZW14SUlHYWJaeFdu?=
 =?utf-8?B?a2xhb01jdjErMXVPazRJTnFpQUltaDh3c0tRanhubjZRNmZVaGs0MFpVWThq?=
 =?utf-8?B?RTJvQ2h5REdCQ09qYWRjcm9sR2FsZ0NIcmdMdkxiN1FvVTJ3WXMwclo1KzJj?=
 =?utf-8?B?ODlRU2VCcWdlT0krSVNEYklYeGxpWGNZM0hGREdWMFo3a0swNTJPTWU5Q2FS?=
 =?utf-8?B?WHRlai9oT2dJUGFvdG9oUFQ5Vjl3VXByU2Z3UlpIeUlaNHoxYlVrR3p5STFo?=
 =?utf-8?B?bGFVa0FHMmh0RmhyZmdlUU11eUF4VWZhR1h4T0VFWTk4UlZMdFhaSzFneGQ4?=
 =?utf-8?B?QzQvL2tOSklOdEJITEdzUUVKOEVobHFRcDE4Nkl6OEh4aHE5N2YrNFBGaisv?=
 =?utf-8?B?WnoreFhUQjlHOHdDeEgyelZQYTlmQ0p2blkrL0hIUE5EZHdIaHdHbWhvVWxT?=
 =?utf-8?B?bFlzc1ZsdWRmT1VaMUpnU2s5R1pUSTZJditjUE51S3g2QitiOUpOTkMwaGEx?=
 =?utf-8?Q?CDH1jVFMxj27AWNSD9QLfA+yq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea6b2ae4-5000-4fbb-2d93-08db70dab5b4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 15:34:45.8922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UMrYU8cIdiorCVRxdCY8bDQl1Ewy3ZcbyKXlUqFyZiufC9zOQZyQ7vXwX769nU7Qkm/zcb+xGF1JV+Uz87v1jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7740
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 09:14:42AM +0200, Johannes Nixdorf wrote:
> A malicious actor behind one bridge port may spam the kernel with packets
> with a random source MAC address, each of which will create an FDB entry,
> each of which is a dynamic allocation in the kernel.
> 
> There are roughly 2^48 different MAC addresses, further limited by the
> rhashtable they are stored in to 2^31. Each entry is of the type struct
> net_bridge_fdb_entry, which is currently 128 bytes big. This means the
> maximum amount of memory allocated for FDB entries is 2^31 * 128B =
> 256GiB, which is too much for most computers.
> 
> Mitigate this by adding a bridge netlink setting
> IFLA_BR_FDB_MAX_LEARNED_ENTRIES, which, if nonzero, limits the amount
> of learned entries to a user specified maximum.
> 
> For backwards compatibility the default setting of 0 disables the limit.
> 
> User-added entries by netlink or from bridge or bridge port addresses
> are never blocked and do not count towards that limit.
> 
> All changes to fdb_n_entries are under br->hash_lock, which means we do
> not need additional locking. The call paths are (✓ denotes that
> br->hash_lock is taken around the next call):
> 
>  - fdb_delete <-+- fdb_delete_local <-+- br_fdb_changeaddr ✓
>                 |                     +- br_fdb_change_mac_address ✓
>                 |                     +- br_fdb_delete_by_port ✓
>                 +- br_fdb_find_delete_local ✓
>                 +- fdb_add_local <-+- br_fdb_changeaddr ✓
>                 |                  +- br_fdb_change_mac_address ✓
>                 |                  +- br_fdb_add_local ✓
>                 +- br_fdb_cleanup ✓
>                 +- br_fdb_flush ✓
>                 +- br_fdb_delete_by_port ✓
>                 +- fdb_delete_by_addr_and_port <--- __br_fdb_delete ✓
>                 +- br_fdb_external_learn_del ✓
>  - fdb_create <-+- fdb_add_local <-+- br_fdb_changeaddr ✓
>                 |                  +- br_fdb_change_mac_address ✓
>                 |                  +- br_fdb_add_local ✓
>                 +- br_fdb_update ✓
>                 +- fdb_add_entry <--- __br_fdb_add ✓
>                 +- br_fdb_external_learn_add ✓
> 
> The flags that imply an entry does not come from learning
> (BR_FDB_NOT_LEARNED_MASK) are now only set or cleared under br->hash_lock
> as well, and when the boolean value of (fdb->flags &
> BR_FDB_NOT_LEARNED_MASK) changes the accounting is updated.
> 
> This introduces one additional locked update in br_fdb_update if
> BR_FDB_ADDED_BY_USER was set. This is only the case when creating a new
> entry via netlink, and never in the packet handling fast path.
> 
> Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
> 
> ---
> 
> Changes since v1:
>  - Do not initialize fdb_*_entries to 0. (from review)
>  - Do not skip decrementing on 0. (from review)
>  - Moved the counters to a conditional hole in struct net_bridge to
>    avoid growing the struct. (from review, it still grows the struct as
>    there are 2 32-bit values)
>  - Add IFLA_BR_FDB_CUR_LEARNED_ENTRIES (from review)
>  - Fix br_get_size()
>  - Only limit learned entries, rename to
>    *_(CUR|MAX)_LEARNED_ENTRIES. (from review)
> 
> Obsolete v1 review comments:
>  - Return better errors to users: Due to limiting the limit to
>    automatically created entries, netlink fdb add requests and changing
>    bridge ports are never rejected, so they do not yet need a more
>    friendly error returned.
> 
>  include/uapi/linux/if_link.h |  2 ++
>  net/bridge/br_fdb.c          | 67 +++++++++++++++++++++++++++++++++---
>  net/bridge/br_netlink.c      | 13 ++++++-
>  net/bridge/br_private.h      |  6 ++++

To minimize the number of changes per patch and make review easier, try
to first maintain the count and the maximum and then in a separate patch
expose them via netlink. See b57e8d870d52 and a1aee20d5db2, for example.
Merge commit is cb3086cee656.

>  4 files changed, 83 insertions(+), 5 deletions(-)
> 
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 4ac1000b0ef2..165b9014379b 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -510,6 +510,8 @@ enum {
>  	IFLA_BR_VLAN_STATS_PER_PORT,
>  	IFLA_BR_MULTI_BOOLOPT,
>  	IFLA_BR_MCAST_QUERIER_STATE,
> +	IFLA_BR_FDB_CUR_LEARNED_ENTRIES,
> +	IFLA_BR_FDB_MAX_LEARNED_ENTRIES,
>  	__IFLA_BR_MAX,
>  };
>  
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index ac1dc8723b9c..bc61d1fd5fcf 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -301,6 +301,38 @@ static void fdb_add_hw_addr(struct net_bridge *br, const unsigned char *addr)
>  	}
>  }
>  
> +/* Set a FDB flag that implies the entry was not learned, and account
> + * for changes in the learned status.
> + */
> +static void __fdb_set_flag_not_learned(struct net_bridge *br,
> +				       struct net_bridge_fdb_entry *fdb,
> +				       long nr)
> +{
> +	WARN_ON_ONCE(!(BIT(nr) & BR_FDB_NOT_LEARNED_MASK));
> +
> +	/* learned before, but we set a flag that implies it's manually added */
> +	if (!(fdb->flags & BR_FDB_NOT_LEARNED_MASK))
> +		br->fdb_cur_learned_entries--;
> +	set_bit(nr, &fdb->flags);
> +}
> +
> +/* Set a FDB flag that implies the entry was not learned, and account
> + * for changes in the learned status.
> + *
> + * This function takes a lock, so ensure it is not called in the fast
> + * path.
> + */
> +static void fdb_set_flag_not_learned(struct net_bridge *br,
> +				     struct net_bridge_fdb_entry *fdb,
> +				     long nr)
> +{
> +	spin_lock_bh(&br->hash_lock);
> +
> +	__fdb_set_flag_not_learned(br, fdb, nr);
> +
> +	spin_unlock_bh(&br->hash_lock);
> +}
> +
>  /* When a static FDB entry is deleted, the HW address from that entry is
>   * also removed from the bridge private HW address list and updates all
>   * the ports with needed information.
> @@ -321,6 +353,8 @@ static void fdb_del_hw_addr(struct net_bridge *br, const unsigned char *addr)
>  static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>  		       bool swdev_notify)
>  {
> +	bool learned = !(f->flags & BR_FDB_NOT_LEARNED_MASK);
> +
>  	trace_fdb_delete(br, f);
>  
>  	if (test_bit(BR_FDB_STATIC, &f->flags))
> @@ -329,11 +363,16 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>  	hlist_del_init_rcu(&f->fdb_node);
>  	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
>  			       br_fdb_rht_params);
> +	br->fdb_cur_learned_entries -= learned;
>  	fdb_notify(br, f, RTM_DELNEIGH, swdev_notify);
>  	call_rcu(&f->rcu, fdb_rcu_free);
>  }
>  
> -/* Delete a local entry if no other port had the same address. */
> +/* Delete a local entry if no other port had the same address.
> + *
> + * This function should only be called on entries with BR_FDB_LOCAL set,
> + * so clear_bit never removes the last bit in BR_FDB_NOT_LEARNED_MASK.
> + */
>  static void fdb_delete_local(struct net_bridge *br,
>  			     const struct net_bridge_port *p,
>  			     struct net_bridge_fdb_entry *f)
> @@ -390,6 +429,11 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
>  {
>  	struct net_bridge_fdb_entry *fdb;
>  	int err;
> +	bool learned = !(flags & BR_FDB_NOT_LEARNED_MASK);

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#local-variable-ordering-reverse-xmas-tree-rcs

> +
> +	if (unlikely(learned && br->fdb_max_learned_entries &&
> +		     br->fdb_cur_learned_entries >= br->fdb_max_learned_entries))

This function is not run with RTNL held and so 'fdb_max_learned_entries'
can be updated concurrently from user space. You will need READ_ONCE() /
WRITE_ONCE() to silence KCSAN.

> +		return NULL;
>  
>  	fdb = kmem_cache_alloc(br_fdb_cache, GFP_ATOMIC);
>  	if (!fdb)
> @@ -409,6 +453,8 @@ static struct net_bridge_fdb_entry *fdb_create(struct net_bridge *br,
>  
>  	hlist_add_head_rcu(&fdb->fdb_node, &br->fdb_list);
>  
> +	br->fdb_cur_learned_entries += learned;

Don't remember seeing bool being added to a u32...

> +
>  	return fdb;
>  }
>  
> @@ -894,7 +940,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
>  			}
>  
>  			if (unlikely(test_bit(BR_FDB_ADDED_BY_USER, &flags)))
> -				set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
> +				fdb_set_flag_not_learned(br, fdb, BR_FDB_ADDED_BY_USER);
>  			if (unlikely(fdb_modified)) {
>  				trace_br_fdb_update(br, source, addr, vid, flags);
>  				fdb_notify(br, fdb, RTM_NEWNEIGH, true);
> @@ -1070,6 +1116,8 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
>  			modified = true;
>  		}
>  
> +		if (!(fdb->flags & BR_FDB_NOT_LEARNED_MASK))
> +			br->fdb_cur_learned_entries--;
>  		set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
>  	}
>  
> @@ -1440,10 +1488,10 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
>  		}
>  
>  		if (swdev_notify)
> -			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
> +			__fdb_set_flag_not_learned(br, fdb, BR_FDB_ADDED_BY_USER);
>  
>  		if (!p)
> -			set_bit(BR_FDB_LOCAL, &fdb->flags);
> +			__fdb_set_flag_not_learned(br, fdb, BR_FDB_LOCAL);
>  
>  		if (modified)
>  			fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
> @@ -1508,3 +1556,14 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
>  	spin_unlock_bh(&p->br->hash_lock);
>  }
>  EXPORT_SYMBOL_GPL(br_fdb_clear_offload);
> +
> +u32 br_fdb_get_cur_learned_entries(struct net_bridge *br)
> +{
> +	u32 ret;
> +
> +	spin_lock_bh(&br->hash_lock);
> +	ret = br->fdb_cur_learned_entries;

I believe that for MDB Nik asked not to take a spin lock for each dump
and we used READ_ONCE() / WRITE_ONCE() instead.

> +	spin_unlock_bh(&br->hash_lock);
> +
> +	return ret;
> +}
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 05c5863d2e20..954c468d52ec 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -1527,6 +1527,12 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
>  			return err;
>  	}
>  
> +	if (data[IFLA_BR_FDB_MAX_LEARNED_ENTRIES]) {

Please add this attribute to 'br_policy' and in a separate patch convert
the policy to use 'strict_start_type' so that future submissions will be
forced to update the policy. See c00041cf1cb82 for example.

I suggest writing a selftest to verify the expected behavior and to make
sure this feature does not regress. There are a lot of examples under
tools/testing/selftests/net/ and tools/testing/selftests/net/forwarding
in particular. You can post another version before writing a test, but
mark it as RFC so that it doesn't get applied by mistake.

Thanks

> +		u32 val = nla_get_u32(data[IFLA_BR_FDB_MAX_LEARNED_ENTRIES]);
> +
> +		br->fdb_max_learned_entries = val;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1581,6 +1587,8 @@ static size_t br_get_size(const struct net_device *brdev)
>  	       nla_total_size_64bit(sizeof(u64)) + /* IFLA_BR_TOPOLOGY_CHANGE_TIMER */
>  	       nla_total_size_64bit(sizeof(u64)) + /* IFLA_BR_GC_TIMER */
>  	       nla_total_size(ETH_ALEN) +       /* IFLA_BR_GROUP_ADDR */
> +	       nla_total_size(sizeof(u32)) +    /* IFLA_BR_FDB_CUR_LEARNED_ENTRIES */
> +	       nla_total_size(sizeof(u32)) +    /* IFLA_BR_FDB_MAX_LEARNED_ENTRIES */
>  #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
>  	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_MCAST_ROUTER */
>  	       nla_total_size(sizeof(u8)) +     /* IFLA_BR_MCAST_SNOOPING */
> @@ -1620,6 +1628,7 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
>  	u32 stp_enabled = br->stp_enabled;
>  	u16 priority = (br->bridge_id.prio[0] << 8) | br->bridge_id.prio[1];
>  	u8 vlan_enabled = br_vlan_enabled(br->dev);
> +	u32 fdb_cur_learned_entries = br_fdb_get_cur_learned_entries(br);
>  	struct br_boolopt_multi bm;
>  	u64 clockval;
>  
> @@ -1656,7 +1665,9 @@ static int br_fill_info(struct sk_buff *skb, const struct net_device *brdev)
>  	    nla_put_u8(skb, IFLA_BR_TOPOLOGY_CHANGE_DETECTED,
>  		       br->topology_change_detected) ||
>  	    nla_put(skb, IFLA_BR_GROUP_ADDR, ETH_ALEN, br->group_addr) ||
> -	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm))
> +	    nla_put(skb, IFLA_BR_MULTI_BOOLOPT, sizeof(bm), &bm) ||
> +	    nla_put_u32(skb, IFLA_BR_FDB_CUR_LEARNED_ENTRIES, fdb_cur_learned_entries) ||
> +	    nla_put_u32(skb, IFLA_BR_FDB_MAX_LEARNED_ENTRIES, br->fdb_max_learned_entries))
>  		return -EMSGSIZE;
>  
>  #ifdef CONFIG_BRIDGE_VLAN_FILTERING
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 2119729ded2b..df079191479e 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -275,6 +275,8 @@ enum {
>  	BR_FDB_LOCKED,
>  };
>  
> +#define BR_FDB_NOT_LEARNED_MASK (BIT(BR_FDB_LOCAL) | BIT(BR_FDB_ADDED_BY_USER))
> +
>  struct net_bridge_fdb_key {
>  	mac_addr addr;
>  	u16 vlan_id;
> @@ -553,6 +555,9 @@ struct net_bridge {
>  	struct kobject			*ifobj;
>  	u32				auto_cnt;
>  
> +	u32				fdb_max_learned_entries;
> +	u32				fdb_cur_learned_entries;
> +
>  #ifdef CONFIG_NET_SWITCHDEV
>  	/* Counter used to make sure that hardware domains get unique
>  	 * identifiers in case a bridge spans multiple switchdev instances.
> @@ -838,6 +843,7 @@ int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
>  			      bool swdev_notify);
>  void br_fdb_offloaded_set(struct net_bridge *br, struct net_bridge_port *p,
>  			  const unsigned char *addr, u16 vid, bool offloaded);
> +u32 br_fdb_get_cur_learned_entries(struct net_bridge *br);
>  
>  /* br_forward.c */
>  enum br_pkt_type {
> -- 
> 2.40.1
> 

