Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5ABD4BEB43
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiBUSUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:20:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiBUSSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:18:41 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150113.outbound.protection.outlook.com [40.107.15.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3697AE01E;
        Mon, 21 Feb 2022 10:10:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlQm3u7BZR1o2N1JRc+0K//f1l0yZB+m0bF0boFrMbCojUkZHeRBzCFm5iv+Y6KcXgqgYS/xhTLjdOx75dmc+L05RNvly19PQiQyBzPJXv9TMWI7FtZz5ysd2tf8wjy7NCAe+huskqFhWOPfppJmPy+U2XjFzcR3zy2Jb9C0sfeoA8XwrH+sLaAif37oUDQjIoUI3OPSogthtt0JY+QMuR8L2CGtFLjGJy1qTH7vIRUSx9cAKIqf74gdmIgpyqd2k8feE0bgYGHUYk1Ig9zi2l/UV5t9SqLRdbXHZp1nk1CvZBFPlmBu3tEfhnEz7nRJcU2rYKMAGZrdoRdoB7GJGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rLvZJQ2hc5EOVfdmFe7LNgVpnhiVkPLlkct2JXdsapw=;
 b=Oz4jqZYXls1+Qzm3td7xcgUK7bO3f0zJuIQc0GlS0FcQf2GVOeQTIXqrHolP9uV6bFxZ/UOetzrsSn7JBog5XEj8So3q7aje6+lCnaTmArVkYfo7mkwj1qT6vAn0JaTp7qDx6YHus0ASeb2C70YNqXN4DwecveBQL4nTP5BL0qeHbQMBTeR7vF//x6ljBmRaXjLtoldZvbafarqRXcFGWwl0Pju9S4ecVVvusTpvRlO9uVUlYkMtEMpuWAx2P0Y5IHEDRSI2E4h5JFsW6LE5OWob7wXG1QmE3DTxSEILiEqTWQdM5u/19VD5lJ3SGw1ZT9prtmogd/X17kpkEdzhwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rLvZJQ2hc5EOVfdmFe7LNgVpnhiVkPLlkct2JXdsapw=;
 b=bKrZZwurnYN+xMgaDugYnNFD6qb9B1ys1Btwo4WRq24XHDo3w5xxZWlrVZ3cMLeNSaHb+tDTJM+99VGsvtFou75qd+eaDpvBM3QvpjMYnRid5V0cL47wAbtqCGHUA9vdc3iwB7fPkmtg/70bE5itvCPSorE1sY7Zo5ZmqLPQNzg=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by GV1PR03MB8110.eurprd03.prod.outlook.com (2603:10a6:150:21::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 18:10:01 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 18:10:01 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: dsa: realtek: rtl8365mb: serialize
 indirect PHY register access
Thread-Topic: [PATCH net-next 2/2] net: dsa: realtek: rtl8365mb: serialize
 indirect PHY register access
Thread-Index: AQHYI07dxnVE+WkWDUK/DhqhBDRISw==
Date:   Mon, 21 Feb 2022 18:10:01 +0000
Message-ID: <87v8x8hz0m.fsf@bang-olufsen.dk>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
        <20220216160500.2341255-3-alvin@pqrs.dk>
        <20220216233906.5dh67olhgfz7ji6o@skbuf> <874k4yrlcj.fsf@bang-olufsen.dk>
        <20220217111709.x5g6alnhz3njo4t2@skbuf> <87bkz5r6zq.fsf@bang-olufsen.dk>
 <871qzwjmtv.fsf@bang-olufsen.dk>       <20220221171525.ib32ghevud4745hz@skbuf>
In-Reply-To: <20220221171525.ib32ghevud4745hz@skbuf> (Vladimir Oltean's
        message of "Mon, 21 Feb 2022 19:15:25 +0200")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7c488b5-6d78-4d05-6a7d-08d9f56560ed
x-ms-traffictypediagnostic: GV1PR03MB8110:EE_
x-microsoft-antispam-prvs: <GV1PR03MB811060FA2A86CA4459272FCF833A9@GV1PR03MB8110.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kyv8dmjp/kNlClHTuhK5KcA8YZcqAcRq+K/jYToQZiR69mYZGdQlYWcnkBPkKeBJXjpwNkaDGh2QzVdOoMxEXM/F/LB7GataStdVQvcI9FcWstzSbXhjZp/ScPomtN5zP0wJ9Qk8MZVHr5jbBf1NG9/bqfGVxT+6CsniPjgQGTwpkfhWcLWeWNrSx+BISgWz7OK2xg+HPV17LAp4hqCAC+edoOypSiIhIoWsJ/3xGtf/PZlR/RnMuMT29qFUFa8Pw0R4Vsty/d//gK8319xfwtWOF83lHeJfaPPA2Y1lzknn4B1iTbX3i8kPJUTH7e2sv7gOVbaHA+/K3PcJrInAjPBgBmvx/KaGxVpRcmRqeNpZOC19Fal8ZdvPgwP8X9IvHUjP7AqzPLJrZMkrJakd/Qi8HTni+lUMakTcPb8RZdizKQr/kZS+ErPZnj4BLYNLxX2lnhhY8mLQvXgHFf2lnqK0iIMZnjtlLwW/nGsFor/pRS2MEpwgpCXIEEqV6vbMDPHxgfGOpyymT3e4y6wrDev/FoRJM8YyFteMZHZtxJLqE/6VyiU+5d/Vvw2HCjdHyOU4a8vtvNSdydjf2yCyieKsfltA0oOQaGkU0Dkx0bNTj/kVAgy5lkuri+52gZAPYh1dHKht6zwiDp2WGnCqIcsahdaCJ4yJdbSBgFBDxTZhT8o4JqEBqBDcvKyw54/bm1EgzndTScF80noEVahkorTZVntcWR9K1igf3lojfrw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(8976002)(26005)(2906002)(8936002)(122000001)(7416002)(38100700002)(2616005)(86362001)(6512007)(186003)(5660300002)(316002)(85202003)(76116006)(66476007)(66574015)(91956017)(71200400001)(83380400001)(66446008)(54906003)(6916009)(6506007)(6486002)(36756003)(85182001)(8676002)(508600001)(4326008)(66946007)(66556008)(64756008)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFpxTFp4MjdKNTA4ZjRHaWkvMkpwRmlINkQzbFNjVlRUam4xaDdCUTJPYlRR?=
 =?utf-8?B?MUY0ZlJaTnhnTXVORVBQOWU3aTJ4R25lKzdLRmVOUXk1UEFpR05VVnV0R0F1?=
 =?utf-8?B?ZDBLZDdmL05UREVuNE8xenVmWWgvTkwrRkV4ZXk5ME1GRmlONitoWVJ4ZTJu?=
 =?utf-8?B?eXBuelVlampQT2NJNGliRTQ0Vm9UVjFXdDJRaitnWkVVVmxVemdsaDNpRlBI?=
 =?utf-8?B?ZVovNlJKV0NTN1NNbmNpSGlmMGdtNVJMZVovUWV3dnZzSEh4azh2a2pTOURx?=
 =?utf-8?B?MUM3VHNwTzUydXBnLy9oc240dkZtdkFvUXFQVFR5SDFBNEJWRURnUmMyenhy?=
 =?utf-8?B?S0JwWGlDbEVjWTZUa3RsUWRIaWR5TjJjTUZueUFJZGJWbkg5a0Erb2lGYndW?=
 =?utf-8?B?Y1RwNklRUVZJTjFZaHRpQ1ZFOG9yaEdWVlZISDRacHdmeEdkcUNiRFdrOS9n?=
 =?utf-8?B?TTBvQm5ybVZxVGMySUpRazZIYjMvZis5N243NkpRTUlIV25ERlgvSnR5VFlO?=
 =?utf-8?B?WTh5cysvbHhKVXV1Znd4UzZuUU8rNFBiS1RvVHBnQmpZcmRwRjV6UWw1RkRU?=
 =?utf-8?B?bVY1WGFxVEQ1NENRRDlmYnU4cktzb0xHSEFXREhoY2ZlcDZwd0FwRmFhaVha?=
 =?utf-8?B?ZGY3OW9uejltUFR0eUpuSXZQOUdPbVNsdGFjL094QjhIYzA4VXdjeE52ejIy?=
 =?utf-8?B?UDFORm5nZEN3RUNCbzdpcWVpNk1OenpGdlBkSTFCb3FEMnVQWi9UZ3R4L3FO?=
 =?utf-8?B?ZUk5OERGTjRaTmoxOThPcGg0QnNaVnRGNXErWnFTZXlSS0s3ZCt3S0RvVzJI?=
 =?utf-8?B?TFFaZUtqajgzY0NCUFIyMThJdjNWLzNCQWJWZ1oyL0xsR21aYktRbHZqRThh?=
 =?utf-8?B?MWxzdURFY3E3WWJHaTByM2FHd29mT2FtVmtqZHJLWTBzVEJFOFMxNlN1VGJq?=
 =?utf-8?B?MjJqSmR6R2xxd2xNUHJtbTZxd0tnMmNwZm5mcng2Qzg3ZDEwOFBlZmtwckNp?=
 =?utf-8?B?ZVNDOFcwakZjeWhsWTZUeWI3bVBhU2VmajZYQUZabjd1OXowc1U3dHZyVk4w?=
 =?utf-8?B?K2JNK0UzSXRkeXRndXlvaStLVnFHRDRSdXRMZUladHd4WlFqQVdjeFVQWXFI?=
 =?utf-8?B?TXFlaVJENC9Sa04yOG44bUZrSUlja0ppSkFFdVQ5anQwWkVJS1owN3cvUmlT?=
 =?utf-8?B?YWpWV0phd1lRSFRsZ2hnRVFpR2xZc1BQdVE0VmRCYjJrSEt6aUx1bGVlcEN2?=
 =?utf-8?B?RVNocmZiWmVTU2VBaXNpNWJXRHZ1cmZBSTFxZlRiYU5NdkdMNktjMHZkcHJw?=
 =?utf-8?B?dVdJZUlMYk5nbEJkOFVIVW5XdGpML2lxN2MzRGo2V2N5ODdhOVpQZnd1RDN5?=
 =?utf-8?B?MHVZdDB6SVlGUHhrWHVRR2s3MGovbXltODExUVNidjI2RXNiZGduVDhOMmlh?=
 =?utf-8?B?R1M2UzdVcUd3OWpsclFMUTkzZGF3VW8vTDdUUUl4L21kanpqUEJaaDUweWV5?=
 =?utf-8?B?UU4rVVNuOW9NWUNNNXZaL00vT3hSZEREdmJEWDQrSFFwWHZLcEE5Ym1zWHpt?=
 =?utf-8?B?UTdSNGZrSXJtSjVaOURZanJyZjRPVHRNbTIxempOOFpHSDNJSld4VmFVWmV4?=
 =?utf-8?B?TzREWkplMWd6WkEzR0NualRraWR5QWtnYTFnUFBkcXM1ZWJIeWhDNmJwL2VD?=
 =?utf-8?B?TWlTYmMzcWZsUVYya1BscW04YkJaUmZtV2t4M2p2eE9mUzJHc1g0SUNxOTFX?=
 =?utf-8?B?OTRYT0ZsclYzNGZsRkJKVUk1SGgwRmxKRUdkNXJ5V1J2ZzFYMmlDcnAzNW5G?=
 =?utf-8?B?SWkyTjVISWp4Zk5XOFcyWWpaYTNvcmF5MEhOakovTmhndzZhYi9aTE5mV3FK?=
 =?utf-8?B?MGl0RVhaeUNXQ3JNN0srUmxaaUNsRmRJbEpFWDZnZ2d3MEhTT3QzczFNaUIr?=
 =?utf-8?B?Rk5XV1RVSld5aGliUkVRYjh4OEpGMFFCYWNVS0F4WXRFQ0JwL3M0VTNEM25k?=
 =?utf-8?B?dHFEd013eVEydzFvaXo2emxUWGl1WGVpTFJta0hhVFdxSk0xbVJld0wzLzFZ?=
 =?utf-8?B?WHhNUjhMZnFhU2tiaWZXZmppQ2o5TTIrK2ZEZ2xTbGc4NkhXNjljNnRkSURS?=
 =?utf-8?B?QysvTVpEK2xrLytPZ01TQU9pS0tHaUk2NmMzWTJ3bjhicmFvcUg2ZmJwMzlW?=
 =?utf-8?Q?zduoqiUAD5oxMIoHsB56nNM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F12AD1A15D5A4478EEEAA618C4CE651@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c488b5-6d78-4d05-6a7d-08d9f56560ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 18:10:01.5216
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e7mI5P1umADiRXJ7u5pwsXyNBc88Qi60b6AoElKgTyRWD2dtSjpFoaCOlSymbTuEAjp+YbysA5mhd6ux57gtSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB8110
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VmxhZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4gd3JpdGVzOg0KDQo+IEhpIEFsdmlu
LA0KPg0KPiBPbiBNb24sIEZlYiAyMSwgMjAyMiBhdCAwMjo1MDoyNFBNICswMDAwLCBBbHZpbiDF
oGlwcmFnYSB3cm90ZToNCj4+IFNvIEkgbWFkZSBhIHRlc3QgbW9kdWxlIHdoaWNoLCBpbiBzdW1t
YXJ5LCBjaGVja3MgdGhlIGZvbGxvd2luZzoNCj4+IA0KPj4gMS4gZm9yIFBIWSByZWFkcywgYXQg
d2hhdCBwb2ludCBkb2VzIGluc2VydGluZyBhIHN0cmF5IHJlZ2lzdGVyIGFjY2Vzcw0KPj4gICAg
KGVpdGhlciByZWFkIG9yIHdyaXRlKSBjYXVzZSB0aGUgUEhZIHJlYWQgdG8gZmFpbD8NCj4+IDIu
IGZvciBQSFkgd3JpdGVzLCBjYW4gc3RyYXkgcmVnaXN0ZXIgYWNjZXNzIGFsc28gY2F1c2UgZmFp
bHVyZT8NCj4+IDIuIGZvciBNSUIgcmVhZHMsIGNhbiBzdHJheSByZWdpc3RlciBhY2Nlc3MgYWxz
byBjYXVzZSBmYWlsdXJlPw0KPj4gDQo+PiBGb3IgKDEpIEkgaW5zdHJ1bWVudGVkIHRoZSBQSFkg
aW5kaXJlY3QgYWNjZXNzIGZ1bmN0aW9ucyBpbiB0aGUgNg0KPj4gcG9zc2libGUgcGxhY2VzIHdo
ZXJlIHNwdXJpb3VzIHJlZ2lzdGVyIGFjY2VzcyBjb3VsZCBvY2N1ci4gT2YgdGhvc2UgNg0KPj4g
bG9jYXRpb25zIGZvciBzcHVyaW91cyByZWdpc3RlciBhY2Nlc3MsIDQgaGF2ZSBubyBlZmZlY3Q6
IHlvdSBjYW4gcHV0IGENCj4+IHJlYWQgb3Igd3JpdGUgdG8gYW4gdW5yZWxhdGVkIHJlZ2lzdGVy
IHRoZXJlIGFuZCB0aGUgUEhZIHJlYWQgd2lsbA0KPj4gYWx3YXlzIHN1Y2NlZWQuIEkgdGVzdGVk
IHRoaXMgd2l0aCBzcHVyaW91cyBhY2Nlc3MgdG8gbmVhcmx5IGV2ZXJ5DQo+PiBhdmFpbGFibGUg
cmVnaXN0ZXIgb24gdGhlIHN3aXRjaC4NCj4+IA0KPj4gSG93ZXZlciwgZm9yIHR3byBsb2NhdGlv
bnMgb2Ygc3B1cmlvdXMgcmVnaXN0ZXIgYWNjZXNzLCB0aGUgUEhZIHJlYWQNCj4+IF9hbHdheXNf
IGZhaWxzLiBUaGUgbG9jYXRpb25zIGFyZSBtYXJrZWQgLyogWFhYICovIGJlbG93Og0KPj4gDQo+
PiAvKiBTaW1wbGlmaWVkIGZvciBicmV2aXR5ICovDQo+PiBzdGF0aWMgaW50IHJ0bDgzNjVtYl9w
aHlfb2NwX3JlYWQoc3RydWN0IHJlYWx0ZWtfcHJpdiAqcHJpdiwgaW50IHBoeSwNCj4+IAkJCQkg
IHUzMiBvY3BfYWRkciwgdTE2ICpkYXRhKQ0KPj4gew0KPj4gCXJ0bDgzNjVtYl9waHlfcG9sbF9i
dXN5KHByaXYpOw0KPj4gDQo+PiAJcnRsODM2NW1iX3BoeV9vY3BfcHJlcGFyZShwcml2LCBwaHks
IG9jcF9hZGRyKTsNCj4+IA0KPj4gCS8qIEV4ZWN1dGUgcmVhZCBvcGVyYXRpb24gKi8NCj4+IAly
ZWdtYXBfd3JpdGUocHJpdi0+bWFwLCBSVEw4MzY1TUJfSU5ESVJFQ1RfQUNDRVNTX0NUUkxfUkVH
LCB2YWwpOw0KPj4gDQo+PiAJLyogWFhYICovDQo+PiANCj4+IAlydGw4MzY1bWJfcGh5X3BvbGxf
YnVzeShwcml2KTsNCj4+IA0KPj4gCS8qIFhYWCAqLw0KPj4gDQo+PiAJLyogR2V0IFBIWSByZWdp
c3RlciBkYXRhICovDQo+PiAJcmVnbWFwX3JlYWQocHJpdi0+bWFwLCBSVEw4MzY1TUJfSU5ESVJF
Q1RfQUNDRVNTX1JFQURfREFUQV9SRUcsDQo+PiAJCSAgICAmdmFsKTsNCj4+IA0KPj4gCSpkYXRh
ID0gdmFsICYgMHhGRkZGOw0KPj4gDQo+PiAJcmV0dXJuIDA7DQo+PiB9DQo+PiANCj4+IEluIHRo
ZSBjYXNlIG9mIGEgc3B1cmlvdXMgcmVhZCwgdGhlIHJlc3VsdCBvZiB0aGF0IHJlYWQgdGhlbiBw
b2lzb25zIHRoZQ0KPj4gb25nb2luZyBQSFkgcmVhZCwgYXMgc3VnZ2VzdGVkIGJlZm9yZS4gQWdh
aW4gSSB2ZXJpZmllZCB0aGF0IHRoaXMgaXMNCj4+IGFsd2F5cyB0aGUgY2FzZSwgZm9yIGVhY2gg
YXZhaWxhYmxlIHJlZ2lzdGVyIG9uIHRoZSBzd2l0Y2guIFNwdXJpb3VzDQo+PiB3cml0ZXMgYWxz
byBjYXVzZSBmYWlsdXJlLCBhbmQgaW4gdGhlIHNhbWUgbG9jYXRpb25zIHRvby4gSSBkaWQgbm90
DQo+PiBpbnZlc3RpZ2F0ZSB3aGV0aGVyIHRoZSB2YWx1ZSB3cml0dGVuIGlzIHRoZW4gcmVhZCBi
YWNrIGFzIHBhcnQgb2YgdGhlDQo+PiBQSFkgcmVhZC4NCj4+IA0KPj4gRm9yICgyKSBJIGRpZCBz
b21ldGhpbmcgc2ltaWxhciB0byAoMSksIGJ1dCB0aGUgZGlmZmVyZW5jZSBoZXJlIGlzIHRoYXQN
Cj4+IEkgY291bGQgbmV2ZXIgZ2V0IFBIWSB3cml0ZXMgdG8gZmFpbC4gQWRtaXR0ZWRseSBub3Qg
YWxsIGJpdHMgb2YgdGhlIFBIWQ0KPj4gcmVnaXN0ZXJzIHRlbmQgdG8gYmUgd3JpdGFibGUsIGJ1
dCBmb3IgdGhvc2UgYml0cyB0aGF0IHdlcmUgd3JpdGFibGUsIEkNCj4+IHdvdWxkIGFsd2F5cyB0
aGVuIHJlYWQgYmFjayB3aGF0IEkgaGFkIHdyaXR0ZW4uDQo+PiANCj4+IEZvciAoMykgSSBkaWQg
c29tZXRoaW5nIHNpbWlsYXIgdG8gKDEpLCBhbmQgYXMgY2xhaW1lZCBwcmV2aW91c2x5LCB0aGlz
DQo+PiBuZXZlciByZXN1bHRlZCBpbiBhIHJlYWQgZmFpbHVyZS4gSGVyZSBJIGhhZCB0byB1c2Ug
dGhlIE1JQiBjb3VudGVycyBvZg0KPj4gYSBkaXNjb25uZWN0ZWQgcG9ydCBzbyB0aGF0IEkgY291
bGQgYXNzdW1lIHRoZSB2YWx1ZXMgd2VyZSBhbHdheXMgMC4NCj4+IA0KPj4gSSBoYXZlIGF0dGFj
aGVkIHRoZSB0ZXN0IG1vZHVsZSAoYW5kIGhlYWRlciBmaWxlIGdlbmVyYXRlZCBmcm9tIGFuDQo+
PiBlbm9ybW91cyBoZWFkZXIgZmlsZSBmcm9tIHRoZSBSZWFsdGVrIGRyaXZlciBzb3VyY2VzLCBz
byB0aGF0IEkgY291bGQNCj4+IGl0ZXJhdGUgb3ZlciBldmVyeSBwb3NzaWJsZSByZWdpc3Rlciku
IEl0IGlzIHByZXR0eSBncnVlc29tZSByZWFkaW5nIGJ1dA0KPj4gZ2l2ZXMgbWUgY29uZmlkZW5j
ZSBpbiBteSBlYXJsaWVyIGNsYWltcy4gVGhlIG9ubHkgcmVmaW5lbWVudHMgdG8gdGhvc2UNCj4+
IGNsYWltcyBhcmU6DQo+PiANCj4+IC0gd2hlcmUgX2V4YWN0bHlfIGEgc3B1cmlvdXMgcmVnaXN0
ZXIgYWNjZXNzIHdpbGwgY2F1c2UgZmFpbHVyZTogc2VlIHRoZQ0KPj4gICAvKiBYWFggKi8gaW4g
dGhlIGNvZGUgc25pcHBldCB1cHN0YWlyczsNCj4+IC0gUEhZIHdyaXRlcyBzZWVtIG5vdCB0byBi
ZSBhZmZlY3RlZCBhdCBhbGwuDQo+PiANCj4+IEZpbmFsbHksIEkgcmVhY2hlZCBvdXQgdG8gUmVh
bHRlaywgYW5kIHRoZXkgY29uZmlybWVkIHByZXR0eSBtdWNoIHRoZQ0KPj4gc2FtZSBhcyBhYm92
ZS4gSG93ZXZlciwgdGhleSBjbGFpbSBpdCBpcyBub3QgYSBoYXJkd2FyZSBidWcsIGJ1dCBtZXJl
bHkNCj4+IGEgcHJvcGVydHkgb2YgdGhlIGhhcmR3YXJlIGRlc2lnbi4gSGVyZSBJIHBhcmFwaHJh
c2Ugd2hhdCB3YXMgc2FpZDoNCj4+IA0KPj4gMS4gWWVzLCBzcHVyaW91cyByZWdpc3RlciBhY2Nl
c3MgZHVyaW5nIFBIWSBpbmRpcmVjdCBhY2Nlc3Mgd2lsbCBjYXVzZQ0KPj4gdGhlIGluZGlyZWN0
IGFjY2VzcyB0byBmYWlsLiBUaGlzIGlzIGEgcmVzdWx0IG9mIHRoZSBoYXJkd2FyZSBkZXNpZ24u
IEluDQo+PiBnZW5lcmFsLCBfaWYgYSByZWFkIGZhaWxzLCB0aGUgdmFsdWUgcmVhZCBiYWNrIHdp
bGwgYmUgdGhlIHJlc3VsdCBvZiB0aGUNCj4+IGxhc3Qgc3VjY2Vzc2Z1bCByZWFkXy4gVGhpcyBj
b25maXJtcyB0aGUgInJlZ2lzdGVyIHBvaXNvbmluZyIgZGVzY3JpYmVkDQo+PiBlYXJsaWVyLg0K
Pj4gDQo+PiAyLiBNSUIgYWNjZXNzIGlzIGEgZGlmZmVyZW50IHN0b3J5IC0gdGhpcyBpcyB0YWJs
ZSBsb29rdXAsIG5vdCBpbmRpcmVjdA0KPj4gYWNjZXNzLiBUYWJsZSBsb29rdXAgaXMgbm90IGFm
ZmVjdGVkIGJ5IHNwdXJpb3VzIHJlZ2lzdGVyIGFjY2Vzcy4NCj4+IA0KPj4gMy4gT3RoZXIgcG9z
c2libGUgYWNjZXNzZXMgLSBub3QgY3VycmVudGx5IHByZXNlbnQgaW4gdGhpcyBkcml2ZXIsIGJ1
dA0KPj4gZm9yIHdoaWNoIEkgaGF2ZSBzb21lIFdJUCBjaGFuZ2VzIC0gaW5jbHVkZSBBQ0wgKEFj
Y2VzcyBDb250cm9sIExpc3QpLA0KPj4gTDIgKEZEQiksIGFuZCBNQyAoTURCKSBhY2Nlc3MuIEJ1
dCBhbGwgb2YgdGhlc2UgYXJlIHRhYmxlIGFjY2VzcyBzaW1pbGFyDQo+PiB0byBNSUIgYWNjZXNz
LCBhbmQgaGVuY2Ugbm90IHRyb3VibGVkIGJ5IHNwdXJpb3VzIHJlZ2lzdGVyIGFjY2Vzcy4NCj4+
IA0KPj4gNC4gSE9XRVZFUiwgb25seSBvbmUgdGFibGUgY2FuIGJlIGFjY2Vzc2VkIGF0IGEgdGlt
ZS4gU28gYSBsb2NrIGlzDQo+PiBuZWVkZWQgaGVyZS4gQ3VycmVudGx5IHRoZSBvbmx5IHRhYmxl
IGxvb2t1cCBpcyBNSUIgYWNjZXNzLCB3aGljaCBpcw0KPj4gcHJvdGVjdGVkIGJ5IG1pYl9sb2Nr
LCBzbyB3ZSBhcmUgT0sgZm9yIG5vdy4NCj4+IA0KPj4gNS4gSXQgc2hvdWxkIGJlIHN1ZmZpY2ll
bnQgdG8gbG9jayBkdXJpbmcgaW5kaXJlY3QgUEhZIHJlZ2lzdGVyIGFjY2Vzcw0KPj4gYXMgcHJl
c2NyaWJlZCBpbiBteSBwYXRjaC4NCj4+IA0KPj4gSSBob3BlIHRoYXQgY2xlYXJzIHRoaW5ncyB1
cC4gSSB3aWxsIGJlIHNlbmRpbmcgYSB2MiB3aXRoIGEgcmV2aXNlZA0KPj4gZGVzY3JpcHRpb24s
IGluY2x1ZGluZyB0aGUgc3RhdGVtZW50cyBmcm9tIFJlYWx0ZWsgYW5kIHRoZSByZXN1bHRzIG9m
DQo+PiB0aGUgdGVzdHMgSSByYW4uDQo+PiANCj4+IEtpbmQgcmVnYXJkcywNCj4+IEFsdmluDQo+
DQo+IE5pY2Ugd29yayENCj4NCj4gVGhpcyBsb29rcyBtb3JlIGNvbXByZWhlbnNpdmUsIGFsdGhv
dWdoIHJlZ2FyZGluZyBjaGVja19waHlfd3JpdGUoKSwNCj4gbXkgdW5kZXJzdGFuZGluZyBpcyB0
aGF0IHlvdSBjaGVja2VkIGNyb3NzLXJlYWRzIGFuZCBjcm9zcy13cml0ZXMgd2l0aA0KPiBvbmx5
IG9uZSByZWdpc3RlcjogcHJpdi0+cmVhZF9yZWcgaXMgaW1wbGljaXRseSAwIGR1cmluZyB0aGUN
Cj4gZG9fcmVnX3dvcmsoKSAtPiBjaGVja19waHlfd3JpdGUoKSBjYWxsIHNlcXVlbmNlLCBzbyB0
aGF0IHJlZ2lzdGVyIGlzDQo+IHByb2JhYmx5IFBPUlQwX0NHU1RfSEFMRl9DRkcuDQoNCldvb3Bz
LCBteSBiYWQgLSB0aGFua3MgZm9yIGNoZWNraW5nLiBJIGFkZGVkIGFuIGV4dHJhIGxvb3AgaW4N
CmNoZWNrX3BoeV93cml0ZSgpIG5vdyB0byBkbyB0aGUgY2hlY2tpbmcgd2l0aCBhIGNyb3NzLXJl
YWQgb2YgZXZlcnkNCihnb29kKSByZWdpc3RlciAoYW5kIG1vdmVkIGNoZWNrX2dvb2RfcmVncygp
IGJlZm9yZQ0KY2hlY2tfcGh5X3dyaXRlKCkpLiBUaGUgcmVzdWx0cyBhcmUgYnJvYWRseSB0aGUg
c2FtZSwgYWx0aG91Z2ggSSBzdGFydA0KdG8gZ2V0IHNvbWUgY2hhbmdlcyB3aGVuIHJlYWNoaW5n
IHJlZ2lzdGVycyBsaWtlIFBPUlQwX1NUQVRVUyAoZm9yDQpvYnZpb3VzIHJlYXNvbnMsIHNpbmNl
IEknbSBwb2tpbmcgdGhlIFBIWSBjb250cm9sIHJlZ2lzdGVyKS4gVGhlcmUgdGhlDQpsb2dpYyBv
ZiBteSB0ZXN0IHN0YXJ0cyB0byBicmVhayBkb3duIGEgYml0IGJlY2F1c2UgYSBsb3Qgb2YgdGhl
IHNhbml0eQ0KY2hlY2tzIGFzc3VtZSB0aGF0IHRoZSByZWdpc3RlcnMgYXJlIG5vbi12b2xhdGls
ZS4NCg0KU3RpbGwsIFBPUlQwX1NUQVRVUyBpcyB0aGUgfjMwMDB0aCByZWdpc3RlciBpbiB0aGUg
bGlzdCwgc28gaWYgYWxsIG90aGVyDQpjcm9zcy1yZWFkcyBwcmlvciB0byB0aGF0IGRvbid0IGFm
ZmVjdCB0aGUgUEhZIHdyaXRlLCBJIGFtIGNvbnZpbmNlZA0KdGhhdCB0aGlzIGlzIG5vdCBhIHBy
b2JsZW0gZm9yIFBIWSB3cml0ZXMuDQoNCkZvciBjcm9zcy13cml0ZXMgSSBhbSBhbHdheXMgd3Jp
dGluZyB0aGUgc2FtZSByZWdpc3RlciBhbnl3YXkuDQoNCj4NCj4gQW55d2F5LCBpZiBSZWFsdGVr
J3MgZGVzY3JpcHRpb24gaXMgdGhhdCAiaWYgYSByZWFkIGZhaWxzLCB0aGUgdmFsdWUNCj4gcmVh
ZCBiYWNrIHdpbGwgYmUgdGhlIHJlc3VsdCBvZiB0aGUgbGFzdCBzdWNjZXNzZnVsIHJlYWQiLCB0
aGVuIGl0J3MNCj4gcHJvYmFibHkgbm90IHN1cHJpc2luZyB0aGF0IGNyb3NzLXJlYWRzIGFuZCBj
cm9zcy13cml0ZXMgZG9uJ3QgbWFrZSB0aGUNCj4gaW5kaXJlY3QgUEhZIHdyaXRlIGZhaWwgKHNp
bmNlIHRoZXJlJ3Mgbm8gcmVnaXN0ZXIgcmVhZCkuIEkgZG9uJ3QgaGF2ZQ0KPiB0aGUgYmFja2dy
b3VuZCBvZiB3aGF0IGlzIHRoZSBPQ1AsIGJ1dCB0aGUgaW1wbGljYXRpb24gb2YgdGhlIGFib3Zl
DQo+IHBhcmFncmFwaCBzZWVtcyB0byBiZSB0aGF0IGFuIGluZGlyZWN0IFBIWSByZWFkIGlzIGlu
IGVzc2VuY2UgdGhlIHJlYWQNCj4gb2YgYSBzaW5nbGUgcmVnaXN0ZXIsIHdoaWNoIGdldHMgYWJv
cnRlZCB3aGVuIGEgcmVhZCBvZiBhbnkgb3RoZXINCj4gcmVnaXN0ZXIgZXhjZXB0IFJUTDgzNjVN
Ql9JTkRJUkVDVF9BQ0NFU1NfU1RBVFVTX1JFRyBvcg0KPiBSVEw4MzY1TUJfSU5ESVJFQ1RfQUND
RVNTX1JFQURfREFUQV9SRUcgZ2V0cyBpbml0aWF0ZWQuDQoNCkkgYWdyZWUgd2l0aCB3aGF0IHlv
dSB3cm90ZSBhYm92ZSwgSSB0aGluayBpdCBjYXB0dXJlcyB0aGUgcG9pbnQNCnN1Y2NpbmN0bHku
IChJIGFsc28gZG9uJ3Qga25vdyB3aGF0IE9DUCBzdGFuZHMgZm9yLikNCg0KS2luZCByZWdhcmRz
LA0KQWx2aW4=
