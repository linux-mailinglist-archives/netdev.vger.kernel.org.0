Return-Path: <netdev+bounces-10391-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2E5B72E406
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E2892810CC
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7838A31EF3;
	Tue, 13 Jun 2023 13:25:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64543522B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 13:25:57 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED8F1B4
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 06:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686662751; x=1718198751;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=33lS20173NJKkNXaQePxoW4OqmEUpcZ8mE/F4/rmzMk=;
  b=Qi1vAYOB0pl6K1sS3bYcZboS1Z2i00HXIij/nnl0XYazKczozcWPpmog
   9o24u32dxuoAlXfjlnl/EzdDJZ5P6CqFtw7m8+KAjoyt3AtPiCTFDkd4O
   Jfah1RZvGA0V3FbO9GUPR9nkOYC/VRsTSkNDQUld+qP7XPBSt+WSXXiy3
   v7mblD02TXhLT77Yp4LBI38XApAo/8F5Slcrmg/JbfmVfTvw/HW6W8yoM
   s1GBC6XW1IpKbsReYiBFe8WkSjeXtiJ6J4x/6JQQyWO1ZnGrUCRGWEXhK
   6Oe77ikZRopW9q7qrtBYELaHarZQOR3qR76hWydRTom2WxeVF69AcocDt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361698841"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="361698841"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 06:25:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="835885376"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="835885376"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 13 Jun 2023 06:25:35 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 06:25:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 06:25:14 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 06:25:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fi8dQuQQlvs2fSMa84HnFumIVZeA+4rZ9DkQcrQ33uyjLf9yDLMmcSL5WBWxHZ2wAAapsX6PMGeBq2IhMHtmjdZa+NQzQUjE13NQQGWuL6NO41ugmYLE0Gid2p28YTrhcn3ZrDey8VEY3tvHrFN+SdMsQGUrsxZBiHRroBIUa9BPzUArXrzOKEdkmwwFfEORvHqFG++G0J4XykWLcvUBBn6EGByCGUjy3SXLeoPjgBm9UiEB9AUEk2zur9VGf1raPhMo50eZvufTOLIsCoMTaf7qrdm9HMMjGiLywzhJ0B6Iw9rf/cydODNt1uis4ymUcnkdpMeXcahpH25oj5hsIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33lS20173NJKkNXaQePxoW4OqmEUpcZ8mE/F4/rmzMk=;
 b=Lk+BQbyAOhANRppOyqlEBaTxlkqq1hoBTJb49rQX/ILjdevCbF8BXztJKQLml4kQPWTIPO9JTynAgasq5B6oUCtgTWsWJJJbf6SdVn3QvCA/nDuziD+V/4trFtgquxa1pgsojeMpnNwWuwu0b4WoW9DokmPuCxjbuTOBFD21a48p3U8p7tozea1/H/Tv64oZNxs/uyYvXZfIvbSIkipjFbLN9ZC+W1eK7TfWmmT6WFcrjSCAwxcAh3ogsRvzyUxqMJpx6UyLkzRDlK4ouBI1tWp0V+mg4287e+1CXTiPMyqRV0QW/9Ix6epV8EBssw/WPpEhF4qCh4E3CoX+eaQv6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MW4PR11MB8265.namprd11.prod.outlook.com (2603:10b6:303:1e1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Tue, 13 Jun
 2023 13:25:12 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 13:25:11 +0000
From: "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>, "Gardocki, PiotrX"
	<piotrx.gardocki@intel.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"Kitszel, Przemyslaw" <przemyslaw.kitszel@intel.com>,
	"michal.swiatkowski@linux.intel.com" <michal.swiatkowski@linux.intel.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "Lobakin, Aleksander"
	<aleksander.lobakin@intel.com>
Subject: RE: [PATCH net-next v2 1/3] net: add check for current MAC address in
 dev_set_mac_address
Thread-Topic: [PATCH net-next v2 1/3] net: add check for current MAC address
 in dev_set_mac_address
Thread-Index: AQHZnfIL4be5jb8uK0i9DWDwHD98Da+ItRYAgAADggCAAABdoA==
Date: Tue, 13 Jun 2023 13:25:11 +0000
Message-ID: <DM4PR11MB611742AD2CC964B5C8DFE6A28255A@DM4PR11MB6117.namprd11.prod.outlook.com>
References: <20230613122420.855486-1-piotrx.gardocki@intel.com>
 <20230613122420.855486-2-piotrx.gardocki@intel.com> <ZIhq4Mb7+jGxIdAn@boxer>
 <1e2404ff-232b-5999-cdb2-4205c58b071f@molgen.mpg.de>
In-Reply-To: <1e2404ff-232b-5999-cdb2-4205c58b071f@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB6117:EE_|MW4PR11MB8265:EE_
x-ms-office365-filtering-correlation-id: 69a8321a-41c5-46eb-1d72-08db6c119da0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vsUP8bSQQA1vVpJdRVDLKL3Jp2igCBuJiOzwuTDSfQnTAxn3Zn4Ornn0s/gfiB9ay9wIftlG1DPbfxo0U6/BqsSVuGZ0vYXLipnT8gDQ8yojIxcswix+vh867IrUxdtXQiYOL0qVU8pZE1fLOuiXe6NJAg124sSQSdbu8U3djlbL7XaSWMTEeLkG+ylqAGfo8Dk0hjxAkT2y0v5i080tVQOLdggr0p4qq2YwhG8beHjPsGxAGjiQ/E41KZLr7pUVaWzM7zAFqYFhoeO3Ri5OzuQGHa9UbSHkjvf3uXjT2u2PaHfE8Rynutx3LIQtqN8PXyevwh9aGyDUwQRiB5824wNheFwbpgvnL41WH3L533rhabjVPmJbgttSITqZpzUWua7jzsNGAT6LzILYG8/PKGIOgK97BDVxX6RxMD1yw+S/9+Is+v/QhQP6Lf/PnqP58sIM4izxhsOMdxYYm7335H5oJk56ajXgbe9ave18Z/6Wln5pLwrp8g8h1DAdutjMynJ7ROf2dWAQLd+WZ1gWGZ5N51KgGmIljPKOz3887vSVDdqD03NmQSRfkcersH6aZ70AcnYb/fzTrAr9EGOkK6WrTSU/y3ykRj5jLhtTfQRopgJxEAfsMy2dhAF9ed2w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199021)(55016003)(110136005)(54906003)(478600001)(82960400001)(122000001)(38100700002)(64756008)(8676002)(8936002)(316002)(66446008)(66476007)(66946007)(76116006)(41300700001)(66556008)(6636002)(4326008)(186003)(83380400001)(7696005)(71200400001)(9686003)(26005)(6506007)(33656002)(52536014)(86362001)(5660300002)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1ViV0REU0FzT3hzK3Z3MVBFZFVtYi9jdkVoWEh4dXQyTm0xZDVrdnZQYWpk?=
 =?utf-8?B?THZjOUt0aHEvUys5UDh1STVpV0JKS2lMVG1EV0dwZFZCTk1IOXRVVGQzQkd6?=
 =?utf-8?B?UmY4cnlKNkZKVTZZK1FaUEo3ZkVNYlpxRFhBcHhrcm5uZkIvWS9EazQ5TGNn?=
 =?utf-8?B?SDEvcjA2TnRaTWYzZWQvNnZWa0s3djdVMEtCR0haMGphUklseE45WXg4TjNh?=
 =?utf-8?B?bWovRFA0TFEzTHlpSnZkUE5VZStjUEc1QXZtenJmeEsxWlBSTTVtWUlsUWpx?=
 =?utf-8?B?QWFkUVIxRTNUblhGMkJ1b0YvdjZBdXo1VkxsNFMwazZJcitWU01mdlVRZkM1?=
 =?utf-8?B?QlJ3UVVsYVRLZlorajRBeWtBQi9qalpOTW1iQWFlb0cvZnljSGcvYWZlNXFI?=
 =?utf-8?B?Tm95Yk1lcWNJNnlLWVUrSmdNUjJiY2NvUURIU3lGZ3JhR09HSGhSVmxYRHIx?=
 =?utf-8?B?bGNZQzZ5ZXYxU1loNlF2cHBZdjVlZGJVYVBmaEk2VktEMlRFZWQzaEZ5M0d2?=
 =?utf-8?B?dDhDOEdmMU5ldjdLT2d5NUlYc0lULzUvRTJna2xKM2czQU9OTTAxWmx4QzEx?=
 =?utf-8?B?SnJ2UnZsNDdvaTIrTEdaMVZjRVpHTXlnaHlZM3lRNFIzWFNtenAzRW5sa1hi?=
 =?utf-8?B?UkJ0WHJ0NlFsa3d0cmI3MlJuNTQ0dE1EcWZMa0RZaEg3ekYyU3UvVHp1bDlO?=
 =?utf-8?B?VUtsblRWYlRobFl1Zi9Ub1V3Ulpqb3N4U1lUQ2JqVUwwajUwY1JEYUpWMllS?=
 =?utf-8?B?NktYL2NvSk0rcmh4WHdIbWQxOGlib1dlL2xleWY1VUdyeGE3Zndva0FIK3Nk?=
 =?utf-8?B?QU5iMS9zWTkvY082dWp5MWhBSGtraUJBa1Fjb21BcWQ5VWpQblplbXQ4MjNn?=
 =?utf-8?B?Rnh3VFZyWUlRa3RCa2FUT2xlY2VDRkV1UzdrNzNSNzhNK0daUzBVcDFERXA1?=
 =?utf-8?B?RllaaFVYTjFobzVYVnFLV29pNU1nTFFrcFlIeGRRMG5QRitvOVYxSlJsQ0Ex?=
 =?utf-8?B?ZXVnSGdyZzlpcjZZRjluT0hUenFneHQzdUFVNVk0T0E3M1FoOWNnaVY4RjQw?=
 =?utf-8?B?ODNRNDh5MWpSenk3bCszcTF1QlY2MjhHMVNQNm1mRTlRekdqN2dmalpQYy9y?=
 =?utf-8?B?Z1VmdVNWK0hidG1BWUJOSTBUSFU3Q212c0dqRVltWGZ6RUtDckhPb085TGZs?=
 =?utf-8?B?a3M5RUpnRjQvY2p5b3JibDZpenNxRGd6R3pLZ2tUdW5KRHlDc1JWTzFyOG83?=
 =?utf-8?B?cEJFVm5wU3hESVcybndkQXptTlNrV2NGMFNmczBtVmwyNXJvQkNiZW04QmF1?=
 =?utf-8?B?aTM2b0J3NVFPbjY0RjY4Z1pwOXgxdlNpTndiclZzS21LY0piYmFkVXQ1YXhC?=
 =?utf-8?B?d2NkaXFrZTVKUzdLQkQ2RWhicWdnZ2FKUmxMdzRFR3h6THVsZm5OME5hSXJ6?=
 =?utf-8?B?aE5hQnoxRzBtWUVTNTJuWVhMR2xRZllBWDJYRW9uRnF4dm9odFVPRkw5YndZ?=
 =?utf-8?B?bm9rOEpvSnVZWmhZN3ZSVmZLd1o2S1FJNmZ1TUkwQjFhZDJZSkFKY0V6dC93?=
 =?utf-8?B?QmJCL2N6OTFZVTFMSDdHaDM2MzFBU3d4SkpFajk4T0RRVUZNa2NydThZQ0Er?=
 =?utf-8?B?NU44UTc4L3NlelRnaXN3dGo4cUcxdmJmc1ZhL08yVnFLc1BhOVBHZXkzdWdm?=
 =?utf-8?B?SG40bE4ySXVHSVFPaUMwZ0FSczRKNm9NdWlwTWRBSkpKYnN6MFZCUGxHa3Ey?=
 =?utf-8?B?UmJCaGFxMGdTSE9xYnhHbEdMeTVZUzhrZkE2T0NvS3dXcDJJY1IzRXZqUXB4?=
 =?utf-8?B?bU8xUzFoS2lQaE8xak9tdi9GRkhScTdaUExMczBNL2xaS3piTCtXSWZ2Wk5w?=
 =?utf-8?B?WWdjbzk1ak1oWTlqaGY1aGtCNGxrR3l4ZkRUbm0xY2xwSW96RmFiUkxFdDBZ?=
 =?utf-8?B?Yjg0WUJOZzZQUTlVM1g0aVVESTJ3N3VUcWYwSFFtdU5aSzJpaGVVK25VclZY?=
 =?utf-8?B?aVZnemVuM0N6Z056RUpuVG5tQUV0ZEFaQnYrV3RFZS9LSUlqQVA0ZElHTWdo?=
 =?utf-8?B?ZzI4VFliM2NHQTRoR3V1VU5jYVorcnZUYlBRZjN0ZFV0dnVTMys4aDIzbDA5?=
 =?utf-8?B?SkpUUlI5UGFicXlQY3d2dGZjUlAyWU1TVG5Mbk1Ka0xTVWh6Z012NTdMZW4w?=
 =?utf-8?B?TVE9PQ==?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 69a8321a-41c5-46eb-1d72-08db6c119da0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 13:25:11.7194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N8M6Ak1w1Gkg075Ff4n60dfhwStGfOHQZDs1LDznMbGbnSyWAIcXoe6yAHFtrKq+18fw9bxp0xKSArjGuWlgydOuUfnr1fJukba94Jmltw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB8265
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiBBbSAxMy4wNi4yMyB1bSAxNToxMCBzY2hyaWViIE1hY2llaiBGaWphbGtvd3NraToNCj4gPiBP
biBUdWUsIEp1biAxMywgMjAyMyBhdCAwMjoyNDoxOFBNICswMjAwLCBQaW90ciBHYXJkb2NraSB3
cm90ZToNCj4gPj4gSW4gc29tZSBjYXNlcyBpdCBpcyBwb3NzaWJsZSBmb3Iga2VybmVsIHRvIGNv
bWUgd2l0aCByZXF1ZXN0DQo+ID4+IHRvIGNoYW5nZSBwcmltYXJ5IE1BQyBhZGRyZXNzIHRvIHRo
ZSBhZGRyZXNzIHRoYXQgaXMgYWxyZWFkeQ0KPiA+PiBzZXQgb24gdGhlIGdpdmVuIGludGVyZmFj
ZS4NCj4gPj4NCj4gPj4gVGhpcyBwYXRjaCBhZGRzIHByb3BlciBjaGVjayB0byByZXR1cm4gZmFz
dCBmcm9tIHRoZSBmdW5jdGlvbg0KPiA+PiBpbiB0aGVzZSBjYXNlcy4NCj4gPg0KPiA+IFBsZWFz
ZSB1c2UgaW1wZXJhdGl2ZSBtb29kIGhlcmUgLSAiYWRkIHByb3BlciBjaGVjay4uLiINCj4gDQo+
IEp1c3QgYSBub3RlLCB0aGF0IGluIOKAnGFkZCBjaGVjayDigKbigJ0gdGhlIHZlcmIgKmFkZCog
aXMgYWxyZWFkeSBpbg0KPiBpbXBlcmF0aXZlIG1vb2QuIChZb3UgY2FuIHNob3J0ZW4g4oCcYWRk
IG5vdW4g4oCm4oCdIG9mdGVuIHRvIGp1c3QgdXNlIHRoZQ0KPiB2ZXJiIGZvciB0aGUgbm91bi4g
SW4gdGhpcyBjYXNlOg0KDQpJIGp1c3QgbWVhbnQgdG8gZ2V0IHJpZCBvZiAndGhpcyBwYXRjaC4u
LicNCg0KPiANCj4gQ2hlY2sgY3VycmVudCBNQUMgYWRkcmVzcyBpbiBgZGV2X3NldF9tYWNfYWRk
cmVzc2ANCj4gDQo+IEJ1dCBpdOKAmXMgbm90IHNwZWNpZmljIGVub3VnaC4gTWF5YmU6DQo+IA0K
PiBBdm9pZCBzZXR0aW5nIHNhbWUgTUFDIGFkZHJlc3MNCj4gDQo+IA0KPiBLaW5kIHJlZ2FyZHMs
DQo+IA0KPiBQYXVsDQo+IA0KPiANCj4gPj4gQW4gZXhhbXBsZSBvZiBzdWNoIGNhc2UgaXMgYWRk
aW5nIGFuIGludGVyZmFjZSB0byBib25kaW5nDQo+ID4+IGNoYW5uZWwgaW4gYmFsYW5jZS1hbGIg
bW9kZToNCj4gPj4gbW9kcHJvYmUgYm9uZGluZyBtb2RlPWJhbGFuY2UtYWxiIG1paW1vbj0xMDAg
bWF4X2JvbmRzPTENCj4gPj4gaXAgbGluayBzZXQgYm9uZDAgdXANCj4gPj4gaWZlbnNsYXZlIGJv
bmQwIDxldGg+DQo+ID4+DQo+ID4+IFNpZ25lZC1vZmYtYnk6IFBpb3RyIEdhcmRvY2tpIDxwaW90
cnguZ2FyZG9ja2lAaW50ZWwuY29tPg0KPiA+DQo+ID4gSSdsbCBsZXQgS3ViYSBhY2sgaXQuDQo+
ID4NCj4gPj4gLS0tDQo+ID4+ICAgbmV0L2NvcmUvZGV2LmMgfCAyICsrDQo+ID4+ICAgMSBmaWxl
IGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPiA+Pg0KPiA+PiBkaWZmIC0tZ2l0IGEvbmV0L2Nv
cmUvZGV2LmMgYi9uZXQvY29yZS9kZXYuYw0KPiA+PiBpbmRleCBjMjQ1NmIzNjY3ZmUuLjhmMWM0
OWFiMTdkZiAxMDA2NDQNCj4gPj4gLS0tIGEvbmV0L2NvcmUvZGV2LmMNCj4gPj4gKysrIGIvbmV0
L2NvcmUvZGV2LmMNCj4gPj4gQEAgLTg3NTQsNiArODc1NCw4IEBAIGludCBkZXZfc2V0X21hY19h
ZGRyZXNzKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHN0cnVjdCBzb2NrYWRkciAqc2EsDQo+ID4+
ICAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gPj4gICAJaWYgKCFuZXRpZl9kZXZpY2VfcHJlc2VudChk
ZXYpKQ0KPiA+PiAgIAkJcmV0dXJuIC1FTk9ERVY7DQo+ID4+ICsJaWYgKCFtZW1jbXAoZGV2LT5k
ZXZfYWRkciwgc2EtPnNhX2RhdGEsIGRldi0+YWRkcl9sZW4pKQ0KPiA+PiArCQlyZXR1cm4gMDsN
Cj4gPj4gICAJZXJyID0gZGV2X3ByZV9jaGFuZ2VhZGRyX25vdGlmeShkZXYsIHNhLT5zYV9kYXRh
LCBleHRhY2spOw0KPiA+PiAgIAlpZiAoZXJyKQ0KPiA+PiAgIAkJcmV0dXJuIGVycjsNCj4gPj4g
LS0NCj4gPj4gMi4zNC4xDQo+ID4+DQo=

