Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CBC67476C
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 00:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjASXtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 18:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbjASXtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 18:49:02 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079C9A199D
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 15:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674172124; x=1705708124;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bFRzdWQ84ZyESSwesyS/IRGMErybJmetJ33RI+COJQU=;
  b=Wrz5zTVSze9jMDB0xfzpI3jDXFY1YYlTSc8IHBsMiMZm8nnSH6I+ITU3
   QbP+5k0czwHTnMw1wf0ZQ9kJuDW7Hk55ChLg/S9GwpZ/OSUzpwRbQklg0
   tp+VNMD450hpeMdsiYN2GUxpw7QqRmPL/JT4V7GIzYflZxJn8QKJBKkcK
   RTfYcEFABzkAq4b+7GQ8/HwficCfSatnhA1zshr9/hcyeUljaieUQGCk7
   VGiskNwBMOXq0s7ZifeH1YFq+rPwQAi0ShPQT0/IMU6BzdN5+MWCMxF9G
   7BrRkOdTDUkZZ7T3aciHaALq+eFowJ4UObwBHSWEfTxjiJwmPKEI4KHR3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="352719458"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="352719458"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 15:48:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="749135184"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="749135184"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jan 2023 15:48:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 15:48:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 15:48:43 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 15:48:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwT8QYwSchR5hqVUkTAdxvlhMRN5mP3rkco/EuYuJ00EJUqSJBEBZwy1hjixVFmPhv8R3Yr+UAYCJjiIPq7O8/cKLkD+xuCmQPEX3aAgugiijWtl2qJrZUIGweHHORi7dIugg90b6vNaADd9at8yudq/UHdcCseii8JVnkocBiJQgNUyJhxvfHFa6HhnO7AUqBXVfpdTvMlUUvhEYpYfOlx94oAboSrGTzsbrINrxRWWpnmI8mQEMpBFBZznp0VgQggxjntfKaLchkY1EHNUtQ5dAWf3+roVsd+FkK2ZzFp0bqF00V3UC81g+S8y9t5BTqCHYN8Fqj07c77HGf/OzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJGDail7rPIg936qL0vcO8DPD/MpS/P5HBTz5PcdoCA=;
 b=izy8qvm1dg2PrvzR6Cco3unE1vgFiHCd9AD+cBKXFxTt6+FkoANKSuVZjuc1aQreSoy3BjC/0VAlQmJbGjEAMKbjFhLu3QbUx5J8DeJ2YoyJomRO0ht7JayEnd5bK+bMcd/3FUzVoYKWzeXuEo+sQ3X29DMhAz8WeW0Xl96SMPvFZ0l7j/x0BlivvU3hV+eNRyrLCxM7bXc/muPIwjmLutgKT1aAiXxqtEyXnv7vgJMTHYYIPNA1m3ExL3b8Dq30QDAPkKrUG0rExi/3ENtETDifdD151gzfk9micdLLXdxNNMx8MKmaSpVwce6K7GG/PQyPNP2abzbQq6Q+nktH5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MN0PR11MB6184.namprd11.prod.outlook.com (2603:10b6:208:3c4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 19 Jan
 2023 23:48:42 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 23:48:42 +0000
Message-ID: <f6f38dc9-cea4-d328-3657-c48ce7feabb1@intel.com>
Date:   Thu, 19 Jan 2023 15:48:39 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 2/7] sfc: enumerate mports in ef100
Content-Language: en-US
To:     <alejandro.lucero-palau@amd.com>, <netdev@vger.kernel.org>,
        <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm@gmail.com>,
        <ecree.xilinx@gmail.com>
References: <20230119113140.20208-1-alejandro.lucero-palau@amd.com>
 <20230119113140.20208-3-alejandro.lucero-palau@amd.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230119113140.20208-3-alejandro.lucero-palau@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::29) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MN0PR11MB6184:EE_
X-MS-Office365-Filtering-Correlation-Id: 6942f181-3a55-4bfe-b402-08dafa77b1f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 14G1WJJcaZf8UuxM96h44DxudgUToDcfJyzDHg2r57H7jf0Lawb9KHoBiRP+qITrl6y9vBPabYkjEVpDCDB5g0lp+l61TlxV/vP8uCWxMBrceyYzgpeAIKZ+hcMw2WAXs9BXLZ1O8FA03c79NiERyZOuvCKxbrfr33Oe0K7mOFQ7yjFXDzaHjei+hZE2xP0zYcYmN3aYC+/xZUUmqr3LDnphMxI8RjSvTpsXnsDO98nWHHDBDkL/n+QF43pcwhBZ1VivcCkY4cMpRVN42ZKf4y/kP7JyYTXd6/fy7zD844pA+V9OIwx8gUCWpsZhVMrL6ykKbCDFyr67fLlvRvDgH5ZlnsHb2Lp+gNzXPE3iYrQCjmd+8z2d3pe+LgjSFNwXZ+W9H2kVYaCeKQHgd3R4d2gnWblygw/Ju5npzWm0V2qRoi5RPCwSZnBzPdafimIeZwmK1kF7jC4gBvhdy9lebft+W1lrsr4sCtU1FdsaQhVlQJAI4bp3T6qbh2RtnKO8iOoMbNMp5ojpGsBPcbY+2TtN97dnx//FCZAiBTv0Jws7aolPUJQ+Hw0ZgkgNMgPhkNOBxjD+J8N18/F5SWPdQBHxmfISTVI1PeZU8aXPdBm9EXem5v8lPsutOHlWjOtOsBaD9uOB7w/hDRInRPr08Notl23cx6T5HSyQJvjZx2OpFZZBH9xHjWDp45k4cQITjvOSUl6NA5RXxOIyKsRfJWA9XbfcyPnGL0nJik/3TQs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(366004)(376002)(396003)(451199015)(86362001)(31686004)(36756003)(82960400001)(66476007)(4326008)(8936002)(66946007)(8676002)(2906002)(4744005)(5660300002)(83380400001)(66556008)(38100700002)(31696002)(316002)(6486002)(478600001)(6666004)(41300700001)(26005)(6512007)(6506007)(53546011)(2616005)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3FHNXVtYUlLS0lTRTdkM05TRDFQVG9rdXQzVWJjM1IzTVJjcHhkdFpiTHZz?=
 =?utf-8?B?T3NCbEhLY2o2UUFUek9Ba1FZUmF5WGRwTG91WTJBNzdNeXRRb2JlNE5XTEZ6?=
 =?utf-8?B?NjJlRnFMVXZGcU5WVU5lN2l1ekZVYzY5ZUlST0JTeVBvZ2JIR0lYWjliNFhu?=
 =?utf-8?B?dDdLMDExalllZFhmWlNmL3VYTEsvNGlkdS9Bc2JNbVREdlkrWVhMd1JoY0FD?=
 =?utf-8?B?RmlZVUJYK3JxbjNob2RydnJFNTFENW43ZDZ2OEdTeGd0aWE4T1BYMGtTRFZZ?=
 =?utf-8?B?THh6Mm81NzUrbjNEemtGVVZUV0ZzTlZTVXBkOE1icXUvd3ZSczRrT3JzRCtv?=
 =?utf-8?B?dzNKM21XSzFveUp3TE0zSHZ3TmVqYjFLWmdmT2pteVdFczFXb242SGgwVlpV?=
 =?utf-8?B?VjRCbk9qZDkreVU1WUpTWUVwYUFkQ3dWMXYyRXBTTThZekoxZ1lzU3JmMWZH?=
 =?utf-8?B?SThuUWIvSkJoSXpLV204cFRYcDNkS1FYSVdVK1BqbG5hVGQ1cVFoRnJCOS9I?=
 =?utf-8?B?SVBsb0lzcjZOd0ZjVXJFTjFLRExLeWh4clVQWWp2SjRVdURmaXdOYkFCdWtj?=
 =?utf-8?B?Mk5hK3V0dDFuUkhYTjdPMTJZQlJDV21GUEtvYW4zNDg0cm9BcUJLVWdQbmN0?=
 =?utf-8?B?UldadW9ZeW41aTFJZHZHUnJPc01Kc0Nld3ROS0xydkVJdHpmVVM3cjNpUk5Y?=
 =?utf-8?B?ODFYYzFiRGI1NGdidDBTR2ZscGl3RWZEdnVNa1ZFTlJ4MHM2MVpwYVlVeC9N?=
 =?utf-8?B?NFVjOWdDQ3ZXZHo3b2VWMHZRcXNwaXdIRG5WakcyYjlOMHUyckVPYk1xaXZh?=
 =?utf-8?B?Z1lGOFNRMEo5bDdSQys4dnZmeWU4TFJBSEQrUGNHL0hiVy9aRHpQSXhUdWFv?=
 =?utf-8?B?NnRyOGYxUDVXU1pWa3puTzZDSUdOZmVZNXdaZUR0SDFFbGdMNUFIbHYyeHVK?=
 =?utf-8?B?d2t2dkFaUVNrTXg4WnR4YnF3bEhmcklENENpWk9WTEZvZHZlK05WMzFPWFhx?=
 =?utf-8?B?bURTY3QvViszWUhiaEwyNDJsRk1Gd2dsK3NmNWJjNmVBWnRHREJlWWVzRFBl?=
 =?utf-8?B?Q0RGMUIzYXhtK1YzeEdEZzRJV3NiYzRCTHZ3RHE4bzZqeVZLcVRialNsRHh3?=
 =?utf-8?B?dENuZWlKY3gyZUVlRUY3cWNUdUNzSUs1NzBnWElUZmExTy9EY205Mmp6Z2FX?=
 =?utf-8?B?bXJYV2ViTjRkMEFjWVZHbXFLbU0zU1U3Q0xTQmxTYjVxYXl1UDMvdlk2aXk5?=
 =?utf-8?B?QlJrbWxXUXA0Sy9nTllEcHlsN1RjRVlpR3F6bXNHUnpBV1NtTjRhQnJFSVFS?=
 =?utf-8?B?Wks2Q0ZFam51dnBsQkNTOXZBdENJdm9nbURvWGhYeURub2oxRVRleEg0S2l3?=
 =?utf-8?B?YTVYMFFiTmYxSGl3SXUzK0dwZ2dyVWg5dVcwRFprVU43RzJ5d3grdzNscFVa?=
 =?utf-8?B?anhLQ3d3M3lGemdVQ0Jic3ZMeXhrZkwxamFFaHc0YmhvajBKbkR1bWt2NlBu?=
 =?utf-8?B?YUszeFNLcTRJUXM5VER0WDBFaWxZYVRqa01FMGhkOVMra0tPZUpYZ0xqK3p3?=
 =?utf-8?B?NXFtZnNrYllTaTdjUWhtZFNZQ2VkbG14YWhwMTVXZ2ZrMktqNEZhZWM0NStJ?=
 =?utf-8?B?NHY2VlhncStOVnZLMm5aVXM3MDlDa3BRNytJdWR2U1pQb0RPN3g4TEdZYU9z?=
 =?utf-8?B?WUMvSkZ3bDlqaGN3eHBaMlRFQVZLc1BnQVRoOVQvc0JpeDRWSkVlOGhwZ2dk?=
 =?utf-8?B?WUlmZjFqam9QbUhUQkx6Z29RN2ZuM1lmK21adU9aeWpDMlRnbVNUTVhZWGtN?=
 =?utf-8?B?ZzZacHdGQk1sTlJ1YXQvYVJxdzkwUFg1bUdVcTV0RGVBYVgzc3hrVW9lbGlw?=
 =?utf-8?B?QTlLMENSNU05OVFicXo2OEp6ZThsTG1RQWgzTFN6a2YyUDU1SkRoV0g1aE1w?=
 =?utf-8?B?QnlwS0dxZThENWlOdHAwQlJ4TEgzdmoxS3VWbERuR29JdlIyaXZ2ZUJ1UUJs?=
 =?utf-8?B?S0tmQWI2YW4vNkt3UmRxbFJpU2I0dDU4cG8zVXpMaDkzSXhzLzQ5dk5UQ0or?=
 =?utf-8?B?cXQ4ZjZnNHlQRklBMVI3SWJ3ZEF3MmxMdk54NkJKTWV1eXhRc0FSZ3dxcWE4?=
 =?utf-8?B?Rk4rOEZBRW5XVktidmRWR2ViL3YwZ2w0UGlxelVRMnlrbXgrUjNVMUsrbTR5?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6942f181-3a55-4bfe-b402-08dafa77b1f7
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 23:48:42.1605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YhLTPigeRkuvzqLBkOBP7oFbU+Uh96w/qf90Xv8Ezn0t23J/USCiT8nJkTT/LnV2l3EHltJ9owPkqBGDOq0EzZAZD4Ss6GPV7vjQocT0nGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6184
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/19/2023 3:31 AM, alejandro.lucero-palau@amd.com wrote:
> +
> +int efx_mae_enumerate_mports(struct efx_nic *efx)
> +{
> +#define MCDI_MPORT_JOURNAL_LEN \
> +	sizeof(efx_dword_t[DIV_ROUND_UP(MC_CMD_MAE_MPORT_READ_JOURNAL_OUT_LENMAX_MCDI2, 4)])

Please keep #define like this outside the function block. This is really
hard to read. It's also not clear to me what exactly this define is
doing.. you're accessing an array and using a DIV_ROUND_UP...

> +	efx_dword_t *outbuf = kzalloc(MCDI_MPORT_JOURNAL_LEN, GFP_KERNEL);
> +	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_MPORT_READ_JOURNAL_IN_LEN);
> +	MCDI_DECLARE_STRUCT_PTR(desc);
> +	size_t outlen, stride, count;
> +	int rc = 0, i;
