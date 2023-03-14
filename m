Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231F56B9838
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 15:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjCNOo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 10:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjCNOoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 10:44:25 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCE67C979;
        Tue, 14 Mar 2023 07:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678805063; x=1710341063;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9yGeN7xfiQLFNP7+lmc9v+yVq9rkAyNNCndsDwXcIh0=;
  b=TR8TKs81ThXmERfk4BJa6EMmvXxiAUuNKQpy6NWk4sO0CI+iLp6pN8Iw
   7vQ1ok7W3Wp1yGXhhuzkK4EHvWMtqnwFkBz90yqG10/P7It9994JDmA1f
   lEGZ0fb/sZcJpTAWLC6y84zXxsh3hBNCbkW6fjXM1Pw947mCZ/oJpKssS
   zwpwnPkv6WoEUAcW/qrl4WTx6LqKg8xTyw2bADCpRaiOcUKnwgQcj8PSt
   YnL8HX7J2AXkMuqH55FesHg7+NiAxbDZZPMbvE9oWB1sVvtNC1ltJe1WS
   fvR3bxTuRnkCDIg8rzFxp7u4NhrbdOEByVxPnAEHA9D87hwB9bOOGmer8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317090561"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="317090561"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 07:44:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="768118173"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="768118173"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2023 07:44:14 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 07:44:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 07:44:14 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 07:44:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrhXt4qMaf8feR5SxIHUCkR+6vC1HP3wdhLgxf8t+qBwelO9A4sGAWrTJr3L+pDym6xwAjhc0f+IBq227eTpalQU/fDQcIxK8LPY8J/PYSIbnuOTy37a8qRKGWas4i4Z3jWgaQSKR9g4+Fv6sJP2+UAjYvAcXh1V7gPCeyoohLuHw/8mi4cU7UsY4SNm/d7ela2AbSCBqQ5OEk7xm6IlIE6OVizdHvglAhU+s5dqFmeZRsTRSRhpb48zEgECsKPgB4jhoqXJkFhwwgk/6VLMOLTGuMexOiXiDJD7yeX9bt6pvye7W/W9uQe6ynjkCVjSENxlDrKEWB0Ku+5fLGVfKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/J/s3ribz2ilnkqHCv/o8LLSdzoq4/8ATEm82YCSXUI=;
 b=oMq9XMFKFb+7Dt7wNjCdFl79145OTPPKJgoQ82u7cr9Qdmit+a3jXdG3SIayZ1/pCgo121/APV2jwHMZwhq3sxrOEvUvK6YxPvd7sJUmh7oswpumRkVF74GK3HF6U2vEsQhKZmyKw/9sRRoAVZZqehb7ZkR0mW81RI9eI26bU+G5Txf6P6HJQaWcIe6gi/65sCLVE8BoGOE316IyingczSVV9oD1LKxrBTuekvka67T1K4vN/TR17AU45zo96AeTIvUeOeZOfVlp7Edm57thvOIbCxMDSGpAOSdAx8B2zhd7OBkUayg+Wbnd/nUi5ogtSC4WFmLqP8trCERxW9yAHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by PH7PR11MB6794.namprd11.prod.outlook.com (2603:10b6:510:1b8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 14:44:10 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 14:44:10 +0000
Date:   Tue, 14 Mar 2023 15:44:03 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Jochen Henneberg <jh@henneberg-systemdesign.com>
CC:     <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong Boon Leong" <boon.leong.ong@intel.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/2] net: stmmac: Premature loop termination check
 was ignored
Message-ID: <ZBCIM//XkpFkiC4W@nimitz>
References: <20230314123759.132521-1-jh@henneberg-systemdesign.com>
 <20230314123759.132521-2-jh@henneberg-systemdesign.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230314123759.132521-2-jh@henneberg-systemdesign.com>
X-ClientProxiedBy: LO4P123CA0332.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::13) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|PH7PR11MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 04a2c033-411e-4ee4-a848-08db249a91d2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C7cPCuzWxCaVyZGO74lSYoyrJbp0k1iplMhYNTmpBfwBZiirTudn33wxJDAnjMlFAFIVctMbFmqd8pQG9r/dvV5JEUL9XcOAhQzZtZ38gB5238bYcuw9hnI2KB9heUFnlVBIcZAQ9kFUFD9402ugjrCwRNh02DCB+3FdUxdsJDtegayN26yiJwaBwF2JkoDN3Ej/2LPeNzvATI/+bC4vwMiGYDaSHSRAT2/5w0vjbal4IiaJFyJoU4WAi5CdIi/C3nNPlZw/HKK+uZSaOfQcP591UDJmaG2kr69wthJ0R5Dva33AiR/mZ2Mw192KqNdx4+/mMza3GWg2IedMMbXfVJmsABg42YT+6YbLF1fvB1KFFBp5H5Ri2paE4RLTTS3TT21sPsO41B2FYbXxsUH2velfN0aLk+HmMYPSbFnm6vkm4ac/dsUg1ChOJHhKKah2SXZzHElTz2WKVPHTQDyLtAhdVre7kvMBbURNG4QRjso0CYwYErUSrTkJwGsmdL7BgU57Pf0fB3O1tgC/BZLC5txdGfQMHgt3BzKhn5VIMPdiU1OYMWF8i/zLuQYr8hdlYMUkBYP1/+WNo2NhipBhrhfVEVg++hDAjiQXBTlcFr4De1AdzPNP68Bia+J7I3g4uvT8lReut26O29TYAVYpCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199018)(86362001)(33716001)(478600001)(82960400001)(38100700002)(4326008)(66556008)(66946007)(54906003)(8676002)(6916009)(66476007)(41300700001)(8936002)(316002)(44832011)(2906002)(83380400001)(6666004)(186003)(6506007)(6512007)(26005)(9686003)(5660300002)(6486002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j6IHCWO5u6OEyIq3zF+PQJgBChxuqpyv8Wmsny58GfSL9VZ1JCEi8QBCpRoW?=
 =?us-ascii?Q?W2eCpTsEYljAcUEPB+UvVhUNVTiKsTT+/EISym/+8v+4UcDT/N3boWROFKwX?=
 =?us-ascii?Q?bERZ/WAp16BtNQno6N2JAiEqh7wXdllmfRHhG7NZo/mTUvpxb7DEW1qszTze?=
 =?us-ascii?Q?4bLKGNDdRL5uTmIdoRUSjdf/z3XSgmtxQSE3xDoAmsl3mH9mcptvC37HCV7G?=
 =?us-ascii?Q?xdr6APyenBchw/bjeYNYjI2p2qx2ns/ArAsHaOLPh3ESBeeYJRKWn/QR1D4O?=
 =?us-ascii?Q?p/AbimPhq0a096/auILzE2rQ6fLh44y9DosMfLIkEPcgJpKsNSmPoqmxuos+?=
 =?us-ascii?Q?6cHkpyznBJhwPSibRKBhubfLUopCeBiCzGrzWGKWnzyTtIbiTbdAISqJA73m?=
 =?us-ascii?Q?xyc60oRCBp+Iue7S+/oCmFQr5K19vWHHsh3nMMlmJ9MFU8sKAw1HrN1bQ9H2?=
 =?us-ascii?Q?1WJqb3lKC8oVgfoZ8VyJVfD3fNTQZ/8GLYJEvwg8GkCB7sfbeRnsZVVbb9It?=
 =?us-ascii?Q?CQZ/vmfxeAptvNstwBC7UUouJQknpttArhpI23+FosgPWawJL6QtaHzWyvDf?=
 =?us-ascii?Q?7W7snO8E/I+CLejXOSgWNyLTNDeLig5xYypFqVvyolkXxFxGYDgCQoknhNpg?=
 =?us-ascii?Q?wHfyQLJCpawLKauNwu3b52f5MTcq9GlGRZkBl9T5rjVqDA99vBX+nNGHwoMB?=
 =?us-ascii?Q?HQD6Cp9KamcteIdzHHf2gQVmNTuMsEo31Lv2H/K4SbLvVyJr9KCquIhNXq65?=
 =?us-ascii?Q?qsSVDR4fFz98p4WhtaOafR/S1im6F9T7hMAyKD842cqrgoi3emdDXq6jQNBE?=
 =?us-ascii?Q?pSj/BkBZADIqZAqFOPqxHNLkbj3H+p/PA7DTz7qb//w/Dn1LwSJrghNSEq9T?=
 =?us-ascii?Q?7x2c6/gvB+oweqBLCk2y4eB39hAW5SPsdgsAIDAPZ27eQ2hjc9CMjQwXebzF?=
 =?us-ascii?Q?sMsizYF1xHXm3UyAGsICqNDVnaGG9augtknuAQsbhgo+z5zFeoO30VVzH2Cv?=
 =?us-ascii?Q?icDue8IBB2Y9HpyNg9KjQQExJYslRhsHHhDyQ+y3SltD3zKBDYcuzbQ0wZfQ?=
 =?us-ascii?Q?HXGsjmNvZ+KcDOr0+2W3n8mnyNDfm/jow1WsDG1JwJS02OJGTovPACXp2sJw?=
 =?us-ascii?Q?VMAlh/Olk4sKfD585l1PJgGeRzf8GRceMQ7xsVsYb+LxUROXUmZ0Zm8TgMoL?=
 =?us-ascii?Q?2KrdcrnhSMmRaojwxkqOAtYB/dAEY4Zd+RyYkzmPqvbWd/bPma6747ugcyGH?=
 =?us-ascii?Q?n7kxtI7NKwGwx7hbEYAHZZ5hnd8c4/u6wofbuc250fhzQfxMg00YnQ3QNSn5?=
 =?us-ascii?Q?d2GYqaWcP2nZrHRHhfJDxNqW9s54ccEW0A3jXPiawHFFxrCsR+g+1Fz4i3sw?=
 =?us-ascii?Q?VJZ0I4wSqNRn8+g4Z2RBl33BzbYaT3essa3tJQLzRMxQJQ03x8iTeDQoo4x1?=
 =?us-ascii?Q?7VHK725LnSaLbnxPSw/n1z3T/ngWozfE9G5VwZvqDVPOzLQD27lglYJ+HWxb?=
 =?us-ascii?Q?TswTHoyVkJgZrTOHjYC/R/2T9ZeNL2hmN+m+RPWFOnfsK+fuebPNAVpcb12R?=
 =?us-ascii?Q?/CNNbvL3svdpFesG3PJ19QCqZIyV9lXq1g0XNo/Uf4RCRVo1myMKvkx0mFSH?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a2c033-411e-4ee4-a848-08db249a91d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 14:44:09.7979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PSFl0vJpgy/X9pxklVes4mEQQWuwDYtbSuNl2kcs1+eG26J5doCQ709aBou+gyTU4Or8Buelb1RV18RFvnAqv/2QWSylF3uSkKn/90sfz2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6794
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 01:37:58PM +0100, Jochen Henneberg wrote:
> The premature loop termination check makes sense only in case of the
> jump to read_again where the count may have been updated. But
> read_again did not include the check.

Your commit titles and messages seems identical in both patches, someone
may get confused, maybe you could change commit titles at least?

Or since those are very related one liner fixes, maybe combine them into
one?

Also a question, since you in generally goto backwards here, is it guarded from
an infinite loop (during some corner case scenario maybe)?

Other than that looks fine, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

> 
> Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
> Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index e4902a7bb61e..ea51c7c93101 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5221,10 +5221,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>  			len = 0;
>  		}
>  
> +read_again:
>  		if (count >= limit)
>  			break;
>  
> -read_again:
>  		buf1_len = 0;
>  		buf2_len = 0;
>  		entry = next_entry;
> -- 
> 2.39.2
> 
