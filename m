Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6414E375D
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 04:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbiCVDZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 23:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236166AbiCVDYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 23:24:14 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2097.outbound.protection.outlook.com [40.107.255.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B26F5AA47;
        Mon, 21 Mar 2022 20:22:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c42iLdIzFGbpz7nsZ2gImAcR53VbnhEH9iVZnxczSgEsZv9jEFyJuUAWVh+b/jOeL6Ii7VD6Vt9X/F9XVkLgNuWU3m+W12P7ArOhexjpyzHuZWAO2Pab/OVBwnGAdsu5CdM5IVSOztszWc1YQxGfrFUCTF5QQ6mMNgey9D9w6AcsEKhXmmAFKW3ESnNx725tS1oFCtGOQ7F2LAijo5PoA1X167RYwrXCUcOLzuC189viVlRqBNiwkUyXWIJxJF5b+poK3oxvgTUavEHDhy9yLEhPXRH30mXaCI7Ruz6hnRF2uPqZzyN4N+GMJxP2ShrU3HGPUoanrB0TuU7XE5FKbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wtV7DuuKRidHcfycZiKusnXUDA6vYF9DPk7UbgyP1mI=;
 b=FrgS3JRCUlRw/vS6OerOhL7hqRavrgNln+620h74wYebiKQMg5HOo6OWVuhYButq7/YwOvXitCibbRTUjY2ePILobCbGqN6NUqU7VMTwaaDzhurAimg8qAMVNuSX1OTqzHqQwfIp96UgF9RHV3duGid2sSPhLV2KUyD7Km5vIwMsXyNIyoC/kLlgvvWqi51jhY60zwR5mOZ8ykHEBVj/mYzpWE7stEJK8lsICh13ZgeLCG++4Wq6cVMD/afuYB5+fKH1lynbWxcb1hzgAlCsIGOZj+pvsP56kps8ykE5YN4BoB26CwHCkT0oREn8d5jqTHXqEr65nhOcrWk01qkDbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtV7DuuKRidHcfycZiKusnXUDA6vYF9DPk7UbgyP1mI=;
 b=cW9hZJQJNC+jkEBG+VBcnUJ0NYyXrzabQ9Y712Zfbdhxk3taXBBEGvUposkx8A1DiIJofe4J0hNmRrKtnqCW7gbr9EMPJCGAC81HmmRNWRyHwEIX+2SqFYMKWJSkglp/yr3ok7XhB+ALJCw0zH+2RjfEyG9HrCsb6U64WxTI008xKDPNeDGgoh4a+gS9XRo0MjLKZD2ViSrCBUUz3t0vsY7T/oTi1cKca4YZjB7TVvtINkxLRWgVTKuiaRbRcdI76saMw2mslTpYsWepfVlv7fsz+XW95vpY1WP3tdtvZsxfpweYPjVZu4z6X8/SRVKtzoopQyhbImPQzbVwdygtDg==
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com (2603:1096:203:5c::20)
 by HK0PR06MB3234.apcprd06.prod.outlook.com (2603:1096:203:85::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Tue, 22 Mar
 2022 03:22:37 +0000
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::e175:c8be:f868:447]) by HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::e175:c8be:f868:447%5]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 03:22:37 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Krzysztof Kozlowski <krzk@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BMC-SW <BMC-SW@aspeedtech.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] ARM: dts: aspeed: add reset properties into MDIO
 nodes
Thread-Topic: [PATCH v2 3/3] ARM: dts: aspeed: add reset properties into MDIO
 nodes
Thread-Index: AQHYPQnwNYsxHNQRykGxCSuH1L0VZ6zJ/XGAgACv7MCAAAqZgIAAA7wQ
Date:   Tue, 22 Mar 2022 03:22:37 +0000
Message-ID: <HK0PR06MB28348F925FEDA3853DD3489D9C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
References: <20220321095648.4760-1-dylan_hung@aspeedtech.com>
 <20220321095648.4760-4-dylan_hung@aspeedtech.com>
 <eefe6dd8-6542-a5c2-6bdf-2c3ffe06e06b@kernel.org>
 <HK0PR06MB2834CFADF087A439B06F87C29C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
 <Yjk722CyEW3q1ntm@lunn.ch>
In-Reply-To: <Yjk722CyEW3q1ntm@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7faafef6-a3db-4b8a-da33-08da0bb336d4
x-ms-traffictypediagnostic: HK0PR06MB3234:EE_
x-microsoft-antispam-prvs: <HK0PR06MB3234F0F831589E69A975A5949C179@HK0PR06MB3234.apcprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HbYiHv2gQF4f7K0vCIiRnPfDfVAwIW1t83yONFPa0fPEoxC7xXk3iaDb0cb/s/irZDUA9M5QV34sfLZMGBtdakr+wQbU2Wz289i+9YaseaA9qYW1qF37WJBA3SerLV3qWg1zzFxX+FjlPJAkoK+yhORxRGKW0LAXxNZX1k7Ig0e0Zoc1dHcR4h3/cJk4ER1Z+AM4mf3Q4gvmdskOAkZaZuCoDYsN2maQf1Tduc9IzoJ6tYatWbgz7+HQ0EL4ZhJ0RXaMBiTbF2gaqJYAZhngnq5Cd9j0w3Hl6XSniRC0+3SQzvHXY2VqOBsFZodk1daoVBypL7b+ROf5sS0d9JpOhgkX4BCrbuKbta1cI+6BeiJ7pJ/FAIiB/2nIyPmp44tmyy1hLUtfPdOIwvtNqs3HTMh/Dy5iSvkf2+0X0fshTSC4y40gkP0F6+RQhmQEN4qjHhJzIYHt0Aoo8AjlmzRVYH80ETZKTYYfIkysK+zXAlvIX2807+XzDZWqgvJPE/ycXl/QIBhSfirVeXo5YEP+DYq8cIXFaNRFKEnuMYMiMsgu58oENuQeC3tgW7IFZS21ZsEOK5p3vCGcm1jJcGX8eU/scg7+p+KdvINvviEmcysb95gw7RFHtAsHTRLuQhpi/q+SOh9DOa+WwMTlwy+D1AN1tAqaUTqI5gdKBTVVrNW+reX1uQu2x4PBRAUL/v3b+aRA+LJnhBUxbrOYMfw9tA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR06MB2834.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(346002)(39850400004)(396003)(366004)(52536014)(71200400001)(53546011)(2906002)(122000001)(508600001)(86362001)(66556008)(6506007)(7696005)(55016003)(64756008)(76116006)(8936002)(38100700002)(66446008)(54906003)(186003)(6916009)(9686003)(5660300002)(7416002)(4326008)(38070700005)(8676002)(66476007)(33656002)(26005)(316002)(83380400001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cE5ranV1bEJBNThGWjVwbklRNWU2ckFUbUxqT2JXYStlOUpYSDMydUMyQVQx?=
 =?utf-8?B?TFR0SkVqVkcwODU5cC84VnQ3cEVYMTJXaWRxaWp5blU3V2hiNnN3cDk2VnZJ?=
 =?utf-8?B?UUx4eVZUNFZkL1VSc1BiVkNlODVaMEVOd2J6dnQ4cDdRSzBTR3pwZTJKck45?=
 =?utf-8?B?czlKZTk4SE5oT1kzN1VYZTVtMTBJcHdLRnhaMHltV1pPM2tVMUJ2Y0lONWhZ?=
 =?utf-8?B?MnBPWjJRYUN0KzdPNEpBYWRxSDIzNUhBY2E3KytHVGY1WTh4elZPSkFMbm9x?=
 =?utf-8?B?b3VLTTVUZEJTWURYeFhqUmNXMmVjK0ZVQ0xFNDdITHcrK2lmY0xORnB1RDV6?=
 =?utf-8?B?aEd6ZDJiVlh1a1hyeUVkRmxrZktweUlxRUFTdkdoMmRuNVZMQy9PeEVpRVQ1?=
 =?utf-8?B?NjdBdXdxYTNMZmtEbHBxZjRISkZ0bklFSzI3Wk9iVEdiQkVRdk14UW9peU9z?=
 =?utf-8?B?NnVob29TbkxGQU1WcnRkaVdqM0htZkYzaFRtY3lQR1pvSEFPVUJLMkE4M0Y4?=
 =?utf-8?B?eUlucVJWcEdTeFlqbG1jMkwyOXg2TW4wRFdxUG9TemVJS1ovWHNjTE5oQnZ5?=
 =?utf-8?B?ekVQVmRwbktxMWNrR29JY3BhSzUxZVNpS2s1U2tSa21ESzQ0a0IwMFJUSno4?=
 =?utf-8?B?alJ3MjIva0llSzVoNjh2Uk1YSE8yK2E5SFFJRXZaSm5LMHRqVWpXQjlIM1ly?=
 =?utf-8?B?Zk9PWFNHT0FnbjhReUc2Q2g4VzZ1eW9MMlY5alV6c0duTUxCa1h2L1ZzSVlO?=
 =?utf-8?B?TGVjNGhVd1BYeWJPdHlkam82dHp1Y3JKRkhkeDNTeTBSNzFLd2dSTkExV3Y3?=
 =?utf-8?B?T0kyQWdxYjhXYnEvQXFOaXNJMHdqUW5XRkg4ajAyVWRlOEJnTk5PNjZ3eEFR?=
 =?utf-8?B?aEI2cHhZK1c4TU1zMmhSQjh6M2tlUFdrQUFQTUFwY3JCZ3htcXNUYlkzUTNw?=
 =?utf-8?B?ZTl6aFBRL09STCs5ckk3c05oemxXZ0cvaERUTTNjWk5zcWlEQ2J2ajZ6TmF2?=
 =?utf-8?B?NnpQZkViaTQ2dlYxeHBuL3BlVmNGZTM1ZmJ5MkRlbUNkNlhaR3pwSFJqM2l6?=
 =?utf-8?B?eERaZ3hmZ3RtcmdyeGFSSGNtdlJoUmQwUTFuVUYvOGlFWXVlZE5uekVnY1JH?=
 =?utf-8?B?am04WVJSdDFuMFcyWStyWFpWK1lyM3QvVkRmTk90Ull5bmk4N0s0Y1gxNUQ0?=
 =?utf-8?B?cmJ6OVkwWUFkbGpZTjJKWUhNWm9oUk5rK05KUTloTmRUYk0wRDZ3YVVBdlgv?=
 =?utf-8?B?SkFITHk3ZW1JZlZFc3JZcXJEa3c3TkNzS0Rra0YycFRKRGFiSHdpN0xjVVZT?=
 =?utf-8?B?UkM0VmZaazFtTVZEWHI1QTNXL0lFWDE2Q0xYTFRtWHorWnJMelBvT1FZUkMv?=
 =?utf-8?B?VUljckxUcTZSMFVJVkc4MGFCRXgvUjFJN2o1NS8zWmFVYUs2Ri9XUnVvSlZX?=
 =?utf-8?B?Z2NDK0VrVUFRNWFKYkVUZFhoMmszcysybnF0dE0vbWlNRHFQTnpxMHUvVHRa?=
 =?utf-8?B?dFBHS3lJRnZkT1EyVkN5emc1ZkhqeEpHd2YzUFhxWHlqZkNiTzBpcmo5Szdl?=
 =?utf-8?B?RitmWm5MU2NaaHNvR3VoRDcyV0FNbi9MSnIrd1NOT3VXb2R6YkxwOVZVK3pH?=
 =?utf-8?B?ZzVGUnVBRFdmVzQrK3dmTE0yTUVnb1ZwMXFIZVlRZDdScG9hd3YyZFlEWHE4?=
 =?utf-8?B?eDdpcWtLL1RWSHlmU0JhSGFDTld5TmI3OXpBOVBPMTRLa3pxclZqNzZZc1FS?=
 =?utf-8?B?ZWdtWVlyY2xEUFFkdEpjWGt3NXNGY2svbHVTQmc3cXVWR1Z6OEZtc0ZpWHI3?=
 =?utf-8?B?UkNzMzB4Rm0wNXo3U2ZVSWh4cHBYdkhNTkIrSEVEbFFJM2dTU0UraURrVm9M?=
 =?utf-8?B?aksveDROdmE0L3FQSmNTUnhtVS9IdUJoZytUWnd6U0J1NmozOWFSdzNhSjNG?=
 =?utf-8?B?YmNOeldnTGdCdGJBVmpHdExTcFpMS2E5bVNLSUFram1HcFlML3M0U2dxdm5s?=
 =?utf-8?B?Rm9IZXk4NTZRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR06MB2834.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7faafef6-a3db-4b8a-da33-08da0bb336d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 03:22:37.2379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uXaxBNPr2rA/pbtFgTq7K7OpDKPkwOrlcmnozlXUwdu8IzEOCcs+5+JaPtDbTNRwh9SQhXk/7YHi5NUcWjwPWcQZX1kFjf8LiqlqsHnSsyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB3234
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmRyZXcgTHVubiBbbWFpbHRv
OmFuZHJld0BsdW5uLmNoXQ0KPiBTZW50OiAyMDIy5bm0M+aciDIy5pelIDExOjAxIEFNDQo+IFRv
OiBEeWxhbiBIdW5nIDxkeWxhbl9odW5nQGFzcGVlZHRlY2guY29tPg0KPiBDYzogS3J6eXN6dG9m
IEtvemxvd3NraSA8a3J6a0BrZXJuZWwub3JnPjsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiBqb2Vs
QGptcy5pZC5hdTsgYW5kcmV3QGFqLmlkLmF1OyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsNCj4gbGlu
dXhAYXJtbGludXgub3JnLnVrOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7
DQo+IHBhYmVuaUByZWRoYXQuY29tOyBwLnphYmVsQHBlbmd1dHJvbml4LmRlOyBkZXZpY2V0cmVl
QHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3Jn
OyBsaW51eC1hc3BlZWRAbGlzdHMub3psYWJzLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgQk1DLVNXDQo+IDxCTUMtU1dAYXNwZWVk
dGVjaC5jb20+OyBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
djIgMy8zXSBBUk06IGR0czogYXNwZWVkOiBhZGQgcmVzZXQgcHJvcGVydGllcyBpbnRvIE1ESU8N
Cj4gbm9kZXMNCj4gDQo+IE9uIFR1ZSwgTWFyIDIyLCAyMDIyIGF0IDAyOjMyOjEzQU0gKzAwMDAs
IER5bGFuIEh1bmcgd3JvdGU6DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+
ID4gRnJvbTogS3J6eXN6dG9mIEtvemxvd3NraSBbbWFpbHRvOmtyemtAa2VybmVsLm9yZ10NCj4g
PiA+IFNlbnQ6IDIwMjLlubQz5pyIMjHml6UgMTE6NTMgUE0NCj4gPiA+IFRvOiBEeWxhbiBIdW5n
IDxkeWxhbl9odW5nQGFzcGVlZHRlY2guY29tPjsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiA+ID4g
am9lbEBqbXMuaWQuYXU7IGFuZHJld0Bhai5pZC5hdTsgYW5kcmV3QGx1bm4uY2g7DQo+ID4gPiBo
a2FsbHdlaXQxQGdtYWlsLmNvbTsgbGludXhAYXJtbGludXgub3JnLnVrOyBkYXZlbUBkYXZlbWxv
ZnQubmV0Ow0KPiA+ID4ga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsgcC56YWJl
bEBwZW5ndXRyb25peC5kZTsNCj4gPiA+IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51
eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7DQo+ID4gPiBsaW51eC1hc3BlZWRAbGlz
dHMub3psYWJzLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gPiA+IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+IENjOiBCTUMtU1cgPEJNQy1TV0Bhc3BlZWR0ZWNoLmNv
bT47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIg
My8zXSBBUk06IGR0czogYXNwZWVkOiBhZGQgcmVzZXQgcHJvcGVydGllcw0KPiA+ID4gaW50byBN
RElPIG5vZGVzDQo+ID4gPg0KPiA+ID4gT24gMjEvMDMvMjAyMiAxMDo1NiwgRHlsYW4gSHVuZyB3
cm90ZToNCj4gPiA+ID4gQWRkIHJlc2V0IGNvbnRyb2wgcHJvcGVydGllcyBpbnRvIE1ESU8gbm9k
ZXMuICBUaGUgNCBNRElPDQo+ID4gPiA+IGNvbnRyb2xsZXJzIGluDQo+ID4gPiA+IEFTVDI2MDAg
U09DIHNoYXJlIG9uZSByZXNldCBjb250cm9sIGJpdCBTQ1U1MFszXS4NCj4gPiA+ID4NCj4gPiA+
ID4gU2lnbmVkLW9mZi1ieTogRHlsYW4gSHVuZyA8ZHlsYW5faHVuZ0Bhc3BlZWR0ZWNoLmNvbT4N
Cj4gPiA+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+DQo+ID4gPiBQbGVhc2Ug
ZGVzY3JpYmUgdGhlIGJ1ZyBiZWluZyBmaXhlZC4gU2VlIHN0YWJsZS1rZXJuZWwtcnVsZXMuDQo+
ID4NCj4gPiBUaGFuayB5b3UgZm9yIHlvdXIgY29tbWVudC4NCj4gPiBUaGUgcmVzZXQgZGVhc3Nl
cnRpb24gb2YgdGhlIE1ESU8gZGV2aWNlIHdhcyB1c3VhbGx5IGRvbmUgYnkgdGhlDQo+IGJvb3Rs
b2FkZXIgKHUtYm9vdCkuDQo+ID4gSG93ZXZlciwgb25lIG9mIG91ciBjbGllbnRzIHVzZXMgcHJv
cHJpZXRhcnkgYm9vdGxvYWRlciBhbmQgZG9lc24ndA0KPiA+IGRlYXNzZXJ0IHRoZSBNRElPIHJl
c2V0IHNvIGZhaWxlZCB0byBhY2Nlc3MgdGhlIEhXIGluIGtlcm5lbCBkcml2ZXIuDQo+IA0KPiBT
byBhcmUgeW91IHNheWluZyBtYWlubGluZSB1LWJvb3QgcmVsZWFzZXMgdGhlIHJlc2V0Pw0KPiAN
ClllcywgaWYgdGhlIG1kaW8gZGV2aWNlcyBhcmUgdXNlZCBpbiB1LWJvb3QuDQoNCj4gPiBUaGUg
cmVzZXQgZGVhc3NlcnRpb24gaXMgbWlzc2luZyBpbiB0aGUga2VybmVsIGRyaXZlciBzaW5jZSBp
dCB3YXMNCj4gPiBjcmVhdGVkLCBzaG91bGQgSSBhZGQgYSBCdWdGaXggZm9yIHRoZSBmaXJzdCBj
b21taXQgb2YgdGhpcyBkcml2ZXI/DQo+IA0KPiBZZXMsIHRoYXQgaXMgbm9ybWFsLiBJZGVhbGx5
IHRoZSBrZXJuZWwgc2hvdWxkIG5vdCBkZXBlbmQgb24gdS1ib290LCBiZWNhdXNlDQo+IG9mdGVu
IHBlb3BsZSB3YW50IHRvIHVzZSBvdGhlciBib290bG9hZGVycywgZS5nLiBiYXJlYm94LiBZb3Ug
c2hvdWxkIGFsc28NCj4gY29uc2lkZXIga2V4ZWMsIHdoZXJlIG9uZSBrZXJuZWwgaGFuZHMgb3Zl
ciB0byBhbm90aGVyIGtlcm5lbCwgd2l0aG91dCB0aGUNCj4gYm9vdGxvYWRlciBiZWluZyBpbnZv
bHZlZC4gSW4gc3VjaCBhIHNpdHVhdGlvbiwgeW91IGlkZWFsbHkgd2FudCB0byBhc3NlcnQgYW5k
DQo+IGRlYXNzZXJ0IHRoZSByZXNldCBqdXN0IHRvIGNsZWFuIGF3YXkgYW55IHN0YXRlIHRoZSBv
bGQga2VybmVsIGxlZnQgYXJvdW5kLg0KPiANCj4gQnV0IHBsZWFzZSBkbyBub3RlLCB0aGF0IHRo
ZSByZXNldCBpcyBvcHRpb25hbCwgc2luY2UgeW91IG5lZWQgdG8gYmUgYWJsZSB0bw0KPiB3b3Jr
IHdpdGggb2xkIERUIGJsb2JzIHdoaWNoIGRvbid0IGhhdmUgdGhlIHJlc2V0IHByb3BlcnR5IGlu
IHRoZW0uDQo+IA0KDQpUaGFuayB5b3UuIEkgd2lsbCBsZXQgdGhlIHJlc2V0IHByb3BlcnR5IGJl
IG9wdGlvbmFsIGFuZCBtb2RpZnkgdGhlIGVycm9yLWNoZWNraW5nDQppbiB0aGUgZHJpdmVyIGFj
Y29yZGluZ2x5IGluIFYzLg0KDQoNCj4gCUFuZHJldw0KPiANCj4gDQoNCg==
