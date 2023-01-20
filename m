Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04C1674940
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 03:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjATCOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 21:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjATCOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 21:14:40 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D58EA95AA;
        Thu, 19 Jan 2023 18:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674180860; x=1705716860;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fEqpPiLGlSumKsHmimafj1DUQLAKp/ZTf/J666rXhPI=;
  b=OLIm/4jPqDXz4kGfymQFdCTBpghPaTGVFbSK9r4gAe6pLhRYmgFOQ2A+
   qZiIyYKOihKstfV7X2NbJ16nNp9VvHjYze5h4asRxH5EMrjS/yaqIkf0I
   78gCH373mySbcqz1Zbsb+jCFPJt+CH4r9kXoeR2+124dZLZO728XQUsTt
   RtAUOdmWUyMZ0S5laP77ziBLshGxzpc0ejBf7yh95KoZseoO0fIj+oInV
   WLI7rmK40zKLPaXkiUDNRzXjA/UkkqrvghoW4idi6Z4csGcCq1xgZhRQz
   VSbWqQSvt6UjqkoMECWxMx8JCc6BPf0EeQMXlDQYKQOChhoDeEdby9AGx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305164464"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="305164464"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 18:14:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="905813235"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="905813235"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jan 2023 18:14:16 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 18:14:15 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 18:14:15 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 18:14:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SHNRt4zj90f4XshLW9bDdqC06lYfMMqBinjM6SlmKSpQpzPiT4UgjFWU3zF2S1w7oYFhG+BlgNPBqF0uGh2Fb7mBBh7zfambVdwMB8w+bzmssdbTjYt430G6extYbDcy5HycKk3R/L+4TJPtw/0gHv57t8uYuQ48am9rACBuSLakxMGlO0rljrlTMebp4AsAQZIRp33mougtXft3tfHbqKZTTYHkhtAy9ydblxdScKJZMEt3gJP3SIFSVJylTc4jE3xysf8fguNpX3i0LEGeKDDcflAVUJWx+5HUGkW3v8NC4lkhoilzGX0prqCmToWB7NjeuZSyCBOd3m2lQoDi3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHrJqgeU35fuF9vsI5MlIcXMIp6n7f32Y9G97MiCNv0=;
 b=i8ywWjweUNWznVTfSpMpAF+4cImzxjOoqtU8yxpuSUPbJmKJ9OX4HYOuCy4e8EsWvkMcpwYjRBn31GOGQaHXGMsaasUPZZe2xcMjzL2DZnPq1Pr5BDkCtsZfgKE8VcWn4ix2UhuZAE2M18pqZ0MtVnX+63c2sVf8k+CO6FUSAY91aBafdznO9Mf03IA0xuwvCyhlVF0NleNv58SAQ0J3hDmUyqAvEdHnA4qS+FRXychY3tCnTJocjFLiV8QuG2mEL3q83KQyCNJzU8w2gmDQS0+VIV1XZa2TioSU3Sgz5KSJcFcNrYatE748Qql9wUSbftveE/uDKqsO9+KJJ0cMIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by BL1PR11MB6027.namprd11.prod.outlook.com (2603:10b6:208:392::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 20 Jan
 2023 02:14:08 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e%5]) with mapi id 15.20.6002.026; Fri, 20 Jan 2023
 02:14:08 +0000
Message-ID: <a9f0f4cb-ecb2-62ba-317d-1e54252955da@intel.com>
Date:   Thu, 19 Jan 2023 18:14:06 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net] net: mana: Fix IRQ name - add PCI and queue number
Content-Language: en-US
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        <linux-hyperv@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <decui@microsoft.com>, <kys@microsoft.com>,
        <paulros@microsoft.com>, <olaf@aepfle.de>, <vkuznets@redhat.com>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <1674161950-19708-1-git-send-email-haiyangz@microsoft.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <1674161950-19708-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0260.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::25) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|BL1PR11MB6027:EE_
X-MS-Office365-Filtering-Correlation-Id: fb0b6e48-6eac-47c1-c635-08dafa8c0347
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+VKj2RHO6t+J9pgsHVW1RHrSTdr4g7nQ2xWprtHwDlB+WL0SDvRcnjyjTPqYzy6qu5wLXWFtllNZhqDkPSJ9vjvALPU3Qk/1XFA+e1L3pLYjlYqIOOpArARZFmsAV5BNN5EiLnlVeetYcqYTcA8HL1mxkdVALyKoo7VQhkv14hWsKz1RhJweDZPN8UUmtDBKuiSqbqcvR5WXwhCzZnxCcKJ8ZLf4j8I9lMNMraxt83rvfb3dIsdbe+LDgMCfeBhx8O0oCpqU9Y9lzFQbXE5/FUE+byF2Tnz4bbcBhIT6OcJJXo/87XahoKsigr2/z+1IbgVyU+k1lTlRHnsnNfcfPK8bWuwg7Xoq+QXaOIAn5hMfPh3R2VIKEV5fT+iC2+j2MCJTZGhp6gBhwyJ0JBMmiQcUEFPOZ42mWZpzOYykZSIdrZFCeQ+6pczjMt3RLco0/GWa3LbUiwCIe+r3/59y/wiiO2DAPSiAydHNSTcaF/4IKhsMJbqaFFGeZCNBNMLVfjVUe0Zp0s4bSVPdX7e+JgqTD6nfqsOkjrLOrtkqnd/TSSHiUxXvBiMgJrdOgQsXV92JY0uK2NX3DhiHvXYxcW+0LsQZLjQjMDRgVvdQ6SPoJDXUlVq18BO4qGCy/0EYKB3i8K0OeE1Dju28CViTHtE1bWabyzWM4qAVJTbmo5ZknBoyJut/MpK2Mzj7Cak/Y0XyRvCkFLTJTG9yqKY7RDeUjIRMCyP2ziYNrMZi/s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199015)(31686004)(86362001)(66476007)(44832011)(4744005)(7416002)(2906002)(8936002)(66556008)(38100700002)(31696002)(5660300002)(66946007)(82960400001)(316002)(478600001)(53546011)(45080400002)(8676002)(6506007)(4326008)(6486002)(36756003)(41300700001)(26005)(186003)(6512007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2s3N3puRi91ZGxBSzVKU3ZzR1J2NWdSUnBRV2NISGF1cWNiV08yaHIzTVRY?=
 =?utf-8?B?NlVnOE5udEE3SEFOQUxUT2J5cmowVzIweWdhSWZKazJCS0lBVHp1c2p1Ny9o?=
 =?utf-8?B?QXFubXljQ1QwZ2pBTndWbVQ0RVBHdjZyZnlBRzZ2a0Ztc3F5Z3AxTGt4VFBI?=
 =?utf-8?B?YVhiUUVvRTl0d2hDekIwVE9wM2ljSUs2NmNSaW1CUFBvWXJyc0hFUHprY3ls?=
 =?utf-8?B?UGxjZmJQY1VtejdUUWRSS21YaXloS3FnajFNRUJ0by81RkpHVjYvZzR3QXlI?=
 =?utf-8?B?OUJ0MjJmRzJaYmFlMUtHRVFjM3ptbTVVaUF0UU96eUlSZmVHa014d0g5elpz?=
 =?utf-8?B?aEpEZDNNcG9pK09MQzdoNjdLR2NTZTBWbWVSemZZQ0FrQlMxT2cxR1ltYUs3?=
 =?utf-8?B?OFpjeFpzdS9ScTJpZ3IzNkk1eStvLzE1MnZtMjB2dmkvOUpBY00xd3pJMDRx?=
 =?utf-8?B?K0tYL3BLZnFZdVh3SFNjMStReThCckNtQmwzN1hDanVOeDAxWkZyVGUvd0Vu?=
 =?utf-8?B?MG1ObHZyZjZmMURsVFhnZHBxc2tMWU5xRlB2YVZrVE0zZytaLzVuOThWVVRS?=
 =?utf-8?B?enUyaVNJS0Q5cGNqa20xYlpIUGtaQzJWTFNpNkFvUDRmTUhMOGM1QlNZUFhk?=
 =?utf-8?B?WmxiTlVuMWc1Nm9KQ3c4YXYyb3V6ZE1tSi94YS9MbENtSVlWK01wSUYrOXAw?=
 =?utf-8?B?YnVrNDYrQ1ZhL0VNVERhNHVYSWlDTFRGVmQxejM1VmJibTA2d0ZRSisrcHhI?=
 =?utf-8?B?MmdQa2FRQnVGOG1xZ2RQQVJsRUt4M2NFVlZiNGZSYmpUVkw5cnoweWNMZkEw?=
 =?utf-8?B?aUd2WGdrN0x3V0VDSG1NUmt5ZlJZOVpYZ0NhUDFYdHcya2JpRzFCSXFCdGkx?=
 =?utf-8?B?WncxSHh0ekRxVWVFMzFGbVVRVkt4N1N0bjZuYjZYMFlVSG9MRWZ5ZVI5SGk4?=
 =?utf-8?B?QitkRHRka1d3bXVrSi9UMm9yZExpYVMrNjFqZ04zaWIzMWcvN0NCT05CQnRx?=
 =?utf-8?B?c1QxblB6MlpLb3hucHZGNlZFdjFmNVp5bDg1UU8vYWNEODJIQjQ3WUNxOUk0?=
 =?utf-8?B?Yk1NU09jVjNJRWJ3c1lDWWROVGVTa1dtVmNkQzFDZFpqMTVtUUViR2Jhemts?=
 =?utf-8?B?YVRnNEpUTjNRNUNEcmM3TCsxWTZsbVpwa2ZHam5oVEd2T2kyUytlZlZuaUc0?=
 =?utf-8?B?UXUyT09QUGY2b3dpQ3dFb3ZycXlQOE1SMEkwSzdYa2VVc0RSVURZOFpzQkkx?=
 =?utf-8?B?V2JPKzVDcFBQMno2dWlpL0dVMmlMU3VoV3FuT2pQQ1NlaEYxUXNHTXpWMk1U?=
 =?utf-8?B?Q2U1TzgvOUhpalo1R2w3ZVJRUUJHYk1XSUpuRDBkbXZtd2p4ZFV0ZmpFdU43?=
 =?utf-8?B?RWwwczVpbVlvRFFIMzJuYkpESzZzTXFEYWlGRWhzMy9abWM4NHNJQ0hCd0tD?=
 =?utf-8?B?MUt3ZC9vTW5QV3JhcEtHYU5JbjRRVGpBcEN4MEdqcXZZV2QxOE5tU1JqT1ll?=
 =?utf-8?B?MmJFUTZHYWdIYkFPdllWWTZENWx6dW1ZWXdabEIvY2Y1cUg4V1RwbEJweWQ4?=
 =?utf-8?B?WFV0QzAyd2crV1Y1dDJlU1JuNlFrQzZCNFd4UDVyT2FvRXFFdnp4dno3Mmxq?=
 =?utf-8?B?NWdOQjU1cWRHeTl3dXR2VzZhWE9Jb0p6dUgyNzVCcjNhYkZ4TEtrN3NtRzdQ?=
 =?utf-8?B?MitWUTZyZ0svSW5TeEdaMFBQNng0aGI4aFRrTU5pVy9zMVVPanJibDhTU0pi?=
 =?utf-8?B?OS9LbXd0MnVvdlFuS3hPVUo4Yk91WDJKbFd4RFRvcGUwWXM5WlY1Z3pubnpo?=
 =?utf-8?B?bTk0RjVVWTlMUXhMSGJtQjEybGFGUjNkaXl6MTU0QXdnd09JVk5BL0xjSUQy?=
 =?utf-8?B?VUlPR2djZU1mRk90WXptY1V3WVFpMG9WeWVveDByUHBnTzdFc2hrVWk0aFBh?=
 =?utf-8?B?ZUlnemtNNnlpSmlPNll4WkZTVFlSYTZ5MzdxMjBVU3N6OVc0UGtOYkczTXRS?=
 =?utf-8?B?eCsvdmpCWHJmQ2Z5MXU4dzhEWmZhZTgwaGRGNVQyV1h0ckhaVFV4QWpHTVV0?=
 =?utf-8?B?djV6MXlGTzZZclhzWXV0K2R5OFh6QlA5akFEYlV6OWNZOS9HWEtHQWVIblJu?=
 =?utf-8?B?MUJ0by92OFZnWDlvMjI1WW5qM0UrVXRXUlNUb0g5N3VjeDJ6SkI4bUQ4dmJo?=
 =?utf-8?B?WGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb0b6e48-6eac-47c1-c635-08dafa8c0347
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 02:14:08.5622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWZjceUmyvEPdfOJSPjKBvWyZnir5sbze73OcKqbxaF149vgw/QPH2fJ/duWiPrhQvUlmIgXx7CYuimlD9Q6nWz/Gv1yccDzmmgR+L7/Dgw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6027
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/2023 12:59 PM, Haiyang Zhang wrote:
> The PCI and queue number info is missing in IRQ names.
> 
> Add PCI and queue number to IRQ names, to allow CPU affinity
> tuning scripts to work.
> 
> Cc: stable@vger.kernel.org
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

seems reasonable!

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


