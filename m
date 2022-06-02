Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B117553B5EC
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 11:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbiFBJWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 05:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbiFBJWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 05:22:39 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2053.outbound.protection.outlook.com [40.107.95.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5531EEEC;
        Thu,  2 Jun 2022 02:22:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNTYuuWEsGUZp5cvE2NPMw4ZgQWaNQIMovjPdOSJY1o2kMUL/M+dJyZmKUWgbQBrdUkNuX9RsRoxgJ81xeTrbj9LsAR0pbsG15Lt+25myjZQnqBNziAySjyCnl6L/EIVNWSYum1LAVPQEuI8JcK/+shkb72N8yqFRtOMleh0KBZAJj/RV58wQWppDb4kw0ONsvbYIlvYvqmmXT99LWEktsgCNA2yuBQlaBAI2yorQqVajdWSRKZA1WZppOhtJ7Mi4ooPSu/F7dTXTSWrbjDl/wcFuvyGL2FJANh6qBK1jD+ExweuRoL8UFwwU4vhLfeaEEelhpeGMJGkw96FHgWXxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SQ1yEqMgHHA06JYZ6UeJXysn6GDZ7CYqmS7H1ZDu0M=;
 b=n5qUFvo8PztWA1QmIqA5wrXfA5RKuFpOJ/bbboP+uLWZk+D2pwvb/ivsJU9OQIXsuZRtf+3FOLM1v8ukTCoGdpABmJcSxdJHoyTtoWOWM/NUOmLpz3hV4T8e1hBtj6SZJWLO3tOzUINIG3kZ4N+vfoWTIjv4JvV8rVGtDQG/pvthUfC7Iefj6XYQ26rXtD9SEpuVNvQJCFefwtvSm1rgGVSJJO/H1yjtyDM3UXmCEOZTyCeFJbW6J1SxDxzCcXl0bsXyVgpa9rb69agDCo9/AtmTP664L/dspogsarNm/6CghZVm4zhWGzRye6ihoS2gZ7u5iDCS9vp/36cAV787sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SQ1yEqMgHHA06JYZ6UeJXysn6GDZ7CYqmS7H1ZDu0M=;
 b=Mkk/kr/xjE+94hwvq6IyVNyWAGNSzRku/Jdb+VbzbfCdNfr9gKzUlPaq9R24+xAf8OyKbZ8wMqGO8YwfkQ2HQphxf9K/+BQEuRBqDQxi8FSIyxrghOPxpw8s9Yt7ad4bsR8w8AOB7L7xOnNgZlFZoIxu1JdgLmkSeuDc6U7IPkc=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by DM6PR10MB4044.namprd10.prod.outlook.com (2603:10b6:5:1d0::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 09:22:34 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5%5]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 09:22:34 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface is
 down
Thread-Topic: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Thread-Index: AQHYdhitF3sF8MdKyEyE/FAADx5cL607THmAgACL6YA=
Date:   Thu, 2 Jun 2022 09:22:34 +0000
Message-ID: <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
         <20220601180147.40a6e8ea@kernel.org>
In-Reply-To: <20220601180147.40a6e8ea@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f53afdea-70d0-4c04-2903-08da44796da1
x-ms-traffictypediagnostic: DM6PR10MB4044:EE_
x-microsoft-antispam-prvs: <DM6PR10MB404432B303FD666479905EEBF4DE9@DM6PR10MB4044.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sek9gpVv0MWWUmQ7ux/rPTDYndpChy+7TfYMpfpdBJhFgSzjX+m8BIs+acRhUaPqPKkhSPAp8QaOmhDROrqXydxtnH8CFTPJXxBFZcNrcypgZUDfebboj1pHS9NKSleutUZj3xHwFt+nHaK+WgQizpHalw0ec90GAgfx6UES0sxRAH156ylAx1IHm0cZ6u9Xo6udM15Aqu3aG4jAMFV0e2MI0ZElanRdotMS8oZzgtVeUdU8SR231rIebZBY5IIbNb/1UJbLMbZg05ulbDN2TwGHtF5sV2O3SX5Ixcp+5ldXKPGkyPXMF/d1A5nL66T7W1iAsqc/wG/h6NIZnzn2iD2TipIcy56QDkfN6vGhQmmBfU8Jx66OZ5EqaKeTd4ukROjvF7VS1C+SBEUtdcyrs3/LhA7bKRa/XQ2dz2T2Hb0NlLvt4sUtBFwnxlbHpy0Ew1dFIhDDDx4ZlJxGKZsyiKv9LA1sLYWUAGi2L4ZVDU8mEncNGV5Y8VNLin2BzvaVZLRHBN9q/eSZBwxNW/O9cqYGPd4/Z8bM+Kc7PszcaRZrafsen3as4u1Iq0ca3V5KxEvBKIXEgLvRVs0Ov69tccs6OL2Qmh8LH2N1RFrJakouJ/rcuFNJziZJv+SzqCETV7pwcO1Pne0/d0tWJzqJS3bVIsUjtP280pZuCCPysYt/gweVqp4Muhodo2+Uxx1xj782LdDLVlyoZ09VX/a5nA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(86362001)(8936002)(6512007)(38100700002)(6506007)(508600001)(5660300002)(186003)(122000001)(6486002)(2616005)(76116006)(71200400001)(66946007)(91956017)(38070700005)(66556008)(66476007)(66446008)(64756008)(8676002)(316002)(4326008)(36756003)(54906003)(6916009)(83380400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RlQxOGFSMkFyWURMT0JJcld0N3Z0T0hRbDdIS2dweHM5ZVEzRUduY2NSbVI5?=
 =?utf-8?B?b2NXWHBxa1F6akgvNGZ2OG5EaGZiTEVBLzlPY2hDd0RJZDNNNXdlNTQxb0Jy?=
 =?utf-8?B?Uk9MeHVTOE9IeFRyWVlOWnlYZUV4MXpLVlVZdVZHVkRyQm1TdlpUT3kyWktu?=
 =?utf-8?B?QkFPK3FxWTJpN08wMUtZQVFpakVjc0FTbVB2andhQXVoNXg2aG9NQS9CVzFx?=
 =?utf-8?B?N2pzTTBOYXVGMDM0N3FMN2l0eWIwYWYvZVdpZGpMTDFhU2RDQWY1SEg5REhJ?=
 =?utf-8?B?NjZiaFVJOVhmY210K3c0VmI1dHdSN09tNEM5N0FLbjdkS1h2T1FER3JwaXdB?=
 =?utf-8?B?TUtIRDF3MWtzUWpYMDh2dzRMUUlLWFR2bi80YmZYV2lZN0s4NUNHNEw2YXFO?=
 =?utf-8?B?dGM3THQ2ZkN6ZUM2N1FSYjVBMHdmc0QvU0pMeXBlY0grOVVpMHhidzBtbllk?=
 =?utf-8?B?VUM4Q3dGL2ZKWGxNd3c2dEpLQ3FGQVpaOHJPMzdjRmVpb3l3ZTFZQWxkMFVN?=
 =?utf-8?B?RlhWcHlyVDZ1d3RxTDlMbDFUVDVpQmplOFR1Y205RXl0UHVzU2tEZThJL2Vz?=
 =?utf-8?B?blNURkxITHptZmlnNWxWUG1lcFZmaGxvTkgvbmtRYkV1MTZlZVcwSmZRZWF5?=
 =?utf-8?B?M1RDZHdHMDJwMXNKT1Y3VUxqcmtYQnBYVUxLdjN4Umw3cU9IT1Y4Q1YxbEZl?=
 =?utf-8?B?U2JIcEhqZW9jRmlVUlZoTi9hNWlPREtGUG9tU2h4Zm9kd2JqUkd3clJkc1hx?=
 =?utf-8?B?a1hqS1VZcnd3ay9FVTRZamhvc3k4S2dSS3cvdGZRc2RCQ3QzSHZOclpnV1dV?=
 =?utf-8?B?NmJOQ1FLVWJhNnZnVE5rVzVFT2FoWnhlUlhCTVk5elF3UnU2TGRtOXdadnRJ?=
 =?utf-8?B?ckcxbjV5WEQrY2ZjOEdiNTF3dGd6U2xhV25OL3VwK1dtSnBLWFRva1phT2th?=
 =?utf-8?B?Tjk0VFpOR1hDeUVKZlB1a2ZqdlRXUU1RMFNBZHlSdXk4bS9ndG5BV3d3RXJj?=
 =?utf-8?B?ejVtM3FycXlVRVRWSkZRSktKbzRpS3dVWmo4d245NUtRZmpvV3lnSzRhc0hx?=
 =?utf-8?B?aUp3VUxEUDBMa2VhTmpSOTJIVWxNSE11dENjbkpBcmNBcGVpS2FkVnFZUWwv?=
 =?utf-8?B?UmR2bkNvcmp3QWFHMTlrL3RnQ1FSRXVPeFNXa0piYUtsV1lWVHA2eU5Ma0Zi?=
 =?utf-8?B?SHh2bFIvSHY0cmJrVU9DWnJVTVZuM3hsRm1ycXR3NTUrY1NhQ1UyVDdnbFhC?=
 =?utf-8?B?TExtSXVEdVFKaTR4TVRmbkhxN1VQRTBRTkFBbnhka3RHa21LallnVmhrT1Vl?=
 =?utf-8?B?dTNiRXBZOFZZN1pkQ3FoNlo5ZzZnS0QzdjZ5dXhYUU5IME9TSnNGVUN3QXNH?=
 =?utf-8?B?V2wyWlllSU5zOEwzMU5Hc3padEpTTzZnTW1BbXpTMTBjUk9MWWIzVVFvbW92?=
 =?utf-8?B?dXFJNmUyczhDSFVQSEg4OC8reExzbTlCN2xVeVJTMWlHYW8wSG9JdUhRbmJJ?=
 =?utf-8?B?NW41TWwwd2Nvdmpzam1iYW4rNXhVZjY3WExSQU1uM2d3QnRvRWhLTnd0aUZK?=
 =?utf-8?B?VG1sV0Z0OU9mRFBiNHVMZks5RDhxaU9yVUJFT2dTd0c3ZmRWMWQ1SllET3c2?=
 =?utf-8?B?ZHR1d3BCRHdoZHZaMmRwQU43ejQrWTZTem1oOWhQbE9LZnFPZmhLbTZzcFVv?=
 =?utf-8?B?U09vWEIzUFZwdVFwM2FUak5WMC80VzFuRnR0VzcyeU44OEhUUE81MlRndlRO?=
 =?utf-8?B?d1o5YWJIQWtoSDd6SHNDWGFLSHhMMldrSG4xVk9nV0x1aUtOc2VsMmtndUpV?=
 =?utf-8?B?S2dGeW1RYzhJVzc0V1B0dWJVK05pd0Q0bURQSm4vUEZOOCttcUxKVG9ESXhN?=
 =?utf-8?B?eGsxMmVDVWN4WkVSbkxGOGxJYVZMaGhBN2k2a1hzaStoMVlsQXVkTXVsZjhY?=
 =?utf-8?B?K2hiN3ZDUmsxYWptNERzeXhXL1RxZkgxNmxEM0F3Ly85ZERWdWRxaGN4ZlVL?=
 =?utf-8?B?Yi9peUdlVE4zVExWdlVJWGpIdFdQcWszVWZyTy9qbUYwWkV1elpkT21QbFBS?=
 =?utf-8?B?STVqTlFyelhkcGZJeEJGdWQybHV3WlJiQmZIVzhMbVFYUFVpbHBkNGxWci9n?=
 =?utf-8?B?VTVtRm5INWpXZDdQRTdjRVFhRlRCUDRxNmJEak9UV1hNbWR2OEhNeTNtSUxn?=
 =?utf-8?B?ZWNaVXYvY0ExZS9pVitGb2l1MzYxVmxidmVQSlM2cVBWR21YeU1BdkZ6RGFh?=
 =?utf-8?B?anlLZWJuWWltZitJandOcC9vRVcrRW5pb21TOVNOdUwwSTRhMm5VMWhtZGY2?=
 =?utf-8?B?MjhnVXJwRHNlM1ZJV3Raa1ZNWklrei95aHdYZ3Qwd2M5SUhqbGt5N25lU2R3?=
 =?utf-8?Q?KNhp1qADVOIzfUbA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <70A028FA46DC1345A2B7AEB83625D651@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f53afdea-70d0-4c04-2903-08da44796da1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2022 09:22:34.7043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qH1RGjptXamhbiMvFUvJDoIleHf6+kSMQtxD3IeZ+c8ZaUU9ytOhbUw96O984q2J9eXUDz6mdOvzcLYJHYI2rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4044
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTA2LTAxIGF0IDE4OjAxIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAyIEp1biAyMDIyIDAyOjM1OjIzICswMjAwIEpvYWtpbSBUamVybmx1bmQgd3Jv
dGU6DQo+ID4gVVAvRE9XTiBhbmQgY2FycmllciBhcmUgYXN5bmMgZXZlbnRzIGFuZCBpdCBtYWtl
cyBzZW5zZSBvbmUgY2FuDQo+ID4gYWRqdXN0IGNhcnJpZXIgaW4gc3lzZnMgYmVmb3JlIGJyaW5n
aW5nIHRoZSBpbnRlcmZhY2UgdXAuDQo+IA0KPiBDYW4geW91IGV4cGxhaW4geW91ciB1c2UgY2Fz
ZT8NCg0KU3VyZSwgb3VyIEhXIGhhcyBjb25maWcvc3RhdGUgY2hhbmdlcyB0aGF0IG1ha2VzIGl0
IGltcG9zc2libGUgZm9yIG5ldCBkcml2ZXINCnRvIHRvdWNoIGFuZCByZWdpc3RlcnMgb3IgVFgg
cGtncyhjYW4gcmVzdWx0IGluIFN5c3RlbSBFcnJvciBleGNlcHRpb24gaW4gd29yc3QgY2FzZS4N
Cg0KU28gdGhlIHVzZXIgc3BhY2UgYXBwIGhhbmRsaW5ncyB0aGlzIG5lZWRzIHRvIG1ha2Ugc3Vy
ZSB0aGF0IGV2ZW4gaWYgc2F5IGRjaHANCmJyaW5ncyBhbiBJL0YgdXAsIHRoZXJlIGNhbiBiZSBu
byBIVyBhY2Nlc3MgYnkgdGhlIGRyaXZlci4NClRvIGRvIHRoYXQsIGNhcnJpZXIgbmVlZHMgdG8g
YmUgY29udHJvbGxlZCBiZWZvcmUgSS9GIGlzIGJyb3VnaHQgdXAuDQoNCkNhcnJpZXIgcmVmbGVj
dHMgYWN0dWFsIGxpbmsgc3RhdHVzIGFuZCB0aGlzIGthbiBjaGFuZ2UgYXQgYW55IHRpbWUuIEkg
aG9uZXN0bHkNCmRvbid0IHVuZGVyc3RhbmQgd2h5IHlvdSB3b3VsZCBwcmV2ZW50IHN5c2ZzIGFj
Y2VzcyB0byBjYXJyaWVyIGp1c3QNCmJlY2F1c2UgSS9GIGlzIGRvd24/IA0KDQo+IA0KPiA+IFNp
Z25lZC1vZmYtYnk6IEpvYWtpbSBUamVybmx1bmQgPGpvYWtpbS50amVybmx1bmRAaW5maW5lcmEu
Y29tPg0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IA0KPiBTZWVtcyBhIGxpdHRs
ZSB0b28gcmlza3kgb2YgYSBjaGFuZ2UgdG8gcHVzaCBpbnRvIHN0YWJsZS4NCg0KVGhlIGNoYW5n
ZSBpcyBtaW5pbWFsIGFuZCBvbmx5IGFsbG93cyBhY2Nlc3MgdG8gY2FycmllciB3aGVuIEkvRiBp
cyBhbHNvIGRvd24uDQpJIHRoaW5rIHRoaXMgaXMgYSBrZXJuZWwgYnVnIGFuZCBzaG91bGQgZ28g
dG8gc3RhYmxlIHRvby4NCg0KPiANCj4gPiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvbmV0LXN5c2Zz
LmMgYi9uZXQvY29yZS9uZXQtc3lzZnMuYw0KPiA+IGluZGV4IGE0YWU2NTI2MzM4NC4uMzQxOGVm
N2VmMmQ4IDEwMDY0NA0KPiA+IC0tLSBhL25ldC9jb3JlL25ldC1zeXNmcy5jDQo+ID4gKysrIGIv
bmV0L2NvcmUvbmV0LXN5c2ZzLmMNCj4gPiBAQCAtMTY3LDggKzE2Nyw2IEBAIHN0YXRpYyBERVZJ
Q0VfQVRUUl9STyhicm9hZGNhc3QpOw0KPiA+ICANCj4gPiAgc3RhdGljIGludCBjaGFuZ2VfY2Fy
cmllcihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCB1bnNpZ25lZCBsb25nIG5ld19jYXJyaWVyKQ0K
PiA+ICB7DQo+ID4gLQlpZiAoIW5ldGlmX3J1bm5pbmcoZGV2KSkNCj4gPiAtCQlyZXR1cm4gLUVJ
TlZBTDsNCj4gPiAgCXJldHVybiBkZXZfY2hhbmdlX2NhcnJpZXIoZGV2LCAoYm9vbCluZXdfY2Fy
cmllcik7DQo+ID4gIH0NCg0K
