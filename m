Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800E1582998
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 17:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbiG0P0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 11:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbiG0P0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 11:26:43 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB2D43E60;
        Wed, 27 Jul 2022 08:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658935602; x=1690471602;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=e82aG/9kYDBwlvuH5EUCoIBWbvsqH68bXYVYeR+ibbc=;
  b=RLko6GP8uWeOmYKyaYAfl80xPOoDD/pDY3ahZaXX+SBMbF8FZmfW5Ove
   BCGxByHt6IgqmBCdMdiBWOfV3/Iu0ZfFZnQP/BsgeuFdPJhDS0JOp6EG/
   fkBj18ogbwwWBvrFiD1l3Q2UvVAKFu7C6Z+ZqhlRpA041abTuj09X9BxP
   C+0JD8CLIqG+Fx6SOCgTodbcnwm1bbRkzkB4nRbxWCZkfEvtv6WBZbh/o
   CYhmRsaF9ksE2Z7mEK3TTOSfUfnN+mDlR1tRyZiFqRT0au6+HjqmNv66/
   U29LB5kgllp22QRsvalwOwLCxKqva9pckGRGMXDwGqWR5+avFf8W9fTqo
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="374565446"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="374565446"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 08:26:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="846308557"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 27 Jul 2022 08:26:41 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 27 Jul 2022 08:26:41 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 27 Jul 2022 08:26:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 27 Jul 2022 08:26:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 27 Jul 2022 08:26:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7LhGnWk7vFElEdWFHCPSuLm4Vj2YYDdMGdyJICdbr3s4EUUNA0XqtG//wT/nWD95ysPP1cXgeOIMAE5MkAExqbKFaq95fvbXVy6Qz/5/WIrp9p/6HeHgNKHrj0Ip6/EzUlgtsLbUzaTgvmTYXHj4a7mEITHnuBPobBLw5ctz6fNrrqWS5vkBRIDIa01jTDBBcyrMfNZxRXc6D5JPg44aakVJZG4EvPLxwr4su9aU2LoOah89hsXwTZY0O94XJvNvcLxx6e1JZkH/xo0ajAFdc2r3dgl4BumSaZWkJRMjQ/3kthPn4Ea2zuf7vDaFlx0/qxVzoC7Vg2x5CPeSey3pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQ7XHJxEZJgBz55nrajmSLRpuJ17zYUpRtsqRGuJew0=;
 b=Ry4UFC7aXdZF7bg9NwZUiGX77NHTDCh748feyN1aqU43vxFsCITDMxArhPdM1J5ip/7olKv6QazbfRazbzvWF/dYv9+7GnGNWfqVl4ETW+N9joKwwvW0C6pLPHaVJmDNwIIAl0QpWw6DjKnK3EhkgReSOBpDUmq1TpjhyBCrwvo1jBqelQRy0dT/waLcs9pveWHRLbqnKvzAJOiuDyOdR7JxqgDzGeooqFqSdTN1ouzTXvhjVEQSI8yezaT61KKRAFFCakRvl/zaeVq9SxxR29aDS+BzoNYOlSXcppL38GyuT3/ujT7EnlRp6Ub2zGV7+q9Ou0UxZShCPoB491T8IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CY4PR11MB1256.namprd11.prod.outlook.com (2603:10b6:903:25::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.23; Wed, 27 Jul 2022 15:26:34 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9cba:7299:ab7d:b669]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9cba:7299:ab7d:b669%8]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 15:26:33 +0000
Date:   Wed, 27 Jul 2022 17:26:20 +0200
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
Message-ID: <YuFZHDdta6v++78J@boxer>
References: <20220718095712.588513-1-shibin.koikkara.reeny@intel.com>
 <YtqxJ4f1osDc1Rtg@boxer>
 <DM6PR11MB3995991A0874B1FEFB384376A2949@DM6PR11MB3995.namprd11.prod.outlook.com>
 <Yt/1yLNzEvPFR0Y2@boxer>
 <DM6PR11MB3995F941D45E5CC3CA05554DA2979@DM6PR11MB3995.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <DM6PR11MB3995F941D45E5CC3CA05554DA2979@DM6PR11MB3995.namprd11.prod.outlook.com>
X-ClientProxiedBy: AM0PR04CA0026.eurprd04.prod.outlook.com
 (2603:10a6:208:122::39) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67b14cc0-bfda-474b-36ee-08da6fe462f6
X-MS-TrafficTypeDiagnostic: CY4PR11MB1256:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uKNkiwf4YXzMHMKxzuvp3GIAblqCqLohM5ALVn/Q3AU/13zVzR3Nu8t1KRu1vyJVW6R5xG5mKmLNe/CNYgl7CietwBLz+jmU3VDUKEIPBe7F0hlRlyXleeWG7I4kaGnsb7XBo1GTw8Ah4MS8RvFOZFEuALxuzujHtawZMAGupOkDajNwE9Uyi4qojaCNljWbeG4esho2y8fuhdSNy3bhczXQ3ctH4aleskYdJOhWQrtfUNiZ5yWf9cTXLJzl/HeFHb+1DIfFnjC6gS7i7tT87ss9aYCkiq2DekmxdFG1pJNl3niz4fRtuTcQv92xxri6Fd7V9pGcmLb18bklidanIfOmoTAaAoOoMzLG47rG164egopaYJcvqbHQJR1K/qvVxNrFUKqczwxunoAWQI4tcQCSFt6qHI6IXg8YJzUyLGtY7m6FQmvB/X/Jao+Z5U5t6kkDuBjG9IvKgCo7Iesq+MHaGjgNR4SW0wVbWpkh6R4VED7v42WSB87cDMRanT/8Qb/SRLr46Ua12v7nBHlERhoci4NmnEaI/ThzCIkpETaGuNh3j35Iev1Dd0nqaxRsLEeSQSuacWg9p0cCUikf0Up0fcJquzAAdvD9ZMvipzF8IiB/Dk78/Kth+9mmw3GmAG4BQRVk95RCJy5SP3SEmIswO2zN7Uab0jL8J/7H9SfK2vb4bA2qjELfawANvUWO8cs1WfzdGuUR0ZbIpJ82dBjuhjZcIfaEe/XbJUuze9gBvATRfjxVug2ORh7npWlZNaSXP2sHdMnVW3PA6PPR4EQ3eICHF3QfebOP1s/KQ/s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(366004)(39860400002)(376002)(396003)(346002)(4326008)(9686003)(6512007)(53546011)(82960400001)(26005)(33716001)(38100700002)(8676002)(66946007)(15650500001)(66556008)(6666004)(41300700001)(66476007)(2906002)(6506007)(316002)(6862004)(186003)(5660300002)(6486002)(478600001)(86362001)(107886003)(6636002)(8936002)(44832011)(54906003)(83380400001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7hzOnHG/oqUhXiwydDAFYLryraJ+e7T9VR/DfybZGBl4RgI9e2FLGzMjqoD0?=
 =?us-ascii?Q?wpn+OFewhWj+LM5i6twjPs1mhqF7+ltdjm3mbbqE8V8vN4w631ncSQ5J4i/l?=
 =?us-ascii?Q?+CRI/r8jVZhL2HEIFOA4QKj3thkV9SUQlPTKy/1VGv6Mn1QRYTONLo/LdRG3?=
 =?us-ascii?Q?epiKKEMykoSw0/V2N9PfW6KkQM6zNEjtvOc/Gk0dxjxV8JsF2BQTStoZ6PoJ?=
 =?us-ascii?Q?GfOBiTBSBjDK084/pBkQDkXbp7elGqZwfirPMy3EFS/IQDTjdcN72EwHcuiO?=
 =?us-ascii?Q?4NwmjJbuy+wNZPDND7Oxy+b41fZ9HJhy2PlmO8pYruGmBvnk4K044LwGuCEs?=
 =?us-ascii?Q?9zKbomuFDnfc5mKyNjBPtbtrJgi3v/2It2H2HMVlayObpF8fNc4My5QoQtXY?=
 =?us-ascii?Q?LG4iPo9wLTi2CZ7AS+RW00GApbnDeGAZgJUJYx3V1R2CTW5FeQ9rFlC/VVv7?=
 =?us-ascii?Q?yL6CArEicURgr7ohbSTcg14RKxkuJp6v6FhmVYoBE0UDcCCKmZFYAT+W7Fd7?=
 =?us-ascii?Q?QC+A2PGk3K3d1J6DnoB5hp44N0RTXx259bnzgVyTScV+bpUgRVCOmqWIqm7P?=
 =?us-ascii?Q?qldH5Lxbe1NrbcWjCAJoIaPkhuSTKEqXb5MF5zOoJYYDBy4dsRqAGj1CMzfM?=
 =?us-ascii?Q?2DDWWgKeW9w8cxLwmU/zZg4TwRSnZ8bTp7ej9eAXz4A+YNdGGQnT8ibz4fm/?=
 =?us-ascii?Q?vBih2QT1yxFzzyLVloj0xU7lZ0W/MclmBSdCklR1hAiPCK+IoOqBqnLACXNt?=
 =?us-ascii?Q?2B8qGcQIn2Fbqqje6GDpHY67BC+3sTiAfWhpAdcjcHK/Yei22ah3jWyj9aC2?=
 =?us-ascii?Q?9FDM/9afgaMkt3fXY1q7FOiISVz7DyKtiSoEAoMiLHItKn1SY04iG1aPkx7G?=
 =?us-ascii?Q?WQBaBeeaurYnFl064eBTLpBa5n/pQIS4UM55C2vI0tbYhoa+SzZYPigRNfzA?=
 =?us-ascii?Q?kUSx+d0O0Hl/NLnBSPvOGiJsTxDgAEP+L4HOdoZkGdRJfawFkYr03N7ZBZka?=
 =?us-ascii?Q?vioJ1qxRaoISrG/MWRyquenEuiKZstq56MsmXz6cgWhmLxw8Q18B1k2Zk2MF?=
 =?us-ascii?Q?MwrGN67cKAmyMrX1GYzKo7cVxgnVohRQ62h3eXa6OT+sTr8NdRt8sEPhyyAQ?=
 =?us-ascii?Q?Qnlr8nmPTxp/PNJfHguJua+53cPGZdymktljiVOQSgl5lDDhSfasfFFodLZf?=
 =?us-ascii?Q?vV8kh0QTERQXx217gHIiR0+lKDzWkJjFzRJy+hDiQ6/jGMheixlErMurcFAT?=
 =?us-ascii?Q?ZhQ1mXHDg5TkkeoFKlDhN23Y2kF6TwWGvH808+0420BlbajXpf6G99SKd1r+?=
 =?us-ascii?Q?WAE9JZjjMRy+hEsOB2UD8lmZDu8pZCMJs0o2200eg2H0VDac50BaQ/LPjf/+?=
 =?us-ascii?Q?Juk+D6eJwch6WBx2sRNxGdx/xNRaOXyYD3ZqpsFydOTluB91r/i8/V2X1zmR?=
 =?us-ascii?Q?y/nX6CxPqZoZZvzW1VWpkd2XysdUVO+mXZ0tTbK6FJgisvKN6O7t80VFYlXk?=
 =?us-ascii?Q?c+dGmYZSxTb1zJHzy1qW/9YZKhri0YlaMRAlEXs4DYerIxFpr4yG9UekhRqc?=
 =?us-ascii?Q?Xruw/hTYcKMZO9bJALShuY9Dz4ZSTrAMleTIdIHEBz/FA4ub9QVmp6Wyp0BF?=
 =?us-ascii?Q?Og=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b14cc0-bfda-474b-36ee-08da6fe462f6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 15:26:33.6303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LO7NZcL4XCYvTSLa82MCngsS7Ba/ROW+whswnf9Phjseg1FTGxXURoNLDYMzTarfKmPcmEg5qvkv5wQcs06+exp301W03ApbBTG2hxX4X64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1256
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 11:49:57AM +0100, Koikkara Reeny, Shibin wrote:
> 
> > -----Original Message-----
> > From: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> > Sent: Tuesday, July 26, 2022 3:10 PM
> > To: Koikkara Reeny, Shibin <shibin.koikkara.reeny@intel.com>
> > Cc: bpf@vger.kernel.org; ast@kernel.org; daniel@iogearbox.net;
> > netdev@vger.kernel.org; Karlsson, Magnus <magnus.karlsson@intel.com>;
> > bjorn@kernel.org; kuba@kernel.org; andrii@kernel.org; Loftus, Ciara
> > <ciara.loftus@intel.com>
> > Subject: Re: [PATCH bpf-next] selftests: xsk: Update poll test cases
> > 
> > On Tue, Jul 26, 2022 at 10:43:36AM +0100, Koikkara Reeny, Shibin wrote:
> > > > -----Original Message-----
> > > > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > > Sent: Friday, July 22, 2022 3:16 PM
> > > > To: Koikkara Reeny, Shibin <shibin.koikkara.reeny@intel.com>
> > > > Cc: bpf@vger.kernel.org; ast@kernel.org; daniel@iogearbox.net;
> > > > netdev@vger.kernel.org; Karlsson, Magnus
> > > > <magnus.karlsson@intel.com>; bjorn@kernel.org; kuba@kernel.org;
> > > > andrii@kernel.org; Loftus, Ciara <ciara.loftus@intel.com>
> > > > Subject: Re: [PATCH bpf-next] selftests: xsk: Update poll test cases
> > > >
> > > > On Mon, Jul 18, 2022 at 09:57:12AM +0000, Shibin Koikkara Reeny wrote:
> > > > > Poll test case was not testing all the functionality of the poll
> > > > > feature in the testsuite. This patch update the poll test case
> > > > > with 2 more testcases to check the timeout features.
> > > > >
> > > > > Poll test case have 4 sub test cases:
> > > >
> > > > Hi Shibin,
> > > >
> > > > Kinda not clear with count of added test cases, at first you say you
> > > > add 2 more but then you mention something about 4 sub test cases.
> > > >
> > > > To me these are separate test cases.
> > > >
> > > Hi Maciej,
> > >
> > > Will update it in V2
> > >
> > > > >
> > > > > 1. TEST_TYPE_RX_POLL:
> > > > > Check if POLLIN function work as expect.
> > > > >
> > > > > 2. TEST_TYPE_TX_POLL:
> > > > > Check if POLLOUT function work as expect.
> > > >
> > > > From run_pkt_test, I don't see any difference between 1 and 2. Why
> > > > split then?
> > > >
> > >
> > >
> > > It was done to show which case exactly broke. If RX poll event or TX
> > > poll event
> > >
> > > > >
> > > > > 3. TEST_TYPE_POLL_RXQ_EMPTY:
> > > >
> > > > 3 and 4 don't match with the code here
> > > > (TEST_TYPE_POLL_{R,T}XQ_TMOUT)
> > > >
> > > > > call poll function with parameter POLLIN on empty rx queue will
> > > > > cause timeout.If return timeout then test case is pass.
> > > > >
> > >
> > >
> > > True but  It was change to RXQ_EMPTY and TXQ_FULL from _TMOUT to
> > make
> > > it more clearer to what exactly is happening to cause timeout.
> > >
> > > > > 4. TEST_TYPE_POLL_TXQ_FULL:
> > > > > When txq is filled and packets are not cleaned by the kernel then
> > > > > if we invoke the poll function with POLLOUT then it should trigger
> > > > > timeout.If return timeout then test case is pass.
> > > > >
> > > > > Signed-off-by: Shibin Koikkara Reeny
> > > > > <shibin.koikkara.reeny@intel.com>
> > > > > ---
> > > > >  tools/testing/selftests/bpf/xskxceiver.c | 173
> > > > > +++++++++++++++++------  tools/testing/selftests/bpf/xskxceiver.h
> > > > > +++++++++++++++++|
> > > > > 10 +-
> > > > >  2 files changed, 139 insertions(+), 44 deletions(-)
> > > > >
> > > > > diff --git a/tools/testing/selftests/bpf/xskxceiver.c
> > > > > b/tools/testing/selftests/bpf/xskxceiver.c
> > > > > index 74d56d971baf..8ecab3a47c9e 100644
> > > > > --- a/tools/testing/selftests/bpf/xskxceiver.c
> > > > > +++ b/tools/testing/selftests/bpf/xskxceiver.c
> > > > > @@ -424,6 +424,8 @@ static void __test_spec_init(struct test_spec
> > > > > *test, struct ifobject *ifobj_tx,
> > > > >
> > > > >  		ifobj->xsk = &ifobj->xsk_arr[0];
> > > > >  		ifobj->use_poll = false;
> > > > > +		ifobj->skip_rx = false;
> > > > > +		ifobj->skip_tx = false;
> > > >
> > > > Any chances of trying to avoid these booleans? Not that it's a hard
> > > > nack, but the less booleans we spread around in this code the better.
> > >
> > >
> > > Not sure if it is possible but using any other logic will make the
> > > code more complex and less readable.
> > 
> > How did you come with such judgement? You didn't even try the idea that I
> > gave to you about having a testapp_validate_traffic() equivalent with a single
> > thread.
> > 
> 
> Hi Maciej,
> 
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 4394788829bf..0b58e026f2a2 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -1317,6 +1317,24 @@ static void *worker_testapp_validate_rx(void *arg)
>         pthread_exit(NULL);
>  }
> 
> +static int testapp_validate_traffic_txq_tmout(struct test_spec *test)
> +{
> +       struct ifobject *ifobj_tx = test->ifobj_tx;
> +       pthread_t t0;
> +
> +       if (pthread_barrier_init(&barr, NULL, 2))
> +               exit_with_error(errno);
> +
> +       test->current_step++;
> +       pkt_stream_reset(ifobj_rx->pkt_stream);
> +
> +       pthread_create(&t0, NULL, ifobj_tx->func_ptr, test);
> +       pthread_join(t0, NULL);
> +
> +       return !!test->fail;
> +}
> +
> 
> This is what you are suggesting do ?
> 
> My point is ifobj_tx->func_ptr calls worker_testapp_validate_tx() ==> send_pkts() ==> __send_pkts().
> 
> Normal case when poll timeout happen send_pkts() return TEST_FAILURE which is expected.
> Test Case like TEST_TYPE_POLL_TXQ_TMOUT and TEST_TYPE_POLL_RXQ_TMOUT when poll timeout happen
> it should return TEST_PASS rather than TEST_FAILURE. How should I let the send_pkts()
> to know what timeout type of test is running without a new variable or flag? 
> Then boolean skip_rx and skip_tx are both used in the send_pkts() and receive_pkts().
> 
> This is why I thought it might be complex but if you have new suggestion I open to try it.

In such case you could just lookup if test->ifobj_rx has valid umem
pointer or xsk socket. If you didn't spawn rx thread then you know that
resources for Rx are not initialized, thread_common_ops() was not called
there. And you have a pointer to test_spec which allows you to dig up
other ifobject. There are also {r,t}x_on booleans which probably could be
used for your purposes, couldn't they? You are not testing the
bidirectional traffic, you're rather working on a single thread in one
direction.

Do you see what I'm trying to explain?

And sorry if I sounded mean or something in previous message exchanges,
just some harsh stuff on my side that is happening. We're only humans,
after all ;)

> 
> > >
> > > >
> > > > >  		ifobj->use_fill_ring = true;
> > > > >  		ifobj->release_rx = true;
> > > > >  		ifobj->pkt_stream = test->pkt_stream_default; @@ -589,6
> > > > +591,19 @@
> > > > > static struct pkt_stream *pkt_stream_clone(struct xsk_umem_info
> > > > *umem,
> > > > >  	return pkt_stream_generate(umem, pkt_stream->nb_pkts,
> > > > > pkt_stream->pkts[0].len);  }
> > > > >
> > > > > +static void pkt_stream_invalid(struct test_spec *test, u32
> > > > > +nb_pkts,
> > > > > +u32 pkt_len) {
> > > > > +	struct pkt_stream *pkt_stream;
> > > > > +	u32 i;
> > > > > +
> > > > > +	pkt_stream = pkt_stream_generate(test->ifobj_tx->umem,
> > > > nb_pkts, pkt_len);
> > > > > +	for (i = 0; i < nb_pkts; i++)
> > > > > +		pkt_stream->pkts[i].valid = false;
> > > > > +
> > > > > +	test->ifobj_tx->pkt_stream = pkt_stream;
> > > > > +	test->ifobj_rx->pkt_stream = pkt_stream; }
> > > >
> > > > Please explain how this work, e.g. why you need to have to have
> > > > invalid pkt stream + avoiding launching rx thread and why one of them is
> > not enough.
> > > >
> > > > Personally I think this is not needed. When calling
> > > > pkt_stream_generate(), validity of pkt is set based on length of packet vs
> > frame size:
> > > >
> > > > 		if (pkt_len > umem->frame_size)
> > > > 			pkt_stream->pkts[i].valid = false;
> > > >
> > > > so couldn't you use 2k frame size and bigger length of a packet?
> > > >
> > > This function was introduced for TEST_TYPE_POLL_TXQ_FULL keep the TX
> > > full and stop nofying the kernel that there is packet to cleanup.
> > > So we are manually setting the packets to invalid. This help to keep
> > > the __send_pkts() more generic and reduce the if conditions.
> > > ex: xsk_ring_prod__submit() is not needed to be added inside if condition.
> > 
> > I understand the intend behind it but what I was saying was that you have
> > everything ready to be used without a need for introducing new functions.
> > You could also try out what I suggested just to see if this makes things
> > simpler.
> > 
> 
> Are you suggesting to do this ?

Yes

>                 test->ifobj_tx->use_poll = true;
> -               pkt_stream_invalid(test, 2 * DEFAULT_PKT_CNT, PKT_SIZE);
> +               test->ifobj_tx->umem->frame_size = 2048;
> +               pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
>                 testapp_validate_traffic(test);
> 
> 
> > >
> > > You are right we don't need rx stream but thought it will be good to
> > > keep as can be used for other features in future and will be more generic.

Yeah if you really want I'll be ok with pkt_stream_invalid().

> > 
