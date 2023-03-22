Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5F26C53E3
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCVSkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCVSkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:40:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AB2509A2
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679510450; x=1711046450;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=B8xRNI+F8qsnzjzU4KFlVNZqe0I6PAdRzbWEfgiFe5Y=;
  b=gYlGUAV50SWFN4mYYXTsQvAfT5iDBc07GNCL9RA79S+zm/W1cDB4PGn2
   UVU1Qvs+MZhnxpGTh0sFTw1x05XR9S9bCXi9teGo4J9femw4SAl5gQUoF
   OfMPBxsK+46uf3XrLAbGWpctpw8wjAd3sz1KNk9/2X+Kpxf8jBpynfySN
   laAsR8Rf7WmtiDGjxqnod7PhYvnyVlZteoCXC4Sfx+El/ZYZjse3NMO8I
   3wWj+aqz4P33VVkPA11XZi96YExX6/dtV1Bx96AaScVYPBXT5W85JJo5n
   0LLCRoH5/B4SPK2F5g6BF80sHxkJeEoB0mV0zANr6MN789MdWxe0k435q
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="367041574"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="367041574"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 11:40:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="746434552"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="746434552"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 22 Mar 2023 11:40:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 11:40:50 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 11:40:49 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 11:40:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xt7rwjdX4IowRBwLOxCHqki4vb1RxmNIBMAWTv6K5gTBeXxXj2iezP2At1kfSTg+ZMG76Lzmo1+3WigmPqqv1IukZm5KPxYA24m7/5Pbh1vEqOMfNG0kHixkIJYN4PsHiai1tFkd66aXVg2EjSOzdo9SvOk9714wAyl827wFlR3+TYsPQpbX5iR1kIi7He0ubtsUpvbJZdwcgD5N0Zvk/11nlxlugsE38Fn912iZCIUwr/ZgNob4RYi8L2mFiJTCZsxK7m8Ks7toq+MlEXvsvHyfxw0kYkfHiUPfaflgPhaoZ9pw+6oRyyioqgoromS19yKnJWR4aefSPtNO1hs+5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/xXDFafmwBg/fVl6aTS8Lhfm6Awlp8Ge7Y7DEo0A1g=;
 b=WPPb/sDdqht/Nl9Ae0zgxVm5I/cbEccPUe3RXhUlbF240XQu8NvGbtoVmiN4ZlH7dAVCM5rL9ExV+ifKThbdlNzbwefpWfyng09heLSMAVNtJlucPgrzrZY7bQWbtdFtJGmlh22iSsqncM/bsSe8OlZrFk8TAYU/vNbgV9LulnHn8SHvrJw+zyDnAKAKig+EQZ8JuiY20kZTD29YUdsYdbBupY/WnwtfYZeQOZoFBFuQMz+5pNawho/BFBMmoP8xJAcffhdAlSL4ypA1jTpBB+u3ctg5xRJhZ+/T/BxfAPUeapH6P+tNG8/tdXqfRk6rC9K6b4k7I7iqMk6znM53zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by MN2PR11MB4759.namprd11.prod.outlook.com (2603:10b6:208:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 18:40:42 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 18:40:42 +0000
Date:   Wed, 22 Mar 2023 19:40:41 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <michal.swiatkowski@intel.com>, <shiraz.saleem@intel.com>,
        <sridhar.samudrala@intel.com>, <jesse.brandeburg@intel.com>,
        <aleksander.lobakin@intel.com>, <lukasz.czapnik@intel.com>
Subject: Re: [PATCH net-next v2 0/8] ice: support dynamic interrupt allocation
Message-ID: <ZBtLqdU8aCKxaHDr@nimitz>
References: <20230322162530.3317238-1-piotr.raczynski@intel.com>
 <ec5c3cf4-49b6-32fc-d7cb-06410d6497da@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ec5c3cf4-49b6-32fc-d7cb-06410d6497da@intel.com>
X-ClientProxiedBy: FR3P281CA0160.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::15) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|MN2PR11MB4759:EE_
X-MS-Office365-Filtering-Correlation-Id: 795c1393-a47d-422e-8673-08db2b04f0b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8dtPPDr4Hs73VK/di/VGr1xVE2wEB76B6rESVHbxHIRDXD98I0gsolfS37juQ4rVvjjOXO0ZGo6bPmh3COlQQIONTkl3tmfnp2RP29d37h/0yB1jNxbcTa6/1lUpOyO4nRLF5ce4+IW6k6sAoZRy8uVZYAaBYme/jMOjgHTkDJRR1e6Y2Zse0H0Buk8GrDNwNsYtTvBj9nRH3/3ASiWvOA+JzIYURZicob3N0E/ZI+ki8fyhJzGt36F0EdXyKJ76aPwXA6SWR1xkNRXdrpngjkDmzPEm83HVJRG0wBLNCewbjyoP9SfVjRb2dxkQ6jbYOnSKSOystm+B7FojNlIUmC41cwdAuNmx+goA74xa3oEkeOkLtcMkplK0SjpL6SZmCyOD01urgyna8DH1019VbU4qZxALbxr8PKqAQGXk9iPKP1XhEpLeObDtr3TWOlONJGew6enwbLjFvJ8R5en4E6SRfBKtCRW5spwU3tUV6+Yi26qvGFR+yt7ESlNMMYZYva8Pe4QlkXvZqDvSV/+iobiEtsCNZLg3dQMWJ11EdD3sOBl9/cRaxej1nmGloQk8SotdV2T1XqjfKFHV95qqf5+sZh7EBldWdMXxt38iGPTl046Dt9niO4u9x4aU20ie7WSbNDLWCcICnLKu8N1O/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(39860400002)(396003)(136003)(346002)(366004)(451199018)(38100700002)(6636002)(33716001)(66946007)(8676002)(66476007)(44832011)(316002)(6862004)(4326008)(66556008)(8936002)(41300700001)(5660300002)(2906002)(83380400001)(478600001)(86362001)(9686003)(82960400001)(107886003)(6506007)(186003)(26005)(53546011)(6512007)(66899018)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H3NnKqt1UxUaNHqjTvtjUPEbyRRuPglyTz/l/EVrsoX7ldL93AQScwfVq59c?=
 =?us-ascii?Q?Wj3RRvgYU9S2BN8dr6LoRWHsU29k2YfMhcY9PQV6gom13bzhFt1Hy40PC+Vb?=
 =?us-ascii?Q?wmB4/mNauDNeZBY07uzWOT13CeHlCUxbjOVzrue9OkR3B/nUvgZVq4SEIzHu?=
 =?us-ascii?Q?7Iwxbov1cRmQXD0TX10Qe6FPQcpi1viL/9ZW6komFLaM5YuTcbMRQH0fea2g?=
 =?us-ascii?Q?9GrNgoNY9PttpS4d17D/zRjsV2cCaUhZfG+ft37YNn9fdi9RDgDo3lcQFs4u?=
 =?us-ascii?Q?svDSEvspoYpfRx86o71U+8tFWcWiweL30VLAXvOCSHhLIrL0r1dW2BrhEUC8?=
 =?us-ascii?Q?VjkitHUYOj7VAwzwLsf3yLNrFfkPfUYocSpu8RKRBNaQJJHJfzK0byKMekv0?=
 =?us-ascii?Q?KevpI5xmJsxN3YdH2EN+GSggIxGZptQ/N965fP31CL37cMYz4QXtAhabNqRB?=
 =?us-ascii?Q?Tz2XfldZBojRkS9QxHi5z/vqK2DK6pnfgHfU+kbud5BCSiNvMoV7j9Vr10mS?=
 =?us-ascii?Q?olf5BPudc4aG1Ee2DOWxvxP7SMkJjzcMAoQoET4qIus6zvt6RR8AjEjvKLJb?=
 =?us-ascii?Q?oODIieUC1cyPLCHBy0LrIS2h5HBv5ZEgkZr+d8g/OHOn+EmkLXGSbvirhjSI?=
 =?us-ascii?Q?k1SyvZZVSOxtsdZd4yDLPF9mJpV98Oih/4h1OlKLl3W9SMrtANIVdELj1SYE?=
 =?us-ascii?Q?n2crXZZLun+DnzHpTgd0xvOvnOsJcnB6pgexxhjwzIPmlxpV4yBT7R5jfU1m?=
 =?us-ascii?Q?qcKBvG5PlOWsrMwprbiB5czrcRVWSBcJhW/UqkbKH4tPhhzRl+Nv5pv8P5r1?=
 =?us-ascii?Q?N2evnXIbIokuZru4SMXPbMJgr5EYyaB2LY7jhIutekIVdPqECv7hbiwWt7uN?=
 =?us-ascii?Q?lBBMz1s/Ld4Wk/6K9IrDu7Kai5GeHTC2qbAhOjLiF77bag9TJW+/ySSH2duA?=
 =?us-ascii?Q?AYS1Ohq1ASlGqXVgMnHQFtBFCIc+beXXGBTLy6vBMYvzJXR61Y/CS8Mg2UKK?=
 =?us-ascii?Q?L3AmhJYLMwQ7vpLEIStGKqsKNtwTDyUl9XIqolp5vqwdoqmimf7G6lBgT/ST?=
 =?us-ascii?Q?e2ciEVEO4WQ4Nhe+XF0XqB+JQn64bMAT4S2WX685kgn/b9baUhzJYxrka/H9?=
 =?us-ascii?Q?yb9S3rfl8o5V0ZxsWXWNdoLWfMjEJa/gC3IQKgj4j/kAu1VkURlZdxFK48Nc?=
 =?us-ascii?Q?macbwDmQzr+dX4kWjzS/VZo+9Yfpe4SB5nBNwKHBWzb+oP64x4ZccJdFpHHB?=
 =?us-ascii?Q?Vk4ir+QLiJOxTNqCs2RukvW5PNnKhEW3TSnhUU16BhQxfm52nOei7R1sQx46?=
 =?us-ascii?Q?gyV1pqYj9qSNNRcXnVECxZhpI8fJP7Rmm0jfo/8CzWJXr8SVu/JG32LfJkjc?=
 =?us-ascii?Q?x9Mgb2MMWMIVv/oE8ToC964wwYQoqJmXcdNEYzRnxP6XUhK7LKG3U6hiMl2d?=
 =?us-ascii?Q?G4XwLj4vXE0TQFv7wg1J9JmpTm6gbIt2BVEQY9G56bwYnq6ojSWWYI1drKRK?=
 =?us-ascii?Q?E6j3oHH4kaaGs/kLBjgUvUcqPs7VGOuxdd7MStJtiz0LytLtUo0USpMX9k1u?=
 =?us-ascii?Q?b0vo8OtjH5pmBruzMdjh+aLkPJu9MFUcXGX0VRjPGkYagkhqei+mSuxkC6ah?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 795c1393-a47d-422e-8673-08db2b04f0b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 18:40:42.3027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C4ZA/+n1ZoeZ8NE276bxzurp1GimeEyx20tsYJKJk7BoG1dcZ9tS8tEi+fo4jgq2Qav9z0RaN+MyNZB/P2TzkbA1bcjSfxaTpQKLlfeHDHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4759
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 10:33:31AM -0700, Jacob Keller wrote:
> 
> 
> On 3/22/2023 9:25 AM, Piotr Raczynski wrote:
> > This patchset reimplements MSIX interrupt allocation logic to allow dynamic
> > interrupt allocation after MSIX has been initially enabled. This allows
> > current and future features to allocate and free interrupts as needed and
> > will help to drastically decrease number of initially preallocated
> > interrupts (even down to the API hard limit of 1). Although this patchset
> > does not change behavior in terms of actual number of allocated interrupts
> > during probe, it will be subject to change.
> > 
> > First few patches prepares to introduce dynamic allocation by moving
> > interrupt allocation code to separate file and update allocation API used
> > in the driver to the currently preferred one.
> > 
> > Due to the current contract between ice and irdma driver which is directly
> > accessing msix entries allocated by ice driver, even after moving away from
> > older pci_enable_msix_range function, still keep msix_entries array for
> > irdma use.
> > 
> > Next patches refactors and removes redundant code from SRIOV related logic
> > as it also make it easier to move away from static allocation scheme.
> > 
> > Last patches actually enables dynamic allocation of MSIX interrupts. First,
> > introduce functions to allocate and free interrupts individually. This sets
> > ground for the rest of the changes even if that patch still allocates the
> > interrupts from the preallocated pool. Since this patch starts to keep
> > interrupt details in ice_q_vector structure we can get rid of functions
> > that calculates base vector number and register offset for the interrupt
> > as it is equal to the interrupt index. Only keep separate register offset
> > functions for the VF VSIs.
> > 
> > Next, replace homegrown interrupt tracker with much simpler xarray based
> > approach. As new API always allocate interrupts one by one, also track
> > interrupts in the same manner.
> > 
> > Lastly, extend the interrupt tracker to deal both with preallocated and
> > dynamically allocated vectors and use pci_msix_alloc_irq_at and
> > pci_msix_free_irq functions. Since not all architecture supports dynamic
> > allocation, check it before trying to allocate a new interrupt.
> > 
> > As previously mentioned, this patchset does not change number of initially
> > allocated interrupts during init phase but now it can and will likely be
> > changed.
> > 
> > Patch 1-3 -> move code around and use newer API
> > Patch 4-5 -> refactor and remove redundant SRIOV code
> > Patch 6   -> allocate every interrupt individually
> > Patch 7   -> replace homegrown interrupt tracker with xarray
> > Patch 8   -> allow dynamic interrupt allocation
> > 
> > Change history:
> > v1 -> v2:
> > - ice: refactor VF control VSI interrupt handling
> >   - move ice_get_vf_ctrl_vsi to ice_lib.c (ice_vf_lib.c depends on
> >     CONFIG_PCI_IOV)
> > 
> 
> The other option would have been to make ice_vf_lib.h have a no-op
> function that always returned NULL, since we generally would know that
> there are no VF ctrl VSI if CONFIG_PCI_IOV is disabled.
> 
> But I'm ok with it being in ice_lib.c too.
> 
> Thanks,
> Jake

Thanks, that makes more sense, a little bit too hasty here.
