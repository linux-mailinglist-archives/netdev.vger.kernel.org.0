Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFFA41E047
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 19:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352772AbhI3Rk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 13:40:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:25997 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352731AbhI3Rk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 13:40:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="225288487"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="225288487"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 10:38:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="521292762"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga001.jf.intel.com with ESMTP; 30 Sep 2021 10:38:44 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 10:38:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 30 Sep 2021 10:38:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 30 Sep 2021 10:38:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ivet4E9u41RUrBGSQ+wyEfFIjmzlrwXDfBtSFlLjAZpADtLDLA2qlKwmmN3ySCUd7/2fHTf3/BqRH/f6qlX2eRZwAYCOFHpKZWahLoRskDibr4Je2kkdREPcb4kXTHV1S3vSFOz69o2cd5tjAHPNd+CZe1tOSvBINoPJjRBXhxgvfgBYrBGo8a5VePQvbLFmzYtU/EOOh0q+ur1zeiZTiyD1yxtfz9rkt/d9ugCP9Gm0/80RnNHo71+jcN2ROHHTGbuZWi5yxaUSvGUlFJjqAnSBLMrS/abJLkfyZ6R1j0Qny6GoLqOa6mj0nT7Ukj/fe3im5Q9Sk/kqVE77CQx2vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oNXe0GQlDAVVBkv6SGmw53UziwQUbP1rxTjYLe1/IXg=;
 b=fqK95ZB2mJRwxVDVq75N14vxRwdzMJgOONPX7pqnct5Mt4qO4dpDT+qDDWUzy6yMEx+xY7iZdlYtUaG8XEdzfxhmomX7gupsgBWEa3EA4V8UZGGhG+v9BV21idRX9LQ7jmk7XGnXl5cgL9qW+VzvFXLW3Wr1V2LGrnlUhhI4/DXq821p/+3p9IR3IFmxIa4nKgV1nIZP58G8sp0E0GKWednX89eSNv4PpTPR3UsJY9me7+xqUxbZ0NvCZgmQTFcXuQsz75egg2LxAC5LW9cCjA6XI0icyUHkoZGfBSor9LLckW2ZURlug+TdrfACpf2E80U9+twEmpDGJkUYdZRKGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNXe0GQlDAVVBkv6SGmw53UziwQUbP1rxTjYLe1/IXg=;
 b=OCquIOwpLD0DfX922Xd4jdIbv4XnAKUAQ6gHUrJFqeKe4DLSLx/+3Oflw2kOKkmIZ8C+TOYorwGipRP8XwlOld4oLybeSiLJN8wLKL6rjhElgHFt8T2XUFuGTS0IlAeUINFLNictpfw/eJZNTHE+q5Mvd9PnOgESmJ+JXWki2Kc=
Authentication-Results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5326.namprd11.prod.outlook.com (2603:10b6:5:391::8) by
 DM6PR11MB3610.namprd11.prod.outlook.com (2603:10b6:5:139::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.20; Thu, 30 Sep 2021 17:38:42 +0000
Received: from DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::c61:d5d8:c71e:66da]) by DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::c61:d5d8:c71e:66da%9]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 17:38:42 +0000
Subject: Re: Oops in during sriov_enable with ixgbe driver
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <linux-acpi@vger.kernel.org>, <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
References: <8e4bbd5c59de31db71f718556654c0aa077df03d.camel@linux.ibm.com>
 <5ea40608-388e-1137-9b86-85aad1cad6f6@intel.com>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <b9e461a5-75de-6f45-1709-d9573492f7ac@intel.com>
Date:   Thu, 30 Sep 2021 19:38:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.14.0
In-Reply-To: <5ea40608-388e-1137-9b86-85aad1cad6f6@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FR0P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::22) To DM4PR11MB5326.namprd11.prod.outlook.com
 (2603:10b6:5:391::8)
MIME-Version: 1.0
Received: from [192.168.100.217] (213.134.175.135) by FR0P281CA0017.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:15::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.8 via Frontend Transport; Thu, 30 Sep 2021 17:38:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa850e20-bd09-4cad-839d-08d984392519
X-MS-TrafficTypeDiagnostic: DM6PR11MB3610:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB361028080D37B7843F84E902CBAA9@DM6PR11MB3610.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dA6mIH/2OQLDJr83BEC08teEylLZ7zygtyJe2D4gfL8KvsrJ8RJ4n/d6YfdUoNOij5lO4zIA/ZXTnaT4ynMsngkRRBJVoSrUbPUm+jDZT7kWrxz6WA0q6Yvgy4UPOBM7ZsB4De2L4Woe7dyUg8R7Kkg0YueMy0ykYPruoAsio52YMhR2zgWtLWRNBgkMM8Z24Afoj6oqASHtpr3hWCiM5CsGmOWJtHEee+mncXT/A2C3BYyu/0rpEJFaEzL/NyIwrroePvZV5c1RSJ2apSEjYsPmzUZDnS/a6tmdZPcnsncQ3AFseNu5YH6ale/MwAP40m/w4jUYV9S87saL9BT0Q2KNWH7F4VyRE00ad0/Qe3zZg9ob8nDeCtNKk37TcR6K6gwjaS+W9AHCI2xb5BYM+qfCb3mU79PZml+sYu/7C8F8X8MLH/c8nQoCZg5EJgMaASY94FIvrIvJrrZON7ptzj89ED+sBX0am7TpmOLsUvavWiF1GjucAxZKETMiZ+qrfsV4RDQivoLkj/LCWkEwJxXmOgJD4YY18A+OKnBteSGXWoTgyBO3uYWvKYOvpYjdkh+OiyLapig9za/z8+xoofWxbp02Zs3seXhtGkiUl6r5nQMI97qK0YMgF1d3BU+YfcuDRSpjB7BSYDweKHEHQaJmPpbi9SMNHdwcOeljvNmiNrcZ2Pkp+Mejn6w0jexHMq1I0Skry0PWKvB5UzI16gq3gxJtnELFL68AqdIKhHA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5326.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6636002)(508600001)(83380400001)(16576012)(4326008)(186003)(31696002)(110136005)(53546011)(66946007)(66476007)(38100700002)(31686004)(36756003)(6486002)(36916002)(2906002)(6666004)(86362001)(26005)(66556008)(5660300002)(2616005)(956004)(316002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTBVdFVXQWJrcVArejFZQWlndnpHb2ZTQzFiVys2NUptelZjYzJFcXppNmFV?=
 =?utf-8?B?Yk5OMklCTkVuU3ZCWE5kUnFKOG0ya3VCbWZGL1A2QkIwT0F2c3F5SE56U2Nr?=
 =?utf-8?B?SEZadXgxU0NseGZrelBBYWk3bXBhMDZLUHZmV3kyVTczeEFNVUV0VjBBRjAw?=
 =?utf-8?B?Tjk2cEFzRXJhaWFxaDJ4bVdHUkZYUlVaWHI5SUpmV01yQUF6aW9VaWhQaFFY?=
 =?utf-8?B?dERsSldqL2FHeG9ncGRUTlpWaDRRWmYwU3dOb2VXTFZZdU96Z0hTUWxaWVZR?=
 =?utf-8?B?blRjZ1FNTVgzK2xWWlVMN3lpWjF5ejNWeUdsR0ZZd3FhRXJsZ2x0UUJBR0Jn?=
 =?utf-8?B?OXdMTmpHWFZiaUpCMGJkMmQydzhzRUQ3M0JBVFV5TjN2dllzZzhmVGQweXhi?=
 =?utf-8?B?NG83TEtSY3NPbEZzOHVwQWw0cXR1WjJva2gvLzdLRFlmeDlCU1FRRnRyK05F?=
 =?utf-8?B?M29BdlJVYTZIQ0o1V1dBaWs5MTZpZ1g4SEpzQVg2cGgweDNYUW01Uit0alVW?=
 =?utf-8?B?cVBSUW9xSHlzZTAzNml4d0ZaT3A4YzlMSUk3bFoyTkU3dm9TL1prZEp2YVRE?=
 =?utf-8?B?Q0diUFZIcm15bWpIcGF6Uy9qMTZ6VkpINFhtd3FyWmVGRWw4clR2TTIyVFVh?=
 =?utf-8?B?TUxKaUFRbnNGRmh5NVpnRTdjTTRvUHRrSGZldE02cUNqc1dEdjdQQmRCOEZS?=
 =?utf-8?B?WHZiay85a01LOFZNM0g2T0tEaitVNTd1NEZmT01GTXVXb3RuQVNaOEd2SDVN?=
 =?utf-8?B?bTllV25IVlJ3WDkydW1Fd0NQdVFmdW1LTTluRXBJRUJXaW9vcWFyL3pLcTBE?=
 =?utf-8?B?bVQ1S1lLQ2dIRTl4Q1l0bitCT0FseG41NEtCTkVVTkc1c3dIUGlPSDB3bHN4?=
 =?utf-8?B?M2RISFJWaGs4OVZzcVN6MWd0L3JEbHR6T1o3WjVoUm80VS94OFhIWEtBcnN0?=
 =?utf-8?B?dm44WndMZHlCekswRW9DaEcrUEtNd0lMV3c0cUVkNU13NzkxSFh6Qjh1ZG9y?=
 =?utf-8?B?MGNCRFBuWFBqU1cwUG5MQzBhMHl4c05Ldlg4VDZrR28yZExDMEd1V0YybUp0?=
 =?utf-8?B?d3pDZDJtVmV1NFdZbmVSUFZldnVzSWNmQm94MGdhckVJYVJqR1NlWkJocHZ1?=
 =?utf-8?B?UmFZc2VscGFnamlRc0ZFZEYrSTFMemRwNHVMcjhJblY3aDd2OGJ6T1hhVEdX?=
 =?utf-8?B?Vm9ZV1dSTm02eVZhc1hYZ2FaSnFIeUJuNEdBTGFvR1BXWTdJYlZXbWJSYXpv?=
 =?utf-8?B?VXVEWG5tbnZUS3RmNGc1N1lSU3g4SlQ1UERrL0RzRlROdmpIdCs0bTFFUktv?=
 =?utf-8?B?LzA0WW1kQi83MW4yZUJIUmNjZFNFL1VLN1RjY3VwanJqNnRwc0RRRzU2RVBt?=
 =?utf-8?B?QmxJM1FJME5kaG9OUjVndlh2Qk9QZUlVUktxdDdJWjlIcmJSWC9LTlVSMVhY?=
 =?utf-8?B?YnBkYkdUYStQZE8wSlJWV3EyWi9zdjhDeW05YzBHbEFBNXFIeE1xMVk3TGQr?=
 =?utf-8?B?YjQzKzJYaHZ0UWlIUVlTYy9Uai95Zk8xZmZNaFQ4a3ZpVUNUOVp0R3lrSXZl?=
 =?utf-8?B?WTlLRGdDSmtmVENlenlWZVpwdkJLZGtqVDdjZkdpUzE3bGt2d2FIZjRYMlNZ?=
 =?utf-8?B?VU0zV0E1bk12ZElrUGRuMVBqdVdTT0Y3TFZIS0htYWlTZ1FzdEFnb0Zqb3Nq?=
 =?utf-8?B?VGg5NE5nNFcwb2xhYTl5RmFiN0ZzMVRPb1RZWkFqWVJTZlNTRytCQ0VpLzYr?=
 =?utf-8?Q?NBsGX0ylFWOiKfxIQ0qG0MkZ0cKr0NR6DYB/zUy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa850e20-bd09-4cad-839d-08d984392519
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5326.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 17:38:42.1481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0xQquAGfWpZAW9G5HVNe/BSLwpHaAEtt7k246DRh+/QWnTEQuIRIbAXgf61dCafyR+wFMBU/eQTK3hiMNC8jp+mVhLC4wml2c06+lD9jys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3610
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/2021 7:31 PM, Jesse Brandeburg wrote:
> On 9/28/2021 4:56 AM, Niklas Schnelle wrote:
>> Hi Jesse, Hi Tony,
>>
>> Since v5.15-rc1 I've been having problems with enabling SR-IOV VFs on
>> my private workstation with an Intel 82599 NIC with the ixgbe driver. I
>> haven't had time to bisect or look closer but since it still happens on
>> v5.15-rc3 I wanted to at least check if you're aware of the problem as
>> I couldn't find anything on the web.
> We haven't heard anything of this problem.
>
>
>> I get below Oops when trying "echo 2 > /sys/bus/pci/.../sriov_numvfs"
>> and suspect that the earlier ACPI messages could have something to do
>> with that, absolutely not an ACPI expert though. If there is a need I
>> could do a bisect.
> Hi Niklas, thanks for the report, I added the Intel Driver's list for
> more exposure.
>
> I asked the developers working on that driver to take a look and they
> tried to reproduce, and were unable to do so. This might be related to
> your platform, which strongly suggests that the ACPI stuff may be related.
>
> We have tried to reproduce but everything works fine no call trace in
> scenario with creating VF.
>
> This is good in that it doesn't seem to be a general failure, you may
> want to file a kernel bugzilla (bugzilla.kernel.org) to track the issue,
> and I hope that @Rafael might have some insight.
>
> This issue may be related to changes in acpi_pci_find_companion,
> but as I say, we are not able to reproduce this.
>
> commit 59dc33252ee777e02332774fbdf3381b1d5d5f5d
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Tue Aug 24 16:43:55 2021 +0200
>      PCI: VMD: ACPI: Make ACPI companion lookup work for VMD bus

This change doesn't affect any devices beyond the ones on the VMD bus.


> At this point maybe a bisect would be helpful, since this seems to be a
> corner case that we used to handle but no longer do.
>
> Thanks!
> Jesse


