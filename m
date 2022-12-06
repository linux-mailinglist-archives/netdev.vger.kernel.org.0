Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A98643BC1
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 04:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbiLFDSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 22:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiLFDSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 22:18:15 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C407233BB;
        Mon,  5 Dec 2022 19:18:12 -0800 (PST)
X-UUID: d5041b9580f646cdb7638cc3b0de4733-20221206
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=kxsmeDJfpY5B707xuoNebRQ+4JLbCPkJQJwRxyRSZsw=;
        b=OTAFCM2VLQj4TDDho5fhSZbxHb05G25hVTCiegpVCN528lkZbbRSpR7N0Weclbsa7GU2H0XWA4gNEtGrgiZNyd6tEE2iwJ1HK5Oi9FBU2nbZ/t7wG3hi510y3J2KekC/ecynxkuHoKxhH+12fqja5KkcIRlBkfXQyJxenSwtMWs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:4add4c25-fe52-44cd-9d0a-d43906df133e,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.14,REQID:4add4c25-fe52-44cd-9d0a-d43906df133e,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:dcaaed0,CLOUDID:22316924-4387-4253-a41d-4f6f2296b154,B
        ulkID:221206111808NZZB4C0E,BulkQuantity:0,Recheck:0,SF:38|17|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: d5041b9580f646cdb7638cc3b0de4733-20221206
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <sujuan.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 290679297; Tue, 06 Dec 2022 11:18:07 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Tue, 6 Dec 2022 11:18:05 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Tue, 6 Dec 2022 11:18:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nI+6AquWG3uUS6DFGQT/jIbnZzQNEadDQFd2Qm3SJ3KDtB+IpFezlhY/fi/xLJt2IKJhlm4One1Ahexm358kkL7G0fIB2lTTtJAvw1dNujIiCXP3R0B1C54jBc3amh4ZVKslD9I7cGS9uUAi9n710enT5jvge8PCIvvI7PfHvX4pym1Q8lDRr17WSTUQuOU4aYiJclU1I7XNYtVteZtL+o1X16ededqL9zBlvfz5oCPpXP3OOFJo5pRReebvoO4TqMB2AaXSibS8+cH7gpPB0PRzrs9YQhEU+dCF3e6RqrE2XVLZbedqquKIdkOYkI5MOp69ohcMRnlEFpUEtZFqRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxsmeDJfpY5B707xuoNebRQ+4JLbCPkJQJwRxyRSZsw=;
 b=guhSe6HjT0H1NYX8y/1OF0uJpyXnbUOYZv6sRU/xXZOUU1loeANgg44dAC71eFdjBqUWZYduNVvZKJoawqOn/OByHKG4x69BgQvEYVoFlPcWz8GDiYK7otIyOMbmhat4QIuI7D7lIh78sbjKnGuQpZ/uX5IFmqr/lemwJHl/5nxd0A/kDTj9mEJHPl1mVB5NGU3q9pH+4aOpmyODWbztvqZIejOU8XyUK+j3V2KHfpLT1KIs//xKy3XuH7bmeoOxHk4HhqYq5uMfxnyF4opJCKUMN2aKpIKEXkOAPHsex2Ickx4N/Yf9uQUfnx2wXCVITbwSjhPG7wd39dLlPWs7qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxsmeDJfpY5B707xuoNebRQ+4JLbCPkJQJwRxyRSZsw=;
 b=YLIzegT8u31dHS9NNPR94FCv7Evx2em5sdY3xFeDiOInFNKzWivcxVhkSEms60bTKEGs+K5f/uR8rpPAuhG9YlNG3rn3HOcLqMukrUbaoQxx2MgidBAU9zSVnXI9Dt7S8aLm8qqTHIWQ4lipB6y/4wK8ff7WJLyZBwXLjkh8Lu8=
Received: from PS1PR03MB3461.apcprd03.prod.outlook.com (2603:1096:803:42::12)
 by TYZPR03MB6470.apcprd03.prod.outlook.com (2603:1096:400:1ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 03:18:03 +0000
Received: from PS1PR03MB3461.apcprd03.prod.outlook.com
 ([fe80::59d3:5acf:4c76:d28]) by PS1PR03MB3461.apcprd03.prod.outlook.com
 ([fe80::59d3:5acf:4c76:d28%7]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 03:18:03 +0000
From:   =?utf-8?B?U3VqdWFuIENoZW4gKOmZiOe0oOWonyk=?= 
        <Sujuan.Chen@mediatek.com>
To:     "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>
CC:     =?utf-8?B?TWFyay1NQyBMZWUgKOadjuaYjuaYjCk=?= 
        <Mark-MC.Lee@mediatek.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?utf-8?B?RXZlbHluIFRzYWkgKOiUoeePiumIuik=?= 
        <Evelyn.Tsai@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "nbd@nbd.name" <nbd@nbd.name>,
        "john@phrozen.org" <john@phrozen.org>,
        Sean Wang <Sean.Wang@mediatek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@makrotopia.org" <daniel@makrotopia.org>,
        "Ryder Lee" <Ryder.Lee@mediatek.com>,
        "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        =?utf-8?B?Qm8gSmlhbyAo54Sm5rOiKQ==?= <Bo.Jiao@mediatek.com>
Subject: Re: [PATCH v3 net-next 2/8] dt-bindings: net: mediatek: add WED RX
 binding for MT7986 eth driver
Thread-Topic: [PATCH v3 net-next 2/8] dt-bindings: net: mediatek: add WED RX
 binding for MT7986 eth driver
Thread-Index: AQHY72bQ2LpVhoe9PUWl8GI45OiBp64tTYyAgAAwCdKAAAgcAIAFvBcAgAFWKIA=
Date:   Tue, 6 Dec 2022 03:18:03 +0000
Message-ID: <323e31e3ace1ed15bf8d1c009389fb9c6eca561e.camel@mediatek.com>
References: <cover.1667466887.git.lorenzo@kernel.org>
         <2d92c3e282c6a788e54370604f966fc7a5b479bf.1667466887.git.lorenzo@kernel.org>
         <6d1bd86e-29f0-a3b2-700b-978d64990d56@linaro.org>
         <Y2P/jq34IjyM2iXu@lore-desk>
         <aa7e325f-2986-005a-3d0a-579ac46491f6@linaro.org>
         <Y2QImkLcWIcwiTjW@lore-desk>
         <62fcc16e-51cb-fee4-ca8d-3ff546552595@linaro.org>
In-Reply-To: <62fcc16e-51cb-fee4-ca8d-3ff546552595@linaro.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PS1PR03MB3461:EE_|TYZPR03MB6470:EE_
x-ms-office365-filtering-correlation-id: 5d92422c-9383-4218-192b-08dad7387cb8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0A5pMJgdqdiqd0xKKrore3fQwd9/4Po3ts3STRYz+0YicY+D+OrKUphVGcmSWq4qyb6525NqJc6wxTB0O6PBWqWkE0fXsNggh76oxWkQEzkeaGGofRF+egNfKT94Dme2psHROOmPwLxdV8wMw5cvDQGVRFRj/FPZ0hZsHVEDKK+qmv0ZbuUIiAW3WxWUl/rnYCs4EuPv1zFI9W494Wvwlx12323COVkPDzMvIvRbGXIje8RrIyX/wUpkrB3v6JfXTtZC30Ww3G0S0fFXgJYN90JWmM/QtDiasxFn8/IYWVNnhpaj3Q1G4MGr0UlOj3jpm+KB9qZ1btc+fuFZd56ORhw3Tko57Js6dYrUa5M95MchR1Ohlgxfs4jnTm+YiBxpi4G3DFX5SxP6G57737P9IlM4UvBLviPHiTDpiV3c5mywlT5HoS1uvxcANVzteGoZLqk2uYXgHzQB8vVroTXeJGimGcDZ61U1oAfwXJPum49VwrqtYBcfw9gZDzKzCqdcOsSMtfO28J1a8bhZEH0BMr90MC74JTq8UZ8VgeHp3ca8AgE9jgdT4b12J9+1AV1I7qsaQZvEr+Uj0ZVja9ufZmqP3hPcrlparYLG7GwEhwWo4ZkNzTcpMeUO0MkeRxUzlxG1VzIe7ESyiXSDmnKxxp9IW4L/RLrZY9wQx24UF7Gm5pnnQyWteuI1ssiZq+xH0mwmMEBig8VdXuAfJwx+bzJqoDmhPSV+HMo7wvGXmTi4o9l8gTG7f3l8tatSe22m4hS/+S4Nw3AOjzZ7h+lUgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS1PR03MB3461.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199015)(83380400001)(71200400001)(41300700001)(38100700002)(54906003)(110136005)(36756003)(85182001)(316002)(4326008)(8676002)(122000001)(64756008)(66476007)(66556008)(66446008)(2616005)(86362001)(91956017)(76116006)(66946007)(2906002)(6506007)(53546011)(6512007)(38070700005)(186003)(26005)(8936002)(478600001)(966005)(5660300002)(6486002)(7416002)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UzNmLytxdFBxb3JOQ2lmKzFmYjlLbUFXTm8zanc1L1h0bDBzc1QvN20vektV?=
 =?utf-8?B?ZzhUT0grbzNJb09SdXdzVFlDQnN0MWd2OWNFZlNET2hKWTlTVm5ySHNtOGxH?=
 =?utf-8?B?MFh5bERaaWowQVRQVlBjN05Qems1MzhpY3gyRXp4VTg5K2pNTEtIbnFVWVAz?=
 =?utf-8?B?M0habVl3MkFlYnE4WVcrSE8weEpIZy8vUmUyRG9ObG9nYmFzVnQyMzFkV2d3?=
 =?utf-8?B?V1hOM2Q1bW5waEhiTS9xZm10SS9WbE4vbFNrYTlmWExZeGJGbnV4TDUvSDE3?=
 =?utf-8?B?ajF3SWNGR05zVHNkK3dvY3htdnFLNk5BazlaWitOUHRrOE83djg1M3pVRnBN?=
 =?utf-8?B?UmU2bi9TeEZKbE0rMUNoSXd5M1F0L3poMU03OXh3R2lBanplNm5mRzBCVjlR?=
 =?utf-8?B?aWsvSTRHbnIzckNrUG5ybGU3M3kvMFZDNVcrRUFXdWkxdmJTZitCRG82SlRr?=
 =?utf-8?B?SUVEazRiekNtQVY0aWtuM1k3REdPZjM5Tzk4bUZEYW9oaU5CbWlPUkF4ZG13?=
 =?utf-8?B?Zk1ubmJuMVJUbGZJNGU5R3V6YlpINXJnTHVrNnR5TUtnSEYrZytndXlyREVV?=
 =?utf-8?B?WXVtSzRqM3NpWFc5TGlMdkdsRGRDd3lQcnA1S3JMN2NKa2tuNGtPUGlQZ0ZS?=
 =?utf-8?B?SHNyTW5mNUh6cFN2ZDVTd20vNXV2WC92QTNLY3ozL3NPTGNMMUNZNlMxQzRl?=
 =?utf-8?B?VmczS3lWMnBVODgrcWVCM3V5U3FnbGF3MmEzMWFsdVRGMDhEOFZXdHVNdzQy?=
 =?utf-8?B?cERrQ1R5NW1GYk1za3JGVlB1b0VhN1BOckx2M1F2ZDExTDRQU2UzTjIyRkYv?=
 =?utf-8?B?bFJnTzY5dWRtSnBEUWsrOFBOM3VOOXdzcUo3eUhTYSttcVdCcWJZL052MXlt?=
 =?utf-8?B?OFNCWHZtVWJLMkljUDRaY3hLRTlodFhBVlNEUFZ5U2JCclVWYVZmd05qand5?=
 =?utf-8?B?VGxaYzc0NWRpbkhLUHRBMDdhQ0ZJcnNsZm1YK0xEZEV2eDF4MFovaDN2Ylcx?=
 =?utf-8?B?M09pQUY1ckc3NlZ2NGV1ZjhEYVRRTWxOK1ZLWTlWNzg2SDQ5aXduZUJ4L04z?=
 =?utf-8?B?TVY5VGlSbVRFajZDY3lLcHIxNXpyYVJWOVJpZUFvdUc1eGdlV0EyQnNiRlJP?=
 =?utf-8?B?V1NqbVo3WEdQRk9VMlhMZ2RiYmduM1ZjK2plSnIrd2d4SFRra0pJUi94MXhh?=
 =?utf-8?B?Nmt0NFQxbjI4dWxqcTRWSGRsYkU4dW9NWTdKOGU1Nnl0T0ZhNVBZZzc2eEgz?=
 =?utf-8?B?UklMQzlQb0c5QlREdlhvWmZwcXljeDhkc2V5a1NNK3VvaS9UbWk1MzVFWFp4?=
 =?utf-8?B?R2NCVVNoZHhjV0sySVVoc0pPWFFYRzV0aEowYUJEay9hdjhXWnlEblNOdXVn?=
 =?utf-8?B?bGNKdFJhc0dEWDhzaWF0Tk01TkQ4Z0Q5QkNBU2hNaFZpZWk4MnJxUEdsbGc4?=
 =?utf-8?B?UmFrdmVGYWkyZEJWUG96R015WGxJb2RvRkJqZnc1N3BzZnBiM2h2REx3NHo3?=
 =?utf-8?B?OFZLL3g4SlJ2K1JjVWRGY1phM2JBaHV4dWNxcW1CSEZGN0ZYeHBlWjE3UjlR?=
 =?utf-8?B?YmQ3aWY1QklIUjBCeGhtQXJFV1NNUHBYOTlzM2RHMXg5WitHZk5JWVRwV2xk?=
 =?utf-8?B?SGQ1dEh2YitlWS80MW1TSEZnYjJTVTVzRy9LMjdxZFRnRlliYTNkNnB6Z3Jy?=
 =?utf-8?B?eGtUck9YdXNBeTVhZTFvb3YycXdpN3FNT2lDZ3JLVGlJQlhpQ3lmVzdKUWpI?=
 =?utf-8?B?Q3ozU2FyWkRrMHE2MGYwbEZ0UHgzcTFuSk5sTjd3M3hvbm9TZWFrTnJHTmxz?=
 =?utf-8?B?Y0dmb21YdjRVWUtaN01nNnpXcURTWnZTSWF5WXhSd0xvMVBGRVlud3J6Ris0?=
 =?utf-8?B?MTlvWDZ3Ym9TK0N6Zkp5UnVGbG9DeEd6SDFDWGdLTjBZMXRpUzB2SVk3N2xJ?=
 =?utf-8?B?VlUyR3RWL0p3MzQrRUMyT2l5V2NoY20zTUkyMTNXMUo4cFcyVlhrMTdOYkxm?=
 =?utf-8?B?WWZWTUg3RU1LQ3pkMmgzYmN0dkJSZlFOQy9oTXFPOU5qSUV3SUlTeGdVaWhF?=
 =?utf-8?B?Z3ZZaEhtMUV6eTRSZVIyeUtZb3NKL1I4RzhjdThRRVFzR2xCS3Y3UDE0Tith?=
 =?utf-8?B?VDExWmNlL3V5WHExaHlWT1VqaHJscVU3RERmWnBLcGNXQ09RL295a01RTGlE?=
 =?utf-8?B?UkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <37D2F7484F6E2E409584BE769BB967AB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PS1PR03MB3461.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d92422c-9383-4218-192b-08dad7387cb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 03:18:03.6458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V0odrt6Ytq2nex9XqNDvD76vltWVLB/6TfH03qjjdRnBvgQBIwcsKU/rkSbZnAjyjr/wh+a9TwC/EVC/+GPC7WVwmfPzhAm4iRrnyQp/qZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6470
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTA3IGF0IDExOjA0ICswMTAwLCBLcnp5c3p0b2YgS296bG93c2tpIHdy
b3RlOg0KPiBPbiAwMy8xMS8yMDIyIDE5OjI5LCBMb3JlbnpvIEJpYW5jb25pIHdyb3RlOg0KPiA+
ID4gT24gMDMvMTEvMjAyMiAxMzo1MSwgTG9yZW56byBCaWFuY29uaSB3cm90ZToNCj4gPiA+ID4g
PiA+IGRpZmYgLS1naXQNCj4gPiA+ID4gPiA+IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2Jp
bmRpbmdzL2FybS9tZWRpYXRlay9tZWRpYXRlayxtDQo+ID4gPiA+ID4gPiB0Nzk4Ni13by1ib290
LnlhbWwNCj4gPiA+ID4gPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL2Fy
bS9tZWRpYXRlay9tZWRpYXRlayxtDQo+ID4gPiA+ID4gPiB0Nzk4Ni13by1ib290LnlhbWwNCj4g
PiA+ID4gPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gPiA+ID4gPiBpbmRleCAwMDAwMDAw
MDAwMDAuLjZjM2M1MTRjNDhlZg0KPiA+ID4gPiA+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ID4gPiA+
ID4gKysrDQo+ID4gPiA+ID4gPiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9h
cm0vbWVkaWF0ZWsvbWVkaWF0ZWssbQ0KPiA+ID4gPiA+ID4gdDc5ODYtd28tYm9vdC55YW1sDQo+
ID4gDQo+ID4gUmVnYXJkaW5nICJtZWRpYXRlayxtdDc5ODYtd2VkIiBjb21wYXRpYmxlIHN0cmlu
ZyBpdCBoYXMgYmVlbiBhZGRlZA0KPiA+IHRvDQo+ID4gbXQ3OTg2YS5kdHNpIGluIHRoZSBjb21t
aXQgYmVsb3c6DQo+ID4gDQo+ID4gY29tbWl0IDAwYjk5MDM5OTZiM2UxZTI4N2M3NDg5Mjg2MDZk
NzM4OTQ0ZTQ1ZGUNCj4gPiBBdXRob3I6IExvcmVuem8gQmlhbmNvbmkgPGxvcmVuem9Aa2VybmVs
Lm9yZz4NCj4gPiBEYXRlOiAgIFR1ZSBTZXAgMjAgMTI6MTE6MTMgMjAyMiArMDIwMA0KPiA+IA0K
PiA+IGFybTY0OiBkdHM6IG1lZGlhdGVrOiBtdDc5ODY6IGFkZCBzdXBwb3J0IGZvciBXaXJlbGVz
cyBFdGhlcm5ldA0KPiA+IERpc3BhdGNoDQo+ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gYXJt
IGlzIG9ubHkgZm9yIHRvcC1sZXZlbCBzdHVmZi4gQ2hvb3NlIGFwcHJvcHJpYXRlDQo+ID4gPiA+
ID4gc3Vic3lzdGVtLCBzb2MgYXMNCj4gPiA+ID4gPiBsYXN0IHJlc29ydC4NCj4gPiA+ID4gDQo+
ID4gPiA+IHRoZXNlIGNoaXBzIGFyZSB1c2VkIG9ubHkgZm9yIG5ldHdvcmtpbmcgc28gaXMgbmV0
IGZvbGRlciBmaW5lPw0KPiA+ID4gDQo+ID4gPiBTbyB0aGlzIGlzIHNvbWUgTU1JTyBhbmQgbm8g
YWN0dWFsIGRldmljZT8gVGhlbiByYXRoZXIgc29jLg0KPiA+IA0KPiA+IGFjaywgSSB3aWxsIG1v
dmUgdGhlbSB0aGVyZQ0KPiA+IA0KPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiA+IA0KPiA+ID4g
PiA+ID4gQEAgLTAsMCArMSw0NyBAQA0KPiA+ID4gPiA+ID4gKyMgU1BEWC1MaWNlbnNlLUlkZW50
aWZpZXI6IChHUEwtMi4wIE9SIEJTRC0yLUNsYXVzZSkNCj4gPiA+ID4gPiA+ICslWUFNTCAxLjIN
Cj4gPiA+ID4gPiA+ICstLS0NCj4gPiA+ID4gPiA+ICskaWQ6IA0KPiA+ID4gPiA+ID4gaHR0cHM6
Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHA6Ly9kZXZpY2V0cmVlLm9yZy9zY2hlbWFzL2FybS9t
ZWRpYXRlay9tZWRpYXRlayxtdDc5ODYtd28tYm9vdC55YW1sKl9fO0l3ISFDVFJOS0E5d01nMEFS
YnchendmUGJKcGNBYk9JT3ZvbFpNMTdVMzhjb1hwU0djVURtTFc1ZzhtNDc2MENyal9qcnVDYjQy
cnQ5bFhPcThzdkFFTSQNCj4gPiA+ID4gPiA+ICANCj4gPiA+ID4gPiA+ICskc2NoZW1hOiANCj4g
PiA+ID4gPiA+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwOi8vZGV2aWNldHJlZS5v
cmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbCpfXztJdyEhQ1RSTktBOXdNZzBBUmJ3IXp3ZlBiSnBj
QWJPSU92b2xaTTE3VTM4Y29YcFNHY1VEbUxXNWc4bTQ3NjBDcmpfanJ1Q2I0MnJ0OWxYT3BsMzdf
RkkkDQo+ID4gPiA+ID4gPiAgDQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiArdGl0bGU6DQo+
ID4gPiA+ID4gPiArICBNZWRpYVRlayBXaXJlbGVzcyBFdGhlcm5ldCBEaXNwYXRjaCBXTyBib290
IGNvbnRyb2xsZXINCj4gPiA+ID4gPiA+IGludGVyZmFjZSBmb3IgTVQ3OTg2DQo+ID4gPiA+ID4g
PiArDQo+ID4gPiA+ID4gPiArbWFpbnRhaW5lcnM6DQo+ID4gPiA+ID4gPiArICAtIExvcmVuem8g
QmlhbmNvbmkgPGxvcmVuem9Aa2VybmVsLm9yZz4NCj4gPiA+ID4gPiA+ICsgIC0gRmVsaXggRmll
dGthdSA8bmJkQG5iZC5uYW1lPg0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gK2Rlc2NyaXB0
aW9uOg0KPiA+ID4gPiA+ID4gKyAgVGhlIG1lZGlhdGVrIHdvLWJvb3QgcHJvdmlkZXMgYSBjb25m
aWd1cmF0aW9uIGludGVyZmFjZQ0KPiA+ID4gPiA+ID4gZm9yIFdFRCBXTw0KPiA+ID4gPiA+ID4g
KyAgYm9vdCBjb250cm9sbGVyIG9uIE1UNzk4NiBzb2MuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
QW5kIHdoYXQgaXMgIldFRCBXTyBib290IGNvbnRyb2xsZXI/DQo+ID4gPiA+IA0KPiA+ID4gPiBX
RUQgV08gaXMgYSBjaGlwIHVzZWQgZm9yIG5ldHdvcmtpbmcgcGFja2V0IHByb2Nlc3NpbmcNCj4g
PiA+ID4gb2ZmbG9hZGVkIHRvIHRoZSBTb2MNCj4gPiA+ID4gKGUuZy4gcGFja2V0IHJlb3JkZXJp
bmcpLiBXRUQgV08gYm9vdCBpcyB0aGUgbWVtb3J5IHVzZWQgdG8NCj4gPiA+ID4gc3RvcmUgc3Rh
cnQgYWRkcmVzcw0KPiA+ID4gPiBvZiB3byBmaXJtd2FyZS4gQW55d2F5IEkgd2lsbCBsZXQgU3Vq
dWFuIGNvbW1lbnQgb24gdGhpcy4NCj4gPiA+IA0KPiA+ID4gQSBiaXQgbW9yZSBzaG91bGQgYmUg
aW4gZGVzY3JpcHRpb24uDQo+ID4gDQo+ID4gSSB3aWxsIGxldCBTdWp1YW4gYWRkaW5nIG1vcmUg
ZGV0YWlscyAoc2luY2UgSSBkbyBub3QgaGF2ZSB0aGVtIDopKQ0KPiA+IA0KDQogDQpUaGUgbWN1
IG9mIHdvIGJvcnJvd3MgYSBwYXJ0IG9mIGRyYW0gdG8gc3RvcmUgYW5kIGJvb3QgaXRzIGZpcm13
YXJlLg0KdGhlIHJpZ2h0IGVudHJ5IHBvaW50IGFkZHJlc3Mgb2YgdGhlIGZpcm13YXJlIG11c3Qg
YmUgcGFzc2VkIHRvIHRoZSBtY3UNCnRvIGJvb3QgY29ycmVjdGx5LCBzbyB3ZSBuZWVkIHRvIHdy
aXRlIHRoZSBkcmFtIGFkZHJlc3Mgb2YgdGhlIGVudHJ5DQpwb2ludCB0byB0aGUgYm9vdCByZWdp
c3RlciwgSW4gYWRkaXRpb24sIHRoZXJlIGFyZSBzb21lIHJlZ2lzdGVycyB0aGF0DQpuZWVkIHRv
IGJlIHNldCB0byBjb250cm9sIHRoZSByZXNldCBvZiB0aGUgbWN1Lg0KDQo+ID4gPiANCj4gPiA+
ID4gDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiArcHJvcGVydGllczoN
Cj4gPiA+ID4gPiA+ICsgIGNvbXBhdGlibGU6DQo+ID4gPiA+ID4gPiArICAgIGl0ZW1zOg0KPiA+
ID4gPiA+ID4gKyAgICAgIC0gZW51bToNCj4gPiA+ID4gPiA+ICsgICAgICAgICAgLSBtZWRpYXRl
ayxtdDc5ODYtd28tYm9vdA0KPiA+ID4gPiA+ID4gKyAgICAgIC0gY29uc3Q6IHN5c2Nvbg0KPiA+
ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gKyAgcmVnOg0KPiA+ID4gPiA+ID4gKyAgICBtYXhJdGVt
czogMQ0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gKyAgaW50ZXJydXB0czoNCj4gPiA+ID4g
PiA+ICsgICAgbWF4SXRlbXM6IDENCj4gPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiA+ICtyZXF1aXJl
ZDoNCj4gPiA+ID4gPiA+ICsgIC0gY29tcGF0aWJsZQ0KPiA+ID4gPiA+ID4gKyAgLSByZWcNCj4g
PiA+ID4gPiA+ICsNCj4gPiA+ID4gPiA+ICthZGRpdGlvbmFsUHJvcGVydGllczogZmFsc2UNCj4g
PiA+ID4gPiA+ICsNCj4gPiA+ID4gPiA+ICtleGFtcGxlczoNCj4gPiA+ID4gPiA+ICsgIC0gfA0K
PiA+ID4gPiA+ID4gKyAgICBzb2Mgew0KPiA+ID4gPiA+ID4gKyAgICAgICNhZGRyZXNzLWNlbGxz
ID0gPDI+Ow0KPiA+ID4gPiA+ID4gKyAgICAgICNzaXplLWNlbGxzID0gPDI+Ow0KPiA+ID4gPiA+
ID4gKw0KPiA+ID4gPiA+ID4gKyAgICAgIHdvX2Jvb3Q6IHN5c2NvbkAxNTE5NDAwMCB7DQo+ID4g
PiA+ID4gPiArICAgICAgICBjb21wYXRpYmxlID0gIm1lZGlhdGVrLG10Nzk4Ni13by1ib290Iiwg
InN5c2NvbiI7DQo+ID4gPiA+ID4gPiArICAgICAgICByZWcgPSA8MCAweDE1MTk0MDAwIDAgMHgx
MDAwPjsNCj4gPiA+ID4gPiA+ICsgICAgICB9Ow0KPiA+ID4gPiA+ID4gKyAgICB9Ow0KPiA+ID4g
PiA+ID4gZGlmZiAtLWdpdA0KPiA+ID4gPiA+ID4gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUv
YmluZGluZ3MvYXJtL21lZGlhdGVrL21lZGlhdGVrLG0NCj4gPiA+ID4gPiA+IHQ3OTg2LXdvLWNj
aWYueWFtbA0KPiA+ID4gPiA+ID4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mv
YXJtL21lZGlhdGVrL21lZGlhdGVrLG0NCj4gPiA+ID4gPiA+IHQ3OTg2LXdvLWNjaWYueWFtbA0K
PiA+ID4gPiA+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiA+ID4gPiA+IGluZGV4IDAwMDAw
MDAwMDAwMC4uNjM1N2EyMDY1ODdhDQo+ID4gPiA+ID4gPiAtLS0gL2Rldi9udWxsDQo+ID4gPiA+
ID4gPiArKysNCj4gPiA+ID4gPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L2FybS9tZWRpYXRlay9tZWRpYXRlayxtDQo+ID4gPiA+ID4gPiB0Nzk4Ni13by1jY2lmLnlhbWwN
Cj4gPiA+ID4gPiA+IEBAIC0wLDAgKzEsNTAgQEANCj4gPiA+ID4gPiA+ICsjIFNQRFgtTGljZW5z
ZS1JZGVudGlmaWVyOiAoR1BMLTIuMCBPUiBCU0QtMi1DbGF1c2UpDQo+ID4gPiA+ID4gPiArJVlB
TUwgMS4yDQo+ID4gPiA+ID4gPiArLS0tDQo+ID4gPiA+ID4gPiArJGlkOiANCj4gPiA+ID4gPiA+
IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwOi8vZGV2aWNldHJlZS5vcmcvc2NoZW1h
cy9hcm0vbWVkaWF0ZWsvbWVkaWF0ZWssbXQ3OTg2LXdvLWNjaWYueWFtbCpfXztJdyEhQ1RSTktB
OXdNZzBBUmJ3IXp3ZlBiSnBjQWJPSU92b2xaTTE3VTM4Y29YcFNHY1VEbUxXNWc4bTQ3NjBDcmpf
anJ1Q2I0MnJ0OWxYTzNtZjcwVVkkDQo+ID4gPiA+ID4gPiAgDQo+ID4gPiA+ID4gPiArJHNjaGVt
YTogDQo+ID4gPiA+ID4gPiBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cDovL2Rldmlj
ZXRyZWUub3JnL21ldGEtc2NoZW1hcy9jb3JlLnlhbWwqX187SXchIUNUUk5LQTl3TWcwQVJidyF6
d2ZQYkpwY0FiT0lPdm9sWk0xN1UzOGNvWHBTR2NVRG1MVzVnOG00NzYwQ3JqX2pydUNiNDJydDls
WE9wbDM3X0ZJJA0KPiA+ID4gPiA+ID4gIA0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gK3Rp
dGxlOiBNZWRpYVRlayBXaXJlbGVzcyBFdGhlcm5ldCBEaXNwYXRjaCBXTyBjb250cm9sbGVyDQo+
ID4gPiA+ID4gPiBpbnRlcmZhY2UgZm9yIE1UNzk4Ng0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+
ID4gK21haW50YWluZXJzOg0KPiA+ID4gPiA+ID4gKyAgLSBMb3JlbnpvIEJpYW5jb25pIDxsb3Jl
bnpvQGtlcm5lbC5vcmc+DQo+ID4gPiA+ID4gPiArICAtIEZlbGl4IEZpZXRrYXUgPG5iZEBuYmQu
bmFtZT4NCj4gPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiA+ICtkZXNjcmlwdGlvbjoNCj4gPiA+ID4g
PiA+ICsgIFRoZSBtZWRpYXRlayB3by1jY2lmIHByb3ZpZGVzIGEgY29uZmlndXJhdGlvbiBpbnRl
cmZhY2UNCj4gPiA+ID4gPiA+IGZvciBXRUQgV08NCj4gPiA+ID4gPiA+ICsgIGNvbnRyb2xsZXIg
b24gTVQ3OTg2IHNvYy4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBBbGwgcHJldmlvdXMgY29tbWVu
dHMgYXBwbHkuDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiArcHJvcGVy
dGllczoNCj4gPiA+ID4gPiA+ICsgIGNvbXBhdGlibGU6DQo+ID4gPiA+ID4gPiArICAgIGl0ZW1z
Og0KPiA+ID4gPiA+ID4gKyAgICAgIC0gZW51bToNCj4gPiA+ID4gPiA+ICsgICAgICAgICAgLSBt
ZWRpYXRlayxtdDc5ODYtd28tY2NpZg0KPiA+ID4gPiA+ID4gKyAgICAgIC0gY29uc3Q6IHN5c2Nv
bg0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gKyAgcmVnOg0KPiA+ID4gPiA+ID4gKyAgICBt
YXhJdGVtczogMQ0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gKyAgaW50ZXJydXB0czoNCj4g
PiA+ID4gPiA+ICsgICAgbWF4SXRlbXM6IDENCj4gPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiA+ICty
ZXF1aXJlZDoNCj4gPiA+ID4gPiA+ICsgIC0gY29tcGF0aWJsZQ0KPiA+ID4gPiA+ID4gKyAgLSBy
ZWcNCj4gPiA+ID4gPiA+ICsgIC0gaW50ZXJydXB0cw0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+
ID4gK2FkZGl0aW9uYWxQcm9wZXJ0aWVzOiBmYWxzZQ0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+
ID4gK2V4YW1wbGVzOg0KPiA+ID4gPiA+ID4gKyAgLSB8DQo+ID4gPiA+ID4gPiArICAgICNpbmNs
dWRlIDxkdC1iaW5kaW5ncy9pbnRlcnJ1cHQtY29udHJvbGxlci9hcm0tZ2ljLmg+DQo+ID4gPiA+
ID4gPiArICAgICNpbmNsdWRlIDxkdC1iaW5kaW5ncy9pbnRlcnJ1cHQtY29udHJvbGxlci9pcnEu
aD4NCj4gPiA+ID4gPiA+ICsgICAgc29jIHsNCj4gPiA+ID4gPiA+ICsgICAgICAjYWRkcmVzcy1j
ZWxscyA9IDwyPjsNCj4gPiA+ID4gPiA+ICsgICAgICAjc2l6ZS1jZWxscyA9IDwyPjsNCj4gPiA+
ID4gPiA+ICsNCj4gPiA+ID4gPiA+ICsgICAgICB3b19jY2lmMDogc3lzY29uQDE1MWE1MDAwIHsN
Cj4gPiA+ID4gPiA+ICsgICAgICAgIGNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQ3OTg2LXdvLWNj
aWYiLCAic3lzY29uIjsNCj4gPiA+ID4gPiA+ICsgICAgICAgIHJlZyA9IDwwIDB4MTUxYTUwMDAg
MCAweDEwMDA+Ow0KPiA+ID4gPiA+ID4gKyAgICAgICAgaW50ZXJydXB0cyA9IDxHSUNfU1BJIDIw
NSBJUlFfVFlQRV9MRVZFTF9ISUdIPjsNCj4gPiA+ID4gPiA+ICsgICAgICB9Ow0KPiA+ID4gPiA+
ID4gKyAgICB9Ow0KPiA+ID4gPiA+ID4gZGlmZiAtLWdpdA0KPiA+ID4gPiA+ID4gYS9Eb2N1bWVu
dGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvYXJtL21lZGlhdGVrL21lZGlhdGVrLG0NCj4gPiA+
ID4gPiA+IHQ3OTg2LXdvLWRsbS55YW1sDQo+ID4gPiA+ID4gPiBiL0RvY3VtZW50YXRpb24vZGV2
aWNldHJlZS9iaW5kaW5ncy9hcm0vbWVkaWF0ZWsvbWVkaWF0ZWssbQ0KPiA+ID4gPiA+ID4gdDc5
ODYtd28tZGxtLnlhbWwNCj4gPiA+ID4gPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gPiA+
ID4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLmE0OTk5NTZkOWUwNw0KPiA+ID4gPiA+ID4gLS0tIC9k
ZXYvbnVsbA0KPiA+ID4gPiA+ID4gKysrDQo+ID4gPiA+ID4gPiBiL0RvY3VtZW50YXRpb24vZGV2
aWNldHJlZS9iaW5kaW5ncy9hcm0vbWVkaWF0ZWsvbWVkaWF0ZWssbQ0KPiA+ID4gPiA+ID4gdDc5
ODYtd28tZGxtLnlhbWwNCj4gPiA+ID4gPiA+IEBAIC0wLDAgKzEsNTAgQEANCj4gPiA+ID4gPiA+
ICsjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiAoR1BMLTIuMCBPUiBCU0QtMi1DbGF1c2UpDQo+
ID4gPiA+ID4gPiArJVlBTUwgMS4yDQo+ID4gPiA+ID4gPiArLS0tDQo+ID4gPiA+ID4gPiArJGlk
OiANCj4gPiA+ID4gPiA+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwOi8vZGV2aWNl
dHJlZS5vcmcvc2NoZW1hcy9hcm0vbWVkaWF0ZWsvbWVkaWF0ZWssbXQ3OTg2LXdvLWRsbS55YW1s
Kl9fO0l3ISFDVFJOS0E5d01nMEFSYnchendmUGJKcGNBYk9JT3ZvbFpNMTdVMzhjb1hwU0djVURt
TFc1ZzhtNDc2MENyal9qcnVDYjQycnQ5bFhPVlZkNThoQSQNCj4gPiA+ID4gPiA+ICANCj4gPiA+
ID4gPiA+ICskc2NoZW1hOiANCj4gPiA+ID4gPiA+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMv
X19odHRwOi8vZGV2aWNldHJlZS5vcmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbCpfXztJdyEhQ1RS
TktBOXdNZzBBUmJ3IXp3ZlBiSnBjQWJPSU92b2xaTTE3VTM4Y29YcFNHY1VEbUxXNWc4bTQ3NjBD
cmpfanJ1Q2I0MnJ0OWxYT3BsMzdfRkkkDQo+ID4gPiA+ID4gPiAgDQo+ID4gPiA+ID4gPiArDQo+
ID4gPiA+ID4gPiArdGl0bGU6IE1lZGlhVGVrIFdpcmVsZXNzIEV0aGVybmV0IERpc3BhdGNoIFdP
IGh3IHJ4IHJpbmcNCj4gPiA+ID4gPiA+IGludGVyZmFjZSBmb3IgTVQ3OTg2DQo+ID4gPiA+ID4g
PiArDQo+ID4gPiA+ID4gPiArbWFpbnRhaW5lcnM6DQo+ID4gPiA+ID4gPiArICAtIExvcmVuem8g
QmlhbmNvbmkgPGxvcmVuem9Aa2VybmVsLm9yZz4NCj4gPiA+ID4gPiA+ICsgIC0gRmVsaXggRmll
dGthdSA8bmJkQG5iZC5uYW1lPg0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gK2Rlc2NyaXB0
aW9uOg0KPiA+ID4gPiA+ID4gKyAgVGhlIG1lZGlhdGVrIHdvLWRsbSBwcm92aWRlcyBhIGNvbmZp
Z3VyYXRpb24gaW50ZXJmYWNlDQo+ID4gPiA+ID4gPiBmb3IgV0VEIFdPDQo+ID4gPiA+ID4gPiAr
ICByeCByaW5nIG9uIE1UNzk4NiBzb2MuDQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiArcHJv
cGVydGllczoNCj4gPiA+ID4gPiA+ICsgIGNvbXBhdGlibGU6DQo+ID4gPiA+ID4gPiArICAgIGNv
bnN0OiBtZWRpYXRlayxtdDc5ODYtd28tZGxtDQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiAr
ICByZWc6DQo+ID4gPiA+ID4gPiArICAgIG1heEl0ZW1zOiAxDQo+ID4gPiA+ID4gPiArDQo+ID4g
PiA+ID4gPiArICByZXNldHM6DQo+ID4gPiA+ID4gPiArICAgIG1heEl0ZW1zOiAxDQo+ID4gPiA+
ID4gPiArDQo+ID4gPiA+ID4gPiArICByZXNldC1uYW1lczoNCj4gPiA+ID4gPiA+ICsgICAgbWF4
SXRlbXM6IDENCj4gPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiA+ICtyZXF1aXJlZDoNCj4gPiA+ID4g
PiA+ICsgIC0gY29tcGF0aWJsZQ0KPiA+ID4gPiA+ID4gKyAgLSByZWcNCj4gPiA+ID4gPiA+ICsg
IC0gcmVzZXRzDQo+ID4gPiA+ID4gPiArICAtIHJlc2V0LW5hbWVzDQo+ID4gPiA+ID4gPiArDQo+
ID4gPiA+ID4gPiArYWRkaXRpb25hbFByb3BlcnRpZXM6IGZhbHNlDQo+ID4gPiA+ID4gPiArDQo+
ID4gPiA+ID4gPiArZXhhbXBsZXM6DQo+ID4gPiA+ID4gPiArICAtIHwNCj4gPiA+ID4gPiA+ICsg
ICAgc29jIHsNCj4gPiA+ID4gPiA+ICsgICAgICAjYWRkcmVzcy1jZWxscyA9IDwyPjsNCj4gPiA+
ID4gPiA+ICsgICAgICAjc2l6ZS1jZWxscyA9IDwyPjsNCj4gPiA+ID4gPiA+ICsNCj4gPiA+ID4g
PiA+ICsgICAgICB3b19kbG0wOiB3by1kbG1AMTUxZTgwMDAgew0KPiA+ID4gPiA+IA0KPiA+ID4g
PiA+IE5vZGUgbmFtZXMgc2hvdWxkIGJlIGdlbmVyaWMuDQo+ID4gPiA+ID4gDQpodHRwczovL3Vy
bGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9kZXZpY2V0cmVlLXNwZWNpZmljYXRpb24ucmVhZHRo
ZWRvY3MuaW8vZW4vbGF0ZXN0L2NoYXB0ZXIyLWRldmljZXRyZWUtYmFzaWNzLmh0bWwqZ2VuZXJp
Yy1uYW1lcy1yZWNvbW1lbmRhdGlvbl9fO0l3ISFDVFJOS0E5d01nMEFSYnchendmUGJKcGNBYk9J
T3ZvbFpNMTdVMzhjb1hwU0djVURtTFc1ZzhtNDc2MENyal9qcnVDYjQycnQ5bFhPZXZhNnh2NCQN
Cj4gPiA+ID4gPiAgDQo+ID4gPiA+IA0KPiA+ID4gPiBETE0gaXMgYSBjaGlwIHVzZWQgdG8gc3Rv
cmUgdGhlIGRhdGEgcnggcmluZyBvZiB3byBmaXJtd2FyZS4gSQ0KPiA+ID4gPiBkbyBub3QgaGF2
ZSBhDQo+ID4gPiA+IGJldHRlciBub2RlIG5hbWUgKG5hbWluZyBpcyBhbHdheXMgaGFyZCkuIENh
biB5b3UgcGxlYXNlDQo+ID4gPiA+IHN1Z2dlc3QgYSBiZXR0ZXIgbmFtZT8NCj4gPiA+IA0KPiA+
ID4gVGhlIHByb2JsZW0gaXMgdGhhdCB5b3UgYWRkZWQgdGhyZWUgbmV3IGRldmljZXMgd2hpY2gg
c2VlbSB0byBiZQ0KPiA+ID4gZm9yIHRoZQ0KPiA+ID4gc2FtZSBkZXZpY2UgLSBXRUQuIEl0IGxv
b2tzIGxpa2Ugc29tZSBoYWNreSB3YXkgb2YgYXZvaWQgcHJvcGVyDQo+ID4gPiBoYXJkd2FyZQ0K
PiA+ID4gZGVzY3JpcHRpb24gLSBsZXQncyBtb2RlbCBldmVyeXRoaW5nIGFzIE1NSU8gYW5kIHN5
c2NvbnMuLi4NCj4gPiANCj4gPiBpcyBpdCBmaW5lIHRvIHVzZSBzeXNjb24gYXMgbm9kZSBuYW1l
IGV2ZW4gaWYgd2UgZG8gbm90IGRlY2xhcmUgaXQNCj4gPiBpbiBjb21wYXRpYmxlDQo+ID4gc3Ry
aW5nIGZvciBkbG0/DQo+ID4gDQo+IA0KPiBObywgcmF0aGVyIG5vdC4gSXQncyBhIHNob3J0Y3V0
IGFuZCBpZiB1c2VkIHdpdGhvdXQgYWN0dWFsIHN5c2NvbiBpdA0KPiB3b3VsZCBiZSBjb25mdXNp
bmcuIFlvdSBjb3VsZCBzdGlsbCBjYWxsIGl0IHN5c3RlbS1jb250cm9sbGVyLA0KPiB0aG91Z2gu
DQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IEtyenlzenRvZg0KPiANCg==
