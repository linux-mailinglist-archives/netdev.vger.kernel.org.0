Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9D1306807
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbhA0Xg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:36:29 -0500
Received: from mga03.intel.com ([134.134.136.65]:54428 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhA0XfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 18:35:02 -0500
IronPort-SDR: gUjXUepmNJBisOjMA0+MmzOrS/Q1HAZrSUe0qLngY0QV+u5lyQt6IeY66ko5rSSAXMFGTJFqgf
 NBPwzrl2utbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9877"; a="180229198"
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="180229198"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 15:34:17 -0800
IronPort-SDR: 9sPXJf9pre0tkG1DTlvCRBk63OhxB+dUkhUeIJVIVmj+RlznwGuH8UDqU8PP+R+xmYB0UpBzw0
 u8jKrWlRY+Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,380,1602572400"; 
   d="scan'208";a="353980113"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga003.jf.intel.com with ESMTP; 27 Jan 2021 15:34:16 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 27 Jan 2021 15:34:14 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 27 Jan 2021 15:34:13 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 27 Jan 2021 15:34:13 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 27 Jan 2021 15:34:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aA9eOS+9iewa8+hu8cZsWsFulTJ/qS47IR3In3AYp/xf3qa7xfiYOZDfSOqX1FZe8UTbzf4wBz0x9L41VYQhnHQnWjxQELwbMCYG6REFNfLAn+j2/oDEIE6cWbApb4vpyVMR/JRxkIF3rInbydOQXsUXkacRNXtlIryZFYVTGPzmUCvG+V5NRR+UdasXTAOPhXAZI+4myytSNm3kAS1raCkPjcdXNAOOBMFa7I+V08wUYYauCaje11wmlSXpPswq9EkauWdWDEqbdvr1zEYzUstQiT8Sdkzoy7mXTQhSm6KoI2KYVgp/6g6qo+AI/w2rUT808GB8dDMK0onq6wS6Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9sARgVJbSKnUZjEj4T3JUyDnGj3tVzxwbw55UtQE3E=;
 b=OR2MB9Pn/5psznBuJS/2zcGuOgxFFdQ+SaQ5gD99TU64xC/B6EXSR2XUCfznzeImBdqFCPBRj5JDn66dSorrox4ifrspTMQFjJXd8kzkd1cYtXTIz2GsyiWfv3Ofdi+qBinJmaKwTc9nk0vxPLSauMYaRtdcnxDnddaIgPcHY+hC3osBB1nwvZDzAmD11zZ9BNk7BqdJgWELE8bV6dBLh+++HiPrrcAvYjqkCTxNVBKpgFpuOEVuBPhVttzU2HNxsAwjbhoDrYnSaafheTmzQ4Xv840jDIUi7LnCYJtsRju0vKkREITeK1lXIWnj4Los2T4+97ifM9OgfxZTzKt9lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9sARgVJbSKnUZjEj4T3JUyDnGj3tVzxwbw55UtQE3E=;
 b=CqeB0c5FmInJ4iRZjDjwQSq25IiN82nqlEZhhxFiyIqfWw85emY2QWBm7DapZ+CR8Nu2PNP07qgPP2DUl2iLOXk1ggNMP3tTB7IFeJgLDKR7BaT2c6wypbRHi1QYMK8Lt+CZ/4BkIL/QUQEvmXHwqvlqStkF0XfJb4DBIrj47Ww=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3437.namprd11.prod.outlook.com (2603:10b6:805:db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Wed, 27 Jan
 2021 23:34:11 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::fc53:e004:bade:6bc6]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::fc53:e004:bade:6bc6%6]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 23:34:11 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "vinschen@redhat.com" <vinschen@redhat.com>
Subject: Re: [PATCH net v2 7/7] igc: fix link speed advertising
Thread-Topic: [PATCH net v2 7/7] igc: fix link speed advertising
Thread-Index: AQHW9DAM1+DlgE2RW0uFq3xy9RhKgKo7DM8AgAEUpYA=
Date:   Wed, 27 Jan 2021 23:34:11 +0000
Message-ID: <fe999d382f10af7dd73d0af2eb6dd60741137f95.camel@intel.com>
References: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
         <20210126221035.658124-8-anthony.l.nguyen@intel.com>
         <988cd2d7-e9f2-3947-7fcc-3da7fef7e34b@gmail.com>
In-Reply-To: <988cd2d7-e9f2-3947-7fcc-3da7fef7e34b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0febc2de-8308-49b2-543c-08d8c31c0d1e
x-ms-traffictypediagnostic: SN6PR11MB3437:
x-microsoft-antispam-prvs: <SN6PR11MB343724D7574F60CC6673D190C6BB9@SN6PR11MB3437.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oM1PnkldSbiSgfgQsqi7ekdRbehpv8sOvD7gL+u0A27wkGiNb47uY+4idaT6FFIWAKuOBwDq77gNojDqZ2mtR1yQ2y4tBHyHM2Iugq/U4vVABSt1YtNk3Ft1R3bTqguZyYg7kcPu/Y1GtIzj+mR8vGG45qsyV7V5om8CgfHse2vMzDy5Ge3H+aw+tRFs+3lSSeHnu2dFqe1iKy4RlpToaRKldW56aVaEHcd0PpQQlMvq1CdD9zehkJmlBUCgkUg2WcgOHsNQY4twFOdJy0KmJv5K9zJ8OxNcQibjybvoAdwrzceynC/n3/zETYjVVg598ECg7RWrCbTsUwSUViRnzTkBHn+eu234USiZzsBxcakcVTSnV62GPfAHvhA4uSXNcmPZAKYDfz9tiwhB3slZVH9+zZImLGAcBf1rB0x9Q/TafAuYrc9KMubCwKIGbtMr+ZNbQMoBclJnFOcZJsQb7ZUDHVpod8ZphNWANE1pW+gSUgU1FHWhDAMIEbpVHCxdC1+Vh25DSQFVnafPLqjQjDF9y6twGECJvcfY9129BSLjo8NihvGrU99o4rM8Lr8n
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(53546011)(66946007)(76116006)(4326008)(110136005)(186003)(66476007)(6506007)(8936002)(2616005)(66556008)(5660300002)(8676002)(86362001)(64756008)(26005)(36756003)(83380400001)(66446008)(19627235002)(71200400001)(2906002)(54906003)(478600001)(6512007)(6486002)(316002)(91956017)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dnVpVUw0OFNkZEhzRHAzek5EcW5JM0cwRzdHRWNhMzlNOVNqY1J0c3owTGN0?=
 =?utf-8?B?OElkRjNHU1dmckFoWTNxMXlmd3U2anZFdkRwZ0cyY09HMjI5TnoyZHBCNy9W?=
 =?utf-8?B?ekRubytzQjM1Q3N4MW9mQkpuTk1OT1M4NWhvSUZHaFpTMktoUzlOZFhtRHV6?=
 =?utf-8?B?TXhZYUZYMlQxT0YrTjBXa2NmOHAwb2VJL0wwWUJBcmFEd0JlSlZZZFF4S0NS?=
 =?utf-8?B?VFd3dmpZN24wUU1Lb2lTaEE1VFphSmhwRmRlOE5ZbU4vZi91bDNGOFhvY2Zi?=
 =?utf-8?B?TEQ5U0JxMFF6MGlZSzRiRVIvNUs0QnZDT3BLZmVncDJKQ0VLbm1Gd05OUnJC?=
 =?utf-8?B?M0MxWmtwT2krVGhUbFNsNmRYNjArQ3I4Tm5ldEM4Z3NmTkZMbDlkNWRWUm8w?=
 =?utf-8?B?NkFHaDd4OFdmbnFUTnFtNFFIaDk0M25VUzVxUktVNFkzZXBYekVLa1BwVFA0?=
 =?utf-8?B?RjdxRDB6UFgybmJ3Z25tdlF4STlTeExkN3Q3dnZhMjJPVXRsVUsyWlQyK2ZN?=
 =?utf-8?B?ZFNyaHd6WTNndkY4M2VmSStINENWQjRUa3hIR0R6UW1RWEtvVisyL2tHTTNV?=
 =?utf-8?B?Y1NwY1pQVVViMU5xclJvbncwQ1JUTmRwNGdKK2FQMmYvQ1UzYmcxVjdLMzZm?=
 =?utf-8?B?ZDl4bUVzT3pCdFBiVXlDL0cvMi95eS9JV01YRzRLNWFxZVNHQ2F2ZEc0Tko4?=
 =?utf-8?B?SjJZeVQvRnh5ZWhHYXFzcWR0QnVJb2dZUVUyYys1NVZpanBQRzNFakd6amor?=
 =?utf-8?B?d0QzdkU3QVp6c3JtUHVtN0plcUxJR1lCcXdPZFZMeFlBRW5QWDRtNVNDdldT?=
 =?utf-8?B?bmh0YVozOGo5VmpDWFZTUldyVzBHVmVIdDRVNFZtSFNzditZb2NBM2diaGdX?=
 =?utf-8?B?VGRHTmRodEUxaGNWOWN0MURuM0VtMG1QQ3dOWk1RdE55YXVYWE1rSEdWMTcx?=
 =?utf-8?B?a3FmNWtOZHpHTDl6elRwdmdFOUlzNmNhcllZc2NIeFQyUFVmR2h5RGY5TURj?=
 =?utf-8?B?VkppOHVGdm9FV1NMT0lKMTB6MFpwR2dMb2xyRVN0andudzdYODV0UDMwKzBP?=
 =?utf-8?B?eEw0am8xZ2tDYTRCUERJV0dxWlJSV2J1WGFzR0YzV25EdllvdVVXcFgybjN5?=
 =?utf-8?B?aXhmR0JkbDhNQjNzdVJ2NWwrRXc4Tnc3YkJCNE9kOTd0QnpuOEd5amFDelFv?=
 =?utf-8?B?OG1RK3hZSUFXZkticVpFRXdoSFRrczlhWDkxWC9yZDcyZlBJblJ3YjZmVVUx?=
 =?utf-8?B?NDN2dDUrUXZTQThmcWR5bFlLb0VkV0Q1TlhQTlZpRHZEcVNFcmxvM1psay92?=
 =?utf-8?B?VXhFY0I1MDVMMklPcXp0YkpKaWIzYlRIR1NTUE1FaC9kdkJJd1dUdlRwNzFv?=
 =?utf-8?B?U0tpYjQ3ZW1kSndsa1RadTVWdzA4RHB0b2pNaHVkU2pSZTQ5eDQydFhSRk1Y?=
 =?utf-8?B?Sk5WVmk5NlMrSmpLNEQzR3JFQzRhcUZJVHUzMjhnPT0=?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <70A0E9BE6910FA43B28679913C31FFA5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0febc2de-8308-49b2-543c-08d8c31c0d1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 23:34:11.8078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N52SGXh3rbiWHCayWP8W1FyB91DSKpYQdEVhr9KneT1H3/8n0HvXm8lGK36HcVtEpt0Jaf7ky1E7fTQsM5YL5xWCIayZaaTEvNcmeWhGK/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3437
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTAxLTI3IGF0IDA4OjA0ICswMTAwLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6
DQo+IE9uIDI2LjAxLjIwMjEgMjM6MTAsIFRvbnkgTmd1eWVuIHdyb3RlOg0KPiA+IEZyb206IENv
cmlubmEgVmluc2NoZW4gPHZpbnNjaGVuQHJlZGhhdC5jb20+DQo+ID4gDQo+ID4gTGluayBzcGVl
ZCBhZHZlcnRpc2luZyBpbiBpZ2MgaGFzIHR3byBwcm9ibGVtczoNCj4gPiANCj4gPiAtIFdoZW4g
c2V0dGluZyB0aGUgYWR2ZXJ0aXNlbWVudCB2aWEgZXRodG9vbCwgdGhlIGxpbmsgc3BlZWQgaXMN
Cj4gPiBjb252ZXJ0ZWQNCj4gPiAgIHRvIHRoZSBsZWdhY3kgMzIgYml0IHJlcHJlc2VudGF0aW9u
IGZvciB0aGUgaW50ZWwgUEhZIGNvZGUuDQo+ID4gICBUaGlzIGluYWR2ZXJ0ZW50bHkgZHJvcHMg
RVRIVE9PTF9MSU5LX01PREVfMjUwMGJhc2VUX0Z1bGxfQklUDQo+ID4gKGJlaW5nDQo+ID4gICBi
ZXlvbmQgYml0IDMxKS4gIEFzIGEgcmVzdWx0LCBhbnkgY2FsbCB0byBgZXRodG9vbCAtcyAuLi4n
IGRyb3BzDQo+ID4gdGhlDQo+ID4gICAyNTAwTWJpdC9zIGxpbmsgc3BlZWQgZnJvbSB0aGUgUEhZ
IHNldHRpbmdzLiAgT25seSByZWxvYWRpbmcgdGhlDQo+ID4gZHJpdmVyDQo+ID4gICBhbGxldmlh
dGVzIHRoYXQgcHJvYmxlbS4NCj4gPiANCj4gPiAgIEZpeCB0aGlzIGJ5IGNvbnZlcnRpbmcgdGhl
IEVUSFRPT0xfTElOS19NT0RFXzI1MDBiYXNlVF9GdWxsX0JJVA0KPiA+IHRvIHRoZQ0KPiA+ICAg
SW50ZWwgUEhZIEFEVkVSVElTRV8yNTAwX0ZVTEwgYml0IGV4cGxpY2l0bHkuDQo+ID4gDQo+ID4g
LSBSYXRoZXIgdGhhbiBjaGVja2luZyB0aGUgYWN0dWFsIFBIWSBzZXR0aW5nLCB0aGUNCj4gPiAu
Z2V0X2xpbmtfa3NldHRpbmdzDQo+ID4gICBmdW5jdGlvbiBhbHdheXMgZmlsbHMgbGlua19tb2Rl
cy5hZHZlcnRpc2luZyB3aXRoIGFsbCBsaW5rIHNwZWVkcw0KPiA+ICAgdGhlIGRldmljZSBpcyBj
YXBhYmxlIG9mLg0KPiA+IA0KPiA+ICAgRml4IHRoaXMgYnkgY2hlY2tpbmcgdGhlIFBIWSBhdXRv
bmVnX2FkdmVydGlzZWQgc2V0dGluZ3MgYW5kDQo+ID4gcmVwb3J0DQo+ID4gICBvbmx5IHRoZSBh
Y3R1YWxseSBhZHZlcnRpc2VkIHNwZWVkcyB1cCB0byBldGh0b29sLg0KPiA+IA0KPiA+IEZpeGVz
OiA4YzVhZDBkYWU5M2MgKCJpZ2M6IEFkZCBldGh0b29sIHN1cHBvcnQiKQ0KPiA+IFNpZ25lZC1v
ZmYtYnk6IENvcmlubmEgVmluc2NoZW4gPHZpbnNjaGVuQHJlZGhhdC5jb20+DQo+ID4gU2lnbmVk
LW9mZi1ieTogVG9ueSBOZ3V5ZW4gPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPg0KPiA+IC0t
LQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX2V0aHRvb2wuYyB8IDI0
ICsrKysrKysrKysrKysrKy0NCj4gPiAtLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNl
cnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiANCj4gV291bGQgc3dpdGNoaW5nIHRv
IHBoeWxpYiBiZSBhIG1pZC10ZXJtIG9wdGlvbiBmb3IgeW91Pw0KPiBUaGlzIGNvdWxkIHNhdmUg
cXVpdGUgc29tZSBjb2RlIGFuZCB5b3UnZCBnZXQgdGhpbmdzIGxpa2UgcHJvcGVyDQo+IDIuNUdi
cHMNCj4gaGFuZGxpbmcgb3V0IG9mIHRoZSBib3guIE9yIGlzIHRoZXJlIGFueXRoaW5nIHRoYXQg
cHJldmVudHMgdXNpbmcNCj4gcGh5bGliPw0KDQpQaHlsaWIgaXMgc29tZXRoaW5nIHdlIGNhbiBs
b29rIGludG8gdGhvdWdoIHdlIGhhdmUgc29tZSBkZXZpY2UNCnNwZWNpZmljIHF1aXJrcyB0aGF0
IHdlIHdvdWxkIG5lZWQgdG8gc2VlIGhvdyBpdCBjb3VsZCBiZSBoYW5kbGVkLg0KU2luY2UgdGhp
cyBpcyBmaXhpbmcgYSBjdXJyZW50IHByb2JsZW0gYW5kIGFueSB0cmFuc2l0aW9uIHRvIHBoeWxp
Yg0Kd291bGQgbm90IGJlIGltbWVkaWF0ZSwgSSB0aGluayB0aGlzIHBhdGNoIHNob3VsZCBiZSBh
Y2NlcHRlZCB3aGlsZSB3ZQ0KaW52ZXN0aWdhdGUgcGh5bGliLg0KDQpUaGFua3MsDQpUb255DQo=
