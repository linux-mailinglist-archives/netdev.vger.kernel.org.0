Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA524FED3D
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 04:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiDMDCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 23:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiDMDCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 23:02:02 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2106.outbound.protection.outlook.com [40.107.117.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D3E2656C;
        Tue, 12 Apr 2022 19:59:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eFYyf7irUPImPdP4z68WTDVfq8XRaeb4AX+sO4pdBFsYELuH3hEH+mSEeu4lX7fR4JZuUp422PK3i3CvRfYbr9S2G/Jikpu1plAg4850gTfkp/d3GJtVjQRXIcOMHHP7xYJoEVzp51bqIvPesha8IIKa+dzSDkSGAqUk6mi1xbY5VxKDqCvS62WMyabbOFV4hx9RHXnePicCX5zL85hmXVYtc1N2uyYnvc2D7rcxppxlljfiBNcml8/ulMKhH+NsEU4qAVI3Md8SlGgJFBCOUbn+Di2L48rRVA722z1HabATFDIP2u+HpPGJ1F/SYkWxvlpBDmsxebB3GxsC5cRiMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZyZv3dOmDeZu1jwUZUbR+x288th++FMtn4TPPf6huto=;
 b=kl9KxnZ6SwXmSxOe8sXHFh5qFqmpspz6WgMpOMAk4yhftr6bMs4eiEkxeuZj9qjggUfg0XzEpmbneANsezhMdVEFBYCDrs335vmD/MP7PnSjU5O/BYm1/tkqWgIJczQe8tF7fo5P3OHoQYBb9r5J3aHWPqAg3IAg+aMpEW+SVliz/zX67IR9pdL66hEi0Ew2Q6VQ5du005heMxT2hHx0UYi5ZOih4DQIeFLnCaG0t9czSB9vJzuT/xOmXLIMOpgwhNih4G9eE0eUfPEuHBw5iVC/b19OtXKvAfqH5p92RsSR+l5PF2QoWI4S2aCuXk35PRPnuH38vWm5/BZ4XjPkOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZyZv3dOmDeZu1jwUZUbR+x288th++FMtn4TPPf6huto=;
 b=ea5BdOqrpkHfeqTB2u7SO+rPD4KO5eIJfx8sYwKLhE0HSe2k1BAnANZ7W4I/WHKaRPbZV01oJCd+N1fbVMTVUT+f3J8X9Y2Kqu0OUH1u/JKAlCSe2lCi0x3AVaeygyD5YdOZJVZQVlwt5VOc9vNJvf2szGF8Gsis02H8rrwlQubQ658kxou/be7jXxVjZCJ1i/EMQvMHqGMfrVdeBp+BD1QUUtF3i3E6GG0GhqOuq7I5f9jKIspTbDUkpOTXJZobJYaoY4P84rXt69gTyxBJY+2aByd9G9XQO5Yj97oEu6s1bm+FAw3B1UMRUo7kijzCqjeAoe/lJAiSp7cAY+hnyA==
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com (2603:1096:203:5c::20)
 by TY2PR06MB3085.apcprd06.prod.outlook.com (2603:1096:404:9e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 02:59:33 +0000
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::4b4:4f33:eaec:c5bd]) by HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::4b4:4f33:eaec:c5bd%4]) with mapi id 15.20.5144.030; Wed, 13 Apr 2022
 02:59:33 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Joel Stanley <joel@jms.id.au>
CC:     Rob Herring <robh+dt@kernel.org>, Andrew Jeffery <andrew@aj.id.au>,
        Andrew Lunn <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        devicetree <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        BMC-SW <BMC-SW@aspeedtech.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: RE: [PATCH v4 1/3] dt-bindings: net: add reset property for aspeed,
 ast2600-mdio binding
Thread-Topic: [PATCH v4 1/3] dt-bindings: net: add reset property for aspeed,
 ast2600-mdio binding
Thread-Index: AQHYTjokNbfsFUER4029SQZd/gJrbqztIXIAgAAGUUA=
Date:   Wed, 13 Apr 2022 02:59:32 +0000
Message-ID: <HK0PR06MB2834E93356A4C3ECBE48F71A9CEC9@HK0PR06MB2834.apcprd06.prod.outlook.com>
References: <20220412065611.8930-1-dylan_hung@aspeedtech.com>
 <20220412065611.8930-2-dylan_hung@aspeedtech.com>
 <CACPK8Xd0gh5pDafP3ysu7odhnP=YPNSYPV9u36CEoMPDtQxEJw@mail.gmail.com>
In-Reply-To: <CACPK8Xd0gh5pDafP3ysu7odhnP=YPNSYPV9u36CEoMPDtQxEJw@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f62a767-a738-4af2-b538-08da1cf9a2d5
x-ms-traffictypediagnostic: TY2PR06MB3085:EE_
x-microsoft-antispam-prvs: <TY2PR06MB3085A303CA6AE9574F9341D19CEC9@TY2PR06MB3085.apcprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uk1QREBR9jacAj90MlWfASTXDzTwoZYp71S1MMzNtdYWQOeXejV1u5G2p5q3HJHodJRLy8g8QyP7dFjZ2T2xw8mRlldwhzO+xdB/4vl4AgQ3Wtsm6ZqKhk4UJndtQMigecwziGD8Zf/JIh93UglgWnXSQAk2AFeFZAe4t70EXomP5+Cra3le3kWu7Bta0pQXWs7KDjWRhDVgu0nnTIz9NO1tT371AzNNlEBMAK/G3NtJ0VX26jjJzcuYf4Gfvffq5atP70GxhgBeyhLDE0O+qzouAcG66TRoRiqNCzCtjTxn9OfgcrtzmTrxLOwd1aFn3x2W0qe9MIEea3gNx33H//nPHldSPl2feEH7YK9l2gbdy/t0F01Eb+gbczQDlQzwxUhqUQ5lJwiwZwQO+rQdcGRZZL0nEotGBdB5Pnr9SI1HIF/jv/5ipnYISkstlIONhgX4qY8sHdh4JO68BiUNFds1TsqawCK1ilFVOsbylcJm7fQ2sQFHuJiy9iTIh4EUPbg8aRhRdaovYn22+tgC8MUKJRI59Fc1cyzwLn85zUdHyfzPldB2NC5DbqzNGRu1POWZAY0YTke2JIEEG3m6ULvveMcIeBGfDthRtqvWz4tFov4L/dQR36a1D29yUC67ukg0yk3QtBhVSl6K7bdPL87LCSaGKFBzUihHK+0r0aqWAJBGwjCcEYYLxN26NcIOAkVwk/bj/LllOiLbyIV7mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR06MB2834.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(346002)(376002)(136003)(39850400004)(366004)(55016003)(38100700002)(86362001)(33656002)(122000001)(83380400001)(66556008)(66476007)(53546011)(52536014)(71200400001)(38070700005)(7696005)(6506007)(2906002)(508600001)(8936002)(26005)(186003)(7416002)(6916009)(316002)(54906003)(4326008)(8676002)(9686003)(66946007)(76116006)(64756008)(66446008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFdpQWRUSjYyZkUrczVEOTNkZ2FIeTVLSEkrL0VZWFRjRFh5Q2JkcktibUFv?=
 =?utf-8?B?OFBpeFZMcEttSHdnaHlNaHlTOHg5TnVHU0E1aHFsQS9yejZiUklTWjA0QnFB?=
 =?utf-8?B?ckpyZ3RncjNzMmlsOE1iZVgyOXVZaThtRkhTdlFGbVFwS3gvZVF4dGdJTUF5?=
 =?utf-8?B?YUlhUGZnSm8rcGFYTkMza3pDZ2FCemw2ZkRpcUx3OGFORyt5aTFkNWhBS09W?=
 =?utf-8?B?enBpakRaWHpSRUdVWEMwWWxHdGw2eSt4aUFlQ1FjdHZiVkFEY0ZnUmNKUUdr?=
 =?utf-8?B?bzhLT0xPZDdCaWdrZXlKbHRLNjV0RkErVmdDVnBPaFNTNkxoR0pYa1NkSDBh?=
 =?utf-8?B?dVNpcmNQaHFyaHZDTTNMS1czYi9LVjU0bFQrU0IxNnV5eis5L0ZpOFIwV1VM?=
 =?utf-8?B?dTQ4YWJFaFhzdllPMnlYUzlESldENytHL29KekVsdUFWd25aQyt3akFQSlRp?=
 =?utf-8?B?aitBTUpKVHg0Y082dzVlc2ljQ0R3RVIvckJEbmxQWVNQNXdKTU1jb0xpS0Rp?=
 =?utf-8?B?blR5TzFiMU1LeXd5ZjBLMTVVMU8rNThmeUd0NGZGaHFPL1F1M2kwUlJCV1oy?=
 =?utf-8?B?MUVRbmhpOW1VeWVxemRuTGFmd21nZXVGdThTbHZsa2VWWmdzY2NTSitWM01m?=
 =?utf-8?B?OVA2UjI0YVNRZVppbmdGY05LVjFoN0R4ZFNoWWtMM0RTUWFlZVRLUTFIbDdt?=
 =?utf-8?B?djVrV08wcE54dVJrN3NhaDBPdkxUOEUvVmR4WWJCNnkvSkdMQ3pmNGx3REdz?=
 =?utf-8?B?QUphVUdoUm5GVlRKMjE0YzdGY0phd2RDNXhQdWhQRnNIdGhjdmRKVlMvTGl6?=
 =?utf-8?B?a1FtWFNGT0hQVGhsSElVZitqTnBCdXZma2hJamcvQ1RLVDBxWU5zV0R6eXps?=
 =?utf-8?B?UlU5RnhZKzJ0aXdlODErQjQ4dVpvZTdzUmloOUJpRlIreXBVQkRyelFFL2Ew?=
 =?utf-8?B?SVhxb2psY3VMU29qWjFEUG1NSmovOEs3SlV4R3ZYQ1lQR2pVdVp3NS9ZZUxk?=
 =?utf-8?B?ZWtNZXowd2J2SzlKOE9WaVBlMi9selBuTXdiWWs5dXFhUytzWEk2S3F1Skp3?=
 =?utf-8?B?QjA3L3FhUUpuUnNyTDB0QU9DaE4vbFdjZTg4RkJncEoweUxEaTlIaGZkRXQy?=
 =?utf-8?B?R255QnBCOXlkMkREQ1hJZFlKUDhYNjBVL0UzdXA5cHVmRGh3UTRHTWludTN1?=
 =?utf-8?B?cUhZV0wwdTFKcFEwT0JqMWxNa2hubmtJZWc4SGltT3ZHdEZjbTh1aTR3SVNG?=
 =?utf-8?B?YlorYmMxQWs4azk1YkRtL2dVeG9UL0NFRWlGVlFEdHJOc2FlU3Y4RkdZSDlZ?=
 =?utf-8?B?SkMzWUNYY3g2RFAvaGh4a3N4UEZOQ0hnK3NtbHlzVTFITTRzRGNoZ3c4SGVw?=
 =?utf-8?B?emxWQzdJaWlhb3JxOE43aVBpbFFad0FsYUxRZ2hpOHF1QkxXUFRNQzFWSFBR?=
 =?utf-8?B?ZFhiMmNJZlZ0TXVFRW5lSmtvRWJGcGdQSE9HeTh0Q0kweXNwZnVJT2FkdnNB?=
 =?utf-8?B?T2pmMmZxR1l1WFlDTEZoWllnUklmVGplVVZQUTc5YjNzSjdyeTVCZDI2UnFP?=
 =?utf-8?B?bEphWU45NzJXUGtBTTZkMlQ4MkZzWTdyWlIrSlRYQnRqY2RyT0tqN0xHWWdz?=
 =?utf-8?B?eGQ2dDR0QUhEWThscVRpRkFjQVNSbHI5N2pYbnpkQ1dlazFHYzZGUEg3S2dT?=
 =?utf-8?B?eXg2VlBsRkszR2s3a3NWLzJYaGRyY085NTZmVVlKeEJBb3ZJbjc5MXZpQVVm?=
 =?utf-8?B?YWMzNktXU1dYajZXSTFod2dIR0NnaDRFenFnWkc2citpZStiUy96ZVN2cXZE?=
 =?utf-8?B?UFBIc3d3dUppZDlQek5lQ0tPaTZtNGNHQkNoM2JLbTJUL1ZQRXJSdW9sTkpW?=
 =?utf-8?B?UU5FcmpUN0ZRZTBGdE9xeVNVZmpQK0xtaURWMm1YMFhHVnZKZ0lRcEhVMHo0?=
 =?utf-8?B?T3R0Y2ZSdC9td21QcEtTcm5PK2VvSUVkQkE3bjd6eUt1WVR4YS9NU1JjeURo?=
 =?utf-8?B?ekRWUWoyMEVqNXRBS1YrbzZ2Y01vdi9TZlB2Y1l1NnVCVnE1ZFVKOWVXWkJy?=
 =?utf-8?B?ZHNJZVZFa0xpQmlIMVY5MEozYU1kdVpVN01xVmd1UFd6cnhOQWhET080TEFl?=
 =?utf-8?B?dWRFYmlZcTFiU1JsOGo2TVF5MFBVaWhOdmkwdjJTTkR2QXR5cXUzVWRjVWxL?=
 =?utf-8?B?eUZQMjdDSnR1LzhBZlZTL3puSVZhVmh0L2RET1VPcG9maytPbU1tN2hPTW5u?=
 =?utf-8?B?VUs3VlBNNXBLQlpOamxacXJpZXNZdGdjT3d0aWZSc2UzV2lXVEtWUWkvem5x?=
 =?utf-8?B?cE9HV3JvTkJ4UWZKcFlYQnNCLzlpa3hUcWxGQlNIT21CUmF4eWpEV0xvOHhv?=
 =?utf-8?Q?+l6cjYXYS7UiskeY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR06MB2834.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f62a767-a738-4af2-b538-08da1cf9a2d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 02:59:32.9133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rY4mzJLlGMKhq+ufc/VXo2X2oP01Ray4HAHmAooIV1qkh0UY4G2V3HpYK4bJ0WxYGQdEKedyDCfD2WBiksn/Z8wZWAAHGXtbaUM2xS139a4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB3085
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2VsIFN0YW5sZXkgW21haWx0
bzpqb2VsQGptcy5pZC5hdV0NCj4gU2VudDogMjAyMuW5tDTmnIgxM+aXpSAxMDozNCBBTQ0KPiBU
bzogRHlsYW4gSHVuZyA8ZHlsYW5faHVuZ0Bhc3BlZWR0ZWNoLmNvbT4NCj4gQ2M6IFJvYiBIZXJy
aW5nIDxyb2JoK2R0QGtlcm5lbC5vcmc+OyBBbmRyZXcgSmVmZmVyeSA8YW5kcmV3QGFqLmlkLmF1
PjsNCj4gQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPjsgaGthbGx3ZWl0MUBnbWFpbC5jb207
IFJ1c3NlbGwgS2luZw0KPiA8bGludXhAYXJtbGludXgub3JnLnVrPjsgRGF2aWQgUyAuIE1pbGxl
ciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViDQo+IEtpY2luc2tpIDxrdWJhQGtlcm5lbC5v
cmc+OyBwYWJlbmlAcmVkaGF0LmNvbTsgUGhpbGlwcCBaYWJlbA0KPiA8cC56YWJlbEBwZW5ndXRy
b25peC5kZT47IGRldmljZXRyZWUgPGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnPjsgTGludXgN
Cj4gQVJNIDxsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc+OyBsaW51eC1hc3Bl
ZWQNCj4gPGxpbnV4LWFzcGVlZEBsaXN0cy5vemxhYnMub3JnPjsgTGludXggS2VybmVsIE1haWxp
bmcgTGlzdA0KPiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IE5ldHdvcmtpbmcgPG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc+Ow0KPiBLcnp5c3p0b2YgS296bG93c2tpIDxrcnprK2R0QGtl
cm5lbC5vcmc+OyBCTUMtU1cNCj4gPEJNQy1TV0Bhc3BlZWR0ZWNoLmNvbT47IEtyenlzenRvZiBL
b3psb3dza2kgPGtyemtAa2VybmVsLm9yZz4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NCAxLzNd
IGR0LWJpbmRpbmdzOiBuZXQ6IGFkZCByZXNldCBwcm9wZXJ0eSBmb3IgYXNwZWVkLA0KPiBhc3Qy
NjAwLW1kaW8gYmluZGluZw0KPiANCj4gT24gVHVlLCAxMiBBcHIgMjAyMiBhdCAwNjo1NSwgRHls
YW4gSHVuZyA8ZHlsYW5faHVuZ0Bhc3BlZWR0ZWNoLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiBU
aGUgQVNUMjYwMCBNRElPIGJ1cyBjb250cm9sbGVyIGhhcyBhIHJlc2V0IGNvbnRyb2wgYml0IGFu
ZCBtdXN0IGJlDQo+ID4gZGVhc3NlcnRlZCBiZWZvcmUgbWFuaXB1bGF0aW5nIHRoZSBNRElPIGNv
bnRyb2xsZXIuIEJ5IGRlZmF1bHQsIHRoZQ0KPiA+IGhhcmR3YXJlIGFzc2VydHMgdGhlIHJlc2V0
IHNvIHRoZSBkcml2ZXIgb25seSBuZWVkIHRvIGRlYXNzZXJ0IGl0Lg0KPiA+DQo+ID4gUmVnYXJk
aW5nIHRvIHRoZSBvbGQgRFQgYmxvYnMgd2hpY2ggZG9uJ3QgaGF2ZSByZXNldCBwcm9wZXJ0eSBp
biB0aGVtLA0KPiA+IHRoZSByZXNldCBkZWFzc2VydGlvbiBpcyB1c3VhbGx5IGRvbmUgYnkgdGhl
IGJvb3Rsb2FkZXIgc28gdGhlIHJlc2V0DQo+ID4gcHJvcGVydHkgaXMgb3B0aW9uYWwgdG8gd29y
ayB3aXRoIHRoZW0uDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBEeWxhbiBIdW5nIDxkeWxhbl9o
dW5nQGFzcGVlZHRlY2guY29tPg0KPiA+IFJldmlld2VkLWJ5OiBLcnp5c3p0b2YgS296bG93c2tp
IDxrcnprQGtlcm5lbC5vcmc+DQo+ID4gLS0tDQo+ID4gIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdz
L25ldC9hc3BlZWQsYXN0MjYwMC1tZGlvLnlhbWwgICAgICAgICB8IDUgKysrKysNCj4gPiAgMSBm
aWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdA0KPiA+IGEv
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9hc3BlZWQsYXN0MjYwMC1tZGlv
LnlhbWwNCj4gPiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvYXNwZWVk
LGFzdDI2MDAtbWRpby55YW1sDQo+ID4gaW5kZXggMWM4ODgyMGNiY2RmLi4xMTc0YzE0ODk4ZTEg
MTAwNjQ0DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9h
c3BlZWQsYXN0MjYwMC1tZGlvLnlhbWwNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvbmV0L2FzcGVlZCxhc3QyNjAwLW1kaW8ueWFtbA0KPiA+IEBAIC0yMCwxMCAr
MjAsMTQgQEAgYWxsT2Y6DQo+ID4gIHByb3BlcnRpZXM6DQo+ID4gICAgY29tcGF0aWJsZToNCj4g
PiAgICAgIGNvbnN0OiBhc3BlZWQsYXN0MjYwMC1tZGlvDQo+ID4gKw0KPiA+ICAgIHJlZzoNCj4g
PiAgICAgIG1heEl0ZW1zOiAxDQo+ID4gICAgICBkZXNjcmlwdGlvbjogVGhlIHJlZ2lzdGVyIHJh
bmdlIG9mIHRoZSBNRElPIGNvbnRyb2xsZXIgaW5zdGFuY2UNCj4gPg0KPiA+ICsgIHJlc2V0czoN
Cj4gPiArICAgIG1heEl0ZW1zOiAxDQo+ID4gKw0KPiA+ICByZXF1aXJlZDoNCj4gPiAgICAtIGNv
bXBhdGlibGUNCj4gPiAgICAtIHJlZw0KPiA+IEBAIC0zOSw2ICs0Myw3IEBAIGV4YW1wbGVzOg0K
PiA+ICAgICAgICAgICAgICByZWcgPSA8MHgxZTY1MDAwMCAweDg+Ow0KPiA+ICAgICAgICAgICAg
ICAjYWRkcmVzcy1jZWxscyA9IDwxPjsNCj4gPiAgICAgICAgICAgICAgI3NpemUtY2VsbHMgPSA8
MD47DQo+ID4gKyAgICAgICAgICAgIHJlc2V0cyA9IDwmc3lzY29uIEFTUEVFRF9SRVNFVF9NSUk+
Ow0KPiANCj4gWW91IHdpbGwgbmVlZCB0byBpbmNsdWRlIHRoZSBkZWZpbml0aW9uIGZvciBBU1BF
RURfUkVTRVRfTUlJIGF0IHRoZSBzdGFydCBvZg0KPiB0aGUgZXhhbXBsZToNCj4gDQo+ICNpbmNs
dWRlIDxkdC1iaW5kaW5ncy9jbG9jay9hc3QyNjAwLWNsb2NrLmg+DQo+IA0KPiBZb3UgY2FuIHRl
c3QgdGhlIGJpbmRpbmdzIGV4YW1wbGUgYnkgZG9pbmcgdGhpczoNCj4gDQo+IHBpcCBpbnN0YWxs
IGR0c2NoZW1hDQo+IA0KPiBtYWtlIGR0X2JpbmRpbmdfY2hlY2sNCj4gRFRfU0NIRU1BX0ZJTEVT
PURvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvYXNwZWVkLGFzdDI2MDAtDQo+
IG1kaW8ueWFtbA0KPiANCg0KVGhhbmsgeW91IGZvciB5b3VyIGNvbW1lbnQsIEkgaGF2ZSByZXBy
b2R1Y2VkIHRoaXMgZXJyb3IgYW5kIGZpeGVkIGl0IG9uIG15IHNpZGUuDQpUaGUgY2hhbmdlIHdp
bGwgYmUgaW5jbHVkZWQgaW4gVjUuDQoNCj4gQ2hlZXJzLA0KPiANCj4gSm9lbA0KPiANCj4gPg0K
PiA+ICAgICAgICAgICAgICBldGhwaHkwOiBldGhlcm5ldC1waHlAMCB7DQo+ID4gICAgICAgICAg
ICAgICAgICAgICAgY29tcGF0aWJsZSA9ICJldGhlcm5ldC1waHktaWVlZTgwMi4zLWMyMiI7DQo+
ID4gLS0NCj4gPiAyLjI1LjENCj4gPg0K
