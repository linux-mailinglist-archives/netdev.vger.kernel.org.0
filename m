Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537F1678507
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbjAWSfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbjAWSfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:35:36 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2069.outbound.protection.outlook.com [40.107.104.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866A4FE
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:35:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeEtRAwpadyVUFZru0h8/mZRfxLQvF/im+8qyxZmqWbjRriQ//cYEWBS+35qtOWky5xx0Aqh9hkrtSW2lBg3xX9oy8OTgMiybjLYgeDyVlZLjWwQyuFl9a9f0aKAV3p/ThJjux+J0/sw2ca0dEc8ESWkznawRX2hg9tI8zmmdzEgc4dVcGtYN0ot3STWDHXDq5opBGFWX6vu49arPXEacgQMKIbLmd6mmFnWTPZIAPwt+nvXG0gfzW0RE4NyG/tq6N1j0rF4hmQhHL1x16K9sL+m5/b8P91PTJXIwczEBvwvWiVLXqTgCO811yMFRp+YhaaN0ixISVpEuBQRQs5P2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aoZyziaN0ewjpZzByYXHyt/XWss29pjCYCNjENjnKJY=;
 b=W9DSE/zxPX7kBGVvAzGH9SGHw0CPfhgzAnJzUWkB+BYw1L+wVDwMUJLUSiyZ1KyldLsE85kQd5JuMZh808T6d6UnQpaUilVeTHKk+EWp+HZeLGabkPyeDuiHcKiLOVVDJ/Xpp1jeoxeBbPmcf4JIBViHmaRjgel0sluV1IZ1YPMb7vshH9O5TcgiCWuC3iRuCof7zsVRRpojO1SfPptHYv6C9lI0t1pKw28yB2Vufgn+cnOqOeKzHSVuR1109bNoe1OsPOGaj+pUxO+cK+mso6WQPaKlf/6TGZZ9d71LeQ+YdS30f8/nO027LpAUeF9Pl+a1p+Dm9CKSFwTtIb8+fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoZyziaN0ewjpZzByYXHyt/XWss29pjCYCNjENjnKJY=;
 b=LAmhuwa8gmWUQzcp/3EIsbtgNVm3XME88z3s83td2+OIfCGDfNrN3YaOGfF5uQ/xN7BBOGXNj6PwGf9YDhkPWeq5Ixa2CRCYJVe43wkGK7mJM05qbVzmmWOZG4MvUdcWJfz60Ei+FAQogdDmCAKkqOaJ5SPdivG/2tf6xLMKuzFKekgA59zxx8PMNdjDM90Uanf4wfHaOXxDUv0AFoNE8G7+nzD2itnR8KjznpM5AZmyBivIKF+A9/TglH9jRf9YwSS/IRB6E7JBm/AbP0qNbzsgyuYqYlsJyT7BLacshg98ZIdHhWKfH/tW4+6V5Ua45I4XYzzLCPVDfPqAJ4eQbQ==
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5b6::22)
 by AM0PR10MB3602.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:15f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 18:35:32 +0000
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6180:97c1:d0ad:56a9]) by AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6180:97c1:d0ad:56a9%2]) with mapi id 15.20.6002.028; Mon, 23 Jan 2023
 18:35:32 +0000
From:   "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
To:     "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "Freihofer, Adrian" <adrian.freihofer@siemens.com>
Subject: dsa: phy started on dsa_register_switch()
Thread-Topic: dsa: phy started on dsa_register_switch()
Thread-Index: AQHZL1l5u/8UqDcWzUK0y/q7DWBrrw==
Date:   Mon, 23 Jan 2023 18:35:32 +0000
Message-ID: <f95cdab0940043167ddf69a4b21292ee63fc9054.camel@siemens.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR10MB6867:EE_|AM0PR10MB3602:EE_
x-ms-office365-filtering-correlation-id: f50281a5-2c5b-43c3-3511-08dafd709c4e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CTEMQFfieR3D9NmZ1m3oQHouYmQd938TYfesofoYIi1GGbAxWh6Wic3ga5ivxDXxRj9QPkwUhX1WcftVvXcmL9jWRi93X4aLWfwRY02Ukp02pOV4O45DX+qm1yhYAVxkQpkoPXihRgyqT4eJpmhFcLjYRxOxH8xEpHmcRxEI8tG1DjXbTXUILQWUqCDbs0kbq4F6Ruftouim/09Ru241/7ziMbTqdMgECZ/AdsiZJ5aAnQIavys+R/U1dbzuxElMbZo9clvz3uBvzceoEhUuHLjfYcqiYrElIHk75ZdMacxr4b5ttjo/uqYaFawej01YSWXvnDfjn7440W9wO2tWvQJYWz1HsIXTSTj4roFk1oN4GWttihhB4n/H8tskSdAIQmjdJV+iynu0cEajgQPCo0wMcO/zY1Lh1QhPXnEwq64moao6udoFufESAQd2SwX7qs4fVVAfOQA3pN/gOLW0f4ASxoened/DDs/bRr2+EnbMiSShaM7M/3U6JuVOvo28V/FBvVUvBlRm5dJRIfYgdlvHWa13IOkwsrwAjK3/emwQLSAYUhkXxGgfgcQFm2phrfg+5aCg2Tdo0w4pJvs6xgenARg1k+lUpcLZKUKcDa1PRVyNB0URloUHW655775Tn3yo3gFLtd0Q0iwTPD18zMXWdlv10kHBWqJfdc0MU+q+ZU6QzCSwMt2Jf7V6v7V8fMQdy4xXe55BlBzhanXTANVvwt2Sjvc7wg4YjBRSpZVtgfG8JAbxbhjP6hPs7FlM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(38100700002)(83380400001)(122000001)(15974865002)(38070700005)(82960400001)(41300700001)(86362001)(2906002)(8936002)(5660300002)(4326008)(6512007)(26005)(8676002)(55236004)(186003)(6506007)(107886003)(66476007)(66556008)(316002)(76116006)(64756008)(2616005)(66446008)(66946007)(478600001)(91956017)(110136005)(71200400001)(6486002)(36756003)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVp3bytSUzEzVEtFS0NUcWRzRmlIQXlaZmdXWWtKOXZnU2pHVU92Q0lOR1R3?=
 =?utf-8?B?bGNvdUNLMkVvMFNEam1hTm5Kd1p6ekNESG1GWk5ML0ZhaHQzSkVQd3lsOVlo?=
 =?utf-8?B?NTFlNU9PeCtPUE5WL2VTUmw0bkdtQXdYWHViR1dOa0tpTHFYenU1R1QrWDIr?=
 =?utf-8?B?Z0Y0SGhQS2dZeFc4d2JpNnNSTTdkV3NoV2lkQWxpcGRta1dMWnhwYmZJcUFs?=
 =?utf-8?B?dlIzOVJhSmVHUXdQZXMwbVgrQzE3UmdKVWZIZWF3LzR1TVhkcEhIYkw0a004?=
 =?utf-8?B?aWlEeE1sOWF5NHZxdW90YW0zYnF5WnIvNVdGWDh1clVYQ2l2Y0I1UVlRakps?=
 =?utf-8?B?S0dPdEI5TGE3bGNjY0FVNEhJcnRYWmlXY21uWFlmZlZuMWpIcFZZTDR0VlUv?=
 =?utf-8?B?eUNHUUlKZXlYenFoby9aZU84RlllMk5WOVpmK2dVUlBxcGg2YzJqcEpwTzdk?=
 =?utf-8?B?Zk80L09TMXRWNnJ3NXZ3b3VqSGhjeHJCK09QeGx3Ynp0eUdWS09DaitVdW1N?=
 =?utf-8?B?WTVxVXZ6clFxUDN6QkNFOENjcGxYVE94cVVVVnJpbDk4bWpqamNlQWh1RkN3?=
 =?utf-8?B?cTdONTRWaGxRcGxQcXBSS2NxRjhCQnZDWStoMmEyQzJncjNPTHNabTgxRmJi?=
 =?utf-8?B?a1VqWWhXMTZQbGxXWS9UZHNMaW43dGdRQ0RQOFB0YWh2dmdKRHpnWXRwTjlR?=
 =?utf-8?B?aUtrSm5QREdXSE4xbHRhZTQ4dWZXamxrMHRnaFVlbTdPZW55OG5QZlY0b2NI?=
 =?utf-8?B?aVY0WTVNdVZ2Q2ljTzhUTEgwMDVpZlhjUXRvd3BFM29Ha25wcmhRUWFBa2Rh?=
 =?utf-8?B?NGdTRmNSZXkvMGVPZ0tLQ2VMeU1FaTgzbE9tdWM2QUVISGk4d1hteDFIakhG?=
 =?utf-8?B?dHdwOTFtc2RTemJyZ0VvcjZ1WWVlVHZOS0NXbGJ2Q2Nad1Jrb3hvNkFjcWtK?=
 =?utf-8?B?eTRXTDkxdTlYRXVwejBCbGg3aVBTcG4vZURDTWMwYUwxWUZGZW5aemJhT1pG?=
 =?utf-8?B?YlB1RzFFWTR4WkpBMmNxSVVJL3BnZ0R5UXV4eksvYmtNTWw1dGY3QUE1YzZj?=
 =?utf-8?B?RFB2cnJ2MVJNK21kcFBDUWNWdG5WTTAwcHZmRTc3TEFySnJ4S0s2cXVOL2ZO?=
 =?utf-8?B?MjEvUWdYNU50NytHZWQrWXZFK0F5Y2pySlEvWU1qMHFGZGlndTY5VE43Nmo4?=
 =?utf-8?B?L3hJL05HdE1XS0RYcXVXcEorN1o0MEZIMkVnd2FodGM0YXFqcGJzM1VCeWpK?=
 =?utf-8?B?dVdIK0lvWnB6SUY0cVZjZk1OUUNXUU8rVXZpNGVYcnkvbURZRUNmN2lwUmNG?=
 =?utf-8?B?a29kY09KSmFSY2VUdG9UdkZTSTRFNEc5cE5yNlZZSm9Fa1ZRYW4ydlA5QWtR?=
 =?utf-8?B?MFVVRVE0amhwRTBaSzR6QlZiSzR3NUEvYkQ0VndNT3FhTTE3SUNKS1YwTmht?=
 =?utf-8?B?cFFjcDh2RTVYMmFwS29QbytLRHdqSW1MUGl6Mms2Yk9leFp5Nml6eXU1dXVs?=
 =?utf-8?B?dks3czhmcjBCYUFKMXRZMzY5NmVvYVpDTlFYZEZXOEdlTXlucXAxclZqQnVD?=
 =?utf-8?B?c0JXSWtrQmJSUW1GRDJzaERvR1JQL21EQ3IvNmVrQmp4U1pxbERFNUE1bzYv?=
 =?utf-8?B?eUxWSDJtQnFzanhaSnN3YVVGcTlQMXprR05rYzAza0c1L3JEUXRoQWs5ZER1?=
 =?utf-8?B?NC9PUHVVWC9CaHNGbWYzNWFIVmtjSFo5dCthNVFOMWliTW1BN2V4OFFsWWg1?=
 =?utf-8?B?SlR6RHVPQlUvTXRyRG1KendodGZUQkRDa2RxSTRyRXJ6UWpsRU5IakxaQStk?=
 =?utf-8?B?aDA1eng4RGFZR0FrOWY2S0pzeWZBVkp5aDEvK3V0NUpIY3hYQWVGejZNQWZO?=
 =?utf-8?B?N3FmNDR5Q0ttZEdzVGhBd1JFV0dtWExyK2dZS1ZJYkt2RW1iY29kQ0JudU5i?=
 =?utf-8?B?aGt2cTg0UWMyU2ZOMVZ0ZGFSTWtDeXhTQTBBcTBjUi9MVG5PRVlHOUFCdm1a?=
 =?utf-8?B?NFRNbGExSU1kK0JXbkFPTS8rVEZ6UTlkZnpkcXZYRlhGbW1DN0pmTnlJY21v?=
 =?utf-8?B?Wno5U09oVUY1NDMzOVp5VDI0eWp1N0ZBUWpGdU54MVhydjU0ampJKzZMN2xM?=
 =?utf-8?B?NFBBMnFYa3QzVHRvSDR6K0t0M3VQL1VHMXBxYWdXOUt3NjZmYTl6Tjc3ZGtY?=
 =?utf-8?Q?m3KdRSmjRfyidkJTrrCKDgk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5864E5ACD97D254C92B8C7CBEDCF5D06@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f50281a5-2c5b-43c3-3511-08dafd709c4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 18:35:32.6413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7UGjeHNr8RnhjnEFz3ns8+QN5I2V/Tc5vJct+SSvm3e1bunNyBnQPWdWnhEi8nDlEehqCxGGPc7hOul6+a0JgGX5gxOpoKPFyp5vtd8WQoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3602
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBEU0EgbWFpbnRhaW5lcnMsDQoNCkkndmUgYmVlbiBwdXp6bGVkIGJ5IHRoZSBmYWN0IHBv
cnRzIG9mIHRoZSBEU0Egc3dpdGNoZXMgYXJlIGVuYWJsZWQgb24NCmJvb3R1cCBieSBkZWZhdWx0
IChQSFlzIGNvbmZpZ3VyZWQsIExFRHMgT04sIGV0YykgaW4gY29udHJhc3QgdG8gdGhlDQpub3Jt
YWwgRXRoZXJuZXQgcG9ydHMuDQoNClNvbWUgcGVvcGxlIHRlbmQgdG8gdGhpbmsgdGhpcyBpcyBh
IHNlY3VyaXR5IGlzc3VlIHRoYXQgcG9ydCBpcyAib3BlbiINCmV2ZW4gdGhvdWdoIG5vIGNvbmZp
Z3VyYXRpb24gaGFzIGJlZW4gcGVyZm9ybWVkIG9uIHRoZSBwb3J0LCBzbyBJDQpsb29rZWQgaW50
byB0aGUgZGlmZmVyZW5jZXMgYmV0d2VlbiBFdGhlcm5ldCBkcml2ZXJzIGFuZCBEU0ENCmluZnJh
c3RydWN0dXJlLg0KDQpUcmFkaXRpb25hbGx5IHBoeWxpbmtfb2ZfcGh5X2Nvbm5lY3QoKSBhbmQg
cGh5bGlua19jb25uZWN0X3BoeSgpIGFyZQ0KYmVpbmcgY2FsbGVkIGZyb20gX29wZW4oKSBjYWxs
YmFja3Mgb2YgdGhlIEV0aGVybmV0IGRyaXZlcnMgc28NCmFzIGxvbmcgYXMgdGhlIEV0aGVybmV0
IHBvcnRzIGFyZSAhSUZGX1VQIFBIWXMgYXJlIG5vdCBydW5uaW5nLA0KTEVEcyBhcmUgT0ZGLCBl
dGMuDQoNCk5vdyB3aXRoIERTQSBwaHlsaW5rX29mX3BoeV9jb25uZWN0KCkgaXMgYmVpbmcgY2Fs
bGVkIGJ5DQpkc2Ffc2xhdmVfcGh5X3NldHVwKCkgd2hpY2ggaW4gdHVybiBpcyBiZWluZyBjYWxs
ZWQgYWxyZWFkeSBpbg0KZHNhX3NsYXZlX2NyZWF0ZSgpLCBhdCB0aGUgdGltZSBhIHN3aXRjaCBp
cyBiZWluZyBEVC1wYXJzZWQgYW5kDQpjcmVhdGVkLg0KDQpUaGlzIGNvbmZ1c2VzIHVzZXJzIGEg
Yml0IGJlY2F1c2UgbmVpdGhlciBDUFUgbm9yIHVzZXIgcG9ydHMgaGF2ZQ0KYmVlbiBzZXR1cCB5
ZXQgZnJvbSB1c2Vyc3BhY2UgdmlhIG5ldGxpbmssIHlldCB0aGUgTEVEcyBhcmUgT04uDQoNClRo
ZSB0aGluZ3MgZ2V0IHdvcnNlIHdoZW4gYSB1c2VyIHBlcmZvcm1zDQoiaXAgbGluayBzZXQgZGV2
IGxhbjEgdXA7IGlwIGxpbmsgc2V0IGRldiBsYW4xIGRvd24iLCBiZWNhdXNlIG5vdw0KdGhlIExF
RHMgZ28gT0ZGLg0KDQpJcyB0aGlzIGJlaGF2aW91ciBpbnRlbmRlZD8gU2hhbGwgSSB0cnkgdG8g
ZGV2ZWxvcCBwYXRjaGVzIG1vdmluZw0KcGh5bGlua18uKnBoeV9jb25uZWN0IHRvIGRzYV9zbGF2
ZV9vcGVuKCkgYW5kIHNvbWV0aGluZyBzaW1pbGFyDQpmb3IgQ1BVIHBvcnQ/DQoNCi0tIA0KQWxl
eGFuZGVyIFN2ZXJkbGluDQpTaWVtZW5zIEFHDQp3d3cuc2llbWVucy5jb20NCg==
