Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D45159E528
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 16:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242109AbiHWOfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 10:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241956AbiHWOeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 10:34:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0042B5BFD;
        Tue, 23 Aug 2022 04:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661255437; x=1692791437;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=9JYJ+PSeoG2Lkq000kBr5VhoGA3Ig7whoeyTVi9EkyY=;
  b=FxgAVa+UBmH/ZDlkrhoH9QVe8svOrL5jsMvwBGRJVVamSER9eLuSFpsT
   Z29YkZXYLwoFEqnno5vPb7BZbl/F+FHpDcM5L77dn0+3MsKeXnD1KHJUN
   1OtufK70pQJr0eq/35kDxxWqopr4kLcZm4D6SrQR9dGVWC0Z6dBhk+4kO
   P++uDApQD4LlVop878oHk40u7qxnGoCqOgaY/XV4NgOJo6LeHgmnYjdzD
   VnS4d6qsaNKSfwKtkAsnOyYL/ibZUIeqAM9hLmaHdNglTulpi26sTyXd/
   BZP7vk70aiOzhr9BZaFOAV521PRKlPXRxB70ou6rZJdAFpsmk1EysWjOg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="274049959"
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="274049959"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 04:24:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="609311210"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 23 Aug 2022 04:24:35 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 04:24:35 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 04:24:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 23 Aug 2022 04:24:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 23 Aug 2022 04:24:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/P9BpWSlZcaZVdfIhyGlkvC/ttPsslZARahtezajb//w/fcg7GKWp6XP1R/AhUU2eLO5Q13bV25km3fte5wlH22ILVblKivhkP06T6otGk3npPjWxTuB7B1El1AnB1BipJCrwOnugiqmJBZmMce2R18wGB4hno8AhOvo93jzDGnDAnW+svPqdBNV8kCEpRMLGPRBaOeQ+uKy/27B3Vt3eYyM6S2cp7XGBYoq692eSzA9fNbPnY6iMlXWbBfaBcXYzLiqQf1gCuYtmiT6HoySzmBUGSLSfvs5TAPfAQNFhTRjqgFP1Kh/faE+kOt5fnudxpXQZfz0EfzuSi4CpfMkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GIMgftrfPajGJ9OeFPzPzOlcThdi6s7TmD4a+R0mOMY=;
 b=nUY9Zx5fiz2yG4UrSwFdFeOtW8cCWHIY6FIAcSmT47lcSc0wsyi/OYnmI4Wc8RazQS+9v7yk2MJ2yGujkWHULC0E09at/oveyyG3CEEjFv6gg86QzaJ1bw5KoV84U2pGKGorcn5PGLMSDKcxWSEdZq29xBZJamAtY9/ewSjqODJJ/gwq1gFIw5XItNxl2hpCGeOvWN8uLTXnkkaWMMWwgTq2l4nIsSdBcEoJk9+SoC7+ffWCrij0rF9MxkUdiUO/YbelaPXZgcmDVjHqFQdVE5U8JeEva7KIiM47QLBAuHZEIiPuPN4RIciIvyfS0Yg44TmLdUk2OmJkpVNWB4QKWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BN7PR11MB2770.namprd11.prod.outlook.com (2603:10b6:406:b4::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.18; Tue, 23 Aug 2022 11:24:31 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5876:103b:22ca:39b7]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5876:103b:22ca:39b7%4]) with mapi id 15.20.5525.011; Tue, 23 Aug 2022
 11:24:31 +0000
Date:   Tue, 23 Aug 2022 13:24:06 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
CC:     "bjorn@kernel.org" <bjorn@kernel.org>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 00/14] xsk: stop NAPI Rx processing on full
 XSK RQ
Message-ID: <YwS41lA+mz0uUZVP@boxer>
References: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
 <f1eea2e9ca337e0c4e072bdd94a89859a4539c09.camel@nvidia.com>
 <93b8740b39267bc550a8f6e0077fb4772535c65e.camel@nvidia.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93b8740b39267bc550a8f6e0077fb4772535c65e.camel@nvidia.com>
X-ClientProxiedBy: YQXPR0101CA0029.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:15::42) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4081a1e-8239-4896-5c74-08da84fa0c95
X-MS-TrafficTypeDiagnostic: BN7PR11MB2770:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zOiduu3Stbo4uqu4i0ugfYRLd1UVtASMWtBwPJOhtHcsSWRapMf3SSqcuXQx2zUs8d3KGM/n/e6rUoHTR3T0sGfPCWVjcr9NAFzJCkwU1mv0RzEd6MU1wsq/AkJ0XlHbM8Bi7ds0zSK3Zw09G8o9Jq4L+GpD6DiiQtoN/iPmV5X5+gx5EclVs5k4nsU++kbJZuTbTa9ralAjGgtljH6Vb5mfsVkk094hHHWYKFucRZLP8jgxf0V2mwbSIWr5WVBHsfwLXmloottB4NYXMykOSN7h0UcOPkOgVEm/xPpauUhFlGeIGwtEbnP/ZgNmCYaWOIzqdTj0yKeqPNBKKbUHpuEDGKPzdF8C2y8nMxCdLItU3IeJLG8lhL+UHT6/5ijec1sReb/t/2ZOWxCTsd5ubLK5p7nMTTB6+hu7rmFdOpIovPn/S4EQSVz/lLoZJ2c2Dyawv34Ia4qi2ic/WzdE4uFOH63A40KAfiOrY2wzUSaJNUjfdAF1KvTegUYwsM9mZik+EkmfJ5f5WL8UFZ0WNNyBkeB8porCyIjdUyLPZ9zNUKLoTVcT60+CbR/qwHS0JJss0h8uU2C8/+n3MLVxm9jmsw4Bjl7/Hzka1MF6emx5/jOBfbYf7X3TsV5a0YsqL578TLJz8bG19eoF/Cg73lJswWViPiTz+gVHhrrsPOfwElAmOlI4xOt5N/rPJJgiObqfp37gyW0Lsj2CWdBrQN9vE8x4Ge9KZvMK82RyBrFpoKKqAL2QhZdtQJ9YJUYc3XwB1gb+H+2zP4boSSqvcJ32s+lOi0gF+r9c1PU5Ri76boDKQoH4YYOCfG5d7kIwxBPGNHe4uUybotfPf3JP+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(376002)(346002)(366004)(396003)(136003)(478600001)(966005)(82960400001)(6486002)(6916009)(54906003)(316002)(186003)(83380400001)(66574015)(38100700002)(6666004)(6506007)(41300700001)(26005)(6512007)(9686003)(44832011)(2906002)(86362001)(8936002)(8676002)(66476007)(66556008)(33716001)(66946007)(5660300002)(4326008)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Z8MXQpTKZAsVxQ0RK5CSeitiUerVHRtrAHKkz480Mg8ewjjKzE00mfdSte?=
 =?iso-8859-1?Q?nZJ3hNuqF2zUpV6rExO7qhp2McCiPPP/KNDO+77fMGt4l5CTXSeREFpub6?=
 =?iso-8859-1?Q?Qacf+o4LDxhzfz7jQ1KtSKTgLs4AYHiXvp9dm/S8LkinrpdwNYhYEmE4es?=
 =?iso-8859-1?Q?0cgpGaplAVnt0yU4aJ8YWU6lBNjOg+1k4LwvWZmbq/DbE/sWL7FXO4PQDM?=
 =?iso-8859-1?Q?toI3bux2L7a4pryc59+p2ZltaakZZduq9Kyhzy2Jod/pKHe1GKWdAM/uHe?=
 =?iso-8859-1?Q?PT711fiE/xIKB/ckgg1X6oUEOsCFy2ewtg8gKF/RaMBU4XavVuaeowwR96?=
 =?iso-8859-1?Q?i6d2IjOrIhLUgGWW7adhFgSsCPLjYMEvAg8wr65PxEW84UasXCNzpcWpVh?=
 =?iso-8859-1?Q?nh/8DpgABMEROB8bymAmS/w//ou22yDYfthkTV+XAphid8qKJdc16Cb7Q/?=
 =?iso-8859-1?Q?wxi0ofH37Iq4bC9oWilbtgJzg8Hu3rdu6CEKCWAJ7+RCoS6cVvJ57oggfF?=
 =?iso-8859-1?Q?IccePLD+Y7h0xQlmchK2+91JTf43oO+SYirB/muWUzQ2hBM2dS7QbztSy4?=
 =?iso-8859-1?Q?yvDPF2oALJz2APO9rDRUKeF5jDGovMMLTjj/q7UDpCip//D5HwbRn0viW1?=
 =?iso-8859-1?Q?UctQ88hvw3FzCNH4eQ4f+UNMn4CgnKhHGkHNxYBtbI7VzUFOlkxOaOc8vy?=
 =?iso-8859-1?Q?79PA/xBt5YQAZ79SnBuWNaU/kHyJIlQo36uwjFN7BggDOBYZgPTkf3qRrj?=
 =?iso-8859-1?Q?nzEVU63tIz4KwXvaygK7/wdMcCkLoccHmpWdPEVlBe9uqltojyh6ZxXF+D?=
 =?iso-8859-1?Q?DekLYc8t00DvdhiHC7kGqc6IcPOLyyNpCiszrg+EMFJWvLO7JdUKe5HstE?=
 =?iso-8859-1?Q?a1Athz7TvGnplokoHIHd7uKfrvRRTsWmhjQOJbtsvko09IOqKRi34IDhC0?=
 =?iso-8859-1?Q?w/oyOZpatAi03b9jrQ+Z92+A1x6Wol5xjrkEczLYSTT+Z9P08q0cBO3E4C?=
 =?iso-8859-1?Q?bXv0WP7RhBhjowpyHhMgwlTzAY8ysLQphYo5asPwUhPHGH2Efrsmg3oYsD?=
 =?iso-8859-1?Q?ZqBrjWMN2LfFxcmozf7aHCLVOtZRt87zji5Pg4hAM9pv8dVprssWfEdfRP?=
 =?iso-8859-1?Q?+B45RLMdwfqbdyO37+0PQ4w3h3zezTf851bKRx9kMKUDHWmiMuAEr3hgvE?=
 =?iso-8859-1?Q?Bc8CdfXF4vBmIgYxLUCqq9Lmx8c7bwsR6H1++Di0HUwCOIeuPMtgEvdrD/?=
 =?iso-8859-1?Q?xMIC/m6SyhDPMxsVJpvApCCOyRISBL0vvK3WSjo0k0FpnGmsmdN4SnbC9u?=
 =?iso-8859-1?Q?rCqagqASVRA9eVqyolk6nIiR+aaed9JfwNk6l3gLFSkp20CVlFY9Yt8drM?=
 =?iso-8859-1?Q?ZXuRQ+5BNz8SqBTatK91khhH57Q4cjZ8de4AcV2Me6XhFus+BGDnT/91+z?=
 =?iso-8859-1?Q?oJepCH8Zg2tHqRR8Vf9WH0pMgfxP3NdMxYzF0BOPeE+7XBwXYlkfY5kQB8?=
 =?iso-8859-1?Q?oJOTKQmG2ia4Qgk8x1QnNiXnfmqPyT2PIaG3omLsZiWHSl+myqV9442HyW?=
 =?iso-8859-1?Q?D7lURS06pbEE3bCP/YoZ4/ln4fe6E35w/xlG2tdJy3TTVxssWtLLZhQ39W?=
 =?iso-8859-1?Q?L30l1Jby5wOVOcq9KQDiwBTh4ucOgSCbWkVlMCzYUkOyvusAH/Xu4ndg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4081a1e-8239-4896-5c74-08da84fa0c95
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 11:24:31.5558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nosRs+A2ss+4N79Q6QQpCmegbCcUMItrtE/LFzxmORM07qqaPDpjjl1bqSTiRaLJx21CNs/UxSpfjcJt8d16eqUzoYIufJUQJ9cluNFsCSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2770
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 09:49:43AM +0000, Maxim Mikityanskiy wrote:
> Anyone from Intel? Maciej, Björn, Magnus?

Hey Maxim,

how about keeping it simple and going with option 1? This behavior was
even proposed in the v1 submission of the patch set we're talking about.

> 
> Does anyone else have anything to say? IMO, calling XDP for the same
> packet multiple times is a bug, we should agree on some sane solution.
> 
> On Thu, 2022-08-18 at 14:26 +0300, Maxim Mikityanskiy wrote:
> > Hi Maciej,
> > 
> > On Wed, 2022-04-13 at 17:30 +0200, Maciej Fijalkowski wrote:
> > > v2:
> > > - add likely for internal redirect return codes in ice and ixgbe
> > >   (Jesper)
> > > - do not drop the buffer that head pointed to at full XSK RQ
> > > (Maxim)
> > 
> > I found an issue with this approach. If you don't drop that packet,
> > you'll need to run the XDP program for the same packet again. If the
> > XDP program is anything more complex than "redirect-everything-to-
> > XSK",
> > it will get confused, for example, if it tracks any state or counts
> > anything.
> > 
> > We can't check whether there is enough space in the XSK RX ring
> > before
> > running the XDP program, as we don't know in advance which XSK socket
> > will be selected.
> > 
> > We can't store bpf_redirect_info across NAPI calls to avoid running
> > the
> > XDP program second time, as bpf_redirect_info is protected by RCU and
> > the assumption that the whole XDP_REDIRECT operation happens within
> > one
> > NAPI cycle.
> > 
> > I see the following options:
> > 
> > 1. Drop the packet when an overflow happens. The problem is that it
> > will happen systematically, but it's still better than the old
> > behavior
> > (drop mulitple packets when an overflow happens and hog the CPU).
> > 
> > 2. Make this feature opt-in. If the application opts in, it
> > guarantees
> > to take measures to handle duplicate packets in XDP properly.
> > 
> > 3. Require the XDP program to indicate it supports being called
> > multiple times for the same packet and pass a flag to it if it's a
> > repeated run. Drop the packet in the driver if the XDP program
> > doesn't
> > indicate this support. The indication can be done similar to how it's
> > implemented for XDP multi buffer.
> > 
> > Thoughts? Other options?
> > 
> > Thanks,
> > Max
> > 
> > > - terminate Rx loop only when need_wakeup feature is enabled
> > > (Maxim)
> > > - reword from 'stop softirq processing' to 'stop NAPI Rx
> > > processing'
> > > - s/ENXIO/EINVAL in mlx5 and stmmac's ndo_xsk_wakeup to keep it
> > >   consitent with Intel's drivers (Maxim)
> > > - include Jesper's Acks
> > > 
> > > Hi!
> > > 
> > > This is a revival of Bjorn's idea [0] to break NAPI loop when XSK
> > > Rx
> > > queue gets full which in turn makes it impossible to keep on
> > > successfully producing descriptors to XSK Rx ring. By breaking out
> > > of
> > > the driver side immediately we will give the user space opportunity
> > > for
> > > consuming descriptors from XSK Rx ring and therefore provide room
> > > in the
> > > ring so that HW Rx -> XSK Rx redirection can be done.
> > > 
> > > Maxim asked and Jesper agreed on simplifying Bjorn's original API
> > > used
> > > for detecting the event of interest, so let's just simply check for
> > > -ENOBUFS within Intel's ZC drivers after an attempt to redirect a
> > > buffer
> > > to XSK Rx. No real need for redirect API extension.
> > > 
> > > One might ask why it is still relevant even after having proper
> > > busy
> > > poll support in place - here is the justification.
> > > 
> > > For xdpsock that was:
> > > - run for l2fwd scenario,
> > > - app/driver processing took place on the same core in busy poll
> > >   with 2048 budget,
> > > - HW ring sizes Tx 256, Rx 2048,
> > > 
> > > this work improved throughput by 78% and reduced Rx queue full
> > > statistic
> > > bump by 99%.
> > > 
> > > For testing ice, make sure that you have [1] present on your side.
> > > 
> > > This set, besides the work described above, carries also
> > > improvements
> > > around return codes in various XSK paths and lastly a minor
> > > optimization
> > > for xskq_cons_has_entries(), a helper that might be used when XSK
> > > Rx
> > > batching would make it to the kernel.
> > > 
> > > Link to v1 and discussion around it is at [2].
> > > 
> > > Thanks!
> > > MF
> > > 
> > > [0]:
> > > https://lore.kernel.org/bpf/20200904135332.60259-1-bjorn.topel@gmail.com/
> > > [1]:
> > > https://lore.kernel.org/netdev/20220317175727.340251-1-maciej.fijalkowski@intel.com/
> > > [2]:
> > > https://lore.kernel.org/bpf/5864171b-1e08-1b51-026e-5f09b8945076@nvidia.com/T/
> > > 
> > > Björn Töpel (1):
> > >   xsk: improve xdp_do_redirect() error codes
> > > 
> > > Maciej Fijalkowski (13):
> > >   xsk: diversify return codes in xsk_rcv_check()
> > >   ice: xsk: decorate ICE_XDP_REDIR with likely()
> > >   ixgbe: xsk: decorate IXGBE_XDP_REDIR with likely()
> > >   ice: xsk: terminate Rx side of NAPI when XSK Rx queue gets full
> > >   i40e: xsk: terminate Rx side of NAPI when XSK Rx queue gets full
> > >   ixgbe: xsk: terminate Rx side of NAPI when XSK Rx queue gets full
> > >   ice: xsk: diversify return values from xsk_wakeup call paths
> > >   i40e: xsk: diversify return values from xsk_wakeup call paths
> > >   ixgbe: xsk: diversify return values from xsk_wakeup call paths
> > >   mlx5: xsk: diversify return values from xsk_wakeup call paths
> > >   stmmac: xsk: diversify return values from xsk_wakeup call paths
> > >   ice: xsk: avoid refilling single Rx descriptors
> > >   xsk: drop ternary operator from xskq_cons_has_entries
> > > 
> > >  .../ethernet/intel/i40e/i40e_txrx_common.h    |  1 +
> > >  drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 38 ++++++++-----
> > >  drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
> > >  drivers/net/ethernet/intel/ice/ice_xsk.c      | 53 ++++++++++++---
> > > ----
> > >  .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  1 +
> > >  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 52 ++++++++++-----
> > > ---
> > >  .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  2 +-
> > >  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +-
> > >  net/xdp/xsk.c                                 |  4 +-
> > >  net/xdp/xsk_queue.h                           |  4 +-
> > >  10 files changed, 99 insertions(+), 61 deletions(-)
> > > 
> > 
> 
