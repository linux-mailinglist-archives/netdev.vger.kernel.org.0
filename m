Return-Path: <netdev+bounces-7924-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B93872220D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFC961C20B6F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 333D4134D6;
	Mon,  5 Jun 2023 09:23:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F335134AE
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:23:47 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD68BDF
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:23:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aj4Nd2Lk0CoHaJpPdK8T8yRzXBrXz3AO71psZEhp2Xuy7j2PD5nUzurUNTEvejCl1GUOdTvlLVH5fDHbggo3WZLKZCVliy6Csk3OW32d8+T7RC7srrPHtu+spQm+gec1rYaWjnSarBm7g/GFAhEm0kCsmLNDwyezHBwITmOraeA0qxq3HCCwg8OIVJCrYomEcIdUAm9Ag3I8iYL32QVCgtVMpisOHGhxK4X6F0bxVLSaCXGDtoRz17B7oEVF25KFLsd9I2ZvfZsD2DVPysEtRKbxD1OW10lNHOCC6yUgcUT16YRLZlXH2L6mzZaw1mIMcoBiv+Vg3ospEvkt2R3FWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xp6tpduEfAukR2GKZw+GMs+GBtpsAdT3v3lTlk7V968=;
 b=jUuvOT+S83SC1AkFUWoBC+mjvF8EmMOd3hineCSeHRbFTpJlGvmnxwTGfS+nYOqUzCApBYERMj4SMDir0l+hk4cVTOAk8qKu3BTiQtZa3B1gY2jy7AP4C9N5Q1D9Sr9gZDVz99yXXgdkRTOmZ5QoiUEEqk3rv/2413FcOIHF2HlCFzJKLhc7Jrpumy80lfIgBslZZlsAcVSKCLeZeXNrD5rWSG0W/Rpy8SWWQ/Nec8gAy1CUxNazQXva/klEkdxpjKScJ8LsY4fGsBS+1p9x4JKZ0QJI8Y89opUN4TbdP7E1fZuE9stSBH2hg8KNVuyiwK1X1Dt5I9dxNq26PRSRaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xp6tpduEfAukR2GKZw+GMs+GBtpsAdT3v3lTlk7V968=;
 b=QkasW09uUCVl+QgZxrR41ORJuKmCtd3vPVflCgYlhdhQ1y6qLc50dwh61k7z6M+Rvg8k/LKloe1jF9hW7/khsJPTFvIPOkkUR/v8dqNZxMrrImKbm6VDv0DClxA49k90HXMshBMD5Ut0IEh2Vt8tB004OyPTkG8hKcjqtyqJ+8c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5510.namprd13.prod.outlook.com (2603:10b6:303:195::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 09:23:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 09:23:41 +0000
Date: Mon, 5 Jun 2023 11:23:34 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Marcin Szycik <marcin.szycik@linux.intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	wojciech.drewek@intel.com, michal.swiatkowski@linux.intel.com,
	alexandr.lobakin@intel.com, davem@davemloft.net, kuba@kernel.org,
	jiri@resnulli.us, pabeni@redhat.com, jesse.brandeburg@intel.com,
	idosch@nvidia.com
Subject: Re: [RFC PATCH iwl-next 2/6] ip_tunnel: convert __be16 tunnel flags
 to bitmaps
Message-ID: <ZH2plrPDtUdmjL7w@corigine.com>
References: <20230601131929.294667-1-marcin.szycik@linux.intel.com>
 <20230601131929.294667-3-marcin.szycik@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601131929.294667-3-marcin.szycik@linux.intel.com>
X-ClientProxiedBy: AM0PR02CA0204.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5510:EE_
X-MS-Office365-Filtering-Correlation-Id: f25d0f21-8850-48c1-ad0f-08db65a68d16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Me5FmWKIScyRQf8OPldiiiu+OaC15vdfz119djwVN01ojebbD607DbY9zT/xSruPV8Q7lleTduliomuW5kOuiVp2XjSEJG6gO64T1nXkjGG0bjPJeZ7NjwjXjJRHajd2gsGagBAdR4HwLGvlo8MkY/ME4K3eNI2IYigvWyFamkN2jJQ9hCSD9HolKilhu9kSWwrFATpg5uiCu3RVnzXIDkDpvrnmpczrpan7VAgEVoHB+zTtFmTrh/clb/gP0l0POpZBaTW0xt4FXSpUkDcjA4oUAUaps8DwQNyVm8w3pJhsY8ECZw/qP2COgDTKFqiyAZeO5KVReDy3XhnVWyfqWT8yd2l1VP85FqOtp9obLBPB8Q+rmVmzE3QV7iOZpHTqM56C0JHldjmxeWfdqFhuLLgpwbWyoR5GEA6aHany96d4VogYoKCG9v1lKZmnXdrAv4ng3jnbksIhAVKq7B8VAMnKfea1iHm66EULW1qxUyynTqC2Q8Im5q/0fI9/7V+dNdmztWqjweGz4vd0uFiSEa/TKjMSiXHHY3Fkki+TKogrFuviYlqR7mT4r/GKVv1u
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(346002)(136003)(39840400004)(451199021)(6512007)(6506007)(38100700002)(2616005)(41300700001)(6486002)(6666004)(186003)(83380400001)(478600001)(4326008)(66476007)(66556008)(6916009)(316002)(66946007)(7416002)(8936002)(8676002)(5660300002)(44832011)(2906002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b+9cR2lKmRH5EXxJFCbYusunBkGK/WCB1XI4voJvUkGZdIDPSsYog0Rwjzmg?=
 =?us-ascii?Q?FXLh0kkOaYFJGX2IkLgIqKqzy8z3wcsH1vprpaA37uILC7mjVvWShM2c/WY1?=
 =?us-ascii?Q?s2nkSbs0nnCjISNxOSM3EYUTlvdqb8EX3gp54qcaNno5dL39PhFqWU/MHXAM?=
 =?us-ascii?Q?R5qwJwH9LvevBE96sbX/x2wv9JPDr7bRxFk8oR61+pamnQDgr/nxyEiwGMYV?=
 =?us-ascii?Q?BFe2fBsi1Cw2ZTruXcGH7nX0M1qoCZNDjw3LSsN5q2/sNEtGIQ//yKPMVBLR?=
 =?us-ascii?Q?LUCU4G5ci9XcF9OQ5Z6/JCo2I62nlS76Q3UYrCN+zpEwemP4LRx44kEDzim/?=
 =?us-ascii?Q?sXE0dfq6gJTeEejOGRA6SRtYyGFsiAS3L7ISZGqjNN80md9C4D0e/srXxWD+?=
 =?us-ascii?Q?nap3fYQ4eH/2R9/KlzpjjH4AOrGfZvKHMauBey+yjovLnOMYoapmyk93r4C4?=
 =?us-ascii?Q?/+/7tFF0I6QdjrbLNv1hdwhzwld/m5ddvZ6+2HIM8/JDtADUQpFDQcdLxbDg?=
 =?us-ascii?Q?i+BoCR/wEbAJ9CNJn70odsJj6TBe5p0tF9YFKqV4HfwkZxbYgRVV1wQ+gHBa?=
 =?us-ascii?Q?FAuvHtVt1vEEPTp5x/0C4WJXYUQL4rUrkU8MUHnI/1fUF69jEjyx0/AZLXeh?=
 =?us-ascii?Q?wnnKL8S6za3W2n9VDZRNPCiCkFCy5a/hUDFurDuVFyz3c+wl3QdK62puIl0b?=
 =?us-ascii?Q?c/k6OwnWrfJAbU1Q+3MxI3hL/j2gpB1LNQaRXPXUKOVncYglUXIdTB2nPaC8?=
 =?us-ascii?Q?XWkyqgVcj+oQHt5aFZc+ftVFF1MHsIG8BB2QXIjg5jqpwFe+R379iEcWFVCN?=
 =?us-ascii?Q?GI6u2X5Ktsa/FMQ/Lk97Kz+PIq9SzOMUORY98+Cp7x8S0idGdgBvXnFQLHOe?=
 =?us-ascii?Q?eBFEClqYcPoUNWhzK7RVKr1A90przcyHSyt5DdKqAKcEWLXtFXm4yAo0QePG?=
 =?us-ascii?Q?P801cDx3PNi5u0ivBo4MjaVPgUQ3wFVYRxn8/wxYfMUwYDsGnmeQNZO/UCJM?=
 =?us-ascii?Q?NRUseMn1ztB/X5zdkcg/KbrdQwoXYkG5A6XxDP829yMXPdurdTR4wmwN5Mem?=
 =?us-ascii?Q?20kaAJo/wXD47cCxrwgJveSxxapbv4s1d6HI1e+X3MXkz+fg5xvc1gQ7s0b5?=
 =?us-ascii?Q?ydwLlpsJY1/XbZfHkQNKqz9V9/pQIpK0m7rreUhV9c+qyi0MZdpIxdtYzIr0?=
 =?us-ascii?Q?KYFw+KfmknB4DOLnwlhr/Ez+Q8dY3Ka6Hdj0f4Wxo3W8XKTMoKdtIIj6HEe6?=
 =?us-ascii?Q?MeX+sZ/r0xOQNarv7UfB7GrFIk2ajtAFLTkKhDBLYQAE91qlRos22kKfpA6S?=
 =?us-ascii?Q?H/c5quc+r9stU/FDw7lzm03avjpBFjKcnYUNec612uLjv1Xzza6I7fZYC0qX?=
 =?us-ascii?Q?STNo4okY+8pFZZoYidugqdK1zG7c4ymHLFw3d+ESeFnEvj+uIfnCz9DMUmT5?=
 =?us-ascii?Q?rN9BW3wF5iV8+vUpo8VShVn7nGn8gQqsH6nHr1h8CvWt7dGaX1lXVMrT+Nhh?=
 =?us-ascii?Q?rqlm+mwa3jKnbkIF0lqFOE86WQOktq9jU3nxRSV7y9fKsxAn9/MZI/5vL5Zd?=
 =?us-ascii?Q?MmFe8MSKC6U4jklnlqAUATYDX2osRid1dVBubUcvyW6myGxxHnHpjXKxfP6k?=
 =?us-ascii?Q?giIMh06UHcSGRUTcRAQshxHzC0d0hmIzHzbRXnRgEZGpBGYK8ZxxB0dXEzUC?=
 =?us-ascii?Q?krKCXQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f25d0f21-8850-48c1-ad0f-08db65a68d16
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 09:23:41.0455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ahIRmWATWoR6yMzJWpT6ZiA2gJ+ZrOOJX3gAQW2WzmHp+wyLHU8e4ThOI7I3FKhzZWHrUgaSw5vkHHCPiYk6aBcgLSMFlR/7r+jpesxsLTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5510
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 03:19:25PM +0200, Marcin Szycik wrote:
> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> 
> Historically, tunnel flags like TUNNEL_CSUM or TUNNEL_ERSPAN_OPT
> have been defined as __be16. Now all of those 16 bits are occupied
> and there's no more free space for new flags.
> It can't be simply switched to a bigger container with no
> adjustments to the values, since it's an explicit Endian storage,
> and on LE systems (__be16)0x0001 equals to
> (__be64)0x0001000000000000.
> We could probably define new 64-bit flags depending on the
> Endianness, i.e. (__be64)0x0001 on BE and (__be64)0x00010000... on
> LE, but that would introduce an Endianness dependency and spawn a
> ton of Sparse warnings. To mitigate them, all of those places which
> were adjusted with this change would be touched anyway, so why not
> define stuff properly if there's no choice.

Hi Marcin,

a few nits from my side, that you can take or leave.
Overall this looks good to me.


Reviewed-by: Simon Horman <simon.horman@corigine.com>

> Define IP_TUNNEL_*_BIT counterparts as a bit number instead of the
> value already coded and a fistful of <16 <-> bitmap> converters and
> helpers. The two flags which have a different bit position are
> SIT_ISATAP_64 and VTI_ISVTI_64, as they were defined not as
> __cpu_to_be16(), but as (__force __be16), i.e. had different
> positions on LE and BE. Now they have a strongly defined place.
> Change all __be16 fields which were used to store those flags, to
> IP_TUNNEL_DECLARE_FLAGS() -> DECLARE_BITMAP(__IP_TUNNEL_FLAG_NUM) ->
> unsigned long[1] for now, and replace all TUNNEL_* occurencies to
> their 64-bit bitmap counterparts. Use the converters in the places
> which talk to the userspace, hardware (NFP) or other hosts (GRE
> header). The rest must explicitly use the new flags only. This must
> be done at once, otherwise there will be too much conversions
> throughout the code in the intermediate commits.
> Finally, disable the old __be16 flags for use in the kernel code
> (except for the two 'irregular' flags mentioned above), to prevent
> any accidential (mis)use of them. For the userspace, nothing is

nit: s/accidential/accidental/

> changed, only additions were made.
> 
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>

> ---
>  drivers/net/bareudp.c                         |  19 ++-
>  .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |   2 +-
>  .../mellanox/mlx5/core/en/tc_tun_encap.c      |   6 +-
>  .../mellanox/mlx5/core/en/tc_tun_geneve.c     |  12 +-
>  .../mellanox/mlx5/core/en/tc_tun_gre.c        |   9 +-
>  .../mellanox/mlx5/core/en/tc_tun_vxlan.c      |   9 +-
>  .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  15 +-
>  .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  32 +++--
>  .../ethernet/mellanox/mlxsw/spectrum_span.c   |   6 +-
>  .../ethernet/netronome/nfp/flower/action.c    |  26 +++-
>  drivers/net/geneve.c                          |  46 +++---
>  drivers/net/vxlan/vxlan_core.c                |  14 +-
>  include/net/dst_metadata.h                    |  10 +-
>  include/net/flow_dissector.h                  |   2 +-
>  include/net/gre.h                             |  59 ++++----
>  include/net/ip6_tunnel.h                      |   4 +-
>  include/net/ip_tunnels.h                      |  90 ++++++++++--
>  include/net/udp_tunnel.h                      |   4 +-
>  include/uapi/linux/if_tunnel.h                |  33 +++++
>  net/bridge/br_vlan_tunnel.c                   |   5 +-
>  net/core/filter.c                             |  20 +--
>  net/core/flow_dissector.c                     |  12 +-
>  net/ipv4/fou_bpf.c                            |   2 +-
>  net/ipv4/gre_demux.c                          |   2 +-
>  net/ipv4/ip_gre.c                             | 131 +++++++++++-------
>  net/ipv4/ip_tunnel.c                          |  51 ++++---
>  net/ipv4/ip_tunnel_core.c                     |  81 +++++++----
>  net/ipv4/ip_vti.c                             |  31 +++--
>  net/ipv4/ipip.c                               |  21 ++-
>  net/ipv4/udp_tunnel_core.c                    |   5 +-
>  net/ipv6/ip6_gre.c                            |  87 +++++++-----
>  net/ipv6/ip6_tunnel.c                         |  14 +-
>  net/ipv6/sit.c                                |   9 +-
>  net/netfilter/ipvs/ip_vs_core.c               |   6 +-
>  net/netfilter/ipvs/ip_vs_xmit.c               |  20 +--
>  net/netfilter/nft_tunnel.c                    |  45 +++---
>  net/openvswitch/flow_netlink.c                |  55 ++++----
>  net/psample/psample.c                         |  26 ++--
>  net/sched/act_tunnel_key.c                    |  39 +++---
>  net/sched/cls_flower.c                        |  27 ++--
>  40 files changed, 695 insertions(+), 392 deletions(-)

nit: this is a rather long patch

...

> diff --git a/include/uapi/linux/if_tunnel.h b/include/uapi/linux/if_tunnel.h
> index 102119628ff5..d222e70d8621 100644
> --- a/include/uapi/linux/if_tunnel.h
> +++ b/include/uapi/linux/if_tunnel.h
> @@ -161,6 +161,14 @@ enum {
>  
>  #define IFLA_VTI_MAX	(__IFLA_VTI_MAX - 1)
>  
> +#ifndef __KERNEL__
> +/* Historically, tunnel flags have been defined as __be16 and now there are
> + * no free bits left. It is strongly advised to switch the already existing
> + * userspace code to u32/BIGINT and the new *_BIT definitions from down below,
> + * as __be16 can't be simply casted to a wider type on LE systems. All new

nit: s/casted/cast/

...

