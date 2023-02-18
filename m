Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B942D69B9FF
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 13:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBRM34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 07:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBRM3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 07:29:55 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2040.outbound.protection.outlook.com [40.107.7.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFFB1A49A
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 04:29:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNmrnasr1dVGSUxC+cjtanyHejBarAIEsm18TuQNdJeJN1OqzddoMkPDQjUFayAQZiHgz82qDLnfuan3ULOOKqd58HVZvW3z6fIjRBcv5sirBIOmqGOz2Lft5wSJAqG+HZSO0PeQTQ8QwYe3qFHQkdNVFXUfmYsZOsA+V8AkU+BB5MBgSWwlEmr0gFWokENmBra3g5BmUzz+ws1ltIDykGYkqcQUPF2RuaLqFO1t2qLr4t0EUxOU6eRSjlkGnMwC9zlPDgIc1hp/pQvzx7VF7H8LjwSRoe6WRue4PSTuOasATQjsmLFr6Y/S785HqbQtpynsKQVAV/7hgJlwNUYGQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tO8xCJg/bxZQiB6N6Db9S4leiDxt/O7SYG9uSdsgIjY=;
 b=ezrZk047YDA5zokE843+tB0JgecXBDcENdCVpdYtWGMh865Fmiy7w+oDNhyCsCwtDtMQsiajLuGdSn2Fp+VVAz3JaCCClg/0/n2C+1RXgyymE37UU68CXF9gqW3txiQO+2HBgd5MBa9QsjaAoqtCB9lNuAwdDYoaTsnZLEWuX2dnFFijbOoS9OrparxZsOFcsir/tpRhAM2HlVjbmdTJQIdkZ6T+CVbL3s6j+tjsZacGrPvDFD0OReTF1VKHe11cucAKn4ogeNi9z+fPU59uoOXjKHueGosQsbN32gOsC1+8uFodtN+4lophgbF/8GXlVAgvdS+c82knWKZmi8wRhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tO8xCJg/bxZQiB6N6Db9S4leiDxt/O7SYG9uSdsgIjY=;
 b=aUoKV3duGqeXGXbYOYxw64ExYIbG3nEqhfhRY52JUwsoIpJtvyyP52e//xjurIO8wNltHEgi/DcgjfvVAA6VCg4OsD/CL0GPL/GbZU0EZhjxOliuscB2ot9UrarorpUGqc/31nTCyyUMJ7EOaPnwLD6rw3+muPUb095V7vmoQoU=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DB8PR04MB6778.eurprd04.prod.outlook.com (2603:10a6:10:111::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sat, 18 Feb
 2023 12:29:50 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%7]) with mapi id 15.20.6111.018; Sat, 18 Feb 2023
 12:29:50 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Richard Weinberger <richard@nod.at>
CC:     Andrew Lunn <andrew@lunn.ch>,
        David Laight <David.Laight@aculab.com>,
        netdev <netdev@vger.kernel.org>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: high latency with imx8mm compared to imx6q
Thread-Topic: high latency with imx8mm compared to imx6q
Thread-Index: AdlDlHr59AVRNlAiQTelVSqfVfUDHwAABlCg
Date:   Sat, 18 Feb 2023 12:29:50 +0000
Message-ID: <DB9PR04MB8106956C85A6E28BD9BC1AA088A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <1422776754.146013.1676652774408.JavaMail.zimbra@nod.at>
 <b4fc00958e0249208b5aceecfa527161@AcuMS.aculab.com>
 <Y/AkI7DUYKbToEpj@lunn.ch>
 <DB9PR04MB81065CC7BD56EBDDC91C7ED288A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <130183416.146934.1676713353800.JavaMail.zimbra@nod.at>
 <DB9PR04MB8106FE7B686569FB15C3281388A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <2030061857.147332.1676721783879.JavaMail.zimbra@nod.at>
 <DB9PR04MB81068EF8919ED7488EE1E3D788A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
In-Reply-To: <DB9PR04MB81068EF8919ED7488EE1E3D788A69@DB9PR04MB8106.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|DB8PR04MB6778:EE_
x-ms-office365-filtering-correlation-id: 674fd20c-c6cb-4d46-93bc-08db11abd491
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8KcKAcFVqa3zWxvaupxoT5yHoGdPUB/LB4eXHs4aoxRLZ1DxaCiN6fQsehLaqZvX3+pFnxPmJ+BOskdNbScHjbTCeSB5xgttO603Eb3nVlwcRWu/Fp4HTAdOnUaW0mRQcu1whIESosnl9BGSeZz11oTUTem1sYRroQIJz+vZPc6UNyNExQ+2EAco9ATErlWkDw81sG1b+hGNwn/csfpHug0h3/uZiYZxzaBChzvPn4gFcBpqAolcCJtHrMFyVUBPf6V4YZgmGG0vgKkxWmV1jBCNap5XTDUPMxk5j6qru9bA2ByNsXj0DPov+P4eH0s4+AYNWrMrm+h41slKx9ZisVtzmXlKaUOXsV077jtjwMUWCmxYjxY4WcrNzYhmBogSl6hToCP6x4Nx8jDBLy/II5tJWJlZN+GQcKAaTQqSzgLSNizdOpD370M3luR2CgMz+eiqgJncCPWQHc069/iGY34P9u/y/JQBJUXC19Bz2KFD9Cx5C5lC9+xzDvy0J5aDouaNPnv2DhjgRnzOOR5YxEjqzjiIsZ+rMy2d7BItJFcnCINh/Dq3jFasW/yklqGytbsm8Tr8REMu7x3efQpDtVCUhd9ni87GdaKjY0B30OQ+2GB6q5cU8HLfWX9riIPG7LRRONrBY8I6HZApaoAmB5Mdcr0rggN8jcscjhJN/TN8Tf77sURdQ+VA3mnZY/t/YfZ2pp6JCgXE3HxXLtQpQBkT6Esy3b5u/iFf12+iDj4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(451199018)(33656002)(55016003)(83380400001)(2906002)(44832011)(6506007)(2940100002)(71200400001)(7696005)(26005)(186003)(9686003)(86362001)(122000001)(38100700002)(38070700005)(53546011)(5660300002)(6916009)(52536014)(478600001)(41300700001)(64756008)(66446008)(66476007)(8676002)(4326008)(66946007)(8936002)(76116006)(316002)(66556008)(54906003)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V25rYVBiWEtRM0pxdXU4aFZ6SGw2NGx6Skl1R2pBczRWZzdreTFaM0h0TzZh?=
 =?utf-8?B?bWp3QlJvLzlabzVMTE84aFFza2srT3ZPZExuWVlia2YreUwzR25FWGhSZ3Bo?=
 =?utf-8?B?M3RqMDFPLzhyN0xZc3lwRVpKNU8wSFR2L1FDMXFLeThVcnhrVGtmZG11L3FC?=
 =?utf-8?B?MFFnZFZZdW1YT2N1VFRuWEJIVHdUblczOW9MalpUend2UTJ4YWg4dldKNEt4?=
 =?utf-8?B?ZWxIYUVDeUlMeWQwcTJ2WkFSdFF1MmpzNEltK1FVTENBWVZMOHU4QUJRK2ti?=
 =?utf-8?B?VWtreGF6RXhaQTRqSVdTcGVUMzl5OWFTbnBRM0hha1ZQLzZmWUpJOWdOOTZj?=
 =?utf-8?B?UEJzQ3hFcjUveHlHTFBTd0QwRGtKK2x6OE9zcG5MeDdwMkpHL1JJb3NnZ3Nz?=
 =?utf-8?B?YVFTY3ZJeEQ2OFYyRUZUeW9xWGtHcHNKY0F2N2FHc0phL1ZjNUgxbjZXTEY3?=
 =?utf-8?B?RXAxVVI5YW04ZTFOemZxdUYyanlCOG1QbDlJOE5TUnlJNFExUzRtUEo0NXpx?=
 =?utf-8?B?TnFMMXJGYklMWkZycHE0ZmxvODVCdlpneXM0Z1lmeGNycHFReE11ZEVaREw5?=
 =?utf-8?B?TUZKUFJ3RFNKbXFXQk94ZXNrZFFQVWdHNVQrWXFiNGl1cEVLT2ZzRmZHRWZh?=
 =?utf-8?B?Tkg1Uzgwdng2Rm1UWGE4VmlNNW82ak9uSU5MTmlkaUVvQlhSbXByMHltT0NG?=
 =?utf-8?B?TXl5ZHFCUVFDUzd3N0pNWHhCcXNLMlZHNU1IajVoSWtiTDh3TDI1UUQxVmda?=
 =?utf-8?B?UVE2T3JZRks1VmVJelhVc0c2a1dYanUycUpJY1ZkODljb2R0ZlhUcEZpL2hy?=
 =?utf-8?B?OXp0a2ZtaitzeGZaTmFoQW54VDA4ZjlnWjZlK0dqL1RqV29KWW84NHB0ZkVN?=
 =?utf-8?B?TDZJOGJSTmRxeHFxMklqVEplNS9WRVFHWTJIOThnOEdHSXY1NDIxRndoTXpJ?=
 =?utf-8?B?bW9GNmZ3cDVsODZ4dExxY0Y5Qm1ORUZYWm1OcW12MFVQVTZZM1hWVkxmZVJR?=
 =?utf-8?B?UWFvUlU2YjdEYTdHbnU1WGJkUFJGdHZkZXdRNWx3ZG9UbTUrZWkwcGlsVCt3?=
 =?utf-8?B?eEloOTVWNUxsNyt5bEZUQnFiRWl5UmE5bTJaSzNjcmVkNU1vY3R3R1hvZ05v?=
 =?utf-8?B?b05aYnlHK0VJZGI0S2MvTEV1S0c0Y0RlMUlhT2JPMUJkN2ZkQTdRd3MwY3Vk?=
 =?utf-8?B?b2RKZ2hKQXMxYVpCdXFlb3hRYldMdlpPbkw3WlVueHl3UzRicUpKOGtoYTF2?=
 =?utf-8?B?cFVNUEQ2NzdLeUo3Yi83TE5CY0IwUXI2QmVTODdXM21Ra29aZm5ha1dlWkVh?=
 =?utf-8?B?M3Nhc0V6aTl6bkM1T2NwNnRGN2dPSjJydWJaTlBlS2VLcUZxWWZHTHE2WTR1?=
 =?utf-8?B?Q3JONHJtQm81Q29oYUtkWVp3NDEybmgvM0E1bHZDa3hXeWFpdUZmTXVQcFRt?=
 =?utf-8?B?OUJUcS9jNHFMbjNPYUY1cG8xZUY5bXhZODNMNmF0QWNpZWdka1l2OFJaZnoz?=
 =?utf-8?B?WDB4cHN0UVVjNldpQm5QWjN1T1pjWmNkN3I0bVU3L1VRWStiVFhYMm9OZDdG?=
 =?utf-8?B?dW9NSFNvbmhuUjlicmpZSGJaeWhCSkRBakdvSHhrbDB3elNEYytRZENpQmNQ?=
 =?utf-8?B?MXE5QTFhbFZHNGpoUkFkdkJMVEZoYlJKOGFtdktodGwzL2tobnUxU1ZHNDl6?=
 =?utf-8?B?QzZiRTlsWFJqTGczSi9YYXNadWYwODh1dVh3VkpaNlBraFZlc1BpZDRobmh3?=
 =?utf-8?B?ZmpwMktGTDFta3JmeWx4SEdrWVdLaStBc3V2Yjl6cDJHZUNRb1c3V0o1djNX?=
 =?utf-8?B?akNvQ1NOUXkwQ1Ywdlh0dFkrVm8zb1ZCVzAwOGVtMEREZGxQdzhxVEdSbSs2?=
 =?utf-8?B?TUU4UFNiaU4wOUFNckJTNzBBcUw3dlBDL2FEVDlURDQ0S2E4UndxblMzWkVM?=
 =?utf-8?B?VFViNVFHaVNtOWk1dTVQMytKOVp0N0YxbW9GY1dndmRvRDNSY25ENlB0ZEUr?=
 =?utf-8?B?cW92MjBNaER4b21OL2hIbW03UjVDaWF4ZGQ4dlVnOTNEdUNoaTFhM1BXbnB4?=
 =?utf-8?B?YUk4VnlOcU1JMVM0Q1ZwUW5UaW1SeEYwSzdGdEV4K3NqbGhSVVdvQXpqdzBN?=
 =?utf-8?Q?fOo8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 674fd20c-c6cb-4d46-93bc-08db11abd491
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2023 12:29:50.6291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xqwbe/xsjwOWGAMk9MDpcuo+yVSn8AmRGaIKF9f3UJ7un6Q0W2TvGITOPF7zQl3u+2k1rehf7yUXBEjShCWCQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6778
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogV2VpIEZhbmcNCj4gU2Vu
dDogMjAyM+W5tDLmnIgxOOaXpSAyMDoyOA0KPiBUbzogJ1JpY2hhcmQgV2VpbmJlcmdlcicgPHJp
Y2hhcmRAbm9kLmF0Pg0KPiBDYzogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsgRGF2aWQg
TGFpZ2h0DQo+IDxEYXZpZC5MYWlnaHRAYWN1bGFiLmNvbT47IG5ldGRldiA8bmV0ZGV2QHZnZXIu
a2VybmVsLm9yZz47IFNoZW53ZWkNCj4gV2FuZyA8c2hlbndlaS53YW5nQG54cC5jb20+OyBDbGFy
ayBXYW5nIDx4aWFvbmluZy53YW5nQG54cC5jb20+Ow0KPiBkbC1saW51eC1pbXggPGxpbnV4LWlt
eEBueHAuY29tPg0KPiBTdWJqZWN0OiBSRTogaGlnaCBsYXRlbmN5IHdpdGggaW14OG1tIGNvbXBh
cmVkIHRvIGlteDZxDQo+IA0KPiANCj4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+
IEZyb206IFJpY2hhcmQgV2VpbmJlcmdlciA8cmljaGFyZEBub2QuYXQ+DQo+ID4gU2VudDogMjAy
M+W5tDLmnIgxOOaXpSAyMDowMw0KPiA+IFRvOiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4N
Cj4gPiBDYzogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsgRGF2aWQgTGFpZ2h0DQo+ID4g
PERhdmlkLkxhaWdodEBhY3VsYWIuY29tPjsgbmV0ZGV2IDxuZXRkZXZAdmdlci5rZXJuZWwub3Jn
PjsgU2hlbndlaQ0KPiA+IFdhbmcgPHNoZW53ZWkud2FuZ0BueHAuY29tPjsgQ2xhcmsgV2FuZyA8
eGlhb25pbmcud2FuZ0BueHAuY29tPjsNCj4gPiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAu
Y29tPg0KPiA+IFN1YmplY3Q6IFJlOiBoaWdoIGxhdGVuY3kgd2l0aCBpbXg4bW0gY29tcGFyZWQg
dG8gaW14NnENCj4gPg0KPiA+IC0tLS0tIFVyc3Byw7xuZ2xpY2hlIE1haWwgLS0tLS0NCj4gPiA+
IFZvbjogIndlaSBmYW5nIiA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gPiA+PiBIbSwgSSB0aG91Z2h0
IG15IHNldHRpbmdzIGFyZSBmaW5lIChJT1cgbm8gY29hbGVzY2luZyBhdCBhbGwpLg0KPiA+ID4+
IENvYWxlc2NlIHBhcmFtZXRlcnMgZm9yIGV0aDA6DQo+ID4gPj4gQWRhcHRpdmUgUlg6IG4vYSAg
VFg6IG4vYQ0KPiA+ID4+IHJ4LXVzZWNzOiAwDQo+ID4gPj4gcngtZnJhbWVzOiAwDQo+ID4gPj4g
dHgtdXNlY3M6IDANCj4gPiA+PiB0eC1mcmFtZXM6IDANCj4gPiA+Pg0KPiA+ID4gVW5mb3J0dW5h
dGVseSwgdGhlIGZlYyBkcml2ZXIgZG9lcyBub3Qgc3VwcG9ydCB0byBzZXQNCj4gPiA+IHJ4LXVz
ZWNzL3J4LWZyYW1lcy90eC11c2Vjcy90eC1mcmFtZXMNCj4gPiA+IHRvIDAgdG8gZGlzYWJsZSBp
bnRlcnJ1cHQgY29hbGVzY2luZy4gMCBpcyBhbiBpbnZhbGlkIHBhcmFtZXRlcnMuIDooDQo+ID4N
Cj4gPiBTbyBzZXR0aW5nIGFsbCB2YWx1ZXMgdG8gMSBpcyB0aGUgbW9zdCAibm8gY29hbGVzY2lu
ZyIgc2V0dGluZyBpIGNhbiBnZXQ/DQo+ID4NCj4gSWYgeW91IHVzZSB0aGUgZXRodG9vbCBjbWQs
IHRoZSBtaW5pbXVtIGNhbiBvbmx5IGJlIHNldCB0byAxLg0KPiBCdXQgeW91IGNhbiBzZXQgdGhl
IGNvYWxlc2NpbmcgcmVnaXN0ZXJzIGRpcmVjdGx5IG9uIHlvdXIgY29uc29sZSwNCj4gRU5FVF9S
WElDbltJQ0VOXSAoYWRkcjogYmFzZSArIEYwaCBvZmZzZXQgKyAoNGQgw5cgbikgd2hlcmUgbj0w
LDEsMikgYW5kDQo+IEVORVRfVFhJQ25bSUNFTl0gKGFkZHI6IGJhc2UgKyAxMDBoIG9mZnNldCAr
ICg0ZCDDlyBuKSwgd2hlcmUgbj0wZCB0byAyZCkNCj4gc2V0IHRoZSBJQ0VOIGJpdCAoYml0IDMx
KSB0byAwOg0KPiAwIGRpc2FibGUgSW50ZXJydXB0IGNvYWxlc2NpbmcuDQo+IDEgZGlzYWJsZSBJ
bnRlcnJ1cHQgY29hbGVzY2luZy4NCnNvcnJ5LCBjb3JyZWN0IG15IHR5cG8uIA0KMSBlbmFibGUg
SW50ZXJydXB0IGNvYWxlc2NpbmcuDQoNCj4gb3IgbW9kaWZ5IHlvdSBmZWMgZHJpdmVyLCBidXQg
cmVtZW1iZXIsIHRoZSBpbnRlcnJ1cHQgY29hbGVzY2luZyBmZWF0dXJlDQo+IGNhbiBvbmx5IGJl
IGRpc2FibGUgYnkgc2V0dGluZyB0aGUgSUNFTiBiaXQgdG8gMCwgZG8gbm90IHNldCB0aGUgdHgv
cngNCj4gdXNlY3MvZnJhbWVzDQo+IHRvIDAuDQo+IA0KPiA+ID4+DQo+ID4gPj4gQnV0IEkgbm90
aWNlZCBzb21ldGhpbmcgaW50ZXJlc3RpbmcgdGhpcyBtb3JuaW5nLiBXaGVuIEkgc2V0DQo+ID4g
Pj4gcngtdXNlY3MsIHR4LXVzZWNzLCByeC1mcmFtZXMgYW5kIHR4LWZyYW1lcyB0byAxLCAqc29t
ZXRpbWVzKiB0aGUgUlRUIGlzDQo+ID4gZ29vZC4NCj4gPiA+Pg0KPiA+ID4+IFBJTkcgMTkyLjE2
OC4wLjUyICgxOTIuMTY4LjAuNTIpIDU2KDg0KSBieXRlcyBvZiBkYXRhLg0KPiA+ID4+IDY0IGJ5
dGVzIGZyb20gMTkyLjE2OC4wLjUyOiBpY21wX3NlcT0xIHR0bD02NCB0aW1lPTAuNzMwIG1zDQo+
ID4gPj4gNjQgYnl0ZXMgZnJvbSAxOTIuMTY4LjAuNTI6IGljbXBfc2VxPTIgdHRsPTY0IHRpbWU9
MC4zNTYgbXMNCj4gPiA+PiA2NCBieXRlcyBmcm9tIDE5Mi4xNjguMC41MjogaWNtcF9zZXE9MyB0
dGw9NjQgdGltZT0wLjMwMyBtcw0KPiA+ID4+IDY0IGJ5dGVzIGZyb20gMTkyLjE2OC4wLjUyOiBp
Y21wX3NlcT00IHR0bD02NCB0aW1lPTIuMjIgbXMNCj4gPiA+PiA2NCBieXRlcyBmcm9tIDE5Mi4x
NjguMC41MjogaWNtcF9zZXE9NSB0dGw9NjQgdGltZT0yLjU0IG1zDQo+ID4gPj4gNjQgYnl0ZXMg
ZnJvbSAxOTIuMTY4LjAuNTI6IGljbXBfc2VxPTYgdHRsPTY0IHRpbWU9MC4zNTQgbXMNCj4gPiA+
PiA2NCBieXRlcyBmcm9tIDE5Mi4xNjguMC41MjogaWNtcF9zZXE9NyB0dGw9NjQgdGltZT0yLjIy
IG1zDQo+ID4gPj4gNjQgYnl0ZXMgZnJvbSAxOTIuMTY4LjAuNTI6IGljbXBfc2VxPTggdHRsPTY0
IHRpbWU9Mi41NCBtcw0KPiA+ID4+IDY0IGJ5dGVzIGZyb20gMTkyLjE2OC4wLjUyOiBpY21wX3Nl
cT05IHR0bD02NCB0aW1lPTIuNTMgbXMNCj4gPiA+Pg0KPiA+ID4+IFNvIGNvYWxlc2NpbmcgcGxh
eXMgYSByb2xlIGJ1dCBpdCBsb29rcyBsaWtlIHRoZSBldGhlcm5ldCBjb250cm9sbGVyDQo+ID4g
Pj4gZG9lcyBub3QgYWx3YXlzIG9iZXkgbXkgc2V0dGluZ3MuDQo+ID4gPj4gSSBkaWRuJ3QgbG9v
ayBpbnRvIHRoZSBjb25maWd1cmVkIHJlZ2lzdGVycyBzbyBmYXIsIG1heWJlIGV0aHRvb2wNCj4g
PiA+PiBkb2VzIG5vdCBzZXQgdGhlbSBjb3JyZWN0bHkuDQo+ID4gPj4NCj4gPiA+IEl0IGxvb2sg
YSBiaXQgd2VpcmQuIEkgZGlkIHRoZSBzYW1lIHNldHRpbmcgd2l0aCBteSBpLk1YOFVMUCBhbmQN
Cj4gPiA+IGRpZG4ndCBoYXZlIHRoaXMgaXNzdWUuIEknbSBub3Qgc3VyZSB3aGV0aGVyIHlvdSBu
ZXR3b3JrIGlzIHN0YWJsZSBvcg0KPiA+ID4gbmV0d29yayBub2RlIGRldmljZXMgYWxzbyBlbmFi
bGUgaW50ZXJydXB0IGNvYWxlc2NpbmcgYW5kIHRoZSByZWxldmFudA0KPiA+ID4gcGFyYW1ldGVy
cyBhcmUgc2V0IHRvIGEgYml0IGhpZ2guDQo+ID4NCj4gPiBJJ20gcHJldHR5IHN1cmUgbXkgbmV0
d29yayBpcyBnb29kLCBJJ3ZlIHRlc3RlZCBhbHNvIGRpZmZlcmVudCBsb2NhdGlvbnMuDQo+ID4g
QW5kIGFzIEkgc2FpZCwgd2l0aCB0aGUgaW14NnEgb24gdGhlIHZlcnkgc2FtZSBuZXR3b3JrIGV2
ZXJ5dGhpbmcgd29ya3MgYXMNCj4gPiBleHBlY3RlZC4NCj4gPg0KPiA+IFNvLCB3aXRoIHJ4LXVz
ZWNzL3J4LWZyYW1lcy90eC11c2Vjcy90eC1mcmFtZXMgc2V0IHRvIDEsIHlvdSBzZWUgYSBSVFQg
c21hbGxlcg0KPiA+IHRoYW4gMW1zPw0KPiA+DQo+IFllcywgYnV0IG15IHBsYXRmb3JtIGlzIGku
TVg4VUxQIG5vdCBpLk1YOE1NLCBJJ2xsIGNoZWNrIGkuTVg4TU0gbmV4dA0KPiBNb25kYXkuDQo=
