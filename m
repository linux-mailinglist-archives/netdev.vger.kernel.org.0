Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795F65B7E44
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 03:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiINB00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 21:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiINB0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 21:26:24 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60055.outbound.protection.outlook.com [40.107.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A62A6B666;
        Tue, 13 Sep 2022 18:26:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKPYupNTujNkpU9RMiewnanP87q2lCfs7GCLIwMT64wsSIK919LxNNpBxaJy6HwfHy4+M2i4O05YhX1SC+i89jS4140KC//Hx2Zy1Rgj7TzOPSkxkLwnUj67RSZOTyKRFovXtyJ+arVZpZBtSEgHNzGv93CzzEQBT0jGsRdETXcN4zTsQZI1VjNXbOfoUeQ/gt8+I4IMo71SgLKHHIG3G91fv5uIzpYUYND9q4ud2iU0vqWJOofjZBmPz1aFqc4drLaqypU41FwO53LUbA57XQP1nV1xwn+yP1XR4CcLaC0hRUaaEcMc6r/i/0rdyjj8Ig97I5N6nbk+WUjKgcbbpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCQycXzTMLVHXCDYFlcn7gZwDuoJDgYD9iovbUF3X5w=;
 b=Y81LVnExD/mpAG3HdgWJipHT13mP1c8JPqxyl/12I7/SxLlZManxveq3JVeYmBdeZBq3lRlTiqYSeEpqVKcadcFGscr4spyBtNgWcVYXHD6ZgDaSjH/mMb80N0+oJQYEy923yHj4/6m/fPHoEjiYuPHd9NOqq/Sa7A+dVbdq8+uW1kV6ClBV0cwXbPl2X8DUF/vkNylQCuDccEapDOj7d5WHOSR7J84Vee+Oyo1BNZYCc6AnDVngoFaiUe/87lULp+QmkuN+5OuNtyefRFYRrS7Kc23cZMGQTUAGrK1EMLKVVJtMVg2bGNhzP3zpXr6v2Oln96HCfEEpSPZSxOrVgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCQycXzTMLVHXCDYFlcn7gZwDuoJDgYD9iovbUF3X5w=;
 b=OkDroOOv1Xg06x2FyXFE++9qtjoSqvVOPjg9/qcdo635/kklQ8UJ7QN2eAjeoCnybNB7z9LILhYK1pRRG9hXgzCSsQ/1dDlVc2r+GUUcnOpRkvZGlX81OInpKLoXsyTNnV0Z39d7Gm5ePmOjQ9HgtRIRFvuf4Wgbfw5nNfGYKoU=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR04MB7135.eurprd04.prod.outlook.com (2603:10a6:800:12c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 01:26:15 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::4ba:5b1c:4830:113d]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::4ba:5b1c:4830:113d%6]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 01:26:15 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] net: fec: Add initial s32v234 support
Thread-Topic: [PATCH net-next 2/2] net: fec: Add initial s32v234 support
Thread-Index: AQHYwqA7zQO5ZwJyUECaIoSDadRmWK3eLKBw
Date:   Wed, 14 Sep 2022 01:26:14 +0000
Message-ID: <DB9PR04MB8106313766A2883367E84B1A88469@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220907095649.3101484-1-wei.fang@nxp.com>
 <20220907095649.3101484-3-wei.fang@nxp.com>
In-Reply-To: <20220907095649.3101484-3-wei.fang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|VI1PR04MB7135:EE_
x-ms-office365-filtering-correlation-id: 46758674-8894-4bf5-62cc-08da95f01dc6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PoGH4ILMJYhnOtawkIolVlrp3wcBVAtF/sFJFy6PRhoOB+L4WsAbRbKL9MwjqB8/QWAoIxMwBLH7vtQw6f0ko4aE03XY8P1GnM8sO4/aK1i9DGL+003TXgUSXjJCYDyrHowowA/bVF7rRqjh9QBg1h48UC5aRB70kHCJnooPVZeQ59XzD9mxB9xjzvQ3bY1RZLuDkTwKCiWJD5Hb80g058KVmBAOSsa1saol032npr0svZ3sdCTaZg/K2c6IkTAi5gtjne8PDc6M5Uxia0hiXfRZSFND7NhK6QJiVcWSbCUlR6lWFXvVv1Hfm1K0yo601R3itfHHWgKheZVJm+NxR3MtdnItf2OzzL15H2k/LlXQrGNuYRWOdl48gPIaryNvtD00+cLJr2JrTWgE1sUOt74NjVVl4pCmoWjVU3NASc1OSGIkZO7JjYFRPDl52Ml9wuUIdlIotoPJ4/t0AdwF90mLqBbZrZEWhQRI2E6kDMSuKiEqHMqRsS4C2dfbjiuSdL3Xsgch/pXV/T8Xthk9DtQlBP9VHNKkbSfbwRPub+4zW7rngLYIXbziVNEjroO64bLSCstLwqfHqoERij1GmLQKVP66nATX1qcCBrF87TlXhhX2UvL8rKvZXV8ZXbI0RwXEXVh+VD+8osauqKRMxdkZYFQZi73d8BW6pmEabCylvEribkSFD0IZc7Z68Aoy8q4lwidpd4t4PeUXvge8VXtkty0quRA0SL3AvV+Tphoj53axZxv/dYPFyT6siH3G2CaD0x7kX6/dvL6rzUgy3LPMAd0oGVrqED1O642J0TM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199015)(66476007)(316002)(55016003)(41300700001)(66946007)(26005)(76116006)(64756008)(66446008)(44832011)(8936002)(53546011)(52536014)(478600001)(110136005)(86362001)(122000001)(5660300002)(33656002)(84970400001)(38070700005)(66556008)(8676002)(38100700002)(186003)(2906002)(71200400001)(6506007)(83380400001)(7696005)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?dTB0MFB6dnN6c3FVTkl6cnRad3ZvSUJjZW5PMEFXM3B0Q1FmWjVBNGZsMGRD?=
 =?gb2312?B?aGZNdytXaGNnckVXQU1wbUF0cnVBU0dHRktGZ2ozN3J2aDArdG9taWdmNGRD?=
 =?gb2312?B?VHZRVG9kcE05NnhmZzdPQ3hqSmtYMzZFOFdUNWdHbmExL3BRcmlhczd5UW1V?=
 =?gb2312?B?ZUMzNkl2dlB4eC9VOUwvUm1uRVRPWHNQQndISUZNdDYySWlodGl0M0ZrNXp3?=
 =?gb2312?B?RmFrcXFFdHlGRzVVYi83K3Z2TVZnRkNNRVl4dWlBd1d2dzdBT1lDcjBUQjI1?=
 =?gb2312?B?U2xjdWNOb2V5N3RHMzVLTjdNU0dBK3F5aHByc3NIVGRiWWVoV1lNbDNHMnZI?=
 =?gb2312?B?WnMvY3ZFTk9HN2JNdzJKeHB6dC85RU9YcEhkU1E1ZjlXT0F2cjhuTTgwZ2Z3?=
 =?gb2312?B?WkMwdDE1WTdHQlByMTN2QWxtdFZuQkxFL2FVNk9yK0p2NDk2NzZ6Nk4wNmgw?=
 =?gb2312?B?WFFqQmdLb2NIbjRWbnlVRjhYc1RWYmZKYk5GczlTbXowRTFSSUV5VHlnZ3dq?=
 =?gb2312?B?ZC9zV3ovSVhqN1h4d1VJSmZCdi9OeVJMbnY2NENJRU8vYkcyTGtQM3BMMXJ2?=
 =?gb2312?B?Nkw2azlENitjZHlwUEtMTlJqVWJycTN5dnBTN3g5d21QMUZlY05WcnZMN3Fw?=
 =?gb2312?B?ZG04Z25VUzBEYWNPSE9HNTVOaUF5ME5DRXhvRGxMYXgzWjR3UmlYaXNNUklB?=
 =?gb2312?B?Rm5XckVRVWdGbTU2NGRNTkJHNFlyeHg1YUh2Smo0K2ljb3YwNXFyU2NpVTlY?=
 =?gb2312?B?OFRKOS9lMGdxTlVGbk1WV1NFYkpsRTFEbEFnY2lvZFprdFlWN3ArTU1SaFRt?=
 =?gb2312?B?VnBZQ1ZmT0pPY2dsd3V0VHBCZVVkS29mMDB5bG16ajgrdG5LWW5xYWQ4YWdD?=
 =?gb2312?B?aGdsdk44Vk1aN2xRVnd0cmpEb1NKeXlQZnJEb3FMUXJSdkovd3p2by9ob2Qr?=
 =?gb2312?B?eFFndk1XOEE0Ti9aTmhWbTFSR0taTVhXVTZxSldoRm8wS0VXWmZCcTRsQ29B?=
 =?gb2312?B?SXJrM3ljRm5JQzNMc3o0Rkk2VDlDeDJ0amV4OExMdUdtZlhWajBQT2U0L0xi?=
 =?gb2312?B?VnZVTDAvakUxM1JRcjdWMUxkT2dLNVVhamM1bTdUTHpmbCtEUFNILzlBc3hu?=
 =?gb2312?B?Mlk0TUUxb1prSUl2c0R6b2k5UFNpc3JOazhTM29QKzQ2WVlMeXlQYUt0ZUE4?=
 =?gb2312?B?eEpMRnlMKzAxbHVXVXNZVGVDSTFtVUNRbkR5Ni8xOXlVTWZiZzdPWHhLbFBo?=
 =?gb2312?B?OGxnc3hTTGRweGRKbUFZQkV4eFFzcm9lQUJOSEhGN1ZwdEd3enhJVVBFSWox?=
 =?gb2312?B?K2pFUmVCVDQ1Y2xDMmk2NnlNd0RONlJiVW9KU0QxQ25XeE1BMUkvSTJVOG1v?=
 =?gb2312?B?SjNROGt3TG5HSlZqM1pjODYyNHpCTnhuMXJpVUNUNHArTFllTjdCYnViNkxM?=
 =?gb2312?B?RkhCZVBHT3dXeml5cnVFcHE3NGtNYW82ZWtuaXZiUUpNWkhFRE9HWlkvM1NK?=
 =?gb2312?B?alpLMFhBRndsNGlqS0JOTFlGR213TFFYVU0wQ1RBenJ4RmZjaDRCWU9RSnhO?=
 =?gb2312?B?RVUrRVlVby9SbHBJQmF1VDFjS3F2MkNpSjBhZUdxNEsvTkJ1cFR4WUZUWHEz?=
 =?gb2312?B?VWdVK2tUaDUwNWVwdUF2SXk1MXNjRTlVQ1FkbXlNS29KTkNoakNrUTNOZzVj?=
 =?gb2312?B?Um1tMFl1UG1FWk5HdHhzb3VPMTRYcU9xTjlqUWt4TFhvVDVQWWJpNVBnWTlW?=
 =?gb2312?B?UGRRak45UkRTeTRKMjcyVk9MRUxvQ2hzN1lJejk1R2VMYzZiRjRRblFQckhw?=
 =?gb2312?B?bktST1dWclZMYmJDVElTNmhSQ2RtbGJxQmpDSWlmcGZET2kwbFIvUEVKUHNP?=
 =?gb2312?B?NlJxM01EaHRGQklVUFRXRGdkKzNxMEQyNlRWanFvVTY4N3Rja1hDVWpzdDVP?=
 =?gb2312?B?aEVaZ0lNNFpmMFZ4aW96RktYQmxQa0tILzRuT09jL1FKNVRIU2poK0FGM3Zw?=
 =?gb2312?B?Y2RPbXNVNmI5Qlpxay85WXcvR1Y1SGc4bmdhRHBEMHloQ3ArRVJCMlQzb3ZZ?=
 =?gb2312?B?QlMyRzhDcWpWcWZ3bXIyRlJRQUdMR1Z5VDhuTDVJMTR2TkovMGZzTTBHUlNm?=
 =?gb2312?Q?TN7I=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46758674-8894-4bf5-62cc-08da95f01dc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 01:26:15.0421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JzmjW++yqF9PP7r1lABsCvKAP4Wp5GBfviPbSgtyKgfrlqVHS6yoeqmHpab64u5/un9qmp3twc7HbbMQi50Eew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7135
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

S2luZGx5IFBpbmcuLi4NCg0KQmVzdCBSZWdhcmRzLA0KV2VpIEZhbmcNCg0KPiAtLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBXZWkgRmFuZw0KPiBTZW50OiAyMDIyxOo51MI3yNUg
MTc6NTcNCj4gVG86IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207IGt1
YmFAa2VybmVsLm9yZzsNCj4gcGFiZW5pQHJlZGhhdC5jb207IHJvYmgrZHRAa2VybmVsLm9yZzsg
a3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5leHQgMi8yXSBuZXQ6IGZlYzogQWRkIGlu
aXRpYWwgczMydjIzNCBzdXBwb3J0DQo+IA0KPiBGcm9tOiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhw
LmNvbT4NCj4gDQo+IFVwZGF0ZSBLY29uZmlnIHRvIGFsc28gY2hlY2sgZm9yIEFSQ0hfUzMyLg0K
PiBBZGQgY29tcGF0aWJsZSBzdHJpbmcgYW5kIHF1aXJrcyBmb3IgZnNsLHMzMnYyMzQNCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiAtLS0NCj4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9LY29uZmlnICAgIHwgIDYgKysrLS0tDQo+ICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYyB8IDEyICsrKysrKysrKysr
Kw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9LY29uZmln
DQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL0tjb25maWcNCj4gaW5kZXggZTA0
ZTFjNWNiMDEzLi5iN2JmNDVjZWMyOWQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ZyZWVzY2FsZS9LY29uZmlnDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVz
Y2FsZS9LY29uZmlnDQo+IEBAIC05LDcgKzksNyBAQCBjb25maWcgTkVUX1ZFTkRPUl9GUkVFU0NB
TEUNCj4gIAlkZXBlbmRzIG9uIEZTTF9TT0MgfHwgUVVJQ0NfRU5HSU5FIHx8IENQTTEgfHwgQ1BN
MiB8fA0KPiBQUENfTVBDNTEyeCB8fCBcDQo+ICAJCSAgIE01MjN4IHx8IE01Mjd4IHx8IE01Mjcy
IHx8IE01Mjh4IHx8IE01MjB4IHx8IE01MzJ4IHx8IFwNCj4gIAkJICAgQVJDSF9NWEMgfHwgQVJD
SF9NWFMgfHwgKFBQQ19NUEM1Mnh4ICYmDQo+IFBQQ19CRVNUQ09NTSkgfHwgXA0KPiAtCQkgICBB
UkNIX0xBWUVSU0NBUEUgfHwgQ09NUElMRV9URVNUDQo+ICsJCSAgIEFSQ0hfTEFZRVJTQ0FQRSB8
fCBBUkNIX1MzMiB8fCBDT01QSUxFX1RFU1QNCj4gIAloZWxwDQo+ICAJICBJZiB5b3UgaGF2ZSBh
IG5ldHdvcmsgKEV0aGVybmV0KSBjYXJkIGJlbG9uZ2luZyB0byB0aGlzIGNsYXNzLCBzYXkgWS4N
Cj4gDQo+IEBAIC0yMyw3ICsyMyw3IEBAIGlmIE5FVF9WRU5ET1JfRlJFRVNDQUxFICBjb25maWcg
RkVDDQo+ICAJdHJpc3RhdGUgIkZFQyBldGhlcm5ldCBjb250cm9sbGVyIChvZiBDb2xkRmlyZSBh
bmQgc29tZSBpLk1YIENQVXMpIg0KPiAgCWRlcGVuZHMgb24gKE01MjN4IHx8IE01Mjd4IHx8IE01
MjcyIHx8IE01Mjh4IHx8IE01MjB4IHx8IE01MzJ4DQo+IHx8IFwNCj4gLQkJICAgQVJDSF9NWEMg
fHwgU09DX0lNWDI4IHx8IENPTVBJTEVfVEVTVCkNCj4gKwkJICAgQVJDSF9NWEMgfHwgQVJDSF9T
MzIgfHwgU09DX0lNWDI4IHx8IENPTVBJTEVfVEVTVCkNCj4gIAlkZWZhdWx0IEFSQ0hfTVhDIHx8
IFNPQ19JTVgyOCBpZiBBUk0NCj4gIAlkZXBlbmRzIG9uIFBUUF8xNTg4X0NMT0NLX09QVElPTkFM
DQo+ICAJc2VsZWN0IENSQzMyDQo+IEBAIC0zMSw3ICszMSw3IEBAIGNvbmZpZyBGRUMNCj4gIAlp
bXBseSBORVRfU0VMRlRFU1RTDQo+ICAJaGVscA0KPiAgCSAgU2F5IFkgaGVyZSBpZiB5b3Ugd2Fu
dCB0byB1c2UgdGhlIGJ1aWx0LWluIDEwLzEwMCBGYXN0IGV0aGVybmV0DQo+IC0JICBjb250cm9s
bGVyIG9uIHNvbWUgTW90b3JvbGEgQ29sZEZpcmUgYW5kIEZyZWVzY2FsZSBpLk1YIHByb2Nlc3Nv
cnMuDQo+ICsJICBjb250cm9sbGVyIG9uIHNvbWUgTW90b3JvbGEgQ29sZEZpcmUgYW5kIEZyZWVz
Y2FsZSBpLk1YL1MzMg0KPiBwcm9jZXNzb3JzLg0KPiANCj4gIGNvbmZpZyBGRUNfTVBDNTJ4eA0K
PiAgCXRyaXN0YXRlICJGRUMgTVBDNTJ4eCBkcml2ZXIiDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+IGluZGV4IDhiYThlYjM0MGI5Mi4uNzA1MzQ4ODc5
YjBjIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21h
aW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0K
PiBAQCAtMTU1LDYgKzE1NSwxMyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGZlY19kZXZpbmZvIGZl
Y19pbXg4cW1faW5mbyA9IHsNCj4gIAkJICBGRUNfUVVJUktfREVMQVlFRF9DTEtTX1NVUFBPUlQs
DQo+ICB9Ow0KPiANCj4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgZmVjX2RldmluZm8gZmVjX3MzMnYy
MzRfaW5mbyA9IHsNCj4gKwkucXVpcmtzID0gRkVDX1FVSVJLX0VORVRfTUFDIHwgRkVDX1FVSVJL
X0hBU19HQklUIHwNCj4gKwkJICBGRUNfUVVJUktfSEFTX0JVRkRFU0NfRVggfCBGRUNfUVVJUktf
SEFTX0NTVU0gfA0KPiArCQkgIEZFQ19RVUlSS19IQVNfVkxBTiB8IEZFQ19RVUlSS19IQVNfQVZC
IHwNCj4gKwkJICBGRUNfUVVJUktfRVJSMDA3ODg1IHwgRkVDX1FVSVJLX0JVR19DQVBUVVJFLCB9
Ow0KPiArDQo+ICBzdGF0aWMgc3RydWN0IHBsYXRmb3JtX2RldmljZV9pZCBmZWNfZGV2dHlwZVtd
ID0gew0KPiAgCXsNCj4gIAkJLyoga2VlcCBpdCBmb3IgY29sZGZpcmUgKi8NCj4gQEAgLTE4Nyw2
ICsxOTQsOSBAQCBzdGF0aWMgc3RydWN0IHBsYXRmb3JtX2RldmljZV9pZCBmZWNfZGV2dHlwZVtd
ID0gew0KPiAgCX0sIHsNCj4gIAkJLm5hbWUgPSAiaW14OHFtLWZlYyIsDQo+ICAJCS5kcml2ZXJf
ZGF0YSA9IChrZXJuZWxfdWxvbmdfdCkmZmVjX2lteDhxbV9pbmZvLA0KPiArCX0sIHsNCj4gKwkJ
Lm5hbWUgPSAiczMydjIzNC1mZWMiLA0KPiArCQkuZHJpdmVyX2RhdGEgPSAoa2VybmVsX3Vsb25n
X3QpJmZlY19zMzJ2MjM0X2luZm8sDQo+ICAJfSwgew0KPiAgCQkvKiBzZW50aW5lbCAqLw0KPiAg
CX0NCj4gQEAgLTIwMyw2ICsyMTMsNyBAQCBlbnVtIGlteF9mZWNfdHlwZSB7DQo+ICAJSU1YNlVM
X0ZFQywNCj4gIAlJTVg4TVFfRkVDLA0KPiAgCUlNWDhRTV9GRUMsDQo+ICsJUzMyVjIzNF9GRUMs
DQo+ICB9Ow0KPiANCj4gIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2aWNlX2lkIGZlY19kdF9p
ZHNbXSA9IHsgQEAgLTIxNSw2ICsyMjYsNyBAQCBzdGF0aWMNCj4gY29uc3Qgc3RydWN0IG9mX2Rl
dmljZV9pZCBmZWNfZHRfaWRzW10gPSB7DQo+ICAJeyAuY29tcGF0aWJsZSA9ICJmc2wsaW14NnVs
LWZlYyIsIC5kYXRhID0gJmZlY19kZXZ0eXBlW0lNWDZVTF9GRUNdLCB9LA0KPiAgCXsgLmNvbXBh
dGlibGUgPSAiZnNsLGlteDhtcS1mZWMiLCAuZGF0YSA9ICZmZWNfZGV2dHlwZVtJTVg4TVFfRkVD
XSwgfSwNCj4gIAl7IC5jb21wYXRpYmxlID0gImZzbCxpbXg4cW0tZmVjIiwgLmRhdGEgPSAmZmVj
X2RldnR5cGVbSU1YOFFNX0ZFQ10sIH0sDQo+ICsJeyAuY29tcGF0aWJsZSA9ICJmc2wsczMydjIz
NC1mZWMiLCAuZGF0YSA9ICZmZWNfZGV2dHlwZVtTMzJWMjM0X0ZFQ10sDQo+ICt9LA0KPiAgCXsg
Lyogc2VudGluZWwgKi8gfQ0KPiAgfTsNCj4gIE1PRFVMRV9ERVZJQ0VfVEFCTEUob2YsIGZlY19k
dF9pZHMpOw0KPiAtLQ0KPiAyLjI1LjENCg0K
