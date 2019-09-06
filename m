Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6EAAB326
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391841AbfIFHXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:23:49 -0400
Received: from alln-iport-1.cisco.com ([173.37.142.88]:58525 "EHLO
        alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389197AbfIFHXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 03:23:49 -0400
X-Greylist: delayed 16138 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Sep 2019 03:23:48 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2506; q=dns/txt; s=iport;
  t=1567754628; x=1568964228;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hk6dKiNghRNURoPVtWLKaIwJZ9u9n9Nt3lUUWqvY3To=;
  b=l6w73NJ4UFddqJ4iOUpgY25hoavuOQwtPaqCfyf4h5XN3C7ACy2QiOkO
   K4XyWB/kIVNCrEztz6Mk/ZFpZPkNfJqmEIoleIX9Vm3WnFKM6l+lSAnIK
   MvpK7QGwlV1AJqrwrbNBTfGHldYc+Z8+V0cHL7zgsk5DYIPpIxTS0tjDV
   o=;
IronPort-PHdr: =?us-ascii?q?9a23=3Azv+ipxfSIzneyYBiKawAE0lLlGMj4e+mNxMJ6p?=
 =?us-ascii?q?chl7NFe7ii+JKnJkHE+PFxlwGQD57D5adCjOzb++D7VGoM7IzJkUhKcYcEFn?=
 =?us-ascii?q?pnwd4TgxRmBceEDUPhK/u/Yio5Ec9CWVlN9HCgOk8TE8H7NBXf?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BBAQBfCHJd/40NJK1lGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBZ4FFUAOBQyAECyqEIYNHA4p1TYFqJZdtglIDVAkBAQEMAQE?=
 =?us-ascii?q?tAgEBhD8CF4IgIzgTAgMJAQEEAQEBAgEGBG2FLgyFSgEBAQECARILBhEMAQE?=
 =?us-ascii?q?3AQQHBAIBCA4DAwECAwImAgICMBUICAIEDgUigwCBawMODwGdeAKBOIhhc4E?=
 =?us-ascii?q?ygn0BAQWFFxiCFgkUeCiLeBiBQD+BOAwTgh4uPoREF4J0MoImjwc0nQIKgiC?=
 =?us-ascii?q?UcRuYeoo9nCECBAIEBQIOAQEFgWkhgVhwFTsqAYJBgkKDcopTc4Epj2EBAQ?=
X-IronPort-AV: E=Sophos;i="5.64,472,1559520000"; 
   d="scan'208";a="320921228"
Received: from alln-core-8.cisco.com ([173.36.13.141])
  by alln-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 06 Sep 2019 07:23:47 +0000
Received: from XCH-ALN-002.cisco.com (xch-aln-002.cisco.com [173.36.7.12])
        by alln-core-8.cisco.com (8.15.2/8.15.2) with ESMTPS id x867NltT023562
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Fri, 6 Sep 2019 07:23:47 GMT
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by XCH-ALN-002.cisco.com
 (173.36.7.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Sep
 2019 02:23:46 -0500
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by xhs-rcd-003.cisco.com
 (173.37.227.248) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 6 Sep
 2019 02:23:46 -0500
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-003.cisco.com (173.37.227.248) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 6 Sep 2019 02:23:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOrzkVnIa55l+78SFlsJ2q3SLQXyBBhShXMdDqUItV9GQA8UGABBqwpDCv4Bw+XBFE0Q8QAVnhYp4IeXzE5UMe2o3KFLBxY1ubksmS1mAYV9QoDsxUo7b4fKvt+/GMPsD07w/U0Jzx/0VIFa6VhDjGdS2sm5/bYy/eKCI0oIQQnvOGSRls1X+eyANSypg05VkAVO4kW0HzUb+4BA7Ve2kr5+hWDWTBUHB1MA9Z+UwuAHqaBIXVXTVMZp93P7Hwc5qpVvwCvtOIQmCTVO/NnFetPKAJSSz6nXvKCaXoMSVRv70oSksf3oONBk1IbE8OPTw7xXmqZRyO2ZJsGIlPS0lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hk6dKiNghRNURoPVtWLKaIwJZ9u9n9Nt3lUUWqvY3To=;
 b=QyTRffbfxzyOsAf2xjZDjNylAI6m3/UmAyVVt1s4VSm5wN+Rb9MvJwYvTmWSYWJom/mZ7kEpEvIrgk2g5N8sl19Mcco6fpmvnNTIQ6mYT3QPv2lotCRAu7FABboMYBj3uuecymm6qZXsS9dYvi2r/9G9QCN8jnBxAIthZxrOLvbTR1vdhTK/ffOkF019BPa1tIKFZHCQzCP5HXbZxqe+3to4XNk4/zp4PTMC5l/IDf2z2tOuCJBFYDEkVhbxgkmjlbFSKLRXKshDP0gYyj7a5hMiwQFgg40lv6SNFZHv2oG3x28aXdaCLJkfEiNvWU5YGVkmTzniZMUPZs+D6syi7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hk6dKiNghRNURoPVtWLKaIwJZ9u9n9Nt3lUUWqvY3To=;
 b=uZTaGDtf/yc8Xl48XkxccVrKGcuSyIQyyVJ8+El/+wgD93RLa36hrOOjtvoYqRyKLKcIQVpKKDvVt3jp+cV+2eZp1WSyMHjpUheasjUiA8QZnwCGe5ycGN1RoPsG/AaZLMgwP6TH7plMrmVPQqn5DeMuvbQTNZ7FE8L3OLVYtmY=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (10.255.181.96) by
 MN2PR11MB3904.namprd11.prod.outlook.com (10.255.180.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.17; Fri, 6 Sep 2019 07:23:44 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::942d:38ac:36ca:e557]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::942d:38ac:36ca:e557%6]) with mapi id 15.20.2241.014; Fri, 6 Sep 2019
 07:23:44 +0000
From:   "Enke Chen (enkechen)" <enkechen@cisco.com>
To:     David Miller <davem@davemloft.net>
CC:     "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "Enke Chen (enkechen)" <enkechen@cisco.com>
Subject: Re: [PATCH] net: Remove the source address setting in connect() for
 UDP
Thread-Topic: [PATCH] net: Remove the source address setting in connect() for
 UDP
Thread-Index: AQHVZF6CHsOdeXPHPUGTpDh6i+p9EacePIYA//+NawA=
Date:   Fri, 6 Sep 2019 07:23:43 +0000
Message-ID: <1DCD31CA-E94F-4127-876F-8DD355E6CF9A@cisco.com>
References: <20190906025437.613-1-enkechen@cisco.com>
 <20190906.091350.2133455010162259391.davem@davemloft.net>
In-Reply-To: <20190906.091350.2133455010162259391.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1c.0.190812
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=enkechen@cisco.com; 
x-originating-ip: [2001:420:c0c8:1005::8e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cb7e661-3bd1-4db3-a2c4-08d7329b264e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR11MB3904;
x-ms-traffictypediagnostic: MN2PR11MB3904:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39047A3921E39106BC851E59C5BA0@MN2PR11MB3904.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(13464003)(189003)(199004)(53546011)(6506007)(76116006)(102836004)(2906002)(76176011)(6512007)(53936002)(478600001)(316002)(66446008)(64756008)(6436002)(33656002)(2616005)(58126008)(99286004)(66556008)(54906003)(66946007)(91956017)(66476007)(186003)(46003)(476003)(11346002)(486006)(446003)(81166006)(81156014)(86362001)(8676002)(6486002)(305945005)(4326008)(8936002)(6116002)(71190400001)(7736002)(71200400001)(256004)(36756003)(25786009)(6246003)(229853002)(5660300002)(14454004)(6916009)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3904;H:MN2PR11MB3999.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gr0dcGdwzn/huyMwsqwI4/U/ItEVa6330mWuBAE2IVo+XWFEzwrzW47FzddXWqpccu9BP6TdROjA4FZy1cfH5qqKn1j3vjMWg+yVAyNI9NfIG+XCDCiHIrfxDV559BjzsoBOeW1SQ9Jug3jE09c6/Y4mdoejT4OfxXTn18l6UWe5SpHYSzdf0kRC0eT0b5KrWUWxAXwl9Lhhtffmp7RGf9jFijWNsXxXg3iSkJoLqOzfxjCOKGTqazqugT+5fjajFK2BiuBpZFiIyB+cxyIoPbBLfx6KS93o64pwLvKFvHs8dixF5FOruVHlz0gwr1NgEjyf6NK2j87F6a/5z2ExCoFW4wNz2XUAN8tXNg9c3OrRNQmjkdEfMnu6FmftZqbpkldwGZED9ONkK6QqUAsryU7iySQE0W/YsRxwf76oAFw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D14D8617FC40D4A9268006EF0797F9B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb7e661-3bd1-4db3-a2c4-08d7329b264e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 07:23:43.8842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pr25jFpPXuTWd0lKSx4A+4YkdZyw0L1Ek6oUeTCAo5JUSU1DWss22cyyGJqv0YPphqW37jSQ6Lb9Nayrz73biw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3904
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.12, xch-aln-002.cisco.com
X-Outbound-Node: alln-core-8.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIERhdmlkOg0KDQpZZXMsIEkgdW5kZXJzdGFuZCB0aGUgY29kZSBoYXMgYmVlbiB0aGVyZSBm
b3IgYSBsb25nIHRpbWUuICBCdXQgdGhlIGlzc3VlcyBhcmUgcmVhbCwgYW5kIGl0J3MgcmVhbGx5
IG5hc3R5IHdoZW4NCllvdSBydW4gaW50byB0aGVtLiAgQXMgSSBkZXNjcmliZWQgaW4gdGhlIHBh
dGNoIGxvZywgdGhlcmUgaXMgbm8gYmFja3dhcmQgY29tcGF0aWJpbGl0eSBJc3N1ZSBmb3IgZml4
aW5nIGl0Lg0KDQotLS0NClRoZXJlIGlzIG5vIGJhY2t3YXJkIGNvbXBhdGliaWxpdHkgaXNzdWUg
aGVyZSBhcyB0aGUgc291cmNlIGFkZHJlc3Mgc2V0dGluZw0KaW4gY29ubmVjdCgpIGlzIG5vdCBu
ZWVkZWQgYW55d2F5Lg0KDQogIC0gTm8gaW1wYWN0IG9uIHRoZSBzb3VyY2UgYWRkcmVzcyBzZWxl
Y3Rpb24gd2hlbiB0aGUgc291cmNlIGFkZHJlc3MNCiAgICBpcyBleHBsaWNpdGx5IHNwZWNpZmll
ZCBieSAiYmluZCgpIiwgb3IgYnkgdGhlICJJUF9QS1RJTkZPIiBvcHRpb24uDQoNCiAgLSBJbiB0
aGUgY2FzZSB0aGF0IHRoZSBzb3VyY2UgYWRkcmVzcyBpcyBub3QgZXhwbGljaXRseSBzcGVjaWZp
ZWQsDQogICAgdGhlIHNlbGVjdGlvbiBvZiB0aGUgc291cmNlIGFkZHJlc3Mgd291bGQgYmUgbW9y
ZSBhY2N1cmF0ZSBhbmQNCiAgICByZWxpYWJsZSBiYXNlZCBvbiB0aGUgdXAtdG8tZGF0ZSByb3V0
aW5nIHRhYmxlLg0KLS0tDQoNClRoYW5rcy4gIC0tIEVua2UNCg0K77u/LS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCkZyb206IDxsaW51eC1rZXJuZWwtb3duZXJAdmdlci5rZXJuZWwub3JnPiBv
biBiZWhhbGYgb2YgRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogRnJp
ZGF5LCBTZXB0ZW1iZXIgNiwgMjAxOSBhdCAxMjoxNCBBTQ0KVG86ICJFbmtlIENoZW4gKGVua2Vj
aGVuKSIgPGVua2VjaGVuQGNpc2NvLmNvbT4NCkNjOiAia3V6bmV0QG1zMi5pbnIuYWMucnUiIDxr
dXpuZXRAbXMyLmluci5hYy5ydT4sICJ5b3NoZnVqaUBsaW51eC1pcHY2Lm9yZyIgPHlvc2hmdWpp
QGxpbnV4LWlwdjYub3JnPiwgIm5ldGRldkB2Z2VyLmtlcm5lbC5vcmciIDxuZXRkZXZAdmdlci5r
ZXJuZWwub3JnPiwgImxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmciIDxsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnPiwgInhlLWxpbnV4LWV4dGVybmFsKG1haWxlciBsaXN0KSIgPHhlLWxp
bnV4LWV4dGVybmFsQGNpc2NvLmNvbT4NClN1YmplY3Q6IFJlOiBbUEFUQ0hdIG5ldDogUmVtb3Zl
IHRoZSBzb3VyY2UgYWRkcmVzcyBzZXR0aW5nIGluIGNvbm5lY3QoKSBmb3IgVURQDQoNCkZyb206
IEVua2UgQ2hlbiA8ZW5rZWNoZW5AY2lzY28uY29tPg0KRGF0ZTogVGh1LCAgNSBTZXAgMjAxOSAx
OTo1NDozNyAtMDcwMA0KDQo+IFRoZSBjb25uZWN0KCkgc3lzdGVtIGNhbGwgZm9yIGEgVURQIHNv
Y2tldCBpcyBmb3Igc2V0dGluZyB0aGUgZGVzdGluYXRpb24NCj4gYWRkcmVzcyBhbmQgcG9ydC4g
QnV0IHRoZSBjdXJyZW50IGNvZGUgbWlzdGFrZW5seSBzZXRzIHRoZSBzb3VyY2UgYWRkcmVzcw0K
PiBmb3IgdGhlIHNvY2tldCBhcyB3ZWxsLiBSZW1vdmUgdGhlIHNvdXJjZSBhZGRyZXNzIHNldHRp
bmcgaW4gY29ubmVjdCgpIGZvcg0KPiBVRFAgaW4gdGhpcyBwYXRjaC4NCg0KRG8geW91IGhhdmUg
YW55IGlkZWEgaG93IG1hbnkgZGVjYWRlcyBvZiBwcmVjZWRlbmNlIHRoaXMgYmVoYXZpb3IgaGFz
IGFuZA0KdGhlcmVmb3JlIGhvdyBtdWNoIHlvdSBwb3RlbnRpYWxseSB3aWxsIGJyZWFrIHVzZXJz
cGFjZT8NCg0KVGhpcyBib2F0IGhhcyBzYWlsZWQgYSBsb25nIHRpbWUgYWdvIEknbSBhZnJhaWQu
DQoNCg==
