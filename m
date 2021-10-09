Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296D642781E
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 10:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhJII3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 04:29:21 -0400
Received: from mail-eopbgr1400110.outbound.protection.outlook.com ([40.107.140.110]:31066
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229578AbhJII3V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 04:29:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8otPr2bKf82XOAMIf/KC/th/stLBJZgvELVCz0heP9k0zMHTxQFuIMfypTfT08bmNoAMM6Hbe7yZZv6/1Qk1mJkGcLAMsa4xrlACNUQxEy0Tsq4iS0Bu/1XIGGErj6OVC5mOthmtQbVSEYD7zWpQTaicogQVwRWUV447wxA2pb9PTxeJ333I2OO3m3Ikc0O7hCqxsYZIh5w3Nv3KSYjZfJythwy0bpW/v1agyN7nZeDO1LZd9IOm3WEmYUZwRTssoswM9HxYjgKbXSW4y8/8luK4Fhm4Prw+GOvaEEmnvA1SgzInX6Vydg9GrI8+yiY13NlIkAAXfvT9rxMQFIrwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+RIvAC5cMHKtJBaQZY2fiAX1V1eUos8kDQW2wdb4j4=;
 b=jjxFrTaZYi4B4HpBbISieu6pfjzEO54i4hMD03qfQtaiL9Jot0sn+ofr1pK5Od5kjTstYd5DRQ+H9qNU8/GQqIfqWO4Sxstwhe8Sy9L313cFG4jPu6oSA4tZYSGfHh0RlNnH+uFF//RqawPLefUKxWHFE3khXEHHxjs7Fwic1OtAmUgnaTScTRLtqg+GCUwUckO2ge0duXl/5Lrtkyo2w+lt0DRmCoiBBfRPEjbueYp8buUFj6WnqI65Q0YdeGJqOf9hz78T2SE9lhN2GetZ5ypkpvB7nQNrDgLHLZ53IBkd6Yj0YKFSy762wmhJN/J4+rBD3MuxIqU9AqeD6O7rSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+RIvAC5cMHKtJBaQZY2fiAX1V1eUos8kDQW2wdb4j4=;
 b=joVdkef6MzkEMKFNV3pCeOHKapOzb4vOszl4Q9njhKBiLfxpMWhH4+y8CAhJRtIELoLr/cng+PhOk9SXvWFpjRLCTC8pCdw4JmZg1cdsgVuKvWpk0wrMO0ujLOu3wabX5cbvf0QDlT9kmzRlNtGrSAEHFojic0R20pcNQ6D78SM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB6997.jpnprd01.prod.outlook.com (2603:1096:604:12e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Sat, 9 Oct
 2021 08:27:19 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.024; Sat, 9 Oct 2021
 08:27:17 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
Thread-Topic: [RFC 07/12] ravb: Fillup ravb_rx_gbeth() stub
Thread-Index: AQHXudknyVYpSr19EUOWd3E+ko3swavGX+aAgAAJbzCAAAV1gIAAlePwgADj/ACAAAp2UIAAuMcggAC8+wCAACVLgIAAyy6Q
Date:   Sat, 9 Oct 2021 08:27:17 +0000
Message-ID: <OS0PR01MB59228A4BA524B092F760B52E86B39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211005110642.3744-1-biju.das.jz@bp.renesas.com>
 <20211005110642.3744-8-biju.das.jz@bp.renesas.com>
 <63592646-7547-1a81-e6c3-5bac413cb94a@omp.ru>
 <OS0PR01MB592295BD59F39001AC63FD3886B09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <7c31964b-8cde-50c5-d686-939b7c5bd7f0@omp.ru>
 <OS0PR01MB5922239A85405F807AE3C79A86B19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <04dea1e6-c014-613d-f2f9-9ba018ced2a3@omp.ru>
 <OS0PR01MB5922BCF31F520F8F975606B286B19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <OS0PR01MB5922165EFE14E02388B34F4086B29@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <52f0d801-9750-dbd6-7ba0-258a324208cf@omp.ru>
 <19204ce1-f689-3295-c5a5-7f91ceac2fca@omp.ru>
In-Reply-To: <19204ce1-f689-3295-c5a5-7f91ceac2fca@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c817882-2727-4bec-a264-08d98afe9ae5
x-ms-traffictypediagnostic: OS3PR01MB6997:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB699764EC51C5F501D880FE5186B39@OS3PR01MB6997.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Qczkmk0jVaPiTkztxHITeFebflCZJKE2DktENDttRJxFNiX21KgMGML7vsCw2pfIN7AmPn1G2nLC19hZW5lGiZAAqhQBZJmovGg5i789YDKMIS9DvYaGo+yLdIYQL1BLTIOK670nO2uNLMYkKbOuf3QpKwHbm1j2EdUkNZDAoA9d+4rHWvpWCBsutd6kPUgwPfjxeVuqJ5tOok3te2zYYASLVCa64/MdbwBcHrAtRS4rTUZ86hIxlKdvpQX7nMrLD1tp8B3CDjncqabmExW90OoWOw5bzkq6IpuUadsN3XUwLQLRW2ymRKi95eKEUvQGjauE8L6JlWcME9Mf+tAaPd6bKsCCowqExtONrcGL4bULaCjvTILqRa0YcJJRFJ51loDG9qwLXqM+T+zur4kBHDuz6FKpTjOddCirKYyJef3JqYAUllH8kWfG739AxLGAbPKadgHImPmHOGKMOAaDnKxONzbHhO1v5U0lByS6jbmKz3GUCTcKBDrNeE8VZ73CYMJcWUqhkYTdTDFYSYUaMPROmE5hlaDA3MTHbigl+zNLhVV8gIsPdFudm+PCxzT4EOuAW4sm2Oenu24DBO+HXwCW5Lh/yx0zFFNGj4mqxJEIA6vk0DV5zMgWJnvcYEkUvR8CBAxsrW2ZERiKkPp9tAMySF0wKzxDNNBmTHyOqgaDbCVxtpy+bM7DFt8lhcFVjrKk2TjuaeQDtsAGXSEBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(2906002)(6506007)(8936002)(53546011)(52536014)(9686003)(33656002)(86362001)(7696005)(26005)(8676002)(71200400001)(38100700002)(38070700005)(66946007)(316002)(55016002)(5660300002)(186003)(107886003)(7416002)(54906003)(110136005)(66446008)(64756008)(66556008)(66476007)(4326008)(76116006)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGw2bHljR3A5Unk1NnhXVUJBRUd5L3BvdElQUm0zV1hsWnNrMU5xY2RCczh6?=
 =?utf-8?B?ck9qSXF0aStNYVh1VkNTcVdqNVdGNVh6RVR0TkpBdzJQUk9hTkRIQWhWU0NC?=
 =?utf-8?B?NTUxOTQ5bjdlRVhpb1NSbjMva21nUkgzZk9tQmZrTnlPNHE2dTNuYU5SYW83?=
 =?utf-8?B?M2FqNUNJNmpCdUwrZ0I3RVJhZkdUSS9EWTVXU2dXY1VLREhUd1RHTkV4c2ow?=
 =?utf-8?B?aGtDZysycVoyMDE3U3NXU1c0L204V01uSmlsMXA5TFNzTkVYOE5icG90ekM1?=
 =?utf-8?B?QklXQlFwWDRYWjAzWWt6QWZQeWZVWjhUTTBvM3VCZmM1SEdoeFQ4MTRqL3RW?=
 =?utf-8?B?QmZwcWJ4WjkvVmppMGZ3NkRLL3JtbXp1Z3Z2R0VaZ1RIQ0NGZEpaMnhxM21I?=
 =?utf-8?B?aHhYRTRKelFTR0RoWXFTWWNoQlltYTR4Z0IrS2RRUzdzVGtTaXJUMTFtbEI0?=
 =?utf-8?B?SloxM09NK0hZL2NQWDRtWWRmWE5VNVErT0NVOEUvOG9uV1VLRnlCcEdLTE5k?=
 =?utf-8?B?RUxwUS80SFRJb1ZycUIxNkI2alhBazJsVkEzTUNCeEFGWUwzWXBEYXdPT1d4?=
 =?utf-8?B?T1JQbExROXRyeC9CYmlPWTZxRytKNDBPUDF6TDg1L2hZODZHMG9BT05IODFL?=
 =?utf-8?B?cllpVzhPT2JxQWFUaDQ0M2xKdndiRmVCWHM4V3dxMTR3SGJLdmJVYWlnS1JI?=
 =?utf-8?B?SWRMWG50SjJvZ3Jtc0V4T201MDBMZ1FQR3pTVTV6VlpheWp2MG5td1lyQUxH?=
 =?utf-8?B?ZmUzU1NFTXhJV1NVcUpkNVBlNzFTUmI4aVMrVVRZaUExVmgrRjNYT1orU3I2?=
 =?utf-8?B?Y2I2M2c4Umk4MjF5N1h1bzdUSTVoOHRETmhrd1FPajlrdllkQzZldERMeUxH?=
 =?utf-8?B?emRjZkpvZzVoU0ROakhvRVF4dFZSQzM5VDZTOHUvQmhQYlRNMTBhY3lIajRI?=
 =?utf-8?B?N1JYcWJRTHp6SWJJTzk4V041dmNWYURhTmdWQjBLUkxwQTY0VmdPejBsUW15?=
 =?utf-8?B?UGNtc2lDckRKdmFQWEk1amcvZDdkT0U1UnYxTEFtQ2FxQU4xNWgwZTdNWHls?=
 =?utf-8?B?czR3RUlOTWcwaE8xOFgwTjQwbU1wckxkTk5xeEQvNkZ5ZktxL0VtaTRvRlI0?=
 =?utf-8?B?N2o5Yy9sVnJPcVk2NWVQeGxIZjg5V0Z3U3NzTU82N2JxZnJMU1dWZVNYbnRQ?=
 =?utf-8?B?dVV4a0RKYWR0U2JjbkJBeTYyMWFZa2liOERCZEpncUpoZmp0dFJrdmp0dk44?=
 =?utf-8?B?Ris3bEpFR0JBQUxwYi9RNkpSNjZuT0hhVmJON0s3RGpqWk1ja0JDU1FMeWJS?=
 =?utf-8?B?c0lHM1NqZXlsc1B1WUtFZlVBRitoY0hXbldRTW9Yek1sSE9SandPaEgwMXBZ?=
 =?utf-8?B?d2RUSHd0Rkd3eFNBV3VoVFphVGt2T2xPVS9IVnhFdnNJTHJSY0VyMzRzSTZ3?=
 =?utf-8?B?WjBZWDhSbnh5ZzNCdVVLWmI3ZllRVzJQUVU3RnU2K3hGV21KMFdoNmFVRGNK?=
 =?utf-8?B?NjdlbW9HQ3IrdTlieldOeHpZMVN4QjhoMXZOTHJmNlIzbW9SbkJGL25JZncz?=
 =?utf-8?B?cjczRzZtdUtEVDRTR0Z0WVB5RE9ndmprREJMQW1KQ3dLWGdBbnBXcXNWa0dr?=
 =?utf-8?B?NHZ0S3owWXI2VGVsR1c1NitqRC9pazhTRUlBU21LeVRIYnZXWjVYYlRGaUZh?=
 =?utf-8?B?bnluOGdvT0IyZS9EWGtMQWxEZTEyekE0NXM4Yk1jdG93WUxWMnNJM01IRk4r?=
 =?utf-8?Q?5SIqRDk4g5LPRMP+e8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c817882-2727-4bec-a264-08d98afe9ae5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2021 08:27:17.2353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eGa0MRljjjCyE0uETiUlpiWwsTqg+9A1w6o7fG6QondUDAxqDg9BxRLT8TSLUIVMBiNOsKeUKkyTGIgRGiSiZ3CoRUlqGGD5iPHbpwk7uyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6997
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IFN1YmplY3Q6IFJlOiBbUkZDIDA3LzEyXSByYXZiOiBGaWxsdXAgcmF2
Yl9yeF9nYmV0aCgpIHN0dWINCj4gDQo+IE9uIDEwLzgvMjEgODo1OSBQTSwgU2VyZ2V5IFNodHls
eW92IHdyb3RlOg0KPiA+IE9uIDEwLzgvMjEgOTo0NiBBTSwgQmlqdSBEYXMgd3JvdGU6DQo+ID4N
Cj4gPiBbLi4uXQ0KPiA+Pj4+Pj4+Pj4gRmlsbHVwIHJhdmJfcnhfZ2JldGgoKSBmdW5jdGlvbiB0
byBzdXBwb3J0IFJaL0cyTC4NCj4gPj4+Pj4+Pj4+DQo+ID4+Pj4+Pj4+PiBUaGlzIHBhdGNoIGFs
c28gcmVuYW1lcyByYXZiX3JjYXJfcnggdG8gcmF2Yl9yeF9yY2FyIHRvIGJlDQo+ID4+Pj4+Pj4+
PiBjb25zaXN0ZW50IHdpdGggdGhlIG5hbWluZyBjb252ZW50aW9uIHVzZWQgaW4gc2hfZXRoIGRy
aXZlci4NCj4gPj4+Pj4+Pj4+DQo+ID4+Pj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8
YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4+Pj4+Pj4+PiBSZXZpZXdlZC1ieTogTGFk
IFByYWJoYWthcg0KPiA+Pj4+Pj4+Pj4gPHByYWJoYWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5l
c2FzLmNvbT5bLi4uXQ0KPiA+Pj4+Pj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPj4+Pj4+Pj4+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+Pj4+Pj4+Pj4gaW5kZXggMzcxNjRhOTgzMTU2Li40
MjU3M2VhYzgyYjkgMTAwNjQ0DQo+ID4+Pj4+Pj4+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+Pj4+Pj4+PiArKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+Pj4+Pj4+PiBAQCAtNzIwLDYgKzcyMCwyMyBA
QCBzdGF0aWMgdm9pZCByYXZiX2dldF90eF90c3RhbXAoc3RydWN0DQo+ID4+Pj4+Pj4+PiBuZXRf
ZGV2aWNlDQo+ID4+Pj4+Pj4+ICpuZGV2KQ0KPiA+Pj4+Pj4+Pj4gIAl9DQo+ID4+Pj4+Pj4+PiAg
fQ0KPiA+Pj4+Pj4+Pj4NCj4gPj4+Pj4+Pj4+ICtzdGF0aWMgdm9pZCByYXZiX3J4X2NzdW1fZ2Jl
dGgoc3RydWN0IHNrX2J1ZmYgKnNrYikgew0KPiA+Pj4+Pj4+Pj4gKwl1OCAqaHdfY3N1bTsNCj4g
Pj4+Pj4+Pj4+ICsNCj4gPj4+Pj4+Pj4+ICsJLyogVGhlIGhhcmR3YXJlIGNoZWNrc3VtIGlzIGNv
bnRhaW5lZCBpbiBzaXplb2YoX19zdW0xNikgKDIpDQo+ID4+Pj4gYnl0ZXMNCj4gPj4+Pj4+Pj4+
ICsJICogYXBwZW5kZWQgdG8gcGFja2V0IGRhdGENCj4gPj4+Pj4+Pj4+ICsJICovDQo+ID4+Pj4+
Pj4+PiArCWlmICh1bmxpa2VseShza2ItPmxlbiA8IHNpemVvZihfX3N1bTE2KSkpDQo+ID4+Pj4+
Pj4+PiArCQlyZXR1cm47DQo+ID4+Pj4+Pj4+PiArCWh3X2NzdW0gPSBza2JfdGFpbF9wb2ludGVy
KHNrYikgLSBzaXplb2YoX19zdW0xNik7DQo+ID4gWy4uLl0NCj4gPj4+Pj4gUGxlYXNlIGNoZWNr
IHRoZSBzZWN0aW9uIDMwLjUuNi4xIGNoZWNrc3VtIGNhbGN1bGF0aW9uIGhhbmRsaW5nPg0KPiA+
Pj4+PiBBbmQgZmlndXJlIDMwLjI1IHRoZSBmaWVsZCBvZiBjaGVja3N1bSBhdHRhY2hpbmcgZmll
bGQNCj4gPj4+Pg0KPiA+Pj4+ICAgIEkgaGF2ZS4NCj4gPj4+Pg0KPiA+Pj4+PiBBbHNvIHNlZSBU
YWJsZSAzMC4xNyBmb3IgY2hlY2tzdW0gdmFsdWVzIGZvciBub24tZXJyb3IgY29uZGl0aW9ucy4N
Cj4gPj4+Pg0KPiA+Pj4+PiBUQ1AvVURQL0lDUE0gY2hlY2tzdW0gaXMgYXQgbGFzdCAyYnl0ZXMu
DQo+ID4+Pj4NCj4gPj4+PiAgICBXaGF0IGFyZSB5b3UgYXJndWluZyB3aXRoIHRoZW4/IDotKQ0K
PiA+Pj4+ICAgIE15IHBvaW50IHdhcyB0aGF0IHlvdXIgY29kZSBmZXRjaGVkIHRoZSBUQ1AvVURQ
L0lDTVAgY2hlY2tzdW0NCj4gPj4+PiBJU08gdGhlIElQIGNoZWNrc3VtIGJlY2F1c2UgaXQgc3Vi
dHJhY3RzIHNpemVvZihfX3N1bTE2KSwgd2hpbGUNCj4gPj4+PiBzaG91bGQgcHJvYmFibHkgc3Vi
dHJhY3Qgc2l6ZW9mKF9fd3N1bSkNCj4gPj4+DQo+ID4+PiBBZ3JlZWQuIE15IGNvZGUgbWlzc2Vk
IElQNCBjaGVja3N1bSByZXN1bHQuIE1heSBiZSB3ZSBuZWVkIHRvDQo+ID4+PiBleHRyYWN0IDIg
Y2hlY2tzdW0gaW5mbyBmcm9tIGxhc3QgNCBieXRlcy4gIEZpcnN0IGNoZWNrc3VtKDJieXRlcykN
Cj4gPj4+IGlzIElQNCBoZWFkZXIgY2hlY2tzdW0gYW5kIG5leHQgY2hlY2tzdW0oMiBieXRlcykg
IGZvciBUQ1AvVURQL0lDTVANCj4gPj4+IGFuZCB1c2UgdGhpcyBpbmZvIGZpbmRpbmcgdGhlIG5v
biBlcnJvciBjYXNlIG1lbnRpb25lZCBpbiAgVGFibGUNCj4gMzAuMTcuDQo+ID4+Pg0KPiA+Pj4g
Rm9yIGVnOi0NCj4gPj4+IElQVjYgbm9uIGVycm9yLWNvbmRpdGlvbiAtLT4gICIweEZGRkYiLS0+
SVBWNEhlYWRlckNTdW0gdmFsdWUgYW5kDQo+ICIweDAwMDAiDQo+ID4+PiBUQ1AvVURQL0lDTVAg
Q1NVTSB2YWx1ZQ0KPiA+Pj4NCj4gPj4+IElQVjQgbm9uIGVycm9yLWNvbmRpdGlvbiAtLT4gICIw
eDAwMDAiLS0+SVBWNEhlYWRlckNTdW0gdmFsdWUgYW5kDQo+ICIweDAwMDAiDQo+ID4+PiBUQ1Av
VURQL0lDTVAgQ1NVTSB2YWx1ZQ0KPiA+Pj4NCj4gPj4+IERvIHlvdSBhZ3JlZT8NCj4gPg0KPiA+
PiBXaGF0IEkgbWVhbnQgaGVyZSBpcyBzb21lIHRoaW5nIGxpa2UgYmVsb3csIHBsZWFzZSBsZXQg
bWUga25vdyBpZiB5b3UNCj4gPj4gaGF2ZSBhbnkgaXNzdWVzIHdpdGggdGhpcywgb3RoZXJ3aXNl
IEkgd291bGQgbGlrZSB0byBzZW5kIHRoZSBwYXRjaA0KPiB3aXRoIGJlbG93IGNoYW5nZXMuDQo+
ID4+DQo+ID4+IEZ1cnRoZXIgaW1wcm92ZW1lbnRzIGNhbiBoYXBwZW4gbGF0ZXIuDQo+ID4+DQo+
ID4+IFBsZWFzZSBsZXQgbWUga25vdy4NCj4gPj4NCj4gPj4gKy8qIEhhcmR3YXJlIGNoZWNrc3Vt
IHN0YXR1cyAqLw0KPiA+PiArI2RlZmluZSBJUFY0X1JYX0NTVU1fT0sgICAgICAgICAgICAgICAg
MHgwMDAwMDAwMA0KPiA+PiArI2RlZmluZSBJUFY2X1JYX0NTVU1fT0sgICAgICAgICAgICAgICAg
MHhGRkZGMDAwMA0KPiA+DQo+ID4gICAgTWhtLCB0aGlzIHNob3VsZCBwcm9sbHkgY29tZSBmcm9t
IHRoZSBJUCBoZWFkZXJzLi4uDQo+ID4NCj4gPiBbLi4uXQ0KPiA+PiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+PiBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPj4gaW5kZXggYmJiNDJlNTMyOGU0Li5k
OTIwMWZiYmQ0NzIgMTAwNjQ0DQo+ID4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yl9tYWluLmMNCj4gPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiX21haW4uYw0KPiA+PiBAQCAtNzIyLDE2ICs3MjIsMTggQEAgc3RhdGljIHZvaWQgcmF2Yl9n
ZXRfdHhfdHN0YW1wKHN0cnVjdA0KPiA+PiBuZXRfZGV2aWNlICpuZGV2KQ0KPiA+Pg0KPiA+PiAg
c3RhdGljIHZvaWQgcmF2Yl9yeF9jc3VtX2diZXRoKHN0cnVjdCBza19idWZmICpza2IpICB7DQo+
ID4+IC0gICAgICAgdTE2ICpod19jc3VtOw0KPiA+PiArICAgICAgIHUzMiBjc3VtX3Jlc3VsdDsN
Cj4gPg0KPiA+ICAgIFRoaXMgaXMgbm90IGFnYWluc3QgdGhlIHBhdGNoIGN1cnJlbnRseSB1bmRl
ciBpbnZlc3RpZ2F0aW9uLiA6LSkNCj4gPg0KPiA+PiArICAgICAgIHU4ICpod19jc3VtOw0KPiA+
Pg0KPiA+PiAgICAgICAgIC8qIFRoZSBoYXJkd2FyZSBjaGVja3N1bSBpcyBjb250YWluZWQgaW4g
c2l6ZW9mKF9fc3VtMTYpICgyKQ0KPiBieXRlcw0KPiA+PiAgICAgICAgICAqIGFwcGVuZGVkIHRv
IHBhY2tldCBkYXRhDQo+ID4+ICAgICAgICAgICovDQo+ID4+IC0gICAgICAgaWYgKHVubGlrZWx5
KHNrYi0+bGVuIDwgc2l6ZW9mKF9fc3VtMTYpKSkNCj4gPj4gKyAgICAgICBpZiAodW5saWtlbHko
c2tiLT5sZW4gPCBzaXplb2YoX193c3VtKSkpDQo+ID4NCj4gPiAgICBJIHRoaW5rIHRoaXMgdXNh
Z2Ugb2YgX193c3VtIGlzIHZhbGlkIChJIHJlbWVtYmVyIHRoYXQgSSBzdWdnZXN0ZWQNCj4gaXQp
LiBXZSBoYXZlIDIgMTYtYml0IGNoZWNrc3VtcyBoZXJlDQo+IA0KPiAgICBJIG1lYW50ICJJIGRv
bid0IHRoaW5rIiwgb2YgY291cnNlLiA6LSkNCg0KT2sgd2lsbCB1c2UgMiAqIHNpemVvZihfX3N1
bTE2KSBpbnN0ZWFkIGFuZCBleHRyYWN0IElQVjQgaGVhZGVyIGNzdW0gYW5kIFRDUC9VRFAvSUNN
UCBjc3VtIHJlc3VsdC4NCg0KQWxsIGVycm9yIGNvbmRpdGlvbi91bnN1cHBvcnRlZCBjYXNlcyB3
aWxsIGJlIHBhc3NlZCB0byBzdGFjayB3aXRoIENIRUNLU1VNX05PTkUNCmFuZCBvbmx5IG5vbi1l
cnJvciBjYXNlcyB3aWxsIGJlIHNldCBhcyBDSEVDS1NVTV9VTk5DRVNTQVJZLg0KDQpEb2VzIGl0
IHNvdW5kcyBnb29kIHRvIHlvdT8NCg0KUmVnYXJkcywNCkJpanUNCg0KDQoNCj4gDQo+IFsuLi5d
DQo+IA0KPiBNQlIsIFNlcmdleQ0K
