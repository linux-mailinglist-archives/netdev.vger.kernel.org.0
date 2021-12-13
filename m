Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603B0472AB5
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhLMK5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:57:47 -0500
Received: from mail-gv0che01on2106.outbound.protection.outlook.com ([40.107.23.106]:19873
        "EHLO CHE01-GV0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231713AbhLMK5p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 05:57:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDENbbdAcc0dP1h7zDpUijaOTdLidB3r3zhYrtav1U514GxIoE3alzUO+aottsRVKWlUW39xpWCx6Rilre5vPBsjqVRLOQFfJaJsCGxRmhgyPv+OmSNxNxjv2CnaTitvxdZCbrvtP2Cv5ESHejzjX5dDXqPha9lb2k5/RSFleLIWcOfdaa7EsEERYYQum9zmp7zN2Ont+Y204IkXivJgn4VBZ0AjmeMK7P1pPDv16ER6r8QLbvbflDlNoaZzJ8a4EBtZS9M8QSLIzBFxJui+fbM0iMztkQ/R/rMN3D1L3++HEUCxX0MHpHSQ6nT/qNstca95JYDaFYROQDT1jlN1dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ihZeQWm68J0phKc5VTVwn/z5ScLrvNC9WqzQnRZ08A=;
 b=AM+Ma4uDs4UmVyWxHYMOnEr2Anc0CDyK942ldgpkQ/wdeoqZavwtyJUp1/bC7ON3IBIyiv2E044iWCQ0wDs4v+Bc4hp1W6N6+j78V++HpqLYS4Zq5y9Hyp5YXmEkuY7C7lbrWZZ/jatGPGg/qTdjm+YzkEAqu81ZLpNPpqHazzT5ImveWdj5uB3jL2Emmy6qLHofiIg2dehncHEUavFJaOHz+8N2RF+Etdz8r6+BUzTuOBztpmJqGhrFhKMuxOlaNhgW6SudL8hFEZoFpUJVwzFp/CUV6j8s5NVhyXEj7E5dHKhuQ4fmFGVd/Qr+Jfws5EhPFt7XDXkr+VWtN7KqUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ihZeQWm68J0phKc5VTVwn/z5ScLrvNC9WqzQnRZ08A=;
 b=Tv2K8SKNEPigHxyK2xuXLozwxGHMH5SCZFFRHTXpxDqNZvqMXUiQ5W5+yl6+fJ3qE4jfk9mQwjwrr0Ewc+1gXsCboKgLOyIV4JxNZjeyDLWT4O0IS8lUWZoNpUsg41KQ+zFQuAefc3en9CBnCqL+djp6zpNVOSfq//h1eJGf7Fs=
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by ZRAP278MB0335.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Mon, 13 Dec
 2021 10:57:42 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e5c4:5c29:1958:fbea%8]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 10:57:42 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>
CC:     "festevam@gmail.com" <festevam@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: perform a PHY reset on resume
Thread-Topic: [PATCH net-next] net: phy: perform a PHY reset on resume
Thread-Index: AQHX7o9S3gJitJa0r0m/sbVpicrHs6wwQ2CA
Date:   Mon, 13 Dec 2021 10:57:42 +0000
Message-ID: <395977d1161591814bcadad2c1e9bbdc519f12c6.camel@toradex.com>
References: <7a4830b495e5e819a2b2b39dd01785aa3eba4ce7.camel@toradex.com>
         <20211211130146.357794-1-francesco.dolcini@toradex.com>
In-Reply-To: <20211211130146.357794-1-francesco.dolcini@toradex.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9021468b-4f0f-4033-bb91-08d9be2762ec
x-ms-traffictypediagnostic: ZRAP278MB0335:EE_
x-microsoft-antispam-prvs: <ZRAP278MB033535DBF9C53F0F263E5958F4749@ZRAP278MB0335.CHEP278.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: We8EwX4frexqLEqc5fe0V4i8GJvFeySJNRGNzt6GrkBl8vNDE2KzWz8wcQuF0hOJhP/id/QpPKraHmtLFSzFgFNsH94bW1SLuVtKqKJVQUPWHHC5x46iWJdQCg9/Xw7r1LLuHaB7dbUrF36cA/IVT8tgJnNmYs4/PNzhDRs9hY6i/eN2DoTNPr/U4LJZ2gIr6WELT9CcdfD6Rl1ad+kxyMougctJUKUvpcHKc/YErskUC129LbmKIMd8GUFdBgItf4YJt3RlrKap6ClXwqHTnhgsMNFqS2ampHtUGxjTLc4RCJVNRH1uorCrN7QfalJZCpbp7bErMWYX5c+M5Pb+mz9fsI4Uclf26zK1HBVzTuPwbKVWbVN2ipXj2kVzmecDpBVS+5kQNmeqm95mtwwD82X05lV0NlIw59jRgYBJX6VorXObG3MPiRGsc33juWHM1MD4/PEC8aL3948txEg9HVmSTyVhtcZsfi/demb51i78eHC6UF9UtUFEY5Z+5Lb34WKG8EsBXQB8CSVCyYcdsaQ3WLPfREs2JBmeCMIaD7FFYSgKPFAI+AJFW00yger5/r04X9ZiJudKvoca1iAgY2TK2DM1MbFcxqCHFDDXLywfRNErxsNj4o7iudd1oeo+lxx146g7YfArx3PZetg0geegoW6gM6xAT0Lh8QVdRyNysH8LB1VNmAwMvdSygTgSHSnFncMrrZEYSwrzYZTkclPb+/D+n781H173V/Bab3GObeV023ry0ZhfC3bWZALRfyEqlUWGxu5TQdTXhO/O87wFEc2Gv4jXu9yrIdcoXGE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(44832011)(122000001)(54906003)(110136005)(83380400001)(71200400001)(91956017)(4001150100001)(508600001)(8676002)(86362001)(38070700005)(38100700002)(2616005)(6506007)(8936002)(36756003)(4326008)(5660300002)(6512007)(966005)(66476007)(26005)(66556008)(66946007)(64756008)(2906002)(6486002)(186003)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VCtVdkZrNVNaZVdNZHUxMGF0UE5zS2Z2YzNkWFlrQUxScFJYei8rU251KzNt?=
 =?utf-8?B?RmU4L3gzYXJ4bzZXbGpGQ00wc2pCN3FzZjlLcUMzNWxWOGprbFo1U2FpWWR0?=
 =?utf-8?B?TFh3a2pKUW1VbUQrNUNxQ0gvVExFbVZuK3JPRVJZU2ZHZHBSeWV6SmtHdzV3?=
 =?utf-8?B?NVI2NlA5a3oyZUZUSVYzbEhORnkyakVNdDd1aXJCKzBDK3RSYWhEeGppZm5q?=
 =?utf-8?B?VjZ0L3Z2UXdQMzF3SWNTWnBZQ2o4bjhjYWZWaSt4cGphV1JJUHJnbjNXR2ZP?=
 =?utf-8?B?ekdmYkJ2cGQ2eFlqaUFWdUdxS29mVDRrUFNHUnYxaEsrMmx0TFA4UVo1MTBJ?=
 =?utf-8?B?dVlQdk82dExTZXkyQ3o1TzVYQTZ4TWtxNnBqMUR4VzN3eTlUZ3MvRDYxREZC?=
 =?utf-8?B?REdIN0phVTRCUk91WXZucTdYVGpkbGxZUTRkd0hQTlJBZ2c4NnpJZkl3NzRj?=
 =?utf-8?B?OG9FS1FrK1c4ZVZBY3hUQ3EyL2ROWVJaTVdQRGpsZVpOUmR2RzV3Lzd1KzdT?=
 =?utf-8?B?S0RtV2ZZKzlYbzU4YUFqa3N0U0hpd3lqOFdzd3lubEdkekFCQXZuVnAyYXNB?=
 =?utf-8?B?RUJmSWt6Uk9iTlVjcmdMY2tRS3p2ZGd4azFYZ0pYTUdmT2Z0Y2tLcGJMY3dx?=
 =?utf-8?B?aytFRmNjdkFvejMvSXM0bjAyQjQvaWpBMXFkdGNkNTFncVEvRGMwS3lOYXl1?=
 =?utf-8?B?STZkOU1yTjVPMmZ5TnRNU1pOeTMrVGNGTi82YlEvaC9GVk5MQ0Y5M2lsdTNw?=
 =?utf-8?B?RzRwWWtJa0RCZnlvdldVTndMeDhEU2duRWNoRG5RNU5FcXM1eW8veWFFd3lr?=
 =?utf-8?B?UE5Fa210aGkwdHpQMTdWNFRzTGY5Sk80cFA5RXRPOVRJcFFsZzBkaDdFSE5q?=
 =?utf-8?B?c2dZVzNUSjVWSGtrejNWQnE2VzFDdEUvOXZ1VjFqd0tNWEJ6YmxMWm5IVVBT?=
 =?utf-8?B?TlVuZ3ZhOXBkeXE2SGpRUDdOWFcvbnVvSG1OVGd1Z05vM3hRUnRIR0gzVlhi?=
 =?utf-8?B?OW03OGNDZFUxeVFVNGxMaEFDT1JhK1l2a0pMOWQwUldFZmFUTTkyUDdWSzZO?=
 =?utf-8?B?Zldxek5UV3NFVDdtd2VRU284aHJvTnpZdE1KM29qaGFoR1hIUUdRNEREQlk0?=
 =?utf-8?B?eGhpOGo2MEkvU0dDVnNjdEhJVlo1NGNKeFN1QzNXNE15UXBGNnJsRUFTUkQv?=
 =?utf-8?B?dXFHckZTVU9wbm9rTTJwNkwvMmI5NlJtYTlNYjNHMkhZSEs5Q3V0V1o1aXVH?=
 =?utf-8?B?R09tWmlrdCtpbzlrajNQRVI1eEVGd3A1d01yb3ExZE16R1F2YzNXM0hYWmNR?=
 =?utf-8?B?T05nOGh6Y0creG16WmliOFVhaVd6WXRoTnJOMjZvZXlTK3VZREVrc2FwSVZn?=
 =?utf-8?B?WjBUMWhUK1I4YnZhTXFYbnl0M1hJdGlJcUZoeWl0UERVb0pELzBnNFcxc212?=
 =?utf-8?B?bVMxcnh5OE9TcGlxUWJQQTBReVlidy9jOUdYRXd2bVJOL1M5cnI3QTI3ZGhW?=
 =?utf-8?B?M0JUa1VBbzloOUFNeHFBalhOYzYrUkh4QTROMXErRFpZSVhzZ2VxcUpjaDlB?=
 =?utf-8?B?ajM1VXN6bTlKQ3ptZEpuSWVIaDhTcFREaU1EYXEzcHFaTmhZZmp1TG5xeGQ5?=
 =?utf-8?B?OUVlU0kvT2JualpFdjJ0a1hqTVpsL3JCbmRiYnpPMlJ5ZjdzT2RvR3ZCcVEx?=
 =?utf-8?B?Q3lOWmp3b1ovcnZNL0kwckdiZWJBRFFuVXA4aHpKVE4xRVowbWpWcFpvTWxQ?=
 =?utf-8?B?anQraHNIekdkSlN6Zy94dm41NnlsYUN1MGhNbnhnYUtHSXozamJYL3FhSm9x?=
 =?utf-8?B?Q0lkcGNyc3lBVStWbm1jMFM5K1lRTTI1eHk0WlJ1MTl1cWtYZ2h5VnJHOUt0?=
 =?utf-8?B?SHI5RGo0UXUzM2JGS1FxYytSNG9ndkJRUWU1VEg5Y3JsbHZ0ME5hdkFQcHpm?=
 =?utf-8?B?NXYxK0F3QmtRQVhudDl1K2wxbjAwVW1nOGtnY0RrZTV5TTFCVkhpSjBHbWYr?=
 =?utf-8?B?U2JtblcwUU94VTVzMmhBdFdQazc5OHlqaVNDYkdKazQvTW1vTjROUnd1TXpJ?=
 =?utf-8?B?MmFTVWlwQkZtTUtmWWRkWnBCdHF0TTcrWFcrUHJOKyt2S3RqV3AxWThGT2VF?=
 =?utf-8?B?dG9zYlVKQ3BmR2F0ald6amh4WXpJNHFHcGZpNUdQdGRkd0tpRlYrbTkxbC9N?=
 =?utf-8?B?QTNaQTFTekJSQmpnZFdvYWUyQVZFb0cvZXFRdzFRQ2tqeXlVUzExWTVmWDBz?=
 =?utf-8?Q?LlBW4ylSVQkW3vIOmHWSbO+0YmgvwfGm4O6q4RARD0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <57674DF0F8A8E542A1036A0F2B2A0184@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 9021468b-4f0f-4033-bb91-08d9be2762ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 10:57:42.1433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: evAq9d5JqUdp1gfq/1azft5GXp3/SA3TVTBlngmUSZ7VbAJsr4yNA+RWXCdIwYf+5CP46x1QUnSsZp612Z/7KtG1/Em5Mbs0MGG9T0Fs5/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0335
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIxLTEyLTExIGF0IDE0OjAxICswMTAwLCBGcmFuY2VzY28gRG9sY2luaSB3cm90
ZToNCj4gUGVyZm9ybSBhIFBIWSByZXNldCBpbiBwaHlfaW5pdF9odygpIHRvIGVuc3VyZSB0aGF0
IHRoZSBQSFkgaXMgd29ya2luZw0KPiBhZnRlciByZXN1bWUuIFRoaXMgaXMgcmVxdWlyZWQgaWYg
dGhlIFBIWSB3YXMgcG93ZXJlZCBkb3duIGluIHN1c3BlbmQNCj4gbGlrZSBpdCBpcyBkb25lIGJ5
IHRoZSBmcmVlc2NhbGUgRkVDIGRyaXZlciBpbiBmZWNfc3VzcGVuZCgpLg0KPiANCj4gTGluazoN
Cj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzIwMjExMjA2MTAxMzI2LjEwMjI1Mjct
MS1waGlsaXBwZS5zY2hlbmtlckB0b3JhZGV4LmNvbS8NCj4gU2lnbmVkLW9mZi1ieTogRnJhbmNl
c2NvIERvbGNpbmkgPGZyYW5jZXNjby5kb2xjaW5pQHRvcmFkZXguY29tPg0KPiANCj4gLS0tDQo+
IA0KPiBQaGlsaXBwZTogd2hhdCBhYm91dCBzb21ldGhpbmcgbGlrZSB0aGF0PyBPbmx5IGNvbXBp
bGUgdGVzdGVkLCBidXQgSQ0KPiBzZWUgbm8gcmVhc29uIGZvciB0aGlzIG5vdCBzb2x2aW5nIHRo
ZSBpc3N1ZS4NCj4gDQo+IEFueSBkZWxheSByZXF1aXJlZCBvbiB0aGUgcmVzZXQgY2FuIGJlIHNw
ZWNpZmllZCB1c2luZyByZXNldC1hc3NlcnQtDQo+IHVzL3Jlc2V0LWRlYXNzZXJ0LXVzLg0KDQpU
aGF0IHdvdWxkIG9mIGNvdXJzZSBiZSB0aGUgZWFzaWVzdCB3YXkuIEhvd2V2ZXIgSSB1bmRlcnN0
YW5kIFJ1c3NlbCdzDQpjb25jZXJucyBoZXJlLCBhcyBldmVyeSBQSFkgaXMgYWdhaW4gZGlmZmVy
ZW50IGFuZCB0aGlzIGlzIGJhc2ljYWxseSBhDQpoYXJkd2FyZS1zcGVjaWZpYyBkZXNpZ24uDQoN
CkkgbGlrZSBKb2FraW4ncyBpZGVhIHRvIGFkZCBhIHBoeV9yZXNldF9hZnRlcl9wb3dlcl9vbigp
IGZ1bmN0aW9uIGluDQpwaHlsaWIgc2ltaWxhciB0byBwaHlfcmVzZXRfYWZ0ZXJfY2xrX2VuYWJs
ZSgpLiBJIHdpbGwgcHJlcGFyZSBhDQpwYXRjaHNldCBmb3IgdGhhdCBzbyB3ZSBjYW4gZGlzY3Vz
cyBmdXJ0aGVyIHRoZXJlLg0KDQpQaGlsaXBwZQ0KPiANCj4gLS0tDQo+IMKgZHJpdmVycy9uZXQv
cGh5L3BoeV9kZXZpY2UuYyB8IDMgKystDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9w
aHlfZGV2aWNlLmMNCj4gYi9kcml2ZXJzL25ldC9waHkvcGh5X2RldmljZS5jDQo+IGluZGV4IDc0
ZDhlMWRjMTI1Zi4uN2VhYjBjMDU0YWRmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9waHkv
cGh5X2RldmljZS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9waHlfZGV2aWNlLmMNCj4gQEAg
LTExNTgsNyArMTE1OCw4IEBAIGludCBwaHlfaW5pdF9odyhzdHJ1Y3QgcGh5X2RldmljZSAqcGh5
ZGV2KQ0KPiDCoHsNCj4gwqDCoMKgwqDCoMKgwqDCoGludCByZXQgPSAwOw0KPiDCoA0KPiAtwqDC
oMKgwqDCoMKgwqAvKiBEZWFzc2VydCB0aGUgcmVzZXQgc2lnbmFsICovDQo+ICvCoMKgwqDCoMKg
wqDCoC8qIHBoeSByZXNldCByZXF1aXJlZCBpZiB0aGUgcGh5IHdhcyBwb3dlcmVkIGRvd24gZHVy
aW5nDQo+IHN1c3BlbmQgKi8NCj4gK8KgwqDCoMKgwqDCoMKgcGh5X2RldmljZV9yZXNldChwaHlk
ZXYsIDEpOw0KPiDCoMKgwqDCoMKgwqDCoMKgcGh5X2RldmljZV9yZXNldChwaHlkZXYsIDApOw0K
PiDCoA0KPiDCoMKgwqDCoMKgwqDCoMKgaWYgKCFwaHlkZXYtPmRydikNCg0K
