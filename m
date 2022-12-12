Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F3064A3F5
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 16:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbiLLPOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 10:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiLLPOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 10:14:01 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC57BB864;
        Mon, 12 Dec 2022 07:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670858040; x=1702394040;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KiYIdNgVooibjtYOuqP1jw22BA17HRK4RPLNi/2bdOY=;
  b=fSDgwYvSHWgeKVDLx4dTm4p32WOUHhlXYzh8/bRbCmyAEgJbslQ2n31t
   i3mHItIWQEkKhwBG2iWkHNXjw32RBa5++EdejsqrI/v6zXUZAhH5zM7Vo
   ihAXDg0hjNOqz92Y75VLAJh3shQP03b3/eRN5+9O3xYt2evCY4RyMQSYq
   KHTwJPyN8EsuDh6hKk7evfkiRlpsVkCJ0wpdveUZm/DBH0qGn/YD/1FtB
   glZyhV5WFgtMxs5FWdl8fL789cEWxBYle102kJrXobW3M7Zz/NVlEU7e4
   i3QMTFmDJ5ghnV/tgpi26hYjmsFsc4OiGS745z9tOcq5cmpMWrdKMyU/3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="319016348"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="319016348"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 07:13:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="680707244"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="680707244"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 12 Dec 2022 07:13:57 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 07:13:56 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 07:13:56 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 07:13:56 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 12 Dec 2022 07:13:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEHzWOVtgbK/jK2JOsxwtDrVR0wge3xeG0+uv3Ekecgvhxo5kIpcGIEpfe1pk15D1GVmcRiw3JJcMCaB2XKGuSlcc1ZjuNdj5/khwcaSj0hbdyVv45RVY1JIORVpdCC3c68CI2PQPCw2GRc+3fz2mOfYIOoIkn5M9n4/RVcjLc4rmQZ1UUokR9Koh3y2bH/tBF/HFqe9BEKDsQpf81f4ff0w03ENcYBTQXVcVGDgkmsaWEXL90i5juZomEa7HFvb5QTFV0XGJQta2aVb6GON7++n3Maeefs+2RaAFb6IOIiVjoN9NLzNOPU7cY7VGpa1/0l5XTFvo5sf3Gbj9mN5hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8u3tWWOWognrrhAhpz6fQZQfPJ9HwuJaMXzGrYZPIEw=;
 b=BQMeoO0YCTit8reoM7OeyrIQhQct0zMvyulRT3HYHd2SkrJ411DVnWSlyB7xFM7qfXsziIEyl2QiX64/Jxz8U8iSP/R6TghUw1IAJUlLISPS1kavJhXQZyZy5sMtJCjx+5FXnlOIIDBmEsUGJWtj6eGb6//hiDQ6+m15idiVsgrj7yt9/2M3L2UJbcaQVIkfidrEQrbh2IsKtm+UjvoQVDLOhrp/lyGGiKSSE8/PIBnBZlg3AnONW8OB/KrelgtPJ13IdMNrM9VZUWWimoKByHIkn8adVFmA9Zt7jEgBsytjcOUpuPO/wW/0hXvmOSEzPPdwELttUHBLbo9v8qtiBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA3PR11MB7554.namprd11.prod.outlook.com (2603:10b6:806:315::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Mon, 12 Dec 2022 15:13:52 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 15:13:52 +0000
Date:   Mon, 12 Dec 2022 16:13:38 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <yhs@fb.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 12/15] selftests/xsk: add test when some packets
 are XDP_DROPed
Message-ID: <Y5dFImCN9B6bR3yG@boxer>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
 <20221206090826.2957-13-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221206090826.2957-13-magnus.karlsson@gmail.com>
X-ClientProxiedBy: FR0P281CA0071.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::10) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA3PR11MB7554:EE_
X-MS-Office365-Filtering-Correlation-Id: 0964c718-3cf4-440d-9df3-08dadc537acd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x3SzEvV77hskwqLRH6fxIwDSLsGEFSo+0a1HplNtllVF0gmY5eKcMK0lZowcANvYQIZruzXx+4AhMB9OjklEZCscgTS/P0lduXFoE5YDSqU3Q10fje7VfXy+OvXJ3X7cZQ5oKvyzQf8Y8ygs2d/077/NRK5Lc6XnJZt+W93eFy2DXncP8jLmjGuAZaKq/qQmPQL5nae34nbUMJi13GYjjvfQirjJmOWjgXwyDfYIedVOSfDpWbnfBNJSO6Lmal21uDcZOGrmPwrmv6tIzPlbaP0/1ti8SYvlzB9vUgbsFVXjc6PLzkHGtMzR/6eHGALToh7VRVwSNPVznHKhNxmlwzDFGvc6vPsQa/+04EYmsChfUq1iMsqcyh3n1f7JaWJkZm/EP4MIw7wMWVAMnN95SgJO0T8rIxoR9Q+TYM5VgXQLmXxXVMAN1dwvvgbaowhxfJM/bFgR4hHuHqhgWNVDMuGHw6AEMspy1qw9AVgCLybKDOiLm8rYBVtzQv1DeGL843HkALam6XT17KFQqDfKHqmiNuCdAXCKuXTvtfy0CUwuIndNfG+Q0JyMMdJcWaIIMi1KpdYik5ayIVXepb6yrPFlqoFjl1ssTop9fMkU9xd81+wmp7EVT5YGFWwlhKNi4LQ9HqY/F6HEOcQFjl/4fQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199015)(5660300002)(2906002)(8936002)(44832011)(7416002)(6506007)(6916009)(316002)(33716001)(6512007)(41300700001)(86362001)(478600001)(26005)(9686003)(6666004)(38100700002)(186003)(6486002)(82960400001)(83380400001)(66556008)(66476007)(8676002)(4326008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B5f0FqkXwNRQGA3/qxCgT3GMzU+A/wkc12C5WbDUuNSL1nqvJaY65pwugw+l?=
 =?us-ascii?Q?GL1Ix2gxCpUehz528W6Ju4eSl0Vamfi+bHhuwn9HGyyY5GT/qlLhnbEkQWPp?=
 =?us-ascii?Q?168ID6gvkzqcOzAqSnGx8IwDR2dUxjVANlOb7RqF7EIpj75KCxFeRqBQejb6?=
 =?us-ascii?Q?U4UrwkryX8R2Xk1xfaiH04maYvvM/lEFYHH5fKWwE0Xw82Y4Cu3IqW5XMfjq?=
 =?us-ascii?Q?179bg5tXsahAn3YI/JCz23h8aZGg0eP4QJ92FXdauRyKH9n7sezwY44LFiNO?=
 =?us-ascii?Q?z/hOQzYsViBjknEkzlZnSKFjFNDBEhWwFm4UsyjIy0xc55YanQxeP/2QF+dY?=
 =?us-ascii?Q?q5dr/YnJUCDE4f9n2YbuUda1tuAzu9FeDTl396Ztz1QEXU8Z4QEQNBp8FCgO?=
 =?us-ascii?Q?3JrjJwcT1yDge1VY1d4G/HV68KcGlGVf6WMxbxiRG/UcZMUfXEpAjxuuyWYo?=
 =?us-ascii?Q?+eat3R4Tm4fdyyYxINmgBnsRWyhlV6huchoajJd7NJZjGlQDk2WB/GLVxAl/?=
 =?us-ascii?Q?+2+sV9uqbKxwiyHbq2dNFB6bcR41iPXK5FZ+Gj0sRc/5KRj37P/6Fs1mTA0L?=
 =?us-ascii?Q?WQ1kZIuXJ11PyoK5HjzWxJ3wGc6mO8cCKzZbqBanM87T/LGxVQrUNDmYv6UC?=
 =?us-ascii?Q?0x1JenmRSvgCzscP04EFkVBEdB2yauOcqAZoRKtUlP8U+d3y4il5JPlIhm0H?=
 =?us-ascii?Q?bCeCsmWeXbtIvd6K6lIRLFH+MONL0H0MdGPUGtktfZEbmASgWVHr8+IRSopH?=
 =?us-ascii?Q?eLVnw/DpWlxX/NcZo6H5IpchqC3fku6FLGXfifzimfe28DAn9lDYOABF6eMs?=
 =?us-ascii?Q?Ye66gzHGy9Al8IzV+dG1/LcO+rGnNZAu4GeyKWEuwltsqJoQBxCxmIhEyzyM?=
 =?us-ascii?Q?9JiiRo3kJXneCyRP6I4sU5ItjrY1bI9tZlv5yxKB0FO/VLkRNLG4Drrn6/+a?=
 =?us-ascii?Q?iH4DFtKk+mPFnmzkFm3SgIlTSZadwfL3VMFEhyaZBbctn2ktHA4RrkXI724n?=
 =?us-ascii?Q?Mo+7niAGJhrXzTIGBAtAnejOPSDekucebpbswhWLXGnk2oLIdt+zJs4Dr+IF?=
 =?us-ascii?Q?N8VZc19G4kfcsm5O7pxF07HPACg7ZrHEBFOZfmsnXoVj15V2kBprmp3N+2dx?=
 =?us-ascii?Q?wbve9fOVFPi1bEi/T42f0kKmRx3W3GVOwovbkUI7KjOrQ1JnlhMNrNKsn2PK?=
 =?us-ascii?Q?WZYw159+Ml28ITabgIKG+/3K1tWs7QCcx6LN5DrVdNGh+RW2tY2DFdf5776k?=
 =?us-ascii?Q?Sasi1j0ncL39qmLr2PUaWTzQfqzhl5uJXOmpIx9GPuOGZwIP0Hb8LgoYrCtj?=
 =?us-ascii?Q?ZK0CR+onwhwMEiL9bPCkPHw/T9IpnBs9NJNJ/EYHf5MmsgaFgSTDyFHnNmDy?=
 =?us-ascii?Q?qUDjbf25sKVlDTQGH5wJUUO/k2IAuOu+Bmep06xk+9xJyHLkicTCfcw4uXs2?=
 =?us-ascii?Q?4o+mIbPYJaGTgfZVy/IAU9xJIkOsBn4iypW8t0yuyZZLyeHryC/J2PGYGECS?=
 =?us-ascii?Q?Gq0qc47+iGDclvtoCbBJY/EVGn/zSKm4HpPHZbiFQwcp+g4Jj4TVw6GyCnF5?=
 =?us-ascii?Q?1FLEDQHJpBcypH2NkmDGh2kWpIq/hO8lH+rsSVEUJRP0H2VxyEG4sGCACyuT?=
 =?us-ascii?Q?/0aiV+w8ITZYUP4jMC/yb3k=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0964c718-3cf4-440d-9df3-08dadc537acd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 15:13:52.8288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+Mjkpk6MB4bmKBQdv+RjgHa7g5EKKStaTETy7z8aTR7Qvp7FZnWp7zy/TQfmBuDovQfDml3Jx6OufZP3QKZmEh6IL7hg76pfzbIYOz9t0Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7554
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 10:08:23AM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Add a new test where some of the packets are not passed to the AF_XDP
> socket and instead get a XDP_DROP verdict. This is important as it
> tests the recycling mechanism of the buffer pool. If a packet is not
> sent to the AF_XDP socket, the buffer the packet resides in is instead
> recycled so it can be used again without the round-trip to user
> space. The test introduces a new XDP program that drops every other
> packet.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/Makefile          |  2 +-
>  .../selftests/bpf/progs/xsk_xdp_drop.c        | 25 ++++++++++
>  tools/testing/selftests/bpf/xskxceiver.c      | 48 +++++++++++++++++--
>  tools/testing/selftests/bpf/xskxceiver.h      |  3 ++
>  4 files changed, 72 insertions(+), 6 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_drop.c
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 42e15b5a34a7..77ef8a8e6db4 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -240,7 +240,7 @@ $(OUTPUT)/flow_dissector_load: $(TESTING_HELPERS)
>  $(OUTPUT)/test_maps: $(TESTING_HELPERS)
>  $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
>  $(OUTPUT)/xsk.o: $(BPFOBJ)
> -$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o $(OUTPUT)/xsk_def_prog.skel.h
> +$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o $(OUTPUT)/xsk_def_prog.skel.h $(OUTPUT)/xsk_xdp_drop.skel.h
>  
>  BPFTOOL ?= $(DEFAULT_BPFTOOL)
>  $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
> diff --git a/tools/testing/selftests/bpf/progs/xsk_xdp_drop.c b/tools/testing/selftests/bpf/progs/xsk_xdp_drop.c
> new file mode 100644
> index 000000000000..12a12b0d9fc1
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/xsk_xdp_drop.c
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022 Intel */
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_XSKMAP);
> +	__uint(max_entries, 1);
> +	__uint(key_size, sizeof(int));
> +	__uint(value_size, sizeof(int));
> +} xsk SEC(".maps");
> +
> +static unsigned int idx;
> +
> +SEC("xdp") int xsk_xdp_drop(struct xdp_md *xdp)
> +{
> +	/* Drop every other packet */
> +	if (idx++ % 2)
> +		return XDP_DROP;
> +
> +	return bpf_redirect_map(&xsk, 0, XDP_DROP);
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 0cda4e3f1871..522dc1d69c17 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -1654,18 +1654,53 @@ static void testapp_invalid_desc(struct test_spec *test)
>  	pkt_stream_restore_default(test);
>  }
>  
> -static int xsk_load_xdp_program(struct ifobject *ifobj)
> +static void testapp_xdp_drop(struct test_spec *test)
> +{
> +	struct ifobject *ifobj = test->ifobj_rx;
> +	int err;
> +
> +	test_spec_set_name(test, "XDP_CONSUMES_SOME_PACKETS");

XDP_DROP_ODD_PACKETS ?

> +	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
> +	err = xsk_attach_xdp_program(ifobj->xdp_drop->progs.xsk_xdp_drop, ifobj->ifindex,
> +				     ifobj->xdp_flags);
> +	if (err) {
> +		printf("Error attaching XDP_DROP program\n");
> +		test->fail = true;
> +		return;
> +	}
> +	ifobj->xskmap = ifobj->xdp_drop->maps.xsk;
> +
> +	pkt_stream_receive_half(test);
> +	testapp_validate_traffic(test);
> +
> +	pkt_stream_restore_default(test);
> +	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
> +	err = xsk_attach_xdp_program(ifobj->def_prog->progs.xsk_def_prog, ifobj->ifindex,
> +				     ifobj->xdp_flags);
> +	if (err) {
> +		printf("Error restoring default XDP program\n");
> +		exit_with_error(-err);
> +	}
> +	ifobj->xskmap = ifobj->def_prog->maps.xsk;
> +}
> +
> +static int xsk_load_xdp_programs(struct ifobject *ifobj)
>  {
>  	ifobj->def_prog = xsk_def_prog__open_and_load();
>  	if (libbpf_get_error(ifobj->def_prog))
>  		return libbpf_get_error(ifobj->def_prog);
>  
> +	ifobj->xdp_drop = xsk_xdp_drop__open_and_load();
> +	if (libbpf_get_error(ifobj->xdp_drop))
> +		return libbpf_get_error(ifobj->xdp_drop);
> +
>  	return 0;
>  }
>  
> -static void xsk_unload_xdp_program(struct ifobject *ifobj)
> +static void xsk_unload_xdp_programs(struct ifobject *ifobj)
>  {
>  	xsk_def_prog__destroy(ifobj->def_prog);
> +	xsk_xdp_drop__destroy(ifobj->xdp_drop);
>  }
>  
>  static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
> @@ -1692,7 +1727,7 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
>  	if (!load_xdp)
>  		return;
>  
> -	err = xsk_load_xdp_program(ifobj);
> +	err = xsk_load_xdp_programs(ifobj);
>  	if (err) {
>  		printf("Error loading XDP program\n");
>  		exit_with_error(err);
> @@ -1804,6 +1839,9 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
>  	case TEST_TYPE_HEADROOM:
>  		testapp_headroom(test);
>  		break;
> +	case TEST_TYPE_XDP_CONSUMES_PACKETS:
> +		testapp_xdp_drop(test);
> +		break;
>  	default:
>  		break;
>  	}
> @@ -1971,8 +2009,8 @@ int main(int argc, char **argv)
>  
>  	pkt_stream_delete(tx_pkt_stream_default);
>  	pkt_stream_delete(rx_pkt_stream_default);
> -	xsk_unload_xdp_program(ifobj_tx);
> -	xsk_unload_xdp_program(ifobj_rx);
> +	xsk_unload_xdp_programs(ifobj_tx);
> +	xsk_unload_xdp_programs(ifobj_rx);
>  	ifobject_delete(ifobj_tx);
>  	ifobject_delete(ifobj_rx);
>  
> diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> index eb6355bcc143..3483ac240b2e 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.h
> +++ b/tools/testing/selftests/bpf/xskxceiver.h
> @@ -6,6 +6,7 @@
>  #define XSKXCEIVER_H_
>  
>  #include "xsk_def_prog.skel.h"
> +#include "xsk_xdp_drop.skel.h"
>  
>  #ifndef SOL_XDP
>  #define SOL_XDP 283
> @@ -87,6 +88,7 @@ enum test_type {
>  	TEST_TYPE_STATS_RX_FULL,
>  	TEST_TYPE_STATS_FILL_EMPTY,
>  	TEST_TYPE_BPF_RES,
> +	TEST_TYPE_XDP_CONSUMES_PACKETS,
>  	TEST_TYPE_MAX
>  };
>  
> @@ -141,6 +143,7 @@ struct ifobject {
>  	validation_func_t validation_func;
>  	struct pkt_stream *pkt_stream;
>  	struct xsk_def_prog *def_prog;
> +	struct xsk_xdp_drop *xdp_drop;

Is this going to scale if we add plenty of XDP progs for testing?

>  	struct bpf_map *xskmap;
>  	int ifindex;
>  	u32 dst_ip;
> -- 
> 2.34.1
> 
