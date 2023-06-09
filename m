Return-Path: <netdev+bounces-9534-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B54729A77
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:51:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2DDE1C20B89
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F5C14A88;
	Fri,  9 Jun 2023 12:51:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D9B79E5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:51:29 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921A6DD;
	Fri,  9 Jun 2023 05:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686315088; x=1717851088;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/UNKzqgwD+bO2HxiiX55mW+ysZOAhNxBM01QsFM6x6g=;
  b=N7YbipfXyrmIINy1lQoFIwB79McbP3cswLEY+klgDbuYjY+PmtK0YnW3
   9yg/sIgHNP35LV1wz/qBm+b0x77Fi024nq4R+BdBr+H/6ovqxGZxkAMzF
   c2PLg1T3NiTvPVWSB956+5Zm/6gAGFNGAOIQLaRK+I3+KZ+9mS6PE/8ZC
   twFPGzJpOuV1ew6QTaekYN4qoWfaY7ls5vyeNCBbdnRzqTH4EMwtYu+w8
   iAWFVld9aJmVMxCKLlqw5L1fF3GmLx0PMfcAcjZFtCnxNQuWphylJXU6A
   EpwKqQH1x6HWPkFxqCL+PWg7e95N4DmJismLBkzEfcpklF9C6doaFdAJD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="356480776"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="356480776"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 05:51:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="704541939"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="704541939"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 09 Jun 2023 05:51:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 05:51:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 05:51:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 05:51:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 05:51:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbKcKZTgm1qgZ1EKnoRjppEpJVaFoM8RiPoPYpnyKvAyk2Wz0+AQNpoNMZ0t2Qn0zco6IxWSkPjdWCnPLxtqncArURVBBNfmczRee96fR/wlFbAanJ6DbmGR7LicWr9XNecgh73UUzWmWcYFAx5WWcLORwWpmHDSpnMDAjuDZLMypvOJ6OU8QLTOHgv8KX+ZYr0M14YvHxh1f9fVO8aIlBo0jxuF7D78bkmJvaYkFev6b7kbDctb65/Mndb2Xyrz688/V5tMM8y1w0OP3Thbnm/MnTa/1iSVxC0yQNghfl0dRgOGZ2veURdEBIJsXDd/lfwngH/JHYxq+cSxrVt7iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/UNKzqgwD+bO2HxiiX55mW+ysZOAhNxBM01QsFM6x6g=;
 b=mebcHZbGjdwvRftI71L6DT1CTGE17RNehuNawD7nFfxhzl6HohJBBpL60oGbkgmgY37QJSfwJLRjqvn4GvJwQmQyoumPVOUu71G+dlnqw4ruHj2w8eEvpd6qCV+452MWGE0Q06izmCvmdzdzlU1ZTXtAjwa4C3qdVEs6vxTvtJfvaGVtsE3sZJH/HnXZakkU/GvNdJXKnfTeCuXzNcnnlM9t8w5pV/bPUbuGpob1BWtE5lpOUvrvlMPjUKxa5s4VkSPftj/5SivsGzrOyf8IZeuKpKKnqCrVcQ0PyVo4AN/t7kGqrfOqqwCc9hSxbjPI94yvK1a5Ak+0tVzw60iM9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.41; Fri, 9 Jun 2023 12:51:20 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 12:51:20 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Paolo Abeni <pabeni@redhat.com>, Vadim Fedorenko <vadfed@meta.com>, "Jakub
 Kicinski" <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>, Jonathan Lemon
	<jonathan.lemon@gmail.com>
CC: "Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
	<michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Thread-Topic: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Thread-Index: AQHZeWdERHWnlPmo9kOdLErcTLxvj69mhUyAgBwpPeA=
Date: Fri, 9 Jun 2023 12:51:19 +0000
Message-ID: <DM6PR11MB4657ACA9EB0A25348A7CDC9F9B51A@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
	 <20230428002009.2948020-3-vadfed@meta.com>
 <6c888b44da3235c8405d890c51d77f064d84fd5f.camel@redhat.com>
In-Reply-To: <6c888b44da3235c8405d890c51d77f064d84fd5f.camel@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DM4PR11MB6020:EE_
x-ms-office365-filtering-correlation-id: 77811fa2-3ae1-48a8-cd29-08db68e838d0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /yxDjarj464Y7GhmcMDlfjCwl2sEtONKUWHxFQetX5tejOHFzp1PFHIRQoU3T7RrN1PTYGVj1bWOg38vpxcUphL0PSdEFTKboLMpFUN6IglkmhZcdz5SJwDXdo0LFgototeHrwQGHjikqjrO34ZgXYC75XyDWeMkq8UXh07BzVf33CyPpYIqUhYiQr2QY51Jog0wrc6q95ZXLaZ+93Nl9aIWsysfjnzao+06UE1LoEW8qaD6Pm4zCX+iFNNkrRA8q/R2OTizGoxNZADZt9wtfLKoTNjnaGT1//FWDGLCeNarNDAKvisHbeHfptxnvzlTHs2wLZC54REYcxCSEPCP5RtTCFTsrGtqgj1DdAlSlYbaE+WoIlzASUJkCpRuzqZIXicC0YXqKKnIMgS0gVVaeWnU3tCgYqgmS8gMIv9DcwFCRPi7sp3HSPBYEcl05DKyBx+lonQz7RsRQ80Ato/TSP5HtlUYknb0MVlrQ+2oMGSDMTDoHTzCiRdoER61e/e1bOV1Za0sH1uSnwHddT8qn6LBWxPgMlsrck8otdD3W3m8bhkWx29VaIxcKreDzFTufDvGxKvBQABCq20I40E8efcXSyW+e8DIsUiZ/P6xR4KwzdnM1pj+r8HGEpYOgKP4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199021)(6506007)(9686003)(186003)(26005)(7696005)(71200400001)(82960400001)(122000001)(76116006)(66556008)(66446008)(64756008)(66946007)(66476007)(4326008)(478600001)(83380400001)(38070700005)(8676002)(55016003)(8936002)(86362001)(33656002)(5660300002)(52536014)(38100700002)(110136005)(54906003)(7416002)(316002)(41300700001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RjBhZEZNaHZFaVIvWjlqU2IxajdhWkVWYlZrN2t6YTBYRDE2bDRSNXJRdXNL?=
 =?utf-8?B?S3cvQmk1QUV5MDF5YnVIdkU4QWJTVnlOZ0JuVzV1MGNqL0dnN2k4LzlIM2pn?=
 =?utf-8?B?SCtySFI4RXFjT2tHNkNQOFcydDNYYlk5MEFkb05wdG1uYmZJR1dQYmhISExN?=
 =?utf-8?B?N0tzQ0dzNmJKb09rYXhqak0xT1U1cHU4bmczTlRmTGFyeS92MUN0NTlKOUVn?=
 =?utf-8?B?RDh0cUZVOGtjc2tCeks4NUVzT0owUHVQYkdONk0vMFFTenVsdEQ0eW9QL2Ns?=
 =?utf-8?B?U3kyRW15dlc4WDBXaUM4SVllU1VKTFhpcVJ4Z00ydFN5NDRRQ0EyZFFvSy9U?=
 =?utf-8?B?dTJ6QlhnaisvSitIRzFSVjFXVlQzOW9nTkpIaFErVTA3YXppMXFYcW9lb2Mv?=
 =?utf-8?B?eEdLYStxR3pCWDA3OXNPM0xKdGZ0N21CcExmNm94d0RXb3FFa3hybGNwQ1c0?=
 =?utf-8?B?TytCUFVuV0FaVkd4TkZ2VlZNWE5BNjRVMGJoanV6T29hS2RubkR6a2xGbC9w?=
 =?utf-8?B?a0pqME1NNVhlVFZvMWkvTnp1ZkxZcHNzNlRMZDhYSVpTU0o0RnRuOGxmRitF?=
 =?utf-8?B?aWRRMFJEQ0NUaDkzZlplU1BFWjlPcFVUcUZaVVFjV0pZUWJuNnh3bHNlemVK?=
 =?utf-8?B?Um1pQmh0dWpDbGsxMDRYU0JTYWgxVERXMit1cFpMT1lmZlV5OWZ4bnFKVUJD?=
 =?utf-8?B?S1AwSW95WUN2ekdTZ2Ewb2RRMUtkK2cvTFdzekw4NTVqT29oTjdqdHJiUTlQ?=
 =?utf-8?B?NjBlTU5LZEx2M1Ezc1F0OWM5c3YrR2syWE4zQllNV0N4bVNaNG5CODVQbEhv?=
 =?utf-8?B?Mk1mR1dqQVVtS0ZkdHZUQmcwb2N0d3U4SUI2ZzZyK1o4OVhKdkZiWEZVOXRB?=
 =?utf-8?B?OEtvOCs1L1RaQ3ZvcU1NREZBakI2ZTdyL2VSVis4eTFZMlBUSmlFQUl0aWlz?=
 =?utf-8?B?WWNmUGtNUEFLaThUd01LZncxVElpdDNsWit1T3JVTUpSUUorOWIrWDhiUkw0?=
 =?utf-8?B?cWRYK1AyNk93S0Rna2FYOU1DSnRuVklpOEs2R0c2c2hCVlV2T0dFK0t0MzdD?=
 =?utf-8?B?dnNOMFd2d1FQYnp4VEpYam9FeTVSdnV3L0NoK1FRUVRrOURvTU9DR2Rxc3Bq?=
 =?utf-8?B?dUUzWXlQaENXQjdYNDY0bWhUL0pZUGd3NDJOd3AvaFI5VVJJNkszdjkzc1VB?=
 =?utf-8?B?RjZzQVQ5cHFXUWRud1J6dloycHptRUluT0cxQVEyMWd3RmQ3LzUvZGl1b2JO?=
 =?utf-8?B?TnNONFJwUm5Ga3B2NlVRK1RMRnVpYXRYTzNXNkVManUxUFVRRDV6dURlSUtq?=
 =?utf-8?B?WEorR3lhUHVYUmxNRk9hbkNXbmsrL2VaWXovMFBNVnpMMlJGTmY3RmtxM0w3?=
 =?utf-8?B?YVJ1c21NZmE0bnN2NXduQ1EvWndpZ2hLNnRrdmsxOVNBYlU0Wi9ZNjI4WTBz?=
 =?utf-8?B?d0ZjWlFJU3JwTFdCR2I2VnVhdXgxeWp5cEkvRnRGRThkd1JISkJXL1FmT0Zr?=
 =?utf-8?B?eTFvU2gzS3pzbHZxRkNIcHI4M1o0YXgyeHBlczZzdUZ0bnh0dGpPam1XTVQv?=
 =?utf-8?B?RnJLbmxsLzFWNWNMTkZySU1BekJ1d1ZwOXpJNnhCMDZCYmFrOHNvRHpMVmZz?=
 =?utf-8?B?SGRBdWVnL0gyQkxOT0d0U2YyTjVYWG5UZEJWcVV3OW43dnNRbmJySUh2OGpJ?=
 =?utf-8?B?ZVBjUVdWTzVYSGtkNVFaUUtNUVBTOFZnVDFnYkNKazNTaUpzQ2ZFcG5HWXZV?=
 =?utf-8?B?MWZwYytqczlTUHZVTEwvSFUveWVyVHp2VjU2bnhuWVhKN0kvdDE0NWhhMFl2?=
 =?utf-8?B?M3llQTA4WFNzV3JhSVFwaVd6RVFRNDkraWtwWWI4WVlPNU94Z2dQUEkzM3N4?=
 =?utf-8?B?NVRLZnBvbUJFMnRkc3l4UUMvUGlZTTNpMXdaelRFODlFUXVHZFY0aUdpQ0xS?=
 =?utf-8?B?YjJXMlFyd1NoZFFpUjlhTG8yOUJzcDhPbFdIZTBZSHBGcXg3OTM2SU8xNVFa?=
 =?utf-8?B?YnRMcEpkaWxETXloV2s3QVAwd2VHNzVaQzREbkplMlFwTDkwTHlITFpIaTQw?=
 =?utf-8?B?RU9YYk11blk4U0VlcWIxWmw3YUpVa0ltUzVDNnZzS3c5Y3J0cTVHZUU1UHk0?=
 =?utf-8?B?d05VcTVjdE4vc00wVEtjaVRXWFJlL0dlSitzUjJZcmYwakVYNCtaM0plYUlE?=
 =?utf-8?B?aGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77811fa2-3ae1-48a8-cd29-08db68e838d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2023 12:51:19.7399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d9mHX03dUkP8oJE0oFRQ9gqjXUODlXqDwyQpoNqksKjBULDHEUjTmt3TwzlFqoqc/xWqiICJrboYMLjYqGFvD/C+pRvT1gFM5BklvX5JRhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6020
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PkZyb206IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT4NCj5TZW50OiBNb25kYXksIE1h
eSAyMiwgMjAyMyA0OjQ1IFBNDQo+DQo+T24gVGh1LCAyMDIzLTA0LTI3IGF0IDE3OjIwIC0wNzAw
LCBWYWRpbSBGZWRvcmVua28gd3JvdGU6DQo+PiBGcm9tOiBWYWRpbSBGZWRvcmVua28gPHZhZGlt
LmZlZG9yZW5rb0BsaW51eC5kZXY+DQo+Pg0KPj4gRFBMTCBmcmFtZXdvcmsgaXMgdXNlZCB0byBy
ZXByZXNlbnQgYW5kIGNvbmZpZ3VyZSBEUExMIGRldmljZXMNCj4+IGluIHN5c3RlbXMuIEVhY2gg
ZGV2aWNlIHRoYXQgaGFzIERQTEwgYW5kIGNhbiBjb25maWd1cmUgc291cmNlcw0KPj4gYW5kIG91
dHB1dHMgY2FuIHVzZSB0aGlzIGZyYW1ld29yay4gTmV0bGluayBpbnRlcmZhY2UgaXMgdXNlZCB0
bw0KPj4gcHJvdmlkZSBjb25maWd1cmF0aW9uIGRhdGEgYW5kIHRvIHJlY2VpdmUgbm90aWZpY2F0
aW9uIG1lc3NhZ2VzDQo+PiBhYm91dCBjaGFuZ2VzIGluIHRoZSBjb25maWd1cmF0aW9uIG9yIHN0
YXR1cyBvZiBEUExMIGRldmljZS4NCj4+IElucHV0cyBhbmQgb3V0cHV0cyBvZiB0aGUgRFBMTCBk
ZXZpY2UgYXJlIHJlcHJlc2VudGVkIGFzIHNwZWNpYWwNCj4+IG9iamVjdHMgd2hpY2ggY291bGQg
YmUgZHluYW1pY2FsbHkgYWRkZWQgdG8gYW5kIHJlbW92ZWQgZnJvbSBEUExMDQo+PiBkZXZpY2Uu
DQo+Pg0KPj4gQ28tZGV2ZWxvcGVkLWJ5OiBNaWxlbmEgT2xlY2ggPG1pbGVuYS5vbGVjaEBpbnRl
bC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBNaWxlbmEgT2xlY2ggPG1pbGVuYS5vbGVjaEBpbnRl
bC5jb20+DQo+PiBDby1kZXZlbG9wZWQtYnk6IE1pY2hhbCBNaWNoYWxpayA8bWljaGFsLm1pY2hh
bGlrQGludGVsLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IE1pY2hhbCBNaWNoYWxpayA8bWljaGFs
Lm1pY2hhbGlrQGludGVsLmNvbT4NCj4+IENvLWRldmVsb3BlZC1ieTogQXJrYWRpdXN6IEt1YmFs
ZXdza2kgPGFya2FkaXVzei5rdWJhbGV3c2tpQGludGVsLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6
IEFya2FkaXVzeiBLdWJhbGV3c2tpIDxhcmthZGl1c3oua3ViYWxld3NraUBpbnRlbC5jb20+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBWYWRpbSBGZWRvcmVua28gPHZhZGltLmZlZG9yZW5rb0BsaW51eC5k
ZXY+DQo+DQo+QXMgdGhpcyBwYXRjaCBpcyBxdWl0ZSBiaWcgYW5kIHRlbmQgdG8gYWNjdW11bGF0
ZSBxdWl0ZSBhIGZldyBjb21tZW50cw0KPi0gYm90aCBoYXJkIHRvIHRyYWNrIGFuZCB0byBhZGRy
ZXNzIC0gSSdtIHdvbmRlcmluZyBpZiBzcGxpdHRpbmcgaXQgaW4NCj5hIGZldyBzZXBhcmF0ZWQg
cGF0Y2hlcyB3b3VsZCBjb3VsZCBoZWxwPw0KPg0KPmUuZy4NCj4NCj4tIDEgcGF0Y2ggZm9yIGRw
bGwgZGV2aWNlIHN0cnVjdCAmJiBBUElzIGRlZmluaXRpb24NCj4tIDEgcGF0Y2ggZm9yIHBpbiBy
ZWxhdGVkIEFQSXMNCj4tIDEgcGF0Y2ggZm9yIG5ldGxpbmsgbm90aWZpY2F0aW9uLg0KPg0KPih0
byBiZSBjb25zaWRlcmVkIG9ubHkgaWYgdGhlIGVmZm9ydCBmb3IgdGhlIGFib3ZlIHNwbGl0IGlz
IG5vdA0KPm92ZXJ3aGVsbWluZykNCj4NCj5Qb3NzaWJseSB0aGUgc2FtZSBjb3VsZCBhcHBseSB0
byBwYXRjaCA1LzguDQo+DQo+Q2hlZXJzLA0KPg0KPlBhb2xvDQoNClN1cmUsIEkgc3BsaXQgdGhp
cyBwYXRjaCBmb3IgdjggKG9ubHkgc2VwYXJhdGluZyB0aGUgb3V0Y29tZSBvYmplY3QNCmZpbGVz
IGFuZCBoZWFkZXIgZm9yIGVhc2llciByZXZpZXcpLCBidXQgZGlkbid0IG1hbmFnZWQgdG8gc3Bs
aXQgdGhlDQppY2UgcGF0Y2ggeWV0LCBob3BlZnVsbHkgd2lsbCBtYW5hZ2UgdGhpcyBmb3IgbmV4
dCBzdWJtaXNzaW9uLg0KDQpUaGFuayB5b3UhDQpBcmthZGl1c3oNCg==

