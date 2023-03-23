Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F193C6C716C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 20:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjCWT6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 15:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCWT63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 15:58:29 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2125.outbound.protection.outlook.com [40.107.22.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75C112871;
        Thu, 23 Mar 2023 12:58:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEVaQOcM9y+yYeFODi6Pp7xSDudGZ+b0VYSIDyVZGaBBCZbSD07MG4DYyEL/AZMLAvEu+k/QZc7uJ/H+KUHtwdIX7SBUYBAiQo1KaEz/917xpYz4kXvCwDsP7lMZoWf80e6vPXTKbLyu8bVmig4MSFXT8uz8Y3PgLwUTxG4AR6h837muceT985s411O1LUB6hVTvrQ05vFUTt7+Jn+c0oNYGmAcGEMke/sCSzr3vdtsHNX4jhN6EBc9j2kkbZ83Ipuojd1a4hz7x/V6hfnw4T6SZ3UyBZOEYevHVVeW+J9STNmu4Dbm4bjoUY57uA0hqrsfh53reYqOoDKYuzOC8rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FHbDsqPKtt3CmtW4bQBSAerL6A+X466WDLXEIhGkI18=;
 b=WBH2o+23Rk2Lc8Y4tyesCC9oNp3DZ5ybmp+37txtIco+8xsPg8P/YCcU5aK9KIjKc8gbDXsZ/F+UOueBVQ+gGVodNbahBIS9+ZF/lXBPMlePS+GtEQLb02bpACJGNpFf4GktIlJWfdMNbq6PqiFSBWdxzsGnV3JxgacA000G5G2Sl8Y647I3cya6UcACvDfrzS13b0XKTxfPwt6VDIOwf+215/1+1FL/ETgVPuINMlkHdWWoxKQvXmPG6AncSW4L6C1yhCPKU39dWb+eK9gTEB8hIuFMBX46iEqlWoBwuKkaCKgxV4T86Z6t/B/Kc35mglnXlaW+uOxvlZDQnqhZ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prodrive-technologies.com; dmarc=pass action=none
 header.from=prodrive-technologies.com; dkim=pass
 header.d=prodrive-technologies.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=prodrive-technologies.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FHbDsqPKtt3CmtW4bQBSAerL6A+X466WDLXEIhGkI18=;
 b=H2d85dQAD0M1kxdxTnN9K/y2htqTSizuzSNqCd7hfSJckxZSDOJeh0cAFMimUqJOvrKkp5TJBg6hVcqfm6Sxfl0DAv5UIjQkEanY58JyvnKj41SOQDh55/dwj48MvrqTFP5atE6iCjlEEVqxM6tmzlYaSvS7KCa7bNoG0zp++eE=
Received: from AM0PR02MB5524.eurprd02.prod.outlook.com (2603:10a6:208:15a::12)
 by AS4PR02MB8056.eurprd02.prod.outlook.com (2603:10a6:20b:4e4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 19:58:24 +0000
Received: from AM0PR02MB5524.eurprd02.prod.outlook.com
 ([fe80::b0de:8e68:fc8:480e]) by AM0PR02MB5524.eurprd02.prod.outlook.com
 ([fe80::b0de:8e68:fc8:480e%5]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 19:58:24 +0000
From:   Paul Geurts <paul.geurts@prodrive-technologies.com>
To:     =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jonas.gorski@gmail.com" <jonas.gorski@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/2] net: dsa: b53: mdio: add support for BCM53134
Thread-Topic: [PATCH 0/2] net: dsa: b53: mdio: add support for BCM53134
Thread-Index: AQHZXYGJgbn0KrBHmky8B++N4lZb6q8Ix4fg
Date:   Thu, 23 Mar 2023 19:58:24 +0000
Message-ID: <AM0PR02MB552462D79D12B21CAC00A465BD879@AM0PR02MB5524.eurprd02.prod.outlook.com>
References: <20230323121804.2249605-1-noltari@gmail.com>
In-Reply-To: <20230323121804.2249605-1-noltari@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=prodrive-technologies.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR02MB5524:EE_|AS4PR02MB8056:EE_
x-ms-office365-filtering-correlation-id: db9b6b9e-3125-4d1b-c4bc-08db2bd8f649
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d3A7DY8O2UHC+smbx6NuOj7fEx+PXISM8CN7SYyDcPsYVl3qUaq+7rlULhEQ8RsxxttzSAQbmIZ++qsBY9kpowQQd03XZYIbAtUaYpe6eisa1wyzqEMgWUtuvDQ3zR2RI+cU97c1nY1hTCEioc/MJXWsJ7WPRhLy7WZOe1ZcCle0znJ2KVtQIg8du05hsu/DVMwpFMjyY8CrPwlSRuSBk2PSUx7ncApjSRahr0+clzgag4w8Yl8i68Osu3WodWSojM91ij1387aN8w2a8ZR0RJl/4MMLc94dqR9ftWpP6SNDJNO7YaGrB96xTnaaEaFia6tN6aZaTq5FgmR5he3FW9ik7Lp3lX3jIqzvf855YT+JpgPziwcS07MSXCMT305889BYUyvp84cYRyC5O6AVvFeMd0vyX3wcW30OdhT1qK6JBtPdvB3QcvYNn25Op3e720BGm6KNFsj/+o2awl0sV/Z4DDAZrkQz3wQdAzwVFCmSm4SZbFm0FzDG0JybdE5kNfdY4k2cS35H9OaAhFAxbjJhI+0UM6ibLg44RhTn67BfNPTnze/tOP5yPuZaRvJS7MHOc5/1utC+JfOMcKWyqYiNhNDrt9UTuYQYoq/9mizgf4Mh2QBM4UXn8RZnX5Xs0Q8wiUo+aZKVUEB4KnaYS4hMdGgcWTr13fy01lHeyeRjQLxtrvrY99HFyVlDijiQ3WDDfmwPoSa1JD4P3j8K24IB2Ne1JU11c423zkR0S8Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB5524.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39850400004)(376002)(396003)(366004)(136003)(451199018)(478600001)(66476007)(64756008)(66556008)(66446008)(76116006)(8676002)(66946007)(52536014)(110136005)(7416002)(122000001)(41300700001)(5660300002)(44832011)(8936002)(26005)(53546011)(6506007)(9686003)(316002)(186003)(83380400001)(7696005)(71200400001)(66574015)(33656002)(86362001)(921005)(38100700002)(38070700005)(55016003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVdvejluVGJNekNCYXltYytZNUR4b3pMNS81K3V5SjdUMGlIVlVsRzArRnND?=
 =?utf-8?B?RkdGNGc5STVHVDMxTWVJaW1KU3Y2Vi9DTkQwb2FwTm5JNFliWS9EVWdSd0ZI?=
 =?utf-8?B?dHRFUElsQ2RNNUQ2YlZMMjY5amtOanRXRGlmUXlKcVZuZnpkTVRYYUJIVDh0?=
 =?utf-8?B?NmFQallYWGd3MW13c0pJcmUxRWxjUE5MdXhYYWFUTUNPZU9maGVUVHRXdHhO?=
 =?utf-8?B?VVFnNnBZRHlFV3NKTzA5UGsyU2xZRjZSUjJHNGdhMlRHS3lvMmU0SUpwMXBU?=
 =?utf-8?B?SURiOXF5OTNNYStFUmR0dFVIRFJxNGJLbHVJZEVKUGVFUzRyQmY2WktUdmFi?=
 =?utf-8?B?SHpFanBvSVdrK3ZkTGtUMmlqSlppNWxwcTY3TmhPVUVuODV0cTlzbXNBeUl2?=
 =?utf-8?B?WC9XUTdhUHhOeWkyamFMVGNwNElvcUIyWGI2VnJ1c1pLQ1pLYW1MWnpHWmhH?=
 =?utf-8?B?cWoyR21aYStITVZxM2t2SFJLTkJwZUFDZjV5RGdNS1A1SGlzRlowc05icGJl?=
 =?utf-8?B?QTJyY3gyRFQ4dmNkam1pTmtjQWxPMzVLRG0xbDl6bGorTndhTnc3ekxxM3NS?=
 =?utf-8?B?UTE0T1VOT0hTRnIveS9MVmRsdnNyL255a2paMUV6dDV3SkhQREZneUw0SVJS?=
 =?utf-8?B?RjVZOUd6ckhERW5CYXozZXYzQ3J4eU4wb2VOQXRIOEl6SUxOMFVhZ2JocG1C?=
 =?utf-8?B?L1FTV0h0VlpBWXN6V1pqeVBUVElNMkwyeFhsTjdRbzgrVUtLb0hHL2h6bmxC?=
 =?utf-8?B?dDJ3OWRDcXBpTDY3NEZ1S1JxSDMzcDFQa1A1Z0V6MjFtR29tUGljK0hmcXNw?=
 =?utf-8?B?RkhFWnpPWWZvQkgzUHVKbnVZblFCRlRuNGVZYS9CYUFVby9FZmF2NGxERjdE?=
 =?utf-8?B?b2NkNzdRb0MyRWNVcVRHNU9FdE1ZWGxqZ1dyeDZuT1NZTW9xb2Z6Q3FMdWRq?=
 =?utf-8?B?Y3ZETUx6RlZoSzIxQk9wMVVTUUorUWpPZE05ZmQvNjZMQW9FWWFjUzhPSUh0?=
 =?utf-8?B?SVVxSE9kSW1SY0pLSmFLVUpPUE5sMEhFaFQyTTR2ZWkwK2RpWnhFREtDOTls?=
 =?utf-8?B?OXdyZ25CZCsrb1Fyek1jVURwTFZPVE1Dd1JYNUJSNFR5aVZXSDBEc3psbnZq?=
 =?utf-8?B?enU1TEpxNUlMZUpjYzdJdGVFQVdGdmdVc0FvRHhtdHVlVlZ1T1FoY210R1dz?=
 =?utf-8?B?UFd3R0VVSzZWWFo1dGcvY1I3K1Ayd0wzM0Fac1dBaHdJeml5K3pLVmdCb0VZ?=
 =?utf-8?B?RVAzb2FLTG8xcXBjTW42dkZVN1Q0aG5WT1ppc2dHd3VTZEhld3AvQzhqenFp?=
 =?utf-8?B?b2x0MnVUZFNkMGhkMDl1WVVWVWZJdVF5VUlxN3ZLU2w0akY1SVNET2g3Tjcr?=
 =?utf-8?B?ZVdJS0VnT3BYZmxoWWFFTkJ0WjRSVGJyOEY4NlRuSFBnODR2Y0x1SjM3VFd3?=
 =?utf-8?B?NzQ0eXQyYjZwekZBajBYcWpvZnZONHJ2SUVad1VwNjRYTlhVS2pMRG1tc2Q5?=
 =?utf-8?B?a0g0dkowZEpkNzUrSENUcEV4aWFPUjJoYVpSZkNBTSsrOUp5WUVVbkZ0L1c0?=
 =?utf-8?B?ZmdEWlFXa1owc0wwRmh4SDNyRmRDVmlPRU9HRkRjSkkrME8xeUNQMllNMmU0?=
 =?utf-8?B?bXVTOE54c2xTTi90THVkYjYvUkt6YStWRjZkRE1JcWVKYnFRaGFoWWswUm1Y?=
 =?utf-8?B?cE9WQ3BRaDM5SFVzbEVjR2dsbFIreXJsRmF2a2l2U1YyN0dPbk5ncVFqRDVE?=
 =?utf-8?B?NUlwWnFKdFVIQTdUdTJUYjBBMXhISENJa3o3QTI2SXNPL1RXMXZBQjNvVURG?=
 =?utf-8?B?dlVYU0xMekFXUm9BVlB0aDZMTnFVYWNZZ3gyMmhJc29jZzJITlN5bTROTlR3?=
 =?utf-8?B?b05QUkhqQWFEZzFOY3RQQkdmaTVLaHBMeWZXU3hGMkVXNkFxLzg2S3hJWnV4?=
 =?utf-8?B?TjdFS0Y2b1lkOW05V0hXb3FiNHFnT0dmWmoxVmtzbTA0c3lWMk9JQ2Q2WVlr?=
 =?utf-8?B?R1pzY3VicGRLV3JidGtOWEtMcUQ1QTY2QkJWUDBiTTM2UXJyRTJyM2kzNG9t?=
 =?utf-8?B?bElkVm1sdm0yT0RsZnRBbDRhWkkyZWJEc3dMTE4vdFRxeG9CbFVOY013YVF6?=
 =?utf-8?B?MkZucEhmOGcxK0NqNUVUMGZJUnQwTWJpa0JCUHUvdVBtRG5odS85OXk0V2Zl?=
 =?utf-8?Q?3gOavJUSPE2thO8+oW1Yp58=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prodrive-technologies.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB5524.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db9b6b9e-3125-4d1b-c4bc-08db2bd8f649
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 19:58:24.7704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 612607c9-5af7-4e7f-8976-faf1ae77be60
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QaNxcMcSynTc8D2qNAbM+gBg2cMycgiEfC1TYM5Bkf8JatczKxJ4h6SvA50to4tBQxdW2Au9DylulTFSgUEBn22SNKjt/zI1sZYBYlDwogKYZ6aB1P6nHRJVmYOdGNWm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR02MB8056
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiDDgWx2YXJvIEZlcm7DoW5kZXog
Um9qYXMgPG5vbHRhcmlAZ21haWwuY29tPg0KPiBTZW50OiBkb25kZXJkYWcgMjMgbWFhcnQgMjAy
MyAxMzoxOA0KPiBUbzogUGF1bCBHZXVydHMgPHBhdWwuZ2V1cnRzQHByb2RyaXZlLXRlY2hub2xv
Z2llcy5jb20+Ow0KPiBmLmZhaW5lbGxpQGdtYWlsLmNvbTsgam9uYXMuZ29yc2tpQGdtYWlsLmNv
bTsgYW5kcmV3QGx1bm4uY2g7DQo+IG9sdGVhbnZAZ21haWwuY29tOyBkYXZlbUBkYXZlbWxvZnQu
bmV0OyBlZHVtYXpldEBnb29nbGUuY29tOw0KPiBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRo
YXQuY29tOyByb2JoK2R0QGtlcm5lbC5vcmc7DQo+IGtyenlzenRvZi5rb3psb3dza2krZHRAbGlu
YXJvLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gZGV2aWNldHJlZUB2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IMOBbHZhcm8gRmVybsOh
bmRleiBSb2phcyA8bm9sdGFyaUBnbWFpbC5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCAwLzJdIG5l
dDogZHNhOiBiNTM6IG1kaW86IGFkZCBzdXBwb3J0IGZvciBCQ001MzEzNA0KPiANCj4gVGhpcyBp
cyBiYXNlZCBvbiB0aGUgaW5pdGlhbCB3b3JrIGZyb20gUGF1bCBHZXVydHMgdGhhdCB3YXMgc2Vu
dCB0byB0aGUNCj4gaW5jb3JyZWN0IGxpbnV4IGRldmVsb3BtZW50IGxpc3RzIGFuZCByZWNpcGll
bnRzLg0KPiBJJ3ZlIG1vZGlmaWVkIGl0IGJ5IHJlbW92aW5nIEJDTTUzMTM0X0RFVklDRV9JRCBm
cm9tIGlzNTMxeDUoKSBhbmQNCj4gdGhlcmVmb3JlIGFkZGluZyBpczUzMTM0KCkgd2hlcmUgbmVl
ZGVkLg0KPiBJIGFsc28gYWRkZWQgYSBzZXBhcmF0ZSBSR01JSSBoYW5kbGluZyBibG9jayBmb3Ig
aXM1MzEzNCgpIHNpbmNlIGFjY29yZGluZyB0bw0KPiBQYXVsLCBCQ001MzEzNCBkb2Vzbid0IHN1
cHBvcnQgUkdNSUlfQ1RSTF9USU1JTkdfU0VMIGFzIG9wcG9zZWQgdG8NCj4gaXM1MzF4NSgpLg0K
PiANCj4gUGF1bCBHZXVydHMgKDEpOg0KPiAgIG5ldDogZHNhOiBiNTM6IG1kaW86IGFkZCBzdXBw
b3J0IGZvciBCQ001MzEzNA0KPiANCj4gw4FsdmFybyBGZXJuw6FuZGV6IFJvamFzICgxKToNCj4g
ICBkdC1iaW5kaW5nczogbmV0OiBkc2E6IGI1MzogYWRkIEJDTTUzMTM0IHN1cHBvcnQNCj4gDQo+
ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNhL2JyY20sYjUzLnlhbWwgfCAgMSArDQo+
ICBkcml2ZXJzL25ldC9kc2EvYjUzL2I1M19jb21tb24uYyAgICAgICAgICAgICAgfCA1MyArKysr
KysrKysrKysrKysrKystDQo+ICBkcml2ZXJzL25ldC9kc2EvYjUzL2I1M19tZGlvLmMgICAgICAg
ICAgICAgICAgfCAgNSArLQ0KPiAgZHJpdmVycy9uZXQvZHNhL2I1My9iNTNfcHJpdi5oICAgICAg
ICAgICAgICAgIHwgIDkgKysrLQ0KPiAgNCBmaWxlcyBjaGFuZ2VkLCA2NSBpbnNlcnRpb25zKCsp
LCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gLS0NCj4gMi4zMC4yDQoNClRoYW5rIHlvdSBmb3IgcmVz
ZW5kaW5nIG15IHBhdGNoZXMhIEkgZGlkbid0IGdldCB0byBpdCB5ZXQuIEFueSBwYXJ0aWN1bGFy
IHJlYXNvbiB5b3UgZGlkbid0IGluY2x1ZGUgdGhlIG9wdGlvbmFsIEdQSU8gcGF0Y2ggSSBoYWQg
aW4gbXkgc2V0Pw0KLS0tDQpQYXVsDQo=
