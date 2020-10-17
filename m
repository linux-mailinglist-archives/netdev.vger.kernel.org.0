Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B260290F83
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 07:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436601AbgJQFmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 01:42:02 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29152 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411693AbgJQFmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 01:42:01 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09H1BHxv016687;
        Fri, 16 Oct 2020 18:13:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=qxYRNYcBZHve6q7ipE5aq+bLghDuu6rqnpeeDfrN9fg=;
 b=CzEDcR62kEe2aZvIZKYTb3clvutZ9A/rzotv9PQ5j1NnbR4HKJFxDVEIvoDliidWezEg
 aDZ9MRJnfOsL7MKqa2eMeTFFryAzZMJBiRQmCV2mhxFHKPnfR1EaWDM6Z3P/1p831Kb+
 415qVz2qZas3b0m7FdyZ2PyLTfzM2uyD0DftMcX9/ZGtjX0ZxqP5bGQhmhJjPdCr2Iyo
 uhV5l+FVfwLO4WAnV2ALkpMXTSeSL0vF1CuRWrE9s1it5xKmlWKF32ovlSCgXuhLhFZ5
 3XEA8pQ/QcFA+/qAu9FLzO8LmglctwJ5Voj40FmkAC3YfohUWlSUNVyAm8NCEWDKFfE5 dA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 343cfjrst9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Oct 2020 18:13:21 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Oct
 2020 18:13:19 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Oct
 2020 18:13:19 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.57) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 16 Oct 2020 18:13:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1C9L8GHKLutubi7eqGCI3uZYxCPLh6JbryXTpx18kjAx1LZt3B2BQhCq/snEVeRdw6rFLk4xdGhJJFghACRQv1UMKSvzbUsa6WkSsO7HEh/HRrbroPdfYnDR+39q8t57d5PAvZmOAD2yQdUZeDT5XQGK80+xc2y3RjwitJYpQO4/OP6itJg+XyBKcq5KLIxA+ToGR6GJjUMYHFTfisHggBHI37drcAiav5zZAtR+b3ehnbuxkpkeQxJz/TwKF+SlN/54Itkpoy3jYJs66OzN92ZpkIZcoW2XcMmgNidzTnioTTXlYMDp2sv+690bOWVaK6fZVHX7lFr8nWRvTRR8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxYRNYcBZHve6q7ipE5aq+bLghDuu6rqnpeeDfrN9fg=;
 b=Wdkrx1nGOMxgwkQ1uu4aR7mzjzxIc05l8E4gP1tBt2PZiJDArqVOfakEpeH3Sd2q/HDTzWFL2miwU/uAePi5h+/mtFotvAkgKC+YP79Kmra4jJ135ke+MBA1P3Q86d+8XKS3yjeaCU6PgvYCu/CpiollNf2Bh8ofbg82L2pb0JnVzb5fgPl6hPUip3vQq/Gc/iOdGTar3YpKk0h8qpe64kJ5oLiOoHxZIib7aMsN/prMtz3CbRUuxPFBvfMOfukyTHxncq9edrQfF9K3RODx7bQRFB//5S0/DNUSVMSMB5OowV0PwiOELDlJtmpzc883xGdC8faGL14YJAONm+tL9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qxYRNYcBZHve6q7ipE5aq+bLghDuu6rqnpeeDfrN9fg=;
 b=lrRo8v/VUZYyVGSwvYK8fzmciBy7KA8OWvuEj9FRgWLhpxkniL/grxdKss2rdDWR+0AHPemC3qBpA3Aat1pacn/SFZm+BSRfFBy7kWgwsxk02ZLAk+SbeUHSBoNt8oODBLvxzjlKMfRvUCKLq/iNnkyUsaot0rHwD2Q4daRIego=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR1801MB1822.namprd18.prod.outlook.com (2603:10b6:301:6b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Sat, 17 Oct
 2020 01:13:18 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::69b0:73ce:7112:3b95]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::69b0:73ce:7112:3b95%7]) with mapi id 15.20.3455.031; Sat, 17 Oct 2020
 01:13:18 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>,
        "nitesh@redhat.com" <nitesh@redhat.com>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH v4 03/13] task_isolation: userspace hard
 isolation from kernel
Thread-Topic: [EXT] Re: [PATCH v4 03/13] task_isolation: userspace hard
 isolation from kernel
Thread-Index: AQHWYDdZDqoeqvfF50CzG3l43t/UoamDNPAAgATEYwCAAI5YAIABSVeAgAEHb4CAEKyCAA==
Date:   Sat, 17 Oct 2020 01:13:17 +0000
Message-ID: <98978b81e7eda04c256c3d837c36a032f5d475fb.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
         <b18546567a2ed61073ae86f2d9945257ab285dfa.camel@marvell.com>
         <20201001135640.GA1748@lothringen>
         <7e54b3c5e0d4c91eb64f2dd1583dd687bc34757e.camel@marvell.com>
         <20201004231404.GA66364@lothringen>
         <d0289bb9-cc10-9e64-f8ac-b4d252b424b8@redhat.com>
         <20201006103541.GA31325@lothringen>
In-Reply-To: <20201006103541.GA31325@lothringen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c5676cdc-75ee-4b49-5fba-08d87239d4bd
x-ms-traffictypediagnostic: MWHPR1801MB1822:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1801MB18223A1275DCAE4050719D73BC000@MWHPR1801MB1822.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3URA+X43WSV3Wb3OTUPp0tlhgi0d7Soi9DqIryds9a+p+VlnsELzCdogvbFyoM9WMq17Dgda5WcKzDSdA14TBP/RUFuusps37sdHCnGVXuWQGWoZlj2VzzC0hIS8A4HDUNHOMWHDrota90CobO0gUhFoUyBpz5x0Klh/KLoBErUX11vcMmBlIZlFzMmpiM4RkW+TLs2IRAA1JD5EyRNIxtVyRqW2oIYkVapk49UGDgknd1YQNgz80m35vmSeBA0WZsVBegLOblXBVwI75idbLLxYWBMWmb1GtyitGvY2sk/M7KKVgsZ3iam96bDi4YbXanVuajsK2ggNB77DLSPksw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(53546011)(6506007)(66476007)(66556008)(186003)(2616005)(86362001)(6486002)(4326008)(76116006)(91956017)(6512007)(316002)(66946007)(7416002)(8936002)(71200400001)(66446008)(64756008)(5660300002)(54906003)(2906002)(478600001)(26005)(110136005)(8676002)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: oBdLSWmrMTGPMPVGdZvFEzjKVgx1jgt+ob9L8IxL3ZO42nhX74QllPNmCdUT7rRLRA9ZW1pS2zlq2SZqnun/70ayWBq2rrzu+/gEhWd9Ajy1ljD8RBlFgqQm47qlZPmLzqNma7oxDNQ0RNGUa6nmCOJdSXQlHC8UEHsy27vvnk7TLqiB9OVB24lSU2jmzapjefnO50k3tUdZ86EZkHWaAMWNgHrqrVddOOibZcG7oryIWjlesJ/K+8z+qowi+MsfI3oq84A/d9SsBjXr+axQUrKCPrS3EfnanRTmpModrvoysv4Eg46oKDA8yQHyG+ii2vjRiiOu8CmnGvsdEy8eIGAjhvNUt7kNwdloQG3lYqj9QA4N8djOeKbwFxSMbsY15VZMVj4giEbjETdZ9CQf+pqeGKegfelXqbfPLBrIOu0KiycRj9AvS4O3B/v2KqoL+5yG27yUlc2ryKrc/To+/GrAoSSK/yTUWsaNRWAKYh8OrnrEU4gy2bIT3ZnUcP0V0OoT8BJYmh4MmMy1/7GYErpuqPKnZyhmjqj1yrawAYk33iiEyYki6d9xJy3wlOCfxTpJeboGL+w9d6VVN9Dele3jrkr0wZf1o8BUJAuq1FBXO7gofk2bIGI+5LC6TrZ1rbZNbgDz4g2DWmCCZIboLg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1C4E13D2BD46A429F475C927F23F3C9@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5676cdc-75ee-4b49-5fba-08d87239d4bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2020 01:13:17.9698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oVD0YUawy/yBvoyLQiyqgE1dtT2WqDqqQl35zKi2H7vXvisuK6WUcXkC6ejckHHKX+fQIh6oQeRlmT54v/QlOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1801MB1822
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-16_12:2020-10-16,2020-10-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUdWUsIDIwMjAtMTAtMDYgYXQgMTI6MzUgKzAyMDAsIEZyZWRlcmljIFdlaXNiZWNrZXIg
d3JvdGU6DQo+IE9uIE1vbiwgT2N0IDA1LCAyMDIwIGF0IDAyOjUyOjQ5UE0gLTA0MDAsIE5pdGVz
aCBOYXJheWFuIExhbCB3cm90ZToNCj4gPiBPbiAxMC80LzIwIDc6MTQgUE0sIEZyZWRlcmljIFdl
aXNiZWNrZXIgd3JvdGU6DQo+ID4gPiBPbiBTdW4sIE9jdCAwNCwgMjAyMCBhdCAwMjo0NDozOVBN
ICswMDAwLCBBbGV4IEJlbGl0cyB3cm90ZToNCj4gPiA+IA0KPiA+ID4gPiBUaGUgaWRlYSBiZWhp
bmQgdGhpcyBpcyB0aGF0IGlzb2xhdGlvbiBicmVha2luZyBldmVudHMgYXJlDQo+ID4gPiA+IHN1
cHBvc2VkIHRvDQo+ID4gPiA+IGJlIGtub3duIHRvIHRoZSBhcHBsaWNhdGlvbnMgd2hpbGUgYXBw
bGljYXRpb25zIHJ1biBub3JtYWxseSwNCj4gPiA+ID4gYW5kIHRoZXkNCj4gPiA+ID4gc2hvdWxk
IG5vdCByZXF1aXJlIGFueSBhbmFseXNpcyBvciBodW1hbiBpbnRlcnZlbnRpb24gdG8gYmUNCj4g
PiA+ID4gaGFuZGxlZC4NCj4gPiA+IFN1cmUgYnV0IHlvdSBjYW4gdXNlIHRyYWNlIGV2ZW50cyBm
b3IgdGhhdC4gSnVzdCB0cmFjZQ0KPiA+ID4gaW50ZXJydXB0cywgd29ya3F1ZXVlcywNCj4gPiA+
IHRpbWVycywgc3lzY2FsbHMsIGV4Y2VwdGlvbnMgYW5kIHNjaGVkdWxlciBldmVudHMgYW5kIHlv
dSBnZXQgYWxsDQo+ID4gPiB0aGUgbG9jYWwNCj4gPiA+IGRpc3R1cmJhbmNlLiBZb3UgbWlnaHQg
d2FudCB0byB0dW5lIGEgZmV3IGZpbHRlcnMgYnV0IHRoYXQncw0KPiA+ID4gcHJldHR5IG11Y2gg
aXQuDQo+IA0KPiBmb3JtYXRpb24sDQo+ID4gPiB5b3UgY2FuIHRyYWNlIHRoZSB3b3JrcXVldWUg
YW5kIHRpbWVyIHF1ZXVlIGV2ZW50cyBhbmQganVzdA0KPiA+ID4gZmlsdGVyIHRob3NlIHRoYXQN
Cj4gPiA+IHRhcmdldCB5b3VyIGlzb2xhdGVkIENQVXMuDQo+ID4gPiANCj4gPiANCj4gPiBJIGFn
cmVlIHRoYXQgd2UgY2FuIGRvIGFsbCB0aG9zZSB0aGluZ3Mgd2l0aCB0cmFjaW5nLg0KPiA+IEhv
d2V2ZXIsIElNSE8gaGF2aW5nIGEgc2ltcGxpZmllZCBsb2dnaW5nIG1lY2hhbmlzbSB0byBnYXRo
ZXIgdGhlDQo+ID4gc291cmNlIG9mDQo+ID4gdmlvbGF0aW9uIG1heSBoZWxwIGluIHJlZHVjaW5n
IHRoZSBtYW51YWwgZWZmb3J0Lg0KPiA+IA0KPiA+IEFsdGhvdWdoLCBJIGFtIG5vdCBzdXJlIGhv
dyBlYXN5IHdpbGwgaXQgYmUgdG8gbWFpbnRhaW4gc3VjaCBhbg0KPiA+IGludGVyZmFjZQ0KPiA+
IG92ZXIgdGltZS4NCj4gDQo+IFRoZSB0aGluZyBpczogdHJhY2luZyBpcyB5b3VyIHNpbXBsaWZp
ZWQgbG9nZ2luZyBtZWNoYW5pc20gaGVyZS4gWW91DQo+IGNhbiBhY2hpZXZlDQo+IHRoZSBzYW1l
IGluIHVzZXJzcGFjZSB3aXRoIF93YXlfIGxlc3MgY29kZSwgbm8gcmFjZSwgYW5kIHlvdSBjYW4g
ZG8NCj4gaXQgaW4NCj4gYmFzaC4NCg0KVGhlIGlkZWEgaXMgdGhhdCB0aGlzIG1lY2hhbmlzbSBz
aG91bGQgYmUgdXNhYmxlIHdoZW4gbm8gb25lIGlzIHRoZXJlDQp0byBydW4gdGhpbmdzIGluIGJh
c2gsIG9yIG5vIGluZm9ybWF0aW9uIGFib3V0IHdoYXQgbWlnaHQgaGFwcGVuLiBJdA0Kc2hvdWxk
IGJlIGFibGUgdG8gcmVwb3J0IHJhcmUgZXZlbnRzIGluIHByb2R1Y3Rpb24gd2hlbiB1c2VycyBt
YXkgbm90DQpiZSBhYmxlIHRvIHJlcHJvZHVjZSB0aGVtLg0KDQotLSANCkFsZXgNCg==
