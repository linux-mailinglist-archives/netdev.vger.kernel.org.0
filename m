Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D72449F55
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 01:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241127AbhKIAQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 19:16:33 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:32762 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229618AbhKIAQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 19:16:33 -0500
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A8M3ZQh006073;
        Mon, 8 Nov 2021 16:13:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=A9FfbxxwYvn7JEK7y/8zWiEE35W+GNLBA/ZfoRNvmWE=;
 b=GkC3Dl+Esu0sHOMjuCJVqgmgBq83s6cKo9g5rCGYOzx14iO2aqjEpGYmSpgJ2xNdBfZI
 ZU789Cztkus/QNuzqioDxMMuBJZstc06kqiZlLjTZMkZiWue0YYSyvrvvempwHcn0GKj
 XOKnyv7WFxaCBmu+54pYAOlkz9sz+iwEx4WReQUuJTo8j01KZV7xbzgi8xN8gQrmEmmQ
 w/RCAjpCj4ruJ+zptDbeD8svEqz1TvKeBViL2XJd8r03035t0cdtBlqFF1pS+e3SPErr
 FuxHNJ97z69ukAtOXGQ+HggpFuPNv60TYdKu3CfzWBsL0Py+wOPo4ta8vc3cVYnOZ2rh /w== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3c6pp2jf9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 16:13:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUKnADy3RNN7Ady4XCK2QAheBNGjWHQ4knts7bzFHWtjOJFMEXdlizpksPmag0kym0ZVQEQXmWocPlnouA80EG1P7VhVRiSML0oAON3cNWg5//Z5+BN4sNoX1i2HPlj90BJM1hsOI5JE01etd9LrXXDTM61e7uxWbQKIQzarXr2V+9no4zUPPFR2dwtvPY1L03D4gSXwRqiSitYnJvae+Grnhi24qR/1Sy5Abw5Ql/KGYt0aUjjsWtIcsKh4ALMVS6xDt9wr5c/rOF77ZgwgKGoa7gWyA3Xvv4fPLtDAWXo9jw+tds8/w2RPhJXKLdIT3DbOIlGioUu4voqUbQZCDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A9FfbxxwYvn7JEK7y/8zWiEE35W+GNLBA/ZfoRNvmWE=;
 b=X3uCAyUJhbHEjEQsG1KmZeBPA47n4RuZIkHTZlU9boFfzMiqy2h138/EV8LW97NGjBch4ntZQT7T7widHFk1vRMMjp/eKEnq711Rj49vi+CBFgvgrQyaQxLGl6Gu01PdBr3KiMoZhrapDFAeZ642zYtBoW5MjfVAENw5bwU1qHl2/z5lTBywr05Fwxr/ltI5GozHaj+Len09J9OePFpj4+1wnSj5p8V+zQbVRhkSz8T0nZxFTDiaEFJOr+PjVuEIdGF/FD0yPA/YG5dP69u1R7pWAcrk0Mg4bMGUJQmARFPs3L8jlxNHPGUZPt8K+/5ZZxdN+fPEu9Qgf2ezccN6LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by CH0PR02MB8044.namprd02.prod.outlook.com (2603:10b6:610:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Tue, 9 Nov
 2021 00:13:42 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::6448:2a3:f0a9:a985]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::6448:2a3:f0a9:a985%5]) with mapi id 15.20.4669.015; Tue, 9 Nov 2021
 00:13:42 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] vsock: prevent unnecessary refcnt inc for nonblocking
 connect
Thread-Topic: [PATCH net] vsock: prevent unnecessary refcnt inc for
 nonblocking connect
Thread-Index: AQHX08+iaRxaWehrakq2MtCAeCXF3qv5ThOAgAEHmIA=
Date:   Tue, 9 Nov 2021 00:13:41 +0000
Message-ID: <08D0B495-870A-47A2-B4B2-EE391FBDE3C5@nutanix.com>
References: <20211107120304.38224-1-eiichi.tsukata@nutanix.com>
 <20211108083013.svl77coopyryngfl@steredhat>
In-Reply-To: <20211108083013.svl77coopyryngfl@steredhat>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29c35407-0a0c-4b0b-49d0-08d9a315c987
x-ms-traffictypediagnostic: CH0PR02MB8044:
x-microsoft-antispam-prvs: <CH0PR02MB804409B3E26BB82C3EAEA52C80929@CH0PR02MB8044.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7+80sWL5OIquWyTsOMOJwKUVFdPY79b7QP+xMjYFlhep3YcV61us3qnBziuL+PNVhcWolFJaQmpa/zG+3AmScC7Cvgjs036xNX3pEbVqj7r1Cx+SNHwquf/muuxsBum2v0fe/BkFpabA7ngxTJW4dywfBrfqszViWdPCA+eTzsllyF0wtmqQZGJgMA54vvea/26HjMpshRMIRRXsel8lYYwDpj9czIZybX7XmwkilW/kgbEwnHP0D/BBGRFYQSdVQDWzGmo3ImiXNxW1Lwiv70rLMJYzUz7fTl6gAr6k0qhDTId/56Dk2HNAXy3GIh8Gjto9S9bsGxuOxTIpjf0xoxXkRdsLJJgpZ7wWorJAZiDp24Q3/gDK7BmyOacNmemEKqC566rBKlaDVBYvb2YKk0ykLYUvaFo/w0hfnQ6KO1cnDmyf9TiARagJTQDTrzKrJmmF10+P5YhqGHSQkcJGqY2Lzab4fXaHbMksEMUh87kz7XZ1iRFEhAXD/7p/IN+ADEt/CV75BuwsYeE6JP5jHM+F83ZGW9LHQiT8Ta9wnEshiFhGPrdiIT6veuG/o/TW6/SqSl35Ubq1XrMULJJTP7yVVRHXVEqY7Gxv+/dQ7xkVFrOXseX9Vi8e3Nv1EBjpTBXF27TtWuZW8LwJScZbcD5b9ahWWIYRGbCYQa9SM7Jsny9aXid+KFBgfRm0+AT3zxHu5ruKkscFMoLAIbKzPirishHpSdE0XgaOEVOq9ws=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(4326008)(44832011)(6486002)(6506007)(508600001)(36756003)(2906002)(122000001)(38070700005)(86362001)(2616005)(6512007)(33656002)(38100700002)(4744005)(316002)(5660300002)(54906003)(66556008)(8676002)(83380400001)(76116006)(53546011)(66946007)(6916009)(91956017)(64756008)(66446008)(26005)(66476007)(186003)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U3I5MHFPdnpkWkFOaE9SNTA1TXNidEJPVFBDWHhXb2t4L09jNjRabTg3WHhS?=
 =?utf-8?B?SjgxRXlHSDYwNEtqcGxmUDg2Syt4Mm01cnVRUTZyN1F5Y1RpVFZUd05sUkR4?=
 =?utf-8?B?dGs2UTNZTmFwNlZqSXAxYm5rSjNkLzEybXRUbTdKTGNOV1VEenN2Mmo5eDdt?=
 =?utf-8?B?M0lFOTBveDk3OEU0NDZGdG5KWjh5ZWxIVHlvWTlXa1N2ZElkdUljZmJlcFFI?=
 =?utf-8?B?emNVZC9tNkkrdUhqenJZVUhhZUNPaHptOTI2R0IraHdCb1NVQVA3Q3ZtTGRM?=
 =?utf-8?B?bVlCbmdPb0wyWTAvWFVGZU1sSVpJNkZnNDRSQ090YkVCNHN0QitGb0huUHA1?=
 =?utf-8?B?TTk1Z2p1RStYdXhNeGFaMjBKK1JBbjF4SXJMRjM5Z0cybHNBNDRzRW4wY1pm?=
 =?utf-8?B?YjZmRm5xTEFWKzdCdFdmT3pnbU9aaFhsR1h6YUYzalRUdWhlZEJEZC9KQjFF?=
 =?utf-8?B?Um4rcXdRSXVKQzhqS3N5dWpoc3ZGaGFKZm9jRklOSFVPdWFqb2R6VnAzV3BZ?=
 =?utf-8?B?STFUY21Pdkdpd2MzYlpGdnJkT3JGWHBYSkp3ZmZROHdtV0VjVFlkSkZKR2gr?=
 =?utf-8?B?Y25ZU3RPa0JuSGI3QStBQk8zMEtJdGIzSGM3eW9qNnp4NFlBc2VQS2VXMTFX?=
 =?utf-8?B?dlhzdEMwOHhieFVabThaYmVrZ01lV08rZHd5SXlhY2dadjEyeUduNVQ4NU9s?=
 =?utf-8?B?bWlQclJOb0c2QkpaeEZadkRWUk9jcC9IeGxjSjBwT3NiMjJyY2hDYlFVa2ZS?=
 =?utf-8?B?QXFQOE9JNXNWUGgwcVR6b3RJNXRycVd4em8veldqQ08zaE1OZjBicEgyWTZl?=
 =?utf-8?B?OC9IOXNUbDJwb1NMS3YzeTc3dGNsN3hXNmhaeW5lYXNQaEVpbk5zakwzMUZQ?=
 =?utf-8?B?MkQvK0FjTmZlZWd4cklpcTVuZnI5VzBqUE9ydzViczgyM0NQTU45Z2R4aHZ3?=
 =?utf-8?B?L0pPS21LNnFVRGxFVG1wZEY1N3krTm5qakR0Sy80dmVUa0pESVdwQjFZbTVo?=
 =?utf-8?B?dFAwOVNsK0RhSmN1Z2c3V3dEbGUvcjBhUVBtRUY4OHVsczJRQUd5STZPY2JD?=
 =?utf-8?B?b1d5K2JnR3YzWmgwMjZwa2tBZGE4ZVRiVDE0YjV6K2wyZjBXVEgxc25rcmhp?=
 =?utf-8?B?ZzUzanNMa0liM050aVg1TkJ6ZWZBVGhaenlES0J6ZmlxcjZXNmJNY0IvTzN2?=
 =?utf-8?B?ZXM1RkprOE1nNTBXZkdOQjROYkw4bEwrbnJORHJGME80VjlMdWF5RkJEMkVS?=
 =?utf-8?B?YkxNZUdITitZMWMyeDhiOTJWSldxQTZJY1BzSWdzNitoREpubVNBR3VpUVVW?=
 =?utf-8?B?dDBYd1JUdS9HdW1EcWE0d3B2U3VDZ2RLR0pyNy9sTkVSZTRwRXl4T0xNUm5x?=
 =?utf-8?B?VjRiVSt1cUhqZDc2dldTRkIrSlI0S081Tm1nSkIwRU50bGsxb3RGc29SeFQw?=
 =?utf-8?B?ZUUxTmhuOExJUSszYmFBWFdxVGpYK2R5TGIvSmg1ckJPWUxGSXRNNTl5QTRY?=
 =?utf-8?B?UFhBQTZsenEway9JeUpBdktZYjdCQllmYldSZ1h2UExBWkMvWFdrQ2JBYitT?=
 =?utf-8?B?TDJWSjBpdVFUV1cyQjY4ZW1tekI0VXdFRE5QeGFZeGUwT1B4UmJCV3VLZGls?=
 =?utf-8?B?NDdjQ0hEdlZpV2U4RnFFSzUvYnZUSWxHY01veFI4ZjYwSS9ORDZkSVFjZXE0?=
 =?utf-8?B?emRIV3FwM285VUlRdnk4SFRaMEJmdWwzSFdjc2FHcWR0S1JQK09QaW5IQ0ky?=
 =?utf-8?B?THFZU3pmbHpFc3FYYTVnME5IQkl3ZVVwZnBKdHpxQTJqdUJ2ay9INC9ENTFZ?=
 =?utf-8?B?Rnd4dG9Bc1NrcWZzU3Q0OTlwMytZSWRrN3dMSlZaZDZjdWppVmFVM2t5Y2Za?=
 =?utf-8?B?YU43L1RrTjQrdGpvTkd1RDI1M2hjVkpuNkxqQVF2VXFMSVdTUWR2U09maHQx?=
 =?utf-8?B?YXFXQm90bWVVU3I0K2lIWXFNNUNWaTROOUkzZm5XWFZMZU1zUXJJcitNWS91?=
 =?utf-8?B?VXNRRlRTcGhvUFNwaSsySTd5VlhnYzlSbjI1TkFTQ1NVSGdvMzlOU3lNbHRX?=
 =?utf-8?B?WXlkam4zdkJjNytXSnJsSy9pZnlFSnFzUThQQkZuanEvNGlYTVFiSk5PZHVu?=
 =?utf-8?B?bXh3TzV4Z1JubDNUOGdFaWM2ZGdVbm1Tbm9odUF1ejB0RWlIekVFZ0EzYktG?=
 =?utf-8?B?UzYvaFlBQVNwdndiTFVsMDBwV1pXbTRYNENDalNuWWVUSllxRUxXbW5wQTI3?=
 =?utf-8?B?UFh6dnB6azdGTjBWVmlVNWZDZVhRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4FAE6C6ABB76A04E88DAF396C2C477D5@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c35407-0a0c-4b0b-49d0-08d9a315c987
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 00:13:41.9228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8sPam1NiSyI2MCTYNN8STriD2YnAO1zKFgsJQ9adjyWnPyqgTqoOjVmazvS2mlw1SBMsXbPIdI3MWVRHDFL/obf93bqIG1evJ0LBGpPIkr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8044
X-Proofpoint-GUID: ueRCs4zWUomcquJX9bUBAXjVz4tAxIZK
X-Proofpoint-ORIG-GUID: ueRCs4zWUomcquJX9bUBAXjVz4tAxIZK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_07,2021-11-08_02,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTm92IDgsIDIwMjEsIGF0IDE3OjMwLCBTdGVmYW5vIEdhcnphcmVsbGEgPHNnYXJ6
YXJlQHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gT24gU3VuLCBOb3YgMDcsIDIwMjEgYXQgMTI6
MDM6MDRQTSArMDAwMCwgRWlpY2hpIFRzdWthdGEgd3JvdGU6DQo+PiBDdXJyZW50bHkgdm9zY2tf
Y29ubmVjdCgpIGluY3JlbWVudHMgc29jayByZWZjb3VudCBmb3Igbm9uYmxvY2tpbmcNCj4+IHNv
Y2tldCBlYWNoIHRpbWUgaXQncyBjYWxsZWQsIHdoaWNoIGNhbiBsZWFkIHRvIG1lbW9yeSBsZWFr
IGlmDQo+PiBpdCdzIGNhbGxlZCBtdWx0aXBsZSB0aW1lcyBiZWNhdXNlIGNvbm5lY3QgdGltZW91
dCBmdW5jdGlvbiBkZWNyZW1lbnRzDQo+PiBzb2NrIHJlZmNvdW50IG9ubHkgb25jZS4NCj4+IA0K
Pj4gRml4ZXMgaXQgYnkgbWFraW5nIHZzb2NrX2Nvbm5lY3QoKSByZXR1cm4gLUVBTFJFQURZIGlt
bWVkaWF0ZWx5IHdoZW4NCj4+IHNvY2sgc3RhdGUgaXMgYWxyZWFkeSBTU19DT05ORUNUSU5HLg0K
Pj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBFaWljaGkgVHN1a2F0YSA8ZWlpY2hpLnRzdWthdGFAbnV0
YW5peC5jb20+DQo+PiAtLS0NCj4+IG5ldC92bXdfdnNvY2svYWZfdnNvY2suYyB8IDIgKysNCj4+
IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gDQo+IE1ha2Ugc2Vuc2UgdG8gbWUs
IHRoYW5rcyBmb3IgZml4aW5nIHRoaXMgaXNzdWUhDQo+IEkgdGhpbmsgd291bGQgYmUgYmV0dGVy
IHRvIGFkZCB0aGUgRml4ZXMgcmVmIGluIHRoZSBjb21taXQgbWVzc2FnZToNCj4gDQo+IEZpeGVz
OiBkMDIxYzM0NDA1MWEgKCJWU09DSzogSW50cm9kdWNlIFZNIFNvY2tldHMiKQ0KPiANCj4gV2l0
aCB0aGF0Og0KPiBSZXZpZXdlZC1ieTogU3RlZmFubyBHYXJ6YXJlbGxhIDxzZ2FyemFyZUByZWRo
YXQuY29tPg0KPiANCj4gVGhhbmtzLA0KPiBTdGVmYW5vDQo+IA0KDQpUaGFua3MgZm9yIGNvbW1l
bnRzISBJ4oCZbGwgYWRkIEZpeGVzIGFuZCBSZXZpZXdlZC1ieSB0YWcgdGhlbiBzZW5kIHYyLg0K
DQpFaWljaGk=
