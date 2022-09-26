Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7235E9D23
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 11:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbiIZJPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 05:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbiIZJOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 05:14:51 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2124.outbound.protection.outlook.com [40.107.114.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2386AD121;
        Mon, 26 Sep 2022 02:14:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KB5JUiSVTc/mfEV4GWacJp6qkRbwAYhunOypJoxK89063kZ56d4Zdl+5WfNmMYVcl0scTITINoe+B13vOHIsCKULcpZUcgD6xxwQFRKOWQZelbCIKv0k2ldl+cVb38Ow53MRhO9121DlzBr4pIlRoK4r6lkIXdv+6UIuWcYUPx5hX4MK9VwjNxm+NPUcSezIYqe5W58B7HLwiLl7dqbQ9HrnbANPtLKCFgo1932qRSAzAm2h9qlTLW35dJ1USWdh0zxnryP/4070gHrUDi3/z/uatkmYYA2rSBA2COrcIzwCZv4dF1sFZO7LipxVZ9VUIKJHCQm3WwDpBnzl/NB/lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/45vLiuHMtwzsqIb3LFNAvIBOKnRr5g2nyvb+900zag=;
 b=J+qvf3UoBmhmshfkJgvCWdjZF/2BpvMrWvMpAgRMQPTPY92Cd9+RW2JF8ka5YfsngoxFQNf8Bz4+KV6yEsZi0cg7AhDs5Ehptg0Zl7kfru5iLVsBl1AInmuDyHQ/RuEs+G7MOYEQFjqeII2qzZIM+n/MpWwjoxlXk40p/WOGKrhkmCfk6SMpFAiej1dTOLnuCEOxUbBdSMbwGKK3o4svBfFxpW0z02t5UQdClt4i36Rt56dTf2Bc9JInKSTQAQokWTLb7E1MSdHrTxpWIEsUjkQaTdJHEti8FbBtD+31Mc9/aKSI6RyIlZaKYAypik67xwj70l27RduZ2xhtYSdXoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/45vLiuHMtwzsqIb3LFNAvIBOKnRr5g2nyvb+900zag=;
 b=L2OzxyXPcfqWbTJz/SZqOWa4tHnxe5vr6qCUjvmB5yy+xziG6B8MT+hmuvT8z6LKgZYRUSbcMFlpNmjIfpk1CGquCyPPWkL6bun+zd/8AQ/tiHQ2ScLiqH7QgCp07nMkulauqgEnFd40YwV+ynJoOsSRhqv/nKxarumskurDNFU=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB7777.jpnprd01.prod.outlook.com
 (2603:1096:604:17c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 09:14:43 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 09:14:43 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2 4/8] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Thread-Topic: [PATCH v2 4/8] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Thread-Index: AQHYzZbyqNqCKbNV30+Ykc0QZw/71q3rESYAgAYuSTCAAA3MAIAAJx+g
Date:   Mon, 26 Sep 2022 09:14:43 +0000
Message-ID: <TYBPR01MB5341B5F49362BCCF3C168D11D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921084745.3355107-5-yoshihiro.shimoda.uh@renesas.com>
 <1aebd827-3ff4-8d13-ca85-acf4d3a82592@linaro.org>
 <TYBPR01MB5341514CD57AB080454749F2D8529@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <d31dc406-3ef2-0625-8f5e-ff6731457427@linaro.org>
In-Reply-To: <d31dc406-3ef2-0625-8f5e-ff6731457427@linaro.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB7777:EE_
x-ms-office365-filtering-correlation-id: 7950c379-85cb-4b33-eed7-08da9f9f8ca6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4E6IDPaZk4vDdDZFSVNJzm8bWSJohNay8U1OAs8louQjZpC5+uoxCkF6Xa7b74frXELZ9hNC1iCuIbIhRnoo1fsEyMELgFyu//m0jAQKmLm8vyZD3k3OLZMKVDITODbrInga7mneVm1xdeyyYMOsfWOgYB83PcMCRZdisO883si/uZnYeC44m32CEznSxkBIHE7b6sjz2GvkfIUmKxdWBisDzenzU65Fl42QmEL5Eo1odBwvGlumUhrCWYmyK6aKibElgoEnTYfQvnaZVJy3Qe23qhZyF7dz6p2C0pKMEXUiqN68TJaVgDZeNxt3/v3xDcfFoUzHiAaNkYFzQpMo7s17/xbtd1lmWo7RV9Ru9CrC9sc9HKG9BXz3zTLc5q+9GWU2iCpSYtGkig3FwV52rL/uLcjWBE3pV8UM9WBNxVMjGTHbDXAKBfsJSApUa/5j2xzXCe/GdZOtifdvnyB6qd7n2oeu7eFlmXamb/s0gnUDRhvzw9Xxtv0n3alWkPZL5Wbp2V4zXl/GL6YK7uCrBLpaNID2Z/rPgx8CxiLkIncdvUuE+wWLPe2/fbAeBilAgSBmvQWJlkm9VjsmiIs2eqnhSCI5Lw70OKV0R7Rwaas+qvfzyujCPwtVoCB5nwKIKEoN3dZHUaAX58IIjk+qBL1oNd+LPhvN7g4VqY929Hd7gn36nNZSh3Cyg812HUPvgmdAS5HPPlBi6x/Mqw4qnvCyfEwwxWXsBp4WikLQOFJn7/uXfA4AtuJ8HwPHjwx/MS9JueGkDw9xEyiAUs4dBA2w3R037tUGXyrfhSj+Ubg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(451199015)(33656002)(55016003)(71200400001)(41300700001)(7696005)(9686003)(186003)(83380400001)(38070700005)(52536014)(921005)(5660300002)(8936002)(7416002)(2906002)(86362001)(38100700002)(110136005)(54906003)(66476007)(122000001)(64756008)(316002)(8676002)(66446008)(66556008)(478600001)(53546011)(76116006)(6506007)(66946007)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SU5LeHpHVmk1OWUrZWpWbURuZDZFRDI5amNjUFpFSHJQenhQbjJwNHJ2cEdE?=
 =?utf-8?B?ejhnc0ZJMVQ2MHhqTEIvVVdseTd3UTBQMXlicnZnVHUyeGJvR2daZm4wOVQw?=
 =?utf-8?B?UEFjbHdwSjJGVjZZUERvQ1IxbjJyK2hpRHV2NU1aMjU5VnQ4SkYzb1hybHdv?=
 =?utf-8?B?MFA1cGpKOWEwSWJ4N1liYUNJbDRzTSt4bTNUVVEreFhLL25ETW1wWjFockts?=
 =?utf-8?B?SlJpZTdDYmc1THRpSThlV3lRaFByem4ySzdnNlZDUXRKZytNc2JYclBUeUVG?=
 =?utf-8?B?ZkY2eitBakhkbVl4N01VUWw5ajdBYmdzSU1kUjZjcG4ySlNkUFhlRGtENFkv?=
 =?utf-8?B?RFVUNnhpa2RCVG9lM3h4SlJ4VGx0cmMzeXJHYVFSby9Gc2dzcERrQzBuWjM0?=
 =?utf-8?B?NDlsRlc2S0JwMzZoZTE1RlhFUXNlZDMvRXFabmc3dGc0LzYzOXVUUklOK1ZU?=
 =?utf-8?B?cWJpcjRUd3JLT0tYOEhuR3U0YWZQQXJxOGorQWwrY0dEU1JWWDZrUlU5Mk91?=
 =?utf-8?B?Y3VaaVZkeDhnaEdIL21XUGhTWVRaQll6VnRpYyt4bGpjYmxlcnZyUGQweXlJ?=
 =?utf-8?B?RnZWWElES3NRSnhaY3RtTEVnMmtCRHRJZWpNNCs1VjJnRm0vdW9wcU54RGh5?=
 =?utf-8?B?S216aG9uOVdwOTBSbktxVzFwb2pXK001d2VyeDVnTE9Dc3I4WitKaWdxZVht?=
 =?utf-8?B?UG5Jem1lekJQU2gwd3g3YXRuV1QwSmpuWFc3TThTY2I3RmhDdFk5RFFLcnBU?=
 =?utf-8?B?bzJsUE9VZWROOFlJdFhicm1ORlQrQi9RU2lvekVIQlY1VjUyalhnZk9xUVI4?=
 =?utf-8?B?UXJuS3V4bFFGbEpZMjRhdkdpcDNjWjdrclZqZlFVMkdGY0ZvM3VJcUhhNFhr?=
 =?utf-8?B?S1B3bzM2bGI5TGtER25jZklLNnAxOEpyYmNXTlpXY0VYSExtUTZRVjFyZkI5?=
 =?utf-8?B?Y0lPUjYxVFV2cHhQYnd2ZTFMa1V0cDBoak53Z2VQK1AzV0NtbFdPaHdQTnQ4?=
 =?utf-8?B?NTBJTHBab0ttYlF4alpNaWhPVmdHTnhkTzNmZlJoc29GRFd1eEdQMXBnZEVp?=
 =?utf-8?B?Nk9TTS9JVzhwWkgyNmV1azU4MjAyT0pCRlhjTnB5VFNERXZjeEduRjBzdmt1?=
 =?utf-8?B?NTVaTXRJYmVCcXBKTTdsTTl4SUcybXFaSEFjQjM1bG1RSERwOUF3M2xiS1Nv?=
 =?utf-8?B?enpjWk5rR2o3NXMvdGFsTUl1em9RbVpSd05hdEVMVEI0V3BLWEN4N0UxazRz?=
 =?utf-8?B?dUhVV204MHRQQUFlSjZaSUxTcFRkdkNPajNrN1E5dnY3cmhsL2VqTFo1eWs4?=
 =?utf-8?B?VTNOUTBLcVdWS0JaVjJza2xPaDk3SFRWY2RTVWJkbUtEcFErSEN1ZVpGWlFL?=
 =?utf-8?B?OE9yZkV1ZWxqNWdUbHlRd0x5aXNhZ1grSDd0dnloQjNIU3RMMVROZGgrT2k2?=
 =?utf-8?B?b2FvRitFOUhVcGZXNU5jYlhCMTdGVW1HQ0JnYUs5NUxwSjhVWmdSMmZCSUZK?=
 =?utf-8?B?WDVLVzlNNWRVZkRsZWJnV0l0QmcrZEtDWVU2U3U0L2ZIckNsTXlHdzNvS3gx?=
 =?utf-8?B?RmRrMDRFS2dVYnoyV2tONjZ5dHRZdTNwSHJtalB0Z2hQcGVCbkFtaHpxZitL?=
 =?utf-8?B?ajkybkdQdjNOZStody8rUjdVTG90ZkJJbS9heXEydUgxY1VndStuczMxeDg3?=
 =?utf-8?B?MGYwUHFtN2cvTjMycFdGYUsxdkkvdDlkQzFZbXVDMGpFNjBRaTVrNTQxTFBq?=
 =?utf-8?B?L2tCdXh6eE5kUGdpOCsrbDdoTHVCd2RkQmRXQ0VycUFTb0I0VWw4RTdKd2Mw?=
 =?utf-8?B?VFF5UXJ4b2FOUjMveEpBWERQeGVPQ0ZiMHdpOGNGZVB3eHcxMkhnbnVoUnBr?=
 =?utf-8?B?OWp1YkZrTEI3RXNNUU92NTFmWGdzRXVhQzlwSjZNN1l6bU80dDFpSm5qRXkw?=
 =?utf-8?B?Z3B3SWtjRmZ3UyszTXNnUG9lVkN6SDkyRzZYMnpsSEQwL0tTb0k4R1lzWlVZ?=
 =?utf-8?B?UDFkSWVrcUlCeUF1bkVHYmdBOFFlWjlXSC9uTlVNKzhiYmpzTnJ0dkRRRE9S?=
 =?utf-8?B?OEpCb0VNaWswbW5LNW54WnRJcFl6WGlnMVppam1kWHphMkpjdUQ4cXIwMWlF?=
 =?utf-8?B?N1pyT3RYcWdxWmp1Tk9iWW04UzlhTzNLeVpnOXhsbXFSV25EWTAvcGdCVlYx?=
 =?utf-8?B?ZFRha3M5ei9ZK2FyeEtlZlNISXgzTW1LMTBKdDFxRG4zejQxMjM4d1ZEM1dn?=
 =?utf-8?B?M2VWekdPNVZJQ041OGc2SEppVHd3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7950c379-85cb-4b33-eed7-08da9f9f8ca6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 09:14:43.4088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Y+GFqwpoSDEztp73mZW5ExOylfVI93tc4dpKaMSAFp4AEs1KtqHU2fjQ6M7e2PzmvUl9L+KPKJw9mYffOoNY85tNztaRwJFtltvjVmRyJ0qRPThQ95I5SwLDY1prH/a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB7777
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBLcnp5c3p0b2YgS296bG93c2tpLCBTZW50OiBNb25kYXksIFNlcHRlbWJlciAyNiwg
MjAyMiAzOjUwIFBNDQo+IA0KPiBPbiAyNi8wOS8yMDIyIDA4OjEwLCBZb3NoaWhpcm8gU2hpbW9k
YSB3cm90ZToNCj4gDQo+ID4gSSdsbCBhZGQgYSBibGFuayBsaW5lIGhlcmUuDQo+ID4NCj4gPj4+
ICsgICAgICAnI3NpemUtY2VsbHMnOg0KPiA+Pj4gKyAgICAgICAgY29uc3Q6IDANCj4gPj4+ICsN
Cj4gPj4+ICsgICAgYWRkaXRpb25hbFByb3BlcnRpZXM6IGZhbHNlDQo+ID4+DQo+ID4+IERvbid0
IHB1dCBpdCBiZXR3ZWVuIHByb3BlcnRpZXMuIEZvciBuZXN0ZWQgb2JqZWN0IHVzdWFsbHkgdGhp
cyBpcw0KPiA+PiBiZWZvcmUgcHJvcGVydGllczoNCj4gPg0KPiA+IEknbGwgZHJvcCBpdC4NCj4g
DQo+IERvbid0IGRyb3AsIGJ1dCBpbnN0ZWFkIHB1dCBpdCBiZWZvcmUgInByb3BlcnRpZXMiIGZv
ciB0aGlzIG5lc3RlZCBvYmplY3QuDQoNCk9oLCBJIGdvdCBpdC4gVGhhbmtzIQ0KSSdsbCBwdXQg
dGhpcyBiZWZvcmUgInByb3BlcnRpZXM6IiBsaWtlIGJlbG93Og0KLS0tLS0NCiAgZXRoZXJuZXQt
cG9ydHM6DQogICAgdHlwZTogb2JqZWN0DQoNCiAgICBhZGRpdGlvbmFsUHJvcGVydGllczogZmFs
c2UNCg0KICAgIHByb3BlcnRpZXM6DQogICAgICAnI2FkZHJlc3MtY2VsbHMnOg0KICAgICAgICBk
ZXNjcmlwdGlvbjogUG9ydCBudW1iZXIgb2YgRVRIQSAoVFNOQSkuDQogICAgICAgIGNvbnN0OiAx
DQoNCiAgICAgICcjc2l6ZS1jZWxscyc6DQogICAgICAgIGNvbnN0OiAwDQotLS0tLQ0KDQpCZXN0
IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hpbW9kYQ0KDQo+ID4NCj4gPj4+ICsNCj4gPj4+ICsgICAg
cGF0dGVyblByb3BlcnRpZXM6DQo+ID4+PiArICAgICAgIl5wb3J0QFswLTlhLWZdKyQiOg0KPiA+
Pj4gKyAgICAgICAgdHlwZTogb2JqZWN0DQo+ID4+PiArDQo+ID4+DQo+ID4+IFNraXAgYmxhbmsg
bGluZS4NCj4gPg0KPiA+IEkgZ290IGl0Lg0KPiA+DQo+ID4+PiArICAgICAgICAkcmVmOiAiL3Nj
aGVtYXMvbmV0L2V0aGVybmV0LWNvbnRyb2xsZXIueWFtbCMiDQo+ID4+DQo+ID4+IE5vIG5lZWQg
Zm9yIHF1b3Rlcy4NCj4gPg0KPiA+IEknbGwgZHJvcCB0aGUgcXVvdGVzLg0KPiA+DQo+ID4+PiAr
ICAgICAgICB1bmV2YWx1YXRlZFByb3BlcnRpZXM6IGZhbHNlDQo+ID4+PiArDQo+ID4+PiArICAg
ICAgICBwcm9wZXJ0aWVzOg0KPiA+Pj4gKyAgICAgICAgICByZWc6DQo+ID4+PiArICAgICAgICAg
ICAgZGVzY3JpcHRpb246DQo+ID4+PiArICAgICAgICAgICAgICBQb3J0IG51bWJlciBvZiBFVEhB
IChUU05BKS4NCj4gPj4+ICsNCj4gPj4+ICsgICAgICAgICAgcGh5LWhhbmRsZToNCj4gPj4+ICsg
ICAgICAgICAgICBkZXNjcmlwdGlvbjoNCj4gPj4+ICsgICAgICAgICAgICAgIFBoYW5kbGUgb2Yg
YW4gRXRoZXJuZXQgUEhZLg0KPiA+Pg0KPiA+PiBXaHkgZG8geW91IG5lZWQgdG8gbWVudGlvbiB0
aGlzIHByb3BlcnR5PyBJc24ndCBpdCBjb21pbmcgZnJvbQ0KPiA+PiBldGhlcm5ldC1jb250cm9s
bGVyLnlhbWw/DQo+ID4NCj4gPiBJbmRlZWQuIEknbGwgZHJvcCB0aGUgZGVzY3JpcHRpb24uDQo+
ID4NCj4gPj4+ICsNCj4gPj4+ICsgICAgICAgICAgcGh5LW1vZGU6DQo+ID4+PiArICAgICAgICAg
ICAgZGVzY3JpcHRpb246DQo+ID4+PiArICAgICAgICAgICAgICBUaGlzIHNwZWNpZmllcyB0aGUg
aW50ZXJmYWNlIHVzZWQgYnkgdGhlIEV0aGVybmV0IFBIWS4NCj4gPj4+ICsgICAgICAgICAgICBl
bnVtOg0KPiA+Pj4gKyAgICAgICAgICAgICAgLSBtaWkNCj4gPj4+ICsgICAgICAgICAgICAgIC0g
c2dtaWkNCj4gPj4+ICsgICAgICAgICAgICAgIC0gdXN4Z21paQ0KPiA+Pj4gKw0KPiA+Pj4gKyAg
ICAgICAgICBwaHlzOg0KPiA+Pj4gKyAgICAgICAgICAgIG1heEl0ZW1zOiAxDQo+ID4+PiArICAg
ICAgICAgICAgZGVzY3JpcHRpb246DQo+ID4+PiArICAgICAgICAgICAgICBQaGFuZGxlIG9mIGFu
IEV0aGVybmV0IFNFUkRFUy4NCj4gPj4NCj4gPj4gVGhpcyBpcyBnZXR0aW5nIGNvbmZ1c2luZy4g
WW91IGhhdmUgbm93Og0KPiA+PiAtIHBoeS1oYW5kbGUNCj4gPj4gLSBwaHkNCj4gPj4gLSBwaHkt
ZGV2aWNlDQo+ID4+IC0gcGh5cw0KPiA+PiBpbiBvbmUgc2NoZW1hLi4uIGFsdGhvdWdoIGxhbjk2
Nnggc2VyZGVzIHNlZW1zIHRvIGRvIHRoZSBzYW1lLiA6Lw0KPiA+DQo+ID4gWWVzLi4uIEkgZm91
bmQgdGhlIGZvbGxvd2luZyBkb2N1bWVudHMgaGF2ZSAicGh5IiBhbmQgInBoeS1oYW5kbGUiIGJ5
IHVzaW5nDQo+ID4gZ2l0IGdyZXAgLWwgLXcgInBoeXMiIGBnaXQgZ3JlcCAtbCBwaHktaGFuZGxl
IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9gOg0KPiA+IERvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvY2RucyxtYWNiLnlhbWwNCj4gPiBEb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Nwc3cudHh0DQo+ID4gRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC9taWNyb2NoaXAsbGFuOTY2eC1zd2l0Y2gueWFtbA0KPiA+IERv
Y3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWljcm9jaGlwLHNwYXJ4NS1zd2l0
Y2gueWFtbA0KPiA+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvdGksY3Bz
dy1zd2l0Y2gueWFtbA0KPiA+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQv
dGksazMtYW02NTQtY3Bzdy1udXNzLnlhbWwNCj4gPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUv
YmluZGluZ3MvcGh5L3BoeS1iaW5kaW5ncy50eHQNCj4gPg0KPiA+IEFuZCBJJ20gaW50ZXJlc3Rp
bmcgdGhhdCB0aGUgcGh5LWJpbmRpbmdzLnR4dCBzYWlkIHRoZSBmb2xsb3dpbmc6DQo+ID4gLS0t
LS0NCj4gPiBwaHlzIDogdGhlIHBoYW5kbGUgZm9yIHRoZSBQSFkgZGV2aWNlICh1c2VkIGJ5IHRo
ZSBQSFkgc3Vic3lzdGVtOyBub3QgdG8gYmUNCj4gPiAgICAgICAgY29uZnVzZWQgd2l0aCB0aGUg
RXRoZXJuZXQgc3BlY2lmaWMgJ3BoeScgYW5kICdwaHktaGFuZGxlJyBwcm9wZXJ0aWVzLA0KPiA+
ICAgICAgICBzZWUgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9ldGhlcm5l
dC50eHQgZm9yIHRoZXNlKQ0KPiA+IC0tLS0tDQo+IA0KPiBJbmRlZWQsIHNlZW1zIG9rLg0KPiAN
Cj4gPg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBLcnp5c3p0b2YNCg0K
