Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3515941E036
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 19:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352718AbhI3RdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 13:33:17 -0400
Received: from mga17.intel.com ([192.55.52.151]:3567 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352680AbhI3RdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 13:33:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="205396861"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="205396861"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 10:31:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="520501064"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga008.fm.intel.com with ESMTP; 30 Sep 2021 10:31:22 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 10:31:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 30 Sep 2021 10:31:19 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 30 Sep 2021 10:31:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UB4F+LhHSYtuSU8AmeU/DrHLqIOUSPQlHNNYNdmaEcKXRCUqQcZxGREe6Ki9AAZQm1GjIUQLMDnkASxnqbzAqMHPVTvh6+xVPV+sj7v+2oiw4RRJPHDqBR0FkIhfdyd14UM3k18SgTbm/lbTn6KFrhmV2LHi9EmEW0yVAaaxpfw4n2JUn6Nyb/tjwtB5G+LU5bHVyk2xwi3S606yd13i3+XRZj/GrU8ZwjnnqEeYrQvIpMlBEHyNJakke9IGI9ghvpXy5DhA6qj5+K/gf0lXYC+HBaNBlH9vSQ3z3ehK3cvLssviAvNJPqVkjBzzNY0HpKizAhzRhUcaluIdjWQ2eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=M1I78EFo83McoIerMCLjD1CdtbOdJJHQY0xHm/bZKQU=;
 b=aXk9xDtzuYHyZiLbGvT5kuUrBCsShln0hiia71Q+DF377F3g3N1xMTp825MXuxBD0a5DpsS/PfR+l2Li3VpMbEP/b+eYc9j9wddCuBM9i50kV9zwvC30TkrnJ028QgEHghChkocWkpBmWcosn0VBJHeLGjhtVSUdlxaNFO6FjCgUKbUbvquOoCN/Qj4NOlzgSLMBaTfJOM6yO1Ars06fiB0seEGIDCEEet3KcNsRH2bAMZePLU+wdwjKw2z4PaV2C/9uFewSF9Q+pu9Vu0PcDMjbFUbWT0Z8HaFJKhgc6123y+PVu4s2dEuQHKeCcx/82KZGVMem6MahhQDC68taIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1I78EFo83McoIerMCLjD1CdtbOdJJHQY0xHm/bZKQU=;
 b=VliQRfuR6cgms46Fwq3JKC2Zm8zZQizL+GNlYP6kz3+FGIgalfIFtroVTGrAgRF46aswblTIAkuPknzLwywwLwdgCQQ+Bh9gruZY5mnBkcUfkf7vu4gvhc1Wxxjz35ZwpSe3QT/ZF38PJ0CKMvIxoJORMeBGBRaGQowthdCb/0Q=
Authentication-Results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB4921.namprd11.prod.outlook.com (2603:10b6:806:115::14)
 by SN6PR11MB3374.namprd11.prod.outlook.com (2603:10b6:805:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.19; Thu, 30 Sep
 2021 17:31:17 +0000
Received: from SA2PR11MB4921.namprd11.prod.outlook.com
 ([fe80::443c:2f43:c936:f55d]) by SA2PR11MB4921.namprd11.prod.outlook.com
 ([fe80::443c:2f43:c936:f55d%8]) with mapi id 15.20.4566.014; Thu, 30 Sep 2021
 17:31:17 +0000
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC:     <linux-acpi@vger.kernel.org>, <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
References: <8e4bbd5c59de31db71f718556654c0aa077df03d.camel@linux.ibm.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: Oops in during sriov_enable with ixgbe driver
Message-ID: <5ea40608-388e-1137-9b86-85aad1cad6f6@intel.com>
Date:   Thu, 30 Sep 2021 10:31:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <8e4bbd5c59de31db71f718556654c0aa077df03d.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR10CA0007.namprd10.prod.outlook.com (2603:10b6:301::17)
 To SA2PR11MB4921.namprd11.prod.outlook.com (2603:10b6:806:115::14)
MIME-Version: 1.0
Received: from [192.168.1.214] (50.39.107.76) by MWHPR10CA0007.namprd10.prod.outlook.com (2603:10b6:301::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 17:31:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39920c9f-9bfe-467b-c764-08d984381be8
X-MS-TrafficTypeDiagnostic: SN6PR11MB3374:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB33747CAFBB4F1D74CD72A96C97AA9@SN6PR11MB3374.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XnNm9EL+Liy3E6ihw6TD+a91Kj2sYKeOCpLFKZTt8i3xwQtXiCtc7K/XRIFIu15Ntd/XibqYQU8puRyUXXNzHw9eIX5iRy6mH92+v1Ygqorg3K6akteTuKCudelvHyf+p9WkQo1flYR5AdCqptXt5wo3wPiACcdooJR+QVOoZlJYbaLK6SCNmalBnDvwQ8Y/uy5ghKW9GakegE016xbhbXm7CaHD8tDZnJRuMQsN//ADB3UC8bP/ig22OZC2rAWm01apNs3Pg2uRF1sDrCyPIfgckGXaf5nihxZZHfYK8reZka0qc0btXXQRqJGuEC9y1sgHaStUfXTiipVvr2YmX3zO997DolFYbrVD0fZo3xC/DaqEf3X9XUYKA5EAODYDCl1kf4bWlm+31jdf4VsEQ5GMuboLQpQJhaUK9YEzJylk0LxCWYeY9khk+lE67Q9Lz0xIvXOBDG6q0WPr0Cm9MGo9ciXIJaDsGAIfHP+OigolADynaAbP7scH/7LqrvppFLv7gpbrMSlInsAIJf6ynFsVWTaFLgrB7dqG326HXfWvTpSRIhgJUwgQpuVDy7d2r96E9PSiGo4tuGUr7wx7ZF6DggOeXpmSLs0xOhmCFRaoLw27ZzOCuC+fQZNPZ85zKwPxhaYdvfclcok9543wyNL/QhLbr5WSgq4IMnAP+XAYF0xUMdOIHFFR7CrmRe2kbfaMXMQMsWsFPNCtFNCG7N4+iAPVO6vKWNzV7USVGqM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4921.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(36756003)(83380400001)(26005)(2616005)(8936002)(8676002)(110136005)(66946007)(16576012)(956004)(186003)(316002)(44832011)(38100700002)(4326008)(6666004)(86362001)(31696002)(6486002)(5660300002)(508600001)(66476007)(31686004)(6636002)(53546011)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MXRYWURNejlja0hZNXVCc2Rrd28vWmovNDVpN1BVVnVlQVRTcWs0NklRL1hi?=
 =?utf-8?B?VTBMN0dCLzRnUTg3eEdlN3NHcG14SmJZaGhqYndQUFpZSm9SNktVUkJTMGt6?=
 =?utf-8?B?aHRNUXh3NktPZVlCdTVKSFRjY2I4RXB3L2UvZ1NZNGlneFBwT2UzQzN4Z2I1?=
 =?utf-8?B?VndZWW11Sy9jdEIrb1JUd24zem1qaXkwWVlxRVRsOHYyM1R6ZkZHblI5Rjht?=
 =?utf-8?B?cE1XcmdELzYwTk8xQTR6Yy9lbzQwSyt6Yld0ZHZ2clh5UXNOYjdOSjBhODhT?=
 =?utf-8?B?M0xKS0VLZ1IyaFBQd2VwOC9uM2poOHRMUjM2NXpjKzNwQkRQd1c5U2xTOFJC?=
 =?utf-8?B?VitOZU5sRll1YTByeGQyM1FwaGVSTFdpcmV5WUVoQlN4TDJIY25xSDBqcm9B?=
 =?utf-8?B?K1cvVVozQzBKWnZ6UElWN0dZNk1tLzB5Qk5UbkdBUFNxbzNFdTdTblY0M3Jq?=
 =?utf-8?B?MUNFbWpJOHpLOUlrd250eWpycXJZT0VWUHJoRFdJcWtpcHF2RUp3bWsrd0JO?=
 =?utf-8?B?MkswYzZtbUtYYzdkSVdGVEMvcHB0Szk4MFpIZml4MUhyVVJmL1V0YU5vNGo2?=
 =?utf-8?B?VFV5eGJoVnowN2x4V1FXZHZGLzJIVUg1dTlnbXBCTHRLcVhwNzcrL1cxZHBI?=
 =?utf-8?B?UWsrQ3Q2ci9pK2J1LzJROWFkTHJuS2h5VEg4MlRuTG10LzJ1UHlNa2Y1WGVn?=
 =?utf-8?B?QnU1MzJ6bUVLSzQyeFR0bERjTkRPTDVkZ2NPR2JQZ3BCSDUybU95QU5RcGtp?=
 =?utf-8?B?Y0VCek9OS2tWSmxmMVJSVTdxTk00bWEvWnZqUklOcW9PQ2VjK2UyYVRHRXV1?=
 =?utf-8?B?cUQ2OTNaZW0zYmtvVWlpaWJ6eHZ2RGJyRlUzV3BjbVFYOHRFZEoyNDlOUVo3?=
 =?utf-8?B?b2g1Tjl1SGFFcE4vMzVOZ0ZMM1lyWlB3RG42SVd4L1hoZ2V1WXl2OEdJODFk?=
 =?utf-8?B?MlRsZlZxWi9qbWl2bStMSEUrUVk1VjE4UlFKUXFHS0ZDKzk5bm13L0NvNTJM?=
 =?utf-8?B?dlphaHJyUjc5R0xyOGl0UWcrTGtsUEloc2N4ZkZVbldqYytSWTFsVytycHlv?=
 =?utf-8?B?UEhJc2srZC9UNTUvNlg1RkNPUzNFZS9RQlFnUG55VU41WWlCT0xlSzMzRUYw?=
 =?utf-8?B?dVluejdLV0pBaWRMUDdpUnp1ZjY0dFY2eVpwQjI3UGNtcUNFT1ZUZnRMV2Nv?=
 =?utf-8?B?UzdpamowZnhLaERFdkJmMFRvbUpUdUhpdEpWaHJPSVhnWkdtNG8zTHpUWG5w?=
 =?utf-8?B?SFJRbTB6eDZ1cHF6YjRvMXNxT3lRRkdYRmppMmI5OW82VjZmM3BFTUlpTjNZ?=
 =?utf-8?B?TlFleStXN3Fyd00zelJmYmxEU1RtUWo4RVdIYmxSd2hKNkVzelQyVGliZkE0?=
 =?utf-8?B?NXZIM0RBaU5HRVhkdFVURGtmTTdmQlgrSjVwS2hjUklZeTZFTjNiaS9hTldo?=
 =?utf-8?B?THp4djFUeXdQdE1yYUozZDRVNlB1cDZ4VGRhMldEcTlJYWt3blRuQ0xxUWsx?=
 =?utf-8?B?S01DN0FDVTh6elJGNDJHU3NkbklzNDRPY1VJanJQL0JiSEtrYmt0MmlPVlAz?=
 =?utf-8?B?VWlsRlRsdXcvbTAwYmk0ay9DbTZ4eCswajlVd29zT05jTDV1eW1rYXNsNVZP?=
 =?utf-8?B?blFPRU5JVVE4eVVyQjNzM1JyeHlPdDZ4SjlvZ25WR1czNis3d283VkMvYmhw?=
 =?utf-8?B?UzBFcWI4V290S1NKKzUxSzJBc0lBNEJMTjU0d2J2a21sOTJhaitML3hxV1JG?=
 =?utf-8?Q?1FNE+8R3vNPRVhx5gQ+i++ZzCT4yrugGS80+kAk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39920c9f-9bfe-467b-c764-08d984381be8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4921.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 17:31:17.2066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ck7CfoQi35aQuAiozQF5anl+/f0xKTBMdf2olkHIG+GcSkFTYDosQSMKHmcMJ65/7pkDDhi1nZNgx+bT6+CskCVUlF43eNZ5hYCG6Mu1f/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3374
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/2021 4:56 AM, Niklas Schnelle wrote:
> Hi Jesse, Hi Tony,
> 
> Since v5.15-rc1 I've been having problems with enabling SR-IOV VFs on
> my private workstation with an Intel 82599 NIC with the ixgbe driver. I
> haven't had time to bisect or look closer but since it still happens on
> v5.15-rc3 I wanted to at least check if you're aware of the problem as
> I couldn't find anything on the web.

We haven't heard anything of this problem.


> I get below Oops when trying "echo 2 > /sys/bus/pci/.../sriov_numvfs"
> and suspect that the earlier ACPI messages could have something to do
> with that, absolutely not an ACPI expert though. If there is a need I
> could do a bisect.

Hi Niklas, thanks for the report, I added the Intel Driver's list for
more exposure.

I asked the developers working on that driver to take a look and they
tried to reproduce, and were unable to do so. This might be related to
your platform, which strongly suggests that the ACPI stuff may be related.

We have tried to reproduce but everything works fine no call trace in
scenario with creating VF.

This is good in that it doesn't seem to be a general failure, you may
want to file a kernel bugzilla (bugzilla.kernel.org) to track the issue,
and I hope that @Rafael might have some insight.

This issue may be related to changes in acpi_pci_find_companion,
but as I say, we are not able to reproduce this.

commit 59dc33252ee777e02332774fbdf3381b1d5d5f5d
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Tue Aug 24 16:43:55 2021 +0200
    PCI: VMD: ACPI: Make ACPI companion lookup work for VMD bus

At this point maybe a bisect would be helpful, since this seems to be a
corner case that we used to handle but no longer do.

Thanks!
Jesse
