Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4564323D2
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbhJRQ3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:29:45 -0400
Received: from mga07.intel.com ([134.134.136.100]:54866 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231787AbhJRQ3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 12:29:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10141"; a="291755953"
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="291755953"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 09:27:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="444142383"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 18 Oct 2021 09:27:32 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 18 Oct 2021 09:27:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 18 Oct 2021 09:27:32 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 18 Oct 2021 09:27:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XjlqULHeLJ2BshRJEeFUtIqgtTjsOVh/Q9xKnvV3wG5yKutqJMxfEFwm1evZhnXICplchL8JY4cGgI5DJqy5tIKQu1qEkao6f7FaDmE6IaBkziQ+ayXB+byMOowK9mCJPcYU+HTGNNnGeuqp8ywzGVXMqHmlzO6QrK8hUEnk+WCdoAfr8x3ThuEfjCPkE3j6SuvnXlsAepfGSeymL2Shwbhya6/3AvYfYsEXfPZBeZESOrzMJ7H+wnMEI5qLh+icRBz05n/vMONElRlSlpqwokYBOcG/3CPBz07aT5e/xEfIR2wshFA0IgN/7ZM3n0I8EWlggnRIZhHiWSHonxcOuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKxI8SKAM4GTKxtgsWGq/Gv2oIkKAk/jAfFaEwh8Djk=;
 b=XyWdQ6/WksQpr66gnUIxL551LbHAaB04gDX33Vagw3bdk22pdxmuxSnjcVztK4ZhLzoclkxhUGRbkR6eqK/JjyvP/JevE1fQK8w8QLcfTWqHq1avxTMtgUOgzByTE6HSkcqNH0Th3Z8om7g3DQT3lICQ+wi7A3WivPT2Q+hgMJrniXbc4UXckgnQP6C7umpykuo33zOX1MwlgM5agmLasX8mdtUlm/0w3dFyXiq+fUHMhSDVI1zgx0fGwupgcqRkByqNkxP3frw5PSbs7aRC9QGjg1FC9zHhWaBj5qTlAgS9jGo0vmsdKZ9+XjA3eyXeR5y57kF0ze/Pek1Gnn8fvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKxI8SKAM4GTKxtgsWGq/Gv2oIkKAk/jAfFaEwh8Djk=;
 b=yNTsBLB1mYDoDeTFOWF+aj3BsNGBRoDzDmC2JQ032EkzIvbd4Gln4LWC7agE8OVRIgMvbKeOdUTBAP9BTBUDnZv1t2Ab/KHgr5JB3Euoyovi4MnMZgJW1htLQoTlBfHCZefW1Vm8iefKKiCNHfwhw6yaItUry2t9Pfif24ZLIxo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MW3PR11MB4602.namprd11.prod.outlook.com (2603:10b6:303:52::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Mon, 18 Oct
 2021 16:27:22 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::3166:ce06:b90:f304]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::3166:ce06:b90:f304%3]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 16:27:22 +0000
Message-ID: <a77dd608-1297-1522-7161-197258906ac0@intel.com>
Date:   Mon, 18 Oct 2021 09:27:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH linux-next] e1000e: Remove redundant statement
Content-Language: en-US
To:     luo penghao <cgel.zte@gmail.com>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        luo penghao <luo.penghao@zte.com.cn>,
        "Zeal Robot" <zealci@zte.com.cn>
References: <20211018085154.853744-1-luo.penghao@zte.com.cn>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20211018085154.853744-1-luo.penghao@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0198.namprd04.prod.outlook.com
 (2603:10b6:303:86::23) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
Received: from [192.168.1.214] (50.39.107.76) by MW4PR04CA0198.namprd04.prod.outlook.com (2603:10b6:303:86::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 16:27:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 722b968c-3810-4737-6d55-08d99254299e
X-MS-TrafficTypeDiagnostic: MW3PR11MB4602:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR11MB460298B425965534798CBCBA97BC9@MW3PR11MB4602.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LRzxrp1I5R0k4fA32A/9d2fp9gDsmJNIsStLh+KWcgt6EY84q2cQNb6GFJe7PXAiPtf1XTKW9NC8BBPuViKh1Jm1bTkUy3goBT3RTWR8pbX0amqnyUJ4KrIdsGEnRNaYlVQ1p4HG1EMW+3BIpyT9es0w9rC9B9z/xhsw+0vFOJR4nXAN1+rX8J2PeVMpWpUFcdYO5z7bh44p+aMJcUCF2gXpxcwoxNADgk/cQF8pV2zYfSeI1n5oZIOvz7L4AjAW5cHuu5GDSj7Rx9jP5xmitfU+ZWraV+f8KvTi5S/dXEK/Nw5sQnNt08Pv2c1V9EWHEKTUjRRR1m02zWpyxKNzhk45DxuZtz1Qj+I3JUlzfTb31826yp3wXOIY9xW12UhBKQE64A9iUdDQ3hPdiFLnwDhOmRL7Zy0JeBtHGzUu95QP1JXQHPj0BNy5DiLrnRH9FEcGn9a4eeRpLYRkr4mUjxFnCmdQ9UdlEEFN7IKi1Qn3TvM4KUc9HFkmCfS8EAQ0HpSMwNDPiDa2dGXKRFvfd45ZEU9V1PHXCO7m3rkXhfIWYwdzyYsb96hbtvDJT8ONsJWC6lspx8a11xhag8pKPyPZBI/O8zEoNjZT6h45tAEvNX4o6AlKnJp1sYWPonPBxblbM53PufAtOnzbGw4LhjHUCBjDZcxCR6UrZ8c07Sl8H0nu7GyYBjVwUw2Dv+4jyYO294Wzo1EX+Q1qsIMYcN+t4yencHdYAY3TZrYURdn43Xcea1gkOT9OZEdrxJnk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(44832011)(316002)(36756003)(31696002)(8676002)(16576012)(4326008)(2906002)(53546011)(186003)(66946007)(6916009)(508600001)(6486002)(66476007)(86362001)(956004)(54906003)(83380400001)(26005)(5660300002)(8936002)(66556008)(4744005)(2616005)(38100700002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmJjOFd5cldCWC9lUE5kdk13YVFzRmRrS1BCdTRReVh6V2YvdUFGYzhpMGVV?=
 =?utf-8?B?L0ZVeDM1WkZiYmpXbllST0RhRStSL0xTbGE0NjNvb2RBbFU4bnJHa2ttMmtT?=
 =?utf-8?B?bE1JRzlqbFVYY1pkazlPSDROdUxKMmlGOU51ajZ6MTV3UjgwMmhOSEs5WmJl?=
 =?utf-8?B?Vng0N2hvT3dJK2RSZE43ODJCZUFNcGJ0dW1uT0J3NUtDZzdweWlTbFMxQ3Nh?=
 =?utf-8?B?akdYc2w0NnVyWU9VMjFvYUZOMlZmVytvL0VJZitjYVgrRzdWOURpL3J1dGN4?=
 =?utf-8?B?T1NiRTZTN2RHRFZmQmVscmxETUEzUVNDRGlQaVVITEZsZFFSRXBIeTZFWmdV?=
 =?utf-8?B?RFVEaDl3eW5DYTlCak9wNUJVZzBNbTdmeVNlUjhnd1BCem05OVkzK095NHAx?=
 =?utf-8?B?Z3JIWnZmSFRoOWFkZUx1UEliTEdUODBuaEFIaVdqTmlvSEt1T0tCZ2g5bkNo?=
 =?utf-8?B?RmhCZDhTQkJjcnpJU3lWU0Q3RUVORXlyUCtxcytlMDc0dVJpRXlIaWk5VEFz?=
 =?utf-8?B?UGtHRHZLUkhYRnpJTkFhUTZsbU9vU0k2TCt1TzlYeGpkUXd6Uml3ZHR6ZnZF?=
 =?utf-8?B?L3Job09ORkI2WWJtaTMwS1QzUXFYRnI4UkVNWUlmNUV0WlVIbHQyUGFYVkxq?=
 =?utf-8?B?OEczU1B0WEdwNnhwcGhBMHRuMHBDVkpncytrMklFMHpzOG9MU0FKOVRCTFYv?=
 =?utf-8?B?aXgyanRwUzUvV3dXYU1DYWZlem84NDhlMm56ZEJ6aUhaNEVzNW9zUlovTXRw?=
 =?utf-8?B?VklpTGY5UC9IWitGRnBwTWgzd3hUdDVHdVBNMnZqc1lmMHp1U1U0aWJFVWZv?=
 =?utf-8?B?R1JISkRvV0pFUVdQczJ3RHBCZnpSdzFYWEdGM0N5ZjIrMVpJNTJ3Y0pFWmla?=
 =?utf-8?B?MW5UcWJ2SGtEZmZmS3ZjcGwzNVZkK0RYZlh1N2lVdTYwcEw1U1FQQTUrYnpX?=
 =?utf-8?B?aWlQaXRqTDZVTHVxY0pKL2dleWY2R0NsTEtmOEIzdkRUazEyN1pjdDZMYnVz?=
 =?utf-8?B?aXFMOUh3dUxSOGUwYkpjTk1hSldaQi9TYUdyNkh2eHRMeGcyZUU0Z3lZRnJo?=
 =?utf-8?B?NlRVdXV4R05RN2VYdXl3YjZ1WUQ3cjdMM0ZaZjZML1V4aDBkWitnWTZ5aW9a?=
 =?utf-8?B?ZHhtOGVRQWFCeWNtMUwyRS9LdlNhVVRrLzN3S0pVbUVkKzEyVmVTcnBsWGQ3?=
 =?utf-8?B?WktYU3F2WFJ6eXpkLzNZaGdpRWR6UW40MHJCekNXaFp1Ly9yWUhqZFQ2cWRq?=
 =?utf-8?B?N1VEazJEYUxKRHI1SVd5REhsajZZS3h5TlFoNThtRXJtc2RJOW0vVm9xZEIz?=
 =?utf-8?B?Q2phdU9KL1FMMXplMkpicFZySDN2MnZoTUdPNVo4NVFjQi9TYnZUeE5XS2hY?=
 =?utf-8?B?b0hvbkdkSWhCbWlLVmg5aFJyNGxId0M2eDNWZGY2dC9haUdNR3gxWjlSYTRW?=
 =?utf-8?B?UjYvYjdRRHQ5ZDVMa3dNZGJuNmdkNzAxTE9MTXRna2ZTdTBXdktVZ0RnYzk0?=
 =?utf-8?B?QmZ5L1Exa01aU3l1QzM1RVo1d3BST0sxczJhbXJreE9lelQxWUR6dVlVa1RW?=
 =?utf-8?B?Mk1lN2FOZU1Fb1pxYUUzYVNEalFMaE1CdEZIKzZoaXhUSUxKQUZ0aUlQOWox?=
 =?utf-8?B?dkQxWUExVDl1N0VXakN1MHNoR2lYeVJJZjFpRi9RVDlnMTJjUW50Z1lTZ2Vh?=
 =?utf-8?B?Wm94cUpENzhVY3BndnZEWlVuZjAzWmxlN3phdWs4Z2srNEtodkJlNVZ5Q1lQ?=
 =?utf-8?Q?DttiR8JEZ8yRia0S7vmxDam5gdw1e+h61r0C06S?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 722b968c-3810-4737-6d55-08d99254299e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 16:27:22.4405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jh3NB9fQutHGFbx8aM/OsMIL6o6mBBY+PmrXKt49GtRxAf3zMJ9XtWkCyBi2qPbux5lWw53Jxdp99s9NbqG1T6GyUnix/lRVb2e0v704Cwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4602
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/2021 1:51 AM, luo penghao wrote:
> This assignment statement is meaningless, because the statement
> will execute to the tag "set_itr_now".
> 
> The clang_analyzer complains as follows:
> 
> drivers/net/ethernet/intel/e1000e/netdev.c:2552:3 warning:
> 
> Value stored to 'current_itr' is never read.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: luo penghao <luo.penghao@zte.com.cn>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
