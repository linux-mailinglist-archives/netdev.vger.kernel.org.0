Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB216DE820
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjDKXlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjDKXk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:40:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCC8468A;
        Tue, 11 Apr 2023 16:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681256458; x=1712792458;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q1OKzzxSdwlKhjiiMHlKDiWfhXF2mnsjwMMJw8QVRSI=;
  b=S4eTgVcc28iHKgRwc+Eb187HPNX+ZYtws3Jc0celMjTpoh7Oi1wXlire
   zNmlNPb5GB+xquP+cxVghmy1TuPlhKut0KPCdy5uGRedSarOf08uH4P/c
   N9jKjwHYKggL58Z8ncD6obFKa1EvVgsmxGdCDdahl9jKYUHWtCEzUH68a
   t6YjmYeRh6jciike97eMIVUiq3mqVOq9i0YWWrvc5OTCCXIIAG2reOojP
   +iDLtRO1EHiRsIC9swLrCJigQJzbhHNNfSbxUqFkylUeu6FezEwusop2O
   7n+NCdUtI5evs5cy/RCEL6iOToxDjitB18FXqb7KqhMUcpv8SpZ+Jvy3f
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="346435439"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="346435439"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:40:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="666139136"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="666139136"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 11 Apr 2023 16:40:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:40:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:40:55 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 16:40:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=et+tQ2/wWPWK8J1TJX8DfT0lG3dYxB5gTKdrDQsOdJRaRxG2anbuPp8LLED2/RTqCbTT/pxd4/IwPgetmVEnPUF0ql1KHeEgPmpt+MFmb9EfFUQ87T74+fdVkdp7pjMtA+rmc2ZciROxZ/ApLRvRUHmw4xKPz9d56953Ai8tTHWEzeJR3882KFEQ0SZd1s/zHSFPskNG1ZnxKyOYryNvedlIj0c5tNrIkdwL5Kk20jFiZk1sL17mEe/TH56AxN7dPyWqDh0zA31eF4PO/CK56Ql7NkAby9W3lJ78Dx7az80irZYjf6GMUjRk/oUca/+kN5SW91cnHHGa4wtStf10gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PD4V14lkdFnxkGHZcmOSq2TMZO9xcwKrbKOnYmW49I=;
 b=FLcn0Oxg+8c2R6wONYMXoSj8SFXzTWDxtuBrdBPWvnEkdGRzbbKVmbOe7zqFHiSevDrmfNO50lWohqr4bbRmon/AztjzHwU+VoVskUJ9ky9EyVN4e9A2f2eUvEF85qXvT71FhHh3CrCMKul3efHKxQ93PYipBxN/9y8rUZsIaeCCmZBvGHHGqhzGi3y+3aZz/DFmwjCYDm3G01kgJkX8y0dASJZ8OtvSnGMvjVPGrb1+MMY03Oz7wJA9yaWFf6cNZwQ6qwqEezQbVGKhNJaGMBchBuzm6ENumlXlSLsZGCnqGGGslDrl5/aSCDy57UMjKDJ54fnhpTUM/5gTd46j1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by PH0PR11MB5902.namprd11.prod.outlook.com (2603:10b6:510:14d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Tue, 11 Apr
 2023 23:40:49 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:40:49 +0000
Message-ID: <e99ad5a8-5954-7369-d46c-002a2e94554c@intel.com>
Date:   Tue, 11 Apr 2023 16:40:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v4 05/12] net: stmmac: Remove unnecessary if
 statement brackets
Content-Language: en-US
To:     Andrew Halaney <ahalaney@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC:     <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <vkoul@kernel.org>, <bhupesh.sharma@linaro.org>, <wens@csie.org>,
        <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <mturquette@baylibre.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
        <mcoquelin.stm32@gmail.com>, <richardcochran@gmail.com>,
        <linux@armlinux.org.uk>, <veekhee@apple.com>,
        <tee.min.tan@linux.intel.com>, <mohammad.athari.ismail@intel.com>,
        <jonathanh@nvidia.com>, <ruppala@nvidia.com>, <bmasney@redhat.com>,
        <andrey.konovalov@linaro.org>, <linux-arm-msm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <ncai@quicinc.com>,
        <jsuraj@qti.qualcomm.com>, <hisunil@quicinc.com>,
        <echanude@redhat.com>
References: <20230411200409.455355-1-ahalaney@redhat.com>
 <20230411200409.455355-6-ahalaney@redhat.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230411200409.455355-6-ahalaney@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|PH0PR11MB5902:EE_
X-MS-Office365-Filtering-Correlation-Id: 259e639c-6da6-4679-69cf-08db3ae62dba
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uTc7yja6cXfaAsA9P0n7bx3NZ9dLqH2c+OwmSLA9f4I3OpukxtGaHGtykAaRTEchdXfel9lyh4GG6u6qkVMoh6COk9SXJy7szmDeo1VKgRUpIuP5PF4CIHN5uhN72PVKn8k0tZNGXhwmlhLnG3ol1HdkKoQj4tlywTeeGawG6YPTQZiWoNJaaq2+5tirYzTNcqQqbKVVH8kh2YvTtdtnMfvf8wFse3okc/QGttKCDWvKnboA27ojYIAgansTqgvYzCXo1f+b/EW1YsjWTMS4xVa1yWw/S1ZaNSV1sZF0T6tchVVe9uS5v0oNAzLHQRVdCtl0Rua3hi78cR+UeKTDlikgpExC247SpjrMeFSph51QaQw7ffL/wljZ3eNFLofKs+T8J9hG+Hi3nJOKiWz9PSzWmJ6ABvJgs5jYoDJVqy+w1iOze4qgYCYlcnaOIxXBuf+NXIZWwwwUUpCiKVvC/wC6apSOjx27rvaPLVsustD6OWOWZ+LzgvhhcLvivzGtP6qo01g5OeVBWXH07Ii9fYGxFhltyjVE4L8UoRk0+wgfo94EuzuEENj0sNaVELpCFVR4NsztzzcGlBwkCOXIyI2M7VbA1WJCm7gDDozAjULugX3m+9bocOsaEg2vF/N1zLXyjwFtdZOsevj/XC3WoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199021)(6666004)(82960400001)(2616005)(478600001)(6486002)(26005)(186003)(6506007)(316002)(6512007)(53546011)(44832011)(2906002)(558084003)(7416002)(36756003)(5660300002)(38100700002)(7406005)(4326008)(41300700001)(66476007)(8936002)(66556008)(66946007)(86362001)(8676002)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlFYSmpzR0h1bDd4M1FwV0FzTjBkZUFrNEdQUGVUWUlLMGx4Q0lnVWVyakJ2?=
 =?utf-8?B?K3BUTy9yZnVUVWJETmg2R1d3enFDUVVMQVJzSHJEUjhWYmhFaTZqMFFDRHAy?=
 =?utf-8?B?SkFhV0toNndlbEdYRmZub3VTN0hJd3dPUGRmamwzeEN4cFRWT2FLRnFBaDFC?=
 =?utf-8?B?NDVsc3Q3TGlmSmN0WEd5MiszM3dpbWJsdDh3MnV2YjdvamZyU1RST2EwM05j?=
 =?utf-8?B?bEZ5ZEk2WnZVd2VvR2pLcit4TlNXOEh5MkFhdmVseTVsdVczVWpUemNaSE4v?=
 =?utf-8?B?OEtETlZyMi8zZmRISlRUQmp4dFRUTU1mdkxicm4vQWxUbWNDVm9DMWRvcGU0?=
 =?utf-8?B?YWduOHVBZGFGRG1zWksvRXNYZHBnOHpleTdhUmNyTFFPcHpxczJsaDVLK0p0?=
 =?utf-8?B?UFdVUkEwdGd3clRKc2NLbEtkbXdjN2VXVEJZbkIrMnVtNnhtZlBPV1p4U3ZK?=
 =?utf-8?B?Uy91MGVTbzNYQTlBajNzR3NJeWE1cVpaMWM3TWdhNGhuaGNQZG1jVGhPd2Z6?=
 =?utf-8?B?bklQejJyQk52cVU3S1lSY1VqZ3Q2eGlsYnUzUldkako4MHZMMnVaRnFKdmxD?=
 =?utf-8?B?VW5lc0w3a2xaSTJQL210VW9oMVJiQ2lNQmhSc0VmQm9GNFpaRUlJbXFDbndq?=
 =?utf-8?B?VzZzN014SVpPSTRUYjM0YVI4SDlzekp6VEdVOWNTMC9FemJSWkRQaUliRnJq?=
 =?utf-8?B?NitHQXpJZWZRWlMxZnY2TjFsY2lXWEordzBjZ0M2eHhFVWNMYjNjTUJjOHhU?=
 =?utf-8?B?aEhiWDBxNER5akZTbmRmaFVYTDZibjJ3YWdVZHF0TGl0aFpoblQyM1FCYXEz?=
 =?utf-8?B?T1N3Vy9oS0tJNFBtUTNXK043TE5EOFIwQkdjdWNxVjVpQkc0cUMvbkZTaU1B?=
 =?utf-8?B?MUVkSURtcUN2enE2T3dZcjdlZURRV1lOMW1xb295bkhSdjBNblA1Z0o3ak15?=
 =?utf-8?B?NHg3NmJMSWsvczNmOS9IZUpoMEhsdTMyK2kwSHUzSEhjYnV5R0Y5TFJuK2pp?=
 =?utf-8?B?SUVrSDFCNTN2bGo0QTNrdk91RzJWQzEwZkprRlc0SGg4YVFFTysydUxKWFI3?=
 =?utf-8?B?cTVnMUg5cGNSOWsxZWtvVGp0UWsxUGZNMlgxdVRqZWZnQkgzaFdlQUV6UVpz?=
 =?utf-8?B?bG8yYmtNbWg3VHFPNlFONjVlYjkzSjNlYnovRUNXaW02WEJUbTZQaExTT1Ro?=
 =?utf-8?B?OWdnRjhISCtJVUR0cHpxeG9LbzB5RDVYc2h5T1RYRnZEWko5N0VwV0VlKzFC?=
 =?utf-8?B?UVdJWkg4dHZ1cDA4MDA3Zm9GaVI3bjJXejVXY3dpY2JocEwrTnN6UXdpVG54?=
 =?utf-8?B?V1gwWUtORWZXOC9iRHdEMi9OYmxmWjB4S2MyV3dkRW41SXFxVG9oblFxT1V1?=
 =?utf-8?B?UFNYZWZCQWM1Vk5rdVJXU0JoTDN4N0s0V2FlWm93NUFjdE1TNXpyS05vaVY1?=
 =?utf-8?B?Y3U3MW9FRFpFMXA5TFJxUjdVV2t4ekJ3MUFiekl0NGhtUVNNWXJDTm90alpy?=
 =?utf-8?B?RGVESXdDU3JBMlV3RW9jUFI4aTZzbjF3Q0xXcGFpUlRNOURsR1pBT3VOZ2Va?=
 =?utf-8?B?bW5lYVoyemthc2l6aTdkeGdYYmVkdVZQcEpodmUwMm5TbGMvS2JUTDZtYmUv?=
 =?utf-8?B?ZDR0bUFOYUltVjZlTjJwQmd1MHppOXJ1d25sd0Zkam1oMHNrY3BobnB6THNM?=
 =?utf-8?B?RWhUdUJ3bHhlWHdka0s0V1JxN2l3V09DTzMzbnJLYU5YTFNCc1BXWmRlVlV1?=
 =?utf-8?B?MlNKbkN5RDlZdm4yUmJLYkN3QjRiV3VzNVJtN1ZvbWZTa0EyQ2lYdG5Wamp6?=
 =?utf-8?B?ZnlOcmZoK2JoQjBqWitZVVZ3eVA4cEw1VTgyYW5OcFg0RCtYMzFNSEhVVU1o?=
 =?utf-8?B?Y1FqQkRDVktRZ1ovcU53dGxycWhOUDZpZnVVb1JQbTR1aU9Kb01VY1FoQWZB?=
 =?utf-8?B?a2JYL2JISU11cFoxcGpCR2VCaUNFWVZ0VHhCTE1mRlRUUEYyR3ZNTW13cVJu?=
 =?utf-8?B?eGJJYUdHR0J4MXFHYXo2R2hLRU9KSUpTWHNUVW9JVnBrc0tVcXd1Nm1ITzF3?=
 =?utf-8?B?ZG1sWVhGdUVITXhYdXZUckd5ejM3OXZKTytzaDAwWHNma3dLMTN5aExtTVZR?=
 =?utf-8?B?RU1IWjdtWUpudzJaWFVXU01tbm0yelJmdnYxK0srVEU2RWxIVWVZRjNxdjI1?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 259e639c-6da6-4679-69cf-08db3ae62dba
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:40:49.0790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6x4VGSAaL1TPCuCcN72gKbAnFADqj7rkiyvD9KKii7FMkrqFUORr95gSZBo7abjyAAgZbb2TF3MWC+VCy9LtUY9ZC4CEB5db4GtySzFYg0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5902
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/2023 1:04 PM, Andrew Halaney wrote:
> The brackets are unnecessary, remove them to match the coding style
> used in the kernel.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


