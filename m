Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88996699214
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjBPKqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjBPKqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:46:18 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2044.outbound.protection.outlook.com [40.107.241.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB51518F2;
        Thu, 16 Feb 2023 02:45:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IuTMkrKh6XQKcNylH8WNz28FMSRwBXMc+KUJkj0kxeQ2aavqE2hh8+mf6pA4/uI+CmWwRoxycP4CAjGokxUSl3D3no8tpZH02QYxrKbCIORp9bB8Lrz6nA2JkfKRMO6eu6/o7Qcf5NQ1YWwctc9yz81LV9J/JKQfVvaEHzmFwMCudS4SkQ7HG1aHjeHMDfIdiiUV46wB1ue7QHR56LlvjWWBy6xY67TmtOk+y2K0j60XPa4pq9qYaanqm9Bh0i06IFTkgvXihubdueMWmsOvABPkdv9ITxTOu2c6I7V8YPjL3yZ1X983BCTV8xbbKlU5w+rJr3QrdDDpeMFJ0Bu4oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45IMsTuf1UpQV4BV0rUiXq9oOU4HYLKC63k7Tn+fwJE=;
 b=RahM6etSdOJrkH9GKbBtSdyVlGkgOiTbYIdk3Lk394TbX+AXL7z5Rq5FLBr0XnJpe5x0ICpJz6dA8w0aAbQb+VzcHwfrsCKBcy830SRU6VwWav7SRtGpNPuR1B9MrNlWdGFXDZ0o7djmI9CbFxr/11EomMIOnoXDkakad3HUzBcOYzLNIchwM147PjePeM0fNCS1qV0R6EiUbJ2DxouIxNhk0NiTG3QJ9Nl4CgJHmAuEl0RtKsaOA/w84dyMr//tvnmqkSNZ6JL4F64y8DT/G+2D+OuKp1QGQVlmO31nYvJux4Zk0CAD30mWBCXrqTb7PkhfC/7aJebI5i8ZpngrhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45IMsTuf1UpQV4BV0rUiXq9oOU4HYLKC63k7Tn+fwJE=;
 b=Yhdz+xNOJninexu/TYZB/pRQ1a203ZsV+JV8M01Pp+ZHzMMl+tU/WQH7bkalAVVpOg85g/2WLfhh3XHaU580KtsW/XNfPa+hPqbrqcR54oIO0V7pfpkFwjtw0MNz46V/K2WE7qqJQBBZdMArfB85XO1pnd5/eA+kfH7CQD/oVwA=
Received: from AS8PR04MB8404.eurprd04.prod.outlook.com (2603:10a6:20b:3f8::7)
 by AM0PR04MB6900.eurprd04.prod.outlook.com (2603:10a6:208:17d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 10:45:37 +0000
Received: from AS8PR04MB8404.eurprd04.prod.outlook.com
 ([fe80::7f24:bc0a:acd4:b13f]) by AS8PR04MB8404.eurprd04.prod.outlook.com
 ([fe80::7f24:bc0a:acd4:b13f%5]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 10:45:37 +0000
From:   Sherry Sun <sherry.sun@nxp.com>
To:     Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>, Jun Li <jun.li@nxp.com>,
        Bough Chen <haibo.chen@nxp.com>
Subject: RE: [PATCH v3 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth
 support
Thread-Topic: [PATCH v3 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth
 support
Thread-Index: AQHZP7s5wMRN1tvrbkOa4CwyBldgGa7RQwNQ
Date:   Thu, 16 Feb 2023 10:45:36 +0000
Message-ID: <AS8PR04MB8404000E96456866B6D99E1D92A09@AS8PR04MB8404.eurprd04.prod.outlook.com>
References: <20230213145432.1192911-1-neeraj.sanjaykale@nxp.com>
 <20230213145432.1192911-3-neeraj.sanjaykale@nxp.com>
In-Reply-To: <20230213145432.1192911-3-neeraj.sanjaykale@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8404:EE_|AM0PR04MB6900:EE_
x-ms-office365-filtering-correlation-id: f333e084-4095-42f6-5e14-08db100af04d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3fpqyq7tbwgYJTipXhQcqMHz82lNl0oQ7lH8iDP1b1xLqXUhtFo0hP4QChcAQwEBzEufsB16eT5NFDw3CCJqr6mN4lG/XpqMm4LQ4jyCpu+/jjyeD2S0f21TnJUPBV62VItLiXkhJMXexZhaRubrr07pkF/vDyaMGap5QozvGc57wEFZ/BY0m7ajHNO2ktoMGoWPPYjbno1fL7uPmlC16/He3G7BOjoLtP4Mx9BQMyQFLx4W/dGG8VDMaJgBnRyM9Z6DTck8rteSB5r67rjedpKKABE27rwIYBe0hqEBiZX9Ph70OeVBA+/CQTi2XYdcDffJxGQxn3RDYGeDu9LIqLJtfEffbDANgQfBOaUvyxPtHSfNEiiONpvxmUk2eIvW1YCPVBaZacM8oA8yGshInVlHAXLOrvd46qZKa9iDGvqaZ2u/oHifx6u8c+S9OpTW4K1V09jzSZ8wmQpRhiiLduj5+fLJl9/K7biK+Z7yHwiLvubkzlP5GAI7sye7tNR4VEyWkK4fRu2q3KC02TrE/KjJW5OjeSEUjIHQ4R8Z7zLA0RER+f4D2HkVplf/JUxZ9OGN2jQXxaTq7J04qci9DO5ROk/Jxaq3NFPGJY2eBbT3NreembovThjt2ZfUE9tm5QqjZepC8BqdMSAdcjtXubW+xyXJf1Kv498ddxj70Fxn16JqtcNXtZdrEmcl6vaekGxVu06wJnvC5UwYj8sN6bTJx+pzi7GCVGvoYRF6ArPdJvsyfhlArLp1wutKyk7Y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8404.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199018)(7416002)(44832011)(33656002)(5660300002)(83380400001)(478600001)(966005)(186003)(26005)(53546011)(9686003)(7696005)(6506007)(71200400001)(66446008)(64756008)(66556008)(76116006)(66946007)(4326008)(8936002)(8676002)(86362001)(55016003)(921005)(41300700001)(38070700005)(52536014)(66476007)(54906003)(38100700002)(110136005)(122000001)(316002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?WjNDYTU1VGxaOVFxWmxXRHovMThyR1QxRVdOcGZBTnVFZlplNU1lMEtGS1FO?=
 =?gb2312?B?dnZOTCtwMEpiaHhwTnJvRVcwV3dwWDhRQkpkN1FJL3VJaGlFdkVBbkJRWkpR?=
 =?gb2312?B?bUIxU0NNVUJXelJuSmxqZHl5ZVNrRmszdlJCMGlDeXUxc3hiQTB3ekdhek1k?=
 =?gb2312?B?UEFmOHZkMlZ0Q2JUVm5saFpuL2pTV1lFam51d2NzWnBKRHJIZUlkQ1N3TVA1?=
 =?gb2312?B?VUIrTWN4M3FDckowR3FSdG9KWHR1UWhLRVVzYlE2Sld1OWtoOEY1NVlkOUFD?=
 =?gb2312?B?ZTBpZE5ONE9UbXpGRjZjay9TbTVzRnJoaVpaRlZSeUZ6SUlnK0NSU0t2UUdp?=
 =?gb2312?B?c2Z0WXlaWjU5M3A0MFQ3ZmpKU3RqVEZCMG00c2FpdWViclVqUDJxVWVqNHVZ?=
 =?gb2312?B?SmV5TFF1R291Y0ZZRVRYNkhIRHdEU0VkOVhlVU1MeFBqMUtZRFVKWjZYeitu?=
 =?gb2312?B?Y0NxYXJiZWM2aUhRY2RYaXkrOFBzc3ArNFRXTFpFaHJQRDU0SEc0N2FIdS9I?=
 =?gb2312?B?QjFsUHZoQnZDRDlUK3NacGhrRFVRS0JEK0ZWdDZuTCtnNUQ4MXV3cTI5dzhl?=
 =?gb2312?B?QXlmc1lXeHhEdWw2M1RHZzZheW5za2g4WmNOemRuVnoyV0w0YjVhUDd4ZDJj?=
 =?gb2312?B?TUZJbTNJQjllclU0SnZmdW9oRU0vMFcxWDVTeDZlem03cXNHWVVBU2VCZ2pj?=
 =?gb2312?B?VzlLQU0vTU5rUVBxUUcwWjFUWGZBWDhuQWoxK0hxRmZBODNoMzNwZFNMSmZO?=
 =?gb2312?B?blNKUVNNV0I2Qnh6bm9OaGxHRjFqS3djNlRtZ1VCOFE4OEhBSzcrV2hhd3dS?=
 =?gb2312?B?VUFHK0hBR1QxUFRBQlZWUFNMT2NYWlR2SjFPOWFDcGVybDE3elZTWTRITzVy?=
 =?gb2312?B?c3pZNldpMGUzZHFGK3dtRm9vaGptaEYra1dPVDE2VWlxNElCRnpYek9TN2VD?=
 =?gb2312?B?WmY0eGR4bUtWR1dYenlXWXhRcTU1WFZJbVU2ekRGTmw1cFF6czNMaWUvK2I0?=
 =?gb2312?B?SUd2cGV1NDNISlhOM3V2R0FlaWxwQ1JVbUdsT3VrakgyY21jVERSeFlnUStT?=
 =?gb2312?B?STFMZkZubUNrcVhEZ3U4WVpuTnpnTC9YSGg2Tnd0Y1hqWklyS3c0UjRvRUNk?=
 =?gb2312?B?VEIzamxnS2Z6cUhOZzl4MVJheENVcGFDNW50SG9ldHA1V1NEQUVrZ1hHRHRw?=
 =?gb2312?B?cXpLSm1tNCtSUXRIK3dtNm1JWW1NYjZHK0xEeWtNT3N2ZXFTOTRTTGw3d0hp?=
 =?gb2312?B?MlZ1YkI1b01VczZnRnhWYmJpYVlocW8wV09BVHYzQVE5SUcwVlQ5dGVEUnN3?=
 =?gb2312?B?MUFiZmJSalc2T1lIUkcvcU9zSGMrSitndktZZXE3bVNMeUp1NStuWUgzeGxG?=
 =?gb2312?B?U0FkczJYZ0RHbDkvdGV1Y3dTdW1qMnBEMkF6SlNEbFA0MmRyMzI5cnRZc0l6?=
 =?gb2312?B?UGRtZVNnM2xDR05lTHdJd3htRHZaejB1Z2V3ZjdGTS9xSnZwWnR6K1VlSW83?=
 =?gb2312?B?ZlJORVAzenNqVUJWQTZNVHFINEwydFZoUFlNeTgvazlEeWppWWRzRUFkYzhJ?=
 =?gb2312?B?Q1Bub0RybWtFTStVQnFjNEFmdGlWeURxUnM4U1NxS29MSy9uemdMZGs2TlNN?=
 =?gb2312?B?SFdiU29XKzQwZ3dMTzJHaEFiNmUxenZDWjJLZzBpNlVVZnRUYzRCZUJSUGhM?=
 =?gb2312?B?ZVlVeXZBc2I3SCsyTmVYdkZuZnRyWGhBd0VnQlVmQmhaenk1UW5zdmtjL0JC?=
 =?gb2312?B?VDJBRFBOcm9PNkVBci8vR1hJMEsyVmtQb1RZVTVXK2ZZRGdXd3VZNVdkcGUz?=
 =?gb2312?B?Y0s0eHBSS3VucFNwS3JYNEMyVUZJNExJRlBlc3ZNRm1UR3VETUt3QkM2bWpL?=
 =?gb2312?B?VlY0YXpOREpESng4VVpseFN2aFNMODJxMHJOVEFDUEtmdzA5b2ltd25FSmdu?=
 =?gb2312?B?eGFaSyt6elpHU3I3bnJKWVBNOE16K3NxQWF2Q0R1V2lzWlcwQVFmK1Zzay90?=
 =?gb2312?B?REk5cHdleTZ6b051OHphYWc5RTZERmhzQUhqd256VG8wZ0E2NTNMRzZSTVhD?=
 =?gb2312?B?dWRNejRQdnZORUJIZmtrR3BmNGZ5OEFjZ3dUQnpwTjFaK1R4UElLSng3SWJR?=
 =?gb2312?Q?achKzmqqb+CaQxav8RWsgEhYa?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8404.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f333e084-4095-42f6-5e14-08db100af04d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 10:45:36.9908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LmOha40Webn9PPJGOLmSxeRtTBANBM9ebQMWbTANE+QFhZezCcJHE/asXMuMyFMbN+9lZf/GafsJXXT6FPTBEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6900
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTmVlcmFqIHNhbmpheSBr
YWxlIDxuZWVyYWouc2FuamF5a2FsZUBueHAuY29tPg0KPiBTZW50OiAyMDIzxOoy1MIxM8jVIDIy
OjU1DQo+IFRvOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJh
QGtlcm5lbC5vcmc7DQo+IHBhYmVuaUByZWRoYXQuY29tOyByb2JoK2R0QGtlcm5lbC5vcmc7DQo+
IGtyenlzenRvZi5rb3psb3dza2krZHRAbGluYXJvLm9yZzsgbWFyY2VsQGhvbHRtYW5uLm9yZzsN
Cj4gam9oYW4uaGVkYmVyZ0BnbWFpbC5jb207IGx1aXouZGVudHpAZ21haWwuY29tOw0KPiBncmVn
a2hAbGludXhmb3VuZGF0aW9uLm9yZzsgamlyaXNsYWJ5QGtlcm5lbC5vcmc7IGFsb2suYS50aXdh
cmlAb3JhY2xlLmNvbTsNCj4gaGRhbnRvbkBzaW5hLmNvbTsgaWxwby5qYXJ2aW5lbkBsaW51eC5p
bnRlbC5jb207IGxlb25Aa2VybmVsLm9yZw0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
ZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1ibHVldG9vdGhAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4gc2VyaWFsQHZn
ZXIua2VybmVsLm9yZzsgQW1pdGt1bWFyIEthcndhciA8YW1pdGt1bWFyLmthcndhckBueHAuY29t
PjsNCj4gUm9oaXQgRnVsZSA8cm9oaXQuZnVsZUBueHAuY29tPjsgU2hlcnJ5IFN1biA8c2hlcnJ5
LnN1bkBueHAuY29tPjsgTmVlcmFqDQo+IHNhbmpheSBrYWxlIDxuZWVyYWouc2FuamF5a2FsZUBu
eHAuY29tPg0KPiBTdWJqZWN0OiBbUEFUQ0ggdjMgMi8zXSBkdC1iaW5kaW5nczogbmV0OiBibHVl
dG9vdGg6IEFkZCBOWFAgYmx1ZXRvb3RoDQo+IHN1cHBvcnQNCj4gDQo+IEFkZCBiaW5kaW5nIGRv
Y3VtZW50IGZvciBOWFAgYmx1ZXRvb3RoIGNoaXBzZXRzIGF0dGFjaGVkIG92ZXIgVUFSVC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IE5lZXJhaiBTYW5qYXkgS2FsZSA8bmVlcmFqLnNhbmpheWthbGVA
bnhwLmNvbT4NCj4gLS0tDQo+IHYyOiBSZXNvbHZlZCBkdF9iaW5kaW5nX2NoZWNrIGVycm9ycy4g
KFJvYiBIZXJyaW5nKQ0KPiB2MjogTW9kaWZpZWQgZGVzY3JpcHRpb24sIGFkZGVkIHNwZWNpZmlj
IGNvbXBhdGliaWxpdHkgZGV2aWNlcywgY29ycmVjdGVkDQo+IGluZGVudGF0aW9ucy4gKEtyenlz
enRvZiBLb3psb3dza2kpDQo+IHYzOiBNb2RpZmllZCBkZXNjcmlwdGlvbiwgcmVuYW1lZCBmaWxl
IChLcnp5c3p0b2YgS296bG93c2tpKQ0KPiAtLS0NCj4gIC4uLi9iaW5kaW5ncy9uZXQvYmx1ZXRv
b3RoL254cCx3OHh4eC1idC55YW1sICB8IDQ0ICsrKysrKysrKysrKysrKysrKysNCj4gIE1BSU5U
QUlORVJTICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICA3ICsrKw0KPiAgMiBm
aWxlcyBjaGFuZ2VkLCA1MSBpbnNlcnRpb25zKCspDQo+ICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4g
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9ibHVldG9vdGgvbnhwLHc4eHh4
LWJ0LnlhbWwNCj4gDQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvbmV0L2JsdWV0b290aC9ueHAsdzh4eHgtDQo+IGJ0LnlhbWwgYi9Eb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2JsdWV0b290aC9ueHAsdzh4eHgtDQo+IGJ0LnlhbWwN
Cj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gaW5kZXggMDAwMDAwMDAwMDAwLi4yNjg1ZjZkNTkw
NGYNCj4gLS0tIC9kZXYvbnVsbA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvbmV0L2JsdWV0b290aC9ueHAsdzh4eHgtDQo+IGJ0LnlhbWwNCj4gQEAgLTAsMCArMSw0
NCBAQA0KPiArIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogKEdQTC0yLjAgT1IgQlNELTItQ2xh
dXNlKSAlWUFNTCAxLjINCj4gKy0tLQ0KPiArJGlkOiBodHRwOi8vZGV2aWNldHJlZS5vcmcvc2No
ZW1hcy9uZXQvYmx1ZXRvb3RoL254cC1ibHVldG9vdGgueWFtbCMNCj4gKyRzY2hlbWE6IGh0dHA6
Ly9kZXZpY2V0cmVlLm9yZy9tZXRhLXNjaGVtYXMvY29yZS55YW1sIw0KPiArDQo+ICt0aXRsZTog
TlhQIEJsdWV0b290aCBjaGlwcw0KPiArDQo+ICtkZXNjcmlwdGlvbjoNCj4gKyAgVGhpcyBiaW5k
aW5nIGRlc2NyaWJlcyBVQVJULWF0dGFjaGVkIE5YUCBibHVldG9vdGggY2hpcHMuDQo+ICsgIFRo
ZXNlIGNoaXBzIGFyZSBkdWFsLXJhZGlvIGNoaXBzIHN1cHBvcnRpbmcgV2lGaSBhbmQgQmx1ZXRv
b3RoLA0KPiArICBleGNlcHQgZm9yIGl3NjEyLCB3aGljaCBpcyBhIHRyaS1yYWRpbyBjaGlwIHN1
cHBvcnRpbmcgMTUuNA0KPiArICBhcyB3ZWxsLg0KPiArICBUaGUgYmx1ZXRvb3RoIHdvcmtzIG9u
IHN0YW5kYXJkIEg0IHByb3RvY29sIG92ZXIgNC13aXJlIFVBUlQuDQo+ICsgIFRoZSBSVFMgYW5k
IENUUyBsaW5lcyBhcmUgdXNlZCBkdXJpbmcgRlcgZG93bmxvYWQuDQo+ICsgIFRvIGVuYWJsZSBw
b3dlciBzYXZlIG1vZGUsIHRoZSBob3N0IGFzc2VydHMgYnJlYWsgc2lnbmFsDQo+ICsgIG92ZXIg
VUFSVC1UWCBsaW5lIHRvIHB1dCB0aGUgY2hpcCBpbnRvIHBvd2VyIHNhdmUgc3RhdGUuDQo+ICsg
IERlLWFzc2VydGluZyBicmVhayB3YWtlcy11cCB0aGUgQlQgY2hpcC4NCj4gKw0KPiArbWFpbnRh
aW5lcnM6DQo+ICsgIC0gTmVlcmFqIFNhbmpheSBLYWxlIDxuZWVyYWouc2FuamF5a2FsZUBueHAu
Y29tPg0KPiArDQo+ICtwcm9wZXJ0aWVzOg0KPiArICBjb21wYXRpYmxlOg0KPiArICAgIGVudW06
DQo+ICsgICAgICAtIG54cCw4OHc4OTg3LWJ0DQo+ICsgICAgICAtIG54cCw4OHc4OTk3LWJ0DQo+
ICsgICAgICAtIG54cCw4OHc5MDk4LWJ0DQo+ICsgICAgICAtIG54cCxpdzQxNi1idA0KPiArICAg
ICAgLSBueHAsaXc2MTItYnQNCkhpIE5lZXJhaiwNCg0KTm8gbmVlZCB0byBzZXQgb25lIGNvbXBh
dGlibGUgZm9yIGVhY2ggTlhQIEJUIGNoaXAgSSB0aGluaywgb3RoZXJ3aXNlIHRoZSBsaXN0IHdp
bGwgZ2V0IGxvbmdlciBhbmQgbG9uZ2VyLg0KWW91IGNhbiB1c2Ugb25lIGNvbW1vbiBjb21wYXRp
YmxlIGZvciBhbGwgdGhlIG5ldyBCVCBjaGlwcyB3aGljaCBzdXBwb3J0IFYzIGJvb3Rsb2FkZXIs
IHRoZW4geW91IHdpbGwgZ2V0IHRoZSBjaGlwIElEIGZyb20gdGhlIGJvb3Rsb2FkZXIgaW4gZHJp
dmVyIHRvIGRpc3Rpbmd1aXNoIHRoZSBjaGlwcy4NCg0KQmVzdCBSZWdhcmRzDQpTaGVycnkNCg0K
DQo+ICsNCj4gK3JlcXVpcmVkOg0KPiArICAtIGNvbXBhdGlibGUNCj4gKw0KPiArYWRkaXRpb25h
bFByb3BlcnRpZXM6IGZhbHNlDQo+ICsNCj4gK2V4YW1wbGVzOg0KPiArICAtIHwNCj4gKyAgICB1
YXJ0MiB7DQo+ICsgICAgICAgIHVhcnQtaGFzLXJ0c2N0czsNCj4gKyAgICAgICAgYmx1ZXRvb3Ro
IHsNCj4gKyAgICAgICAgICBjb21wYXRpYmxlID0gIm54cCxpdzQxNi1idCI7DQo+ICsgICAgICAg
IH07DQo+ICsgICAgfTsNCj4gZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMN
Cj4gaW5kZXggMzJkZDQxNTc0OTMwLi4yMTFmYzY2N2MwZWMgMTAwNjQ0DQo+IC0tLSBhL01BSU5U
QUlORVJTDQo+ICsrKyBiL01BSU5UQUlORVJTDQo+IEBAIC0yMjgzNSw2ICsyMjgzNSwxMyBAQCBM
OglsaW51eC1tbUBrdmFjay5vcmcNCj4gIFM6CU1haW50YWluZWQNCj4gIEY6CW1tL3pzd2FwLmMN
Cj4gDQo+ICtOWFAgQkxVRVRPT1RIIFdJUkVMRVNTIERSSVZFUlMNCj4gK006CUFtaXRrdW1hciBL
YXJ3YXIgPGFtaXRrdW1hci5rYXJ3YXJAbnhwLmNvbT4NCj4gK006CU5lZXJhaiBLYWxlIDxuZWVy
YWouc2FuamF5a2FsZUBueHAuY29tPg0KPiArUzoJTWFpbnRhaW5lZA0KPiArRjoJRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9ibHVldG9vdGgvbnhwLQ0KPiBibHVldG9vdGgu
eWFtbA0KPiArRjoJZHJpdmVycy9ibHVldG9vdGgvYnRueHB1YXJ0Kg0KPiArDQo+ICBUSEUgUkVT
VA0KPiAgTToJTGludXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0K
PiAgTDoJbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiAtLQ0KPiAyLjM0LjENCg0K
