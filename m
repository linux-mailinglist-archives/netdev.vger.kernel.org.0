Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC96686CB3
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 23:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390303AbfHHVs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 17:48:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725785AbfHHVs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 17:48:26 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78Llb4k012524;
        Thu, 8 Aug 2019 14:48:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1WF+U5+c8pRtcQvNq8nL/iiiA1l5vRJCJtjgwRxgfeI=;
 b=M/B1saymQkuVFb8j6F8XbMmFRG/dbj8035P2wIg1Qif/sGVzci9dEIViybiqyAS16b7f
 DXvBqJlDh2fM2cu5Uiqmq6FlLoK9TVsaeOuWdbNYc4SXRWKlE40IiD+tAm96LASUkDU9
 6BpfnBwltqnVvi59Pyy9rnMNQAd3hABv/RA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2u8p4b1eav-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Aug 2019 14:48:11 -0700
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 8 Aug 2019 14:47:38 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 8 Aug 2019 14:47:37 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Aug 2019 14:47:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMC674fH5lOuzvKZvO2dv4d9BeOZSUq/PxLExdDdnbgixTeoA4s9NsFseBzi/c6tkkLDaRcELzJbRfaSZ/KF2wWdRQsi7083zOy7uPWShwszYhrjKhEh4eQgbyUYAdadNBzzjLwndAvQ+yfGFzxepja2defRaAzdoyJ+koVY3qT/+aGwshrPTdVLXJKrEtOmxlW88e42y9tKUjUXppM0sjh7toM++LJ9e181P4/JKwBH1UQ2enRqpEAF6ynceOIXMhlkwXAGZ0Q8DZPubAUcJg+q5ruyhVIm9kqyDwjAPEtrMmwpzaTObaz5XV9kuDUFRx/EW1NWyd/SG0gzodd5Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WF+U5+c8pRtcQvNq8nL/iiiA1l5vRJCJtjgwRxgfeI=;
 b=i4KCrRtjHOfWXl+femHICfCB4cX69ZyR9rYzzAFZklTDgsr3W0U/fuGGfTazUl7fco/yXaOYQHtH6BONnceYefFh2MF7LZpOB30Bnl8mupfpgEFzHF1Y4wSn3sZksoMhqHezqQ27+Tn26A66x/6vcGcbQDJAzExBvIW3M9Gc5lredkj/xC+SbJjJTBJAK6WsrKOHkPNofkaL4ubNk3MbUdTGRUUFKxlpiLNKCNBIclnSGhK3IT6Uh33/g/KwboV+rZwEpTxsHQ0DejnXAoF6CmvMMIcFvjMxvrD1dZauv7PgQzuoF3gJwHLNAwjZSv4pdTSvwreUXIMgnC6YH1hTrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WF+U5+c8pRtcQvNq8nL/iiiA1l5vRJCJtjgwRxgfeI=;
 b=jJ8n5zyCOLFOtushYI5GIghInnnxBA7a2lWMXvw3kLcVNCvwC+CWw3v6RLtgkFHHzDT0FlH6uSkq/3XtmDMIgLpdpkRIlGYIkSHKN3whdxLq4Dn/S0GaGVKcKGK7DtCGzIFZQBYqK1x1gBZoqeGRqDZW4LVu6C8jy/bt5ZW6wbQ=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1853.namprd15.prod.outlook.com (10.174.255.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 8 Aug 2019 21:47:36 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 21:47:36 +0000
From:   Tao Ren <taoren@fb.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v4 2/2] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Topic: [PATCH net-next v4 2/2] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Index: AQHVTJuYHTgXpcglwkmoKo5MNz+oeabupnmAgAFqGACAAJiMgIABI3EA
Date:   Thu, 8 Aug 2019 21:47:36 +0000
Message-ID: <14c1591b-26e1-3a2f-f6c4-beb2c8978e41@fb.com>
References: <20190806210931.3723590-1-taoren@fb.com>
 <fe0d39ea-91f3-0cac-f13b-3d46ea1748a3@fb.com>
 <cfd6e14e-a447-aedb-5bd6-bf65b4b6f98a@gmail.com>
 <a827c44c-3946-8f6f-e515-b476fd375cf6@fb.com>
In-Reply-To: <a827c44c-3946-8f6f-e515-b476fd375cf6@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0053.namprd04.prod.outlook.com
 (2603:10b6:102:1::21) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::5aeb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff6733ef-51d5-4ec5-cef9-08d71c4a06d9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1853;
x-ms-traffictypediagnostic: MWHPR15MB1853:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR15MB18538A4DA11A9423E51D7A2BB2D70@MWHPR15MB1853.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(346002)(396003)(39860400002)(376002)(199004)(189003)(71190400001)(81156014)(6116002)(81166006)(14454004)(966005)(102836004)(53936002)(53546011)(8676002)(386003)(6506007)(66476007)(65826007)(66446008)(64756008)(66556008)(2501003)(66946007)(25786009)(110136005)(6246003)(31686004)(58126008)(478600001)(76176011)(52116002)(7416002)(8936002)(316002)(2616005)(6486002)(86362001)(2201001)(7736002)(36756003)(31696002)(46003)(64126003)(65806001)(6512007)(186003)(6306002)(486006)(99286004)(305945005)(2906002)(476003)(6436002)(65956001)(5660300002)(11346002)(229853002)(256004)(446003)(71200400001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1853;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SfpeTvHYUNG5z+nvjGs/EhiEygreh2JErCSxW4adltN61eAVGYGikuTZCfdeyEqxE2H0tVdghb1dNjyUQN9uQXqwGua0yRHUmbgSGIavTJ85KGX0X72Ro2mtmWC8PVCfrAns0IUZSF4KJCaE275yL6y1Xw70RgVlkg8k9T1heN3k96K84B2JvKgiNotsEWESsSsPEp8GOsBnVp5x3FK93Y3foaBwQh6rstBGkdRPluN71z00MGzRfzIK3GJI3e7nLiU3YsnqL34rHXV9M0c0keAAFtTDHWM5GHKTjDGpaQ2TiABEIL5LKU0rJdSm3mavE1WSbEEqNLgODZVDEIl6SJbyEloTSwZYpwiHP76ZNf5XxkSswqEl+LQlIA9qble6e/tZsgj/ijUstGjV/hsg4CMXZ8KA59ta8upKF+413Jw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C69672CB2F4AC4C9A7249B56C452BD9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ff6733ef-51d5-4ec5-cef9-08d71c4a06d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 21:47:36.7208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /wKJ3wXyCSDVqlOHPuZCe9OM2i+WXvBx82n2SMWE4jAZ3Pvxpg1gl5J6n/YRM5T4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1853
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080190
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSGVpbmVyLA0KDQpPbiA4LzcvMTkgOToyNCBQTSwgVGFvIFJlbiB3cm90ZToNCj4gSGkgSGVp
bmVyLA0KPiANCj4gT24gOC83LzE5IDEyOjE4IFBNLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6DQo+
PiBPbiAwNi4wOC4yMDE5IDIzOjQyLCBUYW8gUmVuIHdyb3RlOg0KPj4+IEhpIEFuZHJldyAvIEhl
aW5lciAvIFZsYWRpbWlyLA0KPj4+DQo+Pj4gT24gOC82LzE5IDI6MDkgUE0sIFRhbyBSZW4gd3Jv
dGU6DQo+Pj4+IFRoZSBCQ001NDYxNlMgUEhZIGNhbm5vdCB3b3JrIHByb3Blcmx5IGluIFJHTUlJ
LT4xMDAwQmFzZS1LWCBtb2RlIChmb3INCj4+Pj4gZXhhbXBsZSwgb24gRmFjZWJvb2sgQ01NIEJN
QyBwbGF0Zm9ybSksIG1haW5seSBiZWNhdXNlIGdlbnBoeSBmdW5jdGlvbnMNCj4+Pj4gYXJlIGRl
c2lnbmVkIGZvciBjb3BwZXIgbGlua3MsIGFuZCAxMDAwQmFzZS1YIChjbGF1c2UgMzcpIGF1dG8g
bmVnb3RpYXRpb24NCj4+Pj4gbmVlZHMgdG8gYmUgaGFuZGxlZCBkaWZmZXJlbnRseS4NCj4+Pj4N
Cj4+Pj4gVGhpcyBwYXRjaCBlbmFibGVzIDEwMDBCYXNlLVggc3VwcG9ydCBmb3IgQkNNNTQ2MTZT
IGJ5IGN1c3RvbWl6aW5nIDMNCj4+Pj4gZHJpdmVyIGNhbGxiYWNrczoNCj4+Pj4NCj4+Pj4gICAt
IHByb2JlOiBwcm9iZSBjYWxsYmFjayBkZXRlY3RzIFBIWSdzIG9wZXJhdGlvbiBtb2RlIGJhc2Vk
IG9uDQo+Pj4+ICAgICBJTlRFUkZfU0VMWzE6MF0gcGlucyBhbmQgMTAwMFgvMTAwRlggc2VsZWN0
aW9uIGJpdCBpbiBTZXJERVMgMTAwLUZYDQo+Pj4+ICAgICBDb250cm9sIHJlZ2lzdGVyLg0KPj4+
Pg0KPj4+PiAgIC0gY29uZmlnX2FuZWc6IGJjbTU0NjE2c19jb25maWdfYW5lZ18xMDAwYnggZnVu
Y3Rpb24gaXMgYWRkZWQgZm9yIGF1dG8NCj4+Pj4gICAgIG5lZ290aWF0aW9uIGluIDEwMDBCYXNl
LVggbW9kZS4NCj4+Pj4NCj4+Pj4gICAtIHJlYWRfc3RhdHVzOiBCQ001NDYxNlMgYW5kIEJDTTU0
ODIgUEhZIHNoYXJlIHRoZSBzYW1lIHJlYWRfc3RhdHVzDQo+Pj4+ICAgICBjYWxsYmFjayB3aGlj
aCBtYW51YWxseSBzZXQgbGluayBzcGVlZCBhbmQgZHVwbGV4IG1vZGUgaW4gMTAwMEJhc2UtWA0K
Pj4+PiAgICAgbW9kZS4NCj4+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTogVGFvIFJlbiA8dGFvcmVu
QGZiLmNvbT4NCj4+Pg0KPj4+IEkgY3VzdG9taXplZCBjb25maWdfYW5lZyBmdW5jdGlvbiBmb3Ig
QkNNNTQ2MTZTIDEwMDBCYXNlLVggbW9kZSBhbmQgbGluay1kb3duIGlzc3VlIGlzIGFsc28gZml4
ZWQ6IHRoZSBwYXRjaCBpcyB0ZXN0ZWQgb24gRmFjZWJvb2sgQ01NIGFuZCBNaW5pcGFjayBCTUMg
YW5kIGV2ZXJ5dGhpbmcgbG9va3Mgbm9ybWFsLiBQbGVhc2Uga2luZGx5IHJldmlldyB3aGVuIHlv
dSBoYXZlIGJhbmR3aWR0aCBhbmQgbGV0IG1lIGtub3cgaWYgeW91IGhhdmUgZnVydGhlciBzdWdn
ZXN0aW9ucy4NCj4+Pg0KPj4+IEJUVywgSSB3b3VsZCBiZSBoYXBweSB0byBoZWxwIGlmIHdlIGRl
Y2lkZSB0byBhZGQgYSBzZXQgb2YgZ2VucGh5IGZ1bmN0aW9ucyBmb3IgY2xhdXNlIDM3LCBhbHRo
b3VnaCB0aGF0IG1heSBtZWFuIEkgbmVlZCBtb3JlIGhlbHAvZ3VpZGFuY2UgZnJvbSB5b3UgOi0p
DQo+Pg0KPj4gWW91IHdhbnQgdG8gaGF2ZSBzdGFuZGFyZCBjbGF1c2UgMzcgYW5lZyBhbmQgdGhp
cyBzaG91bGQgYmUgZ2VuZXJpYyBpbiBwaHlsaWIuDQo+PiBJIGhhY2tlZCB0b2dldGhlciBhIGZp
cnN0IHZlcnNpb24gdGhhdCBpcyBjb21waWxlLXRlc3RlZCBvbmx5Og0KPj4gaHR0cHM6Ly91cmxk
ZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19wYXRjaHdvcmsub3psYWJz
Lm9yZ19wYXRjaF8xMTQzNjMxXyZkPUR3SUNhUSZjPTVWRDBSVHRObFRoM3ljZDQxYjNNVXcmcj1p
WUVsVDdIQzc3cFJaM2J5VnZXOG5nJm09WkpBck9KdkhxTmtxdnMxeDhsOUhqZnhqQ044ZTV4SnBQ
ejJZVmlCdUtSQSZzPUVza3BmQlF0dTlJQlZlYjk2ZHYtc3o3NnhJejR0Sks1LWxENC1xZEl5V0km
ZT0gDQo+PiBJdCBzdXBwb3J0cyBmaXhlZCBtb2RlIHRvby4NCj4+DQo+PiBJdCBkb2Vzbid0IHN1
cHBvcnQgaGFsZiBkdXBsZXggbW9kZSBiZWNhdXNlIHBoeWxpYiBkb2Vzbid0IGtub3cgMTAwMEJh
c2VYIEhEIHlldC4NCj4+IE5vdCBzdXJlIHdoZXRoZXIgaGFsZiBkdXBsZXggbW9kZSBpcyB1c2Vk
IGF0IGFsbCBpbiByZWFsaXR5Lg0KPj4NCj4+IFlvdSBjb3VsZCB0ZXN0IHRoZSBuZXcgY29yZSBm
dW5jdGlvbnMgaW4geW91ciBvd24gY29uZmlnX2FuZWcgYW5kIHJlYWRfc3RhdHVzDQo+PiBjYWxs
YmFjayBpbXBsZW1lbnRhdGlvbnMuDQo+IA0KPiBUaGFuayB5b3UgdmVyeSBtdWNoIGZvciB0aGUg
aGVscCEgSSdtIHBsYW5uaW5nIHRvIGFkZCB0aGVzZSBmdW5jdGlvbnMgYnV0IEkgaGF2ZW4ndCBz
dGFydGVkIHlldCBiZWNhdXNlIEknbSBzdGlsbCBnb2luZyB0aHJvdWdoIGNsYXVzZSAzNyA6LSkN
Cj4gDQo+IExldCBtZSBhcHBseSB5b3VyIHBhdGNoIGFuZCBydW4gc29tZSB0ZXN0IG9uIG15IHBs
YXRmb3JtLiBXaWxsIHNoYXJlIHlvdSByZXN1bHRzIHRvbW9ycm93Lg0KDQpUaGUgcGF0Y2ggIm5l
dDogcGh5OiBhZGQgc3VwcG9ydCBmb3IgY2xhdXNlIDM3IGF1dG8tbmVnb3RpYXRpb24iIHdvcmtz
IG9uIG15IENNTSBwbGF0Zm9ybSwgd2l0aCBqdXN0IDEgbWlub3IgY2hhbmdlIGluIHBoeS5oIChJ
IGd1ZXNzIGl0J3MgdHlwbz8pLiBUaGFua3MgYWdhaW4gZm9yIHRoZSBoZWxwIQ0KDQotaW50IGdl
bnBoeV9jMzdfYW5lZ19kb25lKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpOw0KK2ludCBnZW5w
aHlfYzM3X2NvbmZpZ19hbmVnKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpOw0KDQpCVFcsIHNo
YWxsIEkgc2VuZCBvdXQgbXkgcGF0Y2ggdjUgbm93IChiYXNlZCBvbiB5b3VyIHBhdGNoKT8gT3Ig
SSBzaG91bGQgd2FpdCB0aWxsIHlvdXIgcGF0Y2ggaXMgaW5jbHVkZWQgaW4gbmV0LW5leHQgYW5k
IHRoZW4gc2VuZCBvdXQgbXkgcGF0Y2g/DQoNCg0KQ2hlZXJzLA0KDQpUYW8NCg==
