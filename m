Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45435E6A38
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 20:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbiIVSBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 14:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiIVSBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 14:01:12 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70072.outbound.protection.outlook.com [40.107.7.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5C126AC9
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 11:00:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqoTkakvzDE3D4wEUWdc8osL2+DAQk5PSE+llbTNL/Vav+yqkK9MVVFpFOuYTcNW4wkpqE66BuOzrmIGa+Yzre2rb/JinlzJ54oFienS+ol9SGFVp6KVwrfx3SSI1uAsGqjfvBWpccSGgkmcT/RBVwNZlZ5NYim83joJtHA1VhmAbWLjiWqZl0Lempd1QUdA8uO+C9vej5YWjfllXvejnvdB5VLMyA2ht8Dk//gOJXVM5DWRSPqjLofoHIpQqpLOa87a4RnE+c7A04ldQOw1AEyv5NUid44TlSspdK/WxYyxH85t/I+0mkm+IsFKuZfxno8ZIhBfiCSbSDo/CBKAww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cn80rqjT0QMLiBKd0hdzQ1gbR7mAN9cWzhFc3qbCpQA=;
 b=XDRYLv1wn8fz7VA6LF4esNVjbGbOgt47chtEOZoZUcuEzReWi9y3IK3wxqX8am9+mjMHVusYfC7FO3GyimWyHzmSahS0QURS5n53wYi1WX/JiF5ssgd7thNGtGg8XvLsM0g0CrMNt2UVL8wROoT3xRBl+rhErxk6A7wy2BXmjD2Aictt9/nqu3CdPs+zKRbYhn10QaJq4WXZgl7eIYQdOnfpmjhPb1J8E0aKRxf782jhR9DP/Qql6zXrsnyOG2SR15GkN9wH25+Gw1bpesJv9fbxWsHzEbzMDCW+yZdmVZuVZTwYp8FGvibOKvNLIgYJgC84DdtgDn5zB2vtLS5tTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cn80rqjT0QMLiBKd0hdzQ1gbR7mAN9cWzhFc3qbCpQA=;
 b=l8bU3ioUCzcRw1qZ0IEwAo8bvxMDxUYUbxOChxCmtFVhHFGCItGrwPoTYeAm5AEtvUPswwEsgMdbDNufrVvG9ZybjmbYYmOi0vlehh+Hk1Av++A7hv1luD9lVHQVkDTf7fZMPwsMGeoMZQ+fj3QjUkcsX4oNEkraveHk3ekGyVg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8845.eurprd04.prod.outlook.com (2603:10a6:102:20c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 18:00:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Thu, 22 Sep 2022
 18:00:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Topic: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Thread-Index: AQHYzdpfTBwouHrLuE6KwxLywZqExq3qNnWAgAAAg4CAAEPNgIAAL2KAgADHUICAAE1UgA==
Date:   Thu, 22 Sep 2022 18:00:52 +0000
Message-ID: <20220922180051.qo6swrvz2gqwgtlp@skbuf>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
 <20220921113637.73a2f383@hermes.local>
 <20220921183827.gkmzula73qr4afwg@skbuf>
 <20220921154107.61399763@hermes.local> <Yyu6w8Ovq2/aqzBc@lunn.ch>
 <20220922062405.15837cfe@kernel.org>
In-Reply-To: <20220922062405.15837cfe@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB8845:EE_
x-ms-office365-filtering-correlation-id: a9918c01-65c0-4dbe-81a6-08da9cc463ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rkuqPA7pFbz7TOwB2FHLFxX9HWAZMY3nPHaPw1PztABmV3LlKoijczLjXnsX29wg/slzUM21tVWUhWl43LJ+g85fA08hjfSF7mctg84cOfEf5uEqKvgwGUqnuqFH99qajkwhfbNmQdQBF1ISXgsJ5R5ii0GP/q8t0P/eB8r5ZjcPRAaF+8U6v4xN6oZEvta2x5+NYKEqN+cyengC9MfoFE3xDsZMhkzjNVzmLZGeeBip2HUFq7jsJLCjP0tweWW2QBJ728UoZUi+59/juBZKvEtqcfJjaJG8dXFiY0OdEeUIqQ5cUxcAbmEVGsPy89pvr0moIFM/L3cv/1P1P0TFFzqa0yGcoTifvQpabuDgesDKFWEPzawjGTl9VMZpYCpdj2sC6wAUqlFdGinuAtLhGSJUV3jTdUvcJ0gtDY0gExFh26Wu1U2SsLSeNuXnJ/u98o/MmWiq6tBiytAS/UQOALX0EcvZjf8Of2f6V+S9DSy+M2jLO6ubmr9VTyi2/YIi7yMQXBsZNAqVmiv1fQFjiSXfOddja18CP+SchpYVXUga5rHlkYi/srwXYFW2X3Qk8lgHPcY0LpuUTg3kP3cp1275qujMUFtb+w9bJJz/4gxtIoJhNEHU7luyjjycipg/GqLQQPNdAOuiG2Cy6Fh8GDraJwXn59YvP4ZPhxZ9xg0ziU7aaXailIJCZ5oFCNALu57WYi+Rxn40t1+PMemQXBqHbEo4jkHAPgXgLF9LS0TwpgFAxOp0i8KHIhGnCRzeMfmD/FOItyH8V7TM2VLBrY2EuA1HuPKafdNubVeLknfFrAM1ppl0uw/ROERWiRBROK7VgNxRzPzZWzqGUGVmRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199015)(6486002)(966005)(71200400001)(38070700005)(8936002)(38100700002)(122000001)(1076003)(186003)(86362001)(83380400001)(6506007)(9686003)(41300700001)(316002)(54906003)(478600001)(6512007)(6916009)(26005)(8676002)(91956017)(4326008)(76116006)(66946007)(66556008)(66476007)(64756008)(5660300002)(66446008)(2906002)(44832011)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TTRpYUJxSWhHUWx3MlFUWHA2dmdoSjlENHF2TllXVzFINjE4TUdzREJkbmNw?=
 =?utf-8?B?SzFJdkE5QmR3Y1JVNmVFbU1ia21JOHIzNlV0SUo3Z1JkazN0WkpRWUthRFJF?=
 =?utf-8?B?WDU3OVozNTFNRit5SVZ0N25Ya3U5ajVWME5PS1FBbUpFbTFhRFhYbkZ6UUlW?=
 =?utf-8?B?eHBqNXBjMklRbDZ3alErWDExMjdKWUZtZDEyeWt0WG15MGZhMlREUks0TXll?=
 =?utf-8?B?NGtOb1NyTnF6bGVPeXdPR3U3VERCclNjN2QxSWJCZ3d1NWdJbTRFdnVtZEFK?=
 =?utf-8?B?Q3NaMkwrLzFKbHVsSm5KL1cxV2VXY2ZWN1FoVUYweGJ1Ly95T044cFcyNktG?=
 =?utf-8?B?aFRaM2h3d2Z2UzdKZW9LNW5DM2N3aE9lSlBrMkQxSmc1U01WTDMrYm1CL3RP?=
 =?utf-8?B?NEcxR2JKU3htZ3ZTbnVTWXY3YXBmbFVyKy9Ya2p5VnpjYnplMVQvRTErRElH?=
 =?utf-8?B?NjZOK1M4YmRmcUJyNTU3dmNwclpzL25jMTh1Z0RCQTZCU1FBeldoWU1MTnBU?=
 =?utf-8?B?b2RWaG9KRVlORCtNUkF0Umw0TTM1bUJSTzd6WXYyT0NHa2dtcmZ0VmNyT0pK?=
 =?utf-8?B?Y2dTdmd0QjMrVnJQWDllN0t3cVdObitpWDdid2lhaVQvZ0lYeEk4Qy9yL29B?=
 =?utf-8?B?TGlML3dKYlpyem9DSWkvaWJkYVVWSThjNnh5Ykk5S1F5S3VlQW9VWkg0d1Jk?=
 =?utf-8?B?a1d2clBpK1h6MTRQaDJSUHI3ZHY2MlVjZ091ekRRbnBWY3FNeFIvNUVnNXVY?=
 =?utf-8?B?d1FFLzdyaENDVFNlZFJKWW04WHRyWjVvWmw2RExKYzFDbjRtWVVTT01JL0Vy?=
 =?utf-8?B?NTdVTkswNEQ5d3BSM0VDZ3psWGdJMXQxSTV2WVJKNTJqMVhnYTRzTy9Nejhw?=
 =?utf-8?B?RTdmUDVLL0JTa3NCR2NyU2dTTE1uVk55QnhvV24vM1Z4S1licFUyQjVhNE5H?=
 =?utf-8?B?ZkFvSUFIejY0ekNpQ1B3ZloyL1FDRFdiMmswRGxpZkpLRFgremI1TzhINWJO?=
 =?utf-8?B?R3N1emFMSjJaOFRVQkZlWGNHUk9OaVRqYzJ3N3Z4ZjJMMlk0SnJYaGJLUDE2?=
 =?utf-8?B?RUZaTlhQOTZ1bXdHWnZDNzNiNTlyNDMzUUxaYUtEby8wNTA2M0VkV2xVaGl1?=
 =?utf-8?B?SXlXc01XWEJramVRU04xeXNzclZzZkczek04bXVaTUVxdmU5VHhGcU9WRGZC?=
 =?utf-8?B?SDJNb0Z2WWRkd0hpOXJET1oyUVdENFU1VmNLY0R1dEJPbEVUNkdLaTRid2hz?=
 =?utf-8?B?azk0dmhmOVR1OU1adnRmckZsMnAwWHBQc0h2Ujk0Z2M5SmxPdFY0NmRHSHUw?=
 =?utf-8?B?NnVhVnFHZ2xrZ2Q4MjNoRjF6SUlUcmZXSTJlVTRzaTYxbDhkYzZFRzZGWnpm?=
 =?utf-8?B?MjU5dldpeVpxSzJ4ZzlCYlJoL1hIaytnNStBQ0hEbFFjZWZZejZBMHlxd3Yv?=
 =?utf-8?B?U0h6cVkvK1k1bmlMNUg3aXRVeUhIRmtiNnZQaytSTVE3d2l4WGtaSnpzakRT?=
 =?utf-8?B?c1V2bzBCb1BVN0k0c1BnR2o5OVJxcTFzQ2hkMGVhOEliVkNLeVRzQlhFOE90?=
 =?utf-8?B?S2dtSCt0cy9XdG9ENTNKbTZWdlluWjBEV0FjcGYrVmlDZVZHYkJ4Sk1MNnhE?=
 =?utf-8?B?bGtsZTBBdnJQckNIb2Z2dlBqd3pzOW9CTVAwd3VHNGZreURzRFJJZ1Yvblk4?=
 =?utf-8?B?cDl1K3pBVEFVeVhYeXBUdk9RclJySHEwWUt4aWtSTUc3V0h5SHhJNTFDakU1?=
 =?utf-8?B?dmloVXhsRDh1WndiR1U3R0NEcXZ5ejZRRHRqUmtab0l0YmxpS21VaDhLNmM0?=
 =?utf-8?B?bWE2b2JhUGVZZ0ZOQVdDN1A4Q3ZmZ0hwRFdjWGZpV2FhUUFWZGlXcDcrVFFM?=
 =?utf-8?B?VVljOE5BeEkzQUpYMytTdWFhdkIxY1I3ZXAvM2w3VDgyNGlZbTl4V1g2OFBv?=
 =?utf-8?B?VVJPRUdPOWh4WHlIWFN4Y3VMU3QyQTZyTm1GU2VsanQ5ZHdFV3ErSE1pOWR5?=
 =?utf-8?B?N1VTc0xrc0RuanFFNnQ2SmFvWUJpTzZXQ1IvZ0t6T2JKU21wdzBjTDhsQXQy?=
 =?utf-8?B?NmZCZWlmaVZrUVBTWkFNTkduaEQrSFlvUDFZU1JkUDNiNEY2Vy93R1pmTUY5?=
 =?utf-8?B?WVA5SGVlL2Jwb3h6QWpTVjhwODFkd0NCdjliSVd6ODZyOXd1QncvbXpmK3hB?=
 =?utf-8?B?TEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DED82C532A42A34BA23F00B0102634A6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9918c01-65c0-4dbe-81a6-08da9cc463ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 18:00:52.6094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e55hJjEzMoZy6frDkqAhF31q6lU+eHK2si5KEEvaFPJdnmPWDYKmTOhm5c94anq0azTBbGCF0LOa4lqV20rqMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8845
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBTZXAgMjIsIDIwMjIgYXQgMDY6MjQ6MDVBTSAtMDcwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+IE9uIFRodSwgMjIgU2VwIDIwMjIgMDM6MzA6NDMgKzAyMDAgQW5kcmV3IEx1bm4g
d3JvdGU6DQo+ID4gTG9va2luZyBhdCB0aGVzZSwgbm9uZSByZWFsbHkgZml0IHRoZSBjb25jZXB0
IG9mIHdoYXQgdGhlIG1hc3Rlcg0KPiA+IGludGVyZmFjZSBpcy4NCj4gPiANCj4gPiBzbGF2ZSBp
cyBhbHNvIHVzZWQgcXVpdGUgYSBsb3Qgd2l0aGluIERTQSwgYnV0IHdlIGNhbiBwcm9iYWJseSB1
c2UNCj4gPiB1c2VyIGluIHBsYWNlIG9mIHRoYXQsIGl0IGlzIGFscmVhZHkgc29tZXdoYXQgdXNl
ZCBhcyBhIHN5bm9ueW0gd2l0aGluDQo+ID4gRFNBIHRlcm1pbm9sb2d5Lg0KPiA+IA0KPiA+IERv
IHlvdSBoYXZlIGFueSBtb3JlIHJlY29tbWVuZGF0aW9ucyBmb3Igc29tZXRoaW5nIHdoaWNoIHBh
aXJzIHdpdGgNCj4gPiB1c2VyLiANCj4gDQo+IGNwdS1pZmM/IHZpYT8NCg0KSXQgbG9va3MgbGlr
ZSBJJ2xsIGhhdmUgdG8gcmUtZXZhbHVhdGUgbXkgcGF0aCBvZiBtaW5pbWFsIGVmZm9ydCB0byBt
YWtlDQpwcm9ncmVzcyB3aXRoIHRoaXMuDQoNCkkgZG9uJ3QgbGlrZSBjcHUtaWZjIGJlY2F1c2Ug
aXQgaXNuJ3Qgc3VmZmljaWVudGx5IGRpc3Rpbmd1aXNoZWQgZnJvbQ0KY3B1IHBvcnQsIHdoaWNo
IGlzIHRoZSBzd2l0Y2ggc2lkZSBpbnRlcmZhY2UgdGhhdCBpcyBjb25uZWN0ZWQgdG8gdGhlDQpt
YXN0ZXIuICJUaGUgQ1BVIGludGVyZmFjZSBjb25uZWN0cyB0byB0aGUgQ1BVIHBvcnQsIG9mIGNv
dXJzZSIuDQoNCkFzIGZvciB2aWEsIEkgZGlkbid0IGV2ZW4ga25vdyB0aGF0IHRoaXMgaGFkIGEg
c2VyaW91cyB1c2UgaW4gRW5nbGlzaCBhcw0KYSBub3VuLCBvdGhlciB0aGFuIHRoZSB2ZXJ5IHNw
ZWNpZmljIHRlcm0gZm9yIFBDQiBkZXNpZ24uIEkgZmluZCBpdA0KcHJldHR5IGhhcmQgdG8gdXNl
IGluIHNwZWVjaDogInRoZSB2aWEgaW50ZXJmYWNlIGRvZXMgdGhpcyBvciB0aGF0Ii4NCg0KR29p
bmcgYmFjayB0byBzb21lIG9mIHRoZSBzdWdnZXN0aW9ucyBGbG9yaWFuIHByb3Bvc2VkOg0KaHR0
cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L25ldGRldmJwZi9wYXRjaC8yMDIyMDkw
NDE5MDAyNS44MTM1NzQtMS12bGFkaW1pci5vbHRlYW5AbnhwLmNvbS8jMjQ5OTk0MzUNCg0KfCBI
b3cgYWJvdXQgImNvbmR1aXQiIG9yICJtZ210X3BvcnQiIG9yIHNvbWUgdmFyaWFudCBpbiB0aGUg
c2FtZSBsZXhpY29uPw0KDQpJIHRoaW5rICJtZ210X3BvcnQiIHJlYWxseSBkb2Vzbid0IGRvIGEg
Z3JlYXQgam9iIG9mIGRpc3Rpbmd1aXNoaW5nDQppdHNlbGYgZnJvbSBzb21ldGhpbmcgdGhhdCBj
b3VsZCBiZWxvbmcgdG8gdGhlIHN3aXRjaCBpdHNlbGYgZWl0aGVyPw0KDQoiQ29uZHVpdCIgbWln
aHQgYmUgYSBiZXR0ZXIgZm9ybSBvZiAidmlhIi4gSSBkb24ndCBoYXZlIGEgaHVnZSBwcm9ibGVt
DQp3aXRoIGl0LCBleGNlcHQgdGhhdA0KKGEpIGl0J3Mgbm90IGEgdmVyeSBjb252ZW50aW9uYWwg
c29mdHdhcmUgdGVybQ0KKGIpIGluIFJvbWFuaWFuLCAiY29uZHVpdCIgbWVhbnMgImNvbmR1Y3TE
gyIsIGFuZCAiY29uZHVjdCIgbWVhbnMgImNvbmR1aXTEgyIuDQogICAgTm90ZSB0aGF0IHRoaXMg
cHJvYmFibHkgc2hvdWxkbid0IG1hdHRlciwgYnV0IHNpbmNlIHdlJ3JlIGhhdmluZw0KICAgIHRo
aXMgZGlzY3Vzc2lvbiBkdWUgdG8gcGVyc29uYWwgZmVlbGluZ3MsIEkgdGhvdWdodCBJJ2QgbWVu
dGlvbiB0aGF0DQogICAgdG8gbWUsIGl0IHJlcXVpcmVzIHRoYXQgbXVjaCBtb3JlIGJyYWluIHBv
d2VyIDspDQoNCkkgYWxzbyBrZWVwIHRoaW5raW5nIGFib3V0ICJob3N0IGNvbnRyb2xsZXIiLCBh
YmJyZXZpYXRlZCB0byAiSEMiLCB3aGljaA0KaGFzIHRoZSBzYW1lIGNvbm5vdGF0aW9uIGFzIGlu
IFVTQiAoeEhDSSkuIEJ1dCBJJ20gYWZyYWlkIHRoaXMgbWlnaHQgZ2V0DQpjb25mdXNlZCB3aXRo
IHRoZSBTUEkvSTJDL01ESU8gY29udHJvbGxlciB0aGF0IGdldHMgdXNlZCBmb3IgdGhlDQpyZWdp
c3RlciBhY2Nlc3MuIE1heWJlIGhvc3QgRXRoZXJuZXQgY29udHJvbGxlciwgYWJicmV2aWF0ZWQg
IkhFQyI/DQpCdXQgYSBib25kaW5nIGludGVyZmFjZSBjYW4gYWxzbyBiZSBhIERTQSBtYXN0ZXIs
IGlzIGl0IHByb3BlciB0byBjYWxsDQp0aGF0IGEgSEVDPw0KDQpBbm90aGVyIHByb3BlcnR5IHRo
YXQgdGhlIG5hbWUgc2hvdWxkIGhhdmUgaXMgdGhhdCBpdCBzaG91bGQgYmUgd2VsbA0Kc3VpdGVk
IGZvciByZWN1cnNpdmUgdXNlLCBtZWFuaW5nIHRoYXQgYSBzd2l0Y2ggaGFzIGEgRFNBIG1hc3Rl
ciwgYnV0DQp0aGF0IGludGVyZmFjZSBpcyBpdHNlbGYgYSBzd2l0Y2ggcG9ydCB3aGljaCBoYXMg
YSBEU0EgbWFzdGVyIG9mIGl0cw0Kb3duLCBhbmQgc28gb24uIFBlcmhhcHMgdGhlICJob3N0IGNv
bnRyb2xsZXIiIG5hbWUgaXMgdG9vIHN1Z2dlc3RpdmUgb2YNCmp1c3QgdGhlIGJvdHRvbS1tb3N0
IGhvc3QgbmV0d29yayBpbnRlcmZhY2UsIHJhdGhlciB0aGFuIGJlaW5nIGFibGUgdG8NCmJlIG5l
c3RlZD8NCg0KVGhlcmUncyBhbHNvIHRoZSBvcHRpb24gdG8gdXNlIHRoZSBnb29kIG9sZCBmYXNo
aW9uZWQgd29yZCAicGFyZW50Ii4NCkkgY2FuJ3QgZmluZCB0b28gbWFueSBjb3VudGVyIGFyZ3Vt
ZW50cyBhZ2FpbnN0IGl0LCBleGNlcHQgb25lIHdoaWNoDQpKYWt1YiBoYXMgYWxzbyBleHByZXNz
ZWQgc29tZXdoZXJlIGVsc2UsIHdoaWNoIGlzIHRoYXQgdGhlIHJlbGF0aW9uc2hpcA0KYmV0d2Vl
biBhIHVzZXIgcG9ydCBhbmQgaXRzIHBhcmVudCBpcyBhY3R1YWxseSByZXZlcnNlZCB3aGVuIGl0
IGNvbWVzIHRvDQp0aGUgbmV0ZGV2IGFkamFjZW5jeSBsaXN0cy4gVGhlIHVzZXIgcG9ydHMgYXJl
IHRoZSB1cHBlciBpbnRlcmZhY2VzIG9mDQp0aGUgcGFyZW50Lg0KDQpCdXQgSSBkb24ndCBrbm93
IGlmIHRoYXQgaXMgYSB2ZXJ5IGdvb2QgYXJndW1lbnQuIEl0J3MgcHJldHR5IGhhcmQgdG8NCmNs
ZWFybHkgc2F5IGlmIHRoZSBEU0EgbWFzdGVyIGlzICJvbiB0b3Agb2YiIG9yICJiZW5lYXRoIiBz
d2l0Y2ggcG9ydHMuDQpJbiBEb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvZHNhL2RzYS5yc3QsIHdl
IGhhdmUgdGhpcyBwaWN0dXJlIHdoaWNoDQpzaG93cyB0aGUgc3RhY2tpbmcuIEknZCBzYXkgaW4g
c29mdHdhcmUsIHRoZSBEU0EgbWFzdGVyIGlzIGF0IHRoZSBib3R0b20NCihhIGxvd2VyIGludGVy
ZmFjZSksIHdoaWxlIGluIGhhcmR3YXJlLCBpdCBpcyBhdCB0aGUgdG9wICh0aGUgcGFyZW50IG9m
DQphIHNlcmllcyBvZiBhdHRhY2hlZCBzd2l0Y2hlcykuDQoNCiAgICAgICAgICAgICAgICBVbmF3
YXJlIGFwcGxpY2F0aW9uDQogICAgICAgICAgICAgIG9wZW5zIGFuZCBiaW5kcyBzb2NrZXQNCiAg
ICAgICAgICAgICAgICAgICAgICAgfCAgXg0KICAgICAgICAgICAgICAgICAgICAgICB8ICB8DQog
ICAgICAgICAgICstLS0tLS0tLS0tLXYtLXwtLS0tLS0tLS0tLS0tLS0tLS0tLSsNCiAgICAgICAg
ICAgfCstLS0tLS0rICstLS0tLS0rICstLS0tLS0rICstLS0tLS0rfA0KICAgICAgICAgICB8fCBz
d3AwIHwgfCBzd3AxIHwgfCBzd3AyIHwgfCBzd3AzIHx8DQogICAgICAgICAgIHwrLS0tLS0tKy0r
LS0tLS0tKy0rLS0tLS0tKy0rLS0tLS0tK3wNCiAgICAgICAgICAgfCAgICAgICAgICBEU0Egc3dp
dGNoIGRyaXZlciAgICAgICAgfA0KICAgICAgICAgICArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0rDQogICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgXg0KICAgICAg
ICAgICAgVGFnIGFkZGVkIGJ5IHwgICAgICAgIHwgVGFnIGNvbnN1bWVkIGJ5DQogICAgICAgICAg
IHN3aXRjaCBkcml2ZXIgfCAgICAgICAgfCBzd2l0Y2ggZHJpdmVyDQogICAgICAgICAgICAgICAg
ICAgICAgICAgdiAgICAgICAgfA0KICAgICAgICAgICArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0rDQogICAgICAgICAgIHwgVW5tb2RpZmllZCBob3N0IGludGVyZmFjZSBkcml2
ZXIgIHwgU29mdHdhcmUNCiAgIC0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tKy0tLS0tLS0tLS0tLQ0KICAgICAgICAgICB8ICAgICAgIEhvc3QgaW50ZXJmYWNlIChl
dGgwKSAgICAgICB8IEhhcmR3YXJlDQogICAgICAgICAgICstLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLSsNCiAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICBeDQogICAg
ICAgICBUYWcgY29uc3VtZWQgYnkgfCAgICAgICAgfCBUYWcgYWRkZWQgYnkNCiAgICAgICAgIHN3
aXRjaCBoYXJkd2FyZSB8ICAgICAgICB8IHN3aXRjaCBoYXJkd2FyZQ0KICAgICAgICAgICAgICAg
ICAgICAgICAgIHYgICAgICAgIHwNCiAgICAgICAgICAgKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tKw0KICAgICAgICAgICB8ICAgICAgICAgICAgICAgU3dpdGNoICAgICAgICAg
ICAgICB8DQogICAgICAgICAgIHwrLS0tLS0tKyArLS0tLS0tKyArLS0tLS0tKyArLS0tLS0tK3wN
CiAgICAgICAgICAgfHwgc3dwMCB8IHwgc3dwMSB8IHwgc3dwMiB8IHwgc3dwMyB8fA0KICAgICAg
ICAgICArKy0tLS0tLSstKy0tLS0tLSstKy0tLS0tLSstKy0tLS0tLSsr
