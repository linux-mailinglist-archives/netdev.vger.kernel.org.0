Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37FE5814D4
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiGZOK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238631AbiGZOK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:10:56 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAD66451;
        Tue, 26 Jul 2022 07:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658844655; x=1690380655;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BUwo/1IK9y9aoyw8dgbMLvKbRBzbqgkLkR3aKgzz0v8=;
  b=Wfry8VDs5KA/btpnqCO5S4Vr2PZI7KPYo1AjpFElZCNKXS02FFGyQrGH
   IAhJjQEg17m448qAC+bXRnb9r9oMg4aB7ctyZJVA8pk8v3h/T9WhwKkBF
   8itAFjjHwx6DC3Ka6WQ6vJVNHbupR7va9rG+FFhhTx6zMSszMbn5Vl9kM
   +lsjPuDRmeSTMBgd8uEsUVc2wgd4bnkjlip0/oUpCpwJhRQlWki75Tf3E
   qo6X7YfBXvT1ir9PZkcXQfLGfZFMcU9ygDsMCQNWCblNBoXg/W4e2Zwje
   +o/KqdGtJtws1N0siLHlSibQbG0jMUlPiRbZMJjSoMY+ZELHf+H2VRe6/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="313729265"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="313729265"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 07:10:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="575505918"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 26 Jul 2022 07:10:33 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 07:10:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 07:10:33 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 26 Jul 2022 07:10:33 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 26 Jul 2022 07:10:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKKLnk5t84tGL1yFQE+qE5Qdnb6kzxN0mmaAvljjgnZzdAonni/qY6T7uY4+dBJL+CzdpzTBggSS1ezlk+EjyYv392n9S1BtHic9qRrO6ippw9MWKc9wBIzov8LPcI+zPY/T0bjhNc6jiPrJa5Bt6wK2DFX2rtWQ8ivXzzw1SGAbh2FxtrCfbl5EYDRAhsLZvlN1DzCsdGv0OrYDJM0TPaZgcKPb+hvg5i6gaKzS7cLKa0jDg34dguWH6Z8XxU0N0OzwQ/5OzbaUkI4iLKXqIbjft4Fr+MNmDO2+cJGx5YG9OYmFjuZOj+SWcpPn0GP9XWS69o+nc5HY7AreyszRbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pVXEajZ4bZs8cjHCjF9ZEeGOrOY8hxeYXNLzjp0jImY=;
 b=DhKCboJE6B15Yi8RW4xPbXVxKifk3uRY50pFGwWOYF3V+Jo5Hn78OVNxVeyJTPNgjwOy+p4mOVAAJvlbyXD40JjrpBwtnvi+fOZ4ow3OAQmzxs/Xotsz4MsEyDnJujS6ElPoWGAyvVg4gUbRB2N5gOZoJqDCKL7f2WiPJ5GZXIUo67Xi7jDQJsx5aDclwm36U8fNFxC8FvrAololv1xWTcR7/sbM/3QlcPmlroCiM372bw3nvylitgilJ72iBOUZ6OIK5hPlCJU5l9E1xlHuLUsMclPUQXIUWQIPZLGodsUBz+FdELRjhYJ9LXePgr2EQv3e5n7Mz+zjquyUhKf8Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BN6PR11MB3988.namprd11.prod.outlook.com (2603:10b6:405:7c::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Tue, 26 Jul 2022 14:10:29 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9cba:7299:ab7d:b669]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9cba:7299:ab7d:b669%8]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 14:10:29 +0000
Date:   Tue, 26 Jul 2022 16:10:16 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Koikkara Reeny, Shibin" <shibin.koikkara.reeny@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "Loftus, Ciara" <ciara.loftus@intel.com>
Subject: Re: [PATCH bpf-next] selftests: xsk: Update poll test cases
Message-ID: <Yt/1yLNzEvPFR0Y2@boxer>
References: <20220718095712.588513-1-shibin.koikkara.reeny@intel.com>
 <YtqxJ4f1osDc1Rtg@boxer>
 <DM6PR11MB3995991A0874B1FEFB384376A2949@DM6PR11MB3995.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <DM6PR11MB3995991A0874B1FEFB384376A2949@DM6PR11MB3995.namprd11.prod.outlook.com>
X-ClientProxiedBy: AS4PR10CA0005.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea705a81-6237-4673-48a6-08da6f109832
X-MS-TrafficTypeDiagnostic: BN6PR11MB3988:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c/5B8vS1IXcdxLEBiInVN/cN9AODvsHogEvTnLHhl9GbaqKV3+C/HHQ5YckRrADWtWU/YUpWT16hJmMQnxirfRSnVXm7uWtBYstV+BHLsnGjCeAggIY5Dgiodi0J/Lhgia+EA0TQZRr8jHX2Gi4UPsAw2AWyFC6oWJNt2btCkK+9t1acxIZDWs3o3uM8VyVvAC8pOh4kfLmc4rMY219A1/HYsWsEV86qGuamd6m8N0TyQ6mIbDC8x3/l29Z8efcD9oG3Ids1F326aYfm1v7lVrnyKsA3ozZBIED4g9ZohCpS5wnS7p3kXnz8RxFF9HPAISuSuwTriUVzaq+aY0ZlarfVHNu0B7DxL3zyrk6Wwxgx2ZMFtbIvw9po8krptwRuEx/xU71Xku1buJYbe0ZlCG+AUiSVs/VlKNpwq2bW2fENEiKVgnrQmbB0FFDWEVGraD3Hjr9xrk0He1gHZRdEz72azgtsGM/oharpGnovBRmA21Be3X91gWAVTBA/jIoSLdKRN9dGp8wYr83PXlRMmJUuRIl+DTVg0M/2ZrG2ZfiO8rUsfJVzpChRabcAz5lSVCno4hKk5/JaWuf5fGvNBMwayx+BU1Vlj7v7c66GnM2ZNsU99scJWLWvrzTwebk0EYcXP/5VKh+MzUhjXm6bpzOeMov0EmuFt1o0yMW0jmtB1QN4NehUOQWrxiZ323DqkZbABK/5ZFk08cKDcTHCzjCJ+ULMS+oQe/KEXfu5W/Q47ijv13zfjb2fR2gSBE1HG0VI7noTpbFq4SdO1TepUHt6jSOjYyIK3xTAhf5xBWw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(366004)(396003)(376002)(346002)(136003)(186003)(107886003)(4326008)(66476007)(8676002)(66946007)(66556008)(6636002)(83380400001)(54906003)(9686003)(53546011)(6666004)(15650500001)(41300700001)(6512007)(6506007)(26005)(2906002)(86362001)(33716001)(38100700002)(478600001)(5660300002)(44832011)(30864003)(316002)(6486002)(82960400001)(8936002)(6862004)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H18k8NkV6l/G40CKLi/BF6jvpiAh03ks/BQiD5tN86o7mExzAbhnGmbA2lvs?=
 =?us-ascii?Q?0KrJaqCqP7e5wpml+LZTBfd3Wq8ktCYWEn0nPWZHapj0ysetJZCWC1UWJZ5u?=
 =?us-ascii?Q?E2rxqB7QCrVo/846OqK8GAWvIljathva3pu6hEadRtQSsG6hM/6XhaKG9CEO?=
 =?us-ascii?Q?E/4TLMTT6xSbugsrmYQxahp1N/tjQpXskFiZ3n3uLx3sLgQn+laR3JAGZOZU?=
 =?us-ascii?Q?zEmPwN2ZV/EwSDYQWWRy8yzxBiS8ynPmaMbCE7HeutJnuEePBaQLOzUeuJD7?=
 =?us-ascii?Q?wQ6Ajl92Dz/xfQTniUmmzYXNzmuqOhmZIFdaM9BhhY89TUPWgOMHZYUIUkWd?=
 =?us-ascii?Q?7Sg6e1IGMoEjWsUoYZTprTlspTLqlZxnKq8mxhv88yyOf1a7zGFK06I8a4kU?=
 =?us-ascii?Q?d+E92LsTGoUlOEQza09kxA7CCBEZIT9/yy6LHZ3JWC6E7QZSmAO3Le7QZJLU?=
 =?us-ascii?Q?YlxXQGw544m6+986ptjRffQ38DvMfeESlM5zv+vGFnlCzDm+FceUMGQZLH7C?=
 =?us-ascii?Q?Okqq0KB7J6RLicb0TsZFz16vk+3e+TAo5wWWvrZbRL0Np1NBO6aW1Ng8A9X3?=
 =?us-ascii?Q?QPWsh3WF/fkCMhoZoyGGtVrDPLhtiLQQyvJzTz9ghEi3cQdbcIETj7bluFzb?=
 =?us-ascii?Q?v19PNB13i5TWU6V8+sptZzFeVXjxGGyb6WnJr9PZ/V7BLK5JneXX3cKk9G9x?=
 =?us-ascii?Q?GyJIFyJg1J49oykjCGroB9tGzmxfGOvRJaBBB+AaICFNjqNXH3yJGO9q/tAZ?=
 =?us-ascii?Q?czGW9PWOrazrIaXyf5yRkyT5Xrnej/e6tBRIQSP0pkAEkddEOdXQq2fO7b/K?=
 =?us-ascii?Q?TPV/f8ew5VAPJt2Y8+rtSDbtninAHXqI6E1KnIyR9bAuiQMMCSFRdTVGQ7De?=
 =?us-ascii?Q?5adEkHgiew0AgH5t+qDxrL+0qMi2i9XNSVbjJ56ULMLUWTXj24Bch+gAKB0W?=
 =?us-ascii?Q?20frRyeddcEG/3tKLwxA8fZuIwmM+/ZpS4eHtcCWOZ/AYkq0qFQ8REImRiu4?=
 =?us-ascii?Q?PacIzSmhQC10Z8GAE1GL7nQirBO1HpatKDOXzl5PCCQq6pd3zaKtI8MlWENy?=
 =?us-ascii?Q?5ZWC4WrZ0LMC5CZz/7+M3ONizyCTSVT1YzXASCZm/AL+0mZFwuJdWHtG3DQT?=
 =?us-ascii?Q?/7eVNkMVhVIcDxZ01v0w3B5dyATgMZv702Izqwq1JCrjbg5jVbeBuGBCfhfb?=
 =?us-ascii?Q?V75V5129WKoFJj4d3poSLO72SdKtrKSgDfQdTihkNIkvGq9Nb8zvUcb2hkKL?=
 =?us-ascii?Q?MeHeIui14XZAY7laxs5OX5HIeBddIPIxPkl3Ydy085pX2VVNYYiVwKQ4S6tO?=
 =?us-ascii?Q?rs/eScUdthNNSk/88Ao3o9arxXZ6gC/alcGwWe0dmGoJLIba83zmSMhInk2c?=
 =?us-ascii?Q?pabVd/uExQzQCYIPpE95jnfixymN0gc1jT29ScX379A2EZz8tV4Z9lEnmo+u?=
 =?us-ascii?Q?9kt8xc6hIu0HgGFO4puuNQFmusxgwVqNP8ERV4L2KknjDQoR4iH/X6RSBPSl?=
 =?us-ascii?Q?i8mpGv3apyUFpOyhNYVKO4M98tFHqZg5v7THXK5tcf9RhmefVBkZa5vc5CSZ?=
 =?us-ascii?Q?DorSHb4NHWD7CsMxWTNl9S0uWzqkKC+4gcyyf4r29c8IpeJ4EIS72r7XzhDA?=
 =?us-ascii?Q?A/HnITB8H0DaOF2bboXt3NI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ea705a81-6237-4673-48a6-08da6f109832
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 14:10:29.2750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +1owqzHAd5xJV8dVxRCQ+CALnqbGvrMsQuhPjSnPOfryEm8BWJz5lW2QDn4xdePrm7elU7/tphbqNRkRM2McDvHzXLMzcoAcG17QfgHuAq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3988
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 10:43:36AM +0100, Koikkara Reeny, Shibin wrote:
> > -----Original Message-----
> > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Sent: Friday, July 22, 2022 3:16 PM
> > To: Koikkara Reeny, Shibin <shibin.koikkara.reeny@intel.com>
> > Cc: bpf@vger.kernel.org; ast@kernel.org; daniel@iogearbox.net;
> > netdev@vger.kernel.org; Karlsson, Magnus <magnus.karlsson@intel.com>;
> > bjorn@kernel.org; kuba@kernel.org; andrii@kernel.org; Loftus, Ciara
> > <ciara.loftus@intel.com>
> > Subject: Re: [PATCH bpf-next] selftests: xsk: Update poll test cases
> > 
> > On Mon, Jul 18, 2022 at 09:57:12AM +0000, Shibin Koikkara Reeny wrote:
> > > Poll test case was not testing all the functionality of the poll
> > > feature in the testsuite. This patch update the poll test case with 2
> > > more testcases to check the timeout features.
> > >
> > > Poll test case have 4 sub test cases:
> > 
> > Hi Shibin,
> > 
> > Kinda not clear with count of added test cases, at first you say you add 2
> > more but then you mention something about 4 sub test cases.
> > 
> > To me these are separate test cases.
> >
> Hi Maciej,
> 
> Will update it in V2 
> 
> > >
> > > 1. TEST_TYPE_RX_POLL:
> > > Check if POLLIN function work as expect.
> > >
> > > 2. TEST_TYPE_TX_POLL:
> > > Check if POLLOUT function work as expect.
> > 
> > From run_pkt_test, I don't see any difference between 1 and 2. Why split
> > then?
> > 
> 
> 
> It was done to show which case exactly broke. If RX poll event or TX poll event
> 
> > >
> > > 3. TEST_TYPE_POLL_RXQ_EMPTY:
> > 
> > 3 and 4 don't match with the code here (TEST_TYPE_POLL_{R,T}XQ_TMOUT)
> > 
> > > call poll function with parameter POLLIN on empty rx queue will cause
> > > timeout.If return timeout then test case is pass.
> > >
> 
> 
> True but  It was change to RXQ_EMPTY and TXQ_FULL from _TMOUT to
> make it more clearer to what exactly is happening to cause timeout.
> 
> > > 4. TEST_TYPE_POLL_TXQ_FULL:
> > > When txq is filled and packets are not cleaned by the kernel then if
> > > we invoke the poll function with POLLOUT then it should trigger
> > > timeout.If return timeout then test case is pass.
> > >
> > > Signed-off-by: Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
> > > ---
> > >  tools/testing/selftests/bpf/xskxceiver.c | 173
> > > +++++++++++++++++------  tools/testing/selftests/bpf/xskxceiver.h |
> > > 10 +-
> > >  2 files changed, 139 insertions(+), 44 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/xskxceiver.c
> > > b/tools/testing/selftests/bpf/xskxceiver.c
> > > index 74d56d971baf..8ecab3a47c9e 100644
> > > --- a/tools/testing/selftests/bpf/xskxceiver.c
> > > +++ b/tools/testing/selftests/bpf/xskxceiver.c
> > > @@ -424,6 +424,8 @@ static void __test_spec_init(struct test_spec
> > > *test, struct ifobject *ifobj_tx,
> > >
> > >  		ifobj->xsk = &ifobj->xsk_arr[0];
> > >  		ifobj->use_poll = false;
> > > +		ifobj->skip_rx = false;
> > > +		ifobj->skip_tx = false;
> > 
> > Any chances of trying to avoid these booleans? Not that it's a hard nack, but
> > the less booleans we spread around in this code the better.
> 
> 
> Not sure if it is possible but using any other logic will make
> the code more complex and less readable.

How did you come with such judgement? You didn't even try the idea that I
gave to you about having a testapp_validate_traffic() equivalent with a
single thread.

> 
> > 
> > >  		ifobj->use_fill_ring = true;
> > >  		ifobj->release_rx = true;
> > >  		ifobj->pkt_stream = test->pkt_stream_default; @@ -589,6
> > +591,19 @@
> > > static struct pkt_stream *pkt_stream_clone(struct xsk_umem_info
> > *umem,
> > >  	return pkt_stream_generate(umem, pkt_stream->nb_pkts,
> > > pkt_stream->pkts[0].len);  }
> > >
> > > +static void pkt_stream_invalid(struct test_spec *test, u32 nb_pkts,
> > > +u32 pkt_len) {
> > > +	struct pkt_stream *pkt_stream;
> > > +	u32 i;
> > > +
> > > +	pkt_stream = pkt_stream_generate(test->ifobj_tx->umem,
> > nb_pkts, pkt_len);
> > > +	for (i = 0; i < nb_pkts; i++)
> > > +		pkt_stream->pkts[i].valid = false;
> > > +
> > > +	test->ifobj_tx->pkt_stream = pkt_stream;
> > > +	test->ifobj_rx->pkt_stream = pkt_stream; }
> > 
> > Please explain how this work, e.g. why you need to have to have invalid pkt
> > stream + avoiding launching rx thread and why one of them is not enough.
> > 
> > Personally I think this is not needed. When calling pkt_stream_generate(),
> > validity of pkt is set based on length of packet vs frame size:
> > 
> > 		if (pkt_len > umem->frame_size)
> > 			pkt_stream->pkts[i].valid = false;
> > 
> > so couldn't you use 2k frame size and bigger length of a packet?
> > 
> This function was introduced for TEST_TYPE_POLL_TXQ_FULL keep
> the TX full and stop nofying the kernel that there is packet to cleanup.
> So we are manually setting the packets to invalid. This help to keep
> the __send_pkts() more generic and reduce the if conditions.
> ex: xsk_ring_prod__submit() is not needed to be added inside if condition.

I understand the intend behind it but what I was saying was that you have
everything ready to be used without a need for introducing new functions.
You could also try out what I suggested just to see if this makes things
simpler.

> 
> You are right we don't need rx stream but thought it will be good
> to keep as can be used for other features in future and will be more generic.

If there are other features that would utilize this then let's introduce
this then ;)

> 
> > > +
> > >  static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts,
> > > u32 pkt_len)  {
> > >  	struct pkt_stream *pkt_stream;
> > > @@ -817,9 +832,9 @@ static int complete_pkts(struct xsk_socket_info
> > *xsk, int batch_size)
> > >  	return TEST_PASS;
> > >  }
> > >
> > > -static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
> > > +static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds,
> > > +bool skip_tx)
> > >  {
> > > -	struct timeval tv_end, tv_now, tv_timeout = {RECV_TMOUT, 0};
> > > +	struct timeval tv_end, tv_now, tv_timeout = {THREAD_TMOUT, 0};
> > >  	u32 idx_rx = 0, idx_fq = 0, rcvd, i, pkts_sent = 0;
> > >  	struct pkt_stream *pkt_stream = ifobj->pkt_stream;
> > >  	struct xsk_socket_info *xsk = ifobj->xsk; @@ -843,17 +858,28 @@
> > > static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
> > >  		}
> > >
> > >  		kick_rx(xsk);
> > > +		if (ifobj->use_poll) {
> > > +			ret = poll(fds, 1, POLL_TMOUT);
> > > +			if (ret < 0)
> > > +				exit_with_error(-ret);
> > > +
> > > +			if (!ret) {
> > > +				if (skip_tx)
> > > +					return TEST_PASS;
> > > +
> > > +				ksft_print_msg("ERROR: [%s] Poll timed
> > out\n", __func__);
> > > +				return TEST_FAILURE;
> > >
> > > -		rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE,
> > &idx_rx);
> > > -		if (!rcvd) {
> > > -			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
> > 
> > So now we don't check if fq needs to be woken up in non-poll case?
> > I believe this is still needed so we get to the driver and pick fq entries. Prove
> > me wrong of course if I'm missing something.
> 
> xsk_ring_prod__needs_wakeup() ==>  *r->flags & XDP_RING_NEED_WAKEUP;
> This function only check if the flag is set or not and it is not updating or
> triggering anything. In the original case if flag is set then trigger the 
> poll event and continue.
> In this patch poll event is called in any case if it enter the if (!rcvd)  is true..
> We don't check if XDP_RING_NEED_WAKEUP is set or not.
> 	
> 
> > 
> > > -				ret = poll(fds, 1, POLL_TMOUT);
> > > -				if (ret < 0)
> > > -					exit_with_error(-ret);
> > >  			}
> > > -			continue;
> > > +
> > > +			if (!(fds->revents & POLLIN))
> > > +				continue;
> > >  		}
> > >
> > > +		rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE,
> > &idx_rx);
> > > +		if (!rcvd)
> > > +			continue;
> > > +
> > >  		if (ifobj->use_fill_ring) {
> > >  			ret = xsk_ring_prod__reserve(&umem->fq, rcvd,
> > &idx_fq);
> > >  			while (ret != rcvd) {
> > > @@ -863,6 +889,7 @@ static int receive_pkts(struct ifobject *ifobj, struct
> > pollfd *fds)
> > >  					ret = poll(fds, 1, POLL_TMOUT);
> > >  					if (ret < 0)
> > >  						exit_with_error(-ret);
> > > +					continue;
> > 
> > Why continue here?
> 
> You are right it is not needed. Will update in V2 patch. Thanks.
> 
> > 
> > >  				}
> > >  				ret = xsk_ring_prod__reserve(&umem->fq,
> > rcvd, &idx_fq);
> > >  			}
> > > @@ -900,13 +927,34 @@ static int receive_pkts(struct ifobject *ifobj, struct
> > pollfd *fds)
> > >  	return TEST_PASS;
> > >  }
> > >
> > > -static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
> > > +static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, bool
> > use_poll,
> > > +		       struct pollfd *fds, bool timeout)
> > >  {
> > >  	struct xsk_socket_info *xsk = ifobject->xsk;
> > > -	u32 i, idx, valid_pkts = 0;
> > > +	u32 i, idx, ret, valid_pkts = 0;
> > > +
> > > +	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) <
> > BATCH_SIZE) {
> > > +		if (use_poll) {
> > > +			ret = poll(fds, 1, POLL_TMOUT);
> > > +			if (timeout) {
> > > +				if (ret < 0) {
> > > +					ksft_print_msg("DEBUG: [%s] Poll
> > error %d\n",
> > > +						       __func__, ret);
> > > +					return TEST_FAILURE;
> > > +				}
> > > +				if (ret == 0)
> > > +					return TEST_PASS;
> > > +				break;
> > > +			}
> > > +			if (ret <= 0) {
> > > +				ksft_print_msg("DEBUG: [%s] Poll error
> > %d\n",
> > > +					       __func__, ret);
> > > +				return TEST_FAILURE;
> > > +			}
> > > +		}
> > >
> > > -	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) <
> > BATCH_SIZE)
> > >  		complete_pkts(xsk, BATCH_SIZE);
> > > +	}
> > >
> > >  	for (i = 0; i < BATCH_SIZE; i++) {
> > >  		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk-
> > >tx, idx +
> > > i); @@ -933,11 +981,27 @@ static int __send_pkts(struct ifobject
> > > *ifobject, u32 *pkt_nb)
> > >
> > >  	xsk_ring_prod__submit(&xsk->tx, i);
> > >  	xsk->outstanding_tx += valid_pkts;
> > > -	if (complete_pkts(xsk, i))
> > > -		return TEST_FAILURE;
> > >
> > > -	usleep(10);
> > > -	return TEST_PASS;
> > > +	if (use_poll) {
> > > +		ret = poll(fds, 1, POLL_TMOUT);
> > > +		if (ret <= 0) {
> > > +			if (ret == 0 && timeout)
> > > +				return TEST_PASS;
> > > +
> > > +			ksft_print_msg("DEBUG: [%s] Poll error %d\n",

avoid debug prints in upstream patches

> > __func__, ret);
> > > +			return TEST_FAILURE;
> > > +		}
> > > +	}
> > > +
> > > +	if (!timeout) {
> > > +		if (complete_pkts(xsk, i))
> > > +			return TEST_FAILURE;
> > > +
> > > +		usleep(10);
> > > +		return TEST_PASS;
> > > +	}
> > > +
> > > +	return TEST_CONTINUE;
> > 
> > Why do you need this?
> > 
> 
> __send_pkts is expected to return TEST_PASS or TEST_FAIL to send_pkts function and
> if returned TEST_PASS then continue sending pkts and exit when all the packet are finished.
> if returned TEST_FAILURE then test failed and return.
> 
> For TEST_TYPE_POLL_TXQ_TMOUT  TEST_PASS is return value when timout happened and
> should not sent anymore packets and break. But this will break other test. So needed 
> new return type TEST_CONTINUE to keep sending packets.
> 
> > >  }
> > >
> > >  static void wait_for_tx_completion(struct xsk_socket_info *xsk) @@
> > > -948,29 +1012,33 @@ static void wait_for_tx_completion(struct
> > > xsk_socket_info *xsk)
> > >
> > >  static int send_pkts(struct test_spec *test, struct ifobject
> > > *ifobject)  {
> > > +	struct timeval tv_end, tv_now, tv_timeout = {THREAD_TMOUT, 0};
> > > +	bool timeout = test->ifobj_rx->skip_rx;
> > >  	struct pollfd fds = { };
> > > -	u32 pkt_cnt = 0;
> > > +	u32 pkt_cnt = 0, ret;
> > >
> > >  	fds.fd = xsk_socket__fd(ifobject->xsk->xsk);
> > >  	fds.events = POLLOUT;
> > >
> > > -	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
> > > -		int err;
> > > -
> > > -		if (ifobject->use_poll) {
> > > -			int ret;
> > > -
> > > -			ret = poll(&fds, 1, POLL_TMOUT);
> > > -			if (ret <= 0)
> > > -				continue;
> > > +	ret = gettimeofday(&tv_now, NULL);
> > > +	if (ret)
> > > +		exit_with_error(errno);
> > > +	timeradd(&tv_now, &tv_timeout, &tv_end);
> > 
> > This logic of timer on Tx side is not mentioned anywhere in the commit
> > message. Please try your best to describe all of the changes you're
> > proposing.
> > 
> 
> Will update in the commit message in V2 patch.
> 
> > Also, couldn't this be a separate patch?
> > 
> I prefer to keep it. But if you suggest otherwise I can remove.

I'm not talking about removing this altogether, pulling this out to
separate patch would make this one cleaner and reviewers job easier.

> 
> > >
> > > -			if (!(fds.revents & POLLOUT))
> > > -				continue;
> > > +	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
> > > +		ret = gettimeofday(&tv_now, NULL);
> > > +		if (ret)
> > > +			exit_with_error(errno);
> > > +		if (timercmp(&tv_now, &tv_end, >)) {
> > > +			ksft_print_msg("ERROR: [%s] Send loop timed
> > out\n", __func__);
> > > +			return TEST_FAILURE;
> > >  		}
> > >
> > > -		err = __send_pkts(ifobject, &pkt_cnt);
> > > -		if (err || test->fail)
> > > +		ret = __send_pkts(ifobject, &pkt_cnt, ifobject->use_poll,
> > &fds, timeout);
> > > +		if ((ret || test->fail) && !timeout)
> > >  			return TEST_FAILURE;
> > > +		else if (ret == TEST_PASS && timeout)
> > > +			return ret;
> > >  	}
> > >
> > >  	wait_for_tx_completion(ifobject->xsk);
> > > @@ -1235,8 +1303,7 @@ static void *worker_testapp_validate_rx(void
> > > *arg)
> > >
> > >  	pthread_barrier_wait(&barr);
> > >
> > > -	err = receive_pkts(ifobject, &fds);
> > > -
> > > +	err = receive_pkts(ifobject, &fds, test->ifobj_tx->skip_tx);
> > >  	if (!err && ifobject->validation_func)
> > >  		err = ifobject->validation_func(ifobject);
> > >  	if (err) {
> > > @@ -1265,17 +1332,21 @@ static int testapp_validate_traffic(struct
> > test_spec *test)
> > >  	pkts_in_flight = 0;
> > >
> > >  	/*Spawn RX thread */
> > > -	pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
> > > -
> > > -	pthread_barrier_wait(&barr);
> > > -	if (pthread_barrier_destroy(&barr))
> > > -		exit_with_error(errno);
> > > +	if (!ifobj_rx->skip_rx) {
> > > +		pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
> > > +		pthread_barrier_wait(&barr);
> > > +		if (pthread_barrier_destroy(&barr))
> > > +			exit_with_error(errno);
> > > +	}
> > >
> > >  	/*Spawn TX thread */
> > > -	pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
> > > +	if (!ifobj_tx->skip_tx) {
> > > +		pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
> > > +		pthread_join(t1, NULL);
> > > +	}
> > >
> > > -	pthread_join(t1, NULL);
> > > -	pthread_join(t0, NULL);
> > > +	if (!ifobj_rx->skip_rx)
> > > +		pthread_join(t0, NULL);
> > 
> > Have you thought of a testapp_validate_traffic() variant with a single thread,
> > either Tx or Rx? In this case probably would make everything clearer in the
> > current pthread code. Also, wouldn't this drop the need for skip booleans?
> > 
> 
> My suggestion will be to reuse the existing functions. If you suggest otherwise
> I can look into it.

Existing function wasn't designed for single thread execution which you
need for your poll test cases. That's why I asked you to discover if
having a function designed for single threaded tests is worth the hassle.

> 
> > >
> > >  	return !!test->fail;
> > >  }
> > > @@ -1548,10 +1619,28 @@ static void run_pkt_test(struct test_spec
> > > *test, enum test_mode mode, enum test_
> > >
> > >  		pkt_stream_restore_default(test);
> > >  		break;
> > > -	case TEST_TYPE_POLL:
> > > +	case TEST_TYPE_RX_POLL:
> > > +		test->ifobj_rx->use_poll = true;
> > > +		test_spec_set_name(test, "POLL_RX");
> > > +		testapp_validate_traffic(test);
> > > +		break;
> > > +	case TEST_TYPE_TX_POLL:
> > >  		test->ifobj_tx->use_poll = true;
> > > +		test_spec_set_name(test, "POLL_TX");
> > > +		testapp_validate_traffic(test);
> > > +		break;
> > > +	case TEST_TYPE_POLL_TXQ_TMOUT:
> > > +		test_spec_set_name(test, "POLL_TXQ_FULL");
> > > +		test->ifobj_rx->skip_rx = true;
> > > +		test->ifobj_tx->use_poll = true;
> > > +		pkt_stream_invalid(test, 2 * DEFAULT_PKT_CNT, PKT_SIZE);
> > > +		testapp_validate_traffic(test);
> > > +		pkt_stream_restore_default(test);
> > > +		break;
> > > +	case TEST_TYPE_POLL_RXQ_TMOUT:
> > > +		test_spec_set_name(test, "POLL_RXQ_EMPTY");
> > > +		test->ifobj_tx->skip_tx = true;
> > >  		test->ifobj_rx->use_poll = true;
> > > -		test_spec_set_name(test, "POLL");
> > >  		testapp_validate_traffic(test);
> > >  		break;
> > >  	case TEST_TYPE_ALIGNED_INV_DESC:
> > > diff --git a/tools/testing/selftests/bpf/xskxceiver.h
> > > b/tools/testing/selftests/bpf/xskxceiver.h
> > > index 3d17053f98e5..0db7e0acccb2 100644
> > > --- a/tools/testing/selftests/bpf/xskxceiver.h
> > > +++ b/tools/testing/selftests/bpf/xskxceiver.h
> > > @@ -27,6 +27,7 @@
> > >
> > >  #define TEST_PASS 0
> > >  #define TEST_FAILURE -1
> > > +#define TEST_CONTINUE 1
> > >  #define MAX_INTERFACES 2
> > >  #define MAX_INTERFACE_NAME_CHARS 7
> > >  #define MAX_INTERFACES_NAMESPACE_CHARS 10 @@ -48,7 +49,7 @@
> > #define
> > > SOCK_RECONF_CTR 10  #define BATCH_SIZE 64  #define POLL_TMOUT
> > 1000
> > > -#define RECV_TMOUT 3
> > > +#define THREAD_TMOUT 3
> > >  #define DEFAULT_PKT_CNT (4 * 1024)
> > >  #define DEFAULT_UMEM_BUFFERS (DEFAULT_PKT_CNT / 4)  #define
> > UMEM_SIZE
> > > (DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE) @@ -
> > 68,7 +69,10
> > > @@ enum test_type {
> > >  	TEST_TYPE_RUN_TO_COMPLETION,
> > >  	TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME,
> > >  	TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT,
> > > -	TEST_TYPE_POLL,
> > > +	TEST_TYPE_RX_POLL,
> > > +	TEST_TYPE_TX_POLL,
> > > +	TEST_TYPE_POLL_RXQ_TMOUT,
> > > +	TEST_TYPE_POLL_TXQ_TMOUT,
> > >  	TEST_TYPE_UNALIGNED,
> > >  	TEST_TYPE_ALIGNED_INV_DESC,
> > >  	TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME,
> > > @@ -145,6 +149,8 @@ struct ifobject {
> > >  	bool tx_on;
> > >  	bool rx_on;
> > >  	bool use_poll;
> > > +	bool skip_rx;
> > > +	bool skip_tx;
> > >  	bool busy_poll;
> > >  	bool use_fill_ring;
> > >  	bool release_rx;
> > > --
> > > 2.34.1
> > >
