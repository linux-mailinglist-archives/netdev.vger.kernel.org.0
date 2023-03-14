Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EFA6B9F06
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbjCNStY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjCNStP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:49:15 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B03B7DB3;
        Tue, 14 Mar 2023 11:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678819731; x=1710355731;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=9pEhJ2psMNympt2WARRpOgMJzFFuo5NS+0WPG7Lrok0=;
  b=dpeR+dztbGdKYXUNfW/r9h7aW4pMIdk6Pq7sZwLlA8EwYckcG+mucH6E
   QIcaxwD2cwUl+W3zYbusaZEq6sgTg9fgDO03km7FM/mYv6U42ureL27Sw
   AXj0CdHEBT4M0CV/qlXABQzKGhXQv/Kz4YSjiVAytDsLL/PNYM6KBu8Ov
   xJMLiXqYKzAvR4e96BanFpBd6QWgGSQ2TALXAHZ41CPGJmsYm6x+aymZb
   VBCiJ57KCz0u935iOOCed4nduAWu/wS1uLioDghHCTkR9jYjQL/75Llm8
   56CM8yOE8/rp8HYn8fDXvJ4m/CQ8xXnKEy1NDB6qdEbjBh5Bprvw4K2SG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="402380965"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="402380965"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 11:48:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="679203336"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="679203336"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 14 Mar 2023 11:48:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 11:48:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 11:48:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 11:48:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 11:48:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxxotESw6Lyf5aDFj1OF2l0TDoAStormwh2cbWsAbvrhResZARX4qCNpPBPv4bOIb2fORQZvmA5WN3i3zqrIFjwKDbBem5EdDyRQkm8FJgVWywtwv9GGLLQ6NE55B6n6DPFVsXMZHUjDQF4Dw1VVXzIY0zHRlYfCpqxEDjwbN4LL/nOgzYvP0zSHlpcbjuFh+Z7a06h8Cw7p/VrHFhEJYOO/bhVJT1k40bv6+0Z9QUk07VvJpgxtgrFZeXpNoftMSNxplg8fUpygSZsB0/LfwtzpJSLs6XsG+BQblTYRErtaauzVlb2osG7QoVcp91RAErsq3ihOD/Ogai539HV4CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EHg/2d9+NZyR3QdN6hGhyJ6DLPQteva3mog4ooy2BGk=;
 b=bZJFwjWPZN2TKLHiVRzreXpdMJ7IiI4hPuzGMoQg77RFBvGzVnp0r0b8Kpb6n8O7QimNkXIL+eLGQbfe1O8KsO1mzoOQ+fXSgMLgYxCoLllZ0w/Km5eDUSO/6FPhp+5ljXfSo05zTYnrBtPRTDUJWcXyH+nO6FcrCV6FifErs07tuKaeh6p86dK/lPi9cMZGqovfpRn/BSBkJlYopXZug686uc6CpB1X6yYDIAU9nGQP0cSjsgQe83n159Fb9EWBFtS26CrZ0bXr2waghQ6jXVWxl8+LME4mkgCUG1SySgpS07CbNGhWDZRBglfCNC5qz8xjDdmZ0d6F/OVD1bT+Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 PH7PR11MB6450.namprd11.prod.outlook.com (2603:10b6:510:1f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Tue, 14 Mar
 2023 18:48:26 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 18:48:26 +0000
Date:   Tue, 14 Mar 2023 19:48:13 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Jaewan Kim <jaewan@google.com>
CC:     <gregkh@linuxfoundation.org>, <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@android.com>, <adelva@google.com>
Subject: Re: [PATCH v9 5/5] mac80211_hwsim: add PMSR report support via virtio
Message-ID: <ZBDBbZYSmBWIVOVh@localhost.localdomain>
References: <20230313075326.3594869-1-jaewan@google.com>
 <20230313075326.3594869-6-jaewan@google.com>
 <ZA+G3Rr+ibEL+2cX@localhost.localdomain>
 <CABZjns6=8-cxQbUh2510eQ0B6C80hzMNDxFyY7zxgLY+NJTRGQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABZjns6=8-cxQbUh2510eQ0B6C80hzMNDxFyY7zxgLY+NJTRGQ@mail.gmail.com>
X-ClientProxiedBy: FR2P281CA0130.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::11) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|PH7PR11MB6450:EE_
X-MS-Office365-Filtering-Correlation-Id: 30daa0b8-14f0-4cba-0d64-08db24bcb1b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u7fZ1a/ekU+UwGZVgmtUbRvhgC+ZDHE00JlfBbvrwhHkLqX3NUGuQqOeZeAq+9lNWa9ejtsISp/ecVscYXuwBByWoIBHAP+UrY0iZq0ztshfnhw05orERHuSSuvdWhCUOkEPmO0Sa7GEeCtsMg7zfzv1DGuoREGbGYIi1lBJJq+IUsIUT3RKVIZqiUdNYur2vd3d2vLuB0u9caom8Ey25XIZiR27OZMvMDlY0q6bRjV7FBztExCrbnL1KsqgiksyUTejoJc7bL9W3vFNBfe8FSqYT6KMg3KSJDNOkYeasvFSPNlUzBE69LA1hnMlC1osecdWKzJK5cdg1WVYZmluiBSajySqyEY1ZCFNQR7Y6Q0Lby9k+OiMGsgF58sLRMIv8oScRShdVNotbjuX7vmziV7Ep/1CzYcQPbDnsPh24TM4/pcq19mpsxiXdDHFAzg3XukcQm1ajBLBJhTMT+uLhfthsIfoAa8cPLqA6TIxP47VnFhqjg/ywOeWPVDkzC5K//ipTxdEU7D1TBWyYXA7/2E2tP2xZkpkNaq79miCVKBLduAmefFMLDcBXtOSWO5ez8gN9/fX/Z9FancYlVBCGHw0TWOParQOAw5HHbDEjF8gwsLQqzNv74y3d8Arubf3QP5rO/cjwNpWpMVjbKdsprhmJt6HYcvadgI8a6d5Nqts59CQg94L8bdsD+cKdQHe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(346002)(396003)(376002)(366004)(451199018)(83380400001)(9686003)(2906002)(8936002)(478600001)(86362001)(5660300002)(186003)(82960400001)(26005)(30864003)(38100700002)(44832011)(6486002)(6512007)(4326008)(6666004)(66556008)(316002)(8676002)(966005)(66476007)(6506007)(53546011)(6916009)(41300700001)(66946007)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmhiOXdjeWFjZ25uMy9TMFdvTW5kTlBWbU8rU2o3WENUdGdoWFpubXc5ajJC?=
 =?utf-8?B?NkY0dmUreFEyWmd3MkMxSFM5ZTNkVmhPbEc3T3ZGRFR3UmZPUUxCb3BpU0pO?=
 =?utf-8?B?d0NnTlNuS2RvRjR4M0hIOEh5T0U4UEdkclNvTG9lM2EvYmkvazl1dTRxdEhI?=
 =?utf-8?B?MllESXprQU9rMkpoVjJGR2pxanJSeUl3a29ZTGZPWUlBZ1BWa3R6czM4NDFk?=
 =?utf-8?B?KzFEdytpUEZwTEk4eGs2bUFvdzlCWmVJM3I5dVUvc2I3czNNRHAybTdzZmZm?=
 =?utf-8?B?TGZESi9ZS3lmeTlQamY3ekRPWHNubWtuY3F1d21qNGxtNjd2cEZzV1l0K2Ry?=
 =?utf-8?B?UjBOT1J6VnVsUXNtZWJVY3ZQU0ZhSmNKNElGVnNGS0tqUFQ1b2pRQzViaFFp?=
 =?utf-8?B?YTNHcTk3ZUY4dUE5Z08rMC9vY1ZtQ2JXMVlSeHAvdmcrLzd2YkNKWG9Od21D?=
 =?utf-8?B?TkhFVENHdzNhYUZaMUU0RW9ZUWdHZDRXTHRoTXNwdVlrVkE0dmJvUS9KSDgz?=
 =?utf-8?B?TnVZdGVCd1hlZ0oza0dNZzNLYUN3cFR3RGd2eklCakdLMEVFS2JwTnhIcy8r?=
 =?utf-8?B?NXhUV2FBcTdxK241dmdqaUU2NGRzUndSd201RWhBS2xJOEtIV2V4OVVtWEw2?=
 =?utf-8?B?WXFTWHRlNTdMZDIxUW5WVUVRUER4YzEvTmhRNkRBOVFvSTNuaW9YQ3VmVU1n?=
 =?utf-8?B?MHIxNmFrZFovSHJ1NFJKWWlwRkdIYUlBNTRlcldWaTg3bXhBTzBxODlqRkE3?=
 =?utf-8?B?TjFJK3FxaUNSRGk1M3ZkeVJuU281dXlZZXE2NEdtcjFlSFZYZEVmaXVYTzZD?=
 =?utf-8?B?V3luKzlkNUdlRVFOZHFobXdacU9ySEVlNysxSWZKcmkrcDRGNU4wQ2IvMGtN?=
 =?utf-8?B?MkNDM0FSeHhSenJ0SE5tTlVZUXBNQkVXQ0Z2SUl3Z3BTczNvRUdpdDNMODBr?=
 =?utf-8?B?VEo4eGJUTHh2ckRnU0NWMHpNNzgxS1BDdm9sYWtXUkFUd1VJdHdQL0tVVkxj?=
 =?utf-8?B?Q0c2OHZGOVFyUGIwTjVhdFZnK3VEdEpJYmg1b1UxOWlOblBZM1h3NTI1Ny9O?=
 =?utf-8?B?SGFRbHNJMEtidUkrdDVTanlaSkZUVEhnbWFwZmJtOVlvMVVPb09WWmxjT0M2?=
 =?utf-8?B?NnI1Y0YrQXhEdVhCamZ6NGNVa0p5ZTlySjIwZk1hdXBmV2tKWll3NEtJSFg4?=
 =?utf-8?B?eHN3YVcxWnhOalpLRitBTCtYdmZWM0Z0TmhBR0d1ZmRLNHRveDhBWFNmSmpr?=
 =?utf-8?B?azRFVXBibVpNZDZ1bzQydHBqUDQyY21RRHd1OWR1VjM3N1Rnbi9LeFhvUHZs?=
 =?utf-8?B?a0JsWCs0eE9BcXZMVXpGZzI2S0g4Ujk2bkdzRkM5b29jaktkSHpXYWJzWFRX?=
 =?utf-8?B?L1hFRWl0WVhDdUUvZDZTa0ZsaWNmYWFXUmZqdSt1SVByandkZmMxTGtzdERy?=
 =?utf-8?B?UjFXYVpueGRUQTIxSVJ6VDZpMGRYSjRxVFlKM01WOCtsbVArc2E3VzRnLzcw?=
 =?utf-8?B?K1hFYVkrNU1EaW5LK0hYTy81UWMrT3F4b0xIeWd6NEVkM2dDNWRvQTZKVXlu?=
 =?utf-8?B?MmlUT3hWNnVWVDBlbzArOUVSR2dJVHpIUXkwQXRkWWV1bXppUWZsNCtsSGVR?=
 =?utf-8?B?NWhZMkI2WjI0eHNkdTlBc3RLeHRhSTd3ZkROcS9WRmFxbHNrQm9WNjVyT0hn?=
 =?utf-8?B?c0RKYnA3aXNtOU12TkUxaFRaVWlSNFkzWEI3Z0hiaXJSQWR2aFQ4VnlHM3Js?=
 =?utf-8?B?aUhEY0NQVEE1aWxkTGhxc1o2Z0trNlRqYStrUlZqUUV5NHB4SDNqZ2szd3dp?=
 =?utf-8?B?b2FnTkNyS0xUL2VqVnVXdDhmSTlZc2o2QmpWaElpNjJMZ01kTGdGQVNpc2Nl?=
 =?utf-8?B?WmhJeUZqNWRVVkpteHJudnpmQkVLeXNxc2FMaUFkQndqeGUyRDkyVHdydEtM?=
 =?utf-8?B?MWwrK0lGUkQzazZrRGQwSFI1S1RPbElUQ2RodlJzWHpkamJBMldFdzNRemVy?=
 =?utf-8?B?dFpXQktoNFE1NnhGWW9lclZ2WjF1WGJ6QTJJTmQ3SytQd2k1ZDhoWUVZK2pP?=
 =?utf-8?B?RitZY3g5SndQVkIraFlzTTFkWXpNSGRhbk1kWGZBNGx5eTM1NStBRWU4VU5D?=
 =?utf-8?B?ckRCOTJreXFyU1pQcFBWV1pMYkVsQVIvc3VmaWY0MlJuQVJCVkVqNmFpUGkx?=
 =?utf-8?B?dlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30daa0b8-14f0-4cba-0d64-08db24bcb1b0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 18:48:25.9582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /i4GxaT3UXbP0vcF0kSUtecYL+IUUrL6N+x3wG8CGc620eeGJHn3QzPSdjs2mwteKTUi3AYnTE6IxJ6NdLB2LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6450
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 01:31:38AM +0900, Jaewan Kim wrote:
> On Tue, Mar 14, 2023 at 5:26 AM Michal Kubiak <michal.kubiak@intel.com> wrote:
> >
> > On Mon, Mar 13, 2023 at 07:53:26AM +0000, Jaewan Kim wrote:
> > > PMSR (a.k.a. peer measurement) is generalized measurement between two
> > > devices with Wi-Fi support. And currently FTM (a.k.a. fine time measurement
> > > or flight time measurement) is the one and only measurement.
> > >
> > > Add the necessary functionality to allow mac80211_hwsim to report PMSR
> > > result. The result would come from the wmediumd, where other Wi-Fi
> > > devices' information are kept. mac80211_hwsim only need to deliver the
> > > result to the userspace.
> > >
> > > In detail, add new mac80211_hwsim attributes HWSIM_CMD_REPORT_PMSR, and
> > > HWSIM_ATTR_PMSR_RESULT. When mac80211_hwsim receives the PMSR result with
> > > command HWSIM_CMD_REPORT_PMSR and detail with attribute
> > > HWSIM_ATTR_PMSR_RESULT, received data is parsed to cfg80211_pmsr_result and
> > > resent to the userspace by cfg80211_pmsr_report().
> > >
> > > To help receive the details of PMSR result, hwsim_rate_info_attributes is
> > > added to receive rate_info without complex bitrate calculation. (i.e. send
> > > rate_info without adding inverse of nl80211_put_sta_rate()).
> > >
> > > Signed-off-by: Jaewan Kim <jaewan@google.com>
> > > ---
> > > V7 -> V8: Changed to specify calculated last HWSIM_CMD for resv_start_op
> > >           instead of __HWSIM_CMD_MAX for adding new CMD more explicit.
> > > V7: Initial commit (split from previously large patch)
> > > ---
> > >  drivers/net/wireless/mac80211_hwsim.c | 379 +++++++++++++++++++++++++-
> > >  drivers/net/wireless/mac80211_hwsim.h |  51 +++-
> > >  2 files changed, 420 insertions(+), 10 deletions(-)
> > >
> >
> > General comment: there are many lines exceeding 80 characters (the limit
> > for net).
> > The rest of my comments - inline.
> 
> We can now using 100 columns
> because 80 character limit is deprecated
> 
> Here's previous discussion thread:
> https://patchwork.kernel.org/project/linux-wireless/patch/20230207085400.2232544-2-jaewan@google.com/#25217046

Oh, sorry, so it's my mistake.
I mainly had an experience with ethernet drivers, where we still check
the limit 80 characters.

Thanks,
Michal

> 
> >
> > Thanks,
> > Michal
> >
> > > diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> > > index 8f699dfab77a..d1218c1efba4 100644
> > > --- a/drivers/net/wireless/mac80211_hwsim.c
> > > +++ b/drivers/net/wireless/mac80211_hwsim.c
> > > @@ -752,6 +752,11 @@ struct hwsim_radiotap_ack_hdr {
> > >       __le16 rt_chbitmask;
> > >  } __packed;
> > >
> > > +static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
> > > +{
> > > +     return rhashtable_lookup_fast(&hwsim_radios_rht, addr, hwsim_rht_params);
> > > +}
> > > +
> > >  /* MAC80211_HWSIM netlink family */
> > >  static struct genl_family hwsim_genl_family;
> > >
> > > @@ -765,6 +770,76 @@ static const struct genl_multicast_group hwsim_mcgrps[] = {
> > >
> > >  /* MAC80211_HWSIM netlink policy */
> > >
> > > +static const struct nla_policy
> > > +hwsim_rate_info_policy[HWSIM_RATE_INFO_ATTR_MAX + 1] = {
> > > +     [HWSIM_RATE_INFO_ATTR_FLAGS] = { .type = NLA_U8 },
> > > +     [HWSIM_RATE_INFO_ATTR_MCS] = { .type = NLA_U8 },
> > > +     [HWSIM_RATE_INFO_ATTR_LEGACY] = { .type = NLA_U16 },
> > > +     [HWSIM_RATE_INFO_ATTR_NSS] = { .type = NLA_U8 },
> > > +     [HWSIM_RATE_INFO_ATTR_BW] = { .type = NLA_U8 },
> > > +     [HWSIM_RATE_INFO_ATTR_HE_GI] = { .type = NLA_U8 },
> > > +     [HWSIM_RATE_INFO_ATTR_HE_DCM] = { .type = NLA_U8 },
> > > +     [HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC] = { .type = NLA_U8 },
> > > +     [HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH] = { .type = NLA_U8 },
> > > +     [HWSIM_RATE_INFO_ATTR_EHT_GI] = { .type = NLA_U8 },
> > > +     [HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC] = { .type = NLA_U8 },
> > > +};
> > > +
> > > +static const struct nla_policy
> > > +hwsim_ftm_result_policy[NL80211_PMSR_FTM_RESP_ATTR_MAX + 1] = {
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON] = { .type = NLA_U32 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX] = { .type = NLA_U16 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS] = { .type = NLA_U32 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES] = { .type = NLA_U32 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME] = { .type = NLA_U8 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP] = { .type = NLA_U8 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION] = { .type = NLA_U8 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST] = { .type = NLA_U8 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG] = { .type = NLA_U32 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD] = { .type = NLA_U32 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_TX_RATE] = NLA_POLICY_NESTED(hwsim_rate_info_policy),
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_RX_RATE] = NLA_POLICY_NESTED(hwsim_rate_info_policy),
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG] = { .type = NLA_U64 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE] = { .type = NLA_U64 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD] = { .type = NLA_U64 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG] = { .type = NLA_U64 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE] = { .type = NLA_U64 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD] = { .type = NLA_U64 },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_LCI] = { .type = NLA_STRING },
> > > +     [NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC] = { .type = NLA_STRING },
> > > +};
> > > +
> > > +static const struct nla_policy
> > > +hwsim_pmsr_resp_type_policy[NL80211_PMSR_TYPE_MAX + 1] = {
> > > +     [NL80211_PMSR_TYPE_FTM] = NLA_POLICY_NESTED(hwsim_ftm_result_policy),
> > > +};
> > > +
> > > +static const struct nla_policy
> > > +hwsim_pmsr_resp_policy[NL80211_PMSR_RESP_ATTR_MAX + 1] = {
> > > +     [NL80211_PMSR_RESP_ATTR_STATUS] = { .type = NLA_U32 },
> > > +     [NL80211_PMSR_RESP_ATTR_HOST_TIME] = { .type = NLA_U64 },
> > > +     [NL80211_PMSR_RESP_ATTR_AP_TSF] = { .type = NLA_U64 },
> > > +     [NL80211_PMSR_RESP_ATTR_FINAL] = { .type = NLA_FLAG },
> > > +     [NL80211_PMSR_RESP_ATTR_DATA] = NLA_POLICY_NESTED(hwsim_pmsr_resp_type_policy),
> > > +};
> > > +
> > > +static const struct nla_policy
> > > +hwsim_pmsr_peer_result_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] = {
> > > +     [NL80211_PMSR_PEER_ATTR_ADDR] = NLA_POLICY_ETH_ADDR_COMPAT,
> > > +     [NL80211_PMSR_PEER_ATTR_CHAN] = { .type = NLA_REJECT },
> > > +     [NL80211_PMSR_PEER_ATTR_REQ] = { .type = NLA_REJECT },
> > > +     [NL80211_PMSR_PEER_ATTR_RESP] = NLA_POLICY_NESTED(hwsim_pmsr_resp_policy),
> > > +};
> > > +
> > > +static const struct nla_policy
> > > +hwsim_pmsr_peers_result_policy[NL80211_PMSR_ATTR_MAX + 1] = {
> > > +     [NL80211_PMSR_ATTR_MAX_PEERS] = { .type = NLA_REJECT },
> > > +     [NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_REJECT },
> > > +     [NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_REJECT },
> > > +     [NL80211_PMSR_ATTR_TYPE_CAPA] = { .type = NLA_REJECT },
> > > +     [NL80211_PMSR_ATTR_PEERS] = NLA_POLICY_NESTED_ARRAY(hwsim_pmsr_peer_result_policy),
> > > +};
> > > +
> > >  static const struct nla_policy
> > >  hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] = {
> > >       [NL80211_PMSR_FTM_CAPA_ATTR_ASAP] = { .type = NLA_FLAG },
> > > @@ -822,6 +897,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
> > >       [HWSIM_ATTR_CIPHER_SUPPORT] = { .type = NLA_BINARY },
> > >       [HWSIM_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
> > >       [HWSIM_ATTR_PMSR_SUPPORT] = NLA_POLICY_NESTED(hwsim_pmsr_capa_policy),
> > > +     [HWSIM_ATTR_PMSR_RESULT] = NLA_POLICY_NESTED(hwsim_pmsr_peers_result_policy),
> > >  };
> > >
> > >  #if IS_REACHABLE(CONFIG_VIRTIO)
> > > @@ -3403,6 +3479,292 @@ static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
> > >       mutex_unlock(&data->mutex);
> > >  }
> > >
> > > +static int mac80211_hwsim_parse_rate_info(struct nlattr *rateattr,
> > > +                                       struct rate_info *rate_info,
> > > +                                       struct genl_info *info)
> > > +{
> > > +     struct nlattr *tb[HWSIM_RATE_INFO_ATTR_MAX + 1];
> > > +     int ret;
> > > +
> > > +     ret = nla_parse_nested(tb, HWSIM_RATE_INFO_ATTR_MAX,
> > > +                            rateattr, hwsim_rate_info_policy, info->extack);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     if (tb[HWSIM_RATE_INFO_ATTR_FLAGS])
> > > +             rate_info->flags = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_FLAGS]);
> > > +
> > > +     if (tb[HWSIM_RATE_INFO_ATTR_MCS])
> > > +             rate_info->mcs = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_MCS]);
> > > +
> > > +     if (tb[HWSIM_RATE_INFO_ATTR_LEGACY])
> > > +             rate_info->legacy = nla_get_u16(tb[HWSIM_RATE_INFO_ATTR_LEGACY]);
> > > +
> > > +     if (tb[HWSIM_RATE_INFO_ATTR_NSS])
> > > +             rate_info->nss = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_NSS]);
> > > +
> > > +     if (tb[HWSIM_RATE_INFO_ATTR_BW])
> > > +             rate_info->bw = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_BW]);
> > > +
> > > +     if (tb[HWSIM_RATE_INFO_ATTR_HE_GI])
> > > +             rate_info->he_gi = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_HE_GI]);
> > > +
> > > +     if (tb[HWSIM_RATE_INFO_ATTR_HE_DCM])
> > > +             rate_info->he_dcm = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_HE_DCM]);
> > > +
> > > +     if (tb[HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC])
> > > +             rate_info->he_ru_alloc =
> > > +                     nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC]);
> > > +
> > > +     if (tb[HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH])
> > > +             rate_info->n_bonded_ch = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH]);
> > > +
> > > +     if (tb[HWSIM_RATE_INFO_ATTR_EHT_GI])
> > > +             rate_info->eht_gi = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_EHT_GI]);
> > > +
> > > +     if (tb[HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC])
> > > +             rate_info->eht_ru_alloc = nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC]);
> > > +
> > > +     return 0;
> > > +}
> >
> > Lines in the function above often exceed 80 chars.
> >
> > > +
> > > +static int mac80211_hwsim_parse_ftm_result(struct nlattr *ftm,
> > > +                                        struct cfg80211_pmsr_ftm_result *result,
> > > +                                        struct genl_info *info)
> > > +{
> > > +     struct nlattr *tb[NL80211_PMSR_FTM_RESP_ATTR_MAX + 1];
> > > +     int ret;
> > > +
> > > +     ret = nla_parse_nested(tb, NL80211_PMSR_FTM_RESP_ATTR_MAX,
> > > +                            ftm, hwsim_ftm_result_policy, info->extack);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON])
> > > +             result->failure_reason = nla_get_u32(tb[NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON]);
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX])
> > > +             result->burst_index = nla_get_u16(tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX]);
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS]) {
> > > +             result->num_ftmr_attempts_valid = 1;
> > > +             result->num_ftmr_attempts =
> > > +                     nla_get_u32(tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS]);
> > > +     }
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES]) {
> > > +             result->num_ftmr_successes_valid = 1;
> > > +             result->num_ftmr_successes =
> > > +                     nla_get_u32(tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES]);
> > > +     }
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME])
> > > +             result->busy_retry_time =
> > > +                     nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME]);
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP])
> > > +             result->num_bursts_exp = nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP]);
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION])
> > > +             result->burst_duration = nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION]);
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST])
> > > +             result->ftms_per_burst = nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST]);
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG]) {
> > > +             result->rssi_avg_valid = 1;
> > > +             result->rssi_avg = nla_get_s32(tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG]);
> > > +     }
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD]) {
> > > +             result->rssi_spread_valid = 1;
> > > +             result->rssi_spread =
> > > +                     nla_get_s32(tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD]);
> > > +     }
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_TX_RATE]) {
> > > +             result->tx_rate_valid = 1;
> > > +             ret = mac80211_hwsim_parse_rate_info(tb[NL80211_PMSR_FTM_RESP_ATTR_TX_RATE],
> > > +                                                  &result->tx_rate, info);
> > > +             if (ret)
> > > +                     return ret;
> > > +     }
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RX_RATE]) {
> > > +             result->rx_rate_valid = 1;
> > > +             ret = mac80211_hwsim_parse_rate_info(tb[NL80211_PMSR_FTM_RESP_ATTR_RX_RATE],
> > > +                                                  &result->rx_rate, info);
> > > +             if (ret)
> > > +                     return ret;
> > > +     }
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG]) {
> > > +             result->rtt_avg_valid = 1;
> > > +             result->rtt_avg =
> > > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG]);
> > > +     }
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE]) {
> > > +             result->rtt_variance_valid = 1;
> > > +             result->rtt_variance =
> > > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE]);
> > > +     }
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD]) {
> > > +             result->rtt_spread_valid = 1;
> > > +             result->rtt_spread =
> > > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD]);
> > > +     }
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG]) {
> > > +             result->dist_avg_valid = 1;
> > > +             result->dist_avg =
> > > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG]);
> > > +     }
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE]) {
> > > +             result->dist_variance_valid = 1;
> > > +             result->dist_variance =
> > > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE]);
> > > +     }
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD]) {
> > > +             result->dist_spread_valid = 1;
> > > +             result->dist_spread =
> > > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD]);
> > > +     }
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_LCI]) {
> > > +             result->lci = nla_data(tb[NL80211_PMSR_FTM_RESP_ATTR_LCI]);
> > > +             result->lci_len = nla_len(tb[NL80211_PMSR_FTM_RESP_ATTR_LCI]);
> > > +     }
> > > +
> > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC]) {
> > > +             result->civicloc = nla_data(tb[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC]);
> > > +             result->civicloc_len = nla_len(tb[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC]);
> > > +     }
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static int mac80211_hwsim_parse_pmsr_resp(struct nlattr *resp,
> > > +                                       struct cfg80211_pmsr_result *result,
> > > +                                       struct genl_info *info)
> > > +{
> > > +     struct nlattr *tb[NL80211_PMSR_RESP_ATTR_MAX + 1];
> > > +     struct nlattr *pmsr;
> > > +     int rem;
> > > +     int ret;
> > > +
> > > +     ret = nla_parse_nested(tb, NL80211_PMSR_RESP_ATTR_MAX, resp,
> > > +                            hwsim_pmsr_resp_policy, info->extack);
> >
> > You are assigning the value to "ret" variable but you are never using
> > it. Is the check for "ret" missing?
> >
> > > +
> > > +     if (tb[NL80211_PMSR_RESP_ATTR_STATUS])
> > > +             result->status = nla_get_u32(tb[NL80211_PMSR_RESP_ATTR_STATUS]);
> > > +
> > > +     if (tb[NL80211_PMSR_RESP_ATTR_HOST_TIME])
> > > +             result->host_time = nla_get_u64(tb[NL80211_PMSR_RESP_ATTR_HOST_TIME]);
> > > +
> > > +     if (tb[NL80211_PMSR_RESP_ATTR_AP_TSF]) {
> > > +             result->ap_tsf_valid = 1;
> > > +             result->ap_tsf = nla_get_u64(tb[NL80211_PMSR_RESP_ATTR_AP_TSF]);
> > > +     }
> > > +
> > > +     result->final = !!tb[NL80211_PMSR_RESP_ATTR_FINAL];
> > > +
> > > +     if (tb[NL80211_PMSR_RESP_ATTR_DATA]) {
> >
> > How about using a negative logic in here to decrease indentation?
> > For example:
> >
> >         if (!tb[NL80211_PMSR_RESP_ATTR_DATA])
> >                 return ret;
> >
> > > +             nla_for_each_nested(pmsr, tb[NL80211_PMSR_RESP_ATTR_DATA], rem) {
> > > +                     switch (nla_type(pmsr)) {
> > > +                     case NL80211_PMSR_TYPE_FTM:
> > > +                             result->type = NL80211_PMSR_TYPE_FTM;
> > > +                             ret = mac80211_hwsim_parse_ftm_result(pmsr, &result->ftm, info);
> > > +                             if (ret)
> > > +                                     return ret;
> > > +                             break;
> > > +                     default:
> > > +                             NL_SET_ERR_MSG_ATTR(info->extack, pmsr, "Unknown pmsr resp type");
> > > +                             return -EINVAL;
> > > +                     }
> > > +             }
> > > +     }
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static int mac80211_hwsim_parse_pmsr_result(struct nlattr *peer,
> > > +                                         struct cfg80211_pmsr_result *result,
> > > +                                         struct genl_info *info)
> > > +{
> > > +     struct nlattr *tb[NL80211_PMSR_PEER_ATTR_MAX + 1];
> > > +     int ret;
> > > +
> > > +     if (!peer)
> > > +             return -EINVAL;
> > > +
> > > +     ret = nla_parse_nested(tb, NL80211_PMSR_PEER_ATTR_MAX, peer,
> > > +                            hwsim_pmsr_peer_result_policy, info->extack);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     if (tb[NL80211_PMSR_PEER_ATTR_ADDR])
> > > +             memcpy(result->addr, nla_data(tb[NL80211_PMSR_PEER_ATTR_ADDR]),
> > > +                    ETH_ALEN);
> > > +
> > > +     if (tb[NL80211_PMSR_PEER_ATTR_RESP]) {
> > > +             ret = mac80211_hwsim_parse_pmsr_resp(tb[NL80211_PMSR_PEER_ATTR_RESP], result, info);
> > > +             if (ret)
> > > +                     return ret;
> > > +     }
> > > +
> > > +     return 0;
> > > +};
> > > +
> > > +static int hwsim_pmsr_report_nl(struct sk_buff *msg, struct genl_info *info)
> > > +{
> > > +     struct nlattr *reqattr;
> > > +     const u8 *src;
> > > +     int err, rem;
> > > +     struct nlattr *peers, *peer;
> > > +     struct mac80211_hwsim_data *data;
> >
> > Please use RCT formatting.
> >
> > > +
> > > +     src = nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
> > > +     data = get_hwsim_data_ref_from_addr(src);
> > > +     if (!data)
> > > +             return -EINVAL;
> > > +
> > > +     mutex_lock(&data->mutex);
> > > +     if (!data->pmsr_request) {
> > > +             err = -EINVAL;
> > > +             goto out_err;
> > > +     }
> > > +
> > > +     reqattr = info->attrs[HWSIM_ATTR_PMSR_RESULT];
> > > +     if (!reqattr) {
> > > +             err = -EINVAL;
> > > +             goto out_err;
> > > +     }
> > > +
> > > +     peers = nla_find_nested(reqattr, NL80211_PMSR_ATTR_PEERS);
> > > +     if (!peers) {
> > > +             err = -EINVAL;
> > > +             goto out_err;
> > > +     }
> > > +
> > > +     nla_for_each_nested(peer, peers, rem) {
> > > +             struct cfg80211_pmsr_result result;
> > > +
> > > +             err = mac80211_hwsim_parse_pmsr_result(peer, &result, info);
> > > +             if (err)
> > > +                     goto out_err;
> > > +
> > > +             cfg80211_pmsr_report(data->pmsr_request_wdev,
> > > +                                  data->pmsr_request, &result, GFP_KERNEL);
> > > +     }
> > > +
> > > +     cfg80211_pmsr_complete(data->pmsr_request_wdev, data->pmsr_request, GFP_KERNEL);
> > > +
> > > +out_err:
> >
> > How about renaming this label to "out" or "exit"?
> > The code below is used for error path as well as for a normal path.
> >
> > > +     data->pmsr_request = NULL;
> > > +     data->pmsr_request_wdev = NULL;
> > > +
> > > +     mutex_unlock(&data->mutex);
> > > +     return err;
> > > +}
> > > +
> > >  #define HWSIM_COMMON_OPS                                     \
> > >       .tx = mac80211_hwsim_tx,                                \
> > >       .wake_tx_queue = ieee80211_handle_wake_tx_queue,        \
> > > @@ -5072,13 +5434,6 @@ static void hwsim_mon_setup(struct net_device *dev)
> > >       eth_hw_addr_set(dev, addr);
> > >  }
> > >
> > > -static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
> > > -{
> > > -     return rhashtable_lookup_fast(&hwsim_radios_rht,
> > > -                                   addr,
> > > -                                   hwsim_rht_params);
> > > -}
> > > -
> > >  static void hwsim_register_wmediumd(struct net *net, u32 portid)
> > >  {
> > >       struct mac80211_hwsim_data *data;
> > > @@ -5746,6 +6101,11 @@ static const struct genl_small_ops hwsim_ops[] = {
> > >               .doit = hwsim_get_radio_nl,
> > >               .dumpit = hwsim_dump_radio_nl,
> > >       },
> > > +     {
> > > +             .cmd = HWSIM_CMD_REPORT_PMSR,
> > > +             .validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> > > +             .doit = hwsim_pmsr_report_nl,
> > > +     },
> > >  };
> > >
> > >  static struct genl_family hwsim_genl_family __ro_after_init = {
> > > @@ -5757,7 +6117,7 @@ static struct genl_family hwsim_genl_family __ro_after_init = {
> > >       .module = THIS_MODULE,
> > >       .small_ops = hwsim_ops,
> > >       .n_small_ops = ARRAY_SIZE(hwsim_ops),
> > > -     .resv_start_op = HWSIM_CMD_DEL_MAC_ADDR + 1,
> > > +     .resv_start_op = HWSIM_CMD_REPORT_PMSR + 1, // match with __HWSIM_CMD_MAX
> >
> >
> > >       .mcgrps = hwsim_mcgrps,
> > >       .n_mcgrps = ARRAY_SIZE(hwsim_mcgrps),
> > >  };
> > > @@ -5926,6 +6286,9 @@ static int hwsim_virtio_handle_cmd(struct sk_buff *skb)
> > >       case HWSIM_CMD_TX_INFO_FRAME:
> > >               hwsim_tx_info_frame_received_nl(skb, &info);
> > >               break;
> > > +     case HWSIM_CMD_REPORT_PMSR:
> > > +             hwsim_pmsr_report_nl(skb, &info);
> > > +             break;
> > >       default:
> > >               pr_err_ratelimited("hwsim: invalid cmd: %d\n", gnlh->cmd);
> > >               return -EPROTO;
> > > diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
> > > index 383f3e39c911..92126f02c58f 100644
> > > --- a/drivers/net/wireless/mac80211_hwsim.h
> > > +++ b/drivers/net/wireless/mac80211_hwsim.h
> > > @@ -82,8 +82,8 @@ enum hwsim_tx_control_flags {
> > >   * @HWSIM_CMD_DEL_MAC_ADDR: remove the MAC address again, the attributes
> > >   *   are the same as to @HWSIM_CMD_ADD_MAC_ADDR.
> > >   * @HWSIM_CMD_START_PMSR: request to start peer measurement with the
> > > - *   %HWSIM_ATTR_PMSR_REQUEST.
> > > - * @HWSIM_CMD_ABORT_PMSR: abort previously sent peer measurement
> > > + *   %HWSIM_ATTR_PMSR_REQUEST. Result will be sent back asynchronously
> > > + *   with %HWSIM_CMD_REPORT_PMSR.
> > >   * @__HWSIM_CMD_MAX: enum limit
> > >   */
> > >  enum {
> > > @@ -98,6 +98,7 @@ enum {
> > >       HWSIM_CMD_DEL_MAC_ADDR,
> > >       HWSIM_CMD_START_PMSR,
> > >       HWSIM_CMD_ABORT_PMSR,
> > > +     HWSIM_CMD_REPORT_PMSR,
> > >       __HWSIM_CMD_MAX,
> > >  };
> > >  #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
> > > @@ -151,6 +152,8 @@ enum {
> > >   *   to provide peer measurement capabilities. (nl80211_peer_measurement_attrs)
> > >   * @HWSIM_ATTR_PMSR_REQUEST: nested attribute used with %HWSIM_CMD_START_PMSR
> > >   *   to provide details about peer measurement request (nl80211_peer_measurement_attrs)
> > > + * @HWSIM_ATTR_PMSR_RESULT: nested attributed used with %HWSIM_CMD_REPORT_PMSR
> > > + *   to provide peer measurement result (nl80211_peer_measurement_attrs)
> > >   * @__HWSIM_ATTR_MAX: enum limit
> > >   */
> > >
> > > @@ -184,6 +187,7 @@ enum {
> > >       HWSIM_ATTR_MLO_SUPPORT,
> > >       HWSIM_ATTR_PMSR_SUPPORT,
> > >       HWSIM_ATTR_PMSR_REQUEST,
> > > +     HWSIM_ATTR_PMSR_RESULT,
> > >       __HWSIM_ATTR_MAX,
> > >  };
> > >  #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
> > > @@ -288,4 +292,47 @@ enum {
> > >       HWSIM_VQ_RX,
> > >       HWSIM_NUM_VQS,
> > >  };
> > > +
> > > +/**
> > > + * enum hwsim_rate_info -- bitrate information.
> > > + *
> > > + * Information about a receiving or transmitting bitrate
> > > + * that can be mapped to struct rate_info
> > > + *
> > > + * @HWSIM_RATE_INFO_ATTR_FLAGS: bitflag of flags from &enum rate_info_flags
> > > + * @HWSIM_RATE_INFO_ATTR_MCS: mcs index if struct describes an HT/VHT/HE rate
> > > + * @HWSIM_RATE_INFO_ATTR_LEGACY: bitrate in 100kbit/s for 802.11abg
> > > + * @HWSIM_RATE_INFO_ATTR_NSS: number of streams (VHT & HE only)
> > > + * @HWSIM_RATE_INFO_ATTR_BW: bandwidth (from &enum rate_info_bw)
> > > + * @HWSIM_RATE_INFO_ATTR_HE_GI: HE guard interval (from &enum nl80211_he_gi)
> > > + * @HWSIM_RATE_INFO_ATTR_HE_DCM: HE DCM value
> > > + * @HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC:  HE RU allocation (from &enum nl80211_he_ru_alloc,
> > > + *   only valid if bw is %RATE_INFO_BW_HE_RU)
> > > + * @HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH: In case of EDMG the number of bonded channels (1-4)
> > > + * @HWSIM_RATE_INFO_ATTR_EHT_GI: EHT guard interval (from &enum nl80211_eht_gi)
> > > + * @HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC: EHT RU allocation (from &enum nl80211_eht_ru_alloc,
> > > + *   only valid if bw is %RATE_INFO_BW_EHT_RU)
> > > + * @NUM_HWSIM_RATE_INFO_ATTRS: internal
> > > + * @HWSIM_RATE_INFO_ATTR_MAX: highest attribute number
> > > + */
> > > +enum hwsim_rate_info_attributes {
> > > +     __HWSIM_RATE_INFO_ATTR_INVALID,
> > > +
> > > +     HWSIM_RATE_INFO_ATTR_FLAGS,
> > > +     HWSIM_RATE_INFO_ATTR_MCS,
> > > +     HWSIM_RATE_INFO_ATTR_LEGACY,
> > > +     HWSIM_RATE_INFO_ATTR_NSS,
> > > +     HWSIM_RATE_INFO_ATTR_BW,
> > > +     HWSIM_RATE_INFO_ATTR_HE_GI,
> > > +     HWSIM_RATE_INFO_ATTR_HE_DCM,
> > > +     HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC,
> > > +     HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH,
> > > +     HWSIM_RATE_INFO_ATTR_EHT_GI,
> > > +     HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC,
> > > +
> > > +     /* keep last */
> > > +     NUM_HWSIM_RATE_INFO_ATTRS,
> > > +     HWSIM_RATE_INFO_ATTR_MAX = NUM_HWSIM_RATE_INFO_ATTRS - 1
> > > +};
> > > +
> > >  #endif /* __MAC80211_HWSIM_H */
> > > --
> > > 2.40.0.rc1.284.g88254d51c5-goog
> > >
> 
> Many Thanks,
> 
> -- 
> Jaewan Kim (김재완) | Software Engineer in Google Korea |
> jaewan@google.com | +82-10-2781-5078
