Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F5F48BBF8
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 01:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346899AbiALAmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 19:42:15 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:64834 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234326AbiALAmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 19:42:14 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BLq0P2024938;
        Tue, 11 Jan 2022 19:42:03 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2053.outbound.protection.outlook.com [104.47.60.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgp68rwpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 19:42:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PotN1/bs0/mJqvrOhfxRhUcb5036Mz3r3WD12f5ZfCiVeCBaSD4t0OjuaCE08UpDmio7gPurBiqTBk2d25zZN+sKjVwv/GzmN3qJ4wcCSbsfYE6C1o67ehRJCVi3iGkay2sKgHywwvqn6FypB2D5GaMV2M6leaFwkT5bxu0TKoOMJh4bRl7lVY2DbeWaTV/77H8tCvJiLAooPHDZYL8mbUJfAVfJJqeD/qdIqAzgIbtyXfF6B/DwsrpBxw60nEYIQHvR1Z4bkaCR6ZsuwPl7XEDmiGWdzVEGjWS65NzPm6v/ZTskpn7Rf6MgGOjnszSOjox6YsKD0fYkaEJcB46jZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2XQF3zd7asFv/lcGAOKm1r4YHJbAOYeRLEoVdAo8SRk=;
 b=dfvyeL0Ua4GuPFnKb+IsjDYc2ojc+FkalXKaeYYC8ksasxPr+D3AOimxwXCn3fEADU7oEefR3R5qtw8XmMcELSL2wi5BP0eLhwpwB4WsAPuAqV5q3LGK4Y5NqASyWa5hMIFIotEtquNGS9mTEZjFQFuRCqGngwsXdoOwiJrOzpHoIk6717P7e2MBoOgumxN3RsqKkLZzcvnMXssEhZLBvkkA7jrSTYkk7xsbAfIUSW6if9jle0m5AH7xKewfS2EM+s6Fnavrfcz9PnuuxZ6j845WkgPv47Olbcg3EHTvIuPe5jRolLioi66J79w6jCFpGPqLPnD73KnIpgJP9hcGzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2XQF3zd7asFv/lcGAOKm1r4YHJbAOYeRLEoVdAo8SRk=;
 b=M5hvMw7zPU4c1xFucaCmqwQsDdGGMe8rEJewwxL18qtl2pK8rUHmh3fFkUSDE1Lo0jx6BYJ90z7IGoU4yGFQJEB2/Fbf16Y6YJuRO9IoRX98u1I2C4hlbSm8uZjBYHPouBccuLuYlOoNd2BhhRYZYOQ9gL6YTR1BCpx6QJTgST8=
Received: from YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:4d::14)
 by YT2PR01MB6013.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:59::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 12 Jan
 2022 00:42:00 +0000
Received: from YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4441:49c3:f6d1:65ec]) by YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4441:49c3:f6d1:65ec%9]) with mapi id 15.20.4867.012; Wed, 12 Jan 2022
 00:42:00 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: phy: at803x: add fiber support
Thread-Topic: [PATCH net-next v2 2/3] net: phy: at803x: add fiber support
Thread-Index: AQHYBzXzLNXq90W5OkaZTaOCjzQdcaxegz4AgAAIwQA=
Date:   Wed, 12 Jan 2022 00:42:00 +0000
Message-ID: <acb08860e200f94638663e48eb85565a41903fca.camel@calian.com>
References: <20220111215504.2714643-1-robert.hancock@calian.com>
         <20220111215504.2714643-3-robert.hancock@calian.com>
         <Yd4cgGZ2tHzjBLqS@lunn.ch>
In-Reply-To: <Yd4cgGZ2tHzjBLqS@lunn.ch>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11dfd166-3321-4b71-891b-08d9d564588b
x-ms-traffictypediagnostic: YT2PR01MB6013:EE_
x-microsoft-antispam-prvs: <YT2PR01MB60136AA30D6DDC4FD93AC715EC529@YT2PR01MB6013.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hg+BDR6bE+Yh6RUFSc7Xi9fZWTbppsuuFOXOkgbnInWGB36fGuZCJ/fy18k+GPC01ONZ0hiNC2kGeoBtWYMQJfGyPQVzlX4W++1Ak8TFUVRRK4uxRaTLW7qj1FmCVFdYlSKleE+8pfi53uKX5m6jy9buZLVo2euhPiA4UpLrS6XXIppbHMluRoFaK1PBzuw2soYwDXVQhLFJJmjGWRGCkE7jBr5Uf2HkLYofUAQT7tKAetVw0iB+1Koxxgv3BNeAFOZLPsgLUI1W02kwthrUfW8QaUR2mQZhiBWox9m/ywtSDMwktZMNEIxOf9oE26lFZC/AZfRDYThlETOD5wTzqD2u+bOyowmyAQHUHpkKUAUyCaBYh65Jtx9lUdXljbLXRupd9MkKyCU8HrrkCMuYH70yQsu9UCQKbkwFNUXUGIMDhNZ0kKHEXOYrmGaoPOgrnFi0YQ8ht5J48FqJ7YLGIciC77anJgAkqbwZRwUeKtDZGn2iAtlc1Oh8v3hwu3yGYgF2veSRAqitlCJBfhQ+0frgn8fTP/WGD0rsRB5Ww2y0UiRrlSNCtyhqAF8MWxYlo8JLYc71H6bxgpqRqcWmrhHI8nErQJxHZpHsr9PedQ+oGnrEsgiB9yJ/5MOHTTJIyba+toUZ9OSH9pmxSftZMop7r7X+jPSi51rCxZdxtzKfCMRcLPIbylqZzsY2vtIXV5ree2+w5jb4G+EfQmqNTNBjI+yKlTV+hZjf7e6fFpi8EwFwdj4Vm2SNwPlLZSZl4ScWmHIqq15vVtpYGGJsJjsNcaOojJX4eFAU5qwdYCRIJAemo9KNy88b/hme26A8gm/EN5oyNXsIX0Dooigq4j6Aboe+D2XRR6E/xUxkwzhny70v4ORqLKzk94VCY+887Pqt9kYYIbbuY9GfXHinnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(36756003)(15974865002)(508600001)(6916009)(6506007)(316002)(2906002)(8676002)(71200400001)(966005)(38070700005)(83380400001)(5660300002)(54906003)(76116006)(66446008)(64756008)(86362001)(122000001)(2616005)(44832011)(66946007)(6512007)(26005)(38100700002)(66556008)(8936002)(186003)(4326008)(66476007)(91956017)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1lpTmZyY09QMUtkdFRacXU5QzhnTW9vSE4zZnA1eURPWWJtSGJkNFFpS3ZF?=
 =?utf-8?B?aDFXTnZ4WkQ1OGx2b3Z3V1hyZFJxaUFoNEtUUGZOUVNjMDR6UmY5MitrcGtn?=
 =?utf-8?B?Mjk2bStLMzBlUXR1dVV0emdxaXgvdDJuNVlpaW9JUEY4bDhFaUpaSWRVSjVi?=
 =?utf-8?B?WWVIMFgvQTlrdndBelpVVHV2c0dkWjV6bHplNXc2Z202VUQwOHFudlBGYW90?=
 =?utf-8?B?cnJpU0IxWXE2RDRKM29ONExnZWZCUWw0YU4wY1R6MEUybXk0aTJVcnJJNk5m?=
 =?utf-8?B?L09lMVVtenh2QTZISGNiSnB2aTJ0RmY1UXRhVDFiL3NnMlJoalV6MERTUTBZ?=
 =?utf-8?B?NUZ0UXdoSmd6U2YwR3ZqODRZZDdGR0F1Y2dlWXJVZlg2OE9kdEc5SHRoRGth?=
 =?utf-8?B?UmhwRjczeXVIcnB6Y3hKVnE4MDEvUGtmZEliUkVVZGVxMVJVc2ZoYjc1Q29k?=
 =?utf-8?B?R0Q4NEc3V21BeTZWaFg2ODR0Mm5mNUpYejM4YXRMM1hreWZDcTVJd2JjMEVR?=
 =?utf-8?B?V3Z1U0t1clpBbVlKQnhtYzRjaERyZ1R6Vy9icG9nSVl3cHBsaGJZMXNFYnFR?=
 =?utf-8?B?ZGwvQUI2YjM2cGZDMUs4b1E3TTlNdGI2NDN0RzZPWEF1TzAwOGRmZzQyc3JV?=
 =?utf-8?B?ZUYwVnFteFNZdTlTMEEweUJaSkFSSnRxSVpIbFMxUjRWbE5Va2Z3Q3hEQ213?=
 =?utf-8?B?Z0p3UXJDWXdTekkyc0FBNDNPTEgwdVhNL3F6U0o0RUYvdXpJUkdrWE9wdkZ3?=
 =?utf-8?B?cGNaY2ZocHkxVTVyRDJ1dG1UWTRQYlBZWXFxc2tMUEc5ai9EWkYxVm5OVVAw?=
 =?utf-8?B?aWlaNkR4Y1lWeTFqNngwOEFnM1N3VkxNL21XQ2M0SWo5bjN4YXl3VGF2RFEz?=
 =?utf-8?B?Q1BhSmZZQmRxK0o2c2R5QjNMMlIwZzN2eVE0SE1UUUxkKzFQMTh1WFFEOTg5?=
 =?utf-8?B?RDZYdEVNcjNabHhQemRCWWdNaXJ1TFIzYmkrQnBUcXp4RXRHZ2tzb3g0UHVk?=
 =?utf-8?B?aEh4ZGE0Mkw5M0Y3RXkwYWZFdHlZTEY2RHVmdkp5V2Uwc3pVZ1h4eWdkbmlT?=
 =?utf-8?B?dENmVnhpa3BDSTJ4OGpNRjhiUnFxbUlod3pjUjlpVnNNUWtjNGpDUUk1d1o1?=
 =?utf-8?B?NnY4QlNkWUlQanlPTW0zNlphamErckc0SU15cDRyUzlHb0NkODRzQU9vaWFT?=
 =?utf-8?B?TURXWE80RkhNTVdGY2pKQ2oxdHhUam5vOTdDOEJyYkx2V2xlV1QyUVQxVzFz?=
 =?utf-8?B?RG9JTGR1QlRIcmN4bHpYT01CQlduSXl2ekJzQWMzZllSUkJLNFVDZlRDWEs5?=
 =?utf-8?B?N0hwZ0taWUUyYmNvTVVXSHdvNUtUMjJ2bDVvRE9aci9oK3QxMlluTDRrWGNm?=
 =?utf-8?B?UkhzRDdjZnVTaTBPeWpXZWFHci9kN1R3bVB0OVdiam5LRXFrVFpMd1dGLzJu?=
 =?utf-8?B?ZHhNVGozcUFwM2s1K0s2VU9IV1Jzd09vdkExTjlpZG1oRnMxOXhLaE1TUEs5?=
 =?utf-8?B?emxZU2xtNFBMLzJGbjJmcnE4ZjMzUHRtU1BucG9IeHRFUDFEYk9oWm8vOTMy?=
 =?utf-8?B?YWZvYno4YjgwWEZ1TVhRYmJPaHl5UjlzTmZQMFJTTFlzb0RZakl0dUlsQlNL?=
 =?utf-8?B?T0RVNk1RV3oxMGViSnA1Z2pLdHFmRXcwdmF3SnFaL1AyVUF5aTRYVUFCMmg1?=
 =?utf-8?B?eW5qdVdNOEhSWXBTeDdwVWhDNzNZVnZjTkpobkh5Ync2VHlwQnVEM2RkTDNz?=
 =?utf-8?B?L3FNb1lLVUMwd3A0eVQ3MElHcGtoUHpPRWwrSlBRajFtWEJCN1c2L3dmcCtM?=
 =?utf-8?B?TTIvSDJNMnNJL3ExSEV6c2lkZ0MwOS9oR0tEWTM2ZUtrVUk3SzRmWE94dGo0?=
 =?utf-8?B?eEtxQ0JyVTQxM29ISHk2OThsZFp0L0lFZlQrM0F6ejRPMDRIVEZJankxSmh4?=
 =?utf-8?B?VHJpemdYYUs1RlExQzd6YmhEUk1JMjBoOGh3bnAvYUI4dkQzVkNLcmExVDdN?=
 =?utf-8?B?c3U0ZjRhbE1YV1FvLzU2V053MlVGS2RSUW54TmxYRG5BVWx6MmZVWDgrcHRw?=
 =?utf-8?B?czNTWUR0MUREcnlOMUVrR050cFlDTURRTTYxOEZYRlVNTXp3Zm5PNzVlb0dQ?=
 =?utf-8?B?RE9RRkJjc0srKzZpdVFvS1ZVeloxWWFuSFo2MmlXa3drR1BJSzhOOVdJeVFT?=
 =?utf-8?B?bDI0d05yamdpeStEWGl5Rlh1SFJoNmtoa2dKRXdQSHpkQXZNem1XYkViemh6?=
 =?utf-8?Q?l7XNBGl3BgvjklQeKMDyvWASgjufe8JVpTYbaMxkcM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE5E7C1EFE24664F89DD2A4F7C40A85E@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB6270.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 11dfd166-3321-4b71-891b-08d9d564588b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 00:42:00.7840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DFYk96aknPXqUKiZfmMpci85RGMEA0Nhc7b7PA017Lo6NR7eXcRpT6RWtJRB9/9eN4berlbg+cRvxJ6WSkPh08TJQ6jSvApLXvXdrM7lNh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6013
X-Proofpoint-GUID: QYSgMzhn6KZEJsfMZ2ae_88a1X4TBofw
X-Proofpoint-ORIG-GUID: QYSgMzhn6KZEJsfMZ2ae_88a1X4TBofw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 clxscore=1015 mlxscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAxLTEyIGF0IDAxOjEwICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
PiAgI2RlZmluZSBBVDgwM1hfTU9ERV9DRkdfTUFTSwkJCTB4MEYNCj4gPiAtI2RlZmluZSBBVDgw
M1hfTU9ERV9DRkdfU0dNSUkJCQkweDAxDQo+ID4gKyNkZWZpbmUgQVQ4MDNYX01PREVfQ0ZHX0JB
U0VUX1JHTUlJCQkweDAwDQo+ID4gKyNkZWZpbmUgQVQ4MDNYX01PREVfQ0ZHX0JBU0VUX1NHTUlJ
CQkweDAxDQo+ID4gKyNkZWZpbmUgQVQ4MDNYX01PREVfQ0ZHX0JYMTAwMF9SR01JSV81MAkJMHgw
Mg0KPiA+ICsjZGVmaW5lIEFUODAzWF9NT0RFX0NGR19CWDEwMDBfUkdNSUlfNzUJCTB4MDMNCj4g
PiArI2RlZmluZSBBVDgwM1hfTU9ERV9DRkdfQlgxMDAwX0NPTlZfNTAJCTB4MDQNCj4gPiArI2Rl
ZmluZSBBVDgwM1hfTU9ERV9DRkdfQlgxMDAwX0NPTlZfNzUJCTB4MDUNCj4gPiArI2RlZmluZSBB
VDgwM1hfTU9ERV9DRkdfRlgxMDBfUkdNSUlfNTAJCTB4MDYNCj4gPiArI2RlZmluZSBBVDgwM1hf
TU9ERV9DRkdfRlgxMDBfQ09OVl81MAkJMHgwNw0KPiA+ICsjZGVmaW5lIEFUODAzWF9NT0RFX0NG
R19SR01JSV9BVVRPX01ERVQJCTB4MEINCj4gPiArI2RlZmluZSBBVDgwM1hfTU9ERV9DRkdfRlgx
MDBfUkdNSUlfNzUJCTB4MEUNCj4gPiArI2RlZmluZSBBVDgwM1hfTU9ERV9DRkdfRlgxMDBfQ09O
Vl83NQkJMHgwRg0KPiANCj4gSGkgUm9iZXJ0DQo+IA0KPiBXaGF0IGRvIHRoZXNlIF81MCwgYW5k
IF83NSBtZWFuPw0KDQo1MCBvciA3NSBvaG0gaW1wZWRhbmNlLiBDYW4gcmVmZXIgdG8gcGFnZSA4
MiBvZiB0aGUgZGF0YXNoZWV0IGF0IA0KaHR0cHM6Ly93d3cuZGlnaWtleS5jYS9lbi9kYXRhc2hl
ZXRzL3F1YWxjb21tL3F1YWxjb21tYXI4MDMxZHNhdGhlcm9zcmV2MTBhdWcyMDExDQogLSB0aGVz
ZSBuYW1lcyB3ZXJlIGNob3NlbiB0byBtYXRjaCB3aGF0IGl0IHVzZXMuDQoNCj4gDQo+ICANCj4g
PiAgI2RlZmluZSBBVDgwM1hfUFNTUgkJCQkweDExCS8qUEhZLQ0KPiA+IFNwZWNpZmljIFN0YXR1
cyBSZWdpc3RlciovDQo+ID4gICNkZWZpbmUgQVQ4MDNYX1BTU1JfTVJfQU5fQ09NUExFVEUJCTB4
MDIwMA0KPiA+IEBAIC0yODMsNiArMjk1LDggQEAgc3RydWN0IGF0ODAzeF9wcml2IHsNCj4gPiAg
CXUxNiBjbGtfMjVtX21hc2s7DQo+ID4gIAl1OCBzbWFydGVlZV9scGlfdHdfMWc7DQo+ID4gIAl1
OCBzbWFydGVlZV9scGlfdHdfMTAwbTsNCj4gPiArCWJvb2wgaXNfZmliZXI7DQo+IA0KPiBJcyBt
YXliZSBpc18xMDBiYXNlZnggYSBiZXR0ZXIgbmFtZT8gSXQgbWFrZXMgaXQgY2xlYXJlciBpdCBy
ZXByZXNlbnRzDQo+IGEgbGluayBtb2RlPw0KDQpUaGlzIGlzIG1lYW50IHRvIGluZGljYXRlIHRo
ZSBjaGlwIGlzIHNldCBmb3IgYW55IGZpYmVyIG1vZGUgKDEwMEJhc2UtRlggb3INCjEwMDBCYXNl
LVgpLg0KDQo+IA0KPiA+ICsJYm9vbCBpc18xMDAwYmFzZXg7DQo+ID4gIAlzdHJ1Y3QgcmVndWxh
dG9yX2RldiAqdmRkaW9fcmRldjsNCj4gPiAgCXN0cnVjdCByZWd1bGF0b3JfZGV2ICp2ZGRoX3Jk
ZXY7DQo+ID4gIAlzdHJ1Y3QgcmVndWxhdG9yICp2ZGRpbzsNCj4gPiBAQCAtNzg0LDcgKzc5OCwz
MyBAQCBzdGF0aWMgaW50IGF0ODAzeF9wcm9iZShzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0K
PiA+ICAJCQlyZXR1cm4gcmV0Ow0KPiA+ICAJfQ0KPiA+ICANCj4gPiArCWlmIChwaHlkZXYtPmRy
di0+cGh5X2lkID09IEFUSDgwMzFfUEhZX0lEKSB7DQo+ID4gKwkJaW50IGNjciA9IHBoeV9yZWFk
KHBoeWRldiwgQVQ4MDNYX1JFR19DSElQX0NPTkZJRyk7DQo+ID4gKwkJaW50IG1vZGVfY2ZnOw0K
PiA+ICsNCj4gPiArCQlpZiAoY2NyIDwgMCkNCj4gPiArCQkJZ290byBlcnI7DQo+ID4gKwkJbW9k
ZV9jZmcgPSBjY3IgJiBBVDgwM1hfTU9ERV9DRkdfTUFTSzsNCj4gPiArDQo+ID4gKwkJc3dpdGNo
IChtb2RlX2NmZykgew0KPiA+ICsJCWNhc2UgQVQ4MDNYX01PREVfQ0ZHX0JYMTAwMF9SR01JSV81
MDoNCj4gPiArCQljYXNlIEFUODAzWF9NT0RFX0NGR19CWDEwMDBfUkdNSUlfNzU6DQo+ID4gKwkJ
CXByaXYtPmlzXzEwMDBiYXNleCA9IHRydWU7DQo+ID4gKwkJCWZhbGx0aHJvdWdoOw0KPiA+ICsJ
CWNhc2UgQVQ4MDNYX01PREVfQ0ZHX0ZYMTAwX1JHTUlJXzUwOg0KPiA+ICsJCWNhc2UgQVQ4MDNY
X01PREVfQ0ZHX0ZYMTAwX1JHTUlJXzc1Og0KPiA+ICsJCQlwcml2LT5pc19maWJlciA9IHRydWU7
DQo+IA0KPiBPLkssIG5vdyBpJ20gd29uZGVyaW5nIHdoYXQgQVQ4MDNYX01PREVfQ0ZHX0ZYMTAw
XyogYWN0dWFsbHkgbWVhbnMuIEkNCj4gd2FzIHRoaW5raW5nIGl0IGluZGljYXRlZCAxMDBCYXNl
Rlg/IEJ1dCB0aGUgZmFsbCB0aHJvdWdoIHN1Z2dlc3RzDQo+IG90aGVyd2lzZS4NCg0KaXNfMTAw
MGJhc2V4IGlzIGEgc3Vic2V0IG9mIGlzX2ZpYmVyIGhlcmUsIHNvIDEwMDBCYXNlLVggc2V0cyBi
b3RoIGZsYWdzLA0KMTAwQmFzZS1GWCBzZXRzIG9ubHkgaXNfZmliZXIuDQoNCj4gDQo+ID4gIHN0
YXRpYyBpbnQgYXQ4MDN4X2NvbmZpZ19pbml0KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+
ID4gIHsNCj4gPiArCXN0cnVjdCBhdDgwM3hfcHJpdiAqcHJpdiA9IHBoeWRldi0+cHJpdjsNCj4g
PiAgCWludCByZXQ7DQo+ID4gIA0KPiA+ICAJaWYgKHBoeWRldi0+ZHJ2LT5waHlfaWQgPT0gQVRI
ODAzMV9QSFlfSUQpIHsNCj4gPiAtCSAgICAgICAvKiBTb21lIGJvb3Rsb2FkZXJzIGxlYXZlIHRo
ZSBmaWJlciBwYWdlIHNlbGVjdGVkLg0KPiA+IC0JCSogU3dpdGNoIHRvIHRoZSBjb3BwZXIgcGFn
ZSwgYXMgb3RoZXJ3aXNlIHdlIHJlYWQNCj4gPiAtCQkqIHRoZSBQSFkgY2FwYWJpbGl0aWVzIGZy
b20gdGhlIGZpYmVyIHNpZGUuDQo+ID4gLQkJKi8NCj4gPiArCQkvKiBTb21lIGJvb3Rsb2FkZXJz
IGxlYXZlIHRoZSBmaWJlciBwYWdlIHNlbGVjdGVkLg0KPiANCj4gTG9va3MgbGlrZSB5b3UgaGF2
ZSBhIHRhYiB2cyBzcGFjZSBwcm9ibGVtIHdpdGggdGhlIHByZXZpb3VzIHBhdGNoPw0KPiBPdGhl
cndpc2UgdGhpcyBmaXJzdCBsaW5lIHNob3VsZCBub3Qgb2YgY2hhbmdlZC4NCg0KSW5kZWVkLCBs
b29rcyBsaWtlIHBhdGNoIDEgcmVwbGFjZWQgc29tZSB0YWJzIHdpdGggc3BhY2VzIHdoZW4gdGhl
IGNvZGUgd2FzDQptb3ZlZCwgYW5kIHRoaXMgcGF0Y2ggcmVtb3ZlZCB0aGVtLiBPZGQgdGhhdCBj
aGVja3BhdGNoIGRpZG4ndCBwaWNrIHRoYXQgdXAuDQpDYW4gZml4IHRoYXQgdXAgaW4gYSBuZXcg
cmV2Li4NCg0KPiANCj4gCSAgQW5kcmV3DQotLSANClJvYmVydCBIYW5jb2NrDQpTZW5pb3IgSGFy
ZHdhcmUgRGVzaWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3dy5jYWxpYW4u
Y29tDQo=
