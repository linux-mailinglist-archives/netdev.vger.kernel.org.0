Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E338254007C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 15:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244999AbiFGNzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 09:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235352AbiFGNy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 09:54:58 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60097.outbound.protection.outlook.com [40.107.6.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEA924F2C;
        Tue,  7 Jun 2022 06:54:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQqrCW9Ed2w5sPg1SWCHt3qVQK7jRDtvkhqp1HJ6UaGlKAcApE52MmIHjUYqykXmW1ddtXz5y7H0HzpzwTWSQ5WOiwnlsKyyzPZefKmpP5kcY493WXP/xkarfZczLlDh9g0UG0T1knuYHydiAtwBM/rtl5Mz9BjLOfmJRVEtoOEDh+JxTG1LtwhL5m/bSu1X2QoZFNyDm1SOi1wKXUws3KbvO34bj2LF7NnWbUgJKK+AdXfQ/jr8HZPkNT50DdIeXnlxrOhUgZqtnvPpDawhjo7Twa0gQ76dJhoGfCuTFY1oyBul5L64SbhW2MJZwkBMftxj3J1TcJJ19zL/Y3VY2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFtGXVZaI0EXbA/W0Fvo7AvlooI9L5tA2v212ufiB/w=;
 b=F27Yh0VW2oaOC0hwMoDbQQ/KJx+Pz/2QHdyp18GImyOsb2JyvCiM01y2BtY0lrb4KVAyzGJATqKxrwsy8PbP/frWa1SJqHO6Dd+JFhHcn4QUTUc+DlHhVAyrY7f9CR0tlqDSmQov/8x5bIiieKIJQnWuODoSMI7yccQAc3PVkRqKwLLKCMJCJ7R82vjt+SPGRZKPyWqQvYqOV9hz//cP6GD1tXj2/1J/ihsQT3z0Oi9HhXuxl1ewzzZ5mMCRphFtX860GgC6fC8msReOiekIwDM2YyHMIdACB3zW9D1IBYgHoj0rwliklHVZeSLEu5/N5yqioQ1MeS4TZmE1w+jHRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFtGXVZaI0EXbA/W0Fvo7AvlooI9L5tA2v212ufiB/w=;
 b=evMASUYWP2h63zQyNHdDQHfuDEOXnr6hPWTl+J6zgmlG/PbT9OOJyahHqAFN2huqLz2qmY7pLT3E4HEijBQz1kCRg+s2EChy37J17whZM2SkSZbp+fRMZw3x/Sc3OCJCF3EBiACORYiaKG952F2e8oiooScm3mxrdbcTmb/ynp0=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by HE1PR03MB2924.eurprd03.prod.outlook.com (2603:10a6:7:5f::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 13:54:52 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111%7]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 13:54:52 +0000
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
Subject: Re: [PATCH net-next 2/5] net: dsa: realtek: rtl8365mb: remove
 port_mask private data member
Thread-Topic: [PATCH net-next 2/5] net: dsa: realtek: rtl8365mb: remove
 port_mask private data member
Thread-Index: AQHYeavMnvw4Bbfs1E+PrISCl8og3K1D81MAgAAFpwA=
Date:   Tue, 7 Jun 2022 13:54:52 +0000
Message-ID: <20220607135452.g7io3cfqcmv5etbu@bang-olufsen.dk>
References: <20220606134553.2919693-1-alvin@pqrs.dk>
 <20220606134553.2919693-3-alvin@pqrs.dk>
 <CAJq09z6TDWSFZCFHTSevao4-fsiVavUYtmBFVttMhYqsOobg9g@mail.gmail.com>
In-Reply-To: <CAJq09z6TDWSFZCFHTSevao4-fsiVavUYtmBFVttMhYqsOobg9g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2720f470-ccae-4ca0-d7e4-08da488d4bc6
x-ms-traffictypediagnostic: HE1PR03MB2924:EE_
x-microsoft-antispam-prvs: <HE1PR03MB292444FA1872F0E1C39F3BDA83A59@HE1PR03MB2924.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RVZKToviJLsxkLjVvwvwLvzT2vIvM8IHyeUa4g2TovQNqFiiK/L9KwZOJ0XHBpdf5xNZWlJ0hXu+gDgb0VNyUhvRN6u6cjhBdAbZP1JKUZ6z81+rI5hdyKgDZdNBm3cTKVUkKCpfYSBgalwJCsJlTfA0nlzP7Y7gE/ImilKtggTOly5Yp24pg2JPNNIboGNu7nfy56k8Hh44FVMQFOV8LxN3e/7FwilRbPs+2zmI3trRp67IlCy+iXbIcemA/2lGkAvbQZvZJdjma2blTHNRjECDeGIQSaqSMMcJ/S+PKvE3grY4uzzOmsh0h5hZeDUt1XiNqZ81QT8+YIJCa4SRngV61y66B52CpqKVXZOLp6QOiXKSifNOXI5KzHE6qzMqqpX30VAj3m9I3Qo6aq3AY3ASuYOYcrzN4CKUXG9Nw8YRhUy4ta70Aq1oiUncXOlfZXrm3hsWZVi9aBIV7FIYtJwrC1QXUpy+iy/ly4KBdGJiHmLGkePYW8J6sQKdh32YrYWJ99rzCXVXu0GZaYlDph3DaaIE7hgUNJCZC7Uq8V7ZsXzSyWx2lNdacKU/+N9pWCPUtWz8XWtd+yLGK1YvotzCxFUyYWtZiCUE7CKROBQBnOQrqeVWXXaDFcM30nHvvcpdiCSjC6szRChNk5uRi6HFTx5nOA08uQMKoXdlApJoeb0OGL6QzmRZ5eiE6jU8C4FYPzVyPnSQCyc7y4XR8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(76116006)(8976002)(4744005)(66446008)(64756008)(66556008)(5660300002)(4326008)(36756003)(66946007)(8676002)(122000001)(71200400001)(26005)(54906003)(6916009)(508600001)(38100700002)(8936002)(6486002)(316002)(85182001)(6512007)(7416002)(85202003)(91956017)(186003)(38070700005)(2906002)(1076003)(6506007)(2616005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDJHOUdVdGdMMG5veWVJSyt6Yzgxam9tbUJhUkZFOEpPMDdnUnZPR2VxaE5T?=
 =?utf-8?B?eGRaVDd1dm1za1UzY3V1aHZhTzBXeEY0aXVCL0ZQejZLUWNwa29jYWc3RmxI?=
 =?utf-8?B?QU9NRnBhVUdPaGRCZytQLzRQS2krZlIxZmxpOG9Uc253UFdTZWVUTkhKbUxF?=
 =?utf-8?B?aDhEZjZPWk1vRmsvN0VabXJkTFpsTWV3czloeGVUMnFMZmM3cEJmN3FwcThw?=
 =?utf-8?B?N1JnbWJCbEMycHIzZ2c0RTk5TEdkVFJEUU9aeWY2MjdwNGltdDFUS2FHd3NU?=
 =?utf-8?B?WnlxZXM5L0kzOTBPcFQ1SkZsSS9sSzRtQzg5VUEzWlRhNzRLWGVnMnA3T3Zr?=
 =?utf-8?B?YmRBWmRXR3ZkSjNzMys5aVlDeGdHeUladTJEU2ttT3dEbGthc2JkQWVyYkFY?=
 =?utf-8?B?WUlFUld0ZDhRekw2MzVtRGZLV3BFSXNqVzJ3WURGV0FXajI3Y3FWZlpMVkd5?=
 =?utf-8?B?ajU2RWZ6Z2lLdVlLTjFiUmxvbGNFZmdJYmNBYXovVEZnd0tLb01nU1dsRnlI?=
 =?utf-8?B?RlpxbVNsV296ZzZCR01BVG05YnNVTlg5Z25wZU5ha0U0ZUhrVldrSE1OOW1k?=
 =?utf-8?B?Mno0UmZPaEZtMlFuTWhCSmZpMk1Hc21PV056SEtUbnZUU1gvcEp5SGtDUVdP?=
 =?utf-8?B?d1NsRmFxaGNia2JmbkhjN0svVkZCdXh3MDdVaTZFKzRFVGN1ZFdXZi9lbnhM?=
 =?utf-8?B?ZzVra3dVTHZXc0krcnZaWGx3eUJIVmE0OUh3ZEdtYkhzVDN6a0hqdjZaNVc0?=
 =?utf-8?B?eFdmQ0NYU3J4UkxtTG9QY2ZDUFo3cld2NnRvZmtIT2x2aUJMK0xLQy9qQmgz?=
 =?utf-8?B?WmNlZHZwcmpUWWd2Ymk4YnVZQ0tUdGRtR1Y3R1pLNlZ6eEk3cFRqRzdyOVNa?=
 =?utf-8?B?MzhDaVgvbmJ3Q3NRUWl0SFh1MVhhb1ZEdm5JckpUaTR3dnNqZEtQVnlJc3N6?=
 =?utf-8?B?NXFHZGhWUHNZcTRmWVM0RG9MaTJPdTBrVWlManRIaHp0Y2pYSWtuSldmMEUv?=
 =?utf-8?B?YUxVTi8zVUhrb2N3OURkMDh1MkZ4ZnovRWtodHMyczNmbitxaGVYcC96UUU4?=
 =?utf-8?B?TFBmblczUTViQTFaQWFScS9rRHhSTGhpV3Q0MUp3c21WOFdoc0hJTytYRTR3?=
 =?utf-8?B?UEZCbWVUK0ExUTBQRVc5SDZsbmpncVNXejBRNnoyRGIyQWR4LzU4TTVMUVFk?=
 =?utf-8?B?N00wVi9PemdieDNlMzFHcWtmVnR6TEJsTUhqVFV2b1o2dW9BR0tFODNKcDU0?=
 =?utf-8?B?VWVydit2QkgyNXFxdy8zemo4Qnh2bGsyNlBoTFJpUUFqKzdDN3VxQVo1MHNS?=
 =?utf-8?B?aVU4NDVVOXhqMTBsTkwrcXpmRnkzR3FNY2ROUXM2aFFGRmVGdFp3TXlZY2oy?=
 =?utf-8?B?d0xyckgwSVlmUVdiV1dRZzJMOWpVNit2N3NEd0lSd3EzOTduTERYbVcyODQv?=
 =?utf-8?B?MEhNSkF4TUdZVFRlM215RmlKZXg5bFJ2akNzQm92U3h4N2FSTmR4bllaS1JX?=
 =?utf-8?B?R0hUQjkwSnhRREdIc0F4VFBnNWlFRlo2MVFEVTc2a1NYOEd1UGVOVHNJbzR6?=
 =?utf-8?B?Yklad2VBTFVmSC9qbm5oY3pXa25hVzZXUUZkUXJlWnVYQlpEbUJyNmdWYnM4?=
 =?utf-8?B?aDdaRThJVFlMSWtTeVpuLzdyWll1MXNySFFjbTlRQVdKOTdMNVJKZ3NmdFVr?=
 =?utf-8?B?czVtbnVER01CRDFZNjN1MEw4YnVQWGduOWsvODF5R00xUmFJRUF5R3IwRHlZ?=
 =?utf-8?B?V3lKZmdZUUNyZnUzS1FtQlQ5aU4yYnEwQmxHMTd1RmVPTlI3dTQ0bkNyMDIx?=
 =?utf-8?B?cmplMWRTTWVkRnRzSHpDUFVua3dXeVNtTGtzeVpmbnV0ZnQwS01WTXgxOTcv?=
 =?utf-8?B?YjUzaHJGN1RML1dmdW9UZHNEcGFneHl0RWdLVytuWVhSeWJMNjBxalozdDIw?=
 =?utf-8?B?WkRJSDZjWUpqRnlQL215SUNYSHlBalUyWjEvSEVHcXpQekNZWFhrWDc4b0tl?=
 =?utf-8?B?VEhsMkhtYWwvQloyRS9aTjNCSC9TMlBZMzBzci9md255by90WFk4YzA0emth?=
 =?utf-8?B?azl2aDZyUytYVHlXU3AyVU1TM28xakppWXErU05tb2NyVUZHRDhwYi9qbmlx?=
 =?utf-8?B?QUJONGJHL1NlVU5NUUdFb1p3amgwcFBVbmM1bGJ3U0o2dmZQZnFjRzZZM0VE?=
 =?utf-8?B?SUd3TDBRQk5oQjBBSzYrdDFORlE1aTZJYk0xMHpJY1RLSFNqb2svRmZhOVBH?=
 =?utf-8?B?dXJ6NHQwdnYwWkRYSmFKbUwyK0V5OEVNUmNSVmtWSTUwaEtRZitqRlFpcUUv?=
 =?utf-8?B?THFrTDNDVU9GYVlTREhseW04TzZVd255RkdicE1PZktBQlRUYWx2blRZdExM?=
 =?utf-8?Q?dZuuhc7lERqZBhNg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F3886D2FE6C2D419968B6DCA61075E6@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2720f470-ccae-4ca0-d7e4-08da488d4bc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2022 13:54:52.4632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zgPs2T8svHo5DXFWtQY+oT1RoJutopY4dfFCmdLnx0U0K8QwGIGm1qNM8N1/Fps8rAcxU4wa+GYyhqb0BT4ilw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR03MB2924
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBKdW4gMDcsIDIwMjIgYXQgMTA6MzQ6MzhBTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gPiBUaGVyZSBpcyBubyByZWFsIG5lZWQgZm9yIHRoaXMgdmFy
aWFibGU6IHRoZSBsaW5lIGNoYW5nZSBpbnRlcnJ1cHQgbWFzaw0KPiA+IGlzIHN1ZmZpY2llbnRs
eSBtYXNrZWQgb3V0IHdoZW4gZ2V0dGluZyBsaW5rdXBfaW5kIGFuZCBsaW5rZG93bl9pbmQgaW4N
Cj4gPiB0aGUgaW50ZXJydXB0IGhhbmRsZXIuDQo+IA0KPiBZZXMsIGl0IHdhcyBjdXJyZW50bHkg
dXNlbGVzcyBhcyB3ZWxsIGFzIHByaXYtPm51bV9wb3J0cyAoaXQgaXMgYSBjb25zdGFudCkuDQo+
IA0KPiBJIHdvbmRlciBpZiB3ZSBzaG91bGQgcmVhbGx5IGNyZWF0ZSBpcnEgdGhyZWFkcyBmb3Ig
dW51c2VkIHBvcnRzDQo+ICghZHNhX2lzX3VudXNlZF9wb3J0KCkpLiBTb21lIG1vZGVscyBoYXZl
IG9ubHkgMisxIHBvcnRzIGFuZCB3ZSBhcmUNCj4gYWx3YXlzIGRlYWxpbmcgd2l0aCAxMC8xMSBw
b3J0cy4NCj4gSWYgZHNhX2lzX3VudXNlZF9wb3J0KCkgaXMgdG9vIGNvc3RseSB0byBiZSB1c2Vk
IGV2ZXJ5d2hlcmUsIHdlIGNvdWxkDQo+IGtlZXAgcG9ydF9tYXNrIGFuZCBpdGVyYXRlIG92ZXIg
aXQgKGZvcl9lYWNoX3NldF9iaXQpIGluc3RlYWQgb2YgZnJvbQ0KPiAwIHRpbCBwcml2LT5udW1f
cG9ydHMtMS4NCg0KU2VlbXMgbGlrZSBwcmVtYXR1cmUgb3B0aW1pemF0aW9uLCBJIHByZWZlciB0
byBrZWVwIGl0IHNpbXBsZS4NCg0KS2luZCByZWdhcmRzLA0KQWx2aW4=
