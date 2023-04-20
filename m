Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1889E6E9296
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbjDTL2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234775AbjDTL2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:28:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2413F7D9A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 04:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681990044; x=1713526044;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D9FIbZyjVVizjlRJjUVRamXXvgOZixOiNjikVb5Reik=;
  b=kjpufR+jF3m3yufjNcz0x23F1g02HCDab/ec0w3HGNr9cM08B4rXDJty
   UYsAL28ZadMFMkO4nSohpr7Z5hJ7bgyJNbiAKMj/EtP/cf9IgF3PWcBdS
   MLJInR5xDZT9qZ8D+VR0W9ZyG3dlz8PpQzwMLcqC1/HdDwGd0q4RySvEe
   sEVpbRNPulcLdWpGvKgi3/q8fEMP9dPLJxKNqvH5mP7maQ0uaCp25YrOK
   Y61ARfyEkAv2e61Bd3P5i0zcPbtXvoEfwXe+955CAHzmV52r4UPiHaChA
   IUNveK1WruwCNaqE7pYCniTeuHMOgzZO8oEJO4/dJR23EaAdPZK0zGlfv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="325313985"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="325313985"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 04:27:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="724390290"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="724390290"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 20 Apr 2023 04:27:15 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 04:27:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 04:27:14 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 04:27:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bn0/dma6uCdsaERUfXUNrXcsEaEDQbYGn0HQvWW4Sjy9CIbHSmmFIAnyA54Xs8qzpmUk32WfkI5vvyadhblKTD+ahcM67JEuf3AeeUkrFf/cwh51mN36C/TAEU60tA/dnbGcgg8IgelfNlLiA348tk2MuYomOEeW4dOhi7z77g8NXq0dodfXtTJJKnOzI9INPgH9wCmteXWSii+tfGZ7QHt39FB2akrZy/UGgPSeGXm3XH0M1nQaTdpjigiZ48IcZLGqP0iQjJymLr7bXs4vpp/U41W+BritRnrc/fccsaTlvgXZGKbmdLO/9rv2h/w/5Xmx/e+BJHry6HtNwuCVAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9FIbZyjVVizjlRJjUVRamXXvgOZixOiNjikVb5Reik=;
 b=XMp2TqJGJUo21carxxdD1cS+uZCL2LWEaBhyS7TIt/k0kC2Sr+LDAI5x05PKE+te2344jM8DhppiK1VrcT24XPuP8nPcKW4l5uEnSKh3kIC9hTVRkOHtG5i7PkcamVFTY/xJQ4e7VMFGpYXZW/JC/brQ6veZRkQmY2QbJoHvnGVDCR/sP0YSUJ6r5qUjboZJ8tkaxamRqcQt4ZM4X2kxCXRzZ+KaavUciFhGpcaH/kDnDR/l+yzl6HCG1eEqObgZqP6wX4GYWItdXOWCr1H7PgPtL8N5eqN1qhqhKEanDmWSaeXnAL2jpNkOYoCVNdIP5Sx7q7NMdk1ECPdo5hpU3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by BL1PR11MB5979.namprd11.prod.outlook.com (2603:10b6:208:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 11:27:12 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::936d:24c4:86d0:f2a0%6]) with mapi id 15.20.6298.045; Thu, 20 Apr 2023
 11:27:12 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     "Lobakin, Aleksander" <aleksander.lobakin@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "marcin.szycik@linux.intel.com" <marcin.szycik@linux.intel.com>,
        "Chmielewski, Pawel" <pawel.chmielewski@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [PATCH net-next 05/12] ice: Switchdev FDB events support
Thread-Topic: [PATCH net-next 05/12] ice: Switchdev FDB events support
Thread-Index: AQHZctUzhpsg98+ihkmiMm0VAX7gla80Bg4Q
Date:   Thu, 20 Apr 2023 11:27:11 +0000
Message-ID: <MW4PR11MB57760F836B7714BC22A26FC7FD639@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
 <20230417093412.12161-6-wojciech.drewek@intel.com>
 <10045539-91eb-cdb1-0499-1c478d87870e@intel.com>
In-Reply-To: <10045539-91eb-cdb1-0499-1c478d87870e@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5776:EE_|BL1PR11MB5979:EE_
x-ms-office365-filtering-correlation-id: 0f3068b5-970e-47d6-a825-08db41922eff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 21zUarrV6miu/Jusmrpsvft1pWG+QkvugqBBFmqS8P7o3OAbKnnyi0HE4tdzXKz/q6ArLTe+0cXwgEV0Yyj5+lI6N4mQTmuGeqBBE5iyx0dA9+QrrKVEd9/Y0TVSnZdRnAKII5HyPEXtjynX6Fx0zJ+x/EOKZfdVq1bP3Sn7cGyrmrGW+wlNyM0Av6RIohI5q1SH6P8d16M9TuMr/3ulAGnQjD4nLGDTyIeViL9NUB4X5fTr4+PwIf1ZN6aRFs2w55mtSBjarOxoydgFWWEteczP9eyNPLTqybs19Xv7AoSCZfNriQAWVlQeWVRbS8AvRUHlF6XQEzsXl8MI7uG3l8no0gFcBtwZO7MFZpxY/vYdyQASrw18vsLdDbVaSaQc19P7b5YyQutHi0MwqJKgsuZ+xcJKYN0IBNbClWvxL2nHdUmeFVokEouWD3pd3WJVMEjebQQ8Phdmd6cci9geezZsoXHS91VnuRXz8eTYny4k08hPnubLwTm46QUX9vNrS8zgeMf4ze7o4LEnbn1/uLF3iuZ6P8gbs98SQ5zCxWUE8OHIiWoGZHnQ/xoxUkL6L/FZ74OdD6SeljtCkHKpXejn0ODp/36gpDzNj554UCTmUD8kw01cX09ZMLh2E7Yr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(136003)(376002)(396003)(366004)(451199021)(4326008)(316002)(6636002)(54906003)(66556008)(66476007)(66446008)(64756008)(76116006)(66946007)(33656002)(53546011)(9686003)(26005)(6506007)(82960400001)(122000001)(38100700002)(186003)(83380400001)(55016003)(5660300002)(41300700001)(6862004)(8676002)(8936002)(478600001)(7696005)(71200400001)(86362001)(38070700005)(52536014)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dHdncTNjQVdpeEROamJtc2ROdFA2MUFmaWwxQ0VTV2FxNmh5YkNwa29xK01V?=
 =?utf-8?B?QlBsakhwbWpaNis5YUxEL216SXZ5eXFlUXF3cWlDQTlzSlBzREEzc09EZm5N?=
 =?utf-8?B?RWIzVCtJZzJHdmFYVmhVcGRkSVhnZXhzd1Nwb1dYVHhNSzRqMTM2dm1oOXI4?=
 =?utf-8?B?NkJQTXlUWnlwalB5cG03MDczUElzTzNHUmgxSHFJTWZPN0ZpbDhBSi9yMWc2?=
 =?utf-8?B?ZE5vNnNpMWtOZFNPV1pGc2MxVUpzNWpMU1pVVlg4a215ZVplS2I3QUNaclF3?=
 =?utf-8?B?WWtaa3VKWFV1d2RnK0dlRDF6VW9qSFF1VllFejZDUkpxdWlaRjlTMmh6c0ov?=
 =?utf-8?B?VWpYNG9lSVRJTklvY3crZkNhNE9CejlmVW1wTm9SZFI1MmxvOXlad0MraWdV?=
 =?utf-8?B?MTYvOTg3MDNMQ2JzVE8wTnRTN05LMXNvRHhMQVpYU2ZweHlWMlJsZ3FkczVH?=
 =?utf-8?B?Z0dPdWV2SGExdElMTWY1aEgwaE1ubjNWNTQ5K2hIWXNrY0gyUktQbm5Edlg5?=
 =?utf-8?B?RTJsSjJlVzN3NlhML3BSYjdSaHhZQVAweUNGVjhYaFpEWlZGMVNNejFjUFlH?=
 =?utf-8?B?cDNFVit6cHdpZGN5UHJPakZ5c3BQUXV5ZUExWXc0VkVXa3lCVUg0SFp3aUlP?=
 =?utf-8?B?emdERFQvNFQ5a1FkMVI5WXFkbFAxMEtra3RtTWJpVkpKVWRhTzhYaVJFS2hz?=
 =?utf-8?B?WS9KaWFtNzhpcXFGajZkbFVqZFVBV3UrL1E2U1NnQkJMVlk2dUtPN3lDUGd1?=
 =?utf-8?B?V3pyeHhXelN1R3lOaFRJbm9zUjRNQTRQUVVWdDNVdWUwcFR1RHNoVk56RlYr?=
 =?utf-8?B?YTU2UHN4QTJESCtmQ1B2eExTNXNIbFNtbDF0dnI3ay92VTBFZUw3N3VEOFI1?=
 =?utf-8?B?eVN1VjdyUzNGMldkZkZFS1VEUFlCS3lzeXFiRjYxVVl2dXVYYXYyM0N6SHZs?=
 =?utf-8?B?eVpXVkd1V040aUs1aU83c2xIeWNFeFBsaEdJWVYzYlhkd29yUWRyVEEwWmJU?=
 =?utf-8?B?WWlqbmlWVHo1N0xlSklHTU5ENDRCVWpNbWpFWU13UlZ4cXpDc3RLSHByd0hM?=
 =?utf-8?B?SkpHSEJSUFMwWWQ0aUJkTVhmd1dSUStPcytvMnZDR2NEU0d6bU80ZTdpRGVO?=
 =?utf-8?B?ZWhpdmVtZWZTTmYyVVNEeGFiQ3NxVzB5cmJHQWw1MkVuNlEzUFE5UjhVZnNY?=
 =?utf-8?B?c1pRL3hMWDVHaDlWVUlhTURhazExSkN6SzN5a2lHKy9MV29lNDNWeXdtaTFI?=
 =?utf-8?B?ZUFBV0FudTBnbW1OTUJOQVJFTG9HZ0haY0ViSytHVjJiREN2amIra0RMR0xV?=
 =?utf-8?B?YWUyVnRZaWlLUnBQUlZEaXdROThpVmZmU1dBQitJL1FleFlKNDE1VFBhSUNJ?=
 =?utf-8?B?cnk3aUlaMkVOQm1sa1QxNksremxKUkpLNDdsbDhjelBPM2EwazdmS3FqQmxl?=
 =?utf-8?B?Qy9uaTdtelBQQjVnVkZBMjV0UnFEWDRWSjVmTVl3ZllGVUxzT3VkZnZLcGRj?=
 =?utf-8?B?RTREQlM0eWNyek1zZjVkOHlNSW5QQ2wwQTR5TklWUEZUSVUvYm1McmJxdSs2?=
 =?utf-8?B?NWRUcHdCSDBFa3dMWStNQU5FZGJpQTc2Z000V3o0SEdXZ0dYc1Z0ZW4wY3di?=
 =?utf-8?B?bEl0Y0o4dFRYaWtHTVlveWtNS2lXZTBPR1R2ejF3TW02c2hzLytGSHYzUjJQ?=
 =?utf-8?B?ZTkvbmFpckFKeFNWZFVlMlZ0a3M0L3VHdklsY2IwNVpkRXB4YnJOcmIray9R?=
 =?utf-8?B?UHVtRlh6NjRWS0xiRHVuVFNKb0ZrS05uN1hTVXNMMlVRa0hDSUR4d3ArQ0F0?=
 =?utf-8?B?ck1PN1ZnOU9jelIyb2Z0MmFsdUhpRy9oK2g5TTlaeXlLTVFoR1ZZNmRjaEJT?=
 =?utf-8?B?dXNSMW9zblUyOEVmZHYrSVc1ZCtJaWUvR2VHU25obkNUdWlKaVloL2h6aWFW?=
 =?utf-8?B?N3JsaXBqTDJxbHpybWhLdG9UbGl2MzB4TU5ZZjl1cmk0WVFUcW40Zi9jRDNJ?=
 =?utf-8?B?Zi8vTklxM1VhSWFLVkRzVHN1R2lvc2phcUI1dHJwTzh2bXZPdWxFMVVBT0NI?=
 =?utf-8?B?bjhhYnFFWHhnWktaQzFIeVdXVDVyNGtiVXAxakE3NDU3anI0Wkt6eXZhKzZV?=
 =?utf-8?Q?jxrboSOE8n54sHGPkPNBPR+Bg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f3068b5-970e-47d6-a825-08db41922eff
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 11:27:11.2155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dC6X1fKGk1wALP3qgiAa9VcaHR+9K3x4b7KcifXfS5nFX8RcwpcG/xag19Ash46in84jKzHrL+9JsVfv20Lai9qpfwlGFFqZRuSU7hUc6IU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5979
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTG9iYWtpbiwgQWxla3Nh
bmRlciA8YWxla3NhbmRlci5sb2Jha2luQGludGVsLmNvbT4NCj4gU2VudDogxZtyb2RhLCAxOSBr
d2lldG5pYSAyMDIzIDE3OjM5DQo+IFRvOiBEcmV3ZWssIFdvamNpZWNoIDx3b2pjaWVjaC5kcmV3
ZWtAaW50ZWwuY29tPg0KPiBDYzogaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IExvYmFraW4sIEFsZWtzYW5kZXIgPGFsZWtzYW5kZXIubG9i
YWtpbkBpbnRlbC5jb20+OyBFcnRtYW4sIERhdmlkIE0NCj4gPGRhdmlkLm0uZXJ0bWFuQGludGVs
LmNvbT47IG1pY2hhbC5zd2lhdGtvd3NraUBsaW51eC5pbnRlbC5jb207IG1hcmNpbi5zenljaWtA
bGludXguaW50ZWwuY29tOyBDaG1pZWxld3NraSwgUGF3ZWwNCj4gPHBhd2VsLmNobWllbGV3c2tp
QGludGVsLmNvbT47IFNhbXVkcmFsYSwgU3JpZGhhciA8c3JpZGhhci5zYW11ZHJhbGFAaW50ZWwu
Y29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDA1LzEyXSBpY2U6IFN3aXRjaGRl
diBGREIgZXZlbnRzIHN1cHBvcnQNCj4gDQo+IEZyb206IFdvamNpZWNoIERyZXdlayA8d29qY2ll
Y2guZHJld2VrQGludGVsLmNvbT4NCj4gRGF0ZTogTW9uLCAxNyBBcHIgMjAyMyAxMTozNDowNSAr
MDIwMA0KPiANCj4gPiBMaXN0ZW4gZm9yIFNXSVRDSERFVl9GREJfe0FERHxERUx9X1RPX0RFVklD
RSBldmVudHMgd2hpbGUgaW4gc3dpdGNoZGV2DQo+ID4gbW9kZS4gQWNjZXB0IHRoZXNlIGV2ZW50
cyBvbiBib3RoIHVwbGluayBhbmQgVkYgUFIgcG9ydHMuIEFkZCBIVw0KPiA+IHJ1bGVzIGluIG5l
d2x5IGNyZWF0ZWQgd29ya3F1ZXVlLiBGREIgZW50cmllcyBhcmUgc3RvcmVkIGluIHJoYXNodGFi
bGUNCj4gPiBmb3IgbG9va3VwIHdoZW4gcmVtb3ZpbmcgdGhlIGVudHJ5IGFuZCBpbiB0aGUgbGlz
dCBmb3IgY2xlYW51cA0KPiA+IHB1cnBvc2UuIERpcmVjdGlvbiBvZiB0aGUgSFcgcnVsZSBkZXBl
bmRzIG9uIHRoZSB0eXBlIG9mIHRoZSBwb3J0cw0KPiA+IG9uIHdoaWNoIHRoZSBGREIgZXZlbnQg
d2FzIHJlY2VpdmVkOg0KPiANCj4gWy4uLl0NCj4gDQo+ID4gK3N0YXRpYyBpbnQNCj4gPiAraWNl
X2Vzd2l0Y2hfYnJfcnVsZV9kZWxldGUoc3RydWN0IGljZV9odyAqaHcsIHN0cnVjdCBpY2VfcnVs
ZV9xdWVyeV9kYXRhICpydWxlKQ0KPiA+ICt7DQo+ID4gKwlpbnQgZXJyOw0KPiA+ICsNCj4gPiAr
CWlmICghcnVsZSkNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArDQo+ID4gKwllcnIgPSBp
Y2VfcmVtX2Fkdl9ydWxlX2J5X2lkKGh3LCBydWxlKTsNCj4gPiArCWtmcmVlKHJ1bGUpOw0KPiA+
ICsNCj4gPiArCXJldHVybiBlcnI7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBzdHJ1Y3Qg
aWNlX3J1bGVfcXVlcnlfZGF0YSAqDQo+ID4gK2ljZV9lc3dpdGNoX2JyX2Z3ZF9ydWxlX2NyZWF0
ZShzdHJ1Y3QgaWNlX2h3ICpodywgdTE2IHZzaV9pZHgsIGludCBwb3J0X3R5cGUsDQo+IA0KPiAo
bm8gdHlwZXMgc2hvcnRlciB0aGFuIHUzMiBvbiB0aGUgc3RhY2sgcmVtaW5kZXIpDQo+IA0KPiA+
ICsJCQkgICAgICAgY29uc3QgdW5zaWduZWQgY2hhciAqbWFjKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1
Y3QgaWNlX2Fkdl9ydWxlX2luZm8gcnVsZV9pbmZvID0geyAwIH07DQo+ID4gKwlzdHJ1Y3QgaWNl
X3J1bGVfcXVlcnlfZGF0YSAqcnVsZTsNCj4gPiArCXN0cnVjdCBpY2VfYWR2X2xrdXBfZWxlbSAq
bGlzdDsNCj4gPiArCXUxNiBsa3Vwc19jbnQgPSAxOw0KPiANCj4gV2h5IGhhdmUgaXQgYXMgdmFy
aWFibGUgaWYgaXQgZG9lc24ndCBjaGFuZ2U/IEp1c3QgZW1iZWQgaXQgaW50byB0aGUNCj4gaWNl
X2FkZF9hZHZfcnVsZSgpIGNhbGwgYW5kIHJlcGxhY2Uga2NhbGxvYygpIHdpdGgga3phbGxvYygp
Lg0KDQpJdCB3aWxsIGJlIHVzZWZ1bCBsYXRlciwgd2l0aCB2bGFucyBzdXBwb3J0IGxrdXBzX2Nu
dCB3aWxsIGJlIGVxdWFsIHRvIDEgb3IgMi4NCkNhbiB3ZSBrZWVwIGl0IGFzIGl0IGlzPw0KDQo+
IA0KPiA+ICsJaW50IGVycjsNCj4gPiArDQo+ID4gKwlydWxlID0ga3phbGxvYyhzaXplb2YoKnJ1
bGUpLCBHRlBfS0VSTkVMKTsNCj4gPiArCWlmICghcnVsZSkNCj4gPiArCQlyZXR1cm4gRVJSX1BU
UigtRU5PTUVNKTsNCj4gPiArDQo+ID4gKwlsaXN0ID0ga2NhbGxvYyhsa3Vwc19jbnQsIHNpemVv
ZigqbGlzdCksIEdGUF9BVE9NSUMpOw0KPiANCj4gWy4uLl0NCj4gDQo+ID4gKwlmd2RfcnVsZSA9
IGljZV9lc3dpdGNoX2JyX2Z3ZF9ydWxlX2NyZWF0ZShodywgdnNpX2lkeCwgcG9ydF90eXBlLCBt
YWMpOw0KPiA+ICsJaWYgKElTX0VSUihmd2RfcnVsZSkpIHsNCj4gPiArCQllcnIgPSBQVFJfRVJS
KGZ3ZF9ydWxlKTsNCj4gPiArCQlkZXZfZXJyKGRldiwgIkZhaWxlZCB0byBjcmVhdGUgZXN3aXRj
aCBicmlkZ2UgJXNncmVzcyBmb3J3YXJkIHJ1bGUsIGVycjogJWRcbiIsDQo+ID4gKwkJCXBvcnRf
dHlwZSA9PSBJQ0VfRVNXSVRDSF9CUl9VUExJTktfUE9SVCA/ICJlIiA6ICJpbiIsDQo+ID4gKwkJ
CWVycik7DQo+ID4gKwkJZ290byBlcnJfZndkX3J1bGU7DQo+IA0KPiBBIGJpdCBzdWJvcHRpbWFs
LiBUbyBwcmludCBlcnJubyBwb2ludGVyLCB5b3UgaGF2ZSAlcGUgbW9kaWZpZXIsIHNvIHlvdQ0K
PiBjYW4ganVzdCBwcmludCBlcnIgYXM6DQo+IA0KPiAJCS4uLiBmb3J3YXJkIHJ1bGUsIGVycjog
JXBlXG4iLCAuLi4gOiAiaW4iLCBmd2RfcnVsZSk7DQo+IA0KPiBUaGVuIHlvdSBkb24ndCBuZWVk
IEBlcnIgYXQgYWxsIGFuZCB0aGVuIGJlbG93Li4uDQoNClRoaXMgaXMgcmVhbGx5IGNvb2wsIGJ1
dCBJIHRoaW5rIGl0IHdvbid0IHdvcmsgaGVyZS4gSSBuZWVkIHRvIGtlZXAgZXJyIGluIG9yZGVy
IHRvDQpyZXR1cm4gaXQgaW4gdGhlIGVyciBmbG93LiBJIGNhbid0IHVzZSBmd2RfcnVsZSBmb3Ig
dGhpcyBwdXJwb3NlIGJlY2F1c2UNCnJldHVybiB0eXBlIGlzIGljZV9lc3dfYnJfZmxvdyBub3Qg
aWNlX3J1bGVfcXVlcnlfZGF0YS4NCg0KPiANCj4gPiArCX0NCj4gPiArDQo+ID4gKwlmbG93LT5m
d2RfcnVsZSA9IGZ3ZF9ydWxlOw0KPiA+ICsNCj4gPiArCXJldHVybiBmbG93Ow0KPiA+ICsNCj4g
PiArZXJyX2Z3ZF9ydWxlOg0KPiA+ICsJa2ZyZWUoZmxvdyk7DQo+ID4gKw0KPiA+ICsJcmV0dXJu
IEVSUl9QVFIoZXJyKTsNCj4gDQo+IC4uLnlvdSBjYW4gcmV0dXJuIEBmd2RfcnVsZSBkaXJlY3Rs
eS4NCj4gDQoNCkkgY2FuJ3QgcmV0dXJuIEBmd2RfcnVsZSBoZXJlIGJlY2F1c2UgcmV0dXJuIHR5
cGUgaXMgZGlmZmVyZW50DQpUaGlzIGZ1bmN0aW9uIGlzIG1lYW50IHRvIHJldHVybiBAZmxvdy4N
Cg0KDQpbLi4uXQ0KDQo+ID4gK3N0YXRpYyBpbnQNCj4gPiAraWNlX2Vzd2l0Y2hfYnJfc3dpdGNo
ZGV2X2V2ZW50KHN0cnVjdCBub3RpZmllcl9ibG9jayAqbmIsDQo+ID4gKwkJCSAgICAgICB1bnNp
Z25lZCBsb25nIGV2ZW50LCB2b2lkICpwdHIpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBuZXRfZGV2
aWNlICpkZXYgPSBzd2l0Y2hkZXZfbm90aWZpZXJfaW5mb190b19kZXYocHRyKTsNCj4gPiArCXN0
cnVjdCBpY2VfZXN3X2JyX29mZmxvYWRzICpicl9vZmZsb2FkcyA9DQo+ID4gKwkJaWNlX25iX3Rv
X2JyX29mZmxvYWRzKG5iLCBzd2l0Y2hkZXZfbmIpOw0KPiA+ICsJc3RydWN0IG5ldGxpbmtfZXh0
X2FjayAqZXh0YWNrID0NCj4gPiArCQlzd2l0Y2hkZXZfbm90aWZpZXJfaW5mb190b19leHRhY2so
cHRyKTsNCj4gDQo+IChpbml0aWFsaXplLWxhdGVyLXRvLWF2b2lkLWxpbmUtYnJlYWtzPykNCj4g
DQo+ID4gKwlzdHJ1Y3Qgc3dpdGNoZGV2X25vdGlmaWVyX2ZkYl9pbmZvICpmZGJfaW5mbzsNCj4g
PiArCXN0cnVjdCBzd2l0Y2hkZXZfbm90aWZpZXJfaW5mbyAqaW5mbyA9IHB0cjsNCj4gPiArCXN0
cnVjdCBpY2VfZXN3X2JyX2ZkYl93b3JrICp3b3JrOw0KPiA+ICsJc3RydWN0IG5ldF9kZXZpY2Ug
KnVwcGVyOw0KPiA+ICsJc3RydWN0IGljZV9lc3dfYnJfcG9ydCAqYnJfcG9ydDsNCj4gDQo+IFJD
VCA6cw0KPiANCj4gPiArDQo+ID4gKwl1cHBlciA9IG5ldGRldl9tYXN0ZXJfdXBwZXJfZGV2X2dl
dF9yY3UoZGV2KTsNCj4gPiArCWlmICghdXBwZXIpDQo+ID4gKwkJcmV0dXJuIE5PVElGWV9ET05F
Ow0KPiA+ICsNCj4gPiArCWlmICghbmV0aWZfaXNfYnJpZGdlX21hc3Rlcih1cHBlcikpDQo+ID4g
KwkJcmV0dXJuIE5PVElGWV9ET05FOw0KPiA+ICsNCj4gPiArCWlmICghaWNlX2Vzd2l0Y2hfYnJf
aXNfZGV2X3ZhbGlkKGRldikpDQo+ID4gKwkJcmV0dXJuIE5PVElGWV9ET05FOw0KPiA+ICsNCj4g
PiArCWJyX3BvcnQgPSBpY2VfZXN3aXRjaF9icl9uZXRkZXZfdG9fcG9ydChkZXYpOw0KPiA+ICsJ
aWYgKCFicl9wb3J0KQ0KPiA+ICsJCXJldHVybiBOT1RJRllfRE9ORTsNCj4gPiArDQo+ID4gKwlz
d2l0Y2ggKGV2ZW50KSB7DQo+ID4gKwljYXNlIFNXSVRDSERFVl9GREJfQUREX1RPX0RFVklDRToN
Cj4gPiArCWNhc2UgU1dJVENIREVWX0ZEQl9ERUxfVE9fREVWSUNFOg0KPiA+ICsJCWZkYl9pbmZv
ID0gY29udGFpbmVyX29mKGluZm8sDQo+ID4gKwkJCQkJc3RydWN0IHN3aXRjaGRldl9ub3RpZmll
cl9mZGJfaW5mbywNCj4gDQo+IE5pdDogYHR5cGVvZigqZmRiX2luZm8pYCBpcyBzaG9ydGVyIGFu
ZCB3b3VsZCBwcm9iYWJseSBmaXQgaW50byB0aGUgcHJldg0KPiBsaW5lLg0KDQpJIGNhbiBtYWtl
IGl0IGluIHRvIG9uZSBsaW5lIG5vdywgdGhhbmtzLg0KDQo+IA0KPiA+ICsJCQkJCWluZm8pOw0K
PiA+ICsNCj4gPiArCQl3b3JrID0gaWNlX2Vzd2l0Y2hfYnJfZmRiX3dvcmtfYWxsb2MoZmRiX2lu
Zm8sIGJyX3BvcnQsIGRldiwNCj4gPiArCQkJCQkJICAgICBldmVudCk7DQo+IA0KPiBbLi4uXQ0K
PiANCj4gPiArZW51bSB7DQo+ID4gKwlJQ0VfRVNXSVRDSF9CUl9GREJfQURERURfQllfVVNFUiA9
IEJJVCgwKSwNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0cnVjdCBpY2VfZXN3X2JyX2ZkYl9lbnRy
eSB7DQo+ID4gKwlzdHJ1Y3QgaWNlX2Vzd19icl9mZGJfZGF0YSBkYXRhOw0KPiA+ICsJc3RydWN0
IHJoYXNoX2hlYWQgaHRfbm9kZTsNCj4gPiArCXN0cnVjdCBsaXN0X2hlYWQgbGlzdDsNCj4gPiAr
DQo+ID4gKwlpbnQgZmxhZ3M7DQo+IA0KPiBUaGV5IGNhbid0IGJlIG5lZ2F0aXZlIEkgYmVsaWV2
ZT8gdTMyIHRoZW4/IEFsc28gSSB0aGluayBoZXJlJ3MgYSA0LWJ5dGUNCj4gaG9sZSA6cyBCdXQg
c2luY2UgYWxsIG9mIHRoZSBtZW1iZXJzIGhlcmUgZXhjZXB0IHRoaXMgb25lIGFyZSA4LWJ5dGUN
Cj4gYWxpZ25lZCwgeW91IGNhbid0IGF2b2lkIGl0IChjYW4gYmUgZmlsbGVkIGFueXRpbWUgbGF0
ZXIgd2l0aCBzb21lIG90aGVyDQo+IDw9IDQtYnl0ZSBmaWVsZCkNCj4gDQo+ID4gKw0KPiA+ICsJ
c3RydWN0IG5ldF9kZXZpY2UgKmRldjsNCj4gPiArCXN0cnVjdCBpY2VfZXN3X2JyX3BvcnQgKmJy
X3BvcnQ7DQo+ID4gKwlzdHJ1Y3QgaWNlX2Vzd19icl9mbG93ICpmbG93Ow0KPiA+ICt9Ow0KPiBb
Li4uXQ0KPiANCj4gVGhhbmtzLA0KPiBPbGVrDQo=
