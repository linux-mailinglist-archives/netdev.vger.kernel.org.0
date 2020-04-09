Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4829A1A36A5
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgDIPKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:10:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51800 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727771AbgDIPKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:10:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 039F0oQa003361;
        Thu, 9 Apr 2020 08:09:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=IZR7gkHqzvR90VO/3aEWPCv+sOYf9nIOLnPpldXk30c=;
 b=CYtvKPjOUPaeebc9IyH+IXpFaS5ct/yRFsyZIW9qRBcq9YtkTwY3uTvd5UYUkPZ9vBsU
 /6ti4nK7XsEpobQby+dzKduGHyqEccPF1LNZK/RiwPiSz7ioWK1isowmPHXjdWLMGQqF
 IAVdiSi2Z+17F3vWj+vtnHBhHM2/2HTdBa1zkBOduNp9AtkoCV7Dg22LNQUWxWsW207G
 UlxlV2DzkZi8yjF4heZ1mQiBZ+hx7ONfT89vqhUvx0HemXBjKFm7PHeBJ+tiIySgHnEy
 mXaIi1uc20zDScqjjuQgnJzQJFHwc2tkeAnKWvNxuyqw6bZSHVkV77HPD4dgmKR/jYpe 4Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3091me8x0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 08:09:58 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:09:56 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.57) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 9 Apr 2020 08:09:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRR2MfducxfqdgzjJ22sU5zSNliQjON0GcPwkFD960qNsSCrdp3eYRYOK+xto/kf67sjGhS5Rwt35lPLnCAF3+puw0aTo5JuYBW6Rwn+Bmc2/uw+2J+rJroBxK1o24IurwRrwkW65ibGRR9LQmRUVSv/rlyebdPpSgVCGZO5pW7h37bBN9SXkDcE0e0pwhJsr9ZMzCucKbT09zm0QiSkTDOqEreh/4yAvavTQGnhot/GhLNRPeW2Jr5zdv9flFGB9WpvN8sW/uN0SR+Lr6A0I2Eb6ukTkYcj6NQ0eueZ0Slo7LThNurKRJNraIRTZDxk5TsSDBBGtMF/TQa9akHrBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZR7gkHqzvR90VO/3aEWPCv+sOYf9nIOLnPpldXk30c=;
 b=d8tis7bclgVQQiQjSYskTa4YrLuXnGESGFE6kUBTkk+t1FjOT169eJ/S+VGbUIs1v8CXVqOBqr73xqZatryoUXKHvz9QNMTpYSqm/B22nDZjQWkJoIYzRiR/MtVtYmkM9EERGBovCnNvdGS53TZnC3FBg+ttl9uEYlwVoeAE2Js3XWumAhWaFyvAdZCrH4avK0+ndfMiuT1Vg0aAVszYq+c3er9LCWzSJqyZgPd7IOv9Bo1M1nOPbm5lfQfZYIx5iXkJvYrenaOwAR/eTjGQC3T8GazBtNvT3G9+C0nCGdhmuXX2kCvNAiQlyV/8s9zFmH+2t40GFz4V6NyNJOp2iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZR7gkHqzvR90VO/3aEWPCv+sOYf9nIOLnPpldXk30c=;
 b=QT/rpUOtJVY36I8y5QxuvDgFaz+duSdKYVAN09+/HxIK74P+XayR+En5AdQg+EGAvzXaDoCtPNer5d7GgW7gfpQEDmgH7Vuv/iSMgaP3MfDOLMZOAnkJGNl9Hc0duC/4Z96yTLDiDsT4Aog2PNOE4eWfvEYLyEFeXpdel6deNqU=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB3749.namprd18.prod.outlook.com (2603:10b6:a03:96::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Thu, 9 Apr
 2020 15:09:54 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280%3]) with mapi id 15.20.2878.022; Thu, 9 Apr 2020
 15:09:54 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 00/13] "Task_isolation" mode
Thread-Topic: [PATCH v3 00/13] "Task_isolation" mode
Thread-Index: AQHWDoDs8YuoS+TFyku4VXyhIUVeNQ==
Date:   Thu, 9 Apr 2020 15:09:53 +0000
Message-ID: <07c25c246c55012981ec0296eee23e68c719333a.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
In-Reply-To: <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bed32cf4-45b8-48ec-ce07-08d7dc980f16
x-ms-traffictypediagnostic: BYAPR18MB3749:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB374925A22C219F19A402A1C5BCC10@BYAPR18MB3749.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2535.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(86362001)(71200400001)(6486002)(6506007)(66946007)(66556008)(36756003)(5660300002)(6512007)(2906002)(76116006)(8676002)(110136005)(66446008)(81156014)(2616005)(316002)(64756008)(26005)(186003)(54906003)(81166007)(478600001)(8936002)(66476007)(7416002)(4326008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OLlZp9/C6rDdvhJtghH3Y09hOWfZzkQsSHkHlG3obPhwmyy9hCjXP2B2wxqkwfdBPdwKqbFdPTk0Tz0i33u1M3L0+/Y+KyBcubGmpnubMl2f9xE65pMPD5YPV3io93dCQhjtVOQMWAf1eGujyJ04TZX/p02bFF/iMXqEHK96h7507HORw+pKXlJ5lJj41t41g1e839SRUC7feVAODFNxM/JKe9txyUtKIeZFqDEesIV35Wajk+XVpiK0Gc1UHloE0KPGLp5yANHKngYtdq9DRmx717DXasz1Lej4xCXYjd2bRVv4pJkxygwm1ruOz/PneeJm60Kbch9qq1+Jz6BEkGhdOcPz3X0GMUiQ/0Sxlb1GCGmoj+Veu8/BPyAjujMRf4TNbeZhZlxejjkCOnBv6XvNzmBretIAnEfkA2zI3g8uhTWONm5+BaBo/EP+DyA2
x-ms-exchange-antispam-messagedata: fFcO94MlZCOlx0TN7lL5B3Viv42wrDcFNIZLHPiBU8kjGIlZPls27QZGSzJZQyF6l+o6Ger/AZZzO0Ea9eC8FM9OKS/5phwvTpoaeJOICYSrKI3f8kS0U5W3o+pgUI7mMhwY3ZAsTR1k1lbrNdGI5Q==
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF585B88C94C664FBF9473B31EB6D7BE@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bed32cf4-45b8-48ec-ce07-08d7dc980f16
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 15:09:54.0497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aBaeDl38khjWFQatad/+vUEg23MiL7CL6xazxKbDssBdsp5eljIbWRnv0lGwtcJeVA3t+pMCQ3WtPZHLhVhZIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB3749
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_04:2020-04-07,2020-04-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBTYXQsIDIwMjAtMDMtMDcgYXQgMTk6NDIgLTA4MDAsIEFsZXggQmVsaXRzIHdyb3RlOg0K
PiBUaGlzIGlzIHRoZSB1cGRhdGVkIHZlcnNpb24gb2YgdGFzayBpc29sYXRpb24gcGF0Y2hzZXQu
DQo+IA0KPiAxLiBDb21taXQgbWVzc2FnZXMgdXBkYXRlZCB0byBtYXRjaCBjaGFuZ2VzLg0KPiAy
LiBTaWduLW9mZiBsaW5lcyByZXN0b3JlZCBmcm9tIG9yaWdpbmFsIHBhdGNoZXMsIGNoYW5nZXMg
bGlzdGVkDQo+IHdoZXJldmVyIGFwcGxpY2FibGUuDQo+IDMuIGFybSBwbGF0Zm9ybSAtLSBhZGRl
ZCBtaXNzaW5nIGNhbGxzIHRvIHN5c2NhbGwgY2hlY2sgYW5kIGNsZWFudXANCj4gcHJvY2VkdXJl
IGFmdGVyIGxlYXZpbmcgaXNvbGF0aW9uLg0KPiA0LiB4ODYgcGxhdGZvcm0gLS0gYWRkZWQgbWlz
c2luZyBjYWxscyB0byBjbGVhbnVwIHByb2NlZHVyZSBhZnRlcg0KPiBsZWF2aW5nIGlzb2xhdGlv
bi4NCj4gDQoNCkFub3RoZXIgdXBkYXRlLCBhZGRyZXNzaW5nIENQVSBzdGF0ZSAvIHJhY2UgY29u
ZGl0aW9ucy4NCg0KSSBiZWxpZXZlLCBJIGhhdmUgc29tZSB1c2FibGUgc29sdXRpb24gZm9yIHRo
ZSBwcm9ibGVtIG9mIGJvdGggbWlzc2luZw0KdGhlIGV2ZW50cyBhbmQgcmFjZSBjb25kaXRpb25z
IG9uIGlzb2xhdGlvbiBlbnRyeSBhbmQgZXhpdC4NCg0KVGhlIGlkZWEgaXMgdG8gbWFrZSBzdXJl
IHRoYXQgQ1BVIGNvcmUgcmVtYWlucyBpbiB1c2Vyc3BhY2UgYW5kIHJ1bnMNCnVzZXJzcGFjZSBj
b2RlIHJlZ2FyZGxlc3Mgb2Ygd2hhdCBpcyBoYXBwZW5pbmcgaW4ga2VybmVsIGFuZCB1c2Vyc3Bh
Y2UNCmluIHRoZSByZXN0IG9mIHRoZSBzeXN0ZW0sIGhvd2V2ZXIgYW55IGV2ZW50cyB0aGF0IHJl
c3VsdHMgaW4gcnVubmluZw0KYW55dGhpbmcgb3RoZXIgdGhhbiB1c2Vyc3BhY2UgY29kZSB3aWxs
IHJlc3VsdCBpbiBDUFUgY29yZQ0KcmUtc3luY2hyb25pemluZyB3aXRoIHRoZSByZXN0IG9mIHRo
ZSBzeXN0ZW0uIFRoZW4gYW55IGtlcm5lbCBjb2RlLA0Kd2l0aCB0aGUgZXhjZXB0aW9uIG9mIHNt
YWxsIGFuZCBjbGVhcmx5IGRlZmluZWQgc2V0IG9mIHJvdXRpbmVzIHRoYXQNCm9ubHkgcGVyZm9y
bSBrZXJuZWwgZW50cnkgLyBleGl0IHRoZW1zZWx2ZXMsIHdpbGwgcnVuIG9uIENQVSBhZnRlciBh
bGwNCnN5bmNocm9uaXphdGlvbiBpcyBkb25lLg0KDQpUaGlzIGRvZXMgcmVxdWlyZSBhbiBhbnN3
ZXIgdG8gcG9zc2libGUgcmFjZXMgYmV0d2VlbiBpc29sYXRpb24gZW50cnkNCi8gZXhpdCAoaW5j
bHVkaW5nIGlzb2xhdGlvbiBicmVha2luZyBvbiBpbnRlcnJ1cHRzKSBhbmQgdXBkYXRlcyB0aGF0
DQphcmUgbm9ybWFsbHkgY2FycmllZCBieSBJUElzLiBTbyB0aGUgc29sdXRpb24gc2hvdWxkIGlu
dm9sdmUgc29tZQ0KbWVjaGFuaXNtIHRoYXQgbGltaXRzIHdoYXQgcnVucyBvbiBDUFUgaW4gaXRz
ICJzdGFsZSIgc3RhdGUsIGFuZA0KY2F1c2VzIGluZXZpdGFibGUgc3luY2hyb25pemF0aW9uIGJl
Zm9yZSB0aGUgcmVzdCBvZiB0aGUga2VybmVsIGlzDQpjYWxsZWQuIFRoaXMgc2hvdWxkIGFsc28g
aW5jbHVkZSBhbnkgcHJlZW1wdGlvbiAtLSBpZiBwcmVlbXRpb24NCmhhcHBlbnMgaW4gdGhhdCAi
c3RhbGUiIHN0YXRlIGFmdGVyIGVudGVyaW5nIHRoZSBrZXJuZWwgYnV0IGJlZm9yZQ0Kc3luY2hy
b25pemF0aW9uIGlzIGNvbXBsZXRlZCwgaXQgc2hvdWxkIHN0aWxsIGdvIHRocm91Z2gNCnN5bmNo
cm9uaXphdGlvbiBiZWZvcmUgcnVubmluZyB0aGUgcmVzdCBvZiB0aGUga2VybmVsLg0KDQpUaGVu
IGFzIGxvbmcgYXMgaXQgY2FuIGJlIGRlbW9uc3RyYXRlZCB0aGF0IHJvdXRpbmVzIHJ1bm5pbmcg
aW4NCiJzdGFsZSIgc3RhdGUgY2FuIHNhZmVseSBydW4gaW4gaXQsIGFuZCBhbnkgZXZlbnQgdGhh
dCB3b3VsZCBub3JtYWxseQ0KcmVxdWlyZSBJUEksIHdpbGwgcmVzdWx0IGluIGVudGVyaW5nIHRo
ZSByZXN0IG9mIGtlcm5lbCBhZnRlcg0Kc3luY2hyb25pemF0aW9uLCByYWNlIHdvdWxkIGNlYXNl
IHRvIGJlIGEgcHJvYmxlbS4gQW55IHNlcXVlbmNlIG9mDQpldmVudHMgd291bGQgcmVzdWx0IGlu
IGV4YWN0bHkgdGhlIHNhbWUgQ1BVIHN0YXRlIHdoZW4gaGl0dGluZyB0aGUNCnJlc3Qgb2YgdGhl
IGtlcm5lbCwgYXMgaWYgQ1BVIHByb2Nlc3NlZCB0aGUgdXBkYXRlIGV2ZW50IHRocm91Z2ggSVBJ
Lg0KDQpJIHdhcyB1bmRlciBpbXByZXNzaW9uIHRoYXQgdGhpcyBpcyBhbHJlYWR5IHRoZSBjYXNl
LCBob3dldmVyIGFmdGVyDQpzb21lIGNsb3NlciBsb29rIGl0IGFwcGVhcnMgdGhhdCBzb21lIGJh
cnJpZXJzIG11c3QgYmUgaW4gcGxhY2UgdG8NCm1ha2Ugc3VyZSB0aGF0IHRoZSBzZXF1ZW5jZSBv
ZiBldmVudHMgaXMgZW5mb3JjZWQuDQoNClRoZXJlIGlzIG9idmlvdXNseSBhIHF1ZXN0aW9uIG9m
IHBlcmZvcm1hbmNlIC0tIHdlIGRvbid0IHdhbnQgdG8gY2F1c2UNCmFueSBhZGRpdGlvbmFsIGZs
dXNoZXMgb3IgYWRkIGxvY2tpbmcgaW4gYW55dGhpbmcNCnRpbWUtY3JpdGljYWwuIEZvcnR1bmF0
ZWx5IGVudGVyaW5nIGFuZCBleGl0aW5nIGlzb2xhdGlvbiAoYXMgb3Bwb3NlZA0KdG8gZXZlbnRz
IHRoYXQgX3BvdGVudGlhbGx5XyBjYW4gY2FsbCBpc29sYXRpb24tYnJlYWtpbmcgcm91dGluZXMp
IGlzDQpuZXZlciBwZXJmb3JtYW5jZS1jcml0aWNhbCwgaXQncyB3aGF0IHN0YXJ0cyBhbmQgZW5k
cyBhIHRhc2sgdGhhdCBoYXMNCm5vIHBlcmZvcm1hbmNlLWNyaXRpY2FsIGNvbW11bmljYXRpb24g
d2l0aCBrZXJuZWwuIFNvIGlmIGEgQ1BVIHRoYXQNCmhhcyBpc29sYXRlZCB0YXNrIG9uIGl0IGlz
IHJ1bm5pbmcga2VybmVsIGNvZGUsIGl0IG1lYW5zIHRoYXQgZWl0aGVyDQp0aGUgdGFzayBpcyBu
b3QgaXNvbGF0ZWQgeWV0ICh3ZSBhcmUgZXhpdGluZyB0byB1c2Vyc3BhY2UpLCBvciBpdCBpcw0K
bm8gbG9uZ2VyIHJ1bm5pbmcgYW55dGhpbmcgcGVyZm9ybWFuY2UtY3JpdGljYWwgKGludGVudGlv
bmFsbHkgb24gZXhpdA0KZnJvbSBpc29sYXRpb24sIG9yIHVuaW50ZW50aW9uYWxseSBvbiBpc29s
YXRpb24gYnJlYWtpbmcgZXZlbnQpLg0KDQpJc29sYXRpb24gc3RhdGUgaXMgcmVhZC1tb3N0bHks
IGFuZCB3ZSB3b3VsZCBwcmVmZXIgUkNVIGZvciB0aGF0IGlmIHdlDQpjYW4gZ3VhcmFudGVlIHRo
YXQgInN0YWxlIiBzdGF0ZSByZW1haW5zIHNhZmUgaW4gYWxsIGNvZGUgdGhhdCBydW5zDQp1bnRp
bCBzeW5jaHJvbml6YXRpb24gaGFwcGVuLiBJIGFtIG5vdCBzdXJlIG9mIHRoYXQsIHNvIEkgdHJp
ZWQgdG8NCm1ha2Ugc29tZXRoaW5nIG1vcmUgc3RyYWlnaHRmb3J3YXJkLCBob3dldmVyIEkgbWln
aHQgYmUgd3JvbmcsIGFuZA0KUkNVLWlmeWluZyBleGl0IGZyb20gaXNvbGF0aW9uIG1heSBiZSBh
IGJldHRlciB3YXkgZG8gZG8gaXQuDQoNCkZvciBub3cgSSB3YW50IHRvIG1ha2Ugc3VyZSB0aGF0
IHRoZXJlIGlzIHNvbWUgY2xlYXJseSBkZWZpbmVkIHNtYWxsDQphbW91bnQgb2Yga2VybmVsIGNv
ZGUgdGhhdCBydW5zIGJlZm9yZSB0aGUgaW5ldml0YWJsZSBzeW5jaHJvbml6YXRpb24sDQphbmQg
dGhhdCBjb2RlIGlzIHVuYWZmZWN0ZWQgYnkgInN0YWxlIiBzdGF0ZS4NCg0KSSBoYXZlIHRyaWVk
IHRvIHRyYWNrIGRvd24gYWxsIGNhbGwgcGF0aHMgZnJvbSBrZXJuZWwgZW50cnkgcG9pbnRzDQp0
byB0aGUgY2FsbCBvZiBmYXN0X3Rhc2tfaXNvbGF0aW9uX2NwdV9jbGVhbnVwKCksIGFuZCB3aWxs
IHBvc3QgdGhvc2UNCnNlcGFyYXRlbHkuIEl0J3MgcG9zc2libGUgdGhhdCBhbGwgYXJjaGl0ZWN0
dXJlLXNwZWNpZmljIGNvZGUgYWxyZWFkeQ0KZm9sbG93cyBzb21lIGNsZWFybHkgZGVmaW5lZCBy
dWxlcyBhYm91dCB0aGlzIGZvciBvdGhlciByZWFzb25zLA0KaG93ZXZlciBJIGFtIG5vdCB0aGF0
IGZhbWlsaWFyIHdpdGggYWxsIG9mIGl0LCBhbmQgdHJpZWQgdG8gY2hlY2sgaWYNCmV4aXN0aW5n
IGltcGxlbWVudGF0aW9uIGlzIGFsd2F5cyBzYWZlIGZvciBydW5uaW5nIGluICJzdGFsZSIgc3Rh
dGUNCmJlZm9yZSBldmVyeXRoaW5nIHRoYXQgbWFrZXMgdGFzayBpc29sYXRpb24gY2FsbCBpdHMg
Y2xlYW51cC4gRm9yIG5vdywNCnRoaXMgaXMgdGhlIGltcGxlbWVudGF0aW9uIHRoYXQgYXNzdW1l
cyB0aGF0ICJzdGFsZSIgc3RhdGUgaXMgc2FmZSBmb3INCmtlcm5lbCBlbnRyeS4NCg==
