Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B67694D98
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjBMREd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBMREb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:04:31 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50C41E9E0
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 09:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676307871; x=1707843871;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LJDsCIlh8cRZDSp6lrQp1qhChwlH4zUvf7MJod8IZAA=;
  b=hIDqi6KDlqnRDhjjAPQ5REXD8AoTB4m/d1zF1+0eORrWx9lpPcJy+xz6
   q3uEqmBfaAHUk/JLiuCsaLD6fRTY3V5CURgiQPDfwI998HV0gaVesr/YL
   +3CiW3pn0m49c50pcd0ZtBlMnbGJsAzB+nI0SlSbKu40Srl61C4ab5CcV
   OdF+vUjMkI1UXXZuukLAMk++dw2nKTYzjL6NziqLtq1+u7ZwCCJoFeA5L
   JXseX6vvALfPXZ55aDPTfpWZwLGEVikizRL778lmiuoDzsNrOyu6WLH5h
   wAE4b9Yu+Z7E0TfhURu1Kodg9d0Apx3h+4RSIakI9lCf/YJnFt1qyanFU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="332247659"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="332247659"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 09:04:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="997755021"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="997755021"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 13 Feb 2023 09:04:26 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 09:04:25 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 09:04:25 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 09:04:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBLUe21U1f07cO0C0GIsOoYHsGvui+vhizHoIpnBhVkxkB3MeD5UWfvWojEKU0Tl0WrIaoaYFSsYT5jGM9Yr7LRYbqP3oD75mTK1wAWcf5xURSoDmgfyUTH2YYKjmuO6cna5TLTOJqS+AxvqiW4R/QyAN7HYoxOUkZBV7RScuIlo0Lc5LWTa+/4VQEm8MAdAak5WZvd/k4C5dA5eAZLVHK5ByiED5Z/jbkoqkDNeORN6sT99ra5Y3G8VlsCf5vk58ZJZ6PiOsF0iZ4uZFDc44MlZqiypSIg3wWB7FhDo9ayVkcY5b4y9RC4Eil0ca2sPoLv9JfJpE8Q7q6f2k5eG0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJDsCIlh8cRZDSp6lrQp1qhChwlH4zUvf7MJod8IZAA=;
 b=ET3x084M61che7hke+l2q36FJqwQmql+G15aw+cEpPzWHMSB2xBhOvbHrJEQ8KkujyqfvXXpNQD7hDBV42dq34mv7JnHzKUULuliyxndjrpqJh61tdl46U3OkDY6kLNbEudI10vQ6iTMvlRFSpvtET/qpCreKdb2YZ70ijYKyGUvPQFSOjRIR4FxdgbQK0sMcceQXyA50/IpAZ65UF3VaszxTpvF32SPhVFPfYFXG28BGLXjzgjbAuzK/IigSgjnIZd1fGuVAGpcBeYaMFRCy+a2wcaJbePZ3L94JYx7N1dGlGVmxTsCim1iiEPR98kEDSWazsDqJdMFrVFlLgTPAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by DS7PR11MB7689.namprd11.prod.outlook.com (2603:10b6:8:e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 17:04:12 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::86b7:ffac:438a:5f44%4]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 17:04:12 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     "Chmielewski, Pawel" <pawel.chmielewski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 1/1] ice: add support BIG
 TCP on IPv6
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 1/1] ice: add support BIG
 TCP on IPv6
Thread-Index: AQHZOxDS6PeLyNDcAEiDz5K1y6Azea7NJBXA
Date:   Mon, 13 Feb 2023 17:04:11 +0000
Message-ID: <BYAPR11MB33670278220389D4B600740BFCDD9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20230207162303.140750-1-pawel.chmielewski@intel.com>
In-Reply-To: <20230207162303.140750-1-pawel.chmielewski@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3367:EE_|DS7PR11MB7689:EE_
x-ms-office365-filtering-correlation-id: f1c9e4f1-10e7-4279-7e2d-08db0de45413
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8x1MlhEFjQg/z2cKg3SQs/W8FG5Zh50GP3ySG3sx/eo2EEVbskw4HbOmXXRI7QLMoAyMgURL4XukOhviZACt0hCS1lOvCY1HUFKNPLw78C1Y+slq3w+uw4/ZAhRs9zLOpLIGd6Q2bfeZg5fQNLrJavtbRTHAz+kXiqRg+aL5uIlsec26xM2bosoM0b/TQGvllvdA/VxsxKSZffwnNWyIjcLqoiWMtfetaqPHX279+/ThqgjqIEWnw1lJHujbnYaL4mrJCljx0YNjmCXKRDZ/4lFPB2BmabpWPLz61EHTkK4RWEt3YiehhUqrytO2IQfu4MhygfQv7/AdVUTC1mhsJgzzNR4Yh6z8a1DXqR4BKbIu5V+kq/EUJy3rI44TRUihpTrKHcxqjZYWbbsRqwHWAoIzVsk6iMSZTjRbgQds/YLJ4nIbgfGCySnj0YsAhVBJ/OVnHziu6sC36tZjQYdwF8mplVxK/h+2uNfxuDQEley0mjARU52SFsUzD7/5vplCHCK3fuklGzoMD3GqssrE7Mm4WmeqtsnKg+vXtycLu6o/kV6H6FqC10RbafbmW84Xa1RW3TJiprXu+pg9yAn2Axe7C0DG+SgP5yI+E4qz7Uv9jyaFkfX/pDJFCx+vpIyP+BYXUjyVvWDDmNpnYgkxTHPbwOjsFUNP9hhJiOqAP8YbPCUDOZMQNEBBvtumSoAPsQ+gZQRjXPu66/aKIIeWiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(83380400001)(122000001)(38100700002)(82960400001)(52536014)(5660300002)(110136005)(86362001)(33656002)(55016003)(40140700001)(38070700005)(7696005)(71200400001)(2906002)(186003)(478600001)(66946007)(76116006)(66476007)(66556008)(64756008)(66446008)(4326008)(316002)(8676002)(6506007)(26005)(9686003)(41300700001)(8936002)(55236004)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVJQeHp1WGpQSkI3Rjlzb2NSN2NXTUFEMDNlV2Y4ZytlTnhYYXBPTGQ3U2Zz?=
 =?utf-8?B?c2U2aEdrSElsVTdQTitDTjhBbzFRYlJvanNCTzZ1QWc3enZCUDBzR3AzVjZG?=
 =?utf-8?B?NnY1ak93T0RCd3BTQjRZQVlPT3oydDcvTXg0UU1NdDliYmlGVDd1WmZGa3ZU?=
 =?utf-8?B?VGZ0dk9WVHI5TE1GVzhmTXJxTGllUFBZeHF1MEs1WHJPd084QlF0T2RaOG1K?=
 =?utf-8?B?dm1ZM3ZScUpzd0Y0cWhiRjlab1pmQ1ZnRFRob2ZLR3hlSnNISGl5ZTRoVm5B?=
 =?utf-8?B?RjA3bmVLT3FMVEJMS2RSTVJacmRma3hKVjI5Mmg3c3FvVitoVXNtZzVUU1J0?=
 =?utf-8?B?aGVYd3ZSYTErZFhkZjlmYkhLR2FPa3VCS1dIRUFRVmRGdERyQlRLVFNkL3Jo?=
 =?utf-8?B?bXpYWHVDdVFsT3VMNWJnZjJoSEk4c1RKcWtJQUE5ZUZZT0JQdGZWNkJiZGtu?=
 =?utf-8?B?Q0VaMThBZjUzOXR1VUd5ZmoxRTVncXB3eWthN2Z1TElraSt1aDV6SHgyRWNv?=
 =?utf-8?B?dWl4UDFWa1YrWi8wOStENlVSQjh4a2ZDaEo4Q1J5SkZrRnd1cWRTcFUrTTdW?=
 =?utf-8?B?V2Q5dEk2QWoxcElTUWVnMVhmbWV3bTAzUG0raUJmRERpY05tWjlsS1o3a2tq?=
 =?utf-8?B?Tm5nVk83Uit0UlhHRDVoNFFXWGQvMXZFMmZOcHYydFEzVmozdklnMXFLb241?=
 =?utf-8?B?emN4di9WM2IyaCtIdjY4RjgwWXlWY2JVNDVWT1o2WnVlQTI5Rk5iZmp5YmdZ?=
 =?utf-8?B?MDkzWkM2eUtoajFKdkJyUU9iMmdDd2FsbFBmZXpIZjlkaDBVaHRWS3lFTTh1?=
 =?utf-8?B?SnNMTjl6dkFiakx4UW5IN0lla3huMzFKV0plcEpWVUREWnhkT1pid2xDKzNE?=
 =?utf-8?B?ajJKbCt4VHo5WVM4ZllrSVU5V0V1Yy9sNWdqQURGWUhTanVCM3BOSHpWRUVF?=
 =?utf-8?B?azBIWVg2S3FzYklDV2tQWktibG5vbDE1NkZOUDFEZERsa2hyU2ZIN1RvMGVG?=
 =?utf-8?B?d3dNNWx3a1lDL1dSLy9TdUlxM0w0bmkyUlpKWjE5RDM3d28zQWttTzNUY1Jr?=
 =?utf-8?B?MzBQL09KUHFURERGOHFXeEV3QllmY044VndaMFV2RVFobDJaVCtDQTVqVnZz?=
 =?utf-8?B?d2FTMlVNWit3dEIvWFhEK2FyWTZJZ2grSXVDSXZwbE9wOG9ubTBkKzF6OUpS?=
 =?utf-8?B?enhoT2V6VmhHNlFVYUtwR0ZEcDZSR1pCTGUvNnVxNUF2MUYweE8vRzVMbzRQ?=
 =?utf-8?B?a3VReit4Z3A1SlhkeTUrbmVUYWZROGlvYWNVK1EzZ0xaa0NoNEExblVkSXVn?=
 =?utf-8?B?UjNyRUxjbk5jTTdVdjhoU0lSTHNERFFHRSt4WWEzR0p4MmFFZUh5R2VoZWlx?=
 =?utf-8?B?RC9qbnF2WDBWQ1FRQmJ4ZERBaEFtL1dSelNoQjJES00zcGVpMnVkRFBYay9B?=
 =?utf-8?B?SUluQVRZUHJzQldYMk82ZWgwTTdlVHFqSlNQYUtjWTF0QlZKTU5TM0NueDFZ?=
 =?utf-8?B?YUx4MWpRbGRGelk2SWlWamZIMEY3cFNjWmxHeTNDOWcwYkNqT2VGdVJmVWJj?=
 =?utf-8?B?R05xeGU2c3B1VkVkWTVERG55SEZUcnA0cXhjSGFmb3Era04zWnowcGhBK2to?=
 =?utf-8?B?UTBXN0tRUklPbWxleW9xTlY2OVlJdDhWR1ZvK1o5ZWtvMVhIMVJiUjR2TFd3?=
 =?utf-8?B?R1VseHFRaG1TSm9HRm41WU9SVmZZZDNmNkNNMXA1d0hjRkNCMnZHT2xrZnZa?=
 =?utf-8?B?Vk85c2xod3BjUzFGR1FrQUtuSVhiV2k5dFBMU3dlMlJhTjhvSjBUUXI5eVZZ?=
 =?utf-8?B?T2xKeTlnK2ZDOC9aa0I1ZEppRFJCNEllOWcrUmpZR2lNMmdqQjNEOTlERVJK?=
 =?utf-8?B?ZnR2eVlKNzRGblZpU1c5QklQeUYwVGtBMGRiZXFLNXJEVXR0Q1ZZb3NyUTQ1?=
 =?utf-8?B?WmtNSWFBUm5RaGRiRFc5aXNRTVhjVmlsSXFsaEtHWi9qeG5NeGpDTElYTVcw?=
 =?utf-8?B?NzJGSGl4QzUveWorb2NueUF3aVFlRDM0QnFyUE1SREZEMkhYT0hjU2JxTkNq?=
 =?utf-8?B?c0tZSEswSmVudGlqRm81dElGbWgyeG1neUU4NTYxWTJWOXFWUlJQL3Y1Rm0z?=
 =?utf-8?Q?erc3J4gjwAXPf2C65bKNuGT+Y?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1c9e4f1-10e7-4279-7e2d-08db0de45413
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 17:04:11.6856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hYKblF99pPwcstUfa4ykrwgK6M7ndyXQ1O9hBkSeZ1tSwROvWZpE8Xe4tEJQzlBXWhgxpI3WcAwQGwNKLvkBKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7689
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSW50ZWwtd2lyZWQtbGFu
IDxpbnRlbC13aXJlZC1sYW4tYm91bmNlc0Bvc3Vvc2wub3JnPiBPbiBCZWhhbGYgT2YNCj4gUGF3
ZWwgQ2htaWVsZXdza2kNCj4gU2VudDogVHVlc2RheSwgRmVicnVhcnkgNywgMjAyMyA5OjUzIFBN
DQo+IFRvOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBpbnRlbC13aXJlZC1sYW5Ab3N1
b3NsLm9yZw0KPiBTdWJqZWN0OiBbSW50ZWwtd2lyZWQtbGFuXSBbUEFUQ0ggbmV0LW5leHQgdjIg
MS8xXSBpY2U6IGFkZCBzdXBwb3J0IEJJRyBUQ1ANCj4gb24gSVB2Ng0KPiANCj4gRW5hYmxlIHNl
bmRpbmcgQklHIFRDUCBwYWNrZXRzIG9uIElQdjYgaW4gdGhlIGljZSBkcml2ZXIgdXNpbmcgZ2Vu
ZXJpYw0KPiBpcHY2X2hvcG9wdF9qdW1ib19yZW1vdmUgaGVscGVyIGZvciBzdHJpcHBpbmcgSEJI
IGhlYWRlci4NCj4gDQo+IFRlc3RlZDoNCj4gbmV0cGVyZiAtdCBUQ1BfUlIgLUggMjAwMTpkYjg6
MDpmMTAxOjoxICAtLSAtcjgwMDAwLDgwMDAwIC1PDQo+IE1JTl9MQVRFTkNZLFA5MF9MQVRFTkNZ
LFA5OV9MQVRFTkNZLFRSQU5TQUNUSU9OX1JBVEUNCj4gDQo+IFRlc3RlZCBvbiB0d28gZGlmZmVy
ZW50IHNldHVwcy4gSW4gYm90aCBjYXNlcywgdGhlIGZvbGxvd2luZyBzZXR0aW5ncyB3ZXJlDQo+
IGFwcGxpZWQgYWZ0ZXIgbG9hZGluZyB0aGUgY2hhbmdlZCBkcml2ZXI6DQo+IA0KPiBpcCBsaW5r
IHNldCBkZXYgZW5wMTc1czBmMW5wMSBnc29fbWF4X3NpemUgMTMwMDAwIGlwIGxpbmsgc2V0IGRl
dg0KPiBlbnAxNzVzMGYxbnAxIGdyb19tYXhfc2l6ZSAxMzAwMDAgaXAgbGluayBzZXQgZGV2IGVu
cDE3NXMwZjFucDEgbXR1IDkwMDANCj4gDQo+IEZpcnN0IHNldHVwOg0KPiBCZWZvcmU6DQo+IE1p
bmltdW3CoMKgwqDCoMKgIDkwdGjCoMKgwqDCoMKgwqDCoMKgIDk5dGjCoMKgwqDCoMKgwqDCoMKg
IFRyYW5zYWN0aW9uDQo+IExhdGVuY3nCoMKgwqDCoMKgIFBlcmNlbnRpbGXCoMKgIFBlcmNlbnRp
bGXCoMKgIFJhdGUgTWljcm9zZWNvbmRzDQo+IExhdGVuY3nCoMKgwqDCoMKgIExhdGVuY3nCoMKg
wqDCoMKgIFRyYW4vcw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgTWljcm9zZWNvbmRzIE1p
Y3Jvc2Vjb25kcw0KPiAxMzTCoMKgwqDCoMKgwqDCoMKgwqAgMjc5wqDCoMKgwqDCoMKgwqDCoMKg
IDQxMMKgwqDCoMKgwqDCoMKgwqDCoCAzOTYxLjU4NA0KPiANCj4gQWZ0ZXI6DQo+IE1pbmltdW3C
oMKgwqDCoMKgIDkwdGjCoMKgwqDCoMKgwqDCoMKgIDk5dGjCoMKgwqDCoMKgwqDCoMKgIFRyYW5z
YWN0aW9uDQo+IExhdGVuY3nCoMKgwqDCoMKgIFBlcmNlbnRpbGXCoMKgIFBlcmNlbnRpbGXCoMKg
IFJhdGUgTWljcm9zZWNvbmRzDQo+IExhdGVuY3nCoMKgwqDCoMKgIExhdGVuY3nCoMKgwqDCoMKg
IFRyYW4vcw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgTWljcm9zZWNvbmRzIE1pY3Jvc2Vj
b25kcw0KPiAxMzXCoMKgwqDCoMKgwqDCoMKgwqAgMTc4wqDCoMKgwqDCoMKgwqDCoMKgIDIxNsKg
wqDCoMKgwqDCoMKgwqDCoCA2MDkzLjQwNA0KPiANCj4gVGhlIG90aGVyIHNldHVwOg0KPiBCZWZv
cmU6DQo+IE1pbmltdW0gICAgICA5MHRoICAgICAgICAgOTl0aCAgICAgICAgIFRyYW5zYWN0aW9u
DQo+IExhdGVuY3kgICAgICBQZXJjZW50aWxlICAgUGVyY2VudGlsZSAgIFJhdGUNCj4gTWljcm9z
ZWNvbmRzIExhdGVuY3kgICAgICBMYXRlbmN5ICAgICAgVHJhbi9zDQo+ICAgICAgICAgICAgICBN
aWNyb3NlY29uZHMgTWljcm9zZWNvbmRzDQo+IDIxOCAgICAgICAgICA0MTQgICAgICAgICAgNDc4
ICAgICAgICAgIDI5NDQuNzY1DQo+IA0KPiBBZnRlcjoNCj4gTWluaW11bSAgICAgIDkwdGggICAg
ICAgICA5OXRoICAgICAgICAgVHJhbnNhY3Rpb24NCj4gTGF0ZW5jeSAgICAgIFBlcmNlbnRpbGUg
ICBQZXJjZW50aWxlICAgUmF0ZQ0KPiBNaWNyb3NlY29uZHMgTGF0ZW5jeSAgICAgIExhdGVuY3kg
ICAgICBUcmFuL3MNCj4gICAgICAgICAgICAgIE1pY3Jvc2Vjb25kcyBNaWNyb3NlY29uZHMNCj4g
MTQ2ICAgICAgICAgIDIzOCAgICAgICAgICAyNjYgICAgICAgICAgNDcwMC41OTYNCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IFBhd2VsIENobWllbGV3c2tpIDxwYXdlbC5jaG1pZWxld3NraUBpbnRlbC5j
b20+DQo+IC0tLQ0KPiANCj4gQ2hhbmdlcyBzaW5jZSB2MToNCj4gICogQWRkZWQgdGVzdGluZyBy
ZXN1bHRzDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZS5oICAg
ICAgfCAyICsrDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX21haW4uYyB8
IDIgKysNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV90eHJ4LmMgfCAzICsr
Kw0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKykNCj4gDQoNClRlc3RlZC1ieTog
R3VydWNoYXJhbiBHIDxndXJ1Y2hhcmFueC5nQGludGVsLmNvbT4gKEEgQ29udGluZ2VudCB3b3Jr
ZXIgYXQgSW50ZWwpDQo=
