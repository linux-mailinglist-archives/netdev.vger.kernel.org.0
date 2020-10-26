Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDE2298A5D
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 11:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769735AbgJZK2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 06:28:04 -0400
Received: from mail2.eaton.com ([192.104.67.3]:10400 "EHLO
        simtcimsva02.etn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1768422AbgJZK2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 06:28:04 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 06:28:04 EDT
Received: from simtcimsva02.etn.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B919811A1BB;
        Mon, 26 Oct 2020 06:21:10 -0400 (EDT)
Received: from simtcimsva02.etn.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A159611A1B3;
        Mon, 26 Oct 2020 06:21:10 -0400 (EDT)
Received: from LOUTCSGWY02.napa.ad.etn.com (loutcsgwy02.napa.ad.etn.com [151.110.126.85])
        by simtcimsva02.etn.com (Postfix) with ESMTPS;
        Mon, 26 Oct 2020 06:21:10 -0400 (EDT)
Received: from LOUTCSHUB02.napa.ad.etn.com (151.110.40.75) by
 LOUTCSGWY02.napa.ad.etn.com (151.110.126.85) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Mon, 26 Oct 2020 06:21:10 -0400
Received: from USSTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.154) by
 LOUTCSHUB02.napa.ad.etn.com (151.110.40.75) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Mon, 26 Oct 2020 06:21:09 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by hybridmail.eaton.com (151.110.240.154) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Mon, 26 Oct 2020 06:20:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXeNq7WPMzUqOh3bSkYf9vO9hWno3UIgprkymBdNOjtYBhj3dcLaWFwt4RZDFj4IWusRnJ2qhmh4P5d73YTcwgRyVEt6oV51/McAYzL7Rc6vjuo/PuQSwg39+DKTOL45yTPOKecwDKR1+FnLvE7QaefUC7pUtmYJPVSYnbFrWRE3Wn2YpGateXbjZNsHxVw7oBRZWBQ7F5O6UR/oFIsembMoyugdrViX211mV2kaWNtLjLgx4r23Jo3NhsQAeDEwz+Hxc7gQB1SLkX7QA+yfRhBTr4d/Ol4GKOahrlGbgCUawSKxygPI/XTpKoM2TFfiYFI5TxoCz2/os6FZpM2cNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbM9H5/fkWCYz9s8nu4GL5eBht+9199E6ZvuNIpspJk=;
 b=JX7NgIeF4FV4YF+j+jebsjXX4fd8OO+B5L5VGtt8dzvjkq4wkD4cv3pP1YexjWQQMrZq9ITdPxqJ/FF45Xq8crVkxWcW2MLo6PPeajvWPKQ74UpBC8Rrm79BswIqTGargpfTmrF7kqEGjo8XUo4YhNhl+ZZZUjnpEQzbKRq6cbcIZtHGJmVGv9dtYewQgGw+SDEWCOs7va7e6R4FJ7jKbnWJcko0mjSCJOANQKLr3ZybxCkrXdyhNQ0+pVkMw6wYDWhhuGjs6NfD6yhlP/36nD5dA0mT3Hp/08RpGzIZqgZolrMavrM80pQ10jo28N9i7FbxB754GLKIXi2zoWpmug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbM9H5/fkWCYz9s8nu4GL5eBht+9199E6ZvuNIpspJk=;
 b=xzs8KGQRY4myXkoTGGCmHrjNiMlD5Pxp3hoLIHU/RTfc3+RUvD+dS2H9DZJ/8sulaky7z9eh6GLBoIO70enexnMGtuoJ52blECMFRMO8tamBFckW1X9bzthWfxyPhL42BY29sEwU3kkQx46Fqb23NKScDcQeka/2mT62NVnVcuQ=
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 (2603:10b6:910:6d::13) by CY4PR17MB0999.namprd17.prod.outlook.com
 (2603:10b6:903:a6::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Mon, 26 Oct
 2020 10:21:08 +0000
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45]) by CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45%6]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 10:21:08 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     =?utf-8?B?SsO2cmcgV2lsbG1hbm4=?= <joe@clnt.de>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: RE: [EXTERNAL]  Re: [PATCH 2/2] Reset PHY in phy_init_hw() before
 interrupt configuration
Thread-Topic: [EXTERNAL]  Re: [PATCH 2/2] Reset PHY in phy_init_hw() before
 interrupt configuration
Thread-Index: AdYeBMj3Elf0T3++RJuJe8w7Jf842wAQ7JiAACGbPLADupRKgB9x8QIg
Date:   Mon, 26 Oct 2020 10:21:08 +0000
Message-ID: <CY4PR1701MB187802CE3A01E94EF5659922DF190@CY4PR1701MB1878.namprd17.prod.outlook.com>
References: <CH2PR17MB3542BB17A1FA1764ACE3B20EDFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
 <338bd206-673d-6f3e-0402-822707af5075@gmail.com>
 <CH2PR17MB35427EF2FAE4E31FCA144F89DFAA0@CH2PR17MB3542.namprd17.prod.outlook.com>
 <alpine.DEB.2.21.2005191036500.7651@brian.int1.clnt.de>
In-Reply-To: <alpine.DEB.2.21.2005191036500.7651@brian.int1.clnt.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: clnt.de; dkim=none (message not signed)
 header.d=none;clnt.de; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1319d76-2bc0-4b57-ef8e-08d87998dad7
x-ms-traffictypediagnostic: CY4PR17MB0999:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR17MB09996EAFA616F1870F279E6DDF190@CY4PR17MB0999.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ooYgoDtv2khhducPErQ9zQSrPUueOSX62oqmCwKuST/tm6WeYS603nS23OOwTBaCgy08XTpYEm4OV9jJtE1SJJLUp/xRgZQO7hfiTnMGoOWFC4MACL1F/coCYk56JVTdMDjJCEywDeWdnITlRAIF8oFaiU6JvzkRzmsDfDTjD8FyjpasMEsTi9EcDbfBz347hSic70Yzd7VHskZhJM0q66qNOD0AzBn4bRqWAemC9mSRbHeIAaMTuZFXh8qUBYYXiWKkOB8gxEMfCGwRRJLo46AibfAIlnDjrxjm4GK60QxHLVdYT8S8/l2oSeyvVoplYLZawZtEin2ek6E/uubMgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1701MB1878.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(8676002)(76116006)(86362001)(45080400002)(66556008)(6506007)(66946007)(4326008)(64756008)(6916009)(26005)(66574015)(107886003)(66446008)(53546011)(83380400001)(7696005)(478600001)(66476007)(2906002)(52536014)(8936002)(186003)(55016002)(7416002)(54906003)(71200400001)(316002)(9686003)(5660300002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: HW1wdtXUZNRZhAovgiLOhNi9sRYyauez+TNGuAr3xoFn+yLCcz9FgUsaCDkM+1GAmdYZL11w2Os0f5BL+L9QHeVv0hgS4WzLhq2sKg5qK6jy7qBSyTAXJ+LrgKzOZ3m20K1cYt/uu/M/bbp9matSr7sP8x6s7epd1jpmdm2ya00CBN4+cfQMRm6nyt1A0nvyePT0gxRcds4x68WqzhUaQMtOqeu8EF/H4vkzuL5fu3f9Qc5IjknWrVhrwK+MxnMDXhvnwLoqO46uAvh+wv5g/+xNtaIyhl9FaqS65YNVyUiq7c59hXzl7lGXasAoTYoPckh410X9n/DwTqmgXQd7xM/KE4PtFEUWBe2ApmBsA1QlIexH5h/p3VeYfjPKBXhkfz88vWo0AIQgqgvbxGia55rid1KWtFrAcAGgx9xNq3OZ2rSau/Ptr7v+EJiQfRbxEHGXVbULNDNjxfJenLFtXc5JdAPP+MRQYDerlU+/Sywr+vtr/TOQ+6MX4FmQkQ+snskdIEtazGbTgP6YdfK9bLhtwZG4BsiyZJNtPnVpkkfnOKsoYWN/2Kfx2qSEsF1HmBjNWmrrb7goBVf0l1We6HNU1eFZI6ESztpGH6K/9gkl2J4CnY7Cpkacgu8CJTybFAL56vs1BTGyWfWa9B3pZg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1701MB1878.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1319d76-2bc0-4b57-ef8e-08d87998dad7
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2020 10:21:08.5460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zo0VO7qYYRVy3sFKhnh2eOyBCdUEF8eTKdUu6zGgXDvlZs+LuBpn0bq86RWHtscBe3erFJ9kx+A1KYAqePXg2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR17MB0999
X-TM-SNTS-SMTP: 1F3C000C7CC5C0A95CFE3E542507A007D4A44E0E2A8BE5BAAC9951643DB570872002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25748.006
X-TM-AS-Result: No--19.101-10.0-31-10
X-imss-scan-details: No--19.101-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25748.006
X-TMASE-Result: 10--19.100800-10.000000
X-TMASE-MatchedRID: v8iPsRNEpc0pwNTiG5IsEldOi7IJyXyINQB4EQzdUmM/3QFugV4qhgQ9
        n8U23GDfW3VwvqEIvJwdXvAkWdRIlREg9BQLlw7h9u1rQ4BgXPJ6cSMyMC0ZbhkUNDFS89yYvql
        B4fqMN6SQsmJJSyc8DLDj38pGgTYOaA/PqGhe8oSVUcz8XpiS9AD4keG7QhHmh19HA2YmPg3WPG
        f/WCvRSJGW0m426Ec3ZqHTQk8AKbHHPqim4ABQkiqwx8x+s5lFp1Pjcaldww3KbBIdkJiS4LwAm
        z0iQUL1PI8SZp0SyHOPRWK952ddOYqEDaEbYNOrPwKTD1v8YV5MkOX0UoduuSGeZKmZv/3lNmej
        zSz6vFKCZOCv8hiSdC6uYYfoiIOAeoT8ghp9T7/YeXBrcJgL5Pcl/zVnL7N085b+xRMFjsvUizk
        a+GYZvNr77hkhCxrfT6gd6TkwVI+twUHDPndXeTdfT4zyWoZSMn5o9eAFYLgjIzpupoCXK0iO7+
        wNDdeY+Q7cmTSH5ZJt/sXmMOvUfd/hC69ltgOuGUlF/M3Dxp9dSP482MrUJ35Isu006IGGGuhqc
        FSiQagxicNUzIllO6LN00NWXLlb8oXBIPaSRDziHyvyXeXh5lLudjh9ZOSxgW6bY8SOq3WjxYyR
        Ba/qJcTpzYaZOykwr92rc8XRCCvdB/CxWTRRu/558CedkGIvzP4Frv6e/e4oUNNzrsUxk0mARwp
        a0ZNPVQ2azH6/5mdRuHm7FOwcQ37cGd19dSFd
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

77u/DQoNCj4gDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpFYXRvbiBJbmR1c3Ry
aWVzIE1hbnVmYWN0dXJpbmcgR21iSCB+IFJlZ2lzdGVyZWQgcGxhY2Ugb2YgYnVzaW5lc3M6IFJv
dXRlIGRlIGxhIExvbmdlcmFpZSA3LCAxMTEwLCBNb3JnZXMsIFN3aXR6ZXJsYW5kIA0KDQotLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
PiBGcm9tOiBKw7ZyZyBXaWxsbWFubiA8am9lQGNsbnQuZGU+DQo+IFNlbnQ6IFR1ZXNkYXksIE1h
eSAxOSwgMjAyMCAxMDo0MSBBTQ0KPiBUbzogQmFkZWwsIExhdXJlbnQgPExhdXJlbnRCYWRlbEBl
YXRvbi5jb20+DQo+IENjOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPjsg
ZnVnYW5nLmR1YW5AbnhwLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYW5kcmV3QGx1
bm4uY2g7IGYuZmFpbmVsbGlAZ21haWwuY29tOw0KPiBsaW51eEBhcm1saW51eC5vcmcudWs7IHJp
Y2hhcmQubGVpdG5lckBza2lkYXRhLmNvbTsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgYWxleGFu
ZGVyLmxldmluQG1pY3Jvc29mdC5jb207DQo+IGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnOyBR
dWV0dGUsIEFybmF1ZCA8QXJuYXVkUXVldHRlQEVhdG9uLmNvbT4NCj4gU3ViamVjdDogUkU6IFtF
WFRFUk5BTF0gUmU6IFtQQVRDSCAyLzJdIFJlc2V0IFBIWSBpbiBwaHlfaW5pdF9odygpIGJlZm9y
ZQ0KPiBpbnRlcnJ1cHQgY29uZmlndXJhdGlvbg0KPiANCj4gDQo+IA0KPiBPbiBUaHUsIDMwIEFw
ciAyMDIwLCBCYWRlbCwgTGF1cmVudCB3cm90ZToNCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4gPj4gRnJvbTogSGVpbmVyIEthbGx3ZWl0IDxoa2FsbHdlaXQxQGdtYWlsLmNv
bT4NCj4gPj4gU2VudDogV2VkbmVzZGF5LCBBcHJpbCAyOSwgMjAyMCA3OjA2IFBNDQo+ID4+IFRv
OiBCYWRlbCwgTGF1cmVudCA8TGF1cmVudEJhZGVsQGVhdG9uLmNvbT47IGZ1Z2FuZy5kdWFuQG54
cC5jb207DQo+ID4+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGFuZHJld0BsdW5uLmNoOyBmLmZh
aW5lbGxpQGdtYWlsLmNvbTsNCj4gPj4gbGludXhAYXJtbGludXgub3JnLnVrOyByaWNoYXJkLmxl
aXRuZXJAc2tpZGF0YS5jb207DQo+ID4+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGFsZXhhbmRlci5s
ZXZpbkBtaWNyb3NvZnQuY29tOw0KPiA+PiBncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZw0KPiA+
PiBDYzogUXVldHRlLCBBcm5hdWQgPEFybmF1ZFF1ZXR0ZUBFYXRvbi5jb20+DQo+ID4+IFN1Ympl
Y3Q6IFtFWFRFUk5BTF0gUmU6IFtQQVRDSCAyLzJdIFJlc2V0IFBIWSBpbiBwaHlfaW5pdF9odygp
IGJlZm9yZQ0KPiA+PiBpbnRlcnJ1cHQgY29uZmlndXJhdGlvbg0KPiA+Pg0KPiA+PiBPbiAyOS4w
NC4yMDIwIDExOjAzLCBCYWRlbCwgTGF1cmVudCB3cm90ZToNCj4gPj4+IO+7v0Rlc2NyaXB0aW9u
OiB0aGlzIHBhdGNoIGFkZHMgYSByZXNldCBvZiB0aGUgUEhZIGluIHBoeV9pbml0X2h3KCkNCj4g
Pj4+IGZvciBQSFkgZHJpdmVycyBiZWFyaW5nIHRoZSBQSFlfUlNUX0FGVEVSX0NMS19FTiBmbGFn
Lg0KPiA+Pj4NCj4gPj4+IFJhdGlvbmFsZTogZHVlIHRvIHRoZSBQSFkgcmVzZXQgcmV2ZXJ0aW5n
IHRoZSBpbnRlcnJ1cHQgbWFzayB0bw0KPiA+Pj4gZGVmYXVsdCwgaXQgaXMgbmVjZXNzYXJ5IHRv
IGVpdGhlciBwZXJmb3JtIHRoZSByZXNldCBiZWZvcmUgUEhZDQo+ID4+PiBjb25maWd1cmF0aW9u
LCBvciByZS1jb25maWd1cmUgdGhlIFBIWSBhZnRlciByZXNldC4gVGhpcyBwYXRjaA0KPiA+Pj4g
aW1wbGVtZW50cyB0aGUgZm9ybWVyIGFzIGl0IGlzIHNpbXBsZXIgYW5kIG1vcmUgZ2VuZXJpYy4N
Cj4gPj4+DQo+ID4+PiBGaXhlczogMWIwYTgzYWMwNGUzODNlM2JlZDIxMzMyOTYyYjkwNzEwZmNm
MjgyOCAoIm5ldDogZmVjOiBhZGQNCj4gPj4gcGh5X3Jlc2V0X2FmdGVyX2Nsa19lbmFibGUoKSBz
dXBwb3J0IikNCj4gPj4+IFNpZ25lZC1vZmYtYnk6IExhdXJlbnQgQmFkZWwgPGxhdXJlbnRiYWRl
bEBlYXRvbi5jb20+DQo+ID4+Pg0KPiA+Pj4gLS0tDQo+ID4+PiAgZHJpdmVycy9uZXQvcGh5L3Bo
eV9kZXZpY2UuYyB8IDcgKysrKystLQ0KPiA+Pj4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4+Pg0KPiA+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3BoeS9waHlfZGV2aWNlLmMNCj4gPj4+IGIvZHJpdmVycy9uZXQvcGh5L3BoeV9kZXZpY2Uu
YyBpbmRleCAyOGUzYzVjMGUuLjJjYzUxMTM2NCAxMDA2NDQNCj4gPj4+IC0tLSBhL2RyaXZlcnMv
bmV0L3BoeS9waHlfZGV2aWNlLmMNCj4gPj4+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9waHlfZGV2
aWNlLmMNCj4gPj4+IEBAIC0xMDgyLDggKzEwODIsMTEgQEAgaW50IHBoeV9pbml0X2h3KHN0cnVj
dCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+IHsNCj4gPj4+ICAJaW50IHJldCA9IDA7DQo+ID4+Pg0K
PiA+Pj4gLQkvKiBEZWFzc2VydCB0aGUgcmVzZXQgc2lnbmFsICovDQo+ID4+PiAtCXBoeV9kZXZp
Y2VfcmVzZXQocGh5ZGV2LCAwKTsNCj4gPj4+ICsJLyogRGVhc3NlcnQgdGhlIHJlc2V0IHNpZ25h
bA0KPiA+Pj4gKwkgKiBJZiB0aGUgUEhZIG5lZWRzIGEgcmVzZXQsIGRvIGl0IG5vdw0KPiA+Pj4g
KwkgKi8NCj4gPj4+ICsJaWYgKCFwaHlfcmVzZXRfYWZ0ZXJfY2xrX2VuYWJsZShwaHlkZXYpKQ0K
PiA+Pg0KPiA+PiBJZiByZXNldCBpcyBhc3NlcnRlZCB3aGVuIGVudGVyaW5nIHBoeV9pbml0X2h3
KCksIHRoZW4NCj4gPj4gcGh5X3Jlc2V0X2FmdGVyX2Nsa19lbmFibGUoKSBiYXNpY2FsbHkgYmVj
b21lcyBhIG5vLW9wLg0KPiA+PiBTdGlsbCBpdCBzaG91bGQgd29yayBhcyBleHBlY3RlZCBkdWUg
dG8gdGhlIHJlc2V0IHNpZ25hbCBiZWluZw0KPiA+PiBkZWFzc2VydGVkLiBJdCB3b3VsZCBiZSB3
b3J0aCBkZXNjcmliaW5nIGluIHRoZSBjb21tZW50IHdoeSB0aGUgY29kZQ0KPiA+PiBzdGlsbCB3
b3JrcyBpbiB0aGlzIGNhc2UuDQo+ID4+DQo+ID4NCj4gPiBUaGFuayB5b3UgZm9yIHRoZSBjb21t
ZW50LCB0aGlzIGlzIGEgdmVyeSBnb29kIHBvaW50Lg0KPiA+IEkgd2lsbCBtYWtlIHN1cmUgdG8g
aW5jbHVkZSBzb21lIGRlc2NyaXB0aW9uIHdoZW4gcmVzdWJtaXR0aW5nLg0KPiA+IEkgaGFkIHBy
ZXZpb3VzbHkgdGVzdGVkIHRoaXMgYW5kIHdoYXQgSSBzYXcgd2FzIHRoYXQgdGhlIGZpcnN0IHRp
bWUNCj4gPiB5b3UgYnJpbmcgdXAgdGhlIGludGVyZmFjZSwgdGhlIHJlc2V0IGlzIG5vdCBhc3Nl
cnRlZCBzbyB0aGF0DQo+ID4gcGh5X3Jlc2V0X2FmdGVyX2Nsa19lbmFibGUoKSBpcyBlZmZlY3Rp
dmUuDQo+ID4gVGhlIHN1YnNlcXVlbnQgdGltZXMgdGhlIGludGVyZmFjZSBpcyBicm91Z2h0IHVw
LCB0aGUgcmVzZXQgaXMgYWxyZWFkeQ0KPiA+IGFzc2VydGVkIHdoZW4gZW50ZXJpbmcgcGh5X2lu
aXRfaHcoKSwgc28gdGhhdCBpdCBiZWNvbWVzIGEgbm8tb3AgYXMNCj4gPiB5b3UgY29ycmVjdGx5
IHBvaW50ZWQgb3V0LiBIb3dldmVyLCB0aGF0IGRpZG4ndCBjYXVzZSBhbnkgcHJvYmxlbSBvbg0K
PiA+IG15IGJvYXJkLCBwcmVzdW1hYmx5IGJlY2F1c2UgaW4gdGhhdCBjYXNlIHRoZSBjbG9jayBp
cyBhbHJlYWR5IHJ1bm5pbmcNCj4gPiB3aGVuIHRoZSBQSFkgY29tZXMgb3V0IG9mIHJlc2V0Lg0K
PiA+IEkgd2lsbCByZS10ZXN0IHRoaXMgY2FyZWZ1bGx5IGFnYWluc3QgdGhlICduZXQnIHRyZWUs
IHRob3VnaCwgYmVmb3JlDQo+ID4gY29taW5nIHRvIGNvbmNsdXNpb25zLg0KPiA+DQo+IEkgaGF2
ZSB0d28gYWRkaXRpb25hbCB0aGluZ3MgdG8gdGFrZSBpbnRvIGFjY291bnQ6DQo+ICogcGh5X3Jl
c2V0X2FmdGVyX2Nsa19lbmFibGUoKSBzaG91bG5kJ3QgYmUgbG9uZ2VyIGNhbGxlZCB0aGF0IHdh
eSBzaW5jZSBpdCBpcw0KPiBub3cgbWlzbGVhZGluZyAtPiB0aGUgcGh5IGlzIG5vIGxvbmdlciBy
ZXNldCBhZnRlciBjbG9jayBlbmFibGUgYnV0IGR1cmluZw0KPiBod19pbml0KCkNCj4gKiBob3cg
YWJvdXQgZmVjX3Jlc3VtZSgpPyBJIGRvbid0IHRoaW5rIGh3X2luaXQoKSBpcyBjYWxsZWQgdGhl
biBhbmQgc28NCj4gcGh5X3Jlc2V0X2FmdGVyX2Nsa19lbmFibGUoKSB3aWxsIG5vIGxvbmdlciBi
ZSBjYWxsZWQuDQo+IA0KDQpNeSBhcG9sb2dpZXMsIGluIHRoZSBtaWRzdCBvZiBtb2RpZnlpbmcg
YW5kIHByZXBhcmluZyBhIG5ldyBwYXRjaCBmb3IgdGhpcyBpc3N1ZQ0KSSBub3cgcmVhbGl6ZSB0
aGF0IEkgc2VlbSB0byBoYXZlIGZhaWxlZCB0byByZXBseSB0byB5b3VyIGNvbW1lbnRzLiBUaGFu
ayB5b3UNCnZlcnkgbXVjaCBmb3IgeW91ciB0aW1lIGFuZCBlZmZvcnRzIHJldmlld2luZyB0aGUg
cGF0Y2g7IEkgaGF2ZSB0YWtlbiB0aGVzZSBpbnRvDQphY2NvdW50IGFuZCBpbmRlZWQgdGhlcmUg
YWxzbyBzZWVtcyB0byBiZSBhbiBpc3N1ZSB3aXRoIGZlY19yZXN1bWUgdGhhdCBJIGhhdmUNCm5v
dyBhZGRyZXNzZWQuDQoNCj4gPj4+ICsJCXBoeV9kZXZpY2VfcmVzZXQocGh5ZGV2LCAwKTsNCj4g
Pj4+DQo+ID4+PiAgCWlmICghcGh5ZGV2LT5kcnYpDQo+ID4+PiAgCQlyZXR1cm4gMDsNCj4gPj4+
DQo+ID4NCj4gPg0K
