Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A7E46EB3
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 09:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbfFOHTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 03:19:38 -0400
Received: from mail-eopbgr750123.outbound.protection.outlook.com ([40.107.75.123]:42438
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725825AbfFOHTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Jun 2019 03:19:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=gCwszHyBqr2yuVBq9mK8lgszeA6Q7BQq7wApbNKqm9CnZkHZYmQbmaxDvB23N4lvjKK49LigjEkEsmYEEFquv2Bd3C0lvAEuv8bTBmlEwawtgkI/hQIc/HIFgf1uTILciM0elAT+XV+jmdJHuu0FDqJ/x/Q8iqSPDT6sffVE+JI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSAGMq0DMdK9Fk47IySGrWzf7qOm4l0hJnhsCRnHzcU=;
 b=SlN2iWahqVv52Pk1+1dzberXPSTNelG2Lrce3gHL2rdC44cHdlmR3snTkDSEd0RYOf1xjkHhYKUQTXSbT8tS2kjw0FoVblS1Tv2z635pUkmjPyAbgr+O0KmWBv7TupRmbCoKvwAdzL9GhpGzXmQ7OJATVl5vh4Ybxctn3ZzQ2Kw=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSAGMq0DMdK9Fk47IySGrWzf7qOm4l0hJnhsCRnHzcU=;
 b=JB5FiZwD5LgQ+IvlYj5DXtmsf1E5PXCxRwPvk0vPSAaMyqvBs9wLIFYylT3Lq+uY20htglYtLSjmEv9px3PdL026lg90mrlOsOu+XHypyIJeEI1VJIeRmDRAgKCUGHIlNOcOeWPjmv27li6FEMdMrsc3r/72XnL9cRE4wqctC14=
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com (2603:10b6:302:a::33)
 by MW2PR2101MB0985.namprd21.prod.outlook.com (2603:10b6:302:4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.4; Sat, 15 Jun
 2019 07:19:32 +0000
Received: from MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::a1f6:c002:82ba:ad47]) by MW2PR2101MB1116.namprd21.prod.outlook.com
 ([fe80::a1f6:c002:82ba:ad47%9]) with mapi id 15.20.2008.002; Sat, 15 Jun 2019
 07:19:32 +0000
From:   Sunil Muthuswamy <sunilmut@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>
Subject: RE: [PATCH net] hv_sock: Suppress bogus "may be used uninitialized"
 warnings
Thread-Topic: [PATCH net] hv_sock: Suppress bogus "may be used uninitialized"
 warnings
Thread-Index: AQHVIzdRyJ4h5bYUQkOiYCme+G2mp6acTflg
Date:   Sat, 15 Jun 2019 07:19:31 +0000
Message-ID: <MW2PR2101MB1116B911C7CAF2BF9884004FC0E90@MW2PR2101MB1116.namprd21.prod.outlook.com>
References: <1560574826-99551-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1560574826-99551-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=sunilmut@ntdev.microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-06-15T07:19:31.3753016Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4641602a-4424-4841-ac5c-b9f806288a66;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sunilmut@microsoft.com; 
x-originating-ip: [2001:4898:80e8:0:24b4:540:3de4:fc8f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3980b8e0-3ab7-4bde-ba70-08d6f161d034
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MW2PR2101MB0985;
x-ms-traffictypediagnostic: MW2PR2101MB0985:
x-ms-exchange-purlcount: 1
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB09853D664258F03A69D7791FC0E90@MW2PR2101MB0985.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:758;
x-forefront-prvs: 0069246B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(376002)(346002)(39860400002)(396003)(366004)(136003)(13464003)(189003)(199004)(305945005)(10290500003)(64756008)(99286004)(2201001)(229853002)(6636002)(478600001)(6506007)(76176011)(53546011)(2501003)(966005)(52536014)(25786009)(6246003)(66556008)(71190400001)(71200400001)(66446008)(2906002)(66476007)(8676002)(4326008)(6116002)(81166006)(81156014)(8936002)(74316002)(86362001)(7736002)(33656002)(55016002)(6306002)(14454004)(446003)(9686003)(11346002)(186003)(73956011)(66946007)(14444005)(256004)(76116006)(110136005)(53936002)(1511001)(7696005)(54906003)(10090500001)(102836004)(22452003)(46003)(52396003)(8990500004)(476003)(316002)(6436002)(5660300002)(486006)(68736007)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR2101MB0985;H:MW2PR2101MB1116.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cwRmHz/PY714c9cGgVoo1rDuGTao2ZdCw1PPNfLk7bZNWU1XNBTMdHaJk7P104KULikKsbFeBo6eYbF5BlJ51zoaJ5EKZH/7laBQP/El5QRH0qfWZeaEudqFtnVCacnT7ekA790hsAAp4qzizC5HwkIEPGjO/xEcH+CKchMsaVBvYnuOi/z9j9V/ZlfZKaqvdR+7yGGVFChXFdBE6UxiT7QUzFf7hGs23GlVvDgtW3DpYg3lvMh1TY8ixLBxVxj4ykQl2CWJFAoStmubRr4LwXfuISwjubVg39P3+Gm3wV/zo28i3VWLGjX83XJ5YniUZOMXd/+KHKIL9/sLDwWaOPlQzvS+KxTAx+kQ/kOYbkgub7x6PIzUZgCQYZSGYzafLO2jFy4P57UtSMRNeKNe7Cya90NyiIjebxmAFstCSiA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3980b8e0-3ab7-4bde-ba70-08d6f161d034
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2019 07:19:32.5342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sunilmut@ntdev.microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0985
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgtaHlwZXJ2LW93
bmVyQHZnZXIua2VybmVsLm9yZyA8bGludXgtaHlwZXJ2LW93bmVyQHZnZXIua2VybmVsLm9yZz4g
T24gQmVoYWxmIE9mIERleHVhbiBDdWkNCj4gU2VudDogRnJpZGF5LCBKdW5lIDE0LCAyMDE5IDEw
OjAxIFBNDQo+IFRvOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkYXZlbUBkYXZlbWxvZnQubmV0
OyBNaWNoYWVsIEtlbGxleSA8bWlrZWxsZXlAbWljcm9zb2Z0LmNvbT4NCj4gQ2M6IGxpbnV4LWh5
cGVydkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IEtZIFNy
aW5pdmFzYW4gPGt5c0BtaWNyb3NvZnQuY29tPjsgU3RlcGhlbiBIZW1taW5nZXINCj4gPHN0aGVt
bWluQG1pY3Jvc29mdC5jb20+OyBIYWl5YW5nIFpoYW5nIDxoYWl5YW5nekBtaWNyb3NvZnQuY29t
PjsgU2FzaGEgTGV2aW4gPEFsZXhhbmRlci5MZXZpbkBtaWNyb3NvZnQuY29tPjsNCj4gb2xhZkBh
ZXBmbGUuZGU7IGFwd0BjYW5vbmljYWwuY29tOyBqYXNvd2FuZ0ByZWRoYXQuY29tOyB2a3V6bmV0
cyA8dmt1em5ldHNAcmVkaGF0LmNvbT47IG1hcmNlbG8uY2VycmlAY2Fub25pY2FsLmNvbTsNCj4g
RGV4dWFuIEN1aSA8ZGVjdWlAbWljcm9zb2Z0LmNvbT4NCj4gU3ViamVjdDogW1BBVENIIG5ldF0g
aHZfc29jazogU3VwcHJlc3MgYm9ndXMgIm1heSBiZSB1c2VkIHVuaW5pdGlhbGl6ZWQiIHdhcm5p
bmdzDQo+IA0KPiBnY2MgOC4yLjAgbWF5IHJlcG9ydCB0aGVzZSBib2d1cyB3YXJuaW5ncyB1bmRl
ciBzb21lIGNvbmRpdGlvbjoNCj4gDQo+IHdhcm5pbmc6IOKAmHZuZXfigJkgbWF5IGJlIHVzZWQg
dW5pbml0aWFsaXplZCBpbiB0aGlzIGZ1bmN0aW9uDQo+IHdhcm5pbmc6IOKAmGh2c19uZXfigJkg
bWF5IGJlIHVzZWQgdW5pbml0aWFsaXplZCBpbiB0aGlzIGZ1bmN0aW9uDQo+IA0KPiBBY3R1YWxs
eSwgdGhlIDIgcG9pbnRlcnMgYXJlIG9ubHkgaW5pdGlhbGl6ZWQgYW5kIHVzZWQgaWYgdGhlIHZh
cmlhYmxlDQo+ICJjb25uX2Zyb21faG9zdCIgaXMgdHJ1ZS4gVGhlIGNvZGUgaXMgbm90IGJ1Z2d5
IGhlcmUuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQu
Y29tPg0KPiAtLS0NCj4gIG5ldC92bXdfdnNvY2svaHlwZXJ2X3RyYW5zcG9ydC5jIHwgNCArKy0t
DQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svaHlwZXJ2X3RyYW5zcG9ydC5jIGIvbmV0L3Zt
d192c29jay9oeXBlcnZfdHJhbnNwb3J0LmMNCj4gaW5kZXggOGQxZWE5ZWRhOGEyLi5jZDNmNDdm
NTRmYTcgMTAwNjQ0DQo+IC0tLSBhL25ldC92bXdfdnNvY2svaHlwZXJ2X3RyYW5zcG9ydC5jDQo+
ICsrKyBiL25ldC92bXdfdnNvY2svaHlwZXJ2X3RyYW5zcG9ydC5jDQo+IEBAIC0zMjksOCArMzI5
LDggQEAgc3RhdGljIHZvaWQgaHZzX29wZW5fY29ubmVjdGlvbihzdHJ1Y3Qgdm1idXNfY2hhbm5l
bCAqY2hhbikNCj4gDQo+ICAJc3RydWN0IHNvY2thZGRyX3ZtIGFkZHI7DQo+ICAJc3RydWN0IHNv
Y2sgKnNrLCAqbmV3ID0gTlVMTDsNCj4gLQlzdHJ1Y3QgdnNvY2tfc29jayAqdm5ldzsNCj4gLQlz
dHJ1Y3QgaHZzb2NrICpodnMsICpodnNfbmV3Ow0KPiArCXN0cnVjdCB2c29ja19zb2NrICp2bmV3
ID0gTlVMTDsNCj4gKwlzdHJ1Y3QgaHZzb2NrICpodnMsICpodnNfbmV3ID0gTlVMTDsNCj4gIAlp
bnQgcmV0Ow0KPiANClRoZXNlIGFyZSBhbGwgYWxyZWFkeSBmaXhlZCB1bmRlciANCmh0dHBzOi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVtL25ldC1uZXh0Lmdp
dC9jb21taXQvP2lkPWFjMzgzZjU4ZjNjOThkZTM3ZmE2NzQ1MmFjYzViZDY3NzM5NmU5ZjMgDQpJ
dHMganVzdCB0aGF0IHRoYXQgY29tbWl0IGhhc24ndCBtZXJnZWQgd2l0aCB0aGUgJ25ldCcgYnJh
bmNoIHlldC4NCj4gIAlpZl90eXBlID0gJmNoYW4tPm9mZmVybXNnLm9mZmVyLmlmX3R5cGU7DQo+
IC0tDQo+IDIuMTkuMQ0KDQo=
