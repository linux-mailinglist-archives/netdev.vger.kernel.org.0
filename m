Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596F6566415
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 09:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiGEHcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 03:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiGEHcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 03:32:36 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2071.outbound.protection.outlook.com [40.107.104.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2469B12D06;
        Tue,  5 Jul 2022 00:32:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d07wRDeFt0Q64yBzxvlUsTdfNyKxq3geYMOI8xy4uA+kVFAldsbpM4hwReDg6RiEFBfhtAgTVGTnpLbIe+UvZaLMPnbzpVDDymrraVXW0QGq+04Y8WAmY+LbqAjLaxIBUCKT3RAGWlXWfko87T7EUuKcG4KxjIxFZjuXcEUh7Ca1iB3WmNWxj7wCAYy5x7f6UfCHCQ4cgoo+QiOc+Y5LeomUJ2ElkLVInksGTsX0782/qyzw7FzPM/bggDh/U0A3NeZtB/qx8frYd+RtUThdJ8fJ8F2BXcmMpbNcM/PkTdxtc3xxCM24pX3PfD8LiVyiT2CzBV2HujiJ8w5wbw9llg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b05vshqW+s2RUugx28SMRiNlomDfadWVF3O32KOH7ok=;
 b=D9FeSggk6Sn+RRWqZXGrriL4P49BCwyHzyJQ1GqaUaD/IkQ/UpcoyrbNgYznDZmN715tE1pFNYidLwRC+v1Q8XzHFnMiZs2+sKpmZroPnJAyB4HBdqR1JUxzhJo7FvI6H9jpTpADBTvp99xNqgBDQurfctfLbZwve52HjVBFVLf7tIbCmdcuSRZ+ruul6wD3+gC4W6fnVsW8ZNKP8AumY5mYltol/1SJkWRsBQQdcgTulzDdUxKf5c/0MtK2gRphLaSnyMatyf5BqXYICHaivt6dNbP7SZbSxpnnSZpac8muyZnwsVtAH9rPudK6y53G601SMj39HDT3BCQ7QQil3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b05vshqW+s2RUugx28SMRiNlomDfadWVF3O32KOH7ok=;
 b=Q4CeXcsG2u3dhKkTu9zxh3aY4GhG9OmqMD2P4Q1GCEiNlp5HohWSpK+8hexhiAyMc3lUR+E0qkS9dt0RSMY/7Lfj5ZpCUfRdItJUW5JHGLQeO7r/MLbTxMJO11PvmR1FB4pWA3PgoK7ICyTaGQr1r4Ta/xWamJDZC/pjxgHpA6g=
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AM0PR04MB5955.eurprd04.prod.outlook.com (2603:10a6:208:110::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Tue, 5 Jul
 2022 07:32:31 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654%8]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 07:32:31 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Aisheng Dong <aisheng.dong@nxp.com>
Subject: RE: [EXT] Re: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible
 item
Thread-Topic: [EXT] Re: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible
 item
Thread-Index: AQHYj0v3LLIwav7MHE6sxs7MEUf4UK1t7a6AgAEUIUCAAGDjgIAAANJA
Date:   Tue, 5 Jul 2022 07:32:31 +0000
Message-ID: <AM9PR04MB9003AEBB17E9052D335A9EDD88819@AM9PR04MB9003.eurprd04.prod.outlook.com>
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-2-wei.fang@nxp.com>
 <ef7e501a-b351-77f9-c4f7-74ab10283ed6@linaro.org>
 <AM9PR04MB900371B6B60D634C9391E70288819@AM9PR04MB9003.eurprd04.prod.outlook.com>
 <78f2423b-d803-5b3c-40a8-b51f4f276631@linaro.org>
In-Reply-To: <78f2423b-d803-5b3c-40a8-b51f4f276631@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69d3ea98-f7ce-4c3a-9f2a-08da5e58855a
x-ms-traffictypediagnostic: AM0PR04MB5955:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4enB9vRtC89fN7sFCAeX4NqN4htJHz4ovUAlR+laZ2x5kEfjGxUsAWiTlCSNbLNmfucZxrHF3IBGbKIXT6ei4DuSTxGeg84x/s0yuXNrCd7n9s7Ei1I7NTyBRyg8WZ+ihOpLj+2clJp9NH+54ruXBYMHzmQA5p08JPAid3Quge4jtLPQfBjiBhgjjwRbjJHpjV/MKpshY/au4jbE0AMa111xfjv8+T0JXp8L59dAXmcQbEzpS6n4+XXZ85ixUT24pUAecs6t6qL3sPNKVMqj5kifegnlXrrEqQiYLy6ImIc3yEkXE9CZWRv1TiFUvOdjRw343EJpqFfjZcQRfoDsn39qvPwS0gKX8ywf3dMAq+jg4MwdI31eo2Dn1a6Fg11Kl5X4mTzpgDQXWyTyU7fIsDpzOVPiXssmCkfOPrFK4qdplHlOaqERwifsb+MmeJHZus82KLmH6/igbbcwF35oUPEwPF14PcwnGOD2DVsF8wakjYj49kYG+22D0fnZaHEcOGZdjQPkvgFvw2Sv2QF6i3sEvfNhcq7Jb6akWI0OJyvKq8Rvx6oDjnKnoF3/kFiRbX7nmh0vsyPIsR4DijjFkRn+VHXvT0pUJs3/QVVW69HQxXakwhMeSw8GcQRBt8sjUNLIa+WeFwfxcC2xNAytvPa6GO+ZFBNjIvYRPo2KnHoE91uj54YHHBRdyEAr09zIXDjsN37uyyBQkMXjY4AzHMJEFAt2Opqe4xNAsxL1rMQRh03qPAOYiEwTEesUbByGRh7TLn70ccQRFlNG4+r7rgWY0GgIQHZbI8599GvW43tb2lbL15SC7o/B9A6xXMbq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(8936002)(478600001)(86362001)(52536014)(83380400001)(5660300002)(7416002)(44832011)(186003)(316002)(55016003)(54906003)(110136005)(9686003)(38070700005)(2906002)(26005)(6506007)(38100700002)(122000001)(15650500001)(41300700001)(53546011)(76116006)(66946007)(4326008)(8676002)(7696005)(64756008)(66446008)(66556008)(66476007)(33656002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2RwbWQwajBOZEkrdzUyM2hKRHhZUU5mcVVicTJUaXlFaEhEN3VlMlZZSHox?=
 =?utf-8?B?Tlorb3J4MU1DdTg1blFVUzNtcWVBNWFOUlRjbTFTN3ppcFpCeFNXcHZhaGxJ?=
 =?utf-8?B?dG5qVFB0S2JrSmRCVjZRRkw1cDVhNm9HNXQyS3BzQk1lRSt1R2h6QVNjUkpR?=
 =?utf-8?B?dm1XNGFwbzFCVnVuVjRzR2JDTWFNckxNajNUb0dzcFc4bFd0VHN6bk9NclJj?=
 =?utf-8?B?VTlnYVlDNFJUMGQrc2E0SDNreURMamxpWmcwclRQL1NUUWZrSzR4MnZMSTBm?=
 =?utf-8?B?V2FwUDFKVENDaGVRaHI4MCtOWlc2MWx1V3gyTDdSeU96cHNGdUpnb2liVklX?=
 =?utf-8?B?U1Z2aGpOWGQ1ZXFVSXh4UGVmczhoaFRadndsZFMrcVFQQkhCR1MzeDFVaWo4?=
 =?utf-8?B?UWR6dG5ERU95VW9rVFNYUWJrcE8yNWZKMXFTVmdZYVZ5Z2thbHVwYlYwSVVC?=
 =?utf-8?B?UlJrQUpGem5aRnRHV1hYam8vMmxyK3cvdEIzMEM4RGRoWC9qKzJLbW51U29s?=
 =?utf-8?B?bk8rSEp3c3FNRW5mcXRNUEd3a1Y4aVlPS1ZDVGhlSDdycmcxdEIvV29lNkU4?=
 =?utf-8?B?RFp2a3dPUytERHRCcThCRXZSYzRpVVBHbFArWlE0d2Qxa3d0MUlkZTREZHA2?=
 =?utf-8?B?ZTFvWEV4UlhLdWNpOVJMZDgvTlN4aUk5UUpSMmprVHgzbW1UODJXUVNLZTVv?=
 =?utf-8?B?Q3lwRm55NWtWakJjNUxlMUVXSmpSMWRYVExoR3ptL2N1WktHajI4QWdON253?=
 =?utf-8?B?MlNOQm9qUTNhN3pjT0s3dis4MXREZWhGQVI2TDNja1JDemt3Q1A4d2JESlpV?=
 =?utf-8?B?L0hWNmpRQ0diY0pZRGp5SE5UT3V4NHRHNU5CK3lSL0YyanJKWitiNVllYWtV?=
 =?utf-8?B?a216amg3aW9RLzVGaUdSNDVrWjBvZzF3QVR5YXRxNFZ5NXFLbUFzTzRZMndJ?=
 =?utf-8?B?YTlzV1BJUXRUVkpSWngwRElOcmdRQ3kwOXFoOXlmaEVxL2x5VnExdlZ0c2tY?=
 =?utf-8?B?UmZlU0gyVlJDQ2RVSFhWNFM3OTExbGxlNldKeWh0cklCaVVPeVg2TzVPU3F5?=
 =?utf-8?B?aml1eVBqRktIVHlBekdBMTdjdW9SM3ZaWHBFVHhKWVhHL1hKc05NNmRpSGVm?=
 =?utf-8?B?bHAxckUrcWhnSGpKZkx5ajdsbWRIMmpnTTVrUFZzQUp1UU1qS015TUZaVHFE?=
 =?utf-8?B?cWNiSko5ZmI3MjlpVUhqbks4czkrNTZ0MU0vZGxOc2RKUW1aeU1DWkJDMW9B?=
 =?utf-8?B?cENwTGUzR3NzSWdpN2JiZ2VwM2g3SzFtSzAwRXBZaGhXRXF6MHJsMGdwL1ln?=
 =?utf-8?B?RExxWVJUN3B6Y2J4eEFTTGFZTzNPRlhhaEhaNGpsdWRJTGZSbXVGRExQNWJ4?=
 =?utf-8?B?aGFCOXFTNXozaE9HcWlOV0RPTWlBeGRITDZJOGlTMGZzaDc4M0lKMVFnTy9u?=
 =?utf-8?B?cFJrZUJvZUI4T212MmUrRi9tK0NtUXdnTkZNcTNlSmJBVUc1THhQSjE2dkRp?=
 =?utf-8?B?U1J3ZWJvK0V4ajVvS1dhdTBxMjEybE02REFZZnZFeHJVMDQvYTBtK3g0Z1Vp?=
 =?utf-8?B?dzVJeEttS0V1dFptTHpHQ1VVbXpRWFN1OGh0RkdNc1JuQ3RHQmhNZXN1WVB2?=
 =?utf-8?B?a3dIZ05GSjhlelNJbzVxNUFCQjRYVDZ6cHRsSXFMSWZVOTc4by9QajdjWGFT?=
 =?utf-8?B?V3RSTUU3L25EanNtbDY1M2llRU8zS1IyakJUOFE4dDkwdjRBazJTd3VsczND?=
 =?utf-8?B?ZDRIalducUpJR2N3NElzenZla2x2eGtpN0RvTGQvVTgxNmJGNlRvNU1YZXRY?=
 =?utf-8?B?U2J1aHNUeU1HbDVNSUF0aXhEVmJ6ZGF3NHEzQkh6Y2RpWXdaczZYakJidVVr?=
 =?utf-8?B?dVpHVW9UejNMSlFWRGJyR3N2NC82eTRPTUlZVXp2VlJMUHdBVHdwOUZnMGZS?=
 =?utf-8?B?TUhtcDJ6SXdWSUlsNXBvUWdiajYva3FCK3VQdURSemdOYzZVS3RBQWxIaktG?=
 =?utf-8?B?emhkMFFIeVRxZWtRSzF2WXRaekdXUEVZRDZpc1NLZ0NzUWgzQjRSSWNpc09P?=
 =?utf-8?B?bmJIMnpFQjFmc0wwY0sva0luQXFzN2I4Q1F6MU0rWlJEWWNwZDh5emJSZFhL?=
 =?utf-8?Q?aOlM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d3ea98-f7ce-4c3a-9f2a-08da5e58855a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 07:32:31.3163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O950FG8w0VDQgdQAOIue85ovRirV+xdCiCmx/MOIeCdcUp4OLD0fZOyd9G90jIXpwYiAuSJ8CCzuLAr2wo0slA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5955
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS3J6eXN6dG9mLA0KDQoJVGhhbmtzIGZvciB5b3VyIHN1Z2dlc3Rpb24sIEkgd2lsbCByZXN1
Ym1pdCB0aGUgcGF0Y2guDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBLcnp5
c3p0b2YgS296bG93c2tpIDxrcnp5c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc+IA0KU2VudDog
MjAyMuW5tDfmnIg15pelIDE1OjI3DQpUbzogV2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+OyBk
YXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7
IHBhYmVuaUByZWRoYXQuY29tOyByb2JoK2R0QGtlcm5lbC5vcmc7IGtyenlzenRvZi5rb3psb3dz
a2krZHRAbGluYXJvLm9yZzsgc2hhd25ndW9Aa2VybmVsLm9yZzsgcy5oYXVlckBwZW5ndXRyb25p
eC5kZQ0KQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBrZXJuZWxAcGVuZ3V0cm9uaXguZGU7
IGZlc3RldmFtQGdtYWlsLmNvbTsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IFBl
bmcgRmFuIDxwZW5nLmZhbkBueHAuY29tPjsgSmFja3kgQmFpIDxwaW5nLmJhaUBueHAuY29tPjsg
c3VkZWVwLmhvbGxhQGFybS5jb207IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9y
ZzsgQWlzaGVuZyBEb25nIDxhaXNoZW5nLmRvbmdAbnhwLmNvbT4NClN1YmplY3Q6IFJlOiBbRVhU
XSBSZTogW1BBVENIIDEvM10gZHQtYmluZ3M6IG5ldDogZnNsLGZlYzogdXBkYXRlIGNvbXBhdGli
bGUgaXRlbQ0KDQpDYXV0aW9uOiBFWFQgRW1haWwNCg0KT24gMDUvMDcvMjAyMiAwNDo0NywgV2Vp
IEZhbmcgd3JvdGU6DQo+IEhpIEtyenlzenRvZiwNCj4NCj4gICAgICAgU29ycnksIEknbSBzdGls
bCBhIGxpdHRsZSBjb25mdXNlZC4gRG8geW91IG1lYW4gdG8gbW9kaWZ5IGFzIGZvbGxvd3M/DQo+
PiArICAgICAgLSBpdGVtczoNCj4+ICsgICAgICAgICAgLSBlbnVtOg0KPj4gKyAgICAgICAgICAg
ICAgLSBmc2wsaW14OHVscC1mZWMNCj4+ICsgICAgICAgICAgLSBjb25zdDogZnNsLGlteDZ1bC1m
ZWMNCj4+ICsgICAgICAgICAgLSBjb25zdDogZnNsLGlteDZxLWZlYw0KDQpZZXMNCg0KPg0KPiBB
bmQgYXMgZmFyIGFzIEkga25vdywgdGhlIGlteDh1bHAncyBmZWMgaXMgcmV1c2VkIGZyb20gaW14
NnVsLCB0aGV5IGJvdGggaGF2ZSB0aGUgc2FtZSBmZWF0dXJlcy4gSG93ZXZlciwgdGhlIGZlYyBv
ZiBpbXg4dWxwKGFuZCBpbXg2dWwpIGlzIGEgbGl0dGxlIGRpZmZlcmVudCBmcm9tIGlteDZxLCB0
aGVyZWZvcmUsIHRoZSBmdW5jdGlvbnMgc3VwcG9ydGVkIGJ5IHRoZSBkcml2ZXIgYXJlIGFsc28g
c29tZXdoYXQgZGlmZmVyZW50Lg0KDQpJIHVuZGVyc3RhbmQuIEJ1dCBpZiBpbXg4dWxwIGlzIHRo
ZSBzYW1lIGFzIGlteDZ1bCBhbmQgaW14NnVsIGlzIGNvbXBhdGlibGUgd2l0aCBpbXg2cSwgdGhl
biBJIGV4cGVjdCBpbXg4dWxwIHRvIGJlIGNvbXBhdGlibGUgd2l0aCBpbXg2dWwgYW5kIHdpdGgg
aW14NnEuDQoNCkJlc3QgcmVnYXJkcywNCktyenlzenRvZg0K
