Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDE03C7940
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 23:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbhGMVzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 17:55:18 -0400
Received: from mga17.intel.com ([192.55.52.151]:27951 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234947AbhGMVzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 17:55:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="190625079"
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="190625079"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 14:52:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="427415586"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jul 2021 14:52:24 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 14:52:23 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 14:52:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 13 Jul 2021 14:52:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 13 Jul 2021 14:52:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQamHI2NLDyoOLFDchXEo1lrZ/TyhS5NX5lXhf+6Bt1HBOTRmIRj+yS2Vornr/U7crmUkngieyaSGUwyPcW4+O9EwjOLOpCqGpcQ96DxZpiwUA8lQESKHzKN2m16j/szl4KtRl1nfNOeyiO6pkxGLGJ1pN0jA1697UrcV7nex0d9SY8ZTAxfuMfhhCpbJ6lDDb/s3Zyo4PRS4geGHGrZVhdFZvEpNcu09k4L7oHAMsosVp2wRf+Vw/CKpvANUyJLP2q+81gMGnMUeDxA9f0T1uC000XhFK0S2JT4UVGNPspFDxigaD9WpiX+sD37Vp2pVJa3C+/idyz9ZqotrMmz3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Fen3VnFoJ9OWZZ48ubHThjSpa7EfwzLWCdWFPYII/E=;
 b=iv5msIJdQ9+6pP11eYdPouY5Z52mwMT4GIJ3SmpzbkSWEP1+BY91Tx8VG4GrXfC9TTy7IhrCKwv6lkoml2ajIVKnc0QB2NzJtDwBKozSLKoPelYodLUVTUa+ONqqTtTqC7BzRbsVI1TckAB4CZm9BVi1nR+9y4kbUbPkltm3EY8sPhD4rhaBojUbAc9GESNfBILz7Z3lLkVCsa9M2I1BEDXNM2BrEA4sNlKz/MotBELc2MvI8wzhrzdm5bZ248GnrjWSIgSdd56UPe/3De6Qgbh0xcfWaBkmaG+5wltK8XYLnyBKbbqINMBtsPRGVrChdWv+/wUQ7+YYWa1qvfwKhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Fen3VnFoJ9OWZZ48ubHThjSpa7EfwzLWCdWFPYII/E=;
 b=qHCeZNm/qoQhUm7G8ulcf+ZEzduUD0eYu/uka/F6E6ezLmwVO7DehhNfnKEgLKxH0abX2j2DKiF629gLHRQwJYgCnH6PDOJttlAiETiBmQ5aqU/pohQpEilc/Mot7cpfXB0mZGk8/sbxKfekiIPCASSqBTe/IXIHdZo5L/4QYXw=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MW3PR11MB4713.namprd11.prod.outlook.com (2603:10b6:303:2f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 13 Jul
 2021 21:51:40 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::7405:432c:f34a:b909]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::7405:432c:f34a:b909%6]) with mapi id 15.20.4331.021; Tue, 13 Jul 2021
 21:51:40 +0000
Subject: Re: [PATCH v3 02/14] iavf: Use irq_update_affinity_hint
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
 <20210713211502.464259-3-nitesh@redhat.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
Message-ID: <163cd830-e249-9b7f-c2b3-30b04693ec95@intel.com>
Date:   Tue, 13 Jul 2021 14:51:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713211502.464259-3-nitesh@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: MW4PR04CA0083.namprd04.prod.outlook.com
 (2603:10b6:303:6b::28) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.214] (50.39.107.76) by MW4PR04CA0083.namprd04.prod.outlook.com (2603:10b6:303:6b::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 21:51:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3241195-7be3-4d91-1a6e-08d946486568
X-MS-TrafficTypeDiagnostic: MW3PR11MB4713:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR11MB4713416FA472594F9BCB90C397149@MW3PR11MB4713.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y9iJjHpBDs/vbvMawxC/Mk/+Epm+r3l7vTsrpy+ywdIF0/UkQvkM1VbrddlUNfOTOEIeIbmBQZEt70zTRZ2GNKhIVh0gXZxdrOijHjcWIXGgOROTr9JZ0J/tTpYBfAtYYk1o6+e4pOwv+NnzbuUGDbHjuVxbddqipdvH91qLlWFPhaKSNqj8L2k81fpRWgRXVJx313fMNaKmh0zWco8fSNM3kIXU9ZWOJm3OXjQPRXy4eqKuN/yJSy7ZwSQ2NDoyWWhCmRewHzzP9BAWc7f1jNUSsNtkOaNmG/GySHNLUPGPR6G0V6M/ifP/JtxBFdrw5f8VknmHgkC1su1b+0JAp2ZXt0osHnAJmytHpENZR01WqPClM8lDI1o7I8Fl348FtltYR9ce4swhnRqBp0v9g0XG7cM8lzYJpw2Z1fCkjc48bF/1Etcg5b5/h3t/dQfo5SneqQaOBWX91VK3TCVOMCuji/E/xv+h+cteAICtildjBAvaf11BnI2K5xzLqVfQcC/uG15W0RXBps2+n/2yTSlAkcyhr+2o9B8Hpw5sMUqxsM5JNSbNtE5Nkaq9xp6u672ISE+nQ38MiGdeKaducfBL0GHZOzsWLikKsLzSS1p/wbE8rpY353pBUdLN1dzykOTuAFiWrOlyoSFFrhT8DsNNbiUBeoQvn11MSJuVFtFuYDKbzhX8Mi1cnUpyVuudF++pg6U2yoeRwl3ZQz0cMTuXbl5r/K7ROislKPM0HyL8WYPOEftpEx8Igb4jwB4EHDdN1+FdIYI0NOnJGHr8eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(83380400001)(66946007)(66476007)(7416002)(7406005)(7366002)(2616005)(478600001)(956004)(66556008)(36756003)(316002)(16576012)(44832011)(5660300002)(86362001)(2906002)(31686004)(6486002)(186003)(26005)(8936002)(1191002)(921005)(31696002)(38100700002)(8676002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkJOaG9MQTlodldSWVpxaGFtMmpOSGwwaWcyY2UzSlp1aW8xTFVrb1dxdzMw?=
 =?utf-8?B?ZVlzUlJCMjhkRWw5K0VsL3ptY2tmaWZub0JybUZWMUlrNjhPOFIzcW9XbW5l?=
 =?utf-8?B?T1hPUnJaKzc1Qm5wMXAycU4waFZHb05TQnAycTZMeE9yWFFHd29UODVJY2c4?=
 =?utf-8?B?dndEQmQyWm1JUWQ2elZxcStqcTh1dkJUSEMvSXphKzBoTHpJVE9UeTl4SWg2?=
 =?utf-8?B?SlhiSXJVUFh1d2pjb0pybWQzcVN1QWxVT0czTEFyUnJWWkRIRU1iUFFLZldE?=
 =?utf-8?B?YWc0ZGNPRUwvRnVnY09HZVZGanlLbmxSdVNPelNWMHEwZHlTaDdyZE9Ca1Y3?=
 =?utf-8?B?TjZrRHZYWVN4Z3k4RjI0eGovS0ZRMDZHRDk0K1hEaG1NN0FvdXNPbWxmdE9y?=
 =?utf-8?B?bTY4Y1ZCN3RRUnM2MTBuQ3Qrb1dhMGVhdXFCYjhFT2FJM2owNlRWTE5wQU9m?=
 =?utf-8?B?THM3OVdkYURaRUsxdzBGcXowak1rZ3lmaHU0ZnNKTVV4aDRUTFpsbG1yVFZr?=
 =?utf-8?B?UlpBV3Y2KzFMdFhPTzVnS2xrNGViQVhFTEdnQ0swSE9ERjg1MnZpMUNOM1dr?=
 =?utf-8?B?QUwxaUNScmtiekpEY1MzVmwxSElTTHdZNVJ3TzN4bVdQN1J4Y0ppbE5vZ0Rq?=
 =?utf-8?B?WXplVEVmaUpMOHZkTkFvUjVrM01McEVxdnVleENtd3dhcWR3LzdJWEcxVjgz?=
 =?utf-8?B?L3FsV1VLcklCU2VBc2VUYzVDSGZxaElIWVJRUXR1NERYVHFvZWwyNVZjU2hw?=
 =?utf-8?B?QU1KbDhYSEQ4akdKRGE1Qm5iYnl2czhvck5mU1U3VUoyUkR4eUlMRUYrMk5T?=
 =?utf-8?B?QXlaZGJPaXdTQkh4N1hhY0FuZnhWZkYvUTNEb0JxWndwbmdsa0w3OWVuV0JY?=
 =?utf-8?B?VU5VeEtmT3o4NHNLYU9kbkpudUg4cmJELzI4a0x3QVhUd3FqUjBHQlRIOFdB?=
 =?utf-8?B?MFZjeGNNQXcybHVNd3diUHlWNkV1UjFVbWtFRTZaT3FzQmZCVHE1d3JPNmNo?=
 =?utf-8?B?OVlDdGJHc1p1ZTZ5eS9yd1AzN1kwWW1ieU9Ba2hnL0NZMFZXWlcvRElNcit5?=
 =?utf-8?B?OFJCbkFrZFhaYjBaNzBZaXJ0NXBVcFBCc3JFeGdKemhoaFRpSERyUGozNTJp?=
 =?utf-8?B?eWJZamtDdHVDUmkxUTQ1NXZmS2NzNDdPT3ZnNXBPS0pwYTB1a2VRdDdWQytB?=
 =?utf-8?B?TU9LajJXSUVndlgydlNCa1Y3eDNTYmJvdlFaSkZoSTVnaG1odGVpLzlWQ0Vv?=
 =?utf-8?B?d1BIZGdZNHl4a29ia2xhWEJ3cHZHMXN3NlhHTy9QOTF2aWk1QjN2SnpibjZL?=
 =?utf-8?B?NWc3RVdkWi9uanFGdFhvbDk2V2s1eXgwdWd2Y3MvWEE1K0wwZnBCcS8yenFk?=
 =?utf-8?B?eEFta3NFVGU2aTZnQU5DK0l3c0Y2eXQzdmNsZVNUTGNLa3Urb3RCcGJIMDRN?=
 =?utf-8?B?Z0lpUUUyc0k3Y2Q2UlJ2dGIvUjBwSVRUTWljeVluQStCRjlPMnV2d0QyL2l1?=
 =?utf-8?B?bCtRd1pvdWNudjBRQ0ozR3R4amlPemF4VEllbVIxU3VxWXB4NGJWSVdJQmQ1?=
 =?utf-8?B?ZFRtV0pnL0dIWFNoUkZiS1lrQ21HaU11MzVTMkF2NDhITW9WZXA2WjgzbEJh?=
 =?utf-8?B?NDBHQkxKNW5qRmNoZm4vcStIQ0VNSzVCWGhqdXMyQk1DbnJGcmk4TjJnMjJP?=
 =?utf-8?B?VGd2N2dYcWNSNTJXZnBWY1oxVytoTmc1N3hneTJmb2JCVEhNb2s4RmZNR2Ir?=
 =?utf-8?Q?D9NeZ8C+Iv+rmIBZjOu6xamqaHuDTiSBrzR4G63?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b3241195-7be3-4d91-1a6e-08d946486568
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 21:51:40.6320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kZPlHf/9/bMx5ldKYBW29qVB3ugrEiypJ5x2gXcDXhqk4GNK2GAL3MGHjl4oLTkY+L2b4q58SL2AyCY1kJ3gr3Li/OqeO1ivj7xzK8VBgBg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4713
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/2021 2:14 PM, Nitesh Narayan Lal wrote:
> The driver uses irq_set_affinity_hint() for two purposes:
>
> - To set the affinity_hint which is consumed by the userspace for
>    distributing the interrupts
>
> - To apply an affinity that it provides for the iavf interrupts
>
> The latter is done to ensure that all the interrupts are evenly spread
> across all available CPUs. However, since commit a0c9259dc4e1 ("irq/matrix:
> Spread interrupts on allocation") the spreading of interrupts is
> dynamically performed at the time of allocation. Hence, there is no need
> for the drivers to enforce their own affinity for the spreading of
> interrupts.
>
> Also, irq_set_affinity_hint() applying the provided cpumask as an affinity
> for the interrupt is an undocumented side effect. To remove this side
> effect irq_set_affinity_hint() has been marked as deprecated and new
> interfaces have been introduced. Hence, replace the irq_set_affinity_hint()
> with the new interface irq_update_affinity_hint() that only sets the
> pointer for the affinity_hint.
>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>

Thanks for this!

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


