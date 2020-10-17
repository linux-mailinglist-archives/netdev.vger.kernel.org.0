Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BFF290F48
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 07:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411727AbgJQFdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 01:33:38 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39286 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2407466AbgJQFdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 01:33:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09H0A2lk014152;
        Fri, 16 Oct 2020 17:17:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=3c7PfFBtp90M4ddyms7ICtlv9IQbMvFQpoc3UyFOhDU=;
 b=WIx9EzENj6fnSBGDaHyqbvofOp2TObZVVM3tdN+HtFuEKJJGz/9WMA09kDYpa2jt8YZF
 +MCweSTRM9lalHgOP5qSrEW5OhI7mQd5RkOa+ybaqf08gCObeKULQ3Xx8YTWmVpl5+Qq
 zuh7e9mBzrPDsk0ISbkaL+yTW5Adz64/8zJ+psL552nM7lFbq1ThrUQcdCRfj9T/ihoE
 Nya5kW4uA3AzRdAluUIVp8AHQnBykm8TcUKayAIIHINW9x2vOp3GIigQQMToLiHpwOYA
 O3JbETYxyZeEOZBqo571bwV9IWLVWZHRQdMcFJxsonwZdFJd5rINly09vCK1im+zpS1q XA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 343aap1qsm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 16 Oct 2020 17:17:30 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Oct
 2020 17:17:30 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 16 Oct
 2020 17:17:29 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.56) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 16 Oct 2020 17:17:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmV5r2SSKLB3fwaqjk/C4zLb9ZxEbBcCnqvw8x27dAMsRZQXAbLZ4AWB4YOImbnDsylg9K29alwMMULEpfdOc7QkqbWwtOwpwSKO4nA/hn1rHBR6bg8iiP++xz9uqOMTxO+qMxpzC9CUdAfxWHquHOnxk2BSygF5joAlbizJJiLq4rYPKQvavbwCJ1uyMImnUWueNnfJDF1TQvJ/ux0Ak28vGnm8jFZrGKIIj3qWszAB0Y8osbqYlhEsx8mKgxGPsDHIC+0ZON5/GwVKR3xRnsbv1bmAThdqVnIdnvGaxNBDcMU7OXo7NG7qyk5ahv5euMftv/YuqkoJ217El0LZYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3c7PfFBtp90M4ddyms7ICtlv9IQbMvFQpoc3UyFOhDU=;
 b=VnWhpkpZINgVztvmDB8BjCBcDpSYCyJLv1gYSIbixq4HK5B4jNiWiJXFZvsbuYVrWnEjdIDq5h01lPbXLjOk4lIcB1PfYg6j0HPoQ5HCZyBFcmYCVB6lwP/quHhUxeWTT8XES5CaQDbASkTlFReixIUAUpNv6fl+5ROESR1AQEAwIMZRGRBkT6UtEnrWRtB9WkunJUZxGbRhYcTL81ms5cepBocUvnN1Mxg6tPCGMGvSgeMQ1E/IEssMHbZMsnk6l6H2HZk6A5CUo2+MbfuncrMg6166UNiUM+Xeh5lwPYkXOKtReLvLw0IKM6WBQGAX4y2+1GL5sXUUNQ/nXId7Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3c7PfFBtp90M4ddyms7ICtlv9IQbMvFQpoc3UyFOhDU=;
 b=Ry3Fw7y3zFo4QpLGNXrrJtBz8Aui/t5ZObhfIoM/iPYh1jiI2dimggfrlN6zcOnkcDaVC2baTl0I3JcXRkcVopxzVvDdnKiy+tDZ9UQb1bKUGK4Bz8Wj0OUtfiZrfM9hRqVFdmLaLW15XjFpD1Az2+St5KEi6YRpWSjEO6F9Q4Q=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by CO6PR18MB3987.namprd18.prod.outlook.com (2603:10b6:5:34e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Sat, 17 Oct
 2020 00:17:25 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::69b0:73ce:7112:3b95]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::69b0:73ce:7112:3b95%7]) with mapi id 15.20.3455.031; Sat, 17 Oct 2020
 00:17:25 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>
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
Subject: Re: [EXT] Re: [PATCH v4 10/13] task_isolation: don't interrupt CPUs
 with tick_nohz_full_kick_cpu()
Thread-Topic: [EXT] Re: [PATCH v4 10/13] task_isolation: don't interrupt CPUs
 with tick_nohz_full_kick_cpu()
Thread-Index: AQHWYDhuh3VfINlM20KwSBz5WuaF0amDQmgAgATBZ4CAA46SgIAP4vOA
Date:   Sat, 17 Oct 2020 00:17:24 +0000
Message-ID: <5b9b9ff8e90d98ad8b3c2aaf65c3088c463eb15d.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
         <5acf7502c071c0d1365ba5e5940e003a7da6521f.camel@marvell.com>
         <20201001144454.GB6595@lothringen>
         <ab85fd564686845648d08779b1d4ecc3ab440b2a.camel@marvell.com>
         <20201006214113.GA38684@lothringen>
In-Reply-To: <20201006214113.GA38684@lothringen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdde0565-e876-445f-87e2-08d872320662
x-ms-traffictypediagnostic: CO6PR18MB3987:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3987B120899F49613A42F3C6BC000@CO6PR18MB3987.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c8ewBcaKnFshBX+G7nx3WP1+VyqYccBEuApcOobur3RmGVqqsg0N6C/L5bRtiBMHx4ohFXBGoYEJtps8lXKnd8hy0PtZhqZRUHM5mu2EVBeEZTPQmQ/69oza1GXRcyPTeOftWTtGMJeHeIxmla6mS8hDJmzTQSxq4pEXogEqU4+X4I1dfcsj6SGsS8MYiF8pLxuu/WWSpsy+cD9e77221gBneIEzvzXrXgbYnnLB8F/amIqx9h4dostPrcBfMJaUseP3H4ENk99ZI91fe8+OkfwwXM+W5uQZm6A2ZYYifznyrxeirrxYktKp0XSmOlNyQmUV0Ni4qZqocFfDS7VK5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(71200400001)(66556008)(6486002)(6916009)(4326008)(8676002)(6512007)(478600001)(186003)(86362001)(7416002)(2906002)(5660300002)(76116006)(2616005)(36756003)(64756008)(83380400001)(66446008)(66476007)(66946007)(6506007)(54906003)(91956017)(26005)(316002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: nfwIm+sVwpr+T82QHA39cg2bV8KLx+Z5ZZq12qxJMcsoq8w1njD7SPFLGeBg+YDtugcczy+a4j/YkWeE0gTTDJaSsABry/0tqf+4qoiPQJe7wLJET/neZVwunj/rd1Pgae+mjq6oMKBYEGgXrCsF4YPnxA6ZR9hAOwbTXsIm4InmLZMDCr6xqhDXJn+6HhxkPSgKHdbtWdS/I/nb7i9BJrbepTQcT7QIttwCKk5hDLB/Hsk0tFUx7AW5SdTHSI0yXNKWm0XN7Sn0JjxZwXAUbtr9FImn6AxAlxrn26bhVgN+pSU4SuyEB0Twc20V8rpcUEZ6NkdcLyAAwTiPcY9UePIqpz17zlPNTvmqZeNU+cGOrDXEA68pk5/WKLeFEr8I5lrZL1GkX6w0g2sOGm9Bn+mtCl8eDlIVgvLuJyCDbNPdQz0avL9W2gVAo+QiIGHajBFfCp1SsF3QBi4RN/6esZXcxDUpCbJjzwtpJSw8Q1AqfNXUDjb8QxxXKuHFjvxRDuPUrlj5eEL8wbemLflcRmXZ36zMtRtJhJj9nblFqtodFXczF+tDVcFD7Kve/aMV1klU8CFViw8uTfHm2xVsql7DWgmcEs4GHgLlRIHhfqFCg1e7S1esXwRQvYwT5c4hoxjFfE6vker4hvSYhYEjFQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4E498FC4B890B4E9B996BD1B65649FA@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdde0565-e876-445f-87e2-08d872320662
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2020 00:17:25.2927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PMN82s7yEAdrAcqsMyGKGyage2BiRrHcVtVx+eHjUVnwkesLoGTuFu0/EKIusbnoDfN3Jp9XOU6ZeYna8rcGng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3987
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-16_12:2020-10-16,2020-10-16 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUdWUsIDIwMjAtMTAtMDYgYXQgMjM6NDEgKzAyMDAsIEZyZWRlcmljIFdlaXNiZWNrZXIg
d3JvdGU6DQo+IE9uIFN1biwgT2N0IDA0LCAyMDIwIGF0IDAzOjIyOjA5UE0gKzAwMDAsIEFsZXgg
QmVsaXRzIHdyb3RlOg0KPiA+IE9uIFRodSwgMjAyMC0xMC0wMSBhdCAxNjo0NCArMDIwMCwgRnJl
ZGVyaWMgV2Vpc2JlY2tlciB3cm90ZToNCj4gPiA+ID4gQEAgLTI2OCw3ICsyNjksOCBAQCBzdGF0
aWMgdm9pZCB0aWNrX25vaHpfZnVsbF9raWNrKHZvaWQpDQo+ID4gPiA+ICAgKi8NCj4gPiA+ID4g
IHZvaWQgdGlja19ub2h6X2Z1bGxfa2lja19jcHUoaW50IGNwdSkNCj4gPiA+ID4gIHsNCj4gPiA+
ID4gLQlpZiAoIXRpY2tfbm9oel9mdWxsX2NwdShjcHUpKQ0KPiA+ID4gPiArCXNtcF9ybWIoKTsN
Cj4gPiA+IA0KPiA+ID4gV2hhdCBpcyBpdCBvcmRlcmluZz8NCj4gPiANCj4gPiBsbF9pc29sX2Zs
YWdzIHdpbGwgYmUgcmVhZCBpbiB0YXNrX2lzb2xhdGlvbl9vbl9jcHUoKSwgdGhhdCBhY2Nyc3MN
Cj4gPiBzaG91bGQgYmUgb3JkZXJlZCBhZ2FpbnN0IHdyaXRpbmcgaW4NCj4gPiB0YXNrX2lzb2xh
dGlvbl9rZXJuZWxfZW50ZXIoKSwgZmFzdF90YXNrX2lzb2xhdGlvbl9jcHVfY2xlYW51cCgpDQo+
ID4gYW5kIHRhc2tfaXNvbGF0aW9uX3N0YXJ0KCkuDQo+ID4gDQo+ID4gU2luY2UgdGFza19pc29s
YXRpb25fb25fY3B1KCkgaXMgb2Z0ZW4gY2FsbGVkIGZvciBtdWx0aXBsZSBDUFVzIGluDQo+ID4g
YQ0KPiA+IHNlcXVlbmNlLCBpdCB3b3VsZCBiZSB3YXN0ZWZ1bCB0byBpbmNsdWRlIGEgYmFycmll
ciBpbnNpZGUgaXQuDQo+IA0KPiBUaGVuIEkgdGhpbmsgeW91IG1lYW50IGEgZnVsbCBiYXJyaWVy
OiBzbXBfbWIoKQ0KDQpGb3IgcmVhZC1vbmx5IG9wZXJhdGlvbj8gdGFza19pc29sYXRpb25fb25f
Y3B1KCkgaXMgdGhlIG9ubHkgcGxhY2UNCndoZXJlIHBlci1jcHUgbGxfaXNvbF9mbGFncyBpcyBh
Y2Nlc3NlZCwgcmVhZC1vbmx5LCBmcm9tIG11bHRpcGxlIENQVXMuDQpBbGwgb3RoZXIgYWNjZXNz
IHRvIGxsX2lzb2xfZmxhZ3MgaXMgZG9uZSBmcm9tIHRoZSBsb2NhbCBDUFUsIGFuZA0Kd3JpdGVz
IGFyZSBmb2xsb3dlZCBieSBzbXBfbWIoKS4gVGhlcmUgYXJlIG5vIG90aGVyIGRlcGVuZGVuY2ll
cyBoZXJlLA0KZXhjZXB0IG9wZXJhdGlvbnMgdGhhdCBkZXBlbmQgb24gdGhlIHZhbHVlIHJldHVy
bmVkIGZyb20NCnRhc2tfaXNvbGF0aW9uX29uX2NwdSgpLg0KDQpJZi93aGVuIG1vcmUgZmxhZ3Mg
d2lsbCBiZSBhZGRlZCwgdGhvc2UgcnVsZXMgd2lsbCBiZSBzdGlsbCBmb2xsb3dlZCwNCmJlY2F1
c2UgdGhlIGludGVudGlvbiBpcyB0byBzdG9yZSB0aGUgc3RhdGUgb2YgaXNvbGF0aW9uIGFuZCBw
aGFzZXMgb2YNCmVudGVyaW5nL2JyZWFraW5nL3JlcG9ydGluZyBpdCB0aGF0IGNhbiBvbmx5IGJl
IHVwZGF0ZWQgZnJvbSB0aGUgbG9jYWwNCkNQVXMuDQoNCj4gDQo+ID4gPiA+ICsJaWYgKCF0aWNr
X25vaHpfZnVsbF9jcHUoY3B1KSB8fA0KPiA+ID4gPiB0YXNrX2lzb2xhdGlvbl9vbl9jcHUoY3B1
KSkNCj4gPiA+ID4gIAkJcmV0dXJuOw0KPiA+ID4gDQo+ID4gPiBZb3UgY2FuJ3Qgc2ltcGx5IGln
bm9yZSBhbiBJUEkuIFRoZXJlIGlzIGFsd2F5cyBhIHJlYXNvbiBmb3IgYQ0KPiA+ID4gbm9oel9m
dWxsIENQVQ0KPiA+ID4gdG8gYmUga2lja2VkLiBTb21ldGhpbmcgdHJpZ2dlcmVkIGEgdGljayBk
ZXBlbmRlbmN5LiBJdCBjYW4gYmUNCj4gPiA+IHBvc2l4DQo+ID4gPiBjcHUgdGltZXJzDQo+ID4g
PiBmb3IgZXhhbXBsZSwgb3IgYW55dGhpbmcuDQoNClRoaXMgd2FzIGFkZGVkIHNvbWUgdGltZSBh
Z28sIHdoZW4gdGltZXJzIGFwcGVhcmVkIGFuZCBDUFVzIHdlcmUga2lja2VkDQpzZWVtaW5nbHkg
b3V0IG9mIG5vd2hlcmUuIEF0IHRoYXQgcG9pbnQgYnJlYWtpbmcgcG9zaXggdGltZXJzIHdoZW4N
CnJ1bm5pbmcgdGFza3MgdGhhdCBhcmUgbm90IHN1cHBvc2VkIHRvIHJlbHkgb24gcG9zaXggdGlt
ZXJzLCB3YXMgdGhlDQpsZWFzdCBwcm9ibGVtYXRpYyBzb2x1dGlvbi4gRnJvbSB1c2VyJ3MgcG9p
bnQgb2YgdmlldyBpbiB0aGlzIGNhc2UNCmVudGVyaW5nIGlzb2xhdGlvbiBoYWQgYW4gZWZmZWN0
IG9uIHRpbWVyIHNpbWlsYXIgdG8gdGFzayBleGl0aW5nIHdoaWxlDQp0aGUgdGltZXIgaXMgcnVu
bmluZy4NCg0KUmlnaHQgbm93LCB0aGVyZSBhcmUgc3RpbGwgc291cmNlcyBvZiBzdXBlcmZsdW91
cyBjYWxscyB0byB0aGlzLCB3aGVuDQp0aWNrX25vaHpfZnVsbF9raWNrX2FsbCgpIGlzIHVzZWQu
IElmIEkgd2lsbCBiZSBhYmxlIHRvIGNvbmZpcm0gdGhhdA0KdGhpcyBpcyB0aGUgb25seSBwcm9i
bGVtYXRpYyBwbGFjZSwgSSB3b3VsZCByYXRoZXIgZml4IGNhbGxzIHRvIGl0LCBhbmQNCm1ha2Ug
dGhpcyBjb25kaXRpb24gcHJvZHVjZSBhIHdhcm5pbmcuDQoNClRoaXMgZ2l2ZXMgbWUgYW4gaWRl
YSB0aGF0IGlmIHRoZXJlIHdpbGwgYmUgYSBtZWNoYW5pc20gc3BlY2lmaWNhbGx5DQpmb3IgcmVw
b3J0aW5nIGtlcm5lbCBlbnRyeSBhbmQgaXNvbGF0aW9uIGJyZWFraW5nLCBtYXliZSBpdCBzaG91
bGQgYmUNCnBvc3NpYmxlIHRvIGFkZCBhIGRpc3RpbmN0aW9uIGJldHdlZW46DQoNCjEuIGlzb2xh
dGlvbiBicmVha2luZyB0aGF0IGFscmVhZHkgaGFwcGVuZWQgdXBvbiBrZXJuZWwgZW50cnk7DQoy
LiBwZXJmb3JtaW5nIG9wZXJhdGlvbiB0aGF0IHdpbGwgaW1tZWRpYXRlbHkgYW5kIHN5bmNocm9u
b3VzbHkgY2F1c2UNCmlzb2xhdGlvbiBicmVha2luZzsNCjMuIG9wZXJhdGlvbnMgb3IgY29uZGl0
aW9ucyB0aGF0IHdpbGwgZXZlbnR1YWxseSBvciBhc3luY2hyb25vdXNseQ0KY2F1c2UgaXNvbGF0
aW9uIGJyZWFraW5nIChoYXZpbmcgdGltZXJzIHJ1bm5pbmcsIHBvc3NpYmx5IHNlbmRpbmcNCnNp
Z25hbHMgc2hvdWxkIGJlIGluIHRoZSBzYW1lIGNhdGVnb3J5KS4NCg0KVGhpcyB3aWxsIGJlICgy
KS4NCg0KSSBhc3N1bWUgdGhhdCB3aGVuIHJlcG9ydGluZyBvZiBpc29sYXRpb24gYnJlYWtpbmcg
d2lsbCBiZSBzZXBhcmF0ZWQNCmZyb20gdGhlIGlzb2xhdGlvbiBpbXBsZW1lbnRhdGlvbiwgaXQg
d2lsbCBiZSBpbXBsZW1lbnRlZCBhcyBhIHJ1bnRpbWUNCmVycm9yIGNvbmRpdGlvbiByZXBvcnRp
bmcgbWVjaGFuaXNtLiBUaGVuIGl0IGNhbiBiZSBmb2N1c2VkIG9uDQpwcm92aWRpbmcgaW5mb3Jt
YXRpb24gYWJvdXQgY2F0ZWdvcnkgb2YgZXZlbnRzIGFuZCB0aGVpciBzb3VyY2VzLCBhbmQNCmhh
dmUgaW50ZXJuYWwgbG9naWMgZGVzaWduZWQgZm9yIHRoYXQgcHVycG9zZSwgYXMgb3Bwb3NlZCB0
byBkZXNpZ25lZA0KZW50aXJlbHkgZm9yIGRlYnVnZ2luZywgcHJvdmlkaW5nIGZsZXhpYmlsaXR5
IGFuZCBvYnRhaW5pbmcgbWF4aW11bQ0KZGV0YWlscyBhYm91dCBpbnRlcm5hbHMgaW52b2x2ZWQu
DQoNCj4gPiANCj4gPiBJIHJlYWxpemUgdGhhdCB0aGlzIGlzIHVudXN1YWwsIGhvd2V2ZXIgdGhl
IGlkZWEgaXMgdGhhdCB3aGlsZSB0aGUNCj4gPiB0YXNrDQo+ID4gaXMgcnVubmluZyBpbiBpc29s
YXRlZCBtb2RlIGluIHVzZXJzcGFjZSwgd2UgYXNzdW1lIHRoYXQgZnJvbSB0aGlzDQo+ID4gQ1BV
cw0KPiA+IHBvaW50IG9mIHZpZXcgd2hhdGV2ZXIgaXMgaGFwcGVuaW5nIGluIGtlcm5lbCwgY2Fu
IHdhaXQgdW50aWwgQ1BVDQo+ID4gaXMNCj4gPiBiYWNrIGluIGtlcm5lbCBhbmQgd2hlbiBpdCBm
aXJzdCBlbnRlcnMga2VybmVsIGZyb20gdGhpcyBtb2RlLCBpdA0KPiA+IHNob3VsZCAiY2F0Y2gg
dXAiIHdpdGggZXZlcnl0aGluZyB0aGF0IGhhcHBlbmVkIGluIGl0cyBhYnNlbmNlLg0KPiA+IHRh
c2tfaXNvbGF0aW9uX2tlcm5lbF9lbnRlcigpIGlzIHN1cHBvc2VkIHRvIGRvIHRoYXQsIHNvIGJ5
IHRoZQ0KPiA+IHRpbWUNCj4gPiBhbnl0aGluZyBzaG91bGQgYmUgZG9uZSBpbnZvbHZpbmcgdGhl
IHJlc3Qgb2YgdGhlIGtlcm5lbCwgQ1BVIGlzDQo+ID4gYmFjaw0KPiA+IHRvIG5vcm1hbC4NCj4g
DQo+IFlvdSBjYW4ndCBhc3N1bWUgdGhhdC4gSWYgc29tZXRoaW5nIG5lZWRzIHRoZSB0aWNrLCB0
aGlzIGNhbid0IHdhaXQuDQo+IElmIHRoZSB1c2VyIGRpZCBzb21ldGhpbmcgd3JvbmcsIHN1Y2gg
YXMgc2V0dGluZyBhIHBvc2l4IGNwdSB0aW1lcg0KPiB0byBhbiBpc29sYXRlZCB0YXNrLCB0aGF0
J3MgaGlzIGZhdWx0IGFuZCB0aGUga2VybmVsIGhhcyB0byBzdGljaw0KPiB3aXRoDQo+IGNvcnJl
Y3RuZXNzIGFuZCBraWNrIHRoYXQgdGFzayBvdXQgb2YgaXNvbGF0aW9uIG1vZGUuDQoNClRoYXQg
d291bGQgYmUgdHJ1ZSBpZiBub3QgbXVsdGlwbGUgImxldCdzIGp1c3QgdGVsbCBhbGwgb3RoZXIg
Q1BVcyB0aGF0DQp0aGV5IHNob3VsZCBjaGVjayBpZiB0aGV5IGhhdmUgdG8gdXBkYXRlIHNvbWV0
aGluZyIgc2l0dWF0aW9ucyBsaWtlIHRoZQ0KYWJvdmUuDQoNCkluIGNhc2Ugb2YgdGltZXJzIGl0
J3MgcG9zc2libGUgdGhhdCBJIHdpbGwgYmUgYWJsZSB0byBlbGltaW5hdGUgYWxsDQpzcGVjaWZp
YyBpbnN0YW5jZXMgd2hlbiB0aGlzIGlzIGRvbmUsIGhvd2V2ZXIgSSB0aGluayB0aGF0IGFzIGEg
Z2VuZXJhbA0KYXBwcm9hY2ggd2UgaGF2ZSB0byBlc3RhYmxpc2ggc29tZSBkaXN0aW5jdGlvbiBi
ZXR3ZWVuIHRoaW5ncyB0aGF0IG11c3QNCmNhdXNlIElQSSAoYW5kIGJyZWFrIGlzb2xhdGlvbikg
YW5kIHRoaW5ncyB0aGF0IG1heSBiZSBkZWxheWVkIHVudGlsDQp0aGUgaXNvbGF0ZWQgdXNlcnNw
YWNlIHRhc2sgd2lsbCBhbGxvdyB0aGF0IG9yIHNvbWUgb3RoZXIgdW5hdm9pZGFibGUNCmlzb2xh
dGlvbi1icmVha2luZyBldmVudCB3aWxsIGhhcHBlbi4NCg0KPiANCj4gPiBJdCBpcyBhcHBsaWNh
dGlvbidzIHJlc3BvbnNpYmlsaXR5IHRvIGF2b2lkIHRyaWdnZXJpbmcgdGhpbmdzIHRoYXQNCj4g
PiBicmVhayBpdHMgaXNvbGF0aW9uDQo+IA0KPiBQcmVjaXNlbHkuDQoNClJpZ2h0LiBIb3dldmVy
IHRoZXJlIGFyZSB0aW5ncyBsaWtlIHRpY2tfbm9oel9mdWxsX2tpY2tfYWxsKCkgYW5kDQpzaW1p
bGFyIHByb2NlZHVyZXMgdGhhdCByZXN1bHQgaW4gbWFzcy1zZW5kaW5nIG9mIElQSXMgd2l0aG91
dA0KZGV0ZXJtaW5pbmcgaWYgdGFyZ2V0IENQVXMgaGF2ZSBhbnl0aGluZyB0byBkbyB3aXRoIHRo
ZSBldmVudCBhdCBhbGwsDQpsZWF2ZSBhbG9uZSBoYXZlIHRvIGhhbmRsZSBpdCByaWdodCBub3cs
IGl0IGRvZXMgbm90IGdpdmUgbWUgYW4NCmltcHJlc3Npb24gdGhhdCB3ZSBjYW4gYmxhbWUgYXBw
bGljYXRpb24gZm9yIGl0LiBJIHJlYWxpemUgdGhhdCB0aGlzIGlzDQpkb25lIGZvciBhIHJlYXNv
biwgd2l0aCB0aGUgYXNzdW1wdGlvbiB0aGF0IHNlbmRpbmcgSVBJcyBpcyAiY2hlYXBlciINCmFu
ZCBkb2VzIG5vdCByZXF1aXJlIGNvbXBsZXggc3luY2hyb25pemF0aW9uIGNvbXBhcmVkIHRvIGRl
dGVybWluaW5nDQp3aGF0IGFuZCB3aGVuIHNob3VsZCBiZSBub3RpZmllZCwgaG93ZXZlciB0aGlz
IGlzIG5vdCBjb21wYXRpYmxlIHdpdGgNCmdvYWxzIG9mIHRhc2sgaXNvbGF0aW9uLg0KDQo+IA0K
PiA+IHNvIHRoZSBhcHBsaWNhdGlvbiBhc3N1bWVzIHRoYXQgZXZlcnl0aGluZyB0aGF0DQo+ID4g
aW52b2x2ZXMgZW50ZXJpbmcga2VybmVsIHdpbGwgbm90IGJlIGF2YWlsYWJsZSB3aGlsZSBpdCBp
cw0KPiA+IGlzb2xhdGVkLg0KPiANCj4gV2UgY2FuJ3QgZG8gdGhpbmdzIHRoYXQgd2F5IGFuZCBq
dXN0IGlnbm9yZSBJUElzLiBZb3UgbmVlZCB0byBzb2x2ZQ0KPiB0aGUNCj4gc291cmNlIG9mIHRo
ZSBub2lzZSwgbm90IHRoZSBzeW1wdG9tcy4NCg0KSXQgbWF5IGJlIHRoYXQgZXZlbnR1YWxseSB3
ZSBjYW4gY29tcGxldGVseSBlbGltaW5hdGUgdGhvc2UgdGhpbmdzIChhdA0KbGVhc3Qgd2hlbiBp
c29sYXRpb24gaXMgZW5hYmxlZCBhbmQgdGhpcyBpcyByZWxldmFudCksIGhvd2V2ZXIgZm9yIHRo
ZQ0KcHVycG9zZSBvZiBoYXZpbmcgdXNhYmxlIGNvZGUgd2l0aG91dCBtYXNzaXZlIGNoYW5nZXMg
aW4gbnVtZXJvdXMNCmNhbGxlcnMsIGluIG15IG9waW5pb24sIHdlIHNob3VsZCBhY2tub3dsZWRn
ZSB0aGF0IHNvbWUgdGhpbmdzIHNob3VsZA0KYmUgZGlzYWJsZWQgd2hpbGUgdGhlIHRhc2sgaXMg
aXNvbGF0ZWQsIGFuZCBjYWxsZWQgb24gaXNvbGF0aW9uIGV4aXQgLS0NCmVpdGhlciB1bmNvbmRp
dGlvbmFsbHkgb3IgY29uZGl0aW9uYWxseSBpZiB0aGV5IHdlcmUgcmVxdWVzdGVkIHdoaWxlDQp0
aGUgdGFzayB3YXMgaXNvbGF0ZWQuDQoNCkkgYmVsaWV2ZSB0aGF0IGFzIGxvbmcgYXMgd2UgY3Jl
YXRlIGEgZGlzdGluY3Rpb24gYmV0d2VlbiAibXVzdCBicmVhaw0KaXNvbGF0aW9uIiwgImRlbGF5
ZWQgdW50aWwgdGhlIGVuZCBvZiBpc29sYXRpb24iIGFuZCAiY2FuIGJlIHNhZmVseQ0KaWdub3Jl
ZCBpZiB0aGUgdGFzayBpcyBpc29sYXRlZCIgSVBJcywgd2Ugd2lsbCBlbmQgdXAgd2l0aCBsZXNz
DQppbnRydXNpdmUgY2hhbmdlcyBhbmQgcmVsaWFibHkgd29ya2luZyBmdW5jdGlvbmFsaXR5Lg0K
DQpUaGVuIGlmIHdlIHdpbGwgYmUgYWJsZSB0byBlbGltaW5hdGUgdGhlIHNvdXJjZXMgb2YgdGhp
bmdzIGluIHRoZSBsYXN0DQp0d28gY2F0ZWdvcmllcywgd2UgY2FuIHRyZWF0IHRoZW0gYXMgaWYg
dGhleSB3ZXJlIGluIHRoZSBmaXJzdCBvbmUuDQoNCkl0IG1heSBiZSB0aGF0IHRoZSB0aW1lcnMg
YXJlIGFscmVhZHkgcmVhZHkgdG8gdGhpcywgYW5kIEkgc2hvdWxkIGp1c3QNCmNoZWNrIHdoYXQg
Y2F1c2VzIHRpY2tfbm9oel9mdWxsX2tpY2tfYWxsKCkgY2FsbHMuIElmIHNvLCB0aGlzDQpwYXJ0
aWN1bGFyIGNoZWNrIHdvbid0IGJlIG5lY2Vzc2FyeSBiZWNhdXNlIGFsbCBjYWxscyB3aWxsIGhh
cHBlbiBmb3IgYQ0KZ29vZCByZWFzb24gaW4gc2l0dWF0aW9ucyBjb250cm9sbGVkIGJ5IGFwcGxp
Y2F0aW9uLiBIb3dldmVyIGFzIGENCmdlbmVyYWwgYXBwcm9hY2ggSSB0aGluaywgd2UgbmVlZCB0
aGlzIGxvbmdlciB3YXkgd2l0aCBkZWNpc2lvbnMgYWJvdXQNCmRlbGF5aW5nIG9yIGlnbm9yaW5n
IGV2ZW50cy4NCg0KLS0gDQpBbGV4DQo=
