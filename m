Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2558D54015E
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 16:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245493AbiFGO3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 10:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241271AbiFGO3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 10:29:44 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30118.outbound.protection.outlook.com [40.107.3.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256B9237ED;
        Tue,  7 Jun 2022 07:29:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/Tr5KZCnPIlKycbTw5f9hGffyV02dpeDAtlj2Ia4WY6Ja5EVY0zjFfGWxKgg4kTDXV54l+v0NilHe20HukzCpx8QEAWk9FeevwlraEQG2i3Pqr5FQdp2pCHZj6bgqPERMFigqRroio85tWZ+Mn7yAoUJNk1fk1nuWEQqOfFd6HSOTijQpsBH2TPYd/AF8kmVtnRQMf28SZPZdFed1bopz5ZM3P8HqK8DhwiPGyA3MfIA9fFiI1baM+xNMdB2UyiYTmGJaltbIqf6O0sXssa8j2cYF/tSmvAQrrGDxcLjaBrUnTW8KKfYNf5zYM+D/S6wn/4F49wxDmYe59QrVg4Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+QOfAchK+M4dcvZ19F0s/whQdF7CYlba1U8svaHRKw=;
 b=J1PrLS1KJYJA/hUDOJ3XBOhT38hwTAl9Yqn+YnmJmbk5XRKWRuDgYSdarzzbcMf8lePZRrdl/Qe+XKBWMsyG12KdLUoSUfljD7mDxKBGpXgdSSq4r6hD/Fh5L4IS8szGTdkvC+3MBdwZnNkVw8VssdSi/leeKI1bBXLc7YOo28fo9bgHIyub70G/u1eJOk6ZfwTTj5Dkzc160nbYKG20U4T2dj+caajtTgjexMpWkjIgc2qR44XUjAJwUoheLguxPA43+fQBs9iceS9TdRph+mYw4edkYudIc1UepeGEREmKMsGSKawIYoGSl1HCTQHsKHqx+iwpWeqIOgKJq/19dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+QOfAchK+M4dcvZ19F0s/whQdF7CYlba1U8svaHRKw=;
 b=Y//6NQloaFaQtIfa3qftNWF0pxivhXYOc/rbCS9U76RxrW6DCsu2y3TUFPw+Gq20p4H2K3EocEZsrpp/0Ywv+qCmKEa6bqU0B3HGXtR9RqnkqqxZHETBs/xNEeMpkyUespqml9AIFDbMBq640/uf6wf4r05g9qgY3B2oLEF0/ME=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by VI1PR03MB3070.eurprd03.prod.outlook.com (2603:10a6:802:30::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 14:29:39 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111%7]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 14:29:39 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] net: dsa: realtek: rtl8365mb: handle PHY
 interface modes correctly
Thread-Topic: [PATCH net-next 5/5] net: dsa: realtek: rtl8365mb: handle PHY
 interface modes correctly
Thread-Index: AQHYeavPWWwLhyrlgEyQwpcIV6TS3K1EAQYAgAABqwA=
Date:   Tue, 7 Jun 2022 14:29:39 +0000
Message-ID: <20220607142938.u2alfq52wojb327d@bang-olufsen.dk>
References: <20220606134553.2919693-1-alvin@pqrs.dk>
 <20220606134553.2919693-6-alvin@pqrs.dk>
 <CAJq09z7gRosx0uBRCyP6xc0GUFMgnKCdry3BL-iB13M=JEY3hQ@mail.gmail.com>
In-Reply-To: <CAJq09z7gRosx0uBRCyP6xc0GUFMgnKCdry3BL-iB13M=JEY3hQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a68b316-d448-4481-fe2d-08da489227b1
x-ms-traffictypediagnostic: VI1PR03MB3070:EE_
x-microsoft-antispam-prvs: <VI1PR03MB30708FB5F328BDDFFD6AD98D83A59@VI1PR03MB3070.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f/3Eof/H8EpwX1xiUVax5cNdphr1e5geOXIcUqoUzwrFaDQJHi8VpCPknyATIutHKPQwfADfUIZXu3z8IHj8DRLCs+UIQaYWcMjwFGDpPc6oNmOquYi+tb2COD3jS/k3ofT/DBwJnptB7l6AtuU5GLzl+1cJ5Nl+9geu5ENx3JzumvCp2jy74ocVUGNyIbfVzXsKHB1U7H7DrT+pVPQgRIJiaDDVJ4Xv31b5NHkzT9lMSNr4DwC1Aq7TX06wSyc58C/HqkIRPybyfBqjhNkYjGQVGRy7mrLllRHxfvydfOjTc2+6Hv8aRtkOej1NBaODuSpDgo8HsTo80F+lI4dpJ89m8y9qNJ8FobyMrrgW/mRDQAiun+gUsAsbTbtERiGrGR29GdxQ7iHrLH1cZUNQnIu35orPD7v1vwevN7GjRRmT/++48hOGIsXIJifGRJoxHioBapA+SBVxxsxppwUhUycdeW6CAJVmyBTjGUE5mxDnDxoz6wmsiE6fd1WX8DVTpbFRxPj2Ioe9U4n856byAaUE3UesFkpP8d/Zeb9DLVCC4TcCzhANnxquReEwf9kruEIF5E79Nfl1z4cZH1ItTxyWPc9127Kqz3OnCDEvIZfconwpSghPV5T/pJAWAFVAfAOgT4ZwjIT6jy37Fob9Px8U5+xxTR0BTj3/n60f1O1qYmZRdQwXymDOj5R8uuN8YUYPDy0Uo9zGy3MZrXthAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(8976002)(36756003)(85182001)(85202003)(2906002)(8936002)(26005)(5660300002)(6506007)(6916009)(6512007)(54906003)(7416002)(71200400001)(6486002)(508600001)(66446008)(122000001)(4326008)(66476007)(66946007)(8676002)(83380400001)(91956017)(64756008)(86362001)(1076003)(38100700002)(38070700005)(66556008)(2616005)(186003)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHNNbFZObHBPOU5LTkRHTTRiK0k4N2Y3WXhTdWloWnY0ckZIOHdPcXFqTjlS?=
 =?utf-8?B?dEhOTHJObkRUTlVReURIQ1pKU2xLSU1pMUtUbVo1NXBueDBac3ZXY0NranZs?=
 =?utf-8?B?bkw3RnFidHR2blB5V3NzOFJWT0VNUlMxNm1tVUsvM2dFOWVzS1U3MFZuWlFj?=
 =?utf-8?B?TDJrV292eWlwVkxUUjI2MEs0Y21CVUhqaVlrQnQzSEhhcjlwblp4V2s3eFFX?=
 =?utf-8?B?Ry8xaWc1NmN3NTFpdWJEUENxSk9NMjhzbjlSRXl5MDNiL0U1V2s3Tk9ZU0U2?=
 =?utf-8?B?cVBna1R3bVZ3NzB6MWNxaXlCUnpXQkF4Z1laUmg0UkVYdVhxZDlPZElwb0l0?=
 =?utf-8?B?M0dqV2tNeU5JWDBJV0lLSDczc3JiMWtSRG9JakltdzJWQ09pQkMwZEFlZnV4?=
 =?utf-8?B?R2VQZG0zWVQ2dEk5eVcvVWNVU3pIRDZVb3llcVJtNmxoQXdEbXlmSkZKMlBv?=
 =?utf-8?B?WURKSTA2L2lyQitNTCt6L0tncU9UeVVZVG5WL1V6MlVpc0FkSnFLdXhINjdp?=
 =?utf-8?B?MnJ6VDB0cWRZSFpLRWh4VjljckNTWjM0bWdidFR4Ri8yd0lHSWViRXB2MGRo?=
 =?utf-8?B?ZUdxb0ZoM0x4WGRvUVRvN2ZQa2ZyYjNKNXZUUUQwYXpmaXluZkJGaXBwTTJG?=
 =?utf-8?B?dXBFTnlqQmJnN3ZpdE1sZjkrVllDKzVZVVlRdWNmcHJmZHZjendzQlFlUVEw?=
 =?utf-8?B?R3I0WE1SWDdDelg2K3VnYVNiQjd2RzFtTTN6YVV0cTZHVFVsaWhuamZ6bDBE?=
 =?utf-8?B?M2VOejN2NXBtajhCV0E5eXI0amxvdnpFcXV1S0h4TlM3RldNUnVLa3hGU2RK?=
 =?utf-8?B?dnpmcVpxcjJQZE9lZjhPMWZ5NU5Lb1ZzN1J1a2Jta215Yml3dENETXVJYTQ1?=
 =?utf-8?B?eEluNDdDZGZTOUVjbkg0WTg0Z01hQjhSL1YxaXlTNmVDM2Q4VVg5T1p5d1Jx?=
 =?utf-8?B?eDZjNzRZSEVEMXBER1R2ZkRlQnlSRmZXeS9DQkR4bVFtd0Nwb1h2N3kzY2dw?=
 =?utf-8?B?YzVsWDh0aG9CTk1uWGY5U0l3bFpoN1BYamM3bXRWVVUrMktmd1FFNEliT3Jq?=
 =?utf-8?B?UTNsdW0zN20vTVNNTlM4dE4xZVJkY1RWT09PNkhRd01ONjAyeTZYK0hkU3Jq?=
 =?utf-8?B?NGpCQXIxK1hFa1JuSUVvMEtsOW10REwxSm92RDJCa0Q4MXozL2VwWUFVMkxC?=
 =?utf-8?B?d2s3VHZYcTJFMEFOVlFySUVoRDRRdnNpN2IrQ0ttUjRDbWNxRXpMYzVyUTY5?=
 =?utf-8?B?R0FDOUcvZG9PaVdHQTEyUjU4citoNnVEYThXTjlrSXU1aHBaR05BMlY4TTlv?=
 =?utf-8?B?WC9mQ1pwUzE5TWRhWXZwdnRjQW1qbGw4MTZGVWRMT1hMRmNyd3ErdjZGSUxt?=
 =?utf-8?B?aHFnZk5hWjNkRjJGdXRlQmpWa3hscE4zRDlSanNybThTSWNHcHMrVGJuMW9Q?=
 =?utf-8?B?b3FsMWNJQlk1Ym1USE1VbHJaY2pIKzhIU2tNZXlPdlRBaXhaUmpqQ2ZXMmts?=
 =?utf-8?B?NkJrV2xJQVBVeUkyS1MreExIak03b3k4WEl4WE5VSGt5MFg2MUk5MWZYb1RD?=
 =?utf-8?B?SUpEY0FNZ1RORXZoSjAxV09kaDBtRFg3RTdFbldCYmJVWFUwK1czV0ptWHp3?=
 =?utf-8?B?Zjc3ZTJSaWdkMUpIRjNQb2NhczQyZ0VPVy9ONTJTdXNyK0FGdE9oemh2TkIv?=
 =?utf-8?B?YVBxZXV4STNrZG9hcmMxYzhaTDJhQURLbU5tdjh2Q1dKQ29aSERZN1RGTGJt?=
 =?utf-8?B?M2pDS2hUM0F2a0ljN05RRTRKWFJJOGVDZnBpTEYxSU9iOHdFWnNNODZFMWFG?=
 =?utf-8?B?TTlqQ1F5bUNoSE16VGdQSDFITWRKbU9KZlhYaXVuNTdGdjNrM3ZsYk1RUlFR?=
 =?utf-8?B?c2JOdGNBRjk3RWlOQjVOTTlkWndIcUlaZm9oOUVhemtMdmowanVLcHJwRjNU?=
 =?utf-8?B?d05WUzB2enozZnoxYlVFRi92UkRQVmNGbFJreVdZNUpjdjljN1NGemFUdlpt?=
 =?utf-8?B?QU1keDJpS2tlM2JjTEcxYXdjeGlTTW82Q2N4REUyUFpWR0oveDJwR2RkZlJW?=
 =?utf-8?B?bjhxbzV1bi83T1RESFJkZGFGRHhCZ0JTbU8zRmh2QU5KWUNVU1ljYXA4UWtW?=
 =?utf-8?B?ZnhvLzk4dXNNYjAxdXRtTHhFRExqeEMxbFZRNW9MTzJPM3JMc2tZVXhzKzh0?=
 =?utf-8?B?VmJsVUx6d24rVTh0R1RqaWZVNlgyRTM0OU1FSWhyU3J5VmMxcnVHdHdnR1VN?=
 =?utf-8?B?eGdSNjQ2cWtMRDI1anVMSS8rZVdjUW1OUWRRakh1d09ESlNMUUZRSWYrT0Zn?=
 =?utf-8?B?T3pjc1VlRkt5N1RhaFZ5Z3dKTzFNVDk3aDBqT2Exblp5VTlYSU1JTHhQdXht?=
 =?utf-8?Q?xP2D5EEvLv6G/H64=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E7EFFCDAD2B5447BDA23C2B62EE0CB8@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a68b316-d448-4481-fe2d-08da489227b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2022 14:29:39.4122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UKNrWc3r+mu9J5KKWNWWjEUYPJaJJQ/R/6GGIZioFCMrDfOWTemmotV6RYydA5nesqudPmfdPUrhIA71aULOSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB3070
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBKdW4gMDcsIDIwMjIgYXQgMTE6MjM6NDBBTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gPiBGcm9tOiBBbHZpbiDilLzDoWlwcmFnYSA8YWxzaUBiYW5n
LW9sdWZzZW4uZGs+DQo+ID4NCj4gPiBSZWFsdGVrIHN3aXRjaGVzIGluIHRoZSBydGw4MzY1bWIg
ZmFtaWx5IGFsd2F5cyBoYXZlIGF0IGxlYXN0IG9uZSBwb3J0DQo+ID4gd2l0aCBhIHNvLWNhbGxl
ZCBleHRlcm5hbCBpbnRlcmZhY2UsIHN1cHBvcnRpbmcgUEhZIGludGVyZmFjZSBtb2RlcyBzdWNo
DQo+ID4gYXMgUkdNSUkgb3IgU0dNSUkuIFRoZSBwdXJwb3NlIG9mIHRoaXMgcGF0Y2ggaXMgdG8g
aW1wcm92ZSB0aGUgZHJpdmVyJ3MNCj4gPiBoYW5kbGluZyBvZiB0aGVzZSBwb3J0cy4NCj4gPg0K
PiA+IEEgbmV3IHN0cnVjdCBydGw4MzY1bWJfY2hpcF9pbmZvIGlzIGludHJvZHVjZWQuIEEgc3Rh
dGljIGluc3RhbmNlIG9mDQo+ID4gdGhpcyBzdHJ1Y3QgaXMgYWRkZWQgZm9yIGVhY2ggc3VwcG9y
dGVkIHN3aXRjaCwgd2hpY2ggaXMgZGlzdGluZ3Vpc2hlZA0KPiA+IGJ5IGl0cyBjaGlwIElEIGFu
ZCB2ZXJzaW9uLiBFbWJlZGRlZCBpbiBlYWNoIGNoaXBfaW5mbyBzdHJ1Y3QgaXMgYW4NCj4gPiBh
cnJheSBvZiBzdHJ1Y3QgcnRsODM2NW1iX2V4dGludCwgZGVzY3JpYmluZyB0aGUgZXh0ZXJuYWwg
aW50ZXJmYWNlcw0KPiA+IGF2YWlsYWJsZS4gVGhpcyBpcyBtb3JlIHNwZWNpZmljIHRoYW4gdGhl
IG9sZCBydGw4MzY1bWJfZXh0aW50X3BvcnRfbWFwLA0KPiA+IHdoaWNoIHdhcyBvbmx5IHZhbGlk
IGZvciBzd2l0Y2hlcyB3aXRoIHVwIHRvIDYgcG9ydHMuDQo+ID4NCj4gPiBUaGUgc3RydWN0IHJ0
bDgzNjVtYl9leHRpbnQgYWxzbyBjb250YWlucyBhIGJpdG1hc2sgb2Ygc3VwcG9ydGVkIFBIWQ0K
PiA+IGludGVyZmFjZSBtb2Rlcywgd2hpY2ggYWxsb3dzIHRoZSBkcml2ZXIgdG8gZGlzdGluZ3Vp
c2ggd2hpY2ggcG9ydHMNCj4gPiBzdXBwb3J0IFJHTUlJLiBUaGlzIGNvcnJlY3RzIGEgcHJldmlv
dXMgbWlzdGFrZSBpbiB0aGUgZHJpdmVyIHdoZXJlYnkgaXQNCj4gPiB3YXMgYXNzdW1lZCB0aGF0
IGFueSBwb3J0IHdpdGggYW4gZXh0ZXJuYWwgaW50ZXJmYWNlIHN1cHBvcnRzIFJHTUlJLg0KPiA+
IFRoaXMgaXMgbm90IGFjdHVhbGx5IHRoZSBjYXNlOiBmb3IgZXhhbXBsZSwgdGhlIFJUTDgzNjdT
IGhhcyB0d28NCj4gPiBleHRlcm5hbCBpbnRlcmZhY2VzLCBvbmx5IHRoZSBzZWNvbmQgb2Ygd2hp
Y2ggc3VwcG9ydHMgUkdNSUkuIFRoZSBmaXJzdA0KPiA+IHN1cHBvcnRzIG9ubHkgU0dNSUkgYW5k
IEhTR01JSS4gVGhpcyBuZXcgZGVzaWduIHdpbGwgbWFrZSBpdCBlYXNpZXIgdG8NCj4gPiBhZGQg
c3VwcG9ydCBmb3Igb3RoZXIgaW50ZXJmYWNlIG1vZGVzLg0KPiA+DQo+ID4gRmluYWxseSwgcnRs
ODM2NW1iX3BoeWxpbmtfZ2V0X2NhcHMoKSBpcyBmaXhlZCB1cCB0byByZXR1cm4gc3VwcG9ydGVk
DQo+ID4gY2FwYWJpbGl0aWVzIGJhc2VkIG9uIHRoZSBleHRlcm5hbCBpbnRlcmZhY2UgcHJvcGVy
dGllcyBkZXNjcmliZWQgYWJvdmUuDQo+ID4gVGhpcyBhbGxvd3MgZm9yIHBvcnRzIHdpdGggYW4g
ZXh0ZXJuYWwgaW50ZXJmYWNlIHRvIGJlIHRyZWF0ZWQgYXMgRFNBDQo+ID4gdXNlciBwb3J0cywg
YW5kIGZvciBwb3J0cyB3aXRoIGFuIGludGVybmFsIFBIWSB0byBiZSB0cmVhdGVkIGFzIERTQSBD
UFUNCj4gPiBwb3J0cy4NCj4gDQo+IFRoYXQncyBhIG5pY2UgcGF0Y2guIEJ1dCB3aGlsZSBkZWFs
aW5nIHdpdGggZXh0IGludGVyZmFjZXMsIHdvdWxkbid0DQo+IGl0IGJlIG5pY2UgdG8gYWxzbyBh
ZGQNCj4gYSBtYXNrIGZvciB1c2VyIHBvcnRzPyBXZSBjb3VsZCBlYXNpbHkgdmFsaWRhdGUgaWYg
YSBkZWNsYXJlZCBkc2EgcG9ydA0KPiByZWFsbHkgZXhpc3RzLg0KDQpBdCBiZXN0IHRoaXMgd2ls
bCBiZSB1c2VmdWwgdG8gZW1pdCBhIHdhcm5pbmcgZm9yIHRoZSBkZXZpY2UgdHJlZSBhdXRob3Iu
DQpDYW4geW91IHNlZSBhbnkgb3RoZXIgYmVuZWZpdD8NCg0KPiANCj4gLi4uDQo+IA0KPiA+IEBA
IC0xOTk3LDMzICsyMTIyLDI3IEBAIHN0YXRpYyBpbnQgcnRsODM2NW1iX2RldGVjdChzdHJ1Y3Qg
cmVhbHRla19wcml2ICpwcml2KQ0KPiA+ICAgICAgICAgY2FzZSBSVEw4MzY1TUJfQ0hJUF9JRF84
MzY1TUJfVkM6DQo+ID4gICAgICAgICAgICAgICAgIHN3aXRjaCAoY2hpcF92ZXIpIHsNCj4gPiAg
ICAgICAgICAgICAgICAgY2FzZSBSVEw4MzY1TUJfQ0hJUF9WRVJfODM2NU1CX1ZDOg0KPiA+IC0g
ICAgICAgICAgICAgICAgICAgICAgIGRldl9pbmZvKHByaXYtPmRldiwNCj4gPiAtICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAiZm91bmQgYW4gUlRMODM2NU1CLVZDIHN3aXRjaCAodmVy
PTB4JTA0eClcbiIsDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2hpcF92
ZXIpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIG1iLT5jaGlwX2luZm8gPSAmcnRsODM2
NW1iX2NoaXBfaW5mb184MzY1bWJfdmM7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgYnJl
YWs7DQo+ID4gICAgICAgICAgICAgICAgIGNhc2UgUlRMODM2NU1CX0NISVBfVkVSXzgzNjdSQl9W
QjoNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICBkZXZfaW5mbyhwcml2LT5kZXYsDQo+ID4g
LSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgImZvdW5kIGFuIFJUTDgzNjdSQi1WQiBz
d2l0Y2ggKHZlcj0weCUwNHgpXG4iLA0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGNoaXBfdmVyKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBtYi0+Y2hpcF9pbmZv
ID0gJnJ0bDgzNjVtYl9jaGlwX2luZm9fODM2N3JiX3ZiOw0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgIGJyZWFrOw0KPiA+ICAgICAgICAgICAgICAgICBjYXNlIFJUTDgzNjVNQl9DSElQX1ZF
Ul84MzY3UzoNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICBkZXZfaW5mbyhwcml2LT5kZXYs
DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgImZvdW5kIGFuIFJUTDgzNjdT
IHN3aXRjaCAodmVyPTB4JTA0eClcbiIsDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgY2hpcF92ZXIpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIG1iLT5jaGlwX2lu
Zm8gPSAmcnRsODM2NW1iX2NoaXBfaW5mb184MzY3czsNCj4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICBicmVhazsNCj4gPiAgICAgICAgICAgICAgICAgZGVmYXVsdDoNCj4gPiAtICAgICAgICAg
ICAgICAgICAgICAgICBkZXZfZXJyKHByaXYtPmRldiwgInVucmVjb2duaXplZCBzd2l0Y2ggdmVy
c2lvbiAodmVyPTB4JTA0eCkiLA0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Y2hpcF92ZXIpOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGRldl9lcnIocHJpdi0+ZGV2
LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgInVucmVjb2duaXplZCBzd2l0
Y2ggKGlkPTB4JTA0eCwgdmVyPTB4JTA0eCkiLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgY2hpcF9pZCwgY2hpcF92ZXIpOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAg
IHJldHVybiAtRU5PREVWOw0KPiA+ICAgICAgICAgICAgICAgICB9DQo+IA0KPiBXaXRoIHRoaXMg
cGF0Y2gsIHdlIG5vdyBoYXZlIGEgbmljZSBjaGlwX2luZm8gZm9yIGVhY2ggZGV2aWNlLiBJZiB3
ZQ0KPiBncm91cCBhbGwgb2YgdGhlbSBpbiBhbiBhcnJheSwgd2UgY291bGQgaXRlcmF0ZSBvdmVy
IHRoZW0gaW5zdGVhZCBvZg0KPiBzd2l0Y2hpbmcgb3ZlciBjaGlwX2lkL3Zlci4gSW4gdGhpcyBj
YXNlLCBhZGRpbmcgYSBuZXcgdmFyaWFudCBpcyBqdXN0DQo+IGEgbWF0dGVyIG9mIGNyZWF0aW5n
IGEgbmV3IGNoaXBfaW5mbyBhbmQgYWRkaW5nIHRvIHRoZSBhcnJheS4gV2hlbiB0aGUNCj4gY2hp
cCBpZC92ZXIgaXMgb25seSB1c2VkIGluc2lkZSBhIHNpbmdsZSBjaGlwX2luZm8sIEkgZG9uJ3Qg
a25vdyBpZiB3ZQ0KPiBzaG91bGQga2VlcCBhIG1hY3JvIGRlY2xhcmluZyBlYWNoIHZhbHVlLiBG
b3IgZXhhbXBsZSwNCj4gDQo+ICNkZWZpbmUgUlRMODM2NU1CX0NISVBfSURfODM2N1MgICAgICAg
ICAweDYzNjcNCj4gI2RlZmluZSBSVEw4MzY1TUJfQ0hJUF9WRVJfODM2N1MgICAgICAgIDB4MDBB
MA0KPiAuLi4NCj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgcnRsODM2NW1iX2NoaXBfaW5mbyBydGw4
MzY1bWJfY2hpcF9pbmZvXzgzNjdzID0gew0KPiArICAgICAgIC5uYW1lID0gIlJUTDgzNjdTIiwN
Cj4gKyAgICAgICAuY2hpcF9pZCA9IFJUTDgzNjVNQl9DSElQX0lEXzgzNjdTLA0KPiArICAgICAg
IC5jaGlwX3ZlciA9IFJUTDgzNjVNQl9DSElQX1ZFUl84MzY3UywNCj4gKyAgICAgICAuZXh0aW50
cyA9IHsNCj4gKyAgICAgICAgICAgICAgIHsgNiwgMSwgUEhZX0lOVEYoU0dNSUkpIHwgUEhZX0lO
VEYoSFNHTUlJKSB9LA0KPiArICAgICAgICAgICAgICAgeyA3LCAyLCBQSFlfSU5URihNSUkpIHwg
UEhZX0lOVEYoVE1JSSkgfCBQSFlfSU5URihSTUlJKSB8DQo+ICsgICAgICAgICAgICAgICAgICAg
ICAgIFBIWV9JTlRGKFJHTUlJKSB9LA0KPiArICAgICAgICAgICAgICAgeyAvKiBzZW50aW5lbCAq
LyB9DQo+ICsgICAgICAgfSwNCj4gKyAgICAgICAuamFtX3RhYmxlID0gcnRsODM2NW1iX2luaXRf
amFtXzgzNjVtYl92YywNCj4gKyAgICAgICAuamFtX3NpemUgPSBBUlJBWV9TSVpFKHJ0bDgzNjVt
Yl9pbml0X2phbV84MzY1bWJfdmMpLA0KPiArfTsNCj4gDQo+IHNlZW1zIHRvIGJlIGFzIGNsZWFy
IGFzOg0KPiANCj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgcnRsODM2NW1iX2NoaXBfaW5mbyBydGw4
MzY1bWJfY2hpcF9pbmZvXzgzNjdzID0gew0KPiArICAgICAgIC5uYW1lID0gIlJUTDgzNjdTIiwN
Cj4gKyAgICAgICAuY2hpcF9pZCA9IDB4NjM2NywNCj4gKyAgICAgICAuY2hpcF92ZXIgPSAweDAw
QTAsDQo+ICsgICAgICAgLmV4dGludHMgPSB7DQo+ICsgICAgICAgICAgICAgICB7IDYsIDEsIFBI
WV9JTlRGKFNHTUlJKSB8IFBIWV9JTlRGKEhTR01JSSkgfSwNCj4gKyAgICAgICAgICAgICAgIHsg
NywgMiwgUEhZX0lOVEYoTUlJKSB8IFBIWV9JTlRGKFRNSUkpIHwgUEhZX0lOVEYoUk1JSSkgfA0K
PiArICAgICAgICAgICAgICAgICAgICAgICBQSFlfSU5URihSR01JSSkgfSwNCj4gKyAgICAgICAg
ICAgICAgIHsgLyogc2VudGluZWwgKi8gfQ0KPiArICAgICAgIH0sDQo+ICsgICAgICAgLmphbV90
YWJsZSA9IHJ0bDgzNjVtYl9pbml0X2phbV84MzY1bWJfdmMsDQo+ICsgICAgICAgLmphbV9zaXpl
ID0gQVJSQVlfU0laRShydGw4MzY1bWJfaW5pdF9qYW1fODM2NW1iX3ZjKSwNCj4gK307DQo+IA0K
PiBidXQgc21hbGxlciBhbmQgbm90IHNwcmVhZCBvdmVyIHRoZSBzb3VyY2UuDQoNCkdvb2QgaWRl
YSEgQWxiZWl0IGF0IHRoZSBjb3N0IG9mIG9uZSBtb3JlIGxldmVsIG9mIGluZGVudGF0aW9uIDst
KQ0KDQpJJ2xsIGdpdmUgaXQgYSBnbyBmb3IgdjIuDQoNCktpbmQgcmVnYXJkcywNCkFsdmlu
