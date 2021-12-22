Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DAA47D968
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 23:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241866AbhLVWtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 17:49:49 -0500
Received: from esa.hc3962-90.iphmx.com ([216.71.142.165]:12371 "EHLO
        esa.hc3962-90.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhLVWts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 17:49:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qccesdkim1;
  t=1640213388; x=1640818188;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K/79TTsRuphS065Q9inqvhuK9t9DSYg9Uq8QsfkHyqc=;
  b=e1Qjz2hj8oVVNn1pM+6H4IY1GYqgsSvSnAKRDnieet9iab3DJUQMdBRn
   gBf2KbIespEZkvVobKtAg3EThyofa9jC+vAQeePiWi4jsQSXOy+pMgfi4
   66T+1kAmHSA7+LiG7Ba1wR3flZCuKe1/BPYZc/FCOcVXaAlmwu4eBQAJX
   Y=;
Received: from mail-dm6nam08lp2045.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.45])
  by ob1.hc3962-90.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 22:49:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8AtjaC979661E+NII0xh5fhJHCF/mRgj3XtWamGjt/Vqut55yaMmqyIfvFxy5QVH1xHNK79XXPXWMDnPM2zKyqeIeFHWI+fX1HkmYMvTTj46UunGoioeeutktKH129bCb85IXf+ZxL9Ea0tD6v/u3YUV+o/tt+f6th+OdFrP7TUerMoJ+JePXbDWkDlT6aN3ikxLcZKPSut/f1IfSN8z/LPx8xavtSfRfmMNdci2MKMHHvdTtrriA65SS5gV6WT5zUXIr89d4EgPQyCczqKoCM3Q6tbCSeBUDw3tP0OChzQYkMxWKSbiY1HQ+DuF9wkCbHx0jlWNi3/w36md5rrGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K/79TTsRuphS065Q9inqvhuK9t9DSYg9Uq8QsfkHyqc=;
 b=DSMwVW7QVlKPN6qEq6zEo9qZ2Du4s5YViJiiiAiagKIXHVGxuoovc/uyG7A3tiasyq6uBXZVhDW6nU1UatiD0/C30h2Wxzf4kKJFsQUXrRdDQbDICVxjkvZHH688n0MATIWtk+PmjDbC2jelG7HWdStjS4ctH7XfJ4E5AW3rSjakj2ucidmu2w5HsBvpz3ro7Qp8bzPghLuPUOiCHvpIZGrrl96Hk0RhoRe6nqtQOMUFD9iGBiL2JdaqTUG9BC4NgbUjMp4lQYjnFUbFGL5QC6p2NBdm7HOJnnVr6TPUUe1AdennW72Yih6QtIcWx7p6oZDtQt/FOyQKuZpsW+ms0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from BYAPR02MB5238.namprd02.prod.outlook.com (2603:10b6:a03:71::17)
 by BYAPR02MB5368.namprd02.prod.outlook.com (2603:10b6:a03:71::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.14; Wed, 22 Dec
 2021 22:49:45 +0000
Received: from BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07]) by BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07%5]) with mapi id 15.20.4801.023; Wed, 22 Dec 2021
 22:49:45 +0000
From:   Tyler Wear <twear@quicinc.com>
To:     Yonghong Song <yhs@fb.com>,
        "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "kafai@fb.com" <kafai@fb.com>, "maze@google.com" <maze@google.com>
Subject: RE: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Thread-Topic: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Thread-Index: AQHX9tuyjzikyJjagEKGz1loPsx8d6w93owAgAE+o3A=
Date:   Wed, 22 Dec 2021 22:49:45 +0000
Message-ID: <BYAPR02MB52384D4B920EE2DB7C6D0F89AA7D9@BYAPR02MB5238.namprd02.prod.outlook.com>
References: <20211222022737.7369-1-quic_twear@quicinc.com>
 <1bb2ac91-d47c-82c2-41bd-cad0cc96e505@fb.com>
In-Reply-To: <1bb2ac91-d47c-82c2-41bd-cad0cc96e505@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quicinc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8b30fe2-1072-4f4b-6d9c-08d9c59d59d3
x-ms-traffictypediagnostic: BYAPR02MB5368:EE_
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR02MB536810903403095A6B766054AA7D9@BYAPR02MB5368.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WTvdPIRBRsJGdxyrW3r3e59zzL/eAriPxbeJjeHm20z6QY57i4K/n7jF010846+cxseVNSgNf8Lrdlw36T2iE2WHgiOPoyyoxXMtolniHFxXS6LbiLMgWo7DPmVLsejdS/hdre9/lxorGUIfYuZ5qGYrNHPA7RMJvjh4xIy2NjhA4lAlpenyLF0AQVpqHzPiuIPxAjFfJCfWDpFr/RSMQxbh3TGrb4VzXmclG/iKOgqILSS2pvzbNapBC5i2RFaLjs7SNNMDMRogWgIlHDhXPyfk+0LekftEiB2kSM/X6DlAT2PNxRvqYHgTbgXCQdrnsO4+EW7bKuh0sZOUOATGZ2J7dnCAOwZ2B964NifcqhEDuZr7IUrbTBHFOmkPkEVNyY22FqEkq7WhwjsIduBPoEleXqs4v3LlWp2rG/LdchlEVEQnGo97ozrGjCamy6poOD9jMXTgubRhyjc6G1xSduzlJRKfiR1pOk2mTh3veXdq/9wBxpakH/tZX15fRzun2dL3azoilJ0A6SSuTeo8THBwLRwGJ3vWvT2YSLueO6jMiBunC9U+EOreVe/mVCfKrEAJbrUE904N1asG7uQznDk+QUwXj1O6t0EHhd6MqTtpjNTX0bAfJmmrCo+BsLO0pYUyORl4CGqyV3K8wOqtnx8U1HvcGRW2e4ghetMIW51BcP/cheqHB5oN1IF3MdVJHFxzF4w1QZQJGifjw8X0Qg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5238.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(38100700002)(53546011)(26005)(38070700005)(186003)(6506007)(76116006)(122000001)(86362001)(66446008)(7696005)(64756008)(66476007)(66556008)(2906002)(66946007)(33656002)(52536014)(9686003)(5660300002)(55016003)(83380400001)(8676002)(316002)(110136005)(54906003)(8936002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TU5LbXBMOXZTTmpuQ2NPTlNXanI4VHU4c3lISkFtU1dONVB1Ym9rVytqUEJR?=
 =?utf-8?B?SE5IWkF6RjdpNTJJSmVVUkh6UHF1MEl5ZmxHdHo2K3NhOWVDL1d3T3FuclZI?=
 =?utf-8?B?SDRBdjZDL3pLN1JxSHFIdkZrVXo2S044UGNOY2VEUjZMN2RVNmFrNUpaci9S?=
 =?utf-8?B?emZ2VWljUWF3SEc1a2FXNmF4U0p4dFlTTTI5UXg4bEgrdWo5VzZUS3EvTEdn?=
 =?utf-8?B?K1lnVmQycmNFMFAzellDanYwVUpCOGNsQXRTWWtlNmVFdnEyNE9GMDluU3Ex?=
 =?utf-8?B?dmE1TU9MbStra0l6TE01VkJQZ0VMRUVsbXpGWkJlYnZGRWRxWTFMRTlRNHV5?=
 =?utf-8?B?QTVkYWtOdmRydmxyRlpDRU5TNk01NnN3cTRZZDVWU1E1Z0JweE9LVmZMaDhs?=
 =?utf-8?B?eGNPR0VLWTBUNHZBV0xybFJDU01RajlDRmJXNGova0lsTDl2YmpmaHhNUFpv?=
 =?utf-8?B?NUxzRnk2KzJOQ3E2eHRsZGJyM1kxTnJ6eTNwUlFJZWJVbGY2eGVTQW1tQXcv?=
 =?utf-8?B?bW8xbUNTTG92Ri9sS3Bma2VDTWZwTG1aYm5icHpVVFY3dWpzUDgreitMY3ky?=
 =?utf-8?B?ditiWVFTSmtSamJFcmhyUFN1cHJEQ3VvV1QweGdqSUF1b3ZQSHJDUzMxdEs1?=
 =?utf-8?B?WVFnUE5HR1BQT0Rwa0NlUFBFa1Uva2Z5a0pndGFLK05jSzhuY2d0dElNdkdQ?=
 =?utf-8?B?ejlZYkxOck5ocEdNQ0ZSTnV3b0pubFVMN0Fmc3NReGVDZElBUmtOUWtoYkFW?=
 =?utf-8?B?YWx6bFNyTWVkQVhoOWt3bHlDNlhveGxPVkpWaFhYMGlFSE90aG1QT1lyTWNi?=
 =?utf-8?B?eFhTRTFuRWlpL1k3U1Q1Q3d5dkFmanpOYWpzVm5KYU42bU9sN3VZK3V1akti?=
 =?utf-8?B?WGp1UHdDRjFsRmVOQVIyOE0xODFUNlpZM3NmV0FBQTlTQStsM0FOZ21xTDZk?=
 =?utf-8?B?NWhzVDhZcWN5S01nVjQ4bFhBRDNnUU5JK2sxVjRjYS9aVm54OFhkbjMzRHBa?=
 =?utf-8?B?dTlvQlgyMEhuTFl0MVFiZ1R6bFRrYWx6bkRudjVNY3hwaGl1MUhiK0pha1FJ?=
 =?utf-8?B?V1p5VkNOZ3V0dk1hdFpsbVFKUjVWeU5Sc1dZeDNMZVN4a3BFTVhDNzVpQ2Q2?=
 =?utf-8?B?SDMyRSsxT0QzNm9nVnRhTHVhbitEZ05UMW9iWjNDMTNVcGZFbVBGTTRJODd4?=
 =?utf-8?B?SmlZUFFkUVJaQUlFK0dkSnBiNHFhWmpHME8vcUhuRDVVaExhYkY5WktoZEhL?=
 =?utf-8?B?QVp5cTFRQXpiV21EM1R0bDBHZjgveCtmOXJHNldwZXZYa0pjNFlUUk1NM0FY?=
 =?utf-8?B?SllteVA2bXZiT1VuRXZBYzlwZzVHeG1pQTR2emhvbWt1MHMrNmxSK1h0ZVlZ?=
 =?utf-8?B?OGorZEtNekRab2NkdlBTcDJkWnhYcG5oengxRjdIQTBjNGFoaXYrSGczV0kw?=
 =?utf-8?B?OE4vZ1J1bjJYUGRLWmErb0JYMEQvMldMODNqQlA3NXdpejRudW5BWkwrV3gx?=
 =?utf-8?B?emJqZUlKNEVLdFB1ZjcxVzJtNWc0VUNxeFpHVUoyMDk1ZmNpN0F2bnBIVndH?=
 =?utf-8?B?RkJpZFFzdzVIbllGaUdZU1BmL3RqN0QyNDl6SU1IMGdUQjVKbSt4YzVCNXlN?=
 =?utf-8?B?YURSS0s0dkpuT3NndHgzaEVvM0pvQnhXUlNONEVpd2VWTm1kVm5zeHM5QU5E?=
 =?utf-8?B?Rnh1QVhyZVNUWE5uOHNtTDg0bHVqeXNzck9TRWp6ZW9od2l0NWJ3NkZpZzYw?=
 =?utf-8?B?UGpOMFI2am1reHYxY2pYYmlTR3lIOU1qeWNKWC9NMVJiM1NtbzljOEwrcVkx?=
 =?utf-8?B?NWpVSXNHN2t2dHUzcHlCSVA2bTZCSDJ0QVJCUmRhMnFURy9lUE95NzhGTndB?=
 =?utf-8?B?ejU5OU9wOG1CMWJrRGhBYWhBRWRtMnpsZXdpQThpQzBBbzNicmNpOWw4QUox?=
 =?utf-8?B?RlQ3NzY0d292N1hxV3F6dmdoc1Q4cVFKdmNNa1F6TjJOb2psMDNZd09rV2Vy?=
 =?utf-8?B?WVhkSVNmSWFzSlNza3I0c1hObGMxcE1lbmtBTEhLc1FrZGNiT1hNYjMwVVpt?=
 =?utf-8?B?SUJoWll2dy9jTEcxa1ZNRVBwMmNIcGFyaFZuLzJwZUdMd2FTczg4OG5zQkZw?=
 =?utf-8?B?bVYwT3VDTHVCczAzWnBNL3M5b0xCTGZoZ1Z5R2d1MDNhaDFrSFNhL25hdkxk?=
 =?utf-8?B?R0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5238.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b30fe2-1072-4f4b-6d9c-08d9c59d59d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2021 22:49:45.6107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AU3u6YR2/FUUuJ3rXWke702VCy73mDm/DlOb0eh/vxWU5T9kTvlx/LvEzBobZTLy5I9HuGruGU0a35MblWbf+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5368
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAxMi8yMS8yMSA2OjI3IFBNLCBUeWxlciBXZWFyIHdyb3RlOg0KPiA+IE5lZWQgdG8gbW9k
aWZ5IHRoZSBkcyBmaWVsZCB0byBzdXBwb3J0IHVwY29taW5nIFdpZmkgUW9TIEFsbGlhbmNlDQo+
ID4gc3BlYy4gSW5zdGVhZCBvZiBhZGRpbmcgZ2VuZXJpYyBmdW5jdGlvbiBmb3IganVzdCBtb2Rp
ZnlpbmcgdGhlIGRzDQo+ID4gZmllbGQsIGFkZCBza2Jfc3RvcmVfYnl0ZXMgZm9yIEJQRl9QUk9H
X1RZUEVfQ0dST1VQX1NLQi4gVGhpcyBhbGxvd3MNCj4gPiBvdGhlciBmaWVsZHMgaW4gdGhlIG5l
dHdvcmsgYW5kIHRyYW5zcG9ydCBoZWFkZXIgdG8gYmUgbW9kaWZpZWQgaW4gdGhlDQo+ID4gZnV0
dXJlLg0KPiANCj4gQ291bGQgY2hhbmdlIHRhZyBmcm9tICJbUEFUQ0hdIiB0byAiW1BBVENIIGJw
Zi1uZXh0XSI/DQo+IFBsZWFzZSBhbHNvIGluZGljYXRlIHRoZSB2ZXJzaW9uIG9mIHRoZSBwYXRj
aCwgc28gaW4gdGhpcyBjYXNlLCBpdCBzaG91bGQgYmUgIltQQVRDSCBicGYtbmV4dCB2Ml0iLg0K
PiANCj4gSSB0aGluayB5b3UgY2FuIGFkZCBtb3JlIGNvbnRlbnRzIGluIHRoZSBjb21taXQgbWVz
c2FnZSBhYm91dCB3aHkgZXhpc3RpbmcgYnBmX3NldHNvY2tvcHQoKSB3b24ndCB3b3JrIGFuZCB3
aHkNCj4gQ0dST1VQX1VEUFs0fDZdX1NFTkRNU0cgaXMgbm90IHByZWZlcnJlZC4NCj4gVGhlc2Ug
aGF2ZSBiZWVuIGRpc2N1c3NlZCBpbiB2MSBvZiB0aGlzIHBhdGNoIGFuZCB0aGV5IGFyZSB2YWx1
YWJsZSBmb3IgcGVvcGxlIHRvIHVuZGVyc3RhbmQgZnVsbCBjb250ZXh0IGFuZCByZWFzb25pbmcu
DQo+IA0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogVHlsZXIgV2VhciA8cXVpY190d2VhckBxdWlj
aW5jLmNvbT4NCj4gPiAtLS0NCj4gPiAgIG5ldC9jb3JlL2ZpbHRlci5jIHwgMiArKw0KPiA+ICAg
MSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL25l
dC9jb3JlL2ZpbHRlci5jIGIvbmV0L2NvcmUvZmlsdGVyLmMgaW5kZXgNCj4gPiA2MTAyZjA5M2Q1
OWEuLjBjMjVhYTIyMTJhMiAxMDA2NDQNCj4gPiAtLS0gYS9uZXQvY29yZS9maWx0ZXIuYw0KPiA+
ICsrKyBiL25ldC9jb3JlL2ZpbHRlci5jDQo+ID4gQEAgLTcyODksNiArNzI4OSw4IEBAIHN0YXRp
YyBjb25zdCBzdHJ1Y3QgYnBmX2Z1bmNfcHJvdG8gKg0KPiA+ICAgY2dfc2tiX2Z1bmNfcHJvdG8o
ZW51bSBicGZfZnVuY19pZCBmdW5jX2lkLCBjb25zdCBzdHJ1Y3QgYnBmX3Byb2cgKnByb2cpDQo+
ID4gICB7DQo+ID4gICAgICAgc3dpdGNoIChmdW5jX2lkKSB7DQo+ID4gKyAgICAgY2FzZSBCUEZf
RlVOQ19za2Jfc3RvcmVfYnl0ZXM6DQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gJmJwZl9za2Jf
c3RvcmVfYnl0ZXNfcHJvdG87DQo+IA0KPiBUeXBpY2FsbHkgZGlmZmVyZW50ICdjYXNlJ3MgYXJl
IGFkZGVkIGluIGNocm9ub2xvZ2ljYWwgb3JkZXIgdG8gcGVvcGxlIGNhbiBndWVzcyB3aGF0IGlz
IGFkZGVkIGVhcmxpZXIgYW5kIHdoYXQgaXMgYWRkZWQgbGF0ZXIuIE1heWJlDQo+IGFkZCB0aGUg
bmV3IGhlbHBlciBhZnRlciBCUEZfRlVOQ19wZXJmX2V2ZW50X291dHB1dD8NCj4gDQo+ID4gICAg
ICAgY2FzZSBCUEZfRlVOQ19nZXRfbG9jYWxfc3RvcmFnZToNCj4gPiAgICAgICAgICAgICAgIHJl
dHVybiAmYnBmX2dldF9sb2NhbF9zdG9yYWdlX3Byb3RvOw0KPiA+ICAgICAgIGNhc2UgQlBGX0ZV
TkNfc2tfZnVsbHNvY2s6DQo+IA0KPiBQbGVhc2UgYWRkIGEgdGVzdCBjYXNlIHRvIGV4ZXJjaXNl
IHRoZSBuZXcgdXNhZ2Ugb2YNCj4gYnBmX3NrYl9zdG9yZV9ieXRlcygpIGhlbHBlci4gWW91IG1h
eSBwaWdneSBiYWNrIG9uIHNvbWUgZXhpc3RpbmcgY2dfc2tiIHByb2dzIGlmIGl0IGlzIGVhc2ll
ciB0byBkby4NCg0KV291bGQgaXQgYmUgc3VmZmljaWVudCB0byBjaGFuZ2UgdGhlIGRzY3AgdmFs
dWUgaW4gdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3Rfc29ja19maWVsZHMu
YyB2aWEgYnBmX3NrYl9zdG9yZV9ieXRlcygpDQo=
