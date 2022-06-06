Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E6D53EA8E
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbiFFNrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 09:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239057AbiFFNrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 09:47:16 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70110.outbound.protection.outlook.com [40.107.7.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E207C6318;
        Mon,  6 Jun 2022 06:47:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWB4daBQI3PmYjmyntIDaj94dvvguqDmXBDLr98bFE+ohisv/n87Vp7l10R0zudrdQQ6s5KKM8MX+W8K3UqPQIfSlK+CTjQ2Wb1DlqXQd5pMxWaJXvGhRLqQGTh/7rt36HyPWiXjAU4fqSdPC9l/2oaNeTdqAlPZHUj5Iiy2imRJEJW5zmYo9OcLr21q+GGgFDYRPR4Ullh1Tt5dNMJl7R6OPq5s5dl9ggx643DnNILIcz6jAjEqQ4SAnGv/qiuOwL1tSirWHjHCt5fiUhBrZVCRPoummfg+dBM2TSda7kFdNA9AwtfdDFkhjvbqXfw05LO9p4uv8Pn5GbaMnNKaGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/xWIVKZyh52JZ368s6qNOIdZG2n2ygr8U2U8LNhIc0=;
 b=hd9GQTYvVeYChVruVHOXvH1FCQ6arEY02iikv1OqBFtRNNDn+4aoc/hTY3Q7s6uVdf2/oB5U4My6+1JJu4TnfSMomWaBk7P/vLCCwcvwyD10liVVTN1Ee3DHci2q1TZIfXm8YkOxdwyzQsefGTdO7FFSQwTe9nCFCYD68oMHOp9gveuK0+d5gYfxr3KXWMHfIbbBrVtn9ondtC4iK2NL3F/Y4b0LjfAy+Qmv1byyqtyenae3G1Y/6FsfWJ1pyzb+o77nMTF43Af8DZtHaeMtAb8wrVB9VG6Y5OjOzoG4z2PSFl5bFkbpZPiTBbeQK9dpsUQYeiuAzYDcc0lAAhMFjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/xWIVKZyh52JZ368s6qNOIdZG2n2ygr8U2U8LNhIc0=;
 b=eT4CtS0gIAZuOlCn70tdHEvhCi/6dgu2lBl9awJC01G8dsl+08gYwmkyyHe+ygYNkUE4mVo0p103bAI5pHEgNBAq1QwD1oNzpm3DzNJ7EbzCTqJgH/OmoDADq2ier4qHHHSRPIr50GJn+X6v5QJaZi+UhO9xQxXWA7JVFvZIp1Y=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by VI1PR0302MB3344.eurprd03.prod.outlook.com (2603:10a6:803:26::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Mon, 6 Jun
 2022 13:47:09 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111%7]) with mapi id 15.20.5314.018; Mon, 6 Jun 2022
 13:47:09 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        "luizluca@gmail.com" <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: realtek: rtl8365mb: fix GMII caps for ports
 with internal PHY
Thread-Topic: [PATCH net] net: dsa: realtek: rtl8365mb: fix GMII caps for
 ports with internal PHY
Thread-Index: AQHYeaWWRGyRRdDb9EGDzfVT+zDwia1CYBkAgAAEbwA=
Date:   Mon, 6 Jun 2022 13:47:08 +0000
Message-ID: <20220606134708.x2s6hbrvyz4tp5ii@bang-olufsen.dk>
References: <20220606130130.2894410-1-alvin@pqrs.dk>
 <Yp4BpJkZx4szsLfm@shell.armlinux.org.uk>
In-Reply-To: <Yp4BpJkZx4szsLfm@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a926b86-1e68-44f0-1542-08da47c30d0f
x-ms-traffictypediagnostic: VI1PR0302MB3344:EE_
x-microsoft-antispam-prvs: <VI1PR0302MB33442F03EFCF7B65D78AEB4E83A29@VI1PR0302MB3344.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OyKfsBf6EP8ukXNwKIytdKXi6ADqpDXhLC/42p9eM6EwZviG0qXUtxFcRitwzEJxogVVId5iks0+TvXZKTGIQo1L36BPgkAx7F1PCvGqkMW/Unt9DkDg23rBIsr24wXgH+DC9swVCzc8gsH1V9fQkH2nyAJ3JwK1NOJn1/aEptNKWjNpXkbSis3ZVtzZoLPnx0GQSSuJ1x9FTrBHq96kr0nBsRojFpje48n8twzkTyg0WenYVHQyapmC2AXcJH5gQk9Vc2pYZuvYJhtjb6zQGQltqgT3X3lP5tO5QiemqZRUXJecpIiKsK7XxauaNst7WfyQZGvc6ozqRaTIuaTqwNvVmtoAMU1Li7HUHU4lJd+0ZzedBugPsJyVd3pOxKubbgMIx/R5r7Qwwzk45wTcOBy5HW7BFG4SjcD5rs6GkvrTMmfw2HC6gESPOfDikmchjQ+efO3it2aSzYJVASOecRmYFCZnd+sCWa53yFoapw8bRw7C59ZjFZSImgVQ9fjDJU+aG1U9BelGpIdDAtsn8++elumvNIXmO/Q0KobU+R/lEU8cWeodI/Nvx6mJwZC3MpyEqDFhOEqlUzyRF0R4YZW5YP3PbzQZg55VyvOe9BLPgDCSNy63u6votnNIfxTqeYZxS+i800y8SVhppGPf9srkAXl3W3uwPHUCXu+23lRM5asw93NkCrX9N30UZGVAhxREk6yTTN3hadgh2HdXtg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(54906003)(316002)(6916009)(2906002)(66476007)(66556008)(38070700005)(91956017)(64756008)(66446008)(66946007)(8676002)(4326008)(76116006)(71200400001)(186003)(122000001)(2616005)(66574015)(7416002)(6506007)(1076003)(6512007)(86362001)(26005)(508600001)(6486002)(38100700002)(83380400001)(5660300002)(8976002)(8936002)(85182001)(85202003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SjFhUE16amU5aEt1ckZlelFnZ2UzREtQNnBxMy83RGwwZGE2REJpamFSSmRx?=
 =?utf-8?B?czlZT3kwSmFqRjlLdy8ydGJOaFMzcWc4RlNac3c3SWhkVmJ0L2wzOWdoVU5Q?=
 =?utf-8?B?ditmYk1yRmc2bWNWMjRXYmw2dG9DZUtTVkpSNEEzTDhWS2JJWWpTa2tQb2ZC?=
 =?utf-8?B?c1JQOCtwSTBEcktGc1FrYUlSa1dQSkpFUU5kaWJ1a3ArMklYWERRc2gvYytt?=
 =?utf-8?B?VUxySTZ2VEQ3VURFWHNaaml3bVFsc2MzMy9DZ21UNVZ5bHVxMDBSZkJpOTMz?=
 =?utf-8?B?MTluMnA0bDg3LzlPK0ZXVmY0TG90cnNwazcrZnNEUTNhdnVUZFB2blJyWXpn?=
 =?utf-8?B?Y01oeTJTd1JZclpIcUhaNTFqTVZna1gxR1prNldaTTZIL0FqU0JSdFVONjh6?=
 =?utf-8?B?NXlIRGpXT1dLdFUreTh4aXIwQWxjM2M4a3ZnejVDVWdBWDNPVHhDeFpESUtZ?=
 =?utf-8?B?cVJkWHc2bkx3M3AzaFFkb3lFVE5TQmZnWjRZU3FnSG13dGhKTmlMYVhGanFQ?=
 =?utf-8?B?SmVxMFdReEt5L1h3eGtuMFpUczAxajBMME5pVzl3ZXNaVGtSM3Z1R1BOTGdX?=
 =?utf-8?B?WkM4cWd4UVp2S1ozaFNkZ1RZbFoyZE43eVk4dUwrdzZjOW9TcHJlT1VUY1kr?=
 =?utf-8?B?S1NPaWNIdUpyczFLejFYODFjVTFLOW1mTThLVXFVS3gyVUxZYk93TFdycmd6?=
 =?utf-8?B?LzFzTlRVNGsvckFRZy9hK0IrMERCaGVlUjZnZ3UrOUZqU0VKVzB0M2dJcnFO?=
 =?utf-8?B?c3RmMUN6SUJHazd5WGlCQVpybnJqbzNFdUh4ZHltSWlBbzhTdnpNNmZQRXdY?=
 =?utf-8?B?VlBMajZPVkRYcjErWCtnRG5yTm1USm5adTJMeDQwWG1wTFdsMm0vQ2Z6MUhp?=
 =?utf-8?B?aTh3QkpKN3lNbEltakhYQUg3M2JSNWxHUGVscmh1aXZGZUVONVlVUXBSdmRx?=
 =?utf-8?B?ZW8zSTF6eHVLZEVIRmdWZDVXTWJUT0VDVjZtOXZDKzFsSElsMWI5VnVyUGZ6?=
 =?utf-8?B?dVhnZDFuMjBSSSt1ZzFjQS9NbWp3VXFFSE52enAxWEUxcVF0VWhJNXcwWVBn?=
 =?utf-8?B?bnkzc2x2ZnQ1TDljWWNoNWJCc3ljdzVJa2NVdWFKRCtSKy9MY1E1QTMxZit1?=
 =?utf-8?B?YTV4M1lROUJHOTE3QVo0UVM5SUsrWk1pejJ1ZzFLMzIrVjNILzRlY1BxS1JV?=
 =?utf-8?B?aGV1cjJaZ1o0VTNkK3lINEtBaGxhbG96YThPeHFRazNTM1ltVTJ6d3Q0Sy9o?=
 =?utf-8?B?Q1ZId0hRY1FlV0U2elpuK3p4d2pPdVg3Q2lxSmxQci9lQVQxdE9uS1NOS2ZZ?=
 =?utf-8?B?WGJyRk5ZVHZOZDJQVlg4ejlRWG5xRWZ0amZnOUdZRi9xU3U5Ump5RGpHblh0?=
 =?utf-8?B?R2FHLzVNNEZNblJXNVU5VkVRWHpOenBsSU9KTm1RTktocHNWWU1udGRVSFVZ?=
 =?utf-8?B?akxRbVFJeklUMWhqSS9YWnd4TUlQRnNucnNOS0tjSWtuNWFucDZVa2M3dGcv?=
 =?utf-8?B?cnorTWFYOGxpK0djNkdteFlGMVVCMHcxeXpYck5iYmdPOHQ5UWtSbXJFQUty?=
 =?utf-8?B?MEVKZGt6dlMwQ2E1QjdkKzlIcVlBMngwMUQrUnBDaE9jSGtMWlRCLzlWelZm?=
 =?utf-8?B?L2tYYUI5ZDF2eWpQdFlhbmRQUTdSVFV0dlBicXNWa1A4V2xjc1V3TmRQZjJR?=
 =?utf-8?B?TzFYVTlCK3VNbzB3am1YWURQVFgyRThBN2Y5bGpoc2h4c1dZZ0RXS0VHTklv?=
 =?utf-8?B?TC9CNkorSnVFTVhkQjE1SE54N1ZQR21TK0g3eVJwYkd0eE9QQU4vSjJ2L1Bx?=
 =?utf-8?B?L3dQNmVvRU83NnJ6Sit1dnRsN1hpNUE3ZTAzUEozMXNTOWNRTkFpUGFtUFhl?=
 =?utf-8?B?Nm02TC9Mdm1tWlp6YTNtSUhETm5Nd2wrRnhFNy9DVng4SjlDbWswdGRNV1hs?=
 =?utf-8?B?WWpxeVR2bXRLSU0vQjBwMTJnUW5Pd0hia3ZYV0xrRHdCRC91WlZGMSt0ek9N?=
 =?utf-8?B?UXZzMG15aVl5Ry83RXB6ODZtS1R0QmttZzN4cGxraXdPb0lTcHFQN1VsWStQ?=
 =?utf-8?B?cWRzc2dmek84cXpPMzBnWWhIdUhxQVM2VVBDalZkekErdHBwZ3hoV3hPU0VE?=
 =?utf-8?B?ZTJoMUVWNllzTFpZNVRacGhDSkFLenJ4djRDcmRQRXVmaEFrb2FUYnk3YzYv?=
 =?utf-8?B?aTBmT1A2RFRaQ3hOZy9yL242MkcrUUQwNDhuOEFTU2EyR1lOK2x1OUdKL0VO?=
 =?utf-8?B?TkJvN0J6eFl4OFhEaEtLY21Db0h6aW5TanJsdlByQTljR2VQTUdqMnlXeS9F?=
 =?utf-8?B?cUlZZ2QvU0h6T2FodTRXVFVVcEZ5QndhOW5JdDZhNDZsY1g0Qmk0ZlhBdExi?=
 =?utf-8?Q?wHB1O22spOTdFLRE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC44C9E786FC624AB4F6B3B119924AA4@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a926b86-1e68-44f0-1542-08da47c30d0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2022 13:47:08.9164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yi2g5p2Js9Z3DxetiaPqNt+L0DuBP0vvqKOu+Hqktji4rbW0rnjk8aakLy8sQQrcvUu7HzMTA7WbERGkpm/MFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3344
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBKdW4gMDYsIDIwMjIgYXQgMDI6MzE6MTZQTSArMDEwMCwgUnVzc2VsbCBLaW5nIChP
cmFjbGUpIHdyb3RlOg0KPiBPbiBNb24sIEp1biAwNiwgMjAyMiBhdCAwMzowMTozMFBNICswMjAw
LCBBbHZpbiDFoGlwcmFnYSB3cm90ZToNCj4gPiBGcm9tOiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBi
YW5nLW9sdWZzZW4uZGs+DQo+ID4gDQo+ID4gcGh5bGliIGRlZmF1bHRzIHRvIEdNSUkgd2hlbiBu
byBwaHktbW9kZSBvciBwaHktY29ubmVjdGlvbi10eXBlIHByb3BlcnR5DQo+ID4gaXMgc3BlY2lm
aWVkIGluIGEgRFNBIHBvcnQgbm9kZS4NCj4gPiANCj4gPiBDb21taXQgYTVkYmEwZjIwN2U1ICgi
bmV0OiBkc2E6IHJ0bDgzNjVtYjogYWRkIEdNSUkgYXMgdXNlciBwb3J0IG1vZGUiKQ0KPiA+IGlu
dHJvZHVjZWQgaW1wbGljaXQgc3VwcG9ydCBmb3IgR01JSSBtb2RlIG9uIHBvcnRzIHdpdGggaW50
ZXJuYWwgUEhZIHRvDQo+ID4gYWxsb3cgYSBQSFkgY29ubmVjdGlvbiBmb3IgZGV2aWNlIHRyZWVz
IHdoZXJlIHRoZSBwaHktbW9kZSBpcyBub3QNCj4gPiBleHBsaWNpdGx5IHNldCB0byAiaW50ZXJu
YWwiLg0KPiA+IA0KPiA+IENvbW1pdCA2ZmY2MDY0NjA1ZTkgKCJuZXQ6IGRzYTogcmVhbHRlazog
Y29udmVydCB0byBwaHlsaW5rX2dlbmVyaWNfdmFsaWRhdGUoKSIpDQo+ID4gdGhlbiBicm9rZSB0
aGlzIGJlaGF2aW91ciBieSBkaXNjYXJkaW5nIHRoZSB1c2FnZSBvZg0KPiA+IHJ0bDgzNjVtYl9w
aHlfbW9kZV9zdXBwb3J0ZWQoKSAtIHdoZXJlIHRoaXMgR01JSSBzdXBwb3J0IHdhcyBpbmRpY2F0
ZWQgLQ0KPiA+IHdoaWxlIHN3aXRjaGluZyB0byB0aGUgbmV3IC5waHlsaW5rX2dldF9jYXBzIEFQ
SS4NCj4gPiANCj4gPiBXaXRoIHRoZSBuZXcgQVBJLCBydGw4MzY1bWJfcGh5X21vZGVfc3VwcG9y
dGVkKCkgaXMgbm8gbG9uZ2VyIG5lZWRlZC4NCj4gPiBSZW1vdmUgaXQgYWx0b2dldGhlciBhbmQg
YWRkIGJhY2sgdGhlIEdNSUkgY2FwYWJpbGl0eSAtIHRoaXMgdGltZSB0bw0KPiA+IHJ0bDgzNjVt
Yl9waHlsaW5rX2dldF9jYXBzKCkgLSBzbyB0aGF0IHRoZSBhYm92ZSBkZWZhdWx0IGJlaGF2aW91
ciB3b3Jrcw0KPiA+IGZvciBwb3J0cyB3aXRoIGludGVybmFsIFBIWSBhZ2Fpbi4NCj4gDQo+IE9v
cHMgLSBJIGd1ZXNzIHRoaXMgaGFzIGJlZW4gY2F1c2VkIGJ5IHRoZSBkZWxheSBiZXR3ZWVuIG15
IHBhdGNoIGJlaW5nDQo+IGluaXRpYWxseSBwcmVwYXJlZCwgaXQgc2l0dGluZyBhcm91bmQgaW4g
bXkgdHJlZSBmb3IgbWFueSBtb250aHMgd2hpbGUNCj4gb3RoZXIgcGF0Y2hlcyBnZXQgbWVyZ2Vk
LCBhbmQgaXQgZXZlbnR1YWxseSBzZWVpbmcgdGhlIGxpZ2h0IG9mIGRheS4NCj4gDQo+IFNvcnJ5
IGFib3V0IHRoYXQuDQoNCk5vIHByb2JsZW0sIGl0J3MgYWN0dWFsbHkgbXkgYmFkLCBidXQgSSBh
bSBzdGlsbCBnZXR0aW5nIHRvIGdyaXBzIHdpdGggdGhlDQpyZXNwb25zaWJpbGl0eSBvZiBtYWlu
dGFpbmluZyBhIExpbnV4IGRyaXZlciA6KQ0KDQo+IA0KPiA+IEZpeGVzOiA2ZmY2MDY0NjA1ZTkg
KCJuZXQ6IGRzYTogcmVhbHRlazogY29udmVydCB0byBwaHlsaW5rX2dlbmVyaWNfdmFsaWRhdGUo
KSIpDQo+ID4gU2lnbmVkLW9mZi1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2Vu
LmRrPg0KPiA+IC0tLQ0KPiA+IA0KPiA+IEx1aXosIFJ1c3NlbDoNCj4gPiANCj4gPiBDb21taXQg
YTVkYmEwZjIwN2U1IG91Z2h0IHRvIGhhdmUgaGFkIGEgRml4ZXM6IHRhZyBJIHRoaW5rLCBiZWNh
dXNlIGl0DQo+ID4gY2xhaW1zIHRvIGhhdmUgYmVlbiBmaXhpbmcgYSByZWdyZXNzaW9uIGluIHRo
ZSBuZXQtbmV4dCB0cmVlIC0gaXMgdGhhdA0KPiA+IHJpZ2h0PyBJIHNlZW0gdG8gaGF2ZSBtaXNz
ZWQgYm90aCByZWZlcmVuY2VkIGNvbW1pdHMgd2hlbiB0aGV5IHdlcmUNCj4gPiBwb3N0ZWQgYW5k
IG5ldmVyIGhpdCB0aGlzIGlzc3VlIHBlcnNvbmFsbHkuIEkgb25seSBmb3VuZCB0aGluZ3Mgbm93
DQo+ID4gZHVyaW5nIHNvbWUgb3RoZXIgcmVmYWN0b3JpbmcgYW5kIHRoZSB0ZXN0IGZvciBHTUlJ
IGxvb2tlZCB3ZWlyZCB0byBtZQ0KPiA+IHNvIEkgd2VudCBhbmQgaW52ZXN0aWdhdGVkLg0KPiA+
IA0KPiA+IENvdWxkIHlvdSBwbGVhc2UgaGVscCBtZSBpZGVudGlmeSB0aGF0IEZpeGVzOiB0YWc/
IEp1c3QgZm9yIG15IG93bg0KPiA+IHVuZGVyc3RhbmRpbmcgb2Ygd2hhdCBjYXVzZWQgdGhpcyBh
ZGRlZCByZXF1aXJlbWVudCBmb3IgR01JSSBvbiBwb3J0cw0KPiA+IHdpdGggaW50ZXJuYWwgUEhZ
Lg0KPiANCj4gSSBoYXZlIGFic29sdXRlbHkgbm8gaWRlYS4gSSBkb24ndCB0aGluayBhbnkgInJl
cXVpcmVtZW50IiBoYXMgZXZlciBiZWVuDQo+IGFkZGVkIC0gcGh5bGliIGhhcyBhbHdheXMgZGVm
YXVsdGVkIHRvIEdNSUksIHNvIGFzIHRoZSBkcml2ZXIgc3Rvb2Qgd2hlbg0KPiBpdCB3YXMgZmly
c3Qgc3VibWl0dGVkIG9uIE9jdCAxOCAyMDIxLCBJIGRvbid0IHNlZSBob3cgaXQgY291bGQgaGF2
ZQ0KPiB3b3JrZWQsIHVubGVzcyB0aGUgRFQgaXQgd2FzIGJlaW5nIHRlc3RlZCB3aXRoIHNwZWNp
ZmllZCBhIHBoeS1tb2RlIG9mDQo+ICJpbnRlcm5hbCIuIEFzIHlvdSB3ZXJlIHRoZSBvbmUgd2hv
IHN1Ym1pdHRlZCBpdCwgeW91IHdvdWxkIGhhdmUgYQ0KPiBiZXR0ZXIgaWRlYS4NCj4gDQo+IFRo
ZSBvbmx5IHN1Z2dlc3Rpb24gSSBoYXZlIGlzIHRvIGJpc2VjdCB0byBmaW5kIG91dCBleGFjdGx5
IHdoYXQgY2F1c2VkDQo+IHRoZSBHTUlJIHZzIElOVEVSTkFMIGlzc3VlIHRvIGNyb3AgdXAuDQoN
CkFscmlnaHQsIHRoYW5rcyBmb3IgdGhlIHF1aWNrIHJlc3BvbnNlLiBNYXliZSBMdWl6IGhhcyBh
IGJldHRlciBpZGVhLCBvdGhlcndpc2UNCkkgd2lsbCB0cnkgYmlzZWN0aW5nIGlmIEkgZmluZCB0
aGUgdGltZS4NCg0KRm9yIHdoYXQgaXQncyB3b3J0aCwgSSBiZWxpZXZlIHRoZSBwYXRjaCBpcyBj
b3JyZWN0IGFuZCBhcHBsaWNhYmxlIGluIGl0cw0KY3VycmVudCBmb3JtIC0gaXQganVzdCBsYWNr
cyBhbiBleHBsYW5hdGlvbiBhcyB0byB3aHkgdGhpcyBldmVyIHdvcmtlZCBpbiB0aGUNCmZpcnN0
IHBsYWNlLg0KDQo+IA0KPiA+IA0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9kc2EvcmVhbHRl
ay9ydGw4MzY1bWIuYyB8IDM4ICsrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDI5IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYyBiL2RyaXZl
cnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jDQo+ID4gaW5kZXggM2JiNDJhOWYyMzZkLi43
NjlmNjcyZTkxMjggMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRs
ODM2NW1iLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYw0K
PiA+IEBAIC05NTUsMzUgKzk1NSwyMSBAQCBzdGF0aWMgaW50IHJ0bDgzNjVtYl9leHRfY29uZmln
X2ZvcmNlbW9kZShzdHJ1Y3QgcmVhbHRla19wcml2ICpwcml2LCBpbnQgcG9ydCwNCj4gPiAgCXJl
dHVybiAwOw0KPiA+ICB9DQo+ID4gIA0KPiA+IC1zdGF0aWMgYm9vbCBydGw4MzY1bWJfcGh5X21v
ZGVfc3VwcG9ydGVkKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQo+ID4gLQkJCQkJ
IHBoeV9pbnRlcmZhY2VfdCBpbnRlcmZhY2UpDQo+ID4gLXsNCj4gPiAtCWludCBleHRfaW50Ow0K
PiA+IC0NCj4gPiAtCWV4dF9pbnQgPSBydGw4MzY1bWJfZXh0aW50X3BvcnRfbWFwW3BvcnRdOw0K
PiA+IC0NCj4gPiAtCWlmIChleHRfaW50IDwgMCAmJg0KPiA+IC0JICAgIChpbnRlcmZhY2UgPT0g
UEhZX0lOVEVSRkFDRV9NT0RFX05BIHx8DQo+ID4gLQkgICAgIGludGVyZmFjZSA9PSBQSFlfSU5U
RVJGQUNFX01PREVfSU5URVJOQUwgfHwNCj4gPiAtCSAgICAgaW50ZXJmYWNlID09IFBIWV9JTlRF
UkZBQ0VfTU9ERV9HTUlJKSkNCj4gPiAtCQkvKiBJbnRlcm5hbCBQSFkgKi8NCj4gPiAtCQlyZXR1
cm4gdHJ1ZTsNCj4gPiAtCWVsc2UgaWYgKChleHRfaW50ID49IDEpICYmDQo+ID4gLQkJIHBoeV9p
bnRlcmZhY2VfbW9kZV9pc19yZ21paShpbnRlcmZhY2UpKQ0KPiA+IC0JCS8qIEV4dGVuc2lvbiBN
QUMgKi8NCj4gPiAtCQlyZXR1cm4gdHJ1ZTsNCj4gPiAtDQo+ID4gLQlyZXR1cm4gZmFsc2U7DQo+
ID4gLX0NCj4gPiAtDQo+ID4gIHN0YXRpYyB2b2lkIHJ0bDgzNjVtYl9waHlsaW5rX2dldF9jYXBz
KHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQo+ID4gIAkJCQkgICAgICAgc3RydWN0
IHBoeWxpbmtfY29uZmlnICpjb25maWcpDQo+ID4gIHsNCj4gPiAtCWlmIChkc2FfaXNfdXNlcl9w
b3J0KGRzLCBwb3J0KSkNCj4gPiArCWlmIChkc2FfaXNfdXNlcl9wb3J0KGRzLCBwb3J0KSkgew0K
PiANCj4gR2l2ZW4gdGhlIHVwZGF0ZXMgdG8gcnRsODM2NW1iX3BoeV9tb2RlX3N1cHBvcnRlZCgp
LCB0aGlzIG1pc3NlcyBvdXQgb24NCj4gdGhlIGNoZWNrIG9mIHJ0bDgzNjVtYl9leHRpbnRfcG9y
dF9tYXBbcG9ydF0gaW50cm9kdWNlZCBpbiBjb21taXQNCj4gNjE0NzYzMWMwNzlmICgibmV0OiBk
c2E6IHJlYWx0ZWs6IHJ0bDgzNjVtYjogYWxsb3cgbm9uLWNwdSBleHRpbnQNCj4gcG9ydHMiKS4N
Cg0KWW91IGFyZSByaWdodCwgYnV0IHNpbmNlIHRoaXMgaXMgdGFyZ2V0dGluZyBuZXQgYW5kIG5v
dCBuZXQtbmV4dCwgSSBmaWd1cmVkIEkNCndvdWxkIG5vdCBpbnRyb2R1Y2UgYW55IGFkZGl0aW9u
YWwgY2hhbmdlcy4gSSBoYXZlIGEgc2VwYXJhdGUgc2VyaWVzIGxpbmVkIHVwDQpmb3IgbmV0LW5l
eHQgKGp1c3Qgc3VibWl0dGVkKSB3aGljaCBmaXhlcyB0aGlzIGluIGEgbXVjaCBjbGVhbmVyIHdh
eS4NCg0KTXkgcmF0aW9uYWxlIGhlcmUgaXM6IHllcywgdGhpcyB0ZXN0IGlzIGluY29ycmVjdCBh
bmQgaXMgYSBzaG9ydGNvbWluZyBvZiB0aGUNCmRyaXZlciwgYnV0IGl0IGRvZXMgbm90IHJlcHJl
c2VudCBhIHJlYWwgYnVnIHdvcnRoeSBvZiBpbmNsdXNpb24gaW4gdGhlIHN0YWJsZQ0KdHJlZXMu
DQoNCj4gDQo+ID4gIAkJX19zZXRfYml0KFBIWV9JTlRFUkZBQ0VfTU9ERV9JTlRFUk5BTCwNCj4g
PiAgCQkJICBjb25maWctPnN1cHBvcnRlZF9pbnRlcmZhY2VzKTsNCj4gPiAtCWVsc2UgaWYgKGRz
YV9pc19jcHVfcG9ydChkcywgcG9ydCkpDQo+ID4gKw0KPiA+ICsJCS8qIEdNSUkgaXMgdGhlIGRl
ZmF1bHQgaW50ZXJmYWNlIG1vZGUgZm9yIHBoeWxpYiwgc28NCj4gPiArCQkgKiB3ZSBoYXZlIHRv
IHN1cHBvcnQgaXQgZm9yIHBvcnRzIHdpdGggaW50ZWdyYXRlZCBQSFkuDQo+ID4gKwkJICovDQo+
ID4gKwkJX19zZXRfYml0KFBIWV9JTlRFUkZBQ0VfTU9ERV9HTUlJLA0KPiA+ICsJCQkgIGNvbmZp
Zy0+c3VwcG9ydGVkX2ludGVyZmFjZXMpOw0KPiA+ICsJfSBlbHNlIGlmIChkc2FfaXNfY3B1X3Bv
cnQoZHMsIHBvcnQpKSB7DQo+IA0KPiBUaGlzIHRlc3QgYWxzbyBuZWVkcyB0byBiZSB1cGRhdGVk
Lg0KPiANCj4gTm90IHN1cmUgd2hhdCBydGw4MzY1bWJfZXh0aW50X3BvcnRfbWFwW3BvcnRdID09
IDAgaXMgc3VwcG9zZWQgdG8NCj4gc2lnbmlmeSAtIG1heWJlIHBvcnQgdW51c2FibGU/IExvb2tz
IHRoYXQgd2F5IHRvIG1lLg0KDQpDaGVjayB0aGUgb3RoZXIgc2VyaWVzIEkganVzdCBzZW50IGZv
ciBhIGNsZWFuZXIgaW1wbGVtZW50YXRpb24gb2YgdGhpcy4=
