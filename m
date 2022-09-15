Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A384A5BA01B
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 18:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiIOQ6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 12:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiIOQ6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 12:58:03 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5088D3E9;
        Thu, 15 Sep 2022 09:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663261082; x=1694797082;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZbiKQ5oJH44+qp3PvMJECZZk+4XB1B8XLNCWAfUg8EQ=;
  b=dhFD/alP7jLse0tI4zZRrhoGbE0KaRwCP1y8STFRSgMzFBIDnWimOVHl
   G6grjFoKyxAMbW3uOcagNfaMWCPPpK2KVyKcFoIIPmK92LzEPrNaU97Pr
   rUqta3rN6emg4w7BE9YZXrxxBqPZdfVjPdPSJUm/+UcT4qiTRiOzmrXt9
   mU8HwG64lD9WJK9/TuyB6MYsri12n9nMTZ3ycdSEgbCTt34qfoBtSEvgB
   nkoDFCZfwGv6RgwPNu2liwDq8lfl+a0Hg5zp+iD9nR8ADiZgeDO5810UV
   1Wda4eX5RQB9j/MUQfXQIFmO4cvI1lIEryRO5iCDD7UGrE9xVU9/uIJ8b
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="285813455"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="285813455"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 09:58:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="568504026"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 15 Sep 2022 09:58:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 09:58:01 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 15 Sep 2022 09:58:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 15 Sep 2022 09:58:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 15 Sep 2022 09:57:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEwN3OPVopkZsgos0SqRYU5gmSX1+Zaz7FQWXFUWzMH/vRACog6vwnrLwqPAem/p5i6J5FHwnrWIocpJUv2ht74d1dkT8Ww5qvftGhAFmdWKkQre5Z/0PBnwVikegLc8RG9Z3vMjTIO5pT9/w+Btmk2uDNUoWeuYyxTctRTdRDEFHxLr00RbkjrCtT8BgGe5yEmU1IV+JXroS22s1NEfMZuXWzaeQcGUAX4Iw61IKMLhXpKcWqPrDXpFz9gj2eM4b2B9TYXyfgbDhSV/HQvTstr7G24D7zui+ztMY+2BD1UYUzdl+BA0XHCqIw2usHc9pJCkoWk4oViCYZbnVYq8SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acipTvdeHbzf6RfClhX70OE5W96Z7SiCofikamRFdt8=;
 b=ma91auHvzpnsLMX56Lxndq9BwxTe2H7vGiX4PMBZcBXDtIAnuWPBt1qk0NqoLwMyP41y33KFsnVq6RyoU6lAMB9hqsUBmkvYu606aXyjmphvuekmOEEYXDzb8XDcW4qUIhxitsytEhgRqLZT0PkJoQyOyYX+hYeXAVIVTMBNmcrdBlx+uc72vLn7dkWBVZHEowA9O8Vj/a3nKTabxmfhcdtaVplb+jG1bPVUVsaaClhSqX5duN0YT2gcwR9RyxugChhs8sNiX417EmjAqeJoGlnDdsXQmaDZgo9tAvkckCspQKOwhKaBgkW700Wn1wFIoHbuv0LePSVDS6/XTgYFtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA0PR11MB4751.namprd11.prod.outlook.com (2603:10b6:806:73::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Thu, 15 Sep
 2022 16:57:58 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::1967:b7cd:c851:cb91]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::1967:b7cd:c851:cb91%3]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 16:57:58 +0000
Date:   Thu, 15 Sep 2022 09:57:52 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Jean Delvare" <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-hwmon@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: Re: [RESEND PATCH] ixgbe: Don't call kmap() on page allocated with
 GFP_ATOMIC
Message-ID: <YyNZkPxbL6q1kd6r@iweiny-desk3>
References: <20220915124012.28811-1-fmdefrancesco@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220915124012.28811-1-fmdefrancesco@gmail.com>
X-ClientProxiedBy: SJ0PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::14) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA0PR11MB4751:EE_
X-MS-Office365-Filtering-Correlation-Id: a09ccf06-18d5-4155-3f6c-08da973b70f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 739k2ZZ3iJX7i0WUwaxLNiSt3FwQ7un/WRgtnnudTKIDRriQ9/+xOhlhUCsr2EmgHs9Vsvv4Xz2iiw0mIvftYPmnCgS8rnod4dmLvkuxgAqSjSCEiWpxOucRF3iNgX6HulWnG6oKIBSecUjTDHBMqHrl95+CQcY3COKK5/JFVbO/Fno+44tf5tEyWUf8QaJkJv6jUenwOORHmwjjQA87yeVsUp2zPFUbkojI7tdpSC7xSS+PG+V1qzXhIUDlmAPeccaTu5nqo5UdPweNtnP+PddUlcYKIDZsPWkSIldG8AfZvgGNPHbkF75NnyGZ+t4aLvb6XsjyA+SSxMI9vCO1tH04jRPDjSufqb0PY12cxslRxcOlAvXtEXxWBNIvU6v7DWlKVePuNJpFfLO7QJFqFYLPIHmzzTMCzPXoSD0x1AgpX2KTRKFn1N1JNS5eMi7P2FAzmaGokISj6VFsQof8G8aWGhiL5EdE9TCConhK0voJz5POTIgqHrgGfbZHgcpml+N/kV9DV2J4jOiBB48lk+2u2/XeZoOcMQlGF+zn6DmYqdzXCcsKguropnTuD/zXUssH28eONOmOTb1QFNExkc5Qvgg1gfcfj8Oln3+robTeC1FfmpOLRkYVWeR46G3mQyDXLZeU3Ewa2e38ZoV9V4ZMlQojfGCulxjy+IvVjOr9k6Bcn3RBvNfzFU1RL099qTkJXrnopY7+E2TYRR7NXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(136003)(376002)(366004)(396003)(346002)(451199015)(54906003)(6636002)(6506007)(316002)(5660300002)(2906002)(66556008)(110136005)(66476007)(82960400001)(66946007)(6486002)(86362001)(186003)(8676002)(44832011)(4326008)(38100700002)(478600001)(33716001)(8936002)(6512007)(107886003)(9686003)(7416002)(41300700001)(6666004)(26005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VBXOmYZQMoIYYksNodVO96EPgVoZHRo1MLFGnYmiuWTI66vEdytf/ku5YxZ6?=
 =?us-ascii?Q?Oc7p2caGJYTcQm7W894RmixsdurC6VpmpHpCIlHgwbxIrXZIvq/HP/npNNdI?=
 =?us-ascii?Q?yNEPxw6fuf5Ih++kbIPNvQnd6StTRF+lwVrER34c1B1Y/yGULz4UdV5J7gKa?=
 =?us-ascii?Q?ql+ioc/xJMhl3NQvrCO+oN0dCV/iuqITVj8EJOCZa51y6gvR/e65Q9bhCABg?=
 =?us-ascii?Q?7+uZDUwonlzYeylw0KuYCmd0a/XAghcLvHt3Bb6ou9CWKVn+DWOmdo21tts4?=
 =?us-ascii?Q?zD7f2tViSCDaQdsr5A9DnY92YMIrNgWS8HCY22Pq5eYhtvhaaafUEYq3DOsQ?=
 =?us-ascii?Q?6jyHjjOcLvEVPy5XjGZ1oXAiRPtkQAc9C+6wC9moJNBjcI12avX/ygkFfgR2?=
 =?us-ascii?Q?8mB5Or9KPRdqHL9bCqsEICCnRRNwTixpBHUBnTbsHML90V3izS7XZLVQQO2a?=
 =?us-ascii?Q?LxIcroYgUPeuF4/HyQTuG7aCplUQUFj7QbbWAOkZDeHrK8PdNWFSIkv4wSw9?=
 =?us-ascii?Q?4VuI/tz6SUJVKan7jhIDxw8whjgFIRtbyD3pFcvodDgFjLeV7JkYhyvO/csK?=
 =?us-ascii?Q?gUy2aL+2gSOwBImrgMrvOEipySJ+bfJ8t+FcgtfBmVPGHwthSn4YVns9kZ9C?=
 =?us-ascii?Q?C9Axib2bwb5MufqDmlV8YBNzjctEyI0z4QebdzNYi8JJ2/7OacIlPigD1I6R?=
 =?us-ascii?Q?BX64iBCLz+g7hRuO/Nsg0n37m/jYrRVRQO9ZqyQtIXMNFOn6Sh2r79HbBv8K?=
 =?us-ascii?Q?ILWpt3z6WY3fQnhkf9U7BlYTBjZmLSsgDTm2sq7dMZYJpz3Xh4cqXoZ52GL/?=
 =?us-ascii?Q?w2NMv1aHA7sIs4arXnoJgtAOVedTqPKBZDkeWMLg6ZGlKLOgJBnxJDvmWs4l?=
 =?us-ascii?Q?mJ/r03JwEEMcXM0mY40rSjRbiiekkS86xrOy6PqGRzKll04FFFPVBWNPTEqb?=
 =?us-ascii?Q?wvmhLNRlWUe0mLnk2bUFWfBzdsL0NjtEhe/PmMiU9i3KMdaw6DsN9he/YRHE?=
 =?us-ascii?Q?cacSbGa7PHFfbF+Y8xoc3q0D6BtTlXPzN6H20Es395e5d2XLyB3CrojbDRih?=
 =?us-ascii?Q?0Im6sHEovqUCv15sQZ+EETqhok28oLTd9myOFp26wEKCpa7rUfn58llOkvdL?=
 =?us-ascii?Q?5A7MD+U/ydcHX4jQypFLXaX18F8ylvTuEdwIi08FVRRLdQRmSBB+kr9zMgI+?=
 =?us-ascii?Q?KsxF8NfEIxZDK/FTwWJx9ecl+NjNQcijsFy2VtBCRP00kOWAaV65OE7unTuk?=
 =?us-ascii?Q?KK4Hxm3gED8gVcCT1o1bEDexV3Umi0mXn03sSLBwzf63GOTcvpjS+tRbU/Ly?=
 =?us-ascii?Q?vnT5tZT6DGUOA61PY3ENzcNpESPk63ImHgwWCADDmCXUayRCtfLRuu2gIZxH?=
 =?us-ascii?Q?Wv8bML/AuRjrpv7BUYO501PNhIMbNN5wMHQg7VwE8WmpPz6iOpjrMim3aFJA?=
 =?us-ascii?Q?V06tVgN1qI8Z52RVHc+swMA/vsDyWxt41VcZ0TDeigRMSptyUx8sG1MMtSgm?=
 =?us-ascii?Q?xRcGVNLKS30juuUfsBbrvJhJxvi3faLnTOjGTnL6PSsUo6TAS+J4hy5Nd3p+?=
 =?us-ascii?Q?xCRBBxq/CBaq0HXIAVZ468fC7Vp2jJU4kdQ9GIX7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a09ccf06-18d5-4155-3f6c-08da973b70f8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 16:57:58.2403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WihN6YKZzVAOhEgAE66K7/rofG0BM2o8ITnN9TsXnd9tpWNvtqZrlWtW7XzgwbiyaczQqOMKUY7i5cLG+BLpHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4751
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

On Thu, Sep 15, 2022 at 02:40:12PM +0200, Fabio M. De Francesco wrote:
> Pages allocated with GFP_ATOMIC cannot come from Highmem. This is why
> there is no need to call kmap() on them.
> 
> Therefore, don't call kmap() on rx_buffer->page() and instead use a
> plain page_address() to get the kernel address.
> 
> Suggested-by: Ira Weiny <ira.weiny@intel.com>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Alexander Duyck <alexander.duyck@gmail.com>
> Tested-by: Gurucharan <gurucharanx.g@intel.com>
> Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> ---
> 
> I send again this patch because it was submitted more than two months ago,
> Monday 4th July 2022, but for one or more (good?) reasons it has not yet
> reached Linus' tree. In the meantime I am also forwarding two "Reviewed-by"
> and one "Tested-by" tags (thanks a lot to Ira, Alexander, Gurucharan).
> Obviously I have not made any changes to the code.

I see this applied by Tony Nguyen in linux-next:

03f51719df03 ixgbe: Don't call kmap() on page allocated with GFP_ATOMIC

So I assume it will land in the next merge window?

Move Tony to the To line.

Ira

> 
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> index 04f453eabef6..cb5c707538a5 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
> @@ -1964,15 +1964,13 @@ static bool ixgbe_check_lbtest_frame(struct ixgbe_rx_buffer *rx_buffer,
>  
>  	frame_size >>= 1;
>  
> -	data = kmap(rx_buffer->page) + rx_buffer->page_offset;
> +	data = page_address(rx_buffer->page) + rx_buffer->page_offset;
>  
>  	if (data[3] != 0xFF ||
>  	    data[frame_size + 10] != 0xBE ||
>  	    data[frame_size + 12] != 0xAF)
>  		match = false;
>  
> -	kunmap(rx_buffer->page);
> -
>  	return match;
>  }
>  
> -- 
> 2.37.2
> 
