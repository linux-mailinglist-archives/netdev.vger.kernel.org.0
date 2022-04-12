Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2514FE5FF
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 18:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357730AbiDLQkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 12:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357720AbiDLQkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 12:40:51 -0400
Received: from IND01-MA1-obe.outbound.protection.outlook.com (mail-ma1ind01olkn0157.outbound.protection.outlook.com [104.47.100.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8461BEAE;
        Tue, 12 Apr 2022 09:38:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnxIv9VyHbvsfWY8Ks3mKCmRT+/8NveR/4cXE/2COqo+YOYu0JtL69/1OSxlYOoABi9iHDJhRkpzhtmiaP5yLHaT//Jt6Hv2VaaJTmsTbS9lC3/2TXp7IKwZ2RrJMC0fJDpruUuPGfF5870ID3d/Un776/E79TSHKGUV6QqQvkblERhLQn7MSMbUp5dI1nG/h8LgYcyueMah7v33mh1pIgdx4EToSXpErwyGIgv7maswtST2dtdLjkafvaCPVyEtkv0L8rOoypZFLYSvw+RYfT8Je1F5zvell6aDVQrS1nFtyOJ3ck0RkXr1VJN9jFuYiMStr031pw08V8ZUdYWk2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KXCOuCOeiifd0FbrBE9MwY7vaPB2B6YBevO+CxDNaGQ=;
 b=dMJzpKuSxHXly1pDEgxmCK3nHN/7cufg9A4/8Dtji0b9+1rKbgEvlfUcFIcSslkcMwP3zEtZKSwLp57JZWGRp0ozoKwXp8HVefZ92+p3cg2YNayBdVWNqcw/rS0Ma3CNn8wSYC+0iNXbzwQ8KKdfdDzwpiET85MQGn2BzAUiMUtxaSH4lS4bmUwLPZjo8g888SsJhcZHv2x0rMjZOoweE6QRBDS65wtThEvpiVNsym4V8fDWWFBMiD1rZbVpRA4NQtQEAaybk8AsQeEBmD+zwb5dcQFvzO4oOdOhrqrXLvICGljt1jxZ4DzSKHNbZHxFoATzq4LcGUcJsKkABxIGpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXCOuCOeiifd0FbrBE9MwY7vaPB2B6YBevO+CxDNaGQ=;
 b=DaKHL7EvdovCktgOOGeCe8vrfiBpacqwlPhDnVpYB9gv5kDHTiIybiglut4QtkeojOebxEhpu8bHoDLWE+97ScAmgeDqivehrfj+VQUODvZt6E3uNqspUexkKLwctdfQQMCONLisMMsCWPHYgVQuSlYZuDdT0YKql0j9QTNUfRdP0yL60/YWCqhuylmtweIVhDxVxBtPwuEEtqTrIqbZxRr2NxLjZwdD00zTE3vt63Ly7IgWDA0fdsiTFcWZtmq/G75bMF4RPlCqaTH/0ORlTwRee6f62wlB/X1sp+8RGqvR0nZxN0Y5yzJGsDnbecLsfZy14NJUWP4IGGICKDrjGg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by MA0PR01MB6906.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:37::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 16:38:22 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd%7]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 16:38:22 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
CC:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        "admin@kodeit.net" <admin@kodeit.net>
Subject: Re: [PATCH v3 RESEND] efi: Do not import certificates from UEFI
 Secure Boot for T2 Macs
Thread-Topic: [PATCH v3 RESEND] efi: Do not import certificates from UEFI
 Secure Boot for T2 Macs
Thread-Index: AQHYTMiulSPMjZZGmkKiAUWUNy3DFqzsOTYAgAAcO4CAABDTAIAAF5oA
Date:   Tue, 12 Apr 2022 16:38:22 +0000
Message-ID: <C20B5C0B-AB37-4D62-91E0-B74708558F2C@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
 <f55551188f2a17a7a5da54ea4a38bfbae938a62f.camel@linux.ibm.com>
 <B857EF0F-23D7-4B82-8A1E-7480C19C9AC5@live.com>
 <2913e2998892833d4bc7d866b99dcd9bd234e82e.camel@linux.ibm.com>
In-Reply-To: <2913e2998892833d4bc7d866b99dcd9bd234e82e.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [/1VFL+a1gId5L0XsLK+Iwds2HBLT6gky]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 760a5721-4979-41d0-7d32-08da1ca2dc10
x-ms-traffictypediagnostic: MA0PR01MB6906:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WZIAqiQEq1E7rp9lEDP26zC7HMxQ3ZwTM2pRury3tskyavoEJkj+OE1p2zDR4a/Ck1aUtDROJqAPC0y5L97GkWYGzPgNgTTOd6SGbsnnP0Mg9HbT4C66SvKXNbdxDt0j+aeLuMk43M0W/YoSE85tRjWEf/DN++ALhgOd9oYUA66rnCTT5vgT/fBrl5SeXdNns5bNjRXsp/9S4VLgWgVLfGQYRArHOOIa6I/LY6dHLOfuSGjErQf3uZJ85XilAqClFjXHlXOEtAYkVTGVUDJjc6CNSyjNtQarCZE8TA7sntgY3o/oTvvrJVbTzjM4hN0FOPc8lIQzG+7+0vz59ZMKPfZa0ZRctJnO6sHSuXZMeLqca89YPDoptChwuHIU4P26UNhp87nSzMkRuwTxvUGU43YRaAL5pk6preHkqlkh6SAzBPSSyIBSHfjdz+x1/tqdm+JuoFJePI/HbqiLML+49rHf1N4Ny7MQ+BoVQ/Ay4cHg4ythFEhmNxd6oEG6tBW4SFS8aZszu+UnC/lXVfGGRqLvaATcAjEVQJDCxYrXW8h2S8Q8HUPaqXxYojjAcjak1RvcTaTtf0hqC5o6nvB3PQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzNRRmxoTmhsWk5JajJuNWZOcVc2VExzN0hXblI5NHhNVWh1YlQxMG8vQ3Rj?=
 =?utf-8?B?bUczU2ozQ2RqaTlkSmc4TGgzY05BOGVrM3g4cWw3OGdyYU1HNzl0SkV4Vyta?=
 =?utf-8?B?eHNhN2JKdnkyNFFoQ1NkZVhwKzlXZ1dCNXFFbTRNUHVCVE5sT0RvN3R5MDFY?=
 =?utf-8?B?bHBWMC9iclRQUWY2ZnNLdkR2eVBxaXhUK3ZDSXJTSmV2TmplUVJ1eHhCNTQ5?=
 =?utf-8?B?L0UxUTBUN0Nza1piVW9sb0FxVVduUlU5Zm9za2xFRFJMNkQrWmNUZnRUUXVI?=
 =?utf-8?B?bmdMT1RhTWNBVFkyNUVCQjlMUTV6VFhrSk5qaGtmOFRSRjhFbWcrRldDb0Ju?=
 =?utf-8?B?NzI5NjdqOSthWUc1MzFJQWpLbVJ2eWRuMWpZeFpka1pXajhDRGdZU09lK3Yy?=
 =?utf-8?B?eXpyNEgxWk5Oa0xWUWxvZnhrb1FoTFNOWlU5VlVDR0VaNE56YzRlWEJNSHJk?=
 =?utf-8?B?L2IzY3RtbTBjRzVpK0kzQ0EydEZGc3hDRkcydndheVZyaHRQUE1SY3BLTEpM?=
 =?utf-8?B?emVGSXFiL0VvRm5lcEhzdWlUZHRRVXNDbmRsRUJRSHpaTzdFVE1qQ0xlNmxN?=
 =?utf-8?B?eGVybXdFVEZKNzZpOC92Q0VYYUFadU9WRFlGdXNyVnl1SzVPMVdPUWlPV2hL?=
 =?utf-8?B?T0JEUUFiYlpkV01lRnRadVNSSWsyajdmTmhPTWN4REpmREhNV0hiL08veCtv?=
 =?utf-8?B?RkNlazdWdGU0dVBHeGNYaEhaTlF5YmtqdzJ0ekZmTk5HNlNjTEF0aDh1RjRo?=
 =?utf-8?B?RSthbTR5MEVUN091Yk5hZ0tIR2FVZ0JlTU9JU0k1K1RrcTh3SzkwWkQrNEps?=
 =?utf-8?B?cUx1WkVSNHoxNnovcnFwUWFaMERqZ1I5OGxIdzBKeEptK0Q1bjB4QmlXMm8z?=
 =?utf-8?B?MUJEaEdIV1dmbExucVozT0ZYSmdKdEtpYVdUQ3ZwdFZySStjTGEwcWxPZFFw?=
 =?utf-8?B?eVZlZnR0ZHNGS2E4eVE2ZWFtdFk0SElySlpRQlVWZmdpMnZvSG1JSkRxRXJ2?=
 =?utf-8?B?R2tNQTV6V09uSzRjYlBKbHpvSjV3akZCSUMrS3NYeEg2a3BYMzRzUFJNdGNB?=
 =?utf-8?B?czFsM25adTlIam5udGJhWWtFeUhsdThBOTFpSXB2ZDIyZE1LQm9jSDB0NW03?=
 =?utf-8?B?TzIycE5xZ1VKZ2crYUhPb09JQWZRMjlndCsrazhMSmRLbEYxR1Ixb2NoSnB3?=
 =?utf-8?B?ZzltbFA5elVmdGlwOGZmc1k2dUxobWhlMEovbHRrVmJYMVJmcGg5c3V3cFVZ?=
 =?utf-8?B?RllIYTJkencvOWtzWWdtZVE3OGtBSy9aaGMwaXFCQ0VSclhCYkhLNUQwaDVZ?=
 =?utf-8?B?OTIzcUQ4UENQME50Qm1pOFdYbHlNM0l6cVd4bGJJYms3TzFEZ0dNdEg4WUpl?=
 =?utf-8?B?KzdQN2hOMUQyQkNXNzhzZEdzMzlZa3BmWTZ1Z0hvK1hYT04zd0dOQlUxT29u?=
 =?utf-8?B?S0lKYXB4UFB0SGg5aGVtdWNtQUhLeDVZbEdyeVFwM0FmeVBvaWU1WE5aTWxw?=
 =?utf-8?B?ZDNNcjRSMnhTeG15aGZsMHBNbk9JaUJVeUh1WWdNU201b0NkUHJIbUtCNzlI?=
 =?utf-8?B?VE9qYTZhc2VZendoTlZ3SHhxQW51cmczN1paV3VOYkZ4YVMrTXR2bitRdkdq?=
 =?utf-8?B?aHZzTmtabUk5R0x4L3FYTktqN2Q4WDVaMHVrM2hvTUNqVUdQTW9sNGJwRlNn?=
 =?utf-8?B?Z2xnOUdUSzY4SGdTQUdmODhoNGVMc0lSN1hubkhqaUNMeUhrOHVDQWtkdEYz?=
 =?utf-8?B?RldCSncvNktveVMxZHB4bzFLbTZjYkR6RnN3VUtLYjJWTHMxSDc4VkpWUVIx?=
 =?utf-8?B?M3ZQS0hMY2dxZXArb0tTMkdLMHpMekRGQ045OW1PQWNkNlZDTExKK2lVN29a?=
 =?utf-8?B?azNjK2JldmQ5UzBFMG5scDVGNnRhVkx2TjVKZlpqM0phVGx6QVJRdkVHSlN5?=
 =?utf-8?Q?BBtdoPrrTkk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6E0B823C6189941AD5AB17EA1DA4F4C@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 760a5721-4979-41d0-7d32-08da1ca2dc10
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 16:38:22.8069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA0PR01MB6906
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IA0KPiBkbWlfZmlyc3RfbWF0Y2goKSBpcyBjYWxsZWQgaGVyZSBhdCB0aGUgYmVnaW5uaW5n
IG9mIGxvYWRfdWVmaV9jZXJ0cygpLg0KPiBPbmx5IGlmIGl0IHN1Y2NlZWRzIHdvdWxkIHVlZmlf
Y2hlY2tfaWdub3JlX2RiKCksIGdldF9jZXJ0X2xpc3QoKSwNCj4gdWVmaV9jaGVja19pZ25vcmVf
ZGIoKSwgb3INCj4gbG9hZF9tb2tsaXN0X2NlcnRzKCkgYmUgY2FsbGVkLiAgSXMgdGhlcmUgYSBu
ZWVkIGZvciBhZGRpbmcgYSBjYWxsIHRvDQo+IGRtaV9maXJzdF9tYXRjaCgpIGluIGFueSBvZiB0
aGVzZSBvdGhlciBmdW5jdGlvbnM/DQoNCldlbGwsIHRoZXJlIGFjdHVhbGx5IGlzbuKAmXQgYSBu
ZWVkIHRvIGNhbGwgZG1pX2ZpcnN0X21hdGNoKCkgaW4gb3RoZXIgZnVuY3Rpb25zLg0KDQpTZW5k
aW5nIGEgdjQgd2l0aCB0aGUgY2hhbmdlcw0KDQpUaGFua3MNCkFkaXR5YQ0KDQo+IA0KPiB0aGFu
a3MsDQo+IA0KPiBNaW1pDQo+IA0KPiANCg0K
