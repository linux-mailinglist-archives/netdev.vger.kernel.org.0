Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8216DDFCE
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjDKPih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDKPig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:38:36 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CE1E60;
        Tue, 11 Apr 2023 08:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681227515; x=1712763515;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Yb98Agr6ED/F4yxeuFitBVU4LwO7fDcWju0NzDdeBRo=;
  b=GkpB+/l8L4F3pFLl6b0U0YVRi92l4CFomI5DZaIrkVdVpw3Ewq1+ndLd
   EDVvb4+7llhW9EKTepO+M6TsHSNSBpdfTfBXCyF5WTjYr4JV38JmZ1QJt
   9PpZOvgar6UVpHX8lF45HZdhenkxK4yP2rk7jisvgoFJX149HF10x0zaM
   4bjyifcbJUrjIFVoxwashg7FFibEgkjvEYkUT3+8uZkdUaXQkqkFc78Xw
   e5/cGbGjmqPSbrByQLUn7ISlvQEQUNIBH82jT5So4kVHVHOqCg3e+omoL
   S0x+wELvfVsuxa6ZVz4PBXg7tMKvOc/zhlugEd/3gQmL6ijKr5TUzEMX6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="408791315"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="408791315"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 08:38:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="688622223"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="688622223"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 11 Apr 2023 08:38:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:38:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:38:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 08:38:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 11 Apr 2023 08:38:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caZjrAiNtOftJEHmRN16/x02MCO8YbpljMhgQkNWRjC9aaMIcAmdgMd+v4PZKiMFmUAfpwOFlNMP+HgXWMTKeOBHiekeRo377Nz+oyK7ANQVJOD+HQTjVXi6WB6ndlDbpUSvKBtYi/U9d3yvppAn0b89GnLzg+oHBeHhVE7frPK80N7ixw32/RTWsmzCclIOVJ4lQiQHm0zoxsnSzB7AE7EiiEMhWQnCqxrO716u/pwNa7LsyoLqXDsy2modTWB1kY+M3USEQRIMeXxdn3DzyTX2fThmfbKZ3jiNdgUvYoiQMQio9jbXNlhnccumr+uM/DqX3jogsqZs19uuXGsr/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYeOsS1pSRB5iwVYBlC5hMUO6T/0/QAk2kx7FXmAc3A=;
 b=IYm7QqhUGkfVISY5tPJRgmA09R3qp6ZxutBqZ4D+mUCxdzrafg5EA0p0HmmJbhAfjRxEHsDkZHY1WHY+ZDfP/Bjv0DgVG2pexiBlDQfanFPDDn1ho4QHHrTNd7Kduz1s2b842evnUDnVkpGF1WMB2zOvxuRsn6TYNYbab7d1ptPCnX6GbzFU6bZqiU5+dPKxMV/TARJ3NHFA2LzBbnZNRn4G9YvvSJFWXukpIo9GbQQ0Zqovjfv6U7FVkCQbFzh2WXn4PG1YS96bP+U9GvAT3wq87uBXSmLo+KzHdGwEvHU/cjwcwKp6lVvS0YVIHvItxqucNxNpKaknSml8Xn+7RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by SJ0PR11MB5022.namprd11.prod.outlook.com (2603:10b6:a03:2d7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 15:38:24 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 15:38:24 +0000
Message-ID: <17a50d0d-6b00-8966-ae37-d8407c0a89fb@intel.com>
Date:   Tue, 11 Apr 2023 08:38:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH] net: ti/cpsw: Add explicit platform_device.h and
 of_platform.h includes
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230410232719.1561950-1-robh@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230410232719.1561950-1-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0062.namprd03.prod.outlook.com
 (2603:10b6:a03:331::7) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|SJ0PR11MB5022:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f6468fb-54f3-456d-2e3c-08db3aa2c973
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t/cJSFaQU/r/SLxv2ynMHYLbN4Rn0mDjxU1JbpnPxWLLNj6PF+Rkm/nhW028oPdC58xJFhlAqCkC50FBxxAAfyX73RBHKF3qAXaWPHcpeqJS0P50Rl6QwTPhztpR9snOOHnBsaSTrLtgECU+U/zJDZFjpv8WDIgJOE+YC4WhEynR8h4uqtnDuUTZYgfIf7SRGDD9cKNsH/z3UJqvOIxjUaF1cLUf7vGclEfDAVomBTV31yNzfLIQRJJe7Uivo702aGkI6HPYCqYq8kPi9xvt/9H/Z1Wx9VlX+SrRUH/x2WldO+iPiI/CrtppCHBwgIkvvmFqF0PrSB+NTrxkG0H1X88/ayNA43haDjGDuyWjYFNuZS/4vDBJ2Lo/UsHP+bXy6QZV58RH3rngPBZyAqmUeMJXrkb13dEm6jHkJuQiOiReJKN6kBXTsKyvXZPkenqHr3rx+GQGWgsj4vWiGgXI47PB4XEEUDc90lSfM0jOl148D6FtxLGHfrHXwVN8xqWF8oNnm1eQvRloTYu0qJ81n5qr7vJLprt3+meSutXmt0BOTpIrRXmegcM7Jld0dTjVdq7j3UiKyluvVGdQdbL+Y4Jz75KogSSftnTtzG6rryy1JKA7OYiStpqpg+WALMbSD89jHCYo88+TVcx/j32oVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(346002)(39850400004)(366004)(451199021)(8936002)(44832011)(4744005)(6486002)(5660300002)(86362001)(4326008)(31696002)(8676002)(66556008)(66476007)(66946007)(478600001)(38100700002)(31686004)(110136005)(316002)(82960400001)(53546011)(2906002)(6506007)(6512007)(2616005)(186003)(41300700001)(36756003)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y29pd0YzbkR1Ylc4NFNrTC9Mc09tcnEvRGhQbWlKYy8vRThWNXEzYkZMOWVX?=
 =?utf-8?B?ekVyb3M3ejF5U2hDekVCKzMvZXBoWjU4ait6M1FPbEhmYVRRWFBSaFJGcm12?=
 =?utf-8?B?NGd2ZjlaWUlEakZOQmxzM2pKR2w1WXo1aGZYQXV1ZW1Za2ltd0hJUUwrV3E2?=
 =?utf-8?B?ZERZRytrZER2eGZwSndqTk9oWnpMSTROZWhUUGFCWU1LQnpMVEZFZTVYTExv?=
 =?utf-8?B?Y2RHa0ZGamErSzRkWHNMcnF5dWg4T0ZKc2RibVR5K0lVRXBpNW5oRXJFQVdw?=
 =?utf-8?B?VkUwRTYxVzhPRmNFazZoajhOdjJSaDNZZW1lZUZYdHJOYXRKaVdwZzNYZUI0?=
 =?utf-8?B?V1R0Z1g4T0dMNERuMXQ2L3AwN1c5VHJwb2ZSa0kzV3hMbVdNYko1RVJoME8r?=
 =?utf-8?B?ZkZYVGpCZ1JIV09uTkVJU29rSmNWK1V6UkZSeDNJclZRUVk1LzhXbVhjVnBq?=
 =?utf-8?B?TWhrMDR5cnZSRGpVem5zaDNMZm5BWFIzaE52blFLZzBPS0tGdUQyTERIeHlX?=
 =?utf-8?B?ZkVxZTk0V1poM3owenMwWnhXWUlDK2FBd1V0RWpwS3NEeTBHTWowbG10Lzgw?=
 =?utf-8?B?ZGREUEZMVWtSOGNpRmw4eTJ3UGNpY0wxMVM0YzY3Z1ZFOXB0blhBV1JkZldl?=
 =?utf-8?B?cUIrQzh0V051RWtlVjZLcXNkQlMrd01lSG93QnNMRjVnL1l5V3FOUHdlM2pn?=
 =?utf-8?B?SjUrTDhSSzdPcU9ndU1ocmtNelBidUtmZGxKei9JMUlOVHgyWG1yYllPRUxL?=
 =?utf-8?B?L09za1lVTENQVVRpWXVua1ZjKzMzWkxKQUVDUWpQY0tiVEdCOEdtS2t2Z010?=
 =?utf-8?B?YjBwaFArT3FrM05jUTFpdFljRytsTmxEOHA0ZjdZRHNHVGdFYzBndlg5b0Y3?=
 =?utf-8?B?SUhEUkdwL0RUVDVQTXEwckNOWmp4WkE0dHhUOXg5N3gxQ3JNV3JINmttcXBx?=
 =?utf-8?B?bGV2TitnQlFsL2Fjc1NtZ3FGcWVMdmpFN3BDUWM2WlNRTGhYTlN1VmNTRlkz?=
 =?utf-8?B?WSt5UHNBU1BCYjBTdVliVmNreHZENkFyTCsvNkdoVGc0WkhrL0p5ckpNajRr?=
 =?utf-8?B?RVF5UlNYbHgwVzNUTTlZTENhbXUrUDJ4b2RzZlhYUDU3U1J3eFJkYU9qMXVl?=
 =?utf-8?B?c0ZSZHB1MytBTUZwV2JvUnV4MlpRRnBqTS8vbjBJSktHc2ErdlRpRHdnbjZv?=
 =?utf-8?B?QldjZXU1bTJhZWhUL3FTdEg1Rk1FRGRKVFZPVHZoNlZ6TGxCMHViUTJuU2x6?=
 =?utf-8?B?NWxOSUQremhlcE4xLzU5S0swZ1lvQ2Y0QXVJUzBNYndVQ21JVkU5RmRGYXUv?=
 =?utf-8?B?K3Q0aGxlcXVnN0lTNXc0UlgvQlVkWlN4QWhHTFlrWDVEVlRLZHV6MzZ1aUYv?=
 =?utf-8?B?UzNzdnJsWjE2UjRJVmxiZ0JFMUpNZWpvOUE5cll0bnM5NGlLaDBveE80OUgw?=
 =?utf-8?B?R0RQaklDUXAwWWhlNnFqcjk5OENGUEtpWWcwMFIwdXF0Z2RlRy8yMFQvYXgy?=
 =?utf-8?B?bElVOUhpQitYNWxJNlNmOWlnQ3AyREVPN0JtS2pLSGVGaUJxL0xrRXJpYWlx?=
 =?utf-8?B?b3czMkl5dEE5RzRLWG9RSENuVGIybGJ1cTM3VTVRM3J2bXY2SUx6RjJrWFhN?=
 =?utf-8?B?KzJnMWdkL2dIRngxeGpNcFlpMnRybzFjQUVZTGF5a0RocXhobVNzREREVlZH?=
 =?utf-8?B?QjQ3Ni9SYThYZC9VaGN4dW0xRUcxOXZPK0RXOGlLTFc4VnhNUUFxOGxMQTN6?=
 =?utf-8?B?MGYvVGlUMzZHMlMzZEFkSUtaY3Z5SGVXc29tVUdSQXVpSmJUSGxnMHg4ZUVa?=
 =?utf-8?B?cDdQRk80VXc5RzFyUUhyd21SUU04UXhJOGRPdlZYSkxUTFdKWi9GUUlVNE1M?=
 =?utf-8?B?VHhUbURSUW9GV1ZtUDhLTTU2WjJ5N005bktNQWhpN3J3ZHVxcU9xWVArc04z?=
 =?utf-8?B?UDVJYzAwNHorUUdDd1JEa2k2cjhtajNpWXUwakhyWFFrR2ZibGVQd29QOVps?=
 =?utf-8?B?eTNGOFRrOW1DeGVUb2RLR3g5dmQyM0tmNU9ibkFMYzlpSS9udytpWm12WWJx?=
 =?utf-8?B?V3ZhNXhSR2ErYmhSUXBwa2xTRzloazBYS1NxdEUvS3dvV3A3S2t5YjZaNTk3?=
 =?utf-8?B?VDQyYkVNWmxuV0orek5COGhKSGxkaVlMMEJZNXBzejJTQmVMYlEyQnNpS1N2?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f6468fb-54f3-456d-2e3c-08db3aa2c973
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:38:24.4110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2dauERgHfMwZSWju3J99RFhq+bF0kAB/J21UDcBImoUzCpaairVkdLmcWokXnB24k+O7ec8nJDIUoo4NApUPdi+MxWeKzy2h2bcnd1+mDR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5022
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/10/2023 4:27 PM, Rob Herring wrote:
> TI CPSW uses of_platform_* functions which are declared in of_platform.h.
> of_platform.h gets implicitly included by of_device.h, but that is going
> to be removed soon. Nothing else depends on of_device.h so it can be
> dropped. of_platform.h also implicitly includes platform_device.h, so
> add an explicit include for it, too.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


