Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD86525359
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354329AbiELRNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351986AbiELRNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:13:48 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9947D115CA4;
        Thu, 12 May 2022 10:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652375624; x=1683911624;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DMFCxxbLa+TqP5ZZ0bJkQj7yvZyXl1miy3HB6PnxbFw=;
  b=Tu6Ym0bABbxBNaQAe1uL5q0Itv/gvshfyGLe6ilyXOORJpceoK21KLmm
   6EfS8SYo4Z1To8WbS8jyoCn+CMpMODl+Zxwi3LBSbJ7vJVJlYdKXfzne3
   zvQN+lNfS7pD3+gQ0TxOgf3kmBTjt0FXZTy+64CewISegW8KsODtT+hQ9
   e+cb/qlMQBPQAQyQ4ZVsSoyn06ZJ4IdDqfrnkCbV+Ir/B6fx8/aD9w7qW
   YpHusI7AAz93JElkvJSmAPs6IHBrwd8VBcw90dBYdV1U0I5hr0X3d/wk6
   GXrTVoylaXll2zk1xzlYQzDXhWS4tQ5FBEfjPSxwEArTe0J1ZX20z2LFK
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="250595042"
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="250595042"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 10:09:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,220,1647327600"; 
   d="scan'208";a="815003788"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga006.fm.intel.com with ESMTP; 12 May 2022 10:09:33 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 12 May 2022 10:09:33 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 12 May 2022 10:09:32 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 12 May 2022 10:09:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 12 May 2022 10:09:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IP0eDMNLxowrsHdZtBaZlX2ExAr5+bq46tJ+qluaCJTfh83JcZSMVptC4czKp7u74Wf466ePbK2DjemnqgSwpH4gKYrW2WZiXPwH/LUdOjtNAALoug71Mglsuhq80B0PuB0ZGfvAmBR5Xd1k5G3eBiKA+SNx0P1RRIBSHFYkVKb+IYnu6Bys2c1v3mn0RKlgQ/CVcDNViXlQUeM71ZOkpaPFO/a9xdyZ5uxMN4XJElndA8beK3N2XJn1Py+CipPhcWGpY9UlQ3za5Xh6M8JmyoPYt+cD2HwNP7mICIccGUTf24oDMbYVHf9sl73wrIWL3tGh3hQ9h1WM6b3L1Lzb3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4a10UVMlhmp2xpj/x5SeYZHTj906DNaWZ06hcgymsc=;
 b=G3sqwCX46+2SCGHKLMdlq/9QwaT8rlsA0QbwXCfuvsHPm0GPetAzvg+U/jk1w/rCRvBJN/R+bisL98+r4NdnM8XHVlF5Ljvs7tMoeU+tsE3qfNAl4Z4scWPEUOsM6aqi41zyF/z7vKtecZgCJr2HimFxN/Sa5C1gY8jU5q1yvTl4fPRoeoWgbZmEB5ld6S4nfkETKvLnQJN+4U8AN0BuGoDX+cQzdsNlcMGI0CssJn4QU7IH7Gf3Bne2MrSclIKlC/x94rT0aifQADJvFwoGIKyR8KoaDm+02SqWbo9uUv/50oJVNSvwi7sbLs2KJ1ngTz/Qpbm+bVE8t6L2nQD1xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3224.namprd11.prod.outlook.com (2603:10b6:a03:77::24)
 by MW3PR11MB4602.namprd11.prod.outlook.com (2603:10b6:303:52::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 17:09:29 +0000
Received: from BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::99e4:a24a:d119:5660]) by BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::99e4:a24a:d119:5660%7]) with mapi id 15.20.5227.023; Thu, 12 May 2022
 17:09:29 +0000
Message-ID: <fd59c0e8-7f84-a09a-f673-339919b4a056@intel.com>
Date:   Thu, 12 May 2022 10:09:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 1/1] ixgbe: correct SDP0 check of SFP cage for X550
Content-Language: en-US
To:     Jeff Daly <jeffd@silicom-usa.com>, <intel-wired-lan@osuosl.org>,
        "Skajewski, PiotrX" <piotrx.skajewski@intel.com>
CC:     Stephen Douthit <stephend@silicom-usa.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220420205130.23616-1-jeffd@silicom-usa.com>
 <20220425131758.4749-1-jeffd@silicom-usa.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220425131758.4749-1-jeffd@silicom-usa.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0093.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::34) To BYAPR11MB3224.namprd11.prod.outlook.com
 (2603:10b6:a03:77::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa55f04d-1f9a-4360-1718-08da343a2cc2
X-MS-TrafficTypeDiagnostic: MW3PR11MB4602:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <MW3PR11MB460248D03161D5F025B9F0D2C6CB9@MW3PR11MB4602.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /2Ya4Al55v8wHlFWQQsPkPpzo08CWJOKkfHCJAtpvwlUdkhXiQAqUtbQdahJS616pIS9fIguvhJWK0qBj9u1lLJRJO7OAmOXMgYahZZmMYY1LruxKF37sMsMY9YvKUV8+21rO6UBymQe81UNrsbH1xeUL1qYjB0McYQUYKMudszJC785ifu09Q48Ysp/hRPMURJIb795ExNS6P8CbXOCgsF9Lfl2DDM+KWwc0/TkBg0O4to1XotnTQnThxKpdAmpAQL+PTExhZTHBEmiO9XhMYOglmZiMbOp8C9+cxLtIJoqSyIfePq5t7TRfSUqv7/ZShekcoq0gtNiCf+RkWs/ZWZbd5xZngkqNtuAu6oSp60FzaS/3kXvndnYADTgCOot5G+A0ZDjEajyCD6a/uQhGEi6VvSyOckamCH0JJUXcVcB9zvio93RCeyoYIpokCl9d0JK007uqqK/rQRwe2qH+Hz3fUKiTiDRmzp0MzE0qlHb/Eu6Tj8NZxCUpDUZDaE3L03T7idAKJvib1RXwmoKgMSJrG/L5E60K/bHATjN9OZvAXWkhVMnlwjXz6L1WiQ2Z5ADTLm2DldgnBi9zHi1xvlg+bnVS/bca73yo0GwCJ10OCELd78UBo3q395EaBsb6yYXgMhUYtWgYntRG+/ifoc9hnWbxqDj3Btkpg64n8ycHFEJUyf1GHkOLHjVY6HoTvC4zkTx/IcFi34m2LUObh1eB0hIkLiYyJTxiTZgbRvWjUNli1FsafS/nr1ula8L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3224.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(6512007)(53546011)(6506007)(26005)(5660300002)(2906002)(8936002)(31686004)(36756003)(82960400001)(54906003)(66946007)(31696002)(6486002)(508600001)(66476007)(66556008)(8676002)(4326008)(110136005)(316002)(86362001)(83380400001)(186003)(38100700002)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzcyUVdVRWQ5N3kyUTVmeTIwd1UxVEtERXFjODFubXY2K2p5TExrbDlsQlNC?=
 =?utf-8?B?M3NmSldrMVBTb1h3VXZXMlpkUkg2dTBXT3A0cURTZFF6dGxKRjhEUlpiOGxT?=
 =?utf-8?B?dFk0RktJZWNPUGhaWUpuWGVCVnoyMU5QWVU1YnFkWTJvM3NrRmp2dzV0OU9m?=
 =?utf-8?B?blJOWTA2TG1uZkpBWThIUHFWanZkQkJQcVcreE5kTjhjb2lDL3RnaHpYa3Yv?=
 =?utf-8?B?blQ4cG5vQTNoTGdQekJDQzFWVjU2Z0dob1B4UnVmdHI4KzNZRWxYVUhGMitE?=
 =?utf-8?B?OEQ0bFlFZndYZWVIR1RYUExKZFU5UTlzejQzMVRQY09CTTNpZVRCTkxUd2pT?=
 =?utf-8?B?MTUwSGlXNGdUNGFuNEZtQjBqTVErUHUvQUtaNlN1ekwxVlNJb2xuU3R3T0NE?=
 =?utf-8?B?aGtyQWdGaW04djFNajQ1V2doVnpMTnk2cUMrdUw4bk1vWUJJR3NiemZLRS8v?=
 =?utf-8?B?bndUT3pseWN1QzNQUVNWRnJVZFFZY1JnZngxaCtGZ2dkelBuSytzOVdtNVB5?=
 =?utf-8?B?WnQvOGw4VUhSNndGSjBWcnYrOU9wM09oTUZzNEM3NVc0VDQwSERvdm1lczBC?=
 =?utf-8?B?QzdUeDdDUUhrakI4QkdjTDM3TDQ5a0pPdGtCamRXc1RVMTZDbHBNS3d0SXVQ?=
 =?utf-8?B?T0RuTmVRckcrRHZteDczMXJtTUc5Z3pPY1pmaTZkV29IN3BiYWJ3Nkc4b2Jt?=
 =?utf-8?B?S3JNanlxVEZ2WjAzb0tVTmtoU21WandmaFJJTVZTUTJQSlhWb1h2YUtoNWxk?=
 =?utf-8?B?cDJTbnA2OXpaZmJGYVpTR29HR0ZOTmR2VzIxMkJ1cm5KdmVHeWhrTmZEVFZ2?=
 =?utf-8?B?SUoyR3RpVk9LdVhJSTRVb29ISU5XRDRnOWxWQjVkQmRhUGNuTGdMY05mTTBO?=
 =?utf-8?B?ZndsRHpTOTBrdTMyY0piVVdMVkJoQmwyKzliQnQ2Mkc1c2R4aUVBNU8yTUFJ?=
 =?utf-8?B?Q05wWktJSGZxNmtyeDBJb3o4QkwrazBQZUY1dVJTKzBlVTBOTExreGlDRlBw?=
 =?utf-8?B?cVZGbzBXNkEwcEE1ckxTS3FPeE91N0xORDV0eUlNWHNVUlI5QzNuVWVNaUo4?=
 =?utf-8?B?YW0vS1ZsWjFHNVcxRWUrbnhJbnUwSU5IYjRldTczRHZSQzdEL2Y3Wk5hcEQ5?=
 =?utf-8?B?WVBDSkM5NzRhTHpSUWdQUy9vQWwxNWg5cjJhN01CL09YZ3pCbG04UnpXcDMy?=
 =?utf-8?B?Q0FUblFna1Y4M1AvTTd1UnpGT1p0VS9lckhhN29NNzJkem1KRXQvQW5UTWZn?=
 =?utf-8?B?NUYycHhmc2RtWXRxWkw4MmIvaExsdmdRNUNKL1Urbnc2eWhqR0JMTE5ZYXpR?=
 =?utf-8?B?MUcvd3dWM0wrOVZRQ0pMNk1WOWVCdHBKek1seU43bzVRMGNaRTZjZkJjK2Y5?=
 =?utf-8?B?L3c4b3FkYkxyVTZ4cTRtUk5nV1ptMzVSRDlkRUd5MFIrY2p0Y3R4TThUbEZq?=
 =?utf-8?B?NUI0UzNoWDF2RUJsenhaNnF3SzkzSDVJczM3RmZINm9zejF6akxNTUc1Q3NC?=
 =?utf-8?B?NjN6U3lGOXNscmpCa3Fpcm5Ud09HMXNvUHQ5cWxadXBwU2oweXU4L2ZWRGpn?=
 =?utf-8?B?Z2pHcU10YUMremFrZzk0c2RMKzJLZmVMSlhMdmZwR3pHZHUyVTV0ellJcUxm?=
 =?utf-8?B?VXhiY00wRVYwM3JUbG1jYVZyU0VCeVZhNjVhWG1zOXJQVDJ0cjgzMmY0Qlh5?=
 =?utf-8?B?TUYxTVd0VkJpbVliSU9adlJTbkRmOGF2RGhDRDZDQkZ1OGZqN1ZaU3RVM2Ji?=
 =?utf-8?B?SWxSaFhHOStIRmhpZVJRQWpDS01sVXpZVk9OOFMrNGM2N2QyRmhqczMzL2po?=
 =?utf-8?B?YTlqTUZ2VnFtN1lkU2ljN0RXNS9mVFl5QmlRWE1Jbkd1UU9qSXRIZWUwc2VZ?=
 =?utf-8?B?NHZ0Mlh2NkxyQUwyQkNhK25QS24vRTc2UktYOVphMlZhc3k2TlBESUF2THFs?=
 =?utf-8?B?Q09QZ1hwWjdaK0xZTWZjTStDVVdJZHF0d3B2bGUyWC9uM2VTcDZKbElFV2V5?=
 =?utf-8?B?TVlMSUd3anNOTTc3aFRBMnZ0VjdJTTVCNEM1OGFvckVrR2lMTUREejlvME5J?=
 =?utf-8?B?RFBRRUZMZWk2ZEh2MGZJL2VpcDdqMmZHbERiZmtFcnJGN2MxYVRzdXo3b2sr?=
 =?utf-8?B?N2d4T2xiUFdNY0xMSXg4R2s1N3Bqek5zUXFZdWtqK1hJVVZkWkZpMDdQUnhN?=
 =?utf-8?B?SXVHUDczT3dPdEd1a0tjVFRNNzlUV2tpNzhZSHluNE95UkY1V2RtUUJjYTU0?=
 =?utf-8?B?T01ETVV2ZzVyeFhpbFd1NUsrYWk2WkRIdFNFb1dENHIrS2NCQklyV1pVcFNH?=
 =?utf-8?B?bUhQTHpmNFFIZVp0SE5yVVVGMVFrZ3c1Wm1uNUNNUHJzZzdreHdHVXh3WWNG?=
 =?utf-8?Q?uqGpSjWxqgkLaBoE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa55f04d-1f9a-4360-1718-08da343a2cc2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3224.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 17:09:29.7823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /a4s39Zfdr7y1CRQDWMbVs3dN2PdpU0ypELHoedbrQi9O01fPzyWltoYFi+WYfzHxpVnSwi+eVfcJ7sD8dC7f+3tcqqwX/rvUOdKEnPvvSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4602
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/25/2022 6:17 AM, Jeff Daly wrote:
> SDP0 for X550 NICs is active low to indicate the presence of an SFP in the
> cage (MOD_ABS#).  Invert the results of the logical AND to set
> sfp_cage_full variable correctly.

Hi Jeff,

Adding our developer and adding his response here:

"
Our analysis (using 0x15c4) showed that every time the cage is empty SDP 
indicates 0 and when cage is full it indicates 1. No matter what 
transceiver we used, from those we have. The same happens even we don't 
use the device which fall into crosstalk fix e.g 0x15c2.

When proposed patch was applied, the devices are no longer able to 
negotiate speed. So basically this patch should not be accepted.

NACK

BR,
Piotr
"

> Fixes: aac9e053f104 ("ixgbe: cleanup crosstalk fix")
> Suggested-by: Stephen Douthit <stephend@silicom-usa.com>
> Signed-off-by: Jeff Daly <jeffd@silicom-usa.com>
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> index 4c26c4b92f07..13482d4e24e2 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
> @@ -3299,17 +3299,17 @@ s32 ixgbe_check_mac_link_generic(struct ixgbe_hw *hw, ixgbe_link_speed *speed,
>   	 * the SFP+ cage is full.
>   	 */
>   	if (ixgbe_need_crosstalk_fix(hw)) {
> -		u32 sfp_cage_full;
> +		bool sfp_cage_full;
>   
>   		switch (hw->mac.type) {
>   		case ixgbe_mac_82599EB:
> -			sfp_cage_full = IXGBE_READ_REG(hw, IXGBE_ESDP) &
> -					IXGBE_ESDP_SDP2;
> +			sfp_cage_full = !!(IXGBE_READ_REG(hw, IXGBE_ESDP) &
> +					   IXGBE_ESDP_SDP2);
>   			break;
>   		case ixgbe_mac_X550EM_x:
>   		case ixgbe_mac_x550em_a:
> -			sfp_cage_full = IXGBE_READ_REG(hw, IXGBE_ESDP) &
> -					IXGBE_ESDP_SDP0;
> +			sfp_cage_full = !(IXGBE_READ_REG(hw, IXGBE_ESDP) &
> +					  IXGBE_ESDP_SDP0);
>   			break;
>   		default:
>   			/* sanity check - No SFP+ devices here */
