Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4356E663F99
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbjAJL5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238055AbjAJL5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:57:07 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374253F472;
        Tue, 10 Jan 2023 03:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673351824; x=1704887824;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uAA4YuzqUg3rhQTMOH5p6wGA5GUsOXfkd6wRNORMbsI=;
  b=YjzLE5tYRttp8C1puEQeDIBG3B6dtT2LYQgwGlK0HP4JYpuDurP36MNb
   Zt2Uoks9reHr3+Y3PxeKLpB1nNEdTYgkuERUEsgeufgl7CQcH2/Jt6ZJB
   MRozQH4/nROns1BgBMpOFGJ06GgNxhAvp2fe3ynWt5umq9h0QfDUcqoT7
   zFEStDA+HmoncKl7i5mVXYDnuiXlYfVWpkjdjRyaSnHQs018BhCqlz1Nd
   ledXMDVwVP2j352NxSoRoEG8f1Nvbnn1AaNxwGWbvrr0x7iVDiY+dB4aB
   msRNLeq0r8YVNwTOILvtLR+yp9vEqUBS2Dt4jWWmxI4YlyzJcZsMFf258
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="302825502"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="302825502"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 03:57:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="764706540"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="764706540"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 10 Jan 2023 03:57:02 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 03:57:02 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 03:57:02 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 03:57:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROBVl0/zEfV0j69I8f7m2sa+jRzzH80/Fe9sn3qg6ED4q0xDxcjchrFOrEP3nRv6jAl4QIPtL6eMZRMaWxuh0qccnDPX9Pfut8+yqLT7LSu+L0vTtOcw6cWfYHViN8yGvfJYeR7wGESK4Wju8N3eUGDRGZtMt1wprq7klhr7MUU30J0h9wlVAHmskgdOp4qr9UV3TBQrGM/yAAatdhO1tLEwDGqYWpvzrld8f/c6m9YaiCopEIg2AyoRwKbvcbQSC1JnEcSSjEEd6cf+ev+aGE5mvN7eTFhdZq2vNtwYcNQh7N6iTGWBcSnwhpPzLiFutu5f3fTQCg1ieHAz9rIsqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4NDyFQJK7DKplw96iSGT33HgPI36lAx5gFxcGff/PU8=;
 b=mdVVgA3l2DNY7f941d1C7yPv3zfI3+SC3P1pDX+WFGcBNvcwtjMyxFopw0TCQHfkelLyKFIMbPv8dls8iLLHuLbRA/27molQDmsd2i9c8X6iTYXJyY9QtgIxHXHdOngJ/H0PjGUnNkhriQUpchtbCbKfT67Y4zvMfnNgoRfKNm7OmIRSFMh//HEaUBvq5k4nTWGbBNajWTuI9otYxFzBBUljdj2L4vfFCG/LEZysZ8g+8IhEZSsehchT0Q8kzfozDN+w82HTNuZa8O3ra1ofFd3WSrMFmdqM/R2OR7qReGS8j2XTs5DlqK7VnUF/2hX77XkCTiD6inLNjyl4n5Y2mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BL1PR11MB5335.namprd11.prod.outlook.com (2603:10b6:208:31b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 11:56:59 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::fd3c:c9fc:5065:1a92]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::fd3c:c9fc:5065:1a92%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 11:56:59 +0000
Date:   Tue, 10 Jan 2023 12:56:44 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <yhs@fb.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <tirthendu.sarkar@intel.com>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v2 15/15] selftests/xsk: automatically switch
 XDP programs
Message-ID: <Y71SfKDE0iO7OQL8@boxer>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
 <20230104121744.2820-16-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230104121744.2820-16-magnus.karlsson@gmail.com>
X-ClientProxiedBy: FR3P281CA0135.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BL1PR11MB5335:EE_
X-MS-Office365-Filtering-Correlation-Id: f35566af-466d-4e65-23b3-08daf301c780
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +QIWsdchN0m9IL/tuU44gsIIQw75/FNBjRgH4MLBwH8prORtLRWXAAhv8bOC4mBvX9hMFeuJbDvCKEC6HMBlpRyso+BS/D6iWbrp8by/6lwe+E5cKG17CXgNwV5hDouHFt6UGL2e7kiIPqY7nt7Tz5yzYEsPjXWqPr4abFnEm4tfGmhoaYoBAt5W0pHZz7zrCqsu8fvZDWXpfvqzGAxclmW+vPRrbS8v9nleVUH7gbOnDDTbqgdjbUqHlwBKlUeDvFsGODsDP5Jx/nwg9INq15gwn8iBr1VOs/T6eY7ZFUYKhzc/w3OP8lrGCa7SZzkvUQDKQYwzVz65qDUnZUblAqT3A89xf+sU5TYI8tIag7Q+1qF2BXv+AEopUNRyI1kEDPkQ8ZezCnTSVGTFrI7ABCMd81ohPj1A0inFzYxBnGi2Gb74VuKS9zcktgXupJsGlTQ1aS0DUNtA/ZVrdWw/NNeHN4x750C/McwMbPTVtBNgNFupQzGyiliQuY5QN9Oqo2LXeu0wAga7eTx/3qjuSoX0hTxc0r97ktnwV9u3hW3RINLoNNgYfTDWhig6IphYcwDsDX/XdqACAdAf//Iv2NBmYaO9+kbQP76pSA5TaRMIB9VCfi/Z2klY9XnivWiNvM/a9XBh8jsionOZ3HoOsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(39860400002)(396003)(136003)(376002)(366004)(451199015)(186003)(44832011)(30864003)(5660300002)(33716001)(7416002)(26005)(9686003)(316002)(478600001)(6512007)(6486002)(41300700001)(4326008)(6916009)(66556008)(66946007)(66476007)(8676002)(8936002)(83380400001)(86362001)(38100700002)(6506007)(82960400001)(6666004)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F7kpNUkDB1351V9i8iRdJbPlOw6Ryk6rE9xDd+2e/vROuGMWYeCgpR0qHLqz?=
 =?us-ascii?Q?1dxiwJla1cHhCRj2ncmQwLLGzkmEwJgNbufm+5X/u+HnEUiL5toEYVy6wB8U?=
 =?us-ascii?Q?wcpLAppFwMbUL5COBdocrifjmZOuhaNJqnTcT00KkSGTg9DOWYvQZ8bkRnU/?=
 =?us-ascii?Q?UwAVqpQOjZp7lXvH0hvs8kizqPNg56G/u8XFaA5BZuoazY5rLX97aX0h38HZ?=
 =?us-ascii?Q?lfCKGvFIus7Yw3zDtNMueMUDTkCSyb5Yum/OZH0VcEU8fAfmQBEo7FoRxbgU?=
 =?us-ascii?Q?VWBXfi5zSQ537BhAR/S/Kj0IHdcfbeA2eCsc+N2H75yK4EK/uhP0sCmYUvMy?=
 =?us-ascii?Q?/xQkRdvYDJShnLagr6dP+uH0NgLCk5lHec41fvJ+IV6UVzvWyXgjKAFxTlpM?=
 =?us-ascii?Q?EBgoC7aPqkF0pksQePFxgd2itzn0wCOXSmLDViRU+/IHFfvkLBqoNEczWFq5?=
 =?us-ascii?Q?FyEmtHvbWa4/x+YGcR6pljmgcUZMo6PDwLK/W43TjF1jbyWjMku7jcltnCMf?=
 =?us-ascii?Q?KqMoV3uwiNsopzNhySvTrOo3XplHxrFT1hjfK+5fFxknvToKH/x+vSsqfXql?=
 =?us-ascii?Q?oFJ2hM+LgMCeTNhkJR6VGLYwVwTVtsau07ncbd5ZyP7suNOfJdQi0QtGtilF?=
 =?us-ascii?Q?MEaGmRU5zkI4xIs8uolZc4qznCS/qwuMpdcu0g3G9TozTLpdQmAdBHKSvNT4?=
 =?us-ascii?Q?Q2piO0bDLHT4Ht0oartXS4C4BKcpiKeWa+ymTE+n8QWphDauGH8G3Hcr+3IL?=
 =?us-ascii?Q?baOUBbmSnlQCpZLONJCcAnTvQupAnTUFHSgbmVPrt4QfAwnrxLf5qNPp6jWY?=
 =?us-ascii?Q?ArU0APp+dykjad6iJq5RHRjJ0VqRxErEjlRciuBSjtmmti1JMeLcMhNuEBeY?=
 =?us-ascii?Q?kAw5tUa3bCAZcQIzsht4iG1in9C7tWN/i6AHLWaM+5I+dVifYRtcf/B4+T/z?=
 =?us-ascii?Q?KEIleKxbB75W20UJEIbwdCO/92dPWAArMZik/R55iwa1bSyiWmIGokqlUk/L?=
 =?us-ascii?Q?ykv2mc1svFGjXYrDGhhCe5UoadmV55xlT3k5yr4ht6e3yyUSn+cSauUFoVxD?=
 =?us-ascii?Q?wAoM5nbeiJDdHWd34JePvkYpFEU+THBvTfiX5+28CGTqz8dbUoV9qoSuP6iY?=
 =?us-ascii?Q?PZQbiBxUlPwG3yTS7YfPrY/aqurvSOftx/Kn1sv3eNmudJBXxSQshc275TP1?=
 =?us-ascii?Q?iGD9gc6zCrKto5G2+x1mKyMcv0qPNqf9P1A5XAhcb6maxJiJ0cJr/kPLNhli?=
 =?us-ascii?Q?ucWMrJYJykYqpm1YfnFigV8jQHK6HV6L0IqqaCAFf9eZHY2p6052JMT+nM7z?=
 =?us-ascii?Q?lDUJrkSFeY8942NCbXo76MGPnO6F9d1pJTKptlzhO9IXvfRx7PrK/Gawgp09?=
 =?us-ascii?Q?X4Y4Qxorkcf94GBAZJE2h9bFPcOqiaqNMFj18BWsyODXVu9MRGKW7wjYcgVt?=
 =?us-ascii?Q?ej0blNzb8CJ/CNRLq9KAZtLSqVo3keSYZEUbrUcD/Q+MmjEGnnj+GNUjhGbI?=
 =?us-ascii?Q?67lXVluoNUyiv0XPA2SFc+Cga4I/muyO3q8d81J9zoTlsCAw8ujPoM5uHNi6?=
 =?us-ascii?Q?38B4x2hifguui6kLJSIjQl+kkBms3od2XBPtTDZezuJi5v3865BY2i453ior?=
 =?us-ascii?Q?jw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f35566af-466d-4e65-23b3-08daf301c780
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 11:56:59.6582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C7hyvhOEeNgtTDU9mdcklTN1qEC2rJgxVN6Dsz7J0+1w8V7nXq8UJOprkJu+QlaGJXfmf/Msb4DZkpK7WtcheXQMt1ftc21aHHybgijncqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5335
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 01:17:44PM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Implement automatic switching of XDP programs and execution modes if
> needed by a test. This makes it much simpler to write a test as it
> only has to say what XDP program it needs if it is not the default
> one. This also makes it possible to remove the initial explicit
> attachment of the XDP program as well as the explicit mode switch in
> the code. These are now handled by the same code that just checks if a
> switch is necessary, so no special cases are needed.
> 
> The default XDP program for all tests is one that sends all packets to
> the AF_XDP socket. If you need another one, please use the new
> function test_spec_set_xdp_prog() to specify what XDP programs and
> maps to use for this test.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/xsk.c        |  14 +++
>  tools/testing/selftests/bpf/xsk.h        |   1 +
>  tools/testing/selftests/bpf/xskxceiver.c | 137 ++++++++++++-----------
>  tools/testing/selftests/bpf/xskxceiver.h |   7 +-
>  4 files changed, 91 insertions(+), 68 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
> index dc6b47280ec4..d9d44a29c7cc 100644
> --- a/tools/testing/selftests/bpf/xsk.c
> +++ b/tools/testing/selftests/bpf/xsk.c
> @@ -267,6 +267,20 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area,
>  	return err;
>  }
>  
> +bool xsk_is_in_drv_mode(u32 ifindex)
> +{
> +	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
> +	int ret;
> +
> +	ret = bpf_xdp_query(ifindex, XDP_FLAGS_DRV_MODE, &opts);
> +	if (ret) {
> +		printf("DRV mode query returned error %s\n", strerror(errno));
> +		return false;
> +	}
> +
> +	return opts.attach_mode == XDP_ATTACHED_DRV;
> +}

How about making this function more generic since you're adding this to a
"lib" file? you could take on input the mode that you are expecting the
prog being loaded on. Not sure if there will be any future use case for
this, maybe if we would have a support for running a standalone test, not
the whole test suite. I am sort of bothered that things are hard coded in
a way that we expect DRV tests to follow the SKB ones.

That's only a rant though :)

> +
>  int xsk_attach_xdp_program(struct bpf_program *prog, int ifindex, u32 xdp_flags)
>  {
>  	int prog_fd;
> diff --git a/tools/testing/selftests/bpf/xsk.h b/tools/testing/selftests/bpf/xsk.h
> index 5624d31b8db7..3cb9d69589b8 100644
> --- a/tools/testing/selftests/bpf/xsk.h
> +++ b/tools/testing/selftests/bpf/xsk.h
> @@ -201,6 +201,7 @@ int xsk_attach_xdp_program(struct bpf_program *prog, int ifindex, u32 xdp_flags)
>  void xsk_detach_xdp_program(int ifindex, u32 xdp_flags);
>  int xsk_update_xskmap(struct bpf_map *map, struct xsk_socket *xsk);
>  void xsk_clear_xskmap(struct bpf_map *map);
> +bool xsk_is_in_drv_mode(u32 ifindex);
>  
>  struct xsk_socket_config {
>  	__u32 rx_size;
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 66863504c76a..9af0f8240a59 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -96,6 +96,8 @@
>  #include <time.h>
>  #include <unistd.h>
>  #include <stdatomic.h>
> +
> +#include "xsk_xdp_progs.skel.h"
>  #include "xsk.h"
>  #include "xskxceiver.h"
>  #include <bpf/bpf.h>
> @@ -356,7 +358,6 @@ static bool ifobj_zc_avail(struct ifobject *ifobject)
>  	xsk = calloc(1, sizeof(struct xsk_socket_info));
>  	if (!xsk)
>  		goto out;
> -	ifobject->xdp_flags = XDP_FLAGS_DRV_MODE;
>  	ifobject->bind_flags = XDP_USE_NEED_WAKEUP | XDP_ZEROCOPY;
>  	ifobject->rx_on = true;
>  	xsk->rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
> @@ -493,6 +494,10 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
>  	test->total_steps = 1;
>  	test->nb_sockets = 1;
>  	test->fail = false;
> +	test->xdp_prog_rx = ifobj_rx->xdp_progs->progs.xsk_def_prog;
> +	test->xskmap_rx = ifobj_rx->xdp_progs->maps.xsk;
> +	test->xdp_prog_tx = ifobj_tx->xdp_progs->progs.xsk_def_prog;
> +	test->xskmap_tx = ifobj_tx->xdp_progs->maps.xsk;

Is this needed for Tx side? I believe at this point shared_netdev is set,
no? Or is this just a default state.

>  }
>  
>  static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
> @@ -532,6 +537,16 @@ static void test_spec_set_name(struct test_spec *test, const char *name)
>  	strncpy(test->name, name, MAX_TEST_NAME_SIZE);
>  }
>  
> +static void test_spec_set_xdp_prog(struct test_spec *test, struct bpf_program *xdp_prog_rx,
> +				   struct bpf_program *xdp_prog_tx, struct bpf_map *xskmap_rx,
> +				   struct bpf_map *xskmap_tx)


Nit:

static void
test_spec_set_xdp_prog(struct test_spec *test, struct bpf_program *xdp_prog_rx,
		      struct bpf_program *xdp_prog_tx, struct bpf_map *xskmap_rx,
		      struct bpf_map *xskmap_tx)

> +{
> +	test->xdp_prog_rx = xdp_prog_rx;
> +	test->xdp_prog_tx = xdp_prog_tx;
> +	test->xskmap_rx = xskmap_rx;
> +	test->xskmap_tx = xskmap_tx;
> +}
> +
>  static void pkt_stream_reset(struct pkt_stream *pkt_stream)
>  {
>  	if (pkt_stream)
> @@ -1356,6 +1371,47 @@ static void handler(int signum)
>  	pthread_exit(NULL);
>  }
>  
> +static bool xdp_prog_changed(struct test_spec *test, struct ifobject *ifobj)
> +{
> +	return ifobj->xdp_prog != test->xdp_prog_rx || ifobj->mode != test->mode;
> +}
> +
> +static void xsk_reattach_xdp(struct ifobject *ifobj, struct bpf_program *xdp_prog,
> +			     struct bpf_map *xskmap, enum test_mode mode)
> +{
> +	int err;
> +
> +	xsk_detach_xdp_program(ifobj->ifindex, mode_to_xdp_flags(ifobj->mode));
> +	err = xsk_attach_xdp_program(xdp_prog, ifobj->ifindex, mode_to_xdp_flags(mode));
> +	if (err) {
> +		printf("Error attaching XDP program\n");
> +		exit_with_error(-err);
> +	}
> +
> +	if (ifobj->mode != mode && (mode == TEST_MODE_DRV || mode == TEST_MODE_ZC))
> +		if (!xsk_is_in_drv_mode(ifobj->ifindex)) {
> +			ksft_print_msg("ERROR: XDP prog not in DRV mode\n");
> +			exit_with_error(EINVAL);
> +		}
> +
> +	ifobj->xdp_prog = xdp_prog;
> +	ifobj->xskmap = xskmap;
> +	ifobj->mode = mode;
> +}
> +
> +static void xsk_attach_xdp_progs(struct test_spec *test, struct ifobject *ifobj_rx,
> +				 struct ifobject *ifobj_tx)
> +{
> +	if (xdp_prog_changed(test, ifobj_rx))
> +		xsk_reattach_xdp(ifobj_rx, test->xdp_prog_rx, test->xskmap_rx, test->mode);
> +
> +	if (!ifobj_tx || ifobj_tx->shared_umem)
> +		return;
> +
> +	if (xdp_prog_changed(test, ifobj_tx))
> +		xsk_reattach_xdp(ifobj_tx, test->xdp_prog_tx, test->xskmap_tx, test->mode);
> +}
> +
>  static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *ifobj1,
>  				      struct ifobject *ifobj2)
>  {
> @@ -1403,7 +1459,11 @@ static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *i
>  
>  static int testapp_validate_traffic(struct test_spec *test)
>  {
> -	return __testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
> +	struct ifobject *ifobj_rx = test->ifobj_rx;
> +	struct ifobject *ifobj_tx = test->ifobj_tx;
> +
> +	xsk_attach_xdp_progs(test, ifobj_rx, ifobj_tx);
> +	return __testapp_validate_traffic(test, ifobj_rx, ifobj_tx);
>  }
>  
>  static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj)
> @@ -1446,7 +1506,7 @@ static void testapp_bidi(struct test_spec *test)
>  
>  	print_verbose("Switching Tx/Rx vectors\n");
>  	swap_directions(&test->ifobj_rx, &test->ifobj_tx);
> -	testapp_validate_traffic(test);
> +	__testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
>  
>  	swap_directions(&test->ifobj_rx, &test->ifobj_tx);
>  }
> @@ -1615,29 +1675,15 @@ static void testapp_invalid_desc(struct test_spec *test)
>  
>  static void testapp_xdp_drop(struct test_spec *test)
>  {
> -	struct ifobject *ifobj = test->ifobj_rx;
> -	int err;
> +	struct xsk_xdp_progs *skel_rx = test->ifobj_rx->xdp_progs;
> +	struct xsk_xdp_progs *skel_tx = test->ifobj_tx->xdp_progs;
>  
>  	test_spec_set_name(test, "XDP_DROP_HALF");
> -	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
> -	err = xsk_attach_xdp_program(ifobj->xdp_progs->progs.xsk_xdp_drop, ifobj->ifindex,
> -				     ifobj->xdp_flags);
> -	if (err) {
> -		printf("Error attaching XDP_DROP program\n");
> -		test->fail = true;
> -		return;
> -	}
> +	test_spec_set_xdp_prog(test, skel_rx->progs.xsk_xdp_drop, skel_tx->progs.xsk_xdp_drop,
> +			       skel_rx->maps.xsk, skel_tx->maps.xsk);
>  
>  	pkt_stream_receive_half(test);
>  	testapp_validate_traffic(test);
> -
> -	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
> -	err = xsk_attach_xdp_program(ifobj->xdp_progs->progs.xsk_def_prog, ifobj->ifindex,
> -				     ifobj->xdp_flags);
> -	if (err) {
> -		printf("Error restoring default XDP program\n");
> -		exit_with_error(-err);
> -	}
>  }
>  
>  static void testapp_poll_txq_tmout(struct test_spec *test)
> @@ -1674,7 +1720,7 @@ static void xsk_unload_xdp_programs(struct ifobject *ifobj)
>  
>  static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
>  		       const char *dst_ip, const char *src_ip, const u16 dst_port,
> -		       const u16 src_port, thread_func_t func_ptr, bool load_xdp)
> +		       const u16 src_port, thread_func_t func_ptr)
>  {
>  	struct in_addr ip;
>  	int err;
> @@ -1693,23 +1739,11 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
>  
>  	ifobj->func_ptr = func_ptr;
>  
> -	if (!load_xdp)
> -		return;
> -
>  	err = xsk_load_xdp_programs(ifobj);
>  	if (err) {
>  		printf("Error loading XDP program\n");
>  		exit_with_error(err);
>  	}
> -
> -	ifobj->xdp_flags = mode_to_xdp_flags(TEST_MODE_SKB);
> -	err = xsk_attach_xdp_program(ifobj->xdp_progs->progs.xsk_def_prog, ifobj->ifindex,
> -				     ifobj->xdp_flags);
> -	if (err) {
> -		printf("Error attaching XDP program\n");
> -		exit_with_error(-err);
> -	}
> -	ifobj->xskmap = ifobj->xdp_progs->maps.xsk;
>  }
>  
>  static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_type type)
> @@ -1871,31 +1905,6 @@ static bool is_xdp_supported(int ifindex)
>  	return true;
>  }
>  
> -static void change_to_drv_mode(struct ifobject *ifobj)
> -{
> -	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
> -	int ret;
> -
> -	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
> -	ifobj->xdp_flags = XDP_FLAGS_DRV_MODE;
> -	ret = xsk_attach_xdp_program(ifobj->xdp_progs->progs.xsk_def_prog, ifobj->ifindex,
> -				     ifobj->xdp_flags);
> -	if (ret) {
> -		ksft_print_msg("Error attaching XDP program\n");
> -		exit_with_error(-ret);
> -	}
> -	ifobj->xskmap = ifobj->xdp_progs->maps.xsk;
> -
> -	ret = bpf_xdp_query(ifobj->ifindex, XDP_FLAGS_DRV_MODE, &opts);
> -	if (ret)
> -		exit_with_error(errno);
> -
> -	if (opts.attach_mode != XDP_ATTACHED_DRV) {
> -		ksft_print_msg("ERROR: XDP prog not in DRV mode\n");
> -		exit_with_error(EINVAL);
> -	}
> -}
> -
>  int main(int argc, char **argv)
>  {
>  	struct pkt_stream *rx_pkt_stream_default;
> @@ -1936,9 +1945,9 @@ int main(int argc, char **argv)
>  	}
>  
>  	init_iface(ifobj_rx, MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2,
> -		   worker_testapp_validate_rx, true);
> +		   worker_testapp_validate_rx);
>  	init_iface(ifobj_tx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
> -		   worker_testapp_validate_tx, !shared_netdev);
> +		   worker_testapp_validate_tx);
>  
>  	test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
>  	tx_pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
> @@ -1951,12 +1960,6 @@ int main(int argc, char **argv)
>  	ksft_set_plan(modes * TEST_TYPE_MAX);
>  
>  	for (i = 0; i < modes; i++) {
> -		if (i == TEST_MODE_DRV) {
> -			change_to_drv_mode(ifobj_rx);
> -			if (!shared_netdev)
> -				change_to_drv_mode(ifobj_tx);
> -		}
> -
>  		for (j = 0; j < TEST_TYPE_MAX; j++) {
>  			test_spec_init(&test, ifobj_tx, ifobj_rx, i);
>  			run_pkt_test(&test, i, j);
> diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> index a4daa5134fc0..3e8ec7d8ec32 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.h
> +++ b/tools/testing/selftests/bpf/xskxceiver.h
> @@ -143,10 +143,11 @@ struct ifobject {
>  	struct pkt_stream *pkt_stream;
>  	struct xsk_xdp_progs *xdp_progs;
>  	struct bpf_map *xskmap;
> +	struct bpf_program *xdp_prog;
> +	enum test_mode mode;
>  	int ifindex;
>  	u32 dst_ip;
>  	u32 src_ip;
> -	u32 xdp_flags;
>  	u32 bind_flags;
>  	u16 src_port;
>  	u16 dst_port;
> @@ -166,6 +167,10 @@ struct test_spec {
>  	struct ifobject *ifobj_rx;
>  	struct pkt_stream *tx_pkt_stream_default;
>  	struct pkt_stream *rx_pkt_stream_default;
> +	struct bpf_program *xdp_prog_rx;
> +	struct bpf_program *xdp_prog_tx;
> +	struct bpf_map *xskmap_rx;
> +	struct bpf_map *xskmap_tx;
>  	u16 total_steps;
>  	u16 current_step;
>  	u16 nb_sockets;
> -- 
> 2.34.1
> 
