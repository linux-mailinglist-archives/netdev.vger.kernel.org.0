Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2785140FD80
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 18:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhIQQDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 12:03:32 -0400
Received: from mga17.intel.com ([192.55.52.151]:5910 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhIQQDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 12:03:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="202983188"
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="202983188"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 09:01:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="434893643"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga003.jf.intel.com with ESMTP; 17 Sep 2021 09:01:54 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 17 Sep 2021 09:01:53 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 17 Sep 2021 09:01:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 17 Sep 2021 09:01:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 17 Sep 2021 09:01:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCb72ClzxnZO55JtFbJlyE281W7cWtcS31zZuwkLSfnxzxVn7r55cESslhuwoLBeax8zMm721SkruSJlx5DnQndQ3UGA3Xfh6yIBjAlpD6RSka07AXP9T28B8JJxwlnWAQT37gMp/oCSyKhRDvfwe98gEfmkNliFj8+v0m6jIbNlV/CtySrED/lsTXhlBJ9mzRLSygPHhKEOX7flY31Qcs5E9APNXAzkLyMmXQj1pwnRb2+M39cflfHp/N0rC53NAQ88GevPQrrvfV+UyyZj2xqUZKVmBn3qNrxeRCuboo1F3Tkil0yvS7p1JfIbTTkV6ye5JARZRJZAZ1nkGERoPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=S9nrRXSJ4peAa4IcsSuzg09PjZHZeeRjcw6HCWYpHws=;
 b=XEpDJZqLodl2vRwHbJ0slib+klg3ETKurtWCnOkWuOc716yg5d6aWRHfO/YuPNvcjvPxwzy83ZdFc3vxLv2asWRaHHc6Z+pvMysXE8siZ1RbMAcUv0fd3Dh8CY8zBWbAj6DtmyfU167m43owynPXZ27lHsikWAiaVPu2Jy8lnx7uyqeIZmbI2+Ci3pMgo3I2CUX6GJt0XY2PZENJ9+s/Mc0Q+11ck6uiNGfX7FHYqovs0J53h7wPkELU/D/wM3nKt9zF703xkZv5oJXv0iU8ZddM2MFxF58jcXLRd4AGyqZxo2m2+b0YD9+IrOsgNkCtGld0FdxsDb0hUh3GgK3nWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9nrRXSJ4peAa4IcsSuzg09PjZHZeeRjcw6HCWYpHws=;
 b=uPDJvRVwzlFFP58/z5xOidms3bF5UEZ/GDPIU0AXTeSyrGT41eZFXVT+ifcOQ9ZhI7ufn8CPt8orivS0zoMaP0SaJBUs+4Fc53P2cfVxluylOWOvxkbI3wamxDxmwKJrNudGRQJ3Rkm40kxKRiltHkErshkajuDvRPBjynD0Zyk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MWHPR1101MB2317.namprd11.prod.outlook.com (2603:10b6:301:5b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 16:01:44 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::cd0a:aadf:cf9b:f2c3]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::cd0a:aadf:cf9b:f2c3%3]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 16:01:44 +0000
To:     Hao Chen <chenhaoa@uniontech.com>
CC:     <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210917141146.5822-1-chenhaoa@uniontech.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [net-next,v1] net: e1000e: solve insmod 'Unknown symbol
 mutex_lock' error
Message-ID: <20c47a57-e7d7-d791-5c86-e27310672789@intel.com>
Date:   Fri, 17 Sep 2021 09:01:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20210917141146.5822-1-chenhaoa@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::34) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
Received: from [192.168.1.214] (50.39.107.76) by MW4P220CA0029.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 16:01:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7332d140-7103-424a-83c0-08d979f4724a
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1101MB2317D27F9A544C9C9E1F2E6397DD9@MWHPR1101MB2317.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GDNGNct9rktuBc658cfEzQhj1QqXxnXFVNyXxKGe/vP1GdLTxHnTKve2jS2S3urWL+GCoR1Qslj03f59orWTVWWw70rYh3W1Ht3bV/o+Oal3+Mux3j6gVFn61vr6qPUMDXd5VAJ3vJ5dwJ9UkVKr9rqEEX6U4cKZwSlqXVGnma4yg5jUeinKN1X3YTArLglPo92xr0l4ZCUESIg8/feZwTBMcu1IQ3ZADIuLjnzPPYYwDWXrL4uXCfS7W1VZlWE0w92zwW2Bqdl/B0neqs2DL7djaYcD/cVCGZnXpMlrbh8htPSsrkvAQKjnupNEQdyxRnwvGCfNwDFV9GqnEEq7wkusPQuKK5yftw3pgoe9UnyUn+3SnkCM9FFxFIoC1HLht210Up+Qs4hSlgVR37yMYTC79iFa0bNqs9NSPtgafzUr/EzuV2L3BZUfhSciAjjTUgtY/1fOpx4RaOSQSC9sg9Zcq9lFsN4Vy6vaWP8G3fA6eHw0YSKGqLMUYLFQIXdy4bUmaplyyaIjIgsGWB8fzU11M2aBs/xJafIbzqz6jVBYCPq/ZJIJ0oH3Ve+yhrFRFCHL1HXHEd7yr/IcTqfQWLXhrctrA1h0j1f3A0LMkQ12l9xP/Tek9j9WsZq4GlZw+7hUiwmOtr4d9L9GLjg2WP9rPuZllU+jxWb0wJOHxGUBxDAdzkOjHfVeLjqUN0dauTvDRI+cd6GAZZsQpwVsQB0MrP/9MB3erKCwRRiGPmk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(66476007)(8676002)(8936002)(66556008)(66946007)(53546011)(5660300002)(956004)(36756003)(2616005)(4744005)(478600001)(44832011)(2906002)(26005)(4326008)(6486002)(31696002)(83380400001)(16576012)(316002)(38100700002)(6916009)(31686004)(86362001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0ZFcUx4QkpRQ1JZUWtSa3NLL2cycUFRaW50QWNzQ2JndkNieUl2VFlNNjl2?=
 =?utf-8?B?NVB2NGl0L2VTRWsrS3N1TkRVcDdmTW1NbGRMdkV6WjNxWEtmKzVYRnRHZ1FY?=
 =?utf-8?B?UzZGSHZJOU0rcGd1TGozZzlBMHpOeURScTFwTk9uTnBjTFhJMzBPbDRNWStK?=
 =?utf-8?B?RXd2QVozTjh1cnV0VjFaVmhja1czUjN5R3BrTE5oSUpKWkg1a1NWYWgrU3Jp?=
 =?utf-8?B?UE9jMkpQNTRWVk9VOGx1aXFaTVJZdWlDUFAxVG5sbkdYeUl1U3hlT0Y3eVpZ?=
 =?utf-8?B?UFR3UjlwU0lZQ1ZQQlNWZk9ZR3Y1MXMvRk94bE40NFpVNk9tT0xrYVN0NWFD?=
 =?utf-8?B?V3ZBTlUzM2ltVnhrY0VIZEd3bnhOdHhKbjNFaUdYMmpQUHowbFJBODdkWFhR?=
 =?utf-8?B?T2hhUFl0elNLN3pacDZsNnFPNVcxV3ZjdU9HQmIrZWFOYkpISExia1lUWlg2?=
 =?utf-8?B?Sk45ZWNtUFlaL2ViakN2ajlMMDJ6bTdnd2pZMFVIbTBKNjRwQkFBSXdWWVpQ?=
 =?utf-8?B?dkdvKzU1WUQvaGpZVUhlUGQ0SjJka2hDSkxqR1o4VEhBWUx6OVdGT01wYnha?=
 =?utf-8?B?amlUT1lucUZ1ODd3TGdadEFIdSszVFZlM0hVM0VJelhWcnJrTWtSTUQxRDl4?=
 =?utf-8?B?ZGRxaklJeWtyenZubk1GM0RPNkJVSFkrTkN6MVFjeVljSWpqT25IaWM3TGlW?=
 =?utf-8?B?ZjlueVJuZXlSREIwMzhDd2VyNWxNTzdmSXg1cHZpYUR2ZHI4UmJHbFpOS1R1?=
 =?utf-8?B?Mlo4OTIveFdNWWphRGY2M3B6Wm0wbUM2RmFjQjN5ZkExcitSNWlsUHdrcURQ?=
 =?utf-8?B?amNuaEkweTVNeEtVRVFVRlBYOTh1RENHTTdXdWcyem85U2p6MDVlYVV0L0pq?=
 =?utf-8?B?R0s4VUxNd0hBc3BONVJtOXlvM3l5aExOaVN3bFhWdGpFS3lCS1VXTTFuL2Mv?=
 =?utf-8?B?RVB3WnFFaGducGJhejlXcjFzT3A4b2RvSEJ1Mjg2eHpCbWRXTmVyWDhlMi9i?=
 =?utf-8?B?T1NGWkZpQWwwT0YzSGVKSHFOOHgxMnBVWlFyOGtZUmxyRWhOSlRoZ2FreWFl?=
 =?utf-8?B?TWYwQ1lRU1ZkWEpJRElHZEhyd1NXQmZWRDJOT1IwQk9QUTRKcG9BVU1YWGFs?=
 =?utf-8?B?SSsvRlgxOWlheDVMREs0bnlqZmxLai9kQUdIT0VlUG13emlIdjNYNWcvMnZH?=
 =?utf-8?B?bjF0QmhOck4rdXFST21HdjlBZmJrTDZCUXZ4OGlZT2hBeFBmQWlDQ3ZKVmxk?=
 =?utf-8?B?NXFNbXpTakpDemVUbFFuUWhDVFV5QWNqT2VaMzh0RE43dlIzc1NPQWRKcEg3?=
 =?utf-8?B?NW04K0RFVFJnK3NxVkhlZEVrbmRDenM4elpyZEc4aHQxNEdMc3Rvcmp2ZHly?=
 =?utf-8?B?YmJBbHArRFdQSWFJekx0WmM2ZmM4dmMxeHg2ZncwdXBDWGxoNmZ2R2l2RHRM?=
 =?utf-8?B?Q0d4NlZvSWk2VVFOVkRQTVhGbzJIUkg5Qml1SXJjSVdZVGxFeVE3QW0zVTNZ?=
 =?utf-8?B?RGlyek84NlpzRWEvR0RvU21sUlp4V0Exc2NELzY4SUhhNVdyV0ZSVzcrTFda?=
 =?utf-8?B?WEVvcnNEQUZzOHMyTmtYNjR6cERLZ2xobUYwRFZGWHZsdEt3ZHY0d0FSM3dq?=
 =?utf-8?B?eVhiTnkyT1lqMkRwRWphVGFVODB2R2YwOTUwU1pDYWFkWGkxRmtzMnd4bHRH?=
 =?utf-8?B?UVZ1WkUxc2JNTVVrZGNqUmZQNXFhQmNzeVJ5aStKRE00SWVBVzU4b3N6WGxP?=
 =?utf-8?Q?ZV/0l6aNmN9stPQ263G5P8q2cW3s4CPvCLcfmA3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7332d140-7103-424a-83c0-08d979f4724a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 16:01:44.7098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oWQ85ws2EkM8Xtn/EmBi3+9HHQRQkk4uAdZDV3dzYo1NCxawSpQJutzO62n6i/fTHClRU2O6iuT5SjOYAZoNh7Tm8ZMonVcRPw50QC1VEf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2317
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/2021 7:11 AM, Hao Chen wrote:
> After I turn on the CONFIG_LOCK_STAT=y, insmod e1000e.ko will report:
> [    5.641579] e1000e: Unknown symbol mutex_lock (err -2)
> [   90.775705] e1000e: Unknown symbol mutex_lock (err -2)
> [  132.252339] e1000e: Unknown symbol mutex_lock (err -2)
> 
> This problem fixed after include <linux/mutex.h>.

Thanks for taking the time to send a patch.
Why do you think including a file will fix this? That error is usually
the user's fault for trying to use insmod which doesn't check module
dependencies.

The advice I usually give is to try modprobe instead, does the problem
still occur without this patch and just using modprobe?
