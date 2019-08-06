Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0E88286B
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 02:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbfHFALs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 20:11:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58774 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728851AbfHFALr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 20:11:47 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7605ELi022449;
        Mon, 5 Aug 2019 17:11:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=FHtmwPH78/JI4m9zx+PMMwKwh5LffZRFlh0h3Gh571w=;
 b=iCysJnlp0XW08hEg4TAeT++z6uuZENOrt8OYfR1A/tzIR3lG7N0XFVVS62U1sX5NvbEK
 iOW8h3jqXkUY1ua4SW5SyyjbBp1SSAcJsnq4+g6D73DKqK+evKMVR/MGSc59lSw8SYuT
 u2BRqKLKwTEGCTG/pHpdIEBQTFjL5bZRN7E= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u6vhs8e9a-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 05 Aug 2019 17:11:31 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 5 Aug 2019 17:11:21 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 5 Aug 2019 17:11:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CSp6gC5iJAx9CbmexkpZZEzvimVTgtk0EiVw+JnOFnWGbW++MlnjOec6ndFAKtr/xDl0n8DPua/Vtd2Djxn2TwmkTko2eVmPikXM4OL7oxLDTyT0zuVRZ5BiSW1d1aCoHwErCxe8Yul/wHzQL3wWnkSKN/aHEIbDgPvsNokuBGpeVeVYSvK01/fmFmElR0r3mu82wfffQ034ES3xO/L9mGsVs6a8QfpALjUZZRpZOhbGzyLV9yohzx/VgcblM8ujC3ScJadGI0NI30NHc9YqyX7/muo8CtXLsil6y/V1vHzXHkOgd4bdLKfuAciXlzlne3SQNUbZisXE4qC4uJTG9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FHtmwPH78/JI4m9zx+PMMwKwh5LffZRFlh0h3Gh571w=;
 b=Wkg5cjD7Ocg02low+0aJr8KpZW2BQTamTG5sG13Ff16JTtxr9xf9NjXJnQDHbEZrazwzTBabZlhAvbucerrW1rgWMz8YYVw5DiNBS8wkn+T9SfmBKkTtlOBC/7dLB4fzYDnrxbI4GJ1Eu4uspj87LrPsVUKO8+OWXg456nkxjqlh3sRgRhmYiBC2r65ie3Au3e8ofmfUCY3tRLlU+VueE4pcCZ/Uyzo/FZW59sbVxyHD1OHaMAn4EQ/n4DC2sGY0uVlswXaaLA3/v4ll0jy2Q8tWx3C/mPsdl1IBBavWoN9S3vcjMA5nSPMZqjOLKEbzhylgy0JvULAd/bo0qKJRPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FHtmwPH78/JI4m9zx+PMMwKwh5LffZRFlh0h3Gh571w=;
 b=AY0Ohov7IO0TNDiB1sTbUE7by82Salae9P97nKAXHsIcgTATqJD2jxgv+Fv8Lw4aRzIUjH3M9goZ+jGzelzpPaTP9B7mwOjSR/4C5UGE1VNyPQq8W3VzHFm0C4h4SdzRpoG8sk90mZd9ataRDuMjaPxkEJ7mq5p1UWm/WDw1P6Q=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1422.namprd15.prod.outlook.com (10.173.234.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Tue, 6 Aug 2019 00:11:20 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 00:11:20 +0000
From:   Tao Ren <taoren@fb.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v3] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Topic: [PATCH net-next v3] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Index: AQHVSX02YDtqShAJZEiiuBTkPN0xlKbpcXQAgACF6gCAAR30AIAAEvcAgAACBQCAADZ/gIABqYaAgAA5oYA=
Date:   Tue, 6 Aug 2019 00:11:20 +0000
Message-ID: <71899fec-7d75-5ddb-c8e2-57aaeb111482@fb.com>
References: <20190802215419.313512-1-taoren@fb.com>
 <CA+h21hrOEape89MTqCUyGFt=f6ba7Q-2KcOsN_Vw2Qv8iq86jw@mail.gmail.com>
 <53e18a01-3d08-3023-374f-2c712c4ee9ea@fb.com> <20190804145152.GA6800@lunn.ch>
 <CA+h21hrUDaSxKpsy9TuWqwgaxKYaoXHyhgS=xSoAcPwxXzvrHg@mail.gmail.com>
 <f8de2514-081a-0e6e-fbe2-bcafcd459646@gmail.com>
 <CA+h21hov3WzqYSUcxOnH0DOMO2dYdh_Q30Q_GQJpxa4nFM7MsQ@mail.gmail.com>
 <291a3c6e-ca8f-a9b8-a0b8-735a68dc04ea@gmail.com>
In-Reply-To: <291a3c6e-ca8f-a9b8-a0b8-735a68dc04ea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0009.namprd11.prod.outlook.com
 (2603:10b6:301:1::19) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:caa9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8673141e-07cb-4727-402d-08d71a029bb9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1422;
x-ms-traffictypediagnostic: MWHPR15MB1422:
x-microsoft-antispam-prvs: <MWHPR15MB1422085789F00E076152112BB2D50@MWHPR15MB1422.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(39860400002)(376002)(366004)(189003)(199004)(53936002)(8676002)(25786009)(31686004)(76176011)(36756003)(4326008)(8936002)(81166006)(52116002)(81156014)(31696002)(86362001)(65826007)(102836004)(6506007)(386003)(478600001)(53546011)(71190400001)(6116002)(71200400001)(2906002)(14444005)(68736007)(256004)(5024004)(14454004)(64126003)(99286004)(476003)(229853002)(446003)(486006)(46003)(58126008)(65806001)(65956001)(11346002)(2616005)(7416002)(5660300002)(110136005)(305945005)(316002)(7736002)(6512007)(66946007)(64756008)(66476007)(6246003)(66446008)(186003)(54906003)(66556008)(6436002)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1422;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vXGaglXEMNiX279MnvhV8uUltCtZj5431DMbKd3vK+efzVAiG4fc93rUtNmw5nuj4vABi9P99Ku82cM/y3K1IEzSFq5SQ/ogtrewDEM+andkz+y7b/gsLMJ5K0mQkJUV5f4r/aX9xriLPScaA2/wtTNmbe3XbKUu5J1WxZYvmxi5jjK174ZtL2Ge5J5Odg7ZYsSweEh8lgA57lmYmneNUPCtsv3mRDxbjMjL2McAp40wKmuSpqkueBtJUGaC/eCGGJCeKs/IFbBu/OFxrVDBQA0ahhKjX64jj63uMOlyxtiVzjMBwrKRrlhc7rkVizuvwzAtTqu8bqCLikEZZ3YfrRxiI9GvnztYhRAHatUi+8nisEDsQkK0lmco0HRcUIEplyEWbojZg1Or6pBPaHEd4KM6FxUi/6JTN9xyO/KGPMM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <176F53012077724AAD2E7450BA2C0DCD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8673141e-07cb-4727-402d-08d71a029bb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 00:11:20.4328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taoren@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1422
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC81LzE5IDE6NDUgUE0sIEhlaW5lciBLYWxsd2VpdCB3cm90ZToNCj4gT24gMDQuMDguMjAx
OSAyMToyMiwgVmxhZGltaXIgT2x0ZWFuIHdyb3RlOg0KPj4gT24gU3VuLCA0IEF1ZyAyMDE5IGF0
IDE5OjA3LCBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPiB3cm90ZToNCj4+
Pg0KPj4+IE9uIDA0LjA4LjIwMTkgMTc6NTksIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4+Pj4g
T24gU3VuLCA0IEF1ZyAyMDE5IGF0IDE3OjUyLCBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+
IHdyb3RlOg0KPj4+Pj4NCj4+Pj4+Pj4gVGhlIHBhdGNoc2V0IGxvb2tzIGJldHRlciBub3cuIEJ1
dCBpcyBpdCBvaywgSSB3b25kZXIsIHRvIGtlZXANCj4+Pj4+Pj4gUEhZX0JDTV9GTEFHU19NT0RF
XzEwMDBCWCBpbiBwaHlkZXYtPmRldl9mbGFncywgY29uc2lkZXJpbmcgdGhhdA0KPj4+Pj4+PiBw
aHlfYXR0YWNoX2RpcmVjdCBpcyBvdmVyd3JpdGluZyBpdD8NCj4+Pj4+Pg0KPj4+Pj4NCj4+Pj4+
PiBJIGNoZWNrZWQgZnRnbWFjMTAwIGRyaXZlciAodXNlZCBvbiBteSBtYWNoaW5lKSBhbmQgaXQg
Y2FsbHMNCj4+Pj4+PiBwaHlfY29ubmVjdF9kaXJlY3Qgd2hpY2ggcGFzc2VzIHBoeWRldi0+ZGV2
X2ZsYWdzIHdoZW4gY2FsbGluZw0KPj4+Pj4+IHBoeV9hdHRhY2hfZGlyZWN0OiB0aGF0IGV4cGxh
aW5zIHdoeSB0aGUgZmxhZyBpcyBub3QgY2xlYXJlZCBpbiBteQ0KPj4+Pj4+IGNhc2UuDQo+Pj4+
Pg0KPj4+Pj4gWWVzLCB0aGF0IGlzIHRoZSB3YXkgaXQgaXMgaW50ZW5kZWQgdG8gYmUgdXNlZC4g
VGhlIE1BQyBkcml2ZXIgY2FuDQo+Pj4+PiBwYXNzIGZsYWdzIHRvIHRoZSBQSFkuIEl0IGlzIGEg
ZnJhZ2lsZSBBUEksIHNpbmNlIHRoZSBNQUMgbmVlZHMgdG8NCj4+Pj4+IGtub3cgd2hhdCBQSFkg
aXMgYmVpbmcgdXNlZCwgc2luY2UgdGhlIGZsYWdzIGFyZSBkcml2ZXIgc3BlY2lmaWMuDQo+Pj4+
Pg0KPj4+Pj4gT25lIG9wdGlvbiB3b3VsZCBiZSB0byBtb2RpZnkgdGhlIGFzc2lnbm1lbnQgaW4g
cGh5X2F0dGFjaF9kaXJlY3QoKSB0bw0KPj4+Pj4gT1IgaW4gdGhlIGZsYWdzIHBhc3NlZCB0byBp
dCB3aXRoIGZsYWdzIHdoaWNoIGFyZSBhbHJlYWR5IGluDQo+Pj4+PiBwaHlkZXYtPmRldl9mbGFn
cy4NCj4+Pj4+DQo+Pj4+PiAgICAgICAgIEFuZHJldw0KPj4+Pg0KPj4+PiBFdmVuIGlmIHRoYXQg
d2VyZSB0aGUgY2FzZSAocGF0Y2hpbmcgcGh5X2F0dGFjaF9kaXJlY3QgdG8gYXBwbHkgYQ0KPj4+
PiBsb2dpY2FsLW9yIHRvIGRldl9mbGFncyksIGl0IHNvdW5kcyBmaXNoeSB0byBtZSB0aGF0IHRo
ZSBnZW5waHkgY29kZQ0KPj4+PiBpcyB1bmFibGUgdG8gZGV0ZXJtaW5lIHRoYXQgdGhpcyBQSFkg
aXMgcnVubmluZyBpbiAxMDAwQmFzZS1YIG1vZGUuDQo+Pj4+DQo+Pj4+IEluIG15IG9waW5pb24g
aXQgYWxsIGJvaWxzIGRvd24gdG8gdGhpcyB3YXJuaW5nOg0KPj4+Pg0KPj4+PiAiUEhZIGFkdmVy
dGlzaW5nICgwLDAwMDAwMjAwLDAwMDA2MmMwKSBtb3JlIG1vZGVzIHRoYW4gZ2VucGh5DQo+Pj4+
IHN1cHBvcnRzLCBzb21lIG1vZGVzIG5vdCBhZHZlcnRpc2VkIi4NCj4+Pj4NCj4+PiBUaGUgZ2Vu
cGh5IGNvZGUgZGVhbHMgd2l0aCBDbGF1c2UgMjIgKyBHaWdhYml0IEJhc2VUIG9ubHkuDQo+Pj4g
UXVlc3Rpb24gaXMgd2hldGhlciB5b3Ugd2FudCBhbmVnIGF0IGFsbCBpbiAxMDAwQmFzZS1YIG1v
ZGUgYW5kDQo+Pj4gd2hhdCB5b3Ugd2FudCB0aGUgY29uZmlnX2FuZWcgY2FsbGJhY2sgdG8gZG8u
DQo+Pj4gVGhlcmUgbWF5IGJlIHNvbWUgaW5zcGlyYXRpb24gaW4gdGhlIE1hcnZlbCBQSFkgZHJp
dmVycy4NCj4+Pg0KPj4NCj4+IEFOIGZvciAxMDAwQmFzZS1YIHN0aWxsIGdpdmVzIHlvdSBkdXBs
ZXggYW5kIHBhdXNlIGZyYW1lIHNldHRpbmdzLiBJDQo+PiB0aG91Z2h0IHRoZSBiYXNlIHBhZ2Ug
Zm9ybWF0IGZvciBleGNoYW5naW5nIHRoYXQgaW5mbyBpcyBzdGFuZGFyZGl6ZWQNCj4+IGluIGNs
YXVzZSAzNy4NCj4+IERvZXMgZ2VucGh5IGNvdmVyIG9ubHkgY29wcGVyIG1lZGlhIGJ5IGRlc2ln
biwgb3IgaXMgaXQgZGVzaXJhYmxlIHRvDQo+PiBhdWdtZW50IGdlbnBoeV9yZWFkX3N0YXR1cz8N
Cj4+DQo+IFNvIGZhciB3ZSBjYXJlIGFib3V0IGNvcHBlciBvbmx5IGluIHBoeWxpYi4gU29tZSBj
b25zdGFudHMgbmVlZGVkIGZvcg0KPiBDbGF1c2UgMzcgc3VwcG9ydCBhcmUgZGVmaW5lZCwgYnV0
IHVzZWQgYnkgZmV3IGRyaXZlcnMgb25seS4NCj4gDQo+IEFEVkVSVElTRV8xMDAwWEhBTEYNCj4g
QURWRVJUSVNFXzEwMDBYRlVMTA0KPiBBRFZFUlRJU0VfMTAwMFhQQVVTRQ0KPiBBRFZFUlRJU0Vf
MTAwMFhQU0VfQVNZTQ0KPiANCj4gSSB0aGluayBpdCB3b3VsZCBtYWtlIHNlbnNlIHRvIGhhdmUg
c29tZXRoaW5nIGxpa2UgZ2VucGh5X2MzN19jb25maWdfYW5lZy4NCj4gU2ltaWxhciBmb3IgcmVh
ZF9zdGF0dXMuDQoNClRoYW5rIHlvdSBhbGwgZm9yIHRoZSBpbnB1dHMgb24gdGhpcyBwYXRjaC4N
Cg0KSWYgSSB1bmRlcnN0YW5kIGNvcnJlY3RseSwgd2UgYXJlIGdvaW5nIHRvIGNyZWF0ZSBhIHNl
dCBvZiBnZW5waHlfYzM3XyogZnVuY3Rpb25zIGZvciAxMDAweCBzdXBwb3J0IHNvIGl0IGNhbiBi
ZSB1c2VkIGJ5IHBoeSBkcml2ZXJzPyBPciBhcmUgd2UgY29uc2lkZXJpbmcgb3RoZXIgb3B0aW9u
cz8gV2hhdCdzIHlvdXIgcmVjb21tZW5kYXRpb24gb24gdGhpcyBzcGVjaWZpYyBwYXRjaD8NCg0K
DQpUaGFua3MsDQoNClRhbw0K
