Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12258598241
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244090AbiHRL2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244054AbiHRL2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:28:52 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2123.outbound.protection.outlook.com [40.107.105.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE992F677
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 04:28:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFG58GUdUcoi9iCc2bpMsQ4zkDaywRs1AgQlYtvnJ6Yp99StjI6DQLHum8ff3o7ddjn08dpagTM3bywOk/s3dUdLMeKDG6TFN2Qp+GFcp+64Y0T/cNuvzHbIt2dF5Rzo//3dEvMfu0x92yAQaDlamBHytO+l0oTMuGnFzdkh5kQ+f5nSxgZsgCS9AWWMAAwFDszdBn1lrVuK/L7qEBiZlv7qJ01MKrkowMI3ivwPDnAVvYIiGPOekcEsx1yZL85saSZHzfIKa7t5lX+zfsphxh/heuL5EVeOFee+62SN37xUPncLhL/W8iXwRhvMWfCD+Id1r+KgsUq4BgkWA8FZmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LH1KDSm8PUMK9gUrG3eoCjbShaN5/FvLxIkYc79mzJ8=;
 b=VuAwp+tuYWYtiFJ9c7WJiXKaynghVgdBoZEiJ8Fetwd5y7kPYsQkemQ/PzPP0RujlgM7wgqNGVLlAOXtThO9TywvxbkmiIdpmpIzUhCiSB4hlt/J6P6I1ULP92sseW2GXD6d/53V0JWx+HwTaztAIdvgK6Q2IK5WnLKmo/G3khBcCwSvCWJuh0G8/t1DYwwFj2zl0O7KJmjJxjC907U/CaI8yprLFCYgSnrfjuHXiTgyIhPc5tW1B47OWtb1U33YDt6BANb7V4XNuGgIHIKswwvDOzoMlD8cEpmz8NQ5huZWhbHXosxZ4lw2AleeaSDibJjILqEImivNh3DnvgktRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LH1KDSm8PUMK9gUrG3eoCjbShaN5/FvLxIkYc79mzJ8=;
 b=go311cHJhkn0iJBbZ3qYHw0a1je95Q2g0ou1A4J/RUCFDIJ19KTBUXAXsMYyJisyzGcWwGB02fhcGhJuJ+94TttGw7bZZmp+iPa8vrp27blMuFZmF0CY68hpj877/92KUJSuCfxPo7k+hDOxPVXBHZ6IeIi0krOONyPDH+76+oo=
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com (2603:10a6:803:75::30)
 by VI1PR0302MB2654.eurprd03.prod.outlook.com (2603:10a6:800:e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 11:28:46 +0000
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::3965:8efc:7af6:756e]) by VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::3965:8efc:7af6:756e%7]) with mapi id 15.20.5482.016; Thu, 18 Aug 2022
 11:28:46 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
CC:     Network Development <netdev@vger.kernel.org>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: commit 65ac79e181 breaks our ksz9567
Thread-Topic: commit 65ac79e181 breaks our ksz9567
Thread-Index: AQHYsvWuA4J1de3I8Ee4/96kVwe/EQ==
Date:   Thu, 18 Aug 2022 11:28:46 +0000
Message-ID: <20220818112846.ghhiqody2lwuznci@bang-olufsen.dk>
References: <408851bb-5245-7a10-3335-c475d4d1ca0f@prevas.dk>
In-Reply-To: <408851bb-5245-7a10-3335-c475d4d1ca0f@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9d58918-31e7-4d3b-8a71-08da810cd098
x-ms-traffictypediagnostic: VI1PR0302MB2654:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VQ7hrJtf7rfA2do35K2mdCEMfOFx9Zp8yisnby9oCoDdaoe/D+b71GvLtstubRxk0gSuVrJRgIWYEB2xmH2y8ZzfkQblBZ/iNmZXI3hwX0p0wMxF/Rv1Rxb90qFR5mBCSAyVkIjNKjiRr0FbW1hpQBn7NpsNTbM1jsTz32fNYuT934CqO3MZkVPJiysmv3rYuvNi3KWPvKdEbHiqi93HyUSbBzOxLuhDG+TADdj7PdZjGrOmCndokZb6+D7e2vDlXSJkXjw7ZkHnTmx2KTVSrDDfgyxyf1uBPD4lmzmN+QkSCSQkURd0ab3oXK/2I60MEAgRqEmwbToTIvVkhQqrthIlKoXPBDtDrnOodVQ8GppFIjR17sRfyHkyC7Z9rR1CCg+x6ylE82Uy0uvzUfzmWVIZpHbq+m9QV0iplA3oSmna78Gw4XRWEVgJ6mX9BNA/th3EP/nS3lFk6zh/qcP75a4qdGtSvYiWNP9Le+YmsqT8mm80UDQ3swzgmnDxBaP2j0P3k91fJSADX5bYBw+d4TPx35W1g9lth3M9BaVd0YXGHdRZdlfexYPatCw2wUCDZEbxy12HKUgnBH0oqoTlXaVzBR8d7u4OggiojS+yQyzZFMzrHYD9iTTpHY1aURbgPr86tvopcoIQuI6H2yhuKolc79+wCq3fCioNQhAt+joBJc9bmvsjo0ls68Bg9/j9UzZ/QSIJdHc84YQU6TqbpcNQl8sy/rePRAMgVAdjRJsO3AyvkFrA/csOendShfPNOqzxoj4SUDxOsxoGtr+tLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3950.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(366004)(346002)(39850400004)(396003)(85182001)(36756003)(38100700002)(2906002)(86362001)(316002)(71200400001)(122000001)(6916009)(54906003)(85202003)(26005)(91956017)(8676002)(4326008)(186003)(1076003)(5660300002)(6486002)(6506007)(66946007)(76116006)(2616005)(66476007)(66556008)(66446008)(64756008)(38070700005)(478600001)(6512007)(8936002)(8976002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmIxaHBKV1g0ejRkdjlvdGdIK3dqZStCcUFzZVFEenphTkpnRUxWNXZrTFg3?=
 =?utf-8?B?amhvQTI5SU91ejJZN0NvNEN2WXZpZ2pUTmxwN3lLSldXSnhaWHdJWkdZWmYr?=
 =?utf-8?B?a2ZNd1hrSDFaajBWcGlVQ0JQTjBqcC8xWlQvbzJKOXRpREQwUVhWSEF3VUM3?=
 =?utf-8?B?NTk3VnNyUmFkdGhMZ0lLWTM1V3pEZ0VjL1k4cnNBb3JveVJ5N3RWa3NVeXZt?=
 =?utf-8?B?VkJIOFRIY2FWdGQyZG5TMG9mbUQ1Y091WEFpRTEyNDU5QUpyY0xUbmp2Vkxm?=
 =?utf-8?B?eU5JemJ0dE9IaWh5Q3hEY0VsVThzTmMzejk3bDkxMDFyWVZzWFg3cjF5QWk3?=
 =?utf-8?B?VktZZXBQVnBkTHlZUG90WEhRTURqVC9qL1ZlTm8veE9mMmNTS29yRm8zamlz?=
 =?utf-8?B?enJCVExtbEpNa2lZMDdrZGJsR2FqY21XY2NwaTFabzk4VW81Z1ZTS092ajNE?=
 =?utf-8?B?MTFVdFVwOUk5b2N5MjBCMXpDTUwxT0YyS0hGRFA0OHZqWmxCMjJvbkNPOHd1?=
 =?utf-8?B?SnFkYWZ3aU43aW0ra2d1RHFpcjJJczRPQWtVR2d3RXpIYjJFbEVLRHZPQXZj?=
 =?utf-8?B?dmM0eXdrVXI1VDBnQ2hCMnJZS0hKazNzMXJvd2t4V0RTZnhMTENLOFRTVXFm?=
 =?utf-8?B?RTBtWkRtREJ3S2xyRzdOUVFJdnVmMzhYQWlJT1NsOUM0Q0tac2NoendOT0Vr?=
 =?utf-8?B?amNRTWxsWUlxaG1kM09MbDNtSVZmYWtveGlsMS9PdE9kNHhoL0Mzb0Evc1ZL?=
 =?utf-8?B?ZTdpWGxpZWd4T0xMbEJKcEJ5V085bUhZbXAyWGRWSlA4QmVod3JRbzVtTW01?=
 =?utf-8?B?OTBqSmhzdnV2OU14VEl3SEZKdFFqZ01veExsSVE0TUVLNHJabFdKMUVkQmMv?=
 =?utf-8?B?UUZvR25uemlFcm1rRXpoT3pNeUhTbkVSbm5oajFTWU9CK1h6bEc1MGZJZmNN?=
 =?utf-8?B?Vjhid0prbUZGaXY3cTliYzVUczRhUjdaN3NQL3gzSlEzWGFHWmNZV28rRlV6?=
 =?utf-8?B?MHlPVmlxeEU5MlZKUmZ5RjI3SUZJbDdENlh0cVRPcDY3VkwxZlBQRm4rQU1I?=
 =?utf-8?B?Y29zQ3ZwSlgvMW1idmJMcmhBdEZtaytTZDBsY1VvUzYzS0Yvc3JscmF1c2RG?=
 =?utf-8?B?Q0hHMGxmcWFkUlNvTSt0VzdGNEc0STR0TEVVUnlrMnVNTEdua2hYOTFjbFBu?=
 =?utf-8?B?cnBrTURQbisxZDU3SzRJcXV3R1ZwbVkzQTBLdkswM0k0WlZwV0xUVWlqZG1q?=
 =?utf-8?B?QXNIQTduZHpJai9HclBiYXZmbVVxVUMyNTZyb2gxU09EL3JuMlVNL2pMek9y?=
 =?utf-8?B?MDFVME9CeDNFUmRDdE1DK2tEaFRUWmVUaUdHYVFVbEhxWWY2STlabEdvSFBo?=
 =?utf-8?B?WGFTcjVUYzhVSDRLay9FV1J6eXNFZUNJQ0JDaDN3aVFPUHNwdmNMVlFKdXlN?=
 =?utf-8?B?R0lxWTFRZE1TRXdhR1U2L3JRbU9JdzNOZW9RRHlHYTFJdTJuMWJFVTdrM2Ur?=
 =?utf-8?B?bnlNUHBSUk84a3g5ZFQwK0JsWWVCanA2elZldGVtNWFibXVpNzhDZ0VzMWFW?=
 =?utf-8?B?bEFpbGtNMk1Zc05yR0VYbXAvNlZMT2lxeElnRHBTSnBLMGxqeTFINGo3dG5t?=
 =?utf-8?B?NjJORi9PKyt2b1hHZHVEMGJNZHVyd3NsVWhDUEpzQ1hvQkVOR1ZhUm9mMkp4?=
 =?utf-8?B?Y2RoenNRcURvdFZ1STRzZnZMeS92NmpUUW5WQnRuMW43TjJGT0NaNXdwbTZl?=
 =?utf-8?B?Z2g5UTJ5bFJSWEsxcjFiRGVOUERQN0tsWG1TcXZHTmVIeVEyR01LYjJ6Q1dQ?=
 =?utf-8?B?MElSVmtWK3hiR1pqUGFGOS9UQ2RUcDZMMUl3NVAxZU5kdXRwNDZRb0M5d0tI?=
 =?utf-8?B?dlA0U1F1SS81VUhKODNtZkVWbzhzTXd4NDRRMUtwRzlqcEIvQWlWRXd0aXho?=
 =?utf-8?B?Nm43R21LdGtmSzdpSnRpdCthVzY0bURINHBIQStUbUFOS2I3WENPQVFMeU9B?=
 =?utf-8?B?d1hEWGdzd3lEeXZVdWNDSTlNNCtPNmVPM1J3REdYbEtRdDU3TzVYZlpNeHVH?=
 =?utf-8?B?dVd4bGJUU1B0VFdXcEJtUTgvL0VPaUxXMWZHTTdPY2dNd1ZTOVVVV21jbTd6?=
 =?utf-8?B?MVVuTUNuNHdZTG84dUhremh5ZGtHLzYyaW5zSUFWYWE2MjAxZlF1Z2lFeEpT?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4CFBE2EBA078BF44A772CD20ACACCBEA@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3950.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d58918-31e7-4d3b-8a71-08da810cd098
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 11:28:46.4970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1GwmtdbQReUts33M3SzLvUF6vMEXPU+BCt0fGFd0MC1z8SU2083fUHPM/OjITZtzOJGXnInMirli7ciB/E8Xmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2654
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmFzbXVzLA0KDQpPbiBUaHUsIEF1ZyAxOCwgMjAyMiBhdCAwMTowMzoxM1BNICswMjAwLCBS
YXNtdXMgVmlsbGVtb2VzIHdyb3RlOg0KPiBXZSBoYXZlIGEgYm9hcmQgaW4gZGV2ZWxvcG1lbnQg
d2hpY2ggaW5jbHVkZXMgYSBrc3o5NTY3IHN3aXRjaCwgd2hvc2UNCj4gY3B1IHBvcnQgaXMgY29u
bmVjdGVkIHRvIGEgbGFuNzgwMSB1c2IgY2hpcC4gVGhpcyB3b3JrcyBmaW5lIHVwIHVudGlsDQo+
IDUuMTgsIGJ1dCBpcyBicm9rZW4gaW4gNS4xOS4gVGhlIGtlcm5lbCBsb2cgY29udGFpbnMNCj4g
DQo+ICBrc3o5NDc3LXN3aXRjaCA0LTAwNWYgbGFuMSAodW5pbml0aWFsaXplZCk6IHZhbGlkYXRp
b24gb2YgZ21paSB3aXRoDQo+IHN1cHBvcnQgMDAwMDAwMDAsMDAwMDAwMDAsMDAwMDYyZmYgYW5k
IGFkdmVydGlzZW1lbnQNCj4gMDAwMDAwMDAsMDAwMDAwMDAsMDAwMDYyZmYgZmFpbGVkOiAtRUlO
VkFMDQo+ICBrc3o5NDc3LXN3aXRjaCA0LTAwNWYgbGFuMSAodW5pbml0aWFsaXplZCk6IGZhaWxl
ZCB0byBjb25uZWN0IHRvIFBIWToNCj4gLUVJTlZBTA0KPiAga3N6OTQ3Ny1zd2l0Y2ggNC0wMDVm
IGxhbjEgKHVuaW5pdGlhbGl6ZWQpOiBlcnJvciAtMjIgc2V0dGluZyB1cCBQSFkNCj4gZm9yIHRy
ZWUgMCwgc3dpdGNoIDAsIHBvcnQgMA0KPiANCj4gYW5kIHNpbWlsYXIgbGluZXMgZm9yIHRoZSBv
dGhlciBmb3VyIHBvcnRzLg0KDQpJIHRoaW5rIHRoaXMgaXMgYmVjYXVzZSB0aGUgcGh5bGlua19n
ZXRfY2FwcyBjYWxsYmFjayBkb2VzIG5vdCBzZXQNClBIWV9JTlRFUkZBQ0VfTU9ERV9HTUlJIGZv
ciBwb3J0cyB3aXRoIGludGVncmF0ZWQgUEhZLCB3aGljaCBpcyB0aGUNCmRlZmF1bHQgaW50ZXJm
YWNlIG1vZGUgZm9yIHBoeWxpYi4NCg0KWW91IGNhbiB0cnkgdGhpcyBhbmQgc2VlIGlmIGl0IHdv
cmtzIChub3QgZXZlbiBjb21waWxlIHRlc3RlZCk6DQoNCi0tLQ0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jIGIvZHJpdmVycy9uZXQvZHNhL21pY3Jv
Y2hpcC9rc3pfY29tbW9uLmMNCmluZGV4IDkyYTUwMGUxY2NkMi4uMGQ4MDQ0ZjJiZDM4IDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCisrKyBiL2Ry
aXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQpAQCAtNDUzLDkgKzQ1MywxNiBA
QCB2b2lkIGtzel9waHlsaW5rX2dldF9jYXBzKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBv
cnQsDQogICAgICAgIGlmIChkZXYtPmluZm8tPnN1cHBvcnRzX3JnbWlpW3BvcnRdKQ0KICAgICAg
ICAgICAgICAgIHBoeV9pbnRlcmZhY2Vfc2V0X3JnbWlpKGNvbmZpZy0+c3VwcG9ydGVkX2ludGVy
ZmFjZXMpOw0KIA0KLSAgICAgICBpZiAoZGV2LT5pbmZvLT5pbnRlcm5hbF9waHlbcG9ydF0pDQor
ICAgICAgIGlmIChkZXYtPmluZm8tPmludGVybmFsX3BoeVtwb3J0XSkgew0KICAgICAgICAgICAg
ICAgIF9fc2V0X2JpdChQSFlfSU5URVJGQUNFX01PREVfSU5URVJOQUwsDQogICAgICAgICAgICAg
ICAgICAgICAgICAgIGNvbmZpZy0+c3VwcG9ydGVkX2ludGVyZmFjZXMpOw0KKw0KKyAgICAgICAg
ICAgICAgIC8qIEdNSUkgaXMgdGhlIGRlZmF1bHQgaW50ZXJmYWNlIG1vZGUgZm9yIHBoeWxpYiwg
c28NCisgICAgICAgICAgICAgICAgKiB3ZSBoYXZlIHRvIHN1cHBvcnQgaXQgZm9yIHBvcnRzIHdp
dGggaW50ZWdyYXRlZCBQSFkuDQorICAgICAgICAgICAgICAgICovDQorICAgICAgICAgICAgICAg
X19zZXRfYml0KFBIWV9JTlRFUkZBQ0VfTU9ERV9HTUlJLA0KKyAgICAgICAgICAgICAgICAgICAg
ICAgICBjb25maWctPnN1cHBvcnRlZF9pbnRlcmZhY2VzKTsNCisgICAgICAgfQ0KIH0NCiBFWFBP
UlRfU1lNQk9MX0dQTChrc3pfcGh5bGlua19nZXRfY2Fwcyk7
