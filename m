Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808736DE84D
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjDKXsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDKXsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:48:18 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508F1E78;
        Tue, 11 Apr 2023 16:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681256897; x=1712792897;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ePbl5tYyjxA0TcxtWkpyKVlTboPkAdTCmxPefD531sE=;
  b=Sx82/zv47u/XPoG7r0NhNKICIxpAIE8YDVgQtkkdyMzuwnhVwgJrfJ9F
   qAkb26j90nZuQKjxZZOjEdcjCUt0QxGLPURZLSPMJegcCvYr1nq/kWJva
   MuEMtMsyWrlpHnSSXmWd39/Pv+doeTr6cqF4oCI0aogjhXbraSb7OqVOr
   OyxYHBbD8RhrJ3VR5yl7XFV6n6DX9YVi/HzNJn/IXMWlVnquCSTyZ/7zv
   WJvIcKmRhrRo4F7fsbJYydrzdiWeMoW3ZWOrQMfuNlR/aGcl/yei6R894
   FFx9/o9pnq7JQ+FE4bYuQ+PyrXEXDH0CdWUvypJKpQ4sch6AZepdEsb20
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="345549975"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="345549975"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:48:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="691344085"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="691344085"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 11 Apr 2023 16:48:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:48:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:48:15 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 11 Apr 2023 16:48:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQq7k2kXJ6mgQ1BYufpD0JI1yn3JNjLwDxNG4Z70yXFJaF//fiUfInobJSbK0Dtwj63Ul6NrhSKa+use9I2CBbN3zGiXatfdKIIV9nc3wDkf7PdRxARs9meVZNLBj0VhYa8/TcUlFPs6k/YLonDr93/pKhymrb9hvwjHLVTSPNAJoDi1eazpqNWxL1/viofS4tQe2yDyJc9iMK7O5sEdoPOjDfShn7H3y2/kdqISvp7DVHO4j64s73lylsM1UsRFRfkZj7LHIR3oyv5PkkJ0/chd8aJi9ecnljK6CVlgdb+iykLnS00lxuWiXBBH665eACj1gDfygYdsU1GgArma5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sMYvf0NoE5vaOkZRRqanxU/hPEX1Z9kQ0vCVVi7N/HI=;
 b=lCg6++uhV+WtoVOH9yDjBvZtACX7JTJYofNIxdE0fU6quq6ulTNIM6xSr70vvPmKvcAtMymJGU17qMyizaRIBCwNZ9KTolEF0pp6jC69kqtV1e8313mrQJ4h5H07GxbHKmVbSeto7bJ4rabKyS1ve+so4s2yPYz5BILg+Sb3VWAJOmHYfrmi2KZgvBFr7ojitV/mn4NjT+3h7PrJezRuf6eO2M0gsd7RpMHF7F0aT9+afe9+6hkVmkEPxKzBiHUsPKrJJ4AZWpPnostsxivAPeNtDF+lKWDOjXvBjN3VboSwc7Uniz8aLiCfINMOrTkGB+Ffwsq0cN4YuITRnBx/sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CY8PR11MB7194.namprd11.prod.outlook.com (2603:10b6:930:92::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Tue, 11 Apr
 2023 23:48:03 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:48:03 +0000
Message-ID: <fcfa0adb-e204-3232-5c33-711c209b8214@intel.com>
Date:   Tue, 11 Apr 2023 16:47:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net-next v4 12/12] net: stmmac: dwmac-qcom-ethqos: Add
 EMAC3 support
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
 <20230411200409.455355-13-ahalaney@redhat.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230411200409.455355-13-ahalaney@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0375.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::20) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|CY8PR11MB7194:EE_
X-MS-Office365-Filtering-Correlation-Id: a90b0d10-fe43-4bd7-8e3d-08db3ae73072
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: juwc91P5K817pfv5Hba9r97ixHf06KImY+C/3ZOf1MV/8fNQZPw2m0Qky3Y6cVsan9zvPQ7pfEPlItUmdcy2xSN5MwD23+cgO5UjownWPjpVaFV+eQvT/WWmJ//SZA9FVaETPz1/6yWp3IbO27cS1QQgKQUPjMVJjMP9E52cbLo8fcp8T1vugiIuf72J49o3PEU8JLruVOAh1TY53OthOlxf9VGRmPzcYlYKdcY9UxXIkXpdhJ/bOm677+83gRQb4ncqTtg2pUZIIo7XpcbfdA7gN7tStxFgZreX0B52LbNQjWwGjwbRpxLTJ4+L0Log6Q1ImAFtaZFk8RCXK4PD7h+B4NAQqrmlp1B0zHNCONRe3AMr/2herKxjHKicBQvN+4/4QF/bePxM7ombc+NmfpRbtJk9WbsxeIf7DtStRh5A89l04pG1RcdzNaqSI2dSQa7MUpVlYSVowj/b9x2zcgdbxzIbLHvB0n96qtXObA64rEii323IoQ+1qIEVYmCnkBjuehc5IH9cBO4lKYQ9fDxdbmYnpBmHxp1/uY3guTC+rUPtmYmwjX/hYQSxeC4+yCM/+O5u/oHT1VxzgYZ9MgcKiWyd+SXNNkzCjq1knJolINe9aLkYdQF/ymNcdlR4kZTGup3X5+n5Ahfg8z3z0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199021)(31686004)(38100700002)(82960400001)(66476007)(66946007)(316002)(8676002)(31696002)(86362001)(66556008)(478600001)(558084003)(4326008)(2616005)(186003)(26005)(41300700001)(36756003)(53546011)(6506007)(6512007)(2906002)(8936002)(44832011)(6666004)(5660300002)(7406005)(7416002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RE5nWDM1MDF3Z0hyUDNFYkcxc0hidDlnQ0VrZTZxSFEyYVJGMkJ2bE5DRmtX?=
 =?utf-8?B?TnhhNlhDYW1waEdmUlNwWGcvMERXMUlOR0U1KzZrZ2VlcVZubWk2U280Tzk3?=
 =?utf-8?B?SndrVUtkckpxeTMzdzBOMFkzRmxJa2JIR1NkMVNxK1MwQjNOS29pTHNSYVRI?=
 =?utf-8?B?WGRJbVllOWorenEvTFlBK1Q2b0dPeTZKSW1FL2dnUzI5ZFFoMzNiMkd5bU41?=
 =?utf-8?B?UWJzbGdpb3hyVVUrbXQ0OGNxeDVvQ05zWjhPdXlRM3hrQWRLajhkU0VrMWQy?=
 =?utf-8?B?aWJxbzVLYWNYVkhKd1ZVbGtFMGt6VWhyVEpTR29IeUUyc2tEbmEwdnNJcllH?=
 =?utf-8?B?QkJ2ak90TUp3NVJmSFhQaU9hbXpDamlEczZ2amU0SnNPN0pERVhsMUFzVzNu?=
 =?utf-8?B?Sm8vVnpaNlVlWjFieWRUU1Y3VnhlMmdiNGxIY1o2OExVNnhURWR6bnREUjJk?=
 =?utf-8?B?V09YdkJRUmlzYXlSZU1HdjBDVW05anpiYm5JVENqZjViSW1IYlp0M2lLMWxR?=
 =?utf-8?B?c3dGOVNoOTJpYVJyUWpSaU1RTlBsSzNCakxjSVJ6MURHVkpLUUZqTFZCSjJ6?=
 =?utf-8?B?cEtIcHhNa0hoNmp1b2ZvcGJjKzFHRThuREhkNCs0Yzh4UmJHQnR5RTQ3L2Iz?=
 =?utf-8?B?eEdub0tuRnoyaStyYlAvdjdXTUdSN1R3bzk0Sy94MlZPSURyQWZHZExNdlFC?=
 =?utf-8?B?N3pScXdrN2ZsZVRybE4vcHZZRzZJa1Q5Rm83c3VYR3NBUHZOZGVha0RJVDEx?=
 =?utf-8?B?ejY2RnFMb1ZTSGR4VjdScXBFOTc3MkZlOGhkQzlrU0V2VFdIK2pTd1JKeHBG?=
 =?utf-8?B?aFI1T21kL09mYUZGTGRxZURLZ2puR3BIQnY5SnVlNm5QWFhCT1JlSzBha2Fs?=
 =?utf-8?B?UGJONnJnS2tOVzhCcFRDcUYzb2U2a1hQQ2VISmNSd2tCZW14R3NOQWplWnpy?=
 =?utf-8?B?QWhpQWJVMmk0b084eGZQQXAwdnlyYWVvMkhDVGFQOW8rbnYra2F0ZWNMSUFm?=
 =?utf-8?B?YXdjZE1DSWtpdWVpNkEzNUJYL1JyRXFZZTNtdFRBdmVDemhtNDQzRnpOSDV4?=
 =?utf-8?B?dEdQVDdwcXJJanhWekQzaCt2Nk04L1FhUWNMcjlUa0tJUkE0UHc3RWZ4RDY2?=
 =?utf-8?B?Z2VUVkUrc3FaNjVSYXhuK2Jia2o5LzRDdEswUERpUFZ4RTBYVkRIMXVOQXVW?=
 =?utf-8?B?UTIvS01HS25oSFRqa1o4aWpaWVczaUZ1UHBWeURVR1RBS0kwQ0JlNUZqMy95?=
 =?utf-8?B?cXoxRWVSQlQ1aVloNWdqWmNUV2pEZUxreFdtYzR6cWxHQ29pa05tUW1TNGVp?=
 =?utf-8?B?REdZdDg4djE5MUVxaWFPQmJGd2tKV3kxQlVUOUJBSUptdlFuTXdrZWJxZGov?=
 =?utf-8?B?Snp2WG5heldjTDdkaVV1cERtZkNHeEZ3MHZza2VRc250NzhuV3JJNGw5WGlS?=
 =?utf-8?B?NHdYMDF6ekdVNEZ2ZUJPcU9iMXV3b0hIQUVzYytCN1J4OExQNHdudmZVL1Uy?=
 =?utf-8?B?bVN0d1dxNHQzOWhoUGNNeVJmaFF6VUFacUV1UnNPUnZKOTlIK3lHZEZDSnJy?=
 =?utf-8?B?ZGhsOWNJdXZ1UGJkR3hDZHJtbWs5YTFKbGhVTExLVU5rOHNkQ2tyV2U2Snor?=
 =?utf-8?B?RFJZemEyNmNLMXBvSHRKYW9oWHJxODVPR0FSRlc5eHRBRXVXRUtEejd1SWMz?=
 =?utf-8?B?M09hc1RMWE1LWHdWWmo5R00weTJLdzRuOGY3REorTW1xc1dES21NTDZ4a0hL?=
 =?utf-8?B?S3FMYlBXL29rWnAycjAzTGEvREFmVlZHV1RPNHd4enhVMG9kd2dwanJ1cWIv?=
 =?utf-8?B?ekpOV3NTKzVKQmxVcDk3Nkx1TTFlZFpIWkIzREk1dTFobWZVYVdra245MFZC?=
 =?utf-8?B?ZTU2OGN2S0RDczRqUUs3UGRDa3VGNlVLR0QvYmNXU3dwc2kxc3lVRUJoK29N?=
 =?utf-8?B?ak4razduQ2ducThqVTVpY1ZCbEgrY09uSHJoT3NzNkRzcU1DRTl1am9ZcFFH?=
 =?utf-8?B?ZFJjODVWRHNHMHpkaDhzSjV2ZHVQZlQ5K2w1RnlhVDdqQWZUbDlWSlZLWW94?=
 =?utf-8?B?eUhzTUdia1N6QTF4WTVheElzRzJpVmtmV0xyblNlM3FBbUYwMzUrU1ZjblFU?=
 =?utf-8?B?cWNpQTR0d0tIcml3YjJ5dmJNdU93d0o0UmJSUlIwMXdJb1lnekxDdUQybU55?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a90b0d10-fe43-4bd7-8e3d-08db3ae73072
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:48:03.2083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DKtCKd6NyqG/NIqYEgYeUCu2EFbuGHV4hhX2kcMseTIoSSN0LThsrUUdRHvLbxvD7QUAA1Ep3ntMxIOjC+6BLDZmTm+nz3EUKTOQ0wnNrKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7194
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/2023 1:04 PM, Andrew Halaney wrote:
> Add the new programming sequence needed for EMAC3 based platforms such
> as the sc8280xp family.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Looks good!

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>


