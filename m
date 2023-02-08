Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F11E68F437
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjBHRTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjBHRTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:19:36 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159A64E52B;
        Wed,  8 Feb 2023 09:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675876759; x=1707412759;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gtb9pJRP4DbmYVS/sc5MLuq5LU0N8KmeVrB8I/6IYn0=;
  b=fat3tGtpNnLHQFLLTm/wpeHC7q//J8Pmi5kDT08NWKfGfbFoucIqEcTP
   xT9gwbq+jBbRI68pvBEuIGBZuVJ/uqOgiUeLWNZ9NlVQ3n3iryDaiIQbi
   Wt9TJ9D+EYm0hMyyHVyGlfszuh1pcTsKCOFKB0CF3Qzd0H4KIL+XtUqVl
   r+pzow6AFKIaArXW5qJe0qFLvhrL0bZynuhoKvsURGsMCFRXyZ5lhBVOV
   AQrV4LUAgFyaWCDMCMYEEYM+7qILS1tn87ReSJ21q1jUReB8r7F2hZ1Ky
   6KluUOPs/AaS7qo/G1tJABBtefzm8JF/LCiWWUj8BTDl7ssIvWuljpjhg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="309512224"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="309512224"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 09:18:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="841260447"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="841260447"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 08 Feb 2023 09:18:02 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 09:18:01 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 8 Feb 2023 09:18:01 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 8 Feb 2023 09:18:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpyZN+djMUj0eNKP+Wj0TezgFdWs4woI9aIxqkC57qq92i+HffVR7gBKsv90FXZYbDwQxuwdSfyd0F15a7beKwKXpAAPBIM/IJxjZm4bCTbG0Q5o4je4F2bAGcjt8a+MCrzBHorZ6Gbt88V1x+FeVbNfz7IAwW6Jx3upTTucDRTEr6BA/axY/1dJ1N5Xv2jqX6apDb88J6W9ddMdA3tFBPUrqfxxP7XLIka1KQmHhKEU3e18e5YRAGfXpGXOfgbXFsoKO2LBVo6fjYd6lUJle0pAJHl6NWr06vPL8IK7swmNpkGcvve5IJr088ykn71NaIndUfuhRY6S9e1cLqC5Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0xvPRDYL/B41SQcYp3h8Geju6AE5f6xZ5nXItyfIpts=;
 b=ZCt104XDSGUysUNXeOwIcCdt2iWADSf4VVeJJgWWcRltObwWubQp+eWbMUtDwO81S8GWg9l9L0Im+n4KE7p1cx1Y+d0aFP4JN4hxfRroNIpHC5D2viZSStUnWCC//cHkJkxC8kzpp49v1i6SJbs6qsQ1D9vZ1qETBW/FOhPQ3tZBdTA0PMdNX21t6Zsdj0BN678NQarNIHvJxBauw2qQqX9eRVuid5B5E1xnBMF5ZT3zgDtNaqmO734vFawezgo9V5c9Q/tmz9MtcuMjsKeSNjZ0hbwtfep1RU37ApvIdWR6lQ656HS1rfjUkAJP8ZtsgGNg6U0KSb/X+hMzRbogbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM4PR11MB6214.namprd11.prod.outlook.com (2603:10b6:8:ac::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34; Wed, 8 Feb 2023 17:18:00 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Wed, 8 Feb 2023
 17:18:00 +0000
Date:   Wed, 8 Feb 2023 18:17:52 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 11/11] net: enetc: add TX support for
 zero-copy XDP sockets
Message-ID: <Y+PZQBWRqyNf9GlS@boxer>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
 <20230206100837.451300-12-vladimir.oltean@nxp.com>
 <Y+PPzz4AHRxZgs9r@boxer>
 <20230208170815.nsq77mpkpf7aamhg@skbuf>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230208170815.nsq77mpkpf7aamhg@skbuf>
X-ClientProxiedBy: LO4P123CA0303.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::20) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|DM4PR11MB6214:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dd87550-8557-4325-67a2-08db09f86d9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WosbyNZZChM0EKmd/4stIYz0hWKTxaPzyA+U1R7oJR4SSlyYTvjshIyUEPQv0Rs/bnU5uObi9oezBB3fIrwbhij/1PiKsL431YYBN/MqNDadJ3GZ9YGQ4ctTbSegjDVXZGpahJRA9kD7VbrsXWLKlgeXPBrn/lhQ+Z9Co9rc6QplwbVOzkL7yHJNUa7p9J2TewjU3p+Z8WaRqye1g6RcqpnIUTDTzA79ZXMFyGGlK+9crSbT7iD5T/mDOQj4FGQ06qnOvAOyEXgi7WGZoENm3SCg8ic0Cjg8WIDK0Z8MtWW7z9UjqMB63FQSLPGB+fSB9wdPtJBdzaYyPSi8/nSJxZsfbd6ZUpykWJ9rqf3hpQMVRjEDY0bWoa9LVwAXSMdxMS6d4wfiFDnFxyPMABDKlQH8L5LF7AeN+oLx29O9clFtOF2Bugj1dwnBX7+qbbOI7uYED8V3brRo2rX67OzLo7tMhviXyE0eYX4QPzrNNjHGwnOVg83R/i57Kc8oxU3Bi6Vil00umTvgIWFxysIMGdN0tnNgUnwrRgdJvpOkPtb98BD2Pf1jeAAuLXUSTSxGJQtsFdbcOUX3l5YT6PTE1ItI/LTFI7yn/wjYWpReipmgTAjzCTEgc4SvPfik/Nb6YA4F0y8s8DzfXXAGS+l5q2d1h0qDT1CJZO7XBJ8o9+9VC7b+/oN+CjHCQgF2s1Jp+Mv24kNBWq4CjbEmP5kLPbw3De8FRRtTDP2KUKFvG9g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199018)(316002)(83380400001)(54906003)(2906002)(44832011)(8936002)(41300700001)(7416002)(5660300002)(33716001)(86362001)(38100700002)(8676002)(6916009)(66946007)(66556008)(66476007)(82960400001)(4326008)(26005)(9686003)(478600001)(186003)(6512007)(6486002)(966005)(6506007)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KtgZ+rjCIoISg+oCemgM7pJp4QMqVt3OpmDFokCxhcCbUFnFxMzHkp4s6INA?=
 =?us-ascii?Q?r+71j41sJM6NjJrsSSV2XKpQV/h/wkJsen9i6B89YhWu7cTVLjt5hoj9JUPt?=
 =?us-ascii?Q?PbFLBoA6FHjvnfcqM7GJzA3YCwqF7sGX3YydtkWJbOZDKN1GKr/Bep/TORPk?=
 =?us-ascii?Q?HRn+zAk5jMVw1aqMrHXBW4InTdPW6HgLhwnSsjD9Dlkw8g5N33FY2TfPu6KG?=
 =?us-ascii?Q?LvrLlLoPZqKVu7EUJeneLhbCSxl6Wa3xVDizNdP1SIVwlV4U1H4ho9MNpvmG?=
 =?us-ascii?Q?aWvJ7FfiU1EUWUFibzJ4NZILLdPNIpWRWPfMZtNRMFCUZUv5+E3TBerYKJ8D?=
 =?us-ascii?Q?5MKuJX5ER3Tl/SI/lCDA12pzRDKaVvyqbxu7SbkBLY2yz5FyUQYAO2BXPxF6?=
 =?us-ascii?Q?sOzmh8+tOdJgLEtc3PfJvnuXwqpTsv0aWZ8+x8G8GbnBe+QtAi13lsB3KelM?=
 =?us-ascii?Q?9Ncl3oVrLqCPWaDIDSjZ4q/oAXvmeyFiUrphr72PvFOI/qErDq4NnPianw2A?=
 =?us-ascii?Q?n/6o0f8QmubItiBGCiVA3sD/HzZtkXI92YOKvRoC6MMezimgOc9Z+ndj0DAA?=
 =?us-ascii?Q?sQQpI2Ie8H6+776Q8qjp0OqxjNI0HEPnI2WaHIeZvOxRvlgVhiwGWLPvNF7z?=
 =?us-ascii?Q?Hzboego7GhDhPvmP68WfjCw2AsfKiSx9GHvQvf+rzbj0At5ItLct5ZIoWUD+?=
 =?us-ascii?Q?P+MHAjaW5M6U76rxla1tsQi2L9wBO8BBvO7WEl3cZmHmIpCsfWt3AGNbVUEW?=
 =?us-ascii?Q?ywFdPqIRJGU8S8Lj8kwfkmzUFc4YvjtJW/9HImPeyTWch/lVuKC+ak+kklZO?=
 =?us-ascii?Q?ezQAI/zmakQMv/mHzCRcULanh1jpHnJwa5svFePovVdTwX+pVg7PcjnTjkR6?=
 =?us-ascii?Q?Ll8zo9xzhrpVYFFgFAPZIH0Q6X8eewlJcZHkOkUDfKGIoikwMkwuEGlqEw6m?=
 =?us-ascii?Q?8YyBOa7aS3tICbGFui2gH5wcIzzLRb/n1UT083AGAKRznHWZGfUpjDSBru57?=
 =?us-ascii?Q?FpcUuO8YS2bxCAYzN2Y17RjqCREEK78KCIvzUIzQF/AExN3LX0WdFu+owMC9?=
 =?us-ascii?Q?J/O7Ww9WFq1GG3WddE5oZtOFklm7x+ZTNWjJmUcl7RG8k+D7gNPNMHL59AVL?=
 =?us-ascii?Q?YoVKD3vzBy7gkuKuQomzZ4542vJ3qiC7FI44zBqRp6r1JeR3m0oRQk2GCsOk?=
 =?us-ascii?Q?gDO4AIFY5UPeJFQgYJYMZu7sCUReb9IyCMrpJ2VuCyOcbWYr0IL8NpjBLBhI?=
 =?us-ascii?Q?8lt0k4vebYaPgI5h/gB+ERI838i8+BSVONsWH+e7Tg2CxUF5jIh5hQroHYzP?=
 =?us-ascii?Q?rckm1hE53CJFIQIBvgpMfjO6yeOKyFc96bDBIJl05/NyB/0E+Em0jJZGPJH8?=
 =?us-ascii?Q?3sRL37795jqmomx5+WSxN29QTR6Yg4aaoLdADt2F9jKKoE5jy5i2fCPTOgnL?=
 =?us-ascii?Q?OloKWWfzrvSU+2YRuZeMi5F3rr7NgLaZjQE/WkB68jEGTZkcJ+8IQxTuxWs1?=
 =?us-ascii?Q?ni6nX4RYdwQBuaPS6NYpqXaZSDCCAyTrKdFrS09unPqKl0ibitkBipLe9GJ8?=
 =?us-ascii?Q?OUKK349CFELYIBxfQXvn05ocjh9kW14R/Hyo+/G8V0AlioKcUuzQISd12y/y?=
 =?us-ascii?Q?3DnCsSLNXx9cJRFm/5Jv8uw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dd87550-8557-4325-67a2-08db09f86d9a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 17:17:59.9838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CK9dOBWYB6n+AlFhEv7crjiStWWNLOleRnauA14OmBvtlfZqAw6KtMDNbWLw0UtQT70lrER2JsJHUX1tUQC+0l9dz2dd4ahVaOHQ49O8Pgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6214
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 07:08:15PM +0200, Vladimir Oltean wrote:
> Hi Maciej,
> 
> On Wed, Feb 08, 2023 at 05:37:35PM +0100, Maciej Fijalkowski wrote:
> > On Mon, Feb 06, 2023 at 12:08:37PM +0200, Vladimir Oltean wrote:
> > 
> > Hey Vladimir,
> > 
> > > Schedule NAPI by hand from enetc_xsk_wakeup(), and send frames from the
> > > XSK TX queue from NAPI context. Add them to the completion queue from
> > > the enetc_clean_tx_ring() procedure which is common for all kinds of
> > > traffic.
> > > 
> > > We reuse one of the TX rings for XDP (XDP_TX/XDP_REDIRECT) for XSK as
> > > well. They are already cropped from the TX rings that the network stack
> > > can use when XDP is enabled (with or without AF_XDP).
> > > 
> > > As for XDP_REDIRECT calling enetc's ndo_xdp_xmit, I'm not sure if that
> > > can run simultaneously with enetc_poll() (on different CPUs, but towards
> > > the same TXQ). I guess it probably can, but idk what to do about it.
> > > The problem is that enetc_xdp_xmit() sends to
> > > priv->xdp_tx_ring[smp_processor_id()], while enetc_xsk_xmit() and XDP_TX
> > > send to priv->xdp_tx_ring[NAPI instance]. So when the NAPI instance runs
> > 
> > Why not use cpu id on the latter then?
> 
> Hmm, because I want the sendto() syscall to trigger wakeup of the NAPI
> that sends traffic to the proper queue_id, rather than to the queue_id
> affine to the CPU that the sendto() syscall was made?

Ok i was referring to the thing that using cpu id on both sides would
address concurrency. Regarding your need, what i did for ice was that i
assign xdp_ring to the rx_ring and within ndo_xsk_wakeup() i pick the
rx_ring based on queue_id that comes as an arg:

https://lore.kernel.org/bpf/20220822163257.2382487-3-anthony.l.nguyen@intel.com/
