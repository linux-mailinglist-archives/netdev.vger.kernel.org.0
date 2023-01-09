Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB026634CC
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 00:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbjAIXB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 18:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234480AbjAIXB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 18:01:26 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC4915715;
        Mon,  9 Jan 2023 15:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673305286; x=1704841286;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IIP75KCArOV2x3hwC7vkgwLALOtCEjvMX7sTSa4D0aA=;
  b=bIKgIVo7kWp8/sxPjKsg1WrUo/aCn/tBFtJNnnPLycUV9gS1lzP4qsQu
   Oyo6+GPkweOn3ZZEW5wK8aQg8/JqIG4ybgkWS2m7ceqkyEv63I18eTb1M
   VScCXAwU50MWFDrkYTSm61wmEpPbUQXf51efwO8N5KDqaZnTifACAVshl
   R4IK7gTxZ4buIIjc5ApRrIyvfwiY39LjY3VAg3BnaCdaeyaF7M/Uy5LVu
   5bSBvvBL2tyqvdAQbOiATLKOmqBi4q6qZqjiMdxiZ6V8JFV/BntmrjzkM
   JLeeSGSZmFf3s0o4uL+E82b9ZmQkpL6xCqqCDzNi4VYZRXZCFPvNzQ1rI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="324248650"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="324248650"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 15:01:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="902162580"
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="902162580"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jan 2023 15:01:24 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 15:01:24 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 15:01:24 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 9 Jan 2023 15:01:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFD+2WW6FGKW4pJQgL0d9ovQryZUZblGcaidfZgPiJClKBAr0ODx7DCvFTqDL+RcEmOF45C/zPRD8Qc3MV0MJ5ap6xthXXP9ThI6era1N2zTdMvy3ddQwgfzBhxXSifTEEmvZLApqKnPX+2I+SQ5rfxcWaeIEu9Y79l0C3H6Y529FmbfKJwVDfoLG18OPC7tUd0gd+D9ZPefYzhP2JMJcqKqNzkGe4E131zKgPeogJZ25OYImmE4iZFFwGSsRcGRpfczvB/EmyA1BhG9XFzg6cCfRFFUJl71UUVhQAhKBpap+auijtWjyxfS8So5JjmZH3iWCCEjdCJYajeZ9VqWBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jY5mt81zm66iVtjP0Mfa3IYn2axMVlx92D2N49Sf5oo=;
 b=IQUAju6i9ib+FE78dNHNCDgVT4hCoxf7qspCAxmS740HdlJ6/6PRRKjNPIO7lQ7uL+wQ0M/c6+e3lqlbNY2rd2+6UJX/1mY4B53g56WFHwBd0AWSTrC+xsgf/x1JGLCeyrFIpLMiNC+FL8+ETOPD/DSK6GgMT7AsvpgE29WclzQ2je2aMbF0kxvfx+GTfLO0gwyYjA/Dp0PVFjmR10vQScre8KQMoeDM4SXSfZAwtOmwZeGpJ3/4AQvt1W3NswJrGZ0nphHKGmxHJwQUXB5XTbskfhXh+GRkeS/DUfZz1nnZz85mLHPVtTZjmynApEpmGpacYaEKsCIAAeYzu7NUUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM4PR11MB6167.namprd11.prod.outlook.com (2603:10b6:8:ac::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Mon, 9 Jan 2023 23:01:22 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::fd3c:c9fc:5065:1a92]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::fd3c:c9fc:5065:1a92%8]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 23:01:22 +0000
Date:   Tue, 10 Jan 2023 00:01:13 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <yhs@fb.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <tirthendu.sarkar@intel.com>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v2 03/15] selftests/xsk: submit correct number
 of frames in populate_fill_ring
Message-ID: <Y7ycuaHlWRu/jRul@boxer>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
 <20230104121744.2820-4-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230104121744.2820-4-magnus.karlsson@gmail.com>
X-ClientProxiedBy: FR3P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DM4PR11MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: 67dab67e-42fb-46e3-ea2d-08daf2956d0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99uZKBAJCqPUXKAj5OiOlS97nZbpMfxqnOmEH19QujsSLfS9wzinVJAjCcrHMHWpKUhgJZVmyCuW6rSn81zFkXdeTX6XgF8L/vywYdjnJne0nB6x3ZWxd6jZicgAxLYCFxGMgHsEdlLg5+BSNCv0FAACH6QmPUy56AxXN85gTre4G/GGmspkH3fbKK9ShR5aJP036mCuTrpFMWoKxGlH9xC58Eh7vqGFBrpSEYlVSiVvg1Qgmbupemwxn4kOvLJoD3FIW5llhfleZ0J7wXfoM6pGy56Pc1ufud1u6xGyX7oGTLOFU0iuFGR0Fam/8lXmTlFhlmo0gZEaPlAGnNqIBrS6rxVvyzFz4TN0A7av2ygIdnJhmLxZVAHh6nvS0NF5fQX0uYC7Lc/ngE4fusyJzw0S74QVBk6iSdiPkb9Ba8W82e+3/6OFnlXlPL3qIvXLgRbnqPtvfSkiQu4AreUQ+GkyylbGO4IAT5uYB0N/HgNfF6Sj9PW9mLFlN/97mIkuY1DHsu+zpBPVrMFXqOxQsd4zmCVY4uKTdZFOgqOQSVIX9JbbqK8VjiY66XqfAlz6hk8AzZD3T3s7irclgEqqMUAicZ9sXrBseEfJJy98T4raGhdIk7F9UGHXSvjcvcAljvF8pnHtK76v1GEwZx5ArQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(376002)(39860400002)(136003)(346002)(366004)(451199015)(478600001)(86362001)(82960400001)(8676002)(4326008)(5660300002)(7416002)(66476007)(38100700002)(66556008)(66946007)(8936002)(41300700001)(26005)(316002)(6486002)(83380400001)(2906002)(6916009)(44832011)(6506007)(33716001)(186003)(6512007)(9686003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?marUr0SseCV8tQT3xiOuQZ2rXwo0EP0cjgwUcseEqm5iJR/l4myuqam9oN5k?=
 =?us-ascii?Q?Xz8UKCV5IewcqL6H5CCoW9tE4HTft2vm1SODzS36eaLbGU9lTpWBJSVd1Hl3?=
 =?us-ascii?Q?mkZ8HJeT1KK9aCVY2QrqMvJUEHrCxocROUiDh5Z7ya4u0HyD9OvawkzK24+E?=
 =?us-ascii?Q?gcYywlh3e7tWEsvDSXngoUVGLgg4IWnIw/g0RpXQxSNC5rb1O29Z1PyfkQMM?=
 =?us-ascii?Q?JpiJYweupfBZEl8VttiGl9lvysM2g2DMVFhpWaQ7hbIZ7+DRE2kfR2sptgB/?=
 =?us-ascii?Q?qJJIDsrznItMRz4mjr4e5bY769YQPRdrz/uaJAgeUt6uXa7cDOreP/Dt+Vo3?=
 =?us-ascii?Q?zhB9+OleNFeHh43vCXGZHlDpG6ivLFH14lIegPRpkVphYfFI/iib1qYbRmvK?=
 =?us-ascii?Q?hnhqFCsKnt+xmCYE3LxKjD6d98r2y7yVAQvAV9GUM5d/Au0hiAofWoIUAESR?=
 =?us-ascii?Q?uggaIs79SXkoBilzpVAnVAGmaNaCG2RWhmvbcaNCCxBm9UEJ31x+NpP6nv8o?=
 =?us-ascii?Q?1Bxbl3bwlVvIKE0JVfoyflYIo5OW+PEh+YImkk+2jL1VANtDeRuffcxvqpB+?=
 =?us-ascii?Q?69amwzdrYgwpTfB+U/pwSeGH64o2bzDSI82gt2t3mgguD9GZTsS2a56K1jDk?=
 =?us-ascii?Q?/orU/WJplsJr6MO5JT2lBTslAwXsbpN9htF8edO/Mc5cAt6FeAeltbJ24KUO?=
 =?us-ascii?Q?OFC1dqO+kENvePSilbyTeIE2PHAdeIgYu8RyWvtlcQbD0WPYlIgK+JC9wNxI?=
 =?us-ascii?Q?spUpBQ09Om23zE8NI+p7BTT2cd6oltYXxxZo0AeCtXY5p7WBocWvy5/zwhP9?=
 =?us-ascii?Q?i5YxOC/10HxLtlmxSjt3QXdLRfUVVFPsGriiEFl7sJv9yqq3rjRNpTFozLWe?=
 =?us-ascii?Q?oNVYlYynyz1WJ2uZCxhwLkHnoJ7MfaeTg/R10aYZRrEDGZWoVwc80qeEqFFv?=
 =?us-ascii?Q?V/Pn+oMejhKQeUyJWNHWVp0m7omGjaS3sW1qhuJO2zVFv/olHrVP0ZVet2qR?=
 =?us-ascii?Q?wWpu9A/uXfdKCh7k2DkPqpW1i9SAJz7hraRivbrAdFGK9bWEjLq/l2sQ+dd3?=
 =?us-ascii?Q?TrGQf6yZzvpYpL9n8BjSNnScQFLv9B1ewcIZHTnV+XYKLYj+i4U8kj96xlND?=
 =?us-ascii?Q?QCiZqwIRNRteYLOTGwQ73FksKfE47/GY6uBRWi/NgUvEh06E7xBjmnfr8gD4?=
 =?us-ascii?Q?uMXDaZ3kMc2X26qSDYSXqpGQnktjyHwJMeMjGylLkV4EY2++vuGB21Dt5u0L?=
 =?us-ascii?Q?8QpeV8Ffz83iPzn2yh6wqSNbrrZj1lTzNQD2NMnrAf7lrGOQ5eEXgrIZcqaH?=
 =?us-ascii?Q?tIVZvSPrwj7lFsppb0rTIH0j6uhj4U9VeE5AFZvBG6cqZ67RJEdawrUGZMGM?=
 =?us-ascii?Q?j1CyzxF8ShS1zQnFEXbHeBRDZpmkMx6x8NnDoYMDkS0V07isrpcqY7WtkQPd?=
 =?us-ascii?Q?M/36aexjwNpQuIJX8iyN7vNCCpCJy9z/q+mD3FDyfsGMxyPnVn9NKxt4zQYd?=
 =?us-ascii?Q?Y5hGA88Kx3GDvIwD9Crl1BaJSdNLkxWQWeh4PaceTAdlSFI1NA3LCafnA3CJ?=
 =?us-ascii?Q?8T7wvSj2E09LHNH0Zs6P036aVNyMnP8LxWEAB0URLVlHyCcKmHfwXybLS/Q7?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67dab67e-42fb-46e3-ea2d-08daf2956d0a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 23:01:22.1389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0yLLVN65Drt8JFJIg2+21DoM4Bkpf0frGhTSRAjtLAufIU3w75VWlftzSQEZNHOCX/In852XTNQD0CraJxm1mrONpADzjrjt/8UV6hO7s7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6167
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

On Wed, Jan 04, 2023 at 01:17:32PM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Submit the correct number of frames in the function
> xsk_populate_fill_ring(). For the tests that set the flag
> use_addr_for_fill, uninitialized buffers were sent to the fill ring
> following the correct ones. This has no impact on the tests, since
> they only use the ones that were initialized. But for correctnes, this

tiny nit: missing second 's' on correctness

> should be fixed.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 2ff43b22180f..a239e975ab66 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -1272,7 +1272,7 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream
>  
>  		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
>  	}
> -	xsk_ring_prod__submit(&umem->fq, buffers_to_fill);
> +	xsk_ring_prod__submit(&umem->fq, i);
>  }
>  
>  static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
> -- 
> 2.34.1
> 
