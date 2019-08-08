Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7293586D46
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 00:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404775AbfHHWbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 18:31:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52790 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbfHHWbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 18:31:31 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78MSt35006491;
        Thu, 8 Aug 2019 15:31:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/ahrbx/qyA1GTuPtjdTxBpMH9zjyOwEok34Ot0/+UMs=;
 b=bE9Oa5UAlIjbFsUFOHQD9eU8ID67JPMG2/vWrYWhVK/NnxpEfyK/2vGZVk6+28W1Kw8T
 xYbsWDuSfxn8/ufMLz58OgKlckC11oRp5DiFgvEO3/4eb8rtsT2f4phCMYeX76nwE7lV
 9s1JCfmYtD7ZShHmGsLCudrF88wCxZid5wM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u8sungkbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Aug 2019 15:31:21 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 8 Aug 2019 15:31:16 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Aug 2019 15:31:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPrjuCnuCLVGPF09/ddJwgSxScR1kpsIRmuNSg7ANuqBpXFuMdbLVVK+V8KltY5Su5+uaEKymEEv/Rr6O7f7wZKUOiXO4+slgHoicEVRfMU0qzyzGbI2TqRLtv10Chyoi/jmr1bW1OIsgAme9shsEemDA2dPBTnmoUXXSPQ3bV/a6VkwwIXYG9RVgnhYdQoG6U3g7Fnia5XGj9w3v4ez7A9FmDYL0DQLuXcPx9QPvebnor3xC/m8H2657dnAjfqAf8uYHQE2ewHWO5Gd6U+Bei1pj2EQB5dhnSCuH5NbG2XoM22+mltz+ayhfsuoIcQ9Znvwe62BBdrjh0bETs6Hgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ahrbx/qyA1GTuPtjdTxBpMH9zjyOwEok34Ot0/+UMs=;
 b=B1RXiysUivorNK/Vj2khJF/r/A+mXqZr+yPmmID/SvfC/4aBiPN7YHnhxcLVpbIzxL6M8Zcj4iOT4mAxG5MUXlvU0ENsTLVt2BqdBWFA6HmJLv4NYLGMkrw/QkKZfUO88v0QIK9lwbYrLkwQY2mh02a0OuIaCNjL8KWckmvNNBaIbJrnO57ko8vczPDPo+URBWyokstvDau3u3lnRdx7vs4Z77qQsxA+yTv0MunJk80PzzRpFOO0LVhrPOTOQWUUVSCgPU0uf2bHI6uqpRJWgQak+Hx1qhyPpUzQ6e85Psx4GaHnFMb8u01DT9cJItBfgM2AvYKZHckKPe+YHO7Q4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ahrbx/qyA1GTuPtjdTxBpMH9zjyOwEok34Ot0/+UMs=;
 b=CiXtaAfOK6seHf+6cJnAEnRQ2YYQc7O0wYlIG62UwqU9AprZ6WQtCAiGimM8iFMJrJzyF5ZYp9ymh+2bYntD/KxfkRq0eXZXhjs9Fky8VmfwBkP1YkXdA4YUIhXzEcuYjNU9qB1phS/tOyQFL3/yc2quEK03F1/beczGA93TSBI=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1230.namprd15.prod.outlook.com (10.175.2.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 8 Aug 2019 22:31:15 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 22:31:15 +0000
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
Thread-Index: AQHVTJuYHTgXpcglwkmoKo5MNz+oeabupnmAgAFqGACAAJiMgIAArhgAgAB7+oCAAAWQAA==
Date:   Thu, 8 Aug 2019 22:31:15 +0000
Message-ID: <56dd65a6-7c13-52e4-32c9-6e94d1811040@fb.com>
References: <20190806210931.3723590-1-taoren@fb.com>
 <fe0d39ea-91f3-0cac-f13b-3d46ea1748a3@fb.com>
 <cfd6e14e-a447-aedb-5bd6-bf65b4b6f98a@gmail.com>
 <a827c44c-3946-8f6f-e515-b476fd375cf6@fb.com>
 <14c1591b-26e1-3a2f-f6c4-beb2c8978e41@fb.com>
 <6d080f3e-48b9-a65d-b73e-576296e98738@gmail.com>
In-Reply-To: <6d080f3e-48b9-a65d-b73e-576296e98738@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR01CA0005.prod.exchangelabs.com (2603:10b6:a02:80::18)
 To MWHPR15MB1216.namprd15.prod.outlook.com (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::5aeb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4900a5c9-0a4b-49b0-19eb-08d71c501fb9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1230;
x-ms-traffictypediagnostic: MWHPR15MB1230:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR15MB12309BA4183900DA33DF3C2AB2D70@MWHPR15MB1230.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(396003)(376002)(366004)(346002)(189003)(199004)(31686004)(66476007)(64756008)(66556008)(66446008)(5660300002)(102836004)(31696002)(71200400001)(76176011)(99286004)(66946007)(25786009)(86362001)(2201001)(478600001)(6116002)(71190400001)(6486002)(256004)(7416002)(7736002)(36756003)(2501003)(46003)(8936002)(52116002)(53936002)(65956001)(229853002)(6246003)(316002)(446003)(58126008)(6306002)(486006)(966005)(11346002)(64126003)(476003)(2616005)(6512007)(110136005)(6506007)(53546011)(65826007)(386003)(6436002)(186003)(8676002)(81156014)(14454004)(305945005)(2906002)(81166006)(65806001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1230;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bBkhCkkwyGhJkNlk6wGji2BOTUC3IWDH6I+VFfRwUi/xZAC2zSf1zKlIu/+f7C1wPBBJ3QuD6AXFFycF94ltHKUWQTJ+GbR3b0EkbAMnv9z210zZ/bxwlYI+vvJs/dXQ9KbDja5hPhqU98JLdcP3uxuAjl+y52IykDkFny1pIrnFoUerUfP16DCIJuakYh0J2XxuHLs7Cn1v4dhqctHLZXDQ1CcCezP0GOvR8+aKmr8aSiFqGvaAp5QYPFNKYb+TxkZFtnPlwahh8MntyEfP7zeCURDx04JRcKWjo14tgV9o6kESbr6qkAxknzh1y8cssNFdHCJYPwwX4wf/ezjB9wQo8o1jxNJue1PNmzrs4nXoa5ePJ+eeY1eDWzj2FCzeZD72NHFLConNPr/TUo5TE9LbR+QSlX/X7/ExlEXyhog=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F3A1DFFEF6E5744B6DAF9BC963568E6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4900a5c9-0a4b-49b0-19eb-08d71c501fb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 22:31:15.3489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W+4se2f5ZykG11OmdbNA35B6IG/h31/KmIuU5gV2n8O6oaTpm714o/nd4uydlTvQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1230
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080199
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC84LzE5IDM6MTEgUE0sIEhlaW5lciBLYWxsd2VpdCB3cm90ZToNCj4gT24gMDguMDguMjAx
OSAyMzo0NywgVGFvIFJlbiB3cm90ZToNCj4+IEhpIEhlaW5lciwNCj4+DQo+PiBPbiA4LzcvMTkg
OToyNCBQTSwgVGFvIFJlbiB3cm90ZToNCj4+PiBIaSBIZWluZXIsDQo+Pj4NCj4+PiBPbiA4Lzcv
MTkgMTI6MTggUE0sIEhlaW5lciBLYWxsd2VpdCB3cm90ZToNCj4+Pj4gT24gMDYuMDguMjAxOSAy
Mzo0MiwgVGFvIFJlbiB3cm90ZToNCj4+Pj4+IEhpIEFuZHJldyAvIEhlaW5lciAvIFZsYWRpbWly
LA0KPj4+Pj4NCj4+Pj4+IE9uIDgvNi8xOSAyOjA5IFBNLCBUYW8gUmVuIHdyb3RlOg0KPj4+Pj4+
IFRoZSBCQ001NDYxNlMgUEhZIGNhbm5vdCB3b3JrIHByb3Blcmx5IGluIFJHTUlJLT4xMDAwQmFz
ZS1LWCBtb2RlIChmb3INCj4+Pj4+PiBleGFtcGxlLCBvbiBGYWNlYm9vayBDTU0gQk1DIHBsYXRm
b3JtKSwgbWFpbmx5IGJlY2F1c2UgZ2VucGh5IGZ1bmN0aW9ucw0KPj4+Pj4+IGFyZSBkZXNpZ25l
ZCBmb3IgY29wcGVyIGxpbmtzLCBhbmQgMTAwMEJhc2UtWCAoY2xhdXNlIDM3KSBhdXRvIG5lZ290
aWF0aW9uDQo+Pj4+Pj4gbmVlZHMgdG8gYmUgaGFuZGxlZCBkaWZmZXJlbnRseS4NCj4+Pj4+Pg0K
Pj4+Pj4+IFRoaXMgcGF0Y2ggZW5hYmxlcyAxMDAwQmFzZS1YIHN1cHBvcnQgZm9yIEJDTTU0NjE2
UyBieSBjdXN0b21pemluZyAzDQo+Pj4+Pj4gZHJpdmVyIGNhbGxiYWNrczoNCj4+Pj4+Pg0KPj4+
Pj4+ICAgLSBwcm9iZTogcHJvYmUgY2FsbGJhY2sgZGV0ZWN0cyBQSFkncyBvcGVyYXRpb24gbW9k
ZSBiYXNlZCBvbg0KPj4+Pj4+ICAgICBJTlRFUkZfU0VMWzE6MF0gcGlucyBhbmQgMTAwMFgvMTAw
Rlggc2VsZWN0aW9uIGJpdCBpbiBTZXJERVMgMTAwLUZYDQo+Pj4+Pj4gICAgIENvbnRyb2wgcmVn
aXN0ZXIuDQo+Pj4+Pj4NCj4+Pj4+PiAgIC0gY29uZmlnX2FuZWc6IGJjbTU0NjE2c19jb25maWdf
YW5lZ18xMDAwYnggZnVuY3Rpb24gaXMgYWRkZWQgZm9yIGF1dG8NCj4+Pj4+PiAgICAgbmVnb3Rp
YXRpb24gaW4gMTAwMEJhc2UtWCBtb2RlLg0KPj4+Pj4+DQo+Pj4+Pj4gICAtIHJlYWRfc3RhdHVz
OiBCQ001NDYxNlMgYW5kIEJDTTU0ODIgUEhZIHNoYXJlIHRoZSBzYW1lIHJlYWRfc3RhdHVzDQo+
Pj4+Pj4gICAgIGNhbGxiYWNrIHdoaWNoIG1hbnVhbGx5IHNldCBsaW5rIHNwZWVkIGFuZCBkdXBs
ZXggbW9kZSBpbiAxMDAwQmFzZS1YDQo+Pj4+Pj4gICAgIG1vZGUuDQo+Pj4+Pj4NCj4+Pj4+PiBT
aWduZWQtb2ZmLWJ5OiBUYW8gUmVuIDx0YW9yZW5AZmIuY29tPg0KPj4+Pj4NCj4+Pj4+IEkgY3Vz
dG9taXplZCBjb25maWdfYW5lZyBmdW5jdGlvbiBmb3IgQkNNNTQ2MTZTIDEwMDBCYXNlLVggbW9k
ZSBhbmQgbGluay1kb3duIGlzc3VlIGlzIGFsc28gZml4ZWQ6IHRoZSBwYXRjaCBpcyB0ZXN0ZWQg
b24gRmFjZWJvb2sgQ01NIGFuZCBNaW5pcGFjayBCTUMgYW5kIGV2ZXJ5dGhpbmcgbG9va3Mgbm9y
bWFsLiBQbGVhc2Uga2luZGx5IHJldmlldyB3aGVuIHlvdSBoYXZlIGJhbmR3aWR0aCBhbmQgbGV0
IG1lIGtub3cgaWYgeW91IGhhdmUgZnVydGhlciBzdWdnZXN0aW9ucy4NCj4+Pj4+DQo+Pj4+PiBC
VFcsIEkgd291bGQgYmUgaGFwcHkgdG8gaGVscCBpZiB3ZSBkZWNpZGUgdG8gYWRkIGEgc2V0IG9m
IGdlbnBoeSBmdW5jdGlvbnMgZm9yIGNsYXVzZSAzNywgYWx0aG91Z2ggdGhhdCBtYXkgbWVhbiBJ
IG5lZWQgbW9yZSBoZWxwL2d1aWRhbmNlIGZyb20geW91IDotKQ0KPj4+Pg0KPj4+PiBZb3Ugd2Fu
dCB0byBoYXZlIHN0YW5kYXJkIGNsYXVzZSAzNyBhbmVnIGFuZCB0aGlzIHNob3VsZCBiZSBnZW5l
cmljIGluIHBoeWxpYi4NCj4+Pj4gSSBoYWNrZWQgdG9nZXRoZXIgYSBmaXJzdCB2ZXJzaW9uIHRo
YXQgaXMgY29tcGlsZS10ZXN0ZWQgb25seToNCj4+Pj4gaHR0cHM6Ly91cmxkZWZlbnNlLnByb29m
cG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19wYXRjaHdvcmsub3psYWJzLm9yZ19wYXRjaF8x
MTQzNjMxXyZkPUR3SUNhUSZjPTVWRDBSVHRObFRoM3ljZDQxYjNNVXcmcj1pWUVsVDdIQzc3cFJa
M2J5VnZXOG5nJm09WkpBck9KdkhxTmtxdnMxeDhsOUhqZnhqQ044ZTV4SnBQejJZVmlCdUtSQSZz
PUVza3BmQlF0dTlJQlZlYjk2ZHYtc3o3NnhJejR0Sks1LWxENC1xZEl5V0kmZT0gDQo+Pj4+IEl0
IHN1cHBvcnRzIGZpeGVkIG1vZGUgdG9vLg0KPj4+Pg0KPj4+PiBJdCBkb2Vzbid0IHN1cHBvcnQg
aGFsZiBkdXBsZXggbW9kZSBiZWNhdXNlIHBoeWxpYiBkb2Vzbid0IGtub3cgMTAwMEJhc2VYIEhE
IHlldC4NCj4+Pj4gTm90IHN1cmUgd2hldGhlciBoYWxmIGR1cGxleCBtb2RlIGlzIHVzZWQgYXQg
YWxsIGluIHJlYWxpdHkuDQo+Pj4+DQo+Pj4+IFlvdSBjb3VsZCB0ZXN0IHRoZSBuZXcgY29yZSBm
dW5jdGlvbnMgaW4geW91ciBvd24gY29uZmlnX2FuZWcgYW5kIHJlYWRfc3RhdHVzDQo+Pj4+IGNh
bGxiYWNrIGltcGxlbWVudGF0aW9ucy4NCj4+Pg0KPj4+IFRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9y
IHRoZSBoZWxwISBJJ20gcGxhbm5pbmcgdG8gYWRkIHRoZXNlIGZ1bmN0aW9ucyBidXQgSSBoYXZl
bid0IHN0YXJ0ZWQgeWV0IGJlY2F1c2UgSSdtIHN0aWxsIGdvaW5nIHRocm91Z2ggY2xhdXNlIDM3
IDotKQ0KPj4+DQo+Pj4gTGV0IG1lIGFwcGx5IHlvdXIgcGF0Y2ggYW5kIHJ1biBzb21lIHRlc3Qg
b24gbXkgcGxhdGZvcm0uIFdpbGwgc2hhcmUgeW91IHJlc3VsdHMgdG9tb3Jyb3cuDQo+Pg0KPj4g
VGhlIHBhdGNoICJuZXQ6IHBoeTogYWRkIHN1cHBvcnQgZm9yIGNsYXVzZSAzNyBhdXRvLW5lZ290
aWF0aW9uIiB3b3JrcyBvbiBteSBDTU0gcGxhdGZvcm0sIHdpdGgganVzdCAxIG1pbm9yIGNoYW5n
ZSBpbiBwaHkuaCAoSSBndWVzcyBpdCdzIHR5cG8/KS4gVGhhbmtzIGFnYWluIGZvciB0aGUgaGVs
cCENCj4+DQo+PiAtaW50IGdlbnBoeV9jMzdfYW5lZ19kb25lKHN0cnVjdCBwaHlfZGV2aWNlICpw
aHlkZXYpOw0KPj4gK2ludCBnZW5waHlfYzM3X2NvbmZpZ19hbmVnKHN0cnVjdCBwaHlfZGV2aWNl
ICpwaHlkZXYpOw0KPj4NCj4gSW5kZWVkLCB0aGlzIHdhcyBhIHR5cG8uIFRoYW5rcy4NCj4gDQo+
PiBCVFcsIHNoYWxsIEkgc2VuZCBvdXQgbXkgcGF0Y2ggdjUgbm93IChiYXNlZCBvbiB5b3VyIHBh
dGNoKT8gT3IgSSBzaG91bGQgd2FpdCB0aWxsIHlvdXIgcGF0Y2ggaXMgaW5jbHVkZWQgaW4gbmV0
LW5leHQgYW5kIHRoZW4gc2VuZCBvdXQgbXkgcGF0Y2g/DQo+Pg0KPiBBZGRpbmcgbmV3IGZ1bmN0
aW9ucyB0byB0aGUgY29yZSBpcyB0eXBpY2FsbHkgb25seSBhY2NlcHRhYmxlIGlmIGluIHRoZQ0K
PiBzYW1lIHBhdGNoIHNlcmllcyBhIHVzZXIgb2YgdGhlIG5ldyBmdW5jdGlvbnMgaXMgYWRkZWQu
IFRoZXJlZm9yZSBpdCdzDQo+IGJlc3QgaWYgeW91IGluY2x1ZGUgbXkgcGF0Y2ggaW4geW91ciBz
ZXJpZXMgKGp1c3QgcmVtb3ZlIHRoZSBSRkMgdGFnIGFuZA0KPiBzZXQgdGhlIEZyb206IHByb3Bl
cmx5KS4NCg0KR290IGl0LiBMZXQgbWUgcGxheSB3aXRoIGl0IChlc3BlY2lhbGx5ICJGcm9tOiIg
cHJvcGVydHkpIGFuZCB3aWxsIHNlbmQgb3V0IHBhdGNoIHNlcmllcyBzb29uLg0KDQoNCkNoZWVy
cywNCg0KVGFvDQo=
