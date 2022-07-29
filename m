Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A085851DF
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 16:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234333AbiG2O4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 10:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237283AbiG2O4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 10:56:30 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9822B7FE49;
        Fri, 29 Jul 2022 07:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659106586; x=1690642586;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JjYsIIth3VReWwLvNhUq4ud8SJcp+Ar96YRCAGDJqWU=;
  b=AXAiDqrUu0Tkd6Xk2ZxbCL1Z5pfNUtunVjUHaz0b/GjveC/kKzqi6ipu
   ihVouy9N6THUlcpdJhhcnsnXrfcTN/tiuWAR8NFZ/mfewvS9sSfNkok9o
   AMp1px1bu88g5+gVvrSfV1VDqdXe/oSW8O+LY/V1osIycEOjHZX6+J+Ro
   bPghyemhpAZZhUcUhDIJxMJQVExVpxWb4EBLInp5/rQfPfVMmIq/Nabob
   i4ErJHM6lwz8pIyHI4bvbXM6naSUkio1uvqCgWThPrjs1S3x3yc1jkutu
   J6/PdevQ9/fqSk5OezPyuhiH/ECWgrCKqFi1QTV754kWf9DIUcfE/D8FS
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="269164679"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="269164679"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 07:56:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="727765184"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga004.jf.intel.com with ESMTP; 29 Jul 2022 07:56:25 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 07:56:24 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 07:56:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 29 Jul 2022 07:56:24 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 29 Jul 2022 07:55:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AbFnwz2rmZj88FrQ/6VFvY4T/uSoIHCnbUr3nqv2C8AZujdwkMEIzgrMyx+BL4GC3b28dEt4j9C1cRu0M61S6B4OKHOQ4QtbVVVjiz7DzPUhF/KwAyuvvCrkfvTDWCOUPZopCUzscU4qxTGBEmMbiJlWoOQx+by9U1Y/t/nlgWNgJYCjXgQmx5SjGna7DwCTpj7EGr7ET/9XgcLRJnjJvAEp/QhEFNu2fsEMd7/qCiM4vX1termCUBzuCTcIA0Bpy8hrQWcesmp0EIUufA+dTR4IIPmMJxx/JW8z8e3g7jUvhJ5enSCi6GO9TchsvhknU2qy8r196tW2OuUV49LxHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t3ttX8HWvHyKel+oT+ggBrVuDlZx3qtuGLGXWQIU9Dg=;
 b=NuXBZrA9nGJQJuqoFZ49FyxmC6zWoVB86zSG64bizWcMLxUJ7LLShKtNljYj6WKhxZeExCqvzDZnIF6BzMUOFIqSJgzhYx810/HhRxxIOd9d+pVqHP0lfWMZcJuasxTYdfMe2MSl5mRyf0iOB1TTqlmls+JuUwfxcgHF90wjklc/rm7ZIqXV5xQqgmySNK7WwHruyezAEVqEj9GCp92NESySY504UGnNgYhEGwSDQAEXo8J2QAzbZINAErgJiCqYQw3UoJfK8P+C8Lo3qRD7UgmtNs0TW2c0MRP3SE8hwm7ebLYrGEarY2gta5exOIK9lMQK73EneRkdhV04nxxN4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ0PR11MB5814.namprd11.prod.outlook.com (2603:10b6:a03:423::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Fri, 29 Jul
 2022 14:55:41 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9cba:7299:ab7d:b669]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9cba:7299:ab7d:b669%9]) with mapi id 15.20.5482.012; Fri, 29 Jul 2022
 14:55:41 +0000
Date:   Fri, 29 Jul 2022 16:55:28 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <magnus.karlsson@intel.com>,
        <bjorn@kernel.org>, <kuba@kernel.org>, <andrii@kernel.org>,
        <ciara.loftus@intel.com>
Subject: Re: [PATCH bpf-next v3] selftests: xsk: Update poll test cases
Message-ID: <YuP04F3bC5dSI+zJ@boxer>
References: <20220729132337.211443-1-shibin.koikkara.reeny@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220729132337.211443-1-shibin.koikkara.reeny@intel.com>
X-ClientProxiedBy: LO4P265CA0150.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::10) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c82b6cc-9c28-4bd2-9e5b-08da717267bf
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5814:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IbAekTF1b0ws940tKjGpTKsRc5L595l0VyrBZ9gBWKMSTFk6Dbft7CpF8hDSKrwoIPOei5UAebmkGMWD6oB3Taz5NvB9hxgGmecxoo+oilnwd5MtrbzJTFJuwyc3KuVEmAM7ra3ISXQ2fvAgKGqnx9F7KrpgzFDDJHt7kA0FLWQjTr3dusS1DTJCNRFiumeGiv376FlzqQ6nORwecK0c12bH/kPxS0/4d8gcTF6md6VPfIuAD5priL1Bybe8KugLam8RqrAlmrTSKZTEW19J3TfPjkvkdWVh73UcfvNVmG6MCbHdtxLRzL+mbaPmmyXNNuAjWcstrM1P7s/adi4Ird7qnXlQLqRDsDYUzsELZiskkNP4rGLshPjbMsmNTYjQdF4RXRfiTSfyOPPzHX6OP6c1QyzUXhKg9vim4f5t9gz9D8WCbqCgvnQRWZJKLSmFpvgTPA/bknwy2tYY3sl7YWmaJRE5mywtnv5g6mGPgvwivNXEaQ0DtoVnK496ZoHOt4tHulg11Wx3SwutSGHvVksrkBOjswii3YX++lhOHPf3XFn34L0zis5adaGQ+ui6Zb1GDpb8DwklgLPCHrTapjjPde77I8TQNLEjmcquVKZ9NQZQc33K/vsGgh61esLBeOTX5vzfpoTOJUDNPSEHR2mbkuzga6Yzu+LP2wxPQiBrYSNlnko74nGN2pQ7FZckQwk/NGBy2kJCAy7WlIPibRPfFdKGXlP2vxv6RAQaC0M72HvAkmI8RTeX1qipOyWAY6NShSu3PY7F3FGQ/JR0amWFtMWtZQmWC6GaftYndu3I2hmhT+ANzBfm9Xu5Gh1a/0J8A//IV0c/+9YPck7HkN26fn0eTkuhCSkKWC8u6PeNxHXMPtnfAhGgWhbGRFjAryrI31KgmRE+PEkYPYkgBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(396003)(346002)(39860400002)(376002)(366004)(6506007)(26005)(6486002)(41300700001)(9686003)(107886003)(6512007)(478600001)(82960400001)(83380400001)(186003)(966005)(38100700002)(2906002)(316002)(30864003)(8936002)(6666004)(6636002)(33716001)(44832011)(66556008)(8676002)(15650500001)(5660300002)(66946007)(66476007)(86362001)(6862004)(4326008)(67856001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G2a0KADMd5M0rF/uqruqcaYnD7n7zbkCAiTeAVWIYjy8PuoAi2hBPBStMRNI?=
 =?us-ascii?Q?F/RH/WkpIe75prtTKpnaG4F/rbZLWJGILvBznAaiQ77asAzcHUgdifih3WUr?=
 =?us-ascii?Q?ZgpKvkwu4w+Et8AiOA6l27t0j00wtW07Hiw9ipkerh/IbCdeaBGN1cVPIuWy?=
 =?us-ascii?Q?yU8MamOWvkxBzP64g8rp8Sylab5tuFaFpLSc+32Zd+H7gLpiKs5+QQCjvk2d?=
 =?us-ascii?Q?e+3vM2DBRmZQwV6c1sqqSgkvWEBiHDXKzX4xiHWgJdvCuHFAfPWRA7nD5trj?=
 =?us-ascii?Q?pIok72FPyJzY00j6g+D036HIet5cdIdPALu0HlRedNUfqGAVj1FjhPZZP+g6?=
 =?us-ascii?Q?Rb8jQWsnTrIp9Q21jwSTvqUwbh2elG3MVXqZg6AvvkQDiIfJdueyhuHfQMrZ?=
 =?us-ascii?Q?8vBJSFF0oZdOnyswwH3MpcKX1DfYVLXWqfscV6H1BMcKDA9PBM48s9MfEuTI?=
 =?us-ascii?Q?OTVoXRqlCHCsnLTAMdsi9oYTJdAJRGqng7k931VW6RVBL0PxTFITmK0ls+1F?=
 =?us-ascii?Q?8wcrHNV01z5nBn6iovIdJGESU2bIMZODXhfze9GaMjkDr/IpXQUycBh/p3Ee?=
 =?us-ascii?Q?wmnciS3diDiwPjPhT/18WCDXkl2MLjt9kmg6dg8c3DJQjVgD+9iRjXZdEKsP?=
 =?us-ascii?Q?eoC8BZhvoWO0e1NVoXlJX4rGC6WYHu92p0o9+8MjNkIQeQjGZ1GTL9Yah558?=
 =?us-ascii?Q?ReM8RKrAy+hwCFNmFNSacnuqIJ5faIpDHVS9AKy2mZl6vgeDACHN7Gh5/ohP?=
 =?us-ascii?Q?MTbkx/4lyet+9mdaBkXkzGER2gzYk1XxHw3L8Z2mzMHfJfy3XK0FnKSc6LR6?=
 =?us-ascii?Q?gmF7dUpQnSjhAMpIK+Bz+Z4eTFI4hf7dBztKhillPRzzn538ozAM21zJGiNU?=
 =?us-ascii?Q?62OaW5Hy5btxKfgWfR2pVOCl/s/JC4l01s64+0vGpSVGtEvJSy0MZGZTOARf?=
 =?us-ascii?Q?fBImwMMRnTzIyrB3OJzkd0dBUN7NPPgbgN/M3UFOBxHw2KQ5UtGveAeK/8mO?=
 =?us-ascii?Q?FWefk68WcEPa1F5comnm2eKQ+mE317NTrmZKZi8YGwQ1X2eP27aRZ6NdzOwx?=
 =?us-ascii?Q?AJx7Q3GiSkfJ6/psxtGkm3kGIXZaQCE0xSpds58d6dQ+LYbESslrquurgpEB?=
 =?us-ascii?Q?XUiVLGgkVgnDmkCwaXspazJTgGB7M6sR7x/O502Ffb312HWAouA/o89qeQ93?=
 =?us-ascii?Q?p4cZtcR6dpvFQ+19xJofdHZgxAPctaCGjOK9/2XxMJRAf4eBNPXv2lLT9/0N?=
 =?us-ascii?Q?BWDZLPtk8/01Il9uG07gC1L+BOQrFK3VfbnF9aGEKVaVQ6I+eEy5/fH7Up27?=
 =?us-ascii?Q?8wJg27RKRtGtkG/TbxjeRKKj7myr8mTU9WcQsUrbpwMZOAZq+8fshKKowsd3?=
 =?us-ascii?Q?AeblCgjK91fC4oQ+8qKDo81lAJ6rL9l4YC+YG6DssnRTNaP3BSXYEQVf4ePS?=
 =?us-ascii?Q?mqIfVqznLPmPncjySBOJl0sRfow4lwWHxDoxVVP/LdxcQFmNKjkiPduUBkrP?=
 =?us-ascii?Q?VARlEl424bDLjO9+MT/iddrwGS5GP6+bwd7Xk/VIvTne2WV9tnkWw5l3pE3z?=
 =?us-ascii?Q?CiR5bxmv4f6QxsX5GMPCHffq57dyw0cq3IQbwsKznGxX8URF9yFrpNralSoq?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c82b6cc-9c28-4bd2-9e5b-08da717267bf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 14:55:41.2010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1RcUhPDvzjJ1K10QgKvMtnXhx8bcERK/WsxN/LKFXjJvEdB4funIH2RPoCCbBxhNmF+l34UyscJgHS5q/21s7QZj1j6WHnqqJYkWjH0TMHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5814
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 01:23:37PM +0000, Shibin Koikkara Reeny wrote:
> Poll test case was not testing all the functionality
> of the poll feature in the testsuite. This patch
> update the poll test case which contain 2 testcases to
> test the RX and the TX poll functionality and additional
> 2 more testcases to check the timeout features of the
> poll event.
> 
> Poll testsuite have 4 test cases:
> 
> 1. TEST_TYPE_RX_POLL:
> Check if RX path POLLIN function work as expect. TX path
> can use any method to sent the traffic.
> 
> 2. TEST_TYPE_TX_POLL:
> Check if TX path POLLOUT function work as expect. RX path
> can use any method to receive the traffic.
> 
> 3. TEST_TYPE_POLL_RXQ_EMPTY:
> Call poll function with parameter POLLIN on empty rx queue
> will cause timeout.If return timeout then test case is pass.
> 
> 4. TEST_TYPE_POLL_TXQ_FULL:
> When txq is filled and packets are not cleaned by the kernel
> then if we invoke the poll function with POLLOUT then it
> should trigger timeout.
> 
> v1: https://lore.kernel.org/bpf/20220718095712.588513-1-shibin.koikkara.reeny@intel.com/
> v2: https://lore.kernel.org/bpf/20220726101723.250746-1-shibin.koikkara.reeny@intel.com/
> 
> Changes in v2:
>  * Updated the commit message
>  * fixed the while loop flow in receive_pkts function.
> Changes in v3:
>  * Introduced single thread validation function.
>  * Removed pkt_stream_invalid().
>  * Updated TEST_TYPE_POLL_TXQ_FULL testcase to create invalid frame.
>  * Removed timer from send_pkts().

Hmm, so timer is not needed for tx side? Is it okay to remove it
altogether? I only meant to pull it out to preceding patch.

>  * Removed boolean variable skip_rx and skip_tx
> 
> Signed-off-by: Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 155 +++++++++++++++++------
>  tools/testing/selftests/bpf/xskxceiver.h |   8 +-
>  2 files changed, 125 insertions(+), 38 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 74d56d971baf..32ba6464f29f 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -817,9 +817,9 @@ static int complete_pkts(struct xsk_socket_info *xsk, int batch_size)
>  	return TEST_PASS;
>  }
>  
> -static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
> +static int receive_pkts(struct test_spec *test, struct ifobject *ifobj, struct pollfd *fds)

Nit : I think that we could skip passing ifobj explicitly if we're passing
test_spec itself and just work on

	struct ifobject *ifobj = test->ifobj_rx;

within the function.

>  {
> -	struct timeval tv_end, tv_now, tv_timeout = {RECV_TMOUT, 0};
> +	struct timeval tv_end, tv_now, tv_timeout = {THREAD_TMOUT, 0};
>  	u32 idx_rx = 0, idx_fq = 0, rcvd, i, pkts_sent = 0;
>  	struct pkt_stream *pkt_stream = ifobj->pkt_stream;
>  	struct xsk_socket_info *xsk = ifobj->xsk;
> @@ -843,17 +843,28 @@ static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
>  		}
>  
>  		kick_rx(xsk);
> +		if (ifobj->use_poll) {
> +			ret = poll(fds, 1, POLL_TMOUT);
> +			if (ret < 0)
> +				exit_with_error(-ret);
> +
> +			if (!ret) {
> +				if (!test->ifobj_tx->umem->umem)
> +					return TEST_PASS;
> +
> +				ksft_print_msg("ERROR: [%s] Poll timed out\n", __func__);
> +				return TEST_FAILURE;
>  
> -		rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> -		if (!rcvd) {
> -			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
> -				ret = poll(fds, 1, POLL_TMOUT);
> -				if (ret < 0)
> -					exit_with_error(-ret);
>  			}
> -			continue;
> +
> +			if (!(fds->revents & POLLIN))
> +				continue;
>  		}
>  
> +		rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> +		if (!rcvd)
> +			continue;
> +
>  		if (ifobj->use_fill_ring) {
>  			ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
>  			while (ret != rcvd) {
> @@ -900,13 +911,34 @@ static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
>  	return TEST_PASS;
>  }
>  
> -static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
> +static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, bool use_poll,
> +		       struct pollfd *fds, bool timeout)
>  {
>  	struct xsk_socket_info *xsk = ifobject->xsk;
> -	u32 i, idx, valid_pkts = 0;
> +	u32 i, idx, ret, valid_pkts = 0;
> +
> +	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE) {
> +		if (use_poll) {
> +			ret = poll(fds, 1, POLL_TMOUT);
> +			if (timeout) {
> +				if (ret < 0) {
> +					ksft_print_msg("ERROR: [%s] Poll error %d\n",
> +						       __func__, ret);
> +					return TEST_FAILURE;
> +				}
> +				if (ret == 0)
> +					return TEST_PASS;
> +				break;
> +			}
> +			if (ret <= 0) {
> +				ksft_print_msg("ERROR: [%s] Poll error %d\n",
> +					       __func__, ret);
> +				return TEST_FAILURE;
> +			}
> +		}
>  
> -	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE)
>  		complete_pkts(xsk, BATCH_SIZE);
> +	}
>  
>  	for (i = 0; i < BATCH_SIZE; i++) {
>  		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i);
> @@ -933,11 +965,27 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
>  
>  	xsk_ring_prod__submit(&xsk->tx, i);
>  	xsk->outstanding_tx += valid_pkts;
> -	if (complete_pkts(xsk, i))
> -		return TEST_FAILURE;
>  
> -	usleep(10);
> -	return TEST_PASS;
> +	if (use_poll) {
> +		ret = poll(fds, 1, POLL_TMOUT);
> +		if (ret <= 0) {
> +			if (ret == 0 && timeout)
> +				return TEST_PASS;
> +
> +			ksft_print_msg("ERROR: [%s] Poll error %d\n", __func__, ret);
> +			return TEST_FAILURE;
> +		}
> +	}
> +
> +	if (!timeout) {
> +		if (complete_pkts(xsk, i))
> +			return TEST_FAILURE;
> +
> +		usleep(10);
> +		return TEST_PASS;
> +	}
> +
> +	return TEST_CONTINUE;
>  }
>  
>  static void wait_for_tx_completion(struct xsk_socket_info *xsk)
> @@ -948,29 +996,19 @@ static void wait_for_tx_completion(struct xsk_socket_info *xsk)
>  
>  static int send_pkts(struct test_spec *test, struct ifobject *ifobject)
>  {
> +	bool timeout = (!test->ifobj_rx->umem->umem) ? true : false;

normally instead of such ternary operator to test if some ptr is NULL or
not we would do:

static bool is_umem_valid(struct ifobject *ifobj)
{
	return !!ifobj->umem->umem;
}

	bool timeout = !is_umem_valid(test->ifobj_rx);

but I think this can stay as is.


>  	struct pollfd fds = { };
> -	u32 pkt_cnt = 0;
> +	u32 pkt_cnt = 0, ret;
>  
>  	fds.fd = xsk_socket__fd(ifobject->xsk->xsk);
>  	fds.events = POLLOUT;
>  
>  	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
> -		int err;
> -
> -		if (ifobject->use_poll) {
> -			int ret;
> -
> -			ret = poll(&fds, 1, POLL_TMOUT);
> -			if (ret <= 0)
> -				continue;
> -
> -			if (!(fds.revents & POLLOUT))
> -				continue;
> -		}
> -
> -		err = __send_pkts(ifobject, &pkt_cnt);
> -		if (err || test->fail)
> +		ret = __send_pkts(ifobject, &pkt_cnt, ifobject->use_poll, &fds, timeout);

could you avoid passing ifobject->use_poll explicitly?

> +		if ((ret || test->fail) && !timeout)
>  			return TEST_FAILURE;
> +		else if (ret == TEST_PASS && timeout)
> +			return ret;
>  	}
>  
>  	wait_for_tx_completion(ifobject->xsk);
> @@ -1235,7 +1273,7 @@ static void *worker_testapp_validate_rx(void *arg)
>  
>  	pthread_barrier_wait(&barr);
>  
> -	err = receive_pkts(ifobject, &fds);
> +	err = receive_pkts(test, ifobject, &fds);
>  
>  	if (!err && ifobject->validation_func)
>  		err = ifobject->validation_func(ifobject);
> @@ -1251,6 +1289,33 @@ static void *worker_testapp_validate_rx(void *arg)
>  	pthread_exit(NULL);
>  }
>  
> +static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj,
> +						  enum test_type type)
> +{
> +	pthread_t t0;
> +
> +	if (pthread_barrier_init(&barr, NULL, 2))
> +		exit_with_error(errno);
> +
> +	test->current_step++;
> +	if (type  == TEST_TYPE_POLL_RXQ_TMOUT)
> +		pkt_stream_reset(ifobj->pkt_stream);
> +	pkts_in_flight = 0;
> +
> +	/*Spawn thread */
> +	pthread_create(&t0, NULL, ifobj->func_ptr, test);
> +
> +	if (type  != TEST_TYPE_POLL_TXQ_TMOUT)

nit: double space before !=

> +		pthread_barrier_wait(&barr);
> +
> +	if (pthread_barrier_destroy(&barr))
> +		exit_with_error(errno);
> +
> +	pthread_join(t0, NULL);
> +
> +	return !!test->fail;
> +}

I like this better as it serves its purpose and testapp_validate_traffic()
stays cleaner. Thanks!

> +
>  static int testapp_validate_traffic(struct test_spec *test)
>  {
>  	struct ifobject *ifobj_tx = test->ifobj_tx;
> @@ -1548,12 +1613,30 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
>  
>  		pkt_stream_restore_default(test);
>  		break;
> -	case TEST_TYPE_POLL:
> -		test->ifobj_tx->use_poll = true;
> +	case TEST_TYPE_RX_POLL:
>  		test->ifobj_rx->use_poll = true;
> -		test_spec_set_name(test, "POLL");
> +		test_spec_set_name(test, "POLL_RX");
> +		testapp_validate_traffic(test);
> +		break;
> +	case TEST_TYPE_TX_POLL:
> +		test->ifobj_tx->use_poll = true;
> +		test_spec_set_name(test, "POLL_TX");
>  		testapp_validate_traffic(test);
>  		break;
> +	case TEST_TYPE_POLL_TXQ_TMOUT:
> +		test_spec_set_name(test, "POLL_TXQ_FULL");
> +		test->ifobj_tx->use_poll = true;
> +		/* create invalid frame by set umem frame_size and pkt length equal to 2048 */
> +		test->ifobj_tx->umem->frame_size = 2048;
> +		pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
> +		testapp_validate_traffic_single_thread(test, test->ifobj_tx, type);
> +		pkt_stream_restore_default(test);
> +		break;
> +	case TEST_TYPE_POLL_RXQ_TMOUT:
> +		test_spec_set_name(test, "POLL_RXQ_EMPTY");
> +		test->ifobj_rx->use_poll = true;
> +		testapp_validate_traffic_single_thread(test, test->ifobj_rx, type);
> +		break;
>  	case TEST_TYPE_ALIGNED_INV_DESC:
>  		test_spec_set_name(test, "ALIGNED_INV_DESC");
>  		testapp_invalid_desc(test);
> diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> index 3d17053f98e5..ee97576757a9 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.h
> +++ b/tools/testing/selftests/bpf/xskxceiver.h
> @@ -27,6 +27,7 @@
>  
>  #define TEST_PASS 0
>  #define TEST_FAILURE -1
> +#define TEST_CONTINUE 1
>  #define MAX_INTERFACES 2
>  #define MAX_INTERFACE_NAME_CHARS 7
>  #define MAX_INTERFACES_NAMESPACE_CHARS 10
> @@ -48,7 +49,7 @@
>  #define SOCK_RECONF_CTR 10
>  #define BATCH_SIZE 64
>  #define POLL_TMOUT 1000
> -#define RECV_TMOUT 3
> +#define THREAD_TMOUT 3
>  #define DEFAULT_PKT_CNT (4 * 1024)
>  #define DEFAULT_UMEM_BUFFERS (DEFAULT_PKT_CNT / 4)
>  #define UMEM_SIZE (DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE)
> @@ -68,7 +69,10 @@ enum test_type {
>  	TEST_TYPE_RUN_TO_COMPLETION,
>  	TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME,
>  	TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT,
> -	TEST_TYPE_POLL,
> +	TEST_TYPE_RX_POLL,
> +	TEST_TYPE_TX_POLL,
> +	TEST_TYPE_POLL_RXQ_TMOUT,
> +	TEST_TYPE_POLL_TXQ_TMOUT,
>  	TEST_TYPE_UNALIGNED,
>  	TEST_TYPE_ALIGNED_INV_DESC,
>  	TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME,
> -- 
> 2.34.1
> 
