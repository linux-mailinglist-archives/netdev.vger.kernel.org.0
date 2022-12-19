Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02D365114A
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 18:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiLSRiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 12:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiLSRiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 12:38:15 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67857DFC7
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 09:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671471494; x=1703007494;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QUxKQeRhqsNe5/6gqnNRy0e7uVXwVz60KejzatHW2js=;
  b=Fjvmlsif6d4fkeCQtKFqRJm546L2Cq6tx6V0rhUWwGRSjJLxkWzsBsqG
   5+1+MxylpS4T9S5RgQE7XGCdTMEuwbbndMaMFFLHeXUzlzuXQSsQaPjHG
   7AWwcLSG7D3uU/mFq0aWVwJxS/EbPy6D4tPhYJX2PGf0AJDEoUDYyq5eM
   5cJ2O/F1jnFYZPliDXabGt9JIBHykXHjiVpdgd/1JsXH2ggVWBv7Konz+
   7GVLK3r9tVmgzDpDTQGknD3E8mh1MQYnziLBcDS5Zumfbhqx+ix2f59t/
   S2braMkBr7UyAtxyQjFDqrtIE4cU3KaG0bx+kzaD0LhAXaZuhkbKcnwvc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="346504611"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="346504611"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 09:38:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="896106956"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="896106956"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 19 Dec 2022 09:38:13 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 09:38:13 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 09:38:13 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 09:38:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMxEt4p/+QrIvpPGM4k4FDJuZrJUXYQ1rv+4dedhKXx04FcSqX52lhFZN/kujqX/8/OmmgxzhUPDrEUKMI+jAcSnLommP0xwvhU0W9jZnB/TGehwv5arWQ1GjqgPxNtzT+h7ZCWGfkE6mAKBiF0X6w9ZCX57YN+7MJcpjvpS1/jCOhM+u/2d5qvaC/47E75o3FRLIX2xtUvolyDTvBN3POhVqDS6vKTRGA645nwv4vzE7YRteOm2jvQAdlagtqVYOtwU5lAPIIhfBVdiNaOJDYFx42R20odkuZMBWC0pXjA+NW4M0sLS155F32UpU99SFiG5/lLlb0Vz8Ifj62XLhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6e/quuPpaSXQx3pYY9aP7o97MJDHar32WdEuUIYKK3s=;
 b=UmwlXRygfigx3yfy3hYrKEf3nxV28b57O1u6EpQ6Js9Wj9PHVs82HwUuIu7xHvGJmRFEzZGmo4hvW9sTgE1Beg8B+QXrSdlvHccpKC5f5rmn8DtdKsRhHiuDN1egjNGXAb+huW8eOWdtpPRxAuIFD36g1/ILSlNwKkL7awOtkepfdMzEhbic08jqKic6Wn1d/zAzjRq7zoCfhT7LpHPj4En86SD99OmJ24WjX+hcGU1o7KqIwvnWzlfffwqtG3hnYnE46GeWgw8yM00pQ87uEruLGGkkI5KDtGG1BxPMgyJ9RsyUe98LD44Nw/7sh8DqI31qTMByHzbA2nnch/QpYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SN7PR11MB7592.namprd11.prod.outlook.com (2603:10b6:806:343::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 17:38:11 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 17:38:11 +0000
Message-ID: <3d169051-e095-6a2a-d5d8-409a5ad8af4b@intel.com>
Date:   Mon, 19 Dec 2022 09:38:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 00/10] devlink: remove the wait-for-references on
 unregister
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <jiri@resnulli.us>,
        <leon@kernel.org>
CC:     <netdev@vger.kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221217011953.152487-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0103.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::44) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SN7PR11MB7592:EE_
X-MS-Office365-Filtering-Correlation-Id: 55fce36c-547a-4de6-0a78-08dae1e7ccc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NrwyEZXZt7tJEXW1io5Hll/3qiQhynaAvMcObN8eZ+4jbe+tR++sWxbyzXo4KMI0n0bZ8pncc40r2DD5V9sLLZkWnyCeAboVttwm7qSJmoizi2I4PFM3IIMnpEoGdr9Q/NTdTWUWWpL2YJ7v3bmXyLu0FUB0tJeEMmCeDtzhaWKXZHlagxoz4tTHMoJVYuw7RggtusqW3XS+TRpNFLZpFONPeCTePWJoHVcAUjOnaqFfr/+rSPm1edLweS++Vn6LWEGwoITiS5CKgqfLeRA0qDyTJASg371PqhtVXi59oXK0BX25dNwcFVsbXIzROsLAEHqDTAzKbqMFHlh1NruW47RPlS7GHCpDdEGZZWfbl3Mn1T7EK9RBoGiT2+Yxnlh0zHcUBr4FMhR1trdwcq2dMkwNjMk6W2cxRp0wK7LyESmZz5Aqfv32QBMs+Rm+piBe+DWJu5MRFBqzMoRfJHsU67tayy+bi+nTQM3nbu5FeMUGubRWQa7Lxxd7YW2Li73Cx8/h9ZBlMtwK36mvq6yVT7ywu4ruRWKSJ8H+Vrd5N1M1jWIlnayu0ox/aiMFMejmaGRcnk8g0r1NPRer/XKg0aq4G+HbexQUvN8HrD/nVgRmxSDbJaKK/UFB8CMva1iGViJMimuKDO/y0MXaR6NogR/2qgD56GgygqDBM8HsdGW0l+s+Chqw8Qh2TNtSb7tgmhar+fPphsrsWPkNCgW85QSxrD4uM1ABf0H9jnttZ6c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(346002)(396003)(366004)(451199015)(316002)(4326008)(31686004)(5660300002)(8676002)(86362001)(26005)(6512007)(186003)(31696002)(82960400001)(2616005)(66476007)(66946007)(66556008)(478600001)(6506007)(6486002)(8936002)(53546011)(38100700002)(83380400001)(36756003)(41300700001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkJ4cUF4RDFtWk5JREI0NTdNdUNXRHlPbjRVNW1NbVd3bUZodVdTZ1lCZWNS?=
 =?utf-8?B?WVUxWnJaZk52aUhKaDVMSFRPVTFKeTM1MU12cmZnMzZNL20yMWdsTklmVkZZ?=
 =?utf-8?B?QUcrZGZyc3kvKzJNNk5UOWgyTVhmbUNTVU9xLzFYc1RBL05HNGVrRVJzY1Zm?=
 =?utf-8?B?SjYzRGVJMzBZdnFOcDdQRCswOVAxN1JKMllDbjBycGlkcStDZzdtTkw1eUo5?=
 =?utf-8?B?QWdOaktlUXk4TklNcVhSNGZNclora0Qva2xBbllVUlJHaFVWUVZ1MDFLR09a?=
 =?utf-8?B?RzhYUDNoOVZMU3kvUWRrQUFQTHhpMFBESndMdDE0aG9oc2hwdE1iQUw2bldu?=
 =?utf-8?B?WGErVzIrbm1hRnNlaWl5bFBHaWxBVWQ2c2ZwVzJoMTludERSUEJmSDBNeTZu?=
 =?utf-8?B?NWVVakRqL0tyL1pRNmRsSEs2T0RZZm0xSnJNMzFWOFp2Mit5M2VpalpHbGcr?=
 =?utf-8?B?OCtCTC8vc1NxNTVISjlrZnhyQk1MOUl1TVpzdVRuZkFzS3NrVGRoQkg2dHVx?=
 =?utf-8?B?bTNpNkVCakJiZi9heUR1OCs2ajJOUkU1bGMvN1BEcGFzU2FFbmw0SDd3N2J0?=
 =?utf-8?B?cUdZOTdjcjR5MlNjcDQyN2dOTWpDQ01ubGFBVFkyd3dFcWg5RGZhMUVCeWFR?=
 =?utf-8?B?SnI0LzdyTDkwSXhlbTh4WFgvS081K2QvUkJZblZLR0lHSkRoaWhpWTJidXNN?=
 =?utf-8?B?NFhqOTFYbkQxWEhoTm5VdGJyTVllSUFtcFkyOEljVHp5VU1ocGFTRHdLMXhl?=
 =?utf-8?B?SnZUU2lpWGJQUU9lcTJoM1BYVHY1SUt1NDBYOHpZekNuQXhEYkErUjFKakUw?=
 =?utf-8?B?N3hLa0hpd0FQWWo1d2cxejhFSmdtaUNFVkJNODFJclUreG0wbWRNWHJ3WGJF?=
 =?utf-8?B?cmdOWTF0YnlMVDRUamdpWURvUWFCTUdIZkVoaGUxckNCdjRGOXNYZmc0aGxE?=
 =?utf-8?B?QUNyWXpzcWVDS2R2b2tTSSsvMXltZ1RMWUYyY2F6ZnUyU0Zlb1dwSGdzQzY4?=
 =?utf-8?B?d3QwQ20rTEdtbzdLUklza3NiQTFyeFpwMnBMVFFQL1p3V1N0RXgzNzVzZWQ4?=
 =?utf-8?B?ZTRHajFIdVlZOUsvZEt0bm5mT2k4UTZzbGY1V0ZiV3UzUXJ4a2Z5ZHhlLzlS?=
 =?utf-8?B?dExZOWgzcGh1SHVqRS9NMmpGVTF5LzhrOUoxSjFyRzh5UTZkMjg2VVlEQ3Bp?=
 =?utf-8?B?WjlsL2Iyc2x3WC8yTm42aWwxM1FscUx3dEJRU1dWODBsbCs4TU83YmlVcHFX?=
 =?utf-8?B?Q0RQdEFRMzE1Sko1QWlJYjRXb25lL1Y1MmM2STl0RlhoWEc5S2NRR2JJSERw?=
 =?utf-8?B?UlRYRk1Pc3F5cERVRmQxMlRrNktMMTc2QU9wWXdtYjBPTW1jdGExYmpOWDNh?=
 =?utf-8?B?dEFtNnQwWk1zV3prN2Z4MWdWSVBwQVAzS0tKUXI0bVRqeit5SEF3V1VhYTc1?=
 =?utf-8?B?a2poelJkZ3RPWXZ1MGlGTGxMbjNPRCtNWXd3QzV5MDl4MFBpT3ZEbCtMKzIx?=
 =?utf-8?B?WFQ3YkNialdjbVcxZVdCcVdvZTB6bzBJMlVTa0RKb0hNZWl4MDZId3ZTYVRG?=
 =?utf-8?B?Q3JkTVF4ODY2bkRwUXJIOU05bngvamFjbHNYendlbWVmS1VScmkwMnlzR2xN?=
 =?utf-8?B?SlhZdjdnZk5wY1VHd0RrdU1kVG5vaEJ0VFVOVFhhQWoyTGl0Z1FaU2xMY09n?=
 =?utf-8?B?eVR4d0FuQVp1cEVFUStHWWwwNFUxZ1ZSc0s4NWk2UklIUHo1RHBoeHdRWElw?=
 =?utf-8?B?V1FTeTRzVEdwaytMZlMvWm1zWFIrN2wrMnRaYzQ4UDRBSHJxWGVzQnllWE9E?=
 =?utf-8?B?cXErdUJreDNQVlRiYm81dXJ4TVN5UkVIL0VqazhUQkNoZk5zOU82aFJ6a3lp?=
 =?utf-8?B?YWxveUxVN3drYUdnM2ptT2ludHN2ZUEzbUtrVjNrc3BXRURPNVh0cEdJNTJL?=
 =?utf-8?B?S29QN2JGRGwwUzhwZ0FmRTBBRllldm1kaWpacG91S25HTFN2Z1YvRkRLZ1dF?=
 =?utf-8?B?VlM1b1RocFRzZU1PZC96S3Bua0pZVG1QSHZmdmZlVkF1Z3ovbDd3OVZ4eTVE?=
 =?utf-8?B?bE1pT1IrVTBDMTdaTktsMXBZbDZ3R2lwbXdIM2EwSnFiOFRLdDBlT1loR3Zu?=
 =?utf-8?B?dllUN2xGL0ovWituZVhxbHhwYTcvZC9rcjdCcmQ5YXk2VnJ6Q09MWUdzeDVZ?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55fce36c-547a-4de6-0a78-08dae1e7ccc1
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 17:38:11.6821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G4jkuWnXu3gBkxsj5TB4oeNl9/VWsSwggZ7xi66JIKReHk9IzyEPFw6J8hpap6HlfaN+WBG5LHSMj69Ugy0oLvGksh3ksvEPp/x6X7uoTpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7592
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2022 5:19 PM, Jakub Kicinski wrote:
> This set is on top of the previous RFC.
> 
> Move the registration and unregistration of the devlink instances
> under their instance locks. Don't perform the netdev-style wait
> for all references when unregistering the instance.
> 

Could you explain the reasoning/benefits here? I'm sure some of this is
explained in each commit message as well but it would help to understand
the overall series.

> Jakub Kicinski (10):
>   devlink: bump the instance index directly when iterating
>   devlink: update the code in netns move to latest helpers
>   devlink: protect devlink->dev by the instance lock
>   devlink: always check if the devlink instance is registered
>   devlink: remove the registration guarantee of references
>   devlink: don't require setting features before registration
>   netdevsim: rename a label
>   netdevsim: move devlink registration under the instance lock
>   devlink: allow registering parameters after the instance
>   netdevsim: register devlink instance before sub-objects
> 
>  drivers/net/netdevsim/dev.c |  15 +++--
>  include/net/devlink.h       |   3 +
>  net/devlink/basic.c         |  64 ++++++++++++------
>  net/devlink/core.c          | 127 +++++++++++++++++-------------------
>  net/devlink/devl_internal.h |  20 ++----
>  net/devlink/netlink.c       |  19 ++++--
>  6 files changed, 136 insertions(+), 112 deletions(-)
> 
