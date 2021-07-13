Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3523C795A
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 00:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbhGMWFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 18:05:03 -0400
Received: from mga07.intel.com ([134.134.136.100]:18912 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234947AbhGMWFB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 18:05:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="274079443"
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="274079443"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 15:02:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="412595706"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga006.jf.intel.com with ESMTP; 13 Jul 2021 15:02:09 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 13 Jul 2021 15:02:08 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 13 Jul 2021 15:02:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 13 Jul 2021 15:02:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CM4vU8dJpica1ZLAq0dH/HeVbacDW7K/BO8Bw53S7INQdfnmIsJw/85ic0bbb56UdAw/WeHfstQ3+sVx7CRo/IZHfphfVD05RFH5MYsTSXtHKgPZTxLgkC7CE5olX8vMIwnwCfjEqHVw7e7qZO1Z7Zz/lj3v2tkRsEoJxyp6HNjPH6xqfYjNyVB0xcHgsjoWPO8ee5QI21CzDcmq00i9wbTuMyYFDjavimGJ+iO3mDIwiaIppxo/9SrJfWOXDQ99AIF3RAMTBK8GwykjKVRoePQZdbthtziS5A6wLF/xekdepdSOyhcjcRcKjHICU9KZR/rFhvQzL1TUAd9WeGUorA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PjNPwK95MTLTm0xFMblbMGH1EHzBgz6QjCV7erSFfo=;
 b=X/vLEEOVpTNLZBm/X/yEXmo3s7TDS2bRbbwSUGPy9E+NSqsUp5KDARPEDw9UsqJWZ8caIH8rRtqPzmQ7UolQDvrRAGJtElomuGTjPPvr/rPTsrfOjF/XZlX2bc1Jqdg9ozZDaQvOhlc7ggkrMOjKh69WagE2qOfp0Ax7QigXpKWajKc3x9xfsZrgFi4dO52Lj3fjp0CtKIDzAKgM1QHYxnRCxMMwPfr6rivlZpdzplJolrtaf5Q3jaSnkTSR1sb9b4at8CJ2+bCkgSd4ZEfYsK9qOScKGKK+RGKbCZuVtHarbBAjYvlYOg9gkb6dDKcqsWPl/mOMCU1EUqWZmp2kug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PjNPwK95MTLTm0xFMblbMGH1EHzBgz6QjCV7erSFfo=;
 b=Nl0zEBuT+I05DzYfQwCfopPOtC8neBFHJ9++SM4+D8AEzPL6DohEIE1qkfiC4KdU3BvrmMd/688PrmWackTlWU4VsRSGN0Y1JnF67zQtNzWT5RXw8TCCYv9jfhH8ioO65EH/BSfdA5emk4TILKUSx6sUVWIR71iBqob6mGFKxik=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MWHPR11MB1440.namprd11.prod.outlook.com (2603:10b6:301:7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Tue, 13 Jul
 2021 22:01:56 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::7405:432c:f34a:b909]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::7405:432c:f34a:b909%6]) with mapi id 15.20.4331.021; Tue, 13 Jul 2021
 22:01:56 +0000
Subject: Re: [PATCH v3 09/14] ixgbe: Use irq_update_affinity_hint
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-api@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <tglx@linutronix.de>, <robin.murphy@arm.com>,
        <mtosatti@redhat.com>, <mingo@kernel.org>, <jbrandeb@kernel.org>,
        <frederic@kernel.org>, <juri.lelli@redhat.com>,
        <abelits@marvell.com>, <bhelgaas@google.com>,
        <rostedt@goodmis.org>, <peterz@infradead.org>,
        <davem@davemloft.net>, <akpm@linux-foundation.org>,
        <sfr@canb.auug.org.au>, <stephen@networkplumber.org>,
        <rppt@linux.vnet.ibm.com>, <chris.friesen@windriver.com>,
        <maz@kernel.org>, <nhorman@tuxdriver.com>,
        <pjwaskiewicz@gmail.com>, <sassmann@redhat.com>,
        <thenzl@redhat.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <sathya.prakash@broadcom.com>, <sreekanth.reddy@broadcom.com>,
        <suganath-prabu.subramani@broadcom.com>,
        <james.smart@broadcom.com>, <dick.kennedy@broadcom.com>,
        <jkc@redhat.com>, <faisal.latif@intel.com>,
        <shiraz.saleem@intel.com>, <tariqt@nvidia.com>,
        <ahleihel@redhat.com>, <kheib@redhat.com>, <borisp@nvidia.com>,
        <saeedm@nvidia.com>, <benve@cisco.com>, <govind@gmx.com>,
        <jassisinghbrar@gmail.com>, <ajit.khaparde@broadcom.com>,
        <sriharsha.basavapatna@broadcom.com>, <somnath.kotur@broadcom.com>,
        <nilal@redhat.com>, <tatyana.e.nikolova@intel.com>,
        <mustafa.ismail@intel.com>, <ahs3@redhat.com>, <leonro@nvidia.com>,
        <chandrakanth.patil@broadcom.com>
References: <20210713211502.464259-1-nitesh@redhat.com>
 <20210713211502.464259-10-nitesh@redhat.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
Message-ID: <1f083139-4faf-126d-b14c-29d228474d6b@intel.com>
Date:   Tue, 13 Jul 2021 15:01:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713211502.464259-10-nitesh@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: MW4PR04CA0252.namprd04.prod.outlook.com
 (2603:10b6:303:88::17) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.214] (50.39.107.76) by MW4PR04CA0252.namprd04.prod.outlook.com (2603:10b6:303:88::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 22:01:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5b59858-1b7f-4052-55a0-08d94649d43d
X-MS-TrafficTypeDiagnostic: MWHPR11MB1440:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1440497EE6398B17F15DDE5197149@MWHPR11MB1440.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S4svR+oPCZ8P3L13e0Y79hj5o/J/DUBNolFJoF3ltbSjuJYlJdaso5h1C5FCljXYtZRHUbe9IyciIP5el7YauNagoFUTaC5lmVW2bRm9vBej/df9RpoekYYC7pRECfDcxRpn8p5bQ1otoKhcdx5VN54LqwIW/Ysxl9mqtmQSAG+g7OEkruewNJDvEQv4mBYVnIyJHkb392F7t86L81oWtsD92XBDIxWDLgslhqN3hkWXKekHyF+Hg5IcWkwBXzsdFFGF8TGS5VzhI+dDJcsll8nQbxeYFw5a22HCQ14slxWL4k6klBlFn/ppxW5PfJEq0K11Msx5vUYYrfNoE2F0BiOFXSfTEHoPo1jSc0d66BL8YA9ddxrx35ygz0lJSqMxdBG3Hi2jSJdx7Av5p8B4ZS65ts4e3DN1Zo9KXpz6s1ADE/+ZJjRMewp/dTPjRovRHVRM8J3rdJhKuyFrT9IIgezYyAXi0Q9X5zP9yRjGqopdcW3y8ykOeRf1pSSxFitxMN5sAEeSfeHgHN1QzMTl897JBcoBm6atKOHAYBWoQqZa8LqGWNEzpPNyivGGzm42ehfQxXIezF8CqKDmRO0m1aYVaI0Ldig3dgEjHIu1ydg6MmesmkwUnIjGxVF4rQjXQNNd78O7uwDFl+V1qKKAg36M6WE4Fi9NWpk1E51r2yRP7QY/59rYIO3QO+ZPhwRrwb5KcB4QfGC5nIJVcgXmxQwv9MZQHejjqAqGHZlaeXkeJfOVDEMarkO2G/hZsrr/fJB4E9o6zyrp6vFiY+9RmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39860400002)(346002)(396003)(4744005)(31696002)(1191002)(86362001)(2906002)(8676002)(53546011)(2616005)(478600001)(316002)(44832011)(8936002)(26005)(16576012)(956004)(6486002)(7416002)(186003)(66946007)(7406005)(66556008)(7366002)(66476007)(38100700002)(921005)(5660300002)(36756003)(31686004)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDZ4VkFsc0dIemxkdEphWjJVdGZYRnA5blVKQlB0TWR5K3BEUjZMVDBPdmoy?=
 =?utf-8?B?Q1R1ZGlxZG1lVUdJRTEzQTBxZ0dqZXFDSlpXRTljbkE2ZytnWEFoT0t0MHpG?=
 =?utf-8?B?WWhPRy9CaURzL0pSUGZHU2pmdU1mMWpsUW9uRnluZ1liaTE5OTVsK2N2aHdo?=
 =?utf-8?B?UlFkNnc0R3NFbmNlVjZSWnFGUEV6dXVZblpncDVmdnlXOEhWN2Z0T0tNMGxt?=
 =?utf-8?B?aE1XOGhReGVoSzcwYmRPc3Q4QmJMOStGK2l2YUw1ZTcyQTZaZUQ0bllCWXNq?=
 =?utf-8?B?K3ByRUd1c2NDSkMxWVY1SlJlY0hlVXlMK0tZS2NUOXRSSWxTUEFuamVxMHVZ?=
 =?utf-8?B?VkhZNXpobkx2d256NVBpM212czhsdHpZTXpWbEs1OGx1R2xDc1U2RFFLZTAw?=
 =?utf-8?B?dFM2Sk1meWJ4dE1TclNuMGowbzRqd0FqbE1zZElGM0JuS25SWDRwRnI5Nnhl?=
 =?utf-8?B?RUtxUk5CVmxxdk4xZDdObmZIbDgrT0lJcXVsUk9CUG1XWGVFR1hBcXNkaG1q?=
 =?utf-8?B?dCtaSVdObGFTZDcrVk5UclBLS0QycGRpUDBmSVZ3eFdYbXQwU2pHQ28zOFJs?=
 =?utf-8?B?VC9WVXZVM1hjeUdMVmdpa2lSblZqbXpXMEc2YmxNS0FWSTdzK0F2SzhpTDVK?=
 =?utf-8?B?WGo4cEZiY0RXMmRWdW9RQU5tQnRPanQ1U2hidkFsbU56a3F0QnFCV0tVN09u?=
 =?utf-8?B?V2l6SnV6NWtIeFNuZThmSGtCVzB2cTNudVVYc2JFTTBTQ3NXamRoYjZ3UnQv?=
 =?utf-8?B?RjRWUncrTGt0aWFzV0gzTUdKTldUTDIxM09IQ0ZkazIrNktCN0tFbXVOWWU3?=
 =?utf-8?B?Z01vdFpJWTBodklETll2WHVaMXZRNXhobTNveTkvRjh2N3doNkpqRHovMkJh?=
 =?utf-8?B?VEw4dmVsK2E3bzUramtmQUQ3c3hwOHZxaGRxc0N4d0dCNEdPOEltNmgzMXpz?=
 =?utf-8?B?Nlp2NE1tSnBVR0o5SDVUd0tDemxTcUU2RG02YmNVRHQvWjdRV0Y3akFkVUhZ?=
 =?utf-8?B?SnRRQ3hmanNTT3NjUWx2U2ZoMVU4TGNIaEdPT0JZVHZCQ1dzMnA3V1lmdXZN?=
 =?utf-8?B?UmpwRFJsTG5lUFVGaFZvVlBnN3kwcWFHWnhaNkZaRXFycE1XRnN2Qy8yamlZ?=
 =?utf-8?B?MjdmUzY5dGYyS1NGT1ZPRExWVktobWxjc1lwdjRuYlNJS1V3MHprNHY5R3NK?=
 =?utf-8?B?T3lPOTNNU1VaQjJ6cHdkd0szUjVlaUpuVUNaMHNmVlBKbXZEUDd6N2syc3or?=
 =?utf-8?B?b2hFd3hWQnhZMW9xelAvcEcvRU96dTM1NjdiZWJubG95aHNsb3hKVzZYUXFx?=
 =?utf-8?B?SUkwUnNRZlNMYUE4TkFHQlB2UmZ1YkN4ZHkyUCtDaHIzYTVyUk1selNvOWJC?=
 =?utf-8?B?aXZTMjgwV2RCWFlrbGYwdlVFbFNRVDVPYXNZYWRiekdiNUVtTWxuaDhQbzVH?=
 =?utf-8?B?MDJDK3BwUmt6cWdkcG9iaS9pdnlObFdIUUJBZ21OS0U0Rm5helpXdlFYN1hx?=
 =?utf-8?B?V2V1MVhjVVVEdjJmNFQ2eThnVytMdmg4U3Nmc09MNGRmT2V6M1BEOVJpaVB3?=
 =?utf-8?B?dWthVERXSkhMT2FQZEU3N3YzV0lXeERFeEtLUmx1Q00zV3c3ZXpDS2J6R1c0?=
 =?utf-8?B?dWY4OXJvUHhzNExMd0p1NThWbFNuS0lLZEhFODRFcWt3eUVXb3BmUTdwa2Vh?=
 =?utf-8?B?UmZOTHkyRmpHdVVuSmYvNUVDa1Z3SUVYYnlSRjBRRVFmNDNvYm5Bd2ovMHJI?=
 =?utf-8?Q?16UFDxbE1JJbYIiPM7drc2GoHRwJIjna0wAUyvJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b59858-1b7f-4052-55a0-08d94649d43d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 22:01:55.9013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTUx1Za1q6kwYKjmCUBrjrhdTiDKcDwKZtAhJWkXEBVlsUyL0xRkyK4t8J9I+zYo395GUTqqRE2wpq1r+iiql45FdGEUCh3KZqljdCDpMfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1440
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/2021 2:14 PM, Nitesh Narayan Lal wrote:
> The driver uses irq_set_affinity_hint() to update the affinity_hint mask
> that is consumed by the userspace to distribute the interrupts. However,
> under the hood irq_set_affinity_hint() also applies the provided cpumask
> (if not NULL) as the affinity for the given interrupt which is an
> undocumented side effect.
>
> To remove this side effect irq_set_affinity_hint() has been marked
> as deprecated and new interfaces have been introduced. Hence, replace the
> irq_set_affinity_hint() with the new interface irq_update_affinity_hint()
> that only updates the affinity_hint pointer.
>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>

Thanks!

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


