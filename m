Return-Path: <netdev+bounces-9021-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A386D72697E
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:09:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B9161C20E89
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8172935B33;
	Wed,  7 Jun 2023 19:09:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663E46118
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 19:09:00 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278CA1721
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686164939; x=1717700939;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y9zXMFAPTO8dNV3eS92IMXKDUBYil58ES6yH8tYJJKs=;
  b=XdpqBuLoOTcePSK5SfQxIThQW5+wma6afn9qRgWrrdy7SJUVJ86XZN/G
   tGF6B1OFgFa9o5CSQW4idblFd0MS4E7LbmWF2Kc8MwIkJLfK0hXI2ZF04
   7NtvqHlHWe26QrjQJo4UoT1YUTEcmlFIIw5yCnjRzW5DHrQ/GeQrVxmLL
   v1dPaqlqGfT11QMYCvGvLuxSR7/N+PglxGNwS/MfsEhNgQ5aV7zhBjlYK
   sN3TtKP6aMhL/3SXxUeU+hwIqFCSvgao22Cz3ORceK90v4HTnmH13EHUa
   FrZ7ir3r9eCk+p18CY+ZpTJ3ofWVqs29cf9GClhyu1SNk5+jCcI41s93s
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="336711679"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="336711679"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 12:08:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="687091417"
X-IronPort-AV: E=Sophos;i="6.00,225,1681196400"; 
   d="scan'208";a="687091417"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 07 Jun 2023 12:08:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 12:08:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 12:08:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 12:08:52 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 12:08:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0vCmNG7QdS8nUFLTm+dMG9IcKaYhpqb9QfT+cjJD5+rbiH67LVhqBvCPBQY7kEPzxWPP7TpuXRBps69W6XK4BsXdwsaFQRTwdswNBehiGU2me0QhijazryVOIIIaZyyMucBktjxK16fZIG9F8sXpsU1mL54TDXklwUIlvXgrNBgJkzA3x48BBUfgF8Ca5Oc89v5JrDMblLdZbp7mcCVJTYFYkRCMYf981V2apE6BiTGsorHqwVq9UCaAbjt0Tlk85INNGSF+4zzwnt+nKVwgfhnFVfzJOkVDeaCwHGGA8LTSt4KnC6Vp0alk6vugRDtQCmbVKSovhnppfGfRTOk3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9zXMFAPTO8dNV3eS92IMXKDUBYil58ES6yH8tYJJKs=;
 b=MsfBrS02E21wtO1XzEF+B9d1CPTGOD1Bpwfo3SNzUufsdSrs0cI+Ea/fEG9I4ZbiGGlWD++iyaONHQVVM/MZmG7uZgn7MJh0ozWDktxAe/vEmnoimvt7FuB/oTwyu4Ius3JpLz1G7rwN8FXjeVfRBKXdx+H5N7v5VGcvUCqAp4Rjj7aeEwQIfsgrUNIvhqQNO290Ujo6e9HQb8TABgOFNI3klAx2uqoIdpUVCo8117xoh1BttCO5YXUDuKUWiLW/QxO3j+pwjwhYTW4SouQamcdtfl55NGOof9CIUBMFyGFDQOBJX5u3/laeSAAg+BvIQVYpRvfYGAwyH0hNeunsIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM4PR11MB5439.namprd11.prod.outlook.com (2603:10b6:5:39b::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Wed, 7 Jun 2023 19:08:51 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.016; Wed, 7 Jun 2023
 19:08:51 +0000
From: "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
To: "Kitszel, Przemyslaw" <przemyslaw.kitszel@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "Gardocki, PiotrX" <piotrx.gardocki@intel.com>
CC: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>, "Romanowski,
 Rafal" <rafal.romanowski@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/3] iavf: fix err handling for MAC replace
Thread-Topic: [PATCH net-next 2/3] iavf: fix err handling for MAC replace
Thread-Index: AQHZlXZEVq7haUmEw0qSncssc4TKPa98mc8AgAD6t4CAAdChgIAAVCkQ
Date: Wed, 7 Jun 2023 19:08:50 +0000
Message-ID: <DM4PR11MB6117A7B1423198E6478E4FDA8253A@DM4PR11MB6117.namprd11.prod.outlook.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-3-anthony.l.nguyen@intel.com> <ZH40yOEyy4DLkOYt@boxer>
 <29e3a779-2051-d4bd-08fc-2835b05de55c@intel.com>
 <e5f6407e-e19b-636a-a90b-3d1d6f7beca0@intel.com>
In-Reply-To: <e5f6407e-e19b-636a-a90b-3d1d6f7beca0@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB6117:EE_|DM4PR11MB5439:EE_
x-ms-office365-filtering-correlation-id: 05c18ebe-c39c-412c-9a88-08db678aa120
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ITbViFnxABfV0Sog3mBbLxLOR7mFt9aYARIirOw85IijxhfF5UbNYCsubkhU33wyEOInFmeujhHvsOuY6nLWqUBCKG497l478LN10Bi8u/Rs0+kC015nUivBlKx1p++MebywDXcIjdS/HuIfdXmUVSZ+0SAfJpbL6dQufGGDvbxzy0DnLjeBr3UQjYIcF0ZXsXjL0pHOZ9exX9Az8BgZDLPwLM8dkHZI0tf45wjGH2au9ap+T2Lb85Tv9pj4QchsOB+GXaw+YhFalB4Tp1IEFLfcpGk7IbG9zVPQWbkdTZsuI6oB4otpsRs4drd6BJ0CpB765GhtG2X09NZGjus/WZX+y1TE2VRFG4LOBbNVrT0OrHN81doLz1opxz5feIT6z7NsPF8noSaWbikO/oJ4NYGXwZJ6iKpapahBdBFAn3v3hGSOvAHKNAkvGZj8grXeuxRklAXJDD/I678K6d8lUO8ucm+pAtxNCCoKs12BbtOgV48u6J70OIBhdx9tfLXbwjmr4+zHGKT3kyPPpshDgBJuCYgRnTuB0oldJC4wTpOWaMec1zG/FphYveUeL0FMS4UAPJ6OshtdPnchMBgfGeTB+MfIoPfhp8b78WDPuno=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(366004)(346002)(39860400002)(136003)(451199021)(86362001)(478600001)(110136005)(33656002)(55016003)(8936002)(8676002)(316002)(41300700001)(38070700005)(54906003)(64756008)(66476007)(76116006)(66556008)(66446008)(52536014)(66946007)(38100700002)(6636002)(122000001)(4326008)(5660300002)(4744005)(82960400001)(7696005)(2906002)(71200400001)(26005)(186003)(6506007)(9686003)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UnZNTnlNVVpaVWpQb1ZKZlJUcXhjZXNxUDBZQ3J4aHdxUnpIZitjay9PSjUr?=
 =?utf-8?B?bXgvQmZ0VkhmRE1GMXBIUllUQTdIV2YzN2djZEpmb0xYZXJBOXc2MHhRejM2?=
 =?utf-8?B?eExOZkdnNVZmLzlWVkFWUnFiY1FZQm1uSSt1KzIvWXRzUnRwYzFlS1oxd2xs?=
 =?utf-8?B?Nm5uQkVKZmxwZG90SmJaa2NjUE1aNUxaeWNZVjU1M2s1MlBQbTEvcHpLb0VJ?=
 =?utf-8?B?M1ovanJGdGlib3FNUWJvQTY2YXludzc0bDIxeXRBcjU5ekFhTVhkY29veUtJ?=
 =?utf-8?B?SUxBV0Nzb0F4dnhpRjUvY2QwMUFvL3pxSlUzQnhSYWN1MEFHck5VUStkM1RT?=
 =?utf-8?B?Y0d4UGE5WEIvM2VTK0NxVHRvUG9Vd3NpRzE5NWk3OG9vNEJtcVVtaVlzakpu?=
 =?utf-8?B?Vzl6WWFab3hIeERCSkExZWoxaGFUVlBDYjJIS3FXbzZEZDFpSU1nK1VpUHRZ?=
 =?utf-8?B?RVpDQlozWnhlb29MRmlnTmZPUTJFMTVOUVlsY2UydUtHOU4xYnk1L2RzVHNC?=
 =?utf-8?B?OHJaWUpxZVRaRm5RbUZ2TVZqYkUvWlFZWDI5Y1Y5RlY3a1JEbVAxbGVoZEk0?=
 =?utf-8?B?cVcyY1RaNllNQXBMQUlaeXVwT1ZMdm1xOHJNdU90SEhYTmZ4akJ0dVNtbjRo?=
 =?utf-8?B?dXF4dFhTWnBpRWJQZ0p0c2pGVTV6MjdBcWRHR0dCV3FXRy9EOUFmaGU1c1Bz?=
 =?utf-8?B?RXg5N0ZZK1ZkWGgrbEd0SC9xUkJFU2swS0h2VTBlNmYvU3pXZXF6NjhQRzE1?=
 =?utf-8?B?b2MwdE04Rm9UTmRjbndKY2xFbE5SN0N1M202OWdHWXpxMitEZ0I1UUJ4QWY5?=
 =?utf-8?B?L2RLanhYSVY1YU1rbURjSjRtSFZDN1FmblF6eVZ6UC9Nc2E3aHlwaEJwcDBI?=
 =?utf-8?B?dkF5QjBhU3c5ZFkzWE5VSUVSWHVWUUVKak9sRGVaWnlKU3JaaHN4TUltWnNZ?=
 =?utf-8?B?cHUxRjF3Ni9YS09qdk9GYU53SUhlY3ZzTyt3R2Z4ekw1d00rMVdPaTFIdDFS?=
 =?utf-8?B?T0VlclpxMlIvanBxbjI5Qm9jT3VUV3FsaUFYeWE0K0pRVzZEOVFFOVZIT1RJ?=
 =?utf-8?B?YVJFeTVrUVphTTlQVkhtbVdXUHdwdTNSTmw0NmEyZzhDdmFvYStaUU80aTJk?=
 =?utf-8?B?cEc2Wm9qV25xb0phNXlSVTVnMVZZQmc1Wi9OWTNVbG8reHkrZjNSUk5Sbjdu?=
 =?utf-8?B?Q0ZRZ3NBamNaa0F5RU83MjdDcE45dE1RZmJlWS8rb2hXd3VoV2Y0Z1l4VUxC?=
 =?utf-8?B?UzgvbWFSbVNJZ2kweHZ4MVY2Q015SCtmZUxQNFRNTXNqV3ZlYUVSUm9RSTFV?=
 =?utf-8?B?KzdFeVhrWlBrOUkxNEYzTE1ZcDR5S3M3dS9saGJOM2IrSzU3amUzZmNuYWpI?=
 =?utf-8?B?eVhSdE9KVzZYR3VXbTRRTWdDZDVualhzTVlNeWdNM1hVOGM2azB3elBjQU81?=
 =?utf-8?B?bVNTTnNPeE9HTWdBdG1xbm5iSFRLRStheFdLekxwQ0U0bXZWWXJVaEdNUFRp?=
 =?utf-8?B?VmlwbklFYXdtNlhoZHdIYk1kTmRkcmpPRjduWkg5TTZlb0dWeDk3YkY2UCt6?=
 =?utf-8?B?SS8zRkxpaGVST1pFRnA0V05zak5RbDdGdjFIaElpNzE0b2UreGVndGcySFdI?=
 =?utf-8?B?cEc1aDNWbHhaR2tlalRTdGJpM2xlcGx3VG5EYTVRaXZzM2g3Qjg4MVBCQnFB?=
 =?utf-8?B?ZG16cmp4TldyTFhKQitSQ0NxeFVkSjc1UndjZTFwb012T24vNEFNY3FxbUEv?=
 =?utf-8?B?VmZKN0FPNXNDNitKc0EyaG5Ba3pMM1J3WEFwUit2eXhObVVpcUpwUFZ2MzZF?=
 =?utf-8?B?SCttcTZQb1N3Vy91cU04Yk05VWJSV01UQWpIVWtlNGxKVXZmQURKZzlna2dD?=
 =?utf-8?B?bzBNRXJaZ05PZzEvV3BkR0h4aVVNbVJjRnNMUm1PS3ZlUExlb2Q0RVlNMVRi?=
 =?utf-8?B?M1dYRG9tcElpVDM0d3pkTUFmVGdZQXI2QWNERUhhRjJTYVFqZ3gweU5pRnpE?=
 =?utf-8?B?WXdwQ2RNcSs2RlZrZ1ZUVGZlVk5nVS9pVUFncm8xekV5azNnUUI1Y1JJVG5V?=
 =?utf-8?B?OUJoYmlucUh2eDJnRCsrcnNtV3RYcXBFMVZOY1BsWkQvQXl2Z2VGTEZmaUZh?=
 =?utf-8?B?eW9rTkV2d0ZXWWhmbms2bEMwZ2hVLzduaXNsVzRPbVVzUXR0cVlwRXlHYkMx?=
 =?utf-8?B?WUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c18ebe-c39c-412c-9a88-08db678aa120
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 19:08:50.9209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZGIiGtefmL6o0JQYLGXKMfjzdP6Ee8bkyApTUHX4+rLeLwOoOdiYw12tIy8d6gw34XAV2XHZSQwNlZrDGUVRj9ZEdrjxNz0hoLfFp8gaVNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5439
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiANCj4gT24gNi82LzIzIDEyOjE0LCBQcnplbWVrIEtpdHN6ZWwgd3JvdGU6DQo+ID4gT24gNi81
LzIzIDIxOjE3LCBNYWNpZWogRmlqYWxrb3dza2kgd3JvdGU6DQo+ID4+IE9uIEZyaSwgSnVuIDAy
LCAyMDIzIGF0IDEwOjEzOjAxQU0gLTA3MDAsIFRvbnkgTmd1eWVuIHdyb3RlOg0KPiA+Pj4gRnJv
bTogUHJ6ZW1layBLaXRzemVsIDxwcnplbXlzbGF3LmtpdHN6ZWxAaW50ZWwuY29tPg0KPiA+Pj4N
Cj4gPj4+IERlZmVyIHJlbW92YWwgb2YgY3VycmVudCBwcmltYXJ5IE1BQyB1bnRpbCBhIHJlcGxh
Y2VtZW50IGlzDQo+ID4+PiBzdWNjZXNzZnVsbHkgYWRkZWQuDQo+ID4+PiBQcmV2aW91cyBpbXBs
ZW1lbnRhdGlvbiB3b3VsZCBsZWZ0IGZpbHRlciBsaXN0IHdpdGggbm8gcHJpbWFyeSBNQUMuDQo+
ID4+DQo+IA0KPiBbLi4uXQ0KPiANCj4gVG9ueSwgd2l0aG91dCBQaW90cidzIHBhdGNoIGZvciBz
aG9ydC1jdXR0aW5nIG5ldyBNYWMgPT0gb2xkIE1hYyBjYXNlLA0KPiBzdXBwb3NlZGx5IG15IHBh
dGNoIHdvdWxkIG5vdCB3b3JrICh3ZSBoYXZlIHRvIGVpdGhlciByZS10ZXN0IHZpYSBvdXINCj4g
VkFMIG9yIGp1c3Qgd2FpdCBmb3IgUGlvdHIncyBuZXh0IHZlcnNpb24pLg0KDQpXb3VsZCBiZSBn
b29kIHRvIHNoYXJlIGEgbGluayB0byBwYXRjaCB5b3UgcmVmZXIgdG8gKyBzaG9ydCBleHBsYW5h
dGlvbg0Kd2h5IHRoaXMgd291bGQgbm90IHdvcmsgKEkga25vdyB3aGljaCBwYXRjaCB5b3UgaGFk
IG9uIG1pbmQgYnV0IG5vdA0KZXZlcnkgb3RoZXIgcmVhZGVyIHdvdWxkIGRvIHNvKS4NCg0KPiAN
Cj4gUHJ6ZW1law0K

