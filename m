Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1200359669C
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 03:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbiHQBTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 21:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiHQBTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 21:19:51 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20067.outbound.protection.outlook.com [40.107.2.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F172F6715F
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 18:19:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuBW60fX7XfSN23ncKsUXvOqsllJsKkA9z9TPtjSpEz0DaJgQmEyOreQSIo7SwDM0iGvWvkRIIzhBPuxpXdyaLi9/ExFkg4GkTqweqpTEozcCQPzlIPJEnzsbvmbUQWYl0cd0Y4n6p36DL/1hmo5vbk4xCND33XvY5ervnw7gUR559pet7qKUU+ovqkVED1kdxxWkHNFV8KvAR9FQYQv+GpH0WPs2cb3PhEDJ3/hNIrQqKgnmwbzKAOKwp3W2gjHcnIlzvCzguuVjhusZfvbLhzZ/JqrLtBHRX6JOs7/mZcDItOQTew3+NY8O2PI2u+dzpbqzKyy8EQDOVee8XkeEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=grQOBSY/J8243+Xkt1Jt8lRigUHip7A0QNxjPLAaFZo=;
 b=RtU913ppFmc5mcB4mx5FHxhpFA81lS/7U6NUOObzawcHA3DGoZDev69ptii/dhcVnQqzgY2GRwTuneUFH+aUQJOxKyTOvOb5jsNWyBtaFvXbWv4OduX4uyBgC8roSeg2/4jRlmHvJxpAFq4/BkdWAmoaxHt9PaQt6Qkqo7vS/BH/2UItl4cY4bXtQ7SYUhqGrEWjRkxx7gvo8eoHdNu1mIhGY9o4Hbava4w98DSUaLicYjxxzvzDGaLF4MkEly0/FPH6g8X9TaUxS/XnenopjJhwxdV9QuYyStpdFnYu4VwiiQNFnmJGR9ZIiMLTGubsnmAFd1xZ59RBvuAhWEVHsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=grQOBSY/J8243+Xkt1Jt8lRigUHip7A0QNxjPLAaFZo=;
 b=h0VjyoMBo0TUgfUaBvIMbTYPA0P4qqdGEPBvsQtSY/qU7DiXjzY6xhSXtijvsDR6vJf/EHAl6Te4M93cvDnrcm7xegKdvJZ4EqREwXiiGDQsy1k97ux81V5HjeiIUURFMgU6mszxmegaHX5uIZm88RT3wYnsR4eqdUulGb8AAD8=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR04MB6798.eurprd04.prod.outlook.com (2603:10a6:803:131::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 01:19:45 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Wed, 17 Aug 2022
 01:19:45 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Clark Wang <xiaoning.wang@nxp.com>
Subject: RE: [PATCH V2 net-next] net: phy: realtek: add support for
 RTL8221F(D)(I)-VD-CG
Thread-Topic: [PATCH V2 net-next] net: phy: realtek: add support for
 RTL8221F(D)(I)-VD-CG
Thread-Index: AQHYsWcUGDLIiIjn8kO3omCWgDjwHq2xg8QAgADHR6A=
Date:   Wed, 17 Aug 2022 01:19:45 +0000
Message-ID: <DB9PR04MB81064D5CD90E219C5D1E69DC886A9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220816194859.2369-1-wei.fang@nxp.com>
 <ca814367-5147-67d1-8cdb-35f57c2cbb99@gmail.com>
In-Reply-To: <ca814367-5147-67d1-8cdb-35f57c2cbb99@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2a96c9a-e9c2-4eb9-bfa5-08da7fee91d9
x-ms-traffictypediagnostic: VI1PR04MB6798:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K+tty9FpAxMyBBYIuDmT5xNplb5mbBTMEpLdii4EQvFn87N3ZsG47zkXakPb4uRAJQdFA3rQPlgma+Jz7yxPIZGhJfs4opwtMg8vOyJIlNpsXzHMjkklpPz9HHl7OBCPZydfFY8pqppcwpS15Qcid7DVKTtbRcwCnrqR63fheItF+vrBnbeTE+cTzHOif8i+Exs17FnmCExK+K+YxDe7pCGz0A4q5wkMb8MI2BUj7vYAVdgy3uLvlOxD11lssVi+kSz/wP9Q1k2Ri5MyGcWBlENGp9IhH2Ni1K8LZL6vrnfzT5XlrzyEGW5MPmMnCemIc6PX9ycIxWgmIcGCUWuNPs4fFuufMGdeAdLoBpnqLXkfCJAtpcgt2UjAL3K7PxJmEiHT4sfAAIGvO9py8P+3gMv1JJBCi4NLEC1OE4Ah3S3b/BneTdICm6yfJZo2rCDrY0e8duo4KmZbNNLuYfaN4aFlY+8Uxqsy2m4Ro18TkvFtWpgRwC34KDlzBkbrJvMHI19hn8R1HBJOZDMxC3dUe5e8aAfBUtQvXObumD133kknkQ9znBbKx77XaUSs3gCJosVrMdPIHpk1gVSGG14dEm1xWYA1p5EtHJAqv5yRaAP/TCwVdTt/ng3RsLRg21p0tGxoxMxunfR6hvoBQ0p+yx9kRYVNGGKVgC98mIpCN2LNgGAI8YCK0KvJ4HHl7c1qIox+OoJEH+keLiqT9iUlFtA41r7RESSfC+MubW2AsWBHafjeQHMTaym6FYtM0iUJ4ZKiRChCizJAzvoGYWhPhmraV13k09msCsnSAcoupFk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(71200400001)(44832011)(316002)(4326008)(478600001)(41300700001)(52536014)(66476007)(64756008)(8936002)(66556008)(110136005)(5660300002)(76116006)(66446008)(66946007)(8676002)(38100700002)(38070700005)(6506007)(33656002)(86362001)(7696005)(2906002)(122000001)(186003)(55016003)(9686003)(53546011)(83380400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Kzc4ZUdJQ2c0a05XSkFQYmZLNFZweUd2YjlBeXhsZ05yRDJPNVZjNmkrU1Na?=
 =?utf-8?B?M2hjbmVYcTFpYWlpcEIzS3hsQTMwMFdxVTl2U0tmYVhRZnpWSkpTbkhVbEEz?=
 =?utf-8?B?L1ZEQVV1MzZOWW1XdzAyTSs4YTB4VjlSN2g2UmJBNGNRcVJFRUd3WlN3Z0NF?=
 =?utf-8?B?OE5WRm5Wa3VPZGZmMHE2TkFSbE50VWc0REMrdDVvejZWTWdUSzlsakkyZ0dQ?=
 =?utf-8?B?RTVTNkMzaG9YcGEraENldmd1KzVIK1R0ZW1vV0xXaGRCWnIzQmF6R2hGdTBi?=
 =?utf-8?B?YnU3MGc3UVphdXVpZWlMbk8xcnQvZ01pZWkwb1MrWndSQ0x1RHZoMUpUak04?=
 =?utf-8?B?WDc5aGE5OFVoZzdJdEJ6bXRhQzFkS3d0UTZWcnNMZ2o5NzNzU1JTbmd2OHkw?=
 =?utf-8?B?Yy9ZUHFmNjRWTlowU0VMWFhTOFBETEhnbzJ2R1JDc0dNcWRWaWROZE1nMERl?=
 =?utf-8?B?NHhrM1IveSt3bmNLdkgremFIY1htNXFub20xY1lWdW0zOThGVnZDOGQvdHl0?=
 =?utf-8?B?cWliUDNkbzVnM09mTVRJUXgxNFo2b3h3SWUvQkZlQkV3RGY4aUJDaWJWNVZU?=
 =?utf-8?B?QzNWSVJ5SHM0QTdFVmNDb0w3SkhJL1JOdlZFZG13VFlja24zNFlEZnJVMFJI?=
 =?utf-8?B?V2hOK1NBRjhOQkVJdS9yTzRzeFBrWkt4WTQ5Z0czdnFFaWRSR3RNcXdlMXhy?=
 =?utf-8?B?V1MyeVZRdkIvTFhmQWgySnByZEE2NWFvNm5SQy9rUm9GdXZZdjdQeUora2NZ?=
 =?utf-8?B?NWYyWVUxdE5WRDB1RzVoTVFTL0hiOHFjblBrN05ldmN1a0NMTURXeVluOC9h?=
 =?utf-8?B?S0pVM0N3T1hnTnhOYzB4cXpaVVZ4SkVRUHZHRFBDeFpWU2wxU2U5QUxHYjlX?=
 =?utf-8?B?YU5aVlA3dFZqZXNNaWp2SmE5RTAvVndaWS8xOSt3UC9FV1AwTTd5RE9rOUNm?=
 =?utf-8?B?ZmUxQ0VzZWdHZkFKSkZDelB6eU0rUFFabVg4Q3BpS3V4UnhGMllFa25LYWxE?=
 =?utf-8?B?Q3dYUFd0bUh5ZTVLVXUrdzM3R040Mkp0TnlUVW1WaWU1by9LeUhQYXhhWFpr?=
 =?utf-8?B?RThXdmNITTU4UzJYMm0xZFRyOEFmSitIVDR6eUp2bHNQQTBMWXpvM1VGdEg4?=
 =?utf-8?B?bWFwYmFDNlovUEpTbUVvNWUxNnFvWDhpNjZqUlcvalJZb3RxNzhwY2lLRkVI?=
 =?utf-8?B?T2t5RjNUKzFXWk9lZDVMVm54NXgwZGo1eVJ0akN0OUIvTzlHMHNscGQvNXhL?=
 =?utf-8?B?TU5kTHVhamhacnh5N2ozS1FKdENsY1o2U3JGVGIxM0hlRERYRXQ2cU45OHdP?=
 =?utf-8?B?SXE0N0tjRElneVhzb3VuOG5jdjhoR3JBdjVvYTNjcUNUTGltQk1EQ2lYdGNZ?=
 =?utf-8?B?Z1d6bktOUkVPSFRQU2liME51MGQ1d2pva0lCelRTb1lQU0YrM29FSHlrQktt?=
 =?utf-8?B?OWsvTlZhMElOdTVIUCt4KytvOVdiSiswM053emhrSURwcHZiNWNsZ3JpcjRz?=
 =?utf-8?B?aGF1amdEbGVacy9abUtmYmpjdzVDR1k1KytzWlpldWFFWTdhemtMdk5obmQ2?=
 =?utf-8?B?NjNHaGxkaUY5N1lpaWloM2pjYllpYnVjZng5TWlpTkJQN2VxYjcvMHRHNUVT?=
 =?utf-8?B?b1ZEcWpHUk5YYThINVJkdG9QbjJWU3NoOHBVSHJqSFJxcjNJdFF0SU9tWVFV?=
 =?utf-8?B?TTA1RVlQc1JIeklJcFZHZGxmRGs1ZXVOVzkvOU9CU0pnMm9XSWpMZTAxUk8y?=
 =?utf-8?B?UHJsamZDekRVTmZNOWtCNlhEdFBnQldTajFNVjNKNXR5cnc3NzF5WkNKNzcw?=
 =?utf-8?B?bVpIQWV5dDVvNHIzaTlYOGszTUVZdkZsekxUeFlrci9UVUJTTm9Vc0VLcXkz?=
 =?utf-8?B?TXRoM3hNLzQyTFBqVFc2d1M5dVJBUDNvQ2pISXVrRXFGNFFvT3VjZFpIZnFo?=
 =?utf-8?B?aHhkeEtEeVBGZDNnSjVnYVV1eGxoRm50S1UzeGVNUWxkbmZFK3IxaXo1b3dZ?=
 =?utf-8?B?eVlOQU1EdmZxWlZyb2lleWRqSXdYZk5Cb3hDVE9tdU5ndVFsNEtuY0cxU2lw?=
 =?utf-8?B?M2tMd3R3KzIyVkovZk5tcWRNNzFzK2RnZ0huUWswaDZtWE1yblQ0ZjNTTmM0?=
 =?utf-8?Q?C0Yk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a96c9a-e9c2-4eb9-bfa5-08da7fee91d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 01:19:45.1944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jUQdwdBs9RprEZpCxviTs4Y4P0HZHrrt7aAwm0z5nD1/UVrC7KCppdioJMnq0gQWe14H1gFZ6dBYeDPMeCiqaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6798
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGVpbmVyIEthbGx3ZWl0
IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMuW5tDjmnIgxNuaXpSAyMToyMw0K
PiBUbzogV2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+OyBhbmRyZXdAbHVubi5jaDsgbGludXhA
YXJtbGludXgub3JnLnVrOw0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUu
Y29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+IHBhYmVuaUByZWRoYXQuY29tOyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnDQo+IENjOiBDbGFyayBXYW5nIDx4aWFvbmluZy53YW5nQG54cC5jb20+DQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggVjIgbmV0LW5leHRdIG5ldDogcGh5OiByZWFsdGVrOiBhZGQgc3Vw
cG9ydCBmb3INCj4gUlRMODIyMUYoRCkoSSktVkQtQ0cNCj4gDQo+IE9uIDE2LjA4LjIwMjIgMjE6
NDgsIHdlaS5mYW5nQG54cC5jb20gd3JvdGU6DQo+ID4gRnJvbTogQ2xhcmsgV2FuZyA8eGlhb25p
bmcud2FuZ0BueHAuY29tPg0KPiA+DQo+ID4gUlRMODIyMUYoRCkoSSktVkQtQ0cgaXMgdGhlIHBp
bi10by1waW4gdXBncmFkZSBjaGlwIGZyb20NCj4gPiBSVEw4MjIxRihEKShJKS1DRy4NCj4gDQo+
IEhlcmUgeW91IHRhbGsgYWJvdXQgUlRMODIyMSwgaW4gdGhlIGRyaXZlciBzdHJ1Y3QgZGVmaW5p
dGlvbiB5b3Ugc2F5IFJUTDgyMTEuDQo+IFlvdSBjaGFuZ2VkIHRoZSBuYW1pbmcgYWxyZWFkeSBm
b3IgdjIuIEl0IHdvdWxkIGJlIHRpbWUgZm9yIHlvdSB0byBjbGFyaWZ5DQo+IHdoaWNoIGNoaXAg
eW91IGFjdHVhbGx5IG1lYW4uDQo+IFJUTDgyMjEgaXMgYSAyLjVHYnBzIFBIWSwgaG93ZXZlciB5
b3UgZG9uJ3QgaGFuZGxlIHRoaXMgbW9kZSBpbiB5b3VyIGNvZGUuDQo+IA0KU29ycnkgYWdhaW4s
IGFjdHVhbGx5IGl0J3MgUlRMODIxMS4NCg0KPiA+DQo+ID4gQWRkIG5ldyBQSFkgSUQgZm9yIHRo
aXMgY2hpcC4NCj4gPiBJdCBkb2VzIG5vdCBzdXBwb3J0IFJUTDgyMTFGX1BIWUNSMiBhbnltb3Jl
LCBzbyByZW1vdmUgdGhlIHcvcg0KPiA+IG9wZXJhdGlvbiBvZiB0aGlzIHJlZ2lzdGVyLg0KPiA+
DQo+ID4gU2lnbmVkLW9mZi1ieTogQ2xhcmsgV2FuZyA8eGlhb25pbmcud2FuZ0BueHAuY29tPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiA+IC0tLQ0K
PiA+IFYyIGNoYW5nZToNCj4gPiAxLiBDb21taXQgbWVzc2FnZSBjaGFuZ2VkLCBSVEw4MjIxIGlu
c3RlYWQgb2YgUlRMODgyMS4NCj4gPiAyLiBBZGQgaGFzX3BoeWNyMiB0byBzdHJ1Y3QgcnRsODIx
eF9wcml2Lg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9waHkvcmVhbHRlay5jIHwgNDQNCj4g
PiArKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0NCj4gPiAgMSBmaWxlIGNo
YW5nZWQsIDMyIGluc2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9yZWFsdGVrLmMgYi9kcml2ZXJzL25ldC9waHkvcmVhbHRl
ay5jDQo+ID4gaW5kZXggYTU2NzFhYjg5NmIzLi4zZDk5ZmQ2NjY0ZDcgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9uZXQvcGh5L3JlYWx0ZWsuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9y
ZWFsdGVrLmMNCj4gPiBAQCAtNzAsNiArNzAsNyBAQA0KPiA+ICAjZGVmaW5lIFJUTEdFTl9TUEVF
RF9NQVNLCQkJMHgwNjMwDQo+ID4NCj4gPiAgI2RlZmluZSBSVExfR0VORVJJQ19QSFlJRAkJCTB4
MDAxY2M4MDANCj4gPiArI2RlZmluZSBSVExfODIxMUZWRF9QSFlJRAkJCTB4MDAxY2M4NzgNCj4g
Pg0KPiA+ICBNT0RVTEVfREVTQ1JJUFRJT04oIlJlYWx0ZWsgUEhZIGRyaXZlciIpOw0KPiBNT0RV
TEVfQVVUSE9SKCJKb2huc29uDQo+ID4gTGV1bmciKTsgQEAgLTc4LDYgKzc5LDcgQEAgTU9EVUxF
X0xJQ0VOU0UoIkdQTCIpOyAgc3RydWN0DQo+IHJ0bDgyMXhfcHJpdg0KPiA+IHsNCj4gPiAgCXUx
NiBwaHljcjE7DQo+ID4gIAl1MTYgcGh5Y3IyOw0KPiA+ICsJYm9vbCBoYXNfcGh5Y3IyOw0KPiA+
ICB9Ow0KPiA+DQo+ID4gIHN0YXRpYyBpbnQgcnRsODIxeF9yZWFkX3BhZ2Uoc3RydWN0IHBoeV9k
ZXZpY2UgKnBoeWRldikgQEAgLTk0LDYNCj4gPiArOTYsNyBAQCBzdGF0aWMgaW50IHJ0bDgyMXhf
cHJvYmUoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikgIHsNCj4gPiAgCXN0cnVjdCBkZXZpY2Ug
KmRldiA9ICZwaHlkZXYtPm1kaW8uZGV2Ow0KPiA+ICAJc3RydWN0IHJ0bDgyMXhfcHJpdiAqcHJp
djsNCj4gPiArCXUzMiBwaHlfaWQgPSBwaHlkZXYtPmRydi0+cGh5X2lkOw0KPiA+ICAJaW50IHJl
dDsNCj4gPg0KPiA+ICAJcHJpdiA9IGRldm1fa3phbGxvYyhkZXYsIHNpemVvZigqcHJpdiksIEdG
UF9LRVJORUwpOyBAQCAtMTA4LDEzDQo+ID4gKzExMSwxNiBAQCBzdGF0aWMgaW50IHJ0bDgyMXhf
cHJvYmUoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4gPiAgCWlmIChvZl9wcm9wZXJ0eV9y
ZWFkX2Jvb2woZGV2LT5vZl9ub2RlLCAicmVhbHRlayxhbGRwcy1lbmFibGUiKSkNCj4gPiAgCQlw
cml2LT5waHljcjEgfD0gUlRMODIxMUZfQUxEUFNfUExMX09GRiB8DQo+IFJUTDgyMTFGX0FMRFBT
X0VOQUJMRSB8DQo+ID4gUlRMODIxMUZfQUxEUFNfWFRBTF9PRkY7DQo+ID4NCj4gPiAtCXJldCA9
IHBoeV9yZWFkX3BhZ2VkKHBoeWRldiwgMHhhNDMsIFJUTDgyMTFGX1BIWUNSMik7DQo+ID4gLQlp
ZiAocmV0IDwgMCkNCj4gPiAtCQlyZXR1cm4gcmV0Ow0KPiA+ICsJcHJpdi0+aGFzX3BoeWNyMiA9
ICEocGh5X2lkID09IFJUTF84MjExRlZEX1BIWUlEKTsNCj4gPiArCWlmIChwcml2LT5oYXNfcGh5
Y3IyKSB7DQo+ID4gKwkJcmV0ID0gcGh5X3JlYWRfcGFnZWQocGh5ZGV2LCAweGE0MywgUlRMODIx
MUZfUEhZQ1IyKTsNCj4gPiArCQlpZiAocmV0IDwgMCkNCj4gPiArCQkJcmV0dXJuIHJldDsNCj4g
Pg0KPiA+IC0JcHJpdi0+cGh5Y3IyID0gcmV0ICYgUlRMODIxMUZfQ0xLT1VUX0VOOw0KPiA+IC0J
aWYgKG9mX3Byb3BlcnR5X3JlYWRfYm9vbChkZXYtPm9mX25vZGUsICJyZWFsdGVrLGNsa291dC1k
aXNhYmxlIikpDQo+ID4gLQkJcHJpdi0+cGh5Y3IyICY9IH5SVEw4MjExRl9DTEtPVVRfRU47DQo+
ID4gKwkJcHJpdi0+cGh5Y3IyID0gcmV0ICYgUlRMODIxMUZfQ0xLT1VUX0VOOw0KPiA+ICsJCWlm
IChvZl9wcm9wZXJ0eV9yZWFkX2Jvb2woZGV2LT5vZl9ub2RlLCAicmVhbHRlayxjbGtvdXQtZGlz
YWJsZSIpKQ0KPiA+ICsJCQlwcml2LT5waHljcjIgJj0gflJUTDgyMTFGX0NMS09VVF9FTjsNCj4g
PiArCX0NCj4gPg0KPiA+ICAJcGh5ZGV2LT5wcml2ID0gcHJpdjsNCj4gPg0KPiA+IEBAIC00MDAs
MTIgKzQwNiwxNCBAQCBzdGF0aWMgaW50IHJ0bDgyMTFmX2NvbmZpZ19pbml0KHN0cnVjdCBwaHlf
ZGV2aWNlDQo+ICpwaHlkZXYpDQo+ID4gIAkJCXZhbF9yeGRseSA/ICJlbmFibGVkIiA6ICJkaXNh
YmxlZCIpOw0KPiA+ICAJfQ0KPiA+DQo+ID4gLQlyZXQgPSBwaHlfbW9kaWZ5X3BhZ2VkKHBoeWRl
diwgMHhhNDMsIFJUTDgyMTFGX1BIWUNSMiwNCj4gPiAtCQkJICAgICAgIFJUTDgyMTFGX0NMS09V
VF9FTiwgcHJpdi0+cGh5Y3IyKTsNCj4gPiAtCWlmIChyZXQgPCAwKSB7DQo+ID4gLQkJZGV2X2Vy
cihkZXYsICJjbGtvdXQgY29uZmlndXJhdGlvbiBmYWlsZWQ6ICVwZVxuIiwNCj4gPiAtCQkJRVJS
X1BUUihyZXQpKTsNCj4gPiAtCQlyZXR1cm4gcmV0Ow0KPiA+ICsJaWYgKHByaXYtPmhhc19waHlj
cjIpIHsNCj4gPiArCQlyZXQgPSBwaHlfbW9kaWZ5X3BhZ2VkKHBoeWRldiwgMHhhNDMsIFJUTDgy
MTFGX1BIWUNSMiwNCj4gPiArCQkJCSAgICAgICBSVEw4MjExRl9DTEtPVVRfRU4sIHByaXYtPnBo
eWNyMik7DQo+ID4gKwkJaWYgKHJldCA8IDApIHsNCj4gPiArCQkJZGV2X2VycihkZXYsICJjbGtv
dXQgY29uZmlndXJhdGlvbiBmYWlsZWQ6ICVwZVxuIiwNCj4gPiArCQkJCUVSUl9QVFIocmV0KSk7
DQo+ID4gKwkJCXJldHVybiByZXQ7DQo+ID4gKwkJfQ0KPiA+ICAJfQ0KPiA+DQo+ID4gIAlyZXR1
cm4gZ2VucGh5X3NvZnRfcmVzZXQocGh5ZGV2KTsNCj4gPiBAQCAtOTIzLDYgKzkzMSwxOCBAQCBz
dGF0aWMgc3RydWN0IHBoeV9kcml2ZXIgcmVhbHRla19kcnZzW10gPSB7DQo+ID4gIAkJLnJlc3Vt
ZQkJPSBydGw4MjF4X3Jlc3VtZSwNCj4gPiAgCQkucmVhZF9wYWdlCT0gcnRsODIxeF9yZWFkX3Bh
Z2UsDQo+ID4gIAkJLndyaXRlX3BhZ2UJPSBydGw4MjF4X3dyaXRlX3BhZ2UsDQo+ID4gKwl9LCB7
DQo+ID4gKwkJUEhZX0lEX01BVENIX0VYQUNUKFJUTF84MjExRlZEX1BIWUlEKSwNCj4gPiArCQku
bmFtZQkJPSAiUlRMODIxMUYtVkQgR2lnYWJpdCBFdGhlcm5ldCIsDQo+IA0KPiBUaGlzIGNvbmZs
aWN0cyB3aXRoIFJUTDgyMjEgaW4gdGhlIGNvbW1pdCBtZXNzYWdlLg0KPiANCj4gPiArCQkucHJv
YmUJCT0gcnRsODIxeF9wcm9iZSwNCj4gPiArCQkuY29uZmlnX2luaXQJPSAmcnRsODIxMWZfY29u
ZmlnX2luaXQsDQo+ID4gKwkJLnJlYWRfc3RhdHVzCT0gcnRsZ2VuX3JlYWRfc3RhdHVzLA0KPiA+
ICsJCS5jb25maWdfaW50cgk9ICZydGw4MjExZl9jb25maWdfaW50ciwNCj4gPiArCQkuaGFuZGxl
X2ludGVycnVwdCA9IHJ0bDgyMTFmX2hhbmRsZV9pbnRlcnJ1cHQsDQo+ID4gKwkJLnN1c3BlbmQJ
PSBnZW5waHlfc3VzcGVuZCwNCj4gPiArCQkucmVzdW1lCQk9IHJ0bDgyMXhfcmVzdW1lLA0KPiA+
ICsJCS5yZWFkX3BhZ2UJPSBydGw4MjF4X3JlYWRfcGFnZSwNCj4gPiArCQkud3JpdGVfcGFnZQk9
IHJ0bDgyMXhfd3JpdGVfcGFnZSwNCj4gPiAgCX0sIHsNCj4gPiAgCQkubmFtZQkJPSAiR2VuZXJp
YyBGRS1HRSBSZWFsdGVrIFBIWSIsDQo+ID4gIAkJLm1hdGNoX3BoeV9kZXZpY2UgPSBydGxnZW5f
bWF0Y2hfcGh5X2RldmljZSwNCg0K
