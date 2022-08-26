Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EA35A1DBA
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiHZAi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiHZAi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:38:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAE0C7F91
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 17:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661474307; x=1693010307;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GNXXwGfLjvGgzI7jdDLuNJBd8JPzg8GS57MQNtwPU+w=;
  b=BKQIJ0JRR6DaV9N4+pNHYmE2K0uhMyoR2lsJPeSjpTRr03rn+EKBED3d
   QhaaLJ2k6ZqDVIoSmf3PalhY6fIJahV+d84DmpIcAg7mUz3Sfgeet6CUS
   sxvnCFxuwVVOa2wBhNYmd8IEI+KqtfOsm9+Q8lxsL4TYWJNwvVPkljunX
   OgjJ1YV9UkzBfY0cJie9CZj4z3DSNW1OTbnG2xY+/8+6ZNPXxLQZ+UcBl
   QQX4O7NFL7W65skoOzVVRWkq54CSZQc4pOT9V+z64vr1smCPSIsvbE+Rp
   veoHWb87BpHbPNNBTXcic3gPzjeg7enTEjOadwbxScMwM6T1qkrFqMi6t
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="293130986"
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="293130986"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 17:38:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="671240137"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 25 Aug 2022 17:38:26 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 17:38:26 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 17:38:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 25 Aug 2022 17:38:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 25 Aug 2022 17:38:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StpkLM34klzRl6NZOL4Gbsyvyvw8kkg0WckRzkmiGrGx48N/g+xNEcD6jcKk8nSubZ6yLrSrZfLEVsEYfDTib9RyrJZgMCEkSjOClTGwUg3gRe/m8oPgOVI/DP+Szq9qgW7WGIPMNLFPGU/2lfxN4QvPXR4DL4h4ItolTFjBFmbDNk6yd+kqsuZ/DbluAdj2EzVEECR80cZEhwT1idc1KMX/+9tJO3jRfo4D6GUf195nsRCRiUPBQwSXMPr9X3V/1NJktphBQLsCdIqxMkox0LK+1s7U9tnVDMZKyghcma45BqPzO81dPgAuK9oqAFd4S7Qinvu73ULqCigaBDfwBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5WTg3g29NhhwXRzP3TOzuGz1saI6LRi1WWOFElrMbm0=;
 b=hP0rHrNtz/wDRiKwiDCziCa0ZnPPEDMNBUQsZfOYvydq9DmumngEYO230h7ji6OPLL1UUpWr8YDTfxT0MJxcDHCEMMk3P+LZgQxFqo97NqeRy3fI944O5LKfecIm5eHhr119SqwnFL+dYHJJ25PbaHaGkhVxvwgjAwYNp0ZT23XdYzqwauwWSbtDOksfLKlKhCwO5jsb3+UiKO8JZDs9maq47eB7GCJrEH4uPAYPQM7EfxhPv/vs5gG9xjX3CUbqLrNbQAaJGK8b05rL+gge4KG80Hsd3+7BInt3qOzG94F0xuLiVuDtX40TJ0JDjOUcMGYY16p2Ha8wESksdywRGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BY5PR11MB3975.namprd11.prod.outlook.com (2603:10b6:a03:184::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 26 Aug
 2022 00:38:19 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 00:38:19 +0000
Message-ID: <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
Date:   Thu, 25 Aug 2022 17:38:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Gal Pressman <gal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
 <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
 <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
 <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
 <20220825092957.26171986@kernel.org>
 <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825103027.53fed750@kernel.org>
 <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825133425.7bfb34e9@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20220825133425.7bfb34e9@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:a03:40::20) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ee46db4-9f0a-446d-c848-08da86fb459f
X-MS-TrafficTypeDiagnostic: BY5PR11MB3975:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nWOLTnicx4L3xKqfPNS1tOGdMK9uDTYP8IuEvLpL4FsucqYTzCXhQrErjsh8kmbNATl2TTLIJxnvpJxU+/XGW8PBFyyuvpAyPnxNRi7Wr5xsBf2ubrGxGnlS1rEztCc4+m3/mok756a1HH+SQOXbz6xoa0HNkscnMr0XZrtkhgwDuMEDnnbNe2v+vWKX5pa/4xc1IQIMkkGSkcClP1t0QwUOydscWyqjESDlFIpuzxj2S5MAtacuZgkHmGy+cU0eOJhrk6kuywi058QMrJMxIfmfliyfaePssZ3zxajVt9FcHKUc0UfyLLZy1reUP/eKiHvsjScs4EyUYuiKslTmhLBWB1SG+wtIz5/KN75HzoGsV11BNLbo97c9QIR/rP8ASDjuyGGOUwg4jxKymZoza1fJ/gwspFdoUczYRP7Hz2mSFmsfBh6p0QsYDsNg8hjKdqtG6GXntekJgeyGH8UKd2Y+g6Dvs98DLOQli+obWtcTlDdSBhu30w2VRmWbf3neD7sKMkzEbagqXasccfKMckcPcT0itwQgJ2xE3Ae3qKjEryRl/CKktv6+n/f948qwUE2UiPHHknrlEvVviWG5PaeIOZOVYWA1TIDwlZbWYfYio5MlVcapIF8vOERsnv2zTQPDasfvuAB+YIlF4cqnQDCmJNmNeGjWYiO6NeSvEI1RBHc2qmrrJsuFsTIA//wmjGnxd/aj+V4MtI6abog1Lf/f9q7tPioLDzwoQCMbDQM5gDhESkenF9RSj8Zn+Nxi/Zxjvlkj2ilC2ccs9gsfCo4yjYs+Z4GvUGzCot3x/xU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(366004)(376002)(39860400002)(478600001)(53546011)(41300700001)(6512007)(82960400001)(36756003)(86362001)(6666004)(31696002)(186003)(6506007)(2616005)(6486002)(83380400001)(26005)(31686004)(6916009)(54906003)(316002)(4326008)(66476007)(38100700002)(5660300002)(66946007)(66556008)(8936002)(8676002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDN1cGhMbWxLQ01CUVJwb2p6ZUZ6SWlveEU1czVvaUpQVFdReXl0Z0gzTTc5?=
 =?utf-8?B?TGczR20xcXg5QXZXRW9Yc3dVSnl0djg0a2FsY0xMRy9SWnU4ZFVvTURDYWFv?=
 =?utf-8?B?Y3FyeVEyaVpwemdTcUpxNkI3UHFSV09WV2ExVzdwN1hUbVdNMHJzRGtBTkRH?=
 =?utf-8?B?cldHM252cFcrcHM0VForaHJRaE9lZW03My81bXc0SFNLMUNsczBWbDhPK1da?=
 =?utf-8?B?aUpTSklPZ2k4VmxVS202UnhLSzF3VUtRbnJySzB3YzFPRDJCNmh6MTdLaWk3?=
 =?utf-8?B?czg3L21rSFZDbHlPV2tDMEtBVnlRVXlTR3l5WnRXRmsyM016Vzc4YnBNTzhH?=
 =?utf-8?B?QUxlS0lRc0xMQkJlODltaGhidVhKdHVwdFVqMjAwYmVaYUlVRzVCTWJTTTVR?=
 =?utf-8?B?bFJhT1AxcnB1NndtUFdGcU5jZW05STlSOHdoTkcwRDhCOVVna2huV053ZkJr?=
 =?utf-8?B?N25UcmRvak45NGdodm1VLzdnWUxqWW1aTndYUnZEaXkzZGVQclIvMWZNTS8x?=
 =?utf-8?B?MUV6Ry9mRjdtcEk0Skt6Rm1LNjlQbThvVENQUm4rZmY0WWZRVWk3YUwwMEhk?=
 =?utf-8?B?ZENkWU1LSWgzK3RQYXNUMStHdTdmZVN3azVndHpPVWZ3Y1hBZFJTWHFGSW12?=
 =?utf-8?B?U2lsanIzblpIR2hmTWNZbEJ2UFNTMHRuL2xQQm55bUpVUGxTWHhneFM0MGN5?=
 =?utf-8?B?Y0p5cmVvdVpBTVF3THk5WE5SMDZkbDBETU1yTjdXUFlreER2Zjl4MEJzNURK?=
 =?utf-8?B?TmdnK09Pa1NWVjFWM0ZnZzJ2RXgwVnA2VmFZUUVuQXJJS3IxTlVqT2hhQ3lw?=
 =?utf-8?B?eUlkRGQxUkh3a0xLSEVteFZyV01SakpZa3RmbUZXbXlBWml6TmY0UFRSS3V0?=
 =?utf-8?B?dzB4eVRVOGF6RTVFRHZCRG9rMVFGYm9rVDR5M3ZXYUw2ZzcxSS84RlJZUmhh?=
 =?utf-8?B?aXpITkx0L3BjVWlvRDZISFVzbGtNS1oxKzB5dzdGMi9WMW1nVmZoOHhKb0Fn?=
 =?utf-8?B?T1VYd0paNVEwdENLMkYxUXJqOXZEdHdXS1YxSHZNUHJSdXFvSmxqbWhxaEdz?=
 =?utf-8?B?ajBrb0VPSmJvd08zQ2JMRlk5bUgycU83Y0tuRld1WXhhTm1rV29aUmRsb3BM?=
 =?utf-8?B?SGhSb09iNlZ1aWozbzYwTkNYRkg4Y2ZoREhKWlRvMzFGL3lBcVVORU9idjZp?=
 =?utf-8?B?Z3VjQjFiMmgyQ0ZkcVRzVGFRR3BqS2tsbEplOUU3c3FqYm9aaXVrdWI3b0g4?=
 =?utf-8?B?M0V2VHYyLzZSNHJxTmZJaGVQTG1vOHBGVDBWbi9FOVZwTmlUMGJCazcwNFJz?=
 =?utf-8?B?SE5YSGZTbkg1VHFVeFRzRkdEU29zUyttbjV1UUdzN25SQ0g5akNXbDdwVEFI?=
 =?utf-8?B?NU1xUExacjZzZXhETlFoaFhaZXBLdHRFWnhyNTQxNnZ1ZlJmOHpDSmFNZ3o4?=
 =?utf-8?B?b0plejZWTWVhWU51N01GbWdaeXBPY2Zla1JGNUJvYTRWa2MzTlNvdFNTMFZR?=
 =?utf-8?B?cUdkTkszNTdEaDFzU0pZUGd0MjVTV0FrVUUzZjEwSGdsSzlWTHlHcEdhbTEz?=
 =?utf-8?B?QStGZVZpR3RGU1l4L3JSeDlVV3dRMHVtcGovRmRadjVXeGN3amU4ZnJsK2R1?=
 =?utf-8?B?VGtCVHhnZ1BCQTB4K2pSSFBsVFI0R0tEUnZrL09iUFlhSmVoTlF2SXgxTWsy?=
 =?utf-8?B?cndoc1Q0c3ltUVk5VTdBd1ZXd1REVmp0QUM4MCsxQ1E4NTArK1RrVU5YVVJy?=
 =?utf-8?B?NGozbGJtWHVkSWY5aTh1S1JFRDlKZHZEcnA4emtGbjJVNGJsbmJScUJvcVIy?=
 =?utf-8?B?RGNxbkV0YnZPNGd5Qi9YQjJsdFV2enhXN2diNVdSVDFwbEIwU01JdnRnK3BW?=
 =?utf-8?B?NWc4RFB3aGE4WnJqRCtiNGxOM0VlT3o3WGJscnRUUkF5bXFFNDNpd0FwWGo3?=
 =?utf-8?B?OU5vZ3B4TVA0ZnR3blBIa0syQmM3QlNGTHVrQTBsZFZxUzk1T21IMHl0b0VX?=
 =?utf-8?B?Q2JPeEl1aGFvdkREd2t4bkptT2o3U0ZYTndEVWFZSWdXbTFFM0x3c1RJUXNy?=
 =?utf-8?B?YW5OdmdKNVQ4SzJ1ZklzLytQdlZXMlYwM3d6K0lXMGVwL3E5Mmg0SlVJNHpL?=
 =?utf-8?B?RWhmN3E2UjNLL3lDU2hQZVJGRVBGK2hOV3dvbHNncDVwY2diellmSWlQRTNn?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee46db4-9f0a-446d-c848-08da86fb459f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 00:38:19.2964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jdxvcoxRjuxev9VjrXbz2puoTTkf20nu4Kxc0XqIgm0oG95eJ6cGhn4dLVkxug5efU3JUS68+RAGwnpvLNU33MrNzyVdHmu7Ol7eSaEfgY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3975
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/2022 1:34 PM, Jakub Kicinski wrote:
> Hard to get consensus if we still don't know what the FW does...
> But if there's no new uAPI, just always enabling OFF with AUTO
> then I guess I'd have nothing to complain about as I don't know
> what other drivers do either.
> 
Ok. I think I have a basic summary of the situation and whats going on
in the firmware. I'll try to summarize here:

Firmware has a state machine that we call the Link Establishment State
Machine. This is the state machine which will attempt to establish link.
This state machine only applies when auto-negotiation is not used. If
auto-negotation is used it will perform the standard auto-negotiation
flow and set FEC through that method.

The way this works follows this flow:

1) driver sends a set PHY capabilities request. This includes various
bits including whether to automatically select FEC, and which FEC modes
to select from. When we enable ETHTOOL_FEC_AUTO, the driver always sets
all FEC modes with the auto FEC bit.

2) the firmware receives this request and begins the LESM. This starts
with the firmware generating a list of configurations to attempt. Each
configuration is a possible link mode combined with a bitwise AND of the
FEC modes requested above in set PHY capabiltiies and the set of FEC
modes supported by that link mode. The example I gave was if you plugged
in a CA-L cable, it would try:

  100G-CAUI4
  50G-LAUI2
  25G-AUI-C2C
  10G-SFI-DA

I'm still not 100% sure how it decides which link modes to choose for
which cable, but I believe this is in a table stored within the firmware
module we call the netlist.

2a) for older firmware, the set PHY capabiltiies interface does not have
a bit to set for requesting No FEC. Instead, each media type has a
determination made about whether it needed FEC of not. I was told for
example that CA-N cables would enable No FEC as an option, but CA-L
cables would not (even though No FEC is supported for the link modes in
question).

2b) on newer firmware, the set PHY capabilities interface does have a
bit to request No FEC. In this case, if we set the No FEC bit, then the
firmware will be able to select No FEC as an option for cables that
otherwise wouldn't have selected it in the old firmware (such as CA-L
cables mentioned above).

3) once the firmware has generated the list of possible configurations,
it will iterate through them in a loop. Each configuration is applied,
and then we wait some time (the timeout is also stored in the netlist
module). If link establishes at one of these phases, we stop and use
that configuration. Otherwise we move to the next configuration and try
that. Each FEC mode is tried in sequence. (Unless the automatic FEC
selection bit is *not* set. In that case, only one of the FEC modes is
tried instead, and it is expected that software only set one bit to try.
That would perform forced FEC selection instead).

This process will repeat as it iterates through the configurations until
link is established.

As a side note, the first stage is to try auto-negotiation if enabled.
So in the case where auto-negotiation is enabled it will first try
auto-negotiation, then the set of forced configurations, and then loop
back to trying auto-negotiation before trying the forced configs again.

So from the software programming state, we currently translate
ETHTOOL_FEC_AUTO by setting the automatic bit as well as setting every
FEC mode bit, except the "No FEC" bit. This is a new bit which is only
available on newer firmware.

With the proposed change, we would add the "No FEC" bit when user
requested both ETHTOOL_FEC_AUTO and ETHTOOL_FEC_OFF simultaneously.

From reading your previous replies, you would prefer to just have the
driver set the "No FEC" bit always for ETHTOOL_FEC_AUTO when its
available/supported by firmware?
