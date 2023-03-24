Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9116C7827
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 07:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjCXGs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 02:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjCXGsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 02:48:53 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36934C65D;
        Thu, 23 Mar 2023 23:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679640527; x=1711176527;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=9cHqpLHTxnsUPa8c9kpDtBW2FSdkKd0hGhDKrXu+dn0=;
  b=V+3entaGMGIjp9+39A6mVSwx8zyGz28BvRogNmX8ZqRO1p+JkFRgCQYY
   t28NPkyl9q9Aaqe21paYYqQ3DkC+YEwvpNvPLW/itTFsQSzyyTonKjKXW
   lESbO/b4NUP2VyWZpQ1Ce7/YJww9AwfkAiADsabcbrEz6JbB0YFE3aEn7
   uoZN3v9pyvQycuy1sf+qpqsUWX6QvKnCVg7+J/zB6gSQYDGPZZgvaDZgs
   fmbctXXiUx6mAO0q1iaSc1pzvAZOsHB9OWy32xtLqSTcKA2M47bmmaLrG
   rLmlJ/38cNypy5wV498ZuS++jJfM1JQ6CY0D4A0nKYZ4gB95N3z2KKIo1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="341277006"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="341277006"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 23:48:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="771759746"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="771759746"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Mar 2023 23:48:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 23:48:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 23:48:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 23 Mar 2023 23:48:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 23 Mar 2023 23:48:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XyNKfrs5lCY8DIjJIi3wqSBi9vq2vkCG6J25xyKA2DAocwTGu/74MK2BRl77CByEqCGlu9CkitvO4gV8qi40MQuGkmxadPpBQyt3N5GGQ467zyCcSqK11qNWKyPqTiVFEvh0qvAHgipfrq/isnqpP6wXlyCXjVyMBzN4HQ7gipas6CirGgZ9bCPCRTIUYIqaMa+TdMtrPKL2D29rp9PHifE9VBjH+UWWTDJnM9fKvUsloH/Z/H/d3itGWwrE06pB0P58EcSkloSNGdT71DEKgQCDY+CLaKLjGjeI7XrTtI/eYWx2cMk/vDS+CBrtco/XuyFU517cEypaZ+7ecMcJMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8nZRGRvk5hqzrv3l1KL7UbqtfKuHdMRRkhdbQrT2eQ=;
 b=KM3m190m+BD6lvZLjSnXB2goD3JyFqR3salmuJ3CS859yrq95lYjHiinXkFhmaMO3jY5ICSKPIP9r5fCmH+4kB0/wXQqg8sD8E0ZIA5BBdLqF6UFEurSrWIyr9tCheyJTb7SbIH08FznTNENSsrQG9/rKtm/UsJO69SYJIbPtxzwvr27x+d36TstpgiTnT4BXYIroCfWBcNXNMxLkaK+X87pbwK66z9tRVgtcqZ+GZpWkwBXCMuvnJwbSDRGeMsny503PL7ATz/jCW3TXtlEdBwbAEG4RvpSOExxolXPp4HfZCXPx1eajFuzyavxot7/L+e1dQar3gaeQA4ZsTJLRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB6097.namprd11.prod.outlook.com (2603:10b6:208:3d7::17)
 by SA1PR11MB6736.namprd11.prod.outlook.com (2603:10b6:806:25f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 24 Mar
 2023 06:48:43 +0000
Received: from IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::4381:c78f:bb87:3a37]) by IA1PR11MB6097.namprd11.prod.outlook.com
 ([fe80::4381:c78f:bb87:3a37%8]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 06:48:43 +0000
Date:   Fri, 24 Mar 2023 07:48:35 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Nuno =?iso-8859-1?Q?Gon=E7alves?= <nunog@fr24.com>
CC:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Christian Brauner" <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next V3] xsk: allow remap of fill and/or completion
 rings
Message-ID: <ZB1Hw6XZnrDLLNhA@boxer>
References: <20230323210125.10880-1-nunog@fr24.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230323210125.10880-1-nunog@fr24.com>
X-ClientProxiedBy: FR3P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::7) To IA1PR11MB6097.namprd11.prod.outlook.com
 (2603:10b6:208:3d7::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB6097:EE_|SA1PR11MB6736:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d36c5e8-1c3b-4f15-fd81-08db2c33cee0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w38a0o0tYRj23CfvNU3QMPqpVZY0Qw74iwqEe+6XOflx4BMbCGyOqYreD3McBM4iySC9ThDRjWGYVj63R4yNJUwgWcrGLAr1yFCAJx91m5Cm5rU4nQPzwKjc6byQy5RMgkLdeKQ1uSIZS1MKDgjhVUgsvAER38GVZkngt7cSKp5GIBIpZnKW3FRpqMbpKCvocsbbjhtblvwJOkVEUal3v3/VIgPE1YXZ9BAC8S57MrK4n9O+jAQUh9lIjp/Hx05oiNsKjyx9G17hDzsWTa/Hrv5btb6wj4aCnT0M4ls2rL8osgnchT1RA3Cm1ELAkk3iF3ynHTNoyd7pDf9Mbl+3CYdUrF7C94u9K82DzYqgCtHl56JMhGUOpYpUhIwkWcQvJu+wbNaqweOeugtWZqze6LeNES4KZhVNP2S3ap50gmZ3Xzz2dPzbASegANf89O/Bm6f30VLpRcCFbal9hX7ehKFubf81FBYzOzLOUTlBwqDUd/Sf+vzzmPGPjgkfZMKLAuW+5GH/7U71Q7mmEkEHGIEnecXPciAVt84OPSjd9N9+npdSBgLygTsCXlqg7in4QQFPT5oTg7ACdG1nOLWkEbvqUlXrPlgP+quJ5CrctsGmYyJu+ynbb/IyTWHz/DOt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6097.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199018)(83380400001)(186003)(26005)(9686003)(478600001)(6486002)(6666004)(66476007)(4326008)(8676002)(66556008)(6916009)(316002)(54906003)(66946007)(6506007)(6512007)(41300700001)(8936002)(82960400001)(2906002)(5660300002)(7416002)(44832011)(38100700002)(33716001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?kAklK8qlxUA1bOMcQxSgBdvfGV5ufdEBdDD4747l9REOMoL9xRuxd1D7kS?=
 =?iso-8859-1?Q?dfJhZq4X3DMVxe72FmkWahc/wPoRuLwPdHJ1yk2UiEPQwxW2lXZt0pH6Up?=
 =?iso-8859-1?Q?Kv2btRT1C13snA719/WY4/ujSKSXgP/W4Dw3hir+gm79XaH/RJPNeSjpTt?=
 =?iso-8859-1?Q?+u0H21WcfYCJTFUeYfc33ZmU4I9tCMFx1YOypdYgVQPJp5paQhjwyZvpu+?=
 =?iso-8859-1?Q?WyqGf12sU2n8i0PVVXqJULIE0TWJuscjlYfoTmWyTFzsISO/BDiY+ZfW7l?=
 =?iso-8859-1?Q?t/8AzwPXhAHxPPvgWSxyZQnRdRQW9J5XzLCUj6E5hDApwLZ2GnNO769myv?=
 =?iso-8859-1?Q?x70KAHi6umKi7QMQwQTUNfP8Bgcgxi8M9cWbLNjSl4IryyCzeo26GTBLu1?=
 =?iso-8859-1?Q?xfDYyhPsfja2bHedKxE98O0Y4uXM5cXV0C+qEFEa89a7f5GgJG0NNGksNI?=
 =?iso-8859-1?Q?poWg5uyy1PbR66HFmDL01iVH8jkGOeWEkaryH7NTcdD7rfEWMWYzypSKwJ?=
 =?iso-8859-1?Q?vcyhyNSc6tnFzp3Uw+ogCgE5QzyalTEWkPXOuaaKsUEuKeBuhelZZBlNGt?=
 =?iso-8859-1?Q?7bXB4iMTShuJRDjiLul+zev3fwSsh5BI9abkIKgMSsiPgwGL6/zgHBwVSx?=
 =?iso-8859-1?Q?63BrFTujV1DnbGF8u2721m+OsfMDgMStLN4qj08RiAjcpjV0feZpk7pZie?=
 =?iso-8859-1?Q?JXGSpTpsIxAvaLv01BXIPtedpgjFulmQ1g5lKqKy0hi5f6eDD+vpivs939?=
 =?iso-8859-1?Q?tqLpaT5Tch8lXA/aaYFFji6seoL3gGs8O5EHYyovwoBcR/QhgL/MQewg4b?=
 =?iso-8859-1?Q?yODn1/F7p3kfvmpqveYA4EVIjjUEoDbKkZ+n1BlV5mFe7gr4PAItRPV38G?=
 =?iso-8859-1?Q?SuhezLHGrg1TkS8GwHLYli2gXaAi2taSD6YDOqJzelvFTVuajtm5zG8Ze9?=
 =?iso-8859-1?Q?JMOQ/CeEuPH0UYYnRYSbKX6fOQ9O24tI8xISDO9uFA/5rWkVY+p8u+DCZI?=
 =?iso-8859-1?Q?YV6+4cLuJgopZHk5Yb0YvR+LusNg+l3uSK4KRQdm30lv3IP5celiK9ubE+?=
 =?iso-8859-1?Q?r2a+nT0WgYX6z9SzGL9ML/j7u7aLrDTJJ6Lp8nskgxVTQSQ70opCDhipnK?=
 =?iso-8859-1?Q?ZhtYoS4OPQOjDCT2aE3y+lpZfolMAavf9iIboUszaUz+HK2OGDHJNvyKJk?=
 =?iso-8859-1?Q?nY/CW//68E9zVdGciQOsvm01ooa/31YD0DC9aM5YX5D9nisFvJxcV+FN0W?=
 =?iso-8859-1?Q?wJXkmI3CeMR/8fTBCSqw/MS+ZPgAzw+X02VSfYrWUvE+thCmoG6+MphHDw?=
 =?iso-8859-1?Q?DzjKX7Nn/qn3qijiaeFLue5k8R+JssaOIK4jVOt+Q7gXsrR0rkDsSIR/oi?=
 =?iso-8859-1?Q?C/SEY9k6tMx7zCdrLIcmq9ytbGTQyW7WnIOfQQdvJvrd8UNCwiOIYdPNI2?=
 =?iso-8859-1?Q?OZH0QAzLZ/O9DaV6L4BQmIcbF+mkoK84jtp723lThXSYyD0AbWwRVlH4s+?=
 =?iso-8859-1?Q?ztc1zqxHy32fCKaQfrl22N4E28LVzy33ijG1PXBpNSxqhxZOGtvlKFdBtT?=
 =?iso-8859-1?Q?rDbBWIGYe9O/dkcFqfYOlzwKgStlz7WhNzbXzH+NOY0IQtznt9NAFJ8k4W?=
 =?iso-8859-1?Q?6rxIx7VLWF+Gd/jt2j6vZf7rVg7iDhbKGtu0x9Iobsm0oOa+t81znU7Dsr?=
 =?iso-8859-1?Q?ZbQu+y6RGxWRloNUQNE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d36c5e8-1c3b-4f15-fd81-08db2c33cee0
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6097.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 06:48:43.0425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QFS/O+b0QKSedWvw+ON8E7BJX8XJocbgwLpOr7C695opWPkX0Y2WpBhbaM95c4jShahtIxlcq3fHEz0hjoAjF+Wd0fgRnbAejTWloLOa458=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6736
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 09:01:24PM +0000, Nuno Gonçalves wrote:
> The remap of fill and completion rings was frowned upon as they
> control the usage of UMEM which does not support concurrent use.
> At the same time this would disallow the remap of these rings
> into another process.
> 
> A possible use case is that the user wants to transfer the socket/
> UMEM ownership to another process (via SYS_pidfd_getfd) and so
> would need to also remap these rings.
> 
> This will have no impact on current usages and just relaxes the
> remap limitation.
> 
> Signed-off-by: Nuno Gonçalves <nunog@fr24.com>
> ---
>  net/xdp/xsk.c | 166 +++++++++++++++++++++++++-------------------------
>  1 file changed, 84 insertions(+), 82 deletions(-)

Interesting, 166 lines touched whereas v2 was about only 9 :) Please make
yourself familiar with Documentation/process/submitting-patches.rst.

Tell us what are the differences between your patch revisions, e.g. how
did you fix the build error that Daniel reported.

Don't include irrevelant changes such as style fixes to this patch.
