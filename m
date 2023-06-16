Return-Path: <netdev+bounces-11514-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 434F2733643
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:39:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65D8D1C20C7B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393F518C07;
	Fri, 16 Jun 2023 16:39:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B75E8F59
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 16:39:42 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A911707;
	Fri, 16 Jun 2023 09:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686933580; x=1718469580;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4X2cAOCAC282WSTig/JBes+XSv4Trkdt9jzbwANR3vQ=;
  b=LSs1pD+gi6sXBKQKKReC+1KzDQC/YdaU2hGMa6mX7Heus1Rv4zlKjc+h
   hmg294nitTxbuEfiisBNL3fQS7URZPMxJRj0/EPxxWzG1RbdS5xXO38NQ
   G/JDDepqDErS37MtYpoMsd/ikVrowkOgeXSTo80gQs3H+Rds76eZqMx2S
   E8LH1SEr1Yu2cROOTiy8S4U+d7f3UQ7Zbo12AXGH0GY67q0dqEuAcjo/0
   F1glR1/cLbgJKqfOhtXmHkbftyVq0A4f0E6IEUeEaxyhRG0yScnSv0E92
   J547q4eF6CPrRH0ra7TL47vsM54wty+sG8Cl3RT0w50eNkDQCIygrlECG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="338873877"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="338873877"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:39:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="778216556"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="778216556"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jun 2023 09:39:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 09:39:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 09:39:39 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 09:39:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ED0IPlyQgcQLIZZOPCv1A+vEc2Qo/zcFScRe2LmeVCmbNvaTUePfxvHiojNbk/Ba9FqHkrXjvcQMAs3ayWBtTGGNurv448KRGotCkIj+L22m2hPw17jmXGxGJyYUX4NQGuw2mvYK0JPQnUk2faICJ3NmMmQm5U/oAioFZoMaudybIbj5V8FgAm/Pc5mozz49D17pbRdLD/zccbA/8kn7WOlBD6c3YfYdc13AOVnFHBzKvZ3Orf9IS2vJIZoNNPenIJzVMwSNitAbpEZcuIazrN4T+X2+clFSZzzEIDoAyotpSZRSMPKU4py2nFnVVpzL8J5yCLYn6JDnfkQk8Gx2qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4X2cAOCAC282WSTig/JBes+XSv4Trkdt9jzbwANR3vQ=;
 b=jOfBrA9qjaKbTIqywGW/4Mvdsf74Sed2jROsQWW827bubFshkU0qrtGyVziBQ4Ts3gM9Rdd4LTiosR18/Q+UP+p9DMkfLosXkQy9e9SeQ5rwjRavPopNz8qnOqMRl5bBUG3N0KIlvc5yq6dj7d+3CM3K8PdXHaDQxRMgmH0Vm+5GuYoDXImCh7Qj6ykGacTVn0wInjStD7oNgco9vetIeSw6L8sjKt4qNa3MGsJz+w3svJoseYRX7W2UswJGK1MNpYbWKh6+dnwe6CTY3SQc+3zULbtB/YkxxGBtVFx0i+B63nv6LBM/4gP3zttxOZr+68wCiCNqiLRepRyNGJKZBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com (2603:10b6:a03:459::14)
 by DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Fri, 16 Jun
 2023 16:39:36 +0000
Received: from SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::dfd2:5a47:bfeb:aa2e]) by SJ1PR11MB6180.namprd11.prod.outlook.com
 ([fe80::dfd2:5a47:bfeb:aa2e%4]) with mapi id 15.20.6477.037; Fri, 16 Jun 2023
 16:39:35 +0000
From: "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
To: Florian Kauer <florian.kauer@linutronix.de>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>,
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Tan Tee
 Min" <tee.min.tan@linux.intel.com>, "Gunasekaran, Aravindhan"
	<aravindhan.gunasekaran@intel.com>, "Chilakala, Mallikarjuna"
	<mallikarjuna.chilakala@intel.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kurt@linutronix.de" <kurt@linutronix.de>
Subject: RE: [PATCH net-next 0/6] igc: Fix corner cases for TSN offload
Thread-Topic: [PATCH net-next 0/6] igc: Fix corner cases for TSN offload
Thread-Index: AQHZnsmr6RJrKMVwJEipSQnMpRCh9K+Nl7HggAAE4gCAAAapAA==
Date: Fri, 16 Jun 2023 16:39:35 +0000
Message-ID: <SJ1PR11MB6180B8CEF4F0F86E405908CBB858A@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20230614140714.14443-1-florian.kauer@linutronix.de>
 <SJ1PR11MB6180B5C87699252B91FB7EE1B858A@SJ1PR11MB6180.namprd11.prod.outlook.com>
 <908bd8bd-8629-f6e4-40f9-77454d52100d@linutronix.de>
In-Reply-To: <908bd8bd-8629-f6e4-40f9-77454d52100d@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6180:EE_|DM4PR11MB6020:EE_
x-ms-office365-filtering-correlation-id: 7b426325-bc58-44fd-b6e8-08db6e8844d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s4ma6vh05Al4AUes8SZtNxmMb2/lOTdPDZkgFNYwd2m2jfWQK7ZrY6MfF/UcJKw4ZHSPH20LixxIHWLH7WICmYzHncGvutmS5B4kjEqxbYnLO5vxW/MPJ6JxeWGBOpTjnxg0U/mcCgR7g8Kz8kiM4VztNTRVki7kljzbz9iZPRNtxbKfGb2AjV1Y7wL6hWO1m+W7gp10udf9yWZtOOyAp8Z/Tu7qRWJaVKCrlKP04WZCOUID47p5Q3LI2dbiD4FdEmySt0NRchjtMaS09OawTMoxXLNYxr3PedSClodpk4Azng6u3w9kFwaib4ccsdWKYow/JTckVk2BO2o9lEV4KgicKC173ou9XpUPXA9Ie5RynwSIuZtBtzaEWo0CvjaLefCIVb6VMKW03o3LqBREBwv9eHjJ7z1qWr8nj0c21MMsGlLMD79Kx6xie1XN9fH+FMXgYDsLwTJZVBe/ICxqOr7uvTe/sgxYgEHxgkE2Vzg5pJs7d1MYCQqfI8kxgta5QcCkSuicdeC5aTWQOWzIsjVE9mSN6ySXEmbs3tq//1DM5+qT1xpWeCXuossZsze4AZnldqYxnCOv3gJtqBiLlMBnn3UrK/SZVGaTAUDXYHuLtB4EGbAUefwaKj40JFU7YH325af9Fg5eXV3pLgoztg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199021)(8936002)(8676002)(83380400001)(2906002)(5660300002)(64756008)(316002)(33656002)(52536014)(82960400001)(66556008)(76116006)(6636002)(66476007)(66946007)(66446008)(4326008)(921005)(122000001)(38100700002)(54906003)(110136005)(41300700001)(478600001)(53546011)(9686003)(186003)(71200400001)(26005)(7416002)(6506007)(55016003)(7696005)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWM0QWROYkl1WTE2MTRxeUpLazZaMWZJMXkyT2tMU2xKRlBVSDBMWkdnWFNw?=
 =?utf-8?B?bUNUYUdJdzg4am9DdVk4WjArRjFNYWpoUEJRSm5ES2g0UGNObVQxRGlzcUJp?=
 =?utf-8?B?RnpWNC8xKzNBa0pyV1lQUlZCY1AxOVFicFZsV0hvZzgxWnU3RFM1WS9NaFVC?=
 =?utf-8?B?SEgrU3NJRmFwazl4TGRTR0Y2YzRmQkZaNXlPWGlwQW1GZkpha1NGMTV5alRr?=
 =?utf-8?B?TFdKTlluaFBjV2dBeUFBRDllVlYwZXQ5ZDNhVTNvbnBwa2t5alovVlJUS3Jk?=
 =?utf-8?B?azdnbFE0SUlQUWQrQ2dzVDRTN3ZQZ1BEOGwyWkdkQlBWWTFMTjU5V0ZIWjVm?=
 =?utf-8?B?bCt4MEZjRmtaOG9NWmcrQ2oraE50cmhGNmxQbURQU2N0UTdmZTBLeCs0d0FC?=
 =?utf-8?B?NzVLajhlbUVwbDNaZU1rUlIxWE9OalJRdi9KZzllTjZ6dTBuRkNTSjlKeWZp?=
 =?utf-8?B?Nlk1L3BQUFBDS0FZOG1RODFEcnhYUGhpajBMNFRxWWZlQ3NhdEsyZmIyY1pp?=
 =?utf-8?B?NklwU09rWllEVnpwSVZ3c2pZdy9XWDlSUTIvQTJKZnNGQ3NpNFV4dytTT2o2?=
 =?utf-8?B?QUU0NUZmOFJnTkFBQXBoZDIySCt3Z09aNlVSY211R05mcy9kcCtQQjY3YWJo?=
 =?utf-8?B?cVZrT2hzaytiWGJBeVVnTXE4ZXBMYVg2eEdYOHBFWFZFNUJWd0s0aC90VkhY?=
 =?utf-8?B?ZlR5SHFXTjlPS1BGSHh2MzlURSt5ZTFHRytsWDMzU0ViQTEzZXFZZElvMVhn?=
 =?utf-8?B?dnNxUEpERXlGeGdTblNGb0RRMWNOTXhxNG5VekxIUUVwZkM4VTc5OVBMSXdH?=
 =?utf-8?B?Mkd2aHRCRXBBU2VXS09ISkhzaVJ0S1dJcDFWRUthYTVmTHorVnlIK3Q2dXNv?=
 =?utf-8?B?OE82TU9sNURlc1dYcTlCc2dVUDVVV1JRb0hldk5sSGt1K3lPYUlsT1lxdUxH?=
 =?utf-8?B?Wms2UGhRQ1hRQ2piblptdEg0ZGVLVWVsMGZnQW54UVpvckNQVm1UN0RaM0lk?=
 =?utf-8?B?RWYvNkx2QmRwWS9SVE8rcWhYbWlPQmptYmpSekRXY2hDaG1tRGNrelVXT2l1?=
 =?utf-8?B?aXlWVEIydjFqdzk4Z3JvQWU0UXQ4NXozTzA3M25vZnVTR2NDZzN4em1lTXd3?=
 =?utf-8?B?L2VYYWJHSnMyOEJTcTEvVWZEaElNTG5BOWdleWQ0OHk2WXlMeGY5cWJOTDhX?=
 =?utf-8?B?WGhWbkRVallkeVhHUWNYKzRCbEtUV0RETTg1YUkwSmZlckM5M1ZwZnkzb2Y5?=
 =?utf-8?B?b0JzYndzWlJtaHVCRzdQTURKQXNVWjRBSnhLazByZExicTlkeWF3QS9MUkJB?=
 =?utf-8?B?RTJJUzU1aXJJcXV2a1l2bnp6ZHhWODhHdVJxOEVsdmtDRlJkdTVVT2dZeU8y?=
 =?utf-8?B?R2FSTFUxTDdYT29VRytiWFZacEU0NTE1QjEvODBSNXZVNTM2N3pJWitkamda?=
 =?utf-8?B?OFd4aXV6Tyt6anZiK0h0MkVMc0xwWFgvTklxejRaSVo0dERqQmF0Sk4zeVha?=
 =?utf-8?B?Zyt3V0NQUHRIUUcrY2RZbUMrTGIxSkZKTG4vQnErU3lQNjdTSGE0UGNVcjdy?=
 =?utf-8?B?UzAwaHd0NnppcmpRTXIrSWxHNy9wV083R2ZlQ0pjeVZuOUZYSUhZUFM2ZGNE?=
 =?utf-8?B?ZkhOQmcrNjFQQktDWEtWTXhzTU51b1pwSHcxa2lWSFdBR2FSR2l2Ui8zWXBo?=
 =?utf-8?B?Mnd3S0NTdzYzcUNlckFzK3dpWlJSdW5vNzF0WUZ5RUZQZkkxZnVsT0lGckFV?=
 =?utf-8?B?RHI4bGhFdFc1Z0QyaWpoUGlBWTRsa2JYV0RTbE5KMHlFZXNNdFNEVDc3cnFP?=
 =?utf-8?B?ZmhOd3U1ejMxaFlGZ0RidGdrQ0RGallTcHhBRjlwckIvUks1eTVMb1NLQ1Rz?=
 =?utf-8?B?QVR1NkJ5TlIzMzd0dTN3eGVDaU5yaVBaUVpmU29DdENIM2NKcHJKNThDY3lC?=
 =?utf-8?B?dHo5TEc5eVZHSGJoLzFHbW5maGVHNVFlMVNhRnZtN0VhVFh3ZTJ1MDF5aytD?=
 =?utf-8?B?QzhBRlhYL1dvUUxNS2VaY3pYSVVXbmNHRitKbG9ZRFRUWGY5d3QwSUZucmZ5?=
 =?utf-8?B?TTBCL0pFbDVleGxLenpkMGNxbGhsNjRub3Mzc2Jub0hjRk5SKzRwWWxqVHF0?=
 =?utf-8?B?NGJOdEZvZEtSZWhUbFMyNi9pdDhVS0g1aFRkZTVITCtLZ2UrZlV5TmhwOE9r?=
 =?utf-8?Q?BVy9tRCp5Du+HPQv4MAJPkE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b426325-bc58-44fd-b6e8-08db6e8844d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 16:39:35.1525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jOanN/0Zs3U+klp+FA17mw7Q0LaYraWc4CzV3usq+FPIkxLEyX6XSw+f9uEqErZS53ovKQRab+9opiVdoOGhSZpTgPm2FD+U6AGr9jTrQ/dM3LyGbDkI03KL2r+qi76L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6020
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmxvcmlhbiBLYXVlciA8
Zmxvcmlhbi5rYXVlckBsaW51dHJvbml4LmRlPg0KPiBTZW50OiBTYXR1cmRheSwgMTcgSnVuZSwg
MjAyMyAxMjoxMSBBTQ0KPiBUbzogWnVsa2lmbGksIE11aGFtbWFkIEh1c2FpbmkgPG11aGFtbWFk
Lmh1c2FpbmkuenVsa2lmbGlAaW50ZWwuY29tPjsNCj4gQnJhbmRlYnVyZywgSmVzc2UgPGplc3Nl
LmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsgTmd1eWVuLCBBbnRob255IEwNCj4gPGFudGhvbnkubC5u
Z3V5ZW5AaW50ZWwuY29tPjsgR29tZXMsIFZpbmljaXVzIDx2aW5pY2l1cy5nb21lc0BpbnRlbC5j
b20+Ow0KPiBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgRXJpYyBEdW1h
emV0DQo+IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVs
Lm9yZz47IFBhb2xvIEFiZW5pDQo+IDxwYWJlbmlAcmVkaGF0LmNvbT47IFRhbiBUZWUgTWluIDx0
ZWUubWluLnRhbkBsaW51eC5pbnRlbC5jb20+Ow0KPiBHdW5hc2VrYXJhbiwgQXJhdmluZGhhbiA8
YXJhdmluZGhhbi5ndW5hc2VrYXJhbkBpbnRlbC5jb20+OyBDaGlsYWthbGEsDQo+IE1hbGxpa2Fy
anVuYSA8bWFsbGlrYXJqdW5hLmNoaWxha2FsYUBpbnRlbC5jb20+DQo+IENjOiBpbnRlbC13aXJl
ZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+
IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGt1cnRAbGludXRyb25peC5kZQ0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIG5ldC1uZXh0IDAvNl0gaWdjOiBGaXggY29ybmVyIGNhc2VzIGZvciBUU04gb2Zm
bG9hZA0KPiANCj4gT24gMTYuMDYuMjMgMTc6NTMsIFp1bGtpZmxpLCBNdWhhbW1hZCBIdXNhaW5p
IHdyb3RlOg0KPiA+PiBGbG9yaWFuIEthdWVyICg2KToNCj4gPj4gICBpZ2M6IFJlbmFtZSBxYnZf
ZW5hYmxlIHRvIHRhcHJpb19vZmZsb2FkX2VuYWJsZQ0KPiA+PiAgIGlnYzogRG8gbm90IGVuYWJs
ZSB0YXByaW8gb2ZmbG9hZCBmb3IgaW52YWxpZCBhcmd1bWVudHMNCj4gPj4gICBpZ2M6IEhhbmRs
ZSBhbHJlYWR5IGVuYWJsZWQgdGFwcmlvIG9mZmxvYWQgZm9yIGJhc2V0aW1lIDANCj4gPj4gICBp
Z2M6IE5vIHN0cmljdCBtb2RlIGluIHB1cmUgbGF1bmNodGltZS9DQlMgb2ZmbG9hZA0KPiA+PiAg
IGlnYzogRml4IGxhdW5jaHRpbWUgYmVmb3JlIHN0YXJ0IG9mIGN5Y2xlDQo+ID4+ICAgaWdjOiBG
aXggaW5zZXJ0aW5nIG9mIGVtcHR5IGZyYW1lIGZvciBsYXVuY2h0aW1lDQo+ID4NCj4gPiBBbGwg
c2l4IHBhdGNoZXMsIGFzIGZhciBhcyBJIGNhbiBzZWUgaGVyZSwgaGF2ZSB0aGUgRml4ZXMgdGFn
LiBTaG91bGQgdGhleSBnbyB0bw0KPiBOZXQgaW5zdGVhZCBvZiBOZXQtTmV4dD8NCj4gDQo+IFlv
dSBhcmUgY29ycmVjdCwgdGhlc2UgYXJlIGFsbCBmaXhlcyBhbmQgY291bGQgZ28gdG8gbmV0Lg0K
PiBIb3dldmVyLCBpbiBpdHMgY3VycmVudCBmb3JtIHRoZXkgd2lsbCBub3QgZnVsbHkgYXBwbHkg
dG8gbmV0IChlLmcuIGR1ZSB0byB0aGUNCj4gY29tbWl0IDJkODAwYmM1MDBmYiAoIm5ldC9zY2hl
ZDogdGFwcmlvOiByZXBsYWNlIHRjX3RhcHJpb19xb3B0X29mZmxvYWQgOjoNCj4gZW5hYmxlIHdp
dGggYSAiY21kIiBlbnVtIikgdGhhdCBoYXMgb3ZlcmxhcHBpbmcgY29kZSBjaGFuZ2VzKSBhbmQg
YXJlIGFsc28NCj4gbm90IHRlc3RlZCB3aXRoIG5ldC4NCj4gSWYgeW91IHByZWZlciB0byBoYXZl
IHRoZW0gaW4gbmV0IGFscmVhZHkgSSBjb3VsZCBzZW5kIGEgc2Vjb25kIHNlcmllcy4NCj4gRm9y
IG1lIHBlcnNvbmFsbHkgYWxsIG9wdGlvbnMgKG5ldCwgbmV0LW5leHQgb3IgaXdsLW5leHQpIHdv
dWxkIGJlIGZpbmUuDQoNClllYWggSSB3b3VsZCBwcmVmZXIgIm5ldCIgc28gdGhhdCBpdCBjYW4g
YmUgYXZhaWxhYmxlIGluIGN1cnJlbnQgZGV2ZWxvcG1lbnQga2VybmVsLg0KIk5ldC1uZXh0IiB3
aWxsIHRha2Ugc29tZXRpbWVzIHRvIGdvIGluLi4uLg0KTG9va3MgbGlrZSBvbmx5IHBhdGNoIG5v
IDIgImlnYzogRG8gbm90IGVuYWJsZSB0YXByaW8gb2ZmbG9hZCBmb3IgaW52YWxpZCBhcmd1bWVu
dHMiDQp3aWxsIGhhdmUgY29uZmxpY3QgZHVlIHRvIHRoZSBuZXcgImNtZCIgY29tbWFuZCBpbnRy
b2R1Y2VkIGJ5IHZsYW1pZGlyLiANCkJ1dCBJIHRoaW5rIHNob3VsZCBiZSBtaW5vciBjaGFuZ2Vz
Lg0KDQpUaGFua3MNCg0KPiANCj4gVGhhbmtzLA0KPiBGbG9yaWFuDQo=

