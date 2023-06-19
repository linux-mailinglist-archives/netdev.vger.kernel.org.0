Return-Path: <netdev+bounces-11989-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23B1C7359C5
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:37:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E28E1C20B05
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF136D2F2;
	Mon, 19 Jun 2023 14:37:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAD97477
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:37:51 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EDC188
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:37:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhSiJ1uN/HvLei5ypDvmL39Vl0H/U4z7hpmA2vw5dDpCbL0tqSJa0xnZ/uHNtc7JE3oqHwFxI+1U40uvCEv/6oB/3kpkB/93JKfXe91gEXFuWLG1NaVkku7fY7xRDiE22VLkHeHOeeW1rjEym9QuIdDSRBFqkngpdeu7zPsTrRtcmYwbXv3p71Yy9TYP5uFMkmWcA+/qf9h0Cd7pgq/GjTWgD+LGWXFeN+USs9SNe+uaSfq092zDin9h6AiE8ySSU0u0uVXqqVuBuBu5ArO9SV7TLt1866FxyiCJtk6ToERiiMxdZmZwfbgaRKlLNDqnbI78bUOV7ayLyPn9lq9+rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUtGVrnK9FsAzdmXjtx0qrYPtWLTfSjFIgh8KDkruBs=;
 b=aUyVgP1bbVywng6R0Ls72fXbJYnSxbBPm4KLBesTzLY2iqp1NsqFkWBxlXa50w/X86r8k7bEC2YjryMLzLEXvJQs0b2I1LFBKB/226M7YcmLZCjXHIWfIrvz5wsfRubDxjxsm4tsvUchUegHb9/Y0Js5bZrWSFUCmPY1+nLXJJa+VpuMpsy4Irkc3zzKko2ArjJ24Hz4QEbDskIG8z1nRnMMgZRMUuKhhO5WHmmWpxyZ9G21N71N7h6yY5sMmG30iLMJvtM+H9OIE2GdOY1ASpkMltNBAFR0qE/3HH7ADBx6VdZvxc++kqvITUYOCDGov6JWkWUMKV3cC1k+8T7ljA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUtGVrnK9FsAzdmXjtx0qrYPtWLTfSjFIgh8KDkruBs=;
 b=rEXafuEXJJlWMJrPOFQNWtlmafikAjYWtlUyyHrC2lFePoVbEIHHUSfwtS5Fs45jap9JnusJZ5se4QbOJ0nx502yhdgWhjiiYwoMRAEfQ67d7nf2CBOvZGLiFwz5EnHfP9eqIJhKiFbaagwltgcqwmEo8K9ruqZoKJGz1r+x0s6JbgQYzReaIr/sNFolaVlC3okv548TGcjg67CGC5cAriuDSz0qibuFT5DZ08HZhgVpO4hP4WBjNDVeZZF6johX8o4ZLERnxAwAtNV9nOdyzjTPY1A5fZHXihDuZAlyZJkY5t4aELtnWPq0EyVwU06LMDiZFcXw7dGVm2pnLgEt4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB5515.namprd12.prod.outlook.com (2603:10b6:610:34::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 14:37:47 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 14:37:47 +0000
Date: Mon, 19 Jun 2023 17:37:41 +0300
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
Subject: Re: [PATCH iproute2-next 1/1] iplink: bridge: Add support for bridge
 FDB learning limits
Message-ID: <ZJBoNYWkE7ts8MHF@shredder>
References: <20230619071444.14625-1-jnixdorf-oss@avm.de>
 <20230619071444.14625-5-jnixdorf-oss@avm.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619071444.14625-5-jnixdorf-oss@avm.de>
X-ClientProxiedBy: LO4P302CA0044.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::10) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH2PR12MB5515:EE_
X-MS-Office365-Filtering-Correlation-Id: 846187e8-95df-4e31-1389-08db70d2c012
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JVrmAbw/DMSwBM7NtZppRVO6gdCI59uGerrGcVifUuPnkIuI1KJ6M2XRhXmQHcYn09/dAGweMKei5BfndzFPoZtaoxXqhPnfUmnO0zb9A/5m1HwMAkAl559v906mNzwGpGWBS1n6ohL/NclBY39BfIHbpk6iSRP+p5o2HrNMNc2/hiBFRjl+IXnmeH4jDLuQiFFJe7niWFNTL+iKXm7ZqtYn2SbzCfmZtJP3POy17tkcRMxf2F4GCixyIH5U2U2GvGO+ka7zJn8wfCLJIsz1mJdF0g+eUEEsdnTQSqQccjf2xDO1p4Da4r7E/HyuflR9wtQKqiuswiclWom586oBqKsCxy9VukgHwYRP0JEUc6DKXmwdetfLDcHmlEzw6Xv+msVJrxOYfRhRdf6gyRw5qvZjcagihj/qnAyVFr/cN7xhu52GbdjM1ICNyF+qB4unA7OduUmRyZQmCS0uFlGpFYSZM5LrPFQK8VmirslvLAQ5+v772anYqwIZ+lMV1cQ1dfTKMK+yHR26ZZ2flKCMrOqQJOpSQQwOlBqVqNexdUOAV0yK1junU8XnACW3fkNqOEeDvoiDcxiP924/n9AR+IsFyxWyfqSYc9OB5i64w+g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(376002)(346002)(366004)(39860400002)(396003)(136003)(451199021)(186003)(478600001)(966005)(6666004)(6486002)(9686003)(86362001)(26005)(6506007)(6512007)(54906003)(107886003)(38100700002)(316002)(83380400001)(66946007)(66556008)(6916009)(66476007)(4326008)(8676002)(8936002)(7416002)(5660300002)(2906002)(41300700001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Lc8YPq6tdvi4BF0SWzNiWGCCL8Wtq+GghgCHb6cpUyYphd3BKipirtl5Wg/d?=
 =?us-ascii?Q?8Yv5xgEj4zmqsquuFdKUNIBc34mHgRRJ02x7FWvJ6eUNtnJwOuf+Jk8EKJsw?=
 =?us-ascii?Q?2gtgmtUzUj7ul/sBDI4XbDwzRYXvYJRnkzWG/Vz48jgm/7wK/ppvbUeEYm0t?=
 =?us-ascii?Q?/Qyh7pMBkLWKVKnNNqt+HOn7v/69ICIwj93GwSSOnpKuf1+yoK3A42Jredk8?=
 =?us-ascii?Q?XG/pA87bdKhvL3O9qQDKhCVqgXK3prmk8laWHaDt3JzysIVtX5AKCTkxNBam?=
 =?us-ascii?Q?ApbG6euuwFuh9bdbZYk1jKZwL0GIIULxCp8FaS98HOyCzFU0fpYJ71GI4teg?=
 =?us-ascii?Q?8tmzuGaSqBicc8ZtA1Y/l++H4onCOWjcv2JhMeseVfyWCeMpFHkpQAZ9lrQK?=
 =?us-ascii?Q?Xj6B2lWxsPrlnsjrUrDpCQaKoqw3dpOtdaK9I7i5H2EzOKThhiF1BQR83XGt?=
 =?us-ascii?Q?fujVOgzmUjFu4THPyitx6t49J6yZw/ZK4wds2wn8chOeH+F0ZkJs2fC2Oa6z?=
 =?us-ascii?Q?wV+2dEDNne5zGKAfTOtaqHPPzfPkrJjAcKNXqXheGz2PaVopZrPzE4yqk3/f?=
 =?us-ascii?Q?Ox/of0ZYyJpeVj5iLCLIwUDYgD/WguVOSPd+YrtrkSo8gcEMYjf01ZqLnU5U?=
 =?us-ascii?Q?FFa2XUzg3HeBCkh1DWo7wPOZAkqqBHpg8sHoFErFWZd7W5KIDPID4eJ1NDzN?=
 =?us-ascii?Q?jvt1eDxICCy0uAIkVnfMjjI11IcIN2dfHJiLRQZqYHr5gGTui4RjxJQJneHR?=
 =?us-ascii?Q?/+Dphvqq6ijHlqVQTdrzOM/cGeWEviZdTGVRzqH+2JCqC1b9qI2JB8Ox7h3D?=
 =?us-ascii?Q?x4ESQKh2UIikBKbPXN2vRlAcn5N6jHgsFIkViU53hObMOTGtbuYaznM6slsA?=
 =?us-ascii?Q?l/ual/bK+OA3jj43/zPvXLpRw+5sLRFRzALFv1Bs1MeKExxXfSK27udwyCc2?=
 =?us-ascii?Q?uaSMLMpZeSRWEjguBFJSmCAYVLoIyVwAzQWu8sGudMpFN8q3uy4MgQmacHaV?=
 =?us-ascii?Q?nam3xTZEr3fN+jvVc8DOH7MsK6aH3VoTfOhhTDxYLzpD7Y8vDxWQjriGdFhC?=
 =?us-ascii?Q?CMflog6cLKw8FzVomNgIl0S5wq7DzqNXqPeTyFi3Hq05pZi8Xoy0OAFMmGX3?=
 =?us-ascii?Q?4xlqKHILEAZ0Y/Rwgyv/FuhU5k9YZeu9RkZd1AvjTKwlfz5icSj2rE8XVBIo?=
 =?us-ascii?Q?YA/qqH/+4ceG0dmb0SnqzHNDN2FdG+VdOzHVUi5C9H3qT8OBISl+mTgpB/wP?=
 =?us-ascii?Q?e29zLOuKkFAT4QPz+ARgccnbimYugl1HCM8HA1OVGC8r+98LCgesmQJlguqR?=
 =?us-ascii?Q?N26jhdj22z05U/YLLSLTjrtWM35AVp6fJksNURp2ADH2TbwDK5L8zNAS3hic?=
 =?us-ascii?Q?wKpczNkssM+msE9m2V440crngAO7DdNCGmmCpHdNFU59oJ1LXq7wceH4lziH?=
 =?us-ascii?Q?zrAsZTsfyz5Y+hSndn6ci0x/YNmxygXCrVwuSQ7Sc5V3cEqiwLid4fMxvmXX?=
 =?us-ascii?Q?2Wfi8NNE0F68nBRtV9Vki0o8PRAnAbIcx+vG5obE4a7aAGyplMQ10iH8USaX?=
 =?us-ascii?Q?ZDhjoOdMTjbwQowOICo8fZ8/a0Birqt0AfkDWhVx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 846187e8-95df-4e31-1389-08db70d2c012
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 14:37:47.2446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BeGUHIySx1Wc5MUH7akUvqK/w7qCfhZUyxlR+jX4wtURFz/imfgTMTU/SN7uIyn3mei+D86gBonuYkuH5HzroQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5515
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Please see the following link regarding posting of iproute2 patches:

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#co-posting-changes-to-user-space-components

On Mon, Jun 19, 2023 at 09:14:44AM +0200, Johannes Nixdorf wrote:
> Support setting the FDB limit through ip link. The arguments is:
>  - fdb_max_learned_entries: A 32-bit unsigned integer specifying the
>                             maximum number of learned FDB entries, with 0
>                             disabling the limit.
> 
> Also support reading back the current number of learned FDB entries in
> the bridge by this count. The returned value's name is:
>  - fdb_cur_learned_entries: A 32-bit unsigned integer specifying the
>                              current number of learned FDB entries.

MDB has "mcast_n_groups" and "mcast_max_groups". Maybe use
"fdb_n_learned_entries" to be consistent?

> 
> Example:
> 
>  # ip -d -j -p link show br0
> [ {
> ...
>         "linkinfo": {
>             "info_kind": "bridge",
>             "info_data": {
> ...
>                 "fdb_cur_learned_entries": 2,
>                 "fdb_max_learned_entries": 0,
> ...
>             }
>         },
> ...
>     } ]
>  # ip link set br0 type bridge fdb_max_learned_entries 1024
>  # ip -d -j -p link show br0
> [ {
> ...
>         "linkinfo": {
>             "info_kind": "bridge",
>             "info_data": {
> ...
>                 "fdb_cur_learned_entries": 2,
>                 "fdb_max_learned_entries": 1024,
> ...
>             }
>         },
> ...
>     } ]
> 
> Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
> ---
>  include/uapi/linux/if_link.h |  2 ++
>  ip/iplink_bridge.c           | 21 +++++++++++++++++++++
>  man/man8/ip-link.8.in        |  9 +++++++++
>  3 files changed, 32 insertions(+)
> 
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 94fb7ef9e226..5ad1e2727e0d 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -508,6 +508,8 @@ enum {
>  	IFLA_BR_VLAN_STATS_PER_PORT,
>  	IFLA_BR_MULTI_BOOLOPT,
>  	IFLA_BR_MCAST_QUERIER_STATE,
> +	IFLA_BR_FDB_CUR_LEARNED_ENTRIES,
> +	IFLA_BR_FDB_MAX_LEARNED_ENTRIES,
>  	__IFLA_BR_MAX,
>  };
>  
> diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
> index 7e4e62c81c0c..68ed3c251945 100644
> --- a/ip/iplink_bridge.c
> +++ b/ip/iplink_bridge.c
> @@ -34,6 +34,7 @@ static void print_explain(FILE *f)
>  		"		  [ group_fwd_mask MASK ]\n"
>  		"		  [ group_address ADDRESS ]\n"
>  		"		  [ no_linklocal_learn NO_LINKLOCAL_LEARN ]\n"
> +		"		  [ fdb_max_learned_entries FDB_MAX_LEARNED_ENTRIES ]\n"
>  		"		  [ vlan_filtering VLAN_FILTERING ]\n"
>  		"		  [ vlan_protocol VLAN_PROTOCOL ]\n"
>  		"		  [ vlan_default_pvid VLAN_DEFAULT_PVID ]\n"
> @@ -168,6 +169,14 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
>  				bm.optval |= no_ll_learn_bit;
>  			else
>  				bm.optval &= ~no_ll_learn_bit;
> +		} else if (matches(*argv, "fdb_max_learned_entries") == 0) {

New code is expected to use strcmp() instead of matches().

> +			__u32 fdb_max_learned_entries;
> +
> +			NEXT_ARG();
> +			if (get_u32(&fdb_max_learned_entries, *argv, 0))
> +				invarg("invalid fdb_max_learned_entries", *argv);
> +
> +			addattr32(n, 1024, IFLA_BR_FDB_MAX_LEARNED_ENTRIES, fdb_max_learned_entries);
>  		} else if (matches(*argv, "fdb_flush") == 0) {
>  			addattr(n, 1024, IFLA_BR_FDB_FLUSH);
>  		} else if (matches(*argv, "vlan_default_pvid") == 0) {
> @@ -544,6 +553,18 @@ static void bridge_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>  	if (tb[IFLA_BR_GC_TIMER])
>  		_bridge_print_timer(f, "gc_timer", tb[IFLA_BR_GC_TIMER]);
>  
> +	if (tb[IFLA_BR_FDB_CUR_LEARNED_ENTRIES])
> +		print_uint(PRINT_ANY,
> +			   "fdb_cur_learned_entries",
> +			   "fdb_cur_learned_entries %u ",
> +			   rta_getattr_u32(tb[IFLA_BR_FDB_CUR_LEARNED_ENTRIES]));
> +
> +	if (tb[IFLA_BR_FDB_MAX_LEARNED_ENTRIES])
> +		print_uint(PRINT_ANY,
> +			   "fdb_max_learned_entries",
> +			   "fdb_max_learned_entries %u ",
> +			   rta_getattr_u32(tb[IFLA_BR_FDB_MAX_LEARNED_ENTRIES]));
> +
>  	if (tb[IFLA_BR_VLAN_DEFAULT_PVID])
>  		print_uint(PRINT_ANY,
>  			   "vlan_default_pvid",
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index bf3605a9fa2e..a29595858a51 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -1620,6 +1620,8 @@ the following additional arguments are supported:
>  ] [
>  .BI no_linklocal_learn " NO_LINKLOCAL_LEARN "
>  ] [
> +.BI fdb_max_entries " FDB_MAX_ENTRIES "

Inconsistent with actual name.

> +] [
>  .BI vlan_filtering " VLAN_FILTERING "
>  ] [
>  .BI vlan_protocol " VLAN_PROTOCOL "
> @@ -1731,6 +1733,13 @@ or off
>  When disabled, the bridge will not learn from link-local frames (default:
>  enabled).
>  
> +.BI fdb_max_learned_entries " FDB_MAX_LEARNED_ENTRIES "
> +- set the maximum number of learned FDB entries linux may create. If

You can drop "linux may create".

> +.RI ( FDB_MAX_LEARNED_ENTRIES " == 0) "
> +the feature is disabled.

Please mention it's the default.

> +.I FDB_MAX_LEARNED_ENTRIES
> +is a 32bit unsigned integer.
> +
>  .BI vlan_filtering " VLAN_FILTERING "
>  - turn VLAN filtering on
>  .RI ( VLAN_FILTERING " > 0) "
> -- 
> 2.40.1
> 

