Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E6258ECC7
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 15:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbiHJNJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 09:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbiHJNJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 09:09:03 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F1879A41;
        Wed, 10 Aug 2022 06:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660136941; x=1691672941;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qAaAY/bq6+Zxce3LAYgOGsXR3e63R6ljJtVketFDdT0=;
  b=iMi0jLIEpE4JMcISYV6GrAzTmXPldvmxJfNrgOvz5AeUlbzFGByjWepF
   y44CypOkn2ta+yYy+qgkF0m4BlaWFuru7I5XRzCKpS6xZ2cmhT9T4SOtu
   +YwPUMzvLuAHz+ENmcxIxpRPGyqHnvb2P4VqRv+/cAADyDjSgEYl689g5
   7IauICcPbdLGKrGWJ4/GGUIGTLMxgpezPplOgmaKzpirev6zmozPLxNqy
   1RsZhZb6J8WuAZhJKcqDBA9drLJjtNKKgtbd/66HDTq4c0JkWeDDGqSN2
   w8Crj5AM19QD4eGcozLMKYNLq4gUkVAfZ2bN3cTBmLZmzOCVD8+REOvcI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="355077136"
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="355077136"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 06:09:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="638100466"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 10 Aug 2022 06:09:01 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 06:09:00 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 06:09:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 10 Aug 2022 06:09:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 10 Aug 2022 06:09:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEG37fFaRHvB5MUbPjh2pmyPg1feEKZbxXo/FXJmIHvrIuJcGLqJIjKsO+Oqx/f7URXjg6LPNNAsI5esR0O5WjLka/sxt7m/fOKSREcSVdBzadr+jH3vLjyL0UvK/LRR97pVsarAi3a6waX1W6ADPHyvwLuC2ZgNvF6EYcxPxLahtJv50Qy4CAdEA8DFIJB0N9/AfpIv1q9cCl0gGXsPKGa/d1DrCSGLJvW1ofKDNbx6i3ITQqTDPyOHRP2AV7eRbL2NEkhn9lqG+AnNeS6xwWLa9OgqCnYVOldjhLKOwiPP2riB5wQqgMrVEno30AqGlfnia9apuo6+JAx4W6Rs+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Trr2xnuFt0ZeQDzsrcxOdWQUkXBKs3PRIt1l4ZL8xNU=;
 b=EjPamRu855C1gn7ht74kExBUwI37yDiEuJH5a5RlWqoR2UD8qpmYcRyyIJXWsuMhu8NBqYw1iKHllbVhkRTyMI/V7u9zti5puwE33c6CZ23RerY+zd7emXQW5+aYwZVnWjFrxUKgzTV7/YRHpBRBvL/Oj9b+BXru92ddgEivQXl6Kf64tZY/TP1FQyd+RmRgkkXWbxaNYlcZWohH00w4ZDPtStUzhmZBB7kjFlExqWDsySmt8mAqvb0KSq6oze0Yi57SuQ4zbAKywaMQXjUP849IIjA1RM+/OudfefBpQxG7Urj2SvZWQ68JvIRnDMT3jXCrm2Li7t8JBSunejI5qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM5PR11MB1547.namprd11.prod.outlook.com (2603:10b6:4:a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.17; Wed, 10 Aug 2022 13:08:58 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5876:103b:22ca:39b7]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5876:103b:22ca:39b7%4]) with mapi id 15.20.5525.011; Wed, 10 Aug 2022
 13:08:58 +0000
Date:   Wed, 10 Aug 2022 15:08:14 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <magnus.karlsson@intel.com>,
        <bjorn@kernel.org>, <kuba@kernel.org>, <andrii@kernel.org>,
        <ciara.loftus@intel.com>
Subject: Re: [PATCH bpf-next v4] selftests: xsk: Update poll test cases
Message-ID: <YvOtvgdSnOhUd9Po@boxer>
References: <20220803144354.98122-1-shibin.koikkara.reeny@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220803144354.98122-1-shibin.koikkara.reeny@intel.com>
X-ClientProxiedBy: AM6P194CA0076.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::17) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7f5b328-73e2-4344-be12-08da7ad17c63
X-MS-TrafficTypeDiagnostic: DM5PR11MB1547:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OguMeHkcj8HdaD9Yo73FSTpAs9NJ0VN3E3LM815Xif86/jGe4wi9MlW9pvNipFcL+BWPEv5jLRmmjcAS+tBRGF5qY4TD6KQa1ayxeaz5Ps5J7hHWcvTQQBwu2bqKX8DpbKdziRm1dfQfPSyYSIdgiFL4CNq5M5UoTeW/3//Zh8b13STmn5+K0gZTzBwcCKLP3ZCzGsJNeAR/p9IaTQCeNWfVrNPDbQpSxZjZ++c/u6rRg+lfq00SwvB7Tl/HIVIeb+UrB2ZbDbcNfNez3k+P0j9c8c5RT84RiBam9JmkuSPWfpwkYgyA7Dfykg4KAekVd5WvOiYvEHljlLE+7YtjGXnrNgT2VYKEniUC6HuQU2oA2kWJLOZr80o5UZOtq7xCkA0S31OCghexJIYCyCxHOQmu/5no3JljYrhmkD3zhfAoIDR0jUwFT03PXo08ULtBaD2y1b/I6EC1X0GVGBW/PYie5w1C8uf7aMC2sQ2crIeAtM1BzqxuOsylhXZlDsWboBZS0QQCU6hkpnJgVI48lS5n47Lmsy9qL1OC7EgjL2nWnXs0rZF04dKH44fVYRHtPiJ1+PlGNTsOFXt7DE1m/j8haT0v8XHP78MxZXeozYN5TAyPR1oWr71iCB5+wCOHlVFS0jOHf+Qj4+Rn/fjsjqs9R3Wig4aR/jWFNSxzgxX/23edD9C7Vz4vGbJk6+sV1v5wrJ3I0Ozbqk3+gbiDKRs1FYaMGuf5ss026mqCWVUpPGP+2We1iO+MsYZmTEzj9wJPTlDY1rNexaLKe2MkXOhzqXZ0t+uxwSFFhSDxS+SvViJ9ISfUfimJxFcvvdN0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(136003)(346002)(376002)(396003)(366004)(82960400001)(38100700002)(9686003)(6512007)(26005)(6666004)(83380400001)(6506007)(86362001)(107886003)(186003)(478600001)(41300700001)(6636002)(316002)(6486002)(966005)(2906002)(66946007)(66556008)(66476007)(5660300002)(8676002)(4326008)(8936002)(6862004)(44832011)(15650500001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8RKRlu3LdSS7yJneXKcoPzcC6IFZ9dirNcXhD0/YDWvCmPgrt8njYRPggO3P?=
 =?us-ascii?Q?v3MhQKPbqvY102evQGU8TrEImjBaCF1gvpAuZDCf/nVBEHxlPOdkr9fHi2wv?=
 =?us-ascii?Q?Wzo/7n1J1XnK4m5OddP6XRF15+1DrfsGwMr5DH4H77aLg0kcl8Srk2+fs/uM?=
 =?us-ascii?Q?WirlsSJmRCiSaz+gRi65lT33l0zrv4i3du1JmCUVNkOXbZ9dXJrV4TJg+Mdg?=
 =?us-ascii?Q?vj9xSUdCNAGVCdM4/s0y+9PaicClTdPyBsD0WDz7Lo2o9VXR68voJtBXQIXV?=
 =?us-ascii?Q?B/Lf0fa8GlcVE/kXgwrS4w2lFRI3qRq+o5hkjtawV5pNm6O/7LFWXgcrTR8w?=
 =?us-ascii?Q?RSlWFn7o/bbWUOtvWbPPTNYmBOb2zcTcOAz81ypExr5Qkyi0JMk1AG0PtfCR?=
 =?us-ascii?Q?GcKwVm7FTSe2G2Z2CdtQY5/ewNQEFBVYrWE4t9EHyGSq6wM01SZOq2ALmy7Q?=
 =?us-ascii?Q?NVVsTkICXklV/1OTAtA675qJLMWqON7/BbWc3wTLnMuWZxA5IesMnocT2KoE?=
 =?us-ascii?Q?LPR38EvD+LNN7WmlvJtni8onVfW89zGFAvRiwHV9QzxtLex6Xyh93AZkdcjJ?=
 =?us-ascii?Q?FmnG3c5FyqdYNe26EWYw4Pi1MwZ99e+4jkksAK5PgbXITfN2Z9Qr6vShOdD2?=
 =?us-ascii?Q?+8iOzRKMoEKytot3s0AnqX0WSZCixNJtxcCd9btpPFIJvKMDiUWGVfytalwe?=
 =?us-ascii?Q?W0E3ttar4QNSr0b0VomNk9mQIB7YY/Wo6PuqquW/qxgUOTlU6wsjT+9BraPl?=
 =?us-ascii?Q?MNC3lHjIif4Tf3BWxq+nxk/E3j/hZ5anIQgaLjDPHPZ3Pl+RWNUL2tUV2MIC?=
 =?us-ascii?Q?eqO4jgQ55Noke4dNzZgijtq/f/bILk2EIdkeExuMdpXfCsvTpmFsoL5DXl6c?=
 =?us-ascii?Q?CShfbF0qYSxFXlujm3kkCAvqGLofOO0ALoxEP6y59bdzj1ztkdbtkXppBpDI?=
 =?us-ascii?Q?mjSRAm3KN1IvJyYO8mhVSanOkO7fh7H3DfHyFaz0n1dhXQcpSqGxx6sMR5KS?=
 =?us-ascii?Q?0oRmHa89+BpIJMJQEE045i0/p7e3eY1jCZwPvuGwP3JEGKctSl1z0yQz43Bg?=
 =?us-ascii?Q?GC+emIxooZ9ZIiCAsI9YOVY8QHNIPp0CQTm3MIqa4LgMX2ajNn0wCfHcNCWR?=
 =?us-ascii?Q?dzN9tF1F0wXTU55SVnJ7g7DHsnKsuh+4Sp5xWaLuHxRoUVLXo4kzCovBARO5?=
 =?us-ascii?Q?Qqes07IKLKFnkYxG+nJgpC3faKA+KoN98yx5KEytXqq7kpokaxuw6oy2GlWP?=
 =?us-ascii?Q?nEBcd1RG1Dnk6827BuOlKjo4+143fmgTN4s6OZMt3uEhPGGWujkrA3STa6cR?=
 =?us-ascii?Q?bY425t9zXIf25asQVUsV4Ju2Q4nydW7Ekz4q8w+bkcBj+VlF2pmpoUDJhfiq?=
 =?us-ascii?Q?tHkc1/b7jUYiZstKB6amJiuREJn8Qg7rdPfbPmmxFSO0bN7fPKoIybjMRtpB?=
 =?us-ascii?Q?cSDsp5UZDB98nIS3d0AswKzcFf+0IaR7+Ni3pIt4HswksiMQx0bDcJbpBgzm?=
 =?us-ascii?Q?Q5hPjjbPfAQ87iticxrtUTa8wjt6ERB9b06NgBDixwX0vOF2zzRsO/6/UJmB?=
 =?us-ascii?Q?E1AkfLjY8s4daSClZNX7/fusp1jE5lBGMZqmPP59qhme8UryPRIHHquRP1sH?=
 =?us-ascii?Q?kw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f5b328-73e2-4344-be12-08da7ad17c63
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 13:08:58.4541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IWx/GwmYhhvkhYSyyXxNL4Nz0BgojSDtg3uab9ZdqwEuETI/J2JgXWGoaf0TicDCWlqIL9FZYsHAOhdxmA8ZXmKsLOlyN+ifuFx22+WXLNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1547
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 02:43:54PM +0000, Shibin Koikkara Reeny wrote:
> Poll test case was not testing all the functionality
> of the poll feature in the testsuite. This patch
> update the poll test case which contain 2 testcases to

updates, contains, test cases

> test the RX and the TX poll functionality and additional
> 2 more testcases to check the timeout features of the

feature

> poll event.
> 
> Poll testsuite have 4 test cases:

test suite, has

> 
> 1. TEST_TYPE_RX_POLL:
> Check if RX path POLLIN function work as expect. TX path

works

> can use any method to sent the traffic.

send

> 
> 2. TEST_TYPE_TX_POLL:
> Check if TX path POLLOUT function work as expect. RX path
> can use any method to receive the traffic.
> 
> 3. TEST_TYPE_POLL_RXQ_EMPTY:
> Call poll function with parameter POLLIN on empty rx queue
> will cause timeout.If return timeout then test case is pass.

space after dot

> 
> 4. TEST_TYPE_POLL_TXQ_FULL:
> When txq is filled and packets are not cleaned by the kernel
> then if we invoke the poll function with POLLOUT then it
> should trigger timeout.
> 
> v1: https://lore.kernel.org/bpf/20220718095712.588513-1-shibin.koikkara.reeny@intel.com/
> v2: https://lore.kernel.org/bpf/20220726101723.250746-1-shibin.koikkara.reeny@intel.com/
> v3: https://lore.kernel.org/bpf/20220729132337.211443-1-shibin.koikkara.reeny@intel.com/
> 
> Changes in v2:
>  * Updated the commit message
>  * fixed the while loop flow in receive_pkts function.
> Changes in v3:
>  * Introduced single thread validation function.
>  * Removed pkt_stream_invalid().
>  * Updated TEST_TYPE_POLL_TXQ_FULL testcase to create invalid frame.
>  * Removed timer from send_pkts().
>  * Removed boolean variable skip_rx and skip_tx.
> Change in v4:
>  * Added is_umem_valid()

for single patches, I believe that it's concerned a better practice to
include the versioning below the '---' line?

> 
> Signed-off-by: Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 166 +++++++++++++++++------
>  tools/testing/selftests/bpf/xskxceiver.h |   8 +-
>  2 files changed, 134 insertions(+), 40 deletions(-)
> 

I don't think these grammar suggestions require a new revision, so:
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

