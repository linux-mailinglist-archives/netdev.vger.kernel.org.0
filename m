Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACF43C7946
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 23:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbhGMVzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 17:55:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:1947 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236198AbhGMVzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 17:55:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="197520230"
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="197520230"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 14:52:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="503493681"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 13 Jul 2021 14:52:25 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 13 Jul 2021 14:52:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 13 Jul 2021 14:52:25 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 13 Jul 2021 14:52:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kW6WdoL6amr8KiHFAfpu//48EMJ5rYYgEDChj9aUb2Xy5LuPPNVgtHV745vI243wy/zQas0gugCD4eKzAAsjh8yo/VAY3xVi1wztPGVoUjyhzTlN2KSnNuTXYFM2G/XHFWw7nhdR7TFYs8rd1XoytO+lx6Xu74xCfqWrxWjgQPdSxiw4M3NVUjcJflEBbcn0ascLZidcQzEDTMjgsll4Z467COz2LMVNAZzTwk5cVGog1FcFt/MH+tkjErcWzDV+2dlFEk9UlBNpVup/C1rnNc1d+g7KKhxYUwNQLO5nDXy84WrqskgyQ/SM+QbLqGxzBAuJQJcnRbQl8i7Gwy210g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khvmwoXl3kb8xRpLao0eDNvBcNiyqzyUIe1TVxCMzmU=;
 b=MPJzNZNV+gTkHeSegSRYiykGV/T8LR7WZ5fXwR0aWfiMCeX/yONzv3Fd/sBvGSryw9d5gNYM/kmiNGRzUFTN75zk1p+pjWE/lW4ATcT71yP02/2ZURCoh+XyXqANgWAB9jkHykcOqMozmlK8voHX+wLKwMWiOJojlSkxRIIB7ocesooIOxFNzLlyLXDU+Tbs6+c88f/htC6O/A2+79ChNfSomOAaBnHZSIlcAB0PWziNccIeAudG1hmylE8ORjc83qbmpsx4xUSdhzOsQgcpM5g9sY5/POK3uyQQc60F6x1dDT43U8EXv5p5P0iqhm0Ri5ByzqaVI+2istWyOINiMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khvmwoXl3kb8xRpLao0eDNvBcNiyqzyUIe1TVxCMzmU=;
 b=y513PrRMaB42BokVnMlDTmgjyO1tOnm3rww9KXyIvJjKM/94Dc7v5vGWLNKLx4jG0RJ+LGlSaEnCbVIwh+0CK2HQ/FvBmBNBdnEb0myHAlieA97LGHnD8zR8qaEg1l4nRw1dPRgj6udtEAaPgj8Bu9TUxBgGJHtQdi3EXgyQi74=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MWHPR11MB1440.namprd11.prod.outlook.com (2603:10b6:301:7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Tue, 13 Jul
 2021 21:52:13 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::7405:432c:f34a:b909]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::7405:432c:f34a:b909%6]) with mapi id 15.20.4331.021; Tue, 13 Jul 2021
 21:52:13 +0000
Subject: Re: [PATCH v3 03/14] i40e: Use irq_update_affinity_hint
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
 <20210713211502.464259-4-nitesh@redhat.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
Message-ID: <4eca6f2d-c5d2-1f1d-ffc4-4d8f7bbed68e@intel.com>
Date:   Tue, 13 Jul 2021 14:52:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713211502.464259-4-nitesh@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: MW4PR04CA0068.namprd04.prod.outlook.com
 (2603:10b6:303:6b::13) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.214] (50.39.107.76) by MW4PR04CA0068.namprd04.prod.outlook.com (2603:10b6:303:6b::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 13 Jul 2021 21:52:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd2fe0ca-8d46-4f6a-2b96-08d9464878cb
X-MS-TrafficTypeDiagnostic: MWHPR11MB1440:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1440DE17CF70E8BC6A7AE82997149@MWHPR11MB1440.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sI4eFJWqapZIUXTZj94uebz5ESYqHU1vDFjTncbF0B4ub8Hu1LQG8b2gsqiPtuJGSUBgKG0Kr5PwiItKlnk4BMFkmkXL5JL0M31DCk7MEEeervVdUSIUrj8xp+RVUwrbyDR2I4OG4GLmZnb7mzDFTz7VmeY2wVGrZ0MlVHPrM3hyLaFju/EAGrGzpuMuUNXVKTlenznIKy/lxSjMqtzyH2BMsy0LW9oLp6ea3K+xHG/JIHet1X44/en2cAaM96v5ORl74FxfGjhZQIXQOn1Nr9ON3EItJL5tQQhxdfkbz19UtLoLFePqDrbuZ4KvvDsYBUqTl43mNxggV9/n7t2Oc3ikDzf8jkylO0KQGLP2qxVeMJIgxgyrtR7McMVZ4cQ4JPlLmFjqm8ZdVsZM+MHexcKXRKRXmgTPj9Vz5rFKwiSq7+vIq0AHuvDr/Jo6xUJ4l+vJjBK30bR73zcIxsekju7chLo8aj1LMChgFmUNT4e4NfBKsShWXnBhheuusHcLXv9dO0Co5JU4QOjFYtLUPQAAL7A8pfm5rEcCthkJY5duCGa2W9DHYnekXPse1aN+KIKSw8fZmRAtYNIekGkS13EZ80fWOVzxiTi3eGUw8OFMuQg6ztFYcTZRsC4LyB4e6MXMWOWdFZQ8prtsr7Vfti9FsOBJib4Jo9reoPjrdabDOk/draSvToPHrKFAHozDUllUpb3YxOH2LwH9wPErb5YRV3mxBz6Ru8bJvQ8rAGhLyhP+wM8eGDeJE8Qb+4AE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(66556008)(7366002)(38100700002)(66476007)(921005)(66946007)(6486002)(7416002)(186003)(7406005)(5660300002)(36756003)(31686004)(83380400001)(8676002)(53546011)(2906002)(2616005)(31696002)(1191002)(86362001)(956004)(478600001)(316002)(44832011)(8936002)(16576012)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnlXU3NCR0hCQnlDOTNBK3ltNG9yZ3hqa3J5bDU1VXpzQWcwdXpvRksza1Fm?=
 =?utf-8?B?Qm9mTDd5MU1MbU1qRWcva25JUjhGS2xSVjNyckNRWUFqU0swYkYxYXBYLzla?=
 =?utf-8?B?aDB6cFlraC9TQnFNZjdvWmJvbWZBK3h5T0Z6QkRSVlRvMHh1UVdSNWJWL2pm?=
 =?utf-8?B?Q1NiaGZiY0NObDlUTyswQzl2T3o5UmxETWxOODZHSDFOR3V1VGVWSDdkcjVL?=
 =?utf-8?B?Wm53cy9KY2szaEpRVnJvTXVoZkhWMXp6bTVERDIwelovTFZhTklHZXZqZytO?=
 =?utf-8?B?NklWbklYT3hXSWNlN1NiT09WT1E5dTBUOGxhUmFDbU9WVlhWUmpwaklSVkRv?=
 =?utf-8?B?dTM2OFlPQ05SVzBmMFlSZlU0Sk9DaEVlbVI5WGdvTCtoTXc0K0ZxblFxbmU5?=
 =?utf-8?B?eFFTdmFqbVVEblcrUUV1dU5VSnBXVlRuSjdTVTJjR29leHprOXgxVFNnaXVO?=
 =?utf-8?B?cjQ1RGp3N1hiUEdWbnlEdUJDVS9CblRmL2FxUWo4OFA2R0FTVllMdiswcm0y?=
 =?utf-8?B?YXpETlFNT0VHaGwyZ0IramZNUWdmbFNscUJtblZza0N2R1N1dElzZ0I4UHI4?=
 =?utf-8?B?TXNUZDRBenh5YmY4cmJsNFphVFJ0aVhlNjJPb0ZWZGhFeU4yeGJPL0hOci9L?=
 =?utf-8?B?RlhKRHhxZ3Z6VlJzMXVjT3M0OHBIUjlUcWp1R1hsNGl4Sk9iZmxXZUl3VUU0?=
 =?utf-8?B?T1BqeFRNbWhKYWN5UlFDaUI3NlRCYXFxc1NNbmtaUTIwTER4MXJSOTdOY2lD?=
 =?utf-8?B?YTBOdkFia2YxV0dReGNBYW9xRCs4Q09haFFtUFdDakpraFMxTlNYWHhOa1I2?=
 =?utf-8?B?N2tkTlBtU1NpUmhtenpKTzNUOXk0MTRrSVJ5R3VJUWQ0N0xDeUhTZ2NERzFE?=
 =?utf-8?B?ckFtTUs1Y1dkSFhReUV4WVNVdEdXT08rRkVJS2tKOFlESkhzTGJnWHNydTNo?=
 =?utf-8?B?MzJwMlJyZ3FUTUN4WUlSYXRsYWMyVWlYZUpCcXFvMzdoSForUlVkZTlyQVpY?=
 =?utf-8?B?ZEpmNlJLazF1RGxuOGlDK0IybXNIYVROS3loTWc5SXIwcUNTVmlSWFJQRVN1?=
 =?utf-8?B?a1hFazVIRUtkR3plTHpVSUs3QnkvcE8rbUcrRkNBR1UrMkphYWdjazJRWWpi?=
 =?utf-8?B?VXhwVlVNWlRWd3docmZrbkxIcTVGV2x4M2RoMEdjWk5XWWVreUFOczNjMEZV?=
 =?utf-8?B?QzEvOFZrREFpaHo2MDFlTGp0d0tNaTNxbGdLTE03dWtVTmVadWswd2FydzFJ?=
 =?utf-8?B?VzhIWUkxRC8zaitYSi82UGFHcUJ4OUwrVUtWQWxjMUk1VjhMdXFYeENnTDN4?=
 =?utf-8?B?Nmg3bWJ1aFdGTkg1UVpPWGlwWStCaG1tMXpKZE8xQ1Rmbk56TkdZU2w2cnBR?=
 =?utf-8?B?WEN3U1FKVGV5bVdha1ZkcTVuaHpPSEdxYlJhVFdieGlPK25mWDZmcTdNZFNp?=
 =?utf-8?B?c0dSdG1YV012d2lXdlVVZXFLNnFkbUxLQUVqOUMvY3grc3dHRCtKZXBLQmcx?=
 =?utf-8?B?OXU1WDh2VVBxK0w5UVRxR1N4V2dWUXhDbCtFd2JxUzhGWVBaYS9acG85cnF6?=
 =?utf-8?B?aUJVT3REbU9YcHU2YThqazY4Y2x0dk9PSDMxYkM2QlYzdlVsQkxPWkhaL0JQ?=
 =?utf-8?B?N1U3N1JtTGFWdmlzNGhISG9GYjRZM2hESndvc3hHcU5rTHVhYzJ5bWtKRHBX?=
 =?utf-8?B?VWpGb1pzaVBnb0Y3UlpOUWxOc09rUk9DamRoTlp4Sk4zNFREV3JvZzhhWEJz?=
 =?utf-8?Q?LpHeFLAlAFZwJPWVfXFLNGmpS+gYYhUtGSZwEHp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bd2fe0ca-8d46-4f6a-2b96-08d9464878cb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 21:52:13.1639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lex77Xam8INV81m57U11jdPjPSafi7nI/GA7lC8pEUmVSephQeHTJWf0QUg82m3mTZcmU7lAxX3uzpCXvOIU+vxskr1/NHHcakOTrch5jgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1440
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
> - To apply an affinity that it provides for the i40e interrupts
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
Thanks!

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


