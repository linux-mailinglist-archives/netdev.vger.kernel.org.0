Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58D985906
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 06:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfHHEYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 00:24:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50286 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725270AbfHHEYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 00:24:52 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x784MU2X030861;
        Wed, 7 Aug 2019 21:24:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1iAh+tpSsZac7D5LYj/L1iVzmGOHGPclzFkZZk0yWOE=;
 b=TxbKzlmhs7fY6WVbqqqqZyt8AXbvQFIsLNzRfFzT8knr0HvalimOO8f6JQzYK3Ig1nOf
 xnvMKsCvzlYJAiKjNq0nS50tnHgnCfl5rWWJ4rCMT7XXyRGZ54gYhQLv7gUQHO3SpR6H
 fD5n/W+EleVj6ZcgMI90kgq2ZTZD+8cszfU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u87u50u6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 07 Aug 2019 21:24:33 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 7 Aug 2019 21:24:32 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 7 Aug 2019 21:24:31 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Aug 2019 21:24:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ti2aQAdeMR5Ikz515w30mu2oF6PbivqQlh6o5mwD99+kzNmKJpANcPlsLzkeALeKUksBZBpW4cRwNH2AQBRGO4rogNJqW/Vr1X++b+5l69kzuitjKwmJ3oWmsho97s/VCnlqxzPFNNSKhbnheKpVhqZdii1SH+g52KKqMm0PxqoFjbsQ1lOJ7fBs2Hfeyf9B6CVurtqLnudQlUSdkxpHPQiD4+hloUdDw/U/9YCOG+gkw9yE7P2Zd0hgsEPbJSVmkr5z56gkQnpq/pe5gQ5mWK+OuhCqiWWI+4MXEHaj0WWQHtwz2vkXPq7lJg/BkfOgjqpDSdAypVnr9fhVpnRwVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iAh+tpSsZac7D5LYj/L1iVzmGOHGPclzFkZZk0yWOE=;
 b=EDBWciEstyfHHGghZe1Y5wQ85l/WARG8wKlkBP0fEgrYVjgwtQqM66LSmsjENaUZoTpgkHDk52UnZjN8pcqoQw/pq9Sj73N6mI6rTXWFBOTbKF6vH0AMC7Aitd5t+c2xWkk6ITWugoRKetGdV/gEtokkng60wPVGWPulw3zgl+htPQmPab94zTYtaILZoh0VAQ9xKhowfNRb3birvhDBXF+4+ode79Kvb/Uo9aRxqOUte/2el++xvH5QFXXNthMGSeGXQzAyubYDT0yiMJotMkywPRmqjKaSpGUvjGPNjmjqDx9+9/5RoSg/5bG9ZP5LfQ0KtNvqtMjygei+F26YRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1iAh+tpSsZac7D5LYj/L1iVzmGOHGPclzFkZZk0yWOE=;
 b=Xr1dYj/i9WBsugReBRQPx0Hk/nxLQBmhb4fGACJJGjWk4gfqiiwNB5u9JGNlCnpclLDSwrwXBKd9xjFeD3rbDytsqHF2Jj0hNPH+bBAIkn1gjsFCdLmSXoGfdllX5uVaD80ZM5014b7wNV0fA2vjgXr91X+65qNk+FLzvrJltrA=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1182.namprd15.prod.outlook.com (10.175.3.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 8 Aug 2019 04:24:30 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.011; Thu, 8 Aug 2019
 04:24:30 +0000
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
Thread-Index: AQHVTJuYHTgXpcglwkmoKo5MNz+oeabupnmAgAFqGACAAJiMgA==
Date:   Thu, 8 Aug 2019 04:24:30 +0000
Message-ID: <a827c44c-3946-8f6f-e515-b476fd375cf6@fb.com>
References: <20190806210931.3723590-1-taoren@fb.com>
 <fe0d39ea-91f3-0cac-f13b-3d46ea1748a3@fb.com>
 <cfd6e14e-a447-aedb-5bd6-bf65b4b6f98a@gmail.com>
In-Reply-To: <cfd6e14e-a447-aedb-5bd6-bf65b4b6f98a@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR13CA0047.namprd13.prod.outlook.com
 (2603:10b6:300:95::33) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f857]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5257f51b-e363-426d-ec3f-08d71bb84e73
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1182;
x-ms-traffictypediagnostic: MWHPR15MB1182:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <MWHPR15MB1182AFDB3B9C92DB1CC9DFC2B2D70@MWHPR15MB1182.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(199004)(76176011)(46003)(6116002)(52116002)(14454004)(186003)(316002)(65826007)(99286004)(58126008)(110136005)(81156014)(446003)(81166006)(966005)(8936002)(11346002)(486006)(2501003)(66946007)(2906002)(6436002)(6486002)(386003)(229853002)(66476007)(6506007)(66446008)(66556008)(64756008)(53546011)(478600001)(102836004)(5660300002)(31696002)(6246003)(256004)(31686004)(7736002)(305945005)(64126003)(8676002)(7416002)(2616005)(476003)(2201001)(65806001)(65956001)(6306002)(71200400001)(6512007)(53936002)(25786009)(36756003)(86362001)(71190400001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1182;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: f8h/W9fLbA4HeOaLamh+DH5R8OujqHGGBDx6Zxam+MWnEHdy4gxsIBc2LxrP6b5D0jV83vqZcfscQ1ZtKdd6DXFj/aH5jzNjVFtQHSvIPVboY03cLv6IAZQuAu5d77GgqYs24LJM5rTpOyBFI0CrrHBq3SoPtMiJs2SAoMDhcJDQ3tXK5yZZPhw4dxRIAk+hGpvhJGdEobgq+dF36V2SehGe0HZcBTG3aYQl9ERFTgBXjo46Zh/XREh8z8Zr/SrdRwflqb50Zd8rVUrGSgKWM0DlNkmB6UIJUcJrMlfTxQCmtWYkaTcrvB8I8mNiOzd5whNgm97fgaEM/md9656NCPa9o1y84kd62ZTdRMMPCIt0jP8yLdLVH3AtPokDmvcyNNCHJDUlOYAY0P1iZ93zfhr8AA71RFWjf6Cd/uQBKhU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C3A9B036882C6247A94DBE5E125C8A8D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5257f51b-e363-426d-ec3f-08d71bb84e73
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 04:24:30.4175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 74HDZA6eTGsNeIYnWYU5fAtHcrOIvOgssrVjxSc49Lsk85GDamyrlBXsK0KsfcTC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1182
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSGVpbmVyLA0KDQpPbiA4LzcvMTkgMTI6MTggUE0sIEhlaW5lciBLYWxsd2VpdCB3cm90ZToN
Cj4gT24gMDYuMDguMjAxOSAyMzo0MiwgVGFvIFJlbiB3cm90ZToNCj4+IEhpIEFuZHJldyAvIEhl
aW5lciAvIFZsYWRpbWlyLA0KPj4NCj4+IE9uIDgvNi8xOSAyOjA5IFBNLCBUYW8gUmVuIHdyb3Rl
Og0KPj4+IFRoZSBCQ001NDYxNlMgUEhZIGNhbm5vdCB3b3JrIHByb3Blcmx5IGluIFJHTUlJLT4x
MDAwQmFzZS1LWCBtb2RlIChmb3INCj4+PiBleGFtcGxlLCBvbiBGYWNlYm9vayBDTU0gQk1DIHBs
YXRmb3JtKSwgbWFpbmx5IGJlY2F1c2UgZ2VucGh5IGZ1bmN0aW9ucw0KPj4+IGFyZSBkZXNpZ25l
ZCBmb3IgY29wcGVyIGxpbmtzLCBhbmQgMTAwMEJhc2UtWCAoY2xhdXNlIDM3KSBhdXRvIG5lZ290
aWF0aW9uDQo+Pj4gbmVlZHMgdG8gYmUgaGFuZGxlZCBkaWZmZXJlbnRseS4NCj4+Pg0KPj4+IFRo
aXMgcGF0Y2ggZW5hYmxlcyAxMDAwQmFzZS1YIHN1cHBvcnQgZm9yIEJDTTU0NjE2UyBieSBjdXN0
b21pemluZyAzDQo+Pj4gZHJpdmVyIGNhbGxiYWNrczoNCj4+Pg0KPj4+ICAgLSBwcm9iZTogcHJv
YmUgY2FsbGJhY2sgZGV0ZWN0cyBQSFkncyBvcGVyYXRpb24gbW9kZSBiYXNlZCBvbg0KPj4+ICAg
ICBJTlRFUkZfU0VMWzE6MF0gcGlucyBhbmQgMTAwMFgvMTAwRlggc2VsZWN0aW9uIGJpdCBpbiBT
ZXJERVMgMTAwLUZYDQo+Pj4gICAgIENvbnRyb2wgcmVnaXN0ZXIuDQo+Pj4NCj4+PiAgIC0gY29u
ZmlnX2FuZWc6IGJjbTU0NjE2c19jb25maWdfYW5lZ18xMDAwYnggZnVuY3Rpb24gaXMgYWRkZWQg
Zm9yIGF1dG8NCj4+PiAgICAgbmVnb3RpYXRpb24gaW4gMTAwMEJhc2UtWCBtb2RlLg0KPj4+DQo+
Pj4gICAtIHJlYWRfc3RhdHVzOiBCQ001NDYxNlMgYW5kIEJDTTU0ODIgUEhZIHNoYXJlIHRoZSBz
YW1lIHJlYWRfc3RhdHVzDQo+Pj4gICAgIGNhbGxiYWNrIHdoaWNoIG1hbnVhbGx5IHNldCBsaW5r
IHNwZWVkIGFuZCBkdXBsZXggbW9kZSBpbiAxMDAwQmFzZS1YDQo+Pj4gICAgIG1vZGUuDQo+Pj4N
Cj4+PiBTaWduZWQtb2ZmLWJ5OiBUYW8gUmVuIDx0YW9yZW5AZmIuY29tPg0KPj4NCj4+IEkgY3Vz
dG9taXplZCBjb25maWdfYW5lZyBmdW5jdGlvbiBmb3IgQkNNNTQ2MTZTIDEwMDBCYXNlLVggbW9k
ZSBhbmQgbGluay1kb3duIGlzc3VlIGlzIGFsc28gZml4ZWQ6IHRoZSBwYXRjaCBpcyB0ZXN0ZWQg
b24gRmFjZWJvb2sgQ01NIGFuZCBNaW5pcGFjayBCTUMgYW5kIGV2ZXJ5dGhpbmcgbG9va3Mgbm9y
bWFsLiBQbGVhc2Uga2luZGx5IHJldmlldyB3aGVuIHlvdSBoYXZlIGJhbmR3aWR0aCBhbmQgbGV0
IG1lIGtub3cgaWYgeW91IGhhdmUgZnVydGhlciBzdWdnZXN0aW9ucy4NCj4+DQo+PiBCVFcsIEkg
d291bGQgYmUgaGFwcHkgdG8gaGVscCBpZiB3ZSBkZWNpZGUgdG8gYWRkIGEgc2V0IG9mIGdlbnBo
eSBmdW5jdGlvbnMgZm9yIGNsYXVzZSAzNywgYWx0aG91Z2ggdGhhdCBtYXkgbWVhbiBJIG5lZWQg
bW9yZSBoZWxwL2d1aWRhbmNlIGZyb20geW91IDotKQ0KPiANCj4gWW91IHdhbnQgdG8gaGF2ZSBz
dGFuZGFyZCBjbGF1c2UgMzcgYW5lZyBhbmQgdGhpcyBzaG91bGQgYmUgZ2VuZXJpYyBpbiBwaHls
aWIuDQo+IEkgaGFja2VkIHRvZ2V0aGVyIGEgZmlyc3QgdmVyc2lvbiB0aGF0IGlzIGNvbXBpbGUt
dGVzdGVkIG9ubHk6DQo+IGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92Mi91cmw/
dT1odHRwcy0zQV9fcGF0Y2h3b3JrLm96bGFicy5vcmdfcGF0Y2hfMTE0MzYzMV8mZD1Ed0lDYVEm
Yz01VkQwUlR0TmxUaDN5Y2Q0MWIzTVV3JnI9aVlFbFQ3SEM3N3BSWjNieVZ2VzhuZyZtPVpKQXJP
SnZIcU5rcXZzMXg4bDlIamZ4akNOOGU1eEpwUHoyWVZpQnVLUkEmcz1Fc2twZkJRdHU5SUJWZWI5
NmR2LXN6NzZ4SXo0dEpLNS1sRDQtcWRJeVdJJmU9IA0KPiBJdCBzdXBwb3J0cyBmaXhlZCBtb2Rl
IHRvby4NCj4gDQo+IEl0IGRvZXNuJ3Qgc3VwcG9ydCBoYWxmIGR1cGxleCBtb2RlIGJlY2F1c2Ug
cGh5bGliIGRvZXNuJ3Qga25vdyAxMDAwQmFzZVggSEQgeWV0Lg0KPiBOb3Qgc3VyZSB3aGV0aGVy
IGhhbGYgZHVwbGV4IG1vZGUgaXMgdXNlZCBhdCBhbGwgaW4gcmVhbGl0eS4NCj4gDQo+IFlvdSBj
b3VsZCB0ZXN0IHRoZSBuZXcgY29yZSBmdW5jdGlvbnMgaW4geW91ciBvd24gY29uZmlnX2FuZWcg
YW5kIHJlYWRfc3RhdHVzDQo+IGNhbGxiYWNrIGltcGxlbWVudGF0aW9ucy4NCg0KVGhhbmsgeW91
IHZlcnkgbXVjaCBmb3IgdGhlIGhlbHAhIEknbSBwbGFubmluZyB0byBhZGQgdGhlc2UgZnVuY3Rp
b25zIGJ1dCBJIGhhdmVuJ3Qgc3RhcnRlZCB5ZXQgYmVjYXVzZSBJJ20gc3RpbGwgZ29pbmcgdGhy
b3VnaCBjbGF1c2UgMzcgOi0pDQoNCkxldCBtZSBhcHBseSB5b3VyIHBhdGNoIGFuZCBydW4gc29t
ZSB0ZXN0IG9uIG15IHBsYXRmb3JtLiBXaWxsIHNoYXJlIHlvdSByZXN1bHRzIHRvbW9ycm93Lg0K
DQoNCkNoZWVycywNCg0KVGFvDQo=
