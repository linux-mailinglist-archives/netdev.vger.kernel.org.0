Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438175F750A
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 10:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiJGIIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 04:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiJGIIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 04:08:38 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5470B7EFE
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 01:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665130113; x=1696666113;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uL/VL1P9x2eSX1QQxgt9v97JWcP/PztngeYL1tANIxI=;
  b=GGFl/ajPbHHcBDMRbnLI+KaQZeSW6RoLSYWLEoyfzlTjglpYMUlPtjCV
   LLYooTIZLjFpzlFTYmAGiejmhjSq3xdz1tGDR/81IjVG3Nx918uhn5/sy
   6d3V2LaBmjCKL384+K58oLymhWvdiClXij3Aru4oe47LjNUFmhLIy3pum
   XUkLcWwWLO/oHc15AbvoIvJ7HOykhcH1x1uwxqDh498xOdMngIHG9072w
   aw12ZnHYvCTOlTjeJ5k3N3JU8u0FIYlcjawqThXvEn41q3OaiBMFIRW2F
   PXSgzlQtGYuG8gKQWjaXapUEnSMCda38hLmwyRLagrXh8InBC3vbBmSRT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="330118978"
X-IronPort-AV: E=Sophos;i="5.95,166,1661842800"; 
   d="scan'208";a="330118978"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2022 01:08:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="627349792"
X-IronPort-AV: E=Sophos;i="5.95,166,1661842800"; 
   d="scan'208";a="627349792"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 07 Oct 2022 01:08:33 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 7 Oct 2022 01:08:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 7 Oct 2022 01:08:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 7 Oct 2022 01:08:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBB+m4yrON1i1bwl3b5KDy3cV54/VBETAIbNvCPYU5wNdc8t00Ctzti7y1ZrRNJib2PwPYhMvoLXbpIPbHWiO6BN26u/DdTexKHVY5i1zvjjZEFNohug/jMuDK6tffGQda4pV2B51v2mn5LTdLEXDJ9HnbfAb+uDIwozeVaysjOqtd4kuJJM4E+qO+Vsc3FPDeq6KaVYFdSNP4OxcjoPhpjB1zPA5s6cFzHYYIyYX9Ktw4QUqy9RZW4FmI8EubyAqd8Ez1x4JZf4BNwMws+M0Bk/6PCACmPZe5uY4P++Qwcln9xfV99he2J4kL7/1WURWDF/f81aqACUX0ogQME4nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mIB41ezWWuIaDbNpoTsQ7IX+F7WE3yh2QdsZb9vlZdI=;
 b=hpHpBTQP9gADc4BUPojvyoqDYn5+Gk25CO44O6j684b3STs9WmPdWS9h+/HNA7gbveT/yb/sJvhXOEjyqondFZFbMah7nCzRzLO0755SCcmH/vqi1y8kswaDP8LYo2movEWtgTalU0w1X7r3JsYumg4YsFSNkqkuEMt8YIDcdm/8/dVeCFh9AvwLAlwwuvfDW9JvfKpIMzJ9zQ+L4CmeF5BoZrbY5X/lpi5pbS5XY5pw5f7zX4tPXi4WV2riZ7c4RQlGw3qZz9qLvyLUMx7fjMxEyTOf/1unuN+wLVQBDQS2KWhCS3KpJzRJsE6nC/ck/SCe9XTOSH6V65PWsJZOYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ0PR11MB4877.namprd11.prod.outlook.com (2603:10b6:a03:2d9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Fri, 7 Oct
 2022 08:08:26 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::6ae9:91fd:f3e0:7923]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::6ae9:91fd:f3e0:7923%4]) with mapi id 15.20.5676.028; Fri, 7 Oct 2022
 08:08:26 +0000
Date:   Fri, 7 Oct 2022 10:08:14 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Joe Damato <jdamato@fastly.com>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <anthony.l.nguyen@intel.com>
Subject: Re: [next-queue v2 2/4] i40e: Record number TXes cleaned during NAPI
Message-ID: <Yz/ebplwWG5UlU/i@boxer>
References: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
 <1665004913-25656-3-git-send-email-jdamato@fastly.com>
 <0cdcc8ee-e28d-f3cc-a65a-6c54ee7ee03e@intel.com>
 <20221006003104.GA30279@fastly.com>
 <20221006010024.GA31170@fastly.com>
 <Yz7SHod/GPxKWmvw@boxer>
 <481f7799-0f1c-efa3-bf2c-e22961e5f376@intel.com>
 <20221006173248.GA51751@fastly.com>
 <3e78ef0a-db8a-0380-0a7a-ca8571513355@intel.com>
 <20221006225656.GA86976@fastly.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221006225656.GA86976@fastly.com>
X-ClientProxiedBy: AS9PR06CA0247.eurprd06.prod.outlook.com
 (2603:10a6:20b:45f::14) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SJ0PR11MB4877:EE_
X-MS-Office365-Filtering-Correlation-Id: a5d04432-8cd9-4322-dc93-08daa83b1c65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4z+eGamo6dX5hyJEOPbmLpFnhAxMCxqYTiutJKfjlycXhJkmx1Lpz8b7B3/CTpqPrnjhd1ZmjZzU9SFAWoZSoddmZFy07NhXkCHoVTkFTNfr1sCebK/SmUPo4ZBuEysx/yxz6uXtBcm0FwuSgEso/np7Yh92KQ3Hz7wfwbc9c1ewfV4oKIlx375QA2JIZCQB+M9HFMPU3vOi8k1pjn1P5w4Uhc1L/mGNB85W36+oUFFVPX3fP+G71wIWGDMlDJ8Zqj+Jo4vbj4Z9+6lZcb3N8YtcY+h/FCJpISpzNNaTJbCXKLOe30E+Nc9sfJKzyN0Pp6/msfntr3aVf96btZo0ZEShhpcP5roUVrX/BHvRyqqL8cQw5ZzHgjzdSKJPuqvBX+A2mXjzSRCTfOaTnePRMuEtZ0nWqQJWuupyJIn/nN/4aq4aFwUIJzG1DCXsVHKpOtypwzcPQW6A4j3gETD8+RRWIsS5wf8sdvumjuD89Jc57Lf7SaFnDek/e1pOvfIUjm0Mz11qS/Q898008YuPIRrTvlN0EHyuqVWRTQpJVcnZHEiTGmQXVZv4CbX2FqbG114lVAvLGzl8lkAJotM2EnQTEFzNbrevkx6jkydmqcb4Y7pnkHPBC0PprwFtgb6gHihrdQhpTuTqH+V9AQHN1ejwWsaBG5Lb4JEI0SX48OPL2lHQFAPOGL7LjRNNlGht4nNa1J/jGAJIqtSlHYxhIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199015)(186003)(9686003)(5660300002)(26005)(6506007)(6512007)(2906002)(38100700002)(44832011)(33716001)(53546011)(8936002)(82960400001)(86362001)(83380400001)(6916009)(316002)(54906003)(478600001)(6486002)(66946007)(66556008)(41300700001)(4326008)(107886003)(8676002)(6666004)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ECgKRgsE26HEw/BARplVon1zqJ864kqwEAIFXcBxVDE7EcTKtyinWU3jkl2K?=
 =?us-ascii?Q?BkBooI/ePSjLY+b1fXh8/vXvM5jdTEcKYZNwbuHeUbCOub0vDO9KIHZrGUSz?=
 =?us-ascii?Q?AgNRw3XlVz8Xj8A2q1bUp//Ffe/FeZbj+6qjypY0sFrncbizebSHARI8ZC2L?=
 =?us-ascii?Q?ZM8O8BoOBa7Z59/XZ434NLLajM/F+7Jd19v7vY9N8GqvRWzGohOe6idZcdi5?=
 =?us-ascii?Q?7EK0JGGvFYAHbV2q6hY0bmyyO3qq2/i4fWFfv+zlEkY6vceVo+lmPcQnDDnD?=
 =?us-ascii?Q?TX7y834ojN9bIbSC9MSbPggY/KKILU6zNfQ3CQAOXzHzi87wOaVTeTLCwbAs?=
 =?us-ascii?Q?S+6xmBy9kS3i/oJZPjLj1pvnyT0wZ0NykhozK+XG4zKzWD2fRboRWfg7sz08?=
 =?us-ascii?Q?v7Z7Z1jJYKSYK2Z1Gv0kloTaJ2lJe6cGagkDh1IEJ/x+08fSiS6LUmF8Egcy?=
 =?us-ascii?Q?ZXBYRX6JysrNIBbNjsngCtPt7mr8x4tAngd8nJ/sRkORWE94cKTgfWpmSrhs?=
 =?us-ascii?Q?5xKBBC7kRTFeWV5WgKIvchsuGrY3+90RPxKqpyv81WFw8vYd6GOKlruYkT3R?=
 =?us-ascii?Q?xETbx+eHpjT/ZInG8RJvC02yxEOwnUWk7MhuOOzMndWDvlChZ6/pWxpPBt1b?=
 =?us-ascii?Q?n0hxs1BCQM3w6uzJPrkxtXaHrIhIPYVIB4kNopNGyL0qur22Gu3y0Pu7mGIF?=
 =?us-ascii?Q?WS7UBlcqy6pSAbSD2XPZ6jZMP4MtVkzAKk6uUYrO1WkOHKjCvoeqH/rI/Wff?=
 =?us-ascii?Q?VL+Jzzjouu1o4teCKv5pUQbxH2YRT8zm4bOn//HAq7NQRiXRPFJSRUJfLGK5?=
 =?us-ascii?Q?zTYEY/DB+PZvTOP3tBpxT/wMYpoGPoOcdu2AdciA3VrzQShXXNFVPqqxYLxq?=
 =?us-ascii?Q?hwmBZMULPc+N99FTXszNA/fRrc1iZlTLAmVZ1/jLQw1olAu7TxAUZ1vzY643?=
 =?us-ascii?Q?qZTrwAwaNbIb+Ot81vs+hk/4S1kyMtHEJo3ttWZvhVIKkdnRDPU4EbSKqxKX?=
 =?us-ascii?Q?fQVbOdVJfRFJExGUwIKkk/bXTtwlcqleonmu/A3TLrTiWMxbYw/u1gSN+4z6?=
 =?us-ascii?Q?9PEDRgY7zlfxswMTefYv1Mb+JajvsdZjeYJ84o4VD2hlIwcBBjRhR4B3D4PO?=
 =?us-ascii?Q?9trdAmN4xbdpqiJwRu+r06/KK7LOlHXXGGtRwYg6tiwKZQZHSEqb1WbcezTC?=
 =?us-ascii?Q?9thMzzIoPORaPr6Rc+vQHiOyBflJTNU0Mi0yh3cdhHMvoWFW25zU3XM1jrbM?=
 =?us-ascii?Q?A4L9aGtoNXVwgf2rTP/bjXUQwQ2FkdfT/OEFqvqTxjm1mlYWpx+v3//nB606?=
 =?us-ascii?Q?74nKLc7+VLr+EoZjMrvtvnNKKvEWhH0/fkBCAaWvRstDlz6nf79Hx3J0NBDt?=
 =?us-ascii?Q?wutPZg1wU5lKkf1rwmaDYMfQFArzXxj+lLRSSBp4sLJa3ISyMne83l7JeD8D?=
 =?us-ascii?Q?Xu+DjRqnMWDcjWRfwmRJbXjp/DD1SaKYaAQVW2vh8XxUGKwFOP+rXSITqiRu?=
 =?us-ascii?Q?mWBLwNMGHDvDTO3dlI0tGmhZvqzfgiRgR2seP866vD9u6JLmOOtCgWX0ctbe?=
 =?us-ascii?Q?jxf+Si4NX7y0/1XjxNEijKbQ2AysJrOG9hS/9DPHA6uivc+9YIuKitudGLnW?=
 =?us-ascii?Q?SvLUgm4Ht559pm+JANHJsDU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d04432-8cd9-4322-dc93-08daa83b1c65
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 08:08:26.0414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R9vGpGeayo70+po2tHh8z2hshkw3qusYatwZIuiWHv0+F35yirzTFnUXwIUWWrIWZDyn4XMWAklTJdXEOJc/MMe7tVS3lsyJBVpzBDmaIKU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4877
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 06, 2022 at 03:56:57PM -0700, Joe Damato wrote:
> On Thu, Oct 06, 2022 at 03:35:36PM -0700, Jesse Brandeburg wrote:
> > On 10/6/2022 10:32 AM, Joe Damato wrote:
> > >Sorry, but I don't see the value in the second param. NAPI decides what to
> > >do based on nb_pkts. That's the only parameter that matters for the purpose
> > >of NAPI going into poll mode or not, right?
> > >
> > >If so: I don't see any reason why a second parameter is necessary.
> > 
> > Sridhar and I talked about this offline. We agree now that you can just
> > proceed with the single parameter.
> 
> OK, thanks.
> 
> > >
> > >As I mentioned earlier: if it's just that the name of the parameter isn't
> > >right (e.g., you want it to be 'tx_processed' instead of 'tx_cleaned') then
> > >that's an easy fix; I'll just change the name.
> > 
> > I think the name change isn't necessary, since we're not going to extend
> > this patch with full XDP events printed (see below)

So better to keep the twisted naming?

> > 
> > >
> > >It doesn't seem helpful to have xsk_frames as an out parameter for
> > >i40e_napi_poll tracepoint; that value is not used to determine anything
> > >about i40e's NAPI.
> > >
> > >>I am not completely clear on the reasoning behind setting clean_complete
> > >>based on number of packets transmitted in case of XDP.
> > >>>
> > >>>>That might reduce the complexity a bit, and will probably still be pretty
> > >>>>useful for people tuning their non-XDP workloads.
> > >>
> > >>This option is fine too.
> > >
> > >I'll give Jesse a chance to weigh in before I proceed with spinning a v3.
> > 
> > I'm ok with the patch you have now, that shows nb_pkts because it's the
> > input to the polling decision. We can add the detail about XDP transmits
> > cleaned in a later series or patch that is by someone who wants the XDP
> > details in the napi poll context.

Please spell out whole AF_XDP instead of referring to XDP. Future readers
might get confused. XDP is totally fine with what Joe is doing, I'm trying
to bring up whole AF_XDP term and I feel like I'm being ignored.

number of produced packets to HW tx ring != number of produced packets to
AF_XDP CQ ring.

> 
> Thanks for the detailed and thoughtful feedback, it is much appreciated.
> 
> I'll leave this patch the way it is then and tweak the RX patch to include
> an rx_clean_complete boolean as I mentioned in my response to that patch
> and send out a v3.
> 
> FWIW, I had assumed that you would suggest dropping the XDP stuff so I
> pre-emptively spun a branch locally that dropped it... it is a much smaller
> change of course, but I suspect that this tracepoint might useful for XDP
> users, so I think the decision to leave it with nb_pkts makes sense.
> 
> Thanks again for the review. I'll send a v3 shortly.
