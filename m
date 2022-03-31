Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1889F4EDEA0
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbiCaQVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239847AbiCaQVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:21:50 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C671F1D2D;
        Thu, 31 Mar 2022 09:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648743598; x=1680279598;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hB6kZyOcnGy0ClajpskNAfKvXnQ81rQ+jHlGKP9rTrA=;
  b=YZqlBKMW5VCeFukuBG29uR1z3ZMaJjIR+DrW6Nr+j5oG0vPoMNwGzbV/
   kKKjPfArYeRyQzwHQ2ii76OXEgm18HmlzyI/1vAdz69mI1gkruPs+1WEJ
   H+u3H7GAqTGauv8ByWRC6dteA7pzX0t7ZlWhnFnZjTZe5NuVKaZ8Hexbo
   CYQHMj4nUeKq34W+uN4vbkMdyHkjSizSnPH79sBZK/vYd7mgLjGmNMhvb
   RfBoTiLSoB89/x5mEbQEbedS/pCGdckjk79doFQsoIbG4H4lJHDTnsanG
   tFryrCUjhP8hnlmdBgoRdIl4gOPYGcTrIwj/int1JvZdm86j6zicqGMQo
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="259862491"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="259862491"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 09:19:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="586492131"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 31 Mar 2022 09:19:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 31 Mar 2022 09:19:05 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 31 Mar 2022 09:19:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 31 Mar 2022 09:19:04 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 31 Mar 2022 09:19:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fSkSK4jHIZr31Gxbc8Jii29JupTtcCbv/9VExhyDgSy7flJYC2mTag7uIQVzD/nj9z6Gf68GxTBX1C9NflN8LCZTGbRrQOSMI05S5hKfBt3a4sO23SkK/cqNMgtB/SvowiiDupN/k3E7W4uYtsQAv8G8dbgZ6KscEMtOLo5pO9LmNl32siLrOoYy7zDwZCrAIDlbT17wjsLfdssFuvnZq3ZBYNB0WfxzAy+ct2hPINOdS9tiW2p2F6um1/MC6QHkSNKC05R5SSW6Z0/9/NAlGXq9PtlTGeeAB5F6t1d9ZNYgFZphtfMYoAImjvQMwKJ05Bz66y/wBaUMlAbnnfBBUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hB6kZyOcnGy0ClajpskNAfKvXnQ81rQ+jHlGKP9rTrA=;
 b=R6pPN+zzrwR6EQ6t3XfJ+sl32ty3g/AyN9QJkYrw2k0C9QLon3QVXhfMWDe1k4ciQPDaB/v9q7s5+QN0c/ZbEXqC8NHXvivySQRpELd/5kRQH8Lpd5wbbRS7PrIL1ScKysI8ybSlDUKdinYF+qoJ1HaW+vs5OHxJcfxrjhCxGkPWPexQ/StueNAFHtryl97lbXdaJoRrtmJHWvCRNk9phirGSeTOKYLXfjvrvjMiKjZ4qn3Q6+p5PnH3px7ZRaxNYnQPqhFD0mdjFW7U8DXa8T09Orbm8BHzYbqYkza6gc0Kk+QA/dp0mXw9gKNMu1REo/jW8/RTqnR+EUT3OTk8WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1392.namprd11.prod.outlook.com (2603:10b6:300:24::14)
 by DM4PR11MB5440.namprd11.prod.outlook.com (2603:10b6:5:39c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.20; Thu, 31 Mar
 2022 16:19:03 +0000
Received: from MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::69:f7e:5f37:240b]) by MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::69:f7e:5f37:240b%3]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 16:19:03 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "songliubraving@fb.com" <songliubraving@fb.com>
CC:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "Kernel-team@fb.com" <Kernel-team@fb.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "song@kernel.org" <song@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf 0/4] introduce HAVE_ARCH_HUGE_VMALLOC_FLAG for
 bpf_prog_pack
Thread-Topic: [PATCH bpf 0/4] introduce HAVE_ARCH_HUGE_VMALLOC_FLAG for
 bpf_prog_pack
Thread-Index: AQHYRIpKa4OOIFtfk0GleBvGfJS766zYnJoAgAAL64CAAQR3AA==
Date:   Thu, 31 Mar 2022 16:19:03 +0000
Message-ID: <aeeeaf0b7ec63fdba55d4834d2f524d8bf05b71b.camel@intel.com>
References: <20220330225642.1163897-1-song@kernel.org>
         <5ef891091337e2d36b29b1410f7f92c21b52d968.camel@intel.com>
         <92027664-4817-47CE-B008-8AFD94947B02@fb.com>
In-Reply-To: <92027664-4817-47CE-B008-8AFD94947B02@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52d25441-5940-4c9e-47b9-08da13322be6
x-ms-traffictypediagnostic: DM4PR11MB5440:EE_
x-microsoft-antispam-prvs: <DM4PR11MB5440C57ADC96C545B7DABA88C9E19@DM4PR11MB5440.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nDkKineFyLJ8JB3Z1+jPxxtPzZa7nQu/ENjKlxoQ3Ws1EEOrEn2nDUeUJ9WzuxSCLyT03IHU0gvM+dY1kd529sbeGEHiNwjqnvSIKxgdBatxtemVnD9ZaWeL5Bi6kZNUJ3pUen7zmk+YsCoukbi2F1Z+FgZ+TW/Xbr87QZtr2htehM6rYnZ+h+h+zESx5/iRtXCqeAyWCjOPHSqIDqUNAtgAxD4oro42U9vuxYPh5pJe8Z6/LHufwxeJUYvKZV7L3YeR/aI1hgH90QGbJ1EAuBYAS1pKR0cz4EML7PLdZVJjnJXdkIEhr6S+vCe3s8+ZPN0DN0DjuJ1hU4w5KZ+GAgUvyX+PoiRhRAuakA4gaCOtio7TFFgcIw5xMXY29G6LdBSecXk6MIw/86MUr992a061wsWH8levFYZ+Y16ihdBPuTODzrODNFLI+sS2aCNtPPpHF2UM+w0PCEFROqynEJ330hIPP+PtvHCa93M9H0QBi6Q8c1w5wVIQlq2O9lWoNZ9gxEWrYjsgneX0TbJEdb0GZ7EB5wGRkS6da53M6YMSsjOvLCvW0WHAqB1oXtGaMrhsd0SQn/sNwl6MTV3VHAAih2m+VnO5Yo/nDUPhIkLygBVjJd9vv/LXWJfuseWc/Te9yJeeZ3D4mzTOtEExvsESwt4U3PctGzUZm4QJ0slHT36mO2aFUseBSdc+VGX9E+gxZbGeVrRwlsnm82kem5aWgOlndekRMnpbg+v5GMsyGgj9/0hzQS4ZOM8BcAyAEh5692qT81+N/UsSF/Q95RYFI7+CNf+5OntMvAmweDMX7oaq+gPEXEnzveCZo4pC33wBeYIpMd/snh/INB9wIg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(64756008)(4326008)(86362001)(38070700005)(66946007)(66446008)(2616005)(76116006)(26005)(54906003)(186003)(71200400001)(6506007)(316002)(6486002)(508600001)(6512007)(66556008)(66476007)(966005)(53546011)(6916009)(5660300002)(38100700002)(122000001)(7416002)(82960400001)(8936002)(36756003)(2906002)(83380400001)(99106002)(14583001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZjZQNGQwa0NiL3RtaDRvOVNjQ0RZeExna2xlS3ZrUlIwZTNhSVBpcE0zdGhM?=
 =?utf-8?B?MFZaQUgwbG5TaFQycy9FVmxTOFlNdCtzZ0ltUWVSSlBod01rdjZpdXRWNk1l?=
 =?utf-8?B?NlhJbHRCL0ZBbWx0UUdEMDZkVE51LzRiQ043QzNpU3BIdFl1bHVtdVNpS3Bv?=
 =?utf-8?B?REFEMU5BUGdKMXRwTWtlZlN0UHlHUDU0aXRlM2N6NE9yWTMrTVdpakNDM2VB?=
 =?utf-8?B?a21YVFZOTTF2d1M2NkxJOTJ5ZEJuRE83RTdVcVJuRFFVNVhlM2ZVTVNTdnlz?=
 =?utf-8?B?dVI3UVkyd2NVSEZBK2t5UkQrQzNoOEFrVjUxMXNnMTBnVVU0YjExTzZTVlJO?=
 =?utf-8?B?TE84ZjBSYlpUSGhPTGIzNGFLd1M3UmJNa1BWaGwzTUhzdEtuRWxHdTY5RlZE?=
 =?utf-8?B?OGRkRm1iWHpEZTA5NlhQeHprclg5RnJIUUhWVjNoVUVFRjdxVXJ4dTltL2w2?=
 =?utf-8?B?OHdybk9rWlkzUTBpRS9raE04T1piRENrWGNjT3lSZi9XYUJoWGEvR096NkVl?=
 =?utf-8?B?NXJGdWlxOVRHRXFxR3QvNVVYYUNuN2t5RFA4cjJBWUJSK0g4bnBTSmE0VENX?=
 =?utf-8?B?c2MxWW5SRzdUOHJTK0Vqdm5YUGVHMXVKUUI0emxXTkFJVExLRXNlbzRJY2M3?=
 =?utf-8?B?ZDN1KzNtbHZTc0ZjZjR2UUxQejJpajUydVJlTFRFN0YvNklFbk9NWWhrdzFQ?=
 =?utf-8?B?WVljcmo2UE91TUdBdlJEeHhjWDdXUmw1TmdNNjEvdzNrV29OVlhjUkRTWEtS?=
 =?utf-8?B?OGJLeUdyMnRrWVJGbkQ2Q0pFdWcrM2JjSEFRMVJWQXR6ZUhkS0lJWWtYbkQ2?=
 =?utf-8?B?YmNXNnM0NWI5VlY3em5UZzE0OXRpMzNMRU1EYkR0eEFpUWFWZVNXbUVwYjU1?=
 =?utf-8?B?REZXMXlrUEt1eWNnQWVBTmcrZFdZODE4aDRIaHNmbWN3d1RzQlZnNUNKRFQ0?=
 =?utf-8?B?YkhYa2s3bkVPMW9ROEpyMk1QbGFjZ2lCZ1ZIdHI0U2hmcUsvRlcwZG5WL3Iw?=
 =?utf-8?B?NGUyeW1scFByZzlvR0lWNGRVYlF4Z0haTDJLWnVvdlhQSFU0UTNoWGh0VkNa?=
 =?utf-8?B?RVBKN2E3NGM3NU5zYVhMaUtlVVVDVDA1ajhWTjR1cjR0c0VVNGlTY1Z6eTJj?=
 =?utf-8?B?cFF1RVpnOEhqOWdxQ2h2RzBPUVpwZHp4MC9SMGRuNFF3T1lJbEdKR24wNkMr?=
 =?utf-8?B?OVAwN21lRHZpdVdNZm90M3ZOR1ZORlJsVTFKZjJ6ZGtsYjdUcTgrK2pYK1pa?=
 =?utf-8?B?eS9iRTdhc1dpcHBCR2hNbWgyMFpzZ3lyYUxhSlYrK3ZCa0pmUTZ3NjNRVWM5?=
 =?utf-8?B?WGlRbURhVjEyc3Iza2psMlJla1pjV2VGOWI0ZUtOSDhidlFucWkxM2V6ZlE0?=
 =?utf-8?B?cHR1YnZzbjZUdzNJRFg5VzhZYUttNzRZU2pKVFlYRTJIdDlDNC9iOEIrdTNO?=
 =?utf-8?B?eFFlUUg4a0NwcHREVHVQSmhGRHQ5SEhSdEJZYmRqblFxanc2QlgxMERxS3lx?=
 =?utf-8?B?TDY0VjdYbVVMZUJUMkY3VWozd1lIY0xKdkd4cnNpaFllVjZ2YXJCK0Z4T0xk?=
 =?utf-8?B?MVRkQUE2NTltZkxwaVBZNEk4aUY1d0pkd2o5WjBRZ2NOakxjWSt2QWExbllx?=
 =?utf-8?B?M2dLUGJtVzJ2c01BSDhEUjQvWWpjWERQbGlkR1dVZlVZaWIvSkV5SkxtcEg2?=
 =?utf-8?B?SEIxVk5uZHNZZDc1b1Nhb2hSejRqMEZIWTRhWmtPSXNGR2V4T2VuYUpWVGlJ?=
 =?utf-8?B?Z0xvdTIvUXNJSm4zM1IwVkxVaVlBY1haM2xqM2NWM1dGNDlsS29rVDV2QUpB?=
 =?utf-8?B?RlNqdlFVZWxQSHI3LzRTMHNXMmF3eGJIU2plcHpCam9LWnptVkZsSTV6M05W?=
 =?utf-8?B?VHdyNEptYXBMT09pZ2FzNW5ieUU4K3ljVlJwdWlxNE5LY2lCbnVvV1hDYUI4?=
 =?utf-8?B?ZTZJUXlqdUlOQ3BhRk5QL2pzWEQyd2pkTkowZE9aL2dySTROWTNCV2l1VjVw?=
 =?utf-8?B?SVptbjdIWFlMZGRtaHd1QVU1YVJ1eHdpdHZGNjU5STlMaXlKenlQRFErejcw?=
 =?utf-8?B?M2RoQTdaUTQ5b29CQW9BOWk4Sk9Nc2gvRWhtN1F3Z2hlWlJ5Q3ZYSkt2c2NE?=
 =?utf-8?B?YXZoSFFEcE50b3lnWTRuRm9FKzZoTUtyUUZ6VWNBVEVrOTVuYUpUKzlsSHJR?=
 =?utf-8?B?RzFMb1BXZGVmSEdpYmNCYnpxWUlsbUJ2K2RJQ0lHazA2M3J2VjNZbDExemN6?=
 =?utf-8?B?ZW1VYnU5V0J3Vmtjd2FUaWZkRGJzamFPQWhqdTZGY2RmVEdjeHV1RE1ZMkN0?=
 =?utf-8?B?MDNRNytYUWl1Q25oemxMMks1V3VMWTZWT2taaDVKTmxoL3kxU0ZDMElZbUli?=
 =?utf-8?Q?l7VOrJBVJLZmlyhnJEoXFi2X134Siu/60MMsV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1D1D671C476664393F2B4FCF31A0724@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52d25441-5940-4c9e-47b9-08da13322be6
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 16:19:03.1057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ee6pZ0reE0OG9A8vIjCszStbcn66GwIneOOKkaWzieFEoDXG9vvVv/5/GUGTfLt3ySwD01UvRebU8fx6+1mpM2IdFWtHYxLU3hAwwt25sBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5440
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTAzLTMxIGF0IDAwOjQ2ICswMDAwLCBTb25nIExpdSB3cm90ZToNCj4gPiBP
biBNYXIgMzAsIDIwMjIsIGF0IDU6MDQgUE0sIEVkZ2Vjb21iZSwgUmljayBQIDwNCj4gPiByaWNr
LnAuZWRnZWNvbWJlQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gT24gV2VkLCAyMDIyLTAz
LTMwIGF0IDE1OjU2IC0wNzAwLCBTb25nIExpdSB3cm90ZToNCj4gPiA+IFsxXSANCj4gPiA+IA0K
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC81YmQxNmUyYzA2YTJkZjM1NzQwMDU1NmM2YWUw
MWJiNWQzYzVjMzJhLmNhbWVsQGludGVsLmNvbS8NCj4gPiANCj4gPiBUaGUgaXNzdWVzIEkgYnJv
dWdodCB1cCBhcm91bmQgVk1fRkxVU0hfUkVTRVRfUEVSTVMgYXJlIG5vdCBmaXhlZA0KPiA+IGlu
DQo+ID4gdGhpcyBzZXJpZXMuIEFuZCBJIHRoaW5rIHRoZSBzb2x1dGlvbiBJIHByb3Bvc2VkIGlz
IGtpbmQgb2Ygd29ua3kNCj4gPiB3aXRoDQo+ID4gcmVzcGVjdCB0byBoaWJlcm5hdGUuIFNvIEkg
dGhpbmsgbWF5YmUgaGliZXJuYXRlIHNob3VsZCBiZSBmaXhlZCB0bw0KPiA+IG5vdA0KPiA+IGlt
cG9zZSByZXN0cmljdGlvbnMgb24gdGhlIGRpcmVjdCBtYXAsIHNvIHRoZSB3b25raW5lc3MgaXMg
bm90DQo+ID4gbmVlZGVkLg0KPiA+IEJ1dCB0aGVuIHRoaXMgImZpeGVzIiBzZXJpZXMgYmVjb21l
cyBxdWl0ZSBleHRlbnNpdmUuDQo+ID4gDQo+ID4gSSB3b25kZXIsIHdoeSBub3QganVzdCBwdXNo
IHRoZSBwYXRjaCAxIGhlcmUsIHRoZW4gcmUtZW5hYmxlIHRoaXMNCj4gPiB0aGluZw0KPiA+IHdo
ZW4gaXQgaXMgYWxsIHByb3Blcmx5IGZpeGVkIHVwLiBJdCBsb29rZWQgbGlrZSB5b3VyIGNvZGUg
Y291bGQNCj4gPiBoYW5kbGUNCj4gPiB0aGUgYWxsb2NhdGlvbiBub3QgYWN0dWFsbHkgZ2V0dGlu
ZyBsYXJnZSBwYWdlcy4NCj4gDQo+IE9ubHkgc2hpcHBpbmcgcGF0Y2ggMSBzaG91bGQgZWxpbWlu
YXRlIHRoZSBpc3N1ZXMuIEJ1dCB0aGF0IHdpbGwgYWxzbw0KPiByZWR1Y2UgdGhlIGJlbmVmaXQg
aW4gaVRMQiBlZmZpY2llbmN5IChJIGRvbid0IGtub3cgYnkgaG93IG11Y2ggeWV0LikNCg0KWWVh
LCBpdCdzIGp1c3QgYSBtYXR0ZXIgb2Ygd2hhdCBvcmRlci90aW1lbGluZSB0aGluZ3MgZ2V0IGRv
bmUgaW4uIFRoaXMNCmNoYW5nZSBkaWRuJ3QgZ2V0IGVub3VnaCBtbSBhdHRlbnRpb24gYWhlYWQg
b2YgdGltZS4gTm93IHRoZXJlIGFyZSB0d28NCmlzc3Vlcy4gT25lIHdoZXJlIHRoZSByb290IGNh
dXNlIGlzIG5vdCBmdWxseSBjbGVhciBhbmQgb25lIHRoYXQNCnByb3Blcmx5IG5lZWRzIGEgd2lk
ZXIgZml4LiBKdXN0IHRoaW5raW5nIGl0IGNvdWxkIGJlIG5pY2UgdG8gdGFrZSBzb21lDQp0aW1l
IG9uIGl0LCByYXRoZXIgdGhhbiBydXNoIHRvIGZpbmlzaCB3aGF0IHdhcyBhbHJlYWR5IHRvbyBy
dXNoZWQuDQoNCj4gDQo+ID4gDQo+ID4gQW5vdGhlciBzb2x1dGlvbiB0aGF0IHdvdWxkIGtlZXAg
bGFyZ2UgcGFnZXMgYnV0IHN0aWxsIG5lZWQgZml4aW5nDQo+ID4gdXANCj4gPiBsYXRlcjogSnVz
dCBkb24ndCB1c2UgVk1fRkxVU0hfUkVTRVRfUEVSTVMgZm9yIG5vdy4gQ2FsbA0KPiA+IHNldF9t
ZW1vcnlfbngoKSBhbmQgdGhlbiBzZXRfbWVtb3J5X3J3KCkgb24gdGhlIG1vZHVsZSBzcGFjZQ0K
PiA+IGFkZHJlc3MNCj4gPiBiZWZvcmUgdmZyZWUoKS4gVGhpcyB3aWxsIGNsZWFuIHVwIGV2ZXJ5
dGhpbmcgdGhhdCdzIG5lZWRlZCB3aXRoDQo+ID4gcmVzcGVjdCB0byBkaXJlY3QgbWFwIHBlcm1p
c3Npb25zLiBIYXZlIHZtYWxsb2Mgd2FybiBpZiBpcyBzZWVzDQo+ID4gVk1fRkxVU0hfUkVTRVRf
UEVSTVMgYW5kIGh1Z2UgcGFnZXMgdG9nZXRoZXIuDQo+IA0KPiBEbyB5b3UgbWVhbiB3ZSBzaG91
bGQgcmVtb3ZlIHNldF92bV9mbHVzaF9yZXNldF9wZXJtcygpIGZyb20gDQo+IGFsbG9jX25ld19w
YWNrKCkgYW5kIGRvIHNldF9tZW1vcnlfbngoKSBhbmQgc2V0X21lbW9yeV9ydygpIGJlZm9yZQ0K
PiB3ZSBjYWxsIHZmcmVlKCkgaW4gYnBmX3Byb2dfcGFja19mcmVlKCk/IElmIHRoaXMgd29ya3Ms
IEkgd291bGQNCj4gcHJlZmVyDQo+IHdlIGdvIHdpdGggdGhpcyB3YXkuIA0KDQpJIGJlbGlldmUg
dGhpcyB3b3VsZCB3b3JrIGZ1bmN0aW9uYWxseS4NCg==
