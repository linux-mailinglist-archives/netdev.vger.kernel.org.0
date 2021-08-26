Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838943F8CCA
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 19:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243122AbhHZRPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 13:15:34 -0400
Received: from mail-mw2nam12on2080.outbound.protection.outlook.com ([40.107.244.80]:58369
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230184AbhHZRPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 13:15:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iukRTDfMuUtYQfxlRVH5sX5Lru8ZtJf4sFCyWa6m3Rc4p3+KqGfQJTkY/0RTlrg6cZy9KjAAmgvY6ZgeMPJzlfgKfJ6RjmCll2tCTQjOD5TjDDG9GpeQdpSQ8vyD7UhJMueLtclEGN5Upp/bOtoOjQVn0/4tgKqFhoqJ/HDCxq1fP1dTDus8zQisyf/dWUxyLO4MpHcmY54pMB7QL7kDHcPnWPb8hJg9v4cMacD3cGLMdX39QChPaXMd7a4tnatFWi1FVp9MJbcQQosDUOnwQEY26/tUmxw5WKtsL3QOfjlmxrW9+GoXZiytO8xHPZ/EXTHb2+yMmOhi1B3qsyZlcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7ZANz64sNMVLtb/aX9y88m7b5L1fkGp9lPOyuz8uD0=;
 b=P4lueAhD82NI5+FxhSHD/9OOAlLq7yhdWIbu6+qUiSHJMXcqYt+Uve0UxuUldLeSXhk26l7HKquZG6naf6L/YHvq/0oPzbKTdsWsIa16WrvDPr9Aj98oc/NMYXrzgvRIupAvr8hmkGv4mTJ11q6x1wkr3KoEkRsuOWijkKCKVGrknIw0+XmBSpPEQNRXJGSYx2URzDZOLus4bDaz3ygBHZPlSwXwshGkmGZklGD5VYh6V/m2EOBjaVJBfSYxPVfzBUa76m6vWXZQyU5+kfHxBG5L38snNjgg3mNgkUet7ZzFkwLpX2Gtx89caNTq5w6zllcJ64TpsQKQmwDXhqX9Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7ZANz64sNMVLtb/aX9y88m7b5L1fkGp9lPOyuz8uD0=;
 b=LfGMfmNGjHuC0C23fQgCtvl9hu7XenbTZAteoT06LSa5g50IiOy6oXK2a6F17lSW7LckQqcQopPvSAmaf+mXVv550E+/GwfGyJtYRUWAWIFBae5QobWsH17fpRdECeKn8IVg0vs8nH1ieXe0lDsPp+llPVxprmQwpbpn3SJUv4E8D52acbbjBOkltnEbpzkiYbNv9QpKD8tl3e1QxauK0fp3X3iV9ON3guTIjRUvfpR2j9JMroxbuVn2s5lltJ3QYNTvHPnOvEE6tYJprDTkjH77mK3sK3dnqL5F5PcAQt0eRfiSs5zASIEFBDxgZddxpUy3CIr+MWaNFEEKhU8WVg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 26 Aug
 2021 17:14:45 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 17:14:45 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leonro@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Roi Dayan <roid@nvidia.com>,
        "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net/mlx5: Remove all auxiliary devices at the
 unregister event
Thread-Topic: [PATCH net] net/mlx5: Remove all auxiliary devices at the
 unregister event
Thread-Index: AQHXloTQ2YFgnEDec0Ki1NhGxhAETquD8oMAgABYqoCAAcODAA==
Date:   Thu, 26 Aug 2021 17:14:44 +0000
Message-ID: <f99c4adb48111f9338fc6605680e5d10c54332a0.camel@nvidia.com>
References: <10641ab4c3de708f61a968158cac7620cef27067.1629547326.git.leonro@nvidia.com>
         <YSYG4it61d7ztmuq@unreal>
         <20210825071843.17f7831d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210825071843.17f7831d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 106518f3-09b5-41cd-617c-08d968b50028
x-ms-traffictypediagnostic: BY5PR12MB4209:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB42096CFDFF00639CBD6043C6B3C79@BY5PR12MB4209.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GwHl0WqLYhqh/AVXvMCVM9+7stOCEABuRKlY9AsSzNykl4JlZPfgFIos94hpAVS5h8tD79/B4VzQiboIucN6YR5ukC3I7mxDbPR+XZ0JF2PjXVSApfGE4CsRRfK/Y9awRAw9zxHHFp1H9kI5beYCYSICqXfZw1aNi1kz1kV4z28OEYeSb+zyEfAXGwAewo27UbHkAKycXdC/isxMET51E9qCzubwIqNeLLXwI0448hJhy86KAeJywnpR88S/fdvHI0NVNSdaAGdpnWVRyzs3qTe4W5dQrUY2xkqxRGvorZXZ/rMTphPegt0dNlhRKBJWXYXRKBT5s/vTimqcXkCOq8LuappzSgO2msvGZXlw79AoDs2CzuOzgGy2wlelaFTNyyn0R+Gx0I+A3I+AqN1h+fwc6lOcssuBzVtoO7spEP6UhZiZdm9wSM0ESchdy2KOpSWgnSWrglvUK21J4tDa9cxjCBRW7XTbE/C7rgbndr3r5gCDa2xwHIBDHwPt9RAchuSCCZ74AVnwnYicdjhqQ2N3jfNz3zQ3p7GxYKYjcnVuxI3irfdsIlo1PntUce3CdM4tpshUZntGB6UWvYqiBMde8372pv3erpeZ41seOHK/24Ob1Dq+v/SM6XFI0t+HtIKjxDD9807lv8CdCgQ51i+f6W5gwcanV/b8to/eFf+qxHxK28Bja4wlqQgcY6o+iYl3KmK6YOUuyqXHw3gAVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(6512007)(71200400001)(478600001)(64756008)(66946007)(6486002)(66446008)(54906003)(4326008)(316002)(2906002)(110136005)(66476007)(66556008)(5660300002)(83380400001)(2616005)(76116006)(38100700002)(122000001)(86362001)(6506007)(186003)(38070700005)(8676002)(8936002)(26005)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFl3N1dCcVpLTFlzZVV3NHJDOU43bGJabkRwUjQ2Skw5ZU9yZkVWWnF2Qy9Y?=
 =?utf-8?B?MVhsSlg2VTlzQkJyR0VrQ0Z1Z0t4ZUFqdlR1OG5CRElmZ2lWOFgxSjREcnlE?=
 =?utf-8?B?eG10a1RwLzBLSjZLTjdVTDhuaC8zUG04U0VpeHFkYnpHRUJKNjBRTFBxS2JT?=
 =?utf-8?B?WWxaQm1pUFZvWTZyZzhha0k3eTFsNnF1YkN4Ulk3R3dvVHpLT0RNRmZMVCtl?=
 =?utf-8?B?cFc3SFpDdTZlejByM2NiTmN6Y2RlMDYwd1VScGVac2FEOWtjZGhvc1hpNlo1?=
 =?utf-8?B?V0VZSThlbFptM2FUOElaTkozS29YQ0tjT1hIKzFUcDIyTTE1UXhCdi95ZUZP?=
 =?utf-8?B?cFQ4enBNZkc1NXRlemJuTjVVUE04WWlYclFmcGd0NDIyOWx6SDJjRnFlMUVu?=
 =?utf-8?B?RmlIRUZoMTl2WFlGZGVGQTNERmFFYXNGNG5haHB6ZTdJb0ZMZE8wb2RyNDl6?=
 =?utf-8?B?WDFwRDlnR2dKSEtlK1dEWmFHL2Q0UGpzNEFhS2hnTUNNc2FqcmJPQUZoQ0hZ?=
 =?utf-8?B?RGl4OFJnUzFrS1VhUjlTWHJYdXVQUFhOQ1ZVaE5IRk53V1huczg0V0ZaeFFa?=
 =?utf-8?B?QVJrckV4eDBUN21zR2lPZDFKY04xdmRPM21ONDNaNkp2OURiN0RLNmFKWk81?=
 =?utf-8?B?YngxUUtlcm85M2MwMTRuVFNaT1NrMWJQcGtkMXAwWVhFekZ1Qi9yVFZ1b092?=
 =?utf-8?B?RDRoVjRmMGRGb01uOGRhTVd0NTZIekNYWmZ1T2JPVk1GRUdpeDd3akdlcDk0?=
 =?utf-8?B?c1lNOGxNZ2QvMXpEZUNHYkVCYzNCZmdFZEgxN2pQU1BpR3BXMGZ3WVA1WkNU?=
 =?utf-8?B?Uk1JWjdJdG5ITFh6UXE5VU1kcVh6N0x5V1pKeWdWRHhTTEJMY3REMjYxdnJR?=
 =?utf-8?B?ZVlRZXEyZ2ZBWTdNN29iaUVvd2M4ZXBxY0FHUTlFY3laM0ZlbmVUdzJ3L1NX?=
 =?utf-8?B?TDJqNXkveWNWR0lKSHluc0VtNnVWRks0cVlqVndXQ0hwZnF1eU4xa1pUWlNm?=
 =?utf-8?B?c0NVb3hoUjVMK2NFVm9oZjVVYjNWQzlaeGU4MmFUamZJZjc0QU9MVWFybjRU?=
 =?utf-8?B?aENOUk5CQUZ6N2R2Nzl4WXBmc0NMWEx4bXBDUmI5VlQvYXd4b1pyUy85MzU0?=
 =?utf-8?B?MGpJOWxKWlZGdnc1MTc0VWMxbjNKRVNaSTl5ZkEyaXRhZ1lpN3JremxwMlg1?=
 =?utf-8?B?bVkwY0pDci9yWldPNWFaTW5IcEQ2OFkzcVllYmdPNUhXOVFMKytEeEtCUlZj?=
 =?utf-8?B?dFFnY09NTm1WK0xXTlJnMmpUd0xrQ1pPTlBnd2VxWXdZUklrUndWSThmSUlp?=
 =?utf-8?B?bnVXdEFVd09OVlZYZVcxOUN4c05IbE5NN3J5bGM5NlM3a3Nia2xBblZ6R3FE?=
 =?utf-8?B?M2FPMFNxL2lhaDlRZ1QrM3NYOFBYV0ZtcUFRSVg3OWh2TnhwMXBJYlBJamhk?=
 =?utf-8?B?MWNLdEF2OElzalI1VmhmMGx4ZTVaZ3Q5enprWkh6TjZVbm9hdUJEendrNHlK?=
 =?utf-8?B?NHd5TFU2cm16SnVaZ2tDS3dOZStFcHZhblZQbjRBWHdDZDJkeDF6QXBQVSti?=
 =?utf-8?B?VVZtbldEOElIdFZQa1BlL2huSGVWcU1vbDFJNjNaK1hNV2lCNnFCUUFWa0RY?=
 =?utf-8?B?MWVmL2JsM2E4QjRZRmRHTzE4dEkrQXBFWHNnYzMwZEVTNTNlV1MwYVdpVW5D?=
 =?utf-8?B?SEQrbW0vUWhZNnZTYTJkS2ZlNi9pWHhrcGlyNUdnYm12SktvMW81TVpBWU5E?=
 =?utf-8?B?WnY3U0lUdW85Vm1lbExLckRScmNOU0ZDUTJpNVAvKzV3dVF1d2pZbitwRGx4?=
 =?utf-8?B?U2lyN28rNHFhclB1blRJUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACE66289A810E745B08044362B42A457@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 106518f3-09b5-41cd-617c-08d968b50028
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 17:14:44.9695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rwTWFatuaQaFBFgC73f1x3Lamz5QD7q4VAxmMlUJHQz8eXW7qLBmykx8wzx4UOlolFuVljIC6wKayxL9lTcgGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4209
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA4LTI1IGF0IDA3OjE4IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAyNSBBdWcgMjAyMSAxMjowMToyMiArMDMwMCBMZW9uIFJvbWFub3Zza3kgd3Jv
dGU6DQo+ID4gT24gU2F0LCBBdWcgMjEsIDIwMjEgYXQgMDM6MDU6MTFQTSArMDMwMCwgTGVvbiBS
b21hbm92c2t5IHdyb3RlOg0KPiA+ID4gRnJvbTogTGVvbiBSb21hbm92c2t5IDxsZW9ucm9AbnZp
ZGlhLmNvbT4NCj4gPiA+IA0KPiA+ID4gVGhlIGNhbGwgdG8gbWx4NV91bnJlZ2lzdGVyX2Rldmlj
ZSgpIG1lYW5zIHRoYXQgbWx4NV9jb3JlIGRyaXZlcg0KPiA+ID4gaXMNCj4gPiA+IHJlbW92ZWQu
IEluIHN1Y2ggc2NlbmFyaW8sIHdlIG5lZWQgdG8gZGlzcmVnYXJkIGFsbCBvdGhlciBmbGFncw0K
PiA+ID4gbGlrZQ0KPiA+ID4gYXR0YWNoL2RldGFjaCBhbmQgZm9yY2libHkgcmVtb3ZlIGFsbCBh
dXhpbGlhcnkgZGV2aWNlcy4NCj4gPiA+IA0KPiA+ID4gRml4ZXM6IGE1YWU4ZmM5MDU4ZSAoIm5l
dC9tbHg1ZTogRG9uJ3QgY3JlYXRlIGRldmljZXMgZHVyaW5nDQo+ID4gPiB1bmxvYWQgZmxvdyIp
DQo+ID4gPiBUZXN0ZWQtYW5kLVJlcG9ydGVkLWJ5OiBZaWNvbmcgWWFuZyA8eWFuZ3lpY29uZ0Bo
aXNpbGljb24uY29tPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogTGVvbiBSb21hbm92c2t5IDxsZW9u
cm9AbnZpZGlhLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gwqBkcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZGV2LmMgfCAyICstDQo+ID4gPiDCoDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKcKgIA0KPiA+IA0KPiA+IEFueSByZWFzb24gZG8g
bm90IGFwcGx5IHRoaXMgcGF0Y2g/DQo+IA0KPiAnQXdhaXRpbmcgdXBzdHJlYW0nID0+IHdlIGV4
cGVjdCBTYWVlZCB0byB0YWtlIGl0IHZpYSBoaXMgdHJlZS4NCj4gSWYgc3BlY2lhbCBoYW5kbGlu
ZyBpcyByZXF1ZXN0ZWQgaXMgc2hvdWxkIGJlIG5vdGVkIHNvbWV3aGVyZS4NCg0KUGxhbm5lZCBm
b3Igc3VibWlzc2lvbiBpbiBteSBuZXh0IHByLg0KSSBkb24ndCBzZW5kIG5ldCBwcnMgdW50aWwg
aSBoYXZlIGVub3VnaCBjb250ZW50LCB0byBhdm9pZCBzcGFtbWluZyB0aGUNCm1haWxpbmcgbGlz
dCA6KS4NCg0KDQoNCg0K
