Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774D61659FB
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 10:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgBTJRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 04:17:32 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7674 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726756AbgBTJRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 04:17:31 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01K9BQcl012016;
        Thu, 20 Feb 2020 01:17:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=e1UYOS3EXeap/koKdgU5pWfXCJ+2p5IqDrHJQCF26Wo=;
 b=azkdFg7cn2gAHivvDb0l+KhtzNVsx8LMJi94pY+qkQ615iR706kxxIx8y33ou+n9krWr
 q2J9hEsAKaLHmPSt3/WPutBGCh0POzDxFufGixtJkiNjDVH3baiuN5zvCHng6ehuw656
 1hjVwgI20aRxA1zDhkl9+FFUXbXgyGqtEFPMQPp5A4GPZYs3dPm4l2QjuoMUWJyuWsbG
 4ITrHMm8pOiyVnCsCOIGxFBbE541PwR9aogQKXfc/iC74jWwfF9SIaG3HH67ZAqeBdns
 ckUfzRypEn4uUhu74f6MryYa3i3YBo550htCNOR/VFVOR9Ttlm1uvE33dpyl+Nw80WXS Ig== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y8ubheqhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 01:17:18 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Feb
 2020 01:17:17 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.50) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 20 Feb 2020 01:17:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/KX7e+hXYtRPE4Z5AnsOK+4HsKi+xW06eZos0nkBFcGmEn914jxhJ4TIARXaE2tPhrBu04LL2VTwg7UnPpbO5GjVvDIwX/Yd+OAw+NbqL+SE5m8/nGNoLkRkPCfPIYwMd4cDcVDHHWqXaNZbgoWz09F5c9HUPQQF6wGl9VRo0EKhqB+yd7KIR171taQmabi4VGTFE7qoiN3E0/l4hOm4u2TIb5xOd/XdAYQPb+Pe6XrIvvXf0IsxQ6WmDkI5opxzuBBOc4c3gbNLyvUFyDbbUc0DPGamaqpt12ryDC7e90i3GyE0OrzF7ZJsGi689Tuh06tcOeCS5y364+JmFjx9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1UYOS3EXeap/koKdgU5pWfXCJ+2p5IqDrHJQCF26Wo=;
 b=QBuIhZhSGrjxc/+nhR2YS4my5YQsYmPilvT1znXIhnW+JMewL8goKoUBh0wHCAc2XDMECfGWD8UGppljOGxMatcNsN5rrVjeGKVhd8hsuJD4ROAT75s5UQ/CoddQx2LO8M6BmlKUOiWbmRpPbf3N6kTbjZhY36lA32W+3hQ8kAFPgFtoXWZ0EZbj7tx2CeqdGFXqNX6eWHhBkEhH6VDN95CZKd3kHSWePoQI2WzMfy1zpIqPbBzUl+G9BbU9dsAJKWqEkPNrp75b+WrRhCZm6z/QbVaz5udf+zmTakz46vM0DPs2Pwq7s2ud/WnglxTeyyOL1xfZVR7C9ZxOOb8Wtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e1UYOS3EXeap/koKdgU5pWfXCJ+2p5IqDrHJQCF26Wo=;
 b=OFFXnTorimRqPyTGBeC6XfZdoBGjpBUrr25R2q89GkWjdxlbH/N3ZHye/96ERVQ1W71EjzSh5TCfTYnWsVDqSTes3dQRU5jsS9osNQ5sDoeDyTQW51j0KkhMLSS0xaG/9zPUFDq4/3vO1X3oCgm90g0i6hl3lUbBsJopWF4d+SI=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB3421.namprd18.prod.outlook.com (10.255.238.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Thu, 20 Feb 2020 09:17:14 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::f03e:3f60:650a:4d56]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::f03e:3f60:650a:4d56%5]) with mapi id 15.20.2729.033; Thu, 20 Feb 2020
 09:17:14 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "it+linux-netdev@molgen.mpg.de" <it+linux-netdev@molgen.mpg.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [EXT] Re: bnx2x: Latest firmware requirement breaks no regression
 policy
Thread-Topic: [EXT] Re: bnx2x: Latest firmware requirement breaks no
 regression policy
Thread-Index: AQHV5ZS7DZVeCVVRU0OIrjv7PCOj3qgiLvOwgABKWQCAAQXBAA==
Date:   Thu, 20 Feb 2020 09:17:14 +0000
Message-ID: <MN2PR18MB2528EC91E410FD1BE9FC3EF5D3130@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <ffbcf99c-8274-eca1-5166-efc0828ca05b@molgen.mpg.de>
 <MN2PR18MB2528C681601B34D05100DF89D3100@MN2PR18MB2528.namprd18.prod.outlook.com>
 <8daadcd1-3ff2-2448-7957-827a71ae4d2e@molgen.mpg.de>
In-Reply-To: <8daadcd1-3ff2-2448-7957-827a71ae4d2e@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2401:4900:368a:58dd:ad19:6b8c:21d3:e066]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2477267-c539-465f-824a-08d7b5e5ac81
x-ms-traffictypediagnostic: MN2PR18MB3421:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3421840ABAE6B19A0C7B311DD3130@MN2PR18MB3421.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(189003)(199004)(7696005)(52536014)(8936002)(186003)(8676002)(81166006)(81156014)(71200400001)(55016002)(6636002)(9686003)(53546011)(6506007)(316002)(5660300002)(966005)(66946007)(66446008)(64756008)(110136005)(66556008)(2906002)(66476007)(33656002)(478600001)(4326008)(86362001)(76116006)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3421;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DVlWFHfPa+NXL2LLjghQbVcaOZnZcxEgyTBSU+TakElEarmrGU54K7XHx4ZikcKpxgBJ4qPT7+tOsaTcy1CvSxBvhWf9+EYYRjPLszAdMNQyhtddN7m4vFCaa5gAx00Ukb7IeLzDVtfBxdXT/3g0RGSNlXM5efpQcscYkIy2ZsXgfrmYfC7ZXo5H0jwL5spmfYrjY/GOoZFzYMtuYkSIpZRwplIH3kpp4cEyRBks0zuOyds8cI9NL3iued34XchB5hvdgSrrr8A0rszryKKSBVZ6qXjtRmJagPJil/qR0YoFxYl0YO0lTZrsn6pXy6oyb7mf8PAgBdpfp9J9jHxlVt5iV+fOE9tiKH2nkOM/5fBziwwIDdUmXWvWyeDq6DDGjw2Yxjddbhq9n3D9pqy9mTMGH7S5zTc97ZdHVC/opdBhRjJUF4E9UT36QLcWJJ/3gCEfNGl2VBo227r9iBwheyW1fSKly8vFIsfmjpvsxEBRTQ1+lNtza1RTmTArKknC3VAWq4ZgZxWMRr/zrKbwxA==
x-ms-exchange-antispam-messagedata: 6QE5zN9ut1e6pSe/ofHGs3kD4qi2iKJrtGGjkYo5dpdrQ56oHsHekuGyA9+mZ1DziYUf9VsZPQTnHs3e/ZmPniVUxB8JFCbLY1YclBdEOCcynpr/J5LJm7J0uW5OF8HPa1jg99WhAajxfyjzyhCvWeJNiZMXvrJcvM8ahw2HgBemi1tpNH5zQIDwtVi+KI8zIuPU0D/Ten6O2yAqzVpOWw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f2477267-c539-465f-824a-08d7b5e5ac81
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 09:17:14.0622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kKiacTeJngMyCLqcjC5WtLpl0ffq4VwpUq77zIfO5nt995JUBokNbP2qta23VSS13IodcZh7JV5ED+nCIsui9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3421
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_02:2020-02-19,2020-02-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGF1bCwNCiAgICBCbngyeCBkcml2ZXIgYW5kIHRoZSBzdG9ybSBGVyBhcmUgdGlnaHRseSBj
b3VwbGVkLCBhbmQgdGhlIGluZm8gaXMgZXhjaGFuZ2VkIGJldHdlZW4gdGhlbSB2aWEgc2htZW0g
KGkuZS4sIGNvbW1vbiBzdHJ1Y3R1cmVzIHdoaWNoIG1pZ2h0IGNoYW5nZSBiZXR3ZWVuIHRoZSBy
ZWxlYXNlcykuIEFsc28sIEZXIHByb3ZpZGVzIHNvbWUgb2Zmc2V0IGFkZHJlc3NlcyB0byB0aGUg
ZHJpdmVyIHdoaWNoIGNvdWxkIGNoYW5nZSBiZXR3ZWVuIHRoZSBGVyByZWxlYXNlcywgZm9sbG93
aW5nIGlzIG9uZSBzdWNoIGNvbW1pdCwNCglodHRwczovL3d3dy5zcGluaWNzLm5ldC9saXN0cy9u
ZXRkZXYvbXNnNjA5ODg5Lmh0bWwNCkhlbmNlIGl0J3Mgbm90IHZlcnkgc3RyYWlnaHQgZm9yd2Fy
ZCB0byBwcm92aWRlIHRoZSBiYWNrd2FyZCBjb21wYXRpYmlsaXR5IGkuZS4sIG5ld2VyICh1cGRh
dGVkKSBrZXJuZWwgZHJpdmVyIHdpdGggdGhlIG9sZGVyIEZXLg0KQ3VycmVudGx5IHdlIGRvbuKA
mXQgaGF2ZSBwbGFucyB0byBpbXBsZW1lbnQgdGhlIG5ldyBtb2RlbCBtZW50aW9uZWQgYmVsb3cu
DQoNClRoYW5rcywNClN1ZGFyc2FuYQ0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBG
cm9tOiBQYXVsIE1lbnplbCA8cG1lbnplbEBtb2xnZW4ubXBnLmRlPg0KPiBTZW50OiBXZWRuZXNk
YXksIEZlYnJ1YXJ5IDE5LCAyMDIwIDY6MTQgUE0NCj4gVG86IFN1ZGFyc2FuYSBSZWRkeSBLYWxs
dXJ1IDxza2FsbHVydUBtYXJ2ZWxsLmNvbT47IEFyaWVsIEVsaW9yDQo+IDxhZWxpb3JAbWFydmVs
bC5jb20+OyBHUi1ldmVyZXN0LWxpbnV4LWwyIDxHUi1ldmVyZXN0LWxpbnV4LQ0KPiBsMkBtYXJ2
ZWxsLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IExLTUwgPGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmc+OyBpdCtsaW51eC0NCj4gbmV0ZGV2QG1vbGdlbi5tcGcuZGU7IERh
dmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4gU3ViamVjdDogW0VYVF0gUmU6
IGJueDJ4OiBMYXRlc3QgZmlybXdhcmUgcmVxdWlyZW1lbnQgYnJlYWtzIG5vIHJlZ3Jlc3Npb24N
Cj4gcG9saWN5DQo+IA0KPiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBE
ZWFyIFN1ZGFyc2FuYSwNCj4gDQo+IA0KPiBUaGFuayB5b3UgZm9yIHlvdXIgcmVwbHkuDQo+IA0K
PiANCj4gT24gMjAyMC0wMi0xOSAwOTo0OSwgU3VkYXJzYW5hIFJlZGR5IEthbGx1cnUgd3JvdGU6
DQo+IA0KPiA+IFRoZSBmaXJtd2FyZSBmaWxlIHJlZmVycmVkIGJlbG93IChpLmUuLCBzdG9ybSBG
Vykgc2hvdWxkIGJlIHByZXNlbnQNCj4gPiBvbiB0aGUgaG9zdCAoaS5lLiwgL2xpYi9maXJtd2Fy
ZS9ibngyeC8gcGF0aCksIG5vdCB0aGUgZGV2aWNlLiBEcml2ZXINCj4gPiBtdXN0IHJlcXVpcmUg
dGhpcyB2ZXJzaW9uIG9mIHRoZSBGVyB0byBpbml0aWFsaXplIHRoZSBkZXZpY2UsIGFuZA0KPiA+
IGhlbmNlIHByb3ZpZGUgdGhlIG5ldHdvcmsgZnVuY3Rpb25hbGl0eS4gQWxzbywgdGhlIGRyaXZl
ciBpcyBub3QNCj4gPiBiYWNrd2FyZCBjb21wYXRpYmxlIHdpdGggb2xkZXIgRlcgdmVyc2lvbnMu
DQo+ID4NCj4gPiBTbyBpdCdzIG5vdCBwb3NzaWJsZSB0byBoYW5kbGUgdGhlIGJlbG93IGVycm9y
IHNjZW5hcmlvIGluIHRoZSBkcml2ZXIsDQo+ID4NCj4gPiAJPiAgICAgYm54MnggMDAwMDo0MTow
MC4wOiBEaXJlY3QgZmlybXdhcmUgbG9hZCBmb3IgYm54MngvYm54MngtZTFoLQ0KPiA3LjEzLjEx
LjAuZncgZmFpbGVkIHdpdGggZXJyb3IgLTINCj4gPiAJPiAgICAgYm54Mng6IFtibngyeF9pbml0
X2Zpcm13YXJlOjEzNTU3KG5ldDAyKV1DYW4ndCBsb2FkIGZpcm13YXJlIGZpbGUNCj4gYm54Mngv
Ym54MngtZTFoLTcuMTMuMTEuMC5mdw0KPiA+DQo+ID4gQXQgdGhlIG1vc3QsIHdlIGNhbiB2YWxp
ZGF0ZSB0aGUgZXhpc3RlbmNlIG9mIEZXIGZpbGUgb24gdGhlIGhvc3QNCj4gPiBkdXJpbmcgdGhl
IGtlcm5lbCBidWlsZCBvciBpbnN0YWxsYXRpb24uDQo+IA0KPiBUaGF0IGlzIHdoYXQgSSB0aG91
Z2h0IGFib3V0IHRoZSBjdXJyZW50IHN0YXRlLiBCdXQgd2h5IHdhcyB0aGlzDQo+IGRlc2lnbiBk
ZWNpc2lvbiBtYWRlPyBJdOKAmXMgbm90IHVzZXItZnJpZW5kbHksIGFuZCBhcyB3cml0dGVuIGJy
ZWFrcw0KPiB0aGUgbm8gcmVncmVzc2lvbiBwb2xpY3kuIFVzZXJzIGNhbiB1cGRhdGUgdGhlIExp
bnV4IGtlcm5lbCB3aXRob3V0DQo+IGFueSByZWdyZXNzaW9ucywgYW5kIGV2ZXJ5dGhpbmcgd29y
a2luZyBhcyBiZWZvcmUuIERhdmUsIHdoYXQgaXMNCj4geW91ciBvcGluaW9uPw0KPiANCj4gV2hl
cmUgYXJlIHRoZSBkcml2ZXIgcmVxdWlyZW1lbnRzL2ltcGxlbWVudGF0aW9uIHNob3J0LWNvbWlu
Z3MNCj4gZG9jdW1lbnRlZD8NCj4gDQo+IElmIGFuIG9sZGVyIExpbnV4IGtlcm5lbCB3b3JrcyB3
aXRoIGEgY2VydGFpbiBmaXJtd2FyZSB2ZXJzaW9uLCB3aHkNCj4gc2hvdWxkbuKAmXQgYSBuZXdl
ciBMaW51eCBrZXJuZWwgd29yayB3aXRoIHRoYXQgZmlybXdhcmUgdmVyc2lvbi4NCj4gTWF5YmUg
c29tZSBmZWF0dXJlcyBhcmUgbWlzc2luZywgYnV0IGF0IGxlYXN0IEkgc2hvdWxkIGdldCB0aGUg
c2FtZQ0KPiBzdGF0ZSBhcyB3aXRoIHRoZSBvbGRlciB2ZXJzaW9uLg0KPiANCj4gRG8geW91IGhh
dmUgcGxhbnMgdG8gc3dpdGNoIHRoZSBkcml2ZXIgdG8gYSBtb2RlbCwgd2hlcmUgdGhlDQo+IGZl
YXR1cmVzL3JlcXVpcmVtZW50cyBvZiB0aGUgZmlybXdhcmUgYXJlIHF1ZXJpZWQgYnkgdGhlIGRy
aXZlciwgc28NCj4gb2xkZXIgdmVyc2lvbnMgY2FuIGJlIHN1cHBvcnRlZD8NCj4gDQo+ID4gRlcg
aW1hZ2UgbmFtZSBmcm9tIGRyaXZlciBzb3VyY2VzOg0KPiA+IAlkcml2ZXJzL25ldC9ldGhlcm5l
dC9icm9hZGNvbS9ibngyeC9ibngyeF9tYWluLmM6DQo+ID4gCSNkZWZpbmUgRldfRklMRV9OQU1F
X0UxICAgICAgICAgImJueDJ4L2JueDJ4LWUxLSIgRldfRklMRV9WRVJTSU9ODQo+ICIuZnciDQo+
ID4gCSNkZWZpbmUgRldfRklMRV9OQU1FX0UxSCAgICAgICAgImJueDJ4L2JueDJ4LWUxaC0iDQo+
IEZXX0ZJTEVfVkVSU0lPTiAiLmZ3Ig0KPiA+IAkjZGVmaW5lIEZXX0ZJTEVfTkFNRV9FMiAgICAg
ICAgICJibngyeC9ibngyeC1lMi0iIEZXX0ZJTEVfVkVSU0lPTg0KPiAiLmZ3Ig0KPiA+IEZXIGlt
YWdlIHBhdGggb24gdGhlIGhvc3Q6DQo+ID4gCS9saWIvZmlybXdhcmUvYm54MngvYm54MngtZTFo
LTcuMTMuMTEuMC5mdw0KPiBZZXMsIHRoYXQgaXMgd2hhdCBJIGZvdW5kIGluIG15IG9yaWdpbmFs
IHJlc2VhcmNoLCBhbmQgdGhhdCBpcyBob3cNCj4gd2UgZml4ZWQgaXQsIGJ1dCB3aXRoIHRoZSBu
b24td29ya2luZyBpbnRlcmZhY2UgaXQgd2FzIG1vcmUgd29yaw0KPiB0aGFuIG5lY2Vzc2FyeS4N
Cj4gDQo+IA0KPiBLaW5kIHJlZ2FyZHMsDQo+IA0KPiBQYXVsDQoNCg==
