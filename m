Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE6E64A3E4
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 16:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiLLPCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 10:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbiLLPCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 10:02:22 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59F911829;
        Mon, 12 Dec 2022 07:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670857340; x=1702393340;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=H1uhnx8VMvnL4IZybHsz6wT6o+G25gd5/bZ0uziJwkA=;
  b=DJpVW02NSa0cD7oCqEgUcIsLoKQUYYUQSGegrMlk+adfqszRrqXhUaSv
   YJuOvrzkdQZlXGJjFSYXaW3PGjQHWX5BgJxTFzkrYHqIHCZMCH7KRAmWU
   AfBsSuJwJ/g4xhyRp5e/giBICeTHJcMdKG98aSVGfhWMH2haBFkS99CwJ
   cYKKQ5f4ON0mhlzrIHdDcKDJhShcA6s+bBGoWvTDyNnnsEoh3s6qdtfv/
   y/QBLhq7uwJY/iWjwFp89DOx37coUVqViceb3duADer+utXTyLUxZixO8
   F8OcDJjr8+vSohTTtfbBPgMjC8kURUjH9+90rhb4NEIeK+vCzDEctoLmd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="297550011"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="297550011"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 07:01:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="711710083"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="711710083"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 12 Dec 2022 07:01:55 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 07:01:55 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 07:01:55 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 12 Dec 2022 07:01:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8sqhoyt7axdS1nmWqz6zqs0E6k/DwbtMWVMPs3W7IfZ0l7TaSdVHQYU+Rky5hLjD3LYqrQTt8c0fn6ZziIiyYugtGId2Aabenvid24sMCxIMUWKlQSyy5Fi328RFiPdxRNXF942ODqGfUyIaPWHEwY3AGD5x4C8xOkcVQmSPswVoE/L1NhdbcCxZBJmYG8/zgS+GD9MFwQZERLHetMH3gDy/aRqbFLz2dzsup6Q3v2wG/vJv8a/WhqfgwomZH+vIvGJwXHXXCh0n7GwsC/zAdXgmvXW8L2W+5El2foLFjdczLltzC7z+q6gJcv3BNRQUBRBspjGMouH7lHxDNKZ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=htPzsnIhWprL2eRpEcc9LS3WzeN+ZJkxiq3N5jjbm2A=;
 b=FvxNKQpFGQ6winIi53HgQV4Qa+b04uK8VSApiu0EaZ8/UfjlsaoKJ6NhfGPi9JxLJ/VKR6UgMhtc3Y0XvTAWzvip4pIXV2dL5059Hu2myEj1CklnsxPzwwy1S4fvG4ZVI7kCvMWUM+P112KB2eiugNxnRNGYYhLfwBaqUDmUMfM47ASRbRJiynkUXaA1n8SPoqBNAbgvE79O8AFZkpDBufAdTf89d0sr64s7Cbk8BE68eCrZQn+7DEIL7m0UWI5RKW0NCzDc8pztM4GFF/UpviJVd/KQhHbFJGbDORH5pDwNrZOyHWN+//Qr40oDLY28x7/hbPOxC/MQ1DvflEN2Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CO1PR11MB4787.namprd11.prod.outlook.com (2603:10b6:303:95::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Mon, 12 Dec 2022 15:01:51 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 15:01:51 +0000
Date:   Mon, 12 Dec 2022 16:01:37 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <yhs@fb.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 09/15] selftests/xsk: load and attach XDP
 program only once per mode
Message-ID: <Y5dCUU5v9cQpkTiW@boxer>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
 <20221206090826.2957-10-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221206090826.2957-10-magnus.karlsson@gmail.com>
X-ClientProxiedBy: FR3P281CA0118.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CO1PR11MB4787:EE_
X-MS-Office365-Filtering-Correlation-Id: fea201f6-b1aa-434e-caf0-08dadc51cc8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qlrjnyxeFUaliKRQuOkR0f8DsEyoOCFQLrN37uv2Wjs30x1Qx05+PhjuuFtJPG071PJT8JIMvgjbeFQtmmnOcZpbVPx/6X8w/elcFeD4WXTGDlRYjO6JMI2bxBhPMMsIpLE7a5L06nT4pkONxBcwXcEo/DnSvmte5CXgujYJBlBX0h2q/zgVxbysaeDo8N+ohjfwTzBr3SpoagpieWNNiTtF6oLQPcYZW5i+3u49O/asqeiVlu5vWh5SwwURdPDlFb91lBY6Vitlk7KYU2HwyOMgRgIsutdPH4svopsTLoZ3G/USFkRv6uSIlC7kIcHV5zSbV+O+3lQ8MhAlimxT+BCBST7Q5wztWXdC7lv4TfGmh0gAQHsWUU7+Kz2t+iUOLbxzvD1oDJ0CW32XNEaj0oLyvBxT0qpSy3AW402G0ArDoM44OzFzxkf5LEhpynoxUrvKt2uMpK6bWPndaTQYR6uOZg2gze/LhGp6vwOFaOVcWAqZWYvKlpVEKSU7m6JaR17VAe+BDjfWWlx3y/Af/lUhULYMTeBtsVLPwZjkoASEC8f3Nb5AYzQOpdW654Jp+D64aeRV2yWNxb6PsntCanQwTrhcD/KFSWo/WZ6utdj2+7xl3dY3N6tBPyASRiYpUwV7fYaj1mjqN/jhFJq18g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(316002)(6666004)(6916009)(2906002)(6486002)(83380400001)(7416002)(8936002)(30864003)(478600001)(38100700002)(82960400001)(44832011)(6506007)(5660300002)(33716001)(4326008)(66946007)(8676002)(86362001)(41300700001)(186003)(6512007)(66556008)(26005)(66476007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6ojBazzIkRa1x3wVVKebTy7AaN/jjvoqw2yDqXht+2AtrHL46MZhcKQvr7Nq?=
 =?us-ascii?Q?+/uBccMeI72480VVtjS3Jf2JcLC80drn6J/GLxnWXhlZBObHQLZqIvvkeC0M?=
 =?us-ascii?Q?MWMQzgNNkHnz4zSZQ/CQwncOEqJwnHlevj8rVmLECOIDvheYf7BoGWiwVE4L?=
 =?us-ascii?Q?4Pw7cyaqP6k3jy3xjdLRQ9ZkqDeZmOW27r1W10rFn/EKtYzn7w+8wjWFvXOv?=
 =?us-ascii?Q?+fYiGXxWyMMa/MNPxWJw2vqsVFlHIpCupLCLdUH+uKBWIX9RFjxEMU41uRuV?=
 =?us-ascii?Q?FQgQyR8W3tEyBMckl16LnHU1WuIeRHh/iOBzC/e9KHRxb0JuUuKYO7S4a2k/?=
 =?us-ascii?Q?6rGTA4iQchhPhZ/O+PuuuUQNGDWzjlX24A+M5pHRKXanN1KUMz0cDzFzNeBf?=
 =?us-ascii?Q?4yH69supXVEBJF5Ntxp3pbYe3ONx1MTtsOBYnVJQt0pX9JhQhmpSBRUBKNs8?=
 =?us-ascii?Q?Z3iftr7E8k2aFtfmWLDplfS9D79YkYkDgv3pG64czDLqqTy3Bx8EB/H6+Cnf?=
 =?us-ascii?Q?Ja7Z6ZOyAglAH48ondUdKAg2Rj+m6wk027PECx8x7wh1WGo7Iovexi5/4VgV?=
 =?us-ascii?Q?ISA145ny4v1nLWub/snEjonE1xmnL5N3xrQ+YJM36MYcrTkVbGplkuu+JX/Q?=
 =?us-ascii?Q?jYdSUOFCr7IYcqzTRsApCYYuks3aZ2UggE2iMOa7KXWWuu3cOk1visjVbqN0?=
 =?us-ascii?Q?+0a0ivTVaiZYUjbbDv2MLXp+n7hkkSSdqRzMk/uybCCnsmeBvuRYlWnFlztm?=
 =?us-ascii?Q?lXjVua4+eFrSz588IO+XlLeZOH+48ItaE3LsKAcuhziwLnvahA229/AYyK8+?=
 =?us-ascii?Q?xlbccHws2f58oIB+oHep3h7ajhQm2lpUeBah8+htYJ1P3aFz8jnRxdGXrCrf?=
 =?us-ascii?Q?kG3P1iznw3iNXkgMtvFE0Z3ezN3bGlNeE8ulGDilJqGmoQgD5NwblaSB/RBK?=
 =?us-ascii?Q?79ZdmeL01FbptfQHoQy9f2LKUUcRhwgMyahWs5ox/qD9ye8lt9UZ7Hd/pl/i?=
 =?us-ascii?Q?LuZLWKBb6ilrYcwJi7+IygqrplOadScIc9CQfO/p/VsKaOFGxmrcLYike28x?=
 =?us-ascii?Q?5mJahjiwvx1Bb4MKEZagJUbAzG/63QYVmJYx5jukw7NMrG4LJjIwgJuny8eO?=
 =?us-ascii?Q?G1vBbtF79bFezYm7gCL92Sh7b3Q7fRmffW1t4zDCR+aL20pQMmTL7PVG0ih5?=
 =?us-ascii?Q?OU2oMJ76FB81xI6/FUYxLD6is1627xEconETfbozQWR5DWePAh7vj22iRiyK?=
 =?us-ascii?Q?Ln8twdn683PDtZ+azoQvDUbO9hAF5Ug3pXRp5UdklgaxQNQkT7akQquygQGc?=
 =?us-ascii?Q?xZOJXxtl8IWffIrFVBf+lh+PczOEps2y5gidyFBmOQaIxAThbmpJM+EXl5Fo?=
 =?us-ascii?Q?JLH2Q135fOXPyGecvXiacIundw9qIxW9ug9MdtuLZVZeI1to6EzmPUzceJmQ?=
 =?us-ascii?Q?WX7rsBR/sklt3L446CRpnIOQugXwp86YcoKD1HxwYTfLmeZUxw26dqjmCz8u?=
 =?us-ascii?Q?HOFyirZ+7Zv8ZbXTXw5yEC24XWlISOpKOcZNpEwAtXWoOERar34j/rl49wKN?=
 =?us-ascii?Q?PEFEGRwCyRhr5J6PMorEAFMqs7NeZkpdCdonTd+b4/6G72TL9RhXXO7OW6+x?=
 =?us-ascii?Q?xLRh9GCbY+Xyu5sP4P+ed+E=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fea201f6-b1aa-434e-caf0-08dadc51cc8f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 15:01:51.0658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4vLaDG0GI6E/zGiGhJegMllx3mfnk8k40bgSVbJd2UolDpU23Ucm6OG/kR6ruI6Uszu/oTD37lCSgTm6SM9mCp2dhrJjA5TBaUxpRYeNso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4787
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 10:08:20AM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Load and attach the XDP program only once per XDP mode that is being
> executed. Today, the XDP program is loaded and attached for every
> test, then unloaded, which takes a long time on real NICs, since they
> have to reconfigure their HW, in contrast to veth. The test suite now
> completes in 21 seconds, instead of 207 seconds previously on my
> machine. This is a speed-up of around 10x.
> 
> This is accomplished by moving the XDP loading from the worker threads
> to the main thread and replacing the XDP loading interfaces of xsk.c
> that was taken from the xsk support in libbpf, with something more
> explicit that is more useful for these tests. Instead, the relevant
> file descriptors and ifindexes are just passed down to the new
> functions.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/xsk.c        |  92 +++++++++-----
>  tools/testing/selftests/bpf/xsk.h        |   7 +-
>  tools/testing/selftests/bpf/xskxceiver.c | 147 ++++++++++++++---------
>  tools/testing/selftests/bpf/xskxceiver.h |   3 +
>  4 files changed, 162 insertions(+), 87 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
> index b166edfff86d..1dd953541812 100644
> --- a/tools/testing/selftests/bpf/xsk.c
> +++ b/tools/testing/selftests/bpf/xsk.c
> @@ -51,6 +51,8 @@
>  
>  #define pr_warn(fmt, ...) fprintf(stderr, fmt, ##__VA_ARGS__)
>  
> +#define XSKMAP_SIZE 1
> +
>  enum xsk_prog {
>  	XSK_PROG_FALLBACK,
>  	XSK_PROG_REDIRECT_FLAGS,
> @@ -387,10 +389,9 @@ static enum xsk_prog get_xsk_prog(void)
>  	return detected;
>  }
>  
> -static int xsk_load_xdp_prog(struct xsk_socket *xsk)
> +static int __xsk_load_xdp_prog(int xsk_map_fd)
>  {
>  	static const int log_buf_size = 16 * 1024;
> -	struct xsk_ctx *ctx = xsk->ctx;
>  	char log_buf[log_buf_size];
>  	int prog_fd;
>  
> @@ -418,7 +419,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>  		/* *(u32 *)(r10 - 4) = r2 */
>  		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_2, -4),
>  		/* r1 = xskmap[] */
> -		BPF_LD_MAP_FD(BPF_REG_1, ctx->xsks_map_fd),
> +		BPF_LD_MAP_FD(BPF_REG_1, xsk_map_fd),
>  		/* r3 = XDP_PASS */
>  		BPF_MOV64_IMM(BPF_REG_3, 2),
>  		/* call bpf_redirect_map */
> @@ -430,7 +431,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>  		/* r2 += -4 */
>  		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
>  		/* r1 = xskmap[] */
> -		BPF_LD_MAP_FD(BPF_REG_1, ctx->xsks_map_fd),
> +		BPF_LD_MAP_FD(BPF_REG_1, xsk_map_fd),
>  		/* call bpf_map_lookup_elem */
>  		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
>  		/* r1 = r0 */
> @@ -442,7 +443,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>  		/* r2 = *(u32 *)(r10 - 4) */
>  		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_10, -4),
>  		/* r1 = xskmap[] */
> -		BPF_LD_MAP_FD(BPF_REG_1, ctx->xsks_map_fd),
> +		BPF_LD_MAP_FD(BPF_REG_1, xsk_map_fd),
>  		/* r3 = 0 */
>  		BPF_MOV64_IMM(BPF_REG_3, 0),
>  		/* call bpf_redirect_map */
> @@ -461,7 +462,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>  		/* r2 = *(u32 *)(r1 + 16) */
>  		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 16),
>  		/* r1 = xskmap[] */
> -		BPF_LD_MAP_FD(BPF_REG_1, ctx->xsks_map_fd),
> +		BPF_LD_MAP_FD(BPF_REG_1, xsk_map_fd),
>  		/* r3 = XDP_PASS */
>  		BPF_MOV64_IMM(BPF_REG_3, 2),
>  		/* call bpf_redirect_map */
> @@ -480,13 +481,40 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>  
>  	prog_fd = bpf_prog_load(BPF_PROG_TYPE_XDP, NULL, "LGPL-2.1 or BSD-2-Clause",
>  				progs[option], insns_cnt[option], &opts);
> -	if (prog_fd < 0) {
> +	if (prog_fd < 0)
>  		pr_warn("BPF log buffer:\n%s", log_buf);
> -		return prog_fd;
> +
> +	return prog_fd;
> +}
> +
> +int xsk_attach_xdp_program(int ifindex, int prog_fd, u32 xdp_flags)
> +{
> +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
> +	__u32 prog_id = 0;
> +	int link_fd;
> +	int err;
> +
> +	err = bpf_xdp_query_id(ifindex, xdp_flags, &prog_id);
> +	if (err) {
> +		pr_warn("getting XDP prog id failed\n");
> +		return err;
>  	}
>  
> -	ctx->prog_fd = prog_fd;
> -	return 0;
> +	/* If there's a netlink-based XDP prog loaded on interface, bail out
> +	 * and ask user to do the removal by himself
> +	 */
> +	if (prog_id) {
> +		pr_warn("Netlink-based XDP prog detected, please unload it in order to launch AF_XDP prog\n");
> +		return -EINVAL;
> +	}
> +
> +	opts.flags = xdp_flags & ~(XDP_FLAGS_UPDATE_IF_NOEXIST | XDP_FLAGS_REPLACE);
> +
> +	link_fd = bpf_link_create(prog_fd, ifindex, BPF_XDP, &opts);
> +	if (link_fd < 0)
> +		pr_warn("bpf_link_create failed: %s\n", strerror(errno));
> +
> +	return link_fd;
>  }
>  
>  static int xsk_create_bpf_link(struct xsk_socket *xsk)
> @@ -775,7 +803,7 @@ static int xsk_init_xdp_res(struct xsk_socket *xsk,
>  	if (err)
>  		return err;
>  
> -	err = xsk_load_xdp_prog(xsk);
> +	err = __xsk_load_xdp_prog(*xsks_map_fd);
>  	if (err)
>  		goto err_load_xdp_prog;
>  
> @@ -871,6 +899,22 @@ int xsk_setup_xdp_prog_xsk(struct xsk_socket *xsk, int *xsks_map_fd)
>  	return __xsk_setup_xdp_prog(xsk, xsks_map_fd);
>  }
>  
> +int xsk_load_xdp_program(int *xsk_map_fd, int *prog_fd)
> +{
> +	*xsk_map_fd = bpf_map_create(BPF_MAP_TYPE_XSKMAP, "xsks_map", sizeof(int), sizeof(int),
> +				     XSKMAP_SIZE, NULL);

Next step would be to create the map once per whole test suite and pin it?
:p I sort of wanted to ask if this would make sense, but I would consider
this as over-optimization. Once per mode is more than enough.

> +	if (*xsk_map_fd < 0)
> +		return *xsk_map_fd;
> +
> +	*prog_fd = __xsk_load_xdp_prog(*xsk_map_fd);
> +	if (*prog_fd < 0) {
> +		close(*xsk_map_fd);
> +		return *prog_fd;
> +	}
> +
> +	return 0;
> +}
> +
>  static struct xsk_ctx *xsk_get_ctx(struct xsk_umem *umem, int ifindex,
>  				   __u32 queue_id)
>  {
> @@ -917,7 +961,7 @@ static void xsk_put_ctx(struct xsk_ctx *ctx, bool unmap)
>  
>  static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
>  				      struct xsk_umem *umem, int ifindex,
> -				      const char *ifname, __u32 queue_id,
> +				      __u32 queue_id,
>  				      struct xsk_ring_prod *fill,
>  				      struct xsk_ring_cons *comp)
>  {
> @@ -944,7 +988,6 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
>  	ctx->refcount = 1;
>  	ctx->umem = umem;
>  	ctx->queue_id = queue_id;
> -	bpf_strlcpy(ctx->ifname, ifname, IFNAMSIZ);
>  	ctx->prog_fd = FD_NOT_USED;
>  	ctx->link_fd = FD_NOT_USED;
>  	ctx->xsks_map_fd = FD_NOT_USED;
> @@ -991,7 +1034,7 @@ int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd)
>  }
>  
>  int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
> -			      const char *ifname,
> +			      int ifindex,
>  			      __u32 queue_id, struct xsk_umem *umem,
>  			      struct xsk_ring_cons *rx,
>  			      struct xsk_ring_prod *tx,
> @@ -1005,7 +1048,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>  	struct xdp_mmap_offsets off;
>  	struct xsk_socket *xsk;
>  	struct xsk_ctx *ctx;
> -	int err, ifindex;
> +	int err;
>  
>  	if (!umem || !xsk_ptr || !(rx || tx))
>  		return -EFAULT;
> @@ -1020,12 +1063,6 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>  	if (err)
>  		goto out_xsk_alloc;
>  
> -	ifindex = if_nametoindex(ifname);
> -	if (!ifindex) {
> -		err = -errno;
> -		goto out_xsk_alloc;
> -	}
> -
>  	if (umem->refcount++ > 0) {
>  		xsk->fd = socket(AF_XDP, SOCK_RAW | SOCK_CLOEXEC, 0);
>  		if (xsk->fd < 0) {
> @@ -1045,8 +1082,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>  			goto out_socket;
>  		}
>  
> -		ctx = xsk_create_ctx(xsk, umem, ifindex, ifname, queue_id,
> -				     fill, comp);
> +		ctx = xsk_create_ctx(xsk, umem, ifindex, queue_id, fill, comp);
>  		if (!ctx) {
>  			err = -ENOMEM;
>  			goto out_socket;
> @@ -1144,12 +1180,6 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>  		goto out_mmap_tx;
>  	}
>  
> -	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
> -		err = __xsk_setup_xdp_prog(xsk, NULL);
> -		if (err)
> -			goto out_mmap_tx;
> -	}
> -
>  	*xsk_ptr = xsk;
>  	umem->fill_save = NULL;
>  	umem->comp_save = NULL;
> @@ -1173,7 +1203,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>  	return err;
>  }
>  
> -int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
> +int xsk_socket__create(struct xsk_socket **xsk_ptr, int ifindex,
>  		       __u32 queue_id, struct xsk_umem *umem,
>  		       struct xsk_ring_cons *rx, struct xsk_ring_prod *tx,
>  		       const struct xsk_socket_config *usr_config)
> @@ -1181,7 +1211,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>  	if (!umem)
>  		return -EFAULT;
>  
> -	return xsk_socket__create_shared(xsk_ptr, ifname, queue_id, umem,
> +	return xsk_socket__create_shared(xsk_ptr, ifindex, queue_id, umem,
>  					 rx, tx, umem->fill_save,
>  					 umem->comp_save, usr_config);
>  }
> diff --git a/tools/testing/selftests/bpf/xsk.h b/tools/testing/selftests/bpf/xsk.h
> index 24ee765aded3..7a5aeacd261b 100644
> --- a/tools/testing/selftests/bpf/xsk.h
> +++ b/tools/testing/selftests/bpf/xsk.h
> @@ -204,6 +204,9 @@ int xsk_socket__update_xskmap(struct xsk_socket *xsk, int xsks_map_fd);
>  /* Flags for the libbpf_flags field. */
>  #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
>  
> +int xsk_load_xdp_program(int *xsk_map_fd, int *prog_fd);
> +int xsk_attach_xdp_program(int ifindex, int prog_fd, u32 xdp_flags);
> +
>  struct xsk_socket_config {
>  	__u32 rx_size;
>  	__u32 tx_size;
> @@ -219,13 +222,13 @@ int xsk_umem__create(struct xsk_umem **umem,
>  		     struct xsk_ring_cons *comp,
>  		     const struct xsk_umem_config *config);
>  int xsk_socket__create(struct xsk_socket **xsk,
> -		       const char *ifname, __u32 queue_id,
> +		       int ifindex, __u32 queue_id,
>  		       struct xsk_umem *umem,
>  		       struct xsk_ring_cons *rx,
>  		       struct xsk_ring_prod *tx,
>  		       const struct xsk_socket_config *config);
>  int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
> -			      const char *ifname,
> +			      int ifindex,
>  			      __u32 queue_id, struct xsk_umem *umem,
>  			      struct xsk_ring_cons *rx,
>  			      struct xsk_ring_prod *tx,
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 0aaf2f0a9d75..5f22ee88a523 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -268,6 +268,11 @@ static void gen_udp_csum(struct udphdr *udp_hdr, struct iphdr *ip_hdr)
>  	    udp_csum(ip_hdr->saddr, ip_hdr->daddr, UDP_PKT_SIZE, IPPROTO_UDP, (u16 *)udp_hdr);
>  }
>  
> +static u32 mode_to_xdp_flags(enum test_mode mode)
> +{
> +	return (mode == TEST_MODE_SKB) ? XDP_FLAGS_SKB_MODE : XDP_FLAGS_DRV_MODE;
> +}
> +
>  static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size)
>  {
>  	struct xsk_umem_config cfg = {
> @@ -329,7 +334,7 @@ static int __xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_i
>  
>  	txr = ifobject->tx_on ? &xsk->tx : NULL;
>  	rxr = ifobject->rx_on ? &xsk->rx : NULL;
> -	return xsk_socket__create(&xsk->xsk, ifobject->ifname, 0, umem->umem, rxr, txr, &cfg);
> +	return xsk_socket__create(&xsk->xsk, ifobject->ifindex, 0, umem->umem, rxr, txr, &cfg);
>  }
>  
>  static bool ifobj_zc_avail(struct ifobject *ifobject)
> @@ -359,8 +364,7 @@ static bool ifobj_zc_avail(struct ifobject *ifobject)
>  	xsk = calloc(1, sizeof(struct xsk_socket_info));
>  	if (!xsk)
>  		goto out;
> -	ifobject->xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> -	ifobject->xdp_flags |= XDP_FLAGS_DRV_MODE;
> +	ifobject->xdp_flags = XDP_FLAGS_DRV_MODE;
>  	ifobject->bind_flags = XDP_USE_NEED_WAKEUP | XDP_ZEROCOPY;
>  	ifobject->rx_on = true;
>  	xsk->rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
> @@ -432,6 +436,11 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
>  
>  			sptr = strndupa(optarg, strlen(optarg));
>  			memcpy(ifobj->ifname, strsep(&sptr, ","), MAX_INTERFACE_NAME_CHARS);
> +
> +			ifobj->ifindex = if_nametoindex(ifobj->ifname);
> +			if (!ifobj->ifindex)
> +				exit_with_error(errno);
> +
>  			interface_nb++;
>  			break;
>  		case 'D':
> @@ -512,12 +521,6 @@ static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
>  	for (i = 0; i < MAX_INTERFACES; i++) {
>  		struct ifobject *ifobj = i ? ifobj_rx : ifobj_tx;
>  
> -		ifobj->xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> -		if (mode == TEST_MODE_SKB)
> -			ifobj->xdp_flags |= XDP_FLAGS_SKB_MODE;
> -		else
> -			ifobj->xdp_flags |= XDP_FLAGS_DRV_MODE;
> -
>  		ifobj->bind_flags = XDP_USE_NEED_WAKEUP;
>  		if (mode == TEST_MODE_ZC)
>  			ifobj->bind_flags |= XDP_ZEROCOPY;
> @@ -1254,7 +1257,8 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
>  	u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
>  	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
>  	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
> -	int ret, ifindex;
> +	u32 queue_id = 0;
> +	int ret, fd;
>  	void *bufs;
>  
>  	if (ifobject->umem->unaligned_mode)
> @@ -1280,31 +1284,8 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
>  	if (!ifobject->rx_on)
>  		return;
>  
> -	ifindex = if_nametoindex(ifobject->ifname);
> -	if (!ifindex)
> -		exit_with_error(errno);
> -
> -	ret = xsk_setup_xdp_prog_xsk(ifobject->xsk->xsk, &ifobject->xsk_map_fd);
> -	if (ret)
> -		exit_with_error(-ret);
> -
> -	ret = bpf_xdp_query(ifindex, ifobject->xdp_flags, &opts);
> -	if (ret)
> -		exit_with_error(-ret);
> -
> -	if (ifobject->xdp_flags & XDP_FLAGS_SKB_MODE) {
> -		if (opts.attach_mode != XDP_ATTACHED_SKB) {
> -			ksft_print_msg("ERROR: [%s] XDP prog not in SKB mode\n");
> -			exit_with_error(EINVAL);
> -		}
> -	} else if (ifobject->xdp_flags & XDP_FLAGS_DRV_MODE) {
> -		if (opts.attach_mode != XDP_ATTACHED_DRV) {
> -			ksft_print_msg("ERROR: [%s] XDP prog not in DRV mode\n");
> -			exit_with_error(EINVAL);
> -		}
> -	}
> -
> -	ret = xsk_socket__update_xskmap(ifobject->xsk->xsk, ifobject->xsk_map_fd);
> +	fd = xsk_socket__fd(ifobject->xsk->xsk);
> +	ret = bpf_map_update_elem(ifobject->xsk_map_fd, &queue_id, &fd, 0);
>  	if (ret)
>  		exit_with_error(errno);
>  }
> @@ -1338,15 +1319,19 @@ static void *worker_testapp_validate_rx(void *arg)
>  {
>  	struct test_spec *test = (struct test_spec *)arg;
>  	struct ifobject *ifobject = test->ifobj_rx;
> +	int id = 0, err, fd = xsk_socket__fd(ifobject->xsk->xsk);
>  	struct pollfd fds = { };
> -	int id = 0;
> -	int err;
> +	u32 queue_id = 0;

move up to pretend like we care about RCT?

>  
>  	if (test->current_step == 1) {
>  		thread_common_ops(test, ifobject);
>  	} else {
>  		bpf_map_delete_elem(ifobject->xsk_map_fd, &id);
> -		xsk_socket__update_xskmap(ifobject->xsk->xsk, ifobject->xsk_map_fd);
> +		err = bpf_map_update_elem(ifobject->xsk_map_fd, &queue_id, &fd, 0);
> +		if (err) {
> +			printf("Error: Failed to update xskmap, error %s\n", strerror(err));
> +			exit_with_error(err);
> +		}
>  	}
>  
>  	fds.fd = xsk_socket__fd(ifobject->xsk->xsk);
> @@ -1415,7 +1400,10 @@ static int testapp_validate_traffic_single_thread(struct test_spec *test, struct
>  	pthread_join(t0, NULL);
>  
>  	if (test->total_steps == test->current_step || test->fail) {
> +		u32 queue_id = 0;
> +
>  		xsk_socket__delete(ifobj->xsk->xsk);
> +		bpf_map_delete_elem(ifobj->xsk_map_fd, &queue_id);
>  		testapp_clean_xsk_umem(ifobj);
>  	}
>  
> @@ -1504,14 +1492,14 @@ static void testapp_bidi(struct test_spec *test)
>  
>  static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj_rx)
>  {
> -	int ret;
> +	int ret, queue_id = 0, fd = xsk_socket__fd(ifobj_rx->xsk->xsk);
>  
>  	xsk_socket__delete(ifobj_tx->xsk->xsk);
>  	xsk_socket__delete(ifobj_rx->xsk->xsk);
>  	ifobj_tx->xsk = &ifobj_tx->xsk_arr[1];
>  	ifobj_rx->xsk = &ifobj_rx->xsk_arr[1];
>  
> -	ret = xsk_socket__update_xskmap(ifobj_rx->xsk->xsk, ifobj_rx->xsk_map_fd);
> +	ret = bpf_map_update_elem(ifobj_rx->xsk_map_fd, &queue_id, &fd, 0);
>  	if (ret)
>  		exit_with_error(errno);
>  }
> @@ -1675,8 +1663,9 @@ static void testapp_invalid_desc(struct test_spec *test)
>  
>  static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
>  		       const char *dst_ip, const char *src_ip, const u16 dst_port,
> -		       const u16 src_port, thread_func_t func_ptr)
> +		       const u16 src_port, thread_func_t func_ptr, bool load_xdp)
>  {
> +	int xsk_map_fd, prog_fd, err;
>  	struct in_addr ip;
>  
>  	memcpy(ifobj->dst_mac, dst_mac, ETH_ALEN);
> @@ -1692,6 +1681,24 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
>  	ifobj->src_port = src_port;
>  
>  	ifobj->func_ptr = func_ptr;
> +
> +	if (!load_xdp)
> +		return;
> +
> +	err = xsk_load_xdp_program(&xsk_map_fd, &prog_fd);
> +	if (err) {
> +		printf("Error loading XDP program\n");
> +		exit_with_error(err);
> +	}
> +
> +	ifobj->xsk_map_fd = xsk_map_fd;
> +	ifobj->prog_fd = prog_fd;
> +	ifobj->xdp_flags = mode_to_xdp_flags(TEST_MODE_SKB);

Are you going to have other callsites of mode_to_xdp_flags() ?
Currently there is only this single usage which probably could be replaced
with explicit XDP_FLAGS_SKB_MODE.

> +	ifobj->link_fd = xsk_attach_xdp_program(ifobj->ifindex, prog_fd, ifobj->xdp_flags);
> +	if (ifobj->link_fd < 0) {
> +		printf("Error attaching XDP program\n");
> +		exit_with_error(ifobj->link_fd);
> +	}
>  }
>  
>  static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_type type)
> @@ -1826,12 +1833,15 @@ static struct ifobject *ifobject_create(void)
>  
>  static void ifobject_delete(struct ifobject *ifobj)
>  {
> +	close(ifobj->prog_fd);
> +	close(ifobj->xsk_map_fd);
> +
>  	free(ifobj->umem);
>  	free(ifobj->xsk_arr);
>  	free(ifobj);
>  }
>  
> -static bool is_xdp_supported(struct ifobject *ifobject)
> +static bool is_xdp_supported(int ifindex)
>  {
>  	int flags = XDP_FLAGS_DRV_MODE;
>  
> @@ -1840,7 +1850,6 @@ static bool is_xdp_supported(struct ifobject *ifobject)
>  		BPF_MOV64_IMM(BPF_REG_0, XDP_PASS),
>  		BPF_EXIT_INSN()
>  	};
> -	int ifindex = if_nametoindex(ifobject->ifname);
>  	int prog_fd, insn_cnt = ARRAY_SIZE(insns);
>  	int err;
>  
> @@ -1860,6 +1869,29 @@ static bool is_xdp_supported(struct ifobject *ifobject)
>  	return true;
>  }
>  
> +static void change_to_drv_mode(struct ifobject *ifobj)
> +{
> +	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
> +	int ret;
> +
> +	close(ifobj->link_fd);
> +	ifobj->link_fd = xsk_attach_xdp_program(ifobj->ifindex, ifobj->prog_fd,
> +						XDP_FLAGS_DRV_MODE);
> +	if (ifobj->link_fd < 0) {
> +		printf("Error attaching XDP program\n");

Nit: ksft_print_msg or we don't care?

> +		exit_with_error(-ifobj->link_fd);
> +	}
> +
> +	ret = bpf_xdp_query(ifobj->ifindex, XDP_FLAGS_DRV_MODE, &opts);
> +	if (ret)
> +		exit_with_error(errno);
> +
> +	if (opts.attach_mode != XDP_ATTACHED_DRV) {
> +		ksft_print_msg("ERROR: [%s] XDP prog not in DRV mode\n");

Aren't you missing the thing to print out for %s format specifier?
I thought that ksft_print_msg() is doing something with that under the
hood, but apparently it's not the case.

> +		exit_with_error(EINVAL);
> +	}
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	struct pkt_stream *rx_pkt_stream_default;
> @@ -1868,7 +1900,7 @@ int main(int argc, char **argv)
>  	int modes = TEST_MODE_SKB + 1;
>  	u32 i, j, failed_tests = 0;
>  	struct test_spec test;
> -	bool shared_umem;
> +	bool shared_netdev;
>  
>  	/* Use libbpf 1.0 API mode */
>  	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
> @@ -1883,27 +1915,27 @@ int main(int argc, char **argv)
>  	setlocale(LC_ALL, "");
>  
>  	parse_command_line(ifobj_tx, ifobj_rx, argc, argv);
> -	shared_umem = !strcmp(ifobj_tx->ifname, ifobj_rx->ifname);
>  
> -	ifobj_tx->shared_umem = shared_umem;
> -	ifobj_rx->shared_umem = shared_umem;
> +	shared_netdev = (ifobj_tx->ifindex == ifobj_rx->ifindex);
> +	ifobj_tx->shared_umem = shared_netdev;
> +	ifobj_rx->shared_umem = shared_netdev;

Hmm looks bit odd. I'd keep shared_umem as local var here or update the
name in struct as well.

>  
>  	if (!validate_interface(ifobj_tx) || !validate_interface(ifobj_rx)) {
>  		usage(basename(argv[0]));
>  		ksft_exit_xfail();
>  	}
>  
> -	init_iface(ifobj_tx, MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2,
> -		   worker_testapp_validate_tx);
> -	init_iface(ifobj_rx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
> -		   worker_testapp_validate_rx);
> -
> -	if (is_xdp_supported(ifobj_tx)) {
> +	if (is_xdp_supported(ifobj_tx->ifindex)) {
>  		modes++;
>  		if (ifobj_zc_avail(ifobj_tx))
>  			modes++;
>  	}
>  
> +	init_iface(ifobj_rx, MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2,
> +		   worker_testapp_validate_rx, true);
> +	init_iface(ifobj_tx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
> +		   worker_testapp_validate_tx, !shared_netdev);
> +
>  	test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
>  	tx_pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
>  	rx_pkt_stream_default = pkt_stream_generate(ifobj_rx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
> @@ -1914,7 +1946,13 @@ int main(int argc, char **argv)
>  
>  	ksft_set_plan(modes * TEST_TYPE_MAX);
>  
> -	for (i = 0; i < modes; i++)
> +	for (i = 0; i < modes; i++) {
> +		if (i == TEST_MODE_DRV) {
> +			change_to_drv_mode(ifobj_rx);
> +			if (!shared_netdev)
> +				change_to_drv_mode(ifobj_tx);
> +		}
> +
>  		for (j = 0; j < TEST_TYPE_MAX; j++) {
>  			test_spec_init(&test, ifobj_tx, ifobj_rx, i);
>  			run_pkt_test(&test, i, j);
> @@ -1923,6 +1961,7 @@ int main(int argc, char **argv)
>  			if (test.fail)
>  				failed_tests++;
>  		}
> +	}
>  
>  	pkt_stream_delete(tx_pkt_stream_default);
>  	pkt_stream_delete(rx_pkt_stream_default);
> diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> index dcb908f5bb4c..b2ba877b1966 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.h
> +++ b/tools/testing/selftests/bpf/xskxceiver.h
> @@ -139,6 +139,9 @@ struct ifobject {
>  	validation_func_t validation_func;
>  	struct pkt_stream *pkt_stream;
>  	int xsk_map_fd;
> +	int prog_fd;
> +	int link_fd;
> +	int ifindex;
>  	u32 dst_ip;
>  	u32 src_ip;
>  	u32 xdp_flags;
> -- 
> 2.34.1
> 
