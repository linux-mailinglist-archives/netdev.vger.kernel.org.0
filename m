Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352AE6BE95B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 13:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjCQMfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 08:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCQMfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 08:35:20 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9A473024;
        Fri, 17 Mar 2023 05:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679056477; x=1710592477;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7slC59EyCIBlX+btQJck03wPgYpI2TpEOA5iEdOFdk8=;
  b=irfJ1kaqdrSwicuUCwJkaDrQzi56FoOf01K4SOCGSf4UsYy588a1Hsxj
   WvhAZ1e34+NjULyUoA2ZgQmPgkGP9GGBOtaj8xbrGDRWSDoeDpfTIvOGT
   vQHJv2UhEF14BkS7TldRATis63o9G2+GOVisR5/UIzOSitFfZSSdEQJZ3
   F/b6sXuAkq+l/uM+xBw3doKxJOzLDfCVQkr7XNWBb6BDlLm36r7qKGPab
   H18Y+ddlsLY/vV+Y7/5nn2Q5CqE7ahy5WAn91EPy0WldCfzWUi17cejM2
   HgY2cW83+r+gFM0vipfshWrCSeI4oQdAh3zrNJxBu2uIwuTQ3mZ9gNxu3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="322097259"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="322097259"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 05:32:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="854428648"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="854428648"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 17 Mar 2023 05:32:58 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 05:32:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 05:32:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 17 Mar 2023 05:32:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQh4YKe1Mqb6TqzSh3IenxUNmF5cH7L9DqTGbTL4eF884yFTIz4zESARTkIhdO24aw9u0OQbz8tVK++TmR53o6cG63+Whfk/yLkOoozX3+stAcuh9xPbOosWEb3OXD9KLFzGjvC52Ihx9D318kEPHriP5T6sLu6p4tnJrtYbX4CZoeo1o6IVX7WMhnt2mAIrKCPdL1fklK/Vea7iy8a7ypTSykLr7raKBg8H6BDEjdRzMdpflfCgAkKz6xBKckYDrC5SbpuQ0310N6+v9WyXPc8YrY1+uMcDVsbwYbb09Eq7YiarMEUvYAAExdxMNWY5fDhsPauhgs6i7t7uoMFmVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKmXW8+PPuuPmw7klDHny+d+uCRnx0hbgIcgTLcl+UA=;
 b=TtgpFJlEXsexTEUbwKjlmddD5F82lpcXaLFY4IsK/bbGkVXatV8PTptx3PvDDXN9MvzHUyzk0GR+Itfuwwy1VbPe05DwyK2RlKEyf6EbBdft1Wo1g8936PuoRKj8lkQB3h4QMeWGeg+9CqCw8RxXwv0dT1aj8m5xC21huI9lhLTSPCdEB9om/guCPeMILR3pK2q1sJUToy5Ixa5UkGK3Og6Is/kgfQY248g+AQLm0+T5wOWQ9Rgcp91+EtIYW4VqaIF/n4bKov6jygtFc6P42bHwWqTr0Ov7MImaioBz/QIsZn6QCHUIw9gWytnpcCSrfwqjb+FaTNBk9MgnQsoPcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by SA1PR11MB7086.namprd11.prod.outlook.com (2603:10b6:806:2b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 12:32:55 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Fri, 17 Mar 2023
 12:32:55 +0000
Date:   Fri, 17 Mar 2023 13:32:53 +0100
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
Subject: Re: [PATCH net V2 1/2] net: stmmac: Premature loop termination check
 was ignored on rx
Message-ID: <ZBRd9Wi1I8KQCpYZ@nimitz>
References: <20230316075940.695583-1-jh@henneberg-systemdesign.com>
 <20230316075940.695583-2-jh@henneberg-systemdesign.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230316075940.695583-2-jh@henneberg-systemdesign.com>
X-ClientProxiedBy: FR3P281CA0102.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::17) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|SA1PR11MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: e80997d1-7874-4108-9450-08db26e3bba5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j64pBchm8Ma59OEkbpaqlQKenjrKSdmmieZjM2zh1UZpiId3P+zcKzTDvXnlkWzv4toXUPvbZdg3VVyK2cuubpvM0Xc9qOj2f5dzvpeps3vUf8w6p5bHZYp+2IeHES9IRy3iEO0nxgKzCxrSjNN4J27bFZ0o4V+8AVtAkPGrhljpYADyNxWF5x+Zyy8X4JD+jfzhu2THAVIycv3agwBQR8xmKsYvTZSUSH3Ge4Q6T2Im3cL6Bj7+RA6kyZWv3eSKWuvQG+AZT5szV1PmMWbumubjRr+0qQLfRkNHY6/7Lr/c7+Uo9CNmpud9RffA6YBrKng/T9xNoAjQUJQnKipX2Zlvy988sseZTie71WXIHrEfwWRkRF3WmUre+R+9FkoIg7gi0VSZCzlgQ8aMZjqpkz1HxTzdAceBCMwMjsIL02Fjnied17Z56OPTDJzsd1HXXzxbMyYwm4osI3gM1srrYqyYiF+otVypxgB9z2SCwQkCXgIgmsHElo5J3y9uIqBOKeYlGjb+kB7eo3atRDe8iebY7vHUhmBHLF/8dwZnfjz9tHNrrqdyDDbL8H5wRkGkpOUtV2pQHkowIfY+HvN2e4TuV0T8/b206zfg/5aKjCW9c7pxk3cEkqMDlIQIzzo/3YY/EaNmWfM9Xm1UUDbCx5dkDMR6JBSws2JV7zYWRRU3W8+OMaR4AVVulMIak805
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199018)(478600001)(6486002)(33716001)(54906003)(38100700002)(4326008)(2906002)(66556008)(6916009)(8676002)(66946007)(66476007)(316002)(6506007)(186003)(83380400001)(26005)(82960400001)(9686003)(6512007)(41300700001)(8936002)(7416002)(44832011)(5660300002)(86362001)(83323001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uZOk8ZdbFXjnL9hD8bgrT+76XLRFAp4Vpy9K6niaRvZBB1LLotrq+n8/COxA?=
 =?us-ascii?Q?8kg1qV4PmH76KSJFOJyXzp8opQBJ6mubnjunhUh8S+Qlj7uw153WootdrPOo?=
 =?us-ascii?Q?S1O3sOWpdcQcaxH02WDzA9Y84vU3lnZ3AuA063+kmugGziynZxWcBaDdiUSO?=
 =?us-ascii?Q?Bu9EsXX6P2n8x7OIQGsm8duyMtDNy/c6+wbAfcBLpMzIiAW5ADszdIrj4rJY?=
 =?us-ascii?Q?Kck/Z8QA02vFJ7p1YBBtqr4NEbnr3Se1Tf3+DsRnCelnXEkwBZyfXzYEL1fK?=
 =?us-ascii?Q?8A57MmW4EV0d3GI4lrjbt/wimQuLIB1m/GNiyWpeYSJVHVHH98zaxyIp/pQo?=
 =?us-ascii?Q?92otx+wPrBNDplqwG5B9kaTtW1o0pVT2UFp+FhRbFBSI+npTnJOzgNsD262G?=
 =?us-ascii?Q?ot0OIiyzw/VMRwAf09hUJ6kolmzOWoj9ndGV7YWVxFDQ3CGjr4kE/xkgqqkK?=
 =?us-ascii?Q?dGfi4ttuI+funNg7p1usgGF6vbfqMJQf9Wp8g/lyUyC++quWpErook6UgJCr?=
 =?us-ascii?Q?/KJFSnAhD7lV7O0v91rv13wE9MFw5uosxDWLfDsxPEkUPCw8xV9OpKNTH8vg?=
 =?us-ascii?Q?nDRiujMFBBjYhUrbwiTtwTL4RuTHilnBPaP1Zm5hrHlDExvLI/TgZn/bqMnc?=
 =?us-ascii?Q?5c8v5vv010gOpKAhlRLg0FK7PyrWEzd5/mAbKuaXmHFVmrtq7o755U2P3qFc?=
 =?us-ascii?Q?QEWIultM5p7EowIHpVYjSf5RanTVXEbRUnqgR2r0na1klZlviAs3nw+EguK+?=
 =?us-ascii?Q?MCz6mLtzwmcFWu18TPZONVAvE/UeoboLJSl6wfrgJakcveZOuTUsMy/cYJja?=
 =?us-ascii?Q?CcTxUUbGgqdUI5ODK3CzGPALAUZkyyNwJRYFRcBATAlKtlXY0+zf7Dkfutsj?=
 =?us-ascii?Q?zXH6bhHr39IPEuLwfZBiDBsqxUhuhrWC+FlM/du/94/fdcl0yxKbH4T9bxqm?=
 =?us-ascii?Q?j7r3oppP4ZejmxnbOR1wAB38O6hqTZ3fGbI5Q3r3Kixh5r4ZLjcaBUIu2cP4?=
 =?us-ascii?Q?zqxouKCO5Z8dN3x3INLDbjF2SqrWsUy1y+DJhseI+gd4/NWvzIW4P2ERYhAB?=
 =?us-ascii?Q?VQ20EfsAsTOWJGvxCfcaXx+evud6XomdcAo8mHdoEXhoa6eSWyMLg8UxGeqy?=
 =?us-ascii?Q?nMN0rnZE8TcGPu9GCbys32/BhN/eU0VEvCZaylDgGyyx1r/cEp/TTsLR9TOC?=
 =?us-ascii?Q?QmR9Gp6JRCDX5caX2Ezz/S8Hsl+xfkxYwTuiZ61jOyMX24sSNrMo1Lx5HJix?=
 =?us-ascii?Q?1dRlJfbYbLpSzcikM5HNKY8CxIu2J4GTYXYu0MXVwWumjHKGBpn6CJ6VMjBb?=
 =?us-ascii?Q?euyixLSs9KV2QN8iLTg97jfCKrWAwKOsJ63CbQiMpSxeUo+6+UOa4JEZIdwg?=
 =?us-ascii?Q?1er24ayF6R4SLd/PmXsXWEjX7Qso1rrU6hb9oIzC0gLZunZ8/qLSB8qt2Yh8?=
 =?us-ascii?Q?hoeB180lmTU0soxniuxF6fNWm1QV/VzZoJHsgBBvgeCz0AWt/GhjKhDvW0B0?=
 =?us-ascii?Q?j/1qkPQRVR9exEGnIwPkuP19JnSyMdCGeKHLYVCzkdN2vf66QbhfkIurftCz?=
 =?us-ascii?Q?rlDF4wTy5eSEthaDffsAEezo5H9NMT+ufD0U+cA/sRoxQN0MPNrXsHghrH0e?=
 =?us-ascii?Q?Yw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e80997d1-7874-4108-9450-08db26e3bba5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 12:32:55.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q1+nLFRQZdinJ+y68+7NsScYMoVv2/xdXCD/hd9zAKO2TLTck7xeu+gqSG07DJGOj4CQ3dp0LX3O/9QJsZhpClPidRIuFcLyTdV/tAnYPWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7086
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 08:59:39AM +0100, Jochen Henneberg wrote:
> The premature loop termination check makes sense only in case of the
> jump to read_again where the count may have been updated. But
> read_again did not include the check.
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
LGTM, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
