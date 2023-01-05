Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA40865F2A8
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbjAER2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235493AbjAER2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:28:03 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFD32030
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 09:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672939464; x=1704475464;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LSqsI+4TfCb/QcxZFfAyGYxyGsBYzQwHPDmBmkMnSiA=;
  b=N1CYY4swz4Uw2r9QZw/g5tNLmE0uF0RNtjzJIP8ElAlcfD8Gub0MrSu/
   M7PC4ONF36KsflWrY7ODfZgUJu7qSJMKQgmEHF8TlRnRfRUvjV0475iyo
   Gqr6Adfs3Vg/hQE1Jo2iKH9MCh3xyarjO0vtxbN9QaBuoIG/LG3FZjCJH
   jFc+6IYkjtTwoN+mAWlmt5kA0PwqQ0iXYMQTmMfbJPUtorpVvGFgPv21u
   m//KwpdvyOnw7QrRoHyiBHe2p2Qje34JEsD6mojJItzUZ6oxffXMzpCaK
   9XNDx7HyfThtQkTToybP/+OJoAQ1kXQkO7liKjeZylrv+oAKD5sT+EGbV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="408517878"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="408517878"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 09:24:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="657593426"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="657593426"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 05 Jan 2023 09:24:23 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 09:24:23 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 09:24:22 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 09:24:22 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 5 Jan 2023 09:24:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QP2QnIgrQfKhhgcI8PY0cB10JhJ3U5ZW7xq3ucDz0wQ78V1lRaLcGptBl+lmqmZQcMWkG2WDgkRu5e/bUZOC3JRGEwJ0p6KWZEebjeImbF8L0AlY+ig2vhuVhiXcnTPE8cxTTOKKsUjr7zOyFh2O1S1aqeXx/gEG29cGN3OG8Xzm+XORcwIHhWX5HPgivIiku1Px9+kVh7ul7idJI5S01wXEF6qMGgNDeAUujNgSuT6x38liPqipCo0Qo9yd7poaZhSJnisoW93tkHo1532kZ3PuBBko7GiFEUSErOux/v8HaDdNxOBJItmYIUdblVTkqEW+PVYd3FX8GXo4xp+5VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+VRNpndF6F1q4Pvowwyw3jU3OGRcMAITsagTP6eH41o=;
 b=DLIl/bRddeuXR5PuDSrikIQRBfHjfE7IedDUiiEnUkVVNN7uoN+C/NyRPbq0trcg5XOUHcsZXbdXh7sH/DWo70wmKZ38s1gE7Hl2iuEHRSH3LMZTtR7Gl96fG85JeCPV3CDIxdaySFgX1MM1bW5yv3wmCxC+bxbxXyY6e3kglVKIQzcXDlbMqtd6U5wDVHPwVHTXvwAPTtssrBuKJlJh/9Pt+X+EUh3KranhwVkx1nSZxrd/y0OcGhiyV3unIAmWlB0DxulYFGf0MQOVUVIkFYVwA7Zfg3sMMUNYtfkMTPiOTGWIxzlZbfQzn/k6W5qUX6gP8nnCDyY47kdMtdlZCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BL1PR11MB6051.namprd11.prod.outlook.com (2603:10b6:208:393::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 17:24:19 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5fa:d223:80b8:3298]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::5fa:d223:80b8:3298%7]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 17:24:19 +0000
Message-ID: <2eaa20bb-2fde-fe6f-5dde-f84bad49a987@intel.com>
Date:   Thu, 5 Jan 2023 18:24:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next v3 6/9] tsnep: Support XDP BPF program setup
Content-Language: en-US
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
 <20230104194132.24637-7-gerhard@engleder-embedded.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230104194132.24637-7-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0033.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::8) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BL1PR11MB6051:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a1e66ea-7d04-4470-c0fa-08daef41ad79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BT+D2FpHfrQ8IHXGt1HfP5lXsGqU1U6GmSaV9ytvIotapZG2kl3xVLRxtNZ47wZgLcCu+oWetGhn3ZRtdB2ZLDq6bz2N08hm/3TeOgu1J6ZQQV9W9HIrJV6tiXuJ6ed8YXV4mjbkn5l2Y73bhERBFGuqypcGfHq4Sc4IXwH146xECyDPy5GSeNYtjyGRu0jbywM1XfmFbQPt6pF7XsbAXjiq7mck8YNiDAhXhb8eFiHLLtnkLdrUNi2q4kqDjOIBD1mtYmRH2sovzf0TQslOIbmVyFFmHBRPZNhHmFwJq5gfiNT85mxYU2pT6eC1l755Uc9p7JTqbQ4u+eKz3t9P1TXTtJcRLeQWm3D2C6pSnrqlFuu4XGh9J3LNsoaO2Tdl1EYnLRKWx5h24pN/WmygHQWCGL1tnW4dGw4zwJBeEd3ibNJEh5trRfAO5R8APYo7hs+QmBEkCxgXfgiDrSyo7xdBGL/OHtnCbG7x7tMdh5NNACvqQREFGSzbv/l7szwZ8qBbyxcX0u34TNsLtYeT6/4/h9wnkMOtxIzniddeD1QqRCcusN+t0vTMZrtY0JKayy4JZScpEfp1g/rxuyJQHAZd3lfyEPvXa+S4KpdIWkkB18YucTJWrem6nthcmqfzIhTptD+XRT+bIFunutFhipBhc+CkAeLRfI7k/XzHkL1Lw2XpfQMXNNS2zdruIJr+esIr9pHNvwbW0T/X7cOPbnYK8XlRdoMP6iVnB0XsLzal94XG9gyjS034RQs4CWdK8rHgD0Qzm1CQUOaAa2luTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(346002)(366004)(39860400002)(451199015)(2906002)(5660300002)(31686004)(8936002)(8676002)(41300700001)(4326008)(66476007)(66946007)(6916009)(316002)(478600001)(6486002)(66556008)(6512007)(26005)(186003)(6666004)(6506007)(83380400001)(2616005)(82960400001)(38100700002)(86362001)(31696002)(36756003)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFU3M2Vwdlg2UnRxRVNsOXM3MkpCQlZwTCt3aDhzcnNtN1dTZTJlUkhWcE92?=
 =?utf-8?B?QjhEVEY5SFViblgzUzJjRDQ3eTR2a3VaNFU1cUJkdEFxT24ydVY2UnF4QTNN?=
 =?utf-8?B?blRVZmFFVldiL2ZFTzZsVno2TGEzOXpkaTR2bG95WHNtQ1RJS1VWNU9FWktE?=
 =?utf-8?B?V0JNUHRBVGhKMTBRcGtiK2s0QzY2ZU5sZGNaNEVxak1BQjMzNlNLNStzUHNX?=
 =?utf-8?B?SnJxdklwM083UUZtaTNKNDZ5V0tzM3VSZ2Y0bkE1RElVejBIQWZ6Nlk2Z0g3?=
 =?utf-8?B?a0t3NzNlSWZrOUgwM3VuakI2SEluUTRWd2I0TzFxUFNWNmdqelNKYUVDVUgw?=
 =?utf-8?B?REd2VGx2NWFLWDVIczM2VE4rWVkwWjJjZEt1YlBRWFR4eW1nRmw3ZktQcUZl?=
 =?utf-8?B?R0JCZ1diSDNIWEk5VVVBcnMwekE4dXlBeGpLV0doWm5tYXpBNHU4QS83d1pO?=
 =?utf-8?B?SmxyY2VTZjZLbklvODc5UVhJZ1NWTWExaG0za05YMzF5OFh0aFZ6dEFndk5C?=
 =?utf-8?B?bThLREhIRDdRd3RoU0R2Nk5sQUdLMXFJcHpJTE9CcXlaM2RpRWlIYmlOVC9U?=
 =?utf-8?B?ZUFEbFFPVVNkZWsveWZYcnVCaDVDc3FZRytkemozVy94dFVqalU0dnRaTWg5?=
 =?utf-8?B?Y3FmL3ZkaTVCOThvaExxNzJObVhVVUJZbHFHdFFTRVB4c2w5dmFqZ2JDR1J3?=
 =?utf-8?B?RjhiVFJldy8weHRLWVowYzM2K3pNRGIvb3FTM2FJWTgwVitvV0xtenpCQk5z?=
 =?utf-8?B?VDh6eW5sM2c2YTV6SFNvalJDR2gzc1FPWGlLMnR1MHQ0ditsMCszS29FYXRV?=
 =?utf-8?B?aFYzcFBFZy9nTjFXZVZOYnQvSkhJSytLQ0xtUURwVmMrVTArdzd6b3V4aTJO?=
 =?utf-8?B?cktOTHFQMGJkUUFzQi9ZVFIwSzNGWWYzNTdTUG1qdk8zZXY4aGU4alZ2ajUz?=
 =?utf-8?B?azZ2Q2w4ZnZPYUZvbGVYR1NSaUdTQmVuaWRVM2VyQlhiTENJK2VleTFrSHYr?=
 =?utf-8?B?bnhKQWFQeE9Ocytzam1qMXhHSmIxZ2pqRDNjMXg2S25Fem8rTEFTMUMwa3Ja?=
 =?utf-8?B?WjJ2QmFXNkV1dndEeHVHTGNhNEtFVlNFSGNwTGlXTkNCUEJRajY2TG1jY1BB?=
 =?utf-8?B?Q2FyOWYwSmV4TEhhNEZpR2JTenZCQ0k0Y25ybTNEZlhONm9KQWFtZVRkeHow?=
 =?utf-8?B?ZHo2VlFWUkFoMXdwVzJhMlp2QU8wWmVMbkVaMWN1U0o3YmlKZDdhQTBtMWZM?=
 =?utf-8?B?OFJudEV2QWFaRFE0QXB5TnR3NVdCSlE4c2dwNzIxZEJrL29KcVhoY0F6djk3?=
 =?utf-8?B?T09sdWtrWXNlZ2VhZXl5QVhyZTNSWktaSS9Gdk93dDlNL0piTXhrM1VNZ0FE?=
 =?utf-8?B?RUErQVFaRUpVanRCN1FWay93K1ZSNjdvZWRITUNvY1VJSi8vWFZXVUM5a1RD?=
 =?utf-8?B?aUhiK0IvLzRaTkNyR2puTkF2N1I2MTRjT2lac3c3ZXNTMlVkWThSeUxKTmEv?=
 =?utf-8?B?dTVldWZadE1XR3JTSmtjRlZ3QTg2WjlpV1IwUXZhenp0ejNXdlplZk5ILzlD?=
 =?utf-8?B?Zmo4VktXVXdMWGtUb0tkeEN3SFRUbi9EL1FVamxKbjI3QWhjdTMwK1RrYzNa?=
 =?utf-8?B?V3lIY243YW5vaCtzWnk2Rjdjam81ZWcyU2N6NXhEQ1ZjN3BWR2pvY0pmQjY4?=
 =?utf-8?B?Y2thdEVaTmN0UFFSalMzd3N0bk9jMzBOTllBSHdnem9yRUxobFR0cTY2aVJy?=
 =?utf-8?B?dGF3S2kvSjIrRSs2N3JBUHZFWG9aSVY1VnJsN1pRQzZ2ek5EUkZhSmtSdDhz?=
 =?utf-8?B?RFpacjJSWFhyajZnNDNJcnlZSVQvbVg2eXdxTThLbDlXTmdNbUxzTklmelRx?=
 =?utf-8?B?dWRpZ3ZRc0FSMjNIamFjempGTTdyVG5GbW9Xb3dhLzhBRXFDdms3YUlXQlFC?=
 =?utf-8?B?QzZHdXVtNVNZUXN5WE9vR3BXb25oMDVJUmxhcnU0UGMvNHhBaXQrWGdhdDcy?=
 =?utf-8?B?TEhHdFlKanRuUVd1b0VpZFFVNjhxMTRIZFhQRWhSK2VlbFpRMFAvU3lFMUpi?=
 =?utf-8?B?dUgyMDRJMDhrMlhMOFpiS3JoTHR4M21vYkJraTZXYkVUR2RXcTIxcVcyNHV4?=
 =?utf-8?B?SnNJRDBZMWFtRkV1ZnVhOUMrbnpyczJLanI4ajJwSHRRQ01lQlozbDBINGtv?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a1e66ea-7d04-4470-c0fa-08daef41ad79
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 17:24:19.2290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eGgWOki0sU7zE3v2VXt52gO2gT4ABBjmmRg7q0CHTsTdatXAxoZ899H994QJZdosaTv5y9ZnAfy1yS48Y+YW1Rh+xwFZfNIemXqYFOwzdMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6051
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerhard Engleder <gerhard@engleder-embedded.com>
Date: Wed Jan 04 2023 20:41:29 GMT+0100

> Implement setup of BPF programs for XDP RX path with command
> XDP_SETUP_PROG of ndo_bpf(). This is prework for XDP RX path support.
> 
> tsnep_netdev_close() is called directly during BPF program setup. Add
> netif_carrier_off() and netif_tx_stop_all_queues() calls to signal to
> network stack that device is down. Otherwise network stack would
> continue transmitting pakets.
> 
> Return value of tsnep_netdev_open() is not checked during BPF program
> setup like in other drivers. Forwarding the return value would result in
> a bpf_prog_put() call in dev_xdp_install(), which would make removal of
> BPF program necessary.
> 
> If tsnep_netdev_open() fails during BPF program setup, then the network
> stack would call tsnep_netdev_close() anyway. Thus, tsnep_netdev_close()
> checks now if device is already down.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/Makefile     |  2 +-
>  drivers/net/ethernet/engleder/tsnep.h      | 13 +++++++++++
>  drivers/net/ethernet/engleder/tsnep_main.c | 25 +++++++++++++++++---
>  drivers/net/ethernet/engleder/tsnep_xdp.c  | 27 ++++++++++++++++++++++
>  4 files changed, 63 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/net/ethernet/engleder/tsnep_xdp.c
> 
> diff --git a/drivers/net/ethernet/engleder/Makefile b/drivers/net/ethernet/engleder/Makefile
> index b6e3b16623de..0901801cfcc9 100644
> --- a/drivers/net/ethernet/engleder/Makefile
> +++ b/drivers/net/ethernet/engleder/Makefile
> @@ -6,5 +6,5 @@
>  obj-$(CONFIG_TSNEP) += tsnep.o
>  
>  tsnep-objs := tsnep_main.o tsnep_ethtool.o tsnep_ptp.o tsnep_tc.o \
> -	      tsnep_rxnfc.o $(tsnep-y)
> +	      tsnep_rxnfc.o tsnep_xdp.o $(tsnep-y)

Not related directly to the subject, but could be fixed in that commit I
hope: you don't need to add $(tsnep-y) to $(tsnep-objs), it gets added
automatically.

>  tsnep-$(CONFIG_TSNEP_SELFTESTS) += tsnep_selftests.o
> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
> index 29b04127f529..0e7fc36a64e1 100644
> --- a/drivers/net/ethernet/engleder/tsnep.h
> +++ b/drivers/net/ethernet/engleder/tsnep.h

[...]

> @@ -215,6 +220,14 @@ int tsnep_rxnfc_add_rule(struct tsnep_adapter *adapter,
>  int tsnep_rxnfc_del_rule(struct tsnep_adapter *adapter,
>  			 struct ethtool_rxnfc *cmd);
>  
> +int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
> +			 struct netlink_ext_ack *extack);
> +
> +static inline bool tsnep_xdp_is_enabled(struct tsnep_adapter *adapter)
> +{
> +	return !!adapter->xdp_prog;

Any concurrent access protection? READ_ONCE(), RCU?

> +}
> +
>  #if IS_ENABLED(CONFIG_TSNEP_SELFTESTS)
>  int tsnep_ethtool_get_test_count(void);
>  void tsnep_ethtool_get_test_strings(u8 *data);

[...]

> +static int tsnep_netdev_bpf(struct net_device *dev, struct netdev_bpf *bpf)
> +{
> +	struct tsnep_adapter *adapter = netdev_priv(dev);
> +
> +	switch (bpf->command) {
> +	case XDP_SETUP_PROG:
> +		return tsnep_xdp_setup_prog(adapter, bpf->prog, bpf->extack);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}

So, after this commit, I'm able to install an XDP prog to an interface,
but it won't do anything. I think the patch could be moved to the end of
the series, so that it won't end up with such?

> +
>  static int tsnep_netdev_xdp_xmit(struct net_device *dev, int n,
>  				 struct xdp_frame **xdp, u32 flags)
>  {

[...]

> +int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
> +			 struct netlink_ext_ack *extack)
> +{
> +	struct net_device *dev = adapter->netdev;
> +	bool if_running = netif_running(dev);
> +	struct bpf_prog *old_prog;
> +
> +	if (if_running)
> +		tsnep_netdev_close(dev);

You don't need to close the interface if `!prog == !old_prog`. I
wouldn't introduce redundant down-ups here and leave no possibility for
prog hotswapping.

> +
> +	old_prog = xchg(&adapter->xdp_prog, prog);
> +	if (old_prog)
> +		bpf_prog_put(old_prog);
> +
> +	if (if_running)
> +		tsnep_netdev_open(dev);
> +
> +	return 0;
> +}

Thanks,
Olek
