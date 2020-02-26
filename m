Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D3416FE20
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 12:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgBZLpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 06:45:40 -0500
Received: from mail-bn8nam11on2044.outbound.protection.outlook.com ([40.107.236.44]:63712
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726408AbgBZLpj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 06:45:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRCSDnkUHnCTMNLNcLYQ1s32T1t5+o2sZruj84bhuq7Q5bg3M5clHcJ/s7TrqobYqUZSvn7aME2azN1xWfmSmnT7p2pc8hdPewQk3EfSIbFMbIumNwbm3QTw7TcZROzYuXRbw4vFMivuG9XsYvjEndnaHQHw4sbDxJIU9C7gWJRrOxZpTgV7R1eQwyZEfkEVorUUoUvIrOpU8a2O8SQ8oSwgqzp6f74Eyl/H6uAtCJbSj9W4Fyt4LjOfHvMr3ChzgSaRSn/tzpNsm1ysTF6iQ6dXDT0khV9pRSXMWADdJL1X/rkwi+AWcvtgUguG1NAwc6hDye0p75TbV3DqcD4qzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0Tx7cla70Wkr8H22Zw/p/rcnoWUa/OGSukspUoawkY=;
 b=Tx2nLzDhOYt7SJvZPcSfkFp95jicVpJmq8Bnb4kq0/ZwVWqiqdUWnKtx8WbsXFk1cYp5zqVzxRIFYTAm2N1TH9ve9QsjtCnjqlwnavYGV+jgOxhK5GUPJY9NJf6/XvFUp0M9dGdq0ymFuNmLKLZPmuf+xepkeKbMIJYHLsJqRI6sispOJpbernUluiJfjBhVpaBqt6d076PL9ZlWYvqn9q8UlYu1iEka7NHVptQg/3Cunr69ZAcmiQZiFcwarKosbpM+FrFDx0bKxR7bJVi/LgRDoR+P7LZ0PbqTqOu8QT3FwDBymFTNWdBMkgL5y0oZkTMdiVS5n8KyUNQMAFPs/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0Tx7cla70Wkr8H22Zw/p/rcnoWUa/OGSukspUoawkY=;
 b=tksybeQ7L4Ycfe6w3FFgEldEUoVbVwumHWzLJi9hqpR8jgyblOJUc7iGWOALEg9rEfbr8LmWk0Mw5zcrU8fp+xkFGIBREqAp2vmbYNm7YEuLZce6rj15SyQOVL3lRsuNgutFhOZZl18kB+ETE5XXZ3vMSaCGQJZ7NBDVxyNZ1Xw=
Received: from SN6PR05MB4237.namprd05.prod.outlook.com (2603:10b6:805:27::32)
 by SN6PR05MB4878.namprd05.prod.outlook.com (2603:10b6:805:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Wed, 26 Feb
 2020 11:45:35 +0000
Received: from SN6PR05MB4237.namprd05.prod.outlook.com
 ([fe80::4da8:aefe:5436:af32]) by SN6PR05MB4237.namprd05.prod.outlook.com
 ([fe80::4da8:aefe:5436:af32%4]) with mapi id 15.20.2772.012; Wed, 26 Feb 2020
 11:45:35 +0000
From:   Rajender M <manir@vmware.com>
To:     Vincent Guittot <vincent.guittot@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Performance impact in networking data path tests in Linux 5.5
 Kernel
Thread-Topic: Performance impact in networking data path tests in Linux 5.5
 Kernel
Thread-Index: AQHV6wVoaIB7e06hTEGauTCQiUGTXKgtPbEAgAB8+QA=
Date:   Wed, 26 Feb 2020 11:45:34 +0000
Message-ID: <A6BD9BBB-B087-4A3C-BF3D-557626AC233A@vmware.com>
References: <C7D5F99D-B8DB-462B-B665-AE268CDE90D2@vmware.com>
 <CAKfTPtA9275amW4wAnCZpW3bVRv0HssgMJ_YgPzZDRZ3A1rbVg@mail.gmail.com>
In-Reply-To: <CAKfTPtA9275amW4wAnCZpW3bVRv0HssgMJ_YgPzZDRZ3A1rbVg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=manir@vmware.com; 
x-originating-ip: [122.182.233.20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fe9a142-b952-42a6-047e-08d7bab1644c
x-ms-traffictypediagnostic: SN6PR05MB4878:
x-microsoft-antispam-prvs: <SN6PR05MB4878D47A82EED633C68E1DCDD6EA0@SN6PR05MB4878.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0325F6C77B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(189003)(199004)(6506007)(6486002)(6916009)(6512007)(2616005)(33656002)(186003)(26005)(2906002)(4326008)(8936002)(478600001)(66946007)(8676002)(66476007)(71200400001)(91956017)(76116006)(64756008)(316002)(66446008)(5660300002)(54906003)(36756003)(81166006)(66556008)(81156014)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR05MB4878;H:SN6PR05MB4237.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s0pGQ5392cuPsBQyxZ+WmOmJK1yMHDaUs6eyNV7FcrNXrYX6zCcjWffO8rd3FayrivZaN0S+zvrO29vK7BdGvbT7LEDFPzfJTizuE97/Z4G146hjUKs5IAoOqwusn5n6HNlgsjqtv8CoVadVSo5GdQQVLp8ntdBzBKRks28Fgrg+ePftLtXTLt2lknio/EtA7gX9x1ks+TA6v8s5oftARGRlihfjuUh+5tfQ/kraxajfw89TJmT4IL69+cN9RqFJZG1YVMENtJYpFMxjQKijiiW9m8Q0HXrESMbcQTpx9+xow1uU2bBC7TQVIP5JeaME21Ec4LADEHf8P+f/qMT5kF0ZUZgCPVB9L4+C6tf87CXiAqLVefIAnqvOAvPIkm/B9iL4wOm16fj9OyMXfadFTFS1UsV5z9cl5igyfHJaOUw2iL5FNiW681VLjNS9TmPI
x-ms-exchange-antispam-messagedata: QZreUTo8l+xvCMP6pYT0Ohnhy4hd74YHuQhLoxBiYmS6Kyamlbp4lz12rfMDGFHo90bx2wfAKBRFxEt4P7fmjvmaj7PbN23ySkPPlB4BsiKfIyfqzubW8zTdwFf9Q85dlY6WhL69MhwF2eiB3Fpgtg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1E3DD18AA4284418EB6F514A941E721@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fe9a142-b952-42a6-047e-08d7bab1644c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2020 11:45:34.8616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J0lWoyYjan5flIiWPqOXi2zkx4N0xNAFF8A+6mHuKXVkD1OZPlh6A2+9hfwVjbR7/bZzZ2qa90cazWdECPqy6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR05MB4878
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIHJlc3BvbnNlLCBWaW5jZW50LiANCkp1c3QgY3VyaW91cyB0byBrbm93
LCBpZiB0aGVyZSBhcmUgYW55IHJvb20gZm9yIG9wdGltaXppbmcgDQp0aGUgYWRkaXRpb25hbCBD
UFUgY29zdC4gDQoNCg0K77u/T24gMjYvMDIvMjAsIDM6MTggUE0sICJWaW5jZW50IEd1aXR0b3Qi
IDx2aW5jZW50Lmd1aXR0b3RAbGluYXJvLm9yZz4gd3JvdGU6DQoNCiAgICBIaSBSYWplbmRlciwN
CiAgICANCiAgICBPbiBUdWUsIDI1IEZlYiAyMDIwIGF0IDA2OjQ2LCBSYWplbmRlciBNIDxtYW5p
ckB2bXdhcmUuY29tPiB3cm90ZToNCiAgICA+DQogICAgPiBBcyBwYXJ0IG9mIFZNd2FyZSdzIHBl
cmZvcm1hbmNlIHJlZ3Jlc3Npb24gdGVzdGluZyBmb3IgTGludXggS2VybmVsIHVwc3RyZWFtDQog
ICAgPiAgcmVsZWFzZXMsIHdoZW4gY29tcGFyaW5nIExpbnV4IDUuNSBrZXJuZWwgYWdhaW5zdCBM
aW51eCA1LjQga2VybmVsLCB3ZSBub3RpY2VkDQogICAgPiAyMCUgaW1wcm92ZW1lbnQgaW4gbmV0
d29ya2luZyB0aHJvdWdocHV0IHBlcmZvcm1hbmNlIGF0IHRoZSBjb3N0IG9mIGEgMzAlDQogICAg
PiBpbmNyZWFzZSBpbiB0aGUgQ1BVIHV0aWxpemF0aW9uLg0KICAgIA0KICAgIFRoYW5rcyBmb3Ig
dGVzdGluZyBhbmQgc2hhcmluZyByZXN1bHRzIHdpdGggdXMuIEl0J3MgYWx3YXlzDQogICAgaW50
ZXJlc3RpbmcgdG8gZ2V0IGZlZWRiYWNrcyBmcm9tIHZhcmlvdXMgdGVzdHMgY2FzZXMNCiAgICAN
CiAgICA+DQogICAgPiBBZnRlciBwZXJmb3JtaW5nIHRoZSBiaXNlY3QgYmV0d2VlbiA1LjQgYW5k
IDUuNSwgd2UgaWRlbnRpZmllZCB0aGUgcm9vdCBjYXVzZQ0KICAgID4gb2YgdGhpcyBiZWhhdmlv
dXIgdG8gYmUgYSBzY2hlZHVsaW5nIGNoYW5nZSBmcm9tIFZpbmNlbnQgR3VpdHRvdCdzDQogICAg
PiAyYWI0MDkyZmM4MmQgKCJzY2hlZC9mYWlyOiBTcHJlYWQgb3V0IHRhc2tzIGV2ZW5seSB3aGVu
IG5vdCBvdmVybG9hZGVkIikuDQogICAgPg0KICAgID4gVGhlIGltcGFjdGVkIHRlc3RjYXNlcyBh
cmUgVENQX1NUUkVBTSBTRU5EICYgUkVDViDigJMgb24gYm90aCBzbWFsbA0KICAgID4gKDhLIHNv
Y2tldCAmIDI1NkIgbWVzc2FnZSkgJiBsYXJnZSAoNjRLIHNvY2tldCAmIDE2SyBtZXNzYWdlKSBw
YWNrZXQgc2l6ZXMuDQogICAgPg0KICAgID4gV2UgYmFja2VkIG91dCBWaW5jZW50J3MgY29tbWl0
ICYgcmVyYW4gb3VyIG5ldHdvcmtpbmcgdGVzdHMgYW5kIGZvdW5kIHRoYXQNCiAgICA+IHRoZSBw
ZXJmb3JtYW5jZSB3ZXJlIHNpbWlsYXIgdG8gNS40IGtlcm5lbCAtIGltcHJvdmVtZW50cyBpbiBu
ZXR3b3JraW5nIHRlc3RzDQogICAgPiB3ZXJlIG5vIG1vcmUuDQogICAgPg0KICAgID4gSW4gb3Vy
IGN1cnJlbnQgbmV0d29yayBwZXJmb3JtYW5jZSB0ZXN0aW5nLCB3ZSB1c2UgSW50ZWwgMTBHIE5J
QyB0byBldmFsdWF0ZQ0KICAgID4gYWxsIExpbnV4IEtlcm5lbCByZWxlYXNlcy4gSW4gb3JkZXIg
dG8gY29uZmlybSB0aGF0IHRoZSBpbXBhY3QgaXMgYWxzbyBzZWVuIGluDQogICAgPiBoaWdoZXIg
YmFuZHdpZHRoIE5JQywgd2UgcmVwZWF0ZWQgdGhlIHNhbWUgdGVzdCBjYXNlcyB3aXRoIEludGVs
IDQwRyBhbmQNCiAgICA+IHdlIHdlcmUgYWJsZSB0byByZXByb2R1Y2UgdGhlIHNhbWUgYmVoYXZp
b3VyIC0gMjUlIGltcHJvdmVtZW50cyBpbg0KICAgID4gdGhyb3VnaHB1dCB3aXRoIDEwJSBtb3Jl
IENQVSBjb25zdW1wdGlvbi4NCiAgICA+DQogICAgPiBUaGUgb3ZlcmFsbCByZXN1bHRzIGluZGlj
YXRlIHRoYXQgdGhlIG5ldyBzY2hlZHVsZXIgY2hhbmdlIGhhcyBpbnRyb2R1Y2VkDQogICAgPiBt
dWNoIGJldHRlciBuZXR3b3JrIHRocm91Z2hwdXQgcGVyZm9ybWFuY2UgYXQgdGhlIGNvc3Qgb2Yg
aW5jcmVtZW50YWwNCiAgICA+IENQVSB1c2FnZS4gVGhpcyBjYW4gYmUgc2VlbiBhcyBleHBlY3Rl
ZCBiZWhhdmlvciBiZWNhdXNlIG5vdyB0aGUNCiAgICA+IFRDUCBzdHJlYW1zIGFyZSBldmVubHkg
c3ByZWFkIGFjcm9zcyBhbGwgdGhlIENQVXMgYW5kIGV2ZW50dWFsbHkgZHJpdmVzDQogICAgPiBt
b3JlIG5ldHdvcmsgcGFja2V0cywgd2l0aCBhZGRpdGlvbmFsIENQVSBjb25zdW1wdGlvbi4NCiAg
ICA+DQogICAgPg0KICAgID4gV2UgaGF2ZSBhbHNvIGNvbmZpcm1lZCB0aGlzIHRoZW9yeSBieSBw
YXJzaW5nIHRoZSBFU1ggc3RhdHMgZm9yIDUuNCBhbmQgNS41DQogICAgPiBrZXJuZWxzIGluIGEg
NHZDUFUgVk0gcnVubmluZyA4IFRDUCBzdHJlYW1zIC0gYXMgc2hvd24gYmVsb3c7DQogICAgPg0K
ICAgID4gNS40IGtlcm5lbDoNCiAgICA+ICAgIjIxMzIxNDkiOiB7ImlkIjogMjEzMjE0OSwgInVz
ZWQiOiA5NC4zNywgInJlYWR5IjogMC4wMSwgImNzdHAiOiAwLjAwLCAibmFtZSI6ICJ2bXgtdmNw
dS0wOnJoZWw3eDY0LTAiLA0KICAgID4gICAiMjEzMjE1MSI6IHsiaWQiOiAyMTMyMTUxLCAidXNl
ZCI6IDAuMTMsICJyZWFkeSI6IDAuMDAsICJjc3RwIjogMC4wMCwgIm5hbWUiOiAidm14LXZjcHUt
MTpyaGVsN3g2NC0wIiwNCiAgICA+ICAgIjIxMzIxNTIiOiB7ImlkIjogMjEzMjE1MiwgInVzZWQi
OiA5LjA3LCAicmVhZHkiOiAwLjAzLCAiY3N0cCI6IDAuMDAsICJuYW1lIjogInZteC12Y3B1LTI6
cmhlbDd4NjQtMCIsDQogICAgPiAgICIyMTMyMTUzIjogeyJpZCI6IDIxMzIxNTMsICJ1c2VkIjog
MzQuNzcsICJyZWFkeSI6IDAuMDEsICJjc3RwIjogMC4wMCwgIm5hbWUiOiAidm14LXZjcHUtMzpy
aGVsN3g2NC0wIiwNCiAgICA+DQogICAgPiA1LjUga2VybmVsOg0KICAgID4gICAiMjEzMjA0MSI6
IHsiaWQiOiAyMTMyMDQxLCAidXNlZCI6IDU1LjcwLCAicmVhZHkiOiAwLjAxLCAiY3N0cCI6IDAu
MDAsICJuYW1lIjogInZteC12Y3B1LTA6cmhlbDd4NjQtMCIsDQogICAgPiAgICIyMTMyMDQzIjog
eyJpZCI6IDIxMzIwNDMsICJ1c2VkIjogNDcuNTMsICJyZWFkeSI6IDAuMDEsICJjc3RwIjogMC4w
MCwgIm5hbWUiOiAidm14LXZjcHUtMTpyaGVsN3g2NC0wIiwNCiAgICA+ICAgIjIxMzIwNDQiOiB7
ImlkIjogMjEzMjA0NCwgInVzZWQiOiA3Ny44MSwgInJlYWR5IjogMC4wMCwgImNzdHAiOiAwLjAw
LCAibmFtZSI6ICJ2bXgtdmNwdS0yOnJoZWw3eDY0LTAiLA0KICAgID4gICAiMjEzMjA0NSI6IHsi
aWQiOiAyMTMyMDQ1LCAidXNlZCI6IDU3LjExLCAicmVhZHkiOiAwLjAyLCAiY3N0cCI6IDAuMDAs
ICJuYW1lIjogInZteC12Y3B1LTM6cmhlbDd4NjQtMCIsDQogICAgPg0KICAgID4gTm90ZSwgInVz
ZWQgJSIgaW4gYWJvdmUgc3RhdHMgZm9yIDUuNSBrZXJuZWwgaXMgZXZlbmx5IGRpc3RyaWJ1dGVk
IGFjcm9zcyBhbGwgdkNQVXMuDQogICAgPg0KICAgID4gT24gdGhlIHdob2xlLCB0aGlzIGNoYW5n
ZSBzaG91bGQgYmUgc2VlbiBhcyBhIHNpZ25pZmljYW50IGltcHJvdmVtZW50IGZvcg0KICAgID4g
bW9zdCBjdXN0b21lcnMuDQogICAgPg0KICAgID4gUmFqZW5kZXIgTQ0KICAgID4gUGVyZm9ybWFu
Y2UgRW5naW5lZXJpbmcNCiAgICA+IFZNd2FyZSwgSW5jLg0KICAgID4NCiAgICANCg0K
